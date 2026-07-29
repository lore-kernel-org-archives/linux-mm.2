Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0790AC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8F26B00A0; Wed, 29 Jul 2026 09:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1956B00A2; Wed, 29 Jul 2026 09:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAFEB6B00A3; Wed, 29 Jul 2026 09:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 873846B00A0
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:54:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D2571A0592
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 13:54:25 +0000 (UTC)
X-FDA: 85041958890.19.2BF62B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 97063C0007
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 13:54:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FD0JedG9;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785333263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V7bhTggPy1yNLnQ4gXjtK4joscfsFAiI9ZCSDdA1JTY=;
	b=eHdAROqaxjohG3fwN0oWfcNVZnZ2NiEssSMSiQoQGYIN/84Cu/VtWqI3lxneTcGdT8jChf
	tU9AsZn94JKMOW2HKr0ZX517HW0HPjLaL8xYYpUMpGqmIb0awIT2GKXH0NrbcE4/wTpPcT
	eyfH3/kalNEeeHOM+5hzqEcNxSdWss4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785333263;
	b=xJ2SBOm4v5KaemaW7gSmxlewC0lfVl5+kUt03dv/dnQxJcwQFECzP3H6uHIJNrmAd9Hckm
	de3U0LjGMBU10OiJYdSAxfy02wdvTyjqlUNphdsCVdROVIDR/LtpEyYTN3zJIBW+UeiK1s
	UDcRTlUInfow15z4/9HSUkVC1bWCWlc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FD0JedG9;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD9AA600AA;
	Wed, 29 Jul 2026 13:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709991F000E9;
	Wed, 29 Jul 2026 13:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785333262;
	bh=V7bhTggPy1yNLnQ4gXjtK4joscfsFAiI9ZCSDdA1JTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FD0JedG9h2X/yjPsQoeyUbAPJnmI9XcssRBAAZlmpVvEiokkGlwFs7ckacNGUQWkQ
	 d8lhMunpzVbFyRcOWMDKnIBbzgp2cqGXhY4+BpQhQ9I3diccsmyj+2Av2rF3WjhBN9
	 EflLb+3JvwQ6usS4AA8O5pqWvDGtQtMSt7AN7iemM3+vHQby3jqO2MPUP1kvQJUxB4
	 MaGaEk/oXd83f7toy2Gi+fC43/gu05DOqsovCrXPf1CAYaw5ifKbe2ItJ1Gb1Uj6Jc
	 kALpBJIcCS0EO+2iZxpahH9DLcuV/d3XyxjflN3Pg8Lh5YXVkp80bt/dOEaDwYCkTU
	 GlrVr9j+etzbQ==
From: SJ Park <sj@kernel.org>
To: Bharata B Rao <bharata@amd.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com,
	dave.hansen@intel.com,
	gourry@gourry.net,
	mgorman@techsingularity.net,
	mingo@redhat.com,
	peterz@infradead.org,
	raghavendra.kt@amd.com,
	riel@surriel.com,
	rientjes@google.com,
	weixugc@google.com,
	willy@infradead.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	dave@stgolabs.net,
	nifan.cxl@gmail.com,
	xuezhengchu@huawei.com,
	yiannis@zptcorp.com,
	david@kernel.org,
	byungchul@sk.com,
	kinseyho@google.com,
	joshua.hahnjy@gmail.com,
	yuanchu@google.com,
	balbirs@nvidia.com,
	alok.rathore@samsung.com,
	shivankg@amd.com,
	donettom@linux.ibm.com
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Date: Wed, 29 Jul 2026 06:54:18 -0700
Message-ID: <20260729135419.87239-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <125de6c4-2fc7-4202-9199-347effe63112@amd.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 97063C0007
X-Stat-Signature: 6keo56bjdkufp89p1r7c6wm1qxzykmwj
X-Rspam-User: 
X-HE-Tag: 1785333263-205411
X-HE-Meta: U2FsdGVkX19Uh1BRPBr3VQVMF03GDwws1+pKt5EleH0B1uM8UrObNAaOsVLay3tVIawAL1Ptxv0uoP6Xe/Q8dKARPq06oUQLjkgZnTJNQzYi3guwN8UhKqfPqapF+0+gfOYcOk2giisC5qqADjAcl66YD4WeJa1Fb5181ayHRbwp8eIId69A6jtRIpO5A0fdB7cKx+3BX8E6v88mxsNFghiZKo4dqWSR/BFYiROQqy2VJff1hmSTBm1r6D47DNc1STGeP6EFidusGLcfiACntWixZ6dSnNKSdAZDCxAr2lmb1Ey8SW/CNjtTvglDS7V/kbgvwLkcI8VtZ1M9OLUwmFpZONu0B//QjpouA4RW5UiyQCcFiGR19Sxcmscf9WzRilv0p4BTcLY3xfTiu2KLkNUI7EDcSj9fojZpnaI/KQZanY/9ZlEi5/ts8YhCmbyEeVNmLnobakqtY5z4cQYZo/WWzq3oublcySucb0nfWA5Qw1XthuFdR97aW41s1Uhiqzr1P0az413FtVGZK5PXeqepY2KCbT4FIu33XBny3/f+jfVv2vcGCzCUxC1L/mJ/LJH7cbQ4yKdAuNwwwde511PR/ha8NXmA7/mWCRd3rIa1nWmcn5D2ZTPVIBhApSVFPDRXm5uQ/8D3L/GU8Afw7bjk0XK3rVdWY1Iae16NvN8iZDpk3yExmnPCF+j/xdiQ0AcCXcG8vldzJFCt8wpzMDZpcwXHTHop8p6T8QwmtcG3CzGtPJ0wJW2o5Nx349/h+eYfnFPA2TFJsaz12YY2jNObqlgeJLvOzYAlSR06ayxKhNU66kl3Kk0z28KkJ5/ROMLB+2QnczeKGXdPFdxV7igxMCF8c1JKyPLYraFDGPW2gIHK6b6jYDK0MQ8dxo7EKZWpzZueRBm+lSet9+4CAyt7b6U75SUKkMQil7Hp6pk0q0YPCmkfYqVYlJvrawsgxo9zKHw91V0cBgIo1jI
 T8oQbK3G
 y3rPAnwTIo5reuXKdB0+iW50QVT1a2mkUC1Yj7Tu+1fwzFBA6PUd/DTJnD+8pTTkGasg2VEdsRfE+L4vKtNOVvvQr+VatK1Qn3bEAe7moQ9Jo2gSzhdcy6S95x0qAx4ODovELlUEJu/l2MhmCatWNWLgnmiA1Xnfgojc0ebCO1/5zbCYbvl704iymfNmMf7/q8TmmcGXNhdnbWwPL7pLsiCArfKat7jUWwEmoh3ucQAgTbniTaoWqAgJbgdzRZ6lqC97YCkwAsICrGjURW/M7+UujtAr9FfRO/4mZwk8xoY9paFzgUPafp+2a5hG8YaQZgEOet9v4t4+kGXq7Yz17Zht7pjJvClL11zsMF0PYArGZvvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Jul 2026 15:05:10 +0530 Bharata B Rao <bharata@amd.com> wrote:

> On 28-Jul-26 11:44 PM, Andrew Morton wrote:
> > On Tue, 28 Jul 2026 11:13:48 +0530 Bharata B Rao <bharata@amd.com> wrote:
> > 
> >> This patchset introduces pghot, a subsystem for hot page tracking and
> >> promotion.
> > 
> > Can DAMON be used to do this sort of thing adequately?
> 
> That really depends on the goal I believe, let me expand...

Thank you Bharata, this clearly explains me your view.  I find a few little
gaps between yours and mine, though.  Let me clarify below.

> 
> DAMON can indeed migrate hot pages today via DAMOS_MIGRATE_HOT, and
> IIUC it can even do promotion and demotion together that auto-tunes
> to a target node utilization. So for someone who wants to write a
> per-workload, per-process tiering policy from user space, DAMON is a
> good fit and I don't think pghot competes with it there.
> 
> But the intent behind pghot isn't really to be another migration
> policy. It is to build a common in-kernel infrastructure that can act
> as a single promotion subsystem, fed by multiple sources, with the
> promotion engine and its heuristics (rate limiting, dynamic threshold)
> living in one place rather than in the scheduler. Hint faults are just
> the first source. The IBS Memory Profiler, which gives access
> information directly from the hardware, is the other one. CXL HMU can be
> another potential source. Hence the design centers on an exact, per-PFN
> record that any of these sources can update, rather than on sampling.
> 
> The per-page, source-driven model is where the two differ the most.
> DAMON estimates hotness by sampling one page per region per interval,
> which is low overhead and self-contained, but it may miss a hot page
> inside a region.

DAMON can do [1] fixed granularity monitoring, down to page size.  Of course it
increases overhead.  A few people are using DAMON in this way, though, and we
are working together to optimize it.

> pghot records every reported access at PFN granularity,
> so it does not miss, but in turn it relies on a source to report the access.

DAMON is not designed to use only the single source.  We started working [2] on
extending DAMON for multiple sources including AMD IBS.  A few working
prototpyes are shared.  We plan to share the first version at next LSFMMBPF.

> 
> The other practical difference is that pghot works with no user-space
> agent at all. With numa_balancing=2 the promotion just happens, and in
> fact pghot takes over the mode-2 promotion path that currently sits in
> the scheduler. DAMON, outside of its built-in modules, expects a
> controller in user space to drive it, IIUC.

For a level of auto-tuned hot/cold pages promotion/demotion, DAMON-based memory
tiering doesn't require user-space agent, either.  Only a number of simple
sysfs file writes are needed at the beginning.

> 
> So I would see DAMON and pghot as complementary rather than one replacing
> the other.

I have no strong opinion.

> In fact DAMON could well become one of the sources feeding
> pghot, and conversely pghot's batched, rate-limited engine could serve
> as a migration backend.

Makes sense to me.  If there are needs, we are open to add new DAMON APIs.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/faq.html#can-i-simply-monitor-page-granularity
[2] https://lore.kernel.org/all/20260525225208.1179-1-sj@kernel.org/


Thanks,
SJ

[...]

