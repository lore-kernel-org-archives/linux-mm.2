Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DC84CFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 10:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980826B009D; Tue,  2 Dec 2025 05:25:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958926B009E; Tue,  2 Dec 2025 05:25:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895406B009F; Tue,  2 Dec 2025 05:25:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8B96B009D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:25:05 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1E1FF59A11
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:25:05 +0000 (UTC)
X-FDA: 84174148170.18.B45DD47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 76E6380005
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:25:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=umoPxODr;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764671103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARoV7/1ETnEwznEz1cD8gvNH3j8fkCCFWwkrvw4Pq4Y=;
	b=FHr18qJhjpX1i4xV7ggeQ6dLk9Bi82/tyDVN15Xul3X1CTP3S8UO2XtBtFvwRaHCZjBAGk
	3TcI/9uiF1AFqp8pAY1owemjJs990wTi0SKx26syNgTZZ/taJgWDW/rc3zTmv9qna/fpSv
	dNlsl9gQNA/aSWecteZ7nFtJGB0wvks=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=umoPxODr;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764671103; a=rsa-sha256;
	cv=none;
	b=3QcCmYseN5GHYyAejXLZDVgQB/O+LOBwxqxQ1tNFeLwqGyIDH7io46b4iih1bOgzJ5A7ng
	mZc+sb6cETUgyYd/Q8QIlXIqrp+z8Obu0DGvayDSJDrALehBVTLMZm4weaWXrMJUZKfVna
	fJ+ypz0q/hK8ppl8kiIYmQR9IP6QPpg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE26460017;
	Tue,  2 Dec 2025 10:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8334C4CEF1;
	Tue,  2 Dec 2025 10:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764671102;
	bh=McMIirB/3kBEvvRZPpsdhilMluP94hMyIECum5e3cYk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=umoPxODriqahmzZI9qf5mBPY/zBtYM6FWwnPvJV2ReErchPj46EIbpDmcHyrm3JIr
	 ovtgUNtZUtD9NHeINj5DHle+vM+/Fii4buhlxY+CYq1NaFfCdGiaU0CPRyAVdcp7sL
	 IKrXoIVcqu/6r0G1toaAImLqHZQwKETCqOnwZN4xXKiPo3O1+RtYg1S86lUocIf6xw
	 JZ86m9iCOfJh3azW+OoPKAFiD6xU8Pm1OrWwJETzO2rR9ikHady6mDPSDL8vDv2Net
	 j1VhEASqR4jAPLfCFgckbLlrPgpwZ8cmgTp16kI+d1RLrrAW6UvWURYn61V2o5uXqd
	 fad3eZ+Ghk+uA==
Message-ID: <2901df56-bf0c-4d08-b043-eca294b981f9@kernel.org>
Date: Tue, 2 Dec 2025 11:24:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when changes pfn range
To: "Li, Tianyou" <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20251201132216.1636924-1-tianyou.li@intel.com>
 <7633c77b-44eb-41f0-9c3a-1e5034b594e3@kernel.org>
 <0d9da08d-4293-4dbd-bf59-999488d73763@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <0d9da08d-4293-4dbd-bf59-999488d73763@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9e6e79isjhh6fynrch8cxxsua13w4edm
X-Rspam-User: 
X-Rspamd-Queue-Id: 76E6380005
X-Rspamd-Server: rspam09
X-HE-Tag: 1764671103-63647
X-HE-Meta: U2FsdGVkX18V0XzRAVLcccAEiUMLUA/UImqU4/budK+1o1YQRMrId3YmpgYLviSL8vE4HOqjfkOF9nW0ktWlGfu/rKCN/vOXo29RonY1cdtiBebZMJ27F7n5iuhls2WSbHtTJ5QL+4qBkFgoAOa2Yy9uRMSBLgKPNGP9iwEO9noWS9ow577HGzGBktGeb5fUci7zN1d1G6umQNOULb37uAqsiLEPT+aaV92yf7XWaPqTcD1BqVnTKbcU27qOqRA6JmO1HGFm4pB/tCnSJ24pIqNkymQPK3ZsYIVCKCyhjfgXrkz+f+JN7NUoU1jBxj53uhC4vv3amQUhJtLnqok+jJ7Aq17Os3RkAMgZIejJCfHGIXjSHI9XzxWPrQa5zljaFTvzpY8/y76ict7+nfwzYtu+ujkoHyRguXtBi/1fsqRuT0o+tziDgfqNwjejDLsCluPJTTAu7vj0/hNFzWkki/sFzh3wF0Fg9tWhG9P+LmrzmLoPye0B/zigO4XPkwRkNA1RivdNXHn4brBAnkIBspgg0f1IC/dg9mX6OsNNH0nYtEIslDybpDjQZ/wbA0EdkUSa4YKKDCC19XZhgaWPIkyBkElD8zbFoz2OhdmLeEzdk0zWlsRGCVf4fzwGbo44Z/0xBOCUlKJQ0sArVUNv11aIEW782j+2FRK68BMgS7d5IfWsZV9xPMnx1F9m3691+EjWFg5M7glNw/PWrOu9EzzPBazYqXINOraREIgO+sXlQYv6GuARW38fW9T58348IHBA3N7MWgS5QAcprfPEhipq42LccaXu3LUNRuC/7IN3kPgsyGL/3LhjajBU+g6t4xp68pClgzDeFGhHJvx0jv4shvILbANAUFzLEv+E17gnML6WH/oaOhEgWIOMVdeO0hmFNspUrzfBhCzYZVHXhwaJp7c/EGE0VJkzsM9PBEsltwLxNns3vpqFkxrZcVxUu+2gQZ9D+9kIpjyGnMr
 DAUqE1qj
 Sa8nUOr7XnpiDA1eqw6zijJEp+rz3ONpEQJEIWBarBovWU4J3qqxgwGYBsmnPwKX0v20kLR7snDw4CsuArVE2IPhJ67/dnc3cCC2LVpJ030fmGjFJOAmgjKTM6C8wudm77pVCPHGWEgTGhQvut6tUxJGhSeVrk7QwK1VzZmmeqeKlfEdnED56r+sLWoHXZ0Wjc+G/cEmHHJ4nYVAyyTKiHsU+Og+JRGAMzZpMP27yVn7KIwxutiBN1mhCVhQFo4AcJQONGT39EvocSQ6RJdqZDNxR3SoRp5UOvqN93fuI1hj+pxtCERUKSXno4stu6jcWl4/KToWTFJh6i7/GdXJkhKfYeJ6P/ome4yU8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> +};
