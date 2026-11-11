Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84049606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QRHQjvRA
Received: by kanga.kvack.org (Postfix)
	id 878B76B05B7; Tue, 10 Nov 2026 20:33:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829A66B05B8; Tue, 10 Nov 2026 20:33:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73FEF6B05B9; Tue, 10 Nov 2026 20:33:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 476E96B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:33:19 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8F1BC01D8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:33:18 +0000 (UTC)
X-FDA: 85421115276.26.93BB5C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 166D8180004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:33:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QRHQjvRA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794360797;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZm5/VQJz2eTrpQ78JUXhGZETDj9k7QexvtB6Y4GVHE=;
	b=IpRj8Q/6/01Wr2pOX81fbNW8XqPb0KYAyYj54JwierrnxyCBWAXFu4f3ACgbv8cUBfSMXE
	a+oNUSDnZu7AchSA1+h1C/Y9awAAna/EM9OiYwbAKyYBeXAC7sAkFAZ+/e/Dl1uLCAU1pD
	1MmIU49bCs0L4MbP7nSKoNdprh9XrFI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QRHQjvRA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794360797;
	b=E45xtPFvvRMPnisA8i6aOQdDiWRSUE5/CNynYX3qQcW5BVd1kj8JwFHASwWsscSrmspwWx
	Uc59OmPJWlsjyik/j9FfkyS71fd33D8tmYdd4pjs8mwewhAoQJX+YkZmhAv9oNZUZ4hxeu
	2SBT0a9HpoFuIDcEX7LhkYJyC73kppI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 437D6612B5;
	Wed, 11 Nov 2026 01:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9261F1F0089F;
	Wed, 11 Nov 2026 01:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794360796;
	bh=mZm5/VQJz2eTrpQ78JUXhGZETDj9k7QexvtB6Y4GVHE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QRHQjvRAdN5m56yil0weABHcnGiCD/Ldzx4va/9DqMPioharKPM2Zysr1X3l3j0pm
	 Lr47CqmGiBmweAkweujUiDbEjsAYeyHmRC/jgI6r3GziLm+xAL0EV4aTFdFy/ClmaL
	 Zxieux2yIPLTgHlvrSR0wxToRKPIFNwaiM50MmhbPME7/ujBHWd6ISz3OXncBnQ4dg
	 X1cQvki10S8C87SliVVopXepXmA4Fz48GItab6D5y9VssW90jgqKk+OZlIycNzABid
	 oVVxIH+IPRU4GutT9FkfLvB263LRwZ1MJIwp3z6sr9TdS2q9naQ3Lm0oWrsBzpK3xl
	 NLgQjm47dn/Mw==
Message-ID: <sashiko-outbox-208052@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 17/25] net: Allocate small skb heads from PISA
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>, "Joerg
 Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin Murphy" <robin.murphy@arm.com>, "Christoph
 Hellwig" <hch@lst.de>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "David S .
 Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Matthew
 Wilcox" <willy@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Willem
 de Bruijn" <willemb@google.com>, "Kuniyuki Iwashima" <kuniyu@google.com>, "Joshua
 Washington" <joshwash@google.com>, "Harshitha Ramamurthy" <hramamurthy@google.com>, "Alexander
 Lobakin" <aleksander.lobakin@intel.com>, linux-mm@kvack.org
