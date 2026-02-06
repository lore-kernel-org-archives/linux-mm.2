Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4734FEE6B4C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 19:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89A196B0092; Fri,  6 Feb 2026 14:19:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8470F6B0096; Fri,  6 Feb 2026 14:19:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 746106B0099; Fri,  6 Feb 2026 14:19:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 63F076B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:19:16 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 025FA140311
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:19:15 +0000 (UTC)
X-FDA: 84414995112.13.628F766
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id E8F2340017
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:19:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U4R79BZR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770405554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fvh5DMP0qO3wt6PHVaJkcnU2bdJYis/SM/P7hxyNSCA=;
	b=50hKmhyjmlWYHstqroJ1xQS0dP3Gx1t11vpPEcYzGwuB1RkQ6rYhN8hJEVijtRRakDIdt5
	QjcQzRPblUQWjwGqWh+0sdcu52DmMuQ1fbdfspZfWwZVvcDU+9B/Z5aw7nVSdZr9RLTNTw
	xsme7k9F1GF3DHWUuVRURRnt3zzub8w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770405554; a=rsa-sha256;
	cv=pass;
	b=qjJ8qfxOWwvaJpTOOYu8UuefGY4RNk23cvtKBmGJVtEjhCERoG/ADQS23oxn1+9t9JQV/l
	cFYo3hS8a+fyJpATYc98oxZbAjyWlnhbdahjGacdMMFbmxsTPgW1/J4OhL13BS+U8Fydn5
	rzgTYqWIa6PRa2rGzYABRwWqezPdI6E=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U4R79BZR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42fb4eeb482so593429f8f.0
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 11:19:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770405552; cv=none;
        d=google.com; s=arc-20240605;
        b=cEzkgzWRG7vQFD7uiztzk/V+70MCL/hPuRJB5WUMqFLuwbJxXfvOzZLWa1+vAD+ERY
         kQ2hw75dKWpZwFfZYhRhTlyYzdNTPbpe4Wb4MFIbA6+4X0IGX3IUhsDT7Z+uQYKtM/id
         vfvFs46ujNSwKRT4nni5sEgTWoToB99GAt2zprLPqJmJ7UzQvYwMDMdUz/+xEvfAylwB
         sdxbWh2V0voR7SaojgFB5JOXEhe+t7aZpUOX/bPTlK4cjgFZEPlgUlRRFHU3YV2SQSEf
         fAfKScinnYDXFZqCV5XAek035A7yfdL251eSKDWb/2yFkOxnxEThIhV0u9BL/Y7pa1Vr
         ZmQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fvh5DMP0qO3wt6PHVaJkcnU2bdJYis/SM/P7hxyNSCA=;
        fh=Z8SC5e7UpjA5klCuuvqu/j54d2FKfI4k/sjzDlBdlo0=;
        b=NTj1m5TKdM8kUnaE7V1By5Qi+YZZ1c0S1PM0zR4n3QAbdCs/4hHyBJZFK9E44obKp2
         /ezJ56ojPSAOeJWlS7d3hE+lKnIKcYYwv7tkUkaeRegGQDebgW1/5VS9DwPrfY7Ke1DP
         Ujbwz1MSSRPTS9OJrD6tEXhOnOxKWEq1PDWnbaPlc23C2Y8dsLAeh0jrN2KVXwUEfouB
         Pcc8+jqpNa/L3HM1o+1DJFDbw0ucb3Tg0lugw8urQOMN+7bT/pVZBKIEpWqfH5HaZIvb
         Nj+Lo/HHgrUl6AzauiYodH1GiqRzhEJbiD76NS3H+Vnt+ueGJIdIPx9TDUWBeCNaktXl
         QIVA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770405552; x=1771010352; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fvh5DMP0qO3wt6PHVaJkcnU2bdJYis/SM/P7hxyNSCA=;
        b=U4R79BZRTLW+t46RJlHWCpoz//izhFm6j7RuQdceazebas/bAI7fO+aBuRl+TLE5Qw
         ZeYV4UWGcVYVWTRaOtYjk9JpXDqaW7iESdoacis0oc880XtBwYOex9HzOLHtd5XafRXL
         mKnaf4QSfUfUsHfE4LniN1uyHGZm5bdMQodz6ktjCt5UmU4+Ym/HzOZZMDgJqZrqlQxb
         V4Lysfeqoi+MMRimpFZt1t41fq6Ko19XYkmgZYPJfgrRcIfn8sb3hT1Y5w09J0dT/dQf
         mUnJbZklfoi6Pj94wIZQ/N9rmiheN0BymXEuYikncqHe5BRaGePRuQ9tAgqOz2sZutMX
         NObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770405552; x=1771010352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fvh5DMP0qO3wt6PHVaJkcnU2bdJYis/SM/P7hxyNSCA=;
        b=w8g1TynPJpfmY2g0L9ep6Vl2aKr1E446avSn4HAM9OfelNmw3bNl3gi3HmF2r7bALt
         6z/GRH7pLMT6LkVYrOd/6NtP5r/2gGVvp+nB4GpdxyrmKvjNFro2rQOHNxN0hQsncJhx
         02xaKQyOT5tI+b11dVa0RyUI1sCG9SDBhaplmPlugodfEVqgtfWxxoAxByr7QdE3V5TG
         gmd+Vw8cN3KYiUJJDx53oDtYRZSdYDlu1lL8W+U9dtERMw2g0q4979kFbZGAw53sEhYn
         f7RKMgVnUcQ3eZxlrGEARJX08uMEqdsirVTDuD2C50SpzpnBzLjlMyIKPDad5jL+baap
         fViQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjMCRemcWIJMOQIJ2b4cFLUCPbs3DFOpXSXPkba21orXZDBjiMoho2KkYRlNEkjXjhoBV/afy1ig==@kvack.org
