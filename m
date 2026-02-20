Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67922C531FF
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 10:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B23476B0089; Fri, 20 Feb 2026 05:35:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADB0F6B008A; Fri, 20 Feb 2026 05:35:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E7736B008C; Fri, 20 Feb 2026 05:35:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8ABF96B0089
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:35:26 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E94B160C10
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:35:26 +0000 (UTC)
X-FDA: 84464478252.28.1BCDF2E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 74BD4A000C
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:35:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lv2YMWDp;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771583723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D7fkENdBGQTQkfZUDGMYyVQsOaU1EMp1r7khPJJKmuE=;
	b=7JqFANUDHG6W0435PBx0V7kXfAfGR86m7Us/0lrwcMda80V6MOXz9X9LvCZ9BcgCKKHp63
	ZSEfC1h2/2QhmG8YgFQIn7yjfDGxwIbLIJ5P2wg9ehwWBoAH0OInXl+KNi/gaU6pyI/BVF
	0bruNPkqpup8zy7wcxlrvCOMjLxLu+Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lv2YMWDp;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771583723; a=rsa-sha256;
	cv=none;
	b=RtmZssKUKQjHL1F+ezg7KWAVk7h5JnjX5KvrA4aHywlKqkGcV6S8kIyVb0Syjrw4Ipxfot
	22n+TiCpGKb6QpLMvdzVTawVUwWt0/KIVLuZs78OkaK6C21Cj6n2w/aTTwWSUGMMs+iRJx
	f+5d0jLA4N+aGCTJJN2YX0fBGq/DZwA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C777B6185F;
	Fri, 20 Feb 2026 10:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38ECC2BC87;
	Fri, 20 Feb 2026 10:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771583722;
	bh=8r95L0v5HL+YxU9vlLOKBH79FE+vYutpqUCr5kUGW5o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Lv2YMWDp7uE7yaxsztb3i0LlL2BjJ2uffnVurXVOYwqxR/7/HcGo2NUww6+rKZWkW
	 DzFOU/ehCwBgorR6mzyrjt923aZ/asEIf8he+7sNbGqyCi9WgxKgNRkEf4zPCXO/Ry
	 nz067tsW4OGWo8uWxR+1nMlIrb7W3N5rrcvnn//buxGjWkKov7eyDP1LVMTTj+9XtU
	 PvzQyY0VyVfL32kS3eJlqk6sO7nbFKyHvlB1vzTqL5nvAoM0lxt9VjEpyMrTtcQF8t
	 vL2bK4Zp/DmCpfIoiOj99ZDmmBFirNmNbTnsA3Jv5zqkW3czdKUVmClIB+y9g/2vrm
	 Nui4+Ugnqt6hA==
Message-ID: <dd01a49a-d655-49d6-b088-da01544de5c6@kernel.org>
Date: Fri, 20 Feb 2026 11:35:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Towards removing CONFIG_PAGE_MAPCOUNT
To: Zi Yan <ziy@nvidia.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org
References: <c3bb0140-942d-49d2-bdc3-210b55435356@kernel.org>
 <fe6afcc3-7539-4650-863b-04d971e89cfb@kernel.org>
 <F0B18B46-EC62-47F7-88FB-C55B0E7FAE1C@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <F0B18B46-EC62-47F7-88FB-C55B0E7FAE1C@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7znir1dtz7uu1448k5jyekxs6ppjk8qc
X-Rspam-User: 
X-Rspamd-Queue-Id: 74BD4A000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1771583723-205579
X-HE-Meta: U2FsdGVkX19TN/Db6kK7IMxd0bup8bqpdzb9g05jFKqr+i7mTKmOtxsNsu5G1dtD4SW8UWVepJ2GQWlO1eAqfBOzBQDBcQ79l3mn040mE2lBBnNVWeiHKKc55w8APuJwZvNoaVL9fgUZFXchi6Ta34QfxLrTgnydgVNIVGBBFznlX84UVsN2rbnYAVEC5Qe3+oNqq+UKzEJlWqXxFsIrRl0CUyaeUvJmzzgu5KPw06IrgzW5fwxzmkP/fC39Fe9+NmGVvUnA0t0I7RmQ5O2sMnzJvvOkifzuhDfbyl214z2obJ2jV57rhGnAY2ghwYkax5qiP5sNKHgghRpB45HjgMGCXAAjywkhV7eMjW5ogM2V5lfqLrYbu7IvrzMKwYCVvsDtxbLhdYfKNFojg8/o22gfP0u/Rp5zNOBtqalRDFrqZdeEY2octgEaUAoAOFi3ZCBq1DFuGE/HTqUtp4vE6oJfC3PWExQYgccZoIo27W+sHOHT4YsBNRCTfekWt9My7SqLM3necha9qOFFrqXuSV9BMhGeFSPzaCb+8cJ5y51yI5LaUeo2uhycbfWJ9BpnPib4ny6/tHD1jYAukZxRJOwAbRymL8eWka/uu7Eov16mWZPmts7zFVkViXyuZfXU/vKL1ywWB8BanoMyQOhBmKr9/OzxM+7iZcwKsyj7FhXX3xFb6Vj0ej5MSNp3UCOvkIdarCBx9zBinON/d0TOGxMU1BoLDJ//k5kpR3rLyUMg7wchQofDz7fbd7rJ2COO+Fp0tyKoRs1Ja2hxn9geOZsWm7dnf5deChh8aUnPl2NRuC+25JMd0HWEuKNWt5hFVoYDqmM+bJ9/2I+xSraYlHF8NvO2cgZMI9mhDdRffimO1jCrYyweLOegvtKGAdj2UiJ7czemg785Pc8uiReK5a+vj83r3KqI0kC7B0cptte0nqid0jhw/K2NSCo3QeVzHS4SUIXAoGdGyjAlq7l
 ZnJafIcW
 pjyX8kk4PQQpaCjKrSZ9tqU+24fXdcHPlfRabIabVqs05nkBPIl1UAWRHE465KgKQ47STLHIS2WmDc8XPKyHCz3XGjqKGXLW5xbt6nVPFarv9YOcIzsku/0dLbRzTBjHb/LircHRhw8H1I6DwARpgbIbEeAJ04fCD/mUT0udfpHt0YFNHKcNaJmGHtw0WEsLQoo7T1TLvC2GzW9e9494p3toTfXL+wSlKJGNaud54MJvuX8PP2wgPq0odXdy4/d2gfvcqgnG1HI3THXC3QV5wA429oSIwx/YOZ0oQr8EUoIagj2HwKZpLXLxxMma2FsFP10v7PuuhGa/HD0M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/19/26 18:07, Zi Yan wrote:
> On 17 Feb 2026, at 16:04, David Hildenbrand (Arm) wrote:
> 
>> Hi,
>>
>> although I like mapcounts very much, I'd rather prefer to not have mapcount work on my todo list.
>>
>> We now have CONFIG_NO_PAGE_MAPCOUNT in the kernel that doesn't touch any mapcount values of tail pages, which is great. But we still have CONFIG_PAGE_MAPCOUNT around, being used as default.
>>
>>
>> To make my dream come true, some things I have in mind are still pending. In particular, I want to:
>>
>> (a) Support mapping of folios > PMD through PMDs.
>>
>> (b) Get rid of CONFIG_PAGE_MAPCOUNT to stop messing with
>>      page->_mapcount on tail pages and to cleanup the rmap code.
>>
>> (c) Better detect partially-mapped anon folios with
>>      CONFIG_NO_PAGE_MAPCOUNT.
>>
>> + some other small things.
>>
>>
>> I discussed some of these challenges at LSF/MM 2024 [1], before we had CONFIG_NO_PAGE_MAPCOUNT. No we have it and we can discuss the next steps.
>>
>>
>> Sorting out (a) is fairly easy once we removed CONFIG_PAGE_MAPCOUNT: we'll primarily have to split folio->_entire_mapcount into folio->_pmd_mapcount and folio->_pud_mapcount.
> 
> Then, for PMD sized folio, _pmd_mapcount is its “_entire_mapcount”, for
> PUD sized folio, _pud_mapcount is its “_entire_mapcount”. For mulit-PMD
> or multi-PUD folio, _pmd_mapcount and _pud_mapcount are similar to
> _nr_pages_mapped but with PMD_NR/PUD_NR multiplier. Maybe we would have
> _pte_mapcount instead of _nr_pages_mapped?

What we'd have is essentially (ignoring hugetlb) is

* mapcount
* pmd_mapcount
* pud_mapcount

pte_mapcount = mapcount - pmd_mapcount - pud_mapcount

That is sufficient to calculate folio_average_page_mapcount().

There are some possible evolutions of this concept (but some other stuff 
would have to change), but above is what we would start with.

> 
>>
>> Sorting out (b) requires switching to CONFIG_NO_PAGE_MAPCOUNT first, which will imply some imprecision with large folios to:
>>
>> (1) Process memory stats: Pss + Uss accounting like "Pss" and "Shared_"
>>      vs "Private_" in /proc/$PID/smaps and /proc/$PID/smaps_rollup
>>
>> (2) PM_MMAP_EXCLUSIVE flag in /proc/$PID/pagemap
>>
>> (3) System memory stats: "mapped" memory like "AnonPages", "Mapped"
>>      and "Shmem" in /proc/meminfo
>>
>> And some other smaller things. While I think that all changes here should be fine, I want to be a bit careful and have a discussion on how to tackle it without realizing in a couple of releases that some use cases still require CONFIG_PAGE_MAPCOUNT.
>>
>> Sorting out (c) is a harder nut to crack, and I wonder to which degree we care and whether I am being too careful. I have some ideas that I want to discuss. One idea is to just remove the deferred split lists and let memory reclaim deal with that:
> 
> Or let a workqueue to walk rmap to check if an unmapped subpage indeed has
> no mapping left and put that folio in deferred_split list. Or let the
> deferred_list_scan does the rmap walk and decide whether to split the folio.

Exactly. That is one solution I had in mind and started prototyping at 
some point after LPC: flag folios as possibly-partially-mapped and let 
deferred splitting figure it out.

-- 
Cheers,

David

