Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F21D606A32F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 21:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O8gv2Nxw
Received: by kanga.kvack.org (Postfix)
	id 15CC16B05B5; Thu, 26 Nov 2026 16:19:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E6FA6B05B6; Thu, 26 Nov 2026 16:19:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2FA6B05B9; Thu, 26 Nov 2026 16:19:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC3806B05B5
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:19:01 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 44FD716011E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:19:01 +0000 (UTC)
X-FDA: 85478535282.21.4A4D294
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6F02C2000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:18:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O8gv2Nxw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795727939;
	b=GcnPHkwXXdeRzlZSD78f2Kmg9u2b8JDgbsnOkvFQvi3s4q/wWV5E/MD6wkpo0Pin0DbSWr
	fqOAl5n3TXYQE9L8B1gvyqLxQQELHRgD7mWTYF7z3paF4p2l3nnhN3LMevG/FSLxNGafIl
	14AZRIcj3VhHnI42YDzqKzxBJxO10ZE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795727939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mg7Qi4LHUwhrCBip/YNh+ysHUS3QtiytfnZ8aKHca6Y=;
	b=zzKCNSfvFmOkyL+/UGVr+JyJxNBGyqJsRnWP2KcPuY+J2qSndhTemVk5GEDMTd36HTOUZS
	AokS6CJDyTGmWF/UW9REt5O1s4lfYSMXGUHBri4NMMpZrCgUArtoWhlcPV5jPmfUbxReml
	RT7TFIu6wHtjBRnZ5BtjKH6hEdcx/is=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O8gv2Nxw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 552A240381;
	Thu, 26 Nov 2026 21:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE4D1F000C1;
	Thu, 26 Nov 2026 21:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795727938;
	bh=Mg7Qi4LHUwhrCBip/YNh+ysHUS3QtiytfnZ8aKHca6Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=O8gv2NxwkgNbzwKhX2fUIYRxC5AGfVq3E/xZVXTMFfMFTb2mP8I76C46eWOA+VnmG
	 q0yRMEpz/XdsubohZiFimte7JM0+A60hrKq6FWTm/6b5EAz5rFgA75xQdrBn/jm1UG
	 ouAMUXR/m3Kg0GCwpi84r79EuxdnlTw2mNbHcVZCTQlZuBb5545Lzl9yAdNREnV+9P
	 jl7xEEAVC6xsQIHtc9wtC0zNpgWKnpf1rAA5jAHz+6/3+bp4+GnqZ0Ro0q71/ysWwo
	 lVmZPxXD1qp1u8vCNmEtTHGdafRJSpY6ODAE5BJ+hKQBdxe+QTcqcLKPstEJpunyMH
	 QrlES0nRCGudw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 26 Nov 2026 22:18:37 +0100
Subject: [PATCH net v2 1/4] net: skbuff: limit folio refcount when copying
 skb frag references
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-skb_refcount_overflow-v2-1-a6f600a5634a@kernel.org>
References: <20261126-skb_refcount_overflow-v2-0-a6f600a5634a@kernel.org>
In-Reply-To: <20261126-skb_refcount_overflow-v2-0-a6f600a5634a@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Stanislav Fomichev <sdf.kernel@gmail.com>, 
 Willem de Bruijn <willemb@google.com>, Simon Horman <horms@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Kiryl Shutsemau <kas@kernel.org>, 
 Song Liu <songliubraving@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Rik van Riel <riel@surriel.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Chuck Lever <cel@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7086; i=david@kernel.org;
 h=from:subject:message-id; bh=wewoRC7UtcfuSJ9poShcy6AwrFQ9/guO5z282gKfSI0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI5Fpnu/Fl3TKl85qY4Od6VcW//ei39GrZIsmBtvM9iR
 Z+D9htfdpSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCRjzcY/kfdf1DtWfPt2F51
 PiF3vU1JnMe+vPf6019rcH6aSAZnWirD/yKOGMlt7cZVSZIfve813vmT5e90cNmMTB3/l8rTg28
 XMwAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 6F02C2000A
