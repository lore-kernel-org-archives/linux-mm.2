Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A32D0C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 20:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 848386B0088; Fri, 28 Aug 2026 16:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9216B008A; Fri, 28 Aug 2026 16:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69C106B008C; Fri, 28 Aug 2026 16:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3239D6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:50:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 342F0140581
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 20:50:21 +0000 (UTC)
X-FDA: 85151871042.23.8F929B3
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3F7FB40005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 20:50:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kwDaH25m;
	spf=pass (imf17.hostedemail.com: domain of stevensd@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787950219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AshsUhDS0njxXs9dy2fBnY4fbd5Y93s1/0Sdvq7L85o=;
	b=hGpN3fs/oHdfJDgWB36A9APHg5QiUzb2Vpb1Z6RDPHAx+jpo8JuE0+gJ3qEGKUNPyYj8UF
	QTu0zrca2rUUIkpmyouEOrqtaxM/ujghV6jdOm0RVv7BieOKR+ZoSV1/wn1bP2LMQbJiej
	RGhw5eU43ED4SFfpTx9VnZ9BvuQdnuY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787950219;
	b=QJcEdUX0RdaF5BvYYX+0SLNxwTB9/d1vh36NeHF+ZC1j7I8syhYwz9L9ZLzPTbXVBvCzgB
	zObvunwFXdpfvCyHjrdGS5ushviwljQGgB9CS7Uc8HGBxmbrjHNTGEZkUzQ3EhH6DuZhnV
	UkpmnAEKtkld1PBj519QAP1AlgSU9uA=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kwDaH25m;
	spf=pass (imf17.hostedemail.com: domain of stevensd@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-499b1409a75so3015e9.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:50:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787950218; cv=none;
        d=google.com; s=arc-20260327;
        b=iGW3AhrbV+L4uFm7RbPy1cDcShqvMjCGtXhqmLumj9Byks5FLMi+DlaC4GHbJ7PdUJ
         T8PUVt9uGqFQEKGZ3A3sKno/eZrlWltSEU3tjJ9byWeQEfAaoXWQ5jzO6pmbg1ea4yF6
         BEzjSDIDtttuUkzv1f5JdpvI0rxmw4Ns+JCiTzZ15QBrfNL+JO6kUfOClaLzTY6l6twD
         o036BkHxi4JMi7oYl6gjXlUT1wUSX/dlXDn8iRjnrLqAyzk4lh6CrViLUhXk/lNm377g
         px//ST83lpT3XEXmvpWT5fTTNxw0sKsj42ZYrKKrqVx70vKvPh9mJj/rjIK1MNjBvCFz
         k+gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AshsUhDS0njxXs9dy2fBnY4fbd5Y93s1/0Sdvq7L85o=;
        fh=YPTTUEpbkLWZA39TDsWZTaW1e0XwROHVpV60L6Pcs9E=;
        b=NboUTozvlnuQ/Bx90xwn+SuHwuqrj4h5STAEbMNiVMQpeAnLd+mpzBMWbGdGeB/n1U
         VeVCJJpWtbEtxWfoiDIvHbBQJWrnXcEoJhG3ULrRfJ7eMQiv1P5ydVZTq6Vi3hk/TMkw
         cfTm1DoHg1n73wYTCH27ONWHM3HksRVhKSwDzw9DiecXjmlGqQnyLhnOslKQ5qZawTaU
         /vIWPCyBmoLsA55TVQCrnChdwF6bZSBoQy+tTn/tBlG7+LWGQVgk+sxuzRRh3G6Qczpg
         4Vp6NcB5zF4Q8FX56gvzYh4gNSnRrZ+pryUfDlom1KpGnaeu/ME+slQUUOU0d4OAUw48
         tWag==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787950218; x=1788555018; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AshsUhDS0njxXs9dy2fBnY4fbd5Y93s1/0Sdvq7L85o=;
        b=kwDaH25mtBPhesrWVrRJ2VilPd9g2wMQpJYSSG47BqiyLhzgsDQ54IKEAUIv4eh1N0
         M3TS/pr3T5JJeOwong4Bg/f0GBtqISqVUSlyCXGD+cocJRHJr02Fic7d/2vXpAyszbJP
         WM2JK4zPkiFRVbTFef0qwQ4wM/Hvu2ZKk6QLdzKig5tYc+vHniPtWJvFb/RvJeizvzZ5
         pfZRYzcI07nqOTPLrlmqHVE+oEdxh/oOOR1P8zC8qHK9Ms6n4vCEnwt68OxbZdWZIWfI
         6MqsjHgHVKlDEcSznxZ8OUH7AW4ZjL84y0D1eJP6OVfj/BRTL+Comb4Z/LdAIZO2OCEw
         dNAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787950218; x=1788555018;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AshsUhDS0njxXs9dy2fBnY4fbd5Y93s1/0Sdvq7L85o=;
        b=slODTv0Xb9BifWOL+edPFdEB89gWpui1kQvRHQt6LrDdUgzNyqMiyPFTG0ZYBq0PnY
         +IfM6qyTWfPjoynzLF9Ub644SZmFiopHADDYzWJWqYOO/uOOdR954Xuo24UERYkaDp0Q
         UNvzEYbkXYny5TubUBZu9LuDj6xcKcSclQyJbNHL49v4pLjDWRdqbHJzqyY3hmCKZcMN
         IUOiIyTlDK2lX2UU7RhXVLWMC3NbWSODdzmnd/LZ14dyxqrz2+S+y6sUYAgbNtOBTCm6
         ZXQUldqThzF9k3kRxh3H/UcKq4xDwt8z+erP8RM/bcIyQwWJ1Vqw9MVs+VpWqQDVfc9f
         5vsA==
X-Forwarded-Encrypted: i=1; AHgh+RrJdEGN8OEguj8mJEhQO3p0Co1GEmxmgwYKgxk/9IF5SHDildLej+yBS2yVteBYHiCdMP1H7+MB6A==@kvack.org
X-Gm-Message-State: AFuF++nqW44P2gqJS82uGAy3wBTqW5kl0JH1XY9VpMCmyzVqjJD6ZoPq
	i2kyk5X6jwp5xTvLaFeyYVs0qJWYUMhii/E5+vFcBsXIjPxy1KxW2hd5MHWfTI78jbRptUZb2VG
	1/7JWNtfoBg6k+8TtFSM9yOJwpCdTE3KgCoQuemZn
X-Gm-Gg: AR+sD13Q3532SbdtanPFEUfu7YYFJCnGqYoDg6tkriIZ81S9oQqx6Iae8uTH9mJ8RKo
	dQmoGx7hFr2R9rTmWGTUupDT/x02Qt0GuJkvuZw03Nkk78u803U1GHf2HPVSehulUpQ7j1c7VlC
	VICGEWjErscrZDKuAU1AIuIsCMd5aIGZfGi3anbnPHarHn7r19yZrTMgBhyf4t04UcW0RzXUDoi
	lTngeebrC8Jg/6jF1+ifylYHXWgl1hverblWaCqFSjKbYPyJn2MG7n2JG2mcSATPjdSZZY92P/k
	sMJ/jWcMGxRrSnNiWnwOM94GQrpjDKTUhGd7io/PskIEd0ZXF9NoJm2dJL4fYTpJfvE2pLrk3EI
	=
X-Received: by 2002:a05:600c:e40b:b0:499:a6a5:a687 with SMTP id
 5b1f17b1804b1-49ccbab90e6mr277105e9.0.1787950217353; Fri, 28 Aug 2026
 13:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260827232948.2520558-1-stevensd@google.com> <20260827232948.2520558-7-stevensd@google.com>
 <20260828133620._x2XfJR_@linutronix.de> <20260828135947.GU776954@noisy.programming.kicks-ass.net>
In-Reply-To: <20260828135947.GU776954@noisy.programming.kicks-ass.net>
From: David Stevens <stevensd@google.com>
Date: Fri, 28 Aug 2026 13:50:05 -0700
X-Gm-Features: AcwNN1VyWJkmCojhn4y_J0QYwM3NKcFniOfDcwtOJUcQgsmCVgZZIDC5YzitEe0
Message-ID: <CAOiLmNHrbXeTY7zoNodmaZUoMWf+NgvGvZ_LjfWD-1sKAoiLeQ@mail.gmail.com>
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Uladzislau Rezki <urezki@gmail.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3F7FB40005
X-Stat-Signature: x9odesoxyo5ot4edbnkwm6hi5k15osoz
X-HE-Tag: 1787950219-532329
X-HE-Meta: U2FsdGVkX1+Hu7SfDmsNvhV5+cjiaMCf/Vdu3oWbFeZcbdGnigiPSdumT0GcfSb8eqGPPYmG813Spr8uaJmUcCMtuGXeBoddfp4fa1XaxjJ9QCMr0jklki8HIsFDUvwOQkb9hyI/vmoxYxvpwRiMqFYJOcAjLTYmpaaH3N8tl2DzEyr2UgyReBJqGyX5w6Qaa1GFf+PmbNYNzxGYd8e1TSAzzxmu9tLg1NlEc9FX3z0dYv9YX9QDcmPbR5ichSNM6Woif5ylyMg65EuMpwew4iUx4C3nCYpsFTTvIcUp2Q5ilTzppvtFJmaMNR/OXlOX6/2pCX1rFH6G1C+NMFrAk8RLTnOP89ELIARAavDWDUR0uAcbpuzJU4F6d8l76EbsnJVhwJfAppr7T3vToD8yTn55o0TEq8eaH9mXGM2+gTMODUDSXHumdK6YYcxbTedMPJ2bMw4tQf/f8NtO8uEalbvlRvFPiwwNLlv42mQ/ojGr38GWYw2CgNucOxS5xEbkqo7qG0wk2TFPfTlCwApNvPJOuCgYdL6hahwaGmYE4kH7GSpp5dql3loOB7sfgkDzmFe8etDZGfJ9Tz1Ei1gWJnsvD9bSb9IGvxNLwvpqGKRKpaPiPQt3Z+opBS6Q6HqKkgbf9vlMI0jp7jdqcxjlBmBIfjX2aOTlACPhA+GgWcCu4HCnfr6fXVFufngb6bRCX/rtNtzDCuiEwh4PIW4ee1BopRuH+Z8Eu5+EA8EuyMiI6I+T0FwnZfmgskuVj1OoiaKDpo59+2CAA6g7EQBgVrXhPGoWK+RNxO9gvgrW+Ydb21uASjG90q+gV6O+FW0fN0O4N3E4wlTzZ3uLtye1BXoU1iG7Bg0XL2aSAll6lElQr84u+Ps3Ai1a6n7QYaq86W5UxTiMEMBQgUktN0eiLuI/YPM0ZKV/tSjUqWR4ia6judqiZR6LnkQV4a3F5mlJ4gMHtm3LDWEPAG9t5F8
 VzDIcXnE
 DE6EJLmnsi9S8zrLw7CFOYcCwkTSY+iISjxe5x7sp1V2DbbIM5JG/3tjwtYGbeM4Gi6xhoft+UraHxYoK4igpxa5jWEoSq2diquDl0DkMzubKM0ZliwhmbyKLFDK0SKJA/yFa9eypgV4zG9d4ZdbfqpjvKcMUngXeLoJ+1GYa2rHKzo+DYphAhpYiGvWDGoAIvG+J1HBq2pTUUsLKl14y3EB8zZQF7En2juiSAYWHCMuelP50asjNBRPEy+ANFXLeVNqvUdfkRvxqzvoVBTep3C/Oyu02W2841yyMGFlE6p0G0dI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 6:59=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Fri, Aug 28, 2026 at 03:36:20PM +0200, Sebastian Andrzej Siewior wrote=
:
> > On 2026-08-27 16:29:44 [-0700], David Stevens wrote:
> > > diff --git a/arch/Kconfig b/arch/Kconfig
> > > index fa7507ac8e13..adb4a5957996 100644
> > > --- a/arch/Kconfig
> > > +++ b/arch/Kconfig
> > > @@ -1534,6 +1534,24 @@ config VMAP_STACK
> > >       backing virtual mappings with real shadow memory, and KASAN_VMA=
LLOC
> > >       must be enabled.
> > >
> > > +config HAVE_ARCH_RECLAIMABLE_STACK
> > > +   def_bool n
> > > +
> > > +config RECLAIMABLE_STACK
> > > +   default !PREEMPT_RT && !PROC_KCORE
> >
> > This shouldn't default like this for RT. It either is useable or it is
> > not.
> >
> > > +   bool "Allow stacks of some blocked threads to be reclaimed"
> > > +   depends on VMAP_STACK && !STACK_GROWSUP
> > > +   depends on HAVE_ARCH_RECLAIMABLE_STACK
> > > +   depends on !DEBUG_STACK_USAGE
> > > +   depends on !KASAN_VMALLOC # TODO: add support for this
> > > +   depends on !DEBUG_KMEMLEAK # TODO: add support for this
> > > +   help
> > > +     Enable this to allow the unused portion of kernel stacks of mos=
t
> > > +     blocked tasks to be reclaimed.
> > > +
> > > +     The wakeup latency of tasks with reclaimed stacks may increase,
> > > +     especially while the system is under memory pressure.
> >
> > It says *may* increase and on RT it _definitely_ will increase since
> > there is a kworker involved not to mention the memory allocation itself=
.
> > Anyway. This either needs to stay away from PREEMPT_RT or find a way to
> > exclude at the very least mlock()ed tasks.
> > Did lockdep see this?
>
> It should have. They're taking spinlock inside raw_spinlock and lockdep
> should very much warn about that by default.

It does trylocks on spinlocks and local locks, inside of
alloc_pages_nolock_noprof(). Lockdep considers that safe.

On PREEMPT_RT, it is necessary to skip the call to
alloc_pages_nolock_noprof() from under pi_lock, since with that
configuration spin_trylock can end up needing to take pi_lock. But at
least on !PREEMPT_RT, there is no risk of deadlock.

-David

