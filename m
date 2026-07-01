Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F83C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 11:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94F836B00A9; Wed,  1 Jul 2026 07:37:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9004A6B00AB; Wed,  1 Jul 2026 07:37:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C9CA6B00AC; Wed,  1 Jul 2026 07:37:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 492D66B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:37:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF374A032B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:37:45 +0000 (UTC)
X-FDA: 84940008090.23.F19534F
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id C3AFE20007
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:37:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dRhe4kJ2;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782905863;
	b=nQDWxA0eQ+E/Us8pXeIqdX9jIGOqdSA/DwiQ9IPKBO6pQTBiptaSr85L+z4wgmjVzkZNrD
	z2rSGY+Cj7nq97YEyjkkWNUirD8e/ZDF8PvbOGCro+TIoUuaL76wLCYeW9uedRibDkk1K+
	Zp55zgmVGPh9O9byptYscKfqBxcZ2v4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782905863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xyNXo7H8eX4YkkvGbSznBTYxJI+0zg6IyIYoofrzRLo=;
	b=0NUndwz3Pe/ZGshn+SJ2bP2InRxD1K1r/pj4KIYLuVD8nxgbYVlDARZKwvPJnW4A5E3dJ8
	WVUsECXIMRIw8fXfIs0i5wqqpi3R+ycCboJUA/G6DfzmIMa0h2J33Ni4QdDcVgz3pOimdC
	5V0dKFXxHqX9/4BV1mOpjKPg0+P2u38=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dRhe4kJ2;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c15a5b265so222801cf.0
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 04:37:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782905863; cv=none;
        d=google.com; s=arc-20260327;
        b=f/KwXzbDQ+5yzLnOEcXGOWf0FmlZtRya4Gbz1VfF+TdyQiLKUuDyY2RExMa4ny0j3n
         iNDLBmhQdR744pfTurEz3fm8Be7n3+hJEdplwkyBxzyIadCkxu+vJGR+CT907ydOZlI/
         6fN3m7TexebzqiRRUfR2oyyV+Na35goZzufOjT50J/w7okraL+HttV+ROK8pff+UF+YG
         7G/IX66DuGKPKqq/JcuDut8QU07hVfBpPnd8IlEgZg1ogtbkJkBi85KmMd7vr6/k0CrJ
         jAteNm/0NoN9Emp2rJNNm7YSnOL1havfyS/y3OLxhj/YEGvG3HdyUMhDXI7ViLpyPxyf
         DtQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xyNXo7H8eX4YkkvGbSznBTYxJI+0zg6IyIYoofrzRLo=;
        fh=FnIsVthMZ+2zJl0vqKePvOcXuOet2ZMSD8AsJPamInI=;
        b=BKFDnetXqHbtkbOlLZFY7nNp/dQdHox6S1Wr+P9GIx1FdIkcgHHfanFCSoLS2E9Yl+
         77mhTXzga1iXrjZifkHer+E0eNcjpU2MmEDcdLvFAL3ftjDQ4SIoDbwVDAAHF3ud7kYw
         JCRFHXMzU6ZrJN0M8H+2cL1GGwJhUIiLUhh40b4BZHb8HjOYy+PFXAr+b9NXEelPmodK
         yrhpEhMgnwdwOAnSNvuWkq85L2fVsXDo87oAHaNtHDMzDct7ovNZnw88Vl1qnvI+h+V/
         oGl0s3D6c1RgmHqjeRn1vw1dG8w/A2BtQTlaCgknCRs55050FX0wpV8aMHcjVOrIgXRE
         jUNQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782905863; x=1783510663; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xyNXo7H8eX4YkkvGbSznBTYxJI+0zg6IyIYoofrzRLo=;
        b=dRhe4kJ2Wsi7ZnIMFwUvPXmmoDG16vklrFtsqC7kQtty7AjhDggquv56fkllpIimDw
         0aUSOjmjpJ9iCwUr4VE6/pG4TkP6B3YfMVIZXJbIovo0+TTsRXfzUQPcFFe/jjqcbKsM
         a+HJ4OCsa6EeG55dq30STVQ1fr1EMkQ0+BjvObeP6FvIYw5L1Nk8/WUE70AdrMvMIpJT
         gTdDw8v/BCS8SIwd/0z2Oh5HnjvVHLYfmic6zjykkyDxTH4N+vcPps6CJ8JEKyKwN3SV
         HqtxaIz0ukPLu7dBEMbbIdgi+qP2B8kbPN5cViZMhMx3Kp5Af33+faVKdqfvUdifM3SK
         Zjug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782905863; x=1783510663;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xyNXo7H8eX4YkkvGbSznBTYxJI+0zg6IyIYoofrzRLo=;
        b=ZmMvbF5YEn1GgTf9Sf+93Gqoo14Rwg9MDL0qMJGQe6QQGEkBHjFnYwkPZDUw3rNco0
         1+ZDDCMN+sGKg9QNPtzGJkB3IrrNC0JMdGjyWOQm5zmtoTNNjdf/sQK8USIXpGhkOjjY
         8rwnHSE8l8PuExNvHnGO9mqsfyB+WGx6ksW9HZAovFUsGdkanyENU/ju581LojGSMYA4
         eMdoJv0TM5lYuu74LO+LfBqDMfwxA9gb1m87lR6bAOPHm5HH+aJ3q3ktuA4EFM6hluVy
         4uMnYgSLiG9IuKnn+L9ChP/CY4ngDtVlucWak7aFSYPr57vGetlAUeL6X8S1l62wcCrZ
         FyCQ==
