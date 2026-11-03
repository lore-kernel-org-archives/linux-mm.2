Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4899F606A327
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tpqnxk4v
Received: by kanga.kvack.org (Postfix)
	id 653E76B00EF; Tue,  3 Nov 2026 11:08:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 604E66B05B2; Tue,  3 Nov 2026 11:08:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519AD6B05B3; Tue,  3 Nov 2026 11:08:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3389A6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:08:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C1894A8026
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:08:33 +0000 (UTC)
X-FDA: 85394290506.06.54C6B09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id B55A7A000B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:08:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tpqnxk4v;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793722111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SvBxcU0JLNXA5MaTI7MCEmWVgzZuquV24Fb0g4m3Vl4=;
	b=U9dowDshJMyslS9yUnAWr7bZKndKAzUFUAj37SW/Ptjt9JUIVGDP/nS1a/4EqYysZE7YZb
	MVR9Yi9VQCeausgCpKVclBtQ40XOcaORYV36pyvjpDP4EuyhG6HAybFt48DMdomNFGHKUS
	+wRNLsNeR/HKgNobpVGuQmS0JjJ+2TU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793722111;
	b=rEqIKFbP24ITEHXK7Pf+3muDSDlBzCa2+cTbso1aUZhMWxwFbcPS0n8MRFSu3iKD6tJJaT
	8RGXmLDp3pacn+IiMY4onZEhfrMGxT0LpTitSJR08JKB/DojvMj6zncL1kX0El5kxAhFl/
	2isRV0hn+WINZ1aRQ+QAb9rVQagvVVw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tpqnxk4v;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D4B4A40762
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DBF1F00A02
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793722110;
	bh=SvBxcU0JLNXA5MaTI7MCEmWVgzZuquV24Fb0g4m3Vl4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Tpqnxk4v7O7cDlHQSOIdarQW8h114qvCR4rA83k23tIgNGlLvZN5zU0JyBchOVxRJ
	 7jUSpgD6p/qx//0BZh6qtlfmgxwzggxLfQXlqiTBOcmRYFWltQDNULbMDwZFjndek5
	 SuFp7ypbGPHSG/qC3QGzdu4fiidAiWBqcozHMpX57iEytcwP7G0JFRMlExqeb7+9lj
	 cqJdiIA4z+ClLUb4UFLxkIiuAAs4QCr8PvK2u0xUKfzzs3feE9HFJoycPKYbg4Sg/P
	 tu1xaF73JnnS2WraaOze2v39F2kuFmRaaUHrRc1iwi/n2kkq0MgmGleJScNbOLNb9T
	 L/ut3Ljl5Pl+w==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c434376dbebso202262366b.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 08:08:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxPcWU8eGGRFgOBYZ1J5ocNr7SKJUh2Z2hjzOikBJe/yBe7AMAqqvOiP/j7/ZIDxb26kMtwVsowaQ==@kvack.org
X-Gm-Message-State: APuU4Z9CYn+8Ztgaxwyh7awXX3VvZVhks7MIYxagV/esgUoPuJbRoxER
	kleFuIEBUDEW+YkfRD/VjV6GlICRZ3ODkioKA8rwB51rquQvaFyFEPmjqNZIj0QPNyE3xCckrk0
	1sZts1xfnk3qwWmuTKdI641ALZzzZp8Y=
X-Received: by 2002:a17:907:869f:b0:c41:825d:ed8c with SMTP id
 a640c23a62f3a-c49d147e127mr1481901066b.26.1793722109538; Tue, 03 Nov 2026
 08:08:29 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103000313.13677-1-kanchanapsridhar2026@gmail.com> <sashiko-outbox-194595@kernel.org>
In-Reply-To: <sashiko-outbox-194595@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 3 Nov 2026 08:08:18 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOdbbn0XGKoU_9ktNJJtn19oP8JxOX1uVs+-BLe0GdCTw@mail.gmail.com>
X-Gm-Features: AclHuK9wS_mhc5Y-JGS88yPApAQKys0rl04uUxuRn3Xg8ICSN0ztaY2JRlrhkNo
Message-ID: <CAO9r8zOdbbn0XGKoU_9ktNJJtn19oP8JxOX1uVs+-BLe0GdCTw@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] mm: zswap: Move the crypto_acomp to be per pool,
 instead of per-CPU.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, Barry Song <baohua@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	sashiko-reviews@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: wj6nagbetf7kf9ebawprfrpnmzmrwjzy
