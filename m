Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43C85606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 02:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XBBWtXQO
Received: by kanga.kvack.org (Postfix)
	id 1C0AB6B05E4; Wed, 18 Nov 2026 21:40:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1721F6B05E5; Wed, 18 Nov 2026 21:40:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 087526B0636; Wed, 18 Nov 2026 21:40:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D171A6B05E4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:40:40 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2E10C08E8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:40:12 +0000 (UTC)
X-FDA: 85450314264.19.459AA2C
Received: from mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5F3B0C000A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:40:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XBBWtXQO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795056011;
	b=t5Yx5CNmgL+j21VJVqtSk070mA7rv1VJhvhZ5x7PvtpecijKTCNlzhg0rHbaJjtNjclFMh
	/7MH6KCE0T7uRUdL1lCSjk83c+hU2lFNxMmWtnDRs1Zko3O/tzqOAwl1vPSIYb6LKRqWet
	tjOxI15k087SVi9hZGB6Ob+ELRXjyGU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795056011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4eldt1poESacQhlEKIXWEYqmbMHzZtx9KsZXa9CMQjc=;
	b=3IKWQk40sXRVVZSJ/NIztfOiwWs02i43t/f+ItHj7RWnCGTLPgZJ0w2xgCdnbfWiLlkjfE
	Jw+hliwtwbasZWp5VEy/csnU2mxQDx2wdgux/SHnt4Q0lfKWQNVjF67h+WF4xWKNSKt4Dg
	5JgxM9sSwXaQF2mnClK8qmfkb/kY/Yg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XBBWtXQO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9pcJmRRsUuG+cdTHwFCyDqrJPxLVIT1eO5dRnb4HvdE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795056008; v=1; x=1795660808;
 b=XBBWtXQOQuSLuvwMtqVfj/iMVIf4tc9Tmd1Nrp9xy2tm31viK7vYLgo61MM1cszxcb1Xabmz
 v+7pNENlDdtYE5Ff5VSE1648FefXrY8sXzFXML+A65gh/dHfhW9PdGHS/BbBn7KjDFyNOfY/HKO
 u5MzYs64xnbYxy3a4XrFNiyU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f7668d8552ff7426;
	Thu, 19 Nov 2026 02:40:07 +0000
X-Mizu-Trace-ID: f7668d8552ff7426
X-Migadu-Flow: FLOW_OUT
Message-ID: <85341270-6c22-4a93-bd07-26ee58b88929@linux.dev>
Date: Thu, 19 Nov 2026 10:39:54 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: hongfu.li@linux.dev, Hugh Dickins <hughd@google.com>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH 1/2] mm/memfd: drop redundant hugetlb allocation mask
 narrowing
To: Muchun Song <muchun.song@linux.dev>
References: <20261117-for-memfd-v1-0-fa68f433171e@kylinos.cn>
 <20261117-for-memfd-v1-1-fa68f433171e@kylinos.cn>
 <87A66860-C0E1-42CF-AFF7-671D19B82E16@linux.dev>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <87A66860-C0E1-42CF-AFF7-671D19B82E16@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n1jdxdcd4mpbe4diknfm9katn4dnousj
X-Rspam-User:
X-Rspamd-Queue-Id: 5F3B0C000A
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795056010-538126
X-HE-Meta: U2FsdGVkX18SZmsecuS4jKyb1RS8ci+X2a3JU8vRQZyLWcO8haQhedIEuczlB+/NQ8UeIuooV45SUeJ1kXtd2ivpXazTVKlH31olgPVpKms4iDNMlnHZGz1SG6JiCVEQHmVTny2k61oHLMYC8cdh8uWjWZdYv+f6BMpKE7rhQuOk+5SBpGDvS8i7AzWBQZZagl+xaehCs1kNpDKPV3Z4AmUUMakB+xQqRqH11NoDWwuWmyt6NqTm0qGkXaL9IIE6Mf1VC/XJiPDGYP9T7FatPSaeFLUtg0Ug31y27kcztyA8YZhwNHBKnDy3pa7d3T1a29x/1VgSrV9jnPrUfyWzJ/TJ8lrpQ9oWIfakJqEnZRc+9y6sAmRWYJkxuDbNMDdxB2z9ycikq/i7eYMac5CGsJ4AheNWIyEo4V9ieWzCm6TZ6AWmpIybQx5OMVpGd5tBU8McBDELD4VrbQPtIoiDhHCkaYPC65BwKsu07INHJEbNci6JrlOt9tsUYL/haiWmrRQANzEsratqQ4cW6o3ZpgJcjzpJbCVSft4QHxokMPGgRb8z4WfNAbbd1jnpXs/qiXw7ehnyNjyMYzz9Pc1HVZla0h58T3J60gtera6BNIT/Zc12icHQ7vJ0PMQJPYvgkgrgX3MzFqu7pZ0zI+Xi2WJbDc2PDUQDZaq0X5g9FRYmt45/9bhjLJBYJiITH5ac01fNAgf5cW5CwCRJld/EK7q35Qjox5nqIslZ/fWDiOpa39NF6CVbAlO7HkTVrkTa3FSp21YaS8e6uTmcrilLSLjoucSkGuMgrhWXLcX31PDS+tyXH/Hl8zescHU3PVJXT9IpAGvTBCdWVE5PKWjH6I2heXIW4ti9t3SFdewVRfRnTLDO8lnS7Li/8Gy+SuCSRchfH5Qzp9xFCgQ+6fqoQ5+xnkfldrNsjhZVj5VfLtjttSrolsqeBfmyKYX1Vc5OFuLY4opThxKr9irJvCB
 bz3lattl
 v9XVLrxBR4bMU2mYrGhu5HghsvhbYSUiX0BLOgUN6IFmfoy/CLpFsBOvInz8RC8ho6Z2cSedVYojEWVVFDVf/tPkJdaML5jHdmVpHkUzuudRpLHCij4o6rYEEPGNx7JjiXwwAE0ETInAX9XGEz0TzS8O2rgioJ/ud9al3HZ7Yilorr5z/Cux+6x/sf26EqBviCGCyVfmAOOZ3DwnjWbmkGRCxVqGx6AvuEVG/TdZXMg8SVH6ktH3PNs12rUcfOST2+Y2rGkIgNBW6ezrTCjOxFSUDwstl2pkouLqhYtQDPA7k8yoUYguMtvVnh3xD6QYclMdZcbtupUqFkHDBTEQ8cxm6Vz8DamfrM7zSfiI/EVd9CDv+XnqerBoE2M9RlUG1S5r3Mp0xGtFA+PqOb5sb97QzUKFRyKvXbh1KBYCiC23LnVywyDiJwXVjC6LIhnJ8Dgm/IzE8KN5+51TZbBeuz0wZVjn+qWP/3SXtpS8qDxUsxILZUqi7C04QgJh9JzuOrCDpoVCtE8Z9jJ3Lj5Kl4Fx1zzP50n0BQG4E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


