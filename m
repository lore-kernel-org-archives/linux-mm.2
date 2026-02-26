Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75B4CFC591C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 10:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC22B6B0092; Thu, 26 Feb 2026 05:06:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62B86B0093; Thu, 26 Feb 2026 05:06:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86056B0095; Thu, 26 Feb 2026 05:06:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A4A296B0092
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:06:29 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36A8F8CACF
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:06:29 +0000 (UTC)
X-FDA: 84486178098.24.7D5CEE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5ECC9100002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:06:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RVfx1aLC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772100387; a=rsa-sha256;
	cv=none;
	b=hiLgCVS89o9JJc5QZu2TN4mwJhZyKfm1WEK5StPxZU9qci4YfInNhg0XYAD8mCWteYY50h
	HocJEgkhkB7WC7Wh1oeLwpWUyB3ipPxqZRBj1sRJeV/3EsGyuIrwcmnQZ6lVgRdAuwatvk
	LGPsadeQTcxhTX/RxsOm3vCJRX7Kz5E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RVfx1aLC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772100387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JtrtUSgCQeh3Rw2Fn/JXA71Qvme4jG+l3UE8ddeJyxE=;
	b=nMYcN+6Ftvx4Ete1F7KID7BPrb9lsbYLqvTkvDZBlUxrxmUBIP1v9At4Pj4fADb9qkLtbA
	Q8y2QiFsW3V6GKGzjbCHkqCw2M1R/hS97KZSm4Z9K9SwK0Kql7a/iAKaFvsbKaAm4wQ1G7
	TLtcfQPKgSYryaXOetykIyA8GFxlKTY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 20D3043EE7;
	Thu, 26 Feb 2026 10:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED8FC19422;
	Thu, 26 Feb 2026 10:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772100386;
	bh=45Zns+iP/oDv+AJi9pnKB/hFBYoQKB7TJG74cHZZyrc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RVfx1aLC/rgzPLjR+YcRHQ9QbMkTt7VfNKPsmzbBDUyihBicyXDn+/CeSp0q5fh/F
	 kjKWSDb2zclM9wXTPMaYjY7TuXRdjo3wVHYkEPQHl5TO3YrcmhTI8ElSfoLYFDjLno
	 Tnpicv8R/PgEavrSqwmG9XtEDSkeupZDbiLG8GqGN4c3SVz6DRQDzMYlmr38dgumMv
	 4bGZ6u2W69bswr2nr6Vsj063bCaR5yAK150vHGgOtsLE9QwvWy6yRGXCivwyIyoFqk
	 bv/Ix9i6Xr2zxWM0B04MCptDQmEspkcDA811RyRki4QGP+naiU+Jj+62wb86gvZBMx
	 PceWJ5vHKtGJQ==
Message-ID: <ece450e0-8e19-42bd-9a7a-fdfc7ab785e6@kernel.org>
Date: Thu, 26 Feb 2026 11:06:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: fix incorrect pte restoration for lazyfree
 folios
To: Lance Yang <lance.yang@linux.dev>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org,
 dev.jain@arm.com, harry.yoo@oracle.com, jannh@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, riel@surriel.com, stable@kernel.org,
 vbabka@kernel.org
References: <36e676b4-dc6f-45f7-b885-8685227ac6a8@kernel.org>
 <20260226070940.96226-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260226070940.96226-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: okkp19m54oz1xm81kj4k81kkshwjuz46
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5ECC9100002
X-HE-Tag: 1772100387-441561
X-HE-Meta: U2FsdGVkX18hx0m+qOUdoZ/mfwWb0AqXXtuCdq2bdYKx3yWYf0eWEqZLxQgtn9IhqxOVMTsC5KeA0wMIFQW/Ulst3hUTvDzhb0R3EpVd7bjFPvATy20IL4grOasadlSMAIMtFlVGA0xSjgH02MQKhCfzFtinNTTuyWWQhWpTdzZiUq5mHiQVXfwXRVId5PzWXy1WO7v77KHpTgMuRwBfw9cuDBYimhbSF79IdYaw/PVLuMMuekCK4lmWLVkmzCewSEZURtTNgExtDHTiQdsELYjmML8ek6CquU1UmJ2crLr7nZnQiseYlJmlf4oJyV7/9Qle9MEBRLsuvaTlDF1dGgtfqOOtRVvVlQi6LcjAG4SsOcanB4JgSVuD73R3JYzHCS2K4nULRj+yM6BfGIS3QqvtrfRTLB9wQukGzG18Q+QdpAoBQPSjb8oxJa2gnAKQnf1iUiGBTsXPuaxCash7qp0GSmJtLZ47wAy4K0x+ZsbQJ+928FiJgSKg2scJ2I1JHErXXqPpG7mSKBczAoUsLL4ediKdvjxx6eOTtAcY9U1NJNXLSmXZpU7tiYgQk4ECXmsNrrD+WwWIg7PUQuuc30pmoE3wB1WIg+xd7ATipA8di6C7spTTRU9BRPMrm7GlPgby9jxtDxO3QBV68ozk6fjFWoE26siU1CsNVIDtbvhHbtmTnXrrlhM6Yema9GjWQM9/E5rZPnulE7TmHxc4MUp2kYYmeAUfyYQvjBd37ls8BPDzg+NXpUGfcJJfjM3HH/antOvoG6d5xmYsBdS3ZWFU2juK2uthdqaZMEgOdLupeEGOPKL8HAG52qjM3Zc7j37gZVpwQduhWSZaGmXmZi0n7t2q5MuIYfEl/8DDe8pHh2Veij4wkGfUQKfenpisoJViyLb/X3ZZzCfy2b2uAooAaw8GF6gpBgb7GjyXkM+4E5MfDrn72JL2BgiClWuamaO2D3JgVGqM02MeXhH
 uDk+IZ3b
 XJrrHxrcs8M2I+wUffHA5fQlYYXjLUTHCcIVqTVRhvETegm0KfORZFCpNnNOhQpzYrWzdKuYPe/jNfoKe7lb2PDPHLMn/UDw6eiPYut374MWtFBmLIP3CFrw6L3Zei8GOKQ4yl/TzzdU6t/o7mK57fFZ9eS6RURvt4YsocZYQVEXTi9Zzy9YGJF9ZhQJnAu2GJa/G1AUwe00aW8+ufY0Umn3HFF707DKxgATwYq5WGbLdS3GgxSsUR4d4mp4GYtZ59PXl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 08:09, Lance Yang wrote:
