Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B55FED116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 22:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39906B0089; Mon,  1 Dec 2025 17:06:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11006B008A; Mon,  1 Dec 2025 17:06:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4F006B0092; Mon,  1 Dec 2025 17:06:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B60B16B0089
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:06:13 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FE0FB92B6
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 22:06:11 +0000 (UTC)
X-FDA: 84172286142.15.9356127
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3C1CC1C001F
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 22:06:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JKBhPj3w;
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764626769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RjsD19aCUMHa2E8WfpptbpfT6kxnKtjPzjy54H5oDQE=;
	b=XAkXFmJ1E+eMbaE2fuAcl7YAYVbxfwXP3dGQ95kYnu8oe0g+ENFK7DlTvUysRcRZfVhqbQ
	srIGTdAS8+Wd2UonfEazIWGM2cQuM3B6BWjlttbvXU0TeqC4eNM/gde30WLsjI3xqPG4bv
	FukgHnXbCLZMN21pvO5bnZOgHG2iA5M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JKBhPj3w;
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764626769; a=rsa-sha256;
	cv=none;
	b=i9QlkrGrjT1p046Z7RYaRwak0/a1el+Azx3UOnQbMigDTL24MB0+VaTBbN5QSK917V6h4+
	nZWAnNzGb0+Ppgb0GXWr44aCOpp75e79mqFZkJRYL4SF6VRZn6HMPMU5iJMIlwu8IYUVi/
	ibzixyJicYQtjuPdforDd1ufcCLBVF0=
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-5dfb5fcf063so1440191137.1
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 14:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764626768; x=1765231568; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RjsD19aCUMHa2E8WfpptbpfT6kxnKtjPzjy54H5oDQE=;
        b=JKBhPj3wXqxbBJ3d6LwaEVUunLvjlCOCPYGNOWN58G6E+ZzN69LMqxV3lsQrrifMZQ
         aVKPx2GMpK2kX2frx+D2SZerXfWkly0/poW6z5UNGqDlMyZulMiSGgF54rjntg2WpNN5
         XCZmabvwv+Aq8/tpm6yquEvElwDYImQEJvffqDKGZsVMA+iutyW1VklcNyY4vRq7wAUO
         Xg82zOL+Bm+1DEdSrpuvIUarQpctRGZiPwfxuGylaiQd5RbAjButgWj5z1rhx7pB21oo
         l0Shg8cohl33gBBiqN9tQTOZ36gefywvonInsPJfT02mjOl0dXknggFpdJbp6VKUX6X/
         Q6/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764626768; x=1765231568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RjsD19aCUMHa2E8WfpptbpfT6kxnKtjPzjy54H5oDQE=;
        b=H3onQFgi6JHj/D4FVQYmeNuCZdWFwXxrH8FOhYcROLCqUCFKGQmadMSpiZ8BrfWHxl
         w9wfyFotwSV/ymPKKMMXNgwIRcaeGLut6zuYMvtJcF/PrE0Xaa3+9ClxWaplywIEM9Wz
         ajrLL1aMQlfFyw6yex+hEn3VboxBkjf0UeM3cdvM83qqRtIPNebW+zPofla29A9hwV0I
         eD5fyho8+CcsvmkZQ8DIXWtUad6kRC41KMFgrRm1d74+f/yA0W0a/m9AdkDnNA/77I3W
         5o7i/rH7GwPfNUca6GphJd1thL80Y0QzlXxjPkgSjj8cBM/jRc5nHbGdiCWVHbCNaXeg
         lPQw==
X-Forwarded-Encrypted: i=1; AJvYcCVLECcLipHJjCEekNnoNI4dzIuXZLQnV7V3er2Zleo70zDiqw/jfuVWSAFZSoDRSb0DxqSDcLfvDw==@kvack.org
X-Gm-Message-State: AOJu0Yy710yaFBa4+syRyFVnCehjyj8TBeZIn+aWPKN9EKhBTvGyIgW/
	jsvOto9dEHgL8uHWgU3wePNhT3Op9gpSUw8ngf5lw9T4Za3SBn1lOWibicImIhAkhIounQRXZm5
	TqWvVS8w16MJNmZBZxDBdleMCOLufiX8=
X-Gm-Gg: ASbGncu332XOaRgQXNsF07sGSh4Qmrrg4pucwqLQBTujM4iePyRFEKRt7zwBjlp/iUA
	/sU1I1dK/F9DA6RfNROSGPyMAt0bEyN3/D5noz21qaDgQfFnQRRwJ5WU2nfCXFMnbKobRabfeQw
	/eUwesybBTuCm1jK9L8eqTWdjjcbXJFGtao8ZdXPMV07+6ikVL7C8SOEmjaNLIvxXlYahDNmHPY
	7LnfN+eJmqPvVeTqlC/i1Qz0WUZbip+9MWJ1dMkDjwW4BPXwd9+Wa9sjBsQxWEsBri4EA==
