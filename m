Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2C69CA5FE9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 00:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43EFB6B0005; Sat, 17 Jan 2026 19:57:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EC7F6B0089; Sat, 17 Jan 2026 19:57:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EECC6B008A; Sat, 17 Jan 2026 19:57:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2966B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 19:57:27 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A88BF590CF
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 00:57:26 +0000 (UTC)
X-FDA: 84343271292.26.542C82A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D726440004
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 00:57:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=n8OmmJFe;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768697845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ZISGmpg9Alqh0mGCDBxFAobtAbGrkKE2QeSfFQVzM4=;
	b=N4CdiB9n9vxI8hqaBBF8f8l8KmYZvvcADtw+Rt6OO4+Ddd9IHXB5PB0KKu3/V/R6l60tUn
	VcNRUluV/2bPHKxH4z37z5OunOgpKiXSWU4cZEpNZYpFyiBpPUV0C09fIlzgGsDEwvsPx3
	aVLShkic5NPZYVnmF7pZtStyv+7a3UY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=n8OmmJFe;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768697845; a=rsa-sha256;
	cv=none;
	b=a2kAWTG7xEEwXfrWzuBAUnfSz3ceXJU2cM0dDa0TKgIN1yA4lmFEWtJg9jfWQCYj7t0ibr
	RgoXpZqCcZud+EQ1L2S+0RroS9hNSMgtHOSHq3vPLl4lsDupdKu+k4avz/eOPqRKlgwUkl
	0Qd/A1LaiOwSjVgd8RnGEpHaio+b2z0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A5F1B40911;
	Sun, 18 Jan 2026 00:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17332C4CEF7;
	Sun, 18 Jan 2026 00:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768697843;
	bh=+qlEcociOsXhFIAAdcAIVtM1BeAAOHRNXsXknKhk1Ls=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=n8OmmJFeegpmjTXfCuPr2nsg2Ue6kyfKGMGToVw4/bRZTybt/tEyM8TIi4ilXkN/o
	 qTY7n2OxXZpNLddYJZCg32+yFIOXNJXnUtSjF6bL8Bpn/PQ9MNGJoAcI45Wt01Sbrp
	 EGUMyYxytM7ELn4tlZqNLM9//8orztSXrFJ9YIGQ=
Date: Sat, 17 Jan 2026 16:57:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+079a3b213add54dd18a7@syzkaller.appspotmail.com>
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org,
 muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 syzkaller-bugs@googlegroups.com, Johannes Weiner <hannes@cmpxchg.org>,
 Muchun Song <muchun.song@linux.dev>, Deepanshu Kartikey
 <kartikey406@gmail.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [syzbot] [cgroups?] [mm?] WARNING in memcg1_swapout
