Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E343ACA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EADDF6B027B; Wed, 27 Aug 2025 07:28:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5EDA6B027C; Wed, 27 Aug 2025 07:28:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D27086B027D; Wed, 27 Aug 2025 07:28:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD5C46B027B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:28:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 64EBF14059E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:28:55 +0000 (UTC)
X-FDA: 83822315430.04.33F2154
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id DDABC8000F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:28:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JOw174Hf;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756294133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2oQ4yyn+fuHtT1ZM0Ps0RKh7qw9mFPkcHlRbmx1CZxA=;
	b=YwUiTKmjiLIcbzbK7jXXVWkHAB5Ly44hGUjDErWdyr1v2mGPECltp4elCiOwWEFcn8wmhm
	T3HOoUuBR4JHOgPxkSsSaU642efwJmVWsVqk3TyyOlXMyrcC6QtcGl+nwIkrAMpaYXCKiV
	lNt4YnGnq3FmyQwG+us3JGg9QbEOYpY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JOw174Hf;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756294133; a=rsa-sha256;
	cv=none;
	b=epNYXvxWZIdC4mGFWK0QOI6jM939/qpYJzdV/LuDwcfDNJrWDhIAQBjBTjg1ctJQZmCA1b
	RKoxen+eE2crXg0hdT94cCDI8clc8m/rYC1HK33ptrReTJaz1OoNrWhcQvCjoEyi0LPQyA
	ktoC6vV2WE7fnziPsxLBcBvPhUssX2U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756294132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2oQ4yyn+fuHtT1ZM0Ps0RKh7qw9mFPkcHlRbmx1CZxA=;
	b=JOw174Hf6ySIqGPk3RRSIN0MCtGAPlHpknNH4VDZtfnAUuad4kzZg2ULqZXonskOPSva16
	+TnjCFvI6uS+XJQF2CqItazIPyccQmWjazMFJ7AFnynBXGOCMZ3bA9NrAo3ym9Z9i3EKHQ
	j1troys7hEEw9AON1iz3p+a/O6zbcHU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-63-vtVqzlAXMMqDrMDWgI5SPA-1; Wed, 27 Aug 2025 07:28:49 -0400
X-MC-Unique: vtVqzlAXMMqDrMDWgI5SPA-1
X-Mimecast-MFC-AGG-ID: vtVqzlAXMMqDrMDWgI5SPA_1756294128
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7e8706a5e78so2467496785a.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:28:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756294128; x=1756898928;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2oQ4yyn+fuHtT1ZM0Ps0RKh7qw9mFPkcHlRbmx1CZxA=;
        b=kLYXH94kxft1sBL/GbbIf4ys7oZQ1W8Ic3z8B1fh9JdULPv8CkB8ax4yBBx60lysZm
         KB8+y/eybS4xz8iqBM7H3ivNMfIZKTilkaEG+PalwV6XBK/hS+JDAT5ApZZjAJXBXz5Z
         ZYhQz9vLeahoSgqzMzGi4ZBhtYSTmcEzzak0kBQFWrq11EfTMq0O1j5/wjZgIOPJT9TB
         TARYDM3nN8MGszcfm3KJlI4nkEacGEhip11axHwdfFM3jWvFnpy1fee+EiLpdgMfa+c6
         YFmQF5ouNxKiFZdRz2xst9ikpYBDZrIfcvjCSbP+/R4MZfPleVZwhTvg6II3Zb54T5VE
         kalw==
X-Forwarded-Encrypted: i=1; AJvYcCWPvJZbVFtC5hteU+yvDvg8CkjpefSzf9Ccp8Y/Blsb5VjEpwAMzzf86mRghRya25yk7aJtWUxmaw==@kvack.org
X-Gm-Message-State: AOJu0Ywf+iyk1U1whNa5P3EjcN9v44fbGfMem1cTt2r7PRLo6Kz30noU
	UPNrpL04GcGiQd8k9NzkoKsMSjQ+Cl4aTlOwU+br/FMg1S92M50cOulk7dwN3cjbRubz5/oEVX9
	RCDXEBtxOrKrb79aq6rnaLR2OtdSUurjS0DRQPQq6E8PdjiW1lIHW
