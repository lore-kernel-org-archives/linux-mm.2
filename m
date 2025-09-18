Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8954ACAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 09:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7288E00E6; Thu, 18 Sep 2025 05:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C778B8E0093; Thu, 18 Sep 2025 05:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8CDA8E00E6; Thu, 18 Sep 2025 05:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A67E38E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:29:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56D481A0844
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:29:18 +0000 (UTC)
X-FDA: 83901847596.06.E282ED0
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9981640003
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:29:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Phht3Ace;
	spf=pass (imf11.hostedemail.com: domain of 369DLaAsKCAokmuo1vo83xqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=369DLaAsKCAokmuo1vo83xqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758187756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQDo9EaQ2w3t78/otIEPi+dSfFPSjpELcLYcaQVq7QY=;
	b=OKvYS63J2HGkTcxqfcbWRJRag9iJj491mBGGAIOL8Qj0KBIb0BFgUB7Fpo5VejySXNmnIH
	NhH9t3IJHw/LaLfDXNtHH5awHm0OJZmllx0nMY+ITM68mRIULdOElLzC3LzIt/El1T8D1d
	zm/RCkFWRjqxeOqA3P8Pp2vL8vLIVAc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758187756; a=rsa-sha256;
	cv=none;
	b=rcUcE2mXw7D6noAYYQwbpOxkWN0oGW6w2dgBHTEGYu19WzRc+epUG+y55983fKMEuO8UCR
	Ut34ps+QJtRNAcajMWadjfeJfW3Y7vIj8IuAjziiqrDu38S2Y0r/eyFmOtocd3hoNs/mlB
	I2RJsLshcGHLUU+dwNWhPDQzxFpTIs8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Phht3Ace;
	spf=pass (imf11.hostedemail.com: domain of 369DLaAsKCAokmuo1vo83xqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=369DLaAsKCAokmuo1vo83xqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3307af9b55eso199305a91.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758187755; x=1758792555; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xQDo9EaQ2w3t78/otIEPi+dSfFPSjpELcLYcaQVq7QY=;
        b=Phht3AcedLzSPq6lhw0aO0qW6jdddGqsbnvw3ZAHyy8Mmi/oFnAVF8W+eBQJgcQSvj
         G2mCc8h1uGltdlOCwyLONCqc51xMekE4qDPolzW5Yy5pPLWs5EWrCAbWxnkge0a9luPQ
         D+KHb10FvvjfxjVUcUzY0T5l5yuKZgHL4GGxa3Z6fzpMg/tRLI09oRljJzjHKXaMpHqY
         IqbsuJFIfdsMdBlfMMkkVVUip2kJR5OLMwQp4mfvsjglz2nA0p3C39iWmptHbpQmEGxH
         sxDqPEXu4iNWRx4jg0FCwv9b8JlTgkJIoxx1BBN27f4SAZ0rR/Xfv+yWMKdxGZsuc/2r
         u8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758187755; x=1758792555;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xQDo9EaQ2w3t78/otIEPi+dSfFPSjpELcLYcaQVq7QY=;
        b=FXwNO9Q3sbI3Fkd1scWvFO9TD+jIvJN1oTWqIBavLiZIrJVp+iLYQjh9VpO/5D6k7V
         f9KtiP9GgB9G9hXcuyyin3Jy7FuBnLTzFUVK8KebuJIWDDoYKhN1sia06NUvxFvh1PLO
         +SEBAVqGRow1HXVssAo6AXQ8nNlHTfRMJjTkjV4C3yU42qEr2kulF8xQOV2wMW5Ub0k9
         5iz6GhShKJO00RIPZn3TZGCKmpO8A5wjMQvWaCOItVxJPOGuS8f3JjIWTIMq0nh08MXs
         +KmoGGAoafYqmu8fghu/iW4YMKoL4nvrlTsDMCBmVM+Bbl/KkwVYt9Hsk/BJI3aQsDU6
         ldlA==
X-Forwarded-Encrypted: i=1; AJvYcCXI5qmG2dTxqhfaA93IUW+tfFs8UosFvxxfjIvmA+ESWrLg/9BHs6BtKRY9rO+poa+ewduDPpVufg==@kvack.org
X-Gm-Message-State: AOJu0YwLhiUUjjhl1hcja+Lb56JURrZE+uMFx2iaA2ct2wZtMPVKqkw3
	mPUr1H5C9Z4mUylTbnFHhmAaAmxYarvbdpUvDhbgtAwlvAZBcEqihWC+lIaK+HeE2mWoyCwGEFb
	kH1cYmS2N8CFdTdQv0d5vGxhumA==
X-Google-Smtp-Source: AGHT+IFUQkgkuqmfWUG7HDKnuWEBjj0flQA10iJkOzbHKdrj3MYRDVrEP3z7SCj5p8m6zzJiYkILKbi/G2n6kH7QHg==
X-Received: from pjbsi16.prod.google.com ([2002:a17:90b:5290:b0:32e:8ff7:495])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1b12:b0:330:6d5e:f17e with SMTP id 98e67ed59e1d1-3306d5ef3f6mr1962826a91.24.1758187755343;
 Thu, 18 Sep 2025 02:29:15 -0700 (PDT)
Date: Thu, 18 Sep 2025 09:29:14 +0000
In-Reply-To: <diqzcy7op5wg.fsf@google.com>
Mime-Version: 1.0
References: <20250613005400.3694904-1-michael.roth@amd.com>
 <20250613005400.3694904-2-michael.roth@amd.com> <diqztt1vf198.fsf@google.com>
 <20250916233335.wv2lf4fiejlw53o2@amd.com> <diqzo6r8p90a.fsf@google.com> <diqzcy7op5wg.fsf@google.com>
Message-ID: <diqza52sp0r9.fsf@google.com>
Subject: Re: [PATCH RFC v1 1/5] KVM: guest_memfd: Remove preparation tracking
From: Ackerley Tng <ackerleytng@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@redhat.com, tabba@google.com, 
	vannapurve@google.com, ira.weiny@intel.com, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, joro@8bytes.org, 
	pratikrajesh.sampat@amd.com, liam.merwick@oracle.com, yan.y.zhao@intel.com, 
	aik@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9981640003
X-Stat-Signature: t39wigyywtymn86wc7eb5pim6biysmk3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758187756-925912
X-HE-Meta: U2FsdGVkX19f8KXJCO1JA+VpOZ4OJin+fY9uZPGEh+/acCWCDVwjgvV+MiLPdQnsFJZmjWlfCZfTYxJah7ERrHv+0CujLOm6dGyDD8px4kwllJXKMcAadAsyWZpwAyc+LPE8mjxPux+VkzYGF/cqeXWA6GMImBEj+K1wylfV5FmmgLKBPA9DbytB2EpDtN0vrpxE8+NyIywtvIEPJwPNTTJdFDCowoBl6R6BR/BtQsfiZ4XfkdDIGdmpFxJA1vbd4JYG3m4kCB9qIhePUfOoYW9VYg1TPeKygEeVVtdQS3atZWt0m+AcycRJ44sy3CA7mLvYtZK7qddUHsnEKIjJsNVTQR7eLiygkMAk7Qk1G3VtoejacTTSMG4yidynmtxnCcXAu1V1pVqI+UEwanLy4clU0N9bj6sCwouEFnm5nP2Jz/EZbFsdlU9VNIsGghwC8a+jDVvCd39c/zAd1o0DTsXE4WIq1UKCf5p+M8TJeIjtpo3qZksuLilfaph0aPpORUMuyeFzliz0Plx4k9p2mLk5ryGG6nfRBHDfzP73uqV0fJo6H+BcarKHqaGSb1FZ+4aOuZ55So4QSTNffZIEGd5hmD0DT4VODI4eQW9d6zQpsSp3BUMlCGk9F2lytd1AcHNbwUihm6RHXQcCn/hgaaVsZVaHH3WOoTCsFVYxIw/GYXVtBYwioUuDFvKQXe2vMzHTpAwby5K3OWKgYMjpUUF2OlACrM2mS2UZSk0SyDGc2F8PknL+zNc3aLtXMkHOljCm1ZzfW/Tp/ItlHMLYiuu3iFWQvE/aB/os42B3cqzzN6lagPGhsHTQHhQyYqUPxWR6svRcbaO8DK/WDGf/Ylds0jgxY3UVhiXETD2TzOqa4kBo3JVn00fs2MQcrHDtSkxaXxtx7PJEWjBtH798QnnHXQVlq8H/ZX8YN/F/Y34gfLhKLoEwDBqiMr6BuxsydONes18JHUy+MNCKHeS
 AR7sL2XL
 JIfMgAvyAsgrAo9gyZm1dRf/FqVJfdnk+fDrYMfSIWhMX/+OyEAdQOey8ox/Z81DoBlWFWnFI7/I5yx0APZ5Jk32nsUjJmuLHGxWaYbBR1OoDEGBMPCQgjjOcYvUhelNkooMqU+ZHQLfYTClpkguQMQRFCCS/9yiio/uMjtZampTObZDCIY8Q1dnEIvJfJfr6dmdCpEpj/+Exn0+DMpsKaw8X7cyZ5/gjbR7E5vp8enz6txjKheqvds6HtLteKU9WCrXgkRKjW0yZsO2/Vusq9OVpoG6IOjXY9NiZQucPHiNLBk4Ur+TPF0ULCJs4Br4i7DKOEfyUhUrPnCGLEGcgSNl2rMsJMViRPgiys98RpoaCT2Q2TgXOSxTDBDx+28nFG4Qbyg+RVtzQ58GMCSDWvI5JTY8oWBeJfiW6G2oB9rSoa9yAHesn4t9B8QUbiTwodsUIGww6Xv8rmBHhxPB3edpDR8CSWNRuGsMYp987l5AYX0RguqWQQQWhn09NTbcpBjePK59p2L0IWVmTipWc48Q7GgaGBMbZ+lcFuBqNIcf+BnEc/fPP3qmw2pNThFvLTf1E13aM76LPoOBt/T0JcoKSLua80ojOdwd8neo2u3yLz5hjbKmPoWl7o6+jdMK7IcSV6vZPFrfSKEwOVHiEfitDyEC3wXfuiiRavDZuEWOnFQ0jLf2fOO7OlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> Ackerley Tng <ackerleytng@google.com> writes:
>
>> Michael Roth <michael.roth@amd.com> writes:
>>
>>> On Mon, Aug 25, 2025 at 04:08:19PM -0700, Ackerley Tng wrote:
>>>> Michael Roth <michael.roth@amd.com> writes:
>>>> 
>>>> 
>>>> [...snip...]
>>>> 
>>>> > @@ -435,13 +430,7 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
>>>> >  static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>> >  				  gfn_t gfn, struct folio *folio)
>>>> >  {
>>>> > -	unsigned long nr_pages, i;
>>>> >  	pgoff_t index;
>>>> > -	int r;
>>>> > -
>>>> > -	nr_pages = folio_nr_pages(folio);
>>>> > -	for (i = 0; i < nr_pages; i++)
>>>> > -		clear_highpage(folio_page(folio, i));
>>>> >  
>>>> >  	/*
>>>> >  	 * Preparing huge folios should always be safe, since it should
>>>> > @@ -459,11 +448,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>> 
>>>> While working on HugeTLB support for guest_memfd, I added a test that
>>>> tries to map a non-huge-page-aligned gmem.pgoff to a huge-page aligned
>>>> gfn.
>>>> 
>>>> I understand that config would destroy the performance advantages of
>>>> huge pages, but I think the test is necessary since Yan brought up the
>>>> use case here [1].
>>>> 
>>>> The conclusion in that thread, I believe, was to allow binding of
>>>> unaligned GFNs to offsets, but disallow large pages in that case. The
>>>> next series for guest_memfd HugeTLB support will include a fix similar
>>>> to this [2].
>>>> 
>>>> While testing, I hit this WARN_ON with a non-huge-page-aligned
>>>> gmem.pgoff.
>>>> 
>>>> >  	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));
>>>> 
>>>> Do you all think this WARN_ON can be removed?
>>>
>>> I think so.. I actually ended up dropping this WARN_ON() for a similar
>>> reason:
>>>
>>
>> Thanks for confirming!
>>
>
> Dropping this WARN_ON() actually further highlights the importance of
> separating preparedness from folio flags (and the folio).
>
> With huge pages being supported in guest_memfd, it's possible for just
> part of a folio to be mapped into the stage 2 page tables. One example
> of this is if userspace were to request populating just 2M in a 1G
> page. If preparedness were recorded in folio flags, then the entire 1G
> would be considered prepared even though only 2M of that page was
> prepared (updated in RMP tables).
>
> So I do support making the uptodate flag only mean zeroed, and taking
> preparedness out of the picture.
>
> With this change, kvm_gmem_prepare_folio() and
> __kvm_gmem_prepare_folio() seems to be a misnomer, since conceptually
> we're not preparing a folio, we can't assume that we're always preparing
> a whole folio once huge pages are in the picture.
>
> What do you all think of taking this even further? Instead of keeping
> kvm_gmem_prepare_folio() within guest_memfd, what if we
>
> 1. Focus on preparing pfn ranges (retaining kvm_arch_gmem_prepare() is
>    good) and not folios
>    
> 2. More clearly and directly associate preparing pfns with mapping
>    (rather than with getting a folio to be mapped) into stage 2 page
>    tables
>

Thought about this a little more and maybe this is not quite accurate
either. On a conversion, for SNP, does the memory actually need to be
unmapped from the NPTs, or would it be possible to just flip the C bit?

If conversion only involves flipping the C bit and updating RMP tables,
then perhaps preparation and invalidation shouldn't be associated with
mapping, but directly with conversions, or setting page private/shared
state.


> What I have in mind for (2) is to update kvm_tdp_mmu_map() to do an
> arch-specific call, when fault->is_private, to call
> kvm_arch_gmem_prepare() just before mapping the pfns and when the
> mapping level is known.
>
> The cleanup counterpart would then be to call kvm_arch_gmem_invalidate()
> somewhere in tdp_mmu_zap_leafs().
>
> kvm_arch_gmem_prepare() and kvm_arch_gmem_invalidate() would then drop
> out of guest_memfd and be moved back into the core of KVM.
>
> Technically these two functions don't even need to have gmem in the name
> since any memory can be prepared in the SNP sense, though for the
> foreseeable future gmem is the only memory supported for private memory
> in CoCo VMs.
>
> Also, to push this along a little, I feel that this series does a few
> things. What do you all think of re-focusing this series (or a part of
> this series) as "Separating SNP preparation from guest_memfd" or
> "Separating arch-specific preparation from guest_memfd"?
>
>>> 
>>> [...snip...]
>>> 

