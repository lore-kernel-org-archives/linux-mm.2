Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C74A4D4A604
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 06:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20AD36B0088; Fri, 16 Jan 2026 01:43:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C16D6B0089; Fri, 16 Jan 2026 01:43:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118316B008A; Fri, 16 Jan 2026 01:43:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 01AE86B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 01:43:38 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BD4B8BAB4
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:43:38 +0000 (UTC)
X-FDA: 84336886116.12.3117EB8
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6F0AD1C0002
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:43:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=biHB6KGC;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768545816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARTSuV509kHUtcD5UptlNc7+P6GWfeAXeeklrMKAtP4=;
	b=6GTISvlNGoyXzWwJZSP37fU9s/ObvTDApV7DvGpdzG8jFfSTzGYlpJJWC0vE4H3o2dh0Ci
	CfFD+fVOSJOQyqpVJtM/FqLv8jUUM5yhTqL76IV+3uWRgkrFna0d9EEGft80tjmnDm/Z2h
	mrYAYol5vtDAa17YNZ1aoE0Cc7sohuA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=biHB6KGC;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768545816; a=rsa-sha256;
	cv=none;
	b=v1151iFoMlq8Usgg1oDK2qNSVp82uBxPCEGqTA34jHVzstGC0D1SH+YxXxgDl+VrykIyvQ
	YdSSMAOWtEutgE3OUirUa4OE0uA0lsEuajNOhcNWQ5wuvfJ2CMYYwg7orxn8RK/sRfO78Q
	WNtRkgo3Rn2DQSZFN8REDqcHLPx1s9w=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ARTSuV509kHUtcD5UptlNc7+P6GWfeAXeeklrMKAtP4=;
	b=biHB6KGCWlKZSC7ST1w06lO7WHI1/8kAVPtofcMw1vBRMjughgzUN0u86fxsfJf/tBi0Yseqx
	mEajjgVR8RoW35O+2Xmz4Q1ajREGGta7X22wA72vEYVckIj4ZPWFTM3RC2GLR6ikt/u9JNBBj6D
	Zzw/xo4YmJ3a486SnmqZZtk=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dsqvm1HNhz1T4G7;
	Fri, 16 Jan 2026 14:39:32 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id A6FBF201E9;
	Fri, 16 Jan 2026 14:43:27 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 16 Jan 2026 14:43:26 +0800
Message-ID: <1ad31dbd-6743-473d-9f66-a603b91d1e54@huawei.com>
Date: Fri, 16 Jan 2026 14:43:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
To: Andrew Morton <akpm@linux-foundation.org>, "David Hildenbrand (Red Hat)"
	<david@kernel.org>
CC: <akpm@linuxfoundation.org>, <ziy@nvidia.com>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<mgorman@suse.de>, <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>
References: <20251223110523.1161421-1-tujinjiang@huawei.com>
 <04b92008-f843-4879-b4a3-608cc5e1de4c@kernel.org>
 <20260115101252.2e0cbe0559e62b988e5f7151@linux-foundation.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20260115101252.2e0cbe0559e62b988e5f7151@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: hzgodhxde8cn4khe97thpat58j9m4x5k
