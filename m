Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E108ECE9D47
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 397A16B0088; Tue,  6 Jan 2026 10:19:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34F206B008A; Tue,  6 Jan 2026 10:19:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223D56B0093; Tue,  6 Jan 2026 10:19:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 131656B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:19:24 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C2B511A02AB
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:19:23 +0000 (UTC)
X-FDA: 84301897806.27.1F46B0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E7ED4C0013
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:19:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZzFBdx/W";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767712762; a=rsa-sha256;
	cv=none;
	b=wlrHg59+DTqaVubAxQ1hnAbZPMg/c7rrFCf1NyQRLbL5ZDXZu9ApxdHQXG9PCWN15vB9hu
	3fRNjC7Q5MAId2fF0f1H+kcaTVNslEydsm29u3y4nDQnZmoA3FJF0ikgVIXdhGoWtyiESa
	mhXlAxZljarH6da1BavFEHOS+IOpSBQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZzFBdx/W";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767712762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgfgbctUF7kJY4GbHAbcNmnHQc4AiPPCBiRwo+2uenY=;
	b=1M/KFo61SP/2XQjF0BqRfR36ZK9IVWgtGyNX5ACbadfIqxe4JFyKv2nX+pXOQBJCQX1rO4
	ipYoBxAAKkUX5bx0l960HqWaRCt4eIqBbt8ussCPpBjRZ6nHwHqcZd9YtmVGjCn9rMNMmM
	O0Ike1cxWoh3jAhdNrxr7t5EnjDJ8YY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C2245418AD;
	Tue,  6 Jan 2026 15:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C849C116C6;
	Tue,  6 Jan 2026 15:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767712760;
	bh=PQWjEY27AuDHc3U5eemh0TiBpvWBZ7jdK/tSG6xBxCE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZzFBdx/WI2GjYmhcvi6yp9/4UwfmyCrys7P4UZIgj9FaT0LKyStePM0eQWcUtCvvD
	 /V+gKQvG7a5yrjBvfP3OIZyuMzZcMET1RTxKDveQdPqP4J0DZItzZPPXMiwZqRJxTH
	 ltE0xzEPK4GVmb4gMdVhyH8bNy3BF0lQYPQpov9PLICaPs60edviHqk09OlDoH0xPd
	 a5h8A4YKZAZYXLg467JE6rI21qfDDc21DmskYYRK8VOMlItxTnVkmGU0o2NZ95NM05
	 pmZzeKuBl5AVnS7gEx1hfB0qvpQtQU6tW2wcirPpQZSWcVxB4fWJg52P/EadhVBR7F
	 KN8vizOZoWdiA==
Message-ID: <da1e8a00-99fe-46d9-b425-c307ea933036@kernel.org>
Date: Tue, 6 Jan 2026 16:19:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 1/2] mm/tlb: skip redundant IPI when TLB flush
 already synchronized
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: dave.hansen@intel.com, dave.hansen@linux.intel.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260106120303.38124-1-lance.yang@linux.dev>
 <20260106120303.38124-2-lance.yang@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260106120303.38124-2-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E7ED4C0013
