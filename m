Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6E5BCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 11:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF3346B000D; Mon,  8 Sep 2025 07:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCC356B000E; Mon,  8 Sep 2025 07:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C08778E0001; Mon,  8 Sep 2025 07:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B065E6B000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:07:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 515D311B252
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:07:53 +0000 (UTC)
X-FDA: 83865808026.16.81A0DC0
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf01.hostedemail.com (Postfix) with ESMTP id F08C940014
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:07:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757329671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9DJh/PA4q4+ObKVmprXH0NoXkk36iB8jeDWGoTQj/SA=;
	b=iGijGkEUBk5WePdUCTnS1fy4QOZDGOX4h9qZ+v0UuKQudAegqCO3nR0PcM/x66u10oeVFA
	QivIJInOXehbU0JlkfbWMsFQ8ckR9WiodOnmjkw4nrUAV8ro75hkFPyy3xpcDELkfrpzgl
	7znHISZq4xAHQ7ilklbufCTtbU/MZp4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757329671; a=rsa-sha256;
	cv=none;
	b=n4uBff8im8HKD8qDggl14/cyFyNJ/hlzTvYDxJnFJ3NjaovsyjSLVQnhebMyCRSrQM/Q+X
	fMMw2d/j1+8LQdC2ziQ4pO5KSUxbt1WnTdgmtE/px2Spqkvv2yNHCAWdo88QGoIGWZt4vW
	+SSjnjAMtu7ROjWzQ6Z5tNGfJPEt2UM=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cL3xX1YzBz24jCF;
	Mon,  8 Sep 2025 19:04:32 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 2DF7418005F;
	Mon,  8 Sep 2025 19:07:45 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 8 Sep 2025 19:07:44 +0800
Content-Type: multipart/alternative;
	boundary="------------A9rDRIXDBV3Qwp5MpBa0syLK"
Message-ID: <ffb328a4-c52b-42be-a2c9-aeb2e5a00fcd@huawei.com>
Date: Mon, 8 Sep 2025 19:07:43 +0800
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
References: <aLmhbjtF0Sp75XXE@tiehlicka>
 <f088cdda-9799-43ef-a4f0-fba563be4076@huawei.com>
 <aLqadzgmyGGjSck6@tiehlicka>
 <87e085b9-3c7d-4687-8513-eadd7f37d68a@huawei.com>
 <aLqo9NKQ-xDfJ-14@tiehlicka>
 <69180098-9fcf-44c1-ac6b-dc049b56459e@huawei.com>
 <aLqwcXHzsaTxN3dM@tiehlicka>
 <8616715a-fa08-47d1-bee2-2608a5c4d9f3@huawei.com>
 <aL6JzhRjQWFQB0DI@tiehlicka>
 <47c4e0c9-9719-4dae-94c8-3a1863b1b321@huawei.com>
 <aL6dtpEQL1A_PcOh@tiehlicka>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <aL6dtpEQL1A_PcOh@tiehlicka>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: ee1z6m9ujzf8df7dspw9y1khx6ag863t
