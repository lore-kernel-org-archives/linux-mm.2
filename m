Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79F20CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 20:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 981738E000B; Thu, 28 Aug 2025 16:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 959078E0001; Thu, 28 Aug 2025 16:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 847CC8E000B; Thu, 28 Aug 2025 16:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FE478E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:13:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D46F184B8F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:13:10 +0000 (UTC)
X-FDA: 83827265340.30.4D9AC5C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 550DA16000F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:13:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Iw5IIXey;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756411988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6CKebG25zZ7Qh5eUzDGh3RpuZ+KtDVV8aoTCmVYURho=;
	b=5MBKnXBTGuLLnmgmS4NZjdVhuZFpNDX+IBOk30tFuKx2Gm814X8SdwHY5pm7+gnSJTF8QV
	IJxGW1e7Qq0KG7L++EHFNwW7v4k9oauwYHQOhvguCtB3ANSDE7vz7Ui6A9XItwPr+WO8iM
	IoH8ZTLVonSZCNmYSKFHiYpydx7YLZA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756411988; a=rsa-sha256;
	cv=none;
	b=WNGLv+M60f9/OqXsFEikYTmwyYA5iYqMOwpGOzmCK9EfcaCOQwtbt9BK6y4O/nXbl/1v9y
	Kff/cu3d6otYiclcsryGshc+0hXmjGJYfwTu5RBJa4/gnI9VeTKEVskApsK/M5IweaM8R8
	0vyjlkPBzKF7xnQr/tU5DyBdh/zCqzw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Iw5IIXey;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756411987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6CKebG25zZ7Qh5eUzDGh3RpuZ+KtDVV8aoTCmVYURho=;
	b=Iw5IIXeyvLi7OS1NA5S9aVWCcu2NZUFUX4LsJnGs8R1LXmycsCPfoYwfurHCQoFW7++zMQ
	970OtlRptHx9hHPxUVNG1RCe28crdoIc1VkPqQGSzfXckHg8vO3/rhDHyBGzCX68OpcPZS
	n+7yUAF+ddbJv9F0t5QLOXxvFHijI0k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-fhckn6dVNR-CP-Hdz7ecqQ-1; Thu, 28 Aug 2025 16:13:04 -0400
X-MC-Unique: fhckn6dVNR-CP-Hdz7ecqQ-1
X-Mimecast-MFC-AGG-ID: fhckn6dVNR-CP-Hdz7ecqQ_1756411983
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b05d8d0so9440275e9.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:13:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756411983; x=1757016783;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6CKebG25zZ7Qh5eUzDGh3RpuZ+KtDVV8aoTCmVYURho=;
        b=uYNCo5k4LGY0D4tuv+lXrQ7A3m8s4Ov5D4eHw+75relOh4HIIt2zWVM1EZNF5CxK0D
         CtEUl3O2IlsxieFiuetyXXqAIKoHTX3xJdSUGPLg+4yYMdK+0bEp0HOAi+1yoCaaR7Vq
         YxwhWlxHWvhczMNvT7WIiLGOw62m/XdRpYZuJjPOfRFqkYQqr9BJhUtKcDIirtXBdjNL
         SKVN5bk0IGc2CGioQJkRoDIjNkzaiC6eiDgBgaDyQlmwtsCozCtHxRVitvbb6N/PnuoF
         iNAaYIhaR/EWWBheqqhQu50jLfoQYCmmrE0ybY+o5ASWyRDfXW2bMIaUddBMbwFchpDM
         rmOw==
X-Forwarded-Encrypted: i=1; AJvYcCX2hhVSCHBkrsbvIwePCdMxOR2J2xvt5QNsuiorgC9lXdwyBCEUCRYIem0tJfOjU/fUr7iCmCqtgA==@kvack.org
X-Gm-Message-State: AOJu0YwSqb/KqM8obrh+uDWYN7yg7IxFj+h8x5MzJveLYxW2kiXeTNOh
	z0tDNEYFcle8rc2SseEz7Pp4cacXXzJqNafoC9CQoXnIHZilMOzuE/mFIyyOG9wFuOHNBzSMXbT
	tpoB/2EtMliibc+pQdQ/T+MOrbJ8hOywe7VxvhqNB5VfqDNUoygvs
