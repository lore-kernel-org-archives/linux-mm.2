Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13E34606A8B4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RV3Wjhhc
Received: by kanga.kvack.org (Postfix)
	id DEF3C6B061A; Thu, 12 Nov 2026 17:56:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC6956B061B; Thu, 12 Nov 2026 17:56:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDCED6B061C; Thu, 12 Nov 2026 17:56:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4286B061A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:56:00 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 059674117A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:56:00 +0000 (UTC)
X-FDA: 85427976480.04.58E6068
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2A8A280002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:55:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RV3Wjhhc;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794524158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WzTgpej2ncx6QIZIb4B0vfziYK/NSwfzxDGBK1Sb5Mo=;
	b=rRocifT+xTHvpYj31KJMJSddQ/aITNFxwN1MNhsSLKo03p6HWI/+Jh39iGPUIK/A57BkCs
	eaYedhQnfpP2x5EMx/jedYOjC9xQPT+2ubcQ+lEbE9nseavx0ETZPJXJcosOg02NEawREm
	7Ra7srJMfONDDdvjPzqe97b3snIjZXU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794524158;
	b=nx2u//DxwhZfGiUsuZkI9Fmzk6HDwZExtRVBODFXNbRVigi5AT6bYJ0rF6AmxjR75RMBPk
	SDiqDHeZR/cExzc5mUG1ThvuAx5O3STPwbXLk6INUJMYO65Qi4UV1Zw4XVMOL0djaRiWwE
	Y2tGAwfZsGdnD+Q7AJ4acC+IwQtqmqI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RV3Wjhhc;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CD5741286;
	Thu, 12 Nov 2026 22:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15E11F000C5;
	Thu, 12 Nov 2026 22:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794524157;
	bh=WzTgpej2ncx6QIZIb4B0vfziYK/NSwfzxDGBK1Sb5Mo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RV3Wjhhc6lK7WFK/QqSJvzulZIbg/SvBnBx3dyr9yRolSAvY3JdrvpiEnkiJ2eN0U
	 o05/7nm33X6FanTpy7kc3vyq9bk/2PhRyP/p+BZb1niT77XpJEcvwat/0ct5n/T7Rn
	 NsZz18nRD3HcHHk4LdQulo3PpHsGxk34auD9+CyT6v2t8FKZeH19domrRGbxmq+bhL
	 HG5ocw1khCU97pHVNr6E8jbS02KxXxxNO4EmaNBRfHnkTu/LSNSAkScZDyqesbSVD9
	 7jRaG9/mJ4otNeg3G3zH0R4+YFmT06VN2pkTwXjAiH5E3wfkDKg6fjOv97gXkrNWj0
	 fJn/jSlaeuKeA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 12 Nov 2026 23:53:27 +0100
Subject: [PATCH v4 8/9] net: limit folio refcount when splicing pages into
 skbs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-refcount_overflow_stable-v4-8-ad3deef0bd23@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2437; i=david@kernel.org;
 h=from:subject:message-id; bh=2HIVuRJemzSar8UdUmReSo7kyB3JDSJ5ToRfjKbRBOI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+OWf1PDr6KcJKb/52PYHbuw2PHj399hVnfKbJfLaef
 HXVC64WHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzEJIrhD5eqTtHJ0jVXewXm
 m3DxrJ/HxcBz0OObysLvTItenzivx8XwT32S4UHWfZdm7bnYtaXSeO+j//xK9fN0b1deez8h1t7
 gGwcA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2A8A280002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: g4w896m5fmao9yj81qz4maygz7fi6b63
