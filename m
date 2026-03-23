Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0173DD58CBF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 20:53:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414566B0088; Mon, 23 Mar 2026 16:53:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39E656B0089; Mon, 23 Mar 2026 16:53:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2652B6B008A; Mon, 23 Mar 2026 16:53:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 112006B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:53:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4264BDEA6
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:53:22 +0000 (UTC)
X-FDA: 84578528244.21.C9BDD62
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D93FE100004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:53:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kvPVnbAw;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774299201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LUzPZFjQeVSedg3H/jZSfR9FQMyKwp5Ly8lrhERBFcg=;
	b=Kw6DnTB+Qk6lg8YvujYyCxv/T5doBt9ZNcNhsB37fi7DW0LHsW3w3BiilIW8c85dmuG5xL
	FODOq40CMwUGMDRIA+4uVlOng/Muhp1OsexHXsX/R5o+owpF1L5ZEYNLBDzDzpHrYBPmPx
	PFfcc4U04eFYocRYmIKj8V4Ps3RHSyc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774299201; a=rsa-sha256;
	cv=none;
	b=1Wp4BY7sxe5f2JiWdbuxpGpRBXcERsUlg1+jKMcnSPF6bi/Hk/aOg0LzO+kAQTBp+jdwQp
	JZXLtZXCts9q7f9sPJ7/sJQ2UBqcp79Z1STjP+v1csFWZ8wkiC8tz53R9WLMkhifkiTnhB
	8TzzkgI/Bb3ugg1ddeyvN9NLMmd98CQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kvPVnbAw;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C35F434BE;
	Mon, 23 Mar 2026 20:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D3BC4CEF7;
	Mon, 23 Mar 2026 20:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774299199;
	bh=QmQZj8LJwz8i/n5oMIerdh5lvsfZ3NzT10K6LkDvPj4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kvPVnbAwr00o9SQ7ZkT1K2caM9+zgYDp9UtWvkzPgTBmdKYSZX22YUmwe8jqHvw2M
	 0bz6DGEYuA3D+y3EMhjJQLaeqQ7BODjk/7he5KAZUzmSNlTnSv+AIvIdAUsjAb4RoB
	 DUisssSc2jyK6FKFTDwQ6amAtnVwj/PaSceQlkFw=
Date: Mon, 23 Mar 2026 13:53:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: peterz@infradead.org, david@kernel.org, dave.hansen@intel.com,
 dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
Subject: Re: [PATCH v7 0/2] skip redundant sync IPIs when TLB flush sent
 them
Message-Id: <20260323135317.0b702a575eeef93332ba2519@linux-foundation.org>
In-Reply-To: <20260309020711.20831-1-lance.yang@linux.dev>
References: <20260309020711.20831-1-lance.yang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: uie8ng9o439t9sit37hepemkywdzecyc
X-Rspamd-Queue-Id: D93FE100004
X-Rspam-User: 
X-HE-Tag: 1774299200-634466
X-HE-Meta: U2FsdGVkX18LY8qkZMDwyHYfg/i1olMks5LcZKGH13glmMkM9gQTu3hmYiVs9h43vVNQs44pddXRXJQ4DCKZNdXA0v7XCjc9Rd/lymy71xaTyCffMa6gMRxGI5biA8n9gVG00sY6KrczhRLMD6aw9dt3h7+u3LXDC+2iWPpGdiBu4mIba//trpr8OV1q5lDobobTZ10gfWEQc0/ulTKjssxG88mGzSCKjy763d8zGJEzet7mPM5vM5+/9MIAmACaNBSiCwjPdPtxg1PT0PLO5JdwaYNa6rvIwt0m6iQJl1Yu+IYOzyAv5WbA0sXkUFD/cdpAL+GHXQZjhor/KkXjReZTJ/nIFb9eBrkfR5vleUsTafoALSSTNrK6OKMXKobfCDMLNd6LQG7V+9p4o/eaWAdLgQ8pfwSmv1kyWshE9t0QQ36HO2L35aF299OtsGiV/VePmGcn6vHA550Hcn81LhDTPgkfS+X2CD28bcQMyX934psjyF2PSJPo2Y4F64AuFP8jYnzsWGYvwXcP2q+VLhkNY1hmfI8ukb15A7ZGodDqdFvPfvtfMX/GCWOSfzAhF2eTBZ5gepvvmvqI5zLQBiHD1MF7/Bc65eMe/2902GTNcUoTsWBuLc07y8V4VRn/HToAriLBLVhj/774iKfjBvJlWixWKXFOF12rZhgyQGfiHBHZMaGGeqjQ7F3qe5UGQ1nhpmkE6PCeZ6PKkikhZ1Ep8aveE/jbFX7vhSvttCj9oREKqosp8W5IOWB3bC27Ga/3JyXwbMyu4CVRUmW3IO1zo2tMMJ6j/I0MG1kI1fzArsKY/EuiQJAMGfblcOerGJwjqezt0IJx8ZOJbUG63Bz2Tm/0yKkQiFtKhhUUiGWZ1HLqTSKj/b1pDxT4Ffs5cjSg1UKrq/RBcuCjVNf+xLkMSlUKJTp48zngCWtF51Iaqn7UO1cULn5uKfN0dbthb6nnRChfHeZLWdHKR0n
 HNTw4mLG
 KMIIbIOFJ/GILdnIjX+QQVfD/+GXqLW3SaGwbJ8JQxzrbeutjk1hV7p/jHU4Z11nyRUKvFUO/5Pk2hGdxW3iUKthHILEQrrKDYYEXqAS94LOa3OeEhmkIri2jaAmLIqgtr0wew09al0KgsKnHDDoxfzpftHTYFjnMOvMReyFZF3ejiRU1dtNZH7ZSZ/E2BVDnjOxgMwTp7VbkWPNYNebkvkPOiT2/+Eay5N/cT8wwALa6cfLMMyWkuhkAej15/RWSjNNW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  9 Mar 2026 10:07:09 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> Hi all,
