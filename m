Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B46DBD30CDB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 23:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1B126B0088; Tue, 13 Jan 2026 18:34:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC9656B0089; Tue, 13 Jan 2026 18:34:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBDE76B008A; Tue, 13 Jan 2026 18:34:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CAC076B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:34:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74BEC1A9B81
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:34:19 +0000 (UTC)
X-FDA: 84328546638.09.E67AE6B
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8CC931C0002
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:34:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MRM45ZBy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768347257; a=rsa-sha256;
	cv=none;
	b=gBF1eF9tecvFT+mq5VPuy7gxCfH1ELmuhyBf8S/M4bE3oUvU3RY/CvGoBgVCH5UGNY2fQ5
	F8E0J3mgK9Dk7qIiELX0syKJ4LepqaaSujqjZhD6dhxRM1NP+gpsuAVG6hOZWNytHwJkJN
	yGE4yyl1qP3d2zuFnos4SskIEbSO9/g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MRM45ZBy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768347257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7s9rxJWckSpPn5eremPzEyroaJb9H+mV+4Z95ehOgA=;
	b=n27ooFvlTAWxLqL+ZSp1/SS7TxyoAmyzP68fjcSvwgvcgvfp0v2utbdlVrvfo5IOnOLpR0
	DxKj4HtuNAi4KhOjaPrJxvZac0qrp5mk5XdjiD2qhIRlKZBSrdeEY/VLAne2AR2xwNeZJe
	OxV235+uOJ+BYmSzqSMI6jgew0PcGJw=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42fb03c3cf2so4416328f8f.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768347256; x=1768952056; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K7s9rxJWckSpPn5eremPzEyroaJb9H+mV+4Z95ehOgA=;
        b=MRM45ZByKdqR/QOXzuQ5F0e2WrF+jg0OgGSuPN3Lt2vzXngYnHuUjLsT0/IujN/dzU
         FZC8WRDQXnevNpso+PVwmtReUtWquAa441qaDT2hXxPuskjLcf8XrWDHDKhTPtcr8867
         kWOxQ6uspDnhf5f8ZkiNmAqQqPMx4wMrwcx54Q4J68IhISavtgUbz128DNegrMGb5J/S
         eTrVBXlNYPcPq/RVzvsD7xJtm/ZZr1xwohxiE+WsaU9p0MGOkUYcsJnPVa+b1k5VzUda
         ZWUo+JeppV7fkRf1fTtawtIcRRvSORCYncguAN9YDHZTq2VHoCo+bf/iJ2zVMGY6W1AW
         DKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768347256; x=1768952056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K7s9rxJWckSpPn5eremPzEyroaJb9H+mV+4Z95ehOgA=;
        b=TZX6nRLgiXUocE8y1DyfmtkEbJVdQsCETn0/TRlgyOaeo7i+7eqf0jFGOz71rlkfmq
         sjqPd/B6NypMAkhYmxJFHAtRpS5sGrlYLrCnCNNP7LiuIO1BA22HifK+qUDvYnkZYLZK
         qrSu3j9+E3rkXTTUk/mfjdoMAG2ICpV/C5BuC8GPR/Uud8eVcQHlKF9paKmH+Qzl0JfL
         1AIsrLQpLQen2ving4vrONfQwHXednw+mYIHI47s5CZLON8LzsNP8yIr2CrM/YTV+NQM
         wSjX09alHG8PEYuM68yV7hEZlPgyrDyvm+ESsyOMJT+QJospZ86aq1Kzzxi0Re0oOrL6
         EvHQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2fLR5zePHwqMcY2a8oYofsX37BlpxddLPFN6huXFWwU0/VEBg+gKMQvpl1V+htMrxsfy+F+By7w==@kvack.org
X-Gm-Message-State: AOJu0YwD4OFIS+bp54lUU8eHJy6AEB/YOh8g8PrGa32acyx9oqB8098m
	7r9S39z95CwqZk3QbHJDqC1pRzF4b7XcJB0hJAP87Jm0eQVrsbjufdCROaxypyRc2rNOlxRlrtR
	l1cl0xc3dXRFggPzoaaeMG693KjQ3c1s=
