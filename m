Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D964CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 10:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48F236B0005; Wed, 20 May 2026 06:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467216B0088; Wed, 20 May 2026 06:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37DFF6B008A; Wed, 20 May 2026 06:01:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 292266B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:01:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8B9C1606A5
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:01:50 +0000 (UTC)
X-FDA: 84787356780.05.D6BC889
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id B8777120015
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:01:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=enP56z8g;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779271308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j+vsRneuQukq1VCZsxvt5EboIhJTKy6gqyaaIC0kDxc=;
	b=VqYop9sbtqtGlkSjOfipPo588aek/1H7oZck8+65KNeDSGFFCS8qjGvYfIcMqmnksPxOSb
	ZXaPHrEabqTC6nYr83mq+ziQxo9YTfZrHxM4NSj2zfmGkzWF7708z5MO87iztZ8HhgiWNy
	0OnwPJEKAlxMHu0rykSQBnzBikOw9zk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779271308; a=rsa-sha256;
	cv=none;
	b=eDNW5KQwDsz4jeX804BuFQ7kPRoMBIZhm3SrjOrz0ZRAi83cCvGTPRbWogjEGSd4Kd6Vxe
	XvidQnh0d4rsc28SePJKJoYOArXkwcA7aHgrtRJDGNYCUlLxGio1ejNu8mwby+W++LtPeQ
	XDXpUR0Of1sbNGkQbxqg3J3yb5t3HxU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=enP56z8g;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.178 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-38e84ed22bdso57198111fa.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 03:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779271307; x=1779876107; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j+vsRneuQukq1VCZsxvt5EboIhJTKy6gqyaaIC0kDxc=;
        b=enP56z8g6fspU2bvGalO9Y7ysVV+l1k9a+tkheTIEwpyTJEGdEKi0xILXExNgq+iGw
         d1yjk5yn2WigWYE+UYbDOVIemj3MBXqaBFjnBmsUYUQ6EqBlPjJX+F7itUixTNmMs2D7
         1cIM6IYKsH7M1DbO0wO+FNxGhLm8cNn4C0M2abYa5g8J0vZTvskWgKPJuXM0U5PQlsYg
         jCjtxStH8p5EvA46tB+su5RVXGs9RE416vOO7G5FLUrIbjXmZZsSOb//leqQwJS+9c3l
         cOymgA8+jdqLU6M7we5d+K3HlPmCKPJC8ECnnhlGEbfSR8uxt8tuyowEbO403hfH0gmf
         zoiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779271307; x=1779876107;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j+vsRneuQukq1VCZsxvt5EboIhJTKy6gqyaaIC0kDxc=;
        b=b21jEdxcNmq+/WyCVV5o1nkGDJ3jwFsOtookfD3DsIcM6xRPfFdhd424T2fmuCj3Zq
         zW6zYW0agF9UAwv0IWhRKbPzqZ3NTdctd7Zls36TRD4NlYfSGSZoY3MT9GfPrM77KWuh
         I4YqtQCkQ24zr7aq5Et7vlLvpA8dxx3ZhqARB5NajG3HKYrNHBPg3TtxENEg+d6izNQx
         8PX1lyr3ZbrGVoQbwpOBjzMxNliI1Dj6HdPleyAvyCIPwHhNYFylq3wzkj+jGwxx5kqZ
         zyBZwXhet4LsiXqXsroAMpABEVdFQPBVRF7qSLyfkXvTBosJ0BesL09O8D+d01q2T8v5
         5kBA==
X-Forwarded-Encrypted: i=1; AFNElJ9PD8x+0E/2UKq1+bNZXumRCco2s3l3+zCJHeFsodhmDRsLAaR0O5uSnXtghblNjHByXaSg8+F8fg==@kvack.org
X-Gm-Message-State: AOJu0Yz6MfOgQJ/7TGvNVvZ9wmajUYlBJ06d+tWNw+YsNsRWQmytOQpo
	nnMMRc0+D3kb/bckBLNr0a7ePm/HD23CKh1/4OGOus7GGJEnRnhf+vZM
X-Gm-Gg: Acq92OHk/60yJbAoMs5yKq25z02b34nyqJONo4nR5VZ0cCXBArbsEPRzEoP+KDIWZsB
	78sxCzGOCi8hARO2RXRN5pmlHTS+cQzND9wpegZE4t36EDCAD5UbpVqLVvLKznQn4qV9fH2qjLG
	FaAZifTyLZVYvgqW14OBJSRLt+BgpmTyK9IF7bTb48d5GNxS46cgWEZiLlwjL0QCh+N4BfUMPzm
	4i5hFuOk2gP5QjuO1PysqMsT9WN13ZxzQlCFgMUWt9chO0YgGpeJ9q8Azi0XEL0ZzjbpI4MwjP8
	ccoO6BmAtUGQuBbrgA9lR0Y5R0MiHLferLaAuegRNiEfHeEr638pLkgHE/hHTOZzDI1W40W3kTS
	NMW4nHR1Ekmia8oJqWQExlXyUxDlLD9xxd/xhlGTvG8eCEZl/cWYdSyS25wxD/q9B