In-Reply-To: <20261109182533.3594984-18-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-18-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 01:33:14 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 166D8180004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: zypncx5xqptpuftnfz1za8bdifts8n3u
X-HE-Tag: 1794360796-940691
X-HE-Meta: U2FsdGVkX18TvA4/PkFnWDRIPE9Uj6DZijUAPxEiqCXVwKwU7G8f1AnCIMHu301X7U9iSASoVg7qbph5WLZIYV2L7xIZfvz10mmUQhtzJ+7vyYRWur1IocwSJ9krvrdSZpbD+0bOewAlKzDGKAMgu5MFujGLoepsHpuUDDAfBHtT7KCArul3JcxWr4J0WkI/wLMgZ6MaMCMYSWpICoaBZqGeGjzCjV5cwZZiHXD1580YUHkwwiI2J69gyWIuVMJogo6PZkgT1u7EjUgcg6rYwzdVT4iQit+4FTDy6/LSGOzfZpgBwjTLUb4gd2jBXwzFBijZypgl7J+B9ybk2Q5lLTl638S3xwKVHNJOQhShmPJ+uvL4+uOmjUUC/Oz3310TUAJep48HZ4Upx3L/bBaf35G6UkSsgdlUGIOJQivUIcnof5c2YoFZvFoc4mvDDltEB6bcz7AmvOSANLhkdlCGNs0fdMHIjk1udLuLgl1eNL/6DPYbs/Bzet5pEZTdCV6vFDaVy+DwhUcmY9wjRorKxI7OawkSUKN/PVG6lo4/DKM+fL+2gk0SqxUNdDWyiG9TEl8rjy7+zj0vkhNATCpLq1W/p6kUOvqWNiTh2nBMP+hZkExy96oDvcyDlMpOSllwD8230Kc198Cglmnxouizv65ffIUwz3kQwMZwQdD3D3niv6K0XM3PtUWBLYz9HbtRvbiEUUYhmfqkXZX8JDchbpMlkK8n6zJD6UXAfr2Xzv5wHA2bvVPuhMhUdtRr8yHRrRxV8rP3g+x4xFy3/VTOuyd/ws6F1w6lOA5baSOfZLEXI6JBcKDc3HDXXPy+frCUnvGZxmDvj9fzOR7oFlGUPOhbeEQ9We6y9WAsyeZjMiWKTBPiEonBUZap3XykPYK5uCi6ZshHW1RdNirq/hcpplhzwGiJmYEXqGk10pkVj9dcyFPzE8sXFwCd7TIoaxC12Nv8Wk/FQU2ifhoaCcs
 A5Twbn+z
 +6xCHxk5FAQ/hNO2KcdLBqEmplaK9qzZnN1UNThbicpBR9Sy93Lo6d8IkB9SqDonY4k2BdLhJiYNEi2m/o0bigWzWXqTq6TUJmcUtTwd1y2VE0X6DuUIXDhCNakE1uvSS5U+Y1kzgTUZg4SEr2u9lIX5hjAAVySygHfzJstm6zyIVLZ3PryOivqdUGN6v/7Xx9mhjqhUIoUuIiXncrG31LKMdMxkU/HVx1jbYOqTqKNtjhmDvriIt/hhTaAmshRaQ6VO23ounO2P+5FlcQ+uxCJMs26LXJ+xT3PiYO3X+BPNVLa668fWXG4aI+FXHayM5MjcDOxmOF/enDxTTyQyFOEkMEyyYEGPs6Ri4KoAbJ6BHHjEBJ6HGU6QEfqZ9jRpCiQibMHMo8W24PAS0pPLyY7A2u+zBsM02Rw6tdTkF1Yi+SbnWvGPMIEVLDrer2TMvC+1mprxcYEmBvGUvH03NH3EKqsOav0xgdVEKDYMYGehIeuLSb07SJRWZM03weuB0LQGRDMWpPbaUnkPwzVuk0hAoy99jdzCopEP/Ctq9AQbv6R9E2Of9vk7z5uX10t3IRyVDfK7QIekXReEfg63Qx1b+rl5cbdpx8fjpLH8SXGz4wAum399W2OqpyKFh7pqO5QeazTOhuqJMHxaw6cYQ/3gi0P6zSGtv8Gko
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
- [Medium] net: raw_send_hdrinc() uses sk_dst_cache instead of packet
  dst for PISA
--

commit 37f3bd5cfa3158313d9a63615631730f2ababf39
Author: Luigi Rizzo <lrizzo@google.com>

net: Allocate small skb heads from PISA

This commit adds a skbuff_small_head_pisa slab cache backed by read-only
PISA folios and allocates small TX skb heads from it when per-device
pisa_tx_skb_heads is enabled.

> diff --git a/net/core/sock.c b/net/core/sock.c
> index 695fefe316925..0ddb5e57f4969 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -3061,9 +3061,10 @@ static long sock_wait_for_wmem(struct sock *sk, lo=
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
> @@ -3092,7 +3093,8 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *s=
k, unsigned long header_len,
>  		timeo =3D sock_wait_for_wmem(sk, timeo);
>  	}
>  	skb =3D alloc_skb_with_frags(header_len, data_len, max_page_order,
> -				   errcode, sk->sk_allocation);
> +				   errcode,
> +				   sk->sk_allocation | (!data_len ? gfp : 0));
>  	if (skb)
>  		skb_set_owner_w(skb, sk);
>  	return skb;
> @@ -3103,6 +3105,16 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *=
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
> +	return __sock_alloc_send_pskb(sk, header_len, data_len, noblock,
> +				      errcode, max_page_order,
> +				      pisa_tx_gfp_sk(sk));
> +}
>  EXPORT_SYMBOL(sock_alloc_send_pskb);

[Severity: Medium]
Should raw_send_hdrinc() and rawv6_send_hdrinc() also call
sock_alloc_send_skb_dst() with &rt->dst like __ip_append_data() and
__ip6_append_data() do?

Both functions still call sock_alloc_send_skb(), which checks
sk->sk_dst_cache via pisa_tx_gfp_sk() instead of the per-packet route and
then copies the entire packet into skb->head.  If a connected raw socket
with IP_HDRINCL or IPV6_HDRINCL has a PISA-eligible route cached in
sk->sk_dst_cache, sending a packet whose per-packet route uses IPsec XFRM
(for example via msg_name) places the plaintext payload into a PISA page
before encryption, violating the !dst_xfrm(dst) requirement in
__dst_tx_pisa_ok().  Conversely, unconnected HDRINCL raw sockets have a
NULL sk->sk_dst_cache and never use PISA heads even when the packet route
qualifies.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D17

