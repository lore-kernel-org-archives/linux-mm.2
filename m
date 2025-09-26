Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70ED8CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 15:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C90BD8E0013; Fri, 26 Sep 2025 11:36:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68CE8E0001; Fri, 26 Sep 2025 11:36:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5568E0013; Fri, 26 Sep 2025 11:36:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A7A968E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:36:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 53B818503E
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:36:26 +0000 (UTC)
X-FDA: 83931803172.22.6C8FCC9
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id 643E018000C
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:36:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JXbjeVAg;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758900984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZSv7jCMIO3/8aLO/JxtF9r3uIns87B1XPQ7ZuJUAZ8=;
	b=g/dpopnXNdyvWGPQidMhLvyrK+qxZKQi9aS0KPtGq1holnVDfLCBY9i984BvodRtxWpEeE
	TdGA9eyEJQD5KzpZ8ohhgZTZGsO3pUY0CDiaD+CBWKYYrNuz8RiVIcZQQLOSknq+UICw2h
	oTJDCgOBs2gsgZiYVnBBvCzzgak5Kxw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JXbjeVAg;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758900984; a=rsa-sha256;
	cv=none;
	b=dHXytlNv1YYUkLJBiTbn89bc3VgUvOmgIVNi0jfPN+EXFN5SiVZr12UhfW+FXCz7CqGQAb
	fjrdNmhkmOL570AJPozXSa1E/f30lOeOB6GrelArQUWXWgo6IOMu8PKiVDx7Ttf91cwqGb
	zHuHDu5J4H1aphfah0Cmfzy7KVBAqgw=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4de60f19a57so253711cf.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758900983; x=1759505783; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OZSv7jCMIO3/8aLO/JxtF9r3uIns87B1XPQ7ZuJUAZ8=;
        b=JXbjeVAgTQRMPQ6gw4f58I/SpMyPOp9c47dZPINoonFCaie9tqVxhgp8KU7kJqCyTS
         ZN7ri++L+pj1ChblafsDgfTrN+ogw+OPvdslNpm4prFZIRObdpzu23dqZLAyjS2/WaI2
         LdTadWAkVm/jlm7bfuk+iDPhBtWum3OGRxCSfrqHF5dpWKdC61yw4rgIfCvK6xXD7t8n
         WzwA7Y6mf8csE3QJFbtkLKNbrZpePIC+VXOi3fynZr20sNPLKmtAtswv8Qy3MnbdsQuR
         2jalLc+IjBIMN4/tIUSDstvEBiFQkvImb0iOJOYRxlOnlGiImoqFEI8xmJy5ZQpTyCtZ
         MIVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758900983; x=1759505783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OZSv7jCMIO3/8aLO/JxtF9r3uIns87B1XPQ7ZuJUAZ8=;
        b=bGldsm0A/O+q8Xe7dmC4fvkXBnmjkBLHlqP5MUoeAPqqrLxqFq2oLWS43ALGJqVmPs
         TixZ4EMnLCh+jfE+inf2OfI/ygEnnHIO999YqcVavYxJrEHvSNAJ+ZTPecI0TY4jXTpF
         89rqa3hA5e0Qu1nhovlWlCn+e2+Wj+7jsOKLvROCnXEgt39yzkXmFCPEyKS7pRaKNBgg
         sfT72KKG7/E5expP2zugv1nT8H/i0ovnh1/+ZKM4450VNRqHpwzI1SkmpxLVeH0vvKNN
         xjpO7YdWb87iWkAi/DBAv7nO10KcW1JQhUhgWIYXW5zdFVNesCqCVmVfDy6NfmcK+qGS
         s2pA==
X-Forwarded-Encrypted: i=1; AJvYcCUy+AsYZCaMJ4KGpM/ZTtG3/6FAqQaJ8PQrePsW5FmXZxmqZtpfuLQklSJVu+0vqi2pTK6uXYL24A==@kvack.org
X-Gm-Message-State: AOJu0YyA3J8pRX8mTe2PEh7+3TldB5FHkZH2IjNvfpwvily+oDVohAg7
	Bfx0pD5urbG7CE4iJdc4y6V4fLPLbnrzBfMghMq5G77CkM8nGMOO2AcKgtPRTGBAKzfWT1jVU4z
	zSmEBMjvIPG7cEMiObNBxwUdgFAYo5qxbQyEalKYi
