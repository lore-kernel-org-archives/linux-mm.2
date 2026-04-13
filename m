Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F363F34C5E
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 14:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7334C6B0089; Mon, 13 Apr 2026 10:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70A4A6B008A; Mon, 13 Apr 2026 10:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61FFA6B0092; Mon, 13 Apr 2026 10:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C02B6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:53:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B96CBC02B7
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:53:20 +0000 (UTC)
X-FDA: 84653825760.02.30F98DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id CCAA520011
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:53:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lyhdxi9+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776091999; a=rsa-sha256;
	cv=none;
	b=fvs/ruQCAyNZGpzuc+4KvTlHCpecZD6R3EMNEgUMJT6HSDM9qzR1+rUut941VMx98j7SwD
	XoVcMbCGxu6BEeU0u0L43Jr7gXhdcDt9p78+9WkYxabBOD1OXL+8LbW9K9VdAYzrYJdf0m
	8AbmzSrraY+w2aeyzfSSiecfOSgPOnA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lyhdxi9+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776091999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ce/8afoozu+GpInTG8dyDm8kkXm2KmbQ5zMyyw/wLXY=;
	b=VaOI1juBp5IAEr/JVJc9CnXjG13vHejFLTkIrr9TMQEy2E1lmndmE+2oBKSs//Hu+ZsxsI
	vwL8vQCzRaIy16MaXVwF8Mkd6gN1DpZ5hDVGxRNndPKUlTiKfEuVBNysTzVwJ1s8rHvLPj
	nTHGl3e/OtMSLb+ddn+epROPIUD0dUE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C1D0940D61;
	Mon, 13 Apr 2026 14:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B031C2BCAF;
	Mon, 13 Apr 2026 14:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776091997;
	bh=SmlzEupAcTl8dpDl/4W91ji9DI1If1QZKHMeX0jJhQE=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=lyhdxi9+o47SLGVSzeL9CygkaHYOoek0pzdVy7BBu91dQX4084zZ82Wv/hwCilFgh
	 MGOPAIAfVk6v9hiIYj9WGra1wNEygiJb8BF34YYdTYlMXp8x8F8P5Zdxd0CDAsrgSm
	 NQviKLgaFxwNCDEPdomHWocsjqctyl1FltdwYiiTYLPHYdzz8gnSL0UzOyrCPxyKdD
	 jMyRjny+JBeV+/Wd9KzczDO8aEH+9qURUzJCBzjEiir8JtKDh0Gkq4j8itRc6EEOlb
	 HwI9sucCsSOY7ISuTWPS4vCzlzeLbmhgBj8an1UbxrVXqvWEhW35mDm09diJl2asZC
	 kaGLCumaCmRww==
Message-ID: <ac9455ad-21cd-49e9-a6fb-9f25175b5681@kernel.org>
Date: Mon, 13 Apr 2026 16:53:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] dax/kmem: atomic whole-device hotplug via sysfs
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 osalvador@suse.de
Cc: dan.j.williams@intel.com, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, kernel-team@meta.com
References: <20260321150404.3288786-1-gourry@gourry.net>
 <4c08c0a8-9415-4f30-bfa9-db39318fa7d3@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4c08c0a8-9415-4f30-bfa9-db39318fa7d3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 83i8ja1gcahpttcifxtgfbokja1ouu3y
