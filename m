Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9682EC88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:18:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9746B0088; Fri, 11 Sep 2026 15:18:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882DB6B008C; Fri, 11 Sep 2026 15:18:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7985E6B0093; Fri, 11 Sep 2026 15:18:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E26E6B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:18:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F46914030B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:18:56 +0000 (UTC)
X-FDA: 85202443872.04.60D47ED
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9E46340006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:18:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=s5achtpr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789154334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vIEx8uU8IqjffSSCDEyJeKQJtwuejUussKszKVj30XA=;
	b=tJx/Rv9GhB8Nv1eAoHl0BxNyyP5h8iji+lce39nkxWRkWIeOxNwOTsc8mfsCAAtxsnNC8f
	GFzMcuo96dYg9QpB14ilLFCMZDG4LDQgdxqiG5SkOBOzcKF2akPlvNB/tmoFgq+gyzB084
	IqSKvLk90RoDrXBHwZLRtQTvoWyfHvI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=s5achtpr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789154334;
	b=3GjspuFRXT7/cd/BuxHUhSC1iG2f+qgAEN1UmmUtB4nJDcFb0qsg2CZw4Aa0ByXw2dppgQ
	LtUfY0kS2A4Zxa7KEkyDv31B1EqBuPniGzCLdUiQSC3Tq7kuxpd0H3UGTtwhZVoisQvKIX
	zOBU3/QA3Xp0/DVIJbqnS6zXp9/Kbsc=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530411c7ee1so118341cf.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:18:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789154334; cv=none;
        d=google.com; s=arc-20260327;
        b=Uc6m1zJXbfPJDfFrh4zztDXI+yeNJoi3qlR3f0U3H4MuLj7NbJUgiJi/nB4y/T0AuS
         PKhQVnD79JsK3mrFCidwwCk3UPNOnIfpU8pW4hMxoL0NxJBkCzRAhT2ndCD8/CesamHC
         UxlB0l02PQ5Onhz0zhwaKXsPrvzxtckRmaDdRnUMDwWzc0EC2MgmV1Ki6jws7xhyJM0u
         YglZjFhw/SmYYdS/ozxtENq+V8K1cNahJyoVhrxTM9RN3e1VdrMbmAGVHQfEzt5PX2o0
         5Ypk0jkMJ1sqkpCShxj2rjLOr8Ck+pFoBcGMz/z3KZsj0940sOEvxFFzL8LWoAOmtI+5
         SoYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vIEx8uU8IqjffSSCDEyJeKQJtwuejUussKszKVj30XA=;
        fh=VhQzt5cLmIdob5qXGWjC5h3TtuNcmkTV7E+sg9WlPhI=;
        b=Otq6Nj8wZrcpis5KgdjCHQhKnOiKOKlf2CD++fKEeTQG5nO2dRoDoPSbtiwBAvdIA8
         +q5RMogUnbglq32SCdRKFregApKwWpW54oAtV+A+BfU3AczoTp4Z0OwG+KG1NX/Aimq9
         nvewSSEKQUdIwP1tEEBVRVAn2OXfFFEwiH9kJA7DgSq6q2Hn2gwqVokrW04XTC90fMGE
         HeXw9598KY9vclCmr6LANw72lGj+49xnronFRP1w3WmWXr2Sboy1YRXS7bySInXKqz+A
         nif511l6dgYyRl1+ej/iYDeccX2/i+1Ge7kf9MXhKKQBjvu3X9/igY5b6dCvDEUNnUIt
         P9hA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789154334; x=1789759134; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vIEx8uU8IqjffSSCDEyJeKQJtwuejUussKszKVj30XA=;
        b=s5achtprTVhFwuy2VxWDC0FPHjl9Rr1MgyZ3wL0jxopGxu0J+nshNdf8vuviuqsGBQ
         9cjPi+d6/OQjRJDrp+gA//tzD6U5ocewN0U2JDi3paxhstdArPiMhoSXpIyT+aB0pqld
         k/3p+iR5Vq8OK+lyF2Z7GOp2osbS0KtrEO2K7adZxACkRbicRUnAxcyTXw2UzM2l747D
         gfBOD/NqJmIp5tdNcOt+5FedjJl9vFUeuG7i/Z2exknasLN7/3OYf9GCP5nX/sxn6l3A
         KHvhis6AO280KeB86VgK9SNWuWjFgEsC9Om/neysH5kWDPwzz5OK9A/zx10zeiio5DZJ
         SQVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789154334; x=1789759134;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vIEx8uU8IqjffSSCDEyJeKQJtwuejUussKszKVj30XA=;
        b=biE/XOwRjAnbkRwfbJ3GJRW/rCoVWe303U1IbQPfL81T9s/Lu+u+SvaA7EDUwvEnLu
         Vll8wKgr7Lq0zMwehFW10QKbSnE0OQjUuaflo6LsJ+WAk/ciEAq16tP6daId+MXC6rBB
         WufFCwD8AbvjpNxJBGE2M5IC1SY/GuElg8slPqSAlYWryW92UEADTcowjmUDs5E8AcxA
         5AbrrmQzspQmN9G50AapmU17AvblzFGhczYj6cAcTnFpQ/eUdpslqpQsGs3y95HjyLiY
         0Y/+C9fKqE1Rl0YkWhWwK3i/IjQ3IvJDPNSssKVQPr3qBaolBhOoocMhNdDOB86S0kRL
         IO9A==
