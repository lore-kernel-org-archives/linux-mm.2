Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F15BFF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 09:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7C256B0005; Mon, 27 Apr 2026 05:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52776B0088; Mon, 27 Apr 2026 05:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B68676B008A; Mon, 27 Apr 2026 05:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A42956B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:28:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D3E9407A6
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:28:26 +0000 (UTC)
X-FDA: 84703810212.29.51E1FEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 791C54000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:28:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k9ko+X8h;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777282104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/DtDYJQ3ePyj2e3KjlEhrPTuEBKdiWp28PGLq9lD0g=;
	b=fMDiILZawnwN4XoYrEsGs304GbRzGzh/AYjOLUNJ2z5X+wJ4Su53Y8QPpuey0dwZPXjC1i
	ljenhszRUtCsIkdv6cs8HzktY7alLWOOz1mlZqcTDkDxM3RGdd5Qj6PbsRmMQeRSZKbRII
	OxNXUftwyDyOZmgT8aFk76qvAavIj78=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777282104; a=rsa-sha256;
	cv=none;
	b=R7WePrJMxbVWHZ6nRhvtTTATwre+io7Ooyrn7g4aGcms68sk6sjr6SVpJtJ8zGCx5KaK2Y
	ehYEzPDSNNvh7OFL+xNMX7VsPyVCJrJax9QvRZkpiT1UJlhDRJqJTz/1TMzEAVhDNtqoKZ
	A/JKHrOOYykga/z93vt7cjIKInBcGL8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k9ko+X8h;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8267340851;
	Mon, 27 Apr 2026 09:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAD3C2BCB6;
	Mon, 27 Apr 2026 09:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777282103;
	bh=38Eg7fzUhEHcKQxPhK//RD3lF1LtVHnHiWyYCaGxWi4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k9ko+X8hteZitT+P7Xd5MkF0CK4/Y98A6IupxRxKrxOYCU4MpLdgdWvbxewgoyW/R
	 1k09eUdB4tsx0fShHBjfIs+iLz/gFBgGAwso7o6XmdmGHpIMFNphG9JkDCr5LwiRlR
	 hlZ2xuODo6d6T7TWh2xv1/ibvaJNSp0QzzZgp+CLhK7kD2flIQs8qXkdsB5gfhWJMw
	 qJYH9lIhhvyMBqTeM71FRS9WBKGg4dam4/jbk+Y6UVYkbZhg6btTPaX+zgQ8zeTEBS
	 DoHd8WdD6h6ijsbaFKBMFAFIN1DlHULxvWR+h27dR/yRKW7tylMEKmgOQPuh1/MoNW
	 0BriLFhOJAv1g==
Message-ID: <572dc427-9598-4982-a015-d19904996dab@kernel.org>
Date: Mon, 27 Apr 2026 11:28:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] drivers/base/memory: fix memory block reference leak
 in poison accounting
