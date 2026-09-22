Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5014C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 11:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58BFF6B009B; Tue, 22 Sep 2026 07:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5634C6B00A0; Tue, 22 Sep 2026 07:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47C0D6B00A6; Tue, 22 Sep 2026 07:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 164256B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:47:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9CF601A0443
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:47:06 +0000 (UTC)
X-FDA: 85241222052.16.9D82823
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D964F180004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:47:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iLoYgScJ;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790077624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+DKAj4xzdIdJKSxQBQcBD03qNvXqcqF0lY3BnsNpe0=;
	b=sLabvTUz1PeFpFc5XfYGZ8ZCOln8aE/Zkp49kKkeYTlBefKxMZ/iYQrbxZ0ca8f8b/QW7K
	QEsCsUhDwhzCgM1dX4vXwQn6X/NDH+iwMqd3cWhn2l50cHoIJAztwFNq9Z9vbgxpXBuqda
	t8vEi72bypSyhvKTBOzgxWCIb5IO+aA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790077624;
	b=r+hAxSsrDEWvWqX6JYRUKzTCgatb1+mm0Fs7M7KEG9QKrW8DDBjQJsSb1au+hjYgeOPL5M
	BxAvOANddTVSXUwASn8SiYmKH3sdX6Xg7jMsQes2xnKVTDIfOkuxS9xiEidbxUya0s83b4
	T9H3Ob/CgiTvkghGExf67K5EuwcwciY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iLoYgScJ;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E7ED601F7;
	Tue, 22 Sep 2026 11:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48B01F000FF;
	Tue, 22 Sep 2026 11:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790077624;
	bh=c+DKAj4xzdIdJKSxQBQcBD03qNvXqcqF0lY3BnsNpe0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iLoYgScJP8kyzXcT27ks9DHRBs9LUcWMlsVKfWujGuDqvoNr6FSuHvHB9/SoFCLpZ
	 O32AE0nCsHqqF7z8754fWqJHurtvL4n/fjjS2I7gphbJZ6D6zV+XjQ5hxGt1/Qwk2W
	 mjNmJ9CGfKoy1zhGkRuTBiuYMOm3uvBKZqDlVsTZXCGc38ApHeh9D9ojsJOxpU5+Uv
	 VVuP4G9IkioxURcBOpKQlZaU7hlpEqzzrebwItu+acqyPCIlvyTgiinzlO0QjB4+Up
	 983xFLBA0M4YrSlIuCJvyVCHZx36nUuziYpWWfITljmkXGhPjSMLvScuDrNrwDQky5
	 58uEhwfCy+S3A==
Message-ID: <4101d661-7b16-401c-aaef-b87e81fdaee3@kernel.org>
Date: Tue, 22 Sep 2026 13:46:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 11/29] mm: split PMD swap entries into PTE swap
 entries
To: Kiryl Shutsemau <kas@kernel.org>, Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org,
 ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, baohua@kernel.org,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-12-usama.arif@linux.dev>
 <aqqwFOoPxqFnxclE@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqqwFOoPxqFnxclE@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D964F180004
