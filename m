Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59A36D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 13:28:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6E796B0006; Mon,  1 Dec 2025 08:28:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1F2D6B008A; Mon,  1 Dec 2025 08:28:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5C636B008C; Mon,  1 Dec 2025 08:28:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 929FE6B0006
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:28:22 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5FF4C1401F7
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:28:22 +0000 (UTC)
X-FDA: 84170981244.30.3B445E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id C82D740016
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:28:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GB4PdAEQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764595700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJP1CphtVFSgNIZU1NL+eU+k3JeTHzGDRtTV12rYQ8o=;
	b=N37zCOqs4tS09Bm54Nf3wrDyysf5gDm3wHdRwYQsCl2CH6VUFS1/uuGGS58qbpYHslPT38
	NtZVdGizTYPZCkqroyPMPfSeE/HMnw6meN+3Rz+g7sMdELwz9FTylmFWSAr6hX7nfc2tYX
	b/5BYaT9A3M++hamYB8oCmO/bNmayvs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GB4PdAEQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764595700; a=rsa-sha256;
	cv=none;
	b=ItNAYi1qte1miaJ+EIa1gUEQP9BA7KTcsYsGTfzZPDIi+460wHWqZudIRjdisvl1fcarZn
	W9qMnFmmX8ePlD5/gPICAyRLf7sJRQXEgFROMcL0+HJhg+nmhcaxJUvyXwi+6he8vWO/mz
	uqpxsckq9kN5WN8Lal8G2HH+OgvyWEU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 119E16001D;
	Mon,  1 Dec 2025 13:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A75C4CEF1;
	Mon,  1 Dec 2025 13:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764595699;
	bh=FevHi0kLliUV5SQ+/ZO84hut8iMmC7m6mevvQPXJiHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GB4PdAEQpQKQuhcpxGteKkjdVYH9TyuUXh91JdQuQ/4eOSaS2YGYg8q65zNG0ksj3
	 4iUEy0Sx1XA6EcrsvEEFUEatwObl/Xb4VOs+L86Ygm1h9jfbIZJCen+EqrXkmpQq5t
	 vzD4d1lwJZVkBXeR8YPgRBOEnuKEzhMHebtHoUi8rgbvy6z9HzRJWNsxrHMf0OOPoB
	 QRJMGlCp7nwSLq51InSz1Ynj4rVUI69oirRNzlrghJAXSQ/uBjN8HHZrs29TWgZ9vU
	 f74tqNqWKXSMr8kOIGEZPP3OtZP0dyeYroa1jhuGK1jujZYk05YvwT+2gsPZXN9D+G
	 afF+kzb1yTDQw==
Date: Mon, 1 Dec 2025 13:28:13 +0000
From: Will Deacon <will@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Zizhi Wo <wozizhi@huaweicloud.com>,
	Catalin Marinas <catalin.marinas@arm.com>, jack@suse.com,
	brauner@kernel.org, hch@lst.de, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	yangerkun@huawei.com, wangkefeng.wang@huawei.com,
	pangliyuan1@huawei.com, xieyuanbin1@huawei.com
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
Message-ID: <aS2X7cIiRnR26hyg@willie-the-truck>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <33ab4aef-020e-49e7-8539-31bf78dac61a@huaweicloud.com>
 <CAHk-=wh1Wfwt9OFB4AfBbjyeu4JVZuSWQ4A8OoT3W6x9btddfw@mail.gmail.com>
 <aSgut4QcBsbXDEo9@shell.armlinux.org.uk>
 <CAHk-=wh+cFLLi2x6u61pvL07phSyHPVBTo9Lac2uuqK4eRG_=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wh+cFLLi2x6u61pvL07phSyHPVBTo9Lac2uuqK4eRG_=w@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C82D740016
