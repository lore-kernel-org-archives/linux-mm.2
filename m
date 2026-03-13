Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3E85105F784
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 09:48:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44EBE6B0005; Fri, 13 Mar 2026 05:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC896B0088; Fri, 13 Mar 2026 05:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FB866B0089; Fri, 13 Mar 2026 05:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F06C6B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:48:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B2B60587BC
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:48:22 +0000 (UTC)
X-FDA: 84540564444.25.9A76F0D
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3D37E40011
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:48:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zjllx+17;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773395301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tEJz35Adc3NsFkK40sxCO0i6EjmFIRWe/WjjQkCGHCg=;
	b=Ft7/CoRQfJ0kV5szWaWYtQuA4I/und2584REIYuFxk9gd/GBnr6lnCbLvChD7fyFADSz+V
	NsWPPxBa/rO3NF7yiCL8Bn7L8wkRdi+CKumRcEkdLNSikAGOcI5wd7HuCxhKfr3uFtLZYj
	Z2trl3kAjYgkhfNmqjAfAIhpV7FCj8Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Zjllx+17;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773395301; a=rsa-sha256;
	cv=none;
	b=gVBMZUtNPqXbyauoH4R1hqyH8Wjtro+dtKMdcnOC8fqQYPsP8j8STSRqEUbDGGyoO9L3D8
	obeCK6qKKbEKqGVJik+rxivxoJCfdBZC1xOkv8X06yFnOdqVPiWYsS62+KbxvGAnWRhIq7
	6mmkbLUb5QMVB8/6DGTa3uQ+DAV6Z2M=
Message-ID: <1a886b5b-319c-4f3e-8db1-6af6696f4d84@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773395295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tEJz35Adc3NsFkK40sxCO0i6EjmFIRWe/WjjQkCGHCg=;
	b=Zjllx+17Jiz/7ga1clp9pCa6VHzQgQMd5fHO2FujvKPSUUg1rEJOFI2Hp2+/8uHpxRbTQx
	vh3Jtnmwko2XXm1olQ/iInZQWIL7me0Gzoai8LfN913QvKIWTBP+X9+bCMbb/6WJvtMpnO
	267U/Y7QfyMTCgsNl2Yf59L7op2lNUU=
Date: Fri, 13 Mar 2026 17:47:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 1/2] huge_mm: add stubs for THP-disabled configs
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>, hev <r@hev.cc>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com
References: <20260310031138.509730-1-r@hev.cc>
 <20260310031138.509730-2-r@hev.cc>
 <bca4ea00-3052-425b-8f39-729d504fd4db@kernel.org>
 <7937d789-539f-47db-838f-c153ca6cfc50@kernel.org>
 <CAHirt9gpZ98HQCXStEQMMfe6TEnSzmD04BM313h2LJGJ1K-hJw@mail.gmail.com>
 <60ba4311-01f8-4ff3-a2df-e1b3fb6db699@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <60ba4311-01f8-4ff3-a2df-e1b3fb6db699@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3D37E40011
X-Stat-Signature: 3d56u77ofmxtgw8suyopiq773dgpz3si
X-Rspam-User: 
X-HE-Tag: 1773395299-491191
X-HE-Meta: U2FsdGVkX18728Dpj2MTlHZ2ZWC5CEJzhdd67xlmYwYXdN3cHfkHbpu0tPk4gWwYMaIO173bG9SsjQQhQDGmajVWe4hfHpZm1/yBhLoR0hHHyHkjCAJ3m8JDvtQH1kew8S0rGIidVsq75YfOvUjGSRCDAznBUN5n6xIICMazPxZLBwQXWBgJZ6dRgUsA0peTU2TEsBu3TXMt6mnSsUFlHwV5zvRtdoFnb5mdIvCapI2//b/uiVH9pgunhMgVVYjF6ihmeDk255D7LWxZ1d2Oe4y3zU5W6zOa77j05zfUmVB4uqg76CDoS8h+M4l5rHYgHVfcRDJKGs999gx7Vqobv9wEjsYUxyMjOlC72u5yz3FYoq9/tiAUrr29+Fsp2rDzcp0alsqvZxaknoOVUBB3y/u3RkPadC0xasoH0gFC8oFvJ5/O9VIUdSQ9wAzQIm6mVAUo62/oWwH3OUm6KulMrGEGuZD5F6HfgqVrAgFqdvc9Nf0ne1fMlxzOUCBBqZzHw20KTdIdhW99g+tZLa/qC7B9rpbPI6ZcFS/C67mcTyCT7kNWtLQF77Fh9VK2PtSoq/hJMyzuIslvWKmUyXG14pa4NxcaL5VekCecRVovyhyu8g56tNru/LJdJ0EiSKJPpVLEjuxf2dQ8pL+mhJFUQU2yeVHqWGUcj5CjtwUrOk0EbaUh6LqukUd60CdRO4YLOVigjdYzFA67YP4nipjNbU2Gf9lsI/tQSkQ9ogxyvHzdbXpYyvPP+bCPvrP1TUvDmAkGr4GszOayGIa6EkERXeMWmiYJKwCVPkwjajNui6RN+Y+phWN1m88S1aBrSj9sUXhISy52GRvY06lmg8lwbOvgfz+GXr4/sdzuK4u1BzirTH2mLAh/QjGdN/U54hy4kgWzLFIFGlGAARGmqBhcFETwPZTQ0hig
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/13 00:29, David Hildenbrand (Arm) wrote:
> On 3/12/26 17:12, hev wrote:
>> Hi David,
>>
>> On Thu, Mar 12, 2026 at 11:57 PM David Hildenbrand (Arm)
>> <david@kernel.org> wrote:
>>>
>>> On 3/12/26 16:53, David Hildenbrand (Arm) wrote:
>>>>
>>>> There are other ways to enable PMD THP. So I don't quite think this is
>>>> the right tool for the job.
>>>
>>> Ah, you care about file THPs ... gah.
>>>
>>> Why can't we simply do the alignment without considering the current
>>> setting?
>>
>> The main motivation of raising the alignment here is to increase the
>> chance of getting PMD-sized THPs for executable mappings.
>>
>> If THP is not in "always" mode, the kernel will not automatically
>> collapse file-backed mappings into THPs, so the increased alignment
>> would not actually improve THP usage.
>>
>> In that case we would only be introducing additional padding in the
>> virtual address layout, which slightly reduces ASLR entropy without
>> providing a practical benefit.
> 
> Well, that parameter can get toggled at runtime later? Also, I think
> that readahead code could end up allocating a PMD THP (I might be
> wrong about that, the code is confusing).

