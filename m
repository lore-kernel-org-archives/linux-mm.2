Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C68C44532
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D82B6B00DF; Wed, 22 Jul 2026 11:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B0136B00E0; Wed, 22 Jul 2026 11:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EDA56B00E4; Wed, 22 Jul 2026 11:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BB5B6B00DF
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:56:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E34BEA0218
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:56:16 +0000 (UTC)
X-FDA: 85016864352.06.47AE990
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0F211180007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:56:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=luqgxHZg;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784735775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uuu1Tu0mavyGTKCTNlz/UMSHBAzx4FGHXBKIVOkO5m8=;
	b=LzDvDnlXglxcZ0ZOsAMJZatzVboR0Zrn55/0Ccg6ZeMbSCJ4GKQRgpmXurlgPj3GKxyClg
	YeBiu1R2l2151ErnqjqGRygNuHLF+gR/qCbRtuJJy6APTZMfG5aXOzD6+efGHkfJ83RXj2
	MMyzEXu4ghXSeoDpQNbsQBoqr3wJZ4U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=luqgxHZg;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784735775;
	b=fP9s5o5hWPtTBzufT9Y8Fab7i7KpF2lRZ8a76hKVQxXA+zkpnvi0InTyvTg0h9DJy6tm4W
	RWJENUdRH6JZ4BfXqcQzPuojBu3QPvuJqH/9rxC3x3Cx73f41X721GIQqnlZQ10/cd1rcg
	cwBahRfTjsVNm5ls5doA/BZgnbRXFFs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36AA443941;
	Wed, 22 Jul 2026 15:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D547F1F000E9;
	Wed, 22 Jul 2026 15:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784735774;
	bh=uuu1Tu0mavyGTKCTNlz/UMSHBAzx4FGHXBKIVOkO5m8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=luqgxHZgCLrxH35q8K0hoG5fURY3wUyTXsoWg0QnmpHM71Q4GfoEZnLFZ7E43AtXW
	 R2csB6RpmM2d4Ky3zgHFJdkvuXaPl8zBu2PYmh5dA5DWe3lVLe8X13dG7V2JPIgUjI
	 dCvvi8VdDxSA+cR943rwpFJT6PLWwnU7WTs6TEl9/r0J7RI2hA6T4cZywp+Oz77ijd
	 6oX7iQyTXPEffMEIHWUpX/eNRbCJyRi757LlQJ0IgviZhqW6deQYHK61SS0xhOwwpp
	 yDaypsknrwAz6NFmfQgRJgy6QQ9c7/q5RdiZH4Ea/ir9U307CP3EvbEkHDX6xHJm6h
	 hZFLlsjKjNFYA==
Date: Wed, 22 Jul 2026 18:56:07 +0300
From: Mike Rapoport <rppt@kernel.org>
To: kexec@lists.infradead.org
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	David Matlack <dmatlack@google.com>,
	Alexander Graf <graf@amazon.com>,
	Steven Rostedt <rostedt@goodmis.org>, kvm@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE/CFP] LPC 2026 Live Update Microconference
