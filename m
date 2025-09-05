Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF97DCA1002
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 01:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12B898E0007; Thu,  4 Sep 2025 21:56:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DDA08E0001; Thu,  4 Sep 2025 21:56:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0E568E0007; Thu,  4 Sep 2025 21:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB2C58E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 21:56:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C01511A84C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 01:56:12 +0000 (UTC)
X-FDA: 83853531384.30.CD2282A
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf01.hostedemail.com (Postfix) with ESMTP id 987BC40005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 01:56:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757037370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vg3fthHAPcs3lCwgpH7RQqV2vSsTB5EqSI+AusRTGoA=;
	b=4NPO9KyE+ZrMPL8GgbWZYodBi99TW9EPE7KK6DPFhFodZaf0TCNNYQJOftc/dTkN2m5mMl
	3uRkEmpxbTny6/xE8OvXhqn4N4cOtoPDT/V8brX3hKgoYIIm0MjSLcNUUngMzGWRyIXhtr
	G/MbBRC8Mn3OYxm71FIjYYtAU+YXOgA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757037370; a=rsa-sha256;
	cv=none;
	b=ZaMIWb8qkS+nS1pRXycw1RdS5GoRy5gB1YvwHcMnGhGaX58OU1yCpRzq6MmNfPX3bxce4w
	kLq8GGZuQr0s7yEV6SuIpuC8KdBULxCBiWUR2R2WJ3094N9wh9J72bDhl0E9CTKh2QXScb
	vcGok/x1TMMDQOFqmmJ7eTM742DVH18=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cHzpv0JBbzPtMT;
	Fri,  5 Sep 2025 09:51:35 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 14360140278;
	Fri,  5 Sep 2025 09:56:05 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 5 Sep 2025 09:56:04 +0800
Content-Type: multipart/alternative;
	boundary="------------qDcK57pP3jslvg99Opau402G"
Message-ID: <f088cdda-9799-43ef-a4f0-fba563be4076@huawei.com>
Date: Fri, 5 Sep 2025 09:56:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/oom_kill: kill current in OOM when binding to cpu-less
 nodes
To: Michal Hocko <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>
References: <20250904134431.1637701-1-tujinjiang@huawei.com>
 <aLmhbjtF0Sp75XXE@tiehlicka>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <aLmhbjtF0Sp75XXE@tiehlicka>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 987BC40005