X-Forwarded-Encrypted: i=1; AKwUvBxUDtBo7ob6kz6s7+Z3jPBHA5ukh7DDGx8NrQWiRemyyKIPKhMG+/YQYtVyIO9PbwarVaDZpyWyrQ==@kvack.org
X-Gm-Message-State: AFuF++kdBNjSxs1KUfT7RUytHm38FugSOq5Em+tlGWWw9vPfOjVXSoJw
	hZ/g+38Uok1zSlVesJ8CIsjUD+q6glSwSWeNmTkswqnRyR7v/U2AHmnO/LJp31o2VvANwy8Mya4
	K+mh3nSWlVLDydvRwB/6FXwUejj3u9Ah9EWJYtO9I
X-Gm-Gg: AYBFou3rHnKOlwSNWl7uYQkIPWqkFvD31Go809+9tM1T/j76kDXWzT6uPyv9HrfbxFf
	K65U5J5QFIk+2qcXR0O4nQiCnJVQRTI04MMTOejc8zicrmqWdldYQdMm2VdBJNYcpvGLgy8HvhB
	Py2HgtHjpSQVHwXKNi1g0DC3M3YTssR3VKp0EiDNh0fRWANLmRKoYSXsjvU1NVvbYemqYe3FxCA
	/ol+N5b8Ig6m+DpoieAoU9iap96E2fM43XtKPqV+O9R/W1AcauoDWMBEK55YBzMaFowjo3fR388
	fTKt/E32ddG573vCx//7HnTb5ThVucd/GLwG3U6JIrVY1+T9wv/y/KILOrtjSuxYxD3KT2jJuJ0
	2vgMmn4Wqsg==
X-Received: by 2002:ac8:5c85:0:b0:530:4182:5a68 with SMTP id
 d75a77b69052e-530e498be91mr2143731cf.15.1789154332936; Fri, 11 Sep 2026
 12:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com> <20260910234737.1340642-6-surenb@google.com>
 <aqRF4YB7Ijk9PmRM@gremlin> <aqRPeZH4yeYXfWgS@gremlin> <CAJuCfpG-8sQjg2ECiRQpjn9tBj3AfEXnmgmomdfFGS7JoDhZ4w@mail.gmail.com>
 <aqRSvISJtYrt5Gvp@gremlin>
