Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A043CA1013
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 01:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60FBA8E0005; Fri,  5 Sep 2025 21:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7AE8E0001; Fri,  5 Sep 2025 21:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FDB18E0005; Fri,  5 Sep 2025 21:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF7E8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:56:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 08A401DE0DF
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 01:56:27 +0000 (UTC)
X-FDA: 83857160814.27.3F16AAE
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf20.hostedemail.com (Postfix) with ESMTP id ADF6A1C0005
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 01:56:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757123785; a=rsa-sha256;
	cv=none;
	b=JCNg/Iz/roYlYOzZACXP9vvPlOPmZkF5qUHoVN3uIliPwskbzY0M6MPCg4yB40C1PiUcth
	4hqkEisjKNYJYcRq5bOFa8ztIZ6uD3SOce0aRfUQ6CJtOneBiQn6WBe64NWjNU6lEm6JSZ
	w1j8pp6HnbrBQ2y7oyiYHet4fjNp43U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757123785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nuv0EH5qB+dNXHjqLtN7wwiFin2Pn0KBdAWwUWqWA2E=;
	b=QKXsVU5Krlw6nlSPVsi33818BFvcPaMx+JMXlTZ0SY7NfHxwJvXMU/z31BY/7gCuQ2bSis
	Sg1uJtcxYtKoaAhkhhiTHScz1k9BygXO14Ioq/l73YyaypesohqJFaVz7xIh2fZ6E459s5
	gkIarILOXCLRiJPXAm64DY6zdWLG3yA=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cJbmh1StgzJsWt;
	Sat,  6 Sep 2025 09:51:48 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id A58B918048B;
	Sat,  6 Sep 2025 09:56:18 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 6 Sep 2025 09:56:17 +0800
Content-Type: multipart/alternative;
	boundary="------------rBIQj9CCRXgZ8KkRlAyYkrFU"
Message-ID: <8616715a-fa08-47d1-bee2-2608a5c4d9f3@huawei.com>
Date: Sat, 6 Sep 2025 09:56:16 +0800
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
 <f088cdda-9799-43ef-a4f0-fba563be4076@huawei.com>
 <aLqadzgmyGGjSck6@tiehlicka>
 <87e085b9-3c7d-4687-8513-eadd7f37d68a@huawei.com>
 <aLqo9NKQ-xDfJ-14@tiehlicka>
 <69180098-9fcf-44c1-ac6b-dc049b56459e@huawei.com>
 <aLqwcXHzsaTxN3dM@tiehlicka>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <aLqwcXHzsaTxN3dM@tiehlicka>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ADF6A1C0005
