Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87FE0606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FwjDP5r4
Received: by kanga.kvack.org (Postfix)
	id A98D96B05B3; Thu,  5 Nov 2026 07:32:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6FFA6B05B7; Thu,  5 Nov 2026 07:32:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986546B05B9; Thu,  5 Nov 2026 07:32:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 633636B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:32:31 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 28AB61A0A1B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:32:25 +0000 (UTC)
X-FDA: 85401003450.27.F67BF0C
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6DC60C0005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:32:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FwjDP5r4;
	spf=pass (imf22.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793881943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bKGuzAUaHML6wkJsYB/5ryGtpKz03dwMg3XqSc0JR10=;
	b=oQKfBdsRL2GGk6F9AKp411jP62xgZmjLolZ0LOdes4S/XZJZe+hfcqwX3DgtrgCUcwJPNd
	3HDps4lJjIJElLJrLcyYjvylhgN2bV60/830E6L+Ll4OOzPAeiDDOvkywMCZhcXeDjTBd7
	0LgNEjM/3ls3BbNpHwuBeexO/n8IgdI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793881943;
	b=lNVWI/2LnM4AIP7jY0iSIEn3Hxjv3qyohr5gRmZzqvE+LUsareQlGob2pDUF7A6Lsjtcd5
	9j0STkIoX2OS0JOC61edGhrNpfDkvhj7OjEZJfD7dTPj2ulOdnFJddMnuetqaMIK7hhkN+
	wpOvWDg9ltPzhwdv3Z2SVtnv4tvHACk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FwjDP5r4;
	spf=pass (imf22.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-36d6765756fso2063853eec.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 04:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793881942; x=1794486742; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bKGuzAUaHML6wkJsYB/5ryGtpKz03dwMg3XqSc0JR10=;
        b=FwjDP5r4D1yRsZL8/7fv+bjQ7p8E/PJJ+5vEHCUHs0KlGblcUTVT3xfwXwVRaihtC5
         biLKdUpai6i7y63t9DWt6qXiHpV7HXFFnSmS3EVWYsr4XRs3SAHGVhQoYmTdWTEhKikd
         pe5uK7zLIu75tKHyo+EfbocIqAPvKRDes62EzBk3FaqR1zyZPXw4pED78LqWg7GEsicA
         LgQuYY5hSAymFBecGhoJdiFztGMrcfoj+bXMgFqe4obLfypu2Yr/bltlz5DeQKzXPGzM
         m3x+lKk4aGlceMgTKEH/MVLnIYRDf6uhdAO9R9E6bH8srKVxu66M2xTcyFOI4WcIIBVR
         QJnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793881942; x=1794486742;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=bKGuzAUaHML6wkJsYB/5ryGtpKz03dwMg3XqSc0JR10=;
        b=ApOyJ/12ST87NRAruIAoRVAraiWvQ7REuXNCkoIy9hsdqI21ksYpoO4D6KotHXH2+J
         4aARAQgcJHTAVvs466LhovePAm6KHGSHwbMd2JAP6bxAZCgUGDknvOT/elZpq8rTroil
         rFrv1KFGM4OOZUPXJwe1dgBnb2P/72UReWgur+DrfHXHEg9lpp+CibPaTwpCFlluet3/
         zrMkNVzFQdMIvNTdd6m8X/Uir3TmWhtsZSJqkShp6tprVH209EfG4fivGzRn1xstxXPm
         0qNRI16KeervN746gCFM5XNTVQXyqZpUC/GRQ9bm/mWMfsEAsHH+qi91hBETvkjGBSWV
         uS7A==
X-Gm-Message-State: APuU4Z9e4NEfI41jkhvqfxjMSixYRsJbRhJCt225Dy0bcusQYsYJM0XV
	J0IVr3rgNuSspjI8uHcoBplhYvF6DbdJeDF+B6LEyABqxO5TZqRdiAaD
X-Gm-Gg: AYBFou13I/ouuAHzD9+oPGSKJCEjfcc1lW9K+jgkj9dC/VbMy1O5OphEWQFYgLUOXuc
	Hq4IpoZbRQWxI0x86w7e24BQOIuzEEljiUUJ9CASVjEwZznAj+qa/NEaduQf42YPBkKMMV3J3Wl
	Bw/di49qsZI/bEEYOudmALU6lycJN/CI/5I22MjALMm9MlQSnzh109C08fWcGHZIw146bIVR6r9
	7nedANzcVb+wuNr24HMMF0/OZ/LomvX2eN+ZLmiURwfkRcIrwip5lo8H+/Jq41FL7wSFoI7xqAb
	jUozMsfgDAFzBrQu9mgQKLfIwA2PDxZNcIoG4vXzrPOERWYR0gUOIVEChvTIoDnQ9QOl6Vur/H5
	LMV/VcnDxSS6vmCVxmX3CPjvA6+Z5zLqDo2asjrwpWG+hmkiO2zhevx+7LHotg2vBCTNfXiEfd6
	2yeLcZW7ij88LHVZK/0KR4bs/1Q1lHDmtWiwQfYXE6vxAEvz9ndIousg+dIhap1FMzyA09y4vz+
	LJ0OSDNCtp7HDL7W66xyebByVHcHgxrogXr4idPns9pj8pFr4RuEy4UM/f/+Om3lTKcIDJ4gU83
	7PX9Eg1a9vQH+T76okV58kz5TTaDT5N87U/5Cjb1MNUt24w=
X-Received: by 2002:a05:7300:de06:b0:36d:2b02:86a6 with SMTP id 5a478bee46e88-36d2b028b7bmr5063810eec.4.1793881941559;
        Thu, 05 Nov 2026 04:32:21 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca3966daasm21742977eec.23.2026.11.05.04.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 04:32:21 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Thu, 05 Nov 2026 07:32:11 -0500
Subject: [PATCH v2] mm/shmem: remove truncated folios from the page cache
 in batches
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-bug-mm-shmem-undo-batch-v2-1-ae5f89ced044@gmail.com>
X-B4-Tracking: v=1; b=H4sIAEp37GoC/4WNQQ6CMBBFr0Jm7ZhOVRRX3sOwgHagk1hKWiAaw
 t2tXMDle8l/f4XEUTjBvVgh8iJJwpBBHwowrhl6RrGZQStdktIVtnOP3mNynj3Ogw3YNpNxaFk
 pspUpO2LI6zFyJ++9/KwzO0lTiJ/9aKGf/d9cCAkvVXs6a9IdX2+P3jfyOprgod627QtJLB9xv
 gAAAA==
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: h14gyc93nuryaptsdgenincnajziquou
X-Rspamd-Queue-Id: 6DC60C0005
X-Rspam-User: 
X-HE-Tag: 1793881943-139129
X-HE-Meta: U2FsdGVkX1/xbPmOUZWAdsmEqYqDvDWKKEksCYiJbBKvvqmqnbfs3I+K9FcEjdahxbvYGhJXW5zpg3omLXm4h5srIKFz1m3LRBNtTCAgIz4SmvMKgHrB3FNUrnC4M4NR/jqtI2R82/ZAFkEYSPZJrtyDrSFAcgv4Q4Ka8ZSQhzwQYMDrmLF+KpNHSp5GZAHCFr4SL3f4ytGJffO2HF12osVzRJ27yOotR9MLGgZNvjghqLp2TFJ7/Io+O4u0qhq+LLjzTjBJ86g+2lEH1jkOpAaW5b0dGJLZRAqGAqj0D6FvQXwWaptvx1qxR8gCHrZrQeFeqDy3f0brCoJa+ZFSWQDegyONnqb50qOXIyOS4Ie3U7OTLW8EgDkEGz2tx92aICQIfnNbW/VFLFNZGPVQvClSqbKs5Gt5+plmJ87uDswx/+SR988VmFxSOC91RyrUUALj9FSsevZ/tziL042n7D8kJNjSogiPr56vmxSgoL7tKNz+qnMVAuzV18VFWLAOWT4KSpZWJXgVo9bCJKGw6Zy8AyyoQr0p0Msa/qTgBy5+/rC7B41zjob/SeyC+pwwgajxykBLedUC39TxZOdjGz/Ei3ZPQffShyVwN2tIXyOPUlRtVVFbEDPZLIp2wKOJ0+D+v3l+/x+uNG6nPl0FMmhUiOjXgN2ATf4vl3HTbiBvSLHPUd8EUZeXNQyeSzGeg+f5GI7VjGm5HnxULOFMmFmtvVNTAz7T5XV8VRyVQQpi6HabRZtjPguFnZoMjcLrvuo7VfdiHRz3B3g3+Vko7Wf50XL2W9Lsz2OIpBxYLgE1S+lTyIgm8L/aO/fxyw5LyPxtLu5/xjkfEeuZ0e/DhdInRt9SeqsqM2zZShu3sRIcUEk8LtTuHMa+Gohn4he7BE4t7pbeeLPBkg5iWWXEpvZr0oMiC/tgJtjdXAJ8c+NTlR0vpNz3r1zl2knViNb5qgQhg/KuI9J71FtFkiq
 9nTF9i/u
 iX4wOF4ZlzQkh1q0nwrv4J36rKbya4TFCtUIrub5CeEIwCyXd+cTCsqkghS9svlSgxGVPAqz2x5eFifN6udItQiQqbP2wMj+0vGwUyikRGvYmE/FeLPVrPBLK39LU9VcKHrAJxOY2NgqY1YFy89YowQU62+Vjm3thZPsiKGyz9hULDbACk5ejamofqPn8DNdZthHxsMkQ2VQuWgNZxO4XUx6dZVp+moH3SpaXpoa0ql4niDPNYTU8xmsRYn1O2j5znunY0LQpuqMzfUQYQHM4zSnafkiQ/T1Kc9UAt1RPlnLvHfMrUKEu0UiHwdshcyKdh4sdFYPOU12V5ZJ/eiUzDgmjvJRbHTrb9WpjORw3NslcOEw0Z9C/5m6gvCmY3e1rykFl/pvgbaDWBiI4pUEgZ9vOPBQi/puh7dFgl4DlirL+ruPomBjmeK+83Vk8ZmfrsegnnVx4E5wSWhfXEDr21p6yktSF9hFlmynqCDs8VERGrBGu2KIHcRLUSYI9xyBgYAwVyGWbiFMrvlvzP6X5/zAQUXjpiSUhhZ9a
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

Clean each folio up as truncate_inode_folio() does, collect the ones to
remove and take them out with delete_from_page_cache_batch(), which
needs truncate_cleanup_folio() outside mm/truncate.c. Swap entries, and
the folios kept when undoing a failed fallocate(), stay out of the
batch. Dropping an 8 GiB file of 4K folios, median of five runs,
averaged over two boots of each kernel, in a 32 vCPU VM:

                        before    after
  ftruncate() to 0     1150 ms   917 ms
  hole punch           1165 ms   919 ms
  close() of a memfd   1153 ms   921 ms
  unlink()             1152 ms   921 ms

Files of PMD-sized folios take 18-27 ms with or without this change.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
V1 -> V2:
- Unlock the folios after folio_batch_remove_exceptionals(), as Jan
  suggested
- Rebase onto v7.4-rc1-132-g05441d697f7f and update the numbers from a
  new run

v1: https://lore.kernel.org/r/20261029-bug-mm-shmem-undo-batch-v1-1-59b34212fe78@gmail.com

To see it, fill and remove a large /dev/shm file:

  fallocate -l 8G /dev/shm/f && time rm /dev/shm/f
---
 mm/internal.h |  1 +
 mm/shmem.c    | 13 ++++++++++---
 mm/truncate.c |  2 +-
 3 files changed, 12 insertions(+), 4 deletions(-)

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
index af21a89abb0f6..2e51cc9c4c24e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1352,6 +1352,9 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 	index = start;
 	while (index < end && find_lock_entries(mapping, &index, end - 1,
 			&fbatch, indices)) {
+		struct folio_batch remove;
+
+		folio_batch_init(&remove);
 		for (i = 0; i < folio_batch_count(&fbatch); i++) {
 			folio = fbatch.folios[i];
 
@@ -1363,11 +1366,15 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 				continue;
 			}
 
-			if (!unfalloc || !folio_test_uptodate(folio))
-				truncate_inode_folio(mapping, folio);
-			folio_unlock(folio);
+			if (!unfalloc || !folio_test_uptodate(folio)) {
+				truncate_cleanup_folio(folio);
+				folio_batch_add(&remove, folio);
+			}
 		}
+		delete_from_page_cache_batch(mapping, &remove);
 		folio_batch_remove_exceptionals(&fbatch);
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
base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
change-id: 20261029-bug-mm-shmem-undo-batch-de001d9c6f1e

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