X-Received: by 2002:a05:6512:3b96:b0:5a8:6391:4fe5 with SMTP id 2adb3069b0e04-5aa0e7647c2mr8015525e87.26.1779271306104;
        Wed, 20 May 2026 03:01:46 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a9164cb606sm4795698e87.63.2026.05.20.03.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 03:01:45 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 20 May 2026 12:01:44 +0200
To: Harry Yoo <harry@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
	linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [PATCH 4/8] mm/slab: introduce kfree_rcu_nolock()
Message-ID: <ag2GiLJSA2Rguxf3@milan>
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-5-harry@kernel.org>
 <aejeVK0J_jHSfVhD@milan>
 <aemevSofweaUSx0n@hyeyoo>
 <aeoD_Ts6hLsgNc9-@pc636>
 <3s4jafam3la72a6y3dkfvhtzxk3fsngb2cka3bpfqrirl5m633@pz3vzizefoxb>
 <afNG0jNQNYeZ940g@pc636>
 <82d2145a-9b41-4ee4-b980-e7bd5d12f035@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82d2145a-9b41-4ee4-b980-e7bd5d12f035@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B8777120015
X-Stat-Signature: bwninwo7nfwi8irwsgm919xp93stjpog
X-Rspam-User: 
X-HE-Tag: 1779271308-220539
X-HE-Meta: U2FsdGVkX1+fEsil6wKthtGZ7aRpqDClsUBXgSjXRr8bfziysW02X3AoZJHeWtD/iiIZebO6yUsdTGKjKcH0+ipAF+mOqceIKYMHF3oGfdhfSjlwCO1Cng8nPhCy4GgiWll0Z8ZwFCG3wpe0a3yF0XnK0S2KEJ3Az9APLZIUMT4OUmpDvZO74pxF6vdCd45RW0tgWQgSWx5J8dY/mhynsyAo6b/Eog8iA5dEWKM0Z3TUQ+TIZ8H4gYZI/2jfSIbQauUfv12JJ7ZPwKMLYXPhzU3UkJ85NtmWGRcdCw6k2z+oDuhW6MbK8/m++N7uHFHY9zg1obnQLlXfROaAEzOpuq+s3PV5JNesthod2d2LJFFHAA0ozYhQEXgc4niol/yx6dD+RUnN6PWtYevq3VYfmSqxDgMpDPLD+zNqncMgK3m5jNQMpDSfV79c+qW7bPMRIvZ/2ES+i4top0PhK56sNY0/py+MHvYIK93zLwuYASwMSt2ZH14hJN/1EbAXA8+pREICEoThCsEMDSd6CN/Tw9eWz5cYd4RGwZLCxbwqGm5yLL/r2dnqbeuO7sTSUa03XJfZOcAFmXch3HPdKDeCbnqcI4bkdG51rpGPzioYmfG/smekyzq5fADFb3OLyDtkXOpqv1h3FKcyLKMWn8gu0LawWQTVfGJ+kIWpNYFX4ggrnoFOSMtJvLwpxhTLv+uQi1L53fs8pLSxRq5G95k8LX1jkwnQrrv6PqeNHlnMJEm6N4CnItF4c+tME1Qu3zNoykrQwN0BKN7YBH9EcENk5FDRlszCLZgI9PPX2B0891MyYOBKigZWsmFD2R5OEz+qcJzB+AuMV0mqIMjjVLTt1pDXa9BaFAOCRmhVWIC5qjg+UbYnDCvzWLIunh+FKq96Rv38VkFK9GPI9QHynCOzExcaFngMXM/Ywdz7iQAp92fXX7RlKZHo9aB4v5ERnpRGThMiLYj97RozgwbPjnA
 FLpmlZkZ
 nLSA62f4o2FOaENhqPxE3Ywz2eZ0utvrv11kyLczJ9Ue/MNS+CqYEDlyqHd7IscxrBRxTjLCJ9c+nqhZI/sB1ox1pHIakpZdfr2abZEUfBFqxH5Qu1wNR78fQYb1u7gEo62UaVbq0RFOpjGiKjRTbL8tMb3XThROeoxM9UaxHIpTcFjSNY8h04YMu62ANajWoERgc2pX1WAeE/OY/aQzRFale8ENtWSLIMF5MPAd5QTnWj2liFPdHAJKgSuvHXUnHv4boyAW3RWrvG4XqMR25XOih6oME0s1rih1RzhpYBoqcWfq7XMh6jAmf8jCyMQ7W6JY7b3Ugr5+Jg+aDQAPoxjztXUkIqSD8VBrEdBt3NOq2ycQPVlc9Ek8u0FY3WMU/WHfiOBGyb8Xh2R1Uf2qt1RWn3ccjJQyKk/VOo0/rd77+9YaCLbmUVRJYxe8KODe91tz6z9hrBDYo9h2yrq2Js1iill9UUGPSclNCfZMqVmkxDcODXdQgwUuRT7eIR9nAy5ulr6ZOk/6LdnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 04:44:30PM +0900, Harry Yoo wrote:
