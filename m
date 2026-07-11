Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 402FAC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 00:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF3586B0098; Fri, 10 Jul 2026 20:03:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECABD6B0099; Fri, 10 Jul 2026 20:03:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE0B46B009D; Fri, 10 Jul 2026 20:03:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC2CB6B0098
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:03:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F9041C3E27
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:03:15 +0000 (UTC)
X-FDA: 84974545950.22.C86B94C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 90159160003
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:03:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ks717yvF;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783728193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xuhLIGvoMzgdosMhkd0fNaNt5l4k3HBHBOpccxuxKL0=;
	b=3z9pzKI2kMYU/4qVg/jyvGB4l7c5Z2ci/hU4Ke//NYIbtbPiVB9oMSwdlw0Mm0c67y1Fcr
	i6cIUvOIZkV6hTX4iZB/8ZID0mrS/7U95QSJ51JeKARo9ec2E7xr3US7XGYhuqEMkbtEVJ
	HjtJ602wSKCf+Ak+dw5Mu4WoAQnT5KU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ks717yvF;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783728193;
	b=2klI0fjpYH8IPtf+WjQHm/WcIsOd3mp6/QxZ5n4AruOq/JihDhi1J/7Xa9ChI10QkuKrti
	ni2YwT+PdDvZPymVu6gZMvydaKoMpPDF0L4XTQRKmtPCjPuL3t+RPltTXBbg26SFT5CPX7
	7pvZg4ozWGkL/ucDoV6EkO/tHkXEY8E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D2B4405A6;
	Sat, 11 Jul 2026 00:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1A11F000E9;
	Sat, 11 Jul 2026 00:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783728192;
	bh=xuhLIGvoMzgdosMhkd0fNaNt5l4k3HBHBOpccxuxKL0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ks717yvFqYIqA6WR+QY37XIQWgJADMKlFNW8jw3XJ2p3rnLamQ14UKrDDItXLbEl4
	 qMcKrFN9cPWw4pHi6vEKiLUVCcNSTKGHw5XWQFPyyn4tHd+4kR4/AfwoZFuob4diub
	 l93MdDD/tamKwNitPw3Y4n9eHiC14DinXg6/RRiE=
Date: Fri, 10 Jul 2026 17:03:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, Steven
 Rostedt <rostedt@goodmis.org>, Shakeel Butt <shakeel.butt@linux.dev>, Harry
 Yoo <harry@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, sashiko-bot@kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/page_alloc: don't spin_trylock() in NMI on UP
Message-Id: <20260710170311.e22bfd21c658e8357ceddeec@linux-foundation.org>
In-Reply-To: <20260710-spin-trylock-followup-v1-1-affb5fe5ed00@google.com>
References: <20260710-spin-trylock-followup-v1-0-affb5fe5ed00@google.com>
	<20260710-spin-trylock-followup-v1-1-affb5fe5ed00@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b9s1xy8graw99nqaz1zg9henz6eqf8es
