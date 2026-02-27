Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 550DBFD5307
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 07:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 593026B0005; Fri, 27 Feb 2026 02:45:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5413D6B0088; Fri, 27 Feb 2026 02:45:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43FF76B0089; Fri, 27 Feb 2026 02:45:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C0BC6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:45:59 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD6A11A057B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:45:58 +0000 (UTC)
X-FDA: 84489452796.04.278C95D
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id C6F8014000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:45:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nlFmVCh2;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772178357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s+gsO7qzgl0YDvU8i4Ep8ulpnj6axpwVI6gbW4IwZ8I=;
	b=3+3KMBG6lEFhMDVKKnr1iHQj6D/5g+CUE5n4W8Kxm664Iy23aRYD6daWb0ICiAU92yx/98
	sVUWEwm7fwQz0/5W3tjQoMch1sgaUy5DQlhGlyOpGEeSZG/vfpLQXPt+aXJpmNLmyFaWDM
	DMsS35MomIRME5KBztM8KhcUXGHvj4I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nlFmVCh2;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772178357; a=rsa-sha256;
	cv=none;
	b=G6tUe4nW/NlyWy9WhH+x15Lcq9VeXZEHTvXLh2dOtyboSCKhZO/c+VYxunz++hRVVFwhN8
	8s+riAH7UdO7JmeA2uNX+DGrIjdW5+SDyNdSnzVMqoyhmXX+hy0R4upoxYMVd23AphyOhZ
	JZgihJai1aEcIgYCeR+v3PmPXuRC3sw=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772178354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s+gsO7qzgl0YDvU8i4Ep8ulpnj6axpwVI6gbW4IwZ8I=;
	b=nlFmVCh2sxoc/JMaV1J/eitKR9UJbtydFDZO2/o0zUmbXnqrMorkaR50QrpeceJ5z31xiP
	UmxUCI6HvC9JRgXUGHm42gtxi0EUGfEYdrjt+BalzXu8M0rgNilF/XmvDsS/SlKkGhDaNI
	p+h+9q3NsHwkUZW/DBhSIAcFGdXXthY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH v3 0/3] add support for drop_caches for individual
 filesystem
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <69A14882.4030609@huawei.com>
Date: Fri, 27 Feb 2026 15:45:02 +0800
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
Message-Id: <C63DBC11-B4CD-4D8D-9C09-E6A9F690FB21@linux.dev>
References: <20260227025548.2252380-1-yebin@huaweicloud.com>
 <4FDE845E-BDD6-45FE-98FA-40ABAF62608B@linux.dev>
 <69A13C1A.9020002@huawei.com>
 <959B7A5C-8C1A-417C-A1D3-6500E506DEE6@linux.dev>
 <69A14882.4030609@huawei.com>
To: "yebin (H)" <yebin10@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 67yqzf17nhxfzhme7c3douwt1d77ce49
X-Rspamd-Queue-Id: C6F8014000D
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1772178356-788597
X-HE-Meta: U2FsdGVkX188dpRrxW6A7egsZaaHAQppzOIJmJ2B3hrNclu4ynSrvy/VzvZi3X/qw+aSISEGiAnhx79bOZsM32Q7fYseBjAuAa8fnQYDTboLIkpcwCMQOeOZibEMv/rKkraQvbfG4NrVIMs9B1AuOjKlwpFFphNiBx6zeK18KyMAMN23N0j3zkHidSGZoxXYxDkkGQl9C0BJnLGsb5rtShiUE2PqD4GOoD0SWuUCPFWPdx1Ttq08P0tUf7XRakNyyzePIKjTaMY+hpxNC4gIt58Lu72SnXh4GGDOWydx0yC37IHIyWVzD5ny9d7H81izXcyaXwzQU5R2bzHpUdR2Im7WJrcXld/vLsqaTAkQxdYwDWHZ8jIyrOj+qaKrTR2gCxEq59fpkbbCUJ6wwUPDXMAldm6UsXAUaT40xJtkarTdmYHpWyN8JCLdP73L3aBV5p8Q4HJhydu2XptiLZapDHQBB91Pob2mMh+kQ/FYwveVZ/276n/OWCcxBMkFY7YGmPIQidIS7Qxgy8iOOagAH7YZAnS009SJdHOM4iPTp4UUeOYJyR4oeI5PrJYfJKYx6bzzrwlZ8PMfpoiP3uRCxdfsZr74jG1XIEdSykQ/g6UXKrpp/dKTq26rhz9SnY55GpahxQuwu5gkyAd6cUd2CBjGG2DMWRGEmq+/+ENRKFyr2kOc4M9vnNah5sPggQrBHi80HtHGNu/wNfL8TqF1JUjdr9AV7Thfh/DL7P8DwDv6DSNHDianq3El1NWjgZB18N7s4LHgAvbR23fZBlBi+/nmBc+jv1qZMlDkCIlhw6pg8E4dGzhMYyW358j6Kj/82qG6/ptyB3K6rdd6xPEYJBf1UktLFsih0d1JwihOAIElDaO6Tp9RgTa3efYNVpHMWH9gerrBXd4II6ovNL4O8hD68TjBnjBaJ3iVnScMoB0j+GUuefWFYT2GRziLZtscAkxAmMgnO/0caZ2AwHj
 NxAKngI4
 zhi5zZjKgs7d2Wodou+ipiHfvJb7LbPZF+FI/Tg3K7uqB07SjwbCbKh9math11QwGncBzyLyBX69t49NkyrXN3R7ecP9HGTVAZwqk2hL5MWe7NwNDtob2gzIUi4KXsMr1Eas4c0PFF/SDhU4D+8okQsUEl+Z4IKgI3g8IFV/3JXQZDhVr5mtMkC6Ehnqm2GSxgV/mpbdM5ZxGMks1VAqGh5+K5fIfwxtpP8YR6u9WY/r46OPBN+uo8aMuEb179BpxQFZQNht5Zlxn8XfkmVjOUOFIbSHf6zR34e2WizW34zMA4eEF0+n4Mcflon3HZQeC0jErfGV1hbl1/YJX/YNYzzfQyIrdovDZmeVzAtoqR1RWveCRoFaiZjouMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Feb 27, 2026, at 15:32, yebin (H) <yebin10@huawei.com> wrote:
>=20
>=20
>=20
> On 2026/2/27 14:55, Muchun Song wrote:
>>=20
>>=20
>>> On Feb 27, 2026, at 14:39, yebin (H) <yebin10@huawei.com> wrote:
>>>=20
>>>=20
>>>=20
>>> On 2026/2/27 11:31, Muchun Song wrote:
>>>>=20
>>>>=20
>>>>> On Feb 27, 2026, at 10:55, Ye Bin <yebin@huaweicloud.com> wrote:
>>>>>=20
>>>>> From: Ye Bin <yebin10@huawei.com>
>>>>>=20
>>>>> In order to better analyze the issue of file system uninstallation =
caused
>>>>> by kernel module opening files, it is necessary to perform dentry =
recycling
>>>>> on a single file system. But now, apart from global dentry =
recycling, it is
>>>>> not supported to do dentry recycling on a single file system =
separately.
>>>>=20
>>>> Would shrinker-debugfs satisfy your needs (See =
Documentation/admin-guide/mm/shrinker_debugfs.rst)?
>>>>=20
>>>> Thanks,
>>>> Muchun
>>>>=20
>>> Thank you for the reminder. The reclamation of dentries and nodes =
can meet my needs. However, the reclamation of the page cache alone does =
not satisfy my requirements. I have reviewed the code of =
shrinker_debugfs_scan_write() and found that it does not support batch =
deletion of all dentries/inode for all nodes/memcgs,instead, users need =
to traverse through them one by one, which is not very convenient. Based =
on my previous experience, I have always performed dentry/inode =
reclamation at the file system level.
>>=20
>> I don't really like that you're implementing another mechanism with =
duplicate
>> functionality. If you'd like, you could write a script to iterate =
through them
>> and execute it that way=E2=80=94I don't think that would be =
particularly inconvenient,
>> would it? If the iteration operation of memcg is indeed quite =
cumbersome, I
>> think extending the shrinker debugfs functionality would be more =
appropriate.
>>=20
> The shrinker_debugfs can be extended to support node/memcg/fs =
granularity reclamation, similar to the extended function of echo " 0 - =
X" > count /echo " - 0 X" > count /echo " - - X" > count. This only =
solves the problem of reclaiming dentries/inode based on a single file =
system. However, the page cache reclamation based on a single file =
system cannot be implemented by using shrinker_debugfs. If the extended =
function is implemented by shrinker_debugfs, drop_fs_caches can reuse =
the same interface and maintain the same semantics as drop_caches.

If the inode is evicted, the page cache is evicted as well. It cannot =
evict page
cache alone. Why you want to evict cache alone?

>>>=20
>>> Thanks,
>>> Ye Bin
>>>>> This feature has usage scenarios in problem localization =
scenarios.At the
>>>>> same time, it also provides users with a slightly fine-grained
>>>>> pagecache/entry recycling mechanism.
>>>>> This patchset supports the recycling of pagecache/entry for =
individual file
>>>>> systems.
>>>>>=20
>>>>> Diff v3 vs v2
>>>>> 1. Introduce introduce drop_sb_dentry_inode() helper instead of
>>>>> reclaim_dcache_sb()/reclaim_icache_sb() helper for reclaim =
dentry/inode.
>>>>> 2. Fixing compilation issues in specific architectures and =
configurations.
>>>>>=20
>>>>> Diff v2 vs v1:
>>>>> 1. Fix possible live lock for shrink_icache_sb().
>>>>> 2. Introduce reclaim_dcache_sb() for reclaim dentry.
>>>>> 3. Fix potential deadlocks as follows:
>>>>> =
https://lore.kernel.org/linux-fsdevel/00000000000098f75506153551a1@google.=
com/
>>>>> After some consideration, it was decided that this feature would =
primarily
>>>>> be used for debugging purposes. Instead of adding a new IOCTL =
command, the
>>>>> task_work mechanism was employed to address potential deadlock =
issues.
>>>>>=20
>>>>> Ye Bin (3):
>>>>>  mm/vmscan: introduce drop_sb_dentry_inode() helper
>>>>>  sysctl: add support for drop_caches for individual filesystem
>>>>>  Documentation: add instructions for using 'drop_fs_caches sysctl'
>>>>>    sysctl
>>>>>=20
>>>>> Documentation/admin-guide/sysctl/vm.rst |  44 +++++++++
>>>>> fs/drop_caches.c                        | 125 =
++++++++++++++++++++++++
>>>>> include/linux/mm.h                      |   1 +
>>>>> mm/internal.h                           |   3 +
>>>>> mm/shrinker.c                           |   4 +-
>>>>> mm/vmscan.c                             |  50 ++++++++++
>>>>> 6 files changed, 225 insertions(+), 2 deletions(-)
>>>>>=20
>>>>> --
>>>>> 2.34.1
>>>>>=20
>>>>=20
>>>> .
>>>>=20
>>=20
>> .



