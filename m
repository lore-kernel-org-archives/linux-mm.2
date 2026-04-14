Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2DAAF531D0
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 03:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D984D6B0088; Mon, 13 Apr 2026 23:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6FB26B008A; Mon, 13 Apr 2026 23:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAC966B0092; Mon, 13 Apr 2026 23:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B98426B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 23:52:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B6DA1A03FF
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:52:40 +0000 (UTC)
X-FDA: 84655789680.25.E32F64F
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id E2A442000A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:52:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LOdjCPmX;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776138758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Hsa5jfeTcTq/O2GmFxGJYQJNsRI2GpDuYxjEIeC86U=;
	b=2DmSJunRHMm/nN/P+G+4JX4Ks4dMFJ3zYiKOvzW+OOPaqLRf02mVC/2iePOtbFSzvRsqY1
	vYMAx5uvWTQYzcaM5jZ38Chd4HKYb8dzuGtCcID+Adfxw7AUuOaIHytdkNjcIatpM0B+7P
	dtIAW/aWDxH3YOolE2cjtQNspI3edWs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LOdjCPmX;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776138758; a=rsa-sha256;
	cv=none;
	b=s0VWRuG0CoVbubEz4vnBBaHgtHd3I7mCXMIXZoKFvylkER9S4Ok0YjPEPZCRnPJe/Yryl4
	zonvC8vcQlW/C2F9xm8+PWxtLkaaWn/mxkdsTqRyNRAH+BIPQ88/+Zg3JDsHAHN8LVxOMa
	du1ThwnX60TPxkWf0bKiE0qpU+LeDjk=
Message-ID: <358c60e1-fa91-40a1-9e00-84c93340c04e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776138754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Hsa5jfeTcTq/O2GmFxGJYQJNsRI2GpDuYxjEIeC86U=;
	b=LOdjCPmXff29fEJNKAZ3LMXkF9RzU2+hFU9CxpdNwutuqYVfL4ZInbe/sjUEEbqSDzBjEm
	IUNWxqVvNTpAwKQayHyG8BhbttLqSgBn6ACYfFMCMltOrO5EcHJcXCl7Z/bqIe3pL1t3SM
	cqKF6PtDYf93gaDyzuMiG0wScgL2eMY=
Date: Tue, 14 Apr 2026 11:52:13 +0800
MIME-Version: 1.0
Subject: Re: [syzbot] [mm?] [cgroups?] WARNING: bad unlock balance in
 lruvec_stat_mod_folio
To: Shakeel Butt <shakeel.butt@linux.dev>,
 syzbot <syzbot+1a3353a77896e73a8f53@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org,
 muchun.song@linux.dev, roman.gushchin@linux.dev,
 syzkaller-bugs@googlegroups.com, zhengqi.arch@bytedance.com, yosry@kernel.org
References: <69d54494.050a0220.3030df.0002.GAE@google.com>
 <ad1tV5WpFhxbQ86N@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <ad1tV5WpFhxbQ86N@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E2A442000A
X-Stat-Signature: umi68fc68aq5ueg793cmrfmqt9fbzamx
X-Rspam-User: 
X-HE-Tag: 1776138756-176512
X-HE-Meta: U2FsdGVkX181Vl5pk5OPq4QKwPeHmEJA6fFG7f1Itzp1h1xPjyBTxs9+MA+VTI6ApRJzjRDXzMFEi7NVmyKunVry+q+T84TA5dT5fCe/uYFH+vt+2d6TW6jcDkd/o15JUDiCL2zAm9fsVIpOnik4wZZCg/FUpH4NHC2l0gtC5x92GNP2t8kyzWMiCMZrCz6iXpwnHZiX/zzJ+3lgXq/FSZgm1IDDaHJcJt4JRWwykYZCaVkbvU0DqtxYHuwYUHrYx/gjKAZN8LZsvUsZ9BcRH3KstzmFgMOMFfPp55vfEEpqlinzt1RmYW3Dli8jUmxUspaPOurGS+/4X4h5/DV4oNgIAYz37ML4Gbag5R9FCPuUSeUkGnWWZW1f/DAjfarlzQFioLgsFoFDeLNvKCbMHD2E4B9WFdWhiGuL+tERLaYexRea9D2FZx8+FnhB0JLH1rtUcO2DIHBPBTkp/U8DRxhopT1BOXNysLBJdnU1p8C4biwuNPuFIBYM5S4Q8iK2ZYK/SUoC8Ilv8bfd6vy9VJpLFFrC2t6An5KpS3S4K0NSb2d2Ymhzwri30cg3Qo6O2YUCG+RDaCgecAYyG9/4oDeRp+SDIQT1zYiv7Z/nmbeu0/PENeU1F1ownFHiupjl2rqHqTjRJEt7f+GMCBWcuDF5NeJjpW7LEay2lUxI3HzAj+Ix/sj58Vos2JFm/v3EQ3pxpNJdWhe8VqtKFivyLBV657v4QqjUKsSvHm/wfcg340szuUviYV8KTNr0V7L6sk+EVcoQsCNso+HU5H1fApt6Jnq6Dt6KROvdjivwE/GPZQ84rigUwY8ljaTaGhvDj3QDYr1scn1tac0IDG+5fVxBWoutdPcZiKr6g81mWhGn/WKVEkGSVe7rZn6+Z9IZ6RFWdd1fLu8X3CHC/PYdd4yQbiMPEeSVwAXnNDT6EaYdXIe6Ws36iFG0QE5JDHxKUJdWegXGvg0zCH7WibA
 PWHj5Kd+
 stJGQQL24RHNoDT9i006q8iizTRNdYnO3Ho23tt79olgmhTPRyrOzAVxUpfXs88Ckn+EYIYIIQ3kEN5xbMdsdtIJmIso4kUg5S32wFqJTlGKrnRGsOM8astA4jbE7mnHR/Ob8doqszmj46cYijfDsZe1g3wvAAqg4EeK0MSFiNo64StAk1U4/izgqIEhf++zgVr77gMbCokHeNXNALsLQaZZBHHQQb+zd8bW6/g99H5QSVN8+pFaahBukl2KYrQLflTCzA1hda27O7pyAysT5LHgJNRMyhCpjEU4DxmG8nTli/b4Ma3wS0N76/5S7D2kubEOm+SlYeaM1BEvn+KjgEqoBxdUYO9sh12oPYYAeX8B3GNe4lerTP8I6hMsSB5usDE/Gmttk5RGz1lLB8tVMpHlji6mkccnYuqsiEez/fuyzdTJTWsAL9eY22/v3iK438pcsyzLKKRahIkGYj8byBos5jGFfxc0hVBsysbx0+4EkTqHf4O3ltxmJsIrnzk2MUhmWW5DMpVw6SpE5zpHYAz6ggXcrh0UWN8e6bdBFSMTP3rGUmN1+cR5zWLF4PQCxMexp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shakeel,

