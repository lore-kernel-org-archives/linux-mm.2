Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A0E8FEC0F6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 18:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B99DC6B0088; Tue, 24 Mar 2026 14:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4ACF6B008A; Tue, 24 Mar 2026 14:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5FD36B008C; Tue, 24 Mar 2026 14:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 983F26B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:43:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4D1E68961D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 18:43:44 +0000 (UTC)
X-FDA: 84581830368.07.2F44EC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6429F40002
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 18:43:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Qp9yLI2s;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774377822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VejPlZ7eXEj7v3ks3bIF67Pw2+Q68qbPZ6Iyi5A5YKo=;
	b=sBh8Q+Wpll15zXhRniDDqzbdfyB8sdVfhSnTb0o++Ec3gKuVQacE1LmqIEspBULH7iIYYx
	qjDrGIQx7vCwbxJAm38/z8XCyAikhaFPx+eaNAQUWhd1zrjzGWZjsSjytcDKau/q+jMlcc
	AltFO1fL+/gp4Mik87ssaQUFzcr5vvA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774377822; a=rsa-sha256;
	cv=none;
	b=ON1UVsAlPVpu+IDtyChVWGExgcoua7VLJnku2JUchicQCzaipxjSiQe0kUGIeti4jyRjkI
	YS2lRYOLEBIEDPC4Z5ySOuf7DkwQ/FWvIJepPuGTmt6sRQyDgdZJQzM3/Yy+kb2VC9nN4j
	HA+HApz0f6TPn5RuSPWmT+RfOwQEcY0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Qp9yLI2s;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F9884073C;
	Tue, 24 Mar 2026 18:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F1DC19424;
	Tue, 24 Mar 2026 18:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774377821;
	bh=S0aEBB6Hs3Vms/fOltqD3iMe7jfXUYvj08ux34yihS4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Qp9yLI2ss3h+ai6f5OaGy67x+J1yw4C6X8kNtrj8ChIAW3GFIuh4oHiazxaH/uVur
	 yJ9fhv/K/ztsKhc6ijGjpJ9KA6vwyYau0Csg17eOA76SSxNLe3kU/O7HdupLv8J7s7
	 CRAcsYSiMUGkwcoPHzEElyf73w16pjlh5DXe9Cb4=
Date: Tue, 24 Mar 2026 11:43:39 -0700
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
Subject: Re: [PATCH v8 0/2] skip redundant sync IPIs when TLB flush sent
 them
Message-Id: <20260324114339.2c0777f7b2c5483281a15667@linux-foundation.org>
In-Reply-To: <20260324085238.44477-1-lance.yang@linux.dev>
References: <20260324085238.44477-1-lance.yang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6429F40002
X-Stat-Signature: h415pqud69hhd3wpaeukd17qjori9cqf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774377822-330511
X-HE-Meta: U2FsdGVkX1/4Y5aFxnO2G5fVz4D5R5SGSRnMSwgMYqdYuLe4XiA8ynh5OBpGORS2cBRyKCp36Fb5fpqdBXjynZD29f2r2pvk7H8YF8RaizCR7Rp9yzKhg4VW3/vT5y7idNZ+4wkF8Yi19Bi8uWl1jYHpMSeG3AxRbDhPkNE1HKfalK9lwB5Fo7aNrVouNmkUu8T3i+EeY3tiNqAjjHamQ1znDzRfSVQOtHOphSeMAFtIXQmDSZIxmp0y+M1A4cDUdrlsHBvLy8q5Ld2VlLcwl2J3kc0iwZhPvwA6i0CRE8poDB3pnIg61Injrm30KT8hQL7vzlO6QWJwRwg9Q5WhtdUhzG7FvPeOujj0pXzeSoov7sFhC2xWF4Th52YQUWEmEa8Wz81H3Os5PS+Z4AmVgI9rgKg44I+RFCDBH8FtG6mdZZLrZ2il84boZinbjHqKV8EFS/utHSEbUT6xX6HGeJIgqen9AlBbiDF99XR6m2uHn+9dXr9xtDoBuDLhByn9kUyPWg6/fZ1LfiAdgR2ENzqarxBEt0QGTP/6QG6NiczJp0E7rHev3lAV2O/7pEQenRZs+Pc4DKAZgsL1W6vRSXUs+VV3M/Wg7iel/h0WMhkb8le9LST0F+cGYoysi2BBQ568vmEKHIG0ptLFkfoa6PeUiGaKz4D5GloWOn4a6vWRgfK0OEiAos1Ru0JVLEKHcYINfn/grtS+fvuZ5DjZSQ1oTXdA5EYHCECQAMNCJ1+dBZuBzbJCgzzxK/DvJ6O9j54l8MZy+gN9lbZ6/TiYdbNYh97zBM5kImSY87lVtrLLLEJQleba4SYilJmukgFlIN/S0a1F11isec+SZAg8GdWQiqb7teu6a0rwGKctI36Kp2iDAWSBMwMbep7+H7EPz2XGRPRJnb8pv7OzCXdqYnOyylnMl0kFiS2LtN9MvOClhXY/k5gzAH6AzQBg6BluZogLGTqTT9x2tB2YW6F
 mMVxKFw1
 Z8pnI48dpcTOAcOLBWH67x9vgTjaGgRorXzOLifiOty+QcGJ468NGfO/KGGRUbQxp7yRvnNoGCm0TzhgIczbpVst9TR4jqDQTjjwB1GlZQPLJw8D3Z5L3QMFtwCO0BuCeoc5UHvlLPpPj+gZk/VBoEQn0ptsIdf6vwjrPD0w3KcT+TbZ697jm+cMLshQWZ3BcMybxwG0expmzV/yNnTKO+OPvzdCknOkFeyCSdKQPoIwk0/gGv6O6GLZWTlkaGLEPjEeo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 16:52:36 +0800 Lance Yang <lance.yang@linux.dev> wrote:

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
> On a 64-core Intel x86 server, the CAL interrupt count in
> /proc/interrupts dropped from 646,316 to 785 when collapsing a 20 GiB
> range with this series applied.

Well that's nice.

Which other architectures could utilize this?

> David Hildenbrand did the initial implementation. I built on his work and
> relied on off-list discussions to push it further - thanks a lot David!
>
> ...
>
>  arch/x86/include/asm/tlb.h      | 18 +++++++++++++++++-
>  arch/x86/include/asm/tlbflush.h |  2 ++
>  arch/x86/kernel/smpboot.c       |  1 +
>  arch/x86/mm/tlb.c               | 15 +++++++++++++++
>  include/asm-generic/tlb.h       | 17 +++++++++++++++++
>  mm/mmu_gather.c                 | 15 +++++++++++++++
>  6 files changed, 67 insertions(+), 1 deletion(-)

Can the x86 maintainers please review these changes?



