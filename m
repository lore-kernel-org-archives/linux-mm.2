Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C19AFFD530E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 08:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F421A6B0005; Fri, 27 Feb 2026 03:28:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEF6C6B0089; Fri, 27 Feb 2026 03:28:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC4086B008A; Fri, 27 Feb 2026 03:28:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C94B06B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:28:00 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6CC3F1A057C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:28:00 +0000 (UTC)
X-FDA: 84489558720.05.73E2C08
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5E47040004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:27:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oXsvCypf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772180878; a=rsa-sha256;
	cv=none;
	b=hupJwycWmAKg+GjonTOH0I58UaEmKlgKPNjcBIyUBTyEf6P8WESqWI7ltQX+y+4ROAcMdc
	q1H8bOlzuc0SJNzIH3TCAZT8fvXAzzQ8LngFz0u5OtSrZ+g3CTVQ7poUC2BLxGadTNKPVm
	/sfw28rX520UYaM0A1Zc7EoaQaehGLY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oXsvCypf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772180878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pYGSEvnS8api4yyTvRackPp/95vnLHXx6MYWXk9I9+4=;
	b=8qd/u1FrsK/IREzT/ZxErLsNmMMSoUmUAfEhTL9wL1tUIMX1uWD7kAkaStK2GBhqcDblOX
	x1kEaLiYiCCxob0KMfxAfMOZGvMVGluPODpVusemz/ELKO2VuIRyVuIaPacyfHgsLo5m7g
	bbfhuOF0W0z7s0T3iqDSPHMdPHuUA04=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772180876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pYGSEvnS8api4yyTvRackPp/95vnLHXx6MYWXk9I9+4=;
	b=oXsvCypfA2YDihEQXRbhd4EXgO9FbAFl0EcjFZIH18y7qokq6WbbDvWGmwSAWO9V/pB90X
	Lb87p545rrUn7pO2cC0nkmhKx2M11/iPtWhoIOzqRwgwIxXk8A9u0YANDiEXfjweDRMLPP
	XjykPCSkdtSsBYacoa5N6O9M3U0rlRw=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH v3 0/3] add support for drop_caches for individual
 filesystem
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <69A15314.3080602@huawei.com>
Date: Fri, 27 Feb 2026 16:27:13 +0800
Cc: Ye Bin <yebin@huaweicloud.com>,
 viro@zeniv.linux.org.uk,
 brauner@kernel.org,
 jack@suse.cz,
 linux-fsdevel@vger.kernel.org,
 akpm@linux-foundation.org,
 david@fromorbit.com,
 zhengqi.arch@bytedance.com,
 roman.gushchin@linux.dev,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <57055A1C-0684-4B77-80ED-4A641F262792@linux.dev>
References: <20260227025548.2252380-1-yebin@huaweicloud.com>
 <4FDE845E-BDD6-45FE-98FA-40ABAF62608B@linux.dev>
 <69A13C1A.9020002@huawei.com>
 <959B7A5C-8C1A-417C-A1D3-6500E506DEE6@linux.dev>
 <69A14882.4030609@huawei.com>
 <C63DBC11-B4CD-4D8D-9C09-E6A9F690FB21@linux.dev>
 <69A15314.3080602@huawei.com>
