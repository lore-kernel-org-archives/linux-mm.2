Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96CD4CCFA18
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 07:41:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C801C8E0007; Thu, 13 Nov 2025 02:41:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2FEA8E0003; Thu, 13 Nov 2025 02:41:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1FB88E0007; Thu, 13 Nov 2025 02:41:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7EF8E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:41:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3DF1513BD22
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:41:40 +0000 (UTC)
X-FDA: 84104789160.24.0580E9E
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7785140006
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:41:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf01.hostedemail.com: domain of 3sYsVaQkbAG4eklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3sYsVaQkbAG4eklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763019698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=jWzdKl7vgdIGJfdYX6z8A/NZowwAqQ9vSHhm0lIHqaA=;
	b=pue+8agrGkUNPP/O9iguS3ZcwH7+F3HRI/OPHHXet+TLbbjRG54ZCaM9nk5uKl790lA9Ur
	PIr3KpCwY2KUbgYJhuRUwaSVvTHDljkpICM5pVuKPixBBx9LfKtFjKGtqC1lvYqFUNA/y3
	XZzXF5BGr9HyFnYQkXavxaQATPAe52M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf01.hostedemail.com: domain of 3sYsVaQkbAG4eklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3sYsVaQkbAG4eklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763019698; a=rsa-sha256;
	cv=none;
	b=YCBY8A3UlYG/cH3MRVo34pHxlFXy6XzqWqMVGoFFySdpLdTEDPHzx3oQau+/WxcsB77cIm
	0HS7b+anEG7tHQOk0x51MByArl8sUyxLUs7SWEaO4+I0HkYHaVP5kaRosZSB3JfvQb9P1p
	EjHQwqI0gRQghpUYnQlj16NT1EdbN64=
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-4337853ffbbso7613175ab.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 23:41:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763019697; x=1763624497;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jWzdKl7vgdIGJfdYX6z8A/NZowwAqQ9vSHhm0lIHqaA=;
        b=wyOXcgbwnwVgX4SMvC42CzsW3oIFr7xxqAcr1Mv4uLtDMYl9Ewf6j7fTfIlqI8r2UJ
         1KooLAGSM2CwmugKl2523ODPcviZHakgtifbzGR6k03G6I/lZ9DnC6B9lFsXicWgQhBB
         PqeF8+Z2GOAQ5S6uW7oE0277LN5hz74iH+ek5Erp/rqWfCP6pJ6/f3sUb8FQVbgVkj+x
         0vVuJ8JGSrAXBoC/XXzif8442zbFAkSEaYGpMu7Pt6MDtZ6A0sIP4zs1zyCrdOQtlB7K
         aki0BkjzCHov8/U6AbXdAPCuaYN+9vqxCr0alS9rp6uvj+yxjdp6835ihOg9txAhSd+R
         WKpA==
X-Forwarded-Encrypted: i=1; AJvYcCW6G2od8eTF+QnEnC8XkepWG2gLFT0gjYDe8yvAJQd2hSkCWgU++Krp7n+Y+U7RreYr0YnYt5HN7A==@kvack.org
X-Gm-Message-State: AOJu0YzQk+oyJEVpcAhtP0+tuqbAlSrj7iAa0AfczZAWk4S8Kyqd1hRY
	b/yIKKDYZcLm+e+AUZXzHG6DYQCdVMIr0efunlmukYaKvMNc7ESPQPR8/1kdZVm5oqJQ4t+T1oK
	q22S4rCbjpmo8BSIVrPZozPOk1fIobdYTJ3N7ublan5rdjqZzNFnx8F7Vrw0=
X-Google-Smtp-Source: AGHT+IG3FVRXoV3IJYse4nKZ7YA6tLNSXRmqIqWo6eFJ4/fcr5tzXzRXuvajfRcvKmFz7PDAabk2bViR8Eeqb1Oz5r5xzHzojmQl
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2283:b0:433:2812:8066 with SMTP id
 e9e14a558f8ab-43473ddd4edmr74082945ab.23.1763019697635; Wed, 12 Nov 2025
 23:41:37 -0800 (PST)
