Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D7E0606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S0cniXBB
Received: by kanga.kvack.org (Postfix)
	id 36F796B05BF; Tue, 10 Nov 2026 15:38:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348C66B05C4; Tue, 10 Nov 2026 15:38:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25DA86B05C6; Tue, 10 Nov 2026 15:38:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA3156B05BF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:38:34 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8405C1C3BFD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:38:34 +0000 (UTC)
X-FDA: 85420372548.09.4717ED6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id A5EFB1C0008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:38:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S0cniXBB;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794343112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rWL1Kmv7mAHkdWfEPS1Zn8rv1uvTakq1n0zWir5tjAY=;
	b=CcB1yTQb0xEd6P96M6k75BvjVUcjPwb91y89NAdAiFeLEmk8/wqu7U9iUbjAZTaMDBk6j2
	IEb1jOAysCSbyZXlaENk19iGnbvDtAtzfvDHwPSHRxk5ns6DsnCvItLJEAKYbAKg8vKkHc
	KlIZA0fFh8pkjHGa6BixPqB5RTOHk6A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794343112;
	b=W+/o5x2NEv8gG8lpivQvvNcamm9gH/j1foDNgTiZyFgHTAY9JbQNd6LsfLJSCYI9SWxRr5
	WMztggLs3aa81cy0hdEnCs2BlgFVayR2wyePeaLXxrCVpgaIPZTAEkuQbmwiHx8XvPVqmt
	VgmE8aXWIXsAaNLXykOEzWV4kX4Nslw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S0cniXBB;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C5DEA46988;
	Tue, 10 Nov 2026 20:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5091F0089F;
	Tue, 10 Nov 2026 20:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794343111;
	bh=rWL1Kmv7mAHkdWfEPS1Zn8rv1uvTakq1n0zWir5tjAY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=S0cniXBBSbAKwPU5LJmTHsLUkrO1HqQv11rasfD/psGONH8eC80I8KSQwkTkjLI6b
	 XnkUDdUwQnPhFRf2NLkslK6dq3W/sAqOlctTZBNTtzKtrcfAsDU6JIqa1ONcsRkjgv
	 oZhy/GycQfPdplQGnKDAco8MZO1QEF1y4gDVcgwljEOrzxVNfhGDM+L1brF3OjeFGW
	 Zek42g0D77m/bI2HQuIdj7GTt1YdDVJsuBNyyYK4hFERt4aqts0zSPkbR7mmVcMFr+
	 IX9vlzjAJBEbkwd36sFrboVpmjb5aeMSmLXcWCM4WIXFboWhg3b4QF0SRVHERCrX47
	 Db6onH4qFIZsw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 10 Nov 2026 21:35:46 +0100
Subject: [PATCH v3 6/9] RFC: net: limit folio refcount when copying skb
 frag references
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-refcount_overflow_stable-v3-6-318625d63a98@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7051; i=david@kernel.org;
 h=from:subject:message-id; bh=8WcF+eMICV96yVCjGSTifLoav7b/cDE4tGUfm9+Di/I=;
 b=owGbwMvMwCF2QOXvyb15Z08znlZLYsj63BDO94xPoTdwnfeynl5fLReXSVd9StZMtGd1+rXHe
 63no4h1HaUsDGIcDLJiiizX1uWkBq9pdSyLMnSDmcPKBDKEgYtTACbiMY3hf/WMGttfF3rMLma/
 XXOe52Bjneaq3cyslXH7s2YorZuunMHwT2uhp6DtOVubC/MdjD+V3zGZvuVu0H6XfV4LvofabH0
 RwA0A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: iximm3kb7ck8t36s4pkyeqkwy8e8khki