X-Google-Smtp-Source: AGHT+IHy9MubOTLG2etzaabSpxtKy1Lb/AjgjOqAEtXPMeO1sBbpyDe9CCi6vq0uRyBGY3AdXltB4if2OEMaCAYo1tg=
X-Received: by 2002:a05:6102:5805:b0:5db:c987:d8f4 with SMTP id
 ada2fe7eead31-5e22421c58amr9629989137.7.1764626767957; Mon, 01 Dec 2025
 14:06:07 -0800 (PST)
MIME-Version: 1.0
References: <20251122090343.81243-1-21cnbao@gmail.com> <aSiB-UsunuE7u295@milan>
 <CAGsJ_4z21fN2KSg6jt_qveYgrKZw1Vsi_kb+uhed=RJAbujMHw@mail.gmail.com> <aS13J6U-QMOrwwbs@milan>
In-Reply-To: <aS13J6U-QMOrwwbs@milan>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 2 Dec 2025 06:05:56 +0800
X-Gm-Features: AWmQ_bmgxK1g1aP9fycsrkY4ZrS4yYO9pthpUyw8iDWG0FYFC6_bJ-WYcNubwhU
Message-ID: <CAGsJ_4yGLdhk84Ent8VRcE4_2Am_U=bXTVdV2LHDBtD2OZs8xg@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/vmap: map contiguous pages in batches whenever possible
To: Uladzislau Rezki <urezki@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, John Stultz <jstultz@google.com>, 
	Maxime Ripard <mripard@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3C1CC1C001F
X-Stat-Signature: wx9zas9y59pnfukhrpybappk8uz695fm
X-Rspam-User: 
X-HE-Tag: 1764626769-640459
X-HE-Meta: U2FsdGVkX1/QjR7QDqJP+/HCmcUUFZaRt6QR+Pj+9jYQajfc9Qhbus8g5p0w0rIn4WdxVmnQtuNT6HCOjJWnHyc786tVztZUVq92qCYyFSC1h5OTLXnYHPV/uNZkt3HxWLyhivZvBfQmRfGdjLk2h2E8nSW4HmAq8ZiSqax6ojrk0+vRjGTiyZsJ3qWV0s+VfDe3tnmkKRRox3pcwPahIVT6BjvaCXIBv9nzjLP14jeXznN2cvqkQ16yEVThw4ctc0+RFPTLni0NF74j3+8cBQqRVqcrhSImfkqHxlJJjMvtPOEjvGzHAmOTxfuR9Ewc7itDJ9oukIM2PfBZUMZ1Ci8GhztfCaIf5V2+zInK/CA0Ab4/4V8T24w33Q58pWx5SUB9POlbeur636JCmlQXTbBgbnlCN5SsegRd/mKEEIQfwxWOSRF7xSRE7WNhP8I86zY1cuU2dtAeCfrnS7qXj45LWv2DJOBZxnGDnhSQJ6Ue9uIJeCTaI7U8S2NCU6EWYroRxrzuYTWUtPpat01D8XwThMPrwX3vQ9TxgERsFz97kZX48mTk4Q+OMLHEfWgeGyLiS3NbToHfFNKW8+YBwK/t7eUG6UhyF8O1/8dhfQ2M09JKtiqHZ/ejUoiyd+UgzE5wrYNhJ1OV+uT4ja+iKbrq+eJNE7d7iKPudhh2aLdG9pzyeD7iWqowzNqH8ghLl5ZzDgqDlqEcVRrfEVateY8fhdBkaHcjQDNgLSeqa4OHCt2BJd1VIGf4QewbACeXFkRX4lLMi7X6Pym7eyQRRKMCIhj1nrxq0x8lUUJlNlAd4Wec2FUbFN9gfivVJjNahiD80modV5K23Pi+GNkYXCcftP5pLmPKV7ljpAvn+0gw1PHtAY3CaCbneQucAVYeyPI/skpWYeEXGLAHTohEc+aTTl4zb3xPMYPUVoVnPIRu1j/aT6aDqETW96KQv1ZZeKPiLoxWNolAZDa2eMG
 reneBGS1
 jsunSPPWftzisqD24eO3hzxnaR66jRndv/xjALZDaIN5AmZ4StK0fnCV79Fq0cXt+4c22GWabEr1UOhDz2vONqq+WSM58m3g/K5DxsVvyU8q8U0gD2OhjfgXwELH1q8CeWSWkygnTGeVZCMdMoUC2+Rpjdwz0eyHeUJ3ahMX3L8FQH5VP+n6CRa1/L51U3l0P8mpu942l173vr/kufUytwl6GfljMko+y6h5QUDOkJWkavVZMHA5QC42HvTYaLCgx/Uc8IqgJxjMD+XCywPpMhMFQu/VpJ3QhBJkcVmQVSchhhYZ7FunOrmNs30QHXekvgky23QQZ8H6GDygBry2UM/ghKMTmH47t58B0BSi6dnxSbFFVBpI09NVylzO3SW+xCgH7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 1, 2025 at 7:08=E2=80=AFPM Uladzislau Rezki <urezki@gmail.com> =
