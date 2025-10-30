Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A5D6CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 15:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66DFF28000D; Thu, 30 Oct 2025 11:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64576280003; Thu, 30 Oct 2025 11:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55AF328000D; Thu, 30 Oct 2025 11:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 43E33280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:59:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D41AC1601D0
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:59:29 +0000 (UTC)
X-FDA: 84055240458.06.F295E1F
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id CB7D9180004
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:59:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fMLPh+rC;
	spf=pass (imf16.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761839967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dtYLD87/tbnWpFhxZoXLkwutGQwHC9HiwVV2d797j9U=;
	b=LcWpg0Y4qXVWG+1OULYmhHsUocrmfvKitfWtVtLcCbhidtSUSXLpSn01a3zoehmv1jsTav
	hZmg4Ntbycc9rxw6YNwY3BT6xth/DD5iZTKswpyiMC69q+OX2tvXlZibFM6rDdgK5Sx4rd
	aQNjvQ9TwhNbD3HYvPoAfeLcjYu++S0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fMLPh+rC;
	spf=pass (imf16.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761839967; a=rsa-sha256;
	cv=none;
	b=t7nOGQutduqDNSGCDC2M5H+kssvGdswID/zjxsaucqWhqREBfm1p4dHqkB2stj428sGUTh
	QAtCOA77Rh2zYDk9ZB3rt6uDh0gAx1r6VOZwuAXhOSawo0dt6MGDlhEeOdBcRKFD55hxP/
	jHSxL7rnDpSmnwUPF0rGVntFnRofvIA=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b6d5b756284so314093166b.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761839966; x=1762444766; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dtYLD87/tbnWpFhxZoXLkwutGQwHC9HiwVV2d797j9U=;
        b=fMLPh+rCewM0kKCnmZS6GZUM8kG76NswqEGestFyuCZuMKa1JfzHBljb47T1wpqQMU
         m0UFs1vdYsFw3xyAlg3TNE86V3X4rUKpbcJaJj//vCb9m2Rgs7FOKToRdW0NLNCxk1rp
         TqhFR/Cj9yATCEkqlsV2h7ZkI5j9pG4DrBb0Kys8JlfS1amFvzbgXzTQpsmOXhEJkrU+
         FpnSlygL8aMjoGETj4MXAmTp+5Az8C8KGLXrjfuzu3H0LW7XJj+xagGeUKnl0XyBfNLh
         bToyf/Z44i9utab/McRHRV3zB1qkiG2Zi8tDqQdocIDvKRBb931FzfWPgPVE/A1THNx3
         YzGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761839966; x=1762444766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dtYLD87/tbnWpFhxZoXLkwutGQwHC9HiwVV2d797j9U=;
        b=GI/vcocad9w5QhQ4rw9cRv/PvnpYpYseS9PhaywGLTqIrh2rPh3JQg48MMLFZQ16SR
         kbuWgUA8iSEaImUihITRtX+fwYv6FQ5bEvjkSnxVjbecDgAbRLuGrjz6zVNS9HreIuxh
         cI6tbLJLdyNunPb8u1Sq7Wcu7ipfI/ihHeUSh448jBvMEnh6V74xI3GGe7HRz+GO3IR2
         QXPdBQgfM2ffBsDLiFzBsJKPRFSuXXAtOkVOWYsJxIva1uhfThKnUq6LdXXSQOkd5+9k
         LGeFR4lkA1XCQdaGtrDzdFqRJLscD7scQtascyz8mLwuTWwbA/c2jiwVH/IojyFXEpUp
         nPZw==
X-Forwarded-Encrypted: i=1; AJvYcCVTuzKA8MqU1y0c5vDNulzYe8/v8cYNBjR3amdohDoqd6PuPuxL4Pmde+AgBesMl6oR63fFc1j5aw==@kvack.org
X-Gm-Message-State: AOJu0YxFM9bKLvfxGc0XPcyH5Tc1x07+m6opYKV2bNT0fuOctKvdvnsc
	HvF+VSucugIUQ72eZrdkXDfTytaMx3ntwEFp0X0U3LKCv8JNbGnNU8+WpCqCFge1hWUr0BUI1jV
	0OEtAl8/VBc7LV6dYrsxDJJqxevotJTE=
X-Gm-Gg: ASbGncuSH/yXNDrpoo6fPlE3KN/ECC+wunCqHbAs/CmAsGm3KWhDGO14T+0rhTuki+2
	yHgoIbpyVyhNJfxxwW5Q+qysRPy5rbyVlnk/GCeOJIZlfevcIuoXltZGHsg4iwhIkFFOgpx/ZKl
	aJ01rE0CkumxCfe76y9SVm5QOs163niHbN9nJj53BkfWKxQGBxRBkufpymlt7SU/ghUvkoouQP9
	MXZv63W8Bk5KEpJgCiaMnP/mcFxQOFpas/QGFeQyaPuWJNh1iKbIoi6AQQXYeG5tDetP/+PM6DL
	RMLDWt0LbvY=
X-Google-Smtp-Source: AGHT+IGNEehD/IbzmT/eYnqMidws6XqejIuodVpG5l4cgolJSh8b964GFDYeXBLMdMY3NgBpsNfX2tZZfLZTiPrySFg=
X-Received: by 2002:a17:907:7f22:b0:b0c:b51b:81f6 with SMTP id
 a640c23a62f3a-b7053e45459mr371911866b.43.1761839965702; Thu, 30 Oct 2025
 08:59:25 -0700 (PDT)
MIME-Version: 1.0
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-10-6ffa2c9941c0@suse.cz> <aQLqZjjq1SPD3Fml@hyeyoo>
 <06241684-e056-40bd-88cc-0eb2d9d062bd@suse.cz> <CAADnVQ+K-gWm6KKzKZ0vVwfT2H1UXSoaD=eA1aRUHpA5MCLAvA@mail.gmail.com>
 <5e8e6e92-ba8f-4fee-bd01-39aacdd30dbe@suse.cz>
In-Reply-To: <5e8e6e92-ba8f-4fee-bd01-39aacdd30dbe@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 30 Oct 2025 08:59:14 -0700
X-Gm-Features: AWmQ_bkWAOmvQoKcQyr_zcqHDGMRrBlm9dDGveiPgB0Mj-QwDfGlE8jGMTlojF0
Message-ID: <CAADnVQJ_yzOGAT__EG=eBTHbWeiFgEZ--fHFQNprsX9o0vEQkA@mail.gmail.com>
Subject: Re: [PATCH RFC 10/19] slab: remove cpu (partial) slabs usage from
 allocation paths
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-rt-devel@lists.linux.dev, 
	bpf <bpf@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CB7D9180004
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: jcr761qg9mu4zc4e94zm3difrkof5eyw
X-HE-Tag: 1761839967-339837
X-HE-Meta: U2FsdGVkX18enQVyc1wZP+nckTuHrBgYwUEUML4iMpLxz//gMdCvH92w5aaGTIhyhAJtR0qPgWsgTbswCrCaEskEjDygwpQsJMLzevtPNi+XIEy2aRTXoQHrQeD7gmL/jT/wQ/CKtV/UZ6a9aVG3z4L4YtaGGS1nVXl8v6wiEm1vVyYDH2m13Ea+9XR3nN9kCBSg8YXU7tnPaFuPb0+bwHLHQtshksJ9oFUgeyXQ1HsTvLw3fn71dQgr3Juv03kW0w4LFGL6HPg601uZV43501j3Kz1EiVt2DyGJYDaPeccGH75OYGyoxIW4IRfCfcHQ7/hV8onUkrY0eeKpvch5zHlGRwtO9X7C69ZZY/ihim4LCv7AnROEPZO5EEtO06+ZjkRlg0G3S+lYrHwFf+MOHsE96+gk/QCBRc+cuTnAVQWTCyt6ds0a8FBate3/EBpUDsiGmm8T49jtp483vtYsRMgKU5enWhiQLkmdQoobxTbCRR5QhgdqbZ7qRo+wfbIeq78O/secP+Z+KkgX8EuADEcFVnWMIiGhtHlwtf4F81ylAKKG3WDk1/AzEWi2/9vywvlRfCyl4c2bxK+/1zVIAMK/s3TgHSoegzlphB5S/XO9PpcL2wkXz9lcfm2S5ivXOTDC1fe0vmvnZoBjVYcHwh41klWBLAMMMlE/fy/pZT4i7SmP4F9aQFA72k1vpEBMjGTIbYRu4BALLq4qm6+MO/isqu8B6TUkZyxwPcz4ORhmhsbsuZ6HdB8CkjJ/KF8gwDQOTe+J3rP2vqX25FjqP6prTH3AxtzaINUR9pJXrC8M9XJSdMCnWY1QBhWf/E5lRYhzqTcVw/85kqiBmDi7r4gWgITBrduTzLMbhE+TZbyft7flpiOcdT8AvDmLQRI4JO0O0jtkzHRBiqSVufEWxux4iAtpKvW7poY/1nVWNzc4ySTX9tnDhmbk1klyUDmUHz7GBOI9G2uYFcBr+P3
 AG1aDjyr
 c8Sp0x1QHUmEu2bVZz5O04agcCDwIevHUfpCERTsPHuh837/uD5ilQ2/ya2HxT69xjPXnYJDpmbVGdfbJYsjORk1qKdbtoPEGpiUh3ahCMeuy4/fUdwkavKJxc0zWrn9qNdV76mULXQHLz5Ns411oqzywpfqLcRr/4HmfSRum/bgiWO6MOUstCPVU/oy6r6845k3eq7fNiELf7ga0h42PvP2UmZbDfG1W6g/3uOxylEvLeymhb+K/OvFAadiTa3SD1hMgVDomPqLUKdxKIsmrBfRiimApndVhRNg8E/c8kAu4ajaY6wfv/hvLmPduUQwqGPZRrFk3Qm2V4TIR/TJb7D58hbGuunlHuuFXeHSfdFwKzT2OAWiri237UnSnF7RmSNackUtxciqKfhM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 8:35=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 10/30/25 16:27, Alexei Starovoitov wrote:
> > On Thu, Oct 30, 2025 at 6:09=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> >>
> >> On 10/30/25 05:32, Harry Yoo wrote:
> >> > On Thu, Oct 23, 2025 at 03:52:32PM +0200, Vlastimil Babka wrote:
> >> >> diff --git a/mm/slub.c b/mm/slub.c
> >> >> index e2b052657d11..bd67336e7c1f 100644
> >> >> --- a/mm/slub.c
> >> >> +++ b/mm/slub.c
> >> >> @@ -4790,66 +4509,15 @@ static void *___slab_alloc(struct kmem_cach=
e *s, gfp_t gfpflags, int node,
> >> >>
> >> >>      stat(s, ALLOC_SLAB);
> >> >>
> >> >> -    if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
> >> >> -            freelist =3D alloc_single_from_new_slab(s, slab, orig_=
size, gfpflags);
> >> >> -
> >> >> -            if (unlikely(!freelist))
> >> >> -                    goto new_objects;
> >> >> -
> >> >> -            if (s->flags & SLAB_STORE_USER)
> >> >> -                    set_track(s, freelist, TRACK_ALLOC, addr,
> >> >> -                              gfpflags & ~(__GFP_DIRECT_RECLAIM));
> >> >> -
> >> >> -            return freelist;
> >> >> -    }
> >> >> -
> >> >> -    /*
> >> >> -     * No other reference to the slab yet so we can
> >> >> -     * muck around with it freely without cmpxchg
> >> >> -     */
> >> >> -    freelist =3D slab->freelist;
> >> >> -    slab->freelist =3D NULL;
> >> >> -    slab->inuse =3D slab->objects;
> >> >> -    slab->frozen =3D 1;
> >> >> -
> >> >> -    inc_slabs_node(s, slab_nid(slab), slab->objects);
> >> >> +    freelist =3D alloc_single_from_new_slab(s, slab, orig_size, gf=
pflags);
> >> >>
> >> >> -    if (unlikely(!pfmemalloc_match(slab, gfpflags) && allow_spin))=
 {
> >> >> -            /*
> >> >> -             * For !pfmemalloc_match() case we don't load freelist=
 so that
> >> >> -             * we don't make further mismatched allocations easier=
.
> >> >> -             */
> >> >> -            deactivate_slab(s, slab, get_freepointer(s, freelist))=
;
> >> >> -            return freelist;
> >> >> -    }
> >> >> +    if (unlikely(!freelist))
> >> >> +            goto new_objects;
> >> >
> >> > We may end up in an endless loop in !allow_spin case?
> >> > (e.g., kmalloc_nolock() is called in NMI context and n->list_lock is
> >> > held in the process context on the same CPU)
> >> >
> >> > Allocate a new slab, but somebody is holding n->list_lock, so tryloc=
k fails,
> >> > free the slab, goto new_objects, and repeat.
> >>
> >> Ugh, yeah. However, AFAICS this possibility already exists prior to th=
is
> >> patch, only it's limited to SLUB_TINY/kmem_cache_debug(s). But we shou=
ld fix
> >> it in 6.18 then.
> >> How? Grab the single object and defer deactivation of the slab minus o=
ne
> >> object? Would work except for kmem_cache_debug(s) we open again a race=
 for
> >> inconsistency check failure, and we have to undo the simple slab freei=
ng fix
> >>  and handle the accounting issue differently again.
> >> Fail the allocation for the debug case to avoid the consistency check
> >> issues? Would it be acceptable for kmalloc_nolock() users?
> >
> > You mean something like:
> > diff --git a/mm/slub.c b/mm/slub.c
> > index a8fcc7e6f25a..e9a8b75f31d7 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -4658,8 +4658,11 @@ static void *___slab_alloc(struct kmem_cache
> > *s, gfp_t gfpflags, int node,
> >         if (kmem_cache_debug(s)) {
> >                 freelist =3D alloc_single_from_new_slab(s, slab,
> > orig_size, gfpflags);
> >
> > -               if (unlikely(!freelist))
> > +               if (unlikely(!freelist)) {
> > +                       if (!allow_spin)
> > +                               return NULL;
> >                         goto new_objects;
> > +               }
> >
> > or I misunderstood the issue?
>
> Yeah that would be the easiest solution, if you can accept the occasional
> allocation failures.

yeah. not worried about the slub debug case.
Let's reassess when sheav conversion is over.

