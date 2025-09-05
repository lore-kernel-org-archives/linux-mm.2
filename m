Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7521BCA1015
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 08:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3D396B000D; Fri,  5 Sep 2025 04:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEE1E6B000E; Fri,  5 Sep 2025 04:18:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A03F86B0010; Fri,  5 Sep 2025 04:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA826B000D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 04:18:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 37D3486905
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 08:18:55 +0000 (UTC)
X-FDA: 83854495830.02.ECC4AF4
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf29.hostedemail.com (Postfix) with ESMTP id 27F9C120006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 08:18:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757060333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NJRQejhTHUu7ndJwJdYrXjNjqSqNE2nD8urJMeqj3xo=;
	b=gMhQufY3y08AUc0lE6j1VPukNJ80BmDqY3p5KIPTYWdoJNUIDGqp0v8lk49pk5CQtuzxAS
	zZDF+FAbA0d7sxxcX9kzmqgI7G4dz4uazLzki+B9Q4vfBxH4gxwrPlp0q1jxc/aSGSTHa+
	qSjMfFW04b4CeHT5XIck0CltnSa+T6g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757060333; a=rsa-sha256;
	cv=none;
	b=rCL1kym0Vs7JThlSd7Tf1YtP9lHKg1D0FtFsJsQygkWGAVA5aVDioae4gIbyespPPUHrBE
	q4Z0/6iga+JozkW+Di2kPB5gsdcYS23EyFeQqpitaR7skXCPqxiuYKnC1+2xL6PkEQOIsq
	jAVfF8Tk6r/nQmR/z4wY3YPHtvs55HM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cJ8JJ5wBczQk0l;
	Fri,  5 Sep 2025 16:14:08 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 7C6B81400CA;
	Fri,  5 Sep 2025 16:18:45 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 5 Sep 2025 16:18:44 +0800
Content-Type: multipart/alternative;
	boundary="------------6QYWoRFXfZXRlUJMdyuQSYUt"
