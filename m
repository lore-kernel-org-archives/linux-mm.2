Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 169F5606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 21:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CGIVhXWq
Received: by kanga.kvack.org (Postfix)
	id 2176F6B05B0; Fri, 27 Nov 2026 16:16:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF756B05B1; Fri, 27 Nov 2026 16:16:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12C6C6B05B2; Fri, 27 Nov 2026 16:16:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E23AA6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 16:16:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6299A1C3CB4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 21:16:02 +0000 (UTC)
X-FDA: 85482156564.20.5C891E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id B4231C0003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 21:16:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CGIVhXWq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795814160;
	b=NUxtAgYbNBYKf9pjQrgHfSYWip/esVV66GAmYb6DZjEFQ+yt9yzeA2yKfgeuG/EpgIXT6p
	okMpBffg/a+pRyTEyszz2t5dSaYRW77Y5tw5vmQMTENovExd/gJ01EzbnEOU3vxJGdOp25
	Ztdu1jLHL8KMhx/k+N9huEkdY3I+O/c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795814160;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UjkHrUpeAV74kiQoBGdvPVmIUfl/g4nDGIK8+/Y3xdI=;
	b=uBtbwN5KCKQKe7znAqoKqTTfJ3QwAGufG3JmvFrvqvTmo+ozwuy9nMxK1fHy/ANdPJ03x4
	S/A/8tLZGGjEuGHhvBrb3PPV1VpLI8teGkDELT80lSSz7+ItPKz/77utterP/i5MiWXRlP
	+jfQlOXwFEaGhTHuKuwQyJJUDBbl/so=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CGIVhXWq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E7F741A9A;
	Fri, 27 Nov 2026 21:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D871F000C1;
	Fri, 27 Nov 2026 21:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795814158;
	bh=UjkHrUpeAV74kiQoBGdvPVmIUfl/g4nDGIK8+/Y3xdI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CGIVhXWq+NOcg27X6TB1+/mUrMxk9/uDMHJ5Lq/G3lxPDEZJvegIq45WKqE6p2RhO
	 LAf13uLh+YXIq0PGn5zQgjmitwVWb6w8zzJP3MpwFdqu/apx3b8P1DacaNgtPLWasB
	 rLAf9YS+Py03LKs1kZJeuzm6L1K/K3KWhlzBDm8EuAz/mKRXqN5rN1lNCHJX81JugE
	 /hGJUtY3NRWsGFA6xH+SuVMCVjPdJcWVNPy7Ai2uAaV5MMeILd5LYGe8l+kmlwJcQc
	 S2buzkxpw09Ii/572sduAmLvsalqikXLRgC8Bz8zsAmvK1DiarDUgER4SfzSaebHgh
	 SnkGNslqgjE0w==
Message-ID: <sashiko-outbox-238285@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] mm/slab: handle __GFP_NOFAIL better with prefilled
 sheaves
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Vmxhc3RpbWlsIEJhYmthIChTVVNFKQ==?= <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>
Cc: "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>,
 =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>, linux-mm@kvack.org, "Chris
 Mason" <mason@kernel.org>
