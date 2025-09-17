Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A155CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 10:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACF818E0002; Wed, 17 Sep 2025 06:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A80BB8E0001; Wed, 17 Sep 2025 06:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 947938E0002; Wed, 17 Sep 2025 06:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5068E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:22:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 29B3013B1A2
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:22:24 +0000 (UTC)
X-FDA: 83898352608.24.065B7CB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id BD4CE14000B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:22:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZMzL6mfk;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758104541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mKyszV1q06Fp6TRfybx7eNtO4VCdcm3YS1IzQgwBUT4=;
	b=0gxZjaXtBbMUQ6c8bCvDtKYJSRxcrI7YY2VZIFbZSMgsb+buiuB+2nPLKAvm3zPsPG8E9+
	/5t7G0wCPbC1pmZ65g1rPQLTvvm01H4XRdkErOxwjjj9omJ44OjQJOBXs1i6SRhR2BTNMe
	WMOnB0licD/QxN5bGHWmWWR44CFDGyk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZMzL6mfk;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758104541; a=rsa-sha256;
	cv=none;
	b=sWb0Oy8JD66iKChoOl3DRRPuO9t9Y77nx6Zc/tDyqRZnPF7R69o0BMM92Uiz2FiB6Ksqyp
	/lNyAXX/cLON5UUs6YmT49oE36TrHTeDiT97QUlMdSnFsgUsR1ipkwwQhbiPkUpLHVc/Wv
	P0qIiYdHkxrtbba6t3t7OWue6mvz24I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758104541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mKyszV1q06Fp6TRfybx7eNtO4VCdcm3YS1IzQgwBUT4=;
	b=ZMzL6mfkrHmLoUibbiznuyddUlhAZ+I9R0pcZB+af6X3xUo1sgx0Pxuzn62xNpcd665q2j
	fqwyy7XngTT7Enhq2lvjQSNwLUiU31JcWcHgrq6IFenVpJ9k9t/WD78RUbjB+a9sQGa5V6
	/8Pz6ux3PJQm3AAA3uAwBXjszFRZfNc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-RRE_GdHfM3esDa9IOshHGQ-1; Wed, 17 Sep 2025 06:22:19 -0400
X-MC-Unique: RRE_GdHfM3esDa9IOshHGQ-1
X-Mimecast-MFC-AGG-ID: RRE_GdHfM3esDa9IOshHGQ_1758104539
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45e037fd142so53923975e9.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:22:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758104538; x=1758709338;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mKyszV1q06Fp6TRfybx7eNtO4VCdcm3YS1IzQgwBUT4=;
        b=WkwvTVj+qYsQPV+Hmm9BrkZANrewaOM3DLkZmxs03wjEFk75x3yl8Hy/pi3c324MsX
         RIX/t66iHeRQAVm+GlLcHu71FRh9AA3PFdsGH24LSbndHJEMDQ1ImnvaKPpeZ/uRMbYN
         ZsJC7LdEPKXxn85BYWTLbrW055FJQiyOIk0OItVAnwmu5cJuM9KcYIVIZu8aRkTAJT7D
         qHAuYvjiQowpgc/GZLU8bfdedlNztWBblOA86iN9rzgcsb5B3G05Gt0wDFr/0ZBYtUzb
         cjb4GCvsOcXTAkVgcG9OFbHXQ9rMmv9lnYM/27J3n4it84Q6ohUeK0ASNmRo+TAGtQY+
         jdzg==
X-Forwarded-Encrypted: i=1; AJvYcCWG54Y3IcyY8GaTsyaKu0r/wC4zlhACWHDQXF9WKlp/wZDL+n1wL6RLVQbfiZaCW8X7tCuHWnb6mg==@kvack.org
X-Gm-Message-State: AOJu0YwK84IXqmLN0n/RZqkrmIm9VTpOT6D+rxQiCKgKXvQadERnFmD9
	kclMBs3I2BfWUz90cH4ekyZsLCaz2O6vyn7boyhXt/WMr6DXyjOkNBzVIOa9WZeBect8NDjUf39
	VEiOmpIqk2TUEfI5jNKnO+GXwqlEBi3lYE5K6hrvpwQytHn/g4ufB