X-Forwarded-Encrypted: i=1; AFNElJ/qL/sH4nj2iD1fnH0fOvqhBTC/xppg8Ox0uVEbcbBv/Uog7Lq9GaVH6McwOF1cDq/7gnB2R4VzbQ==@kvack.org
X-Gm-Message-State: AOJu0YxBfjDJ4zl1dZ++Lj7ExcGF5XXC7L5r6ZVAhFRPd/lX/q7HDHOi
	4F3CdaTtfaV2aFDkGM+YYEbPP0yGwB3sBU8Xaj6NYMiUYy4kYEk27HH3VB0pfWVUfjhZ3Lnhsmd
	Vxl9r89yrpPIuFInpn6UeffUaPrJegFLt+YyFea5p
X-Gm-Gg: AfdE7cmiD/WSsalufPZOGRAwmsUwiVLqhKMzWoWDkOIxknx2pdkHs2mu+55KaV8YLvp
	zL4TEBevP7A4AasFmfCITo08zdTHVpUKLUauMpmvJSeRygLnH80E1y99tNKXA6p+tIBfi1FrzXD
	zhbT/COqTT9pGN8qzwAljI/SMKPXw2pEnGgToI9JdnlO6G7Qbbqwz+lCaslMgkwJJsguRbMMEnx
	0FLndemKXYe+Tr+C438sn0Lxc13yGe+0aJJEtD+Qry0H9icTNeuIa+BY4cZo7drV9EXRtg=
X-Received: by 2002:ac8:5850:0:b0:51b:fe30:b8c5 with SMTP id
 d75a77b69052e-51c204fb36fmr10762871cf.6.1782905862160; Wed, 01 Jul 2026
 04:37:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org> <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org> <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
 <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com>
 <39a79576-dcae-4b66-9478-c81dfe676699@kernel.org> <CAJuCfpGRC7NPxcODUsb3YS5nV=qG+-SbSYj1Fwm-QPqgKSVWAA@mail.gmail.com>
 <c5c4208d-a6f0-413e-bad9-49be12f12d55@kernel.org> <5ebd3c4a-5c06-43b4-ab0a-7a8f0396c84c@kernel.org>
 <akPSjsbjl-UAcdI8@linux.dev> <CAJuCfpE4BwDpt08iXtdh_nqRR5TGzGTdHzGZWYayC7t6V1O49w@mail.gmail.com>
 <c4eab53b-c54d-4f1e-a4ff-8d86b8d32503@kernel.org> <CAJuCfpE6WSWPyZMheF4b=2mrwx7bPP3JUe9Pwp6QAswSMF4GyQ@mail.gmail.com>
 <9a139365-28e6-4f1e-b35b-7f6091e9aa14@kernel.org> <92bf5e21-690e-4a77-929e-5217e0d7cb0c@kernel.org>
 <68e7f6cd-cf11-46b2-84a2-d512bb22dae4@kernel.org>
