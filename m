Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6E12C561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5A476B0088; Thu,  6 Aug 2026 04:36:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0AA26B0096; Thu,  6 Aug 2026 04:36:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C209C6B0099; Thu,  6 Aug 2026 04:36:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6B26B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:36:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A1FEBA235B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:36:03 +0000 (UTC)
X-FDA: 85070187006.30.0B41C9F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id DDD3E140004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:36:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kt+UntKS;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786005361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Zf7vT1dgbmGchPNuaWZ7/mC3SH4bQR1pOsfD0HMIQ4=;
	b=3i7CYAYO8+Td4W6mkuaLJWuR4PR2P/ns9Oswa9Hk78OxX/gI+ycbYfCIf/8NVHVlPu0XE7
	3Gg0wjU89kirn3ZxhNZVEN85GmNqQvrY6uzwCQQH34nAknOXNp1+TgPkzviA+xFmWSwRo2
	9clK9UqGFoFVNmzgfhvQZ8ivgGRps0Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kt+UntKS;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786005361;
	b=e2jQk5gA3WMWsfCazFYfZYPmUDHgtvWN/o+blIvtj8jLpmfiyfKcq3Alwqa/E1MIGQ2oTw
	SjHXl4D32nDqpL4lwJymbu7YZfPjqPg0ly/tDUbSKbWfl+23KICsO7tXMtTrp11YPc81Mp
	fql56ThNVAxF9OBcJyVstEYpds6Nm0I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6090060A8C;
	Thu,  6 Aug 2026 08:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B051F00A3A;
	Thu,  6 Aug 2026 08:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786005361;
	bh=+Zf7vT1dgbmGchPNuaWZ7/mC3SH4bQR1pOsfD0HMIQ4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kt+UntKS1mKD3CdD5YyzbRET6/9d98rdD+1USoOle7taqWerZrysYUDzu5d9ihTNN
	 A8IFeBs0LRmWngc0ozxr7t5btrhKh6b+qOJ1/k8xqc6Ku9Amo2uIn1HSwO34DjyvmS
	 slnnMdREQasqw9kzSZym8MGP5GIirQvXtAfl2RCy8inUMqzBgmy7SDdeBAqCT7o0a4
	 ioPuo8wIZ2anVzJUNvoT8pjRKSWdFV6DNzERhOBoFxD+qObcpuB8T4QQNnNsAjCDbx
	 uXI6BDgooGV6+KKFzD0Xe8KtMLrWVg3uyvhvqJgryQVjMyMIIJzFBBLSS4LY7cDAku
	 W87MDlXNktVzA==
