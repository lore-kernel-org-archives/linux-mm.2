Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1883CCD1A7
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 18:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 129EF8E0006; Mon, 20 Oct 2025 14:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 102408E0002; Mon, 20 Oct 2025 14:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0176C8E0006; Mon, 20 Oct 2025 14:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E42E48E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:52:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 52F4B1DF286
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:52:31 +0000 (UTC)
X-FDA: 84019388502.10.DEB5272
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5BA0A1C0005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:52:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xGtTvO3I;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.166.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760986349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UH3L+M6Do8/IZzZOeL5IDLK/GCmbK/v9qK/+5ymQcBc=;
	b=IBB983BpAu9+YPkWPhfeVRDrcuGomBi2d1W7jQCB3HHdPPVUlp33DoYZHR6bJOkDeS2H67
	Lx3c86nSQb8l1H7hqz/O+Y4SWv2IjVaZqIxcI40ZmlZO81XGW2Q6CXV53ufsy3ZitpVcUb
	pK1Zu8LGtX/zlfMMxPwYr+voUEO8t2c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xGtTvO3I;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.166.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760986349; a=rsa-sha256;
	cv=none;
	b=NAKdG2tbocAqHp3UYUf23/Xs3ATM3/PTa69+fSrtUUDV6hZsz1tqy9CSNrM8yPzAHk5zBm
	nskdQxq9j/t8e3RW7lxGGlKM0gha1eQbDiGZ9X7FxeevU74Drb0XLlZi5CkHp+yFadI9PD
	CsSQshEcNUJtwfjxrBpJpLg+/fSpVPM=
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-430e5d5ca8aso82315ab.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760986348; x=1761591148; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UH3L+M6Do8/IZzZOeL5IDLK/GCmbK/v9qK/+5ymQcBc=;
        b=xGtTvO3Ims2+jacWhZKIfaabJHk9x3rg2vrya690um6nDxfa4/CrFn4slTzu0299uR
         MhL4wiUECtjQEuZOvVz4TXp7WPMVmMMu9M8nkctUuILLN34v1bZGN/77Ug6KfGSOsXnK
         1lpIZ4zT1gK56J/pdLw1tzgF6YlALQbVlaOy2t0oh7ViU2fRdY8qrwPr4K8Uxive8BuO
         ZEgIkNy7Zk4hxdTjNs21GcGmduMl9RpsVp/UMVJjgW1C7+qvz9t3v2ghkbpKqUMTsO8K
         iFh+M+lQGOQsCI/gCRqIGwzPjHq/YJhiO8YTe6mLsu9bUTSPxFa5Cmj3R9DXdvbXczwV
         xEfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760986348; x=1761591148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UH3L+M6Do8/IZzZOeL5IDLK/GCmbK/v9qK/+5ymQcBc=;
        b=XNnD9eHuN4gQi5kO9BJ0MjTR+OEEObUsoPtdIZj2r79TI/jOSLEq7ZKp2e7OxmOZs2
         UpeWZo1QFOktiKF5zXZYtGpI6ceo4CWzhg8WNi5VftrYFBja9SrYvUTyCdGO+frCLQFN
         oALu0O5ndQApC05CxRV2t/xI1hHGyilDIuHzDVi5MSM7nitwEHnxjRbbytlB963czuhp
         R77icHWn7LROlPAlTBS+4coKzsIjN8rYzRarktm7jBk3/QJm3aiPwLYXNZnY/cCl7sBA
         hUIvXqoSrSrbJ5jrjIcMKz7U10OJZ3fw7olQSWMMLLO5qIsc7Bv68kZG3xPO1+4JMy+h
         WN/w==
