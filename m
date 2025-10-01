Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D31CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 14:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8468E0005; Wed,  1 Oct 2025 10:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8F68E0002; Wed,  1 Oct 2025 10:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0986C8E0005; Wed,  1 Oct 2025 10:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBF2A8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:51:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8450B8106A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:51:02 +0000 (UTC)
X-FDA: 83949832764.24.E10205F
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7CDA84000D
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:51:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wLTN8hzQ;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759330260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=peyroWJS7GoK2qIOLHA/WAl/+DBXE3+j7/RubeBzCyg=;
	b=X0BllC+GfG5xzBtSbLg5LRTnUh1EJ0OeG3dC/6TLY/Wh8KXtlGYK04vlMIg1M2mNPOZkvZ
	X5cCUx/Re9Zj6C1UF6HG/3uwQj4iLlvaeK6QW72crvuil9moqbrhQOzmyIDNKivPuHosET
	PFll11YXxxnKythpr+V002LAHFGaPKk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wLTN8hzQ;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759330260; a=rsa-sha256;
	cv=none;
	b=z3fPGfDcdKnTBgHEp9+kmwVjnZ3/U07YCtZ+cRMFq0Eny7x06OBKSPMG7FEDFSBohz7Iki
	CYlvkEXXql+ioGY4yDZJa3c9VmcO8Lq1qkKWxSqTXx/n/eWReDBWwdeZmT0uAAeldpOYNV
	18BxjDnx7gPqsric2+qE/3DVBgVmjzo=
Message-ID: <a8ff06f6-99ca-439a-9553-831c7f8134f8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759330258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=peyroWJS7GoK2qIOLHA/WAl/+DBXE3+j7/RubeBzCyg=;
	b=wLTN8hzQb5ibEcje5wvyAqZFPwayPFHgQOKVoHX/1pmCCHZpCNuah4CA1ZluJHaPOFBnup
	DWPlQOnbSR0pbDhQeQQZIOftUznbLrkpgzUAS36rnbzdTa7kAOc4lFAW5lHlF5T0R4cz7E
	KczgHsbRyJFtVSx9tA5j1wD2/wLCDP4=
Date: Wed, 1 Oct 2025 22:50:45 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 ziy@nvidia.com, dev.jain@arm.com, Liam.Howlett@oracle.com,
 baohua@kernel.org, npache@redhat.com, baolin.wang@linux.alibaba.com,
 akpm@linux-foundation.org
References: <20251001142823.4050-1-richard.weiyang@gmail.com>
 <660dc0e8-a23a-4cc8-a9df-bef07b2322da@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <660dc0e8-a23a-4cc8-a9df-bef07b2322da@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7CDA84000D
X-Stat-Signature: nirh5zjkdg7pmiyzhabstmej43gqda5g
X-HE-Tag: 1759330260-451466
X-HE-Meta: U2FsdGVkX1/pYjDk4aaH0+PVU70C180dEyXNnITS42oXND2MjLOM3pYiHXl+wNcrSI1zF04vaiE1w0PsQawwZCXyh7aYEsK8S1+3WTPbmWQFX4BymrAD2mRyKMCISydUFDCJ1SIUs929l0RFGcvh+NfFrhD+rAS3G7pZHxMIy0VbgZ9qUpvQi3yc5D2ICEqrrczzB17FmaYb7itXD5M+JTWeZU8lbL6BWKtaIuRns2Qhb/dmpNhjYAQEnhXLh7WS63ivUIaHU98TBr579cmGKVdypnQ7X3oiMMAOKbkwo8xQWhRkMiP+miI2Qnjun8gpSnjphhvHJw9e01iGvfGKQtpy0770+FSKgesrS4MfCci6DSfTTA7/p0il80/OVCKPmwT8yAwiOkioCmxu4Cf/Xw3rUPgjmr70MkmjU5nUZ1XOiMThMEzlaKdvclAkoNN9sGuDXIhIayiYSaMfyYbNXstzd0zJ4/PsTeTN08M6g3NwXaGC8XdND2gzPEPOWlKL7bzg2zx+fwuWSvDIA63c/SoV3++1H+dhob5wxzFrLu8pcMI9oPZQjlgcEAEFta4t2uZeQUIcSYKSNTD6Fq1Q+t8R3M0Oep5Ro89Ln/ANb6qGWwU2/xOGcbUcV6454dggBxKWbtHSrjOn3GfDVM8rjbJJHvqHJUe0Pe1vcvpQTV/DksANLr5Q+pFgtplTF2xFqk2iqP1YyAFdo5JlIbxKQDfPTeH3NZPdWeRuUHnjPRdh2MXJgYtQUNBZXfn5fZpKm2REtFIl7QxmYoiewZVseX3FWUljyddqL63svUDZfcTTlk9NTSW3J50NCxv3GtX+EaD4fDRen95XljjgsaWV3dXA40H7qECicKOnzTE0esevEyGRal8tM3X5ud00745EvUwXRf/GWA7dSQVplYwtKu3JLrXLg2a1o+xddT96FdIqDNGgCpqeE088dOHKZS8r3gncuwjrIjMEQkujgXp
 FYb8+b+0
 1qZFtNj73lcbcEQQ769v0U/4/PKQiBRyMC4wIQiZ1GwvRK5rpoyOotTBf25dKt+51FqbQo08ryelLyXB3KEcvSkUQezYdVxg2gRIGJD9TuRhfBL4moEdJUWVh5/D3tPI7+Y2TQs7uHLWqK03tqCPQ5XQY6wSVuwFUlqyt16EjqpAKApuoyD4vYF7Rk4oOqX6omg3MN/EVMEkLpTLzIxt14rMKJBRkOhV0wahk/5AUGNyJLyLyUe9Cn+tU23A2vSxzTSGoExJJvDJok68ECP2uwGAbPCMo+YXd+Qtv/IGKvU4aRO1bHaRkegatc9OshxMurQh2FW+or8MLCe0IFf7fwJwv91TrGDwT73SsEg4x3oygY7/v3Vubo0WyxP6u15gNUryw43AnkMS/eiZ03DLoM3xGVjIRtNdcrAfNAI+adx3ljYo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/1 22:34, David Hildenbrand wrote:
> On 01.10.25 16:28, Wei Yang wrote:
>> We add pmd folio into ds_queue on the first page fault in
>> __do_huge_pmd_anonymous_page(), so that we can split it in case of
>> memory pressure. This should be the same for a pmd folio during wp
>> page fault.
>>
>> Add it as expected.

Good catch!

>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Lance Yang <lance.yang@linux.dev>
>> Cc: Dev Jain <dev.jain@arm.com>
> 
> Fixes: please, and I think we want CC stable.
> 
>> ---
>>   mm/huge_memory.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 1b81680b4225..963cba933cb6 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1878,6 +1878,7 @@ static vm_fault_t do_huge_zero_wp_pmd(struct 
>> vm_fault *vmf)
>>           goto release;
>>       (void)pmdp_huge_clear_flush(vma, haddr, vmf->pmd);
>>       map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
>> +    deferred_split_folio(folio, false);
>>       goto unlock;
>>   release:
>>       folio_put(folio);
> 
> Which raises the question whether the deferred_split_folio() should 
> actually go into the map_anon_folio_pmd(). I think you should just move 
> the one from __do_huge_pmd_anonymous_page() in there.

+1 Moving the call into map_anon_folio_pmd() feels way cleaner :)

Cheers,
Lance

