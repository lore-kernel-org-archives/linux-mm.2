Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CF7EFD45F6
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 21:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B9C86B0088; Wed, 25 Feb 2026 16:29:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567EA6B0089; Wed, 25 Feb 2026 16:29:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41ED66B008A; Wed, 25 Feb 2026 16:29:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2DD246B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:29:12 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3DDB8C3CE
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:29:11 +0000 (UTC)
X-FDA: 84484269702.29.0115A30
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id B5AAA80008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:29:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VG43uxIZ;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772054949; a=rsa-sha256;
	cv=pass;
	b=XnXAHq1r6vMvMY8/FtkFryeTVObXcrKB43jjDaXR7aOIgIyfWZ+/oaFQDdZjt+teXw1YL2
	GpP+fXRUjNmfkDdq7DsUJfOiB1vWXx5luZUDn8eDCQuC3gE4QdboNd5hZQnug/CnMlKT4P
	n3kYAk5xnxKi6KB0w2neyjGUGwCIt5Y=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VG43uxIZ;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772054949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CBVeTBt/zgAeQebVCnCfQ16MTGwsKLeH6DI4j8g18R4=;
	b=P3wOay5xjZ6EYrS/fru/4OKTu5CAH5lPgWUmRW+/mWmQN7tY7IUxQTccmsQ2W0F34iRh9L
	vZmYF387lKbnb2KfBcdcc1J6abFyEECGS+0UlNqRnPqdf4CvzCk5/y9jjZBilo69BwQ0cv
	V+LTLZWX4+ks0C7PCEXVRGnJpF1gMBg=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-506a355aedfso79861cf.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:29:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772054949; cv=none;
        d=google.com; s=arc-20240605;
        b=g/u2NKGvWqy+v+OCvqmpKmfcVqHkJSCRMQHHXbNwyPMmPvYnaLZ8HFc3ZYUiMF+yjz
         vdMyHVidXsX740bTdnBf390+ysCkoUDg1R40Fe0UMm8klVR8ibpchhrUMYeN6rjrhUTe
         HQ+dv7qTTnUP/0kW9LK5IPoXJ1mGeLNjuCzqe2+XWx6vXSB2El4K7Bs6HG4PaBWGrqiV
         AQN/o6/KJ5EXTkuXakRj3A+HcSJjz2b+udx1zjWrc4pFkcsL5th+WBjwH6RoHpSbfGPu
         E5jj+iQjk0RIzyPNVnqZLjFtpeyNlsdeNWi6bXzXZZ/NKDFdc0Wd4QBV3p280LG7u/yR
         eINQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CBVeTBt/zgAeQebVCnCfQ16MTGwsKLeH6DI4j8g18R4=;
        fh=0YqHVxjtOV4mwYHJhxWKpQ6H/ge1VbIIPVkHYqZQGBQ=;
        b=ilsgxiT884/hUOg1VahsSTJvOOwi0zkY8tWfs8rcqsElpP+BINyIobMCWNNps/eDz8
         BbrZD33AHj22aMWAOjYQvxPmYSaBema7nQ8TyPfpN5IDH2mAkl04PdRv7RsiiPtXp8Vy
         xFaC3gBhAfZh5hNdzvRSabA0YrID8lhba5RLpPBh3CEM9onAnMSA8M438wPET/NXlpAp
         iLZL3fHz8yd8m1UiVvoAL9UfldpELGLbX5K01dcMitd/3n4FVRovGBLxspv+hKYogkWf
         vTk+jqcAeF3jgSD8vjWj/ERnmPKxknAwtoKyAdsoItJzZo1lazgnHz0Q+SCZI/9cLJGJ
         DDdw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772054949; x=1772659749; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CBVeTBt/zgAeQebVCnCfQ16MTGwsKLeH6DI4j8g18R4=;
        b=VG43uxIZAojsA+NWqRYCD5EgwVt8UF55hSGizsxVG7lcZN2EGPPmUzi/0MrYomprYV
         5+XkMI5tO5oxY5U6TmDcs0MRQb/MsjfTa6MLNyx06VOlbigNfd4ksUQxnfwFR0CL/TNU
         SDFIsasgA7kuwOp9C52Zo9VctKKf9EbZYupIeFxrBaQOlZuLc2Z/YaGxjBL/E2ei5Ke+
         LR6lVZEYNJZfC605QktZY6WCs5SwMoZCmLbB5kDL1ZD9WTM29uw6iSmwyw1hgnCUmAd/
         aoT1sgbWsSwHxhrrh0bziURybpAX4ki7uEu4S6chENMIHahTDjP2F740BNbNLj/Mp1T4
         TFeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772054949; x=1772659749;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CBVeTBt/zgAeQebVCnCfQ16MTGwsKLeH6DI4j8g18R4=;
        b=G8D9kqv0blOCEb3ua7jVEKYjVmErqGI0x8MsbtDoLyj764KCHCenb5F+ilk1THvI9K
         76aVZm56lYTmO7wPkiHPMuVGhy3u/gnUpbdMgM4gTs7zdQMLsBrbrGutp+UXXtX0gDui
         WskpVz30hjbfPm41SzeuciDK8Rz9jKUxrSvjynGX0ChLHTDSEuO+tZ0GPVNeFE1hidqa
         iAoMKOQFA/tFWQqyiP7xcQZpJJPKG+0zOVmEuQwP75CuSNDw51PSBjKJ0jiEjWrRtTJj
         qwaQ7yAZszMQCoEg/SoGiRSO7pnLcThkAR/hHSMF376FnyeaaN8QbkjlDIKd0nSiOkbY
         /NzA==
