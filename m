Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E471E6F07C
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 10:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D756B0005; Tue, 23 Dec 2025 05:05:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDBA16B0089; Tue, 23 Dec 2025 05:05:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE6B96B008A; Tue, 23 Dec 2025 05:05:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A9BD26B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:05:18 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5F4ACB55DD
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 10:05:18 +0000 (UTC)
X-FDA: 84250303116.03.F537076
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A9109A000E
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 10:05:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oJoWzDS7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766484316; a=rsa-sha256;
	cv=none;
	b=zPF3RTgpHcMhK1QOwSCBhXf6vvmWqQIFKFmiIxmXlYXPr3oRScYJqQ8oBELAVF3r8RLLhS
	rfCxotAbKu2A9g7BPM9k63G8iahY+X0cii4lZd/0T6Ilghx5r92AXl0bR0z5eC6y+FA/K8
	XtLFnPACParwX9wf2KE6SxT+lTZUwJY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oJoWzDS7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766484316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X7reCOlyV5VVRA4BmBe3zqWeiVjSywNJBdWbyVINsW4=;
	b=VksGWwtqyaM5HTgW1h06z/YXhgPj5LO67Y04ljEjOEeLSN4o3xlKG6kTHt4tbbsmZYkGFL
	8gWNl/ZtefBEcbzYrVtGYy8CBuH7fQvaHxHHIZZ7njqdRko+cOSLr7bkR8FMIePuuI6Ade
	/0cTWb/HH9+NiLRLcSnC0xb6Bw34C58=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B37F42DFA;
	Tue, 23 Dec 2025 10:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C50C19423;
	Tue, 23 Dec 2025 10:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766484315;
	bh=/OJqifOWoyqm7WqvxpLIce+Bf8o0iv5oP5XqbYdtR7M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oJoWzDS78ytdfMpr0MttEkJNS9g35R7S2Q0KC76Uut40zYJwt7LM8oupLnkk9fl8G
	 OCD8p+fn4WYZdxZYAYbWLLgKCBY9N+smWwJCoMDdGA1wYFP4P/XVTe/TFp0bnbNvYx
	 xZBewuRQycsXLItOf9HNZMO21nb3q283HTXBGT4iDjLIvzD6lQlQuCxGTDozHrCmUk
	 y0pRizA0MQv+RP/y1VtsdoOlxNReW3Y1Eb767tdL42doG7GFmdNPUS/lehhvp73oLF
	 dgLDDHAWForw+JAtSMBZ18KLzd6rN5TBkvkqcE7IRtzLSJHwipLIX1dhnZBd+/56JT
	 cqZcP5kYvvHIQ==
Message-ID: <ab1eb404-f51c-4c02-95d5-93c108a81e34@kernel.org>
Date: Tue, 23 Dec 2025 11:05:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3] mm/huge_memory: simplify page tracking in remap_page()
 during folio split
To: Andrew Morton <akpm@linux-foundation.org>,
 Wei Yang <richard.weiyang@gmail.com>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
References: <20251222134531.20968-1-richard.weiyang@gmail.com>
 <20251222101419.10e73a9f2b35df440abd8a62@linux-foundation.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251222101419.10e73a9f2b35df440abd8a62@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A9109A000E