In-Reply-To: <aqRSvISJtYrt5Gvp@gremlin>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 11 Sep 2026 12:18:41 -0700
X-Gm-Features: AcwNN1WG2bylStI11oz5hgwXcx_h9MCQ-S7zrTZGjslGEl7r32QMSMJo4pyGgXI
Message-ID: <CAJuCfpGvB4o1HrKsi4zbzKNmdxppW_76xJUbaYeE+sN6w-u6UA@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] proc/task_mmu: change proc_get_vma() to stop
 returning gate VMA at the end
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: r4y8mc6yazfqhrk3n19cghxyrg59ng66
X-Rspamd-Queue-Id: 9E46340006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789154334-724440
X-HE-Meta: U2FsdGVkX1/s9Lhre++oaOWPjisqo4muepHcWEd5wFqUZbYbDrLktF0naAWNffxnxjwTwlHLA9s++AslM2cdOaY+mBdIKwhrR+34Vr5eJMMp70aWWFHxt+f/6jvmeAsWH1Lku76Um1VDp9tJBa+1okZ5QEiv/zaWqbbAAOam632UNQxPyzYrl+tA2FVuKeDagsOuQnY9cUqBg7jgHuL7Fub+phYi3M5rBtSzykaC0iu0GSumLNTx1Q8LFaCKSC9ikcdZiq3NCqFXi/W2xc9jx0bMyUz7/4FysZOTn74XwoxYPvb1lQhKuZIh0FAbS7os9Cjnm5YiraUo7I1EtySp7Dqkf/6MnK+47WYuIGhHBtRqdPwY6ficcGg18a+GCjW7wx7L4K08c9ynz+Jl2vuD6lpvpRZMAVk5xDfC8gtUonDuP5cG7+pXM4pE+t9zyKbb4nFD5U9ENvOQmCkiHqZDETjGoGNPJ6QBXgnQJbmLVu7tmaWIbckOTSKg55GBzZRiwYovSVWaN8b/8OFy9ODHiPkjFn0KXcPOX9nZxddPXuMSUTuEVNd4gjkBRVFC25DThWsab2Hvcn+hTnfNVlPTKN1KzcDKK/Dj2ofj/+CA93YWlwWhEOd9aioB4HJ/SRcNnFfvIq1LtsqA88RTfv5h+cDW1t5vg5vuVNpUbRc+7Ih6QtM7O8M6TwL3QB8y5tGwsR0rg+SM14cKt8bjbC1IM4MPrZaAwjcAoXfF/uG9LVxJHuIIRUf2gn1Lq7Go1zi+PbqKZjIukV/6uOa0Fc6eyLARwRsLjLyQZEFlhvSsvN1CPzKeYVsdrle9Z+PiEr32dVfw1i7uPAm8wdm7QTR8o1dQ5rdYWqa65Uy3X1dza4uvkWOHiDSZLa+luOS/1nDM/HwLbQauAKoqL51Ga3bEiAyhQIvKwoeR0ykmeNDFBjIaaQbQDs+EevpNzutGTw1mOEgjxXLAgU+iM/384gn
 lbppECuG
 rNJVtWaQCbB8MVwNlsUQUJDolaSw70ExeZzkfDiXd8QX3gVH3X7a9dq5M3QQq8M7Qldm4yBWz+h6OtOyfu/hSse5k4N/lKIW2bzn0SVNgMABm4gG4Y8FtPzcQ9f/oiOlrHQJ+3Iwl04s1/+uIb37H6B5citEPvsJGd8ZFVDBSFyKJOs4BfIAMG5Y1/XOHm7EPpOaoLfN77ohsGxUQjABsxqdASf36QETPQEboyaSCy24TU3lx//gaT46VEFxEnkidfdm7H62gXDvhWSepOnJvLMGL3QxQrmJmmkt9AXWdrV7G7niZtnDLCobsHRskbdPLZBjR+6bNkqz0bfVqzM/vz9D1uVmWGxL72+VCsD64YIvy6VsSoH/NzksTt+hwDM0cfIV2qoalxOfIhkD8p0lIMfa6EQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 12:13=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> On Fri, Sep 11, 2026 at 12:11:55PM -0700, Suren Baghdasaryan wrote:
> > On Fri, Sep 11, 2026 at 12:03=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@ker=
nel.org> wrote:
> > >
> > > On Fri, Sep 11, 2026 at 07:26:49PM +0100, Lorenzo Stoakes (ARM) wrote=
:
> > > > On Thu, Sep 10, 2026 at 04:47:35PM -0700, Suren Baghdasaryan wrote:
> > > > > proc_get_vma() returning gate VMA at the end is desirable for the=
 its
> > > > > current m_start/m_next callers, as they need to report a gate VMA=
 at the
> > > > > end of the address space. This behavior is very specific to these=
 callers
