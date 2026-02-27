Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C069FFD9E35
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 03:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06EA56B0088; Thu, 26 Feb 2026 22:32:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 018BB6B0089; Thu, 26 Feb 2026 22:32:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA8796B008A; Thu, 26 Feb 2026 22:32:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D27876B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:32:00 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B6FE160468
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:32:00 +0000 (UTC)
X-FDA: 84488812800.03.8260238
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf21.hostedemail.com (Postfix) with ESMTP id 796EC1C0006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:31:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=upLOXXJB;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772163118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nr4zyboFdAPQ3Cak33Bpk6ampsu5iWEcatVRj6UGzbk=;
	b=6YehUGV/pDjC0pljyE+R4gw6XQFP7A1xV1IjgcEvLQkdOM2LT/ckalbNbpsVqMo339uJFf
	R//nWjdVdrzO4TPJCLKiMk1k19/9jReJ1sbmW4Oc0CK2Eo2gNEZ7Dvbj37Up2McAu4WmUg
	0LZgpjcbdJ5WS3w1ZCEmH9E215jZkfE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772163118; a=rsa-sha256;
	cv=none;
	b=Ma6whtfxyzb9+Bg8ytO1AwonOTMuAtNspy/rm971GB9fK6tpvah8SdkNvvyus7Zn67neUo
	7XcU3xwwPGBrSq7j85mJQfc8Bgsh0LlI1HHr+ybPddnV0Pu0mluuvF1+xcKornCBxZ5m6C
	27yC0pJj+eNusaWMsAvrB7npPv2h4XE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=upLOXXJB;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772163116;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nr4zyboFdAPQ3Cak33Bpk6ampsu5iWEcatVRj6UGzbk=;
	b=upLOXXJB5UXrgeCQzrsGUxZEF1D3mrKy6Rj9kcUrj+82JPeXSw/miuAomPgutSLnzOce9l
	d6n97fFDvsQpw27NUesDKBVP/e1Ra/v49rzBWLeDFaXtLPcDDe4KU0zKEfwkcXMdgvib2R
	vl+2mbopA9te9KyKQuYniQDS8ShLqpE=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH v3 0/3] add support for drop_caches for individual
 filesystem
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260227025548.2252380-1-yebin@huaweicloud.com>
Date: Fri, 27 Feb 2026 11:31:14 +0800
Cc: viro@zeniv.linux.org.uk,
 brauner@kernel.org,
 jack@suse.cz,
 linux-fsdevel@vger.kernel.org,
 akpm@linux-foundation.org,
 david@fromorbit.com,
 zhengqi.arch@bytedance.com,
 roman.gushchin@linux.dev,
 linux-mm@kvack.org,
 yebin10@huawei.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <4FDE845E-BDD6-45FE-98FA-40ABAF62608B@linux.dev>