X-Stat-Signature: pn5iyfgyiyp4dzu39pma9ywz1tzmqwwh
X-Rspam-User: 
X-HE-Tag: 1757123783-730659
X-HE-Meta: U2FsdGVkX1/tIheGWGRV+8iliImnxPiVIY6E1tuYo3RlkGI8Rat2djF2isRjNjwpwfhgis8ObLpoCkcUWw8blU/Gm9+avyP0rPjNnb3pRUhfBYxDJgS5rAK55/SMk/v3qG7SU6scB8jO7/hwMkAWKAtPhAKNU/7ZKOrgNFUhHK9rDw8h2NVDHNfdVTArrpLcSO7vV0+Gg2fSF8JaoZq5wiIm6IvGT53ip5X6EgA8O0BGDn+kNYpMMONvtjHIR/NRjkkL/6Tsi9M7vCr6z6RbpQHHsOD/Y13X/An8vYnLTRw9j79dgbmeISoqrG4ueyT0bNpue3qxdPIA/kLgLatWmx0lAcmVKKwIK0veuT3aV80ZsD7k0Wtq6trE3CdS35qKAmjsc8XGCy/MP6/2TzQa3siCdfWOn3tBdWspNlKcOxjjPmoyU74hOCewnNDMP1efATJCSWDUmQ4S3FDkvQyi5zEXzwBzha0O5F3DXEVr2fIRrlyfShZlltlciJxgGtub0cxMejztq3/jnzCERWmywTc+7oEjTSgnuE4QIkWPF0C02NwgjV07qfURLdG4OXdgjxUhcCoiD3OgUc0oBPS+w1cPEFmuxSuzjkF83mdg12dXsb7RDICqoF0BS3PS+BqreYXM5ee/8GEF52n7duHrY5ueARxPdTvjYtw7hUaxFe+rqYwaD0nhUI41kwlFtdLSWevdK+iobQf5Yhr5bY2VfpVwarHIxW0KI0C6azkUtWfHzTF+y1gyD0WWQhjWqpFut06hACqSsBMi8U4jK954ERwwwdEsRMVhOS8go0lHSC1vMSHk6eWapLwtb4hHD38uTmEcUtMqIGcgihsWLaTI1Ea0X0SpOCx2dZgdrcyQrTo4P0moI5oaRTZSz/2Dc8GbH9etJZ2Y4RAXBdMVmUuvH3p0ecCXQnHoVG8Ot2XCXnS9PErmLpsun/ytnj5Os25crj12kamAbYCZjlITFn9
 CeuGpWi0
 msuICEBbB29VU4rv6aG38qK0i/fMWRI9o80+fdm6p2B/IJOmF6s6nog+6OD2CSaqN4qmtJydlM5t12BHKKw7gbt49WD20TvsZ0+vxGeY1DYBRk1hBnIJQJ6ZNS3Zk7HK3jVv7g7NNl2ZlbJ0OhLR/9olYzxgqRjNJpvRtrZY2L0bEDhw+dH7KAEeSP4ahWW+dN9P8o7Z4HfdoEblk9PEi+HkWWumOceZ5K3Tho35OXJCLdKscyVAH4ciOM4tXBAKmHpWPsN3Uoh5zO2bBCnTIAmDJmUIhkRWvMLLdAw/rh9nndViU2y7r26Nr5xTPJYWTlUCGiqVQn8CWxcBkpu7dAUFLiL7/tqf5IJA+D+Ww62YfLG+U7OLxpmi30Dw+t6Y3M/HibOuALk+J26oGBo24JiUxZgHj5icsZGDbOC9dkvJsQqY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------rBIQj9CCRXgZ8KkRlAyYkrFU
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/9/5 17:42, Michal Hocko 写道:
> On Fri 05-09-25 17:25:44, Jinjiang Tu wrote:
>> 在 2025/9/5 17:10, Michal Hocko 写道:
>>> On Fri 05-09-25 16:18:43, Jinjiang Tu wrote:
>>>> 在 2025/9/5 16:08, Michal Hocko 写道:
>>>>> On Fri 05-09-25 09:56:03, Jinjiang Tu wrote:
>>>>>> 在 2025/9/4 22:25, Michal Hocko 写道:
>>>>>>> On Thu 04-09-25 21:44:31, Jinjiang Tu wrote:
>>>>>>>> out_of_memory() selects tasks without considering mempolicy. Assuming a
>>>>>>>> cpu-less NUMA Node, ordinary process that don't set mempolicy don't
>>>>>>>> allocate memory from this cpu-less Node, unless other NUMA Nodes are below
>>>>>>>> low watermark. If a task binds to this cpu-less Node and triggers OOM, many
>>>>>>>> tasks may be killed wrongly that don't occupy memory from this Node.
>>>>>>> I can see how a miconfigured task that binds _only_ to memoryless nodes
>>>>>>> should be killed but this is not what the patch does, right?  Could you
>>>>>>> tell us more about the specific situation?
>>>>>> We have some cpu-less NUMA Nodes, the memory are hotpluged in, and the zone
>>>>>> is configured as ZONE_MOVABLE to guarantee these used memory can be migrated when
>>>>>> we want to offline the NUMA Node.
>>>>>>
>>>>>> Generally tasks doesn't configure any mempolicy and use the default mempolicy, i.e.
>>>>>> allocate from NUMA Node where the task is running on, and fallback to other NUMA Nodes
>>>>>> when the local NUMA Node is below low watermark.As a result, these cpu-less NUMA Nodes
>>>>>> won't be allocated until the NUMA Nodes with cpus are with low memory. However, These
>>>>>> cpu-less NUMA Nodes are configured as ZONE_MOVABLE, can't be used by kernel allocation,
>>>>>> leading to OOM with large amount of MOVABLE memory.
>>>>> Right, this is a fundamental constrain of movable zones. They cannot
>>>>> satisfy non-movable allocations and you can get OOM for those requests
>>>>> even if there is plenty of movable memory available. This is no
>>>>> different from highmem systems and kernel allocations.
>>>>>
>>>>>> To avoid it, we make some tasks binds to these cpu-less NUMA Nodes to use these memory.
>>>>>> When these tasks trigger OOM, tasks that don't use these cpu-less NUMA Nodes may be killed
>>>>>> according to rss.Even worse, after one task is killed, the allocating task find there is
>>>>>> still no memory, triggers OOM again and kills another wrong task.
>>>>> Let's see whether I follow you here. So you are binding some tasks to movable
>>>>> nodes only and if their allocation fails you want to kill that task
>>>>> rather than invoking mempolicy OOM killer as that could kill tasks
>>>>> which are not constrained to movable nodes, right?
>>>> Yes. It't difficult to kill tasks that use movable nodes memory, because we have
>>>> no information of per-numa rss of each task. So, kill current task is the simplest way
>>>> to avoid killing wrongly.
>>> There were attempts to make the oom killer cpuset aware. This would
>>> allow to constrain the oom killer to a cpuset for which we cannot
>>> satisfy the allocation for. I do not remember details why this reach
>>> meargable state. Have you considered something like that as an option?
>> Only select tasks that bind to one of these movable nodes, it seems better.
>>
>> Although oom killer could only select according to task mempolicy, not vma policy, it't better
>> than blindly killing current.
> Yes, I do not think we can ever support full mempolicy capabilities but
> recognizing this is a cpuset allocation failure and selecting from the
> cpuset tasks makes a lot of sense.