wrote:
>
> On Fri, Nov 28, 2025 at 04:43:54AM +0800, Barry Song wrote:
> > > >
> > > > +     /*
> > > > +      * Some users may allocate pages from high-order down to orde=
r 0.
> > > > +      * We roughly check if the first page is a compound page. If =
so,
> > > > +      * there is a chance to batch multiple pages together.
> > > > +      */
> > > >       if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> > > > -                     page_shift =3D=3D PAGE_SHIFT)
> > > > +                     (page_shift =3D=3D PAGE_SHIFT && !PageCompoun=
d(pages[0])))
> > > >
> > > Do we support __GFP_COMP as vmalloc/vmap flag? As i see from latest:
> >
> > This is not the case for vmalloc, but applies to dma-bufs that are allo=
cated
> > using alloc_pages() with GFP_COMP.
> >
> > #define LOW_ORDER_GFP (GFP_HIGHUSER | __GFP_ZERO)
> > #define HIGH_ORDER_GFP  (((GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN \
> >                                 | __GFP_NORETRY) & ~__GFP_RECLAIM) \
> >                                 | __GFP_COMP)
> >
> > >
> > > /*
> > >  * See __vmalloc_node_range() for a clear list of supported vmalloc f=
lags.
> > >  * This gfp lists all flags currently passed through vmalloc. Current=
ly,
> > >  * __GFP_ZERO is used by BPF and __GFP_NORETRY is used by percpu. Bot=
h drm
> > >  * and BPF also use GFP_USER. Additionally, various users pass
> > >  * GFP_KERNEL_ACCOUNT. Xfs uses __GFP_NOLOCKDEP.
> > >  */
> > > #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |=
\
> > >                                __GFP_NOFAIL |  __GFP_ZERO | __GFP_NOR=
ETRY |\
> > >                                GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOU=
NT |\
> > >                                GFP_USER | __GFP_NOLOCKDEP)
> > >
> > > Could you please clarify when PageCompound(pages[0]) returns true?
> > >
> >
> > In this case, dma-buf attempts to allocate as many compound high-order =
pages
> > as possible, falling back to 0-order allocations if necessary.
> >
> OK, it is folio who uses it.
>
> > Then, dma_buf_vmap() is called by the GPU drivers:
> >
> >  1    404  drivers/accel/amdxdna/amdxdna_gem.c <<amdxdna_gem_obj_vmap>>
> >              dma_buf_vmap(abo->dma_buf, map);
> >    2   1568  drivers/dma-buf/dma-buf.c <<dma_buf_vmap_unlocked>>
> >              ret =3D dma_buf_vmap(dmabuf, map);
> >    3    354  drivers/gpu/drm/drm_gem_shmem_helper.c
> > <<drm_gem_shmem_vmap_locked>>
> >              ret =3D dma_buf_vmap(obj->import_attach->dmabuf, map);
> >    4     85  drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
> > <<etnaviv_gem_prime_vmap_impl>>
> >              ret =3D dma_buf_vmap(etnaviv_obj->base.import_attach->dmab=
uf, &map);
> >    5    433  drivers/gpu/drm/vmwgfx/vmwgfx_blit.c <<map_external>>
> >              ret =3D dma_buf_vmap(bo->tbo.base.dma_buf, map);
> >    6     88  drivers/gpu/drm/vmwgfx/vmwgfx_gem.c <<vmw_gem_vmap>>
> >              ret =3D dma_buf_vmap(obj->import_attach->dmabuf, map);
> >
> Thank you for clarification. That would be good to reflect it in the
> commit message. Also, please note that:

Sure.

>
> >       if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> > -                     page_shift =3D=3D PAGE_SHIFT)
> > +                     (page_shift =3D=3D PAGE_SHIFT && !PageCompound(pa=
ges[0])))
> >
> we rely on page_shift =3D=3D PAGE_SHIFT condition for the non-sleep vmall=
oc()
> allocations(GFP_ATOMIC, GFP_NOWAIT), so we go via vmap_small_pages_range_=
noflush()
> path. Your patch adds !PageCompound(pages[0]) also. It is not a problem
> since it is vmap() path but we need to comment that.

Sure. Would the following work?

        /*
         * For vmap(), users may allocate pages from high orders down
to order 0,
         * while always using PAGE_SHIFT as the page_shift.
         * We first check whether the initial page is a compound page. If s=
o,
         * there may be an opportunity to batch multiple pages together.
         */
        if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
                        (page_shift =3D=3D PAGE_SHIFT && !PageCompound(page=
s[0])))
                return vmap_small_pages_range_noflush(addr, end, prot, page=
s);

Thanks
Barry