X-Rspamd-Server: rspam10
X-Stat-Signature: pg8o4mncfzrcp1g8z87a88mt9bdhsksm
X-HE-Tag: 1767712761-879577
X-HE-Meta: U2FsdGVkX1/he6o7xxkGx9HxqCwQyVkkUUr0PkrVqruPcSUR2HEX1fay+409basZS5rCxBgsX2NCvEKo8/dK5fAz3D5vHiQGdxAnDsFYIinLuaDzb4O3+ANhqvA9EXsgeph+FJE/TUhlSBCEHNca1gpKEhJrOgGBweDboNErCDxC8hMq2kGXTWWgCbf4mHxgAaBwygT8va/vLDUAXNaxxnHXQrsjGZ46jgVMhA2LuARDLfDc+UC6ktxmhyDY0+4XXbvoxTM3oD1M6rMktbSsI4Cqq1dSN1euPW5vMdemfxfNOI+8U6/FwpMQSV5PX1xnYsNI0jWTyx43oLZ7IGYmaPiggMQwlwwRmVYcu920GK666vdOBA1rKpvc96uC45riZBuvFFmIs/1ZR4TbSS2N9brODswYnHdbnpMW6LGq1oXYiGFNL8BohtMP5IyeY91MAAoshfyV0EU7tciWhsKWpeZL24ZG+hR6Ze3eud7JT/AJ3ILNka3fLn4pWosLC2VhC8C3SbEvlNNW4fv5G/F+aqXZZIrx4lbUnOT3S+1SDGjVJrHcxJK4N1cOQJOg6BNWpV3AAQX3O7tZD8ei1BMGEq7hzBIfAHQylBALYg6/xHuRb4+vZnZTfyBaKmgnhFs8BCHKMl0nH7kJ3DgjsuEaptT/JcguK46ZLG63WZHbKRrC9izoaP6N7R8LqjyBHatyHthpBirwdKTLeKn9z7n6dUPRC+yHGFm82WR+1UupuHYCjPzXi/RlCASovlXjwRy9NyqtmmD/Bjc7pedn9CwyhS/Ez2uQRc94ovP0RDIEBM3I/mr9ZgUhPzkbeCjP87hZz7eLhMrcmUNhGPla2Hvve3szFenAqMV/vBKjYaDP5kaIhYFZSPg41SXcq009L/nRfYOpeMyR17gw/qRbopWnmfNPRQ5yX2zj+dDfRBFjJU3uuMS6tYHNJi6zqxYB5n3+STmERU10bMMxAg+cNBj
 HiL0vVb5
 ikGnLWemtNZHj7Q7DG/8lwIOoWMpHsPs2oUp7finurjHXeLOMelwA6zj8J8h5q+3owTJuFnauWSLZRjCbm6gIk9bTJ6KiExtQ5ExmIm1iRb/2xq815KX7zZfE6xenhccobdBTS1G6a4eGvdrjUPzsxWeakR6wB0rx+FTmPqtAs4/QQion7yZhcAuqB1zbfrMVSMuRyjLfvLENHci3dwG4/DEaTs6Vba9XnA3XtkAGvbFhqK670iJ/vp2I7OM25kQErokW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>   
>   static void tlb_table_flush(struct mmu_gather *tlb)
> @@ -367,7 +378,7 @@ void tlb_remove_table(struct mmu_gather *tlb, void *table)
>   		*batch = (struct mmu_table_batch *)__get_free_page(GFP_NOWAIT);
>   		if (*batch == NULL) {
>   			tlb_table_invalidate(tlb);
> -			tlb_remove_table_one(table);
> +			tlb_remove_table_one(table, tlb);
>   			return;
>   		}
>   		(*batch)->nr = 0;
> @@ -427,6 +438,7 @@ static void __tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm,
>   	tlb->vma_pfn = 0;
>   
>   	tlb->fully_unshared_tables = 0;
> +	tlb->tlb_flush_sent_ipi = 0;
>   	__tlb_reset_range(tlb);
>   	inc_tlb_flush_pending(tlb->mm);
>   }

But when would we have to reset tlb->tlb_flush_sent_ipi = 0 later? 
That's where it gets tricky. Just imagine the MMU gather gets reused later.

Also,

	+	if (info->freed_tables && info->tlb)
	+		info->tlb->tlb_flush_sent_ipi = true;

in native_flush_tlb_multi() misses the fact that we have different 
flushing types for removed/unshared tables vs. other flush.

So this approach more here certainly gets more complicated and error prone.

tlb_table_flush_implies_ipi_broadcast() was clearer in that regard: if 
you flushed the TLB after removing /unsharing tables, the IPI for 
handling page tables can be skipped. It's on the code flow to assure that.

What could work is tracking "tlb_table_flush_sent_ipi" really when we 
are flushing the TLB for removed/unshared tables, and maybe resetting it 
... I don't know when from the top of my head.

v2 was simpler IMHO.

-- 
Cheers

David

