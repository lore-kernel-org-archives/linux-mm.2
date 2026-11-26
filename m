Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56B3B606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 21:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nmK+azDo
Received: by kanga.kvack.org (Postfix)
	id 555A36B05BE; Thu, 26 Nov 2026 16:19:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506966B05BF; Thu, 26 Nov 2026 16:19:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CED36B05C0; Thu, 26 Nov 2026 16:19:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA0A36B05BE
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:19:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CC1140125
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:19:20 +0000 (UTC)
X-FDA: 85478536080.17.F62C690
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7A1D7140003
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:19:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nmK+azDo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795727958;
	b=YUroMGsGbMORUWAVNtwRQuOSUMmWNmYaB9ZcOD810m+Rx/hqYU35YkPR9/MDrpiqAXJJkl
	MHXvZbnNFmT00Lmu73SNNmmD3ZBHRg1AMXkD/7GFC0pf7qhk2XKwZ4jKCkLFQNxRcOHsT4
	Q73HzjwXXrmC8dhIJWyr6nhCfwY0pAA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795727958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7g0PF2rhm0R9Xo1OcuGfmkKtp0vvqib29xJ2PkeRIE=;
	b=fOSx8u5ZruyGIDY43cEdlJoaDUK7MMP//FmkpPjd+VRABvwmKuyhW4g3TFcdtZapcaLZn/
	S4+PH0G5FDP7m4Che+R9OhFwiXS8WMoLQ7N6kBvnqF10gfAf/UBlOzNI3FRX5A+HN1fd4H
	APZ5Z6KULGd3HbH5U95GnRWfF1UTEP0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nmK+azDo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0930561379;
	Thu, 26 Nov 2026 21:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4602E1F00924;
	Thu, 26 Nov 2026 21:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795727957;
	bh=T7g0PF2rhm0R9Xo1OcuGfmkKtp0vvqib29xJ2PkeRIE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nmK+azDom1PHTU7H8yvB0f4RqUfCdgs859IwtodDz2vMV5vCV1NX8WTon4Q0KNF5f
	 Z94d27mzbKCejbI/EnAqTIDZtThR5A9bWEl2TW3tqxmmysJRjOWINwCOIX182tvd+2
	 bBIbkRRXJkSy7F6206Y2qFGAazvL/zsW7lw8udwjnG5h/vnqY9ei3A4rTYovvAWnUl
	 ubuW/k1yG2LmG5zX3X84Lh+YQixDMb55SpGD4lYqTfqvQU8xOS1stQtRo3aFdc4EhT
	 D96Tzk4dxDiVGxTCC69KqQ5dEBvrB60eXjhBZAv44sr/vFOHbBFp0RnYatUOb6KI9l
	 D2qsHxnZR5Inw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 26 Nov 2026 22:18:40 +0100
Subject: [PATCH net v2 4/4] net: skbuff: limit folio refcount when splicing
 from sockets
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-skb_refcount_overflow-v2-4-a6f600a5634a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5778; i=david@kernel.org;
 h=from:subject:message-id; bh=T9uhC/xEmr2tuYoZB/8o6f641B8j3fTWqS2TXzJ8NJU=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI5Fpl9Slk7v/Na4NTqfarWO1YmNxwXTrn0IkH2zUPfL
 Q5XGgOMO0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjIbgmG/zWacwIKHqlvzj/E
 sVL303ruyLkLE14FGa14vlU3YVvf5lJGhleCX1LldmRrZZuyRSiKBiSFed+uupO8QG+//tl5C5+
 78QAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7A1D7140003
