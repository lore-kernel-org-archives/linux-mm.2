Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8249AC5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73E6D6B008A; Tue, 25 Aug 2026 04:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EEE36B008C; Tue, 25 Aug 2026 04:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DDCF6B0095; Tue, 25 Aug 2026 04:03:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 309BC6B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:03:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 87A9E12038C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:03:52 +0000 (UTC)
X-FDA: 85139053104.06.068858A
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf14.hostedemail.com (Postfix) with ESMTP id C4A93100002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:03:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf14.hostedemail.com: domain of 3ZUyNagkbAI4AGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3ZUyNagkbAI4AGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787645030;
	b=kxTJUg4jMNZmhGNJWoukvxWkNmp1CIFhC3TzIAxzIEmV0mTqPqty2ELkXG5wgUeXA+DzGD
	LjM1JYkGKxBl1ar/glSuA5vEsSNNvKM6plvCKcOfjql2B1dRGDqTzRLqS472ehcHwDqjyj
	6kB3v5Mm6VXJG8Wsgmj+ZJhL99Mj4EY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf14.hostedemail.com: domain of 3ZUyNagkbAI4AGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3ZUyNagkbAI4AGH2s33w9s770v.y66y3wCAw9u65Bw5B.u64@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787645030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=AtGfEt5fG2go9z5Op71wQEx7a+tRBKr+1KtptibDM+E=;
	b=UsLCqm+Hxkmn9M+AD3JHyCOHnlM3K2bbTR6xTYtTcT49yxkE6Oc4yoqlkksChwiLrGr85N
	NwXrbzDv+c4VHz5MKFqfsFOgtBSuTqc+3M8GHbaN2IqNP85rP9TtF79L1eDSesDSlXOLZJ
	FUicMRSCEEuJgvpaOIQBR2T+J2eTKpc=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4ad778bacbeso8856640b6e.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:03:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787645030; x=1788249830;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=AtGfEt5fG2go9z5Op71wQEx7a+tRBKr+1KtptibDM+E=;
        b=ZTfSFoZ7IcLf0e/yERYUSz8f0+orhFLETEqxMk4odTNvUoFfMBcQq9N5/Xf1KoaLUO
         4ZjuY9gz2M3snvTyQJfNnYljBCy1BXz6sL6jsWvm9pFJAE2hwC7mAnAFf3DtRHg62Qip
         xQUMQM8SVC84J1Kv8nfXT2fBz85MvZffUnvm4TrhAkAKCx+zQc9jCAWKlBatwgaumkJl
         huYVPYvP6vM1qIbd4f9Jz7gkO98Yi5fG881gcH6zIiGe90zk2P7PV9yO8ZGyV5GSxkzd
         O5aH0YSy52W4Bm/wwj46qsSHmgHi/r9BqSgfx0UQomeBRZTp9na2HwtLI70ue3HJo61A
         WdCg==
X-Forwarded-Encrypted: i=1; AHgh+RoW8nHWkMnCuSsykSQuKuNi6PtDWvGDae0I1rWeqIBZvvEj90t+1Eiss63jGc4+JjOaksFB8eE7+w==@kvack.org
X-Gm-Message-State: AFuF++lZFUfs8eVGtoarSNvheot/ltvfXhfAA2O6kUwcBsN+pOCTYc8n
	i+ezsRcfIAjTARbJY/zNcZnm17u3v9iKFivE2uxN3fKBIrbXhrFvHLHf4CLdXgqDSeM+mSLT6w5
	lfoB6pJqHDTNWd/YFlCUGU0PzpKjvBxyFhEWBTT6t0lC1MB8YMon8lpeKp5Q=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1c09:b0:496:a36:b5e5 with SMTP id
 5614622812f47-4b35089c71bmr4724901b6e.17.1787645029903; Tue, 25 Aug 2026
 01:03:49 -0700 (PDT)
