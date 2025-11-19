Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E609CF34A9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 12:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF1A56B00A4; Wed, 19 Nov 2025 07:54:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2026B00AF; Wed, 19 Nov 2025 07:54:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE3F96B00A4; Wed, 19 Nov 2025 07:54:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BDDA16B00A4
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:54:56 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E8A888553
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:54:56 +0000 (UTC)
X-FDA: 84127351392.11.A61AD74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 851FA1C0006
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:54:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=onMr3WZN;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763556894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kodpPKa2SKf19OxkMO6e/uBCehBoanD0UvjYM0WCRM=;
	b=lk7bRs2YxHFzCG1jJR7Ounj4pE6Ps3Pfec2lrrUFNVcNfswcDS/pmJqM+1gPIrsijFNnRh
	DE6qhJ7efRzNfJR72SXhbNaf7mlSvmxcJlsXKZEiiSlA+OBpplXlkmrAPSaMbd8Tuhkyrj
	CaInq57I4lRUuPkzuLUAsAqNdMuhhls=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=onMr3WZN;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763556894; a=rsa-sha256;
	cv=none;
	b=8RQqmEYTxiWMbT80shplgsYx5KpLU/eZVnN6oHIlkMTE+EeFq+UuDO7c2HA2wZHRfvBcVO
	1rXQsLwPPLhwpm2CumbIOW864G1NtOqxIDkUxAq0Hxyfx8k1DR7jhKH55GtRSym0jUHXbK
	Z2rccVBQYmky1YG0Z2Bfh4yLuB4DzQ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 17C174379B;
	Wed, 19 Nov 2025 12:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062DEC2BC87;
	Wed, 19 Nov 2025 12:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763556892;
	bh=pEzIFnffdX0dHeSUOEWfyrJx4vS+HbyKds+OL9ZS4Yc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=onMr3WZNqee7RsOHlX1laMRPO98IL+mncRJmjC9IzvDxZiO1ZHUH6LrS7gXQnCkrm
	 XYZO6nhXifE2Ac9d1BlxZO/JwLmyiQQ8/H/QusIzj7dCtiCbUSjdCVVKN4KpRzPop1
	 VZ2hWfoDvrPopZfn9299LCV8QvOq5ek9rPL+3C5gO0BB2KvBYFQb8c3F4TkulErUEt
	 nr54hZE5BesF7WZrp/xsbhVZKovJvnjSreOo9PQVq90GC/aBPmGICm+vaeXXDtAqIV
	 60ndnsa6aivy3FwJ492whR411EePEkZk6awDTZBpO+9R6eqM0nAOWeKVRzlg/wVEAM
	 0v3dsr122e2Iw==
Message-ID: <59b1d49f-42f5-4e7e-ae23-7d96cff5b035@kernel.org>
Date: Wed, 19 Nov 2025 13:54:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix NULL pointer deference when splitting
 shmem folio in swap cache
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, stable@vger.kernel.org
References: <20251119012630.14701-1-richard.weiyang@gmail.com>
 <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
 <20251119122325.cxolq3kalokhlvop@master>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251119122325.cxolq3kalokhlvop@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 851FA1C0006
