Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9534DC5AC67
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 03:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C21B6B0100; Sat,  8 Aug 2026 23:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 172DA6B0101; Sat,  8 Aug 2026 23:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062616B0102; Sat,  8 Aug 2026 23:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B68D96B0100
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 23:12:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D1D816046E
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 03:12:11 +0000 (UTC)
X-FDA: 85080257262.27.FD9811A
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id AAD5EA0006
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 03:12:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oZjQfolS;
	spf=pass (imf25.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786245129;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gb4FrJ3xdhpqkyi3C55lynZ/symBerXShmcXNlDSbiM=;
	b=74Zi0ydHMyn3FktkjMtCzbt8lW5xE+fYZiZ8HvTbJPCNtCv2W6kvS6oNs2+A+AeEwgYsJq
	jQncTwAFLJ8UqJdwvgrJxp2sOotCJEjkm1wGVRT2AYtAqy7JUZDF6rGbsB/ibv7aeS8bNn
	X5UbS0aduoneSZdCFKajsdl/grpVeUw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oZjQfolS;
	spf=pass (imf25.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786245129;
	b=yOlmA8HhER6QGMd6AsuuMxzYzjGyu34xHzN2B1CFnI83N4GS+FxjMPyyRpzJqBblw6kFnz
	w9b9OY3qogGSGf4ZMLiubmrrd7sNjUIsi5WCbzjOnMDEqMVqA206keFGOJ2lL/h6dILTUt
	enuOc8a8+lq1jFevjlDCMIEt6wxpXdA=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c2022323c37so99158066b.0
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 20:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786245128; x=1786849928; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:content-type:mime-version:references:reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gb4FrJ3xdhpqkyi3C55lynZ/symBerXShmcXNlDSbiM=;
        b=oZjQfolScyMGlDPo8WaWRHTmDyZET6v5+yaVORGil8xKROZhj3O6jT+sXRtlN3m2Fa
         NQw/1wGOvAnd8cjWfcEHM5dPk8JDvy/5cYH2tKV54c3NXrxT2ORw8mMiHS/uB0HIyqzn
         WD/VVIbQPOMbWbmgdjCH5ic3U54on4O4PKPgfkrZYNNr8p+KsmSiT3PEo8BkGS65GxC0
         D56V5XGjtmRRQaSVjWLnIEfWH9jaDRtWnG7woh9DEfKJUeMmtYQ5BGZ8bMcSgqtubvnv
         c1PHT4DlcbwEpGAQmwEabt55ebUZK6IeUCv8+RGxBJhm5v/IL4cdQswizvEHcREX7oBq
         yaEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786245128; x=1786849928;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:content-type:mime-version:references:reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gb4FrJ3xdhpqkyi3C55lynZ/symBerXShmcXNlDSbiM=;
        b=C3nbmSrAorPphCbBdqE3hAq+ZE+F86SYasAl9Rbcg5385VYdSqOqqL0a69Cel55C8B
         jJ2NZ6F6/vM909AGrwjiXDQhssZUi1cfhkMlh+Q02PDAhENMC9DbEneO9YKCeNPrKiXq
         l3g0jW4RY8Zqxdl0slUOYdkjxRW+h2M0pji0/sipAvx8P1yy7CvUzi0Xys3Gi307fMUA
         W1Veq+y+UaBIJULvAVzrJYYXW/U8le0hAdhMTPTYHF4w4KVREY4gCkv3GtifojnT5wMH
         JssUNUNuxynrJzbVJqgUKyWsGr+C5SM2YDjMt0JTOkdGaCbRGsToDoer/wVSP1nfTZra
         Os6w==
X-Forwarded-Encrypted: i=1; AHgh+Ro+1Qm7QoBDEp1XVlMD6ZzVeWntQ0AbDA7Cstiifcdl2KpKbISTWk8v1Ho5Ttxq62r7UCz4lGGm0Q==@kvack.org
X-Gm-Message-State: AOJu0YyoxmVaWvYW3+xJqULLiOpFGoq3no31CbDahpOsJWaW/yH4BjNl
	hYk7hV2HawIdZlBg3HOF/bXofpHgYfLnrMAMfaevQaAP6CPeezi8V2GR
X-Gm-Gg: AR+sD12/e+YwknkVxAKDbWwDbXjCYI6nigECshgUbbeLtET8HQ6dYKtO0eZEufPo/g8
	HcjPE9khhzHJ2OZJSea1X3Ay/r50bg7duwlnnL1lOdH/d+aujvbSat/rsxkzZqYX3P+l5g8Rk+F
	kSG/YlVhQRQl860D+QPeB+TGxXV+d7csmDwGG6EGUbgvfYHE45wtvSSYcDXWAbxy8j7EEv3v6bC
	0uklnI8ZibyeV1gghOXFATqnzo1FT6ewe/rdmdXWPi2NXVaPg1LB+g6y5OZ6cduM3MCytSVE7Bz
	sBeNCGH7EUZEKK3H3CEovOd9xvLHlSiQ1ZkMUuw7uiugfyd06hR4mOo4xwiKxIHysSXDUIQ1Pab
	X64re+3AXRrHyHrQCYVc5jverg1yIQrHd1prCfzhpTlrfcj7e/Lvxm9+vDx+VTpa6Cn9qeHeS8Q
	dOinNLKGqOwAcNtX7uh3QIjq0IJ/V+UJlni526Scxfz3jFfxsveOQbWqayxsQ=
X-Received: by 2002:a17:907:3c93:b0:c16:769b:9838 with SMTP id a640c23a62f3a-c20731a9d01mr981067166b.5.1786245127750;
        Sat, 08 Aug 2026 20:12:07 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2080cff006sm216562366b.63.2026.08.08.20.12.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 08 Aug 2026 20:12:06 -0700 (PDT)
Date: Sun, 9 Aug 2026 03:12:05 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "Liu, Yuan1" <yuan1.liu@intel.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Zou, Nanhai" <nanhai.zou@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>,
	"Li, Tianyou" <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	"Zeng, Jason" <jason.zeng@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Message-ID: <20260809031205.h6skr3uluj3cnn7t@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-2-yuan1.liu@intel.com>
 <a15107de-ab16-433a-a504-72c3e8dbf2a6@kernel.org>
 <PH7PR11MB6932A554A6D18A4F1A29E90DA3D22@PH7PR11MB6932.namprd11.prod.outlook.com>
 <2cbd42e1-b5bb-474c-b0e7-ce3f46541891@kernel.org>
 <MW4PR11MB6936594CC6B15968AAB781DCA3D22@MW4PR11MB6936.namprd11.prod.outlook.com>
 <0b02ef3e-363f-4b49-a208-54cdfea56c75@kernel.org>
 <MW4PR11MB69363CCE15647FD7D85542B6A3D12@MW4PR11MB6936.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MW4PR11MB69363CCE15647FD7D85542B6A3D12@MW4PR11MB6936.namprd11.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: cz5fm3jd4ifmxoqzgxk9zo4h9eb4ea8q
X-Rspamd-Queue-Id: AAD5EA0006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786245129-299685
X-HE-Meta: U2FsdGVkX19pRIVRqG9BCURXXGW6sbwwU4j+U2wDO7lj7G7HGt7Crou1JsBYPMfLQyPjUoraEhyrFiLV6hB447dBCdb/CmlaQyLXVq1KLKBVe3g9jL/Y2N4jxqNTPYeI9UNRxqmb7xA+TO0Ls1zZlqS9zM59954x9QE7Yelwb9MB6ObYsokMiBvUiQg0gVWE+P7HqUc+0XG5Br67dkQn27t33x1T/8fNL5Lx3rxYOIAOZCajd4+jKklKlw08LB62cJv7ner4ESQRgRsWYEL764N0Fv9X5AL25s8+gg3jwjcQiBEI/dQEA1Al5QXozsKKYQev3bYxjxWcBL7fugz1v5/zYZ/WH3dLx5r7AVYrzenolM5CqAQaWEy1IBui9AwyecjBkPbxnHor+rRP3rW39/CZlsslhdCUGeBwloe9WNiMRXqps4cyumiUvUzRLXXGPfKPSZBol9lNB5Foxur3i+WfzADpfHuW8VKUNOfCAb7V4kMgOUCEkE1DymKWWBRcH1nMZ5WbHQq0HD3ACsZ9tIooUmFq91DrSGWiCe9DTW41hxvLS/0Yq5q7Jt23aVB7ELT9DGtlaTKK1kF1AoKnx6rbcw7W9jC549FWpGfJlfYhuABeL9i3v7HdYs8Fy8hATkycQ2P8/k4NakMIOkY8R2qsxXNjXtoFk33Yz0OkaxWGTAf74mrEmTjSm/3suYUUnPRPKOHD8r/kRQqEiwjuh6kv/WdPqNdkH3hcbphoyAOZsLnplTU92RU/V/A9bibcbOKEEQ6jdchrwZM7qRs46Pck9IWcCAh1UPEpQD+US0IvpacWBzIK9BgkVUaw4Lt3qufSjFEYoJnR39vnVHSrFKj5Peg4Dva8+qEyk8y2F4T/hdJp4AprNe0tgoOig95Id3EAVZS+6I0NGNqoLePr4+tZwVKDvRZZieZcUxodhzElDmHgYgLmGPG1h5nOPPYeoW3iVM2QGdO+7UMb8dr
 +gD+rQme
 iuoKsZG+eTg0vGW5w7AwoqlKQ2AZuyW6bAAJ4W6um/QQmRfQrYE9Uw8rnGlRaQS7rPIbb9EoAeRcNLuRroYDHG1AklAXini+BcpWzz3jgOGIbN7E9mxk5NRAIiIpbOWprfXyoaRKUxy//FlrrOH1Ptv27oiP3JNbjmlpuNXcZUuZ+cK3g/vngYrwyEWF4lZmOFQ/0RbzrkS2RY/cg8Ee7W6hjsIJ4qLqgOXjRKFXzx9adYk3PztqGxVk+GECw82wUMF274o9MdSLVxnKalJVnkrnEt4rsQ7OVGAhTwg1M9c2vb3srUgnX8+RjKVtY98BhbhH5VAK4hJ6S+Jaug8td4aT3OYEBUSvjWyVM9fAGy1NuaYPas19YgwQF/zeE2PuFs0uAVUhqjyAMPmU8QYUsJ+x0rj8lTlRipeMsEwoMhATql33YCj2Z9ZIyp+tbAiQzj3279/Q9MTt8ZYXBziBu6i9+nVpcGojCWpEx1ccoBYEwJrIqhFS3WkH7Xewak+ZjzS3GVEndUm98B8hteCkyUW/PKqqjsuneXpwlHlWp5t7n4VhRuTtPIFPcXxlUoGHzlKwnN/3QEMG5fgNJhuD8Jf2euFFXK+FM4PZRnSbxpU1HyIwiy4TppH/kkZLZMWDzKnUSi6O6Qp2rnfuLEUKYXT76Enf1YKH4KV8KB5P0Eic1GcwEq1vkfr9SUJoU9yjFjdtSawY+lzXiuUe7pMGocaaOkrPbKgm2+Ipgj0OGef1g2rFsR6LjgEC07rWkUfKvSmEVAJYF3kvyslb1Iijaqyw0rW6cLcYdxpNuc62ay7KRCQoqGw9V8zbQatNKBo3oUeHB88MnioRQcAdNW1LotNYXkn2a+5uaoiTYxW3oL94K767JfpWMJPmawZMNZsF6buont1g1wN1AsFTUeVyAKAS3U8VjHOq1onEO/D+DYFc02YE1tFsg0i+svYzF8sOIyOTb18SZv6nwXuL5OdzuGXw4cA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 12:15:42PM +0000, Liu, Yuan1 wrote:
>> -----Original Message-----
>> From: David Hildenbrand (Arm) <david@kernel.org>
>> Sent: Friday, August 7, 2026 7:30 PM
>> To: Liu, Yuan1 <yuan1.liu@intel.com>; Oscar Salvador <osalvador@suse.de>;
>> Mike Rapoport <rppt@kernel.org>; Wei Yang <richard.weiyang@gmail.com>
>> Cc: linux-mm@kvack.org; Zou, Nanhai <nanhai.zou@intel.com>; Deng, Pan
>> <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; Chen Zhang
>> <zhangchen.kidd@jd.com>; Zeng, Jason <jason.zeng@intel.com>; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous
>> check when changing pfn range
>> 
>> On 8/6/26 11:52, Liu, Yuan1 wrote:
>> >> -----Original Message-----
>> >> From: David Hildenbrand (Arm) <david@kernel.org>
>> >> Sent: Thursday, August 6, 2026 4:46 PM
>> >> To: Liu, Yuan1 <yuan1.liu@intel.com>; Oscar Salvador
>> <osalvador@suse.de>;
>> >> Mike Rapoport <rppt@kernel.org>; Wei Yang <richard.weiyang@gmail.com>
>> >> Cc: linux-mm@kvack.org; Zou, Nanhai <nanhai.zou@intel.com>; Deng, Pan
>> >> <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; Chen Zhang
>> >> <zhangchen.kidd@jd.com>; Zeng, Jason <jason.zeng@intel.com>; linux-
>> >> kernel@vger.kernel.org
>> >> Subject: Re: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous
>> >> check when changing pfn range
>> >>
>> >>
>> >>>
>> >>> Will do.
>> >>>
>> >>>
>> >>> pages_with_online_memmap counts all PFNs where pfn_to_online_page() is
>> >>> valid. With CONFIG_SPARSEMEM_VMEMMAP, pfn_section_valid() operates at
>> >>> PAGES_PER_SUBSECTION granularity — when any page in a subsection has
>> >>> memory, the entire subsection is valid/online. So we align to
>> subsection
>> >>> boundaries to include hole pages within partially-populated
>> subsections.
>> >>
>> >> But we must never account exceeding the zone range. So I don't
>> understand
>> >> why we
>> >> would have to care about PAGES_PER_SUBSECTION here at all?
>> >
>> > We never account beyond the zone range, because `sub_start` and
>> > `sub_end` are still clamped to the zone boundaries after the
>> > alignment.
>> >
>> > The subsection alignment is needed for hole PFNs between memblocks
>> > within the zone. These hole PFNs are valid for
>> > `pfn_to_online_page()`, because they sit in a subsection that has
>> > memory, so the whole subsection's memmap is online.
>> >
>> > |----------- zone range -----------|
>> >
>> > +-----------+---------+------------+
>> > + memblock 1|  hole   | memblock 2 |
>> > +-----------+---------+------------+
>> >                ^
>> >                |
>> >                |
>> >      subsection boundary
>> 
>> Right, but init_unavailable_range() can just return how many were actually
>> initalized? Why can't we piggy-back on that?
>> 
>> I think we had something similar previously, why can't we use that?
>> 
>> We know the zone span, so we can just account all the mmap in the zone
>> span
>> that we initialize.
>> 
>> What is the problem with that?
>
>Hi David
>
>My understanding is that init_unavailable_range() initializes all
>PFNs that satisfy pfn_valid(), but not all of them satisfy
>pfn_to_online_page(), since some PFNs belong to subsections that are
>not online.
>
>You previously mentioned:
>
>  pfn_valid() says early sections always have a full memmap, so even invalid
>  subsections have a memmap. pfn_to_online_page() says an invalid subsection
>  cannot be online and its content must be stale. for_each_valid_pfn() follows
>  pfn_valid() semantics, and we use it to initialize memmap that is not going
>  to be online and account it as pages_with_online_memmap, which is wrong.
>
>  The cleanest approach is to avoid allocating memmap for subsections, which
>  also removes the special early-section handling from pfn_valid() and
>  for_each_valid_pfn().
>
>I also share the concerns raised by Sashiko in the analysis below [1]:
>
>  Scanners like isolate_migratepages_block() will then blindly iterate through
>  the pageblock and access the completely uninitialized struct pages of the hole,
>  leading to functional errors or kernel panics when reading these zero-filled
>  structures via macros like PageHuge() or page_zone().
>
>That's why we went with the current approach in v6 instead of your
>earlier suggestion. I'd really appreciate your guidance on which
>direction you think would be more appropriate.
>
>[1] https://sashiko.dev/#/patchset/20260520093457.3719960-1-yuan1.liu%40intel.com
>

Hi, Yuan & David

One thing I found is __pageblock_pfn_to_page() is ambiguous when pageblock
contains 2 subsections.

The subsection size is fixed, which is 2^21=2M. But pageblock is not fixed
size. If !CONFIG_HUGETLB_PAGE && !CONFIG_TRANSPARENT_HUGEPAGE, default
pageblock size is 4K * 2 ^ 10 = 4M, which contains 2 subsection.

For a pageblock in early section, __paeblock_pfn_to_page() result is
different when the hole is at the beginning or at the end.

Like what I did in [1], I punch a hole in Zone Normal with 2M size.

If the hole is at the beginning of the pageblock, the zone is non-contiguous.

  [    0.004079]  memory[0x2]     [0x0000000100000000-0x000000013fffffff], 0x0000000040000000 bytes on node 0 flags: 0x0
  [    0.004080]  memory[0x3]     [0x0000000140200000-0x00000001bfffffff], 0x000000007fe00000 bytes on node 0 flags: 0x0
  
If the hole is at the end of the pageblock, the zone is contiguous.

  [    0.004068]  memory[0x2]     [0x0000000100000000-0x00000001401fffff], 0x0000000040200000 bytes on node 0 flags: 0x0
  [    0.004068]  memory[0x3]     [0x0000000140400000-0x00000001bfffffff], 0x000000007fc00000 bytes on node 0 flags: 0x0

The reason is in __pageblock_pfn_to_page() we have different requirement for
start_pfn and end_pfn.

Hmm... and things would be complicated as pageblock is PAGE based but
subsection is size based. If we have large PAGE_SIZE...

Also when pageblock_pfn_to_page() is introduced in commit 7d49d8868336 ("mm,
compaction: reduce zone checking frequency in the migration scanner"), we
assume there won't be [node0 node1 node0] interleave within a single pageblock.
Would this still stand for large PAGE_SIZE?

[1]: https://lore.kernel.org/all/20260408031615.1831922-1-yuan1.liu@intel.com/T/#u

>Best Regards,
>Liu, Yuan
>
>> Cheers,
>> 
>> David

-- 
Wei Yang
Help you, Help me

