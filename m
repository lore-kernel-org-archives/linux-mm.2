Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C14D0C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 16:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C86A06B008C; Wed, 15 Jul 2026 12:13:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C36186B0092; Wed, 15 Jul 2026 12:13:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B01886B0093; Wed, 15 Jul 2026 12:13:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DA7F6B008C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:13:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E626E160215
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:13:52 +0000 (UTC)
X-FDA: 84991507104.03.F9838A3
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id 00138100010
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:13:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bGgHnknG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784132031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzrlbG1i1Z2grnBug4mVQe2iSrEhqBzyFP6w96GEH0Q=;
	b=1RKBOCxWORBq0xYadhnyniaevM/9seZlVy7eiJAghEr9Arcxea/Kv7bbxM3nvvCePdbmbu
	r0kSaOxYB6KtFg0brLyc6+h7WRB2yQj0cQi11Oi5qYkIgWrNeA/kdb7w2+T6t+IlwUkfEN
	Ml8eqsBnnOp7Rg5uYTKTQxnwxpd1CNo=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bGgHnknG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784132031;
	b=ygM+qiUnBSHj9Y558R8rfbl/Z1zY94ErVVW1eehRV7fl85dwgouM89VyIwUqVBSXR7KnZv
	sSp1u6o9fShV1TTngRYBoFLi1osAU/yYx923pRWzrMhRcirxKjibuQksmSAXdYcgNH0nXt
	SMWMDP7AQoaH6rW+vTMUBWK0FfOyZes=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c01c79467so243191cf.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:13:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784132030; cv=none;
        d=google.com; s=arc-20260327;
        b=mPCDdYB6hargIJECSbK1kjR/bQvjiYYX5/gytoUAiCzYtxdgf2HCNdNrurEJWmrDWg
         t75CoJwR1hnkqUqIaa7Gto7pZcMPrBaRi59YN0UIUDO9Mke2f57JRfMw+7LHWi1/cGtj
         Zm0iJquq0sJdNV1jbwTMofTkvMwPpXX7mofQqVUYN7PmITH0FBeuW0h7TrPf023ZMIBJ
         ZdTf9GhlZvG4aefsd8HueVCOMjPuq93NSU26CsjNeNmgzdh4luOK6IIzIrgFJZUimkbQ
         ZcQhEaGt5Q4IDTD2ObFQwnEx4FW0FE2uOiXaXs+22U8g02+vJBn1RXAlhlsH93VT2kja
         OQAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NzrlbG1i1Z2grnBug4mVQe2iSrEhqBzyFP6w96GEH0Q=;
        fh=nxufOlSWkVDBgfWLyKX1begNdmqSG2AFFMDTUIUQlg8=;
        b=QcdRwmZ4Sf65JNA4IWarl2YPg48IRUBC5PL6JLyZx4CpStUtk57hdGffvELNQVKlMx
         QyU5cICYgmnbuCJ1iFdXu1aDpi18eeXZCUOc5kgslBEoGfBiyZs507NObS7JW6Qjx6Xg
         K9R2WwO1wQ71z8iUTr3GpWybMj4wgKgfuoeooy5cDBB0JN5UcIcpuV5aLugW7bHhRWp6
         bvHYdT6qdrvFVhNcxhJrT9BUyRx8+6d+GlG1KiZ+6kDdkFV9s7cOrxvaYHJc3zUIyDDj
         0WUBOxVVTpTEMAWS6cb3LRdqub0dVbnoWS9TJEFnelGkfFUHFlQ5b1qFILpBzocYBv/Y
         r1iA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784132030; x=1784736830; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NzrlbG1i1Z2grnBug4mVQe2iSrEhqBzyFP6w96GEH0Q=;
        b=bGgHnknGBrONEBofLYEM2bE/AKwNl6D/Ba3hNxFODvQ8WSUTQ39CDCDBoc5UJabb8E
         g29p13yAl06nHeM30Ue0SaF5LzH0hDn/vmop3NBlqpZewQ3+yw/os1E31M5j9N+53eE0
         ItCijNnq109POHcCGirYgy0pSfeQgO6JRSn2OIzshoKcrgUcalu8a5IqY9S7b/3ZLpsC
         zxdnZThGhDIAAFHWsh4+MKYe29qpI1f2aI31YYZLCSwJ0JMdurYXftQvy7CzpKkD3Xwk
         TKAIakM2Q1C4oR0yFtevUh5kMM5tpUwYtgFzoxvKm8fF8sPu1vhVSVGgWZkR8k71xQ5h
         gXsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784132030; x=1784736830;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NzrlbG1i1Z2grnBug4mVQe2iSrEhqBzyFP6w96GEH0Q=;
        b=KPj2cRgrqsBCxuN8Dt6JZ3iW6M1yY8vQkJ3BzaCkRQ4VDl9r3BeddYlQ30406YXOjk
         vPXJKZh+dt/NwIkMcgq/JPFMmLUv/QSrD/FyaL7yKuPp/zdZjwh5oukx994GJtwtURez
         tPolUvVJ8BWnMTPNz5aNeRbDEm+IJL6NnkyZ6jLwXKrL3wybbqVh9QGDF1kgKcXSswsv
         BYI4CW+oQbXW95zAA3im1kIYZH02Jv4ui0V121T1nJ4x1NUdmo7nbw4rCVjRzJjxcgms
         6Z9uwePeXgWu4OP8e1BbVi9CcIVQdsPNJlaUGczXrB6Paf6xr1dEJYDJSoFkwvZWGTYf
         eeuw==
