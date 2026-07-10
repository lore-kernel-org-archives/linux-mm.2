Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EC23C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:13:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D83DD6B008C; Fri, 10 Jul 2026 09:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0D886B0092; Fri, 10 Jul 2026 09:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD6366B0093; Fri, 10 Jul 2026 09:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9207F6B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:13:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2BF698DF91
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:13:24 +0000 (UTC)
X-FDA: 84972908328.04.DF0ECDA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1E57B20010
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:13:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gHKR1jOj;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783689202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7UUlB0EZdyV01MSm2/rVxOPnJv85wsGTXlZTFUdeAw=;
	b=BtVvrD7xsFx/JdbXuZnO0/dhj9F1fZMz2ItzzZnXZ3vaN/aoNjYfenORn7U52ZJ59uQ5gl
	umEVv+XhvNeST2cjDAQAhTZwhz6ryjrlQAkKvK0MiU0ZP+BDb116TBDohM7GbWgzBVrrLc
	QRk6NBCx3zGfbBo8KATGTgc1aIHsaFY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783689202;
	b=ty1kfoduW+bvb+j76+/qgcBM11IoXA97Yv0AfEBCw53p5Viahk4PBdz1dG9y8o+GZK4aPt
	dxzb6dwimM/bg5qU7K/It9vLvzt98UAKEoxJ8niA3SXbBi0i7jYp1th+fBeXN6JPsdKTMP
	9EVjOED/S5PVh26BvMtIkzzGJJrsrUM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gHKR1jOj;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93DD0176A;
	Fri, 10 Jul 2026 06:13:16 -0700 (PDT)
