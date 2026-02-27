Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDBA9FD5313
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 09:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 133136B008C; Fri, 27 Feb 2026 04:03:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10C186B0092; Fri, 27 Feb 2026 04:03:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 038226B0093; Fri, 27 Feb 2026 04:03:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E24506B008C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:03:21 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7930F8BFD0
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:03:21 +0000 (UTC)
X-FDA: 84489647802.05.9B8FF90
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4D9318000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:03:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Oc5a1yLP;
	spf=pass (imf30.hostedemail.com: domain of yebin10@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=yebin10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772182999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5JYKwxylStVlmGFQYqYqbwAD5RX+1jkpsl+y0bf3huM=;
	b=oscPQKqX9x4yxkimuHzCIEgu0fZVLVRKnCTeI4/MW8r56SJw0/Hoqng58jz/dHHwnZFEBA
	/scv0JeGGV4pkC46hfVHwehYRtpufxr0+brbzgjtQL1fkRQMexI6SklLrp/Hr3AtW/dbZR
	/kxqbG05CJ3wNDpeMzPVEcCkvP4NRgs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772182999; a=rsa-sha256;
	cv=none;
	b=ojJVYByTXUuR+k/EDqjP6YgRIeIxZi/gMh0r+pWUI21F9amxM6FGcge4rc11r1v2INQmbZ
	kt7+j0vtwCvJK+5ZvqzhcawoKPcug7xLjE2wVJF++LTXlZL+Lc9e8kcxy+Jekw+XK546cm
	furaBVZVdaE2g25Wb0p73KMWkVT9Cxo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Oc5a1yLP;
	spf=pass (imf30.hostedemail.com: domain of yebin10@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=yebin10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5JYKwxylStVlmGFQYqYqbwAD5RX+1jkpsl+y0bf3huM=;
	b=Oc5a1yLPd7i0yeHHXyRY6S+yskLqw2BWbQLtW0ZJ9um5KXUYaKuwdHsOGrkZoe7ITr78yiIth
	xrYA1X4H6RByWSy4tNwO6HFhrB7ob4jkjwq+sSUQNNsEj+5dJyUAP4JQMiye/A5r5LQRVrjH0fm
	U02GotkHJQfVfsefwFoiDes=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fMj0R1pMLz1prKm;
	Fri, 27 Feb 2026 16:58:15 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id AA88940569;
	Fri, 27 Feb 2026 17:03:05 +0800 (CST)
Received: from kwepemq500016.china.huawei.com (7.202.194.202) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 27 Feb 2026 17:03:00 +0800
Received: from [10.174.178.185] (10.174.178.185) by
 kwepemq500016.china.huawei.com (7.202.194.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 27 Feb 2026 17:02:59 +0800
Subject: Re: [PATCH v3 0/3] add support for drop_caches for individual
 filesystem
To: Muchun Song <muchun.song@linux.dev>
References: <20260227025548.2252380-1-yebin@huaweicloud.com>
 <4FDE845E-BDD6-45FE-98FA-40ABAF62608B@linux.dev>
 <69A13C1A.9020002@huawei.com>
 <959B7A5C-8C1A-417C-A1D3-6500E506DEE6@linux.dev>
 <69A14882.4030609@huawei.com>
 <C63DBC11-B4CD-4D8D-9C09-E6A9F690FB21@linux.dev>
 <69A15314.3080602@huawei.com>
 <57055A1C-0684-4B77-80ED-4A641F262792@linux.dev>
CC: Ye Bin <yebin@huaweicloud.com>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <jack@suse.cz>, <linux-fsdevel@vger.kernel.org>,
	<akpm@linux-foundation.org>, <david@fromorbit.com>,
	<zhengqi.arch@bytedance.com>, <roman.gushchin@linux.dev>,
	<linux-mm@kvack.org>
From: "yebin (H)" <yebin10@huawei.com>
Message-ID: <69A15DC3.8040808@huawei.com>
Date: Fri, 27 Feb 2026 17:02:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <57055A1C-0684-4B77-80ED-4A641F262792@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.185]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500016.china.huawei.com (7.202.194.202)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4D9318000D
X-Stat-Signature: egf1pdzaoprgifomwjjm5ykyyjj78j1c
X-Rspam-User: 
X-HE-Tag: 1772182997-161553
X-HE-Meta: U2FsdGVkX18uZomS5tlCTL7NdmJwC24d4lQoBt00yWcui5Vvn6RfDEbf3rF8enx/TrEz0Z1+RwO3BVz+9izIeis5ocMwHrfbrOjVrMdCb4gktZdpw1JlXQMdpkn7Ou75RUYfWLq8De11xQrk4BLJmdBJYpq/7FITgf4/ic4xT518GaGW6834QCgge/oZ7ML9B+7ffMNhORBzQ3kOpyiD4cBy3zIO4gr2L2y7zixm+KpJBQYCGANyALHxUrc15zJ9JqVP0mffmi9vslCIA/Qqn4uvVvPu5MJLfwDpfWwarsBRCqEcEfbvL0N6HSoXYv00H5q+4BE2FYWXIa3u44BdRqfjW60R5mDcJWTRyXjd1ih3IRLo5hHPKo2KPdTl+jwD1201nBj2gwFpo3QgR2LJUBQDUGbpx37iIHhA+LiEJ9wXL7VPEwcIHIVSr5L+ENuwHU8UODiUUFmObmtzf6K+rS02Qoa854AfVQK0HsE2evXi0ndg8VA5rmzHShV8TN9uDc0sPb9qyBT/fioR1PQEjYVc3S+duJit43adgBkkoN8FsADoPpApS4sYMPveSBlYYGWEmgy2iLpCd/7COi1RByFdf/R8b+7v27asS9soQqgRmyHXQd5E+mhib8nC/eo6vWEZW0jo0Z53vDRPRbSHk+d1JffsJ8AVneP10uG3zErRzNi8qC+hruZsQeEQKs90keXvDFTm1DEUSS66j6JuWPUJLLy5jVWgEPY7VyyjGlHn3JSy1FQAVNquW1wvQMi9BJVZVqQx9rU9hWYpGiHU8lVfdpyNJEGGBIIAV9IUlYee5Ww6GghHRA8piasd6l0XmJnEEbXNMWh6aa8JLm9SC84GQTYov1K8kZIsTD4If6uB8sp+/z5wAqty72i8PPef3khZSzYtSBS9UCPXKa2XXZglWnlZLOST7Cqlig56swCwR8nI3cD0aZ0oKofGGQthAG6A8EF4A9WySQiBw0l
 bgg5iTwe
 OMoGisdyHoR54vSPuXHtxBCHvhVdCufRlLgZi09NRsowTUZKcYIhMW5R+/10Y5jI9wLxbQ3OoyVXOa9vno537iuqul57FpYoZ3uOvAIYTj7gWYQB7z0cXWXZ9Bs9h2YYDU7gU0n26Uo5ftcZYOLav5NGPhPTqAF7dt7YIMGojXHe5uFMuHtPZW9/ir66Y6TyOoF1EfJ3TIzNzKAhrIhWT0tle/R64ZCY7nZpqHBJfX4Z90EmrtZtiY1rSXrs9PT2MGclw8FKfTWiSbEPOgP86h/wRByDwaaVk9O8b3hQ9vd1Vs+UILuxJTFV/VurSHfrSYZveVnPnv5pz8+sH5cAnvKTQ6JgNimwKjXvJb0tXQS4dnjuV234bgulR3R0oDDzku7gfxXuNmKm5BOqPA8tuBa9eee05DXFFL5KSqUp/Px+qnK39V4WhKhbYKcy09xO22fYmzdzpfZUsfBVNtGIUgBdBNThRdK8GnXxyYTpuJbC0CQFCkKspnkIN7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/27 16:27, Muchun Song wrote:
>
>
>> On Feb 27, 2026, at 16:17, yebin (H) <yebin10@huawei.com> wrote:
>>
>>
>>
>> On 2026/2/27 15:45, Muchun Song wrote:
>>>
>>>
>>>> On Feb 27, 2026, at 15:32, yebin (H) <yebin10@huawei.com> wrote:
>>>>
>>>>
>>>>
>>>> On 2026/2/27 14:55, Muchun Song wrote:
>>>>>
>>>>>
>>>>>> On Feb 27, 2026, at 14:39, yebin (H) <yebin10@huawei.com> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 2026/2/27 11:31, Muchun Song wrote:
>>>>>>>
>>>>>>>
>>>>>>>> On Feb 27, 2026, at 10:55, Ye Bin <yebin@huaweicloud.com> wrote:
>>>>>>>>
>>>>>>>> From: Ye Bin <yebin10@huawei.com>
>>>>>>>>
>>>>>>>> In order to better analyze the issue of file system uninstallation caused
>>>>>>>> by kernel module opening files, it is necessary to perform dentry recycling
>>>>>>>> on a single file system. But now, apart from global dentry recycling, it is
>>>>>>>> not supported to do dentry recycling on a single file system separately.
>>>>>>>
>>>>>>> Would shrinker-debugfs satisfy your needs (See Documentation/admin-guide/mm/shrinker_debugfs.rst)?
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Muchun
>>>>>>>
>>>>>> Thank you for the reminder. The reclamation of dentries and nodes can meet my needs. However, the reclamation of the page cache alone does not satisfy my requirements. I have reviewed the code of shrinker_debugfs_scan_write() and found that it does not support batch deletion of all dentries/inode for all nodes/memcgs,instead, users need to traverse through them one by one, which is not very convenient. Based on my previous experience, I have always performed dentry/inode reclamation at the file system level.
>>>>>
>>>>> I don't really like that you're implementing another mechanism with duplicate
>>>>> functionality. If you'd like, you could write a script to iterate through them
>>>>> and execute it that way—I don't think that would be particularly inconvenient,
>>>>> would it? If the iteration operation of memcg is indeed quite cumbersome, I
>>>>> think extending the shrinker debugfs functionality would be more appropriate.
>>>>>
>>>> The shrinker_debugfs can be extended to support node/memcg/fs granularity reclamation, similar to the extended function of echo " 0 - X" > count /echo " - 0 X" > count /echo " - - X" > count. This only solves the problem of reclaiming dentries/inode based on a single file system. However, the page cache reclamation based on a single file system cannot be implemented by using shrinker_debugfs. If the extended function is implemented by shrinker_debugfs, drop_fs_caches can reuse the same interface and maintain the same semantics as drop_caches.
>>>
>>> If the inode is evicted, the page cache is evicted as well. It cannot evict page
>>> cache alone. Why you want to evict cache alone?
>>>
>> The condition for dentry/inode to be reclaimed is that there are no
>> references to them. Therefore, relying on inode reclamation for page
>> cache reclamation has limitations. Additionally, there is currently no
>
> What limit?
>
If the file is occupied, the page cache cannot be reclaimed through
inode reclamation.
>> usage statistics for the page cache based on a single file system. By
>> comparing the page cache usage before and after reclamation, we can
>> roughly estimate the amount of page cache used by a file system.
>
> I'm curious why dropping inodes doesn't show a noticeable difference
> in page cache usage before and after?
>
>>
>>>>>>
>>>>>> Thanks,
>>>>>> Ye Bin
>>>>>>>> This feature has usage scenarios in problem localization scenarios.At the
>>>>>>>> same time, it also provides users with a slightly fine-grained
>>>>>>>> pagecache/entry recycling mechanism.
>>>>>>>> This patchset supports the recycling of pagecache/entry for individual file
>>>>>>>> systems.
>>>>>>>>
>>>>>>>> Diff v3 vs v2
>>>>>>>> 1. Introduce introduce drop_sb_dentry_inode() helper instead of
>>>>>>>> reclaim_dcache_sb()/reclaim_icache_sb() helper for reclaim dentry/inode.
>>>>>>>> 2. Fixing compilation issues in specific architectures and configurations.
>>>>>>>>
>>>>>>>> Diff v2 vs v1:
>>>>>>>> 1. Fix possible live lock for shrink_icache_sb().
>>>>>>>> 2. Introduce reclaim_dcache_sb() for reclaim dentry.
>>>>>>>> 3. Fix potential deadlocks as follows:
>>>>>>>> https://lore.kernel.org/linux-fsdevel/00000000000098f75506153551a1@google.com/
>>>>>>>> After some consideration, it was decided that this feature would primarily
>>>>>>>> be used for debugging purposes. Instead of adding a new IOCTL command, the
>>>>>>>> task_work mechanism was employed to address potential deadlock issues.
>>>>>>>>
>>>>>>>> Ye Bin (3):
>>>>>>>>   mm/vmscan: introduce drop_sb_dentry_inode() helper
>>>>>>>>   sysctl: add support for drop_caches for individual filesystem
>>>>>>>>   Documentation: add instructions for using 'drop_fs_caches sysctl'
>>>>>>>>     sysctl
>>>>>>>>
>>>>>>>> Documentation/admin-guide/sysctl/vm.rst |  44 +++++++++
>>>>>>>> fs/drop_caches.c                        | 125 ++++++++++++++++++++++++
>>>>>>>> include/linux/mm.h                      |   1 +
>>>>>>>> mm/internal.h                           |   3 +
>>>>>>>> mm/shrinker.c                           |   4 +-
>>>>>>>> mm/vmscan.c                             |  50 ++++++++++
>>>>>>>> 6 files changed, 225 insertions(+), 2 deletions(-)
>>>>>>>>
>>>>>>>> --
>>>>>>>> 2.34.1
>>>>>>>>
>>>>>>>
>>>>>>> .
>>>>>>>
>>>>>
>>>>> .
>>>
>>>
>>>
>>>
>>> .
>
>
> .
>