> 
> When page table operations require synchronization with software/lockless
> walkers, they call tlb_remove_table_sync_{one,rcu}() after flushing the
> TLB (tlb->freed_tables or tlb->unshared_tables).
> 
> On architectures where the TLB flush already sends IPIs to all target CPUs,
> the subsequent sync IPI broadcast is redundant. This is not only costly on
> large systems where it disrupts all CPUs even for single-process page table
> operations, but has also been reported to hurt RT workloads[1].
> 
> This series introduces tlb_table_flush_implies_ipi_broadcast() to check if
> the prior TLB flush already provided the necessary synchronization. When
> true, the sync calls can early-return.
> 
> A few cases rely on this synchronization:
> 
> 1) hugetlb PMD unshare[2]: The problem is not the freeing but the reuse
>    of the PMD table for other purposes in the last remaining user after
>    unsharing.
> 
> 2) khugepaged collapse[3]: Ensure no concurrent GUP-fast before collapsing
>    and (possibly) freeing the page table / re-depositing it.
> 
> Two-step plan as David suggested[4]:
> 
> Step 1 (this series): Skip redundant sync when we're 100% certain the TLB
> flush sent IPIs. INVLPGB is excluded because when supported, we cannot
> guarantee IPIs were sent, keeping it clean and simple.
> 
> Step 2 (future work): Send targeted IPIs only to CPUs actually doing
> software/lockless page table walks, benefiting all architectures.
> 
> Regarding Step 2, it obviously only applies to setups where Step 1 does not
> apply: like x86 with INVLPGB or arm64. Step 2 work is ongoing; early
> attempts showed ~3% GUP-fast overhead. Reducing the overhead requires more
> work and tuning; it will be submitted separately once ready.
> 
> ...
> 
>  arch/x86/include/asm/tlb.h      | 17 ++++++++++++++++-
>  arch/x86/include/asm/tlbflush.h |  2 ++
>  arch/x86/kernel/smpboot.c       |  1 +
>  arch/x86/mm/tlb.c               | 15 +++++++++++++++
>  include/asm-generic/tlb.h       | 17 +++++++++++++++++
>  mm/mmu_gather.c                 | 15 +++++++++++++++
>  6 files changed, 66 insertions(+), 1 deletion(-)

Kinda straddles both MM and x86.

I expect a v8 based on David's comments.

One merge path is for the x86 people to take this, noting David's acks.

The other merge path is via mm.git, if the x86 people can please
perform review.

And...  mm.git is basically full (overflowing) for this cycle and
review/test has some catching up to do.  So I'd prefer to only take the
important things.  This patchset is a performance improvement but
contains no measurements to demonstrate the benefit, so I'm not able to
determine its importance!

