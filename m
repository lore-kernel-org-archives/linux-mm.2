Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75C5260A2608
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DHPcEkzb
Received: by kanga.kvack.org (Postfix)
	id 9652B6B05B8; Tue, 10 Nov 2026 15:38:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93ACF6B05C5; Tue, 10 Nov 2026 15:38:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8506F6B05C7; Tue, 10 Nov 2026 15:38:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 660556B05C5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:38:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F004A0AFD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:38:18 +0000 (UTC)
X-FDA: 85420371876.09.B52D384
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 546201C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:38:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DHPcEkzb;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794343096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQhZr4bKzH1yYf83YlQikJs/ouU09iimk/Cgl1T4SEk=;
	b=ClzN0afBZrC0Jqd2Cv7LfFH68eieKCyD6XFXoNkOrUCP1ghGA3eaFSQgQCpr27iFg7SxTm
	FN0hrgYhJjPRkbYRadGouMFWnoVVN2AVYfa8sW9NJ6fg8waUjuSod1CZwPiGZxYYithw/v
	gXRKrXeiCbz1nk8QYXhVUf+k49XKXbA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794343096;
	b=MepSPWW/a+ghYB3weoukKXmSgoCECxN7rFGi7iMqCbFezQPFOl8NUzWQGsWANLaInY/ycP
	ew31NxF8qri+XHVqIGEE/ulBvifXAvmuiG3ozsDGpIwPkxMWpdPcdEog68TkcY/3NnblwJ
	/octoV2URz5QILviDY14SyEdhCQdGpw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DHPcEkzb;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4044612FC;
	Tue, 10 Nov 2026 20:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153321F008A1;
	Tue, 10 Nov 2026 20:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794343095;
	bh=TQhZr4bKzH1yYf83YlQikJs/ouU09iimk/Cgl1T4SEk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DHPcEkzbho85PvDiXuH1Qd5lFyC5q8gv5xBGffOubCgfOWWV7lqek7lvYfLRpSA0t
	 IQhTVJa4D+18lGt7AH2soR542b0oAlCR8P7LrIYpK31KzO7WrEG5dh9vxvNnyOQM/S
	 Zzp0LW4h/4rd/y6B/YdEiEzjYrWRL++7W+rtuk1+Hj57yFgXvgIdV4CQiW+ldPSf67
	 6GKEdhSSGHlGPBXfai6+VBlvQkQwf+pS+xWNq8luXH6gsQU2QOgxTB3fEnlfzzRiiM
	 NiKA0VJ1SYCOE+9P07p5d1RFLT20ramI6Mni0mRodbWhV4r9rKIOncSV1qxGF1Jmt+
	 y25nKd0tEPckw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 10 Nov 2026 21:35:45 +0100
Subject: [PATCH v3 5/9] mm/gup: limit pagecache folio refcount when
 grabbing references
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-refcount_overflow_stable-v3-5-318625d63a98@kernel.org>
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
In-Reply-To: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Song Liu <songliubraving@fb.com>, 
 Rik van Riel <riel@surriel.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>, 
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Steve Sistare <steven.sistare@oracle.com>, 
 John Hubbard <jhubbard@nvidia.com>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Josef Bacik <josef@toxicpanda.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
 iommu@lists.linux.dev, netdev@vger.kernel.org, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4131; i=david@kernel.org;
 h=from:subject:message-id; bh=U2nJUUKzo83lirIS+DNqGFEsPfDiTB+27qyVWt6EY4E=;
 b=owGbwMvMwCF2QOXvyb15Z08znlZLYsj63BC+Xi7jxvm37RO/J0ZcYPGTjOO+dHWBuLZc/bcgh
 UsBpnZzO0pZGMQ4GGTFFFmurctJDV7T6lgWZegGM4eVCWQIAxenAEzkbDkjw5fAS44nfZnacuf5
 MJ/NztLk33np7QlN1nMf71/7dsjK7CIjwzXxOSLLW+9qfzk1I/lYa8CL/dqKjX0dMxnj5fuu9x6
 5zQUA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam06
