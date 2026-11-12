Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F3AF606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DCsQmUyQ
Received: by kanga.kvack.org (Postfix)
	id A4D226B05CB; Thu, 12 Nov 2026 04:06:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A24A46B05CC; Thu, 12 Nov 2026 04:06:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93B3D6B05CD; Thu, 12 Nov 2026 04:06:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F29C6B05CB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:06:03 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E1A440483
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:05:42 +0000 (UTC)
X-FDA: 85425884124.22.F9C74C9
Received: from mta0.migadu.com (out-36.mta0.migadu.com [91.218.175.36])
	by imf16.hostedemail.com (Postfix) with ESMTP id 285B0180009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:05:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DCsQmUyQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qiliang.yuan@linux.dev designates 91.218.175.36 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794474340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zdwRUxVnTZpYGma3zR8iiLeIgpobDvdrNh1nRqXAWMA=;
	b=oRdiTd6FJMbfuhMzJAgxYdicAxz7bcZjz8o9rooOjyG/KTeTnzUL4KiBNj0ysnSEJABj9G
	LHbztrJhnVkKmAdIOkapey4sqIMN4gsnaIEqtlZS7RudMmXjqnim6Na2D5X0CBTTOmzLrL
	uNic3cyZY848bXM04FifShtAPiFMCbg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794474340;
	b=8b6ot1d4HV8QsPA00WP1NvBByNeh3FKclxoacXXkJWrwoEp2lLO4PDo9XhXnxPoa9ZdZuB
	zxJIY42BLa5cTKDluLLF7TDc6al/6HQjpjhMDp4NqO0jnB0rVJImMEJuFaa9ljSvk47xhW
	+2i6FqFOJl9LRfpkdxZEn2T0U3n1N1w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DCsQmUyQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qiliang.yuan@linux.dev designates 91.218.175.36 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KIBx6J3ONlwSdrSfqJem9k0si8vhTNYH9l6d114wjKA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794474338; v=1; x=1795079138;
 b=DCsQmUyQ79v5wBYgkdsZd8ebSpT4VClpeRJd66dX/56CNzO3uF0SfW4Ta/e/y66fZWzLpKDm
 O10ZENMP0VPHQaI/l+Yiju9S06dT8WsH8EtITnzH3wo6+7Uv5Hz6r0rcGSI/SRjCho0G9cfIhwB
 cVrvXWjk4uCw+4q6jva6EuOM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 60eafffd12fdfb43;
	Thu, 12 Nov 2026 09:05:33 +0000
X-Mizu-Trace-ID: 60eafffd12fdfb43
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Thu, 12 Nov 2026 04:05:12 -0500
Subject: [PATCH v3] mm/shmem: remove truncated folios from the page cache
 in batches
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-bug-mm-shmem-undo-batch-v3-1-212db8c24058@linux.dev>
X-B4-Tracking: v=1; b=H4sIAEiB9WoC/4XNTQ7CIBCG4as0rB0D9MfWlfcwLigMhUSKgZZom
 t5d2o1ujMv3S+aZhUQMFiM5FwsJmGy0fsxRHgoijRgHBKtyE055wyjvoJ8HcA6icehgHpWHXkz
 SgEJKmepkoxmSfP0IqO1zl6+33MbGyYfX/iixbf1vJgYM6q4vK864xlN7GZyw96P0jmxm4h+H0
 fq3w7MjsNZtJ1HRqvp21nV9A4XaRgoGAQAA
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0
X-Stat-Signature: 3tb7r1s5qxdbzzf5umu67thtap7jj9ga
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 285B0180009
X-HE-Tag: 1794474339-511466
X-HE-Meta: U2FsdGVkX1/Wi1Z5GarT65pXtmFGeAq3z8l8C25e/1vgIDMVV0nF14SftuvXSu47Vc14Ewyh8FeDJ1DHmei8uS8B+ikiouCrFrZN+XgvDE2fCWAwmvYFmtP0NbjYq+xmIdUoXT4rLpZUQ7hseVLF6ZYlqrcNwAzISAa9iJJidKbRzvGthJl9JakVpBRkVRcOgOkRX0BYUVXLyUijyZbiPcvwVQNFZHVEzkD+57mH7BH7wmY5mwfRpZGHns8XOevF9uB/8vWPi3gVH3MfdSo7aJlx6rEMdGrqB4pnUnIWXyYDhj0QaL44wGAGXVma/TN9dA0Ky/VSojZUBvpO68Ti4BLLfClUPT746G5otEwTMpthOnWRPdkgK6OEkvsWd0zXG/jFeudjVevte7jQylOvy4LHT9HqQ4vQCcWsbdQ1qJyiXOTbTpzkgadr5NKGEFbPUqbRhSnGmpKE8Zuj9MC4WOMOk7GLztXBASZe8UGk7GlYiOZZYBQT1xi0ORjbIBEK9Ah3UiJdSYj7It0YMTFdFtPJM17FitUMuq9DmzgiXMXy2E6fZm5++Amw7B0SLCt0guvIYUns8zT9l7TJekZWszvtVQylGrANOcTYuzs+RlheBvgZz5pqMxW6UtqjO8tXao6PzbaldNImVikJO0tI+4Y0U3J4x1Io/3Fi5WDThDG0+PxkmqwY5uFTCFzzOLmFkWm1f1iWDAnFp/aHuZ0vOem+ccfIZ81bsrMeF+A0vQz0R/HuiVnm0OUhUhucVWgqZsLsRijClj3kVcUNzoqeo7cYXnrYC+7nasUhHeLygHoxUl5tczPKHuL86HmcmAbWPlY22x7PkSddKXC/gyVrr47SZACDVejruapQDzvvO1pvfsUpyP/equf8lfcuv+HVuY6vlT4MMhyQZx80yN2JFLQ+jz3xXD88CBo116gJEHoUmUgrrcHVYFsDiOFmOtpIT4a+aslTEtyw9VusPHA
 0Bg4xOHt
 1TNXKucIGXSzfY0Hl0ZX9D2/EXfMyUsyZte4/5UtcPrL7lxXaW24NAOVQ9k4rO5DGR5ohfCegp4D5emtNXwlGAzTgdT3D+b6AGVEHXbbuuRP+XSsj/+Ho50Pv4kk0GnfNtDszC2DJlsmxQwkW/5acbi3vG12106r+4FdcxqPWFtq0vDuQ6J/KmChBpXj93WBqbt/8bNE8kDfxwuNWXkS7VUN52tplEnXHHApGFSBEil2PW1R3r+xyteRTnaKeUZjDSAszAZ7tjJbVUdXgbS6TofIlwRPwUIlwEDow
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

