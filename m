Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE3BF606A88E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 08:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L/YSrX82
Received: by kanga.kvack.org (Postfix)
	id 0AD046B05B3; Wed, 18 Nov 2026 03:33:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05DE66B05B4; Wed, 18 Nov 2026 03:33:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB5EB6B05B5; Wed, 18 Nov 2026 03:33:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C19B96B05B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:33:07 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54B8C4045B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:33:07 +0000 (UTC)
X-FDA: 85447574814.18.99C8677
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 98941160004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:33:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L/YSrX82";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794990785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X5+mrw7HYEFvCvOyayXlxKhQQJlRFubrquRPaak2JSQ=;
	b=f5Jp0xQL/EVgJoQddv1SdRUPK4oL4yb3qmv1k2qQR+tc6YLxN03OMQoHaQur74PFw/WnAO
	Krcw48BASuBMP3PXvS7F56w97i3XAa6NOOHtyB0evItotv5VAoB0gFxpp/L2VcJfh+QdaZ
	sDIqMCvTrsrWXZPk46DzJk0+NGm3/mo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L/YSrX82";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794990785;
	b=VrO6i3SuiSCRAUrZpR+Wnk/BTZXjLiOu3BvJ5noYCbEq4/Rl6E2F5yKyd0G9KlOVMFe1u4
	KlMy9yO8YUfehnAaJ+6WZyc93K9TNfBrep/Va48XEHQZNX2l5pJ6eWMfyO1k1AXAEQ3FkK
	Z1adqC4QM053SAvlU7udiyNKToFpGEw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C6EF611D1;
	Wed, 18 Nov 2026 08:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4929C1F000C7;
	Wed, 18 Nov 2026 08:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794990784;
	bh=X5+mrw7HYEFvCvOyayXlxKhQQJlRFubrquRPaak2JSQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=L/YSrX82F8z9WFIi6QltKHwZGwMN9NQr/tSIimA5pPLoYsWlAF5BTwGKkihRQyheA
	 YLF2IWkwSQC7r+xLmiy3V6W5wuayTTpmoY/a90hz541g7Pz/gzttomAVnR4ir0VecV
	 TetLsC1g1dQSm7iry1ygk9dFD7ZDiupt+7o95IO/cfJSVSs2MKtd39cBfE/3G21LCT
	 +t1g0ToEXAycI6B799CKZPYmskaE91lgSCSbqDraH5UXU8e3hIeidJAkAe2um9Fb/C
	 7RrXRkaYtDayfYMLoqQZDkpPVaVzBCfi3PTLvPcScApK6lEAIRS8e5b/C+Z7pQanFq
	 qQGW4ECbPLdaw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 18 Nov 2026 09:32:38 +0100
Subject: [PATCH net 1/4] net: skbuff: limit folio refcount when copying skb
 frag references
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-skb_refcount_overflow-v1-1-5551b4954c3f@kernel.org>
References: <20261118-skb_refcount_overflow-v1-0-5551b4954c3f@kernel.org>
In-Reply-To: <20261118-skb_refcount_overflow-v1-0-5551b4954c3f@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Kiryl Shutsemau <kas@kernel.org>, 
 Song Liu <songliubraving@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Rik van Riel <riel@surriel.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
 Pedro Falcato <pfalcato@suse.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7095; i=david@kernel.org;
 h=from:subject:message-id; bh=81ha1g6Of6vaYR5pJbvgdvPTEKVuj17huB66s5amVak=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLL+Jm3jWfBVwI1jieq5xeETNmc239h0YEpGYcrevxlXD
 lnuZZXR7yhlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAiX5cz/M9xmNISKlLackon
 w+UfF//56dufKeypSW07Wsk19eC1wE0M/wusZ8kVXzgm7vlg/xvmA8cCAtVdq54+Wn/sT1Z6S3P
 hYkYA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 98941160004
