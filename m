Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B7F5E9D40D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 16:50:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 315236B00A0; Wed,  4 Feb 2026 11:50:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CBBB6B00A2; Wed,  4 Feb 2026 11:50:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CB576B00A3; Wed,  4 Feb 2026 11:50:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 07B616B00A0
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:50:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A43B7C13B9
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:50:34 +0000 (UTC)
X-FDA: 84407362788.19.56ADF59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B292A140003
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:50:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KvP2Ej0r;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770223832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dizu3UrovhjzKxn0TRKZF2AItoOO8OJZaigSXl9q9s4=;
	b=X82pSEgeEDmn/B9C3StPenek2wdBnNU+tE1Kv1OC3qJQweqCcSr/sN8zcMH6QUDpL2tPVR
	lZUkum8scVCSNERk1z1YhMmQo+SRr5xPAM8fj4y9niclVUPUIsDX8y0pn6Gmkx28bO2nvQ
	5dZsf7LxRPLyAURN7d3fi/gRAiVvHCw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KvP2Ej0r;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770223832; a=rsa-sha256;
	cv=none;
	b=tkW3xy5r54qmCwtWzIaPPRWrpwakTBEf9BYkbghWDNBTLe+pO5uOrQvZEODe4ePj62RYl7
	l7N5qvSg2oBhyhet0tzTmlrzyphUShfUoe9pE26osDG+brP7tK4qoLgrUcap34xZHr1piG
	6USwFTPtC6Ynm+6sMl1Tt4RzKefIx0E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EF4E441E2;
	Wed,  4 Feb 2026 16:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F69C4CEF7;
	Wed,  4 Feb 2026 16:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770223831;
	bh=fd9mB6uxi20UpngRQKWBUIqmPqpBhJ06BLLPzdm+xN8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KvP2Ej0r49rqN3zlMVpi7wdZOiGb5ddjkwluNNwr9i65tfI+kq4umf0NzPJuSsz8p
	 P6qg5MuNuC/5M3knmpbfL5L40N42mK4CxEuRfEkEvj5XMAVFGkQ5ALUg/vIDbzsrpn
	 //iCatRb0KhDzkd/uzYZNxOW53aznd3RDzb/Zz2Zl7jilmlNc1PgoPNluqUj5Pdz/2
	 6b47830F8Tvk2zwwsSlOD9haOzCh25eYY3PiIsZkPeucUqpGe9bEw1u0YDXiUIHiK+
	 uatWn5zfW2IwFwvhWhhIepkHH5jQtDQ0ES43T91LXVz3v288R1X14ywTluExwNxg70
	 eVR618or/n1mg==