> 
> On Tue, Feb 24, 2026 at 05:01:50PM +0100, David Hildenbrand (Arm) wrote:
>> On 2/24/26 12:43, Lorenzo Stoakes wrote:
>>>
>>> Sorry I misread the original mail rushing through this is old... so this is less
>>> pressing than I thought (for some reason I thought it was merged last cycle...!)
>>> but it's a good example of how stuff can go unnoticed for a while.
>>>
>>> In that case maybe a revert is a bit much and we just want the simplest possible
>>> fix for backporting.
>>
>> Dev volunteered to un-messify some of the stuff here. In particular, to
>> extend batching to all cases, not just some hand-selected ones.
>>
>> Support for file folios is on the way.
>>
>>>
>>> But is the proposed 'just assume wrprotect' sensible? David?
>>
>> In general, I think so. If PTEs were writable, they certainly have
>> PAE set. The write-fault handler can fully recover from that (as PAE is
>> set). If it's ever a performance problem (doubt), we can revisit.
>>
>> I'm wondering whether we should just perform the wrprotect earlier:
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 0f00570d1b9e..19b875ee3fad 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2150,6 +2150,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>
>>                        /* Nuke the page table entry. */
>>                        pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
>> +
>> +                       /*
>> +                        * Our batch might include writable and read-only
>> +                        * PTEs. When we have to restore the mapping, just
>> +                        * assume read-only to not accidentally upgrade
>> +                        * write permissions for PTEs that must not be
>> +                        * writable.
>> +                        */
>> +                       pteval = pte_wrprotect(pteval);
>> +
>>                        /*
>>                         * We clear the PTE but do not flush so potentially
>>                         * a remote CPU could still be writing to the folio
>>
>>
>> Given that nobody asks for writability (pte_write()) later.
>>
>> Or does someone care?
>>
>> Staring at set_tlb_ubc_flush_pending()->pte_accessible() I am
>> not 100% sure. Could pte_wrprotect() turn a PTE inaccessible on some
>> architecture (write-only)? I don't think so.
>>
>>
>> We have the following options:
>>
>> 1) pte_wrprotect(): fake that all was read-only.
>>
>> Either we do it like Dev suggests, or we do it as above early.
>>
>> The downside is that any code that might later want to know "was
>> this possibly writable" would get that information. Well, it wouldn't
>> get that information reliably *today* already (and that sounds a bit shaky).
> 
> Makes sense to me :)
> 
>> 2) Tell batching logic to honor pte_write()
>>
>> Sounds suboptimal for some cases that really don't care in the future.
>>
>> 3) Tell batching logic to tell us if any pte was writable: FPB_MERGE_WRITE
>>
>> ... then we know for sure whether any PTE was writable and we could
>>
>> (a) Pass it as we did before around to all checks, like pte_accessible().
>>
>> (b) Have an explicit restore PTE where we play save.
>>
>>
>> I raised to Dev in private that softdirty handling is also shaky, as we
>> batch over that. Meaning that we could lose or gain softdirty PTE bits in
>> a batch.
> 
> I guess we won't lose soft_dirty bits - only gain them (false positive):
> 
> 1) get_and_clear_ptes() merges dirty bits from all PTEs via pte_mkdirty()
> 2) pte_mkdirty() atomically sets both _PAGE_DIRTY and _PAGE_SOFT_DIRTY on
> all architectures that support soft_dirty (x86, s390, powerpc, riscv)
> 3) set_ptes() uses pte_advance_pfn() which keeps all flags intact
> 
> So if any PTE in the batch was dirty, all PTEs become soft_dirty after
> restore.

PTEs can be softdirty without being dirty. That over-complicates the
situation.

-- 
Cheers,

David

