Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54A96D0E6E8
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 13:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95CF26B0007; Tue, 25 Nov 2025 08:50:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934186B0088; Tue, 25 Nov 2025 08:50:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8714E6B008A; Tue, 25 Nov 2025 08:50:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 724926B0007
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:50:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3671112E131
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:50:58 +0000 (UTC)
X-FDA: 84149265396.15.9672B0E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8952140008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:50:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=etmqten4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764078656; a=rsa-sha256;
	cv=none;
	b=iKXkgL3uxO3Pb5ZPsbEn2JFoWokoMPtTyI9eQZNzFJ5aiB+yWc36NRCS/lmvY0kCpB4RjD
	Mq7JmQYIDr8M3jNpSa1s/jqbHAAd0+OZvAV7ShGIlzOUek5PqBjOj/IEjGmvZxRExaibw0
	2gM3HpnvV20197f1wAPPwa0qsi2rVKs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=etmqten4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764078656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDzLnaqJnF4GelhzBMoaCpTQL1e98pE3glMvvfEO1xE=;
	b=Eojv9OUgQhqakWciWwJUAZg1eJEdi0C+plWlxz1b4agiKBuCF1irgc/FeJpph3ERnNdED2
	VfPztmzXtQ0SQXoTH6cL95sgrdz99hxc8PvLOY3plptE1ie+773Q/rFjZWL8iD+Ne6LnCW
	tMwscUq3znvi3C8/ob8IcMNC1UwtPRE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BF8D960159;
	Tue, 25 Nov 2025 13:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF3BC4CEF1;
	Tue, 25 Nov 2025 13:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764078655;
	bh=6xfio8cFRmyYhEhLPbb1/bShqDICsN94++aEKRQdnVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=etmqten45YBPrROyon9PprwIWauaqW4vDxwB4L84pqD7TXNr/ypb4xYMDIP4pjB2t
	 I6pUXdOAlcm3mtXkvpziSOCffrWvM0oGTMqA7Zm5s4hpL0Rcc1PagcmomjSt786jzx
	 Lk029vWmPIXMRsUYt3aBWDLpCgu+hw9ZZtw1XBJ+ZXzQv7tWlInhER4wOvVAT6wtO4
	 CX7RmMAPnlTNzj+7sF03AhReF/bZfb/oUlctXBVHcOQLNSMXTaXktvJiVooMyZiRo9
	 z2UUCAhTbCL7rlsH4WP3KE1MMqL8hN0MiuNqowV/NXWjxtHBKLrDRelqvMCn5M52OQ
	 70clwxd6RUYEA==
Date: Tue, 25 Nov 2025 15:50:40 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>,
	Changyuan Lyu <changyuanl@google.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, anthony.yznaga@oracle.com,
	arnd@arndb.de, ashish.kalra@amd.com, benh@kernel.crashing.org,
	bp@alien8.de, catalin.marinas@arm.com, corbet@lwn.net,
	dave.hansen@linux.intel.com, devicetree@vger.kernel.org,
	dwmw2@infradead.org, ebiederm@xmission.com, graf@amazon.com,
	hpa@zytor.com, jgowans@amazon.com, kexec@lists.infradead.org,
	krzk@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org,
	mark.rutland@arm.com, mingo@redhat.com, pasha.tatashin@soleen.com,
	pbonzini@redhat.com, peterz@infradead.org, robh@kernel.org,
	rostedt@goodmis.org, saravanak@google.com,
	skinsburskii@linux.microsoft.com, tglx@linutronix.de,
	thomas.lendacky@amd.com, will@kernel.org, x86@kernel.org,
	Breno Leitao <leitao@debian.org>, thevlad@meta.com
Subject: Re: [PATCH v8 12/17] x86/e820: temporarily enable KHO scratch for
 memory below 1M
Message-ID: <aSW0MF9BXjLnY2Fr@kernel.org>
References: <20250509074635.3187114-1-changyuanl@google.com>
 <20250509074635.3187114-13-changyuanl@google.com>
 <a0f875f1-45ad-4dfc-b5c8-ecb51b242523@gmail.com>
 <mafs01plmxngp.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs01plmxngp.fsf@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8952140008
