Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09769CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D1D78E0014; Tue, 11 Nov 2025 04:46:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 581958E0002; Tue, 11 Nov 2025 04:46:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470A28E0014; Tue, 11 Nov 2025 04:46:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 331FA8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:46:06 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE076C04B6
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:46:05 +0000 (UTC)
X-FDA: 84097845090.14.F269675
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by imf11.hostedemail.com (Postfix) with ESMTP id EA8424000F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:46:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf11.hostedemail.com: domain of 32wUTaQkbAIIy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=32wUTaQkbAIIy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762854364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=pxx43rg5vTwPZ2wNbygdxPupwm5jqNPgGIjEmJm74aE=;
	b=YhBbfoW/6DaxIJMmCa3y5+kQC31/syaP1rFqQq0TiydMO5jl5iNt+yhc9rg5EvGh9WnfCf
	bWGetIhSFlDWtjNFOAXsn/wV7BT/lSCFTYZkGOtHJDREFLKmNpvY80/Gb2Pm0o1xzZLFfb
	ofFaRglnK3GRfLgG9NVGGQd/H4XbL4w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf11.hostedemail.com: domain of 32wUTaQkbAIIy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=32wUTaQkbAIIy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762854364; a=rsa-sha256;
	cv=none;
	b=541F1Mr3XXiylWsoQEPeTr9TLJ45FeUGLGvGjGI4sCDWF11Z5i2i5fBDBTn/8wXPRrogC+
	0+75dtKW8ykFHIL/BWkoY5oq+liuoeykJzAPbSLJ8jOsYX7PnRHzyQU8IGyOPKlxPKo7iu
	nhovsPSgPPZgWXGaaMLjO8Z9uv1UHiI=
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-43329b607e0so59162565ab.2
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:46:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762854363; x=1763459163;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pxx43rg5vTwPZ2wNbygdxPupwm5jqNPgGIjEmJm74aE=;
        b=JBvt12nFP+PMfEOiN68yEWb8yxgHwo/NwhhtVTMFNhCw8lbqzugE4AVhV33n+DVmfl
         6dt03gDa4c1mW+67FctdoLMAuxaju/oL1qauck0NS2+2SK/hsgywwHZZVzWLqM/asErJ
         BW56X4tY70Oo0Q62490be7I1yTVartOUtxHMfZAf8srmq+UgaSY2035Smus3ym7yb5jB
         ma7wYzs5+jl4ymjRrD8J6qa9M/xYtW4TUpKw1HYlUGnETEbF8u8Y8ONZpK8DOmqDRdyH
         6bZIPN3kyks3Yanyp6gExdXC2V57lQ6LB4UouAfDbkDurDMiTdti4iEZcJspx5e+UoLf
         kKXA==
X-Forwarded-Encrypted: i=1; AJvYcCW1G8CoiUTn1oITBWvJ63PoI5TqyRFx9+duYniKE/iZ6D7f7WA7nwYkOTUtprt8y+SLtvBSbsk4Ow==@kvack.org
X-Gm-Message-State: AOJu0YyoiqUPTR5noc6xOuLbLXdWpfHSOoxs8xVN9kUUCKHyvbZpb/Uu
	cB8aene5EBjkCNepcfSVCwRiUme6ZrBBdT0mNaOmEV58zRMrsaAheBrMGU88rIzL3BmE2Cz6Lkq
	utcssU+Nr3LH63VIncAmeWUco9TSrbDkGbX9H1atkG1meAyd68fOYEBPEJDY=
X-Google-Smtp-Source: AGHT+IFqLPDPKBiPRu3uu7IeP812DZQb4h/dmZnbCd8SnvgWxvVU1yv/z8fN5lQPvlaeArHHV0ZoY+wPaoICTLGVJWFDgk3ltdWI
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:349d:b0:433:4ac7:13bb with SMTP id
 e9e14a558f8ab-43367dd8a03mr188557675ab.11.1762854363073; Tue, 11 Nov 2025
 01:46:03 -0800 (PST)
