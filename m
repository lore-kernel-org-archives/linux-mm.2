Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AE57C4450A
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 08:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31C1B6B0088; Sun, 19 Jul 2026 04:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CD036B008A; Sun, 19 Jul 2026 04:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E4266B008C; Sun, 19 Jul 2026 04:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F2BE26B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 04:56:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87A91A0561
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 08:56:04 +0000 (UTC)
X-FDA: 85004919048.26.17B5198
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id F08011C0002
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 08:56:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UKlIHd3G;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784451363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2U5qRrAFa9bh5Xmu1DmWsyCaZmGr6MmPtt2A5WCS8eI=;
	b=cqpsWVJpefYA07wtSizmJQ4jPgy6Ze14fCyatcGTQVTrI7VJwl7KOCxhwXEmP6MgSVebwy
	9cHKiUPwmcGmXh2/ebYXyGd08ehBbZWIjGaD8Qxc593xXFiLeDJbq5JzO0/4sLeZwEQX/R
	ESQN0tlKucW0W245lYMwThCUMhrWafo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UKlIHd3G;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784451363;
	b=daQ34gSqK50VAorA9N6g9goqiQUqK2v1ZtHi4NG8FX64Z0eMLCmps16LxooF4LyrH+I13D
	t5Gy1y2ZH9h7ltx4YtF0UbPHd3y0KuGgcGzu9tI5yQjMfxOiwZpF/VxG7gX+UI7mkXaEZE
	76VCaEl5nsDGnBbnTEFQ+GsEuRJ0cP8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70087600AD;
	Sun, 19 Jul 2026 08:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CAA1F000E9;
	Sun, 19 Jul 2026 08:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784451362;
	bh=2U5qRrAFa9bh5Xmu1DmWsyCaZmGr6MmPtt2A5WCS8eI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UKlIHd3GXV7IU3Wzd4zgNGbWboOz3yZfmmQ4qfqEiPSWD1qHhrj4/uqYPPX9vX8b9
	 +R+xQOrMW7VIqDEg0DNU+UiuC0v849p7ryJ04TXG/C5rsbVME4u26eoM7/XOjhvXuS
	 Gq+yd6Xh0+TLCsNtLXrs2suu8LIjACy+526imMnPBAF/8FeI4YZkeFnV1IR3AUbUTc
	 716I8AShlrSiF3OVnjSrdRp1s+oMzwFZ/DcgQ/5Loto0FG0DZk2NqQJ1HvtxRHGibL
	 IuwYTFgBf6X1CyzZysQ5JX7i746Mo0A6A1tRG/ZW63Xe0yPj61oHO9R39VflM/MY96
	 HI6d5Zv98HXZg==
Date: Sun, 19 Jul 2026 11:55:56 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>, linux-mm@kvack.org,
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/execmem: Print size, align and caller on
 allocation failure
Message-ID: <alyRHFN9T0FIDBl2@kernel.org>
References: <20260717075715.25513-1-yangtiezhu@loongson.cn>
 <20260717075715.25513-2-yangtiezhu@loongson.cn>
 <20260717113730.787867964b1c3a7c645bb0e0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717113730.787867964b1c3a7c645bb0e0@linux-foundation.org>
