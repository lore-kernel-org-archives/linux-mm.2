Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 396CFCD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52ED6B00D7; Tue,  5 May 2026 11:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2AC46B00D8; Tue,  5 May 2026 11:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967C76B00D9; Tue,  5 May 2026 11:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83CD56B00D7
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:43:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 507EF1A0552
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:43:03 +0000 (UTC)
X-FDA: 84733784646.30.5E20A09
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 30C6F180014
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:43:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NIzKZt4z;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777995781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iwRizo0xbie4Bg9vziU8v0kBZl92TvvHtH36INlm6CU=;
	b=QeU9wqELJpob17cfcfJZag8xDyOz25iTOkXtOI9PkEdDMfIBQ5qRr1i7Rg39JbmO48pgZH
	UN1LO9F6QHYA/OiL9PWxbsWLTAQFRkByrtMEgWkzlJz7SSjkjKR2EO0MaTljR38VuC5AhT
	N50l34UfoClHjwxRXYkRmLf8NAJCol4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777995781; a=rsa-sha256;
	cv=none;
	b=KTUp05AVJHwcVhlgc5Og4+pVqNR+Xg6cLpqzIfhuCYtnH9+i/gGdIOiBQMy6DjIwtz277e
	JNdVW0f9+7fLK5OmcoQShD1RrtLL8dGFMwPUmOyh9n0mZLfhE+nQ9RhxZ5vBjGCS5JMwEC
	TDbhASJgJ6IERD0j8ZXYIBnEW2fpqF8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NIzKZt4z;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94CC62681;
	Tue,  5 May 2026 08:42:54 -0700 (PDT)
