Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D689CD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 13:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBB576B013B; Sun, 31 May 2026 09:11:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44BE6B013C; Sun, 31 May 2026 09:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0DFC6B013D; Sun, 31 May 2026 09:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B7186B013B
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:11:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37212C1D0B
	for <linux-mm@kvack.org>; Sun, 31 May 2026 13:11:57 +0000 (UTC)
X-FDA: 84827752674.09.56F2A66
Received: from out203-205-221-190.mail.qq.com (out203-205-221-190.mail.qq.com [203.205.221.190])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9173C1C0003
	for <linux-mm@kvack.org>; Sun, 31 May 2026 13:11:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="bTmZx/tC";
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf20.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.190 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780233115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mr1TwSKmatj/2m2QnGIAam1qjSB1zq1uNQfenesrHOE=;
	b=Zek9VsfZ1C7N1SDL6DnVQjrMo0UAGqTHaAHSb4iq63y1LrTkRb8LP1H2LyZvoBup3It8DJ
	9d6TWzZhFo1UZUyWEe5eFZO6NczS+G4kGwFCDk6SQAhKuUXygEHBoP2Mepl+KR4VqkkLXT
	4qGBnuwk7bC/OLXsV6epEx2yEWHxuTo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="bTmZx/tC";
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf20.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.190 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780233115; a=rsa-sha256;
	cv=none;
	b=oLFNP6JDE4YjjxZf0iNlNo0oE7Iut3juFDrsbve2L2RcTGlMRViLCw26ZQAMQuo2STXG5p
	lzjj9dChuZCS1vvmjsZV0uRsMCMO4I4UF21i4889FYQRFGw7g2fWfLBHkPKS0uiK00wiHa
	PCbhB4KvO/Qzhq7OS89YEJfECwbZ3gk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1780233111; bh=Mr1TwSKmatj/2m2QnGIAam1qjSB1zq1uNQfenesrHOE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bTmZx/tC9RapxA9/U5GpERbBYtAu0v+zHymS0+pgQGn4TmYx6cAENL+9zIHgJGcU3
	 CMi7aHCgGQOUI6zH3FkUigIy68/QnUlaVumqIV6fZkHy6Am5VI1ep8sBMLIbIRTrgj
	 q5rMN0+Eqt5tlNTwbjP85bFX/j20xYcjxWbuDrzM=
Received: from [10.24.9.42] ([123.112.11.230])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id 2F0AF885; Sun, 31 May 2026 21:11:48 +0800
X-QQ-mid: xmsmtpt1780233108tekoiylja
Message-ID: <tencent_7577C581F93B0F8D11889B0B8B2A2E876707@qq.com>
X-QQ-XMAILINFO: Nx5J06Esz7r7P/dOXETCc3qUJRi+RIHfWK/c5+SKK3I3LCwYUZz58fbE8ki/C/
	 TGRlcZxk2GIJU4WDlSxdwm0+OgU8L/rxF+8MzxlvBIs4a1OQ8pHXHv6ILp+svRN4Rdk9m7mz1bFQ
	 IGzVxne7Jkm1gkqvJF9S8VZX4lJGnsVkzGjrFn8yAVu6OrFIwdi9XyHJFR3G0ewJ20ec/aeQpYA5
	 LOEmG7eTUcT2nIuP6uzmQN0mOK2q3z01VCbmTq0FZ5PzroscoOhrEyZO6IC4T9EIl+K+4ex7m78V
	 mS06WoNAhACLunlj0i/CdqP/yQYUKTzi5M/mq2XiSAbj45A7QCgllDLG72JYXUW9gQ0Q2hyEOmD9
	 NGmmvIK9YZpCSOJPojO0FksiATbJDRMvdGp1vV0LnR9Q4/Umn16fYlwbhEo/lpVLfnNXnvz36wrC
	 jgpw24zEAO4dyE+64Y9kU1QFyvb4hkKJtTlc6V5QL5QfT3Y/ENAKrRXcCYcQiY8n83f/ajO8h0bv
	 Scs3coLI8iltq05xBsT3p1GwW4IwPFAo3ntQE776lBfP+jZG1IWY3oRX6gyJKLlm17ct98vIHUwW
	 FqA2uSnml+Ahn7W2geghkdQo5XGChHZhS+1/68PQue6D8wq/9cP40OSfYzrAekGftiiG28Ne4uJv
	 iGRhVkNHbSUyN7HeghXVBDoD+NpiNoP38HgzWt2QWpGgXAkz4Y0kMVrD3zYPsA8bGx1olgHO1sjM
	 LizvBv/ElMywemUejBGnRkxYvhGg8uqFQN4X+iMzwPmUW94pN5XBSbEjngXTVDJD5bzLPQNDnI8/
	 33ISNLrfsV0MoUuggQRfTu7GpyM5ClNEENVA6ZiuCV2JSB8zplwLM9rOHkTJbRATFZ01VP5p2V/8
	 o8u23JaR/46P63O4NwDpfcXZbniSwFAPPvRiGXmSJh7HqLG7fYYmQpd0j7rTYBkpFgmCpM9TumSu
	 5/OWob19ztuYnlQMkgW5Sh8zGYduv/r3SzJeMbrLBzloXOw8fXSzWUNDPLluO9Dx7buerPYEEo16
	 yFtPMKldPSH0DPiEc12uv8NmtxqvOUuaoqHmt4ZAC965shOfXOev52CMF46VG89AJIS2mZofhbFn
	 ubvG35dSBTBVJstOmNB8vewEDoyQ==
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-OQ-MSGID: <e0d41c89-877f-41fa-9b50-f26275c86475@qq.com>
Date: Sun, 31 May 2026 21:11:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 6/9] mm: provide anon locality evidence for zswap
 large swapin