X-Stat-Signature: t94ntpisn8dkjzzm95zk7m4a5csbeqz5
X-Rspamd-Queue-Id: F08011C0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784451362-749202
X-HE-Meta: U2FsdGVkX18sI6JFlTFCvw2nPAxhjziTSPUzQaYKcQFS0bRnAeWretKls440rWtdcVijr4O6wwQptNy2EJ6i3ORVsVG+6HSqmaFQT1RMGrxbbE2VDxHxELIn8N/OKiPi1tIku2w4ebiN22GKB/T9dw4unrodiC8kZjcHvyfZg+yrOlMSji/uZSEEQF3DNd9KdOF5d+CzpFR2zZGGlzHm/bp6DbCYgC+3rVR2C/Gw0Wd/iXsHVFPkfrQXszQJm9GS0YHj8feGaXm9KgP4Fr1w6Pr4dbmae6u+u28vSP+5O716qKVUxZiVLcQSnxQjhQ1EMrpraqIhY9XClSwfnmYD3Xgtz1asQynql2rfHOW6DeLo342f7zfvTQGlzVw9g5moNAgoiSaFaDRWip1S30X9D9KSFunuHCJ8NBL6VZRSddoshpolZMrC8RNqf2JqxZclThcYpcTa6LdiHrHEt+Ms/kg9PbJclCQVIVDQfpzM2aJ1zvUk8UUFUPMbuBSmfkdmGkatkqBJMulyp1grVgbV73TAMZhfsRrWBqkWjssQcoYUVkCUl65PaUx1w+R3XY7L+9yE6JuQujZM3+Ri3JBB4uN5TjJfkpVAMGJwIc/P28r6ZKglYXTkhyJ3Fz/2gZHvxPao/ih/X+Z0WABhAgeToW/kh5P+PTIy9S2ZtsWdELdW5WOeQtfFuoYYvkIn5FYMfOexUS5Db7+RnFOk4LxJptKbMKvf7CqiWoxSknLLbj3Lc5EkP39ulVZVHp7G9Xmu54MSI3CWLYpfaeiZnZ7sCBeXTPBbndjoCEP4tZ5vRjTBOKf/UyKRHYITFdbTDNMsBFcCWaT+daaH268cb1gRzUVZuS/LP9Ts24Jj7JHmjhIMls8qw6PbLqgM6w+nyDppC65ctf25OdUrb0HQK7JGJIF2nVJwZ8Nad32m2VtYVT/NPTen3F8ETzAG4J8lTHNsQsdSQo/gp4bt8x4cFvD
 FT42Ckom
 Pb8WO001InVFBed3CxUKJChMEIf60uNwcleWSPOD1XEVmKJJSY8n1+pTdxwPJyzhU6juXfSx9ETuNa//dSxgzuMUCfZXGNw3YKUnhBGiX1nVSTwUwxJGscgMF3dkycL54XqRuHN3uJNzidoWmNHGOiCYJqqJr3+aiDtWD5YUpa4llJtASVN413VT4BA0J71NqTu7aGbOY1HZjkbcFFWafhtaRrPZl7ph4BC04WXTws8phzjyECBrWxXcLM+kuIoVH+qvO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 11:37:30AM -0700, Andrew Morton wrote:
> On Fri, 17 Jul 2026 15:57:14 +0800 Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
> 
> > The current execmem_vmalloc() function reports an allocation failure
> > with a simplistic "unable to allocate memory" message. This notifies
> > the user that an error occurred, but it acts as a black box during
> > debugging.
> > 
> > Enhance pr_warn_ratelimited() within execmem_vmalloc() to explicitly
> > print the requested allocation size, alignment constraints, and the
> > symbolic caller.
> > 
> > This diagnostic visibility is valuable for analyzing the root cause
> > of allocation failures and tracking misbehaving subsystems without
> > inducing log pollution.
> 
> Have you actually encountered this?  GFP_KERNEL allocation failures are
> supposed to be very rare.

Looking at the second patch, it's quite possible. The allocation is limited
to module addresses which was only 256M on loongarch and could have been
exhausted.

> > ...
> >
> > --- a/mm/execmem.c
> > +++ b/mm/execmem.c
> > @@ -50,7 +50,9 @@ static void *execmem_vmalloc(struct execmem_range *range, size_t size,
> >  	}
> >  
> >  	if (!p) {
> > -		pr_warn_ratelimited("unable to allocate memory\n");
> > +		pr_warn_ratelimited("unable to allocate memory, "
> > +				    "size=%zu, align=%u, caller is %pS\n",
> > +				     size, align, __builtin_return_address(0));
> >  		return NULL;
> >  	}
> 
> This seems to be duplicating the information which the page allocator
> can emit.  Perhaps we should remove the __GFP_NOWARN in there?

Right, page allocator/vmalloc reports would be more useful, for example

"vmalloc_node_range for size %lu failed: Address range restricted to %#lx - %#lx"

was most probably the cause of allocation failures.

But we cannot remove __GFP_NOWARN unconditionally though, because execmem has
fallbacks for some of the allocation failures and I don't think the
complexity required to detect when __GFP_NOWARN should be cleared does not
justify one-off case.

Besides, nowadays there are other tools (e.g. BPF based) except printk that
allow debugging such issue, so I don't see much value in extending this
error message or clearing __GFP_NOWARN sometimes.

-- 
Sincerely yours,
Mike.

