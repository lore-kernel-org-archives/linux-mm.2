Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2687FCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8620D8E0005; Wed, 10 Sep 2025 12:12:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812B78E0002; Wed, 10 Sep 2025 12:12:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 728928E0005; Wed, 10 Sep 2025 12:12:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DB238E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:12:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30917B5C8C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:12:07 +0000 (UTC)
X-FDA: 83873832294.13.7E9D9B0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 261EC14001A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:12:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cdS8DQ91Fk2KRig7JcdWAE1Tb1sePXx/4ByqYYrByXY=;
	b=sdg70kAppCkG5iErz4dFqPNnDJ1SYwVBIOpDl+vtxWwIUxTQJ8YsDaw+mvl4MUzv5nOyGU
	fSBmrJVh664kGBfClfYBRfgoJ51kgvqHqX3BIKkPh85U6XjsP6M65U+x6/+lsgTS624lrX
	6Yq9OyE2F5Jqmr2JFMCNkbndbHcgvi0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520725; a=rsa-sha256;
	cv=none;
	b=breAu+aak8ng2Gn83CvGQBnhGftHzVdKKaOiMs1mJNG+Jn2T6eLlX2qTQXwxfqR6Z3+z7d
	b3VyVwY4yjf64k1BjuFx8BfNyxVOlzgje0LXYRobkjI2vsJfj2nSLru4+kBw/8hetqkehh
	fg2dD+FiTB8mNbEjPJ357DhqeDa0bkI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B91C716F2;
	Wed, 10 Sep 2025 09:11:55 -0700 (PDT)
Received: from [10.57.67.148] (unknown [10.57.67.148])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F3D43F63F;
	Wed, 10 Sep 2025 09:11:56 -0700 (PDT)
Message-ID: <250835cd-f07a-4b8a-bc01-ace24b407efc@arm.com>
Date: Wed, 10 Sep 2025 18:11:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm: introduce local state for lazy_mmu sections
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
 Mark Rutland <Mark.Rutland@arm.com>
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-3-kevin.brodsky@arm.com>
 <d23ea683-cca4-4973-88b1-4f6fd9b22314@redhat.com>
 <ca2054ad-b163-4e61-8ec4-6f2e36461628-agordeev@linux.ibm.com>
 <e7acb889-1fe9-4db3-acf4-39f4960e8ccd@redhat.com>
 <2fecfae7-1140-4a23-a352-9fd339fcbae5-agordeev@linux.ibm.com>
 <e521b1f4-3f2b-48cd-9568-b9a4cf4c4830@redhat.com>
 <47ee1df7-1602-4200-af94-475f84ca8d80@arm.com>
 <b2e52967-7ca1-411e-9c66-8d3483624ca7-agordeev@linux.ibm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <b2e52967-7ca1-411e-9c66-8d3483624ca7-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 261EC14001A
