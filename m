Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7258606A334
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 21:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GyXeg09V
Received: by kanga.kvack.org (Postfix)
	id 5F4E46B05B5; Fri, 27 Nov 2026 16:21:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57E176B05B6; Fri, 27 Nov 2026 16:21:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41F136B05B7; Fri, 27 Nov 2026 16:21:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0B746B05B5
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 16:21:54 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 646771604C4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 21:21:54 +0000 (UTC)
X-FDA: 85482171348.17.D5C77D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id BE74914000A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 21:21:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GyXeg09V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795814512;
	b=kWDegyi7QN35dyA+d2MSYyHVGhLKSatnHuBfEKotwu/TYkJo7h3I/QEZvYgsH4/uwbbKRn
	7x8ljlFxCSxKyhAtwLDhRC/i4kekEiVLg1VLtF2qZzMebMNgmPDnjRIwOVPqI500uMJNW/
	1yQ9Go9ijSZwqspxixfgc9AcBJu73UQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795814512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YIRTDuQE4r/aXiKDRPP0uS7lZ5Ydoef491BfdGmULdw=;
	b=up+KAvXyxQQ8E1yGGNZ3JtHILTXRBgOIhbBaRpdsM6YvDXfkjH2ykRjT4Gudm2HP+7JxZx
	ZzeAg9BvjNmMzSNL/g2+v5ob7k/R7EN4QMgwuPzY+OMvl9VmdMnqAXwnt+5jMUMLWCnPDP
	50UDhtAeDc/IpPNLAD/iKvMXC0JSa28=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GyXeg09V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5989E61B36;
	Fri, 27 Nov 2026 21:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDD91F00897;
	Fri, 27 Nov 2026 21:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795814512;
	bh=YIRTDuQE4r/aXiKDRPP0uS7lZ5Ydoef491BfdGmULdw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=GyXeg09VB0wAl0TmCP+UxG6RrRmfqXEG/4IhxJ1zoEH9+INmjqQYNKNW4+b5QtRfR
	 a3BcfF8GGG9UpO8uDuxoTgZdzukxLv6z835qNLUvGZFLqAvcsIvzNZXers5+YqN++K
	 Vd5kyeQlCd0MtrhRzUSsUEMiaobcSmqLmrd1+G1HmEweLidfTv69X4gvyXHbzWJ8eP
	 yYA9yyYffm5lqcZcc88Ppw9imIM8tpLNdK5ncLgOXbvjk8GQnt1xvVYxIdaelCsYTk
	 6f6CshpkX6nsGDDWnyC0tNwO9L6M+wdB49AHjiNNsJ9Xi6fk5sUqHarMJQrYdb5Vtc
	 tK03Xs9SeMDUA==
Subject: Re: [PATCH net v2 3/4] net: skbuff: limit folio refcount when
 splicing pages into skbs
From: netdev-bot+sashiko@kernel.org
To: david@kernel.org
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, sdf.kernel@gmail.com, willemb@google.com, horms@kernel.org,
 akpm@linux-foundation.org, kas@kernel.org, songliubraving@fb.com,
 hannes@cmpxchg.org, riel@surriel.com, willy@infradead.org,
 ncardwell@google.com, kuniyu@google.com, pfalcato@suse.de, cel@kernel.org,
 jlayton@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
