Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C4DCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 04:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4AC76B00A2; Fri, 26 Jun 2026 00:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22656B00A3; Fri, 26 Jun 2026 00:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5EF26B00A4; Fri, 26 Jun 2026 00:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84FE66B00A2
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:22:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EAA131A01D0
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:22:24 +0000 (UTC)
X-FDA: 84920767008.19.4DD135A
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0E057160003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:22:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ha3ajxW4;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782447743;
	b=eGX6WS26NdAhq0QnYEZnOXMnax97+y4FQx6XuZoo9vC56YFo8CH9sg0VyUNFWiC01oixHt
	TYcEIf2pjdyMFxmAmaM4VeFCEaj8Y25CE6Y+YBPL+NxCq1kXm9B/UW2R7gMqRkEU1TCJxP
	rgjBKKaQRz+kiOA0EZpb842YAgJ+S8s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782447743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y2iZYrcehiloQezHa6L5Jbel2ruqJBtvciYwuV6POaA=;
	b=lsFJFAeau/SWlMEb/ZQ4/VwxJGLH/w+tcNgSwIHi9zTcs9Mp6AzCr6mf/oavA75l4Dv83H
	0OSccvIpQ7t/CXbelZHrUPP+Czjg7bGrvgB+zYgv9zxkQzxit3UgqkCnBGyx7ikPDLIG5Q
	gfXgeW7ayjooNP3WYfARBeQfYvQfuy8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ha3ajxW4;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782447740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y2iZYrcehiloQezHa6L5Jbel2ruqJBtvciYwuV6POaA=;
	b=Ha3ajxW4nnYDyhVmnrf9lafZACH1Ca4ev+9lzJsUjv0qelwqbz9PObGw3bhuRGHrkLm/pZ
	79h53E4Jvsh5z8nD0jBfU3ayLKxumiHx8JIUsyzQb5P6fj6X8F8aTGR8r3+d0LRjJoZVIO
	EkPh1ok4IJiJykubG+jxxxb1yRXfrn4=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 5/5] mm/mprotect: use huge_ptep_get() for hugetlb
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <c807eac2-7b72-4b16-b4bb-b7241d35a991@arm.com>
Date: Fri, 26 Jun 2026 12:21:00 +0800
Cc: riel@surriel.com,
 vbabka@kernel.org,
 harry@kernel.org,
 jannh@google.com,
 lance.yang@linux.dev,
 kas@kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 rcampbell@nvidia.com,
 apopple@nvidia.com,
 ziy@nvidia.com,
 matthew.brost@intel.com,
 joshua.hahnjy@gmail.com,
 rakie.kim@sk.com,
 byungchul@sk.com,
 gourry@gourry.net,
 ying.huang@linux.alibaba.com,
 mel@csn.ul.ie,
 nao.horiguchi@gmail.com,
 ak@linux.intel.com,
 j-nomura@ce.jp.nec.com,
 pfalcato@suse.de,
 dave.hansen@intel.com,
 tglx@kernel.org,
 jpoimboe@kernel.org,
 ryan.roberts@arm.com,
 anshuman.khandual@arm.com,
 osalvador@suse.de,
 akpm@linux-foundation.org,
 ljs@kernel.org,
 david@kernel.org,
 liam@infradead.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A7E52D3B-8673-49F9-89F4-06FB2165FF06@linux.dev>
References: <20260625112955.3254283-1-dev.jain@arm.com>
 <20260625112955.3254283-6-dev.jain@arm.com>
 <28f75d0d-de54-43a1-b46a-fe3dd1188929@linux.dev>
 <c807eac2-7b72-4b16-b4bb-b7241d35a991@arm.com>
