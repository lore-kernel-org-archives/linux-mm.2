Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A66BAC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:29:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B89486B0092; Thu, 10 Sep 2026 10:29:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61476B0093; Thu, 10 Sep 2026 10:29:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A776F6B0095; Thu, 10 Sep 2026 10:29:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 826526B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:29:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D6DC160306
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:29:20 +0000 (UTC)
X-FDA: 85198085280.28.83BEEBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3FF7B4000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:29:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I/DKz63I";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789050558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u57NC1k6Bqf0mo7Kdt9/SiH0AeFRP72u3trAgFtt4Ns=;
	b=O0aYTS/VMJYh9CjraDXc/ahA/dAMexCOZgpiN1Z93ACwVn9FS8htCvOVny0KW+aD7hY+vd
	NKkFCcz8yppxhZadSsrQIivn4vcPvcgDh+aarY55gntdqvGatDC0gkhOLuVK8ciUsqUn80
	yyWlIKQ/Mn9dJ7Lu8/j2DUeO9jJ2foQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789050558;
	b=QnAd/04W8KJ6B2lXA9lnBsxqKvrDYy23tPISJO8di3uSWAFo/M9m49fgVKERQbGxpEKFXC
	MvbneB2nfBGsDWxQXFhcetOuC1PiQHbwl3lg9ljM7N9OXuQ9OEshida56OWEIVXz/oPUAX
	cHVWB6kzAhe0YBA93lPO27rp1I4sdiU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I/DKz63I";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 709EA4034A;
	Thu, 10 Sep 2026 14:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7D71F00893;
	Thu, 10 Sep 2026 14:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789050557;
	bh=u57NC1k6Bqf0mo7Kdt9/SiH0AeFRP72u3trAgFtt4Ns=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I/DKz63Io0owfDmvuXF1ij9DmOob8NZ36qEzesmm68JMcrvrYC1f9gjBLiqyS1NNR
	 AtCUF797lcT2SlhbFdyyfPMwXX7BVth8RKdT6q/+2i2gr+l5ZkVvEhyUoGhVzOTBBE
	 TPZQ+UX9U1okNoy8vHDfi6hfrlJ3BUiXuQoEfNuvUWkkawQ8KJOY8pC0J/xMqPhq+j
	 TbjK+5Q+Rj30wCkFfkJfcmIkdzpJrAKsK9oJPvJ5RVpQbDI3w2BX3trSlemnHEe/3p
	 2JLdlKg1fVyDjQDOYsSmtD5VuIKY26NLB+G1PhOILay33McJMAqhXw32euDxhrsGEL
	 +s4H7uJsegykQ==
Message-ID: <c72f7358-cb6c-448d-9ce9-c17b425964bf@kernel.org>
Date: Thu, 10 Sep 2026 16:29:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/12] mm/sparse: move __highest_used_section_nr handling
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-8-008fc8d579fe@kernel.org>
 <aqK2_RpAlMbVYcuN@gremlin>
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
In-Reply-To: <aqK2_RpAlMbVYcuN@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: uzbhzftjudnftbwc173ciy9adunyizco
X-Rspamd-Queue-Id: 3FF7B4000A
X-HE-Tag: 1789050558-80923
X-HE-Meta: U2FsdGVkX1+sLZUddA5BEXpAl9h3CxC3NL1ufCUoMCjDQKgrCfM8gNzp0T4M9+YIopLVSRvBwhPFFdVE0XN25xwCpxJhcsw1En1aHonZY1Fg+P+ZZvg0qXKY0V50VZducGO3xRl+yJaSJ44lLiZ6lwWQLGCefNGA9CGkKJMlcuoF+HtvXn4hsAw3tGpYcFy29R+ZLhkJfmf+iyQJlxQVrvh414a1b7Tkz8Pm7YR2YhzLpHTgsh7lBs4PVzKSy3NFog3IZ/l6eiCry91tYIhVTmGHQpKs0viXejlRMiSPrAfQxUF9JBHXeRajLL8jC+szSy8/GDv6DeNdHzqdkDVVpEiPyD5VHIbZXUEz9GcK3Vvpoup5lEsIF+zkQev9TqnCoVvO//Z1g9Fq1B2GFlJZPnxm1X4vuKi3S75pa15JursrBP7pCI31iRDH2DvGh/SS1gNvHBnibYfn2ogelTXJmBEl8s5/zeFGngjmPGTOj3CCg/BdQGCDDKgSce8vkXWFelwJIqtuk6bAa0MxaA6O8Ds/eKM6WL6wNRmWwafi/cYTN+XgZFhBB/Vm5krHoSM8kfpl7wZPB3GDFu4UjsX1BPfiFElYMHQADsRz/sPYHQ5meYwue76bN/21R348mem0dXnv5v/QeypAT08cl9impUagexJZBJlXuOPC6w6rnVN1EnLDAzhAUfV0CIGz/51TirFIUHbJOOe/5Sqlsxz5yQe6igexgBN19/Nbf7fcdqtn4c0nPXL0nPktHZiklwTOAuCVjz21DaGtrZWTeAjpl1b8qs3YCd+jFoCMccR0oWB/5AthO8GZM57wli0crRaqD7H3hmPbp8WjsU3xPwFsYkVGqn5SI5gD9HtYD4yiF251R8rvRnpMqtvhkG86fqls6gVrSMzvY5YoY+WxwqzkeWS2fntfKEyp6twTpFbdyroSR6RB5bgKtKyD4N659TMXDNmVRNTRdCjb8CRJ2d9
 xe4SHuNQ
 sk2VNFJ7t/O3UggwmRt0uFNNjwdAGxgA6j7j2hfJUS8r6KAeM+caJad4PuymK49SGECNx7dAZAiAmpeGUxP9peUgJbG0woJHFI3We3mBha8HS7X/fB4UJvhfVP/Kg5gtYcJ+M0/AvxwrFZtkDZ9oqW3PqxYvplpeEdjnariWyrNQIaXObOGyuAUM5M99dzmWoooaWBIApsB7nw26jm+NBp6GAiH2TmGj1PMZ9xPKEz8QESnE0xWjXgCXaGY5LPMM21Wydyb7T9y+70uvPEGhjKVo87n6h859wpz4MGO2N1GrN6UAibxX/u20gIPDtEC7qtZrwXrKjflRevQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 16:16, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 09, 2026 at 03:33:01PM +0200, David Hildenbrand (Arm) wrote:
>> Let's move it to sparse_init_one_section(). However, to keep early
>> boot processing working, we also have to initialize it in
>> sparse_sections_init().
> 
> A why might be nice :)

Agreed, I'll mention that.

> 
> I guess preparing for removal of __section_mark_present()?
> 

Right intuition :)

> Also good to have arguments as to why this is equivalent of previous
> behaviour.
> 
> E.g. higher pfn = higher section nr so naturally the highest is the one you
> end up wtih at the end of sparse_sections_init()?

We go over all sections, just earlier.

> 
>>
>> Should we use READ_ONCE/WRITE_ONCE with __highest_used_section_nr?
>> Probably, something for another day.
> 
> It might be worth expanding this a bit. Do multiple threads read/write this
> concurrently?

Hah, I'll probably just drop it. I was just stumbling over readers vs.
concurrent updates and thought "that looks suspicious".

> 
> No functional change intended here or is one intended? :)
> 

Certainly no change intended ;)

> Before it was:
> 
> mm_core_init_early() -> sparse_sections_init() -> __section_mark_present()
>                           sparse_add_section() -> __section_mark_present()
> 
> Now:
> 
>                                                  mm_core_init_early() -> sparse_sections_init() [early]
>                                                  sparse_add_section() -> sparse_init_one_section()
> 
> But also called from mm_core_init_early():
> 
> sparse_init() -> sparse_metadata_init() -> sparse_metadata_init_nid() -> sparse_init_one_section()
> 
> Are both required?

sparse_metadata_init() relies on __highest_used_section_nr in the
for_each_early_section_nr / for_each_present_section_nr, so it is required.

I could probable move the update on the hotplug side into sparse_add_section()
instead!

> 
> 
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  mm/sparse.c | 5 +++--
>>  mm/sparse.h | 6 +++---
>>  2 files changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index 2b41ae36f20b8..2d0f2db34f4cf 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -177,7 +177,7 @@ static inline unsigned long first_present_section_nr(void)
>>
>>  void __init sparse_sections_init(void)
>>  {
>> -	unsigned long pfn, start_pfn, end_pfn;
>> +	unsigned long pfn, start_pfn, end_pfn, section_nr;
>>  	int i, nid;
>>
>>  	sparse_extreme_init();
>> @@ -187,9 +187,9 @@ void __init sparse_sections_init(void)
>>  		mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
>>
>>  		for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
>> -			unsigned long section_nr = pfn_to_section_nr(pfn);
>>  			struct mem_section *ms;
>>
>> +			section_nr = pfn_to_section_nr(pfn);
>>  			sparse_index_init(section_nr, nid);
>>  			ms = __nr_to_section(section_nr);
>>  			if (ms->section_mem_map)
>> @@ -201,6 +201,7 @@ void __init sparse_sections_init(void)
>>  			__section_mark_present(ms, section_nr);
>>  		}
>>  	}
>> +	__highest_used_section_nr = section_nr;
>>  }
>>
>>  #ifndef CONFIG_SPARSEMEM_VMEMMAP
>> diff --git a/mm/sparse.h b/mm/sparse.h
>> index 7c5d82ceb7142..a3af4967fd5c5 100644
>> --- a/mm/sparse.h
>> +++ b/mm/sparse.h
>> @@ -97,6 +97,9 @@ static inline void sparse_init_one_section(struct mem_section *ms,
>>
>>  	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
>>
>> +	if (section_nr > __highest_used_section_nr)
>> +		__highest_used_section_nr = section_nr;
>> +
> 
> Could also be:
> 
> 	section_nr = max(section_nr, __highest_used_section_nr);

Ack!

-- 
Cheers,

David

