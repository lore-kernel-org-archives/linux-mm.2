Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16BE2CAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 17:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50EDA8E0014; Tue, 23 Sep 2025 13:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6738E0001; Tue, 23 Sep 2025 13:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC868E0014; Tue, 23 Sep 2025 13:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC258E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:58:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DAE895959B
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:58:58 +0000 (UTC)
X-FDA: 83921275956.02.2CB7830
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id E46C1A0008
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:58:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v0DGtYaT;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758650337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yYKyXs58ep6KuR+AMq5KlViCjagWm/Z5ncA3hHpUIH4=;
	b=mhvrDAS/CpNos6mmR7V/soAMnAS2GsEHjAHoGZs6CAL8SW8t33yEwOFHudc/A3DWAB5csW
	vxA4VP5VZKpKE9ujsaDngmFmqU22bc3rk2Ysm+kK7CnXFmv5d2ZgheTz3rw81yRjmEEdZk
	Tv85vYWFbFxAW3kvk8uNqw9i8Wo8JFg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v0DGtYaT;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758650337; a=rsa-sha256;
	cv=none;
	b=nFn+izYimZRMcoeevRoCJexhy6EBfN6m4BiltOfxBHn+6GAZGbj4eh0tXwNW5qG+qNxhdp
	ma5z/BF7cEUfg9x5O+bLo0G1zTS4Z3hWH7tXUIR93+NgkQaUQrA2KJxpbXrgtuN+dC9RiG
	WPuzqXCJwm96WWCYVU0ggyLDEYyhAlQ=
Date: Tue, 23 Sep 2025 10:58:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758650334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yYKyXs58ep6KuR+AMq5KlViCjagWm/Z5ncA3hHpUIH4=;
	b=v0DGtYaTVzThHF6HsIWYKdJB/qBlprObAXIATcqkmwxmMa7V6QoGhVss3iKlYuSIRwPGGc
	nG1tSqjYBS7hiT/YHjzG7YrQINl0nQ4gjEL/4PREyAph7Gi50E8x6XFX2RIKufm3NYgCRo
	xD+0stdmC/cbEWobkH/e/YB9EgK6T8U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, david@redhat.com, chengming.zhou@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH linux-next v3 0/6] memcg: Support per-memcg KSM metrics
Message-ID: <4sunwlleii5mrlwvnio4rm4uvrngzcdbsig7xer3ytyixpu543@7dlwpeeocjbl>
References: <20250921230726978agBBWNsPLi2hCp9Sxed1Y@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250921230726978agBBWNsPLi2hCp9Sxed1Y@zte.com.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E46C1A0008
X-Rspamd-Server: rspam05
X-Stat-Signature: wtwfc4ydczr17bmcu6ip6rdhw958ghuh
X-Rspam-User: 
X-HE-Tag: 1758650336-928908
X-HE-Meta: U2FsdGVkX18xGo4u245cItpnSkzoxQGVsU9SNpu0GD/XlwzEBiGik3VQ3o5Y8rLejQxWpEIibLZS8VzpOKj3Z3dYVL6hP23ujTOcO4DtR6JZhHr0MonlO8jfYKanBQqVuGIHNoDlQ52lHJFcNRLdfs52hxhzeLTAaV6tvFINcn7nLU7ggioHpPaHPltND8qB19SvK+sY8g4rM2cwXemeeZ2bFTYmS1OkWGXMNV2hi8kaYyIvZd7iKOsRSYPRozfYEfOTsGYoM0ukZzlG6mCSngtJPilSh0k/bL5GMD5asGoqOR29cUpTYDe91LClNDI5XA9WUOuT7mSV89gAob+MqNCRoUp64cqvwQwjZ9rcXEtPKZ40sy0zil6B7s9uUVfY52HqmlLEsehTSofaNCXzCC8rm1k/jimYZAIX+alYmCXVuSPeRFpMjXMYjcUPzT96K9W3WFCgQacJN7AiBtNkF3bQorXc1vdvD/6KY5RxeVjxq4NTuUS+wXvRjT9/BhdD2Qumf3Q/WT9QiJyoGhbLzcNq+CgtP7N//vtisVcwazqnkWCOEV1FPpUTiXbfTvlMng1h7GtfrTpqViRAHnu1JFqr3rEeYi8X5NAqqeiD8OqeLel+pjREhMvPJtF7Nu47pDHVCjl+YioamC2bOa87799iK2qQj8aXjDEa+2Chp1pS8OZY42GT/QzCJneqgdBCdwcEGk10CnQz36zAeK2jQIdOEEyM+p7G4vBQ/oX9TG6rY977OSnuiw2DlvuP4kRR+RUI5qq6Q7uzn144GZS87n8iyS31mdlZ5GOVjy9ji8EV3z7bRaNjgQhRjP5hPI6iud2JFQ3SbIRfnrutl6l05TzkqjHNFgFlCZO7ZJHUaVJnkErtqq2atajAlLpdopWTV5gDmRtmpg6tZ2lX8BLraSR65dTS3nUgAkIYwGv5f0d1IFL6FPGo043tNONGtc9S9Fw8L8ECYRH+vgF3jgs
 YtNvETq7
 ZP4UN57fJil5yIanqCHzH1qEfFUScQNCnrgTg80KEBk/ysB44ZhHOpw5yqBExBXshnsXF+rYGhh62tB20ZejwzUJAx66hXidxqJQIvgdFySgTr+9e1KsPVV+nyqjXGhWt7BNBqDfbZzUmlvPl6pCB41iTKdgF340mOLfWGVtQ1KXGk0mdko1mnAmhVvF8NdAIVoroePEP3RJVoSBuWBFjB+GFvB8kg759CD9LEeRFCqZ56q2aH7gJA8b8awlbtQk51psnXIBZY7lZCirnxcTZJuYluZZEgukiilisVv2Ok4r/PktX/3455+KBvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Xu,

