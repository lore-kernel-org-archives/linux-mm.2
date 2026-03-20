Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E8DB108B8E9
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E60856B0005; Fri, 20 Mar 2026 06:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37376B0088; Fri, 20 Mar 2026 06:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D766B0089; Fri, 20 Mar 2026 06:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1FF36B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:37:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9188E55EAB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:37:07 +0000 (UTC)
X-FDA: 84566088894.06.6621CE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id DAC7120004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:37:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uooxfFYS;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774003026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A3OVDiQ8zmXTEr8ce4De9MThuf7MRei45Rl5nLZqZ6I=;
	b=wbtlI197BPab0K8rU+k2jz46ObeZlrgNfLBYZvpEQn0Q/Jcg7NjQU1LQdr1p53MbxOAr0E
	ciD6ztPAYFbOMfqzp2dZrq96zAb0w/ry1JHrBDC6MVOvsXOWk68WJKMFG9mQSpS5MddZH/
	SJ55pb1KQW/ejYRQJ/JL6wOcdv2w7Qo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uooxfFYS;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774003026; a=rsa-sha256;
	cv=none;
	b=IjFqycSNhQroQYEddRS1KeBBBzbtFWv14eFMIfyz62mHIyw1lgp4Gstn7sCmtlDM3xq1YL
	vUbvAI9WZ+Am9aqDDMKnigtt3FuAc16oWzNQna59ZVUr/WFbncJusi5Xx85DAQVzVzTS6x
	03xispra4QN2jC94M4HiPN8QcVRu9kA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CDD9042E36;
	Fri, 20 Mar 2026 10:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FE4C4CEF7;
	Fri, 20 Mar 2026 10:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774003024;
	bh=zAvzqY64529I2JFeiO/I6mnMt4/hxOcfh8LG4F5CxIM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uooxfFYSTImWXzioTPHHDJun3DI9J1T0OD00Yj71E92TF8l7xggHtB8LNrsvEgrCD
	 OMGEMqt3LNbJ2Vh8pue6iTJL0YcEF8oJzuCR5IoDcLBPUhBHVEYzeznWh9KDZ3djKR
	 eGp9cT0aLV/uCo/Bjxnbzc6IreB3NHVKrMSmFnSRW+5nI5r3wWa02G305Y5Nb0bWiq
	 5RSzIS2SXx67f6cs98aJ43EVJ5mucPlpKAIfI3kqMsOuaUiPdEaMyhHsoF/tZX6eFv
	 h6UywiH1J4fT4/hxtnMGddjGDf7Dy/bxjkOhIbGyWk3+YeIgk1wONKr3oXp4ESJkBG
	 kOkDdysOhQZtw==
Date: Fri, 20 Mar 2026 10:36:59 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Dev Jain <dev.jain@arm.com>, 
	Luke Yang <luyang@redhat.com>, jhladky@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mm/mprotect: un-inline folio_pte_batch_flags()
Message-ID: <fcc2665f-014b-490f-8451-ca907730e60c@lucifer.local>
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-4-pfalcato@suse.de>
 <2da1181c-165d-49cd-94cb-5ccbd3bb93b3@lucifer.local>
 <69382383-5f08-408f-8c13-d674e82c4dfd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69382383-5f08-408f-8c13-d674e82c4dfd@kernel.org>
