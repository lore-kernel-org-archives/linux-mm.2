Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0CF7EC01DF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 12:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35E7B6B0005; Mon, 23 Mar 2026 08:20:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 335C36B0088; Mon, 23 Mar 2026 08:20:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24BCD6B0089; Mon, 23 Mar 2026 08:20:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16F106B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:20:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF327140B9C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:20:20 +0000 (UTC)
X-FDA: 84577235400.06.0D5A23B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id DC071A000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:20:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mBxJJpc0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774268419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjPLtkj50zlbcLoq901AUzECqyNBm1ae81BWSi6q7H4=;
	b=jj81ouUe5s6s2bk+VRud4i8Bp+rD9kk469+jbPqbeY3e/yfTrRpsvFWnb3/kK5q5Vke9Lv
	pRTPLYKXQPolmmTXkFst/q//6F4ZSL4IEDnrALP/BgOKxZ91Vr9rsrMzPO0G3sRVFeMgGE
	Mw5ii8Dq/ruxzAA0NoT7altvcrRNjgE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774268419; a=rsa-sha256;
	cv=none;
	b=HIlbWtkCfcN3wADG7V9jsQNz10hs8WmysGKaOevMD0C9AUEk3LEYWW2CCZvNGdUvGrfnVD
	OzfQ1L6MwNA5bOC1rfIXXgVbkUCfFELSeMV1LJq6e2B6LUmQBB4NUtHf0JD6c5v3RYHT69
	0OOu0pF6kx7cOgtRgmJW7mzO7NpA5G4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mBxJJpc0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B8C5643C43;
	Mon, 23 Mar 2026 12:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFAFC2BCB1;
	Mon, 23 Mar 2026 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774268417;
	bh=q907mWmretck/dkDWY6czsLRkWpdZxdxZ34zLFmLAo4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mBxJJpc0a/J/qXlh4wWG3qDWE4ieZbnSHK+x9tW8qtkWjOssiwWJ1tVKEaohonphl
	 lUqG7s0u0H/KQQ7W0QoEMIiYFR0CLUrbIYz/SzS2YGiASQvW55Gi+p59TyCM1V13h8
	 14JsNDOW2uejTxYxVX0MNhn1s44gU6rzn7LMylITcHvdXdPDl7IOwAzcnTbPpHgqjF
	 +LA6wvaSpkuik4y3XSNPIbQPZdc1Kbdtum9w5HMihvlnT1ppt5GDA89L10T+aPWBOm
	 E+rO5UO5l8FCBrdjHSl8cCiejQw/I0Ai247DRAG3r6xckRxmvBjEqBUVUWwIUvlBNf
	 YY5vAiqWgJWWw==
Message-ID: <ad000c66-aeab-43cb-ad0e-69dc57f327da@kernel.org>
Date: Mon, 23 Mar 2026 13:20:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 2/6] mm/migrate: skip data copy for already-copied
 folios
