Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08AC9ED7B97
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 02:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 736756B0089; Tue, 14 Apr 2026 22:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E7E06B0093; Tue, 14 Apr 2026 22:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6243B6B0095; Tue, 14 Apr 2026 22:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 561A36B0089
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 22:30:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 181021A02BA
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:30:21 +0000 (UTC)
X-FDA: 84659211042.30.297C426
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0C9BE40008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:30:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nM0gxUcG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776220219; a=rsa-sha256;
	cv=none;
	b=w5YF0OI8dOgCgJKEkk28MqtFQx/pUr8jmB7EjSQcRJlraxNFXPmPuOyTQKEZnMg+zxfVaU
	6ZV/uSCqF+PUgG9nAat8Vfk03yeGPz+tuj11WBK4J5+XfYCtU7xxpb+a0jdC7NS5LhcSVj
	G1PQW/PeNGRc0bzPd3AdHFTFo8USiRA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nM0gxUcG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776220219;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=StC25PVDWT8M7W9NSgY17XCq6J9v4q/RTTNrlPmFksY=;
	b=lwzDdW2lt0TljxIK5g83UM8xWD3wYzm81VB0gj62PpCR0R7WKH9+3NSCTn8UKcXafF+n3y
	hZepOgzuIRW5/ANY+O5URwU32azMHevP2AbnoEeABk0HAomDns1/pXWho/26swzkpsCToZ
	kbRCpXupDVYMZ/NeFTlqpYvzv29HvX8=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-671ff4b716cso2166537a12.1
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 19:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776220217; x=1776825017; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=StC25PVDWT8M7W9NSgY17XCq6J9v4q/RTTNrlPmFksY=;
        b=nM0gxUcGJGh/7gnK87EpaicAKGU6aSz4etEwWaISmV3yo+QNr1wvqF5HXX1+PwoTt8
         5UEYi4F2w2UoUDYucZLqKQusqayccIM1H8R/gzagOjftMhugwr5SvpHXHJh5s4ARv8YF
         uU/M80HaMsDsuC696Ue0fIHaW6oJxazH7ocUo20y4CCkdL/mMmXs8CQ3GUkeUzHqLYrY
         NhhCuraou+5zje3xvQRUAYI+Qy7oAOzVGAESj9VLwtjkZuVGU3wFJlwhufUSLYXQvESV
         IsLFbfXvGdmMFv9MWL5PJyIZg16t2O/gGaCi4z0hxYDoxTy2ghZ28EhVE8wWr5qhRfJI
         cxKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776220217; x=1776825017;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=StC25PVDWT8M7W9NSgY17XCq6J9v4q/RTTNrlPmFksY=;
        b=crCQ5g8H2Wvz5HQ1Vgbr0nxgt88B1HjtAVUJ03weiBzrIq1vw3G0cJjcYwlWd31V7N
         8L5VFuO78z7c2iceOH6JQgS2o549INRrneA6Dq3+7hj1mi446ZyH8nbEVJWUQVgMtWAs
         RBzJRiJ+qla2XCxuXMDsbdoLcqJa0YbWtNPhorQTqrpAhY1bBR8g+0Vg1Oc2cdVqEQtq
         MqRwQ2azWzI6FnWilNcrO5X3fLDQHqSzc8CZjtp3PpG3EMZApDVCtxsfQu8FPi6bzrtO
         ZP8lvbgldxOTZjdrBuOES20Oe9ebNT0myvSzc6V0j0paCaxFI/6Y4xOP26B7ugTRpoBC
         4sMQ==
X-Forwarded-Encrypted: i=1; AFNElJ+uoljMeDb1O7eymnyzJwrcu6CMFo5fHiUvZbrkfRUHtLHHOhBVqGt7aOGO3FL2+KKlGeBwlgcXgQ==@kvack.org
X-Gm-Message-State: AOJu0YzbGV1QwCOR7oHhddf7kxh9vE9UmPOAnDSuZf2x2dh0UlJza+Y5
	qhuwRMU9cbtmVTJl/sAttRBaoyIFQkAGoTOFklPr1j1kKXnfAj2NYbB6