X-Rspamd-Queue-Id: B55A7A000B
X-Rspam-User: 
X-HE-Tag: 1793722111-359247
X-HE-Meta: U2FsdGVkX18c7gd8BNPGSs1p8TrWlQ7w9Oo5ppVTgVLnZgnb3d43IZF46u0hgqy0PGgAT42On6nlyvOo/Wg8e9KuKp+aB+Nd7KjbamWgzptMqd3MLqVLXcquHhwe3Lb57tRNmg82Zh80LlctVhMnIUxlCMjN0wNhu40+Nuqj3kLN6vrPvVSgGp9tOyr8QOiHDwEd1YSZckNmjneSKW6TGxKDv7IOhT30UG0fr/u39OpgrjE9GoBgSXcsHWREghp24KNOXhov4DSckLTEpsfoxACb81NgCSN/PtJqRDSG+8Cnmxe9ph+SSX0s1tkOmhXXqtyY0+6aBgf0NduQL6I0n1vIKx/OK+vM+xwrWRX/bD9zhBQHT+Aj5m18rgbZ7L/sZsQbdMCYb5Wbzqdzj0wvUhrkyOuQ/JED5toX3v7z1bUIUYIBJwcoeMskbcW3F12V5Fd73OBGRB0X51yjNtij+RA8wl9WGbf/E7oyXIV/kPvDXX6d3myGpZNoZ4UW26btpkw662sWZPO4oOnhfTYQyTZ7c3l43zMcfHrn3iyjjCkeBXEFkf+lQT3+ozQQuxWqnkKPSlCDlzP98oSYwU+fF30M+gu2JTOl3M1O1k5vFOc+YJ2mUxu9ISK+jp/swvy5cJGyRBCFPDwZaEtju0cJbSezlZFKpbHKwsuBebF8wsxp5NY7SmGaLxvJDFV09e3eIpZ/J6JyN6hCukB0XslpeKH2tflL6E4OZiLVr3xS1JXdSHZfgKSXAp75dtYptHoXgfUYxn10/sRtcc2gvOq2bCYnsKiLxfBWzVqJhJAJcFBSXN5G86LObQO4aq0IVVvNFoczJ/zkQd04asrLsjLQ98QM5G6ykYamw3vkrbkvA8gTUqwDLm62dSVFVYDFvHx7WrEbZmCgE1eAMxgbVxfB8F+o5S8BuAji0BzcDtzid2HMCBidgjH0YFzFl3K8OFRleAsVFJBjTDMdwNI0UnU
 SJVgEYab
 JAawah5KpR0BVtc5DaQffFze0NWC2VdmzOvhp0oypDiOi0Bg530KVctcuxIirKVXLGGo8BrdezMsjE/OHGQ5TzNJePpuXAiTMFlQRe4OPolB/BL97AY0L9oYkeJ4lJ7FiFlA+HxK48rl4UVY6HVzCG+mEpYc5PVh7EfsF8ddCByylevKPUHhEx6Gnhe2kxq74nAfZrUum5UkxpQvD05rxsjOSty0d8IXAY5yj4gqWZ1lwzf51lq+cpod51DrBcQm+JV9VkIG1LqkCw9p0j3V6bK6UlnFXOaiMTzlb97de5Nkd8R6uOeAMcLGpSJObEUIz5xqiV7HNuL7EwNdfZ6ZnG57uRZlC0FKPmzEXXTVaXHtDHLliNOuZBfLGjQFGFRzMTbZ6z3YUGwFd32TJ9Sv8Hdp20wI04tnjjaPHXMia/BimXkmcbi8zP0dbKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 2, 2026 at 9:42=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] mm: zswap: per-pool crypto_alloc_acomp() breaks NUMA and HW qu=
