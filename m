Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC814C982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 05:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09156B00DD; Mon, 21 Sep 2026 01:52:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0F76B00DF; Mon, 21 Sep 2026 01:52:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6F56B00E1; Mon, 21 Sep 2026 01:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B29186B00DD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 01:52:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 439364057A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:52:31 +0000 (UTC)
X-FDA: 85236699702.20.A91B123
Received: from mta0.migadu.com (out-154.mta0.migadu.com [91.218.175.154])
	by imf16.hostedemail.com (Postfix) with ESMTP id F3C1C180004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:52:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AGqHNvoB;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.154 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789969949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qIvuPN6/WzgNqJCUjuOUJwBEDkwuxe9xKnTs3tPz+lo=;
	b=lGbykjsAke/oxNqjUmzol02ByQYl5mXUeitqkcIO3pCKBDHd6vVYKpBZ8bLmZ/3ABZbeYJ
	EIBXNXVxFM64wZThY/aMfr85H6SZHY6ic/s1yk9KbwlI3CN/YXM3KRJkm0uVE3hCZJn+ND
	FunLu1HBnNze5fNDUVMq9z6poT5dmRI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AGqHNvoB;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.154 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789969949;
	b=MPttWRvzdb3vojZRCyj+5+eVB+UlNhCS1SJuyd+qt9CIynAPPT7Wm1Ytni5itsmBMnmuID
	voY63XvEmAGOqrAU513LGu2hRoTqb0ueWsbiYtIA7Wy59LuF0kguBqsYkjPvHrVp6iWWqY
	qfzhLA1Qyc8KX+sIIZiaQw78p2XiCPU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+3OQfzHRoTvBjBd8jB9/THE2C+GAiBoDPdOUT4cBopw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789969947; v=1; x=1790574747;
 b=AGqHNvoBHNAK5Sgs8bbNFPB9LRfWqahsS8hsc3FUslRi1QNL9CbtcXuiBuAODhnoALewzvTz
 zAJKHdCmXss9/DvIqB5/J8rDlIqMR5eOYjWyZsTcomxdHzlJCmmDAyvIWSZur3TyrC6BPzAwIHN
 locxBrK8oD3Q849lc7AWjrUk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 3106e5e1082e60f1;
	Mon, 21 Sep 2026 05:52:26 +0000
X-Mizu-Trace-ID: 3106e5e1082e60f1
X-Migadu-Flow: FLOW_OUT
Date: Mon, 21 Sep 2026 13:52:24 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Wandun <chenwandun1@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, catalin.marinas@arm.com,
	will@kernel.org, chenhuacai@kernel.org, pjw@kernel.org,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, robh@kernel.org, saravanak@kernel.org,
	akpm@linux-foundation.org, pasha.tatashin@soleen.com,
	pratyush@kernel.org, m.szyprowski@samsung.com, mark.rutland@arm.com,
	kernel@xen0n.name, alex@ghiti.fr, hpa@zytor.com,
	ruirui.yang@linux.dev, robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Subject: Re: [PATCH v6 06/10] memblock: introduce MEMBLOCK_NODUMP flag
Message-ID: <arDGGOhKFueI90tJ@fedora>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <20260902073116.802752-7-chenwandun1@gmail.com>
 <aqzxavL91icLw-Xv@fedora>
 <aq41nFRPtRWTQ7cK@kernel.org>
 <aq9UGXeqmCfuPHdD@fedora>
 <32b00102-0961-49e3-b780-74d6db182809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32b00102-0961-49e3-b780-74d6db182809@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F3C1C180004
