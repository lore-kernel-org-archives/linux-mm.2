Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A284FD88FD
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 05:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71E0E6B0005; Wed, 11 Mar 2026 01:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5746B0089; Wed, 11 Mar 2026 01:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4246B008A; Wed, 11 Mar 2026 01:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 322C96B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:07:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A513E8C0C3
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:07:10 +0000 (UTC)
X-FDA: 84532598220.06.282D29E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3FB4D40007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:07:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eUxX34tx;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773205629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=22+qCSypJfYdCYbxatNIm6AZwnDwrgSpA+TT0A7a+k4=;
	b=OIuKfYXLTRMSgoYQxYmpXoMQxf0uYFbSx8pD9QbegaHLc41ZoiAq6ST1o/BT3f0Z1RhgPo
	Wtn3ghLucXJYv+o8PYuGMEdwgW9CGJuX0/GOVnC8foTlORe4KKI/21Z90XPfD17SwJjK6y
	oA4ZHJxsX+m28Tsv3XE5pvJ7brDjJqU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eUxX34tx;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773205629; a=rsa-sha256;
	cv=none;
	b=dZ9TKpZTkp2379GoPAmfpwOGnT0Ezouf4Nm8wNb2LDw9xnD2XXIIFkoMpSlf8SdRt5wRCU
	Biyt7gjkmKsGL995bZtfyijziJ4k0AaGStl3m4YIPmaA9AaAWDoP+1TgaAx98rV46h+KRr
	vviST7TuCZRu4CHYokigRrHGzl/XwxU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A6F5760054;
	Wed, 11 Mar 2026 05:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D134C2BCAF;
	Wed, 11 Mar 2026 05:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773205628;
	bh=faeJo8ihjOE+9bWVu9ZNPRNm5sUDD91envks+mZlquc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUxX34txTmCrHmBEwuTeX0N2rpfmmyw7vSLIbdrfUhGHvYen2D3nlcS7kHTAZ+Z1A
	 GUFkyVbUUwu3tXLqv5QAjs/Zijsc5DaUaNNvLfjcYosEsaISjSmVLClWXpnTpRSnw7
	 fZKd8Aa8LuIi8kIqa+W7gvj0FsVAUZFU02Va6nH3QdUmeOLtSYYLt3bsJjgvre/vtM
	 l+zQyxgPnnJ2yF+ez78OhMgdEGGLgJpt4XWDgZ+kmrA+uZBSWWluYswLOlLG8Brf2I
	 Ckgs9c7qbaQzBIUPCc+rBUvKRVa/94GOOmwyDspxn19WoMIjJt0OpSsvMQWf0HsERP
	 Ju27I8kYUStAQ==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] mm/damon: Support hot application detections
Date: Tue, 10 Mar 2026 22:07:00 -0700
Message-ID: <20260311050701.91686-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260310162420.4180562-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3FB4D40007
X-Stat-Signature: o7df4mrhb1tygakeeacoqa69p5mfrpkj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773205629-535017
X-HE-Meta: U2FsdGVkX19H7IdAH21cP6JWMPSOT3ehPzvWGTlu0ZZx6Yk6LP1bsfOwMcAlKUayiy0bXFaGVumn1oEeCfmxB3u2maiGJGN+kaYS3gJyNNkbqgeqgr7O0I+de+LbsSmaPMXly/eQJAuF5iZmajt3pdj8nyoVYiEyn7XGDweeuxmckyhomBfd6Qrfh7CtCdxFGg3BJIi1o25uDrUcPjfarbjvqf8BBLphUndFR1iWIqcGe/ARkwtTQ0YZpeMS8rGnBd+YXG126xQgW5Y/FayvhdCRAj007OpRBhIApdEYSQeL0LLRP8UiT1Dn905iuNaEm86x7pNXfjlqtapvNcmCfERgcSEWbgKgHx8DKksPBQ4GXAV9qcuLwT9mmPtmM11h6dHIWDo33ApdwWXHtNj92+3Ay/XEoNUoTeTYR/3lF8CJFJmBUqR1ZjAtPUyU+bjtu5xR3cBArisvkLdeUwwAsBmhfzZO4LEDJgO9v2liVCD7VZst8OSmKvWFrIV/LtYo79vIYxMAUaorq0F4eFozbL14jDE4WevHXFI3ZpIN7MXfldpfvFfmDk+cIZw5MoFnkkryLuGVsMFWkZQ74zeZTKugVWqDd+TmpfiMWqNnxQI/ma7OWh2/SHTu+GAnUwkHYx4cETrKXReWRtoSn7ZhJExfvx95BeSHjWylJ6eIuIhWtFsCI8O/JOtpW5iuid+Ruq/QlCizsGLuiHaJb6nnc7Npz82SvNk/+ZAKASO/p17XVtgCxN9eCEk7/40DYVKGmtOm48/x2NDA9GeGZAmEJn6UeUgfmsIzGcPZFiMn5U4J0zYvzmKr8EeilbmOpTyct60OaZF3DgLshnBZWa4wJG2XBBxsTIl1d4v+3ys+jv0FBsI4yG7k1HNqmdlpFPtcYPr8wSAhQ52WSZ18PASGrATXMqj0jIcwagOX1033iNSAkktPE4BR5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Asier,


Thank you for continuing this work!

On Tue, 10 Mar 2026 16:24:16 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Overview
> ----------

Let's make the legnth of the subject and the length of the underline same.

> 
> This patch set introduces a new dynamic mechanism for detecting hot applications
> and hot regions in those applications.

Seems now you offload the hot applications detection to the user space.  If I'm
not wrong, you should remove "hot applications and" on the above sentence.