>>
>> I don't like that the defines don't match the enum name (zone_c... vs.
>> CONT... ).
>>
>> Essentially you want a "yes / no / maybe" tristate. I don't think we
>> have an existing type for that, unfortunately.
>>
>> enum zone_contig_state {
>>      ZONE_CONTIG_YES,
>>      ZONE_CONTIG_NO,
>>      ZONE_CONTIG_MAYBE,
>> };
>>
>> Maybe someone reading along has a better idea.
>>
> 
> I agree it's better. Will wait for a day or two to make the change.
> 

Yes, good idea. No needs to rush at this point because the merge window 
just opened up.

> 
>>> +
>>> +void set_zone_contiguous(struct zone *zone, enum
>>> zone_contiguous_state state);
>>>    bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>>>                   unsigned long nr_pages);
>>>    diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>> index 0be83039c3b5..b74e558ce822 100644
>>> --- a/mm/memory_hotplug.c
>>> +++ b/mm/memory_hotplug.c
>>> @@ -544,6 +544,32 @@ static void update_pgdat_span(struct pglist_data
>>> *pgdat)
>>>        pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
>>>    }
>>>    +static enum zone_contiguous_state __meminit
>>> clear_zone_contiguous_for_shrinking(
>>> +        struct zone *zone, unsigned long start_pfn, unsigned long
>>> nr_pages)
>>> +{
>>> +    const unsigned long end_pfn = start_pfn + nr_pages;
>>> +    enum zone_contiguous_state result = CONTIGUOUS_UNDETERMINED;
>>> +
>>> +    /*
>>> +     * If the removed pfn range inside the original zone span, the
>>> contiguous
>>> +     * property is surely false.
>>> +     */
>>> +    if (start_pfn > zone->zone_start_pfn && end_pfn <
>>> zone_end_pfn(zone))
>>> +        result = CONTIGUOUS_DEFINITELY_NOT;
>>> +
>>> +    /*
>>> +     * If the removed pfn range is at the beginning or end of the
>>> +     * original zone span, the contiguous property is preserved when
>>> +     * the original zone is contiguous.
>>> +     */
>>> +    else if (start_pfn == zone->zone_start_pfn || end_pfn ==
>>> zone_end_pfn(zone))
>>> +        result = zone->contiguous ?
>>> +            CONTIGUOUS_DEFINITELY : CONTIGUOUS_UNDETERMINED;
>>> +
>>
>> See my comment below on how to make this readable.
>>
>>> +    clear_zone_contiguous(zone);
>>> +    return result;
>>> +}
>>> +
>>>    void remove_pfn_range_from_zone(struct zone *zone,
>>>                          unsigned long start_pfn,
>>>                          unsigned long nr_pages)
>>> @@ -551,6 +577,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
>>>        const unsigned long end_pfn = start_pfn + nr_pages;
>>>        struct pglist_data *pgdat = zone->zone_pgdat;
>>>        unsigned long pfn, cur_nr_pages;
>>> +    enum zone_contiguous_state contiguous_state =
>>> CONTIGUOUS_UNDETERMINED;
>>>          /* Poison struct pages because they are now uninitialized
>>> again. */
>>>        for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
>>> @@ -571,12 +598,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
>>>        if (zone_is_zone_device(zone))
>>>            return;
>>>    -    clear_zone_contiguous(zone);
>>> +    contiguous_state = clear_zone_contiguous_for_shrinking(
>>> +                zone, start_pfn, nr_pages);
>>
>> Reading this again, I wonder whether it would be nicer to have
>> something like:
>>
>> new_contig_state = zone_contig_state_after_shrinking();
>> clear_zone_contiguous(zone);
>>
>> or sth like that. Similar for the growing case.
>>
> 
> In both shrinking and growing case, separate the clear_zone_contiguous
> from the logic of zone state check, right?

Yes, I think that makes it look a bit nicer.

-- 
Cheers

David

