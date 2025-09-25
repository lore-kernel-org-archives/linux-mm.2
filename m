Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BD6ECAC5B0
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 23:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB7CC8E000C; Thu, 25 Sep 2025 19:07:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68F08E0001; Thu, 25 Sep 2025 19:07:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5638E000C; Thu, 25 Sep 2025 19:07:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA8238E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:07:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60B74BA098
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:07:40 +0000 (UTC)
X-FDA: 83929311480.26.A8A7EDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6DE3A40006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:07:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=brT0Fr6Y;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758841658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BeSxWx48aKNidsNnkG1cI4RNEijG5VTEYRv+7ldzcFg=;
	b=XiwDvSONM5/1bTeYVcxmEBV6k1wt+LlcikQsObNVpc+/EnmTyLhbfAmxfYqZPGq8HRCyvX
	12Yi+yWIl9ZZ2oWyRZqW68h3ClpTQfFp+zXRrXJIfuRTteoZomVGvEQLYGA83FahqU+5ts
	RbZaUkYYex46SQma3C8Q1naPIUApy/c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758841658; a=rsa-sha256;
	cv=none;
	b=U0Qv7PrLF+TNBL79H/Dfo8h6xzPLYyYdIit176lqUkQn01Jt2kh+chq+4BzBp/fovmAJW+
	SNFGzepdDoUf7cNfW9pLVj7vY7w8gG2T2Yfq17thLXgcMWbM3BuSuSx6Q410exnR4YcbYY
	pEuWZTrhSjIVnDv1jiAhUVxtAKnjVhg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=brT0Fr6Y;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DBB2A440B0;
	Thu, 25 Sep 2025 23:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8587BC4CEF0;
	Thu, 25 Sep 2025 23:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758841656;
	bh=BRwkdIeOqd/rDVvAiAIzP2EoO7oEfbhtEfm+rEGKFHk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=brT0Fr6YzrHpjdAzSDVEF69LvFcoZsXnjFk3WSAs/SBLeKlq+50menaV5UZGIf2gJ
	 fbWVfK52c25O0zAj+WLq1+m2w6F8eFzJR1BSAf35AZgfZo7BPjvk6ueGC6gbstGOLN
	 Bx2lG3eaE1HtKLIceNbZGzSmejfezbhfDI/cfBNM=
Date: Thu, 25 Sep 2025 16:07:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: agordeev@linux.ibm.com, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 ryabinin.a.a@gmail.com
Subject: Re: [PATCH] kasan: Fix warnings caused by use of
 arch_enter_lazy_mmu_mode()
Message-Id: <20250925160736.a8c65952370d66d1544f9309@linux-foundation.org>
In-Reply-To: <20250912235515.367061-1-balbirs@nvidia.com>
References: <20250912235515.367061-1-balbirs@nvidia.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i6mxs8uoz4anyeznop1a3ueswsc6oaxd
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DE3A40006
X-Rspamd-Server: rspam10
X-HE-Tag: 1758841658-325316
X-HE-Meta: U2FsdGVkX18xnBAGvoX89BFk1Lmxzh+hm+fjCJ7Vcgx8HwqNXK0vFd5DLGAS1cjY75XmhGMdkhJYvfqFPRc8P0Wfpx07SvBFhO0Co7bJRUQdhF+xecBjmPBxEGt2C6lTeYB6h5/tdcdjDT+0JLHBJY82Ai/cpepDTVMVJBPoEhtAsoVNNh8FIjmsGzjO6+Oiaybaf8q0Y8HEq6eY9vL2mc36ZeBLabWz0Wjh0jSmFnmXfpH1G2/5L6kcb6b2X7GCSYLDGvptba3aDFv7M2MqpsBh50Uw9ZkbVAPdydrer+zUcWnaHtYcDVPHwx2H1WWSGeG1U+4a3PjNFFOwNqwHOukQSNLcLAlzi/PdEPz7dmkNEUIZnuhVOC4Qeo1aNBn1xIzIG+Dv6/mMxIuyvPaYLQ6g+89+wN3r6oweYJuTDCAWzBzNdTRElpZE1aHIYR7eTMnokCFqtOGUng4d8G4Fe95TsUDWl1eFO7WLpqosNdJHut8VGrMKbaPd2V9zM+AX3UI5xchS6ogRCv7Xwkt8ugbdMJJE32JQiNMoBhYIOyKGIsejV7TuZ7CewtXSBETsWBjwR/UafkZReuOGHYQQLxpMCyxrnBQa3N2h9dkXVTnvh+sfb11IRGz7QoScfSF1LduvXnCOJ8uB7SyYBqJkMwg7LbZ2zEsmzAzWEc0GHecmsvXZx0o9JrD+s+EbXAwPqulKhFFn9pzam/UgAVAzQKaZZqZKUpwMd2fK+keq3Y+9kZ71EgSzCF2AgzrGS8I8142rU3wK10kFtGzTlu1ilSz3FP0ua5AFKXYkrvuvZ+lBdSGTka+t9g05BokkNz9r9uGLCzQto04Vbg46K+AwKmaIzV3vJNllvBcmoPqWBCM/fk/ARYWnNC2V1VU5uNi6Xgz+4O2TJS7zTAGjZ0Gqi82Ci6yn1gvxP4/eL2uIW6rIITGR537XGBm4zYeygoXPfGSfAOgp0XQqkxHspod
 Unt+IR3U
 w8xSY6WuejWUUdIdtASveszRsYvppkgjbbad7zKaVwI63VZ2Dw7iBkqMy8HRnbUf1iHWTGkkAzWTvq0+KZkZV+dOdZmmsAo6H/nx+OJOUP1UG+8saAW3EpQqrycN4LTYW7Tg/hzqGM8aPXgvvY6SzMt5YptNBqoNQH2IuFefgK/xibJMcB8S08sAfq0JjrQvovSweT74vL3L6WN1TgBG/Tg5KHxgk2J6MEe28RFEA487nuaayC2akPbvFwujS7KedKFfElBw3RyNbTdFWMBOjIdkGsLqtNnycMq5qIk0hCaK1UZ7pjIego5i+kjAHsMmJdDMDQdXoBqx/efJuOB+Ee5c9LW0t+EDbMxxwovkS/1dNE2SPFotVYrbqCRDAkFZGHXxOiL2Or9UeN9HHC8ObPh9OomJtZeVekr4kVU7xvm2MqCHoEfnm4FmszATjbmCOTcsUDStZYS7DeKk4bCkYplRsdFBb7AHAmScnnV9f9uqAo/5Y0d1thMzv2fyxFPkL5rtDRvKQqSSlh163R1m64duwfCowsobneaVawj6s6OZbmyPfNPpU5alWVWejADnOZlWQHrBMLkGY3Fc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 13 Sep 2025 09:55:15 +1000 Balbir Singh <balbirs@nvidia.com> wrote:

> commit c519c3c0a113 ("mm/kasan: avoid lazy MMU mode hazards") introduced
> the use of arch_enter_lazy_mmu_mode(), which results in the compiler
> complaining about "statement has no effect", when
> __HAVE_ARCH_LAZY_MMU_MODE is not defined in include/linux/pgtable.h
> 
> The exact warning/error is:
> 
> In file included from ./include/linux/kasan.h:37,
>                  from mm/kasan/shadow.c:14:
> mm/kasan/shadow.c: In function ‘kasan_populate_vmalloc_pte’:
> ./include/linux/pgtable.h:247:41: error: statement with no effect [-Werror=unused-value]
>   247 | #define arch_enter_lazy_mmu_mode()      (LAZY_MMU_DEFAULT)
>       |                                         ^
> mm/kasan/shadow.c:322:9: note: in expansion of macro ‘arch_enter_lazy_mmu_mode’
>   322 |         arch_enter_lazy_mmu_mode();
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fix the issue by explicitly casting the use of the function to void,
> since the returned state is not forwarded/retained
> 
> ...
>
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -319,7 +319,7 @@ static int kasan_populate_vmalloc_pte(pte_t *ptep, unsigned long addr,
>  	}
>  	spin_unlock(&init_mm.page_table_lock);
>  
> -	arch_enter_lazy_mmu_mode();
> +	(void)arch_enter_lazy_mmu_mode();
>  
>  	return 0;
>  }
> @@ -494,7 +494,7 @@ static int kasan_depopulate_vmalloc_pte(pte_t *ptep, unsigned long addr,
>  	if (likely(!none))
>  		__free_page(pfn_to_page(pte_pfn(pte)));
>  
> -	arch_enter_lazy_mmu_mode();
> +	(void)arch_enter_lazy_mmu_mode();
>  
>  	return 0;

doh, I just figured out that my fix for your fix simply reverted your
fix!

I'll promote my cleanup into a hotfix:


From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/pgtable.h: convert arch_enter_lazy_mmu_mode() and friends to static inlines
Date: Sat Sep 13 05:03:39 PM PDT 2025

commit c519c3c0a113 ("mm/kasan: avoid lazy MMU mode hazards") introduced
the use of arch_enter_lazy_mmu_mode(), which results in the compiler
complaining about "statement has no effect", when
__HAVE_ARCH_LAZY_MMU_MODE is not defined in include/linux/pgtable.h

The exact warning/error is:

In file included from ./include/linux/kasan.h:37,
                 from mm/kasan/shadow.c:14:
mm/kasan/shadow.c: In function kasan_populate_vmalloc_pte:
./include/linux/pgtable.h:247:41: error: statement with no effect [-Werror=unused-value]
  247 | #define arch_enter_lazy_mmu_mode()      (LAZY_MMU_DEFAULT)
      |                                         ^
mm/kasan/shadow.c:322:9: note: in expansion of macro arch_enter_lazy_mmu_mode>   322 |         arch_enter_lazy_mmu_mode();
     |         ^~~~~~~~~~~~~~~~~~~~~~~~

switching these "functions" to static inlines fixes this up.

Fixes: c519c3c0a113 ("mm/kasan: avoid lazy MMU mode hazards") 
Reported-by: Balbir Singh <balbirs@nvidia.com>
Closes: https://lkml.kernel.org/r/20250912235515.367061-1-balbirs@nvidia.com
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/pgtable.h~include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines
+++ a/include/linux/pgtable.h
@@ -232,9 +232,9 @@ static inline int pmd_dirty(pmd_t pmd)
  * and the mode cannot be used in interrupt context.
  */
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
-#define arch_enter_lazy_mmu_mode()	do {} while (0)
-#define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_flush_lazy_mmu_mode()	do {} while (0)
+static inline void arch_enter_lazy_mmu_mode(void) {}
+static inline void arch_leave_lazy_mmu_mode(void) {}
+static inline void arch_flush_lazy_mmu_mode(void) {}
 #endif
 
 #ifndef pte_batch_hint
_