X-Stat-Signature: auy6kibw68joc8si54tqkjoudkaa97xs
X-Rspam-User: 
X-HE-Tag: 1789969948-184120
X-HE-Meta: U2FsdGVkX18LKZCHaUNiqAigdIZoOj80nnL0aAh6jcgzr6RKC8FJxGcMI3ybS2q15Va0PA3yN6iDHpZTsdF38vcTf9lwiDMKLoCEd34VZx+z1jO+UiBgP0gO+1PcHyvUxD18yj1nb5of68aoFL1twEbw4pTdKj3BZzWJMopA/h4VikvhUmxjayCj8zfG4kI0fCnUR+OfMl+C6NguJtXeJMPOsopQzMLqnHqi8M7XoDiTCuP8RuXQK2Iauj7QjenNgWiii8bdzDyfQ8pKSoxKBTuUcO2cxcnBKwAH/X9s77+dJCacn48kafRQUuYwD2GQ2raBjMdkVBOnQ9vvP/q8ZXd1IAiLHfWdLPxQUkNZ/JvOVbL7F2xEOSCP2FZDKVH77/YfJaU6Z+QyeeeEg0SJsEj66cqHhPUt+Vttk2yD2yKwEq8vbNVxX7OCzXuJizQvgE9Q1ZCwDWYzfxQdzeI0746DzQmAhTj1bWVj1hQJl1q3VnSIn/c6NuTaFQ3unl51DBezLnVhxJUHO8DpoUswUjj6ENo5WrLpyYhIZ13+XtwuIzZt+XYPplIaOMarPHdKmQ4skhwsR5DOF3kPOjw3AzrIet891paCSFym+s5/3QfKI7NIKVGwuCRgXBtyHiiP5BHuIl3fyUXbmivLt6uR7iJATIcZaV6Bc5iK3YLfWoP8/8khQwJBkneQ6f0yHbWPLgmUREeNf3fwos4Hjbjl2UMwqeB24eIBBOuU42DNxyrIt6tMOWRgNtJ35cxhCB2Eh51imtFNfIVyNXS1MTQGZpkwtDV45EvRN9YmeNft6G/VnRK6CJwXFrPGWNscLP6n8r1HRauoppYnzTegeI4wOdf9nYfyLXjIY9VtUS43VurZZv+Y9hB+t4kvTXChJTnNVB8hryDDyptjDFwbytdWBuHeYki5dwo6Lf7hjtmS8lB2wlthiJc8r4xqYnpL6Pof5MDyMkKtF5sfERduqCz
 ZJ/HSO9n
 ndO9mlhIm/TVuf+iA9S6c1/RDItBWdkImsN4CEDgvi6KqKdPg+rWmFR4Q95qKWuRQGdr1tavJwhQkboFEzd7TiYXAUd7y7SRvbGmtaDUCdh5sf5gn5Fw4av6pGI6yS3+Ae5bkVKse2NlQMhLBYyHy3qFP3Be6Vfx9CY4ISDv52kwjtBo6boo0Ab87kQjhhrPL+WpF/5+493y0N7S34wWcQ8VFB6SVHXOzU22S0swU6CNe1CXCBbBErca+iGc9RFrqqCYBWo8l5vQx3XFfSoQCgqGFmsdQFmfBqXWveZxSv7D9VGz+QnjIujZkrtuG1r2ZB7ZT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/20/26 at 04:00pm, Wandun wrote:
> 
> 
> On 9/20/26 11:33, Baoquan He wrote:
> > On 09/19/26 at 10:11am, Mike Rapoport wrote:
> >> On Fri, Sep 18, 2026 at 04:08:10PM +0800, Baoquan He wrote:
> >>> On 09/02/26 at 03:31pm, Wandun Chen wrote:
> > ...snip... 
> >>>> +/**
> >>>> + * memblock_mark_nodump - Mark a memory region with flag MEMBLOCK_NODUMP.
> >>>> + * @base: the base phys addr of the region
> >>>> + * @size: the size of the region
> >>>> + *
> >>>> + * Mark the region as not to be included in crash dumps.
> >>>> + *
> >>>> + * Return: 0 on success, -errno on failure.
> >>>> + */
> >>>> +int __init_memblock memblock_mark_nodump(phys_addr_t base, phys_addr_t size)
> >>>       ~~~~~~~~~~~~~~^
> >>> Is it impossible to use at runtime even thought it claims to be generic?
> >>
> >> This should only happen at boot.
> >>
> >> Allowing modifications of memblock properties in runtime is a can of worms
> >> I don't want to open.
> > 
> > Thank you. This is why I said this can't be claimed as a generic way to
> > mark memory region as no dump. The generic way I'd like to see is
> > at any time of system we can mark any unwanted memory region as no dump.
> > And it won't impact the behaviour of the current system.
> 
> Thanks Mike for the explanation and Baoquan for the suggestion.
> I'll drop the "generic" related description in the next version.
> 
> 
> Baoquan, by the way, patch 2 is still awaiting review. It rewrites
> the riscv side of the code that patch 3 (which you've acked) then
> folds into the weak defaults, if you could take a look at it too,
> that would be very helpful.

I checked and looks good, I have added ACK. While RISC-V people can hold
it anytime if they have concern.