X-Forwarded-Encrypted: i=1; AJvYcCVCATLoi23vvO91vgFWSWSHoHWXSDSbcifTtUR19mHcr0Fx5JJY6E1mbhYhe8bEF9q0DweIsBt3TQ==@kvack.org
X-Gm-Message-State: AOJu0YxG8KVFtUqNDNv4StulPH9bE92x3zkFCQiuS4Px41oNUX4obwUh
	iNyuUgz0JxBMP4bOvzB6G9KAFk39hTMH3AcBdZC8l2TiBy4x9pajMt0PqhnvH5Q6XgeUu/VBfxI
	s7Zo7mvxYcbZhAlgs8Xl9ze/rTheZ/Nv8Sd0lPzGp
X-Gm-Gg: ATEYQzxHd6rk/cyMcpPIonTZ4sZF1aDwJ0WNohPIwmjXP7HyaMi+xkZSwYksA5O8Sqy
	Q4TsYyjNhhJG2++rolvpFcl5AJWVS1Kk2Z51oRMXKg7/B11kBZTVj0Z/JgZ88D6BlsryauIT3ze
	RUXFzDGaiC2xoygKxgFTjEeoYPeGNYhYsIIfGPLj/J/jyyMmv0LsPnrfFZPliXLIPX4a7J00QNJ
	shEFfsqRrkehezeOcPzGY62wnnh8KAt7C6yMHsDFPlRdhCpJaAH3ZQzp1er6wbhj0uiBI2z8o5v
	AQ7OF6NvdHWUDkOEskOz9SEYSXYioJiYWGw=
X-Received: by 2002:ac8:7d95:0:b0:4ed:ff77:1a85 with SMTP id
 d75a77b69052e-50745536611mr542441cf.17.1772054947996; Wed, 25 Feb 2026
 13:29:07 -0800 (PST)
MIME-Version: 1.0
References: <20260225163407.2218712-1-surenb@google.com> <CAJuCfpH-+trdZ=68v0FTj_yKn6+gmE10gKjmjrTyPvO2EaXdRQ@mail.gmail.com>
 <3ab53191-5aac-4b9f-a019-303d837ec517@suse.com>