X-Forwarded-Encrypted: i=1; AJvYcCXjFbEJd1c2VfXA9zZCPrI6JfEjHheojyX97XcshLjUACO7YX4fAg+8ziaIetmv0SYTdpo+CUS7vQ==@kvack.org
X-Gm-Message-State: AOJu0YwRW7IjHH3ZHPhQzeW1odSMGiIiGxj+tL6X36k5xL9FCF0oiCI/
	DIsZJoM63OYZIOWxmjvbUKNKJykBymcGU11ZdqAnq2OKkccX09niVGXewPON2nMZtUptQEqVeGW
	MoqaP0NyFpDmvp+n0oBnnVhm9YTrxTR2foVKutQKq
X-Gm-Gg: ASbGncuiB1BHilfCt/Y2OVKQC99HRAQJzUnft40KcVUEkcByoRJWgQ3U0qj9BwXC3Wz
	n8rlc5mAlZ0oUFXtwuE/SJ3/ou5WEup/uNDov5uIJQBZvLoAbMCW49ydnEjAZB1Zt0kTwTotdIN
	HTaWK16PD3dSYLhcSuBepGibbmiD0I7wNafgvnLzqO5Ta/LHAZrY7gfKohtcRDW0GwRKrhcu2sX
	R9XlKtJiqsX9KFQT+0PilfrFS6FxNnujLk4HKdfXehIwEoMy8BuuuV727I=
X-Google-Smtp-Source: AGHT+IECMTuCbPUO2ugkDIL5dMsu9QmLMhJNLgKv48taGSx+9VT52z7nwDMkZPiViU21/WAOQTSQMPLooT+yBZUkja0=
X-Received: by 2002:a05:622a:1b06:b0:4b0:f1f3:db94 with SMTP id
 d75a77b69052e-4ea12038bbfmr495711cf.5.1760986347737; Mon, 20 Oct 2025
 11:52:27 -0700 (PDT)
MIME-Version: 1.0
References: <20251020143011.377004-1-hao.ge@linux.dev>
In-Reply-To: <20251020143011.377004-1-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 20 Oct 2025 11:52:16 -0700
X-Gm-Features: AS18NWDJReJvkcvY9a-Vg5Sxok_V9AisWyediqO9Nhy9j9lFCVqZjHumsBMEEYg
Message-ID: <CAJuCfpGhzzQwS8q0t3RWygT924uSFRJUxmb5pSMnLrjrRnPuSg@mail.gmail.com>
Subject: Re: [PATCH v2] slab: Avoid race on slab->obj_exts in alloc_slab_obj_exts
To: Hao Ge <hao.ge@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hao Ge <gehao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5BA0A1C0005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: bwow57fw3ubpwwrx89utmzap3xfja4jb
X-HE-Tag: 1760986349-553560
X-HE-Meta: U2FsdGVkX1+AaaPMpwEUeJRVhiBJsn+TaAY0TdPSKXsYTwWNBn9xL6atJycvefWCVes/tYpJ3DDHHZtEBbGk+Ha792EIE1vNGxaN2LOwcczy0bBlOq8be0iclgB8Xfw4OIbyAhwK0VGt2oN3KZMvnCBVBsKu9PWMHS1G2jkXWRmUcflf28eI/NcwSzAXOiaaXJ97MUJBEigoAdoVmWczaWjUAKdAXI8SgSxJJPIpCFKtKKHZdcNfyLOd5qRYK7xbWADlijFFYrA69BICwaIZwRqNn7FKfl59m6znXtt6TNWUP9fJ623BMsXm3lmYGZ8K6XuQXQzarsbEBAYXHMGyHUaZLk3asa3mx2sHUfAVJHnEbfoSU3+75ujXEBsL+CKGimdLMMDqkJjM/F0gu73bXR/wcD+Ib5PacHX1xawxQjhgSyEuMJUlpSt8l0qJ/PIyCOSMoZEFGRsS7ASm5wKkXArVWK9r8k0IftYUConcf8DZl2A59l25Gpdk3HpfDNWQ3kkqOcHgbb54wxklPUf5TnchXYcYxDwSfJSMxpJaD4gRMaMHHMBtylxSYrdCNR0Koux3BXCTNe4mLJZSkH4PNU/MQj2L2hxcC+7S1Bbbp5a9NMyCvIg0zl89E5PY62+VylbfQIUPhzFuyVw6eQSImmy/fwIDEBz0yBDHz5tmMkTCZTjgoJnMAN6ehZ66Aavsn/pZeWE0DDm1sc0MKoa4FbQkev2rEHkf5L6aSWdd1yEEVfbpxlCLHyl7uSDEFo50eS2k2NyDAkYlX9Lzk457v50La6wCfGJiVYxoaAPUn7zJLjVmUQiwYxB/YqyrbecX1CfFbj17e0oS8srrGKk9/2kSN8+jt7ryQBLkYEI791YuAW4brrqXmqjHeT5YS6vsIh4qEtKI62oI3mMltGHn63BtTFDhgWkrtbTInmTbej7gQue5rfr1n6iPuHNt8dyqRLpFTphwDzNVqUx/zBz
 E7qPAyPH
 LdHNUUBvjv1DyxzPVhrT+h632RtE8oSyUBdUYiAnaYqSbmfUrGbKC4CrtZh9cDvo/HQoq31GTVljf3hAZlP+H90lyRf9fFgkauS2k6RNrHbG09dJPg7Dw37uo+HPsiLiJR9wPnwpVI2KbByCyxr97GjeIMvcSo7l/veWFnOgHsOrNZWqhZHR1UiGk6TY1arbYwZ3tDJEn3BprlF4jSgTLDorlHJJuAx2Ah7HJbYSvPXyXZO5hP2HKytXNXU8IeqL1uT/U8mgtCKVLNWw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 7:31=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> From: Hao Ge <gehao@kylinos.cn>
