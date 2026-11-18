Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB504606A33B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 08:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iovxfvO0
Received: by kanga.kvack.org (Postfix)
	id 011A96B05B6; Wed, 18 Nov 2026 03:33:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2B3F6B05B7; Wed, 18 Nov 2026 03:33:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E410B6B05B8; Wed, 18 Nov 2026 03:33:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B58D66B05B6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:33:12 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 501091C3FC5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:33:12 +0000 (UTC)
X-FDA: 85447575024.20.244392D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7F97680008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:33:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iovxfvO0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794990790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tNPg0ACmVQdDcbUvahoJ+sX2NLYiOTZE/5SlqvfFlLo=;
	b=1DlSbjyzZnwjU/d8oQ0NJi3Y2Elat61p+3VNzAFC062UzXw8Tn19KKYog+eJUnIu3magDV
	BohWn6wvp7sPKUWia4a8qBeRNsuDVEWS7NNWkGVFcuh3+6Fx2pi4ujmte0acHDow5BWX54
	sBuWy2X5h8fg1VM7s5pPYKZLG5WSHrI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iovxfvO0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794990790;
	b=7mz5sWo20nHk8VA0Jzl9clTtWvYp2Z2MAqxu0C8wgVNyVNZ2RbT/JARuk4Q4mYpY4RZb/a
	yH7C9OKV0z9ZMhaDAHkpNZL7p38yMwwZuKROh9VnUH3c0AwoCnIB8G2L/m8Sebq8BSBgfW
	K8N0ODM4BwXojAw3MKYtGqwI10fZlD0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0FD7F61188;
	Wed, 18 Nov 2026 08:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AD21F000C5;
	Wed, 18 Nov 2026 08:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794990789;
	bh=tNPg0ACmVQdDcbUvahoJ+sX2NLYiOTZE/5SlqvfFlLo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iovxfvO0Xz1ORd/v3dwYcwfajxh+hupUCrkqoNdJc/YiYYuz02pVptDqZY3MokE2U
	 Hw8f4MKhRX7BtTItkijvVUxVFwZ0cNxxJJl9Fm+dFcKEfsLJMOB1R0aGwwD1ixwZ8I
	 9ScDBkhMiRXtJjjE1VabhNWWvKXuY46JjIZq5sZkjGfkDT6EmdvYj/OQ7VCf5QM138
	 2daTDskmGranbE7KArDs1j5HHfHeUggjnOkmApltTYKiUhsbR+tX5OS+l3cYN8Li1G
	 AsQJ5BhqwBqotMh7paO9Va6MUl7REQP49T5miDehA1QE1GE9TxpPVWfdJP3MRZumdR
	 0TI1XMudHx+Cg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 18 Nov 2026 09:32:39 +0100
Subject: [PATCH net 2/4] net: skbuff: limit folio refcount when rearranging
 skb frags
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-skb_refcount_overflow-v1-2-5551b4954c3f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5075; i=david@kernel.org;
 h=from:subject:message-id; bh=2F4qM0zZmhIpBb9Mf21D4ViNEGscC/lfRDW/fzP+9Hs=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLL+Jm17Y3kx9+lKbbWF+/YXF/xgSox8cWaP0Ys3Bwp2u
 fItzNHN7ChlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAicfMZfjJqzVi45tP+hw/S
 NqzsVd6zieNYzbKAwDkW27Qt1U+a7ktnZOh9N4fz7ASJa3/90hqYuhb39300ihB+LOvVJRucYLN
 tBQMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: tusepqug86gh1tk8ac7ttmex6qzw6jec
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7F97680008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794990790-265046
X-HE-Meta: U2FsdGVkX1/cLUnAhdv/I1W+OY1fZajOQZ4fMjyapsks7s3MaTyUWEIBxOX4xWNhD+8SatqX/2zydjW9M1LFBw0sYLtiGYZ2VABoHab9PSrpPneP5O8ijrKdWYRtm0SX3QoR3Q8+Vy3vuD4fYsG4LRoy3Cdp7kNWl1ZtxJDdRCd4OJoMURJZWK1M+GhKwZFhXa2/YFhC5gFIhhwY9fxNhazSqVcQaesKOqtI9UGuyghSvuyDo3lzzAjWONAsKEyrI9VDG4GGqMpMScYjCTLyGyW7azcH1Hxr6eAAjbJ2MyVPQ3unc9qUIh4ULWU6ivzFtJ8F9KWp5ZTX1DcYya17oGY8I7q9pjeFW9G2jPf/2hHtTMPReM1/sZMbL9pIDUcnAExVz7SrlueFIVgX0LUAAMcvznJJDKIYsYkC/Oqq4sdll5xau0QxCV9Tq0NiHhOBr7yhfdp1vsTvY6lofvCWQQTU0f/p8qs8O4ryAqjp2fDULYDu3ThGzB30e4bBeJ25haPhxFFsFJHw5/8ZVWUAaV8tNDJEoAo+I9kuXvAsQ+dmjHnR+VKcJ+v/fTsPO4p6O2dnyXmusdUem5M2Ew4vsoo6hlbOwgXRMQLPabDgfiGkOtNbIFsY/Gse3fpovxKMpv4TFZDr2BFudWHOKT0jeSy+F8u6xbUkREgnlp/MLaakLtgHnhp7SBWicSCX5Z/OBKEpSuVm0kpIKWFYb5X+9bi/a7D1b5+G8+E1NFz59INfzFjsv+ifPTQI1cnIaJm6zfy6M4/9aIgzPhBduuj6zoE3bWbuXYlZ6/84pgXvwHuJQDtniqLLOEuI6davO8uC52OvuQSLQlVDWGNw1+ZP/67vmmOiyq/tw7RqaZALoog9AFe6dGPgjX2bFK6gFrLMaSPuQSGKPIDfBwcjowvv0eaXypt6qlGqv2MRH0u+fvVQ1ZYKZli2LFwovsk1XQPAO/B68iFGfKbYiLu3Iyl
 UV/V+hdK
 cZ60nJl8GOTQhJVuGUUGLJTu5IcFzUfD7+K3ClHb0DWxThVhz3DarBjwFGhQXzt+X4nBBAlD83w7WZ5rFdtfhObaWYVugDPnoquGjxQRyfQZeE83JUIpO5aXgeeINm+BmynjdSUhSY9AwgbSXMLPfWaAmKPH2yvhNT6XO1BNXDZUZ/xP/qp2cP8GSFczOf4oV+Pd3KWdMSL2IwC+YJYQe0y1XdBzv9VJWI7IFxglMtgz44GjslRWAbeWy7Q==
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
index 447099b39deeb..bed1c8c4c6b99 100644
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
2.43.0


