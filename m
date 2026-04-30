Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDF73FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63AEB6B008C; Wed, 29 Apr 2026 23:26:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 613366B0092; Wed, 29 Apr 2026 23:26:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528646B0093; Wed, 29 Apr 2026 23:26:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 43A286B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB0901B98E7
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:25:59 +0000 (UTC)
X-FDA: 84713783238.01.FF9AA80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4F1A8C0005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:25:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PvM8my1I;
	spf=pass (imf22.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LXhOAcmYnCD9USewCHVAQkUCf2Ty94DfND3RLOI2CXo=;
	b=3TXxDsAkn5XUQz+MqJpk0O0stGr4Mfz/b5uj3FAYvik8lBC781eGkxEE5Y2xd7RscutGz6
	nouMM2FLOZCn0DUgvcWFrFhussmIdP9gH4ISQ63hlb7I2ITeIomr/ij5sf143zFUKHOdhl
	hUzfei67EHQasIBjbKXFj/T3pgKAbUc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519558; a=rsa-sha256;
	cv=none;
	b=o8tPLTFXyD2cMEMuhr8Xe53+N0KEtRvOCHr4oFUpKORDrd4q4RjWIN/3UgN8HgjHQBw24K
	lX7SqTeBP5E8Tu/qYe4L0zBUXuFLokdSLW4rOwdahHAQ3mLfaKIGN6Jtk1fr8YuJXfHA1Q
	QWqSmKjLZ5Bvd/30jBN4YIrtpqHjedc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PvM8my1I;
	spf=pass (imf22.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 83710444C0;
	Thu, 30 Apr 2026 03:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662B9C2BCB8;
	Thu, 30 Apr 2026 03:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519557;
	bh=3A9sSPpTFnTSwNLnH2RiVekzHJbPnUK+mXyDzY4bjyk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=PvM8my1IW2Yjwupoq66vKLJIr1YZ/KioPkhJQkE7eo14dAk8o2H6RNfUatGZ2Au9S
	 91HQM/8YvYPRiw98kHgqVpZmSf7VnKX3GtzG7tbbozHcDgaRlvxBU0lZAMm+aj7cPh
	 qT6q1tde0FqSYSPt0N2fidtUIF1aUhoMl4reQhuruOMGgj3cRRvZeoBRiI4AEgorg0
	 StaKda1S6UYGl5kKlqXb2yBN8WQ8cq7wMowo/Uy/ler0ew/dVewdsp0hCgMvA54aza
	 CunUoeLgN5/VA34GkpqJiUE2zYwO5PBQl4g1nYfrAsGa+cekkOMHiB31Rm0HDxSQeo
	 il5OF8PZWn6WQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA3583809A07;
	Thu, 30 Apr 2026 03:25:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7 16/18] mm: Remove the branch from compound_head()
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751951229.2274119.12563342067361093997.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:12 +0000
References: <20260227193030.272078-16-kas@kernel.org>
In-Reply-To: <20260227193030.272078-16-kas@kernel.org>
To: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 muchun.song@linux.dev, david@redhat.com, willy@infradead.org,
 usamaarif642@gmail.com, fvdl@google.com, osalvador@suse.de, rppt@kernel.org,
 vbabka@suse.cz, lorenzo.stoakes@oracle.com, ziy@nvidia.com, bhe@redhat.com,
 mhocko@suse.com, hannes@cmpxchg.org, corbet@lwn.net, chenhuacai@kernel.org,
 kernel@xen0n.name, palmer@dabbelt.com, paul.walmsley@sifive.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, david@kernel.org
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4F1A8C0005
X-Stat-Signature: ok5curt5c3s6mmnicojp3r1q8cwbbgxw
X-Rspam-User: 
X-HE-Tag: 1777519558-414783
X-HE-Meta: U2FsdGVkX1+9ppEgqoUyaBysokWWQluI9eUauiFDroxO+rrAgV/MSrI1qovPLVWc0i9y+K7AKth7k7c1/Gdaa//b0t2klv6QqO6axCjhljQ0av+GcPGpakCOiops1XmqrZx/MBo2Il6ar2Ld7ZjhQkx5OmDSXlkYwGLB6TUe+d63yYz28hluQdlKcA9GWAUinN6ftov0YIK6hwMjtVrU8JI0jTz9Ht/Dm8lietSEFGz++U5jmtdhlcFcu+uwUAnPmt9PMnkBjA3J6ionj+TVqsTusG+0u6K7yDeOXLDqYw7IcoIY+4V2G6LN758huT5Kr+4AdiiX//F0KKktgmlbGaS0LkyN58DNTtx11eJ5+vgGbyEw8LWbaeRkSWl4VAtFzFSop6R5wrfcxuHahiCsgIV+afyrCtqMtcgVE7DvU4dDjGl5N19V9JRSkbdlqBxoHSk52LYiMhKqct4p90nWJypdAJAjpC/DKBUi+pQK1De9JkFJkE2c9o/tj3tWugdlFPb90Z0+ZXkZ0Txu48z9ySp8UiDCpASUf8Z+1fsURmIAmrimwt8iRuvZy1F8szd1Qtu7LXNR2EtfP8+wD1QRgsxati3ebSuYsuYhrn6MO474OIPxnQCa+kCMzhfHzOKBTO5qosya73gT8YXlg2cMdWpYtjIY5QsNvizN5sAGRO7rpCwDsfOHqA0kn3RYD2hgYj0V/x4MtCjOvlEn0TE7B4yRow/2mgRHq39c/3wq7ZmGsHvVm9jTVR5xUFunWGWavE8stP/HWErD5g4Y46BCiHA60/+npOQF+IV2ADDsvBXJs0t4QL2NpufOBdh6ZILszYjDZqH+tz4i3a7FPTO6HbkMSx9qN17B4erHnuRhW/QgPpmQUcEdMNlkFzEl4rag67f/4j+GP/gzm3X9xKj1Tj+izhbfRH9sbI7Wj4yrUza+AShqb2FZA+5BrY+UFjLqgU2oniIBO2kQQq+mpix
 7voMbMyO
 eynp9Fr4h+ZcQ3nqWNcdR5fOFOa24JcqJTQLC+n969+8bdCgdPrCtpGjKiII4sBRms5Efvhf7H1iDVP0/jKOcK3ARnuat9cUrQRlKuzc15ET/2nv8qgdhdrBTiAjZ+kEHP1EmaAr1J8PsJ7YKu4tl5twRVndYQz7Aksprc5kE0XjxuPZk3HzN9Z4Aaj2YJhNVoamAlhj0q8aOwWYZkD4iuMzREGbRJmk+vm3PXtaHetLEB1Z+fGIAfQRaZlLCULqzxFBZs8XVk9me704ge3XVIFs7+bFeBbVEinI5Y1czKb5X8/COIOSOo65XTwcEufjUU56pfaLT25cHZtPQZo0tACzXFL+B+GwvMXswU0hy8IsqrXv1NzlRdXqqqQLYGmp8ewBc/cFV5QmJAh6TXYpnEboeOOHMMtbMjowQRcAx1RW/3qC9f3/z8rPzWUSMhOZzGfRUyFOT/HwQcqmP2pFwNOISmHJL6ba7Uy3Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 27 Feb 2026 19:30:17 +0000 you wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The compound_head() function is a hot path. For example, the zap path
> calls it for every leaf page table entry.
> 
> Rewrite the helper function in a branchless manner to eliminate the risk
> of CPU branch misprediction.
> 
> [...]

Here is the summary with links:
  - [PATCHv7,16/18] mm: Remove the branch from compound_head()
    https://git.kernel.org/riscv/c/66b2a3d9ae46

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



