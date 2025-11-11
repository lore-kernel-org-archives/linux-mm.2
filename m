Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FC40CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 13:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A451F8E0006; Tue, 11 Nov 2025 08:03:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1CD08E0002; Tue, 11 Nov 2025 08:03:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95A1E8E0006; Tue, 11 Nov 2025 08:03:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83C698E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:03:06 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0416313B259
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:03:05 +0000 (UTC)
X-FDA: 84098341572.08.6D3958B
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by imf04.hostedemail.com (Postfix) with ESMTP id 42AB74000F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:03:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf04.hostedemail.com: domain of 3BzQTaQkbAAw4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3BzQTaQkbAAw4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762866184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=CGB/TAKZOcKtrhPxjpEL/9Rt1n53HiPGQxYzu5TTEyA=;
	b=Lzu8OeRzb/j5rCBTLnRlv7dlpVLG/i0Ll5Qj/+OEicuZumQSfG9/FNsNaRr+MrobqUDJxI
	0az1A81d8QeD8Ezws1503ZB46jFwXIl+ZFx9nGNwygygz500POWmM5Ueluq5y3+v90mZUO
	kjyMpJspsdb0UfuBPiq21CzNuWL9R6k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf04.hostedemail.com: domain of 3BzQTaQkbAAw4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3BzQTaQkbAAw4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762866184; a=rsa-sha256;
	cv=none;
	b=0oXpjmYv8fDYfUfaaA4eAJ2vybF+bYw61XaSPTEHVtVZKQ/9U93+E6CNeKDLeCyTNvaTdp
	qbFjBmwoswodJHgx44wWcP02eaZl3dE3ku1WaUTKHb2DwSMCo+QXTOWI8/WOmkuFOco2iy
	NiEyJAuwhUCd+f6rf9QIDHFyfQ6H0zA=
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-43470d72247so1808975ab.3
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:03:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762866183; x=1763470983;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CGB/TAKZOcKtrhPxjpEL/9Rt1n53HiPGQxYzu5TTEyA=;
        b=DI1Tl/ircVSCXQrLenaY8+0vaak5UIandRYuZBam5XevHBAiTHUgVcl5LivFqqOAnC
         yTDS5QksuBwU04tHmLFQE/+UUG8bsTcnWz0TBrdj8/y1SFClquU/xkTVZaQ+2MH4JVaY
         x02aciIq5YZlDT0iEJXreDHgpiisdTb1x3rgJI0LupyGXkeuSvVr+XziQeYaYuU9ZptO
         uKibuzkWC3aRbp/b99ySK2ySw1p8BqHTBT8pXTv1QfdY8rXYvF3zhAXohwmenmRBMYrY
         eMxBL1kNtBr5/RsjB5q/zyCk9dEl6Z4crJJim/xbL/U9CsCdOY4rhI01WzqwxJmA7z7U
         kltQ==
X-Forwarded-Encrypted: i=1; AJvYcCXU43evOPPSJ5N6QkiUGi8cLGN1kziPkIV2Qpyzi13UZqF4j+fTZseUBvmDmEt/6OLrCTx6DvObIA==@kvack.org
X-Gm-Message-State: AOJu0Yz1ONJFbbHACEM+i+QGARqf7etJYKjMNX5xCLbV4/maOKRSGJXk
	9VVxTxWuMBHD+jXFggUVfAQ5WdlUUb+gQ5a2+D79UDnGQYGX3Gnnfes3k7bSbCXYw1t9+4DfjVI
	jCJPCb9YN01uDy+LiuO2V9cKouVEjIMmY9Sh7N0ieqV/BtTx6NHokwrkX2Rg=
X-Google-Smtp-Source: AGHT+IEpTzA/3NqtQbsss3Bt9ogTGA39GU8M8pGLRnvPzS3lXufcYtJkf55mtmGcYxBah4LCmhDhp2qV1vWIUjAYrBjwalX4qAqr
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2408:b0:433:29c3:c512 with SMTP id
 e9e14a558f8ab-43367e2d24emr143895815ab.21.1762866183264; Tue, 11 Nov 2025
 05:03:03 -0800 (PST)