在 11/18/26 19:47, Muchun Song 写道:
>
>> On Nov 17, 2026, at 18:53, Hongfu Li <hongfu.li@linux.dev> wrote:
>>
>> From: Hongfu Li <lihongfu@kylinos.cn>
>>
>> memfd_alloc_folio() derives its allocation mask from htlb_alloc_mask()
>> and then clears __GFP_HIGHMEM and __GFP_MOVABLE. This mask handling was
>> introduced by commit 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios()
>> for pinning memfd folios"), when the fallback path in
>> alloc_hugetlb_folio_nodemask() could still call
>> alloc_migrate_hugetlb_folio() and reach the buddy allocator, so the mask
>> decided the zone and migratetype of freshly allocated pages.
>>
>> Since commit 26a8ea80929c ("mm/hugetlb: fix memfd_pin_folios
>> resv_huge_pages leak"), this call site uses alloc_hugetlb_folio_reserve(),
>> which only dequeues folios from the existing hugetlb pool and never falls
>> back to the buddy allocator. The mask therefore no longer decides where
>> any page comes from.
>>
>> Long-term pinning safety no longer depends on the mask either:
>> memfd_pin_folios() obtains its folios (dequeued from the pool, or freshly
>> allocated) under memalloc_pin_save(), so PF_MEMALLOC_PIN makes
>> dequeue_hugetlb_folio_node_exact() skip any folio that fails
>> folio_is_longterm_pinnable(), and current_gfp_context() already clears
>> __GFP_MOVABLE from any page allocator request made under PF_MEMALLOC_PIN.
>>
>> Drop the narrowing, which has had no effect since 26a8ea80929c.
>>
>> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
>> ---
>> mm/memfd.c | 1 -
>> 1 file changed, 1 deletion(-)
>>
>> diff --git a/mm/memfd.c b/mm/memfd.c
>> index 0e3ff3eebfa8..8905e3e9efc8 100644
>> --- a/mm/memfd.c
>> +++ b/mm/memfd.c
>> @@ -85,7 +85,6 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
>> 	u32 hash;
>>
>> 	gfp_mask = htlb_alloc_mask(h);
>> -	gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
> You didn't mention why __GFP_HIGHMEM can be removed safely. I have to
> investigate the reason myself.
>
> During review, __GFP_HIGHMEM was cleared because "these pages might need
> to be accessible by some DMA driver, so you have HIGHMEM constraints.",
> refer to https://lore.kernel.org/all/ZmvNLSUgUgFETR0M@localhost.localdomain/
>
> I think that restriction is unnecessary now: DMA and existing memfd_pin_folios()
> users operate on pages or scatterlists and support highmem, while the
> shmem path already permits highmem folios. The hugetlb path therefore
> does not need a separate lowmem constraint.

Hi Muchun,

Thanks a lot for the review, and for tracking down the __GFP_HIGHMEM
history yourself; the explanation is very clear and much appreciated.

I was not fully sure about that part, which is why the commit message did
not describe it much. I'll add the following to the commit message in v2:

Clearing __GFP_HIGHMEM was a lowmem constraint for these folios, which
were meant to be accessed by a DMA driver. It is not required any more:
the users of memfd_pin_folios() work on pages and scatterlists, which
support highmem, as does the shmem path with its default
GFP_HIGHUSER_MOVABLE mask.

> Because you have removed the constrains, why you didn't remove the comment
> along the way?
>
> 	/*
> 	 * The folio would most likely be accessed by a DMA driver,
> 	 * therefore, we have zone memory constraints where we can
> 	 * alloc from. Also, the folio will be pinned for an indefinite
> 	 * amount of time, so it is not expected to be migrated away.
> 	 */

You are right, that comment describes the zone constraints that patch 1
removes, so it is stale once the constraints are gone. I removed it in
patch 2, together with the mask computation. Will do that in v2: move the
removal into patch 1 and drop patch 2.

>> 	idx >>= huge_page_order(h);
>>
>> /*
>>
>> -- 
>> 2.54.0
>>
-- 
Best regards,
Hongfu