X-Rspam-User: 
X-Rspamd-Queue-Id: F08C940014
X-Rspamd-Server: rspam01
X-HE-Tag: 1757329669-484448
X-HE-Meta: U2FsdGVkX18kFPU80xafIpBl734+KfgxEAjcuSw1m6cmZdHNRplU6RHKbEKxOZ24yb3xhZ/FwwBspiAHRgq0pCgXHK9fZWghh1SisI6BD+SJG4vWTDO4J3Be/gFhu4SX5QpmfGGKWXwBYHABzIf+k5/YikWmkwo+xVWi51CvNbq+m7XnxhNz5+Z6Tgrs0OWjegjPGwvuz6j42ZAN8ukE0gfmmkbWsdw8KSKvUz3HKD55TjZz2qUMhezv5qTgKaPjog+NDlhTVw98HCA80mC5Cy64OwpSrN5cQljBU24jlK5yRTQb91HXIkKn3Qyt1jW++gQ6oPl+DyTiBhU+If9d9ZgQn7ebJnrRi2XlCMTZgUFTFGAfvB3nrefNzJoBgi0sY+2S73yNtMzMiRlAXr0uL6B5QPFBIQaCoY/okgF3iMXKxuyvq4Fiuo1sZC90+3W6JV47dkOfFM0d7Pf/Y9NCSaWN2iWZEOU3JM/kF7MK1cbltRY8GJXWjq6Mg2SCRLp94lSXN9HwQu5ti7zzNIMPZmqP6csYnPd7ZOH159z/Mvaq1aPZQoVLa1DOqDrdMZDluT0PZkK8ZXe7SRCJq6xNLtb8N8U3FpD/UDwDvtyU/CTtZjRLGCbBtRAIDQq18ezTk2rtReVyJU9c57t9CKGMqJ9YTDNIau/nNEs7gY5jfSJ16B0Pmcwr2gjWq3QXDmNCaoJXgP+zrlI5kG22bk9xR48WfnKqyNq/o0yVHHIhasOMVONP2WlnbeBusAHggELEvDlEm9GZkPqFv29wpDpJSNKWdliF54bGuyn/CwcsfyuaLv8nAtsuSoK5pXl0seo9AyeMSHXBHF+MhOFsgZBO5pHahUmPB5ioPD2CNxNLfF150o4nvoYcdDijIMjuQFZa7AEsCkp9PTjcWe0sFAxKrBGWhnUIzmFX8jsxkAQBIbyhBrrRA63E2Ch1L0Zn+QWDfB0rUbCImhTRVPzLQzx
 AavIMd90
 fQKFCfD2LcUNYaY0BZsE8MkmqvGmysTDJHY4G1w++gq+N2rhXLDOfknxkEUHYo35vQvTiLR+KJXC3XE2X/SJYrcGYOZHRUIa5LlhtSVsDPi7PycHcNcnge6GIRPNNxmiCioRLgCOVQEiGKnubkwnxGuw95/0YAi+XJa3un+tHUQnZtZ7PG3IwuXJfwtWSFJoNZHf9CKvaiLGQDjoPqYXrG17Eh8PxKvlg92c+SbYeXRfzLPePFufbRXy6hLHj7WXTiu0AOGKhpfWpE/neIDWuqkABUYoHcSLtYRiYsaWF3pIh1HmXvIlT89YxKpMXr3SvfCcYgnZx23AK0zT9BXXxI0E7/GTIsPv7MHfpr1W8saNoUQHLSzk9KrSA8oGClPXEh2NpLGB1AKTHgKF19GEpu5tA6qcBGkdAYsLmSobHNKOqQWw6DYeinCxmt0yS/MuMiQ7FX2wJ6Mc+1fG1UCrt/n6ycw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------A9rDRIXDBV3Qwp5MpBa0syLK
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/9/8 17:11, Michal Hocko 写道:
> On Mon 08-09-25 16:16:38, Jinjiang Tu wrote:
>> 在 2025/9/8 15:46, Michal Hocko 写道:
>>> On Sat 06-09-25 09:56:16, Jinjiang Tu wrote:
>>>> In our use case, movable nodes are in all cpusets, so that movable nodes can be
>>>> used by all tasks. Even though we move tasks into cpusets that only allow to allocate
>>>> from movable nodes, oom_cpuset_eligible()->cpuset_mems_allowed_intersects() returns true for
>>>> all tasks.
>>> Right but this is because you allowed _all_ tasks to allocate from those
>>> movable nodes so why would that be an unexpected behavior?
>>>
>>>> Maybe when oc->nodemask == movable nodes, only select tasks whose mempolicy intersects with oc->nodemask.
>>>> Like the following:
>>>>
>>>> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
>>>> index eb83cff7db8c..e56b6de836a6 100644
>>>> --- a/mm/mempolicy.c
>>>> +++ b/mm/mempolicy.c
>>>> @@ -2328,6 +2328,9 @@ bool mempolicy_in_oom_domain(struct task_struct *tsk,
>>>>           if (!mask)
>>>>                   return ret;
>>>> +       if (!nodes_intersects(*oc->nodemask, node_states[N_CPU]))
>>>> +               ret = false;
>>>> +
>>> Nope, this doesn't really make much sense TBH. I believe you should stop
>>> special casing cpuless nodes and look into the actual configuration and
>>> check how to make cpuset based OOM tasks selection. Your underlying
>>> problem is not about no CPUs assigned to a numa node but an allocation
>>> constrain based on movability of allocations so you need to find a
>>> solution that is dealing with that constrain.
>> Many tasks are in the root cpuset, systemd for example. The root cpuset
>> contains all nodes, we couldn't exclude cpu-less nodes.
>>
>> If we reply on cpuset based OOM tasks selection, tasks in root cpuset may
>> still be selected.
> If you start by killing tasks from the cpuset of the currently
> allocating task then this shouldn't really happen, right?

Yes, indeed.

--------------A9rDRIXDBV3Qwp5MpBa0syLK
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
    <div class="moz-cite-prefix">在 2025/9/8 17:11, Michal Hocko 写道:<br>
    </div>
    <blockquote type="cite" cite="mid:aL6dtpEQL1A_PcOh@tiehlicka">
      <pre wrap="" class="moz-quote-pre">On Mon 08-09-25 16:16:38, Jinjiang Tu wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
在 2025/9/8 15:46, Michal Hocko 写道:
</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">On Sat 06-09-25 09:56:16, Jinjiang Tu wrote:
</pre>
          <blockquote type="cite">
            <pre wrap="" class="moz-quote-pre">In our use case, movable nodes are in all cpusets, so that movable nodes can be
used by all tasks. Even though we move tasks into cpusets that only allow to allocate
from movable nodes, oom_cpuset_eligible()-&gt;cpuset_mems_allowed_intersects() returns true for
all tasks.
</pre>
          </blockquote>
          <pre wrap="" class="moz-quote-pre">Right but this is because you allowed _all_ tasks to allocate from those
movable nodes so why would that be an unexpected behavior?

</pre>
          <blockquote type="cite">
            <pre wrap="" class="moz-quote-pre">Maybe when oc-&gt;nodemask == movable nodes, only select tasks whose mempolicy intersects with oc-&gt;nodemask.
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
</pre>
          </blockquote>
          <pre wrap="" class="moz-quote-pre">Nope, this doesn't really make much sense TBH. I believe you should stop
special casing cpuless nodes and look into the actual configuration and
check how to make cpuset based OOM tasks selection. Your underlying
problem is not about no CPUs assigned to a numa node but an allocation
constrain based on movability of allocations so you need to find a
solution that is dealing with that constrain.
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">
Many tasks are in the root cpuset, systemd for example. The root cpuset
contains all nodes, we couldn't exclude cpu-less nodes.

If we reply on cpuset based OOM tasks selection, tasks in root cpuset may
still be selected.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
If you start by killing tasks from the cpuset of the currently
allocating task then this shouldn't really happen, right?</pre>
    </blockquote>
    <pre>Yes, indeed.</pre>
    <blockquote type="cite" cite="mid:aL6dtpEQL1A_PcOh@tiehlicka">
      <pre wrap="" class="moz-quote-pre">
</pre>
    </blockquote>
  </body>
</html>

--------------A9rDRIXDBV3Qwp5MpBa0syLK--

