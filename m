Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AD4DE83045
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 06:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DE726B0005; Wed,  4 Feb 2026 01:36:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0086B0089; Wed,  4 Feb 2026 01:36:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C43A6B008A; Wed,  4 Feb 2026 01:36:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66DD26B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:36:32 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D84891B253E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:36:31 +0000 (UTC)
X-FDA: 84405815382.27.BFFCFD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 533B240002
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:36:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q2OuIsCp;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770186990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PKiLsQOYKsOSLiFQOikhSGrffLOP0eA8agqGroBlfPU=;
	b=kJ8BAwvOJv8vkLkEHUGHgC2ciXMy/2n4m79wg+GtGQU8aU8gCdtfPTRJ3b9RKoIMibie6Z
	SF94j7xf9xG+njx9LEaPB9jOk7i0YC9TRKXQXddy8S13usQWcRAMC/C14BKGKn5P8C4v5K
	0eTmPlnjAhdDtLJu18LqUDbuFXQ8+oE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q2OuIsCp;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770186990; a=rsa-sha256;
	cv=none;
	b=XXph3KOK5BeBV9r26r3J6i0674t/u4hkf1E8thtPsEFSnOItHWQD7KXWeSQcF/A1nPrTDH
	gr21h8vxKKJQ4yah5o4l2hfvsFIxbXmnkT4JWAHvTwfD/QhIXSPUeHh6DGKpjqVsIk3j2h
	2X9kbdFfxDm7/AUU9S7JXOUcyssmGtM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6202160010;
	Wed,  4 Feb 2026 06:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C879DC4CEF7;
	Wed,  4 Feb 2026 06:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770186989;
	bh=N3s8qX3LNYftquHC3kpN7MQgpIFfQVMSYk7RgIbY1MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2OuIsCps8yAxB5WsKTvJw2wY9YwmEGr1azMDKqi5tndxSlUx4bDcrNppvB3EY1WB
	 gE1qO4dfGLQZAdcIQSzo/ag6udaX7sVSMJYsc+FeKdZJWhn13a+wBYsQxM0cyC7IJz
	 M98NoTz3xVMH32Dx5I16ZI3jWyajgHUN38scVWItDjChT/htsHh9k9O1ueWBzYCvDL
	 XoHuuCILaBBNPACtQRGRALEMkJcZlq6SLwwi+9/5TqqBJpkCxanhVGrSc7F2cjAE8L
	 dFXYr94Awv9FjP36RF3udcoreRJWt1gbhqj5kwg2Qe2MD3HFNs5e/YfIKiSpNVdPCG
	 jsxymUq17EovQ==