X-Stat-Signature: pzf9d9acg48pfh3965b6rbrdoi46dimb
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795727958-644690
X-HE-Meta: U2FsdGVkX1+JCgtXhThVdue/Lo+49JMxzV8OtTnxoHu/qvxpTvHwaDEPJmZkQUjMP+v3a0ZQFk8rfj876LhQJrYJIluY/VvYKb4B9slD4hPny83nNL1KJ01iyLxxIfL2FxitofNuD9aAsXNT/xsM2dm2ebPpUXT8uLak3pDmeFEvg1tj2BArVMjNgjHe3ALrVTYoBf7YNWiSFbJDBdaZAdQRZQ8TTsEdPPJqeii4HlR9u2pLV93Zr89lxeADBfOUnk/dbW0V22wrJWMvlBFkCn44GW+R7gP4YkQaWQbQ+Scov52BvGLgc1PYbHx2CrtOfbwizLjsIjGhdo4UC6RDSuTqrx95sqTWCE4pIfZalr6dJPxDGTgJOWJcr/UJhe+YsDsiX2jbfQApq2uXvcZGr87j70XJbx3ZrrsBlxekJNvlXtQkSCqcJ9Cbq41OHr2PoN+gBDzrS2puc0CcK1wMgh6uTdGK9q29LvRTW5ayrtUk4vgmDXmGodd7EmLhXe5MtmcINBN/w0Y62KnQ1xJLG1HTXzImnkl9xSFRFUNK4AI+EkouaqZKZPOc1Of/hu7LPvDSejL/KPr9JiscrFvDLa2RPejJ4E71wCB3mFh6dp/sgVkYfuXuLsOS4F95c+5Q6F4+yZCnFrmHLJi4DZgAPgcdqB6JUkaTDfRlAbsJ1eW+WJv+YofDYgmxm+NtE7NaAP8lVgjqwPosxvCA8MlGzqEZ5WFY4i0l5l1+2wqaqn6oeYinAFz5Qq8k4rbD8vzWKtKQ583Mgf7rFXcXANpp8WKniOteOG/HcI6CMuQFZ7fCNn8WbgL2FaMWXFFE+Ef0hHeuQiw1xpecbBefQKjBSRhkCVBzVLOZ2f5wiCWg0oxfgxL7/0Jl+/1QUdT/Irm9/ZRGoDQMPz20L2lQPsj0fyfdENRWRcrSA4zjU+U+WKnUjtpHnK2Ea9VJNBhffceteor/3bUxyAAFXDNjr70
 MCQouwnh
 SxDOYnMAAeKBuO5S2ob9UGN393wV7rZvAmK9xQ7XK14e9GuG2TNzGYxlwtNSmJ7evMBPt74JHrUeBLCgObILxpVXcSeWVsNeG5io+reWVYLNPU4I/w419YsWqjsqmZm8WPgN0uzcEKGgqs36H1CASk1PFp8KCB6MYZVUIlG5c4NrJiNWDlye7wMuEYPZF4jrFiIeCxCN8cNuc4nB9ezkyl/D3pLbIit8SWEchDT2RWj3B9V1lsKd8T8Cm5AJ2bTPISTDTVApZkqsZ/pJioswQv2Z4raxhAdBS+WGOPcSRVb4N/UPnL30v/KHIEb1gj1QgLerOuOrsrFBXlWdCiSJt0uNq96gt5e6XnSQE9nXE4MDedSiLOV67tymh2T4Cg8WDaczXBDmU9TLAxCBvxMnlPxMWUUX6Buy55iH+8bEEUDEgwlt9ypKOxzHE8KhqLHeJit6AAaJhyiuAyhZNYXelU26Pjtur5MYJIhJfZSvwBoLzCOlVlAslAMhXZ013daHqSULYecTgLisUynY+1EZz5OQouZYs4cxUfmAj
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
-EFAULT if that fails. To propagate the error, add an "err" output
parameter to spd_fill_page(), __splice_segment() and __skb_splice_bits().

If we could not splice anything, return the error from skb_splice_bits():
returning 0 would make the callers (TCP, AF_UNIX, KCM, kTLS) report EOF,
although data is still queued. The callers already handle errors.

