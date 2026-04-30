Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF22ECD13D9
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52AEA6B00BE; Wed, 29 Apr 2026 23:26:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B65E6B00BF; Wed, 29 Apr 2026 23:26:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C8A6B00C0; Wed, 29 Apr 2026 23:26:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 207F66B00BE
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E26FBA031D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:55 +0000 (UTC)
X-FDA: 84713785590.16.BC0254C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 29B8720009
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yxx8M2cZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=icMT7CFKhgxWAkB9/aWQ2VEfcgaI/KuH9G4xtfFNj1k=;
	b=t8sN4sx09YDlF9aDz3mw7AouhLPyc4InZaB2jN4VgMEKN+lB6E1qZYx0aC2haQDChdlVWy
	o3mQB7tpqPOYAmzTiHQ6I+owSY7hGvyOuBWXC+EEpcm/ZeKWYbQXseI4DRP96tok7aLhM4
	KFe4Xp3Tl8EiDN8/zmdtNBSufxawhTw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519614; a=rsa-sha256;
	cv=none;
	b=mLxbBSO40pwKiCs6fVx6ituYRGQZ8+87+XEWBG/hbRxUf44S+QP20FMFHVnU9Mo85uV+rb
	VUWbn3O54wHdBAmWt369nCXnYLrJyjLhkALWhl6A379FgkKcAEZZGAQe7FzH3EWwOEDnxM
	91YRI92SfWH9tUuK1YVNMXtHHon1m0g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yxx8M2cZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B076438E4;
	Thu, 30 Apr 2026 03:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADBFC2BCB8;
	Thu, 30 Apr 2026 03:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519612;
	bh=1y/qx12Do8kjGRWa26585Z3zhVAR8s9S7MLftzRNkxc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Yxx8M2cZdErYh+yTRb4JYMX8n1xNToXdqoarYlzvZ+VJICM0/uJ3iKDXLNPcQGnRA
	 H8JIZj/nbbFvJXlTP9rWLNIO6QshmFfKvvU6zFT0LGw+HDcOhs2jTIA7HlayOm+BjJ
	 l8dQuieDdBsxH/orRnJnvut7oa8qxmGhcBxqkYKXiYlXBhlzr2TDj3n3VHNazWuaBZ
	 hEks0+SfUJmmVmm8mQuI5NIPiY9XYGr5RP3vTjFgNfu+nr8cJ5r2000NO381toN5VY
	 Duo2QjuhrvCx7cz7cRqnzsz5bSojfgxGn1cgcZYUy76sYJ9bjKOeYDGE6A+KGk2zK4
	 ipDtjb+awhKqw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FD4A3809A07;
	Thu, 30 Apr 2026 03:26:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 00/22] riscv: Memory type control for platforms with
 physical memory aliases
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751956779.2274119.16366589478749649607.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:26:07 +0000
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
To: Samuel Holland <samuel.holland@sifive.com>
Cc: linux-riscv@lists.infradead.org, palmer@dabbelt.com, pjw@kernel.org,
 akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
 devicetree@vger.kernel.org, surenb@google.com, linux-kernel@vger.kernel.org,
 rppt@kernel.org, mhocko@suse.com, conor@kernel.org,
 lorenzo.stoakes@oracle.com, krzk+dt@kernel.org, alex@ghiti.fr,
 kernel@esmil.dk, robh+dt@kernel.org, vbabka@suse.cz, Liam.Howlett@oracle.com,
 apw@canonical.com, dwaipayanray1@gmail.com, joe@perches.com,
 Julia.Lawall@inria.fr, lukas.bulwahn@gmail.com, nicolas.palix@imag.fr
