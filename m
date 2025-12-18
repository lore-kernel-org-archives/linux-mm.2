Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E5B3D68BE1
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 06:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 458DC6B0089; Thu, 18 Dec 2025 01:32:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 406636B008A; Thu, 18 Dec 2025 01:32:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312B36B008C; Thu, 18 Dec 2025 01:32:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21DBB6B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:32:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADB81BDF30
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:32:10 +0000 (UTC)
X-FDA: 84231622020.27.8CE3D54
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id CD4BD10000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:32:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KFBee5nT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766039529; a=rsa-sha256;
	cv=none;
	b=Qw1OCMlXfl8HEboZPBNFS2RL+3sPfW22qgp/mKkJr7VJRRTIouTMQ9LFb1NxERfhr2ja5c
	Hkcnvk1ihYi9QVAyXEAFG2PJhfLwWQb3A6sssgyCPeK017CtKVwe7nAJ66mSoFKQ9W8TaM
	Z0LwbaFN4bLbf/xHLZ1uui6tyM99VMI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KFBee5nT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766039529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GuMAIMAxghdct3aJXfk8ti9XZUSoxcVspsnX7srcGqs=;
	b=LTM/HHUyMMgPITQCPq4zoXQutTbfQxcKIEFEXUn6ihLzsKbMJZeP7ix05QOOvX5iw0MkTs
	22WPqjiZKVdGD9dCH4QpEz2TCHuHhVQJYPS2E0WcNzb1D8EmqddMIAoMKBCM2f9FctPEyN
	LPOPI+H+yyXdyqKV82AoIp3idoBwFTE=
Message-ID: <f59a7a6d-2685-4c90-a02b-33dce49898cf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766039526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GuMAIMAxghdct3aJXfk8ti9XZUSoxcVspsnX7srcGqs=;
	b=KFBee5nTIhzoI9YEZNoVUIkAkpAX+95cyo5ZbyznMbVg80cFiduvqe3iOLSyfH1F7yrANX
	BC9xI2JhDTlys1R/SarHKY2E12ETA0eO9YYcKBcmlJ6QozfDzcVEvwLaxCSkXX31/2xxTL
	gfQN/eSKa8XVV4ZxKZwfH7DlY53ijd8=
Date: Thu, 18 Dec 2025 14:31:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 08/28] mm: memcontrol: prevent memory cgroup release in
 get_mem_cgroup_from_folio()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <29e5c116de15e55be082a544e3f24d8ddb6b3476.1765956025.git.zhengqi.arch@bytedance.com>
 <aUMkYlK1KhtD5ky6@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aUMkYlK1KhtD5ky6@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CD4BD10000E
