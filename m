Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC3DA606A333
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC0C86B05B9; Thu, 19 Nov 2026 02:00:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79D86B05BA; Thu, 19 Nov 2026 02:00:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C39836B05BB; Thu, 19 Nov 2026 02:00:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A44F16B05B9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:00:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3FF52120981
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:00:33 +0000 (UTC)
X-FDA: 85450970346.06.830CDD5
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7C51640007
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:00:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of 3jp7-agkbACUTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3jp7-agkbACUTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795071631;
	b=IoZIzSk0s6AxDJWBWg7rrNuvnv+7m1r7ciY+ffko+WTpItynxEGgHqUhwkxFgp/aKBdo+Z
	DskEKghudNX7uBnggBcsDzbxV3PPctJqrN9qrAXpSuPiInSuXRiV6ekkYD4g7f0acDU9hu
	ok5qls3jE/VS/gabgFVDJmlD3qFfbaQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795071631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=43dOOzPr4kWGfR+oDKr9fjX9nu8m4LA8+j1vqIMP6kc=;
	b=TLVXwnGr82LxGgR2KwOoVSj2KM5XN9jJ/2nXe6Tv/PlWKs2uHaVa0WTiunitk6FD4VCQE+
	NW5a4Qj29Xf+31AUOnjZFfZvBQ2qjwzaHLWayut2PKu9wtfpu5YTQyOvgerVCqcG58O5Jy
	egm4sGdJLLVNTjrkbm2O4JgyYOtWq6Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of 3jp7-agkbACUTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3jp7-agkbACUTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=appspotmail.com (policy=none)
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-5587351d419so1429400b6e.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:00:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795071630; x=1795676430;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=43dOOzPr4kWGfR+oDKr9fjX9nu8m4LA8+j1vqIMP6kc=;
        b=vXRo2SJLMzNYvLGOfQZCiTJOcvICf23yKt2tIz8tbG2At1jO0+et0zKwiYXS29pL0h
         9OaXikGR4u8m5XRh1iL3p/1PeeC+/ssEtlbinALhbFbPA8RlWpSKyY+V1Px0PN1t45aK
         AY/4pHG0U/k7cdn2JTERr5LMHtA8HHWc8jfTg0RiX6Eh12iKx9bO/SIt+6F9chtd2wvg
         NisQTA5ok10kRUzoAu7ns5qmysvJaz3+xMV7dsrEAHpWC9OFYIChc0aUvtJjssxh/bp+
         U0mJXl8afvY+0qLyWjEPshDNwnalCf95ILD2kv6/GYX7GWBIJb9Ur74fcuryOecevL92
         +BHA==
X-Forwarded-Encrypted: i=1; AL+hErFZ2WJrsf5kJtFEXhCUk0KGifK9u1KQ9H54BarnUwGHVdHgini9UXUk+g8FHXhW4qDatTUkDNxVZg==@kvack.org
X-Gm-Message-State: APuU4Z+rOXbtDtgGHbClee8o0og88JkqHfjlIki8O0lzfK27XgjGJPsa
	CR8+Nvc/7srdZYLVSJU9oUuhGQ9xhWcx+745PgC2HS5zvNgA2Zg1TOPXxGqJQUtcB+o1D9S9ZKt
	IUCb9NrKpGQtX3aJW86jOnPbMWCpmI46U3YUORl6gBEq6VkUW3Uqu0EHS9ZA=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:5088:b0:4a4:744:a4ff with SMTP id
 5614622812f47-5773db24bc2mr5642223b6e.4.1795071630660; Wed, 18 Nov 2026
 23:00:30 -0800 (PST)
