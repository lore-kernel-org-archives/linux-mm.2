Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F9FC606A335
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 11:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fjZWf2HJ
Received: by kanga.kvack.org (Postfix)
	id 515FE6B00EF; Mon,  9 Nov 2026 06:53:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6FA6B05B0; Mon,  9 Nov 2026 06:53:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DCFC6B05B1; Mon,  9 Nov 2026 06:53:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D40F6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:53:03 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3E5A16064E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:53:02 +0000 (UTC)
X-FDA: 85415419404.02.1705566
Received: from mta1.migadu.com (out-233.mta1.migadu.com [95.215.58.233])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4ECC940006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:53:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fjZWf2HJ;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.233 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794225180;
	b=zig9S9ubfDlFO6K3EnQ2gqfxXXeoX6ABKvxv9ZUAWfLs1KqpakQWIdEG19ANcw7NTh0Epi
	I9Aq9xGRM9KNtX7VH/cfWgKWe5aXq0/TxSnuwojwxepAzMzO5WKVAxa/p1o+JK7HnrqAm8
	mp/3zdL1s12+hwJZEbp/rPHgLHpclns=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fjZWf2HJ;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.233 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794225180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NUMBjE4wBB/Q8mO02dBvrjk9d7DRztoNKoxB4KrfGU=;
	b=BrhO8TCp1sb91sEcAfTlaAYPE4GXjXUZ3WnAOfpCZPy1svOO8LMvVRqjJZgEGtyLEiGyIK
	7e9ds2q9EK9NKVdBTIHx1QsZ9gooC8dod/oAcS+LK9xYjdJSsxg2C7DPpsR1gB5tanabAb
	PoSHZpR45qpGCUfZwvCrqIWB8zA248E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NR/9+ds+0qbFQbbZWnYyK+Ful0AYe2acx+nJjLHN/lE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794225178; v=1; x=1794829978;
 b=fjZWf2HJD7A86dlOOGKc7YTE2TJXjn7KAT4Dlcw0GrCnYfmegMGlBh2rFWmbVlYwGROKfxG3
 c5oE6/S8UqkfbMR+L+hmdv8asxYwD/6KcJiuY2sKb4pm3TnONt6L/IIiXZfl0FPLqeGpbJJBRjY
 aFHHOznKvzoEosZpqn3Rg94g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 47f3f8f417342a33;
	Mon, 09 Nov 2026 11:52:58 +0000
X-Mizu-Trace-ID: 47f3f8f417342a33
X-Migadu-Flow: FLOW_OUT
Message-ID: <7975c299-dcd3-4aee-8bcb-f3c0e8b8ce7a@linux.dev>
Date: Mon, 9 Nov 2026 19:52:42 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: Tear down the direct map when memory hot add
 fails
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Chris Down <chris@chrisdown.name>, Dave Hansen
 <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <au_l5MRyDbYfsUVe@chrisdown.name>
 <4bfb6533-1e77-4150-9626-437678b1785d@kernel.org>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <4bfb6533-1e77-4150-9626-437678b1785d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4ECC940006
