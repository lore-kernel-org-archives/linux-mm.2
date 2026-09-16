Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 793F7C982C4
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6600F6B0088; Wed, 16 Sep 2026 11:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610F26B0099; Wed, 16 Sep 2026 11:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FF636B009E; Wed, 16 Sep 2026 11:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24C046B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:03:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DAA8D1A0774
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:03:43 +0000 (UTC)
X-FDA: 85219944726.05.394F00D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D6C2214001C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:03:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zako6Vpz;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789571022;
	b=19ioycY9ae9JCLcr+gdUsTUPtia0sGOGe2fbPBVHboUlgwVwBJ/OhraQoLuvq0pO87iLip
	j8262+tKV1diNfT02TkmwLurk6Noo0PYGmviUS18K5icMAxaNO9s2JpNbunXwd52NWMeJK
	by9JlxkRZmwwmZ2eTh/domVrI9V7xAo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zako6Vpz;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789571022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KOjRRGLOArHWhTrfAyjhRqsXyXwK0RXqgS/mUFsjbec=;
	b=lp8+qqRwML+Z25K4cWighMLdSDnrW7uotLHuujUNiCdfHcpJHM90CaUR4Xrn0kQDP7Nfs+
	57y7cWILBiB51yTU88cDIBI6faA+icbqT91CoyyxqH3bZW3yTJ7Rq3fLWHsymrDpkEyhYZ
	/0wTgqCEmjCzOQTixWoU7E5dmscdUug=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 06CCD423E1;
	Wed, 16 Sep 2026 15:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2EE1F000FF;
	Wed, 16 Sep 2026 15:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789571020;
	bh=KOjRRGLOArHWhTrfAyjhRqsXyXwK0RXqgS/mUFsjbec=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Zako6Vpz+OVqBBL409INiUuLRc2GtszoD5EUPPH70dsozsEGz+4wuEILq6i+Enu2Q
	 jBgCndSwCSpa6r78kXA5DLPC1WEMNCSDUPz0DYDuYUj4/BQD3Q2HycknHpOJ/aoDlv
	 q8qSq3VGrXV+cnwycrFi5KywOImgAtaCvkzclbHnXmDYqHBEZCh3/E680ay14QSIhY
	 9uKSipF/a9Iemhwh22pY3pr+0h/1od5EgKITFPUCxvCs59wsYRw2v77sbUTkbl271E
	 I0745+lMixVN5y/fHTyoZVRr7DPihyuHlxKf8HtvZWOY2/0CFZO0q2pw/SVXKHIsgX
	 qxKqr42rGlLSA==
Message-ID: <b41603e4-3ec7-4da5-b567-59ff16f93f65@kernel.org>
Date: Wed, 16 Sep 2026 17:03:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] mm/memory_hotplug: panic due to race between compaction and
 memory hot-unplug
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chen Yu <yu.c.chen@intel.com>,
 Jason Zeng <jason.zeng@intel.com>, Vlastimil Babka <vbabka@kernel.org>
References: <20260903095543.3752338-1-yuan1.liu@intel.com>
 <1d625a60-9473-4f48-a384-7d756ccb7135@kernel.org>
 <20260910031609.qbn2qcxzbitau5xc@master>
 <12147238-575e-49ea-aa83-ea25c660ee38@kernel.org>
 <20260912020624.tyu6gwj3tssxfjp3@master>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260912020624.tyu6gwj3tssxfjp3@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D6C2214001C