X-Rspamd-Queue-Id: 90159160003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783728193-51727
X-HE-Meta: U2FsdGVkX1/gne5LzodMquE1/QP3JZjxoM0jDqUqt5K3mOki/29Xrr6pyXkV5cDJxKgDOs+twZW4LPNutvBh/18eEFHsjvY0nKj3BHhrJC3Q2K89hTIVjnzo0OLd7UCobl9XiWeZdk/H2orCCCohLKBGvRugabIRmTYFv4SbTiXy43uTmF8Mh5g4V4yGWR4u4UtIqYoYh4r6cdINKoh9uJkInDMxpux91fvqriNm8PWTi2Ia/n82CIpUeYR7LHlujRcpsQMSkCpjGFHz5tGu0FZWuegSwVJYWl5UyFQ+gy6CMtFgngFQQHC+ecIAVZfxcuvVEGIMEqZZNu2usagPrzPlS3T+8j+ImBKiMD5LpG4qPaMu5KZS6LRg59v9JaoxSot22LDraNEuISNUYBgQske8LcreSMgjmsbBaHc0FWNiJTTmbc+XW5lrPQwJU73sOL6N8+2ANAJhdY/MvIOqYZ//KlhdbGq8ScHRaBSz8Ml41EwtNUObzIpLnMt99dH3fOxJRApbtAr5poOfN4/ypCB8nAbAjSwJHf/svjaFTKFh/6KiRnfs/r/nVZChTC36v2mwx+XReE/GrYSwyAzoe3dpl9oMMoXBlq1ZpSR2sSai2VH1SYSU1+c46gaUvKVzFi/DfLaSG3QUZf3aKhjgEYwO25AFq3zMM4QcgHbyefCo1RGpPLSE93LYMj6oJ7KS7rzgleWRuOm0Q7QMDGDvVoFGFKsXNH1/5fH/ACG0wCY0CexS6+YYbSVmUt/uOjQ23igI6UQcaxcGAx4oc84ZG7kSibjF2ZtYRTlvFagiWV1obwotNgMOXn/8597+bUdz00Zbqq4pUr5xP2AcZMkzrITp+KZ9Q7HttTZ4FF2bycQS6QuZ15ft4gnggPOjMjC28pdEOVBYsfyohWJeLwRHDAclvTeTXBkJiiSk3BNg1c9bT0jtc2vxHvvSMfJh7QNSlQi6Pp8rC782v7l/z4j
 w59TnRV5
 7FIfNkbXQSLxuQCwEQuPxL14hwQVBp8KrujJzSuhShznewDw5q6Ch4KreKi4BmUzqWJ7T0++QG2JuoRi4Ygl1jAyFMPZ6HLrPI71rmDw3VXM8LmTIO5vZAnWL6nhyeVvPWPFwchDSYze/58bsIwRDeaMaso0IQOfJTHVn+j+NrKx4t+Izc0/2USEVonyJSPyYWtXkEUELwQT5MZbv7W9+E07lOsv46IJXJd0TXlaDHImDAT6AXawhd+44a9PPmMts1wDMDA3TmwkzBz/J2GvItuWzTAnDc/Ot+xlUzaIpxxeLqi/XblHw2dKxyXJn3kRyLykDI+G4KSPjpMlMB86Xzn3cKMEgEB90u2p8e6wVk8w1zLgIqSIti1OS/+EiLLrAAEsgrGtrrM9o5cA4us8CjMeYkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 10:42:20 +0000 Brendan Jackman <jackmanb@google.com> wrote:

> As noted in can_spin_trylock(), using this is unsafe in this context.
> commit 620b46ed6ae17 ("mm/page_alloc: return NULL early from
> alloc_frozen_pages_nolock() in NMI on UP") fixed this on the alloc side
> but missed the free side.
> 
> Reported-by: sashiko-bot@kernel.org
> Link: https://sashiko.dev/#/patchset/20260703-alloc-trylock-v5-0-c87b714e19d3@google.com
> Cc: stable@vger.kernel.org
> Fixes: d7242af86434 ("mm: Introduce alloc_frozen_pages_nolock()")

Is this correct?  I'm not seeing anything in that commit which could
have caused this?

> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2979,8 +2979,7 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
>  		migratetype = MIGRATE_MOVABLE;
>  	}
>  
> -	if (unlikely((fpi_flags & FPI_TRYLOCK) && IS_ENABLED(CONFIG_PREEMPT_RT)
> -		     && (in_nmi() || in_hardirq()))) {
> +	if (unlikely((fpi_flags & FPI_TRYLOCK) && !can_spin_trylock())) {
>  		add_page_to_zone_llist(zone, page, order);
>  		return;
>  	}

It would be nice to include a description of the userspace impact.  I'm
suspecting that's "none known", but some speculation on what might
happen to someone is appropriate.

Also, please let's not combine a cc:stable bugfix with a minor macro
renaming.  They're very different things and will take quite different
paths into mainline and -stable kernels.

Also, Sashiko might have found yet more pre-existing issues:
	https://sashiko.dev/#/patchset/20260710-spin-trylock-followup-v1-0-affb5fe5ed00@google.com



