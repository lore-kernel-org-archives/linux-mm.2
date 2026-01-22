Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B5F3C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0FB6B0154; Thu, 22 Jan 2026 06:33:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB85D6B0155; Thu, 22 Jan 2026 06:33:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4096B0156; Thu, 22 Jan 2026 06:33:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AAD9F6B0154
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:33:06 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5DF4C16025D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:33:06 +0000 (UTC)
X-FDA: 84359388372.17.7A94119
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E777C14000A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:33:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=elXN6kAD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769081584; a=rsa-sha256;
	cv=none;
	b=oi1kxfNCctiXJL32oUhfGVw7wDfyAlnDqLH+r9EzL5LVe9G79vd+FThHABJ6wNeHqJu5Y5
	ls2EPFcVmpAcgeBAQ07WZUvXwjqfNuIHlhRjq/P5UQIoHfscmrOeTA9bCBOS1c+4SPkrx9
	PXFbB908nUCSPv9PVjDtcQ/6cuHiLjs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=elXN6kAD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769081584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VkcESs9IRUmQ6wO9mvJ+w9N+5/hR0W6iCxEMY0nDun0=;
	b=D13ZLFJpIyTzHkNgjWFY8IgDNqMGOAlPkK6dmKHoO0fkh8B3kncdVAeYHddgc41+Q+5AtT
	9jNdMRA203T8UDh1/7luyG5q5HswCi5PQbke3k1aWrq09gZaWMP/GvEAneFQm7Mcub7KUK
	IyDH1dnUi8AK16VpsxUS2H5e11cMXqI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 236AC600C3;
	Thu, 22 Jan 2026 11:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A708C116C6;
	Thu, 22 Jan 2026 11:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769081583;
	bh=MT9pFV75h0kEmZC8bIWLFiHCACTEbTBp++ksnQFyvoc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=elXN6kADHsYbxw7riLecWjrnoHwzXUqXB0BHU6NtMjlC/TRgi6c5iq18AS+JGg/7p
	 GAXSrk2TGJSdoSvtU/gnNY/0xbNnLM5BMYJgV5zjWtjbyduX0kIqp/LLhoJAkJGnPl
	 Zg/hVqzht+qvSNzrRLGcZiqeV54nQufdxn6K6aDfoUbnIXvxgoliiNkdorrVJCMxqh
	 ry7uB9fFUBOZwkCmUPd+ZtAWEeUeYJl5k82Y1W5+fYIepLhv4nd8M1L/GdBmKnRQvL
	 eygIHwdBhAoexps7q5rHryWJLO8rQDDya4lPdFcaLVpXNUaYRdGAV+FRWmjACK+Ltj
	 5uu74gQGbTJRQ==
Date: Thu, 22 Jan 2026 13:32:55 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tianyou Li <tianyou.li@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 2/3] mm/memory hotplug/unplug: Add
 online_memory_block_pages() and offline_memory_block_pages()
Message-ID: <aXIK55fQeKfB-jM0@kernel.org>
References: <20260120143346.1427837-1-tianyou.li@intel.com>
 <20260120143346.1427837-3-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120143346.1427837-3-tianyou.li@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E777C14000A
