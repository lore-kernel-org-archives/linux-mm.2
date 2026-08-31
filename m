Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75CA5C61DF0
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 06:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88B056B0092; Mon, 31 Aug 2026 02:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83C1B6B0095; Mon, 31 Aug 2026 02:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 778506B0096; Mon, 31 Aug 2026 02:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 524F56B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:09:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CBE72120218
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:09:21 +0000 (UTC)
X-FDA: 85160537322.17.E5E10C6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 09F0F20005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:09:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NhYV4X83;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788156560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VMR2Ax0HEHV+Sm6RNjfQGHOwJAKk2JlFWoDHWXOR2yE=;
	b=3UmBkjVeZkHG265q5v1dQb5rdSAkBVLHNrUJWaA5l1DL2T2JYZmzVX1rgN0DgmVmoYpF27
	aD6RI266NhlJNWON4ZLqGd0osNE67eTvFpjk3ZHqoBKaDaCwo5MAoyonmDJM1aQ/W+IEzS
	RrmX7srIqNG3dXGTz7SuPz4tdyBNyIE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788156560;
	b=L2kY1MPje69q/ppEEgrMFuP8nh38pPLF417cQsq4chV09R7hHirtJ9p/vSUFTnlz3r41lK
	hy4YDNVw8cuL1lTta8U7RdhzU2nU+cQj6bTwH6uT1vg/9Yc3Qx8nx1c+aKlBgtgkglLYFr
	qIRTxLTX1IZmRCLp4vVIkO54WYwT5eA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NhYV4X83;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 53E8E14BF;
	Sun, 30 Aug 2026 23:09:15 -0700 (PDT)