To: Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Alexandre Ghiti <alexghiti@meta.com>, Kairui Song <kasong@tencent.com>,
 Usama Arif <usamaarif642@gmail.com>, Chris Li <chrisl@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
 <tencent_913470853E9B289ECF0379248E24DFB4590A@qq.com>
 <CAKEwX=MDSwMoU-=h3NOG==-ru+qT3LeTi2_PADLWFXBB9aZZ+w@mail.gmail.com>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <CAKEwX=MDSwMoU-=h3NOG==-ru+qT3LeTi2_PADLWFXBB9aZZ+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9173C1C0003
X-Stat-Signature: wysbh5nrndhc8za8orrgnegjxwxk7ski
X-Rspam-User: 
X-HE-Tag: 1780233114-325607
X-HE-Meta: U2FsdGVkX1/+5q74TJC4JDXLntBR/ZSS79rBD2sMRtASZMuc040BKKg2aRekB6LwFa6RbnYf9p2IOA1mE9wkwZwSYdGGVSHVtXNtmrYTT2SJZGjo/o+ehc4CuY326KKyi1DGn5dKjtqT79KawhqC5ckhklTPiTSgnMFR6kGPPHCq7kbl+sT5SHYYeQMO1/pavGju81YmI/xzg3CryuhA+aOAUgMH88kDEFuQxByrLzrzAmJVmpDe+Tpkm1CJp9Z78cPJdBFFYvUkiPDYP1M99QhJha0YO2GKKnJp+L8ho5kff7pJ0ligUHNbd3kd3v3r3oVaIHFrINvvJ9ZNGjRDPM4gRn0ivv7EQrUKZfRGr+VxnMTVOYjOPU2Ujpx7W48rqRQm6be2lAzlSdOBW6ydnjt55XP1cF6ojHSMqwTi9HtR7UVXhvMZvkgycxcNxRkGcR5DWDJX5ORR17cXQby1rjMZqr0On266NCoXjiU9WtNOMeVTCjQVyodmxTgLVGhkzeSKKIiGh8IqUaUEZmEs9+D6W2p9MxxcJ3ojqo51cOoQwDnTXfOBFq0h3r1INro6RwfLhunJZUjvlRtq8JQJ8jYi4VnFnRpe1i/ZFle7dF1VfdyibG6mP80eJCb2BQrnCKdiSch/AarlGafi7szefwjHk5iYWdE/4tdMykucPg0Vogkjyb0i7tPt6DAw+o08+n6vAXjWU5pq3tRWo0yQr3lA+3EsAA9pzu2k38Ml7B2rwDbbMqvvWdhCuLJkibqOaQ4ivyRndE3AFczRSRJ+2FhBj0YW9znzqYiH4UV0HilBuIXtVw/2rLWMOoVHM+OnXYuhraIpAi610Y4RdtuAPBG6+L8LcqO6giBEgO0XRVFaWTGMsrhLOuss5VPIsM3k9Xu7ANHlBdA4oAVgMX/ABve6WY8n/A/VcA9OJHfdeS/evrE+KIDCP12EANGa8XoxX8hW2AqOP2j4z4fHbOP
 BhV3T9Xw
 Z+djZlrkNd6QFA9wrbPggeieSqKM5RQLFjBEjMDZ8VrN2DwEaJ/7OEAf5VLqTqT0cWgIoCWw2wZxflKKvWDavn2G053OhFMiQI0iOVy00ShoMQA/Vnlr0MJSZw8PoR+NotleVVEA2mHomAeN49/CGfGxBJ2LJHlFW4dppyfVkrtbaSXVYMa5MY6gGj21eBjtEvItS8a/Qbc0OwM9JFl3jrN1ld6Sh5Hz+Eq5TrX4xKWaLjXPozCpbwKuxibtJUT5MuFXym7vMl2KGeJ4VQws3BYWGn/UcRXQg2w6vzHmKN8zHVwv4jyMZ3RCEqRp7YYDxynmOSqFktopciA/ayYt8HXZNQ69i13Rs5ApDj6y0xtZyGaxrSRoLtsMgGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/30/2026 3:22 AM, Nhat Pham wrote:
> On Fri, May 29, 2026 at 5:19 AM fujunjie <fujunjie1@qq.com> wrote:
>>
>> The common zswap large-swapin policy needs locality evidence from
>> callers before it can admit a large folio. For anonymous faults, provide
>> that evidence from existing VMA hints and from the PTE young state left
>> by earlier zswap-backed large swapins.
>>
>> Keep non-faulting PTEs old when mapping a speculative all-zswap large
>> folio. A later fault can then require a dense young previous range before
>> admitting another large swapin without adding VMA state.
> 
> Makes sense to me.
> 
>>
>> This also removes the old zswap-enabled guard from the THP swapin
>> candidate scan. The common swapin path now classifies the backend range
>> and falls back to order-0 for mixed zswap/disk ranges or races.
>>
>> Signed-off-by: fujunjie <fujunjie1@qq.com>
>> ---
>>  mm/memory.c     | 234 +++++++++++++++++++++++++++++++++++++++++++-----
>>  mm/swap.h       |   6 ++
>>  mm/swap_state.c |  15 ++++
>>  3 files changed, 235 insertions(+), 20 deletions(-)
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 92a82008d583..7bbb89632000 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4556,6 +4556,35 @@ static void memcg1_swapin_retry_folio(struct folio *folio,
>>         folio_unlock(folio);
>>  }
>>
>> +static void set_swapin_ptes(struct vm_area_struct *vma,
>> +                           unsigned long address, pte_t *ptep, pte_t pte,
>> +                           unsigned int nr_pages, unsigned int fault_pte_idx,
>> +                           bool fault_only_young)
>> +{
>> +       struct mm_struct *mm = vma->vm_mm;
>> +       pte_t old_pte;
>> +
>> +       if (!fault_only_young || nr_pages == 1) {
>> +               set_ptes(mm, address, ptep, pte, nr_pages);
>> +               return;
>> +       }
>> +
>> +       old_pte = pte_mkold(pte);
>> +       if (fault_pte_idx)
>> +               set_ptes(mm, address, ptep, old_pte, fault_pte_idx);
>> +
>> +       set_pte_at(mm, address + fault_pte_idx * PAGE_SIZE,
>> +                  ptep + fault_pte_idx,
>> +                  pte_mkyoung(pte_advance_pfn(pte, fault_pte_idx)));
> 
> Hmm, does this mean that without THP swapin, the faulting PTE is not
> marked young, but it is marked young if there is a THP swapin. That's
> a behavioral change right? Would this throw off other heuristics
> relying on this bit, or any justification that this is fine?

Thanks.

The intent was not to make the faulting PTE behave differently from the
normal swapin path. In do_swap_page() we first build the PTE with:

		pte = mk_pte(page, vma->vm_page_prot);

and on the common architectures I checked, the normal user pgprot already
contains the accessed/young bit. For example arm64 PAGE_SHARED/PAGE_READONLY
are based on _PAGE_DEFAULT, which includes PTE_AF, and x86 user page
protections also include the accessed bit. So in practice the faulting PTE is
already young after mk_pte() there.Therefore, the default path is originally marked as young.

What I really wanted here is only to keep the speculative neighbouring PTEs
old. A large zswapin may install PTEs for pages that did not fault, and those
should not all look accessed just because mk_pte() produced a young PTE.

But, the explicit pte_mkyoung() on the faulting PTE makes this look
like THP swapin is adding a new behavior.I will try to improve it 
in a way that is less ambiguous.



