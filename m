Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E92B2CA0EED
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 00:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38948E001F; Fri, 22 Aug 2025 20:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE9588E0018; Fri, 22 Aug 2025 20:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFEEF8E001F; Fri, 22 Aug 2025 20:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BC80F8E0018
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 20:42:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 38282C0269
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 00:42:37 +0000 (UTC)
X-FDA: 83806171554.26.4B1EA5E
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf14.hostedemail.com (Postfix) with ESMTP id C4160100009
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 00:42:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755909755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0JLXbiU9hpBNBe++O6Gf31scyXGyjJMmWi/9YeZlkZo=;
	b=lIJgYOLYfVeIqU3ganz92aJ+zBowqeo3hBd1bu+pjl28jLKANniMPsKw5mAw7izImcDcVF
	t2pcpL/KURX8aeRWkhe2/gpZ3kf2n7UBS9pc3uJUh4vlOkSENReTRvizUzR1BTx1ELc3Z0
	R3JBBVArAT2Yi7w+jrHp/jguBtgZr2Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755909755; a=rsa-sha256;
	cv=none;
	b=CwZvZ5wTcE1Z7rRo2wR4vZKSmC43g4l2pWNwAcXMEY+jXzzLS/j4unqaM7kj5M0RYqJd2K
	q6KuyxSvf1CvzyfEiNEYGgj+MUHDaCLgFelfb18/jD9vH4SnExPQUZgVeKBYUpvk5RmrOG
	s7xxUMMUpSUeLQXSxMMm/TAMOOi8zPw=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 23 Aug 2025 09:42:30 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sat, 23 Aug 2025 09:42:30 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Chris Li <chrisl@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	ksummit@lists.linux.dev, gunho.lee@lge.com, taejoon.song@lge.com,
	linux-mm@kvack.org, David Hildenbrand <david@redhat.com>
Subject: Re: [TECH TOPIC] Per-cgroup Swap Device Control
Message-ID: <aKkOdkGJh3pQtJ/u@yjaykim-PowerEdge-T330>
References: <aKgm+wisMipLqnL4@yjaykim-PowerEdge-T330>
 <aKihqI8PWLFL1b5i@casper.infradead.org>
 <20250822131022.4df59a60@gandalf.local.home>
 <aKisJJYL9LV20qzg@casper.infradead.org>
 <CACePvbUYp7w68C8z_TeMhOJQ0hmWw1jkwy+D_Lb+N5WbmufAug@mail.gmail.com>
 <20250822142650.572507ff@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822142650.572507ff@gandalf.local.home>
