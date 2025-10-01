Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34662CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 17:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DA4D8E0005; Wed,  1 Oct 2025 13:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B25F8E0002; Wed,  1 Oct 2025 13:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EECF8E0005; Wed,  1 Oct 2025 13:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6EB8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 13:22:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F812852E3
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 17:22:31 +0000 (UTC)
X-FDA: 83950214502.16.1A47F89
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2B66D80012
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 17:22:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759339349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KtHH5slsD8Ox5MoPLqaiqd9jBeTgdv0YVlgjsuTd720=;
	b=yf+Fi2D/tYKt6hE8tKIlue/qnH2WuRDtokSl7Zgsr/9QiPC5XsKAnbhif4rauB9Ohl+xbc
	4hEQn9SAdvBOVF1xf7vksxptA93r8DqawIk9m0RUGwD1T34+8NgBx/M05HY78YFGbRuD1o
	ZWPlrH8q6BOHz34FT6UeGtcl0voNWqE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759339349; a=rsa-sha256;
	cv=none;
	b=pU23/X77oVnAr+gztlaTHQaJrzPk9+AhrBIbXx/lAAmjhYTWxNx8nLiOaJM0BP07Owzv3b
	vf2jn5DJu5MyVt8YcWfUS8w2ozK60FVBMs76K0X6L9BHAZQRyLLMoaeR5HEWlLUt0XMgyM
	akD6VOk1SHBOjUTqdV27vXalgv+mKRo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DDF2116F8;
	Wed,  1 Oct 2025 10:22:19 -0700 (PDT)
Received: from [10.57.66.40] (unknown [10.57.66.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 30AE33F59E;
	Wed,  1 Oct 2025 10:22:22 -0700 (PDT)
Message-ID: <69b1c489-b4cb-4bee-aff1-6c76fc48cf29@arm.com>
Date: Wed, 1 Oct 2025 19:22:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 13/18] mm: Map page tables with privileged pkey
To: David Hildenbrand <david@redhat.com>, linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
 <20250815085512.2182322-14-kevin.brodsky@arm.com>
 <48ed62b1-cceb-4bce-923c-25c11dbccc37@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <48ed62b1-cceb-4bce-923c-25c11dbccc37@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2B66D80012
X-Stat-Signature: ay7ackudwjsp95nq5d8bdmzp7aphwp3z
X-HE-Tag: 1759339348-737702
X-HE-Meta: U2FsdGVkX1/HgEOccN8W1mF5pyZQ5z06SmtfaqN3h4O0iyyPweKsrw2ZPmo0+95CA60lWU0Hy7IHTQ1b4u7lWjlO49VhNVw+P2AZCTiHm+zTHak4/3kUlQ1Oq7up+u1lAJSebqASfP+QOMFv+MdkbXFx1CshONf7INZRJL6hgqQAIznr0EBH4rw2loAKHXHrnNRJ87hXdaI3GmoO5nwfyVkvjbv9pRJ7WHTN4q0hb03F7Jnd+Yv1tXhs3c4yJfxdSXXQLRkbL2rMKJNOju45WOa2NNah3GlCUHae0pMTPd3zoHM+KMQuCn2myh3jL4leq9t6ThPynEeP1yG2FWS+PtK32Zf9YmwoSKmBc7+F6OUt58PO6YXeV8R2xFq/70OyFG+zganSRIjja4Abr5jtIZ2xe8UqOpptXcKr1P211TYitdH+Jmh5P9s5OBGomEif3TyxNM4hoonsbjTQ6wuYl1I1IfvIGXYBD3izPw+WBMzTRZMkblXgyuJC6osmTDGmbTwzN+J3zz8MI15b3HM00oS1NrF1jpZteg0fo4xyTNAwa8Pa3QKOmHHaXDlrdTf8FFmyau9n0kY6RLXtsj+w0tsPx/QPi9/Th1CDgCrTVGRHBHHjhkhqom5S4ABcqcQvJKuJ6E5tW+6Op8m3dAZm1aSTF+82nWpkhwiJyy/ls4aNlLznUP3WoLGiGsirSFIY7q4akclBfvvZYECiVAqx1zksF+gb/7uivrxbcAYGNp6iMxn+lRSJfrCyFQwquvRAofC0dNH6k7Y4xebrcK6vO6EdIAO+MifffZ87jAahGF95UiBW9T4EB8kgkxX61DeJokAzzpjCJWX/I8qlu9Wpt7ktt2BmgzUgA497Q7XlpblMvbRdVMLPENWRw9uhR3W6v53RHWQ4Kp4ojSlAsAYNzfVT160YbY+9Or67SYe4jTIvmRkEXkn1UZJBkr7kPhH4OS90jl1FbhmbLlNe+px
 xzy8ww1E
 wfiJmuCwNCr0ADLXUmIOIdyQM1iTCgVQGmLMuDQtUpAEz0+KWitu7+ckGNwiEBFoD62rWsjdqq4bNI7mvCCEMPQZzIHUEE7ni+G8P5LDioqRP1U7UksR+ik0JPgiK2XGcy1vij/A2oTNMi/NoGbJweDfUHPaUlXLQeM3oJGoOoYwrF8QU4WwyL4vy89NNvHTPgu8EoCurH0hTyb+MeHfPxX7w2sDpIsVPQ2B4wFZSfVk6acz6mjqI7Lgn5iPjgWDCAHbYwla93SDH8Smry4OnHaLePTmtgnN4rq0j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/10/2025 17:28, David Hildenbrand wrote:
> On 15.08.25 10:55, Kevin Brodsky wrote:
>
> Just wondering, should the patch subject be:
>
> "mm: protect page tables with privileged pkey" ?
>
> At least patch #2 tells me that set_memory_pkey() will set the
> protection key, and the function is called
> "kpkeys_protect_pgtable_memory"?
>
> Just trying to connect the dots here :)

