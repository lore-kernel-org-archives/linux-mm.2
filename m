Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C70610ED67F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7E0C6B0099; Fri, 27 Mar 2026 10:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2E676B009B; Fri, 27 Mar 2026 10:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6BD56B00A0; Fri, 27 Mar 2026 10:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A4DB66B0099
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:44:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 510145E9A5
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:44:27 +0000 (UTC)
X-FDA: 84592113774.20.E270294
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 820ADC0012
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:44:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a8E2wyNd;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a8E2wyNd;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774622665; a=rsa-sha256;
	cv=none;
	b=0d+eXb73hE9wLBiDZo4nxftFk1/HfHLZPyzpwZX/miTyy9SI6/TfszohhbEDtKE7yp6fv7
	Siz9u1gxUlc0asSVLRoVlZSkIH92H6VXDGB5fyWb6ED6cZINqk4UxonhtAYftHl+zNuQ7N
	fiEp6Fy9xJmo/61qfgwe5VbpNLpCCzk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774622665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4bL1ZdD0sFQhLxNDlIYt/xGNsmzBE3WuCYZOOCOtpJY=;
	b=FjApKOwAam5Wxp9IPYPoNACyuEYE4XqW3oNu+VdX6QMWHzTBxLP/A5co8iWPlDOguMfR1M
	4nqJ2BsTOkq0+YFxrLa6IUL78mVXS6mVwtYl+lNRZcCZ3ZIqRR9nk9b3/lgQH/9WY/q7AI
	q32iyaUx4l/+HEN1Yx8O/wbt7cRIUMU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A48EF444C8;
	Fri, 27 Mar 2026 14:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9445CC19423;
	Fri, 27 Mar 2026 14:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774622662;
	bh=VzHqT1HLWRjCt76mqRElErCGJJ63FvELKETApdvgTtc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a8E2wyNdJdSDZm0OE8JfiS0ZOuXavyS8W+f3sH3lFuwsiRPNFKHKQuJ37M5mjZ7gP
	 vk/NEMG//USy10sqpVztsM6u/7B5EcEerEDDx/SvI6+nSnMCyWxFCvPddhJNJJ3SNC
	 wJfUkzB0oy27IjdARRblG64Ei4E8V40vR2iDoCrZwXVq0MVnCKyYRrDNPkei+YHZAy
	 dV5obcBpIRU5PUZ+4Et8Ob37LyIf5R6YwF//O8oBlXJHN5TtEZqcrPCii0sRI5a5fx
	 5NnHYhh1ehALiW8ZME4bu9f3vV1L/kQUmpg2mXDKGKH9D8BZO/ZyWpkQd+phdl0AuR
	 9riX2874GFefw==
Message-ID: <2356614e-d9b8-4639-8e2a-96c5e4eaef61@kernel.org>
Date: Fri, 27 Mar 2026 15:44:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory_hotplug: maintain N_NORMAL_MEMORY during
 hotplug
Content-Language: en-US
To: Joshua Hahn <joshua.hahnjy@gmail.com>, Hao Li <hao.li@linux.dev>
Cc: david@kernel.org, osalvador@suse.de, akpm@linux-foundation.org,
 vbabka@suse.cz, harry.yoo@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
