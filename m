Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F464D116F3
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 11:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B65146B000D; Fri, 28 Nov 2025 06:26:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15A76B0027; Fri, 28 Nov 2025 06:26:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A530E6B0029; Fri, 28 Nov 2025 06:26:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 924A86B000D
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 06:26:49 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2148C5951E
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:26:49 +0000 (UTC)
X-FDA: 84159788538.10.3FF3D4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 64BC5180008
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:26:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ce+yZbIh;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764329207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Karb8MQ/UDxOFWn3DQ5kxVv44zf842FhiMkOKk3B/ok=;
	b=CDqEsyofGDLEkya23muwaUo8LbODtJghCouBdPUJUPA6ywQYEezjz6X9m/N8BAkyOqY3YN
	c+kRj5fiEIgX4slXSLoHPeNKh9mcYcOLrt/u1DhU+UJC8OC+hvcZaUJdPRLYnI3O3rYV+5
	7y3xtcY+9Xtl9AgLc4tad3UiB/lfTyg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764329207; a=rsa-sha256;
	cv=none;
	b=V6lkwNi8jCM8zpLJq1dCnDfmjEKcxxRqVImJEtJVdOZ2Il/e32MPH3+QsSesRb+R3Z3Rsk
	MsQSJj8d6eoXqrzdLU/+9omGkGItzk+D3EXWzA1i5y3r92IJLKwgUcH446yRhy+jhX8Dpy
	TrcMFB4TlPgRf6vguvglP4ieH51G4Tk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ce+yZbIh;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 40EBE434B0;
	Fri, 28 Nov 2025 11:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F14AC4CEF1;
	Fri, 28 Nov 2025 11:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764329206;
	bh=pixOixLW18MiI7w2OhyFVjtVTI0QWrgN96lX5JcVnGI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ce+yZbIhiq2cMKfLdkoXgLsyrCnReqnjN4Z0QFeNfmGjycBuAVXpzBoTCbIyEvUN7
	 TullcC/YkKK0Q/YQoAEK5obFvYdwQERmJD+Uwx4F7NtpNKWGjEUCKUc79VEYJi2Kav
	 4SfQO/lg0uo9LhA7grPmaT5JqsNum01LVNi/KScFCXMCb0bZSVtDeHFoyxvAlrZWrr
	 uWVxT9XgVqOIzess0ZkuSknSIOzhN/H88f7JW9ZOKNoMOkDY2m9UdO6GCBVEPpKbxF
	 q2XjQcTIewbHDYYuokViM7UbOIKPSwzan4OchotebltAV0O7qzCsodeuqUDPLhzWv4
	 uLFQ6rezfj3ng==
Message-ID: <f562c165-f652-4f40-9620-8f5f610b433f@kernel.org>
Date: Fri, 28 Nov 2025 12:26:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hugetlb: Add guard support
To: Fushuai Wang <fushuai.wang@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev,
 osalvador@suse.de, wangfushuai@baidu.com
References: <9cb0a602-69ca-400f-890c-e9dd5b44f53b@kernel.org>
 <20251128112307.80237-1-fushuai.wang@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251128112307.80237-1-fushuai.wang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 64BC5180008