Date: Wed, 12 Nov 2025 23:41:37 -0800
In-Reply-To: <20251112185834.32487-1-vishal.moola@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69158bb1.a70a0220.3124cb.001e.GAE@google.com>
Subject: [syzbot ci] Re: make vmalloc gfp flags usage more apparent
From: syzbot ci <syzbot+cicff749feae9a145a@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, bpf@vger.kernel.org, hch@infradead.org, 
	hch@lst.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	urezki@gmail.com, vishal.moola@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7785140006
X-Stat-Signature: 8ojc8neuwep3dayfgesshicecmyigmdh
X-Rspam-User: 
X-HE-Tag: 1763019698-266520
X-HE-Meta: U2FsdGVkX1+lrLmMtZ5pjjA38jUA+4GZfaoKtTogLQVPtKokuar1J5sKYfCE5HVFbglqIlG7nXho2VHze7y489+A0OQmGhGI1fkQzgsrHMnkMscfCkIyXEgz/XJZ8zTwMaKsr7z9qM8UFERPVb2FEcoJF1qCUxeu0fCUT3uq3jh+IvnIIsTrRXTLkB7aCmk4c5pewU20LGbrfDYvubFre255cH3mjVidC+B1mqTridAWgdVNadohd3TZ4AJZ0s+fh9oOa9dRJOTdIlXf+aeH/zogxIKfIakxldtArJ76udIUz2zXjYQir7kziq9GjPLL/0vWubCr+I6Sf85GPYJfcu1XQDLix5QlBC8yybMbZZX1qIMFD8d29eooxOyB6cFOYPLbTcUgM085EOas8uqnW07Mj+f4TQzd1zXu7B1miNM/N2QOYSje2LGjTMhrbQ4r0ukbvJ8ZAmdZJ1UhGjwCuRPPnmBrdI+NXhUo9Ibt/iFSatc6P76KeRU0WWIDq3GqRb7Coe37+CKK862oFrHEkSiDdSv3z7K/n9808bay+bLRtz9ZRPpyVE89kI6zytrNuqApa3QMxGED6xiHhCVGrVx4VnfyC3Q+NMhlVYp4+3MIlNKKFnxT7ltVztSDR8XpCuSoQh3j6Zfa2+F8/nbbzd5EzYmrBod1rEHwL2RAyd+DjGPdXH7K7U/In/exgiy0TnvWgrwPPx4UvlK3BKkR0THCV0F1KfYHoIi+IyJeqmY8BwROXr8J7QODoTsAryvhJ7fB5W4P7mtxaWCx439nMc8axZAIhc+XKYSgvLYnqQIivXVgch55Nd4zaphHmnaUZxna+tYDX9/8vrYB082QALIWO0A17LoMcDVyJDEny5elYjFKP7PNNXEVRVLjVtAq81NhIXROOuFvAz+BBY8l/MUkRnP9Rc4Zpe/RhmBC/E35iNcqdCwnGl/6LXxIVDdq4fYpVElW2dpxK2AXskG
 lA4Kcm7j
 EVduCg45KPGDPAP3QzELKCkdKZoaTbElAiachNgdKgP/mXmTJwPo9/9CQFax+Nrcqf2zMRCInOjbqYKYJ5Z2oYsK8lIlMPg8L+U4i9pUTeIXcV2s8ZztAYlraBTsghYSIIyQcjhaeCigwDWJLh9DZv9JVnmX38PMqyTgVVLNgdB6M/628X4PieII/0j9Ndh2Q7zeEUqCtqZlyZhlkE991V/+hsnPQEFglwerxSHhU7XP7NP0UCWT6E19wyFgJaXcDMZXf8kdi5Z2Xaf2mDDIdHp9uieGGqksDtM6If1LRvLQMH0+BOeoy2qv3gAvjlr7tQOWZ8HU3EaHgIzqNY4anYJHaS5WhTA1u68V+CouMZBJNremvznaeqjyWkBf/WQnXwPV039qs+Op4yJoT0RuGYjikuJ897N420abLEZ/jHtaOuIisgEzenPFLUBpQDueRWGhdIQMQAfGI8FzmR3lvJpHU4dTreEFobcpI1B0f4W0bJFvhB5Xy3+t8PxKS7S4XAjgm3eBi76TwZ2cMgmHADU/jdJHA7XG0egTgfZgXd7tCWOw2d/j5gp6UXZuxrcwdZGRXOBFQmNSkEw/cIubfhWHrAZPL/Quo1C/1BNxtYBYV/0/sqc6YKonILI8tapydjIO13zmbjau408i5V4KlSq3R0Yep0YgaFJ68svtfgynzYvoV8QyQ2lJgC4Jsv1AFdrPvHIPQsljsxf9rnIQ0ayJGKzuQS5tSRFBWK4N7rbC/c0WiUciw8IeWAbldV/S80Luq3hHGISuUBGfKGK0pNwVCbeKjXarD19esx8AMBxWQ/OX//DWejrm5Dw+9gIRfkoFZ8B9l8H1cvGIufpeOi8yg9T/8j6jrYMn/hDA9nWkX4Jkq+MOU+ahqhDMgHN2n+zFYnMR6ldwxd7xGx39fC5UeRuSCAyixH6MHwK6kUNsfjd6rvj66/OC6Is2aWliNEY/Le9wOiEQmMXSjS6m4PCSJZUOo
 VoAcN1DY
 J72fgurSZiKiL0nlA77Oq6uV1Et4w3LZRmMps2OlpQHMLcsHdXt0zkzF6E75jby0jxJqMm0/OoSqurLIQiAkkULUGMPtz7raH2pbVd+Wlig=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v2] make vmalloc gfp flags usage more apparent