X-Gm-Gg: AY/fxX6rCXYu4m5WPGKK/c3+uhK43qyLLKR6csRto9KMaD+fKMGM0ncCWU9eLym2M1E
	e9/YMaDbcDaLbEPROUZl8Hc+n82BXBRepC5JPqIu757bcd7Ynv9i3ohYJXc9aOOOGKN5xoYGkS7
	ztA1xoW1LIOsqSq08uMJ+Oyjb8IalVKbNcP/LaL8Q06ZfMrb7kMI7mOWE+/VA9XFDOFROHDK80V
	ocDaM68yLBPMEmLn76RZWOkNn7X3TZv66U6Hd0EKbmbEmQQceqWLOnWHfZudJAqz1QvG6gu+bD2
	XA7kJZxfGu6wMa35BFKgSEPpT8Cv
X-Received: by 2002:a05:6000:4284:b0:431:9b2:61c1 with SMTP id
 ffacd0b85a97d-4342c4f40dfmr471528f8f.6.1768347255789; Tue, 13 Jan 2026
 15:34:15 -0800 (PST)
MIME-Version: 1.0
References: <20260113150639.48407-1-swarajgaikwad1925@gmail.com> <20260113180036.Zl8j3vIY@linutronix.de>
In-Reply-To: <20260113180036.Zl8j3vIY@linutronix.de>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 13 Jan 2026 15:34:04 -0800
X-Gm-Features: AZwV_QjYt435EovaX3Vefewc_Yb9AEHtH7N6cRpOO2cyq9Oe5XpDAMX_LWYuCTo
Message-ID: <CAADnVQ+no23M8x-00yZXHo=0BqwwR0kyq8Z=oE9OK8G71PO5Yw@mail.gmail.com>
Subject: Re: [PATCH v2] slab: fix kmalloc_nolock() context check for PREEMPT_RT
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Alexei Starovoitov <ast@kernel.org>, 
	"open list:SLAB ALLOCATOR" <linux-mm@kvack.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:Real-time Linux (PREEMPT_RT):Keyword:PREEMPT_RT" <linux-rt-devel@lists.linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	david.hunter.linux@gmail.com, 
	syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8CC931C0002
X-Rspamd-Server: rspam06
X-Stat-Signature: 98dedjmip9rbu9ug3tgaf4hxj73hox8g
X-Rspam-User: 
X-HE-Tag: 1768347257-457103
X-HE-Meta: U2FsdGVkX1+ieWO36K/K/RZr5iL2lsC3qPY286mzATDDRHltJF01YPQaJs+RMBPxxmG3VWvZQxW043uzI+wGEysh3iH8vZXJg66fOtlGzCi/Eu9KQnE3hK9X0fvSbTjq75o20Q4YlFSyp+17aDRv05ewwezkiSg5j5Goa7NfLdTuuyej8zWBWAzTag9+IaBPRcVToz/KVuCkAf2Fmv9nj0rwwTzn5BUQnmY/TjuJEjpWDYgwUSH+6EYvtk3C978WrOAWowQX89oA6z0TrL1KiMi4qO9J85r9A3w6B3aFLFYEO8PXnk8NOgILCoMHDVJxuSHN6cCvsvLUamU8a9LA//Wv7SoZ9KaJMAEGOgymLaNZJgfmoEYUjk5dk1hYqG2e6jJG4RLoHCbLzCXO268m4UZzomE3rGRQuqtaYWz7SlY7WKFTUR0aLB5hBwIhJayKuhuMffiP8oaB63MJmwTuyyFW1+3+LaVJeBbzjmS4RFBW/qL/xQzigPtAQXHY1xuMpy5X6fNGvgq5iQFzl9nCZg4jzksvB5WgCT8zWaGHh0Ib13vu9kQKFKMcQSMSIk8lasugcSG5ugtc5E81wCk+J81+5aO+tS9cUWzDteFk+ykzc4Pyg+J2SbwbeKRHFEltr9Y57pbUGsTq19IuX3tD2G3VgtYDJVSHdI9AqTUkhCkVBOUrXIcyoNB48Aoa1GDVlkwf4DVr9HbJJ3AvkniTOA0H8aKV/dwQlaM5/mLRuGoTIk15RjtCleRBQASW+EYkLVJdcGsmlNpSyxU7FA+V44nydTXI/KYjs/WS3573XZqTUn2UnCqbW+Ln5gu3WUic8+q3vSGfqs/OWz6Z+XH9hxr9bc/NmQziaFAn1VKAmoguZx0/ZM9Ek/M4yrAAaJGiSAkpWiXgiehAJHb5DheGthcO20SpaUM9MYShAhqCnduvOcbE+C1Esunefaa+TvfveJ0bK7P6qollDk4R+8q
 PnG0zslx
 KuJR3w1elziClNIutFH2W77OrUJGbA7Yu7O6cCYGTk7wQl/4xxrRJzDhWjEpteu6fJDzeJIQQLoKyCFLpkxkptTt1NBiAqe+j62+BZmEbBJmd8a7LFlDaU+BjuihTxvGNPRiutLzDnhIM5p05L/Jqpju5Vv+rnyZkEY/+8V1aFQlxSTBQrVJuGgAio98F+RA4KVDcvDamoyqDKJ6tpqvMzTNpzujHuPcY3/Ja7WCdK7ADQ73ni0cSkHGIH9Y3uCMsRkeMOAjmWPClYA9TsaS805y4CIetbyHeuB1fSO8D5BBcu126cNXP4cCSH/OB5FGc4Pq1nrY4Kj8icvnzB+4bHgOBGRiY8SUohbagm4tfRLm1U94w8N5ejItgU004NpqYG9/alYRrF670FZ8hSKcWGAES8JN7qfr1dpBs234F+SHN7iB6jNJT0XvKEqY9I+kv4Vh7RuC/zifeX71GG/fuyi/F+0a4xFSytulfAJVcNOHZsh+6mJdDM/kJYvGYc3vDRexUUzZpuGTFQsTWxUWZCLstAlTL4gxOdBmhZnYcvYVvMAUNkpDkwjRGJ6/qP/rbxDskJtRrYUBHbZCLeJlyn0Y883dax9M0uSnAaQD6mtUnG1VIVEGYnEc6yb2lHCm20YO7gPC/3P/5Q8BI1H9jQHNw2oPeo7mqzGB23wqj3nVeJLkSkALW3ax3gisp0DkO3Zn7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 10:00=E2=80=AFAM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2026-01-13 20:36:39 [+0530], Swaraj Gaikwad wrote:
> > On PREEMPT_RT kernels, local_lock becomes a sleeping lock. The current
> > check in kmalloc_nolock() only verifies we're not in NMI or hard IRQ
> > context, but misses the case where preemption is disabled.
>
> The reasoning was different back then.
>
> > When a BPF program runs from a tracepoint with preemption disabled
> > (preempt_count > 0), kmalloc_nolock() proceeds to call
> > local_lock_irqsave() which attempts to acquire a sleeping lock,
> > triggering:
> >
> >   BUG: sleeping function called from invalid context
> >   in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 6128
> >   preempt_count: 2, expected: 0
> >
> > Fix this by checking !preemptible() on PREEMPT_RT, which directly
> > expresses the constraint that we cannot take a sleeping lock when
> > preemption is disabled. This encompasses the previous checks for NMI
> > and hard IRQ contexts while also catching cases where preemption is
> > disabled.
> >
> > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock=
().")
> > Reported-by: syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3Db1546ad4a95331b2101e
> > Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
> > ---
>
> Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>
> for now.
>
> > Changes in v2:
> > - Simplified condition from (in_nmi() || in_hardirq() || preempt_count(=
))
> >   to !preemptible() as suggested by Luis Claudio R. Goncalves and agree=
d
> >   by Vlastimil Babka
> > - Updated comment to reflect the more descriptive check
> >
> > Tested by building with syz config and running the syzbot
> > reproducer - kernel no longer crashes.
> >
> >  mm/slub.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 2acce22590f8..642f4744d5c6 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -5689,8 +5689,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t g=
fp_flags, int node)
> >       if (unlikely(!size))
> >               return ZERO_SIZE_PTR;
> >
> > -     if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> > -             /* kmalloc_nolock() in PREEMPT_RT is not supported from i=
rq */
> > +     if (IS_ENABLED(CONFIG_PREEMPT_RT) && !preemptible())
> > +             /*
> > +              * kmalloc_nolock() in PREEMPT_RT is not supported from
> > +              * non-preemptible context because local_lock becomes a
> > +              * sleeping lock on RT.
>
> I would say that despite the _nolock() suffix a local_lock() is still
> acquired. The !PREEMPT_RT does a trylock.
>
> As I noticed this myself today while looking at other patches, was the
> trylock removed on RT by accident, was it there only in an earlier
> version which was never merged and will it ever come back so we can go
> back to !nmi || !hardirq?

The root cause of this syzbot splat is preempt_disable() in
trace_virtio_transport_alloc_pkt() that is being fixed separately.
I guess this patch doesn't hurt, but I suspect with tracepoints
moving to srcu_fast syzbot won't be able to find
preempt_disable() + kmalloc_nolock() case

Acked-by: Alexei Starovoitov <ast@kernel.org>

for now :)
until shaves come.

