Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DACBBC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 10:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBB096B0092; Tue, 14 Jul 2026 06:53:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B926E6B0093; Tue, 14 Jul 2026 06:53:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A81C86B0095; Tue, 14 Jul 2026 06:53:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82C216B0092
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:53:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 06755801D7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:53:31 +0000 (UTC)
X-FDA: 84987071022.07.D96085F
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8A098A0004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:53:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hr8CWtXv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784026409;
	b=FxSoSM3Kdy6HUp6Er0/dIdGQYi+jsLnZ3p/2587l513j/QT7ec1XzRTvwTGlIDvQKTq5oG
	gMmQHuMsu7YhcCEpbb2pie6MTlTBGGtsrp7EOh0uQvhmfMhHTC+NbZ1L0/l/wz43zhDKEd
	+1UkoulGtlQwPnXSaN7OKYy14XHFtRA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hr8CWtXv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784026409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/LDmA+4RVpARa99Ab+t/25jrDC9AwuxQ6Gu81nLkhgA=;
	b=do2CZmEFCgRLeWAGH5FMPmGVPm8xYpVGgu7eC0UOQcCs6veCncv6cUrFltO8X/ofW0WHDK
	YOCBzOPtGH5owB13eT04DrNNpopx2fdyx33m/P3hP3pu4f30MFihgCgRAO26B8ouH91RBH
	IleY3fLRYXnHXrPfRvUc9KAmUDgBrss=
Message-ID: <3f87f6af-3952-4c16-83fa-9fb77085a285@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784026406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/LDmA+4RVpARa99Ab+t/25jrDC9AwuxQ6Gu81nLkhgA=;
	b=Hr8CWtXvQzP2VMAmcJlnKckqOOTkk3iGdGQicebeUy0g3l/oGG59Ca4fqkEdungTTaa/3y
	baGS7gF9L5q6kyZ1BETnjjODc9EtUAVdVkjDAmOhhK8BYUUSrIPf3OPRXSMx5QH7UdyR7s
	rr088010fIg34Lex3w5OKYga2sdvUUo=
Date: Tue, 14 Jul 2026 18:52:49 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in memcg
 slab shrink
To: Usama Arif <usama.arif@linux.dev>
Cc: brauner@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, hughd@google.com, boris@bur.io, clm@fb.com,
 dsterba@suse.com, linux-btrfs@vger.kernel.org, cem@kernel.org,
 linux-xfs@vger.kernel.org, shakeel.butt@linux.dev, hannes@cmpxchg.org,
 riel@surriel.com, kernel-team@meta.com