That's fair! I suppose I meant "map with privileged pkey" in the sense
of "modify the mapping/PTE to set the pkey". But I see how that can be
confusing, as we're not creating any mapping. I'll reword that in v6.

>
>> If CONFIG_KPKEYS_HARDENED_PGTABLES is enabled, map allocated page
>> table pages using a privileged pkey (KPKEYS_PKEY_PGTABLES), so that
>> page tables can only be written under guard(kpkeys_hardened_pgtables).
>>
>> This patch is a no-op if CONFIG_KPKEYS_HARDENED_PGTABLES is disabled
>> (default).
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>   include/linux/mm.h | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index d9371d992033..4880cb7a4cb9 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -34,6 +34,7 @@
>>   #include <linux/slab.h>
>>   #include <linux/cacheinfo.h>
>>   #include <linux/rcuwait.h>
>> +#include <linux/kpkeys.h>
>>     struct mempolicy;
>>   struct anon_vma;
>> @@ -2979,6 +2980,8 @@ static inline bool __pagetable_ctor(struct
>> ptdesc *ptdesc)
>>         __folio_set_pgtable(folio);
>>       lruvec_stat_add_folio(folio, NR_PAGETABLE);
>> +    if (kpkeys_protect_pgtable_memory(folio))
>> +        return false;
>>       return true;
>>   }
>>   @@ -2989,6 +2992,7 @@ static inline void pagetable_dtor(struct
>> ptdesc *ptdesc)
>>       ptlock_free(ptdesc);
>>       __folio_clear_pgtable(folio);
>>       lruvec_stat_sub_folio(folio, NR_PAGETABLE);
>> +    kpkeys_unprotect_pgtable_memory(folio);
>
> This is all rather nasty. Not your fault.
>
> In the near future page tables will not be folios, and the whole
> ptdesc_folio() conversion will not make any sense.

Ah, interesting. Any patches/series I should be aware of?

>
> Likely you should make kpkeys_protect_pgtable_memory() etc. consume an
> address range, or a page range right from the start.

Got it. That said, as per the discussion on the cover letter [1], it's
quite likely that we'll have to change the approach completely anyway
(i.e. allocate PTPs from a dedicated pool where the pkey is already set).

- Kevin

[1] lore.kernel.org/r/aMwd7IJVECEy8mzf@willie-the-truck

