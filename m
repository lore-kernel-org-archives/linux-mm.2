Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E49E0CA1012
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 02:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3936C8E0007; Thu,  4 Sep 2025 22:06:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316548E0001; Thu,  4 Sep 2025 22:06:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DCEF8E0007; Thu,  4 Sep 2025 22:06:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 094D38E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 22:06:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8269013B92C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 02:06:09 +0000 (UTC)
X-FDA: 83853556458.16.3359587
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf24.hostedemail.com (Postfix) with ESMTP id 166B1180015
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 02:06:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757037967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AO1WLbBXhXDEBDlG28mbWOsNvsj7fU4e+ZpHr73oQdk=;
	b=qiMRdDpXT5C3FZY2/K7PD1WYL7fv+BWDEQKNWtAt5I0chKbM4k9uu9U4EWIxzOTuszpT6X
	3MCo0fyUJkkibI9mlW1gPrp88zPCJMsajY4KeBm8mwjvZ08LJaNyzCmk+aIi3YIndRcs7y
	wyRR21ckAec2CzRzTDK8Qg3JNDex6JU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757037967; a=rsa-sha256;
	cv=none;
	b=cRbZ1a1dIBP1njVCk+52m2qk4LkQb0XegNhjxkibS7UIxG5yIzwSIAbB8/gF/ihkIBXe76
	JJLUSPuwr1vSzzrEuZiZhn7dqPoAikHW7eFwBAHkM6zPyGe4xFC1Yu4U4sYogQamKP5/1a
	1EhAJKrcN1hutfBZ1pdTCmoFkJ9BAVo=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cJ06c24sjz14MWm;
	Fri,  5 Sep 2025 10:05:12 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 1F1DB180B53;
	Fri,  5 Sep 2025 10:05:23 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 5 Sep 2025 10:05:22 +0800
Content-Type: multipart/alternative;
	boundary="------------UjbJoeHXv78iDT540rUJcIhn"
Message-ID: <686cf134-7682-4871-a561-b8dba019f5ce@huawei.com>
Date: Fri, 5 Sep 2025 10:05:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/oom_kill: kill current in OOM when binding to cpu-less
 nodes