X-Stat-Signature: xbx14877dyhag4t6h3fbnkec44fp9duh
X-HE-Tag: 1764329207-833953
X-HE-Meta: U2FsdGVkX1/wSOY6+r7Frr/5XPSwavkgNcueFSKnURO3E42X9aGqcev8CoQ6IttYsDKyYVu9LZ2tpmucBwDCIFOKDo9WQKTX17tGvQLIbVFlpaZtx2Ne0YVLNelSuWQlpSWSR7lTL9umd5THqvKw2eMIZS6P4jcwDd6EdmiC8xBEO7TiIAAdDAMD9WG+GBQlnvRYH5KGJY/OzGfIzB6qoYa+4yvbNalHOBUd+ZA/gMxMoE8q565G4EOlep+/r6Q/ubg6+3OzMMcpM3xWONuKQzZHJfO5Fj+zhJ+nqwShJ5uVgGxzWNEmwIVkVSZ3vn858/zgQNRR7jjoZ6celVMW3ZQUE4iD1oTouYSRO6IpucXpZzWhyvwvVu2uE6UMPBDRxazDFHXp8KJg92zMetUjH/UCKR27wdByKhUMZG6bHNdq+qP8oYXnIEQfg5o34osJ1zppwP0V87hX8FdxjgxWK0t1ZgLTzy3ox+ZEhhPwIoFDNdamrMK3bIyt9VMXtqQT1L7OS/QvP/S+eU+c5cfU6F1enDwSSSa2lWHBQFMzx9gNqSU4l71mb93wJr6LxhvRD6xupTrVTS8E81D2WexImHGounNFx6DWAQFzWfJ5h7E8YHBm2CKiGapMZgV+9yTj5brAZx2mEVkXdoWETsoZqSi0HXNJ25f+kl+NA+N+vKh57VOsT2KLn//v7DfJySA06NMC+dNOwa9VeHJqvTMKzozNEXVnSxxg3Rkuc86vBMm6Y3aOK3xzMDxKg3c3/mJirvbY7GBHK9YBcChsFsUOrN1fdZeWaO6v9FAXZlteTVz29jR4f7E8aljuz5mHTDknvOzyRtti9ILrnjuNBXEW3FI/u3LmY8LptPZtHH6xnS16drpJIcrlpDSIPKUHs92gOw0pqe8afoYnnf2H/M5yeCXCkMRUa/rbUG4IVNZlwg0dZPxrFmsJMFwCMGeo1UQIU9C9QBhkFGWs0QbUhf2
 p4OkJzo9
 lV6LoYOtYzmAkxHc+dWEhu4Q3s6qtD7/MHkF/p/uU8WejY7+Z758w2LJhydHgfeEpwAJH5YneMONtFL6rf5jVH06smMDwfNuzw3FS/0ZDTwZXR78PPX8A8tDYsqY/Q0g35CxR4Y49jV40iFDiVPKXuKMV2xxBErxLMPAe4xJfLCkbmohOqwKrcRbWGTZ7isvLEGmTUFdzh7mAQI3AIkBoS5vjFIC1wo++TvTZmowA46Hd1pGR+cVmbmRYk+/mFtFc+xMT/0Eg1AET7xqfI2sx8RL+Mn5dSREV3CtG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/28/25 12:23, Fushuai Wang wrote:
>>>    include/linux/hugetlb.h | 8 ++++++++
>>>    1 file changed, 8 insertions(+)
>>>
>>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>>> index 8e63e46b8e1f..f97cb2f123a3 100644
>>> --- a/include/linux/hugetlb.h
>>> +++ b/include/linux/hugetlb.h
>>> @@ -15,6 +15,7 @@
>>>    #include <linux/gfp.h>
>>>    #include <linux/userfaultfd_k.h>
>>>    #include <linux/nodemask.h>
>>> +#include <linux/cleanup.h>
>>>    
>>>    struct ctl_table;
>>>    struct user_struct;
>>> @@ -468,6 +469,13 @@ static inline void hugetlb_split(struct vm_area_struct *vma, unsigned long addr)
>>>    
>>>    #endif /* !CONFIG_HUGETLB_PAGE */
>>>    
>>> +DEFINE_GUARD(hugetlb_vma_read, struct vm_area_struct *,
>>> +	     hugetlb_vma_lock_read(_T), hugetlb_vma_unlock_read(_T))
>>> +
>>> +DEFINE_GUARD(hugetlb_vma_write, struct vm_area_struct *,
>>> +	     hugetlb_vma_lock_write(_T), hugetlb_vma_unlock_write(_T))
>>> +DEFINE_GUARD_COND(hugetlb_vma_write, _try, hugetlb_vma_trylock_write(_T))
>>
>> Do I understand correctly that the code you are introducing does not
>> have any users?
> 
> Yes, it is not used now, but it can be used in future development to simplify
> the code. If there are complex hugetlb_vma locks in the current code, this can
> also be used later to optimize them.

Right, but we usually don't add dead code. So it should ideally be 
introduced with actual users.
-- 
Cheers

David

