Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 437A2606A336
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QTeTfbGe
Received: by kanga.kvack.org (Postfix)
	id 0F5F06B0613; Thu, 12 Nov 2026 17:55:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CE176B0614; Thu, 12 Nov 2026 17:55:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED82A6B0615; Thu, 12 Nov 2026 17:55:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B63876B0613
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:55:10 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4575C1C4166
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:55:10 +0000 (UTC)
X-FDA: 85427974380.03.EF54912
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 833071A000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:55:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QTeTfbGe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794524108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xD5fh73q/8pagNiTYKZXU3AwQ2//zL6YtRJEHaiPpLQ=;
	b=0tEiQBozayzLhcg4buFyU7jC1btuEBaBYWcC4rw3tpMuaB1CIwEJKzY5PSqW4HwRtFmSeq
	gWFI9HZHHAMRpR9AtJy007FX8LV/faXFVuG1H5P7sB42KH1D8wbZK/d+D2xGtjn+zUa2oi
	r6W/9l4cEKvq0iOdnc4rfd5acSP5phs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QTeTfbGe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794524108;
	b=ob79zUx7Me2+1cdS0cGmqL60KbJzy3CYpJQ9yLj0Kt8BTswMRuxz2PvVbcnObPxq8dAKST
	UWCcixYtWDvN0N4wvRQ3pYKWmazmGaJGQi4yT9kDRqH+xCuvh0Hj83m05nf+boCAkl3+oB
	jjLICmutstbQBEqM6WGGcQ8Ydszk6rg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2188362477;
	Thu, 12 Nov 2026 22:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7641F000C4;
	Thu, 12 Nov 2026 22:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794524107;
	bh=xD5fh73q/8pagNiTYKZXU3AwQ2//zL6YtRJEHaiPpLQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QTeTfbGessK3tLqLfk7/znA/6mfnv+uFezUe9IOZA5Y1l7h7Oo1TfY8ZdN2V3k9Kj
	 1uH0fHiEDnYNZS3QfepNFBRNe/EZtIRS7UPXtVBhP44WAKJNI+2cPRoO2GUXkz7mns
	 C7ZQPAp1zqi98vSWE5I2aNWqf2jTsRwaPSF3rRk/z8e7e7Z7glMoWIEkyK6hC4E+Q+
	 AwkyTgZFTjzLSXEF8jBBxkmTxzzLfXQjh+6JvVz/yokNdr+mmWr9hRvvSkO1zaoej4
	 /DQHD54k41YzHXDi7Ns7oaPdD0KIkYYtObsnxIxQ6/yZ09TpfcPTPS6jegKf/G28Yg
	 eRP5Dbx1fktTw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 12 Nov 2026 23:53:24 +0100
Subject: [PATCH v4 5/9] mm/gup: limit pagecache folio refcount when
 grabbing references
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-refcount_overflow_stable-v4-5-ad3deef0bd23@kernel.org>
References: <20261112-refcount_overflow_stable-v4-0-ad3deef0bd23@kernel.org>
In-Reply-To: <20261112-refcount_overflow_stable-v4-0-ad3deef0bd23@kernel.org>
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
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
 iommu@lists.linux.dev, netdev@vger.kernel.org, stable@vger.kernel.org, 
 Pedro Falcato <pfalcato@suse.de>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4594; i=david@kernel.org;
 h=from:subject:message-id; bh=oyZjzhRpZpzTLHbZfyFwqqIr96d+/BTQmUry5D3V7Tk=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+OWe1ad82rOEOc3geX6LAmhz4VF7baNeb+BCD9UGPX
 jBkLIzqKGVhEONgkBVTZAkKvm/w8uW62mo3PmaYOaxMIEMYuDgFYCJBExgZ9j10fOmaED9x/Y3W
 xz+Pebg/+LTFUDGn6V16UuNv5sYrRxkZbgp+/bVy3f04nwks3Ke7w7meFHt+q9mRyaWQm/TKYcs
 NTgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 833071A000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ij4rqeyd7uqd1k6rn9es6bdd4xnor7q6
