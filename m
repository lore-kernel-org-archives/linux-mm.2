Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FCA8606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 08:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AhRyx/iR
Received: by kanga.kvack.org (Postfix)
	id 3BB676B05B9; Wed, 18 Nov 2026 03:33:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 392716B05BB; Wed, 18 Nov 2026 03:33:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25A1E6B05BD; Wed, 18 Nov 2026 03:33:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E3F466B05B9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:33:22 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56ECCA06B8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:33:22 +0000 (UTC)
X-FDA: 85447575444.12.7E16271
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 955A718000E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:33:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AhRyx/iR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794990800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DPYjQSpLLKGvu/CktwvaDUi/oogU/7rVXfO7DnoaPk=;
	b=PkBb7LC67d4mdM4Qdq7kSI/ka3/m+FIi6L+WNN7048tymIflqh3g70ej8zUCcfE9m0PC0U
	3L8ZiwG51tdwPx4pDmCo/TH4a7/LfXrT5M8yLkEeVusvIy79hpHDdgg5KmeH08M0mtx/DI
	dvcVFaHIeI6kydLCCtsnFQ/gNfcOwFY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AhRyx/iR";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794990800;
	b=vh4dO+LSGRhk4jtNiIGwF/HgC7HB3CFOoExencLNB6WulpnkLLgbBEDQkCRxF2v415RhxD
	BvVvTJ6YyoCoBApRghISGLB/Jy5R/NFOvgmx9cnogAy1SMSsUR9iLhWLcoTHI2UhPQxyyj
	5oZzH/J0ShnI8S9S7tcSBwQfFeDA4wU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3267461FA3;
	Wed, 18 Nov 2026 08:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881341F000CE;
	Wed, 18 Nov 2026 08:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794990800;
	bh=2DPYjQSpLLKGvu/CktwvaDUi/oogU/7rVXfO7DnoaPk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AhRyx/iR8609PFZufMjUaQpeUjXIkXZ3CgtN0KGHLlCdFOm6Vr4kqWC2oU84YKGhR
	 ATCdXaKaR0MidjlxNwXp8KyTadBLuQW0z0gu9aMxakwRTfKU65kmpp5y17GxONTD42
	 sE1aEW+slkYcXdbNIJqTvrBRImFkq+/SX2kVgpm3BwfMtqr4PHGmzNoARauZoNgb0B
	 V09LTWfLzXcg+d4b1tNYM+hurES41ZlQ262NE6iphJ+GVncdTieDzTAzpMl1cr0kby
	 8HzIELXG/Kwbp1TLc/lkLEonpHZvV66g0npOhZO7OQ4uZboRuJpwEYdpW2AwEBujR5
	 kqUjG0NS16xSA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 18 Nov 2026 09:32:41 +0100