X-Stat-Signature: hp8ubt948cpnd4ahdsz5ak5emaz7jpmm
X-Rspam-User: 
X-HE-Tag: 1763556894-174990
X-HE-Meta: U2FsdGVkX1/Y5ewrzM5i9wPD9qIZHRz8RtYLvUQvjbAX5S+NlxzMPG0ja/4VcaW/O6rCcduQO5cUbHShEkCR515EOkQRYlI+/uxQUEv3DcYkFLwR+yXmL4OAt6BSDXX6J2m8Ry2wvtIP4CqP3xpnDqZII10EcbEW/QhMBi0xyX3qMOVE80X5WC7/X5LEWj5N1iA/0gDB89F0UEww0MP0906tqCopxDt6DO8Nj+BNQBD5l5P3f45t8TLNTxNMj8sqt4OJfGJoyDuLYzKLwo+Yqzb7Ici7JsZxUQ2hLgSqiGWeNrR6tcKkIEW4BKO3cTxprkxxS0l88X+ijhrfzDGI3k71bRwsfTYQbWeM5a0KLm7dYmSv09c+Ktnu6v85zBXJYICpvt+j6InQZOnN5mh1L2u01sJEOuvFC88w0LHEGihLAmVDubtREDbTHez6EVCOo+7Etca9FJJgW4tpyWlduR9c+xYAK/pL9uQyDbOIGxFlgXXXLdSEsE8UNbm3Y78eRPHdEggJ5Ro3YBjqwdoOWX8kALkxHGoQiNGN7ay2y1XAT02jrHduGeRrwUwZ7n3fE3XUj7V6yM5Ux7gaErRW8SnTZYCx4fVQnRiRCliwJ/f8YZRvVrhEcnocDn/57R6cUtJUOM8sord8L6inVePDmvwnyTOIOUI4fser/k3zTs6m++jlu5NfOQV+okYv00iaANRd/ZEsfLDa+83nJ9bo3bERojUy7UBhKCqAbeb5UK9/HpVcJIVI3bUmE5Q51Ntia5IYHFjospHbI2h32F53dx9D9/nMtuemOOC6VFLqDl4BGmdj9H6XvBsB1Frn0TcNdLWKP3wdTP86dvWFTN/ApA/bkm9HhEyzPZdubiDQpniWBVyps1YqdxNhEXvQoiTmK6NvMWMtxSA6/441I5DX+MjXEpMJsp6zi/wjasSKzL4MlAzkQXmD5lWq1XKMdb6iqsEoZQQ9pDWVijcqIXh
 HyE01g5g
 DNbrh7f+CLy5lo/0fG3Yf090g2vTHZBbze3Ho77mNsvoMWEzN6CgKzRWW95K4MTZgnU8ckAUVpZh70ZcEKEtRI/r9mKA0gSTmBrQM0r+JIobIwQBy4EGewI978uQggHQIoSUUg5+WsWXea6TvY8K7TorUrBM1Q4c+5YQbfn1BbpMIjrHBSnfVoOmNW4WyjPgOPhVkmvuCHb4ZN/36jilJ2pIeZ2Rci8l2a0/cPywyX9vhwkagkOs9+P08a0Rdy6psHmJJDQgaYwfS9x9bxfKjZ7sdnSBd1FHv6amU7Ep00McJzidI6QDI8xQXGYc6DMRex9HtvxqGnQ8TRfjobm1DknxcWZL4K6XpU0QJkFjEKPPW3jtF+OFKimdpk6c3Heq+cnDiGZ50TQImcC9ygyctR5JLoFT3H5hi/KxHddxWwBCFUpPYLCuri0dCZd7JmA4QbXn8a6heN20sjWUPqgc6uGNnRDPSpKYgxWma1YIhMegawvyG+NXuZY2CYpz5fyjvMoqp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
>> So I think we should try to keep truncation return -EBUSY. For the shmem
>> case, I think it's ok to return -EINVAL. I guess we can identify such folios
>> by checking for folio_test_swapcache().
>>
> 
> Hmm... Don't get how to do this nicely.
> 
> Looks we can't do it in folio_split_supported().
> 
> Or change folio_split_supported() return error code directly?


On upstream, I would do something like the following (untested):

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2f2a521e5d683..33fc3590867e2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3524,6 +3524,9 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
                                 "Cannot split to order-1 folio");
                 if (new_order == 1)
                         return false;
+       } else if (folio_test_swapcache(folio)) {
+               /* TODO: support shmem folios that are in the swapcache. */
+               return false;
         } else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
             !mapping_large_folio_support(folio->mapping)) {
                 /*
@@ -3556,6 +3559,9 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
                                 "Cannot split to order-1 folio");
                 if (new_order == 1)
                         return false;
+       } else if (folio_test_swapcache(folio)) {
+               /* TODO: support shmem folios that are in the swapcache. */
+               return false;
         } else  if (new_order) {
                 if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
                     !mapping_large_folio_support(folio->mapping)) {
@@ -3619,6 +3625,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
         if (folio != page_folio(split_at) || folio != page_folio(lock_at))
                 return -EINVAL;
  
+       /*
+        * Folios that just got truncated cannot get split. Signal to the
+        * caller that there was a race.
+        *
+        * TODO: support shmem folios that are in the swapcache.
+        */
+       if (!is_anon && !folio->mapping && !folio_test_swapcache(folio))
+               return -EBUSY;
+
         if (new_order >= folio_order(folio))
                 return -EINVAL;
  
@@ -3659,17 +3674,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
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


So rule out the truncated case earlier, leaving only the swapcache check to be handled
later.

Thoughts?

> 
>>
>> Probably worth mentioning that this was identified by code inspection?
>>
> 
> Agree.
> 
>>>
>>> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: <stable@vger.kernel.org>
>>
>> Hmm, what would this patch look like when based on current upstream? We'd
>> likely want to get that upstream asap.
>>
> 
> This depends whether we want it on top of [1].
> 
> Current upstream doesn't have it [1] and need to fix it in two places.
> 
> Andrew mention prefer a fixup version in [2].
> 
> [1]: lkml.kernel.org/r/20251106034155.21398-1-richard.weiyang@gmail.com
> [2]: lkml.kernel.org/r/20251118140658.9078de6aab719b2308996387@linux-foundation.org

As we will want to backport this patch, likely we want to have it apply on current master.

Bur Andrew can comment what he prefers in this case of a stable fix.

-- 
Cheers

David