X-Gm-Gg: ASbGncsQrEZ2Sa2cJA17KamQBYmOZyBb/jpugkJbOSFEHYzVlqFEI/lPqnNG2Pbk8Rq
	9XOeBSUXiOJhIxR0IyXd+doIiHABKZUr//vTQWgLzOUP/IWMGQXRLeCe8nSqrOfUW6ixQYl+rSq
	LXDaWW6Xu9hkJi4xZ0YAeyR2kL+67pH76vEkqwEZG0CLtEnSRPsd1aAyaaz3he/c4k7DOL1at7Z
	ufGRL/y2R6Xlx77YVA+ySh4RIPCGIo1BVzjqAZfSIOB2w5yuQc7VbEN9pkNLDZ5hq4CZ9WTu4dA
	XZ3av2oNNjVolu0XaB66Q8SgitccmFNARfC3o/P9ViqBHNqXirg1KVDgtmDzJ42yxIKwf0Z+LwT
	Aa+QX1EgDdIKjATB3ekA/WKyNecVouMgZyR0y48W4QFKLLm49+JFzs63VnmDr3mgs
X-Received: by 2002:a05:600c:3b20:b0:45d:e110:e673 with SMTP id 5b1f17b1804b1-46202175527mr14813565e9.4.1758104538534;
        Wed, 17 Sep 2025 03:22:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHo6HbjqyIn3oQJnoxmTmcqeb7EBkzpfCOw15hL8v6Me3R6DzuZDAIwQ1WGLFWW9sjTfM1yRQ==
X-Received: by 2002:a05:600c:3b20:b0:45d:e110:e673 with SMTP id 5b1f17b1804b1-46202175527mr14813245e9.4.1758104538056;
        Wed, 17 Sep 2025 03:22:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4613930bdd8sm31088005e9.19.2025.09.17.03.22.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 03:22:17 -0700 (PDT)
