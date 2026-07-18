Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AD4AC4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 19:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D159E6B007B; Sat, 18 Jul 2026 15:05:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CED156B0088; Sat, 18 Jul 2026 15:05:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02EA6B008A; Sat, 18 Jul 2026 15:05:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 54CA36B007B
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 15:05:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA2E9A0391
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 19:05:30 +0000 (UTC)
X-FDA: 85002826020.12.9DA7726
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1BBD8140008
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 19:05:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 3eM5bagkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3eM5bagkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784401529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=0vmcegl3OOLgh38fBpJ4SPH/8D39XCHqiqIL39qmmnE=;
	b=ww9Dy/y9fhSEAg7dxGRfC648YqVCKTJ06MVomvqs1JEaZqQxvWhBupR5Z4N3mvfnoHdws0
	RZhLpSRSuAEbhpUWb/Zz6qXL9Bd92i5kTqNihR3sAZCoyDxcdmoB8SsuE15pp2xpSu0JCw
	V3h4P1nzXMEl1K2OmsVnTIZkYNDcCnU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 3eM5bagkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3eM5bagkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784401529;
	b=eldkihQ8btlKBY05yknJe0Fk3UWrshEvAPhPHVA5XpdqbSP1DxDSaAe3FEw3a1aif24Cbi
	VGpa+oFjFdEjcuNXlFiVdn1d363dp6xVqo09aX7dHzaSxjzqlWjuIzh4Gj21GK691Yh7Sa
	xCJaiXvvvjLDXDn4Y8uDyGmngVY24qs=
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4a45b3f0bdfso8723411b6e.1
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 12:05:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784401528; x=1785006328;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0vmcegl3OOLgh38fBpJ4SPH/8D39XCHqiqIL39qmmnE=;
        b=Xo5ba2YUr9261dACAMcePOlDgQ85oP21Ghhkbehhx81LIHTh+zovYTWyAZo3PdgUv+
         1CJ8DqQi20c3AGl+7C2JuP8JRkd8uMGb9+Ngu9mugzwvvtjlQzzbz6HyZKNhrz1Ywp6n
         iPSNtQ4aGThgKSKFvNgBSPU4m9lkIC2DuKniWmxded9QxVT/7DXv6LriWOZTXrkityKt
         ef+v5taqX4I1/UqLZLIGdZcR3NrpeM0bbZCnXq7SuhjfoutQiOt7BDjc3zFZ4LLni32z
         VThvxhnxo1qfkzmrq2YVO2uWBEYLaCQWfiX51o3t00NIBhNTGS/GKpozkdXf4Ch/dc3e
         mfvw==
X-Forwarded-Encrypted: i=1; AHgh+RpTDWlYh+durHE0ljQR55+WPe8iK1PoREAVwaADEEYZrZE+LSgaohm5PBC1BDMKfclSkFZDj38lgg==@kvack.org
X-Gm-Message-State: AOJu0YzQw28E5YkHejQOCwi/03lvWz3FgMsGC+i4FFK7hzbK89SsgLdA
	Mndyp3Ohz+rUeDcpmiYZJC/1n0W4Qb39CcY5sQ41c5Vu38MJI2WBV+59CinHJ3CMX43Pi7jHlAU
	i30HbZxiC9UjhCspzvJjaYmVPe126ilOyMS4Gve3Qs81K79Ww0UO4mgcvklc=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:170f:b0:495:fed9:a84f with SMTP id
 5614622812f47-4a4d051ebc3mr3730981b6e.27.1784401528247; Sat, 18 Jul 2026
 12:05:28 -0700 (PDT)
Date: Sat, 18 Jul 2026 12:05:28 -0700
In-Reply-To: <20260718123417.16339-1-liavalb@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a5bce78.f1649fcc.2a4208.0321.GAE@google.com>
Subject: [syzbot ci] Re: Fix an imbalanced file ref count in the mmap syscall
From: syzbot ci <syzbot+ci8a1a6021291643b0@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@kernel.org, jannh@google.com, 
	liam@infradead.org, liavalb@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	rppt@kernel.org, surenb@google.com, vbabka@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1BBD8140008