X-Gm-Gg: ASbGncvw6l0Pylkce62478N2TCuFqnwU5JLLtTdbBB+Xm2l71Dr6FBBYOf3i0dKuP6K
	b1dWRnSfDU5/3SNZd989InqCF36RpoRUcSikVuz3PMKB7NKSd8P0sV2QkKNcmpJ1ec+T04rR+f/
	wgfyMe4Ecf2qNV91XnJUFVgVuhrx9C5/Puop1SvNbIVl23ZsZReHxI+pfFU37+9l2oyJLiduDfH
	9CFv4fDzO6DZIjpb5bJIVwt5mm+amulaqr2nTMCrK+m9D6US2yD0NmQL9lNU2TQ2KbEUqK3P/jZ
	NrdSdRDUSlmg4WyAZkI2ng3Igc55yTYVr0aUCouOFp0s+3TO+U+8oTms9nZPZQ==
X-Received: by 2002:a05:620a:2894:b0:7e6:856d:bcb with SMTP id af79cd13be357-7ea10f94df7mr2661737385a.6.1756294128466;
        Wed, 27 Aug 2025 04:28:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGW8ZUPI6UYniG83VeXzqqz790E5oUSfgsxv/Czm9VchZxyn+4OUiu73ck2Pw5OQnBy/KIY8Q==
X-Received: by 2002:a05:620a:2894:b0:7e6:856d:bcb with SMTP id af79cd13be357-7ea10f94df7mr2661730185a.6.1756294127842;
        Wed, 27 Aug 2025 04:28:47 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ebecb18cb4sm867878585a.2.2025.08.27.04.28.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 04:28:47 -0700 (PDT)
Message-ID: <7cdc05d8-899b-495a-8298-ad5f27fcf8ad@redhat.com>
Date: Wed, 27 Aug 2025 13:28:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v3 02/11] mm/thp: zone_device awareness in THP handling code
To: Balbir Singh <balbirs@nvidia.com>, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250812024036.690064-1-balbirs@nvidia.com>
 <20250812024036.690064-3-balbirs@nvidia.com>
 <763e1fca-e4c4-467e-a1d0-ea911cad4714@redhat.com>
 <85ef9a34-f511-4306-ac28-bf90f614709a@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <85ef9a34-f511-4306-ac28-bf90f614709a@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E4EE1hB2InZjLqdcz5lvE-pZbstp2q98Ua9y_KenEQ0_1756294128
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6do1k75ksa4sqe6y5ksoznnyng1rnxzb
X-Rspam-User: 
X-Rspamd-Queue-Id: DDABC8000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1756294132-881248
X-HE-Meta: U2FsdGVkX1+A1xJxA+9OWGqUCdd3pdrh1mlOXhzG0OOHdgXI7R8mQ4b0bU+FthPTv+3ThEOS90hfl+s2r+D7ovPow2/sJKvu/ZhjDdZD0bLb+V+ovu1e7HZaogPNsa6nM+EfbXwdZRxX+G5DK8JuTJRhL2P9iv6+IJX0v9TJeHfFY76WXs41OEwko1+G/jw1JG7iHZKoS04gpnbgkieqG0iDNYdHcrjOP/D3rHKL/kcQ6D7q+ewhbv+vIxLYWaUEeUxDQMF/BOmrhDHXQjJnv2F9e+McoIX6voGha05TmoEgXPELwIAvTnMzqhGfv5L7335zn0f9BvRCNIX+AWV+DhtYh8xnOXzvrk7mhpHSRq9/TuMFZQ+qII7Ji3qVt/wNcfu8l/82d0JLYplu6Ftbgvz5yW9a4ves81XEXqJrkTs3TXVw6JaL1ZM+de8P4si19w21siSBSAjvhcXP6pofoE+25Kk8RTsG8jlVLeOT2rqx/GGq0jnXotaOzmnfkcrC1KTOzBMMvdeBAMKzuG2irLwf+5ickrxO2FI+qbFrquylxZrV9HO4Bj6G6mQN09sAxEwtppvwtQbwVHD++5Fi6Ddqqg9c+a3bEEhkPMhxIGbEB1VadKnwJXgJCv3s9ZLqAiaAXmtmM06bEL4JZGqzrz8y+H9nHjBtcE2D7Zy3rw/r4dKuOBORxoxvd3lt4zrMSFHm2xNVIEZiVzYYnSlHMIkkL6Up/qIXtOn/7k6kIa70WbQs+bJWMPRHeJfjIHeJBnV9bRY4OaKQX7jXUm2GA/i2ZAOKjkjG2U8fbI59UT8oIPY1+QImCXqW5RputrxQ46UnhAR+Y5sfEsAJm6OIZdisHr4IO5I6ulXIfqFIBAPSUqDbkxkfu4jNBLr3YlucTWjWZytnxwNlgyByl6A7/0xgLrp3gEFwl3hkTGfdXQvUgHmsA6U1HKV1eaEV0MtSpZWYdHmS8HEPf/s5y9N
 /TJiNdC/
 Xe81NMn1szklwWXnZqdCvwRHwrM7O0/iRwdruSy/j1ZIRNGR5rQXUS5amaR6DShCuCVMspVqKUnjA03SIWxjD8/XiK5oh5SAnPQrdK6EUdbjR0CghtUQ1db4UBrpbd8a6zHoq4TiP+p2hDYIv2cqwF7ClCIUDshvZ36KMJGRnMTytsGQQ1trev8Wj3LWjeQs87J1w19KBW4MS6pxNc38cmgbM6JdWM0PicceL7w6qka7OG/VbsouI5cxCBKcovflog4R7QUKD726WdwsFOuRINuXkfs9fVQgv3i4Sy861T5VW9BjxUACS1knoo1syju8FV9HSw6JgcnRu75iyiEs2qX/0axl3uaxANAHHS77lI2qKweyjv3yhri0pvMIPgqcfzzCVpKiljN6hAA/N7q+TSlwhuxS1PeevD8p7HziY0ZEAeygzEATzOjFVpl7ovU1P37wLjy3/pQmVUzqXJoyKdpleyS+K2lmbV9x/ItsLRgJ1TlU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Like teaching zap, mprotect, rmap walks .... code separately.
