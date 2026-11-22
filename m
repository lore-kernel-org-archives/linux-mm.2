Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C50F606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 09:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dd0ckpvV
Received: by kanga.kvack.org (Postfix)
	id 60F1D6B05B2; Sun, 22 Nov 2026 04:19:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7FD6B05B3; Sun, 22 Nov 2026 04:19:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FDDC6B05B4; Sun, 22 Nov 2026 04:19:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21B396B05B2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 04:19:45 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 84BAB1C3F4E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 09:19:44 +0000 (UTC)
X-FDA: 85462207488.04.CD0680D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id DFDFF20002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 09:19:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dd0ckpvV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795339183;
	b=vrCb8Oi2MDbD6l2cN65HMUT2by8Eg4S+Dgy4unURkTd9Ew25GBNR4Vru/uYVwXPPXTMG43
	HyBv2tDoOqqVtVt6p+x/6c9Z/37CP3rzh50hxj1kLSlVqgsf+Hi1s8/iykRsqzWfnSWMH/
	jDEsYlQ97q8JjwKz2isi0RPaCNVVu5E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795339183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fVNYRzFGTGfYNkMSOeZUACCFY7N+y5n5CkCmP6DMOOY=;
	b=34FDVOcadhltgPl8LQZbUn7I3ulwzMkf5kguksP1K7FC4Rl/n8IuOMQ7OvRR12+ecef2k0
	VNmMXrSOVc1GjiHkwBefxs3G2kofeQjEt5lOGVxoKSO7JAtQvLWY1hZNgLSRgjN3fFB+hX
	bO0908gUlFazc7qCbSk+j2HEyP0cRXs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dd0ckpvV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D79FD41738;
	Sun, 22 Nov 2026 09:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB5E1F000C0;
	Sun, 22 Nov 2026 09:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795339181;
	bh=fVNYRzFGTGfYNkMSOeZUACCFY7N+y5n5CkCmP6DMOOY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=dd0ckpvV9iU7+l+MXGIYaoxsyzfzMGuyX+mHtXwLU3oOVA4/OiyW8JrxgW0I3Xqec
	 7FgAEaDrhiJB092xBEqWK/s49hNFgLMbFpjyHvt1qet9i0msAlDiKZ1ZBj83NddO9q
	 /4ArRBggAXbyey3y8ParLgxacHl4TUbBEtfcROGQUrtS2o8AdewpqfAF9kSnlFwmg9
	 4rb96Nm62Qvp7xfkr+AwcQESkV9ASMn5NQ+aFeAESjEOglV978WkqaWpD4meoMx1ZT
	 vXjqkR4MwyY1PHsPR6/47P19h6xmDgyClyhSkm8PA3oBVhADR618h0X5rvVc2jotl3
	 HQ7hJASzf2Ugw==
Subject: Re: [PATCH net 4/4] net: skbuff: limit folio refcount when splicing
 from sockets
From: netdev-bot+sashiko@kernel.org
To: david@kernel.org
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, akpm@linux-foundation.org,
 kas@kernel.org, songliubraving@fb.com, hannes@cmpxchg.org, riel@surriel.com,
 willy@infradead.org, ncardwell@google.com, kuniyu@google.com,
 pfalcato@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
