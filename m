Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC6CA606A326
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 09:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vCxKaGCa
Received: by kanga.kvack.org (Postfix)
	id B877B6B00EF; Fri, 30 Oct 2026 05:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38316B05B1; Fri, 30 Oct 2026 05:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4DBA6B05B2; Fri, 30 Oct 2026 05:16:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83F3F6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:16:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F022FA066A
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:16:48 +0000 (UTC)
X-FDA: 85378737696.21.C9E331C
Received: from mta0.migadu.com (out-250.mta0.migadu.com [91.218.175.250])
	by imf28.hostedemail.com (Postfix) with ESMTP id E660EC0004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:16:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vCxKaGCa;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.250 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793351807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cvtULt05CNENF+dcGaZHfj6dxMkQ2uk2IJDUbG8kU5k=;
	b=B07bx4AW8wKlWjMc+qBspJHD0oMj76TD/iwO3l3wwbYsEfSXXY9mOkErdkdDUNDmgM/Mfr
	9SxbBgwJD+uEaI+zk+dh1q+wxOHdxq7fWdJjvLP88ZeBT/vZlOJUIDc5a3H2vE0o/Eovuo
	ednhSzN5NTfLbn0wk087ij3plP7thOc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vCxKaGCa;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.250 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793351807;
	b=d/7pG/0vlhDgXSoY0M7axU+SEWeReusLMAIpdn1KxSW9Zs2qpvCqxTY75hXJfkBrW1Jbyq
	hU5kUfJYnojZucWwaCQX+8zmAglfDBYwGso/kCz48zrRvf9vTySuTLNnMBS9Sn9Mexmt4a
	fquHSwUfFEKw/4aNZNWN5AsuBXOrJyc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OWKCARjtfy267o2XbXOnvCk2rMveSznO0EDjspP5kOc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793351805; v=1; x=1793956605;
 b=vCxKaGCa8XdTEH3cRIlQG7YJ9HhHuHhhVBmrQ5NQnJs35a7x6KI99FQfPEZqInlPJ8x9kWgw
 SF0MpEP3K1cLFo2g53kEQtmUBqUUdWTq9xVw57OlUQRwIdCHr94/4/ako6Rfms7fWM5bEQvPOnU
 xG3Wo7AAShron3KNLkb5U+To=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 339b1e922908af26;
	Fri, 30 Oct 2026 09:16:44 +0000
X-Mizu-Trace-ID: 339b1e922908af26
X-Migadu-Flow: FLOW_OUT
Message-ID: <5b0f90a4-c7d2-4f12-9d95-95c7149c49c7@linux.dev>
Date: Fri, 30 Oct 2026 17:18:01 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/10] mm/vmalloc: propagate errors in
 vmap_pages_p*d_range()
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
References: <20261026080329.140244-1-hao.ge@linux.dev>
 <20261026080329.140244-5-hao.ge@linux.dev>
 <e1cfd568-8fdf-4aa1-a8c5-961bb8d7efba@arm.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <e1cfd568-8fdf-4aa1-a8c5-961bb8d7efba@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E660EC0004
