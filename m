Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B944EFCE57
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 01:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 650E16B0005; Wed,  4 Mar 2026 20:39:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FE666B0088; Wed,  4 Mar 2026 20:39:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50A856B0089; Wed,  4 Mar 2026 20:39:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 41A456B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 20:39:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9CF7BAADA
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 01:39:40 +0000 (UTC)
X-FDA: 84510302520.04.BFC1FC4
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf04.hostedemail.com (Postfix) with ESMTP id 231964000D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 01:39:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pB85H4Eq;
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772674779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uDoyp3hxHGk5GmnYLh2TQRpKoqZ2riLhM9IR9bsjBzA=;
	b=u8F7cZnfv8rjCC2wTKgY2NoVe3fcEy/kaAqcziDLbmzLThl2JFWkI58Jg8OVoN+/Hadky0
	mAssOK3Je1Pg1HjvaI+cyKBTqrVS7KkLokIcqVbcI/jKKUQgqz81pL8Y4dS2JCZ/RGAoh8
	wkY2CDp02C5zOE3NH2+waqWqAAPgG2U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pB85H4Eq;
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772674779; a=rsa-sha256;
	cv=none;
	b=sOkamyRw7OTuCO3bc691OWRQK4O4N31iw+Sd+UHE9Qo9DZQHmrkA34CFd/8CL8B8ig9rQx
	s5t33GmaregLl5P4rs/+Zo/rDtyDE+uO+m0dvZ5yexJ40WquEhrCSx0OHrETee6GJ4tE2h
	FBKjsIydMkVaEfCPEoftP327dTLlAiE=
Date: Thu, 5 Mar 2026 09:39:28 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772674777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uDoyp3hxHGk5GmnYLh2TQRpKoqZ2riLhM9IR9bsjBzA=;
	b=pB85H4EqMTXOpPAWcPhlreTH79rHN+1Z19hKBN9h2ASGqqPTRfakDO/JcdZxM7x2Pcu9Sr
	NWAqb6awheRe0Uh5miuCp+XZQhmIeBSyDhklB101UEGRLMxXV9TUR7kV5JmHtA8LRS0pUK
	/I8mKCNpsHoMOSl1gjnxBHa+es3CSto=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH slab/for-next-fixes] mm/slab: allow sheaf refill if
 blocking is not allowed
Message-ID: <le2aabnh7doxt3zo3l2l35urng4kdxeacttv3qyefabzpv32pl@qs3e2yemq7sa>
References: <20260302095536.34062-2-vbabka@kernel.org>
 <3at546the4zbun7g7aoeqrirh46iwsw3vj5ncc4fjhz26gfbb2@tsgplt5o2ybu>
 <3952b84e-9342-4628-9778-92ae155e9727@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3952b84e-9342-4628-9778-92ae155e9727@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 231964000D