Date: Tue, 11 Nov 2025 01:46:03 -0800
In-Reply-To: <20251111-lausbub-wieweit-76ec521875b2@brauner>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691305db.a70a0220.22f260.0130.GAE@google.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EA8424000F
X-Stat-Signature: o79ge4fnmnccx3m4tcgmhhef71r3boi5
X-Rspam-User: 
X-HE-Tag: 1762854363-770884
X-HE-Meta: U2FsdGVkX18YXaLkaqIXv17SN3YzJIHTvYAjD0nWsuo9Oiy2AGQuCf4ch7z44INzCqX32HPFDiBsZJCnRmMdtEn/Hw81VFgwGv6slVMJpggo6gRckNWd1/t8374eLwLhJkq51BIYr0f3L7uzMQGVFmPX0lZBy7kH6nynOiXtu5TTXi1RXtdHD0HNghYUJY1gTz73/MGg2Kzr3Fs4rJAvgsrkTNNiixLIypv7DYqLRFNdzTM9oxIO02IG4NVr4KgzcfIk/xAnzDALpibhSshoXRqtQrnjMYIBHGsgDgHlQkAjL3H3f1w11UNJ/sZNN0fhp/18ShR5GbO5Z1ho8uKJ6WAa0riKeTI95KVA3/f3VxiaPgeUmskcP5ix7oWxATRFkxYzTU/Ai/c8HMXDjHA/8E/2/3LJQ5KII79nRbJAJRt5lcEzKhdb9zfpp/kx8cp+32bi3uEq9iNQ6VIY6XFZiDE3M5A3Zp17HJc1LJIh7qqcz2DaX91cM/SFuwDrINhkTWkPAN5hfs2DwGX+z6537bJ+cAQxhhrkSKsf9NkM7Ga+ikjsE/VaT6sqiBf8/+SqcORAImVIOKL3P52S8cJ4SaopNBfKDEs+CZ1ZBSvloGnDJ5Ds+e4XLQZ63O8TSsX2TqKih6rIIpgNOlBeojEFNbldF4/KyhfPU6ctycAYr2sJ/yoygBTnhJs4tbjPF0XXOtel0neBhPaa/sp3NarIff361hdnjz60d3QgF/upx1cI3DLpMdA63zdw3ZK0HqfaosshncjmYaHpQAjZEkP+DLbjvIIk71O6+3L03S31mfW7w3ThbnCn1i2BSllPOY4RxWybYXocgeLpwif3+9WjVk3V/roJtVHbI1DdwvRUMbmOD3Vm/z7MlyQPrNF7whnv9xsh8QNArhzkvSyTFtRZJEjP8ZVWSRdryYzGsbQH34XksRGVlMe4WuNJYJbEXwyY2GCNnGNxez2g/ZsUhtk
 Ng7TXcwP
 4ex+S+QveqHC2NzwVX5KGa82/PzrdIOzUzDN148FdayCYKESBVzpH/I3c4VvwTeCMa7MMugsH6EfO+9dDOW+KIjs8uIvwWp53YhC7/WukWqiiaXE+CfiOITx73BQe+GgQ1d5T9+FTKP/2cfDogxsCrqkA5oXriQglVtDApTpibbyCXVzD576Qsubt2BV0yHjsXO9JHnTOfdsIO6edEm+nQ2X/gp3prXkPavSLvTD4shf9OgiMnXZIonsn4zIOm4gNcohpUzJ9wI8Zf2iNv3SdPh/r6nT5HgFzcDt+X9jlJfabklDeG7E83EcLTGTLZhBYvNvnyGx/y2bAhsnhiSYjA8Bn4r8cPzVajFKOsetMLJjyicrkDTarpq3a7UPM4pda1AanGFjzRNu+suXyTSttiA3n+TEd4jcty26m7xkdeAFJ5ddByoPVBBSzz4dG3pLaHPK7e6CVsP7nj2O+GnlvSXVuKK2S35ihpFPfFzhKGfxGgkZGgQMAaWaqrrqla2JXkyY7ow0dK9IrAPDduoW6OfiZSWNupYGgaa2w5aikEuUCtgs+YqVtK25TW7QByaW0FjntejCL+8mFY8rX73eSZrox5SidFBHSyw+gHTvoSvRfsj9UYucaZHrQFWHCjyM77lQUxD3zzsNbG4QzbasPuy3ZP7LZiTUWRXLGwI2ODdJHgURhSmBlU0p98gC0iXcMC0NbGpNRb+tT0nqW6Hvz0y+O7xv0qUu/urugJ9iD8hsAanw8l/OpAeDTJrHiN7FxRcTq97UMxGR76djCUmo0/VPhwdO0v6i7HSMuchzLJJJDgvfpiIFDw4F6nKOcgblT9LuA3k9Y9rVRowthJ1k5xsa8Pl/RSlXQO7yAzd7L2MUCl6teN6BeVLmtsNy9SU1f7bUK0WxVGUs3m5dmebcCYRlc6kBXWkfRFvI9+NzqXcXP6hU8GuGearQkQtmHEpkMTIbw6ItLIOlXpJYtzGLqhqmnE053
 PK+7NsvY
 2ncdpfndkFSQ9MPBFhnc2l/RP/pTglf9ts7kESpFM08mdqYMm+kDuIGgC3VzNa6pC9KVNw6kHWzzI4GFkxfZe6kZNJQMSno+Qf+GC/hkV+0=
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
WARNING: CPU: 0 PID: 6489 at kernel/nscommon.c:171 __ns_ref_active_put+0x3d7/0x450 kernel/nscommon.c:171
Modules linked in:
CPU: 0 UID: 0 PID: 6489 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:__ns_ref_active_put+0x3d7/0x450 kernel/nscommon.c:171
Code: 4d 8b 3e e9 1b fd ff ff e8 b6 61 32 00 90 0f 0b 90 e9 29 fd ff ff e8 a8 61 32 00 90 0f 0b 90 e9 59 fd ff ff e8 9a 61 32 00 90 <0f> 0b 90 e9 72 ff ff ff e8 8c 61 32 00 90 0f 0b 90 e9 64 ff ff ff
RSP: 0018:ffffc90003457d50 EFLAGS: 00010293
RAX: ffffffff818e5b86 RBX: 00000000ffffffff RCX: ffff88802cc69e40
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
RBP: ffffc90003457e00 R08: ffff8880320be42b R09: 1ffff11006417c85
R10: dffffc0000000000 R11: ffffed1006417c86 R12: dffffc0000000000
R13: 1ffff11006417c84 R14: ffff8880320be420 R15: ffff8880320be428
FS:  00007fe11c3746c0(0000) GS:ffff888125cf3000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2d863fff CR3: 000000007798c000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 nsproxy_ns_active_put+0x4a/0x200 fs/nsfs.c:701
 free_nsproxy+0x21/0x140 kernel/nsproxy.c:190
 put_nsset kernel/nsproxy.c:341 [inline]
 __do_sys_setns kernel/nsproxy.c:594 [inline]
 __se_sys_setns+0x1459/0x1c60 kernel/nsproxy.c:559
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe11b590ef7
Code: 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 34 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe11c373fd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000134
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fe11b590ef7
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000000c9
RBP: 00007fe11b611f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe11b7e6038 R14: 00007fe11b7e5fa0 R15: 00007ffcd9b83d18
 </TASK>


Tested on:

commit:         18b5c400 Merge patch series "ns: header cleanups and i..
git tree:       https://github.com/brauner/linux.git namespace-6.19
console output: https://syzkaller.appspot.com/x/log.txt?x=12c08658580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=59952e73920025e4
dashboard link: https://syzkaller.appspot.com/bug?extid=0b2e79f91ff6579bfa5b
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Note: no patches were applied.