X-Stat-Signature: xtm5isy967gihr6ao76aaniiabrzhiqm
X-Rspam-User: 
X-HE-Tag: 1790077624-598257
X-HE-Meta: U2FsdGVkX18PM0F1mutQGAI+ObyfRSPrTpXuLj6ctdr6TxjxQVF36TjhltqsgDHvVA7743zJF5S+0hBAj1bvs/3Ar3xnW9tos4g7rDxpq9ltcX1ZP9hWxKzCbSUMQEpdCxTMWufMBgj2CfyZCmE+DHX3yqC4LdE+MLK95ILlVAi4O6ioytjIfeeK2wOLwLs085sKxyupGq66bowzAHAT8jkgBIBAFbfe+QvSHDlchjKdNuYt+Rs0ZoqhQ4klUJYtLs6daWq/iff8hAVJCia9nFaiEWHV7J+yBJrSfnjCXwADyJmp+zojYERurTLLdjizr3c5FT/Q6RQ+3yyxrQ8ujlkZTLmkJXJ8T0tOBSdz7kDk3kQbW3XaGOHSw0XLXm7TNhlyfkPJL3ACalloijTNHfoZps2bQTsKzdJKGrKujqYHPmqfhsh8KPTq2++USD8g/sb6WB/jcp18RSSLnynvXRseQwUfztP2eRY2iZa1fPuIzaG+UwU4uWHxpzKpRDiWaqdbyGEkTzx/T3IdC44IJdmWzJDgy1BBozykyFGEVUiouDswTv/Nfq5ytcljtayr95J79hK4/rUOw2HO9M66cx0mEQm/DwjFDi7pw+0ny8EULkEogHKm7/my4DWWjruDxTdnFmUC+wobIQu1F2PnVyNtll1MP7B9/y6qOg4Q8CByP+H30f3GkF8ApV0RJCOWCqryfE9szq2ZZAzYmsn5UIAqzfuOqk1RmVtFtMfVk6wB5reFHKcWvzVdvgaGxejoGEEyDhBphIZMPU1cpD9cQMhGn29PSb/MxYaUooSWrq2HRQnGuMBJyxtFqQwt+I75H0GmaUrGrwn9w1JnY+JF0s6W8eKKfoiaMUQSBBEOiCAkEZlDt5lwx56amobsSfQDRGCHRuzzfqFcoEFO1h90a69SP56HFmkh/DzDzG9KY4wocnjJJGYT/3ptTx686efv3yui+/huilFOqdvpMH3
 jmor8E6D
 EIB+Cp0s5LoG65XDmU5yvmN686SHiPzn2uepqNo6G8V5ep6eQLqLM3ZuiaB3kLOD3PlbzM9I4qsFnvgC/CMkjn5/nxK8sc9Fv0mTYsu0EWncsyxNLt3jXLI9xPxFE5K+/XvdlsyCdLHWtISlB1u/ieYNTJS6EkcVVCi2ImWV7n7lOXELdag+yseDKTvLMXqKPEonX8sIszbr8tMIAA46umlOPKnR8xhnKfcm68m5ckn/vVjO/8tfxqp6JwdrzYgL6/sF1oXPJe/gS/yR938utWFsEl2hQFhzHvGxEdvtxYzmDHWAU6Y6GONwqBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 17:08, Kiryl Shutsemau wrote:
> On Mon, Sep 14, 2026 at 05:28:01AM -0700, Usama Arif wrote:
>> Once a PMD can hold a swap entry, everything that splits a PMD - mprotect()
>> or munmap() over part of the range, MADV_FREE, a pagewalk with no PMD
>> handler - has to be able to split that entry too, or the callers that rely
>> on split_huge_pmd() to hand them a PTE table would find the PMD unchanged.
>>
>> No reference counting is needed: a swap entry pins no folio, and swap_map
>> is already one per slot, so the PTEs simply take over what the PMD held.
>>
>> The migration-only entry point cannot reach the new branch, because
>> page_vma_mapped_walk() never hands back a swap PMD for the folio being
>> migrated. Warn if that ever changes, and force the regular split anyway,
>> since the branch leaves folio and page uninitialised.
>>
>> Test the pre-split old_pmd rather than re-reading *pmd in the trailing
>> folio_remove_rmap_pmd() gate, so every entry-type test in the function
>> interrogates the same snapshot. That part is cosmetic: pmdp_invalidate()
>> leaves the PMD present as far as software is concerned.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  mm/huge_memory.c | 36 +++++++++++++++++++++++++++++++++++-
>>  1 file changed, 35 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 873887aed0bc2..0e347a545588c 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3304,6 +3304,21 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>>  						 vma, haddr, rmap_flags);
>>  		}
>> +	} else if (pmd_is_swap_entry(*pmd)) {
>> +		/*
>> +		 * A PMD swap entry has no page, so it cannot be turned into
>> +		 * PTE migration entries.  page_vma_mapped_walk() never hands
>> +		 * one back for the folio being migrated, so this should not
>> +		 * happen; warn, but also force the regular split so that a
>> +		 * broken invariant cannot make the code below dereference the
>> +		 * uninitialised folio and page.
>> +		 */
> 
> The comment can be shorter.
> 
>> +		VM_WARN_ON_ONCE(use_migration_entries);
>> +		use_migration_entries = false;
>> +		old_pmd = *pmd;
>> +		soft_dirty = pmd_swp_soft_dirty(old_pmd);
>> +		uffd_wp = pmd_swp_uffd(old_pmd);
>> +		anon_exclusive = pmd_swp_exclusive(old_pmd);
> 
> The logic looks right to me, but __split_huge_pmd_locked() is getting
> awkward. It is close to 300 lines with two if-else chains that have to
> be kept in sync.
> 
> Can we have a preparatory patch that moves the PTE-install loops into
> per-type helpers?
> 
> split_pmd_into_migration_ptes(), split_pmd_into_device_private_ptes(),
> split_pmd_into_present_ptes().

There were recently patches about related cleanups:

https://lore.kernel.org/r/cover.1787941780.git.yintirui@gmail.com

I'm fine with cleaning this up later (I hope we can land this series in 7.4).

-- 
Cheers,

David