In-Reply-To: <3ab53191-5aac-4b9f-a019-303d837ec517@suse.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 25 Feb 2026 21:28:57 +0000
X-Gm-Features: AaiRm514iarEi9e6d4SvP5mFx26wknnf3cgG_K9dLrpjH5Lns-l8myFmCZfY2uc
Message-ID: <CAJuCfpEgB8bLMSXPG_K0uaOvALoC1OamKuRosv3Bb=ngiYJz6A@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] mm/slab: mark alloc tags empty for sheaves
 allocated with __GFP_NO_OBJ_EXT
To: Vlastimil Babka <vbabka@suse.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, harry.yoo@oracle.com, 
	00107082@163.com, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B5AAA80008
X-Stat-Signature: uj9oc1yiptqfrb14dxjk3mqrrqg7c7x4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772054949-38655
X-HE-Meta: U2FsdGVkX185ilEdHXj/nqwPs+tkxXY6ce0dTukHIpsfKsM9AMZiH0lpZRZ7FjvcFPAoBVo11FPxKSnNMNUrC+PjhNSIXWT/k7eGPD05rPGu4rdf4KjfweFXX1P3XTkQEJNste5CHa97LAQ1ANtSjM+BKxkUhVl4rmyOovy8xwRrLKbYGcy/HnpprRZZ0dikohZG2Rieimmu5KOdtIirrrrNxx9yAW0PRRU2MclMcedDlOW4+05qhxEoodSkkCiSLdGPdkJnJwk/nqdWf/S7OJf7adwQW+nX3K7n0rf1oP3HMR2+ZT83a3mQP0JtArr83+q1XuYYHve9Xdp5112U9XXQNeiQvk1gTWofBEdpLu+BGOZw+2UgMWl4KvRfEfEZyPvYPUKU5jo2cYG5vzdNKjmz3aRzQve8ODv4OOY6LHC8yMnnUY2P1fDS6kZdYTnUjJqXEU0Ywus0Nkc8gNLkr7MM+90zaILtcbQCfDnELBxHiDoApN9HL6gU/K3OY5CUq7obGacqAosupR0lh02tHphwtSOC49NtzbId1KOSMknH4LkSf9hWDckLxD5QOHCSM5Q+O3+YgHnLioViixEPdyqa8weVmIZlwqZRIKV9Jw9dpUzIeDscAijpzb7W4SzzkV//LoZvY1pxRmopW9DYOmpGUvwoLlWv3DCD1N8yhIJrgQFsx1kCI0i7CgFr4F3c4NmL5jqegUZbF03a/Et2Pt6Y5AOsoY3/kaHC24KV6O/SNaV6FVfZgFdt/b71elw79LnLgu7bmSm6cL8JwzynCNr+1P1ZqzYeGfuYtntANKkYtvwKBiTFVyogbRSfdSzDw3C7orMmAFJo8Khseg2W1pUAVQu725pH3XKOXjD/GjW4+uKtMXLlGzOIHt/QeMf+SykYi5fn0R+nGZuwx8kRkfbld3dZBB8dKBIJupF3D3gFTG5/w/tsJm5eEf+D+2FzDhh8abm12yqtMbvgG2Z
 EHgt0VHn
 rKMDbSN+66K45HmSNrFOK5NftlRrLZecYWf70L6SOAnHPrbOCrpwlsZZDDu9t2ZBiYwygHQ53dHbTW+0xfDsOqq/cen+HghMkAaZijXyz3y/q0lx7ZL/mERXdwAh9GMIP1mjMtTJuDfTuJdwYfO2IrDqLoyieZixROObDhB+IM88E7SprmP5hcFp/gCItcwy6E83GiOxgPxbIh8pNkFpkSFdMApehHWCq/9Mqt/O6xXIMAz7m6DQxrCnigXzF45r7b7F5yL3cGbhJEnAV7JnDDiKr2xTkfVaephAwjayHioXNtyWwj1nF7Il/Ljdsw4Jju1XlrIjWxAq42zfrNFwfhiRNaIqVdHOmN20BWICB10IV3LouJiJfdz3p7xjBAriXfYKHdhOcn/RTuij2B6JPxjONcjjyX04ytXice9nx7xzok0h4cAxcB/4cbD6l9LfUW6HrzOHTexyclZtex/QaYp9syQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 9:23=E2=80=AFPM Vlastimil Babka <vbabka@suse.com> w=
