Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5941ACA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 14:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A44FC8E00E8; Tue, 26 Aug 2025 10:22:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5A98E00E5; Tue, 26 Aug 2025 10:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9329E8E00E8; Tue, 26 Aug 2025 10:22:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8072D8E00E5
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:22:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 477A0563A0
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:22:00 +0000 (UTC)
X-FDA: 83819122800.07.01EC1A8
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8DD9040017
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:21:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QnGD6shU;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756218118; a=rsa-sha256;
	cv=none;
	b=IEmMqj2VK75vgHe6XJuORwjdrPdyKMyzDm/HxkzTUDr3Bd3PZrwLBG19zqptjobOaRiSB7
	xHPKxprTDLhssCIGcW08qPIEqhHWCHQuDaB2qedP0T+ZtZkXmFU0Mbxk142jtOosylIbIr
	qeNT/h0N91MbIpXU32+mh46EONtjLZo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QnGD6shU;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756218118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wurazuL2BIBrZ3LPD7cqhPNZzCm36PU8RAUwUPqzcAU=;
	b=7JjJNpM0w5lW57YJct8G1ny4mpbmLeiffhJBdT7C/B7X+HU6j1keNpfmUComRj+pz5Cxj4
	k9uEfXYLSH5aB+5SVGl2hsBJJeKibk6vtsvthXUMzBF25Ncy54f2QvOkYEgFd2j4zlyCks
	ZofE0oIBsIp/cLZDJdMbxK3EAGMqwuc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 83D095C61BA;
	Tue, 26 Aug 2025 14:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07367C113CF;
	Tue, 26 Aug 2025 14:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756218117;
	bh=feW4U7ohinlgGVmRvgwizm/FFoHAZFSnfVYUwDEFhBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnGD6shUMLWWB5w8MDuseZc3fub+Aj7VB6CmQ6avNhIIPUXCDje46h8Ed98L/xoan
	 n9/X7AqowrCMgyKT3JxEmVmjch50OqqC6ALGG9Q2Avly66fyf8ZImxO9IW0ELG26lz
	 kO/Vu1sk59Vv1H/Li9opDxRDCJRhANo7x8DE1rkPUUUPtrJXCxDOr9rJTm4pImdO4I
	 Yjk9DsQRrf9Tn0ZnNIdxxlP+bMLcsJEOwpqDNKICO0N+LcrJ6sJidPs6wl2UrS79YX
	 XcorS7q08TZ8dUqZB3ZsH2qYqPBTu4MFuc+PJiqpBMJr4zrSOKrEx+B4pg0JvWrVUL
	 7W9dHkbDzzaBQ==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com,
	kernel-team@meta.com,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 03/11] mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
Date: Tue, 26 Aug 2025 07:21:55 -0700
Message-Id: <20250826142155.53632-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <464f9f46-6ed5-4a78-8e06-878869f2afc4@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8DD9040017
X-Stat-Signature: ab4ur8r3xndjhiynj7ws5iruoy6iajjz
X-Rspam-User: 
X-HE-Tag: 1756218118-354747
X-HE-Meta: U2FsdGVkX1/gawqqVQ8NfMxVDPN98iQLoPIXXYMbON1DD9rkX6BHei3sVYDkpdqFLvtLU93/68M4O2ZIRzNb2FX7U1bZL7XJ8Vtx980lqSzM/fDjB8ghhV+56sM99glEYOhT6oJhvgD7EOm/pFbmQA04QjYMdCghyUt+osk95SMypbJ/gEDnNb6ZYxFZBLb8H84IO/dEH42OoFu4DaOJ/ltgVO7Eq/QtPWPv61rKrGkICVOTu2h+VuFRE6bvZbC3J17NUsaH1Xloyf2XlvtDn0WXih4PTLQnPV/s63VZmir6hl4ESnLe8vsVG4TEK54kMhboBihWTTDYrD6LIuv8nz7l4izAqPkg5Z1Rw2JAP4WlAVb8D6KrvlaphJ8dSFpn8TLhhzSgIkLKLdD60IasRAbGVEDo8fSDKgTcAaJNKDr53imSjYMMBwhvZJ2y8I+Zz0GgbavzillncgV9olR/Xyb4IGfUHrmC9hd6JMZRfzF5zkqhlr2vKn60BLHgBM1MDmzUEbWVFrlDvt0HdpyM0hW+Vuw9k9BYqt07K258swANJgSsHhrwho/nl91HfKsioI9v7EQc+Wa8wvIh2K0xWHM0k8gORysCrFu55RUExYWF8R4i1ZQDWjU5whL7FSf6BWg/j2Gq4yFw1RRr6I6zhA4WqXLcyZz9yQP736oc1aXp6xw6C1DBVsZ1EYjjAFI3mPiTCknb34FKK2gUQM4thuGnsob7/qUsHWYu3/4F6MM1gkq6A0im+jxWKB3GD8eMJ7GDx9Rwf8ck1FLLeNZIbUuu0C3DZCyf3Lj/1flo/EgHJUwsP5oXVaMR5dHccok5allhpbyP5wXiPSqIDj6rCtj82M/H1nAW0Pk0uYS5AM9KVWFEFh+uM2A7AYDpjMJn2FD08xNiarlkURM6vQM14DrcwDhs+qVHTUfd+/H+ogM7rjyOo2l41U10dX1zf7N7k5h6CsdV5up5+KOQtvZ
 SkiZZSB4
 g89zVTikseTdAweaP0CnZP3bsvHF4/el4wxwM/YLjC4FlL1Ma7VF5WGjoulEPvY6BxMQROHyQESaz7F4u/JFmMV9/DVdCNRn4duyHvyRJcofk+vxI4Gqh3HP1bXQHz+ntaeYQmf4OzgsyPbI7HOqa6a9h7xRBbIkrgaicTCu60mUZkq/UHBlSe80CLyg6YjevStBEsVKHuhFn6bgXWHHXToG8E+0iIDefi5CDgSw9DDoIano3rKryGkMGgLWtQLI4rHCQ36Q7+yE/GI6XxSL9LByRU3+QKDyJCdZ3hXJBdK/KMJl0UZo7sc65vDfEo4bgBB3YgCD87IP35C2N5xYp6iEgl/9Aa7vUZ5Ul5H0Ys9Y34JUG+wuT64VYEy/CBUpaplOt6zjDDtGIxs9qUNaUF4H6guaLapbi+ZdBX3+BaWCEY3cD94wU6flrQfMYU7oSztaIvudeiety90kSFSyOuVDQCBoSyrS7AnX0MVvnZsOP0+8eabKK8RBQnTALrvecE+Hhe0uVgBrpoy6s8xkPQZvqJp2urOj2kUnPR75kzytvPD8YNh3d6AUrDr/dUDMmBy0M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 Aug 2025 12:51:17 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> Hi SJ,