X-Gm-Gg: AeBDieseQD1/+ZaugM+Ir6FrzXMExyKnd3ICuTqWE7XXxyrO6FivGI4ZM2CeOYsyEUO
	/tGKLBESHESTARFtuqDUQO3jbi8/V7Ve2Sajv+wutObG1XWQZsEGFPdDRqvJFnkRpH5AQHw3yCl
	Yc1t2mN0R63DqMkrYdPB7sy+CQAk47BhiFdYAQbFu/Z6YjE7mfzRGxlBf1q/URKjtEyS8+jmj7b
	DLCFYVAA+VNsGS0z7x2jsoqIrEPCcVWEsSm0Qh8DpfkvOrY74VjjaCMHaeUp3JUuzhMxoRWKRZD
	ajV7BJg+wjqK73zydgJ4bpqUdC8wc/f6nIQBeOJjeY1BXRdPiMGoa28o/wjGxodEQEqX+9+GICx
	5Rq7iyduN0prfN1jZdfbu10SnYVYEBa+ehaZtWHkfmnc7rqwGoWVJWmK4igSNgHXCrQz/MKdCY7
	vcUE1lmt6cfI7j+GhXOooP7AABeLCHX3V+
X-Received: by 2002:a17:907:25cc:b0:b9c:aae6:907e with SMTP id a640c23a62f3a-b9d7260da0emr1116420366b.13.1776220217053;
        Tue, 14 Apr 2026 19:30:17 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba1784a808fsm7816466b.61.2026.04.14.19.30.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Apr 2026 19:30:15 -0700 (PDT)
Date: Wed, 15 Apr 2026 02:30:15 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, Yuan Liu <yuan1.liu@intel.com>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
	Nanhai Zou <nanhai.zou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Message-ID: <20260415023015.5i7hrixrk64uzjqj@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
 <20260413130633.knzkliyqvjhuz2kd@master>
 <1928b6b0-2ec3-43ca-a41b-e880d974af04@kernel.org>
 <20260414021219.wayysugpfbzirzh6@master>
 <fd59736d-a02a-4693-9e70-23c593c9dac7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd59736d-a02a-4693-9e70-23c593c9dac7@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0C9BE40008
X-Stat-Signature: 13ndhn15t96a5emhep5m5ukwx978qfnj
X-HE-Tag: 1776220218-387822
X-HE-Meta: U2FsdGVkX18frLIrbaSEg9bF6dyvkLBJyT3ytf6bKZw2j4S7vDS4sg92ExqCZpEgHuKuIVicx1I0jL1QQZg538Ij2dG4pgC+IvrgSd51uDfgH5hM+Pb9FpGsmeXPjwPYUrXRnXpz7DwGzmEBwMBEcrrtvr23V1qjro/t2OwmV1NNQBVmuRFU09JxN/bsrI7TeEAqGSdiuKGgGgutrhWtvplvwqeihyLD+vgCq0EarlQYFZJkJ+tKAmagidoXWBZFYj/qo2l+hpllHlneeFg1tbkODlVZxfsZOlViosSYRZY9jneTU3ulgYyqhM+yuZkHH1uiHMJnaqKCuyw8MYYAxCMeXzTZ1hmZfh4/rGPLgHCM6HK1X2hJ9nQmc/01NEWgF6nGP1SvU5O2QHAWOCNOsv32D630F34FMIMK0R6jKvy4kB8XJtH+nr8rlVm2gRprWxVsDjxTIMCZMqSv1nYAXteBV5sKMV5qXSIkgoURu28veDc9Db8mjXKc4QbExUCRp74DNRSDLF4M2MT4IC+KVx9LCMnMDWD18NEi5w424bUSHVwlslN/5cT4eCgiloCdE3rRB7y+3fvVQ5gWprVvMh943eIMHNkp/lpjfiB+LT2ScuWXouV6pHZRlnExOXeBAMurn7CvhRPADMRK6fTZvHEyw/ebqp51wtoTjiwVAThbxUqfRcvXGpC8G3gQf8T4CvHAQpjaba1MIBvYoISrYbpIVRPrio0qyRm+r32gk3MTU5/IzVV5rVaJ8VI5wLzN6EI7ifEmgi9G/lzEYceJOD51CAekPvgVrQVbWKXaYDi1moK+DcV7trcBtwdFshszWyhiGVW/Dzzpim3+SimkMthk/KTF0a090QRemGDcdMN2cUPdVhont1X2lsjzEjTLylrmwns18AWIV+mmd2XXMZf/57GU66gVwxn77TJ3LZDTV4F683fBRfTr1i1znQXgOL7QjfpvOJ+y9mpaQ5+
 xUy+2ZHm
 +zBGj5O/MXSOK5gX65y4Dn8CQr9gZDz7p/pbV4Za/XGMxveKhu7TQuNFTS5EvjjzU+I+DjVwZXr4r3F3x8said8ujAHzh4zq8f/ivtXdJydeJZYIrBqwBj4fqahTcIJG7pnUE2Z2INN9e6x65JH6AUx6WsknIZ7K54YrF0uJBVs0fSGGdqs4nzRKN0qIrdq845CXv4oVNg8lNI9SOuZ3dytDddJ/+V/RvqY3s421u3GdjPrNHsPQ3llvspf5DRc2hVCaHCAV0T55k523pVUZZRwxeyXYA7N3pcnGC4BEiwAmhTcBSFGNS51vANn5ptzIxsvyPFSvtRHPoDJB8HKtfXKqS1pYBvYStj5+/bYZlrQJCZTdzChP9HfFda4/JWTawa3tJMh26ywJs1I9veHwR1yuv4QNDua+ejfsiyvgJOnR/3GTK6jrGWyCD0V6fhKvdbwh9EmoO8z1d4yWkbOivwbQ753lNxSbcZdr/f7KR5kRt2TqWnTQwV4+bLTRNJGoE8zjsvdeivayxyWdsFrlVnBLsS4ci9rjA9v3xqXpuSNB4vQ86NW8gUqbb7nWN+n26uZUP7bfWi7YNavM7dMhvew8mlw5B+9QwqDRQiMIOcwuyo/jm+SZN1kmUQXXQONa17s15OQyMD9d6aFXCmThGBCcuNfkBKBdqpBFCTZ/FmgkYGmea7mFlZZIZJ/p7+52X4xe3yDfA5OLlhhfeXgyLQwcXcZoIynXc5L3tl7Ou7K2069A1J72pflXfT5L+oVE1wO2zgA8rE0BaAns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 11:32:13AM +0200, David Hildenbrand (Arm) wrote:
>On 4/14/26 04:12, Wei Yang wrote:
>> On Mon, Apr 13, 2026 at 08:24:05PM +0200, David Hildenbrand (Arm) wrote:
>>>>   With the last memblock region fits in Node 1 Zone Normal. 
>>>>
>>>>   Then I punch a hole in this region with 2M(subsection) size with following
>>>>   change, to mimic there is a hole in memory range:
>>>>
>>>>     @@ -1372,5 +1372,8 @@ __init void e820__memblock_setup(void)
>>>>             /* Throw away partial pages: */
>>>>             memblock_trim_memory(PAGE_SIZE);
>>>>      
>>>>     +       memblock_remove(0x140000000, 0x200000);
>>>>     +
>>>>             memblock_dump_all();
>>>>      }
>>>>     
>>>>   Then the memblock dump shows:
>>>>
>>>>      MEMBLOCK configuration:
>>>>       memory size = 0x000000017fd7dc00 reserved size = 0x0000000005a97 9c2
>>>>       memory.cnt  = 0x4
>>>>       memory[0x0]     [0x0000000000001000-0x000000000009efff], 0x000000000009e000 bytes on node 0 flags: 0x0
>>>>       memory[0x1]     [0x0000000000100000-0x00000000bffdefff], 0x00000000bfedf000 bytes on node 0 flags: 0x0
>>>>   +-  memory[0x2]     [0x0000000100000000-0x000000013fffffff], 0x0000000040000000 bytes on node 1 flags: 0x0
>>>>   +-  memory[0x3]     [0x0000000140200000-0x00000001bfffffff], 0x000000007fe00000 bytes on node 1 flags: 0x0
>>>>
>>>>   We can see the original one memblock region is divided into two, with a hole
>>>>   of 2M in the middle.
>>>
>>> Yes, that makes sense.
>>>
>>>>
>>>>   Not sure this is a reasonable mimic of memory hole. Also I tried to
>>>>   punch a larger hole, e.g. 10M, still see the behavioral change.
>>>>
>>>> The /proc/zoneinfo result:
>>>>
>>>>     w/o patch
>>>>
>>>>     Node 1, zone   Normal
>>>>       pages free     469271
>>>>             boost    0
>>>>             min      8567
>>>>             low      10708
>>>>             high     12849
>>>>             promo    14990
>>>>             spanned  786432
>>>>             present  785920
>>>>             contigu  0           <--- zone is non-contiguous
>>>>             managed  766024
>>>>             cma      0
>>>>     
>>>>     with patch
>>>>
>>>>     Node 1, zone   Normal
>>>>       pages free     121098
>>>>             boost    0
>>>>             min      8665
>>>>             low      10831
>>>>             high     12997
>>>>             promo    15163
>>>>             spanned  786432
>>>>             present  785920
>>>>             contigu  1           <--- zone is contiguous
>>>>             managed  773041
>>>>             cma      0
>>>>
>>>>   This shows we treat Node 1 Zone Normal as non-contiguous before, but treat
>>>>   it a contiguous zone after this patch.
>>>>
>>>> Reason:
>>>>
>>>>   set_zone_contiguous()
>>>>       __pageblock_pfn_to_page()
>>>>           pfn_to_online_page()
>>>> 	      pfn_section_valid() <--- check subsection
>>>>
>>>>   When SPARSEMEM_VMEMMEP is set, pfn_section_valid() checks subsection bit to
>>>>   decide if it is valid. For a hole, the corresponding bit is not set. So it
>>>>   is non-contiguous before the patch.
>>>>
>>>>   After this patch, the memory map in this hole also contributes to
>>>>   pages_with_online_memmap, so it is treated as contiguous.
>>>
>>> That means that mm init code actually initialized a memmap, so there is
>>> a memmap there that is properly initialized?
>>>
>>> So init_unavailable_range()->for_each_valid_pfn() processed these
>>> sub-section holes I guess.
>>>
>> 
>> Yes, I think so.
>> 
>> When memmap_init()->for_each_mem_pfn_range() iterate on the last memblock
>> region, init_unavailable_range() will init the hole.
>> 
>>> subsection_map_init() takes care of initializing the subsections. That
>>> happens before memmap_init() in free_area_init().
>>>
>> 
>> Yes. I guess you mean sparse_init_subsection_map().
>> 
>>> Is there a problem in for_each_valid_pfn()?
>>>
>>> And I think there is in first_valid_pfn:
>>>
>> 
>> You mean there is a problem in first_valid_pfn?
>
>That is my theory.
>
>> 
>>> 	if (valid_section(ms) &&
>>> 	    (early_section(ms) || pfn_section_first_valid(ms, &pfn))) {
>>> 		rcu_read_unlock_sched();
>>> 		return pfn;
>>> 	}
>>>
>>> The PFN is valid, but we actually care about whether it will be online.
>>> So likely, we should skip over sub-sections here also for early sections
>>> (even though the memmap exist, nobody should be looking at it, just like
>>> for an offline memory section).
>>>
>> 
>> And it should be like below?
>> 
>> 	if (valid_section(ms) &&
>> 	    pfn_section_first_valid(ms, &pfn)) {
>> 		rcu_read_unlock_sched();
>> 		return pfn;
>> 	}
>
>Probably, yes. We have to understand if other users would be negatively
>affected.
>
>> 
>> IIUC, this would skip hole and leave allocated memory map uninitialized. And
>> then those pages won't contribute to pages_with_online_memmap, which further
>> leave the zone non-contiguous.
>
>Yes.
>
>> 
>> But we want zone to be contiguous when we have a hole like this, right?
>
>Not if a subsection is marked invalid. That's why the existing scenario
>is that it will not be contiguous.
>