X-Rspamd-Queue-Id: A5EFB1C0008
X-Rspam-User: 
X-HE-Tag: 1794343112-824510
X-HE-Meta: U2FsdGVkX190/c+cn32v2PGO6jYT/hnbgrdClR1CHi0fAYVB5wdKsv/DWV8O9s3f2T/LqpAOh/xZ57NOty9lcQMwl5SNK0I/w+1jwAXtjNKImK9LxYCjsrvG+Uk2jirvnG/I4JBNNooemqCJg7gd+yd8m/P2B/OQ/Pi3u92H2jugmeLKH66OHK1QA4sWHPvj4zRiOXxqPoeJ65fVAeuOvQz/v63z2QoWz5DLCQrSZ7aCPTUgE8p2ifjeGFq6gXfOcXd5HxoHiHjjrnwT0MWG1ha2MZhWx9R8MGzXi95FKgxR7006NECzkFQoRNDY+nCVQAcnFAVVBGTMrnyPIEXtd+WDrdqA4J5/mr62aJMKDyhNiCiUfgHfvz+SLMDgGoikhn2Cv38j0PdKsNTj7rO9+owoavLwkroA8aGpLG9Qn2AOKpE14BZaokq7MMlmyqDteiWvQxYfFzqUgGs430UptYVHQbMmCZmTGtWMi3OW8SnfzIeFp1Xs1ORpUycvTi34GFqp3dR5g2xx08/JVG6mmkVc0gHUCXqKt5G0wIUeKHeg8NT5i1/r2p3IVSV2cJbtp4pS80g7mcYbCqH9GHfPptipu9jmWckhtuPkkIKbTlKSqhKMWVWAIhWkCzi7JWj/9wayV0si/lA+hgTq+/3+9PBFz9y6D6lR4iPtJ2n6tCFzayzPQYK0q/Z7koJR7Ep0ZpVEtiWXPtBvRw0oKrFBIQfpT7NNWBXLnovdPfkGxGuLIus2eIV2dawd6PIE0OOslmNHFrSIdANUGtI31LZCS2frPjm51upW/ShSI99IBPd8XfhavTW2FkjFPW+ZMGlJTsDV/5oTM+awSy18nKUjC2Tmx0daJsbkHEZ51jllLJC4iTKFwzKjlB9dyMcWjOzXzODr5MhIb5WtjY9BqYZg/tHDPDPPwUoCI7HwIRmJbbqzL7+6Bj1U0+TCXpbZ7nxvfSQY0yQc8S4XE3aBcUK
 Y1hIcCcc
 2HTOxeugIPyGw/6Dt9hvUvr7IUufzJnOWFJBZGhcnkACJ1TXncWg4fhT0xMgcUOYyLlsm0zvg21+WbrmDAeGwJK+J4TQxCxHNjRmOVJmIWKHmxV+1pD/LlYgJIrUdcTKdt1c/p+zVD2sia2lZy/AhjBfJW4FGRo3c9f4IpdCYXMTpiZscVtsQRInKrFVZvepbhVFmmkhYIQ/Jz5H6W8KkWuJxJjxJdl/bFU6VlxKg8oq5BSuSMTXG/SI/SlM0DrLli27HObzXnT5il8hPTj0KvaRHebsDWs9kEpOqsVnerGQbqfCVoGNNhvhFcDDV/+WU9lNC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Various networking features copy frag references of an skb, for example
when unsharing a cloned skb (AF_PACKET trimming a clone), when copying an
skb (nft dup) or when building NFQUEUE messages. This is an effective
way for multiplying folio references held by an skb, allowing for
exceeding folio refcount limits.

This is not specific to large pagecache folios, but with them it is a
lot easier to reach the refcount limit, as page table mappings can cheaply
create many references.

Let's introduce skb_frag_try_ref() and skb_frags_try_ref(), which use
try_get_page(), and use them in pskb_expand_head(), __pskb_copy_fclone(),
skb_zerocopy() and pskb_carve_inside_*(). All of these can already fail,
and their callers handle that.

Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/skbuff_ref.h | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 net/core/skbuff.c          | 35 +++++++++++++++++++-----------
 2 files changed, 76 insertions(+), 12 deletions(-)

diff --git a/include/linux/skbuff_ref.h b/include/linux/skbuff_ref.h
index b6f6da556ee90..560ddc863bbec 100644
--- a/include/linux/skbuff_ref.h
+++ b/include/linux/skbuff_ref.h
@@ -44,6 +44,33 @@ static __always_inline void skb_frag_ref(struct sk_buff *skb, int f)
 		       skb->pp_recycle);
 }
 
+/**
+ * skb_frag_try_ref - try to acquire a reference on a paged fragment of an skb
+ * @skb: the buffer
+ * @f: the fragment offset
+ *
+ * Like skb_frag_ref(), but acquires non-page_pool page references using
+ * try_get_page(), refusing additional references to a page whose refcount is
+ * at its limit.
+ *
+ * Return: True if a reference was acquired, otherwise false.
+ */
+static __always_inline __must_check bool skb_frag_try_ref(struct sk_buff *skb,
+							  int f)
+{
+	netmem_ref netmem = skb_frag_netmem(&skb_shinfo(skb)->frags[f]);
+
+#ifdef CONFIG_PAGE_POOL
+	if (skb->pp_recycle && napi_pp_get_page(netmem))
+		return true;
+#endif
+	if (netmem_is_net_iov(netmem)) {
+		net_iov_inc_ref(netmem_to_net_iov(netmem));
+		return true;
+	}
+	return try_get_page(netmem_to_page(netmem));
+}
+
 bool napi_pp_put_page(netmem_ref netmem);
 
 /**
@@ -83,4 +110,30 @@ static __always_inline void skb_frag_unref(struct sk_buff *skb, int f)
 				 skb->pp_recycle);
 }
 
+/**
+ * skb_frags_try_ref - try to acquire references on all paged fragments
+ * @skb: the buffer
+ *
+ * Try to acquire a reference on each paged fragment of @skb using
+ * skb_frag_try_ref(). On failure, acquired references are dropped.
+ *
+ * Must not be used on skbs with managed frag references.
+ *
+ * Return: True if all references were acquired, otherwise false.
+ */
+static inline __must_check bool skb_frags_try_ref(struct sk_buff *skb)
+{
+	int i;
+
+	DEBUG_NET_WARN_ON_ONCE(skb_zcopy_managed(skb));
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		if (unlikely(!skb_frag_try_ref(skb, i))) {
+			while (i--)
+				skb_frag_unref(skb, i);
+			return false;
+		}
+	}
+	return true;
+}
+
 #endif	/* _LINUX_SKBUFF_REF_H */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 8da53d5b76fc2..1d44e9a4152e5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2254,7 +2254,13 @@ struct sk_buff *__pskb_copy_fclone(struct sk_buff *skb, int headroom,
 		n->pp_recycle = skb->pp_recycle;
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			skb_shinfo(n)->frags[i] = skb_shinfo(skb)->frags[i];
-			skb_frag_ref(n, i);
+			if (!skb_frag_try_ref(n, i)) {
+				/* Drop the references acquired so far. */
+				skb_shinfo(n)->nr_frags = i;
+				kfree_skb(n);
+				n = NULL;
+				goto out;
+			}
 		}
 		skb_shinfo(n)->nr_frags = i;
 		skb_shinfo(n)->flags |= skb_shinfo(skb)->flags & SKBFL_SHARED_FRAG;
