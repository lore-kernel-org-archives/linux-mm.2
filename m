Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 128BEE78D6A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 09:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5311D6B0005; Mon,  9 Feb 2026 04:09:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D56A6B0088; Mon,  9 Feb 2026 04:09:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 396746B0089; Mon,  9 Feb 2026 04:09:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 283586B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 04:09:44 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3FC7C26A4
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:09:43 +0000 (UTC)
X-FDA: 84424345446.17.83C86C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 20CA740010
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:09:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QpaCy0kz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770628182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2wXLPrF3c7P97b6gTT96e+3ioNg8zNrz2OKrVFmg5jY=;
	b=UN0M4F+X/e8XGY3Fk1ldYSTZABCcQ+iJ1dDyrFe3JybQSKVkpT4G3PlZ9VCqft/ZaIYYys
	cI6xUo1FD6iHVFPwniH3+wuOTT32u5TunqE0P9UKx+VK/IgUEI2FDh6EbubeSnTTHn3TXj
	CkEPe+eGpjtNT9R1lljOYhctvf/nxqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770628182; a=rsa-sha256;
	cv=none;
	b=ad7D/J4cYbDaKnZosKSbMBgStyz+33EQwj7jXZ+GgCkTLJMRh29ncalUwW6kpG1TTLiIdF
	LO5/PmRH9RavE1NP/LeSmR9wP+n2E7SEMa6KepKGt/opYWoHZgTl+P4+1Inf1TgMlnL6om
	Xo1XRNiyG3BBgG4NHwiRxlh+EAHnZLI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QpaCy0kz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A0DC60008;
	Mon,  9 Feb 2026 09:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26BBC116C6;
	Mon,  9 Feb 2026 09:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770628181;
	bh=5nuDSACBfO1w4dYNx+WaobWzgCQZBOlLbjl0OCUaDVg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QpaCy0kzVd4IM6z6DErGLY+U81uSuhZNpp97Oy6ER3Mhj0ry4O2rjFJv4YuLDpuJW
	 SLje45zN8tKMCDqQpfecKeqg1BpGsCusv4+O+BgEf1/ZgKfh0Sbu1pA4/5eBbL/N/8
	 l+QkmCo8KGkZ+s1VlQ15q4HgVxNY+e58LuFLkZX3HweDwVrXiKDN45FNAiospV98w+
	 oxVzVIskWVUi5Jk16M5x6/YBWOo+HykdpgVafv/ot6GwFHaoSfKJGmc1Bt9wUFDaXI
	 N0pT3nwBvcZDxqNy7E2Ue2yL8p5RdeEd3NfAQ2+kA0D+VJ2tZ+70xb9d5TBoQ/YQkN
	 rGiHwyo/HpxUg==
Message-ID: <07d55759-a50a-457a-badd-85697174116f@kernel.org>
Date: Mon, 9 Feb 2026 10:09:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] arm64: mm: implement the architecture-specific
 clear_flush_young_ptes()
To: Baolin Wang <baolin.wang@linux.alibaba.com>, Chris Mason <clm@meta.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, will@kernel.org,
 lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <9d866a2644051e13a41ef4d6ca3909c6e1f9e229.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260128114936.72280-1-clm@meta.com>
 <de141225-a0c1-41fd-b3e1-bcab09827ddd@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <de141225-a0c1-41fd-b3e1-bcab09827ddd@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 20CA740010
