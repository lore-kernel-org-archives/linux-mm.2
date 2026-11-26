Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB467606A327
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 21:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Oc03qaVB
Received: by kanga.kvack.org (Postfix)
	id 6B48D6B05B9; Thu, 26 Nov 2026 16:19:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63E4D6B05BB; Thu, 26 Nov 2026 16:19:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7C06B05BC; Thu, 26 Nov 2026 16:19:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18F4B6B05B9
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:19:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92B56C012A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:19:07 +0000 (UTC)
X-FDA: 85478535534.25.3C5691D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C45C720004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:19:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oc03qaVB;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795727945;
	b=aDuhp3NeyxQbKtUZQIkvc0/Z+IOJWzf+7/tHzykliODFtAUM9aZwDw6bA0djpmPzRFyZVs
	o9W34qNx/jv1ycUbXIxAnp/XxKXrjM6l0wSMKiHH8a9OE6TFyucoXUNhEJQawNPml9xeGC
	pkovYtUY+DFbaIfdiOt4qdJkcBJBZgk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795727945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BECvhQRh4+2QJTSzh2eae5Yl1mGEIFIrnDajqcoZhJU=;
	b=1+bgLUwH/IM48bgKlDbkRY2fTgwTlrKdA/ojPcHzMUt4ZwOtEjVLejcTBv/4DB3VbYqKmQ
	1vU5wqHMCjJec/PASTlBgIrvTnHC6MkLLcaaFo1WTH8/F3jgNB2UZ7SIsk9nPlhD44EU1K
	AN+9ZLcgY3JHgfh7aBb/nrYqFQKItyE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oc03qaVB;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 09D1141AED;
	Thu, 26 Nov 2026 21:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1F51F0089B;
	Thu, 26 Nov 2026 21:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795727944;
	bh=BECvhQRh4+2QJTSzh2eae5Yl1mGEIFIrnDajqcoZhJU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Oc03qaVB7N0zm8Q/tLoPqxT6wZstxIs8tp3UpFlIph5ls45TzCK+u5tV8qBhasSSJ
	 NSfGzhJG5z+mY/tV6zUunyW1NwVu/amoolNAkZJi4cPqqX4bhVdfAgvu6D/4qRB08M
	 BRG3ycg8q0IAm4H0pn3+bmCBQI9sjsZoJu7Ur9BlzZkdwphNEJBuyOqBtXkK2BtJoC
	 c50SqZswM0ROynDR6jab5vd961bjbLuGjLbDhI6dfZjhEwWKdYZ68l+hRHM+MG4UrG
	 m7xve5i1IDuU7zPUAz8dITMuPsApFbAY/urRzY5WDj1LXb8GFmG6QMsK9RhqrLEbeB
	 ZP7zu8XgLbwzg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 26 Nov 2026 22:18:38 +0100
Subject: [PATCH net v2 2/4] net: skbuff: limit folio refcount when
 rearranging skb frags
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-skb_refcount_overflow-v2-2-a6f600a5634a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5075; i=david@kernel.org;
 h=from:subject:message-id; bh=WAffQyLBI6rfibJehelEzcOeB9e8IRQYJFfmSALfK30=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI5Fpmlb32dL5eW4GActVHu8VWLlzkHKgRnap8y6fvn5
 rzm2b37HaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExk1w+G//5f1bn85VcpbtZ0
 3Vsd7Dl/W2nyiqIWo2VKmlNvbHORzWb4K/b6XvD+j14fI5fkHpVkEvnx/fGjC0uC/mxd+/2Fd9u
 TfFYA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C45C720004
