Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA2F606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 00:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wtZM9a0n
Received: by kanga.kvack.org (Postfix)
	id B047E6B05B3; Thu, 29 Oct 2026 20:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADB9E6B05B4; Thu, 29 Oct 2026 20:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3536B05B5; Thu, 29 Oct 2026 20:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73C8D6B05B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:11:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B6BF160406
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:11:41 +0000 (UTC)
X-FDA: 85377364002.08.CA69869
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1461840004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:11:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=wtZM9a0n;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793319099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eMFC2eyPXrFFKJU701P6neL6odKYpxUo97XpYgZl+Gs=;
	b=XrF08RWY0n2s8xSrlqnbZF5si81WGXn3eThsrnptUp8BzyACIW/KgEzL4fweN6fdH89mQP
	oBn5LFm9zBwLhHTnKUsRKEJSNoX4T4SqW2cHWY4x/piMWi1Q1vYBOK9r5DaOPBVZKveZk3
	+DSAASFP49kL+Y9Axh0hsox3KGknfXU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=wtZM9a0n;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793319099;
	b=uvdrPRplIKFPjdhS4lEhV9ajY1F37sfy6CX9rhhh4Astafr/qxY8Bcf5qOjVACKfRajXXI
	KgQ3+Cpbx+U/2BN5riPada2serM40efE3edV40ksv6jYEM56F3ZUWxYRa51xsL31eamXtW
	GOR43a4cwqWmbGfq23fKF9IT+IfAY8U=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5be3ed646a5so216726e87.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:11:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793319097; cv=none;
        d=google.com; s=arc-20260327;
        b=U369LCs1ZX2IAjdpiPAA/AyY6IUgQ8xH3/iNdQ1loIJbwLf89dpN8qvH2BTAnr9lcQ
         P9lbgMWxwT+edIw5S8m4FUwMFJM/+iPW4s2VtcO9OsJnurm/Sli8rGlpx5U2m2lY7dfC
         h3wzEJJM5XCvFKwULEjXQ5gUQH2ugcSKSLpZR/dveKjaZe+W699pLA89QntQlCbaDjGa
         jeWK6qMKS4l8H6nhWImtDX7xIowxLikYc/0RvQnH3C1yMD97/B9i8y+v6a06C5HAEwsG
         eT0X498Qa1qloTBVAUtYJRBjqYMKGhiLuNbfurLNgqkcxn9SEo4TShBAZgU9sbBE8Y1Z
         cyhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eMFC2eyPXrFFKJU701P6neL6odKYpxUo97XpYgZl+Gs=;
        fh=q7K02NzOPtmrkfTQgkv6JNpmk1vwmGmz+y1C96ElDmQ=;
        b=VsjJdIFc1vgdv5SUNm8ul3MXlWInNsyfZvN6zMKGcCRUdmixExP3AyBJhTG3/aI6RG
         pXaCVi7dNDmu3TbKlTHBGY2DlsVD+InbPiUnfrrmC2QE4SKYPHvbte+yq5eFNOyKFEPE
         Yu+uxABuUHYoewjiVbg7jA63DTBuFExZ25XMgPi3JK4LBFRw5heq+MDQKxm08aGfrzk/
         VT0c5mi6CAGs4zOvzAG9NKEa8sQDSbXYZ8j1CHnesLemjW2XIhcUkpXubiE5xeY3KESR
         nuUPFtv7h5ZZi5P6a8uE+0P//b+BO0JjCWxQ2HGBcXSQG7zHAGbX//QBXHVoNIEeGUMy
         tSFA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793319097; x=1793923897; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eMFC2eyPXrFFKJU701P6neL6odKYpxUo97XpYgZl+Gs=;
        b=wtZM9a0nTkvLM5++3++rmE0/3NsN3IbPE3IzExtRVDun4uJJlAPOWCaLVWdvYjlP4k
         abWM6JM9EawwDulYJOQi3umAnafDbkYM3rmFXc0XoYrGK8iIcTk4po0PLE+Mguw2nFxr
         SWStjDABLW0LCjl90sPE83MD46fjvXw5pDNeVbRfhREw/a+Que/LjHzWvIKD4hDiiF35
         GQDuBOjAnIoCR6IZVLrHYBjVT/S9YeYVSRjRU4wITzQIsfKtIW7Pzo6ed3VmaW5taHf+
         V7FAWxt3cLXS3Pjms4xQuzYskYZIOig/DMN3KRzCRlErgrhTO8As9XUsc0ph/uPnsK25
         Dyqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793319097; x=1793923897;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eMFC2eyPXrFFKJU701P6neL6odKYpxUo97XpYgZl+Gs=;
        b=lWhmauuATbUH1q6t9+bAG66sPvG7CrZo25PjI0o74DxoSbOIfYYgTncKuqkgcLm2zD
         g6PJmgwzRUoUAk/9+Pf260N7ULeWuV8VCz1VWnAhXCSZJbGloxK6Abhjrwxc2CxrZ1Ng
         v/4TO7/s+d/QMb/OWY8RLt1XNHYQFgzSXRNS89TJkPa8dyAoV7KMTg8G9v+bS5pB2h/1
         akUcDxJWxnHas2b7CVZnVtf52/oiPBd9uMMRT+OyYibOb9oKOIRr/VQVQXDdQ3LVYadb
         BKThr30UWyCli9TpFMdsEVqLlpHULHSdn9WUIRqG8N6qQPIsGysLXzbSIrYFzDCRfoKS
         tY2A==
