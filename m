Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C829ACA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 08:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F1E38E0008; Mon,  8 Sep 2025 04:16:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CC688E0001; Mon,  8 Sep 2025 04:16:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206D78E0008; Mon,  8 Sep 2025 04:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8858E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:16:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F4C711B1A9
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:16:46 +0000 (UTC)
X-FDA: 83865376812.28.C5218B4
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1067018000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:16:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757319405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Y5slMggn0tOdlu14YDvFjj2GD+ZJkthgS2YfyV+RAA=;
	b=W3J7lhCVkgvDiaYYOL14hvFkpJNsSZdXhDhfnppxekqw+xxnsEgr1jo4D2OOi0Z/VEONti
	WQsIERCk2R61PV98gr/4p+43HS6cJUSxDLrxdxEskjzDpso2fwb6AvKdRmlCmeg3N7swPT
	uqQ5/2knmtkS7nLa8amS8Hr9RM2vhQQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757319405; a=rsa-sha256;
	cv=none;
	b=5FQKkyInD1OXKZv+vwoZiqRd3f87R/Ho7sFT83UAQFZb9AUBBYVWuiN6oIdrLQ85thDK44
	P81E0CsCf9SXnmMVJ7TWysfP9xP3G94JQMX2Sag+VOUR/wgMZvPQsU+Q6hbODqKhN88sEU
	8cPJo0+nFiY+JeCND6Yi4oxBdyyxA8c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cL08L3Wmyz1R9KQ;
	Mon,  8 Sep 2025 16:13:38 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 188FB1A0190;
	Mon,  8 Sep 2025 16:16:40 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 8 Sep 2025 16:16:39 +0800
Content-Type: multipart/alternative;
	boundary="------------Xkb4o0TWiUZ6nJ2g3DwV60eq"
Message-ID: <47c4e0c9-9719-4dae-94c8-3a1863b1b321@huawei.com>
Date: Mon, 8 Sep 2025 16:16:38 +0800
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
 <8616715a-fa08-47d1-bee2-2608a5c4d9f3@huawei.com>
 <aL6JzhRjQWFQB0DI@tiehlicka>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <aL6JzhRjQWFQB0DI@tiehlicka>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1067018000A
