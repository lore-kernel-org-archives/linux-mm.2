Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCDB0EA7946
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 21:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29D526B008A; Wed,  4 Feb 2026 16:52:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24A7A6B0092; Wed,  4 Feb 2026 16:52:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11FC06B0093; Wed,  4 Feb 2026 16:52:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1E766B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:52:35 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9500A14029B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:52:35 +0000 (UTC)
X-FDA: 84408123870.03.E99B269
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 908D3120007
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:52:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HWKy1JXk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770241953; a=rsa-sha256;
	cv=none;
	b=YrqkZnldyPAb3fYkWb5Yy35qTTVtw1bpbXi8wLzNb4pqNPpLL8CMUeQDwEvzHi8A9Tqa8D
	Tz40lLETUBXkps4O2p31dQOBZwO6CbdlzX6r3ubgfje93WO7f4ou2EW79WeB47kg2S1CKW
	G5TBTLizKK76X/opYQAvZTHgttYNW9w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HWKy1JXk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770241953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=apwmoJ/NqQIls7XkamxxCHsqfHOdPWtNfNkocUwRrkY=;
	b=pfFxdZ/tAgYZqJA4ltJZfVE3tzTzSfAAc4E16Oqt0LTPN4LtrbMXgm9I2dGhllcLx+GUrk
	2D8hmN7MP9qVwOqBOo9afkHxlisEtwdjQC6el4xx2cGOir/7bWAc7xQciTCo+I6mKHvDgw
	lStM3VS9xjyrKgKk1CCiocrUQJx9Z88=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1EFF4400CF;
	Wed,  4 Feb 2026 21:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45DDC4CEF7;
	Wed,  4 Feb 2026 21:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770241952;
	bh=SBfx+CM602J5ou5CcxN5uQHo/IDdl2oeSO8Rn7So8ZI=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=HWKy1JXkxhvkeOGLYPlG9Opnedkfs033jLldco2kxt9E5Ea1HNKMUC/mnlKh79JLq
	 0Cww7ih/+Bk2Dn6W4Psr+ZKQkR3WJqmtYZZWPNpGGq3lhRmFzD7lBHO+LZA/VmH1UN
	 VRTUrPaS7xyJQ3X5NMDGIvAvOpvXe4IA2ACpzOIsVepExWSMT0dSVhjABRJaJP1sj2
	 JPZuDDem2a6jT7xymRus0tL1zNsTahdxogdacPLA7XcMj70Aa1PULGazJh4vjegUgA
	 HbhFoh+NkR+A91ggyTL9M0v+MX7m4r2Bv8aApXWoe/EQ5ihJac2CFLAtEG1JN2sT5O
	 gaDLIxj9gShaw==
Message-ID: <5948f3a6-8f30-4c45-9b86-2af9a6b37405@kernel.org>
Date: Wed, 4 Feb 2026 22:52:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: walk_pgd_range BUG: unable to handle page fault
To: Tytus Rogalewski <tytanick@gmail.com>, linux-mm@kvack.org,
 muchun.song@linux.dev, osalvador@suse.de
