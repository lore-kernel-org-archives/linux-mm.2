Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2B8ACAC599
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 08:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 146C08E000D; Mon, 15 Sep 2025 04:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E9E8E0001; Mon, 15 Sep 2025 04:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28E08E000D; Mon, 15 Sep 2025 04:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA7588E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:23:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6899513B20A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:23:36 +0000 (UTC)
X-FDA: 83890795632.29.C7C0E2E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id EB883120004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:23:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EF8M1DEn;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757924614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JqhshB8TYPsb+g5TmZKbNKCw5pbdQvF7Hb0F2Aj5puM=;
	b=ElcUziY/hk/w0bLOSFfKICKhB4G5ZB4Dhl8pmuzLDPKHFOu5eChN0twuBiCs2GQ6MNs0j3
	o8JuaNjR17DqwpZu/XCUCvU6v9n65wn0ruSL8wubdBpVO9/7IX87f4I1Q7BD/Q9E9hVhop
	lLUIYR7acr1RGqgKRbXaYdKsTMSGh3k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757924614; a=rsa-sha256;
	cv=none;
	b=3lyBtjX50CrD6LlDvDVWzmX5h7hnJyW20ehFh0YI8t3cyVRvqPoqb/Qs26RCN4Tk9GiGqd
	x5/P99aiarqvOJAeKxFDC+j19pL6V1y6ol/kW0G9IVkWkIKqOrrRSEIVR54Ikc9MY1FU8Y
	KSRC6hseeWJpMSql6CpzGaiXwifLQm8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EF8M1DEn;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757924613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JqhshB8TYPsb+g5TmZKbNKCw5pbdQvF7Hb0F2Aj5puM=;
	b=EF8M1DEnmtsb4IDyQM2JoSORAFLsbQZJNVbK+iLmFsccISGs51f4GlW6QnldmO1lg8lbdo
	um7AUbDHOAAov247qjYWsutqhw6Mo3sH+YRXCLXA6tAjJQeoYsUEwMjE8OF80NuFkV0zIM
	17XUy/KU8tBhx7eC6tJVaDVjmWLerG4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-G0UEqQYuOSiX3rcG9woWIg-1; Mon, 15 Sep 2025 04:23:31 -0400
X-MC-Unique: G0UEqQYuOSiX3rcG9woWIg-1
X-Mimecast-MFC-AGG-ID: G0UEqQYuOSiX3rcG9woWIg_1757924611
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e8c4aa37bbso404026f8f.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:23:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757924610; x=1758529410;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JqhshB8TYPsb+g5TmZKbNKCw5pbdQvF7Hb0F2Aj5puM=;
        b=odv+B0lC0q7x0xO0DH6RnLCi3+/sbEPZr1nqYMqM3WszFfFIYcQXRX+mJPSOlwEeSz
         rBiCw4f+9Bl4VpuB5QJZ96J7vob8P1P1jcO3WU67NQ3t782pdG7LKpouaqps+13uVk9D
         sP/iHgPjShcQwZvvYd59aLKazBBjf50KE7VoF2gAMhCYD4lLyH8fpzR/ttI/K2j+Zo70
         ZTtJYNA34+k7EuBhxnfyO3amkw4H6n7HbbNMiu0QOW8fGr9IycazFl8AQEBz2cJezbsK
         zhLZluv5eBwNOX5mF+fQfNNNrkW/3a9ljzOyyn5mtyLOkuRl6vqUl+RKX5SBEHn/Skcn
         dgaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqX/ephcOGjogWAmDgmagE8TdbMFmWjybFjke+IdpZ5TjcRm1yFcFvQh4vUmFkv0T1JD4zbdND0A==@kvack.org
X-Gm-Message-State: AOJu0YzWthOWYGZlbkpKyViVDre0urlV9otv79Jo/HVhkwTZoUF2W1OJ
	bqiKVXhg7dxAGalb0gTliQoH6eher3llrCAMYC1AmOpflLsv0yCB3iJvHAcTeKtMVIdlDL0jRYR
	67pYho/WFGcYuyXidRVkIRya2ira3qOjZTzjVRAJvm5psqk2qaoyU
X-Gm-Gg: ASbGnctox2wCZ2cYcyejCrAH70x7ARlNMt0FnyTbgrb72hTZVM/Rt1zWEVi1wTWDW7y
	GZIa2NPTRlav4dGfWujOFGqM0gth0shs4PSVVi0uU47BpbwNK++Fk3CSyWl2j69UhOOciNyDTvP
	W5Y8qfOdyMy03RlgshhZclPQOzyEZIPvNyShWYbgK/hQre634NCxIw8m+5hBh/Tx4hMKkWnZBZK
	OA3olz1BePxdn1UmNAIAlURyYCQV5TKcj7oglt/0cxcOzbDVOOeYJmoXwRMHxIUnt3q3ItYLXI0
	bcNs4SqdkTQ2wTzOOeRk2rfOOnTcrIv8dsr07lXt6tSblWIDFEJOoV6IEWI6r5geQkcVM+TjdXx
	9061GcwXi32rB7JJeULlFCSg8Fp6yDMqobSwINFC0jwgrMXDoGwexvuBGNIKe62spP8M=
