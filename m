Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 560E4EE6B40
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 17:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92A006B0005; Fri,  6 Feb 2026 12:30:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B996B0088; Fri,  6 Feb 2026 12:30:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8350B6B0092; Fri,  6 Feb 2026 12:30:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 716AA6B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:30:44 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0731414027D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:30:44 +0000 (UTC)
X-FDA: 84414721608.21.D4A9D82
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0EB4920016
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:30:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YsgO2JBK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770399042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R2ci6nhI3j7ZOgP8M5vOd80tULh6Zm9vUAl8sjnJkCs=;
	b=NSgHgzEu0+cau+XoY3gjXpHX2quCUXK1nmY6PXiEAg/NJujNDHRVNxb+lqsziBKYoHAdLH
	NNe8j0XJ48MmHR3wmjJ0JE0riaDW1VIpz0YKYdjMC3mFIEITcVn+vhunTVw6AHXSoQiU2X
	Z3CHQ7ucIGRWtKVifXDVO3uuNCE4beA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770399042; a=rsa-sha256;
	cv=none;
	b=FB6M0J3YtXXmLhr/10PpYxErsyIKgx5CcebTpvaSc19kGcakvYnQl0M8wcTl2Cjdrq2ll8
	SebaD5phivyiyCzt7+lGOQJRMHy6MctygYFxAe83jttyFI1u7qsD8Wv6+EhhyCUgkAKemk
	So9rCUSHsgdlKI48b6efiRJxjRPg728=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YsgO2JBK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Fri, 6 Feb 2026 09:30:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770399038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R2ci6nhI3j7ZOgP8M5vOd80tULh6Zm9vUAl8sjnJkCs=;
	b=YsgO2JBKLwqx2QHEJ/wWcFksHlSgVaIOLCvMJIa4ge63THx3Mibi8nz9mHSHmHF+XyGYrG
	wNnQV43jMurMligroEsF4RtCH/3y6c4iWZGEWDjgauk8q+34ffWme57AQ6QX2VJnGpfpfJ
	nvPhAR+0HRhm/SRnaNaJNrGkjhpwuxA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, syzkaller-bugs@googlegroups.com, kasong@tencent.com
Subject: Re: [syzbot] [cgroups?] [mm?] KASAN: wild-memory-access Read in
 lookup_swap_cgroup_id (2)
Message-ID: <aYYkvaqYGLXD3_P-@linux.dev>
References: <69859728.050a0220.3b3015.0033.GAE@google.com>
 <CACT4Y+bd+PcL=XzkehM-bmsfAB95UA2y9jr5JY2ov8zVOp1DWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+bd+PcL=XzkehM-bmsfAB95UA2y9jr5JY2ov8zVOp1DWA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0EB4920016
