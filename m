Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12D4B606A697
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZoVXvtNb
Received: by kanga.kvack.org (Postfix)
	id D310B6B05C3; Fri, 20 Nov 2026 20:09:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBAC16B05C4; Fri, 20 Nov 2026 20:09:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD0FA6B05C5; Fri, 20 Nov 2026 20:09:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 976676B05C3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:09:47 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04C5F160295
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:46 +0000 (UTC)
X-FDA: 85457344014.22.6B11D3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 583C4100009
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZoVXvtNb;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795223385;
	b=mivlG2pU0n2sKNmGXtRFrkbR5P6zRedVqi+4pZ9pKbPm8YAISaMl/GARaM29JqNNkshFXR
	xr0kvpMnQFr/h8Gu/CWvzQbgrYRXgJwMgjh0tj+CUAjzoJZBCHLGqmA4P0mqfuvkCgBL6i
	1CO00MAqcMVvFdRcImleencofht7tms=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223385;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8hNb8W3UGfxBQSao7zkr7/h6IjxifCFNO+cU+J3lxcY=;
	b=PPTM9INYWQxs+Qx9q/AbLYi6PFPcqGO/hZtFLZcYvId6/StdW7DZ2neQPxiRA91cP88t9S
	4F4+sW2K5nelxwNRXqyowhzB6tggTeDmV/DBlfkK5dA1qYl2Z+g+TIN04/NgPbN0l04cYk
	ctcZ+LO3OKLAP5/lWUNt6lmez9qInM4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZoVXvtNb;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7319442A0;
	Sat, 21 Nov 2026 01:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC1A1F000D0;
	Sat, 21 Nov 2026 01:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795223384;
	bh=8hNb8W3UGfxBQSao7zkr7/h6IjxifCFNO+cU+J3lxcY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZoVXvtNbUA36Zh0D2qs92O2EYjgL9cJWyeu8f/mRtJ+3M/8FRWPizS9/jDZ8yjHqx
	 gEJhhdjWf9Yuz2AgsqtEqy/uMmwqRP5rpAQxQH7VNebtonUy6zi++WqXk9r9wzhDJW
	 8db52UNFwybutKKBmGeNeRXcN/SY6Z3whHE1KBcbTg9TF/5nkzYVeh/N+fvUDNXGWp
	 vLqcy1Ul09fr7cyw3wyNq2ZbaLZRi2PBxv5PKoTh4AFtZvZ0/1qA1G51n284DjSEi8
	 Q7VkaH7rrF8Pp1mzgIuBg6x48bcswV4aTsFgL1ERzeyIBpmaSeLjaivBAC5GPfW/kJ
	 +nEzo/Y1Cs0qQ==
Message-ID: <sashiko-outbox-226481@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 17/25] net: Allocate small skb heads from PISA
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Joerg Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Jens
 Axboe" <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Harry Yoo" <harry@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Hao
 Li" <hao.li@linux.dev>, "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Jann
 Horn" <jannh@google.com>, "Catalin Marinas" <catalin.marinas@arm.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Simon
 Horman" <horms@kernel.org>, "Jesper Dangaard Brouer" <hawk@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Willem de Bruijn" <willemb@google.com>, "Kuniyuki
 Iwashima" <kuniyu@google.com>, "Joshua Washington" <joshwash@google.com>, "Harshitha
 Ramamurthy" <hramamurthy@google.com>, "Alexander Lobakin" <aleksander.lobakin@intel.com>, "Christoph
 Hellwig" <hch@lst.de>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Dragos Tatulea" <dtatulea@nvidia.com>, "Naman
 Gulati" <namangulati@google.com>, "Pranjal Shrivastava" <praan@google.com>, "Mostafa
 Saleh" <smostafa@google.com>, "Randy Dunlap" <rdunlap@infradead.org>, linux-mm@kvack.org
