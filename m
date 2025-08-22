Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B033CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9781244015D; Fri, 22 Aug 2025 13:43:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 950028E009D; Fri, 22 Aug 2025 13:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8656044015D; Fri, 22 Aug 2025 13:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 754FB8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:43:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A06B1602BC
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:43:09 +0000 (UTC)
X-FDA: 83805114498.15.CC05F62
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 681C114000E
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:43:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DN6I9sm7
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755884587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3At4kmhBLGosGoYl3W4xiNGWvgZL4G7WKLe5QnrFXMI=;
	b=HqTw+ByGPop9Y1Mqy0N05Ny/6rvU3qv5L4/vN30YwWrTQN4WgF3wIqhkPrKMRy2gkFsPId
	8b7s/bsaoheojeji/uP+4VocWxvuT70+T23d/Det93V+Gxi+zF4KNFRICj6cPfcsl+e8sQ
	G496bQzF8zRPnjdOBMrnx/ud5VPGHk0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DN6I9sm7;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755884587; a=rsa-sha256;
	cv=none;
	b=cjUmVxmoD4K4qawbpkoSkN5BoDTojZAU/E6g/2e4gahpFssindyeoPj4GW+vFMY2ZHU74R
	/4WILBSVFwCbtmqxUiP3KB8sX3I7Vrt7k2iaR4HYiRi0lgs84wLCIsh477rLM8piAZMcPZ
	kOjpIacNzNHcoRSa+oNc0ED9SiGxNh8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3At4kmhBLGosGoYl3W4xiNGWvgZL4G7WKLe5QnrFXMI=; b=DN6I9sm7tzwK15MtkSMSc7C+GL
	uX2OeS9q6qX46kxHR2IPnC9EeCOE11ZTi2ZW2xEi41RR+khyjkTdfGI9XyTmCLRwOY7tu2HVu/s1u
	QAt8gUbRLCM2CXHY8gFzeVuisHBMAQq086Nl4JuYbKdrK6w4v/0r6iI3ejCbVMPh9hWwbdehjgoFq
	SqLZqIKzLfXjG7l6HjMQnjpgSCsWelhInpvcdnlYRZbam7fDCW/wCKIkCBkz1qAcjkXcC2EWRzkWA
	TPfOmoLH2PWdaolhAbnNQywtokkDsjo4U8Z2gV7C2sMgQA5m0IOxnraVVtC0njMVI0aFZ/3YCICWZ
	DWh57imQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1upVn2-0000000AmIO-2TDV;
	Fri, 22 Aug 2025 17:43:00 +0000
Date: Fri, 22 Aug 2025 18:43:00 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: YoungJun Park <youngjun.park@lge.com>, ksummit@lists.linux.dev,
	chrisl@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com,
	linux-mm@kvack.org, David Hildenbrand <david@redhat.com>
Subject: Re: [TECH TOPIC] Per-cgroup Swap Device Control
Message-ID: <aKisJJYL9LV20qzg@casper.infradead.org>
References: <aKgm+wisMipLqnL4@yjaykim-PowerEdge-T330>
 <aKihqI8PWLFL1b5i@casper.infradead.org>
 <20250822131022.4df59a60@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822131022.4df59a60@gandalf.local.home>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 681C114000E
