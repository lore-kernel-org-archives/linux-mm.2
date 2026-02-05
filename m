Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 539F8EC1EB9
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 13:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78666B0089; Thu,  5 Feb 2026 08:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D076B008A; Thu,  5 Feb 2026 08:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4C2D6B0092; Thu,  5 Feb 2026 08:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 980E16B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:59:09 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51C85B9CD0
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:59:09 +0000 (UTC)
X-FDA: 84410559618.05.F4EED1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 770BA100008
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 13:59:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UDgEXs23;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770299947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GAkL/tsqhjWmsB3gTBJ6WdAVIJsLA31Bz4iVVKg5aT0=;
	b=2OQIlUwaKMfAup4rrUqNJfzyY4MiNdc2beEcmzq1HiOmOjDHWTyzb38Y8jesnhUPMs9ViM
	BORTxKKLj375P9quvMSslqul41rPe6ySS6AhHyat4n18U79lUBGMFn5POdjVd+NbwG7qrl
	zjZY3TFz7Pgc/J5mZR5rkqdNP6f6uew=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UDgEXs23;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770299947; a=rsa-sha256;
	cv=none;
	b=Bp90IFBMjz4F9EJwQVoG18IFwrCXbRhTqfRZVjM8dLhxf1QNxIp+DLVOvwpS1Jo84P9p91
	oDgS+v5sgWTu8ZHi6gnwXrDyqV44kGrqtFhI9+f1cM01xvST61simEumPSydxzzIi25ahw
	xDCFV0Az0+TZKbMeSCRPThQSBLTTbFw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A508444FC;
	Thu,  5 Feb 2026 13:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9A4C4CEF7;
	Thu,  5 Feb 2026 13:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770299946;
	bh=NrgItkvDCDI0JdjjTiJgmYN8Hu+I5JatU6qOApBTUkQ=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=UDgEXs2326E6nluf1TRc8JSNvhmzOon3wFQO4IGhep2GcsTFGb51oZnfVZiY1GAaR
	 AP8fzqcnv7eYrYj9lL4FNmIylIXtktJO6S/8lPEsr9/blHUuTeaYrMQZrCri1qieYO
	 cq0gkqvEXFYLEhEOZv7vi4RklL+UFVEE6ysMw5CnfQHGwPi5Qp1XZ6xxWiFW46pN2N
	 kiqi1m6pj9kSW9RPBUIsDiBzSO344zesdF59KRQwvqScPSbSq4fhaJHCL1XMX/KL6Z
	 AGh6cTxV+hX4OwAQ5pwgwcuIpE1fW7fngurZgxukYKy1X9RCDc7bsKDUrmmVxEI6CF
	 RZ/PweRaGfL5Q==
Message-ID: <a3f454aa-7cff-4e85-b046-5d4c55d8ccb9@kernel.org>
Date: Thu, 5 Feb 2026 14:58:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 09/17] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-10-kas@kernel.org>
 <ef1f6ec1-7036-400c-9d4f-fc4f6f969ef7@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ef1f6ec1-7036-400c-9d4f-fc4f6f969ef7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 770BA100008
