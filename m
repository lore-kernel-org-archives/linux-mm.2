Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8BDDC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 23:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4746E6B0088; Fri, 28 Aug 2026 19:33:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE686B008A; Fri, 28 Aug 2026 19:33:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 278666B008C; Fri, 28 Aug 2026 19:33:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1F876B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:33:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5FB69A4069
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:33:16 +0000 (UTC)
X-FDA: 85152281592.13.9FF660C
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id 72AC11C000A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:33:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FIUcjDPT;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of stevensd@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=stevensd@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787959994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPbHw3SXRt8c1h9FzmacGhPD5cdWkOAwAK9dhsy7doU=;
	b=oGSmq9MNxVI8Gg2Aj4x0znKklz53MYNU5XwrwUbPTkd+kNUHlIAxFEKNHPmtIkXDuXri0y
	Mnbpno7azQFudlfVUJJ8k5v6lDpDzaV3Ahkv9wR++90QPr2K6hLLhNKwF+JTDKIVFrbyup
	cUtGoK/tEWzsGk5u3vrc+pPX+EDvJsg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787959994;
	b=7K56hSA0TG0FiJADhhz34+YSHLn9w0CKlZHx0OS3F97LOYVjn9quTj4oHYkw0yymDEL1D0
	Zg2CvEaDc6PljcWKyc02xX36/UbgI002hul8U34WRAmmcCSO1FQ43xVaalfRbrPrByFRV4
	v3MOxZW69YkvCXKaJV5BQ5hmUbxhziQ=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FIUcjDPT;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of stevensd@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=stevensd@google.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-499add6348fso8145e9.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:33:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787959993; cv=none;
        d=google.com; s=arc-20260327;
        b=ckr3lyAC9P/Ttfr2UKUYMewRVn0Df/H8UlnuO4KLrEeIskNEX6n9EpOCCoyt8SzefV
         zP053qLfJ30NYEhf9kHevIdcpx9dv23RcpdvrCRGpEZ0AfcroS/rwOZsTFzEyYt9kUDN
         JGOo6JtQoQqWj34BtmoryGK2HU3n5NY9M/7WUjNqIgWWNkywUTiLhAegoA5AbP8tca+T
         L+aRJloxfirQb28XfZiVAOvECdETLBczN/gR7gUlaLINDs9G/+Wo33dAVZ9o/6mNeME9
         CQN/Xau7vsIe8B1mHGSD9i/j6S+bbzF88fWzatSwmv5nfQuA9maiSZhQ1+u/EA1GGo/c
         5/DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vPbHw3SXRt8c1h9FzmacGhPD5cdWkOAwAK9dhsy7doU=;
        fh=G3qIYzB3iB1GxsNvTK2QLYG63fGg4sI1yAkS18OlWxw=;
        b=VgnnPp7fTTmLeNzg4x8NHM3rqH+eNk7g/+LiGzUmy8vbjHith/sXyX0Mstyc0lMYOM
         vovVk8GwosNnJKP6HrlNeiiZHhSZe9CO+QBszMAmTvLIIalpIbhlZLxSYSVnasqBJrTz
         v7wW6OxUzaJ7cjTp8DlGouHfkaulzgiNaHX5YJ2/0HrNl11iO/PUuSAktcre/eSS840D
         yH+txlYQJIeNLPAkNj+YLQxjyKdOKFbM9fVJXEPbFCzKxBNdYxjWgrspdDdEl8wzjdnK
         HL3pZfiVYOB2tfdc8F1lI/ca6v/gaAiSDo5V06uLu8pKbjjTEdA/CqFWPrDR6uBMVYHh
         1pbA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787959993; x=1788564793; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vPbHw3SXRt8c1h9FzmacGhPD5cdWkOAwAK9dhsy7doU=;
        b=FIUcjDPTOeaCGwoyQ7ZPJQJ9ZOHO23Uio57kKv1ke8bn72XF0q+tp/d6bEhYE7rl2r
         SZQQeNvGP2Q+zC1ZhjzhOVG2RwtVQF1VgNvlrvSTsaQOblr0LdnWGejZpsWlXAo6IKBv
         5Y1W+wfyWrC14l9k3dAzX7SETC3y6ftj0Zdn3ZiQEwCuuA3XOgZoNpisX0FW0NW0HIev
         Y+8H3aXqletNP1F/7iY/kXY0hphAUIb3OklEPGVjTVntEF7l99dN+WAk9Kje9qX/8bPR
         BZDRUZT+6sksaCFoke1K5rlUg/IfYTQnz9P/SqJl4dx5ZglNpe5P3x3OCHO0DrqEo1Q7
         VxMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787959993; x=1788564793;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vPbHw3SXRt8c1h9FzmacGhPD5cdWkOAwAK9dhsy7doU=;
        b=YOVeOCkckI1amCen7qEmT4F0AVloHOyO71ugqhhjdH+JpZslKhXCjxUIl5CuZo54+G
         OfZyiOHkXdkpzJlSI8kv4hyd2DixnOcpJPZI8CrUXuFVyk6LOYEjhjRo8RBNSIEQ40n5
         1a5Oey8eNXoYY5nJyQOl/8oAivaY1KcxEz2Joq3NfumJDaxwsMdkpWX6GT35JBqvzOHm
         2IJantoxk4w/Ao4lkG4Ugyqn2HLiK4H130bgBcAcQmWAOgC5Ea7eMIhBvnxDqUBYybbM
         tvIgMkP0WTdp5xcRnj5FiMjKPVXI++UNyVmOfKC6qXxvkJt9RUqgajsa1YEN8Lw/SG85
         U7Bw==