From: SeongJae Park <sj@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Alice Ryhl <aliceryhl@google.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH v3 21/30] maple_tree: Add cp_is_new_root() helper
Date: Tue,  3 Feb 2026 22:36:19 -0800
Message-ID: <20260204063620.15857-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <malwmirqnpuxqkqrobcmzfkmmxipoyzwfs2nwc5fbpxlt2r2ej@wchmjtaljvw3>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: kfw517sxmr4wxkffzdg8np1rw46cu56y
X-Rspamd-Queue-Id: 533B240002
X-Rspam-User: 
X-HE-Tag: 1770186990-131717
X-HE-Meta: U2FsdGVkX19yJE6xlq2yu04h0qhVpUC4ekoqYGuOIYSavGgXpaj/6ZQweQwtrD9KygRHL7LMgs0wdFka67znGKOQqbEjR9OOoqdAjseXKgzGfmcOC5+J+g8oo+YMOpk+0BZFPDQWRaQBtBP3nJSlLI3nM7Q/vuV/EDQUdqb8XzOiuruR6OKQ91/zmjpsoG+tXGwl+91QkOqD6rXQJZIma//1YLr/zdpbdC7jnZwlZBSdcOdIfsNbjL0B7ifWmS7d/YdKYf1KWibFgNq67MO0yH6e/4DxQEIVLeVwz+2dTzIoT+lgbhLLoHW/Tw/PxGpv1iSxrfO0woP8dQAvhGZwqV8XgX1GqUrbFxgFzonj0rhnhDcbYyqb/Eo4gVOTdDL+AXgjphO8zgq024vMax+k9IWwB4QCeBlx4bAb/G9ntHCLBUbvbBJrzaBvKOshK0Czwttn7/AmlCme3t6om0QDEYY9A5y77MjtixCvO3QlapyN+mGvb8DAm37/yC6GTLn6OqlGTe/BLA2Nkssa4dTg23fe440BKIicPuUIUH1S85xpn5lYfJTm1hXLAIiXdKyeXL3a6T8hX4oM+dNiqBEbqJA85o/Ej3HLPs4u8syO4Eqq0VJ4xOob+8AG1HooJMO0H6ghCAx/SHiQBXsJTXH5oEju/6+k23Zn3k0f0iTv2rKwLNk5Go4MfdvNacJaBHNOvy91eobo+AIOjYs/bpHf1WZBPGEwV5z4NssZHTTagu6nv1umoxNxw/mSAv9oJFSq6pIcNupkro0WGZvQFe/DnfUPDdC+AgyJth1Q4E8CaXdlP5Di6TiSJI7KWG3x0dbgicuEDNyrIEQhLx+2fef8fITrOxZ21tU6dm8vA6zEc6csAff2+ah0UyGAtRqWEomN+Y68ot2PoBpilLTBGLoQLu+hSwkdQuBDAZpLMPcfwsg0DqDKDdstkw7pcrK3S5k7dI+TwadtfExk5fMTIcv
 tQORNYS0
 bF7hKWW7jmnSHrgHmtLZpC1WCvIVD+6I1arAz7Pj4iZXpmIVJ+8D07uK/kYOHk61UaDRgRZsDC3vuKR471B71z4vy2cqwCGvjI+FyYjhYAZ0dbOkqL1uxcwaR2Ftz2PpdJqAS61t0Y/OpbPjkdfWY1zfqmI3BkdFKHkbekTpN18ijmpvTpt1RpdfC038rgfryqGKzv7u8i64Bm3WN7g2MZaCiZE9Q2LVeYpx2cXKocupF9iLjn/xo6E8UwdLHDxw1K7IXD4E66PuWSbQbuVEyMbhnVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 3 Feb 2026 12:26:44 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> 
> Andrew,
> 
> Please apply this fix to remove warnings on older compilers.  I've compiled the
> lot against gcc 8.1 and 9.3 with only this fix needed.

I also confirmed the below patch passes my build tests.

> 
> Thanks again, SJ, for looking at these patches!

You're welcome, that's my pleasure :)

