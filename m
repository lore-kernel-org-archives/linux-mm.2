Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE3E3C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 19:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EB9E6B008C; Tue,  1 Sep 2026 15:53:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99C376B0092; Tue,  1 Sep 2026 15:53:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88ACA6B0095; Tue,  1 Sep 2026 15:53:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 511896B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:53:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A23E21204D9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:53:35 +0000 (UTC)
X-FDA: 85166243190.01.3BF43D0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 23C7740007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:53:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="CA+/0UGr";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788292413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=reG9gp6F6Sc44ynjc987c7Nir1HVN+IgKVtXu+sNVIw=;
	b=Al0wD/81H4wLgu2Rb7ibpb8SKQK7VXxwhcPEOYmV8ujpOPUwurKSx0bh9N47lm91AG59xS
	9WoqeN75TDtfbV3BkAfUTmpG7lt6DgzjG8l4Xah5jyIV+rq+A4/B/FAwIw9FY8kXvuBtxw
	vcRkVWVJkWzjoXwcgHoG7oOdvGyu+VI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="CA+/0UGr";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788292413;
	b=C1XpG3B6TSGNFh9U4NgP7zGtnoemfML47/G48GeH3f/VTh4KxuVZzsbJSyrKTVMHppV3I4
	n+eWDz98PkmScHk1HUuaag4/i4h+FFoc9BUdP9iIeMit7o1H9KuA3SwPVUoZ7AFdQb1vLx
	T83o1PUddrLLQJlHqZqXIuua0+PFBno=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788292412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=reG9gp6F6Sc44ynjc987c7Nir1HVN+IgKVtXu+sNVIw=;
	b=CA+/0UGrUiJ4TRJ4TRTvmdq9ec66GjTAI5zPRIo9T1Ev5Dla/+eV5M8jN/2humzzIcKsHI
	d/C2rjBt9O4J63sczZpZZ16mnFtcS0ax1i7Ry1FC4RijngimTnHbmiXu9MAYqeEbQLp595
	4eB7siJh2oeU4ttq1Zm/6DiXmVQy94o=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-K773EhgVPrmlkIx3Hm_p7Q-1; Tue, 01 Sept 2026 15:53:31 -0400
X-MC-Unique: K773EhgVPrmlkIx3Hm_p7Q-1
X-Mimecast-MFC-AGG-ID: K773EhgVPrmlkIx3Hm_p7Q_1788292411
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93909014c85so65235285a.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 12:53:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788292411; x=1788897211;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=reG9gp6F6Sc44ynjc987c7Nir1HVN+IgKVtXu+sNVIw=;
        b=h7QGx6wFT2Ewj59lSDiCq6iixE4MYhyYM+Z+tGGooXInJS0Hqt63b7Xrkt12nyodqF
         otLlCKo5dYCg4pdEl9dJGMdtRiUm2rTggzaf4pZwuVyi4AY3LXOABgUSK6pNfllWCQKK
         FCOQTt5WF+Wjp6j+0PFsg979ZuH5pMeVtBUA7jRjGddXGzaGyoH11tsCh2aysKXsWdtm
         OhsM9j8zNcVNmhJjyezN7XbiLAIebaJgOUnmGEZPr9uPlTi2AiFmbV4cVkHkePKTMS67
         Kol+vUuaxQ61gIN6xEq9a6u0+BHlyNE1wlmdmS6OlTX5M7sVfSD6dDAtvJ/bXG2yb3xw
         LJ1Q==
X-Forwarded-Encrypted: i=1; AHgh+RrBYK5Za1BUPi7kXpwofOvO++1LpKYO3Rl/w65t+Ie+KGR0hI/yBsW8LJW0025EcAG7e3rdtoBdKw==@kvack.org
X-Gm-Message-State: AFuF++mVlX8PsuGAu1IhysBEuYuyU2F6QBy8JxC4d3DGJPyosFO7Qfhc
	XkIezlJtV4kl74Te5/9baFzmoKbOb/gyiL9Lsf+owTxrotnOyPNZSYXe4SD8odKHP4pFFx898Hy
	cpzlffVUVC3a1FgCYnbsktMUYiWVTI2MqMv9CyF7LgR3VM/f2zEFV
X-Gm-Gg: AR+sD12qkkFAHJ6t9DV2dX6IaICwywWUEbPLGKJCX/KJI8CWH7uKdB2QMf7LAhZUX/i
	cElWiC8YJUlrGNU52JjvJTsoGYf6ZX1+c05nO0M+ZYff0O6Xc8390iYb7CzFS+hIGrKeqpCS6Cx
	B1TB9SSL+qJmjxWBE5CMdZpPK4xqmO54XKcjomp/HKocFswgCRGXbLEZpLAG/Eq3KIF1CNsYPQC
	rutbPV0D8kQkIKHGe3ASbOxbm+MevrJsilGbHgDyOr/bqdy1R0WDFluaI0p37Lq+GRI2ozsIScx
	kQbU98pI3QzOAeJsgaOuCdmNaiVQkmff+D066SwBayByhxpR9s0Kxx4S6NDH0SXzSM37vAsmFBg
	+Uw==
