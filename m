Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FAE2E7E0BB
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 10:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9827F6B0005; Mon,  9 Feb 2026 05:13:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 905BD6B0088; Mon,  9 Feb 2026 05:13:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 805446B0089; Mon,  9 Feb 2026 05:13:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F69F6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 05:13:33 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 10B1D8C407
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:13:33 +0000 (UTC)
X-FDA: 84424506306.25.45481AD
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf02.hostedemail.com (Postfix) with ESMTP id D045D80003
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:13:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="CZN94h/F";
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770632009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KuHdmbMe8FhR6HcphPrJrW4PyN3G5yZpYJxJ7bkfPFc=;
	b=miBrwqHhqNaHqIEV2fvlb90vw1hzJhoQcuz07k6uBAk/Yoc+3VkZp3B3pfTz6+gRTT/DLS
	hG14dM4cDLRHJn2hjKz2xi2LN5CzurXAgY6HSF8Tl5T+ifyy/bksYf7mFPAbftcCLIebRv
	0NLEIBu2sJt5HunJ0ddeDRBOBtklOqs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="CZN94h/F";
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770632009; a=rsa-sha256;
	cv=none;
	b=utfGRTiDkLUeWzgpe3VUXDyeWVMkDyrNtuZgie0Mxtf0FG/AjoFPt5M+u4Mh4bB77ZZO9x
	e1TZRhALfLAIPCp/qb7AeUVyw1fiVNrEHyZUQFnFeTdVtRiUAU0a75iJVo3wdgJ7oLqWD6
	Yt3TLVpd/lZ33pVTigfEbXGMDf+6JiM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770632002; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=KuHdmbMe8FhR6HcphPrJrW4PyN3G5yZpYJxJ7bkfPFc=;
	b=CZN94h/Fi2O/H1Kn6DWY/XfKmeh/C8euEtmiMdhYjxRsTUOXV2K7k1z2pw8hCeifmakp/N+BgYupPKfy4VweEzKttlewBW9rY2Adc8+uX/it2LrGzNlT70RQU3cJD3nQg1UaJEa/mf/QJ3xo9/HIFtMd6nIneltSUCbczhNoP8U=
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WyqmBGB_1770632001 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Feb 2026 18:13:21 +0800
Message-ID: <6817c7b9-e67c-46b6-b3b5-1bc3d9eed4a2@linux.alibaba.com>
Date: Mon, 9 Feb 2026 18:13:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] arm64: mm: implement the architecture-specific
 clear_flush_young_ptes()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Chris Mason <clm@meta.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, will@kernel.org,
 lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <9d866a2644051e13a41ef4d6ca3909c6e1f9e229.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260128114936.72280-1-clm@meta.com>
 <de141225-a0c1-41fd-b3e1-bcab09827ddd@linux.alibaba.com>
 <07d55759-a50a-457a-badd-85697174116f@kernel.org>
 <280ae63e-d66e-438f-8045-6c870420fe76@linux.alibaba.com>
 <16fb7985-ec0f-4b56-91e7-404c5114f899@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <16fb7985-ec0f-4b56-91e7-404c5114f899@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D045D80003
