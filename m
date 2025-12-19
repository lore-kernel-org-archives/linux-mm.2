Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4FDDD78789
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 277626B0088; Fri, 19 Dec 2025 10:22:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2254C6B0089; Fri, 19 Dec 2025 10:22:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 130D46B008A; Fri, 19 Dec 2025 10:22:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 009466B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:22:34 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A173313A753
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:22:34 +0000 (UTC)
X-FDA: 84236587428.04.47F4620
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8A79C1A0016
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:22:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P8SXJr8g;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766157753; a=rsa-sha256;
	cv=none;
	b=WxGxzYpiJzWDxHETlMRlY1ncG0oSMJEX0e/Y+I+kv0JyzLJ9bYJVO9A+YJiS7KOunx79jQ
	F2I1grNjqstZt4SofsoVcNuaAQ7/HpZg7QFMaiwxym1cs/6EaA+25DoW3hdPwf+Hr4VA1z
	IeIQ2cxEsYA14T5Oppae/dYOj0+5ZiQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P8SXJr8g;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766157753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3s9JULSYXzELMJAZ9rBTWMLVrJKymV2Q8hfDA0hnfqY=;
	b=iX+SgU9jJyVjyxp9vlpY59oeVDuvZ750Y+jo1Jm75Vf7pE2Q/zmSlAi/7rbCVTv6GgYNX/
	Bgty5iGQtdSdoH/xZH4eOL/fbTmGxfPugwm9hDZpwg/S0M8YPeoLUoUxaRCzO0BhF15VOY
	B43VWwfIgQYT9r8WofZRa9Yaq20KdyU=
Date: Fri, 19 Dec 2025 23:22:02 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766157750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3s9JULSYXzELMJAZ9rBTWMLVrJKymV2Q8hfDA0hnfqY=;
	b=P8SXJr8gDG4M12wrwkP9Ka2nH0qsdAxraE23lcyLTJkG/xBOKXWTHJuSovBKj+EGHpbfu2
	DKEDZY44SAvoeWtuOdyUh0VS0YmxoDLmqdXs8l+7ab84a3iFtJSoEicJAPgZRAZC6/FMAG
	/gzueVk0S42JOVHcw3W+XcpSzDP11MQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, 
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Alexei Starovoitov <ast@kernel.org>, 
	"open list:SLAB ALLOCATOR" <linux-mm@kvack.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:Real-time Linux (PREEMPT_RT):Keyword:PREEMPT_RT" <linux-rt-devel@lists.linux.dev>, skhan@linuxfoundation.org, david.hunter.linux@gmail.com, 
	syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
Subject: Re: [PATCH] slab: fix kmalloc_nolock() context check for PREEMPT_RT
Message-ID: <p2kiryxpwq7iu7x6jq65kzff4uivbdd3cne7rizax5b33ce5yx@nr5hfrnfevxy>
References: <20251219085755.139846-1-swarajgaikwad1925@gmail.com>
 <6fcfe0cc-3826-42c2-9c54-c127dc8379e1@suse.cz>
 <aUVTJyd74OoCtSyN@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUVTJyd74OoCtSyN@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A79C1A0016
X-Rspamd-Server: rspam04
X-Stat-Signature: mkf5i6j8p76sxbn33tiu7emkmyd13tju
X-HE-Tag: 1766157752-193678
X-HE-Meta: U2FsdGVkX18WX9GeEfzJMO9XL7cgAfZzv350WIs42j5BdUZzG3kxNxm6jzE31RsozSWbjHXBbsn8uf+to326XBAhRFTjfCqjHCqQ2xTKVMqb8sx7BRvTh+sq7jAQE+N5X9Bylb7lE0eJ1pKEDdCe+kmDUtv4vJdGdRi/15SN99XQdbVJKPlIjvM/fB/1iRoEoKOghBxr1nf5B3EjhAOViymr+NohtI23SmW3JLHcRfhcOhXCn27PMzkF1YEXsevBcdp+xzT68xl8JDm+6IuqiR5/s47yYpi5Dy/IaZ3xCKsv7waaa2BJsI0wKVG2JOOHCxnOs3kardQoULo0fYia+mMFZxmghPDCt5c5oNkFARq5VtP796EFsYfovc4t6V1ZjUyWn67FDcq934QHK8YiLYkx2HlLRAEnor6phjDj2Haw2EMhSJkkROw065p9l/Jo2Y2XuR9hYPyYcdsgz6ympCb53IKlhKmj7kjtwiT1+PbMyTuBW7dpAqLI7H0Ne2Z/FXKzJFNR2fDTptHviPKT75Cam1pWzVha1OuJPSzBawDf0vwbVh4yVbQCzg1Uasd9rgYqRtvGEdis1SPLMQYHN2mf6j/iiBCyazyVX94XlIanLz1RSyTdrmWpkpxHs/eh+AUd659Sf/t5X3YS6FfM0vVvx7ERhIICeg6WAcuO9QgKcsB05kcTPAoz5yES6CdKlveNDiaZJ0+CnzPNe9eWhDrnFb0yYC4ajwi7z5JANN4K1IvHy/5O8BoaFkt4Atc6fZhoRy5D43v2ADKy4yOky4d8PS3G19Gh8+gsxLP4YQfQy1ramHSMPto78p5A5jAHBya1Opa+kzb5oBQAEYtYnfdwU+0MnHLZ5mWlGs7yYGp/fmKEImDDjr1o4zOjuXURBXuDILANSijGQidQQi+xwnc3HI0myHe9sv/yo7UJ4m4rrlgldwmwE6xOQbbl8X0q9SdUKLTgvBT+9MaVtB/
 VRGCh6Yr
 n0lthFJRjB65P3uZnHyFGHnwW3rVTc9ABl3F+XxYLGDr5ca37U4iG5O1Fjq4iAQBAah94V0FVyjoe1TtLFL2rI9e1LKvl7dbe7bNhEjFVc1V1X2ynYSmRTwjTSVlSDwBJJ7RrkmG1/vc0PgVlyWzP6g71eR6NmaYP6JOFl+Og7VqfxRDmnhUYmqiz32YYCv5VLbrx/7z0C38Xlzz1/RcogriI89+nRPottjwv3pQEV+Pf3VR3E+Gk2PZiF9biln0j+OHHVnQ4bs5AB82HYzi6mVjCCJdYvuGRFajsbaRTtwSU8OaVFW8LU24xL75kQX3qOS0tCgj5ajLwC0AtyUuGXHowdowxzVZZhdPB07dhdoDLNQCt5YC6tLB0wpfCW7dRaGDGXmjhAgV9sQixPnvRY2THl2mpDzX1YjA0e6p+SU/QrRzLuSjvwdWHzWmFfTZEfG0Jgta1wY+pJb6uR4ib8KBCqJ0BToRS/9Fpxjco8YLX+bUmpqT36J6ldA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 10:29:11AM -0300, Luis Claudio R. Goncalves wrote:
> On Fri, Dec 19, 2025 at 10:31:55AM +0100, Vlastimil Babka wrote:
> > On 12/19/25 09:57, Swaraj Gaikwad wrote:
> > > On PREEMPT_RT kernels, local_lock becomes a sleeping lock. The current
> > > check in kmalloc_nolock() only verifies we're not in NMI or hard IRQ
> > > context, but misses the case where preemption is disabled.
> > > 
> > > When a BPF program runs from a tracepoint with preemption disabled
> > > (preempt_count > 0), kmalloc_nolock() proceeds to call
> > > local_lock_irqsave() which attempts to acquire a sleeping lock,
> > > triggering:
> > > 
> > >   BUG: sleeping function called from invalid context
> > >   in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 6128
> > >   preempt_count: 2, expected: 0
> > > 
> > > Fix this by also checking preempt_count() on PREEMPT_RT, ensuring
> > > kmalloc_nolock() returns NULL early when called from any
> > > non-preemptible context.
> > > 
> > > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> > > Reported-by: syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=b1546ad4a95331b2101e
> > > Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
> > > ---
> > > Tested by building with syz config and running the syzbot
> > > reproducer - kernel no longer crashes.
> > > 
> > >  mm/slub.c | 8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index 2acce22590f8..1dd8a25664c5 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -5689,8 +5689,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
> > >  	if (unlikely(!size))
> > >  		return ZERO_SIZE_PTR;
> > > 
> > > -	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> > > -		/* kmalloc_nolock() in PREEMPT_RT is not supported from irq */
> > > +	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq() || preempt_count() ))
> > 
> > AFAICS we can just simplify that to preempt_count() then, since in_nmi() and
> > in_hardirq() both are a special cases of that.
> > 
> > Any comment from RT folks please?
> 
> Maybe, for the purpose of this change, using in_atomic() or !preemptible()
> would be a bit more descriptive, as both macros check preempt_count()?

Hi,

I might be misunderstanding the situation, but my current understanding
is as follows:

__might_sleep will report this BUG if it is called with IRQs disabled or
in atomic context. Therefore, to avoid this BUG, it seems necessary to
check preemptible(), since in_atomic() alone does not appear to be
sufficient.

As a side note, once Vlastimil's "sheaves for all" branch is merged into
mainline, the local_lock_cpu_slab(s, flags); statement that currently
triggers the BUG is expected to be removed. Furthermore, the entire
nolock path in SLUB is planned to be implemented using trylock
semantics, which should eliminate the possibility of sleeping, even on
RT kernels. At that point, it seems we would only need to guard against
deadlock risks from NMI and IRQ, so this condition might need to be
reverted to in_nmi() || in_hardirq() again.

Please let me know if I'm missing something here or if there are
additional constraints I haven't considered. I'd appreciate any
corrections or further insights.

Thanks

> 
> Luis
>  
> > > +		/*
> > > +		 * kmalloc_nolock() in PREEMPT_RT is not supported from
> > > +		 * non-preemptible context because local_lock becomes a
> > > +		 * sleeping lock on RT.
> > > +		 */
> > >  		return NULL;
> > >  retry:
> > >  	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
> > > 
> > > base-commit: 559e608c46553c107dbba19dae0854af7b219400
> > > --
> > > 2.52.0
> > > 
> > 
> > 
> ---end quoted text---
> 
> 

