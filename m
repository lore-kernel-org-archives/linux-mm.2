Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24A78EDA69C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 16:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9225A6B00B7; Tue,  3 Mar 2026 11:32:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F9B66B00B9; Tue,  3 Mar 2026 11:32:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8236F6B00BA; Tue,  3 Mar 2026 11:32:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 724B56B00B7
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:32:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20F688857B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:32:56 +0000 (UTC)
X-FDA: 84505295952.27.B2162B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 47E8A40011
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:32:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nDNY2kBm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772555574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FEL/TtVbe5ASgkwZnfcfemXJ7VYjUN4DKcL0dOBph1o=;
	b=n8x1uw257GVeeUrQ09NJ91bahLexZw9UmIjXv9nYvBkF85CwaqsalQZRQwFd8EnQ50jw1i
	RcnwHsfyrBBxo978kKc/iLNgkGW08lN6J3oaIgTbLNng9f0UJ/gbzik8styv0m6EnSu9ig
	Fm+gKPfoGWaubqFE82Ca+vAGbDCvBVs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nDNY2kBm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772555574; a=rsa-sha256;
	cv=none;
	b=e691bfptmp9PhAUj+0S2i2CuzRwojpT1NvJhOPWwAVTnqfvn/30l3AlVPg5s7MWnLfTRSF
	8E4oQakadW/BeIuBoy9a4fu7ok82pZmfYqQt3ENujeVpZhdY/tgBKp54ovBKUpTDjqxVZy
	MVB7biz+NiBJgpHmWM1WF+NV+l/o074=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3449A43F0E;
	Tue,  3 Mar 2026 16:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008A2C116C6;
	Tue,  3 Mar 2026 16:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772555573;
	bh=2Sl7aDOLhWSrJiQTk8Mgcff8zbQx95VCCn1PoV2FpZY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nDNY2kBmYN+NuwFo3thQ/sWHyhRgfQeHTyWHfBniHNjPL0oQI7rwVP4BAGGka2BVO
	 X2eonOQTORKw4QyAvBe8SHzxKvYYXyRcQkhx11QEY4iezHoyT64BtvBlX/zrslkt8o
	 TmzoL3Y7w1lww4tC8ombT9QBKmAzjT4qFDkONDvfp2oR2t+yNFM1oHn2WfDjnZrf73
	 BuRfV7dQttvocIgye8lvZLJHANLxlbrfIiIalPMQ6tZuJeSyCAHEsrZwI4tw/4bZbD
	 QmvrR7XLBlf8skl2ht4g6ytJIQCVDZVIfR9GCQISCD5amk7k+O3aibTOEoIWlXUS4c
	 s5pzS6NssRWLA==
Message-ID: <c5584cf8-1389-4df4-9fb7-19d9ee26ab9c@kernel.org>
Date: Tue, 3 Mar 2026 17:32:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/13] mm/migrate_device: Introduce
 migrate_pfn_from_page() helper
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ziy@nvidia.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com,
 lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com,
 willy@infradead.org, linuxppc-dev@lists.ozlabs.org,
 intel-xe@lists.freedesktop.org, jgg@ziepe.ca, Felix.Kuehling@amd.com,
 jhubbard@nvidia.com, maddy@linux.ibm.com, mpe@ellerman.id.au,
 ying.huang@linux.alibaba.com