X-Stat-Signature: qh6sw9thwibzrxw4g7kdmncabycbjfda
X-Rspam-User: 
X-Rspamd-Queue-Id: C4160100009
X-Rspamd-Server: rspam01
X-HE-Tag: 1755909753-518601
X-HE-Meta: U2FsdGVkX1/r2try/TBsn2e2YdVGRO2U8uy+UA6NUItfzujYBfP4NwYmwxr6Q9XQXd3qgxePYF/tk6N8DuW9UYOQon/qRYYLIkgwq7b+0AYqP+KaAD97oyAPqSV8y3ElbFDJKbmtpZ222LO0gy1Ytp8iW/yCc0KWsjP8rh2MIcZ3l5MXbdNNGZ8+1aFmPOfFErFrqVMH81fPjnCOaPJlYjjp4egchcCtYh9Az5AKI0C0Ozu/lu1q2QDfELuhFX7HbWgKNylIVo0ow6kHK16Ofz84YeVosWJichVltGhOqGq8pVbbokYcFZqozr9R1DAlGIveC5dtsIdTskjd8SH7iyFDK1sSpj1Z2T8USXhy9OeQUlBZo99nAVp1dCRhtYeDpwaxHhskTM1PCXdzBbl9JQZLEM9pG92Qo5MgYXsIrS2wMOs/fvIImJS6odIAriKaGR+UT0Wcfo72fKwf6+C8WiPdFY39MmRbQt3zSpWQ0qSxyNfmHvoV7tVIUzDb7QdoHW++jhjujOGN+AbNDzmbLdxGCs0uqeIxvCN5lQqboxeqb4WVI7XXCyEXaOfbPQuNvWYkMwBEV/ijan0IZUnd84cSd3ZMhlLXhlJpWWKlBeKX6ZD/I2m8NJPx09kdbHnUuoqFoROY3N/jsiWUB8rCi07wOiVNkMiCZa+8UwRI1wnQDg3+l2qGwzK/Z9isR4N6QIbP57StLeF8VQa+tgbHHtcUtUBMpL5OG2DKYaxtyRO7USaOCFKU+pVjUlY5+U1ocaJYGo6BY/BCpkmtUZBSsBGUpfwwQEtTWNf05sQPSkKDq6rf7SmZewjEj0WLQAt0zuayB/3x72749m905T3eLoM+J9QMMH+7ebslYg5JZslXOz6i56O9FPfmBBrVBGeXO92KmHKIQ4iwwvIMQd2U+cuKA7b6L9x2WYrBx0wOagu3najOmHrBQghUUqsVoKH+BaW/qVivH3gP0ih9qXD
 9hWEunxD
 Au/YdyLLXT73hSiqLCXIdpi2J4o7oc2AygL+GeYfAFibFFKwqfq+i6nrHSBP5kjIMRSV33p6jaMnL/0DPdt4PHMBWNL5CUX2kvZyC+/B5DNZ7gf93QDOLGQNj+LnK5EtiSUhQoIa6LLPDWXOOe/GAJ8bucnkNg5+xp6Dmr5PCFTjmKcnBFIdtasMZ4DBVYqGLCu16SFw3ACyZKvXGdtnXyCVeEJoq6icgo2fg4DZSZhkKQtehj5hzPyR5munMMJKnl9neCUYwczwqRmrafsvJvOSxLOnYM2orVfBrTWynk8iyY/DS4RvWFDyMvijJFgITCFQ8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000058, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 02:26:50PM -0400, Steven Rostedt wrote:
> On Fri, 22 Aug 2025 11:13:41 -0700
> Chris Li <chrisl@kernel.org> wrote:
> 
> > Anyway, is there any conflict to apply to LPC MM Micro Conference
> > track as well? Of course which conference to apply to is a decision
> > for YoungJun to make. I am just curious what options are available
> > now.
> 
> Note that MC topics are more discussion focused than either the Refereed or
> Kernel Summit tracks. A MC topic is between 15 to 30 minutes which does not
> give much time for presentations. A Track topic is longer and allows more
> presentation of the topic. Also, acceptance to a Track talk gives a pass to
> Plumbers, whereas acceptance to an MC topic does not guarantee one.
> 
> > 
> > Hi, YoungJun,
> > 
> > If you decide to apply for LPC MM MC track as well, don't forget to
> > register yourself as a speaker on the LPC website.
> > https://lpc.events/event/19/abstracts/
> > The lower right of the page, there is a button "Submit a new abstract",
> > Click on that to start the process. Don't forget to select the pull
> > down menu MM Micro conference.
> 
> The part I left out of Ted's email was:
> 
>    Secondly, please create a topic at the Linux Plumbers Conference
>    proposal submission site and target it to the Kernel Summit track:
> 
>         https://lpc.events/event/19/abstracts
> 
>    Please do both steps.  I'll try to notice if someone forgets one or the
>    other, but your chances of making sure your proposal gets the necessary
>    attention and consideration are maximized by submitting both to the
>    mailing list and the web site.
> 
> 
> So YoungJun has already signed up to the website and proposed a Kernel
> Summit track. It can be switched over to a MM MC topic by editing the
> submitted abstract and switch the Track over to:
> 
>   "Kernel Memory Management MC"
> 
> -- Steve

Thanks everyone for the clarifications and helpful guidance.  
I have updated my submission and switched the track to
"Kernel Memory Management MC"

Best Regards,
Youngjun Park.

