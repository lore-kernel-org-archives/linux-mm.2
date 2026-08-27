Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45F65C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 10:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09C5C6B0095; Thu, 27 Aug 2026 06:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04D5B6B0096; Thu, 27 Aug 2026 06:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4D56B0098; Thu, 27 Aug 2026 06:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D58D6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:56:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0EABE801BF
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:56:31 +0000 (UTC)
X-FDA: 85146745782.09.83923AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 35DA4C000B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:56:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hqAkKGTh;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787828189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFSoHGGqxxziGMu2IRcDTRzduPnwUAK7ed4z65urCyM=;
	b=3PslpPHVlazwakZtiH0g6kiwsue7a8ki/onTnCCWXULMWrb/TVByCs1o5qzyJ1nIRGjjJj
	B6W3RHYrTEJsNGOcUJAsUSejAHDWK3rniPSxVey2uGH54TYoUbGWn0JQPMgAdH9AFfnJAj
	iwJJb3qBM7UEtgl3BnFTykM2ibzbWuI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787828189;
	b=m4feifYX9qoIzILgUmOCT5jEqD65Le8BNJH9EjUBuN+BqFu2TpeZ0079ClO3woDfc+e9y2
	wz414wQU0J8MFITfSdIkEpFK38wLOw8hWXBeIFHwSDZ5Kv3ayjVzSPApKGmqp4GZ+SgeAO
	3BvMclMZxYZs2J3wEnuB/l4jA2wjIlE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hqAkKGTh;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A8C8340832;
	Thu, 27 Aug 2026 10:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884EE1F000E9;
	Thu, 27 Aug 2026 10:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787828187;
	bh=NFSoHGGqxxziGMu2IRcDTRzduPnwUAK7ed4z65urCyM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hqAkKGThxGJWMDhKFcSqIWlnjHYbdxq1MeNgfjxCRuLwN4q6Unx/ArGi1iZEnVRvu
	 Iv7dJcszqIzAJbFJsWXjHXD1+RsWJUxwC8j5Ks+evINia+X5Ozh67I5DYAQ53x2sA6
	 ImjOty7oGpySiMZzOvF75EtrAk5qVpXX2dRmif+/T1O+/UGu9i7E+5tmYuVhWNWUxV
	 wbTlrMwiZOTS1625hnk4jnRHRraUo038M1/ftEcQCVtClBMO5Gf4u42PMvrCDsm8nG
	 jGP7E7920p8wsb0FNIMiK5eJs+xLOaIUtwoG3yz1aEZq1G4QC1bOBA7M+Oag9b2hiT
	 1xm3sIdxFgf9g==