To: "yebin (H)" <yebin10@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E47040004
X-Stat-Signature: 4b3mu7y5anz1d81ydi4xm8njksqbat7o
X-Rspam-User: 
X-HE-Tag: 1772180878-668212
X-HE-Meta: U2FsdGVkX1/tLXXCfmd5HSoG5zBxX1p06eYM/UG6x1sTj0rTIb3wJWNZO8dHv1GBnxw+saPFoEPt2HvHvBTwcVvraakVdfTb5zaMe2rbrlAVDwog+K5DOb+GIkfSutjPrJT//K/4Hqih41eV1nRjxRyOnRyYeLY/uNwkYRkgwi1NN0dGB1yPsPrhftu0AXxrY3YMJy/oFVZWylcQrWTWB98btD+jM6U6AggGtwGGfBaEGRN61KWug52Dpa/01G/G9tQY9LmiLlOcACp/OvYITZGhdqOqz2qAfc2djpopMwqCq6FJHgvvDiOWw872d0g/oBlXItJm6+WrK+2DazNk8GPfGPjPsLo/15qOI8o/CMKUCydWcx2/fjdYmBvo85qwhNBzEq7949Z0qeasSD/r3ASSJndhG34goQXz5QRw3HtRL6vPSkNVrpaw+sSXwXl8E/E/bjoReMePZwDEesiHZ7d9QKtnNtUNXui/Q0/65dMuWCS5I9WTMBEXRXcZf36s/QKShMvyvWEWNx+iOrlMBFpOdc3Y82fXUv8zKe9jS5n0Mf5PTZkfTNdk2Vh11MnbTtvT5P4y/96z8EuBugz/JmkDqKgNpv8ecNJpzef6SgIp+WJtQSUjGvsAV8PWs21BjhLpnUIPLLDUgSWpVjiLj2S4j0N3kkSNNS78hA3RFt7CgjadQQEXNbfYV4hX9urNJFTcNat+DhnLclOEStDM+0RnfixsWMnhxVr4ncY6neP9DjhKoZOEGzKMsljfQXci+b9dDILqjq3hI9gDyk2Y91vMyARrt10r5GBaj4r6g8syKi8W2EeoEjZJollMQIaYC7d+AU4iMk2c5n82K4YkCVY58KrkeplIN9mhplY8x0OVllFVr00F22J7NZPSNzPN1QJ869e9eAH6D4y/eQIxd9fbzrWXrdIn6ktDhq6hfPmb5//1+dHjH/XQZichbXl/41fiLfziTquOGkGfR7I
 XsKzXE/o
 JrHAOLBZ6oGjCdRAonJ31doem7yKnw0+onb0QJEbwZcRt+yHQ6skUtjke+ADJYVPhBssKkQO+5sK7yeyolVSs8d4Dd/LkKxbwK1gZqBG4xQ6BIngJ6gcnIofvnHddCsWs7hT/nrQKnNAQqSMV6n3/zLZv8kncOIOrNVJG9c9hYKOAmw1Rcwp/Hp4AsSgR462N1wWYTkK+AWVrT2imJzoJk6/1tZjHjZaAItPez4g1SU/V5HYnPsx5eQS0/17Qvt1v+AlSzIiSfycK8X/Xv+MefrO6YVpninjnomSijLJ5N3M9UVhtlyu/C3XKHlbXtPqdR7735Xm5c0arSdS2WigyA0ToTGKytsnDm6TezJDO5Jhk0OjKrAjr9zoPPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Feb 27, 2026, at 16:17, yebin (H) <yebin10@huawei.com> wrote:
>=20
>=20
>=20
> On 2026/2/27 15:45, Muchun Song wrote:
>>=20
>>=20
>>> On Feb 27, 2026, at 15:32, yebin (H) <yebin10@huawei.com> wrote:
>>>=20
>>>=20
>>>=20
>>> On 2026/2/27 14:55, Muchun Song wrote:
>>>>=20
>>>>=20
>>>>> On Feb 27, 2026, at 14:39, yebin (H) <yebin10@huawei.com> wrote:
>>>>>=20
>>>>>=20
>>>>>=20
>>>>> On 2026/2/27 11:31, Muchun Song wrote:
>>>>>>=20
>>>>>>=20
>>>>>>> On Feb 27, 2026, at 10:55, Ye Bin <yebin@huaweicloud.com> wrote:
>>>>>>>=20
>>>>>>> From: Ye Bin <yebin10@huawei.com>
>>>>>>>=20
>>>>>>> In order to better analyze the issue of file system =
uninstallation caused
>>>>>>> by kernel module opening files, it is necessary to perform =
dentry recycling
>>>>>>> on a single file system. But now, apart from global dentry =
recycling, it is
>>>>>>> not supported to do dentry recycling on a single file system =
separately.
>>>>>>=20
>>>>>> Would shrinker-debugfs satisfy your needs (See =
Documentation/admin-guide/mm/shrinker_debugfs.rst)?
>>>>>>=20
>>>>>> Thanks,
>>>>>> Muchun
>>>>>>=20
>>>>> Thank you for the reminder. The reclamation of dentries and nodes =
can meet my needs. However, the reclamation of the page cache alone does =
not satisfy my requirements. I have reviewed the code of =
shrinker_debugfs_scan_write() and found that it does not support batch =
deletion of all dentries/inode for all nodes/memcgs,instead, users need =
to traverse through them one by one, which is not very convenient. Based =
on my previous experience, I have always performed dentry/inode =
reclamation at the file system level.
>>>>=20
>>>> I don't really like that you're implementing another mechanism with =
duplicate
>>>> functionality. If you'd like, you could write a script to iterate =
through them
>>>> and execute it that way=E2=80=94I don't think that would be =
particularly inconvenient,
>>>> would it? If the iteration operation of memcg is indeed quite =
cumbersome, I
>>>> think extending the shrinker debugfs functionality would be more =
appropriate.
>>>>=20
>>> The shrinker_debugfs can be extended to support node/memcg/fs =
granularity reclamation, similar to the extended function of echo " 0 - =
X" > count /echo " - 0 X" > count /echo " - - X" > count. This only =
solves the problem of reclaiming dentries/inode based on a single file =
system. However, the page cache reclamation based on a single file =
system cannot be implemented by using shrinker_debugfs. If the extended =
function is implemented by shrinker_debugfs, drop_fs_caches can reuse =
the same interface and maintain the same semantics as drop_caches.
>>=20
>> If the inode is evicted, the page cache is evicted as well. It cannot =
evict page
>> cache alone. Why you want to evict cache alone?
>>=20
> The condition for dentry/inode to be reclaimed is that there are no
> references to them. Therefore, relying on inode reclamation for page
> cache reclamation has limitations. Additionally, there is currently no