X-Stat-Signature: cy7rxxjikywrnb3jfan4f9w715bb5grq
X-Rspam-User: 
X-HE-Tag: 1770299947-30444
X-HE-Meta: U2FsdGVkX191/288wtf0q6g3oF2L+bKVihelLbAmeuV+LeWi/3aVhp5dzfHvhMLjgi0mz1DTcdH8BDjOly2IQ9Q1Njj8i5gR/+Itw009ZUrpOCcbCLBvWgC1JUSOBD3f+GLggvrTEKypBrNH8Z8JE6fFB/kJWhEiegG96D3i6D1TrQ3ltDC/55jKNqoC47vIFQtAbEWuy589hfTARcVTKBpZaz8SiS/HUfUhq3nXUfLO2XUBYgBcqNPfcl/ZX4kQzZnYyDrQYoaZUl6bXYmNqJgc19qkatsYf1ginEskCotuZ+FRy+7KrNzdQ1XuXkSVGoxh7MyAoJ2A2q1MIbKlDUDRDJ8ZK1AE/e8p5papWF3D12Qzb2Zn943hxf+8RAVsrqBn3d4NQZiTWC48QsS2TGLAxiX5e+tqzK2o9wvMOSh2LRP6sOLHiFINm9tZ+UxrbJXKNuWwxMKS8+vcVxkgMkp7GJbLI6chPyjFOFh9a6uyqYtAZrzDT1h5FQ0J8ebloQU965vtczaKtyun07PGaZghZKyA6IjA0+bJGFYlXMCBaB2Jggc6eVuW2d6zWzHk+3TFUoMwM+hGu3/c3ihg68nwyuFrSG2LcKrB2UsL8ouc88aX2CdWipI83WfbhUSUsZjM+EkPwAlruSG6YYGCMY4O1pU5VjKjc1Q7yIYoG9nPUgsT0TOVjPp+P5L1x/Af0CDmG5gbapUGxL7lnVCOmjCWjsV4pE9kOJ3nn2uF6mKsrKC/qpslfxPUNYyeugU6/fapHZTKmhQJ+zXtQOq8hPFx1pN6jD1UA0hulMTYr8jxkreBQ3/g/P8e2GKh6VxMyeq+3ZV7Tk4Vp0ZFywNkc4vK2TVyK2qNGMODrJ0fybzRidKiuXL0NPa7UTi3RiMheCtwWrs6AKaZ03YPHlpA5SBN/YaqTS/qBU3MGHAiSvC6wx+HkNteg+7OeyKmm7WjxzO03eTE0ljmEpBEwHY
 HjSd8nRu
 P4VTWtsIYqb3zDsW/RWxtOV0cytAeGd0N8WpOwn+9KA/a4fhuN3boF+ZI+B4h+1SBp3zniMrNmPLoB5cG+Y2rWe0hZlmLyDrmT6Rpj3LH6gfX5mmUOGl8MVMLPDw9YxG+YLJKZ9hTWolb5mijqYnYupB7FfIaDIA5ngR9gHxLcN2WNdEZI8mSzErJ96MpP7l7V33pT1VFDoVlQAHFj4+TodynuTvkF/O1F5T3TFJFUidocta9I4woK8oIpUELM+DIJ+wiKODlhHTiqzawV7gu42HaHhVkixgyKlURQNXTKqqt3w3DFfl3vZfd+brHWHkL0Hr06MUmtfBrSLg0uUGZA/7fkIGoAHET4dAj1FG0XdxhsZkt6wL20zXaUwm5X3JCrGrx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 14:31, David Hildenbrand (Arm) wrote:
> On 2/2/26 16:56, Kiryl Shutsemau wrote:
>> If page->compound_info encodes a mask, it is expected that vmemmap to be
>> naturally aligned to the maximum folio size.
>>
>> Add a VM_BUG_ON() to check the alignment.
>>
>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> ---
>>   mm/sparse.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index b5b2b6f7041b..6c9b62607f3f 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -600,6 +600,13 @@ void __init sparse_init(void)
>>       BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
>>       memblocks_present();
>> +    if (compound_info_has_mask()) {
>> +        unsigned long alignment;
>> +
>> +        alignment = MAX_FOLIO_NR_PAGES * sizeof(struct page);
>> +        VM_BUG_ON(!IS_ALIGNED((unsigned long) pfn_to_page(0), 
>> alignment));
> 
> No VM_BUG_ON. VM_WARN_ON_ONCE() should be good enough, no?
> 
> As discussed in the other thread, is checking for MAX_FOLIO_NR_PAGES 
> alignment sufficient?

And after further discussions, we could use MAX_FOLIO_VMEMMAP_ALIGN 
macro once we have that.

-- 
Cheers,

David