X-Forwarded-Encrypted: i=1; AHgh+Ro8m3UNgqJJyPXvVQmxZRb0ebmqyUUCgW2C3c9zmu0IwnXDMFXUJyZqWZSo66RvN1EUwJyfIxjLQw==@kvack.org
X-Gm-Message-State: AFuF++kV96dOD2WZ/jvpSCKIuUmgRqaj2/I0YU9y3AZHzrp3os8po22C
	T3DTPUviUeuBPYCg0DXbe/wxzyEKmkx16kM158yaUmGq9oY5qzGSXMT7r3DFJBaeyueLff5hmr+
	kQLP5LTeXfkAFjMpTahX1pA0DJvPbM2DnZFpHXunX
X-Gm-Gg: AR+sD10UnnQxZr8yWBBLEj91COBzLqDCaso1XAqna9NEw2btGSDBkzREk+7BM1T/DwY
	+vcTRu05cqKS2WVzekKYH2lv6y6XBEbu1sa2NSJySWK8cf4LIbyOiHqNAQgzMeL1e9gtulJszMC
	CwO6mBtWlapOL8c0VJKl1nzFxy7V3JAWWxPU4qA7Kb8za9VjZAB7oAOZytZnl2xX/zZyo4s8JlV
	W3wQiroLgbLTqni004GY17sND6wSqhOTBYwHeypvIXyKi6rW34iVTtqBI3sZSBUNjsD02w1GVjv
	wHze9TB+P1aD+V7xTs3MgC+Lq2AHIaO99GK7cpiROceVDTiGGVYIYapadQqZ3hAf3J0hZIBSi5M
	=
X-Received: by 2002:a05:600c:3794:b0:499:cb15:4511 with SMTP id
 5b1f17b1804b1-49ccbb61af8mr349255e9.8.1787959992396; Fri, 28 Aug 2026
 16:33:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260827232948.2520558-1-stevensd@google.com> <20260827232948.2520558-7-stevensd@google.com>
 <20260828125706.GQ687043@noisy.programming.kicks-ass.net>
