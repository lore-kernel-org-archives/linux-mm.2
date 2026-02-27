Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 628FFFEFB51
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6BAB6B00E9; Fri, 27 Feb 2026 15:32:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2D196B00EB; Fri, 27 Feb 2026 15:32:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18776B00EC; Fri, 27 Feb 2026 15:32:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7386B00E9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:32:01 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 347F51603AC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:32:01 +0000 (UTC)
X-FDA: 84491383242.14.E4D9EC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9EAF2C0012
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:31:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kyuHOhzj;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772224319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HAcmYxQyGIzXk3g2T2QkeEz1xqCTs6mD3orFZBdIEmU=;
	b=7cF1BOes8xcXEbNcI8hrqht2HBUwR3FfWqNVXW9Y0T2ou381UU9mB29e2KlihzMFhjSPkL
	ZA9iIDo+c4WvbLpRtDGe7MWgsZrd9qclbBlhhIx4GUV8kdSy486UKQ2+3Cj+2ncoGNRNU0
	doJyzleNFnuvpTRm86ajw9cdbEqjHNc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772224319; a=rsa-sha256;
	cv=none;
	b=dqftZRlDwCpHBXdBYRYIWbPcz3zWN11vhN1/lEiN/oy6Rj2I+fVHWp47wUCJH4yVImJiDV
	9d6rn/lp81AdGjQM6+USZt5qIAnUdnjPDWbjaf9oDmx6UnvgLFzRTCWQRowhiL/4mDWpl3
	8MIID5vbiSOwuDS2thdS30pGoQpdtK0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kyuHOhzj;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A889F4415A;
	Fri, 27 Feb 2026 20:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BD0C116C6;
	Fri, 27 Feb 2026 20:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772224318;
	bh=GsGJcM5lC5dbmgIT+M4WfJsd6FtHP9AI7W3MvjVlZXE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kyuHOhzjPeaL9ZBX8v9BFk4Vl1+Z8aFaC9olyQsYhW+BEPn4gG+OirqiS0vjY7wSh
	 08AMVtHAdfLIukZECBbxqF78N9qGu5FW8Bt5tRmyiQAQYFEw5wxcQuuzR9pqH6WqJw
	 r3wShM1wgJAs/WfWXNGcQSjs2IlTlepCJqMP4x/V5zu2VMrV5sMU8NMr+KOPjW/OyS
	 itN52VkP0EjHt7tbTWQfjPdKlfT5854ZDrWUbFljsH2eAU+gk+L6ltqkFxDegpDUJq
	 GyMKzPup//vrXRRmPfxpL1HVKDjePjl8VyB6YHiKhoq6Y49SPP4z4wQTNnR2bzJ/f2
	 3gdeO5LHu2EBQ==
Date: Fri, 27 Feb 2026 22:31:41 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Shi <alexs@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>, Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Klara Modin <klarasmodin@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>, Vineet Gupta <vgupta@kernel.org>,
	Will Deacon <will@kernel.org>, x86@kernel.org,
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-hexagon@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org, linux-snps-arc@lists.infradead.org,
	linux-um@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev, sparclinux@vger.kernel.org
Subject: Re: [PATCH v3 23/29] arch, mm: consolidate initialization of nodes,
 zones and memory map
Message-ID: <aaH_LVnl8FlERA_r@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
 <20260111082105.290734-24-rppt@kernel.org>
 <b9527ed4-7a5c-42e9-8814-b276b3741f63@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9527ed4-7a5c-42e9-8814-b276b3741f63@suse.cz>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9EAF2C0012
