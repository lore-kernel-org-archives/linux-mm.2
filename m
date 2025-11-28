Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D72BDCFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 13:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 262516B0030; Fri, 28 Nov 2025 08:08:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 212DD6B0031; Fri, 28 Nov 2025 08:08:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 101C66B0032; Fri, 28 Nov 2025 08:08:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EFE4D6B0030
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:08:31 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9565D50A0B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:08:31 +0000 (UTC)
X-FDA: 84160044822.10.45E7B3E
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8E07818001F
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:08:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HDAXnLFq;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764335309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6c52tLyhxFAZFK9SA+rgt/FFMyydOFAml3OBpzwOD/w=;
	b=G5YlKY1M+2rKW606TKKmXu03aY9AhAHWjd8vCRHZKwubf2q2lAqEe52mLTw0ekQLLzAMdl
	8imnM+ab///UkI3eYF2IN6CrSzyifzricR9Nh3ruYW3SfpxEuNXijkSdcVgMm0PomQyAcp
	l0FKLeo4z2Nt05duh08gX3fJ+/9Pl0w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764335309; a=rsa-sha256;
	cv=none;
	b=kVh75V3ea/83FQAoS8h9qkTSjccj9d1Q4YO4gdCcifIXqzfSY7rF99txAnHhzWFflI0PUV
	NoRfRLD+v0ZF+WbUs91jggSUak7XRRj4eHCS5jkgYhD2AUtELKFbcbUh706vJdJuDy+5Y2
	vKtXDEjqShbmOKl4dUAspqFKdikazDQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HDAXnLFq;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-88056cab4eeso11515736d6.2
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 05:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1764335308; x=1764940108; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6c52tLyhxFAZFK9SA+rgt/FFMyydOFAml3OBpzwOD/w=;
        b=HDAXnLFqzflRbgo1DFtOqAJyCvk0KTLSu+2AbIAaaMIVnxMlROqOsgj4St+goX9hoS
         8AhTSy2nz4p8KPh/wjZqT3VTTcR4Hfet4ZVjvTYl8bjjaIMTR+FNrOqNK5XtJS+3xlUO
         zj2nYqHrWCrkkRWb7hobgmtZsjcHnhwqftxuBXJXhJTdztldTBocQFGlMtONNlT1awvn
         0NTqHh2cKN5wH+S52B7V1/ZDfxrd8rxVP1ciVFFOkCZUZrzWCCDgpJHk3psXA8OQsm4s
         Q73OxnXnTECDBu0Wypg50WmFigwiqlh0pcOnu7Rt6tm6B3EsDjycyOjg2C0IBwn7n1Wi
         ZmJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764335308; x=1764940108;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6c52tLyhxFAZFK9SA+rgt/FFMyydOFAml3OBpzwOD/w=;
        b=aQEL/cu5qUR2HTaoO6yLA5R0XycNJ28SPXP0WWzGcequOFMPoCHHW0GiIYVYRUV29D
         mTC95AmkHNOm5QjXTm8Z4IXq1m0m7On2TODK8/qxJTeXS7My0RErKYJlMhWa33zgf+jX
         zCUw56mq2ntF6+bMSKF23Uj2p+Zu/NGc1ZzJf7izNMqxiK4qqVRiBomkl7ePaMeIdb8n
         0IZMUHMF/qYpDdT/34yX7QI7gyI5qy7MCWGQzzrdWswfaipr7dfpE73y/7Gz4oCO5Uy+
         XX9L1mGbVVfbm6v6vfNLq/lfK0FtZ4TnVdjdvH/PnZe5+koCe41HyfhoLU5RPokb+RRJ
         1Fxw==
X-Forwarded-Encrypted: i=1; AJvYcCVzrKU6MWVRrgbDxJM1EzoS6/eooi1iBEm/Vm2FdQjGKXGphVAyg+bKyFXiP/R6zkObFIGcQclp7g==@kvack.org
X-Gm-Message-State: AOJu0YxOjAU2cyc7HOcJDwTuy6pFjCxrsogpdUSNJWm5r4rheFgknY8y
	xcIY4Rq06jRx7aP3CRImaWEag+1/Nra6Jy6YlfgMKSsGEmNlFvfcENpdwZrOvfQolhw=
X-Gm-Gg: ASbGncvXpZi+/wxKkd2vABLSd4K6tXMTi2CAR2i4K4GgeVT3I/lD/Ro3oTvD1eI/R4k
	j+dTPkW+cwabaj6TcPavEPbBOOT4npNKwGgP3SFW/+kZRy0R+956Wqzj8V0Dx8Ed45YyUEhXIXZ
	B3m3fLSrD37569ULysE+dK++chEHaz5DNtOHhrTOKNsXgRExnWcGDCCaZ1nVbcu5VmS0krxaodF
	IHaw615ApkGzWUtTLFbqdpYRwa0cyg103czlsdwMt1uQZCId5yGYaWyhhUwR/YR0ORcmIdCpuLC
	upTqOg2CNf6DdYRevOx2zuNfvKCURIYziOU77hAYZ8f/ADUTcRr/E4NBDvP7/ZSn6bQ6Q0DO+lw
	Vn8QQs7+jpreOSydqAoz0B74lZEKnIXhlr6ua6JbwQ+udw52ehTBhycU31XZK8wytFhdwMbLfgH
	guUCORmT4Pgg==