X-Stat-Signature: 48u6f4jqkx5yn1hs49wqhazis4c4yyk5
X-Rspam-User: 
X-HE-Tag: 1770632006-967358
X-HE-Meta: U2FsdGVkX1/eSFl9LKrth9Vm+3carJ1NOFBCU+zh8EOR1QJ/UujzMjTbsvjfvjjNxUjBfeH+Q0kru/llVgyUediO3T4lFrIv0srroGo4jVJpcsGnCZ6DIJy3WIlZGVwaz38rkOA9wHiH+TE5TIbZaQS9aiBITwk3w+rkHXiWBZgYHoJ+MnOPGXSLAJblbzp3usUnP+hQzG12s0EzXSz4YcvQ+QgR5orcSIF6LbRphVmLAjxSbx6ixYiivGlE047vtrwu3aVvaQD6jT9y/PpqGjp7Q67AbtN/HkotE81WpWYVxw42nfyZ6q+pEhFmH+WD3LNXVciipnlMADPSi/uXjRY7rMusoge/MCR1BfxBcg8Op4sDDODDlOtoUj2pbBRPvZf6eRi9uWugZ+wD04O5XuUl3mcNj2z7kYt95yaP45MXTgUCh0V0Frl5yPw+0YUxUNl265PfSRq6Ko7kdvLwKS95Kr1AM7RQcR8e7IdeNLJlNOrb/Tg70isbwyylNkJeKWP52iO8oOiN0F/glLKfI6VqQAAomAS61KtOcWZq14mX2H7Qr1zmWoAgop16J95baMj/kpWjldmU9bAO79I68ZuyaS7go1nmcgOzZVIqK83/kIDvbvf+R342HwmKR2l3f1pwv5ioLtxDStSGeEmiU443+QvfmChfLax3zoG0bkXg6+y2MKhC09/kHkBQOtfBT1TX8L1yr5RbnyGflVPHXu+BpmVDjeFhTA6w0s/zBe4wQHz7aJEmzbRIfEwY8HNTss1eVaMkLtd4IJJUB1GeJtEFRCRZvFyS8Ayxr0xT5TBaJUK03h8utWQ5S+eu5azZP6sUx1zwyapHi4AHkD6FKWc93qsNgOdlyAo+49YynAT1hce/THo6jMdrtAfCTD58WM6zussUY2jm1A836aktB5wOenvDl8XD8MCL/aDrWlNqvaOYR9lkxnaiOfphn7rVRlrAcP5d4yYvfYqci1H
 WVzMlPNA
 sLZ1i5JE6QKHmMjwk0idMR3wGS99jL+UKb4l9v+LvwQOnycbvqUGvS6k+cwHaD14bKiiptLc82/RF+885WB91yp5ch8+lUd0YammtPwNoCJz3ZXkYA6RnK1a1TM5BvaUF83+4UQNDR07OV6kVRnT64SoAJkGu0XedyHoAp9IgsYXXWjM8KZ5OGwpiHwUqkfHXGrTjMvdaG9XtWRZjd97zBkcXVrqYFmf/BUsGd75xU1fZUfeLgvIQvF6ZI0Cn77CfUFWjByhRxUhowpXQmzipqwS7rw2p/ZIll2lSXhlGnsFsiDCESsRmHSbVxdoPgPhtnnqntaMMYCNIdVQQQBqh0ErxwQJqRSakb9YvyTW8G44RYz+bpaZiTeu36of9Z6tuaMCZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/9/26 5:55 PM, David Hildenbrand (Arm) wrote:
> On 2/9/26 10:36, Baolin Wang wrote:
>>
>>
>> On 2/9/26 5:09 PM, David Hildenbrand (Arm) wrote:
>>> On 1/29/26 02:42, Baolin Wang wrote:
>>>>
>>>>
>>>>
>>>> Indeed. I previously discussed with Ryan whether using pte_cont() 
>>>> was enough, and we believed that invalid PTEs wouldn’t have the 
>>>> PTE_CONT bit set. But we clearly missed the device-folio cases. 
>>>> Thanks for reporting.
>>>>
>>>> Andrew, could you please squash the following fix into this patch? 
>>>> If you prefer a new version, please let me know. Thanks.
>>>
>>> Isn't the real problem that we should never ever ever ever, try 
>>> clearing the young bit on a non-present pte?
>>>
>>> See damon_ptep_mkold() how that is handled with the flushing/notify.
>>>
>>> There needs to be a pte_present() check in the caller.
>>
>> The handling of ZONE_DEVICE memory in check_pte() makes me me doubt my 
>> earlier understanding. And I think you are right.
>>
>>      } else if (pte_present(ptent)) {
>>          pfn = pte_pfn(ptent);
>>      } else {
>>          const softleaf_t entry = softleaf_from_pte(ptent);
>>
>>          /* Handle un-addressable ZONE_DEVICE memory */
>>          if (!softleaf_is_device_private(entry) &&
>>              !softleaf_is_device_exclusive(entry))
>>              return false;
>>
>>          pfn = softleaf_to_pfn(entry);
>>      }
>>
>>
>>> BUT
>>>
>>> I recall that folio_referenced() should never apply to ZONE_DEVICE 
>>> folios. folio_referenced() is only called from memory reclaim code, 
>>> and ZONE_DEVICE pages never get reclaimed through vmscan.c
>>
>> Thanks for clarifying. So I can drop the pte valid check.
> 
> We should probably add a safety check in folio_referenced(), warning
> if we would ever get a ZONE_DEVICE folio passed.
> 
> Can someone look into that ? :)

Sure, I can take a close look and address that in my follow-up patchset.

