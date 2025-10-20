Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB591CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 11:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4597F8E000B; Mon, 20 Oct 2025 07:00:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4316E8E0002; Mon, 20 Oct 2025 07:00:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36ED38E000B; Mon, 20 Oct 2025 07:00:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 270D98E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:00:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E37A1135D9B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:00:38 +0000 (UTC)
X-FDA: 84018199356.21.47EEF73
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1DD3C16001D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:00:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qx+WPAAe;
	spf=pass (imf08.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760958037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I0Rh7vr2r5CUO65seAlIgLtsprqiSEsZXpmW27HKpY8=;
	b=g/0LjCdaAzcqMIn5zW5dHQQU5KDVs5WRu0SqGp3c6lj626+7cQILZbJ87p9DbCJCxzzQAf
	EJB/xdaa/Yru84iljkgzE5Wo48po8bevdgUaBhKFRsNygqO8AfqhvM+UmpSeJQsYdKtaOH
	MgQowOh/eoPxiTp0NxJWrxgc6Wk2/7g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qx+WPAAe;
	spf=pass (imf08.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760958037; a=rsa-sha256;
	cv=none;
	b=b48/fW+jZv+mJ2xGF0/btdF40OXCZQOMMioblDcBsl9g2uoxKLKieh7pJOVo0fs5agTF1/
	0qoQlHgb9NSz+KptUq/TMyKImpnAPDI2R/d+7E+g457EcAFr0M2xMLS/0p3pja8VNTDEpl
	/LK5Z83qGObaTIcLffNf2F/ICNeQXEI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760958032; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=I0Rh7vr2r5CUO65seAlIgLtsprqiSEsZXpmW27HKpY8=;
	b=qx+WPAAebl/wHBOFVI25W9WrSOw6oyYGkxnSrYWKMpeUuksJSAJqeT+ZsBzymyJjWPX5RTrF2T8SiwTGiLe3sem8/QN3847SeLK/Wht5xkjYp/GaDuai+zMOAs6WQOOzgybQ3AgiqQEXZIuwR0fHMPZkIEceMpn41TGseuXlCTQ=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WqbBPTq_1760958022 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Oct 2025 19:00:30 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>,  Anshuman Khandual
 <anshuman.khandual@arm.com>,  Ryan Roberts <ryan.roberts@arm.com>,  Gavin
 Shan <gshan@redhat.com>,  Ard Biesheuvel <ardb@kernel.org>,  "Matthew
 Wilcox (Oracle)" <willy@infradead.org>,  Yicong Yang
 <yangyicong@hisilicon.com>,  linux-arm-kernel@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH] arm64, mm: avoid always making PTE dirty in pte_mkwrite()
In-Reply-To: <aPKFmHg-FrkGJxWd@arm.com> (Catalin Marinas's message of "Fri, 17
	Oct 2025 19:06:16 +0100")
References: <20251015023712.46598-1-ying.huang@linux.alibaba.com>
	<aPKFmHg-FrkGJxWd@arm.com>
Date: Mon, 20 Oct 2025 19:00:20 +0800
Message-ID: <87bjm1g7nf.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Queue-Id: 1DD3C16001D
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: irfwawjx86uomjxe31dsc3kg6zqugosy
X-HE-Tag: 1760958035-821780
X-HE-Meta: U2FsdGVkX18VATfqXaTlIhR8ePt3IKkGRN58apfQoYYvItrBqGXMuKJ0eWfkU0wzagbWgvl56SRRu3xTKQ5Sg9xZxSxiKlKpko5xbrAsxl4wdGDhJGCs+f/0Mu2DTrXl2+FSblZi9bEDHws+kUHoiVP/MUjw5DIz0mE2PG1ZEm0HA8KowuNsWuFGSH/KwyAxc8csaciBwW0GQIok+si3kq6Hsn6cRr+pQPxwAnqFkkRKoGrFhQ5N3wUa4ByShmpz/SLd4TE7qm6gHOjrIPsqVaKyXmYJmjcvQF4HnuQ0rjenIg46+qTsMdWX19SJCJfIoV2GHDrFveSqeNZcZEr4DnC8Vll/MtFPmLLWgnjvmA8odGMTLZB6RWWhAof9C5jsJ/qmYnAIjN+82F098F0VpjTBATlQAHCYxrwRSbksZsFGwdxJbP1/BMObocpWDWVIu6nayEcxb3yHnrUB9H3wfCOsCJNYlhGCm4s9uWNZko1eX9rWXcWnmnF9RDnpVKG2ZAtMyZXRaBeXvZXhWS81X/O66XahSOvR9eI/4uQJ7aZ77yHek8ikWi8vNibUD+fGfq7kgh3y1gACOcavlmbA3bGcV1SigRGXjM3uzrUk8qDNvF4hGD4FEQdv2sJtaj0GUx38gVaac2c0QltAnl5MguV9Wax42SXSDxn488vKfJJOdMHjsNm6eQmKt/vwcI15fQQ9I094VSVnR6c3p1QH72ERKIUk3J+otL05dtipgCjyEdJhYXvugFWnnWT95NGkuH0ULgYo6WoeanJ5FXY9avYtXVx9Vmqm3XX9S74YNyI6pUZdeZkVsmts/rUUUAz2le4/wQFKxhLbZIr0jLtLohk/VC8cImAuf/mP2fp2GUQpVfPrxVOs7diLa8BoNfzs9s5fCT+UKlsD/3KFEoynUN7kKVPrYR/9OcpXgEW6oQ0cjE5/r40OmP5YRExAjF79BO657lMFQWB58Rc1KVL
 JqGl2v2X
 qq0IZ/mDtWMIFuNg2lLk4tFrtbrt0aIjTBb8Mp5DDhta6ul92JzuFHfRMsafGseZwcdgRTo4MAAFQ2/mBrPKAA55ko3qZw/XSMAgX3Uap86GekHco1sPtQZwLzH/gLxuJt3/yaTd0JzAlBmrUj1ZFWeseziQgFGLldZvN6dJL+AEkbn83as2FO5E5qUdQBgyLeOBUWanh+Ze2RM7LYPWzj0gtysG97lc12leMhlMBdC/VX/PcQUJN6XeRVFgQTUafPlaGuR0KPvBpAsDdGfpoyOUlMT2Dr0uj5lR/Fm2AGPTIqR4cxDWsg8iYBdKUX7GgWbfkltXy7LknMcX8QM9xUtEsChanKcX204PaV2vTxRGqb392PxNmMmtsAYuJFqau8B1Y1L2cUojFXTwJKD9aRq4Rn0VIcrjToeJQIMkiD2FHo3Z7klKVQagRXosslScoqybik/Gc80oPwEI4wAcNBZ4MGZRx1mKPW37eVx9SuXyxqfJxpu690n/w0Z9HxC3jglz1Iwgd30CDc8E8vTUGoiU3dQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Catalin,

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Wed, Oct 15, 2025 at 10:37:12AM +0800, Huang Ying wrote:
>> Current pte_mkwrite_novma() makes PTE dirty unconditionally.  This may
>> mark some pages that are never written dirty wrongly.  For example,
>> do_swap_page() may map the exclusive pages with writable and clean PTEs
>> if the VMA is writable and the page fault is for read access.
>> However, current pte_mkwrite_novma() implementation always dirties the
>> PTE.  This may cause unnecessary disk writing if the pages are
>> never written before being reclaimed.
>> 
>> So, change pte_mkwrite_novma() to clear the PTE_RDONLY bit only if the
>> PTE_DIRTY bit is set to make it possible to make the PTE writable and
>> clean.
>> 
>> The current behavior was introduced in commit 73e86cb03cf2 ("arm64:
>> Move PTE_RDONLY bit handling out of set_pte_at()").  Before that,
>> pte_mkwrite() only sets the PTE_WRITE bit, while set_pte_at() only
>> clears the PTE_RDONLY bit if both the PTE_WRITE and the PTE_DIRTY bits
>> are set.
>> 
>> To test the performance impact of the patch, on an arm64 server
>> machine, run 16 redis-server processes on socket 1 and 16
>> memtier_benchmark processes on socket 0 with mostly get
>> transactions (that is, redis-server will mostly read memory only).
>> The memory footprint of redis-server is larger than the available
>> memory, so swap out/in will be triggered.  Test results show that the
>> patch can avoid most swapping out because the pages are mostly clean.
>> And the benchmark throughput improves ~23.9% in the test.
>> 
>> Fixes: 73e86cb03cf2 ("arm64: Move PTE_RDONLY bit handling out of set_pte_at()")
>> Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Gavin Shan <gshan@redhat.com>
>> Cc: Ard Biesheuvel <ardb@kernel.org>
>> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>> Cc: Yicong Yang <yangyicong@hisilicon.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  arch/arm64/include/asm/pgtable.h | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index aa89c2e67ebc..0944e296dd4a 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -293,7 +293,8 @@ static inline pmd_t set_pmd_bit(pmd_t pmd, pgprot_t prot)
>>  static inline pte_t pte_mkwrite_novma(pte_t pte)
>>  {
>>  	pte = set_pte_bit(pte, __pgprot(PTE_WRITE));
>> -	pte = clear_pte_bit(pte, __pgprot(PTE_RDONLY));
>> +	if (pte_sw_dirty(pte))
>> +		pte = clear_pte_bit(pte, __pgprot(PTE_RDONLY));
>>  	return pte;
>>  }
>
> This seems to be the right thing. I recall years ago I grep'ed
> (obviously not hard enough) and most pte_mkwrite() places had a
> pte_mkdirty(). But I missed do_swap_page() and possibly others.

The do_swap_page() change was introduced in June 2024, quite recently.

> For this patch:
>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks!

> I wonder whether we should also add (as a separate patch):
>
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index 830107b6dd08..df1c552ef11c 100644
> --- a/mm/debug_vm_pgtable.c
> +++ b/mm/debug_vm_pgtable.c
> @@ -101,6 +101,7 @@ static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
>  	WARN_ON(pte_dirty(pte_mkclean(pte_mkdirty(pte))));
>  	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte, args->vma))));
>  	WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
> +	WARN_ON(pte_dirty(pte_mkwrite_novma(pte_mkclean(pte))));
>  	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
>  }
>
> For completeness, also (and maybe other combinations):
>
> 	WARN_ON(!pte_write(pte_mkdirty(pte_mkwrite_novma(pte))));

Sure.  Will add another patch for this.

> I cc'ed linux-mm in case we missed anything. If nothing raised, I'll
> queue it next week.

---
Best Regards,
Huang, Ying

