Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC38ACA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 15:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A377B6B008A; Sat,  3 Oct 2026 11:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8AD6B008C; Sat,  3 Oct 2026 11:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0446B0092; Sat,  3 Oct 2026 11:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D5E16B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 11:44:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D8DEA7628
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 15:44:38 +0000 (UTC)
X-FDA: 85281737436.23.8D1D953
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 87BE4160008
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 15:44:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="WY71yzv/";
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791042276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0wZiVOoBi9CdBRkhP9ZWY4fcF1JHhwbOBeOslp4i10I=;
	b=iNP/GmgvXsKOe8eLaUOVy08hdwVVk7XMr5BvnZaRAqu1zFG7/STdpVZssLnxqcZTbp0RLK
	+aXIafKVywQzmXH7H4Ln8rkgPuFD7hgiXfy7ewRJIKY4EEMXztYPElp3F7MrjLEImrv/re
	UXpPMWUZ5fRDSgwFkABjrjqsUk9JGC0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791042276;
	b=72DL/YJGDjlSKbo6OEGeepswCS2IG+QYB8QoRRKLXGwkv5/UrjgyHUVO+2Bbt2upnYvjX8
	Xq87A6czm5dMLbgDRZ8pJJgA7xXuvH+SVzampjojX31K/9+AJkS7ycKiyHceLpKpNC/qpE
	7mnYnQqLhkWLlQrOTCKMSS2KXlrFiWY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="WY71yzv/";
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791042275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0wZiVOoBi9CdBRkhP9ZWY4fcF1JHhwbOBeOslp4i10I=;
	b=WY71yzv/jjjyic9OhABhBWPRAWHDzBk+wcndsFkaP0wKKeQ+608NluJ/i+gfaGIMcaraF4
	389KFO9JIh+qo8t7+/bXvdS3hAcTeyCAvcF6SMbtdPy1VYLZwZaJO9eUMe/p9+3/xGnT6H
	vF4bZgnO3fGzZJPc8SUPsAQS9bH+nt0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-lkj_UBT5PCev4zDMHuBaUg-1; Sat, 03 Oct 2026 11:44:31 -0400
X-MC-Unique: lkj_UBT5PCev4zDMHuBaUg-1
X-Mimecast-MFC-AGG-ID: lkj_UBT5PCev4zDMHuBaUg_1791042271
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5338974c0ceso9589361cf.0
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 08:44:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791042271; x=1791647071;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0wZiVOoBi9CdBRkhP9ZWY4fcF1JHhwbOBeOslp4i10I=;
        b=enT4WTFO2mzxLdd3Vr/E+jeqV/GvqQh2xAyCu+cVt2RuHPZjWE/ggwZBDqtA2ig2Kf
         YOudAe0ZlTZJC90GWzWMgO/AxVDFb2S8kmE2mdJwqIJmXwQY42CVDSkL5EnIEqrf9GXK
         gBf88SplNnqieH2DYfJL+dWE4ov1mhuu7Ws/zMeaEgoiC4nQ9vuQqQ70F3fwfphSdlUh
         eXZXLo6GMFMtFjbLG0YO/QdKkxH90gLS+0SeYIgaIQ3PgwabOjuNDAYNdN/zVzBGWeOi
         3Y5G9FgnhrNYB1HKeflfUX6dJrlRvvdpMJTS0BxsqUz50t+Vwn1KCpAfuT0thlX8vu8A
         RPug==
X-Forwarded-Encrypted: i=1; AKwUvBw8ftpVONJlW8NE73cXLSaYThS+NUUZKka1PrYr9eiyBBQc5vLtqWYJTrUXzJfQgpfmSHqmACxtUQ==@kvack.org
X-Gm-Message-State: AFuF++lViK0EQiMfflCLGjVUXaJ7tIiiH/A7A33XEn5UbVR7oAGtCzu8
	MQIk69jZBQa3pC5bZp9atnXkD0EciMzjTSDiDYF1WnKhrXpgHCRxHrJmB/+NDOjFU8zeXzAI9cz
	cnNFOC1oSpgiB1fmDvVT296najptRfmMze5MmaVDaOXiJp2fwXf5S
X-Gm-Gg: AYBFou2HFsgO0rXlAtp8jziSUnhqoUv/3sHQvpsmGbGZvzgUdZ5eDb/QXL5C5tThbo5
	k6lX0glB8/gynltd+q+zYrPA7QS+9RiCfQzzJgcCL11MMf+qh2um8wJBtksu49gOpu9oLVeoile
	Iwt80byrthNQBEFzVqoTsUC+EzPp6AMimefs0mPn+XVdkzhsjD8CH1BRzLybR1wi+W/XZpMyn1Q
	KPq8Wex3nxugvHOMJfsVxkx5Yr2rrsD7aWoQmoXB4ZGuI/5JOGGRTHkin4uZZWqUCfZSMzU9yzr
	gyNX+fwLD9TGII9RnRecYiT14PgN/rFYZluu5ogd3V/fdXY3NWP5EwETXhKOMUSC8jH2MMB9cz3
	rHcQ=
