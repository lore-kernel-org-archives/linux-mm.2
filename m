Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EBB9F9D0FE
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 02:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444866B0092; Tue, 14 Apr 2026 22:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F58C6B0093; Tue, 14 Apr 2026 22:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B616B0095; Tue, 14 Apr 2026 22:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DC4F6B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 22:22:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6CB37160314
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:22:39 +0000 (UTC)
X-FDA: 84659191638.30.A2A4B28
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 89796C0006
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:22:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IOjTynhS;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776219757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxdlTa6h3czNPKK/Gx4JCfQxJJmMB+PRQCNkrNojt5w=;
	b=HvkbhRi1VoLrAF+Nj2CT0J+A+Gz5XWoT3AVcUCOkmqJhSB79BvMAvLXrrq5K4U3UmsM563
	Wu1vjC3Z3RhkzbtJbzha4OgJGvfG6Ot2VmRxPenQiFQUSTY25y0M3aUtr56pNtzAfp1fgL
	WuktZ9VULFpTGjc+9CshvIC+4ke44Jo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776219757; a=rsa-sha256;
	cv=none;
	b=lzzG5YSx8pnzDuVw9SRow6vH87e38zNMsmEwMqzw/j6oTBREB21nRt2UKN+P6WhWRCAOIz
	1kKM0bu8k/Ha4q4sXmKq5x41zHJi8E1G2CqhrSPighXWTL3HV/jUa9Jmm+2syAHwGqiWnT
	70B9fJH91N8tHsE9kcz1pEuHA7b/KPA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IOjTynhS;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <e657c791-0768-452e-9a21-ae5dd13aa706@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776219755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SxdlTa6h3czNPKK/Gx4JCfQxJJmMB+PRQCNkrNojt5w=;
	b=IOjTynhSxRbXbBSIhYqt2yRd7gag1Ol6pIPFPPWfKEsMNn0st+gT7Nx2aN/4/2E9c0tByV
	o2/VyHreSZkVVP70OUwZcbozDNSPvno3Q4trUeesMZXyk/tXVVMWMlHl+WLb4/JQU3iAJb
	UrympiKJEuVbJBeZ/4t3uteVtAH3I6k=
Date: Wed, 15 Apr 2026 10:22:05 +0800
MIME-Version: 1.0
Subject: Re: [syzbot] [mm?] [cgroups?] WARNING: bad unlock balance in
 lruvec_stat_mod_folio
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: syzbot <syzbot+1a3353a77896e73a8f53@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org,
 muchun.song@linux.dev, roman.gushchin@linux.dev,
 syzkaller-bugs@googlegroups.com, zhengqi.arch@bytedance.com, yosry@kernel.org
References: <69d54494.050a0220.3030df.0002.GAE@google.com>
 <ad1tV5WpFhxbQ86N@linux.dev> <358c60e1-fa91-40a1-9e00-84c93340c04e@linux.dev>
 <ad5134-5FkAKDqtP@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <ad5134-5FkAKDqtP@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: mk84xy6koq95k3kcp9tmuwy55yktixwj
X-Rspamd-Queue-Id: 89796C0006
X-Rspam-User: 
X-HE-Tag: 1776219757-921792
X-HE-Meta: U2FsdGVkX18dxL50VCh9qtAWCgfDgo0O5EMcoFdmdu7Dytpzzypix0PIFVTdx7W6IRReg6s7lPaE1PE3a96N7AE9KjpQR3OUVp+ojhcpi4oyDxPGExpC6teHW66v499dUx3PfnpG9D95IZfSJczT+71DEEprZVZT3sbnSAEpkzAb6Ip7i3jmgbfriEALuzm/Fk6kFpIlKYSvGWfSnVBY9nXYXvkANKeB8NxWK+mCEalnTKGTHvvXfu9QAelfFT4XdH+Y8EFo91EvkpxHRn95FSQuYv9bJ0GRAMmgP23CNM5sA62qUIKjbOcutL7o+jDZ14Ir7mpDne59SlfswCQtVVmgpo4cdIZePJf6gYwjWv4SuH3tzvPWs7zXEW91+bLG6U340PR6JZX1tbvFbaxY2OsO29eJiwjJr2/c9hNaZ0RgVwAq0UawwN36Y+RIZ7pQQXaTWXKP1e5nPH8aq78LLfQsKbsfP/CS0XX4eLBgub3gctWjnu8kKPJsw+njQ4jIfXzcgZ+ovRRTFAAqXV95U2qBqZ+mjP9YzeoPs8zFrxaSVdlSsjd/7xp3bxXNZB5bkbF5NK7mTIERD54WXd+nTWm7eyE8qyOxinxCtWt7L9jG+WfV/47qmmPi2AA8UMD5gVRbVnOPdgfeKP/DvZc+OekcpPf4AykF/EoO5tHlzKZM5SdBdQxkrSdfX72CV5fScV+Af0TyAN+NhRF0dP8ocwEVMQhdne8nzbBLgL1TJBPYKvOYRrQRtZ9g4BWwrpH6+zWsa3erHPPsITh6IbCqAkpg1e9kFF8Ytb8O33PK6FrikIXsaYgSuAxOWy6g3PYnYZC3YQNizGGcayvtVF1mlCapB7k5t+u9x0tFMjPfAgyngA8jvOhwrvau6p+GRC0v+b5RoirR70Muj1fPtdRwye0f+hv+lv5L6Ragu6A+i6BVg0HKND7aGJJSFzxPGhQsCwWQFGCKjPRUr+7wJa1
 iCDNxrRh
 Xwjj3PPUwD7zyiYESWM3Ee/Jqq0wGnnCnx2KzoWpBroBzeWSmHGFxbsJVV/zQwIYiMyqfI0IptrIE/HVCA3W3RY5CmYnxY9fi7gT+hv1gx2mQ7ytLoFhx1CF8Q3jJILKA6CSFM2dDoKmUYkSpfNS4vihJ2jTI1JyR8ExUZnL10CBDf9fi4LCHFWuDk69PofaexEo7KUyqyDJ47Y2ribheqPLyy0Tj5WJvSA5KddCVjHKOqNaF/JgGOFze84OkEy107PzmAbbjOH/B3wUHX1Y5L7WHnAN7MNrpCIeyDWXo0IBWmeMMHWIpcsz9qBiz7JY8OeXB+QmrJZwgg0QfN5/8jO1irNa0/WUBcwnz/jG02KTquapCVMF3GYcg7dWKVdRsVFhO+bXl4/9kT/bbPm6s9FMuh1VDYGDdZM0sRsGVsMp2z3i8C/eu8Nw/JrmWAvgwcIo/Ca3nYxHIjABSUQipLhKOdsg8tLc+PhTNnNIgqwjCZSXBJ/KF1UBKYvHez6zaDKNcKlJq6Nm5Hs1/qgCuGxE86M2E+wcXDwjLrOc5/6gsvQvjmHpsbGw+R0ZaMX+rENgF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/15/26 1:15 AM, Shakeel Butt wrote:
> On Tue, Apr 14, 2026 at 11:52:13AM +0800, Qi Zheng wrote:
>> Hi Shakeel,
>>
>> On 4/14/26 6:28 AM, Shakeel Butt wrote:
>>> +Qi & Yosry
>>>
>>> On Tue, Apr 07, 2026 at 10:53:24AM -0700, syzbot wrote:
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    cc13002a9f98 Add linux-next specific files for 20260402
>>>> git tree:       linux-next
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=10d8946a580000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=4e6c8be618ab359
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=1a3353a77896e73a8f53
>>>> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>>>>
>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>
>>> Let's wait for the reproducer. I can only think of cgroup_subsys_on_dfl() check
>>> returning different value in get_non_dying_memcg_start() and
>>> get_non_dying_memcg_end() to cause this uneven rcu unlock. However I can't think
>>> why and how that can happen.
>>>
>>
>> My AI bot told me that the cgroup_subsys_on_dfl_key can be dynamically
>> modified at runtime during a rebind:
>>
>> rebind_subsystems()
>> --> if (dst_root == &cgrp_dfl_root) {
>> 		static_branch_enable(cgroup_subsys_on_dfl_key[ssid]);
>>      } else {
>> 		dcgrp->subtree_control |= 1 << ssid;
>> 		static_branch_disable(cgroup_subsys_on_dfl_key[ssid]);
>>      }
>>
>> However, when I actually tested it, I hit the following error:
>>
>> mount: /tmp/cg-rb-repro: mount point is busy.
>>
>> Indeed, there are already many child cgroups under the cgroup v2 root
>> (the VM just booted):
>>
>> root@localhost:~# find /sys/fs/cgroup -mindepth 1 -maxdepth 2 -type d | head
>> -50
>> /sys/fs/cgroup/sys-kernel-debug.mount
>> /sys/fs/cgroup/dev-mqueue.mount
>> /sys/fs/cgroup/user.slice
>> /sys/fs/cgroup/user.slice/user-0.slice
>> /sys/fs/cgroup/sys-kernel-tracing.mount
>> /sys/fs/cgroup/init.scope
>> /sys/fs/cgroup/system.slice
>> /sys/fs/cgroup/system.slice/systemd-networkd.service
>> /sys/fs/cgroup/system.slice/systemd-udevd.service
>> /sys/fs/cgroup/system.slice/system-serial\x2dgetty.slice
>> /sys/fs/cgroup/system.slice/wpa_supplicant.service
>> /sys/fs/cgroup/system.slice/system-modprobe.slice
>> /sys/fs/cgroup/system.slice/systemd-journald.service
>> /sys/fs/cgroup/system.slice/unattended-upgrades.service
>> /sys/fs/cgroup/system.slice/system-systemd\x2dgrowfs.slice
>> /sys/fs/cgroup/system.slice/ssh.service
>> /sys/fs/cgroup/system.slice/dhcpcd.service
>> /sys/fs/cgroup/system.slice/systemd-resolved.service
>> /sys/fs/cgroup/system.slice/dbus.service
>> /sys/fs/cgroup/system.slice/systemd-timesyncd.service
>> /sys/fs/cgroup/system.slice/system-getty.slice
>> /sys/fs/cgroup/system.slice/systemd-logind.service
>> /sys/fs/cgroup/dev-hugepages.mount
>>
>> So it seems impossible to rebind memory in a production environment
>> using systemd?
>>
>> Then I disabled systemd:
>>
>> set `init=/bin/bash`
>>
>> and found that I could successfully run the following commands:
>>
>> root@(none):/# mkdir -p /tmp/cg-rb-repro
>> root@(none):/# mount -t cgroup -o none,name=rb none /tmp/cg-rb-repro
>> root@(none):/# mount -t cgroup -o remount,memory none /tmp/cg-rb-repro
>> [   65.903125][  T241] option changes via remount are deprecated (pid=241
>> comm=mount)
>> root@(none):/# mount -t cgroup -o remount,name=rb none /tmp/cg-rb-repro
>> [   73.405829][  T242] option changes via remount are deprecated (pid=242
>> comm=mount)
>> root@(none):/# umount /tmp/cg-rb-repro
>>
>> So it seems this race condition does exist. Should we fix it?
> 
> This only succeeded because there weren't any active cgroups. Were you able to
> trigger the warning as well. If not, I think we should just wait for

Nope.

> reproducer from syzbot before doing anything.

OK, Let's wait for syzbot to reproduce it.

> 


