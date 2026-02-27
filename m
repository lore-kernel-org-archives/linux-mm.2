Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C969CFD530E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 08:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D380B6B0088; Fri, 27 Feb 2026 03:17:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2576B0089; Fri, 27 Feb 2026 03:17:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0F516B008A; Fri, 27 Feb 2026 03:17:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABC4A6B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:17:32 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E8991B7222
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:17:32 +0000 (UTC)
X-FDA: 84489532344.12.7DAC7E0
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf21.hostedemail.com (Postfix) with ESMTP id 874201C0006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:17:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=A8U6QcFj;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of yebin10@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yebin10@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772180250; a=rsa-sha256;
	cv=none;
	b=JnmET1pYpJI1KITeb43f4iawkqDuxnyzrqbrnhJhjhIVsnaKOnGHRipe2Uv8zEJD5va454
	gLYn/U8OedfCG97D2jJ9CdQXoCqSrWsPg+jIqgVE6yqNdFRspQHp2e7iaJ8A9vae7obaXH
	1gThFMQG4oQuf0rRMukNJhpZdv1EPps=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=A8U6QcFj;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of yebin10@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yebin10@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772180250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DFRglj1idX0wl9sFMMaEKWZS+rbqYmOLqrcVSb6FkRg=;
	b=8Mc2tYCb0NE8iUA18hb7YW8pAhXQW4izVuCy+IaEpW4JcXt4WquAufS7IuWTGfQC56MVmR
	hkCcZJ1R6+ObDVDtkEYjZnexZzM6tSVE6VbnKZUjl2IrEIETS3OjhZ9BkBZysTinMReRMR
	KHV4AQ/47kAnf9ntF00pDy6oaTo5nNs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DFRglj1idX0wl9sFMMaEKWZS+rbqYmOLqrcVSb6FkRg=;
	b=A8U6QcFjytjw4d9ak9Pn2C1V244l8CN4E3+JJsYsfYk/7nsZ1sWRMudBdJiEH8NR5VpGW0S6r
	E+fqQNOokZqeTIfCl4ThRVKb/b7u1vRGeV0Lji1250NnuD0phzHTrLCSRb5UfN1/zMfoisV5WYM
	NIsrI757GDcWIxM1MXCNT20=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4fMgzn5bc0zLlSN;
	Fri, 27 Feb 2026 16:12:37 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id AF74240561;
	Fri, 27 Feb 2026 16:17:25 +0800 (CST)
