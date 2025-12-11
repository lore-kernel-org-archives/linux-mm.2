Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A676D3E793
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 05:16:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 415746B0005; Thu, 11 Dec 2025 00:16:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39ECA6B0007; Thu, 11 Dec 2025 00:16:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267C66B0008; Thu, 11 Dec 2025 00:16:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10E346B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:16:15 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56FB25B205
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:16:14 +0000 (UTC)
X-FDA: 84206029068.03.91030C5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 18F8320004
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:16:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EsqaK+b4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QIElUVwL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nBItFmQX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iTBATg1k;
	spf=pass (imf13.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765430172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ers3ixHL8W9DPh68jGWp3T9AioXIVuTQmqnETwRdD1Q=;
	b=4jCF5ANoACzlo4FY09NOIATIgYPGVu3GtkhrK7NZO9WV/pxUkxpbHQgnUkhEwun4i7ULvE
	6ji9GtVm0EFmeEt4t47/p3Tlk779RWlQbMLBahPx8BwJHHkdOQ8NtQD5dWCwDkVRp3xY9G
	ydfJHx1VprDSHUX7cpHehn0E87houhY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765430172; a=rsa-sha256;
	cv=none;
	b=6RdKylRca/Z9EsKEic+VHOFAAdshEw3kiwxNtbc7UIj2bSmc9GP6zD8NyBIq+lnx6OUWMY
	aeTbBn1J4QcCWAuBsoPjN7zIeZN9E6rMtbnnVZ/NLnJZM4F0sShd9oYlNNf7iQjyMHyH5y
	TnSxaBDxWhuBb27246428zahHilrUCk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EsqaK+b4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QIElUVwL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nBItFmQX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iTBATg1k;
	spf=pass (imf13.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4CDA05BD5B;
	Thu, 11 Dec 2025 05:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765430170; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ers3ixHL8W9DPh68jGWp3T9AioXIVuTQmqnETwRdD1Q=;
	b=EsqaK+b4SdN62gbYftoi+D5PvvwkH079hPM+fkU5bw5Ax5L5rkwToEdoinKV8FxG9K7JiK
	oNKIK9C+/PR8QQBR4C27BwRMn/e5MzQO5bPySd3rG8DG+vdCTUtjeeg3r46tIcKcSfuBlD
	dCfhLq+FATW8YrCORtl1cafg874O2TU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765430170;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ers3ixHL8W9DPh68jGWp3T9AioXIVuTQmqnETwRdD1Q=;
	b=QIElUVwLqPS1gNkSQiVhWG76WLcdRnpWy3oGp3AHPxc5pZbbS9LdtPUdi8dtKbrCgJ6wG2
	4V6duAIDR3dzgWCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765430169; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ers3ixHL8W9DPh68jGWp3T9AioXIVuTQmqnETwRdD1Q=;
	b=nBItFmQXDkG8I231s6XiKi6WFRS5w/IGziORPA8VO3x8CHa22zWEJuGPwhqrKeEXTV3OZ7
	9O3OHJOlNVuJag0avAEd5MckEM/jT2cZgf+WSco09nGnEjchh1PsSuwGewKkg7q2tJIcB9
	f3YexrjqfiL1jvZZd/0iZGqiE739/ns=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765430169;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ers3ixHL8W9DPh68jGWp3T9AioXIVuTQmqnETwRdD1Q=;
	b=iTBATg1kQPGtuMhJA+/6oDb5O1fjVJ9WaLVN3D3o5QoCZnlSr3pHOgU5NOKAqb1laHW5oR
	AiSYm09lwYjxF+Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7789A3EA63;
	Thu, 11 Dec 2025 05:16:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id en1PGphTOmnHHAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 11 Dec 2025 05:16:08 +0000
Date: Thu, 11 Dec 2025 06:16:02 +0100
From: Oscar Salvador <osalvador@suse.de>
To: Tianyou Li <tianyou.li@intel.com>
Cc: David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] mm/memory hotplug: fix zone->contiguous always
 false when hotplug
Message-ID: <aTpTkuBkVmcSuiIi@localhost.localdomain>
References: <20251208152544.1150732-1-tianyou.li@intel.com>
 <20251208152544.1150732-3-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208152544.1150732-3-tianyou.li@intel.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 18F8320004
X-Stat-Signature: xn55adzphc9rrzpc5ukqwngsmh38ak1a
X-Rspam-User: 
X-HE-Tag: 1765430171-901837
X-HE-Meta: U2FsdGVkX18ZlHqarsreIc6H1ETBznr6ag/xc8JdMId5micFi02sjVe4fF6oF5wDjioSMHFeKsP2x7xDk/8ZBCeGfXo8ESBxEvsdk7dIv3QiYut1wt+CteL06K+yqPct1Z3YCT27QzgXtskG2djlr7syhZj1hck/YGWrwNVwG5JPBhyLWsYAhg4YDXsaqmZR9jdBLDftIYir25ki/ioehgGAdudvvMcl0cNAYPsjh7Bfi2rzG+G3faJb/g76DwXDOzq3MNLj7pXZ9PDud9qkZEUbo62pXsyISAlrZGBb7Oh/Hmzbg37cx6lI50ELTtd/neWCjG5lMe/XLj9lTk6Xx+DjsqpMG9D9xDwrMnTidm2PZIva7oFEW3DnAG6NYIPBXAkNpV9X6x49oGPIBBQyx1K4avg9lgn2Or1hvUBpDFlkikn6TPwWJsyXRjmphYxmqpaBZO4u22pS9Dwx525VC6J5DzBBwjBNpzl/8ylWkaP4aLwOEBJsKlI7dstptBDk0lsEYvGoGdGYilWn8JFXF7YxTR/hMZRma3mRigoQtoellE0wKwH6mUkE+01TRfWTdu58ek6m4GyyPY44F76UpTIDOMJpJZhDzuhognylB6yTXFwJiWCq77peQfTmZYjr32ruuB1Mo1CqpTziXdzNa8034dshk2NNdwp3/+55Bs2l6Mwmuwdr0pdJGX39j8vQzTDoyfQZImGxFW17iABFi3R4CJYFKc/b3PLwMQV+s5OS8NvVrkQ1jrw3UNBiHvDjhSJLi8VzoairmUSrNN6pOwUgO/G2PGZI/d2a53DrN17XhLNiMHcIjkJaXUf5+XU/+C/ObT0sEM+w/LGKUcTvZ5+u1W/jls4jtZN+I7JaVc3S2G+rTWPqspA8cHA9WgxUJ/EdT5SF+9bbGOunJTjtPlIJSTORGwVJVcMgRpAwv9QH+Vy0uk3kcdAwfNTymhV1XWmoAZZy/2+T6YACd46
 WDTlsMGY
 AUgbb1EErtckaSnoyYqAR/euKGoLBZMtIaGh9B+bxmWNnXCsLVCVGoMGytB81SuBePeoo20l4ujQL+5fdsVFCe5uQBzSOYZntOYXYvBww0+JTr2Jgkv0RuY0gMildR5oaPNi7W0BA3cVqt6e/ibAu1URy+ESvQ8hjZ16Do7kvPpoisySAjBZIW5XWkXfJNwDOQzppx/5kfsQWgGG6CtRlcF3fa7L+DOUWqhgJQkaFd6n/z3I49C/rGF3AJTP2tGqzanY8NpGqq7dgX/rKUwBUuEkMd1lPaS1r24i8i4g3j947CE13fTdCoEA+G5qgZF6tbkLVWyxOs7A9FBfuaqxqoiUrunW/qsmZ4esAcuTvsRTMaE+U2gyFYyLYl5OAlYWzoI/ZWhZLIMuCUQI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025 at 11:25:44PM +0800, Tianyou Li wrote:
> From: Yuan Liu <yuan1.liu@intel.com>
> 
> Function set_zone_contiguous used __pageblock_pfn_to_page to
> check the whole pageblock is in the same zone. One assumption is
> the memory section must online, otherwise the __pageblock_pfn_to_page
> will return NULL, then the set_zone_contiguous will be false.
> When move_pfn_range_to_zone invoked set_zone_contiguous, since the
> memory section did not online, the return value will always be false.

Then, this means that zone->contiguous was always left false on new
memory-hotplug operations, if it was false before?

I guess we did not notice this before because it is just an optimization
so we always took the long road.

Nice catch.

> To fix this issue, we removed the set_zone_contiguous from the
> move_pfn_range_to_zone, and place it after memory section onlined.
> 
> Function remove_pfn_range_from_zone did not have this issue because
> memory section remains online at the time set_zone_contiguous invoked.
> 
> Reviewed-by: Tianyou Li <tianyou.li@intel.com>
> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> ---
>  mm/memory_hotplug.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index d711f6e2c87f..f548d9180415 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -809,8 +809,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>  {
>  	struct pglist_data *pgdat = zone->zone_pgdat;
>  	int nid = pgdat->node_id;
> -	const enum zone_contig_state contiguous_state =
> -		zone_contig_state_after_growing(zone, start_pfn, nr_pages);
> +
>  	clear_zone_contiguous(zone);
>  
>  	if (zone_is_empty(zone))
> @@ -840,8 +839,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>  	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
>  			 MEMINIT_HOTPLUG, altmap, migratetype,
>  			 isolate_pageblock);
> -
> -	set_zone_contiguous(zone, contiguous_state);
>  }
>  
>  struct auto_movable_stats {
> @@ -1150,6 +1147,7 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
>  {
>  	unsigned long end_pfn = pfn + nr_pages;
>  	int ret, i;
> +	enum zone_contig_state contiguous_state = ZONE_CONTIG_NO;
>  
>  	ret = kasan_add_zero_shadow(__va(PFN_PHYS(pfn)), PFN_PHYS(nr_pages));
>  	if (ret)
> @@ -1164,6 +1162,10 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
>  	if (mhp_off_inaccessible)
>  		page_init_poison(pfn_to_page(pfn), sizeof(struct page) * nr_pages);
>  
> +	if (IS_ALIGNED(end_pfn, PAGES_PER_SECTION))
> +		contiguous_state = zone_contig_state_after_growing(zone, pfn,
> +								   nr_pages);

Uhm, I think this deserves a little comment.
I guess that if we are not allocating memmap pages worth of a full
section, we keep it ZONE_CONTIG_NO.

 

-- 
Oscar Salvador
SUSE Labs

