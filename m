Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D45E0C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDF076B00F4; Wed,  2 Sep 2026 11:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5F66B00F6; Wed,  2 Sep 2026 11:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6D56B00F7; Wed,  2 Sep 2026 11:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8AFEF6B00F4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:12:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D6C0C0241
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:12:59 +0000 (UTC)
X-FDA: 85169164878.13.63CF915
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9E79C1C000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:12:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MJSrUhKe;
	spf=pass (imf21.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788361976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hW0UXPiaj5HBVsIwr+z0dRI3kHamagF/s5VaYIAmBvo=;
	b=C9LsYrv5TM2YwXUMxOPNsqX4UIdylnNf5OI1VkMKP/GClgKmuViyHrp6xi6Qsx+/ScdV7Y
	unW1+5NibU7T91Vd/gJKppM+oPLWWrMmT95cWjtZuO6rvqFaMBIcbe9jC0PkXRENpF6GrV
	q2KqhIEvAhPZcuLAkgTLw8N4B8V50Aw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788361976;
	b=FYkUfGQv7jKnoYlqav5j81r84VbbetC8paVWu9NaE6/w2Os10Awa9iqBB6ZkA2b4OzQFMY
	01xy93N5xh+nshFB+CH+fvQilTB1EgbeazVie5lejKGDPbYvBEApN/91kR+H5eGfQW3+sO
	dCLuB+9ZbZtFFLKJMPVl1439b2pnozw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MJSrUhKe;
	spf=pass (imf21.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788361976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hW0UXPiaj5HBVsIwr+z0dRI3kHamagF/s5VaYIAmBvo=;
	b=MJSrUhKe1fRjBqZf8HwgFpTEkd65rJtWykMehEKigQY/sIsKbw86am31a0xv88rJO9XDOs
	cCBX4/HJODPP66InN4sHCuhKHwIpQSUpLvjsI+vKlUYdimusoDGVElCTdCd6G3xJRGPtag
	hQvMxEWCVAHTZ+uUxTmxWZFrmmKbjKM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-b8trlLoPOWu2iQA-oMiA5A-1; Wed, 02 Sep 2026 11:12:55 -0400
X-MC-Unique: b8trlLoPOWu2iQA-oMiA5A-1
X-Mimecast-MFC-AGG-ID: b8trlLoPOWu2iQA-oMiA5A_1788361974
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-90f8b463ea3so2744136d6.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 08:12:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788361974; x=1788966774;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hW0UXPiaj5HBVsIwr+z0dRI3kHamagF/s5VaYIAmBvo=;
        b=HJv3Zbgswlu6z4Y+xWZ6Sx+xshKWy2EWzjBqxMeiYeUqI4D2PEzj3pesGiEUCs8WBr
         Cx2Cp2h+UknOytdsGORX+NizCulpEqECkkJyCn4l4tIGpjMUO0gMc4P0sw+TYY3FOVTP
         qZNbivwy5xDv54p8fNsUi/ZPr6hepa7WoDHihfQyfv4ZDpC4NOfURS0J7jXnpQ7IMMYK
         ip937yCuz5Ze3l78c/085TEEwCF5C+wg/pYquTOuibKevHAAgbnenxL+lugl2IQdKDVE
         DXyw7QI/vPCwf8z41gP14DaJgIhyUvkw8TL3LCCFteV4w1k0GkBpdmHS1J1yXbNuPRJg
         qXig==
X-Forwarded-Encrypted: i=1; AKwUvBw1rdz5MgDCwOaaX2ZhX09Gce2fa8fIqhazeyHFINV/qch4CmMs7Gn9Ma9/5VxOnFIZp203LMfXYg==@kvack.org
X-Gm-Message-State: AFuF++mZdJYVpws35sgtR2z+ISbNtgVh7tYX7WbebFbCUGB8nlYQxgxu
	TjGHPHY7FjWZJMrOSYnyHNiAPvFQ1yXA7r+4hOPIm9qg3awx7s9wDnK9LqgMHT7HG/gquNccyZD
	OyoLQvMIb6B+126EC3ovldK5LxOmB8SPs8sQBuddJ44+EUlu4Wb81
X-Gm-Gg: AYBFou2wCEmB7Mi1TqSjIVvVGOiIvIeeKqOZmg1qtaBw4PLpq5glDgarnDTyRYpyKi0
	HPRDzZZ+gcW/gSt5xsAQfif8tFU/fvVBfwAfPb2S/zvNaMwcZHZl62VFoX3erjToJN2gWTYok5r
	/YCy0OiLwH0tx9F3a2ComnL+cIqRCKf+RTC6Qsl34JttEK9Pk12VXIw+fnIs+XNu2Gan1zzFLZK
	Vt2B+pqIcKejvbt2pA/k1xrpN3xzBbdnx2EJ8vzVkemXvQzmfvqeKGb3s79aGc1Y1SG7MXn6Dul
	vbGC39FCxYo25WqBABdJWJSutuBCtMUFfEGjKo/TNYiNbaaBJ2Z8qbZGsLFx4EzKngpDa4ChmnX
	TpA==
X-Received: by 2002:a05:6214:434a:b0:8cc:d29:9f73 with SMTP id 6a1803df08f44-90ebab8fb94mr89149216d6.21.1788361973782;
        Wed, 02 Sep 2026 08:12:53 -0700 (PDT)
X-Received: by 2002:a05:6214:434a:b0:8cc:d29:9f73 with SMTP id 6a1803df08f44-90ebab8fb94mr89146766d6.21.1788361973014;
        Wed, 02 Sep 2026 08:12:53 -0700 (PDT)
Received: from [192.168.2.110] ([76.65.104.212])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eef4f2fsm19747746d6.40.2026.09.02.08.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 08:12:52 -0700 (PDT)
Message-ID: <2802ba90-fee8-455b-9858-a6bcd0212c46@redhat.com>
Date: Wed, 2 Sep 2026 11:12:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/14] mips: move has_transparent_hugepage() out of THP
 guard
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Lance Yang <lance.yang@linux.dev>, corbet@lwn.net, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, maddy@linux.ibm.com, mpe@ellerman.id.au,
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
 <00eb76eb-c330-4662-9ca9-1e89fbc1e4ce@redhat.com>
 <apdQ2FJrLhkdjh_n@alpha.franken.de>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <apdQ2FJrLhkdjh_n@alpha.franken.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8cbFSsqu_RurWOVycpTr38VGYPXOdiIBBBDAi5M2MIY_1788361974
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: udjxw357i1dwtneyba4cs4hhpmhxuj6t
X-Rspamd-Queue-Id: 9E79C1C000C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788361976-8026
X-HE-Meta: U2FsdGVkX19058BejbYjeJWUTpIORgs/qyDFc+mh6/6E+lBf+jQ2Sud4mGnN282pPtoHd0H/2zbSbFJxDpPZNFbVb2XUMO8L6ecDEvEo6GQDro6ybI1yUTjQWUK42RP6MPfvFnlrjL88zfZRvfbqZY05e+VoRO3IXoI6UWL/bWAdlIsVvNVxV29NfRt4PptowHFb/uobTWKT99wTlSU2P7QDSVlRlwzL5FPWBeLBxmbjbdq42ojSMi7ICuBxkJKk+ZPu0E8qkrveNoACGp4gUBdWO7hFGStipU9L33hP8f/KC9rsWze9LqdbSltN8kJ0mki8eek2D3K63mRFascmGnQQIAVXAHmLQNLbkOcATgyMhhhcMawesrDFob5WKD/FpQmZFwY3zRbDGR92rME6XeOm0F3flOBGHR87tec65rwIp5ydCmudht2EcXlG282IdWTwT5G/9+5gTtr4eGSKrRrbSPx/MVvaIoLq3lPYfordJMWtJwS9irJrviFMWvie6mccXCRU9YtBT7VWZXnMdtdR5ICJx3Kfy16ln0osbWFeQ9rglcipa8G4GFrlEyPblG/4M+MlKad9gcOODXPmHWcu97UuuQkPidAm7bc9oZ2RI+nLjA55nZZYad/bn0aMWlU8KzfR2RTa2UZpWE3Lax4cByyBU635HqkF+W4m71dsdRyCwwOk83ScYRxX3XYcgkrecbEwaR74pycEr5yfr9rfj4Rnq39Q84w8PnDefJr77J4Js/FEe0qDJOWaGzd750zSNfLQybkq4SLpxMkbpKLGQUomOdmF3hRpFFn/RsBgJOaV9+DMctJOCtfe3FGdMAf/yz6ja6N+zFF58+38n48MfBxcsKwkpI8J9Z4GsiKLwIMFTj/rURtaKDQb3p/eEIp2jZkQrcAgTugajnGlyIJOX3oOA8OOrItKnXy9KJpPdeimO6IN9TQfyjqjA77F9FuhEXfAP2bBRLO0yzb
 gytRsjOi
 dCxlim+PTJDTUQ+n5rCu0fqXpyAgpz4Y+dwdDzzovssOL8Ls7Ur+nYOyUvyX6PORzzkSvRQpZxTtL6H9O+zcjj7AzmYfbARHjbQfbsRX7Ycx9GBE0TNfBS0+HSFR9RpDUJHxZOHFYJuMhWrvmlWMQc0GdOp7E4Fayfmz7jK9sRnxeiCMG7sjEmtTm3kIjSYGBB4zMcAa45z217FsQrhugoxtx/rF0CO0qcn5oM3ZvXFkQtWBFx9i/z8bjMqJYBURVlAihcbfBTwEIQRL1Jmp53XFxq1ZMXkGycqnOhI3kH1YK5oqhwYsVHCRtJTWIGNKxn0erRyhqyfje2mnd6sncSmscslcn+bnI8fp55fcYTu+b8lKoaLE23FMax+1TlWnAN7kcPFkAW86cg0v7pPGN4iKI9NPGyzHyE/Hb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-01 18:25, Thomas Bogendoerfer wrote:
> On Tue, Sep 01, 2026 at 03:53:18PM -0400, Luiz Capitulino wrote:
>> On 2026-09-01 07:42, Lance Yang wrote:
>>>
>>>
>>> On 2026/9/1 11:12, Luiz Capitulino wrote:
>>>> A future commit will introduce a kernel API to allow for checking if the
>>>> CPU supports PMD-sized pages. This API will be based on the
>>>> has_transparent_hugepage() implementation but will be orthogonal to THP
>>>> and therefore must work when CONFIG_TRANSPARENT_HUGEPAGE=n.
>>>>
>>>> Move its definition out of the THP guard.
>>>>
>>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>>> ---
>>>>    arch/mips/include/asm/pgtable.h | 6 +++---
>>>>    arch/mips/mm/tlb-r4k.c          | 4 ----
>>>>    2 files changed, 3 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
>>>> index fa7b935f947c..b038da872ec6 100644
>>>> --- a/arch/mips/include/asm/pgtable.h
>>>> +++ b/arch/mips/include/asm/pgtable.h
>>>> @@ -615,9 +615,6 @@ unsigned long io_remap_pfn_range_pfn(unsigned long pfn, unsigned long size);
>>>>    /* We don't have hardware dirty/accessed bits, generic_pmdp_establish is fine.*/
>>>>    #define pmdp_establish generic_pmdp_establish
>>>> -#define has_transparent_hugepage has_transparent_hugepage
>>>> -extern int has_transparent_hugepage(void);
>>>
>>> Assume a decstation_defconfig build. CPU_R3000 selects CPU_R3K_TLB, so the
>>> Makefile builds tlb-r3k.o but not tlb-r4k.o IIUC ...
>>>
>>> The only MIPS definition is in tlb-r4k.c, so R3000 would fail to link with
>>> an undefined reference ... no?
>>
>> Yes, you're right. I can reproduce this. Would the solution below be
>> acceptable?
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
>> -
>>   static inline int pmd_trans_huge(pmd_t pmd)
>>   {
>>   	return !!(pmd_val(pmd) & _PAGE_HUGE);
>> @@ -743,6 +740,9 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
>>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>> +#define has_transparent_hugepage has_transparent_hugepage
>> +extern int has_transparent_hugepage(void);
>> +
>>   #ifdef _PAGE_HUGE
>>   #define pmd_leaf(pmd)	((pmd_val(pmd) & _PAGE_HUGE) != 0)
>>   #define pud_leaf(pud)	((pud_val(pud) & _PAGE_HUGE) != 0)
>> diff --git a/arch/mips/mm/pgtable.c b/arch/mips/mm/pgtable.c
>> index 10835414819f..3a5b411493d9 100644
>> --- a/arch/mips/mm/pgtable.c
>> +++ b/arch/mips/mm/pgtable.c
>> @@ -23,3 +23,30 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
>>   	return ret;
>>   }
>>   EXPORT_SYMBOL_GPL(pgd_alloc);
>> +
>> +#if defined(CONFIG_CPU_R4K_CACHE_TLB) || \
>> +    defined(CONFIG_CPU_SB1) || \
>> +    defined(CONFIG_CPU_CAVIUM_OCTEON)
> 
> I guess using CONFIG_CPU_SUPPORTS_HUGEPAGES is a better approach

Makes sense. Updated patch below.

Subject: [PATCH 10/14] mips: move has_transparent_hugepage() out of THP guard

A future commit will introduce a kernel API to allow for checking if the
CPU supports PMD-sized pages. This API will be based on the
has_transparent_hugepage() implementation but will be orthogonal to THP
and therefore must work when CONFIG_TRANSPARENT_HUGEPAGE=n.

This commit moves has_transparent_hugepage() definition to
arch/mips/mm/pgtable.c under CONFIG_CPU_SUPPORTS_HUGEPAGES guard in
order to ensure that it's only used in CPUs that support the register
operations performed.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
  arch/mips/include/asm/pgtable.h |  6 +++---
  arch/mips/mm/pgtable.c          | 25 +++++++++++++++++++++++++
  arch/mips/mm/tlb-r4k.c          | 22 ----------------------
  3 files changed, 28 insertions(+), 25 deletions(-)

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
index 10835414819f..4515fa42f0b3 100644
--- a/arch/mips/mm/pgtable.c
+++ b/arch/mips/mm/pgtable.c
@@ -23,3 +23,28 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
  	return ret;
  }
  EXPORT_SYMBOL_GPL(pgd_alloc);
+
+#ifdef CONFIG_CPU_SUPPORTS_HUGEPAGES
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


