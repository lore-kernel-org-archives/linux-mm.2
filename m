Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E03AC9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 13:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62CA46B0088; Fri, 25 Sep 2026 09:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 604206B0092; Fri, 25 Sep 2026 09:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 541606B0093; Fri, 25 Sep 2026 09:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 359196B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:28:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA74D160672
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:28:25 +0000 (UTC)
X-FDA: 85252363770.06.F06D75B
Received: from mta1.migadu.com (out-97.mta1.migadu.com [95.215.58.97])
	by imf28.hostedemail.com (Postfix) with ESMTP id 96506C0006
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:28:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HmVTdxry;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.97 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790342904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0TNRaYRZjxEWnZgBUsH8QNN5OVfzQ+p6s2AcLUJON0=;
	b=0HtGXM9DVCT4hGJUK5XEMZvO6u89Oa8fS987wJEpaehx2p9LO3rIuK2qoArBD8oYfjm7NL
	f7QZBlgn0VN35Yqt9Y7yc3rZVB+VqPAxr14P+ejon/BzCzwCbtAKbq0lQimVWK0e010Jzc
	Y0puODq45z8q86MzghL3VLLO5eKIJA4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HmVTdxry;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.97 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790342904;
	b=U7OUGGGei6+QKFyrRr41l+hTqehcdcsiv6VXJsAwMVuvIYKwpxtrfnx//H8tansiqIFmkd
	r93wXv8qu8bQbNWewCyuPsGFq0aF6lbIo0FsuGhlhpAHO1oPycH4JVF03LejdF65f8JWsU
	3Y41Yqs3b/PNbhjK4qa7fqeQiIhZPNs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KBJNJZ99wqa5tNb5ZwQjjrE8HikWsGszb2RQSZ1VdK0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790342902; v=1; x=1790947702;
 b=HmVTdxryUavcKgddH3EhuweynIhT/yU1A8AQNhdrcdakjXxUPXdoRy5ujE/EzzZYK49pE2jl
 JYUHgxAXSefqSgRVAKfjGPG9fl3t84OMnVW1A4vW7e/keFsB4icYYlI0cSUI3EhcANGkUoW1sB5
 /uYoDoW2HE8aoMWDjzFPz0Qg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bbd36d2360a9889a;
	Fri, 25 Sep 2026 13:28:21 +0000
X-Mizu-Trace-ID: bbd36d2360a9889a
X-Migadu-Flow: FLOW_OUT
Message-ID: <856c4436-8328-4561-a399-2df292c08b35@linux.dev>
Date: Fri, 25 Sep 2026 14:28:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 15/29] fs/proc: account PMD swap entries in smaps
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-16-usama.arif@linux.dev>
 <e375b500-be0c-4ad2-b59c-ce1d4d58bb10@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <e375b500-be0c-4ad2-b59c-ce1d4d58bb10@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: shyzke5hoygkcaaigqkfycxd3xc3s4pk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 96506C0006
X-HE-Tag: 1790342903-994081
X-HE-Meta: U2FsdGVkX19HZgr9kbV5QZO9oyk5EJKYkt0upD46q0hl5tW9dDg/9iWw7lYy1hOtck0yZ7K7fUaXGxESRjBm7D0ZvipOF/fsmIkNliXl1qPiVZbWZSdFxb1LzpBV0PEvp+/p0gf6uQTNNE9dtzyo3bl0Uzc7Tc7EZOt6UwLtJ0D83/R1K+kqVPGJhhQXCshZGb23CHlXzUZaalmPuo3GHstX4TLlCNmD6m5t4Gu8M6IRvqFqc0x1rWAan0ke8+I5BZuGldMUvMunL8USyjb6zE+v+LV8ELo0jgQ7VbIs6lI2tRdT3SguCguk3U+hm3SA7DNnpz0cJjGYbSWZoVvrT4ZKwR9ue8Nf3wz8oBv1h24BOHIzTDVEKJbDwqIluy5IBYFQWr1x3kb1VqvuE/U1AXGvoH3zqVIgFonxdsjkAUIBLAp30hHWARwcJW5jv0Rfkjl6mgdqyMCDo5JG85eQodaCHdFOj0qSCw5A/CQ+isZW3NfnQ4ZoBZ6UIrhfkKfpec+vM3TQ+vw09ikh+JpcTXHD0s7/FezNhmXtXzb5JKeJWWixcHd0Ko7eP/wB9Gyg+df0IYtIvBxWwWKTjCx6Zps+x8M0q2r3pan4vO21eTrQgYeREtSsuV6TNNAVoGOWAu6QiJkQ/KwiJgh5IpL3RRWbSVmuGR3Pu18hEIkWWYLYdtopT/IJXjJ4yrFoabgwhTmMAYnNlzMxwVax7sPVKanfDBGaaaYBlUrVRP6lviptXMQz3gjrtspH2/qSxYyVfB+vfbx/YXEzl7H2RVTTY2/0pyPCtYO7UsapTGVS4+nPukCFHrhvXU7mVVy6MjbpvO5Yhi+tDRlSOooKM8jLh62FNzcRvOIIMQHIFOSyDitnuUDN5zOwR8YKFqc5qvCH1mhJNBArmf8PXyLWn36LYUrUMhMdLCbK/B7IlDNGqlgdGgu+zzburA0uTCvJLxVTLXisgOXj0ItdAMZE2ny
 3YbdAr70
 EsG3MISnaJ36YsrXZJkm19Mm7E9OuiP3rfMdp9V+/KOwAS6128zKl0oecksI6j+Hk9Fi8Qv0CO71j1LfeeEIQnNVb7E+xpHWEZ8h/1saW5meoyzSgd7eQSbTMBhiy9otwWLRR62J0ffioJHvOwDsdLWsoqyixxzeUEw0SXus4rd0oniulTAzgqQccXsE7IAEvUk+YK86s5oqsEc9mxAK5tkzeXm6C2o2dfB7lzwUJ6B4ufjFdd7HSNZErYNhik0aiI8v3QPlSZoHsUPpAx1J1ziiVOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/09/2026 21:37, David Hildenbrand (Arm) wrote:
> On 9/14/26 14:28, Usama Arif wrote:
>> smaps_pmd_entry() derives a page from a non-present PMD and gives up if it
>> cannot. A PMD swap entry carries no PFN, so a swapped-out THP is accounted
>> nowhere: its bytes show up in neither Swap nor SwapPss, and VmSwap silently
>> loses them.
>>
>> The slots of a PMD swap entry can have different swap reference counts, so
>> SwapPss has to be computed one slot at a time rather than divided once.
>> Factor that loop out of smaps_pte_entry() and call it from both levels,
>> then return early: a swapped-out THP is not resident and must not be added
>> to AnonHugePages or Rss.
>>
>> pagemap needs no equivalent change - it already emits PM_SWAP and
>> type | offset+idx for a PFN-less softleaf entry - but its
>> thp_migration_supported() gate answers a different question than the decode
>> requires, so use pmd_is_valid_softleaf() there instead.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  fs/proc/task_mmu.c | 42 ++++++++++++++++++++++++++++--------------
>>  1 file changed, 28 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>> index 24425e2308951..aa3f4d54a8580 100644
>> --- a/fs/proc/task_mmu.c
>> +++ b/fs/proc/task_mmu.c
>> @@ -957,6 +957,27 @@ static void smaps_pte_hole_lookup(unsigned long addr, struct mm_walk *walk)
>>  #endif
>>  }
>>  
>> +static void smaps_account_swap(struct mem_size_stats *mss,
>> +			       softleaf_t entry, unsigned long size)
> 
> Wouldn't consuming nr_pages be more consistent with other functions that consume
> swap entry ranges?

Yes, done. mss->swap += nr_pages << PAGE_SHIFT; below in the next revision now.


> 
>> +{
>> +	unsigned long nr_pages = size >> PAGE_SHIFT;
>> +
>> +	mss->swap += size;
>> +	do {
>> +		int mapcount = swp_swapcount(entry);
> 
> While at it, can you please call that swapcount?

Done.

> 
>> +
>> +		if (mapcount >= 2) {
>> +			u64 pss_delta = (u64)PAGE_SIZE << PSS_SHIFT;
>> +
>> +			do_div(pss_delta, mapcount);
>> +			mss->swap_pss += pss_delta;
>> +		} else {
>> +			mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
>> +		}
>> +		entry.val++;
>> +	} while (--nr_pages);
>> +}
> 
> 
> [...]
> 
>> @@ -2000,7 +2014,7 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
>>  			flags |= PM_UFFD_WP;
>>  		if (pm->show_pfn)
>>  			frame = pmd_pfn(pmd) + idx;
>> -	} else if (thp_migration_supported()) {
>> +	} else if (pmd_is_valid_softleaf(pmd)) {
>>  		const softleaf_t entry = softleaf_from_pmd(pmd);
>>  		unsigned long offset;
>>  
> 
> Interesting, the function already seems to do what we want. Weird that we
> indicate PM_SWAP for migration entries ...


> 
> Also, are device_private PMD's handled correctly? *doubt*
> 
> [maybe there were patches, not sure]
> 

Not in smaps.  smaps_account() documents device-private
as fake-present and smaps_pte_entry() does it, but smaps_pmd_entry()
never did, so a PMD-mapped device-private folio got PSS charged
undivided and landed in shared_* even when mapped exactly once.
I have folded the fix for the next revision