Message-ID: <cd9bae54-a12b-43f0-8014-0c1d95916c0b@redhat.com>
Date: Wed, 17 Sep 2025 12:22:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 02/15] mm/huge_memory: add device-private THP support to PMD
 operations
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
 <20250908000448.180088-3-balbirs@nvidia.com>
 <17e3c19e-0719-4643-8db8-cf8c5b5aa022@redhat.com>
 <49776f0a-d891-40be-bce3-c2b1f16bd825@nvidia.com>
 <4de00290-7c29-42f5-b8aa-58a77b17c1d5@redhat.com>
 <8a2c4803-d613-4592-9114-d68b97bf3fb0@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <8a2c4803-d613-4592-9114-d68b97bf3fb0@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: btOUuRggX7ooux0SjpT16PROnzI3smTra73Dfe4YgNs_1758104539
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yf5seinj6dddanfjmuck9q1uow9xpqx8
X-Rspam-User: 
X-Rspamd-Queue-Id: BD4CE14000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1758104541-606724
X-HE-Meta: U2FsdGVkX1/dF5f2OnE2AXbzEu8y/zVCH7+S9hPnohW20S9/zK/DmChUUEoMPUa97TqwEsFUKcv9LRtQSZ1dNK0VYolsdMCtcvqAgyuIc++AENy4gcaDdwaOJmlQjwur4Zf4EDtjIW5MOQ4Hv6JUnihiCso4eB52hiGP0JgEWXrPZWMlMgqRJWLTKwPaHmPF4uXWh/odpjmPVVmeFhr6wBVHl7Ca1fF7UkXShLQbxt4NNzhsyH44H2KRSisf5jyTQSAPSb8h04eIx4lusbfRMALS5CtzVa4fIdLm7xbCueCfmlIILwo2w5a7RM+oy0LH7SRiIlQsrjInmDe+n6OQfsxBC1kUizZcE80vNRDj3cfT4u+UKP0HQf1Jd3pYOwRfTBoEfVGcwKpcMDJPOnydFRQgwEJZqDNgoBkSy5Ox5MoWaGpG0SUsnA6YAI9eoTTEHpQMf6/LW4jWuisPErGxXNky1uoZ7wlthUE2zFCUcxVgIMCVcbpVRr7a5I3utxEd2V4jLKRw47X9DHG1tplkt23PVhJE9bFzwGnJSvCKf7l03NDhKyoWACdZA4C+85owPlgJj5cd2Z/dhOBW17U2nAEfvp6MUAD5NWvEaIb/bgzYno1F6QdzVy+SP1oSOHmjz0Yq3Ld0aks74GzPqIHDn/PglFxiOInLrfBTrCwFQc/70JKkKpJ6NKHtaUeSFIJFIIzcwgjbeBZfcYvbw54x6WMp8WCdiskDIo9ZQIXYAHBSg3xUQFMjfLHmhsmYeDvYEn5ZX3M+5pvc/8VDRpD6/1mrsIb7tAIYN/5agpkkML/FsaYIY2ghJqw4AO3z6omw+9j1MMprY+GPxxZf17k1HQMokaTE28WlPAvpVJcBl65oqlWLSeA2JFOQZGSQzqQms72/G7QJUWmx3GP+2ig6Mh1utlQmze8fG60GLuis0xWGQ+Mh3QfNptljnRDeQBVbgYRyzkD+h1a2msN+98E
 i5exz+2p
 yja8Sdzabj09rlPAvLu9wcOwX4IIkSAgSxA18SkoVPzgAT9ImWw6mXvXJ6M0/7iFAgnPj9YzDXEfj+lsEEZyQNQO1tqsPkud0fNrMwjrp5oU/vQ9XNnBw+eVndvJMPSrWPSjfq9EDlo9X4GLhYLyx7PkChUakqDBbgNK2YrZwpHT25ifHmk6JuoPmYgw0Q2RxhvkLclfAIHKBpQJEsuP6C1+bjllhUNvw3t1F5N87n1cvepsxkc56/7hsGC0nHQ3W+Vpo1L9b+rNKWkk6LfHHdHBnpbtuhrnbUGO53gjDNQe21YJlSFSWRR6rueXcLkrYsS+PorEfIXFuZQ1e8L9wzLo4GX8ybhyV5/aHTIOHYxmgextJiPUCDBZ1j7VLh2PMCk6HA3f4hszKiMI/Kw4UvQzIoCaLChEuL1D7rUoJ9/g3vDziAkkdJd6rytm4Bh7kWFDR6U2/F2uhvcacOtIk90YPn9SrlLD4Nui0Kd7aymSU0Tb7JYndG3DlJoxw5GCss9S89rZAlKyPe7zjtN576N7PZvRKemdVrMhGk09LgE/QTYUd6uecrJnylv5+tM5Q/szJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>>
>>>> Couldn't we do here
>>>>
>>>> if (!pmd_present(pmdval))
>>>>       goto nomap;
>>>>
>>>> To replace the original pmd_none() .. check.
>>>>
>>>> A page table must always be present IIRC.
>>>>
>>>
>>> I am not sure about the pmd_none(), a page table may not be present, I've not audited
>>> the callers. But I think we can do
>>
>> IIRC page tables must always have the present bit set. So we can just simplify to the single pmd_present() check.
>>
> 
> Not sure about that one, are you happy if we follow it up later with a separate fix

Taking a look at other page table walkers, they couldn't possibly work if
tables would not be pmd_present().

E.g., walk_pmd_range() in mm/pagewalk.c has

if (walk->vma)
	split_huge_pmd(walk->vma, pmd, addr);
else if (pmd_leaf(*pmd) || !pmd_present(*pmd))
	continue; /* Nothing to do. */

err = walk_pte_range(pmd, addr, next, walk);
if (err)
	break;


If a PTE table would not be pmd_present() we would never ever call walk_pte_range().

So I am pretty sure that this can just be:

diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 567e2d084071e..1916d22aaf1f1 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -290,7 +290,7 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
  
         if (pmdvalp)
                 *pmdvalp = pmdval;
-       if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))
+       if (unlikely(!pmd_present(pmdval)))
                 goto nomap;
         if (unlikely(pmd_trans_huge(pmdval)))
                 goto nomap;

Unless I am missing something important :)

-- 
Cheers

David / dhildenb