X-Received: by 2002:adf:e8c9:0:b0:3ea:f4a1:f067 with SMTP id ffacd0b85a97d-3eaf4a1f3b9mr1182511f8f.48.1757924610371;
        Mon, 15 Sep 2025 01:23:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFN3XeyCLaRYHldjOQ9OEelMTey5LNlW0frPUT1EYWkvYswnHtxiqghkiDAMSUmTm6fMzozBQ==
X-Received: by 2002:adf:e8c9:0:b0:3ea:f4a1:f067 with SMTP id ffacd0b85a97d-3eaf4a1f3b9mr1182484f8f.48.1757924609866;
        Mon, 15 Sep 2025 01:23:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ea9abd7234sm3683870f8f.59.2025.09.15.01.23.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 01:23:29 -0700 (PDT)
Message-ID: <12299d6a-487a-4d29-a74a-a53928b83dd0@redhat.com>
Date: Mon, 15 Sep 2025 10:23:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 04/15] mm/huge_memory: implement device-private THP splitting
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
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
References: <20250908000448.180088-1-balbirs@nvidia.com>
 <20250908000448.180088-5-balbirs@nvidia.com>
 <ca592d4a-3e91-48ea-970e-a5ff12f215be@redhat.com>
 <dbb631dc-32d3-4b2d-a23c-968c7a61001c@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <dbb631dc-32d3-4b2d-a23c-968c7a61001c@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JKDXW4rc8cnAOSy5eLWqTnnai4fKyUPWFigi-U_AcaM_1757924611
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EB883120004
X-Stat-Signature: wpkh9mgz7ox6itirfp74h3ns1qytc5y6
X-Rspam-User: 
X-HE-Tag: 1757924613-416782
X-HE-Meta: U2FsdGVkX19xUYcDB8AlrZpLHmQIPkTockA2RP1pKe+/lIsUMqSOStW2Dwhfn6CEKwIZQWHksU2OZGx4jfbafJHzpIoYIGLnpL4GFSFNjw+OXgVfZdGt/bm4rrh+Bm94iCrBra/p0S9HQDf4W04laq/hAK85zXBukh7SIrV1X0gp1Yy6T5S01lDvKIU2/zG4MDnhq9hnGhha7NUJivhz05EzY8vF/+hw2hAu2HTYFEi9/AzfV1ehf0b/WmMhdb6vBG3n+VhuDdO2IHXCfSFY/0n+xvUslNnI+0HEbG5b6fSWin5B60gIUmCBsN41uIjEoD3hGkGYdNkiVnuZu3F7C9RFTsEvdLzVK+sv/bcCgumX0mx72ygRc8QOtOUjKynM+7GYMJlk12KkHUbc64MYR+VeWOedPm1E7/BawLjbyYCfEyLwNIPWiAyUOwFYhjDHHQj0x04pD57dpPuUvADStK7Nanm62ylfgzzTrzA6vMHH1Ufv0cqT96YUMJ4lOFAv/TUZ2M3xxghbp4V9JpsihMadAKmizjXX0KX5miZku/lMaQYLLMyEgfnqipr28A72fgSc1oSfEYELSqChyFoDlUleCvkx80Wcb/oYRHg2txMgswDy2+lpGNsOH2FdhvADGXy+zdvCkSCV7xRddQUNfMqgUhQU3qgOuhTXstXPfQhuxvfES/IZWbtkKbDK13wtXzeWSaJKHsyjPKNIbCGJDv+vGHkdSS5cStbHNE3NzRTtn//hZuFOMZ9Kj9yY1JGF7W0Gj32N7bgo+dhDgJR7K3HYzbKHf2siphapV47WV5/ayRNwiO29qkevQNy7iNTalwwK1zDu4MQruDd+VKkQYMm0GKbnV26xTHi7b26zMw1wcuC6BOKiSc8ZL2y9Hspcmwsqr/if8zBpxRH/gs7aAoxecjGep7VRhhqlRXQaVGW0BUMc9LX6atCItaJTD4FGnp2ms3E61x+/IlbhUC2
 1ENI68mw
 qPDSc1QHs0cIwVmj+RQTT0D34cX2N+Ik+y9WKadOWhjiBeHIZS0t/acXpSb2znmHf4ySa3Qt31PPc5ppTSD6uhi9MTvrFsGx+XA2X5wg2eUvTS2Io6ItgBf06ztEizQYWnVBEAiRF08DiPl6aSxjRIk7DGpFAcPhc9nV4/gYgrzetQVBHbflPNM9Ntzt+A4jdU7fifkzQFEnChQCQbG3h3mo1omvc9XrX47TQGGqfR9aU/l2HrzJfYr+S5GvOqCrE+iYPOhjNDVzLrMN+rm3gaQDTifb/Hn65yEedGaYVJGHF41mG1A5cvEow+tPqzmW+EcBp09hMta1MW4hdzgvpJ/d0x60Vzb0ZeefdcXIlLjP9ZKolYRg4Kz8IjLxuOaMisvKMy49gzCJxDYigQRitLE/ZJvOjZpZNBSvYHdAWpGhCNXYiwXnk+V3OMyW0vMJBn8n2nRuUWunB1gmkUIVNcoEQxyNpPHhWeP/ujKcbtaQeoPZYap+YJctjV4A0C1nDrSZgZ0/FXDxCEp/hJotc4nnrxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]

