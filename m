Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A9FC79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 02:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25B3D6B008A; Wed,  9 Sep 2026 22:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205946B008C; Wed,  9 Sep 2026 22:29:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7066B0092; Wed,  9 Sep 2026 22:29:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD6EC6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:29:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0795BC03B9
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:29:37 +0000 (UTC)
X-FDA: 85196271594.03.FD3287D
Received: from mta1.migadu.com (out-147.mta1.migadu.com [95.215.58.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3F5D2100003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:29:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pssyfs5u;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.147 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789007375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1dXHIkcJwJLA3XRSt6pYMi2wLGGIVeR4tS6aHBeJyNU=;
	b=vD96luk6UB+elyAxSp7ShPRfpad2Kcsa+f1sebfGHWyV4/T+vian7TFeKjANnQJI4Ri9Fa
	h66ioUX2OyrOcoieBgu/NirzsPtpTaVRxe5VHExqhTv1EegsxwDldcS4jV4sDnNnSTBEVp
	4SpTCp32XWCVzO2gnFYCXp7AMI5ZyLY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pssyfs5u;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.147 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789007375;
	b=wVHc9GkHBLELguip+jyF8x8B5f976HaAJYhP5rDdF+L9EmC1BRULmKPFv4Owztv/guHJm9
	AKeaOaMUkQYVLKSykAXGgXJjo/BJD4Hom7Bx+8jIno4qijhV7fm3C9d4/Z81OBDazE6iAt
	HIyD7wZHpqw79WvjDYXTNYsjm6be0Fg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Y/blbjutIcIhh1FZMIlhTaz3G2b1cjP6+5HZLeL4Xxc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789007368; v=1; x=1789612168;
 b=pssyfs5u/ge2qtdtQ5UewIqqERFFt2qdNLPX4iCPo7bLsQGuPr+wI4v9UkamJDRPt2BGgNHR
 dNzEfXty5Fm54+/jDJnRAbTch1eGYK9gsbA56rlixHczHruRctTYo1P9iJ5QlspfI65Aeb8t79h
 crxzbr3DgL5yWdnGb1ccxmJE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cbde5c5200df5b9a;
	Thu, 10 Sep 2026 02:29:28 +0000
X-Mizu-Trace-ID: cbde5c5200df5b9a
X-Migadu-Flow: FLOW_OUT
Message-ID: <bc8d46f4-4bdd-45b6-8c68-09a8b7556dc3@linux.dev>
Date: Thu, 10 Sep 2026 10:29:19 +0800
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH v4 0/4] mm: workingset: fix the shadow node budget under
 MGLRU
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1788837625.git.zhuhui@kylinos.cn>
 <20260908183733.ea115c9f8e6f88220d1b9b5b@linux-foundation.org>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <20260908183733.ea115c9f8e6f88220d1b9b5b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3F5D2100003
X-Stat-Signature: ygy9hrwyiarze4ya1m35trbnx8nghw5y
X-Rspam-User: 
X-HE-Tag: 1789007372-398629
X-HE-Meta: U2FsdGVkX19/3UddPp5xDsdIxqz/uSyB6CI01uz+7RdBr/r+V4gMqdTxlNrb0WC3zXtiIXXcp0FTyLdgpWqZ4E+b8feq9mTmQ74a9LVRLezCR017DMQADevqx5kRjjnXxJG4K7BmWf93aywW0sf2mIJ4NqP5FzvsMJRT6SoqA8pXtz/foRVhdtXCmXpBjHA6LYtQChq1gBrRiKIJ3jMeFHIKU78+mfKhxzucBgb1P17ZuWwmiF8JI5ExVclZXlbPN6kVj6bjE8wjPr4iRpaSRAvr+vfBuzOlk9dwIShnNzi+cEoFZwIq13i0lMsGORSYS+LHY/gFke1RcjRDWBYvJbefpJxhO5onyckB7RjC0RZ081JfVyK10RbDzXcfrkd9lg/tI09EBuwkRVOUtwhBqQxBJ2ubfOy1iC3WveWqoFUJ/qt1DCI2/wWv9c6XHLY3fowVPcnVS3aMwR8wp9Y7Y0k8wt2wjyeOGHsCKqJWrUmqJWI0mu4RgjsEWTGGUJgKSPilg9ur3J2xhXxd9sN93LKAB7STlCTmr7dtIb2Q/oyRCy4rwBBzNp8EOnl+QqkmrDBfmsG502PIVRy9W2o9uNYLwwmPYuAuU+DMicGeDBdiEpzfjApGny6agB1SQTRSXMms+MMi1mraUbNLvLsa2pAHW+YFVtOeYzfKj+COOKJp722HzxnPjMdQfVSPMght6ikp5/cCuFvUXBQRX4tko9eADrHw7/X2iynbyI4mFkRE9vPbDq2n3gUswKJGkq2bjTuPxuBsY1NM2HwpwAjsIaxUZJOIqOBE8LSsmuREwWGGtToDJF5TiQwl+ARwcPU6WGrooKbKOu9KrL1TP/5KMouZSsh4i+foqlTeqdMiOxHDKwwHSjgJbL4R+iJ2NdHjUt8q1Em19SOmxOrqXR3HcOJcdTUlaSookLxUlqYqtoR4CL8D0jgxm0hPkmup9SlzTHdYCT+hPJyvmMrad/R
 ajwy2y4L
 P44osQGDKXxBDfzDZV+topjJKNeIlZeYGJ16gMx3ddx/MtZ6fWSWSwiXOxl+DiDAY0URnMWKBvtK6IzXA147KkEQXF0E/zwmufS3MZC1nCdAlpYHCLd60YsGQDBzhz6g0nzv02e3gv5sK3SNU/yE7BcRVG8uIkT1eIY5DmDz4sbU62GMKKe3ehhD/I7VuwxIPVqmJPnumTUpSG2cfgxFzLazS5sdgtUsKNvMrSSA57HV83aR26fd7XzzPemVoZh4Ez/NtA8SpsnRt/4ouROmuB6ak+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> On Tue,  8 Sep 2026 11:41:10 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:
>
>> From: Hui Zhu <zhuhui@kylinos.cn>
>>
>> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
>> number of lru pages") broke the workingset shadow node budget under
>> MGLRU: lruvec_lru_size() reads mz->lru_zone_size, which MGLRU never
>> maintains, so count_shadow_nodes() sees the evictable LRU lists as
>> empty and the shadow shrinker reclaims eviction tokens almost as fast
>> as they are created, losing thrashing protection.
>>
>> ...
>>
>> Performance testing
>> ===================
>>
>> The test script and the raw results are available at [1].
>>
>> Environment: 10-vCPU QEMU guest, 8 GiB RAM, cgroup v2; 7 runs per
>> configuration, medians reported.  Workloads:
>>
>>    w1-anon-churn: single-threaded anon fault/charge loop in a memcg
>>                   (MADV_DONTNEED + re-fault, no reclaim).  Every touch
>>                   is a real fault with charge and memcg stat updates,
>>                   so it stresses exactly the fast path patch 1 changes.
>>    w2-file-churn: file read loop under memory.high pressure
>>                   (reclaim-bound, noisier).
>>    w3-reparent:   reparent accounting sanity check.
>>
>> w1-anon-churn (pages/s):
>>
>>                   classic LRU          MGLRU
>> base             4393028              4377122
>> patches 1-2      4385996   (-0.2%)    4352887   (-0.6%)
>> patches 1-3      4381832   (-0.3%)    4377053   (+0.0%)
>>
>> w2-file-churn (MB/s):
>>
>>                   classic LRU          MGLRU
>> base             8277                 8226
>> patches 1-2      8226      (-0.6%)    8123      (-1.3%)
>> patches 1-3      8157      (-1.4%)    8294      (+0.8%)
> Am I misinterpreting this?  This difference is probably within
> inter-run variability?
>
You are reading it correctly.
The w2-file-churn differences are within run-to-run noise: it is a
reclaim-bound workload dominated by reclaim and I/O, which is too noisy
to expose the small fast-path overhead.
That is what the "within run-to-run noise" note in the cover letter
refers to.

The meaningful signal is in w1-anon-churn, which is designed to hit
exactly the fast path patch 1 changes: every iteration is a real fault
with charge and memcg stat updates, no reclaim involved.
There patches 1-2 show a consistent small overhead (-0.2%/-0.6%), and
patch 3 brings both LRU configurations back to the base level.

I can reword the cover letter in the next version to make this clearer
if you think it would help.

Best,
Hui