X-Stat-Signature: t5j8g6dxtidxkgi16yxqfas1wtq747tx
X-Rspam-User: 
X-HE-Tag: 1772674778-64263
X-HE-Meta: U2FsdGVkX18O0al5v9ddZs1/ivnYP1WD6pnPqj6JB/MyKRnPRo3FAlIniLLbqxzG60JsR/l/Q0G6Czo/YKdlfuMcAKWZ8b1uuNb4X+9x58FVxS4dNC8k50KD3ml6UylCqRsJksNOwIRzkVB9/FMNHFifPLOxquc13GhCtj2gUki0yop+7Z8T4iK5pxm5Cja7dXWX8PdN23apW6E0bA1nfJmQqA/wXagRtVvpRdSBIj9TohKaPgEJFbWSdHpBOWICZkfUPG/iBcjCSbjOqHWgjrUXMBkDH1YjLqrGwvMVzplDNflzdmePdzoSJvAhpLvXQY0wW7/ojlok8W55N3v2E+7M7rbq2p1tKyGCzOuWwfwaB8WJyMpJ0D04a2QS0zrRjNpRtjOSh2FzqDHBUBm4F9/8NxT5uYgz6ON6E3XaRzDFyPtMANTdn72hFovRGne9osXehqvcFtBwriq3PYLxZO+B2T8GijXSJgjnWUxxOSNeDhcwMOuKgZlmQL2E/EQJEjoY2TyQfy/Am1Z3MLBobS1VIjI+iheKoAAOruEFjkqurDVnYg+zUFhJrd/8CrDY+pddA2PHXAM55Dk0l0WosxDiufPVxLzrPmG1OGDp5pH/r6MHFnp4Zh7jhfYMM36qHY7XslMdwwYg/QGQ1gGvXAGI4yRZJ7fo3ZCu0tkfSK8jJjrWexMg1peYi15q8TQXJZrad87F8qRGaU8pu91M/OA7icNOCUfWu1rTKlilZOQ5HuKr1x1hVauCPrNeAydsoAb4iDmmV0F7eV3FgEhuRrbWZtopv5eR9NfbpYFnAzgeeN/WHbOZmWowrgLSd6RCmcTt00bYEscRaNVjypZ8QJXoVhJ8WCCl8bBvrq6gpCz1GYeEmY44SQd+cHxNf2XZzGppvg9i80hhy7JNXsbTQALfBvfdTapXdfwS/KcJD1cdfux+XWTutFKSJ1hlvp8HisnNwg/rmw/PWrsrOW8
 FSKqZD8W
 65PvoaVy1Z2ouOtruVQUz06WJ2oqvR4/ru1QaYAblwMKG6hWGmJoEgvO6QuwJA1XPnKSMoDkjZBCNOwDLGlt6a/oDPYY6bLoIlxBYHkQBpQ/5WCV3Rm60tdndHpd2kNTdlkUIsmyxIIhCTQFwMt5Uv7rkxoponhVDhm80kAH6Do3FpISk0c9xlf3xsje5WfuAkdYOuc5YeljEukA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 11:14:51AM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/4/26 8:44 AM, Hao Li wrote:
> > On Mon, Mar 02, 2026 at 10:55:37AM +0100, Vlastimil Babka (SUSE) wrote:
> >> @@ -4632,11 +4631,8 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
> >>  	if (!full)
> >>  		return NULL;
> >>  
> >> -	/*
> >> -	 * we can reach here only when gfpflags_allow_blocking
> >> -	 * so this must not be an irq
> >> -	 */
> >> -	local_lock(&s->cpu_sheaves->lock);
> >> +	if (!local_trylock(&s->cpu_sheaves->lock))
> >> +		goto barn_put;
> > 
> > A quick question to make sure I understand this correctly.
> > 
> > My understanding is that after this patch, there is now a new case where
> > allocations with __GFP_KSWAPD_RECLAIM set (e.g GFP_ATOMIC) can also reach this
> > lock-reacquire path.
> > 
> > If we were to keep using local_lock here:
> > 
> > 1. On non-RT kernels it seems fine, since alloc_from_pcs() already does a
> >    local_trylock(&s->cpu_sheaves->lock) check.
> > 
> > 2. But on PREEMPT_RT, local_lock could potentially schedule away, which may add
> >    latency. So the idea of using local_trylock here is to fail fast and return
> >    without incurring that latency - is that the intent behind this change?
> 
> Great question, thanks!
> 
> So the main intent is that lockdep would complain if it saw this
> local_lock() happening in e.g. an irq handler. It doesn't know that it's
> safe from deadlocks because we already succeeded a trylock before and
> thus the irq handler didn't interrupt anyone holding the lock.
> 
> Trying to teach lockdep such things leads to the complicated initial
> design of kmalloc_nolock() before it could be simplified by sheaves.

Oh, yes - I hadn't considered the impact of lockdep. This is a good point!

> 
> On !RT it makes no difference as the trylock will succeed always. On RT
> it may not, but indeed they may prefer avoiding the latency as you say.

Yes, make sense, thanks!

-- 
Thanks,
Hao

