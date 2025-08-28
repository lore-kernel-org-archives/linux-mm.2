Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 570D0CA0FF6
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 20:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B692F6B009F; Thu, 28 Aug 2025 16:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A306B00A0; Thu, 28 Aug 2025 16:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BB1D6B00A3; Thu, 28 Aug 2025 16:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C1196B009F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:23:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 259AF84AFA
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:23:01 +0000 (UTC)
X-FDA: 83827290162.04.AD1548E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 932E0100007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:22:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bOS4yZau;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756412578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iCw6S1c4Czg1r6M7ZHaUoX4qfCo09yOzs1izbaqUr5M=;
	b=0toHfiGrNrt/Sa/gSuhJ+g9OlLE+1ON8dgwHUx23UHiUwtsPxfPc2fkE9lrOFDNzeMSR8T
	LRC5oyDVtojZp+roxpS+tKbVQRRiN8Wd8m0lD/CAYyrkS24aOU4St5u0Kv/gJ2bOczsE4X
	wbbBVhL/0wLILLjg6Cad85exVqW4OBk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756412578; a=rsa-sha256;
	cv=none;
	b=m7kKdG93n5lXDovP0ckRTu6FSyFY0Dam7qmfkhzH2D34z8h+sSh6OPchWcM008I+eS6vDN
	k8BA6PdiU8h5AuHG4deHBIqdDK1zlb8uJKokLSSslHDiMuu+QTZ09b6MLqzrVoY4sOcGnb
	fEGkhnU6DlGeDPDSBnDWzPBz8U2xbKs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bOS4yZau;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756412577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iCw6S1c4Czg1r6M7ZHaUoX4qfCo09yOzs1izbaqUr5M=;
	b=bOS4yZauIKJHJ5LKGodGGWafSdMvtCy47hitJnSzYrotzrjKXrWthiONxGRoj/Pog3a4P2
	1qEO9Juq4NUfPZ4JVLB7zkMoeFa8aqbPwZ2eY1gCjT2At+l2y9p58Eq3DGsiD1thLFm5gm
	AXIqEyb6LaAikYc4TXjShTBKXvHqdmc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-Y1pez5JHNoSxl7swZEcvBQ-1; Thu, 28 Aug 2025 16:22:56 -0400
X-MC-Unique: Y1pez5JHNoSxl7swZEcvBQ-1
X-Mimecast-MFC-AGG-ID: Y1pez5JHNoSxl7swZEcvBQ_1756412575
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3c79f0a5bf3so764723f8f.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:22:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756412575; x=1757017375;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iCw6S1c4Czg1r6M7ZHaUoX4qfCo09yOzs1izbaqUr5M=;
        b=g2bJv4AvHGLL3V++7PyDOqmtnhCXhX/1T3i2qCmgyAPuZGEjWXcMYU1mD2gJRnIZqe
         +bkzSYezMzJRXz/PWyeKo5bETfm41UlerLZNnvMGtkjM3fTYGCKTWUzGJ8WdvQp6G3Ep
         z/7fQTt9EJ7G+hAGXUhlpYPZdQlPDdEmKOpCYZFJsA5RjjPkrKvCbipEvVAR/n9lWwax
         Y2BheUkoWMWZx7LbXwzaOUhhS7DE6jQO3lS4wYhBqAyFJdcpV8o32TZgUQqoQtpweR/H
         gNpv9mNgozUyJV1N0HCRkKbJcTQQWUEYxra/j121+jE36nmZC+3WouzZPf44ftQAGxb8
         wxKg==
X-Forwarded-Encrypted: i=1; AJvYcCX2lueWZkNComZuJF/S1KfW0yrQqAWqQprBYVIKD6RM0Sx5R0p7bytMCJPkjL7nVHWM3xV7Wcnzag==@kvack.org
X-Gm-Message-State: AOJu0YwAHZ2UFRlC/aNCInGSswn39S7qWidQrHHn5AR1hWYnksILZd+A
	BlcXPKiBS/jkmKhfsR8jc0ViNqiUjdLYMcu++zni8bc8F33tEiabC36aXOf14PNCP19Nzs5tes1
	SpqC6FiMubOS/lepI32QWTt9gLR9g1DqA4z8yvfrgGHGpaAA0fpUj