Message-ID: <1b80b189-b549-40ba-800c-8037ce12b081@kernel.org>
Date: Wed, 4 Feb 2026 17:50:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 05/17] riscv/mm: Align vmemmap to maximal folio size
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-6-kas@kernel.org>
From: "David Hildenbrand (arm)" <david@kernel.org>
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
In-Reply-To: <20260202155634.650837-6-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: mxte6cnt9sq8jpmri8gstgcng5fd967w
X-Rspam-User: 
X-Rspamd-Queue-Id: B292A140003
X-HE-Tag: 1770223832-707934
X-HE-Meta: U2FsdGVkX1/ONkbAv1MrpTR0eyEKBYoQAcOuoq5/1Tk+tTDYuik9YSJU9WL9008u4qKKU2O2wC13kfHejlyjZm045L2CPj3jObaC2P3tunp/6qmtIdgbWZYgZ6+ubCX61Dh/94vbzsgSXHhUtcfXwsNlOvhgFcrQv+lLX3av5AA/AHGybMqQQn8/8RHaWnREw7EmYJ6ib1Sl3NyEXN2/T/wk9qBiuy5nc0YdbhYKxAnHOZu4a4+yNzdbTAh37TTqtG5WWlNCXuKv6wRouV/Y7BqrBNSM5l2/rslpr1orZBgaNgXwx1tijlUuRPret3EBtOkf+zKHTzzjCB9sp1NuIaA2D7vMfmkiguyuUDJxddG8Va7EoJaiZPBD4GIujgj/RmCOkaRxCVZe/ffAJf39SDPs9eahB7mTffi4jxIi8J703cGS4fIeOm7m2O/q3e0QuJiek/6NR4ndMRFo5f5Q+ZYZaonaEK/H6KUNr5MP14gkeeMdIJNHoOYU/M0RSJCnkiSARHCvDayQHiVBh3Tn6GvXIabb8/SsEo1XWLGJjqf7beNm0QX0jwFZit07wtHvS+UQotWi341Od24GfsjSGGgmKXdtMguWyCqMztMoxV9omWSeGj+u0mT7gjZ2uvS+I375//klk5mdpL6lEkfZKGkOxjwIWr1yDOlPdNMNKzWDi9MMUIMt7FxOw0/uafu52Hbv0mVaSb+Sp4vD/rvAghAYMOw2VNFKcdJBIYHQC5tN/79/X9pscCizYGRuKQkfFPOtfURGYcU/JrsyF09HXWaTq1ZTKflVFH9+dALb4PB1G3njhm2uMKfci/RwY93KpdYgHesAQtonk7qS6eiv2f8aVin6X8NeNRiSRwqEH2zJXqzaj8S9daog5Qei5Oo0DNLOfQo8Ue/d4TejNGTvNNYZ0jO4q2xAdBz7r1W8CvX5AvMDUbWB/oCsFchrLeg7lmodHtgdVl9n8RZLh67
 zNTLb9/j
 3Yz3yVVrIW9sGyVPyh2afMX7j4OVI2uP+m/bDXtI4DGtbZhHcpJ6MLvZ2uhwLhlCti6kiDZ/MfOJIV+ABFVlOYH58nSLHS4v7Sysu1tJC6PV9JYltnSfcgLbrNs7ziqWGydZXwEnTn/ed5HF7o8xnv93JtzrlKjdTyNhPZiN6BK62EUzFpYcEXrQEFijMDFshEGSdnvtNfU/QzqsBqYfCzYv7M99jKn2UbDYfffcOk5g7k/JHp16LCR3cB7EZk3qIf+GHW2i8Os8fDL+GAI8XoMDrmLeCfkkry+Ff
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> The upcoming change to the HugeTLB vmemmap optimization (HVO) requires
> struct pages of the head page to be naturally aligned with regard to the
> folio size.
> 
> Align vmemmap to MAX_FOLIO_NR_PAGES.

I think neither that statement nor the one in the patch description is 
correct?

"MAX_FOLIO_NR_PAGES * sizeof(struct page)" is neither the maximum folio 
size nor MAX_FOLIO_NR_PAGES.

It's the size of the memmap that a large folio could span at maximum.


Assuming we have a 16 GiB folio, the calculation would give us

	4194304 * sizeof(struct page)

Which could be something like (assuming 80 bytes)

	335544320

-> not even a power of 2, weird? (for HVO you wouldn't care as HVO would 
be disabled, but that aliment is super weird?)


Assuming 64 bytes, it would be a power of two (as 64 is a power of two).

	268435456 (1<< 28)


Which makes me wonder whether there is a way to avoid sizeof(struct 
page) here completely.

Or limit the alignment to the case where HVO is actually active and 
sizeof(struct page) makes any sense?


> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>   arch/riscv/mm/init.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index 21d534824624..c555b9a4fdce 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -63,7 +63,8 @@ phys_addr_t phys_ram_base __ro_after_init;
>   EXPORT_SYMBOL(phys_ram_base);
>   
>   #ifdef CONFIG_SPARSEMEM_VMEMMAP
> -#define VMEMMAP_ADDR_ALIGN	(1ULL << SECTION_SIZE_BITS)
> +#define VMEMMAP_ADDR_ALIGN	max(1ULL << SECTION_SIZE_BITS, \
> +				    MAX_FOLIO_NR_PAGES * sizeof(struct page))
>   
>   unsigned long vmemmap_start_pfn __ro_after_init;
>   EXPORT_SYMBOL(vmemmap_start_pfn);


-- 
Cheers,

David