References: <CANfXJzt4P+FCkdL_=FfmG80_bY8FkzSocJSPeksSQ_vXObRNOQ@mail.gmail.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CANfXJzt4P+FCkdL_=FfmG80_bY8FkzSocJSPeksSQ_vXObRNOQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 908D3120007
X-Stat-Signature: eh39upie69dch7edpom9tn7oejuba1h1
X-HE-Tag: 1770241953-263055
X-HE-Meta: U2FsdGVkX1+N1C5VnbHEVvN+4Vw+REbi6zjj75nSBV4TqZEM2gGhcTXIA1jukdj40n3s89H7J9hjNNQiP1FjR9uanC9o1Iy9Q4FDutLTqzGt9js7p55Gwn1QuW0S9DreO6LHPDhN+MBT/AokRJwH0JQWmLOUVLj6/Xi+4q2PNrckeHNGHbhYsfrWe/zcvAIEIcWD87HkHq/cSS7duBuT5glgTylkn7k67qrug6QF0/qGnrDgQ9LtKvo8cM+jTmi1NwjbGL+E1ZAnDcpxxlv95Vh6gb+7VBdNz9Cydg9l8IfTVOdunA/lj74/DyL0jblm1yfdazvvotWxpCY2SKB2R76hKUJp43hitrvdubFVVjeCe7r/B/dyDw4biSJ5a5L/mxGLfzV1awNbZJ1MglfjTj8UNjClFGktGWwTaNmtV2yoPNZyoUmVYWH/dQ2vqJ0VN5FBgcUvfiSeeYWgrzk3wlCswnVl3XEj2Q5O+pR4uaF7l34REVyJrkdglUK4S3j1LijE2xknKNizqRZM+9vmmRvrBK9TrNY7DhfwKoyuQ68HbxuAIweCFntOlUN7ryP0BopEIIE/QtteAWHv74JpntYuJhFS/pRHNcf3OCqOocoU4pCLHuGP3PZQBK5veboPLU961mGevfJVnOCkRAkvLzV9TxhNer6tyc7GK8L0ElcarIeIcwF3aChv/RD9gpuj2tqZJbxXRjwpAt0YIwZnT34SQbPn9dw8kgQ899Axf6naqZkt5LomGf3Yd4ZrboNATddJcsP3cjrQXRc7HqInHZCLVMQ52iCNphFuPGFIY44pvKKua4V9JWULNboJAD+zi3MVWvA0TUwQv8khDBjYQYYeB/mfgwQxCpUs530k17Zu8kW80WrZhGZUuKUboNk1fAr7UlJNy95ftrLk1z4QGnI3QmVCNy4mdmISdrtpx7GMRITk7C1S2kfwgmIiaa/XQzVX2Pq0e7vpTaveNwb
 DmhSscjU
 Y+z/8GbFPVNbbfzQTUYusm6loJpfRr8zqfD/seLuIoLcM2rf+koVtKdfxq5yPxGG0Qz1aAvCyvMNvHWSNrFQmzXsnufnk7Tp+XfTlMlOmeVaAMDOCYYSYlr9IoW7pyCDSlXhjzMUiMr14RB/5FThWkaSHUqeigfU0o1/o6tywZIxKs8Hhl3WmC5LaABlQdJ6gyZdD3ZSXe9ipKqWdlaXGMAypS/jc/l3Z75iQLTH4ZH9UuFkvgof8ijX/iqbXd/Lz/DbioKo+tvCedHi/9v63kygl/mnmOs295od2CqKFg2zDW5pmqaB1qReNTDJPACeZQ124Q2UowwcG6bo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/28/26 15:14, Tytus Rogalewski wrote:
> Hello guys,
> 

Hi!

> Recently i have reported slab memory leak and it was fixed.
> 
> I am having yet another issue and wondering where to write with it.
> Would you be able to tell me if this is the right place or should i send 
> it to someone else ?
> The issue seems also like memory leak.
> 
> It happens on multiple servers (less on 6.18.6, more on 6.19-rc4+).
> All servers are doing KVM with vfio GPU PCIE passthrough and it happens 
> when i am using HUGEPAGE 1GB + qemu

Okay, so we'll longterm-pin all guest memory into the iommu.

> Basically i am allocating 970GB into hugepages, leaving 37GB to kvm.
> In normal operation i have about 20GB free space but when this issue 
> occurs, all RAM is taken and even when i have added 100GB swap, it was 
> also consumed.

When you say hugepage you mean 1 GiB hugetlb, correct?

> It can work for days or week without issue and
> 
> I did not seen that issue when i had hugepages disabled (on normal 2KB 
> pages allocation in kvm).

I assume you meant 4k pages. What about 2 MiB hugetlb?

> And i am using hugepages as it is impossible to boot VM with >200GB ram.