>>
>> I'm, sure you'll find a way to break this down so I don't walk out of a
>> review with an headake ;)
>>
> 
> :) I had smaller chunks earlier, but then ran into don't add the change unless you
> use the change problem
> 

It's perfectly reasonable to have something like

mm/huge_memory: teach copy_huge_pmd() about huge device-private entries
mm/huge_memory: support splitting device-private folios

...

etc :)

[...]

>> Careful: There is is_readable_exclusive_migration_entry(). So don't
>> change the !is_readable_migration_entry(entry) to is_writable_migration_entry(entry)(),
>> because it's wrong.
>>
> 
> Ack, I assume you are referring to potential prot_none entries?

readable_exclusive are used to maintain the PageAnonExclusive bit right
now for migration entries. So it's not realted to prot_none.

[...]

>>> -            WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
>>> +
>>> +            if (!thp_migration_supported())
>>> +                WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
>>> +
>>> +            if (is_pmd_device_private_entry(orig_pmd)) {
>>> +                folio_remove_rmap_pmd(folio, &folio->page, vma);
>>> +                WARN_ON_ONCE(folio_mapcount(folio) < 0);
>>
>> Can we jsut move that into the folio_is_device_private() check below.
> 
> The check you mean?

The whole thing like

if (...) {
	folio_remove_rmap_pmd(folio, &folio->page, vma);
	WARN_ON_ONCE(folio_mapcount(folio) < 0);
	folio_put(folio)
}


[...]

> 
>> Why do we have to flush? pmd_clear() might be sufficient? In the PTE case we use pte_clear().
> 
> Without the flush, other entities will not see the cleared pmd and isn't the pte_clear() only
> when should_defer_flush() is true?

It's a non-present page entry, so there should be no TLB entry to flush.

> 
>>
>> [...]
>>
>>>            pmde = pmd_mksoft_dirty(pmde);
>>>        if (is_writable_migration_entry(entry))
>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>> index e05e14d6eacd..0ed337f94fcd 100644
>>> --- a/mm/migrate_device.c
>>> +++ b/mm/migrate_device.c
>>> @@ -136,6 +136,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>                 * page table entry. Other special swap entries are not
>>>                 * migratable, and we ignore regular swapped page.
>>>                 */
>>> +            struct folio *folio;
>>> +
>>>                entry = pte_to_swp_entry(pte);
>>>                if (!is_device_private_entry(entry))
>>>                    goto next;
>>> @@ -147,6 +149,51 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>                    pgmap->owner != migrate->pgmap_owner)
>>>                    goto next;
>>>    +            folio = page_folio(page);
>>> +            if (folio_test_large(folio)) {
>>> +                struct folio *new_folio;
>>> +                struct folio *new_fault_folio = NULL;
>>> +
>>> +                /*
>>> +                 * The reason for finding pmd present with a
>>> +                 * device private pte and a large folio for the
>>> +                 * pte is partial unmaps. Split the folio now
>>> +                 * for the migration to be handled correctly
>>> +                 */
>>
>> There are also other cases, like any VMA splits. Not sure if that makes a difference,
>> the folio is PTE mapped.
>>
> 
> Ack, I can clarify that the folio is just pte mapped or remove the comment

Sounds good.


-- 
Cheers

David / dhildenb


