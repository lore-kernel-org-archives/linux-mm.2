Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAB13EA7199
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 11:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2C3C6B0303; Sun, 19 Apr 2026 07:41:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DD656B0304; Sun, 19 Apr 2026 07:41:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CBA26B0305; Sun, 19 Apr 2026 07:41:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 761A06B0303
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 07:41:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A466140756
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 11:41:46 +0000 (UTC)
X-FDA: 84675115812.25.BF0CE72
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0CB6E40008
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 11:41:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VJCTQ939;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=yintirui@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776598904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/AOOji5H/H94/JhqjPLabF0j7yCM0LUwvT3tEVvAxc=;
	b=GcUN4LK4GNnl2mUE/fwa547bRfP5zYFGgWI2j9GkYdrHpRsAfUF5djmddPjx+2U79tYtJk
	UAzUg1lSUptkrPN64B0JsPVnHaQLihknVOvdMlU8EMpAxwxK5TQD74Cma7C8+mvPVRG9V+
	Ijw5DOW3BYs6ldbIDbfMIqvE7wpIMw4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VJCTQ939;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=yintirui@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776598904; a=rsa-sha256;
	cv=none;
	b=matctDdkJdQUbfg2Ei1xpBg7Ep2Z27KpGA/jAgN6yYMScj03RBg4b4g+ANkXtoXNmV5N9Y
	N2rC1N5tXcwHsKsjWj3qnKXyIcHxWMXEUZR2tvCP1MwPyafvMqmMSgOwCMAiPfcBzZZmP4
	VH7BLHwx0qMFMe9nP45QQXXr8uwNG8o=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8296d553142so1271130b3a.3
        for <linux-mm@kvack.org>; Sun, 19 Apr 2026 04:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776598903; x=1777203703; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w/AOOji5H/H94/JhqjPLabF0j7yCM0LUwvT3tEVvAxc=;
        b=VJCTQ939skxwqIVWxc7Wd7twWGwoWQpye253JbCahWcZMOC4xx5vwxmoKUxMfznPgv
         woiGcfaG2pjJaqrUwGycBtC3l6f9JNuy+3v2FrD/LCZQhgPaECJMUFbwer3j1x0xSn7I
         0Th4e+gq04xuuRYsoncAd+lvZPsciAyZxFyBGf+UE2LUfuQ8UxaKYMeVT+gdJsXT3XFI
         YhGZHEmgE0A+gTn4dAvQOp/V+IMglX+e1PYlEfyY4ClORute9sRkq+2cuoY9PK7vNfwC
         65K5lCKfaErqH123sCSAWR/fU0i/Fr3oWF77tpmn+A0WaM9AZDLh0eae/nWFa7UjpbwO
         hy3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776598903; x=1777203703;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w/AOOji5H/H94/JhqjPLabF0j7yCM0LUwvT3tEVvAxc=;
        b=jKmAi42MiFgVfqDqQAh4nn/SfPxfUDLHT7nghGFCeAGF0+Sd2i6v1tPA5ERcs+QO+d
         8t8eI+iUvluQjLJB2n7w481N3sDmGWKj36YeGVL+YNwp8QLHrdzvUQVINVU61hIBRauj
         7dtGgLIo55WWYpL8U2IpO626JXOWH0eOWU+48Dn1bfNQl5CJFeC2p6/T0VYrsjfSIzKx
         +xG2eYJxlwKLlz+w2pBzB2dZIKIOysUuQM86a/HwUGbpoWtZV9xpU7+Oy39SEal1kRdh
         oOhDfRgWqUcZdtXFxh6aqYG4LsZW8PDF77Op1tY1g3mZDiVhekz8MICbTpisENQR8qJv
         KBpQ==
X-Forwarded-Encrypted: i=1; AFNElJ+VuEbzS3yhmQTIlTi56QjrACJcHrZIXpXOPSie+z6jMAAHUfwYBlVIQc9l2qkETpqJVUodCEErVw==@kvack.org
X-Gm-Message-State: AOJu0YwcASWDpqwmq/d8L5PlThkAe/1uuQy1UIeFQJ0UT9iUXlBcCUQh
	bBH2Qr44LvGJIjmlrs724ux67U6nuCIyHO28ozx4EN5gpDa4/aaxP5Am
