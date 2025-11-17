Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B78C6CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 19:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2548E0011; Mon, 17 Nov 2025 14:50:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E89FC8E0002; Mon, 17 Nov 2025 14:50:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC7348E0011; Mon, 17 Nov 2025 14:50:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC7F28E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:50:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7060913A3EA
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:50:22 +0000 (UTC)
X-FDA: 84121140684.01.9EC911B
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7DADAA0004
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:50:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GVvTtMaR;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763409020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1hTgdTaDhLFOmNrm+p67cEssjl2r7sbc2JFHhbdzkAM=;
	b=PfbE3Z+TMu7JV0d6M4kzDtS7OQjGGimzMimGYQAT/jRoUeKwvi7GCU79sK904ajM4gLsQA
	TkkmVA9XOCllnXar/HHnOOQUaOhEpC7WPH4TKvO+VrnrArStE7JsidxzzrHyn+pNreacLq
	vKUWnxGbO2G/aJYu/Cht+pJdqlszAGU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GVvTtMaR;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763409020; a=rsa-sha256;
	cv=none;
	b=7PALvKic95TjQFoDadju2jRaHpJ3H8XJ1zzPeBG8dEpUVr/yiaE2dAhE/1yE6aEXufy1oT
	35XAzyrqY1OmCo/GlzzI7Xk2CkIPgFtDaKXSCTatzeYhHSLMhZ7G08b+keWdDhxoJfIGwY
	OSvHzTOWSrCvv+dLDnm8PyiU4QBOmJY=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ee243b98caso36051cf.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763409019; x=1764013819; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1hTgdTaDhLFOmNrm+p67cEssjl2r7sbc2JFHhbdzkAM=;
        b=GVvTtMaRN4N4TioFDuXBM2nQ2QQC0Qf/lDqn85yNa3pFLBsAFYS3uejcv3HojVWAmd
         pff/AkG89Iwe+P/4DNobQ2l9Qf+MeTg+CX+zLU6ZeyxCZJBJniwbUgYlxLtdFOrBDTnK
         ZUxZvHxAvK1HjrrBPyzlfapmWTjCk0vlB+QhB5DhnY9phv/b40ms9PVQamR4Hi6/eLFN
         ZYiLvldSEUS0ezYJ6PzdPVuB3o4LFd9VtwOwlq0qemjIQUYFUbkTxxuyByFpTbNm26wp
         aqzEokkXl7Ar4JC20ZalYevSYCfuqn8lybJrZTPEkvBfLtokWX9rkWwA+r4hqRdrLbsb
         lU+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763409019; x=1764013819;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1hTgdTaDhLFOmNrm+p67cEssjl2r7sbc2JFHhbdzkAM=;
        b=cH+i4wFUl92T6sxsztXSJfS9WB/KR33rL1HupzRYr7KdPv+e4WRPsDlGVvkXBI+Z9/
         MzoMWNxS2sPGMjvpBi/mjPGqwLeMLu0NkMg49w07VgYaUFJJKhuYuVssbRgE6KQlTa/a
         4KlLdNVDuZwR/eTP5VxYH6P9Pz4TXgVa+pSYd7Kv+DTXzm+b8GSHMthT1XJ8u885RJZ0
         g1OGQYpTOk9YEDAyP4YLMJqaV/7BtkWLAZ5ExXAYnMsYWVVltl5sxQT9iRwbkVJMDRaQ
         FjmzHFL1Mgl/WDWpECZGDEACYzM+NRtMgANtBLN730WbUp0W+4HQViP0GSDw+n3EGF24
         kukA==
X-Forwarded-Encrypted: i=1; AJvYcCW+FvIViSV6rpGZlxhnM1pDRY+nY2FutlrinmNmXsfHaC6pFeQhmTyBZIkGNmix3GfzYjvoJdFVSA==@kvack.org
X-Gm-Message-State: AOJu0Yz4xo3Qs0eBd/j9awC1T1By8yY6evH5nW9/bhmhUh8JuGX48zDY
	PchZaxaN5tMtLTA2dwWpSDjFzibaQzzaM7zg2uGqI7qvZ6z66/tXR6uIwjSG6Xzpz/aOMUfzfQn
	PRko1K3JuwQjIVI/jXRFrU0pE9LeeDQXQNVFkx6pp
