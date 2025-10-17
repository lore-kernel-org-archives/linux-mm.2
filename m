Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA8C9CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 01:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23BE58E0034; Thu, 16 Oct 2025 21:27:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 212D88E0002; Thu, 16 Oct 2025 21:27:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 150118E0034; Thu, 16 Oct 2025 21:27:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 03AFD8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:27:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 940D71604A8
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:27:28 +0000 (UTC)
X-FDA: 84005868576.01.DB18378
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9A6F81C0003
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:27:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ig4Rl1Er;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760664446;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=toN8uDcHs2UA1ksRfEWAocNXcohSpkKSetMRHMkBztA=;
	b=Yj/coMTC47hERyao7tVPvZelLQSNd7JgDyPfxH4AxMcTGMVFParco1Ej/O66Rew3cmcmpr
	mhpRhGOvDcHMvETljyraT0UWebCWTsu6nvwkjlYutA8w5whTqsI/AuSXdjud8vDEJaeUSp
	EpD4WA85L/+DCd+KLgmU3fRyr70VPZw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760664446; a=rsa-sha256;
	cv=none;
	b=sNCXkgU490ZN5E+hMfDlJLpR9qfadnTnMhfJNrBn/QaL8cIN10hoNbfma/VybpfFFqwf2f
	cOqQJi19mHl+R9UfoMAQHX8l6KH3mMocs2hM1f+V+iCHIX97kNuoLOSTPI5eT5LhEW07qp
	DmL7Vsl+OB1ORLakB3U+woXXPssM81c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ig4Rl1Er;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b3dbf11fa9eso267311666b.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 18:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760664445; x=1761269245; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=toN8uDcHs2UA1ksRfEWAocNXcohSpkKSetMRHMkBztA=;
        b=ig4Rl1ErmBa3r4KJ6GsSJVnW+iRUmmiw1mAUBlnCZL8u26aJBK7XVzSMOmjO35DfGl
         g9NZH94nRpAyvRVM7wF432OoGMMq4GmXtBRdekTgBOHEJYJ+43gXqQ8XZWrtSHTdkDui
         CCeAnUoD+ydP/Kq453MS1eCnR2Wf9/CJXDvA/Xv2f6dQRQWF/8zOP6DqchL3EJ+MJPly
         67knTVynKCGmGVTBqT1zlDWdOXguZZ+XnCVrvcFsV4hViutW3/udUE1ix7fpdSAftFL/
         oxnZg2Nejpwy8WeXg2GYx25YsMK9XdCxB5drfz9Wb6foCu5Iwnhcd15Hn+T8th27Iluq
         bSHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760664445; x=1761269245;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=toN8uDcHs2UA1ksRfEWAocNXcohSpkKSetMRHMkBztA=;
        b=wdCdhC/LCn+Km8cGMvXl+daw7TNKNsdjAQnIE0yC6sYXklU7dc+kCNseTDCQpN72Xa
         bnET2AJJNmolDw7zphpY4q7Nr7CCvpnpyCbr9019tmSm5bEcPTgyh5JMNHk4OHURGz23
         PzSMT5AoQX1BJfKGnl6fT8qgSTq75Y1cMRzjZOolP4lz3udx61Fj1Mn+hEUWkHU1jVhb
         0vNad5d9vxxtPRzBX9NCvv+XzROl5gMxbQtjxiZUNTjuvjW9mZo4LIBfRdt4LUmeQ9ZX
         Y5VrMmJYdZerOt1N/4u3yEkNsNxSq4QnO+epNJrd9A3bOSWLURRS2b6isGXpoR3V3BBp
         fu9g==
X-Forwarded-Encrypted: i=1; AJvYcCXeNt5MVfuAJjbUSJXqbNVUIbY6eqUYBCIyDedqp5YDjZ0OKZvBpp7Kwh3GH0SMDFOFoaufPZf55g==@kvack.org
X-Gm-Message-State: AOJu0Yy01H7CHJ2ic2T1DHrKR4/egVNVjg0m9oMGmZXPjGpoNFnmI9R7
	8SRuJmsy/km5F3Hb24BacbX2QVWJ1z89/McdxVSzxsNm7BVELBHPl8lu
