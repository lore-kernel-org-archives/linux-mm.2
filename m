Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37667CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 08:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C4A06B00AA; Fri, 26 Jun 2026 04:21:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FE7A6B00AB; Fri, 26 Jun 2026 04:21:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE246B00AC; Fri, 26 Jun 2026 04:21:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E772E6B00AA
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:21:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 672B5A03E4
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:21:33 +0000 (UTC)
X-FDA: 84921369666.06.E27932A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id B9CC11C0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:21:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d5Lo7MDs;
	spf=pass (imf20.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782462091;
	b=fgjzl4dz178Cp9f9z1Rb+wEWJwmU4gS2W92a2kILhiTwg8A9OHy5i/ziVUTevcGWMqTNvp
	BFqCYHz8TL3yGXy3jwSW7RrK/N3r9oTkb1V8RSciP0gumOt3kZ7W2c5khQeP2RpeuQMRwf
	1N0l0nTpGvXVPJ2SktyKRYEaCJNtHew=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782462091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=amHqBGTdQawFVm0LwCwHTx4WOCHiePZ3qut6Gw9czoY=;
	b=UJIEGwoQXejfeQaF2IHBE+vcboPjDIaPLl2LbIKrQrqxDwTfUdeYAXRDJvosFc/b0dCJLB
	z1s7nSLVX04+aAJy8bc/eRW3ZaCgi1/ON9mQGm0PqkPg0DmUH3BFYrQHT+ns5yoY6KUAAH
	y33hLP49nksJfrNlHKZlrHOL2N0Q6a8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d5Lo7MDs;
	spf=pass (imf20.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F35DA417EA;
	Fri, 26 Jun 2026 08:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21131F000E9;
	Fri, 26 Jun 2026 08:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782462090;
	bh=amHqBGTdQawFVm0LwCwHTx4WOCHiePZ3qut6Gw9czoY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=d5Lo7MDsnDBM/WZunCT8elchDCzS+3C2c2lbeT2RSyY4SfuiwU/JuHgJcOlOwtDQj
	 xTs8KeqZ97q11hRxTGc6nX5sC8HyMT5fZT+4qSj8SryW2td/wtO9smFCvfjcxc87Ru
	 eLKRJlPdL6ayIsq8pXjYViiy3xT8buj1g0NlrmisaHekowwVrgLIe+N8x2ztJj0mHl
	 P2mUemccKTtOFMr2RIOTamnjYwOMVgAvn0oNX07Zb+nu/Qg5awHIX5oYSWKc3+tC3h
	 k5BC3dcthXef5b80m5peDldls/Zf3sAtajK0+0mGczG7pCQAJfwafDixrBN/6u/FYB
	 5mx3vhjFNnd6w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1977339389E8;
	Fri, 26 Jun 2026 08:21:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/5] mm/sparse-vmemmap: Provide generic
 vmemmap_set_pmd()
 and vmemmap_check_pmd()
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <178246207775.3816447.6521226918403076772.git-patchwork-notify@kernel.org>
Date: Fri, 26 Jun 2026 08:21:17 +0000
References: <20260601084845.3792171-1-songmuchun@bytedance.com>
In-Reply-To: <20260601084845.3792171-1-songmuchun@bytedance.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 palmer@dabbelt.com, pjw@kernel.org, chenhuacai@kernel.org,
 andreas@gaisler.com, davem@davemloft.net, muchun.song@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 sparclinux@vger.kernel.org, alex@ghiti.fr, aou@eecs.berkeley.edu,
 kernel@xen0n.name, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
X-Rspamd-Queue-Id: B9CC11C0005
X-Stat-Signature: jn1czgct876soa5p3rxr5x99z9qtz1kz
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782462091-469832
X-HE-Meta: U2FsdGVkX1//50Ckjte3c8brGhLn6bqybN1Xxh6ZzSRBHv++hToZMrRRU+j+JCyk1wAC9asuhgRqVoHFnmWoi9nIdmBg0604GjKd6OKgXg742bsuw6g33Rd5ijWRPzJ7nfuDjwKJb2EpFOuEF+8DWn7GzfIyBwtX4X/zsAJfU0v6OwJqvgROVWEfWo24DMsAHM8O+petwcTqcU9I1K0cM2KlUg49qP5YJvG5E0HtZFbGRa4m6kOx9HQNv2+/pF3SCkdlWmcP+/YMfkBx5q8yX9fG9iFIQ5Dd/65EhqkoQptQiohcNUAyFRlrUjBvBcArAejqqZdpbfpfui+xi270EuvQUdyeqbH5dFDtaFW2N+X1rvg/W7HXe1PDghiB2Gqx8ETCYrgZHn0amWiR1HWwwBiHffZjymhOBIFeTBLzGq2tGmLSBFDKWcEekt7J9HgrN06lcjssNrg8tbdAAhOCP9eG4zKmhOhaPiIzheKiEZ2qadccnx7rFIswQxbCEVOOA5FCcr2RnZrW+81yqm0uG5ls22gvMcguBnEZn22ta2SdGWSemST1iLdC4MHQHVl1cUnPZLMGuh6BtMNM8SKelTKawPupX/eHE6WOn+hZ3kEOSp6WTDqvHDjV2dkRL7yX0928It+iRved7ig14Z7Y2xSUglPk/Gd3a+YIuSzauOKvcyq9plxsqCv+PKd5kKKSVED45lI+SgyEv3U075qfX87IfE9WlWvo/EDJGgcn/iqQURo6xrcgJrlshXiISx02Xefcvrl2QrOOU7zKhauWIbALeJLBBkzTsROXEl17sgDursjMdMu+lIvy15O8wcLopnypS1Tv3qpBSSluha3fRnkA8hUbJ3tQzq1yTl+zwoAt46PPWgfwgbUm+yNmIz3WIc/GD4Z9GgSoKcS05DZW6HbHLQ+kF5wG6EgQslQWrLUEgI5CnKbyj9CPbhoQpe6j64Vg7xF/jFl943xLqTL
 PI3ULDWT
 t+94cvNEugfXoEhO52syRY6oAgKPVXSsjc0wBOwv/P8Zqdsq2fqhvVjZxU55q9AHWuJS2IphTsuel+8u4raqM7hZIniMRUZartqy7+NwODWm/cjO48P90sweENnpRCrSudJLWeg15i9cpAlrXKOeqwP4TaCVU4onoSfz8WxUHLH8bfUcrTVQjdx7CPyJIe+6YgreWyMWN1C1ftDIhaSc4HuALqpFqd3bN9FmVLXSwcog87LB7r5L2zKRk13Rz3lUq9cyf3MqvwcsvIovIreI39uPuwqB/VbaS1iZMOmprG4jwVIPVGzviG3cqjVlpO6sAZ+MYeWT7IL9/hEQ/ihdjUOA7Hl30CY6maOIpjyId2e00fXAfAA9sQcQ2GA6mndiG4BEUZOa+vmCfz/NqeQYxFB6nzr6T4Nv24zuPurNPA+DzgRorOwWdp5KPsfrUcV11q7kOpb2PrYWmzwE63I5Xjz6a6hVkzZNbyMDEq+eHTvmfvi27exMdwwUy2NLL74UdYadwmdg7UC16+74=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Mon,  1 Jun 2026 16:48:39 +0800 you wrote:
> The weak vmemmap_set_pmd() and vmemmap_check_pmd() hooks are
> currently no-ops in the generic code, which leaves architectures that
> need PMD-level handling to open-code the same logic locally.
> 
> This series provides generic implementations for both helpers in
> mm/sparse-vmemmap.c. vmemmap_set_pmd() installs a huge PMD with
> PAGE_KERNEL protection, and vmemmap_check_pmd() verifies a present
> leaf PMD before reusing the existing vmemmap_verify() helper.
> 
> [...]

Here is the summary with links:
  - [v3,1/5] mm/sparse-vmemmap: provide generic vmemmap_set_pmd() and vmemmap_check_pmd()
    https://git.kernel.org/riscv/c/0b6073ff1574
  - [v3,2/5] arm64/mm: drop vmemmap_pmd helpers and use generic code
    https://git.kernel.org/riscv/c/f521f198b50a
  - [v3,3/5] riscv/mm: drop vmemmap_pmd helpers and use generic code
    https://git.kernel.org/riscv/c/abff0ecf7602
  - [v3,4/5] loongarch/mm: drop vmemmap_check_pmd helper and use generic code
    https://git.kernel.org/riscv/c/ecca7da924b1
  - [v3,5/5] sparc/mm: drop vmemmap_check_pmd helper and use generic code
    https://git.kernel.org/riscv/c/d3d58e946900

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