X-Rspamd-Queue-Id: DAC7120004
X-Stat-Signature: 7azn16oco5qmeyhk1m9zhrftgd6ffefo
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774003025-847392
X-HE-Meta: U2FsdGVkX1+l1QRHlKVMQeigwqfm8q38uhI0t9l7d+lfiNKzi00dsijQtAe7Bb1o4uAUp8aSUC68fiSPhe0BElld1dQT+e9TpOunjXZoo5pxbjit8cjSC0oAE2BJPpORkBKZahqDXzY1m8E3l2SH4ElmDS2Mvvs7X4fHF3vtPulYTRaLEGh3KHdqKJI7/1A/GxqI8m2LkJjv1F9I4vGdbOLYMN4xORcTlLjZNL3CuaQI7Uhih/Bzm00211gZxuy3DWI4MAus0/3d4YmATeSjvytk5RPAQ+nNjq/cwo+xq4diB1FJqMXqMkkw2fLw10QorMxC5nvHz+QRV8gLwSh5BoMzUOVZgBF9qSLPLAMTA+ABhdrTNog6TnqFw4ymHYTKfPqsTYuAo9a6LzgwIb39Nc9TZEyhEmmpH3CCIvnLe6Ngp0yPFOcCbHcBBkMS/QpvWa6vI4Z8ISiYgI/De7P3qTC6jtFWRAQ4VEIqqNTaJCkdGbD3ouxM90sHl9V621kM58WTWZCCTUZ+wHmw60jgBLDLoYTeFvB2qGfRMsxq0YYnKS7k/uJn9FeK6hz2iasG+QSjC1jVgktW3Brzp3/SNOkVsvotcTPj00j5pam8jBhwAIajXGfZuTyg0nelPtFFLLgAb4yj4EhBg8ZMKsCi9yRXTUR8vC8liEDtWsvl9TUB/NXDoZAUsKuWUPk+VHQ1ZUd6c6x3zH2iftK1tzYStX0T1YDf/3KLi4hCISGnSaJlJ2Car4Ua63ow9BwJ2iOFbmHNflX7UL9VmWRSpdWCz8FUqJmFtkfS8y1Sq/niFa1DUWz63+cuijHg3OBOo8M8GROZ9t/GUuObwoWAflMKRnSfPMnrZ72Vb7FET1Zc27Ea81QhQyZhJP6TRGDYYQxi4BHJJco8kHRUnUXUwHiUWIKqAHo/H2gnfNZ+1wGhR81lLbvwgyT11v2sXT9CruNMgLOCRJ6DrvprcHC0es1
 sRAfzqJ4
 cyOwZzYqAgs3uHlPsiY3wcybqI+m1rpB0Ox752gxl67tpKS4CB1xSTRVrrAC7MZSZiz2v50AU22LorskHhHqG/MAGrA+EBbRYYmf8RpYz2kNyGV4JTYTQvVBFA/gVLA0f+p0xSTdq8x3TvnaWS+9dromySUtH/wnNEWmYEs68DC3xnDE5mc8jYagxTjtkAVrE4DwPb1BS7b/3+aKytjuVYoRiTRhe4N4Rso0j3sDNwYsUYIA3+dlcunjaHpY1y5OegdWxXJEoLoblnmY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 10:41:54PM +0100, David Hildenbrand (Arm) wrote:
>
> >
> > This is all seems VERY delicate, and subject to somebody else coming along and
> > breaking it/causing some of these noinline/__always_inline invocations to make
> > things far worse.
> >
> > I also reserve the right to seriously rework this pile of crap software.
> >
> > I'd rather we try to find less fragile ways to optimise!
> >
> > Maybe there's some steps that are bigger wins than others?
>
> What we can do is, collect similar folio_pte_batch_*() variants and
> centralize them in mm/utils.c.

I'm not sure that addresses any of the comments above?

Putting logic specific to components of mm away from where those components
are and into mm/util.c seems like a complete regression in terms of
fragility and code separation.

And for what reason would you want to do that? To force a noinline of an
inline and people 'just have to know' that's why you randomly separated the
two?

Doesn't sound appealing overall.

I'd rather we find a way to implement the batching such that it doesn't
exhibit bad inlining decisions in the first place.

I mean mprotect_folio_batch() having !folio, !folio_test_large() checks
only there is already silly, we should have a _general_ function that does
optimisations like that.

Isn't the issue rather than folio_pte_batch_flags() shouldn't be an inline
function in internal.h but rather a function in mm/util.c?

>
> For
>
> 	nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte,
> 					   max_nr_ptes, /* flags = */ 0)
>
> We might just be able to use folio_pte_batch()?

Yup.

>
> For the other variant (soft-dirt+write) we'd have to create a helper like
>
> 	folio_pte_batch_sd_w() [better name suggestion welcome]
>
> That will reduce the code footprint overall I guess.

I mean yeah that's a terrible name so obviously it'd have to be something
better.

But again, this seems pretty stupid, now we're writing a bunch of duplicate
per-case code to force noinline because we made the central function inline
no?

That's also super fragile, because an engineer might later decide that
pattern is horrible and fix it, and we regress this.

But I mean overall, is the perf here really all that important? Are people
really that dependent on mprotect() et al. performing brilliantly fast?

Couldn't we do this with any mm interface and end up making efforts that
degrade code quality, increase fragility for dubious benefit?

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