Date: Tue, 11 Nov 2025 05:03:03 -0800
In-Reply-To: <20251111-covern-deklamieren-ee89b7b4e502@brauner>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69133407.a70a0220.22f260.0138.GAE@google.com>
Subject: Re: [syzbot] [fs?] WARNING in nsproxy_ns_active_put
From: syzbot <syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, bpf@vger.kernel.org, brauner@kernel.org, 
	bsegall@google.com, david@redhat.com, dietmar.eggemann@arm.com, jack@suse.cz, 
	jsavitz@redhat.com, juri.lelli@redhat.com, kartikey406@gmail.com, 
	kees@kernel.org, liam.howlett@oracle.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	mgorman@suse.de, mhocko@suse.com, mingo@redhat.com, mjguzik@gmail.com, 
	oleg@redhat.com, paul@paul-moore.com, peterz@infradead.org, 
	rostedt@goodmis.org, rppt@kernel.org, sergeh@kernel.org, surenb@google.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz, vincent.guittot@linaro.org, 
	viro@zeniv.linux.org.uk, vschneid@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 42AB74000F
X-Stat-Signature: dha4pn3irta5f7nubxt3ciy4dsf4w9p4
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762866184-134605
X-HE-Meta: U2FsdGVkX1+zcfNtQ0dxBAoVUO8kH/dPApQD2vCicnCP5baNQB/dDp+oMduy0U14dMAkYBLMwWrAHy585CcYpE2xL0SYQj+/uYc6L+XXRUz6Q2Oc+WX4WwLzkYVGsYnlw3lB783hKT+ab7DhXTZjFR265LjShFHRkrMpir7YBhiKb67UFqZ8n8QTPqRKScyv1fAkcbHz26x9xJVVXJH3ETvgWwuMrX8XM/4oCqH0Iz6jrwnSYkO/sZr7kzKUrr3xaEKnXjC4/zl0vQchGWlSuXj93vx9ll0q+1ukstlHUjJGuKeIFLJxntFin6IJ23ajNHVVvCVXft+dlLihOi/JH7IoQuvo8EMo34VOaaNZdIh+RWc+ruN4vuxq7PosqbMpwW8IbGFKCcjpHI53pQqvBFFmBgMr6HcbG4ThKppFI3or+VRl3biUn674w3MRK5XK+rmFMCJy78XuAHg5CjEISqHm5FPvYHA7wIRY6p15WTDQs4+OpvHwBZmLOe6pZjOCF+Rmw1T1jyqW2ysNjKW+NbrPwS9yDlHD/tGqUeG3JS/McyYvDYPgccOFYKwdjKGbaPBSMrsCfyEB4idZwaTblYZUtmVxjpjevxzkgspD07RTCK7jyZHIEYah2P4IIsrmKtEqf1HHxNDZHC0U+j9jc2QYU9f4qqorZ/3VKT+X7OK9drSNL6wo+Z9MHqlP7/EF8kI9qsEjwfFBIT9OprqhlVNnX59hdzfk4LM3qRTiOsMUtMrhHFYWkWDsKlDKtsmJidkqaaXOHFi8shmUQiPj7BDHVCbUFLTymzYNmIXMx8FVKn5LKAA/IJBMdOG/9kaX5ROpP8E9Pxh5QQgFvXtFiQBenamP1XP0rbncOQdi29NTvXMHpj0bQD0Q3BQ3uAkX/fEAp20IoeR9woPFnktZ30+WCJj79wO1xziZw1YNqjG0uY//s6lsrdnpBlCmEmgt9wBQ48mhcqhMsU9/aOA
 mqCx5BMy
 hQmT7nANXf2OTT2XujGSL9EAU3LMG8E0cYsgZWvIFeLemoNcuZ2u6o1/B7Tob/EoAeDsvpZP1+vZc7dMApHYvPwIn/iWkXOqwvttvvU8+fMZyGvbB41FUhLpbNwH4TQqotfiXV0hNYLz3EAyabUKVVpJUEoWnkyi9raOsD9n1RB84Tpfz8b/tkJvMZhmfxNegWin75VA1+gRpZX3pTM9wNSDaMeHpFq5mjBT6aQOPcHs6n/YJXCjIQCsOe8WPHbxkliWEE2idkIKmO9yvwvJUfCqv1LF4hmRGUsnKNGRs9t2uVo9Xomq0PIonfhBEErpev7rVlEYhzD9A2ZN47HlJ6F2LDbuim5Jmif328mA1n2K3Ago5geGMmMCHuBvfyvWLX5HdOV/nKJHDuMGRTiKyXPjkcXeUdafO9MvVIjAm7eJH/kiBtsHk705WJeHE50nwrYQ6PyNkcYND6/cBYJXjncRfWJKdtO4y6ZuQOd0A6XIaXUi6flRPs/hHpSNJqYdIYYFJfo+9i1JLLeF/Hj1tOOyr3x7h48DB59CUdDx28ym1ZT0X2UFZw6AvvXDk+la0ft496nXEWd6WBXECy4DpZsiuTAR/+bJe12eWsRXMgypVTRbudgCsBHMVwkeVGyyB0rLRxqzBWXCTe0Iof2cJ+fcFDulytdwvVYFO6wYOSNAVm4NpraPG7LU1Si+S0hR0u4/D6qTu8TNB8IEeKGl5DGxU8cW5rQyOOHFoNYVjmznuromTcwkuNc+fz8UcsPiHW36m1EAnI2jf2O2kdJOG8N1XiuTmn8SuID0C2vrJRz9ujEmIeigV9NimTZ+Q2kp18ceOQ4q1/yCAv7cULH+yMP56iyFdF9/9Yld+Ujl6wfkBuiB72ijufF6f2WGUhdwI4vmjQ9WWzshO8JSLS52i+hPjjMxEB92WlfcTMd63pYjuRGiZ9gsLCP4Zzs4YS0FcV9pTCkMI6ulM2SGwCl16f/evRXxJ
 4uFRnzlD
 XXIi817Z9IXWNNTv5pC6lSi6xD+2IlKgJ3HdOuqxnStfajmSHg09j43ijcsSQUjYQLA/wrIZ7tklxZIcjf++1qDRYCMlkX+d+5y6aeNR0A0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in __ns_ref_active_put

