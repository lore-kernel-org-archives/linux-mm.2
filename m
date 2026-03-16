Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1C7DF506D2
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DD1E6B02A2; Mon, 16 Mar 2026 10:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A8EB6B02A4; Mon, 16 Mar 2026 10:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D51C6B02A5; Mon, 16 Mar 2026 10:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 20B0E6B02A2
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:05:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CDD14140212
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:05:48 +0000 (UTC)
X-FDA: 84552099576.20.0736A63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 01B4640006
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:05:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X8JFInN5;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773669947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kqeMcaklJ0d/sXf7uOGx5lZBPtL/a3aHNwJWVbgHpSo=;
	b=w4oMDeUip8fS0e+WTW9rQp/zcJI2+dbAE32LY7dMAlE5S9HwosGkIRGZe3Sf6uV6jpnOsk
	KzukkNeoLr7BfvpysnW97HZc/WX55OPZiN/HoqmXMHeBCzFU17y05rS5befxjCsDyzO/6N
	Rqi9UNjeMTU4MyL9EE80roREyI3Cjfw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X8JFInN5;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773669947; a=rsa-sha256;
	cv=none;
	b=12gMgOmqDDyreysKrlGYcrJvpscGn6wO3DzJUWlfX8nlU8JFMpBqGgFjutFPbZKUAyFWHH
	LAgfuk+f6ilzkyPPyMfSh5hrSnCiHUTNNhsaDZC9APcK/6PWVRAK7j95n4/OVVPHmXWdC9
	GIGp5euyQ7d4u2LIY2b1Cq224MrD/A4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 11C7041927;
	Mon, 16 Mar 2026 14:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444F4C19425;
	Mon, 16 Mar 2026 14:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773669945;
	bh=tqbyBrcIjU4Pl1SxtzxPJQJzOMpfaXCIFXaqOSBneok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X8JFInN5v0aRUWv8rkZeuTHVlIzeAg/a1RaxxRycGNgAOglWyFWYVgiTzl3TrxHTs
	 fBo95reCGJSM0ecFD+5AlB14TwnNnZC2kkqfd6lSu7AWN/7AKmfsGLbVpm46QhyGUr
	 ZzrS+Beg4NcTH+xr5SX1fUlaXdYqMIHEog8Yr2a19cXCI8Cy3+/0LI+SChm6tqc9Bk
	 ztSvX+jdUKUn7qjWZ5DbHmXsPFYjX/90qzKUPjcR7ywegUmvCl0LBjSnDl7M7tQukg
	 BVg3Oka7wY9N2Jxm4GneXQM26HEQXMiz1rbvYhGWKqUu/YvPl0mF2ElFDELOkuM4wB
	 s7uWNq4tPaPIg==
