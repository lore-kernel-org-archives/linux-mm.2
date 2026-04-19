Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB6E7EA718A
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 11:24:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D92B6B0301; Sun, 19 Apr 2026 07:24:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88A3B6B0302; Sun, 19 Apr 2026 07:24:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A01F6B0303; Sun, 19 Apr 2026 07:24:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 65EA46B0301
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 07:24:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E42DD140749
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 11:24:22 +0000 (UTC)
X-FDA: 84675071964.30.01005C3
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id C634114000C
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 11:24:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kC07JleA;
	spf=pass (imf09.hostedemail.com: domain of yintirui@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776597860; a=rsa-sha256;
	cv=none;
	b=aSwa6cW6c4ROZVL4RK4U6ikEzT3/cEwOzrwr3A58m2YwvgHLeDSYcbBfMJ84fCEzAg8opx
	yK4M+0MClQ7sk9cpXCEAQe5+0dRz+sUnYaO8qMfbyFXOC6935mZhuU3LRS44ppl9Gf3sC7
	Y8eFw3UwT+WEAI4g0zx76R1ZoFq43Ws=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kC07JleA;
	spf=pass (imf09.hostedemail.com: domain of yintirui@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776597860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CVIi4BTXGqRWLbaF1AjKsZST1JQete5I/BbrbNbXtW8=;
	b=ZWsfVw0iq8lyD3jjfgkSk1E4w1gnf4xNIaK37pjqs7a6vnZdA3QKBSNJegdyp1TIGGdoCy
	IO5SselyMeoZnmZ0vtiTw9emBgG1g7pseZeaZSBsGDPMka9TJm4n7g+wGFCrnFdLYKdofK
	0FRNRJqt1oJOf8Q1NBXRX7ozxZiAGIo=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ad617d5b80so11389315ad.1
        for <linux-mm@kvack.org>; Sun, 19 Apr 2026 04:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776597859; x=1777202659; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:cc:to:references
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CVIi4BTXGqRWLbaF1AjKsZST1JQete5I/BbrbNbXtW8=;
        b=kC07JleAS4T8VPBTS6r1DqIjSDGJ57vjqbdxlJwwrED2kp7EsvGMDZ/gHZ6ylXbY0p
         V+JrBEYJss0qE3xyaF1rlfennb5CZEGrzxfx+2s3Ylc06MoLwDOaH8vQfAJrmAq6P3dF
         vjrbtJqiZUdY3esGm5ylN4clVeYbEjNmcCD4pSOxFgVwCTxGUTArXvxvluB5W812ExcY
         KwlSa3nvOdOqQ+VJpX/hwT2PZ7nlhcB09rpG0abn+KfHxtMGsaR98oBCvemKxNQu52ex
         O5cxonaY7Sk0aWSB/mYSHkmdG2UGtOONOMtjyb8ZUS6QjcAMiK44HE9TsRbiwyusIPNq
         J/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776597859; x=1777202659;
        h=content-transfer-encoding:in-reply-to:from:cc:to:references
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CVIi4BTXGqRWLbaF1AjKsZST1JQete5I/BbrbNbXtW8=;
        b=XMpMhSud96hTMJZWxVBY0lqu3A8f/nVjUc8WnIntNNQYnp4ON1qT+2l6W7m1fXL8SK
         KxaVPw46O6/hm4AMO4QRAPnOKCNDSh+n/rU9mvRTS/7j1xESncHfrAjXegea3TuP0631
         pUu06aiwdOU9k5r1K0m+WcPCGO/BFVWwCndRQCQbL3WiD6raxo9LZWcSbFqfcs9hfJY8
         2oEo0ZubWeg8tAAh3M6GQv2/tTplK88NbOlRNeYRx5C/CmBayYlNJ5hIZEEoTX7y0530
         HlGlNN5HLyKYW60IxOhAVKwPgwDOxefRUTABYMXlj136H5K+hOBMfxXn6O9fWbwmCuA+
         iHsA==
X-Forwarded-Encrypted: i=1; AFNElJ9inwjTkP65g9mK1orhEpOrHGBddkPSOh8e7P3F6kkFT+Pp4cshYwfrm+eMK9On/609MsHcilHRdA==@kvack.org
X-Gm-Message-State: AOJu0Yw2bqBisQkblFWrgDqsejvB1iOwUli7MqLLo/cqAdr6UfBwxvtw
	v3u2c2wfhlZ9XIbegj4tSA3oTFAQF1xKkLYzSUmoGtmhtuKCUFmu2eJF
X-Gm-Gg: AeBDievUz0JtcvvyrIyllrp8J56vestfbIBCr40C8Hx/dMmuhLUQ54+IA4zviiMz6O8
	fV/vEFixEST8m2t+x+Lc+/h+rAJbYAfZGfSmFRc4MpU0oyQGuF+A+aHHBEUD+OHiM3MOroTYA0K
	XtWJ9UMnshdSU/AtL2I7XKg5e0rnlozYB2d5KhMchhDyNUNPyGhw93JPHhIVnalOV+AGgAZ/0Ks
	CnDdQo/e+sjtu6DxLboF4Fd5+B4+dEJtiTSLN8G9auXVUqEB0QZZMpgGZ//cpstWXGPNtUsT5bz
	CZZ4U3C+IMlj258/fne1CVEahNIj2jSNCNEcdKDtoON9PLmE0ilLaChIY/gfS94NF8CvwbMwBTN
	f1sDlGo7pL0wnlvAtAEw7XTNRwdDiwjYhFNi76CM3Om8zxAGG1GBnT66UKEp5wiC1YiTTpI5vvK
	0SJFdf4iHpyt2WQzWEkx4LsujilZ+ZeRhBZ5WQ3Y4txJfKgU0unQM99P5nJ4K1tGnISMR6O7c0P
	/fFNXDAHLuDq//jx/7+TW/KmWU8is3t4CVNfSYT2i+z8Ngoj0T7Y7e2Mo3w5xZj
X-Received: by 2002:a17:903:198c:b0:2b2:90f3:d774 with SMTP id d9443c01a7336-2b5f9e85c92mr103655085ad.2.1776597859436;
        Sun, 19 Apr 2026 04:24:19 -0700 (PDT)
Received: from [127.0.0.1] (211-76-176-101.dynamic-ip.pni.tw. [211.76.176.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab29398sm72897605ad.66.2026.04.19.04.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2026 04:24:18 -0700 (PDT)
Message-ID: <07686318-dfdc-43d0-bfb4-5635e2eb70da@gmail.com>
Date: Sun, 19 Apr 2026 19:24:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 4/4] mm: add PMD-level huge page support for
 remap_pfn_range()
Content-Language: en-US
References: <5d04929b-576f-4926-9f3b-be9a41a3e010@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, lorenzo.stoakes@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, willy@infradead.org, jgross@suse.com,
 catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, luto@kernel.org,
 peterz@infradead.org, akpm@linux-foundation.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, anshuman.khandual@arm.com, rmclure@linux.ibm.com,
 kevin.brodsky@arm.com, apopple@nvidia.com, ajd@linux.ibm.com,
 pasha.tatashin@soleen.com, bhe@redhat.com, thuth@redhat.com,
 coxu@redhat.com, dan.j.williams@intel.com, yu-cheng.yu@intel.com,
 yangyicong@hisilicon.com, baolu.lu@linux.intel.com,
 conor.dooley@microchip.com, Jonathan.Cameron@huawei.com, riel@surriel.com,
 wangkefeng.wang@huawei.com, chenjun102@huawei.com
From: Yin Tirui <yintirui@gmail.com>
In-Reply-To: <5d04929b-576f-4926-9f3b-be9a41a3e010@gmail.com>
X-Forwarded-Message-Id: <5d04929b-576f-4926-9f3b-be9a41a3e010@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C634114000C
X-Stat-Signature: 834xwf4u3mdecmqidtkdgh6kd9mpdztg
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776597860-353733
X-HE-Meta: U2FsdGVkX19lPy7DuOAYKKkVkgznnFnlctiCZyhanxbrzWY7vSMJOSaqGhC4fq7JGJVh6sVy1NkG2dHTuCO94HOjiDNltEdVAFoVse5iTD7GziOyC/ODNjQrAKMyAZ7qMYT716a9Mp8ua421/eT54es0XQ52NnkEko8hsBKm7JE8A2jjbmTXMdmx1CC4x21z84JMgYyXoUkeGNjK3m9EfVFTXfDEIEXsJPWduDPL7x5TynpJ368DIqJyKjoFYrcVRiG6QNb9fOEELBcuNwUImaBD/YPzElWh0OJAkqsCnOawwx6hHt7sJtHDm5gNMj7L7K8EzXKFElJvvtdWspASvzmMEQX5Zks48MmSRFzilPIYx96v4JBUNJz/gUcCkNTc96gDGJdIdzKZESunCrbXoosdageNUVAYeny0BbpZutMFlD8f6m6yId833c65bESjPi9NDXSwUB68ZjFauP4E8Tm/cYgCx4B3f+0lDgNxNbyedLQq6/2n1H7Lei76FQbVxvAwBrEzrz0gs/q3Xq7a4OMePflv8vCVoM/HTvY9zbYR2nFyCd07Lrb/5Dls9oXvSx5yTUUujmYT4oLGoG5gFOs/+vl3sRLoM/DVVPIZ5t4eeN0jWYxYxXDOjq60H+J6TldfNsVsJUcQS5xx0hCh/l9ykECnYuwlczLYKKnO1UuuX45tKq+a4MW8MMYcVngdJ7a5dSNXqzq5wv1LJR3ViN731jGLN7WHoNWD/bSwhMkiCSLZWxpTh3c788bHkhp2J5vNPj2fcp2pSqKBZ8g/zY8q9pimNgj7mGNQf7hv0tCNBTTsvEzMBYdUfoZBgkNdcND6BqC4b+98AoEjA0VL9GiEAWPzTM3T+eAoHoRRAW3a5Y3nisV3NjtSMZ2jmUWll7D2HLJHxsBYzi+9/n9soNoAOgUPDIGw/+zoss5iGOrn7pGEJmzoa9449xqgIBLB06bGprUxRDsaLNTXNHn
 62Be0saI
 7A52lFku3Rkh7Pq2FeAsp4XTWqQQQRxo7jQmOsuTMRoHSEexa0M/nCRPaLkYR1JLKzBklF1d+ITxq7UnNzS3oQNt8rcQHH518COjilE36D/ifZkvvxsEGv7kJ1sf1OFkssVapsgpsumMUqPMkL9AikWNgBDpDao5YuR9pcudaMMWgLqjzkazi9bXoJPBhdySjs9r4N44PAMolmvkeAHgg+OjqpH+VZRYKdHF9wYgCxOMmWH6x3pijr7QiNQZHaa7N0Hi6bHVRqroDB0ygh04X7hPxNQFiD81NZXCfri6lV1JYcaZIJYkA74Dx603O/pVl5hQxoztYooQ8uiW0GhDocXpFnFyJzj09eFd7e9SyLE/JNYza4lQ5FOvO+spbjy2NOHv6ud0vXcLm6UI0jL7oCy4Lnv4/mvrY3W9clGhh73DfUE3uzZtAOxKoEwcZnn8jIZYqONr51s33+KETlYuz2UveJbBQdSvYH9zbEqqspu4Bc3HCG96fwVAf7Gdl7M2BrMj/FjeDmhN0jPL6Dry0PlzDQ9NnYkAF0tNe1N0ooLjV0FxODljjJ0FqF8S9yq6BlEo6oDugJAtgz/2M28FRfdJcdhRBjKmUDGnq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

Thanks a lot for the thorough review!

On 4/14/26 04:02, David Hildenbrand (Arm) wrote:
> On 2/28/26 08:09, Yin Tirui wrote:
>> Add PMD-level huge page support to remap_pfn_range(), automatically
>> creating huge mappings when prerequisites are satisfied (size, alignment,
>> architecture support, etc.) and falling back to normal page mappings
>> otherwise.
>>
>> Implement special huge PMD splitting by utilizing the pgtable deposit/
>> withdraw mechanism. When splitting is needed, the deposited pgtable is
>> withdrawn and populated with individual PTEs created from the original
>> huge mapping.
>>
>> Signed-off-by: Yin Tirui <yintirui@huawei.com>
>> ---
> 
> [...]
> 
>>  
>>  	if (!vma_is_anonymous(vma)) {
>>  		old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
>> +
>> +		if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
> 
> These magical vma checks are really bad. This all needs a cleanup
> (Lorenzo is doing some, hoping it will look better on top of that).
> 
Agreed. I am following Lorenzo's recent cleanups closely.

>> +			pte_t entry;
>> +
>> +			if (!pmd_special(old_pmd)) {
> 
> If you are using pmd_special(), you are doing something wrong.
> 
> Hint: vm_normal_page_pmd() is usually what you want.

Spot on.

While looking into applying vm_normal_folio_pmd() here to avoid the
magical VMA checks, I realized that both __split_huge_pmd_locked() and
copy_huge_pmd() currently suffer from the same !vma_is_anonymous(vma)
top-level entanglement.I think these functions could benefit from a
structural refactoring similar to what Lorenzo is currently doing in
zap_huge_pmd().

My idea is to flatten both functions into a pmd_present()-driven
decision tree:
1. Branch strictly on pmd_present().
2. For present PMDs, rely exclusively on vm_normal_folio_pmd() to
determine the underlying memory type, rather than guessing from VMA flags.
3. If !folio (and not a huge zero page), it cleanly identifies special
mappings (like PFNMAPs) without relying on vma_is_special_huge(). We can
handle the split/copy directly and return early.
4. Otherwise, proceed with the normal Anon/File THP logic, or handle
non-present migration entries in the !pmd_present() branch.

I have drafted two preparation patches demonstrating this approach and
appended the diffs at the end of this email. Does this direction look
reasonable to you? If so, I will iron out the implementation details and
include these refactoring patches in my upcoming v4 series.

> 
>> +				zap_deposited_table(mm, pmd);
>> +				return;
>> +			}
>> +			pgtable = pgtable_trans_huge_withdraw(mm, pmd);
>> +			if (unlikely(!pgtable))
>> +				return;
>> +			pmd_populate(mm, &_pmd, pgtable);
>> +			pte = pte_offset_map(&_pmd, haddr);
>> +			entry = pfn_pte(pmd_pfn(old_pmd), pmd_pgprot(old_pmd));
>> +			set_ptes(mm, haddr, pte, entry, HPAGE_PMD_NR);
>> +			pte_unmap(pte);
>> +
>> +			smp_wmb(); /* make pte visible before pmd */
>> +			pmd_populate(mm, pmd, pgtable);
>> +			return;
>> +		}
>> +
>>  		/*
>>  		 * We are going to unmap this huge page. So
>>  		 * just go ahead and zap it
>>  		 */
>>  		if (arch_needs_pgtable_deposit())
>>  			zap_deposited_table(mm, pmd);
>> -		if (!vma_is_dax(vma) && vma_is_special_huge(vma))
>> -			return;
>> +
>>  		if (unlikely(pmd_is_migration_entry(old_pmd))) {
>>  			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
>>  
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 07778814b4a8..affccf38cbcf 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -2890,6 +2890,40 @@ static int remap_pte_range(struct mm_struct *mm, pmd_t *pmd,
>>  	return err;
>>  }
>>  
>> +#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> 
> Why exactly do we need arch support for that in form of a Kconfig.
> 
> Usually, we guard pmd support by CONFIG_TRANSPARENT_HUGEPAGE.
> 
> And then, we must check at runtime if PMD leaves are actually supported.
> 
> Luiz is working on a cleanup series:
> 
> https://lore.kernel.org/r/cover.1775679721.git.luizcap@redhat.com
> 
> pgtable_has_pmd_leaves() is what you would want to check.

Makes sense. This Kconfig was inherited from Peter Xu's earlier
proposal, but depending on CONFIG_TRANSPARENT_HUGEPAGE and
pgtable_has_pmd_leaves() is indeed the correct standard. I will rebase
on Luiz's series.

> 
> 
>> +static int remap_try_huge_pmd(struct mm_struct *mm, pmd_t *pmd,
>> +			unsigned long addr, unsigned long end,
>> +			unsigned long pfn, pgprot_t prot)
> 
> Use two-tab indent. (currently 3? :) )
> 
> Also, we tend to call these things now "pmd leaves". Call it
>  "remap_try_pmd_leaf" or something even more expressive like
> 
> "remap_try_install_pmd_leaf()"
> 

Noted. Will fix the indentation and rename it.

>> +{
>> +	pgtable_t pgtable;
>> +	spinlock_t *ptl;
>> +
>> +	if ((end - addr) != PMD_SIZE)
> 
> 	if (end - addr != PMD_SIZE)
> 
> Should work

Noted.

> 
>> +		return 0;
>> +
>> +	if (!IS_ALIGNED(addr, PMD_SIZE))
>> +		return 0;
>> +
> 
> You could likely combine both things into a
> 
> 	if (!IS_ALIGNED(addr | end, PMD_SIZE))
> 
>> +	if (!IS_ALIGNED(pfn, HPAGE_PMD_NR))
> 
> Another sign that you piggy-back on THP support ;)

Indeed! :)

> 
>> +		return 0;
>> +
>> +	if (pmd_present(*pmd) && !pmd_free_pte_page(pmd, addr))
>> +		return 0;
> 
> Ripping out a page table?! That doesn't sound right :)
> 
> Why is that required? We shouldn't be doing that here. Gah.
> 
> Especially, without any pmd locks etc.

...oops. That is indeed a silly one. Thanks for catching it.
I will fix this to:

	if (!pmd_none(*pmd))
		return 0;

> 
>> +
>> +	pgtable = pte_alloc_one(mm);
>> +	if (unlikely(!pgtable))
>> +		return 0;
>> +
>> +	mm_inc_nr_ptes(mm);
>> +	ptl = pmd_lock(mm, pmd);
>> +	set_pmd_at(mm, addr, pmd, pmd_mkspecial(pmd_mkhuge(pfn_pmd(pfn, prot))));
>> +	pgtable_trans_huge_deposit(mm, pmd, pgtable);
>> +	spin_unlock(ptl);
>> +
>> +	return 1;
>> +}
>> +#endif
>> +
>>  static inline int remap_pmd_range(struct mm_struct *mm, pud_t *pud,
>>  			unsigned long addr, unsigned long end,
>>  			unsigned long pfn, pgprot_t prot)
>> @@ -2905,6 +2939,12 @@ static inline int remap_pmd_range(struct mm_struct *mm, pud_t *pud,
>>  	VM_BUG_ON(pmd_trans_huge(*pmd));
>>  	do {
>>  		next = pmd_addr_end(addr, end);
>> +#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>> +		if (remap_try_huge_pmd(mm, pmd, addr, next,
>> +				pfn + (addr >> PAGE_SHIFT), prot)) {
> 
> Please provide a stub instead so we don't end up with ifdef in this code.

Will do.

> 

Appendix:

Based on the mm-stable branch.

1. copy_huge_pmd()

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 42c983821c03..3f8b3f15c6ba 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1912,35 +1912,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm,
struct mm_struct *src_mm,
 		  struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 {
 	spinlock_t *dst_ptl, *src_ptl;
-	struct page *src_page;
 	struct folio *src_folio;
 	pmd_t pmd;
 	pgtable_t pgtable = NULL;
 	int ret = -ENOMEM;

-	pmd = pmdp_get_lockless(src_pmd);
-	if (unlikely(pmd_present(pmd) && pmd_special(pmd) &&
-		     !is_huge_zero_pmd(pmd))) {
-		dst_ptl = pmd_lock(dst_mm, dst_pmd);
-		src_ptl = pmd_lockptr(src_mm, src_pmd);
-		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
-		/*
-		 * No need to recheck the pmd, it can't change with write
-		 * mmap lock held here.
-		 *
-		 * Meanwhile, making sure it's not a CoW VMA with writable
-		 * mapping, otherwise it means either the anon page wrongly
-		 * applied special bit, or we made the PRIVATE mapping be
-		 * able to wrongly write to the backend MMIO.
-		 */
-		VM_WARN_ON_ONCE(is_cow_mapping(src_vma->vm_flags) && pmd_write(pmd));
-		goto set_pmd;
-	}
-
-	/* Skip if can be re-fill on fault */
-	if (!vma_is_anonymous(dst_vma))
-		return 0;
-
 	pgtable = pte_alloc_one(dst_mm);
 	if (unlikely(!pgtable))
 		goto out;
@@ -1952,48 +1928,69 @@ int copy_huge_pmd(struct mm_struct *dst_mm,
struct mm_struct *src_mm,
 	ret = -EAGAIN;
 	pmd = *src_pmd;

-	if (unlikely(thp_migration_supported() &&
-		     pmd_is_valid_softleaf(pmd))) {
+	if (likely(pmd_present(pmd))) {
+		src_folio = vm_normal_folio_pmd(src_vma, addr, pmd);
+		if (unlikely(!src_folio)) {
+			/*
+			 * When page table lock is held, the huge zero pmd should not be
+			 * under splitting since we don't split the page itself, only pmd to
+			 * a page table.
+			 */
+			if (is_huge_zero_pmd(pmd)) {
+				/*
+				 * mm_get_huge_zero_folio() will never allocate a new
+				 * folio here, since we already have a zero page to
+				 * copy. It just takes a reference.
+				 */
+				mm_get_huge_zero_folio(dst_mm);
+				goto out_zero_page;
+			}
+
+			/*
+			 * Making sure it's not a CoW VMA with writable
+			 * mapping, otherwise it means either the anon page wrongly
+			 * applied special bit, or we made the PRIVATE mapping be
+			 * able to wrongly write to the backend MMIO.
+			 */
+			VM_WARN_ON_ONCE(is_cow_mapping(src_vma->vm_flags) && pmd_write(pmd));
+			pte_free(dst_mm, pgtable);
+			goto set_pmd;
+		}
+
+		if (!folio_test_anon(src_folio)) {
+			pte_free(dst_mm, pgtable);
+			ret = 0;
+			goto out_unlock;
+		}
+
+		folio_get(src_folio);
+		if (unlikely(folio_try_dup_anon_rmap_pmd(src_folio, &src_folio->page,
dst_vma, src_vma))) {
+			/* Page maybe pinned: split and retry the fault on PTEs. */
+			folio_put(src_folio);
+			pte_free(dst_mm, pgtable);
+			spin_unlock(src_ptl);
+			spin_unlock(dst_ptl);
+			__split_huge_pmd(src_vma, src_pmd, addr, false);
+			return -EAGAIN;
+		}
+		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+
+	} else if (unlikely(thp_migration_supported() &&
pmd_is_valid_softleaf(pmd))) {
+		if (unlikely(!vma_is_anonymous(dst_vma))) {
+			pte_free(dst_mm, pgtable);
+			ret = 0;
+			goto out_unlock;
+		}
 		copy_huge_non_present_pmd(dst_mm, src_mm, dst_pmd, src_pmd, addr,
 					  dst_vma, src_vma, pmd, pgtable);
 		ret = 0;
 		goto out_unlock;
-	}

-	if (unlikely(!pmd_trans_huge(pmd))) {
+	} else {
 		pte_free(dst_mm, pgtable);
 		goto out_unlock;
 	}
-	/*
-	 * When page table lock is held, the huge zero pmd should not be
-	 * under splitting since we don't split the page itself, only pmd to
-	 * a page table.
-	 */
-	if (is_huge_zero_pmd(pmd)) {
-		/*
-		 * mm_get_huge_zero_folio() will never allocate a new
-		 * folio here, since we already have a zero page to
-		 * copy. It just takes a reference.
-		 */
-		mm_get_huge_zero_folio(dst_mm);
-		goto out_zero_page;
-	}

-	src_page = pmd_page(pmd);
-	VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
-	src_folio = page_folio(src_page);
-
-	folio_get(src_folio);
-	if (unlikely(folio_try_dup_anon_rmap_pmd(src_folio, src_page, dst_vma,
src_vma))) {
-		/* Page maybe pinned: split and retry the fault on PTEs. */
-		folio_put(src_folio);
-		pte_free(dst_mm, pgtable);
-		spin_unlock(src_ptl);
-		spin_unlock(dst_ptl);
-		__split_huge_pmd(src_vma, src_pmd, addr, false);
-		return -EAGAIN;
-	}
-	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 out_zero_page:
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);


2. __split_huge_pmd_locked()

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3f8b3f15c6ba..c02c2843520f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3090,98 +3090,50 @@ static void __split_huge_pmd_locked(struct
vm_area_struct *vma, pmd_t *pmd,

 	count_vm_event(THP_SPLIT_PMD);

-	if (!vma_is_anonymous(vma)) {
-		old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
-		/*
-		 * We are going to unmap this huge page. So
-		 * just go ahead and zap it
-		 */
-		if (arch_needs_pgtable_deposit())
-			zap_deposited_table(mm, pmd);
-		if (vma_is_special_huge(vma))
-			return;
-		if (unlikely(pmd_is_migration_entry(old_pmd))) {
-			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
+	if (pmd_present(*pmd)) {
+		folio = vm_normal_folio_pmd(vma, haddr, *pmd);

-			folio = softleaf_to_folio(old_entry);
-		} else if (is_huge_zero_pmd(old_pmd)) {
+		if (unlikely(!folio)) {
+			/* Huge Zero Page */
+			if (is_huge_zero_pmd(*pmd))
+				/*
+				 * FIXME: Do we want to invalidate secondary mmu by calling
+				 * mmu_notifier_arch_invalidate_secondary_tlbs() see comments below
+				 * inside __split_huge_pmd() ?
+				 *
+				 * We are going from a zero huge page write protected to zero
+				 * small page also write protected so it does not seems useful
+				 * to invalidate secondary mmu at this time.
+				 */
+				return __split_huge_zero_page_pmd(vma, haddr, pmd);
+
+			/* Huge PFNMAP */
+			old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
+			if (arch_needs_pgtable_deposit())
+				zap_deposited_table(mm, pmd);
 			return;
-		} else {
+		}
+
+		/* File/Shmem THP */
+		if (unlikely(!folio_test_anon(folio))) {
+			old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
+			if (arch_needs_pgtable_deposit())
+				zap_deposited_table(mm, pmd);
+			if (vma_is_special_huge(vma))
+				return;
+
 			page = pmd_page(old_pmd);
-			folio = page_folio(page);
 			if (!folio_test_dirty(folio) && pmd_dirty(old_pmd))
 				folio_mark_dirty(folio);
 			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
 				folio_set_referenced(folio);
 			folio_remove_rmap_pmd(folio, page, vma);
 			folio_put(folio);
+			add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
+			return;
 		}
-		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
-		return;
-	}
-
-	if (is_huge_zero_pmd(*pmd)) {
-		/*
-		 * FIXME: Do we want to invalidate secondary mmu by calling
-		 * mmu_notifier_arch_invalidate_secondary_tlbs() see comments below
-		 * inside __split_huge_pmd() ?
-		 *
-		 * We are going from a zero huge page write protected to zero
-		 * small page also write protected so it does not seems useful
-		 * to invalidate secondary mmu at this time.
-		 */
-		return __split_huge_zero_page_pmd(vma, haddr, pmd);
-	}
-
-	if (pmd_is_migration_entry(*pmd)) {
-		softleaf_t entry;
-
-		old_pmd = *pmd;
-		entry = softleaf_from_pmd(old_pmd);
-		page = softleaf_to_page(entry);
-		folio = page_folio(page);
-
-		soft_dirty = pmd_swp_soft_dirty(old_pmd);
-		uffd_wp = pmd_swp_uffd_wp(old_pmd);
-
-		write = softleaf_is_migration_write(entry);
-		if (PageAnon(page))
-			anon_exclusive = softleaf_is_migration_read_exclusive(entry);
-		young = softleaf_is_migration_young(entry);
-		dirty = softleaf_is_migration_dirty(entry);
-	} else if (pmd_is_device_private_entry(*pmd)) {
-		softleaf_t entry;
-
-		old_pmd = *pmd;
-		entry = softleaf_from_pmd(old_pmd);
-		page = softleaf_to_page(entry);
-		folio = page_folio(page);
-
-		soft_dirty = pmd_swp_soft_dirty(old_pmd);
-		uffd_wp = pmd_swp_uffd_wp(old_pmd);
-
-		write = softleaf_is_device_private_write(entry);
-		anon_exclusive = PageAnonExclusive(page);

-		/*
-		 * Device private THP should be treated the same as regular
-		 * folios w.r.t anon exclusive handling. See the comments for
-		 * folio handling and anon_exclusive below.
-		 */
-		if (freeze && anon_exclusive &&
-		    folio_try_share_anon_rmap_pmd(folio, page))
-			freeze = false;
-		if (!freeze) {
-			rmap_t rmap_flags = RMAP_NONE;
-
-			folio_ref_add(folio, HPAGE_PMD_NR - 1);
-			if (anon_exclusive)
-				rmap_flags |= RMAP_EXCLUSIVE;
-
-			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
-						 vma, haddr, rmap_flags);
-		}
-	} else {
+		/* Anon THP */
 		/*
 		 * Up to this point the pmd is present and huge and userland has
 		 * the whole access to the hugepage during the split (which
@@ -3207,7 +3159,6 @@ static void __split_huge_pmd_locked(struct
vm_area_struct *vma, pmd_t *pmd,
 		 */
 		old_pmd = pmdp_invalidate(vma, haddr, pmd);
 		page = pmd_page(old_pmd);
-		folio = page_folio(page);
 		if (pmd_dirty(old_pmd)) {
 			dirty = true;
 			folio_set_dirty(folio);
@@ -3218,8 +3169,6 @@ static void __split_huge_pmd_locked(struct
vm_area_struct *vma, pmd_t *pmd,
 		uffd_wp = pmd_uffd_wp(old_pmd);

 		VM_WARN_ON_FOLIO(!folio_ref_count(folio), folio);
-		VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
-
 		/*
 		 * Without "freeze", we'll simply split the PMD, propagating the
 		 * PageAnonExclusive() flag for each PTE by setting it for
@@ -3236,17 +3185,82 @@ static void __split_huge_pmd_locked(struct
vm_area_struct *vma, pmd_t *pmd,
 		 * See folio_try_share_anon_rmap_pmd(): invalidate PMD first.
 		 */
 		anon_exclusive = PageAnonExclusive(page);
-		if (freeze && anon_exclusive &&
-		    folio_try_share_anon_rmap_pmd(folio, page))
+		if (freeze && anon_exclusive && folio_try_share_anon_rmap_pmd(folio,
page))
 			freeze = false;
 		if (!freeze) {
 			rmap_t rmap_flags = RMAP_NONE;
-
 			folio_ref_add(folio, HPAGE_PMD_NR - 1);
 			if (anon_exclusive)
 				rmap_flags |= RMAP_EXCLUSIVE;
-			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
-						 vma, haddr, rmap_flags);
+			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR, vma, haddr,
rmap_flags);
+		}
+	} else { /* pmd not present */
+		folio = pmd_to_softleaf_folio(*pmd);
+		if (unlikely(!folio))
+			return;
+
+		/* Migration of File/Shmem THP */
+		if (unlikely(!folio_test_anon(folio))) {
+			old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
+			if (arch_needs_pgtable_deposit())
+				zap_deposited_table(mm, pmd);
+			if (vma_is_special_huge(vma))
+				return;
+			add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
+			return;
+		}
+
+		/* Migration of Anon THP or Device Private*/
+		if (pmd_is_migration_entry(*pmd)) {
+			softleaf_t entry;
+
+			old_pmd = *pmd;
+			entry = softleaf_from_pmd(old_pmd);
+			page = softleaf_to_page(entry);
+			folio = page_folio(page);
+
+			soft_dirty = pmd_swp_soft_dirty(old_pmd);
+			uffd_wp = pmd_swp_uffd_wp(old_pmd);
+
+			write = softleaf_is_migration_write(entry);
+			if (PageAnon(page))
+				anon_exclusive = softleaf_is_migration_read_exclusive(entry);
+			young = softleaf_is_migration_young(entry);
+			dirty = softleaf_is_migration_dirty(entry);
+		} else if (pmd_is_device_private_entry(*pmd)) {
+			softleaf_t entry;
+
+			old_pmd = *pmd;
+			entry = softleaf_from_pmd(old_pmd);
+			page = softleaf_to_page(entry);
+
+			soft_dirty = pmd_swp_soft_dirty(old_pmd);
+			uffd_wp = pmd_swp_uffd_wp(old_pmd);
+
+			write = softleaf_is_device_private_write(entry);
+			anon_exclusive = PageAnonExclusive(page);
+
+			/*
+			* Device private THP should be treated the same as regular
+			* folios w.r.t anon exclusive handling. See the comments for
+			* folio handling and anon_exclusive below.
+			*/
+			if (freeze && anon_exclusive &&
+				folio_try_share_anon_rmap_pmd(folio, page))
+				freeze = false;
+			if (!freeze) {
+				rmap_t rmap_flags = RMAP_NONE;
+
+				folio_ref_add(folio, HPAGE_PMD_NR - 1);
+				if (anon_exclusive)
+					rmap_flags |= RMAP_EXCLUSIVE;
+
+				folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
+							vma, haddr, rmap_flags);
+			}
+		} else {
+			VM_WARN_ONCE(1, "unknown situation.");
+			return;
 		}
 	}

-- 
2.43.0


-- 
Yin Tirui