Message-ID: <1dd77152-bafa-4c4c-a85f-aba054065601@kernel.org>
Date: Thu, 6 Aug 2026 10:35:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/ksm: validate KSM rmap items before hwpoison kill
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Longlong Xia <xialonglong2025@163.com>
Cc: akpm@linux-foundation.org, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, xialonglong@kylinos.cn
References: <20260803151151.3472893-1-xialonglong2025@163.com>
 <20260805162937.1795310-1-xialonglong2025@163.com> <anNl1SSA3fidOrTy@lucifer>
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
In-Reply-To: <anNl1SSA3fidOrTy@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DDD3E140004
X-Stat-Signature: 7z71537893xmeiyma466j6rpfb3gyfkt
X-HE-Tag: 1786005361-778855
X-HE-Meta: U2FsdGVkX1/Pr2RPNZ386O7hRutUqZc4W/BM6Lfx2zyKNxEOmc6A568HEBj3N2omLeM97t4F+tv4uaWFiOpULM0xreIv1wtJdhBp2BkJrjp5/5uiCJ8u1MwzRnCWHzwncyFjIqhA6vkWG2ecX43nPWVvnvHHMm3bGzcH/EjFjFGfmVPGVikuCpFQGgHR7o2SKFauQpdJIu9hZCH80fKdOIMCs/ra9JQHW2/are9p1aBwdKP65vX3W10vgtreLzRT1j2vV/jnSvKcGnMVm7WN7rBqIJ98J49D0qZFdG5A6z9lwthyui8CuKh8aojL/xGbdh3Nr2ekctMP9ukrwWekvGqm18po5eju5c23jjEJjofkU0sXcni0gv51TqeGseC6ZFg9iDRLi78/S6OcS0E8gc46oJ8NruiE9UyfSPKvATqXoOZBtY8nxZSd2SF5j697RAbV0XUoTMwF89/FBQRgL2zHNfi/5tg8oEjncjwhrd2kM2/WJf/DvuKnTW0eZzjDPzkP2IcxVKPLmGmWCeVjtlJP28QGbWRv50rEp4VSwfoHJh6WBo/GpAEV0fY3Kp3EFBv1sUzoLWelCVi7XWAG+nOEwfeY7DYhDZGMAaHaqa09iSQSvNPJss7yDDw/U2l+fqXmkNVg+woFj9xRbMI/WdFgbWEAXyhbk74KKJiQgIYaEB2V+gb3xmk46/1U2rlsMlzGCMrZm3F71YB9bVD2CzkgmWQtHDypoDIbZ06f3aVPrjx7rpEoYzDyOemI/omHJ+Qf8SMCP4HVx5kQ/ZiyeXXi9l89S/6BzkVsB2SPDngrkf2Re4iZNhEAVnodqjKyqfeIdJFsd5iNGeJRMOBEKBVs+OKDnzXLpsIH3Tp/CBd6Y512UxbEd5DVzOP1fsXUlYPHMfK+qCYctmPgdkrE9HnP1ZrFpKks0gt+klg9R3DUt2wtGSqGg7VaZ4uq9vt4HFBndXee6h0Ke3Ln01E
 BTNNrnX/
 vnhmseH7CorxzWyq1x33fU1T5LLp25DL6zdvRkrP5oQSYetk30dKDR8YgQG711hiTsBk0nOtVtFMvnZbRhk4rJBXv1DWjs8UiE1BILzD25QGjInsoKJnmO4D4ZDvn+eg6rx47i1S//WT28xW1Fu3s+4Pjx1UjeKxmkA8VUYA4P51aup+2frZfs48cePzkafhaPPsfijHssTutgGozPptujmxX5Q39SIfXn99ZoqTkhtwjy0G+6FUP39GvI+OLv6mZj0Ya
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> @@ -3253,9 +3253,13 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>>  			{
> 
> OK so you're literally doing an anon rmap walk here, with the anon lock held.
> 
>>  				vma = vmac->vma;
>>  				if (vma->vm_mm == t->mm) {
>> -					addr = rmap_item->address & PAGE_MASK;
>> +					const unsigned long mapped_addr =
>> +						page_mapped_in_vma_at_address(page, vma, addr);
> 
> Now you're doing another anon rmap walk? Why on earth are you doing that? And
> won't this deadlock?

I think it's the same as with page_mapped_in_vma(): it expects the anon vma lock
to already haven been taken.

At least that's what I understand when looking at collect_procs_anon. :)

> 
> Why aren't you just checking the whether addr is contained in the range here?

Yeah, that should be much easier.

> 
> Like:
> 
> 	/* Make sure VMA wasn't split/remapped */
> 	if (!in_range(addr, vma->vm_start, vma_pages(vma)))
> 		continue;
> 
> Or something?
> 
>> +
>> +					if (mapped_addr == -EFAULT)
>> +						continue;
>>  					add_to_kill_ksm(t, page, vma, to_kill,
>> -							addr);
>> +							mapped_addr);
>>  				}
>>  			}
>>  		}
>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> index bac2eb5de63d..f7c5dc9248bc 100644
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
>> @@ -336,6 +336,26 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>  }
>>
>>  #ifdef CONFIG_MEMORY_FAILURE
>> +unsigned long page_mapped_in_vma_at_address(const struct page *page,
>> +		struct vm_area_struct *vma, unsigned long addr)
>> +{
>> +	struct page_vma_mapped_walk pvmw = {
>> +		.pfn = page_to_pfn(page),
>> +		.nr_pages = 1,
>> +		.vma = vma,
>> +		.address = addr,
>> +		.flags = PVMW_SYNC,
>> +	};
>> +
>> +	if (addr < vma->vm_start || addr >= vma->vm_end)
>> +		return -EFAULT;
>> +	if (!page_vma_mapped_walk(&pvmw))
>> +		return -EFAULT;
>> +	page_vma_mapped_walk_done(&pvmw);
>> +
>> +	return pvmw.address;
>> +}
> 
> I hate this name I hate that it's CONFIG_MEMORY_FAILURE only.

Note that page_mapped_in_vma() is also KSM only.

But I am curious why the function differs from what I quickly hacked together.


-- 
Cheers,

David