X-Rspamd-Server: rspam11
X-Stat-Signature: cyns1gz66tc6iy9cret9g4q5frsbm7c1
X-HE-Tag: 1764595700-982342
X-HE-Meta: U2FsdGVkX19Py4w+dWWftWjmASkxHyy0eJT78wh46Q1NFN0HB5uSRnR5zOl/JNDpTt3MwhP7nWiVNIweWmqhcBrL3iSl+8vrlianNXqikSuZeRKOU/BEf1u9rqkdP241KDb4lrZqLyVO9I83fW//H2O0722P3flv4mQ6fk7a8ftOnvV711oXms6Ai+XmEW8gZH1wSttE/ZGNDFuHZf+016cmdJr3gg7gL648dePwgyNM3V4l8QFOfKWX+w7MkerXLGRqQSs24ZNtpn4XLdG9dHsrbex5th+R5A62WlpRHVp+47dARBA1GKnBzE/JSRdaUT5DurvQvsTSCA0+X8gdBOReZFsqcRC1CgG9QpZ4OIHe2JfPTWSxUoVsvjTF8N+6V0+MTkuaJs7qP+XQLrV7Xc+zarau3YI8f412drsT0dSqfLbw67sNd3rvF0dWYoWP5ozdLAq4HXFdS43WA4whTZ+jY5nkKnH/0JkS9t3P0qZzY/vjSsRUQYeFPr5A4BZ+Clfjw2UmrI5A1E7XHbGpSReCVkXVBqQu2rZfNhFamZbwO8fqZN12Lbu+4JtLvRBG0eE+QeHW6dF731bwn0AG55X+tqtMKmLIH17Q/ks2BcBjqjeOQ1JUfx3/9wIL1a0EyOEeix8bjlMyv0N5gd1lghid06hAvvKjfbiM2ePqBaHnrUMOFJYq/MeCg5Uq8fTWeJSyzNdyxghj9/jaTvIZ4dUhSmMjU5+wJaX7Gwid1Hbkzf+PYG+asFCqup1wABYovjf5S4W+ppTuo/mL2BwDVjMUFSvry76FexnrnM74ptfhNcuxoQCM3sjbqdWejZdmkICzkdaJEfqKgvNxonIeocUb3EKUEn55DWh4atSz+5r9VoFhdIP7ea8lAkEUMTC24BNL2frgPQYSIvcL/BapQuDAcjfsOEt95lUUMjbmNQgN44pqu9QAjZWnUivFsrBTVbrniKtrEL5LejWlZcW
 8FuxPWCi
 mLVkM4eqTzYO56DarDoglEfnzSLChbfVMm5M8Lw0JQ3WXeW4VJ1d9wmEvlNa/jTDvgrTSVbXFvASdGarbgn+5XIcf7VBdZzn4kchRCubzOcMPD5cvYKZzyry9upwtU2jc9eAyJ5Vuf0mT4KegwjJiGIpr2vzur8PjtBb0Bhz0RXmuypHp3pxF6TnwqynT2XlCQEhHQXYedvM7YcZkHDKDjGRlf4hGlW+lBMau26gnusm6MTzoTt3BapqdKyE1MgENSge974lL4DHkIh5oy3ixFhQUYq0Z7yOxZR1574C0wKMynU/hPtP0R4OQkWKpt1WBcN43vjMXJmy7RyXt7DD/CKoFEMLHs3hNBN7h+jXm0gLsv5LGTlKFLH+XNeT6rOrlH8NN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 09:06:50AM -0800, Linus Torvalds wrote:
> On Thu, 27 Nov 2025 at 02:58, Russell King (Oracle)
> <linux@armlinux.org.uk> wrote:
> >
> > Ha!
> >
> > As said elsewhere, it looks like 32-bit ARM has been missing updates to
> > the fault handler since pre-git history - this was modelled in the dim
> > and distant i386 handling, and it just hasn't kept up.
> 
> I actually have this dim memory of having seen something along these
> lines before, and I just had never realized how it could happen,
> because that call to do_page_fault() in do_translation_fault()
> visually *looks* like the only call-site, and so that
> 
>         if (addr < TASK_SIZE)
>                 return do_page_fault(addr, fsr, regs);
> 
> looks like it does everything correctly. That "do_page_fault()"
> function is static to the arch/arm/mm/fault.c file, and that's the
> only place that appears to call it.
> 
> The operative word being "appears".
> 
> Becuse I had never before realized that that fault.c then also does that
> 
>   #include "fsr-2level.c"
> 
> and then that do_page_fault() function is exposed through those
> fsr_info[] operation arrays.
> 
> Anyway, I don't think that the ARM fault handling is all *that* bad.
> Sure, it might be worth double-checking, but it *has* been converted
> to the generic accounting helpers a few years ago and to the stack
> growing fixes.
> 
> I think the fix here may be as simple as this trivial patch:
> 
>   diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
>   index 2bc828a1940c..27024ec2d46d 100644
>   --- a/arch/arm/mm/fault.c
>   +++ b/arch/arm/mm/fault.c
>   @@ -277,6 +277,10 @@ do_page_fault(unsigned long addr, ...
>         if (interrupts_enabled(regs))
>                 local_irq_enable();
> 
>   +     /* non-user address faults never have context */
>   +     if (addr >= TASK_SIZE)
>   +             goto no_context;
>   +
>         /*
>          * If we're in an interrupt or have no user
>          * context, we must not take the fault..
> 
> but I really haven't thought much about it.

In the hack I posted [1], I deliberately avoided modifying
do_page_fault() as it's used on the permission fault path. With your
change above, I'm worried that userspace could simply try to access a
kernel address and that would lead to a panic.

Will

[1] https://lore.kernel.org/all/aShLKpTBr9akSuUG@willie-the-truck/