X-Stat-Signature: 7dxbfwo6mu5d1yo9nza4yt5mhr539ghs
X-Rspam-User: 
X-HE-Tag: 1757037369-676005
X-HE-Meta: U2FsdGVkX19slJllFXydxfxdkIz5Br5fZegTYoYqs8yeTLPDbCR3y6XhihsdqQw0zvsUyerFDXZ+bZ6SFOyrPsK45bDr7wcu4HJLwvGSKddh20QhUHbOBLgW6JyDQmJ4wHF7XQ4Ou3nxmkoT8coZjZIojIAhoQeG01ksia4dtvkIpsnD+VWiyoFP6hHmAKd5jXEcZamJ0HSm3UppbFZvdti/U2/WU95nBW/5l3Ym192Ml+BzHqhsORnORRMOr9IQ/3Cu1R3Xv9tphXJksohRagDbkz5g+7Xy6WQlz2zoa70JbFYNNTTgdijntYLWNgj3fthZ5qbjMxg9caWceW2Bbg9MxUd+Cy0m9DaY/MS9yW9Tc/ceuOVq3XOW920e593CIuWQKT4Rbk9C8uhTJ3AtUhVAxuX7lhEmmAs9745z6T+ewMQFczNTrNEDcQsoABHs/DWZsztYip8NsendDV9dFAyV/Rz0OEdicjUmScSje/hE+Bbjv3/3NP57s15nf5KZtO0xmWZioPDXtb1Mv2U40qrfNo353Wn85JYjg/RXkFKbBjsuGWzOu9Sa3bvobJSWDtPdojINkERCsCw7woOoqVy4pnMCtUKXpM5VZvnn6sXku8wTXm1cebtCiLlXvMKuTauDw70EfiX1TOMgn9kOazdT3ZUW+s7t13mp+AJwgEl30bc4sLHgBU9P2t45a8NKpWdD5TEN6HqBWngZuI91mnl4xBxhv/iS2yEk+N+XuvjvUUANfJ2mlUCSmQZj4pGvnyM9DkyyAvAAbcnKXbRSa0u4xbENQO/c4PetPmZ8tXIWsm9xhaRBH/Y7pRx/5VC7/Ou1nV36DCL6eFBKa8mt/Sb4Cla9QPZW3gfQp1UXG11gI8lxnGxW7s/I+bOcGANdslUZhP3BUw7m3GHbGQtVXpQF76KKW/4QP2kNBjCdAUVZa1bY65Bq6/S8Qg5r/FeHUrIyBlIVQJp4TqhhjZx
 /iZYqCyI
 hFiQQEIbBYKEpSe8n6f8AzEiOajdbq/bp4gXrzpB/2ZeoS4p6ryIwGc3FpmaprdxqpLVwTaelLJkWZ008oBWrkiZ2pSoU9D2ysnCpAWFdmoP7AtFlfs5BOEOZIFH385nEy5w5A7aHre2gC+oUESiWxYSqFTFGgqg5LWVh/e2lfJI9BHbK5z6hzDltConQaFU1Hl0qSZZOF2l51xAkBp181B9BKyL1mYFDgvABzdK9eSvXn/RxXFJLrbzuHYaPeknQipXTb3fhuNvjwvQUg95vIttW93aM08qhow+IpK5mdgcEqj/DUeX+0FaH5jKrVxZuzjUkYfqNSlDnv8p39jvELci1Ac+H6zo32UJhsIMBemWmvVxo11nk0qatGIp0Rwwflx7X0OKfEM9VgSABfliXuVr9DR5B5pEnF5O4bNQXOK+Vlw01lxDetNgxQn6tWJo9sXIYPkN1mzsH4hsZ6gqc6tsLMzMoHEWMg9ce
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------qDcK57pP3jslvg99Opau402G
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/9/4 22:25, Michal Hocko 写道:
> On Thu 04-09-25 21:44:31, Jinjiang Tu wrote:
>> out_of_memory() selects tasks without considering mempolicy. Assuming a
>> cpu-less NUMA Node, ordinary process that don't set mempolicy don't
>> allocate memory from this cpu-less Node, unless other NUMA Nodes are below
>> low watermark. If a task binds to this cpu-less Node and triggers OOM, many
>> tasks may be killed wrongly that don't occupy memory from this Node.
> I can see how a miconfigured task that binds _only_ to memoryless nodes
> should be killed but this is not what the patch does, right?  Could you
> tell us more about the specific situation?

We have some cpu-less NUMA Nodes, the memory are hotpluged in, and the zone
is configured as ZONE_MOVABLE to guarantee these used memory can be migrated when
we want to offline the NUMA Node.

Generally tasks doesn't configure any mempolicy and use the default mempolicy, i.e.
allocate from NUMA Node where the task is running on, and fallback to other NUMA Nodes
when the local NUMA Node is below low watermark.As a result, these cpu-less NUMA Nodes
won't be allocated until the NUMA Nodes with cpus are with low memory. However, These
cpu-less NUMA Nodes are configured as ZONE_MOVABLE, can't be used by kernel allocation,
leading to OOM with large amount of MOVABLE memory.

To avoid it, we make some tasks binds to these cpu-less NUMA Nodes to use these memory.
When these tasks trigger OOM, tasks that don't use these cpu-less NUMA Nodes may be killed
according to rss.Even worse, after one task is killed, the allocating task find there is
still no memory, triggers OOM again and kills another wrong task.

