Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C5DEF55451
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 06:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 451E66B0089; Thu, 26 Feb 2026 01:47:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 428366B008A; Thu, 26 Feb 2026 01:47:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37F1C6B0092; Thu, 26 Feb 2026 01:47:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2541D6B0089
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:47:33 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B540D1CE35
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:47:32 +0000 (UTC)
X-FDA: 84485676744.16.363FAE3
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8095940007
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:47:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S12TlyhM;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772088449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fvIzD9WJtipjYeMRrpj/AGOaEvkByWxGuVy0TYOYU04=;
	b=BRbk6FobvDNE3EctusVcjsNbA3pnBGF7dJZWz+5d9uqcO3El3ztQNnOUQnH9B7WWTB3sD1
	rKyAPiQ37ivlqja7jQfAOXBYI4cjO4P3lMWuWxvgskiPaQu3Ng+raQalqp4sCTOOoeMNd7
	mUcLX5f2dZUGUEpM29eA1MhkG3G+PjY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S12TlyhM;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772088449; a=rsa-sha256;
	cv=none;
	b=EDkaInBuw8PjHGk6po1F691PNizLrwhS/uIEe2Ee6TpwATbfRyGRnz48c4gUR6aMWslLqu
	Rssa46s+PXFSAQQmXmlpebBJaGaPHUCcwOKE7TImTVWjYc57rJVAp4Jq2Jeysb/rhi/u8w
	+iv7gDCz74kxDnkztXTY9GxtGuAdzH0=
Message-ID: <6effce05-9a13-4991-8183-5e8187914c54@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772088447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fvIzD9WJtipjYeMRrpj/AGOaEvkByWxGuVy0TYOYU04=;
	b=S12TlyhMe1GbrxdO2P/PjyBRAFPl/RgOxwCuDYl2PXTlPFQ/8xaB2vjNd1UtgtDQB8H91e
	vSMGImE53Ms+r26I3v3k92+U7qfWwQo1UVhnCtIg3v3Mhqs7tyRqBPqe2SyE3nxYBHfthb
	mmA0HTmtZ4vyRIpigAqXpt8/fCaLK7w=
Date: Thu, 26 Feb 2026 14:47:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 update 30/32] mm: memcontrol: convert objcg to be
 per-memcg per-node type
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <0f915487ffc653cf6ea19335c21c01aa06004641.1772005110.git.zhengqi.arch@bytedance.com>
 <20260225094456.74145-1-qi.zheng@linux.dev> <aZ-uNV1biPYLhJ48@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aZ-uNV1biPYLhJ48@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: tkjngmtn13z4erufqwwcfjsjgtgzpfc3
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 8095940007
X-HE-Tag: 1772088449-725249
X-HE-Meta: U2FsdGVkX19SK11claJPmA+E0jNvpl3tq03OMv1IIS/ezZ0fItzvYaalQiRvS8H86N+X6AmhqJDxUvh+0gXiq94gBZQdGGQm4n+sYLVdoUgBRKm5IuaBLwWeelw1RXDclxRDKNH+1N3pg6wjziW/1QvIzarfBZUDH6SwFUys5SvBNveeheUz2ExVRbhV52ruf3WNBAtYrN0Z69GuodAbTpYT/bq/VohgSFm12vFIEQv3mzXaUPDzBQkSyR1dse57Hh3nxgNnSzOJmbmp5UvwENDFIxvVPuzephTgkgGKVa/jMhILBRHtD9hQNyn4yVW3ggMKjLgmENqg1dBNsg33gdM+gfHqMU08WlfmBCMz+2mrTKV96TRFSgk2KXB3V8LZzgMa4Uui9rEfX30o34seZdsI3TIIRq90iTr2fzEyfrCIe7Eyj1DywuAsE/yRvUMp4m1h6xdB/mXKuIstrj1IInN6d6GubdvfqcvypEnk1XODy+gUXkKehI/so7opPtobmHi0T8Ixg8CCakNR4EbsCwi4dH2Ihr8iuPKs5aqzhdHFRsSdREzcDmqyCG/QPMTXOvVDv8VdfmXgnV93Zo/5sb7vSlgiISi4jALvuZeEXcL1Ltx3BJvteBr0xdQxjPaJxQHGRoffVXXgP6UsDapZGFhBvm1K+t2vW7UCW0RQ2B7ayNCfeSJwnxzQ5vU+FSSuihbdPbxu/Vx8FsbZ6o0vLbPcJ+uhUlFwxiZxxZNZ2eMNc0Ik4Pxuawj/yu63rLltqgXmM4TC8ywjohxAFLNcyLPseTop917eGb0J9DN8VCh1OSVxL6Wv0u0s63kXOgDfHXdPPhUSPv4quCsoGPy7kbM4HPU6QeTDN3CGoOfK08tJSY/7cBU2o9ANowwHZgsSIEowlDPuNexzwY+nizt+WLv54tRJZl29QVeIu5/5bq9vx0f/Rle2iDzWcIms/BWvB1cGu9lBiNRmaPWMMy2
 nR51lkcq
 T8FHHnzFrKfvYR5jYuCPqRnXi1lEi4CeTMTRsv5Us7NwhPI7UCb02CQH5tDEodFcWhZ6q1idBxz/DX6T25bSuB7N6bGonZnAL8DRy3CBafNXHd2Rj0cQ3dSwGenkY0at5SL7yeljRHeIpdPdy8ZJAkJ0kIv86RpNVObhenJXlsppykiw6b31VkAbvgsekyu2Wwmj6dfiDnjpM4kRNelQIAVOQ5vI98OWVYufwCnJcKhJqd3rWQWqmVLRGt6wdlMS5cjQVFU3cS1bb7yNDKeKe5Z3DAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/26/26 10:27 AM, Shakeel Butt wrote:
> On Wed, Feb 25, 2026 at 05:44:56PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Convert objcg to be per-memcg per-node type, so that when reparent LRU
>> folios later, we can hold the lru lock at the node level, thus avoiding
>> holding too many lru locks at once.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>> changlog:
>>   - fix a missing root_obj_cgroup conversion and completely delete
>>     root_obj_cgroup.
>>
>>   include/linux/memcontrol.h | 23 +++++------
>>   include/linux/sched.h      |  2 +-
>>   mm/memcontrol.c            | 79 +++++++++++++++++++++++---------------
>>   3 files changed, 62 insertions(+), 42 deletions(-)
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 45d911dd903e7..6e11552a90618 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -116,6 +116,16 @@ struct mem_cgroup_per_node {
>>   	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
>>   	struct mem_cgroup_reclaim_iter	iter;
>>   
>> +	/*
>> +	 * objcg is wiped out as a part of the objcg repaprenting process.
>> +	 * orig_objcg preserves a pointer (and a reference) to the original
>> +	 * objcg until the end of live of memcg.
>> +	 */
>> +	struct obj_cgroup __rcu	*objcg;
>> +	struct obj_cgroup	*orig_objcg;
> 
> The layout of struct mem_cgroup_per_node is very performance sensitive. Please
> couple of performance benchmarks after rearranging the fields particularly the
> above two pointers together at the start of the struct.

Got it, will try to do it. Additionally, it would be even better if
there were existing test cases available. ;)

> 
> Otherwise:
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks!