X-Stat-Signature: 3hm77mpj3udk56b3g933h1dr3hi4umia
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793351806-94820
X-HE-Meta: U2FsdGVkX19Hl9D7VmcGtg2izp4Jceps9U3aW3ZrWCt7KduPyDmmZej6nPOruW5cNEfZ6t93TzSexMz9ASyUjN6qhLiiW8shvd5UPmMRtNDzFEOSLvCyxPME+q3yClHOfv7HGKX5bdS9Af3vF1AjYOFAHte6ZlVOgyoMtVKHfUFLDw7JT7bmFhnIftrcx6amSdvAqcG6COJn3SsahmYFHqug87PdLLTx28TM+16DPMnvzYkoo+KD3e9x2jxLWa0cLQUuM4gWIuJ1VK3Kh50jSqzkZyGlOQKKCDTz5vrXWM76+nAs2fR8uzW+nP+du/KPMYRV0B/EKf1JzzgmtdZTpe7f6cyAWMvu/WwmxU5XXA4KKXGmPl+23mG5hbqa0UiWyxxJtafXyusWh5uhMVQ9JUe4uW7KClGzdTyG+wZbo2iJY5MXY7VTMzs0f4R8yJwHbbtvE4z1BIwwYPaa2PC1hjxG10RYTy4P/un7fbLtE3LiLfmKPeq06I92KKNiX5+d8Qn71wvc3+g1mgDJOPtF1DxqPjK3HQIz0bLUtR4nlAOjv7mKQN3MgnEnxOwgs7jutybpc3oyMa8pno2Vl6zLXWzLkhKRWgTx7GhP22eueHLQI/FpaDwjT2H9XmTHnfyDhZ9TAdgBlePce+g+ULZs+ninvlnr/qFJqHGf+ZNP1pPX0ukTOhQdIHP5X8XXH2OOI6P0TYOanhpIXHSrLFk45hdwh2ILTHpyOCslW2S/fSx1j9m16k+C7aY/sIxP5N2/wgeCkOtRg1a/0WEqaLLGr+tsp/RXjGfj3ka2sazUEXboil2ewUt+vKnmxiEvtj4rzTlAfA+QbkSbGYZIz4gsiiS8rY5LW3o2TzH19OqJKr/JMqbsMf/Ej4E8fZqbnvzQ8p7bjvuCy7SSD2DdjvJuDzjVMyXnqkVQMgCkpncqxmW8CbhqRMquulYlHO0D/ZjHX7V+C8NrQ1yQ0LR6DhG
 4CG+05TP
 kKCnSBcAXmhLpNJt0n5BmM8ejAK1InHxmtiw67IU7e9lGMiTuPPGz3jWVMiGng3xrTSzWw/mdPrgmm5ljM3Ou0z4DDg6XqGH42U/a5TM5F8yJbNJqQketoewubrW/d7uBf92/+HAXN1t5oPUySNmLKPzY7EPFNzVFoTO75BVrO4J7miMN4JouklL/dT8QZc8vEqiGhKsBB2bCPS7EA5cYzhOxWLjd6sPYUe0so46VNP9NEd6+lLP2r0myino4PmPRIHt190UxaeI3e+iHtJsi885famS5szuelU9WuBCNzgKw/kumc7/nLPy1Dq10BOd4WnssOxiwh3t37ET6DQSSkvktVRe1GJPUHgewmgri+F1v7u68Xsb8BCNVfqOpiSLaDM5rqzbDHz0nQCr7VfJDzL60GbYMDKxCBmL0Qq0JtckMStRKEUm+9RcgcHddhO5DXBHzeOTkQiBMxlY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Dev

Thanks for your review.

On 2026/10/30 15:29, Dev Jain wrote:
> 
> 
> On 26/10/26 1:33 pm, Hao Ge wrote:
>> vmap_pages_pmd_range(), vmap_pages_pud_range() and
>> vmap_pages_p4d_range() return -ENOMEM whenever the level below them
>> fails.  But vmap_pages_pte_range() can also return -EINVAL for a
>> page without a valid pfn and -EBUSY for a pte that is already
>> mapped.  Pass the error up as-is instead, like the vmap_p*d_range()
>> helpers for vmap_page_range() do.
>>
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
> 
> Fixes?
>

Sorry, I missed that.

> Reviewed-by: Dev Jain <dev.jain@arm.com>

Thanks! If you have some time, I'd also appreciate a review of the
remaining patches in the series -- or Suren and Uladzislau, if they
get a chance. No rush, I know everyone is busy.

Thanks
Best Regards
Hao

> 
> 
>>  mm/vmalloc.c | 24 +++++++++++++++---------
>>  1 file changed, 15 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 7131f60d1a8e..d60b99b81ec9 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -600,16 +600,18 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>>  {
>>  	pmd_t *pmd;
>>  	unsigned long next;
>> +	int err = 0;
>>  
>>  	pmd = pmd_alloc_track(&init_mm, pud, addr, mask);
>>  	if (!pmd)
>>  		return -ENOMEM;
>>  	do {
>>  		next = pmd_addr_end(addr, end);
>> -		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
>> -			return -ENOMEM;
>> +		err = vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask);
>> +		if (err)
>> +			break;
>>  	} while (pmd++, addr = next, addr != end);
>> -	return 0;
>> +	return err;
>>  }
>>  
>>  static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>> @@ -618,16 +620,18 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>>  {
>>  	pud_t *pud;
>>  	unsigned long next;
>> +	int err = 0;
>>  
>>  	pud = pud_alloc_track(&init_mm, p4d, addr, mask);
>>  	if (!pud)
>>  		return -ENOMEM;
>>  	do {
>>  		next = pud_addr_end(addr, end);
>> -		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
>> -			return -ENOMEM;
>> +		err = vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask);
>> +		if (err)
>> +			break;
>>  	} while (pud++, addr = next, addr != end);
>> -	return 0;
>> +	return err;
>>  }
>>  
>>  static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
>> @@ -636,16 +640,18 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
>>  {
>>  	p4d_t *p4d;
>>  	unsigned long next;
>> +	int err = 0;
>>  
>>  	p4d = p4d_alloc_track(&init_mm, pgd, addr, mask);
>>  	if (!p4d)
>>  		return -ENOMEM;
>>  	do {
>>  		next = p4d_addr_end(addr, end);
>> -		if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask))
>> -			return -ENOMEM;
>> +		err = vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask);
>> +		if (err)
>> +			break;
>>  	} while (p4d++, addr = next, addr != end);
>> -	return 0;
>> +	return err;
>>  }
>>  
>>  static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
> 