On Sun, Sep 21, 2025 at 11:07:26PM +0800, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> v2->v3:
> ------
> Some fixes of compilation error due to missed inclusion of header or missed
> function definition on some kernel config.
> https://lore.kernel.org/all/202509142147.WQI0impC-lkp@intel.com/
> https://lore.kernel.org/all/202509142046.QatEaTQV-lkp@intel.com/
> 
> v1->v2:
> ------
> According to Shakeel's suggestion, expose these metric item into memory.stat
> instead of a new interface.
> https://lore.kernel.org/all/ir2s6sqi6hrbz7ghmfngbif6fbgmswhqdljlntesurfl2xvmmv@yp3w2lqyipb5/
> 
> Background
> ==========
> 
> With the enablement of container-level KSM (e.g., via prctl [1]), there is
> a growing demand for container-level observability of KSM behavior. However,
> current cgroup implementations lack support for exposing KSM-related metrics.
> 
> So add the counter in the existing memory.stat without adding a new interface.
> To diaplay per-memcg KSM statistic counters,  we traverse all processes of a
> memcg and summing the processes' ksm_rmap_items counters instead of adding enum
> item in memcg_stat_item or node_stat_item and updating the corresponding enum
> counter when ksmd manipulate pages.
> 
> Now Linux users can look up all per-memcg KSM counters by:
> 
> # cat /sys/fs/cgroup/xuxin/memory.stat | grep ksm
> ksm_rmap_items 0
> ksm_zero_pages 0
> ksm_merging_pages 0
> ksm_profit 0
> 
> Q&A
> ====
> why don't I add enum item in memcg_stat_item or node_stat_item like
> other items in memory.stat ?
> 
> I tried the way of adding enum item in memcg_stat_item and updating them when
> ksmd manipulate pages, but it failed with error statistic ksm counters of
> memcg. This is because of the following reasons:
> 
> 1) The KSM counter of memcgroup can be correctly incremented, but cannot be
> properly decremented. E,g,, when ksmd scans pages of a process, it can use
> the mm_struct of the struct ksm_rmap_item to reverse-lookup the memcg
> and then increase the value via mod_memcg_state(memcg, MEMCG_KSM_COUNT, 1).
> However, when the process exits abruptly, since ksmd asynchronously scans
> the mmslot list in the background, it is no longer able to correctly locate
> the original memcg through mm_struct by get_mem_cgroup_from_mm(), as the
> task_struct has already been freed.
> 
> 2) The first issue could potentially be addressed by adding a memcg
> pointer directly into the ksm_rmap_item structure. However, this
> increases memory overhead, especially when there are a large
> number of ksm_rmap_items in the system (due to a high volume of
> pages being scanned by ksmd). Moreover, this approach does not
> resolve the same problem for ksm_zero_pages, because updates to
> ksm_zero_pages are not performed through ksm_rmap_item, but
> rather directly during unmap or page table entry (pte) faults
> based on the mm_struct. At that point, if the process has
> already exited, the corresponding memcg can no longer be
> accurately identified.
>

Thanks for writing this up and sorry to disappoint you but this
explanation is giving me more reasons that memcg is not the right place
for these stats.

If you take a look at the memcg stats exposed through memory.stat, there
are two generally two types. First are the ones that describe the type
or property of the underlying memory and that memory is associated or
charged to the memcg e.g. anon or file or kernel (and other types)
memory. Please note that this memory lifetime can be independent from
the process that might have allocated them.

Second are the events that are faced by the processes in that
memcg like page faults, reclaim etc.

The ksm stats are about the process and not about the memcg of the
process. Process jumping from one memcg to another will take all these
stats with it. You can easily get ksm stats in userspace by traversing
/proc/pids/ksm_stats with the pids from cgroup.procs. You are just
looking for an easier way to get such stats instead of manual traversal.
I would suggest exploring cgroup iter based bpf program which can do
the stats collect and expose to userspace for a given cgroup hierarchy.