X-Google-Smtp-Source: AGHT+IHoTOn/0L0u2/PweEXjrcM7aTYoUbYRN5p3hWVxuFtne8kJk6roodWEOJ+eRuQYsnhj8fLbww==
X-Received: by 2002:a05:6214:5911:b0:87c:1f7c:76ea with SMTP id 6a1803df08f44-8863af9e876mr187203726d6.44.1764335308491;
        Fri, 28 Nov 2025 05:08:28 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-886524b189asm28782566d6.9.2025.11.28.05.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 05:08:27 -0800 (PST)
Date: Fri, 28 Nov 2025 08:08:23 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hongru Zhang <zhanghongru06@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	ziy@nvidia.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, Hongru Zhang <zhanghongru@xiaomi.com>
Subject: Re: [PATCH 0/3] mm: add per-migratetype counts to buddy allocator
 and optimize pagetypeinfo access
Message-ID: <20251128130823.GA222920@cmpxchg.org>
References: <cover.1764297987.git.zhanghongru@xiaomi.com>
 <97a9e695-487a-4428-87b7-cb8a505c9966@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97a9e695-487a-4428-87b7-cb8a505c9966@suse.cz>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E07818001F
X-Stat-Signature: 6d7wodkru7o4obg5n4kcpetsby8pfgky
X-HE-Tag: 1764335309-698634
X-HE-Meta: U2FsdGVkX1+NG6m14Cw7A1W8ZyfD9d6+7YefhvbKvoA5XC5CTnKsCnTCgKnVs8/OpJnRhVTN1FYSMdIi9cz7/I0+t2/YpIkyesSRNTz1cxle7AK/mteVvctwG63654Fvly005kwV6HJ7SfLGbxyIvvPPn0w7EkduBFyu2ZehIepuGu6ow5LhIo/y/BiHHjw5ox78MyX9SStwb37aEkNpBIMi5q6erCWRAaF8+lCkpiSwRMWbodje/sAqb3fFGwwpSJ4gAWR4WA7Q0lbL1l5ucEFGRFc1l9NiriT8q4RHaMvhhM8JPJDkpLEO0z4xgoqWkI4MIM1ewCbhQ8OG5Y3Kbw9PGGnccHNGY2j26LpfVSGTXUTmULMqqsK59elHvxSKlWxEFJKavXYdy8XHRWJAz8X8laRBQi/qRn/vPQe7Iro+/9AJvkvQK4ym3FLvYsUGmu48TctFRTFDBL1UmNMdcsGk8DRzwYHIiBh2CH51NzPSqh5eiwxFLYmLc4JQZHbp/V+wH7PLjft7OABllE1J00wbRtHrse6VZVJ45nhS2L6lKMwZFf0Bx24cZWHkoqtApl7aFaVYrKjXroCg7/oFAM9XdHM7b5FXBZsZfgkfc0SXLdagTPZrDjb15nPYBqIFv8k201sPeSw17f05MPWsthL6SlFM+riTQpnpmJZQwjTV/n6n3golq6iRTapE5pY+3uTQL9+rJLzzJtAfDFwawO7lYD0gSNCmGoGb1TMAkC3yPie/9NqktA0mcpsmVAsZilWPnFP6g3UKNrUShFNXtPCG784wnldM6HmxbMJHSpxTsNpqD/7pGb34Mq2YeMS7l5lZFxdNyI2pBFz7ENW7J9RTjss4p77HIcDFDrl1KDuYB7b0cwwX6ruDHOeW5B97CdGlWh7B6oUnriTFaAREDCXAnYUwJoDpJvrg2LprbytAgOmtitHq6Z+LjoBUZN2oGiU0gQrwDZg67olICQB
 BLXJDNyV
 QXfYU39UwRAK1UySU7yorIyeWlC7OYRkeDh3t1MawhIeagcyNkJBXT1DdBcFf7+WumRIm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 10:24:16AM +0100, Vlastimil Babka wrote:
> On 11/28/25 04:10, Hongru Zhang wrote:
> > On mobile devices, some user-space memory management components check
> > memory pressure and fragmentation status periodically or via PSI, and
> > take actions such as killing processes or performing memory compaction
> > based on this information.
> 
> Hm /proc/buddyinfo could be enough to determine fragmentation? Also we have
> in-kernel proactive compaction these days.
> 
> > Under high load scenarios, reading /proc/pagetypeinfo causes memory
> > management components or memory allocation/free paths to be blocked
> > for extended periods waiting for the zone lock, leading to the following
> > issues:
> > 1. Long interrupt-disabled spinlocks - occasionally exceeding 10ms on Qcom
> >    8750 platforms, reducing system real-time performance
> > 2. Memory management components being blocked for extended periods,
> >    preventing rapid acquisition of memory fragmentation information for
> >    critical memory management decisions and actions
> > 3. Increased latency in memory allocation and free paths due to prolonged
> >    zone lock contention
> 
> It could be argued that not capturing /proc/pagetypeinfo (often) would help.
> I wonder if we can find also other benefits from the counters in the kernel
> itself.

In earlier iterations of the huge allocator patches, I played around
with using these for compaction_suitable():

https://lore.kernel.org/linux-mm/20230418191313.268131-17-hannes@cmpxchg.org/

ISTR it cut down compaction numbers, because it would avoid runs where
free pages are mostly in unsuitable targets (free_unmovable). But this
was also in a series that used compaction_suitable() to stop kswapd,
which in hindsight was a mistake; it would need re-evaluating by itself.

I also found these counters useful to have in OOM/allocfail dumps to
see if allocator packing or compaction could have done better.