X-Rspam-User:
X-Stat-Signature: pn8yukriq6iz1c7uzdn3diuajs18c597
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795727945-511403
X-HE-Meta: U2FsdGVkX1+bx5DqM+TvlrxxgNQUyI74OV6zXvewxmXxqxK5yrnV6M8mXAzKjBU4KrHSieX8JX3tPmjrewU3ooXTrbbR6tcbuDeXYf4jxLTPaMJX8b9AtobdvBTVFv9+CaE5nRP0QLfpaahLIFUWCBwoIOY5acOsv0Sh9iWovZ+CJMzgISB/ZUw1xNOIWWpxwrW1gV4e7kDSiCkswsG+CVL5KOLEsTCA02q5Rk/RSd9dw31XxM8yqM6+6JRfXyDjP9r4m+OG2zjtjAm+9GRknpc2LK4Q/sTVKcDgjtfQURK53e9ZmaMr1VvlGXyQwIDVyp0s70ZdP0MJfX4Xswk+hwr4sHCMGUcNJrPFazRKP4hmzap8olW4m+5wZ6V1IjGdmAfCOF/EsBL/iQqtLfzEeiO9xloZFa8FtWvHqcCTxUFclrVB2CPCYMaS/fJFpYHSIMpn5ibPrKuSsEDYLdB5BxP3b3xLYKWapAKWz9u9ydN+nHa3PUqPEYa1tcIan5wmXfWSRZDA4cEIhSbvHEeAwkJxlFp13zoAC4oH5jeeFceMFJxzEPSlk9iT2TL61DpC/GxcKx0ZZuOoccLwHxIdK/VHXFH9Hgi3wVc1t/UzRJQflx+ZRjp4hmkh4LjB2nstMsTMvDXe1fG3THyjq0sHT+KUggVqBW2xEIxmfLA4n/EaXIHmiqcD+BhF9iV0RpVvEE1Gu0zWH7hBNyS+Km/vXoBj1GCtt6bboGofQbEWi9qMfPOWf6BpPPZS3Sj81sb9OGBW8u3fSRdsFCBzFR592RuoWzScKxWZxJqvP/SiNVdWEZcJCzcwx3aQAhEhHR/sB8mGQ7jU+uanPSnicUj68Mkad/JnMfJUBDfzAFckbFtoGbGRD+IdrgogfWdVNjLC9HBCg5P4+jbDW0v8IC4p0IMvUJBOWtJvYA2nfXahljd01nLDpgdnR31WAxj9TXA26htC+3kwvRQsrbuCJ85
 z9dsOt8E
 bqI4G0CsvoqA0brDzuYFAmTLTYUk8I/+HuHcM4l32XzyQMCFAZBKUgx7/KcEy+0nYLLPi7KmuVdx9TSZgo2gdoNl8ea70oBCUwNDGcI0PuftnvmiW7idmbJToWtNYIgKfKEy49k36D0axbN33YhkolxayvIPIRe3l27awMidpUbknjimzh+hXr5oxw/nTSR2fhzc3jjrnuM4/szSS+Sb6Rxqj81nQIuFJbL71u8c1GsFaKB6fKTtQoExVxx25dRju+94s0UEHe0tKa/k52FTTrsFv1VdQq1K9nEISs269jTtNIYM6RifiKFPefphNlUOHnY6tN/xFWtO8Wns6qCudVXlnEOtOHYVf3meSdgNODyviOeBDM9IkEwN7UxfYN7rX6YRNgUfOC2XaLAUfYvlFshaBulxM3tFjUP94aShulo2CNDXNOcTTxVZQgJAmDpUQQ66ig6Vh1cyQpApJ3Ujcg2FdA/klKGQOp8sh7l5Df9FnngBjmFXr2MLSgMVwM0zf8Kug2GZ2ru+jS7lJZ/8OUpDHrVvQ58AULOnJIN9CJOVmy+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Various networking features take additional references to frag pages
that are still referenced elsewhere when rearranging skb frags, for
example software GSO segmentation, TCP receive coalescing of clones, SACK
shifting and MTU probing. This is an effective way for multiplying folio
references held by an skb, allowing for exceeding folio refcount limits.

This is not specific to large pagecache folios, but with them it is a
lot easier to reach the refcount limit, as page table mappings can cheaply
create many references.

Let's use skb_frag_try_ref() and skb_frags_try_ref() in skb_segment(),
skb_try_coalesce(), skb_shift() and tcp_clone_payload(). All of these can
already fail, and their callers handle that.