X-Gm-Gg: ASbGncsbI/Z5SlmgCG0yJzi86B8VnYljRcaEC7p59SEYWigjgsw+EU+Ssc4As6iafWE
	YDwpGSuwOHHARSawEB18nNf6TzJ0LKpVR+78z+IumndXY4OzkjYhf35Jzt++cyUhsqIydfGaqVo
	8P+2uxneH4CjATG6DeWJA6cw3ZyIcxlT8EfoG3HpOaMKzBo9lPe5RO5jCSn+/R/5+vMSluc6IYF
	0qULhRox//nuapJ1xAekcOwPi0VebG5xPVZWuqT2J+h7gfN/kS8HwYCVKvnrXL2epjgz685zIxt
	h4BwOGco7n59OhZzD0l4cLdBtbS50DKNZeMJ2jOjbRRZvDyq/CK8dgLlS6iwDUvGdSqPz8IfuSq
	ctOfcYbCZiUNGMmb7b/Mc/8YayZPtmaPtgP0J3d6hr1kbuYuGfME0CrZd/AbJIJRsfa4=
X-Received: by 2002:a05:6000:2c02:b0:3cb:2fbb:cbec with SMTP id ffacd0b85a97d-3cb2fbbcfacmr9199142f8f.2.1756412575182;
        Thu, 28 Aug 2025 13:22:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1bdB/M72bSY/WXb2DaG2tpHGVwgtZZzzvekQUCsScziZOca1dV+TjSk1aAgRBOQI1EyT87Q==
X-Received: by 2002:a05:6000:2c02:b0:3cb:2fbb:cbec with SMTP id ffacd0b85a97d-3cb2fbbcfacmr9199122f8f.2.1756412574722;
        Thu, 28 Aug 2025 13:22:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f30fe02sm86293885e9.18.2025.08.28.13.22.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 13:22:54 -0700 (PDT)
Message-ID: <80a7b182-6bd4-49f5-ba3c-1ef53f51557c@redhat.com>
Date: Thu, 28 Aug 2025 22:22:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v3 02/11] mm/thp: zone_device awareness in THP handling code
To: Matthew Brost <matthew.brost@intel.com>
Cc: Balbir Singh <balbirs@nvidia.com>, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
 Francois Dugast <francois.dugast@intel.com>