X-Rspam-User: 
X-Stat-Signature: 9px1zotcaas718m9uokh7k85ouoxz343
X-HE-Tag: 1789571021-703341
X-HE-Meta: U2FsdGVkX18Q5U/Bpl/dblr6eZ0Zq4pngzAzWtqZn0i8ovHGajTQyYCnzkVFzt+WfMtYYe0RMQc1qFu707Gp3dwOE2bmtVvG8V+6QPgWZGk0Xmen7XKvNPs7VtZBoIxHvvjHcVaFCdcN0Wrh6twHqexZmX820u/xFaAEq198O2R/Oqfr8ixqqDXc1eWzDdRUZpuYR+X43n0sVw0IZ8ZZQ8rW9jc+BiOiv0oLN9HWsKr+n6p2Pmzzzpd6upbHRV+UVDKNDWr21E5YmI1d7t31biqhSVoTmZgNV+iNm3rH106QN8s+KRZF96DWMHBCHlUhYfiLpuNGZ/UJmJhkM677atcbhQtOrjtGSM9EQjUfGe1mv22vpZr4wLmYPV9OH5XHLt47L7CClbAM01bboB39WizpU65xHGD2V3p8CCOByWCx9SIGsjLWeHgKwE+Uk3v6qVgbRMd0FNJtGsuDaXXV3ZrgKWiZ6cVVaFYDh/UjgQ/MirwkKubJXSbJ1cpcaGzzeOKIxTo3yMJdOyxodGWSi7qGsgx1JFm1XriaPsMMUG9s+iZnpFJLma7tUnTksQH8RhLqkO2YIBNs1HWObNXvmalgD5MFaCEo5iwo3jTdsoxJ12yZgqlcLgo8BUKk/E/P2T8GEvNYlurSQSJMYRe9PtHZ6QvrRlbXnps2FvtBMttKQjXJEdSPHHgkOc+35/fazji+nIqJxYIIxazct3pMJr54hCgLUW3mgVFLEhxojm9mA4qLwXq8QGZiU+/6sDvPH1cHWQEwKGKx1HVT5/ZRy+fhYTL937Y+5ol29ISFv1XKcM3jQeagoW6KdBP417LmB7r5iezjdAPyuq+cTIOQBvsISZAHxrgUNTG4idaIyZcrtGLf5wLIagi3DSWkdqic+hmMibSlB3/e8YUOQyl40aJROE96duHcKCAGelhYqMYG/IPJ8FUPHad97W4Q5hWVp3Rj1duuAV/PouU0Z/u
 qieiIxeJ
 746CE8ek1fszOTeArseg5j+doWnmNGe4wJeZbpfoyRLswZrhBZZC3sGjZgC4std+G6LNV000g8q2KMWQGWT4DMuOuyDuEW6UEc2yzFja2sbZ7h+0+dNAGnNViANn2DO2TIhvJ4TBOfcyXfFXEXbJAiifhdIxNNErIPbihoV/sZpVPQqrg5LD/sEqEg5ASjbmHvpNfuu91024CIbGGBX5eZGx39nVQ0LMibHtK6hUanLS345n9cwFIkQe6hkkyF6v/lEWo/NxzWS9v9kqRBH81VTTZyUlaX3uvNqy+52pIUzJnhN2Ubaj+q6haeCcB3YZnb3RBgoYEl1HoNx7oBlB4/1zSM9p1JMgNdw2uRUpWb4FMAiSqJSff0vLqmrGmlL/mNC4f8DM9hB22M0Tt0g5dxxXY5FJQFoQM7I04
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/12/26 04:06, Wei Yang wrote:
> On Thu, Sep 10, 2026 at 09:40:32AM +0200, David Hildenbrand (Arm) wrote:
>> On 9/10/26 05:16, Wei Yang wrote:
>>>
>>> Does it mean, the combination of pfn_to_online_page() / PageBuddy(page) is not
>>> safe, when there is hot-remove, even for other users. Not only compaction.
>>
>> There is an inherent race between any
>>
>> pfn_to_online_page() user that then takes a look at the memmap (PageBuddy,
>> whatever).
>>
>> Usually, that's not really relevant, because for things to go terrible wrong
>> (instead of only being slightly suboptimal :) )
>>
>> You have to run both, memory offlining *and* memory removal.
>>
>> For things like
>>
>> page = pfn_to_online_page()
>> if (PageBuddy(page))
>>
>> That's unlikely to hit (no reports), and we could likely easily fix it with the
>> help of RCU.
>>
>> It gets more problematic when we do things like
>>
>> page = pfn_to_online_page()
>> ... do all other kind of stuff
>> if (PageBuddy(page))
>>
>> (what we have here)
>>
> 
> Thanks for the explanation. I still have one confusion.
> 
> What we have here is:
> 
> isolate_freepages(cc)
>     page = pageblock_pfn_to_page()
>         if (zone->contiguous)
> 	    return pfn_to_page(pfn)
>         return __pageblock_pfn_to_page()
>             start_page = pfn_to_online_page()                       (1)
>             ... check page_zone(start_page) and page_zone_id()
>             return start_page
>     suitable_migration_target(cc, page)
>         if (PageBuddy(page))                                        (2)
> 
> It looks the extra stuff between (1) and (2) is trivial and they still rely on
> page struct. 

Right, on that path there is indeed not a lot happening.

> 
> Do you think it could be caused by the data synchronization between CPUs?
> 
> Two possible points:
> 
>   a) zone->contiguous
>   b) section_mem_map's SECTION_IS_ONLINE bit

Hm, not sure. Given that we run in a VM, we might just be pausing one VCPU for a
bit longer and be able to trigger this :(

On the bright side, *maybe* RCU could be used to sync here. Well, we really have
to isolate the page to stop offlining to just make progress by taking the free
page ...


-- 
Cheers,

David