>>>          VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
>>>        VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
>>>        VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
>>> -    VM_BUG_ON(!is_pmd_migration_entry(*pmd) && !pmd_trans_huge(*pmd));
>>> +
>>> +    VM_WARN_ON(!is_pmd_migration_entry(*pmd) && !pmd_trans_huge(*pmd) &&
>>> +            !is_pmd_device_private_entry(*pmd));
>>>    
>>
>> Indentation. But I do wonder if we want a helper to do a more
>> efficient
>>
> 
> The indentation at my end is fine, do you mean you want to see the conditions aligned?
> 

If that's the case then all good (sometimes the added +/-/" " in the 
diff mess it up and confuse me)

>> is_pmd_migration_entry() || is_pmd_device_private_entry()
>>
>> If only I could come up with a good name ... any ideas?
>>
>> is_non_present_folio_entry()
>>
>> maybe?
>>
> 
> There is is_pfn_swap_entry(), but that includes hwpoison entries as well.

Yes, we could just use that I guess. Or alternatively add a

is_non_present_folio_entry() that does not include hwpoison (because 
they are special).

> 
> 
>> Well, there is device-exclusive .... but that would not be reachable on these paths yet, ever.
>>
>>
>>>        count_vm_event(THP_SPLIT_PMD);
>>>    @@ -2937,18 +2940,43 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>            return __split_huge_zero_page_pmd(vma, haddr, pmd);
>>>        }
>>>    -    pmd_migration = is_pmd_migration_entry(*pmd);
>>> -    if (unlikely(pmd_migration)) {
>>> -        swp_entry_t entry;
>>>    +    present = pmd_present(*pmd);
>>> +    if (unlikely(!present)) {
>>
>> I hate this whole function. But maybe in this case it's better
>> to just have here
>>
>> if (is_pmd_migration_entry(old_pmd)) {
>>
>> } else if (is_pmd_device_private_entry(old_pmd)) {
>>
>> There is not much shared code and the helps reduce the indentation level.
>>
> 
> We can definitely try this
> 
>>> +        swp_entry = pmd_to_swp_entry(*pmd);
>>>            old_pmd = *pmd;
>>> -        entry = pmd_to_swp_entry(old_pmd);
>>> -        page = pfn_swap_entry_to_page(entry);
>>> -        write = is_writable_migration_entry(entry);
>>> -        if (PageAnon(page))
>>> -            anon_exclusive = is_readable_exclusive_migration_entry(entry);
>>> -        young = is_migration_entry_young(entry);
>>> -        dirty = is_migration_entry_dirty(entry);
>>> +
>>> +        folio = pfn_swap_entry_folio(swp_entry);
>>> +        VM_WARN_ON(!is_migration_entry(swp_entry) &&
>>> +                !is_device_private_entry(swp_entry));
>>
>> Indentation.
> 
> Same as above, checkpatch.pl does not seem to complain

Make sure that both "!" are equally indented. checkpatch does not catch 
what we usually do in MM (if you read other code).

[...]

>>>            soft_dirty = pmd_swp_soft_dirty(old_pmd);
>>>            uffd_wp = pmd_swp_uffd_wp(old_pmd);
>>>        } else {
>>> @@ -3034,30 +3062,49 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>         * Note that NUMA hinting access restrictions are not transferred to
>>>         * avoid any possibility of altering permissions across VMAs.
>>>         */
>>> -    if (freeze || pmd_migration) {
>>> +    if (freeze || !present) {
>>
>> Here too, I wonder if we should just handle device-private completely separately for now.
>>
> 
> For all practical purposes they are inside the if statement. freeze and is_migration need to go together.
> 

Right, but there is only the loop part share between

freeze || is_migration_entry(swp_entry)

and device_private entries.

So we can just avoid that churn and handle device_private entries 
separately, right?


-- 
Cheers

David / dhildenb


