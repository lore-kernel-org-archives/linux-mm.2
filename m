Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FCEF1098783
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C4356B0088; Fri, 20 Mar 2026 09:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B8F6B0092; Fri, 20 Mar 2026 09:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B3786B0088; Fri, 20 Mar 2026 09:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6AB0B6B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:19:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13614139AC0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:19:17 +0000 (UTC)
X-FDA: 84566497554.02.4E25CE4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id DD7BD1C000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:19:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cMJEPqUI;
	spf=pass (imf20.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774012755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=43pI9Rxx7g/U6KWY+aHGDiY4UP4hzBP1C6y0vyJ/NMo=;
	b=YBsUEF9eMVH9QMdENv57gyjgsJDtTvlGZLi7J8A7spsdYLtjkLDNJlKvN0tS3Ba83LZ0Rl
	NJsqT4x31aUDI5p3s0+Se/fOyED/fVyxfJLoH54sdOlnUjTxLT0zIp/Gc1EPdJt1mW1lCp
	zRWcP+2NEF6mjNbW7oe1APKeKeR1M0E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cMJEPqUI;
	spf=pass (imf20.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774012755; a=rsa-sha256;
	cv=none;
	b=pH/+n5XqwCoOkX2XuQo4r4SGjL/39Dm/8ZMsdhTsFW2JDx/4JBOL2o3hcSRFDcSs3j5FgM
	8smVNMPeOaPqY2xiqTsRYeJPBylWUzlRRCn3YeIy+YY8ozNmOCDo5G8DJ+6JIVgf9v7Hrx
	HvOEHzV0NtPWjuOJFOWnTbkCmT8Kj5o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774012754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=43pI9Rxx7g/U6KWY+aHGDiY4UP4hzBP1C6y0vyJ/NMo=;
	b=cMJEPqUIYURmb3ow6OLba9nduPNVdsxFXSNdVdewvxfvE9AUB/ev1r/6d3cnH5vh+HODCM
	0/JhUiuyFt9Q/scGdxNioG6pkwuY6Bw1UEfxTwwfns3xYE7flkE8fqK+cbLPYnbueaCgvy
	sjXrUeABQr3jDnZz6bIoHrXa3s7mvyg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-461-CeVCNg7WP_inUj0MZw47nw-1; Fri,
 20 Mar 2026 09:19:10 -0400
X-MC-Unique: CeVCNg7WP_inUj0MZw47nw-1
X-Mimecast-MFC-AGG-ID: CeVCNg7WP_inUj0MZw47nw_1774012748
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CBBF51944F01;
	Fri, 20 Mar 2026 13:19:07 +0000 (UTC)
Received: from [10.22.65.139] (unknown [10.22.65.139])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B29951955F25;
	Fri, 20 Mar 2026 13:19:03 +0000 (UTC)
Message-ID: <bf33746b-46ae-47ec-a735-d2a29226bf9c@redhat.com>
Date: Fri, 20 Mar 2026 09:19:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] memcg: Scale up vmstats flush threshold with
 log2(nums_possible_cpus)
To: Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 James Houghton <jthoughton@google.com>,
 Sebastian Chlad <sebastianchlad@gmail.com>,
 Guopeng Zhang <zhangguopeng@kylinos.cn>, Li Wang <liwan@redhat.com>
References: <20260319173752.1472864-1-longman@redhat.com>
 <20260319173752.1472864-2-longman@redhat.com> <ab0kAE7mJkEL9kWb@redhat.com>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <ab0kAE7mJkEL9kWb@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: lmjdvxApl6C7fk-OVKM42Uo1ddOkTEeiQLNVSCzafQY_1774012748
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DD7BD1C000B
X-Stat-Signature: wrxu7t7ru63dn8pmhafu4fujnkgfrd5f
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774012754-751514
X-HE-Meta: U2FsdGVkX1/A7WPKIU/Y5GCMYtXGc2S65RGWUDwpWN1HoLftP2tFMF4QVKo29ld+3j7ePVQF2/S+TaoAnUhaw5rlu+cu2Dug/NhXnyNcXeIK4DO0gFOlwzO3OZVqHH2MNnP3ioxgz37NulsFsRBJ63pxxLpKJ+KMrkTwhkQigFs1Co9dA36g77xOFoAAA08S4y0KgyszRY5Cgp/btukn5EaB3SkuktLUP/qF1fyd10LJYf3vNsrS4y/xItqiMrKia2RoSHoRPw6TAa9gSyluU8RuIPN0NbVYLravlksSwelkWB0Mr3nXm9AERATSAIhSDSBsSb+g931TGUi498asq++VpV7Up5n0tXpO0srYU7PFEKJTiJUZwp8gQy+y9tUs2oDL+XDU5HAz9tEHAaWuGopTPzOSwW+sMreQSKMzk/85s0DSBL3gVtvi9Jdiku1h2pKq4l1dxv7SPzSiXzRv1Wr622rHe8zw/LndTNFazlf2ja6dT/zr8AZby5korLjRFoVuRvs+Zkg4EX+wuxw1sydKPNXh0wYoPRWNRBGqt1ImTw9y7iOeyHl8fVLU8DV/ql8icv/d9WmFEu8DpknZ1SpMsC+3FbWopodduZ05ZXkBlGivukAlHCDaEakwlmVE6+mIMvRJxw5ktqweX0nk9p3XW/wpTsUr5jmTKDdUglP/DTx3n6gdQD9XnuvZQxgeRxnPgsOXNa7M7eLgkevKau8IMetmBSq0BOCOusUXt/Dt4NIT+ocRMGZAlpXpdpYoBxm2hH21vVX16o8w1q17Cv2V6aA96HKaBf70vo/gEh+/9bCK9YxgUH2Z8HC0vxRljopqkJkmcV1KWWfeg6Goeosldys1XRzfHKeFwGk2WiMtXSPJcvXHn4CjWEZ/OWk3PKqSp0uw9XMCUPmqxnjgaNlzDolINAJXJVsuvTn3CHw3GzjAqVxL8yssu0JJ8+z7L4/FEckdFLlRKI9aAQE
 16jDC0PJ
 AOnDCrwuqjNCSXZc57bJTfEJYQfkcInBZfczHH6VmJtW9NhD3o6DhA690Ki2x/0zatKdZhjbmlQojDvcLjADIYtkXqzqzbKZaEL1NzgJRs4SgN+HKU370g5DdtU9/QDq2xN7NqvXo9Y6HVYk58N1h39OzxNkrwayh2kp0AVaEBlsUR8KiJ+DtNTAd+gE5oM+hfVCDCmSkM73M/m2mEApnPCX2zLn1K/Pq9Qz7KR4Gj2jO8uYROvoHi+BdvsDPXtSywOH3G7oGRWD/rz6aDA0zWxKe8Il0ksNVLklS3RDc55bA/FnD8VsskqWz90zH12XTDzAMy5dyIlNXDeeRY055/76IjaaR0xXzMd7JOMNbgxdELJXa1Fb4rANERhwIkihTxmQ7HIwGfZeMRyA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/20/26 6:40 AM, Li Wang wrote:
> On Thu, Mar 19, 2026 at 01:37:46PM -0400, Waiman Long wrote:
>> The vmstats flush threshold currently increases linearly with the
>> number of online CPUs. As the number of CPUs increases over time, it
>> will become increasingly difficult to meet the threshold and update the
>> vmstats data in a timely manner. These days, systems with hundreds of
>> CPUs or even thousands of them are becoming more common.
>>
>> For example, the test_memcg_sock test of test_memcontrol always fails
>> when running on an arm64 system with 128 CPUs. It is because the
>> threshold is now 64*128 = 8192. With 4k page size, it needs changes in
>> 32 MB of memory. It will be even worse with larger page size like 64k.
>>
>> To make the output of memory.stat more correct, it is better to
>> scale up the threshold logarithmically instead of linearly with the
>> number of CPUs. With the log2 scale, we can use the possibly larger
>> num_possible_cpus() instead of num_online_cpus() which may change at
>> run time.
>>
>> Although there is supposed to be a periodic and asynchronous flush of
>> vmstats every 2 seconds, the actual time lag between succesive runs
>> can actually vary quite a bit. In fact, I have seen time lags of up
>> to 10s of seconds in some cases. So we couldn't too rely on the hope
>> that there will be an asynchronous vmstats flush every 2 seconds. This
>> may be something we need to look into.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   mm/memcontrol.c | 17 ++++++++++++-----
>>   1 file changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 772bac21d155..8d4ede72f05c 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -548,20 +548,20 @@ struct memcg_vmstats {
>>    *    rstat update tree grow unbounded.
>>    *
>>    * 2) Flush the stats synchronously on reader side only when there are more than
>> - *    (MEMCG_CHARGE_BATCH * nr_cpus) update events. Though this optimization
>> - *    will let stats be out of sync by atmost (MEMCG_CHARGE_BATCH * nr_cpus) but
>> - *    only for 2 seconds due to (1).
>> + *    (MEMCG_CHARGE_BATCH * (ilog2(nr_cpus) + 1)) update events. Though this
>> + *    optimization will let stats be out of sync by up to that amount but only
>> + *    for 2 seconds due to (1).
>>    */
>>   static void flush_memcg_stats_dwork(struct work_struct *w);
>>   static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
>>   static u64 flush_last_time;
>> +static int vmstats_flush_threshold __ro_after_init;
>>   
>>   #define FLUSH_TIME (2UL*HZ)
>>   
>>   static bool memcg_vmstats_needs_flush(struct memcg_vmstats *vmstats)
>>   {
>> -	return atomic_read(&vmstats->stats_updates) >
>> -		MEMCG_CHARGE_BATCH * num_online_cpus();
>> +	return atomic_read(&vmstats->stats_updates) > vmstats_flush_threshold;
>>   }
>>   
>>   static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val,
>> @@ -5191,6 +5191,13 @@ int __init mem_cgroup_init(void)
>>   
>>   	memcg_pn_cachep = KMEM_CACHE(mem_cgroup_per_node,
>>   				     SLAB_PANIC | SLAB_HWCACHE_ALIGN);
>> +	/*
>> +	 * Logarithmically scale up vmstats flush threshold with the number
>> +	 * of CPUs.
>> +	 * N.B. ilog2(1) = 0.
>> +	 */
>> +	vmstats_flush_threshold = MEMCG_CHARGE_BATCH *
>> +				  (ilog2(num_possible_cpus()) + 1);
> Changing the threashold from linearly to logarithmically looks smarter,
> but my concern is that, on large systems (hundreds/thousands of CPUs),
> the threshold drops dramatically.
>
> For example, 1024 CPUs it goes from 65536 (256MB) to only 704 (2.7MB),
> that's almost 100x. Could this potentially raise a performance issue
> as frequently read 'memory.stat' on a heavily loaded system?
>
> Maybe go with MEMCG_CHARGE_BATCH * int_sqrt(num_possible_cpus()),
> which sits between linear and log2?

I have also been thinking about scaling faster than log2 but still below 
linear. I believe int_sqrt() is a good suggestion and I will adopt it in 
the next version.

Thanks,
Longman


