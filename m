Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B7CAC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 07:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 474986B008A; Tue, 21 Jul 2026 03:57:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C9D6B008C; Tue, 21 Jul 2026 03:57:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38B716B0092; Tue, 21 Jul 2026 03:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD096B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:57:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6722F140340
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:57:43 +0000 (UTC)
X-FDA: 85012029606.30.8B95F94
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8F79C120005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:57:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=otTSCgQq;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784620661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=67VeInvfg2059N6m643qkaKNMdL7mnmvi+qBizbLEU0=;
	b=BsFaINcTURa3CuKM9PJLsVjShBuflzYInnHP+hpE1s4Mqro2ARkukIRPSykUgQQP5xQ7yd
	UWWSwe3DYx6h/JxmZdEYH7oRfqneZNHRimpbE9xYcXsqvKVBrGPq3Blqiry5sKJMDQSo0D
	pW2Ev2FIh3K/nPhJYLiGDFBp3zu60Ko=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784620661;
	b=cUk+GKlh1Eu279xwfDwhNgmI6n2VzQTpLl6Md+ZsfY4swPiVeqRtwuPzVxb+LF3O+u/+zS
	7TXF5to5FhyIg+QE4JpVgKQcsyxYKrkag6ZNgwAdWjB5uiio37BcfU2Y2F3VWz9PYM4HUi
	cLTA1f2GKGGnTplp5EozNCPpBn4iCKo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=otTSCgQq;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0321C60AA5
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF38F1F00ACF
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784620660;
	bh=67VeInvfg2059N6m643qkaKNMdL7mnmvi+qBizbLEU0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=otTSCgQqMLlbrvW2m893eQvJObUlIZJUTdI03GPpxD2A4rMXYHt7QPUh1NEo76K+3
	 XsCuuN6Vgm9nheplVYdhDDRorMNF/cHOvDV+EGgIqjaFSgJRZ807MdIxAYSwDdI1my
	 WXAMvycApGnVXgocZ26TSrtWVpqkEdz+IgGNZAofk0xCU+N6CRiLye0M3I2Y2vFaYP
	 B9JilmWmBx4Fq9Tz0+h/XPZ7hQKAx731y0Uqg1Fn/GCvhqsnnrb0lNiC1m9rVRO2Lw
	 Z1I0ZDzNVMau9zk8owbVG9ICdJXT3z2jEkVnE7NdZwU6boid6+76DRkAl39S26WB35
	 xUUT+fCOmeWSw==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e6391b114so601376285a.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:57:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrsuUH7jqF+PHygZxMd6TVqTiwLpo2/uWuoizA8+nbsPlwoACzh1jXsC24Th3bVBt47RMN0kWK54A==@kvack.org
X-Gm-Message-State: AOJu0Yzpp48iaac9kpXS5Iunj0kaB/4+o7xHXt+nINZkvAXg97SrkX3x
	AhIP3M+qvl84OBgY6I0Ptp1EJeGfAEFXIhYoQnm23d7Ojcj/8W33Kka489IA4C0fTjMOjC7yW5D
	o8H4udUsseQWyev9sB+U9f51K5BeBb5g=
X-Received: by 2002:a05:620a:4011:b0:92e:604f:909a with SMTP id
 af79cd13be357-930b3ec8d71mr1812555785a.29.1784620660059; Tue, 21 Jul 2026
 00:57:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260717122514.51514-1-xueyuan.chen21@gmail.com> <20260717122514.51514-5-xueyuan.chen21@gmail.com>