Subject: [PATCH net 4/4] net: skbuff: limit folio refcount when splicing
 from sockets
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-skb_refcount_overflow-v1-4-5551b4954c3f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7665; i=david@kernel.org;
 h=from:subject:message-id; bh=OJSTu3EOnCJVKNCuHU2Z5gm29MaQJSf5tLrXQ6DteMM=;
 b=kA0DAAgWx+nLGEVVu3kByyZiAGr9YrajXVl/ZgZiJ03eOlSXnV9F5HIQsfWyvOHIGUC4Xzua+
 Yh1BAAWCAAdFiEEUlPfMOnprn17Rg4Dx+nLGEVVu3kFAmr9YrYACgkQx+nLGEVVu3kpEAD7Bu1l
 ySlp03zpckUvXtRG2XrlJc+HQRnbrS2meXXyVeAA/RVSQrlfyMBZTs6D/lBoHwbagpNm3OifvxL
 ngbF2yhUK
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 955A718000E
X-Stat-Signature: 6jr7dqm9aq8ge3nx3guhizs8ezyuprao
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794990800-328417
X-HE-Meta: U2FsdGVkX18PaNn7cyA/mCqn4kpzYl9XOOx2CksbutEDJmbigQQsBM3lowdsIKviSMAWxO1j0GND8t71DjwN7P6dl+5UP3wxuZBVI6uok0/WHWzs1w1fQur4z6/9f3L1WpQEbMS1Pawa35lhZQxZpjUbg4lnh+Y1Db/n47KqNxSQwzNW+yyUVvRG5zDXNiqfdxjisIHWjb58Hx+ZjVamYsZsdPfakAZrDpV/czQx2GcVuFhsfZwh8vU903jwFphXtyA6dyId8Ie4ePztbnyS5lgQBesQKcv2O3o7iCBHxsS4oOTlxbzH7DSrsCtYUP8A0fOtwoAdFxvdAXgQK0HT9BQQ3Aq2OdcU2Rw/ZjiROU9NA6MqVKQvetPQOTAqaHzcO155kY6Rv5grmaZ0FdFwllSG2OoQKfOVgUE8ugLPOurT6lhPgBqsdTaKcaedLkXaU8HmiHlx/d9/JW/on37d4xxYPQKglq1ct3TiBHrXdLkZTjk5AlKpn4R6FCv0Iep4WSeM/1O77NEkd/0CHgGsONBRwAoKk09REIFEycooGqzJw0e5k3OdldLV3ivSEuJy45C0/4Y0rjR0qEyH0pXvCMVe/ENbgubEjaLLQE7kVQTaEOMIYqbxVS6EyqAg+JhxeV0+VAyVcwSJ5WJmKk2b7pfFdOeevbhYKm4vFqkPfwm/UWSJNgMgR1ELkZ12qR6J/5QKEmXOnRNBLLdGxOVnDOho0DhQFeJmuF4cgv6Wx4+ROTlWZ+k6c3G8HN8lRBsfDgjiFpARs5yHacLL6kFMF6H2mvLAvbRkerweREGo7xN6+Ep+C1RYtcwlAk+SdpaopS5BfK4y1Xf9Q9ypvs+//XZhfgQ1MBtwFI9R83PyN5S99vgMUadfy29m6U9rzJDJjGdNsiSh1U4M1eA6mIBMB2368PsbBPIKTC3uDqf+6IoVcWiFErkpBO8zjhKkCUeBLjKsOtPsm9lvbErtAEU
 i8r8nmmQ
 QvIWXtW4EcrdsCZLsCeAtAG+hOnV/HEidVSAJZ5784kHi1pidfAkZHSFfT2gsJh+hK4vf2u0EcYdOPpsgwvOqeG7DhvyICZfq990oKA3fo46x6ybvRl4+4jzF5oso8zKxU/caSFrAC5WJaiH/8frRgvG2/u7RD9bGBIfXJJRqRsYelN+jwi6RTeAJsQjpO9SQGPfgMsgBptBmk9hj7gWWN3KNKMZug6WSjrnM3MK8gq0rING9pRy86F8dfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Various networking features support splicing data from sockets into
pipes (TCP, AF_UNIX, KCM, kTLS), whereby spd_fill_page() takes an
additional page reference for each fragment, while the skb keeps its own
reference until it was fully consumed. This allows for exceeding folio
refcount limits.

This is not specific to large pagecache folios, but with them it is a
lot easier to reach the refcount limit, as page table mappings can cheaply
create many references.

Let's use try_get_page() in spd_fill_page() and stop splicing with
-EFAULT if that fails. To propagate the error, let spd_fill_page(),
__splice_segment() and __skb_splice_bits() return an int instead of a
bool. Keep returning true/false instead of 1/0 to reduce the churn in
this fix.

If we could not splice anything, return the error from skb_splice_bits():
returning 0 would make the callers (TCP, AF_UNIX, KCM, kTLS) report EOF,
although data is still queued. The callers already handle errors.

Use -EFAULT, consistent with splice_folio_into_pipe().

Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: stable@vger.kernel.org
Acked-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 net/core/skbuff.c | 90 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 51 insertions(+), 39 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c937d74eed6ac..b73fef7a1b460 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3162,11 +3162,13 @@ static bool spd_can_coalesce(const struct splice_pipe_desc *spd,
 }
 
 /*
- * Fill page/offset/length into spd, if it can hold more pages.
+ * Fill page/offset/length into spd, if it can hold more pages and we can
+ * take a page reference. Returns non-zero to stop, or a negative error
+ * if we cannot take a page reference.
  */