To: Joshua Hahn <joshua.hahnjy@gmail.com>, Michal Hocko <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>
References: <20250904144301.1224021-1-joshua.hahnjy@gmail.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20250904144301.1224021-1-joshua.hahnjy@gmail.com>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 166B1180015
X-Stat-Signature: dgkf3915s4zrjbh3ykfrjeipb496t1dc
X-Rspam-User: 
X-HE-Tag: 1757037966-262931
X-HE-Meta: U2FsdGVkX18pL+Xkn6wc65YRTHd9UJoy345IIPJROIyf4HYoe+SVSWVup6in8mQhspaOgcRftiknd10i5uz/i76S6Vi3qntHv210tFMiACs+KmcXc3YAg6pQJFvLHv/rpev2yViIPkO5sD2HCxlNHPxRncTrURaLZENK10IE76H4DlUruiUWs2sCyntiTRvIF8l6wDzLvCN+C7FJ1WdlQ48uBfaZndL8p5IFpH/oZjt7CX2Ocx2Qpb6LLGxv97f4SkVnnk/bRKbwAQgUw/vxY0y9MSs9o7a4BqUcVPyqdfnEvTDnbA8ETIC+ySV5+FT6Ug6CE4ppNB9Z5Gu6NH3ptM+xPPwslQSGIzmOrc7C13vk0zTV5oAtZHzv+XE9ivPgswaIy/xDXWvy2+yE4Wy7Uz6DGOMiDeW0S3Vw3nZDUJAslJEQTygWW/sZfcb8AChLH04S1WTclYZc4NNPo3A4OGC8UsZjHoveI1gqs+YMAXc75A1fQJ/B3A7HzFEXS4e6iXkJi2eGZIwrM8J53DYFmtwglQoATpDV8wWgd18XVnzF/mfYTce45nvT2oiORjevo5bAdaL7DyiCCHYw3EoKLLZcajeU8rM7zE3LINjMT4t26GlbMQxmPPh/TByQAXwvNgXm4dPN2SywSqIo+tkYZWIq8S5F6Fm72JDg6ANe+a8Iw1mjBGyBaWsfZCFe2P0dZkdeFhMY53/XyXZ4YaJFEGlJ/mn02ilLR4NZFTQUYi0ZNzbl2d+kjpnGzV3s/8FCW1C5uBcwp0g/nh76M5uqRaCnB/DYkSpb+JdSIlZRS5HKLu0S74Qtq+1wiu6ARKcxqJvoW85r/H5fDIwadhqv0vFyPdApZM5T20I64CGaZEd9Nc24x/kakW7cfsCNTX9fbIHXd5nTziCSTRZsil7YEF6k76FdRSq2hVsSldAw1HzoeYcTP0xS4YfeXzPc6I28WX4uIV7zr+cC+NVy6Sm
 M9uJXkxs
 wgN4jjAAI9P/e6BG4+EBEbS78sjeHLCeoweO8tjtpiOCuoFo5gjCD6TzGvnS9dJnGUQwaP0ALvzLQgTce8WhzC6JMYgz/vzpaIjTZXe8z7Ms9+FJ60aKTS+UYp5OaI7dUQskFJZMhw51t8ElTTXUUEPMOe7bAoP94Nf+TRYSVn7QfavvqoGzDedAeeJFCIdXuRU9fWBWqSSeGM9ACiBks1+DGdUBBssxc8NKlhLZdUiIZtcnI58p0QzlG+x9QpuYb54EDnn8rgp2L1K0tkf6y0vJPbJe8e/FMvKt6g0kDEtV24jlvTy/VWDT/ZmXPM0Zcl4OQmFJ7MHwSO1TwB3EtGIeaUOdiKNhGdVe2BF9fuxClXKwknWkEHrMxUtOlcpPvC/Eahevr2DQRVyfGRPpryt+i6aaNeOYGwfFery9S1SOSnzTFHccgs2xz8XSWypkcHn1RlFreSoDejvsB4O5DPLV9m3qlBKSZHtmpekgGP1uAEON0WiUFjDsBJf1u78FNCvyhcE69rLRwz6bh+IoK+X7633BXTuKW2lDogG+rPT8FV1t56DxMERumtVOGgk4JC9YcpILmceq2PALG8fEfxyH1Rw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------UjbJoeHXv78iDT540rUJcIhn
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/9/4 22:43, Joshua Hahn 写道:
> On Thu, 4 Sep 2025 16:36:28 +0200 Michal Hocko<mhocko@suse.com> wrote:
>
>> On Thu 04-09-25 07:26:25, Joshua Hahn wrote:
>>> On Thu, 4 Sep 2025 21:44:31 +0800 Jinjiang Tu<tujinjiang@huawei.com> wrote:
>>>
>>> Hello Jinjiang,
>>>
>>> I hope you are doing well, thank you for this patchset!
>>>
>>>> out_of_memory() selects tasks without considering mempolicy. Assuming a
>>>> cpu-less NUMA Node, ordinary process that don't set mempolicy don't
>>>> allocate memory from this cpu-less Node, unless other NUMA Nodes are below
>>>> low watermark. If a task binds to this cpu-less Node and triggers OOM, many
>>>> tasks may be killed wrongly that don't occupy memory from this Node.
>>> I am wondeirng whether you have seen this happen in practice, or if this is
>>> just based on inspecting the code. I have a feeling that the case you are
>>> concerned about may already be covered in select_bad_process.
>>>
>>> out_of_memory(oc)
>>>      select_bad_process(oc)
>>>          oom_evaluate_task(p, oc)
>>> 	    oom_cpuset_eligible(task, oc)
>>> 	
>>> 	        [...snip...]
>>>
>>> 		for_each_thread(start, tsk) {
>>> 		    if (mask) {
>>> 		        ret = mempolicy_in_oom_domain(tsk, mask);
>>> 		    } else {
>>> 		        ret = cpuset_mems_allowed_intersects(current, tsk)
>>> 		    }
>>> 		}
>>>
>>> While iterating through the list of candidate processes, we check whether
>>> oc->nodemask exists, and if not, we check if the nodemasks intersects. It seems
>>> like these are the two checks that you add in the helper function.
>>>
>>> With that said, I might be missing something obvious -- please feel to
>>> correct me if I am misunderstanding your patch or if I'm missing something
>>> in the existing oom target selection : -)
>> The thing with mempolicy_in_oom_domain is that it doesn't really do what
>> you might be thinking it is doing ;) as it will true also for tasks
>> without any NUMA affinity because those intersect with the given mask by
>> definition as they can allocate from any node. So they are eligible and
>> that is what Jinjiang Tu is considered about I believe.
> Hello Michal! Thank you for your insights : -)
>
> Looking back, I made the mistake of thinking that we cared about the
> !oc->nodemask case, where Jinjiang's patch cares about the oc->nodemask == True
> case. So I was checking that cpuset_mems_allowed_intersects was the same as
> nodes_intersects, whereas I should have been checking if mempolicy_in_oom_domain
> is correct.