truncate_inode_pages_range() takes the folios it finds out of the page
cache with delete_from_page_cache_batch(), which takes the inode's
i_lock and the i_pages lock once for each batch of up to
FOLIO_BATCH_SIZE folios.

shmem_undo_range() calls truncate_inode_folio() on each folio instead,
so filemap_remove_folio() takes and drops both locks once per folio.
Truncating, punching or freeing a tmpfs file or memfd made of small
folios, such as a large /dev/shm segment, pays for that on every page.

Clean each folio up as truncate_inode_folio() does and, once the swap
entries are gone, pass the batch to delete_from_page_cache_batch(),
which needs truncate_cleanup_folio() outside mm/truncate.c. Undoing a
failed fallocate() only removes the folios that are not uptodate, so
keep removing those one at a time.

Dropping an 8 GiB file of 4K folios in a 32 vCPU VM takes (median of
five runs, averaged over two boots of each kernel):

  operation           before (ms)  after (ms)  change
  ftruncate() to 0           1144         901    -21%
  hole punch                 1148         906    -21%
  close() of a memfd         1139         912    -20%
  unlink()                   1142         914    -20%

Files of PMD-sized folios take 18-31 ms with or without this change.

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
V2 -> V3:
- Delete the folios from fbatch directly instead of collecting them in
  a second folio_batch, which pushed the shmem_undo_range() stack frame
  past 1024 bytes on mips with clang (reported by the kernel test robot)
- Rebase onto bf87d3fe8b35 in core.git shmem-7.5.misc and update the
  numbers from a new run
- Drop the Reviewed-by tags from Jan and Baolin, since the loop changed

V1 -> V2:
- Unlock the folios after folio_batch_remove_exceptionals(), as Jan
  suggested
- Rebase onto v7.4-rc1-132-g05441d697f7f and update the numbers from a
  new run

v2: https://lore.kernel.org/r/20261105-bug-mm-shmem-undo-batch-v2-1-ae5f89ced044@gmail.com
v1: https://lore.kernel.org/r/20261029-bug-mm-shmem-undo-batch-v1-1-59b34212fe78@gmail.com

To see it, fill and remove a large /dev/shm file:

  fallocate -l 8G /dev/shm/f && time rm /dev/shm/f
---
 mm/internal.h | 1 +
 mm/shmem.c    | 9 +++++++--
 mm/truncate.c | 2 +-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 566cbd2dce485..abe64e49a4170 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -628,6 +628,7 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
 unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
+void truncate_cleanup_folio(struct folio *folio);
 int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
 bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 		loff_t lend, pgoff_t *pstart, pgoff_t *pend);
diff --git a/mm/shmem.c b/mm/shmem.c
index ce92e74baeb75..5bcbdd6078a73 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1363,11 +1363,16 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 				continue;
 			}
 
-			if (!unfalloc || !folio_test_uptodate(folio))
+			if (!unfalloc)
+				truncate_cleanup_folio(folio);
+			else if (!folio_test_uptodate(folio))
 				truncate_inode_folio(mapping, folio);
-			folio_unlock(folio);
 		}
 		folio_batch_remove_exceptionals(&fbatch);
+		if (!unfalloc)
+			delete_from_page_cache_batch(mapping, &fbatch);
+		for (i = 0; i < folio_batch_count(&fbatch); i++)
+			folio_unlock(fbatch.folios[i]);
 		folio_batch_release(&fbatch);
 		cond_resched_tasks_rcu_qs();
 	}
diff --git a/mm/truncate.c b/mm/truncate.c
index 733d2713a875a..c6bf4aa0b91e8 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -151,7 +151,7 @@ EXPORT_SYMBOL_GPL(folio_invalidate);
  * its lock, b) when a concurrent invalidate_mapping_pages got there first and
  * c) when tmpfs swizzles a page between a tmpfs inode and swapper_space.
  */
-static void truncate_cleanup_folio(struct folio *folio)
+void truncate_cleanup_folio(struct folio *folio)
 {
 	if (folio_mapped(folio))
 		unmap_mapping_folio(folio);

---
base-commit: bf87d3fe8b35087c2c043642e76e9f100d61328b
change-id: 20261029-bug-mm-shmem-undo-batch-de001d9c6f1e

Best regards,
-- 
Qiliang Yuan <qiliang.yuan@linux.dev>