skb_split() can still add one reference when splitting a frag. But each
split also allocates a new skb that is charged to the socket, reaching
the refcount limit that way would require a lot of socket memory, and the
references go away once the data was acked, so it's not that relevant in
practice. Making skb_split() fail is more involved, so let's leave it alone
for now.

Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: stable@vger.kernel.org
Acked-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 net/core/skbuff.c     | 32 +++++++++++++++++++++-----------
 net/ipv4/tcp_output.c |  8 +++++---
 2 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 05626d9622b3d..6da51ad8fd440 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4338,7 +4338,8 @@ static int skb_prepare_for_shift(struct sk_buff *skb)
  * the length of the skb, from skb to tgt. Returns number bytes shifted.
  * It's up to caller to free skb if everything was shifted.
  *
- * If @tgt runs out of frags, the whole operation is aborted.
+ * If @tgt runs out of frags, or we cannot take an additional frag reference,
+ * the whole operation is aborted.
  *
  * Skb cannot include anything else but paged data while tgt is allowed
  * to have non-paged data as well.
@@ -4421,7 +4422,9 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 
 		} else {
 			skb_frag_page_copy(fragto, fragfrom);
-			skb_frag_ref(tgt, to);
+			/* Nothing has been committed yet. */
+			if (!skb_frag_try_ref(tgt, to))
+				return 0;
 			skb_frag_off_copy(fragto, fragfrom);
 			skb_frag_size_set(fragto, todo);
 
@@ -5160,7 +5163,10 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 			if (!skb_shinfo(nskb)->nr_frags)
 				nskb->pp_recycle = frag_skb->pp_recycle;
 			*nskb_frag = (i < 0) ? skb_head_frag_to_page_desc(frag_skb) : *frag;
-			skb_frag_ref(nskb, skb_shinfo(nskb)->nr_frags);
+			if (!skb_frag_try_ref(nskb, skb_shinfo(nskb)->nr_frags)) {
+				err = -ENOMEM;
+				goto err;
+			}
 			size = skb_frag_size(nskb_frag);
 
 			if (pos < offset) {
@@ -6301,7 +6307,8 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 		      bool *fragstolen, int *delta_truesize)
 {
 	struct skb_shared_info *to_shinfo, *from_shinfo;
-	int i, delta, len = from->len;
+	int delta, len = from->len;
+	bool cloned;
 
 	*fragstolen = false;
 
@@ -6374,6 +6381,15 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 
 	WARN_ON_ONCE(delta < len);
 
+	/*
+	 * A clone keeps referencing its frags, so we need our own references.
+	 * Nothing was added to @to yet: we only steal the head of @from above
+	 * if it is not locked, and the head of a clone is always locked.
+	 */
+	cloned = skb_cloned(from);
+	if (cloned && !skb_frags_try_ref(from))
+		return false;
+
 	memcpy(to_shinfo->frags + to_shinfo->nr_frags,
 	       from_shinfo->frags,
 	       from_shinfo->nr_frags * sizeof(skb_frag_t));
@@ -6381,15 +6397,9 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	if (from_shinfo->nr_frags)
 		to_shinfo->flags |= from_shinfo->flags & SKBFL_SHARED_FRAG;
 
-	if (!skb_cloned(from))
+	if (!cloned)
 		from_shinfo->nr_frags = 0;
 
-	/* if the skb is not cloned this does nothing
-	 * since we set nr_frags to 0.
-	 */
-	for (i = 0; i < from_shinfo->nr_frags; i++)
-		skb_frag_ref(from, i);
-
 	to->truesize += delta;
 	to->len += len;
 	to->data_len += len;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index cf3ddc055d48d..043838d996404 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2710,10 +2710,12 @@ static int tcp_clone_payload(struct sock *sk, struct sk_buff *to,
 	}
 commit:
 	WARN_ON_ONCE(len != probe_size);
-	for (i = 0; i < nr_frags; i++)
-		skb_frag_ref(to, i);
-
 	skb_shinfo(to)->nr_frags = nr_frags;
+	if (!skb_frags_try_ref(to)) {
+		skb_shinfo(to)->nr_frags = 0;
+		return -ENOMEM;
+	}
+
 	to->truesize += probe_size;
 	to->len += probe_size;
 	to->data_len += probe_size;

-- 
2.56.1


