Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA429D46602
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60C966B008A; Thu, 15 Jan 2026 12:00:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B7146B008C; Thu, 15 Jan 2026 12:00:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CFFD6B0092; Thu, 15 Jan 2026 12:00:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DBB76B008A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:00:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2F24B9605
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:00:47 +0000 (UTC)
X-FDA: 84334812534.08.F615E09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id CD0EB4000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:00:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="tBmRUSF/";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768496446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IKvtryMZGAeFknx0hrrGvGbj1czbv7zXhZw2wagyUD8=;
	b=FiXWOUzKFD3S/J5dOeUYqslwAOSZzqt6yLXc8PKhXOf8pd7dVNMBMCzOAHFd5z1ReFjuxV
	n/BbKZJs2+I4W22ym6lsNzUyqKJvC10B+jg7q4b/Ju0x3Hq9UBqGGKogSVhXxQIWE20BBB
	4IUzqNsJ9zwgmO2IO/AVS8VKl4BG8Zk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="tBmRUSF/";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768496446; a=rsa-sha256;
	cv=none;
	b=ZO5al5y1bjq6AdhuoYdukna4ZDgw+iUM7zH0QGtBTzjiepdKIqV5WSZlghXpcTEmBVOJwy
	QjYC8jZenU/zAz4pVYOWgfL2FXsp0MqT66ldCyD6/auEh/0tzOVBHqjXQlg5MaQO2sCQ1F
	qQz0asxxyuLMIwNZRcN0Gz2Ngh6/dy0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CB04D443E3;
	Thu, 15 Jan 2026 17:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2088C19422;
	Thu, 15 Jan 2026 17:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768496444;
	bh=84ZzsHKAsmM4gPycYymqOGqKp1Uk7K/+crT20DmmNeo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tBmRUSF/WJWzAErGMwtJx3Ly6y9N4lTBa+f8BuBZ0FB9MHRKIdZe00jLd3lJ4NHVk
	 bRflBmd16wdjqzwc3ny7gUFvXGQOHCbzqNGAzVz4Z6X3+8dRm239DQccpxEgfEOhUW
	 4ZqXd+qhUZjFebPDwdKfSQc467jbqexLwIruYOBefLoxsX//rEaPct6nDDLehIPSFZ
	 L1230G42T25WKqNf9FInSLhqkoiKl2Vuoe3O0EDyGgvm4V1dvexxMrOCSrS5w/rHcC
	 hKAuh2xSGPSW84fBsM4oGZD0s5qBFqtHyCElZdpwdoYWjlf8P5uYmeXyWgbuCDHkTQ
	 leJbLOWcHz+3Q==
Message-ID: <4d47cd01-034d-4886-80c4-3861d2181e18@kernel.org>
Date: Thu, 15 Jan 2026 18:00:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: "Li, Tianyou" <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20251222145807.11351-1-tianyou.li@intel.com>
 <20251222145807.11351-3-tianyou.li@intel.com>
 <2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org>
 <e9d52093-d11e-4e0d-9bb9-88e0ffb78a19@intel.com>
 <a7da047e-0064-4f21-9f8b-fa4bcf40dca3@kernel.org>
 <d97a8744-6d49-4582-82fc-a38ee2ae06fc@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <d97a8744-6d49-4582-82fc-a38ee2ae06fc@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CD0EB4000B
X-Stat-Signature: woprdb6xe4yp1w3kdxmf6xq8mynt9cfs
X-HE-Tag: 1768496445-299899
X-HE-Meta: U2FsdGVkX18qgDH3qoNPdsAb2aHP9KEWJXPrtz9jZpuhjpLnf55opWllCCdiT9dKNj3/FDHR8aFT4YWX8etvPBgZxJ3zvywsmyJ8Va0DzY9V9LxdXBqYaLQz+WCVMZzXS+FTUKBI3BbdOxkCIxk/nSapqxJYuLg72pjB84gQhdy5CkGDu6xhT+9tRnH/HduQCoT7vFmIsHGFNxumWF1jk6OoyTPfIstC31dQn43Cs+NJk1OEyJ7F0WDg2IXKhsyXvevKurGtqhZVbkYvIYBtcIEl3g52xMLB8LrhKtixFlo9j+O0ou2oFleviQZe3FwRH9Lh2giGN4nD2Rmv9IANYODu5KVS/xfwfmlZ4Ew2oUarWLAkCFFL2xtNm8xNHTKjZp4gAcCeFpgV4NHofOwK3+qIxqZMnlflc5Rw0BwpRbsRnhfp0pv5r03ZF8lkAfJBdKXZCdvdOpVyTYYxlGyDHGe64ExiMtfLpgvAwwrnbrktDg5Kx94xnSfE4O8YbxMnNczpaUqJsDd4s+k3vxcZXmqdS18CuyYBMKmc2wVxM8c9F4MO9XNj5GUIUsAs56MmNxPKpk6gKAC42SeMC/pnThaOQhSPQcBlHPq38IIwOYesZB+KfV3nTV2gJZQ6PQOmJl8ATnuF9kmjDqJLaKm1EhT95ZkPABOjQ19SUGrhvWFJSh5OVr91QexoUFOfIv5y2DcSomDQ5GqeK1c9Ru3pwNuIboUQd8YR/t//JRH7rwo1iPGyYCyyN6/+021DJeO4sGfWas+VR9rA9XbLsfW0V5uykcFlSDKt+0+gIe5Y49FjxR36SSMa5TELSEvBK5F4ERCLW+36ahtZOt9bOyHEEKCg4JJ8HkYePD361ymYNhbiM9KFnmy4pg0YbYcCgtRC2nS+gOugmaIccmm3uH2mB6nIOyK4A7LduAwKvIakOyeGlHUEmCgomDg7ZjhilF66hkcb9nOEweH/4DCP3YG
 4/68MDSw
 KWofqkKqism+95bb9dv6SBScPXmxPx5DSgOAMpFkyxleAJrlsr9tFMBBr3qMX20L5F9O5WcYkg27FV46Vb3HHFJwK4Wa8zHLmG4x7Lq7nJZGQ0cSBQpodLDKfxOMsC4B6HapK9r2MtpfIupdjLLPriyabIydUVbzUjsvlk0QEmgamxCsELtYxJyqmV6vY6E/AyfwI6KR8m54P1oenXUbwuqP1txfJ7v5xAnncDKH8aUatP/hirS3DelHEtZYAcIZWUBjBZSOhA53O2BBQ4tXr9BBd/WWCluFBdh/6SgFrXmQrNLTpL9xJG5Y6mVHZIVf5C1EeCECJmUQ5kzKoOxqHK3+YB6O2C2h3olFt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 16:09, Li, Tianyou wrote:
> Sorry for my delayed response. Appreciated for all your suggestions
> David. My thoughts inlined for your kind consideration.
> 
> On 1/14/2026 7:13 PM, David Hildenbrand (Red Hat) wrote:
>>>>
>>>> This is nasty. I would wish we could just leave that code path alone.
>>>>
>>>> In particular: I am 99% sure that we never ever run into this case in
>>>> practice.
>>>>
>>>> E.g., on x86, we can have up to 2 GiB memory blocks. But the memmap of
>>>> that is 64/4096*2GiB == 32 MB ... and a memory section is 128 MiB.
>>>>
>>>>
>>>> As commented on patch #1, we should drop the set_zone_contiguous() in
>>>> this function either way and let online_pages() deal with it.
>>>>
>>>> We just have to make sure that we don't create some inconsistencies by
>>>> doing that.
>>>>
>>>> Can you double-check?
>>
>> I thought about this some more, and it's all a bit nasty. We have to
>> get this right.
>>
>> Losing the optimization for memmap_on_memory users indicates that we
>> are doing the wrong thing.
>>
>> You could introduce the set_zone_contiguous() in this patch here. But
>> then, I think instead of
>>
>> +    /*
>> +     * If the allocated memmap pages are not in a full section, keep the
>> +     * contiguous state as ZONE_CONTIG_NO.
>> +     */
>> +    if (IS_ALIGNED(end_pfn, PAGES_PER_SECTION))
>> +        new_contiguous_state = zone_contig_state_after_growing(zone,
>> +                                pfn, nr_pages);
>> +
>>
>> We'd actually unconditionally have to do that, no?
>>
> That's a great idea! Probably we need to move
> the adjust_present_page_count right after mhp_init_memmap_on_memory to
> keep the present_pages in sync.
> 
> When the zone is contiguous previously, there probably 2 situations:
> 
> 1. If new added range is at the start of the zone, then
> after mhp_init_memmap_on_memory, the zone contiguous will be false at
> fast path. It should be expected as long as the
> adjust_present_page_count was called before the online_pages,
> so zone_contig_state_after_growing in online_pages will return
> ZONE_CONTIG_MAYBE, which is expected. Then the set_zone_contiguous in
> online_pages will get correct result.
> 
> 2. If new added range is at the end of the zone, then
> the zone_contig_state_after_growing will return ZONE_CONTIG_YES or
> ZONE_CONTIG_NO, regardless of the memory section online or not. When the
> contiguous check comes into the online_pages, it will follow the fast
> path and get the correct contiguous state.
> 
> When the zone is not contiguous previously, in any case the new zone
> contiguous state will be false in mhp_init_memmap_on_memory, because
> either the nr_vmemmap_pages can not fill the hole or the memory section
> is not online. If we update the present_pages correctly, then in
> online_pages, the zone_contig_state_after_growing could have the chance
> to return ZONE_CONTIG_MAYBE, and since all memory sections are onlined,
> the set_zone_contiguous will get the correct result.
> 
> 
> I am not sure if you'd like to consider another option: could we
> encapsulate the mhp_init_memmap_on_memory and online_pages into one
> function eg. online_memory_block_pages, and offline_memory_block_pages
> correspondingly as well, in the memory_hotplug.c. So we can check the
> zone contiguous state as the whole for the new added range.
> 
> int online_memory_block_pages(unsigned long start_pfn, unsigned long
> nr_pages,
>               unsigned long nr_vmemmap_pages, struct zone *zone,
>               struct memory_group *group)
> {
>       bool contiguous = zone->contiguous;
>       enum zone_contig_state new_contiguous_state;
>       int ret;
> 
>       /*
>        * Calculate the new zone contig state before move_pfn_range_to_zone()
>        * sets the zone temporarily to non-contiguous.
>        */
>       new_contiguous_state = zone_contig_state_after_growing(zone, start_pfn,
>                                   nr_pages);

Should we clear the flag here?

> 
>       if (nr_vmemmap_pages) {
>           ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages,
>                           zone);
>           if (ret)
>               goto restore_zone_contig;
>       }
> 
>       ret = online_pages(start_pfn + nr_vmemmap_pages,
>                  nr_pages - nr_vmemmap_pages, zone, group);
>       if (ret) {
>           if (nr_vmemmap_pages)
>               mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
>           goto restore_zone_contig;
>       }
> 
>       /*
>        * Account once onlining succeeded. If the zone was unpopulated, it is
>        * now already properly populated.
>        */
>       if (nr_vmemmap_pages)
>           adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
>                         nr_vmemmap_pages);
> 
>       /*
>        * Now that the ranges are indicated as online, check whether the whole
>        * zone is contiguous.
>        */
>       set_zone_contiguous(zone, new_contiguous_state);
>       return 0;
> 
> restore_zone_contig:
>       zone->contiguous = contiguous;
>       return ret;
> }

That is even better, although it sucks to have to handle it on that 
level, and that it's so far away from actual zone resizing code.

Should we do the same on the offlining path?

-- 
Cheers

David

