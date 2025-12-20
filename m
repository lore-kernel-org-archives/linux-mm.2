Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C61E668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 06:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 482906B0088; Sat, 20 Dec 2025 01:50:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EBF56B0089; Sat, 20 Dec 2025 01:50:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EE4C6B008A; Sat, 20 Dec 2025 01:50:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FE236B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:50:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88682B6A42
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 06:50:06 +0000 (UTC)
X-FDA: 84238924812.06.8BB6FFB
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9D20F140008
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 06:50:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5qGuPM7X;
	spf=pass (imf26.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766213404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a98wO/0A+FNtihODenK7+CyxvgH+njrZmDp+u9ICXto=;
	b=h8yrEteURt7fmNdzZQAKAKZ2GNiXQRjVmgQ+sD0rs5kacO7DAOW5SmkT7UTDFpPmgE3bgQ
	/ZVjP1uJ2lkPr2Hq7t/OqZ/1TaoytQ6aOrQVR1QFIQK7aynzWitWUer+B7F28cdetCpn+w
	eWh5mosK3GUPtv4K8scKFK+iRbEIA+w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5qGuPM7X;
	spf=pass (imf26.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766213404; a=rsa-sha256;
	cv=none;
	b=SJNsxOp5XL79mTuiVNVz1WU5vN8TT8l1G7jYKf2NACvEyeujci+g5YEmBNA+DrupS0xooK
	3J6SXA7wDlYBVU9Z+SgEqxjWfZcO8sWvEY8PA8NbebAlqrW3JCioyGOdihrPgC9uy7O5rO
	J3ho2PDpbj6EzeQEFmhjF4ehx02l1F4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=a98wO/0A+FNtihODenK7+CyxvgH+njrZmDp+u9ICXto=;
	b=5qGuPM7XRTHlZ4hSLD8zihFpysjslbR4DGa9yFFLGMyy8Uz71Ot38ehwd+bgK6MJ7zJ4w0tv5
	PTiTGnJc2j1UIGFU3RtSv8TK2omenw/r/Mty4nOeKDD883IMtvBwb+5wW1eAILdIYsIhoAD0IYB
	a2fylz5kmj+O5jhU+RrLJoU=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4dYFLf2vt7zRhRM;
	Sat, 20 Dec 2025 14:46:50 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 3361D40363;
	Sat, 20 Dec 2025 14:49:55 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 20 Dec 2025 14:49:54 +0800
Message-ID: <1dda4952-c86a-4171-ad7d-6710bdad83c7@huawei.com>
Date: Sat, 20 Dec 2025 14:49:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
To: Gregory Price <gourry@gourry.net>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <david@kernel.org>, <ziy@nvidia.com>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<ying.huang@linux.alibaba.com>, <apopple@nvidia.com>, <mgorman@suse.de>,
	<linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>
References: <20251213082911.1509735-1-tujinjiang@huawei.com>
 <20251214160459.1c9d9cfdec4088097ff6d713@linux-foundation.org>
 <aUWljnUzmeofr7Oe@gourry-fedora-PF4VCD3F>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <aUWljnUzmeofr7Oe@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam02
X-Stat-Signature: i5cgbn45rek8gtesozb7g5bhhfjaxmes
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D20F140008
X-HE-Tag: 1766213402-787234
X-HE-Meta: U2FsdGVkX1/iYNYJxTbxSDMnVs8xJ44iPnv+YtHk4hFwYhp2LIRcfx7Eg4hmW4EAWZP0AdwSI2gDwzayp6Lmhyhdi1C7lNhwYW/n6Jxh7nmyDJq2ouSk6h2QABdEznHgQAn44l+0upBqtszeM1BD7DdJdWZru4nTnEmB300LOAb3qBZBbz2ws1kYrLUsExBjoy4ulEkDpVSBr1U2Qf4k4JlQL4QXXssTvmq/BVSPJvDJ66QpexMzrEtqBlQHfrJS63SmIb+jNs8DhtrQi1LccjrN8Uk6YcUzxQVctBQw7bY6TCLBCVEgYu9w6WBath265CyOWYgp35hov9XytZYlsgd8DEltWaEFuIG+8V02TRz3OZKqbSNQ8uKkrRvZGE0C7HwAwbU3ZyW6cSU1x3uWBn6oPyE7FCGZw1+S6H7p0qKYLMA2nFkU6HQzC/rnPRnDVsC9gQ7qs+LKgQ1aII5Sg83s5XQXGoXfjLooyw8tY10x2jIk9SdwDkaPKHQd9GubIFs5GuYNc2OK0RU6LBiZuJDu4cg6AFBYsbq42zvJMtGgYIeF+TzTX5hY5hTgegk0HY3QnTeGa4YbaovwbSbr/uapY9fQyCs7aPrjF5M4FT/SM804qIMjAc8lMf9AtBx0p/l+vPsu2PeMvl0Q80VGzYHzauYSNJoFVqGnC24rOXztSMackI69/rLwGJRDlxJmwu0DTykPMwgh7dHClTabAsnhb8HqQHw9FcsdQQAA+FaB8daaJ9VmKUJRAxZ5UP0y4oFVZfatM0dFz+2VpT8XN2JgHATpV+ECnI22EconHzr03rEIqHJG8Gkk/pJTyH5whxs6ml+pf+jL1mfrcZUuX3cb+5v5WOR1JvpzkoQS3PU375l18prcO1emB6lvg7kdG3CrczR8PM2yCNVhLnOPyRcTO4EvxwyKj3d75I5oQQpZRzHMLBUU4J+rKK3PuoM/iTgTd/MYrdCIw7dr00u
 9lQFoC+4
 /t48HBZku1WvhVHM62uj/XR9wE1zG6Ccn/tVMq2xwiVn2BbPS65Uj35MvCSlFKmkUGYrPzXIZ4ImEhGgcpyRRcKFZiDYmmW+7jwz51tKXlWg6iJTRN9ueSZswhxzQxb9DUt0ZGPBNxa1c3o4jTIIZgtoNGPUOICilRvFAKxZEHvdbnlLz/Hg5PzZw8ZG37z5pHSto54gYLKUgNz/2ELHbNq0qWuWzBKK9slWXiN2WFqwdDx7xLvnyWqmazF4IJWLFxRpVFdEUQJ/4gNg4058c2pYJ39Un/Ng/cYBvvosU2Y6kHXkeIjqEHBBvRZBcqE9VqvTTeI4tLHG2IN6IeqpEQ5SwRgqJ1+Rrk2EW87ez2SnAJeEUgUVkcqCFq5H1ko8fLLNT/IFdEOhRuiGHkQVdM03d/PSRNvSHea239C+obydI59fXI4A6ZbbMLPWb0w6qbLqzlvYTqA/R4UxjlVQAkR2UGo20xY4aGBs/trxYaXDz0vU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/12/20 3:20, Gregory Price 写道:
> On Sun, Dec 14, 2025 at 04:04:59PM -0800, Andrew Morton wrote:
>> On Sat, 13 Dec 2025 16:29:11 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:
> ...
>> The intended behavior was for the rebinding logic to remain the same as
>> the default `MPOL_BIND` behavior.  However, the function
>> `mpol_store_user_nodemask()` was incorrectly returning `true` for
>> policies containing `MPOL_F_NUMA_BALANCING`.
>>
>> This led to a bug where:
>>
>> 1.  `mempolicy.w.cpuset_mems_allowed` stored the **user's passed
>>      nodemask** instead of the actual nodemask allowed by the current
>>      cpuset context (`cpuset_current_mems_allowed`).
>>
> Hm... these things are a union.
>
> It's probably simpler to state the following
>
> ----
>
> Setting MPOL_F_NUMA_BALANCING causes pol->w.cpuset_mems_allowed to be
> erroneously overwritten, causing mpol_rebind_nodemask to rebind the
> policy based on the wrong nodemask.
>
> 1. The intended rebind behavior of MPOL_F_NUMA_BALANCING when neither
>     MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES flags are present is
>     to remap nodes based on mempolicy.w.cpuset_mems_allowed.
>
> 2. `mempolicy.w.cpuset_mems_allowed` is overwritten by mpol_set_nodemask
>     setting `mempolicy.w.user_nodemask` (these are unioned) when
>     MPOL_F_NUMA_BALANCING is set because it mpol_store_user_nodemask()
>     check for any mode flag.
>
>     union {
>         nodemask_t cpuset_mems_allowed; /* relative to these nodes */
>         nodemask_t user_nodemask;       /* nodemask passed by user */
>     } w;
>
>     static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
>     {
>          return pol->flags & MPOL_MODE_FLAGS;
>     }
>
>     static int mpol_set_nodemask(...)
>     {
>          if (mpol_store_user_nodemask(pol))
>                  pol->w.user_nodemask = *nodes;
>          else
>                  pol->w.cpuset_mems_allowed = cpuset_current_mems_allowed;
>     }
>
>
> 3. `mpol_rebind_nodemask()` consequently ends up rebinding based on the
>     user-passed nodemask rather than the cpuset_mems_allowed nodemask
>     as intended.
>
>     static void mpol_rebind_nodemask()
>     {
>          if (pol->flags & MPOL_F_STATIC_NODES)
>                  nodes_and(tmp, pol->w.user_nodemask, *nodes);
>          else if (pol->flags & MPOL_F_RELATIVE_NODES)
>                  mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
>          else
>                  nodes_remap(tmp, pol->nodes, pol->w.cpuset_mems_allowed,
>                                                                  *nodes);
>         ...
>     }
>
> To fix this, only store the user nodemask if MPOL_F_STATIC_NODES or
> MPOL_F_RELATIVE_NODES are present.
>
> -----------

Thanks for review, I will update the changelog and send v2.

> On another note... what's even the reason for this union to exist if you
> need to know the flag state to determine which one to access????
>
> and they're both nodemask_t!
>
> May as well call it `pol->w.rebind_mask` or something and let the flags do
> the talking.

Yes, the only difference is which type of nodemask is stored.

> Otherwise the fix looks good, I will respond to the original with a
> review tag.
>
> ~Gregory