Message-Id: <20260117165722.6dc25d72fd58254cb89e711b@linux-foundation.org>
In-Reply-To: <696b56b1.050a0220.3390f1.0007.GAE@google.com>
References: <696b56b1.050a0220.3390f1.0007.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D726440004
X-Stat-Signature: q1ox6bjwt8q3kw8cm4rfgswj8s4za5mk
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768697844-155069
X-HE-Meta: U2FsdGVkX1+L1lDrvKikqMSQ12/0J+nJNVcWj3VM2WF1uZfyVQiWpahqhZc+TF7nTDkux3zPYggOnIJfoaJNWH+ySLX8kWqUU7jJ4v+SkGSZog7UYomxBXce4jqgahpzsOgyFCsLzQMUCySiPXXbWrZcwy8S97OVtEaxgK+A4BNFNkP9QgS9mi33j2Ho0+EA53li1v4/rRXMLCfrh6GwHB+7BWL8/a/N8IsObGMq70l1t81vhHTcBugqxGIHxhpzSM9huPPHZbYVvf/s73NLZHcMAMzuQ+ym43iBAn1clxd30jwT+PbMSx/cqOzThE4nhHUSi3iacvqAYJCuZuAkuXezJurUdZ2G8IQPk61AOOkAchicp33PS3uB/iiTHyGhLxP1QHFrpQ48YpjEwVofqlvBSHDR4Gpl+8rPl0770745CGNGiQ5IQDRSGLRPXLpE6WF5rumhNuSSUir/TESK3LCLbRsr7iFPOn++5smT7ajPuqYphTayzldD9rPnSWOLny7WqcuxCp/vL81DYS6k3w4f/F+klT0rttd2xrP350PRVeqWzeK3HkhsiOCD0wqP5x1vHFPoiWbx992W/yTPw2XvGUXlItiREl9+vi5HpNzvvaBGvmsEkRZD3cIcJbtWq1Xe7mpiIkjokOfCIFkhxcGXHgeOdN30UqV2QMpnIMXM5dbffJ1wRjEOUOqVC7LolLvc7xovb/VtMzErlFuHvaZFQvbHD4RN0Tvtm/l3oL/IXvo1vxenuWEq+QOfUOqxlvAjRo5SPMO4a7wX/nFuJIKjUBrhx8j0RfOxr9dbZpSz9v/Jl9cwPN8X94wWUK7IKztLBoxpy7N86hd6CCVfuLwYq+HRajmbWM4WXW//E+o10WulFaF5JH10MCm2WiMAYkqXcb3CiQC01uTDdz6WmSDk6Sow/LhirOb22dp2AK17TGOuMeoqJAn9wvGhQmcx70XFC5Rv8KtzU3QC5af
 Z/MyWg/1
 ansomehO3EgSxRsAAh7wL0ZCFFNe2O5pSRU9nbhQMFEFfKbmYaZ7WsjrOriEAG4NOF1pJM10s3zz67bx4Hs2Sp7ZhkuYniNffc/+dyGyuId1S5UXgpCqg/J6UYrQeJrO40pj2Xiln0sk1RhKuFUbj0t4LHOcpMSojUWECBM9vRiCfKgsy7oWl0HdYxvOR3mHsYUg/6kJbNGyJpA7l8zY0uLlnHXDPDynIM3qRiGpJgVDLC9ycWQDGKOIULAQVQKJ5D4oZ1mUnvEenT526ft74xFIVNt7H8jxMSfc/o4fLFufcE1qvEWrpEw7MQkWMMeULl9mXjR4yjTTFPI5qxEoIEgNt8m5u7pEkuyd42XkbRLILZe3nUjpbh4+cIXTXgC3X7IphC/BtFHyes2YR9YxOro6KWleTlOHeVGZukgIjRLwCd4uix7wfYLp+6Bls9hrKm45k7sz+7/PyVR1QBtilq7wScn/SPQ7hcMEN1ISmnF7PZT6QbuctPMacXqBBa2nS8e7djN71bxtT2JDU4iqoKborLNUvo2d9D3BdTbr5Nfz2U4w4gWGjI0oLf3pBSoyFyeKod064ZfF3nx8U4TVsR26iFpCvo5gK+qIpc6fTxNh/3IIh+3CvNbTWbaEmrf9zB2Xh4k7BNtcPH4qOQ65GcHF37dHhYEgpphDZhjxQE3apc4sgcrQnZmKn4zzg4ot4NGPrIRXqDMmPhfcBDho/PJImS0oRnOxIENq48vwDMSTHuOBUwtCgOCmGgxoLqHdpppLb08t405A3/WZUiJewbOGnbCS4zpkcEjl3N4NwJgPF4vpYGlBGBK+zmlEl5aafg4moQnJDShykOnFS7EG7TtT32AruluKzausYr8RdOSMT+TLvxefx2UjAcCMBaNLx3wpw9SIOVqexeuxmwuTjWiUxhwfK5AHOf4TkVr/UdUL8ftJ59G+OkVeGrO1Z7bH1NxCW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 17 Jan 2026 01:30:25 -0800 syzbot <syzbot+079a3b213add54dd18a7@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    0f853ca2a798 Add linux-next specific files for 20260113
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=14f7259a580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8d6e5303d96e21b5
> dashboard link: https://syzkaller.appspot.com/bug?extid=079a3b213add54dd18a7
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=167ef922580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d295fa580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/480cd223f3f6/disk-0f853ca2.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/1ca2f0dbb7cc/vmlinux-0f853ca2.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/60a0fef5805b/bzImage-0f853ca2.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+079a3b213add54dd18a7@syzkaller.appspotmail.com

Thanks.

> ------------[ cut here ]------------
> WARNING: mm/memcontrol-v1.c:642 at memcg1_swapout+0x6c2/0x8d0 mm/memcontrol-v1.c:642, CPU#0: syz.4.233/6746

That's

	VM_WARN_ON_ONCE(oldid != 0);

which was added by Deepanshu's "mm/swap_cgroup: fix kernel BUG in
swap_cgroup_record".

This patch has Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT"),
which is six years old.  For some reason it has no cc:stable.

Deepanshu's patch has no reviews.

So can I please do the memcg maintainer summoning dance here?  We have a
repeatable BUG happening in mainline Linux.


