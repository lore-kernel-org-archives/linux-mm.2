Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EA11CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32BE46B008C; Wed, 24 Jun 2026 09:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DBFA6B0092; Wed, 24 Jun 2026 09:52:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CC126B0093; Wed, 24 Jun 2026 09:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA0D66B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:52:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 666E01C1893
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:52:33 +0000 (UTC)
X-FDA: 84914946186.17.9BE0128
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id 644B54000A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:52:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=joK+Q83Y;
	spf=pass (imf07.hostedemail.com: domain of abarnas@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=abarnas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782309151;
	b=0l5q1WbVBgHninHsQEzxHm9kGcJEbnBLcQ8X1+gu9P61XHslx53MUfspGvcNWJ8zofpgkW
	KBj7+7A6yUb1AqzC244DbVeNrxnwN1kKiS+t2Kqv+5Y3+US+OBqW+6useBsuq5+T9Wkc4B
	6Ei9Bn8TQu1LzWUuauIWST0vfWIsJEI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782309151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H9fHKpp0hsSkHZoVgpfSSRVfUXpN+LFN7Jx/OE3znng=;
	b=hzjEjRxlr2TeQDkUwYUKmWRV2CHN26ZC+via/M9LAXrvDefN+fE6q/8+Rue3DdNhDezNGn
	j3qF0bTAMWR2ErnLrJABcGrujdyTZ/FGYi97GqdzQn1TdLSX/zn8ronW3MSTXgC5dKtaPa
	qjkgnbug/Hf5rv1dK0aHGNi7g7Exlzo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=joK+Q83Y;
	spf=pass (imf07.hostedemail.com: domain of abarnas@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=abarnas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4924f8db066so6281885e9.2
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782309150; x=1782913950; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=H9fHKpp0hsSkHZoVgpfSSRVfUXpN+LFN7Jx/OE3znng=;
        b=joK+Q83YCr9kiaW4i727468n/7y/Mb0lFLlXnO0wmj2MhZoRSUiNnzKd9DTeXZLBOM
         IbXANGrKvGVfq6QMSqbv2PCQpNdSVbrR4SdbR5RfwEVaGkypsJp7Vs4czmI4pc8I08IV
         DsRQmcqsNIOgGt1NvouaBhZwrPP0ZseZffV/WCrjSRfkutMbfgbHG8NapeBBI7ABGaMD
         72MJX+9MzVbdcTx6iVqEKkKaktgAwlrx3Qw6WzgqhG7HXbeQJF5L5MZaWCBcd3tg36CB
         yfB6j50LVhsHUWLFGrnKJaFoXBgD+5sLkZwOErW7tkg2nEeFI0lyyO3gA1YbxH0KHK4B
         D0oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782309150; x=1782913950;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H9fHKpp0hsSkHZoVgpfSSRVfUXpN+LFN7Jx/OE3znng=;
        b=Gg7wZs8Oi4UtiaU+o4ezFAwAWJ0IaDICnvckBtyoXYWXRdKqTiTELnjc7Ln5RbqnYb
         8MqFTVNXaefB8paKp8bshlEqUdRkeCHwKeeFvrgqz1e8abiHp6LvvnjRArH1rcQi+sjE
         w/S05lL2FNpUa86NIl/k7j5y603ejtL6/5Iimn7zOKcMbTRWxkbd4inSOxog6gfttnUp
         MYk3aXKj9260bhTpV9F4ZgTGfaLfoFGKkFcy+zZbp8lepcnJksyGcdvXvS5Jc8eDRZ9w
         PIJPhYID59a2eJRFp4MchZ5sWnMGvUn+IbkHnDtOS8woZtrZCdBAu5wsDRWqQuBmrFK3
         q1Zg==
X-Forwarded-Encrypted: i=1; AFNElJ9qRl/Xq4YEk6xMr6gbO/k9ba7nfvj+hg/YP+efAOmPUf+vmvMWzDQlXkQ/ST2yjP3U4yItYPRgHA==@kvack.org
X-Gm-Message-State: AOJu0YwA8pIBwCPMTo22YkcpqxbHfLRwMGXnf0tQmmSZJUtb6TWm70uO
	ysZXeKtaU66V4EayHu1a65UWVssZFqhdnQ3072ax55LUO2mpRzlOfJD0+RyRIWPm8w==
X-Gm-Gg: AfdE7ckQ4jNLHpskbVdsFUlAjsbtBGV+5cMteY5cRdZ3rz7m458N38dfBiZqQZiM5aD
	RGnngiJOQ4+x9mZCWB3De0opGMyQ1+VxDdsPCojPppVgddBL/+NqtVgBzLNczLFI0CoqOCx8Wty
	DPu/IyLHs+gCbzNy4XJghsKkxl0C2zGg3uoLDDA8xFBk1BJp/JZvpmA/lYLTl9tKDG2UfWEx4/u
	1NuOQhBlmaJ91ZweTh8aypbfLQ28J0BIg0nZ4uqa2wnxf7rccXC4mrBszR4PPRIzTE2ylLGewmN
	E9iz+c3gDO3ZxnEs1rjVEJL3jjGQbuKeE7bNu2TqcS7PmSMcS6igrZZ/Ti7G8AkGYRyoZAaSTXp
	qNTjNgod3tk2GdJJ5+00RruL4OVWsE8LSPkxgumYWY9T8bmYdfp/o/nkuVlqxdLgYsM6sr1Bcdh
	a9UcqxZ/RaVAH1QfEUQ/r9C9HSyDaBJ0JKKe9yL/kGdRxNH/k=
X-Received: by 2002:a05:600c:8b71:b0:492:59a0:4a65 with SMTP id 5b1f17b1804b1-4925b3802a0mr117077955e9.27.1782309149240;
        Wed, 24 Jun 2026 06:52:29 -0700 (PDT)
Received: from google.com (97.113.76.34.bc.googleusercontent.com. [34.76.113.97])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492494496cdsm341827885e9.10.2026.06.24.06.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:52:28 -0700 (PDT)
Date: Wed, 24 Jun 2026 13:52:25 +0000
From: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [RFC PATCH 3/6] arm64: mm: fix restoring linear map permissions
 on execmem cache clean
Message-ID: <ajvhGajVO_GFlcrY@google.com>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-4-abarnas@google.com>
 <402e247d-1eb9-4842-ba9a-712a3bb9b438@arm.com>
 <751c564b-d6c3-4bd5-a269-e3de89e8cf13@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <751c564b-d6c3-4bd5-a269-e3de89e8cf13@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 644B54000A
X-Stat-Signature: w6w1bkkb4uefgehmj764t54s1ncnznts
X-HE-Tag: 1782309151-659077
X-HE-Meta: U2FsdGVkX187wSQRMCmJKXFzgsay4y2HLQB0UAI+wt21yrSb+YeljzOpWFBZW/r5nDzVpmyfzOfZsulnKRIP5qa3z4IJnD77G7uJBls0fy8hdPKZJC4oQhGtVHFbBLp+PGFcuTMnAn1fw5M79uy9K7iTcmX5JC6X1SiR7TgSQGitpcxbVsadBSxLWZJqAkmFSxKU53luCaa6Uuixc6wd01BEBqwIAZ0WAt922fe1j2Ln1ZwhVN+9gpWqPE8iwZDwC7UrcNNMUEoiU9ZDSy2C8JBe+FW77Y1iN688S8FyADfb0Z3Sd3GIUtQjyC9cy5Yv44v5lJKh77xEauFtGevHwY/kuDLRKey97QnffmceNIRBhDAEP3YzfEx5KIaMsQpkgKmaIETgzNjXTqpKVQ71Pju7QlVipU7qLeDlfbk3T3GDeX5TdTRLGu/QH60sx+SvvrCPMBAWarr2cvkJ/BUWZ2XnjONNozK8ER78tDQpWicld59LGrJpXrrHqQ53QtojT/G5UoYYWLsyMRgfKnKdU8urd4OISbFKwurdCHl5Zupkb51M/3UZEDE6w+LqzyvBK45cyDnTM6PzHuZ/A/5LTM4Uz4uyIP+r5RSnowlJbSyhosMFEJ3NivZSQ77I/dJO5mddK5H2cYt1hAJvC2CB6Sj4CtBHHIB35kO3T99vEXjzjVmyP3Hl2i0pszlz/YFyoU3bbiaITSufSxGnxiuZsIWyEVxiiCZPrx2Q3MKxGeP+Cs8HfilKh6InBukDUXgwsLF1jHFWvbp78a8jfrZQsuZnunUqkSd0IzhL10i4I6eyIFfoQCKEb0DIPfm5hE8wgyPaelZlNscogLgpjw5zduGdyhJzna9N3N5wEX5xvFzWTW/nNBenXFLEw5GQz57wYqWtH4M/ccSP46walDDuqZU7LFowTh8GANTValerRaSYCeZzZZ9Nonkxu1T6K+13fX8b/gmh98RJjtH5J2P
 dgR4Qw6B
 ojNNqPif3Y1sfY4Elm59gGnqUA2xMYuZd71NfA13xT+OCOS672Pb+L/78EMgRAQNglase6KepaCAX//wLcclBGT1EzgUb7Oj4nzUQfoxz3+fG7v6eK2UbNTxoOdWFzL5AQEmNv8jnxBGheaVBb6eWTETzyQK76ZnOufyxDzU+T29JfQkaqXeQxglB2CuH2T0hmpt08c83CLyQNpKkG8d9X28lW8AnaUa3BjVLJZgRxjJnFQio9eRL6BOxF5xQfIJFhrS05vVZwhQc1FAMelvQg390RGAiwDmnRhU4mDq0hn4SamNlcj9DtC9Z09X9qThS+Zrh7HKP5cgAh4PM02NiR8Eq6cGAvYeBHwO+oPRrsurOreBgJ9jA+v4X88FPL6gbynQvBKhnFK4HMRmFoWybeGO3OoXt4gkbrJ1SxjU5Uk3S5gF5Iq9c+Z8nvbTVfRbBMllN4fLqxdsks/CQ8TuPA4b/3rNc/Bl4QrehWQ+Um+2wRa1wzax4W0V4azIkb4xFJuL0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 09:33:18AM +0100, Ryan Roberts wrote:
>On 18/06/2026 16:05, Ryan Roberts wrote:
>> On 11/06/2026 14:01, Adrian Barnaś wrote:
>>> Strip the read-only attribute from the selected memory range when
>>> restoring the linear map after an execmem cache clean.
>>>
>>> An execmem cache clean is performed when a cache block becomes empty
>>> after unloading a module. When making the memory valid again, the linear
>>> memory alias must also have its read-only attribute cleared.
>>>
>>> Without this change, the linear memory alias remains read-only even
>>> after the execmem cache block itself is freed, which prevents subsequent
>>> allocations from writing to that memory.
>>>
>>> Signed-off-by: Adrian Barnaś <abarnas@google.com>
>>> ---
>>>  arch/arm64/mm/pageattr.c | 17 ++++++++++++++++-
>>>  1 file changed, 16 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
>>> index 88720bbba892..eaefdf90b0d5 100644
>>> --- a/arch/arm64/mm/pageattr.c
>>> +++ b/arch/arm64/mm/pageattr.c
>>> @@ -239,6 +239,13 @@ int set_memory_x(unsigned long addr, int numpages)
>>>  					__pgprot(PTE_PXN));
>>>  }
>>>
>>> +static int set_memory_default(unsigned long addr, int numpages)
>>> +{
>>> +	return __change_memory_common(addr, PAGE_SIZE * numpages,
>>> +				      __pgprot(PTE_VALID),
>>> +				      __pgprot(PTE_RDONLY));
>>
>> This is not sufficient to convert an invalid entry to valid. As well as setting
>> the PTE_VALID bit, you would also need to clear the PTE_PRESENT_INVALID and set
>> PTE_MAYBE_NG.
>>
>> e.g:
>>
>> int set_memory_valid(unsigned long addr, int numpages, int enable)
>> {
>> 	if (enable)
>> 		return __change_memory_common(addr, PAGE_SIZE * numpages,
>> 					__pgprot(PTE_PRESENT_VALID_KERNEL),
>> 					__pgprot(PTE_PRESENT_INVALID));
>>

Thanks, I will fix that

>>
>>> +}
>>> +
>>>  int set_memory_valid(unsigned long addr, int numpages, int enable)
>>>  {
>>>  	if (enable)
>>> @@ -362,7 +369,15 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>>>  	if (!can_set_direct_map())
>>>  		return 0;
>>>
>>> -	return set_memory_valid(addr, nr, valid);
>>> +	/*
>>> +	 * Execmem cache uses this function to reset permissions on linear mapping
>>> +	 * when freeing unused cache block. On x86 it makes memory RW which is
>>> +	 * desirable. On ARM64 set_memory_valid() just change valid bit which
>>> +	 * leave direct mapping read-only so use set_memory_default instead.
>>> +	 */
>>> +
>>> +	return valid ? set_memory_default(addr, nr) :
>>> +		       set_memory_valid(addr, nr, false);
>>
>> Surely execmem should just be using set_direct_map_default_noflush() if that's
>> the behaviour it wants?
>>
>> I think that the current implementation of set_direct_map_default_noflush()
>> doesn't undo the effects of set_memory_nx() / set_memory_x(). That might be
>> worth checking?
>
>It's also worth mentioning that set_direct_map_valid_noflush() has "noflush" in
>the name, implies it doesn't expect/require any TLB flushing to occur. But the
>implementation will perform tlb flushing for any case that is not just a
>invalid->valid transition (which for the existing impl is the case when
>valid=true and for your changes is never the case - see __change_memory_common).
>
>But execmem doesn't do any tlb flushing so it looks to me like it actually
>requires that set_direct_map_valid_noflush() handles the tlb flushing? All seems
>a bit fishy and probably warrants a cleanup to make things clearer.
>

I think that the clean approach would be to have the `set_direct_map_default`
function (without `noflush`) that does flushing as needed (like the current
one on ARM64). I am not entirely sure but x86 seems to handle permission
faults gracefully while on ARM64 those would cause panics. Is that correct?


>>
>> Thanks,
>> Ryan
>>
>>
>>>  }
>>>
>>>  #ifdef CONFIG_DEBUG_PAGEALLOC
>>
>


Thanks,
Adrian

