Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9FA3EB3655
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 02:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCB806B00BE; Mon,  2 Mar 2026 21:32:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99046B00BF; Mon,  2 Mar 2026 21:32:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC69A6B00C0; Mon,  2 Mar 2026 21:32:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CC6D6B00BE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:32:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3AEF4B9DE0
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:32:23 +0000 (UTC)
X-FDA: 84503177766.23.83C6458
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf10.hostedemail.com (Postfix) with ESMTP id 06805C000E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:32:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=g+Ccphz3;
	spf=pass (imf10.hostedemail.com: domain of yebin10@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=yebin10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772505141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g9ZERwdBTzNcJlyl7JMEnk+Gz1/74PAnF0zrPGxMSQQ=;
	b=WwDZaUIhHYtWOZSmmBJ3J8K53zE7AA2PKaALi+xVJSaH771JXkRHZUTIBmAYbqOzl/+DoL
	2aZIC+/A+8C7U0hhfLeHGU0tg3wo5z3eEvBl8Yt83IG9fDM4sKXQelhR2Alf4OTWgT9x9F
	HKaG1Y53IixCQiRkZ9c/WB4T26joEbs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=g+Ccphz3;
	spf=pass (imf10.hostedemail.com: domain of yebin10@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=yebin10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772505141; a=rsa-sha256;
	cv=none;
	b=wtUN4mT8tHUe8VR6/DqcZddUwnsQREy12puduZllTbn+D3S7qZ/2vmU8qFmtZ+Np403nRn
	avAHinm0EPF8q8WHpb/Gpv6f1ZbFOCJMGX9uNSlgr44VmCoCyl6K0Fn8EV+2aL1Ih2V04o
	jZ/qXeCoIH1rMbpWJzyvdRim4Mp1zhE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=g9ZERwdBTzNcJlyl7JMEnk+Gz1/74PAnF0zrPGxMSQQ=;
	b=g+Ccphz3cJNi5TcygW53gBxDab7EwyQTaCNpRcJjETumLELzvNTl4B5FiUfyF/86C7c4+Y//l
	CFCACOmEJ6W+2CN38ejvHuYCbFe1+C7XV3R4GTglJDnl1cymj8P9ZYZudqGgZS4UkwUr8niVtMW
	GlHKRalvnsVd6SKU82/e2bE=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4fQ07b51GCzmV7V;
	Tue,  3 Mar 2026 10:27:23 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id F18C340565;
	Tue,  3 Mar 2026 10:32:14 +0800 (CST)
Received: from kwepemq500016.china.huawei.com (7.202.194.202) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 3 Mar 2026 10:32:14 +0800
Received: from [10.174.178.185] (10.174.178.185) by
 kwepemq500016.china.huawei.com (7.202.194.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 3 Mar 2026 10:32:13 +0800
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
Message-ID: <69A6482C.6060807@huawei.com>
Date: Tue, 3 Mar 2026 10:32:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <57055A1C-0684-4B77-80ED-4A641F262792@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.185]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500016.china.huawei.com (7.202.194.202)
X-Stat-Signature: ej75n49t4yu6qbxqoy7gkpg98in8t567
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 06805C000E
X-HE-Tag: 1772505139-69385
X-HE-Meta: U2FsdGVkX1+8bdC4yz3bf03q7uyCw9MnXGH3kVXGB+1/YBcH0elbb6uS1pSju0LksYZwGAf4E4gJpbuLl4CQqCo3E3/UPhJpLl4EukHM8Vq5RSPjygCGH+5TSg/42nnASOhVqXk1TBEXxpdsPbyUnhOz0OLJqRfR3R/c+p/itYoDGVEocp9UwIMWPv6v433waHASNYbTeu951GDf/44ik/tKaK7KDEk0YZNfc+14WT0BHaHd1M4c+nEunrm166TsHx5r0UJ9RLsv+YIwaOnKR4AwUzHsMeCLKfGSEjeHKXE93CtKOA+gBRbMSNITfJWp8JCRVSmDBjtYmuwgePaGYK615Tx9FD5WNCf7SskTBfhpW+5TYCgQvaBIdvRyusc9Cop3WEiC0c9P70I2my1o8VVZk6bKFSz46WxMNRkiJfGdjsPrnSYvZ/ahc4A/gUie3Hlk/O70oMRD5bHxsk5EeuPHLupcv5okh+0h8yVqt7diOP0CurKvSdww46+8JUhEwKF2IcburYxcULoVjxM4zxPKbTsqwXBRqd7bt8kRfL32M+bivCCeXE/WPUYF0ngQj6u/zOwPGg5JHflASahtsOPFDA8+csO0wV3xv8rzHaqmnN5MFCH3Em9e1v91YBx8p1P7hYJc1c5e9B2gMerN4ClrYKImanj01ajy/+Zg7Ufbp1emZQpSSDIsmphgUr/ZNpOvAyDaBUDBcgeKzefb2U+bWF6A4c+o53hhMRPhFaxiEcXmhRW8TkTwGLsSdhp24JbbfzpqVO/gXqP4jyoBy73AmnOYnJWB5f4oMiEESUGMcdQu38ACfFGFVmV32NazDUUL79Fh3jZl2SYF0oAiFPsmILMKhLECX4gl9XnlbPOGtwPbtk1wqOtOVC6JX7w/Ef/6AahGM81au215GDs2diFsSSp3kdVt0vNuq3ohBrmPwiQdK2UNU7eVmfwfICqRFHuTcJ4RNUxLDtx94DD
 JTw7HTA9
 4EUbj0V7IKSfz0CvQEBqqjgyXOTjB5uuxxkxp0EPh8jzoeE7PquYct23BM1deKvvVgoXgBqa2Crm3hQC3en+NBpkTb23MyzBYleSTzQ6hdtNB9h1uUeaiTmcfGGx7ESKs9r0m5axT2D7c65uxW3/SQOi7FXnH7S6qvyW8LrFI1l3F5/bNCpOCDF+u/baH2g9B4EIPLeyZZqE9FoGNDZ0ELC4J1Yyt7LHP8IwAOIPX7EJ0dvhmnqz/0OuEdeoux+l3+tUeS+kg6qliYLlko++RIgXGNnNvo+xwxAfRwshitWmJkaU0OV+dkepbEJRBd0jdVgmFi7G7cIYI6iaAh6ncBiatkCpekBZQ5iTSwPyw8rtfdlUhFPyxywYbpTAHPRgZ8yuGzqQP/2HklhPYx3KSwV3A/WJQoBbulLKFr5hmkJolZQ+rNOyltPaBNXwuKdfWUCfQKcBFJieYRMyiMW2UStUqqf0AeRnFYOKiel+wPpKZtNo6L6oBYf2B2g==
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
Perhaps I didn't explain it clearly earlier. What I want to achieve is
the ability to perform memory reclamation (pagecache/dentry/inode)
based on a single file system. In the current network environment, when
troubleshooting issues, I want to control the impact of operations and
only perform memory reclamation on specific file systems. Therefore,
some files might be in an occupied state, and relying on dentry/inode
to reclaim pagecache will not achieve the desired effect. Additionally,
I have encountered some users who periodically run `drop_caches`,
mainly to clear the pagecache. If we rely on dentry/inode to release
resources, there will be issues where the pagecache cannot be fully
cleared. This level of granularity is actually unnecessary because in
some scenarios, users know which partitions they use more frequently,
so they only need to clear the pagecache for specific partitions.

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

