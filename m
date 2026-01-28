Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC491D35676
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 05:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F3606B0088; Wed, 28 Jan 2026 00:21:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0886B0089; Wed, 28 Jan 2026 00:21:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99D06B008A; Wed, 28 Jan 2026 00:20:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5E606B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 00:20:59 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 87BAC1A0465
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 05:20:59 +0000 (UTC)
X-FDA: 84380223438.23.3C0D1E0
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7B04C20006
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 05:20:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=L7U96Aml;
	spf=pass (imf13.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769577657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V1J5+mim67A7RbbplsiEoQN/uCVwUx2jWg1suf/tpgM=;
	b=tcqyO9yXg4xWtuFxqSZgsOu3IiTWMMxOAovlLd4cDut5cqtWAozH2b9QhFSrUgFcqS+ffE
	j0p9tiqMa7sKiQKOyIUraYWbbVw9uITTeuBKO27LBuvKeR2v9UzzebO4RcMwPGQa7S2h+s
	AZgNj5sixflCdxiqPoVVsO0zEP+/RGw=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=L7U96Aml;
	spf=pass (imf13.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769577657; a=rsa-sha256;
	cv=pass;
	b=ghzHubUxEex9ZIBxhSZaHjnVKF4yFraOAY1Wy+qpWjfPZp67vL451KOTmAnJ4SLtHWfEsv
	aS82c+Acl9qRL+PwA3SeCOqAPD4Mb0hquDeA80m8Qk4NXTVJOMOJQIUYj01Wz/iqPe0uLK
	h+rWAYVWKRmDqAXFbViYHn8kC5omkps=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4806b0963a9so27925e9.0
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:20:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769577656; cv=none;
        d=google.com; s=arc-20240605;
        b=CBtSn0ztzm+8QKp3e6+M8Q1U6vtck/CGY4bqWZUPIRnPbd4QUE5kcw4nvs7UXAlBmF
         Vfoz/LDbrmW6nt0V05B2rpySIlLzx+gelLdycgkC63WrIhCRqOALpNqnmOMUztMlIqhG
         xYxhjZJvH54pAscPDIW5tTsOWYPKa7kaR6xUbH4rDtN5i7/vpuEPTc/qjD8WLxyGikAs
         6i6sIY9yDrUvxEB8eacflly0Or/5sKBdhti+H5T73UT50dUvVaNpGGfXOWuLp6b6RVt5
         Prit/nR2evyE/rhpbN7hoNEEa4dHmcfV2qZ2Z9haD2Yb8dQ/3ed7tRflJHfNo5vVnBmz
         LOxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V1J5+mim67A7RbbplsiEoQN/uCVwUx2jWg1suf/tpgM=;
        fh=ZJW7YCy54jBfy0r4sRFTJlTOITigsXyZvuu63cJaG3Q=;
        b=MyMEh+TSmTLVYwc31XdPxYvGgEjdrYyAtpUnR8Vb9kvEPjLfk3qWJSt+1J3WMhSO2L
         bJe1/3+SrNTKlHjLK9TbxqyFUMEpSK5oZXawitgbHdUVVcVcemgE1LlNuSC+6wr1HoSZ
         PT8tKciaLi5avCuIGJnVbHnY0MeWRN/5OARqzgOIXuEixmEG0++3skqvQAqfWYF+hSw4
         VPMNR+muavbTKk8Ib1JPggwh+OiktqppNc25BaTGgcO2eGAmZi11RhyioIqL8ysBxCUp
         n+gK6vXgstWlRPrH3s6gMIJW0XuReyBueKpUdPlpLJevj56qlBLvIQFFYnI6u1pvfYZY
         DkAQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769577656; x=1770182456; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V1J5+mim67A7RbbplsiEoQN/uCVwUx2jWg1suf/tpgM=;
        b=L7U96Aml/kGWPgRsavFj6d0S3dSKCAOdD5AO15RQ/MRB8x0x6ScVidLQgGcxAA2+Aw
         bR5RaJgS2KYiDtP6tAew43WzOJEJxHkJw3RlfhUPDsBJs13wts3lZ5E6Yxq6S7zmxHh0
         6kqI3zbht7fpK7NnU/Ys1o53CW47lyxAVwP45tINSDx5IgEwbT4TvMRU/0n3B7GkhcKf
         HpVA9IjfpEaGYD6bbpreOHNcm0pk+hulzRjBgsiyVCUxSn+hDP6UquwdHFS11APOEzO8
         SDW5grY5E/nyufcAXu/iV63qf5WKK69FsWYSXwXKSc0m++yB0Qw8zN0U+JI5aQJlbfLg
         O4hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769577656; x=1770182456;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V1J5+mim67A7RbbplsiEoQN/uCVwUx2jWg1suf/tpgM=;
        b=Hu2af/dQG5jR/FTxB9+X9MYD6o9Ak0Rlq6Pbv5hTvPctX4K1i07Bwahq4jfxnsQ8E2
         Iw/C7WGYaipctqDST/OEGoXAt9OLHEtci0aTLfKon0ww6HhM9DQFufMh5u1SaHxYStb7
         ZV713PjN+eVt8TkToZ++V8f6XhUSSVKPPaOUFXuW8D9JYS/6V9gkkP4RO9RLmf3e39o2
         NcBbTfEoVqnSI0QLpiM9lwxoFmfEq6iLeida8gBL4zZ8Jy75qi9n44Rvp7zCAdo8LRVk
         XNtZ0di7XyltR5XKegtyTpkJ2wFE2O6N9y2wbhwOQtMhis4X65j8gpd3zP+ODD9inWpS
         E27g==
X-Forwarded-Encrypted: i=1; AJvYcCUaHuRHpi0KhdeZTyy0RlBSW91Dmeh07GWaYsTwcPVFJAgOnJ1/zZWDiFYxiOVSIb6M+bL4m0OqCg==@kvack.org
X-Gm-Message-State: AOJu0YzDUuBVM2rt/pg474gt1yzEMHnkeYpG3Bqbr0+FCrwS3UOgWatg
	Mi4k7AbMpI+IlYB/mGE8t/WfGiXWyGluHdBKVyxspjDzKqeFVTRBQsffAY2t9AweXaULueIRC5s
	4yusG82aMJkbrwfxLNTW+qahAfygc+WtPWY0Zh85C
X-Gm-Gg: AZuq6aICss9dQL64NajDJaY2vMv4i17Zss+DUDJDB4//MahRr5WKYQEygZ1/74fNL7N
	B0EoBk5sLjGnBIHzzJEHv2bLrUnXAcWNHjUEMCUGozw9vvy3RQx9tSzeBC9gZxrlnhD+MjM6FkS
	JDUAXOwvzqpbyQiSDI/VCS/BAk7f7fs9O3DFJFDibnzy5ivt1qyPmbAYTg516t0WB0NKnG2uEwd
	SXIlMYIEhOoK7kQKQvDuyFZiJvIM42S92OjV4YXJEPRS1uTX0g3H0Qd6h+rQZlWQnrn/r3tztDs
	8/43UDV3PZaquJwSov9uB/Es48Y=
X-Received: by 2002:a05:600c:8208:b0:47e:de3a:a929 with SMTP id
 5b1f17b1804b1-48069b29697mr1219695e9.12.1769577655513; Tue, 27 Jan 2026
 21:20:55 -0800 (PST)
MIME-Version: 1.0
References: <20260112004923.888429-1-jiaqiyan@google.com> <20260112004923.888429-4-jiaqiyan@google.com>
 <e996cec7-f2ed-38ae-3f8a-c89ef61ffa49@huawei.com>
In-Reply-To: <e996cec7-f2ed-38ae-3f8a-c89ef61ffa49@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 27 Jan 2026 21:20:44 -0800
X-Gm-Features: AZwV_QjuK27ce0rpc2m79Hh_DIJ3F66eHcfvNwrwezMP7n1QVH2QRK6h1XL-oy8
Message-ID: <CACw3F51xvzo1YHW9OtUTcR2Yji1TR8_DkKyWR6AAsPaERZhVAQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mm/memory-failure: refactor page_handle_poison()
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: nao.horiguchi@gmail.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	harry.yoo@oracle.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: eff77qopnujmmjtdbgso8im5fp8ye1ya
X-Rspamd-Queue-Id: 7B04C20006
X-Rspam-User: 
X-HE-Tag: 1769577657-800318
X-HE-Meta: U2FsdGVkX1/9Rv7UCofgwihIWiNj4b4/fLatJ5XE0UhwY9PT4907PaAzW7b1L4v55/z+oU6nFxozUhI98eEfNbcQ2505IGM4zjfp72v1+QNec3ROkzvbbnOlGjXOuMWTdXGaF01/wLdSNuKtMaVkU8MqHAVbFMtnHNj1Gf5hNSiZiln3wgOWt5IyyuI0B8O17gTcSQaX+kfMW7e3yo1sEsnGai2EA0OsmSL9xgWbi3zM4ONdY08zIaBCrMCLC8mK7SLhLHjzVJcQu0MGnVPUiZAzQdiyX1TR++uWFutw0dU77OMftnijJHeUYXxIIhffdXLmLJlX43BfpOEh40t27cO5AD7JBOihBuiGLQKwXn6WwfgSIBA0YT09d2eFBECqZwyc3Yt+7rA/T2/EJcR2ffmjicTSK+zPs3eceyYfFWwiq7VQa31WzJUFmIufRVjKQi+Y2sM1SzqgAulxo3kXP6buUY+O6rgq2ISHfRsZwrRd/WQ2UpzKMRozWT+WzxLpRHv/CCen/s5bSPrvAN2VQIjyeNGrU2h2tQc0ljo9OZzIEPdpSA5lhrck98uVPFLho7OHbfbKxZBut49mIa7ZU8tC63AEK/GM+iTKXqaoarX+mA7cW0/atMy99ZUWyNX5dtUj6lZBL+/fP2m/mn4O9RD3PzoeL2o2AlrZgMEf5jnGQYFd5Pne8wfIHRKOkgtIWkO/cS/7h4K3o2iBWmHqSm7KJjvW7P3lThJdIEdng3cwFHBh7Vg29hu5V7XfRw2efJfAA7Mtjq1Jv9GFIeZryJdUKLZ9qFs/AqCkmfknQhKaIGT6l1gpeuFPNJKjMOPU8nwrTKVMflBIN2WYXyE8e8AkCStQh16QF6XQl8Nu8V8O2DRzLbtamkHjh1SqzeG0yudpQ1fl6SW8FPtHP496vthTWycy1W2QA6oyM5a122lov9YOBF+K4jaLsNAysUx/AKLSB5dlOM5OBameVC/
 oUC0rrGp
 tF2fsck+nXC5i8DZUBmfEscUAmctniVmlwlT4QRDm6huUYy5ng9kgmazyCEKR8+PPGEbAUvE6CP+HI6L32hjZdYPlx74p6Xvz6C9uHCiBrEf8quPOvUq7XytXtpINBHV8fxnPrOlO8lXD//jtQLSOOojvM/wFWe46UoYrLWDG91nhpNjfdurzP/oKoTdvvxT4Yl0+TZeoNxT4fKlt4sP/djLDOp7cxlS6i+CgMH7myj20HlfaIBj+G4mZ2e7RKkH4xVuC7UcdBeEwJJSpo7vv5xVtmfYgAY0VLhtC1oVJvQH5vs1SqbRpOl3rZPN8iYTTRSfIij5CPXLjBOtcQdL0iOPp4SlPtElsC7S/yiDexXrbU2n68OTAHZWITJRS4Dod2Oc1ijwzHVFKREGvgFajX+UfOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 7:41=E2=80=AFPM Miaohe Lin <linmiaohe@huawei.com> w=
rote:
>
> On 2026/1/12 8:49, Jiaqi Yan wrote:
> > Now that HWPoison page(s) within HugeTLB page will be rejected by
> > buddy allocator during dissolve_free_hugetlb_folio(), there is no
> > need to drain_all_pages() and take_page_off_buddy() anymore. In fact,
> > calling take_page_off_buddy() after dissolve_free_hugetlb_folio()
> > succeeded returns false, making caller think page_handl_poion() failed.
>
> s/page_handl_poion/page_handle_poison/
>
> >
> > On the other hand, for hardware corrupted pages in buddy allocator,
> > take_page_off_buddy() is still a must-have.
> >
> > Given hugepage and free buddy page should be treated differently,
> > refactor page_handle_poison() and __page_handle_poison():
> >
> > - __page_handle_poison() is unwind into page_handle_poison().
> >
> > - Callers of page_handle_poison() also need to explicitly tell if
> >   page is HugeTLB hugepage or free buddy page.
> >
> > - Add helper hugepage_handle_poison() for several existing HugeTLB
> >   specific callsites.
> >
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > ---
> >  mm/memory-failure.c | 84 ++++++++++++++++++++++-----------------------
> >  1 file changed, 41 insertions(+), 43 deletions(-)
> >
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index d204de6c9792a..1fdaee1e48bb8 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -162,54 +162,48 @@ static struct rb_root_cached pfn_space_itree =3D =
RB_ROOT_CACHED;
> >
> >  static DEFINE_MUTEX(pfn_space_lock);
> >
> > -/*
> > - * Return values:
> > - *   1:   the page is dissolved (if needed) and taken off from buddy,
> > - *   0:   the page is dissolved (if needed) and not taken off from bud=
dy,
> > - *   < 0: failed to dissolve.
> > +/**
> > + * Handle the HugeTLB hugepage that @page belongs to. Return values:
> > + *   =3D 0: the hugepage is free hugepage and is dissolved.
>
> In soft offline scene, dissolve_free_hugetlb_folio would return 0 when th=
e page becomes
> a normal page due to race.
>
> > + *   < 0: hugepage is in-use or failed to dissolve.
> >   */
> > -static int __page_handle_poison(struct page *page)
> > +static int hugepage_handle_poison(struct page *page)
> >  {
> > -     int ret;
> > +     return dissolve_free_hugetlb_folio(page_folio(page));
> > +}
> > +
> > +/**
> > + * Helper at the end of handling @page having hardware errors.
> > + * @huge: @page is part of a HugeTLB hugepage.
> > + * @free: @page is free buddy page.
> > + * @release: memory-failure module should release a pending refcount.
> > + */
> > +static bool page_handle_poison(struct page *page, bool huge, bool free=
,
> > +                            bool release)
> > +{
> > +     int ret =3D 0;
> >
> >       /*
> > -      * zone_pcp_disable() can't be used here. It will
> > -      * hold pcp_batch_high_lock and dissolve_free_hugetlb_folio() mig=
ht hold
> > -      * cpu_hotplug_lock via static_key_slow_dec() when hugetlb vmemma=
p
> > -      * optimization is enabled. This will break current lock dependen=
cy
> > -      * chain and leads to deadlock.
> > -      * Disabling pcp before dissolving the page was a deterministic
> > -      * approach because we made sure that those pages cannot end up i=
n any
> > -      * PCP list. Draining PCP lists expels those pages to the buddy s=
ystem,
> > -      * but nothing guarantees that those pages do not get back to a P=
CP
> > -      * queue if we need to refill those.
> > +      * Buddy allocator will exclude the HWPoison page after hugepage
> > +      * is successfully dissolved.
> >        */
> > -     ret =3D dissolve_free_hugetlb_folio(page_folio(page));
> > -     if (!ret) {
> > +     if (huge)
> > +             ret =3D hugepage_handle_poison(page);
> > +
> > +     if (free) {
>
> Nit: huge and free won't be both true. So we could write it as:
>         if (huge) {
>                 ...
>         } else if (free) {
>
> >               drain_all_pages(page_zone(page));
> > -             ret =3D take_page_off_buddy(page);
> > +             ret =3D take_page_off_buddy(page) ? 0 : -1;
> >       }
> >
> > -     return ret;
> > -}
> > -
> > -static bool page_handle_poison(struct page *page, bool hugepage_or_fre=
epage, bool release)
> > -{
> > -     if (hugepage_or_freepage) {
> > +     if ((huge || free) && ret < 0)
>
> Nit: ret won't be <0 if both huge and free are false. So I think we might=
 simplify it as:
>
>         if (ret < 0)
>
> >               /*
> > -              * Doing this check for free pages is also fine since
> > -              * dissolve_free_hugetlb_folio() returns 0 for non-hugetl=
b folios as well.
> > +              * We could fail to take off the target page from buddy
> > +              * for example due to racy page allocation, but that's
> > +              * acceptable because soft-offlined page is not broken
> > +              * and if someone really want to use it, they should
> > +              * take it.
> >                */
> > -             if (__page_handle_poison(page) <=3D 0)
> > -                     /*
> > -                      * We could fail to take off the target page from=
 buddy
> > -                      * for example due to racy page allocation, but t=
hat's
> > -                      * acceptable because soft-offlined page is not b=
roken
> > -                      * and if someone really want to use it, they sho=
uld
> > -                      * take it.
> > -                      */
> > -                     return false;
> > -     }
> > +             return false;
> >
> >       SetPageHWPoison(page);
> >       if (release)
> > @@ -1174,7 +1168,7 @@ static int me_huge_page(struct page_state *ps, st=
ruct page *p)
> >                * subpages.
> >                */
> >               folio_put(folio);
> > -             if (__page_handle_poison(p) > 0) {
> > +             if (!hugepage_handle_poison(p)) {
> >                       page_ref_inc(p);
> >                       res =3D MF_RECOVERED;
> >               } else {
> > @@ -2067,7 +2061,7 @@ static int try_memory_failure_hugetlb(unsigned lo=
ng pfn, int flags, int *hugetlb
> >        */
> >       if (res =3D=3D 0) {
> >               folio_unlock(folio);
> > -             if (__page_handle_poison(p) > 0) {
> > +             if (!hugepage_handle_poison(p)) {
> >                       page_ref_inc(p);
> >                       res =3D MF_RECOVERED;
> >               } else {
> > @@ -2815,7 +2809,7 @@ static int soft_offline_in_use_page(struct page *=
page)
> >
> >       if (ret) {
> >               pr_info("%#lx: invalidated\n", pfn);
> > -             page_handle_poison(page, false, true);
> > +             page_handle_poison(page, false, false, true);
> >               return 0;
> >       }
> >
> > @@ -2836,7 +2830,7 @@ static int soft_offline_in_use_page(struct page *=
page)
> >               if (!ret) {
> >                       bool release =3D !huge;
> >
> > -                     if (!page_handle_poison(page, huge, release))
> > +                     if (!page_handle_poison(page, huge, false, releas=
e))
>
> This might not work for soft offline. PageHWPoison is not yet set so foli=
o_clear_hugetlb_hwpoison
> won't be called when dissolve hugetlb hugepages...

Thanks for pointing this problem (and the later problem) out, Miaohe!
You are right, and I think the reason for both problems is, soft
offline is a totally different case than memory_failure(): there is no
PG_HWPoison until the end of page_handle_poison(). So
free_has_hwpoisoned() can't help dissolve_free_hugetlb_folio() to
exclude the page that triggered soft_offline_page().

For free_has_hwpoisoned(), I should only change the call sites in the
memory_failure() path, and leave
soft_offline_page()/page_handle_poison()/__ __page_handle_poison()
alone. Looking at the current code, HWPoison hugetlb pages happens to
be handled by __page_handle_poison() in either me_huge_page() or
try_memory_failure_hugetlb(). So I think I can replace them with a new
function that doesn't do take_page_off_buddy(), something like:

 /*
+ * Only for a HugeTLB page being handled by memory_failure(). The key
+ * difference to soft_offline() is that, no HWPoison subpage will make
+ * into buddy allocator after a successful dissolve_free_hugetlb_folio(),
+ * so take_page_off_buddy() is unnecessary.
+ */
+static int __hugepage_handle_poison(struct page *page)
+{
+       struct folio *folio =3D page_folio(page);
+
+       VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
+
+       /*
+        * Can't use dissolve_free_hugetlb_folio() without a reliable
+        * raw_hwp_list telling which subpage is HWPoison.
+        */
+       if (folio_test_hugetlb_raw_hwp_unreliable(folio))
+               /* raw_hwp_list becomes unreliable when kmalloc() fails. */
+               return -ENOMEM;
+
+       return dissolve_free_hugetlb_folio(folio);
+}
+

On the other hand, just leave __page_handle_poison() and
page_handle_poison() as is to do take_page_off_buddy() for soft
offline case.

>
> >                               ret =3D -EBUSY;
> >               } else {
> >                       if (!list_empty(&pagelist))
> > @@ -2884,6 +2878,8 @@ int soft_offline_page(unsigned long pfn, int flag=
s)
> >  {
> >       int ret;
> >       bool try_again =3D true;
> > +     bool huge;
> > +     bool free;
> >       struct page *page;
> >
> >       if (!pfn_valid(pfn)) {
> > @@ -2929,7 +2925,9 @@ int soft_offline_page(unsigned long pfn, int flag=
s)
> >       if (ret > 0) {
> >               ret =3D soft_offline_in_use_page(page);
> >       } else if (ret =3D=3D 0) {
> > -             if (!page_handle_poison(page, true, false)) {
> > +             huge =3D folio_test_hugetlb(page_folio(page));
>
> folio_test_hugetlb check is racy because there's no guarantee that hugetl=
b hugepage won't
> be dissolved before calling page_handle_poison. That will lead to problem=
...
>
> soft_offline_page
>   folio_test_hugetlb -- true now
>   page_handle_poison
>   /* Hugepage is dissolved somewhere. */
>     hugepage_handle_poison -- return 0 because page is normal page or fre=
e buddy page.
>     SetPageHWPoison(page);
>     page_ref_inc(page); -- refcnt is increased while page might be on bud=
dy...
>
> > +             free =3D is_free_buddy_page(page);
> > +             if (!page_handle_poison(page, huge, free, false)) {
>
> We assume free is always true due to ret is 0. So we can write it as:
>         if (!page_handle_poison(page, huge, true, false)) {
>
> >                       if (try_again) {
> >                               try_again =3D false;
> >                               flags &=3D ~MF_COUNT_INCREASED;
> >
>
> Thanks.
> .
>

