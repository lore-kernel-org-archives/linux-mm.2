Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0D8DCA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 20:44:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E02A66B0093; Tue, 29 Sep 2026 16:44:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85976B0095; Tue, 29 Sep 2026 16:44:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4D386B0096; Tue, 29 Sep 2026 16:44:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A08EE6B0093
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 16:44:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9AA921405CB
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 20:44:05 +0000 (UTC)
X-FDA: 85267976850.11.25C22EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id BE583A0002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 20:44:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="NxiPSC9/";
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790714644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zz0B4XqWsy+qxFaMtyX0F1BfNEcbPkUQ0oH+i88JnoY=;
	b=iYP/LZhDHNGHvzpSIpenWq8WT1RVZb4qcMfaH896YwrU5T3X7mG/mwtKevkKhInEf+cLHl
	q8ejNK+U4J7SYm3M3XPkV00qgog21QtyaLM9io50oL7IYspGj2TemYM/aUTtLm4t6g5BIV
	g4DYWjx75OGsfvY4fy6yts1fvNB+/44=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="NxiPSC9/";
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790714644;
	b=R/P3lMPhFsd0uDQkOk25DA5eq0TMmj5Aokcr2nl1HZQ0qjU5AFHuDOtXPClSxS/UOEGlnw
	NWHdaLoxjUTMpHlK6DlfI5XYJCK8yrcYNakRTYd3yIunAc/Tsm2RHZL6Z8F/axD5AgFAz3
	7btsz7uskuzXODLNSUuJNmz8LK8t47s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D974343C38;
	Tue, 29 Sep 2026 20:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4661F000FF;
	Tue, 29 Sep 2026 20:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790714642;
	bh=Zz0B4XqWsy+qxFaMtyX0F1BfNEcbPkUQ0oH+i88JnoY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=NxiPSC9/iQaxEFIjneAiZnd5hzZTUgHlU5t4CE+9Sv378x0oBHn4Zyglt9rebVyHY
	 BsUkxmue92FcpicBaQWtw43kNGn0PuXIGAaTcbDK1qgHJV2y05+HMSv846F96Sxe4t
	 OLhsm+NoWgddAAa2O7M6fcIr0nL0AtUMfBvyxEZA=
Date: Tue, 29 Sep 2026 13:44:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, =Kent Overstreet
 <kent.overstreet@linux.dev>, Luis Chamberlain <mcgrof@kernel.org>, Petr
 Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, Sami
 Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
 kasan-dev@googlegroups.com
Subject: Re: [PATCH v11 0/7] alloc_tag and module codetag section fixes
Message-Id: <20260929134401.a1a385ff4369661f879b5d2f@linux-foundation.org>
In-Reply-To: <20260929082014.160587-1-hao.ge@linux.dev>
References: <20260929082014.160587-1-hao.ge@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oniogfwd3egh4yj7tb8wxkz1y6pthgsz
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BE583A0002
X-HE-Tag: 1790714643-562641
X-HE-Meta: U2FsdGVkX19OzaZWEhzLPTRDv77qfoMqovQ1GTZntMtvi/xf8aEFOllihWvo7VFFB+LnD1tpJEMDAnJHMSklFcBddu699oAWKsTO2Y5KTLCeTfWujkUz1pcExEnDdWjnlfplZJJcj7GaOMntlJIzA4UQ+Y4u08jqMx9bVapR/c5TDYY/WVYOF6x7Z4NfrkKkJa0Y6XYQY0buVevYNjuAMkQLLxXtNj6VnwLco2YbrUK9z3TyU1JlFKbVzNUll72dakWZJMAwDr1ZHSxIzweK5SKLePa4O3VCq9VhZcRhI5jGb7LTorV7k+uwkET8qN50JtCwz8RkwUAFoPmzTMDKnSzzyfucfNwacpML+8SLyl+AaKAkyEdfxN8k0fKSFyKMsIdaFYfwTjs6jnzQbp6IB7RwJsglmZPPYlx/Mnbs9VxzIGEPWklrbmPO+v7CTh2YsDb11+PGQcxB3cyBrmUJykC2sLh3RuZcK2zCzqPpULGadHBU8JkdYBs8WcS+kQOVtd/VBxyyp9q2sD7/+Rv0GKbkLNhh/Cj6p0LPYLAdekfdBckS8LRncaj7CYMsbmHUbSgjpyO9WuIOJ6k/Q6xEK1UWRG4Pahqq2ktl/pABZi7b2M2K/YAFWTZG/08sgMMCllLxgCbnIGRhEG0vQDq0hNE2xLSPhUZwAAUqy1Pb7OWCD76DZNxO0nadnGQKDrAklJDctkT96wBhOE2L5oQJOjz8cXaKL2EKyJho0D+gZK8dmJS6YICAa5sSHD20H+4yuXEqNf6s3tkjHipci+R262PmBz+zkHBCVKLmZIufuQNzADHPwnueJe0BY75mOY2vIVJ4/l/bmdVcEUA6gQzLFMiz3VSluLiSQq02AIXm7BXhB3mLof086TkTTAqpbbN5Zpygt3Gdmwubovj3d7NsQKZ9rsY/L5BOyzUW+7a87vuId8SwY7e3s01vDNzPubkNlAdBSP72UkvQD0G5108
 9jPklXvx
 idqiN0ZNTlnMgJcGMNuM0Q/7COQikrLDyf77O483EvvE2fUybLg39fcEMCYxtVq719idKgwNegqIYKq3zcjoKUDOAjXtxxa6ZBZJhWwyJXuOcL2Hk/JBw+rol3LgiNL2a94Ivc7xKBnFtcekCFnlBEvYcq9x2hrXcQ/iovKr8k/O5vXaXWYL9n069bd3BHBCCFJktfSGaZpYrh0dyeZbIyE4vxd2eLftktPP0DdO2WhEUHUngNiIJk/2w0DoL/8QhyiQxdQthbn8/TMi5azavqshY3qoWnelsX1Cfqte13UbZPAHFxZO509Q0GjjR6dDZms1IOsTd3GRX8bscs6hbSRjAnvM72hugAY2ss8oeUUqa98A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Sep 2026 16:20:07 +0800 Hao Ge <hao.ge@linux.dev> wrote:

> With profiling toggled off, the overflow check in
> reserve_module_tags() did not run, a module could load with more
> tags than the page flags can address, and re-enabling profiling
> then silently corrupted /proc/allocinfo. On overflow the fix shuts
> profiling down, releases the reservation and returns -EAGAIN, and
> the codetag section lands as regular module data in the same load,
> so the module loads without profiling.
> 
> Review of the earlier series by Sashiko turned up more problems.
> 
> One is a race. layout_sections() and move_module() both asked
> codetag_needs_module_section() where a codetag section goes, and
> mem_profiling_support can change between the two calls, for instance
> when another module load overflows the tag index and shuts profiling
> down. move_module() then copied the codetag section to offset 0 of
> its regular destination and clobbered the first section placed in
> that region.
> 
> v7 reworks where codetag sections are allocated, on a prototype by
> Petr Pavlu [1]. The allocation runs before layout_sections() and the
> placement is decided in one step, so nothing re-asks the question
> and the race is gone. The retry is gone too, on -EAGAIN the section
> is laid out as regular module data right in the same load.

Thanks.

Seven patches, all cc:stable.  Why is a backport proposed? 
Documentation/process/stable-kernel-rules.rst gives guidelines - does
this series meet them?  Does Suren have thoughts?

Also, Sashiko has been busy again:
	https://sashiko.dev/#/patchset/20260929082014.160587-1-hao.ge@linux.dev