X-Rspamd-Queue-Id: 6F0AD1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768545814-718130
X-HE-Meta: U2FsdGVkX1/DAXxPyX+0gEKLZlrMMFvErnHsU92ohkIqyAQlj8RIQ5kkC5GEdGRqScGYSr/N/3pm0FP7mqfNUwihe747efHwQi2VJt17TCuqHRxgJNvXh8YzWeOTI61GPQSql2vwiSX5aPbQWYbXXZ5+ftd8TW509IGxDmmtFZG50kEjJErTI3xXDui+95QQQBGMB1kmWAI/+az8mH8bBwIhbNr/7sh1ze8kgir9qtjx1CZfZIvo9Vnxsm3Eo5iXY5BrpWX/EACpaJKwSFd3m1pGZJbm1vafM2nHdijwkV33GSo1YrX1CvHzDK2AcWPtm3sX2wx54JX7bNNlbCJV1hl/mnG3PR8SibiIEjCLEyzN9ly4Ssmd+aSnKIpiEUc2NtKiJwCGiNIcTGbrO1fbUoSGlcre9R4UXwPSG5AXrv3gRK7EXb3fn+IADjWxzRa5ogIiWFz058cnPxBt4vSn1bSsM8qk2dDAhkVnyS4yAS7zlMJBau+TjuOxO3x7Tr4bAzSJazFnuq5MaKuRNidRNJ1zyJbW41ellDQoPdwlaYJAZcI1Xlf/A5aTcNJjamrfNBEgNXdnVBuA1YkSd+XXOtlH4pk+zRn+EedQvmaUr+o578Gai5k4B4yeZ6NlJZJbHw4LND0WE31D80yYcFV+KOilrGXlqxc/Zf0X93e6zlM/5r9MQNI+ewTmRH15JW1fZ46UT9ERNOGf7NYmhobsvOhmO0HLrL8hNALkBY7KvY73actmcd41ZGaduqMQndDU3SnDzBC6/ERGP5XBNIMi5LeFyqgv91GH7kHm66b4mqPs4lQCMqyh/3YrvmKD3JDIu7YvrflNCIYfwkivIRRHLec3SYylLToRtH5JU6oGJHghxanZIvADtJF4o0k0wo10+JUOYUZqH2C3Al0MN33Nb9hnyp1KMLoeEljEq1cypkbptBV9xOWnqmQ2YnBO5hZ8/78k5p3g7axyVh5kPO9
 3XFqcAjm
 Yo43gLbwhjr7EuwoYLrZgxSRBq4FU6uiH2RSG5AebSXdZ0+zlsrPdTuSibOkarwefhn8rIwEeL38UddBkrD1bfePzGSwd1F126yuK7r9R4+BaBS5zn1ncS6azVsjUHjujpW2BiWM7Y3o9I7JWjia4LZ4SGX6+yJnufmPibmpPTC2FF8raXIwvTfkRD343RhozSRW2RkPAlhUB/BtMWt9kqXTOmVqyOrR8vgYV/MvgWswfQGHHcdWorRSpOzxr62GXt2bo1+5HGPBDFB1FT3MG5abyNSgKPrpSow8zd1sCZXoTIwKMC+S8jpQdQbTdy3+Kbf9jPdvx4JNO4Ju+sQn48ZYkaUdUxyV829zqc0Jw3iG46i0h5u0pJdAudMqR/NCOyrWBwiUvu+/qxuiF0JuyULUyEph6bOzlp4YCIFHstblT+M92EtSkVvDmKKiRAfJO799Ym6YTCmcamc7vism47e/R66evAkb8WP89A+QK9TGnpw4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/1/16 2:12, Andrew Morton 写道:
> On Thu, 15 Jan 2026 18:10:51 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
>
>> On 12/23/25 12:05, Jinjiang Tu wrote:
>>> commit bda420b98505 ("numa balancing: migrate on fault among multiple
>>> bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
>>> for MPOL_BIND memory policy.
>>>
>>> When the cpuset of tasks changes, the mempolicy of the task is rebound by
>>> mpol_rebind_nodemask(). When MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES
>>> are both not set, the behaviour of rebinding should be same whenever
>>> MPOL_F_NUMA_BALANCING is set or not. So, when an application calls
>>> set_mempolicy() with MPOL_F_NUMA_BALANCING set but both MPOL_F_STATIC_NODES
>>> and MPOL_F_RELATIVE_NODES cleared, mempolicy.w.cpuset_mems_allowed should
>>> be set to cpuset_current_mems_allowed nodemask. However, in current
>>> implementation, mpol_store_user_nodemask() wrongly returns true, causing
>>> mempolicy->w.user_nodemask to be incorrectly set to the user-specified
>>> nodemask. Later, when the cpuset of the application changes,
>>> mpol_rebind_nodemask() ends up rebinding based on the user-specified
>>> nodemask rather than the cpuset_mems_allowed nodemask as intended.
>>>
>>> To fix this, only set mempolicy->w.user_nodemask to the user-specified
>>> nodemask if MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES is present.
>>>
>> ...
>>
>> I glimpsed over it and I think this is the right fix, thanks!
>>
>> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Cool.  I decided this was "not for backporting", but the description of
> the userspace-visible runtime effects isn't very clear.  Jinjiang, can
> you please advise?

I agree don't backport this patch. Users can only see tasks binding to
wrong NUMA after it's cpuset changes.

Assuming there are 4 NUMA. task is binding to NUMA1 and it is in root cpuset.
Move the task to a cpuset whose cpuset.mems.effective is 0-1. The task should
still be binded to NUMA1, but is binded to NUMA0 wrongly.

>