X-Rspam-User: 
X-Stat-Signature: 16jh9a8bunxmb9y47jg4nsyj484bjsfk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794990785-119836
X-HE-Meta: U2FsdGVkX1+AX5GsTtA0xN5m7Rl4fz8zebPXjyhdQ3kapmwZSeNa8FxaHdJ8eoFdBQ4GqyuAlUSS6gWpDx1WNhyIrhjtJhN++fLlLm/GGVgq0PLKBOgSuvSxkML19ZE7Fqm1rJ1NYpPrWuCERukKs1V3QGJnLxTUe60pjyrrJkkg6L/mUn1dN5RWekgjywGtZDYrszJBNubV+4B0DL30iTg2TJRXPEykrQhKN1KAXp3LX3tKDBBGpOUVdHSkb6bAmPHiPvwplqNuV/xTkmKi1DfwBi65yqXymUDRjyp1i1zTUJ2eK4cPBOhEOeDS6fK5M+qe644RZvAfjGGaSo7k6TZZZ+LEALwJdlBKOG7iZVmn3WGT64vWBDHPWXDV0yiWWrLUZNhSS1woFTkYmCsoyUeIpseMcAhSb2NI0ewc5MiCyJZVVwxOsvlJdjjTXQZPwpvt1L0eb/gN/fND80Fyqn2bRppnGFPs4vABcia5a0cX6GaD78N2qSxb0LLNW7VKhGDIJ6lWXZTevzkqtVc1iIvZTU1OyA+XyHknAsVFo5/BYCX/URPqA2eFv8TZRuWc748O7anm6SPIAnIThpq1bL02fUHFo9wKipJk2HA3uAKEpKSbctzREz9rVsYiZJGg0BoEtgbn9G9m6Yn7kBrI4s8ao2GfaLItyL2+F9DfmjBuq24+OKuJhFElcEtkP2fWO/lTZY5kswt4m64aiV/glYH0BGWuQIHeSyjvlMnx1+ikqyaP8kZq7L+X2L4bg53lTqUpB1g7ChrdDT2JDM+eJ1XQULAOr9wLWROUiT7C/uV8GbVCu40724HGqYFWlE/YhZH87YuFkRnsrIlHB5g2RQqP4ALZrzNu51M1h5bOf7ahtKNydGEWZOri3gif8gjcNasfgpcumXZR0y6eAazVjhkY7fRorboW3KyZiDt4p0ds8y+tPRFETSNZ+IDmQWKVGNAqR+P1S1livPfAFhC
 FprsMos1
 Zf9q3VaXMkFZH000DaVRH6uHZDmPVftbdf2ZS/lwFjTzqrKVDs3JDeGBAmEbqifKHMnRbiYfUmpd6OdnAMYYd49VKxCeWJ/rG1q8mpegeSlDr2uPF4a4kqnrdAOLsn3+6+eEFzSSpgSpmUvWnvGS5KmPotYx63TS70q6O3byBUCiab8G7yLDRn0yyo3RoUK20Iiw+Hut9X7ArwDfugYAxuEG6Vl5i+6UZuxHwO0n9UXQ3eHnUKYxB/DOC7w==
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
index 1ac1e327ac4c6..447099b39deeb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2266,7 +2266,13 @@ struct sk_buff *__pskb_copy_fclone(struct sk_buff *skb, int headroom,
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
@@ -2310,7 +2316,6 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
 	unsigned int size = osize + nhead + ntail;
 	long off;
 	u8 *data;
-	int i;
 
 	if (unlikely(nhead < 0)) {
 		DEBUG_NET_WARN_ON_ONCE(1);
@@ -2347,12 +2352,10 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
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
@@ -3908,7 +3911,8 @@ EXPORT_SYMBOL_GPL(skb_zerocopy_headlen);
  *
  *	Return value:
  *	0: everything is OK
- *	-ENOMEM: couldn't orphan frags of @from due to lack of memory
+ *	-ENOMEM: couldn't orphan frags of @from due to lack of memory, or
+ *	         couldn't take additional references to the frags of @from
  *	-EFAULT: skb_copy_bits() found some problem with skb geometry, or readable head
  *      payload would be mixed with unreadable frags.
  */
@@ -3973,7 +3977,11 @@ skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
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
@@ -7004,7 +7012,6 @@ static void skb_carve_reset_headers(struct sk_buff *skb)
 static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
 				    const int headlen, gfp_t gfp_mask)
 {
-	int i;
 	unsigned int size = skb_end_offset(skb);
 	int new_hlen = headlen - off;
 	u8 *data;
@@ -7032,14 +7039,12 @@ static int pskb_carve_inside_header(struct sk_buff *skb, const u32 off,
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
@@ -7169,7 +7174,13 @@ static int pskb_carve_inside_nonlinear(struct sk_buff *skb, const u32 off,
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
2.43.0