X-Stat-Signature: smqqfeei7we8bu5ywuqj4btc4d9hbaj8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770399041-264638
X-HE-Meta: U2FsdGVkX1/Bpiz7hxJ+cslUih5EnBgu1a1lXOeV4DkVTZj+Z1Qm9uzwI5CJ76shFB+38A4FI4LSPFLsZ7aUOO5GGecEnRgNPUZXVIVCfJhgbobTDKehXdrpT4Sjxrp+ByDyScnM3Chfb7f4ayPBQn6fml/0yDlY0TolhNSYb/3JBqI5ysPI5OVLyGTwSOSsJEJdjFNTh72VInqIvCnUm19t57NclrfhYiI+AFdCVxYw3ZQJVHeJGsoVYQ8yahERNNcdd/L2mlWFiPp/IZgfONa36LaxVJXKaQyuytxGMZUoO+CHhmJC0YRT+OiujIGbO1Qdu/fvyVy4Q2qWDN70zvBXPZ1JMPteCO67w99y7Ev1LoUlEfjS/8dsR8XzdMcCAO8M9GL5EKexuU8BtU1loQo+O0HEHLX6AlpHHFqccpi2K6Y4LZKU1XP5xkdzQvvyc53qd//wXq65g6IXNxXFLN1dVL1k8w7AXVeJ06zX5BPTNKrZPREa2ZIJBDOZJDkHa4ak6z+WH0GceTRbEt6RnRgNmGodUYOOPDSbExjVFxPNRAJ3JH9/HBub+poxyXcOYBkgVDAyBCSu8FeZX83qvjb4xLpPSj4Of8lfjKKle7q8bA1cKFTR2ZFsIMXvRmk7UtaBmG4aJoYocGMxsj4uvhN6wjvfMhwk1uxWbtCP9MaDfJTBXtXXVdQT4QJEgiW8Uq6wYvdXXl+CqJFX+fhGdBNZwJZjV2Z9Ovj9OXtzW5xrKUs6JLMDGds5c0NvwIoih8U/CaSgjqGrW3/rTw5o7udTh2JBdD6OholpLW4Xt4j6FNb7QtlmKxeFXESk3D7D56Yk1Yg5PU11YCSN8XiaNNnFCqpbSgFmW7ov9P2IOh7tu+yWg4X/A0mFjntlBX+orA9dlsuhwiEyb/Fjw1Tc77c7Vb+OYxEHhg+QVEJ77XVizQ7zN81HowKsW/20mQlYcJCEj9HgzFz2NUrVxGt
 S/Tsh6N/
 XifwE7BZzw+ELWuV1vP5gj/st9jz5IYXfLvXpRD6QxYbmr/tJjlUj1QB71hu3OjX8rsT64r5Km7hIiILA+jv65HUGkVeypwHpVAQCXKeD/Z0/t+dXvo5yLlTqegSPFBfJJ0T32gvCQSj8JF7yblB/PIdeb0WVu/totJiolsRtDKUYZO9d1jjQThi1Ke/A5nXLertn16EllhLtt+GOCq4UXJdg6ZnfzpEM8Q/+OT5vnw9GsmCS/N5U9oNbPoPqStawxWUooEYOVsTmwEqOVGk6vMLY2rBGR2BooWzlFJ9pZEwn/IgQXf3GLe6vh7ifXyoBH9lt95f1cNv2M5QalLL3cCIJsb97V8DWIv/MnEUJ3NJOm63FDxzA/ld3jUAtJEQahyXtm6iFOuOsVMux5GJ1B5vl5H5//CShDtjvb7llFPyYDPyTEbD1Pj56pK3JBjOd7rkhwPe2xXhBrDxqHtYW000TVvamS560VjClnON/a+pQOjJwJSdy02xBwKy4662O7I5Fyzlo/G7Y04hkrapZULRmrZ7tV5RUkg0247/Xbvu9eE8EH9TB0KX8+Vq4POiStg24TVqYZvwnBk6xU/h5YJ85mq/0ALWvf0tHoExw1L2Als6x+qcdyJGtSr5aQE8ji2tP93r2jFc6ZF4E2UPHlm50PvOTLJTtQii8aJ+SHD3jnRI+s3L92+V9P89e+jYAaTWRJJ6r9XqX4Ke6kJB4gltsAIokn7WjJsjr2oxRuAns4BU9yeQTMvwYn4T+2QBb9ilNDzNhCOwpGjnFhW/IIO2+hq+kRMBHQ8dCTSSc9fP3sovAJt9BhoZ8dCAX9nSqWU0mz4bvKBwaibUwzpJrhoPD23yKPiiqickc7YqMz4mjF+mjb0SFNG6unw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Kairui