In our use case, movable nodes are in all cpusets, so that movable nodes can be
used by all tasks. Even though we move tasks into cpusets that only allow to allocate
from movable nodes, oom_cpuset_eligible()->cpuset_mems_allowed_intersects() returns true for
all tasks.

Maybe when oc->nodemask == movable nodes, only select tasks whose mempolicy intersects with oc->nodemask.
Like the following:

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index eb83cff7db8c..e56b6de836a6 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2328,6 +2328,9 @@ bool mempolicy_in_oom_domain(struct task_struct *tsk,
         if (!mask)
                 return ret;
  
+       if (!nodes_intersects(*oc->nodemask, node_states[N_CPU]))
+               ret = false;
+
         task_lock(tsk);
         mempolicy = tsk->mempolicy;
         if (mempolicy && mempolicy->mode == MPOL_BIND)

--------------rBIQj9CCRXgZ8KkRlAyYkrFU
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
    <div class="moz-cite-prefix">在 2025/9/5 17:42, Michal Hocko 写道:<br>
    </div>
    <blockquote type="cite" cite="mid:aLqwcXHzsaTxN3dM@tiehlicka">
      <pre wrap="" class="moz-quote-pre">On Fri 05-09-25 17:25:44, Jinjiang Tu wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
在 2025/9/5 17:10, Michal Hocko 写道:
</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">On Fri 05-09-25 16:18:43, Jinjiang Tu wrote:
</pre>
          <blockquote type="cite">
            <pre wrap="" class="moz-quote-pre">在 2025/9/5 16:08, Michal Hocko 写道:
</pre>
            <blockquote type="cite">
              <pre wrap="" class="moz-quote-pre">On Fri 05-09-25 09:56:03, Jinjiang Tu wrote:
</pre>
              <blockquote type="cite">
                <pre wrap="" class="moz-quote-pre">在 2025/9/4 22:25, Michal Hocko 写道:
</pre>
                <blockquote type="cite">
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
                  <pre wrap="" class="moz-quote-pre">I can see how a miconfigured task that binds _only_ to memoryless nodes
should be killed but this is not what the patch does, right?  Could you
tell us more about the specific situation?
</pre>
                </blockquote>
                <pre wrap="" class="moz-quote-pre">We have some cpu-less NUMA Nodes, the memory are hotpluged in, and the zone
is configured as ZONE_MOVABLE to guarantee these used memory can be migrated when
we want to offline the NUMA Node.

Generally tasks doesn't configure any mempolicy and use the default mempolicy, i.e.
allocate from NUMA Node where the task is running on, and fallback to other NUMA Nodes
when the local NUMA Node is below low watermark.As a result, these cpu-less NUMA Nodes
won't be allocated until the NUMA Nodes with cpus are with low memory. However, These
cpu-less NUMA Nodes are configured as ZONE_MOVABLE, can't be used by kernel allocation,
leading to OOM with large amount of MOVABLE memory.
</pre>
              </blockquote>
              <pre wrap="" class="moz-quote-pre">Right, this is a fundamental constrain of movable zones. They cannot
satisfy non-movable allocations and you can get OOM for those requests
even if there is plenty of movable memory available. This is no
different from highmem systems and kernel allocations.

</pre>
              <blockquote type="cite">
                <pre wrap="" class="moz-quote-pre">To avoid it, we make some tasks binds to these cpu-less NUMA Nodes to use these memory.
When these tasks trigger OOM, tasks that don't use these cpu-less NUMA Nodes may be killed
according to rss.Even worse, after one task is killed, the allocating task find there is
still no memory, triggers OOM again and kills another wrong task.
</pre>
              </blockquote>
              <pre wrap="" class="moz-quote-pre">Let's see whether I follow you here. So you are binding some tasks to movable
nodes only and if their allocation fails you want to kill that task
rather than invoking mempolicy OOM killer as that could kill tasks
which are not constrained to movable nodes, right?
</pre>
            </blockquote>
            <pre wrap="" class="moz-quote-pre">Yes. It't difficult to kill tasks that use movable nodes memory, because we have
no information of per-numa rss of each task. So, kill current task is the simplest way
to avoid killing wrongly.
</pre>
          </blockquote>
          <pre wrap="" class="moz-quote-pre">There were attempts to make the oom killer cpuset aware. This would
allow to constrain the oom killer to a cpuset for which we cannot
satisfy the allocation for. I do not remember details why this reach
meargable state. Have you considered something like that as an option?
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">
Only select tasks that bind to one of these movable nodes, it seems better.

Although oom killer could only select according to task mempolicy, not vma policy, it't better
than blindly killing current.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Yes, I do not think we can ever support full mempolicy capabilities but
recognizing this is a cpuset allocation failure and selecting from the
cpuset tasks makes a lot of sense.
</pre>
    </blockquote>
    <pre>In our use case, movable nodes are in all cpusets, so that movable nodes can be
used by all tasks. Even though we move tasks into cpusets that only allow to allocate
from movable nodes, oom_cpuset_eligible()-&gt;cpuset_mems_allowed_intersects() returns true for
all tasks.

Maybe when oc-&gt;nodemask == movable nodes, only select tasks whose mempolicy intersects with oc-&gt;nodemask.
Like the following:

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index eb83cff7db8c..e56b6de836a6 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2328,6 +2328,9 @@ bool mempolicy_in_oom_domain(struct task_struct *tsk,
        if (!mask)
                return ret;
 
+       if (!nodes_intersects(*oc-&gt;nodemask, node_states[N_CPU]))
+               ret = false;
+
        task_lock(tsk);
        mempolicy = tsk-&gt;mempolicy;
        if (mempolicy &amp;&amp; mempolicy-&gt;mode == MPOL_BIND)

</pre>
    <blockquote type="cite" cite="mid:aLqwcXHzsaTxN3dM@tiehlicka">
      <pre wrap="" class="moz-quote-pre">
</pre>
    </blockquote>
  </body>
</html>

--------------rBIQj9CCRXgZ8KkRlAyYkrFU--