In-Reply-To: <20261127-slab-ai-fixes-v1-2-cf13b6be6692@kernel.org>
References: <20261127-slab-ai-fixes-v1-0-cf13b6be6692@kernel.org>
 <20261127-slab-ai-fixes-v1-2-cf13b6be6692@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 21:15:57 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B4231C0003
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: zktnjz8mdintbcb3jcq7befnokcj5zdi
X-HE-Tag: 1795814160-472667
X-HE-Meta: U2FsdGVkX1+0cvbEIWRBrYesXEfwUy0byLzrfiInD0Ww5hgpo1Y+YGSr+5MieHp4/It23UYDlV6KNZO5cRcSu9GBTRzTu6mamVW5/hGJemkQogkc8Ex+3ChiXkzu24nnL2p2vcBxobrODcS+8hsv+h6edgoZAdVVTiCjtqoTBF7dfw0NeMuTGksr3rdi9MPr1d7sJ0jzPaPv5FME0Y7CrRCXCkDaSaI1D0E68zzQc229aK9IU31SgsBfU9Wmw5Vgm6wBT72qOxNSMJA6KXcUULnKOtZCT4Xc/E2oTymzi594FLn2wVL5RzFniHSCGIi6vQz79UoX6bg2zMBTcFPlZ2joJeav4XRRRO4hzbwFbpeSWEbVjr+cVxKJ503u5Co+LYDMBNTr0GCDNNvsl7uz3TcR3bkXy9R96bSnjC6U/JTNj/wKVSdWn+igUTkV1vdZFMX1IJdSfS7RIfEP7kmxQRFagIZ0NXApzW6hKai0hxw2p37tjFvgIow2tslqwp/l5IzHTIzP4a7OGQ9lROeMz0g1NRuATVUCyIaYOuKm8ZNIZ2Z1nhp7djIDhVw6Shff+UpsGXFQZsMJJhTf9tbCC4F6BF69pp+x19weCjbPqsKxW43DwJVeJZ45yUNLCU/DDZ7QJdnUC6WhtH9Wg1tzX3CCyNwT6/nMgDVpXoyNfViRxig98jEHnKCBLSpo4L0ZIkiIcufW+BbbScWuQlcY6pd70h+vgJ4gABQIA7H2bgj4Z/A6XNS38q0hq1Aog1R6bFYmc8hag7qneBm1JZQvEdtPbeubfBsf/1xtL9maDpfSqQNuLqpf6GfLLbczJrXBzUBsce+0uZ2Bj2YytHNQO2SvvTaQeMqHqdkX0k8n9sMPECs0YnBjmowAx+hYoVXuwDLY+8OdPq+qyaN90oMOlHht/AbAzymP8HPjJ7okhzqYs4F+b/I3mowRJ+4wS36jYrmrXbxde2VIuzVaR9P
 so7Okw6o
 9+Eh2HyW2f2bi2GwLcL7c3ZQ6rB8Ipmz6TDGujTCikFFEKr9VdwlhC/zhgF1Goxy0GJct2ta80mpjk8tyaMk/mzau//rq18H4+4JKNNfrRZwyFX3IZ3+uUL+SYcr6PQi/iX8yVBczm/SV8V6D7uc6pNPgKeHaunjKLGTf5WimD8/q5aMWchPKb8pikA0GF1mGgonLmd1EDxGBGH8WC6B03o4OOPdJD73yULyJ3LaWJqbhkZD2DPpkfTb3GFe9zUD33mkjCib+CEfe5ayUU3YS3/QqV7tgPj7JosdIfx4zjPwhYUS87MAs9gWhFhGaexlaC/7DR6wPkc0Xt9KNj3TKi5qqi6wWP+QBMaQRgsIZL2wtLM9E290LbODXtdEkpj3GdHBPZ5UGAj/UjR6lGMMA/2EU/CN2AV2q5Nl5w2MKm1WV8lHudFLQpu5iUMeaV09/IKJ4oLZNRnV40Xu2G2Dkha+fjqwT2JJuH5IUvnKWz4PVb/sox/3CfvmlY68tsCf1MvQ3wi4KyVnE4d24r6a0mHAAUC1f9I5DnDlHOMK0XkgiRqva20NkY/Q08cDaY8ZR9MnCTP0wuCv7Xa+lTjjmS17TQTR2dBgcQlhGCTqJFmPVYXbMKH0ZwmOC/Cd1794+TC+1TTh27gdQ14igSKfZFrZIhyHjdgjGa32IIc53Oh3wDx7IhfcBzF21nr0Wevdv//5xAA2AvzOSXQ/MsgI1UeLlmxwVRxdOh44UZzkm9ESCDLW4ajmaoJfv/NnSDSJa4xMFBIrn9I3SD/F0g3mksZaKhEHCEBBNewgU0EWCNTYJAsilM6go7eOqo4aoSqc7Z0GR8I2HJaAglKvsE/AECsPgIT8mRuNlvJF1AXf+/siRGW+VvgMNC1tzg57TggXUNN1c4HD1JHetlGQUfb0cLodWmF31KtCnePjxyrZlI2pAi1+w7N8M3t4puQ==
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
- [Medium] mm/slub: __prefill_sheaf_pfmemalloc() misses __GFP_NOFAIL
  without pfmemalloc
--

commit 7b605e7e1980fd6063399368212254f7119ec46c
Author: Vlastimil Babka (SUSE) <vbabka@kernel.org>

mm/slab: handle __GFP_NOFAIL better with prefilled sheaves

This commit strips __GFP_NOFAIL from the initial __GFP_NOMEMALLOC sheaf
refill attempt in __prefill_sheaf_pfmemalloc() when pfmemalloc is allowed,
and also clears __GFP_NOFAIL and adds __GFP_NORETRY in
kmem_cache_return_sheaf().

> diff --git a/mm/slub.c b/mm/slub.c
> index 5fd148f11efd1..20570e4f1795e 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5204,8 +5204,10 @@ static int __prefill_sheaf_pfmemalloc(struct kmem_=
cache *s,
>  		return 0;
> =20
>  	gfp_nomemalloc =3D gfp | __GFP_NOMEMALLOC;
> -	if (gfp_pfmemalloc_allowed(gfp))
> +	if (gfp_pfmemalloc_allowed(gfp)) {
> +		gfp_nomemalloc &=3D ~__GFP_NOFAIL;
>  		gfp_nomemalloc |=3D __GFP_NOWARN;
> +	}
> =20
>  	ret =3D refill_sheaf(s, sheaf, gfp_nomemalloc);

[Severity: Medium]
Can a __GFP_NOFAIL refill still allocate a pfmemalloc slab without marking
sheaf->pfmemalloc when gfp_pfmemalloc_allowed(gfp) is false?

Callers such as mas_nomem_nofail() -> mas_alloc_nodes() pass
GFP_KERNEL | __GFP_NOFAIL in normal process context, where
gfp_pfmemalloc_allowed(gfp) returns false because __gfp_pfmemalloc_flags()
only checks __GFP_MEMALLOC, PF_MEMALLOC and oom_reserves_allowed(current).

In that case __GFP_NOFAIL remains set in gfp_nomemalloc.  If direct
reclaim fails, __alloc_pages_may_oom() grants ALLOC_NO_WATERMARKS to
__GFP_NOFAIL regardless of __GFP_NOMEMALLOC:

mm/page_alloc.c:__alloc_pages_may_oom() {
	...
		if (gfp_mask & __GFP_NOFAIL)
			page =3D __alloc_pages_cpuset_fallback(gfp_mask, order,
					ac->alloc_flags|ALLOC_NO_WATERMARKS, ac);
	...
}

The resulting slab is marked pfmemalloc, but refill_sheaf() succeeds on the
first attempt and returns with sheaf->pfmemalloc left false, allowing
kmem_cache_return_sheaf() to place pfmemalloc objects into pcs->spare or
the node barn.  Even if __GFP_NOFAIL is stripped unconditionally from
gfp_nomemalloc, the fallback condition (!ret || !gfp_pfmemalloc_allowed(gfp=
))
below would still return -ENOMEM without retrying unless it also checks for
gfp & __GFP_NOFAIL.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-slab-ai-fi=
xes-v1-0-cf13b6be6692@kernel.org?part=3D2