X-Stat-Signature: 9p3yygdupwcfw9xwgrq5wirnoqrnwatx
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 546201C0006
X-Rspam-User: 
X-HE-Tag: 1794343096-913788
X-HE-Meta: U2FsdGVkX1/KOLa82Ot46ZhJTGMX7XSH4pMswqi/BAR+4Q4B0VIXhLvGvK+IbOv1ksG+xhMJJ073rLsWqvp7x5BttJWkkDgs3kG8lbARdvDj3gc6cXxzK8El4ZyxEWSu1JyNWq9bjKNZ/BlzMWEm9rQ2ZCf+gf88B35tWokiCnxCJJQ3mhC+8k6kZzMpIOpinLmdRLFuLBAHZ0/Dv1E0Gc/P6YwYm370DDMn1Wfgd8YK5BXZ1ttyxac6tRjXp2aksU3sosLIfEB6kEwONSE/3Raj4Um/iX/YlajYqKOArZKMVr2mgIbUOk6mPWMrcX9llmqptgm9O11+WXvuv0VYrL0fXqYvlG3ZwP8r7JOT25bPXNBTvShYCxHuZQGicPFPHty6FClGAM38B1f+0CoSTHLd8gMBWiMyyl924Hw9TGZnO5FIofwQJo98iQGD8PqgxOA2VB36YlQMP3UMtcUmjAptFv3q2Pz60GsOXvBQyXT55YFThqqy+nuBBz9hZev3LIf40s04p2egWZk0VhVfrbjfLCVcIhbfAnuR1FY6QozkVAyNQcpjhRTIbIXYBkaUbXz0dTG+1vkEbii+aCpEo9UIMldaAW0sVa76JKT9pdeGoKuDazpWxBPJ6s6O4CQrW1nYNDK5tpft976CKpJL5fK5pH3PT8CPflBYsOVyP4DDkwEar+b/ZQ7lJqfErLe3jj8UIyDyuJoaRKL9OZIKnOYf1y1JOlQFpmW/hONpLwp6kK7eLHHow8Wpc9TjE2H2bnPGDUgror8SKZTs+MnqeC3r0QEQE/x8WVzdfYYXIj+miAI7TUeJB9zIg8LAYDZxYvfIb77EVr2pO+TEXDTzXAyYvFXx+pLIky6UtCZp9BVl+E877zF/6/tt2Q9aWgGsSnR9d1UonGiPZINzyLOk9+GkahqoBoIF1s1UffdALA25We4e2Xxoz6GH3/E8b1yLluQ6+RZNkLKRjTE1pAx
 hq4KxwDz
 QPE0bGVs/HBgF7UHi3r9U2UwgQ9PJ5nPKhUj9PBn7PF8zphtphbqAq7LpxgcsvNUOfZ+GFWdDdZBXR+twaCT3YcMazQHYiGTOuG2OBn4Zb3wqj3hIHilefmc+g+npnOHBRNiSBQzOf8gH8K37IpaXlmZfNhaMX9EY+d6ZT6wpSMQAM6s++J1mFR4QqZtwx8gEwDhILlHnyTQygSBqLcvRzdEwt0QuIOiMHwn5Tpgpbda02vAxbOFXXC48ZFsiRyyv+NfueDqS8hbIWHR03RL1K3CQTJrlyXhY4PGOxJuXTfPpD/DZD8nQ6axh6A7xgrHHO39okL6ioivBbbZKiEImuv9hgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Let's add a folio_ref_count_over_limit() check in fast and slow GUP
before acquiring additional references or pins.

Keep it simple and use the check for all folio types.

Also propagate try_grab_folio() errors when grabbing additional
references in __get_user_pages() and in memfd_pin_folios(), so hitting
the limit returns -ENOMEM instead of -EFAULT and -EINVAL, respectively.

Keep the existing invalid-refcount warnings.

Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: stable@vger.kernel.org
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h | 11 +++++------
 mm/gup.c           | 24 +++++++++++++++---------
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a36ff83589c61..9b11af88de2b9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2244,6 +2244,9 @@ bool __folio_ref_count_over_limit(unsigned int ref_count);
  * to pagecache folios (!hugetlb), either before acquiring references or
  * afterwards with rollback if the operation is refused.
  *
+ * Also required when pinning folios without a dedicated pincount that use
+ * GUP_PIN_COUNTING_BIAS.
+ *
  * Checking other folios does no harm.
  *
  * This check is an approximation; we leave some headroom such that concurrent
@@ -2951,12 +2954,8 @@ static inline bool folio_maybe_dma_pinned(struct folio *folio)
 		return atomic_read(&folio->_pincount) > 0;
 
 	/*
-	 * folio_ref_count() is signed. If that refcount overflows, then
-	 * folio_ref_count() returns a negative value, and callers will avoid
-	 * further incrementing the refcount.
-	 *
-	 * Here, for that overflow case, use the sign bit to count a little
-	 * bit higher via unsigned math, and thus still get an accurate result.
+	 * Use unsigned math so even an unexpected negative refcount is
+	 * treated as possibly pinned.
 	 */
 	return ((unsigned int)folio_ref_count(folio)) >=
 		GUP_PIN_COUNTING_BIAS;
diff --git a/mm/gup.c b/mm/gup.c
index ebbfee09b7278..531ef2469228e 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -79,6 +79,8 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
 	folio = page_folio(page);
 	if (WARN_ON_ONCE(folio_ref_count(folio) < 0))
 		return NULL;
+	if (unlikely(folio_ref_count_over_limit(folio)))
+		return NULL;
 	if (unlikely(!folio_ref_try_add(folio, refs)))
 		return NULL;
 
@@ -143,6 +145,10 @@ int __must_check try_grab_folio(struct folio *folio, int refs,
 	if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
 		return -ENOMEM;
 
+	if ((flags & (FOLL_GET | FOLL_PIN)) &&
+	    unlikely(folio_ref_count_over_limit(folio)))
+		return -ENOMEM;
+
 	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && folio_is_pci_p2pdma(folio)))
 		return -EREMOTEIO;
 
@@ -1482,17 +1488,17 @@ static long __get_user_pages(struct mm_struct *mm,
 				struct folio *folio = page_folio(page);
 
 				/*
-				 * Since we already hold refcount on the
-				 * large folio, this should never fail.
+				 * Grabbing more references can fail once we
+				 * hit folio refcount limits.
 				 */
-				if (try_grab_folio(folio, page_increm - 1,
-						   gup_flags)) {
+				ret = try_grab_folio(folio, page_increm - 1,
+						     gup_flags);
+				if (ret) {
 					/*
-					 * Release the 1st page ref if the
-					 * folio is problematic, fail hard.
+					 * Release the folio reference we
+					 * already took.
 					 */
 					gup_put_folio(folio, 1, gup_flags);
-					ret = -EFAULT;
 					goto out;
 				}
 			}
@@ -3541,10 +3547,10 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 					break;
 				}
 
-				if (try_grab_folio(folio, 1, FOLL_PIN)) {
+				ret = try_grab_folio(folio, 1, FOLL_PIN);
+				if (ret) {
 					folio_unlock(folio);
 					folio_batch_release(&fbatch);
-					ret = -EINVAL;
 					goto err;
 				}
 

-- 
2.56.0


