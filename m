Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EC2ECD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 11:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFB8F6B0005; Wed, 17 Jun 2026 07:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2F46B0088; Wed, 17 Jun 2026 07:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC1F26B008A; Wed, 17 Jun 2026 07:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA116B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:07:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06E30C1A4E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:07:22 +0000 (UTC)
X-FDA: 84889128324.07.D4044D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 23C5A80013
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:07:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xd4qAxDs;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781694440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h6dXIG9Ix1iq8lF+scJp0tVtUJekSbTJUAEd9UVcqC4=;
	b=rgYKGtp82bgkEm9+IrN3AUeGpMk3IDpWGOFKYMmeN4ABNDpsPcV7x9GGRUS2e0SliMUDlY
	++6tyKZ05GvdCtpfRw0EIybNt+r/I3RPcAMsFOVOtFZebBWgBFYGAqVb2KkSQ/fEz7xKMY
	0ORPNIjmbmVZHfVwXgJm8JHWJ/E3Bjk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xd4qAxDs;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781694440;
	b=O+foIJ2/b7lGTR4O6leZgDFl+2G7h5BDxPs7y9tcxNbyVvPCsTnOah+yCK6AjyEmqkVAYN
	382D5JLY4bwtcKS2eJbwMKoN8Wsq/x4cM+xeW+FmtCU01AH902fxyjg8z4bp3jzxlxiuUl
	IkEV2IQgy2UZMODLxih1qMVat2oqr+I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 198D04064B;
	Wed, 17 Jun 2026 11:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6D91F000E9;
	Wed, 17 Jun 2026 11:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781694439;
	bh=h6dXIG9Ix1iq8lF+scJp0tVtUJekSbTJUAEd9UVcqC4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Xd4qAxDsspeL4VPFXtGf6ezzzzy3sFoOLNA/rgK9CqhbNBV78Bx5Jw9dOc/7ORvpi
	 Ux6t84B976GEVfgr0WeTR1nEJ4qY/eFWkymBFbNit34duGhAjlcOeDiCyyvKOFCeZ7
	 iopv/+rFJH6HABE6inEDqWJGZBipr3UEcuXPwKTpHamr8JCV7OXlRSYl5fZJpdE07x
	 bFLbJDMrkeb3VkwSO5fiQh+RG2+I/pwnfFeKCl29NnmcqlR32zvjlYlmrc+0D3TNTV
	 icpze+hF5EEQvSMoi9xpBxk/Xszdn+0LXCVKGC+BAH9YfIVZ+IAHHn5eSjH3CdgP23
	 HFV3qaRNMhiVQ==
Message-ID: <e37721e1-75d6-4908-8f93-7c0f68a73eb9@kernel.org>
Date: Wed, 17 Jun 2026 13:07:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_table_check: do not track special (PFN-mapped)
 PTEs
To: Andrey Smirnov <andrey.smirnov@siderolabs.com>,
 pasha.tatashin@soleen.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr,
 syzbot+2b5fe617654be3d8848b@syzkaller.appspotmail.com,
 Thomas Gleixner <tglx@linutronix.de>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Andrei Vagin <avagin@gmail.com>, Andy Lutomirski <luto@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, stable@vger.kernel.org