References: <20260714101740.1270419-1-usama.arif@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260714101740.1270419-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8A098A0004
X-Rspam-User: 
X-Stat-Signature: uqbu7apps8ar8jrnnfntq4xp8kd5dd3m
X-Rspamd-Server: rspam03
X-HE-Tag: 1784026408-172065
X-HE-Meta: U2FsdGVkX19hfIy9JmMpPk3CsFLYeoXXIQzXaPUrHL+SC2ITCXW7f8s59spk53HIseJ/gYrtGM0fmK6T6M6KK7mweWTeT7bJ88Qk/vBJpwfIV/a8WfHdeLaQ0xp0FC+31I6gAzqE4P9h3qJA8RcmwLQpkY2cwf0Uqxr49AgLb+seYAL1KVDetIFW1gKam49d938g6y2Ptq7CGw1Bs40tMSDLY3virCMQnO7nWTDmrg4y85yi9o8vhoRay1vmwapZMMvk541xbV4aPQ5sBG43koatSEpaJVFSzAyjbZ0AtZGN5e8ySBaQt8efOhQsq5RjWGItcLkbrZkuvAAo4V9bbfY5jPL1lEKr97/gVVLVK9O1w+QIXthRXIQmA8D7DJhvdTc8NKyEf/RLe7+pwqGr1a2+OeD4ZvNRCQiLiLyllDVDvBHbZy258pot3NYlpExan6fv6H3255hC5cTwSfoc35UOsaIIJeCVjTmPno0m6AXHH6WHuTAWUKr25KcExX9nmLjwSONGLJUAD9+elAYI1pCY+ZBIyHm4vRuIBT7By6+BrThB6YSmDIoroLDqQM4x0PE71AKG/v+fCqvvI6McUAv7gt1636S7jP6k1ceXkGx8tgxqtVCj1TUnS91iv8Y0HsXvZgLOR3TMc02yL06J/2GoA0+QYfIT0NHQ/2ThWJNXJ5vEq1C5tb2vXjNlJpfRUxzWAobhirly9DUcEXDAV2LL1sWALrVu8KgLZOkNdzQht0eeC7kpGpMEp/r4l59gWq0BJAvOS4SHoNCX8TqaRJ3GWVFGVeag0OAVxuqffN+CAyfA6r2R35DfnGAAVJY0l8PBZj/WZtmQu3wtQv0CIrMGlcefkrKcJUjx8HkGrVNjKNlb0rLvM7yIcyzw6y7jIDWk7JwwcngH/Fw8limeeHKKgNnXfTSEVWRCMJ8/ulIKYuFHT88+ZvEYpk3o3ZV9nVcGJowwyy+Qzyu9VkO
 KqSwBBnh
 31LDg/Wja4kStaURaww9y3u48DGJDHuCeTGggUfma7IXz8+GaObVvOsAChNOeBYTTEXfg6dBkHSzh1c9RF1GRdvPXwpERMbdJYXLYgNyD8QNY9eQa0jyOZqApB+jnNio4xz9hXA8tqnEQQ7lD/KWOI1QTRsRFv3zImLEaVPdy2AnYkOegLSfO+jcQYmhKS42xwfLg7Wim04/rwyQlzjx1r5bU20P/rQ+1O1sC62ChJfixKAC1eG8RdZsI+9jaFvCcxR6YowV2yqQJhODHRwqurnYV9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/14/26 6:17 PM, Usama Arif wrote:
> On Tue, 14 Jul 2026 10:09:26 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>> Hi Usama,
>>
>> On 7/13/26 11:34 PM, Usama Arif wrote:
>>>
>>>
>>> On 13/07/2026 14:12, Qi Zheng wrote:
>>>> Hi Usama,
>>>>
>>>> On 6/9/26 8:30 PM, Usama Arif wrote:
>>>>> The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
>>>>> dentry and inode LRUs are memcg-aware (via list_lru). But the optional
>>>>> ->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
>>>>> btrfs extent maps and xfs inode reclaim operate on filesystem-global
>>>>> state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
>>>>> None of them filter by sc->memcg.
>>>>
>>>> This makes sense for now, but how should we handle this if these
>>>> shrinkers are made memcg-aware in the future?
>>>>
>>>> I've recently been working on making the shmem huge shrinker
>>>> memcg-aware, but noticed my changes broke after rebasing onto the latest
>>>> tree, which led me to this patch.
>>>>
>>>> As for the shmem huge shrinker, I can work around this limitation by
>>>> making it a separate shrinker. But this feels more like an overall
>>>> design decision, effectively meaning that all nr_cached_objects are
>>>> precluded from being memcg-aware.
>>>>
>>>> Thanks,
>>>> Qi
>>>>
>>>
>>>
>>> Hi Qi,
>>>
>>> Thanks for raising this. I think the alternative is what I mentioned in
>>> https://lore.kernel.org/all/cfdb8620-ea55-4226-98bf-d006820e6270@linux.dev/
>>> move this down to the fs own callbacks instead of here. Would that
>>> be better?
>>
>> Yes, I think this is a better approach.
>>
>> Later on, shrinkers that are converted to be memcg-aware can lift this
>> restriction themselves.
>>
>> Thanks,
>> Qi
> 
> Thanks Qi, I have sent a patch to push it down to filesystems in [1].
> No functional change inteneded in there. You would have to rebase your
> patch on top of that one and remove my code in shmem specifically.

Thanks! I will rebase my patch once your patch is merged into
linux-next.

> 
> [1] https://lore.kernel.org/all/20260714101454.1202449-1-usama.arif@linux.dev/
> 
>>
>>>
>>> Thanks,
>>> Usama
>>
>>