X-Gm-Gg: AeBDietu6AVH8jYzi5CpoJ4Z34qX3MN0pwEADqGoblGv9IrdHzy7YrkprPIIGcyAdCp
	ac8AkoFK+Y2qtSCUqCl6RaDABLFYi+XvtDSf6VC73OrfIldasElaqG0V1p7zHoR2Mh1jk/Nq5nR
	DtmizBy59Z4obapz6ZWeFAs37Ev1rO+i3WT1b2Jo5U5vKNHlOyYfRErzkUZY/18/QGjxlqNqGYE
	svJAGhhugTs87WEuwjTAVy4ZK1p0z/+OU0uXc0vBJQeFojKMc/XrANzn5kLzyMtX5YrJUtUYOtU
	0aTiCC5sMMCuxWmbH498HHJ7Z2X4RzGm7h1mE6k8HbJz0jeShow8Zn2lHmLVp/gIWvPZs717ErC
	HPITOYswE8JxoarzkZFcQu9y1uvgWI6TLB7+qcyxN/riuVYunCdESjw9gWWGWztlz5hWJLW3jnW
	ff0EWse0bBatmd1PRaiG5h5EpB7q8aRPrcrE1yHbI8AIoDjyb0M4c1A9zzwelKvAQUCtRSJan0u
	IkMRsHvc8283gZuI6emivYsK09ikFmz18R4OzQf+ALVrXw+4Fg5iQ==
X-Received: by 2002:a05:6a00:2d28:b0:829:8942:2c93 with SMTP id d2e1a72fcca58-82f8c7d10a9mr9456710b3a.9.1776598902602;
        Sun, 19 Apr 2026 04:41:42 -0700 (PDT)
Received: from [127.0.0.1] (211-76-176-103.dynamic-ip.pni.tw. [211.76.176.103])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ebb3fa2sm7324521b3a.29.2026.04.19.04.41.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2026 04:41:42 -0700 (PDT)
Message-ID: <39dac497-220c-4e71-9d3e-d9cf32357400@gmail.com>
Date: Sun, 19 Apr 2026 19:41:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [RESEND] Re: [PATCH RFC v3 4/4] mm: add PMD-level huge page support
 for remap_pfn_range()
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
 baolu.lu@linux.intel.com, conor.dooley@microchip.com,
 Jonathan.Cameron@huawei.com, riel@surriel.com, wangkefeng.wang@huawei.com,
 chenjun102@huawei.com
References: <20260228070906.1418911-1-yintirui@huawei.com>
 <20260228070906.1418911-5-yintirui@huawei.com>
 <9886b2c6-5516-4be8-ac31-db3133455af2@kernel.org>
