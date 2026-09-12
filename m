Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 991DFC88E50
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 02:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8757B6B0088; Fri, 11 Sep 2026 22:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82DFE6B008C; Fri, 11 Sep 2026 22:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 714F76B0092; Fri, 11 Sep 2026 22:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41B886B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 22:06:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB3151A0412
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 02:06:29 +0000 (UTC)
X-FDA: 85203470898.12.1055B9A
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id EA44A100002
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 02:06:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VfxXht8K;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789178787;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XjLvs9IRvdKtutQQVUqHinOZTztdopsuXZK8dx8qcRk=;
	b=UYjHUZp//M8cRwX0AZhz5QiIF5QDrJ/pEMx5riLeHPbwKd6Vh8VSKOV64diX3Gu0ZZydfW
	uahTFnB62p5ZPgYbcOCIMHLKS2O6o8j+50iqZR2+76wBxI5tgWTGN69LwnR/3Gy3CCW79O
	H+9P+8Ew0VcLV+hVKvYe7p83h5xkREE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789178787;
	b=ha+fww1rCxg/VdqNIhI1/RF3OvbxS0m3/bMq5qooe6iD0U3rlKmi0W7SeEEjl2W4LLXdvq
	rnjzy9UpVqTq3KPBigDLB2hl+B++Av7vlfcTx/r4PkG2m+KsU/VPK1VvxzO6mbg4dzb6cm
	xAepYdZUafQN61OqMbIZxKNYQmaDVwI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VfxXht8K;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c2946dc8dbfso229474566b.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789178786; x=1789783586; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XjLvs9IRvdKtutQQVUqHinOZTztdopsuXZK8dx8qcRk=;
        b=VfxXht8K5pk3fF2FmPw5PDz5CX3am7iL5mykrsUjP+EOftqyLIEbZMOqKJy90IpvG1
         wpeGV2DrFZ2EjIXNzKFKIR3eYw+JF/BWOLPNsP1mvBFkz2DgIMyP9jBqWWyC1Z5xdRns
         hw75UCGu8eLRDCrENu9DKppI+osWFZnSCbWpM7CKmv2wgfsrPjNW9hIRgyvFT2XAzG4/
         AfXriGXu1G024WtwmNs80d6fbuDAJRpwRLxEyMg+U4LFHIFdJrwDduXs3Nj0upeeDWZM
         72o8gC3CLsjpsjtfhSVleE4puO1x8MgoU8jtBRdkNKWuy9lthyJ0jqMNvlylxeHEMa2Z
         skLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789178786; x=1789783586;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XjLvs9IRvdKtutQQVUqHinOZTztdopsuXZK8dx8qcRk=;
        b=oJHf2U2lEA8d+iu8Rr9GhWH5H7aJntKlKDwia+83dChpPFlfCWkp9bfqT3vje8qzIu
         08T31cAdNS/HgbQj1boxxqZxkQXz4OROAwuFbZKIg5/aYx9SccpDwQQzeM8FiijFR1AM
         dTSBOk5DG4E6p2E1z8fmUK+VBbXo9lqRgzoitNyKarM0UO3F7ZKdaEO+/i8ysQsvhF9Z
         P8ioYIm0mVyMTt0uNr90GdCkcj9zMdJxTltFsCGFz7Cq7DaOnMFeKaLw/A48HvGbDp4e
         jPNXX7o9afJtLaKl0P3ZYkyrwIqBLfW3AE3XvBk2GjVe8yz6AU8914UoRH7ukw/x1Pwx
         jHKw==
X-Forwarded-Encrypted: i=1; AKwUvBzl5IQDJwm4L5e5aOO9/JWkkAHBRTgnumMWJYN1/9Z5fyWqv0eliP/LOkuzb+u1GCUAXfA2IXoQzg==@kvack.org
X-Gm-Message-State: AFuF++kNpEZd/1aTiOxxXs15iLrrRJBvugQE/NDHA8i65wAV3Hgs6opZ
	yYez+HdYcoDZb48WOewKgBvynWUWkv6GctGLTYGl8jtF+Y3a0brTK6bM
X-Gm-Gg: AYBFou0U9+mZQCEW6o9yjGHqdEZowM5Ocvv1ymgqmdKot4fNOSyi+6E7bwQ8+4HjABl
	A+e6WG9PY5NUTyts22Hh9qgxcvMSm4uySLCiQHMAKwddJiYfBeWXp0V6tDuBLrr+f3VM6SDDlDD
	hsP80Kb0bJ8Het77fQawAJQOxkqwLle4QXPL+SJ09KgQRs+JdOzwM2osO/eKXFko3L5gPCkBYJR
	v2BR4nhYi+XtODoaUMwfFP4Oh7vSfrKHZb9gBDci0GX5PBenceyiOzY0ioPkDgs3VQk9ffqPKWU
	JxKpuTXpYvDtFyguUTWeEFC6XY8/g9wAJh5Q1IiuE16L7kjfT+DSkLGLnVZTrlsWogzmQ470+up
	zIw8q2mBuQ94ts0l9X/8axlW01grfqRxgovd0lUjGJ3XKyxk3USavy+V5yF+Skw41EhfyBYwjn/
	FkYLdNi+TF1Ky8Sw1+fSWILtOzn+6kustZGCaAdX81lkoT8IJ3bu1qYKi5e242y1w0ReaxZEDRI
	SIRUaRh