References: <20260608155758.1220420-1-andrey.smirnov@siderolabs.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260608155758.1220420-1-andrey.smirnov@siderolabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 23C5A80013
X-Stat-Signature: bs653g8xunqntfz6j4yumqut9kxugkie
X-Rspam-User: 
X-HE-Tag: 1781694439-121818
X-HE-Meta: U2FsdGVkX1+EwO0IxnrN+jxg3IJPXfU9e+XKoHzi5dqSrWIGZJAWllQSKIvBqjopQ67JUYi0D4INka81DsJY/8++ckxWL1/gby8kpdcBc7sR7UNUcq/4NEr1qcU+7pLkNm9O/5ueLYE1rlrqGxFfCzspf5jyEjySLxmSRlTcnXpZNJmNvN4oVdg9izJwEWlXDRFNavUNLG1IXHIe0MWkXJ1ViDpRUCC5XRfGVXBW+eAPXqIiLrUWH3O1Mgm5kc/C/DWr+t6S/OUD4e35bCCVAujpiNbFY0hB5WBficeyWQjuXLOLg6y22ZtxaurukdygByK64IjEs1otxH50QFFWIcRNvbxAf5cG5Rd8qn8Edc7DKUQOswqSyiNfZiwXwAHZ4ILYfp9xmwxkHQXkRfVg/gmyIi4V/4CSGkYqTJibebFRJciBhWkLcAlZ0VF7rmudjNEA+mkrnoyhWhJoYKFZVP0paVXjspbBfUSyZdeZvRPeMWtuv9wA/meDYZ1dopOkepPNYS7Ybbfpz+Dw17+OA3XXJpurZlUAlWB7x5U9hYTdUwsXefEVjxljaBS1mqV2CC0/sqK/LZ14erg/2v/ZltfN4L43/Wko0DZnFd4t35LeZo1IAgVmQ70kjNm5ALKYrri64jdA6FNd5EEWuYntucZ05SimaoBemOPHjW1sCfPIyPjU8ynjmXry/QY6A7Z7hV0xneq7x44qIi9cAn92Jyik3z14gmwoHgKqPsnP27DlW9pOORu/n1mqFATwFNIVWUtRXXSTcrBEaF1dJL09ux6W6p/VEyard8CqbAYIpxghSzrssgR6ebfvgZVtE07T0jhG6DpQLKQMCWROd9U9hbNOyyuGmnLjE6kkTXop0f0AFWfn6QwbHWtfoRAnwgPEHN9oiEajz5QQctUoctFvBMj4Yuh35tDFgO1FGv48/282kFClJ0mb2QCSwNqVZjMazY8T8n6pyN2iMGTZ/0N
 +VwoalSH
 r7840YekEc8Fsp6M8hBT2ZBGldJC9Y1EFAJeQayboRis5BI5YKlbEUCUGh7aHD3ofP2l49rrLno89vPnHnvpktVV6XZu/q4IjJ+jV1LYtW/o7wycxr0HXcWb8S65o+MVb7AmrvaxuBt1Xl6lKAoRmIncn34aPOH59MEtv1je4lfl/OH6XmGy4ntc9OZ5twzHkARSerSpb/smhpFA3rq58rnb2PLVUFS4t7lor8nWyBHt+ALveegxqQoWYHgZqUtth6RWf1xBgKeuKsJAPRNG80WQljg21To28nCpJ0IY1FoLSQ0GU4YAPSnptlDQLzqh5xF9qB96vmJGso6JJDLIo4408aHgE7dlvTTLNRGa8JFJPE87EHnNAI8V4z51rvy/DRQ9+63ZF8HC/gXd/Pv63hgYMcFKRwytP5Z+mYtvqczYs6pCHuRh2QNfQcK8SGzo0yd/e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 17:57, Andrey Smirnov wrote:
> The vDSO data store ("[vvar]") special mapping is created as a VM_PFNMAP
> mapping and its pages are installed into userspace with vmf_insert_pfn(),
> which produces special PTEs (pte_special()). On x86 and arm64 (and riscv)
> pte_user_accessible_page() only tests the PRESENT/USER bits and does not
> exclude special PTEs, so page_table_check accounts these PFN mappings in
> the per-page anon/file map counters even though they are not rmap-managed
> pages (vm_normal_page() returns NULL for them).
> 
> Most of these data pages live in the kernel image and are never freed, so
> the stray accounting is invisible. The time-namespace VVAR page is the
> exception: it is a real alloc_page() page that is released with
> __free_page() in free_time_ns() when the last task of a time namespace
> exits. Across the map / unmap / vdso_join_timens() zap transitions the
> special-PTE accounting is not balanced for this page, so a non-zero
> file_map_count survives to the free path and trips:
> 
>   kernel BUG at mm/page_table_check.c:143!
>   __page_table_check_zero+0xfb/0x130
>   __free_frozen_pages+0x52f/0x650
>   free_time_ns+0x85/0xc0
>   free_nsproxy+0x7f/0x130
>   do_exit+0x313/0xa60
>   do_group_exit+0x77/0x90
> 
> This is reliably reproducible on x86_64 and arm64 under heavy container/CI
> churn that rapidly creates and destroys time namespaces (CLONE_NEWTIME via
> runc / docker-init / tini), and was independently reported by syzbot on
> riscv. It only manifests when CONFIG_PAGE_TABLE_CHECK is active.
> 
> Special PTEs have no struct-page rmap semantics and must never have been
> tracked by page table check. Skip them in both the set and clear paths so
> the counters stay balanced (always zero) for PFN-mapped pages, regardless
> of how the architecture defines pte_user_accessible_page(). pte_special()
> is available generically (it is a no-op returning false on architectures
> without ARCH_HAS_PTE_SPECIAL), so this is a single, arch-independent fix.

Using pte_special() is usually a sign that something is likely shaky, as it
misses architectures that don't support CONFIG_ARCH_HAS_PTE_SPECIAL.

I assume relevant architectures (loongarch32?) do not support
CONFIG_PAGE_TABLE_CHECK.

arch/arm64/Kconfig:     select ARCH_SUPPORTS_PAGE_TABLE_CHECK
arch/powerpc/Kconfig:   select ARCH_SUPPORTS_PAGE_TABLE_CHECK   if !HUGETLB_PAGE
arch/riscv/Kconfig:     select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
arch/s390/Kconfig:      select ARCH_SUPPORTS_PAGE_TABLE_CHECK
arch/x86/Kconfig:       select ARCH_SUPPORTS_PAGE_TABLE_CHECK   if X86_64
mm/Kconfig.debug:       depends on ARCH_SUPPORTS_PAGE_TABLE_CHECK

Can we enforce somehow that we expect CONFIG_ARCH_HAS_PTE_SPECIAL, so anybody
unlocking ARCH_SUPPORTS_PAGE_TABLE_CHECK is aware of this?

For example, through a BUILD_BUG_ON?

-- 
Cheers,

David