>> To fix it, only kill current if oc->nodemask are all nodes without any cpu.
>>
>> Signed-off-by: Jinjiang Tu<tujinjiang@huawei.com>
>> ---
>>   mm/oom_kill.c | 16 +++++++++++++++-
>>   1 file changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index 25923cfec9c6..8ae4b2ecfe12 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -1100,6 +1100,20 @@ int unregister_oom_notifier(struct notifier_block *nb)
>>   }
>>   EXPORT_SYMBOL_GPL(unregister_oom_notifier);
>>   
>> +static bool should_oom_kill_allocating_task(struct oom_control *oc)
>> +{
>> +	if (sysctl_oom_kill_allocating_task)
>> +		return true;
>> +
>> +	if (!oc->nodemask)
>> +		return false;
>> +
>> +	if (nodes_intersects(*oc->nodemask, node_states[N_CPU]))
>> +		return false;
>> +
>> +	return true;
>> +}
>> +
>>   /**
>>    * out_of_memory - kill the "best" process when we run out of memory
>>    * @oc: pointer to struct oom_control
>> @@ -1151,7 +1165,7 @@ bool out_of_memory(struct oom_control *oc)
>>   		oc->nodemask = NULL;
>>   	check_panic_on_oom(oc);
>>   
>> -	if (!is_memcg_oom(oc) && sysctl_oom_kill_allocating_task &&
>> +	if (!is_memcg_oom(oc) && should_oom_kill_allocating_task(oc) &&
>>   	    current->mm && !oom_unkillable_task(current) &&
>>   	    oom_cpuset_eligible(current, oc) &&
>>   	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
>> -- 
>> 2.43.0
--------------qDcK57pP3jslvg99Opau402G
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">在 2025/9/4 22:25, Michal Hocko 写道:<br>
    </div>
    <blockquote type="cite" cite="mid:aLmhbjtF0Sp75XXE@tiehlicka">
      <pre wrap="" class="moz-quote-pre">On Thu 04-09-25 21:44:31, Jinjiang Tu wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">out_of_memory() selects tasks without considering mempolicy. Assuming a
cpu-less NUMA Node, ordinary process that don't set mempolicy don't
allocate memory from this cpu-less Node, unless other NUMA Nodes are below
low watermark. If a task binds to this cpu-less Node and triggers OOM, many
tasks may be killed wrongly that don't occupy memory from this Node.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
I can see how a miconfigured task that binds _only_ to memoryless nodes
should be killed but this is not what the patch does, right?  Could you
tell us more about the specific situation? 
</pre>
    </blockquote>
    <pre>We have some cpu-less NUMA Nodes, the memory are hotpluged in, and the zone
is configured as ZONE_MOVABLE to guarantee these used memory can be migrated when
we want to offline the NUMA Node.

Generally tasks doesn't configure any mempolicy and use the default mempolicy, i.e.
allocate from NUMA Node where the task is running on, and fallback to other NUMA Nodes
when the local NUMA Node is below low watermark.As a result, these cpu-less NUMA Nodes
won't be allocated until the NUMA Nodes with cpus are with low memory. However, These
cpu-less NUMA Nodes are configured as ZONE_MOVABLE, can't be used by kernel allocation,
leading to OOM with large amount of MOVABLE memory.

To avoid it, we make some tasks binds to these cpu-less NUMA Nodes to use these memory.
When these tasks trigger OOM, tasks that don't use these cpu-less NUMA Nodes may be killed
according to rss.Even worse, after one task is killed, the allocating task find there is
still no memory, triggers OOM again and kills another wrong task.

</pre>
    <blockquote type="cite" cite="mid:aLmhbjtF0Sp75XXE@tiehlicka">
      <pre wrap="" class="moz-quote-pre">
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">To fix it, only kill current if oc-&gt;nodemask are all nodes without any cpu.

Signed-off-by: Jinjiang Tu <a class="moz-txt-link-rfc2396E" href="mailto:tujinjiang@huawei.com">&lt;tujinjiang@huawei.com&gt;</a>
---
 mm/oom_kill.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 25923cfec9c6..8ae4b2ecfe12 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1100,6 +1100,20 @@ int unregister_oom_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(unregister_oom_notifier);
 
+static bool should_oom_kill_allocating_task(struct oom_control *oc)
+{
+	if (sysctl_oom_kill_allocating_task)
+		return true;
+
+	if (!oc-&gt;nodemask)
+		return false;
+
+	if (nodes_intersects(*oc-&gt;nodemask, node_states[N_CPU]))
+		return false;
+
+	return true;
+}
+
 /**
  * out_of_memory - kill the "best" process when we run out of memory
  * @oc: pointer to struct oom_control
@@ -1151,7 +1165,7 @@ bool out_of_memory(struct oom_control *oc)
 		oc-&gt;nodemask = NULL;
 	check_panic_on_oom(oc);
 
-	if (!is_memcg_oom(oc) &amp;&amp; sysctl_oom_kill_allocating_task &amp;&amp;
+	if (!is_memcg_oom(oc) &amp;&amp; should_oom_kill_allocating_task(oc) &amp;&amp;
 	    current-&gt;mm &amp;&amp; !oom_unkillable_task(current) &amp;&amp;
 	    oom_cpuset_eligible(current, oc) &amp;&amp;
 	    current-&gt;signal-&gt;oom_score_adj != OOM_SCORE_ADJ_MIN) {
-- 
2.43.0
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
</pre>
    </blockquote>
  </body>
</html>

--------------qDcK57pP3jslvg99Opau402G--