rote:
>
> On 2/25/26 8:08 PM, Suren Baghdasaryan wrote:
> > On Wed, Feb 25, 2026 at 4:34=E2=80=AFPM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> >>
> >> alloc_empty_sheaf() allocates sheaves from SLAB_KMALLOC caches using
> >> __GFP_NO_OBJ_EXT to avoid recursion, however it does not mark their
> >> allocation tags empty before freeing, which results in a warning when
> >> CONFIG_MEM_ALLOC_PROFILING_DEBUG is set. Fix this by marking allocatio=
n
> >> tags for such sheaves as empty.
> >>
> >
> > I think this should also have:
> >
> > Fixes: 4c0a17e28340 ("slab: prevent recursive kmalloc() in alloc_empty_=
sheaf()")
> >
> > and CC to stable for inclusion into 6.19.
> > Andrew, Vlastimil, should I post another version CC'ing stable or you
> > can add that line and forward to stable?
>
> I will add it. Note, they don't care about getting an actual email, but
> seeing the Cc: line in the mainline commit.

Perfect! Thank you. Let me know if anything else is needed on my end.

>
> >> Reported-by: David Wang <00107082@163.com>
> >> Closes: https://lore.kernel.org/all/20260223155128.3849-1-00107082@163=
.com/
> >> Analyzed-by: Harry Yoo <harry.yoo@oracle.com>
> >> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> >> Tested-by: Harry Yoo <harry.yoo@oracle.com>
> >> Tested-by: David Wang <00107082@163.com>
> >> ---
> >>  include/linux/gfp_types.h |  2 ++
> >>  mm/slab.h                 |  4 ++--
> >>  mm/slub.c                 | 33 +++++++++++++++++++++++----------
> >>  3 files changed, 27 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> >> index 814bb2892f99..6c75df30a281 100644
> >> --- a/include/linux/gfp_types.h
> >> +++ b/include/linux/gfp_types.h
> >> @@ -139,6 +139,8 @@ enum {
> >>   * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
> >>   *
> >>   * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extensi=
on.
> >> + * mark_obj_codetag_empty() should be called upon freeing for objects=
 allocated
> >> + * with this flag to indicate that their NULL tags are expected and n=
ormal.
> >>   */
> >>  #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
> >>  #define __GFP_WRITE    ((__force gfp_t)___GFP_WRITE)
> >> diff --git a/mm/slab.h b/mm/slab.h
> >> index 71c7261bf822..f6ef862b60ef 100644
> >> --- a/mm/slab.h
> >> +++ b/mm/slab.h
> >> @@ -290,14 +290,14 @@ static inline void *nearest_obj(struct kmem_cach=
e *cache,
> >>
> >>  /* Determine object index from a given position */
> >>  static inline unsigned int __obj_to_index(const struct kmem_cache *ca=
che,
> >> -                                         void *addr, void *obj)
> >> +                                         void *addr, const void *obj)
> >>  {
> >>         return reciprocal_divide(kasan_reset_tag(obj) - addr,
> >>                                  cache->reciprocal_size);
> >>  }
> >>
> >>  static inline unsigned int obj_to_index(const struct kmem_cache *cach=
e,
> >> -                                       const struct slab *slab, void =
*obj)
> >> +                                       const struct slab *slab, const=
 void *obj)
> >>  {
> >>         if (is_kfence_address(obj))
> >>                 return 0;
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 862642c165ed..34c32749f091 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2041,18 +2041,18 @@ static inline void dec_slabs_node(struct kmem_=
cache *s, int node,
> >>
> >>  #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> >>
> >> -static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
> >> +static inline void mark_obj_codetag_empty(const void *obj)
> >>  {
> >> -       struct slab *obj_exts_slab;
> >> +       struct slab *obj_slab;
> >>         unsigned long slab_exts;
> >>
> >> -       obj_exts_slab =3D virt_to_slab(obj_exts);
> >> -       slab_exts =3D slab_obj_exts(obj_exts_slab);
> >> +       obj_slab =3D virt_to_slab(obj);
> >> +       slab_exts =3D slab_obj_exts(obj_slab);
> >>         if (slab_exts) {
> >>                 get_slab_obj_exts(slab_exts);
> >> -               unsigned int offs =3D obj_to_index(obj_exts_slab->slab=
_cache,
> >> -                                                obj_exts_slab, obj_ex=
ts);
> >> -               struct slabobj_ext *ext =3D slab_obj_ext(obj_exts_slab=
,
> >> +               unsigned int offs =3D obj_to_index(obj_slab->slab_cach=
e,
> >> +                                                obj_slab, obj);
> >> +               struct slabobj_ext *ext =3D slab_obj_ext(obj_slab,
> >>                                                        slab_exts, offs=
);
> >>
> >>                 if (unlikely(is_codetag_empty(&ext->ref))) {
> >> @@ -2090,7 +2090,7 @@ static inline void handle_failed_objexts_alloc(u=
nsigned long obj_exts,
> >>
> >>  #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
> >>
> >> -static inline void mark_objexts_empty(struct slabobj_ext *obj_exts) {=
}
> >> +static inline void mark_obj_codetag_empty(const void *obj) {}
> >>  static inline bool mark_failed_objexts_alloc(struct slab *slab) { ret=
urn false; }
> >>  static inline void handle_failed_objexts_alloc(unsigned long obj_exts=
,
> >>                         struct slabobj_ext *vec, unsigned int objects)=
 {}
> >> @@ -2211,7 +2211,7 @@ int alloc_slab_obj_exts(struct slab *slab, struc=
t kmem_cache *s,
> >>                  * assign slabobj_exts in parallel. In this case the e=
xisting
> >>                  * objcg vector should be reused.
> >>                  */
> >> -               mark_objexts_empty(vec);
> >> +               mark_obj_codetag_empty(vec);
> >>                 if (unlikely(!allow_spin))
> >>                         kfree_nolock(vec);
> >>                 else
> >> @@ -2254,7 +2254,7 @@ static inline void free_slab_obj_exts(struct sla=
b *slab, bool allow_spin)
> >>          * NULL, therefore replace NULL with CODETAG_EMPTY to indicate=
 that
> >>          * the extension for obj_exts is expected to be NULL.
> >>          */
> >> -       mark_objexts_empty(obj_exts);
> >> +       mark_obj_codetag_empty(obj_exts);
> >>         if (allow_spin)
> >>                 kfree(obj_exts);
> >>         else
> >> @@ -2312,6 +2312,10 @@ static void alloc_slab_obj_exts_early(struct km=
em_cache *s, struct slab *slab)
> >>
> >>  #else /* CONFIG_SLAB_OBJ_EXT */
> >>
> >> +static inline void mark_obj_codetag_empty(const void *obj)
> >> +{
> >> +}
> >> +
> >>  static inline void init_slab_obj_exts(struct slab *slab)
> >>  {
> >>  }
> >> @@ -2783,6 +2787,15 @@ static inline struct slab_sheaf *alloc_empty_sh=
eaf(struct kmem_cache *s,
> >>
> >>  static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf =
*sheaf)
> >>  {
> >> +       /*
> >> +        * If the sheaf was created with __GFP_NO_OBJ_EXT flag then it=
s
> >> +        * corresponding extension is NULL and alloc_tag_sub() will th=
row a
> >> +        * warning, therefore replace NULL with CODETAG_EMPTY to indic=
ate
> >> +        * that the extension for this sheaf is expected to be NULL.
> >> +        */
> >> +       if (s->flags & SLAB_KMALLOC)
> >> +               mark_obj_codetag_empty(sheaf);
> >> +
> >>         kfree(sheaf);
> >>
> >>         stat(s, SHEAF_FREE);
> >>
> >> base-commit: 7dff99b354601dd01829e1511711846e04340a69
> >> --
> >> 2.53.0.414.gf7e9f6c205-goog
> >>
>

