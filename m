Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62D69606A328
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lUfxt6bO
Received: by kanga.kvack.org (Postfix)
	id 83E116B05B1; Fri,  6 Nov 2026 04:49:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EFEA6B05B4; Fri,  6 Nov 2026 04:49:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705616B05B5; Fri,  6 Nov 2026 04:49:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56AE36B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:49:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E25F41A0D1F
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:49:37 +0000 (UTC)
X-FDA: 85404221994.07.1156236
Received: from mta1.migadu.com (out-94.mta1.migadu.com [95.215.58.94])
	by imf28.hostedemail.com (Postfix) with ESMTP id D0828C0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:49:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lUfxt6bO;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793958576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6DU4XzSpmp/n4/D9eXag/+qPRamb2DqfAVopLVqvQOo=;
	b=JRKdOm0jIx0/1YSHOlo80FjdfxQjUVpbA0cwJa8FxTrl52mHmVWMwB9T3e9oTQAdvvgcGd
	UeO38PDQ0muxj1Ra1YmXfZn5neaSvpi2imDv7l5N+ho9twVXsUdzkrKVpdRXvo4d+I5Sal
	uHuf7al7oebOTUHjUYAGcD2IIZTxaXQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lUfxt6bO;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793958576;
	b=NxD3aPepJtX2d8fV9Ygy+I/r7lYerwjF5BXhehKqTrw94zoa7emccG3V27AxD640fNK5m5
	0BxylIA68m18ypdi5lUoLyUgMgNGtUmJqgTRTM+D0yVO/iplFjSCLI/gEePAxrIhJFLiN1
	o/oCrCn6fXrT0igFyndzmxMpYiJA9Ak=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eG7lP6gOXEU8U4LBsocd1+0PiWMCGV/hYfHSxyzIAWA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793958574; v=1; x=1794563374;
 b=lUfxt6bO2AGkup/NTOyuAZoiZE/jQzRxT5tCXgq14ZttaOFnSszhVifTOFP9nEEpplUmd8kd
 9wfsWuh5xuZoTmvlJg4W24nXQIet+recIFSbR+orEKuGtuZx7twPiwoMZ9WprNnwHvvE4f6QU14
 8UDGWZZy1lxF4UYC0FQsRE1Q=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ec9a2babcc567cf7;
	Fri, 06 Nov 2026 09:49:34 +0000
X-Mizu-Trace-ID: ec9a2babcc567cf7
X-Migadu-Flow: FLOW_OUT
Message-ID: <3436028c-6ab8-42a6-9489-8dfe861fc3f4@linux.dev>
Date: Fri, 6 Nov 2026 17:48:23 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] powerpc/mm: drop powerpc vmemmap_can_optimize()
Content-Language: en-US
To: Muchun Song <muchun.song@linux.dev>
Cc: Sashiko <sashiko-bot@kernel.org>, Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>, maddy@linux.ibm.com,
 Mike Rapoport <rppt@kernel.org>, akpm@linux-foundation.org,
 mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org,
 ritesh.list@gmail.com, sshegde@linux.ibm.com, osalvador@suse.de,
 Qi Zheng <qi.zheng@linux.dev>, chenhuacai@kernel.org, kernel@xen0n.name,
 linux-mm@kvack.org, x86@kernel.org, linux-s390@vger.kernel.org,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com
