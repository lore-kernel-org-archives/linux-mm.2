Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABBEFC5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 21:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3A16B0322; Wed, 12 Aug 2026 17:04:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB576B0323; Wed, 12 Aug 2026 17:04:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707D76B0324; Wed, 12 Aug 2026 17:04:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49C166B0322
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 17:04:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A094DA0442
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:04:01 +0000 (UTC)
X-FDA: 85093844682.23.434D9D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 05CBC100005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:03:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="M7L/CM2k";
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786568640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjntp49iT9Wxm1cuWnwjCVqtDnt7W8/fWzirIfwxfgY=;
	b=Xl4YmG24r0UWLzWeRqP0gUXUNZNl3m+6sEM6oELCX6Vxpi+6rhMHn0GinQzSrMVQKHaoUr
	MNn7nxl7O81J75dgKN/t+JiOAsVhX5KzxpwJf9Ywe9YHjOD96scALVeQzuyCMFfLpJfTsK
	6+Y2ZpCw9NC1m1OhyytmO05z+G6Lizc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="M7L/CM2k";
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786568640;
	b=vzzUvZVH97va8m4WkadtiKmgodwuyi8i1bfVXcQG6SxWH385TyRFPveVueo8/xjo6luCmp
	8bp5yUuWbsbuicbRzdKPyCP/C9iA8NOOG1eRS19HNR11HG3y/bHutm+YBzqNtdlRBjz/9L
	tw+sqen2/io09hXMAgaQ0sznDsXP6Nk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 882F8600AD;
	Wed, 12 Aug 2026 21:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951761F000E9;
	Wed, 12 Aug 2026 21:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786568639;
	bh=kjntp49iT9Wxm1cuWnwjCVqtDnt7W8/fWzirIfwxfgY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=M7L/CM2k5o4Ik35mAzj3NgcfHzwZQf6D1hc7uET1/UnSKnP7AKT2juBm3Bvlso8kN
	 cRNA7/EvQwBAc6qwMlcJggMbUrw1oxKpiBKp5ZRZus38UshDBOW7V1uOqjP1OtQUf5
	 boGRAVO0JuJGU8VWcTWjX4TYLFQeImnlLMw3AknE=
Date: Wed, 12 Aug 2026 14:03:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com>
Cc: axelrasmussen@google.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, cgroups@vger.kernel.org, david@kernel.org,
 hannes@cmpxchg.org, kasong@tencent.com, kernel-team@meta.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 mhocko@kernel.org, mhocko@suse.com, muchun.song@linux.dev,
 qi.zheng@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 syzkaller-bugs@googlegroups.com, weixugc@google.com, yuanchu@google.com
Subject: Re: [syzbot] [mm?] WARNING in set_mm_walk
Message-Id: <20260812140358.343927ad8d0955b67c4e7ad5@linux-foundation.org>
In-Reply-To: <6a7c6670.3668565d.e8814.0012.GAE@google.com>
References: <6a7a6929.b50370da.49fe0.005e.GAE@google.com>
	<6a7c6670.3668565d.e8814.0012.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: xzbcrmtgo85oiupt5z1ewuf9s53y3h7u
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 05CBC100005
X-HE-Tag: 1786568639-730597
X-HE-Meta: U2FsdGVkX18aQ/f7znv/kzBoq3gWNTZzg4lC1EuTjzLnu7wSiEVnrEOmbgO0vZnonJJQnQZW9OFxRqlzGgamR+GLI5ymsPdTosZh7d9Gsz+kW/al88Aayo1dChm0iV/kVTzbUJHq8FuX8ckdlhGYZ+g6idGukGIEKG6k/7/yDun3kBf6VSPuOM4dAaYFggqRi61IqwJGMtTVJJ23odzgZRDewQe9OzFwrHEFO0k1s2iz//QxwbGkx4C8ha17fHCgFcDv/CB5/CTILf7I53bnGjIMP7YAz3Qa/h0aualdIBBB78Z6yHGEzKJuXdAdgYgLO3RUkkGVoE8oy8fh5HRxmc3cXYRaaPWBVVJV5JfQIpgVBYki90RquS7wlUG5tnruXXqVPHF1a+mXtAsYLGmUyBM04KkuaTlJOfdIq2+xDEEoLhIuLUqqo1ABjcKqDokf/xtvKwm5gGrzFzPs3Tz4P/Z8r+seu96NGdNgJ2OL4si3kVV5d9Y/VN4CeO/e0RccwJyI+k5TTEKOMsWrvvbcUf2VZa5utz6HWLK1LY+TXbQp2/nkAl4GLv6byFVdCE0RCldjoSS6cRnF1mZE6YB66uL+vft5rkCoFdv2oFIiYOA3iNuXo8uw6bfAkMzuva/rUec8L9OQFgal0lQ6kNOSiLbSEmSEaNr8Y3LbbP92HVyH4Dz9HTOVpb4bIrT9DYmNTxERCnk6i/aIRqf1M7XDZpL40ByiYJ/PpClU/8IVbUwj9sOqNqxcZ85V2kLDY0CPfGyuy5G5bTaLVf9TEk2lusVaXdp2Ph4dsoTfcqNzFIFTa8Vy/HLl1RsUBF5DLjlbcJkHkeRu3zKLENtRZhS4QCxlpta6NFUymL5b1EpURn/751HG61L0nKRilqGxsiMGwnx4Xq/GwahRvJoxa0fwOh5YOVRNYbNjSBjNgCjXuL0TZOTOO76v8zBzF+2OD+wpdIPyHNpf0asmf+vq2GJ
 KyZ/IwIu
 gRK9ixgja8OcdwjOHBELV4qW8/Xw+9qYENVRXSV/ICPie1jV1dLuVK3U+lzTEy83omTRNTkRKLMHYUZs0AYO5wkVLjOKjub9GR5Lt7dv6TZqXwjA6K6pJbXgVYLjyGO4Tz048Pz6a5g6oGBX5LbZithbzHjAHUmx9mShUi8pccXo5/h4kBKD4jGrcmb9r1rqevZmG5s38nTuIkPbbae1XP+WEvQvphtk5mVGHPSIk5VAmK3g4CsSiQaj1zJGnht60RIPRz9fU69ZlR3tz1WIbyzadbuQEbqy4PbOwJOs4c/xi2hNiXpIcAeawrwrW4JU3j4xgx/uuPB7O/L5BTsXO3YnmhyLlSFVgdPu72/jcnKE077cgtJCZBzy1ExYxarTYoFa0xHLZnOMbMLCG6GDVpePk1/ewZzO3/BUo6+H0uel1oNDNrud928SXda2YIABE2vev2kxWmf8+I3Cj709UvWdNQt2ZKga+fyKADSxXa5G+YOZpWoYVAmQuIv2D57XHm2j866MKrjd3emmlm0hmWqykEgvgb2TzGEYXaA0gkmWHFCUmFaakk8oks2thxjqfTHNDlnCJZsH186KDTaKOdKllqS5cCyn1XzTMH+VISpeM0uzbTsPk1krf/iE5y2Yo7Z2TfCH5fIHZPPF8KogioQ7vrcUgbHhoVDadHKhwdgmwmPwFyVcXyxrR+K9lnsN61R80DS+0GXI0fV8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 05:26:24 -0700 syzbot <syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com> wrote:

> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    f5bbbfec59b4 Merge tag 'probes-fixes-v7.2-rc7' of git://gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11f44c79580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c44651ea7dd2f307
> dashboard link: https://syzkaller.appspot.com/bug?extid=12ee2725d5fde63a9c96
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d11149580000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> current_is_kswapd()
> WARNING: mm/vmscan.c:3800 at set_mm_walk+0x210/0x270 mm/vmscan.c:3800, CPU#2: kswapd0/111

Thanks.  Shakeel is working on a series which will fix this by removing
the calling code.  But it isn't a minor patch.

Shakeel, it would be good to have a backportable quick-fix to make this
warning go away?

> Modules linked in:
> CPU: 2 UID: 0 PID: 111 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:set_mm_walk+0x210/0x270 mm/vmscan.c:3800
> Code: 13 00 00 4d 8d 7d 08 e9 f7 fe ff ff e8 19 f7 2a 00 e9 b7 fe ff ff e8 7f 68 ba ff 90 0f 0b 90 e9 d2 fe ff ff e8 71 68 ba ff 90 <0f> 0b 90 e9 74 ff ff ff 4c 89 ff e8 20 f7 2a 00 e9 4e fe ff ff 48
> RSP: 0018:ffffc9000272f2b8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff888023f04a80 RCX: ffffffff82500a88
> RDX: ffff888023f04a80 RSI: ffffffff82500b0f RDI: ffff888023f04a80
> RBP: 0000000000020000 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000020000 R11: 0000000000000000 R12: 0000000000000000
> R13: ffffc9000272fc38 R14: 0000000000000001 R15: ffffc9000272fc40
> FS:  0000000000000000(0000) GS:ffff8880d5fec000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005643a2ed4168 CR3: 000000003c7ec000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  try_to_inc_max_seq+0xf0/0x1090 mm/vmscan.c:4023
>  try_to_shrink_lruvec+0x4bd/0x6b0 mm/vmscan.c:4977
>  lru_gen_shrink_lruvec mm/vmscan.c:5128 [inline]
>  shrink_lruvec+0x31e/0x25b0 mm/vmscan.c:5888
>  mem_cgroup_shrink_node+0x227/0x6a0 mm/vmscan.c:6753
>  mem_cgroup_soft_reclaim mm/memcontrol-v1.c:312 [inline]
>  memcg1_soft_limit_reclaim+0x2d5/0x830 mm/memcontrol-v1.c:362
>  balance_pgdat+0xa11/0x1f00 mm/vmscan.c:7177
>  kswapd+0x556/0xb50 mm/vmscan.c:7462
>  kthread+0x370/0x450 kernel/kthread.c:436
>  ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>


