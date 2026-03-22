Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20DE3FC72BA
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 10:31:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4131E6B00A6; Sun, 22 Mar 2026 06:31:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB076B00A7; Sun, 22 Mar 2026 06:31:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301F16B00A8; Sun, 22 Mar 2026 06:31:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 220616B00A6
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:31:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB6DEBB387
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 10:31:08 +0000 (UTC)
X-FDA: 84573331416.03.E84C297
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf01.hostedemail.com (Postfix) with ESMTP id 862264000C
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 10:31:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774175467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WOLC2yeyDAVBzDsXmvwbojGnkOwApANQrMXtV5D4S+E=;
	b=RylGjVBrDTKBvTfZDw5SPInRxWmTHyZe4ZZ0RO1Tv6V+KeUiZrba530ocI3rTFt5PaRG7V
	SJykvIdeZsjkqyQbM7lLu/nHV2BWNb63xbFjp/oc1594duqb3ho5EGY05Oht463Bq80h/r
	AzdrkwcVFx1O8WwSRuCWw9RZnG1ETng=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774175467; a=rsa-sha256;
	cv=none;
	b=HeEKeMf0MKT1M1F0/Bm0QXF9dnwouVnfMY/I+JCa3WYz/nMJqbPKzC62I42wZomp6dLUBA
	1+CxvatxWbyAxNLceNs5XBOP3Ne/suNidt/VcoCFtK7o3sDJgslDcUzW25KKXXZrsh7YFc
	HKBY2QfdXMjIyOfrlMfSxSD1pk/8Dys=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 22 Mar 2026 19:31:01 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sun, 22 Mar 2026 19:31:01 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rafael@kernel.org, chrisl@kernel.org, kasong@tencent.com,
	pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 0/2] mm/swap, PM: hibernate: fix swapoff race and
 optimize swap
Message-ID: <ab/E5SaSAlAKLCwD@yjaykim-PowerEdge-T330>
References: <20260321103309.439265-1-youngjun.park@lge.com>
 <20260321105921.19388b7acbc0f8d6036e29a7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260321105921.19388b7acbc0f8d6036e29a7@linux-foundation.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 862264000C
X-Stat-Signature: 9p6hpo78x48nxbyzi9urxbmx7fp6e3hx
X-Rspam-User: 
X-HE-Tag: 1774175465-551462
X-HE-Meta: U2FsdGVkX19nRSPiROTzlev59Sb4TZH44v1fbMRhm9GP4e01RQCio/0ZMz3TM+GUpPmCCMV3+9GR+/mO1xCJQ9yADfnuV5j0TLVbZry/Y8YJESsKGV5mUdegB6AN1NgZjgD6v5luO1+VKdF+gcTSUl/FDlLnOo7rhjrQHcK5yXmiYogh9Fi6Ws/YO6NR7g5lFA7cYH3xJRexiLHamXoYHSgusl21KVEv94t+2W79KzDyASY1LD0uRoHm75JTP2ysqqiBmU5WpKYkAjn18h18oTOo0gk08H7sKhp960j1ihEdvUkOcmBC7xIxke4k8gBVcM5ImDHGSW8zNDLm6PpKuSRhbgoU6KmFlIX0vj/ZUs4gZ5BIVXuTVcsR7+K8NLT+b7lR97wdYL5XE/B608oCEWOwflhpT3zAyTcwoilLnyQYwASjlDBeSeKkpmg5UhvBZO8oMNXlU5CoCowH7sD6ya/WHtBi8lXLmRBYaLHqFSLMriEQbTwuioZpJckDdN1C9CwF9lagnRcA2+soVB+hfFr2WDT7ceIatlDQhHLWYRC9INhiOjtnxVhbONaewF2vO9NeRKwh1o1dCTh05Goub9Ixe2nxZwfQH0AObqrrh64e8MKexQwY5dQV0Ykrihdfr/5qCkRct4CHv0IIbeP2eZL9y1r8HtvpvXY5yItBEqgwFNh3QqbmnXPHVG+DGyk1UESGxP1SCs3kp6vV4eOjRfxzUoy6gRz/qRb1NpMFSYdjDQbBjpTWAaOhejwhQS2VIBq54phHWX/Ah7NuQBWN/DZm2sGVph31/ds0kzYJfyz6S9zC52LEmMrgJNzd/+1+k4pGE3EVUVzFeZTZ14iCDfhM12GjE3pmqNU0LTaGOTDNcHnEM1KW0vPEY5wV3IiDaDb6vZz7cgEwxKYpHgjqP0QbHUi2qOiig0K96Qi6ETrY36uoJ6STYQ1DVlUDyy/BnD3K1Jg3SdcC/LBpbUQ
 H+4XDGuf
 A0rm8AAEuChqI7wWGC1N5IWQQIOrdcQHBSw3/OTXruFj09P64pN26aqKWgGTxN7teXbwtMekHnRtVpCqmQjHa3WFzRFkflrVLTuVTVtlPuHvA9paYXaw9MXI1ZAyE2Ak2zSjrfDt6f11s/KLr3CkP2dAxU6DSCqMZQCFcpfBQnhP53lFxiP3w8MaWR09JX+OiA6JBarGoHRgWrGnmt0TZg1OR3KgJORzZasFtFJVIsEqhydnS5EJB1uLK+v3FNR+/oWcIxcF0inDFVjHkr5EzbUgzK1Q32W52Znl6NWldQCyOqf6Qas5xdWz+08YkD6AdBSoInoANatyLyVQdqpHSl9avos5EzfSl/rb3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 10:59:21AM -0700, Andrew Morton wrote:
> On Sat, 21 Mar 2026 19:33:07 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> 
> > Apologies for the frequent revisions. Hopefully this version is close to final.
> > 
> > Currently, in the uswsusp path, only the swap type value is retrieved at
> > lookup time without holding a reference. If swapoff races after the type
> > is acquired, subsequent slot allocations operate on a stale swap device.
> > 
> > Additionally, grabbing and releasing the swap device reference on every
> > slot allocation is inefficient across the entire hibernation swap path.
> > 
> > This patch series addresses these issues:
> > - Patch 1: Fixes the swapoff race in uswsusp by pinning the swap device
> >   from the point it is looked up until the session completes.
> > - Patch 2: Removes the overhead of per-slot reference counting in alloc/free
> >   paths and cleans up the redundant SWP_WRITEOK check.
> > 
> > ...
> >
> > v6 -> v7:
> >  - Dropped Patch 3 (pm_restore_gfp_mask fix) from series as it has
> >    no dependency on Patches 1-2. Will be sent separately.
> >    (Rafael J. Wysocki feedback)
> >  - Andrew Morton's AI review 
> 
> Well.  Roman, Chris, Google and others.  I'm just a messenger ;)

> > findings applied only to Patch 3;
> >    Patches 1-2 are unchanged. (no problem on AI's review)
> 
> Seems that it changed its mind!
> 
> 	https://sashiko.dev/#/patchset/20260321103309.439265-1-youngjun.park@lge.com

Thank you Andrew. It seems sashiko has learned not to go easy
on me twice. :) Will address it.

On the v7.0-rc4 base, add_swap_count_continuation() modifies
si->flags (SWP_CONTINUED) under si->cont_lock without holding
swap_lock, so the non-atomic RMW race is a real concern.

Possible fixes (based on v7.0-rc4):

1. Grab cont_lock on the SWP_HIBERNATION set path, or grab
   swap_lock in add_swap_count_continuation(). This would
   serialize the race, but adds lock contention on a path
   that doesn't really need it.

2. Convert si->flags to atomic ops. This would be the correct
   fix, but is quite extensive and better suited as a separate
   effort.

However, on mm-new, Kairui's series [1] has removed
add_swap_count_continuation() and SWP_CONTINUED entirely, so
this race path no longer exists (verified by code inspection
and AI review on mm-new).

[1] https://lore.kernel.org/linux-mm/20260128-swap-table-p3-v2-9-fe0b67ef0215@tencent.com/

I based this series on v7.0-rc4 per Rafael's request since it
depends on PM-side changes. I'm not very familiar with how
cross-subsystem dependencies are typically coordinated -- if
rebasing onto mm-new is an option, the race goes away and the
PM-side changes could be picked up separately. Would that be
a reasonable approach? I'd appreciate any guidance on this.

On a side note -- the AI review is becoming genuinely useful.
It might be worth having it gate-check patches before they hit
the mailing list, rather than reviewing after the fact.

Best regards,
Youngjun Park