X-Received: by 2002:ac8:610c:0:b0:532:ca82:51f7 with SMTP id d75a77b69052e-533d971af67mr96753361cf.54.1791042271042;
        Sat, 03 Oct 2026 08:44:31 -0700 (PDT)
X-Received: by 2002:ac8:610c:0:b0:532:ca82:51f7 with SMTP id d75a77b69052e-533d971af67mr96753111cf.54.1791042270560;
        Sat, 03 Oct 2026 08:44:30 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-917e0c3e2bdsm46623276d6.49.2026.10.03.08.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2026 08:44:30 -0700 (PDT)
Message-ID: <25bb02df-a795-4e48-9de6-99f1ca799176@redhat.com>
Date: Sat, 3 Oct 2026 11:44:28 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 09/14] powerpc: move has_transparent_hugepage() out of
 THP guard
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <05a71b6011a6eab7b096f262485fcb8b4987976f.1789695931.git.luizcap@redhat.com>
 <f54d5d75-5cc1-488b-b640-76163419cf4d@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <f54d5d75-5cc1-488b-b640-76163419cf4d@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LiRzsgLCm5-9uOC4WEOQ7JvJ2W2V8WbtgXVnuibogjM_1791042271
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 87BE4160008
X-Stat-Signature: cwsmoh16auhonezqbiq9f3cucw7kca8j
X-Rspam-User: 
X-HE-Tag: 1791042275-644303
X-HE-Meta: U2FsdGVkX1+klHp7WiC/bN62tklOXUY6PcuZPbkXjLFYzpGvN0p/v9jg+eY0kX2sfIyd6kHcAF/AGA9KBLvqOeSl+ol7mgq2r7bGULkm3HGW3xV46t0AyYwACeEFM1cawAEvR88TSDQQVi1bPEhXJUPdEpxgkHoSZXUQzwvLULf9uq/KDl3pxE+x9QY9vXcXIxVPVDbE1j8jLdP6Rdybai5Y8nZ62XdaWnBYs7XqCUfBC4xa7fwE4tyuR0jEcp2pls4SMZID9HXeSDvX+fN1TwYnB9K6eaUH/cQqL9oTXGCWVga9RlvfmboATzz5Co6nZuPKwQhW+IPk7+UvthdPlJgPsF7vDcF1xS/HQO6nwA13NSqcaqL0hjstHfUL/2fCEJnsnySn1kljW73GuITuWldf+UM87/knRj+fi6auAxOkxKcc3xs+PBQg3BslwTQWwYce5wnlFCsc55d2GQpZPZLgX2R0LUW8I4+a0Bbqx8RVGrFJKmLhSR/T9gmOYpbnqImx0LT9cJb71LIAm+277UxTdlqbc+7qS9LiOpUN+R3EYgpVkkoO6TwD4ZOIYM2a/LTHDjVZiuKoU/RH7rs5oqVFXUgcktPsNQKbUv1P7gmb8xiwv8mE5gYC8A76qATMeclO3ubXuFtA1ys+EcHHTtSJif63uQjlpr03K6fqMJQFMNslsFwSaMITcywTXIh+bxMB0eoCv4xq5yNU2+4aGfLQvf+vNYkEHxBWF0tp8uvS4sXznBTaSS35o22z2DfyXAEmzkB2a6zH3AGEZZHZBBCRhVqa8KhljyHEvBL7GOa/ZgmxmJ1kPkFvksdBS+5KYGuTefW1uqF13cJRJtNrT3XW0jDK7XK3eMcXzxP/yYwOCsm03p2Hf9mGCBNiFOUKi9L8BXyev1YvW3zr4U1Zskrc6OU27CujuhimSUtX40qL+IG/Wb7b3/3Xb06D/TXkfDOzCsBYWzpMoXYG8Mx
 hda+c6rT
 899kT938F0YyJQOXnb5xMAsIMh9lGlND63MgbK/P98jBvWR89PqGTly9Qb6noP9vZcc7EfRBpq5KUKHrioLFPiDFYIVP8dQueNCnreU+H9gY3+yiGHyV3tp+APS3zbrln4JglqhYZWeVB8AC+3PPqwHnhrdohV9hY0ESaAi19/ce2lr4qMXp9eLBD9ib9Yhz7R9PrHEuDkD4LAYgoq0bq6K3fT408Zcri+6p+zJbB2wD+550XB6wE5nQ6euFEO5PFwNqwb3VWjSYzz01IWNt909FiFDyKJJ9i4zeRX6dAxRaqY2Pb8WBWISfZ43Ncm33aeVhFoueRuzZU6sT1CTQ2Lgmgw5WoN4n23DXRekl/Sm70I11af0MD2h6aR7he9iY/ReSfrq6cpqFEbA+ps7dH60XqbKTk9vo/zfGc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/2/26 3:28 PM, David Hildenbrand (Arm) wrote:
> On 9/18/26 03:45, Luiz Capitulino wrote:
>> A future commit will introduce a kernel API to allow for checking if the
>> CPU supports PMD-sized pages. This API will be based on the
>> has_transparent_hugepage() implementation but will be orthogonal to THP
>> and therefore must work when CONFIG_TRANSPARENT_HUGEPAGE=n.
>>
>> Move its definition out of the THP guard.
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
>>   arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
>>   arch/powerpc/include/asm/book3s/64/pgtable.h  | 18 +++++++++---------
>>   arch/powerpc/include/asm/book3s/64/radix.h    | 14 +++++++-------
>>   arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 ++--
>>   5 files changed, 20 insertions(+), 20 deletions(-)
>>
>> diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/powerpc/include/asm/book3s/64/hash-4k.h
>> index 8e5bd9902bed..79511e6abfca 100644
>> --- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
>> +++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
>> @@ -165,9 +165,9 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>>   extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
>>   extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>   				       unsigned long addr, pmd_t *pmdp);
>> -extern int hash__has_transparent_hugepage(void);
>>   #endif
>>   
>> +extern int hash__has_transparent_hugepage(void);
>>   #endif /* !__ASSEMBLER__ */
>>   
>>   #endif /* _ASM_POWERPC_BOOK3S_64_HASH_4K_H */
>> diff --git a/arch/powerpc/include/asm/book3s/64/hash-64k.h b/arch/powerpc/include/asm/book3s/64/hash-64k.h
>> index 7deb3a66890b..a4a44a112ff9 100644
>> --- a/arch/powerpc/include/asm/book3s/64/hash-64k.h
>> +++ b/arch/powerpc/include/asm/book3s/64/hash-64k.h
>> @@ -278,9 +278,9 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>>   extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
>>   extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>   				       unsigned long addr, pmd_t *pmdp);
>> -extern int hash__has_transparent_hugepage(void);
> 
> Without some of these helpers in place, I assume actually using PMD leafs
> without THP would require some more work. (which is not the goal of this series,
> just asking).

Yes, you're right.

> I do wonder whether the architecture should instead simply say "not supported"
> if !CONFIG_TRANSPARENT_HUGEPAGE?
> 
> That should still enable your series: using mTHP without PMD support.

Yes, it would. However, I think this introduces an inconsistency.

In in its current form, arch_has_pmd_leaves() should always report a hardware
capability. This is true even for the default case where
arch_has_pmd_leaves() defaults to
IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE) in the assumption that
archs supporting PMD-sized pages by default will have this config
enabled.

Your suggestion will change this and for some archs
arch_has_pmd_leaves() may have different behavior depending on the user
configuration. Additionally, I intended to decouple the base API
implementation from THP.

If you feel strongly about this I can implement your suggestion, but I'd
still vote for keeping the API about consistently reporting the hardware
capability. Even if the only user is THP code today, new use cases can
be added incrementally.

> 
> [...]
> 
>>   
>> -static inline int radix__has_transparent_hugepage(void)
>> +static inline int radix__has_transparent_pud_hugepage(void)
>>   {
>> -	/* For radix 2M at PMD level means thp */
>> -	if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
>> +	/* For radix 1G at PUD level means pud hugepage support */
>> +	if (mmu_psize_defs[MMU_PAGE_1G].shift == PUD_SHIFT)
>>   		return 1;
>>   	return 0;
>>   }
>> +#endif
>>   
>> -static inline int radix__has_transparent_pud_hugepage(void)
>> +static inline int radix__has_transparent_hugepage(void)
>>   {
>> -	/* For radix 1G at PUD level means pud hugepage support */
>> -	if (mmu_psize_defs[MMU_PAGE_1G].shift == PUD_SHIFT)
>> +	/* For radix 2M at PMD level means thp */
>> +	if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
>>   		return 1;
>>   	return 0;
>>   }
> 
> You are swapping both implementations, which might create some unnecessary churn
> I think.

I suspect this was done by git diff as I just moved the functions, but
I'll take a better look.


