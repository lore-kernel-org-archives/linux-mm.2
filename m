Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1693BF506D2
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A54A6B02A6; Mon, 16 Mar 2026 10:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646516B02A8; Mon, 16 Mar 2026 10:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57C3B6B02A9; Mon, 16 Mar 2026 10:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 474FB6B02A6
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:07:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B9B7B734D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:07:21 +0000 (UTC)
X-FDA: 84552103482.14.4CEF1A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3D11C40010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:07:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CfStdxdL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773670039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jwcAooz0ag51T4kAHl8PahI6wRlQgzZgCY3QNvWhWXg=;
	b=iaJLmecJ9PxgfIyYgXJBJhUQ+NCs8rErhqVTTKajn6zfuwp8E3P/3na1i7ZT6TzoF8RoFp
	5IG3hpQCw6crZetzPAVa1XpJiLSZf+BmzBsUL06i6NHVTVIpC4y2zunrOyDkjFjMDF8MR2
	W6uDdW3o6sUBkPerviZ4g/7BLRJPwvw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CfStdxdL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773670039; a=rsa-sha256;
	cv=none;
	b=vIjVMLTts4Kn11eeN5asJ3W/8TGLZB+nWQBIQsmCv/5JTG05dGwYen5o80DZVqMYK1cF1f
	RVHu0C5T11d+WyB8stx95SyyxghaR3CmuEf47uL+YHPQOZyYr80GfeJmo9RsOIcx6V5idT
	741QSwGNb/LTHGNDufYEynFwTTcMaxA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0144940BE5;
	Mon, 16 Mar 2026 14:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C3BC2BCB0;
	Mon, 16 Mar 2026 14:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773670037;
	bh=W6h9b1n/Az4UpbvTnwPydHebOfLKFomQSqVZiewKgKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CfStdxdL1BIZPOyF3hjQ0VVAAdKIPYU7MVUO9uisomji2Sg9gMkC+00YX9/9+cJFA
	 W+R2oDt/y5mtp70bZEwnRsnH0BYjGAkDs2cXchR21hLHJYG8JOPHVrHThQstMz7dpU
	 b0EIcIRV9NyEJzynfjRlo6MM8Suzb0qbjGnztVCNQlmLrfHaPUg1ciwMBKucjz+ii+
	 eNOOc3kTu+3i5a8fJUDFA7zE2e3stiudZUheLPRD4gmrcDDGR+kyGOdQtIL3FJplxY
	 bLTIx4SAJzZPcHY5Yw+JZylgqefZa7VC1XwxzIOgMsOXXEnAWJOW3Lv5Cwd9NuCiV+
	 1WU8K0cXP47Og==
Date: Mon, 16 Mar 2026 14:07:13 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: syzbot <syzbot+fe426bef95363177631d@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, rppt@kernel.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Subject: Re: [syzbot] [mm?] kernel BUG in __kmap_local_pfn_prot
Message-ID: <94ea3644-4bd8-4ec9-aeb2-f6791fb3d4b8@lucifer.local>
References: <69b75e2c.050a0220.12d28.015a.GAE@google.com>
 <61380f09-f151-4440-bab9-b1129e0ef3cd@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61380f09-f151-4440-bab9-b1129e0ef3cd@lucifer.local>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3D11C40010
