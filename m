Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 882BBE9A049
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 13:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 540BA6B0088; Thu, 19 Feb 2026 08:02:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EEBC6B0089; Thu, 19 Feb 2026 08:02:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2D76B008A; Thu, 19 Feb 2026 08:02:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 26CDD6B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 08:02:50 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C92351A0581
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 13:02:49 +0000 (UTC)
X-FDA: 84461220858.15.9C8ED0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E352E1C0003
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 13:02:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DpIQs0Eq;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771506168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWmGvhbHQ1XwF3ZAwsrQiRrfM0uw+dP9VSG05BhD/jk=;
	b=l79aSuLdwkYZmZ+qGlWqLUeCsIathgitLAObkXOdh67WfVp8+pmBz4L6o4etXTrXMkePJC
	WgYQ2qH6a0S7t/ILb/Cw4kpY0SaN//XnIvO/I7PuOr8dXIOj2fenBod8WrOq8YIaBmTmxz
	fXCjp+YFwJRf7CDKtfJLQfk8HRUMtiQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DpIQs0Eq;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771506168; a=rsa-sha256;
	cv=none;
	b=Q5Ym2Ug0IQO7QJfVsb7sBuKXaEgI+mF9hUIeqbhCZI1s9HicfwC7vA6iXAjzcJYtHXvF2F
	HgJUByaINYupUNez0X08xn78IiGKFMI3KKghEyPtHcwEnpW3ZnK0EXtPUL5GFN24GAa7gN
	4peP9cvk8onDsnC4r05rBM+TuHA/mLc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C881404EC;
	Thu, 19 Feb 2026 13:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AE2C116D0;
	Thu, 19 Feb 2026 13:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771506166;
	bh=7Bb5sRn2SWYbd7qSSUEdEXGOktqPx/z0l+rsOmbcShY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DpIQs0EqYs0a8wRZIPRbqwYSbFeQUBGS4NJRDA5JJdjNW0w51sJGhqeQLtLWstjQp
	 jjoUnTq81FFUJfNqQ7MK7TLmrkv/GsamAc9fok+LwTv7H/Fj9S2f7rW/epZyfN9+3x
	 deTzWq+41Rh3Bs6AixzSI8BhWh/yc9fvugel2pK0/1s83fD3ocfLF4EyHL/rpd5usx
	 WLEw5N6SZYKLox5D0HywedKOzhUZCTjl4fH7dUKL5I28cvnzpxrC40E/TugFmOY8Ws
	 QSmFOyl4obfLb2QErWH7tH4UOQHH2Huq/JaoLRGY7orNfKj81OIzofGV4fj7rY3gaN
	 fDUsRnjNxUCjQ==
Message-ID: <9209d642-a495-4c13-9ec3-10ced1d2a04c@kernel.org>
Date: Thu, 19 Feb 2026 14:02:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions since
 PTE batching (cac1db8c3aad)
To: Pedro Falcato <pfalcato@suse.de>
Cc: Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>,
 surenb@google.com, jhladky@redhat.com, akpm@linux-foundation.org,
 Liam.Howlett@oracle.com, willy@infradead.org, vbabka@suse.cz,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <764792ea-6029-41d8-b079-5297ca62505a@kernel.org>
 <71fbee21-f1b4-4202-a790-5076850d8d00@arm.com>
 <aZSoyjQHvVWFBZdZ@luyang-thinkpadp1gen7.toromso.csb>
 <nfrvygkft42c35ymgupwggrc2hrbatxaa6cn3hjxffrvhaprqg@wjg4ye4uv5go>
 <8315cbde-389c-40c5-ac72-92074625489a@arm.com>
 <5dso4ctke4baz7hky62zyfdzyg27tcikdbg5ecnrqmnluvmxzo@sciiqgatpqqv>
 <eaa6be47-f1fc-4b88-b267-5aa38e3ba2a9@arm.com>
 <340be2bc-cf9b-4e22-b557-dfde6efa9de8@kernel.org>
 <cdrrvtzy76f7wplcrls3pbfe37kzrvzsrlaed7glg2cq6j3yob@wjbjklvovpl2>
 <624496ee-4709-497f-9ac1-c63bcf4724d6@kernel.org>
 <r2b2cjuqicmrw3zdwruacpelulhjhfdawrtbgzph5vsf6h5omj@dhrga7p62hju>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <r2b2cjuqicmrw3zdwruacpelulhjhfdawrtbgzph5vsf6h5omj@dhrga7p62hju>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E352E1C0003