X-Stat-Signature: e9t6uss8rydk9qftbmizc1qco3adhuhc
X-HE-Tag: 1784401528-92363
X-HE-Meta: U2FsdGVkX1+RueDJ8sYdVFzwFGSKM3i/wdXipPCBKHxTbxirAG6kdrzaShBHFbZCVr27aOKsAG1h7UxWnKUJtKPv0kaMOzEJwO5fA/SRry3GcP3fgqC92Yfodi0sRbteA6/2WPU7MsNO2gUpuRgCvPtewfelgPU+qTV1USJ5JTOSH9H5ya0q3cdYD7gZXHvqLH6K7TDhEAm4DFAjakBr81l0aA/uP+fXS5Vrj4SReFPUCq6X/nPgSEPcYQpPqga2KxPUg3PDHF6vKBwT5WzUbQfu8THUAI6pJbYSCGGa6o8dWnb2ffzFZ6OyPZDkFrL3r/D45gp8/RNvfQNmaFxGEvKciYk9URlGCVHwZSDn/dJuTX9rcqGb6vxOLjVGCHVCu6jW9bBDUQXtb513pdf1ets8M/MGMYaaeKuYOjWWe2VdBKrYCtGlmo0USk9i+Rx/ekTo/66KeHdfdbV2o47Vo6R+mbJTj70FvVIFbQnXO1EyCMBkeAkPOzUoqAIZmFJUBc3mubYZ4Z32pluzKgS3EaB7GyN4QKjbW0mq8G8vFbSlB7rZdoNDg73S+urCcHqNfaHnxp85PWBBjYALTRqkEwe7Eu/aiZoByRfsMk4D8biVxuXPsQdiJC4bQJGyDKZYUWHPooJGkbRajdrSVv8qygxYKuLoSBLaU5XHBLdtgcybyqL3l2ALC57JgtOLYICYVD9MMJ34r4NG2OBOsKRu7TAED44DF4v6OWl/SQKsgN8BHX6qWc9QxiqFjAIRiPzG0J1LGqM6LBvtMpWrc2zlemPEpy7JN/8hGJg0AaH0jzbVnqGMilFR+F2PnmuXv5DuSahMa/HCBE7EfiThx4ZZakm7H+Kyd0eqYwC8VZXFtjwbj/0RtPQYn7l9Qe7yudVKtmFMu5A6Pp7KC5J6uyfSUh8jUXJLbfBdzeR9vjkqZq5udxdPOLOR+iZ64FFcTqN86hyJLEWgKvc29utaAC6
 lNTGEtet
 sUGsokVYAOX9kxVoFI/EQod3Ib/doC8FiLOrTNQ/sTByTie/aBF6rpBiGhjt4I7pLhLXrN1b2diX1gR/udnTF58xEozv2CFyTWvDew+RV6BYKqGUL/9nQZgMFppjbwaEwKFu+vxrTTNZnYfGJN8YskwWF5Zoaa54Zw14zEEyUIsiVjBN+Mq/wUydazxpbpwmaCuhoQwz8AINn2fy/y/hQLVBdKhV49OkTLSuYZFJOqO92w5KMeILXTrup6ivHz1nOzyhFlhjP/h/iXoPf31AK8xYY2QnWk/ImQUcSzpjqgsU8HiM7iuqpiVDDNa8QOGSh7NadSYeTveCtKBTxCfNtu3FYDkIc9PY3xRgJjOfDIvj9Q/4sZpfLdMW7tgb7720p4bwMzP9gafQ5SZRnk3ahjzeLycBxaY902iORzYAnZ7b2toAowThSs/+2EYszFTo7W3n0kbmXafl+8X9CWezV3XE97ErMUHEzD1jB/XpfH7enFVWajHxVfEV8nm1TjzSwJHchJtF/72c3TKlbbegcZBptPuoETwgAOMAJwWgx+S1ijOzi50L2eUIAMd22SWOzRl7v/WDsiMy5+AgdY+hDVTkCFWsdMhWT+A/RUT4ujwmsHbkeamSWl9bF+Jbk0Z6R04XzN/iVlzlHrHyGEBFmEimhetfhDgGxtLSr0AXtrGbLxOAf/6jVrpejMLLy/6CrbaWo0VlXWjkg5cSKqBNrYP9RmwyZZ14E9QRA5Ihxeg+R0/SKCpY4SfaXltkQcV6YAlxHK/NNlpqAXRHJDROSkk2y2B+KmuPWqxGr8Lg7DxA4BgRixK2MVMi2eqvsZmfo0RMSJT2t4CF9crleG/XybXi04nTRxbAIZ7AKzrgWKB27YLlf8B3kvY2G18brIt6TC/WSwimG2cqkSTJanwwAMZYalzngYILZsdg8MzAC6rvSYjCBXJz30X3mHoqwcvs6PQ8n8Sq0bxh4Me0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] Fix an imbalanced file ref count in the mmap syscall
