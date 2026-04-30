Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDF60CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 639486B00AD; Wed, 29 Apr 2026 23:26:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C59E6B00AF; Wed, 29 Apr 2026 23:26:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DB766B00B0; Wed, 29 Apr 2026 23:26:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 37B4D6B00AD
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F116A1403D3
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:34 +0000 (UTC)
X-FDA: 84713784708.20.5CBC506
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0BFD0C0002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wo1L0FAi;
	spf=pass (imf10.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uv0/AeoPfpXHb5/5volWmUsGpOV4SzoHoygFS3Y1v0g=;
	b=ZH7CqlZGLY6cUcdknMM/gZAsbgT9+zsRftGXugoXTaOHVbUFPc0HO7inpnKusa02yvHeDx
	uescFBdsqxB/eRqkvPRpX2dNYumtOdy2G6VAcjwlSoGO8jR+dS9+s5WP9Z1IFA//3VMgQX
	5zGFuf4pT4DLc0ZJjmRCUKkLzSBNSNA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wo1L0FAi;
	spf=pass (imf10.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519593; a=rsa-sha256;
	cv=none;
	b=OfzcMKNXTL9+tYWXNtIE5aJddCQrOK+x0r40PjcJtOAhYwbCH1Ms9V0aDMNVnrwxq245Pl
	B4nlV3vD/jCy/DjzU2DH/lCWPHe+LT0YmppcBY7YbaDkMKvrLbFssP6+tFu3XjUhsTYFPg
	oDXbzvogqHb64ZCwfunc/UZvjoXjFXM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A8094443E;
	Thu, 30 Apr 2026 03:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF196C2BCB8;
	Thu, 30 Apr 2026 03:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519591;
	bh=D6nRuLlNtWNYvvWuUfjCi9f8beZLcFCcGwTLfTAZV1I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Wo1L0FAiDsetIA/SZIMY+AZ2u3wX74XqfiqwNIt6PNAuDwjaG2jrM05nbChaS/1w+
	 RCmeQ4j1ATh57HbuwNvIYf9y01C7fhsragL/4RLWcSfcjeArvpsZCIf4D1+2JzF+lu
	 QvlapmT1r6mGtpC/JBtb/i3oKWYqTNCWdDeT5Cjpio+S+IfZdGzYd1U9UsNmsiPiDd
	 SQqYDrMvbc6Q+NbWiVgZLofEOiO1goK2HygUtaTFo5Mcw/hy5zHqRYL31iLH4Ql9Yi
	 iOqQUeeCRrWIjMN41eaD8Tm3MbEk7Cm5c/f/cH4xsZ4sj0M9HzOVh3aiLNeN/s5MxX
	 eA864zTCr1jHA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FCAB3809A07;
	Thu, 30 Apr 2026 03:25:48 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7.1 17/18] hugetlb: Update vmemmap_dedup.rst
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751954679.2274119.8307144944681814627.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:46 +0000
References: <20260302105630.303492-1-kas@kernel.org>
In-Reply-To: <20260302105630.303492-1-kas@kernel.org>
To: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org, alex@ghiti.fr,
 aou@eecs.berkeley.edu, bhe@redhat.com, chenhuacai@kernel.org, corbet@lwn.net,
 david@kernel.org, fvdl@google.com, hannes@cmpxchg.org, kernel-team@meta.com,
 kernel@xen0n.name, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, loongarch@lists.linux.dev, lorenzo.stoakes@oracle.com,
 mhocko@suse.com, muchun.song@linux.dev, osalvador@suse.de,
 palmer@dabbelt.com, paul.walmsley@sifive.com, rppt@kernel.org,
 usamaarif642@gmail.com, vbabka@suse.cz, willy@infradead.org, ziy@nvidia.com
X-Stat-Signature: ex4ijgc3np6ok3yt8g3wwg1gcwy8yi61
X-Rspamd-Queue-Id: 0BFD0C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777519592-598711
X-HE-Meta: U2FsdGVkX1+l7lOR0MsT1fIZ6lvyjQ/JCT+bH1E55qmKZw4BEQAQ+1hTXFFfcGoVyqq8vaaNap6B54/x/MoD+mPNI2+eF523khZIg/L1gXno/V6C5ONqN0A1vZy0hkYdtIUuum18pL8NHIpGmQu2XFy1/ll1KGGYl1D8dIYQfVnyHuCKidn6M6cePu7y8Du8vlsobPQUQzY9Izd4eobb/NsiQ3KijXVLPwTORwt+KdE+e4eyakL8VZTT3oxw5J53YRXDrO6ddXXuW2b2mFILJ4AiO0NUztNuRMfuev5aotVV8nl0NZOL1WbcE/0NA7D+vhKwQjzTrz44K+0LS48WAqyNTzmqSjL42vvLE9kfbEMBYC7DginILZj0pcmbot28Z0viQktR2dyp5U8Mix2dt21eYU1N3yhL5TXfG+jKDlP6P7QOe1wDM/5InrJ9Kd93l1O2gt5XIeHz5+NM161mL8NfYqW8KqCTUsa9PTxlVuHkO+7tVGHXxy8EHYVUW1QwuhXzrG/iMzT2U7yKNktXjiMgd/3887wfvVTAEZFZ6OsJvcOz52di7KnewYfpkaP+AESKVM47X/y6I5LWdae307QFnaZQpqngibPf11lDC1wYUpwPvCGG697zO5vVqm8ZlPOOOxwtMw5xycS1MViYVaeOXIUQptCcPimaU9/OwpQxEwhcjIpXvqUx1cqQS8CNQ8fzA6VhGNFz7U6t1b7mB8HswLGXVLLZEaQFfELS2qq6FQt8LHpf+gmKIctpY/SeCgzJofKknw/A/oUiUqnq/k4E6nSM7R1HCxgi8ippzskadpAPJftTfU5cZDX7b6CilcV3Vb0wcoVeZfamis6LZ7z9HyOx4lDiVKv3HR7EtZpI/pL0Tt2oQHOkcXZdAGBQWUWJueCRHaXpXJ/8kGQjqdpjaSq0dLpQjr5pvDr1J+p19WhScRHkCAmkWA3/HTg4uSRjW6TmU3u3v9zlQTC
 H+Hl42sR
 ZTmNd9FjD2b6RlREpBkOOw1STptQkRsZuwxOEu+Fp67bVRv1bGFO7JylvvEZHR9SbUm92wibvFIDqlOEo5FFYCI8MGg1JSPQThG/z4UUqB/NvsqY5JuLwwUbywhrYPLRam2X/7XIMObIK9d/ovp/Fg/CGHgV1VsEk5eyOmV5QOcze7MVxNW3xhpF5aP5sFiBoy4PnGiOEaOV10IVwApLs0wLVOw6j3ldufIzuTh+l4va9cqAdWid2x6z+CgszeMRth3D2KW2BswIPpnqmdfz5gRGgX1TMwA2mzdmwL+/XZFRqw9/TTgeQaJa9KrdamYWAC9NVMnW+3EhO5dczp/3dqdq4JAr9LP5nI8W0riDdwL4JrKgQdYCct94+wmLDeKvdtx5WPHcfnv7dBgXGchWIFPHZdpyjCXG2vY9uSNMCDdQJA0VBHG36/vrjPcUrHYFGQwsSNGNibFNf/+2Zj1csUErkW1xinkpw1rKehE2V1vKqTWM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Mon,  2 Mar 2026 10:56:28 +0000 you wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Update the documentation regarding vmemmap optimization for hugetlb to
> reflect the changes in how the kernel maps the tail pages.
> 
> Fake heads no longer exist. Remove their description.
> 
> [...]

Here is the summary with links:
  - [PATCHv7.1,17/18] hugetlb: Update vmemmap_dedup.rst
    https://git.kernel.org/riscv/c/fed8676ca2b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



