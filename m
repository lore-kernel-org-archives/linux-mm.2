Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B316EC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 903AC6B00E7; Fri, 26 Jun 2026 11:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B48D6B00E8; Fri, 26 Jun 2026 11:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77E056B00E9; Fri, 26 Jun 2026 11:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 43E3A6B00E7
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:58:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE0E6C21CD
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:58:32 +0000 (UTC)
X-FDA: 84922521264.12.F807574
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E781140006
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:58:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eiJy/zda";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782489510;
	b=ZqzZfaAOh+1Ercp9Y8Owx+P+nfg7AcunixYk9c2uv7CKcSai/fSVMcalGm7/ovl8SE8ROQ
	587VUMZLglDWQ0L7oD1A1t3pq7gNt7UWT4GBzeSF1MFtak+i4E8BqtBmHKaiiD1k9wPkOo
	vBNK/4O4sXczHMhI0vGzDjIm/Up7BCk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782489510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H6d+YLPQTkEvAUlX9G2988IQYpQyGM7qnUDQ1M55AmA=;
	b=RgbNRGxVt+uD9MYROIlRMOsCQ4bNLIO3usm/YRLrx3lFPanfYYU1SWHaISamPp2kVS2cN7
	4cZpDWZv1E2MrwDi1Oxf1yJthdTrZkQHjWyLUfJexvjGgBcSqqbDWkz9KAI8CuWD1GB3OX
	eIywMwbvwQg29xE2go9FYMpDgiSO6Ng=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eiJy/zda";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 424EC600DA;
	Fri, 26 Jun 2026 15:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B607B1F000E9;
	Fri, 26 Jun 2026 15:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782489510;
	bh=H6d+YLPQTkEvAUlX9G2988IQYpQyGM7qnUDQ1M55AmA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eiJy/zda2dkjWvhl72LqpuslGv70vZCKzdM+1+82fNF3ihLtBA9e5sChiFSthzH6r
	 RMwCIcjusgL3BEtZ67F+LqwaPbgPelTrDjV6bLrgn1wRiIRDtTPU2o80x3YaNQ6KQm
	 UI8m6pDX3AH0G8z6yG+wGMDgorpz2nhU+Qt7h/MEhTtfB33/Ynx+msP9wPYgiGhCNX
	 LRnIxj6OzDpDq1jE8aVgDcRzbMVburr+lv91ybgLHFTBOfJT9FVs66m9UrxlpSjmy8
	 m5SZZhdJ95aCy0+IAD1fb60OM2XQPEhgK86nLBt0Ot9K27d81gqrHAFGwIEESsUmTW
	 B/F9mEO/OwQAw==
Message-ID: <e759c145-f55a-4b23-8aa7-ae0342a7cebb@kernel.org>
Date: Fri, 26 Jun 2026 17:58:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: mincore: use walk_page_range_vma() in
 do_mincore()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>, Gregory Price <gourry@gourry.net>