Date: Sun, 22 Nov 2026 09:19:40 +0000
Message-ID: <179533918041.3135.8460911693239501161@kernel.org>
In-Reply-To: <20261118-skb_refcount_overflow-v1-4-5551b4954c3f@kernel.org>
References: <20261118-skb_refcount_overflow-v1-4-5551b4954c3f@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DFDFF20002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: cop39rpquf934nokoea6opk7wnjxsak6
X-HE-Tag: 1795339182-700865
X-HE-Meta: U2FsdGVkX19YacC1UPq99wtORXZfIvME2ABBa8xHpw3Ou9KewFQNvRAh3OktsViPR7lIXDD9lpMTocaVgiVOSOXMwR3MurTR4osZTR0qJBpU8pdTGfX4vSPrN73ojHUBKRwu6K7XOmdUjqfgoQlBtfxHATQpjuBC9F6f/W5EepH6QVG6w7QlW9qpqEOr4cqi/1P5e5IYBP1Qs0SGAFizIQhDsXr0tpWKr/IvbvPOd7lhJAYhgoevEHXGO7GPV4paIyHNXIqifvnFP77iUwYakPYz6bZrXtA6NVifk2kr2alCUXDY7YpN+4avCVkrdueu3czbqbU7+aod9804yK+G9bUFfugCy8THqutAf6KUqsf3AiSOKoW+DDD/qTAYxQJkeV5qE9XtwjWyuFllYMtIThaeoHRWWhTFaCX6U1Db2TX4Rm/Ng6EWZRQDZG2UcaZf/ci287/OTBYMlW6aDiR+uEjgPAaGUAn95T0x93UEztHiT0tClDUX98ZKrAv6JEq1AqTlEcAQA8IOfZuDWfFo2UAREve3OQjVUfiYYd9cII6xi5/RHz/gDJn+qyujG6s7f1QuIutyFdnQfw4FFoBf9dNwclH5LMo9RoyEuaFhh8Y7gBMkyYMuhbncyLoDbOE4KLiS4jiJ1fXdhmOYQoxyQREg62mHhMLgITHlOU94PuOhtYtzUVJQMQ1Jc9Dck6dITs634rskNuQf2sXtt5cqXvOIxvuqCvWS7VchYwE8Y61cLCWHFENhe+KKmzO+g0Yz7ktII5jN9CWQ6OLjk4cwBtXEUi8oJM5M3O360TE23yd/V2G9eLobGssW3lUOZ7pM68uYcVue/KvVlo7dOUKrrDzxYoDjfHM/eRcLxjF5m/Vx5frRpb1AJMQHmasn1qAqfThAjyISHp09fGEXL3exruc0A/tGQAVPmZpwSkEJH5ILaTCxPIdc3xolDY+TclV+pZ5ADh/Qd7yr5nfEAgD
 bWsuf5eG
 cxgxGifliA60onQrnbbd75JWxNXkxtlhcmXZZmjBhec9qZlCJYgImaZaFRcqOvRabywhKDkKVwDHDgVnqtnU7cCltCvzNcxMLugIh77FfXCE5Vkc1KXSjl8eyIjQlb6OhHL+868ahx8mIlDaJ+VFvAoEIZrMnY2dfo7mSsS1U9zE/GB6HTiWhcs1ED2ltLQst/5DSW+3qqyWZmKDTqkcQ2rp5YaZt4XR6ROQwm/mYGLDzVkQyRZZ63uN1Yc+3vYm6QzQHOTC7d7cY7iDAX65/IIdDUBh4Hqn4GiNBmuCr76h3oU2bOR905ic8Xo2/izp4NrLRweoB8yMG7dSVZlVJ/xyshwflTu7NQc3T2BUteAEyGHIhX8eP6EU/XznJLCA2wOe9/j+0pAFass+HIK/WNsLmiZNJHpgiAKJs1fBJWb3fkwq8t1A0yZ4OTXB2mITtlp9kMhiu31yRV12yKCIJ55EQp+w7rkkwsfy56pI4DpyTml5PJm/zn3ZbHf5TOFnC4WHt8Srrwf0CFoibeeT/glkY4MzIJ4gNFiC4gmqsGdWTGnKYerl/ICEDJUuuC2uLQxgTEV6rzUQ3HTwIkOpWRxara4qOQh3Vg+dIFArX8SZQTMRqe+M1ZNSSNuNqT25y5e0TILIx2+eDcp8SFxl0zSAa+L5drm9FgJUJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The new comment above skb_splice_bits()
  (net/core/skbuff.c:3295-3300) says the function "Returns the number of…