Right. In do_sync_mmap_readahead(), if the VMA has VM_HUGEPAGE,
force_thp_readahead becomes true and ra->order is set to
HPAGE_PMD_ORDER, IIUC.

	/* Use the readahead code, even if readahead is disabled */
	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
		force_thp_readahead = true;

That order is then passed down to page_cache_ra_order() and finally to
filemap_alloc_folio().

	if (force_thp_readahead) {
[...]
		ra->async_size = HPAGE_PMD_NR;
		ra->order = HPAGE_PMD_ORDER;
		page_cache_ra_order(&ractl, ra);
		return fpin;
	}


For plain VM_EXEC, the code starts from exec_folio_order(), not
HPAGE_PMD_ORDER.

	if (vm_flags & VM_EXEC) {
[...]
		ra->order = exec_folio_order();
[...]
		ra->async_size = 0;
	}

The default exec_folio_order() is small, and arm64 only overrides it
to 64K.

/*
  * Request exec memory is read into pagecache in at least 64K folios. 
This size
  * can be contpte-mapped when 4K base pages are in use (16 pages into 1 
iTLB
  * entry), and HPA can coalesce it (4 pages into 1 TLB entry) when 16K base
  * pages are in use.
  */

#define exec_folio_order() ilog2(SZ_64K >> PAGE_SHIFT)

> 
> Let's take a look at __get_unmapped_area(), where we don't care about
> ASLR entropy for anonymous memory:
> 
> } else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && !file
> 	   && !addr /* no hint */
> 	   && IS_ALIGNED(len, PMD_SIZE)) {

Yeah. For anonymous memory, the kernel is willing to do THP-friendly
alignment, but it is constrained, of course :)

> Interestingly we had:
> 
> commit 34d7cf637c437d5c2a8a6ef23ea45193bad8a91c
> Author: Kefeng Wang <wangkefeng.wang@huawei.com>
> Date:   Fri Dec 6 15:03:45 2024 +0800
> 
>      mm: don't try THP alignment for FS without get_unmapped_area
>      
>      Commit ed48e87c7df3 ("thp: add thp_get_unmapped_area_vmflags()") changes
>      thp_get_unmapped_area() to thp_get_unmapped_area_vmflags() in
>      __get_unmapped_area(), which doesn't initialize local get_area for
>      anonymous mappings.  This leads to us always trying THP alignment even for
>      file_operations which have a NULL ->get_unmapped_area() callback.
>      
>      Since commit efa7df3e3bb5 ("mm: align larger anonymous mappings on THP
>      boundaries") we only want to enable THP alignment for anonymous mappings,
>      so add a !file check to avoid attempting THP alignment for file mappings.
>      
>      Found issue by code inspection.  THP alignment is used for easy or more
>      pmd mappings, from vma side.  This may cause unnecessary VMA fragmentation
>      and potentially worse performance on filesystems that do not actually
>      support THPs and thus cannot benefit from the alignment.

Looks like this commit does not *ban* file-backed THP-friendly alignment
completely. It only prevents file mappings from getting it accidentally
via the generic fallback path.

Note that some filesystems still explicitly opt in with their own

.get_unmapped_area = thp_get_unmapped_area

for example ext4, xfs, and btrfs.

So explicit filesystem opt-in is still allowed :)

> I'm not sure about the "VMA fragmentation" argument, really. We only consider
> stuff that is already multiples of PMD_SIZE.
>
> Filesystem support for THPs is also not really something you would handle, and it's
> a problem that solves itself over time as more filesystems keep adding support for
> large folios.
> 
> So I think we should try limiting it to IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE),
> but not checking the runtime toggle.

Good point! ELF layout is decided once at exec time, while the runtime 
THP mode
can change later.