Date: Tue, 25 Aug 2026 01:03:49 -0700
In-Reply-To: <20260824152932.1583506-1-lrizzo@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8d4c65.a5a502ce.31d34.0049.GAE@google.com>
Subject: [syzbot ci] Re: swiotlb: avoid swiotlb copy on network sockets
From: syzbot ci <syzbot+ci194162eefbbbb459@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, davem@davemloft.net, david@kernel.org, 
	driver-core@lists.linux.dev, dtatulea@nvidia.com, edumazet@google.com, 
	gregkh@linuxfoundation.org, iommu@lists.linux.dev, kuba@kernel.org, 
	kuniyu@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lrizzo@google.com, m.szyprowski@samsung.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, rafael@kernel.org, rizzo.unipi@gmail.com, 
	robin.murphy@arm.com, willemb@google.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C4A93100002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: qduqww1xs9rea9bwe96ztxpdb9dtm6z9
X-HE-Tag: 1787645030-610076
X-HE-Meta: U2FsdGVkX1+VKYqtABQBwCLBFq6MUzqZ8UZvbF+32HaWp5bDHhLCFxPbgzPx15hiKiDzJ1ccdV9eFkySneJ35nLb8cNGjj2wzO/iyhrDNngJ9Aqjuo4O2agBOuE/qBgSoCmyqPREXGuY/IHhETU8jl81y/IwtV4RCTSAvfeFUuYI0pzzL7Plbt2/FPTQCKncIZCOYT22t6DY+P8GX6tnNcTmaJsSe7pYgblPVrWkcIrm3s5GFfdyKzl6oAkTHtws8afUBOXC+Q7fGRs1PXpqJMmsAq9XKKL57B4c22wd+JU3ZKOdy88Tll31Veh4j4mVxoPJXUtW1HF06BBN+9H0q9Y1EguE3kyXBdlcvH1QmbINH03BbyptbmM2B7sjJRPfAGRZrOHgVUHM86LeLN591U0i8hid6pB5Cz0fq0i/Gfqy8S3GKzu8soyDTZRdf8QzcXD1ERtMloWrxR3aexk68SKoYCijOmqLu2O6ou2mUk29Mb6btsQmDzz7TNkwCDq/pUo6cHsdrk3v4ZuVEKxJW35CM689/LxRB/8k7IS6yRCH2m+WmWBvm02JK4IPgcJDVSqEslLj0RwKQsOEWP/6KuagsSDB9S/r2GgXZP+ofZtByNwTXyXAPsL1pu/v6pSqGOyuqg2mCMOSHDgtv05bMNkH28tq2A+vu6QCE2zvJrD99oX951YDxmeZEAVg9UFWa1Ax36WfJhfnQ6kRjLiYXuIxO21uQMNGwdBV69XwWvNbmptpv1bAtJgh1YH9cinAIi8RIU32Q6T8wWFBTVst4N+d0EDOrSf2IG+RTv/5fXI2ETyl3lBamXaQLY3ceO7LPb1CE8qr/n6i4DX9/859tg5Fh6PH2ETAoFLRFdr1DlAnhJ+y+RG++iJ+/zk+gOsPoOh/F2+wJIfQmCJ3HVWRRq1XjylHileHDbVZZzlIhqouMKPogDtz5V5Z1ymEtWB1MLJk7dqCk13xIkVZe1b
 PEBE7lze
 Zh/S1YaI113edy13Sq5Ndy15qJTiJOxX1k4vfoc5UmBLGcQ/G0joa/LqvBHuLX8+Tn+NKoAis5aXKgfNIgD8bDWJHNJ7q8ulENAWg8p4Ii8nuh6jxLqQJYNSrdfFbiYbT4CjejOkoS/vtn8Yz7uKljmcnLJj0ha9m0PHdK/QZ9F/Mv0Ud5W43fm2YyFKj3B6/S70ikHlAExFQkW5+Vz/s7xG/hBaPQSPK+A11JZ6q/lZZrOYXoHSZMbzRneaWmp5agtSLrTDGg04nyKqLcDP/AMz2xygeeJdtLyajcg9F2wuUtuGj1qv/sKVhbYLfOorua55HPYmW32KRqPSQhnIGdM3oY9ig1LqHZmWUei1swvVINk1nH7ewryfI3dMkUhiAeUTY9ccuUNXIFKneI3Q1KcZ3Q6I5LP08VU+ETlemV8hn1wYkQZ83op98H4JnkpY8DBdyeysiGDAFjf2K+4yxgPIZBCsKq7AWzAQo/gNBhm08ORhFTH8O5FM41AF70Gl3+n9zLcIDxpDKtYWxKhgpEAzSN39lKTF+FaKlGQkZZw1MiBqx45fhg/C1JGv5pJZLTi1s+/27Gx7HGMZt+4lmGVGDgjI6+2uSruw1FyCSTgUviG8AqajCdhqwK4mJ0n4yuMwPFNVUGuYem8mtb40xHPwh57X3qCQWCf8jOU5mEMADDXJiBbqMKRiDQmRoPirBEknuY3JvARl9bXy+aIWCEVyHapybM21pfWAATsRhdUQ1xIhmZX+QYr7SkutUnNv+v8fm7snwHsYMCqAycEUSGpE3DtCJJ8iKkw2zM5GdQv/U28cx1FT2MsQxM4zzsDSDZMKZE9LXXqPJeThbuX92wkWP0tvn6NN/o67a6kxjopgoLZwiOqJ94eNiPm0RNubaFtD0sZ+un+/dDkZyO9np7EPVOKBlteuN2BLiFUJJHkhahdvhYs2/hVb6C0wZNtr19+z103ZgD0Houli85fDASANQ83A9
 y82sEj7b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v2] swiotlb: avoid swiotlb copy on network sockets