Received: from [10.164.19.53] (unknown [10.164.19.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B26A3F8C6;
	Sun, 30 Aug 2026 23:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788156559; bh=XMjiDlUWUD0lEd7uWazW4CIIYSMDuTnUsQicLckbR0U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NhYV4X83xcSoXc3krWIy4c3Q+4GvV8j3Y57msAuhGticUjas+j+t63IiPIfMJvy5W
	 KW+KG96C0prQYGADilYGIQGFNyltA9FGVa9sJow3Y2qfbNdqB0OZ0zGzlajZIdpI0k
	 qXFVh4f93XkmBsi/ll3CHAAQCaG84ssRDmjaawC8=
Message-ID: <bec5eaef-d084-467f-9bfd-43f7dedc1aa7@arm.com>
Date: Mon, 31 Aug 2026 11:39:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: vmalloc: fix vmap_purge_lock livelock under memory
 pressure
To: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <ye.liu@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Ye Liu <liuye@kylinos.cn>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260828091753.299295-1-ye.liu@linux.dev>
 <20260828110503.e1eff32a9b7df9a8b2ddd4d6@linux-foundation.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260828110503.e1eff32a9b7df9a8b2ddd4d6@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 09F0F20005
X-Stat-Signature: d6xt9ixb9coadcf3qj7fthumsenfyumt
X-Rspam-User: 
X-HE-Tag: 1788156559-693239
X-HE-Meta: U2FsdGVkX193EZ9ZZA3T+dSIpcaDH+xWDsIAv2G9zXaujBcME3/3B5KsFcccSI1V8PsCw4TiBJLhqaf4ync2isVxuqKYC9h9MeLSTvIIBjzs2XmuOo1qXmSrElClz7QJb46B9W0mMhDF6cUWfyzq/yWnicVTnrTbCb8416v0Rixw29tQO53betPGPsMFXJ7wgUid8OxmRmh3y87ZM2e0r7a3zdlIp/uL0Pv3gBl26VvLxASaiWGzIjelOrjhmQ2ImYaWGvLgvCISrlogGEkXPyUKSsSMCl0r5PzR5EmDCSG9HfzWpBGNjJO45W3fb2YycDe6eREk11BxZcyNHkePjxbvsoHiK3tyltkanYxMk/BW2ccNGvM13YINmipv1VOTqqnNsojZ2wdp44osjVQIHuWPyAsG0Ps1LOrvAPRMRIF6Izt3Pv656mvzLJQoaFUJHyMYBK3qf1J+irgaeWbPRUtFtaNZ4xLCdnv6d2ka/EpJ/PGGlBTsa5WAFMSukUSd+AR3JLgd3gn/TGfgpMjjJDCfwnUVPUGxZT0LzQNYrEgOlu9ftHFK9rdvlScOllf9M0sSQJC2AGbX8vcMomQYQjw/GzPr6bWodbZxEzZgOZv/80NcWQT1PlyHETt6xr+a7s8U3+OhR4VUSR8FNiX990o7ZAob00emAJv3C2PcV8rbqqSxjQlbNkT2FMdlonrgnFCSJ4k6C0kxfIaQFdJecmdLzfX9a+1hs3pS1D+Jn/FCPSyaMxvkNWpXeYnkVNQtpBycnlH5wIeY9C4EGJMDxxS96JAT/tHuSvQ/gTh0VJEwWC8Gu/GryJbEN6S+ebKUrKhSUwuWvGVyVO3ek0rinw4f06+wP4dwldCOAik+ePlDqAk0EABG9j2NG/r+jr4sxMAB9i271XeHaplRYpImQT2yYK6gtsxVyTJCbk8r/wCAnP4RfIBBO4mmODF7F8H/eas2UwZ6nnAJAKaBVuh
 Hwc95s3K
 4btIuQFLdMw9fzCgHFoV7xIESRpFZIE2Lfwk497c4lkiagpXpyvzb9M5+ll92CG1U9AHNywcl+RGaK2287lxjbcQyXV4aEXZSTWb1toSz/I/hQy8Wyy/kwf1gSJic7hUwQzKpwipl3iz8wFBwnsu8S90dCgmimz7edFNcYDqQWkTPaF6+dDSOT5Lw1fyIYL3wS/qWR17VbqkEdTyU1Kktn2+cBl8HLJkCddgaTM949HRDBnvMrF5rNnT5GB6sRAvf3Pyt5onV5HJ5V1ODUilOWcHkKony1iGRblRG6/hzl0dF492if/YuDRKZywHg7A00E4Zx5169nK8HHbBsCT5D6ANJjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 28/08/26 11:35 pm, Andrew Morton wrote:
> On Fri, 28 Aug 2026 17:17:53 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> 
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> The vmap_purge_lock mutex can be held for an extended period by
>> __purge_vmap_area_lazy() which calls flush_work() to wait for
>> purge_vmap_node workers while holding the lock.  Under memory
>> pressure, those workers may themselves be blocked in direct
>> reclaim trying to acquire the same lock via the
>> vmap_node_shrink_scan() shrinker callback, creating a circular
>> dependency that deadlocks the entire system.
>>
>> Two places acquire vmap_purge_lock from paths that can be reached
>> during direct reclaim:
>>
>> 1. vmap_node_shrink_scan(): replace blocking guard(mutex) with
>>    mutex_trylock().  This is a shrinker that only decays the vmap
>>    pool and returns SHRINK_STOP without freeing memory; skipping a
>>    decay cycle when the lock is contended is harmless and prevents
>>    tasks from piling up on the mutex in the direct reclaim path.
>>
>> 2. reclaim_and_purge_vmap_areas(): replace mutex_lock() with
>>    mutex_trylock().  This is called from the vmalloc allocation
>>    overflow path; if trylock fails, another thread is already
>>    purging and the allocator's retry will find freed space.  The
>>    notifier chain provides a fallback if the retry still fails.
>>
>> Both trylock failures break the circular dependency: the lock
>> holder's flush_work() can complete because workers are no longer
>> blocked on vmap_purge_lock in the direct reclaim path.
> 
> Thanks.  AI review expressed a couple of concerns:
> 	https://sashiko.dev/#/patchset/20260828091753.299295-1-ye.liu@linux.dev


Sounds legit to me. Now there is no guarantee of purge being successful, and we
can get a spurious failure.

How about using a WQ_RECLAIM workqueue:

vmap_purge_wq = alloc_workqueue("vmap_purge",
				WQ_MEM_RECLAIM | WQ_PERCPU, 0);

I see the same pattern in __lru_add_drain_all() and kmem_cache_init_late().