Use -EFAULT, consistent with splice_folio_into_pipe().

Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 net/core/skbuff.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 957335bcc5961..ca5e27545b46b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3162,11 +3162,12 @@ static bool spd_can_coalesce(const struct splice_pipe_desc *spd,
 }
 
 /*
- * Fill page/offset/length into spd, if it can hold more pages.
+ * Fill page/offset/length into spd, if it can hold more pages and we can
+ * take a page reference.
  */
 static bool spd_fill_page(struct splice_pipe_desc *spd, struct page *page,
 			  unsigned int *len, unsigned int offset, bool linear,
-			  struct sock *sk)
+			  struct sock *sk, int *err)
 {
 	if (unlikely(spd->nr_pages == MAX_SKB_FRAGS))
 		return true;
@@ -3180,7 +3181,10 @@ static bool spd_fill_page(struct splice_pipe_desc *spd, struct page *page,
 		spd->partial[spd->nr_pages - 1].len += *len;
 		return false;
 	}
-	get_page(page);
+	if (!try_get_page(page)) {
+		*err = -EFAULT;
+		return true;
+	}
 	spd->pages[spd->nr_pages] = page;
 	spd->partial[spd->nr_pages].len = *len;
 	spd->partial[spd->nr_pages].offset = offset;
@@ -3193,7 +3197,7 @@ static bool __splice_segment(struct page *page, unsigned int poff,
 			     unsigned int plen, unsigned int *off,
 			     unsigned int *len,
 			     struct splice_pipe_desc *spd, bool linear,
-			     struct sock *sk)
+			     struct sock *sk, int *err)
 {
 	if (!*len)
 		return true;
@@ -3212,7 +3216,7 @@ static bool __splice_segment(struct page *page, unsigned int poff,
 	do {
 		unsigned int flen = min(*len, plen);
 
-		if (spd_fill_page(spd, page, &flen, poff, linear, sk))
+		if (spd_fill_page(spd, page, &flen, poff, linear, sk, err))
 			return true;
 		poff += flen;
 		plen -= flen;
@@ -3226,11 +3230,12 @@ static bool __splice_segment(struct page *page, unsigned int poff,
 
 /*
  * Map linear and fragment data from the skb to spd. It reports true if the
- * pipe is full or if we already spliced the requested length.
+ * pipe is full, if we already spliced the requested length, or on error.
  */
 static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 			      unsigned int *offset, unsigned int *len,
-			      struct splice_pipe_desc *spd, struct sock *sk)
+			      struct splice_pipe_desc *spd, struct sock *sk,
+			      int *err)
 {
 	struct sk_buff *iter;
 	int seg;
@@ -3245,7 +3250,7 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 			     skb_headlen(skb),
 			     offset, len, spd,
 			     skb_head_is_locked(skb),
-			     sk))
+			     sk, err))
 		return true;
 
 	/*
@@ -3262,7 +3267,7 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 
 		if (__splice_segment(skb_frag_page(f),
 				     skb_frag_off(f), skb_frag_size(f),
-				     offset, len, spd, false, sk))
+				     offset, len, spd, false, sk, err))
 			return true;
 	}
 
@@ -3272,10 +3277,10 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 			continue;
 		}
 		/* __skb_splice_bits() only fails if the output has no room
-		 * left, so no point in going over the frag_list for the error
-		 * case.
+		 * left or on error, so no point in going over the frag_list
+		 * for the error case.
 		 */
-		if (__skb_splice_bits(iter, pipe, offset, len, spd, sk))
+		if (__skb_splice_bits(iter, pipe, offset, len, spd, sk, err))
 			return true;
 	}
 
@@ -3284,7 +3289,8 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 
 /*
  * Map data from the skb to a pipe. Should handle both the linear part,
- * the fragments, and the frag list.
+ * the fragments, and the frag list. Returns the number of bytes spliced,
+ * or an error if splicing failed.
  */
 int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 		    struct pipe_inode_info *pipe, unsigned int tlen,
@@ -3299,12 +3305,14 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 		.ops = &default_pipe_buf_ops,
 		.spd_release = sock_spd_release,
 	};
-	int ret = 0;
+	int ret = 0, err = 0;
 
-	__skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk);
+	__skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk, &err);
 
 	if (spd.nr_pages)
 		ret = splice_to_pipe(pipe, &spd);
+	else if (err)
+		ret = err;
 
 	return ret;
 }

-- 
2.56.1