What limit?

> usage statistics for the page cache based on a single file system. By
> comparing the page cache usage before and after reclamation, we can
> roughly estimate the amount of page cache used by a file system.

I'm curious why dropping inodes doesn't show a noticeable difference
in page cache usage before and after?

>=20
>>>>>=20
>>>>> Thanks,
>>>>> Ye Bin
>>>>>>> This feature has usage scenarios in problem localization =
scenarios.At the
>>>>>>> same time, it also provides users with a slightly fine-grained
>>>>>>> pagecache/entry recycling mechanism.
>>>>>>> This patchset supports the recycling of pagecache/entry for =
individual file
>>>>>>> systems.
>>>>>>>=20
>>>>>>> Diff v3 vs v2
>>>>>>> 1. Introduce introduce drop_sb_dentry_inode() helper instead of
>>>>>>> reclaim_dcache_sb()/reclaim_icache_sb() helper for reclaim =
dentry/inode.
>>>>>>> 2. Fixing compilation issues in specific architectures and =
configurations.
>>>>>>>=20
>>>>>>> Diff v2 vs v1:
>>>>>>> 1. Fix possible live lock for shrink_icache_sb().
>>>>>>> 2. Introduce reclaim_dcache_sb() for reclaim dentry.
>>>>>>> 3. Fix potential deadlocks as follows:
>>>>>>> =
https://lore.kernel.org/linux-fsdevel/00000000000098f75506153551a1@google.=
com/
>>>>>>> After some consideration, it was decided that this feature would =
primarily
>>>>>>> be used for debugging purposes. Instead of adding a new IOCTL =
command, the
>>>>>>> task_work mechanism was employed to address potential deadlock =
issues.
>>>>>>>=20
>>>>>>> Ye Bin (3):
>>>>>>>  mm/vmscan: introduce drop_sb_dentry_inode() helper
>>>>>>>  sysctl: add support for drop_caches for individual filesystem
>>>>>>>  Documentation: add instructions for using 'drop_fs_caches =
sysctl'
>>>>>>>    sysctl
>>>>>>>=20
>>>>>>> Documentation/admin-guide/sysctl/vm.rst |  44 +++++++++
>>>>>>> fs/drop_caches.c                        | 125 =
++++++++++++++++++++++++
>>>>>>> include/linux/mm.h                      |   1 +
>>>>>>> mm/internal.h                           |   3 +
>>>>>>> mm/shrinker.c                           |   4 +-
>>>>>>> mm/vmscan.c                             |  50 ++++++++++
>>>>>>> 6 files changed, 225 insertions(+), 2 deletions(-)
>>>>>>>=20
>>>>>>> --
>>>>>>> 2.34.1
>>>>>>>=20
>>>>>>=20
>>>>>> .
>>>>>>=20
>>>>=20
>>>> .
>>=20
>>=20
>>=20
>>=20
>> .