X-Gm-Gg: ASbGnctsqSF/sGniaZ0RRgEhfwtGOLzg57+JErpI6Jr0LfBPGb+gOHVGqAI7kRYNVOe
	SCwVcuAGcOhlntKpeARh1Wt3Zead7chcS2p4Kc2h0ZmcDrKUjbN91Gl8LAYCQvMP8aipHzEXpNe
	GJiBxj+Ep/4/DwB4NMK5O0rm9YQVS4Df5nyqAksC7IhpJXYHdXJruzipJ/9cAgyX1Zw5z3uutBx
	DSRCb0KgbrKJQT1Og+BpuNG9K0cSCaXdjz0Zv4Vo1z2iM5P4WfVGAmEJMNfjmy0Ri5dKRmbG+2i
	v/mciaz4dAstAIgDmMotliYxBf876qefhQ9/5ArOs1xD6i2ClT5byrYMg9vgS3g2g9D31p8KhD9
	dVHHcC4WHkuuYsirb+GNxXLGwSeizA1Qf7kWlhzGCX4Kk66YRGXMa2DcSW7/zQV5hGPM=
X-Received: by 2002:a05:600c:45d4:b0:458:f70d:ebdd with SMTP id 5b1f17b1804b1-45b5179eb97mr298530965e9.16.1756411982748;
        Thu, 28 Aug 2025 13:13:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFYlg6U6YWP3KKWPLKnc1b8KsAr3EP3vAhz8qoffX84clo1bvTszS2+UY9ViAz8ohcbnuHyZQ==
X-Received: by 2002:a05:600c:45d4:b0:458:f70d:ebdd with SMTP id 5b1f17b1804b1-45b5179eb97mr298530685e9.16.1756411982211;
        Thu, 28 Aug 2025 13:13:02 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6ee66bddsm88856345e9.0.2025.08.28.13.12.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 13:12:58 -0700 (PDT)