X-Gm-Gg: ASbGncsLGyFS3DAPV9c7WE0Tq0vdaVaCs7i3xRsXhvWnArbD25g9+TWfZBo014FBzOh
	R0UwargO/XP5xba/GvwEAWVqqaYFa9PloCr4nIWUB0hpdTMDjLJhgk5PnYcY6Ko76gR3xvCxzWi
	TsbhNA9MBu24pvmz1wOsM65EES1ZAkaUAArnIbrPiEYrZdcNP7/t0KBVEY2PvubNgWfK0Ds/2C5
	/4xZEqCMbbmLsh3WSd+1TRNBodl2MW7h7sZaZImhop3a7+n60AoiPKFAWXfQl842SfoDg4SLaXD
	PsYIAAjN4Z9XmW21He6kBGmvHldvOG2PWyv2mZZPtDpFl3yJvqN2DzHs7HgTG5rP3Oe2zOhzDja
	ToRZvgQDy7ydC401e0hRpHPe8Vp6OmeEqdsI9m0wu1YHYlhEDklgIc7CPw1fGwx2EAjEYIsnmX1
	AiIPg=
X-Google-Smtp-Source: AGHT+IFUmSUGHTa+ZyXOVo0fn2Et40lgRl36aDqlQg4U7gnNhP3iSC3H9vQYVs/vX439nT0/+aepnQ==
X-Received: by 2002:a17:907:3ea6:b0:b46:31be:e8ea with SMTP id a640c23a62f3a-b646ec7e5bemr217152666b.0.1760664445061;
        Thu, 16 Oct 2025 18:27:25 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5ccd6b03f3sm653857266b.74.2025.10.16.18.27.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Oct 2025 18:27:24 -0700 (PDT)
Date: Fri, 17 Oct 2025 01:27:24 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
	ioworker0@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: guard is_zero_pfn() calls with
 pte_present()
Message-ID: <20251017012724.4bo5oj2g6tdmp2fv@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251016033643.10848-1-lance.yang@linux.dev>
 <17c4c5f9-6ac8-4914-838f-f511dfbf948f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17c4c5f9-6ac8-4914-838f-f511dfbf948f@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam01
