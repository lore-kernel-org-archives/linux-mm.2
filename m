Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B573EC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 09:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACDA16B00A2; Tue,  7 Jul 2026 05:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7DE26B00A4; Tue,  7 Jul 2026 05:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96C9C6B00A5; Tue,  7 Jul 2026 05:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6557A6B00A2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:28:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5642E140386
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:28:51 +0000 (UTC)
X-FDA: 84961456062.30.3100964
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id A3DE814000B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:28:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KSQTh9/u";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783416529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJk7wa5Iey8ZXCCay2oQE5KRjSmBtrQLK5MUIYTrwzw=;
	b=lYNehQWhLjVCJjxslaqW2a14DlE/9QcGtXVHY+4HhQb7gFH6IUh4Au3swn9G1gm2jLEiWz
	s2y3o/DCSBJt+sUcrHH2EAPyoFc/sgdIJsShE0pI5mt6vi7B9QkCAqQ+FejbotUafQwxOR
	toZ37ripx12KfvqymPHcHmBuRxmMDnQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KSQTh9/u";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783416529;
	b=k82n3CSoCUHjiQBZbfOZmq3eTjh6yZgfGXR6tawuqMt9gcvnDKVAysm3Bd2DtvS8ssDGbW
	v8Tb8cmgy7gzajREoVwfD/BNBU1LvRAoYhwIi/OCnkyJ8mLiV/P+OXyHIx7/b186D5IaZt
	j/eKiY3QKeXaUs8O4klyHr1zzjgKrQU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DE9A618A6;
	Tue,  7 Jul 2026 09:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273CD1F000E9;
	Tue,  7 Jul 2026 09:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783416529;
	bh=XJk7wa5Iey8ZXCCay2oQE5KRjSmBtrQLK5MUIYTrwzw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KSQTh9/ubHH7JaMb7yuW6lCxLYkWQGOdjjP6EHaXgQ28ARKOM7xhzL867Jtkr3qfn
	 pXe6q9YeT1kkeKEcxTkOXTNLMBpS6JZXcKF151EFyQBCJhJDdsBU5bLje8jmHaFwA7
	 H77MtRPygRe3w4pLxzuiigxoEwy8932OJm1elVjKgyE4aVdXNBF1RKOrOZ9d3ZA3cF
	 vO66Dp9pZIUtj/k5JNBRPDoT7aPdvT/5mkPIvuPyTTRfk4KUTIapvmovyD5ykMCVdd
	 ARrDtgFvezrTJoxYRfcUzvZm6pp9RMFKVAt6pWmyFbPl+gbZWpfjvT7buGUvqq0JvZ
	 D/P5T0wAE9dpw==
Message-ID: <eea6fee8-f179-453d-9f50-ac23df1f48c7@kernel.org>
Date: Tue, 7 Jul 2026 11:28:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Standardize printing for pgtable entries
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: andriy.shevchenko@linux.intel.com, usama.arif@linux.dev,
 hughd@google.com, willy@infradead.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260707041703.658021-1-anshuman.khandual@arm.com>
 <5c128db1-7f82-4e2c-b029-5623880ea56d@kernel.org>
 <dcab355d-ca27-47f1-8421-c610a9e58365@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <dcab355d-ca27-47f1-8421-c610a9e58365@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: crxm9wuz63h9bduxx1p4do4sc55s9amg