On Fri, Feb 06, 2026 at 08:31:19AM +0100, Dmitry Vyukov wrote:
> On Fri, 6 Feb 2026 at 08:24, syzbot
> <syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    18f7fcd5e69a Linux 6.19-rc8
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1428fc5a580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=f1fac0919970b671
> > dashboard link: https://syzkaller.appspot.com/bug?extid=e12bd9ca48157add237a
> > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/2c19d9acc149/disk-18f7fcd5.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/02cf07c94e58/vmlinux-18f7fcd5.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/84011cec9819/bzImage-18f7fcd5.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com
> >
> > ==================================================================
> > BUG: KASAN: wild-memory-access in instrument_atomic_read include/linux/instrumented.h:68 [inline]
> > BUG: KASAN: wild-memory-access in atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
> > BUG: KASAN: wild-memory-access in __swap_cgroup_id_lookup mm/swap_cgroup.c:28 [inline]
> > BUG: KASAN: wild-memory-access in lookup_swap_cgroup_id+0xf9/0x1a0 mm/swap_cgroup.c:127
> > Read of size 4 at addr 0007fffffffffffc by task syz.5.3598/20029
> >
> > CPU: 1 UID: 0 PID: 20029 Comm: syz.5.3598 Tainted: G             L      syzkaller #0 PREEMPT(full)
> > Tainted: [L]=SOFTLOCKUP
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:94 [inline]
> >  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
> >  kasan_report+0xdf/0x1a0 mm/kasan/report.c:595
> >  check_region_inline mm/kasan/generic.c:186 [inline]
> >  kasan_check_range+0x10f/0x1e0 mm/kasan/generic.c:200
> >  instrument_atomic_read include/linux/instrumented.h:68 [inline]
> >  atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
> >  __swap_cgroup_id_lookup mm/swap_cgroup.c:28 [inline]
> >  lookup_swap_cgroup_id+0xf9/0x1a0 mm/swap_cgroup.c:127
> >  swap_pte_batch+0x3c3/0x720 mm/internal.h:390
> >  zap_nonpresent_ptes mm/memory.c:1749 [inline]
> >  do_zap_pte_range mm/memory.c:1818 [inline]
> >  zap_pte_range mm/memory.c:1858 [inline]
> >  zap_pmd_range mm/memory.c:1950 [inline]
> >  zap_pud_range mm/memory.c:1978 [inline]
> >  zap_p4d_range mm/memory.c:1999 [inline]
> >  unmap_page_range+0x1f6f/0x43e0 mm/memory.c:2020
> >  unmap_single_vma+0x153/0x240 mm/memory.c:2062
> >  unmap_vmas+0x218/0x470 mm/memory.c:2104
> >  exit_mmap+0x181/0xae0 mm/mmap.c:1277
> >  __mmput+0x12a/0x410 kernel/fork.c:1173
> >  mmput+0x67/0x80 kernel/fork.c:1196
> >  exit_mm kernel/exit.c:581 [inline]
> >  do_exit+0x78a/0x2a30 kernel/exit.c:959
> >  do_group_exit+0xd5/0x2a0 kernel/exit.c:1112
> >  get_signal+0x1ec7/0x21e0 kernel/signal.c:3034
> >  arch_do_signal_or_restart+0x91/0x7a0 arch/x86/kernel/signal.c:337
> >  __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
> >  exit_to_user_mode_loop+0x86/0x4b0 kernel/entry/common.c:75
> >  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
> >  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
> >  syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
> >  syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
> >  do_syscall_64+0x4fe/0xf80 arch/x86/entry/syscall_64.c:100
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7f2f8f19aeb9
> > Code: Unable to access opcode bytes at 0x7f2f8f19ae8f.
> > RSP: 002b:00007f2f900350e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> > RAX: fffffffffffffe00 RBX: 00007f2f8f416098 RCX: 00007f2f8f19aeb9
> > RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f2f8f416098
> > RBP: 00007f2f8f416090 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007f2f8f416128 R14: 00007ffc0c8cc050 R15: 00007ffc0c8cc138
> >  </TASK>
> > ==================================================================
> 
> This happened before:
> https://lore.kernel.org/all/67d04360.050a0220.1939a6.000e.GAE@google.com/T/
> and now 2 more times.
> All reports look similar: exit_mm -> zap_p4d_range
> And all access addresses look the same: top 13 bits are zeros, then
> some garbage (0007fffffffffffc).
> I am pretty sure it's telling us something, some kind of tricky race,
> rather than a previous corruption. Swp entry is somehow invalid?

Thanks for the report. It would be good to have a reproducer. I will dig
deeper later but good to have eyes from Kairui who has recent changes
in the area.