References: <20260202113642.59295-1-jniethe@nvidia.com>
 <20260202113642.59295-2-jniethe@nvidia.com>
 <9ee22635-a219-47bb-a397-bc4e141b408d@kernel.org>
 <cf547dbb-af45-49d0-87a0-5267dedf0470@nvidia.com>
 <5182bb7d-f7cf-4b8e-8320-996c52fe24d8@kernel.org>
 <faaa84fd-095e-440b-9922-b4037a67416d@nvidia.com>
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
In-Reply-To: <faaa84fd-095e-440b-9922-b4037a67416d@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 47E8A40011
X-Stat-Signature: fa6u3ppim7kb4o97k7gwo1wejxsd7yg8
X-Rspam-User: 
X-HE-Tag: 1772555574-5360
X-HE-Meta: U2FsdGVkX19v+lf74eOEF7jsRtx/d84TGZ9thMMC7mo6shoqDPo6IE3nCBBGgZzU69JxtBvJA1HtlBIBgJNv5fRjwoo5wyH3bIbaLQhQqn3vY0qUZrGT3t9MpcF8x/Mqm6tqbMKd2Qh3BoWjjf2KqdLLrCbGf308DH8bVbyyEVTONzEIYIroYKsQR5liEH8kgIwaFIQDAI3RQJaSsLXIE7YfWBNRQv//sU/KeG8Cc9CSxgGFd1Ya0PXDW8+Sle+B1S4j9e+i83SjZU+RmDTST1yQXKoYbTT1iNlnG40tIl4EvrJBnbI5OVwiKxdX8A5i2H0iC/aJxZBg8qApsdOSHcfLP9BC2WKkQDg4P36HtOLMfK9bfXMMehHx/EZj/RyfJwyyll8S3fgl9nTNwSdSLrF7VVMSldQ300KJLNGSfC5joJMgNC8Ek4or/nztMjwohVTuN0QkmcRmV2q3M9oYvonnwYpSH9QPxVMl3lhDdYGIiZeVYz/f5OUcNXCidpk6TQ8+KhiejVyt6otcbJGDGMDRK+VK4PnYubQ1nnJzfo9638cLBdrdmR7HVhiQFSqFVRNzu/SG3ZVxrlEb2wOuMmRFQq0BlpzfsJmwDHkWvpcKDsnK3F53UGs/QRLvaQ3YW3Uqre5v4d9sT1fn1C1qeJ+GrguZgzrE/Rox5NuJFYBsw7J+uPHyq0Al2GvR/3Giq6SNHermutLQmg4Px1LoI9RiBH2NHSTdKRdp8JiVD9Y2DEMw4rjiJhoMsqBKsdpFXTtAmG4zzbhoCLEePRAwcwgxgYxr+7i2pVA2RiCINxLY4DzYXBmsSgqZhWTsr7GTk15ZfJ22/26rxIySHl1IePklYNfePYTiSv4RJVlcamKTTg4Zpq4XYz3Pq/7h1S4COdutWqWLbgW8K1W+GPA0fS1TIhJTIAW3LTeG/4cplc91sgMpArBd1AEYoIGz3BRxEE12O3nm7/QzotSQtvQ
 /tJ4+xRb
 fWkSqzbH3aJG447a2IR6RybuTGlD6AZHnvYXrHCYtQA6B2br2NQ0breyf4BUDNpfBg+xwSgTF5R0ZfTDSie0OMUxlxt5bTTayrQ4LGWJKmIPUgcLNwx9PgS8xjvEJyLLj3+Y7MtmMaaJA4+zenM4z9/ITW3nAjImdcJAIpFV1gZcA0pjGaty5v2nnYQ/bSuevAual6ite45PMOqIcMiApbiaMZbGTG6cLT/Ltjov9s8XFV1QkkH4wjunpNjD8rsEInoQNfrzaA2y9KmVJ4MAdXcnRaxRVDq0ilcQAda2KPBsts/F/Rd2580uad3Al7+B2nn8vlcKRkFjA0bY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 06:52, Jordan Niethe wrote:
> Hi
> 
> On 2/3/26 20:22, David Hildenbrand (Arm) wrote:
>> On 3/2/26 00:38, Jordan Niethe wrote:
>>> Hi,
>>>
>>
>> I'll go through he remainder of the patchset this week.
> 
> Much appreciated.
> 
>>
>> While skimming over patch #2, I was wondering whether
>> "page_to_migration_pfn()" would better fit "migration_pfn_to_page".
> 
> I guess you were thinking about migration_pfn_/from/_page() rather than
> "migration_pfn_to_page()"? Renaming it to page_to_migration_pfn() would
> be fine.

Yes. :)

page_to_migration_pfn() and migration_pfn_to_page()

But really, we should only be dealing with folio migration longterm ...

> 
>>
>> ... and I was wondering why that code deals with pages instead of folios.
> 
>>
>> E.g.,
>>
>>     page = folio_page(folio, 0);
>>     mpfn[i] = migrate_pfn_from_page(page);
>>
>> Should just be
>>
>>     mpfn[i] = folio_to_migration_pfn(folio);
>>
>> Right?
> 
> This patch is quite limited, essentially just converts usages of
> migrate_pfn(page_to_pfn()) to migration_pfn_from_page().  However, I
> agree, there could be scope for moving some of those usages to folios.
> 
> Was that example from drm_pagemap_migrate_populate_ram_pfn()?  There
> 'page' goes on to be used elsewhere in the function so we'd need some
> further refactoring to fully benefit.
> 
> I see migrate_vma_collect_huge_pmd() as a candidate for a
> folio_to_migration_pfn() function too.

All that code should be converted to folios (unless I am missing
something important). We only support migration of folios, and all
ZONE_DEVICE pages correspond to folios.

E.g., in migrate_vma_setup() we're implicitly converting from page to
folio multiple times, which is rather wasteful.

Now, I don't think the conversion is your responsibility :)

But you'd provide the folio helpers and use them where we can already.

I'm fine with leaving the code the still operates purely on page to be
converted later.

-- 
Cheers,

David