https://lore.kernel.org/all/20260824152932.1583506-1-lrizzo@google.com
* [PATCH v2 1/5] swiotlb: enforce pool nareas and nslabs invariants
* [PATCH v2 2/5] swiotlb/mm: Implement SWIOTLB nocopy page allocator
* [PATCH v2 3/5] net/swiotlb: Track bounce device per socket
* [PATCH v2 4/5] net: Divert socket allocations to SWIOTLB for nocopy TX
* [PATCH v2 5/5] swiotlb: Implement RX nocopy with fast recycling eviction

and found the following issue:
general protection fault in page_pool_put_unrefed_netmem

Full report is available here:
https://ci.syzbot.org/series/b17756c4-983f-4d7a-8415-3da06c0dda99

***

general protection fault in page_pool_put_unrefed_netmem

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      0a0d1d55dad570724bf8c7ea83409639cfb4be9b
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/20e51ca2-88da-4674-9797-a62c64743095/config
syz repro: https://ci.syzbot.org/findings/4385dd7f-d1fc-4627-ad19-6862c780a90c/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000082: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000410-0x0000000000000417]
CPU: 0 UID: 0 PID: 5836 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:swiotlb_addr_in_default_pool include/linux/swiotlb.h:177 [inline]
RIP: 0010:swiotlb_is_nocopy_addr include/linux/swiotlb.h:184 [inline]
RIP: 0010:__page_pool_put_page net/core/page_pool.c:851 [inline]
RIP: 0010:page_pool_put_unrefed_netmem+0x22a/0xd20 net/core/page_pool.c:930
Code: 5c 63 00 00 89 c5 31 ff 89 c6 e8 61 17 04 f8 85 ed 0f 84 07 08 00 00 e8 54 12 04 f8 49 81 c4 10 04 00 00 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 e7 e8 37 c7 73 f8 4d 8b 24 24 4d 85 e4
RSP: 0018:ffffc900039df230 EFLAGS: 00010206
RAX: 0000000000000082 RBX: 0000000000000000 RCX: ffff888160efda00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffffffff89c3aca5 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8ed5a4e0 R12: 0000000000000410
R13: dffffc0000000000 R14: ffffea0004450300 R15: 0000000004450300
FS:  00007f08f83e86c0(0000) GS:ffff88818d6fc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd455a8fe8 CR3: 00000001134ac000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 page_pool_put_netmem include/net/page_pool/helpers.h:343 [inline]
 page_pool_put_full_netmem include/net/page_pool/helpers.h:373 [inline]
 napi_pp_put_page+0x133/0x1e0 net/core/skbuff.c:1036
 skb_pp_recycle net/core/skbuff.c:1047 [inline]
 skb_free_head net/core/skbuff.c:1091 [inline]
 skb_release_data+0x8c3/0xab0 net/core/skbuff.c:1122
 skb_release_all net/core/skbuff.c:1197 [inline]
 __kfree_skb+0x5d/0x210 net/core/skbuff.c:1211
 llc_rcv+0x77a/0xcb0 net/llc/llc_input.c:-1
 __netif_receive_skb_list_ptype net/core/dev.c:6312 [inline]
 __netif_receive_skb_list_core+0x784/0x830 net/core/dev.c:6354
 __netif_receive_skb_list net/core/dev.c:6406 [inline]
 netif_receive_skb_list_internal+0x995/0xcf0 net/core/dev.c:6497
 netif_receive_skb_list+0x67/0x480 net/core/dev.c:6549
 xdp_recv_frames net/bpf/test_run.c:268 [inline]
 xdp_test_run_batch net/bpf/test_run.c:349 [inline]
 bpf_test_run_xdp_live+0x1875/0x1c20 net/bpf/test_run.c:378
 bpf_prog_test_run_xdp+0x7d8/0x11d0 net/bpf/test_run.c:1463
 bpf_prog_test_run+0x2c5/0x340 kernel/bpf/syscall.c:4804
 __sys_bpf+0xa22/0xd90 kernel/bpf/syscall.c:6385
 __do_sys_bpf kernel/bpf/syscall.c:6486 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6483 [inline]
 __x64_sys_bpf+0xba/0xd0 kernel/bpf/syscall.c:6483
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f08f759e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f08f83e8028 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f08f7825fa0 RCX: 00007f08f759e0d9
RDX: 0000000000000048 RSI: 0000200000000600 RDI: 000000000000000a
RBP: 00007f08f7635024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f08f7826038 R14: 00007f08f7825fa0 R15: 00007fffc4c69778
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:swiotlb_addr_in_default_pool include/linux/swiotlb.h:177 [inline]
RIP: 0010:swiotlb_is_nocopy_addr include/linux/swiotlb.h:184 [inline]
RIP: 0010:__page_pool_put_page net/core/page_pool.c:851 [inline]
RIP: 0010:page_pool_put_unrefed_netmem+0x22a/0xd20 net/core/page_pool.c:930
Code: 5c 63 00 00 89 c5 31 ff 89 c6 e8 61 17 04 f8 85 ed 0f 84 07 08 00 00 e8 54 12 04 f8 49 81 c4 10 04 00 00 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 e7 e8 37 c7 73 f8 4d 8b 24 24 4d 85 e4
RSP: 0018:ffffc900039df230 EFLAGS: 00010206
RAX: 0000000000000082 RBX: 0000000000000000 RCX: ffff888160efda00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffffffff89c3aca5 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8ed5a4e0 R12: 0000000000000410
R13: dffffc0000000000 R14: ffffea0004450300 R15: 0000000004450300
FS:  00007f08f83e86c0(0000) GS:ffff88818d6fc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd455a8fe8 CR3: 00000001134ac000 CR4: 00000000000006f0
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	00 00                	add    %al,(%rax)
   2:	89 c5                	mov    %eax,%ebp
   4:	31 ff                	xor    %edi,%edi
   6:	89 c6                	mov    %eax,%esi
   8:	e8 61 17 04 f8       	call   0xf804176e
   d:	85 ed                	test   %ebp,%ebp
   f:	0f 84 07 08 00 00    	je     0x81c
  15:	e8 54 12 04 f8       	call   0xf804126e
  1a:	49 81 c4 10 04 00 00 	add    $0x410,%r12
  21:	4c 89 e0             	mov    %r12,%rax
  24:	48 c1 e8 03          	shr    $0x3,%rax
* 28:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2d:	74 08                	je     0x37
  2f:	4c 89 e7             	mov    %r12,%rdi
  32:	e8 37 c7 73 f8       	call   0xf873c76e
  37:	4d 8b 24 24          	mov    (%r12),%r12
  3b:	4d 85 e4             	test   %r12,%r12


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

