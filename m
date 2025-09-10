Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85459CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBF5A6B000D; Wed, 10 Sep 2025 04:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6FCD6B000E; Wed, 10 Sep 2025 04:39:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B38086B0011; Wed, 10 Sep 2025 04:39:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9BF986B000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:39:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B0FE11AD75
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:39:32 +0000 (UTC)
X-FDA: 83872691784.22.8703F42
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	by imf10.hostedemail.com (Postfix) with ESMTP id 78CFCC0004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:39:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf10.hostedemail.com: domain of 3QTnBaAkbAAYy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=3QTnBaAkbAAYy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757493570; a=rsa-sha256;
	cv=none;
	b=DkyPG0zSyXJQq1hwlMEI2SDhbspXXUJCapEMOIEm2usSC2gQ0SyJBKGoIld6MMDCRjJ8t2
	vYHdhrg9Tx8jlHSPdrIWmHQgVSzHhDecfDUAgThN/fAYKP+b3lV6xOLaVGwoXLJSVkMyMG
	4pNzxKWTisUX38zFJUuzHjgntzo4t5U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf10.hostedemail.com: domain of 3QTnBaAkbAAYy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=3QTnBaAkbAAYy45qgrrkxgvvoj.muumrk0ykxiutzktz.ius@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757493570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=Wcqwa9UVTgt+vSJ2HOOPjUHsHWgh6bX7b58VAKjfe3Q=;
	b=Ao5fIDSZ8zP2R+Y2G5q1FX0qdS+0LG3DEqWfvSVb+98k99fJheqFmiDFDiz3tboI3sKVpt
	9m6VFzmLKbrV7FC3cWQ0DSKXAM4p9joRWOhuo8e6ALYNbtU/uFxtDLSw/5aKFhEnCzKCWb
	NBxjqBK0++Qk79yPiXOI/+XvkEsKZk0=
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-4190d8f16c3so2595245ab.3
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757493569; x=1758098369;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wcqwa9UVTgt+vSJ2HOOPjUHsHWgh6bX7b58VAKjfe3Q=;
        b=quHJWNLBxPjgnpt4EE2W+09XJNvyTIiS3rUdo0tQq8Fsg7E/CYhIiMgUJXcF/ULwtE
         UX3EMhckENVzZ7bEJM8ivBQOIAohAZWcqtlyXT9gWoG8OcyFdCnilgDeoJvrOSP1aLIF
         yqn7tB8KxTr78YCj5vuNDs/L3uFn1x+kmiDJ5tDs7xRNDZgbkaMJgHvws9RXUquZufZb
         1e4RKMLrP6znSLwbtdYnXkhGP83tUkK3WJhZ5OtwXD2lHpvkep1ubfXuOTDN6LaqvQpD
         Pe/e7WU6HIa5Ty34Msw/20G6H9amf4/7GW9GaQDXpEy/ZfRzupkAZZt2Dy7dORhfg1gW
         bNkA==
X-Forwarded-Encrypted: i=1; AJvYcCV8g8zDhLwTHHcI0IHwZyQxmux/cNobIFsJz7ZPFz8bbeYFtYCvdMSPfYwUVUM7eAqZDB/IbDbW7Q==@kvack.org
X-Gm-Message-State: AOJu0YzKDgqmLaoBmEbPsLQ1eMAlKyw+f1uwkAOsUjcmlSFgQnZ8JzfU
	aPTZ3IBX9hUMsUfTRlhxPXj717f/LTQhH4C0Q940LOit7BkMJ7uHkzLV84EPTKrzTg11jWOA80O
	qNFveHmdFQkm8nTXLNbqPYzw1PLRmOwAKO0kY32aU5w9ag6PLEiY5KuO909Q=
X-Google-Smtp-Source: AGHT+IF+kkdZuXHRGt39YmgS5WbPtMYJOAMbJ/XGa2whcdg3dnOyi8+jm0FGA1na2rxzdjWkeavI2JXVEsr6LVsp5+Vhp83goTur
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a2e:b0:412:f7d1:7432 with SMTP id
 e9e14a558f8ab-412f7d17596mr65192215ab.1.1757493569579; Wed, 10 Sep 2025
 01:39:29 -0700 (PDT)
Date: Wed, 10 Sep 2025 01:39:29 -0700
In-Reply-To: <20250910005957.54108-1-rgbi3307@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c13941.050a0220.3c6139.001d.GAE@google.com>
Subject: [syzbot ci] Re: mm/slub: Removing unnecessary variable accesses in
 the get_freelist()
From: syzbot ci <syzbot+ci49ef42f07c0503e6@syzkaller.appspotmail.com>
To: 42.hyeyoo@gmail.com, akpm@linux-foundation.org, cl@linux.com, 
	iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	penberg@kernel.org, rgbi3307@gmail.com, rgbi3307@naver.com, 
	rientjes@google.com, roman.gushchin@linux.dev, vbabka@suse.cz
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 78CFCC0004
X-Stat-Signature: eyajoyurghk944ycs1obp4tf1i9ti7en
X-Rspam-User: 
X-HE-Tag: 1757493570-876920
X-HE-Meta: U2FsdGVkX1/VsA6cW0C+Ep9YUaaV1bhVJ8H7Vpm2vQJEKfw8asQcAce7HYc7wVnVPQVYHfCc0ENwDtIElGMDdKjVgCg9dNmhqtkMlHMNqxFM+I/vL9HGY83p5D8dohQd1X2lWJTsRF7oUvGkdzCNqUSF/5G5BScj+MDlLirJ8J6tQV6iMUUcdGymZStPp0pz9dYcUEOVXZ7092QrnE4ev5pppl0Ng4K6tNxVAkYANmvRjUeAKc2QCjrIQeji9QQ0Be5iG7bR1lluWAkBV1wr5E5mzZyv1lXD37p2lkpwrskIj6PHdqCvXK/iaSgOMG/g3crztoml/pCHn7PMxfyXElZ//5iqexJN5ScAHlOM3VVp72YxC/Jx43yowCXp6+4RgIvBT7RVqsbOhStgHlKEnbcsGo5Z/j8V6MaotAZF8IWxKgfidELRXEZxW1weJTiWbv55+0macuoSfWRdKIlDkbR5yrgOiIsXiCTaUU6GOSJmqYlVmMKAMAauaeLV2W4liChNiDBYLhKX0m2awPlpMqQLH4L1cczOrR/7idE5iwrtcQ9fdzxsh1TDkNvHi70d+Mb4tlLhgFrvwWpGS0Ua2Z+C2D0WvQEh3vM/O6ec5CNeXaImxz7TDo/JF1rEdBmIKhEJmbWNDXqRl5xq8ercw+ouTN8X0kes4R8ea35xcKAR3/7ahcL28XuB7cY4oh6vXu9HQd66h2ySF9bevBalgDs8axuUZg+MhtTXri0Z/KKD/hARg5j72fgMlCEbDAIFcPCxu4Csud/RCa/mJdT70BKrI5wWl1lIRky8qemggrEUQY1wtxPc1iIOk1Sn/geeXSSRRD7j2adhpU7WySAtMof40jmP++AEoQDDJp9e0iLY6QoRTp9pP9IKZwF4zEjKoBBxiVmJyeo74pdriYsR/DwHZQzZ/Zdn9Vb270sLx6bf4IQNDu8boJVI9WxK7lmsI25hDuokpD6jgiIERpk
 N1+WDCxS
 cj0uIUDlUSo/v7zs0Xf6sj2QRzb9J1fgAF8qqfxHlmymrUl+NTbj5Otj7sJoxLlG4m0rFJ2B2zywDOAvFKPBrsytAiO7N+zQksa+Zl8JFs/9P+sjh2ARbYdYDTguEz2aXAVK8qzbBHqZBQSt+QlUJQjq8pUVY7pZj1jU0/T5ODMAfzJ1EuiuXdCll1an3TFrFP82MTgM6ygLQxQgdD7ywx1VIByFUjWIjDBJtH30YR5EqR95/94ZYIGhaiisWKGDWjTNUV8H6kUnxT2ksSx5Yb//Q8afbGBEQqGLUjJYgH10o5TyrXUmoJ0RzxOmQ5G8u8K8bWbZdgKM99Pp1tfXpchbGMjf2jUaowY4A0bpAdNrwvit7Q6USeSuqYoE3cnAAGgRBX36+VUQEL+SwWAEnUyXxbBz7zp28XgBBK6GsG/Obw/5a42P3PuGkooqmMiwPMQoxDrOM0++FmkcksqIc3EwCbxkNryHl/hKOcLx3CFCgu6CW1oBkTse7rTzqzZK12SfDugZFoHAsgZWb6mB3sY8YK+SdlBM9fRFKcYl6aUJ4IHRUrgtJoii4wJ+rrGy+7FjiOXV+JBzdso0xAy16QS+NiJpwTtlANFQSYVtv1dnxy4xAC79sE2vSmxZSw0Gr+mdcTOqWM+yfpPnFx+6q4reehdrXKJApuCe0zgyi1VMNEjXj/uzYnyDsvjQJV6+GRd3Nfc8aQFs2Yrnmsz0qKqrrulH14k3ZiNbM/A7Z8nJhHrnfKBBh9XV0oUY+Cr2AUOjPekY7/epmdRXY/MDkYqpj1o3prYoEQm0QOnivuB9N0YF6NoExdrAtutlPZvjJv5yjyGcnO7H3TpIwwAcqibc3glbYRpTna/OpZJA9sRduVFnZQ2iN0pJuZ5ez2FsIG40H4G6F0QG6KuUkyhF+V/Qt08QcDqhOWW9IqT+BUPyNbSBm3S+yAAaHGJQLNuzf8Jh7EFyB6/rRikIelV26hnK+BkuM
 3T1xFvA+
 CQ4+3GcV9J/lFcqElNckQldywl0OiqxQnuABv5eWFAiacmL4QmFGu/dPa8IA6dQF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm/slub: Removing unnecessary variable accesses in the get_freelist()