In-Reply-To: <20260717122514.51514-5-xueyuan.chen21@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 21 Jul 2026 15:57:26 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z+uw0YdWMwJzxHA6kbV1wPaqSXhFzwT65ffj1drSmnbw@mail.gmail.com>
X-Gm-Features: AUfX_mwXoCUVj4Q581J7mLiAo59hEPI1kMXrhwsYQcD6VlJcdSV4gQgQI9BZuCo
Message-ID: <CAGsJ_4z+uw0YdWMwJzxHA6kbV1wPaqSXhFzwT65ffj1drSmnbw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 4/4] mm/shmem: split large folios only on -E2BIG
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baolin.wang@linux.alibaba.com, hughd@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8F79C120005
X-Stat-Signature: iih1mga48q9egdxdfacebtkbm8fpfq8o
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784620661-798423
X-HE-Meta: U2FsdGVkX1/7Tg0yXkQRpTof/x2GLzmvurDx2OYP4+phCYNukeJA+QqbWQpyL7sjhCiRcb4oEn4MnNhLmQGtH0x300QCICHsSbTdxkkzC4DP1ZCjXQfY42LfTFiy3YOmKyLk5xEFqEsSq5fVPzgDTJ/h8zlS8aJbdvREz8xurU03uL7qKa6+minCeN7y91vPosPz/vMyrKqiJbIyoTR+zLIuhny5KaR8By3UbN1CPwEaPHztpdt5I0Xt0zqayuYWeZl39QEPCG+AHZYGRFIN50Z9fTWsckjC5Wt5sYaEXYPAAEQbFi/sbpMaKf1PJLCIFPyO3DsEnxHxA77FRH7gD1dOKCHajLXX6J+htY3VCdiT4/6cFjU55TlVBYM/0PRbiAZ5k3sQwQ2RidboBw9upbi0iy70OrTytJG2onxKuYPTFO+eewQT0xeisShKJZ2vtfJ0Z0pf7G2dgCYl2CI0snP8FpA4xbkgKvY2mcIOlYCweuTLcUHC2mP94aMQuL/++5htLB7y/GiLhVFbqoCofWLdg+e+xqWimkEgz8ko1baubVD/jIj+LgYk+7t1IV00MMxnQ9JnSy7MIHvBjIO309cY6LvR2SpOwyRqrL9bjrb8KAGntEJX/VEChXpRbbnGmNYyKhg76WgRfRWrcnIF+c3fpfqz/0c8cPShnyuO0JsUG2Uq2Iiwgm6vrBXeXfHXmt1JZtUAnpfTmnN6I6FQEq4JMn3ZLhOjNr61OhrjNWJhvDWqDLab8maCukNDIvf9b0ktGAUXyIaxGJBgz0BaKW+lRCI/oC+EIwq5y29qO0gG5ry4FutLx/pCeNGPWH98WgZnFV0nhudOT7I933hPw4FpD5aCHOVaZ7sSVbNBiiDcKYSXb9cB6QjQ2/9spx5y9yNKKeQzIGi09veBb/VGA0+gpXNnZTgk0ten0K3AaSNQiTXhAGkbCrnrZgxB7LhGQLsPtrvrsyU9ETTIoDv
 PjieAw1Z
 bW8ftscEGaTYgMbmWDZjYROVcrA3P6mj6QZZBBkHN95bcgcEwimg2idOU+p0b9EIeMiyBTqH9kYRNRdZnWeYOReIpvU8T5PL1xHccRUNdKVWhKjd8KS9Z2IE1dv9O65wUBxWOi8JRaNt2mRZopeNy6OIQuiwNU8PvVz1k8CCQLY+EbNLShae0gXZCuMrh2uIppuwShbu8ppZtmj0TKuYmog5LIg0Ifhlw647Cl0dFvKdVxfBZY1uxZw4jvELI6g4dsrILE1utIAUYqdN+Quds8lY79oRiS+g3yFZN0dZ68i/cWjkJ2thb0fH9TgNpxmH6/HKHHdaZtlmijJH6Uq0VTx4nit1krH2Y8kfnHLLGK49kWos1mY61rIYf6kAHTCuaNtMc8e+BYNzA6g54VC7OVV/LUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 8:26=E2=80=AFPM Xueyuan Chen <xueyuan.chen21@gmail.=
com> wrote:
>
> shmem_writeout() currently splits a large folio on every
> folio_alloc_swap() failure. With the refined return-value contract, only
> -E2BIG indicates that splitting might allow smaller folios to be swapped
> out.
>
> Enter the split fallback only for -E2BIG. For -ENOSPC and -ENOMEM,
> redirty and reactivate the folio as before.
>
> Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/shmem.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3b5dc21b323c..d76812dd3cef 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1599,6 +1599,7 @@ int shmem_writeout(struct folio *folio, struct swap=
_iocb **plug,
>         struct shmem_sb_info *sbinfo =3D SHMEM_SB(inode->i_sb);
>         pgoff_t index;
>         int nr_pages;
> +       int ret;
>         bool split =3D false;
>
>         if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
> @@ -1679,7 +1680,8 @@ int shmem_writeout(struct folio *folio, struct swap=
_iocb **plug,
>                 folio_mark_uptodate(folio);
>         }
>
> -       if (!folio_alloc_swap(folio)) {
> +       ret =3D folio_alloc_swap(folio);
> +       if (!ret) {
>                 bool first_swapped =3D shmem_recalc_inode(inode, 0, nr_pa=
ges);
>                 int error;
>
> @@ -1732,7 +1734,7 @@ int shmem_writeout(struct folio *folio, struct swap=
_iocb **plug,
>                 swap_cache_del_folio(folio);
>                 goto redirty;
>         }
> -       if (nr_pages > 1)
> +       if (ret =3D=3D -E2BIG)

I'd rather keep if (nr_pages > 1 && ret =3D=3D -E2BIG), as it makes the lar=
ge
folio case more explicit and easier to understand.

>                 goto try_split;
>  redirty:
>         folio_mark_dirty(folio);


Best Regards
Barry