X-Stat-Signature: 5ptycgepewescqck6r3roqc438yskdj3
X-Rspam-User: 
X-HE-Tag: 1766039528-928004
X-HE-Meta: U2FsdGVkX18NXyG3BzcnbkOyMUkWuUyCREnd2HFpuOReKWNqg0srFdBphS3/ui5oTy9ELlaaiEXkkMEaFi8lN1Mk8/gTvQiJS/j852BqDqY6KACkCWcfyAAyNcEiwuwg93aY8ZITlacaeLAuaVVlZsZKgTLm7RanbDtrXJazm/2saiI8PxauEzva0cWT1XkBmiV6QiX5RKSsHKIrbG46DUnGAP9Yz24+tPDLup3AWxXuWBSCvIca2Auq5jan4aX0fcke24zpxvkFBU1s3eqssdoameBCCFgQm/EitPO5k3mUBqg8NZkvVnVuheMjMNAt8HJQy/9LnWba3h73iWVZ8MLlvI5q/Hc5XfaSEaxd3LCTeL7E48GeRRhdm2ns0kC5nxdUlcaZMX7TXDX92GdEYdvew8lhbxI//qRbPRHsCkx3dott/DOszOe6n2bSB/vZlBEan6+K2Mo0ZBXIIg3RAyVqGqXikF9a79u6msMO86x8dmZ6UO4kiUyj36jSwhpuOFPeBnJe66cZsq8HtBtYJfoT71Fz61xHfrZrTRV4GP+pbGPZAMqCg9ALlmqAu80Aly8i4HGb6PbqVDTrKB2fKec74wyugbWsRpP7DCDMtwOklS2J+/FDYM/CfsPbuhXs/OCc/uAly/WwtY+Oj9RsuqXw/ay/2TjKPu3Wh1mywpzZXCYqfe9IjwxCV0clgqsoCFAIPgQetXchERKt6T1tTPtNRsLsAy5CSKDyyAteCSsutRJU7pW9nxlr3hjEh1jB5xGBwp1sM1imc2d7CKEibc+rEWYKIUz2rNEZ0dzeXcwZ6vY0RqGr1qIqNl9cSycvb2Kj32yTZrVkDml9FhU/Vu18x49syWvUHBdyqCdj9tQbNbVXnnT/IVdr3o3fVz1TOirF/qFWns04bWYwm2IJIi8uT9kXXTHv7anzLOS/XBmuwXE7kVLc3TyR70U0IyHlKZsCSNi+kesEIInXwy4
 +kMfYTIy
 fiSNZP3uPT159ukHrccryfCQXOXHI7RbFZcwOrTYapOavrnyv5+i97EePbqTdKOBscxlxjH6Fmz4OqBoNJ7NhtRtM0CeTf6iqXP/vktRKkyuLnriTL0PRU/bW/U0MoGjzJvSRpEBqH0ivgQvsHDOImxiWsLiTkZU9r55W4o3ikLrEQ4cLMp5Qkclkbc7iCKhU1QbZQjxmzyNq4lrzAHTz6mFHNuBZoO16s0zxqTpJBy4R432vjMEWMzU8I3h2yrfbwM2/NCo9MtJI7Hy3ihYSKxxwPaR+0FjJgGHKmWbtDvhiE5w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/18/25 5:45 AM, Johannes Weiner wrote:
> On Wed, Dec 17, 2025 at 03:27:32PM +0800, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> In the near future, a folio will no longer pin its corresponding
>> memory cgroup. To ensure safety, it will only be appropriate to
>> hold the rcu read lock or acquire a reference to the memory cgroup
>> returned by folio_memcg(), thereby preventing it from being released.
>>
>> In the current patch, the rcu read lock is employed to safeguard
>> against the release of the memory cgroup in get_mem_cgroup_from_folio().
>>
>> This serves as a preparatory measure for the reparenting of the
>> LRU pages.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>> ---
>>   mm/memcontrol.c | 11 ++++++++---
>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 21b5aad34cae7..431b3154c70c5 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -973,14 +973,19 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
>>    */
>>   struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
>>   {
>> -	struct mem_cgroup *memcg = folio_memcg(folio);
>> +	struct mem_cgroup *memcg;
>>   
>>   	if (mem_cgroup_disabled())
>>   		return NULL;
>>   
>> +	if (!folio_memcg_charged(folio))
>> +		return root_mem_cgroup;
>> +
>>   	rcu_read_lock();
>> -	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
>> -		memcg = root_mem_cgroup;
>> +retry:
>> +	memcg = folio_memcg(folio);
>> +	if (unlikely(!css_tryget(&memcg->css)))
>> +		goto retry;
> 
> So starting in patch 27, the tryget can fail if the memcg is offlined,
> and the folio's objcg is reparented concurrently. We'll retry until we
> find a memcg that isn't dead yet. There's always root_mem_cgroup.
> 
> It makes sense, but a loop like this begs the question of how it is
> bounded. I pieced it together looking ahead. Since this is a small
> diff, it would be nicer to fold it into 27. I didn't see anything in
> between depending on it, but correct me if I'm wrong.

Right, will fold it into #27 in the next version.

> 
> Minor style preference:
> 
> 	/* Comment explaining the above */
> 	do {
> 		memcg = folio_memcg(folio);
> 	} while (!css_tryget(&memcg->css));

OK, will do.

Thanks,
Qi