In-Reply-To: <20260828125706.GQ687043@noisy.programming.kicks-ass.net>
From: David Stevens <stevensd@google.com>
Date: Fri, 28 Aug 2026 16:33:00 -0700
X-Gm-Features: AcwNN1X4mjRfDUQTmdB2Q8G8afN4YKn_2mHhFiMGwyOfarmpU5bToKMeymOANtE
Message-ID: <CAOiLmNG8XUKzy7uyodfDyuSBKJa4LujqSRKhgmOiRUSFEAEjFQ@mail.gmail.com>
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
To: Peter Zijlstra <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, suleiman@google.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 72AC11C000A
X-Stat-Signature: giaqzftm4kzk4u5f1mqdhd3kbewbtccz
X-Rspam-User: 
X-HE-Tag: 1787959994-237001
X-HE-Meta: U2FsdGVkX18GYJgpw2E40GMXyVOkACoGGci7Jx9W+YxLMWS0ujwe0m7LouTcYT28EfhUcjvUuZBkaAAxkjQbNfZAx0RZNI52PrWhhZrk54Wz1ldXJqWJayD59SDQHRMCOFzZRs+KM3WRPuAqq1V2vo9pH5Z3BRlyGbwWmgNmNVr84+ZssyhEIR9L9Dg+1O182rhRVVhLZTRpvd5kqegJtvjf0bLgFazq2GH1Ar6iefJtQLuesTGXmeBlTtcPCyHi5r1Hs0KvDVAC4PWld/TwOILbDG5m1dsP8RIrO+KTi/cNi0HM2vUWuuW9/Xw7/1QcK4IAhNiQd0khNCmAfqeAi1unAycyYiBHqawQLR8wHr/9m+xkgwLtcNlTfqiTz6aehRYvaremQcsSGJzWDK//ygIPtrHLVQiqFpqpzYHCjQJZlis0+iTamihVIl60xt3mnUQcLc25utiXVEjihADQ3l3MGn6tTlJ8BLMwbq17v1BrBDyeFwA+i4yVx3kx3ra5YGRaXA/gxVvnKuninyf2LMkOQDfarHZ2Si3LaZVodjDkt91gcjLbB8yt9raZUS3/tGZm+Bx/Hi43nOjkssFsRfmi1dvsfD6oh5+Vseq0zwZAqKS7Bmp95xdJV/Xo5MeflDEMVjZmmDnHJyuul6tTE9TwO88+1BufOrOhWeUGrYK9ZIq50Wj+DPP03c1EvKTxWhMJ/zQKpMIx/zcowg2xx0jZ06JsdmoJ1FJBeQaxVYFu1vNZoTZRbiCrZgNf9I2+1t2gxTQyozuzapDXO5fxmMutPVpByWe6/ZBFXTZuP02hEhBiZXv+GVh2g3fSVmFS7i4P7DGhy2blpDTxWzprwHkbEorTdsKtg4hhO1uxXINrxKf52A6QSbIhWGza6nMgNoiSxz03ojtyHLo2Nwiz9FXcbIWQwJoWkSppPpjtrlf+UfzprDQsn5c2gk441S0eShOVxjaXmX+ke7cR1JQ
 60ykcR2u
 KXEZkpnokvRQFA/8okLsVQPbMfOFFu3HX/QYhCvWtAObD7u6OEDx8evyAzBxT+L4HOIJEwQfVt4bayBMj2Z62B7WACn2zdznA/FPeKX+Lydhkc04RmOQEl5WoHgheyRtjqvXV2EAW8QX8vHg9bhY+KMTB1D8LVfp9Zwy+AiB9oTcbaAGmLDRWgD9zVVn4eB1eL9zPHdMN25iwwprX3ZcRA+3tpT/bt2nZV1HtAi3s88L0bbHU57aaLFL++xl/McE2dvzfgOpAy0US0IgANR7ZTfHti0BB8yI6SDNrRNuka44DcEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 5:57=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Thu, Aug 27, 2026 at 04:29:44PM -0700, David Stevens wrote:
> > +DEFINE_CLASS(allow_stack_reclaim, bool,
> > +          ({
> > +             if (!_T)
> > +                     current->flags &=3D ~PF_RECLAIMABLE_STACK;
> > +           }),
> > +          ({
> > +             bool was_set =3D current->flags & PF_RECLAIMABLE_STACK;
> > +
> > +             current->flags |=3D PF_RECLAIMABLE_STACK;
> > +             was_set;
> > +           }),
> > +          void)
>
> > +     allow_stack_reclaim(prev);
>
> > +void __allow_stack_reclaim(struct task_struct *tsk)
> > +{
> > +     union stack_reclaim_state prev_state, target_state;
> > +
> > +     if (WARN_ON_ONCE(tsk->__state =3D=3D TASK_DEAD))
> > +             return;
> > +
> > +     prev_state.val =3D READ_ONCE(tsk->stack_reclaim_state.val);
> > +     do {
> > +             target_state.val =3D prev_state.val;
> > +
> > +             if (prev_state.stack_state !=3D STACK_PREPARE_RECLAIM) {
> > +                     WARN(prev_state.stack_state !=3D STACK_IN_USE,
> > +                          "Reclaimable state %x for previously running=
 task", prev_state.val);
> > +                     return;
> > +             }
> > +             target_state.stack_state =3D STACK_RECLAIMABLE;
> > +     } while (!try_cmpxchg(&tsk->stack_reclaim_state.val, &prev_state.=
val, target_state.val));
> > +
> > +     if (irq_work_queue(&tsk->stack_reclaim_work->irq_work)) {
> > +             /*
> > +              * Take a ref that gets released by do_reclaim_stack() so=
 we don't
> > +              * have to worry about races with remove_from_stack_shrin=
ker().
> > +              */
> > +             get_task_struct(tsk);
> > +     }
> > +}
>
> > +static inline void allow_stack_reclaim(struct task_struct *tsk)
> > +{
> > +     if (unlikely(tsk->flags & PF_RECLAIMABLE_STACK))
> > +             __allow_stack_reclaim(tsk);
> > +}
>
> So you have a guard with the same name as a function, but the function
> only functions when inside the guard of the same name. WTF ?!
>
> Anyway, it looks like you're sprinkling this guard around a few specific
> block sites. Which seems to suggest your PF_ flag *should* have been a
> TASK_ flag, no?

A TASK_ flag is definitely better. I was thinking in terms of defining
safe scopes, but that just complicates things for no real benefit.

-David