In-Reply-To: <20261120010655.467825-18-lrizzo@google.com>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <20261120010655.467825-18-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 01:09:40 +0000
X-Rspam-User:
X-Rspamd-Queue-Id: 583C4100009
X-Stat-Signature: qz4fq6zhg16crsjg64rkpjexz8fien9p
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795223385-446030
X-HE-Meta: U2FsdGVkX18jJZ2Db608ozqe2+piFSVfF5P+CWlFmu+aFllSS4VAkCQTrSMcelOesbmWvRNnw6mI7fA/jbJMiFH4X4teJe2wN0OUwcvnLa7r3JUW4tTVppdTnLdSTIivmd4zVr5ON9jcKmuZZkOjCO0zILW9Q7LC+Muu7TiyFxrhEJq7aACHJ6FJlii0z48fskTzPAluacn8m2iJngY82B7zpViBRWVJvZ/W5i/JcedXag3OP7+67mpqCUdzgNLgI+Mm/YRDhBt65GE1Qq/oGQHEDdFAlq1CXgc8xsxq7B0qU8noLSVyFm1VrKED+pmtxJuejR0DX00B4/0oeqE8euZWpfBvcXS+3z4O49Aof6TUZJu6ZNundfPux6BizGmLyv44StoVlVsVPnfaFc4dOnHB0Jyss4l+Z2Wm8AiNqnyu3dHluvPkUBsDLGXksnoACd24B9n0BqEhH+SK6VOa7v+7NLOyaX8pVsgrGTjWmt2KItpbjoCQhyea78D9QDOgErWH+hLPbzkPEpH5/Wxbloe8MNL0y128dG3Z8oeCVeXmUjcEvwxB+5kgHNQhME8lGbQfuruMyKIxvSm9c2nt6XVuNqZTDVFcQttrEnogwj/Dsc3vVMjFkit6XDFkGfQfsnG21rkTbYuCunoNVYFusM2+7Zyg60xnBV2F1RFoxu3UhQ+njguaY9Y5gakvJQuWJ4kzzogkg6SbLAe24V8dDXh2F2dkwNQlw+Pq4mknq3RxEHh7GiQoQ6Sp11xzIFHOcmKLZ7gXwQheMnt+HjR2W7/IqY7SGbHHb4Wsh8VOk1JyKjrHEnYbFOc3Qm9oLu+f5Ch3FMaoxA37K/XPm51eXmK9Wz4RVSKdgPd1ihLpNqbyLXgXADV19PKqBwuqVooKf9wE8mUz34s3P0k8G63EUU1nRBKaRk1Zo8L6Jd+xRZQ5CRy01EUddkH7yMGzpmYedOvJKLFmB+abx+h7aBz
 kdI0mDMW
 8p2U9EdN9VoAaiqLGPBWSwgMgIOCpnsesHxEh6HCqiOKY9A6Ab/Mz0TTEkcBuKGBGdngEDLkX1tz64b8DU62m4YcEDkVKwaK4DmeLYEBLcPNO7aofL+NfgzDnEI9Kf/H7cwrFGUQEzDmHgLe9PHWoT11X6kPJDMqocP+cvIKYai44uwA/0mBvsUiEvd2F/tl96kBYxK5sp+/weUXmEDfKHM0F8fxsO/yhSZ7ePCkGsoJvAKUn7TrglvGLld4a6f+KlWkoqVn5zpOmY08zunnmnI0+dRLDJN0hOFTssMbsQ2rO41QZ5cDvwG1L47JFvXfAUooC9peP0yj7LMSWxCxzBo5QxOM7+AoiX4z8+luCBn8hEROo05au4I77/r869jFlOjjvtF/tfh+XM7SCobekk1Clzmk3mr21dlFFoYW4AcPw3aZMM0e5sNF7hBVzLfKWKxIDu2yTuwt3nEuztqdjwT52MoVQdhgYiraX0oLqlha9oo6/NvonCn/7BDG0kqT3xk6ubF29W2nBqiu25uaK9mXFvUtPehy9WiGHlGrtsg5VaeDyReoUdArysD69/ki/NC8PkIweD7zd/iCLP4MY1aPNeoIAK5AGIIAs9ARELFz4eWrpOO9G5cPKCXyphHB2/x24guCju8j9hcide9Qsg40o2QZhcpU98O9w9SC399rkZLPVEUwDfxFpgUneF90YzLir8NTqV4EZR+/SpPTL8sU51RQmpIbEHAb3u0ekFxb7fUYJjKlsvvw5xc3R2zsPc3ZYSgcIyt85aavuvukwhydD6fXS4yB+0dmb5/pyyyXUY5dEWbMVBDKhkvsxm1WwQDsWdK/Hf6z4ydme0Grtnem3nnEHvv9+F3dbhNG5+QyMFA4iSSnr8awbhLKHggSKspUQVicASGorNls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] net: __GFP_PISA leaks to frag pages in sock_alloc_send_pskb()