X-Forwarded-Encrypted: i=1; AHgh+Ro8bNwk3w6J4gBCLdMjB6wNzVuS+24yGv7lNkkNsysvkIkftBF/pW8oR3SN94fOYHELgxs/hUKoMQ==@kvack.org
X-Gm-Message-State: AOJu0YyF8PoN4a5um2sGsWYwXUoPuZ2mbzFpip4i9OkdT9Bpe/9kAE0N
	SCqjS3gBQZwy34krYjdYcH6lH5K8cLudkKvfxjGOf/Lk4YhifjN/3+Fxn2lqh22IMYAKB0XOmAd
	aReyLyxL+K2TwuMn/X8d5l2M7bZ/9qFrWT31CKgXl
X-Gm-Gg: AfdE7cn+jupJ1kF+YanI0aShyE9FbVMr6cnRzMcEb0NL1jGlkwi4i0XQknUJsR0usnO
	hoN2O8X0EBJd4/8xL8Gw1UGnOE1zTUb+TezhDECszyNqx1dtyU8bY1kEI2M4yXjDpt912sxLgTL
	Mq+djoUcCe193ElBU0EX68LP59BDVnn2vKGux6X4qtj0Snf5VAyEJLbaATGT0hAZFhcS4JXOjDm
	BCXg3Ql35Bvbu5ypTZDtr56RAfJAiXrbClgJuEYjfUHQbwzndUPgm2arR3EauKe6tgqdh15II3T
	ZklHK8V4Gnw1eeKo2yJMHPEFCmE=
X-Received: by 2002:ac8:7fd6:0:b0:51c:523:9540 with SMTP id
 d75a77b69052e-51d7bd7292emr28840051cf.18.1784132029139; Wed, 15 Jul 2026
 09:13:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-2-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-2-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 09:13:36 -0700
X-Gm-Features: AUfX_mzWQymAiWtZQlBJB582QbB-RDSaqmDhzME45pNGf0-qJx6G_e02yGRYqOo
Message-ID: <CAJuCfpE1P=8RiSwm1FV2TCpM2FPo3A4VH5izpKR=J9F-_h5Y_Q@mail.gmail.com>
Subject: Re: [PATCH RFC 02/12] mm/slab: remove objs_per_slab()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: j93eqhf3dkuw9n9s7ihgngkxop8fgsz1
X-Rspamd-Queue-Id: 00138100010
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784132030-766493
X-HE-Meta: U2FsdGVkX18fd7887QKp6ibziPdKF1KZNpcj2X8evZpNB/HcIJ7IUVBe7D0GF3xxbGGqKbGQ/Z6T0PLTJFK74BTuAoOjHA+0CtLlCi1Kxt+3e3AB+Eq6pLTWEqc8oEvC89QcDbfJRdhuywoq9thT+Ed+CizAXEvnh+/8+cHIYi7kRcKkbpDDxdFr+bO0BLNLl5H3aR0rmNw3keVK/ZwFdCfRpMst/Q2P2MmT5MVcoFpkcz3t7puW6ZoQEtRA+ZLRCE43dlyLNPB0Z5jrfy7P0LeCvzoWvcCBcsjCAGWG7iLH7qJ9lPpiOjSQ8XfsP2Z/19Q46oLT6pRcG7TdDWXOtiP/EPUtZ5M5n6+TMH5KQ2XcIKF/NQWavHArr693qBbbNTtOkaUlcPRNhafyv/FJeNmUj3G5GShaXLLxYx5ky3FsRzvbtmdW8USM7atdSjNIAkmg9Y+8GxonGhQEUb0dyfWU6g8gbGCRJDDZDpbHfmZ9nL2m0ZzT4n94mAkcHUm/OFlJUk/Sv73ZKfsYmHLZVZmKE6ZclMURyJP1lz60BHL4xlWGPScwLeYM5mhY4m+md2b4ci77VDxEIKu53rlC6QB1zCxYPNB9AH8UqZ8Txu1zpA5Ud8rKyaBr+mr4bF4sS8vfV9Nz5IR2q8VtEDbrE/kM+kPHlgd2vA04lspE9iGNSppjLEaAuulr6cepzigJZ59T6+FRkYu8TxMPpiF9w6vV5PEOBo4V3AwCY4CeaCH1UqF0XpDDOZVCRBOxXoseqj94U4OKb9ntRafWJbKashR+vbckJwY6cvkeDrnmoD9Ih2hGfRACP/mPYDXc8B7Ai0dlNYuiu9vysWldHTmg9KUD3Z+lgwvhBrk/6qg0JYiDndkpGLbGpXcYcnDcYEWG2b2HKUBguneh9/T4eXZaYlYSuVbqaurPNUhNIjB8P4MgBa1XvuqeN6NTZaSMdALuVShG5me78quN80FSogs
 9+lnZ1jk
 f2ezbqDJ3rPIrUmO9fbDO3eSzKuIz44WjPSxIr4hRdGpoNMMz+mKMQ9jfHHw87IVGNrzHK32/bjnlnSOwwvje8zoB22S2Sum+z6uKAVj5IgPpaBTpp4KlrsAOvBw4tmPk5yYM1L8bncDaT/lQkWNqlocnKHbMvwFIY4uPG0HZvnhWFUF/+MA+9pkwJatUq7QJG9TVSw5rnaIHN8IWvR/1/zh304CcjCIG9TXsWxd31Kv3GSeD5rukl+pqMxKnyxFifFZi+m0AGV+JX5NPmTGFwE6AlBXoBRxQtw1Iuh+Geujrt+v7SiGjW9exsXq8tC9w+tad/eETn4570O4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 3:10=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> The function has an unused kmem_cache argument and almost nothing uses
