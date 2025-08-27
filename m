Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B9ADCA0FF7
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 23:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 994976B00A0; Wed, 27 Aug 2025 19:15:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96C116B00A1; Wed, 27 Aug 2025 19:15:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A8F56B00B6; Wed, 27 Aug 2025 19:15:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7530C6B00A0
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 19:15:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DC56411957C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:15:33 +0000 (UTC)
X-FDA: 83824096146.06.345432C
Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2E68E180006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:15:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of 3k5GvaAkbAMAy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=3k5GvaAkbAMAy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756336532; a=rsa-sha256;
	cv=none;
	b=DGFEQnzWzxkdoi7xA/CEoWOsPwuMC3hweq4r0jY0GpF6+NHoXqpUo6zpOWcm+wN3m3gRyo
	xHBqa7eMJ/Z5qIid7PO6xm9x752+AgJzKEu7t8xn9bxITZ2dsMKfpi03jh8gBTKfZAFP+g
	fKbYT4iNwzWwx9444FIFF0isir6Bj+w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of 3k5GvaAkbAMAy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.206 as permitted sender) smtp.mailfrom=3k5GvaAkbAMAy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756336532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=uGDUKp6Jifkzk/nND6NoukxFoNU6RlGCAv9Hj9lFmmg=;
	b=pyc0v9l9vN+1czG6TTz1SbrlI7M4ym/7LrvrK/V2b9LFh7+vFXj/75JdcCvkAXP3/ZAls0
	JMO+7NFEp7AEK3CiCveajn/+EygKeIw311+t8qYMlUbB8PxluHM7aufdfywsJ31Mk0Ov/+
	P6i+HCad+Kli/xbBzi2PrDym2ofgL4s=
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3e6649d783bso8647095ab.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:15:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756336531; x=1756941331;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uGDUKp6Jifkzk/nND6NoukxFoNU6RlGCAv9Hj9lFmmg=;
        b=Vd0QKA48C2tqPbZBqzIQws5pIIrDA/wLeGmwf/0VqwiMRtvycMt/kTYKAGU8yhWams
         aYfgz/cAU1EH64w5vp2xyH0S64uRzQNbGMbgQFseFpuV6JJmetnI+XYEl4+4A93MHPFT
         yOFUO/DiloDZNVdCD4+P+OaAx4X32vjUfBraVn+Pm5H8VMkynU644HN0qIqvi3zkMPVb
         VcKT+yVA91S/iZWPKbCbRlo+s0z2aunaRsiVguOWUCx5nEgusezBPYsjki4A0THrq7cB
         DwjkwE7JD2C3NhSoAfxZZK2ghTpPg6nKVXNGpS5pNlRWNEdf6Liq62YSQEQVB9IRuNdQ
         4a7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXxVZOFEdUzEYu3k7lJjct5pCWbUi8NGN0CcrkvGDwYC+N3yLxCI5T8Z3MXIQDytZD5Lrv75UZNcA==@kvack.org
X-Gm-Message-State: AOJu0Yw5+N8nHzefary9dx2lHsb6DRBTFZcvF2E5G3T9ybKqWFO3OJCR
	ZVY0bBJka5vFMKwx3M5DLPpeks/Kb5zrk5bfeo1aq8P9/mU5SgSeYu+SBdnygRlC4QnmzJgAyQ9
	lv8vENsefOi9YBILrU/e/XmlKSz3nHh+Pw/vl86+/bVzYTD21bhSv+N2XvlM=
X-Google-Smtp-Source: AGHT+IGBD/jbzm4LO4d90l1K5n08kpgz7DPRgUulbX5bDNiMrQfC/SyAfyapVvZs2qeQ1RInlZ/3O5lc9bXiObx+3TsyrG9ODKBe
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aa3:b0:3ef:88d6:1cfc with SMTP id
 e9e14a558f8ab-3ef88d61d2amr82393825ab.24.1756336531207; Wed, 27 Aug 2025
 16:15:31 -0700 (PDT)
Date: Wed, 27 Aug 2025 16:15:31 -0700
In-Reply-To: <68abd1c8.050a0220.37038e.0083.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68af9193.a00a0220.2929dc.0006.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in copy_process
From: syzbot <syzbot+69c74d38464686431506@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, bsegall@google.com, 
	david@redhat.com, dietmar.eggemann@arm.com, juri.lelli@redhat.com, 
	kees@kernel.org, liam.howlett@oracle.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mgorman@suse.de, 
	mhocko@suse.com, mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org, 
	rppt@kernel.org, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz, vincent.guittot@linaro.org, vschneid@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2E68E180006