Received: from kwepemq500016.china.huawei.com (7.202.194.202) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 27 Feb 2026 16:17:25 +0800
Received: from [10.174.178.185] (10.174.178.185) by
 kwepemq500016.china.huawei.com (7.202.194.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 27 Feb 2026 16:17:24 +0800
Subject: Re: [PATCH v3 0/3] add support for drop_caches for individual
 filesystem
To: Muchun Song <muchun.song@linux.dev>
References: <20260227025548.2252380-1-yebin@huaweicloud.com>
 <4FDE845E-BDD6-45FE-98FA-40ABAF62608B@linux.dev>
 <69A13C1A.9020002@huawei.com>
 <959B7A5C-8C1A-417C-A1D3-6500E506DEE6@linux.dev>
 <69A14882.4030609@huawei.com>
 <C63DBC11-B4CD-4D8D-9C09-E6A9F690FB21@linux.dev>
CC: Ye Bin <yebin@huaweicloud.com>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <jack@suse.cz>, <linux-fsdevel@vger.kernel.org>,
	<akpm@linux-foundation.org>, <david@fromorbit.com>,
	<zhengqi.arch@bytedance.com>, <roman.gushchin@linux.dev>,
	<linux-mm@kvack.org>
From: "yebin (H)" <yebin10@huawei.com>
Message-ID: <69A15314.3080602@huawei.com>
Date: Fri, 27 Feb 2026 16:17:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <C63DBC11-B4CD-4D8D-9C09-E6A9F690FB21@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.185]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500016.china.huawei.com (7.202.194.202)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 874201C0006
X-Stat-Signature: pnxyz1oaxhutbz7ak9sibw8yk8fekec7
X-Rspam-User: 
X-HE-Tag: 1772180249-458568
X-HE-Meta: U2FsdGVkX1/6jFzSv/sPe4MjeYET71hX87y/0366DzRwzBhBqPPQ5fg3GVpLV5HaOeQPaEE8KK2otGJGmfChViwKj5FjD51U/e1+8Uc2TmEDNXBNCcqBpAxmaMwtu1zgrkVHmZ61uL4YCToW06O5Sivk02Q3HqBLuUYIZUal+XM8t7G46lclygL+2dePtegFx4YmVNKf79jUkTHyIF+9RZA6iYkO4u1ZF7FWBYkTpCfko1iJZilVeXhSYtibN+/zBlkGnNBJPljjEgddzUY7yuSE/65nBJI8Vxa4qT9N5oZ2kYvRYPMdFmkFGAJtyM1mTjPwnl9+QM/3w7pTsk0MUHIcZZ1Ctfw10jjuOccsa3BU+S+s+EY2NV5C8dR1aK/eoPFV6LV/Q75MuZ/XwYZdv0j5vD9/bj9htkhWsjrHLN+zzX10+7kxFve5Fvze4tuN5OByVPFNvy70w05/0CmHHOBE4XPXyA9IZh4MwnETO4V+3HXeGcnVQtwFzjFDSsd9Rzcw9bZAOhK+6sxGxBd4j1fVMzCsKx5U84dl0mzDmjUm8NwPnYcWT6kzI3LBEbuwjzxnKQapAAVkgiqs4jljItnuJ5tXJbGSrd+7K2BetJJfNmik8xD6CxT9F9a/UvvO5KYXHGNWUp6vK97zDoUGWoOFKutwxLc84fQ8xq+Et15ZPsDvynCsH3EoDPn3Bl+23kHWUw/QcdaOagzlZqEgv2Xbox3d4kdjFN+t3XP9WAESBL3dePDnPlAL9df6qf3onfAljMeMNVNFeZyDXqVKSp+X2mXZL1L97AlPFE1dNf68QNEzUdpzsGYJSC8O3GG16/nuoDwH5FBV4dnwRiAH/X2w4eghIf1yTzOUT0tQQ2RThqdhqMH6+Mqyr1qa2QCzP8qKyeDOflDS/mxs13gGh4Um0hXTi8Q655KnVBOtPlwY/z2a3pgVRqLrCjj08TbpPWfnajYivgbgAfB0Z0j
 9iZCcAzo
 /VwTl//GP/UfzmIFkdRimtlqYtbg+9TLgFJ+PFTRqmkYwAwMJwd1kxEIwFEiIwF0ZrrCjvLwHMTfQv6t3r9aRcdfKLkZyH/IRm9DwjDLf1OfBl088MECqbGPG4+OQiX2H6ZSZ7e63uDsGYe73J34D1RlAYu5frzhukuqn+hF73Wb5dqEDjTKaA3mCMFt+SSOUmshl9o490/Y5J3+PiQ2tG4VZ3Xx173DxJpWWHTH24vACAumE69DcicPz09aPbaNZZ8QNCUzEYu7g1Asf0qI3M9q4h7XtTbo1QypS16w6bEaVUAo+suZ5oyJZ4Zg/xGX2JX/9+SU1A0oacI2yF39ZXPW6WRYaaKFv8CZ1qmrKpKsAoESiXFIS0ra6LbTPFArnbq/Dc/55ALAUZK8sdAEIBmhCKfCVaXjJVZ1+GYKlJMcVddzL6eAmiAx2VnreASv5uEVmITG8PM21fuznXBQXsPZ/0Bow4kjoy4rSLXBorQhDZnnszN0L+tawfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/27 15:45, Muchun Song wrote:
>
>
>> On Feb 27, 2026, at 15:32, yebin (H) <yebin10@huawei.com> wrote:
>>
>>
>>
>> On 2026/2/27 14:55, Muchun Song wrote:
>>>
>>>
>>>> On Feb 27, 2026, at 14:39, yebin (H) <yebin10@huawei.com> wrote:
>>>>
>>>>
>>>>
>>>> On 2026/2/27 11:31, Muchun Song wrote:
>>>>>
>>>>>
>>>>>> On Feb 27, 2026, at 10:55, Ye Bin <yebin@huaweicloud.com> wrote:
>>>>>>
>>>>>> From: Ye Bin <yebin10@huawei.com>
>>>>>>
>>>>>> In order to better analyze the issue of file system uninstallation caused
>>>>>> by kernel module opening files, it is necessary to perform dentry recycling
>>>>>> on a single file system. But now, apart from global dentry recycling, it is
>>>>>> not supported to do dentry recycling on a single file system separately.
>>>>>
>>>>> Would shrinker-debugfs satisfy your needs (See Documentation/admin-guide/mm/shrinker_debugfs.rst)?
>>>>>
>>>>> Thanks,
>>>>> Muchun
>>>>>
>>>> Thank you for the reminder. The reclamation of dentries and nodes can meet my needs. However, the reclamation of the page cache alone does not satisfy my requirements. I have reviewed the code of shrinker_debugfs_scan_write() and found that it does not support batch deletion of all dentries/inode for all nodes/memcgs,instead, users need to traverse through them one by one, which is not very convenient. Based on my previous experience, I have always performed dentry/inode reclamation at the file system level.
>>>
>>> I don't really like that you're implementing another mechanism with duplicate
>>> functionality. If you'd like, you could write a script to iterate through them
>>> and execute it that way—I don't think that would be particularly inconvenient,
>>> would it? If the iteration operation of memcg is indeed quite cumbersome, I
>>> think extending the shrinker debugfs functionality would be more appropriate.
>>>
>> The shrinker_debugfs can be extended to support node/memcg/fs granularity reclamation, similar to the extended function of echo " 0 - X" > count /echo " - 0 X" > count /echo " - - X" > count. This only solves the problem of reclaiming dentries/inode based on a single file system. However, the page cache reclamation based on a single file system cannot be implemented by using shrinker_debugfs. If the extended function is implemented by shrinker_debugfs, drop_fs_caches can reuse the same interface and maintain the same semantics as drop_caches.
>
> If the inode is evicted, the page cache is evicted as well. It cannot evict page
> cache alone. Why you want to evict cache alone?
>
The condition for dentry/inode to be reclaimed is that there are no
references to them. Therefore, relying on inode reclamation for page
cache reclamation has limitations. Additionally, there is currently no
usage statistics for the page cache based on a single file system. By
comparing the page cache usage before and after reclamation, we can
roughly estimate the amount of page cache used by a file system.

>>>>
>>>> Thanks,
>>>> Ye Bin
>>>>>> This feature has usage scenarios in problem localization scenarios.At the
>>>>>> same time, it also provides users with a slightly fine-grained
>>>>>> pagecache/entry recycling mechanism.
>>>>>> This patchset supports the recycling of pagecache/entry for individual file
>>>>>> systems.
>>>>>>
>>>>>> Diff v3 vs v2
>>>>>> 1. Introduce introduce drop_sb_dentry_inode() helper instead of
>>>>>> reclaim_dcache_sb()/reclaim_icache_sb() helper for reclaim dentry/inode.
>>>>>> 2. Fixing compilation issues in specific architectures and configurations.
>>>>>>
>>>>>> Diff v2 vs v1:
>>>>>> 1. Fix possible live lock for shrink_icache_sb().
>>>>>> 2. Introduce reclaim_dcache_sb() for reclaim dentry.
>>>>>> 3. Fix potential deadlocks as follows:
>>>>>> https://lore.kernel.org/linux-fsdevel/00000000000098f75506153551a1@google.com/
>>>>>> After some consideration, it was decided that this feature would primarily
>>>>>> be used for debugging purposes. Instead of adding a new IOCTL command, the
>>>>>> task_work mechanism was employed to address potential deadlock issues.
>>>>>>
>>>>>> Ye Bin (3):
>>>>>>   mm/vmscan: introduce drop_sb_dentry_inode() helper
>>>>>>   sysctl: add support for drop_caches for individual filesystem
>>>>>>   Documentation: add instructions for using 'drop_fs_caches sysctl'
>>>>>>     sysctl
>>>>>>
>>>>>> Documentation/admin-guide/sysctl/vm.rst |  44 +++++++++
>>>>>> fs/drop_caches.c                        | 125 ++++++++++++++++++++++++
>>>>>> include/linux/mm.h                      |   1 +
>>>>>> mm/internal.h                           |   3 +
>>>>>> mm/shrinker.c                           |   4 +-
>>>>>> mm/vmscan.c                             |  50 ++++++++++
>>>>>> 6 files changed, 225 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> --
>>>>>> 2.34.1
>>>>>>
>>>>>
>>>>> .
>>>>>
>>>
>>> .
>
>
>
>
> .
>

