Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A094CCF9EA
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 03:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EFF18E002F; Tue, 28 Oct 2025 23:20:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0958E0015; Tue, 28 Oct 2025 23:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78F5C8E002F; Tue, 28 Oct 2025 23:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 644548E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 23:20:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E3B6160646
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:20:13 +0000 (UTC)
X-FDA: 84049698306.02.309E34F
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4F32C10000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:20:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bUr5kCWZ;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761708011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7sWCgjKKhp7TKcKNU9g7Njs3zaKm3E/eeC+3FUQGpNQ=;
	b=CskhJg0vQDxtfjfvTekWHyByyH682exe8OTrirxQiMHdLz1poTS5rAVA64DoPV0Jhus/5c
	0xyKtfq0rnAGHfaST19Cj56f9NYqOcs8FNtfnMqKDp+T5Ov6p1gPYkateCRjxiiwiJoDnw
	7iofhiu/BJZapdb9hgrvrl64MgdXVug=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bUr5kCWZ;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761708011; a=rsa-sha256;
	cv=none;
	b=xPv+cSBHgIxaY7WybrfAzB4WCOOARlZpR2x0WdoA73ynDkD6/nzYpUaAMKW6s/or7CuYpN
	6fsfYqxyO0vdkiXH7nYyaxKYhZW0NjPfuXTT1Dn9p2CdNwFAWwzz6G3s58r5XqTjGbE//7
	ZBq9leTyY2qn5OWK7WlFYbs3Y31hLKI=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ed0c8e4dbcso202941cf.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 20:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761708010; x=1762312810; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7sWCgjKKhp7TKcKNU9g7Njs3zaKm3E/eeC+3FUQGpNQ=;
        b=bUr5kCWZ8sQqzqHVo0WYucv3XP/nsq/2Urxwh6WvkOFh3xURFteV4YauzcbNlDyC/W
         AWKRg/HgDI9TUKPZ4RFStllslInklUIGb/bDqVkP7NJHQH9rkwnTYk6SYZ2RdSAoUTlx
         Ws4P4vv4Yo+ksLqHfVTQQ8QVPHwYcNMtd7H2BeLGtDPB4khH1vuGpzcwB/4bbSaJqorq
         4177B0Km3+gnMhJ+fkfW9/BpPVmtcpTqKXi/mw8YBvZz33E6uHUYPjAzaFc/V93nycrk
         1h5PIxw9ukfiWlB506xkvMAPBGIBs32FRdilBHVixW0IdOCx9o6OZ8udKooW2PDC4Xt7
         LzVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761708010; x=1762312810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7sWCgjKKhp7TKcKNU9g7Njs3zaKm3E/eeC+3FUQGpNQ=;
        b=deylisTZ5Y/DhwziSZbGxUfjpifnvqoPndK9Q0R4eIuuUXZR3kp+rZY0Krvu9/vTdB
         o0u8op1uRwbg+EnhanzaL9e7KLFo3HPBlZfgdE+vBEDOeGNcb9MHRJ7N5WsmaFv7XKJx
         Ydt4JmMDGPWpPqKkRGytS0m5yqQ3yucE1Yo8J+fBsQyLGfac5wFrt4aK9w7QZ7FRu01q
         Klnu/byE4YDlMVHS1hkZI90bVyczN7fHWG5V8qHK10dD4ziEc1fz9nbTQmvhOTkqZrA8
         e5IvwW6SE82HPgq5yTXF1lLARGYftfWW6iPRY7ZWJHQK7IhiqByTqtl7LUvuNhID1v+s
         zlQg==
X-Forwarded-Encrypted: i=1; AJvYcCUZdUAMTHd2HlROJXcDbYSEYGysoYY4IgsxtxiMm74OVA7l753HQNLPa1YPc0EH0N+0QlSW/0+qpg==@kvack.org
X-Gm-Message-State: AOJu0YwzkAAWRzbVddl85MHQI5WgPz6ore4o0MO+j2LmmcOpBPJAqbJK
	2JoJn+bwyU3+zIoyntCt4yg/3QQCjh7Hqj+KKEg4u+t0faqxa96ZZQ4rpuc8raHu97fD4MVjyhB
	vhSh9nKXo0Y44fQ2tAPEZORWlX3SH5LaWl+JD7AKP
X-Gm-Gg: ASbGnctt2GaFAM9+Ef4LCu3BMsUosZXh+0DS8qRPOuJN5So2OHFoExl8VKM8IqwWCZY
	zH0JstdK8iVHPhEVM5h/VfmK++EBHOY5ghtOAYaEel18q++1RfMxNUHb37GELGCJVRsP4QqHu//
	iPMsu/EC4ebcO3RjAzHHpBlUWJ/npDkdcECLnxGwWTnEvk+DPrDJGWgB1QkwpB9RCxw3BAnEJMl
	P/qCZZjhnKPdf4UNmlW9TI10EzXlaYoBSdM7nJl+ebQbjmz9lI23imp+eL2nP9DR27l3w==