Cc: Pedro Falcato <pfalcato@suse.de>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org
References: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
 <20260618092845.3905740-2-wangkefeng.wang@huawei.com>
 <ajPZlxq5z1hyo1kE@pedro-suse>
 <42e167b2-5676-45fd-8f3a-738d2f4f6623@huawei.com>
 <ajP9bQhmvR9OX0VE@pedro-suse>
 <e7244b54-d794-4e46-88e7-69204da2b60d@huawei.com>
 <20260624193852.2a1ac8a187978e4baa75f47e@linux-foundation.org>
 <1b34ac03-edf7-4219-a334-1e7b7292129b@huawei.com>
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
In-Reply-To: <1b34ac03-edf7-4219-a334-1e7b7292129b@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mkk4ikwcz7ajj74drxoxm143euetr6k6
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E781140006
X-HE-Tag: 1782489510-864598
X-HE-Meta: U2FsdGVkX18gCzRAzsbxPn5C0WKaDxBDbW12ZsUR0TwB05UK/sHn/wgEZfYxdP6NDcfZ3fiafQUv/MOQTNIMstjrRm0ORzPcmXHs0PS9YWcr73P85aw5kMaJxMc1QULezyX4jz86wA6cI3aMC10gtVYWLT7XvtyJ9bZBoF7tD3B/kBk1U0NcKnujm1jgqg0xm1p7OrC/6q2XFfrJBYXjjY14FQHhYfTzQ+OOx+WLRVz1gKKfmGYok29DLfQCt5hv5QrNRFqLyGspcxYOz0kulY5Cw3+nqclCwenGz7J9/N7jUiJcwwYSwjJVyMztvtx0FuTVrmYwSmAOYQRTqSsvDe86H+nTHVU7oQWb8S5r93+4Irfd1z5S82gCTJUTPx4nAhprW65kbChhcf66QWkqAh7WyO90D7yoEffuhvBjR7f3H0rAyaBSUy+HIrd/M17YXRF2ratHhhB+Bpaf3HmRRgUYoKHY9u1AMk5M9xuGsjtzYhZ7TkOxD1TfTann2ifQ3Hb1S0QcRQVKr8RE69QjeMTyBugWbIRi4u+8iscjwdppYaHhMUdLfhlhn5TuZUDqDitHleGJcqFHvtvALIvd30tG7ruaeSlZwwX7PglewcK0fVOlG9rOE6xqDhw1o6jMT6/375XxH3uvKLHMSThBtSpyhW9NGgdWWqEfcQrFtuGOvpGTBHLAqj6SQeO/H+9Tr1cszZ5ENbuKejTgk9leEu0jsSm8L5qK9qjMXrvEKhU++bvVyvwR5w/oa2N564UC0AJDMiaODO3Hunqa7yoV+J9pOpZb+cT++Hv5jsd8Mm6nlSaC1EJVx+Udx5jVNo9VgfWjLQXmU7gLa4yV651UYFkP/AUn3RMsBRpJ3pO76k0IQPf0QmnGR8uc5vTOjboTJxBvWtF7p85Am4zsciYSVgiN56nVf3SIi5zvnfpoNiUyCgHAdaPBXW0orioxKE1EW7b0BIFImyNZOX94ooA
 aNMfa7tP
 cyxrYQjAFPLePahYZ952bZ87tzmkThcUQ/UWt98UvvjKAMyR+pWO1U75XGJtyBklCWvDdka7ohBxuSONwHhXOYl14qMoXX+8DbW+W6lbr07RUddFlgoo6shsNN+pSqqWM46+Kn6zZivFxrXFJw/y3doBP1+nbuYKT1m36giZzBLqrQZMLzubUEXm9b7TlKeIy0aPVSYIPmK4FpXc8Zhn3v5Juv6CI922K88FR+37IqwX+UV6HrBzKQjlc3AEgRTB3CHSiRx6tkd9tHgMWY7joJ4mSePvT+/FOBYAZR74gzkBhnyH2ROnzePNW715UaeoOaNN0yiZwQAFuw4KfssdYBpHmAZUaQGVabU9fqLNGBbmV0jaJpuPz1gYM/7DM2eBSsLOmq4d1KL9aJa6fHyr1Z53+UA9vajI/+t52
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 17:21, Kefeng Wang wrote:
> 
> 
> On 6/25/2026 10:38 AM, Andrew Morton wrote:
>> On Mon, 22 Jun 2026 11:23:11 +0800 Kefeng Wang <wangkefeng.wang@huawei.com>
>> wrote:
>>
>>>
>>> Hope Andrew can fix the comments when pickup patches.
>>
>> I added this:
>>
>> --- a/mm/mincore.c~mm-mincore-use-walk_page_range_vma-in-do_mincore-fix
>> +++ a/mm/mincore.c
>> @@ -261,12 +261,7 @@ static long do_mincore(unsigned long add
>>       }
>>         /*
>> -     * walk_page_range_vma() does not call walk_page_test(), which
>> -     * handles VM_PFNMAP VMA by invoking ->pte_hole() to skip the
>> -     * page table walk. Without this check, PFNMAP PTEs would be
>> -     * treated as present by mincore_pte_range(), changing the returned
>> -     * residency status from the historical "not resident" to "resident".
>> -     * Handle VM_PFNMAP explicitly to preserve the original behavior.
>> +     * mincore historically reports PFNMAP mappings as non-resident.
>>        */
>>       if (vma->vm_flags & VM_PFNMAP) {
>>           __mincore_unmapped_range(addr, end, vma, vec);
>> _
>>
> 
> Thanks.
> 
>>
>> Sashiko is OK with your patchset, but it might have found four(!)
>> pre-existing issues:
>>
>>     https://sashiko.dev/#/patchset/20260618092845.3905740-1-
>> wangkefeng.wang@huawei.com
>>
> 
> Sorry for the late, this is pre-existing issue, I am not familiar with
> zone devices, so just focus on my changes and the subsequent
> changes related to mincore.. After a quick review, most of them are not
> issues based on my understanding.
> 
> + CC Alistair and Gregroy for migrate_device.c, also Zi could you help
> to check it?
> 
> 1. mlock.c, ACTION_AGAIN
> 2. migrate_device.c, goto again array overrun / double counting
> 3. migrate_device.c, softleaf_to_folio VM_WARN
> 4. migrate_device.c, pte_pfn / pte_dirty on non-present PTE
> 
> I think issue 4 is real issue, a quick fix is
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 554754eb26ff..3ccc4fc1015c 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -401,7 +401,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>                         bool anon_exclusive;
>                         pte_t swp_pte;
> 
> -                       flush_cache_page(vma, addr, pte_pfn(pte));
> +                       if (pte_present(pte))
> +                               flush_cache_page(vma, addr, pte_pfn(pte));
>                         anon_exclusive = folio_test_anon(folio) &&
>                                           PageAnonExclusive(page);

That looks reasonable.

>                         if (anon_exclusive) {
> @@ -422,8 +423,12 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>                         migrate->cpages++;
> 
>                         /* Set the dirty flag on the folio now the pte is gone. */
> -                       if (pte_dirty(pte))
> +                       if (pte_present(pte)) {
> +                               if (pte_dirty(pte))
> +                                       folio_mark_dirty(folio);
> +                       } else if (softleaf_is_device_private_write(entry)) {
>                                 folio_mark_dirty(folio);
> +                       }

The pte_presnt() check looks reasonable. But dirty handling is really
responsibility of the device side user.

So likely just

if (pte_present(pte) && pte_dirty(pte))
	folio_mark_dirty(folio);

-- 
Cheers,

David

