Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C88C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 07:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6283A6B00A1; Tue, 22 Sep 2026 03:54:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D9586B00A2; Tue, 22 Sep 2026 03:54:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EEEE6B00A4; Tue, 22 Sep 2026 03:54:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8F06B00A1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:54:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 053A7C03D8
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:54:45 +0000 (UTC)
X-FDA: 85240636572.29.0248FF5
Received: from mta0.migadu.com (out-106.mta0.migadu.com [91.218.175.106])
	by imf29.hostedemail.com (Postfix) with ESMTP id A66D4120005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:54:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xd3a6B2s;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.106 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790063684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TP8hP/DR2YONPSF2v1CC1+QNgDBOk54Or3SAgzas86o=;
	b=sd2LCv3WHmRjZVBkXqXO04gjS34jdr8lR1G2Kcxvs6VlEY60h9uXhJPC/ADO1s0cBMcCud
	0IZ5doEoY2WW950on9kBPfa8fCHB2QWIj3/3fIDDEtIMQQrD/GVKq1Dmh67JvEAP7NegqK
	GFN6cljlghhSePZU423/Acf/g84yyfI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790063684;
	b=B/WBPH0JtGUQ1TYDw5JNbp66IoQmwjD/lzEhtNOdI1mrCI3/ebDCcSeNJBH8BLunuxe5aS
	CODzt3blLqTGUdF4ngdf+yQtcFHVgL0/AbaztiVCvT8Kpk0+tgw0IsxnEI7c2qsCAdtv2K
	pN63pCxu4N31V/0T7cYjdBPYNTE/vqY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xd3a6B2s;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.106 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0TJo2ZSluV7GOtUR+gK4tKoCDniJGIYoMCtvZ+NvpCE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790063682; v=1; x=1790668482;
 b=xd3a6B2sQAwINnfLcvWZCJdEhKDv1yDJIwF5I46000AJKB+hlvozpnyNd+wNXV4nYxB+VkPh
 FuBbSScASCv0iMy+TNJDfXqCu9P33f3fHCMeAZRZzQAHxXokyl/W8gsnX9RmF1DCl6RRUf7Wl2p
 TVk26UoXZWkAAaCoFfgFQons=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 994fcd1d9a4dc67b;
	Tue, 22 Sep 2026 07:54:32 +0000
X-Mizu-Trace-ID: 994fcd1d9a4dc67b
X-Migadu-Flow: FLOW_OUT
Message-ID: <47038cfd-59a7-4dab-891c-0469cbeb37c8@linux.dev>
Date: Tue, 22 Sep 2026 15:54:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260913083734.86802-1-songmuchun@bytedance.com>
 <20260913083734.86802-2-songmuchun@bytedance.com>
 <186ee2ba-daf3-4120-a3e3-101cac1ff5a1@linux.dev>
 <4AA6C66B-0FD8-49F3-8447-959A3E438FC2@linux.dev>
 <95d326cb-ebb4-492c-9062-5d373609e18b@linux.dev>
 <6479325A-E6FA-45BD-9392-262E71467EDB@linux.dev>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <6479325A-E6FA-45BD-9392-262E71467EDB@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A66D4120005