On 4/14/26 6:28 AM, Shakeel Butt wrote:
> +Qi & Yosry
> 
> On Tue, Apr 07, 2026 at 10:53:24AM -0700, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    cc13002a9f98 Add linux-next specific files for 20260402
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=10d8946a580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=4e6c8be618ab359
>> dashboard link: https://syzkaller.appspot.com/bug?extid=1a3353a77896e73a8f53
>> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Let's wait for the reproducer. I can only think of cgroup_subsys_on_dfl() check
> returning different value in get_non_dying_memcg_start() and
> get_non_dying_memcg_end() to cause this uneven rcu unlock. However I can't think
> why and how that can happen.
> 

My AI bot told me that the cgroup_subsys_on_dfl_key can be dynamically
modified at runtime during a rebind:

rebind_subsystems()
--> if (dst_root == &cgrp_dfl_root) {
		static_branch_enable(cgroup_subsys_on_dfl_key[ssid]);
     } else {
		dcgrp->subtree_control |= 1 << ssid;
		static_branch_disable(cgroup_subsys_on_dfl_key[ssid]);
     }

However, when I actually tested it, I hit the following error:

mount: /tmp/cg-rb-repro: mount point is busy.

Indeed, there are already many child cgroups under the cgroup v2 root
(the VM just booted):

root@localhost:~# find /sys/fs/cgroup -mindepth 1 -maxdepth 2 -type d | 
head -50
/sys/fs/cgroup/sys-kernel-debug.mount
/sys/fs/cgroup/dev-mqueue.mount
/sys/fs/cgroup/user.slice
/sys/fs/cgroup/user.slice/user-0.slice
/sys/fs/cgroup/sys-kernel-tracing.mount
/sys/fs/cgroup/init.scope
/sys/fs/cgroup/system.slice
/sys/fs/cgroup/system.slice/systemd-networkd.service
/sys/fs/cgroup/system.slice/systemd-udevd.service
/sys/fs/cgroup/system.slice/system-serial\x2dgetty.slice
/sys/fs/cgroup/system.slice/wpa_supplicant.service
/sys/fs/cgroup/system.slice/system-modprobe.slice
/sys/fs/cgroup/system.slice/systemd-journald.service
/sys/fs/cgroup/system.slice/unattended-upgrades.service
/sys/fs/cgroup/system.slice/system-systemd\x2dgrowfs.slice
/sys/fs/cgroup/system.slice/ssh.service
/sys/fs/cgroup/system.slice/dhcpcd.service
/sys/fs/cgroup/system.slice/systemd-resolved.service
/sys/fs/cgroup/system.slice/dbus.service
/sys/fs/cgroup/system.slice/systemd-timesyncd.service
/sys/fs/cgroup/system.slice/system-getty.slice
/sys/fs/cgroup/system.slice/systemd-logind.service
/sys/fs/cgroup/dev-hugepages.mount

So it seems impossible to rebind memory in a production environment
using systemd?

Then I disabled systemd:

set `init=/bin/bash`

and found that I could successfully run the following commands:

root@(none):/# mkdir -p /tmp/cg-rb-repro
root@(none):/# mount -t cgroup -o none,name=rb none /tmp/cg-rb-repro
root@(none):/# mount -t cgroup -o remount,memory none /tmp/cg-rb-repro
[   65.903125][  T241] option changes via remount are deprecated 
(pid=241 comm=mount)
root@(none):/# mount -t cgroup -o remount,name=rb none /tmp/cg-rb-repro
[   73.405829][  T242] option changes via remount are deprecated 
(pid=242 comm=mount)
root@(none):/# umount /tmp/cg-rb-repro

So it seems this race condition does exist. Should we fix it?

Thanks,
Qi