X-Stat-Signature: 84e3yz3jc1nyfd67zpb5itm156doyi4u
X-Rspam-User: 
X-HE-Tag: 1772224319-19152
X-HE-Meta: U2FsdGVkX18K6I0Q6RniwH5rAkO6mRLWyQnZDKPqZsTb2IvQjlZSKSCkFdA5VBKMSdmQYJN3TiWYim7IwGAfilgQVfe8V+93Jv2Wc/DjjdqNZoqgAVmItEzAtoFvR8iIHz/eRoxxGF5QurJmgZXA3sA8NPqgcnlcA3cUYnwRwTklsJx+bzzSax3x19cmXjemPOIDwrcB2iE3rfavJVSI4vH/ZI6knqrEWK40jNReA23ib4dvdW/H6TRrxIU6EoJzVBcj1feTRr4LV5UPAfxIF6a2+2V1RafNxvT9eS9ruyHc1Rtda3TPmMdJ9zaDC+X6ccLCw5NlvpqJb3lPRnK3aUy6FPOV2fvXBGPQ0/W/oVD/NEoIeH42RxWwrebELhhzcGyEuxLi9y/OTnaWnD8C9FNLjSshUdYSCQmCd4RudE5TWj2yVDQWsHHem2qaysY+AOM5E6/FUk6UwGNg53ADGoJwplV2r4mQOOoVfkWD3lR+ln2osU27XyeJbPq7160Ru/XqHK06kZcD8ZSu+asRzCE3N+ve9/VcTrI9Urcpz/sGcJp7s8EB6qXK57nah+In0ds8iFMd3uEXMv/CnKyrhpDmHmReKIaeu2/0zqOIh73DzX+8A6m26Fvmfa5kwdhHbNBXisV9O8naeA959PqFjd0g9Uzfssj+nw7RGJ+08bWP2ZHP3R9n0C2bA7kgJ7LnqwoQFQeXXPmgKR86I1lqGLShX2u8r3fTdngFuE9vznb5ivFageEHf/8NT6yyg6lwIcnA3y2Z48Cg5IfIZ5Q161jWBv5iTXhKkDysdttse5jJD7SxvPqoo76NK0Ucvjn/ychW7CpIL88kEVI9DPv7HFrCN4DD6/g9p34eonRPxGGw6hL3T/CZNx7VNTYQXJs5LnuX4hgpRKvxnP7WvH5i9lTKcMiHLUgWl5CIabvqUJWasntB9fzS/lZhKkwGcV4YcNEaxPjP4Rlf8aKKB2n
 8p9o5Lse
 WLbisowOc8XnhGTHf4KXl50zcKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vlastimil,