@@ -2298,7 +2304,6 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	unsigned int size = osize + nhead + ntail;
 	long off;
 	u8 *data;
-	int i;
 
 	if (unlikely(nhead < 0)) {
 		DEBUG_NET_WARN_ON_ONCE(1);
@@ -2335,12 +2340,10 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	 * be since all we did is relocate the values
 	 */
 	if (skb_cloned(skb)) {
-		if (skb_orphan_frags(skb, gfp_mask))
+		if (skb_orphan_frags(skb, gfp_mask) || !skb_frags_try_ref(skb))
 			goto nofrags;
 		if (skb_zcopy(skb))
 			net_zcopy_get(skb_uarg(skb));
-		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
-			skb_frag_ref(skb, i);
 
 		if (skb_has_frag_list(skb))
 			skb_clone_fraglist(skb);
@@ -3896,7 +3899,8 @@ EXPORT_SYMBOL_GPL(skb_zerocopy_headlen);
  *
  *	Return value:
  *	0: everything is OK
- *	-ENOMEM: couldn't orphan frags of @from due to lack of memory
+ *	-ENOMEM: couldn't orphan frags of @from due to lack of memory, or
+ *	         couldn't take additional references to the frags of @from
  *	-EFAULT: skb_copy_bits() found some problem with skb geometry, or readable head
  *      payload would be mixed with unreadable frags.
  */
@@ -3961,7 +3965,11 @@ skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
 					len);
 		skb_frag_size_set(&skb_shinfo(to)->frags[j], size);
 		len -= size;
-		skb_frag_ref(to, j);
+		if (!skb_frag_try_ref(to, j)) {
+			/* The caller frees @to, dropping the acquired refs. */
+			skb_shinfo(to)->nr_frags = j;
+			return -ENOMEM;
+		}
 		j++;
 	}
 	skb_shinfo(to)->nr_frags = j;
@@ -6966,7 +6974,6 @@ static void skb_carve_reset_headers(struct sk_buff *skb)
 static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 				    const int headlen, gfp_t gfp_mask)
 {
-	int i;
 	unsigned int size = skb_end_offset(skb);
 	int new_hlen = headlen - off;
 	u8 *data;
@@ -6994,14 +7001,12 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 			frags[skb_shinfo(skb)->nr_frags]));
 	if (skb_cloned(skb)) {
 		/* drop the old head gracefully */
-		if (skb_orphan_frags(skb, gfp_mask)) {
+		if (skb_orphan_frags(skb, gfp_mask) || !skb_frags_try_ref(skb)) {
 			skb_kfree_head(data);
 			return -ENOMEM;
 		}
 		if (skb_zcopy(skb))
 			net_zcopy_get(skb_uarg(skb));
-		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
-			skb_frag_ref(skb, i);
 		if (skb_has_frag_list(skb))
 			skb_clone_fraglist(skb);
 		skb_release_data(skb, SKB_CONSUMED);
@@ -7131,7 +7136,13 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
 				skb_frag_off_add(&shinfo->frags[0], off - pos);
 				skb_frag_size_sub(&shinfo->frags[0], off - pos);
 			}
-			skb_frag_ref(skb, i);
+			if (!skb_frag_try_ref(skb, i)) {
+				/* We referenced frags i - k ... i - 1 so far. */
+				while (k--)
+					skb_frag_unref(skb, --i);
+				skb_kfree_head(data);
+				return -ENOMEM;
+			}
 			k++;
 		}
 		pos += fsize;

-- 
2.56.0