X-Stat-Signature: zqotmdy8g9q7cu7yq8sw5e79xiq397rc
X-HE-Tag: 1769081584-96620
X-HE-Meta: U2FsdGVkX1/dudT6180MCVDeRspD+puicE6uMe2UAm7V4a2ImMxebQkVVsmB54hTiFIvXyTIsiTe8KZA/29pJcRB3Op07lX2i4Cf7cYLKoCxWrLpvSlHZt1X5YyXmIW7TYmg4xg++1tsFnkBMUjOJ9XZ1ZY3pjJpSa2UbkPrqfPCYI8+YJ3LqpZSk5ryHJDiR2KcJyKZsPv4dlNb+g/blShIYYOcrxJYCyUarWNieF6Ueu9N5qmYP3Q2y54K0lWelD5ki1Hj9gZ/Oqg0pEZomo3hoFht1Sk2UTn+JQUIkXMPYLGeGTAcPguS7ZOJIVdx+6AA6aydousFTln3Ool6g4RJDN8xNJezBIuSdApL5ly/oOyO04kir+sbbyyXv7M3mE9DmHU8H8N7ON8YEppK9TUZCc6/GVuk9Wqzlpk4bCc3G8bzjJ2Mr6qVR+ys6EMKI3StT+jWzgSSTChlprkgT7nrODsqWJWtcmws62zMALwhyvSjgoIW/debpI0fLAXVT13QipIh7PkGeAQAzrnFpe1/9UVBOw7CaHBLnj0IpIEVuaYzdV20+z2yF1ns9Y0y2h0g8xPtigRMJ9ZGX5iqRQHj9QhD1z1ONeJsMitBCAQ+htCty/wAKZ/hoLR3lNEQr3ibTRxq9K4wGuxW/6Wt/Ey15H/YgWVg//NcSvp6SWpTq73+3zo21o3n1LP3+7kmHQIh2hD85g2IUJCFMGdYOVZrCyhHQhh00i++a0WyT63LmV5v7z+igi0t74bA8A1Ahc8eqIsc7vrHA5Ye3Gc4HU2kfM2JwFHyB1aWtbBudLqzuSG5IpOPIPmcwhzKpz1jockU5KkUGkrXy5raAFAhhd8SX83uJIsReQ9MhKIk5TsPIOy1uMWlxwJoK1D2P8zmDE6ILg3gNsSnGiq+/sStxiyWh+Ln6ZjSPn9wfr6WUD1fVQak91BnSyLLPCyrc8ectY8lVOUTGO+cU036Q4g
 zJfcaXEu
 0My2PIo9v7hTEQ5/npQc+kiSgqlknzX2W0Dce
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, Jan 20, 2026 at 10:33:45PM +0800, Tianyou Li wrote:
> Encapsulate the mhp_init_memmap_on_memory() and online_pages() into
> online_memory_block_pages(). Thus we can further optimize the
> set_zone_contiguous() to check the whole memory block range, instead
> of check the zone contiguous in separate range.
> 
> Correspondingly, encapsulate the mhp_deinit_memmap_on_memory() and
> offline_pages() into offline_memory_block_pages().
> 
> Tested-by: Yuan Liu <yuan1.liu@intel.com>
> Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> ---
>  drivers/base/memory.c          | 53 ++++++---------------------
>  include/linux/memory_hotplug.h | 18 +++++-----
>  mm/memory_hotplug.c            | 65 +++++++++++++++++++++++++++++++---
>  3 files changed, 80 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 751f248ca4a8..ea4d6fbf34fd 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -246,31 +246,12 @@ static int memory_block_online(struct memory_block *mem)
>  		nr_vmemmap_pages = mem->altmap->free;
>  
>  	mem_hotplug_begin();
> -	if (nr_vmemmap_pages) {
> -		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
> -		if (ret)
> -			goto out;
> -	}
> -
> -	ret = online_pages(start_pfn + nr_vmemmap_pages,
> -			   nr_pages - nr_vmemmap_pages, zone, mem->group);
> -	if (ret) {
> -		if (nr_vmemmap_pages)
> -			mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
> -		goto out;
> -	}
> -
> -	/*
> -	 * Account once onlining succeeded. If the zone was unpopulated, it is
> -	 * now already properly populated.
> -	 */
> -	if (nr_vmemmap_pages)
> -		adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
> -					  nr_vmemmap_pages);
> -
> -	mem->zone = zone;
> -out:
> +	ret = online_memory_block_pages(start_pfn, nr_pages, nr_vmemmap_pages,
> +					zone, mem->group);
> +	if (!ret)
> +		mem->zone = zone;

I think we can move most of memory_block_online() to the new function and
pass struct memory_block to it.
I'd suggest 
	
	int mhp_block_online(struct memory_block *block)

and 

	int mhp_block_offline(struct memory_block *block)

Other than that LGTM.

>  	mem_hotplug_done();
> +
>  	return ret;
>  }
>  

-- 
Sincerely yours,
Mike.

