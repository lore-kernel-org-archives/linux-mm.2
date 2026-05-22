Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9591CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 08:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C79B96B0093; Fri, 22 May 2026 04:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2A346B0095; Fri, 22 May 2026 04:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3FE86B0096; Fri, 22 May 2026 04:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0CA56B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 04:46:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43C071C0770
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:46:55 +0000 (UTC)
X-FDA: 84794425590.30.C545AA6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9DDA4C0011
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:46:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YUKESoVK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779439613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2kKj5TUBkJ/lhKpwrX5zg7NzjXpzWJAzpXTS1fgVICc=;
	b=dphaEbRtdQ6v/OLqIvUvDFst7HtuxWB32VTznZNNiESdxGOIqVE8wao3wkG3R0pUN+yE8H
	8ZEmZxd1y3NbCYiM2MMbDxe6OgQjFVdyp2H2e9N31QopZLOo4TKV7OxoQ5y5fiRaPmIXay
	rD4aUm/T1CcC10Rro0nOfVW1JFKNOm0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779439613; a=rsa-sha256;
	cv=none;
	b=5dzOwdWoLGMBqbhirO/Ht7mC0KwzxT/ruz5iAZkbua5GRoZdrjWi/hLZBqpSofXorZbMrh
	mVUMcXezafGurOnJLHMnxoDT3TYltjjR1TuVvh7qwgQ+vmBeB1zC20Mi0ioioitc0dkd+X
	zYgMGfnOILtyQb6MeZqQtu99WbHGoss=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YUKESoVK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A156F43C8A;
	Fri, 22 May 2026 08:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913AC1F000E9;
	Fri, 22 May 2026 08:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779439612;
	bh=2kKj5TUBkJ/lhKpwrX5zg7NzjXpzWJAzpXTS1fgVICc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YUKESoVKquqC4dbfhsbG+HvacauCOzizSC2ClD87K4VvwII9MuHoouI4xV6+a4bo4
	 Hv6Ogqb0s11ambrct3s7TRpVCroOEefPc8TFLJ5+7tRb68ny8XBBckvNAye09lto6b
	 62apL/qdZ8Hwou2syulNQb0bVPXvLEWe0w0XGQ67shJQB70o2e8SvfkzUBLBWrPDz6
	 QgYa5ARg3iQF5F4nYKqEE6bADB4D2JmeQcZk0vqa7O3LStfFInwFlSuI3IFk4tmDVw
	 ha27UMDq77FAZF2c/4QvcGyBqEnxrSAF/A+3PFGRE1DTqzjdBXfVU1sppHgtG8XZcF
	 oM7t8g+UFTdtA==
Date: Fri, 22 May 2026 09:46:45 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-rt-devel@lists.linux.dev, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/2] gfp_types: Introduce a new GFP_ATOMIC_RT gfp flag
Message-ID: <ahAXO_XN1TYvq24D@lucifer>
References: <20260520204628.933654-1-longman@redhat.com>
 <ag8zX5KJUKo70TvG@lucifer>
 <f0f4841a-816a-4442-bebb-277984ee950e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0f4841a-816a-4442-bebb-277984ee950e@redhat.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9DDA4C0011
X-Stat-Signature: 7k5n85n4qwhdxx5i9hqs8qtxm1xbaycy
X-Rspam-User: 
X-HE-Tag: 1779439613-426331
X-HE-Meta: U2FsdGVkX19Ed4L6JRrxqZFscVNYU6tiJmG+6ySMNjdx2T6mifS+cA3zHrNMCnYHTnHgz6tiyVLtJMuGehLLkvw5rm4OxKSCNVZaDYCR5U5jLZhpx9+KAODHMKO+hjMwt05vRClwSIBd1bGgDi17IvlbPWrT8aBmMxLuRgT8W+XoYZj2wQMBY9zswa5KH/XhT+KG6tSRZBJWndp0599eDxQzq+kTvyk0ymz71I01sgbSANfXCglMY0rGoKMYY+rCIVyLjo94M+/rpswWxifIlq1ubHhHxAoxq3aElfHloyd5tdBUzV+dBFixrpXg4nqs0TTJSUzPJUJm2zeC+IYokLtfLwCXtiVmLh/SdgPh26QbG8S/mamHLEkSOflC7fiOPBAm3fXU/sKm8X5wmALnlR795L2msEGc89hxTfiUbF+KxZtFtqd+W6v/hXNw4HKVPtUbK9N+xFS/jsQKEAI84QSSx87UGmf7b3g+sqatRuut/FEUeBXLMXveui1mV0ltrO4MP/wBq3tl9BZBT32R4MZMFM6b/4L/gbRAYb+5LIaiRN1fM5lsmD24YHZXZr0B16+KDmf4aE9ayX/VAnYEgu/DBfvHkL5qkSUOt8adLsEU8tmQpJKYS/tqMTyxKYclg6DJTUv3nAHP5s5aRcQgFaoj0gRU6x+2vVDR8Lv6xhNXnsmop2ir6TccXyGE62+VKXedY3CozdWVuqlW+EOKNKiGWxMWsk/m7OYlcCqMW3DWWeZVQwHVsBo1WMrMBoCXDECO7CA/Zid1JSUA9J/5lljUWhqjUeGa8CG7aYk/WHOfeNw5oSZ2EsmxQmz15Qx7RwX8j4aKpd397rxk+SqmHDncN0nyaZs7ur9yb0NDPLRweOrXn+Lj+HKZ+OMEYJxD4pWkHH8+TjTWnS3tT61sSjKyN0E4bRoaLP/o+tYxr8XwiS1fCZBP5ISoPPJ4mzO4k0aWDzeEEmI+gpzWZmM
 233D3o+q
 K57DvAE8Sm+ZnEIzo5pU6kCr/RoL8OKkd1SDkEpJUT0pNllpMhaGx2WrrPgECGA5jkmxVHplBducQZesWKHqbAdmOWhWAYjxb7pkWTyN3w6deCZeTBrPCCH2om3zDz9aT/za7hB1Qwwtr0lMXeKLdC/yQPcRDiAlV+XuBDA3F9YY5hGdAKR09DQ4N6gAzJhggEoUph2whHymTbUZ9OkL62UpiQO8nOyq1m6WJCXXru5xZN5KfwMayJumm7gpCYTcMTd4k3Brzv8hA+ZGlBcUQBP13GDGxW9TKzJiofk0ocHSm98pPlTQ+2RNCBik2cGUFsiOe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 01:40:03PM -0400, Waiman Long wrote:
> On 5/21/26 12:40 PM, Lorenzo Stoakes wrote:
> > +cc Matthew who has fairly strong opinions on GFP flags and such :)
> >
> > Also, please don't send 2 patch series with 2/2 in-reply-to 1/2, use a
> > cover letter + have patches reply to that :) [yes it's one of those
> > subjective things that people differ on a lot but generally how we do in
> > mm]
> >
> > On Wed, May 20, 2026 at 04:46:27PM -0400, Waiman Long wrote:
> > > The GFP_ATOMIC flag is to be used in atomic context where user cannot
> > > sleep and need the allocation to succeed. However, it does not support
> > > contexts where preemption or interrupt is disabled under PREEMPT_RT
> > > like raw_spin_lock_irqsave() or plain preempt_disable().
> > >
> > > With the advance of the ALLOC_TRYLOCK allocation flag in the v7.1
> > > kernel, it is possible to allocate memory under such contexts by using
> > > spin_trylock to acquire the spinlock in the memory allocation path. This
> > > does increase the chance that the allocation can fail due to the presence
> > > of concurrent memory allocation requests. So its users must be able to
> > > handle such memory allocation failure gracefully.
> > >
> > > The ALLOC_TRYLOCK flag will only be enabled if none of the
> > > ___GFP_DIRECT_RECLAIM and ___GFP_KSWAPD_RECLAIM flags are set.
> > >
> > > Introduce a new GFP_ATOMIC_RT gfp flag for those PREEMPT_RT
> > > atomic contexts.  This new flag will fall back to GFP_ATOMIC in
> > > non-PREEMPT_RT kernel. GFP_ATOMIC can continue to be used in contexts
> > > where preemption and interrupt are not disabled in PREEMPT_RT kernel
> > > like spin_lock_irqsave().
> > This seems like the wrong place for the solution, now we have to remember
> > to use a specific GFP flag but only in one specific place in some IRQ code,
> > yet RT is fine with this in any other scenario?
> >
> > This is really confusing.
> >
> > Wouldn't we better off with a way of actively detecting this context
> > somehow in the page allocator?
>
> This new GFP_ATOMIC_RT flag will make memory allocation more likely to fail
> compared with GFP_ATOMIC. That is the main reason why I think a separate
> flag with documentation about this difference will make the users of the new
> gfp flag more aware of what they should check before they use it.
>
> I would certainly like to have the mm memory allocation code to handle it
> automatically if it doesn't impact the failure rate.
>
> >
> > It just instinctively feels like this is the wrong level of abstraction for
> > a fix here :)
> With PREEMPT_RT, GFP_ATOMIC_RT just translates to __GFP_HIGH. It can be set
> explicitly in the relevant call sites. This patch is more a documentation
> step to make clear the purpose and consequence of doing that.
> >
> > > Signed-off-by: Waiman Long <longman@redhat.com>
> > > ---
> > >   include/linux/gfp_types.h | 13 +++++++++++++
> > >   1 file changed, 13 insertions(+)
> > >
> > > diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> > > index cd4972a7c97c..ac30882b6cd4 100644
> > > --- a/include/linux/gfp_types.h
> > > +++ b/include/linux/gfp_types.h
> > > @@ -316,6 +316,13 @@ enum {
> > >    * preempt_disable() - see "Memory allocation" in
> > >    * Documentation/core-api/real-time/differences.rst for more info.
> > >    *
> > > + * %GFP_ATOMIC_RT is similar to %GFP_ATOMIC with the addition that it can also
> > > + * be used in context where preemption and/or interrupt is disabled under
> > > + * PREEMPT_RT, but not in NMI or hardirq contexts. The allocation is more
> > I'm not sure 'GFP_ATOMIC_RT' really communicates all of this information.
>
> I am not good at naming. If you have other good suggestion, I would like to
> hear it.

Haha herein lies the pain of naming - I am not claiming I am great at naming it
either :P

But _RT feels way off the mark for sure.

I mean in general, I'd rather we not add a new shall we say GFP flag alias? You
suggest an alternative approach in 2/2 so I'd definitely encourage you to
explore that first.

But if we were to add this, I'd prefer something like GFP_INTERRUPT or such? I
mean that's pretty terrible too... but something that points to the key feature
of being usable in contexts where preemption/interrupts are disabled.

>
> Cheers,
> Longman
>
>

Thanks, Lorenzo