X-Received: by 2002:a17:907:3f17:b0:c29:4970:abec with SMTP id a640c23a62f3a-c29665d8281mr318676066b.19.1789178786176;
        Fri, 11 Sep 2026 19:06:26 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c29660b29a7sm146651466b.43.2026.09.11.19.06.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Sep 2026 19:06:24 -0700 (PDT)
Date: Sat, 12 Sep 2026 02:06:24 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, Yuan Liu <yuan1.liu@intel.com>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Chen Yu <yu.c.chen@intel.com>, Jason Zeng <jason.zeng@intel.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [BUG] mm/memory_hotplug: panic due to race between compaction
 and memory hot-unplug
Message-ID: <20260912020624.tyu6gwj3tssxfjp3@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260903095543.3752338-1-yuan1.liu@intel.com>
 <1d625a60-9473-4f48-a384-7d756ccb7135@kernel.org>
 <20260910031609.qbn2qcxzbitau5xc@master>
 <12147238-575e-49ea-aa83-ea25c660ee38@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12147238-575e-49ea-aa83-ea25c660ee38@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: zx7nq11xrp3d6gww6yk1uhhi37x111uu
X-Rspam-User: 
X-Rspamd-Queue-Id: EA44A100002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789178787-40504
X-HE-Meta: U2FsdGVkX1+ntGCCv+xoTLkwg01UmiZEnpCVdDITDBSSHedvoFQRQ3fMhmEPdLzhpBeuSpaPIAnsv2rizPQpcVqhUM/ZvNRomusBtW6ZsKA6OuLUSBeDa+SaukPNaF482jV/e2Uujhoy9htKUHTmOR6DQxDxcl9IQ3x9xtGInrh1CDYWDevsJEY//SoDcklNhEzBMFItOoBHfbTzT/VMxmckyjBiOCRE3wB/wwlpp9lMO89yGvOLYqhf51gsYb7gj8aqziovLzDQUUsARostW9uBTng+pLiMX8tMBI2Ga12ym3rsPErgFyzPwc6AJ2ZYDePR46Fv+AUHtP7OOjY4gnY7r/Oqv6eWg93VrgySCTBXVd2UQQTB2qHbvYgRa46WO+Vb6DKm9q8yBAB7KYcyhD3rMlVd3CdMVd5jyPeLVq9WB4sJjc2GVcHKk6hkxx2PBvCzH6cAOUG79ThK4WduoY4+Fv0n3+YQeZQbm4MZ2XKxG2kZ98eQg9kSwPgvfe6s4WZA/mDvSIIPqcZnx4GL67lvbnwLBD0lNLSwzwYjerrGv/e61bbzudZ+bSio+W7uIrvR3wBR2Y25LPZntOsAEdvZ/efbb/6/Ljk2aOxGoiC/2Ll6rH33WSof/T/Ejcn9cAhKEGCJk40K18FJcRJA1fYCxo95FHOYwlPoT2xfzJ5iwnl4bP8tOxOtZcrgBb8PRVE508XatvLBfXick3D8kWeryr6M7DNeigA0s/X3B/VOfnO9vFRqjR2iURBpbwllu1OuDQ/vsD9YldWzquLGnsKx6O/w8YBDjfMWdb+P72iBCr7oVVhB+tym1xQy3d36JMF64e7uYj8G4YP/GQmKRbfLkrqtsfidn1dblEUMrDb3TbSbyP9fJtK1xcao+e6SnGEmfm6vA/iwYq41vPG9Rglhjcwsh5cnXZ9DVwBloanofwyMzPyXOPNLBQod2HYtiq6TtAh/56irRXOdBWe
 lXKNPyY9
 OYAjUABbrNWVyy5nS+lwSM2mSdCWud4nWmbEOgXLQM2L5B6gxUeDVii2uokU5ZOGF4/VVmdebefvjqnfQG4oWJyktn/bjaYkZe1vdK2DGtbtTBPMicLGJCBkROJyjSSHKXwSoqz7EXp51uZaSWvbwP1j1zY/mds+7tfoA9QsB2M3sTZ8dJsp+s0sTX8V3Q5e6FClc/0CXiZQqgVD4yjAmkIkBaPkzm+nA6XitdJqqGAJX9FTb0xG8ukMelfP1P4uSRQleNInJm5uJgogK2hgJT1LcRtxzMfHyM4e7wKyjg+WaS8ZJUREyKudv3YMpEtaBntSKhRlIL2aE9eU/6+H/srF+1w35AZNRpgF7moGlrAyCoabc7A6N9Z2aAukTsPXze1mgiXJ+8H8KO26srXPvnxHXdYIhoLO4OM1gehCrlOe5mxg5RRN54JoUSP+RDW+cIc16GZj+x2TGiaJYgSf1uy98A/BFCzWI9sumleEZ400ea7T+jHp6cmTpeunbLwseIJeJrkjAtrSosSSNykuc84vapmYllyaIbIiYcJPy7zpYPoboPEjlsYvi9IAea+hWFSD7OORC3sm1BsC5AylywPRec6inb6yO4/UE4K6q7Ilk2kNh3bgxTFHmeGau/EkEPRTmR1fuFKkVFeBwHr2LALBSuwXnRv4VbWIVpuR1TR32Rq5aYvyU8ZAdXviGR9eqK1eJFu+NqgGfgoyjHF/LiZduH+0bVHXTBL08kibftTXiTxPagZpjVA0B7J3IL3sqRZDT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 09:40:32AM +0200, David Hildenbrand (Arm) wrote:
>On 9/10/26 05:16, Wei Yang wrote:
>> On Mon, Sep 07, 2026 at 04:27:50PM +0200, David Hildenbrand (Arm) wrote:
>>> On 9/3/26 11:55, Yuan Liu wrote:
>>>> Hi all,
>>>
>>> Hi!
>>>
>>>>
>>>> While stress testing memory hotplug on a VM guest running an
>>>> unmodified vanilla mainline kernel (7.3.0-rc1, as reported by
>>>> uname -r), we hit a kernel panic in the guest when memory
>>>> hot-unplug runs concurrently with memory compaction.
>>>>
>>>> The kernel was built from mainline at commit:
>>>>
>>>>     cee9395acd80 ("Linux 7.3-rc1")
>>>>
>>>> To be more specific, after a large virtio-mem hot-unplug, the guest
>>>> kernel takes a fatal page fault in suitable_migration_target(), called
>>>> from isolate_freepages() during compaction.
>>>
>>> Sounds like a real problem we should tackle.
>>>
>>>>
>>>> We are not sure whether this race is reachable under realistic
>>>> workloads or only under this synthetic stress test. Sharing it here
>>>> in case it is useful, and in case this is already a known issue.
>>>> Thanks.
>>>>
>>>>
>>>> Call trace (top to bottom)
>>>> ==========================
>>>> - RIP: suitable_migration_target+0x5/0x70
>>>>    isolate_freepages() <- compaction_alloc() <-
>>>>    migrate_pages() <- compact_zone() <- compact_node() <-
>>>>    sysctl_compaction_handler().
>>>>
>>>>
>>>> Why the race happens
>>>> ====================
>>>> CPU0 (compaction free-scanner)          CPU1 (virtio-mem hot-unplug)
>>>> ----                                    ----
>>>> page = pageblock_pfn_to_page()
>>>>    /* checks pass, section ONLINE */
>>>>    /* returns valid struct page* */
>>>>
>>>>                                          offline_pages()
>>>>                                            /* section -> offline */
>>>>                                          __remove_pages()
>>>>                                            vmemmap_free()
>>>>                                            /* struct page UNMAPPED */
>>>>
>>>> suitable_migration_target(page)
>>>>    PageBuddy(page)
>>>>      read page->page_type
>>>>      *** not-present fault -> panic ***
>>>>
>> 
>> Does it mean, the combination of pfn_to_online_page() / PageBuddy(page) is not
>> safe, when there is hot-remove, even for other users. Not only compaction.
>
>There is an inherent race between any
>
>pfn_to_online_page() user that then takes a look at the memmap (PageBuddy,
>whatever).
>
>Usually, that's not really relevant, because for things to go terrible wrong
>(instead of only being slightly suboptimal :) )
>
>You have to run both, memory offlining *and* memory removal.
>
>For things like
>
>page = pfn_to_online_page()
>if (PageBuddy(page))
>
>That's unlikely to hit (no reports), and we could likely easily fix it with the
>help of RCU.
>
>It gets more problematic when we do things like
>
>page = pfn_to_online_page()
>... do all other kind of stuff
>if (PageBuddy(page))
>
>(what we have here)
>

Thanks for the explanation. I still have one confusion.

What we have here is:

isolate_freepages(cc)
    page = pageblock_pfn_to_page()
        if (zone->contiguous)
	    return pfn_to_page(pfn)
        return __pageblock_pfn_to_page()
            start_page = pfn_to_online_page()                       (1)
            ... check page_zone(start_page) and page_zone_id()
            return start_page
    suitable_migration_target(cc, page)
        if (PageBuddy(page))                                        (2)

It looks the extra stuff between (1) and (2) is trivial and they still rely on
page struct. 

Do you think it could be caused by the data synchronization between CPUs?

Two possible points:

  a) zone->contiguous
  b) section_mem_map's SECTION_IS_ONLINE bit

At either point, if we get the old data, we would think page is still valid
and access it.

>Using RCU is usually not easily possible. Mostly only comapction does something
>like that.
>
>-- 
>Cheers,
>
>David

-- 
Wei Yang
Help you, Help me