X-Stat-Signature: 9mx381n8hm3a1sxxasndkfsru4473qiz
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A6F81C0003
X-HE-Tag: 1760664446-278879
X-HE-Meta: U2FsdGVkX18xw733ueDv0tFq7tUwi4tFRNF91Q14rNYN85gzUa8tgH7TWjrV4W1DbAvAekgKcby2gCweVgKZqNQA9Pe+XoQFrvjevGpEtxcxV0upEYWNNu06Tfa0ZD+cnktz7mHhMYg7vPoAgQVNo/rYZYtCtw+LKO/G3iJ9ei+ZUUUPUiWT2jrvwcC2cEsPqPhyDVXmi1M7UU66b2hOXApnk77wpv3UN35gsslrrlwMM8IfEXBIOq8hshQhWlAJ3y6h281mSKW1cs+uviZV9a0QqTYDXYbEIbH4LJ5UdVDeDshSLx/xRQtJTLtnrJJp0ni5gDIhdACqZFIP7YSy8CApDTUTxavlAwNSdLYUg5kvGzkncJqeNZ7sdPYR4265FkSiS/tgSMKLn5vyUYkPVc8SrSuLpWCqU7JfFLQ1jXZR672GCI4wFEOVCyq++vUZA/ioQRvecz4KwetlEcELkch0IWMcNLsUSygXIql8EgS+LcMmAII/6PaF8/YkKZ/KKFuUd7KZsNzVZnjbHcCwwSGnWFXFBunBty+5RF7bT8TVFsEjIjWUAwmbXZIO4iZL3WdFb9FiTs2UfF99LS0OQms9Agu0uCeFKuUP+uVppcizRKdI9S3Miw1JB180DwISSHMBx98cSrh1+8fKpLfXVgCA5ys8bsDNGOwCPOT9rpJkjIrbCJhsNNDeHYn2ilTs3rHrSP/oQcLI8+JDXiFeqBYpkGbUbZMLnNZjNzM3/PQtNqDAshAsr7goog3CdntM2rXBBt0gR+PJfXigj+cjvcZ+HfnWemQEdVw/kKep82um7BpdVThj2O1Lwvteg3TkVYfxCGdZOIEa+0XNoaZFKILXVA3y+ci9iML69UxjOmiKcDjIEDAfdHMwuBwf0IZ6bThcotH9N9qsnZC/PQ6BDrD+N69GLnSWUMAHT4hkkJ5/GM16ez1BQrTiSagvKiTLWISydi9ayfYNTJ6emr1
 weyiT1P8
 vILduxi3CbvxcUSuLvgnQLaEUk5QTg6eEm9Ne1zEfAQTX434OWJHhz/spj/IwaGFkhCcQo1K1wOUZlQb/U5xV2fKMwP7thS2K7ph+AAiK+cR8HYzb6q3SvbNTGPVkw4hpveflOFNqaAc8g/08tbyAUOZ/YbY05Iltr3duPm2B1TcYsiQ53Rj1UVzuvMQiUH6hZ9Dgte4XOThdg14ZKuzLaEFn6KvzGVyzY2jlThbiH1f8vr/reFL1AQgoEiEpQvhwd8qWekH7oAcpAOfeSPFbAMHXXm2PNmjU+i5wndRwFmbcfSEyOTvukQCiimzP22EGal2VTgz7YAokvp2LkYWwYoj/FKJmzcygLJ8b2nGcA+/8hEfDK68mMQ5bfGaYqT1zFmt9chBbMxVTsILXJgYgNQSVYzIewTOx3zYIssA1uDzF1OH7IRzka9AZq/QklDf+DD/jE6feoJS8RPYzbG61PV0h/3SCM/wVXrmSHpw+T4WCco6dLwRgVuAeLSFxftGau9/C5UCzE8dftmpiBIfEu+RG+BKuvRspeeZdG6c1fu0pgHAKz7CbItivnoI+DEcpOLmUlV1+BSiAcPqzdx9pR/sj+q2HoDf/N2PuByUwWbX7tgQ59kN3hSo5NtJE5iCh9+7cY4zmA31TSmsirQoLGwbVzSwGdKZVxuJUIpQLZR1SU2P2N88+x7E0sKCAPLpToU2F/+w2KC2CO5BGnh6Z1JU63SaJFGtKimbj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 11:47:06AM +0530, Dev Jain wrote:
>
>On 16/10/25 9:06 am, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>> 
>> A non-present entry, like a swap PTE, contains completely different data
>> (swap type and offset). pte_pfn() doesn't know this, so if we feed it a
>> non-present entry, it will spit out a junk PFN.
>> 
>> What if that junk PFN happens to match the zeropage's PFN by sheer
>> chance? While really unlikely, this would be really bad if it did.
>> 
>> So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
>> in khugepaged.c are properly guarded by a pte_present() check.
>> 
>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/khugepaged.c | 13 ++++++++-----
>>   1 file changed, 8 insertions(+), 5 deletions(-)
>> 
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index d635d821f611..0341c3d13e9e 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -516,7 +516,7 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>>   		pte_t pteval = ptep_get(_pte);
>>   		unsigned long pfn;
>> -		if (pte_none(pteval))
>> +		if (!pte_present(pteval))
>>   			continue;
>>   		pfn = pte_pfn(pteval);
>>   		if (is_zero_pfn(pfn))
>> @@ -690,9 +690,10 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>>   	     address += nr_ptes * PAGE_SIZE) {
>>   		nr_ptes = 1;
>>   		pteval = ptep_get(_pte);
>> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> +		if (pte_none(pteval) ||
>> +		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>>   			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
>> -			if (is_zero_pfn(pte_pfn(pteval))) {
>> +			if (!pte_none(pteval)) {
>
>Could save a level of indentation by saying
>if (pte_none(pteval))
>    continue;
>

Vote for this :-)

No other comment.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