X-Rspamd-Queue-Id: A3DE814000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783416529-721020
X-HE-Meta: U2FsdGVkX1/0banJu25XfhCEkE2DC8QeSNtAwc7wEMfMxw6U1jVSrk69fP4FsAJqWD39JwbGyCXDeEpOJMsu64an8nykTCo2pcOsvADz9OV+qFH5F4YxPzrqFyhPKcHWkptME3NoiV1oZlQGTxi7qyK453Esv17wv8JL7es83Qt1+fFNiq3HELoTVA7Q+PL8Xn/fqZLAsRHN8UwYKX20D7mzaSoVWPiI/XBgpDL+wt48ywTrE6iDkO8Hzc02O3EB7IPxCINjAsTj9qkPLF9DidgynHvR7F4uIOMK4ImVXKufeATEypxa65yL2Xchfo0QZ/OgKcrCZqgthoS/TvsGY93m2GAjRwXaX+ntgYd9ztk27tu+ZsH/op+vFIMSMDk30AEXUBDPMiCX+s6mMv/P2Y7ZHo9yThcxuDf4j79kVn78VD4QmOwJ2QzWgxQxnOtsmZ9WhGyh+VOf599cbXID9TocGF/oYwhQREBCe4El+M1b9TKDr93Vfdq2n9PFkipOVmIIofCK8PLB/r+cSEizp4RIMphKC4xOGRQI+iIlbEftOSMZTnHV5U48oDAoBQQzJfdVONkC0knhJEX6vv1wHLApOQ1N8zLR6aROwDTzGfm5HuDWqySUdNLlPiTYF4opDyjZ1RQLWFiItMnKhdO8wpxT2AHWF/wy04ne3PObjZC//TdCWOkqO8NdT+eiur0c7R8Xw47+TK9lKtvQyiQszSlV4ieRJ05gxLuGtzywQMi/1T4jMShXZNojEBsg0EibBjgE5BigjQrYt+b4xkq0aMEwFPSXAfkjctSqH/d7sI250f7oQ6xFJkzuhWuPqf+xn/tuPxCx5oH1WAvYxaWVYLqZIob8FRsLhIaIDfgneAQcTjqfF0b2Z9Zhul5V3/g6o3/PmCwb4cG8xmoWWiiW/ddoYahN9LSFQz3Dbt4eeDjo9ulSRA3Eg5wZ/KjOrvxdBFzcH6+W5WOZoQdSxfJ
 XdD+vlgR
 //rXRqKDrAqrp38FGwbwPUFNaNNn+R2yqH5eplDv7ace0c0NNOc61zozVn7XU5Ai2R4zSFTLYosqq0zjh/2VMa0IAfK33w6NAD4G+ctE8A+cyXhYTWHGElmoykFAHQJDsTGYYXeH3Pkc2G7SjqybdFjmTIreZQ5PJPeJ3NFXBHtbwgPZuod/yq6GZHOh56cOG+Mv2DjOroPHH2QR50ZGu5VuumAABynAPrjDLuaE/6iaaj5sjN4SmF4ABwviPksUOLer4NX6KoCbO0sV4VHkk/4fCtWvvPQuXn92+8K+4VnV3a+OwingKvG0OxmnVJ43V4cNZI5IZKJlhJOxWMv6bIBPyuC4uE6VC0QHOwYGwa2AtvsjWLvx5oLj6ii1g1/JHCMlnCBbhzVrAvhs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 10:58, Anshuman Khandual wrote:
> 
> 
> On 07/07/26 12:38 PM, David Hildenbrand (Arm) wrote:
>> On 7/7/26 06:17, Anshuman Khandual wrote:
>>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>>>
>>> Bad page map reporting currently stores page table entry values in an
>>> unsigned long long and prints them with fixed 64-bit-oriented format
>>> strings. This is inconsistent across call sites and does not work well for
>>> architectures where page table entry values are not naturally represented
>>> as 64-bit values, such as 32-bit or 128-bit entries.
>>>
>>> Introduce a common helper to convert raw page table entry values into a
>>> fixed-width hexadecimal string based on the actual entry size. Use it for
>>> bad page map reporting and for dumping the page table walk in
>>> __print_bad_page_map_pgtable().
>>>
>>> Pass page table entry values to the reporting path as raw bytes together
>>> with their size, instead of forcing them through an unsigned long long.
>>> It keeps the printed output consistent and avoids truncation or misleading
>>> formatting for non-64-bit page table entries.
>>>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: linux-mm@kvack.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>
>> You should add a Co-developed-by here :)
> 
> Have not done much changes from your original patch :)

Well, you did some :)

> 
>>> ---
>>
>> [...]
>>
>>> +
>>> +static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
>>> +{
>>> +	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
>>> +		snprintf(buf, buf_size, "overflow");
>>> +		return;
>>> +	}
>>> +
>>> +	switch (entry_size) {
>>> +	case sizeof(u32):
>>> +		snprintf(buf, buf_size, "%08x", *(const u32 *)entry);
>>> +		break;
>>> +	case sizeof(u64):
>>> +		snprintf(buf, buf_size, "%016llx", *(const u64 *)entry);
>>> +		break;
>>> +#if defined(__SIZEOF_INT128__)
>>> +	case sizeof(u128): {
>>> +		const u64 *val = entry;
>>> +
>>> +		if (IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
>>> +			snprintf(buf, buf_size, "%016llx%016llx", val[0], val[1]);
>>> +		else
>>> +			snprintf(buf, buf_size, "%016llx%016llx", val[1], val[0]);
>>> +		break;
>>
>> As discussed, can we simplify that by casting to (u128) and then shifting the
>> values into place?
> 
> which would be something like the following - had similar
> construct in D128 RFC V2 series as well.
> 
> snprintf(buf, buf_size, "%016llx%016llx",
> 	(unsigned long long)*(const u128 *)entry >> 64),
> 	(unsigned long long)*(const u128 *)entry;
> 
> I did think about it but is not the proposed chunk bit cleaner
> instead and easier to follow. Do you have concern regarding u64
> pointers into u128 then accessed in chunks ? Regardless don't
> have a strong opinion either way.

I think any removed endianess dependency is a thing worth considering :)

-- 
Cheers,

David