Received: from [10.164.19.51] (unknown [10.164.19.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1014A3F66F;
	Fri, 10 Jul 2026 06:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783689200; bh=Dz+rBYa5uMfuc05j8/QbOewekJXZQIzUiNonDDQ2YCo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gHKR1jOjt7QCu91OrQyhYTWE6z7tWRrsPrLcLJyogfZsmcrO1zcQzkTE/7l9qsV/i
	 09u12atqLLnIDhbZB5aAaH9CLlmnqRDuMy/SIGeu9zjyjxTgVGe3az0ZXn+5a/4q+y
	 xwb5Dwiz9ZCSwCFmEtmfTNwzWAS01dpf47wxh5Tc=
Message-ID: <42300e6c-523b-4f58-98f7-672ce9173fe2@arm.com>
Date: Fri, 10 Jul 2026 18:43:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] mm/rmap: add anon folio unmap dispatcher
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, muchun.song@linux.dev, osalvador@suse.de
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260710055915.638659-1-dev.jain@arm.com>
 <20260710055915.638659-6-dev.jain@arm.com>
 <00467fbf-0360-47be-94bc-d1456323e5a1@kernel.org>
From: Dev Jain <dev.jain@arm.com>
Content-Language: en-US
In-Reply-To: <00467fbf-0360-47be-94bc-d1456323e5a1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1E57B20010
X-Stat-Signature: 4h7q48yw94ft34wcz5y45gnwy4e1u59w
X-HE-Tag: 1783689201-344588
X-HE-Meta: U2FsdGVkX191zzAkoQJytKH0aOdInAftEdntPZeKKbGoatoXXHDba/NyliZtnq/mT9Gf/FIhW/QAEijaj+SkRJZ4wEnbSP23weYxSqkH2vvfhoAICAy5uUvxfPX35LvKQWXfIQqEJspzrE7lAQgXcPWnkczmnvYdvpY+eYlx0nZVzA8gQHX59BKzoXSvOAGUGp1ENct0EUeMvKstXefdwfxp7GZYD1JM82RwpwK2qqC1ZWYS9i5p6ub4z0fQBW3cDLMy3+qsRguzTh63jCeWcrOI6HUhDgro2xu5sRv/N5WzM+5Jj4ZtyXky9EO8Wr3TPRXBoCS9YcRv2iy4iPH/2fKF6YdPPVwVElMVC8qU9ZRyNGWQasmRRZ1ONWAkZz5HKrh7rUcT7RdmRPYbCtmcdICn7AuhTkOxnKTz3w9Dx88CxBtiUK3YA5UF1iXMSWH0w4j92iBp2EtjiVM7VFmMoHNcgYoqp3x3nQLSfrdkVLvEgmG6zOirVpOsaP+MiZNglPHEZ6iWUs8wNTKeY1JFJxcguQK2GycjOwDxWfdSXbeTNDDOOafe8yNCjIh9cQGkK/53U7uBf2b3/xmMz/fDn1YfHBAE+DLX7kr9bpKsUqxVMO87ShCHDH1zj7GkyIh4jZmcx2QzRM4Yar5bOd+36Kp5L1xe/iB/r5Jh/BT20hak/0iDAEypCthn2IruFiJo11gE7wyqzD85mDFXiL/Cue0ItQlarDeglmagKX+5r/BcZX4170AsZuVIw2xuyVGap3FfEnVSvLT4Yz7SQRhoqet91vVmpLGvo0kL6OBnKNtzHWlCtDwhwkIHvp2WAXJKqSFZKnCEeKKQVtU/R8oHIW6CCNLqHU5WnskoiIQvDTw6XOU3GW0ZixtWZh2VBPDPAZ7aw5GWxhzdM5++t7c3GB7B+5zncmTMhDSUGDbjU2WCu73s2mfrFUA7nzodJUqk3NNSAXBlWQPLrmG20gY
 wJAiqhah
 e8zYJ3X7aUMy6I/Yloc+HuNNDBsJZlenQontquGuoCDTftKzV18V0jAjSrzC8W8AIt687yAmrM+wSlj6qCqLBz1rOfPITAduM90gWuMFa7MBb63WRUIej/s/6HEG5ySlZB8Bii/z2jeyudxTuvDUdmQkEboB2EG122cwAAvdY2uJwu6miG7Bpfj969xONSVT3hTiM15wPZETu/efGbNUy32pjww2bKPvffpgYYYXdLHO5KTUd62vUPs7gEX+SC+25kDe4eP2BGxh90crkR28WVsvC/GB2YlNsTIW8Mn5bQKGJFGxDm+MrnQl4vmAGJyEsbZbp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/07/26 5:57 pm, David Hildenbrand (Arm) wrote:
> On 7/10/26 07:59, Dev Jain wrote:
>> Add ttu_anon_folio() as the common entry point for anonymous folio
>> unmapping. It dispatches to the lazyfree or swapbacked helper as
>> appropriate.
>>
>> Keep restoration of cleared PTEs in the caller, where the PTEs were
>> removed.
>>
>> No functional change intended.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/rmap.c | 47 +++++++++++++++++++++++++----------------------
>>  1 file changed, 25 insertions(+), 22 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 68459f23f5c0a..55aa3ff8bf216 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2172,6 +2172,28 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
>>  	return true;
>>  }
>>  
>> +static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
>> +		struct page *page, unsigned long address, pte_t *ptep,
>> +		pte_t pteval, unsigned long nr_pages)
>> +{
>> +	/*
>> +	 * Store the swap location in the pte.
>> +	 * See handle_pte_fault() ...
>> +	 */
>> +	if (unlikely(folio_test_swapbacked(folio) !=
>> +			folio_test_swapcache(folio))) {
>> +		WARN_ON_ONCE(1);
> 
> Can't you directly do
> 
> if (WARN_ON_ONCE(...))
> 	return false;

Right. I didn't do it perhaps because I was playing with if (VM_WARN_ON_ONCE) somewhere
and that didn't build. But this is without the VM_ , this will work.

Andrew, could you you squash this diff:

diff --git a/mm/rmap.c b/mm/rmap.c
index 55aa3ff8bf216..41a049e7dd231 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2180,11 +2180,9 @@ static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
         * Store the swap location in the pte.
         * See handle_pte_fault() ...
         */
-       if (unlikely(folio_test_swapbacked(folio) !=
-                       folio_test_swapcache(folio))) {
-               WARN_ON_ONCE(1);
+       if (WARN_ON_ONCE(folio_test_swapbacked(folio) !=
+                        folio_test_swapcache(folio)))
                return false;
-       }

        if (!folio_test_swapbacked(folio))
                return ttu_anon_lazyfree_folio(vma, folio, nr_pages);


> 
> That even implies the unlikely() :)
> 
>> +		return false;
>> +	}
>> +
>> +	if (!folio_test_swapbacked(folio))
>> +		return ttu_anon_lazyfree_folio(vma, folio, nr_pages);
>> +
>> +	/* nr_pages > 1 not supported yet */
>> +	return ttu_anon_swapbacked_folio(vma, folio, page, address, ptep,
> 
> LGTM
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 