Received: from [10.57.63.19] (unknown [10.57.63.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 671EA3F836;
	Tue,  5 May 2026 08:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777995779; bh=iwRizo0xbie4Bg9vziU8v0kBZl92TvvHtH36INlm6CU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NIzKZt4zcu2MezSQ2f7BjKQlPFd+wq1ZltfcIoa9TM3i2hI+52kbb3+4atY93eiFs
	 GPD5KrLf+3TMDyEghwcdBGRZOoJDVIiZrYJwt+ylbKLlnjDOVA4Z5BDp91vCe8QRk4
	 nAdNA6T0mfR2WrMTda/OBu9+TSxv47XOgZUwCrDg=
Message-ID: <7dc9485d-a822-494d-9384-4a973c782c11@arm.com>
Date: Tue, 5 May 2026 17:42:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 07/30] arm64: Reset POR_EL1 on exception entry
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
 Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
 Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
 Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
 <20260227175518.3728055-8-kevin.brodsky@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260227175518.3728055-8-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 30C6F180014
X-Rspamd-Server: rspam04
X-Stat-Signature: 4kefx9bnyi514mrqwny7j6fhk383t7fe
X-HE-Tag: 1777995780-119155
X-HE-Meta: U2FsdGVkX1+BLEkz57kqHAZZBA3G7UrfA3EDARbbRZjHmJ5WRjI9AGpJTMoOb+l0IjuNnx1k3Y1Zf81c0c+v0F2FM06EoExxoHtPoBeCXjTJaxfWR2bSVIjTIYF0B/iS8AovjFobUbls/hzbz1Y/SCBcNdhGueQUJ2X4fma5foUlIStuCRk0myIO6vfqxXynn/M/JsMKlwXr0rvP8Xadjnja1sN9Q/gRJvbesewLTbrMx3BR93sJ4efET6f6UPDwdXwnUf4pFo54cFEX9M0DFOmCi9FGYKZLzSBjChDNY7aLeVSsU5oYvRBwSo23K8ZFvKGX6bHkywip0OOdwuF7e+Qo1vhEVZTlxG3XRNEIyqDAnRe0aFwT7VOvuKcbqk6QBaDcXze1krbWVOzyBEu9F8AA6GOTT+225wrJ/SPwP0k724A2bg8rLgGZp3idWctALK9cqYKcJTPyBwIdCeDemb4sRD/MIfChMqKiBXys6oA+zVdTlUIFy+ghl8Cc+4bRdcS0M4fUmYLz0/xDy5BN5idu9VDl6U+fQVlFMwhvd1oUKb88fCVjMPvH9eB4ok2mZnMS43tmoRWwX2rlRoRZyFnLlUD4SDjWDuxrXj7Oo+YjoE17yPXzYP0IwTEbM9uO8yYnUSOZOhmVznTH8F1bVzAqyR3tqOs1ary/rHQeBIu4IA08JUEsltqMokxGp5kpsRxUBRDLIjLc439L7TqRXdcWy/SRTGWvLoBpHtYlX4XV8q7XqQE3R4sSpaHSyXHO8YzQudpVivTGnkaG58vOAFWYgrnwMEo3M5L7AA5ND90LgawxfRFQqb7JR5GMfDlJNWf+NI39CfnMsMkE7MQIgrdxo4We9kR2XLTHNEMMNUT43rlFWOJpPw4hKtbYcOjOUy2EH47T+KSi63yC1o+JsCdHSzgTEznuibfnn0f5wf8dz7Zxxg2iQUTDL1qw2WpYHhOduL6IiwCh9ps0Lzr
 QXKZlyrV
 oVQqSH3RAg8dQYUqMa8aSF7j9D/+jc8tzV611pOihGoYwdqWUFm79V4IkqqyqLbCyEVr0y/MhznkhMk/gd0qOxY5H66fSwrtlGBy8/stPY9IDOgUk/aLvwf/j/pFu5mtbWFrln0bWwEzh+49re+v0RRQdUjPTpayDW4dZTx/oifbdVjiCXl80ZVM5kri7llWjaobDU6jWlTMKXLxWbLJf0fZELvcT7Ke2UR/cWP2aO1ksRaWnrI8McADLo+005QG3AawUhSl1dwonofgBNenJkqRXyIkFnsrboarwOm9SF8sk4UScpzBGyFTcpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/02/2026 18:54, Kevin Brodsky wrote:
> POR_EL1 will be modified, through the kpkeys framework, in order to
> grant temporary RW access to certain keys. If an exception occurs
> in the middle of a "critical section" where POR_EL1 is set to a
> privileged value, it is preferable to reset it to its default value
> upon taking the exception to minimise the amount of code running at
> higher kpkeys level.

It turns out there is a corner case where this doesn't play well with
patch 28 (batching using lazy MMU mode). I got the following splat:

    [   33.603892] Unable to handle kernel write to read-only memory at
virtual address ffff00087fbbbd78
    [   33.603969] Mem abort info:
    [   33.604028]   ESR = 0x000000409600004f
    [   33.604058]   EC = 0x25: DABT (current EL), IL = 32 bits
    [   33.604101]   SET = 0, FnV = 0
    [   33.604133]   EA = 0, S1PT
    ** replaying previous printk message **
    [   33.604133]   EA = 0, S1PTW = 0
    [   33.604165]   FSC = 0x0f: level 3 permission fault
    [   33.604200] Data abort info:
    [   33.604222]   ISV = 0, ISS = 0x0000004f, ISS2 = 0x00000040
    [   33.604259]   CM = 0, WnR = 1, TnD = 0, TagAccess = 0
    [   33.604303]   GCS = 0, Overlay = 1, DirtyBit = 0, Xs = 0
    [   33.604345] swapper pgtable: 4k pages, 48-bit VAs,
pgdp=00000000eec2a000
    [   33.604397] [ffff00087fbbbd78] pgd=0000000000000000,
p4d=18000008fffff403, pud=18000008ffa2d403, pmd=18000008ff82f403,
pte=10e80008ffbbb707
    [   33.605031] Internal error: Oops: 000000409600004f [#1]  SMP
    [   33.605596] Modules linked in:
    [   33.605690] CPU: 0 UID: 0 PID: 1 Comm: systemd Tainted: G       
         N  7.1.0-rc2-00028-g497c3a31207b #371 PREEMPT
    [   33.605864] Tainted: [N]=TEST
    [   33.605933] Hardware name: FVP Base RevC (DT)
    [   33.606012] pstate: 141402009 (nZcv daif +PAN -UAO -TCO +DIT
-SSBS BTYPE=--)
    [   33.606140] pc : pageattr_pte_entry+0x18/0x118
    [   33.606272] lr : walk_pte_range_inner+0x1d8/0x480
    [   33.606393] sp : ffff80008005b5a0
    [   33.606467] x29: ffff80008005b5d0 x28: ffffa991675fd6b0 x27:
ffff00080e5b0000
    [   33.606662] x26: ffff00080e7af000 x25: 0010000000000001 x24:
0040000000000001
    [   33.606855] x23: 0040000000000041 x22: ffff00080e5b0000 x21:
ffff80008005b740
    [   33.607052] x20: ffff00087fbbbd78 x19: ffff00080e5af000 x18:
0000000000000000
    [   33.607245] x17: ffff0008001d2240 x16: 0000000000000004 x15:
0000000000000000
    [   33.607434] x14: ffff00080a80b810 x13: 000000000000b706 x12:
0000000000000001
    [   33.607622] x11: 0000000000000000 x10: 0000000000000000 x9 :
0000000000000020
    [   33.607809] x8 : ffffa991686a7130 x7 : ffff00880e5af000 x6 :
0000000000000072
    [   33.608000] x5 : 0000000000000003 x4 : ffffa9916625e028 x3 :
0000000000000002
    [   33.608187] x2 : 0000000000000000 x1 : 00e800088e5af707 x0 :
ffff00087fbbbd78
    [   33.608378] Call trace:
    [   33.608441]  pageattr_pte_entry+0x18/0x118 (P)
    [   33.608587]  walk_pgd_range+0x648/0x94c
    [   33.608716]  walk_kernel_page_table_range_lockless+0x5c/0x98
    [   33.608864]  update_range_prot+0x8c/0x1a4
    [   33.609007]  set_memory_pkey+0x48/0x80
    [   33.609149]  kpkeys_pgtable_free+0x40/0x9c
    [   33.609305]  pgd_free+0xd8/0x120
    [   33.609429]  __mmdrop+0x54/0x1d0
    [   33.609552]  finish_task_switch.isra.0+0x234/0x2c4
    [   33.609714]  __schedule+0x3ac/0xf00
    [   33.609860]  preempt_schedule_irq+0x3c/0x7c
    [   33.610013]  raw_irqentry_exit_cond_resched+0x2c/0x54
    [   33.610154]  arm64_exit_to_kernel_mode+0x40/0x5c
    [   33.610290]  el1_interrupt+0x48/0x60
    [   33.610416]  el1h_64_irq_handler+0x18/0x24
    [   33.610553]  el1h_64_irq+0x8c/0x90
    [   33.610672]  __vunmap_range_noflush+0x310/0x540 (P)
    [   33.610829]  remove_vm_area+0x50/0xa4
    [   33.610977]  vfree+0x38/0x274
    [   33.611118]  n_tty_close+0x40/0xa8
    [   33.611234]  tty_ldisc_close+0x4c/0xb0
    [   33.611360]  tty_ldisc_kill+0x30/0x64
    [   33.611485]  tty_ldisc_release+0xd0/0x1b0
    [   33.611615]  tty_release_struct+0x20/0x88
    [   33.611766]  tty_release+0x384/0x480
    [   33.611912]  __fput+0xd0/0x300
    [   33.612041]  fput_close_sync+0x38/0x108
    [   33.612180]  __arm64_sys_close+0x38/0x7c
    [   33.612308]  invoke_syscall.constprop.0+0x40/0x108
    [   33.612447]  el0_svc_common.constprop.0+0x38/0xd8
    [   33.612589]  do_el0_svc+0x1c/0x28
    [   33.612720]  el0_svc+0x38/0x148
    [   33.612846]  el0t_64_sync_handler+0xa0/0xe4
    [   33.612984]  el0t_64_sync+0x198/0x19c
    [   33.613137] Code: a9400c42 8a230021 aa020021 1400000a (f9000001)
    [   33.613230] ---[ end trace 0000000000000000 ]---
    [   33.974524] Kernel panic - not syncing: Oops: Fatal exception

What happened is that a thread entered lazy MMU mode in
vunmap_pte_range() (inlined) and then an IRQ fired. On the exit path of
the IRQ, another thread got scheduled. Later, the original thread was
scheduled again, and it so happened that finish_task_switch() had some
mm to drop (mmdrop_lazy_tlb_sched(mm)) and we got the last reference on
that mm. We then proceed to free the PGD and eventually write to a
linear map page table to reset the pkey.

Because this patch resets POR_EL1 on exception entry, anything running
before exception return uses the default POR_EL1 value, which does not
grant write access to page tables. This is indeed the intention, but as
this crash shows, it comes with an implicit assumption that the
context-switching machinery does not itself write to page tables (at
least not on the irqexit path).

This patch isn't functionally required for page table protection so it
will be dropped in RFC v7. Maybe lazy MMU mode could be paused for the
duration of finish_task_switch() instead, but I'm not sure whether this
is a generic enough solution.

- Kevin