X-Stat-Signature: et4wzyntgiquejutuqagkkbeif8nqjh8
X-Rspam-User: 
X-HE-Tag: 1764078656-831039
X-HE-Meta: U2FsdGVkX1/g6COvvMfmr5dBeNY+e+1JcuSDp1jqVL//3vcx3ol/oWukex4hKIg+lakXvvbipmwXF4Lu+hadKVXe/vx+c0o4Iit+Q1u5xLsZR/otNoRCrVGAYN7EhcEoXOuIUs8WGYDlSiNCUA49LSA1PDXTEJgBa34JvYFJlcs3+7g+Iv5R8Jcnh6hK03LgM6lEWQIcekW9nafPj3YFSaKb22P0R5eTKnPjjI5p8x1DO79ok7i25eMfIHeSHKHsT/z4zOzBk+6sqW1TYmxVLJ/+w90ph2ORrpmwjmXAXf3OaDrmh0a24oMRGb+8AuzYVnGAdkU/Fj6H1L2W4RYvWEI9u4hXuK2fb8pxfsAd973/8L5snXVJSG86r6P+fWJHAMVnputDZASmVsmyuIn2aB2P3PrMP7J6OVuiTHzoSBI14UyF27HES3hG7nN7Y1ODrv55MNH15ceBv023i3mja0cKyd1d6x1YBMoSzJS3unQVYURNBaVihkWk6l03092MUw3iHhCXIVZtyaNMa63nT1TuxC7SfW4r4vyP8QEm1OhNCi7CTVEtUIcoWIGGO60abwQr7r6ZYvVeWpTi02YfCs+8UhnYpG5gOgHphVQP+2QopjO69LlPHh/gW4jXiFK3RwgbhWKpLt0zeftzNzlMSqpFA2zybt2evA35WNwcrb7QqRjvBXs8M6hrHclRjUbVvzbVeCNPHY8Ug9x7QF4i9bQ3VMkmjKUJth9xD+dkytW1tjf0mkCDiWLMDD3LeOQN+MskZFPawIs5v/AU72oowLt+a0pM6RZsQAbXGL7OUf1sHl/vnY+CJOr/9ZoryN9h3ZNfXPXkot7TpEB8V73WOsA4lfFLa3tiHlZ5wVmsE8EywCoi3ONtHfmqPTzpGTsgS4wZ/B7zMrQ6fLNECUGQ1vETV+2O57HGMjGoVvqQG4OmSOesn9hwH/efHT0+Qo99fsAo0lp104kOYf2TAJL
 u67XJv77
 RLRmlEWszT8+i8C/aDynX4t4n17qgqqYHx4F47GVTW+KsoeifUlk11+UT/NKZFiTeqalbFJvqUWQkNwkOSgsm+LxitpJtFa8Qu8xH4X2oZ2iZSMpOlpUQvjuF5wZFue78plojAxZJnKNx3WRb2ehPZwWm777Z0sK+L1vC9Z+48Rx45mN/8pz2LxWgmIZENVstmbse7Gy5SDIWpWE9eKsVWMdtxFHxuePEF6/rOz7UH4zpKf28oAlHhktwjKrfcL0fOqc+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, Nov 25, 2025 at 02:15:34PM +0100, Pratyush Yadav wrote:
> On Mon, Nov 24 2025, Usama Arif wrote:

> >> --- a/arch/x86/realmode/init.c
> >> +++ b/arch/x86/realmode/init.c
> >> @@ -65,6 +65,8 @@ void __init reserve_real_mode(void)
> >>  	 * setup_arch().
> >>  	 */
> >>  	memblock_reserve(0, SZ_1M);
> >> +
> >> +	memblock_clear_kho_scratch(0, SZ_1M);
> >>  }
> >>  
> >>  static void __init sme_sev_setup_real_mode(struct trampoline_header *th)
> >
> > Hello!
> >
> > I am working with Breno who reported that we are seeing the below warning at boot
> > when rolling out 6.16 in Meta fleet. It is difficult to reproduce on a single host
> > manually but we are seeing this several times a day inside the fleet.
> >
> >  20:16:33  ------------[ cut here ]------------
> >  20:16:33  WARNING: CPU: 0 PID: 0 at mm/memblock.c:668 memblock_add_range+0x316/0x330
> >  20:16:33  Modules linked in:
> >  20:16:33  CPU: 0 UID: 0 PID: 0 Comm: swapper Tainted: G S                  6.16.1-0_fbk0_0_gc0739ee5037a #1 NONE 
> >  20:16:33  Tainted: [S]=CPU_OUT_OF_SPEC
> >  20:16:33  RIP: 0010:memblock_add_range+0x316/0x330
> >  20:16:33  Code: ff ff ff 89 5c 24 08 41 ff c5 44 89 6c 24 10 48 63 74 24 08 48 63 54 24 10 e8 26 0c 00 00 e9 41 ff ff ff 0f 0b e9 af fd ff ff <0f> 0b e9 b7 fd ff ff 0f 0b 0f 0b cc cc cc cc cc cc cc cc cc cc cc
> >  20:16:33  RSP: 0000:ffffffff83403dd8 EFLAGS: 00010083 ORIG_RAX: 0000000000000000
> >  20:16:33  RAX: ffffffff8476ff90 RBX: 0000000000001c00 RCX: 0000000000000002
> >  20:16:33  RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffffffff83bad4d8
> >  20:16:33  RBP: 000000000009f000 R08: 0000000000000020 R09: 8000000000097101
> >  20:16:33  R10: ffffffffff2004b0 R11: 203a6d6f646e6172 R12: 000000000009ec00
> >  20:16:33  R13: 0000000000000002 R14: 0000000000100000 R15: 000000000009d000
> >  20:16:33  FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
> >  20:16:33  CR2: ffff888065413ff8 CR3: 00000000663b7000 CR4: 00000000000000b0
> >  20:16:33  Call Trace:
> >  20:16:33   <TASK>
> >  20:16:33   ? __memblock_reserve+0x75/0x80

Do you have faddr2line for this?

> >  20:16:33   ? setup_arch+0x30f/0xb10

And this?

> >  20:16:33   ? start_kernel+0x58/0x960
> >  20:16:33   ? x86_64_start_reservations+0x20/0x20
> >  20:16:33   ? x86_64_start_kernel+0x13d/0x140
> >  20:16:33   ? common_startup_64+0x13e/0x140
> >  20:16:33   </TASK>
> >  20:16:33  ---[ end trace 0000000000000000 ]--- 
> >
> >
> > Rolling out with memblock=debug is not really an option in a large scale fleet due to the
> > time added to boot. But I did try on one of the hosts (without reproducing the issue) and I see:

Is it a problem to roll out a kernel that has additional debug printouts as
Breno suggested earlier? I.e.

	if (flags != MEMBLOCK_NONE && flags != rgn->flags) {
		pr_warn("memblock: Flag mismatch at region [%pa-%pa]\n",
			&rgn->base, &rend);
		pr_warn("  Existing region flags: %#x\n", rgn->flags);
		pr_warn("  New range flags: %#x\n", flags);
		pr_warn("  New range: [%pa-%pa]\n", &base, &end);
		WARN_ON_ONCE(1);
	}

> > [    0.000616]  memory.cnt  = 0x6
> > [    0.000617]  memory[0x0]	[0x0000000000001000-0x000000000009bfff], 0x000000000009b000 bytes flags: 0x40
> > [    0.000620]  memory[0x1]	[0x000000000009f000-0x000000000009ffff], 0x0000000000001000 bytes flags: 0x40
> > [    0.000621]  memory[0x2]	[0x0000000000100000-0x000000005ed09fff], 0x000000005ec0a000 bytes flags: 0x0
> > ...
> >
> > The 0x40 (MEMBLOCK_KHO_SCRATCH) is coming from memblock_mark_kho_scratch in e820__memblock_setup. I believe this
> > should be under ifdef like the diff at the end? (Happy to send this as a patch for review if it makes sense).
> > We have KEXEC_HANDOVER disabled in our defconfig, therefore MEMBLOCK_KHO_SCRATCH shouldnt be selected and
> > we shouldnt have any MEMBLOCK_KHO_SCRATCH type regions in our memblock reservations.
> >
> > The other thing I did was insert a while(1) just before the warning and inspected the registers in qemu.
> > R14 held the base register, and R15 held the size at that point.
> > In the warning R14 is 0x100000 meaning that someone is reserving a region with a different flag to MEMBLOCK_NONE
> > at the boundary of MEMBLOCK_KHO_SCRATCH.