In-Reply-To: <68e7f6cd-cf11-46b2-84a2-d512bb22dae4@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 1 Jul 2026 04:37:30 -0700
X-Gm-Features: AVVi8Cf5UDtkoAqOcj2xTsaoTi_1LNUJTo4KVIzlyqHVW__EJJwtisRC8ShRSwQ
Message-ID: <CAJuCfpEBd_V_U0GQiqWtYXmZxxQ1M48b_LhVn6W+EU5862HD5Q@mail.gmail.com>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: Harry Yoo <harry@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>, 
	Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C3AFE20007
X-Rspam-User: 
X-Stat-Signature: wqhz4fspn111zwwdkk3o79w8ef8h6phd
X-HE-Tag: 1782905863-46492
X-HE-Meta: U2FsdGVkX1/9tmMKZFO6X5scroOArex+NKcsCGVU/tUFXtKvf4QxbrtpfGZnAnFdil4tOQdhQvzSGly7+gFYtmTs4oS3Vq5HG7N6QXlSyq4HUjoCUsShZxiaU9kGR7u0AOPELTaFWZ7Blea2yrJ7kc1tQ87dpQt07s1STLOqBZ1MB30Bequ2Ufmb3GaTYNzFmYWSWyDtgiKNPLQdlX8UyjXrYutez5LcJVv1XLpx7WStnS6lDmAadjsSGaNtNyIgE/FRdC1BQ8pUASYGThB3oLTxfuJvMVpygOZ0QeFs2RnGXmHZ7+rRhS26neIlKe6Pa0TgUSb/KLSTOkefPqbzSZeqaTsVlY7tZyJdzGhmkrgnwdmUw4rzjYoa5UdJGYrky0ZsWsZ+ixk6ad9jJZA6NxnwyUmNJRlzZwICxpauNV81MajocrzELo27Jh9yPxym8nAZGCoSX1UOP/i2xlV6nA+Y7tYyUcTc3XDB2at00j6y449+lO0d8edLA6g1qmT27iiUsemaQjaCehHAEltrMvRDW+Pw5GjXewxA4QHi5GQD7ijAlRc1Dr33n4PdO/zQGHcUwPVb2tBWfd9GGJd1DrXkUexmFKR/jbStu3Sqaxfr6gRFoxTvGKnOpRZQx/mKamToNQqWnWehEFm6a/PFN0tgfHmzrosj+m7oPeKGWfHPkk4E76pZTxH7LziIXhPDg1b7qhAr/GbXJYIOr/AVbw+sRq+AZ7bHCjMzOoBBtH+cWQtmWIJkiv5iXRo8BHg4W2+yZFnbiaAWFaZQSy5xh5yGcLGqDfg4/sy7vz4nop8No1xd3EVFAkmj7eZjWUC9QTkICWvQllT4HQxo6fDN3Jj/wJ26vdOUfven3d3eDjBuhbc0nyWZ6UaInwx7dbbsxpLqWgorkMv3AKLgX76HlnI3txvOARc+xBBX1g0KUa1lrFY0NaCQ3jATrY3z64wLrr5KWxI2dqn5pfl/OLy
 dLf2dOnW
 4eS2AnN0gEHr5ptgt9gEr+3tVhNPbIXpNrcIIvZBTxob84ZH0cApcFsBuFjaDTSTr5yF9BeMJHEguJJ5KNMlgodz1ljStshSPs0nraUTgoS8P7O6oe40qU3Tgtpro26vV4B6S+/vgmlT3CNqmtNzIAB6WR8rNETFYoRgf4WNYiA8486xQTNhN95B73I8e3Cl6UiKXgkvnxXuPL7oT0mjY8gImRKliAuHiep1FZcgFdItEdyJKR4IQfHLtKQSos/dkFwMJx2CPVYvwJBpv6JmmnAPv36YwelOV8SI2nMJMFfj2rJBbviTspBdugw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 1, 2026 at 12:42=E2=80=AFAM Harry Yoo <harry@kernel.org> wrote:
>
>
>
> On 7/1/26 1:53 PM, Harry Yoo wrote:
> >
> >
> > On 7/1/26 1:30 PM, Harry Yoo wrote:
> >> We can do that in pre-7.2 kernels, by teaching kmalloc_type() and
> >> kmalloc_slab() select the new KMALLOC_TYPE based on __GFP_NO_OBJ_EXT?
> >>
> >> e.g.) Select the new KMALLOC_TYPE when KMALLOC_NOT_NORMAL_BITS is not
> >> set AND __GFP_NO_OBJ_EXT is set.
> >
> > Uh, this is bit subtle though.
> >
> > In some cases  KMALLOC_DMA =3D=3D KMALLOC_NORMAL,
> > KMALLOC_CGROUP =3D=3D KMALLOC_NORMAL,
> > or KMALLOC_RECLAIM =3D=3D KMALLOC_NORMAL.
> >
> > Just checking KMALLOC_NOT_NORMAL_BITS is misleading.
>
> Here's a prototype for slab/for-next. Backporting it requires handling
> __GFP_NO_OBJ_EXT instead of SLAB_ALLOC_NO_RECURSE, but shouldn't be
> too difficult. Now writing changelog and going through testing...
>
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 51f03f18c9a7..91a71537a2fe 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -684,6 +684,26 @@ static inline unsigned int arch_slab_minalign(void)
>  #define KMALLOC_PARTITION_CACHES_NR    0
>  #endif
>
> +/*
> + * SLUB needs a separate kmalloc type, KMALLOC_NO_RECURSE, when
> internal slab
> + * metadata of kmalloc objects can be allocated from the same kmalloc ty=
pe.
> + */
> +#if defined(CONFIG_MEM_ALLOC_PROFILING)
> +/*
> + * Memory allocation profiling can allocate internal slab metadata
> + * for any slab cache.
> + */
> +#define HAS_KMALLOC_NO_RECURSE
> +#elif defined(CONFIG_SLUB_TINY) && defined(CONFIG_MEMCG)
> +/*
> + * Accounted slab objects are usually allocated from KMALLOC_CGROUP.
> + * On SLUB_TINY, those can be allocated from KMALLOC_NORMAL because
> + * KMALLOC_RECLAIM aliases with KMALLOC_CGROUP and has higher priority t=
han
> + * KMALLOC_CGROUP.
> + */
> +#define HAS_KMALLOC_NO_RECURSE
> +#endif
> +
>  /*
>   * Whenever changing this, take care of that kmalloc_type() and
>   * create_kmalloc_caches() still work as intended.
> @@ -702,6 +722,9 @@ enum kmalloc_cache_type {
>  #endif
>         KMALLOC_PARTITION_START =3D KMALLOC_NORMAL,
>         KMALLOC_PARTITION_END =3D KMALLOC_PARTITION_START +
> KMALLOC_PARTITION_CACHES_NR,
> +#ifdef HAS_KMALLOC_NO_RECURSE
> +       KMALLOC_NO_RECURSE,
> +#endif
>  #ifdef CONFIG_SLUB_TINY
>         KMALLOC_RECLAIM =3D KMALLOC_NORMAL,
>  #else
> @@ -716,6 +739,16 @@ enum kmalloc_cache_type {
>         NR_KMALLOC_TYPES
>  };
>
> +#if !defined(HAS_KMALLOC_NO_RECURSE) && defined(CONFIG_SLAB_OBJ_EXT)
> +/*
> + * kmalloc_flags() with SLAB_ALLOC_NO_RECURSE should not use KMALLOC_NOR=
MAL
> + * if any of these alias with KMALLOC_NORMAL.
> + */
> +static_assert(KMALLOC_DMA !=3D KMALLOC_NORMAL);
> +static_assert(KMALLOC_CGROUP !=3D KMALLOC_NORMAL);
> +static_assert(KMALLOC_RECLAIM !=3D KMALLOC_NORMAL);
> +#endif
> +
>  typedef struct kmem_cache * kmem_buckets[KMALLOC_SHIFT_HIGH + 1];
>
>  extern kmem_buckets kmalloc_caches[NR_KMALLOC_TYPES];
> diff --git a/mm/slab.h b/mm/slab.h
> index 281a65233795..ba0560111488 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -386,12 +386,21 @@ static inline unsigned int
> size_index_elem(unsigned int bytes)
>   * KMALLOC_MAX_CACHE_SIZE and the caller must check that.
>   */
>  static inline struct kmem_cache *
> -kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, kmalloc_token_t
> token)
> +kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, kmalloc_token_t
> token,
> +            unsigned int alloc_flags)
>  {
>         unsigned int index;
> +       enum kmalloc_cache_type type =3D kmalloc_type(flags, token);
> +
> +#ifdef HAS_KMALLOC_NO_RECURSE
> +       if (type >=3D KMALLOC_PARTITION_START &&
> +                       type <=3D KMALLOC_PARTITION_END &&
> +                       (alloc_flags & SLAB_ALLOC_NO_RECURSE))
> +               type =3D KMALLOC_NO_RECURSE;
> +#endif

Overall your approach LGTM, just here why not simply:

+#ifdef HAS_KMALLOC_NO_RECURSE
+       if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
+               type =3D KMALLOC_NO_RECURSE;
+#endif

?

>
>         if (!b)
> -               b =3D &kmalloc_caches[kmalloc_type(flags, token)];
> +               b =3D &kmalloc_caches[type];
>         if (size <=3D 192)
>                 index =3D kmalloc_size_index[size_index_elem(size)];
>         else
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index b6426d7ceec9..8541f4a9cfda 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -783,11 +783,15 @@ u8 kmalloc_size_index[24] __ro_after_init =3D {
>  size_t kmalloc_size_roundup(size_t size)
>  {
>         if (size && size <=3D KMALLOC_MAX_CACHE_SIZE) {
> +               struct kmem_cache *s;
> +
>                 /*
>                  * The flags don't matter since size_index is common to a=
ll.
>                  * Neither does the caller for just getting ->object_size=
.
>                  */
> -               return kmalloc_slab(size, NULL, GFP_KERNEL,
> __kmalloc_token(0))->object_size;
> +               s =3D kmalloc_slab(size, NULL, GFP_KERNEL, __kmalloc_toke=
n(0),
> +                                SLAB_ALLOC_DEFAULT);
> +               return s->object_size;
>         }
>
>         /* Above the smaller buckets, size is a multiple of page size. */
> @@ -843,6 +847,12 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
>  #define KMALLOC_PARTITION_NAME(N, sz)
>  #endif
>
> +#ifdef HAS_KMALLOC_NO_RECURSE
> +#define KMALLOC_NO_RECURSE_NAME(sz) .name[KMALLOC_NO_RECURSE] =3D
> "kmalloc-no-recurse-" #sz,
> +#else
> +#define KMALLOC_NO_RECURSE_NAME(sz)
> +#endif
> +
>  #define INIT_KMALLOC_INFO(__size, __short_size)                        \
>  {                                                              \
>         .name[KMALLOC_NORMAL]  =3D "kmalloc-" #__short_size,      \
> @@ -850,6 +860,7 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
>         KMALLOC_CGROUP_NAME(__short_size)                       \
>         KMALLOC_DMA_NAME(__short_size)                          \
>         KMALLOC_PARTITION_NAME(KMALLOC_PARTITION_CACHES_NR, __short_size)=
       \
> +       KMALLOC_NO_RECURSE_NAME(__short_size)                   \
>         .size =3D __size,                                         \
>  }
>
> @@ -966,6 +977,11 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type
> type)
>                 flags |=3D SLAB_NO_MERGE;
>  #endif
>
> +#ifdef HAS_KMALLOC_NO_RECURSE
> +       if (type =3D=3D KMALLOC_NO_RECURSE)
> +               flags |=3D SLAB_NO_OBJ_EXT;
> +#endif
> +
>         /*
>          * If CONFIG_MEMCG is enabled, disable cache merging for
>          * KMALLOC_NORMAL caches.
> diff --git a/mm/slub.c b/mm/slub.c
> index 9f754cf1c187..a5745759f0af 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2123,42 +2123,6 @@ static inline void init_slab_obj_exts(struct slab
> *slab)
>         slab->obj_exts =3D 0;
>  }
>
> -/*
> - * Calculate the allocation size for slabobj_ext array.
> - *
> - * When memory allocation profiling is enabled, the obj_exts array
> - * could be allocated from the same slab cache it's being allocated for.
> - * This would prevent the slab from ever being freed because it would
> - * always contain at least one allocated object (its own obj_exts array)=
.
> - *
> - * To avoid this, increase the allocation size when we detect the array
> - * may come from the same cache, forcing it to use a different cache.
> - */
> -static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
> -                                        struct slab *slab, gfp_t gfp)
> -{
> -       size_t sz =3D sizeof(struct slabobj_ext) * slab->objects;
> -       struct kmem_cache *obj_exts_cache;
> -
> -       if (sz > KMALLOC_MAX_CACHE_SIZE)
> -               return sz;
> -
> -       if (!is_kmalloc_normal(s))
> -               return sz;
> -
> -       obj_exts_cache =3D kmalloc_slab(sz, NULL, gfp, __kmalloc_token(0)=
);
> -       /*
> -        * We can't simply compare s with obj_exts_cache, because partiti=
oned
> kmalloc
> -        * caches have multiple caches per size, selected by caller addre=
ss or
> type.
> -        * Since caller address or type may differ between kmalloc_slab()=
 and
> actual
> -        * allocation, bump size when sizes are equal.
> -        */
> -       if (s->object_size =3D=3D obj_exts_cache->object_size)
> -               return obj_exts_cache->object_size + 1;
> -
> -       return sz;
> -}
> -
>  int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>                         gfp_t gfp, unsigned int alloc_flags)
>  {
> @@ -2168,15 +2132,13 @@ int alloc_slab_obj_exts(struct slab *slab,
> struct kmem_cache *s,
>         unsigned long new_exts;
>         unsigned long old_exts;
>         struct slabobj_ext *vec;
> -       size_t sz;
> +       size_t sz =3D sizeof(struct slabobj_ext) * slab->objects;
>
>         gfp &=3D ~OBJCGS_CLEAR_MASK;
>         /* Prevent recursive extension vector allocation */
>         alloc_flags |=3D SLAB_ALLOC_NO_RECURSE;
>         alloc_flags &=3D ~SLAB_ALLOC_NEW_SLAB;
>
> -       sz =3D obj_exts_alloc_size(s, slab, gfp);
> -
>         /* This will use kmalloc_nolock() if alloc_flags say so */
>         vec =3D kmalloc_flags(sz, gfp | __GFP_ZERO, alloc_flags, slab_nid=
(slab));
>
> @@ -5330,7 +5292,7 @@ void *__do_kmalloc_node(kmem_buckets *b, gfp_t
> flags, int node,
>         if (unlikely(!size))
>                 return ZERO_SIZE_PTR;
>
> -       s =3D kmalloc_slab(size, b, flags, token);
> +       s =3D kmalloc_slab(size, b, flags, token, ac->alloc_flags);
>
>         ret =3D slab_alloc_node(s, flags, node, ac);
>         ret =3D kasan_kmalloc(s, ret, size, flags);
> @@ -5395,7 +5357,9 @@ static void
> *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
>  retry:
>         if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
>                 return NULL;
> -       s =3D kmalloc_slab(size, NULL, gfp_flags, PASS_TOKEN_PARAM(token)=
);
> +
> +       s =3D kmalloc_slab(size, NULL, gfp_flags, PASS_TOKEN_PARAM(token)=
,
> +                        ac->alloc_flags);
>
>         if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
>                 /*
>
>
> --
> Cheers,
> Harry / Hyeonggon

