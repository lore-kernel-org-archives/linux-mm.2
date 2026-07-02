Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF6F1C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 587F06B0172; Thu,  2 Jul 2026 21:01:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5CF6B0173; Thu,  2 Jul 2026 21:01:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A1106B0176; Thu,  2 Jul 2026 21:01:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E50226B0172
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:01:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C6961C0768
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:32:39 +0000 (UTC)
X-FDA: 84944228838.18.AC2D2BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 96FBB120007
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:32:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RrfHMTc6;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783006357;
	b=ixZtdDAAC3XKsGyyy48NJq16TLpnmIHjC+hiERX+V8eUhzAqrMBT1UqW1Ix91YEl5+Rlkr
	JYEcT2ZZ+Cvsp2U3pgMW5Js04hUhFHd3WvxPS1n/axPe126kwmxagu+UeibNAyDxGLJeUA
	Ytuclv2wYbOJ4TA36yUurzMSDI1YwbY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783006357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K6BXeY1SuXwf6XNLIwmaGIUYMIBQYDCncKaEEO6QK5o=;
	b=dSvsgB2Wi/adMLlitByWLpBBQNBbucnPnP7u4b3yOGJpv9QcjZfDIV2isO7KpG8QH/rm57
	KSDaqN0jtVlNfOsymFg4ibZZMaJtzjMj4uBq9AVVfLfqvR5LK8Lo5yGv+6fVLAnW8rI+hB
	TAFZH9ze0KaDEz2KyZmk73nGTFdxUPA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RrfHMTc6;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD853601EC;
	Thu,  2 Jul 2026 15:32:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9271B1F000E9;
	Thu,  2 Jul 2026 15:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783006355;
	bh=K6BXeY1SuXwf6XNLIwmaGIUYMIBQYDCncKaEEO6QK5o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RrfHMTc6WpFqBIjgT3gKXJn9UOPoDGOmQjbssocbfy19iPWhzvzZOmDc2uft1nTM/
	 G4mcZQYbMHXOrHseVJCkoj98KH/X/o931BKZVuGiz0o8Sx08jvdPQC00UZ01xGkDe0
	 ANjXIGZ1epVEZa/j/Wi5/7tIdg3oTErIEWdOWc+QRX0pwGPIq40tRn1qFM7FYFQXAY
	 zHmSlxTopOz0AVxljNc3xjqdmrClnJqiS3j5wBtfJ8Wu0IrfTdc0iUeT+sEnWbwR2S
	 iMJSwCbMr6porAjAWR31wA7EQRiBrXaHFYTaVgyinEnl24OpPzs/7aTh/Q2g3PTBmX
	 HzG8A1gFURwlg==
Message-ID: <00d6e0fb-dcba-45d5-98c0-f5ed81604ca0@kernel.org>
Date: Thu, 2 Jul 2026 17:32:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
To: Dev Jain <dev.jain@arm.com>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcampbell@nvidia.com, apopple@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, j-nomura@ce.jp.nec.com,
 nao.horiguchi@gmail.com, ak@linux.intel.com, mel@csn.ul.ie,
 pfalcato@suse.de, jpoimboe@kernel.org, dave.hansen@intel.com,
 tglx@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260702051341.126509-1-dev.jain@arm.com>
 <20260702051341.126509-3-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260702051341.126509-3-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ga7rgc3au8mbq6uoojgr4if133cb9zze
