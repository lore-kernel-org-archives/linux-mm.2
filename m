Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6DE9CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BFF58E0007; Fri,  5 Sep 2025 05:25:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 397D48E0001; Fri,  5 Sep 2025 05:25:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D43D8E0007; Fri,  5 Sep 2025 05:25:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0078E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:25:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1BCCBA66D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:25:54 +0000 (UTC)
X-FDA: 83854664628.16.E715514
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7A00D120003
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:25:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757064353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Lh3tMa5DHMlm/god0XSfHzT8StLzQySapCG4d52TSA=;
	b=ZKze0/K9GBzwvUBINhu0Q7evts66pbL7SkUBqXP/jTIoxGSPZ4ozf2jw1sN5qklQfa58eX
	IssTOFmuzwss+rPAOBHQP3IAbKDpAyOTcxmJSJ1mVnTflw/MZRSRrCs0NxyB+mMwzoZAFg
	VqObV6trv9pcpB+TG08L+9+K3Y1Tuj8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757064353; a=rsa-sha256;
	cv=none;
	b=hfjfw8HEUxrUaEBFLTf12eztKHch9TotWS3hBWivcbhf4o/a5tYmWOPnZW4tEt5UwAdXFm
	GizLMsK1SPsvjHkmqrtC5iZeHQN1qdw5fqEkut2i1IjMrG0pajuVhtWYkZxt7Jt6RV4swJ
	9Ah1g/ORWbbmARNrh0FnChBQLlBxSV0=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cJ9qK3XF4z24j4W;
	Fri,  5 Sep 2025 17:22:37 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 85D641A0188;
	Fri,  5 Sep 2025 17:25:46 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 5 Sep 2025 17:25:45 +0800
Content-Type: multipart/alternative;
	boundary="------------0ojXdgKluhc8TxEjJ5wiTjYK"