X-Google-Smtp-Source: AGHT+IEgHBrwGW14wfvE+tNAHLr5vJEtehAhSwoEdeqMmNNr0R+yG/j5eehRFy4Sh6qRX8n2G2p+LqQGRABiqViVmh0=
X-Received: by 2002:a05:622a:244d:b0:4b7:9b06:ca9f with SMTP id
 d75a77b69052e-4ed157de56amr3957211cf.2.1761708010022; Tue, 28 Oct 2025
 20:20:10 -0700 (PDT)
MIME-Version: 1.0
References: <20251027122847.320924-1-harry.yoo@oracle.com> <20251027122847.320924-8-harry.yoo@oracle.com>
In-Reply-To: <20251027122847.320924-8-harry.yoo@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 28 Oct 2025 20:19:59 -0700
X-Gm-Features: AWmQ_blp-ZEBcawtFO459XLUyJcG47lh4LXAakbZFQWgL79B818mKpJ-2TDZ1ko
Message-ID: <CAJuCfpHNhes_csqvm9-Z2f-C6XWuyRuXpchNtXwTSXxTpARZSg@mail.gmail.com>
Subject: Re: [RFC PATCH V3 7/7] mm/slab: place slabobj_ext metadata in unused
 space within s->size
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com, 
	cl@linux.com, dvyukov@google.com, glider@google.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, 
	rientjes@google.com, roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, 
	shakeel.butt@linux.dev, vincenzo.frascino@arm.com, yeoreum.yun@arm.com, 
	tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: x53y6sx1ur6xaz3d7ghjznt5warptjx7
X-Rspamd-Queue-Id: 4F32C10000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761708011-446601
X-HE-Meta: U2FsdGVkX19RLn3u97GUuaDfIOqKElE3j4PfpLH1nVxspNjoU/QXRYQjv4KF29IWgYAx+lpe4hbN2TkH6IUflp1cmeMU+d13svowBJHChrf9h7mx70g2CsWGLI/mq9Gxtu3q3zKZNdutFlGCVthxx43QX1qOGsyul/bCJwXFx6LnXQa4F2lNmBdotMUFWcQLPc9l31RgPSDGfELe6Z8DV/9X36aaCw9ZPoOg/WtxQ5LplAfyzgytIz4S3YeSlQrH/JRdDKhixhjVawyh5HdgncF9WApQtRgNrGbOKlK8/4yMgXU7Mx6rnYn2SBeszj1r0zvU6LPstUEoxySzFBL2nDSQSMbs5zIX+VfWHdqQwsUsbetqB4DyFd2Gh3mKIV46a4lVyKKkYPfPc0yItKY7HqLCSWrOMSOl8oYHt/IL7AeIU7iJuAdcD5gPYRhN479hfhWdXLczVm87nAttFO+prxHaA7xo8JakInRf/Ga0lbYboP099lutMegWIwj6qiuiZk3lEzFoYf1X2qsBdd6VZG98cWvbJq+W1rYID9vBtvvqsEET+lMsA8tO3ytu0rJfLKDYoMdfwLB64D50tD1pRCG6NWQNmEkSXhzh6n3xn8dGqDvbiZepauPUGc2I4zQF3j7tibgVW3r0XWyezhi9OpUCay+jReLIY6mLs19DZ9v8jH31E50/LL3vQuZCXicwKhnK0aHrkMqLRzZ3A6Y5v5EE1qwk+btZLp3WU0KViCuTMnqErabdtstWhQC/5N4PZRZI9/gDFrqyHDYxvgNZ857mir6JDJTjEpUGx9JoHWZI31MN4OGjTLFwRlyFY3bkEzZCLOxKFbRx/KgxULxFjVIH1de8q53YaQXsfT/j8GHHL/jK1D2m9Z2qqLIxQrp0i2m6dWrjXJWOXEVUsh7BxeRFt3vugQ1J9CtG4mput24ep8GdfRC/s6qMzwSQn43E+2Qz9/cvK2z+siyrnIh
 s1d9JAuP
 ThJYf9DcMkyympjhkN1euco9qQbmSyJd2leDjk/1EAV13KnI7UeJqFI97fwUKBjz9p3vfA/EG3NrsYayISSXWssYB5D6mBcP9WiwcZ1Dk0nM/m0o7D4SkHMIFi+dvCKREk/tFBj22+gp9kVR5iKBMLTqsaG8BgL4QXcHyxxdTgh0JqBDXeHlIgFgMOtnusZm/LnIKZlm6SVZOM1q9P7BSHrQsTylxLEeVbqcD7QhfWT4+bfJjnR++XWHQDMpbZxdjPrEkZQhdloG5F966zp8mXccs2AWu4s/3iDBe8MGkvUPiuHdwreBs7NaX6fCxzBIZPndSodRNz6m7QFO+nhQzIHlgcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 5:29=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> When a cache has high s->align value and s->object_size is not aligned
