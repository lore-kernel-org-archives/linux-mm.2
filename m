Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68C55606A88A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gdwb1klD
Received: by kanga.kvack.org (Postfix)
	id 4EDC66B0614; Thu, 12 Nov 2026 17:55:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6EC6B0616; Thu, 12 Nov 2026 17:55:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DAEC6B0617; Thu, 12 Nov 2026 17:55:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16DEA6B0614
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:55:28 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 082CB4187A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:55:27 +0000 (UTC)
X-FDA: 85427975094.09.E0EC8FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 16905100008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:55:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gdwb1klD;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794524125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtuAsfhpH9Wi2rdBATYS1f2ORNrPFRRfK6WhBQnQnFY=;
	b=4KzjVAAEfY0BninYflPhrcY2VVZp2VbXxSK+xrOLhBpuw1sqQwaB76xTa9owQIlJgiBhP7
	2L4sij3bVqBa9Qy6zsGm6Xv8hO+C8l5ieFWZaQfKnX8m94KiSOtXFY3RJUqWFgpdK8dbeo
	7JpxrqfY2TmDtyGFbJCvHMKpWUPQR1c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794524125;
	b=ngejTHkoOSFueWCUodCO02e1Qor3CechRFGSOE2g7bIAhE6RQlDPgK0npOi/aW+TjGPJRe
	a4iydkhOVhzBKaWFw4Xu6e8zcGlXg+OmkI/09MP8cpRAGWny+CWAHxyDiOCFsN94qIDyx9
	rsdltfoJF6F579PqPliNcRiJgnJdn88=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gdwb1klD;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 43A4B41ADC;
	Thu, 12 Nov 2026 22:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AFD1F000C4;
	Thu, 12 Nov 2026 22:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794524124;
	bh=YtuAsfhpH9Wi2rdBATYS1f2ORNrPFRRfK6WhBQnQnFY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Gdwb1klDz3rDpk33v9KdY79kgGQ0z0CsT+1QzSa3AHhNT1VfKpS4dY+elh8Vh8zzH
	 7200U0MJ77EZV1wdBXuZV029q8TE1VwwQjCttb9LRSTGvr5Z8FCdqbrkWZsQnnsD9V
	 zJu7Bl4EyiJZbUfuXY9DaKDPb2tzs/HZl3g4HENFg2Gt727/oin3dVOfZ84cKN+xee
	 Cj1BrMCXhArTBYRhjfo1rmIzOL8h5ZNgAxfQMZTz1+rgjr5vBHHN1uGBOOqpWJHRt1
	 w8G68tIb6/C7RB1968O36s+e1pTDqLz9pQSndAdpjgIfMxsNgYQmqtl5kv1aupQh36
	 mlJrgkpih+DeQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 12 Nov 2026 23:53:25 +0100
Subject: [PATCH v4 6/9] net: limit folio refcount when copying skb frag
 references
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-refcount_overflow_stable-v4-6-ad3deef0bd23@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7095; i=david@kernel.org;
 h=from:subject:message-id; bh=xba2U2hB9W37nLQj4Nz5OSKhUBoSCCtXjwLlqARMq2s=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+OWfpuWcejPu65Py2edJ3/FU1+pe87WU92bo7MubIj
 hdba+t6O0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjIxzMM/4PdsudUmN/lyp33
 Vv52is1b5mo152nFAXNlZ+muSlvb+Ifhf1Q1c/2uRa6THvNGsTJ5PC0uf7Jpu6PM5y8MU7c9K/y
 0kBMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: h1uhf1asif6mtr8oo55bc8gzk8j7o554
X-Rspamd-Queue-Id: 16905100008
X-Rspam-User: 
X-HE-Tag: 1794524124-448380
X-HE-Meta: U2FsdGVkX1+L2TzyivuxgTjeDdZgkfbFZ08N+9LhOTLHoQFA1z6Dez/Yf9VGG0rdSnUUATDExUlEVsuqRcL/aiiwMJc4usSVz24Uq4f1CPMsMCTMFKNksDXYtNqhVrTNGjlN6Dljd+mIXK3DisywXVw9ISCNOADU16DFDveUPRXDAnrIYaphhrsmHNzYKNg6lxVReXoE5OoPXJAQpSe62TcJa1yeMsU3zJxsrI6sUrv6iiNAXJVYOmwGdppBOey4bx6UZ3fgTNdWuPUCR59fr1bp1ba9Yf22j/m/V4ZhCT4Z+Nk78QLGESEMgoCijNrpW9SFGENllFONOo3iObpVLUePcEtWGO0LiD9Ued14scLC6gqkoxawW2nI2AJ5tKzqWjbJfVIXtUlrPTr76eyy3AvvVq8LMwiPCYZuZirVWtgFYqPxEQFz3kWCWzDvdWp516JQs2DWaBrnRXuzTH8pEIdA1dLUqixryZ20c8cha+d8P5hVjfvDDokyvkxaBxbcyII2ApfPXfTsmfdNnnm9k0+nBKBqZCy3giahfBQ37vPl1DZKvrdzVvHvN9oSZytypuZMEzYdFVPFJuLtD2WjLEoceI8aLi7O7b/QJeWxHK8QJ+GmMc3rcAqfVvUgLJMU46lNZNiB8pIDEUM6xaDEeV8wg7bkzbSJoTt4QgfAMnOxuqUvdlkiM+KaNlGDOvlm7X6mFs2v1sx07g74F2YZM/O60DH1gTBwo+fhStJnPphCbJSqhKVxv+aqEWwaYqON9JRschZCpB7i+qe3UxL0lCHUnvmMyx7X9QFzM/4S0+Fq0Aw+aqnJ9siVeIFGigiYwpSI48v0KMMHqg9gWGEZiBslQ1epySsenDWz5J1i9VGGYKUJf/zDX2YAO1UEnMaP5PwdVtin8V9/Oa1rLM+RYsS3m8npkDKAbxm6hrc652rSzCaUxnnsow7qFrHjEoNpzdayV4YPucoqZRPZcB1
 zqVMNuYZ
 QKYf/j4haw7BtONLl1OV7sEDbow0qEu2kgpo1joTSzM81c/NlGQYDqs3mgTcJDuToEm3Ts0omZLzqzMGaDSOVUYQAcCUbPoKDeMxU28nsDo1SOLbFk/CHi3YoiLPuz4aSJH79RQVKlVMVMifs8OtIkE3XzmJ1a8yAYY0xzlg8nigYQQpC6vozkHf4OQwx0VKAF6zosvd/ADZ6Qyta83Y45cwjGDUP+GEWR/aOYaqDnGPkuYkhQ1+8sFTAs2vAiTlmSROtZNi3Imzz+p59poCg1bPvwIU59HHABR47Q6dQnHv/A8ZaX5+uwCoyTthpRo2TRMRQ
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
Acked-by: Pedro Falcato <pfalcato@suse.de>
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


