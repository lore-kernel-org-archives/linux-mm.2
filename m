Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0505F606A328
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 18:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FpVt81lu
Received: by kanga.kvack.org (Postfix)
	id 1016D6B0342; Mon, 19 Oct 2026 14:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B3276B0343; Mon, 19 Oct 2026 14:49:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F32206B0344; Mon, 19 Oct 2026 14:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D42F06B0342
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:49:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4CC9A407AE
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:49:14 +0000 (UTC)
X-FDA: 85340263428.01.BE27C9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A9AC640003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:49:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FpVt81lu;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792435752;
	b=v1xjkJNGqcMoBSRqa9dhdQvxU0+7WhzkNqpyTfnVEgJtvELTYvdJG26PlpBEd8Pn1VNsaf
	+F+rnEbhbvAZT3kgkwXepQ8bZTNuAVhcF0ajONQQfXfCRZaLiuCjb8XPivCC/8ti7tnmpl
	tdW+OUpXpX3GMvwS/QoMEVmwss5JTzY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FpVt81lu;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792435752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=odoauVdJqWqaAI8ZwIV7KjQzqBjqQDbAw/30Cb/fZ88=;
	b=anhqBUe+2tB2zr+qkNoowAG8n/w/EO3/tyjkPnNGGxHB//pd97NQPb7E1ZeB/FbywBQKFL
	fQpndPhFThxSgvdUODQ34Xr7UW66IK7V+wj5IZZOCpVihnqADRm+mRmO8gRHPvTcVpN9k+
	GQHC/VEiXXheG0qCo8oxKKDLDHsKtQI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA976410BE;
	Mon, 19 Oct 2026 18:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244821F000C5;
	Mon, 19 Oct 2026 18:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792435751;
	bh=odoauVdJqWqaAI8ZwIV7KjQzqBjqQDbAw/30Cb/fZ88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FpVt81luKpgl1WbnJJ7TGOrqiFGvJE3Vp6obqv4BfKFwpY83JjR22wBTyq00DpteV
	 Yn5OVnKkHlnjGjCrOznxDdU7mpGANQof2eWfxPOKPb2PltMjR5Xk9FpmPFOihIcyqZ
	 6A4+TGeNbwggf80qgkj2+YogHGG81aFViwNYLz5nmpdPhfOtGEMT+p9/gRYiaGQxiL
	 9aeS6k3X6WcPE/UvlwrmOsk7H1p8uGmpJsLUqR19zfRQ57SuTDIBn50er8OPHButkz
	 zyFMD4MF4QFuSmtQk7gDLFY0NdpysNqdbseTNWlKW88MI2mWQBma+YdXSicarCtQDs
	 GSnP5tFu7k5+w==
Date: Mon, 19 Oct 2026 19:49:09 +0100
From: Harry Yoo <harry@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/percpu: clean up callers of pcpu_obj_full_size()
Message-ID: <atZiXtW0rmiQLEB8@thinkstation>
References: <atZWW7V0MI--HOke@thinkstation>
 <20261019181628.2113224-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019181628.2113224-1-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: A9AC640003