> [Resending as it's rejected by mailing lists due to my broken email
>  setup. Apologies for the noise.]
> 
> *shows up late again after LSFMM and processing some backlog*
> 
> On 4/30/26 9:10 PM, Uladzislau Rezki wrote:
> > Hello, Harry!
> > 
> > > 
> > > Hi Ulad. Apologies for the delayed response.
> > > I meant to reply sooner but sidetracked by other issues.
> > > 
> > No problem, sometimes i also can lag because of other tasks :)
> > 
> > > Your questions are fair, but let me try to clarify
> > > the current situation.
> > > 
> > > And before diving into details, I would like to reiterate that
> > > there are potentially two points to discuss here:
> > > 
> > > Point 1. Can we justify complicating subsystems by passing
> > > 	 `allow_spin` parameter all over the place?
> > > 
> > Yes, we can. But as i noted i see some drawbacks :)
> > 
> > - all new incoming patches have to respect that new third argument;
> 
> That is true :)
> 
This is i would like to avoid :)

> > - the fallback mechanism which uses irq-work is not optimal in my
> >    opinion:
> 
> In most cases it would not fall back because most likely trylock would
> succeed. If most of the calls do not fall back, a bit of suboptimality
> on the fallback path is acceptable.
> 
> >      a) We introduce an extra window between queuing a pointer, mark
> >         irq-work to be executed and then reenter the kfree_rcu() with
> >         no-sync flag and now we need to wait a GP for them. But the GP
> >         might be already passed for such pointers. So we potentially
> >         need more time to offload. This is rather minus.
> > 
> >      b) Since it is for BPF, allow_spin is always false, thus only
> >         fallback path is used. Decoupling comes to mind.
> 
> No, allow_spin == true means spinning on a lock is safe. If allow_spin
> is false, it would do a trylock instead of spinning, and it is expected
> to succeed most of the time. As long as trylock succeeds, it uses the
> same data structures as the existing kvfree_rcu batching without fallback.
> 
> > 
> >      c)
> > 
> > Why should we mix those? What it is worth to do, is to prevent mixing
> > "unknown path which is for BPF/others" with generic kfree_rcu().
> 
> Because we want to reuse the existing kvfree_rcu batching infrastructure
> without reinventing a new feature to do the same thing.
> 
> The intent is to avoid the fallback in most cases when allow_spin is
> false, with fallback being there for correctness.
>
The problem is that, it is a random behaviour with trylocking, i.e.
it is not deterministic. If you apply some noise you end up in kicking
two paths anyway.

If the idea is to reuse "existing kvfree_rcu batching" you need to
access the array in lock-free way. If you can do that, i would agree
with it.

