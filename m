Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58D42FD4601
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 06:50:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5F4C6B0005; Fri, 27 Feb 2026 01:50:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0CB96B0088; Fri, 27 Feb 2026 01:50:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90BEE6B0089; Fri, 27 Feb 2026 01:50:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 788826B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:50:31 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0644313B257
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:50:31 +0000 (UTC)
X-FDA: 84489313062.07.718E349
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3D2CD40004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:50:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k3c5+5Dj;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772175029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJ7ts30l4mrTad+d0Hkes/PMYHLzhj3PuIrWDmD+Q50=;
	b=Tb70IX4m7ONtxU+sR3RSTQEb2paJ5LEYjjdlEEDelm8J7yBzijabppnnZ+fpbpEMElOsti
	E9Sbw10GcnVv+Ns6bV+2uU+MKVvqpevVEUghD6Pn/xtboYYyh3+2q859Gqi5BC1T9mocQv
	nAeMp1vq28CqqH1ZZTo8bYYVzzsp1kY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772175029; a=rsa-sha256;
	cv=none;
	b=0Bpxice46RzcrbyOnYH4WLKO04olczjH9ChOP6pHpFgv12ZY0q+VHqwHRinRGikDgJrAnv
	PyFQmIc9/PY2S4qlKilvWJusDOHMDZ6YdgjaIvqV8XjgJMBN2OOjS6YNK/IU3u64dCbY9z
	WkuPjPRd3T6ZWrWQyCo+1czZdFEdOH8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k3c5+5Dj;
	spf=pass (imf01.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <e4834869-4144-41aa-b370-9c4e6091322e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772175025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EJ7ts30l4mrTad+d0Hkes/PMYHLzhj3PuIrWDmD+Q50=;
	b=k3c5+5DjwB1axQckFpil6TTouQJgOeo5wNB67twv7enMbpueIbelLu3veNh6ERzkdVZX69
	BGyoxm+KfQbKH+kqSDSNnnNOCpurF8zGmiSg/v9MpBCSN71hQzB4TaVY758moJX7U0QPP9
	PoX+1OQi2OiadBTu4NzY0yPrAdc6OOM=
Date: Fri, 27 Feb 2026 14:50:17 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/3] add support for drop_caches for individual
 filesystem
To: "yebin (H)" <yebin10@huawei.com>, Muchun Song <muchun.song@linux.dev>,
 Ye Bin <yebin@huaweicloud.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 david@fromorbit.com, roman.gushchin@linux.dev, linux-mm@kvack.org
References: <20260227025548.2252380-1-yebin@huaweicloud.com>
 <4FDE845E-BDD6-45FE-98FA-40ABAF62608B@linux.dev>
 <69A13C1A.9020002@huawei.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <69A13C1A.9020002@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3D2CD40004
X-Stat-Signature: sdwrj8whm6yi9uymbsfh583twji3f9f4
X-Rspam-User: 
X-HE-Tag: 1772175029-895337
X-HE-Meta: U2FsdGVkX1+2tWZoLT9oksqYLlC5SzDEaDpFVtnj3nJ8ib+DsNIL3iq4AGHv8GySS77No5i4joT8M6Oh5HGVEfQUoGlxB1+Er4JcDmYcuPcIG0G/Ezo3p7OQIgbCvnvYk5Muti1qK28rHrtT+HlnBmipKIYdZpRJljSWlbcrGtOKel4F4LpKVjuSyhC2USDlHE81i8dM7UU7EAcXJuxDkr7Z13r+RqL547fFt1xMxafEJ67/WEaZ67Hf8mmLp9jEbHNqnMZ2rPw7EaBraOiMXJgA6vwnEupQ1W8kIaOj93Qx5ScqpnEXcMu/5r3SPWRj8mji3B+Mz2hh5636o63kqLkQGhO6wZdftxTKxa+iemv8Wmy2+PJp/VcfH/I4q2X3U7V2zMUYJ7d6KTmYwGI8bGEkZ72xcEWfCYv0Wt4Jzvh8Oyp2wtjfFz2mIQJBQNx9Q8hIfe8JfsyED952ptStR+VrqvI+1nPYPnP3QBb/7gv4pdMjh8HbMS8s7P1Fq/AIJ+7GutoQB2VXWqJjQZ3QVmBfABZhisZrwc6gwglamzPo4QQAP77GIx2lCwmRPIqVZ+U9czySzxAwvHKybp7TJ7jUZXMVMxgRBj/BZJE/WXpy4RbJa2f/mbOvSTkPaWFOt8NI9tO10yZ/JYTZDRGdK9JFThFKwet1h+rsnxnnjVpBFjJ3e+CMHyhE6zgg+b2pxMBPtfZgoPv88fylz4VzVQkGmCXcxw9qSgLov13oPH8lEZuawTbMxr3m7pf0lxz+EBtko9f//n1diwOeoD6yrhEjQ6DgLze0T92wFn1kcbiX/lvAScdUd4OA0ZgBRUbXW3XAVq/GmUDSY4tUkuPKenk8RoUrO1WxZIODcQuTL8dQ4hfl6BgqbjNuGT4sjJ9QfHDPoIgkctMOwcnqH8NBcAAUDWyxlrIFVI5uPS8ckVgMnkwDmOPRd9B3ZQPUFlBw3TN3QKtC9cmWYfySI1G
 BuW565V/
 mctMnnnqvuk1qwBHl4ViMBRJHikCaUGwG/pyxTm1XkbwAQ5UeEJ/UKk1W+EYYnnOhtHESdCMo9jAUEG4g2cAuKr+29Pf886Bkhr2YE7+KCjPsqEvNgaCjB6aj4zyr4bqY/DQbDmUJ5HZf+bKRNUdUb0NnpQygEwyy8ZMjIRoRdbgbsocng09Emzv34UDU0Mt9RkaxEtB2kj1FwKptvlc1Wh0lsrTPuHWsiVbDW/5R08vkyEqCg0eKaX1c9GQtZyPe1DFmWRLw+WhM1TXfcMmMcgYmd1Tc/51guYSMDHTE4cFMxfpfEJ8btWdJiQZNI7uq/xowboMam08UwHrHB7NWFSCzjoPfSmzEZ7iF7v9l9nnJMC4WU8s6SHruUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/27/26 2:39 PM, yebin (H) wrote:
> 
> 
> On 2026/2/27 11:31, Muchun Song wrote:
>>
>>
>>> On Feb 27, 2026, at 10:55, Ye Bin <yebin@huaweicloud.com> wrote:
>>>
>>> From: Ye Bin <yebin10@huawei.com>
>>>
>>> In order to better analyze the issue of file system uninstallation 
>>> caused
>>> by kernel module opening files, it is necessary to perform dentry 
>>> recycling
>>> on a single file system. But now, apart from global dentry recycling, 
>>> it is
>>> not supported to do dentry recycling on a single file system separately.
>>
>> Would shrinker-debugfs satisfy your needs (See Documentation/admin- 
>> guide/mm/shrinker_debugfs.rst)?
>>
>> Thanks,
>> Muchun
>>
> Thank you for the reminder. The reclamation of dentries and nodes can 
> meet my needs. However, the reclamation of the page cache alone does not 
> satisfy my requirements. I have reviewed the code of 
> shrinker_debugfs_scan_write() and found that it does not support batch 
> deletion of all dentries/inode for all nodes/memcgs,instead, users need 
> to traverse through them one by one, which is not very convenient. Based 
> on my previous experience, I have always performed dentry/inode 
> reclamation at the file system level.

Using shrinker-debugfs allows users to specify the size of a single
reclaim cycle (nr_to_scan), which controls the strength of each reclaim
cycle to adapt to different workloads. Can the new drop_fs_caches
support a similar approach?

Thanks,
Qi

> 
> Thanks,
> Ye Bin
>>> This feature has usage scenarios in problem localization scenarios.At 
>>> the
>>> same time, it also provides users with a slightly fine-grained
>>> pagecache/entry recycling mechanism.
>>> This patchset supports the recycling of pagecache/entry for 
>>> individual file
>>> systems.
>>>
>>> Diff v3 vs v2
>>> 1. Introduce introduce drop_sb_dentry_inode() helper instead of
>>> reclaim_dcache_sb()/reclaim_icache_sb() helper for reclaim dentry/inode.
>>> 2. Fixing compilation issues in specific architectures and 
>>> configurations.
>>>
>>> Diff v2 vs v1:
>>> 1. Fix possible live lock for shrink_icache_sb().
>>> 2. Introduce reclaim_dcache_sb() for reclaim dentry.
>>> 3. Fix potential deadlocks as follows:
>>> https://lore.kernel.org/linux- 
>>> fsdevel/00000000000098f75506153551a1@google.com/
>>> After some consideration, it was decided that this feature would 
>>> primarily
>>> be used for debugging purposes. Instead of adding a new IOCTL 
>>> command, the
>>> task_work mechanism was employed to address potential deadlock issues.
>>>
>>> Ye Bin (3):
>>>   mm/vmscan: introduce drop_sb_dentry_inode() helper
>>>   sysctl: add support for drop_caches for individual filesystem
>>>   Documentation: add instructions for using 'drop_fs_caches sysctl'
>>>     sysctl
>>>
>>> Documentation/admin-guide/sysctl/vm.rst |  44 +++++++++
>>> fs/drop_caches.c                        | 125 ++++++++++++++++++++++++
>>> include/linux/mm.h                      |   1 +
>>> mm/internal.h                           |   3 +
>>> mm/shrinker.c                           |   4 +-
>>> mm/vmscan.c                             |  50 ++++++++++
>>> 6 files changed, 225 insertions(+), 2 deletions(-)
>>>
>>> -- 
>>> 2.34.1
>>>
>>
>> .
>>


