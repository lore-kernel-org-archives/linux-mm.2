Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF963FC5926
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 10:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46C386B0089; Thu, 26 Feb 2026 05:28:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4160B6B008A; Thu, 26 Feb 2026 05:28:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30F766B008C; Thu, 26 Feb 2026 05:28:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CB416B0089
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:28:37 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A53C713C020
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:28:36 +0000 (UTC)
X-FDA: 84486233832.16.24709BB
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id A6B0DA000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:28:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YAVrmS6n;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772101715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+yFBRNqmJ5O/9wR1LsjXptvmYsNUxZetzHoIAzFZaU=;
	b=MdDMKC6q3TFVXVe9g/CSOxozJ5c8U5B/ZsuJNg8G8p6TzLmxNNxp+fn7/B3qW/Ulb113qm
	p9nNC14fdvooufS4r5tVA1d8pfZXsBNi05q2/3aIIXAtPCPjBMN+zxfPBzR/JXOYn5mvOC
	JFDWx4fS4pdp03Bn39yRo0CJLnjVqTU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YAVrmS6n;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772101715; a=rsa-sha256;
	cv=none;
	b=x3LFphlGJ+gAwI8dafH1I56CrXrgCCq9HRL3x+tr69iyaYs0KsUzMgS00GGY76lrB23Aiu
	Vsn30wdYM6Bl2/5cmlIa6D6S2q4nV8BNubNzOa+3qff6Vhd3CW7frUsGs77gE+Q+2K4qUm
	mu6P6BUmv9KHekaL9Q5angS9kpdkoUA=
Message-ID: <dfd37e2c-d939-4682-a693-ae3941358fea@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772101712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S+yFBRNqmJ5O/9wR1LsjXptvmYsNUxZetzHoIAzFZaU=;
	b=YAVrmS6nLqZsCg6F0yNd7g0+0S+UrhZBNrsQMxarcA45GZ9rploasDDZG3zBZSsvtqu4V1
	ECAaFMOU82waYaNw0uoudNJkZG/zShB6fLGXc24OaJox6bMyFxjr9yGpUarKUGEhz2ukum
	27LYG00ZV4ikGkVU5Gl5m+aEL7o7tEc=
Date: Thu, 26 Feb 2026 18:28:23 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/rmap: fix incorrect pte restoration for lazyfree
 folios
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org,
 dev.jain@arm.com, harry.yoo@oracle.com, jannh@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, riel@surriel.com, stable@kernel.org,
 vbabka@kernel.org
References: <36e676b4-dc6f-45f7-b885-8685227ac6a8@kernel.org>
 <20260226070940.96226-1-lance.yang@linux.dev>
 <ece450e0-8e19-42bd-9a7a-fdfc7ab785e6@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <ece450e0-8e19-42bd-9a7a-fdfc7ab785e6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A6B0DA000A
X-Stat-Signature: x48he167u8aonr8pr1iw6eu8w3h14zpp
X-Rspam-User: 
X-HE-Tag: 1772101714-389844
X-HE-Meta: U2FsdGVkX1/VKl6OACBKUDMunB1HD1bAcDn0eTCQFyBAgejO7feHknBbYHVKIfT8MBMKmc/tgavmvjImo0B4nZ46hjaYKPphRoTL4aY8cer87fl/O0qTvMzNvYQ/uSH85E+mBgK7OuY/zKCX80jM8S5pHvVlZDe1XiRQGNYUN7O4o9W+PmwPz3X578HHwU0c5eaX+6wNM5e60tTfaYu+l3Ppigtr5Prg5E9Ao5a9NKe6Ihrd33R3YkED/GNLhTX4wkGKUeAJzvwIH0XflrXtGb52uoA3X3jej1PqLb31x9OVLpQQlVpZL19WZD5Bbc55yrXhSeodBiQIsKA06xGOcMHEJPZaZ7oQwPT+ihDpeGmd/bEjcxzrQgXaV4y8dDCQI8QxyF987VpnQEqNzQI3+xM/BYoj7QSbVbXzdrgl/PQRw1uAk+G1CDKRbfrYehWKfzYGSrA0tOG30csrAjRM39fIm+VvB/NG5SUtoppdVfX6Ui2HBlq5gLQox0dOxfCMRjsd7A7nkNFEKBWKX5mW4Dwq4XmVn+TNlFWuI0xlnh02P/oYKwCZDL6O/ggr9y026nqifz3/1u35TjM0/mSPnxe8lSttr4deRalg4yJVJXcnzgH8E5447cIo4x0FFy4GdjcHJL0CV92duPKeKeC/HNYM6plQo3hCfJ7+KzP18CweUMkC9izgvV1tfFKWRXWCZLytJC4l54OCWcvVCcfm5LZAPjv3Bppo4mbjh+rly63pwnXbAe4eAcilAIzmT4OZ0nk8CTbnLCuH7fRista5/9qjkPGMgFA6prxWnXDp2tMsR71k9zuyvX0IpYNag8FWExiwIiwakxPAvdZyJ599H/Wwef37wYKQRmOEMrFdRZiQ1CtZA45Sdk2QGNps1vRge1e1VYWkvVP9dIhMN8cN7R5+XghsV5kV2ttK4IUSj4uGvpjJyMGrEML67zBD0Qe3R3JHV1Nv6FlLgvCWTv5
 MhhR5hl9
 qg5zJCm37fAeBRxdGsowFEhCa1b3+ekQO0artbWjCA3lYS2/EvzXcUksGkcqEJ+LTViUu738HTdOpi9gHBVNxB5IM5H/ZAl8uNMb/+7SLVQvRYchKlLdS+GnzD/biJSBMdurfhrJCHhPNKJGQBdM1mcTlGBbgnwUIhhAII2tCRuRfgm3dWNQEpfauyQt2CPUl1QXvMQqYBaOdV5++qZzVmwswnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/26 18:06, David Hildenbrand (Arm) wrote:
> On 2/26/26 08:09, Lance Yang wrote:
>>
>> On Tue, Feb 24, 2026 at 05:01:50PM +0100, David Hildenbrand (Arm) wrote:
>>> On 2/24/26 12:43, Lorenzo Stoakes wrote:
>>>>
>>>> Sorry I misread the original mail rushing through this is old... so this is less
>>>> pressing than I thought (for some reason I thought it was merged last cycle...!)
>>>> but it's a good example of how stuff can go unnoticed for a while.
>>>>
>>>> In that case maybe a revert is a bit much and we just want the simplest possible
>>>> fix for backporting.
>>>
>>> Dev volunteered to un-messify some of the stuff here. In particular, to
>>> extend batching to all cases, not just some hand-selected ones.
>>>
>>> Support for file folios is on the way.
>>>
>>>>
>>>> But is the proposed 'just assume wrprotect' sensible? David?
>>>
>>> In general, I think so. If PTEs were writable, they certainly have
>>> PAE set. The write-fault handler can fully recover from that (as PAE is
>>> set). If it's ever a performance problem (doubt), we can revisit.
>>>
>>> I'm wondering whether we should just perform the wrprotect earlier:
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index 0f00570d1b9e..19b875ee3fad 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -2150,6 +2150,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>>
>>>                         /* Nuke the page table entry. */
>>>                         pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
>>> +
>>> +                       /*
>>> +                        * Our batch might include writable and read-only
>>> +                        * PTEs. When we have to restore the mapping, just
>>> +                        * assume read-only to not accidentally upgrade
>>> +                        * write permissions for PTEs that must not be
>>> +                        * writable.
>>> +                        */
>>> +                       pteval = pte_wrprotect(pteval);
>>> +
>>>                         /*
>>>                          * We clear the PTE but do not flush so potentially
>>>                          * a remote CPU could still be writing to the folio
>>>
>>>
>>> Given that nobody asks for writability (pte_write()) later.
>>>
>>> Or does someone care?
>>>
>>> Staring at set_tlb_ubc_flush_pending()->pte_accessible() I am
>>> not 100% sure. Could pte_wrprotect() turn a PTE inaccessible on some
>>> architecture (write-only)? I don't think so.
>>>
>>>
>>> We have the following options:
>>>
>>> 1) pte_wrprotect(): fake that all was read-only.
>>>
>>> Either we do it like Dev suggests, or we do it as above early.
>>>
>>> The downside is that any code that might later want to know "was
>>> this possibly writable" would get that information. Well, it wouldn't
>>> get that information reliably *today* already (and that sounds a bit shaky).
>>
>> Makes sense to me :)
>>
>>> 2) Tell batching logic to honor pte_write()
>>>
>>> Sounds suboptimal for some cases that really don't care in the future.
>>>
>>> 3) Tell batching logic to tell us if any pte was writable: FPB_MERGE_WRITE
>>>
>>> ... then we know for sure whether any PTE was writable and we could
>>>
>>> (a) Pass it as we did before around to all checks, like pte_accessible().
>>>
>>> (b) Have an explicit restore PTE where we play save.
>>>
>>>
>>> I raised to Dev in private that softdirty handling is also shaky, as we
>>> batch over that. Meaning that we could lose or gain softdirty PTE bits in
>>> a batch.
>>
>> I guess we won't lose soft_dirty bits - only gain them (false positive):
>>
>> 1) get_and_clear_ptes() merges dirty bits from all PTEs via pte_mkdirty()
>> 2) pte_mkdirty() atomically sets both _PAGE_DIRTY and _PAGE_SOFT_DIRTY on
>> all architectures that support soft_dirty (x86, s390, powerpc, riscv)
>> 3) set_ptes() uses pte_advance_pfn() which keeps all flags intact
>>
>> So if any PTE in the batch was dirty, all PTEs become soft_dirty after
>> restore.
> 
> PTEs can be softdirty without being dirty. That over-complicates the
> situation.

Ah, it's even trickier then :D