https://lore.kernel.org/all/20251112185834.32487-1-vishal.moola@gmail.com
* [PATCH v2 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
* [PATCH v2 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
* [PATCH v2 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
* [PATCH v2 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()

and found the following issue:
WARNING: kmalloc bug in bpf_prog_alloc_no_stats

Full report is available here:
https://ci.syzbot.org/series/46d6cb1a-188d-4ff5-8fab-9c58465d74d3

***

WARNING: kmalloc bug in bpf_prog_alloc_no_stats

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      b179ce312bafcb8c68dc718e015aee79b7939ff0
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/3449e2a5-35e0-4eac-86c6-97ca0ec741d7/config

------------[ cut here ]------------
Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
WARNING: mm/vmalloc.c:3938 at vmalloc_fix_flags+0x9c/0xe0, CPU#1: syz-executor/6079
Modules linked in:
CPU: 1 UID: 0 PID: 6079 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:vmalloc_fix_flags+0x9c/0xe0
Code: 81 e6 1f 52 ee ff 89 74 24 30 81 e3 e0 ad 11 00 89 5c 24 20 90 48 c7 c7 40 c3 76 8b 4c 89 fa 89 d9 4d 89 f0 e8 a5 a1 6c ff 90 <0f> 0b 90 90 8b 44 24 20 48 c7 04 24 0e 36 e0 45 4b c7 04 2c 00 00
RSP: 0018:ffffc90005557b00 EFLAGS: 00010246
RAX: a6bff5ae8e950700 RBX: 0000000000000dc0 RCX: ffff888173b29d40
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: ffffc90005557b98 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1bba6ec R12: 1ffff92000aaaf60
R13: dffffc0000000000 R14: ffffc90005557b20 R15: ffffc90005557b30
FS:  000055557c070500(0000) GS:ffff8882a9ec0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f86f6df0000 CR3: 0000000113d64000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __vmalloc_noprof+0xf2/0x120
 bpf_prog_alloc_no_stats+0x4a/0x4d0
 bpf_prog_alloc+0x3c/0x1a0
 bpf_prog_create_from_user+0xa7/0x440
 do_seccomp+0x7b1/0xd90
 __se_sys_prctl+0xc3c/0x1830
 do_syscall_64+0xfa/0xfa0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fcbe2f90b0d
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 18 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 9d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1b 48 8b 54 24 18 64 48 2b 14 25 28 00 00 00
RSP: 002b:00007ffed4000b80 EFLAGS: 00000246 ORIG_RAX: 000000000000009d
RAX: ffffffffffffffda RBX: 00007fcbe302cf80 RCX: 00007fcbe2f90b0d
RDX: 00007ffed4000be0 RSI: 0000000000000002 RDI: 0000000000000016
RBP: 00007ffed4000bf0 R08: 0000000000000006 R09: 0000000000000071
R10: 0000000000000071 R11: 0000000000000246 R12: 000000000000006d
R13: 00007ffed4001018 R14: 00007ffed4001298 R15: 0000000000000000
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