------------[ cut here ]------------
WARNING: CPU: 0 PID: 6581 at kernel/nscommon.c:171 __ns_ref_active_put+0x3d7/0x450 kernel/nscommon.c:171
Modules linked in:
CPU: 0 UID: 0 PID: 6581 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:__ns_ref_active_put+0x3d7/0x450 kernel/nscommon.c:171
Code: 4d 8b 3e e9 1b fd ff ff e8 76 62 32 00 90 0f 0b 90 e9 29 fd ff ff e8 68 62 32 00 90 0f 0b 90 e9 59 fd ff ff e8 5a 62 32 00 90 <0f> 0b 90 e9 72 ff ff ff e8 4c 62 32 00 90 0f 0b 90 e9 64 ff ff ff
RSP: 0018:ffffc9000238fd68 EFLAGS: 00010293
RAX: ffffffff818e5946 RBX: 00000000ffffffff RCX: ffff8880302ebc80
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
RBP: ffffc9000238fe00 R08: ffff888078968c2b R09: 1ffff1100f12d185
R10: dffffc0000000000 R11: ffffed100f12d186 R12: dffffc0000000000
R13: 1ffff1100f12d184 R14: ffff888078968c20 R15: ffff888078968c28
FS:  00007efc0fd536c0(0000) GS:ffff888125cf3000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33263fff CR3: 0000000030876000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 nsproxy_ns_active_put+0x4a/0x200 fs/nsfs.c:701
 free_nsproxy kernel/nsproxy.c:80 [inline]
 put_nsset kernel/nsproxy.c:316 [inline]
 __do_sys_setns kernel/nsproxy.c:-1 [inline]
 __se_sys_setns+0x1349/0x1b60 kernel/nsproxy.c:534
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efc0ef90ef7
Code: 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 34 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007efc0fd52fd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000134
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007efc0ef90ef7
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000000c9
RBP: 00007efc0f011f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007efc0f1e6038 R14: 00007efc0f1e5fa0 R15: 00007fff5692b648
 </TASK>


Tested on:

commit:         cc719c88 nsproxy: fix free_nsproxy() and simplify crea..
git tree:       https://github.com/brauner/linux.git namespace-6.19
console output: https://syzkaller.appspot.com/x/log.txt?x=1613f17c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=59952e73920025e4
dashboard link: https://syzkaller.appspot.com/bug?extid=0b2e79f91ff6579bfa5b
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Note: no patches were applied.