X-Stat-Signature: 4x3a4k5kekp99tyzmhpggzm1bff3aw96
X-Rspam-User: 
X-HE-Tag: 1766484316-810726
X-HE-Meta: U2FsdGVkX1+BnMz00l9TjJL+wYEGM8naUA0I5mq5AqA8MNAZf/kvbSAJHsa79L4i6iclRf9gxhxe7XvcKTmByFPhVn8Hf934AxvmTVuwmrhp+cpMIOw1kpg0o6ZwnePvhypF0qHCe6TJi9TpzSsx+o39Ldr3ap6GzCGZfX1SlUzl2qOufuRQA4FVFT62pepYTHtqm9gUrTzmgSjCux0IzesOZ7h6iRNC8gZ+Fr+iMjQDFPJxE5wlx6rpA/oMXHFgZ164DSvN4mMW0tx5/t3xKWtn0sYUpyCAbJ7X4Q73F1OPi4ffu2G626Z3h3j8tZTidD1i6w8cb2tOSKFfvpUGCCYpin92NLkixa0BOMzRCkNKiwkC7XSx13aQd8vYlw/8fxCIO9mojuu2+GR9+NmbmrFrMriEo2PkKU3tL135IZZBH9b9GZy05qjPIGc5b1BECb3itvw2GVF1IqzUkEbxzX/akaONi+Q5lXnDWbZG6i4v4tSXjmM9ii9biHFBNN3hJx0zEoYdk9S1t9wSqSBG+0CnjaGdxfWLOOIwx55oT+9iR9T3Z588lrapazOu/us8frksRzC7weK9A5qiE0heQ1S9RF/Aoo/qs6eLhEUJCK8NG/kAe9oFNIzpISHrwC7ONNbGPehhlnsJo272OhJvU5XPNsybGd6NWQoEZG0sO9r+FsGwtdCpHV4SlHbRVcN5ZOcDJsB2b7omfq1nepiBgINN0ZuRMVwpK5CoWHEgOqhIQpjMVGZ0iqzXU+VxyX2VBVT1w/alUE7/85nfRrsyLqQ1K00xGlKQb3vyuV0jeithDVqNGFHf3iTPVQsa0tb4YDOYZx/cEuxB3NyWmx4ycRWsU33dgPNQyIZwG95pXIGjp4RxbJEegfroTULOclOtTbyKDAxTyzuyHTr6zVWy2OU1kR3GgbNi7rYE8Q2JBvWmOTVKWLRIhzzbxTGQn8C+BdwgEBBWJPwTrCRN8/d
 e+G3UEFJ
 xvgG+Ds9SRU21soJtQzuHp8rzs7QxbmYaoNYwFq4e3qioSrrLDRl6kZx2f9yd0kw+k1rRQgmmrAx203TY6CEj2DcFyutcnaPqnJW/g9kB/sfWv6soS1zgtfrOhUba1AQq38cs/mkbFOg6OsILzGvOsS3k83l/kGzUKIcifUIEZoL0DHGjCXqxjTNsPEtbgi7rdLebng9gcis1yZzoWjK3LwyZqzvHm6dQZbCSJhpDQvMw5ow88fCECi2/JVYnSedVPSy/+y1M7WNmmvpD4xbpjIjY7gd5BagLNcaELsV+1YgP9cZlkARg2OdFzohILLdF0vV1uqFFy1UmnWLZ5m6ezvVMEQ3oDFWwyu/9QVzGUyyLbsXM2t3KzbSNZpm/8xuPiKVFpbzJ7fNLqVE9kQc/Q/BFqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/22/25 19:14, Andrew Morton wrote:
> On Mon, 22 Dec 2025 13:45:31 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
> 
>> After splitting a large folio, the resulting anonymous folios must be
>> remapped.
>>
>> Currently, the code tracks progress by recording the number of processed
>> pages in an index variable (e.g., @i) and comparing it against the
>> total. This commit simplifies the logic by directly subtracting the
>> processed pages from the remaining count. This approach is more
>> straightforward and reduces the number of local variables.
>>
>> Additionally, this commit renames the variable nr to nr_pages to improve
>> code readability and self-documentation.
>>
>> ...
>>
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3423,17 +3423,15 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>>   	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
>>   }
>>   
>> -static void remap_page(struct folio *folio, unsigned long nr, int flags)
>> +static void remap_page(struct folio *folio, unsigned long nr_pages, int flags)
>>   {
>> -	int i = 0;
>> -
>>   	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
>>   	if (!folio_test_anon(folio))
>>   		return;
>>   	for (;;) {
>>   		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
>> -		i += folio_nr_pages(folio);
>> -		if (i >= nr)
>> +		nr_pages -= folio_nr_pages(folio);
>> +		if (!nr_pages)
>>   			break;
>>   		folio = folio_next(folio);
>>   	}
> 
> This changes behavior when nr_pages was too large.  It would be best to
> mention this and to describe why this is OK.  Or to check for
> ((signed)nr_pages <= 0).
> 
> Also, isn't it a bit nasty to alter an incoming arg?  I think it's best
> to treat all those as const - part of the function's calling
> environment.  Yes, C permits this hack but that was a mistake!

For small functions I think it's quite acceptable.

But yeah, for bigger functions it can happen too easily that one ends up 
reusing a now-modified value by mistake.

-- 
Cheers

David