https://lore.kernel.org/all/20260718123417.16339-1-liavalb@gmail.com
* [PATCH] mm/vma: fix imbalanced file reference count, properly abort mmap_prepare

and found the following issue:
WARNING in tear_down_vmas

Full report is available here:
https://ci.syzbot.org/series/63d42f9f-f249-4678-8916-5464a15accd6

***

WARNING in tear_down_vmas

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      3827fe994db98623a5a619a72f15f57bf8274deb
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/f57e989a-6273-4413-b35d-20dab5a41e92/config
syz repro: https://ci.syzbot.org/findings/8f36751f-0976-460a-b5ab-de97c9074c0a/syz_repro

------------[ cut here ]------------
!vma_is_attached(vma)
WARNING: ./include/linux/mmap_lock.h:435 at vma_assert_attached include/linux/mmap_lock.h:435 [inline], CPU#0: syz.2.19/5813
WARNING: ./include/linux/mmap_lock.h:435 at vma_mark_detached include/linux/mmap_lock.h:455 [inline], CPU#0: syz.2.19/5813
WARNING: ./include/linux/mmap_lock.h:435 at tear_down_vmas+0x381/0x520 mm/mmap.c:1261, CPU#0: syz.2.19/5813
Modules linked in:
CPU: 0 UID: 0 PID: 5813 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:vma_assert_attached include/linux/mmap_lock.h:435 [inline]
RIP: 0010:vma_mark_detached include/linux/mmap_lock.h:455 [inline]
RIP: 0010:tear_down_vmas+0x381/0x520 mm/mmap.c:1261
Code: 48 89 df e8 01 46 16 00 48 8b 44 24 18 48 39 03 0f 87 e0 00 00 00 e8 ce a8 a8 ff ff 44 24 04 e9 9a fd ff ff e8 c0 a8 a8 ff 90 <0f> 0b 90 e9 2c ff ff ff e8 b2 a8 a8 ff 90 0f 0b 90 e9 94 fe ff ff
RSP: 0018:ffffc90003cdf7e0 EFLAGS: 00010293
RAX: ffffffff821dbb90 RBX: ffff888115e14b40 RCX: ffff888171f9bb80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003cdf920 R08: ffff888115e14b43 R09: 1ffff11022bc2968
R10: dffffc0000000000 R11: ffffed1022bc2969 R12: ffff888115e14a80
R13: 0000000000000001 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007f15b88e36c0(0000) GS:ffff88818dc1c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9033eab095 CR3: 0000000173ace000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 exit_mmap+0x4ca/0x9f0 mm/mmap.c:1320
 __mmput+0x118/0x420 kernel/fork.c:1187
 exit_mm+0x221/0x2d0 kernel/exit.c:610
 do_exit+0x6cd/0x2360 kernel/exit.c:992
 do_group_exit+0x22d/0x2f0 kernel/exit.c:1147
 get_signal+0x121b/0x12c0 kernel/signal.c:3038
 arch_do_signal_or_restart+0xbb/0x860 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
 exit_to_user_mode_loop+0x104/0x730 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f15b799ce59
Code: Unable to access opcode bytes at 0x7f15b799ce2f.
RSP: 002b:00007f15b88e30e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f15b7c15fa8 RCX: 00007f15b799ce59
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f15b7c15fa8
RBP: 00007f15b7c15fa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f15b7c16038 R14: 00007ffe1b61d9f0 R15: 00007ffe1b61dad8
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