References: <20260327143823.3063541-1-joshua.hahnjy@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260327143823.3063541-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 820ADC0012
X-Stat-Signature: kzfj9y4waripcisw7j8gmw7oizys73ad
X-Rspam-User: 
X-HE-Tag: 1774622665-415200
X-HE-Meta: U2FsdGVkX1+km0zu8WmHKv72f/KHEESmo2xCVpLl2J165Va1Cxo/TtgAS+Zos8ElBFpV/f4iUkOAUrYheMcjPSwN5ogYwszL6OcW98acLx0o8igEurFMhOzPk2O9sVWInbilsR4QDkAz7mC2fe206FveUFslSfhu5OEokfex7dmEELfov7GrXA9/cntRjsxjJHfgw/JmeeeEHWZJExXaPOh5YWeiZ+qC+BiJ6ET+FLG8aTFNk1COT90MKDtWw4xkGCcYvlW3SLzuDomQ52Q2zmuoS9adw8YDT+FEEZS/OXbQTUn0KJI8HweeSixADul9z4iPtoxv951k2YDBDzs6YzJ5XXUEfVuKfhfWu3GuBFMonJ9HBinDNKM4fUWKP8Z1KRbZIDiUIhKi9F7johywjQKn/Q7Dil4XW/J38GGHCvSUe15ndwKMoCr27B2YjPni7zy0ImjJ/WmNclqpbPH56T46fbNTd1NfBDJJELCf06ypvXwjLx/zN+K0961A4T77SILWOcuzjs+vUKOhWuTnStOddeUwocASX8KNmpnIw8RCgU+beKel6GM3fJetnn8SRvtCWD0Kl46RzdfIAM5haUeo3bbVuclY0KpPHpenWPwD4BWpIUjUau8DzWB5LQav/V8qq65B6f48Gw9aHkFE1UhT3iJgGRhonYazDnDGNz633j25stJUlsF0QQTtRzARtY0EfPYA2v7N8XETq0xY0Q+AxwFvZARsYeEsGiD6q8jkjEdB5nSnChQqT7FTPr+b3YorVCKemV2eGFhDo5TryGoWP+fqfg0TjeN7pJScWxXUKBN3wTOmEEu4A8dIynsGQ+B/PvLqKdJE4M5B12AtO8HqQxjR/5EJ2YfQNmvjIYSUlGCMoctWaZnyJY3JQ1YSIiOkAYqgPiO292jntbZ1G3/TgMKlnDb0Zm+yLoWbwFjIuuOAdSiLvn/EqCMlyw14vd8qN4h0FXpzdeRALKD
 5F5sYXVI
 JlNC5flJbb2/HrYNrr4jwF31lNo2KkTZ87E1qvI6+DspcvnYE3nw5MY33eIcFlMAMozqBQX+VGj3MY2yzCTVfAP4Ft38UMWZxv5vfkpWvb/VbMTGH3cviS7b2vub3kkQxXnVCwyppawjZ2JQlOB46kcjiGWewuv81L8j3e//0jSkxyPpftIcD5FkT/IhHfsaDYwZfsw457AQO+un07GnR6c/sw0fwpQ4TKlZEopypp8CslogILqE5Bs7cYofM/n4KTvJ6ENKzYMazH7icR4w61OmuVAl94ktbS6cmyFKkGMnfkbmTeTUYGkQtlXLaOfbG5s+Y5XAfQnd4fp8Wrszv3D40LNZjFo/eepcziWqLCSHFPaujPqRncRduZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 15:38, Joshua Hahn wrote:
> On Fri, 27 Mar 2026 20:42:47 +0800 Hao Li <hao.li@linux.dev> wrote:
> 
> Hello Hao,
> 
> I hope you are doing well, thank you for the patch!
> 
>> N_NORMAL_MEMORY is initialized from zone population at boot, but memory
>> hotplug currently only updates N_MEMORY. As a result, a node that gains
>> normal memory via hotplug can remain invisible to users iterating over
>> N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
>> incorrectly marked as such.
> 
> The second part feels more important than the second part, doing a quick
> glance through the code I can see a few N_NORMAL_MEMORY iterators that

Note in practice it's unlikely that a node would hotplug normal memory,
start using it, and then manage to successfully hotremove it, due to
unmovable allocations. Most likely only ZONE_MOVABLE memory can get hotremoved.

> are in some hot paths like shrink_memcg. Iterating over nodes that don't
> contain any NORMAL memory seems like an inefficiency rather than a bug
> though. 

Ignoring nodes that have normal memory, just because it was hotplugged, will
result also just in some form of inefficiency, or can the consequences be worse?

>> Restore N_NORMAL_MEMORY maintenance directly in online_pages() and
>> offline_pages(). Set the bit when a node that currently lacks normal
>> memory onlines pages into a zone <= ZONE_NORMAL, and clear it when
>> offlining removes the last present pages from zones <= ZONE_NORMAL.
>> 
>> This restores the intended semantics without bringing back the old
>> status_change_nid_normal notifier plumbing which was removed in
>> 8d2882a8edb8.

