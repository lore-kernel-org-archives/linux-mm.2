Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 108FC109C041
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:42:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54DF36B0089; Wed, 25 Mar 2026 12:42:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 525286B008A; Wed, 25 Mar 2026 12:42:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 462586B008C; Wed, 25 Mar 2026 12:42:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 337346B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:42:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C87A58C876
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:42:31 +0000 (UTC)
X-FDA: 84585153702.02.9A12585
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8C1AAC0004
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:42:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M85FIDU6;
	spf=pass (imf10.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774456949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k8Ejv58wPUbDLQJ+Tj4MdIi2shlj9vonZOVFSYDuwn8=;
	b=pP7EOwaOLv9eJMNloCiYbYieeWaRhpqKA0QgrBAIpZkr88e+80cg5QcCwO3XAzjO1BzEEy
	tnYuc9uu6h6QpnB3WPyQTSbHkHZuO9yifOnz68GTP72h+z5pHhc47qDAd7h1W7Grpg1ZpD
	34YjzBIt3/FxN1h5vupZcL9mzqhwi8Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M85FIDU6;
	spf=pass (imf10.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774456949; a=rsa-sha256;
	cv=none;
	b=3Uw/eJELFGhr5xL8qmIIKR2zzNoSBays2FkogeTSsJ5cTWMJ4Nb3wKwlDqPmzZY6HeobGy
	0Z8cINP1Zl7Pf2A1n3OVKVexXMUVyWhK9JZmPOZPrhrc0C98EouJ9sMlIocdu7KbOcQSdq
	z3ZZiAX8wBOLC9WhsWvGpex61JDRiI4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774456948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k8Ejv58wPUbDLQJ+Tj4MdIi2shlj9vonZOVFSYDuwn8=;
	b=M85FIDU6/l+oRzy1M5UNH395SWIXjgtQsxc5IAwrUgwUPClsngi/MnmE4jPf7BSReKXjn0
	0DGbzXKCcz2+fqw+nZwKAhzF3OP6HAE7F0jh4VNoLw+DnqMrs4iBeeiZQTCwc4FpjEYfHp
	C21KrPY3pH8OkOh1l3Mz4wW6NlWg/Sc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-339-lcagNMoDMTGvBrvVXY_vqg-1; Wed,
 25 Mar 2026 12:42:23 -0400
X-MC-Unique: lcagNMoDMTGvBrvVXY_vqg-1
X-Mimecast-MFC-AGG-ID: lcagNMoDMTGvBrvVXY_vqg_1774456938
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 94F8618005B4;
	Wed, 25 Mar 2026 16:42:17 +0000 (UTC)
Received: from [10.22.90.27] (unknown [10.22.90.27])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9C8571800351;
	Wed, 25 Mar 2026 16:42:13 +0000 (UTC)
Message-ID: <82661a8e-256c-4cf4-96b2-98d52cf62cde@redhat.com>
Date: Wed, 25 Mar 2026 12:42:12 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/7] selftests: memcg: Increase error tolerance in
 accordance with page size
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
References: <20260320204241.1613861-1-longman@redhat.com>
 <20260320204241.1613861-5-longman@redhat.com> <acDzaouBPCIpB7Ij@redhat.com>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <acDzaouBPCIpB7Ij@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 9mR2jgNpIwA5nhKi6kxS7Jp8jt9W5fLz79DC7j_r-Ls_1774456938
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8C1AAC0004
X-Stat-Signature: wdqcxbnmb1kdj5eh7qyxwhafmbm7nbmm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774456949-614876
X-HE-Meta: U2FsdGVkX1+osT4sj8LQQWqSqyyogexhGOVvIdv+/6b7Lmn83u5qBPAvEmjWbxOsRUnhlhyPBpNHlDpcHNJjBc+lanp/i7oAiGNgQSgnpkkzEdbBZYt6DIvUQpUGSwfyr+csY/353yIrU1K8gLpFMZkPi1nlOqgU6ZZgyHokachYMiFPTUjR+r0l1iDui8lI2jry57nZCv2eycFuNJlOkawg+yS16FHmYSH2EP7v/yC8gCxsv1SYEjskwn4XCgUkRrR4TqVOKVccYOJsK99q0p2OkJVYeutnJEFEdCsCflLipEYSJnP5dRMMKX12wLr5t+/JxqQlEE2+JhzawIZ/KRHM+21romFg2sNgLQfsR2V6ku5YMijU/cHXVPBHzvlYAFT7BDJc/hZxfF0cmiGrFr+IvNJWugtd9gEg0+ItFZi0L2dZs4pmvi5Q7ZxSN/xfzBFtBxaxHhntADQqy27RpeVkYWvzzy/IN/TW/kxRMo5dKeAxDpXVANsQ8+rJxW1/0VWyKiVLxAJCZ50VulJLvl4TZql1zvzWkHBdlTfAn8LqSHWxuPmw4RiYACTgZ06G6razq0dUtcC92r4v2VSRyz3XJdxy7ddC7W+/AL7IP8GSCOkNQP6b9zl1XWU7xDAjTOjD4Y1ZMP4LWzHWeq7zsijX+9caM2SN6L6cZlHzYYP4Llh+KPfX6wGXyicgqBid49k2DgR+nv4a87I/UPupFVEi2AocTdm76c5nMFP6Hbsk+HUGVQ6Hrd85Cwb6ok5i+81hT8vHC6CMgXgh/ZHeDlmcQVZBUzPrOaOjkEid+m2kWn07M7SsEK3yKEpBgeo4zrxiHK/8+hb/wNXZ4lRYgaJuh0DCaIn7+OAiLRKMRZuR8MUxYJaV+7LafKF4z2+HU8fOXKMQC4dn+hhwIgWctLPRVbSyJt/JUzWDgXO4Id6EH7+fE/rl5VHfeN2/PXmCCUQvyIEU3UBVK3lnOho
 Yd12koQt
 NgkOZgZYX2XW7nw7zJzcC1fg8Ux9+DmEVNaLcAAuhEkRFQoidpmJ+zCqSTUOdZXn1c41OgqZ9oLsAv5DV+WDOXwgYS1wEUIGLcceN30GO0XN9bRznkCkHikXNEeMjJyI7PwHtHA0obu4OYq349wVo8NlHETXJp/8MW1A3y2uSBfPxaTMMw+bSlbPVyLcrDrVzRtc40EDRQjjRYAv7w8Zng/DHkbbeIHshZaLVILp63qmGya1guQfD/RrMNwarF9JBbcQkA6hJLidXcpEpB1uvsXvhja+I2weg/y25EGNFcAAjiK1YgkbF92wnFm8SBw2v2U8s0St4IVxYGg17dxEyXr++V0Snt6GIjlhhCIm8uYU56hxRARWsfgRwoZfkNu4f5nz+/LRFQp5n8m8VTikKtGMZ6bAyLVLTDa6m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/23/26 4:01 AM, Li Wang wrote:
> On Fri, Mar 20, 2026 at 04:42:38PM -0400, Waiman Long wrote:
>> It was found that some of the tests in test_memcontrol can fail more
>> readily if system page size is larger than 4k. It is because the
>> actual memory.current value deviates more from the expected value with
>> larger page size. This is likely due to the fact there may be up to
>> MEMCG_CHARGE_BATCH pages of charge hidden in each one of the percpu
>> memcg_stock.
>>
>> To avoid this failure, the error tolerance is now increased in accordance
>> to the current system page size value. The page size scale factor is
>> set to 2 for 64k page and 1 for 16k page.
>>
>> Changes are made in alloc_pagecache_max_30M(), test_memcg_protection()
>> and alloc_anon_50M_check_swap() to increase the error tolerance for
>> memory.current for larger page size. The current set of values are
>> chosen to ensure that the relevant test_memcontrol tests no longer
>> have any test failure in a 100 repeated run of test_memcontrol with a
>> 4k/16k/64k page size kernels on an arm64 system.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   .../cgroup/lib/include/cgroup_util.h          |  3 ++-
>>   .../selftests/cgroup/test_memcontrol.c        | 23 ++++++++++++++-----
>>   2 files changed, 19 insertions(+), 7 deletions(-)
>>
>> diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
>> index 77f386dab5e8..2293e770e9b4 100644
>> --- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
>> +++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
>> @@ -6,7 +6,8 @@
>>   #define PAGE_SIZE 4096
>>   #endif
>>   
>> -#define MB(x) (x << 20)
>> +#define KB(x) ((x) << 10)
>> +#define MB(x) ((x) << 20)
>>   
>>   #define USEC_PER_SEC	1000000L
>>   #define NSEC_PER_SEC	1000000000L
>> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
>> index babbfad10aaf..c078fc458def 100644
>> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
>> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
>> @@ -26,6 +26,7 @@
>>   static bool has_localevents;
>>   static bool has_recursiveprot;
>>   static int page_size;
>> +static int pscale_factor;	/* Page size scale factor */
>>   
>>   int get_temp_fd(void)
>>   {
>> @@ -571,16 +572,17 @@ static int test_memcg_protection(const char *root, bool min)
>>   	if (cg_run(parent[2], alloc_anon, (void *)MB(148)))
>>   		goto cleanup;
>>   
>> -	if (!values_close(cg_read_long(parent[1], "memory.current"), MB(50), 3))
>> +	if (!values_close(cg_read_long(parent[1], "memory.current"), MB(50),
>> +				       3 + (min ? 0 : 4) * pscale_factor))
>>   		goto cleanup;
>>   
>>   	for (i = 0; i < ARRAY_SIZE(children); i++)
>>   		c[i] = cg_read_long(children[i], "memory.current");
>>   
>> -	if (!values_close(c[0], MB(29), 15))
>> +	if (!values_close(c[0], MB(29), 15 + 3 * pscale_factor))
>>   		goto cleanup;
>>   
>> -	if (!values_close(c[1], MB(21), 20))
>> +	if (!values_close(c[1], MB(21), 20 + pscale_factor))
>>   		goto cleanup;
>>   
>>   	if (c[3] != 0)
>> @@ -596,7 +598,8 @@ static int test_memcg_protection(const char *root, bool min)
>>   	}
>>   
>>   	current = min ? MB(50) : MB(30);
>> -	if (!values_close(cg_read_long(parent[1], "memory.current"), current, 3))
>> +	if (!values_close(cg_read_long(parent[1], "memory.current"), current,
>> +				       9 + (min ? 0 : 6) * pscale_factor))
>>   		goto cleanup;
>>   
>>   	if (!reclaim_until(children[0], MB(10)))
>> @@ -684,7 +687,7 @@ static int alloc_pagecache_max_30M(const char *cgroup, void *arg)
>>   		goto cleanup;
>>   
>>   	current = cg_read_long(cgroup, "memory.current");
>> -	if (!values_close(current, MB(30), 5))
>> +	if (!values_close(current, MB(30), 5 + (pscale_factor ? 2 : 0)))
>>   		goto cleanup;
>>   
>>   	ret = 0;
>> @@ -1004,7 +1007,7 @@ static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
>>   		*ptr = 0;
>>   
>>   	mem_current = cg_read_long(cgroup, "memory.current");
>> -	if (!mem_current || !values_close(mem_current, mem_max, 3))
>> +	if (!mem_current || !values_close(mem_current, mem_max, 6 + pscale_factor))
>>   		goto cleanup;
>>   
>>   	swap_current = cg_read_long(cgroup, "memory.swap.current");
>> @@ -1684,6 +1687,14 @@ int main(int argc, char **argv)
>>   	if (page_size <= 0)
>>   		page_size = PAGE_SIZE;
>>   
>> +	/*
>> +	 * It is found that the actual memory.current value can deviate more
>> +	 * from the expected value with larger page size. So error tolerance
>> +	 * will have to be increased a bit more for larger page size.
>> +	 */
>> +	if (page_size > KB(4))
>> +		pscale_factor = (page_size >= KB(64)) ? 2 : 1;
> This is a good improment but I still think the pscale_factor adjustments
> are a bit fragile, each call site needs its own hand-tuned formula, and only
> three page sizes (4K/16K/64K) are handled. If a new page size shows up,
> every call site needs revisiting.
>
> How about centralizing the page size adjustment inside values_close()
> itself? Something like:
>
>      static inline int values_close(long a, long b, int err)
>      {
>            ssize_t page_adjusted_err = ffs(page_size >> 13) + err;
>      
>            return 100 * labs(a - b) <= (a + b) * page_adjusted_err;
>      }
>
> This adds one extra percent of tolerance per doubling above 4K, scales
> continuously for any power-of-two page size, and also fixes an integer
> truncation issue in the original: (a + b) / 100 * err loses precision
> when (a + b) < 100.
>
> With this, the callers wouldn't need any changes at all.
>
> This method is inspired from LTP:
>    https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/controllers/memcg/memcontrol_common.h#L27

Good point. I will implement something like in the next version.

Cheers,
Longman


