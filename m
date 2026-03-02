Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38172EB3622
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35246B0005; Mon,  2 Mar 2026 12:35:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5216B0088; Mon,  2 Mar 2026 12:35:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7846B0089; Mon,  2 Mar 2026 12:35:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75B396B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:35:56 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E4A9139FC9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:35:56 +0000 (UTC)
X-FDA: 84501825912.24.C336CD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2B539120015
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:35:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EPqYvCqV;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772472954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U6gUT5ouHHMBICtOGLkFd9bsOB9nAcU+1+8zvo4YUr8=;
	b=IRCTGt4Nch/hEfOFr8KiVKkcVRQXgPq6mPz7iTzkmnD+smXAdD3DpDXY8biBxLd1DhO4rt
	bRNzUdZGTnxjxacXHUl1AYI2zduID4NsovhLHg+kOIK5Hv4llPvocAw2YfFOb4aXHrirSk
	NmC5ktcAVdGaVglTJT/ZUTP1jOw96oA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EPqYvCqV;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772472954; a=rsa-sha256;
	cv=none;
	b=apfB2C8duNa6X7EwDtkS3YwqddaIX7/lILddiZVm/OAx1Q9vtnLvXVecpNLy+bOuaYhtxn
	O2UBMHQEZz8Wvp+/ksGLmcR6WDwZQZMVP+NJypLSIGETF/chvNojTwH7YmYk4FPiZGIR5G
	RKyrwUctNTk7xWk13GPUL2V2AaqU8mk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 22E5544108;
	Mon,  2 Mar 2026 17:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1423AC19423;
	Mon,  2 Mar 2026 17:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772472953;
	bh=yOd4guL7b619CYCfrzFj0ifBAp6YAdyKNrES1KocA2E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EPqYvCqVglk5IX8hCbTrnZYFIhgj8BG92iDXwl/4tG3cqv2KMgNu6lvhB/TPRz8J+
	 xSkezFZFmw9fBNKyjPViUibk6VTAqus0MegRYiqx/MDmXg/Re2HnPYpW5gcovgDR8P
	 t1kJrDUPSmLujrrttKD938XAOlS6fs+hbOKFas2kTOA5ddRYeKmKmKpbGpp4Xe3jah
	 NZ5tytujhuYIjn/oGzM60ua/RQZlcGWPN3avWOLSIefbnmheVDDibnhz50Kr+FnGCD
	 d7RRe/pw2hOXEcGFwjBl0JNhcRFSje9bHrB+ClEDuMm29jDG8jqXUlpb4XtqfHu+Yy
	 jhyfXi9FGPkLg==
Message-ID: <89d988b7-846f-48aa-9b69-c316f2179d61@kernel.org>
Date: Mon, 2 Mar 2026 18:35:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/huge_memory: Fix use of NULL folio in
 move_pages_huge_pmd()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>
References: <aaBVg6nPQz-WvyzT@chrisdown.name>
 <27c260d2-796f-48a6-8b1c-751ab172d480@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <27c260d2-796f-48a6-8b1c-751ab172d480@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B539120015
X-Rspamd-Server: rspam08
X-Stat-Signature: hhe54uihsfy895dxqtjzx3qdgbsrtb5u
X-HE-Tag: 1772472953-851538
X-HE-Meta: U2FsdGVkX1+OxEQVbUZJnANR4vNAAPtFfcMxzLxYdMMfl79HlNFneEfY96rONyIlzpR2yU5hiiHyDhQ3mxdG+G9h3mzDyt6WSZWHc0mchAxsKWSdrMHJPFRtYCf5aY6PkcF71+Jtmbhp0M8QYjoICVfQeEyVfP7X7ENHQxCznVA/OOGPF1emD4fwlWR6LBFRaf9tKlZLBquR0Ra8B3lX50RZDVxIzfJiwuprf6vT343U46VPKKeIkA08KiVLqoSByg9IkYmr4TjVkZhDnuZfUE3SOvd7c6F5UNWQc3FzFEzmLiq1k0XUiogmjygXaOtHUSsDVaUO/AxZvpqDs9xIa+MgqrZ3dqck7oCD7UDmpaqTUdZYFec7BYLsUPEySW6TPaVEbT8YmldhYDGhEc+LnYo2LeVoxFIpexa37s2yREg9GiFNFiNObVGxi7pgqXhKg0aE/ThDHOJdkerTl7/aI5l1UO7lDoRhQEFgxca2agKgraLubukosm837e7jA38X0G8bgta31DZ+nmfdVmZq0eFJAWc5T9SMAzRGuXmfZ23Kb/tVatCrRqdfe16pVoDnvyRa2LbklDokZCX5NdoluNV2Yb1f4nHLwfe/X05zGuONtKMDIsMvE2BIgAMRO/SPJCafwedxRPcqxvs+fIRzuzAgg1+dE4lI2pPpiR/OMLa8iOQ1q2qsR+B9je6wcz28qnOH2qvhxVRYaxOvTh87vZLheJqMEh+Jy5pJXQ4A56DH9dZVN9Nrwa6HY1XLVFEcQWC1aiJT85UNcNAzkqKLNPKn/2M9B1CD+PKHGvjfnQSGyU1Et6mmabRRDtpE0DmTP6zUnHZHdfRu5eYRkExrGEMwhVQgit+ncP1r9YU35katELlnvgf5ir2SqZ9Kw0r0gcFtKDLP18A6EibccdjgrBvhvFRId6+9la+ysWTj1JOxrGjTAzPfAFvsBZ1jJiEijZXNOdKESU4vLQb0QI3
 lDbod6M+
 Ft6dreECluDEq3gmrhEyK7h4Ky6UDdRh9gQkOoFONjCHz6rubQjj48thZEupSj/fuetl+inikxi7HoVjWEkxS0yvtLOgqlgEIyd7QZd4h94ZVyqUHTogJSiqQiCQNFc8Z1rt2EdIVaHRIM0b6xxgw5lhatzHBw5+p1NqZvdhMQvptQorD/gBPDW3l2kkvTkk7kb1nQtTdw3zd7k1BtB4VZQLSdceZSQeIgeLsLZ0AwuWu8dmvRFqWli/d9/4iRSs7pEeCEj8Ty5QDFNSg4vhPZlWOPxEHemeqAaGiqyUcDRcAOUZ67YFD4LL2T3dOi8CnV72kWldW8Pydza4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>  mm/huge_memory.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 44ff8a648afd..fed57951a7cd 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2794,7 +2794,7 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>>  		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
>>  	} else {
>>  		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
>> -		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
>> +		_dst_pmd = folio_mk_pmd(page_folio(src_page), dst_vma->vm_page_prot);
> 
> I prefer my version at [0].
> 
> Cleaner to actually pull out the zero_folio into a local variable, and also we
> should mark it special to be consistent with other codepaths.

I argued in v1 that we should handle it similar to an ordinary move
during mremap()->move_huge_pmd() and not split it over two patches.

It's still split over two patches, which doesn't make sense.

https://lore.kernel.org/linux-mm/0b653dcd-842b-4360-bc1c-8fe779efbc23@kernel.org/

I don't think there is no need to get the folio involved at all if we
know that we have a well-prepared PMD (zero folio, makred as special).

The less code we have that has to deal with setting PMDs special (and
possible messing it up), the better.


@Chris, please make sure to CC all relevant maintainers (I didn't check)
and send the patches as a proper thread (e.g., through git send-mail").

-- 
Cheers,

David