To: Muchun Song <muchun.song@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Ying Huang <huang.ying.caritas@gmail.com>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>
References: <20260426144447.817722-1-songmuchun@bytedance.com>
 <20260426144447.817722-2-songmuchun@bytedance.com>
 <7fe73023-1fd1-0c10-107e-5c0f47383453@huawei.com>
 <D07C436E-E6BF-4E6D-9431-48C496E350CE@linux.dev>
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
In-Reply-To: <D07C436E-E6BF-4E6D-9431-48C496E350CE@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 791C54000D
X-Stat-Signature: n8x71nbzk4ywrwwhhc3steo9ith6ajj1
X-Rspam-User: 
X-HE-Tag: 1777282104-291715
X-HE-Meta: U2FsdGVkX19qIwa2X/Zbg9iveZPZ1l/VOPUY7j5brm+qrxlEiLc/Ep3T4vxIplvBOcV1D1eFzczwCoQZaoTd+S9m7kifVgb1rykg6//ota9UTEM5OH8V9uKo4H6tOZOxNZXtRTcj/i5A8orHlz2nBcvTUPRMoy1FrY/Mq7o3A/n24O0wiOGpk0y8PaVdz1phP/5Yzv3leORHsn44YEqKHFb1jkSCISRBCpmekHQ4tl4WwF0jUl95fnM21/ZY2o7x8w1U2HrUAyb/r6eMItX9rfOsZy2Fcs7NBidYmEla2AGqDMR7RxJAbELqMJ3qFXm0o0PSeVbClgTEmO/659/QQbQd73eEkVXvHyTwjgR4fb82aUl0t9w6I2RzSg1mv5U2E5KEP9fvQcpXbrFpiq5jV8vH0or9O0Dmqh6Mv9nIq2SbBObT90sqp/YELKzceiRijubgqTzurLARS/s1AY0E0h1Wv9MapIR+OJGxPlZIYTKdFziB3PQ4c9scaIZ5kxNeEbIzTiKzZY7dd+TFcPlAchO9EBQlG6w6kW+sIjl/bWsk8mwyNDvxP8vIVAnN+FPsN7guGFAo+BQQPxhjgPdWbisj4dZooqY7Vt3Xm8WX+W+XRpNmIEb+GiCdreoq+2qoBZ6ne/qZBQLldM89l13wK1WnPIWngt1kxKl0wRhDH9P0aBtDwt0iflHqagYUHltIj2QBZBVKciPB48EW5QKNSpBLNSAF8ZOrRcNnIXLJCzlo1CTrUK6jU83KiY63ZhTzQvkiBQgf+tjaEiWUSfDTfnFcqO94Ml4m30Nzc04bjTJv2d7F2ewC4O7KGDWvNyzo66VsArMfVRZE1qsKjrB8DtRsQ0tPDQcyOiGliTQQHq6XnCk8Ne+mp2UJqhOSa4MibPggS5w6ORMReRrXsRrVfPZFucJfCLSe6yL3+QK0HNPtocZsmlmGbXxTDkN1IrcGpNq/p26OmuayXhy8Agt
 BwwIp4JK
 vMBKvEoBIBiQokVVOlZsZTYlGENZLUL7zzDFq6sbEGLNAEKxx9V49HfA/3PV6R+QbbBLxnpYoReKsJ978etkRSoRf9OZWcfY+A3Z3RaD7+AMspIE0WkCBTPU/kIl+yVHoy7Ejnr0j/FY9TLjiP5uoRIuNAddVRLZ/f6mbupWxgd7qspXDbruwc2BXncHW9/ECHEOCE9TVvTaTVwhA+oG81jQEmh1xyCq29J7AlSEUUjLyOXNBqKffmeJeREBUnon9bfv4C1PRM7gu7asX6xihKgabztvwLCexUJzooEOS2T3bOvH1rm79JGfnTOBXT3ioHpT2Q66wZa1Z0EOqRZ+tZ97LYs7MImjA+3uhjfPhf9aBoIMftO4U1ywJbhdx8kgg1KG2s288vRJumt6OsqhAUhLERQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 11:16, Muchun Song wrote:
> 
> 
>> On Apr 27, 2026, at 17:13, Miaohe Lin <linmiaohe@huawei.com> wrote:
>>
>> On 2026/4/26 22:44, Muchun Song wrote:
>>> memblk_nr_poison_inc() and memblk_nr_poison_sub() look up a memory
>>> block via find_memory_block_by_id(), which acquires a reference to the
>>> memory block device.
>>>
>>> Both helpers use the returned memory block without dropping that
>>> reference, leaking the device reference on each successful lookup. Drop
>>> the reference after updating nr_hwpoison.
>>>
>>> Fixes: 5033091de814 ("mm/hwpoison: introduce per-memory_block hwpoison counter")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>
>> This patch looks good to me with one question below:
>>
>> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
> 
> Thanks.
> 
>>
>>> ---
>>> drivers/base/memory.c | 8 ++++++--
>>> 1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
>>> index f806a683b767..6981b55d582a 100644
>>> --- a/drivers/base/memory.c
>>> +++ b/drivers/base/memory.c
>>> @@ -1230,8 +1230,10 @@ void memblk_nr_poison_inc(unsigned long pfn)
>>> const unsigned long block_id = pfn_to_block_id(pfn);
>>> struct memory_block *mem = find_memory_block_by_id(block_id);
>>>
>>> - 	if (mem)
>>> + 	if (mem) {
>>> 		atomic_long_inc(&mem->nr_hwpoison);
>>> + 		put_device(&mem->dev);
>>
>> Comment above find_memory_block_by_id says it's called under device_hotplug_lock.
>>
>> /*
>> * A reference for the returned memory block device is acquired.
>> *
>> * Called under device_hotplug_lock.
>> */
>> struct memory_block *find_memory_block_by_id(unsigned long block_id)
>>
>> But device_hotplug_lock is missing here. Should we add it?
> 
> Yes. Otherwise mem can be freed concurrently.

I guess that is rather unlikely to happen, given that we just worked on online
memory. But sure, if we can take that lock there easily, then let's do that.

-- 
Cheers,

David