Let me try to understand.

During previous discussion[1], we want to define "zone->contiguous guarantee
pfn_to_page() is valid on the complete zone". So this definition is not true
now, since we found the behavioral change.

Because __pageblock_pfn_to_page() won't treat range with hole as contiguous,
detected by pfn_to_online_page() on invalid subsection.

[1]: https://lkml.org/lkml/2026/2/9/550

Now you are thinking the problem is in the iteration function,
for_each_valid_pfn(), used in init_unavaiable_range(). It should only take
valid subsections into consideration, even for early sections.

So your concern is if we change first_valid_pfn(), it will affect other users.

If the above understanding is correct, maybe we can use spanned == present
to do the trick? Because holes are marked subsection invalid and holes are
counted into absent.

But I see the mirrored_kernel thing, not fully understand yet. This is the
reason to prevent spanned == present approach?

>Note that Wei reported that it was not contiguous but would now be
>contiguous.
>
>
>If you have a DAX device the plugs into that hole through
>memremap_pages()->pagemap_range(), I think this could cause problems. I
>doubt that this would happen in practice for such small holes, but if
>they would be bigger, or at the start/end of the range, it could be
>problematic.
>

Not fully understand yet, will take a look into it.

>-- 
>Cheers,
>
>David

-- 
Wei Yang
Help you, Help me

