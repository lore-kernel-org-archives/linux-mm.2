Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50B60F532E5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 06:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 827C06B00C0; Tue, 24 Mar 2026 02:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1966B00C1; Tue, 24 Mar 2026 02:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679866B00C2; Tue, 24 Mar 2026 02:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4FCF16B00C0
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 02:14:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60174CC38A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:14:32 +0000 (UTC)
X-FDA: 84579942384.05.F9A0483
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9DAC51C0004
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:14:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hnT6R2oX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774332870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ICRwvZNxMVB+eDUAUeHAtU147HuuApF1zRxwwY2qVB4=;
	b=0BI+1LsKjjgQ8wSwp7jLbfUy5r3GI4cL+WTXfyYU5V6Iabr9F50QgwmAgPg35t8SEiOfF4
	vJ/dBjTfumILlDmeF0SWIOY7FuJ/B4c8FnLpklt57UhkpHW66Fyn83lWYAnUUI5211CNyt
	zaADijTiM63PipuLua3O59NI3POcQ9U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774332870; a=rsa-sha256;
	cv=none;
	b=PT3m/vesYW66C2qENzAEtpcVYf65HUYYSKVssqd86MmKIYzGeGOxsuIqqMaYA/TgH7z16C
	yiyzbveE+2jTDNeKV3LIBz1KMRB1uvfzAkg+KF3EH55NzXuwaKD1nqyZqzjxpAnJdclCSY
	NKpTK/HXi2Z7sxtOAx73b3VCbalZWWI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hnT6R2oX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774332868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ICRwvZNxMVB+eDUAUeHAtU147HuuApF1zRxwwY2qVB4=;
	b=hnT6R2oXEZmInaXSy3cUMJ/hU2EBTkHqrDBMOTe86YmiKmkBh4ZMxGwIf3PT6Bbodw5rsH
	zp6vfO4HhkUvXVnkryl6PMVzOGOSTIkhVAQ45c8jFi4YMTXWmFXvOOAep/e0TNDHsvvvoc
	0XvhJ3OfAPbCQDqd1ZxdNUPU56+eQf8=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: lance.yang@linux.dev,
	peterz@infradead.org,
	david@kernel.org,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
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
	ioworker0@gmail.com
Subject: Re: [PATCH v7 0/2] skip redundant sync IPIs when TLB flush sent them
Date: Tue, 24 Mar 2026 14:14:19 +0800
Message-Id: <20260324061419.48613-1-lance.yang@linux.dev>
In-Reply-To: <20260323135317.0b702a575eeef93332ba2519@linux-foundation.org>
References: <20260323135317.0b702a575eeef93332ba2519@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9DAC51C0004
X-Stat-Signature: b96g1mhdhq6zah6btktytso4tzfxc75d
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774332870-624244
X-HE-Meta: U2FsdGVkX1+C6c0ZjL17WHO+Q0V16Fz6dVJqn3/6VAwYrO7PeJvI9Y99+v22rHBz/u3f7BX2CnmltlMmktuvKe3h3WGID1O+vol6Rw7Fz19b2dUgV8pKglGz8IUBCZNVGH+J/WDUyDSK7ZdUsTJcHkBeCVBf3ANyRPihYutrhg0PTD0FgBHH1c8f3pCOy4i+BzG10hdTywn8qRvf5gRPM7j7xNNt8+gQxDJNsoOhdOAWdYdtKyjZYcx7tZ/Ld01Y7XmPg4TGcDattMPlWnK+gGtB9iSwW9XMpAF8ha7a/OkkIuf8hdyNr42/UoBHohVFLexkgoOgz2bx8OyXa8pwEuyeDWqg3YTdxki2VMMI9HKqN4wfqgT/1q3dkPtN897xXF4nbwn5ByCQV4S8it/s6U9Xub169GZzeMNTBVkablhkmJXP333RSjSQkngOYebFj3X9x29EZ3oGx+P0JVNPmIRSfiGU0hBDiTn8tscEPFOQIvoOyHtQyj5yfKve7Q9Qto8RqqNh7viTAFgcIheSMQAaYbjj2vXXIaWhq/4EhHxmEarN/C/YnLjb2FYATszz0M978KxpgYy0EI6vaODOs38tgo4v16G7Q2eyq3DcpP5SJVZ5dax3qpydI9CdrNG02/Re6ZzycxIoTY9b3qqAc3oGBG/K6lGy7rQ8ytYYETGc6mZTroNAgY5Q+bK6jO5j4C4p2v2zol1qT9v4cQTR0Axgdx3rNDMayuLfO+WsVhjDrwoUgBq1UNtoOrlSltFD9Gen5b4sYsaD0iBb5LjXUoxyXDRE/4AW/pnAh7BUqnbd6ujmSgr3s8uoIl1/A7gDpZwf1DRG2dmHuYuS0rfGYs8N8uLBgboMERWGoW/nVpszUjcuE/Yby+AA1z3TiYtzsJmoj/rw/BipYxDP0htlwQuvuX2hrLTPNlya77VHVgtKukmlyVFgMSNdLmRPv8FStWv+VZ8ovJWphL8h5lb
 m+Psbe2K
 wbrZJBEImMJterv9X5xvUrRLFErXvHKtU6rXz71aOGBTldRXZs3Pa2i4x4Do7HrsZE0Ga2hEU1z4h3G0QJ6M4Yph4hmTFLsDMfUTu8A/LmuMUJESFCJWZVRekhEhXM6j1XZouvekQ/4KQnXKhG9qEHK0QmO87atd8QTQGngf+hxXCiEtc27oTWmCcjPl1BHdM9/Zo54jTUvnCDooZS0/qUo9dVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Mar 23, 2026 at 01:53:17PM -0700, Andrew Morton wrote:
>On Mon,  9 Mar 2026 10:07:09 +0800 Lance Yang <lance.yang@linux.dev> wrote:
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
>> ...
>> 
>>  arch/x86/include/asm/tlb.h      | 17 ++++++++++++++++-
>>  arch/x86/include/asm/tlbflush.h |  2 ++
>>  arch/x86/kernel/smpboot.c       |  1 +
>>  arch/x86/mm/tlb.c               | 15 +++++++++++++++
>>  include/asm-generic/tlb.h       | 17 +++++++++++++++++
>>  mm/mmu_gather.c                 | 15 +++++++++++++++
>>  6 files changed, 66 insertions(+), 1 deletion(-)
>
>Kinda straddles both MM and x86.
>
>I expect a v8 based on David's comments.

Yes, a v8 is on the way.

>One merge path is for the x86 people to take this, noting David's acks.
>
>The other merge path is via mm.git, if the x86 people can please
>perform review.
>
>And...  mm.git is basically full (overflowing) for this cycle and
>review/test has some catching up to do.  So I'd prefer to only take the
>important things.  This patchset is a performance improvement but
>contains no measurements to demonstrate the benefit, so I'm not able to
>determine its importance!

That's a fair point. I should have included numbers from the start.

On a 64-core Intel x86 server, the CAL interrupt count in
/proc/interrupts dropped from 646,316 to 785 when collapsing a 20 GiB
range with this series applied.

The larger the system, the more costly redundant broadcast IPIs become.

Thanks,
Lance