Message-ID: <00d58bba-7695-4f72-8ebd-d2db23fccec3@redhat.com>
Date: Thu, 28 Aug 2025 22:12:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v3 02/11] mm/thp: zone_device awareness in THP handling code
To: Matthew Brost <matthew.brost@intel.com>, Balbir Singh <balbirs@nvidia.com>
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250812024036.690064-1-balbirs@nvidia.com>
 <20250812024036.690064-3-balbirs@nvidia.com>
 <aLC2bfpIQo/a22gr@lstrano-desk.jf.intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aLC2bfpIQo/a22gr@lstrano-desk.jf.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Tr9Vm5F8k5Rhw8SNAIEPF7ofOlPFOO-syEnn4cZCqpc_1756411983
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 550DA16000F
X-Stat-Signature: peqdbpo8p96m36c4ugaw9mcxa7o7btqp
X-HE-Tag: 1756411988-140948
X-HE-Meta: U2FsdGVkX1/k8dn3rn4sKspqKJN2xzWY7M0+7VOGUTDMdeUOYbH5gaGfDbqqlI5MUEaSdGFo6tJP+C3PBPysXCJgZgoFFKJ1ZGce+ZT4k3mMIrjlri2Lu9lJ1QZts3SmQ/OkPHL6fhEDLpXW3ZMhiXzeRQDa9YmRCzPtu3So26a9IC3w37TvsmI08HBL3VXUNo4GCcm0ACU70Hyf54pthsSaygI+1NsUXoFRH3f68w42HiLoLryHtvxc5YcGgumK19H1fGcuzT0w8S2d4Pshr01To5vr0U13Ao03GPlfXXamO/LN+dNXJ6M7GDcH9yFA8YyVWEsNonoDeDsMfPKw/MslX+62RuXqijS5Ds/cDTnjujlO1B1xlP+OvrbjWeTWJCtAaGlgAG0xOGv8whpvtWTWwSU6wiiumJeUm+zRxTayLvCXnw2KBVmX9lhNN9kcc/Pdc7XGd9ItOWy/lUQ75k2JUumcU76qsZkmfV/JmmJLb0vjZkGngiVpsYGA0KcX2/KRK9O55cc3LDsn0YcQyEIRjbGaLH48RLXRA7Rqkodn+mHERAxZDkm3SSkpcHpy6hp3DZE4QcAtDooZcK1dKiSsb0wEn4HnmVcOmI6JwPkvDrKAXdriUvlXyybqVGoJbvAY3ct0ERMtJW6XRriUmEbvMkFnyDZBu/eElP1pd7LWMSMckTbkOuei+SHuzc3HPiPjJvSye2YbuubpfenKke2lnQE87yGPV9tv2hs9xJIUE0ZvjdUJr13FT+/JkFXp0UZWY5yFO7TH3DXnSUXqhcQwiCKIZFSDb2PGmAfnfG09c+V1bMdowc8fAUd89u4+AdZcPgl4Oew3YGfjpSMbjgeiCE++ynW0ONCahU3tLoADAwwMU7TLOFfc/x0MF9/xCsuT/DaHbMVB3AQEm8BeExd+UnApPzt2tTlIteepNFgL0cFJiUQWIILLatBA6Kmvlmf5CSvRJ1ofGKdTMG+
 8wjjs9z7
 WdJQgurJ0j2IpbadbVUtx5hGOKpUsQDYAuPbkPcU3UTiJpZSMhorAm72FUCX/zFz4vL8PW3K2amL874G76Xapa7BaC4WoWsCALHfIxoyHQuH8ydo3ebtFvm85nHg/EjzzqjmW+PEk33A2zGKHOBdtA4DsjzRFn3v3CjNfXwXG4krdjR3KXCUX88ToD/w/rkKLigO3DupY901btjiqoIvPdwWcR/TY31R0SmRf1bd/IfjdJyyJRpELAbPUAUMQMs5ZMphIrDGW0Ihct89gGU4AYv106CmHkErYWcQVxXTnpUACBXrxzuKgpY3VDSW00VFXPLQShW2gYpVgEgClifMa/i4+hiM5JuIHDo0pGRnp4EbUlRJ/2Dy6zWUR1QKktFqW60L/REYO3vR+wLLjAraBsEuqOiLLE2AeTTBNnRmNT1ea+IklPnGwr4HePI25wALfObaKN7NtwSAuHB5O+837uJoTlDtf3oJHI18JF8gd8o4iQRCHMUSdZVjGBle7E500iegxoLTM2KTlowRHiuo2YuR8ncSwWsanZKGHpnKo/cbH81wPZLsdMD64SFbEYmR6T47oWuD6oyOv4wetJI45wyg9UXBb2P4HaBS1tD1dkyi9Ri0PlEoRMlbe4ChGIkCAI6/UzFWuN4bFBHhsVBGZdjlo58wdzBAN9NPNaVYsgSiNa1OFUNcDbHAkUhQHGmEBlhQt9nGDms9lC8vmo8a5Vt2pbYflS6Ys9aQsxdHGJkjLq8ExfdCDyB3kVwKMXc8CjNmcauyDFNTD1+5Xka7/GrJoMgwkjdTTfvpK/+yVe4MqqdnqzcE062Zd2Xf2Zi3wytXbp60fcRkmwjvwtq9GbH1cxc5p9UI3Kh0jpvnlAlgx5BVqcK5jfwLJ0KaXwozcO0XHOfNibDypYc5YNYEh7pTiJVAzvYOH2HgikSA5+73WZQFiQJ9jIxGN8WA+V0EdOCjGRHlUelDaNXutC3RNY3d9ow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 22:05, Matthew Brost wrote:
> On Tue, Aug 12, 2025 at 12:40:27PM +1000, Balbir Singh wrote:
>> Make THP handling code in the mm subsystem for THP pages aware of zone
>> device pages. Although the code is designed to be generic when it comes
>> to handling splitting of pages, the code is designed to work for THP
>> page sizes corresponding to HPAGE_PMD_NR.
>>
>> Modify page_vma_mapped_walk() to return true when a zone device huge
>> entry is present, enabling try_to_migrate() and other code migration
>> paths to appropriately process the entry. page_vma_mapped_walk() will
>> return true for zone device private large folios only when
>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
>> not zone device private pages from having to add awareness. The key
>> callback that needs this flag is try_to_migrate_one(). The other
>> callbacks page idle, damon use it for setting young/dirty bits, which is
>> not significant when it comes to pmd level bit harvesting.
>>
>> pmd_pfn() does not work well with zone device entries, use
>> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>> entries.
>>
>> Support partial unmapping of zone device private entries, which happens
>> via munmap(). munmap() causes the device private entry pmd to be split,
>> but the corresponding folio is not split. Deferred split does not work for
>> zone device private folios due to the need to split during fault
>> handling. Get migrate_vma_collect_pmd() to handle this case by splitting
>> partially unmapped device private folios.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>> Cc: Rakie Kim <rakie.kim@sk.com>
>> Cc: Byungchul Park <byungchul@sk.com>
>> Cc: Gregory Price <gourry@gourry.net>
>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Oscar Salvador <osalvador@suse.de>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Lyude Paul <lyude@redhat.com>
>> Cc: Danilo Krummrich <dakr@kernel.org>
>> Cc: David Airlie <airlied@gmail.com>
>> Cc: Simona Vetter <simona@ffwll.ch>
>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>> Cc: Mika Penttilä <mpenttil@redhat.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Cc: Francois Dugast <francois.dugast@intel.com>
>>
>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>> ---
>>   include/linux/rmap.h    |   2 +
>>   include/linux/swapops.h |  17 ++++
>>   lib/test_hmm.c          |   2 +-
>>   mm/huge_memory.c        | 214 +++++++++++++++++++++++++++++++---------
>>   mm/migrate_device.c     |  47 +++++++++
>>   mm/page_vma_mapped.c    |  13 ++-
>>   mm/pgtable-generic.c    |   6 ++
>>   mm/rmap.c               |  24 ++++-
>>   8 files changed, 272 insertions(+), 53 deletions(-)
>>
>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>> index 6cd020eea37a..dfb7aae3d77b 100644
>> --- a/include/linux/rmap.h
>> +++ b/include/linux/rmap.h
>> @@ -927,6 +927,8 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
>>   #define PVMW_SYNC		(1 << 0)
>>   /* Look for migration entries rather than present PTEs */
>>   #define PVMW_MIGRATION		(1 << 1)
>> +/* Look for device private THP entries */
>> +#define PVMW_THP_DEVICE_PRIVATE	(1 << 2)
>>   
>>   struct page_vma_mapped_walk {
>>   	unsigned long pfn;
>> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
>> index 64ea151a7ae3..2641c01bd5d2 100644
>> --- a/include/linux/swapops.h
>> +++ b/include/linux/swapops.h
>> @@ -563,6 +563,7 @@ static inline int is_pmd_migration_entry(pmd_t pmd)
>>   {
>>   	return is_swap_pmd(pmd) && is_migration_entry(pmd_to_swp_entry(pmd));
>>   }
>> +
>>   #else  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
>>   static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
>>   		struct page *page)
>> @@ -594,6 +595,22 @@ static inline int is_pmd_migration_entry(pmd_t pmd)
>>   }
>>   #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
>>   
>> +#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_ENABLE_THP_MIGRATION)
>> +
>> +static inline int is_pmd_device_private_entry(pmd_t pmd)
>> +{
>> +	return is_swap_pmd(pmd) && is_device_private_entry(pmd_to_swp_entry(pmd));
>> +}
>> +
>> +#else /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
>> +
>> +static inline int is_pmd_device_private_entry(pmd_t pmd)
>> +{
>> +	return 0;
>> +}
>> +
>> +#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
>> +
>>   static inline int non_swap_entry(swp_entry_t entry)
>>   {
>>   	return swp_type(entry) >= MAX_SWAPFILES;
>> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
>> index 761725bc713c..297f1e034045 100644
>> --- a/lib/test_hmm.c
>> +++ b/lib/test_hmm.c
>> @@ -1408,7 +1408,7 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
>>   	 * the mirror but here we use it to hold the page for the simulated
>>   	 * device memory and that page holds the pointer to the mirror.
>>   	 */
>> -	rpage = vmf->page->zone_device_data;
>> +	rpage = folio_page(page_folio(vmf->page), 0)->zone_device_data;
>>   	dmirror = rpage->zone_device_data;
>>   
>>   	/* FIXME demonstrate how we can adjust migrate range */
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 9c38a95e9f09..2495e3fdbfae 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1711,8 +1711,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>>   	if (unlikely(is_swap_pmd(pmd))) {
>>   		swp_entry_t entry = pmd_to_swp_entry(pmd);
>>   
>> -		VM_BUG_ON(!is_pmd_migration_entry(pmd));
>> -		if (!is_readable_migration_entry(entry)) {
>> +		VM_WARN_ON(!is_pmd_migration_entry(pmd) &&
>> +				!is_pmd_device_private_entry(pmd));
>> +
>> +		if (is_migration_entry(entry) &&
>> +			is_writable_migration_entry(entry)) {
>>   			entry = make_readable_migration_entry(
>>   							swp_offset(entry));
>>   			pmd = swp_entry_to_pmd(entry);
>> @@ -1722,6 +1725,32 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>>   				pmd = pmd_swp_mkuffd_wp(pmd);
>>   			set_pmd_at(src_mm, addr, src_pmd, pmd);
>>   		}
>> +
>> +		if (is_device_private_entry(entry)) {
>> +			if (is_writable_device_private_entry(entry)) {
>> +				entry = make_readable_device_private_entry(
>> +					swp_offset(entry));
>> +				pmd = swp_entry_to_pmd(entry);
>> +
>> +				if (pmd_swp_soft_dirty(*src_pmd))
>> +					pmd = pmd_swp_mksoft_dirty(pmd);
>> +				if (pmd_swp_uffd_wp(*src_pmd))
>> +					pmd = pmd_swp_mkuffd_wp(pmd);
>> +				set_pmd_at(src_mm, addr, src_pmd, pmd);
>> +			}
>> +
>> +			src_folio = pfn_swap_entry_folio(entry);
>> +			VM_WARN_ON(!folio_test_large(src_folio));
>> +
>> +			folio_get(src_folio);
>> +			/*
>> +			 * folio_try_dup_anon_rmap_pmd does not fail for
>> +			 * device private entries.
>> +			 */
>> +			VM_WARN_ON(folio_try_dup_anon_rmap_pmd(src_folio,
>> +					  &src_folio->page, dst_vma, src_vma));
> 
> VM_WARN_ON compiles out in non-debug builds. I hit this running the
> fork self I shared with a non-debug build.


folio_try_dup_anon_rmap_pmd() will never fail for 
folio_is_device_private(folio) -- unless something is deeply messed up 
that we wouldn't identify this folio as being device-private.

Can you elaborate, what were you able to trigger, and in what kind of 
environment?

-- 
Cheers

David / dhildenb


