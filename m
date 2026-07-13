Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6524EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 02:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5353E6B0005; Sun, 12 Jul 2026 22:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6686B0088; Sun, 12 Jul 2026 22:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423686B008A; Sun, 12 Jul 2026 22:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19A436B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 22:41:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 936B11C951B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:41:25 +0000 (UTC)
X-FDA: 84982202130.11.4007F1F
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 21CF7100005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:41:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FryoO8/F";
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783910484;
	b=u3/tKZ/oOoRVNa2azIlkeSKRSYYrR+SWL0jkZxgrQW5SwWfS5/uyefEWCbpoMimYIIu80z
	rVkdiZhy1EG4neLzP0RD4PnwDwL/B95KjjgOSxmnoaY8rosYsV26vh19mYgeV+3Ecz2kV8
	fDlUoKRbOfEMclYHQTY8WZ7613aFDw8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FryoO8/F";
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783910484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2B/xG+qu8furtxmJkYMRRCvbVRz6ayW5kKLZ2HvMBhQ=;
	b=BvKL6zeA+B/HRr1buQ9Y4DC5vZfjKguUvNcscZI92F9Rn3DCW5E0O8lWoiLIJkmwycukI9
	fP74vfgpeBVgDpgFg0l7IFFTTFIB8UtNTRZt+XWckc1l0Q0IfK62t/VbnAp+kK8hBW+/Ca
	Fnq8C6wzrqdQMHyjRSHR/FZJ+AlXgro=
Message-ID: <4762af9c-e9ac-4162-a407-84d335325dac@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783910480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2B/xG+qu8furtxmJkYMRRCvbVRz6ayW5kKLZ2HvMBhQ=;
	b=FryoO8/F6TmYq7NE1embuxGnzVod2pqWmEsa1T0lBvGOnvphTZlNlvZLciBNwUd7hGS2zI
	/wtvuI7RZYd4dIViTGLaizNgfrmQtQCPTe2kOadIymXh0LQBIv2EUzRby8CQA6QoBLlpCx
	x4B4xedJDrW/BcH4esObwep8iMEEyec=
Date: Mon, 13 Jul 2026 10:40:52 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 9/9] mm/page_owner: use memcg_data snapshot instead of
 PageMemcgKmem() to avoid TOCTOU VM_BUG_ON
To: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260701061101.344679-1-ye.liu@linux.dev>
 <20260701061101.344679-10-ye.liu@linux.dev>
 <0E890CCC-818A-47DE-9D1C-9EEF98CC758D@nvidia.com>
 <4d8e0125-0630-4070-95cd-acec3d626329@linux.dev>
 <622D6E1C-6E27-4912-A1A8-E5110A4581BB@nvidia.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <622D6E1C-6E27-4912-A1A8-E5110A4581BB@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 21CF7100005
X-Stat-Signature: t3qegbdeq64onjosimta3kdbzzzjkh5x
X-HE-Tag: 1783910482-101007
X-HE-Meta: U2FsdGVkX1/bVOHtsl+XXWE6ogcWysPQonm0e+VgIraPCxxZFtsIV8jLQaCRWTKK6H1Lws/wGQqeBa5VnOKYb3x4DoiL1zX2fLlBb58Jo0WtNwF+PYzwNN0VYyqSr/a6cN/KYvERAuMPjURHPJoaVmPXS6xWeA3+WcQTSFjZwjVOOD56mlu0cplfrHhZYnxKf7sCEUXIDiZx/H5YuY0gG5CG6gCz4aXaTi6bxbXvUxKYk0jJUypDkH0brQVaNEHDNxndBCtZaG5zIAwBhiblJqgb0XISnOjiDdDc7x0DlAUTB1pOuOows6CRgnzuv8hije9JD1+1fGB2GppEKNhSa/FUX3inHkiYXDamGBgM0WGJPg5wVm0yHrR1kPCx5lL33mF9XhAYfj96qRzFIADiIoag1gzzDdV+jqXzj/Vh2jouc8WINqhQwB9n2lclwyynpwO2Ip8/D/p4WPXcfo1wUNuxkscDk6/okP9VYvv2WxCM7y4/jhcgwdBFvUKB2Hg245U1QTUPvZQSvNzVl+M2dLObEIhIHrkozQR4/DCioqjTpEHFYgx3HFccHH3aePfm17vQLSgHCeWkJXPYnz9FsntD/sOlMbYFM0LFPNgSzeLqaCPKQH0nInJp9lp36BlJHalBoNx27FYC5WkErkDT8bz4Q6zYPbOKA9BRsOnMsUPz4PpnXXC2FrlU4oveP4jNwdZlBQJLxM4jsBrks0wIiaL440NAAPR9m+PDbcEBCh+GY1izB/sCjj29PZ1GpnuxgfzuaBkUq6spNYvZeMP97TAYZgeUJdH3a2/yJGrKkSr95+SoocGbr0Mc4/iNocMM6aRuEQwT2byaLb2pKBvrSUUqUQr5wGUoiktjmmJOK6DAZUuUOMOk3SMeZJpwJ466z7Svbq3AEVacR6mq25IU/aeq0g+yLNoN29+sEi+OUSjCUGFVDmP6Xv/jJKEFszp9eSoWTVW2Zc3KWtqnpOX
 Nw2uz5OU
 JTplNU5INNhEqh5c7KWM5ye/W1cybDha1bmCpfOyU2BGchhZqBXgjf7BBgjDtqv1aZ1Gz2+7tv9x8VN1mi23REuJ7nrE3w5xfmdZsyaB8Bwkp1qCuEHGe4JynL5KSUIHvP36ZJR/VMe9c/fMZlz5oV/c5wKUVS20nho5JwF8ZoTGmuVXcEd+8YPLU9MmJU2FrG1VNlg7Wz5JbQjXSdYPz+qclZtXFRjZQ+eMMNkaFxCXZykhKrnliOsjsMx0PdxPXL1EI++IZcM8nsWIVskvyYcFv9e9GmDASm1O94OkLR7gaXSmDAtS4h6KC/NHqGiz0g2KRLVKdQuV38TyVSUQ2VxVwav6WfFhgvpUqFdGSAZdnKYs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/10 23:56, Zi Yan 写道:
> On 10 Jul 2026, at 2:51, Ye Liu wrote:
> 
>> 在 2026/7/2 10:02, Zi Yan 写道:
>>> On 1 Jul 2026, at 2:10, Ye Liu wrote:
>>>
>>>> print_page_owner_memcg() takes a snapshot of page->memcg_data via
>>>> READ_ONCE at the top of the function and guards against tail pages
>>>> and NULL memcg_data.  However, at the end it calls PageMemcgKmem(page)
>>>> which internally calls folio_memcg_kmem() — and that function re-reads
>>>> folio->memcg_data and page->compound_head locklessly, wrapping both
>>>> in VM_BUG_ON assertions:
>>>>
>>>>     VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
>>>>     VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);
>>>>
>>>> If the page is concurrently freed and reallocated as a THP tail page
>>>> or a slab page between the initial guards and this final call, the
>>>> VM_BUG_ON assertions can fire on debug builds (CONFIG_DEBUG_VM=y),
>>>> causing a kernel panic.
>>>>
>>>> Fix by reusing the memcg_data snapshot already taken at function entry
>>>> instead of calling PageMemcgKmem(), which is semantically equivalent:
>>>> PageMemcgKmem()->folio_memcg_kmem()->folio->memcg_data & MEMCG_DATA_KMEM.
>>>> This avoids both the TOCTOU window and the assertions entirely.
>>>>
>>>> Signed-off-by: Ye Liu <ye.liu@linux.dev>
>>>> ---
>>>>  mm/page_owner.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>> LGTM.
>>>
>>> Reviewed-by: Zi Yan <ziy@nvidia.com>Hi,Zi,Vlastimil
>>
>> This patch still has warnings (see sashiko link[1]).
>> I've made the following modifications, or do you have any better suggestions?
> 
> Maybe use snapshot_page() from mm/debug.c, so that you do not need to replicate
> the code from folio_memcg_check(). You probably still need the rcu_read_lock()
> when reading memcg_data from the snapshot to prevent memcg going away.
> 
But it does a full struct page + struct folio memcpy with retry loops,        
which is more than what we need here -- we only care about memcg_data.        
The READ_ONCE() snapshot is sufficient since the function already             
holds rcu_read_lock() to keep the memcg alive once resolved.                  
                                                                              
The two-line inline of folio_memcg_check() logic is minimal, and we need      
the OBJEXTS check to be explicit anyway (to print "Slab cache page\n"         
 -- page_memcg_check() just returns NULL silently for slab pages).            
                                                                              
Therefore, I don't recommend using snaps_page. Are there any better solutions?

>>
>> [1]:https://sashiko.dev/#/patchset/20260701061101.344679-1-ye.liu@linux.dev
>>
>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>> index 2e3880053a34..e18512a49e38 100644
>> --- a/mm/page_owner.c
>> +++ b/mm/page_owner.c
>> @@ -540,6 +540,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
>>                                          struct page *page)
>>  {
>>         unsigned long memcg_data;
>> +       struct obj_cgroup *objcg;
>>         struct mem_cgroup *memcg;
>>         bool online;
>>         char name[80];
>> @@ -549,11 +550,14 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
>>         if (!memcg_data || PageTail(page))
>>                 goto out_unlock;
>>
>> -       if (memcg_data & MEMCG_DATA_OBJEXTS)
>> +       if (memcg_data & MEMCG_DATA_OBJEXTS) {
>>                 ret += scnprintf(kbuf + ret, count - ret,
>>                                 "Slab cache page\n");
>> +               goto out_unlock;
>> +       }
>>
>> -       memcg = page_memcg_check(page);
>> +       objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
>> +       memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
>>         if (!memcg)
>>                 goto out_unlock;
>>
>> @@ -561,7 +565,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
>>         cgroup_name(memcg->css.cgroup, name, sizeof(name));
>>         ret += scnprintf(kbuf + ret, count - ret,
>>                         "Charged %sto %smemcg %s\n",
>> -                       PageMemcgKmem(page) ? "(via objcg) " : "",
>> +                       (memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
>>                         online ? "" : "offline ",
>>                         name);
>>  out_unlock:
>>
>>>
>>> Best Regards,
>>> Yan, Zi
>>
>> -- 
>> Thanks,
>> Ye Liu
> 
> 
> Best Regards,
> Yan, Zi

-- 
Thanks,
Ye Liu


