Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2924CD24451
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 17:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AF036B00A5; Thu,  4 Dec 2025 12:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45FE36B00A7; Thu,  4 Dec 2025 12:52:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375878D0001; Thu,  4 Dec 2025 12:52:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2652B6B00A5
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:52:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0B5916033B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:52:52 +0000 (UTC)
X-FDA: 84182534184.20.D349946
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 31E92180011
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:52:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OEprNUEv;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764870771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IIM/SPjkK4FNsPgSjNgG/0QOsmrHFtDYau3v9eqdx3U=;
	b=WEzrzjiRFD08XuXrtjAeQcIG6PjPjhDo05lqsPjdjdNEcMWXHB9xb592LJYnO7RZhtcnVs
	80g0XKN/cVmRWz8fJgowLjo90bLqyLHB1W4TGFc1QWSquEkG9qowtPoo2751hspDQACJeP
	Y2JRgr7l3AFQbRMglCabq7nowYpLDoM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764870771; a=rsa-sha256;
	cv=none;
	b=ERHujTUkh0OsstaASGAwlPky1A7/tJ5ZCGmBeo5PGMH3AAotzkczCGMFzrRw9xArwK7Ue7
	/5Q6Gj/fVbYh9YBVn78VG+cz9JR7lpX0k4mjE3lpDchwnF78anFiw82w00mABjAqinWede
	N/QCkNoyIJwLM0k6LaNr/n8cpKfH1rw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OEprNUEv;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 26BE2601FD;
	Thu,  4 Dec 2025 17:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED49C4CEFB;
	Thu,  4 Dec 2025 17:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764870769;
	bh=DA9sJvA5tPMf3L1jBZwxHdfTxY+amIPbtGepu9VIEh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OEprNUEvW8qmIDYNlWFM/AsLXrtGLg2ss4MYpjzKW1LYFPYkt9h93qnZxylHoslXC
	 IoPZKIHV88WcjIIfkywxKNnEur7UY9hIWAS1g5R7MZCRplpAnwCcKEoqi33oDQaXWP
	 X+8DpHBAMDmYgLCdBRhiym+ogD6AE3Gyfe58ZHInmwwm5D2ZXkEdwavlMHj3gpYRaJ
	 joDiliqQbezPP2qqZCRUtc9M4UrZfNbuLAIGJuX5V6uXwijLengdS5M64cklc1TpNS
	 3GNOfNCW6eEKFL4LZ/Yie+bzoUu5lj0lLMS+ODRPv6fOLfOVLISuJOo0k3I7L8Fwul
	 RzpIFh6w4QVYA==
Date: Thu, 4 Dec 2025 19:52:41 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org,
	changyuanl@google.com, graf@amazon.com, leitao@debian.org,
	thevlad@meta.com, pratyush@kernel.org, dave.hansen@linux.intel.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3 2/2] mm/memblock: only mark/clear KHO scratch memory
 when needed
Message-ID: <aTHKaaeY7_HCswbg@kernel.org>
References: <20251128173257.969322-1-usamaarif642@gmail.com>
 <20251128173257.969322-3-usamaarif642@gmail.com>
 <aSwFwMVyFcPlOR10@kernel.org>
 <CA+CK2bB+OQ-8CDdQfN3UFxUJR62ZjZkFB3dN43LYaXavewk_ng@mail.gmail.com>
 <f1ee34be-44fd-4286-8b02-f69d3a2dbd26@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f1ee34be-44fd-4286-8b02-f69d3a2dbd26@gmail.com>
X-Rspamd-Queue-Id: 31E92180011
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: xtnq5r6p45b6zmx1rcx3qk63us8ezpf5
X-HE-Tag: 1764870771-400582
X-HE-Meta: U2FsdGVkX18Du8nKGQ8ntuK7GOHED7rJc3VsSO80cxLwS95bx0di0a7OIl9y9XmuevoyIeMrxqaI9giqWmz5ICLn9jQ4iZy0ZL9lsJO5ny0sjgznF5i0KN89dxZlJPRY/xWPyRDAYs7P/1MzRZJl7Iu3BgMd0+pWGbaXgQWetev1JjFWSpORipgTXehz/u9d7bGxG/M0xMxxPHFJswPSCquA4yPU4vJ9yCU5wZFDtjr8/YfasvwYt0yMvFwv6iLwmDiM0apFXimQV93QlDpgwpCTXXNPXld5S0/Xj5WI4XrW9y2OtnzxZTaDEeLc7aVtaPnvF5pm3Rv7EUFwekwdPQh0OpTqVTyCsxK9StWTUC006QEWHUAKjGs+6gNE5i0AJZwK0YKKEvT7KIgwlk6oVc6r1TsBHp2x5EHKgwKcg3XTyfUdNzYgJRW7QhkBFRI0HPfyo76fXiXJpdehVRXbvxJDBKfC9rQZ3GH8hlrcNW5tTcEz0n8XkJQJ219q9d551j/RIk1Jj9RkZ8LPYVlNCRu9zSCKvR0EqdWCyeNi338w7cgVXUiZuoIh/wVDICPZyLB75DP7sGMwhx7fyB8FJZhagWjz0E5/bJ4efZk72jukoRYtr0nOMMJPV5oNY27pSDCFzvbMoaMjIpAyN3kX3YXtb95beKbxpU1q2hvZ62xoJN4gR96qKn0bCBorEDMJk1DBxRJSeA/eOutQS/6+2M1A8m+IaQXeDWE8Wd1bNXVQTGBiC2S/Ar/SspOyik1bD21CGTamtHIGYGf+Fs9ffAiyQbiw2qT6PlnE42XtGCkpFGJgcBMcoFMBQebycHm1Hsgmq6ABS6qd5NbBVhWwZPQ9SKC2atPn+H6fj5k397bIZrZiDpvzbaAztj2atpmcrFz5b0al3LXj1R+K3j1ZD9TziCYfh2ik5RIUytTGRH1nMkHUzjP/g+LyoEv7eroie/8Jek7iDbfLlkHjCED
 nlRGAGC0
 zdoAlCxTx0U1eCBR3QrJyiTh2RbTD19FQzC/v/LNJ/sLPh1lTnVcm2TSFBCtdiZJMCJM22q9r4kERGtTbQZt+zznqA8kruwmyEU3OvhZHFlPgUd292ex/IRiZYmc3a2SnHJcEOZzWOlKAAq0a/Kr8qjwdYTxJWYjr0GR8trWnN6BN8vzStlZ0pvX9nbUJDSPrI+vDpQpl6Q4bOwnD+wkve/N/49veofy+EXPe94CosBywmS9gzmkby1Qby9xuwJUbSRdOKr7SChFJ6lH7jWmL2RyVQShwFXuyjgfSKNIh1om9126Kpr2sJcpGOLCNi+Wvza+80K9F/tu8YVe8di2AFGhu14C7cDldz2jFjuMw2DJ/qpZobpLToQXu8YBR2hR8YQdl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Usama,