X-Stat-Signature: df591oa51epx4onxb9bdfo89rbho6z4s
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792435752-184371
X-HE-Meta: U2FsdGVkX1+I1C9s74cQxZTrHMGz7DWUaFFCit2HvgIkzRWuV17pHT0i8XZ47Kxmj+lCK0pHWfcW6qdl0cTJwdplhBWR5IxO08PGtUDX/tN4ynG1pfyi1yHfKOD1E3gFRRlufC1JhtBAReDmgwU2YM42eXVHCZSO76pZz07NQTQoyQAsw+cq5mXdGjafmlEVH6H+f91Lx+oQtj179xCEPhBz8uxq5sfITUOnMk5QuW/WYsujmRH4Hv4/OTcVzfqigTQJeinHvio3pjyffp4RO1t0oTDXYpnX/JCwrXrofy9EzQ2cAu3n71oFOVH0jxpfJXix70zT8pZfkGZYsQMhZdlW6mG3XZ3Br0+74ERZNWTGNk56PQRpTF48afmC1jFwzCTDQqeL0dWQjsbQrVAnzzMz5SKENKUXV+2LFvlEBuumTKeo6T8YpNLFchUZQebxPbvo87ykwBJ8vB5PG3npqJTFYNQHERowvG+LnwVGUX2StQ8Xh5V+tSuVelKDsfW/szskPab99sNbcavzq5fRlfmHxGDqeEx1zW7ngBVQfKQnV5Eajhmdf7+nCbRQ2XDeArm+Jouv2QPD2JR/x+aumPbdCxpWepivHMlObgDmXw3Xf06rQAF3R2IU0fzaaU7K1P38ccwgvYng26OYHwGjCVqWWGngJ4L+N0qBun4Z1+A2YO8SFPqtUEkvvHJA0IAwx30W6Yii2fegkuJQln5jDlVPfP9N1Rw7SeRLdY0TvdmziC79HdXPpn5yS1j9OdeUxvFdTGos5ZVKaQsDiAGD+JT86RnRw5vWJTDB2pKxov2hrGfqWDU8xRudtB3ULRlSc2EVK+6znuZpj6Y21dmlbswi/4MPpDSdLHth7/HI7DiMK4qRGBvzbEGX01o8JjNoKe8KxDLPTBvbawFwst8kfZynx0X58M/3K754jXbjrqgnJX5K80z2E8EK1PXtiitCPehlma5gbHauX6o5D0X
 THAlev3+
 zlERiDYEFENYYLemCMoQOHxyarMkcntJJ7wZOmRE9lBtpHvvPD7rMxGACIrg6ZIaiwXayjRHVZwlmLNDptCrU4dHiiAM4n1whwwbxj5DFpcJtXxDaDkMawo0zdaMPn8DWrkIc/iR2/wQ4eezvGIvgU1yprKGgac9vCOvxwBefcFZHTQwZWG0CbhR0j3XwolNEKl1B+ciyBRfSTaQm340w7gdEUQS5RvvepVTiqX+LZQg1qhSdiSvYLQMlZezFyJ5jgqNjayKhdWdNbedXiMyUDMLCFB9jbnEFcuvcqfVL5I3aJp4UfnZhSXOpK+mT7IXsy6zF1pTOZH/wY/Q7uYVg5/Xw5pPvsNDTcxPGxCwJVx6UHvF4xg6eP5GHRq/OlO0QNTZCeXq498bVKXQjS52BL65EOpJx8fpw3/K+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 11:16:27AM -0700, Joshua Hahn wrote:
> On Mon, 19 Oct 2026 18:49:26 +0100 Harry Yoo <harry@kernel.org> wrote:
> 
> > On Mon, Oct 19, 2026 at 09:28:02AM -0700, Joshua Hahn wrote:
> > > The size of a pcpu allocation can be interpreted in two ways:
> > > 1. The size of the allocation attributable to a single CPU.
> > > 2. The total size of the allocation across all CPUs, including the
> > >    allocation overhead (for obj_cgroup membership).
> > > 
> > > In most accounting paths for percpu memory, we need the second
> > > definition (total size). Make this more obvious by coalescing the
> > > callers of pcpu_obj_full_size().
> > > 
> > > No functional changes intended.
> > > 
> > > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > > ---
> > > @@ -1662,11 +1661,10 @@ static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
> > 
> > Perhaps it's better to rename 'size' parameter to 'full_size' in those
> > memcg hooks to make it clear it's expecting total size?
> 
> Hi Harry, thanks for the review! That sounds very reasonable to me.
> I'll spin up a v2 to make this change.

Thanks!

> > Otherwise LGTM!
> > Thanks for cleaning this up.
> > 
> > And it might be beyond the scope of this patch, but I think
> > trace_percpu_alloc_percpu_fail() should take full_size instead of size.
> 
> Hmm, I'm not sure. The trace event for percpu_alloc_percpu actually
> tracks both size and bytes_alloc separately, but percpu_alloc_percpu_fail
> only tracks the "size" paramter. I think it might be a bit confusing to
> have the percpu_alloc_percpu_{, fail} have diferent meanings for the
> "size" parameter.

Ah, right.
 
> Perhaps the right approach here is to add a new field "bytes_alloc"
> to trace_percpu_alloc_percpu_fail so that we get full parity with
> trace_percpu_alloc_percpu?

Yeah.

> ( Actually I think we don't even really want size, what we really care
>   about to me it would seem is the size of the allocation request that
>   failed but alas...

(looks at fun percpu memory allocator history)

commit df95e795a722 ("percpu: add tracepoint support for percpu memory")
says the tracepoint is for recording & replaying percpu memory
allocation requests re-evaluating the decisions.

I guess for 'replaying' purposes we'd need 'size' rather than
'bytes_alloc'.

> it may be too late to change the meaning of the field )

Agreed.

> wdyt?
 
I guess we can revisit this when it actually bothers us or
somebody then :P

> Thanks again Harry, have an awesome day : -D

No problem, and you too!

-- 
Cheers,
Harry / Hyeonggon