Oh, really? That's odd.

> When that issue happens, process ps hangs and only top shows 
> something but machine needs to be rebooted due to many zombiee processes.
> 
> *Hardware: *
> Motherboard: ASRockRack GENOA2D24G-2L
> CPU: 2x AMD EPYC 9654 96-Core Processor
> System ram: 1024 GB
> GPUs: 8x RTX5090 vfio passthrough
> 
> root@pve14:~# uname -a
> *Linux pve14 6.18.6-pbk* #1 SMP PREEMPT_DYNAMIC Mon Jan 19 20:59:46 UTC 
> 2026 x86_64 GNU/Linux
> 
> [171053.341288] *BUG: unable to handle page fault for address*: 
> ff469ae640000000
> [171053.341310] #PF: supervisor read access in kernel mode
> [171053.341319] #PF: error_code(0x0000) - not-present page
> [171053.341328] PGD 4602067 P4D 0
> [171053.341337] *Oops*: Oops: 0000 [#1] SMP NOPTI
> [171053.341348] CPU: 16 UID: 0 PID: 3250869 Comm: qm Not tainted 6.18.6- 
> pbk #1 PREEMPT(voluntary)
> [171053.341362] Hardware name:  TURIN2D24G-2L+/500W/TURIN2D24G-2L+/500W, 
> BIOS 10.20 05/05/2025
> [171053.341373] RIP: 0010:*walk_pgd_range*+0x6ff/0xbb0
> [171053.341386] Code: 08 49 39 dd 0f 84 8c 01 00 00 49 89 de 49 8d 9e 00 
> 00 20 00 48 8b 75 b8 48 81 e3 00 00 e0 ff 48 8d 43 ff 48 39 f0 49 0f 43 
> dd <49> f7 04 24 9f ff ff ff 0f 84 e2 fd ff ff 48 8b 45 c0 41 c7 47 20
> [171053.341406] RSP: 0018:ff59d95d70e6b748 EFLAGS: 00010287
> [171053.341416] RAX: 00007a22401fffff RBX: 00007a2240200000 RCX: 
> 0000000000000000
> [171053.341425] RDX: 0000000000000000 RSI: 00007a227fffffff RDI: 
> 800008dfc00002b7
> [171053.341435] RBP: ff59d95d70e6b828 R08: 0000000000000080 R09: 
> 0000000000000000
> [171053.341444] R10: ffffffff8de588c0 R11: 0000000000000000 R12: 
> ff469ae640000000
> [171053.341454] R13: 00007a2280000000 R14: 00007a2240000000 R15: 
> ff59d95d70e6b8a8
> [171053.341464] FS:  00007d4e8ec94b80(0000) GS:ff4692876ae7e000(0000) 
> knlGS:0000000000000000
> [171053.341476] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [171053.341485] CR2: ff469ae640000000 CR3: 0000008241eed006 CR4: 
> 0000000000f71ef0
> [171053.341495] PKRU: 55555554
> [171053.341501] Call Trace:
> [171053.341508]  <TASK>
> [171053.341518]  __walk_page_range+0x8e/0x220
> [171053.341529]  ? sysvec_apic_timer_interrupt+0x57/0xc0
> [171053.341541]  walk_page_vma+0x92/0xe0
> [171053.341551]  smap_gather_stats.part.0+0x8c/0xd0
> [171053.341563]  show_smaps_rollup+0x258/0x420

Hm, so someone is reading /proc/$PID/smaps_rollup and we stumble 
somewhere into something unexpected while doing a page table walk.

[171053.341288] BUG: unable to handle page fault for address: 
ff469ae640000000
[171053.341310] #PF: supervisor read access in kernel mode
[171053.341319] #PF: error_code(0x0000) - not-present page
[171053.341328] PGD 4602067 P4D 0

There is not a lot of information there :(

Did you have other splats/symptoms or was it always that?

-- 
Cheers,

David