Judging by the register values, flags could be in %rcx or %r13 (0x2 - MEMBLOCK_MIRROR) or in
%r8 (0x20 - MEMBLOCK_RSRV_KERN)

Since WARN_ON() is triggered in __memblock_reserve() I'd bet on
MEMBLOCK_RSRV_KERN.

And apparently the warning triggers for some memory that was initially
reserved with memblock_reserve() and than some of it was reserved with
memblock_reserve_kern().

If you have the logs from failing boots up to the point where SLUB reports
about it's initialization, e.g. 

[    0.134377] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1

something there may hint about what's the issue. 
 
> I don't get this... The WARN_ON() is only triggered when the regions
> overlap. Here, there should be no overlap, since the scratch region
> should end at 0x100000 (SZ_1M) and the new region starts at 0x100000
> (SZ_1M).

Not only that, the warning is from __memblock_reserve() that works with
memblock.reserved and the dump is for memblock.memory.

> Anyway, you do indeed point at a bug. memblock_mark_kho_scratch() should
> only be called on a KHO boot, not unconditionally. So even with
> CONFIG_MEMBLOCK_KHO_SCRATCH enabled, this should only be called on a KHO
> boot, not every time.
> 
> I think the below diff should fix the warning for you by making sure the
> scratch areas are not present on non-KHO boot. I still don't know why
> you hit the warning in the first place though. If you'd be willing to
> dig deeper into that, it would be great.
> 
> Can you give the below a try and if it fixes the problem for you I can
> send it on the list.
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index c3acbd26408ba..0a34dc011bf91 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -16,6 +16,7 @@
>  #include <linux/firmware-map.h>
>  #include <linux/sort.h>
>  #include <linux/memory_hotplug.h>
> +#include <linux/kexec_handover.h>
>  
>  #include <asm/e820/api.h>
>  #include <asm/setup.h>
> @@ -1315,7 +1316,8 @@ void __init e820__memblock_setup(void)
>  	 * After real mode trampoline is allocated, we clear that scratch
>  	 * marking.
>  	 */
> -	memblock_mark_kho_scratch(0, SZ_1M);
> +	if (is_kho_boot())
> +		memblock_mark_kho_scratch(0, SZ_1M);

We'd better add an inline stub to memblock.h for
!CONFIG_MEMBLOCK_KHO_SCRATCH

and move is_kho_boot() inside memblock_{mark,clear}_kho_scratch. This might
require moving them out of line, but it's not that they are on the hot
paths.

BTW, this makes sense even if it does not help with the issue Breno and
Usama are working on.

>  
>  	/*
>  	 * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
> index 88be32026768c..4e9b4dff17216 100644
> --- a/arch/x86/realmode/init.c
> +++ b/arch/x86/realmode/init.c
> @@ -4,6 +4,7 @@
>  #include <linux/memblock.h>
>  #include <linux/cc_platform.h>
>  #include <linux/pgtable.h>
> +#include <linux/kexec_handover.h>
>  
>  #include <asm/set_memory.h>
>  #include <asm/realmode.h>
> @@ -67,7 +68,8 @@ void __init reserve_real_mode(void)
>  	 */
>  	memblock_reserve(0, SZ_1M);
>  
> -	memblock_clear_kho_scratch(0, SZ_1M);
> +	if (is_kho_boot())
> +		memblock_clear_kho_scratch(0, SZ_1M);
>  }
>  
>  static void __init sme_sev_setup_real_mode(struct trampoline_header *th)
> 
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