X-Gm-Gg: ASbGncsezqOjorcnMMP29TORxKKSL6Z3esmMsYBMSJilssDooh9fIWJJm/VtPMosfMS
	wQWvIk3xDttu59OnyGgJH+BkYHRcLOnoRKo7PKTBMzX4GtnSghEY1j13PJ+iFvgI1r5tLB1QDaP
	SQ0A9H6xJp7N5v44AjC52UPt1Qpv6W06xJcnkkP/xlAWhiavDfN7BARfE5HKwthR2S6Kp1Xt9kp
	WwZotk4J3cYw88AIoF88x0bSO2bXqSqwadbZiAxgLJyjZd1vlSY18G1JJr0haOi/otalQ==
X-Google-Smtp-Source: AGHT+IEpcZdkbY0iv/59qsGX/IxxcUW8GzwD9ZbhmBR9VzSdCtYhXOz8YNBOnVxd765+8oqFNtwZvtZ/Ztbhs6GOdZ4=
X-Received: by 2002:a05:622a:1aaa:b0:4ed:ff77:1a86 with SMTP id
 d75a77b69052e-4ee317ac6b3mr553271cf.18.1763409019256; Mon, 17 Nov 2025
 11:50:19 -0800 (PST)
MIME-Version: 1.0
References: <20251110203204.1454057-1-willy@infradead.org> <20251110203204.1454057-2-willy@infradead.org>
 <894ad5d2-034f-46e0-96fb-135c847e4019@lucifer.local> <aRXt9JXI3rW1kP3k@casper.infradead.org>
In-Reply-To: <aRXt9JXI3rW1kP3k@casper.infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 17 Nov 2025 11:50:06 -0800
X-Gm-Features: AWmQ_bmyW7ezt5xyvYPoUDTogLv2Cq2ZkadtjcQWWMh1MyIUU_z7hiOhpq3_sHw
Message-ID: <CAJuCfpG32mQT45KqEkO=5TNecES9M6AccPLw-Ju=N2cbto++=Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm: Add vma_start_write_killable()
To: Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, Chris Li <chriscli@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7DADAA0004
X-Stat-Signature: 8s986abpnauh5wumnt6rd5ygsobn6mht
X-Rspam-User: 
X-HE-Tag: 1763409020-61018
X-HE-Meta: U2FsdGVkX1/T90hYSPMrcjeitSY/Yoo5pHEAs+Hd+1Td7RNV1jID9P5vMTMMVuwV2u1+nxlO4eAKMJGfOaA1odyAjG5zu9d84TpkncnG6HLpK6tZUJ+Sd3SLXe8jKvWuuJVpOLjQpEO4seNSDd69EYAtL1JGtUJNHbkGtLRYD63OUH2loBqQBg0oSiQ4Au4KAdPf4F9e7ls30yIXaL0Xq+DoZSQZhX3qqFXnSrQlRw60O88Z0kYjooR+hJPC06cXUcZTg/2Bg44hOw3CIyEHn+RmB6nVjH4rLP+Bh/fqhoGAbwkRYGByDCUDU5bet26+RxxZ3e3YhysEGJm05A936Woga866xieHjWXn//OhUTvFtQz6L8xy9+e5BfjJaQdol99X+YXek/OYe3mmNSGBOf5DHvE7UIBsD0DybVjjoLR4iAY5gux+PQqzkbe7QA7nzpenl+NgKg7EiOU/J0cvEtmm+tRB6rQUxunx6uTCWls+qNFBwyaCV1s61VDQtoXM9vnFLv7uoxbokm/K241wKVrRo2k7QXpUfofl+ApKqcYMw5nCU1e760XK8BIfXqqwdXymbQRl9pBm4sKpY6da12cE4AVFxWqCddAzcIH1Nm622QT/3V0KmaHOEiW1QP7H6C+MPLtcr0TvftYsQShPGDzQML0wAcspZUkiWfv0BozJQmaOiHkaYmoX7ZCc2U9OMMSKUKYX15+b4QOjcRYCzpEunfzrjlPLjh5iYW2oiLiBX4Q2aPUlaLxQshGWJN14sL51Iluql/5OZ2DQ+C8xLQH5MjifUwYZ9e7XeXG6LTq/mRzHX4d2uLYNSfv8HowLm7jHOvrWlEsdfhJzQ9hHWmPgTZolYH+wWw8sW4ges2hX2Lg+sROeM8/N9h1NaF8G3K5iVMZfH6P29XIeC159TxHrmEOXQ3xiXPR1YP8sbE3xrOyofJlbBjr7wrzHZSB+17W2ENhPZUq1PtzLjFs
 FA/OqdGC
 sazZXj/bBvI2+fsERqWQABeen7LhcKfS4NthucDntW9vOaK7nnHQexTcV25hipF3qXaA2cmReUkJISDSJyFujJNZEETUDDjyh0cPFFqJOnFqAREinX6eUVYgcIjtG5IdhkuJb78xoBF6RsemERuQjo+k3ZWuzHH122hcRqphzGbW8YdBfEoAkcWlOdWqaDS1Lwc6NcS9hwT3RHGAWSd6AUe8w0RxqWmvhh5lIHCJkrwBZe1WkJKk/YPoqi02q1OiDeqHhue2JTTHPoWhVuQjiixWylQkyS5UkcX7qH4anKxFiS3E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 6:40=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Thu, Nov 13, 2025 at 01:20:14PM +0000, Lorenzo Stoakes wrote:
> > > +/**
> > > + * vma_start_write_killable - Begin writing to a VMA.
> > > + * @vma: The VMA we are going to modify.
> > > + *
> > > + * Exclude concurrent readers under the per-VMA lock until the curre=
ntly
> > > + * write-locked mmap_lock is dropped or downgraded.
> > > + *
> > > + * Context: May sleep while waiting for readers to drop the vma read=
 lock.
> > > + * Caller must already hold the mmap_lock for write.
> > > + *
> > > + * Return: 0 for a successful acquisition.  -EINTR if a fatal signal=
 was
> > > + * received.
> > > + */
> >
> > Not relevant to this series but probably we should write kdoc's for all=
 of
> > these...
>
> Yes.  I was mildly miffed that I couldn't crib from an existing one ;-)
> Definitely worth a followup patch at some point to add kdoc for all of
> them.
>
> > > +static inline __must_check
> > > +int vma_start_write_killable(struct vm_area_struct *vma)
> > > +{
> > > +   unsigned int mm_lock_seq;
> > > +
> >
> > Wonder if an mmap write lock assert is appropriate here. But we can def=
er
> > that as we don't do that with vma_start_write() either...
>
> Seems like a reasonable addition in a later patch.  As you say, it
> wasn't there in vma_start_write(), so I didn't like to add it.
>
> > > +int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lo=
ck_seq,
> > > +           int state)
> > >  {
> > > -   bool locked;
> > > +   int locked;
> > >
> > >     /*
> > >      * __vma_enter_locked() returns false immediately if the vma is n=
ot
> > >      * attached, otherwise it waits until refcnt is indicating that v=
ma
> > >      * is attached with no readers.
> >
> > This comment seems to need updating?
>
> Honestly, I'd rather remove it.  It's weird to document what the
> function you're calling does.  If there's anything worth saving,
> put it in the comment before __vma_enter_locked().

Either removing or moving it above __vma_enter_locked() sounds good to me.

>
> > >      */
> > > -   locked =3D __vma_enter_locked(vma, false);
> > > +   locked =3D __vma_enter_locked(vma, false, state);
> >
> > NIT, but while we're here maybe we could make this:
> >
> >       locked =3D __vma_enter_locked(vma, /*detaching=3D*/false, state);
>
> Ah yes, the canonical 'don't pass bool arguments to functions' problem.
> #define VMA_DETACHING           true
> #define VMA_NOT_DETACHING       false
>
> > > @@ -118,7 +134,7 @@ void vma_mark_detached(struct vm_area_struct *vma=
)
> > >      */
> > >     if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
> > >             /* Wait until vma is detached with no readers. */
> > > -           if (__vma_enter_locked(vma, true)) {
> > > +           if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) =
{
> >
> > No issues with us waiting uninterruptibly here?
> >
> > I guess rare condition and we require this to happen so makes sense.
>
> I'd defer to you on that analysis.  If we want to add a
> vma_mark_detached_killable(), we can do that.  If we want to make all
> callers of vma_mark_detached() check its return value, we can do that
> too (see earlier patch attempts you were cc'd on off-list).  It really
> requires someone to do the analysis of whether it's worthwhile.

I analyzed this when Matthew proposed his first patch and I think
waiting here uninterruptibly is fine. The only time the writer might
be blocked here is when a reader temporarily increments vm_refcnt to
check vm_lock_seq, realize the vma is locked and drop back the
vm_refcnt. That is an unlikely case and when it happens the reader
should drop the refcount and unblock the writer very quickly.


>