X-Received: by 2002:a05:620a:439e:b0:936:883d:89c6 with SMTP id af79cd13be357-939480def48mr1638072885a.28.1788292410573;
        Tue, 01 Sep 2026 12:53:30 -0700 (PDT)
X-Received: by 2002:a05:620a:439e:b0:936:883d:89c6 with SMTP id af79cd13be357-939480def48mr1638064385a.28.1788292409955;
        Tue, 01 Sep 2026 12:53:29 -0700 (PDT)
Received: from [192.168.2.110] ([76.65.104.212])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9395f1aba80sm20825085a.20.2026.09.01.12.53.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 12:53:29 -0700 (PDT)
Message-ID: <00eb76eb-c330-4662-9ca9-1e89fbc1e4ce@redhat.com>
Date: Tue, 1 Sep 2026 15:53:18 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/14] mips: move has_transparent_hugepage() out of THP
 guard
To: Lance Yang <lance.yang@linux.dev>
Cc: corbet@lwn.net, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 tsbogend@alpha.franken.de, maddy@linux.ibm.com, mpe@ellerman.id.au,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, david@kernel.org,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com, djbw@kernel.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 yintirui@huawei.com, dev.jain@arm.com, usama.arif@linux.dev,
 linux-mm@kvack.org
References: <cover.1788232334.git.luizcap@redhat.com>
 <371e2d3a7bcac265ac748ad3c67b74abfa238422.1788232334.git.luizcap@redhat.com>
 <f4c568ad-a17a-4982-b8d2-d5852a789a4d@linux.dev>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <f4c568ad-a17a-4982-b8d2-d5852a789a4d@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0OcivNGcSfCOlN4AtAy2azW1nXiEQfrOK5PPtGWKJbA_1788292411
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: c67beaodu1no3sfufisuwzfo18tf7s8o
X-Rspamd-Queue-Id: 23C7740007
X-HE-Tag: 1788292412-65919
X-HE-Meta: U2FsdGVkX196Clvg5eVogzB8cdG0D80JMP7JEd7GxxlM6TFb9U1z/EjIjCkKL6N7TbLCbgZHAs1+V+4vaQvoihl+pzSAvw//6zZd/vZ9lA9fYj/7fY7J29o0i8AcFz6WykGPw6Ju9uIKHjP8rvc0AVTM8N/nDlH9fedduQXYS7+ZI3EaA9Hmnls4HFeYEhxgWUOuzAl1/s+l3QCnxBm1aaWlyFE6mWB74Yfrlfr14+mzGdejsk8yLlqUhmmAJJi7PL4X4qgiAOu5XYSOQWu4cZRZlqwF9LOUx5x946B8ZxWBZ6A/yP2gaCul2heExdIM18DtB7hb8H2+NUWrnbLvc6oG92U6Lljxdbr+/iO7WaVBAKlWjUCD0pJ4v9hsAhgqXndRNvh///w3NprDZKvs7h86u1F1fbWuN8h0hFnRZdt3Hh8x/e7a59bRX5WDnW6TrOxyvp+pocPgG8Hp/47JZXmVRfp1u4MD8zxXWRhBS4Yr40nLSxQ4haZnFL4b1RtvgF/ImRWWUBSVikfcs/qmd/tKVyjvOv3VY3xme3uAN9ilg09QrZ2D4HKrojBElqMLOuuATwJYfSSioKFsA+KK3rMBVgPq808Tkdr1T/FawH3D3m52A8si+6tJ/hyB6uRNQwywtZiLhvnVXQ3sJortfB+n0kmXPLZVxfWObd6eZad2isYNQnayLMemu7JXfQRTeeSFD/N27971oxVHI/HoS45Atf53bPRPlJheEL1FRfUKdRjoq7XvPoK25ZlXDPyLyAfs0lkbAHhusz52TDkNHsiU4KW8RHXXTpzbdEgWYJ1CUr1BnSNEUprSkhfKbgvETNfbkqMAyVulx3kk9zpzKna7krK95ZPa50D1IxpduKyVryk479HKsB4aA7WEVdOVminWNO9cIKEnK3BKw4AmrstOi8OgGiuT5/GRpZ22NdrqWhl91aR5D6b5grUoi45Tbhkft3vfN1SXPVkp+B2
 HnrcbtxI
 GhYWi0BuPQ2UWwCauqmJmwhLgyStEnRZNfSMGQALDJXoyAUpLkEJizGHs9BGRy4qia85U1lO7iFkU3OXBKnZHqnFsDO0y/FTkcCMm9TkeYp25nFesYp7c6VtFGVz5xE8cxN22Us5UhEpoHqsGD/z/BnBB8OAPztjPRQEMzzMRwcMrgc8SCkyDwHqOU5rAfHcNOCcLdEMQmyYjy5ug+pp1sHiEnStBHbDcsTuZXzvr4d+sYw9hyfGQZR32IUJ4AScWeWb7e3S+Lb83V1LuOdubUTwY+fN9dnY5XhKvkfs7VoyLkmmDjdZRzvH0JIEmnThS+cFNkfeJPkaLaX7AMsbFSsWnHN5VEZyQa9t/WBgIEgNxDbCdXm/XUvi/Uf5tPif3/pNntnQH61F30y88YkG9PJjKzq8+g70nrwEG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-01 07:42, Lance Yang wrote:
> 
> 
> On 2026/9/1 11:12, Luiz Capitulino wrote:
>> A future commit will introduce a kernel API to allow for checking if the
>> CPU supports PMD-sized pages. This API will be based on the
>> has_transparent_hugepage() implementation but will be orthogonal to THP
>> and therefore must work when CONFIG_TRANSPARENT_HUGEPAGE=n.
>>
>> Move its definition out of the THP guard.
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   arch/mips/include/asm/pgtable.h | 6 +++---
>>   arch/mips/mm/tlb-r4k.c          | 4 ----
>>   2 files changed, 3 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
>> index fa7b935f947c..b038da872ec6 100644
>> --- a/arch/mips/include/asm/pgtable.h
>> +++ b/arch/mips/include/asm/pgtable.h
>> @@ -615,9 +615,6 @@ unsigned long io_remap_pfn_range_pfn(unsigned long pfn, unsigned long size);
>>   /* We don't have hardware dirty/accessed bits, generic_pmdp_establish is fine.*/
>>   #define pmdp_establish generic_pmdp_establish
>> -#define has_transparent_hugepage has_transparent_hugepage
>> -extern int has_transparent_hugepage(void);
> 
> Assume a decstation_defconfig build. CPU_R3000 selects CPU_R3K_TLB, so the
> Makefile builds tlb-r3k.o but not tlb-r4k.o IIUC ...
> 
> The only MIPS definition is in tlb-r4k.c, so R3000 would fail to link with
> an undefined reference ... no?

Yes, you're right. I can reproduce this. Would the solution below be
acceptable?

diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index fa7b935f947c..b038da872ec6 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -615,9 +615,6 @@ unsigned long io_remap_pfn_range_pfn(unsigned long pfn, unsigned long size);
  /* We don't have hardware dirty/accessed bits, generic_pmdp_establish is fine.*/
  #define pmdp_establish generic_pmdp_establish
  
-#define has_transparent_hugepage has_transparent_hugepage
-extern int has_transparent_hugepage(void);
-
  static inline int pmd_trans_huge(pmd_t pmd)
  {
  	return !!(pmd_val(pmd) & _PAGE_HUGE);
@@ -743,6 +740,9 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
  
  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
  
+#define has_transparent_hugepage has_transparent_hugepage
+extern int has_transparent_hugepage(void);
+
  #ifdef _PAGE_HUGE
  #define pmd_leaf(pmd)	((pmd_val(pmd) & _PAGE_HUGE) != 0)
  #define pud_leaf(pud)	((pud_val(pud) & _PAGE_HUGE) != 0)
diff --git a/arch/mips/mm/pgtable.c b/arch/mips/mm/pgtable.c
index 10835414819f..3a5b411493d9 100644
--- a/arch/mips/mm/pgtable.c
+++ b/arch/mips/mm/pgtable.c
@@ -23,3 +23,30 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
  	return ret;
  }
  EXPORT_SYMBOL_GPL(pgd_alloc);
+
+#if defined(CONFIG_CPU_R4K_CACHE_TLB) || \
+    defined(CONFIG_CPU_SB1) || \
+    defined(CONFIG_CPU_CAVIUM_OCTEON)
+int has_transparent_hugepage(void)
+{
+	static unsigned int mask = -1;
+
+	if (mask == -1) {	/* first call comes during __init */
+		unsigned long flags;
+
+		local_irq_save(flags);
+		write_c0_pagemask(PM_HUGE_MASK);
+		back_to_back_c0_hazard();
+		mask = read_c0_pagemask();
+		write_c0_pagemask(PM_DEFAULT_MASK);
+		local_irq_restore(flags);
+	}
+	return mask == PM_HUGE_MASK;
+}
+#else
+int has_transparent_hugepage(void)
+{
+	return 0;
+}
+#endif
+EXPORT_SYMBOL(has_transparent_hugepage);
diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index 24fe85fa169d..625f1c0dd71e 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -432,28 +432,6 @@ void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
  #endif
  }
  
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-
-int has_transparent_hugepage(void)
-{
-	static unsigned int mask = -1;
-
-	if (mask == -1) {	/* first call comes during __init */
-		unsigned long flags;
-
-		local_irq_save(flags);
-		write_c0_pagemask(PM_HUGE_MASK);
-		back_to_back_c0_hazard();
-		mask = read_c0_pagemask();
-		write_c0_pagemask(PM_DEFAULT_MASK);
-		local_irq_restore(flags);
-	}
-	return mask == PM_HUGE_MASK;
-}
-EXPORT_SYMBOL(has_transparent_hugepage);
-
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE  */
-
  /*
   * Used for loading TLB entries before trap_init() has started, when we
   * don't actually want to add a wired entry which remains throughout the
-- 
2.55.0