--

commit fb32b2e4054bdacb45b319dad44d287251d24e33
Author: Luigi Rizzo <lrizzo@google.com>

net: Allocate small skb heads from PISA

This commit adds a parallel skbuff_small_head_pisa slab cache backed by
read-only PISA folios and updates TX skb allocation paths to allocate
small skb heads from it when per-device pisa_tx_skb_heads is enabled.

> diff --git a/net/core/sock.c b/net/core/sock.c
> index 56dea49baaec2..0599c7d1aa6d0 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -3062,9 +3062,10 @@ static long sock_wait_for_wmem(struct sock *sk, lo=
ng timeo)
>   *	Generic send/receive buffer handlers
>   */
> =20
> -struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long head=
er_len,
> -				     unsigned long data_len, int noblock,
> -				     int *errcode, int max_page_order)
> +struct sk_buff *__sock_alloc_send_pskb(struct sock *sk, unsigned long he=
ader_len,
> +				       unsigned long data_len, int noblock,
> +				       int *errcode, int max_page_order,
> +				       gfp_t gfp)
>  {
>  	struct sk_buff *skb;
>  	long timeo;
> @@ -3093,7 +3094,8 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *s=
k, unsigned long header_len,
>  		timeo =3D sock_wait_for_wmem(sk, timeo);
>  	}
>  	skb =3D alloc_skb_with_frags(header_len, data_len, max_page_order,
> -				   errcode, sk->sk_allocation);
> +				   errcode,
> +				   sk->sk_allocation | gfp);
>  	if (skb)
>  		skb_set_owner_w(skb, sk);
>  	return skb;
> @@ -3104,6 +3106,17 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *=
sk, unsigned long header_len,
>  	*errcode =3D err;
>  	return NULL;
>  }
> +EXPORT_SYMBOL(__sock_alloc_send_pskb);
> +
> +struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long head=
er_len,
> +				     unsigned long data_len, int noblock,
> +				     int *errcode, int max_page_order)
> +{
> +	/* Callers with data_len !=3D 0 (unix, packet, tun/tap) have no sk_dst_=
cache, so gfp is 0. */
> +	return __sock_alloc_send_pskb(sk, header_len, data_len, noblock,
> +				      errcode, max_page_order,
> +				      pisa_tx_head_sk_gfp(sk));
> +}
>  EXPORT_SYMBOL(sock_alloc_send_pskb);

[Severity: Medium]
Does passing pisa_tx_head_sk_gfp(sk) unconditionally to
__sock_alloc_send_pskb() cause alloc_skb_with_frags() to allocate nonlinear
payload fragment pages from PISA memory even when pisa_tx_bufs is disabled?

ovpn_tcp_sendmsg() calls sock_alloc_send_pskb() on an established TCP socket
(which has sk->sk_dst_cache populated) with non-zero data_len whenever the
packet exceeds PAGE_SIZE:

drivers/net/ovpn/tcp.c:ovpn_tcp_sendmsg() {
	...
	skb =3D sock_alloc_send_pskb(sk, linear, size - linear,
				   msg->msg_flags & MSG_DONTWAIT, &ret, 0);
	...
}

When pisa_tx_skb_heads is enabled on the egress device while pisa_tx_bufs is
disabled, pisa_tx_head_sk_gfp(sk) returns __GFP_PISA, and
alloc_skb_with_frags() reuses gfp_mask without stripping __GFP_PISA when
calling alloc_pages() and alloc_page() for the nonlinear fragments.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120010655.4678=
25-1-lrizzo@google.com?part=3D17