> to it, each object ends up with some unused space because of alignment.
> If this wasted space is big enough, we can use it to store the
> slabobj_ext metadata instead of wasting it.
>
> On my system, this happens with caches like kmem_cache, mm_struct, pid,
> task_struct, sighand_cache, xfs_inode, and others.
>
> To place the slabobj_ext metadata within each object, the existing
> slab_obj_ext() logic can still be used by setting:
>
>   - slab->obj_exts =3D slab_address(slab) + s->red_left_zone +
>                      (slabobj_ext offset)
>   - stride =3D s->size
>
> slab_obj_ext() doesn't need know where the metadata is stored,
> so this method works without adding extra overhead to slab_obj_ext().
>
> A good example benefiting from this optimization is xfs_inode
> (object_size: 992, align: 64). To measure memory savings, 2 millions of
> files were created on XFS.
>
> [ MEMCG=3Dy, MEM_ALLOC_PROFILING=3Dn ]
>
> Before patch (creating 2M directories on xfs):
>   Slab:            6693844 kB
>   SReclaimable:    6016332 kB
>   SUnreclaim:       677512 kB
>
> After patch (creating 2M directories on xfs):
>   Slab:            6697572 kB
>   SReclaimable:    6034744 kB
>   SUnreclaim:       662828 kB (-14.3 MiB)
>
> Enjoy the memory savings!
>
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  include/linux/slab.h |  9 ++++++
>  mm/slab_common.c     |  6 ++--
>  mm/slub.c            | 72 ++++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 82 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 561597dd2164..fd09674cc117 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -59,6 +59,9 @@ enum _slab_flag_bits {
>         _SLAB_CMPXCHG_DOUBLE,
>  #ifdef CONFIG_SLAB_OBJ_EXT
>         _SLAB_NO_OBJ_EXT,
> +#endif
> +#if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
> +       _SLAB_OBJ_EXT_IN_OBJ,
>  #endif
>         _SLAB_FLAGS_LAST_BIT
>  };
> @@ -244,6 +247,12 @@ enum _slab_flag_bits {
>  #define SLAB_NO_OBJ_EXT                __SLAB_FLAG_UNUSED
>  #endif
>
> +#if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
> +#define SLAB_OBJ_EXT_IN_OBJ    __SLAB_FLAG_BIT(_SLAB_OBJ_EXT_IN_OBJ)
> +#else
> +#define SLAB_OBJ_EXT_IN_OBJ    __SLAB_FLAG_UNUSED
> +#endif
> +
>  /*
>   * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
>   *
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 2c2ed2452271..bfe2f498e622 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -43,11 +43,13 @@ DEFINE_MUTEX(slab_mutex);
>  struct kmem_cache *kmem_cache;
>
>  /*
> - * Set of flags that will prevent slab merging
> + * Set of flags that will prevent slab merging.
> + * Any flag that adds per-object metadata should be included,
> + * since slab merging can update s->inuse that affects the metadata layo=
ut.
>   */
>  #define SLAB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER =
| \
>                 SLAB_TRACE | SLAB_TYPESAFE_BY_RCU | SLAB_NOLEAKTRACE | \
> -               SLAB_FAILSLAB | SLAB_NO_MERGE)
> +               SLAB_FAILSLAB | SLAB_NO_MERGE | SLAB_OBJ_EXT_IN_OBJ)
>
>  #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
>                          SLAB_CACHE_DMA32 | SLAB_ACCOUNT)
> diff --git a/mm/slub.c b/mm/slub.c
> index 8101df5fdccf..7de6e8f8f8c2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -970,6 +970,40 @@ static inline bool obj_exts_in_slab(struct kmem_cach=
e *s, struct slab *slab)
>  {
>         return false;
>  }
> +
> +#endif
> +
> +#if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
> +static bool obj_exts_in_object(struct kmem_cache *s)
> +{
> +       return s->flags & SLAB_OBJ_EXT_IN_OBJ;
> +}
> +
> +static unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
> +{
> +       unsigned int offset =3D get_info_end(s);
> +
> +       if (kmem_cache_debug_flags(s, SLAB_STORE_USER))
> +               offset +=3D sizeof(struct track) * 2;
> +
> +       if (slub_debug_orig_size(s))
> +               offset +=3D ALIGN(sizeof(unsigned int),
> +                               __alignof__(unsigned long));
> +
> +       offset +=3D kasan_metadata_size(s, false);
> +
> +       return offset;
> +}
> +#else
> +static inline bool obj_exts_in_object(struct kmem_cache *s)
> +{
> +       return false;
> +}
> +
> +static inline unsigned int obj_exts_offset_in_object(struct kmem_cache *=
s)
> +{
> +       return 0;
> +}
>  #endif
>
>  #ifdef CONFIG_SLUB_DEBUG
> @@ -1270,6 +1304,9 @@ static void print_trailer(struct kmem_cache *s, str=
uct slab *slab, u8 *p)
>
>         off +=3D kasan_metadata_size(s, false);
>
> +       if (obj_exts_in_object(s))
> +               off +=3D sizeof(struct slabobj_ext);
> +
>         if (off !=3D size_from_object(s))
>                 /* Beginning of the filler is the free pointer */
>                 print_section(KERN_ERR, "Padding  ", p + off,
> @@ -1439,7 +1476,10 @@ check_bytes_and_report(struct kmem_cache *s, struc=
t slab *slab,
>   *     A. Free pointer (if we cannot overwrite object on free)
>   *     B. Tracking data for SLAB_STORE_USER
>   *     C. Original request size for kmalloc object (SLAB_STORE_USER enab=
led)
> - *     D. Padding to reach required alignment boundary or at minimum
> + *     D. KASAN alloc metadata (KASAN enabled)
> + *     E. struct slabobj_ext to store accounting metadata
> + *        (SLAB_OBJ_EXT_IN_OBJ enabled)
> + *     F. Padding to reach required alignment boundary or at minimum
>   *             one word if debugging is on to be able to detect writes
>   *             before the word boundary.
>   *
> @@ -1468,6 +1508,9 @@ static int check_pad_bytes(struct kmem_cache *s, st=
ruct slab *slab, u8 *p)
>
>         off +=3D kasan_metadata_size(s, false);
>
> +       if (obj_exts_in_object(s))
> +               off +=3D sizeof(struct slabobj_ext);
> +
>         if (size_from_object(s) =3D=3D off)
>                 return 1;
>
> @@ -2250,7 +2293,8 @@ static inline void free_slab_obj_exts(struct slab *=
slab)
>         if (!obj_exts)
>                 return;
>
> -       if (obj_exts_in_slab(slab->slab_cache, slab)) {
> +       if (obj_exts_in_slab(slab->slab_cache, slab) ||
> +                       obj_exts_in_object(slab->slab_cache)) {


I think you need a check for obj_exts_in_object() inside
alloc_slab_obj_exts() to avoid allocating the vector.

>                 slab->obj_exts =3D 0;
>                 return;
>         }
> @@ -2291,6 +2335,21 @@ static void alloc_slab_obj_exts_early(struct kmem_=
cache *s, struct slab *slab)
>                 if (IS_ENABLED(CONFIG_MEMCG))
>                         slab->obj_exts |=3D MEMCG_DATA_OBJEXTS;
>                 slab_set_stride(slab, sizeof(struct slabobj_ext));
> +       } else if (obj_exts_in_object(s)) {
> +               unsigned int offset =3D obj_exts_offset_in_object(s);
> +
> +               slab->obj_exts =3D (unsigned long)slab_address(slab);
> +               slab->obj_exts +=3D s->red_left_pad;
> +               slab->obj_exts +=3D obj_exts_offset_in_object(s);
> +               if (IS_ENABLED(CONFIG_MEMCG))
> +                       slab->obj_exts |=3D MEMCG_DATA_OBJEXTS;
> +               slab_set_stride(slab, s->size);
> +
> +               for_each_object(addr, s, slab_address(slab), slab->object=
s) {
> +                       kasan_unpoison_range(addr + offset,
> +                                            sizeof(struct slabobj_ext));
> +                       memset(addr + offset, 0, sizeof(struct slabobj_ex=
t));
> +               }
>         }
>         metadata_access_disable();
>  }
> @@ -7883,6 +7942,7 @@ static int calculate_sizes(struct kmem_cache_args *=
args, struct kmem_cache *s)
>  {
>         slab_flags_t flags =3D s->flags;
>         unsigned int size =3D s->object_size;
> +       unsigned int aligned_size;
>         unsigned int order;
>
>         /*
> @@ -7997,7 +8057,13 @@ static int calculate_sizes(struct kmem_cache_args =
*args, struct kmem_cache *s)
>          * offset 0. In order to align the objects we have to simply size
>          * each object to conform to the alignment.
>          */
> -       size =3D ALIGN(size, s->align);
> +       aligned_size =3D ALIGN(size, s->align);
> +#if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
> +       if (aligned_size - size >=3D sizeof(struct slabobj_ext))
> +               s->flags |=3D SLAB_OBJ_EXT_IN_OBJ;
> +#endif
> +       size =3D aligned_size;
> +
>         s->size =3D size;
>         s->reciprocal_size =3D reciprocal_value(size);
>         order =3D calculate_order(size);
> --
> 2.43.0
>

