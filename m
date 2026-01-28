Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D24FD3566F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 03:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A8086B0088; Tue, 27 Jan 2026 22:26:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455926B0089; Tue, 27 Jan 2026 22:26:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30D3B6B008A; Tue, 27 Jan 2026 22:26:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 205E76B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 22:26:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B6BF11A040F
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:26:00 +0000 (UTC)
X-FDA: 84379933680.10.F59AB3C
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id B7C48180005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:25:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mCKE2jVO;
	spf=pass (imf24.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769570758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aoGoz2eY2Z5cScS79bGBONPFBBMwxV4aMlRLmXnwIds=;
	b=zOGbXR3nOEvFhu3NPlpEBUPCkiAYdwiIIYJkcXEShcGUbAuXgALVIVfxrnZvUDVj1zygRY
	iYNsGwS7ehO/e26OvsozKy0pQn+VRt1VoftP8g+0urJdqNzAMvZqxc9xYrLM4o7KRwR8vP
	PeZp4Lxkba+Vc7DUxCNtTGwI1cURvpU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mCKE2jVO;
	spf=pass (imf24.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769570758; a=rsa-sha256;
	cv=pass;
	b=jtst1vUsGn3gzQJRneZEbhCYNWqO7XT68HUTdptW5R/KcXnDgcg9joq4Z/FrbdOBUxyQA4
	2PJZGEpC+xb/jfux8FRMB9ti5vILVKovUB31umeVLQUBjSBAIIZdm0NOGpuygPVDPx9a1Q
	xBjPFHbdoaK8ynCTL4VQ6hxS5V3Iyuk=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c2af7d09533so3914179a12.1
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:25:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769570757; cv=none;
        d=google.com; s=arc-20240605;
        b=NkJBVDlqHcgo4eh8klhlP/d+csCSOnJeXaFGLFVoPVIXhdW89btL8z8EM1FP1yx5xz
         WaJDNfRDeFtNGzc5r+d0xelkNwEwQLgKZSo+o2rMrS77eJ23cUhiZUSAp26OaFiUfqoa
         N8+UXLF8hYCyImQhvTbXqD6mvy1M8iqwOB8I9AnTEKSPUuBLWGSWwu0kNUysUQ/cDHVc
         u4EOvVpZpNS5YgTwTYiZjimnIKRZQQHUiRZl54wgOEVhUvXSDdPygqy2hBlx7offuZHt
         TcUHBPGbWBsD9TCA+5sZbUxZtoaTnv9nEi44W95/a5lEgUv6ehTGGhyAptXORgGjKayn
         qqOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aoGoz2eY2Z5cScS79bGBONPFBBMwxV4aMlRLmXnwIds=;
        fh=k59Kl5fE4lTugqmg0EMaSRrd0uuU4WqE9RF479H5uKg=;
        b=ciu29O8dlRvWCymcMroRoBVnmFDsskmqGBvM3BLskXoyJ+eO8iYWs/B+1NFHRmNwGg
         WG+LIlbAqEqGHaSSRE6guxMv1q2Zt87+9T9QUNKnZYU+E1HxsilPdBGIR5V7w4QXFnyT
         Kidys5uYBTTF/wUhf9W/vX8rXIwptR7/gQpr1tb/TPsrvpLpkMT/RchShCFnA+EXuxRh
         jif8J0+9fSKlIfHpQ0m8pdhZ5RuJulchK7f5Rf2o9dzKqvB6OJmd235gvEjkMX+TVbCp
         LwBn0QxkL4jMetVQtqlQcp3PrtD1v0vXIQ1FQ7mFvRQDM1F+UQ320RlLl4XuGPS6oZxk
         6O/Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769570757; x=1770175557; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aoGoz2eY2Z5cScS79bGBONPFBBMwxV4aMlRLmXnwIds=;
        b=mCKE2jVOooQsi9HFExuw/I2IHdf73uQAK1tY9RuXPc/Y9JJibSfz1BKgIgWKbSLmFo
         Uc7r1L5vjY6+1AIJlwVYER3HSw++o8wY+OW7ohWI8PWcUmqKDY9TzYX3/3hK5Saq+vbH
         G9rU01BntqQajRZqHPabOBj4k7jcDSQK8Kjd9UBSWrO5mEwWbKuLpXCBCiT9bgWfaatp
         +khLmC6sx/Th7AjZI5ycFFyQDyHN2hd+F4VGpGxjatB5qvAP5vC+y9rhc29zo1I1j0Uu
         9YjGOWakJPwE6URRXdtZCFG5OEsgIe9aSIGVpj1Qy0EhP7+qb3FCODuZ5EIaSAtFkuLs
         Z4pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769570757; x=1770175557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aoGoz2eY2Z5cScS79bGBONPFBBMwxV4aMlRLmXnwIds=;
        b=o/d4WrxgpK7Z3lACMSevLQf19DVDvQKVObn8M4V8ACjKFd0b4iYo71dDqVx0wGs+Wg
         I5GxKw8+n3+oFnFXWrpI9ye/MVsCbNhpC8oTSdxVF9xb2jaiYFhxrXFJZgde1JG4GT1Y
         Iq51P99+hZY7NkHbEmUcSAaMoiIl1rXtAQK/7ukR+/okRQOoHa8mEHxG+IUO1IdWxmTS
         /k8FgRHT6Q5iV3I3dGi1ZX77vimYkf8xrBTJlDPurX5nFK8a309QnXSDXWfImvkcmV6v
         wVdFxWyE5LORBSWA1t3CbnzQznDpSXgb1+xXKhTMDIEoLbmLZbkIDjAhfYKy/1oqQ2gl
         zqjg==
X-Forwarded-Encrypted: i=1; AJvYcCV+Dj8Va8OOnOBuh9niH6Z4Luy7LO1nFIFKpWJ/Qc2hx9ayNeJHNTKvH95/5lAiIocTrl5g4q4sGA==@kvack.org
X-Gm-Message-State: AOJu0YxWDWuv2V4eD6kIGD9lzpqsKOJ0QmFRlYRLd/ejtz254rmlb/1e
	FeqeOPn0DqiQZN4ti7UKMVwj1lhDyjz62v387oGseADJT2z3c961yKelxd2nTtq+u65yvEWnLY7
	XKg4zYeM84SVyC2610qfBr8RE36Ng3JM=
X-Gm-Gg: AZuq6aLPPYJADOs/DYJcqoIMUrbt/25bxfyi7ghUHRPPGf3hjScmall2B2JHqBXiLfW
	+jBxsfK9QlzubBx8qSkUOIY9Xalzp6dq+Ap1HU2QtAPQRhJAnPb+NnDxVKbCy6iuCbQ+92IWvN1
	6RvcgRKzB+dP3KCzGmQ5Dt4erT113z7AXT04+VUUEoi0KDe7Tz3sRIyR4TohxFjqCSSJ7E9Qm5D
	zDv4Br2hhPgJlZqiG4h1ZhHNsGdctrOjPhpMGd0emyyzb52hEVTSHSBNVX6lMezqDzltQ==
X-Received: by 2002:a17:90a:e990:b0:353:883:aff6 with SMTP id
 98e67ed59e1d1-353fed846f5mr2705765a91.20.1769570757348; Tue, 27 Jan 2026
 19:25:57 -0800 (PST)
MIME-Version: 1.0
References: <20260111074453.66728-1-pilgrimtao@gmail.com> <20260111074453.66728-2-pilgrimtao@gmail.com>
 <aaf30e1e-be55-4212-b096-69f71bafd406@gaisler.com>
In-Reply-To: <aaf30e1e-be55-4212-b096-69f71bafd406@gaisler.com>
From: Chengkaitao <pilgrimtao@gmail.com>
Date: Wed, 28 Jan 2026 11:25:46 +0800
X-Gm-Features: AZwV_QhgQy9ZJdV5p3jCCt7MradNH2YcIqn0iOIIzYeURQTKXe5ygQBurmDKREs
Message-ID: <CAAWJmAYmMtdE7nSJ8BWSnt2DObipqGi_KdXdMJrHfwc0ANBSPQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] sparc: Use vmemmap_populate_hugepages for vmemmap_populate
To: Andreas Larsson <andreas@gaisler.com>
Cc: davem@davemloft.net, akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, kevin.brodsky@arm.com, 
	dave.hansen@linux.intel.com, ziy@nvidia.com, chengkaitao@kylinos.cn, 
	willy@infradead.org, zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7he1mf9xeu3bzm99hcg3ddhcktzjean5
X-Rspamd-Queue-Id: B7C48180005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769570758-698920
X-HE-Meta: U2FsdGVkX18dBvtwSwB040NosMXgPq2XQEvs4MKU60zXlCWCsgC49FDNGCkdnlWDj1Mk6zto1Uv7WOPnXm8zOa3xlkRknGBsmO8jRKE4XrdTT6E0ZLqzNSk4F67AAf2W0EuwFjskOUwNB5b47gx+6/IZu06gipzlM9WcFc0uwEh6TX8Qj4yTwueUJ947Mmd8m5wwl38J5ibw2U9pmBoMQTvqAhQw6gdL6fxj7ZG06ERzO17KK8BrHrFOwbzxtidSFpb2+0w0GtAnBe2EwIMHTJr7p0eqR3IpEAmqzjkoij96WmnUBdM0PLSdHMiw/fvFW0ShS+k1RppiS3oRLR9fiAaWlLlmh9lrLQEfW6pW1cmIRfLqspJOXnCu2sJztzg43b0hTSbI4XvMpZpR7nsDF631WOs5EvNr43h2KKoE1H7cqlO3pBcLYplPOoxxV7x3nDf+7OaMd3W8YjNoWTAGy3a0UJlTRz0TAj+bsW1IBbk0tLkw9I4jH+R27KDw87WEOdty2IWlPWrDLRJS0Xiy1K2i0puPIkVkhBg5Q9k92KPtxbaze1e4kSYprMWKeRMv/wbWBFaqMWTjrMAc09pbCWj1edOPM8Vh5x+l2P1a9uR7/UygakpQZm6VgS6o2wNzzwkaxiud8vAX26XtJiSExBLJA4pvq73Sze2qUQeq/Jov79HdgpWaTNzO9Z4u4NivUl95/phHcSlgwvQsOZdZ5oZjnPuyIH3Uuy/nJktc8Wkt94IzgQQmeQf/Y2XVbtP6jCQhvP5aKDxGJpWFZ/Ascr8xqOJU5tEWTE0oKCnpzh9MxC3MLPKga05HfYLliSaO8Cn0kvOSDWqcxkkftxhrhlTJWMSkHdpAUgdl+kHgLjEhOR8PNQ4YS51kx2KZo1oxh2WWvDh/zX2m2nZiQa8VOmJtufZhdoOtM3hVVv8WGimBPl5RGJev1lnuBMxqIaFORf8pAUg64XaMDwV8y44
 qwCtukmP
 UHqRzoyyE5jxmOMai6MKZrBKNIwbx8BEBFF5sRGB5IBzq6Dsy2De1aYTtw5+gYFowk1A0aBSGSkl+USPKTq/nRb2KP/ocp99Po67dnLLjia9yhi5xjT1/Q2v1/yAQAkZZFkVJLx4iDFQSNStcBkgsU5DPFpISYTgMY2Ss4qTm6i6Hn9aVU8Mp904qgi+WxPWlDjx4nSsQQEq2l3bkNsBrfFZ/9OHuKqVMVBCyYZ5T+U9ptkFG06Fy6j4Q/gF1aMZTvZe1a7zBnLPSpdf4h8tcYapIpm++7vPOYY4dQ9PuJnRCzSnwEBn/eOURoe0E1APuasXlo5JKTU7xVlyo31Kem1Bd6DUCRZLhUU5aOMS49wZnEsUzqLTt1mJ3meeep/LbTXFC8+n0RV9saUbS7DMAbO8ICwAvcmVBz3FeF04O0RviIwNNQlR+xWs5GsEeOQNcm8eua1GJnnH9MYbqtpvHsWYrS0VyNwq5jhk+YOrE8YqAjyOkxoc/cRQ4IJT9vKI1Nql1MnTPTbjc3SrFEFL3FoWx9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 10:50=E2=80=AFPM Andreas Larsson <andreas@gaisler.c=
om> wrote:
>
> On 2026-01-11 08:44, chengkaitao wrote:
> > From: Chengkaitao <chengkaitao@kylinos.cn>
> >
> > 1. In the SPARC architecture, reimplemented vmemmap_populate using
> > vmemmap_populate_hugepages.
> > 2. Allow the SPARC arch to fallback to vmemmap_populate_basepages(),
> > when vmemmap_alloc_block returns NULL.
>
> This patch seems to potentially make more functional changes than what
> the descriptions gives impression of.
>
> Given the amount of changes this seems to introduce, more on that below,
> I'd like to see more description on the changes and why they can be done
> than this.
>
> Nit: use active language, "reimplement", not "reimplemented".
>
>
> > Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  arch/sparc/mm/init_64.c | 47 ++++++++++++++---------------------------
> >  1 file changed, 16 insertions(+), 31 deletions(-)
> >
> > diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> > index df9f7c444c39..858eaa6615ea 100644
> > --- a/arch/sparc/mm/init_64.c
> > +++ b/arch/sparc/mm/init_64.c
> > @@ -2581,8 +2581,8 @@ unsigned long _PAGE_CACHE __read_mostly;
> >  EXPORT_SYMBOL(_PAGE_CACHE);
> >
> >  #ifdef CONFIG_SPARSEMEM_VMEMMAP
> > -int __meminit vmemmap_populate(unsigned long vstart, unsigned long ven=
d,
> > -                            int node, struct vmem_altmap *altmap)
> > +void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
> > +                            unsigned long addr, unsigned long next)
> >  {
> >       unsigned long pte_base;
> >
> > @@ -2595,39 +2595,24 @@ int __meminit vmemmap_populate(unsigned long vs=
tart, unsigned long vend,
> >
> >       pte_base |=3D _PAGE_PMD_HUGE;
> >
> > -     vstart =3D vstart & PMD_MASK;
> > -     vend =3D ALIGN(vend, PMD_SIZE);
>
> It seems that this patch removes alignment of both start and end. Is
> this a functional change in practice or are these always aligned for
> some other reason?
>
Whether vstart and vend are aligned with PMD_SIZE doesn't seem to
affect the behavior pattern or output of vmemmap_populate_hugepages.
The vmemmap_populate_hugepages function performs necessary alignment
processing internally, such as pmd_addr_end and pmd/pte_index?

> > -     for (; vstart < vend; vstart +=3D PMD_SIZE) {
> > -             pgd_t *pgd =3D vmemmap_pgd_populate(vstart, node);
> > -             unsigned long pte;
> > -             p4d_t *p4d;
> > -             pud_t *pud;
> > -             pmd_t *pmd;
> > -
> > -             if (!pgd)
> > -                     return -ENOMEM;
> > -
> > -             p4d =3D vmemmap_p4d_populate(pgd, vstart, node);
> > -             if (!p4d)
> > -                     return -ENOMEM;
> > -
> > -             pud =3D vmemmap_pud_populate(p4d, vstart, node);
> > -             if (!pud)
> > -                     return -ENOMEM;
> > +     pmd_val(*pmd) =3D pte_base | __pa(p);
> > +}
> >
> > -             pmd =3D pmd_offset(pud, vstart);
> > -             pte =3D pmd_val(*pmd);
> > -             if (!(pte & _PAGE_VALID)) {
>
> It is not the same thing, but is this equivalent to if
> (pmd_none(pmdp_get(pmd))) at this point?
>
For PMD entries, there shouldn't be cases where pmd_none and
_PAGE_VALID exhibit inconsistent behavior. I've observed that
pmd_none is widely used in the SPARC architecture.

> > -                     void *block =3D vmemmap_alloc_block(PMD_SIZE, nod=
e);
> > +int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
> > +                             unsigned long addr, unsigned long next)
> > +{
> > +     int large =3D pmd_leaf(*pmdp);
> >
> > -                     if (!block)
> > -                             return -ENOMEM;
> > +     if (large)
> > +             vmemmap_verify((pte_t *)pmdp, node, addr, next);
> >
> > -                     pmd_val(*pmd) =3D pte_base | __pa(block);
> > -             }
> > -     }
> > +     return large;
> > +}
> >
> > -     return 0;
> > +int __meminit vmemmap_populate(unsigned long vstart, unsigned long ven=
d,
> > +                            int node, struct vmem_altmap *altmap)
> > +{
> > +     return vmemmap_populate_hugepages(vstart, vend, node, altmap);
> >  }
> >  #endif /* CONFIG_SPARSEMEM_VMEMMAP */
> >
>
>
> This change introduces using vmemmap_alloc_block_buf() instead of
> vmemmap_alloc_block() seems to introduce two new behaviours that was not
> in use for sparc64 before:
>
> 1) Using altmap_alloc_block_buf() for a non-null altmap, that was not
>    used before. Also the fallback to vmemmap_populate_basepages() passes
>    on altmap.

If altmap validation isn't required, I can retain the original code
logic by setting altmap to NULL.

> 2) Trying sparse_buffer_alloc() before vmemmap_alloc_block(), which was
>    not done before.

In SPARC, sparse_init() is called to initialize the sparsemap_buf.
If the SPARC architecture doesn't support using sparse_buffer_alloc,
we can remove the sparse_init() call path.

> Neither the commit message nor the cover letter touches upon this. Could
> you elaborate here?
>
> Given all the (at least seeming) functional changes could you share how
> you tested this change?

My original intention was to help architectures adopt more generic
kernel APIs to reduce maintenance costs. However, due to my lack of
physical SPARC devices, I couldn't perform comprehensive testing,
I've only verified compilation correctness based on code analysis.
I sincerely apologize for this limitation. If you have access to
physical SPARC hardware, could you kindly help with testing?

--=20
Cheers,
Chengkaitao

