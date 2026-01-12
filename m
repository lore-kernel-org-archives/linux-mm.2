Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ECF7C9EC77
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 11:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CF996B0088; Mon, 12 Jan 2026 06:25:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D906B0089; Mon, 12 Jan 2026 06:25:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77BD46B008A; Mon, 12 Jan 2026 06:25:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 629246B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:25:35 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 068B51A0A7F
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:25:35 +0000 (UTC)
X-FDA: 84323081430.12.B4B52FB
Received: from sg-1-104.ptr.blmpb.com (sg-1-104.ptr.blmpb.com [118.26.132.104])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3199014000F
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:25:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=hJVyVO0R;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.104 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768217133; a=rsa-sha256;
	cv=none;
	b=mWa6ZwYqALntXeO1TPUarFsWzUiODZe5CROcqu5ZODkD2sz7z+5wLS/jtZRmqPEb28JpMA
	K6jqglv6WcCkEsUbbTgT0xrGoG59b2gIE6UFysAcTHH8B0EMn7lIgBQlaRoEnWDqzHK6xK
	hszfFK0/UTZxcz8x79Tl3S7Iuf/Q9bA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=hJVyVO0R;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.104 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768217133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKOFO+CVnEuIl8zNfRXLDOzkoUcRZtrcrnTCMRJl+qc=;
	b=ha7Ub3XJhjLv8oF0pS0y+YpkMMytm0UMsemLve/4Le4O/qgJrooLAQQ2SmUwHHLcUvT/jP
	KrHekT/XzYrJiWnW+IYc30xLdD5y/rMByzEkvjzaN41NnUyg5dYFg3NhHdku1bEQ5HRI/p
	2TRj0LjFo3Q7qTMhhGYziQCgHuEB9dE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1768217125; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=tKOFO+CVnEuIl8zNfRXLDOzkoUcRZtrcrnTCMRJl+qc=;
 b=hJVyVO0RA6tDMOWLz8MlQ50l9O1lpGAC3v/RJeviujZWkRayAZk3wuW9JmlGMvnjwIwlYF
 jkjSy5Obzd9hu25EGylYOz6pKhOzerC9xW0Q4ciitzXQzdYf7oqialsSg2kGHMHnE/affd
 f99hlVRm8NofmY7+0T+X1rGT/ivXlClroLOeYR9TxQRFgQ5Oc5lGfeSkwvnaX4MNyMsaYe
 vyXP7FgC1KfD6H87TjEP5/zDFOG0dV2IZZjS+QhCt5VboSbFefgLepS/uRuRgwgc339zPj
 2Gk5ZYhanHQXz8VVSTqWZ575qTfC146z4vo++t8eg1cy3Hppp1QGIUP1B0agMQ==
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26964da23+d26472+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>
Date: Mon, 12 Jan 2026 19:25:09 +0800
Message-Id: <20260112112509.94521-1-lizhe.67@bytedance.com>
In-Reply-To: <20260107081921.0e189904060f49a555142e28@linux-foundation.org>
Cc: <david@kernel.org>, <fvdl@google.com>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>, <mjguzik@gmail.com>, <mhocko@suse.com>, 
	<joao.m.martins@oracle.com>, <ankur.a.arora@oracle.com>, 
	<raghavendra.kt@amd.com>