Message-ID: <87e085b9-3c7d-4687-8513-eadd7f37d68a@huawei.com>
Date: Fri, 5 Sep 2025 16:18:43 +0800
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
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <aLqadzgmyGGjSck6@tiehlicka>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 27F9C120006
X-Stat-Signature: agqj558jpz5srz5ukbribetb1kai5ia3
X-HE-Tag: 1757060330-520934
X-HE-Meta: U2FsdGVkX19u368hrIOmPeqgoCUxO5OguuKvas3ewHJq/GJo5deFSew3qbPNoQNGsHG8VnXKG6LKZ779Rx9wGc+C8bGMqJb5V7XlaQBdxN7rkuHXWeXl41Hm1PUH/iw33STkR6H8NTCKREaclEVEkOwZ1mAKDfv1kA+/2g8qGN1iWLHHZgHf/0OchzXs18z7Ihf2tCFmcbll9XoSE0CFez7z2RhnWiXivESSyeD8B6U+oIcbyyT9rh+q66FAUz92vRaCtSqg0EudcyUB2Nsex6/RntnUDES142iQ52fhIxZtFl0SNQPWm5Hjbx4B/UlcTRs66KhVPnsPrSZN1kFTL5RIVDyOcIO8F8xCBKS1JaDaheaJMAzKRdWtHP4D7iDshq9T6K0fBa3p3FhOolN34HLmBiJJkltCHvcJyrPkMvvlNurbgU2Ey8u0KlirjHsHVB+AcdxZuGNsDgZqwhc52EsRxFsWr7FEyu3n9tqRhNHnSgzOJK93m4cIbrZC0zvnzR19Gjqvr3WhsP+BDhJhdQmwWtv39y4NQ9Z/FusdUwl4Fs7GSdS8hu96ZKCNpRpBy8eJv++Plx0KjUSUmSB9jJ39CYjy3DMYJhqLe9sLmPSWTmYxWrRNUtOgnG7a0XtaeT6i/sFNThR9i5hsiKTgwyIp8RWwJmkhrTknO4CNRcC1iGhn+BrbY9OewCpJYX+6DDfyL83plA6DAFphAgNmg22opqqVQ5ewHdcizXuQgwoxMlSxIygAKn8pRgbZviwtsodKMnkvlBYz0c5dL98xwI1QVHDkPVNuxRD8KBM/M1NDdE2AQPSFTleYcIW6mpe+XaLbo73v9XEe13R9H2gQl86hsUK5zVMbPs14NhhxPlh+ra2JTm+QXK9AvkDQiz8T9iNkP4jeAVkA+/7IQc1kg1dvvkcomKJ4svVK9qjKuL3h4RwI09D/37QV1ITn0K2OtiQQAchRKwy1vIGmTl/
 0gq8aN96
 WbKrC2+bldJEhCxKS0PtWhMvDvTBZ38fZeLd9x0PW0Xi1GU2uAHll4lc0YpK0GajJt83ORAaJk+Au0WCDqKYun/48wZtXoSzT0WORwmkiy1VPvtUusvFcwGpaa6vkNcRJ5D1ppUTc8eKZHov7k0+KjNuArmyh2iM/aVJGu11EANiiBId+ZuVi6sUkkZTAUmYoqRqbhXH3siZ6QqFzkGJqOQJn07FdpeaPDmrpemOIvZLuSmRIXxu4oKhzGGeUbaBRGBw+cKvFYpGOCopG/1ETUorrqC0ggHRBPkBRxLQFeyjRvLma7GgaU1k4Ok1yiXYSOEuOH1AVgxO+eA3n1rjEiymIz3MxlTgB10hJapye/7Z1H3HvwAg+pWg2+ja9f7O2KRr5z8O6sjfNF8o9JzARJpyjcuQZXFNfrJkWK9XH4GNXSFVgaqvtxhnF4x/GMFL2+voak7Ee6crvEuuoDmGc+TofoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------6QYWoRFXfZXRlUJMdyuQSYUt
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/9/5 16:08, Michal Hocko 写道:
> On Fri 05-09-25 09:56:03, Jinjiang Tu wrote:
>> 在 2025/9/4 22:25, Michal Hocko 写道:
>>> On Thu 04-09-25 21:44:31, Jinjiang Tu wrote:
>>>> out_of_memory() selects tasks without considering mempolicy. Assuming a
>>>> cpu-less NUMA Node, ordinary process that don't set mempolicy don't
>>>> allocate memory from this cpu-less Node, unless other NUMA Nodes are below
>>>> low watermark. If a task binds to this cpu-less Node and triggers OOM, many
>>>> tasks may be killed wrongly that don't occupy memory from this Node.
>>> I can see how a miconfigured task that binds _only_ to memoryless nodes
>>> should be killed but this is not what the patch does, right?  Could you
>>> tell us more about the specific situation?
>> We have some cpu-less NUMA Nodes, the memory are hotpluged in, and the zone
>> is configured as ZONE_MOVABLE to guarantee these used memory can be migrated when
>> we want to offline the NUMA Node.
>>
>> Generally tasks doesn't configure any mempolicy and use the default mempolicy, i.e.
>> allocate from NUMA Node where the task is running on, and fallback to other NUMA Nodes
>> when the local NUMA Node is below low watermark.As a result, these cpu-less NUMA Nodes
>> won't be allocated until the NUMA Nodes with cpus are with low memory. However, These
>> cpu-less NUMA Nodes are configured as ZONE_MOVABLE, can't be used by kernel allocation,
>> leading to OOM with large amount of MOVABLE memory.
> Right, this is a fundamental constrain of movable zones. They cannot
> satisfy non-movable allocations and you can get OOM for those requests
> even if there is plenty of movable memory available. This is no
> different from highmem systems and kernel allocations.
>
>> To avoid it, we make some tasks binds to these cpu-less NUMA Nodes to use these memory.
>> When these tasks trigger OOM, tasks that don't use these cpu-less NUMA Nodes may be killed
>> according to rss.Even worse, after one task is killed, the allocating task find there is
>> still no memory, triggers OOM again and kills another wrong task.
> Let's see whether I follow you here. So you are binding some tasks to movable
> nodes only and if their allocation fails you want to kill that task
> rather than invoking mempolicy OOM killer as that could kill tasks
> which are not constrained to movable nodes, right?

Yes. It't difficult to kill tasks that use movable nodes memory, because we have
no information of per-numa rss of each task. So, kill current task is the simplest way
to avoid killing wrongly.

>
--------------6QYWoRFXfZXRlUJMdyuQSYUt
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
    <div class="moz-cite-prefix">在 2025/9/5 16:08, Michal Hocko 写道:<br>
    </div>
    <blockquote type="cite" cite="mid:aLqadzgmyGGjSck6@tiehlicka">
      <pre wrap="" class="moz-quote-pre">On Fri 05-09-25 09:56:03, Jinjiang Tu wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
在 2025/9/4 22:25, Michal Hocko 写道:
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
        <pre wrap="" class="moz-quote-pre">
We have some cpu-less NUMA Nodes, the memory are hotpluged in, and the zone
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
      <pre wrap="" class="moz-quote-pre">
Right, this is a fundamental constrain of movable zones. They cannot
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
      <pre wrap="" class="moz-quote-pre">
Let's see whether I follow you here. So you are binding some tasks to movable
nodes only and if their allocation fails you want to kill that task
rather than invoking mempolicy OOM killer as that could kill tasks
which are not constrained to movable nodes, right?</pre>
    </blockquote>
    <pre>Yes. It't difficult to kill tasks that use movable nodes memory, because we have
no information of per-numa rss of each task. So, kill current task is the simplest way
to avoid killing wrongly.</pre>
    <blockquote type="cite" cite="mid:aLqadzgmyGGjSck6@tiehlicka">
      <pre wrap="" class="moz-quote-pre">

</pre>
    </blockquote>
  </body>
</html>

--------------6QYWoRFXfZXRlUJMdyuQSYUt--