To: Dev Jain <dev.jain@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: igg3rb3m9ou8kea6nirhrifchue5pn51
X-Rspamd-Queue-Id: 0E057160003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782447742-401666
X-HE-Meta: U2FsdGVkX18j/cQtekA4MX4TOnh6KDUiX8mmSYfg2dvm5BAG9pBfRsgMI60Tu7VBsVdmCCSKBqBGT9rszHTBVS1/z1Alu4BQb4lezmmw2oBO1hJabOME7vpZm2TUIwhmlJLdQLmDFASQ0wXIT7E28wE3s8x4T5eyNj1d59IhO7wD5tEEdQs62PW10NT0v5vL09TABebGZ5hBgmqkX2cHCkCmYCPcViHK2qA/HNxTaULZwRFLfhXCSWv1xTYY23teLwiLFcj6GtnflZV89qKjFKcrNcWElhYohUK2KRC4/zbsHixhfkYdgSSBa0e4Tv4K3U7TALG1v6yvuNkjpMyOYzJpuXTU2YHkVo58ZYIP+6iBSXNQzWJ44wFUQXcyFwP8M+vOgoAV2L9D53yokCu3AWcv6dEZm0xqslXgMg71o7DE7dQS06IELlS78/UAN3xYPh1ecEG1ae8PnORiPWfFLQKbCCAIiOGvwrRsyOz98+iGxwc+zQBLdqYERR9ZbhsMFZ6IX9TwRQ8sIvMCp1ZW+RC0MvGRDoglOmsgumCoYRAYU4e9L7U5Tz7DgdsDf6GN0b2UbkEbMDrP9Wq96MKRBUaBZblXSn2nzHFMmWPIRygkYbY+Ntb3TJ7/6/ciMe4IfomX9HS44zHXhdaTMRgOGsWq2DP/Jb1zOekce1oWV/c+XhkuQqcbgzrU4iveDbfIUvxyxkrKcGNyM5qy+QffkCMAbGheMzOECJg9JUjPYkaCOGgRwQDvKcBZDX/5MRMlWqo7MrgDKbd3u0R/SITWeXdXC2ACZygVg+yn5Q+ZSKiiEQ8cJtK7vjHrbMB+s0t2stHCtub3/Ytj8Jq1Kl7z2/Go3nRFMWvczYg0EMSNDGGTJTNzDEnM5EjI03Lt/JDV0Syqte6xTsBsO2BPJCQzEXr+qtWG4Q/tzYW+VweISAXY/mbsIdaJEvapVgkGHhJJ/tfk+MO1pmboovsmUzX
 QldAAHW5
 8x7uulAoy+BDYCS2FR8wEXzScG324pgDR3rFC1xIQraweakRN0JgfhznyF2hQG7GChv0cl4s/yWf9hjFauQGEj+bO6OMzCOfXGOR3y92ro6maTHvqofW8ZVmoMI2SVHg/7/eZC8eJyuXVD5Q5vJ9sMQvpe4DWZSB5UZPAAsooyU1zPERGzg4nGVKTPlGsVT25af1Bt+hRpLQfjwjtVz571MNF1O9XGUZTGX6RLr1Y0SDr4WhXNKRO5ep6w15bCrFG01dsLlpLzlglzKYmKcCCWFuPqNHYyG8q9TK9qLT65fFeksOZOY1/LYJ2ifHLhf/lT3KVIlxfxU1zDZTakN8qChzlrqLWHu6FT6R+A5Ur5zwDBM0ShjNauRarLCYISEmnGxN4hL3s8phM5IEuhghOApxZ8mXxXqK2KUqM4bmB2DXc6v0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 26, 2026, at 12:08, Dev Jain <dev.jain@arm.com> wrote:
>=20
>=20
>=20
> On 26/06/26 9:10 am, Muchun Song wrote:
>>=20
>>=20
>> On 2026/6/25 19:29, Dev Jain wrote:
>>> prot_none_hugetlb_entry() is the hugetlb callback for the early
>>> mprotect(PROT_NONE) PFN permission walk on x86.
>>>=20
>>> The callback passes the decoded PFN to pfn_modify_allowed(). For a
>>> hugetlb callback, the pte pointer refers to a hugetlb entry. On
>>> architectures where hugetlb entries need huge_ptep_get(), reading =
that
>>> entry with ptep_get() can make the permission check use the wrong =
PFN.
>>>=20
>>> Use huge_ptep_get() before decoding the hugetlb PFN.
>>>=20
>>> Currently there is no path which can trigger a bug: huge_ptep_get() =
is a
>>> simple ptep_get() for x86, and the prot_none walk occurs only for =
x86.
>>> But use the correct helper anyways.
>>>=20
>>> Fixes: 42e4089c7890 ("x86/speculation/l1tf: Disallow non privileged =
high MMIO PROT_NONE mappings")
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>>   mm/mprotect.c | 8 +++++++-
>>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>>=20
>>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>>> index 9cbf932b028cf..23779632d18bf 100644
>>> --- a/mm/mprotect.c
>>> +++ b/mm/mprotect.c
>>> @@ -699,14 +699,20 @@ static int prot_none_pte_entry(pte_t *pte, =
unsigned long addr,
>>>           0 : -EACCES;
>>>   }
>>>   +#ifdef CONFIG_HUGETLB_PAGE
>>>   static int prot_none_hugetlb_entry(pte_t *pte, unsigned long =
hmask,
>>>                      unsigned long addr, unsigned long next,
>>>                      struct mm_walk *walk)
>>>   {
>>> -    return pfn_modify_allowed(pte_pfn(ptep_get(pte)),
>>> +    pte_t entry =3D huge_ptep_get(walk->mm, addr, pte);
>>> +
>>> +    return pfn_modify_allowed(pte_pfn(entry),
>>>                     *(pgprot_t *)(walk->private)) ?
>>>           0 : -EACCES;
>>>   }
>>> +#else
>>> +#define prot_none_hugetlb_entry    NULL
>>=20
>> This is very strange, because we defined a stub as NULL for a helper
>=20
> I was following pattern elsewhere, search for ".hugetlb_entry" in the
> codebase and you will find others doing the same.

Okay, I understand why you want to do it that way, but I would still
recommend not following that format.

Thanks.

>=20
>=20
>> function. How about  the following diff?
>>=20
>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>> index 9cbf932b028c..4d8c1551fbce 100644
>> --- a/mm/mprotect.c
>> +++ b/mm/mprotect.c
>> @@ -716,7 +716,9 @@ static int prot_none_test(unsigned long addr, =
unsigned long next,
>>=20
>>  static const struct mm_walk_ops prot_none_walk_ops =3D {
>>         .pte_entry              =3D prot_none_pte_entry,
>> +#ifdef CONFIG_HUGETLB_PAGE
>>         .hugetlb_entry          =3D prot_none_hugetlb_entry,
>> +#endif
>>         .test_walk              =3D prot_none_test,
>>         .walk_lock              =3D PGWALK_WRLOCK,
>>  };
>>=20
>> Thanks,
>> Muchun
>>=20
>>> +#endif
>>>     static int prot_none_test(unsigned long addr, unsigned long =
next,
>>>                 struct mm_walk *walk)