X-Stat-Signature: mcu38jqmqsy4zhqp6zuof1t536we7qz1
X-Rspam-User: 
X-HE-Tag: 1773670039-341453
X-HE-Meta: U2FsdGVkX1/nKsV7SB4OP0Gj77ObgHKiG+N8ZWTxU6/cyWbMxOyXwqf/jZo7/GPRlgBtLE2gdDZ1VRZgxR/ydRISR4VOfVO0wjQ6BJl/ifDo++LqF4SzPbb1HGfL9CXM4D/KdySQYUipqkRh69/vkYa5E8V/UPiSMNhkWXHgRUm1alDkiHImtdIKndfIiDB+gO6CSlmyiiApuT5jaqLng1faGDi7vT8FmEEz4UZM3zTj4W0uywE4V+dP0IIZqqO2nETG2AUL2V7KkDdl4WNTLwAQe/shBVC1666WyJjtCFa8oqbMUW+ntYkYz7FbFTQzR8zWx5ltGMoNIFxkO+UyOhKnKmB1a7kEJRofUYr/n8UesAtnE+06oHxLv4+Gl9z2dknsrwkhDAyrOs5dRnY6iChw0YqTUTx7L8wlZ3Vf3xT2bEPlMBJdiGiTcBLKgGLnAaHst+Uc8InBkxNmbLZtgy+PdDg0FVlAslBVmwRk2ahBx+JVdMVCtOIDm4p1eQlNl2YNNNfra9SWxVs2QELhCn05dV62ia7GQM4gXUvaElTTy71zQU7fOzlVgP2nFY/XwqmVOgt+oOU0yXyfA+x85vURnGprVaUJ65JOT635Hgd/KMHTTG7uXQp/b9hmttfEUNobTi95kba4ObVwfMzMiu620EYCsM/gR0KJ05POx58jTaMsuRnkkAbL3SXINTAz82NkPhM/id8FOtws3X5F1GBpQorCsAnUvYZ98OV3YoXHpej/0mjBmFFU3o9hUc4UXRytjpruEZCajuMTve2+DD23Q4cxlOVG0/LGkyT0p4EADfeN8+In/ugyPOHnVhQJrVrmdquixb6kSBCyI00DTz2ofTcWLXcroYr9yuORxHhUoJdjXUDjU9NfXPd3z+Yecqum7jaIsd5WUR8zE+YITtiRqs9E6Sjw2yrXaGm2I2UeVPb73+AJnVxTDQPC8aAGMfGLnY8ufFl4ZUXEkXE
 pyOhvyFJ
 T09IN9QJRI/sqQ3oqhcIJR9UzlogxCC9wz0r16cc4X8ttkJ+nm3v3wMVtRjyRBK1IX5cC2cehN54VP5bkWPhPvalrbkl9188nB0mwDZQ8TfYbre3VOj3be5Bd71o4hqqKRjRTH9FrV2dzR/3cCoX7WNckRLQjlr5Bs/tns19nsqMFnob5dfPHmnMcgcbEHYbxRjKvTcBzBRV5hCjI4JNjrXQ57VLT3okg77tXAlJlm7eVLtaMsNK+20ECg5tIKSUUrpZmi1mPj9Ytj0wM/l2ckQ1n56HBDDe1Ipw4bBg4K/6cAVML6H4p4+ssoeSCgiNSFYFTvda+Cni89jGhRLhTRi4NcyNcaHTnLZUFBixldikxyUbAWmC6EWrajuheow5pnktcAENTTW3cDZrFyxxR9CNcK6Y28Y/pR/3eS9bCe1z+kH8ikZEDsv9iwlk8bOl02FwIfy4iC4L/cnXhFO4JKY3c3Xv6chptHhsKkW8aoCJLchef/vq5j7nP3mM2Dop0byrxDoOFx2c6c0CcfkDgH9XwNeT+BlNqlW7StcJtdNHEjtyvYCshSgigW0LNjmVL7XCkkB5w9dlQIJHlWrx2uzn6fu059hvnt82XEEcq5gJdHJLH88nIWRTVev/lXIjkuGAlo/oHpyKCk8RNWqeVHpskXiDOgI0mYwHcDNJ0y/jWhYj/WorwSyQmvUrtpY3vzqXr4+x75IbejTYIFuNPG/5Y2GqWIwgrjsKGC0LKzucTOdn+/PAQF3yylMcyGaRuV9TUtlIk0Ll8x26rMlFxIPwYuQ/ZKjXDb23TuUUQeF21/CqhHGSxe/ls1E0xdUadv/CzCixTEQUB53+F29SktWfyQaEICpsWDLpaH8D4pb+Tmpz0dlmm7KQKsC9BsKJysVExs3MWYzdE+a8WsoeApa6CefyNd3SqjQqx140wJfDqhJsuSgCrNSUfgoEB5TIxCcW55UGlYHrN7FF+/z38nn1wHSGr
 kE3sLrOb
 F5PP9VN80cp9k0PDmMdNYbYIwZ2XYywR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 02:05:46PM +0000, Lorenzo Stoakes (Oracle) wrote:
> TL;DR: fixed it :)
>
> On Sun, Mar 15, 2026 at 06:34:36PM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    b29fb8829bff Merge tag 'v7.0-rc3-ksmbd-server-fixes' of gi..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11709806580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=6eb60188ef90336d
> > dashboard link: https://syzkaller.appspot.com/bug?extid=fe426bef95363177631d
> > compiler:       arm-linux-gnueabi-gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> > userspace arch: arm
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/98a89b9f34e4/non_bootable_disk-b29fb882.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/03c37f3b0853/vmlinux-b29fb882.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/58abf25b8259/zImage-b29fb882.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+fe426bef95363177631d@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > kernel BUG at mm/highmem.c:480!
>
> This is
>
> 	BUG_ON(current->kmap_ctrl.idx >= KM_MAX_IDX);
>
> Which strongly suggests that we are leaking a kmap.
>
> > Internal error: Oops - BUG: 0 [#1] SMP ARM
> > Modules linked in:
> > CPU: 1 UID: 0 PID: 12237 Comm: syz.3.10715 Tainted: G             L      syzkaller #0 PREEMPT
> > Tainted: [L]=SOFTLOCKUP
> > Hardware name: ARM-Versatile Express
> > PC is at kmap_local_idx_push mm/highmem.c:480 [inline]
> > PC is at __kmap_local_pfn_prot+0x230/0x24c mm/highmem.c:562
> > LR is at get_lock_parent_ip include/linux/ftrace.h:1168 [inline]
> > LR is at preempt_latency_start kernel/sched/core.c:5744 [inline]
> > LR is at preempt_count_add+0x114/0x150 kernel/sched/core.c:5769
> > pc : [<804d94c4>]    lr : [<8028d87c>]    psr: 20000113
> > sp : eca19900  ip : eca198d8  fp : eca19934
> > r10: 00000000  r9 : 00000024  r8 : 000e1380
> > r7 : 0000071f  r6 : 00c00000  r5 : 83ff9800  r4 : 00000020
> > r3 : 00000022  r2 : 0000071f  r1 : 00000011  r0 : 00000000
> > Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> > Control: 30c5387d  Table: 8688cec0  DAC: 00000000
> > Register r0 information: NULL pointer
> > Register r1 information: non-paged memory
> > Register r2 information: non-paged memory
> > Register r3 information: non-paged memory
> > Register r4 information: non-paged memory
> > Register r5 information: slab task_struct start 83ff9800 pointer offset 0 size 3072
> > Register r6 information: non-paged memory
> > Register r7 information: non-paged memory
> > Register r8 information: non-paged memory
> > Register r9 information: non-paged memory
> > Register r10 information: NULL pointer
> > Register r11 information: 2-page vmalloc region starting at 0xeca18000 allocated at kernel_clone+0xac/0x428 kernel/fork.c:2654
> > Register r12 information: 2-page vmalloc region starting at 0xeca18000 allocated at kernel_clone+0xac/0x428 kernel/fork.c:2654
> > Process syz.3.10715 (pid: 12237, stack limit = 0xeca18000)
> > Stack: (0xeca19900 to 0xeca1a000)
> > 9900: 00000000 00000000 8050a67c 72c571c0 00000881 00001000 eca19978 00001000
> > 9920: ffebe000 82a80518 eca19944 eca19938 804d9550 804d92a0 eca19974 eca19948
> > 9940: 80818b4c 804d94ec 00000000 00000000 00000000 deddc6a8 8337ec00 eca199a0
> > 9960: ff7f5e74 0000002d eca1999c eca19978 80818c90 80818b14 00000000 eca199c0
> > 9980: 00000000 72c571c0 ff7f5e54 865a7ea0 eca19a1c eca199a0 80537bf8 80818c04
> > 99a0: eca199bc eca199b0 00000000 00000000 00000000 00000000 00000000 00000000
> > 99c0: deb9c9c2 00000000 00001000 00000000 00000000 00000000 00000000 00000000
> > 99e0: 00000000 00000000 00000000 00000000 002d0000 72c571c0 deddc6a8 00000001
> > 9a00: 865a7ea0 0000002d 85795f00 00000001 eca19a44 eca19a20 80539cdc 80537b30
> > 9a20: deddc6a8 82ad6c20 00000000 85528900 00000001 00000001 eca19a94 eca19a48
> > 9a40: 8052cc48 80539c54 0000002d 00100cca 83ff9800 eca19ab4 00000000 00000000
> > 9a60: 00000000 72c571c0 8052ed9c 0000002d 00100cca 00000000 00000000 0000002f
> > 9a80: eca19ab3 00000000 eca19b14 eca19a98 8052f18c 8052c958 eca19ab3 85420288
> > 9aa0: 83ffa688 deddc6a8 00000028 00000028 01a19ae4 00000000 00000000 00000000
> > 9ac0: 00000000 00000000 00000000 00000000 00000001 00000000 eca19ad8 eca19ad8
> > 9ae0: 00000000 72c571c0 eca19b3c 00000001 00000000 00000028 00100cca 00000000
> > 9b00: 84ce1400 eca19c30 eca19b9c eca19b18 8052f384 8052efc4 8022bc40 8022aba8
> > 9b20: 00000000 804e0f7c eca19c0c eca19ba0 8028d88c 804e0f7c 00000000 00000000
> > 9b40: 824ad034 72c571c0 eca19b7c eca19b58 ffec8000 83ff9800 00000028 85528900
> > 9b60: eca19b9c eca19b70 8052d220 72c571c0 00000028 eca19c30 00000000 00000028
> > 9b80: 00000000 00000000 84ce1400 85528900 eca19c0c eca19ba0 804e1294 8052f328
> > 9ba0: eca19c28 87979800 eca19bc4 eca19bb8 804d9550 804d92a0 eca19bec eca19bc8
> > 9bc0: 804f3820 804d94ec eca19c28 87979800 2000d000 eca19d28 00000000 eca19c30
> > 9be0: eca19c0c 00000214 83ff9800 2000d000 eca19d28 00000000 00000000 00000000
> > 9c00: eca19ca4 eca19c10 804e2bc4 804e0f64 eca19c64 00000000 eca19c4c 72c571c0
> > 9c20: eca19c30 8575ad00 df871003 00000000 84ce1400 00000cc0 0002000d 2000d000
> > 9c40: 2000d000 00000a14 87979800 8688cec0 00002880 00000000 00000000 00000000
> > 9c60: 00000000 deb5fbb8 00000000 00000000 826c36c0 72c571c0 eca19d0c eca19d28
> > 9c80: 2000d000 00000207 2000d000 00000214 8575ad00 00000007 eca19cec eca19ca8
> > 9ca0: 80232fcc 804e2718 00000001 00000000 8280c82c 83ff9800 00000000 83ff9800
> > 9cc0: 81c01eb4 8281d3d0 00000207 2000d000 eca19d28 80232edc 83ff9800 84df3318
> > 9ce0: eca19d24 eca19cf0 8023357c 80232ee8 eca19d5c 80200c04 83ff9800 84df3318
> > 9d00: eca19d24 81ab4034 80000013 ffffffff eca19d5c fffff000 eca19da4 eca19d28
> > 9d20: 80200b2c 80233550 2000d000 7effffff a100d000 000006c0 2000d000 2000d000
> > 9d40: b5003500 b5403587 fffff000 2000d6c0 84df3318 eca19da4 eca19da8 eca19d78
> > 9d60: 804d0850 81ab4034 80000013 ffffffff eca19d94 b5003500 8047cd9c 0047ca50
> > 9d80: 000006c0 00000000 00000000 000006c0 000006c0 81c1ee80 eca19dc4 eca19da8
> > 9da0: 808f215c 804d07dc 00000000 00000000 0000c940 000006c0 eca19e2c eca19dc8
> > 9dc0: 8047db10 808f211c 000006c0 00000000 debb5aac 00000000 eca19e1c 83ff9800
> > 9de0: 00000000 0000c940 eca19ed8 eca19e60 2a7a3214 debb5aac 00000000 72c571c0
> > 9e00: eca19e60 00000000 eca19e60 84df3290 eca19ed8 875806c0 00000001 00000006
> > 9e20: eca19e54 eca19e30 804abc20 8047d87c 00002004 875806c0 00000000 eca19f88
> > 9e40: 83ff9800 00000001 eca19ebc eca19e58 80572c54 804abbb0 00000006 eca19ed8
> > 9e60: 875806c0 00000000 00000000 00000000 00000000 00000000 00000006 00002004
> > 9e80: 00000000 00000000 eca19ebc 72c571c0 8028d87c 804abba4 00000000 875806c0
> > 9ea0: eca19f88 83ff9800 00000001 0000016a eca19f5c eca19ec0 805743d0 80572b30
> > 9ec0: 00000000 eca19ed8 00000000 00000000 00000000 00000000 00010000 0000c940
> > 9ee0: 200006c0 000e4635 00000001 00000000 81af13d4 200006c0 000f0f75 00000000
> > 9f00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> > 9f20: 00000000 00000000 00000000 00000000 00000000 72c571c0 875806c1 875806c0
> > 9f40: 00000001 20000080 8020029c 83ff9800 eca19f84 eca19f60 80574834 805742a8
> > 9f60: 00000000 0013e480 00000000 00000000 003464f8 0000016a eca19fa4 eca19f88
> > 9f80: 805760c4 805747b0 00000000 00000000 00000000 83ff9800 00000000 eca19fa8
> > 9fa0: 80200060 805760b0 00000000 00000000 00000006 20000080 00000001 00000000
> > 9fc0: 00000000 00000000 003464f8 0000016a 003464b8 00000000 00000001 76ec30dc
> > 9fe0: 76ec2e88 76ec2e78 00018ba0 001302e0 60000010 00000006 00000000 00000000
> > Call trace:
> > [<804d9294>] (__kmap_local_pfn_prot) from [<804d9550>] (__kmap_local_page_prot mm/highmem.c:593 [inline])
> > [<804d9294>] (__kmap_local_pfn_prot) from [<804d9550>] (__kmap_local_page_prot+0x70/0x74 mm/highmem.c:576)
> >  r8:82a80518 r7:ffebe000 r6:00001000 r5:eca19978 r4:00001000
> > [<804d94e0>] (__kmap_local_page_prot) from [<80818b4c>] (kmap_local_page include/linux/highmem-internal.h:73 [inline])
> > [<804d94e0>] (__kmap_local_page_prot) from [<80818b4c>] (scatterwalk_map include/crypto/scatterwalk.h:111 [inline])
> > [<804d94e0>] (__kmap_local_page_prot) from [<80818b4c>] (scatterwalk_next include/crypto/scatterwalk.h:146 [inline])
> > [<804d94e0>] (__kmap_local_page_prot) from [<80818b4c>] (memcpy_from_scatterwalk+0x44/0xf0 crypto/scatterwalk.c:39)
> > [<80818b08>] (memcpy_from_scatterwalk) from [<80818c90>] (memcpy_from_sglist+0x98/0xbc crypto/scatterwalk.c:72)
> >  r10:0000002d r9:ff7f5e74 r8:eca199a0 r7:8337ec00 r6:deddc6a8 r5:00000000
> >  r4:00000000 r3:00000000
> > [<80818bf8>] (memcpy_from_sglist) from [<80537bf8>] (zswap_decompress+0xd4/0x28c mm/zswap.c:946)
>
> 		memcpy_from_sglist(kmap_local_folio(folio, 0), input, 0, PAGE_SIZE);
>
> Note the kmap_local_folio() that never has a kunmap_local_folio() done to it...
>
> Looks to be commit e2c3b6b21c77.
>
> So a fix would be to add a kunmap_local_folio() here.
>
> Have sent a patch, which should be at
> https://lore.kernel.org/all/20260316140122.339697-1-ljs@kernel.org/ but lore
> just decided to break so you can also see it at
> https://marc.info/?l=linux-mm&m=177367239109552&w=2

OK lore's back, at least for linux-mm, so is at

https://lore.kernel.org/linux-mm/20260316140122.339697-1-ljs@kernel.org/T/#u