But commit 8d2882a8edb8 didn't introduce the current state, or did it?

>> Current users that benefit include list_lru, zswap, nfsd filecache,
>> hugetlb_cgroup, and has_normal_memory sysfs reporting.
>> 
>> Signed-off-by: Hao Li <hao.li@linux.dev>
>> ---
>> 
>> This patch also prepares for a subsequent SLUB change that makes
>> can_free_to_pcs() rely on N_NORMAL_MEMORY to decide whether an object can be
>> freed to the sheaf.
>> 
>> ---
>>  mm/memory_hotplug.c | 22 ++++++++++++++++++++++
>>  1 file changed, 22 insertions(+)
>> 
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index bc805029da51..5498744aa1f1 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1155,6 +1155,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>>  	int need_zonelists_rebuild = 0;
>>  	unsigned long flags;
>>  	int ret;
>> +	bool need_set_normal_memory = false;
>>  
>>  	/*
>>  	 * {on,off}lining is constrained to full memory sections (or more
>> @@ -1180,6 +1181,9 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>>  		if (ret)
>>  			goto failed_addition;
>>  	}
>> +	/* Adding normal memory to the node for the first time */
>> +	if (!node_state(nid, N_NORMAL_MEMORY) && zone_idx(zone) <= ZONE_NORMAL)
>> +		need_set_normal_memory = true;
>>  
>>  	ret = memory_notify(MEM_GOING_ONLINE, &mem_arg);
>>  	ret = notifier_to_errno(ret);
>> @@ -1209,6 +1213,8 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>>  
>>  	if (node_arg.nid >= 0)
>>  		node_set_state(nid, N_MEMORY);
>> +	if (need_set_normal_memory)
>> +		node_set_state(nid, N_NORMAL_MEMORY);
>>  	if (need_zonelists_rebuild)
>>  		build_all_zonelists(NULL);
> 
> Do we need the flag here? As far as I can tell, we can just skip this and just
> directly check whether this is the first normal memory we are adding to the
> node here and set the bit. Then we can remove the flag and the extraneous
> check. We won't do any notifier work so I think it should be OK.
> 
>> @@ -1908,6 +1914,9 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>>  	unsigned long flags;
>>  	char *reason;
>>  	int ret;
>> +	bool need_clear_normal_memory = false;
>> +	unsigned long node_normal_pages = 0;
>> +	enum zone_type zt;
>>  
>>  	/*
>>  	 * {on,off}lining is constrained to full memory sections (or more
>> @@ -1977,6 +1986,13 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>>  			goto failed_removal_isolated;
>>  		}
>>  	}
>> +	/*
>> +	 * Check whether this operation removes the node's last normal memory.
>> +	 */
>> +	for (zt = 0; zt <= ZONE_NORMAL; zt++)
>> +		node_normal_pages += pgdat->node_zones[zt].present_pages;
>> +	if (nr_pages >= node_normal_pages && zone_idx(zone) <= ZONE_NORMAL)
>> +		need_clear_normal_memory = true;
>>  
>>  	ret = memory_notify(MEM_GOING_OFFLINE, &mem_arg);
>>  	ret = notifier_to_errno(ret);
>> @@ -2055,6 +2071,12 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>>  	/* reinitialise watermarks and update pcp limits */
>>  	init_per_zone_wmark_min();
> 
> Same here, couldn't we just iterate through the paegs here and accumulate
> node_normal_pages and clear the memory here? We can get rid of the bool and
> also keep node_normal_pages defined inside an if (zone_idx(zone) <= ZONE_NORMAL)
> check as well. 
> 
>> +	/*
>> +	 * Clear N_NORMAL_MEMORY first to avoid the transient state
>> +	 * "!N_MEMORY && N_NORMAL_MEMORY".
>> +	 */
>> +	if (need_clear_normal_memory)
>> +		node_clear_state(node, N_NORMAL_MEMORY);
>>  	/*
>>  	 * Make sure to mark the node as memory-less before rebuilding the zone
>>  	 * list. Otherwise this node would still appear in the fallback lists.
>> -- 
>> 2.50.1
>> 
>> 
> 
> Thank you for the patch. The rest looks good to me! Have a great day : -)
> Joshua