X-Stat-Signature: 9k8nf6h77spj87fhayag7dga5e9h9p53
X-Rspam-User: 
X-HE-Tag: 1755884587-691241
X-HE-Meta: U2FsdGVkX18wlK/NEMWDZcEUH5EiNG6kLLLjvqPp7ziytnB40dHpkdNnDmwU9pNG5i8CMdIKh31BlAppgLqSDX+x6bfL9ooZTJAXDPZ7Qw97HxKFiuTBURJERSsfGjmRKTiCgO4fGumAUznwXTX1ZE0HSIH/P2Ac7eKPQCmmLm3vn1uClijRz2XgZsOSiSg98UBd5fqaUlqfQVWhb/5QTflOxHu5FBY1VglKgNuUVZjW67VgagZK/z4QOyBYFTIEXZAAoHloUKTvQyH2aoeHcfHfKDqK0YYz9Y7MMqFKvpEjz4EQ5/niEtiRIDYg4EK4ZshTn4NA7UdGWeztD1e/6oBX3U4wq48aEliVoveZWt6tvOOxVIfNTRgaj5xLmorn4Kx3AtfuLPvFQubxgZccFYb5M84k2YsbFhYD2K2IuyRJADZm2d27/o0TFvx155crz8iK86bI0VWfNp6s5KGDdR0p57Yfm14pa03yOuEOC16BkrltRW9hZ+ORPNypRPnEo7g/HQ6F7mg9tizJor0TDYGkKosmbfO4eZx9jIhJgOyI7IhQawRhVnJmh3vZm+lGyg7XB++k8kih12hLhr6rIQBYG+u0HzVGgW3PXd4SE+sAZ+kNcPjrFUVoxyt8aGcLNo9OL2MDUASY8sABsLmgIlp5HXFGVUQh3PN0tkIFBD5zc1lDo9AREj5AtxFRNx+eYUEzRk11FMiWHB9fmJWxtp8UBklxTN13jdBZqv6+SZaOX6DHYH/sqg+QKnkW12uzCzfr6V1Gl9EP500XCR+oOddPDq3Sehsfsy40khn8Uw2ahZR/jWdvwAoKNJeoY/bD09Xdck10YbU/tJ75OzIwsrZ65NqhjAaAHLcKvuy+pxCaLEqQA3+QRW8GUapcj4As3e04HUoXjFbKWNt+gEw986mO1LahTerobh2HAicqr17ikd03ooFxFRKDllSF7tMI7BIA5wRRXA4NVuwjInB
 QbhxxpQ9
 8a2klwTI84/7okBgclfDkJQaeIHq6Uxjx9NgKfSEk874+s1Dn21LLCBxYKZRH+582U0gFE3hunElcr1PfDXYbysRDE4Q6uxYrBaS8y+LACJl1BVe0ER0H/Z5eTyJ7VBp1PqctyKRwaqRkOFM9P1oTh6lg/clWOh2QWOBgoxUL/xexrQNQGczxj4Wank+SiGEuwF+pj1UvN9L1O0N82Zgc/MPlT1eWualhMq2nm+7M+adpX8fpWIcECrwEwLIomcZNK0ttbNTAYW8iu4MOrHgYH78gOP39TZ+JCrz/faSm5bFdi6O0EuStM9/XczRkWUBdLcJNCqpGi1YNA/ueI3GmNUKG9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 01:10:22PM -0400, Steven Rostedt wrote:
> On Fri, 22 Aug 2025 17:58:16 +0100
> Matthew Wilcox <willy@infradead.org> wrote:
> 
> > > Proposal:
> > > I am developing on a restricted internal platform where there is a
> > > technical requirement to use idle devices as extended memory.  
> > 
> > I don't think this is appropriate for the maintainer summit.  You
> > can submit it to the Plumbers MM microconf [1] or LSFMM in May.
> > 
> > [1] https://lpc.events/event/19/contributions/1995/
> > 
> > Also you should have cc'd linux-mm for this kind of thing, adding
> > it now.  Preserving the rest of the proposal for those who are
> > interested.
> 
> From Ted's original email: https://lore.kernel.org/all/20250805144357.GA762104@mit.edu/
> 
>   Related to the Maintainer's Summit, the Kernel Summit is organized as a
>   track which is run in parallel with the other tracks at the Linux
>   Plumbers Conference (LPC), and is open to all registered attendees of
>   LPC.  The goal of the Kernel Summit track will be to provide a forum to
>   discuss specific technical issues that would be easier to resolve in
>   person than over e-mail.  The program committee will also consider
>   "information sharing" topics if they are clearly of interest to the wider
>   development community (i.e., advanced training in topics that would be
>   useful to kernel developers).
> 
>   To suggest a topic for the Kernel Summit, please do two things. by
>   September 10th, 2025. First, please send e-mail with a subject prefix of
>   [TECH TOPIC] to ksummit@lists.linux.dev.  As before, please use a
>   separate e-mail for each topic.
> 
> So this appears to be appropriate.

My mistake.  I thought tech topics were part of maintainer summit, not
part of the kernel track.  It'll be up to the kernel track organiser(s)
whether to accept it to that track or whether they think it'll be more
appropriate in the MM microconf.