> 
> 在 2025/8/26 11:21, SeongJae Park 写道:
> > [...]
> >
> >>> ==== Attachment 0 (0001-mm-damon-paddr-use-do_div-on-i386-for-damon_pa_pageo.patch) ====
> >>>   From hackermail Thu Jan  1 00:00:00 1970
> >>> From: SeongJae Park <sj@kernel.org>
> >>> To: Andrew Morton <akpm@linux-foundation.org>
> >>> Cc: SeongJae Park <sj@kernel.org>
> >>> Cc: damon@lists.linux.dev
> >>> Cc: kernel-team@meta.com
> >>> Cc: linux-kernel@vger.kernel.org
> >>> Cc: linux-mm@kvack.org
> >>> Date: Mon, 25 Aug 2025 07:41:33 -0700
> >>> Subject: [PATCH 1/3] mm/damon/paddr: use do_div() on i386 for damon_pa_pageout()
> >>>            return value
> >>>
> >>> Otherwise, __udidi3 linking problem happens on certain configs.
> >>>
> >>> Reported-by: kernel test robot <lkp@intel.com>
> >>> Closes: https://lore.kernel.org/oe-kbuild-all/202508241831.EKwdwXZL-lkp@intel.com/
> >>> Signed-off-by: SeongJae Park <sj@kernel.org>
> >>> ---
> >>>    mm/damon/paddr.c | 14 +++++++++++++-
> >>>    1 file changed, 13 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> >>> index 5fad2f9a99a0..09c87583af6c 100644
> >>> --- a/mm/damon/paddr.c
> >>> +++ b/mm/damon/paddr.c
> >>> @@ -135,6 +135,18 @@ static bool damon_pa_invalid_damos_folio(struct folio *folio, struct damos *s)
> >>>    	return false;
> >>>    }
> >>>    
> >>> +/* convert physical address to core-layer address */
> >>> +static unsigned long damon_pa_core_addr(phys_addr_t pa,
> >>> +		unsigned long addr_unit)
> >>> +{
> >>> +#ifdef __i386__
> >> Can we use the following condition instead?
> >>
> >> #if !defined(CONFIG_64BIT) && defined(CONFIG_PHYS_ADDR_T_64BIT)
> > To my understanding, this issue happens only on i386, not every 32bit
> > architectures.  So I think i386 specific condition is better.
> 
> I understand. However, the aforementioned general condition is essential,
> and we should propose a new patch to address this. After introducing addr_unit,
> any 32-bit architecture should support monitoring of 64-bit phys_addr_t.

The issue is that we cannot divide 64bit values with plain '/' operator on
"i386", and hence this patch makes it to use do_div() instead of '/' on "i386".
No such or other problems at supporting 64-bit phys_addr_t is found on other
32bit architectures, to my understanding.  My understanding is that at least
you confirmed that on your arm-based test environment.  So we don't need a new
patch to my understanding.

Am I missing somthing?


Thanks,
SJ

[...]