Date: Wed, 18 Nov 2026 23:00:30 -0800
In-Reply-To: <20261115075832.132109-1-xu.xin@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6afe9e8e.92f98041.20636d.0002.GAE@google.com>
Subject: [syzbot ci] Re: mm/ksm: clean up scan_get_next_rmap_item() initialization
From: syzbot ci <syzbot+ci7e1f981ab411668d@syzkaller.appspotmail.com>
To: chengming.zhou@linux.dev, david@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, xu.xin@linux.dev
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Stat-Signature: q46qmuetxedho143jbr38hxmi11cpumc
X-Rspamd-Queue-Id: 7C51640007
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795071631-742279
X-HE-Meta: U2FsdGVkX1+A6h1nwAkB8V1ShIjog7/LuuHl84XFpsRsrG0hOKFV0mxf03siS6lsfYXfUPDmGQSo9mXpO34bzLXLzgAlnE9EltYgpyZndo0tVx+vbUa51TTMpsHmaPujsgFLhtCKbQHycHQncZTTZcChwRZATNYs76bHTjc5hFJWFC94GI+HVfb8mCcAXEcy3oG89oOIQYUYgOX/3iyL2+RqgVeJkLWBeXEZhwL4BD119sVL5NKa3OX9QZkQ7NEACRRTPRrG5UYwTDNNz3LP6FdsKpxxdbtM8tQvt7t0RcFgJ88T2Caro8u+De1uGTXg7S31t2OV3+UxMBKLg/brcthfUBDyAl6vmuCSKXhUq2qc/AzJT/GpG+1Ws9IecuT3sDE2osew9z7s2eDi75zoM3EeEt4UgVTMUPyjiXO58wAN3SudH/ghvQx8ukYIn/zY/J+FFNGRa5RpbNOko64hTSKNZBZptvsCbVQcnK9ggNvhCrTZ4NkOlgUbxMOIGspUYNQ6lu7mxtWRqXAjedkCtNM6Bq+EmYO+unEZhWWaBGXTKukwtSFtxEWrDVdpaYqD//0YDOzDck8y0uoWnGKwhFp5cXxwqAH6N0NvMO+wD8XzF9Dztml1fWOx0+6ViTSolfkDSCCPp3rW4bpG7sx+l9MP48potrLNx9UUwP49TBgpj7iBf4iNJlZ184prJukymFNsDFnlNjac42W+EI/DncNsVYDff1K/BehgprLyRnQExvLzAxDVXw/lCG+9UBoTyf1CesHY5f3hmKf+fxRT4ls0JHefnxzqdWZ8W5IlzMPYoXriWozuJaZPoTehGXxFEu9qc3s6e/Lw2ThsIWfyvCgmGSJ+vTcGvSjYJri8a3qeNjd/pFdUlidSoVkyM2VC6DFQoJixS86+0cZP2RlkzXBwLwsZ2Vxl9hPjewvjdsyQ0futUxJrK8zwPNHuoAASJgG4iaeZee4xM3XYyEC
 qMa9SX0I
 jF09XUdq+IpGVTjWS1z4jdRYJAgUKIjf4dXl/vw0o2s60Pkq5uxEdiRP38HIgWKUPFdt9tvJDxNkSvZsPRV52WnR67zsSS8quNLJ/RjPClJGLsrN5oeCwcOo9x1/qBhRUg73MHTol2OMtUdhN9/BfJMAP+zHeZHoThHHRV1ClBr5poelZRvpyMsTbSa6uCq6K39gTJY+h40GmZS9HkK7qDeo6TXEb+l+ll8qhOe6Oq+B/GgPz8qhwAZUPXWvcgCgmkfLyGY9i5PGNzGiwWU71OGKTr41Bl9DEhpd5mR8yW9h/hkWPJvN/OZt2np3OTYRePxeAQpIWK6OjN99xzSV6LhxGLl55RATX617az2SMV+4/9S8HABoT85haUJqpTceZWYPCWibcAafgJbd3kU+tiQ9PH58X0t+JqjtMf1FEHsiNM67jpQDEJ8Dr1a6tmGMT6vUaM0gA2SFaijzA9Gz/DV6FCfioeEDApTgRfIBVMuUqxlfu//1FFTr2olhyDyuQLqY2R0gfQRF2oIXnXqXlqxUNRoZkCt+KNicVwhkIT4nmQwKPhS3LfcgBLPPVSTDhty5VZJUGsO0i5qDOmvliv1ZElA9GvkKwNHNAMdx4bKGLyfRy5w80Hp4H2UicRxYhvJfxrNsLFVBrcoGh/vnXxmAFfSvUIfB0hyIkGnlNA29UqBY//QA1Q82BURHBCmBa4XCblY79yj0mELInxMJZsf3Q28UGjrlCRBqIRaik+FF/TJ5nrIo1Wi7kgdMBibzj+kKm9wWo7mq2n/NQ1ZyYsMgYAKfe28+Oi4wG2x0EttVNg+dKygYLB3K5HBed23cFJs3UwDwClCi+QqRi19amM5BFue1uDAEQ3jjEcXtbi+x4VJr6mxLyzXW68JzjdRtZbCbNVnQXWjS6Esqa2DbmYsTm66jV2VH44cbkVrTcHlzqCZa51/uzNCIno8ix1wouDHFQhV0DJk4Yv3E9teapTRQzsS5g
 zpyzAl+T
 NkHrq35LhVbI5Rr8bU81Z1TJUz5WG3bVBHoFirsFLgh0HYSJpH8xMgZvsM4CoLsL5f1n8sFvnr4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

