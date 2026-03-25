Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD5F103A99F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 02:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4DE16B008C; Tue, 24 Mar 2026 22:43:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9926B0092; Tue, 24 Mar 2026 22:43:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C6076B0093; Tue, 24 Mar 2026 22:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A25D6B008C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 22:43:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10B6559D30
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:43:57 +0000 (UTC)
X-FDA: 84583040514.28.E3ACC27
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1911CA0002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:43:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JqJYxCEq;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774406635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ei/9l0yY7Rn5LSa4qZLzjXvD8FXeXbiuykIdzrEGGI8=;
	b=ST32nXJQIJvbZatPEZRYsHDsiTYeyDsnpc8/C8G/E6c+rihUAA6JMrKCvaQ4BBkHSCnlks
	2Ldoz8xBY4slCINxPGoavQzxv+GTUj7/FxdjEZgqnu/AUnMV1pfHs1fRt0KKyUVAWZQKmh
	Hxqg3/Kla7FRKsEAlqqIiq4WSlansak=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JqJYxCEq;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774406635; a=rsa-sha256;
	cv=none;
	b=4fqvefS/k26qNH81kkzM+bJKWxV2oO416aGEW/Bzw6OeiyccQaj31tCMgHF4hTyL8K+zGV
	UlLbvv2YGshxny0h3IVx167g5sIiizsCz2exxtICJVO7pojQRE+gEwAOaSLNEPjgT1aPHX
	NTyEKR/csc/3SUJyjw3Sjn8upI3nq/0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774406632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ei/9l0yY7Rn5LSa4qZLzjXvD8FXeXbiuykIdzrEGGI8=;
	b=JqJYxCEq+lrhrLpLxEyPYrKajW5e8CXwMDWT8tH66YKkSs1lIqcLLBSimJDzH2ilNjg2fr
	XqMyL9OU6mgfjoBf8JGd1h7NnAf5wUyg9Sl9kJtncCi0D3BfYneybyTawTqCbvGyi29LLu
	TyhR/3ijGiBXv1xiv7Di0IYSdgxmA4Y=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	peterz@infradead.org,
	dave.hansen@intel.com,
	david@kernel.org
Cc: dave.hansen@linux.intel.com,
	ypodemsk@redhat.com,
	hughd@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	jgross@suse.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ioworker0@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v8 0/2] skip redundant sync IPIs when TLB flush sent them
Date: Wed, 25 Mar 2026 10:43:37 +0800
Message-Id: <20260325024337.56681-1-lance.yang@linux.dev>
In-Reply-To: <20260324114339.2c0777f7b2c5483281a15667@linux-foundation.org>
References: <20260324114339.2c0777f7b2c5483281a15667@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1911CA0002
X-Stat-Signature: ch5af7amzrt4qpq75t48ppbmt79bksqg
X-Rspam-User: 
X-HE-Tag: 1774406634-751087
X-HE-Meta: U2FsdGVkX19ccz1Y0mi8kE3HtlOZIGqxisHFZ8nxoaqRBZCzXHIfOvfcO4rOmHfLapH93/0YtP/xZ7h2i3XqvGueRc1AAl+4eQ6J8V6jpcl5lWc3Vn1TB6ZP5j+qVSNl2/Pde36gRIDTFYRM2E57FnlfBq2i+Lw14aXS4cBAnlD6lQWPcybQzHddfesMukbqCHYYW0zVdyuP55YK8xHewDWJ2yyc56YDxkCDtITP7zj35h8QMobdD6lawjcmYANqKJpIxyEZD5NXzoD0hidM55sPRM+tTPdnqxLwWaGu7UnC1ODHvd6zqjELkhMd0EfOD+EWm2YF43XHSaGNxVQsDhDzlftLnoLj73HJZG+mPbZQ+EYe/jwG1DTY0N12vE7xMWM4KDvp1uRrPxAr1I4WmEqBBOq/mGr7qBQ/yGMB1A23bXMa8Pq3fq8SZBqzFomacoN4E++BtQxj10FGD1GchLBOgUP+gF19edt2ipHz0uxEbKkkON0XK1N8oy96na2nBESXwOA/Duj7JgTcGcOPaURzkE+6Tjsu3kvW2CHgWSyWkTUBN0/ukx1uG938g/w/kgPvI9IEXuEzgapBA+Din/A0U/LXyhunf7v/CHrNWBLV/YHvbsmoZr5xCYv3lWbluyF2CqLJS0tKStNETiSOgCYs/aZ909SsL4qHCM+Jrmj4TZqiVF57THcz9jERZBb6WPgYhVgLFDD0TyKN7o2BrJXaUrmoo+hW4Pi+bvEzh4DJ9D8rqBxFiY2vObBJwVFd9lDs1JIJkQXfk4O7eF1UFRdUAWOaA5W6iT9ZEAD26emSB6uM6gMTIa0z7xLUYrC4ot1Cbknjfv1EmFu+nTeZg4Gbs5Ns54BtOwzfNsyEEkh9Tgc5f5RGE+ibKgo1ATl/czqwMLlUCGPdEB3J9HSih0UcX7V43iwXHBoh5sV6JUKm47IRtFMj3SgS52LnNFOTzHPGomTh6/tLEQksu0F
 vnAT6iSS
 dy/n8pdN5DpHAddzg56IxSzgiBNrOd45jmjYTbFrxXaVnMD1PD9WtFwA8H3gLKxUMQA0iyeWTq/iMNQnOFyDGmCaO4D5eemo6QN2Ac5Gxfj+7hsKbIB248A0YtCni3Zod5QZmh1x8523QmC8u81bmKFIYVrLCAF7jVlDPpM7gr/7gHQxToYFXopjW28cz2bnp9BrWCnQlJs+ugDdWPyQ1rljF4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Mar 24, 2026 at 11:43:39AM -0700, Andrew Morton wrote:
>On Tue, 24 Mar 2026 16:52:36 +0800 Lance Yang <lance.yang@linux.dev> wrote:
>
>> Hi all,
>> 
>> When page table operations require synchronization with software/lockless
>> walkers, they call tlb_remove_table_sync_{one,rcu}() after flushing the
>> TLB (tlb->freed_tables or tlb->unshared_tables).
>> 
>> On architectures where the TLB flush already sends IPIs to all target CPUs,
>> the subsequent sync IPI broadcast is redundant. This is not only costly on
>> large systems where it disrupts all CPUs even for single-process page table
>> operations, but has also been reported to hurt RT workloads[1].
>> 
>> This series introduces tlb_table_flush_implies_ipi_broadcast() to check if
>> the prior TLB flush already provided the necessary synchronization. When
>> true, the sync calls can early-return.
>> 
>> A few cases rely on this synchronization:
>> 
>> 1) hugetlb PMD unshare[2]: The problem is not the freeing but the reuse
>>    of the PMD table for other purposes in the last remaining user after
>>    unsharing.
>> 
>> 2) khugepaged collapse[3]: Ensure no concurrent GUP-fast before collapsing
>>    and (possibly) freeing the page table / re-depositing it.
>> 
>> Two-step plan as David suggested[4]:
>> 
>> Step 1 (this series): Skip redundant sync when we're 100% certain the TLB
>> flush sent IPIs. INVLPGB is excluded because when supported, we cannot
>> guarantee IPIs were sent, keeping it clean and simple.
>> 
>> Step 2 (future work): Send targeted IPIs only to CPUs actually doing
>> software/lockless page table walks, benefiting all architectures.
>> 
>> Regarding Step 2, it obviously only applies to setups where Step 1 does not
>> apply: like x86 with INVLPGB or arm64. Step 2 work is ongoing; early
>> attempts showed ~3% GUP-fast overhead. Reducing the overhead requires more
>> work and tuning; it will be submitted separately once ready.
>> 
>> On a 64-core Intel x86 server, the CAL interrupt count in
>> /proc/interrupts dropped from 646,316 to 785 when collapsing a 20 GiB
>> range with this series applied.
>
>Well that's nice.
>
>Which other architectures could utilize this?

Thanks! RISC-V looks like a candidate, and if I get some time I'll dive
into it.

>
>> David Hildenbrand did the initial implementation. I built on his work and
>> relied on off-list discussions to push it further - thanks a lot David!
>>
>> ...
>>
>>  arch/x86/include/asm/tlb.h      | 18 +++++++++++++++++-
>>  arch/x86/include/asm/tlbflush.h |  2 ++
>>  arch/x86/kernel/smpboot.c       |  1 +
>>  arch/x86/mm/tlb.c               | 15 +++++++++++++++
>>  include/asm-generic/tlb.h       | 17 +++++++++++++++++
>>  mm/mmu_gather.c                 | 15 +++++++++++++++
>>  6 files changed, 67 insertions(+), 1 deletion(-)
>
>Can the x86 maintainers please review these changes?

Yes, an x86 review would be much appreciated, please!

After commit a37259732a7d ("x86/mm: Make MMU_GATHER_RCU_TABLE_FREE
unconditional"), tlb_remove_table_sync_one() is no longer a NOP, even on
native x86 without INVLPGB, so it ends up issuing a redundant IPI
broadcast.

Thanks,
Lance