X-Stat-Signature: bdk37npos9xh3iogthpwdit6ig8jc3co
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756336531-340887
X-HE-Meta: U2FsdGVkX18552UuLZJENAMU+I+Yj9v7CVjNuWi8p46cKtwGdyHCB6pqK+uyWKe/Q0hPrH7j6FjCQuhtgnUsdeisXwyd0ASvrwnFtTocYJjFFeACPH1tHVKA/WPQlATOeLQSbW4x7J6UnIZ2NuToZ/LGl1yVXRHCTqluGdhl3CJwm07AD/5ZxXc60ScpDnKhUAJ7/PyECYPnMlaMzrRzJGI6bBvMNpcuonndYZgzte43nq/90bkqZ2klsu4nyX0IoDoM0vf+C+v/hT84C8Yuh1e3BT1zs/7JhXt9edzk+1e+dAqjdyHS0EHPa4WutDIAyE8Ta+tEX5pLlGt3xSplmIRghvvuCFdP0oHkHRkXRctdqPQ7U613LmD1A0wktAfujUAMwiPUaCMBuqBasUgTQKgXMo0ewh0Bu4UXZaj+WbsHK4ucj/G6/u68PQjNJD6M2+omlTEpoxNBG3wgtz9yQQ6NJaNMyzXyrCBnKXyfQEOLXPPBk7Mui593i8dMhNrmJBNnEgjXyUrikW2lU6ucr33BUvweaI6StJz4NWLDFnu7mxSL4xRyuJtxPpW2qxyNcxw3dWscCdLrM7XMV3/opCV4+zVqipdTPv82zDIUtmsqqsfKjBcQan9uItRjEt/bmHW8kgkkuffrPL195xjalJCn5hJu8aIJes+tUgZHlugyma3akuoSjyIMihtIRFYRHqoaCwu6lua6P7vJynzWXwTZc11J/IhmO76esHnRiBslU3VmWNpUwrK91OAJTX0zDxUoBpmirpu5GQ17aCvvXHh3zvyTzPEpQ0YE/mYIs6QWc4eZIETk7sodWMHlzVXtAltERgpYYslaOu/TPQCWlzAKwK0Yoe9/cAUSP82S4N2gAeXAMicQjmLL+zdatDsl8R9Ju3I1QJ8DY7kQ9bfjRdV9etl9AV90nFIAlIAqv0pLTUZQAfjDV89+xUBICmhoqpmAa9v5LTM3VD1bra7
 Qf297Ah9
 8ehrHo1G2iB0FXqBpesY0bBXI8EO8viXTNnXJrQIt9/AVEJy4AYH8jZ80jx5c/YpEgY2GGp3UAJR+Uh6emnFKEMqNAXTMWlP2f9JZeI5saAaxDODPNu6Pq0XLmLj9reRYB0X1vgqvZeLGOu8V9zfKykQ6Jb4p+sCSlJLiOlXcxVccvOcXubCWTdxgCTEorXaw2vpvJIUSYaB8YccLv7NdRSfJgvi8ctnkpK5oGYFlbxf8Dv4H1x+UdCvrrYMBxOE4xZe8xIgQZszKl++1v2C4+tNX59CYkhuzpGlbsjRlPV82rPWpbMowsAVpVCkTp1yySutkgYyUHu60ZNoOIvrvbYa2RGdyp8GO5z6KTiQKotWhX41j3aW3ueIBNUFOJz/6DzQbxLlbIYtcglEuKnk5b7DUUwyy8c2vVlLSHmBhfXH9akYgwtWZzI7XXJgNR1fcltG0ddzDVrMhojCy15xoQOvv06UsBnwPPJGu0enN5fw3cY9JNMWgrcvv5+kdRLr5Geic/QUpbVJubFNh/FnPBzpdu6sUeknZtX7y0wxnD83dFdLX36621yeWOpuM+FbvsNOzjyert61YZ99MWV4/9AcJwP1Kt/A+0msavcNzdGTKuldS+nSvsARnD38PtJa1a+eCvFehIEKvYzzHaxNENw9byTWGZtrEyhRVk8+p/JogRkeDJk97alrzgPFAfh+DOm1FBwS1q1qyzppjInY8R/K5H10Ch5D5qzWoWyjYro8xe1xRKqvliqapZSzY7oEllU5UmS3HcHOj5t/b2gbeADurA5l8jQtYC0LXBQuaxz9DSMbfhaWELB1zhhS9+ptjrb7hUAJsVM2IkmxSyLWy3xohACVX5q55E1ju2TuEEgVlKfD0VAzaW1hZr7fLDbgOPBPME1VQuNjD3m7N+KnN2KFzYsZt6EfrbgX2z5HB2Ysz3p6BUuO9rBVAQH8faz56X+JKP/F9fG+SK/KdRap6r/p1nFjp
 ILp06ECO
 oGpnKftEjabh+Dc64VVV5SqhdkIMaTMrbsVAN0zSgmTyNx8gWm3jFwLydPxGOhKNbbaFtndOf2zgasry0bnfSv2G9/b6pLfkslMtIL7VkGN1R9irQgdCUIwUiBiLf9F0koCh1fn6dfdIsQ7O21j69u3soPqY/N9hkFAsZtND1MkKUMaHohhiRqSISvy59vGJR2WDKCsQWR9xmlQiR1AgDRENNLGxdHgAWp3zha0lAbh5Ma88bZfJFkonCnwaPizG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    7fa4d8dc380f Add linux-next specific files for 20250821
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1036def0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ae76068823a236b3
dashboard link: https://syzkaller.appspot.com/bug?extid=69c74d38464686431506
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13595c62580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/63178c6ef3f8/disk-7fa4d8dc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c5c27b0841e0/vmlinux-7fa4d8dc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9a8832715cca/bzImage-7fa4d8dc.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+69c74d38464686431506@syzkaller.appspotmail.com

