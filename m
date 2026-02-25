Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13A85EC113C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 17:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 257696B0092; Wed, 25 Feb 2026 12:57:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205736B0096; Wed, 25 Feb 2026 12:57:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1083F6B0098; Wed, 25 Feb 2026 12:57:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F20E66B0092
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:57:33 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1DA7BA840
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:57:33 +0000 (UTC)
X-FDA: 84483736386.29.10B297A
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id A1A9F180008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:57:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=doIZJMao;
	spf=pass (imf24.hostedemail.com: domain of almasrymina@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772042251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Om7WA+0rDJMCyh+EuthvxH1P/DwUlMRij1gLg5qOqPQ=;
	b=llGz0qSYktqyJq8XJGJO1EptJNTpv+Yn5LfTSzeMG1QhEDDes0LMzsgck2cHabQT+MYVL9
	bYVI/vpger8OSTcw2SWoXJOAYBrtGfSX0GjU+CjDmL+qmBbgL1qMesqr9GjsReYWlftUaQ
	VfrF996TN+gBCTgW66fHjl68a8C2TEE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=doIZJMao;
	spf=pass (imf24.hostedemail.com: domain of almasrymina@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772042251; a=rsa-sha256;
	cv=pass;
	b=36AfpMz61YSH+g5Fv57NOfGfDq1AsZaot9qwQg6wvCtYWG+V5mrV05VyP6MOgyZEUa59GU
	pU7/klD/HH8noAY+t/I2IbftKLJkiFuX2zkRz1K5eXoFX/vWU0ZRROibAxE9H/4zihoSNP
	wbZZ9Xkp9DEHVb/CqiYLoJXu/fmTYQI=
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-124a60cc9a1so497c88.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:57:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772042250; cv=none;
        d=google.com; s=arc-20240605;
        b=LUK6JDmkw8Nji7chA9AOLmuzJnL83b6n2fF83X5YQUZv6/RIu5+oFb14Jtgd3pcSPj
         lt/4i7ZA2GTWz75tE4H/gPEX5iEWxmFXrRFzZbizynGgvmbf3/I2NUJm3BgywGOqFyoc
         GhyqEukqbq4ShTn1zIII0v/8xS2FgGYx6/wJF6zdR98ZSP1jf+lVvGjOPolpzAV3yvlw
         UdXnyujhnVax6gMwQKOA/gR8VnSUZNL2cZIQiadF2r4Ycis/Geh6HD6bvqImhNF3eqfl
         3vozQpE+7YR4jkNPTDWG6tv9JaxPfBbLKZmcRoyL+fgG2z4OeMYD20rXduX0DGZk4546
         OFag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Om7WA+0rDJMCyh+EuthvxH1P/DwUlMRij1gLg5qOqPQ=;
        fh=eQSt8hbEegt1D1/xP1zIskIW/vvUjg/CPKDQhBfoBuQ=;
        b=WihgpDNyZw0Gil2aobPIEMMi6BvZ8OYJB6oqEseKeR/YOGdK0ibSNcXL9UlsNi0CB1
         t4FykAyWbVYp76V7ZxguajWXarwFv0nm2KMAENghTI/LBF/lQxYu7yYSsXTwYFZSowJD
         iWUAjudWUZt4MIAKy401Unhq3EaAknupurR5tA7R+sKi7Wn3fzMdCVaFNatqFYqwX31p
         Mwsv4jWnMDClW7PcJqezac4cNTaPceX469Rj0bIGeSTslO+1jM7MomC2jyVdI0OC6LXY
         7jpdoeLk/bVkOVXhEq2ekFoEIRqhw/pqF2D/7Am+roqq8xiMifCVvLRMGaMF6o3i5bfe
         NGFQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772042250; x=1772647050; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Om7WA+0rDJMCyh+EuthvxH1P/DwUlMRij1gLg5qOqPQ=;
        b=doIZJMaogGlcPztc9fRJXQ6hQ9YcaXH1MgdfiIsgv54MYnXrbYQXGRps41vrD4L9UL
         dMB9X23OT4l+p6qzKioPwqZBQhWaYoTnnVjNYFaTS/6CV8vz+eyChhI4dTjmdsqCpfmd
         Onoau9409jyV8X1wgxuORuAt6DPWD05i8jOiJFWyhe1+cCYayE3Sy6j43IQu7tAhZyG5
         Yu5EJQLvtK4mZ5zVBYA6os5JU18AA/WleO7qxIIe7uQsUng/dBBLOsLrHCPMLiVwFB4J
         oN+FLCQtf/f0ppvvZVvdNiv2AtoJyRSRADIaOXC5qndssUw+rGIS9XW1hP/AxlYeH6Rm
         8mNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772042250; x=1772647050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Om7WA+0rDJMCyh+EuthvxH1P/DwUlMRij1gLg5qOqPQ=;
        b=Q0Rzw1D5wL6tvnxyH/LD3zYkpifMKovwE1+lEjw92At3KzET2WGiMSpf/HW6zuiJtz
         KTcM603/lghOvl2pPftWhSo5eD1r4+zz0HmlS7JTCoacm5sZRtDoL/ejp6U8XCDKcYpy
         C2Bq60wW4eVYSto6eQkws0VTgKWMPyHjHXcwoDsqmDRIKxayOHFJTyVtIb7Cwne4t248
         RbqeHyhYyYD3hHgp4i37pnUDKKZ/bM19ZhNPYgcuIiP/ZU5n8LRhXQJg1npQ1KIRR0MW
         9JEfdzxLpxUzmgv99vrgi55PtRehIqb1VJMbQ66NvIBoBaI6wnNM3wPcZ9yWu2xf0/Zv
         7Lng==
X-Forwarded-Encrypted: i=1; AJvYcCVeVbuYP/a0p3mHe63E4IYGmAEaGLFq5mAfVTiMzl3MjMCeoN6kH1OWBbqxahsyVxN/WBsBijK9bg==@kvack.org
X-Gm-Message-State: AOJu0YxPSN4E4/lCbDSYIliec2uHyc/loIHs43cZ0jEoDWoPYy7Y0WxL
	jAUgAT8wb3UBt3bdXkXa/JzIQxr0w34Y8yIWSsE/pked92ass0yRZNPzPSS7X2BJTQyqgpl9phj
	rSPx1ag8NnUcwPcjeb7j9xxK2hjnYDPBBVqe9eP4i
X-Gm-Gg: ATEYQzxBxZtVOtt8cnvtNRSxN7SXitK6TUV8foVCkKRBVRFq5qjUnuhE9mb4q2s4mWD
	Iu5oi6ygVKyrDMl/C4UMuBdF2QsAHa6nBerQv2bKW/IO8CwIAMWQhPxx5xrJwVLNh/WSeMcxIPO
	n1dN7OGh1/y0HEYozvXSASPN6oaM/wk5e04YUVqTi9r7IeuZv+X/6z265MVzT/D00DILQ0PXs5s
	h6n6PUFtMOEUIwF71blOTuU/cU5wtMyTLqtxJtrRKgRLB1oOC1pbS2qcIsZYxvWWaQYIMrIxhZ5
	ASu+rgHb5csNYWBuPcwLOCzpePsaAM6P+MEDmo/c
X-Received: by 2002:a05:7022:229:b0:119:e56b:c1de with SMTP id
 a92af1059eb24-12781cfd467mr170045c88.9.1772042249674; Wed, 25 Feb 2026
 09:57:29 -0800 (PST)
MIME-Version: 1.0
References: <20260224061424.11219-1-byungchul@sk.com>
In-Reply-To: <20260224061424.11219-1-byungchul@sk.com>
From: Mina Almasry <almasrymina@google.com>
Date: Wed, 25 Feb 2026 09:57:17 -0800
X-Gm-Features: AaiRm52vhIdwB8NdZd7JgaIXodcRDphEOHqkxN7idSkBUfk5IzYKeF_O7pMnx5E
Message-ID: <CAHS8izPjfrKFNtvkyODY7HXSsAuQuPhzy3+fMyYTFuWKQJZ0Fg@mail.gmail.com>
Subject: Re: [RESEND PATCH net-next] netmem: remove the pp fields from net_iov
To: Byungchul Park <byungchul@sk.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kernel_team@skhynix.com, harry.yoo@oracle.com, hawk@kernel.org, 
	andrew+netdev@lunn.ch, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, ziy@nvidia.com, willy@infradead.org, 
	toke@redhat.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, asml.silence@gmail.com, axboe@kernel.dk, 
	ncardwell@google.com, kuniyu@google.com, dsahern@kernel.org, sdf@fomichev.me, 
	dw@davidwei.uk, ap420073@gmail.com, dtatulea@nvidia.com, 
	shivajikant@google.com, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: uorwr5wtsdxwh9o3k3nosics81d4rrkr
X-Rspam-User: 
X-Rspamd-Queue-Id: A1A9F180008
X-Rspamd-Server: rspam01
X-HE-Tag: 1772042251-530904
X-HE-Meta: U2FsdGVkX19bteW1EhgKUD5FqMDNwk4dg9CHgxd7txYnVHxjQjGQzKqiMDKlCeUToV7sO4nAOX2UeFODP1RgilEO2w/Uj9cmRT8HRmk9arOTTY3z5WUrghRrw7Zuzr9UNk0UktndumV6JziNpPXDa1K4ARhVYtji/NpmaiGJzrdnveubRhPT3ldZ9+cnZEy5FuS2eTC61SnpYTlGXfYSPhWG9oUJ6LsAE+ZwFMdnFSJ65+etknVx2HHK2zCOy9lnLREwJDGBAaHROQWykLpxIchS4PAep+KHZhqfnvqHko4L6mD0gALFbhEGzknc8OKmR++1QwUZn3+4+c9n+DZ2ar0Jdp5dCo2Z0YpamxkOPIX39pnb+RS4H94QFEh/tSsMWRd7AMeQP9j+FbkvJ+IdC5oEeibdDUkZI4F1BL+Jw6Xgcs+rOwSDwLxiMnM7OFS1iYboSmmYpkEPb2vjLazgO7tgTx1MruBNLi/V12ZxCtr2iQtBK9797YALjccC4a7MqwR5HHYy031Sevk25XlAz88hKnspt8DBaVTxmqfLwg7B3iHlknlXac7U5hfsCZlf7Rpm/iAxOOrl8Hc7BQi1yDSnecsADI+KEnlYFFoD5EHH+gBEmCgA13Ob24fNGP1MIMdHpV9z4UjQdUfKD2P0UNurTa3Mp6ItGVAUj9whgEUIfHjPrBe6AlHL1tRLj8Tz+Il2UHSL1N1ZGqyfcNcTIhn175cdH0I+0advvYQDrRSSgraNCJpl8lN1UFdHNq7Ch1eAkeL8wu+S4iX5Bxn9IAIZorb+7sZxVwY88Km7v0ktiQBVp6W8WtD2ZkNZbhfZqulQH6wITwGeCgOlqpt6GF9QKO4gtnUY7bWyWAaoXAFbJ9+wTD6fyJ+2HuhLcOG2DZhUcMsaDg2Qj2nG/6KxVQ6vR452kbOypV2/xlZ1fIuIb/OFPCM+L955R8PPkhFPmYf0q7x+mzZWe0rJ9Cv
 HCvUIoeP
 fYiub7Inl8a6MURpn4v9+brBVpJWheV6so+COYFxEDTnOPzFI8rFbWVYv+87nckC2aUCaOYBCfRFjEH03pomhA8/MAwlpXmy33lQqleH0MTY53psjuDHXkhSb9NN8b34f6QxSGgMr6INxw2SEMvXEM2u8emcuRFNWGxRVQC+sdW8C3JF3e6T+G9KLAdkg2WgJ8vmoDID20ryuvz7I0zv4ltyGG3YtLPe/RzjVHvgoyoPcKFfV63BBxRVf43Y/dl7UuCO1u1sQdOwKy7a6atXgi8VgrNh24Cn2iTY8sNZElG17OuuZ5mWcQNhJEY3uO5KJuSRxun15BiR9svWqHzSxzauxpXBhVkZ0PaK8HEyNE245xD1wt7u1Sv7rlfOWV/lKZMzEWyXrjGahpJRTWClp52GBXZBS7ROmJDRhF/WizUcLFZgy4uXe6r2rMQOG5/539RH8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 10:14=E2=80=AFPM Byungchul Park <byungchul@sk.com> =
wrote:
>
> Now that the pp fields in net_iov have no users, remove them from
> net_iov and clean up.
>
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> ---
> The original post was:
>
>   https://lore.kernel.org/all/20251121040047.71921-1-byungchul@sk.com/
>
> 1/3 was covered by Pavel's patch:
>
>   commit f0243d2b86b97 ("io_uring/zcrx: convert to use netmem_desc").
>
> 2/3 was taken by Jakub and merged:
>
>   commit df59bb5b9af3f ("netmem, devmem, tcp: access pp fields through
>   @desc in net_iov")
>
> Now that io-uring and net core changes converge in one tree, I'm
> resending the 3/3, which is what Jakub asked:
>
>   https://lore.kernel.org/all/20251124184729.7e365941@kernel.org/
> ---
>  include/net/netmem.h | 38 +-------------------------------------
>  1 file changed, 1 insertion(+), 37 deletions(-)
>
> diff --git a/include/net/netmem.h b/include/net/netmem.h
> index a96b3e5e5574..a6d65ced5231 100644
> --- a/include/net/netmem.h
> +++ b/include/net/netmem.h
> @@ -93,23 +93,7 @@ enum net_iov_type {
>   *             supported.
>   */
>  struct net_iov {
> -       union {
> -               struct netmem_desc desc;
> -
> -               /* XXX: The following part should be removed once all
> -                * the references to them are converted so as to be
> -                * accessed via netmem_desc e.g. niov->desc.pp instead
> -                * of niov->pp.
> -                */
> -               struct {
> -                       unsigned long _flags;
> -                       unsigned long pp_magic;
> -                       struct page_pool *pp;
> -                       unsigned long _pp_mapping_pad;
> -                       unsigned long dma_addr;
> -                       atomic_long_t pp_ref_count;
> -               };
> -       };
> +       struct netmem_desc desc;
>         struct net_iov_area *owner;
>         enum net_iov_type type;
>  };
> @@ -123,26 +107,6 @@ struct net_iov_area {
>         unsigned long base_virtual;
>  };
>
> -/* net_iov is union'ed with struct netmem_desc mirroring struct page, so
> - * the page_pool can access these fields without worrying whether the
> - * underlying fields are accessed via netmem_desc or directly via
> - * net_iov, until all the references to them are converted so as to be
> - * accessed via netmem_desc e.g. niov->desc.pp instead of niov->pp.
> - *
> - * The non-net stack fields of struct page are private to the mm stack
> - * and must never be mirrored to net_iov.
> - */
> -#define NET_IOV_ASSERT_OFFSET(desc, iov)                    \
> -       static_assert(offsetof(struct netmem_desc, desc) =3D=3D \
> -                     offsetof(struct net_iov, iov))
> -NET_IOV_ASSERT_OFFSET(_flags, _flags);
> -NET_IOV_ASSERT_OFFSET(pp_magic, pp_magic);
> -NET_IOV_ASSERT_OFFSET(pp, pp);
> -NET_IOV_ASSERT_OFFSET(_pp_mapping_pad, _pp_mapping_pad);
> -NET_IOV_ASSERT_OFFSET(dma_addr, dma_addr);
> -NET_IOV_ASSERT_OFFSET(pp_ref_count, pp_ref_count);
> -#undef NET_IOV_ASSERT_OFFSET
> -

Probably better to retain an assert that netmem_desc is the first
field in struct net_iov, no?

There technically is no assert that netmem_desc is the first field of
struct page, but it's generally well understood that the memory
descriptor types should be the first field of struct page. It's not
well understand that the netmem_desc type should be the first field in
struct net_iov though.

--
Thanks,
Mina