Pre-existing issues:
- [Medium] skb_splice_bits() still returns 0, which callers report as
  EOF, when nothing was spliced because linear_to_page() failed to…

--

net: skbuff: limit folio refcount when splicing from sockets

This patch uses try_get_page() in spd_fill_page() so that splicing from
sockets into pipes cannot push a folio refcount past its limit. On
failure it returns -EFAULT, and the error is propagated as an int
through __splice_segment() and __skb_splice_bits(). skb_splice_bits()
returns the error when nothing was spliced, so the callers don't report
EOF.

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index c937d74eed6ac..b73fef7a1b460 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c

[ ... ]

> @@ -3284,7 +3294,9 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
>  
>  /*
>   * Map data from the skb to a pipe. Should handle both the linear part,
> - * the fragments, and the frag list.
> + * the fragments, and the frag list. Returns the number of bytes spliced,
> + * or an error if we could not splice anything because we could not take
> + * a page reference.
>   */

[Severity: Low]
This isn't a bug, but is this return description complete?

When spd.nr_pages is non-zero, skb_splice_bits() returns whatever
splice_to_pipe() returns. splice_to_pipe() in fs/splice.c can fail for
reasons that have nothing to do with page references:

	if (unlikely(!pipe->readers)) {
		send_sig(SIGPIPE, current, 0);
		ret = -EPIPE;
		goto out;
	}
	...
	if (!ret)
		ret = -EAGAIN;

The reverse case also exists. If linear_to_page() fails in
spd_fill_page(), nothing gets spliced, yet skb_splice_bits() returns 0
and not an error.

Could the comment also mention the -EPIPE and -EAGAIN cases that come
from splice_to_pipe()?

>  int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
>  		    struct pipe_inode_info *pipe, unsigned int tlen,
> @@ -3299,14 +3311,14 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
>  		.ops = &default_pipe_buf_ops,
>  		.spd_release = sock_spd_release,
>  	};
> -	int ret = 0;
> +	int ret;
>  
> -	__skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk);
> +	ret = __skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk);
>  
>  	if (spd.nr_pages)
> -		ret = splice_to_pipe(pipe, &spd);
> -
> -	return ret;
> +		return splice_to_pipe(pipe, &spd);
> +	/* Returning 0 would make callers report EOF. */
> +	return ret < 0 ? ret : 0;

[Severity: Medium]
This is a pre-existing issue, not one introduced by this patch. Can the
spurious EOF that this new comment describes still happen when
linear_to_page() fails?

When skb_head_is_locked() is true (a kmalloc'ed head or a cloned skb),
spd_fill_page() goes through linear_to_page(). An allocation failure
there returns a positive value, not a negative errno:

net/core/skbuff.c:linear_to_page() {
	...
	if (!sk_page_frag_refill(sk, pfrag))
		return NULL;
	...
}

net/core/skbuff.c:spd_fill_page() {
	...
	if (linear) {
		page = linear_to_page(page, len, &offset, sk);
		if (!page)
			return true;
	}
	...
}

That 1 is passed up through __splice_segment() and __skb_splice_bits().
With spd.nr_pages == 0, skb_splice_bits() then returns 0 here.

The callers treat the 0 as end of stream even though data is still
queued:

  - unix_stream_read_generic() adds a chunk of 0, breaks because
    unix_skb_len(skb) is non-zero, and returns 0.
  - tcp_splice_read() breaks with ret 0 although the receive queue is
    not empty.
  - kcm_splice_read() and tls_sw_splice_read() return 0 directly.

The old code also returned 0 in this case. Hitting it needs severe
memory pressure, where sk_page_frag_refill() fails both the high-order
and the order-0 allocation.

Would it make sense for spd_fill_page() to return a negative errno such
as -ENOMEM when linear_to_page() fails? That would send it down the same
error path as the try_get_page() failure.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261118-skb_refcount_overflow-v1-0-5551b4954c3f%40kernel.org