------------[ cut here ]------------
pvqspinlock: lock 0xffff8881c5419bc0 has corrupted value 0x0!
WARNING: kernel/locking/qspinlock_paravirt.h:506 at __pv_queued_spin_unlock_slowpath+0x1fe/0x2a0 kernel/locking/qspinlock_paravirt.h:504, CPU#1: syz.6.106/8286
Modules linked in:
CPU: 1 UID: 0 PID: 8286 Comm: syz.6.106 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:__pv_queued_spin_unlock_slowpath+0x1fe/0x2a0 kernel/locking/qspinlock_paravirt.h:504
Code: f8 a8 9b f6 48 89 d8 48 c1 e8 03 42 0f b6 04 28 84 c0 0f 85 93 00 00 00 8b 13 48 c7 c7 00 0c ab 8b 48 89 de e8 73 9c fb f5 90 <0f> 0b 90 90 eb 95 48 c7 c7 90 e4 40 8e 4c 89 f6 4c 89 fa e8 fa c5
RSP: 0018:ffffc900100c78c0 EFLAGS: 00010246
RAX: 9e0501aa69750800 RBX: ffff8881c5419bc0 RCX: ffff8881921f9e00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: 1ffff11038a83379 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1c7a604 R12: dffffc0000000000
R13: dffffc0000000000 R14: ffff8881c5419bd0 R15: ffff8881c5419bc8
FS:  0000555565514500(0000) GS:ffff8881258c4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8801a12e9c CR3: 00000001d6f0c000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __raw_callee_save___pv_queued_spin_unlock_slowpath+0x15/0x30
 .slowpath+0x9/0x18
 pv_queued_spin_unlock arch/x86/include/asm/paravirt.h:562 [inline]
 queued_spin_unlock arch/x86/include/asm/qspinlock.h:57 [inline]
 do_raw_spin_unlock+0x122/0x240 kernel/locking/spinlock_debug.c:142
 __raw_spin_unlock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_unlock+0x1e/0x50 kernel/locking/spinlock.c:186
 spin_unlock include/linux/spinlock.h:391 [inline]
 copy_process+0x2793/0x3c00 kernel/fork.c:2435
 kernel_clone+0x21e/0x840 kernel/fork.c:2608
 __do_sys_clone3 kernel/fork.c:2912 [inline]
 __se_sys_clone3+0x256/0x2d0 kernel/fork.c:2891
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb44b1c3449
Code: d7 08 00 48 8d 3d fc d7 08 00 e8 12 29 f6 ff 66 90 b8 ea ff ff ff 48 85 ff 74 2c 48 85 d2 74 27 49 89 c8 b8 b3 01 00 00 0f 05 <48> 85 c0 7c 18 74 01 c3 31 ed 48 83 e4 f0 4c 89 c7 ff d2 48 89 c7
RSP: 002b:00007ffc514a7578 EFLAGS: 00000206 ORIG_RAX: 00000000000001b3
RAX: ffffffffffffffda RBX: 00007fb44b145860 RCX: 00007fb44b1c3449
RDX: 00007fb44b145860 RSI: 0000000000000058 RDI: 00007ffc514a75c0
RBP: 00007fb44a7fe6c0 R08: 00007fb44a7fe6c0 R09: 00007ffc514a76a7
R10: 0000000000000008 R11: 0000000000000206 R12: ffffffffffffffa8
R13: 000000000000000b R14: 00007ffc514a75c0 R15: 00007ffc514a76a8
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