X-Rspam-User: 
X-Rspamd-Queue-Id: 29B8720009
X-Rspamd-Server: rspam04
X-Stat-Signature: jzsfdjc91gdi68d7ani13r11s4dpoqxm
X-HE-Tag: 1777519613-7575
X-HE-Meta: U2FsdGVkX1+5qo7VGcxavvZ8PZDl1/A8y8Ml7qQc72H85DdzcbQ/5mJepn8Tusp/wha0FiLepmBHOLdmyhkGXDDw8S8KIazGocmRDxHBzLOPVnPU5uY5/crdg3GBV7fFhGWYWABjriWOmDOfRnjuSyt3gt7B+ZPQZpDRNTKL+eFmuuJ/XrjYblrJ9923sWPY3A4uuyzhNFSclMxQcNdMEKnzM2V76VFPl6kG96KNYHhWnQDXxDl7wk+VWUloS59BJxjpv/yG55L89FD85h6gbUb3kIunVGcE7Ntf8KVQKGLXrAmvXAuieUbALOsKDVGuu9W4Et6mUkouUsMIGQlYdhu6dYpu8U75QCjSMxsn2HXG2WqfJai33+naQr7KfLDAcmDzK90+lf8NjIRZ+cb1ibJB1mUrCB69nuyU8vXQ02A+wkiYosYk1THJoSAMvIzFr6LDEednwkuDJejVV5erMbzjSe3uGtNZs+ABpmaeFkgW9/jx27/zrQ7SfwvGSaivoR4U+HGec8tNc4pjjTNNhEoetc3j990YF4lcG4VAbWiXIfLpMKDKf43RgpQJJCuLi7ZE27ak+/Gv7i56sqqh0VCATpLYi95K1FawDWj3WQ73bvPMhqxERhHrg6dix+DFaRTYYOWia/kH+oW3I6PteAlRlxzl8Ay7z7jk1rbHQ2Bgr4b+g/Wv1gXeUKR1hdEmcmrz79RON3VJfwZAjtAg505vpEegNp+7eAZPtfamR8tJXyHxTvggBu1kthG2ghzlfvb06VJJLXeaaDmzYFds4K6Gw+zhK7s9y4I4GeYLRKIjJejIJDK4ey3lkrT4605y6WgFkuKLX8PYw63Mq1O8jH4b8PLTDWalpgZDNnNwZM4etQcLCSlU2XlyUik2FeH+zs7uYd/RaBEiETQC6zKTDmk4LWE0Zfpjl+OoP9PGckrBnAAtXq2nEWA4gTmpHeevrwt2idl3ymciEux2PUA
 uzF54/yv
 3t0xF3Vi7LUi4wjHxl/V/gZF3ckm0JCoNhBxUOzgcfzI9hzyo1gzBFRr/KmQ9sgepFFeb4vgPosEnKQ6rtBOpXZHPfvSLPVBSfgWra85IAWWWTheT3YTABFyJQHrokVcYEWDd5UP4qF2MyVTy9pocpj5xBWSTJ5SQU5s3gbsSWODxLEUjrXoB0+Zo/WZPd4Wa103IRcd3ODya+aX7WXQr5cqqCv6ZEk5EE6vavndOlnfSfEuvLj+xw9gBj7vwwUV3XRP0bVrgWq7imPJS+T4uzzjXf19UJugqm0b0IKDcT67RdzE1Hv0yQcrWkylNeAFJlgR5C4wkui0MsBe7HaWUMqiY0XAQQGEmoSf/BGEoZ01atAztSW6WcMaZZwZDTQd4KO1yPW7eqVTCMNzTCto9fFQQ8skZhlYeFDk35CjgxDue5agSnlkNEOPzGSkXUZUnZQ+UYaQWCH1vRLyLlfu7mtE6lWOxHb691xWX8tdxGXMRWlFzr4EzZXs+tUg9uKU3yl0X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to riscv/linux.git (fixes)
by Peter Zijlstra <peterz@infradead.org>:

On Wed, 12 Nov 2025 17:45:13 -0800 you wrote:
> On some RISC-V platforms, including StarFive JH7100 and ESWIN EIC7700,
> DRAM is mapped to multiple physical address ranges, with each alias
> having a different set of statically-determined Physical Memory
> Attributes (PMAs), such as cacheability. Software can alter the PMAs for
> a page by selecting a PFN from the corresponding physical address range.
> On these platforms, this is the only way to allocate noncached memory
> for use with noncoherent DMA.
> 
> [...]

Here is the summary with links:
  - [v3,01/22] mm/ptdump: replace READ_ONCE() with standard page table accessors
    (no matching commit)
  - [v3,02/22] mm: replace READ_ONCE() with standard page table accessors
    (no matching commit)
  - [v3,03/22] mm/dirty: replace READ_ONCE() with pudp_get()
    (no matching commit)
  - [v3,04/22] perf/events: replace READ_ONCE() with standard page table accessors
    https://git.kernel.org/riscv/c/5a84b600050c
  - [v3,05/22] mm: Move the fallback definitions of pXXp_get()
    (no matching commit)
  - [v3,06/22] mm: Always use page table accessor functions
    (no matching commit)
  - [v3,07/22] checkpatch: Warn on page table access without accessors
    (no matching commit)
  - [v3,08/22] mm: Allow page table accessors to be non-idempotent
    (no matching commit)
  - [v3,09/22] riscv: hibernate: Replace open-coded pXXp_get()
    (no matching commit)
  - [v3,10/22] riscv: mm: Always use page table accessor functions
    (no matching commit)
  - [v3,11/22] riscv: mm: Simplify set_p4d() and set_pgd()
    (no matching commit)
  - [v3,12/22] riscv: mm: Deduplicate _PAGE_CHG_MASK definition
    (no matching commit)
  - [v3,13/22] riscv: ptdump: Only show N and MT bits when enabled in the kernel
    (no matching commit)
  - [v3,14/22] riscv: mm: Fix up memory types when writing page tables
    (no matching commit)
  - [v3,15/22] riscv: mm: Expose all page table bits to assembly code
    (no matching commit)
  - [v3,16/22] riscv: alternative: Add an ALTERNATIVE_3 macro
    (no matching commit)
  - [v3,17/22] riscv: alternative: Allow calls with alternate link registers
    (no matching commit)
  - [v3,18/22] riscv: Fix logic for selecting DMA_DIRECT_REMAP
    (no matching commit)
  - [v3,19/22] dt-bindings: riscv: Describe physical memory regions
    (no matching commit)
  - [v3,20/22] riscv: mm: Use physical memory aliases to apply PMAs
    (no matching commit)
  - [v3,21/22] riscv: dts: starfive: jh7100: Use physical memory ranges for DMA
    (no matching commit)
  - [v3,22/22] riscv: dts: eswin: eic7700: Use physical memory ranges for DMA
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