Message-ID: <amDoFzbQVdxjgqzH@kernel.org>
References: <ahcc3Qyuy7Oy03Iq@plex>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ahcc3Qyuy7Oy03Iq@plex>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0F211180007
X-Stat-Signature: 7adjoxajd7h89nbancdgnpbjksosociw
X-HE-Tag: 1784735774-559050
X-HE-Meta: U2FsdGVkX1/2+J+tIZUX1/ZJtRSrxthNXlRI+ZiGW6YXqEbucIJ6JFLIaZoZh2k0/La+VFYszLsx7Yt26Bu50Cq6iOVVxnFCS8CALtGlHVcvItG893tNrk/axqPrPeXfqWpm5bRdfToQXDRNvO7SvNP7tGrgMUNY3g80e/K9xP24obFCG/Tbx46d0AdbsPaN5fQiPwE63iKbvtvymp/9kFTNlQXyoJtM8eTDs3DMS4/FZiQ7n619R9lvlp38NoLWMTkR/cUWsyztRTYIZRx8B2CI/Yw/qTgzxUXcfxcJGGRL2IsmMB3kp9k97uxRGTuug+EtCl3tm002FTKv8Jp/xytKhwXhlxDvmDqD3bmnvWfMEhkHdb76NAFQX0tdVv/WQLyxHPWTKta3gVV3MbUItHN04zQk1MgljR7VtfFrmQe3ctGyMmLPiR7UMeKQvgZreAUKra+cPFivUH/iWVhiHvx+cGnD+T8KjoG2k8Dkm+szdKUmOOrgvPGIkJco18SbL+XucJcOQwEB758SySI1n+YmTyX6fMbnZ6UlIQeEST0Qn/ulpr3tbXOZXWTFXaAEp241v543F+J5wqO6xUXMAhTxoRmLkcDSrlFv5j3vbF2HFoJqShP6cSv26cUH1qWa9Yn//ZGdZjsMxz3QOgC+JbMQwKAFN1crexuM7rgwSGHYLy3FuDbDui87IaBWkSLPIJqz7MS4HqODoldfACR/ej26WMHZ1d/ODvzzDu+wr9hFwgx0BOFze4dLdkXIjUA+YM2HWrefAoI0YV5qDFK8InWVuZ+t+RkhItCgJDTMLNFLhUjaGnmSOlAf+2FrjEZ5/UqJf5wU6xbPIL/yCy1oul6wq4BE6YEbVy3oRz+ecCkWgo5mYJN0rfN5X9ErjERvBDeeGpQXYo1iSOkeXVNb9UMew4YGXceLNZK5CsRpFNa9izff/sbcXDx8OKD1SPjSZDIp8s85/trq6OgTWJj
 bBVbntAO
 a3duU54tzuG6be01QhbOCZQL97WnMbUJibq8gc24CZSay848yqD/kAEUk8zMu12aPSibks2znCyMcdkidsY3BBltu4UN1vujGAcq6AWBT7v4wsxlVkkCVniTk6/tkFXVRU9NivMyjhZTVISfSj7sGAZB+L0faHr0g67L/mTM2Oa6Uwm9iXrcGOTQ/laNI8rYzuVSUx7Uf29sWlKzE2NBoAph1N5ClhmjvVkcv0b5Ihh+95GJ/crjrWQuX0Y9VKKdz5t/CqGTToiKPng0iYIeigq2t5ZcoX0My+mQR+9t7EbAiWdeucJGPPDicsApvnf+3HS2Gc4nd+VEZ2KKHw6zaE1pjNM37sqM/75YjeSQe5KA18Mo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This is a reminder that the CFP for Live Update microconference at Linux
Plumbers Conference is still open and even extended until August 7th.

On Wed, May 27, 2026 at 05:05:23PM +0000, Pasha Tatashin wrote:
> Hi,
> 
> The Call for Proposals is now open for the Live Update Microconference 
> [1], taking place at the Linux Plumbers Conference this October 5-7 in 
> Prague [2].
> 
> As infrastructure scales, minimizing workload disruption during host 
> updates has become a critical operational requirement. This 
> microconference focuses on the evolving engineering challenges behind 
> seamless software handovers, state preservation, and warm reboots that 
> bypass traditional hardware reset cycles.
> 
> We are seeking technical presentations, and problem statements spanning 
> the entire stack—including kexec optimizations, hypervisor integration, 
> user-space checkpoint/restore, firmware coordination, and device state 
> handovers.
> 
> ---
> A few focus areas we hope to cover during this year's sessions include:
> ---
>  * Orphaned Virtual Machine for zer-downtime upgrades.
>  * Live Update Orchestrator (LUO) enhancements and architecture
>  * Kexec HandOver (KHO) framework advancements
>  * Kexec reboot latencies to minimize guest/workload downtime
>  * Preserving guest states across live updates (guest_memfd, hugetlb)
>  * In-flight DMA, IOMMU tracking, and preservation
>  * VFIO device state preservation and live update migration mechanics
>  * PCI/PCIe device handovers, reset avoidance, and state restoration
>  * Live Update in Confidential Computing (TDX/SEV-SNP)
>  * Building robust testing, fuzzing, and validation frameworks for 
>    upgrade paths
> 
> ---
> Submission Details & Deadlines:
> ---
>  * CFP Portal: https://lpc.events/event/20/abstracts/
>  * Track Selection: "Live Update MC"
>  * Deadline: July 24th, 2026
> 
> Session Format Reminder:
> LPC sessions are highly interactive working groups, not static lecture 
> slots. Proposals should be designed to introduce a concrete technical 
> challenge quickly and leave substantial time open for real-time debate, 
> consensus-building, and problem-solving with the room. Keep slides 
> focused on architecture and open issues rather than heavy text blocks.
> 
> We hope to see you in Prague to help push the live update ecosystem 
> forward.
> 
> (Note: LPC attendance caps fill up exceptionally fast. We strongly 
> advise booking your passes early, as track organizers cannot always 
> guarantee speaker registration overrides once the event sells out.)
> 
> [1] https://lpc.events/event/20/contributions/2321/
> [2] https://lpc.events/
> 
> Best regards,
> Pasha

-- 
Sincerely yours,
Mike.

