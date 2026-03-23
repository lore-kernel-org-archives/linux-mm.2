Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB87CEC01C8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 278646B0005; Mon, 23 Mar 2026 07:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2292F6B0088; Mon, 23 Mar 2026 07:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119026B0089; Mon, 23 Mar 2026 07:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 000EE6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:04:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E96D13C013
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:04:24 +0000 (UTC)
X-FDA: 84577044048.16.1C7F320
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D2E7112000F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:04:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O8uzlx4d;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774263862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P5gRVqF448GHnNH5vLwSdeqUZDPsYhOzcnBdu+XA+is=;
	b=uQTvSSHwHsulx/3yZ5/BJ7rxjKmneR5U1zenVEze0osWkTAbinftNEDdfAO/XnPCoYdiBR
	7kgziYwCOvem56ibqgpn7xxZi30OaBdqPla3vhc+TFmb6smlsX0eKaGGTO3fvnz2vEujeD
	ZS7iHtlxVtAM05BhSwypD8t0N2CINPk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774263862; a=rsa-sha256;
	cv=none;
	b=g0icg7odCNUVD0yeAmy78VIJVOEauG7erEuWlzkZU87MXK0iU9xpMy9i0g7HxPsbj96zci
	pY931vN+A+xc9PeBvpLvWkzWllz/hHxZcPqdL0VxCqmyzpyZddUwd3qzT0uzG10tNgKeMG
	FXoFQcwmt9iGZBrVCaw6oHH0Q4XKg0U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O8uzlx4d;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 034C660051;
	Mon, 23 Mar 2026 11:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B458EC4CEF7;
	Mon, 23 Mar 2026 11:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774263861;
	bh=cZpSLIsH4XFvNpI5LDZxz95hRu5Out/Dx+WnDsOPv7Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O8uzlx4dv+oYAEjjcSqdVpXYZ8B1iP9u6eefUS7KnBdO1jV1nDLkt8M4cv+flrJ4x
	 JF7n9LdVHizBHwgYFeftNAhGfNvKisywSC2AaXUa41lyhkyqMUb8NppSToaU+zt0oA
	 UAtjne/8nIy5mv0bKnjNILw1rFYh6TWOnXJddrcLMCseV0/5HUCRM4Jypn9BKiYQho
	 iGxT3MH3lNx89NIH5zl8sSPrXHrzz9E9C/kMhCuZPS2bPCSZy0MuA6DTcYRzcfqsAT
	 TdXdgeuNufG5FxoEffzcSDEbgMga4n7kdNwccYNXqRFy5B9qmW8CcaHnCjmD2sCqFS
	 WZIMdntBTtMgw==
Message-ID: <955fb2e9-b3f9-479a-806d-79877635816c@kernel.org>
Date: Mon, 23 Mar 2026 12:04:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/2] mm/mmu_gather: prepare to skip redundant sync IPIs
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: peterz@infradead.org, dave.hansen@intel.com, dave.hansen@linux.intel.com,
 ypodemsk@redhat.com, hughd@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
 arnd@arndb.de, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260309020711.20831-1-lance.yang@linux.dev>
 <20260309020711.20831-2-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260309020711.20831-2-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D2E7112000F
X-Stat-Signature: 51388o8djsmbxechpfnddws9khq1oh9t
X-HE-Tag: 1774263862-386169
X-HE-Meta: U2FsdGVkX1+LF4oYsvAvlTziT2+czCIPPWtUXAr4Xw32YM/ngE7TMqSkeF5d847e/l0PmMD/1XDyo2iuPWMFqH17TH5Y/3myH9A804z9cu7Scobl+anxhyusZAzKb2oYGjCSwXXzmrLzAPBBpQoAEk0XPtRnwccWL7vxhCHoK+E5mtcNRVn/glgiz+hV7fqB53g/yq15md05+0HpAEKa72mfNM/gtFEJzZx20Xi5nd6AuiH7b2uj6tTTJULQG3CuR0+FvcGkCkIJAu4L+Ufhm25V/UdCzQmouNzBZcm2RqNMsxz9D31aVltQQejqxhnB5BszW9KY+V4Fr/hpsmTkTjAOcb3pCCPty8asfTttBWyTfLbrdI1esRLTDXQ2mucjCk8hntt8HGKNmYAbQlW09TOJBS9fT89lfPcbkEhqat7cTgjCr1773V8CMdiKfrBbbxOLZXRjqf1EvEtfi51QB7ZSY1zzvlkompjt3htyBPulsE1U5cn1FIYMqoyF7VymKzObVZTsnth8Xzsj0y9vBnXCuRNJuaws6RYSS0PXPDsQpsVxJ3SNofPVlUfqo94HIIJejSi672o/qZvZtrrZVeSxPOUCbI0dB9on7sLU82dcmcze6YqDvtpt0+27J33lX9F8h+X+qOygh1cOfQ07RNCjXeMb36/GRrj1xF/pVoyGZCaOc8kiucMCnpQvKlDy7gfGbHmEiOjTslqT4/h/HSI42U+92AeOR1th/+L8lCFEJMqm6vDwGYKHOqYyyWk6aIzJCwkjrH9h9IOlqWFf8YOp4yBcyhcKQd7W29utd04HfTIt0h2x4+x/c4sZiyf/zKCQd9cdk3oAbN98cvKofgDDwBzPABSA5vB2yhVbw0YO6hhPyudZqD3p28sGg/W46t4Kn8b1tZD5h5NIfJNipr//qFewbE3aQ3rrvursmBKypNtnCR6H17w/tQxD+EX8/Hb+HMsfazu2FPXLMmx
 fjq4Le4E
 wKN/mxjp/D9/ddizHcndE+1pQqZFFjhP7qMOeL6gtjNHhI0RHz+w1gUlYAZVeX8R0XzeqPpH9rpzHh4GXh4HQVjIvFkEmd4NlO/jQN1UvWsySXxLq1cp8bUSUDA3A+8Eu8mou9+mDuG2gg+NujkYNu9D8smzUSwXR4SvcXAWwFu9ReDLl2gdT5Yzicw9nA5qceqhxZ4jUNZ74mJGsg8M87jpu6rLjybxb46LHl/fl4BIOynu7VAzv3qFYvydKvM1bPo+zFucm8Zq3h4av8IosgHLaDpeMKq3osH8SZr9oyenluTfZ8goOBTPQQzgBRyY7R6ktBP3rUXpvykFleVfJQ4h1tEnNSul9gx4WyWf9iQzu90I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 03:07, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
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
> Introduce tlb_table_flush_implies_ipi_broadcast() to check if the prior TLB
> flush already provided the necessary synchronization. When true, the sync
> calls can early-return.
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
> Currently always returns false (no behavior change). The follow-up patch
> will enable the optimization for x86.
> 
> [1] https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/
> [2] https://lore.kernel.org/linux-mm/6a364356-5fea-4a6c-b959-ba3b22ce9c88@kernel.org/
> [3] https://lore.kernel.org/linux-mm/2cb4503d-3a3f-4f6c-8038-7b3d1c74b3c2@kernel.org/
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