> 
> > > Point 2. Can we avoid adding this complexity to kvfree_rcu() and
> > > 	 let slab handle it instead? (as mentioned in [4])
> > > 
> > it depends if BPF people want to free a pointer using RCU machinery?
> > Do you know if that an intention?
> 
> They want to free slab objects after RCU grace period. Freeing slab
> objects without involving RCU is already supported by kfree_nolock().
> (There are other use cases as well, as recently posted in [1])
> 
> I meant RCU sheaves can handle freeing slab objects after RCU grace
> period, and kfree_rcu_nolock() users don't need to handle vmalloc pages.
> So technically we don't have to add this complexity to kvfree_rcu
> batching and handle it in slab.
> 
> But to do that, we shouldn't disable kfree_rcu_sheaf() completely on RT.
> Apparently Vlastimil has a suggestion to address this, and I'm going to
> digest his suggestion and explore that aspect.
> 
> [1] https://lore.kernel.org/linux-mm/esepccfhqg7m6jo76ns2znj2cnuaepx2xvw5zaygtwohq4psma@563ypprp6rr3
> 
> [2] https://lore.kernel.org/linux-mm/6811cc17-8ee4-48c8-8cbf-6bf4d9f98162@kernel.org
> 
> > > On Point 1: IMHO it could be justified, but at the same time I hope we
> > > end up avoiding more complexity in the long term by working on Point 2.
> > > 
> > > This reply focuses only on Point 1 and explains why it could be
> > > justified.
> > > 
> > > On Thu, Apr 23, 2026 at 01:35:25PM +0200, Uladzislau Rezki wrote:
> > > > On Thu, Apr 23, 2026 at 01:23:25PM +0900, Harry Yoo (Oracle) wrote:
> > > > > On Wed, Apr 22, 2026 at 04:42:28PM +0200, Uladzislau Rezki wrote:
> > > > > How much performance do we sacrifice compared to
> > > > > letting them go through the kvfree_rcu() fastpath?
> > > > 
> > > > Freeing an object over RCU from
> > > > NMI context is a corner case. It is __not_ generic.
> > > 
> > > First, I want to clarify that kfree_rcu_nolock() is not just for NMI
> > > context. It is intended to be used when the context is unknown (because
> > > it can be called in an arbitrary code locations).
> > > 
> > When we say "unknown" to me it sounds like a worst case, which is NMI :)
> 
> If we say "allow_spin = false assumes the most restrictive context, such
> as NMI context", that is misleading. It sounds like we always fall back,
> but we don't. Even when the context is unknown, fallback isn't required
> most of the time.
> 
> So I would like to say "the context is unknown", meaning that
> technically kvfree_rcu could be re-entered in the middle of kvfree_rcu
> and we need to be able to handle that for correctness (although in most
> cases there's no re-entry and no fallback).
> 
> > > There are two kinds of problematic situations where BPF programs
> > > are attached to:
> > > 
> > >    - 1) a tracepoint or a function that can be invoked in a critical
> > >         section (w/ a lock held), or
> > > 
> > >    - 2) a function that can be called in an NMI context, which might
> > >         preempt an arbitrary context holding a lock.
> > > 
> > > While 1) and 2) are not (I think) dominant use cases, and although
> > > most of users can legally call kvfree_rcu(), BPF can't use kvfree_rcu()
> > > and must consider the most restrictive contexts.
> > > 
> > > > We even do not have(now
> > > > in mainline) users because we never support it from NMI,
> > > > just like call_rcu().
> > > 
> > > Unfortunately, we've had this use case (of allocating memory for BPF
> > > programs) for a long time in the mainline. There are two current
> > > approaches to mitigate the limitation:
> > > 
> > >    - 1) Pre-allocate all memory. e.g.) allocate all hash table elements
> > >         when creating a BPF map, rather than allocating them on demand.
> > >         This ensures correctness but sacrifices memory.
> > > 
> > >    - 2) Use the BPF-specific memory allocator [1] [2] to allocate memory
> > >         on demand and avoid preallocation. While this wastes less memory
> > >         than 1) and also maintains performance, it is re-inventing yet
> > >         another memory allocator.
> > > 
> > >         Also, the allocator reinvented kfree_rcu batching as well.
> > > 
> > > Now, we're trying to avoid 1) and 2) as much as possible and use
> > > kmalloc_nolock() instead [3].
> > > 
> > > > If BPF needs
> > > > it, then the first question which comes to mind is not about performance.
> > > > It is how to support this case in kfree_rcu() without adding noticeable
> > > > complexity or overhead or hacks to the generic path without making it harder
> > > > to maintain.
> > > 
> > > Since there will be only few subsystems that needs it, and because
> > > they already use it on production systems, I don't see much value in
> > > maintaining a simple implementation if that compromises performance
> > > (and thus make the transition harder).
> > > 
> > > > Performance wise you noted, you mean:
> > > > 
> > > > a) call latency(this is probably the most important for NMI)?
> > > > b) memory footprint?
> > > > c) pointer-chasing overhead?
> > > 
> > > I think it's either
> > > 
> > > - The performance of kfree_rcu_nolock() itself (a), or
> > > - Not distrubing workloads running on the machine (b and c)
> > > 
> > > depending on what people use BPF for.
> > > 
> > Are you aware of any specific workloads which we can run? To test
> > and see what we have when it comes to performance metrics? I mean
> > exact uses cases with exact steps who to trigger them?
> > 
> > That would be useful to see on behaviour.
> 
> I'll share once I find what BPF folks are using for performance
> benchmarks. (Which means I'm not aware at the moment :D)
> 
Please share.

--
Uladzislau Rezki