-static bool spd_fill_page(struct splice_pipe_desc *spd, struct page *page,
-			  unsigned int *len, unsigned int offset, bool linear,
-			  struct sock *sk)
+static int spd_fill_page(struct splice_pipe_desc *spd, struct page *page,
+			 unsigned int *len, unsigned int offset, bool linear,
+			 struct sock *sk)
 {
 	if (unlikely(spd->nr_pages == MAX_SKB_FRAGS))
 		return true;
@@ -3180,7 +3182,8 @@ static bool spd_fill_page(struct splice_pipe_desc *spd, struct page *page,
 		spd->partial[spd->nr_pages - 1].len += *len;
 		return false;
 	}
-	get_page(page);
+	if (!try_get_page(page))
+		return -EFAULT;
 	spd->pages[spd->nr_pages] = page;
 	spd->partial[spd->nr_pages].len = *len;
 	spd->partial[spd->nr_pages].offset = offset;
@@ -3189,12 +3192,14 @@ static bool spd_fill_page(struct splice_pipe_desc *spd, struct page *page,
 	return false;
 }
 
-static bool __splice_segment(struct page *page, unsigned int poff,
-			     unsigned int plen, unsigned int *off,
-			     unsigned int *len,
-			     struct splice_pipe_desc *spd, bool linear,
-			     struct sock *sk)
+static int __splice_segment(struct page *page, unsigned int poff,
+			    unsigned int plen, unsigned int *off,
+			    unsigned int *len,
+			    struct splice_pipe_desc *spd, bool linear,
+			    struct sock *sk)
 {
+	int ret;
+
 	if (!*len)
 		return true;
 
@@ -3212,8 +3217,9 @@ static bool __splice_segment(struct page *page, unsigned int poff,
 	do {
 		unsigned int flen = min(*len, plen);
 
-		if (spd_fill_page(spd, page, &flen, poff, linear, sk))
-			return true;
+		ret = spd_fill_page(spd, page, &flen, poff, linear, sk);
+		if (ret)
+			return ret;
 		poff += flen;
 		plen -= flen;
 		*len -= flen;
@@ -3225,28 +3231,30 @@ static bool __splice_segment(struct page *page, unsigned int poff,
 }
 
 /*
- * Map linear and fragment data from the skb to spd. It reports true if the
- * pipe is full or if we already spliced the requested length.
+ * Map linear and fragment data from the skb to spd. It returns non-zero to
+ * stop: true if the pipe is full or if we already spliced the requested
+ * length, or a negative error if we cannot take a page reference.
  */
-static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
-			      unsigned int *offset, unsigned int *len,
-			      struct splice_pipe_desc *spd, struct sock *sk)
+static int __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
+			     unsigned int *offset, unsigned int *len,
+			     struct splice_pipe_desc *spd, struct sock *sk)
 {
 	struct sk_buff *iter;
-	int seg;
+	int seg, ret;
 
 	/* map the linear part :
 	 * If skb->head_frag is set, this 'linear' part is backed by a
 	 * fragment, and if the head is not shared with any clones then
 	 * we can avoid a copy since we own the head portion of this page.
 	 */
-	if (__splice_segment(virt_to_page(skb->data),
-			     (unsigned long) skb->data & (PAGE_SIZE - 1),
-			     skb_headlen(skb),
-			     offset, len, spd,
-			     skb_head_is_locked(skb),
-			     sk))
-		return true;
+	ret = __splice_segment(virt_to_page(skb->data),
+			       (unsigned long)skb->data & (PAGE_SIZE - 1),
+			       skb_headlen(skb),
+			       offset, len, spd,
+			       skb_head_is_locked(skb),
+			       sk);
+	if (ret)
+		return ret;
 
 	/*
 	 * then map the fragments
@@ -3260,10 +3268,11 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 		if (WARN_ON_ONCE(!skb_frag_page(f)))
 			return false;
 
-		if (__splice_segment(skb_frag_page(f),
-				     skb_frag_off(f), skb_frag_size(f),
-				     offset, len, spd, false, sk))
-			return true;
+		ret = __splice_segment(skb_frag_page(f),
+				       skb_frag_off(f), skb_frag_size(f),
+				       offset, len, spd, false, sk);
+		if (ret)
+			return ret;
 	}
 
 	skb_walk_frags(skb, iter) {
@@ -3272,11 +3281,12 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 			continue;
 		}
 		/* __skb_splice_bits() only fails if the output has no room
-		 * left, so no point in going over the frag_list for the error
-		 * case.
+		 * left or on error, so no point in going over the frag_list
+		 * for the error case.
 		 */
-		if (__skb_splice_bits(iter, pipe, offset, len, spd, sk))
-			return true;
+		ret = __skb_splice_bits(iter, pipe, offset, len, spd, sk);
+		if (ret)
+			return ret;
 	}
 
 	return false;
@@ -3284,7 +3294,9 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 
 /*
  * Map data from the skb to a pipe. Should handle both the linear part,
- * the fragments, and the frag list.
+ * the fragments, and the frag list. Returns the number of bytes spliced,
+ * or an error if we could not splice anything because we could not take
+ * a page reference.
  */
 int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 		    struct pipe_inode_info *pipe, unsigned int tlen,
@@ -3299,14 +3311,14 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 		.ops = &default_pipe_buf_ops,
 		.spd_release = sock_spd_release,
 	};
-	int ret = 0;
+	int ret;
 
-	__skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk);
+	ret = __skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk);
 
 	if (spd.nr_pages)
-		ret = splice_to_pipe(pipe, &spd);
-
-	return ret;
+		return splice_to_pipe(pipe, &spd);
+	/* Returning 0 would make callers report EOF. */
+	return ret < 0 ? ret : 0;
 }
 EXPORT_SYMBOL_GPL(skb_splice_bits);
 

-- 
2.43.0