Content-Language: en-US
From: Yin Tirui <yintirui@gmail.com>
In-Reply-To: <9886b2c6-5516-4be8-ac31-db3133455af2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0CB6E40008
X-Stat-Signature: 5u76z4y5s4s5zdjw8ynecyhsuif1a3n7
X-Rspam-User: 
X-HE-Tag: 1776598903-667370
X-HE-Meta: U2FsdGVkX1/TU/m8+kf6pk9XpiS2cmbHK7nYvsZmUBI+Oo/5rv5AKpTIuqLPXKFz7dzQU3EglewrT390bzffJDqUap5+VbN2B/0mdpmK/AYcRxGKUlR/WrGnwkacr8JqDSZ0p4el+ra7n4k+9W1/8FONDH6+HyIIEw9HAFoCMkBghj+Q39fAAoRW8XCvT+Fbc2MARoBSwvHV5LEVyyhR4ZT5/tlDDAo82SzML5hXKSJHwImwBJR27+ufXQecCAnRl3mgXoelW71mWet7WEqHqGSjQRq+HdDYLK8FT1leOqWjs8INq6+9vnHsHXIBqYwqreJPA/gOBgsZLJrfbzETYHn5UgxkTUY6NlJr38bBPrdVjnyebmoSdlsogx4j090vL55r8S+xAim+cK0q+rLwACapXszTZ+cBQh6vMHSIwHM61OzhCxftwvaq3weFMj6UFesBVrEDGSgwcUgbUEFp4PlpoWNrtJtPzGLZZUalh90sq9leMjnZA7wMHW7L5msvnhS2y3N0i44cZHkm/Ahe0hKU6uUgEpF0zebkoZp3j+hn+6cUMwLFffzchCg4h5bH3H7KvtEi4QB/HiFzoTeT7TOgB86hB7t92tyqW1oXrfeoPEk/KlUBDJeYFMjE+2hvlKPPn+togZZlAPF8WCZggdRVNmF6JMtCnXeZgcCJspb/Z6pb3Lq6z4lfFPAUQ5q0MbJQninI2fW6enqkcc8cyMpGQNTgFuBS4/o8ia4QP9ojoL5Ei5bRtkzPtBApx0WcDz0I3y3tCTe36N1ehz+VziKzcfrHbJRURcbenONdHxH6N1W+eHoIMMIj0MZzwZAmwCHnTtmRHeKr0KEYKybGRop07Ks5W+tApMOKOjI+uLEk0imUWE1xqqOhMQnF5SVL4w6O1EIW93re3szkxBR8MVPl90FAr/UgmVPiW7oeHpRCI6AGGhJf8AQFNm5lFIFpkiX0kv1SbR3BTmzsOgY
 /aEGaUI/
 T96QQhATZ5ohh2m/c+t36BgCDMQji1TDIzpohy1JMCNHOqufTOkNk0w9Dc+XUal2B7FU6HjnGpsW8ao7vpne1p0ez29u4EhO4EkrwO1UVvbtoEScXlfLs8Dl37T/OB8peeq7rx6CUBIGdL1cz1aBlK7JGk6Q85aFAieKifjuvPKWkzMjYuCVjr6JASke3RYw2tKrqTvmYymgQJ1bddT+x71XJ3oV6mpbc6xmOw4WFDSQfiW6ZF0SzRI7ScPJ5jarMe8fZV0qxxv0WoF5Wz8BN3ILXaSEjArQBnCD6mTTThoro5M+mSa7EPlucTbRe+k6Fw3eplc3+r570jj8NHDcByOYV6+MXp32xum9PLEv1BKghLuJKxrZm0x3c6qRh/vjLbR5NC/QxDzQCiAykzLIdZBxvvOXTipu7lC+hnFbkGcGX3xNl2DQdAwDKilie5YF5t8w5AVd874v6dnAbtIvz/FhjhhtBAQP9Tvd3cgxWo4Ov0e6gRXexalCdncijL+ounkD3R1RZ+tNb987EUguZPgV/odhGUoYOZIf+wdSOUI4Oyy3iWKUPOEoOmZZdGeXZQLg6JWMOo4UQfNPZOMV7G7MA0sXELrt/U9T6wmqSzARSHx8Hvq7RW/3UBHaffPDSOLfH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Resending to keep the thread intact, sorry for the noise)

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
2. For present PMDs, use vm_normal_folio_pmd() as the single source of
truth.
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
>> @@ -2890,6 +2890,40 @@ static int remap_pte_range(struct mm_struct
*mm, pmd_t *pmd,
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
> Use two-tab indent. (currently 3? 🙂 )
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
> Another sign that you piggy-back on THP support 😉

Indeed! 🙂

>
>> +		return 0;
>> +
>> +	if (pmd_present(*pmd) && !pmd_free_pte_page(pmd, addr))
>> +		return 0;
>
> Ripping out a page table?! That doesn't sound right 🙂
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
>> +	set_pmd_at(mm, addr, pmd, pmd_mkspecial(pmd_mkhuge(pfn_pmd(pfn,
prot))));
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
>> @@ -2905,6 +2939,12 @@ static inline int remap_pmd_range(struct
mm_struct *mm, pud_t *pud,
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
-- 
2.43.0



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


