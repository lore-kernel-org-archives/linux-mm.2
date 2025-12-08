Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21178D3B7DD
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 08:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ADF26B0005; Mon,  8 Dec 2025 03:51:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 765026B0007; Mon,  8 Dec 2025 03:51:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6749C6B0008; Mon,  8 Dec 2025 03:51:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56B8F6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:51:37 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBC358B0E9
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 08:51:36 +0000 (UTC)
X-FDA: 84195685392.25.6390013
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id DD0654000D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 08:51:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cr1DCUmR;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765183895; a=rsa-sha256;
	cv=none;
	b=kHiLo1mWs5tqam19elO84lSqF5jShIe/q2AYF4wcdgEK18Hov8GEltvB7AyVI98DDzrT7p
	11oZIDp0FwaaalUjngfnL7UPjb+ZbYCd9H/LiS9tDlVf1zK6VzeJihQ0Vf4/kx13Xd4qh6
	/6D/OfSmnlhlv4SGBvvHNbTUzkFlqVY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cr1DCUmR;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765183895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZupgdnI9DnGIKI6Kb2R3FbGbwkmxc3TNKDnNAKjVIyw=;
	b=Fdahqb5DZruXw3AaagIkyOk5tN59vTcfI6P2LzqqxnIjASSxXwQf1jCmtCN1zYWjBn15Yz
	TR2Qj6nnS6v2yCJprRnHnSsCOuT/92bTXHM4PMo3ZxWenGKizglc16XGDJpc6X2W2+PwbO
	3P8mGHsssN5kf/TAJuo4LbozSagLJl4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA1F344237;
	Mon,  8 Dec 2025 08:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAE7C4CEF1;
	Mon,  8 Dec 2025 08:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765183893;
	bh=VJIYaAqKOVNUR+Rg7ZHgeKhTWwi4euQtMnCdZt/0PUE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Cr1DCUmRwq97YX8qI+fsQH6Nnatf0InWW3TZngZE6rYJvidws+6jIYYjKa5bz/lIJ
	 QoYjEKv1VH6g4Y74txefNK4WVb0kVzHyWc3ObUTBYEFcekosO9ijr9B/vFVzf1JPFw
	 cbOXfnN/6d7fN9dAWqV/90UufL1GrZtdlpgf+l4ZfpxeOa6kwTSwB/QrXK2Tt/Xyl8
	 VZ84ikJqfLUn9QVOdD/CCBfn0FitqNDB23iYppF+ERZHx64E0QZwuHCcYM+XC3tsUV
	 mn4rQrhzzs2jVESkwOwNLCVnuMQ+QXrki/YpHTOZzQtqMbEMAeNElw0NShmrE8+tiA
	 ohTB7nlmHwk7w==
Message-ID: <3563e215-1301-4c2e-8a4b-b690dfa643d1@kernel.org>
Date: Mon, 8 Dec 2025 09:51:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] mm/hugetlb: Eliminate fake head pages from vmemmap
 optimization
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Usama Arif <usamaarif642@gmail.com>, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20251205194351.1646318-1-kas@kernel.org>
 <e1c50f7e-cec4-4676-b5d6-f6446cd64ba5@kernel.org>
 <bdie34dgpltxd5ayvjvqkusx4thdrrebgllvwp333psfuu4vgj@bkfxg2c5sfr2>
 <01e5d0b3-dbf8-4f77-b38a-f48c46f7c31e@kernel.org>
 <ysvhofzg5mdtvxfujdsmffkuqna72pr52ehrpglmlhxnvwstas@xurgptkgtnbe>
 <1b659d59-b1c1-4910-baab-0eef7cda234f@kernel.org>
 <3v5hdubqnil6w54kimvbgapghj7irjp7xuqma6uxtsrpvj22ph@6t47vsevdwyi>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <3v5hdubqnil6w54kimvbgapghj7irjp7xuqma6uxtsrpvj22ph@6t47vsevdwyi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DD0654000D
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: mfb1khht3hm8345ah1o1sguzbn6de9cw
X-HE-Tag: 1765183894-540396
X-HE-Meta: U2FsdGVkX1+NnXE/CDfbc19dy0X2M69T7jr6fE0OruQuD31TBLV7Eufifw95jk/3o6xykl1CPSwsBPq/hxgI4VfqnWxGEa5lspz8gtsXFn5Psie2tCLmxlbmsVNsjOLK11WRDWh0cJw6/ysuky6Q5npXpKhQaFii3rpcvGTzL3DJubflgfXkSpMgxdUr/R4yi8CD57OXRySX5vIzvdLlKh3//7n7Tr/S70y1SEd0/UGmTypWYUBL83vhrdT+UCcxXHUcI0Rp3h/rd/lVycY9y+EJWRaA6k6aNwHCAkqJsg9yEwGww0bx3jTJ2nc7R7TORW42dbsATEKmNcBrfdWgrwl53lb8OLBXPHBWR//4Y98AOEXieVw3Oee7JluObqWlzYweTXzA5IMpBF8pQgDKQ9pK85XtHVdrZGV4NYvlNfqgI3wFBeQoUhD+4M9hPu1CA3KTqnFr7G5sLm7vq6SIjUrD4jfhtdJst5G5N6sU115tZ8j7nU7e3onEvs6LGe1gBo87+L6ZBPnqORvCY9pFGH28AeDYzWEqwRf3xE56wSbFKL2D3/vmiVPGnj1WeKNI0LqqjJQhLLwZzDr8pEOzXKIWBhUs3yK9LBO7KtV30P8uJKCdg7LFTi+K/2pfQ9M9bYIEP+4Z0+ySfBwlswirshvnwMghAlqd5vjylXSqaGNGmv4cFJZF6t3xmOCoJSy0As6r1Hn+pCILSiWD4yJXglyKgcKL6bbPMAqZOgMJ3hNrBRAtKiixi75ngIQg2YB4B+6YFZ02Q0+jAFFKqaNpTJium1uOP1vEgPZVDwQTLGRl0Gi4dDNXjleP2KLFkWISJpUZU2BWH2MAndR7XfPViLiYrsgvFIYPVnT4+V7ckQ+b9x8DKLUV4+q0JeNJr7zXLE4xCRMjZcXWb/TfXow80owmbhv37/x6O5YAvtD20yrzm+U0lAzLhOmkEP6hBXaMPfLXFyUADf1F++cXdh6
 4qhJYbZW
 e5gQA6TZd4NMhF3zje8S/XJTdTQve4pCwaCSHxnpH6sEIg7hloD/RAc0t0hUAT6O+sn73si0dinAyEGqrB7uWLaUWAcMmG4ixdpEBToh22gu2WTWEgki9H31JQwluAQBlmprLyu0hbENo9HkCOVSaW0Moqa508LWeLssP4o3ihiDJ7E3eaaFCj8mS40sJElhw9HBYQZ5FwSMAS5P/JjvjzeWSR89G7oIOuexmignGugsmKbAedbVn3pz/OVdOsPArrx+z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/5/25 22:41, Kiryl Shutsemau wrote:
> On Fri, Dec 05, 2025 at 10:34:48PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/5/25 21:54, Kiryl Shutsemau wrote:
>>> On Fri, Dec 05, 2025 at 09:44:30PM +0100, David Hildenbrand (Red Hat) wrote:
>>>> On 12/5/25 21:33, Kiryl Shutsemau wrote:
>>>>> On Fri, Dec 05, 2025 at 09:16:08PM +0100, David Hildenbrand (Red Hat) wrote:
>>>>>> On 12/5/25 20:43, Kiryl Shutsemau wrote:
>>>>>>> This series removes "fake head pages" from the HugeTLB vmemmap
>>>>>>> optimization (HVO) by changing how tail pages encode their relationship
>>>>>>> to the head page.
>>>>>>>
>>>>>>> It simplifies compound_head() and page_ref_add_unless(). Both are in the
>>>>>>> hot path.
>>>>>>>
>>>>>>> Background
>>>>>>> ==========
>>>>>>>
>>>>>>> HVO reduces memory overhead by freeing vmemmap pages for HugeTLB pages
>>>>>>> and remapping the freed virtual addresses to a single physical page.
>>>>>>> Previously, all tail page vmemmap entries were remapped to the first
>>>>>>> vmemmap page (containing the head struct page), creating "fake heads" -
>>>>>>> tail pages that appear to have PG_head set when accessed through the
>>>>>>> deduplicated vmemmap.
>>>>>>>
>>>>>>> This required special handling in compound_head() to detect and work
>>>>>>> around fake heads, adding complexity and overhead to a very hot path.
>>>>>>>
>>>>>>> New Approach
>>>>>>> ============
>>>>>>>
>>>>>>> For architectures/configs where sizeof(struct page) is a power of 2 (the
>>>>>>> common case), this series changes how position of the head page is encoded
>>>>>>> in the tail pages.
>>>>>>>
>>>>>>> Instead of storing a pointer to the head page, the ->compound_info
>>>>>>> (renamed from ->compound_head) now stores a mask.
>>>>>>
>>>>>> (we're in the merge window)
>>>>>>
>>>>>> That doesn't seem to be suitable for the memdesc plans, where we want all
>>>>>> tail pages do directly point at the allocated memdesc (e.g., struct folio),
>>>>>> no?
>>>>>
>>>>> Sure. My understanding is that it is going to eliminate a need in
>>>>> compound_head() completely. I don't see the conflict so far.
>>>>
>>>> Right. All compound_head pointers will point at the allocated memdesc.
>>>>
>>>> Would we still have to detect fake head pages though (at least for some
>>>> transition period)?
>>>
>>> If we need to detect if the memdesc is tail it should be as trivial as
>>> comparing the given memdesc to the memdesc - 1. If they match, you are
>>> looking at the tail.
>>
>> How could you assume memdesc - 1 exists without performing other checks?
> 
> Map zero page in front of every discontinuous vmemmap region :P

Good luck convincing memory hotplug maintainers about this added 
complexity when making vmemmap ranges (un)available ;)

-- 
Cheers

David