To: "Garg, Shivank" <shivankg@amd.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 willy@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, dave@stgolabs.net,
 Jonathan.Cameron@huawei.com, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, weixugc@google.com,
 dan.j.williams@intel.com, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260309120725.308854-3-shivankg@amd.com>
 <20260309120725.308854-8-shivankg@amd.com>
 <4bfec2c1-9747-49d2-a490-87ab204cec1c@kernel.org>
 <99d3a0be-d33e-47c8-88b4-3f0e21f4a1cf@amd.com>
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
In-Reply-To: <99d3a0be-d33e-47c8-88b4-3f0e21f4a1cf@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DC071A000B
X-Stat-Signature: 5sax18zo1oe59nrggpexd9o7nc5bybu8
X-Rspam-User: 
X-HE-Tag: 1774268418-938959
X-HE-Meta: U2FsdGVkX192AF01C8OCwbcvddYa4USijvRLdAL4HxFy5P7W4aiMa+u250NaJSCfaDijB7FM/lgMpmW0UKpCua8ACMskg1H70TdB8WGG9hohzvJl/IVWZy4QBUrz3mZXhRl7pjrTvVGSDQQEg5DlcwQ8um+yw5yDIeASZ8GeBaVnzfpHRFZW0QOKinVI6VOgnG6YdeQI+da33+aAecFRcaddsQJqWRqvL3JglX6oAkNzwBhRHK5AS0Sf4s7ufYEBfl5qlC/BbTiwYddzFSx4RsQOE9ESxD6YyVVExaQCBGKB2zzHY+bCy1hE76O31yhxpNnLRfp5iqty1RUUcC7QbX+sVgQuqI2fUZfYffgTZHyo8/gog/zlZQOlZOumbwezgGd3Hsfr0zOo8M/FkDATrjEK7jgsyO8ouSvzc8ZZ8oD3VnuUuJg7yxjOwO3WmmgsKJfzWt3c34DN2HwB/kLZl8HHb12Djjz0MF+Ti7EyD1ZfK3xlQRAKDUek4dMgT41RTd95qwM+zI/bgaBeVBWO9q9UT3FM1L4UJ4l6CpteUZGT3ndZffia6A+mHC6+jmco6Ng5Tx+OqWv0Ay09ddcVLjaF/LclR0kduu5h+Rhub+g67TyBwh1pGF1Gjq6RBILRHLYanw61rm4CRh2j/8NiSnfr9xoe/q+es1o+q9paEUipo+86Ezdo5Fyp6wimevNvUeX99cv0+olnRCwMc1UI3Xf0zmduA1LMbA2k8/un0Y3LlDCY4HkruPTgrr2a5FUSXdVYuOBJ2W11+8ZnwefkNb9Zw3316cbMsUJErTG6LU7AJk/rVMG6xiQXOF8LWZkjYMPDPYbtVALowWoXCtAh4ueONPC9nIm0d3vW3uoRIU4yzVs9ZLRNLj/TYSOyE3KcKTm8WHGkRNqcsF17ki/d2A1RVxOfH4Xqa+7/mjjNH9B5BSPmhymIqM4AA8PSWBZOeIEJlgNJH4fRCF+QnYG
 hsCOWifJ
 AcXUCL1+bpJ7DdxxPAfEBzBSSCF+9I/1p5y81HFFlEmzwscGwaPN1VFwwGRaTBUfCc/1+r4ukgHPOdqnCQiaQ2RU0gk/9PqzbqVEOddIL+OiiJYC3RMxABRzCYDOswq5nM5tAV35T5vpQfc1hMsW3LqhRShlmKuKJdQjTNMnrLMyb4GLxQRYzDT2p3rBA0UTgADt3QWLZjSsUwHlowm6xj3WVn39TI8VbQkdPHnGD2gq7nDsY3XH5uVGFUAvfLlaA1pvBn/O+orgSO5pxXUfYw7LqgBqZ4dGTF6PZbUVN9ayNRG2Cv+xURzPksuoB+ZDM76ql93WEIe2Hz0YStPo475VE374hr6F1apcC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/15/26 19:25, Garg, Shivank wrote:
> 
> 
> On 3/12/2026 3:14 PM, David Hildenbrand (Arm) wrote:
>> On 3/9/26 13:07, Shivank Garg wrote:
>>> Add a PAGE_ALREADY_COPIED flag to the dst->private migration state.
>>> When set, __migrate_folio() skips folio_mc_copy() and performs
>>> metadata-only migration. All callers currently pass
>>> already_copied=false. The batch-copy path enables it in a later patch.
>>>
>>> Move the dst->private state enum earlier in the file so
>>> __migrate_folio() and move_to_new_folio() can see PAGE_ALREADY_COPIED.
>>>
>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>> ---
>>>  mm/migrate.c | 52 +++++++++++++++++++++++++++++++---------------------
>>>  1 file changed, 31 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index 1bf2cf8c44dd..1d8c1fb627c9 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -848,6 +848,18 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>>>  }
>>>  EXPORT_SYMBOL(folio_migrate_flags);
>>>  
>>> +/*
>>> + * To record some information during migration, we use unused private
>>> + * field of struct folio of the newly allocated destination folio.
>>> + * This is safe because nobody is using it except us.
>>> + */
>>> +enum {
>>> +	PAGE_WAS_MAPPED = BIT(0),
>>> +	PAGE_WAS_MLOCKED = BIT(1),
>>> +	PAGE_ALREADY_COPIED = BIT(2),
>>> +	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED | PAGE_ALREADY_COPIED,
>>
>> All these states really only apply to proper folios (not movable_ops).
>> So once we complete decoupling movable_ops migration from folio
>> migration, these flags would only appear in the folio migration part.
>>
>> Can we convert them first to state it clearly already that these are
>> folio migration flags?
>>
>> FOLIO_MF_WAS_MAPPED
>>
>> ...
>>
> Sure, done.
> 
> Should I fold it into the series? Or send it as independent patch as this series would
> likely take few more rounds of reviews and discussion.

Best to send it out as a standalone cleanup :)

-- 
Cheers,

David