On Fri, Feb 27, 2026 at 04:14:42PM +0100, Vlastimil Babka wrote:
> On 1/11/26 09:20, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > To initialize node, zone and memory map data structures every architecture
> > calls free_area_init() during setup_arch() and passes it an array of zone
> > limits.
> > 
> > Beside code duplication it creates "interesting" ordering cases between
> > allocation and initialization of hugetlb and the memory map. Some
> > architectures allocate hugetlb pages very early in setup_arch() in certain
> > cases, some only create hugetlb CMA areas in setup_arch() and sometimes
> > hugetlb allocations happen mm_core_init().
> > 
> > With arch_zone_limits_init() helper available now on all architectures it
> > is no longer necessary to call free_area_init() from architecture setup
> > code. Rather core MM initialization can call arch_zone_limits_init() in a
> > single place.
> > 
> > This allows to unify ordering of hugetlb vs memory map allocation and
> > initialization.
> > 
> > Remove the call to free_area_init() from architecture specific code and
> > place it in a new mm_core_init_early() function that is called immediately
> > after setup_arch().
> > 
> > After this refactoring it is possible to consolidate hugetlb allocations
> > and eliminate differences in ordering of hugetlb and memory map
> > initialization among different architectures.
> > 
> > As the first step of this consolidation move hugetlb_bootmem_alloc() to
> > mm_core_early_init().
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> I've bisected a problem with virtme-ng testing a NUMA memoryless
> node setup (on x86_64) to this patch (commit d49004c5f0c1).
> 
> It's executed like this, where node 0 has memory and node 1 only cpus:
> 
> vng -vr . -p 8 -m 4G --numa 4G,cpus=0-3 --numa 0,cpus=4-7
> 
> This fails to boot due to:
> 
> [    0.095894] BUG: unable to handle page fault for address: 0000000000004620
> [    0.097196] #PF: supervisor read access in kernel mode
> [    0.098180] #PF: error_code(0x0000) - not-present page
> [    0.099155] PGD 0 P4D 0 
> [    0.099641] Oops: Oops: 0000 [#1] SMP NOPTI
> [    0.100437] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.19.0-rc6-00152-gf206359553c9 #53 PREEMPT 
> [    0.102201] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-2-g4f253b9b-prebuilt.qemu.org 04/01/2014
> [    0.104313] RIP: 0010:mm_core_init_early+0x263/0x900
> [    0.105271] Code: 93 ff 72 09 8b 7c 24 30 e8 da 82 00 00 48 63 44 24 30 45 31 db 4c 8b 24 c5 a0 7b 1d 9a 48 89 c3 4c 89 5c 24 50 4c 89 5c 24 58 <41> 83 bc 24 20 46 00 00 00 75 0b 41 83 bc 24 14 47 00 00 00 74 04
> [    0.108863] RSP: 0000:ffffffff99403e38 EFLAGS: 00010046
> [    0.109861] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000001
> [    0.111223] RDX: 0000000000000040 RSI: 0000000000100000 RDI: ffff89597fffae00
> [    0.112577] RBP: 0000000000000005 R08: 0000000000000000 R09: ffff89597fffa200
> [    0.113924] R10: 80000000ffffe000 R11: 0000000000000000 R12: 0000000000000000
> [    0.115294] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [    0.116656] FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
> [    0.118193] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.119283] CR2: 0000000000004620 CR3: 0000000060048000 CR4: 00000000000000b0
> [    0.120645] Call Trace:
> [    0.121122]  <TASK>
> [    0.121521]  start_kernel+0x5d/0x780
> [    0.122206]  x86_64_start_reservations+0x24/0x30
> [    0.123079]  x86_64_start_kernel+0xd1/0xe0
> [    0.123860]  common_startup_64+0x12c/0x138
> [    0.124641]  </TASK>
> [    0.125061] Modules linked in:
> [    0.125646] CR2: 0000000000004620
> [    0.126279] ---[ end trace 0000000000000000 ]---
> [    0.127162] RIP: 0010:mm_core_init_early+0x263/0x900
> [    0.128106] Code: 93 ff 72 09 8b 7c 24 30 e8 da 82 00 00 48 63 44 24 30 45 31 db 4c 8b 24 c5 a0 7b 1d 9a 48 89 c3 4c 89 5c 24 50 4c 89 5c 24 58 <41> 83 bc 24 20 46 00 00 00 75 0b 41 83 bc 24 14 47 00 00 00 74 04
> [    0.131676] RSP: 0000:ffffffff99403e38 EFLAGS: 00010046
> [    0.132684] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000001
> [    0.134033] RDX: 0000000000000040 RSI: 0000000000100000 RDI: ffff89597fffae00
> [    0.135412] RBP: 0000000000000005 R08: 0000000000000000 R09: ffff89597fffa200
> [    0.136763] R10: 80000000ffffe000 R11: 0000000000000000 R12: 0000000000000000
> [    0.138112] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [    0.139487] FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
> [    0.141014] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.142094] CR2: 0000000000004620 CR3: 0000000060048000 CR4: 00000000000000b0
> [    0.143448] Kernel panic - not syncing: Attempted to kill the idle task!
> [    0.144833] ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---
> 
> > ./scripts/faddr2line vmlinux mm_core_init_early+0x263/0x900
> mm_core_init_early+0x263/0x900:
> free_area_init_node at mm/mm_init.c:1721
> (inlined by) free_area_init at mm/mm_init.c:1902
> (inlined by) mm_core_init_early at mm/mm_init.c:2681
> 
> It crashes at WARN_ON(pgdat->nr_zones || pgdat->kswapd_highest_zoneidx);
> because pgdat is NULL.
> 
> With some debug printk's I've figured out that in free_area_init()
> we have:
> 
>                 if (!node_online(nid))
>                         alloc_offline_node_data(nid);
>              
>                 pgdat = NODE_DATA(nid);
>                 free_area_init_node(nid);
> 
> 
> But node_online() is true so this allocation doesn't happen, and
> pgdat remains NULL.
> 
> And node_online() becomes true in init_cpu_to_node():
> 
>                 if (!node_online(node))
>                         node_set_online(node);
> 
> But without having a pgdat allocated.
> 
> I was able to workaround this by changing the code in free_area_init() to
> 
>                if (!node_online(nid) || !NODE_DATA(nid))
>                         alloc_offline_node_data(nid);

if (!NODE_DATA(nid)) is enough ...
 
> But I don't have the bigger picture, and also didn't check yet what exactly
> about this patch results in the failure. Probably ordering of various related 
> actions. Thoughts?

... and there's a fix already in the mm-hotfixes-stable:

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-hotfixes-unstable&id=a4ab97e34bb687a2ca63fc70b47e8762e689797f

-- 
Sincerely yours,
Mike.