X-Stat-Signature: ygxgg8ig1r3pymzyhzoz8i9aoym4dbye
X-HE-Tag: 1771506167-917646
X-HE-Meta: U2FsdGVkX18GRMCJlIUCsW8KZ5g1gLgP+xgrQrKSmmtohFnot5lj1yxK6v0U4p6y2ZTZw61VfUexzf4nRJuQ54tYYYeIs8tsN5UHMdQH8B+SelrDRs1gQmdLrYdSEiBjWxDkbcVoZYWa95Vn17Hf2SflXx3AF1oI/37v+2uuU2/aSzfD6VJvGdVjYC52yjb+wQQ8PBlrQRoqgHZuFNX+a/BcmgJlGFSpSR/d81jb5i5mGbdu9RED3lOS7OiS0MuPpyONj8Iv5qL984l6dqbOiNPE9egRWiHjiZ1VKTlAxRgxsIAevdUJU9/4ZNedWrBO4QUeznvqeS8PgB3btiWiANKd6yHokYAG0ORsTcy6vEgbz1PFWeNprZ2uu+QfOK2evHkPUJfyslunRKAlCDp9rWzRdSAavmJruZ3SzavLo/kVgzVHu/WJ/Cpj9KlLKXOyv+rgpGG5POI+NAaF4VY382eMYcMtTCjGvS/BvouaqDICQjB55Pyi6Zvctltb+qQXy7xJwJx2wSjlCDhJfURFC8i/gedZZWPBnURpUE4xMaeneYcD5YtewrmKRyRlGkAn+9KmLHY1urzeYEDWdSeminAfjx0qLgJb2FhG6bt4evfFxPMkkCpSfORwJ4Dx1rBC5V0LbiMF5GVEQkJb1449CXLzxyLZAmTmRJ/PdH9Cuz3W06EXFvqx63Y+yWxuN1Cau6rQr2GtF5NsGu18blUITzK/MhK6f7DBZDxoVUvFn9zOUcVbysH61OBoPol7hoXo4j5RmsrZ1dOxKGgDbuSaWIOcRmIA3dsBowt0CrvU5vb92HHyv2d5j4ReKAXuzeMWEO3IFI7uoS4nk480/yikpG9nWIUygdU4PCYcbX0EeyMi5MM5NHDLoVMs6ISWTYmsQDHwobafwbS2xV2iCs9pAxkoIV2qUoM7rCeGo1oRAuXNYmIRqJn1YX2/g0R8sGoJXcx9FIYrjJSjoHxSEya
 jWw0/Jwr
 NdoSXAOBZCqdvF6X0whkn4YJDml/WEkVNNJTNgfRN+9Jtz2ZDmbGmubDUPGNTbowiS+YNodx4W/O9bDvvu9cHqlJ7pmlsTOibRaEurTkpQv9/CBIF74938CeSMgMK/sMOF2v+wKFAdD9hhYazpmUTtJ6mftl/nV2dqilqSGrZ7BKTiXQI3Tjn1AIjEtqKE6b2jaNFmozSwc3645DZOAK7I1VODTp4UmdmHQUU6wvDQtpsyinleUSIMxrvl9/4xDqQqARE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/19/26 13:15, Pedro Falcato wrote:
> On Wed, Feb 18, 2026 at 01:24:28PM +0100, David Hildenbrand (Arm) wrote:
>> On 2/18/26 12:58, Pedro Falcato wrote:
>>>
>>> I don't understand what you're looking for. an mprotect-based workload? those
>>> obviously don't really exist, apart from something like a JIT engine cranking
>>> out a lot of mprotect() calls in an aggressive fashion. Or perhaps some of that
>>> usage of mprotect that our DB friends like to use sometimes (discussed in
>>> $OTHER_CONTEXTS), though those are generally hugepages.
>>>
>>
>> Anything besides a homemade micro-benchmark that highlights why we should
>> care about this exact fast and repeated sequence of events.
>>
>> I'm surprise that such a "large regression" does not show up in any other
>> non-home-made benchmark that people/bots are running. That's really what I
>> am questioning.
> 
> I don't know, perhaps there isn't a will-it-scale test for this. That's
> alright. Even the standard will-it-scale and stress-ng tests people use
> to detect regressions usually have glaring problems and are insanely
> microbenchey.

