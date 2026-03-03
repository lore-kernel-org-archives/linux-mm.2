Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB57AE67A98
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 08:51:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6686B008A; Tue,  3 Mar 2026 03:51:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286F26B009B; Tue,  3 Mar 2026 03:51:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 189E16B009D; Tue,  3 Mar 2026 03:51:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 080BF6B008A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:51:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8EC09C1966
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:51:11 +0000 (UTC)
X-FDA: 84504132342.12.927C50A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8A42C0012
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:51:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hPZBH363;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772527869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRldGGadxD7P1SZwucOdwYTcq+Wz/lX1e3xXFC/detU=;
	b=OjHzQDgJkdpC9fQeSTRm+XlsJyJVwnQcPjSbHTa07sOj+FJntYYCwS9RZUrUZI/iI/sVVl
	e57LMWXEsWRVa/ED/4H/YaTI+8TGUL5vhS35eWs1Fzbn5swaPv5QZAQb6lm/pWa8rar7BO
	jBy12LvzYBI1rx4ruZh68fVLf1ieVIQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hPZBH363;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772527869; a=rsa-sha256;
	cv=none;
	b=CSMV3h4P6YwKebX1GJOiRT/G+RP6sO1ZQiFZUL9JUXN81bd7BhytvGvh+nbqxW0+B5CO6R
	iaK/D4yh4XvuJHovhGylum3jDx9qNyHZRBxCoHPQCJiT1ayF37WAPypjQ+3NVj6JDJtNpf
	H6zvr5eWVVSYdReO9JsdpBoQUh0Szig=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF6CB4344B;
	Tue,  3 Mar 2026 08:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B49C116C6;
	Tue,  3 Mar 2026 08:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772527868;
	bh=2CCAoaRCdOOyLTEd958HxZE4sWRmnIGbYscxtuURPiQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hPZBH363HLmLj6thg8VLMbt5F6oDAzNl0hSpABg5fw9njux/vr1PXcMuDb9x+cuXM
	 dxnLFVTbFZu8tGxcfDHIPkB9TkB4CYiL0YzuWPjRAtIfyMrqAe3xr0vlICISY6Qpgq
	 gN+MMYMul36QU4EGyX7NrZFptehV1Ap7O1GocBIjRmtAg9l+Jen9UdaW7CjFAsMeO7
	 PavCrC49ldHj4djWk58jWPz8yYcrQQJ6tooGkNIqiNGhK8EjpyVQr2eqejs000Uq8m
	 OBxaLekIKbVoXpl4MKx7VHq5DFm9lisHMlRjdGmuTbVt4xKcN71Nkmv2HCSgTgiy6O
	 w/JLid6+muIfg==
Message-ID: <c56f4fe6-165b-435d-86bb-ad6a548990b5@kernel.org>
Date: Tue, 3 Mar 2026 09:51:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/6] mm: add a batched helper to clear the young flag
 for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
 <589d743f4e048dc749002a7e1a1aec5d511c406b.1772185080.git.baolin.wang@linux.alibaba.com>
 <be90d12e-304a-4c26-984d-2410a8850293@kernel.org>
 <7b4266c8-f885-44fb-b39b-aee38625980c@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7b4266c8-f885-44fb-b39b-aee38625980c@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B8A42C0012
X-Rspamd-Server: rspam07
X-Stat-Signature: wgp9qchgukngkq8hsac3hmnxnt61g87r
X-Rspam-User: 
X-HE-Tag: 1772527869-772855
X-HE-Meta: U2FsdGVkX19kU2qCAoUI/CSRRlUi1bxgc8VEOSFykHm3qywB3RAeUV/618sKsK1UCAciFkhx0MvXB3RYw7I4UTEamN0+aG5yMbg1i6OJiPf8q6+ATTbyjPpjO3n3Ce5t8gIchxStrQ5mzS9fuzwoSCi/dfr65w8ZSZsRI5J6Ii0y2guFbpmolZVBSSXLPdt2B0zyqY9zYFXBtRG2z8WaotHrHr+KWJzN8DzpQNYuHinrbO3mFtWviIesidrffDN7/PKKcLz06Vd1wSHDBgvg0xZU6RPE3oM5jTH4m0fzJe54COcB2yLzjHpAhV4k56hTWJzsVFgjrTxagw2Bi8wBjXCzOjKI4rO2zbv0rPIVCSbO7m1RLl+J12tM6YmnmP1A0hGFmIjWDTFzE3KoftmFPWgE/ZzEhApf9TMTF1fzLemeOqmqfCcedZQl/DxNZLsaK6wWNBEHnQZT+UyRl1yqUDfNMs8a19F9wiYK3ahPZ4VcBoOvmeef6JiwsNFx7+VZLMmyzwh+A3DH9DnuIakcPNOCoMv75CJY02XoWQGTCOk4p+L92Rt7OiaPea3WQCcmM7nnXXP2+suFyK3VcUpA5WxGw8WyB1XsyPFhL3tU8ycG+I5xFVQRGVIrrt1eYR5OovRx0JNjESaqIIDx9v5ThqP5QSUWHtm4LmAw6WFbmKZlQ69LIqpwuV0SkXYMwq+0ULJdspj/iyd1FA4aElCkXU6D9VCdtpj8k7Xu+A9/0f1C3+4PpvFLoqng46n/W/IG1+toUr5jGmDmo32RMYBOmAPDYsjkjvg2CaNXGzbARKxySY8GhdnLyBLNl/y75a2FnCPgzgVDuy0rPmXFLRZIX9PQkZZAlAbGmzGPdYygIeqK2V72jVpGKDohR4IASt0YZ37fBrF/USiL0zfhr0ZlKzdh4eOCofcWT4CK05FxJHMgWeI43usfWdENP60fW1r+O0nm1hUoOWJA41pHBbs
 rs7egdST
 a5IwkXsRAJ2h6WEFwPEV7dgDJHNm6lHqvrCZiVvRDdloQwoEQTGO0OyVAdoW85eNMFILoWyXzvFtz0W0BCUsvJSt84OOGXxd35RnHsj5BYOTJvYpp448+fvctdTH5RDRkX9nt7Ma/PvowV/e9Aygm4ghzF/wnsl31gDafEUJbxrs1aYwtFV/9PNzfu+ydCN/DFMYJUifoMwvrtpTrWBDh/r3IwRKeQJmvWkdgkuzEuAaoeU5wu7oKvB2/AAAlDqt21nu77qyEeWHmoCBCbGYHH2wRFNnYJPGbZmIya/Cbt1Y4rT8aALlPwuaAzdAVKHtnzCVWvfJxMtqO+qgytG04oz7YL8eRMYdwlFeQWlWassa61jw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 03:36, Baolin Wang wrote:
> 
> 
> On 3/2/26 5:07 PM, David Hildenbrand (Arm) wrote:
>> On 2/27/26 10:44, Baolin Wang wrote:
>>> Currently, MGLRU will call ptep_test_and_clear_young_notify() to
>>> check and
>>> clear the young flag for each PTE sequentially, which is inefficient for
>>> large folios reclamation.
>>>
>>> Moreover, on Arm64 architecture, which supports contiguous PTEs, the
>>> Arm64-
>>> specific ptep_test_and_clear_young() already implements an
>>> optimization to
>>> clear the young flags for PTEs within a contiguous range. However,
>>> this is not
>>> sufficient. Similar to the Arm64 specific clear_flush_young_ptes(),
>>> we can
>>> extend this to perform batched operations for the entire large folio
>>> (which
>>> might exceed the contiguous range: CONT_PTE_SIZE).
>>>
>>> Thus, we can introduce a new batched helper:
>>> test_and_clear_young_ptes() and
>>> its wrapper test_and_clear_young_ptes_notify() which are consistent
>>> with the
>>> existing functions, to perform batched checking of the young flags
>>> for large
>>> folios, which can help improve performance during large folio
>>> reclamation when
>>> MGLRU is enabled. And it will be overridden by the architecture that
>>> implements
>>> a more efficient batch operation in the following patches.
>>>
>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>>   include/linux/pgtable.h | 38 ++++++++++++++++++++++++++++++++++++++
>>>   mm/internal.h           | 16 +++++++++++-----
>>>   2 files changed, 49 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>> index 776993d4567b..29bd9fd04e1e 100644
>>> --- a/include/linux/pgtable.h
>>> +++ b/include/linux/pgtable.h
>>> @@ -1103,6 +1103,44 @@ static inline int
>>> clear_flush_young_ptes(struct vm_area_struct *vma,
>>>   }
>>>   #endif
>>>   +#ifndef test_and_clear_young_ptes
>>> +/**
>>> + * test_and_clear_young_ptes - Mark PTEs that map consecutive pages
>>> of the same
>>> + *                   folio as old
>>> + * @vma: The virtual memory area the pages are mapped into.
>>> + * @addr: Address the first page is mapped at.
>>> + * @ptep: Page table pointer for the first entry.
>>> + * @nr: Number of entries to clear access bit.
>>> + *
>>> + * May be overridden by the architecture; otherwise, implemented as
>>> a simple
>>> + * loop over ptep_test_and_clear_young().
>>> + *
>>> + * Note that PTE bits in the PTE range besides the PFN can differ.
>>> For example,
>>> + * some PTEs might be write-protected.
>>> + *
>>> + * Context: The caller holds the page table lock.  The PTEs map
>>> consecutive
>>> + * pages that belong to the same folio.  The PTEs are all in the
>>> same PMD.
>>> + *
>>> + * Returns: whether any PTE was young.
>>> + */
>>> +static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
>>> +                        unsigned long addr, pte_t *ptep,
>>> +                        unsigned int nr)
>>
>> Two tabs ...
> 
> Ah, yes, not sure why I missed this one :(
> 
>> What happened to using a boolen as return type and for "int young"?
> As I replied to you previously [1], I’d like to do this in a follow-up
> patchset that converts all functions that check the young flag. Does
> that sound OK to you?
> 
> [1] https://lore.kernel.org/all/32c538ce-6af8-48a8-86fc-
> d26ee253af54@linux.alibaba.com/

Oh, missed that. Works for me.

-- 
Cheers,

David