X-Rspam-User: 
X-Rspamd-Queue-Id: 96FBB120007
X-Rspamd-Server: rspam05
X-HE-Tag: 1783006357-574786
X-HE-Meta: U2FsdGVkX1/Y1kEwQG1/YNfVNWS5tH1ULB6q3hTk2X+Kb1vcWP2sZBs3dwE9HFA5hsNsU4iRYwV/R2efqA6fKiVFTjEI5O2F4N4LdFwKyACBcODk7BOZGAzNlwqNVFonxsMxuHUUYTwTDmI1yt2lsfRkLqYk+UHzhyQhYXLKGSl9xlmcbreGNP/P2eNuHCx5cD8uab827H3RO/5IkyKNCJ6FexnkWr9sFUr2voo37z9ChA9JY1lIUSzlVhKzCEEraYGYzHEdlmGG0A8XqAc9RMzwxbR4kT/RqrraFpe1WXA2FED5h8PIt2vvanDIJK3S19nwvGUe0JoALCHWX7xqgrqSfAxNe+TlDtAUihaoH/s31Kp1q/DRUmlCsXwH2jnAsJAvhelaY1ne82UuqmF1dxR9wXONs99ROIeCCYoTRzhgW4Y/inPSGM7gYI9zdJ1d0Y/1711uBtZZ+Zzc7Sgb5acnCpIjiUZEDkEZEP4YmdScMnGv4TE1EPMbqklsAwzOUXIKWh1GfSxSyqIMR9dhTaZhU7r2kkp5J0oLe+WZIPI5umYF9Ehs7RZS7ccgjmYAvRIA0g7oBrFtArCsrAgBFMtXOL9f+ArHyIn1kvgmDDkiX+FU/EaVCfn4ly4mcotnFmPp80TAaiHl73V2ciPBMwAGS8n3JgJEctihVwsTCfjAEUW5lfNpMy8YyWsQcO0HfZnkYThFAWvINGkHo0umQ4DHFa8zidu+sNwb6ORub2RlhAqwt7r0LvMoXmHUI8pia3EXUiF0w1K7KaLMmSO4OsDyxl3jgaouzk7kjB/sT31jPJ5pqfFUejZeNVUei58q5f6ieQ76/rYhYRNBCZ8ZzgpjYwfYo3gjmx+io3sk0ukFoBFWirQvUIF0TuAwo6zBAGwsSkeoY3jRadGRmti/yetoht76QzL41beokJePcXpBNK9zNsUeZ6l69AUbAEI09FrMIGz7yzlBJBAK/vj
 DVIV4q5x
 dEf036gMurbz+OIUO04GRbUZFLGxxUVS+Humk3L1ZLBdoaE93CmLqzuVc/UMemHW12VcbPfuM8Jpwga2FRdFfmfuTpsbyvuGDg8k+Bxd9VHD0UUN/G2lXv9TxCz/fQfKonzQIstoBgGF5zbWVk9qbmsl/fNflqeARXup9oSMZZqr0vRahdCSy3CDnWuwctDfZhgZy74y4qyQxlSg2bGvjIbeDHJ7epZ2MXxGry82L1+WextqJsqjKC8go5FEQO54j34iL1H/0SX0556Wz4dLYeTtNH29uYqbqd2q8paUoi5surqhVSWssZidNlIL4qn7l/nWoVb0P/tUWMhWsczzEa+NKZpw/VbCliPXmPKRq5cKxBAvrAYK6E4+r2dvFtnU2pFvZUTfXOvmWuXtVbsFtBtKhyRBPvUmqcbPkG/juUZRicOq5rxITdFa7zyFqQidXm6HMDlnot4ZGjp3Mvfn/NxjFMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/2/26 07:13, Dev Jain wrote:
> try_to_unmap_one() handles hugetlb folios when memory failure needs
> to replace a poisoned hugetlb mapping with a hwpoison entry. In that
> case page_vma_mapped_walk() returns the pte pointer to the hugetlb folio
> in pvmw.pte, but the code reads it with ptep_get().
> 
> On arches which provide their own huge_ptep_get() to dereference a huge
> pte pointer, accessing via ptep_get() would cause pte_pfn(), pte_present()
> etc to misbehave.
> 
> It is not clear whether this has a trivially visible effect to userspace.
> 
> Just use huge_ptep_get() for dereferencing a huge pte pointer.
> 
> Fixes: c7ab0d2fdc84 ("mm: convert try_to_unmap_one() to use page_vma_mapped_walk()")
> Cc: stable@vger.kernel.org
> Reported-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  include/linux/hugetlb.h |  3 +++
>  mm/rmap.c               | 16 ++++++++++------
>  2 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 2abaf99321e90..fdb7bdf7645c5 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -1261,6 +1261,9 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
>  {
>  }
>  
> +pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr,
> +		    pte_t *ptep);

Two tabs, or just in a single line.

If others prefer a stub, I don't care. This here is shortest to let the linker
bail out.

> +
>  static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
>  					  unsigned long addr, pte_t *ptep)
>  {
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1c77d5dc06e9f..aa8a254efaecc 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2095,11 +2095,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		/* Unexpected PMD-mapped THP? */
>  		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
>  
> -		/*
> -		 * Handle PFN swap PTEs, such as device-exclusive ones, that
> -		 * actually map pages.
> -		 */

That comment now actually belongs above the pte_present() check below.


-- 
Cheers,

David