My theory is that most heavy (high frequency where it would really hit performance)
mprotect users (like JITs) perform mprotect on very small ranges (e.g., single page),
where all the other overhead (syscall, TLB flush) dominates.

That's why I was wondering which use cases that behave similar to the reproducer exist.

> 
>>
>> Having that said, I'm all for optimizing it if there is a real problem
>> there.
>>
>>> I don't see how this can justify large performance regressions in a system
>>> call, for something every-architecture-not-named-arm64 does not have.
>> Take a look at the reported performance improvements on AMD with large
>> folios.
> 
> Sure, but pte-mapped 2M folios is almost a worst-case (why not a PMD at that
> point...)

Well, 1M and all the way down will similarly benefit. 2M is just always the extreme case.

> 
>>
>> The issue really is that small folios don't perform well, on any
>> architecture. But to detect large vs. small folios we need the ... folio.
>>
>> So once we optimize for small folios (== don't try to detect large folios)
>> we'll degrade large folios.
> 
> I suspect it's not that huge of a deal. Worst case you can always provide a
> software PTE_CONT bit that would e.g be set when mapping a large folio. Or
> perhaps "if this pte has a PFN, and the next pte has PFN + 1, then we're
> probably in a large folio, thus do the proper batching stuff". I think that
> could satisfy everyone. There are heuristics we can use, and perhaps
> pte_batch_hint() does not need to be that simple and useless in the !arm64
> case then. I'll try to look into a cromulent solution for everyone.

Software bits are generally -ENOSPC, but maybe we are lucky on some architectures.

We'd run into similar issues like aarch64 when shattering contiguity etc, so
there is quite some complexity too it that might not be worth it.

> 
> (shower thought: do we always get wins when batching large folios, or do these
> need to be of a significant order to get wins?)

For mprotect(), I don't know. For fork() and unmap() batching there was always a
win even with order-2 folios. (never measured order-1, because they don't apply to
anonymous memory)

I assume for mprotect() it depends whether we really needed the folio before, or
whether it's just not required like for mremap().

> 
> But personally I would err on the side of small folios, like we did for mremap()
> a few months back.

The following (completely untested) might make most people happy by looking up
the folio only if (a) required or (b) if the architecture indicates that there is a large folio.

I assume for some large folio use cases it might perform worse than before. But for
the write-upgrade case with large anon folios the performance improvement should remain.

Not sure if some regression would remain for which we'd have to special-case the implementation
to take a separate path for nr_ptes == 1.

Maybe you had something similar already:


diff --git a/mm/mprotect.c b/mm/mprotect.c
index c0571445bef7..0b3856ad728e 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -211,6 +211,25 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
         commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
  }
  
+static bool mprotect_wants_folio_for_pte(unsigned long cp_flags, pte_t *ptep,
+               pte_t pte, unsigned long max_nr_ptes)
+{
+       /* NUMA hinting needs decide whether working on the folio is ok. */
+       if (cp_flags & MM_CP_PROT_NUMA)
+               return true;
+
+       /* We want the folio for possible write-upgrade. */
+       if (!pte_write(pte) && (cp_flags & MM_CP_TRY_CHANGE_WRITABLE))
+               return true;
+
+       /* There is nothing to batch. */
+       if (max_nr_ptes == 1)
+               return false;
+
+       /* For guaranteed large folios it's usually a win. */
+       return pte_batch_hint(ptep, pte) > 1;
+}
+
  static long change_pte_range(struct mmu_gather *tlb,
                 struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
                 unsigned long end, pgprot_t newprot, unsigned long cp_flags)
@@ -241,16 +260,18 @@ static long change_pte_range(struct mmu_gather *tlb,
                         const fpb_t flags = FPB_RESPECT_SOFT_DIRTY | FPB_RESPECT_WRITE;
                         int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
                         struct folio *folio = NULL;
-                       struct page *page;
+                       struct page *page = NULL;
                         pte_t ptent;
  
                         /* Already in the desired state. */
                         if (prot_numa && pte_protnone(oldpte))
                                 continue;
  
-                       page = vm_normal_page(vma, addr, oldpte);
-                       if (page)
-                               folio = page_folio(page);
+                       if (mprotect_wants_folio_for_pte(cp_flags, pte, oldpte, max_nr_ptes)) {
+                               page = vm_normal_page(vma, addr, oldpte);
+                               if (page)
+                                       folio = page_folio(page);
+                       }
  
                         /*
                          * Avoid trapping faults against the zero or KSM


-- 
Cheers,

David