syzbot ci has tested the following series

[v2] mm/ksm: clean up scan_get_next_rmap_item() initialization
https://lore.kernel.org/all/20261115075832.132109-1-xu.xin@linux.dev
* [PATCH v2 1/2] mm/ksm: extract helper functions for scan cycle cleanup
* [PATCH v2 2/2] mm/ksm: add initialization helpers for scan_get_next_rmap_item()

and found the following issue:
general protection fault in ksm_do_scan

Full report is available here:
https://ci.syzbot.org/series/cc51d824-2b5d-4c6d-bd56-c5bdb2bf5e12

***

general protection fault in ksm_do_scan

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      3dfc09a9493ddaa5e7722a29165d8450b55b4d3f
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/6f9c12e2-f68e-40ee-bbac-84e33b709dfb/config

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 1 UID: 0 PID: 44 Comm: ksmd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:ksm_do_scan+0x5da/0x6f40
Code: c7 05 86 a2 b1 19 00 00 00 00 48 8d 43 28 48 89 05 9b a2 b1 19 48 89 4c 24 40 48 8d 59 20 48 89 d8 48 c1 e8 03 48 89 44 24 78 <42> 80 3c 28 00 74 08 48 89 df e8 47 3a 01 00 48 89 5c 24 30 48 8b
RSP: 0018:ffffc90000b47a60 EFLAGS: 00010202
RAX: 0000000000000004 RBX: 0000000000000020 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000b47c08
RBP: ffffc90000b47cd0 R08: ffffc90000b47c07 R09: 0000000000000000
R10: ffffc90000b47bb0 R11: fffff52000168f81 R12: 1ffff92000168f68
R13: dffffc0000000000 R14: ffffea00046aca00 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8882a77fd000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f15aa3f8c38 CR3: 0000000170aa2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ksm_scan_thread+0x114/0x520
 kthread+0x38b/0x480
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ksm_do_scan+0x5da/0x6f40
Code: c7 05 86 a2 b1 19 00 00 00 00 48 8d 43 28 48 89 05 9b a2 b1 19 48 89 4c 24 40 48 8d 59 20 48 89 d8 48 c1 e8 03 48 89 44 24 78 <42> 80 3c 28 00 74 08 48 89 df e8 47 3a 01 00 48 89 5c 24 30 48 8b
RSP: 0018:ffffc90000b47a60 EFLAGS: 00010202
RAX: 0000000000000004 RBX: 0000000000000020 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000b47c08
RBP: ffffc90000b47cd0 R08: ffffc90000b47c07 R09: 0000000000000000
R10: ffffc90000b47bb0 R11: fffff52000168f81 R12: 1ffff92000168f68
R13: dffffc0000000000 R14: ffffea00046aca00 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88818bdfd000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000110c27b575 CR3: 000000010233e000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

