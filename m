Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 215FFFF8864
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FEA96B0092; Wed, 29 Apr 2026 23:26:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C47E6B0093; Wed, 29 Apr 2026 23:26:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4655E6B0095; Wed, 29 Apr 2026 23:26:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 330306B0092
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D69C71C06E9
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:01 +0000 (UTC)
X-FDA: 84713783322.20.CE68586
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3B6D8180005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sCAQnthw;
	spf=pass (imf06.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UOc7eENZzDSvqUDGAtbJQOxjSzOyNxwJNl6sfNg3Hkw=;
	b=IF0G/oI8Tn/fNPfw5McAQ+sNM+uoXcy0saXn3MyI5G8BjQj/ZUfc2LbJcy6WuVcvKWaAQX
	pEOi+4A48tcM4RZ+C/uxP8mhXG6orY1ZLp408wrww05jXdNRQzugVh9V+KayQaePLZb6Hw
	lPhWxR+bO+eSIoN8GttIshu1jO9cAX8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sCAQnthw;
	spf=pass (imf06.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519560; a=rsa-sha256;
	cv=none;
	b=i8Lsk60sOt6anvvGXrD1CdUSGr9qM0bV8V5fkMJlLp4GnX591Sv6eStpizbNUNLL7wwSWb
	+ng5sVPB0Q4CIbUT8Hd32nRXzXBWDPlICfkaWAaG/cduQzig8CDEQ0jJ6bqf6BMYuK5r+e
	s4QARi954Ic0Qf5KKlhysnfLTXJ10Tc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D55B6132E;
	Thu, 30 Apr 2026 03:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3783C2BCC4;
	Thu, 30 Apr 2026 03:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519558;
	bh=Gdp4vkpY3OWdrZmj6MnO4StGWD3Debys2l2muIOhkFA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=sCAQnthw0OckKXZO6x/qlAXlkm3PLrDJ5UCQPIaxPTmeHXivI8BUebUCMqXtrSrS5
	 ycbZA6dI+TYjbkodgrkOGHjHHCi3vWD9sR/+qZxRozBig6oZj0B4quAoubPGs1jyyt
	 PG6udE2/TwpTXZH1+QlMFNDx6O0VW/7j5EmGWb+ZOet5eD+DEcj3LIRbpsxwkXJyq4
	 1dIKTmZznzAI1yNeEJ2sgsW6b3umMsdpQHghvmJyFdZ/QNVV8/VS4eFOTe5NCMEBAQ
	 LVMpV68lCDytpgtZlgzNQLnEzJdciZiKTtVC9Gh/yuSwg6kNujg/UbaaOArleSR8dZ
	 zcS9ACifyzHeg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FCD33809A07;
	Thu, 30 Apr 2026 03:25:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7 RESEND 00/17] mm: Eliminate fake head pages from vmemmap
 optimization
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751951380.2274119.11967025926304588817.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:13 +0000
References: <20260227194302.274384-1-kas@kernel.org>
In-Reply-To: <20260227194302.274384-1-kas@kernel.org>
To: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 muchun.song@linux.dev, david@kernel.org, willy@infradead.org,
 usamaarif642@gmail.com, fvdl@google.com, osalvador@suse.de, rppt@kernel.org,
 vbabka@suse.cz, lorenzo.stoakes@oracle.com, ziy@nvidia.com, bhe@redhat.com,
 mhocko@suse.com, hannes@cmpxchg.org, corbet@lwn.net, chenhuacai@kernel.org,
 kernel@xen0n.name, palmer@dabbelt.com, paul.walmsley@sifive.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B6D8180005
X-Rspam-User: 
X-Stat-Signature: oggsjbqaowcs6uk7qow5uaeaf6u934xi
X-HE-Tag: 1777519560-318817
X-HE-Meta: U2FsdGVkX19k+oE+yCSx7xzIdtN1i8oILF9E5DOBWijmw1X9RkPg6hRTgPzFX4qhYQ2ZugR1XHXp7PJiF+3TMtGf4iKfwd9pGVSDBZXP1fIlsGSx5D3Od4aYtjRyrjg512/ilMQo1/utKhBw5qyTeB8KyuI4MMzN9sjJbllCMzp4vzijmLV1I1nh69Ha3u5+uMV8rMAHyDiMvFkkhgWZlQwPKY6XFtaBfwNvN+lgYqqg85JpF9hIgNxBn8GHLUsR7GdlHjjB1ZN+AlftcXgk+RiASur2eO/svp9efsE9Pw3npmVLRlJdXl/fK0LLp9iQa4e37Pc5P4y2v5yUHvphFshSk0vt7N/Ar5+lX++ZBnRyx30hZu4Xt++nYiNH2HvV/3zq79zgn+n8ZrZ/F/ejZ2YSlEnz0uu6dhKW8ymQ4AtLGE/BOUNSzo70xSeclmobjxeA8dr4imvanAg8DB+rMdnjWm57frQJbXRnnFe8AjEnsPsxFsq7aQzVR+OpvlOoPuw2g6uqe9Y8oDd5E+i8L46hw3Be1dgs0Fi50uTBaMAta0v+XcCFemJD9BP5eUwdUTSw9SNo0Y6AxU/lUJ+EsJvpqppVgezYIHW9l7HdAjfVOcyTNaeCsC7hpx/CUpiS7rNuPPxr06Yc+62ciy5t7m+dLYh0PEALiaYz3otsSB82QZSlvLD0n4HTw6xIcLz8sXhzw2RpLhXmNl51Yp9yBA2xMmskyCTzgrYm4+vRhEtNUt0k6IkbziF1yS1fbpp2rx02R2cvEelLFo7MYrHWPsrUI6sAV9bIU8hCoBMfxJBLlcy73WMLn3J5+WUZuZqtgTMQZN8XWpMqku+IizqjXARKW4K3DpBHTNbZKML7wcSdgEsKbIAWIRe9ys5OWznXgH7QVyUHYGXvKQUARHgpN/k8Znz5gHZbVIi+2vnNHWYFhixWgdfTkVFOKcr/EJCs2EVNgut8AszDzs4y4h8
 qwUZdHrB
 TECcUv/jRMvB1hnZpDGHOQhQOPVzlMNtGKg6G/TSXUlYxY9wcuLQOf4oBY3/sDMz8/pOGF/YA7onae52+di2dWHz/VWx2Abmdd4Dlr8Wpox/J3/qhj2/J+8TrHadlfBstyhMWHGTBx1sH3U8xK7CxMi1A89fgpXF3pnM9mf3S29ORQ0Gi5lYpFXJlEH1hc/+KSa+kvn17TK2SFl00wAzRASUX9GonCKP+JY86v+kH5hRvOMCAdDwQK8BkL6qAs5GUY7nmSGbT8K91kmHUfhAPbETD8gOWFOVLS9TJxvAwDNWvKoEZfNnmOpDNKDG+jD3avzpFs1pcJzBgRrjkmWsqaPH+uSYRnp+BLPDTyGaupKRtYlSQT8KYrxBOie+DXhQYjL2Zfxbd0O9EJck6yVmtGB/PTq2DJWP105fO9opxhPfk5zTHcEBzjfqwJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 27 Feb 2026 19:42:38 +0000 you wrote:
> This series removes "fake head pages" from the HugeTLB vmemmap
> optimization (HVO) by changing how tail pages encode their relationship
> to the head page.
> 
> It simplifies compound_head() and page_ref_add_unless(). Both are in the
> hot path.
> 
> [...]

Here is the summary with links:
  - [PATCHv7,01/18] mm: Move MAX_FOLIO_ORDER definition to mmzone.h
    https://git.kernel.org/riscv/c/a2c77ec320a9
  - [PATCHv7,02/18] mm: Change the interface of prep_compound_tail()
    https://git.kernel.org/riscv/c/f0369fb13619
  - [PATCHv7,03/18] mm: Rename the 'compound_head' field in the 'struct page' to 'compound_info'
    https://git.kernel.org/riscv/c/d50569612c29
  - [PATCHv7,04/18] mm: Move set/clear_compound_head() next to compound_head()
    https://git.kernel.org/riscv/c/67c79a5af051
  - [PATCHv7,05/18] riscv/mm: Align vmemmap to maximal folio size
    https://git.kernel.org/riscv/c/476849b0fba4
  - [PATCHv7,06/18] LoongArch/mm: Align vmemmap to maximal folio size
    https://git.kernel.org/riscv/c/2969b42c8f99
  - [PATCHv7,07/18] mm: Rework compound_head() for power-of-2 sizeof(struct page)
    https://git.kernel.org/riscv/c/8c846c879e22
  - [PATCHv7,08/18] mm/sparse: Check memmap alignment for compound_info_has_mask()
    https://git.kernel.org/riscv/c/9f94db4c7eaa
  - [PATCHv7,09/18] mm/hugetlb: Defer vmemmap population for bootmem hugepages
    https://git.kernel.org/riscv/c/209e6d9eb13a
  - [PATCHv7,10/18] mm/hugetlb: Refactor code around vmemmap_walk
    https://git.kernel.org/riscv/c/c0b495b91a47
  - [PATCHv7,11/18] x86/vdso: Undefine CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP for vdso32
    https://git.kernel.org/riscv/c/76351f2f0c27
  - [PATCHv7,12/18] mm/hugetlb: Remove fake head pages
    https://git.kernel.org/riscv/c/622026e87c40
  - [PATCHv7,13/18] mm: Drop fake head checks
    https://git.kernel.org/riscv/c/32c440d67e6c
  - [PATCHv7,14/18] hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
    https://git.kernel.org/riscv/c/01b1d0ffb6f7
  - [PATCHv7,15/18] mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
    https://git.kernel.org/riscv/c/da3e2d1ca43d
  - [PATCHv7,16/18] mm: Remove the branch from compound_head()
    https://git.kernel.org/riscv/c/66b2a3d9ae46
  - [PATCHv7,17/18] hugetlb: Update vmemmap_dedup.rst
    (no matching commit)
  - [PATCHv7,18/18] mm/slab: Use compound_head() in page_slab()
    https://git.kernel.org/riscv/c/8231e4c040fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



