Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B766BE674B8
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 14:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 243526B0005; Mon, 22 Dec 2025 09:25:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1116B0089; Mon, 22 Dec 2025 09:25:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD316B008A; Mon, 22 Dec 2025 09:25:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F06886B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:25:57 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3F4B12BCE
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:25:57 +0000 (UTC)
X-FDA: 84247331154.04.E36A26C
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1E823120007
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:25:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=obD5POnI;
	spf=pass (imf29.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766413556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IYeWwjaY2KM7ZyG0dX4nY0oeBNNmpB7HA9HiypRw6Ac=;
	b=dLOAGlXYjA46p7XcKkYwMqnMawzjpZT9TIyocLw3alAxVMXSlhBtePiu7BC6Um97mPXn2z
	aehkoV134241wP75LynVcBgO9j0/6JIi4su/mO52BQKHXr/4bR89Y4CqvgQhIGlZ1YuhAD
	nF+zKVqvU73DmVW1lxhXp7iCqnSpg58=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=obD5POnI;
	spf=pass (imf29.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766413556; a=rsa-sha256;
	cv=none;
	b=uMouUBLLQIcGJpBpDczCTJYtu5XQKrPIEaxGmstveZv6hcC5UhD8NnapF8qDWkiy90sqMW
	978Ee4Nk2K7cp5xAJAN6FrFlS1G6z467H6zh+zF9INRI07ry+LdYiGkCHCFZHh7wAgLxIx
	Ft2zrL665IxDxiJqLgvraNoNFZAZJGM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IYeWwjaY2KM7ZyG0dX4nY0oeBNNmpB7HA9HiypRw6Ac=;
	b=obD5POnIfXSnNtD/O3b8wGCRdinGeebredunAdcCea2kP8Kq3byJmOP5POh8ijUCCe/k7q5s8
	3ya3XECkeF6FgvclSQiHmTcOVxlDaZIFju/bVQeURsa424M7wHcn7itZVnYHGj4tRbZnMvpZFZF
	he+QUabCTSM8vWUk+2f/evM=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dZgMk0Fggz1K96V;
	Mon, 22 Dec 2025 22:22:42 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id CADC340565;
	Mon, 22 Dec 2025 22:25:45 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Dec 2025 22:25:44 +0800
Message-ID: <4cf67d5a-af50-44d4-8a2a-c7fc76b304ee@huawei.com>
Date: Mon, 22 Dec 2025 22:25:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
CC: <akpm@linuxfoundation.org>, <david@kernel.org>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <apopple@nvidia.com>,
	<mgorman@suse.de>, <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>
References: <20251222030456.2246728-1-tujinjiang@huawei.com>
 <87ecomalp7.fsf@DESKTOP-5N7EMDA>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <87ecomalp7.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam02
X-Stat-Signature: uxk1q6a5w4kk6roed3fm3ew8c4a6ft1b
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E823120007
X-HE-Tag: 1766413553-457812
X-HE-Meta: U2FsdGVkX1/fBlWsyN5vEzZ0+l6gLF8OgNgAXTpRkMg/1zIWOKOOfkh5aDqVbGW5iqA09y7kfTLhjJZeQ3duE5qdLStTPJJKshRLUpwhslcI4xWEa1TBk2/oaLYOf6RWTrVDSzcttZd7dIUUqUpzNffx+/ZJh/HDKoqY49blbwGZOtYXQ002YJTaMPKCly4AT7ZwKsQv9JrWEkE5fNOvnIDsLzZXR8YH0P62oAc6+RSlMVILGmQh/rA4IcARFCt2SyEIA042Xh6ufsr98TE7+CYdzmnvlL7GsIvpHY1POwcDej8I6X3+Rk7u9HvONO9kVNbSWnT5JoTJgwcxj76EXfAGclmHAwGfoB94OTYjL7DT2cALHiw4SYn2vFCMCLFRcq8mYODSGw120wJrddmyFFbe2FwsxH00D1tdRAA8CKYkT00G8zurxKOa7JUaFP/k2afdaovvv6NchgEmin9Egj0/EhOAU4J11XnG8yjziP8svOHEB7GBl58Lkqa6RlWZ6Br/V7bBhoyiwYiVqrHUz1o7EmtgyZYH16H7HPmYG4ziuF4OeqFmiOggL+v5/5DHGBuvgutrIuxwXGESf+4nsjeeQzii0WXMDjGnFedO/FnAsL3t/RwK+CP2Fa4hkIxd/yc4LnedA4t80RRlNwqYrAAdgTPsfFuHWXwMRrus0+YCG+ZT4/6IRv776r7fOEEwwOVnGFDPNDONwpZ+tpBro6FRCuBQ9Mr0pcya1zjB8xYWKtychxpEd8WjGKHdt3Pwd1cWFJrRt34zt449YsWORS93Mx/g3W/91FtE6BZY43xL/+qIJ9aaYi6nZpKk+rPdEQ9gFNiW/zWlVFOeEZS/eugrCxhkPKB/RpetNEFdN6QCH1ZYqL+06XbuCrXYcxxRLUd+qlwPoXAqRZmPqu0eH0CRbHCSmP4Ui9hAg1f8crBxDNURtK2up8zGavmUy/Aqgni0fDulCpw5B774hqo
 4O3Xob5a
 vURC5dm1pYQVeilMEx6Q/kwvVnkwnnMTwbNAqtmp7EYR4gaRJqdfcJNP/AZIFq1fTH0S3xb14bOs40HNopzQiqt/49rORVNipoXaFpM6UUI39bbMhq2GJiTWP6D6H2HjhRjcdb77djtjwk4KbSulGYgHz+9USayfBEkqEOP3DCSYDNyg2d/JDN0oDAYLO33/fkSGCqz0UlK3gchtiey5QYdz39dLOk2R1TAen/ajmJl7fW9WyUouDruH2OAjbcFFfm3ZX2qz4ncRLZgrNd5rOvmM/YGwpZpXWi9QP+M2ZifCy1+w0usvBJ1QVY2uDQmoM10xuh/4JwzW/xrAexjb9ynu/tC466VJFpkHjpZXqbFKyunU46MVCTUwBnkqRgXoouAlaND5VggO0EHKOO6trxVi8IlqLLpSj6qRlWQdPViQchpzxca4+7s0F01WD+DFVAHe0BW5AzCLzNMqyVjgB4HHRcm7B0cytdul2qNqBXglDsVzdqwoVXrfdWpCxTxmJy/njBFNcHf7haPG3w33XGMri/wnpWIHoLEmU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/12/22 17:51, Huang, Ying 写道:
> Hi, Jinjiang,
>
> Sorry, I found the patch description is still confusing for me.
>
> Jinjiang Tu <tujinjiang@huawei.com> writes:
>
>> commit bda420b98505 ("numa balancing: migrate on fault among multiple
>> bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
>> for MPOL_BIND memory policy.
> Is the following description better?  At least, I think we should
> emphasize that MPOL_F_NUMA_BALANCING is set while both
> MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES are cleared in the mode
> parameter.

Thanks, I will update it to make it clearer. How about the following
description?


commit bda420b98505 ("numa balancing: migrate on fault among multiple
bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
for MPOL_BIND memory policy.

When the cpuset of tasks changes, the mempolicy of the task is rebound
by mpol_rebind_nodemask(). When MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES
are both not set, the behaviour is same whenever MPOL_F_NUMA_BALANCING
is set or not. So, when an application calls set_mempolicy() with MPOL_F_NUMA_BALANCING
set but both MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES cleared,
mempolicy.w.cpuset_mems_allowed should be set to cpuset_current_mems_allowed nodemask.
However, in current implementation, mpol_store_user_nodemask() wrongly returns true,
causing mempolicy->w.user_nodemask to be incorrectly set to the user-specified nodemask.
Later, when the cpuset of the application changes, mpol_rebind_nodemask() ends up rebinding
based on the user-specified nodemask rather than the cpuset_mems_allowed
nodemask as intended.

To fix this, only set mempolicy->w.user_nodemask to the user-specified nodemask
if MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES is present.

>
> When an application calls set_mempolicy() with MPOL_F_NUMA_BALANCING set
> but both MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES cleared,
> mempolicy.w.cpuset_mems_allowed should be set to
> cpuset_current_mems_allowed nodemask.  However, due to a bug in its
> current implementation, mpol_store_user_nodemask() wrongly returns true,
> causing mempolicy->w.user_nodemask to be incorrectly set to the
> user-specified nodemask (or an empty nodemask).  Later, when the cpuset
> of the application changes, mpol_rebind_nodemask() ends up rebinding
> based on the user-specified nodemask rather than the cpuset_mems_allowed
> nodemask as intended.
>
>> when the cpuset of tasks changes, the mempolicy of the task is rebound
>> by mpol_rebind_nodemask(). The intended rebinding behavior of
>> MPOL_F_NUMA_BALANCING was the same as when neither MPOL_F_STATIC_NODES nor
>> MPOL_F_RELATIVE_NODES flags are set. However, this commit breaks it.
>>
>> struct mempolicy has a union member as bellow:
>>
>>     union {
>>         nodemask_t cpuset_mems_allowed; /* relative to these nodes */
>>         nodemask_t user_nodemask;       /* nodemask passed by user */
>>     } w;
>>
>> w.cpuset_mems_allowed and w.user_nodemask are both nodemask type and their
>> difference is only what type of nodemask is stored. mpol_set_nodemask()
>> initializes the union like below:
>>
>>     static int mpol_set_nodemask(...)
>>     {
>>          if (mpol_store_user_nodemask(pol))
>>                  pol->w.user_nodemask = *nodes;
>>          else
>>                  pol->w.cpuset_mems_allowed = cpuset_current_mems_allowed;
>>     }
>>
>> mpol_store_user_nodemask() returns true for MPOL_F_NUMA_BALANCING
>> incorrectly and the union stores user-passed nodemask. Consequently,
>> mpol_rebind_nodemask() ends up rebinding based on the user-passed nodemask
>> rather than the cpuset_mems_allowed nodemask as intended.
>>
>> To fix this, only store the user nodemask if MPOL_F_STATIC_NODES or
>> MPOL_F_RELATIVE_NODES is present.
>>
>> Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
>> Reviewed-by: Gregory Price <gourry@gourry.net>
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> [snip]
>
> ---
> Best Regards,
> Huang, Ying