X-Gm-Message-State: AOJu0YzjSxJFDG6ePgoD8dMzqlQxnL5pdzY//Y230ETAO2d/abhNBDuz
	623HQ5WxbwJpyhmSFZdD/E+YubRrbzuRCxN4BRo/J///2We80S57fca6GWwlISyijwamLv4uw12
	6oT8UIiKWJdnfvs9rYg4hHqVJOPMESvM=
X-Gm-Gg: AZuq6aLXOokDz7M22o+AyN4N/wPnrYHnprBGwZCuxmXz8pe/WX9elU4uZzCBMXwKpJ5
	iTXib296+md4ITkbfLutUBvrPAkSR/CezKr6N5Avr4pQVuacNO3eAxCHom8/ib+64C2xz09wVVe
	1KUIS/CJMpGPSwitowpJB2suMieS8mLNQQTkS9zqrUoKWEwhXQ8T+c/Ig0/5+Q9E9SoEE6g6XfY
	tTyBfEbGD35o0GllcpS28NnMZy6f4TQxtKSURtizX6A22zi4UPD3XAc+84teV/YmonO9+SX4Bpj
	pxtt4ceuSlo1TlgNKWbuWdC2w9G6rTTiFhpZ9UH9IndGz5HaZOlBjLePnl7zxa3rbGpDqe23oqd
	b3ikLoMTZytZz7eq2cOndYqKo
X-Received: by 2002:a05:6000:24c6:b0:430:f985:a7b2 with SMTP id
 ffacd0b85a97d-4362938a74bmr5832110f8f.51.1770405552209; Fri, 06 Feb 2026
 11:19:12 -0800 (PST)
MIME-Version: 1.0
References: <20260206171348.35886-1-harry.yoo@oracle.com> <20260206171348.35886-2-harry.yoo@oracle.com>
 <2ce1eac3-98fd-448f-8a73-01bb3cb5a7d5@suse.cz>
In-Reply-To: <2ce1eac3-98fd-448f-8a73-01bb3cb5a7d5@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 6 Feb 2026 11:19:01 -0800
X-Gm-Features: AZwV_QgOmEJlQPiQCkEAMnSvrww4GS3Jp7SWFouow-nGLlJkXss3_AON0w3rSVU
Message-ID: <CAADnVQ+1RBXBWNQtshEfFNZEp0tDZOFKf_vedyjgdz=wqWdG8A@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/slab: skip get_from_any_partial() if !allow_spin
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E8F2340017
X-Stat-Signature: kpbuzrzhyiy959bg31gj7xisgttxqnty
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770405553-640868
X-HE-Meta: U2FsdGVkX1/6Py9U53JVICssGX0E3QzEGgUSvR2j0WuaCUrJNVOoJF4vPPzr6VNZGZgTuOyzt2dQ7zZ/ROTGdPRyM46PI+BgtV90aTDGgXCoAgQnF5bzI9H75gMwTMH4a1K6HR643hiomM/UDbexj1oF+nAyDKUspmfVTjx43FYAGfc/P2r+/6lq4D6j9CeoTZCVTS78xnzm77Bpe9kWyIJBM8jpoG7M5oWfiA5yhPCTalfOOL84XoiErhAzeqiBMIwqBLV7dfIZTCda+ITCFqfj4NJLWeOxz/szvRaSmWy2+HGUwcasMfcv45SrY9WV/esFrUbFPpEJ7wp9xG/02HwWHO7tzT49LPocRoiB/YmdvKqhIDfY7H3Pv3iRJp211XUGEAiuzhUSnun8Dih5zfzsbZEbofEjp2NUpKoiGvCOADkQfTzzjln4o1XHoTnvOL2XdafVZ8zKA49DTijTJLmA1F2sBSB7y91lf7bO6MHwg1dPLNKNkKzYTYmoboEhLdvukhm8hEjf24U8SUEdCPleT5MvhF0SLE/+DAQgCSHAGDnBmhToDBlKoLokpXwuIJH9spruIIjrd1YCZq6irHFGtgs8YKgLl7NXWzo967rIO5rHu6rGpKjAOnFr4/u4raxKjFsAZ7ejXnC4H8p5k6bq6QlKOCjSuTYMSiUiw3AtwTzoFWDD4C2UrYlG45QX5+93mBg9j0L905Q5CGW0zmXVlBh46xrbKOty5024pVxileMHXIMAkSU3vEIEUcjBzHw93nDmg9AWVmOGle12cjCXcXS9szYClFbIQbu8K5u7m+iInXQoM0JBDQ9gXxvRbAxm3w0O3fwgP2AiRVuXu/wdqRhP/KfujCtFbG+LHWupp11eJ3QwIcXGMveQPGZ91wHP4gR6fYE/tzb42YnLLzWGoZlWX1mQdPnZ3HxJSVPMgYuh2leJ62Texux6RDvVF+Ufu2OMHbN9OJVrgB2
 JpcOxplA
 x44F7ilwUIdDWDTyt4u+ZOmcjQRhJImIxAhcgTnmmOe9pYjnMk7Fe0Go9fpRxL6sOMfA5wjk8XCI3Uyb+qk0RtLd7iulMhHOJFr3aNJJXSdS1DlbuT9UXKlL9Fh5VW0+cXQ2EPUxhwcPeTsM5RMGoar7bohwzgVdrUzFenIFNlwWKw9cPV5yE/sr7HeryxbgyIOXTBkJZ1VY82QutO5Y/nCzHxrPCUQq7RbOnWUuwSw4f03GtLhZPAD9rWiF/AIUReNjNxD3iU4N1fkCBRWVky7Wwiv+p/Mf7CPn1SKP1uodeK6pQ5gs2LIfDDubWXyLsO9e806fkebV46/g/aILJfDotJySo0I5LPvGtc4crtnNPh+OCythz/eqxRxKH+N8NQYfRS1+Cryshdu6bfwlSIDX9qaiIujdt9TP5LyT+64SrWPSi/+dkXxRQKQcVXNnkcSXzPSHRsh1JKLB2Nu4RIQrqXgGps7IPpt6tjSfa1H5Ad0AUsm6QFMlXFvZBd4zQUbWYQoG5MMIngJF8XtiUzyWiEKeso41YUSo56RmqvvNQ04UCKiLVqYffB4lGq5WjUZZE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 6, 2026 at 10:10=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 2/6/26 18:13, Harry Yoo wrote:
> > Lockdep complains when get_from_any_partial() is called in an NMI
> > context, because current->mems_allowed_seq is seqcount_spinlock_t and
> > not NMI-safe:
> >
> >   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >   WARNING: inconsistent lock state
> >   6.19.0-rc5-kfree-rcu+ #315 Tainted: G                 N
> >   --------------------------------
> >   inconsistent {INITIAL USE} -> {IN-NMI} usage.
> >   kunit_try_catch/9989 [HC1[1]:SC0[0]:HE0:SE1] takes:
> >   ffff889085799820 (&____s->seqcount#3){.-.-}-{0:0}, at: ___slab_alloc+=
0x58f/0xc00
> >   {INITIAL USE} state was registered at:
> >     lock_acquire+0x185/0x320
> >     kernel_init_freeable+0x391/0x1150
> >     kernel_init+0x1f/0x220
> >     ret_from_fork+0x736/0x8f0
> >     ret_from_fork_asm+0x1a/0x30
> >   irq event stamp: 56
> >   hardirqs last  enabled at (55): [<ffffffff850a68d7>] _raw_spin_unlock=
_irq+0x27/0x70
> >   hardirqs last disabled at (56): [<ffffffff850858ca>] __schedule+0x2a8=
a/0x6630
> >   softirqs last  enabled at (0): [<ffffffff81536711>] copy_process+0x1d=
c1/0x6a10
> >   softirqs last disabled at (0): [<0000000000000000>] 0x0
> >
> >   other info that might help us debug this:
> >    Possible unsafe locking scenario:
> >
> >          CPU0
> >          ----
> >     lock(&____s->seqcount#3);
> >     <Interrupt>
> >       lock(&____s->seqcount#3);
> >
> >    *** DEADLOCK ***
> >
> > According to Documentation/locking/seqlock.rst, seqcount_t is not
> > NMI-safe and seqcount_latch_t should be used when read path can interru=
pt
> > the write-side critical section. In this case, return NULL and fall bac=
k
> > to slab allocation if !allow_spin.
> >
> > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock=
().")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > ---
> >  mm/slub.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 102fb47ae013..d46464654c15 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -3789,6 +3789,14 @@ static void *get_from_any_partial(struct kmem_ca=
che *s, struct partial_context *
> >       enum zone_type highest_zoneidx =3D gfp_zone(pc->flags);
> >       unsigned int cpuset_mems_cookie;
> >
> > +     /*
> > +      * read_mems_allow_begin() accesses current->mems_allowed_seq,
> > +      * a seqcount_spinlock_t that is not NMI-safe. Skip allocation
> > +      * when GFP flags indicate spinning is not allowed.
> > +      */
> > +     if (!gfpflags_allow_spinning(pc->flags))
> > +             return NULL;
>
> I think it would be less restrictive to just continue, but skip the
> read_mems_allowed_retry() part in the do-while loop, so just make it one
> iteration for !allow_spin. If lockdep doesn't like even the
> read_mems_allowed_begin() (not clear to me), skip it too?

+1
Just unconditional return NULL seems too restrictive.

