Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4194BFD5301
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 07:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440716B0005; Fri, 27 Feb 2026 02:18:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C3F46B0088; Fri, 27 Feb 2026 02:18:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D1036B0089; Fri, 27 Feb 2026 02:18:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1436B6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:18:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E0B059485
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:18:45 +0000 (UTC)
X-FDA: 84489384210.18.E7E311C
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf09.hostedemail.com (Postfix) with ESMTP id A46CF140007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:18:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=s0Qqfgv6;
	spf=pass (imf09.hostedemail.com: domain of yebin10@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=yebin10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772176723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avyklT8ko17OO+T4b2BCtg7wDKlzbbLPrf2QbaV4vBE=;
	b=bfpLQ34+K+0VgSRUkzV64+JredZcAkKsWbgqR/zoMUXcps/UhmHw9tZcTb69bt+el4sXFs
	uOpLNnUmYtmiOkP64I/q4HKSV6rfZdiRJIReqim6Sot4JaDoKf9Jcv+iIzE6FaBn6st1bM
	Dc//xwBulSoukQzaCsvd1kRbSEIANrQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=s0Qqfgv6;
	spf=pass (imf09.hostedemail.com: domain of yebin10@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=yebin10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772176723; a=rsa-sha256;
	cv=none;
	b=6uulogo6whF5cAhFWvWqSJwseOVBEzkD4+ozlshbmsTdWq1AVqLWTPDb/TBXwaAlG4yDOl
	OBS9EqlRCHOBwSS4M2kwTsSWwZuCo+4QnuWyhVn66VcWxMvX8Y9SskDgWJ1TspOqmgIn2E
	0bJGYkjZcbyCgXBHGzAxIY/GyWE6QL4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=avyklT8ko17OO+T4b2BCtg7wDKlzbbLPrf2QbaV4vBE=;
	b=s0Qqfgv6XXOMw0WL6SBdGWFuu/zOcDq311HqQfv3rZGLhyYWsQP+QOoGtNSsASop83hvOW6pL
	6sNgjken/XLv0tubjuEugoPxYMyuL5Lgq1xX6PhrM4TzAOUL8zSJyNahh2xLrNC2s1FNBXb03eL
	HMJqi0zYDffehJthhyGgZpc=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4fMfgl0QbBz1T4Fq;
	Fri, 27 Feb 2026 15:13:39 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 8CA002021A;
	Fri, 27 Feb 2026 15:18:33 +0800 (CST)
Received: from kwepemq500016.china.huawei.com (7.202.194.202) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 27 Feb 2026 15:18:33 +0800
Received: from [10.174.178.185] (10.174.178.185) by
 kwepemq500016.china.huawei.com (7.202.194.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 27 Feb 2026 15:18:32 +0800
Subject: Re: [PATCH v3 0/3] add support for drop_caches for individual
 filesystem
To: Qi Zheng <qi.zheng@linux.dev>, Muchun Song <muchun.song@linux.dev>, Ye Bin
	<yebin@huaweicloud.com>
References: <20260227025548.2252380-1-yebin@huaweicloud.com>
 <4FDE845E-BDD6-45FE-98FA-40ABAF62608B@linux.dev>
 <69A13C1A.9020002@huawei.com>
 <e4834869-4144-41aa-b370-9c4e6091322e@linux.dev>
CC: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<linux-fsdevel@vger.kernel.org>, <akpm@linux-foundation.org>,
	<david@fromorbit.com>, <roman.gushchin@linux.dev>, <linux-mm@kvack.org>
From: "yebin (H)" <yebin10@huawei.com>
Message-ID: <69A14547.3050803@huawei.com>
Date: Fri, 27 Feb 2026 15:18:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <e4834869-4144-41aa-b370-9c4e6091322e@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.185]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500016.china.huawei.com (7.202.194.202)
X-Rspam-User: 
X-Stat-Signature: hsqupc4z7ajiyh6hiju4844myqdng5bc
X-Rspamd-Queue-Id: A46CF140007
X-Rspamd-Server: rspam10
X-HE-Tag: 1772176721-607014
X-HE-Meta: U2FsdGVkX1++/2yXGsNwtp47I/eNwjYcMc5Tq5nvr/mZBPxufRwiAKps+1tA32wFszDV8HRDtz/S/uF2+b/LEhUvESA2V2FUFMBHtRlRqXoaRe9oohFcjA5FWZwYubd5EIqtmhldJRvVpCkbNHZlRdXbxWZITSjL+B7xCCJF6nRpQiT8kwIqNaf+1BSvdL/jXLPfr8tQkfe8CC6CZfxPFlJtH8gBUbIhPc5ql8UehHmPQwbxcpCx/3NOTE7dqg71zggoHd2yOcQajTmV22uwztBZraC2ktJFUqvuWK0gf6+Mbyo0qovqVJoNB64Xv9GzOE9dAQdbX/yCZGKFT//+a34hbohYxPZuUJdY2XA7C9l7Vj1ZfXDj/LyNM86c4B9Xb4TwNdpDfbOCUuaRi1xFqcDSX2AWD8mLCPxtOcCedQpV4GfvtKgfYUYOdkWomTwAzeZBTS4M/Vs9VaEC0OC5aVuSdtgqE1O134Y4vLjWK4bGK/zkkK9YHRcpu8kU+s/subu0BmnShofY8kF0no2QdAkhEaHp/L8/jzSPHTYFBl6I6u03FafYLSH+0FBB0A75vA/4MBiiEq+9LnhteqP9fJ/dEPQKYfT6mOu91FbZAKnVe1YnVGL789346kvA0FPRD8DahOJhub33aYgfTjWNDM4gX6v/NT6hBhC/OGLXanMoZ75g8x/dwAPTdtpR7KnU/7IT/r1+62oHMTi/D7Vci8AI9OZlZeAIzQszErDH8hokjE3j9hxtOXfNejhX17dNq+e4z64nIhSL+DV/M9MRaWEYzB20xMSl+nPcPIXildaZXhrLypNR+1irF/TLcGG7IoeaIMkwIkV7NFQndlo7W7Vf0JecgSKPw5Nrjvz88CgZomzVrSWaYfbwstG0fOU4j2ngbnwWGflMsPnoTtFRhMi2X/EQw5nWFX6lGZHnGldRU0l5HA4ya6BptzTBs1qOoaEhpEJfA/tZKYtxt01
 l8HKirlP
 SjOhfb53cl9n8YvxCDttvDtou9jfAho4QSQ3/Ip1IUxJkLEYGO3qupyykpM3LTFYk8iZ1uABW6vrDt58/r/oBVzsEN+yY3EytN+HSfBpfFHVFqJh036gqtmSsx9xZ355oQhOH9n4tPDWu0Vm3BSKWcYSTJOUwsfaPtplyYFhn6iLsvMT3ER8nqxV7L3YYfxqbjflBkP3MgyZOTsoXqQvsey95XQuz+aMfyw63dJbPcU8fSS8Y9KyGMYZqRecyqAiJAdJ6NF8UMKn3A6nBmO0FU1aIuQgrCTdh2r0u3e2BJPAFPoZ1XBP7DyOBD276Zi7hgQmSJ9rpMqTvW+HSABPBHaKKv92f5Qgp77wHMyR6x8+zZLmsFLUBI9NI5qd3ha4WrH9AxAXfTEIclK5GHNF9Peui4GAuNvbRp0vTSY68Uu02B8BUC80W+FIMHHob7eU/lGmvIKL5sShwHsI6ulD56LO79A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/27 14:50, Qi Zheng wrote:
>
>
> On 2/27/26 2:39 PM, yebin (H) wrote:
>>
>>
>> On 2026/2/27 11:31, Muchun Song wrote:
>>>
>>>
>>>> On Feb 27, 2026, at 10:55, Ye Bin <yebin@huaweicloud.com> wrote:
>>>>
>>>> From: Ye Bin <yebin10@huawei.com>
>>>>
>>>> In order to better analyze the issue of file system uninstallation
>>>> caused
>>>> by kernel module opening files, it is necessary to perform dentry
>>>> recycling
>>>> on a single file system. But now, apart from global dentry
>>>> recycling, it is
>>>> not supported to do dentry recycling on a single file system
>>>> separately.
>>>
>>> Would shrinker-debugfs satisfy your needs (See Documentation/admin-
>>> guide/mm/shrinker_debugfs.rst)?
>>>
>>> Thanks,
>>> Muchun
>>>
>> Thank you for the reminder. The reclamation of dentries and nodes can
>> meet my needs. However, the reclamation of the page cache alone does
>> not satisfy my requirements. I have reviewed the code of
>> shrinker_debugfs_scan_write() and found that it does not support batch
>> deletion of all dentries/inode for all nodes/memcgs,instead, users
>> need to traverse through them one by one, which is not very
>> convenient. Based on my previous experience, I have always performed
>> dentry/inode reclamation at the file system level.
>
> Using shrinker-debugfs allows users to specify the size of a single
> reclaim cycle (nr_to_scan), which controls the strength of each reclaim
> cycle to adapt to different workloads. Can the new drop_fs_caches
> support a similar approach?
>
> Thanks,
> Qi
>
"drop_fs_caches" is similar to "drop_caches," but it only operates on 
the specified file system. It does not support specifying the number of 
pages to scan (nr_to_scan).
>>
>> Thanks,
>> Ye Bin
>>>> This feature has usage scenarios in problem localization
>>>> scenarios.At the
>>>> same time, it also provides users with a slightly fine-grained
>>>> pagecache/entry recycling mechanism.
>>>> This patchset supports the recycling of pagecache/entry for
>>>> individual file
>>>> systems.
>>>>
>>>> Diff v3 vs v2
>>>> 1. Introduce introduce drop_sb_dentry_inode() helper instead of
>>>> reclaim_dcache_sb()/reclaim_icache_sb() helper for reclaim
>>>> dentry/inode.
>>>> 2. Fixing compilation issues in specific architectures and
>>>> configurations.
>>>>
>>>> Diff v2 vs v1:
>>>> 1. Fix possible live lock for shrink_icache_sb().
>>>> 2. Introduce reclaim_dcache_sb() for reclaim dentry.
>>>> 3. Fix potential deadlocks as follows:
>>>> https://lore.kernel.org/linux-
>>>> fsdevel/00000000000098f75506153551a1@google.com/
>>>> After some consideration, it was decided that this feature would
>>>> primarily
>>>> be used for debugging purposes. Instead of adding a new IOCTL
>>>> command, the
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