X-Rspam-User: 
X-HE-Tag: 1794524158-263910
X-HE-Meta: U2FsdGVkX18eNMESQ/yZseLqc33WHOLbVdGF1JN9HBk5HYsCovwssDJ3xoJ3w9kQ+gjMwM575h+JR1HxAFflBFTvyCuFUH6KFA+HDnkDx18ub7Wh++XGMz+aTnwfS7cQU16TFYGbWnyECCVC6ESIxRa/DRNpfcLBZVxp7ix7JD338SDv+7R+UcLfmtCg80X9S7eCRQK/LbNCMVsIcq//vQR3sqbluH5VpKx2BoIxohIHgTPpHxTl0od4anVqJ3gVSq7OjaowPc5D6Au/R8eCOhUhar2m7UZMYMM90EQKQ9pRBZjDMLd2vKMAA/78z2D7Uwn+6d3C5BKurzSdErrkRXB1p8OBrrBxqBYHVMy35B8AsCiJRyERY8Gszz6uCCcFLLzHICWxhobbe/iX6Ks/noCpMnHGYczVAz9vpXaBTuLoFXEzPVAuwXcDPrkiXDxxlEnV/JDLEONLr1RIbB9o86UoDbric2OszpQwr6Td6u/BgqqMim5IyHalnkUMeNqigcp7mRCl5lfP9W59EWUmhAJQaOIo4UOQkI5KnccRStioJJFP1NyIZbkSAIQVj0djFQ9q9PF4XtOZZDwG6CDY8+rKStFm25VMuBSH5dpl9TzxOW+XYoiwL885Do1ZObIjOyKMFxX8t0BP2mxMSbmFM5c7KNulHDcuuu3zYG3fLLacr0E5WGXj3lhDwyDYrMWFuX9ypSLRvNVhE3Gv7G2HCpcNFIZzqAgh1xI749Dw8GU49WgDHgJ4AR/kJdAUdJhQfM0Ig42cMAVsPRi6sku66gXsKMVX0J48wfoRLS4NsMNWSnGJRuJjHwtsLyy+aXECGNRueKVczLkBb8p7HntnU1msqf84XpQSpaLX2XvKZdAQgkFGP1FsqztqYqtjeaqsG5B8JnqFZak1khIyRYouYfa7CXiyalGn2h75ox5EBsAPGaKjlYySfdtQLdYn42Lj2fgC44Udcx5q9ywOuUc
 F4JrJwfH
 mm69p4+gWaJ8x+WoWww5EnKmuD07qJJxZyQzhYUEGN2Uvqs9TMcrdsWPjlcr97mYpdoPnY6xNE3TREBR0b83mAJaeyRqcdsfamlJHBFFNh0A8we3PlmwZUUnXqHqP7zzv40xT8kQHYDLTq+9UGvCmjN7Qi6mHMalLdeqpKFyNWdliBzt+Iv0K3srg8yofC01qGB904lAhsK6gtVN7hGtdU9eRyV9cGVjfuYEwwSwkofXwSnpngUGEncgteou22UzFxwrx7Y290VKZDKv20/BC2CVQdekV+OuQC0M2/D1/5RFeVH6MquQgdxJmla7cVZa4VmVN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Various networking features use MSG_SPLICE_PAGES to add pages to skbs,
whereby skb_append_pagefrags() takes a page reference for each fragment it
adds. Pages spliced from pipes were already checked when entering the
pipe, but in-kernel users like sunrpc pass pagecache pages directly. This
allows for exceeding folio refcount limits.

This is not specific to large pagecache folios, but with them it is a
lot easier to reach the refcount limit, as page table mappings can cheaply
create many references.

Let's use try_get_page() in skb_append_pagefrags() and fail with -EFAULT.
Don't use -EMSGSIZE, as TCP would just retry with a new skb. The only
caller, skb_splice_from_iter(), handles that.

Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: stable@vger.kernel.org
Acked-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 net/core/skbuff.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f473c74956b8b..5e3f910eeea0b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4702,8 +4702,13 @@ int skb_append_pagefrags(struct sk_buff *skb, struct page *page,
 	if (skb_can_coalesce(skb, i, page, offset)) {
 		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], size);
 	} else if (i < max_frags) {
+		/*
+		 * Don't use -EMSGSIZE, as callers would just retry with a new
+		 * skb.
+		 */
+		if (!try_get_page(page))
+			return -EFAULT;
 		skb_zcopy_downgrade_managed(skb);
-		get_page(page);
 		skb_fill_page_desc_noacc(skb, i, page, offset, size);
 	} else {
 		return -EMSGSIZE;
@@ -7575,8 +7580,9 @@ static void skb_splice_csum_page(struct sk_buff *skb, struct page *page,
  * possible, copying them to fragments if not possible (such as if they're slab
  * pages).
  *
- * Returns the amount of data spliced/copied or -EMSGSIZE if there's
- * insufficient space in the buffer to transfer anything.
+ * Returns the amount of data spliced/copied, -EMSGSIZE if there's
+ * insufficient space in the buffer to transfer anything, or -EFAULT if we
+ * could not take a page reference.
  */
 ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
 			     ssize_t maxsize)

-- 
2.56.0