Message-ID: <69180098-9fcf-44c1-ac6b-dc049b56459e@huawei.com>
Date: Fri, 5 Sep 2025 17:25:44 +0800
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
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <aLqo9NKQ-xDfJ-14@tiehlicka>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: 7A00D120003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: dyuhktwappxrcs53qwyd41mecigkofrj
X-HE-Tag: 1757064351-74430
X-HE-Meta: U2FsdGVkX19GeoUI8sQAy+doejsbsmzGPTjEzqD76Zav63EQkDKOtY7rWgEnDwjk7A6yDtd4xeU20ZfKcb5KNJpv4kRxKzJCTrKmt5eZfcGt4fcglQk4AQrC8Me2DIB7RG6fOEZrYrPCJevSetEcrC+gfFen9p8qt0X3sOsAiD49e0lUNZwvlyOez9nmJSV4DevbErsW2SJeqrmdguRATDOiySFKSddD/xXi/deZ+A+iQDpIhcdtwP8r8ntwBR8mtyWf5ZUW0XtWHqfkWZQkpG/cb+HumbhTEXtwK/1FBUJ+G+e+XnZV9RjthrKqOkNVTKxPgcYPWzHRyL+a1BxqbrVfrj1sOB4c2p4SXTdngCPDrdChKp5WagStwLoDolxFVf8jJ9oYZEN90zkuatGTPOUyPZPbZoqwQf6GHxpC3sNodcewwFTWvG/Kw0CeWREy7XrIMBJZOBjDLFPYaisMlxeH19ct3TDz2xEpKNQndKpjAes8ayJyhFHtQQ0ZTABH9BSPClifbDdhab43YUKv5Eon3Cdp/8bys5FEzVN95uzFEmHd0PcYNDiJbCUCqb2Sp0L0SR1q/XahFN6/l7oGVhj5SlLGJ+kJZqPv26e5ZyK9XkyrFqUaRljwIpAaPCSGJVpQfQ52+OiRrAI0kRKmqUqsbzm+Iz3MgCQux6k1qX3C2ZfKNzuxAaSlMd0VcB8EwFbCz3MPoqokTtxshbJyFexnJJ6BAE+vyajznSW9MvuEW9/5Pjwdd3Tjr1DM5zjuexk1xjBoMY3b4L748MUc274r4GcMKspmjdRXqQjzttvEsIstK+q0i0exfqdjgPjzln0Ww81vMcH3fF6OGIYHYqoGKUMFxNiuqAO5Mkq9CZjzqA3PR23EsBmeVs99rNE6GNNhFvGgHowjv9moQ1wUcvR3oTamkCa3rzS7I+pIaspV+JZlbL622GXi5FfHLw8MneO8o8efYzbk1UxYhj5
 jrRk2Og5
 741T5Oz0TdYrinz4f7W2QA6jNvO3hasEeEY5lX506oT+Mf8A4OJRLwGWCKUSOI3Nom1VUSNkCOQ1llhmekBBI3q6ovEtI8vup9Hh9367bAbSxOZEsDQoc1L1YzBmdtQuxVQCL61mQMsHwO17Pq3LstVhLGCBHQqyeWSI5HgcKMkP8muEWCElLwE0X0aHRK4EwJRa8lUF1Q7R7UyhWbGby5tvFeCG6/hA7Zk33zVZbDYy5IG5HFnxaUDX0Bf03BAcGLdJWmu5RVdp6Sa7q8JZt1vE/NpZ5fB65feSLew5juXLmuqnKHG5XfQ0FktjQTJd9UQI5w3LiaFuk9hRaFUmVp/riMZqPKsAOpZwdHAfODKl0fGkyMHnGZLg4oRFN7jaHkp6W2wRm1C2uMVytjVX8u3xoZXYlBSha5aRCcCnHSifY2ok=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------0ojXdgKluhc8TxEjJ5wiTjYK
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/9/5 17:10, Michal Hocko 写道:
> On Fri 05-09-25 16:18:43, Jinjiang Tu wrote:
>> 在 2025/9/5 16:08, Michal Hocko 写道:
>>> On Fri 05-09-25 09:56:03, Jinjiang Tu wrote:
>>>> 在 2025/9/4 22:25, Michal Hocko 写道:
>>>>> On Thu 04-09-25 21:44:31, Jinjiang Tu wrote:
>>>>>> out_of_memory() selects tasks without considering mempolicy. Assuming a
>>>>>> cpu-less NUMA Node, ordinary process that don't set mempolicy don't
>>>>>> allocate memory from this cpu-less Node, unless other NUMA Nodes are below
>>>>>> low watermark. If a task binds to this cpu-less Node and triggers OOM, many
>>>>>> tasks may be killed wrongly that don't occupy memory from this Node.
>>>>> I can see how a miconfigured task that binds _only_ to memoryless nodes
>>>>> should be killed but this is not what the patch does, right?  Could you
>>>>> tell us more about the specific situation?
>>>> We have some cpu-less NUMA Nodes, the memory are hotpluged in, and the zone
>>>> is configured as ZONE_MOVABLE to guarantee these used memory can be migrated when
>>>> we want to offline the NUMA Node.
>>>>
>>>> Generally tasks doesn't configure any mempolicy and use the default mempolicy, i.e.
>>>> allocate from NUMA Node where the task is running on, and fallback to other NUMA Nodes
>>>> when the local NUMA Node is below low watermark.As a result, these cpu-less NUMA Nodes
>>>> won't be allocated until the NUMA Nodes with cpus are with low memory. However, These
>>>> cpu-less NUMA Nodes are configured as ZONE_MOVABLE, can't be used by kernel allocation,
>>>> leading to OOM with large amount of MOVABLE memory.
>>> Right, this is a fundamental constrain of movable zones. They cannot
>>> satisfy non-movable allocations and you can get OOM for those requests
>>> even if there is plenty of movable memory available. This is no
>>> different from highmem systems and kernel allocations.
>>>
>>>> To avoid it, we make some tasks binds to these cpu-less NUMA Nodes to use these memory.
>>>> When these tasks trigger OOM, tasks that don't use these cpu-less NUMA Nodes may be killed
>>>> according to rss.Even worse, after one task is killed, the allocating task find there is
>>>> still no memory, triggers OOM again and kills another wrong task.
>>> Let's see whether I follow you here. So you are binding some tasks to movable
>>> nodes only and if their allocation fails you want to kill that task
>>> rather than invoking mempolicy OOM killer as that could kill tasks
>>> which are not constrained to movable nodes, right?
>> Yes. It't difficult to kill tasks that use movable nodes memory, because we have
>> no information of per-numa rss of each task. So, kill current task is the simplest way
>> to avoid killing wrongly.
> There were attempts to make the oom killer cpuset aware. This would
> allow to constrain the oom killer to a cpuset for which we cannot
> satisfy the allocation for. I do not remember details why this reach
> meargable state. Have you considered something like that as an option?

Only select tasks that bind to one of these movable nodes, it seems better.

Although oom killer could only select according to task mempolicy, not vma policy, it't better
than blindly killing current.

--------------0ojXdgKluhc8TxEjJ5wiTjYK
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
    <div class="moz-cite-prefix">在 2025/9/5 17:10, Michal Hocko 写道:<br>
    </div>
    <blockquote type="cite" cite="mid:aLqo9NKQ-xDfJ-14@tiehlicka">
      <pre wrap="" class="moz-quote-pre">On Fri 05-09-25 16:18:43, Jinjiang Tu wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
在 2025/9/5 16:08, Michal Hocko 写道:
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
        <pre wrap="" class="moz-quote-pre">
Yes. It't difficult to kill tasks that use movable nodes memory, because we have
no information of per-numa rss of each task. So, kill current task is the simplest way
to avoid killing wrongly.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
There were attempts to make the oom killer cpuset aware. This would
allow to constrain the oom killer to a cpuset for which we cannot
satisfy the allocation for. I do not remember details why this reach
meargable state. Have you considered something like that as an option?</pre>
    </blockquote>
    <pre>Only select tasks that bind to one of these movable nodes, it seems better.

Although oom killer could only select according to task mempolicy, not vma policy, it't better
than blindly killing current.</pre>
    <blockquote type="cite" cite="mid:aLqo9NKQ-xDfJ-14@tiehlicka">
      <pre wrap="" class="moz-quote-pre">
</pre>
    </blockquote>
  </body>
</html>

--------------0ojXdgKluhc8TxEjJ5wiTjYK--