Message-ID: <44d36fb6-fdf4-4a8b-8e74-084a4b4f802e@kernel.org>
Date: Thu, 27 Aug 2026 12:56:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260826-fix_split-v2-0-71153c7f579a@arm.com>
 <20260826-fix_split-v2-2-71153c7f579a@arm.com>
 <0107447a-7c1f-44f8-94fb-109b0f850677@linux.alibaba.com>
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
In-Reply-To: <0107447a-7c1f-44f8-94fb-109b0f850677@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 35DA4C000B
X-Stat-Signature: jsquef9z6nahgo6pfeg9zyzzcwda7qx7
X-HE-Tag: 1787828189-534108
X-HE-Meta: U2FsdGVkX1+LIUlbao/fpBjD/Rv+yMtlsNiHkAbOmzoksPYfUp9OuZ2RdYuahVtIMZMUKWQwObuSCNcF5fMWrwGTuyFiCpktiw5+xDx7kW8TX0gq4AImfQ4X0jZTWeelLG0AOHNJ29cfoXeDRiwTskfARIpUGLcqrWje5TLLWkzFDYdvi1rHsBO5W2sP5aZfMsWsxStqJiDfqqYSwnZHWhWldgZQShjBWu9Frx4ehbz98WwM8NS7U0T1vL8rejfxKzJuhfRDpMRUjK9Ylcz7SUA8n0jP4N++BBOrgiLtUzsGAwfsvmowrtWRrZ1HOKE3IFcOVCEdGHFLwUs/iLmT9CSzbmXaR6Co8A6bvBcdWj7nGXzFhx55gQMgBJM3ExwmiA5L3Ye+QNb/fpbYKHflObJxwBwfMGQFtzThlZbcG5+5FVCtId4ths3rjKpjPKCaPPIxZ7pHrFoGABHIvSF/igV4Rnw2RPX8pToRdZryIFa2gt0kI6rXm1pEG9jFvgBxQ7VenDpWI1I1LUwK6e6ZIHt2eaD4FBYTG/2GQDoqeJPu12ANMLEZjLwVauOqVyGQ7CyzHNG+/1M/hf1tbfS522WIdJJDcgbWsJ/9z7L2guUshwEVnK4Slk/Zg+QBJ8KdWTE3itbnTer6LbPkA8tY/6Q3Z8Fu0LZObq46yVMjEOdyxGAQehI1OOrgkCcFFuZr5eroSjMZFyG3RfhZSEwaR1vlKQIIo8GIv7XR54PP842aUUrCdwZHbNpHiHZmX2u4Ynvc/g7WnpTHAjC7iqBVVQdlG3wBOu49r+2ol7yW07LdE34F7SkUzlQeaFTpVi/+mLBMV5nnMqheAh+Ew9dzPKOfdRn7tkGhbKlGgmEW53Bt1EjAnCDh93MvOF9gKcrlwDGkAz9WkWz2tmfiEC1YgftxJfePOcQMiYIotoUxoraVrAJrLyYV09zq/+UjH7XAmoN7+VtOCios2Tx+IFr
 W0qsJxxS
 bwhx9GrG6qCQ7lR0Mrbu8HMbyKVzkypoVFzYKK54cynB36uZq1sZTytNb8mHdwRnWktpuIEhxeYSAZkpQGfwAC/30H8miVxjtDjhnilUqBIRp3D2yUl7FK4PxdqwPTU4jWdMesr0oC2aSUSG74VubqGbtGLutY0FQgt7VRwvkpGs3noeBj2oOMxmv/u5OVNu4AEfKiL19esMEVKBgZSPMUT1C0S0/2cX/HOprONlmaVWpx8+8YLaI4+mlvjOhBjB1oSC9mwuofv9ulMCXNSGUIE98ly1JYLoZfIegNtAZvg3ZqhLvDQ24KYYPzVC7Ore+bDVSQTF01aF2+4pLU/aNmiLn5RLu4iqKeQ8aCO1tCF1Bb/JkuVHdaYy2QSlnm3WPq902lkvUCrdp4nvblLDQNhUIjkA6VvTehze0rQGfowYqrMy44mv7S8f87Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 10:28, Baolin Wang wrote:
> 
> 
> On 8/26/26 8:24 PM, Yeoreum Yun wrote:
>> Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
>> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
>> made by memalign().
>>
>> The underlying VMA may start at a different address from the aligned
>> address returned by memalign(). Furthermore, a subsequent
>> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
>> already set.
>>
>> This causes split_huge_page_test to fail because the check_huge_xxx()
>> helpers incorrectly require the address returned by memalign() to
>> match the VMA start address reported in /proc/self/smaps.
>>
>> Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
>> /proc/self/smaps to detect huge pages.
>>
>> Reported-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>> ---
>>   tools/testing/selftests/mm/vm_util.c | 130 ++++++++++++++++++++---------------
>>   tools/testing/selftests/mm/vm_util.h |   1 +
>>   2 files changed, 77 insertions(+), 54 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/
>> mm/vm_util.c
>> index 4821a3563036..1d0959b3b9e8 100644
>> --- a/tools/testing/selftests/mm/vm_util.c
>> +++ b/tools/testing/selftests/mm/vm_util.c
>> @@ -351,31 +351,13 @@ char *__get_smap_entry(void *addr, const char *pattern,
>> char *buf, size_t len)
>>       return entry;
>>   }
>>   -static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
>> -          uint64_t hpage_size)
>> -{
>> -    char buffer[MAX_LINE_LENGTH];
>> -    uint64_t thp = -1;
>> -    char *entry;
>> -
>> -    entry = __get_smap_entry(addr, pattern, buffer, sizeof(buffer));
>> -    if (!entry)
>> -        goto err_out;
>> -
>> -    if (sscanf(entry, "%9" SCNu64 " kB", &thp) != 1)
>> -        ksft_exit_fail_msg("Reading smap error\n");
>> -
>> -err_out:
>> -    return thp == (nr_hpages * (hpage_size >> 10));
>> -}
>> -
>> -static bool check_large_folios(void *addr, size_t len, int nr_hpages,
>> -        uint64_t hpage_size)
>> +static bool check_large_folios(int pagemap_fd, int kpageflags_fd,
>> +                   void *addr, size_t len, int nr_hpages,
>> +                   uint64_t hpage_size)
>>   {
>>       int order = 0, pagesize = getpagesize();
>>       unsigned int nr_pages = hpage_size / pagesize;
>>       int orders[MAX_NR_ORDERS], status;
>> -    int pagemap_fd, kpageflags_fd;
>>       bool ret = false;
>>         if (!nr_pages)
>> @@ -386,15 +368,6 @@ static bool check_large_folios(void *addr, size_t len,
>> int nr_hpages,
>>           ksft_exit_fail_msg("invalid order\n");
>>         memset(orders, 0, sizeof(int) * MAX_NR_ORDERS);
>> -    pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
>> -    if (pagemap_fd == -1)
>> -        ksft_exit_fail_msg("read pagemap fail\n");
>> -
>> -    kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
>> -    if (kpageflags_fd == -1) {
>> -        close(pagemap_fd);
>> -        ksft_exit_fail_msg("read kpageflags fail\n");
>> -    }
>>         status = gather_folio_orders(addr, len, pagemap_fd,
>>               kpageflags_fd, orders, MAX_NR_ORDERS);
>> @@ -405,48 +378,97 @@ static bool check_large_folios(void *addr, size_t len,
>> int nr_hpages,
>>           ret = true;
>>     out:
>> -    close(pagemap_fd);
>> -    close(kpageflags_fd);
>>       return ret;
>>   }
>>   -bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t
>> hpage_size)
>> +enum check_huge_type {
>> +    CHECK_HUGE_ANON,
>> +    CHECK_HUGE_FILE,
>> +    CHECK_HUGE_SHMEM,
>> +};
>> +
>> +static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
>> +                 uint64_t hpage_size, enum check_huge_type type)
> 
> The original __check_pmd_huge() is only for PMD-sized large folios, but now it
> not only checks PMD-sized large folios but also mTHP large folios, which I find
> confusing. Please keep its original semantics, and only check PMD-sized large
> folios.
> 
>>   {
>> -    uint64_t pmd_pagesize = read_pmd_pagesize();
>> +    int pagemap_fd, kpageflags_fd;
>> +    uint64_t pmd_pagesize, granule;
>> +    uint64_t categories, kpf;
>> +    unsigned long pfn;
>> +    bool check_large, huge_mapped;
>> +    char *start = addr;
>> +    char *end = start + len;
>>   +    pmd_pagesize = read_pmd_pagesize();
>>       if (!pmd_pagesize)
>>           ksft_exit_fail_msg("reading PMD pagesize failed\n");
>>   -    if (hpage_size == pmd_pagesize)
>> -        return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
>> +    if (nr_hpages > 0) {
>> +        check_large = true;
>> +        granule = hpage_size;
>> +    } else {
>> +        check_large = false;
>> +        granule = psize();
>> +    }
> 
> This is incorrect for the mTHP large folio check. I already hit a selftest
> failure. Please test your patches before sending them out.
> 
> [root@]./khugepaged -c 4 mthp_khugepaged:anon
> TAP version 13
> # Save THP and khugepaged settings... OK
> 1..4
> # Allocate huge page on fault... OK
> # Split huge PMD on MADV_DONTNEED... OK
> ok 1 allocate on fault and split
> #
> # Run test: collapse_full (mthp_khugepaged:anon)
> # Collapse multiple fully populated PTE table.... OK
> ok 2 collapse_full
> #
> # Run test: collapse_empty (mthp_khugepaged:anon)
> # Do not collapse empty PTE table.... OK
> ok 3 collapse_empty
> #
> # Run test: collapse_single_mthp (mthp_khugepaged:anon)
> # Collapse PTE table with half PTE entries present.... Fail
> not ok 4 collapse_single_mthp
> # Totals: pass:3 fail:1 xfail:0 xpass:0 skip:0 error:0

FWIW, the CI flags this as well:

https://github.com/linux-mm/linux-mm/actions/runs/33028595020/job/98375618491

-- 
Cheers,

David

