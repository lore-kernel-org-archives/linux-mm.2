Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FF5ACF34C0
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 14:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCB356B008C; Wed, 19 Nov 2025 09:46:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C550B6B00C2; Wed, 19 Nov 2025 09:46:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B43BC6B00C3; Wed, 19 Nov 2025 09:46:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A1FA26B008C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:46:24 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 54E331A0298
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:46:24 +0000 (UTC)
X-FDA: 84127632288.22.113402C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id A1EFA1C000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:46:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UJ08OGem;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763563582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=07p4ZrFfytEA9vNIQLVKGymPxLyj0agyqGjCmg/aUOQ=;
	b=yMiQB7REhmxBu2+kjmkcTlSVyTST1iX76a8cqVS8AjDzHea1I1T2pD2X6RrbSLytSNbLtY
	HTnyP930l7kyGSLz9xDXlUT4s+ybAfqEfR3msj2motZe3Yk/shdqU2hUbYuIr/hNIlM+3s
	gJVAboX+UCapQlDFgOpbpd5Jpd3B3gU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763563582; a=rsa-sha256;
	cv=none;
	b=wtaTUc5pgY/6lQKNchs2xfVqYEMacpopWQUyEnOYhR1H6cej46k7VvNbYEucdDzSsI6rA8
	uL2yUMo0+npFmXLP6qdAUlRASXpCuLJg0kQBwj7+a5CqQ2XLJYa5LEvYxsPixQ7hCgOVFt
	7dsE0QVyOmffBKjjojaHSeS9wPQVCLs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UJ08OGem;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 75C7541530;
	Wed, 19 Nov 2025 14:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F23C19423;
	Wed, 19 Nov 2025 14:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763563581;
	bh=flOy/nWQ0wLVWoCwxnbCEkms8GbhSC0jwYnCdil2gFs=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=UJ08OGemkRMHs/5BP9p6GxgNAJ3FfXkNSl61nyBQgUU1OOaQHXFuquLRTowbdkzWX
	 BpgTZbNM5/rdpcm4mXW+7H63io0Kn+vgdf8poUwDvYL3vTEbOJX4HY3kcz3yfqHf4B
	 6FWaR3gZglexrsjYE90E3lX6mvF1ofMUU23OG1APHtHIQlpTuRF0wPTMN3SONtFTUt
	 AFUmlWj3WIgLc8IlQzyUkFKJlW8RJlgYsJW/7Zo8R3wRO86neZ/sIL56mBYAL8JT8D
	 A/CAnPKnDtKarm8pGVC/ziVgzbPp6PTdP618XmoWM42rqlPsdUoQeDaSOdLw1tA7Rv
	 M9FMgQ4C8RzBg==
Message-ID: <14253d62-0a85-4f61-aed6-72da17bcef77@kernel.org>
Date: Wed, 19 Nov 2025 15:46:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix NULL pointer deference when splitting
 shmem folio in swap cache
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20251119012630.14701-1-richard.weiyang@gmail.com>
 <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
 <20251119122325.cxolq3kalokhlvop@master>
 <59b1d49f-42f5-4e7e-ae23-7d96cff5b035@kernel.org>
 <950DEF53-2447-46FA-83D4-5D119C660521@nvidia.com>
 <4f9df538-f918-4036-b72c-3356a4fff81e@kernel.org>
 <FA37F8FD-DDAB-43B0-9BEA-2AC25986767E@nvidia.com>
 <822641bc-daea-46e1-b2cb-77528c32dae6@kernel.org>
Content-Language: en-US
In-Reply-To: <822641bc-daea-46e1-b2cb-77528c32dae6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: A1EFA1C000A
X-Stat-Signature: 7ad9ewmj7ufrq1xyh9zpyz6edeerek4h
X-HE-Tag: 1763563582-3899
X-HE-Meta: U2FsdGVkX192FQOuolbPhBmq4iZF+Qe4aY/LQihvIhaypfwoqeZBV0FN/FPQEyiiIFzDTBFv89vnFylq0U8q38jsxhuAHpdfRusmwfcMc6wlb3+LX6Q1Gd/+BKk9Zd1a/7zM+5EuFNNDZ+eSpLdJMGrK/5K89Stq4HuIPBbRT/ecxHouujKUpxfR8tsw6pev/1S/VXUv9hgY9Jlhq1yrHf2/L0k4aq+JZfqs2oulfNLUpsx99HjouMRihd9RcoWopk4y5S22IvK0TMEo+J439fwY9zOOTuF7lDJPfwJRp+6DnLO41d0dtV9ZmCUvg/aFIRXa6wrqXN/RHtJnOJO5F8eKCies4Z1zDJ1GuUK8c3V9dos0z/9NsWogO04NGFpSaIjWtcuV8MMc+BR0n9EHcaQxgj1T2nwxcm9ZYN3p/YvJ7ECh8wP0NnZrd+ro+z+aHsHKDdL46FmwnPvolG9DdTECvGvHApJ2B1wGU22AqYQBusFGoxJ7BtSLYEzFj4Sce7sSUW02eEweQSARtIMn/zXDxsyKTXTGVCgdgSebfLqk0VNMkdAdbKmfFZRdfChWIkg20OalWEs620549uLSuvCid1z+X5iXdEMiDBsdzT2AeaxXemRn2iRxjAq8pZm/19UJf3lrosZRNDT4ZhqZPPB5Gs2iz7DCcuhktZjS82ByBofvhmaAa6/rIYoSBgou6JBL9IgQ7Z8vZNMDJzxYR/rG5TnenuswcKNeSy7jqeIfRtSjnYGaQ1u0/8Zp6KWfdywR4yb6uRLU7hOAyBWq3bTNCNWnDJ+DE7qiv49BP5AekPTtyXuJb/oBb19uqPNFEDHpGmi7qDvH1nmN9b9GbzwYz28F4I232MY2EJP7X6Zk77604c1V26rZ1Fp9nQ0cfLdenydXR39CU+hR+Qx8OVMoygiXBKSGTjzUqMxdR8+MJobmcl8PWSpYHkKsUAS4yQDBObdPdXXdQ4EeCoC
 9vruJAYm
 B0PSNNXVTcdlaMGhx5lJWlN5C/3hykmJYBVZK//raBZPlSds=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.11.25 15:37, David Hildenbrand (Red Hat) wrote:
>>> Given folio_test_swapcache() might have false positives,
>>> I assume we'd need a
>>>
>>> 	folio_test_swapbacked() && folio_test_swapcache(folio)
>>>
>>> To detect large large shmem folios in the swapcache in all cases here.
>>>
>>> Something like the following would hopefully do:
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 2f2a521e5d683..57aab66bedbea 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3515,6 +3515,13 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>           return ret;
>>>    }
>>>    +static bool folio_test_shmem_swapcache(struct folio *folio)
>>> +{
>>> +       VM_WARN_ON_ONCE_FOLIO(folio_test_anon(folio), folio);
>>> +       /* These folios do not have folio->mapping set. */
>>> +       return folio_test_swapbacked(folio) && folio_test_swapcache(folio);
>>> +}
>>> +
>>>    bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>>>                   bool warns)
>>>    {
>>> @@ -3524,6 +3531,9 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>>>                                   "Cannot split to order-1 folio");
>>>                   if (new_order == 1)
>>>                           return false;
>>> +       } else if (folio_test_shmem_swapcache(folio)) {
>>> +               /* TODO: support shmem folios that are in the swapcache. */
>>> +               return false;
>>
>> With this, truncated shmem returns -EINVALID instead of -EBUSY now.
>> Can s390_wiggle_split_folio() such folios?
> 
> [noting that s390_wiggle_split_folio() was just one caller where I new
> the return value differs. I suspect there might be more.]
> 
> I am still not clear on that one.
> 
> s390x obtains the folio while walking the page tables. In case it gets
> -EBUSY it simply retries to obtain the folio from the page tables.
> 
> So assuming there was concurrent truncation and we returned -EBUSY, it
> would just retry walking the page tables (trigger a fault to map a
> folio) and retry with that one.
> 
> I would assume that the shmem folio in the swapcache could never have
> worked before, and that there is no way to make progress really.
> 
> In other words: do we know how we can end up with a shmem folio that is
> in the swapcache and does not have folio->mapping set?
> 
> Could that think still be mapped into the page tables? (I hope not, but
> right now I am confused how that can happen )
> 

Ah, my memory comes back.

vmscan triggers shmem_writeout() after unmapping the folio and after making sure that there are no unexpected folio references.

shmem_writeout() will do the shmem_delete_from_page_cache() where we set folio->mapping = NULL.

So anything walking the page tables (like s390x) could never find it.


Such shmem folios really cannot get split right now until we either reclaimed them (-> freed) or until shmem_swapin_folio() re-obtained them from the swapcache to re-add them to the swapcache through shmem_add_to_page_cache().

So maybe we can just make our life easy and just keep returning -EBUSY for this scenario for the time being?

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2f2a521e5d683..5ce86882b2727 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3619,6 +3619,16 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
         if (folio != page_folio(split_at) || folio != page_folio(lock_at))
                 return -EINVAL;
  
+       /*
+        * Folios that just got truncated cannot get split. Signal to the
+        * caller that there was a race.
+        *
+        * TODO: this will also currently refuse shmem folios that are in
+        * the swapcache.
+        */
+       if (!is_anon && !folio->mapping)
+               return -EBUSY;
+
         if (new_order >= folio_order(folio))
                 return -EINVAL;
  
@@ -3659,17 +3669,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
                 gfp_t gfp;
  
                 mapping = folio->mapping;
-
-               /* Truncated ? */
-               /*
-                * TODO: add support for large shmem folio in swap cache.
-                * When shmem is in swap cache, mapping is NULL and
-                * folio_test_swapcache() is true.
-                */
-               if (!mapping) {
-                       ret = -EBUSY;
-                       goto out;
-               }
+               VM_WARN_ON_ONCE_FOLIO(!mapping, folio);
  
                 min_order = mapping_min_folio_order(folio->mapping);
                 if (new_order < min_order) {


-- 
Cheers

David

