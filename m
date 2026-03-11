Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E16E1FD88D6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 02:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F17E6B0089; Tue, 10 Mar 2026 22:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17EF96B008A; Tue, 10 Mar 2026 22:22:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06E676B008C; Tue, 10 Mar 2026 22:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA9986B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:22:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69F91B94FB
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:22:00 +0000 (UTC)
X-FDA: 84532182000.12.D4882FE
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 18C7D180007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:21:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b="WBR/0fa2";
	spf=pass (imf24.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773195718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PjeSX1GpoKSTte/pCYon1SpF7+5pTSCLuhxo/UX6odU=;
	b=eq8Lre512zCM0j0EkIZxpzbLenRpIEnSxOkqRH2aFQJh3dcAiHdFu5+Af0KbXkQebFa/9l
	ifDGq6WSEBk0FbeNr/wX1FLulpFlBkg4CBiVZ5XWJ/0qMd+cnaYCBI8pQSVCKUPMVPnNY0
	gTV+lrjmjkUOx7wAxuHz4rczXJ2m4II=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773195718; a=rsa-sha256;
	cv=none;
	b=e2plRaByfWlrtCscBvHlHGNvDqZ3umDEu37uxqGbRjhw7H1MdVCKVBkZzQaGJXsG9me6UX
	szXE413R2bOLiWDmNERDL4k1/tiRf29DK7PUK7d0+r5BQ6TnFuXeMZkz0wiPeT5p3MKJLm
	TgdGBSmH5dvdZx+VMnWs3jFGK8GW/rQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b="WBR/0fa2";
	spf=pass (imf24.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a7a9b8ed69so148631935ad.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1773195717; x=1773800517; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PjeSX1GpoKSTte/pCYon1SpF7+5pTSCLuhxo/UX6odU=;
        b=WBR/0fa2pHuF2eFuqvC2Op8xSwBC65QHKQoZZ7vbvQ5rLodA/LOejjtiGetKU7vCvT
         F+CNhQFtPUNBtN6ytQrjqzxgmoiEPyih4K7hXXtoetk34F615sYWOggDOryiA6+2M/oF
         +FTKCy2JFqOhIUKFIm7NdClnsKNMvVXvcqYPB7zFNVYj5naLan9FUB6M38Qbe1DOfVBI
         MK9U2VVQckB5J/koLfbs7JC2Ypsu6n74/lOWb0v0hnpS2xYwgPSvV9QnVcFQihZ5chVJ
         CaFi4Jtfd8gEo3jeH5LDtwum2dORdeGGdBImQa3CxvDi6+Zq+SI+AEQjm4Xe4jI/EmCe
         0FDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773195717; x=1773800517;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PjeSX1GpoKSTte/pCYon1SpF7+5pTSCLuhxo/UX6odU=;
        b=nmDPhUGj5ZZDrf9wPpIuYFdcG2Nvl7YXbJhEJG5w+l/dNMLiM8BI8kiOA3MoL7O1lT
         ADw6dEf0vPt+oRyCmPtMbk6Q7mrk6xWp1xukwV9TyvXNQgDeaAsLggHfVeZHyxz/iFoi
         4KI93ebff660I/dw06gg1Rp7tRfTPDxZJMsMaYmZVBccqJrzmZY9Ix111ttzQLG+zj0f
         AlTkrkCH3t4oc4q3MSbzncV9hx936uzx5wIcCEVrHCc2ksFnS/3uKEN/FaxLDtNdiyiJ
         1CaiJL2Wqe8EVl8mGQombNN22kRNKZGgqDKc1XVl/s5XWTCL7w3DYPWeDLFNa2p6kx6N
         JIbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLCFIj6mtuRfi0AotodKpXrLV/GGZSJGhY39TKPgTHD+ff5lYnJEQsN3iKCcEfJ/miKBkr2wbNZQ==@kvack.org
X-Gm-Message-State: AOJu0YxbVV6AjYG2zL3MVj/oxVUiu2jZKbcG/gUZAvZQll665Ha6n14M
	3Ua6uFPztSTFa2g4YwAXZ52XdBkW6J4MReMTP808g9b6S4WMLNvhU2HmQunX0a7lbhc=
X-Gm-Gg: ATEYQzz7/3iyGzwrIFxlk/JPdgMRc4ZEp7X4vTjT7lZAGzJgWJpkfyD2DaiODeyZN0M
	7uB65WJhXn2gDsl1+9vutTkMrdEUqcwJw9nFGysmdPeoz6n/cn7ojOL7D9TTpJ8BJ87M/gbggi4
	hb7VPRW3Cu1K6FDCNWFJgQxfyHJsBogeBNHsnxKYfLbNmoOw99ZKto+wdVtDGiIDUWFZg5vzW2A
	6WKsEfwPMOpl8/Jylpss6iHCSJK4VVUbX6JojVfOHxL5+1RuiRVocX4wvunCvD2X+y5bQx8gxNy
	pWNzJTjfYDvwF0IOxsl82eI3+EZ6EQQ/lmk8iQ0m/pUsXyQ1a9k/A1ta3gSyGHioYKOCwrYy7/J
	0Jh4gh7Lyw/I5cXeglE9zGN2xKfNnbZtvpprbET4wm2M6lA3EAqKgp/0nqGZSKrF+lGiWOJMMmf
	TX3jjjoQgOJhEvLam3/u7waCF1S0vb8fGwTyy4zh/pLwr+P+HQxfCybc59rFo4zJZSPJVv3+Npc
	lIZlsU6kOM=
X-Received: by 2002:a17:902:f651:b0:2aa:e6fa:2f6c with SMTP id d9443c01a7336-2aeae7d8961mr9253585ad.24.1773195716865;
        Tue, 10 Mar 2026 19:21:56 -0700 (PDT)
Received: from [10.54.26.107] (static-ip-148-99-134-202.rev.dyxnet.com. [202.134.99.148])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae22217dsm6012985ad.4.2026.03.10.19.21.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 19:21:55 -0700 (PDT)
Message-ID: <18f4092c-35c9-4ac4-a2f5-1039c7d54ec5@shopee.com>
Date: Wed, 11 Mar 2026 10:21:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 3/4] mm: shrinker: optimize the allocation of
 shrinker_info when setting cgroup_memory_nokmem
To: Usama Arif <usama.arif@linux.dev>
Cc: akpm@linux-foundation.org, david@fromorbit.com, roman.gushchin@linux.dev,
 zhengqi.arch@bytedance.com, muchun.song@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260310110536.3474739-1-usama.arif@linux.dev>
From: Haifeng Xu <haifeng.xu@shopee.com>
In-Reply-To: <20260310110536.3474739-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 18C7D180007
X-Stat-Signature: nk6krqn34pw4ncpe1gwjwp8yw6uqf4gt
X-HE-Tag: 1773195717-86328
X-HE-Meta: U2FsdGVkX1+Dw8Ljjb0MPNQn137ViSTkLMRPl185fh16boeKdNNdmppjVubFdTZyo5xNCRCY9F5RgCcsuG9Iierl39dcuE1HSMnZk5HEtLkqrFHw3LhhV1fRLoYvg/FvjB5BNDl/p3ha+Jl8k5rjFmUFmr7iVUd16y4AFg9BOZhwj6Rqmepw0vZ9u6X//t8CBtn+tARqV+Tmks774dpsDyb89LPu+525ERjajoJsMx7iZXZPrEMOYYSmV0v/yF7jEBQ3HlXi4jpiPBaABw2Pn7NXxtVoDB26VZCjVpksT2u3CiVWRhlSs5yQtAUS0r14YtshlrhAQYB807b3GUQgxQp8BpjnkwiDLUTzhUfad8DPpRIGABpXkDH96FVbYpiPUo4Rg47V8u8CdNhGYnDaEPxQ3yhqVt1lvqkaV9R2w04kbHhMFZZg9Z5yKcb1y/yK6FUyEWsIDHIEuZ3Ffv3IPyi9gmTCsahh1QFCVVfz66df/jBgN1NkKFSS/2AoaxKk2lrWaokqVUDAKbK5oUhktY/0Lv9LUpgsjSUUfvBObxgto+UyaBwkDzkUj/qX3seTalqsX2NBS3IvSz3bMN9RoioY3ajeCMQ0H3OIMg+sWi3FzVSqJXx3g1Z4ChDuZMSZjd/d59i5emY8lyClHs3q1XiFU1ee02JFtbLIT0aDxlMsgSa0JEWI+5oQnDp7OMlBLLVAbNBuwbu2d5hDdq0dBH4FF9jhgaJALgrNKLxx7F5mHZU748G4ahKKPVqypMZpEnGbOxOWJHTppKNLGz/Q8oQz5r7zonWH4slcauY1swuV+/jlLVAXH1C0ueOrIWuFgq2aT6bseDCDFcX1Rkl3KBgSjVtmWcfp8jY6+n24eM1g6U4hW+AwFD4J0jZkpdx+njDtzMBdS/oAds6pw11A1m5QEgYTzMIe6xZJGRWlIo+41yYsFkV1hK2TsGJAbwrRLF9rkK7F7wvN+beq9i6
 ZdEjFhif
 dTa6Z6eFZY+VwAFveftAcuuad7yjE5w1ElX+a5ji2zb5DE4hgfvRyIe9RnbqfPG+wel0ylTWlH3VaJR6oiZIDMkgz2sqge/SP8R41j0uOxR9RFqfLBfimWsrRZRlbj/axQUx3cZBNWgRfkyLiR7iFT9Xqoc4grZIPI7rdctpAqqdUhcxZtlTBQHUcwhFI3DrFUKpjAbTm4Barn29ie8Lu8GIHZtCRt3Fh2bDMVyN6lkKfcmAXFZ0QYPWTHpvuxoyLfYZMPtCDR7QQjltrF2/7A3dV6X66GCC2B6dc5baQYekSnQZnQDB16LGRfiJNbHlMRcZI7N100z+02jmZ1q1SkC2lBaSOjlOTjRWbsrhH6Wyt7tlmlkQ9IoU3upGcjNMTP1fLbJZBIz9pqAJno0Mq2//hWPo+hSdl6yxW2qzRAqJYgpncHUq909aX0KtoR7L9b33eshwIPvMbbS6m1MCf7TB5XSK8pIlmPwiVM3D6uqgmzoo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/10 19:05, Usama Arif wrote:
> On Tue, 10 Mar 2026 11:12:49 +0800 Haifeng Xu <haifeng.xu@shopee.com> wrote:
> 
>> When kmem is disabled, memcg slab shrink only call non-slab shrinkers,
>> so just allocates shrinker info for non-slab shrinkers to non-root memcgs.
>>
>> Therefore, if memcg_kmem_online is true, all things keep same as before.
>> Otherwise, root memcg allocates id from shrinker_idr to identify each
>> shrinker and non-root memcgs use nonslab_id to identify non-slab shrinkers.
>> The size of shrinkers_info in non-root memcgs can be very low because the
>> number of shrinkers marked as SHRINKER_NONSLAB | SHRINKER_MEMCG_AWARE is
>> few. Also, the time spending in expand_shrinker_info() can reduce a lot.
>>
>> When setting shrinker bit or updating nr_deferred, use nonslab_id for
>> non-root memcgs if the shrinker is marked as SHRINKER_NONSLAB.
>>
>> Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
>> ---
>>  include/linux/memcontrol.h |   8 ++-
>>  include/linux/shrinker.h   |   3 +
>>  mm/shrinker.c              | 116 +++++++++++++++++++++++++++++++++----
>>  3 files changed, 114 insertions(+), 13 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index ce7b5101bc02..3edd6211aed2 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -1804,7 +1804,13 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg);
>>  
>>  static inline int shrinker_id(struct mem_cgroup *memcg, struct shrinker *shrinker)
>>  {
>> -	return shrinker->id;
>> +	int id = shrinker->id;
>> +
>> +	if (!memcg_kmem_online() && (shrinker->flags & SHRINKER_NONSLAB) &&
>> +	    memcg != root_mem_cgroup)
>> +		id = shrinker->nonslab_id;
>> +
>> +	return id;
>>  }
>>  #else
>>  #define mem_cgroup_sockets_enabled 0
>> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
>> index 1a00be90d93a..df53008ed8b5 100644
>> --- a/include/linux/shrinker.h
>> +++ b/include/linux/shrinker.h
>> @@ -107,6 +107,9 @@ struct shrinker {
>>  #ifdef CONFIG_MEMCG
>>  	/* ID in shrinker_idr */
>>  	int id;
>> +
>> +	/* ID in shrinker_nonslab_idr */
>> +	int nonslab_id;
>>  #endif
>>  #ifdef CONFIG_SHRINKER_DEBUG
>>  	int debugfs_id;
>> diff --git a/mm/shrinker.c b/mm/shrinker.c
>> index 61dbb6afae52..68ea2d49495c 100644
>> --- a/mm/shrinker.c
>> +++ b/mm/shrinker.c
>> @@ -12,6 +12,7 @@ DEFINE_MUTEX(shrinker_mutex);
>>  
>>  #ifdef CONFIG_MEMCG
>>  static int shrinker_nr_max;
>> +static int shrinker_nonslab_nr_max;
>>  
>>  static inline int shrinker_unit_size(int nr_items)
>>  {
>> @@ -78,15 +79,25 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
>>  {
>>  	int nid, ret = 0;
>>  	int array_size = 0;
>> +	int alloc_nr_max;
>> +
>> +	if (memcg_kmem_online()) {
>> +		alloc_nr_max = shrinker_nr_max;
>> +	} else {
>> +		if (memcg == root_mem_cgroup)
>> +			alloc_nr_max = shrinker_nr_max;
>> +		else
>> +			alloc_nr_max = shrinker_nonslab_nr_max;
>> +	}
>>  
>>  	mutex_lock(&shrinker_mutex);
> 
> Hello!
> 
> The patch reads shrinker_nonslab_nr_max and shrinker_nr_max before
> acquiring shrinker_mutex. The original code read shrinker_nr_max
> UNDER the lock. Both variables are modified under shrinker_mutex by
> concurrent shrinker registrations. A stale read could cause
> alloc_shrinker_info() to allocate an undersized shrinker_info,
> leading to out-of-bounds access in set_shrinker_bit() or the
> nr_deferred functions.
> 

Yes，thanks for pointing out the problems.

