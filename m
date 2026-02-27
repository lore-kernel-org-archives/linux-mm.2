Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0A6DFD4601
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 06:55:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D927D6B0005; Fri, 27 Feb 2026 01:55:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40406B0088; Fri, 27 Feb 2026 01:55:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C22736B0089; Fri, 27 Feb 2026 01:55:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD3216B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:55:46 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5475C1C5A0
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:55:46 +0000 (UTC)
X-FDA: 84489326292.21.DB19CF6
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6329520008
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:55:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=umbhtIzr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772175344; a=rsa-sha256;
	cv=none;
	b=W1MYZSvKZw3cKtVMK4oOPVMmah3bmqEjbD9C2YVajbACPfh3Vtlv1pD8Jtz9TECJNCxRrH
	+jh92Hj9Iy8S5yxezrMb5ytCk1TrzDfdrZ4FWEEj4dQFifvOH30MyZA0K9wGbznnp/k7XD
	X8st//jGLfDxwUA3fSz9nhaiOAJgt7A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=umbhtIzr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772175344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=59f9kZ4QTS/rAqlXMkEZDqhsSG127NPeC7GDWClZ9lc=;
	b=BaWdxks9rtZqQydf5q2O+LkORwe9c/ZOhBJTC9lDv6NPvqkfEccyCvVQ5e0Jvld9+6Oy1a
	zI4rWjOtGZFoFZ/Tdtfwb1py1ICG1gc5GQuHE0Fh36dxmD/MuTI7khBYvyaFzShY3ZO69Z
	x2JLqYom2O0rSJUt4f6Ept5YhCN6CEo=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772175342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=59f9kZ4QTS/rAqlXMkEZDqhsSG127NPeC7GDWClZ9lc=;
	b=umbhtIzrqzO7voFpO99rC7TZTKDMQ2AjLNp/A5tCHMjlqOKxEVNsEDdUf/pVDTCrWC4eK0
	sNIgAUfCWrCpngy3O2HHd4QccUW5F01xyPDLzq6LyUjQxXvvcOlbsiSAYMHjnSPfyYsjj7
	8pkguaygaF/K20DTI7g6sP5oIqUT784=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH v3 0/3] add support for drop_caches for individual
 filesystem
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <69A13C1A.9020002@huawei.com>
Date: Fri, 27 Feb 2026 14:55:04 +0800
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
Message-Id: <959B7A5C-8C1A-417C-A1D3-6500E506DEE6@linux.dev>
References: <20260227025548.2252380-1-yebin@huaweicloud.com>
 <4FDE845E-BDD6-45FE-98FA-40ABAF62608B@linux.dev>
 <69A13C1A.9020002@huawei.com>
To: "yebin (H)" <yebin10@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6329520008
X-Stat-Signature: pa4ah8gkehznm5byuzjedzaazp3awmji
X-Rspam-User: 
X-HE-Tag: 1772175344-661343
X-HE-Meta: U2FsdGVkX1+nb5Bn8+b6oY2pis2+tmXaFpMnBze7sMegRzQL5+GJ9ivLZnD1nNO3oS4NfZv06lc1hdZ343JUESrxoLgRxAMIFt5g4g/lCRuoW0/Y5q6xir3Up8Ul8g77uu5I707/1NxF3+x0wQ7AvOBP6qDbpsD6+REKp13wztBPNg/M+UtN2gu/MuhdXwTriBedOc4nNzKXCjMsPWuGMf9WNdoM3pl8b6E84g4UPmSxuCqm6hqWit4bVBXiz/maFT3KStmi9jqVbm6Ow8XUGCCcEPuQKpEzA9JLrgT+TfiifPo0IhRLKwU/u9d3bUkKoIzJ2YYjn4fmduIP/tDLCJFAF2/2HaUE0uVaTH5dIN524p18Hzi2epfYehYVcNZM6h4M46zs+l/KjWHYlpp2gUDMr1OVNWE9DLBSX/qj7Rz0Ft5rBio3fAU3acJIKJc35fuFIri7stHcKLW3xFNoKt5yMMKfoCEp8tZD2L17EFKXn1UzCWIrXdaqRf28KhqXYvnwSQJCUONVO/0WsolcgtCfoQWDnWrLhgDgveG3Zk4/ZL5WTyP/9cXieTJxu3wnQxtQIE9QUJpO7x9kA27BplYC1Vw5ao15PuHUhKc57234hK1WAF0n2p3wzE/3aoKg3gSmKpjokvE0IJkmp+mBRQQL2hsPVE4leLS7XKXG2E8SdPFkbQ5NAXcwmOqRaILK7X0/fyue9rjj2c5Rgi7kv+E318yZYMj8omLY8y2wt16AR3Q5bl7wHHS5NRT2u7Ks/VGgHcNDdHYL1iloUPG2vN68NI5xE9VOPupavKgRDx+JmJ9g1oscyA67mnWSoCdwwQ4VJaidAA9LGeuVtIbBgd69i8nWweVCVT4B8OPfkte5HBjfnZiOCvg1UHLyDNday8roN1FRHXDyyPrdfuxJ3QuFTBeFuK0sFwKSiWDS6av+HRlP9mL7Sb1UkyioxBtq5sFHxz7WD8FVJx4s05H
 dGTnIV5W
 kx41ER4231Dx9dt5CymqkgqU6hNC7cXsjgrIkE/POhWBJugH+7UFnj162SBARr2IPhyG21PDzTo/fnsyPcWs60TertyVYvg60USU1QGypL+dBt5NDpuQARNkbYGZ2NJgudCECO3gEm/zd465nv1glJN5IbAxESvXZMG+bSvt4AxoWP1+kk3q28lYlKwgvM9jZd+YPGTd88uHFmYLOTKxdY3Qdehrsm/YJ64JXyAv5UbYg4pwHLk/9fIcsVqbA1/Mdo5tJNakQcARDkJVjiixeHNb4yDikR7sIdMH4my6KNfVEO3tcXXpzcAKJOISO9UNx2PplpQxZVyjoiyxDDpn4tPLH5ppG0Q0w5ZI61MQkGUDDFbhosPWxilDQPNbP5r7ekLKY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Feb 27, 2026, at 14:39, yebin (H) <yebin10@huawei.com> wrote:
>=20
>=20
>=20
> On 2026/2/27 11:31, Muchun Song wrote:
>>=20
>>=20
>>> On Feb 27, 2026, at 10:55, Ye Bin <yebin@huaweicloud.com> wrote:
>>>=20
>>> From: Ye Bin <yebin10@huawei.com>
>>>=20
>>> In order to better analyze the issue of file system uninstallation =
caused
>>> by kernel module opening files, it is necessary to perform dentry =
recycling
>>> on a single file system. But now, apart from global dentry =
recycling, it is
>>> not supported to do dentry recycling on a single file system =
separately.
>>=20
>> Would shrinker-debugfs satisfy your needs (See =
Documentation/admin-guide/mm/shrinker_debugfs.rst)?
>>=20
>> Thanks,
>> Muchun
>>=20
> Thank you for the reminder. The reclamation of dentries and nodes can =
meet my needs. However, the reclamation of the page cache alone does not =
satisfy my requirements. I have reviewed the code of =
shrinker_debugfs_scan_write() and found that it does not support batch =
deletion of all dentries/inode for all nodes/memcgs,instead, users need =
to traverse through them one by one, which is not very convenient. Based =
on my previous experience, I have always performed dentry/inode =
reclamation at the file system level.

I don't really like that you're implementing another mechanism with =
duplicate
functionality. If you'd like, you could write a script to iterate =
through them
and execute it that way=E2=80=94I don't think that would be particularly =
inconvenient,
would it? If the iteration operation of memcg is indeed quite =
cumbersome, I
think extending the shrinker debugfs functionality would be more =
appropriate.

>=20
> Thanks,
> Ye Bin
>>> This feature has usage scenarios in problem localization =
scenarios.At the
>>> same time, it also provides users with a slightly fine-grained
>>> pagecache/entry recycling mechanism.
>>> This patchset supports the recycling of pagecache/entry for =
individual file
>>> systems.
>>>=20
>>> Diff v3 vs v2
>>> 1. Introduce introduce drop_sb_dentry_inode() helper instead of
>>> reclaim_dcache_sb()/reclaim_icache_sb() helper for reclaim =
dentry/inode.
>>> 2. Fixing compilation issues in specific architectures and =
configurations.
>>>=20
>>> Diff v2 vs v1:
>>> 1. Fix possible live lock for shrink_icache_sb().
>>> 2. Introduce reclaim_dcache_sb() for reclaim dentry.
>>> 3. Fix potential deadlocks as follows:
>>> =
https://lore.kernel.org/linux-fsdevel/00000000000098f75506153551a1@google.=
com/
>>> After some consideration, it was decided that this feature would =
primarily
>>> be used for debugging purposes. Instead of adding a new IOCTL =
command, the
>>> task_work mechanism was employed to address potential deadlock =
issues.
>>>=20
>>> Ye Bin (3):
>>>  mm/vmscan: introduce drop_sb_dentry_inode() helper
>>>  sysctl: add support for drop_caches for individual filesystem
>>>  Documentation: add instructions for using 'drop_fs_caches sysctl'
>>>    sysctl
>>>=20
>>> Documentation/admin-guide/sysctl/vm.rst |  44 +++++++++
>>> fs/drop_caches.c                        | 125 =
++++++++++++++++++++++++
>>> include/linux/mm.h                      |   1 +
>>> mm/internal.h                           |   3 +
>>> mm/shrinker.c                           |   4 +-
>>> mm/vmscan.c                             |  50 ++++++++++
>>> 6 files changed, 225 insertions(+), 2 deletions(-)
>>>=20
>>> --
>>> 2.34.1
>>>=20
>>=20
>> .
>>=20