X-Forwarded-Encrypted: i=1; AKwUvBzzva8+gr74qXVaULLxHM7TZ8FuOkwwiSUCgIxobXK3wRqnQQ0LX+8NbHdxPtCYfQDkufE0mSVNnw==@kvack.org
X-Gm-Message-State: AFq9FYIEZ/IqpB8knXToMylLEZFkaOmZ8PWzNEM536i9/eZhogHqqMg0
	C/dFy5uS5Zkh50kYD/k1eF06WFZgEdzvG78npv6I/2F+3le9mUJXV8kgQ2zBBwYODf5Zf1fnrr/
	ZjJDQK9yvoblpS1Ka1xeKgc6bAmJNCEM=
X-Gm-Gg: AYBFou1JHeki8LJllKjbXp/9JgmzpTFhfsCtwtI1YjPFFcKCnZsrKJjMo5rPQoZfpMy
	Rlxji4m79J04DGYBpH3t5hEQa81LAHwDnthLYfRBetbOOrzuGXaCbHHuEpq0Mrbbsd+nxIpRVzM
	tPz5+YdqrzIefrkKprvPG5oVFswchnf6OeEfLKZNHckkqRhW1s3M/55ndftyURZZztwj5W/1Thq
	yQkXlCh8abKKFeWN7XdLkZD4s3ElQU85WtgwcQ6fADyGBkOxwBN6Mf5tUSw3l3RlKdvhBY6MYYP
	jZ24ej5Rm4wgEJEeU2omimzTIbPZ0C+KmPI2q81zt4qgPW6ISeXPznd9jW8nWEYukUcCo9tsDzI
	zD3StN896PebYGjCSEQbKv+2TfHmm6IDq+RU9
X-Received: by 2002:a05:6512:2250:b0:5bf:a467:32a6 with SMTP id
 2adb3069b0e04-5bfd957cd4cmr126035e87.39.1793319097124; Thu, 29 Oct 2026
 17:11:37 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-7-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188658@kernel.org>