X-Stat-Signature: ozp14yuaoodim1gxe3r8hxymujk97pqw
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795727939-75286
X-HE-Meta: U2FsdGVkX1+aokBOVtSztNEp0G30DBdsWy/33LZB5Z2kIfrzU70VN+uzzLLSQdDNcncjXxfGwBGAHx3YuGt53omwfwd93mFY6n8rhHJY+E1YnBuE3tfK4Xdh5pJasAJpsNJLod2okglxtuQNFpcH6PEXfXlCzCurV0FbzQo9bP6XNck05xzDf0Hem7R6wXO15UDDmNLoERW1qHHDleDVvpjL49sFcjBIiSkT1piz5oKCTP7ciDw58p0jf/kbrK/dWH84kYUoEs5dTGS0ohiZcD1Z0N4advA9IFPHO8uzTR4m5tdktXJyIxtpzV4dEktLW0GB/48a+52pYWHXKoK5frK+ySANzJcVSaaTfV9AE9u/NBmPYw/NRZ2YkC7Bf78k68R6PjWFLnFY9SdOa4KlZl8ReYvUU1jichjyV0Rm26nxZzG32eKxUHyZrOBRL5SAEOC6THW+RxLxtPt+Aq3I+7bVQk/m95gPPQ8zzlMBIfm7MrHe+9vJuRTbko+uS2G+1J87HCjHXY+y7DW+s1ADd/KQ8w8ZK9o/Eun8kuiJ0UPerrLTuVXNW3mMlvz5/2uphzKHHazu/+Y9WZexuTWJV0XIFPSH7uhpixgCKebz8x2H1aqx5PYHD2ndMYr7i3s4HNQEDW27VXiwCVxZj14vPRQB7RWhlyZgJaL1OUQK1CQfSMtxAT9Pf6xIWzPcarsiQJ5+0cFn2mOwGpnHUHRDqQpJcA9pK9qd4Az9IU2XgexA+n11TPilJrnDOCm2xOh0J1Ihdep2fqm6as+ReGY7jLSFPGqk6YQDpvhT73S24C7A31bI7PdhifYD3ms1MDN6w0YGmbcoLwguoB/nZ09njjkz/P4j7q1LU36mrKJQAT+i6O5Ec5dUjT/jVUjQIbEhBZnaJDBN5qXyEjQoO+qZTnKbYsWUA3IFlhCOGZf3xw4zUJexmkffgF71+EHRdXU89Au4VuAtofsQi7Hi2+D
 uDajkh3n
 FZ7ReQkxBorROgSySxsZQDW6PJGoS0H2cEZWmt8wOSOVcpeY8jTXcGvGBfVW7qlCfKv/r9wP3t9px69n3AvBCWrQIsy26z0QhcfQ3vKcbQdSIigMllcpP0ZW+DZFKpHrZ6raLYnuMbUeJxsDUVkrZq38+yJGen0+8wBDQs8GPAhZlP9rwH0bDVLs4jGWXZgi5dro93WG0BFIbPPq1KeDS+lumBHGZfMjmhDlH1Mdt3qkHByUD6JpDTgpGDb4qBdSOLmN2bsoS9rOc0H5bSZgnvx7AdkQYXu/0MBbrWPR2W9pAtrFTTXdPyuLJASWrvOcDJpGVJzFFzY2oVvXaOtsHkPN87mbMvRqei7DELsgZOs1P4kYkCCqvijjhdg1QLhJLDnTWoIBwoPeiAI7Jw4y8hb14yEDNycvSwYTbApxierlDfqHuwi5AQdNG4QJP6g1A+JWYzIzXoz8bBFxfZKhePMngLHXO+3P6O8REEbZmtCnmh6FvFXBN9eVAMRM9a3xDpfPsMGiLivqXaeaG9J/LRIkoBqz47fZgCa5Mrvbc2684ZsM=
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
index 1ac1e327ac4c6..05626d9622b3d 100644
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
+ *	couldn't take additional references to the frags of @from
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
2.56.1