References: <20260227025548.2252380-1-yebin@huaweicloud.com>
To: Ye Bin <yebin@huaweicloud.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 796EC1C0006
X-Stat-Signature: fygphheo8j359jx4kd1jyamks3b9ecox
X-Rspam-User: 
X-HE-Tag: 1772163118-361103
X-HE-Meta: U2FsdGVkX1/KdVdhXk1Z+l9y59FGA3Zk/DYM9G4mXykKA5wfy8tclrDGHCCHCP/7f0Xu2AqhGrnjDgUrAKCxiJE0nbIzuk7jUbCg8YJObHszXmtJ/CQ5eNa8be4JgSTh8bpdZEd1Rs/rNQ8qpRc+G7M1zlY+c4O+JAhwtV8vyEbNi+8DJipP5dhbSoV7wnDHDkK0Y2kT9/Qk/jEr13SXvcQM35KNEpi0wdjPBqpn/gFWab8Snsa0JmG0gaobm44VMY0HD9GmEFlBCOj3RFI3RLTDWvfxksL5zem/UlyPUqs4pXtSc/zmsuauMK5n/E6IqCZPisLlb7LK9LftRQxguaAWq/v03WhAPIsNvDsdsBgG0veYTk/BMD/pMRidWbnwucfNZrJ/ahJzoWI11jIrd7dEtWLD+ryi+Nc9IWzk9iHrfHJ85i7GoIewrh59l09XcDv5jO2Q2fiMd1Oc2+SZ03JbrLfdIkV466QSoH44Sh08mCn2NbJDqgYzaL6JovLtYY50rR2WQyZsaqNcgjvlkJFlGsyDQNiubhvngAkl6lI7KZM8arqyYHS8rpOCJNJuSdBGCzobRbyceuqIJ4twUgAJhFjYx4fUPOya7eQNTK7MmAUCBnZffJ/zkGKEpYavYpKbyVOyTz7tVcuUc8eqpQg1FAV1FdausWGs9Bocu59SxYJsOnU4ts4OIjhOGR3AaNqrRNvCeCvQUMEJ8fTaufXuaS9FwBIYf9P0MoBQje1pvki0wX9H04nXes81njeT0A6QubcQHoUyD0tDruUa/sp3VUEcrlHCTFFA5onuYzvZTpG6IdqPfuogserGWWRKWmMaZKPbQnKAJqjjDyM/aAE2xcdxTcbiKCBLMlnLjAlfMRwy03sitYWroHgXHwFFK+KoODmLss7efNV9JWeR9WxcLLPy2AWfODuiEjgpQOzVSkerw5aCYtyy+PFGzXvWxpY2R2pWNQ2ql1op69z
 JU1EtIDK
 A4y704Eg7WWzoL3bCbL4E1MOpWuubC7rNqAGnSYwHx0S5y5UvbSBP1JDXOxaIQiaIYoSojjB3MX8ci9ZQQXC/649mADxnoIWCPu4/uxg1M1dAv4DvwhiF5c2D/arwJSNvi6iZedq6pzENYqUDv1TnY2tAIBbnyp09rhtd0sd0sRxQ6VUYjjH7IhlN0UHgYLnlU+E9sp6g/JfLwbIj4k2Oy3a/xBqiymObU9w9ap4gt+02uf+hq/fwjVFbz2jdV6zAVNnNaDxDJLpzGOgbXVFlmKQIF5XO+U5BIiQZTUDkrWpe4OCVSoW21kAuSc878Em+fK2+YuLpK1mlRwXUy7TMlP5ADjjEP9E45BmOgAsxQGfdm9ubJzrvFoBeCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Feb 27, 2026, at 10:55, Ye Bin <yebin@huaweicloud.com> wrote:
>=20
> From: Ye Bin <yebin10@huawei.com>
>=20
> In order to better analyze the issue of file system uninstallation =
caused
> by kernel module opening files, it is necessary to perform dentry =
recycling
> on a single file system. But now, apart from global dentry recycling, =
it is
> not supported to do dentry recycling on a single file system =
separately.

Would shrinker-debugfs satisfy your needs (See =
Documentation/admin-guide/mm/shrinker_debugfs.rst)?

Thanks,
Muchun

> This feature has usage scenarios in problem localization scenarios.At =
the
> same time, it also provides users with a slightly fine-grained
> pagecache/entry recycling mechanism.
> This patchset supports the recycling of pagecache/entry for individual =
file
> systems.
>=20
> Diff v3 vs v2
> 1. Introduce introduce drop_sb_dentry_inode() helper instead of
> reclaim_dcache_sb()/reclaim_icache_sb() helper for reclaim =
dentry/inode.
> 2. Fixing compilation issues in specific architectures and =
configurations.
>=20
> Diff v2 vs v1:
> 1. Fix possible live lock for shrink_icache_sb().
> 2. Introduce reclaim_dcache_sb() for reclaim dentry.
> 3. Fix potential deadlocks as follows:
> =
https://lore.kernel.org/linux-fsdevel/00000000000098f75506153551a1@google.=
com/
> After some consideration, it was decided that this feature would =
primarily
> be used for debugging purposes. Instead of adding a new IOCTL command, =
the
> task_work mechanism was employed to address potential deadlock issues.
>=20
> Ye Bin (3):
>  mm/vmscan: introduce drop_sb_dentry_inode() helper
>  sysctl: add support for drop_caches for individual filesystem
>  Documentation: add instructions for using 'drop_fs_caches sysctl'
>    sysctl
>=20
> Documentation/admin-guide/sysctl/vm.rst |  44 +++++++++
> fs/drop_caches.c                        | 125 ++++++++++++++++++++++++
> include/linux/mm.h                      |   1 +
> mm/internal.h                           |   3 +
> mm/shrinker.c                           |   4 +-
> mm/vmscan.c                             |  50 ++++++++++
> 6 files changed, 225 insertions(+), 2 deletions(-)
>=20
> --=20
> 2.34.1
>=20