> 
> Motivation
> -----------
> 
> Since TLB is a bottleneck for many systems, a way to optimize TLB misses (or
> hits) is to use huge pages. Unfortunately, using "always" in THP leads to memory
> fragmentation and memory waste. For this reason, most application guides and
> system administrators suggest to disable THP.
> 
> 
> Solution
> -----------
> 
> A new Linux kernel module that uses DAMON to detect hot regions and collapse
> those regions into huge pages. The user supplies a set of PIDs using a module
> parameter,

This sounds reasonable to me.

> and then, the module launches a new kdamond thread to monitor each
> of the tasks.
> 
> In each kdamond, we start with a high min_access value. Our goal is to find the
> "maximum" min_access value at which point the DAMON action is applied. In each
> cycle, if no action is applied, we lower the min_access.

So, this patch series introduces a sort of auto-tuning of the hugepages
collapse hotness threshold, that implemented in the new module.

We already have a sort of DAMOS auto-tuning feature, namely goal-based DAMOS
quota auto-tuning [1].  Have you considered using that?  Of course, it might
not be able to be used as is.  Some extensions, e.g., introduction of new goal
metric, may be needed.

Yet another approach would be implementing the auto-tuning in the user-space.
Because DAMON parameters can be updated online, updating the min_access from
the user space should be doable?  Given the fact the module anyway require
user-space control for feeding the list of applications to apply access-aware
huge pages collapsing, I find no problem at user space driven auto-tuning.

If the goal-based DAMOS quota auto-tuning or the user-space based auto-tuning
are feasible, all the controls can be done using DAMON sysfs interface.
Introduction of the new kernel module might not really be needed in the case.

We have DAMON modules in addition to DAMON sysfs interface for users who want
to use DAMON for a given specific use case with only minimum or near-zero
user-space control.  In this case, because it is already aimed to ask the
user-space to feed the list of applications to apply DAMOS-based hugepages
collapsing, it seems a new module is not really needed, to me.

But I guess your use case might have some special restrictions that really
require use of the module instead of offloading the auto-tuning to the
user-space or DAMON core.  Is that the case?  If so, can you share more details
about it?

> 
> Regarding the action, we introduce a new action: DAMOS_COLLAPSE. This allows us
> collapse synchronously and avoid polluting khugepaged and other parts of the MM
> subsystem with DAMON stuff. DAMOS_HUGEPAGE eventually calls hugepage_madvise,
> which needs the correct vm_flags_t set.

This makes sense to me.  I expect DAMOS_COLLAPSE to have some advantages over
DAMOS_HUGEPAGE for some use cases, similar to MADV_COLLAPSE vs MADV_HUGEPAGE.

From my perspective, this patch series is introducing three things.
1) hugepage collapsing hotness threshold auto-tuning, 2) the module for running
the auto-tuning, and 3) DAMOS_COLLAPSE.  To me, it is unclear if the first two
changes are really needed.  I will wait your answer.

Meanwhile, the third change seems reasonable and not necessarily need to be
blocked for the other two changes.  I think separating the third change from
this patch series and upstreaming it first could also be a path forward.
Because the change is simple and sound, convincing me would be easy.  I'd be
convinced if at least some reasonable test results can be shown.  I'm not
saying we should drop the other two changes.  We can keep discussing those in
parallel.  Rather, upstreaming the third change first could help finding real
benefits of the other two changes, since the testing will be easier.  The
decision is up to Asier, of course.  I'm just sharing my two cents.

> 
> 
> -----------
> Changes in v2:

Let's keep calling this "RFC" here.  When you drop the "RFC" tag, this might
confuse some people.

Also, when you add a changelog of a patch, adding a link to the previous
version [2] can help reviewing.

> - Previously there was a mechanism to automatically detect hot applications.
>   Based on SeongJae Park's feedback [1], this was removed from the module, leaving
>   it entirely to the user space.
> - All allocations now use kzalloc_obj.
> - Since the user space provides now the list of pids to monitor, a commit_input
>   parameter is added to allow changing the pids while the module runs.
> - Renamed the module from dynamic_hugepages to hugepages

Thank you for doing this, Asier.

> 
> [1]: https://lore.kernel.org/all/20260211150902.70066-1-sj@kernel.org/
> 
> Asier Gutierrez (4):
>   Damon_modules_new_paddr_ctx_target. This works  only for physical
>     contexts. In case of virtual addresses, we should  duplicate the
>     code.
>   Support for huge pages collapse, which will be used by
>     dynamic_hugepages module.
>   This new module launches a new kdamond thread for each of them. The
>     purpose is to detect hot regions in a given list of tasks and
>     collapse them into huge pages.
>   DAMON_HOT_HUGEPAGE documentation
> 
>  .../admin-guide/mm/damon/hugepage.rst (new)   | 186 ++++++++
>  include/linux/damon.h                         |   1 +
>  mm/damon/Kconfig                              |   7 +
>  mm/damon/Makefile                             |   1 +
>  mm/damon/hugepage.c (new)                     | 441 ++++++++++++++++++
>  mm/damon/lru_sort.c                           |   5 +-
>  mm/damon/modules-common.c                     |   6 +-
>  mm/damon/modules-common.h                     |   4 +-
>  mm/damon/reclaim.c                            |   5 +-
>  mm/damon/vaddr.c                              |   3 +
>  10 files changed, 650 insertions(+), 9 deletions(-)
>  create mode 100644 Documentation/admin-guide/mm/damon/hugepage.rst
>  create mode 100644 mm/damon/hugepage.c
> 
> -- 
> 2.43.0

[1] https://origin.kernel.org/doc/html/latest/mm/damon/design.html#aim-oriented-feedback-driven-auto-tuning
[2] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