X-Stat-Signature: 5butqrdtn5d9q39w9ugphp7w3r759xhc
X-HE-Tag: 1790063683-611260
X-HE-Meta: U2FsdGVkX1+3w5oRau7WNtRzXQL/8A+yJIwJ0hI/mTzdowP9YFibqQtrwwi5yeXYzsV36kvJmJo9+uT/g79RALMtv19Lv2czZDArXqsWWtVTqSkhT9Ye4zotDBbdfzEfGbhmDh6Vc0nPQGWpGrmWrQnYlq63XCfZqKNLlGopQsM2ZaM4RjBT6oHzRLPZPOplml7uU6svZr/8XHf+T1gJOK6CMS/iJhcNilf+l+0uZ/YdvvZrFrF9b6/kghLjGC9Fx1kj9IIrjDyC9EqKmyhsNB4dHpLW6J3RUGoXHOYIyN3bDGXWJduIga2FxotQEeCqthi9e78q8v5pUUvh59C1uxz9vyPgKt2Gf/dr8qH7/NiFT7TLeM4mHPff09XSx5r7dmRRYxXGn4kpSS5lNYQGWV1ZuCtnUgqkgVCWl9dVBSF5O7jV/C6wqsjoRORzj73CvxtKhFXIcEKXa4KeCvlrYR5Or3qioVtuMkd4V7S9xL7hrz2AtOO5jbeycj/2/ViDsLH0p3Ao/aBQ8L7sj8YyZhk06Co29kVBD4Vvv4MNT7C4E+OWoX1ac6nTksQ780wsEEwbOZQpkKh2nkHUH3fURppY+fxRgWXGEaSwcrVzUiTiiflDSkgbpj83Q4PIS2x2dSVhiNay45uNOZ+05+zoEiE9wmUC9m5Jf1phozeD4OClYZkveIHF+TtNXlFXuZo9nNn3a5usoSrhOj6KyVZ9aSC+ZIzWehsxObr2iUkZ6MU8m+VcroWlrdEDYosDYGxaaQWeHEISbtiHriNRpwbEqITDFYEl87GVrYLpmmTAhpQ0BSHDBMmI7peBejG+KA504vr7EghYyyQcPtlSfsSyZQ/UtQWFIHTYkYH55zmDt12aklmy1mJ/SwzP/LQjs401vt/YZaqWrwOvwO7Cu4zQy3fTfpuYK4sExxBYJENU6fGpYRrY6RqcSzzx8bB/If/X7SpNW050BOMSD87AVbV
 gCsE6iA5
 ZzWMBtjTgvSBy0CqQRf4se7hA9alQ74Q971UPjlgog1MIPIBPFp9gXvIj/66fCV2f/di9+9UxsVX+B3/gCmqmKstEkBmUKpAEfXpZ7UjsAxGVLU4961t5OjkGfBF4vE9lugkrITgb1ZzmC44Ix+CPWrh9jbu5EkI+09AfFoCE4Ajm6l4xU3vuCxRtN1avlvkhM0p/uMhyeQp+sLPEXu327BFfa7TPfpfwSWcAmb8a8/jhjiKOY2bfSPnsu+lUhC/3wV0/sS2Ewb07NQdOl4CwU9l/StvCuGZXJBiPnAeUdZzpQJ/yk3JGlPUFv62o0gtCHopj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/21/26 11:49 AM, Muchun Song wrote:
> 
> 
>> On Sep 21, 2026, at 11:43, Qi Zheng <qi.zheng@linux.dev> wrote:
>> On 9/19/26 10:07 PM, Muchun Song wrote:
>>>> On Sep 19, 2026, at 22:01, Qi Zheng <qi.zheng@linux.dev> wrote:
>>>> On 9/13/26 4:37 PM, Muchun Song wrote:
>>>>> VMEMMAP_POPULATE_DAX currently distinguishes DAX vmemmap population in two
>>>>> places: it keeps allocations on the normal path and takes a reference when
>>>>> a backing page is supplied for reuse.
>>>>> After Device DAX switched to the common per-zone shared tail page, both
>>>>> conditions can be determined locally. DAX supplies ptpfn for every shared
>>>>> tail mapping and requests an allocation only for compound head mappings,
>>>>> whose PFNs are not optimizable. Therefore, vmemmap_optimizable_pfn() alone
>>>>> selects the correct allocation path.
>>>>> When ptpfn is supplied, the caller is reusing an existing backing page.
>>>>> Once the slab allocator is available, take a reference for each reused
>>>>
>>>> Does the availability of slab mean the buddy allocator is already being
>>>> used? Could there be a window where the buddy allocator is functional
>>>> but slab hasn't become available yet?
>>> Yes, because the slab allocator is based on buddy allocator. But I want to know
>>> what's your concern here?
>>
>> The goal here is to check if the buddy allocator is ready, but the code
>> actually checks for slab.
>>
>> I'm concerned there could be a gap between these two:
>>
>> buddy is ready <-- gap --> slab is ready
> 
> There is no vmemmap population during the gap. We don't need to concern the gap.

Okay, perhaps we could add more explanation in the commit message.

With this, LGTM, so:

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

> 
> Thanks.
> 
>>
>> Thanks,
>> Qi
>>
>>
> 