References: <20250812024036.690064-1-balbirs@nvidia.com>
 <20250812024036.690064-3-balbirs@nvidia.com>
 <aLC2bfpIQo/a22gr@lstrano-desk.jf.intel.com>
 <00d58bba-7695-4f72-8ebd-d2db23fccec3@redhat.com>
 <aLC5SC7jUgUE2rKh@lstrano-desk.jf.intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aLC5SC7jUgUE2rKh@lstrano-desk.jf.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _juOUFlqioQT3TQlYMSFrqavtQfxR8GyB3IrF_MVUiM_1756412575
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 932E0100007
X-Stat-Signature: 7nf3p41sgsios1ortt1io6uk1czxbn3n
X-HE-Tag: 1756412578-303182
X-HE-Meta: U2FsdGVkX1/9znQ9LMZRs6FS8QHX2gb8Wf0J7YZ7Sd+VaUnml4Sctzbk0aA5FjFN8v4AVpOqUPxPDnID4z+Lrb4x8h9EP3I4JiYm/XMsogwCntDQ6aansj0nfvFjfthTiDMg8/WN2igqfBwBDwzeeZRXDiVSy3mcCEIOtUuB6qmlewYfGDIdLI1wsGK90sjrYat41y39BTQYU2nBxgwoV1hvoiaq8sQtLmtT+te7AJ7+DVEMuvuKDen2ixTxE6pvv12OhaSv9+ty/x2GKB+ik/HSozXcjAjxD/jsq/xgZxgkezzpTTuUfCzkFzb7l25AwjdwOCnuBFs4WYLU4p0hY/L3wLCJabBo+VJMvYwLB5/siM9HjMQIiIMTVyGmMFlV5qBx066mflCrNwu3ikOUK3DdvW85dTMAOQLzsZi4tlc4r+gUnjZFO+v4iLwUVHI4IWXFyYsIBFbzz2xQaJXUPUGLxOenGiAhA/3BEX75o4s3m32QF9fa2D/NY6GZC4c0o46pJlaDayRu/24Qhf6s+f08GdwwW4qNdsxAvfr9jZv9eaAbR3UuoAlnVwU2Q3/+3RLZbGWS5Hd1KBSzlipMtxCZzeYLOQR4Q77kewwshQL9DY8iMdnA5dbzzGmGCaMhvwRHG8l9dv9SJ1FEgRf9vu6zTmxG1prUW90pHYX5e3+Jrfbzafvrqv1zSe6pbzWr/FdcOLKE2Ky0uJjKshQ0lM1A/Irdlr5bZNRJQW4eA/T3Oiu0jW1Tix6s6RGVccJBOindpTF0IS1cFddyLsOvILJdcy/WCl9fvyssm8c3dLaInWCveZIVTXLD0J00obac3MXMKHeTjM6GOz6gGzfBxgGE/UobhqX9Jb3MH1oQP4jPEPnAQyZ3pIJs8zN0IggI87JvjncZO4EtL0HlcG968f+oKX5xpywo5Fe1KTQpQXnoo6baB8tNhycjfn6aDFPIULOMq1tShtwulFrxj4I
 iUpr6s38
 +K/dn76CYkMkAjbV5GCvfSmJMLtugHW6s4U6QSq8Im8hjmvPuF2dhTdOMyv96xVSWbO7m9Jbte5uA59r+sdJwyy5yEM+FbUmftxhIEe0FRh3r0ZM16dYdcX9LC3n6EBhRYvkErBWn0MSJKjuNEUUUDdMukWK6GStplGlouXZIiJ5rfe50eesnT3vg8IORrgg6JTU45UyN0h/DY7sGs7UnUocNkCO6ccEEisZRYlQUfEHidbvkiI2zWetvHwmPsDFAEGo1sxn/zDMA6rF/zRndrPTGd2E2n5Kh54m2qAJCA56TGF+T64XO245+mdpxhSxdcJbewta8ZmpZU4CyyDzRqXRL5O3/4IZtdOjQbce1vaII3H3uPnnlkE4pCZ8rVbzfcIRSROXXQ1Y0QUubkjqZRXw4NV8AicoRPmpE+F/gTxFaTSTxfSlF7aS8mckRyRWIk7+vUzxUlu72mKXaGBSxgrCbytN25j5pQJ914ueLC9YhwVH5WQgz8CjJIzFwdUY1nnbdcKJuLXP6TN882iIS2vDVqmT2ttaOrx8Ex6xqFgd48BR0StkX8/rrwbCybz3FeomwqUWhir2G9Gsmh2ORznomNJaZXuqeRcyW0H/3kLfNNnjPvgAEVBRqq17GxOBxBTmQmKsvdUX9dYHzxD1QgjWiAo6FwzQzLpkvlZZWH5FLMK1yxlPUqdr3K5Kxaz78+l4V78WiWNhT06oU7Rx0oeNeYFdtQbMAweduHvqEL776xVI3X93LddHzg1I0LO58w0bVrSYePz1jVW/QRu49otod1mkmR9lAfWwZ4yAIqWmq9nsdv0BOWiWHPREW3NBFVUVnF1pwrhZpS8tHk38UCI+OK0URgYarc7PTSNQRgp7X8fBG0fN8mduIuPMwadk3XIFqDkwAclMvoKBpSgFAhm05xYECWIzuMG9zRdsBpmIjcyULuauVuX3qF7V/2dmCW+9ZygPRREwbA9jOtSGE6HEijA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 22:17, Matthew Brost wrote:
> On Thu, Aug 28, 2025 at 10:12:53PM +0200, David Hildenbrand wrote:
>> On 28.08.25 22:05, Matthew Brost wrote:
>>> On Tue, Aug 12, 2025 at 12:40:27PM +1000, Balbir Singh wrote:
>>>> Make THP handling code in the mm subsystem for THP pages aware of zone
>>>> device pages. Although the code is designed to be generic when it comes
>>>> to handling splitting of pages, the code is designed to work for THP
>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>
>>>> Modify page_vma_mapped_walk() to return true when a zone device huge
>>>> entry is present, enabling try_to_migrate() and other code migration
>>>> paths to appropriately process the entry. page_vma_mapped_walk() will
>>>> return true for zone device private large folios only when
>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
>>>> not zone device private pages from having to add awareness. The key
>>>> callback that needs this flag is try_to_migrate_one(). The other
>>>> callbacks page idle, damon use it for setting young/dirty bits, which is
>>>> not significant when it comes to pmd level bit harvesting.
>>>>
>>>> pmd_pfn() does not work well with zone device entries, use
>>>> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>>>> entries.
>>>>
>>>> Support partial unmapping of zone device private entries, which happens
>>>> via munmap(). munmap() causes the device private entry pmd to be split,
>>>> but the corresponding folio is not split. Deferred split does not work for
>>>> zone device private folios due to the need to split during fault
>>>> handling. Get migrate_vma_collect_pmd() to handle this case by splitting
>>>> partially unmapped device private folios.
>>>>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: David Hildenbrand <david@redhat.com>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>>> Cc: Byungchul Park <byungchul@sk.com>
>>>> Cc: Gregory Price <gourry@gourry.net>
>>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>>> Cc: Nico Pache <npache@redhat.com>
>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>> Cc: Barry Song <baohua@kernel.org>
>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>> Cc: David Airlie <airlied@gmail.com>
>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>
>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>> ---
>>>>    include/linux/rmap.h    |   2 +
>>>>    include/linux/swapops.h |  17 ++++
>>>>    lib/test_hmm.c          |   2 +-
>>>>    mm/huge_memory.c        | 214 +++++++++++++++++++++++++++++++---------
>>>>    mm/migrate_device.c     |  47 +++++++++
>>>>    mm/page_vma_mapped.c    |  13 ++-
>>>>    mm/pgtable-generic.c    |   6 ++
>>>>    mm/rmap.c               |  24 ++++-
>>>>    8 files changed, 272 insertions(+), 53 deletions(-)
>>>>
>>>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>>>> index 6cd020eea37a..dfb7aae3d77b 100644
>>>> --- a/include/linux/rmap.h
>>>> +++ b/include/linux/rmap.h
>>>> @@ -927,6 +927,8 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
>>>>    #define PVMW_SYNC		(1 << 0)
>>>>    /* Look for migration entries rather than present PTEs */
>>>>    #define PVMW_MIGRATION		(1 << 1)
>>>> +/* Look for device private THP entries */
>>>> +#define PVMW_THP_DEVICE_PRIVATE	(1 << 2)
>>>>    struct page_vma_mapped_walk {
>>>>    	unsigned long pfn;
>>>> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
>>>> index 64ea151a7ae3..2641c01bd5d2 100644
>>>> --- a/include/linux/swapops.h
>>>> +++ b/include/linux/swapops.h
>>>> @@ -563,6 +563,7 @@ static inline int is_pmd_migration_entry(pmd_t pmd)
>>>>    {
>>>>    	return is_swap_pmd(pmd) && is_migration_entry(pmd_to_swp_entry(pmd));
>>>>    }
>>>> +
>>>>    #else  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
>>>>    static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
>>>>    		struct page *page)
>>>> @@ -594,6 +595,22 @@ static inline int is_pmd_migration_entry(pmd_t pmd)
>>>>    }
>>>>    #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
>>>> +#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_ENABLE_THP_MIGRATION)
>>>> +
>>>> +static inline int is_pmd_device_private_entry(pmd_t pmd)
>>>> +{
>>>> +	return is_swap_pmd(pmd) && is_device_private_entry(pmd_to_swp_entry(pmd));
>>>> +}
>>>> +
>>>> +#else /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
>>>> +
>>>> +static inline int is_pmd_device_private_entry(pmd_t pmd)
>>>> +{
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
>>>> +
>>>>    static inline int non_swap_entry(swp_entry_t entry)
>>>>    {
>>>>    	return swp_type(entry) >= MAX_SWAPFILES;
>>>> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
>>>> index 761725bc713c..297f1e034045 100644
>>>> --- a/lib/test_hmm.c
>>>> +++ b/lib/test_hmm.c
>>>> @@ -1408,7 +1408,7 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
>>>>    	 * the mirror but here we use it to hold the page for the simulated
>>>>    	 * device memory and that page holds the pointer to the mirror.
>>>>    	 */
>>>> -	rpage = vmf->page->zone_device_data;
>>>> +	rpage = folio_page(page_folio(vmf->page), 0)->zone_device_data;
>>>>    	dmirror = rpage->zone_device_data;
>>>>    	/* FIXME demonstrate how we can adjust migrate range */
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 9c38a95e9f09..2495e3fdbfae 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -1711,8 +1711,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>>>>    	if (unlikely(is_swap_pmd(pmd))) {
>>>>    		swp_entry_t entry = pmd_to_swp_entry(pmd);
>>>> -		VM_BUG_ON(!is_pmd_migration_entry(pmd));
>>>> -		if (!is_readable_migration_entry(entry)) {
>>>> +		VM_WARN_ON(!is_pmd_migration_entry(pmd) &&
>>>> +				!is_pmd_device_private_entry(pmd));
>>>> +
>>>> +		if (is_migration_entry(entry) &&
>>>> +			is_writable_migration_entry(entry)) {
>>>>    			entry = make_readable_migration_entry(
>>>>    							swp_offset(entry));
>>>>    			pmd = swp_entry_to_pmd(entry);
>>>> @@ -1722,6 +1725,32 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>>>>    				pmd = pmd_swp_mkuffd_wp(pmd);
>>>>    			set_pmd_at(src_mm, addr, src_pmd, pmd);
>>>>    		}
>>>> +
>>>> +		if (is_device_private_entry(entry)) {
>>>> +			if (is_writable_device_private_entry(entry)) {
>>>> +				entry = make_readable_device_private_entry(
>>>> +					swp_offset(entry));
>>>> +				pmd = swp_entry_to_pmd(entry);
>>>> +
>>>> +				if (pmd_swp_soft_dirty(*src_pmd))
>>>> +					pmd = pmd_swp_mksoft_dirty(pmd);
>>>> +				if (pmd_swp_uffd_wp(*src_pmd))
>>>> +					pmd = pmd_swp_mkuffd_wp(pmd);
>>>> +				set_pmd_at(src_mm, addr, src_pmd, pmd);
>>>> +			}
>>>> +
>>>> +			src_folio = pfn_swap_entry_folio(entry);
>>>> +			VM_WARN_ON(!folio_test_large(src_folio));
>>>> +
>>>> +			folio_get(src_folio);
>>>> +			/*
>>>> +			 * folio_try_dup_anon_rmap_pmd does not fail for
>>>> +			 * device private entries.
>>>> +			 */
>>>> +			VM_WARN_ON(folio_try_dup_anon_rmap_pmd(src_folio,
>>>> +					  &src_folio->page, dst_vma, src_vma));
>>>
>>> VM_WARN_ON compiles out in non-debug builds. I hit this running the
>>> fork self I shared with a non-debug build.
>>
>>
>> folio_try_dup_anon_rmap_pmd() will never fail for
>> folio_is_device_private(folio) -- unless something is deeply messed up that
>> we wouldn't identify this folio as being device-private.
>>
>> Can you elaborate, what were you able to trigger, and in what kind of
>> environment?
>>
> 
> Maybe this was bad phrasing. I compilied the kernel with a non-debug
> build and fork() broke for THP device pages because the above call to
> folio_try_dup_anon_rmap_pmd compiled out (i.e., it wasn't called).

Ah, yes!

As I said in my reply, we should not do any kind of WARN here, like in 
the PTE case.

-- 
Cheers

David / dhildenb