X-Stat-Signature: mwou8n4jgddsyw8r9hq668d1bkm6ny4a
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770628181-664055
X-HE-Meta: U2FsdGVkX18OkH/xImXOQ/08yxYvjfqLwJqb3KubgO5HQLcCsDmLwM5ImvEvXO2ZK45QXTYhf3ej2W98xLeepgl5sNRd864hEGC7HeaUe9xgbgbk0yLdOxXrodwfppq95+EpB13GkEBM7K2RNnXKm2AALrvGmUsBeeyGUb8BKmKk7tm+RPt0Bhsn4h51BlzuCkF7J+r3J0Dmm8laXAPNIWMzUnZk0rUn0vExZpMTDrxsBQNou34fIcZmm8Hvhc+E7jbMAEoLK4xSb6szkM0Jz6/rXDTcSb1nxfwYyFNm6003f4441zXxvKmaXigIYlm/g0h38XgGXRJMNyGAd7VJd2VZv0FgYT6Wzegca0Zxcb79sFZWMhh0GOa5hhA/KNJzpi/vOupxHM6ZhrohZqNAScvZYrtJi6oeshtw310dhS6gPVmV5jRXWthSwmvuO+dEwOWzNT5a4hUVxJRceXrU1+fZuqyB56Bu3MqUEF2Mwx7JzTkq9rL64T2ppQU982PjDxUrxq6uviBfOWGwFChFPZMESn6muUTvaGM6Mw5WcC96QdlI3U5CoUMXKMQV0RElimo7miGka7t3XTsy3NlLEK8dMMWn9xkYFOCw6s4EYgl7PfX0UWQYKA/gw+9DD+7RADxJk7VGGTwf79uNK9RbMe27XkoSIFX/9QbjJ03kChxpFs0jWPQrwlUn8/J6qDeHPPCHJPJgxXJNO/wAQWZ3a1qFakr9SmN1zL3TGP/nWrwr0xwzWEAc8Zlm5KpS9felxDkRXv1Tk89D3col8gOtHgISrXaWd1Xj54Kb6oeVGLpGsnY0gTL28pL7yP7/7wChGxL3ResoOVq1m/70yi+ld1N107IA0NIF9/9fyIkxvT5QApw/BYpIV78lOLip6OheQmLq3YjFcFd72oVgi1LCgTZn1aTCDf4cPAjiZqOrMn+Iq8FYxKrMMIKanoMkUKvdg9OCirOrCma2FAW7r2C
 dcK+o7bP
 r9ChF/IM4xmRqc4jVzenmHMDq7ZOd/dCc2qXqDeLb0D6yFpItBLdoQyaaMAD5nQMFwdXxGQLWsMysnFk+Tv6aGX+k5cItqcz46QtWu81o9YtAkpw1nWAwmsgMbpPzmY3HjVxpyrQADSk7H62SZKWweCeEb0h4SOS8ZEBnIAsr9QRlN2glJU8Z6ZLmYsyMSzWi7WTLJHo7ISmOE6is6+jWELKJS/UuiJ/YvkfLsIc61N3uKhINn6zEn8AgkZDHxET9S05Nvx413vZiiaG2dm8kGwO+dsJ5E8S7cU/IRkep5Ir949OH6p6rdTFEPbd4ltpD2TpkpJvJkvgkXEvlW39hKDRsyGKVaKAeH3HJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/29/26 02:42, Baolin Wang wrote:
> 
> 
> On 1/28/26 7:47 PM, Chris Mason wrote:
>> Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
>>> Implement the Arm64 architecture-specific clear_flush_young_ptes() to 
>>> enable
>>> batched checking of young flags and TLB flushing, improving 
>>> performance during
>>> large folio reclamation.
>>>
>>> Performance testing:
>>> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, 
>>> and try to
>>> reclaim 8G file-backed folios via the memory.reclaim interface. I can 
>>> observe
>>> 33% performance improvement on my Arm64 32-core server (and 10%+ 
>>> improvement
>>> on my X86 machine). Meanwhile, the hotspot folio_check_references() 
>>> dropped
>>> from approximately 35% to around 5%.
>>
>> Hi everyone, I ran mm-new through my AI review prompts and this one was
>> flagged.  AI review below:
>>
>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/ 
>>> asm/pgtable.h
>>> --- a/arch/arm64/include/asm/pgtable.h
>>> +++ b/arch/arm64/include/asm/pgtable.h
>>> @@ -1838,6 +1838,17 @@ static inline int 
>>> ptep_clear_flush_young(struct vm_area_struct *vma,
>>>       return contpte_clear_flush_young_ptes(vma, addr, ptep, 1);
>>>   }
>>>
>>> +#define clear_flush_young_ptes clear_flush_young_ptes
>>> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>>> +                     unsigned long addr, pte_t *ptep,
>>> +                     unsigned int nr)
>>> +{
>>> +    if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
>>> +        return __ptep_clear_flush_young(vma, addr, ptep);
>>
>> Should this be checking !pte_valid_cont() instead of !pte_cont()?
>>
>> The existing ptep_clear_flush_young() above uses !pte_valid_cont() to
>> determine when to take the fast path. The new function only checks
>> !pte_cont(), which differs when handling non-present PTEs.
>>
>> Non-present PTEs (device-private, device-exclusive) can reach
>> clear_flush_young_ptes() through folio_referenced_one()->
>> clear_flush_young_ptes_notify(). These entries may have bit 52 set as
>> part of their encoding, but they aren't valid contiguous mappings.
>>
>> With the current check, wouldn't such entries incorrectly trigger the
>> contpte path and potentially cause contpte_clear_flush_young_ptes() to
>> process additional unrelated PTEs beyond the intended single entry?
> 
> Indeed. I previously discussed with Ryan whether using pte_cont() was 
> enough, and we believed that invalid PTEs wouldn’t have the PTE_CONT bit 
> set. But we clearly missed the device-folio cases. Thanks for reporting.
> 
> Andrew, could you please squash the following fix into this patch? If 
> you prefer a new version, please let me know. Thanks.

Isn't the real problem that we should never ever ever ever, try clearing 
the young bit on a non-present pte?

See damon_ptep_mkold() how that is handled with the flushing/notify.

There needs to be a pte_present() check in the caller.


BUT

I recall that folio_referenced() should never apply to ZONE_DEVICE 
folios. folio_referenced() is only called from memory reclaim code, and 
ZONE_DEVICE pages never get reclaimed through vmscan.c

-- 
Cheers,

David