> 
> Regards,
> Liam
> 
> -------------------------------------------------------------------------------
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 42038e42a4c7e..22cbaba72931f 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -3361,7 +3361,7 @@ static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
>                  * read-side operations that can view it until it is insert into
>                  * the tree after an rcu_assign_pointer() call.
>                  */
> -               RCU_INIT_POINTER(cp->slot[0], mt_mk_node(cp->dst[0].node, mt));
> +               ma_init_slot(cp->slot[0], cp->dst[0].node, mt);
>                 cp->height++;
>         }
>         WARN_ON_ONCE(cp->dst[0].node != mte_to_node(

But, I found mm-new of today triggers below warning during booting on my test
machine.  And git-bisect points this fixup patch.  I further found reverting
this patch makes the booting success without the below warning.  I have no idea
about the root cause, so reporting first.

[    0.447863] ------------[ cut here ]------------
[    0.449019] WARNING: lib/maple_tree.c:2617 at mas_wr_split+0x116d/0x1270, CPU#0: swapper/0/0
[    0.451068] Modules linked in:
[    0.451745] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.19.0-rc6+ #263 PREEMPT(voluntary)
[    0.453653] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    0.455282] RIP: 0010:mas_wr_split (lib/maple_tree.c:2617 (discriminator 1) lib/maple_tree.c:2590 (discriminator 1) lib/maple_tree.c:3400 (discriminator 1) lib/maple_tree.c:3462 (discriminator 1))
[    0.456071] Code: ff ff ff 40 88 7b 4f 88 53 4d 4c 89 43 08 48 89 4b 10 48 89 6b 20 4c 89 63 28 e9 27 fe ff ff 4c 39 e2 0f 45 f8 e9 e7 f2 ff ff <0f> 0b e9 78 f8 ff ff 48 c7 44 24 10 00 00 00 00 b9 01 00 00 09
All code
========
   0:   ff                      (bad)
   1:   ff                      (bad)
   2:   ff 40 88                incl   -0x78(%rax)
   5:   7b 4f                   jnp    0x56
   7:   88 53 4d                mov    %dl,0x4d(%rbx)
   a:   4c 89 43 08             mov    %r8,0x8(%rbx)
   e:   48 89 4b 10             mov    %rcx,0x10(%rbx)
  12:   48 89 6b 20             mov    %rbp,0x20(%rbx)
  16:   4c 89 63 28             mov    %r12,0x28(%rbx)
  1a:   e9 27 fe ff ff          jmp    0xfffffffffffffe46
  1f:   4c 39 e2                cmp    %r12,%rdx
  22:   0f 45 f8                cmovne %eax,%edi
  25:   e9 e7 f2 ff ff          jmp    0xfffffffffffff311
  2a:*  0f 0b                   ud2             <-- trapping instruction
  2c:   e9 78 f8 ff ff          jmp    0xfffffffffffff8a9
  31:   48 c7 44 24 10 00 00    movq   $0x0,0x10(%rsp)
  38:   00 00
  3a:   b9 01 00 00 09          mov    $0x9000001,%ecx

Code starting with the faulting instruction
===========================================
   0:   0f 0b                   ud2
   2:   e9 78 f8 ff ff          jmp    0xfffffffffffff87f
   7:   48 c7 44 24 10 00 00    movq   $0x0,0x10(%rsp)
   e:   00 00
  10:   b9 01 00 00 09          mov    $0x9000001,%ecx
[    0.460144] RSP: 0000:ffffffff9b803ba0 EFLAGS: 00010087
[    0.461338] RAX: ffff8c6b8022f600 RBX: ffffffff9b803e78 RCX: 0000000000000000
[    0.462915] RDX: ffff8c6b8022ee00 RSI: 0000000000000001 RDI: ffff8c6b8022ee50
[    0.464498] RBP: 0000000000000003 R08: 0000000000000001 R09: 0000000000000003
[    0.466099] R10: 0000000000000002 R11: ffff8c6b8022ee00 R12: ffffffff9b803c90
[    0.467676] R13: ffffffff9b803e78 R14: 0000000000000001 R15: ffffffff9b803c78
[    0.469244] FS:  0000000000000000(0000) GS:ffff8c6ccfce7000(0000) knlGS:0000000000000000
[    0.470862] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.471827] CR2: ffff8c6c40801000 CR3: 00000001bf624000 CR4: 00000000000000b0
[    0.473238] Call Trace:
[    0.473861]  <TASK>
[    0.474326]  mas_store_gfp (lib/maple_tree.c:4890)
[    0.475159]  early_irq_init (kernel/irq/irqdesc.c:197 (discriminator 2) kernel/irq/irqdesc.c:572 (discriminator 2))
[    0.476105]  start_kernel (init/main.c:1112)
[    0.476922]  x86_64_start_reservations (arch/x86/kernel/head64.c:310)
[    0.477950]  x86_64_start_kernel (??:?)
[    0.478854]  common_startup_64 (arch/x86/kernel/head_64.S:419)
[    0.479761]  </TASK>
[    0.480243] ---[ end trace 0000000000000000 ]---


Thanks,
SJ

[...]

