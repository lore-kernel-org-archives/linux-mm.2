Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83179C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 807976B00A0; Mon,  3 Aug 2026 09:17:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 790FD6B00A2; Mon,  3 Aug 2026 09:17:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 680A96B00A6; Mon,  3 Aug 2026 09:17:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 380786B00A0
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:17:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 43FD01A065E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:31:26 +0000 (UTC)
X-FDA: 85059288972.06.D972E40
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf21.hostedemail.com (Postfix) with ESMTP id DD7B31C0010
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:31:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785745884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uaW2b6ES7dXDLe/v/Ims3uFprpyE1KlhpRo/kqps2jY=;
	b=g2SgQqL5DtqDhwFbKJjPPVGOGP8bMCaGMfDmJPUxoWmG1kXqfVwgRDoFWDqJbH6mOztFjW
	tZFLTGBWWJhbKmVCkl4KW0OH5a+f3YvGpB9IlPuIE7yHpsS/V6lF4yIUQ7N19QqxL8FRxJ
	4ZJJsnrKJlyOEnEo7Hn+pB82SSumCho=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785745884;
	b=sQ3KZ6tnl97b8CYFId50r/8uTMCuUd5W00maxJ7sYOEk1b1ATx8TLBQ0ziUVs0vwglVl6f
	m524kPxej2pkfXU5qLbY5CsvMTsXNffd/dTl/OAwAqKkJaVmNN+RWvh/PcOjfuOqnhmYn6
	5plVn12PBvu5MDnR7+bny4EKYQeEkZo=
X-UUID: abd158388f1511f1aa26b74ffac11d73-20260803
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:39fdc744-9c3f-4a35-af33-10a4527732b7,IP:20,
	URL:0,TC:0,Content:10,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:30
X-CID-INFO: VERSION:1.3.12,REQID:39fdc744-9c3f-4a35-af33-10a4527732b7,IP:20,UR
	L:0,TC:0,Content:10,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:30
X-CID-META: VersionHash:e7bac3a,CLOUDID:efc466c88c93480a3c80bec4f3ef947c,BulkI
	D:2608031631084UW370JG,BulkQuantity:0,Recheck:0,SF:10|64|66|78|80|81|82|83
	|102|127|136|841|850|865|898,TC:nil,Content:3|15|50,EDM:-3,IP:-2,URL:1,Fil
	e:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,D
	KR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: abd158388f1511f1aa26b74ffac11d73-20260803
