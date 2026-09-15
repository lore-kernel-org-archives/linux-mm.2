Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7369FC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553696B0088; Tue, 15 Sep 2026 11:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503F16B0095; Tue, 15 Sep 2026 11:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F1A46B0099; Tue, 15 Sep 2026 11:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 081A06B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:20:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1ED1C1A0459
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:20:16 +0000 (UTC)
X-FDA: 85216357632.21.00FA0A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4FE1D4000C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:20:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F5KCAvfz;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485614;
	b=emuf3JwDXmI6+fvwFRwzg9C/BqqoOMcwquMYGimbLLCpBbXIp3qiQMnK5zb4HBGy/TDpLQ
	T7nXs1Idl/at2wRN8dH1iwLrGlHhoUalWvI+EP0ROcS+v3eT84lmqCGrvKNGlTrKtXZLDQ
	AtxIaFyp/e6HeP5yKxYpK26QZqUpoKo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F5KCAvfz;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=isskOEQfc9nzpx03clYSswsA678FF85KNCAnq2sLlf0=;
	b=JW3dzAAZMysL/y+rhQV5tP1JCUvC/T8HQqliA+KHJfZdOJuySAIcnL9yVmwcUd+ueoP4BC
	g0YHY30s2uvQW6HlYtcC2VfqZqyf8xTkqE8AIGqtvCxIYunCUN7qItr0QlyhaMMyIkg84Y
	IGntw/7zbB/Ip7DlMLv+iHPgTd08CNI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D233D600C8;
	Tue, 15 Sep 2026 15:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876C51F000FF;
	Tue, 15 Sep 2026 15:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789485613;
	bh=isskOEQfc9nzpx03clYSswsA678FF85KNCAnq2sLlf0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=F5KCAvfzKIMU4RBO8DimZQ+dYMQ4Kck5NXykD8YT6qRLs+1XhXMqwpDa/0PF4bDCx
	 oapOUpXIapYpujnnnHerFsH/Leztqw8ke5xgeGMOlaQ3IjWTmXOZlUimaUnfpfHigi
	 HvdGCt9N1CGdHEvP5jvc/KMiqb2Vcf6vArbviDyRQBo0e5TJItJhNua0+a2MR7m1Qw
	 FjzrOzP4Wx6QPyISluhoMdOwD6TW8DoBjXOc/IsvUXNpxNJXY9i35/nc13CToUYrlq
	 vhLoq4vztd5Jk2663lqxxjJA6AE5j32XeCloFoGA5TuLQxaLqHTlhAaMg8JAoVTiOy
	 iI+P8x/YBg68w==
Message-ID: <209de483-a9a5-4d98-bda4-7998e8fdc7da@kernel.org>
Date: Tue, 15 Sep 2026 17:20:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
To: Mike Rapoport <rppt@kernel.org>, Yuan Liu <yuan1.liu@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
 linux-mm@kvack.org, Nanhai Zou <nanhai.zou@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, Jason Zeng <jason.zeng@intel.com>,
 Chen Yu <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Tianyou Li <tianyou.li@intel.com>, linux-kernel@vger.kernel.org
References: <20260914072929.1883794-1-yuan1.liu@intel.com>
 <20260914072929.1883794-3-yuan1.liu@intel.com> <aqjfyGeQaL4g2EcA@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqjfyGeQaL4g2EcA@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4FE1D4000C
X-Stat-Signature: j5fjpqu613998fct8kabkt1i66k4fqii
X-HE-Tag: 1789485614-799373
X-HE-Meta: U2FsdGVkX18VzsybFpfxx8oAo10Yvo7lVfmVq8nFr+vVtZdIP0Ea0JPKpbezjIqd196RGM85QCrknIATeojiQ+/gRB2m/pkTS231MrkxFSdI3Fy0o4TYmW6+5zuweFJspXUtfiQqmHG+io9+9SN7hg/Lc3agJpLpPblfJrs6ckJvcZaNG7inLxSIjNsQ2Wxj6ADuyYmRanap5Ucj3XJfG9a71T+k84pzZEG0Dsq2+5PNlzs+kmdnr7uzhYUyK5W2y6iA+8st76PdXrR7i8bwAwYzbCj/Q4OVKJEBchaovXi4uiAkY/5DjOflXUfH6ZOvmdFUuP8hOYwgaRHXhxz3I2ZD0N8QyEaZLa8jyIylJrLpVsqiRx3UD83Vmdgb+ZVsS0jzVVpFIMux2qWaJNYeCwHdZZ690ioAj6jVN9/Ni74XrsuzBZM6GBSgWPqNBqI6ZC/7SBOgTyKtpG7kOPro9I98BS4lKpCZxrxw9GGZtaAETJKSpZI0cw+Ku0VQRiOc0B1HAZ5/EW5I37ylTg1WtA6bx0S6roKzb0wLWlmiNL4DHYY/NwycGvs+YuCaddawfu29bPpBpLnZOOKWFn7nVyYTgvReEQCfar7nQgjDJaIL0yhBo4zgvXt/GSBuRNEk2iRfi9ft4RHF8dWQgCMQn7iUdFBVXJyvKd/Ce8TP0BY03lp9RoxUJs95lmvHT+yebS7BwZ5VEmKDrOCiRxuBsyEiFeGEfs0OUOBtfA7HIBX7qjuCDIGqMdM1zWRrAhdI4b5HspxbHb4zpCuQ7LVAc+n8MVCp60DJIPPENa5r+WIN5oHwtakR3mtwPyPgMcIpRQ/TgIrTN5b9GeBbJMZKICgd6nun68uBzDv2rpOhpRvLN2OESWuSMZDVn8ThnsjuGkVVFi+tS+2POY/n/jtLqDf4qViP9QZzNkvebbkevyXq0jtNtRSpQOAAsannqF0vsQvfW+xQx1A+HkCOFxD
 HmyNBybt
 H4W09fhVypTBhf8sq/TZE1NeSnnTZscKDJxLxuzn8TquNGXy9GUDd2+fIz0BLQZKW94j9vN3+YMse5zq9Dd4q25HxdrWvcINCJkwUWve65xvi60/Ra/aZRI6U3xvK6jUZgUhX2PSZQe0VbP6nfkS3FPruQcbE6vaGa0IdyVyaZ840RldHJNFvAyeE1lgs/kcfLDADlRam29NcYzCQqJAqPs0AwopcIPYnzHSRzcP4OJqxV2LL3BzJbt/aB1t+leeBDwFta87LYT4Od2ITQegDaeEAjj2vtIWoFj3Jeb9k09sPrFXnGwm48GSfN4Bw5Wr7wTmoG5aPrPG1cNePRHaocmsvqyqH3AR9zu+yfPOqobbLWUdvjQqQf9xIV/EuUcpcGEr8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/15/26 08:03, Mike Rapoport wrote:
> Hi,
> 
> On Mon, Sep 14, 2026 at 03:29:29AM -0400, Yuan Liu wrote:
>> When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
>> zone, set_zone_contiguous() rescans the entire zone pageblock-by-pageblock
>> to rebuild zone->contiguous. For large zones this is a significant cost
>> during memory hotplug and hot-unplug.
>>
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 1533aebafb68..d40a8ff23370 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -817,22 +817,39 @@ void __meminit init_deferred_page(unsigned long pfn, int nid)
>>   *   zone/node above the hole except for the trailing pages in the last
>>   *   section that will be appended to the zone/node below.
>>   */
>> -static void __init init_unavailable_range(unsigned long spfn,
>> -					  unsigned long epfn,
>> -					  int zone, int node)
>> +static unsigned long __init init_unavailable_range(unsigned long spfn,
>> +						   unsigned long epfn,
>> +						   int zone, int node)
>>  {
>> +	unsigned long next_chunk_pfn __maybe_unused = spfn;
>>  	unsigned long pfn;
>> -	u64 pgcnt = 0;
>> +	u64 online_pgcnt = 0, pgcnt = 0;
>> +	bool is_online = true;
>>  
>>  	for_each_valid_pfn(pfn, spfn, epfn) {
>>  		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
>>  		__SetPageReserved(pfn_to_page(pfn));
>>  		pgcnt++;
>> +
>> +		/*
>> +		 * With vmemmap, at this stage all pages in an early section
>> +		 * have a valid memmap and are marked as online. However, only
>> +		 * subsections in the subsection map are actually online.
>> +		 */
> 
> I'm having trouble parsing this comment. Shouldn't is say that some
> subsections in a section can be offline because of holes?


Maybe extending that a bit we could do

"With CONFIG_SPARSEMEM_VMEMMAP, early sections have a valid memmap for all PFNs
and the sections are marked online. However, we might have offline subsections
in such early sections, indicated by the subsection map. While we must
initialize the entire valid memmap, account only the online pages according to
the subsection map as online (see pfn_to_online_page())."


-- 
Cheers,

David

