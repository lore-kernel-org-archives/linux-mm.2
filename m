Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADD0CC531E4
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 04:10:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE6256B0089; Thu, 19 Feb 2026 23:10:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73736B008A; Thu, 19 Feb 2026 23:10:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7F8A6B008C; Thu, 19 Feb 2026 23:10:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 945A36B0089
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:10:34 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1DE648CB1E
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:10:34 +0000 (UTC)
X-FDA: 84463508388.14.E80FE2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7EE1E140005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:10:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kTtK5AKZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771560632; a=rsa-sha256;
	cv=none;
	b=2N0CBHvSsvr/fFtHPih27FptpOSeNwWgSjUsT3dKbZ8n8KsQISgZCLL4lR5l00SbzdvHkA
	YSLewDrsVOaTwuA1lslsLX+92V8W91WV/2nrEbtz3BnXTDLFn1vXVpu9pk3dmFnQhZIyhS
	Ya8gMKuuXRViVP3VYK5uGIR6ro+U3iM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kTtK5AKZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771560632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QmGz/nz89BPlHPn/CEPU0KsA77OiPdkRUGBt8Jxsdoo=;
	b=XHvcVNgm0LTiJ7c/ZVlNIX2gFcBQ3Lzts+opuxd7YJitRqk9p13fGE0M8UQ0lXUWdhOt5L
	ILO2ZXWuQw2X3hs77EDRo9el1nYh2G3njPuBNnEAiFpTOloHqFG79CHSqVoCjNuhUbMYPa
	eqvpAIoaSVUzPPnLdSXMHX4XWAknOmM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 84F376184E;
	Fri, 20 Feb 2026 04:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267C4C19421;
	Fri, 20 Feb 2026 04:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771560631;
	bh=YLLAbyGm0F9m0Mypc3ideA8QOvIO6kTmhd+3yWxkaE4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=kTtK5AKZ1RD3Hd+Qxzib1YAeeESOC+72wxWtnIJN6iDEVUEIY7Rxl2ePuPiN/V5o/
	 k+rZIs9FvLnPIxPUWEwmtTWZePyqnygsvQ/oRArPOSMUQehN9ZmGNPzN/htt5J58Ai
	 qcfxI2WQy0ULly43wzvW5aObYdstSnWi5aOFUekprwhQS9sIRFzYU9aMBGM2c3HeI2
	 Zee+wtGMbpNJzghQBk7w0eK0VIxBPrxD2SptGPil48nFuUCxTHwCt5C3MokQ+6Oo4M
	 NnfGIuud5nhQXgIazdRPxlu5zrkOUi0ojKCNfxJMh6pEIcV6UUhN2bIxI3/yprxCQG
	 neCFLK/sxgU3A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9EF73809A88;
	Fri, 20 Feb 2026 04:10:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v18 00/12] Support page table check on PowerPC
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177156063929.189817.18154815738132303149.git-patchwork-notify@kernel.org>
Date: Fri, 20 Feb 2026 04:10:39 +0000
References: 
 <20251219-pgtable_check_v18rebase-v18-0-755bc151a50b@linux.ibm.com>
In-Reply-To: 
 <20251219-pgtable_check_v18rebase-v18-0-755bc151a50b@linux.ibm.com>
To: Andrew Donnellan <ajd@linux.ibm.com>
Cc: linux-riscv@lists.infradead.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, pasha.tatashin@soleen.com,
 akpm@linux-foundation.org, maddy@linux.ibm.com, npiggin@gmail.com,
 rmclure@nvidia.com, chleroy@kernel.org, alex@ghiti.fr, x86@kernel.org,
 nicholas@linux.ibm.com, sweettea-kernel@dorminy.me,
 andrew+kernel@donnellan.id.au, ssrish@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Stat-Signature: cd41ypa8jpisxa6ifukoqw5bb8m6xdnm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7EE1E140005
X-HE-Tag: 1771560632-706435
X-HE-Meta: U2FsdGVkX186w6jbvAEFlprOzVxtz6Vb00/l3HymhqmBu9g54nE0JDk3wuPCsBi/xK4oMX3S9flAf5K4lFgGc3h8vnm2dt617OwJ590T8p9oqpmKh4tqCKTuFZic50H+HlRJ47bQlAjw/5w6G7m/0V2m3nOmMdjerIPB7EiZrXL9wDtu4YBEBWz6VvaLqj+bv6t5ytnelJ7m2qpTQr4O8yksdMDGLe733bvvYp8W8cnksv+9gBaq5Jiqptms5HYKRMPOQ61gsBezaI6Tj9GdQrggVgORkc2RDqofs/thIfQadVo2VUyBCAtAM8VLK6af/0yuBDqupzjHPv5IO0IJVuBQG9gcNSK6UEhtp3shY4firKvZP+20TO1xt9Yrim01zk3/pVjcQodC2832kl3daxYABzsAEPeJyuZeRr/l28W42N/F4P/4NxIz5k7qoHuWf/CHcXRdtaiSbIM9gLEKcR6J06O5LzJopdasm0aL1KRzZ4CHkJnBeYWhin7YE+5CmnyJ4CE9pJlupT+ga0x8Epj5+VHKJDh0reXFeMG9WaULxUIvmEEC6dymoqG7wueV8UGsUYhgPklJihQyKU4+lpp0JncPoNpxQYEPB6NszRkSBswAUXLkAd97DXXGIWtaxb8yhDz/2FfFZO4gZ+L0biUAn7Bd7TGY5Q1a4byseoIl9Czwpgktw30I3gb+SJ55Q18W4Rsi/zda9lb9pzEKFhszXY3sIyremT/IuYUp/tdxMzHkm037bkrx84TkE842GeG3wcBlEQqmbms10+cT5uRwFzTmeluebQ8wJxHoDX5Ia6Ha0rVehqWPFuqADPPNCihXwGHlJNAWKeGZwKasjKEQW5UhK+4Eibjd9ujM3Fb95taSDbocvMOiV10VJoZJzWhlHGQSPpwbzzSrcjvWrTqlJkBIZuxG9XlR65qP3c0CqImp44MXnW0TtsW7Jbbt+r8OEXLTVuGOKYkApbk
 r4Jvqcig
 3bRsJQsjkZCNR0CkBZdly6WavYpnp3+8dqAIr5pPPDGUsnjNFiXhVLoaDuCllbXrWkHa4fl78uPXVO0xWhq245U5D8BCohw8R6PFvWe8yCEBGl7a0pPYLl9T0BpBAJadN0mqIdSI9TY7kZiFHwtmvEOzJH54AbFTpRK6DLZAdsB03kZKrTyW5Zeoh7kXnDlD08CaWESbbHzqNgrFdNQlba0HHtDgICcC1TgJa5FO/Q2QHfU+RDL6gv708E/O4YuuhBXH5Swkv3Ucac2VVAxYlrl2Uegd7gdDlntwG5YqU6XOIVVu92SRumdX3OOSTg82v3aIqzRoTgS31Q6brhSPlI+v68wDACKbHQUEwzei9gGNBUU6pCVEusX4Y65CGXOMFKTerx3163rlCgrtqCZomUM+erDTsoAl9zPpdfEQ6r0rKK9FpDi2OZnAAv2S+Z3QrW3q+wIVob333xmMLI+p3IvYiL8Lbirgsc0Ys81HgA/9blNX3jh8Bw24pUMyyT9AOE+Vw
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

On Fri, 19 Dec 2025 04:09:32 +1100 you wrote:
> [I will be leaving IBM in about a month from now, and will also be on leave
> for most of that time starting tomorrow. I've cc'd my personal email, which
> I am going to use for any kernel development I do after I leave, and also
> Srish Srinivasan, who will be taking over some of my work.]
> 
> Support page table check on PowerPC. Page table check tracks the usage of
> of page table entries at each level to ensure that anonymous mappings have
> at most one writable consumer, and likewise that file-backed mappings are
> not simultaneously also anonymous mappings.
> 
> [...]

Here is the summary with links:
  - [v18,01/12] arm64/mm: Add addr parameter to __set_ptes_anysz()
    https://git.kernel.org/riscv/c/9ac4941aceb0
  - [v18,02/12] arm64/mm: Add addr parameter to __ptep_get_and_clear_anysz()
    https://git.kernel.org/riscv/c/ee329c29fde8
  - [v18,03/12] mm/page_table_check: Reinstate address parameter in [__]page_table_check_pud[s]_set()
    https://git.kernel.org/riscv/c/c4a0c5ff85b7
  - [v18,04/12] mm/page_table_check: Reinstate address parameter in [__]page_table_check_pmd[s]_set()
    https://git.kernel.org/riscv/c/6e2d8f9fc4ed
  - [v18,05/12] mm/page_table_check: Provide addr parameter to page_table_check_ptes_set()
    https://git.kernel.org/riscv/c/0a5ae4483177
  - [v18,06/12] mm/page_table_check: Reinstate address parameter in [__]page_table_check_pud_clear()
    https://git.kernel.org/riscv/c/2e6ac078ce5d
  - [v18,07/12] mm/page_table_check: Reinstate address parameter in [__]page_table_check_pmd_clear()
    (no matching commit)
  - [v18,08/12] mm/page_table_check: Reinstate address parameter in [__]page_table_check_pte_clear()
    (no matching commit)
  - [v18,09/12] mm: Provide address parameter to p{te,md,ud}_user_accessible_page()
    https://git.kernel.org/riscv/c/d79f9c9cf703
  - [v18,10/12] powerpc/mm: Implement *_user_accessible_page() for ptes
    https://git.kernel.org/riscv/c/2f5e576598c9
  - [v18,11/12] powerpc/mm: Use set_pte_at_unchecked() for internal usages
    https://git.kernel.org/riscv/c/2360f523a49b
  - [v18,12/12] powerpc/mm: Support page table check
    https://git.kernel.org/riscv/c/641d47d4c963

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