X-User: duanchenghao@kylinos.cn
Received: from localhost [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1392599488; Mon, 03 Aug 2026 16:31:06 +0800
Date: Mon, 3 Aug 2026 16:30:56 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>,
	"Andersen, Tycho" <Tycho.Andersen@amd.com>,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Matlack <dmatlack@google.com>,
	"Heyne, Maximillian" <mheyne@amazon.de>,
	James Gowans <jgowans@amazon.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Praveen Kumar <kpraveen.lkml@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	"Woodhouse, David" <dwmw@amazon.co.uk>,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>, linux-mm@kvack.org,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [Hypervisor Live Update] Notes from July 27, 2026
Message-ID: <20260803082957.GA861524@chenghao-pc>
References: <20260801123213.2259109-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260801123213.2259109-1-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD7B31C0010
X-Stat-Signature: 5zf9pz3oitknikps5xfubojfmbqaox4d
X-HE-Tag: 1785745882-237461
X-HE-Meta: U2FsdGVkX1/fbIWAbrPPMc7lfSVvV7XLiP8hF0BDYSutcn5/2xsneAyOSUoYqJPeuzymg2y3NO3q7dCoDSeBYs2/6dfrHa3QiKbfXAaWatUg8Qme1g2qw34gHlx87xixIxRe98NZaqFeUwLpFtg5z1T4InzXVhgw/bBVcKrr8alipQVLrOmRtv3I6MyQgduvmPVqtZVox0He7YhGQrs6aql7pIEACUdIhPiHgTrdPG+QvygOsfO9tITLD6Pjhgslok8vZyrq/KTRRWEPbpCKbjixrVdiq91KJMtUZWMvgSCtUQxyMc7hW1TNg3qShfuYvswlnbx9W71icWwhmT4YlA2xGkgIUyFX4YLoL/J9j6krKMcjhuH0RB/9QqQ09TcwivNEqy5wJwR6db+N1DFqpuXLrNoUOvJ7n+LbWl2wrwBLYxKJ1JqdxMEkWw+Y/xY7ANPO7kddyDettZ/eRnE+0If8oMbFU8cTXOiTBqiKmQ44bmdKEIpnASkWFhfpLdFB2MEeJCsm5p94hdgsvUL7VioJ4il/A0RnPzlscr9/6rcCTLLDSYU+rb2UGd/KXHSSpD0KQQL4kJhbWWSwCUwRLMKBrHEW5JDsmnH5JC1WPGLuBganZvZO/DdPXaqSrSvDtzJs121xCpIm+DyJ4XX1G6XkLM+1UK6mA15Uf+DsGcTPnGIh2fSCXu8eBP10YjPuy1sFyDLZ9AoxzSgI5NJA14ZhkDf0y51yWjOjAEdgez9LGyQ+8pSAAXpJeel0hKnMbB0pzyakwF+24wEgsXyVQB7oofpwSUklx3XIKO29PZlcHApBAw0gd2a0KQKLvJpk3wsk6F5a5MUn+dMriYSchjFb36mmycNt1ZTwzrU4giNj+zAi8ObvAFTISOwQJRd1vpN+cekgmASF6ZeTRSUxBBHrWpWoYuluwpDRDaiGpDeLuXhiMBjC/iaQkQne59px20jgFvUzM2wc/eeV0qd
 1XcnuIpb
 QuYhXj9jDlL3DxlUAy+jzJFiPDLkO6qoUeRrdgV4kKa5dukfQFghDkn5BKNlGEL+iwRd92Rqg3WSxwJ7jfI7L8yaoai9fwQ+apqTeJPMDRDwj85YanzVOafQ+L+OFJ5VaMjaY72ERBGBIRCPkKh7hCDeKrY5S6mzhk1HT727FlIJD570wpQBhO+6coji+a6Pa/Yv41prGl24EkNqbsFI1YiX2UyZydidxtFvzWJxCDNtrVnGqLvmK9jUIaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 01, 2026 at 08:32:07AM -0400, Pasha Tatashin wrote:
> Hi everybody,
> 
> Here are the notes from our Hypervisor Live Update call held on July 27.
> These notes are intended to bring those who could not attend up to speed
> and to keep the momentum going between meetings.
> 
> ----->o-----
> LPC 2026 Call for Proposals & Registration
> 
> * Deadline Extension: The Call for Proposals deadline for all LPC 2026
>   microconferences in Prague has been extended to August 7th.
> 
>   https://lore.kernel.org/all/ahcc3Qyuy7Oy03Iq@plex
> 
> * KVM Track Load Balancing: Due to a strong number of proposals for the
>   Live Update Microconference, the team discussed moving select topics
>   to the KVM track to balance the schedule. Orphaned VM topics (proposed
>   by Pasha and Pratyush) and potentially guest_memfd preservation will
>   be submitted to both tracks. Pratyush will coordinate with organizers
>   of both tracks to ensure talks are accepted in one track rather than
>   duplicated.
> 
> ----->o-----
> PCIe Persistence
> 
> * PCI v8 Status: David Matlack is preparing the v8 PCI series, targeting
>   submission by Tuesday/Wednesday before leaving for vacation.
> 
> * Versioning in Structure: Versioning is being moved out of the compatibility
>   string (which will remain a constant string like "pci") and into the first
>   field of the pci_ser structure. Because retrieve failures in the PCI core
>   are fatal and require a kernel panic to prevent memory corruption in
>   dependent subsystems (such as IOMMU), embedding the version in the struct
>   allows the kernel to reliably distinguish between missing FLB data and an
>   incompatible version.
> 
> * Reviews & Landing Strategy: Bjorn Helgaas provided review comments and
>   Reviewed-by tags on several patches, including feedback on structuring
>   and naming for the bus number preservation patch. David will reply to the
>   v7 cover letter to propose merging the initial series through the Live
>   Update tree due to dependencies in liveupdate/next.
> 
> ----->o-----
> VFIO Persistence
> 
> * VFIO v5/v6 Status: Vipin Sharma sent out VFIO v5 on July 14th and is
>   working on v6 to address review comments, targeting submission in 2-3
>   weeks.
> 
> * Lockdep Investigation: A lockdep warning reported during testing was
>   investigated and determined to be unrelated to Live Update (involving CPU
>   hotplug locks during boot group operations and ATS). Vipin will start a
>   separate mailing list thread with a reproducer to discuss the lockdep
>   issue independently so it does not block the VFIO series.
> 
> * Landing Strategy: Vipin requested guidance on the base tree for landing
>   initial VFIO patches. Pasha will reply on the cover letter thread to
>   initiate discussion with Alex Williamson and maintainers.
> 
> ----->o-----
> IOMMU Persistence
> 
> * IOMMU v4 Status: Samiullah Khawaja plans to post v4 this week. Changes
>   include lifecycle edge-case fixes identified by Sashiko, refactoring to
>   separate non-live-update functions, and adopting the constant compatibility
>   string with private struct versioning (matching PCI v8).
> 
> * Recoverable Error Retry Logic: Samiullah noted that retry logic for
>   recoverable errors is not required for Phase 1 and will be deferred until
>   needed by subsequent patch series.
> 
> * Dependency Ordering Documentation: In response to Pratyush's question
>   regarding file preservation ordering, Pasha and Samiullah reaffirmed that
>   LUO does not enforce a hardcoded preservation sequence. Any ordering
>   restrictions imposed by file handlers (e.g., preserving during preserve
>   rather than freeze) are strictly for optimization or immutability reasons.
>   Samiullah will explicitly document these guidelines in-tree. Future
>   evolution may only relax ordering requirements, never make them stricter.
> 
> ----->o-----
> KHO & LUO
> 
> * KHO Scratch Extension v4: Pratyush Yadav posted v4 of the KHO scratch
>   extension series on Friday. Feedback from Sashiko was primarily on
>   pre-existing issues; Pratyush aims to land the series in the current
>   merge window.
> 
> * LoongArch KHO Support: Pratyush followed up with the LoongArch developer
>   regarding boot protocol preferences and maintainer feedback; awaiting
>   further updates.
> 
> ----->o-----
> Guest Memory (guest_memfd) & HugeTLB
> 
> * guest_memfd v4 Status: Tarun Sahu is ready with v4 and plans to post it
>   this week. The update integrates negative tests, including verifying
>   allocation failures when guest_memfd is frozen during preservation and
>   ensuring guest_memfd without required flags is not preserved.
> 
> * IOMMU Interaction & Freezing: The group discussed how IOMMU DMA pinning
>   interacts with shared guest_memfd preservation. Unlike regular shmem/mmfd
>   where sealing prevents hole-punching (fallocate), guest_memfd currently
>   relies on freezing during preservation. The team agreed on a phased
>   approach:
>   1. Proceed with the current guest_memfd v4 series as-is (using freezing),
>      with a cover letter note clarifying that IOMMU support for guest_memfd
>      will be addressed in a later phase.
>   2. Pratyush will explore removing the freezing requirement for mmfd and
>      guest_memfd in favor of dynamic updates to serialization structures.
>   3. Implement IOMMU support for guest_memfd once the freezing/updating
>      model is finalized.
> 
> * HugeTLB: On hold pending landing of the extended scratch memory series
>   and removal of freezing.
> 
> ----->o-----
> Orphaned VMs & Development Environment
> 
> * Prototype & Repository: Pasha presented an update and demo on Orphaned VMs
>   (allowing VMs to survive host kexec/reboot without stopping vCPUs). He
>   published an open-source development environment repository:

What are all the features mentioned above? Are user-space out-of-kernel
tools included in scope?

> 
>   https://github.com/soleen/orphanvm

I cannot access this URL, as it returns a 404 error.

BRs
Chenghao
> 
> * NanoVM & Simics: The repository includes a lightweight C-based VMM
>   (nanovm) that demonstrates end-to-end live update across kexec. Pasha is
>   running it under Simics, which provides full hardware emulation of Intel
>   VTX virtualization instructions (unlike QEMU full emulation), booting the
>   host VM in ~6 seconds and nested guest VM in ~5 seconds (real time). This
>   provides a clean, bare-metal-like environment to study vCPU state and VM
>   exits during reboot.
> 
> ----->o-----
> Action Items & Next Steps
> 
> Pasha:
> * Reply on the VFIO cover letter thread regarding the landing tree strategy
>   with maintainers.
> * Coordinate with LPC KVM and Live Update microconference organizers regarding
>   track placement for Orphaned VM and guest_memfd topics.
> 
> David M:
> * Post PCI v8 series.
> * Reply to the PCI v7 cover letter proposing merging the initial series
>   through the Live Update tree.
> 
> Vipin:
> * Start a separate mailing list thread with a reproducer for the lockdep
>   issue independent of the VFIO live update series.
> * Continue work on VFIO v6.
> 
> Samiullah:
> * Post IOMMU v4 series.
> * Document in-tree guidelines for file preservation ordering dependencies
>   and optimization/immutability requirements.
> 
> Pratyush:
> * Follow up with LoongArch maintainers regarding KHO boot protocol support.
> * Submit LPC talk proposal to the KVM track and coordinate with organizers.
> * Continue work on removing freezing requirements for shmem/guest_memfd.
> 
> Tarun:
> * Post guest_memfd preservation v4 (including cover letter note regarding
>   future IOMMU support).
> 
> ----->o-----
> 
> Next meeting will be on Monday, August 10 at 8am PDT (UTC-7), everybody is
> welcome!
> 
> Join Here: https://meet.google.com/rjn-dmzu-hgq
> 
> Please let me know if you'd like to propose additional topics for
> discussion, thank you!
> 
> Best regards,
> Pasha