>
> In the alloc_slab_obj_exts function, there is a race condition
> between the successful allocation of slab->obj_exts and its
> setting to OBJEXTS_ALLOC_FAIL due to allocation failure.
>
> When two threads are both allocating objects from the same slab,
> they both end up entering the alloc_slab_obj_exts function because
> the slab has no obj_exts (allocated yet).
>
> And One call succeeds in allocation, but the racing one overwrites
> our obj_ext with OBJEXTS_ALLOC_FAIL. The threads that successfully
> allocated will have prepare_slab_obj_exts_hook() return
> slab_obj_exts(slab) + obj_to_index(s, slab, p), where slab_obj_exts(slab)
> already sees OBJEXTS_ALLOC_FAIL and thus it returns an offset based
> on the zero address.
>
> And then it will call alloc_tag_add, where the member codetag_ref *ref
> of obj_exts will be referenced.Thus, a NULL pointer dereference occurs,
> leading to a panic.
>
> In order to avoid that, for the case of allocation failure where
> OBJEXTS_ALLOC_FAIL is assigned, we use cmpxchg to handle this assignment.
>
> Conversely, in a race condition, if mark_failed_objexts_alloc wins the
> race, the other process (that previously succeeded in allocation) will
> lose the race. A null pointer dereference may occur in the following
> scenario:
>
> Thread1                                                 Thead2
>
> alloc_slab_obj_exts                               alloc_slab_obj_exts
>
> old_exts =3D READ_ONCE(slab->obj_exts) =3D 0
>
>                                                   mark_failed_objexts_all=
oc(slab);
>
> cmpxchg(&slab->obj_exts, old_exts, new_exts) !=3D old_exts
>
> kfree and return 0;
>
> alloc_tag_add -> a panic occurs.

I appreciate the time and effort you put in this description but it
sounds overly-complicated IMHO. IIUC in both cases the issue happens
when a valid slab->obj_exts pointer is overwritten by
OBJEXTS_ALLOC_FAIL. I would simply say:

If two competing threads enter alloc_slab_obj_exts() and one of them
fails to allocate the object extension vector, it might override the
valid slab->obj_exts allocated by the other thread with
OBJEXTS_ALLOC_FAIL. This will cause the thread that lost this race and
expects a valid pointer to dereference a NULL pointer later on.

>
> To fix this, introduce a retry mechanism for the cmpxchg() operation:
> 1. Add a 'retry' label at the point where READ_ONCE(slab->obj_exts) is
>    invoked, ensuring the latest value is fetched during subsequent retrie=
s.
> 2. if cmpxchg() fails (indicating a concurrent update), jump back to
>    "retry" to re-read old_exts and recheck the validity of the obj_exts
>    allocated in this operation.

The paragraph above explains "what" you do but we can use the code to
understand that. Changelog should describe "why" not "what" you do. I
would just say:

Update slab->obj_exts atomically using cmpxchg() to avoid
slab->obj_exts overrides by racing threads.

>
> Thanks for Vlastimil and Suren's help with debugging.
>
> Fixes: f7381b911640 ("slab: mark slab->obj_exts allocation failures uncon=
ditionally")
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> ---
> v2: Incorporate handling for the scenario where, if mark_failed_objexts_a=
lloc wins the race,
>     the other process (that previously succeeded in allocation) will lose=
 the race, based on Suren's suggestion.
>     Add Suggested-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  mm/slub.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 2e4340c75be2..fd1b5dda3863 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2054,7 +2054,7 @@ static inline void mark_objexts_empty(struct slabob=
j_ext *obj_exts)
>
>  static inline void mark_failed_objexts_alloc(struct slab *slab)
>  {
> -       slab->obj_exts =3D OBJEXTS_ALLOC_FAIL;
> +       cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
>  }
>
>  static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
> @@ -2136,6 +2136,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct k=
mem_cache *s,
>  #ifdef CONFIG_MEMCG
>         new_exts |=3D MEMCG_DATA_OBJEXTS;
>  #endif
> +retry:
>         old_exts =3D READ_ONCE(slab->obj_exts);
>         handle_failed_objexts_alloc(old_exts, vec, objects);
>         if (new_slab) {
> @@ -2145,8 +2146,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct k=
mem_cache *s,
>                  * be simply assigned.
>                  */
>                 slab->obj_exts =3D new_exts;
> -       } else if ((old_exts & ~OBJEXTS_FLAGS_MASK) ||
> -                  cmpxchg(&slab->obj_exts, old_exts, new_exts) !=3D old_=
exts) {
> +       } else if (old_exts & ~OBJEXTS_FLAGS_MASK) {
>                 /*
>                  * If the slab is already in use, somebody can allocate a=
nd
>                  * assign slabobj_exts in parallel. In this case the exis=
ting
> @@ -2158,6 +2158,20 @@ int alloc_slab_obj_exts(struct slab *slab, struct =
kmem_cache *s,
>                 else
>                         kfree(vec);
>                 return 0;
> +       } else if (cmpxchg(&slab->obj_exts, old_exts, new_exts) !=3D old_=
exts) {
> +               /*
> +                * There are some abnormal scenarios caused by race condi=
tions:
> +                *
> +                *      Thread1                         Thead2
> +                *   alloc_slab_obj_exts                alloc_slab_obj_ex=
ts
> +                *   old_exts =3D READ_ONCE(slab->obj_exts) =3D 0
> +                *                                      mark_failed_objex=
ts_alloc(slab);
> +                *   cmpxchg(&slab->obj_exts, old_exts, new_exts) !=3D ol=
d_exts
> +                *
> +                * We should retry to ensure the validity of the slab_ext
> +                * allocated in this operation.
> +                */

I don't think we need a diagram here. The race is quite trivial. Maybe
a simple comment like this?

/* Retry if a racing thread changed slab->obj_exts from under us. */

> +               goto retry;
>         }
>
>         if (allow_spin)
> --
> 2.25.1
>