On Thu, Dec 04, 2025 at 02:51:00PM +0000, Usama Arif wrote:
> > On Sun, Nov 30, 2025 at 3:52 AM Mike Rapoport <rppt@kernel.org> wrote:
> >>
> >> On Fri, Nov 28, 2025 at 05:29:34PM +0000, Usama Arif wrote:
> >>> The scratch memory for kexec handover is used to bootstrap the
> >>> kexec'ed kernel. Only the 1st 1MB is used as scratch, and its a
> >>> hack to get around limitations with KHO. It is only needed when
> >>> CONFIG_KEXEC_HANDOVER is enabled and only if it is a KHO boot
> >>> (both checked by is_kho_boot). Add check to prevent marking a KHO
> >>> scratch region unless needed.
> >>
> >> I'm going to rewrite the changelog and queue this for upstream:
> >>
> >> The scratch memory for kexec handover is used to bootstrap the kexec'ed
> >> kernel and it is only needed when it is a KHO boot, i.e. a kexec boot with
> >> handover data passed from the previous kernel.
> >>
> >> Currently x86 marks the first megabyte of memory as KHO scratch even for
> >> non-KHO boots if CONFIG_KEXEC_HANDOVER is enabled.
> >>
> >> Add check to prevent marking a KHO scratch regions unless they are actually
> >> needed.
> >>
> >>> Fixes: a2daf83e10378 ("x86/e820: temporarily enable KHO scratch for memory below 1M")
> >>> Reported-by: Vlad Poenaru <thevlad@meta.com>
> >>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> >>> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> > 
> > This patch causes panic with my tests in linux-next.
> > 
> > [    0.000000] Kernel panic - not syncing: Cannot allocate 17280 bytes
> > for node 0 data
> > [    0.000000] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted
> > 6.18.0-next-20251203 #2 PREEMPT(undef)
> > [    0.000000] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> > BIOS 0.1 11/11/2019
> > [    0.000000] Call Trace:
> > [    0.000000]  <TASK>
> > [    0.000000]  ? dump_stack_lvl+0x4e/0x70
> > [    0.000000]  ? vpanic+0xcf/0x2b0
> > [    0.000000]  ? panic+0x66/0x66
> > [    0.000000]  ? alloc_node_data+0x32/0x90
> > [    0.000000]  ? numa_register_nodes+0x82/0x100
> > [    0.000000]  ? numa_init+0x36/0x120
> > [    0.000000]  ? setup_arch+0x667/0x7f0
> > [    0.000000]  ? start_kernel+0x58/0x640
> > [    0.000000]  ? x86_64_start_reservations+0x24/0x30
> > [    0.000000]  ? x86_64_start_kernel+0xc5/0xd0
> > [    0.000000]  ? common_startup_64+0x13e/0x148
> > [    0.000000]  </TASK>
> > [    0.000000] ---[ end Kernel panic - not syncing: Cannot allocate
> > 17280 bytes for node 0 data ]---
> > PANIC: early exception 0x0d IP 10:ffffffff89007a13 error 763 cr2
> > 0xffff991090a01000
> > 
> 
> Thanks for reporting this and sorry for the bug!
> 
> So the patch was designed to remove the memblock_mark_kho_scratch in e820__memblock_setup if not
> in KHO boot. But it broke memblock_mark_kho_scratch in kho_populate.
> Moving kho_in.fdt_phys = fdt_phys to before the memblock_mark_scratch
> should fix it. I dont have a setup where I can easily test KHO, but I think below
> should fix it?

This might, but this is too late for v6.19-rc1.
For now I'm dropping this series from memblock/for-next.
We can resume working on this after merge window closes.
 
> TBH using fdt_phys to check if the boot is KHO might be a bit hacky? Is it possible
> to have a better check for this?

Presence of KHO FDT is a clear indication that it is a KHO boot.
The issue is that during early boot ordering is hard and it's not always
clear in which order features and configuration are detected and used. 
 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 9dc51fab604f1..c331749e6452e 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1483,6 +1483,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>                 goto out;
>         }
>  
> +       kho_in.fdt_phys = fdt_phys;
>         /*
>          * We pass a safe contiguous blocks of memory to use for early boot
>          * purporses from the previous kernel so that we can resize the
> @@ -1513,7 +1514,6 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>          */
>         memblock_set_kho_scratch_only();
>  
> -       kho_in.fdt_phys = fdt_phys;
>         kho_in.scratch_phys = scratch_phys;
>         kho_scratch_cnt = scratch_cnt;
>         pr_info("found kexec handover data.\n");
> @@ -1524,7 +1524,10 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>         if (scratch)
>                 early_memunmap(scratch, scratch_len);
>         if (err)
> +       {
> +               kho_in.fdt_phys = 0;
>                 pr_warn("disabling KHO revival: %d\n", err);
> +       }
>  }

-- 
Sincerely yours,
Mike.

