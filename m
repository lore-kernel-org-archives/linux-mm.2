Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E40BBE9A77F
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 12:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5687B6B0088; Tue, 24 Mar 2026 08:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519C96B0089; Tue, 24 Mar 2026 08:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 408586B008A; Tue, 24 Mar 2026 08:46:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2FEC06B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:46:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECEDBD13F6
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:46:27 +0000 (UTC)
X-FDA: 84580930014.28.FE455E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4721BA0018
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:46:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZxGj9ugq;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774356386; a=rsa-sha256;
	cv=none;
	b=3Lx17Q8D7awYxPNvaHSKFcbIHuds24nEBE7G2u7walz6oBTkx+//iC0Usyx5CTdOEHWMb4
	SLw4WoWDsTqK7aiMiYVmY7Hfe6oXi1nSGmZ3wRUaOIvl/URtcKaPn7C3PRR21df68O0qEc
	0opsBPCRjQDF1Q72lV3NgQOIn7QEJak=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774356386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e653nGx2VZ8jixFDVbtk9AceHSw1qV3VoarRkZ0gRTA=;
	b=Fom4AZdQn6tmRAabx6qN5n8mfw+yAXf1ByOv3vKiDpI6ebMUwDcNX8+oae1HqKD28S+MCx
	va/xx+6611E+0Hbp7lFrR5parxENH3s1CZpOp5WdrAIheMJsLIHLw1LNaExp0hQMF2zi8l
	y9cR4abS3f+l3bmeA/J/qAY8ns8+1xc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZxGj9ugq;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A94FB6013E;
	Tue, 24 Mar 2026 12:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D74C19424;
	Tue, 24 Mar 2026 12:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774356385;
	bh=pj0qNOEO5MNCC+dnvNkS1WO0CHnBtfXliGY5/GqJgPY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZxGj9ugqZy4OaUMpJcbotouHGeD9e5JDcxz4fZYcsg86sxfxHkxx433cdmP6HrAEk
	 qXrc+urtRiZjqJvUeYAlKqfJU2O5oGcJus9uZ5ePCueSrJA59iEYM99IQcRr4PxDlH
	 KR2TZMdSym3GbI/F8CtRnK2FK8tAZzywiVpIfZwenWzAG4o8YpIIKAz4APJU/J4EH3
	 HuNrojgkpeT74yfUIZdMspOlhkR/XG2gAPqEGY0Cs18hnO4xiJflg7epi7NmGOFXL/
	 hmBUkOTy7d52Nk6wEi1mzkb4YnlyeGzr0qP/D/mOd82RQdBtsyfCX6dPhhUmwM5o0i
	 MKglDcXVpi3pg==
Message-ID: <43cc2290-10b6-4db3-bfc0-169adb8201b7@kernel.org>
Date: Tue, 24 Mar 2026 13:46:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory: fix PMD/PUD checks in follow_pfnmap_start()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 Alex Williamson <alex@shazbot.org>, Max Boone <mboone@akamai.com>,
 stable@vger.kernel.org
References: <20260323-follow_pfnmap_fix-v1-1-5b0ec10872b3@kernel.org>
 <b3b78722-c265-484b-acde-3aa4bee0aac7@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <b3b78722-c265-484b-acde-3aa4bee0aac7@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4721BA0018
X-Stat-Signature: fw5krcgxh1bsw8kyi4mx9mgsyx8offsj
X-HE-Tag: 1774356386-233344
X-HE-Meta: U2FsdGVkX1/vrDJaF6fHQwxZOnqA83JHVGFn0O4eFFmEEs0Zu2Ts+w+F+EB0D3ujyJXYBkcPMpEX/V+G1DZeREVADmjKNmQo80h81XVLoT46gtk/zhAOkyKIqt/QQ4bBySCCRlYeQuNpzbuj5Cd7E4sQKZlTzXw3qCtcpkbR7M/sHO2uY7ikSYJh10fnfRAedJJOJ4SQSeqf5u4V/OBFI5ov1AX0PcV4ddRNJfnvluB8oHSsa8aDxZzIy70UZ66Uq76QmMmVK5/4pTSf+DzT68cJQEVXh15pFgdgBCKb6lZaUZ5aqcbDCtIs4ss2F/MTquotQT5zf6Pc7jU7DIrXQKDrmezB/SnYJdcPcSJw2CIkzycK5tYxW8Gj5Z18S7sS7CZoVN4XM9Sj0l7Vnugi+Ig0lm1xmxNnxFNm0U/r4xcHHM2xRqjnMOgSqctj+wAWhYDx/hzfGti0l8vfHCHpbuSqcH8QFdeb3WoWOz2pDC45o135rbPrHvu/iTke4DmLaw8K9t1fw/zDe4gGJCc/gtj+0KugRdWwF705IzwERJXuiuNdPZzJ67KxiOjV+2EvVScHHDo4s85ZyeR/kAXmP3aC96hs/HztYLEMEmJLJdC2aDHMrERzu5G7w/vODlzezjU76Jw30FCO6bJ137ZL13aVVqSKBH7KLVBH/SoFHCZtf8HvigKK0W0WGv/2MLAcmE1/Wx/YDQiSI2Nzl3H2S3ahkrQ81DY3bVxlQW1HDSXcoRPvMQQ4dH8YJ1+BUJWxRxdmiXLpxhQkRVAQ2Tiv631pmGns1xrPhfIASdmxmEJI9mU5t7LgJgZw0Y1R00a+r3FuhY3X8jArqZhK6AIwcy0NE//bnJH0NPO/YEuidKe3XA23LE03VGd++JdEjZF/O19sPqN7TZ0xkS5JWv84Mn3zAhVcjcfbn0ca7AIXavcFOGGbuGin1YXSVYH/4YAdObwY/TP21Ng1DapnkRa
 prAqaIEI
 ww64n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/24/26 12:04, Lorenzo Stoakes (Oracle) wrote:
> On Mon, Mar 23, 2026 at 09:20:18PM +0100, David Hildenbrand (Arm) wrote:
>> follow_pfnmap_start() suffers from two problems:
>>
>> (1) We are not re-fetching the pmd/pud after taking the PTL
>>
>> Therefore, we are not properly stabilizing what the lock lock actually
>> protects. If there is concurrent zapping, we would indicate to the
>> caller that we found an entry, however, that entry might already have
>> been invalidated, or contain a different PFN after taking the lock.
>>
>> Properly use pmdp_get() / pudp_get() after taking the lock.
>>
>> (2) pmd_leaf() / pud_leaf() are not well defined on non-present entries
>>
>> pmd_leaf()/pud_leaf() could wrongly trigger on non-present entries.
>>
>> There is no real guarantee that pmd_leaf()/pud_leaf() returns something
>> reasonable on non-present entries. Most architectures indeed either
>> perform a present check or make it work by smart use of flags.
> 
> It seems huge page split is the main user via pmd_invalidate() ->
> pmd_mkinvalid().
> 
> And I guess this is the kind of thing you mean by smart use of flags, for
> x86-64:

Exactly.

[...]

> 
>>
>> However, for example loongarch checks the _PAGE_HUGE flag in pmd_leaf(),
>> and always sets the _PAGE_HUGE flag in __swp_entry_to_pmd(). Whereby
>> pmd_trans_huge() explicitly checks pmd_present(), pmd_leaf() does not
>> do that.
> 
> But pmd_present() checks for _PAGE_HUGE in pmd_present(), and if set checks
> whether one of _PAGE_PRESENT, _PAGE_PROTNONE, _PAGE_PRESENT_INVALID is set,
> and pmd_mkinvalid() sets _PAGE_PRESENT_INVALID (clearing _PAGE_PRESENT,
> _VALID, _DIRTY, _PROTNONE) so it'd return true.

pmd_present() will correctly indicate "not present" for, say, a softleaf
migration entry.

However, pmd_leaf() will indicate "leaf" for a softleaf migration entry.

So not checking pmd_present() will actually treat non-present migration
entries as present leafs in this function, which is wrong in the context
of this function.

We're walking present entries where things like pmd_pfn(pmd) etc make sense.

> 
> pmd_leaf() simply checks to see if _PAGE_HUGE is set which should be
> retained on split so should all still have worked?
> 
> But anyway this is still worthwhile I think.
> 
>>
>> Let's check pmd_present()/pud_present() before assuming "the is a
>> present PMD leaf" when spotting pmd_leaf()/pud_leaf(), like other page
>> table handling code that traverses user page tables does.
>>
>> Given that non-present PMD entries are likely rare in VM_IO|VM_PFNMAP,
>> (1) is likely more relevant than (2). It is questionable how often (1)
>> would actually trigger, but let's CC stable to be sure.
>>
>> This was found by code inspection.
>>
>> Fixes: 6da8e9634bb7 ("mm: new follow_pfnmap API")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> This looks correct to me, so:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks!

> 
>> ---
>> Gave it a quick test in a VM with MM selftests etc, but I am not sure if
>> I actually trigger the follow_pfnmap machinery.
>> ---
>>  mm/memory.c | 18 +++++++++++++++---
>>  1 file changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 219b9bf6cae0..2921d35c50ae 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -6868,11 +6868,16 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
>>
>>  	pudp = pud_offset(p4dp, address);
>>  	pud = pudp_get(pudp);
>> -	if (pud_none(pud))
>> +	if (!pud_present(pud))
>>  		goto out;
>>  	if (pud_leaf(pud)) {
>>  		lock = pud_lock(mm, pudp);
>> -		if (!unlikely(pud_leaf(pud))) {
>> +		pud = pudp_get(pudp);
>> +
>> +		if (unlikely(!pud_present(pud))) {
>> +			spin_unlock(lock);
>> +			goto out;
>> +		} else if (unlikely(!pud_leaf(pud))) {
> 
> Tiny nit, but no need for else here. Sometimes compilers complain about
> this but not sure if it such pedantry is enabled in default kernel compiler
> flags :)

You mean

if (unlikely(!pud_present(pud))) {
	spin_unlock(lock);
	goto out;
}
if (...) {

?

That just creates an additional LOC without any benefit IMHO. And we use
it all over the place :)

In fact, I will beat any C compiler with the C standard that complains
about that ;)

-- 
Cheers,

David