https://lore.kernel.org/all/20250910005957.54108-1-rgbi3307@gmail.com
* [PATCH] mm/slub: Removing unnecessary variable accesses in the get_freelist()

and found the following issue:
kernel BUG in __smpboot_create_thread

Full report is available here:
https://ci.syzbot.org/series/832d6128-4556-4bd1-ab18-0676b8e7dbc1

***

kernel BUG in __smpboot_create_thread

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      f777d1112ee597d7f7dd3ca232220873a34ad0c8
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/7bff7792-4edd-4680-a5e7-3cc9d97ac5ed/config

smpboot: CPU0: Intel QEMU Virtual CPU version 2.5+ (family: 0xf, model: 0x6b, stepping: 0x1)
Performance Events: unsupported Netburst CPU model 107 no PMU driver, software events only.
signal: max sigframe size: 1440
------------[ cut here ]------------
kernel BUG at mm/slub.c:3832!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:___slab_alloc+0x13ab/0x1420
Code: ff ff 4c 89 e7 48 c7 c6 3a a1 a0 8d e8 3e 4f 0f ff 90 0f 0b 90 0f 0b 48 89 f7 48 c7 c6 3a a1 a0 8d e8 29 4f 0f ff 90 0f 0b 90 <0f> 0b 90 0f 0b 4c 89 e7 48 c7 c6 3a a1 a0 8d e8 11 4f 0f ff 90 0f
RSP: 0000:ffffc90000047750 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff888100028000 RCX: 0000000000800001
RDX: 0000000000800001 RSI: ffffffff8dba8965 RDI: ffffffff8be33980
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff82189e55
R10: dffffc0000000000 R11: fffffbfff1f47407 R12: ffff88804b03e480
R13: ffff88801a441640 R14: ffff88804b03e460 R15: ffffffff82189e55
FS:  0000000000000000(0000) GS:ffff8880b8615000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88813ffff000 CR3: 000000000df36000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __kmalloc_cache_node_noprof+0x29a/0x3d0
 __smpboot_create_thread+0x11a/0x3b0
 smpboot_register_percpu_thread+0xc6/0x420
 spawn_ksoftirqd+0x2f/0xc0
 do_one_initcall+0x236/0x820
 do_pre_smp_initcalls+0x4c/0x80
 kernel_init_freeable+0x30c/0x4b0
 kernel_init+0x1d/0x1d0
 ret_from_fork+0x3fc/0x770
 ret_from_fork_asm+0x1a/0x30
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:___slab_alloc+0x13ab/0x1420
Code: ff ff 4c 89 e7 48 c7 c6 3a a1 a0 8d e8 3e 4f 0f ff 90 0f 0b 90 0f 0b 48 89 f7 48 c7 c6 3a a1 a0 8d e8 29 4f 0f ff 90 0f 0b 90 <0f> 0b 90 0f 0b 4c 89 e7 48 c7 c6 3a a1 a0 8d e8 11 4f 0f ff 90 0f
RSP: 0000:ffffc90000047750 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff888100028000 RCX: 0000000000800001
RDX: 0000000000800001 RSI: ffffffff8dba8965 RDI: ffffffff8be33980
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff82189e55
R10: dffffc0000000000 R11: fffffbfff1f47407 R12: ffff88804b03e480
R13: ffff88801a441640 R14: ffff88804b03e460 R15: ffffffff82189e55
FS:  0000000000000000(0000) GS:ffff8880b8615000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88813ffff000 CR3: 000000000df36000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