> it anyway; doing slab->objects is simpler. Remove it with the last two
> users. KUNIT_EXPECT_EQ() needs a cast to avoid "error: =E2=80=98typeof=E2=
=80=99 applied
> to a bit-field" but we don't need to keep a wrapper just for that.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Reviewed-by: Suren Baghdasayan <surenb@google.com>

> ---
>  mm/kfence/kfence_test.c | 2 +-
>  mm/slab.h               | 6 ------
>  mm/slub.c               | 3 +--
>  3 files changed, 2 insertions(+), 9 deletions(-)
>
> diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
> index de2d0f7d62b1..9867c03ef0ae 100644
> --- a/mm/kfence/kfence_test.c
> +++ b/mm/kfence/kfence_test.c
> @@ -295,7 +295,7 @@ static void *test_alloc(struct kunit *test, size_t si=
ze, gfp_t gfp, enum allocat
>                          * memcg accounting works correctly.
>                          */
>                         KUNIT_EXPECT_EQ(test, obj_to_index(s, slab, alloc=
), 0U);
> -                       KUNIT_EXPECT_EQ(test, objs_per_slab(s, slab), 1);
> +                       KUNIT_EXPECT_EQ(test, ((unsigned int)slab->object=
s), 1);
>
>                         if (policy =3D=3D ALLOCATE_ANY)
>                                 return alloc;
> diff --git a/mm/slab.h b/mm/slab.h
> index f5e336b6b6b0..01535e1e2d3c 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -330,12 +330,6 @@ static inline unsigned int obj_to_index(const struct=
 kmem_cache *cache,
>         return __obj_to_index(cache, slab_address(slab), obj);
>  }
>
> -static inline int objs_per_slab(const struct kmem_cache *cache,
> -                               const struct slab *slab)
> -{
> -       return slab->objects;
> -}
> -
>  /*
>   * State of the slab allocator.
>   *
> diff --git a/mm/slub.c b/mm/slub.c
> index a4be70d080fb..9e25f2dce7a6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2127,7 +2127,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct k=
mem_cache *s,
>                         gfp_t gfp, unsigned int alloc_flags)
>  {
>         const bool allow_spin =3D alloc_flags_allow_spinning(alloc_flags)=
;
> -       unsigned int objects =3D objs_per_slab(s, slab);
>         bool new_slab =3D alloc_flags & SLAB_ALLOC_NEW_SLAB;
>         unsigned long new_exts;
>         unsigned long old_exts;
> @@ -2183,7 +2182,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct k=
mem_cache *s,
>  #endif
>  retry:
>         old_exts =3D READ_ONCE(slab->obj_exts);
> -       handle_failed_objexts_alloc(old_exts, vec, objects);
> +       handle_failed_objexts_alloc(old_exts, vec, slab->objects);
>
>         if (new_slab) {
>                 /*
>
> --
> 2.55.0
>

