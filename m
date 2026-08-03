Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83ABCC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 749566B0095; Mon,  3 Aug 2026 11:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FA786B0096; Mon,  3 Aug 2026 11:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60FF36B0099; Mon,  3 Aug 2026 11:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 308826B0095
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:30:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 993BA4074F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:30:48 +0000 (UTC)
X-FDA: 85060345776.20.D190B97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D5B85C0010
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:30:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H4cM7EkQ;
	spf=pass (imf28.hostedemail.com: domain of "SRS0=EL+k=F4=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=EL+k=F4=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785771047;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o2DlwFFQ7c69iQDGWX5wN0uky725dmGY92UH68gtyxg=;
	b=uwxociWJ4k6ktj99Op5RGRjdELu8jzwJ0XY4ex1RMpZKAlCnzcBqO9WY2IqLgNKwUu45BS
	z3js5G6QLvrAVJELRfFeb5gYecxS0W/YBIdfNJ+cLrKllsoxzNNhY64DLQb2jiUnPZqeVM
	sPqn803axR+QewjSit3u6mzwX+2sp6w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785771047;
	b=xp70Nm3W1n1rl4oNmTZYhD9h8yYHPbWU/FTe6bqhS6+oTbjnSY7vsbh5EFUqMJrb9jg54W
	toqEiUaM9sBmuqJT135G78wBijYNIoGUSPrEmUfqcyetrFTwcB80KOnwdVt38vj55KsYN5
	rTwk/zqRJFRtvya6pfpIwpwAFb/HPn0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H4cM7EkQ;
	spf=pass (imf28.hostedemail.com: domain of "SRS0=EL+k=F4=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=EL+k=F4=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E1DC42AB1;
	Mon,  3 Aug 2026 15:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298C11F000E9;
	Mon,  3 Aug 2026 15:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785771045;
	bh=o2DlwFFQ7c69iQDGWX5wN0uky725dmGY92UH68gtyxg=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=H4cM7EkQ3LmPnIVD1B4GJPrQpM2/VvFq8kIOmxYWwzqFmWEeC6Aai/uUHOFR2oVYU
	 NkSD9sg5hBgN/+MI/7ehjvmlgr+eIkgn2erHgLklpwfcTq4GGttuYAvl3VryS3HCeq
	 Io39nbVKt229iLOwbCp9l0BFsxkmxaRgfPVavAqpRbIvdH3cF5gSSPhZ3aG6ePv+EN
	 pVwxi5ttwl1MX6NnXocv7BT7A2un7C3dByDMUt1GXjmCoh98IjcV+mKUD2ie8hXhcM
	 Yb4nmBeTNFuZ3otl7WRCz4eOZM21QKunTtRJNrS8sguLSFEjuWCEpCums446vZO1K5
	 1qxxlyS3nBzwg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id E7F0BCE19B2; Mon,  3 Aug 2026 08:30:44 -0700 (PDT)
Date: Mon, 3 Aug 2026 08:30:44 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: hu.shengming@zte.com.cn, vbabka@kernel.org, akpm@linux-foundation.org,
	hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
	roman.gushchin@linux.dev, ast@kernel.org, andrii@kernel.org,
	puranjay@kernel.org, ameryhung@gmail.com, bigeasy@linutronix.de,
	clrkwllms@kernel.org, rostedt@goodmis.org, frederic@kernel.org,
	neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com,
	josh@joshtriplett.org, boqun@kernel.org, urezki@gmail.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, pfalcato@suse.de, surenb@google.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH v5 3/8] mm/slab: use call_rcu() in unknown context if
 irqs are enabled
Message-ID: <03f04f1f-97c2-4800-b73c-23460ef15466@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260729-kfree_rcu_nolock-v5-3-a28cdcda9673@kernel.org>
 <20260730192119586UvhYMv4xrNqaZLKIJH9X0@zte.com.cn>
 <anBAiTl_16H7NqEr@dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anBAiTl_16H7NqEr@dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D5B85C0010
X-Stat-Signature: a6nopmakuttnia9349mhiy5i77myej63
X-Rspam-User: 
X-HE-Tag: 1785771046-443669
X-HE-Meta: U2FsdGVkX18a0Ls1xT17yNF31ujE9lV8s5H5mdXYJRoT6/VXEmlgNvxVLujrG1IEUa2VFfceu9sCo4PQL1GqKAMhRh8/uvjBXO//45/+RaIYC8l+WJo4QVWNnhqqZZ7pi9ZUsIOxHelFfz2I7n4kJcX3RkKMg//CCxojhq8xN9rpf8F91rV97nVqwHMfsaaWvVmmIdWPZ0qJy2U9C/VEpimDwi4oSkSmPGLxvOIvt6wG8mQ4HQBxfz0lI1IERa5BZPDJNu8NsO2Pg5h9eYv76HtnyJUiwQkZzFpW/9CR8LOXKhn64hzqJkqwGVeV5C+63aRA5bKCOHEikGM2JcPomR/1SXdLK0eaUrSho9fYt8Lk67UF5rNSS/CP5OUIiphqK4dMLa5t09UdSCE6BWwtBn/1wXlM/tiwsd3RpFrCBzY3OyM8vKM/hlv5pTpYp/HD4OadFqWS4umRu3NmplbRUCv929B0ph4s++NRnQqc/B9K7QB5MGQb+3a8hT6KItt/mvv9BdQ+9Y+C0yPwpcVe+8ESmWujLWkgixT6Z5n0kWPbH34N4uDI/4tLti/greBw/LKtK6PvU/yVVTxnesEf7NykkcPfDhjzoLN2e/q3kJOEOHkxIcHsmrhlvmmQ8Dt03n94QoA90lzK/dKRzyagQLDIu2oVSPW2YulqvkEnrCoaqeNNux8/RXsUKLP8kOwHXGF3OD7y4k3pLrSIHqGvq6R2r8/Oe8qBrqolJwbOo1lNjHTgty9lJCFBYbSQ6BLYXMKt2VxG+dq893u12E6UUh/knrfNdLe/nsFg3wqMNPLj6Xd/Z2Dgfh8CLHsbMOvtTmem7dKlN3mpW+Bg9slczrps2F1dLDS32R+dFseTibe4ZZ2AGKI+RzQAB0FO/IwwESRCNyc9/C8JvJAQbZw+KtleIHRel623NuBHg5sTiBazcqPE0YZTy7xCG2N21VJmb/xpT2TYwfcjjyqwYN/
 4y/b7LyU
 cGcVq2bJrMZIGDTndpukl2USHGJhXm+gEFelHAYTGclS9ee1DmbhTGtfses1v2DBsn4P5Ud70rdCW/uh3vs5yQcMC3erMmuj0f3yioRDZqvz62fnELL8VV0aOJsvELOrF+cj7foiIdZMlJPWa40QD8DPgUNea4gJcitZ6YJkYx9Mf3VlbA44AbZ8Jr6EAfYBXGlQoFeUhML4wsuWgoSokG6mpkbXCkxbIgYAbOdY+V3O+DMbCKzKOvWPUUZV0zRWhPfFHfTUXbeWBnByDWCdMLsGlCpLGg4l9FgmFLb5CUiDduGBJ3zAqzNTEpY7+ULmhvORp9GJGu3v3LWRlhDdEAM7IQspLRmOw3fPoUBXoHCUNxF33ZAoaVbZPcQjxQlbLGWiQPUB4KmypUZ9yrT/9y/lujm0iK6oSyx21umYN5Eu+Z/DIMyyCAJhOrcsT9NfwLGBHLF0Zx3zkG/uFMKu19sTYPPd750k0xp2F/Cmsz9k1WAmxhoVZ10LMRggAQuYZ5M3KWXxZETJkBednPRFPmLWRIrO+KFjkO19LNb95dK1PcLLsYoeA0pJp6jqM2lx67LzxwD7WiQzSy7KBmGvYOUFSZgbPzi5wIOI/h1ZAtUzBGcOAwrb2/mSW2aVvsmrZ2fyZomHZ6Fq6pkmPsZrP/Ovbns1itRZNGJSZsbg3xTDGeV6xTrgntyuJoYDFoEavgh8GRzXhZkcDt5jiY5PuljDRF/rRpGCHJyO1+4U9at3Es3AXnseWxhOjsTI2Zb44AA6DIXxtadSo7yNvrhhvav/CdpGiMB0EgZ1S5Wkcay2GVBL9sWjOv4Hbaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 07:19:32AM +0000, Harry Yoo wrote:
> On Thu, Jul 30, 2026 at 07:21:19PM +0800, hu.shengming@zte.com.cn wrote:
> > Harry wrote:
> > > call_rcu() disables IRQs with local_irq_save() to protect its per-cpu
> > > data structures. Therefore, if IRQs are not disabled, they cannot be
> > > corrupted by reentrance into call_rcu(). So fall back to the deferred
> > > path only when !allow_spin && irqs_disabled().
> > > 
> > > The RCU subsystem does not guarantee this contractually, and this
> > > optimization relies on RCU's implementation details. Ideally, it should
> > > be removed once call_rcu_nolock() is supported by the RCU subsystem.
> > > 
> > > Link: https://lore.kernel.org/linux-mm/CAADnVQKRVD5ZSnEKbZZU7w86gHbGHUug2pvzpgZTngNS+fg4rw@mail.gmail.com
> > > Suggested-by: Alexei Starovoitov <ast@kernel.org>
> > > Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> > > ---
> > >  mm/slub.c | 8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index 2c5ba8c326e7..bb0f2975c95b 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -6157,8 +6157,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
> > >      if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
> > >          rcu_sheaf = NULL;
> > >      } else {
> > > -        if (unlikely(!allow_spin)) {
> > > -            /* call_rcu() cannot be called in an unknown context */
> > > +        /*
> > > +         * With !allow_spin, we might have interrupted call_rcu()'s
> > > +         * IRQ-disabled critical section. If IRQs are not disabled,
> > > +         * we know that's not the case.
> > > +         */
> > > +        if (unlikely(!allow_spin && irqs_disabled())) {
> > 
> > LGTM!
> > Reviewed-by: Shengming Hu <hu.shengming@zte.com.cn>
> 
> Thanks a lot, Shengming!
> 
> > I initially wondered whether in_nmi() should also be checked here.
> > However, irqs_disabled() already covers the relevant reentrancy case,
> > since call_rcu() disables IRQs while modifying its per-CPU data.
> 
> Exactly, that was my reasoning ;)
> 
> As a side note there is an attempt to do this in call_rcu() instead of
> slab:
> 
> https://lore.kernel.org/all/20260729162207.1567770-1-puranjay@kernel.org
> 
> Just FYI.

Why not both?  ;-)

(Sorry, couldn't resist.)

							Thanx, Paul