Date: Mon, 16 Mar 2026 14:05:41 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: syzbot <syzbot+fe426bef95363177631d@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, rppt@kernel.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] kernel BUG in __kmap_local_pfn_prot
Message-ID: <61380f09-f151-4440-bab9-b1129e0ef3cd@lucifer.local>
References: <69b75e2c.050a0220.12d28.015a.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69b75e2c.050a0220.12d28.015a.GAE@google.com>
X-Rspamd-Queue-Id: 01B4640006
X-Rspamd-Server: rspam07
X-Stat-Signature: m5i7cp64ket7ekjz7cjhnhd7hn9cct6b
X-Rspam-User: 
X-HE-Tag: 1773669946-820505
X-HE-Meta: U2FsdGVkX1/rw7jb45I9Um/u3jzQp/m3JpPvncDDDU3ZhrgPb++eGi1qoRhMB28vpRY3F8oKpwcD6B1nCzl9p1yVZX7DG40aA5iWMmlnoOPZsNNU/IIe+w0vgupngr0sRAuvJZxVGiRySgI21llRCgBmbH1l+yqCvjCua3E1nmpMVHxAIdBAE8CNrm0s2jXZOA4QUmZs9E8tWYZn2Q9jubEmwtBWwRIxgjUae+1AdtttkuAo4XrwSF/ZQVj2eVTKVyzIV72K9qeOqkitpIIl8wY1rzE/li4FkKsX+vhAvX3hOzgDcZy8ZHnHBpFhe/QKAb3TEpBj+nfJrwLltTxivi2lmEVA72OKwlPAEYHUC2fcUogaAheoqICrdwBa7bAX03PfcuMLsiWq7Yrx+jXyDuSpyCj3xM0zad/yR4B1xGgJIJPhafb/YlL2pRcsE2gkifbbvLKQuIedpDaaGlMMxK5HpMp2HHPntaqVJSUcy9w91uqCBSzUbtlkmDzuODQtx4ORBukhTzL4oQq2l7iOany84XyRD1jeZUaz+V+fOKD+1bASmxHgLagBcw9WEuxPvtABc/ZzgdvHrodG8t2hlyUl/V8Gk3cmTVlWwDnXWDJHxMSMVLjFUCu4Qu5rSYLypJH6W9sX1yt1o9pF1sOn4/uWcJRHAkqIBkB4Vhy8ejv5Q1llCn+v/xtab9DmlJjyQZHFO/zRzuDeCeHTEfaIzFfRVCPTnqYKsGcZUVN7AUV2754/eh8AakQ9/si7bylPlDfCWQBmN+pAIx0eDnTm0Hd6Hapr8fRxUpIn7GqeXuzNucFVeViTsBxwtToDQbgu15MC42YFc3Xbux8vqaiYNpUsutHN0TUWxYCg+AYWjumBpnX/gQ4jku/Th8ALWUA6v8Bbw8yUkHQ9Ea3mgPSf+3Me+b21JNkA8LRK4DkCm9k/zEAhkIqsurYqDYckYvfJR4Fhw/OleEZAAi+eXJI
 /JA2SUYL
 fonClD4lxBLPEshblzFyJm9/eJ3Sv3dFoH5kazVufsNFdK0JMz8fLGN3ky2kTtcvm7jEG5Bsjud2+4BKdy3y9balZP9mc1dBdscy3n+u4/N/pAm0WzPn4tAIag+cPNl6E/7Gf4s8N+qbv8jwbcJ87aoni4x0qAsEsT0nNd0/N+WS1v4mRZhXbufCvp0xJsFueU/yrUDQzXhwRlDOU3M+vfa/KU/DTsoQlfO7y8RPgzHS+DQ6ASzE2QeY4xZ4ivXGemLJwIwByZxXOU8LjoJDPIu2lRBCgVDcFf0L8rNuWdXvQgmauqcMJFPjkCAzvv3RBpxVGP9S1Fmo2/lrynUcEvi+f8EhtK2AFj0zu9KKuvu5D4tFpfIM5Un8Hz4pNEL/11gVSPk7K87B9KPitqhYIqcWZJBSjeHSlYCs3Dq1eRWekpJUSW0pdbaB0KjTOAv7Q5B53UdCSl3XhlCg7oAr1pCxM5hJG2YCCttd8kYEURFVvvbbCR0s9y5GzL2EDbNNWMoBjQ+l06gHdc+r7uTuJeyJlyKk74G5a0K2g60g3K4JOxRdFVZ5CbDn0hHDlCjwx61msAg8jhEPoteifam2fph3Ti9+sV3vS1wMF8stCk6k+6RlouygKQpn6uzL6qsPJJsPBlabuE5eZWZiF5l5mXo5DjvwIaXhe4jj1f5p53YmK3QYCulLYoLGVvWTWgXCsRw+qSWqoO/UEcFiAgc+sMCz6SwS3YaDiLVLyXHlSDzhUfWLNU5kJp8K1YHQsmH1HxC8IqJqj9XXIsuq6uUyGZikkcjnQLh/YT2lk4nB+ZVRPCdUTKntZO104oMA3BjxidOSKOAcCsVdkd4WR96PYiTzFtvBVf3wNi9iAbnmoHLzuALOQnQnOty/kqsp+vZvMiGGhRQt7x7NlV+FlHZYilsnnf8QWOI0fRq9qM0ufCKaFYDJgRL5oZtfkqPmKYmrw0wAIPDNK4oLSc8qCUTgog0URsNf2
 rlNYewsv
 QsUS12A8KGaR269Ztbvd70BiM1eJUlIZ6qLzSWGWeybJtuh6Rtea2OIuj5Hi9gijhJFbsio7XnujCQpV3HAMX3qz9GnhFy9cZBIOkx+QsNdevnpBF2fYvIgrQjQtFiWfDApv+82Hrpmtpx/OrMfevnMyJ3cLT7J3BljVrqLEjaky2OK7MvsFC7BwAT4DeJkuFhDAqshNYfc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL;DR: fixed it :)