Date: Fri, 27 Nov 2026 21:21:50 +0000
Message-ID: <179581451032.3135.17667643003292457918@kernel.org>
In-Reply-To: <20261126-skb_refcount_overflow-v2-3-a6f600a5634a@kernel.org>
References: <20261126-skb_refcount_overflow-v2-3-a6f600a5634a@kernel.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BE74914000A
X-Stat-Signature: a787rp6yuy4q87bs8cf787y8uadc56fi
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795814512-469970
X-HE-Meta: U2FsdGVkX1+PV2fYfVg9wEFVeA/tuC3Ng9g1uSkFxDNcjVsbnap5GvIW14hiM8xZSMRMZ2YDDbb/jywAjdlFSsLXUNRxXG0mgftPLi4WN9n5+TI+ui73DN4sA3IQOl805Uz8CXKqEuYWqnlzLZAJOZv7pi3BPEa3xp0SMvFdGXXhHL+wfHoc2VX8XpM2n98Gs8WvvrH8zUqiP7VtqZNFMiv5qz1HrPHigUIz7oVuIS9HCngfMo1Wa7VLR9DbJ6g6RDtHiwiilW2vyhZwqBCb3lfhrgy5hh7kcBjPPt7VoBSvDhkCzhxD3zypMv31UpV2FNxKWglqb+0MDz90HaItNK78CNlLcQ/LZscpGqhK91DKZeq1FlbH6Z2xpvMPNsnmDdq+KMFiYeKrLmWXAzsec+qShnlok8ZvwvinlNmCOxmG6r2hD3DuuV0V+wj35hz6zbWDU0tS22LQ+gsEs3rnGn15TkGQeaUKXGxd02Hl8bsrGVTs2u9LZJicsLc04MmrfmQ9VUZ2l0yVSnWFd4pnz8qFalyh7EKwV8bmgGMlyVPRvT/9ap5aPJoUV+BzvVvQnziHTNZh0TJbvEDsV0sEfmrfvrzUWXf3wlSUjfp5cgnddFfbjoIvHJt78FMz5NbQMmTQbQFRk6BfCPjhJjFBNxJl7aCFp4qgh8XXUhSFKSUHgZY09CxHgSH4p7TiW7PFjPb2XQGiFm54GhH8QDiSh1FzQIhN/HZGJTxomknxwu9bzRrPYvhw/6h45N6lGySYMji+qYNg5NEYvQxPdy44FyjKBGcvCMe/IivL0aNiea3Nr3gCp3RGq8C5s5+ipfJ9mt5mgA/pBIowBGofLYP1Yciatg0Ik3Spxbv1JrVTeiXflzdUVdjpqnb8jV0vqmNRxUvZHu0uWHjLc6w5Ed8XSPHd76MncXWIWhG+HjttK4LUNKQK1AacKtyQ7HKBrRWdVkwYQuL5XOn8I0ydxhM
 BAcW212p
 ZKUgn0K7qkqfxRCYLrgG9CGfsn83ijA6q0XJvWdBniRwrKZpXB3fDxcPs3EI3qXS1fZ/RtT1XP5LBGHANlVW8AmJsQV8KgrsO1qhfDCAp/9OVFwC5eay04qfEiNvyV8NeOlJ1zdc/9yBV8MI5KPNGaLNQXWLma4bj1Im35D8bqG31y+TMWJVNdpx3Vv+zB/jElrS6ZVzqxB2pLE3jGSqHAvnycXPXTjH5bpj4wrHmxvGWgyEuW5kk2IRVnECkpOM3f0l6yyK+N1uvGvNNQEqb42Ddhw1ZG8fn5z+hmKXm1OZffmvEbjWhwIWmf9jg4u91r0UTkCmV1J4qb0mZZH0kODrh+U8VtQ0nEoIdL6jlFW18CDHcDdjHqU5uR+pSHUIYHHE2Frb3nlGVBG8dD0uAh23U6PAQM2pu79g0hSKcj65Oftxo5fDvFR6prbiyl1zA1JU6KR7atqG31MthFRBreaTBF/gza5XgJ8rJM7bNsS/qtvPL934tv8tR6m5OGS5WCeHau8rROhaPS+oSdYv/65ex+XGDoGc9T58lPm9v3a6joIMAMVREaDUkNQv6chq6Fc+l58hTyIfzMTJE0ec+jA2XCLJ4MVYD06PTJROXwG43GPR26Vh8DSFvwv26q98wD/NrQn3F4Zfp9JuEUvf0FfV/oszMjP0I/D8+k+oeNg1oRtPZIf8vF2p4mlyv9TSdv9fA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The refcount-limit fix does not cover kernel TLS, so the case
  the commit message uses as its example (sunrpc/nfsd sending pagecache…

--

net: skbuff: limit folio refcount when splicing pages into skbs

This commit changes skb_append_pagefrags() to use try_get_page() instead
of get_page(). In-kernel MSG_SPLICE_PAGES senders that pass pagecache
pages directly, such as sunrpc, can then no longer push a folio's
refcount past the limit. On failure it returns -EFAULT rather than
-EMSGSIZE, so TCP does not just retry with a new skb.

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 6da51ad8fd440..957335bcc5961 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -4714,8 +4714,13 @@ int skb_append_pagefrags(struct sk_buff *skb, struct page *page,
>  	if (skb_can_coalesce(skb, i, page, offset)) {
>  		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], size);
>  	} else if (i < max_frags) {
> +		/*
> +		 * Don't use -EMSGSIZE, as callers would just retry with a new
> +		 * skb.
> +		 */
> +		if (!try_get_page(page))
> +			return -EFAULT;
>  		skb_zcopy_downgrade_managed(skb);
> -		get_page(page);
>  		skb_fill_page_desc_noacc(skb, i, page, offset, size);
>  	} else {
>  		return -EMSGSIZE;

[Severity: High]
Does this cover sockets that have kTLS installed? The commit message uses
sunrpc/nfsd as its example. With kTLS, though, MSG_SPLICE_PAGES never
reaches skb_append_pagefrags().

With software kTLS the call chain is:

tls_sw_sendmsg()
  tls_sw_sendmsg_splice()
    sk_msg_page_add()

sk_msg_page_add() in include/linux/skmsg.h still takes the reference
without a check, and it has no way to return an error:

static inline void sk_msg_page_add(struct sk_msg *msg, struct page *page,
				   u32 len, u32 offset)
{
	struct scatterlist *sge;

	get_page(page);
	...
}

With TLS device offload, the MSG_SPLICE_PAGES branch in tls_push_data()
passes the extracted page to tls_append_frag(). That function also uses
plain get_page(), and the reference is held until the record is ACKed:

net/tls/tls_device.c:tls_append_frag() {
	...
	} else {
		++frag;
		skb_frag_fill_page_desc(frag, pfrag->page, pfrag->offset,
					size);
		++record->num_frags;
		get_page(pfrag->page);
	}
	...
}

nfsd reaches these paths with xprtsec=tls:

- nfsd_read_splice_ok() only turns off splice reads for krb5i and krb5p.
- So nfsd_splice_read() still puts pagecache pages into rq_res.
- svc_tcp_sendmsg() then sends them with MSG_SPLICE_PAGES through
  sock_sendmsg(), which goes to tls_sw_sendmsg() or tls_device_sendmsg().

nvme-tcp over TLS also sends pages with MSG_SPLICE_PAGES and goes through
the same paths.

The sunrpc client does not seem to use MSG_SPLICE_PAGES, since
XS_SENDMSG_FLAGS is MSG_DONTWAIT | MSG_NOSIGNAL. The server side is the
case that matters here.

Should sk_msg_page_add() (or tls_sw_sendmsg_splice()) and the zero-copy
tls_append_frag() path also use try_get_page() and fail with -EFAULT in
the same way? No other patch in the series appears to touch net/tls or
include/linux/skmsg.h.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261126-skb_refcount_overflow-v2-0-a6f600a5634a%40kernel.org