Mime-Version: 1.0
References: <20260107081921.0e189904060f49a555142e28@linux-foundation.org>
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nujac5qqpk66pqcqzeki39nr1rqwpf8u
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3199014000F
X-Rspam-User: 
X-HE-Tag: 1768217131-429243
X-HE-Meta: U2FsdGVkX18RSK79kNSdR6jNaFooty16o72s8Esnpj/u8BVuOs7xBdo1PS0bmBiM3swAkz0WabXvB2W8rHN2HTavf8n0sI+rfOInfpZy0Eb2aIZv+9GuOASXECuoiFphDWCe5IBGc/8T7LQpwkdXUfNKMrJsLJ1okPYTTlrd3we8Xgw20+gqf/sbNo51DzN7IXnRL3OXVMkttVYDLbCC0ISMx4Zp+DPvCP4vDga1htYLzw61H6AtC4kqXB8R84rR0vNPJ4iAzZaf0aisInOMQvPNV4n425ODBCC+EXjPRZ2zRDvKT6/n9G9uhAOPSm+sxyIUT9a/s3i91hzvBcJejngmt6foSMLmPOTjA52vomu0h16iKYEkWclyzKjV2+1rnxzXTRLBXGgD1UdlcwGQ6CTKgwEQUwRRPl/ax14mbM5Dujliudk37RGiIbfEt1NGSIcxJ8wCY/ms9+RvBvUk18F/t3FMOtKFwkbbmPxc/Ues9nG+D4Gl5eUzD/Bwbvr/AbY4wQzWdQ/jOIUJCez1v1bDHa1pIHafWAEwRPxfbiy6QFtXoF5RDplPxxorjmaJHL2GYIairvZUWLYCnFkM2GtDUSuh2+CkYoL/593G5zpazpvGYu1uaEOX0Sb8+z1FtKdYRxWDlsLCsrWEfTGlI90tLUyHsAZd07WZpXwQcoVU8Ssyk0aqOMoPTr9TEs+/99szooKElPoWmK+MvKF+7EDb8zdGvwDEp3WE5bxQ91Ed9cF0Ca7fwkHP3Wb/kVNyhpC4an4Zejsuhx3+AnAcIaaUUvuqu4sDo91wiE+a+XiuULV1Yn++gzCfYzpjOopM4UNKwGALkN715pbbvd+vTjFVLT8jXSBxTd84CTDkI3lLJfFCHdav7OkULfUngReuHlQUz5KGCRZXeEEDJ22tUMBL9UZpXA/1XzWsfRVuijxeFTt77FRuHlrTaF11W/6dLr7ezZweiWQY5r5PWtb
 uhKmLdX4
 tQaxxuTxdW9CfabceGELoCIJHLgl3r4mVqUSi8IAb10nfBj0NRuHqljInMRCu61zIFbdF+cJGL/zPwBWCRKuu+pG3A6JU+ci3lUlR1VZycGwmqBpXTBPstON/yqD2KN685nx+tWo0v2P8jOZhto7gEJ4AGsuJ3Z2fOCaTm5Ym11YMUig4++/roe9E9pfjh7VJb4IzkX69dSksTdviVvqRWOHNh9nJDrQpTISjIJLwKP5QC6U+TQO7wbF78EdVOwcOYR1lKSqP/BEmMJlgYwxfURzLWFhRHOjElTShlLG5dIzW4kc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 7 Jan 2026 08:19:21 -0800, akpm@linux-foundation.org wrote:

> > In user space, we can use system calls such as epoll and write to zero
> > huge folios as they become available, and sleep when none are ready. The
> > following pseudocode illustrates this approach. The pseudocode spawns
> > eight threads (each running thread_fun()) that wait for huge pages on
> > node 0 to become eligible for zeroing; whenever such pages are available,
> > the threads clear them in parallel.
> 
> This seems to be quite a lot of messing around in userspace.  Perhaps
> unavoidable given the tradeoffs which are involved, and reasonable in
> the sort of environments in which this will be used.

Apologies for the delayed response. I share the same view.

> I guess there are many alternatives - let's see what others think.

Let's cc the developers who took part in the earlier discussion and
see whether any better ideas emerge.

> >  fs/hugetlbfs/inode.c    |   3 +-
> >  include/linux/hugetlb.h |  26 +++++
> >  mm/hugetlb.c            | 131 ++++++++++++++++++++++---
> >  mm/hugetlb_internal.h   |   6 ++
> >  mm/hugetlb_sysfs.c      | 206 ++++++++++++++++++++++++++++++++++++----
> >  5 files changed, 337 insertions(+), 35 deletions(-)
> 
> Let's find places in Documentation/ (and Documentation/ABI) to document
> the userspace interface?

I believe this userspace interface should be documented in
'Documentation/admin-guide/mm/hugetlbpage.rst', and I will include
this update in V3.

However, I noticed that no document under 'Documentation/ABI' explicitly
describe the interfaces under directory
'/sys/devices/system/node/nodeX/hugepages/hugepages-<size>/'. Instead, it
points directly to 'Documentation/admin-guide/mm/hugetlbpage.rst' (see
'Documentation/ABI/stable/sysfs-devices-node').

Given this, is it sufficient to only modify
'Documentation/admin-guide/mm/hugetlbpage.rst'?

Thanks,
Zhe