X-Rspamd-Queue-Id: CCAA520011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776091998-840508
X-HE-Meta: U2FsdGVkX1/ktPNYjBtulhqRRHdUb1lI+maADfHVeNd0vI3D4Uv6hJJXITlEWrq1lJ8bz6yGKcANz3GW4+90PINeq4pxGCGc29vIZqPIHWkb8JVYNvn+nelsGDXomKLoPVFq2MegMzs98umSqFUqmf2DXkcnITzKzmatVIqYbAeYjeuw+Opq8xeKFAudTUP8p3iloyjPJvN17vHS727MqYp23n8pDJRaec7vthxLKk4dxoaRGkqrzN6yHD8HRsNC/KoMSzx5ETCJTgrtdy18Sy3cZHqNyvsfhbKTtQOO9q0prDvrm5qw1WvG6Mcf2u9zdRt8Hs5tlEU7I7sJdReYSdNjk+dbtQ/kinv8SwuoMWdPRRoxAYYzVccmePWT8QVXSRKWo0kdetuh2E3cashJp4OdlUbSZt+NK7h40emOMiC2AuqnQffYT1BWR0jI/ewFSNFiQ0P7SEef21hts+2zNDY/96wnuVqMzCqaIMNP0+UszuTVFUy+CDVTbejzHnznljlk8KOZ1hcJ1YHxuMxBd8IJgIGmP+glRF9QFpU2z/YnIZCu3JVSSBlImQqoqxOk10lRVJ9+LNZaGrjJs71YlSOQayCoK2P7EGUVJxZmFseRKKb/QuA7CV0Bw90AnrvjiYG2mKe1QthmN6wS7e8jJlp4DAY9LcP8sUtPez+/wijiXD7c6Y9pMxibgu8QFZDyMAOToTas6qRTjRe8VvDNpsbltcqevR/ZQ+Vtbv0tDyY3VjNQL95LU6lGaVOxW6C177+TNCTqdN8IHaJiYY+SwRf/EOBOfB9+VoBNCBAnsE9xokZwMX2omCoqzZVtYkdpcxGJQUnVFZ7zQRxkxD3HuVOBVbaOh7BZSXB2RNUZz9/CvQpT3FOksZWk/pMgF5+a6PYkhTexLwwD1DMgR0lXahNG/sZ9wQdz+vSnpIzjd2MwSOD0GhgjSfSVMTIf3a5mtD6CIRix3hymDb3gTMs
 Y1H01ycx
 ceNMTzY0Tm/nqyWqNnUqxy7b3rETo9utTsTuzzJMmyEsWB0s8pLt0Fe0FJ1lBgc8jjVfJxZZhHqA1TObKqOoSkKxbDEaaS4Y0VFwiWE3xvrmLsBuDPoIi1n8cF2TcVp0M/PT1/OXwGSeDhAhUUDjhSQ2fLNNEObxTkrn4D74q0EY3Ic2Q2IYz7IVKxjkCLQe5RCT2Ev2byktrWbcqDhMy083/o6GQwnURlK4lqi458d6f03wbPaI5G1SXTmBMEK6wOOZc81qf8unLhqm0ELxW36MsttrsRr+ajqNFAQ8+O+/CIU4C+wDnbwno19vNT0FwXt5sM3SfiU7ozhIl4ZMwZX5Hn46WkKxYcSExs8POGP7zF97UMCbTGTvbNH3+pJM8d6gpbV8V/1X5YPLUnxAfxH9lR4kWYsv+mQ96culm7eHDu+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 16:49, David Hildenbrand (Arm) wrote:
> On 3/21/26 16:03, Gregory Price wrote:
>> The dax kmem driver currently onlines memory during probe using the
>> system default policy, with no way to control or query the region state
>> at runtime - other than by inspecting the state of individual blocks.
>>
>> Offlining and removing an entire region requires operating on individual
>> memory blocks, creating race conditions where external entities can
>> interfere between the offline and remove steps.
>>
>> The problem was discussed specifically in the LPC2025 device memory
>> sessions - https://lpc.events/event/19/contributions/2016/ - where
>> it was discussed how the non-atomic interface for dax hotplug is causing
>> issues in some distributions which have competing userland controllers
>> that interfere with each other.
>>
>> This series adds a sysfs "hotplug" attribute for atomic whole-device
>> hotplug control, along with the mm and dax plumbing to support it.
>>
>> The first five patches prepare the mm and dax layers:
>>
>>   1. Consolidate memory-tier type deduplication into mt_get_memory_type(),
>>      removing redundant per-driver infrastructure.
>>   2. Add a memory_block_align_range() helper for hotplug range alignment.
>>   3-5. Thread an explicit online_type through the memory hotplug and dax
>>      paths, allowing drivers to specify a preferred auto-online policy
>>      (ZONE_NORMAL vs ZONE_MOVABLE) instead of being forced to the
>>      system default.
>>
>> The last three patches build the dax/kmem feature:
>>
>>   6. Plumb online_type through the dax device creation path.
>>   7. Extract hotplug/hotremove into helper functions to separate resource
>>      lifecycle from memory onlining.
>>   8. Add the "hotplug" sysfs attribute supporting three states:
>>      - "unplug": memory blocks removed
>>      - "online": online as normal system RAM
>>      - "online_movable": online in ZONE_MOVABLE
>>
>> Transitions are atomic across all ranges in the device.  Backward
>> compatibility is preserved: probe still auto-onlines when the configured
>> policy matches the system default.
>>
>> Specific notes for maintainers:
>>
>> I downgraded a BUG() to a WARN() when unbind is called while the dax
>> device is not un an UNPLUGGED state.  This is because the old pattern of
>> toggling individual memory blocks is still used by userland tools, and
>> will disconnect the `hotplug` value from the actual state of the overall
>> memory region.
>>
>> Unless we move to deprecate per-block controls, we should just WARN()
>> instead of BUG() as an indicator that userland tools need to be updated
>> to use the new pattern (the old pattern is subject to race conditions).
>>
>> The first two commits are semi-unrelated cleanups that conflict with the
>> changes made in the refactoring commits. (memory-tier dedup and align_range
>> helper). These are intended to be used for future cxl region extensions,
>> but if you prefer them to be dropped or submitted separately let me
>> know.
>>
>> This is technically v3, but the patch line has diverged considerably and
>> I've reworked the cover letter, apologies for prior obtuseness
>> Link: https://lore.kernel.org/all/20260114235022.3437787-1-gourry@gourry.net/
> 
> 
> Hi Gregory,
> 
> against which branch / base commit is this series?
> 

b4 am --guess-base

Was helpful :)

-- 
Cheers,

David

