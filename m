Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B497FD74964
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 260916B008A; Fri, 19 Dec 2025 03:13:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2756B008C; Fri, 19 Dec 2025 03:13:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D036B0092; Fri, 19 Dec 2025 03:13:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F39866B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:13:15 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8876AC0600
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:13:15 +0000 (UTC)
X-FDA: 84235505550.08.2EEFA38
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id EDCC94000D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:13:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p89JPvBN;
	spf=pass (imf04.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766131993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JbLLpyM3ayapy/UsfZJST95cLNuEfK4YIp6V+IT3Lsc=;
	b=ZLL35832HwP9rJkiVzyt0gms/DD/h9Nnc9p1CtUJkJvSLSRkgduFjonkz9pH843Fg+OcZ3
	2V8pF+DaaxdbXx9qIwcZrCGZxx7QrR2J0vPPbGQDB5bO9HxRS4Z/kMrl92YOdtSiX3LadX
	60eop/+kwQULVTYv3Iay5qbeBi3+ha4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p89JPvBN;
	spf=pass (imf04.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766131994; a=rsa-sha256;
	cv=none;
	b=M9x7M5qZ88fb32boNlQk3RgPPo54e8fAavKT/DPB3DDtpsyWS3NEemWXtsoeU+1bwbCqBx
	gHaqDUIc1wyeFsvinaHhMApV2tayFiGXQU/T8EC1hJtfC/OLVc5by9EU6Q9MVCdGvaAMYu
	W6oNVMCWf7P3XbOSjelpD1EHldQISN8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1507060125;
	Fri, 19 Dec 2025 08:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6E1C4CEF1;
	Fri, 19 Dec 2025 08:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766131992;
	bh=+A23adoC9TayllzNX6/T+neHMWZRAShmj4hgCmrmgJ4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=p89JPvBNTfp1Zxaf6AHlXPUAW5vH+0h/aZBWlIuoc8rpJoH+z3qETdxMxuFJAV6k7
	 amnpVXf6MZnK9NgXMRyK02DHNlLTm9j0h7DawEXTIpuZXjAZYo4vvcWq5huGMRsQPE
	 mtOfS164rBVpeq7K9IWV1kqWnbV0UyCNdUO7eYnA9/AFYIn+lY6r8/UfQ3lncDahyR
	 RL4Txwr0Cuo9wikDA271JZSSCweDDkIMAvfxGNY5ZYTQ+ImUbEPxYAz6Ca9qcSQC37
	 PKnkuVb8wyAiMT/frsE2y4GUuxmeZ6cqN8jbYtjxbXpYApAc3Nwlw7e2vh9rlhpZW7
	 hhT3fx+FdWTWQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F3393380AA50;
	Fri, 19 Dec 2025 08:10:02 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 00/22] riscv: Memory type control for platforms with
 physical memory aliases
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <176613180179.3684357.1299267450443574866.git-patchwork-notify@kernel.org>
Date: Fri, 19 Dec 2025 08:10:01 +0000
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EDCC94000D
X-Stat-Signature: 1b17e9h53xp1mzsaopuq41a45uu4cnos
X-HE-Tag: 1766131993-336503
X-HE-Meta: U2FsdGVkX1/zZG14mlcB5tgWkjSYlRGmyRRv1Vj0H7QI+xd6YdyeQD857XTWqf5JFjGbSMB4aMl98X1/Goe9PF2v70x8IaDGJZm8bM/ghx62XEgh6qXnLBW1mwu+FI5ChjCIjsQRUAHfhTny7f2HKsYkPFdAqpLSYH/cKs1GVzO4NOFAHtAnBvz5W7jm9nOiaXXvGmLPs0PaEBNxxE2FRT/Si8+IEIiIvr6dgTQtnjFpPPGRnpR395dvoQn5nWRozwlAmsVOCNhJw/So2JrGMYRpAHpBXOgJgKpaKTVlBclXGyJjAmjUfYM345HqlMi2lqdgZkKeugtW0pWjkyiYDtKd4RERFdBeEfumZ3ZgZ2LjNDjmmHddLdJNk4PT3y9vyjZFyThTm1hUoFAw1nldWJS4/AmCKesWxddHIebNZc4Tad4PiEczEQBoNRmt/WUvASguL2PbRrGmq3lZg7GaeUIBGXjPJGXAGAIxTpLKQM6HPn/mjjUpjtt6CMjr5KZ6mIm2ME/WnlL2Fm48JFXHhSpHolcmB3UYusLAiQdKPbuRMy1gvM8XcqIaqZrsmJ3LvcCRIae8g7lkQA7/XYmZ/3BhLLzdA6/2wd6vhOMXaCzV0DQ9oCvFKxM5GWsy3keP4578kQYHNTwros4BSIIq1WuGoL7XbgcXFr8jFeSqHcHHPnSOqfjefKnfOBAmxjkkNMrdGHpUmUAYbeftqShQ3A8RVwrzVEJDzRZAMj4smfpqbm3tq766iT/rXSr3bcfI/TdKwZwDXkcX0A/z/X8LZlzAMn6KW+3KOPZXZ3Hky/2ZS8hcNJP01hVNUMFnMwdHX3VX0FtvGTk62pgTDrPmC7JPLhfwkoXpg2jz8OEjiCbQ0wzqCM5dDKcs3nkSO/+YtxExmA6Z5QzEv/xEesSvsnb9Ah+ABN93CsvKLd8vg6MxTydCL7LksfZi3sUXtf86AwUKa9pgT7967egvWA0
 nr1etdpY
 OX1SpWiX60Kw42KxNZwlzaJ3kGIk3+m+4UeIIe+P5pX5JHiSzw6tgLI9vR6REN2B8hMlaLKgB9OdH/PBIlaDCLVEM8Ej2/CM9FjdM+qAFg7HeNq7Rm2qgmLwjvLsYL0yNlyrE7jQSvlNNzRbZBXJ3Zf1TxMMCgKTLhLUnX49yqqxclvy3kpPzYifuzTF3wLuJSSObw3wvgZmNBEGGpgsGl0ktpEFSshQ3ejNXOwBgDYH6kz/9rlXYDC+YEIP/WT5go7C8zVcdvcBDtfSHQOXg6szf+8hpauE1giLAfN1kmRvl1GVPotIrVcvoNxw77Cr/JVu+vLnPeoai1XzGKV6eMeGnBml+62LjSJhzrZE28cjlqdIkhZaYmUwqLlhYB+2cYbnOQCnHq2eN8xoh55Xv1+rHeqjrjfc1Emq8qvTvWTWr+F/38pYYiexAxlWNup7vTyccfV8RB4s0jYnKjAjX/oEIhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

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
    https://git.kernel.org/riscv/c/11119b19f62d
  - [v3,02/22] mm: replace READ_ONCE() with standard page table accessors
    https://git.kernel.org/riscv/c/c0efdb373c3a
  - [v3,03/22] mm/dirty: replace READ_ONCE() with pudp_get()
    https://git.kernel.org/riscv/c/b4e53984f240
  - [v3,04/22] perf/events: replace READ_ONCE() with standard page table accessors
    (no matching commit)
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