X-Gm-Gg: ASbGnctvXImG+lL8r49r5b1wECQHjnmin1vfV7O8kfpsZktUuISfizfOl+7dnPvF4WS
	E3yWX2xBBlAykilUlJ7DU9V/lQTjDtQqYN31JiA59RyvCsFU2jTfxjeISNueEaDa/yXwLQ/TBV1
	w/ADL1rQni4scMYTbSIPA/lXVNmhPM3Tq5GdrJQRkIYJpA/wmg6uJLmq2ctAIYkFLMPk1g/gnHA
	DJUDTTF1vMvyunlnUi4Rqk=
X-Google-Smtp-Source: AGHT+IEI/jk3UcCkf9eM5O2gzijjqrX9cyj5UxKnCeRHeu/NPv0BxP2Itgt6Aa8b5z+x4oXG2jQMDdeupRKQ2GBDutE=
X-Received: by 2002:a05:622a:14c:b0:4b7:9b06:ca9f with SMTP id
 d75a77b69052e-4dd1675a20amr6239261cf.2.1758900982412; Fri, 26 Sep 2025
 08:36:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250926080659.741991-1-ranxiaokai627@163.com> <96d00a94-1a4b-4378-8d89-0554f89778e1@suse.cz>
In-Reply-To: <96d00a94-1a4b-4378-8d89-0554f89778e1@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 26 Sep 2025 08:36:11 -0700
X-Gm-Features: AS18NWDFkKvKtLcxfc1dJhlxjz81QX6DLo5WA6zWZ5CPFfbG2tUlSc1PeLBvbDE
Message-ID: <CAJuCfpHhOohLKDkVKiY11tHnuKLr1C=ffVqUY3BpV+30kDZjgQ@mail.gmail.com>
Subject: Re: [PATCH linux-next] alloc_tag: Fix boot failure due to NULL
 pointer dereference
To: Vlastimil Babka <vbabka@suse.cz>
Cc: ranxiaokai627@163.com, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com, 
	usamaarif642@gmail.com, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ran.xiaokai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 643E018000C
X-Stat-Signature: gzea8837grwepccfxqeq49r1pfcpchcb
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758900984-513485
X-HE-Meta: U2FsdGVkX19f6fIg2PnmHxkIvHWa83383SGI4hb3ej2XppYWL6j4CEVnoIrwPnBf6+CaHZFvwupqJ+V9b0OxsamruoPufwL9+jQK/5K5VsXDi2xVyjktjlygZg6oySip3MJcikzaLzZiivdofyUWUM7ZDcE9mh2XV00DMdDaywjZpXbMwiSir5jWjC66+yEx7gc4UX/zxt8fKHZN46yiTHDElVXX6LqSARYwfcCn0k10bl/AbFWu9rVfUalJlVT01W6X5B7xzyKoAWeaVjMw7CAaAFVBiiEYOkAzbZpdYgQGmKYFlbhlUGk7NldSTXQ/e7n9Y+dt17Gm2teRYogxLBEwe894+PQaTuXrreOeFDS7JbsnP34N5Dn1njdF+ZvhkmT3ubNkCMnU0SF/RUnphG30XyhKylcyPnnNcV1K6NYgCKbI+66E5crnguWrHUvDmDUFsAyELnOdHRhtC/KPKJnlJXRnxLPcaKnsQi126dOOCsSv9h88hQobnQQ4ouYOXYJp9oBZbDAgIAqEiTDINE99e2joS/Cn2vaKIzQsYX2vfeTYGJmWBiz81NnC5dZPC20fBaasPgtEIO4e0hHV5Pab9cX4orRTjzw2Hu4UtKchdzGHmUb0caoX9sQz295A4G3eyxEg0ZV+ATQEWUEMsDLLUqi6OxB69MckOiWe2ctZZUJA3w/p9YM9+Z8fS3G4YheGwboHGkpC4S9ji4sBublrltBZHQNHZV+gI/ib3y+4sdiU6ReDMGsFq2nBqweLNLlJeDJWepx8oUH67vdrwbW9KVWH6MfOnKjc1F8M9A3LxFyibPbZXkukWp+yFYKAmSOXMNGOaFqn6cfW+XV4C3qPa09s9G6Ys/dEgt6W5DppcHHSSLHa3BhpF95PhfGk0km7JJo8cjQr5/nVlL86+OPpyRfnBbXtD7UtSA3GLmuuAxfe27B3WmnboX/6thUEV1YrObUgu3E5vlb3FR0
 KP+J6w7g
 0I0hUH9zkiB9+B0hWbmkBL/1AJ65VEVDwTPUfMhDn5oxfW34qSW2hSrtjn0AZDBpbytVVJIGBbIFt1xMOQSy/KsbED38n0sPhLIE3HG5gXFNvYqRKc6C1OsP/zB2nqWZpacMZJ82N9LsRwqg1cL4PF087s7C8l8aX6OVf6VE13GljRrC41HJeLXfVGfpKyTD4bmbwx7yeunSnAEelQUvNmMf0UnVg6n4E/q5dG5CZFN5oJ+TTyozkoKZov2f1/rP/EXEOY+rG1le76kGUkcFk9E/YQPilUknSjvih1YVystLeEq8b69oileFabxyW+qxVIcXDxx2HT4zpHgD8bTeynwjLF48P84vpRNpe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 5:48=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 9/26/25 10:06, ranxiaokai627@163.com wrote:
> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >
> > There is a boot failure when both CONFIG_DEBUG_KMEMLEAK and
> > CONFIG_MEM_ALLOC_PROFILING are enabled.
> >
> > BUG: kernel NULL pointer dereference, address: 0000000000000000
> > RIP: 0010:__alloc_tagging_slab_alloc_hook+0x181/0x2f0
> > Call Trace:
> >  kmem_cache_alloc_noprof+0x1c8/0x5c0
> >  __alloc_object+0x2f/0x290
> >  __create_object+0x22/0x80
> >  kmemleak_init+0x122/0x190
> >  mm_core_init+0xb6/0x160
> >  start_kernel+0x39f/0x920
> >  x86_64_start_reservations+0x18/0x30
> >  x86_64_start_kernel+0x104/0x120
> >  common_startup_64+0x12c/0x138
> >
> > In kmemleak, mem_pool_alloc() directly calls kmem_cache_alloc_noprof(),
> > as a result, the alloc_tag structure associated with object_cache is no=
t
> > defined neither initialized. So current->alloc_tag is NULL,
> > leading to a null pointer dereference.
>
> Agree with Harry. This should be enough:
>
> "as a result, current->alloc_tag is NULL, leading to a null pointer
> dereference."

Yes, that's much more clear.

>
> > Move the checks for SLAB_NO_OBJ_EXT, SLAB_NOLEAKTRACE, and
> > __GFP_NO_OBJ_EXT to the parent function __alloc_tagging_slab_alloc_hook=
()
> > to fix this.
> >
> > Also this distinguishes the SLAB_NOLEAKTRACE case between the actual me=
mory
> > allocation failures case, make CODETAG_FLAG_INACCURATE more accurate.

Awsome!

>
> Good point.
>
> > Fixes: b9e2f58ffb84 ("alloc_tag: mark inaccurate allocation counters in=
 /proc/allocinfo output")
>
> That's in mm-stable so the fix should go there (probably too late to fold
> now) if it's to be in the merge window PR.
>
> > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks for the fix!

>
> > ---
> >  mm/slub.c | 18 +++++++++---------
> >  1 file changed, 9 insertions(+), 9 deletions(-)
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 867a07260acf..09cbe580842c 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2197,15 +2197,6 @@ prepare_slab_obj_exts_hook(struct kmem_cache *s,=
 gfp_t flags, void *p)
> >  {
> >       struct slab *slab;
> >
> > -     if (!p)
> > -             return NULL;
> > -
> > -     if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
> > -             return NULL;
> > -
> > -     if (flags & __GFP_NO_OBJ_EXT)
> > -             return NULL;
> > -
> >       slab =3D virt_to_slab(p);
> >       if (!slab_obj_exts(slab) &&
> >           alloc_slab_obj_exts(slab, s, flags, false)) {
> > @@ -2223,6 +2214,15 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cach=
e *s, void *object, gfp_t flags)
> >  {
> >       struct slabobj_ext *obj_exts;
> >
> > +     if (!object)
> > +             return;
> > +
> > +     if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
> > +             return;
> > +
> > +     if (flags & __GFP_NO_OBJ_EXT)
> > +             return;
> > +
> >       obj_exts =3D prepare_slab_obj_exts_hook(s, flags, object);
> >       /*
> >        * Currently obj_exts is used only for allocation profiling.
>