X-HE-Tag: 1794524108-802788
X-HE-Meta: U2FsdGVkX1+dUddt5mIor16oXpkAKOm4A4iR8p9j+vbKl4ylPor1YjtkNJYEXJqhdqZKN/M/SXIHv3Z/eSvC3R6mAsBMq5VjR9I53t4IkWAfHV+GlOds5SVqjE3QHRgNjemQObtww5fLTQdTidigF5aAI8gYLXJNtX35q9j4k+IOBBty10N0DuVQJjoltuoU3vxY+SS8RNJpemZ+LTlYLZouvUnyKItmAqA9InrTY+T27Jx1EBeXr/Qdonoyry65vHWbhiz22BbGyBKeOMyoAVSEjkthrLWjgN2iWxdl/vY2AFEJKE8TowqFXuDsd1h1FPpRusi2nF0KzI2/vy7JbKhi/oEFQIOlgBc2lEcmKYoMv9bJzHLwdG4S9xefmABBfj2FoUE4fLzVszGWwv9g4i65xR+z1Ly5Q2ErhXGQn7I5gegS1UdZ3E4Kud79FxNdGFtEAuYS+OFbEppI0lf0uq+Yj+kbj2QCpL4jLeUfzQj+0x0/mImxNA704EUaawJwb6LJEY0GKdHoOZLKJ3J4dPWuGYWbWk7w7vAzW98wCIQyciZx4moMnB3nH07RSod/1+WwwYEGntlgxj4pqUTe+0CvpmQo8q5uGs1wGOivFOyUBveEcMo66fcPD5tRt3WahN0QRncvy93KFHuZ2wkTz3rBMH49Cx/pkED4ummJ9SAfm5eX9KTblt0T4EA9TToyJaSbChqeYq+n9+3g/rih864ooG/r8w/9HmL10+/z3K9r5cD376CTsAMhjqqZqac+OoEh4abNYd8joJFStU/NmCvJif8YDW+hWQfbAF/Vkvg6nrSA+c7eYPhG/oBawsw195k6/e1vuo7z6WmP7X99sbsfdK+DZRWReiY5qymHFhGvEHGepDXXKY679pYHy3HuxOMR4HM2IlwJ9AGQMbaF1+LZPOHfar5clszIKZcnRr2mQ/ZB6ksOU6gdHco4uVLphyYJsChYNbD+3JBl+J0
 1w+hNR3g
 umAfYnac61WpQXz118fOpBB8asNzGzjpGE1gDxaZQniwL8YcL1EgIk65j/PzrTOtGHBJ8TfAMEk6OhFzzmEVAD0VmNqt51BAa0ZeechTy0SgYjJoOAiX35cv66XYKLQd4EUJgi9lfP2ZSsUm5c5ulXi1TRel3XzsnNsxomSyWLli1VnTB26ge94qZ0mBMQ4BKYQ9QVwrD6f9kdwsz/TwogHf9f9mk1UTaZ4nIGobT0MuZv/JY1N5y37bRlPpmaQ1QQr8su4RKzVwB07oBcAoT5Q1TUJ8OUzGd3rve1WkyCXRfvnxAEKyO4WlhBlHLdcDFuV4mKd3JziAKNm7AOVjPpqDNEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Let's add __folio_ref_count_over_limit() checks in fast and slow GUP
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
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h | 11 +++++------
 mm/gup.c           | 32 +++++++++++++++++++++-----------
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0d00fc1838a01..cc6f1e69223aa 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2246,6 +2246,9 @@ bool folio_ref_count_over_limit_slowpath(const struct folio *folio,
  * to pagecache folios (!hugetlb), either before acquiring references or
  * afterwards with rollback if the operation is refused.
  *
+ * Also required when pinning folios without a dedicated pincount that use
+ * GUP_PIN_COUNTING_BIAS.
+ *
  * Checking other folios does no harm.
  *
  * This check is an approximation; we leave some headroom such that concurrent
@@ -2967,12 +2970,8 @@ static inline bool folio_maybe_dma_pinned(struct folio *folio)
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
index ebbfee09b7278..c1b8ec3513913 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -74,10 +74,14 @@ static inline void sanity_check_pinned_pages(struct page **pages,
 static inline struct folio *try_get_folio(struct page *page, int refs)
 {
 	struct folio *folio;
+	int ref_count;
 
 retry:
 	folio = page_folio(page);
-	if (WARN_ON_ONCE(folio_ref_count(folio) < 0))
+	ref_count = folio_ref_count(folio);
+	if (WARN_ON_ONCE(ref_count < 0))
+		return NULL;
+	if (unlikely(__folio_ref_count_over_limit(folio, ref_count)))
 		return NULL;
 	if (unlikely(!folio_ref_try_add(folio, refs)))
 		return NULL;
@@ -140,7 +144,13 @@ static void gup_put_folio(struct folio *folio, int refs, unsigned int flags)
 int __must_check try_grab_folio(struct folio *folio, int refs,
 				unsigned int flags)
 {
-	if (WARN_ON_ONCE(folio_ref_count(folio) <= 0))
+	const int ref_count = folio_ref_count(folio);
+
+	if (WARN_ON_ONCE(ref_count <= 0))
+		return -ENOMEM;
+
+	if ((flags & (FOLL_GET | FOLL_PIN)) &&
+	    unlikely(__folio_ref_count_over_limit(folio, ref_count)))
 		return -ENOMEM;
 
 	if (unlikely(!(flags & FOLL_PCI_P2PDMA) && folio_is_pci_p2pdma(folio)))
@@ -1482,17 +1492,17 @@ static long __get_user_pages(struct mm_struct *mm,
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
@@ -3541,10 +3551,10 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
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