On Sun, Mar 15, 2026 at 06:34:36PM -0700, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    b29fb8829bff Merge tag 'v7.0-rc3-ksmbd-server-fixes' of gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11709806580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6eb60188ef90336d
> dashboard link: https://syzkaller.appspot.com/bug?extid=fe426bef95363177631d
> compiler:       arm-linux-gnueabi-gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> userspace arch: arm
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/98a89b9f34e4/non_bootable_disk-b29fb882.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/03c37f3b0853/vmlinux-b29fb882.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/58abf25b8259/zImage-b29fb882.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+fe426bef95363177631d@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> kernel BUG at mm/highmem.c:480!

This is

	BUG_ON(current->kmap_ctrl.idx >= KM_MAX_IDX);

Which strongly suggests that we are leaking a kmap.

> Internal error: Oops - BUG: 0 [#1] SMP ARM
> Modules linked in:
> CPU: 1 UID: 0 PID: 12237 Comm: syz.3.10715 Tainted: G             L      syzkaller #0 PREEMPT
> Tainted: [L]=SOFTLOCKUP
> Hardware name: ARM-Versatile Express
> PC is at kmap_local_idx_push mm/highmem.c:480 [inline]
> PC is at __kmap_local_pfn_prot+0x230/0x24c mm/highmem.c:562
> LR is at get_lock_parent_ip include/linux/ftrace.h:1168 [inline]
> LR is at preempt_latency_start kernel/sched/core.c:5744 [inline]
> LR is at preempt_count_add+0x114/0x150 kernel/sched/core.c:5769
> pc : [<804d94c4>]    lr : [<8028d87c>]    psr: 20000113
> sp : eca19900  ip : eca198d8  fp : eca19934
> r10: 00000000  r9 : 00000024  r8 : 000e1380
> r7 : 0000071f  r6 : 00c00000  r5 : 83ff9800  r4 : 00000020
> r3 : 00000022  r2 : 0000071f  r1 : 00000011  r0 : 00000000
> Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> Control: 30c5387d  Table: 8688cec0  DAC: 00000000
> Register r0 information: NULL pointer
> Register r1 information: non-paged memory
> Register r2 information: non-paged memory
> Register r3 information: non-paged memory
> Register r4 information: non-paged memory
> Register r5 information: slab task_struct start 83ff9800 pointer offset 0 size 3072
> Register r6 information: non-paged memory
> Register r7 information: non-paged memory
> Register r8 information: non-paged memory
> Register r9 information: non-paged memory
> Register r10 information: NULL pointer
> Register r11 information: 2-page vmalloc region starting at 0xeca18000 allocated at kernel_clone+0xac/0x428 kernel/fork.c:2654
> Register r12 information: 2-page vmalloc region starting at 0xeca18000 allocated at kernel_clone+0xac/0x428 kernel/fork.c:2654
> Process syz.3.10715 (pid: 12237, stack limit = 0xeca18000)
> Stack: (0xeca19900 to 0xeca1a000)
> 9900: 00000000 00000000 8050a67c 72c571c0 00000881 00001000 eca19978 00001000
> 9920: ffebe000 82a80518 eca19944 eca19938 804d9550 804d92a0 eca19974 eca19948
> 9940: 80818b4c 804d94ec 00000000 00000000 00000000 deddc6a8 8337ec00 eca199a0
> 9960: ff7f5e74 0000002d eca1999c eca19978 80818c90 80818b14 00000000 eca199c0
> 9980: 00000000 72c571c0 ff7f5e54 865a7ea0 eca19a1c eca199a0 80537bf8 80818c04
> 99a0: eca199bc eca199b0 00000000 00000000 00000000 00000000 00000000 00000000
> 99c0: deb9c9c2 00000000 00001000 00000000 00000000 00000000 00000000 00000000
> 99e0: 00000000 00000000 00000000 00000000 002d0000 72c571c0 deddc6a8 00000001
> 9a00: 865a7ea0 0000002d 85795f00 00000001 eca19a44 eca19a20 80539cdc 80537b30
> 9a20: deddc6a8 82ad6c20 00000000 85528900 00000001 00000001 eca19a94 eca19a48
> 9a40: 8052cc48 80539c54 0000002d 00100cca 83ff9800 eca19ab4 00000000 00000000
> 9a60: 00000000 72c571c0 8052ed9c 0000002d 00100cca 00000000 00000000 0000002f
> 9a80: eca19ab3 00000000 eca19b14 eca19a98 8052f18c 8052c958 eca19ab3 85420288
> 9aa0: 83ffa688 deddc6a8 00000028 00000028 01a19ae4 00000000 00000000 00000000
> 9ac0: 00000000 00000000 00000000 00000000 00000001 00000000 eca19ad8 eca19ad8
> 9ae0: 00000000 72c571c0 eca19b3c 00000001 00000000 00000028 00100cca 00000000
> 9b00: 84ce1400 eca19c30 eca19b9c eca19b18 8052f384 8052efc4 8022bc40 8022aba8
> 9b20: 00000000 804e0f7c eca19c0c eca19ba0 8028d88c 804e0f7c 00000000 00000000
> 9b40: 824ad034 72c571c0 eca19b7c eca19b58 ffec8000 83ff9800 00000028 85528900
> 9b60: eca19b9c eca19b70 8052d220 72c571c0 00000028 eca19c30 00000000 00000028
> 9b80: 00000000 00000000 84ce1400 85528900 eca19c0c eca19ba0 804e1294 8052f328
> 9ba0: eca19c28 87979800 eca19bc4 eca19bb8 804d9550 804d92a0 eca19bec eca19bc8
> 9bc0: 804f3820 804d94ec eca19c28 87979800 2000d000 eca19d28 00000000 eca19c30
> 9be0: eca19c0c 00000214 83ff9800 2000d000 eca19d28 00000000 00000000 00000000
> 9c00: eca19ca4 eca19c10 804e2bc4 804e0f64 eca19c64 00000000 eca19c4c 72c571c0
> 9c20: eca19c30 8575ad00 df871003 00000000 84ce1400 00000cc0 0002000d 2000d000
> 9c40: 2000d000 00000a14 87979800 8688cec0 00002880 00000000 00000000 00000000
> 9c60: 00000000 deb5fbb8 00000000 00000000 826c36c0 72c571c0 eca19d0c eca19d28
> 9c80: 2000d000 00000207 2000d000 00000214 8575ad00 00000007 eca19cec eca19ca8
> 9ca0: 80232fcc 804e2718 00000001 00000000 8280c82c 83ff9800 00000000 83ff9800
> 9cc0: 81c01eb4 8281d3d0 00000207 2000d000 eca19d28 80232edc 83ff9800 84df3318
> 9ce0: eca19d24 eca19cf0 8023357c 80232ee8 eca19d5c 80200c04 83ff9800 84df3318
> 9d00: eca19d24 81ab4034 80000013 ffffffff eca19d5c fffff000 eca19da4 eca19d28
> 9d20: 80200b2c 80233550 2000d000 7effffff a100d000 000006c0 2000d000 2000d000
> 9d40: b5003500 b5403587 fffff000 2000d6c0 84df3318 eca19da4 eca19da8 eca19d78
> 9d60: 804d0850 81ab4034 80000013 ffffffff eca19d94 b5003500 8047cd9c 0047ca50
> 9d80: 000006c0 00000000 00000000 000006c0 000006c0 81c1ee80 eca19dc4 eca19da8
> 9da0: 808f215c 804d07dc 00000000 00000000 0000c940 000006c0 eca19e2c eca19dc8
> 9dc0: 8047db10 808f211c 000006c0 00000000 debb5aac 00000000 eca19e1c 83ff9800
> 9de0: 00000000 0000c940 eca19ed8 eca19e60 2a7a3214 debb5aac 00000000 72c571c0
> 9e00: eca19e60 00000000 eca19e60 84df3290 eca19ed8 875806c0 00000001 00000006
> 9e20: eca19e54 eca19e30 804abc20 8047d87c 00002004 875806c0 00000000 eca19f88
> 9e40: 83ff9800 00000001 eca19ebc eca19e58 80572c54 804abbb0 00000006 eca19ed8
> 9e60: 875806c0 00000000 00000000 00000000 00000000 00000000 00000006 00002004
> 9e80: 00000000 00000000 eca19ebc 72c571c0 8028d87c 804abba4 00000000 875806c0
> 9ea0: eca19f88 83ff9800 00000001 0000016a eca19f5c eca19ec0 805743d0 80572b30
> 9ec0: 00000000 eca19ed8 00000000 00000000 00000000 00000000 00010000 0000c940
> 9ee0: 200006c0 000e4635 00000001 00000000 81af13d4 200006c0 000f0f75 00000000
> 9f00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> 9f20: 00000000 00000000 00000000 00000000 00000000 72c571c0 875806c1 875806c0
> 9f40: 00000001 20000080 8020029c 83ff9800 eca19f84 eca19f60 80574834 805742a8
> 9f60: 00000000 0013e480 00000000 00000000 003464f8 0000016a eca19fa4 eca19f88
> 9f80: 805760c4 805747b0 00000000 00000000 00000000 83ff9800 00000000 eca19fa8
> 9fa0: 80200060 805760b0 00000000 00000000 00000006 20000080 00000001 00000000
> 9fc0: 00000000 00000000 003464f8 0000016a 003464b8 00000000 00000001 76ec30dc
> 9fe0: 76ec2e88 76ec2e78 00018ba0 001302e0 60000010 00000006 00000000 00000000
> Call trace:
> [<804d9294>] (__kmap_local_pfn_prot) from [<804d9550>] (__kmap_local_page_prot mm/highmem.c:593 [inline])
> [<804d9294>] (__kmap_local_pfn_prot) from [<804d9550>] (__kmap_local_page_prot+0x70/0x74 mm/highmem.c:576)
>  r8:82a80518 r7:ffebe000 r6:00001000 r5:eca19978 r4:00001000
> [<804d94e0>] (__kmap_local_page_prot) from [<80818b4c>] (kmap_local_page include/linux/highmem-internal.h:73 [inline])
> [<804d94e0>] (__kmap_local_page_prot) from [<80818b4c>] (scatterwalk_map include/crypto/scatterwalk.h:111 [inline])
> [<804d94e0>] (__kmap_local_page_prot) from [<80818b4c>] (scatterwalk_next include/crypto/scatterwalk.h:146 [inline])
> [<804d94e0>] (__kmap_local_page_prot) from [<80818b4c>] (memcpy_from_scatterwalk+0x44/0xf0 crypto/scatterwalk.c:39)
> [<80818b08>] (memcpy_from_scatterwalk) from [<80818c90>] (memcpy_from_sglist+0x98/0xbc crypto/scatterwalk.c:72)
>  r10:0000002d r9:ff7f5e74 r8:eca199a0 r7:8337ec00 r6:deddc6a8 r5:00000000
>  r4:00000000 r3:00000000
> [<80818bf8>] (memcpy_from_sglist) from [<80537bf8>] (zswap_decompress+0xd4/0x28c mm/zswap.c:946)

		memcpy_from_sglist(kmap_local_folio(folio, 0), input, 0, PAGE_SIZE);

Note the kmap_local_folio() that never has a kunmap_local_folio() done to it...

Looks to be commit e2c3b6b21c77.

So a fix would be to add a kunmap_local_folio() here.

Have sent a patch, which should be at
https://lore.kernel.org/all/20260316140122.339697-1-ljs@kernel.org/ but lore
just decided to break so you can also see it at
https://marc.info/?l=linux-mm&m=177367239109552&w=2

>  r5:865a7ea0 r4:ff7f5e54
> [<80537b24>] (zswap_decompress) from [<80539cdc>] (zswap_load+0x94/0x1dc mm/zswap.c:1615)
>  r9:00000001 r8:85795f00 r7:0000002d r6:865a7ea0 r5:00000001 r4:deddc6a8
> [<80539c48>] (zswap_load) from [<8052cc48>] (swap_read_folio+0x2fc/0x794 mm/page_io.c:637)
>  r9:00000001 r8:00000001 r7:85528900 r6:00000000 r5:82ad6c20 r4:deddc6a8
> [<8052c94c>] (swap_read_folio) from [<8052f18c>] (swap_cluster_readahead+0x1d4/0x364 mm/swap_state.c:755)
>  r10:00000000 r9:eca19ab3 r8:0000002f r7:00000000 r6:00000000 r5:00100cca
>  r4:0000002d
> [<8052efb8>] (swap_cluster_readahead) from [<8052f384>] (swapin_readahead+0x68/0x514 mm/swap_state.c:924)
>  r10:eca19c30 r9:84ce1400 r8:00000000 r7:00100cca r6:00000028 r5:00000000
>  r4:00000001
> [<8052f31c>] (swapin_readahead) from [<804e1294>] (do_swap_page+0x33c/0x1494 mm/memory.c:4802)
>  r10:85528900 r9:84ce1400 r8:00000000 r7:00000000 r6:00000028 r5:00000000
>  r4:eca19c30
> [<804e0f58>] (do_swap_page) from [<804e2bc4>] (handle_pte_fault mm/memory.c:6320 [inline])
> [<804e0f58>] (do_swap_page) from [<804e2bc4>] (__handle_mm_fault mm/memory.c:6455 [inline])
> [<804e0f58>] (do_swap_page) from [<804e2bc4>] (handle_mm_fault+0x4b8/0x6b8 mm/memory.c:6624)
>  r10:00000000 r9:00000000 r8:00000000 r7:eca19d28 r6:2000d000 r5:83ff9800
>  r4:00000214
> [<804e270c>] (handle_mm_fault) from [<80232fcc>] (do_page_fault+0xf0/0x4d0 arch/arm/mm/fault.c:402)
>  r10:00000007 r9:8575ad00 r8:00000214 r7:2000d000 r6:00000207 r5:2000d000
>  r4:eca19d28
> [<80232edc>] (do_page_fault) from [<8023357c>] (do_DataAbort+0x38/0xac arch/arm/mm/fault.c:645)
>  r10:84df3318 r9:83ff9800 r8:80232edc r7:eca19d28 r6:2000d000 r5:00000207
>  r4:8281d3d0
> [<80233544>] (do_DataAbort) from [<80200b2c>] (__dabt_svc+0x4c/0x80 arch/arm/kernel/entry-armv.S:219)
> Exception stack(0xeca19d28 to 0xeca19d70)
> 9d20:                   2000d000 7effffff a100d000 000006c0 2000d000 2000d000
> 9d40: b5003500 b5403587 fffff000 2000d6c0 84df3318 eca19da4 eca19da8 eca19d78
> 9d60: 804d0850 81ab4034 80000013 ffffffff
>  r8:fffff000 r7:eca19d5c r6:ffffffff r5:80000013 r4:81ab4034
> [<804d07d0>] (fault_in_readable) from [<808f215c>] (fault_in_iov_iter_readable+0x4c/0xd0 lib/iov_iter.c:106)
>  r9:81c1ee80 r8:000006c0 r7:000006c0 r6:00000000 r5:00000000 r4:000006c0
> [<808f2110>] (fault_in_iov_iter_readable) from [<8047db10>] (generic_perform_write+0x2a0/0x2c0 mm/filemap.c:4368)
>  r7:000006c0 r6:0000c940 r5:00000000 r4:00000000
> [<8047d870>] (generic_perform_write) from [<804abc20>] (shmem_file_write_iter+0x7c/0x84 mm/shmem.c:3502)
>  r10:00000006 r9:00000001 r8:875806c0 r7:eca19ed8 r6:84df3290 r5:eca19e60
>  r4:00000000
> [<804abba4>] (shmem_file_write_iter) from [<80572c54>] (do_iter_readv_writev+0x130/0x220 fs/read_write.c:829)
>  r9:00000001 r8:83ff9800 r7:eca19f88 r6:00000000 r5:875806c0 r4:00002004
> [<80572b24>] (do_iter_readv_writev) from [<805743d0>] (vfs_writev+0x134/0x3c0 fs/read_write.c:1059)
>  r10:0000016a r9:00000001 r8:83ff9800 r7:eca19f88 r6:875806c0 r5:00000000
>  r4:804abba4
> [<8057429c>] (vfs_writev) from [<80574834>] (do_pwritev+0x90/0xf0 fs/read_write.c:1155)
>  r9:83ff9800 r8:8020029c r7:20000080 r6:00000001 r5:875806c0 r4:875806c1
> [<805747a4>] (do_pwritev) from [<805760c4>] (__do_sys_pwritev fs/read_write.c:1201 [inline])
> [<805747a4>] (do_pwritev) from [<805760c4>] (sys_pwritev+0x20/0x28 fs/read_write.c:1196)
>  r7:0000016a r6:003464f8 r5:00000000 r4:00000000
> [<805760a4>] (sys_pwritev) from [<80200060>] (ret_fast_syscall+0x0/0x1c arch/arm/mm/proc-v7.S:67)
> Exception stack(0xeca19fa8 to 0xeca19ff0)
> 9fa0:                   00000000 00000000 00000006 20000080 00000001 00000000
> 9fc0: 00000000 00000000 003464f8 0000016a 003464b8 00000000 00000001 76ec30dc
> 9fe0: 76ec2e88 76ec2e78 00018ba0 001302e0
> Code: e5cce005 ebf5de07 e19510b4 eaffff81 (e7f001f2)
> ---[ end trace 0000000000000000 ]---
> ----------------
> Code disassembly (best guess):
>    0:	e5cce005 	strb	lr, [ip, #5]
>    4:	ebf5de07 	bl	0xffd77828
>    8:	e19510b4 	ldrh	r1, [r5, r4]
>    c:	eaffff81 	b	0xfffffe18
> * 10:	e7f001f2 	udf	#18 <-- trapping instruction
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup

