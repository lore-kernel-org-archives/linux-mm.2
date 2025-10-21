Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5997FCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 13:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54F018E0014; Tue, 21 Oct 2025 09:25:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 526FE8E0009; Tue, 21 Oct 2025 09:25:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4635C8E0014; Tue, 21 Oct 2025 09:25:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 35BAC8E0009
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:25:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D23F1B9BAB
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:25:10 +0000 (UTC)
X-FDA: 84022192380.28.A8F13A0
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id E458A40010
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:25:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qIDN6tgE;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.166.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761053109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AN91pXwgqIQMxfVu6MiKIAGYOkS4a8BITP1vquLMZVQ=;
	b=67cBXmvvvhtB5pVu1oc1FmGLlEl6Bkeh8lJpKvS4clCKGaxlomCMP31Kpu4rxH11vBC/9T
	4m9nRegfbvi6Q4tKKoNbliC9UjFB9zJH4xlJiU2XmMCO175dnCxQpmgoZWsJjEWoOQIdZC
	oOJmkHFIwQKkGeN5y3De0PpTiypqUUM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qIDN6tgE;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.166.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761053109; a=rsa-sha256;
	cv=none;
	b=nL0eFKWTG6KA/0/lb9JmxN7QlTIBTCzE6S2/9kBFElkA0QYmbgldNPgwefwBwv+XcD8d0y
	fi1FACUOlPCQLV7cC6WlS5jgDLiSdyc3sHjvbV+tKoeWulFZV6MxcuS+IDgR2t30/7Bcy8
	HiHTIa46TRSiHSfmGevbTSSWqtFqduE=
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-430e5d5ca8aso408175ab.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761053108; x=1761657908; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AN91pXwgqIQMxfVu6MiKIAGYOkS4a8BITP1vquLMZVQ=;
        b=qIDN6tgEPUY5vLDLXgT1blm0HgzLMk2b7bo2g2LwGsr87bpcTJYXiPbkL1ErTpOy1E
         P6pQFt+ayfvtlT/vIDLCxK1kZpffVE5pSfLGsSjeGddDJmNLT5LGgDYN7vnb6aGG7/sQ
         r7hcmzbbOIYz+VUG3XD7561FDErwbdF5U6wWpD7O/fqxztALhMPhjATOYJywCfIvNUOG
         POubqRoaUnO7dV3cD6AcIygVb66nHtU8l7SVnvpcN0fb5Mi0Z+R11ezslf1tw+WAzh5G
         XoY0YQ4lvnmah2xsn3KdD7Rt8TReKc4ctUfT60tmsAbVyxC5Gw+EgNUkBTwDSeGKs/RC
         DrPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761053108; x=1761657908;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AN91pXwgqIQMxfVu6MiKIAGYOkS4a8BITP1vquLMZVQ=;
        b=ZUMQ9dF2ct89Izpk032qiGqSxzPs5bp93+fNRCINFI14tMw+NcDokAxf27DzzgrQ6K
         ar4AhwPZXHOCjPFuTRjhnAE1YtjVjXK7pTiCWvDDgUYTXrJxUkPE5AmA8R7by3xcfAul
         xAyyEnMZJswXK3yE57RsLj4ZupiY13W/jbR7w/TCHa/HSX32dOjXPCTchDZFTrPFgh1+
         +SEvsKJd2r1rYTrVoq5S8y8E2pzRLRGhIqPpCXzp5x2JhWCrXg1BA6L1Wa0cus/CrW0b
         LLZmIUb7ic0oou1gjUtm9WgY5LQEmRCRns4Z4k62wQOyYbJ/YfryG9Pl0Ekfw/AoIZG9
         fSVw==
X-Forwarded-Encrypted: i=1; AJvYcCUpUPTYVFUdUegc7KAFPmnePRBwmcgKd+w4SN+/qJ/xuDcxLVZrkKC66wHIhnlvb5aLjXVl8nJqHg==@kvack.org
X-Gm-Message-State: AOJu0YxhNiY4Ck5SdT9B8aoJgOffvnvX8Gf3Qw7qVL+A1YWbQZL3gFdS
	SNHL5BNwtdcTRPuShg0n1YLYsfB0/OGaFe9hqsXEU/5B1dARM3ynue2RyrqmLQ1rDfYHqUstzP9
	htgWh1+N+TFvZ5h9Hy/SwEpKTIQvizCBNNvLofUKD
X-Gm-Gg: ASbGnct0C6RyZy6qBkpasrNRndMnjhZXaDhD7urPUJ1iI09YV7Npcm5sRGj9qGpx28w
	Y19Mrfij3sPqScz+iNUrZ0rKvOjDd04utT4Z/Qzid+9HPGcta11kYIJOV0uXMEH1DbZcweqDxki
	MhVg0ccQ1mgF+89kxWlvVfa25QNfYVoTcx79+KGiTGVO+aZdP44jHcHdyHcWmBZ/wbKBKQoV95o
	ymP77oLiOClkqtsZQI+6IN50v2XAGVaMsxUHrcMOvZoq+xpII0HLMFy1KTvIhDU6Cel9xM=
X-Google-Smtp-Source: AGHT+IEY3/tL9248AlNmzuOMolz/CQv5WsxYicH+FzqLOvMDH2FmXvH2tkQitr3keOXC46BpA4ai0otA6bymkuK1obw=
X-Received: by 2002:ac8:5c90:0:b0:4b5:d6bb:f29b with SMTP id
 d75a77b69052e-4ea11f78f5bmr1896601cf.8.1761053107372; Tue, 21 Oct 2025
 06:25:07 -0700 (PDT)
MIME-Version: 1.0
References: <20251021010353.1187193-1-hao.ge@linux.dev> <1e1376fd-1d38-4dde-918a-d4e937d4feac@suse.cz>
In-Reply-To: <1e1376fd-1d38-4dde-918a-d4e937d4feac@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 21 Oct 2025 06:24:53 -0700
X-Gm-Features: AS18NWBq-WflSIhn0eZIg3ZJV7hVJZWkIF7eJkNyEtLKL0lBLjGKZ_AOqjdE04E
Message-ID: <CAJuCfpFto6=Z0kPdjNP6WeOYUB0uMKom9+HFg+ugA=ZjsNhewA@mail.gmail.com>
Subject: Re: [PATCH v3] slab: Avoid race on slab->obj_exts in alloc_slab_obj_exts
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hao Ge <hao.ge@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hao Ge <gehao@kylinos.cn>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: a7fxtr6gq57sgosx4ceus4pz4h8p34gi
X-Rspamd-Queue-Id: E458A40010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761053108-32113
X-HE-Meta: U2FsdGVkX1/VU0xkUInadiNQKdekqghk2riHbmItLFafDcFWxQOgHtxm/4fEq221iMa/DLRs3Rop+OV8j75XOCiIWNSbvfnDCShvwHKVNLUArqEbCASwlxDRiETIPOXpkHwmvkk4neBv6hhsAeuDmW7OlMNwRo7CfS1gdztlKx6SCnXRB4q+S9Y8Gj9g48boyTiLO2SkCYGYo/wouUR+2nPC1cw7SLqDhlurfGe1HHnpUhJYYg5mYFIKehX691LXpqbpmQK4Bingrcs/GKPORkoi1HgEr1meOyLb0hvpM+ipKffwQ2R0Ip1NPqeOgZYtr4PuVK0xntZLgHbwgdwn930xSwodonn3ARBT3YKEfrZcX68oVoTFnyJWbNqTbLJ2O67AyQeV8n3eXEmHLNXXb14pPt+RFDd4Z56YgDFZ+EAL+/Tp/seL0oHf6/DDTHV0NqdB4paZPXgZOB7u7fdIxp64JYIM3s4o6l3XVNyMg/VcQT1JEQu2HmYggi4PBdCw3qWUX2PzoJfSgcXDIiQKsDVfIXmwB3Zp6iQ9uCwNzl9RYQk4A48dlyo1UNluAk2brve3e+XrC3FkptviqWSndY+CqB8FeiGQYh0Te6s3qil7sqpqa+67OJStVBwnutGcPJkgEgywG4ZzGYD/dUjnXw459cueCGfBEmSWJA2SKuxwwcGa7Ehw/pXjMltcDnezozQ0e2RueU9oafz2QrByDzujGDy1hyKwUy45rk1aSg5dDp9t11AWImCV72bYWeTo3zjrQN9tOr6CqiL04PqE5IOJkFu0U0GdNmFS0POICV/9czt8waBV3djp94GvIFpMjFIWrC+BHCIq/Tkn4rmtC+HbO1JO8i317ik81Ahqu+btQUYO8BHGwr5recEcvzidcYRJaaMY43itpIs4BWPcqDTfATkLf3MiTQqqgY21swqZ2bjo2d0a8f861cKy2MIwARspMJBjkfZFsuQc8MR
 r6PIIy7r
 YSstX5rx5acCaI7nKE8PGTerpLRkbikVvWmaGR/uVVwBiqfbFvoH4MsVEvuMJhnFO8dED/2SfRWEAonosr3tOumlCdY279pTN3vr/yEIi22dLoGwxTWTLO28zaY2VG6DlMaFMqt8o3kXfG/7B3MYQJ692BJ/0l7ui9/ueMAS61TAhoTJcZZwFDaAaQx/shF4TK3fh2rVjoPjBUv/JxUtgDXmqyj6b5ob+jESmJsWBFmqaLw8qybHaDM3OfOrbNsq4aSokRnCoY2cPepi7zFH+3sMSD8YeDSpnNuEE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 12:04=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> On 10/21/25 03:03, Hao Ge wrote:
> > From: Hao Ge <gehao@kylinos.cn>
> >
> > If two competing threads enter alloc_slab_obj_exts() and one of them
> > fails to allocate the object extension vector, it might override the
> > valid slab->obj_exts allocated by the other thread with
> > OBJEXTS_ALLOC_FAIL. This will cause the thread that lost this race and
> > expects a valid pointer to dereference a NULL pointer later on.
> >
> > Update slab->obj_exts atomically using cmpxchg() to avoid
> > slab->obj_exts overrides by racing threads.
> >
> > Thanks for Vlastimil and Suren's help with debugging.
> >
> > Fixes: f7381b911640 ("slab: mark slab->obj_exts allocation failures unc=
onditionally")
> > Cc: <stable@vger.kernel.org>
> > Suggested-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Hao Ge <gehao@kylinos.cn>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks for the fix, Hao!

>
> Added to slab/for-next-fixes, thanks!
>
> > ---
> > v3: According to Suren's suggestion, simplify the commit message and th=
e code comments.
> >     Thanks for Suren.
> >
> > v2: Incorporate handling for the scenario where, if mark_failed_objexts=
_alloc wins the race,
> >     the other process (that previously succeeded in allocation) will lo=
se the race, based on Suren's suggestion.
> >     Add Suggested-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  mm/slub.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 2e4340c75be2..d4403341c9df 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2054,7 +2054,7 @@ static inline void mark_objexts_empty(struct slab=
obj_ext *obj_exts)
> >
> >  static inline void mark_failed_objexts_alloc(struct slab *slab)
> >  {
> > -     slab->obj_exts =3D OBJEXTS_ALLOC_FAIL;
> > +     cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
> >  }
> >
> >  static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
> > @@ -2136,6 +2136,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct=
 kmem_cache *s,
> >  #ifdef CONFIG_MEMCG
> >       new_exts |=3D MEMCG_DATA_OBJEXTS;
> >  #endif
> > +retry:
> >       old_exts =3D READ_ONCE(slab->obj_exts);
> >       handle_failed_objexts_alloc(old_exts, vec, objects);
> >       if (new_slab) {
> > @@ -2145,8 +2146,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct=
 kmem_cache *s,
> >                * be simply assigned.
> >                */
> >               slab->obj_exts =3D new_exts;
> > -     } else if ((old_exts & ~OBJEXTS_FLAGS_MASK) ||
> > -                cmpxchg(&slab->obj_exts, old_exts, new_exts) !=3D old_=
exts) {
> > +     } else if (old_exts & ~OBJEXTS_FLAGS_MASK) {
> >               /*
> >                * If the slab is already in use, somebody can allocate a=
nd
> >                * assign slabobj_exts in parallel. In this case the exis=
ting
> > @@ -2158,6 +2158,9 @@ int alloc_slab_obj_exts(struct slab *slab, struct=
 kmem_cache *s,
> >               else
> >                       kfree(vec);
> >               return 0;
> > +     } else if (cmpxchg(&slab->obj_exts, old_exts, new_exts) !=3D old_=
exts) {
> > +             /* Retry if a racing thread changed slab->obj_exts from u=
nder us. */
> > +             goto retry;
> >       }
> >
> >       if (allow_spin)
>