X-Stat-Signature: qokjxto93fxi49uxdsiyn5r9ftt9zqbb
X-Rspam-User: 
X-HE-Tag: 1757520724-355155
X-HE-Meta: U2FsdGVkX1/EcLZuci+LYCZjT5/toPTDBQuXg63CWklyrFNcvkRVQCk3moeVjB3phmo+sBjA3vPIO2l00MRxVGoHXpmRxHXGhYMNmnYCTdcvKBPu+JpNgXcFBcog9G9NkRu1f0pZCmSxjhS494FEyuxPYC6+Wzs1tGlmky7+JzgdRCTSyFZCWY/y+/Aikvun9psd+b1cHq1r4v3s+a0gUrirvU4wGNVOQkxmbkGq9cHcbo8QDRGwRUMsa87pXhOAQFDU30fdY1osq0ULpss3i9yNn1avK7/iSYtBN4/cTonyTrNj2hp1PgaqLNwE1Io7nl+Uk9+FDQszLS/l3ntdgc0hcQ9jkCHdpc5iwdKVUoiLcx/Cl89h8ksX1w47v5ZY2CQTRLX562tT46kcQDSkt57N/ulUBWAYspUT0yqXhw6zy9kbfZRHoR0l6mHmDDehNbCBIhf1bg2RFKjOyYsJSKKu+ksz3ZwSzlB6Ar+sf/YZJuIooHVOAsfGesrOgS1J5Zwg0ywb2KySMyk0fSKUzrYCGG8D6o24VV2jZfAmoRaV4k9Tuz9z0qoWYbePAyeI5oCRn8g6Ub/Xl56Xj1htdtjop/LS2wj+vOnewcKhhtuNiQ5oJg6+OVc8gbPgxEZQvQwBltlXZOm1ZldI9Mwm92GJwlW+8vRLVfanA/SmgZg2ET23G3JptY7ihJAWu1duoJNPVuOEqkw+yrrIcPAezTpbW+2on3pJAAGt62dJ2cIvrjae08dXKxZ+0cUI/TSx/lcZy8oWlklzsdAuj8NFJwU9haoOtsnP+7tV1OTJ3ymHBO5cvrefNq1lvuzBm8dA4ENEFTDCEFZNd1qX2x8a3UElMh+gGyBOdrklPmZK4ES1sXoC6MRe5xCbuvy49WQ19rWNvGyzyVlxlzkQnQH97zlx/6iQUgWDfl8tNv+zTGoIXF2BCGXG39MYptOArz8Bk4/FjqZV28w/0a7lJNW
 0bVGU/j2
 LaOqGhlER0hk/83qibNcSMLjoZuVEW/kanUSivalAGFOYqlRAhWmjeeQ7Ha50q5HZwPpwirZvjTR6LqZLXeUDIOy9zY13yg0WiV946ap36sLOBDmyeNTMeM5orNuTR1+p472DUuQjFLTFRplO8xCiyvHJrKEbaXtOwG4b1fyTNVMS4n2CyZ54Zh8WTbKx4ZEt9j/UtvFaEFvzdb6Oa19OexIE34Zg6DLq0RpG+jw7CJ7m/kRdmllvmQpDd/y1h228GXW/b3AyadorAEY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/09/2025 16:38, Alexander Gordeev wrote:
>>>>> Would that integrate well with LAZY_MMU_DEFAULT etc?
>>>> Hmm... I though the idea is to use LAZY_MMU_* by architectures that
>>>> want to use it - at least that is how I read the description above.
>>>>
>>>> It is only kasan_populate|depopulate_vmalloc_pte() in generic code
>>>> that do not follow this pattern, and it looks as a problem to me.
>> This discussion also made me realise that this is problematic, as the
>> LAZY_MMU_{DEFAULT,NESTED} macros were meant only for architectures'
>> convenience, not for generic code (where lazy_mmu_state_t should ideally
>> be an opaque type as mentioned above). It almost feels like the kasan
>> case deserves a different API, because this is not how enter() and
>> leave() are meant to be used. This would mean quite a bit of churn
>> though, so maybe just introduce another arch-defined value to pass to
>> leave() for such a situation - for instance,
>> arch_leave_lazy_mmu_mode(LAZY_MMU_FLUSH)?
> What about to adjust the semantics of apply_to_page_range() instead?
>
> It currently assumes any caller is fine with apply_to_pte_range() to
> enter the lazy mode. By contrast, kasan_(de)populate_vmalloc_pte() are
> not fine at all and must leave the lazy mode. That literally suggests
> the original assumption is incorrect.
>
> We could change int apply_to_pte_range(..., bool create, ...) to e.g.
> apply_to_pte_range(..., unsigned int flags, ...) and introduce a flag
> that simply skips entering the lazy mmu mode.

This is pretty much what Ryan proposed [1r] some time ago, although for
a different purpose (avoiding nesting). There wasn't much appetite for
it then, but I agree that this would be a more logical way to go about it.

- Kevin

[1r]
https://lore.kernel.org/all/20250530140446.2387131-4-ryan.roberts@arm.com/

