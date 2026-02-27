Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7FF0FD5306
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 07:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6EC16B0005; Fri, 27 Feb 2026 02:32:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1B4C6B0088; Fri, 27 Feb 2026 02:32:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1A786B0089; Fri, 27 Feb 2026 02:32:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A95FC6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:32:29 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BF09C1FEC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:32:29 +0000 (UTC)
X-FDA: 84489418818.17.A94E8B2
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf10.hostedemail.com (Postfix) with ESMTP id 76E82C000C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:32:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xibT8yrp;
	spf=pass (imf10.hostedemail.com: domain of yebin10@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=yebin10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772177547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FtzP6snTxb6/9Yfh1EYbBMx18ST1cVCB8Di30/9yAaI=;
	b=xLYQ8VGfm1V9CL0HeMbbo03jw3xIkkhX8K8BkFIMet2t2iGhlEmroV0lHq4oOVGloSKPdr
	q27S8nImH7LpJZjt7/5AxRwQ8J/VlPMUlzO+gxVWvRJnwyKfvBxUqX0y5vrC9gSncKE4RQ
	cGQq8uqG16K+rWUenCmIq6q1s2SzblQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xibT8yrp;
	spf=pass (imf10.hostedemail.com: domain of yebin10@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=yebin10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772177547; a=rsa-sha256;
	cv=none;
	b=INO7cZM+1mIoE5vjl9pf9dxfnWlzSK+w0pHNc26kyZTPZm5oLDM8Pmc3P2u44bA7s9LeKm
	bIbSABs+cRaWBpfrThPDLfD/bHDsmJynLDB/rCGvdmpSu2qo4mljT6Ej25wZ1ay25cip9W
	XRV2g8Kxxntdla+JkA1EGYXlew0JJjA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FtzP6snTxb6/9Yfh1EYbBMx18ST1cVCB8Di30/9yAaI=;
	b=xibT8yrpFyU5r1CHGZu7/2XwE3lL+8Sbz4s+zuFFVzXR8JG966qwAOjSfWgOSwBL3YE1MAgQf
	8at/jTqnnkYjvaopov8TZGf2tG7AtcQ6Um8eFr4tCq5ompNGPvrlqF7zZpvcW9qGOdYVvuP9z4J
	3hbrU2Cq4F0E8vt7JmSsC/Y=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fMfzw4XzkznTWJ;
	Fri, 27 Feb 2026 15:27:40 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 3F2B94055B;
	Fri, 27 Feb 2026 15:32:20 +0800 (CST)
Received: from kwepemq500016.china.huawei.com (7.202.194.202) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 27 Feb 2026 15:32:20 +0800
Received: from [10.174.178.185] (10.174.178.185) by
 kwepemq500016.china.huawei.com (7.202.194.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 27 Feb 2026 15:32:19 +0800
Subject: Re: [PATCH v3 0/3] add support for drop_caches for individual
 filesystem
To: Muchun Song <muchun.song@linux.dev>
References: <20260227025548.2252380-1-yebin@huaweicloud.com>
 <4FDE845E-BDD6-45FE-98FA-40ABAF62608B@linux.dev>
 <69A13C1A.9020002@huawei.com>
 <959B7A5C-8C1A-417C-A1D3-6500E506DEE6@linux.dev>
CC: Ye Bin <yebin@huaweicloud.com>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <jack@suse.cz>, <linux-fsdevel@vger.kernel.org>,
	<akpm@linux-foundation.org>, <david@fromorbit.com>,
	<zhengqi.arch@bytedance.com>, <roman.gushchin@linux.dev>,
	<linux-mm@kvack.org>
From: "yebin (H)" <yebin10@huawei.com>
Message-ID: <69A14882.4030609@huawei.com>
Date: Fri, 27 Feb 2026 15:32:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <959B7A5C-8C1A-417C-A1D3-6500E506DEE6@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.185]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500016.china.huawei.com (7.202.194.202)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 76E82C000C
X-Stat-Signature: in3bu7h7q3358earnm6emuu4qdqn8ixx
X-Rspam-User: 
X-HE-Tag: 1772177545-207260
X-HE-Meta: U2FsdGVkX1+3gtRnbV4rjaD5efRbGA4tKWQuPlSz8xVimh7fzaDTqdcWLbgUP3p5j6FS+fhtqowkjxK4No0X1FJKIa5/cfXXSq9wesivBVlCB2QZqF3KES4QoQu62GNg5L7OuGCu0dd3BsxrRS1vIWYGqo1unjsWA2RgFDhOsXVD4HWk43Bzac21Ms0h92h7fpYPkC8K+AsNKo3vUsJ3bKL2xxn2aYNkqMiSSisWiLLGfC+ZTQ7Qqb5rmMPWpFhRM+b7LXpjkErFugrXruMwyCLtCFIX+M+4iaIMj5ut5Y+Go9SQrNJZHbECbmaB93l14R/7Tr3teXNJazD5A7EvITR+n6UQmOlNzTwO02UHZB8v3lDnyWHQAbgKixQwGbM8HS+9PXi9bPbV0Tubpp39fTMOYIL3FwnXMbQkVCW9Zz9gN868ZfMcbyCNgMSsKko+4LNPSd6N3se0Kv5Ld1QWzzLOhTOlDrrmHqxIdPow6iY54EZYQB8kOPdImI3+zqCON1A+suxzCW7VCQI9dvQmX+oq+2Kcn3L4aMEMWdxGpwFIbu0U4a/0pR0xth1XpAOSJcM8SQNBIHjJZ+xLmsv+uxvW/CuaEgdPD4jL2JTAOSwh9U8xlwH3chdgINuREbw8hZ3VXVjP7I3oklmV3OwtSIP0W+zkKBatthiqtjJu5rRXdkOfcWBWcL3aGmgGa97AMXY/awpx5lco3NV7YbyAhxd2n5G0zJ4QgDR9Ue7qfqr9m0wylUBRP21cZA7GOTOLmYADZZ4ES7CKLmkUjM4Qu2cxkn7wjUefYi33Wd+4Xu5GTHYK8cBPGUNipw7vqsdJSfWBPj08iJe/LYaWtTLOv+dBNSvm6pISTzJrvhJyuVMrxyuxxDovk/0w1KnW6GjQ62cA2H42YIllZ1SY8ypwYIhJj5/NQ2phZB3GZ5SFz2mtEGO7pb2qbjbI8B6yLflu+RJqTeqMXLskeAXNg3V
 En22Dq4v
 mTMLJh0g/cvcDWi2ETvH/egJe3vxLuSgc8VOuLbLlWvDR3+6XcOI0pA4sygEimkDvx8vONEQxKy/UrUjJX/mFOk0nUP0tDb57M+3GvopP29Es8WMBKRUu5JHyIJ2i+7BEz5wTrKZg7nsV/DKRiafqmlYkuQhUPQ3JBMmn+ePeHShkYRlZBGHM5Ll3YXDP9hCdmFBdwUGCc0lV6qPyLJ3RpIHsLuH7lT9lYzvvitcdpXUZWiKlDFWfkJYFqkoBf1QPJPIvxyATgDBJjXsKjVEyVsNNRL0U/HXuhtVq/jN11iZ+UkaCGgUmnJ86IYQBnEdWgvvcHxJ19YM7T+yTkAIy4kA1OUWP9hZfn1z6P6thQK4/swPmGr27qYpO5oc7oYzSBRCqUUNR+C4XyByvAxrOtDEkvAW6HzadANLgQxyI21LUfDBvdk2KIUhsdcDmlklJXJ2WWQHzIzWwhbtjC8LvbzE/td1p3MWOuMe40qyZXf9YiMuEPmmUhvpzQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/27 14:55, Muchun Song wrote:
>
>
>> On Feb 27, 2026, at 14:39, yebin (H) <yebin10@huawei.com> wrote:
>>
>>
>>
>> On 2026/2/27 11:31, Muchun Song wrote:
>>>
>>>
>>>> On Feb 27, 2026, at 10:55, Ye Bin <yebin@huaweicloud.com> wrote:
>>>>
>>>> From: Ye Bin <yebin10@huawei.com>
>>>>
>>>> In order to better analyze the issue of file system uninstallation caused
>>>> by kernel module opening files, it is necessary to perform dentry recycling
>>>> on a single file system. But now, apart from global dentry recycling, it is
>>>> not supported to do dentry recycling on a single file system separately.
>>>
>>> Would shrinker-debugfs satisfy your needs (See Documentation/admin-guide/mm/shrinker_debugfs.rst)?
>>>
>>> Thanks,
>>> Muchun
>>>
>> Thank you for the reminder. The reclamation of dentries and nodes can meet my needs. However, the reclamation of the page cache alone does not satisfy my requirements. I have reviewed the code of shrinker_debugfs_scan_write() and found that it does not support batch deletion of all dentries/inode for all nodes/memcgs,instead, users need to traverse through them one by one, which is not very convenient. Based on my previous experience, I have always performed dentry/inode reclamation at the file system level.
>
> I don't really like that you're implementing another mechanism with duplicate
> functionality. If you'd like, you could write a script to iterate through them
> and execute it that way—I don't think that would be particularly inconvenient,
> would it? If the iteration operation of memcg is indeed quite cumbersome, I
> think extending the shrinker debugfs functionality would be more appropriate.
>
The shrinker_debugfs can be extended to support node/memcg/fs 
granularity reclamation, similar to the extended function of echo " 0 - 
X" > count /echo " - 0 X" > count /echo " - - X" > count. This only 
solves the problem of reclaiming dentries/inode based on a single file 
system. However, the page cache reclamation based on a single file 
system cannot be implemented by using shrinker_debugfs. If the extended 
function is implemented by shrinker_debugfs, drop_fs_caches can reuse 
the same interface and maintain the same semantics as drop_caches.
>>
>> Thanks,
>> Ye Bin
>>>> This feature has usage scenarios in problem localization scenarios.At the
>>>> same time, it also provides users with a slightly fine-grained
>>>> pagecache/entry recycling mechanism.
>>>> This patchset supports the recycling of pagecache/entry for individual file
>>>> systems.
>>>>
>>>> Diff v3 vs v2
>>>> 1. Introduce introduce drop_sb_dentry_inode() helper instead of
>>>> reclaim_dcache_sb()/reclaim_icache_sb() helper for reclaim dentry/inode.
>>>> 2. Fixing compilation issues in specific architectures and configurations.
>>>>
>>>> Diff v2 vs v1:
>>>> 1. Fix possible live lock for shrink_icache_sb().
>>>> 2. Introduce reclaim_dcache_sb() for reclaim dentry.
>>>> 3. Fix potential deadlocks as follows:
>>>> https://lore.kernel.org/linux-fsdevel/00000000000098f75506153551a1@google.com/
>>>> After some consideration, it was decided that this feature would primarily
>>>> be used for debugging purposes. Instead of adding a new IOCTL command, the
>>>> task_work mechanism was employed to address potential deadlock issues.
>>>>
>>>> Ye Bin (3):
>>>>   mm/vmscan: introduce drop_sb_dentry_inode() helper
>>>>   sysctl: add support for drop_caches for individual filesystem
>>>>   Documentation: add instructions for using 'drop_fs_caches sysctl'
>>>>     sysctl
>>>>
>>>> Documentation/admin-guide/sysctl/vm.rst |  44 +++++++++
>>>> fs/drop_caches.c                        | 125 ++++++++++++++++++++++++
>>>> include/linux/mm.h                      |   1 +
>>>> mm/internal.h                           |   3 +
>>>> mm/shrinker.c                           |   4 +-
>>>> mm/vmscan.c                             |  50 ++++++++++
>>>> 6 files changed, 225 insertions(+), 2 deletions(-)
>>>>
>>>> --
>>>> 2.34.1
>>>>
>>>
>>> .
>>>
>
> .
>

