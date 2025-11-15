Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C26EECEB2C7
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 09:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037328E0009; Sat, 15 Nov 2025 04:45:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29248E0005; Sat, 15 Nov 2025 04:45:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3EE98E0009; Sat, 15 Nov 2025 04:45:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C97D68E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 04:45:03 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BFAB1406B2
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:45:03 +0000 (UTC)
X-FDA: 84112357686.11.C862F1D
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2B42CC000C
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:44:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf10.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763199902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KxNOMTz5VFujV9OooqjIvnUhGFwjQOwww6Zv+RdtvrQ=;
	b=2Y/wSDvVM2QAj+rL2Cc0Q3SLboEcvWmIfb1enhLuxiUnknzF61vTn1vkANDDfCMGHoDP2m
	wuoLhZKC2oo6BGzYjMyOVdo9d7VZ2EzmBTVgXQUoMCr11g5lnvTnp8Tpg53G0rRmgxNTsb
	RCjBir/epsw4tuIawPqZMhBS9UuQ5P0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf10.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763199902; a=rsa-sha256;
	cv=none;
	b=pf1oKxOiuVByqwF+ozsKd97ptSWkAauseFkhTBPAgp4XIAs5Y3HeW12rWrsN+qZ4ctF8lw
	FiMbkOiXKt7AZVLvP52jrGK7d7Jq6LB30aQMLh4AgkxAx+WqEF6MYSMHp7UN+OkbQkO6Tb
	frt5WVfMECUQNzqYWq/7pffFBLrOLzY=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 15 Nov 2025 18:44:56 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sat, 15 Nov 2025 18:44:56 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, chrisl@kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com
Subject: Re: [RFC] mm/swap, memcg: Introduce swap tiers for cgroup based swap
 control
Message-ID: <aRhLmEKixuKGCUJX@yjaykim-PowerEdge-T330>
References: <20251109124947.1101520-1-youngjun.park@lge.com>
 <20251115012247.78999-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251115012247.78999-1-sj@kernel.org>
X-Rspamd-Queue-Id: 2B42CC000C
X-Stat-Signature: f6t878fugwg7f36nfymcci7guu4mg47m
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763199899-704632
X-HE-Meta: U2FsdGVkX1/Fu/ljzwLzgoE8Uk5VgO1HtFW2wQ/lcPkx16+JaGLrMrYxwGLE7+VqpDrTpMGgwOYNsffVNPAVhkosR8tOk/YWR6f0jkk/8Zcm6hqt0vF8OIB4hpo3orQkk/V7beoQSSBKSkVo0Tbh5yX5pXUiMP8+gfsXRDwsDWW/+aEUoNiN3VOrwXgfZPFLNro9u0xZPBSWkm+9gn3kTf7HIqYpMl938HxToh/wHbMF0/At+tg0B75PJ1GllHwOhhg07uuAVnYn07tBe9ERGlxw4JX93DrhVED+4F7VcAsNT8PptGhAmbq7GChPQANSFn9+vQcqinsmRsEcPnGRX1QEY0AOvUQvDNldgZ27DFA6HCd7cD/sbVPWadpVGO5SCP6R5V/dee2rB8U/uH/HYUDCQ5eWV6Jg4os3RNlDMdXbhwPQPSFpPK69xjj/KUTcqo0BxfjLejvc2L6hLoJbWd+S3Vl5EJkeLUpGpcR1m+2LTN+rKz7gCEks5q084SRe20Bv4gsVFlRGup+u3DIQ+vFxUnwWrHI3qHBmKqwWULWcCdZQvwrLRUIXAM+oF081c5x6bgIPPTkeLSr0+CxC73C1V7ZxecJ3lqGsDeWWQ9idp+VqkCpb8o/xx3hLQ/a8RKiDkknYvhHLB/aOPRBWQtyYMjRueaCNvCtALxZbfDqrspqoCt3CkcrJtKHW8lzSSjuuGhYzYloOHKkTMaChE2pM3FfHo1FursehplpAhPiLfzNHD/cf8FZK5+W9q1Olbr2CPJ3r/6RftaURsgcHdZ+PXw3amA+pcT1xBI5RqjJy2x+Sy3Oh8C+0/WF+XzFCraLsKuA+X86nlAKnAMquaHk9+Ojt622zNGYRmvf7sC9gPti1RSD4IyPKmz84tbVc0gUspx+pBGsnI+n4dxholuwdrbYocS+1TP/uIp45PAADxbHkrHvzY/ButdyqODYFAiV1ByFInx/iIT2jR5e
 iOgGHKoj
 yMMTACqXlgl6tQUSden2JkEUxmFLPlRCo/EfWTGKYoGh5eirmRcw/WIruS6QXPasLc6h+rhqoL+ze8licfBFjQefwzNZeXwsVPkeWQwiPc6KiPLUz+ABUVS3MRFJsPCkkub0lt+rcppF8sOkhFYDwsZIKMxyST2Zvb3H1Te2yzL+3IAQPTsI1wKcqfyJR9Om2nqUez6u0LrJvAWGc38suB+Fr99Hziza81d/k6KPNwvElBLIJ9thhZv5Rc8x0JUeb/G5C3LeNRxk2KKVW7z8N8EmQulxbOiVtY20DKD5i1QSRGrLfca2TUfVt3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 05:22:45PM -0800, SeongJae Park wrote:
> On Sun,  9 Nov 2025 21:49:44 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> 
> > Hi all,
> > 
> > In constrained environments, there is a need to improve workload
> > performance by controlling swap device usage on a per-process or
> > per-cgroup basis. For example, one might want to direct critical
> > processes to faster swap devices (like SSDs) while relegating
> > less critical ones to slower devices (like HDDs or Network Swap).
> > 
> > Initial approach was to introduce a per-cgroup swap priority
> > mechanism [1]. However, through review and discussion, several
> > drawbacks were identified:
> > 
> > a. There is a lack of concrete use cases for assigning a fine-grained,
> >    unique swap priority to each cgroup. 
> > b. The implementation complexity was high relative to the desired
> >    level of control.
> > c. Differing swap priorities between cgroups could lead to LRU
> >    inversion problems.
> > 
> > To address these concerns, I propose the "swap tiers" concept, 
> > originally suggested by Chris Li [2] and further developed through 
> > collaborative discussions. I would like to thank Chris Li and 
> > He Baoquan for their invaluable contributions in refining this 
> > approach, and Kairui Song, Nhat Pham, and Michal Koutný for their 
> > insightful reviews of earlier RFC versions.
> 
> I think the tiers concept is a nice abstraction.  I'm also interested in how
> the in-kernel control mechanism will deal with tiers management, which is not
> always simple.  I'll try to take a time to read this series thoroughly.  Thank
> you for sharing this nice work!

Hi SeongJae,

Thank you for your feedback and interest in the swap tiers concept
I appreciate your willingness to review this series.

Regarding your question about simpler approaches using memory.reclaim,
MADV_PAGEOUT, or DAMOS_PAGEOUT with swap device specification - I've
looked into this perspective after reading your comments. This approach
would indeed be one way to enable per-process swap device selection
from a broader standpoint.

> Nevertheless, I'm curious if there is simpler and more flexible ways to achieve
> the goal (control of swap device to use).  For example, extending existing
> proactive pageout features, such as memory.reclaim, MADV_PAGEOUT or
> DAMOS_PAGEOUT, to let users specify the swap device to use.  Doing such
> extension for MADV_PAGEOUT may be challenging, but it might be doable for
> memory.reclaim and DAMOS_PAGEOUT.  Have you considered this kind of options?

Regarding your question about simpler approaches using memory.reclaim,
MADV_PAGEOUT, or DAMOS_PAGEOUT with swap device specification - I've
looked into this perspective after reading your comments. This approach
would indeed be one way to enable per-process swap device selection
from a broader standpoint.

However, for our use case, per-process granularity feels too fine-grained,
which is why we've been focusing more on the cgroup-based approach.

That said, if we were to aggressively consider the per-process approach
as well in the future, I'm thinking about how we might integrate it with
the tier concept(not just indivisual swap device). During discussions with Chris Li, we also talked about
potentially tying this to per-VMA control (see the discussion at
https://lore.kernel.org/linux-mm/CACePvbW_Q6O2ppMG35gwj7OHCdbjja3qUCF1T7GFsm9VDr2e_g@mail.gmail.com/).
This concept could go beyond just selection at the cgroup layer.

Thanks,
YoungJun