X-Stat-Signature: r37yk6pb9udfjsmobqy4mf9r5e193897
X-Rspam-User: 
X-HE-Tag: 1757319403-385492
X-HE-Meta: U2FsdGVkX192K6SSKF1Spn1Kzh9u7CwpFHf3+mfMN00IvhJa3pnJBG/Bni+FZbuiLWjfRisgKU65tjIHbKGNUgrCqIkOdvcLwAA56n2+iVqT+N0Nwgc/rUqWLPqjBzp199SQt3rZc82SiojRVhwuDxS5g6mvVdgqU1OgIo03XxPT5Ef2h0oQ82Xlg8FK7h1tsFL+eqp7Pi2QDbXy4WQb4TRJCWtkmNPgICvak31gD1vXgxQBu0vWtIVAS5gQXmKqfV/BUGBZZveE9uXVfeMkrWjf68KBc2ky8ZAigMdtzOvpT6lBvkPuaGt1aS7GuBpcYPtlOuEzrV/Yf+loJFG5EpgreTCaubx5T+XrfJjlK06K5eTOXsc388lDo9fmoIBx3TDMymB9eMBYshhe4BMhEK/SDuepCEZlwkmOXUxLLI4Acc6oUysDa2Dmf4AJmvZAXHxPBNqlr0JDT8Etws3Vwodc2SnjAJl0QBa4U9/3NVIdvxJq0eV2kSERUTwHyOnmGqs5nmIVD3HIL4BJdMjrx57dPRn860WKA9w/s995rI+S15RKiXWQcW37dIdqg/ppcVGePEqaa5y8BPbLS/JuCy+Oc3IoE8Hxm/kFUpLR3EjmNfz6yunH163g7KnKT2aNbAo/pmhkj9o2yADIApe9wFbBrgVomVuPbMgJSp9wXSxRGajFhHrG8opksdTwy7ajw/TlPBO1gUMBGvmIr5NfyQZYkiAsQVN8Ujq4f7F2WYluBcIxdQnoG6qjbgWytk2R9/DqCwtU7bujG59mmSli5wHC6VhZN+le6EfREBhjxCdqQWw4nYHKyTYeoi5E4Ymr/fvJByH+s3OEMAZmPR5XzqhUFOOIWkmJD/+H86jBc+DLuO0l28E4au2YhPZNLt93lYK16bPr9/N4+2TX/wdRbT68VUmALN9qpBcH/jrEEAfn7SrCWbfqdtk4+J2VYwFNT+2fzxFEuE4gGZ7t2gs
 yZOFJLBv
 PQOh8jDLyDaQ+UdXwAP9htQh1570/O9ODUl1Pbg3wKmcPNm+bwBktoxo9Y3eFFL2OMayLJpheFOGwFL84eEfN6Jjah2nowEnaQtHkaPb4l0l8F56F/fx/ttiJZOHDxbLdy84c/xPd8T7fjhzNOAZh/Q/yY7Z2Y9xhzDS9lfsbVf7WOQyx3pmVaNBCLdSbizWn3sNjyS9CAtmh08v2K/LOm++kZC4ki4hBVNBlYX/DniwtZOOoAALeUOhcwy1q0OYp4V62FVpLqOl90KPu1i/G0c5qhbTuIaGvln9Ic3qMVVjClhtt9A+vmsELBh4KA5fZCVmDreyiayDP+BAlHKLjPr3ax+hS+RNtFm7BGn9wWHkwW9A7TNnV0xeqi8MtyqDoNK995Fin8u1m0gEL807wwx1BtRQI1z1IrwXPU4QY7mT3OYcYUGd4F+tpdLqvwSK+2XuofOq7JhMlZwODP/8q5pHKr0JL9yPzcCYlC5ZFzL39Rd8Zx9d4EVt18w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------Xkb4o0TWiUZ6nJ2g3DwV60eq
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/9/8 15:46, Michal Hocko 写道:
> On Sat 06-09-25 09:56:16, Jinjiang Tu wrote:
>> In our use case, movable nodes are in all cpusets, so that movable nodes can be
>> used by all tasks. Even though we move tasks into cpusets that only allow to allocate
>> from movable nodes, oom_cpuset_eligible()->cpuset_mems_allowed_intersects() returns true for
>> all tasks.
> Right but this is because you allowed _all_ tasks to allocate from those
> movable nodes so why would that be an unexpected behavior?
>
>> Maybe when oc->nodemask == movable nodes, only select tasks whose mempolicy intersects with oc->nodemask.
>> Like the following:
>>
>> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
>> index eb83cff7db8c..e56b6de836a6 100644
>> --- a/mm/mempolicy.c
>> +++ b/mm/mempolicy.c
>> @@ -2328,6 +2328,9 @@ bool mempolicy_in_oom_domain(struct task_struct *tsk,
>>          if (!mask)
>>                  return ret;
>> +       if (!nodes_intersects(*oc->nodemask, node_states[N_CPU]))
>> +               ret = false;
>> +
> Nope, this doesn't really make much sense TBH. I believe you should stop
> special casing cpuless nodes and look into the actual configuration and
> check how to make cpuset based OOM tasks selection. Your underlying
> problem is not about no CPUs assigned to a numa node but an allocation
> constrain based on movability of allocations so you need to find a
> solution that is dealing with that constrain.

Many tasks are in the root cpuset, systemd for example. The root cpuset
contains all nodes, we couldn't exclude cpu-less nodes.

If we reply on cpuset based OOM tasks selection, tasks in root cpuset may
still be selected.

>
>>          task_lock(tsk);
>>          mempolicy = tsk->mempolicy;
>>          if (mempolicy && mempolicy->mode == MPOL_BIND)
--------------Xkb4o0TWiUZ6nJ2g3DwV60eq
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
    <div class="moz-cite-prefix">在 2025/9/8 15:46, Michal Hocko 写道:<br>
    </div>
    <blockquote type="cite" cite="mid:aL6JzhRjQWFQB0DI@tiehlicka">
      <pre wrap="" class="moz-quote-pre">On Sat 06-09-25 09:56:16, Jinjiang Tu wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">In our use case, movable nodes are in all cpusets, so that movable nodes can be
used by all tasks. Even though we move tasks into cpusets that only allow to allocate
from movable nodes, oom_cpuset_eligible()-&gt;cpuset_mems_allowed_intersects() returns true for
all tasks.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Right but this is because you allowed _all_ tasks to allocate from those
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
      <pre wrap="" class="moz-quote-pre">
Nope, this doesn't really make much sense TBH. I believe you should stop
special casing cpuless nodes and look into the actual configuration and
check how to make cpuset based OOM tasks selection. Your underlying
problem is not about no CPUs assigned to a numa node but an allocation
constrain based on movability of allocations so you need to find a
solution that is dealing with that constrain.</pre>
    </blockquote>
    <pre>Many tasks are in the root cpuset, systemd for example. The root cpuset
contains all nodes, we couldn't exclude cpu-less nodes.

If we reply on cpuset based OOM tasks selection, tasks in root cpuset may
still be selected.</pre>
    <blockquote type="cite" cite="mid:aL6JzhRjQWFQB0DI@tiehlicka">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">        task_lock(tsk);
        mempolicy = tsk-&gt;mempolicy;
        if (mempolicy &amp;&amp; mempolicy-&gt;mode == MPOL_BIND)
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
</pre>
    </blockquote>
  </body>
</html>

--------------Xkb4o0TWiUZ6nJ2g3DwV60eq--