In-Reply-To: <sashiko-outbox-188658@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 29 Oct 2026 17:11:24 -0700
X-Gm-Features: AclHuK-yXK_SCfxPeXOlV3-w-vp4HmLVTPHL5E8x5sdAfQnRtJ3WTsp8ODMhep4
Message-ID: <CACpmpodSK7txDECSiwqbZjuqs74YgL9TSAbfDNkg0cLrOwT6=w@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] mm: zswap: Store large folios in batches.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1461840004
X-Stat-Signature: beu71tu1ofypne3538yakkiupj5u8jre
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793319098-62068
X-HE-Meta: U2FsdGVkX1+qBYAoQxNqdgOAXASoNAWcfPg3lGLyTQGjiM38dp8Vdmi7RJmuVv1/rvJEy0Z50G4XD1YlJCxMvbPJVWJMe7zaAeKDxnjP6g4I7VsMJp+QKT0eHjG5G3OUM3pQQUTDzGqhXo5+rTEJYIxJWXMGXSIOsPQwWNzs1JPUUht19wf0d4bImbsxcXaSLyYm0m8bZ4u2uVaO+SRmTRGcPsQV3/P8o5oMYhT4yHI1FrxGHPpGYGsbbWtaNe4ahVeJ2Ftl67Xlvd/kdiUDLXBckaacJW8EiB42ndEijqFRTfvqIJQ3KGUTWJHnnjaVzn38Q+beAfYevtUPifhmRuLHoKnQae5PhomVyYj92UNRxxNQiHxcARjW9SNodBI4r2QCGnlO0pG3oTi8dpan+VfTiayXswuO1/SUs1I5xuIFwqGqU99YFKjc7SEefPo2vp89S7MigilDDE8vJS7CcRpwVD04T/ghXxmres78AAihA5jeS1C06CbeJ2A40hn2ZoWUkW96WpumNJu/h7GOvf10UCci5U+pmm+UR2BNC9jcCX+LqGfITBTbnB8GVSLZCxBr2lvkaLzulQQauXUktJCKpLbjDOQp85Xo70EOD0fmp1WxQBsMI29kRI9PDsFXDmctCU5NFmqcoc2Cl+MghsItjYv2pvgjuvzD37FPkEfZT+0MZfs4OhWmfZ9xzBkJxNKG+zLuZcQ63TDlrYm8NmLYXHNecW8Pf3L94/d65R38v3YrLt8wMD8srvKiJix1OWR6b9tURU4e6t17zU7MA7YaJ5vmcmOo6RjraRq2mTunDQd9uJy+rKNQ1Id3+uoLshLeB1GPdO+oQj0DkY1ESMOajE5y57uCswq0LcrrzHPdzhCNXyW3xxnJi6bGEt91uGxavodrshCb0uDNyGnDrIuopIBjgN1lax6dhM93p0aYXwnuw//RveELmbJLxRrzLoHJfC/mMnNF/4/I6Vt
 GG5/Ous5
 Ta1QH9gSv8ukeVFPlGlr9lNvJ5XlR1MhQIYqRebiS5ZSvQreTi6SGIQoeUG8Q2qusYY6/w3XSHUU7jltymeYt4Ifdy8Fv4A5v2mF0tbUtR5jbobrbzAhxCxEAbXs4PyC9Yx9Uzojg/bSqv6gozTNZZ9O4gLrVpyNOxJOUdFoVQ0QudoZLTcLztvmgSgzJGImjbxVEC2PmS9HgNRW9mYD/FBcBaJv2U6HTydkjlKmRWPrDrU3fbPXPOvJN4IAjjokC2TrvwZ+n3JArru1fBtjGJqsF7Ir2LEs82fK3EJezFMWxroQ+T77w/zyxFlhMQlwYX0k5DMobh1rfY/NLpHoDTdTFv11lHiANOPkH4l5Kvn468Eft1ObKmtwEGJIZ7GCPfiCiRzCmpO6DfM1hFNNYwIpP5J/Q7CyvdZq1unh/GsHrCTg6LXNIvBy7cEDdV0jCRaRF4eLhB1HIgk+kDA/hPVc2dw/XQsAxK6SeNiZIcxj7rqmOpvFSILCWW5vwFGaprVOV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 8:06=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [High] mm: zswap: fix error return on buffer alloc failure in zswap_cpu=
