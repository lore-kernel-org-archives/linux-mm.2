Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17951CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 11:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E7448E001F; Mon,  8 Sep 2025 07:14:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 697A28E0019; Mon,  8 Sep 2025 07:14:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5869B8E001F; Mon,  8 Sep 2025 07:14:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4298E8E0019
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:14:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D935140ACB
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:14:01 +0000 (UTC)
X-FDA: 83865823482.08.535EBDA
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf01.hostedemail.com (Postfix) with ESMTP id 690D140014
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:13:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757330039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wVO2gVoQyjqa/l3/unEbaw+vjdluhxOHuV/zNNjgsVo=;
	b=zUTpO1LNFSy9xSAPnqUzBAhPR1yXyXsUeMlTLxneOg/EYN76g8Xc4StWpKmeocmaJw8vXK
	7iz1H82dNIo6JGAMmbXOLyue4Pt9+ZSAXF0ReQj4uvcLPxoeFCerR0tq9RNujC3UsKcPaF
	2eSFvLrofmVZrFx+RmHlKSD1KKS0E3A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757330039; a=rsa-sha256;
	cv=none;
	b=CgwcZXWzZUfbzXnUCMoRfEottAUT4+badwJun7NmuLBu8otLCzcCPpyoKTMd2kzFsQ91Pp
	eQuuEGzZG1jn23Ug76zEVSWKw3ZGrDzfUBhnZ8CWur8otbipVdf8GyUTZXv/ktCv0W/Mzg
	ZtXloq1uiwQZQUxf+tBz2OCzI0zfv1k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cL47G5m4MztTbL;
	Mon,  8 Sep 2025 19:12:58 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 45A571402CC;
	Mon,  8 Sep 2025 19:13:54 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 8 Sep 2025 19:13:53 +0800
Content-Type: multipart/alternative;
	boundary="------------g9b4ckuG88as0Udku39l9OPE"
Message-ID: <ed3823fb-01fb-498e-8248-f4628d258276@huawei.com>
Date: Mon, 8 Sep 2025 19:13:52 +0800
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 690D140014
X-Stat-Signature: xxd3gyt3j9nctbph6q98fhokquxukfzb
X-Rspam-User: 
X-HE-Tag: 1757330038-428206
X-HE-Meta: U2FsdGVkX1/ecJ/dLnX+cEoOufuj8EDLj38ReUkDyKxHmUgJsnIOJ1f5jBnElOK4YhyHgf77QbA2r77YauOtkbWfitA5KZPewlSWgf1vS4p7uiOtB7cxosJM9nWvu0O4HPu1zFDpLWBHeeXmRYdmtu1HskiaLLtjnYh/DU3IS7P/3zLuF8j2ESVP5pWnwQm4Fxceu7eZ05NxJ/bBWf/uP2BbFTZ6HHr9fOH/9dy4qczm5EFtRsLDZXtcd+zjSz2Z59VZtCxNIbBxJ/FVbapQkg7T5fqleNFFR7u/1B9QHTWceQKWiwSeiBGzXFoLT5Bs0ra1aZI3KzkqzhYhvn/nhvmFt6wUWgugzt6+piQFwharcErzQx4+rTMYM6fOicFmHy9Dq7CfghF0vBcfhYOsdXRA3umCmTZ91+qsy8UIyYf22PGoROznVGtGIYzUEgtOzzCvdQG1xn7kBAE8IikULQRU7gYkNMfwl+9ZcLg5wmVBDkIljcs70YT+EYuj68zjzwnw/2jK/WI+RqJyoFhm9MWMqStYhmegQz9prOOlIfYEnyDJgaJzcvHW66SWUef4UThcPT6hdvIY703b5ymfS4ttFhP6ZqW8T0V5AnsMhusZg9QFYpHIGGh2buVym7R2OAYIL5k3fx7pgKxKW3iabtOSUpq/a80AXxhQCZfuhS+8239s765iOACouzIrU2Qcq6yig8JySZS+Cova3fJXIcxWSATLpus+P2D1abuAZ1KBvHWEaIJP4mOSX6kKl2qOr8+Gik8JHmw3W2VHtXb0DbRGY68KHoAM+xANJ9U1iK1RIYBGVa+Ax8hADQsUOwtJeJ5uOEzyRuNkA9w3Hsuy9Dlois/aJJ3Y3Zn75i2M0SMXeDa2EI+7pTBoN9A1xdxfg1iMRDlb69ga1vxBTnhn/SddZNk67G/0WYQW9u4xZQ+F6Zot1MfYUOWZRf/U8sMt3AZpePHYWLiyDv/V+pV
 dvsHiKrG
 p3CdrjFY8RVCKDgN1ZrtvHGuNMEln0YxR0RtIGH3VxPZwyVyGciSIzCbjVYN0SPwsghR939yLyfzQYuyw6xFNKGdl74/bKKh1qU1CZrNGHD96xee3uJVw+jIp4r17kFW6Sb7dwT91IY1TqYVlszqKvpPfHyvfany2uxbiDi91dESOXvPyanS/8yUajJi1PyXHHqogaWb9qoROiiDbH7ognNhs5dAZT58s+NlcVn+4kWPPvEnQeGGbFDoqh8cINbl97WNfBcuYejB/Z1n1DWkkMJn5f28n8Pw8zgNPv3PMfOAeD38zQbVsgys26CLXHTHAayPEmsiSsYKLPXU/BQYj4X3WTtzRmjz9JGDP8O8dlR2LvNbHAZyJXq47puywex8t9SvegjFELD0ODBSFdZc2JJThna+DQzmpoGNn/8hB0N7wm6lDjF52wdlzhHP2Ahw6VNkWkZNsT3mg6jlIeZj7JBh4KS0N2R7X8jKn9N5/7c+KED2dYUdSFyW/8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------g9b4ckuG88as0Udku39l9OPE
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

Do you mean we should put the tasks into the same cpuset, and then limit the max usage
of the memcg, make it only trigger memcg OOM, to select tasks from the same memcg?

--------------g9b4ckuG88as0Udku39l9OPE
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
    <pre>Do you mean we should put the tasks into the same cpuset, and then limit the max usage
of the memcg, make it only trigger memcg OOM, to select tasks from the same memcg?</pre>
    <blockquote type="cite" cite="mid:aL6dtpEQL1A_PcOh@tiehlicka">
      <pre wrap="" class="moz-quote-pre">
</pre>
    </blockquote>
  </body>
</html>

--------------g9b4ckuG88as0Udku39l9OPE--

