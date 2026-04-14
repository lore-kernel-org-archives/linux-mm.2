Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 140EDF9D0E8
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 17:16:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CCA06B0089; Tue, 14 Apr 2026 13:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A40A6B0092; Tue, 14 Apr 2026 13:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA256B0093; Tue, 14 Apr 2026 13:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9686B0089
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:16:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D1771A01E6
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:15:59 +0000 (UTC)
X-FDA: 84657814038.06.A6A8D77
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8DE464000F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:15:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lDiQZ3kP;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776186958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sdGaJ1kfPvwvrDDRsofvgKCgSPPMcVc4q17G+sHRwG8=;
	b=BABY8cfoUlh6Wy1NUuWXbglBpcx85g2ZswHAvNt9EhPUCJ18FWhboqZX7ULtV+0753/x3e
	wCuT9FsRDtKqBMw8NSCqnZ99qQ3ivWPZNfhpMG6WJVoUXK8l/kCT3gcOIfSJs6qx4ccpnM
	W9uEugKtdl32FYSVSRLsPMP2yXayW/M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lDiQZ3kP;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776186958; a=rsa-sha256;
	cv=none;
	b=rlNGz44ruaNAMTCGKKDLbtxG61j5SJvAKvGo44+nwasat/VAxLsrq7MlizfwUU/k7QCaOd
	B0aS+qUEjtueefvOrZOjRloZvFxyjwpzoRknyYGstM+P+c3pMf41L1A2lSKLVnnfj7mO7c
	nGTlFX2E6ddyrQkVPkx5OiSxmvroRP8=
Date: Tue, 14 Apr 2026 10:15:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776186955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sdGaJ1kfPvwvrDDRsofvgKCgSPPMcVc4q17G+sHRwG8=;
	b=lDiQZ3kP1q4ljLOtXGUeSiDgZVrlt+imZNexfUnsxU8YhLd0XOmGT3pF3uPDUsOcutbWli
	5ZTtF5pRjNh1RX0UPL9rPW9f6duLdOvWhexGPRDTf58BbbvLhT6pW9XxzFkUcmLusLBSjg
	qZkttKYp+ZoKBxjOq9VWWerfHYKqDJ4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: syzbot <syzbot+1a3353a77896e73a8f53@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, syzkaller-bugs@googlegroups.com, zhengqi.arch@bytedance.com, 
	yosry@kernel.org
Subject: Re: [syzbot] [mm?] [cgroups?] WARNING: bad unlock balance in
 lruvec_stat_mod_folio
Message-ID: <ad5134-5FkAKDqtP@linux.dev>
References: <69d54494.050a0220.3030df.0002.GAE@google.com>
 <ad1tV5WpFhxbQ86N@linux.dev>
 <358c60e1-fa91-40a1-9e00-84c93340c04e@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <358c60e1-fa91-40a1-9e00-84c93340c04e@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DE464000F
X-Stat-Signature: j557ormxth44gj8hfc9xcpohwmws3bnj
X-Rspamd-Server: rspam06
X-HE-Tag: 1776186957-467306
X-HE-Meta: U2FsdGVkX18Pm8saBnNyWhnurqxcLu5cBD9svq1FNTX2sRb8q8DKzbYRcEZaTcO4SwWlXcpXc3YeDQAS28Wf4F4Aqt8L+CEDK9pIvpXcTYe6QsGSlcLr5iZamY5VyDUCillbZbNtaNtagIZJbupQL8xueJIslsEW8P+hUvfIbXOujIyUgAuX/8vPTPjaDo9YQ6q4pFDwxuw6GSQF6QRhLNPXjA9AR//ZDgUOSyqD1BTkAobFwxPV6S9szc9swiDZOdvWN508xD+lcv1q4Af8Vok7BvC+apiHg10P1gouejuSG3Tw7nr7z3sxRMSvALZMv5/s4DmEIpIltdmdbQTZ4HtRh9U6SXMoLCUg9mEQKmGvH0gdKML36pfJDE0cKZ0Q9S3yaLQm04YO0vesurT2arVBwKxG6Fl7ZoVekhUYezgOfdFswr82ig+ZWsgS95xVXyMRNfZL+nM/UoaNyzZ/ggFa/R790tQRusMFQ/zPewC+xRVJoB12SehRi7Z3egoa8MuYOMQpyhouJn672ad++EnTUmCvSxaiUdznuoqRvJy2pn4AOJm1VGJfuCyeBbYPGkUG+2HhHpRv1+LIGh91yOtUywWsEF7L+We4tf0E6fUfZ6E4of9/Ri7NlA8qUKSD1z3AWxFbWllwT0cWFjLU3KmbjcGhKqn4W/OHu8JnnrtO5cLtamDf2RVtO6qRLIZpCNOzPsp07MJX42aMZpglpxdf6vWLlqktj92GzH1g9COiJEItk+0w43Dz3zgM7XuXk3UxvEfLWg3DO1CTgFK6p44IaJiD5LMAJYFbAmUD18owQiXXMRenZj1QWHB8pGLJkkPDstfTOJ3VV09NkETvuyFtynqN/lKMGvJZ6qRlE8YjoAIHVWRRMZBk+Z/y5LuMkDyOiSXrR2/YC5NidcEZmPlQd6TjU7+MaDffS5WkT4ZTYrIEugA4EcM4Q5KVmHIwr6wCKA4n4MdXrnXveuK
 6ld4MrHE
 Ch1g5BBbNCENYQkbkGY186a7INMlzTNLyrFrzSqs2t9bZlxbkAWISJqZ8MCGrMpZinUGyw6Pk8CTOCnCcVAIq1aWpx7cv6x89oADB33iH+d3KH3i7x3zeyPuOIyyWRzuHa1XeH6vlxal6ipHIj9CfaGMeROMmo2nThV4Lfqz6ODu9BoqyRqgzI7jvyj/XDpGLnuS8i9ZF+3zdn3DO1LctSR1X+KHOahbow7HEYpA3xgpud/XGGVMo6UYV+/vKkro1u7Hq8k3ebobBEfnUfyB0unJbjEv9Z4+gltbRc6Hrd4it/SwgIqHcbY4TWcVZsFTV2OzJ2s9LTLgTVF5AY59wZ1xWcb1kEWTL12/buhkQ5EbwFO2qkEjJNV4fOXzsvCVmwqJFgUWv2GtnUT9iTk7kQokLJVuRtRVJa6Y+KtJx2cC7eIPzz6XQxH/7znY2DFn2z3LD5smyhAEfu1i/i/fjmGZlsgcX9Stzw1ggcmVCDN4+XlX+PWuma/jC6qX5EgZP/IKrQaSqNpNlrY5H1GDHKPu8eUp0q6rPnSLj7PCON2Eks6QrwPbxkhPioSIKkVtCXsFU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 11:52:13AM +0800, Qi Zheng wrote:
> Hi Shakeel,
> 
> On 4/14/26 6:28 AM, Shakeel Butt wrote:
> > +Qi & Yosry
> > 
> > On Tue, Apr 07, 2026 at 10:53:24AM -0700, syzbot wrote:
> > > Hello,
> > > 
> > > syzbot found the following issue on:
> > > 
> > > HEAD commit:    cc13002a9f98 Add linux-next specific files for 20260402
> > > git tree:       linux-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=10d8946a580000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=4e6c8be618ab359
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=1a3353a77896e73a8f53
> > > compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> > > 
> > > Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > Let's wait for the reproducer. I can only think of cgroup_subsys_on_dfl() check
> > returning different value in get_non_dying_memcg_start() and
> > get_non_dying_memcg_end() to cause this uneven rcu unlock. However I can't think
> > why and how that can happen.
> > 
> 
> My AI bot told me that the cgroup_subsys_on_dfl_key can be dynamically
> modified at runtime during a rebind:
> 
> rebind_subsystems()
> --> if (dst_root == &cgrp_dfl_root) {
> 		static_branch_enable(cgroup_subsys_on_dfl_key[ssid]);
>     } else {
> 		dcgrp->subtree_control |= 1 << ssid;
> 		static_branch_disable(cgroup_subsys_on_dfl_key[ssid]);
>     }
> 
> However, when I actually tested it, I hit the following error:
> 
> mount: /tmp/cg-rb-repro: mount point is busy.
> 
> Indeed, there are already many child cgroups under the cgroup v2 root
> (the VM just booted):
> 
> root@localhost:~# find /sys/fs/cgroup -mindepth 1 -maxdepth 2 -type d | head
> -50
> /sys/fs/cgroup/sys-kernel-debug.mount
> /sys/fs/cgroup/dev-mqueue.mount
> /sys/fs/cgroup/user.slice
> /sys/fs/cgroup/user.slice/user-0.slice
> /sys/fs/cgroup/sys-kernel-tracing.mount
> /sys/fs/cgroup/init.scope
> /sys/fs/cgroup/system.slice
> /sys/fs/cgroup/system.slice/systemd-networkd.service
> /sys/fs/cgroup/system.slice/systemd-udevd.service
> /sys/fs/cgroup/system.slice/system-serial\x2dgetty.slice
> /sys/fs/cgroup/system.slice/wpa_supplicant.service
> /sys/fs/cgroup/system.slice/system-modprobe.slice
> /sys/fs/cgroup/system.slice/systemd-journald.service
> /sys/fs/cgroup/system.slice/unattended-upgrades.service
> /sys/fs/cgroup/system.slice/system-systemd\x2dgrowfs.slice
> /sys/fs/cgroup/system.slice/ssh.service
> /sys/fs/cgroup/system.slice/dhcpcd.service
> /sys/fs/cgroup/system.slice/systemd-resolved.service
> /sys/fs/cgroup/system.slice/dbus.service
> /sys/fs/cgroup/system.slice/systemd-timesyncd.service
> /sys/fs/cgroup/system.slice/system-getty.slice
> /sys/fs/cgroup/system.slice/systemd-logind.service
> /sys/fs/cgroup/dev-hugepages.mount
> 
> So it seems impossible to rebind memory in a production environment
> using systemd?
> 
> Then I disabled systemd:
> 
> set `init=/bin/bash`
> 
> and found that I could successfully run the following commands:
> 
> root@(none):/# mkdir -p /tmp/cg-rb-repro
> root@(none):/# mount -t cgroup -o none,name=rb none /tmp/cg-rb-repro
> root@(none):/# mount -t cgroup -o remount,memory none /tmp/cg-rb-repro
> [   65.903125][  T241] option changes via remount are deprecated (pid=241
> comm=mount)
> root@(none):/# mount -t cgroup -o remount,name=rb none /tmp/cg-rb-repro
> [   73.405829][  T242] option changes via remount are deprecated (pid=242
> comm=mount)
> root@(none):/# umount /tmp/cg-rb-repro
> 
> So it seems this race condition does exist. Should we fix it?

This only succeeded because there weren't any active cgroups. Were you able to
trigger the warning as well. If not, I think we should just wait for
reproducer from syzbot before doing anything.