Most tasks don't mbind to specific nodes. In our use case, as described in the reply
to Michal, ordinary tasks are unlikely to allocate from these cpu-less NUMA Nodes.

>
> Looking into it, everything you said is correct and I think I defintely
> overlooked what the patch was trying to do. Thank you for clarifying these
> points for me!
>
> I hope you have a great day,
> Joshua
>
>> -- 
>> Michal Hocko
>> SUSE Labs
--------------UjbJoeHXv78iDT540rUJcIhn
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
    <div class="moz-cite-prefix">在 2025/9/4 22:43, Joshua Hahn 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20250904144301.1224021-1-joshua.hahnjy@gmail.com">
      <pre wrap="" class="moz-quote-pre">On Thu, 4 Sep 2025 16:36:28 +0200 Michal Hocko <a class="moz-txt-link-rfc2396E" href="mailto:mhocko@suse.com">&lt;mhocko@suse.com&gt;</a> wrote:

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">On Thu 04-09-25 07:26:25, Joshua Hahn wrote:
</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">On Thu, 4 Sep 2025 21:44:31 +0800 Jinjiang Tu <a class="moz-txt-link-rfc2396E" href="mailto:tujinjiang@huawei.com">&lt;tujinjiang@huawei.com&gt;</a> wrote:

Hello Jinjiang,

I hope you are doing well, thank you for this patchset!

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
I am wondeirng whether you have seen this happen in practice, or if this is
just based on inspecting the code. I have a feeling that the case you are
concerned about may already be covered in select_bad_process.

out_of_memory(oc)
    select_bad_process(oc)
        oom_evaluate_task(p, oc)
	    oom_cpuset_eligible(task, oc)
	    
	        [...snip...]

		for_each_thread(start, tsk) {
		    if (mask) {
		        ret = mempolicy_in_oom_domain(tsk, mask);
		    } else {
		        ret = cpuset_mems_allowed_intersects(current, tsk)
		    }
		}

While iterating through the list of candidate processes, we check whether
oc-&gt;nodemask exists, and if not, we check if the nodemasks intersects. It seems
like these are the two checks that you add in the helper function.

With that said, I might be missing something obvious -- please feel to
correct me if I am misunderstanding your patch or if I'm missing something
in the existing oom target selection : -)
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">
The thing with mempolicy_in_oom_domain is that it doesn't really do what
you might be thinking it is doing ;) as it will true also for tasks
without any NUMA affinity because those intersect with the given mask by
definition as they can allocate from any node. So they are eligible and
that is what Jinjiang Tu is considered about I believe.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Hello Michal! Thank you for your insights : -)

Looking back, I made the mistake of thinking that we cared about the
!oc-&gt;nodemask case, where Jinjiang's patch cares about the oc-&gt;nodemask == True
case. So I was checking that cpuset_mems_allowed_intersects was the same as
nodes_intersects, whereas I should have been checking if mempolicy_in_oom_domain
is correct.</pre>
    </blockquote>
    <pre>Most tasks don't mbind to specific nodes. In our use case, as described in the reply
to Michal, ordinary tasks are unlikely to allocate from these cpu-less NUMA Nodes.</pre>
    <blockquote type="cite"
      cite="mid:20250904144301.1224021-1-joshua.hahnjy@gmail.com">
      <pre wrap="" class="moz-quote-pre">

Looking into it, everything you said is correct and I think I defintely
overlooked what the patch was trying to do. Thank you for clarifying these
points for me!

I hope you have a great day,
Joshua

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">-- 
Michal Hocko
SUSE Labs
</pre>
      </blockquote>
    </blockquote>
  </body>
</html>

--------------UjbJoeHXv78iDT540rUJcIhn--