eue scaling
> --
>
> commit 0abfb2c1c527ffcd5ca8df2224cd1c4533f5face
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> mm: zswap: Move the crypto_acomp to be per pool, instead of per-CPU.
>
> This commit moves the struct crypto_acomp instance from the per-CPU struc=
t
> crypto_acomp_ctx into the global struct zswap_pool, allocating a single
> transform per pool in zswap_pool_create() instead of allocating one per C=
PU
> in zswap_cpu_comp_prepare().
>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 37d217860a6b2..a958b74d4425d 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
>
> [ ... ]
>
> > @@ -323,6 +313,17 @@ static struct zswap_pool *zswap_pool_create(char *=
compressor)
> >
> >       strscpy(pool->tfm_name, compressor, sizeof(pool->tfm_name));
> >
> > +     /*
> > +      * In case of an error, crypto_alloc_acomp() returns an
> > +      * error pointer, never NULL.
> > +      */
> > +     pool->acomp =3D crypto_alloc_acomp(pool->tfm_name, 0, 0);
> > +     if (IS_ERR(pool->acomp)) {
> > +             pr_err("could not alloc crypto acomp %s : %pe\n",
> > +                     pool->tfm_name, pool->acomp);
> > +             goto error;
> > +     }
>
> [ ... ]
>
> > @@ -841,34 +857,20 @@ static int zswap_cpu_comp_prepare(unsigned int cp=
u, struct hlist_node *node)
> >        * To handle cases where the CPU goes through online-offline-onli=
ne
> >        * transitions, we return if the acomp_ctx has already been initi=
alized.
> >        */
> > -     if (acomp_ctx->acomp) {
> > -             WARN_ON_ONCE(IS_ERR(acomp_ctx->acomp));
> > +     if (acomp_ctx->comp.areq.req)
> >               return 0;
> > -     }
> >
> >       acomp_ctx->comp.buffer =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL, cp=
u_to_node(cpu));
> >       if (!acomp_ctx->comp.buffer)
> >               return ret;
> >
> > -     /*
> > -      * In case of an error, crypto_alloc_acomp_node() returns an
> > -      * error pointer, never NULL.
> > -      */
> > -     acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0=
, cpu_to_node(cpu));
> > -     if (IS_ERR(acomp_ctx->acomp)) {
> > -             pr_err("could not alloc crypto acomp %s : %pe\n",
> > -                             pool->tfm_name, acomp_ctx->acomp);
> > -             ret =3D PTR_ERR(acomp_ctx->acomp);
> > -             goto fail;
> > -     }
> > -
> > -     ret =3D zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->ac=
omp);
> > +     ret =3D zswap_acomp_req_init(&acomp_ctx->comp.areq, pool->acomp);
>
> [Severity: Medium]
> Does replacing the per-CPU crypto_alloc_acomp_node() call in
> zswap_cpu_comp_prepare() with a single non-NUMA-aware crypto_alloc_acomp(=
)
> call in zswap_pool_create() cause a NUMA locality and hardware queue scal=
ing
> regression for hardware compression accelerators?
>
> Previously, commits 7bc13b5b60e9 and 1ec3b5fe6eec allocated a dedicated
> struct crypto_acomp per CPU on cpu_to_node(cpu) so that hardware compress=
ion
> drivers would allocate per-CPU, NUMA-local hardware queues.
>
> While software scomp backends and Intel IAA select per-CPU streams or
> workqueues at request submission time, other hardware acomp drivers bind
> hardware queues, rings, and NUMA-local accelerator devices to the struct
> crypto_acomp transform during initialization based on the transform's nod=
e.

Adding Barry here, I think this undos the optimization he previously added.

>
> For example, in drivers/crypto/hisilicon/zip/zip_crypto.c,
> hisi_zip_acomp_init() allocates one compression queue pair, one
> decompression queue pair, and a per-transform request queue and spinlock =
on
> tfm->base.node:
>
> drivers/crypto/hisilicon/zip/zip_crypto.c:hisi_zip_acomp_init() {
>         ...
>         ret =3D hisi_zip_ctx_init(ctx, COMP_NAME_TO_TYPE(alg_name), tfm->=
base.node);
>         ...
>         ret =3D hisi_zip_create_req_q(ctx);
>         ...
> }
>
> Similarly, in drivers/crypto/intel/qat/qat_common/qat_comp_algs.c,
> qat_comp_alg_init_tfm() binds the transform to a single hardware compress=
ion
> ring pair on tfm->node:
>
> drivers/crypto/intel/qat/qat_common/qat_comp_algs.c:qat_comp_alg_init_tfm=
() {
>         ...
>         inst =3D qat_compression_get_instance_node(node, alg);
>         if (!inst)
>                 return -EINVAL;
>         ctx->inst =3D inst;
>         ...
> }
>
> With a single pool->acomp allocated via crypto_alloc_acomp() (passing
> NUMA_NO_NODE), won't all CPUs across all NUMA nodes share and contend on =
a
> single hardware queue or ring pair on one accelerator device while leavin=
g
> all other hardware queues and NUMA-local devices unused?
>
> Also, if pool->acomp is shared across all CPUs, should the comment in
> zswap_compress() be updated as well? It currently still states:
>
> mm/zswap.c:zswap_compress() {
>         ...
>          * but in different threads running on different cpu, we have dif=
ferent
>          * acomp instance, and compression and decompression use separate
>          * requests, so multiple threads can do (de)compression in parall=
el.
>          */
> }
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103000313.13=
677-1-kanchanapsridhar2026@gmail.com?part=3D1