_comp_prepare()
> - [Medium] mm: zswap: unsynchronized write to pool->compr_batch_size on C=
PU hotplug
> --
>
> commit 13a7e2ffeb93e24e6a8f400496ff51f01ce0c408
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> mm: zswap: Store large folios in batches.
>
> This commit introduces batching when storing large folios in zswap, alloc=
ating
> multiple per-CPU compression destination buffers when supported by the
> compressor and batch-allocating zswap entries from the slab cache. It als=
o
> caches the memcg writeback setting and folio NUMA node ID in a store cont=
ext
> and reorganizes struct zswap_pool for cacheline locality.
>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 19b7d60bc7d2a..c8890e8a9b836 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
>
> [ ... ]
>
> > @@ -866,10 +922,28 @@ static int zswap_cpu_comp_prepare(unsigned int cp=
u, struct hlist_node *node)
> >               goto fail;
> >       }
> >
> > +     /*
> > +      * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers if the
> > +      * compressor supports batching.
> > +      */
> > +     pool->compr_batch_size =3D min(ZSWAP_MAX_BATCH_SIZE,
> > +                                  crypto_acomp_batch_size(acomp_ctx->a=
comp));
>
> [Severity: Medium]
> Can updating pool->compr_batch_size inside the per-CPU hotplug callback r=
ace
> with concurrent readers or cause a buffer count mismatch across CPUs?
>
> In zswap_pool_create(), cpuhp_state_add_instance() runs zswap_cpu_comp_pr=
epare()
> only on currently online CPUs. If an offline CPU is brought online later =
while
> the pool is active, zswap_cpu_comp_prepare() writes to pool->compr_batch_=
size
> without synchronization while zswap_store() concurrently reads it:
>
>     store_batch_size =3D (pool->compr_batch_size > 1) ?
>                         pool->compr_batch_size : ZSWAP_MAX_BATCH_SIZE;
>
> Additionally, because each CPU independently calls crypto_alloc_acomp_nod=
e()
> when brought online, if a higher-priority acomp implementation for
> pool->tfm_name with a different batch_size is registered before a CPU com=
es
> online, pool->compr_batch_size will be overwritten with the new value. Wh=
en
> zswap_pool_destroy() later frees each CPU's buffers using the single
> pool->compr_batch_size:
>
>     for_each_possible_cpu(cpu)
>         acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu),
>                        pool->compr_batch_size);
>
> acomp_ctx_free() would iterate past the end of acomp_ctx->comp.buffers (o=
r
> leak buffers) for CPUs that were initialized with the earlier batch size.

Thanks Sashiko, for the excellent observations. Based on this, I am
moving the "u8 compr_batch_size" to struct zswap_comp_ctx, which is
per-CPU. In addition to addressing the issues you've highlighted, this
will also simplify the store batching architecture quite a bit.

>
> > +
> >       ret =3D zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->ac=
omp);
> >       if (ret)
> >               goto req_fail;
> >
> > +     acomp_ctx->comp.buffers =3D kcalloc_node(pool->compr_batch_size, =
sizeof(u8 *),
> > +                                            GFP_KERNEL, nid);
> > +     if (!acomp_ctx->comp.buffers)
> > +             goto req_fail;
> > +
> > +     for (i =3D 0; i < pool->compr_batch_size; ++i) {
> > +             acomp_ctx->comp.buffers[i] =3D kmalloc_node(PAGE_SIZE, GF=
P_KERNEL, nid);
> > +             if (!acomp_ctx->comp.buffers[i])
> > +                     goto req_fail;
> > +     }
> > +
> >       /* Skip the per-CPU request when decompression can use the stack.=
 */
> >       if (acomp_is_async(acomp_ctx->acomp)) {
> >               ret =3D zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ct=
x->acomp);
> > @@ -882,12 +956,13 @@ static int zswap_cpu_comp_prepare(unsigned int cp=
u, struct hlist_node *node)
> >  req_fail:
> >       pr_err("could not alloc crypto acomp_request %s\n", pool->tfm_nam=
e);
> >  fail:
> > -     acomp_ctx_free(acomp_ctx);
> > +     acomp_ctx_free(acomp_ctx, pool->compr_batch_size);
> >       return ret;
> >  }
>
> [Severity: High]
> Does zswap_cpu_comp_prepare() return 0 (success) if kcalloc_node() or
> kmalloc_node() fails when allocating acomp_ctx->comp.buffers?

Thanks, I have fixed this.

[ .. ]

> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.17=
923-1-kanchanapsridhar2026@gmail.com?part=3D6

