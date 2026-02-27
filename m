Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28A65FD4600
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 06:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 847A66B008A; Fri, 27 Feb 2026 01:39:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CADC6B008C; Fri, 27 Feb 2026 01:39:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9F16B0092; Fri, 27 Feb 2026 01:39:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 55D806B008A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:39:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DACDF8BD30
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:39:37 +0000 (UTC)
X-FDA: 84489285594.09.DF1FD75
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf23.hostedemail.com (Postfix) with ESMTP id 393AF140005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:39:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=fal7Ym+U;
	spf=pass (imf23.hostedemail.com: domain of yebin10@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=yebin10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772174376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/o+Q4AGikwIdB1bx+x/BsS3mTAPffNhVvHygGJp3gQ=;
	b=6f3e7VmdUN4CTA5utl49Y113/cAxtTsUolkzMuzWzMmHSF2laG/+m3SsllW1SZDf2z95fZ
	8uucRD5uICsEmLUoOwWCO0pK7qcCFbH2GNhVoOn/qR4Z6AUr+tasOYqLosgHWFlmA5N5+n
	ZH2TLqWKbQGICdON6OU0r6Jpwno28j8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=fal7Ym+U;
	spf=pass (imf23.hostedemail.com: domain of yebin10@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=yebin10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772174376; a=rsa-sha256;
	cv=none;
	b=okl0sym2zHjAnlv+qbc2wQt81XrqO0ul07Wu0JcX619iF11aqmlaR0gjPiJ3yN/B92+fpt
	Cxv4IyHO2gqWpISto50lczxjbr+DKwzrZTT2/xuLtp+P1UTxb6SAhqCWLCwBIsQABqh/f1
	PtL7RQCrDeP58Gs6KoQEqPxl7frteZI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=l/o+Q4AGikwIdB1bx+x/BsS3mTAPffNhVvHygGJp3gQ=;
	b=fal7Ym+UZ9TdpFDu8oxIToBd875duzVo5udOAcl/QqlARsvXZynsA51nqjSmpqCULkGIyBtHu
	gR9UapoubELSqeSBYWoHctScqwjMyBFqGFb6LRKPcUTe+t96pXiVYrng1LLgmmEnDHB0x4DVEBS
	3ZEy+yqNJmC5goD3zgqvME8=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4fMdpr6Jjhz12LD1;
	Fri, 27 Feb 2026 14:34:44 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 562A74056A;
	Fri, 27 Feb 2026 14:39:24 +0800 (CST)
Received: from kwepemq500016.china.huawei.com (7.202.194.202) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 27 Feb 2026 14:39:24 +0800
Received: from [10.174.178.185] (10.174.178.185) by
 kwepemq500016.china.huawei.com (7.202.194.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 27 Feb 2026 14:39:23 +0800
Subject: Re: [PATCH v3 0/3] add support for drop_caches for individual
 filesystem
To: Muchun Song <muchun.song@linux.dev>, Ye Bin <yebin@huaweicloud.com>
References: <20260227025548.2252380-1-yebin@huaweicloud.com>
 <4FDE845E-BDD6-45FE-98FA-40ABAF62608B@linux.dev>
CC: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<linux-fsdevel@vger.kernel.org>, <akpm@linux-foundation.org>,
	<david@fromorbit.com>, <zhengqi.arch@bytedance.com>,
	<roman.gushchin@linux.dev>, <linux-mm@kvack.org>
From: "yebin (H)" <yebin10@huawei.com>
Message-ID: <69A13C1A.9020002@huawei.com>
Date: Fri, 27 Feb 2026 14:39:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <4FDE845E-BDD6-45FE-98FA-40ABAF62608B@linux.dev>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.185]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500016.china.huawei.com (7.202.194.202)
X-Stat-Signature: w8443rdikse5aq37zs3ouagm5inq1iqj
X-Rspamd-Queue-Id: 393AF140005
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1772174373-994099
X-HE-Meta: U2FsdGVkX19msIGDgNAwafwjbAra1syV99IdGXW0+v7YiXs6+JoTw5FrJB/rBUocnFIUh08IPrKaEz/AQ3qW2ZxnWs/HmUyokUixDDdSuS+BhXhvKYcfRDdDniIfqgikg48UbGBM5Kd9RYjp1ThckB7neTQ0h8+Z07MzQmeDvs5DWPDul1VCEJUlV79m3S1IE3FboOtZou1XplWiS9QZZNzdrGMDUStINxi3QIN/RKDN8dJAQXRqQbEXw1QiHa73wmz4sZY29Q5IpsjkNGlJvO9spr93Ov3jpFc3wxC2zN7YJ++1Pec8laXzfO10huC0a8PfBYru+WiZb/UGK102EQbXAGwVoFsKsISERdOt96ASrI8SXrI5zZZei9Osx4mb+vKSwm/oi20Dl5er8IeVZ9n/T3eDG+zMbOksCm1ZaWe9wiFujpP7tpoVttKAYS8ifVercA1J7TIr9m2XTd1UzvU1OQs6kZ9LyFbepwrU4pWgtpnQHHCH9VpvwaoWC2Z6CLe91Z2w1B2M5GH5qe2ejff8EFFbZyu3rSfnltwHo0aEtG5A9CAjyP9prL4Ev0IAYvqL3wCCXq1mKZKybL7rOOf2gFlvavguRymUiA1BwIoP62GU3qTrG3keNUrqtF0vh0im7HD/d78tk0FBGUUOZsif9sVFqpPGkKQx1PsNHS36ElKcSMznn4xzARMkJbGAczk8Gds36Sch0WUSq4lQSb4Xm7TvnlysHJuoRciGfabL1BaLVB0pKivjp28VGOQPGa14fmaIQ6t1AnD3kmWwhq7mG3CvB7wJCWyl4l5V5EDQR/+9wEc8Nd6S2NjcC+pwo38zTwavglW0Q9edebAdgYXop6BdZ7wEcf0C3eE8Y6A++SpAkd/HvgnQJUXNKewdSSNzuqtEqlVNSOG2NdpMab6itDy7yN/AA3E5LjTZ7KIxef+U6AgyOMlIdo5mvAFRSZ590LUgh210RQ7ZLlJ
 il3dsJme
 QUcZ4r2yhNZtt5fUkI5x51Abi5zwmJafk+3sIAsoCqZBPxkjgfPDzKSensYGeJetPDgetx5G7Inj9SSMtYAkIVqkeFJgycU1b/t195rUoOxheA4rJreOiSHBqKKTE+ObJKFEbB0poF+zekpfpS6FbsKrbuMbbOy8nBhVbT8s+B5wYRJ2gGCHJ2v3c1bQR4SzqwEoWMyKLLwyMWNp5UwLwHfKn1pZ4t51fZMnH6qbmspsTH89A+hGTRrGAMr6QMWWlJb2rE6SIN58NSYluFRaQNoxHf/c74VKS0/U8kBl7KmRa4Mw2WKgr2ll+QpbipoN1fUe0MjbtBxA4e3D+QvJdNwq0g4uReOoprAHCvyr8+Hp/OQ4zEH6qijVh3P+tR/WqVc8YMK38SaQcaYpCw4IZuV6hGDtP5uzBodaXO397zKnikK1bLFLpo8QRC+rtycXwiMQ9r7m1Uw0CJnKXWzqMkCIcww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/27 11:31, Muchun Song wrote:
>
>
>> On Feb 27, 2026, at 10:55, Ye Bin <yebin@huaweicloud.com> wrote:
>>
>> From: Ye Bin <yebin10@huawei.com>
>>
>> In order to better analyze the issue of file system uninstallation caused
>> by kernel module opening files, it is necessary to perform dentry recycling
>> on a single file system. But now, apart from global dentry recycling, it is
>> not supported to do dentry recycling on a single file system separately.
>
> Would shrinker-debugfs satisfy your needs (See Documentation/admin-guide/mm/shrinker_debugfs.rst)?
>
> Thanks,
> Muchun
>
Thank you for the reminder. The reclamation of dentries and nodes can 
meet my needs. However, the reclamation of the page cache alone does not 
satisfy my requirements. I have reviewed the code of 
shrinker_debugfs_scan_write() and found that it does not support batch 
deletion of all dentries/inode for all nodes/memcgs,instead, users need 
to traverse through them one by one, which is not very convenient. Based 
on my previous experience, I have always performed dentry/inode 
reclamation at the file system level.

Thanks,
Ye Bin
>> This feature has usage scenarios in problem localization scenarios.At the
>> same time, it also provides users with a slightly fine-grained
>> pagecache/entry recycling mechanism.
>> This patchset supports the recycling of pagecache/entry for individual file
>> systems.
>>
>> Diff v3 vs v2
>> 1. Introduce introduce drop_sb_dentry_inode() helper instead of
>> reclaim_dcache_sb()/reclaim_icache_sb() helper for reclaim dentry/inode.
>> 2. Fixing compilation issues in specific architectures and configurations.
>>
>> Diff v2 vs v1:
>> 1. Fix possible live lock for shrink_icache_sb().
>> 2. Introduce reclaim_dcache_sb() for reclaim dentry.
>> 3. Fix potential deadlocks as follows:
>> https://lore.kernel.org/linux-fsdevel/00000000000098f75506153551a1@google.com/
>> After some consideration, it was decided that this feature would primarily
>> be used for debugging purposes. Instead of adding a new IOCTL command, the
>> task_work mechanism was employed to address potential deadlock issues.
>>
>> Ye Bin (3):
>>   mm/vmscan: introduce drop_sb_dentry_inode() helper
>>   sysctl: add support for drop_caches for individual filesystem
>>   Documentation: add instructions for using 'drop_fs_caches sysctl'
>>     sysctl
>>
>> Documentation/admin-guide/sysctl/vm.rst |  44 +++++++++
>> fs/drop_caches.c                        | 125 ++++++++++++++++++++++++
>> include/linux/mm.h                      |   1 +
>> mm/internal.h                           |   3 +
>> mm/shrinker.c                           |   4 +-
>> mm/vmscan.c                             |  50 ++++++++++
>> 6 files changed, 225 insertions(+), 2 deletions(-)
>>
>> --
>> 2.34.1
>>
>
> .
>