References: <sashiko-outbox-198652@kernel.org>
 <20261105080241.57241-1-lance.yang@linux.dev>
 <2AB0A0B1-1613-44CC-A007-2453F6206D77@linux.dev>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <2AB0A0B1-1613-44CC-A007-2453F6206D77@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pza5i6w1x1ez9mbb19puqmynu67goi6p
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D0828C0005
X-HE-Tag: 1793958575-884429
X-HE-Meta: U2FsdGVkX19T2LBb1eJChC/bXHZCxkphHg/w22H6hmUdHa4fzwSCosmhWMqSq8y+mV12Ullo3/+w+pXGSNPiRu1svobXgLq735Y+vrhoEeMiSFvtKCD3xeNaTKGGmdpRvV4ms4qUpjX+dHw9inrPMURL5y96pX7yBVNAWgeEaUak5iseLBeZECFRyC8xE2J7NGM9m35O55hwr04ROFSMWZP1pJLawP49ahYd+gWhxOcnINsWTKa87rxdRi6pqCsPT3pfA2ElixjyZfh71cugTsyTUDvRSbFTsa2WyWb3K+svroe7IJ36bzIs4tZK6e9hwQ/WoOpk/dDl2rKcRQl+I8Uc6JBqBrduDj2D3n+sHk48TA8nRL07LrouJatVHgMn7z/ZaisoseT3w8htHRV6EejjIQrvoaXFtyMmjjrGr8S+7tBo/zBRcLjgjGaDl41rMvc4z1DV1k4vf4QApTtcbQcLPjxs/c2R0r8psgDVi3Oxs+muhGoHYbSDQhzkWL5GTOPpk7MrcSbRyPEGOHZaTY0EQQoWhWVOl5qPVVaIXuHbHn3fg0RMbBau9PYaiQC+elgIs1IveNamlaV82dlXc7tWpsSmEAk5Q4kKWvpp9tb11QLVVQ1WzljmwDGxamf1LZohGcLQT1eoeQPBM4t6cLnn7NjM0uxT8WbOUtZXXX3Bh+X2Wi+mSsH8B4aSbOyd8OOzQrXkbMO7Dyzs9ekHDLi5FNkIHkmInE8TVmiP7V2SKgcOXgVPMdvhyjqOjHi93i7w3w4tOenbFRmHxvvsQYFmRF6X8brkcIp+jsJBvuIRdcQOmVUUffvTlsJcK7pNV4/xuLlDnF6vSZuhFnmDXOGc14SYYOxulWUMDZwoorFjI3rg4FPskSp5cIlxdK5fiKRwXFNb7y4egHsZ+VYeNAhhQ56UPz2ubpeO8gVlbbtb9ut0nLVVQfTzZmg+YsWda6njJI/yWw3O2Z2adX7
 mGkS7bxv
 5EEXxjjFuOXHEWWxCu71EXLfY7leP5rDzC8l0DBjhnM4gyVA0xEJ3/enTwJVl2O0g5NERNQacS8QwnB686UCkda1x6kw/v5xiFPq1xJx1/K4qsnUxIy0F/edjFuDA66YpVAq4gWCxZhVLNo0lkUQQIlzhh08X/TJ1c2OuI85ck551R4Th/q3sfPLwDDOyA+G3vWePjwP1tj/S0c2lr3+BEH/RH1LzsSFDanoUy0jKzfg+AWW9DqedU0oV5N2+Cfr+si54Tot/LmIxgGf6OhpHFZwM5S8CX9dbFRgM/8xWNGdolABTBUJ+ZVVY9anorJgjMoKNpLBhxgzG7vLxt5hthQ/KGIIBDsA22cml1rf2hmJF9+5NcH6PbgqNi8y6hqaKhKjHFgdJxRoZRUoRHcVlfKPFvwD5ZNsnMNargfuSK3mSOG8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/6 14:09, Muchun Song wrote:
> 
> 
>> On Nov 5, 2026, at 16:02, Lance Yang <lance.yang@linux.dev> wrote:
>>
>>
>> On Thu, Nov 05, 2026 at 07:16:48AM +0000, sashiko-bot@kernel.org wrote:
>>> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
>>> - [Low] mm: undeclared vmemmap in section_vmemmap_optimization_disable()
>>> - [Low] mm: define vmemmap_optimizable_order() before section_vmemmap_optimizable()
>>> --
>>
>> IIUC, on LoongArch, asm/pgtable.h includes vmemmap-optimization.h before
>> defining vmemmap.
> 
> Yeah. Really nasty.
> 
>>
>> How about taking a PFN and page count instead, and leaving the conversion
>> to the callers?
> 
> However, although this can solve the compilation problem, for the caller,
> it is not very straightforward because they need to calculate nr_pages.
> section_vmemmap_optimization_disable is only supposed to be used in the
> vmemmap population path, and in these paths, the most direct parameters
> are start and end. I think this function could be moved to
> mm/sparse-vmemmap.c, and that way the compilation dependency problem
> would be solved.
> 
> What do you think?

Yeah, fair point, let's do that ;)