> > > > > and makes proc_get_vma() hard to use for other purposes.
> > > > >
> > > > > Move this usage-specific behavior into the callers themselves so =
that
> > > > > proc_get_vma() returns either a valid VMA, an error or a NULL whe=
n no
> > > > > more VMAs are available. This makes it more generic, simpler and =
usable
> > > > > in the later patches.
> > > > >
> > > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > >
> > > > Yes, very good change, thanks!
> > > >
> > > > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > >
> > > > > ---
> > > > >  fs/proc/task_mmu.c | 23 ++++++++++++++++++-----
> > > > >  1 file changed, 18 insertions(+), 5 deletions(-)
> > > > >
> > > > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > > > index ecce7ce116cb..9a3c996c1d61 100644
> > > > > --- a/fs/proc/task_mmu.c
> > > > > +++ b/fs/proc/task_mmu.c
> > > > > @@ -236,9 +236,6 @@ static struct vm_area_struct *proc_get_vma(st=
ruct seq_file *m, loff_t *ppos)
> > > > >              * found the extended vma with the same vm_start.
> > > > >              */
> > > > >             *ppos =3D vma->vm_end;
> > > > > -   } else {
> > > > > -           *ppos =3D SENTINEL_VMA_GATE;
> > > > > -           vma =3D get_gate_vma(priv->lock_ctx.mm);
> > > >
> > > > Yeah this is just so confusing as-was.
> > > >
> > > > >     }
> > > > >
> > > > >     return vma;
> > > > > @@ -248,6 +245,7 @@ static void *m_start(struct seq_file *m, loff=
_t *ppos)
> > > > >  {
> > > > >     struct proc_maps_private *priv =3D m->private;
> > > > >     struct proc_maps_locking_ctx *lock_ctx;
> > > > > +   struct vm_area_struct *vma;
> > > > >     loff_t last_addr =3D *ppos;
> > > > >     struct mm_struct *mm;
> > > > >
> > > > > @@ -280,16 +278,31 @@ static void *m_start(struct seq_file *m, lo=
ff_t *ppos)
> > > > >     if (last_addr =3D=3D SENTINEL_VMA_GATE)
> > > > >             return get_gate_vma(mm);
> > > > >
> > > > > -   return proc_get_vma(m, ppos);
> > > > > +   vma =3D proc_get_vma(m, ppos);
> > > > > +   if (vma)
> > > > > +           return vma;
> > > > > +
> > > > > +   /* Return gate VMA at the end */
> > > > > +   *ppos =3D SENTINEL_VMA_GATE;
> > > > > +   return get_gate_vma(mm);
> > > > >  }
> > > > >
> > > > >  static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
> > > > >  {
> > > > > +   struct proc_maps_private *priv =3D m->private;
> > > > > +   struct vm_area_struct *vma;
> > > > > +
> > > > >     if (*ppos =3D=3D SENTINEL_VMA_GATE) {
> > > > >             *ppos =3D SENTINEL_VMA_END;
> > > > >             return NULL;
> > > > >     }
> > > > > -   return proc_get_vma(m, ppos);
> > > > > +   vma =3D proc_get_vma(m, ppos);
> > > > > +   if (vma)
> > > > > +           return vma;
> > > >
> > > > OK so I guess the logic is, iterate through every VMA, then once yo=
u run out,
> > > > report the gate VMA. Makes sense.
> > >
> > > Hmm one thing on this though - m_start() still has:
> > >
> > >         if (last_addr =3D=3D SENTINEL_VMA_GATE)
> > >                 return get_gate_vma(mm);
> > >
> > > As well as:
> > >
> > >         vma =3D proc_get_vma(m, ppos);
> > >         if (vma)
> > >                 return vma;
> > >
> > >         /* Return gate VMA at the end */
> > >         *ppos =3D SENTINEL_VMA_GATE;
> > >         return get_gate_vma(mm);
> > >
> > > Now at the end.
> > >
> > > Is this correct? Is it maybe duplicated now?
> >
> > Yeah, I noticed that too but I it's not duplication. The first check
> > handles the case when right after m_next() hit the end of the address
> > space and set *ppos =3D SENTINEL_VMA_GATE, we ran out of page space and
> > had to flush its content. Once that's done, m_start will be called and
> > last_addr will be set to SENTINEL_VMA_GATE. In that case we should
> > return get_gate_vma() and avoid calling proc_get_vma(). That's what
> > the first check for sentinel is doing. The second one handles the case
> > when m_start() itself readches the end of the address space and has to
> > return SENTINEL_VMA_GATE.
> >
> > It's possible this can be refactored a bit and made cleaner but I
> > would keep that as a separate change.
>
> Maybe just add a comment to the first one to explain when it'll trigger? =
That
> should suffice, cleanups can be separate yes.

Will do. Appreciate the reviews!

I'll post the update today because there is some urgency to backport
these patches and I want to have a public link when backporting but I
don't expect anyone to burn the midnight oil to review the final
version. Have a nice weekend!

>
> >
> > >
> > > >
> > > > > +
> > > > > +   /* Return gate VMA at the end */
> > > > > +   *ppos =3D SENTINEL_VMA_GATE;
> > > > > +   return get_gate_vma(priv->lock_ctx.mm);
> > > > >  }
> > > > >
> > > > >  static void m_stop(struct seq_file *m, void *v)
> > > > > --
> > > > > 2.55.0.1007.g17ff1f9808-goog
> > > > >
> > > >
> > > > --
> > > > Cheers, Lorenzo
> > >
> > > --
> > > Cheers, Lorenzo
>
> --
> Cheers, Lorenzo