X-Stat-Signature: b7zma91cxoa179yoz99kfk1mzaq6ey7y
X-Rspam-User: 
X-HE-Tag: 1794225180-574487
X-HE-Meta: U2FsdGVkX1+SBRmFP4gTil2EMfhxxcxpDSsOq481ennYRTe2WhV8H2ZmSxKUPrEhLngoVVeGhbCUY9FtWwK2ClHOizE4frshtYSp5lZt2swoZl21eRFHlQti4W8uXUsDxZuiX+1sbXZ1f5w0ThR5mXFtk0l7zyuVuI44DRHfq+A0y7kd75QSRQfX7RZuAWBNXJcvqgQhneVN7uI6szcLaJDXJ67ua0NxQdEw18sM/uuPVsbyLm+5X/ZG1JNCJ4GP1aXIGbA+B8mASIUENDCcHabybY8fwWOi0gpTVGsyw2cejWW0K4oMFjPgjMaAnk63qDw1Q3Hyh38TfBmo4XVqWJbXlYL6SeHVxvl/VE7zcLafGHsoVfa4dS6oUC08F8KULFqrNq/+ZsRef1owsQ/GWG80rJSpk5YIQ37S78c2efX2L8YWig+P/JVv8ST735MQkEvDjDwJnZ9W5RaN9kwI6cUcDNaQb5TLtkNW0H9ghK4kJYHqRdgcOjgjENw7IPDVr/9bjIKkJq/E+idh+xSg4QWuY9cCM6fwwYQBCH6ZtTVt+jGmxkhi+cTd2oXZyFY5zPhjFgxaEYzF9iuzU6zu7d2B7v1r3w9t9VEyUwB1P0inMaxfebKXNEgrpAHRGUZgtkXXalUNU8bW1viWKyMzCODuaarHPui+hEkOZhhnfCqs+wlsXIqK6mMkecViaihkPsgwDUAokMKJ+RVVa0wHNvtcdesyHFZ6IAtVb6IodSsp6fFceOcQsvpHbd8DASWjr/Wz1NHPE/qllklo9IclsBtugfspz/K7SdKoH3Krst54cy2zWHroUK2Iv7KTDQAt1UOG7RgSJc0egfFHUO00uu8sNzQq696Nm/ZPE1uqoZZ7Uh7jtaN130yzRIMVY/Z5JdlfCifIpqxxodrB04LvLGtX0Pi3OikqZ+eJaiOIDY4SiSM70+g/prZI0xlvjyE/AaCiVLIFoWEvOclqfQ7
 8atubs0m
 SL+iJqFCjS8GC1KzlNqfM36SrWcWb1Wd5fgsqSonm1GC6NFaZGPISRYDzAElgxQPuX0hAq5pKncnzWbpgRfYj1wV7E2CjQ04Via9odH8bJ4W09DVaX5totlS7YlfO7EV0QJ3kpOoXjsf4PMxIzn91grYs47xZVQkvpTyr052Ln2cv4ZY+nTeT9rKxXGJOhPlMtglpzumh5AM5Q8WRDL0mMG6AXqyiW7PIfDlwl5U/9kqJDXGUO6qNLE2M9VbIQsCda+hG2QmpFYe3zwuubpZFUB6KJVF9z3crkZn+ldnJ8D7vs/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/9 17:34, David Hildenbrand (Arm) wrote:
> On 11/8/26 04:00, Chris Down wrote:
>> arch_add_memory() sets up the direct map before calling add_pages().
>> If add_pages() fails, the range stays mapped and any page tables
>> allocated for it are leaked. A later hot add can reuse the stale
>> mapping.
>>
>> Remove the direct mapping on failure.
>>
>> Fixes: 45e0b78b0532 ("[PATCH] hot-add-mem x86_64: use CONFIG_MEMORY_HOTPLUG_RESERVE")
>> Signed-off-by: Chris Down <chris@chrisdown.name>
>> ---
>>   arch/x86/mm/init_64.c | 10 +++++++++-
>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>> index 8b6d86fb5a42..846cb34b38dd 100644
>> --- a/arch/x86/mm/init_64.c
>> +++ b/arch/x86/mm/init_64.c
>> @@ -989,15 +989,23 @@ int add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
>>   	return ret;
>>   }
>>   
>> +static void __meminit kernel_physical_mapping_remove(unsigned long start,
>> +						     unsigned long end);
>> +
>>   int arch_add_memory(int nid, u64 start, u64 size,
>>   		    struct mhp_params *params)
>>   {
>>   	unsigned long start_pfn = start >> PAGE_SHIFT;
>>   	unsigned long nr_pages = size >> PAGE_SHIFT;
>> +	int ret;
>>   
>>   	init_memory_mapping(start, start + size, params->pgprot);
>>   
>> -	return add_pages(nid, start_pfn, nr_pages, params);
>> +	ret = add_pages(nid, start_pfn, nr_pages, params);
>> +	if (ret)
>> +		kernel_physical_mapping_remove(start, start + size);
>> +
>> +	return ret;
>>   }
>>   
>>   static void __meminit free_pagetable(struct page *page)
>>
>> base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd
> 
> I thought we fixed that already, but I remembered
> 
> https://lore.kernel.org/all/20260930160432.5564-1-lance.yang@linux.dev/

Ouch ... I missed the direct map cleanup in that fix ...

Reviewed-by: Lance Yang <lance.yang@linux.dev>

