Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27777D172BE
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 11:44:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8894D6B0093; Tue,  3 Feb 2026 06:44:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8714F6B009F; Tue,  3 Feb 2026 06:44:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722CF6B00A3; Tue,  3 Feb 2026 06:44:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B1876B0093
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 06:44:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3DF6C1CFC
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:44:52 +0000 (UTC)
X-FDA: 84402963624.23.E411687
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 07AF0140009
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:44:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZcggqcTw;
	spf=pass (imf09.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770119090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=keJ7r6z0e5tfzYSPZHgMul7xPPOyDBWoeWPV4xq6pBg=;
	b=YsBi8TiUx62njKSkOJSMRXcWxUpkLhCs0L6/KXLDCgOFpOU5U75FOb/txO9jSbBsL2sigw
	muEOe6clDqug/DlwDK2n80izedYdeK8pKv6gmbLF56fPB/cFAzxawqjUG0HZiXPyX5f6DC
	L6Bk7Cxzg64PVDwI/pjV7wLyf+gN//w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZcggqcTw;
	spf=pass (imf09.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770119090; a=rsa-sha256;
	cv=none;
	b=K5M5YKBTJDGsu2kedDYpUN1a55MX0Y4LfhCKeHM2/pKAh1PAKefYnj4mLd5tAfCKWfS2/x
	p2o0baaQaSwua8dnuf7BZATV3jFCCqX4XhkjV8CZUt5VrewZv4k1ejR56N2A6rDHHSwOpc
	aHyRyA+u9tff/7NYc8Akx17fgvaYXi0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770119088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=keJ7r6z0e5tfzYSPZHgMul7xPPOyDBWoeWPV4xq6pBg=;
	b=ZcggqcTwz6L02Jpb69w5VT8n8GSkSNB2oEhJLFQONt9axqkGiaTlagiZMa0W9WB4BgAWg+
	G5RL4SJ+BCvLLx5SBvsgz4HoXW3hd5FcdYl/bwhNcDn2QAi43HNqErhMxrZzofW3psMuTs
	d05cvfq2XOa0VYSYUTauo2UCwjRdqC8=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-7kLtGLWoOTKXj255ALKj-A-1; Tue, 03 Feb 2026 06:44:46 -0500
X-MC-Unique: 7kLtGLWoOTKXj255ALKj-A-1
X-Mimecast-MFC-AGG-ID: 7kLtGLWoOTKXj255ALKj-A_1770119085
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-59e2e5f04acso1249936e87.3
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 03:44:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770119085; x=1770723885;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=keJ7r6z0e5tfzYSPZHgMul7xPPOyDBWoeWPV4xq6pBg=;
        b=IAig3ze2HO3X1aDhzPof+6XiM4SPe7b5g+wDEfpBNr2uMa6SH+ab0pGnfv+D6HBgrU
         7AHeVWNwT+6CV2+/TC98zRE5lUlBFv4dZDDRebqx5C7lj/P8mPJ7N7iQVZupsYZHs2tT
         IdYdIcKDBmof5fe7Va0eZPkprGTEJHQEcpu02G5s2Enuzf6XSCIfyaGFostoxipcCrLa
         JfbnUf87VYM2Z4bdaRI7KyIIsIE5loveTKZsveu34bxruJu11vN9WdeWVm2ghmCj8JJB
         PbNkrP/eC5aPoE0wtbGVERbbKMjIEoahzMaHNAMa0ckkwQfuwmHEkj3JW58sStOyF6ZO
         cRFg==
X-Forwarded-Encrypted: i=1; AJvYcCWrV7mzd/GdlvJMmulDoNb1tEr/EB9Fv1M3cdDs78igRprRAY/2xXEhl0A+dYqs1JMFuwAWKynshg==@kvack.org
X-Gm-Message-State: AOJu0Yz0kTUvlhxovM+HUHWoc4s5uU9O0Nv+SmoeiWA7TLxxsPrJOIUW
	TOvAxt+Kuwinv2GeZkMsoaOQGkhypcV50cqMI7a5oH0ZtrhpMoVzmK18WBiF3s/EUnx6lz3oz1o
	md2iqEJ+diT9B3ZhJuPYSxc1SW3vT6fqmc4KFUHaPDvjwDyS9pAg=
X-Gm-Gg: AZuq6aK4XGuxS1jv57DcudWkl+XIooZC/yl95MGDvK+bI8NloG+1gRNyndIxlLuqxUn
	JZgxag/7Rvdkb7RB3/AZ5vmF6YLwuBHfyBQCNII2qbGbQ0ZUSYKSjx83wwgHZkO2FpXlap8ArtY
	zHeB8CqWxs/9z0Juj4jF3v//ivxB/Ci8PqTXs8690pmg9FwHOXd94bDolIFDv6Uyq1UZ5wHhmN6
	MbCsKE3CnxOclhW+nB+TlNa9I6b2dyolPqPreaOgB17rj63eNmfhlLBjvrqW/cFcRr0AR5OmgaQ
	3Ih2Abm+Ybe8LH6fiMdnn8GFyQm/PDHGuk4fyj0x0UI4bU1OryBZbwWeCze739aRV31ahUSQpwo
	AWTCjgEv59NahdQZe7PnYn6iRtJctxirn4is=
X-Received: by 2002:ac2:5681:0:b0:59b:b2ee:d40c with SMTP id 2adb3069b0e04-59e163d588amr4686698e87.9.1770119085016;
        Tue, 03 Feb 2026 03:44:45 -0800 (PST)
X-Received: by 2002:ac2:5681:0:b0:59b:b2ee:d40c with SMTP id 2adb3069b0e04-59e163d588amr4686676e87.9.1770119084432;
        Tue, 03 Feb 2026 03:44:44 -0800 (PST)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e074b7b5dsm4094224e87.79.2026.02.03.03.44.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Feb 2026 03:44:44 -0800 (PST)
Message-ID: <7f4b10aa-2b8f-4eee-b66b-39dd7965f78b@redhat.com>
Date: Tue, 3 Feb 2026 13:44:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] mm: unified hmm fault and migrate device pagewalk
 paths
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>
References: <20260202112622.2104213-1-mpenttil@redhat.com>
 <20260202112622.2104213-2-mpenttil@redhat.com>
 <779d6e58-caab-439d-9bc5-c996896c51a3@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <779d6e58-caab-439d-9bc5-c996896c51a3@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wcdvYEQoF2qstZb_TXWlln3_EH8b3AQiKyH9Ngjkm-4_1770119085
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 07AF0140009
X-Stat-Signature: 35ewnwqwyt55bno6p5yqde5apwux6bm4
X-Rspam-User: 
X-HE-Tag: 1770119088-616057
X-HE-Meta: U2FsdGVkX1/mEfmtbb7t66TkhjOBeckqGbvuYLeBSXmZKqaCOqESmNPbhpZ46ygyq2ztL9N5dLqIKLle/yCUJBSs8t8tffF1xRn4sDr87iFsUk9JUi4xSpw++lxss2hazovCNbL8C4JYTPXeXaH1jTXO6Eo2+jWspSaoe5eFXvgg/ELdg+tvGnPgHo5D9+heF0luydoJwViZuExCfO1t+S013GmGWOSgpqDJlmEN8+bi28RDqIhgH9U8yfL3evX46NFLiq56RXKKqbcis8exQFfWk97HkON6w9WavEdB2fv7B4gTOXNCIK1GOTkDhSjCPYRj3dQGzJyQ/Mt9DIUJWuMZ8j/Opuk3jkSOOTaF8SSh1dKFUNzHC4KajHyaDK+1PtsJ7T2HQpbKpVTJ4sq1kg61xU54V+Yhbj3XIS4fd9YShs3DyKqFmCx8d0a6IX5XKAm4hHZtLO8KIQzZmTAciSkrW1xeqtsVpWE3q6qTWHFjdcjlOGF4NP3xj1HxCttFjLITP7ILUV05YW2GFX3M0tOhIqG9EyW+LnVDggqHVMj1sb0u1jfBOGNwLeAa2ZZelVy4K/YgI+NrNTlaBpDpyUHior5Zb29LF4VbvilyDc26FlEKtzkDSH2NbXdXGt+AILs99oQs8xReIkiQmw51hfltx7ZMyyYptZzPVQx1LtjHc4zhmDHfIYdKDjTetDyGCJCyJQ/eDQjdgQyV6V78zsYnGcoty/KAnqRKk/xRQ04joQRrYDZP9OEEMqd7hgV5OZpamBkHU41eWwQnnUc7mvsIVYgAyydb2c6iWN6uQqS4ZxELnvJX4sYOQ7eR4w+eOAHtHOBHvWnfookFeNDF8djnLVzW9bFpXMl1CCqvCay06QBYoRw9azirWsr7HEx2PVMUJJeEE6Q/BJmg1xrmFwWp5GD/VsbzGCAWeInNzBKI7IqTHboAyfnhKwwQ6CWIJXEcDvcE69wQDHz8fgI
 2nMfnIF4
 0IokoiwpYqi3DaRNigKBYA73sSdb8NYM3jC0RWii71XfNYVU+olKW/oQKj5gzkYBSbRYMyoKbpaAZYjP/yYFfwZmiQtoqK+cuMtOGN/30aEBOFdhWf6nDYWejSeKFWKA6ehF8x2aR/qEUxKastIi5VxsqZtSuJYIXJkvZrl0RAJKUR4EgaKMLxgMofraDEkTjdWraW1eH1I+tqqXgCwbXIYG70z5xqUW1s3SAzpOBz1O9bZ4jxLhLRpTOlShphm2nPO7UXAn2ughKZGXZfR6f90SUGHeVbM1TA+nesTCK6PwJooyopP/mxcIb/sFquRTYz43Tv9Hj6dYNwOg3WmMXXWVlCTgyFLpuJqiOxIyhQ1OiKGm1/fHnLnlvUEhzhE/GTKiCiupZr2l9psLMXGc9qcdzbyc/BWM9fTmy3Ch5fx3JLx0oIP1miyjkzn9Y82zEfqvXF/L8uB9VcP9vc22Or/Et248dgWVrxRAMb449lg6dMgGM7cEkNCk8AB3tl+I1mHrfING86hF4LpW8Va9COPiEVkA95N031b6eiD8wvInGDP0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 2/3/26 12:46, Balbir Singh wrote:

> On 2/2/26 22:26, mpenttil@redhat.com wrote:
>> From: Mika Penttilä <mpenttil@redhat.com>
>>
>> Currently, the way device page faulting and migration works
>> is not optimal, if you want to do both fault handling and
>> migration at once.
>>
>> Being able to migrate not present pages (or pages mapped with incorrect
>> permissions, eg. COW) to the GPU requires doing either of the
>> following sequences:
>>
>> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
>> 2. migrate_vma_*() - migrate the pages
>>
>> Or:
>>
>> 1. migrate_vma_*() - migrate present pages
>> 2. If non-present pages detected by migrate_vma_*():
>>    a) call hmm_range_fault() to fault pages in
>>    b) call migrate_vma_*() again to migrate now present pages
>>
>> The problem with the first sequence is that you always have to do two
>> page walks even when most of the time the pages are present or zero page
>> mappings so the common case takes a performance hit.
>>
>> The second sequence is better for the common case, but far worse if
>> pages aren't present because now you have to walk the page tables three
>> times (once to find the page is not present, once so hmm_range_fault()
>> can find a non-present page to fault in and once again to setup the
>> migration). It is also tricky to code correctly.
>>
>> We should be able to walk the page table once, faulting
>> pages in as required and replacing them with migration entries if
>> requested.
>>
>> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
>> which tells to prepare for migration also during fault handling.
>> Also, for the migrate_vma_setup() call paths, a flags, MIGRATE_VMA_FAULT,
>> is added to tell to add fault handling to migrate.
>>
> Do we have performance numbers to go with this change?

The migrate throughput test from hmm selftest shows pretty same numbers (within error margin)
with and without the changes.

>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Jason Gunthorpe <jgg@nvidia.com>
>> Cc: Leon Romanovsky <leonro@nvidia.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Suggested-by: Alistair Popple <apopple@nvidia.com>
>> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
>> ---
>>  include/linux/hmm.h     |  19 +-
>>  include/linux/migrate.h |  27 +-
>>  mm/Kconfig              |   2 +
>>  mm/hmm.c                | 802 +++++++++++++++++++++++++++++++++++++---
>>  mm/migrate_device.c     |  86 ++++-
>>  5 files changed, 871 insertions(+), 65 deletions(-)
>>
>> diff --git a/include/linux/hmm.h b/include/linux/hmm.h
>> index db75ffc949a7..e2f53e155af2 100644
>> --- a/include/linux/hmm.h
>> +++ b/include/linux/hmm.h
>> @@ -12,7 +12,7 @@
>>  #include <linux/mm.h>
>>  
>>  struct mmu_interval_notifier;
>> -
>> +struct migrate_vma;
>>  /*
>>   * On output:
>>   * 0             - The page is faultable and a future call with 
>> @@ -27,6 +27,7 @@ struct mmu_interval_notifier;
>>   * HMM_PFN_P2PDMA_BUS - Bus mapped P2P transfer
>>   * HMM_PFN_DMA_MAPPED - Flag preserved on input-to-output transformation
>>   *                      to mark that page is already DMA mapped
>> + * HMM_PFN_MIGRATE    - Migrate PTE installed
>>   *
>>   * On input:
>>   * 0                 - Return the current state of the page, do not fault it.
>> @@ -34,6 +35,7 @@ struct mmu_interval_notifier;
>>   *                     will fail
>>   * HMM_PFN_REQ_WRITE - The output must have HMM_PFN_WRITE or hmm_range_fault()
>>   *                     will fail. Must be combined with HMM_PFN_REQ_FAULT.
>> + * HMM_PFN_REQ_MIGRATE - For default_flags, request to migrate to device
>>   */
>>  enum hmm_pfn_flags {
>>  	/* Output fields and flags */
>> @@ -48,15 +50,25 @@ enum hmm_pfn_flags {
>>  	HMM_PFN_P2PDMA     = 1UL << (BITS_PER_LONG - 5),
>>  	HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
>>  
>> -	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 11),
>> +	/* Migrate request */
>> +	HMM_PFN_MIGRATE    = 1UL << (BITS_PER_LONG - 7),
>> +	HMM_PFN_COMPOUND   = 1UL << (BITS_PER_LONG - 8),
> Isn't HMM_PFN_COMPOUND implied by the ORDERS_SHIFT bits?

Not for holes, they are pfn = (HMM_PFN_VALID|HMM_PFN_MIGRATE|HMM_PFN_COMPOUND) for big hole.

>
>> +	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 13),
>>  
>>  	/* Input flags */
>>  	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
>>  	HMM_PFN_REQ_WRITE = HMM_PFN_WRITE,
>> +	HMM_PFN_REQ_MIGRATE = HMM_PFN_MIGRATE,
>>  
>>  	HMM_PFN_FLAGS = ~((1UL << HMM_PFN_ORDER_SHIFT) - 1),
>>  };
>>  
>> +enum {
>> +	/* These flags are carried from input-to-output */
>> +	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA |
>> +		HMM_PFN_P2PDMA_BUS,
>> +};
>> +
>>  /*
>>   * hmm_pfn_to_page() - return struct page pointed to by a device entry
>>   *
>> @@ -107,6 +119,7 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
>>   * @default_flags: default flags for the range (write, read, ... see hmm doc)
>>   * @pfn_flags_mask: allows to mask pfn flags so that only default_flags matter
>>   * @dev_private_owner: owner of device private pages
>> + * @migrate: structure for migrating the associated vma
>>   */
>>  struct hmm_range {
>>  	struct mmu_interval_notifier *notifier;
>> @@ -117,12 +130,14 @@ struct hmm_range {
>>  	unsigned long		default_flags;
>>  	unsigned long		pfn_flags_mask;
>>  	void			*dev_private_owner;
>> +	struct migrate_vma      *migrate;
>>  };
>>  
>>  /*
>>   * Please see Documentation/mm/hmm.rst for how to use the range API.
>>   */
>>  int hmm_range_fault(struct hmm_range *range);
>> +int hmm_range_migrate_prepare(struct hmm_range *range, struct migrate_vma **pargs);
>>  
>>  /*
>>   * HMM_RANGE_DEFAULT_TIMEOUT - default timeout (ms) when waiting for a range
>> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
>> index 26ca00c325d9..104eda2dd881 100644
>> --- a/include/linux/migrate.h
>> +++ b/include/linux/migrate.h
>> @@ -3,6 +3,7 @@
>>  #define _LINUX_MIGRATE_H
>>  
>>  #include <linux/mm.h>
>> +#include <linux/hmm.h>
>>  #include <linux/mempolicy.h>
>>  #include <linux/migrate_mode.h>
>>  #include <linux/hugetlb.h>
>> @@ -97,6 +98,16 @@ static inline int set_movable_ops(const struct movable_operations *ops, enum pag
>>  	return -ENOSYS;
>>  }
>>  
>> +enum migrate_vma_info {
>> +	MIGRATE_VMA_SELECT_NONE = 0,
>> +	MIGRATE_VMA_SELECT_COMPOUND = MIGRATE_VMA_SELECT_NONE,
>> +};
>> +
>> +static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
>> +{
>> +	return MIGRATE_VMA_SELECT_NONE;
>> +}
>> +
>>  #endif /* CONFIG_MIGRATION */
>>  
>>  #ifdef CONFIG_NUMA_BALANCING
>> @@ -140,11 +151,12 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
>>  	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
>>  }
>>  
>> -enum migrate_vma_direction {
>> +enum migrate_vma_info {
>>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
>>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
>>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
>>  	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
>> +	MIGRATE_VMA_FAULT = 1 << 4,
>>  };
>>  
>>  struct migrate_vma {
>> @@ -182,6 +194,17 @@ struct migrate_vma {
>>  	struct page		*fault_page;
>>  };
>>  
>> +static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
>> +{
>> +	enum migrate_vma_info minfo;
>> +
>> +	minfo = range->migrate ? range->migrate->flags : 0;
>> +	minfo |= (range->default_flags & HMM_PFN_REQ_MIGRATE) ?
>> +		MIGRATE_VMA_SELECT_SYSTEM : 0;
>> +
>> +	return minfo;
>> +}
>> +
>>  int migrate_vma_setup(struct migrate_vma *args);
>>  void migrate_vma_pages(struct migrate_vma *migrate);
>>  void migrate_vma_finalize(struct migrate_vma *migrate);
>> @@ -192,7 +215,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
>>  			unsigned long npages);
>>  void migrate_device_finalize(unsigned long *src_pfns,
>>  			unsigned long *dst_pfns, unsigned long npages);
>> -
>> +void migrate_hmm_range_setup(struct hmm_range *range);
>>  #endif /* CONFIG_MIGRATION */
>>  
>>  #endif /* _LINUX_MIGRATE_H */
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index a992f2203eb9..1b8778f34922 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -661,6 +661,7 @@ config MIGRATION
>>  
>>  config DEVICE_MIGRATION
>>  	def_bool MIGRATION && ZONE_DEVICE
>> +	select HMM_MIRROR
>>  
>>  config ARCH_ENABLE_HUGEPAGE_MIGRATION
>>  	bool
>> @@ -1236,6 +1237,7 @@ config ZONE_DEVICE
>>  config HMM_MIRROR
>>  	bool
>>  	depends on MMU
>> +	select MMU_NOTIFIER
>>  
>>  config GET_FREE_REGION
>>  	bool
>> diff --git a/mm/hmm.c b/mm/hmm.c
>> index 4ec74c18bef6..a53036c45ac5 100644
>> --- a/mm/hmm.c
>> +++ b/mm/hmm.c
>> @@ -20,6 +20,7 @@
>>  #include <linux/pagemap.h>
>>  #include <linux/leafops.h>
>>  #include <linux/hugetlb.h>
>> +#include <linux/migrate.h>
>>  #include <linux/memremap.h>
>>  #include <linux/sched/mm.h>
>>  #include <linux/jump_label.h>
>> @@ -27,35 +28,70 @@
>>  #include <linux/pci-p2pdma.h>
>>  #include <linux/mmu_notifier.h>
>>  #include <linux/memory_hotplug.h>
>> +#include <asm/tlbflush.h>
>>  
>>  #include "internal.h"
>>  
>>  struct hmm_vma_walk {
>> -	struct hmm_range	*range;
>> -	unsigned long		last;
>> +	struct mmu_notifier_range	mmu_range;
>> +	struct vm_area_struct		*vma;
>> +	struct hmm_range		*range;
>> +	unsigned long			start;
>> +	unsigned long			end;
>> +	unsigned long			last;
>> +	bool				ptelocked;
>> +	bool				pmdlocked;
>> +	spinlock_t			*ptl;
>>  };
> Could we get some comments on the fields and their usage?

Sure, will add.

>
>>  
>> +#define HMM_ASSERT_PTE_LOCKED(hmm_vma_walk, locked)		\
>> +		WARN_ON_ONCE(hmm_vma_walk->ptelocked != locked)
>> +
>> +#define HMM_ASSERT_PMD_LOCKED(hmm_vma_walk, locked)		\
>> +		WARN_ON_ONCE(hmm_vma_walk->pmdlocked != locked)
>> +
>> +#define HMM_ASSERT_UNLOCKED(hmm_vma_walk)		\
>> +		WARN_ON_ONCE(hmm_vma_walk->ptelocked ||	\
>> +			     hmm_vma_walk->pmdlocked)
>> +
>>  enum {
>>  	HMM_NEED_FAULT = 1 << 0,
>>  	HMM_NEED_WRITE_FAULT = 1 << 1,
>>  	HMM_NEED_ALL_BITS = HMM_NEED_FAULT | HMM_NEED_WRITE_FAULT,
>>  };
>>  
>> -enum {
>> -	/* These flags are carried from input-to-output */
>> -	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA |
>> -			      HMM_PFN_P2PDMA_BUS,
>> -};
>> -
>>  static int hmm_pfns_fill(unsigned long addr, unsigned long end,
>> -			 struct hmm_range *range, unsigned long cpu_flags)
>> +			 struct hmm_vma_walk *hmm_vma_walk, unsigned long cpu_flags)
>>  {
>> +	struct hmm_range *range = hmm_vma_walk->range;
>>  	unsigned long i = (addr - range->start) >> PAGE_SHIFT;
>> +	enum migrate_vma_info minfo;
>> +	bool migrate = false;
>> +
>> +	minfo = hmm_select_migrate(range);
>> +	if (cpu_flags != HMM_PFN_ERROR) {
>> +		if (minfo && (vma_is_anonymous(hmm_vma_walk->vma))) {
>> +			cpu_flags |= (HMM_PFN_VALID | HMM_PFN_MIGRATE);
>> +			migrate = true;
>> +		}
>> +	}
>> +
>> +	if (migrate && thp_migration_supported() &&
>> +	    (minfo & MIGRATE_VMA_SELECT_COMPOUND) &&
>> +	    IS_ALIGNED(addr, HPAGE_PMD_SIZE) &&
>> +	    IS_ALIGNED(end, HPAGE_PMD_SIZE)) {
>> +		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
>> +		range->hmm_pfns[i] |= cpu_flags | HMM_PFN_COMPOUND;
>> +		addr += PAGE_SIZE;
>> +		i++;
>> +		cpu_flags = 0;
>> +	}
>>  
>>  	for (; addr < end; addr += PAGE_SIZE, i++) {
>>  		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
>>  		range->hmm_pfns[i] |= cpu_flags;
>>  	}
>> +
>>  	return 0;
>>  }
>>  
>> @@ -78,6 +114,7 @@ static int hmm_vma_fault(unsigned long addr, unsigned long end,
>>  	unsigned int fault_flags = FAULT_FLAG_REMOTE;
>>  
>>  	WARN_ON_ONCE(!required_fault);
>> +	HMM_ASSERT_UNLOCKED(hmm_vma_walk);
>>  	hmm_vma_walk->last = addr;
>>  
>>  	if (required_fault & HMM_NEED_WRITE_FAULT) {
>> @@ -171,11 +208,11 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
>>  	if (!walk->vma) {
>>  		if (required_fault)
>>  			return -EFAULT;
>> -		return hmm_pfns_fill(addr, end, range, HMM_PFN_ERROR);
>> +		return hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
>>  	}
>>  	if (required_fault)
>>  		return hmm_vma_fault(addr, end, required_fault, walk);
>> -	return hmm_pfns_fill(addr, end, range, 0);
>> +	return hmm_pfns_fill(addr, end, hmm_vma_walk, 0);
>>  }
>>  
>>  static inline unsigned long hmm_pfn_flags_order(unsigned long order)
>> @@ -208,8 +245,13 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
>>  	cpu_flags = pmd_to_hmm_pfn_flags(range, pmd);
>>  	required_fault =
>>  		hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, cpu_flags);
>> -	if (required_fault)
>> +	if (required_fault) {
>> +		if (hmm_vma_walk->pmdlocked) {
>> +			spin_unlock(hmm_vma_walk->ptl);
>> +			hmm_vma_walk->pmdlocked = false;
> Could you explain why we need to now handle pmdlocked with some comments? We should also
> document any side-effects such as dropping a lock in the comments for the function

Yes, will add the comments.

>
>> +		}
>>  		return hmm_vma_fault(addr, end, required_fault, walk);
>> +	}
>>  
>>  	pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
>>  	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
>> @@ -289,14 +331,23 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>>  			goto fault;
>>  
>>  		if (softleaf_is_migration(entry)) {
>> -			pte_unmap(ptep);
>> -			hmm_vma_walk->last = addr;
>> -			migration_entry_wait(walk->mm, pmdp, addr);
>> -			return -EBUSY;
>> +			if (!hmm_select_migrate(range)) {
>> +				HMM_ASSERT_UNLOCKED(hmm_vma_walk);
>> +				hmm_vma_walk->last = addr;
>> +				migration_entry_wait(walk->mm, pmdp, addr);
>> +				return -EBUSY;
>> +			} else
>> +				goto out;
>>  		}
>>  
>>  		/* Report error for everything else */
>> -		pte_unmap(ptep);
>> +
>> +		if (hmm_vma_walk->ptelocked) {
>> +			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
>> +			hmm_vma_walk->ptelocked = false;
>> +		} else
>> +			pte_unmap(ptep);
>> +
>>  		return -EFAULT;
>>  	}
>>  
>> @@ -313,7 +364,12 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>>  	if (!vm_normal_page(walk->vma, addr, pte) &&
>>  	    !is_zero_pfn(pte_pfn(pte))) {
>>  		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
>> -			pte_unmap(ptep);
>> +			if (hmm_vma_walk->ptelocked) {
>> +				pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
>> +				hmm_vma_walk->ptelocked = false;
>> +			} else
>> +				pte_unmap(ptep);
>> +
>>  			return -EFAULT;
>>  		}
>>  		new_pfn_flags = HMM_PFN_ERROR;
>> @@ -326,7 +382,11 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>>  	return 0;
>>  
>>  fault:
>> -	pte_unmap(ptep);
>> +	if (hmm_vma_walk->ptelocked) {
>> +		pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
>> +		hmm_vma_walk->ptelocked = false;
>> +	} else
>> +		pte_unmap(ptep);
>>  	/* Fault any virtual address we were asked to fault */
>>  	return hmm_vma_fault(addr, end, required_fault, walk);
>>  }
>> @@ -370,13 +430,18 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>>  	required_fault = hmm_range_need_fault(hmm_vma_walk, hmm_pfns,
>>  					      npages, 0);
>>  	if (required_fault) {
>> -		if (softleaf_is_device_private(entry))
>> +		if (softleaf_is_device_private(entry)) {
>> +			if (hmm_vma_walk->pmdlocked) {
>> +				spin_unlock(hmm_vma_walk->ptl);
>> +				hmm_vma_walk->pmdlocked = false;
>> +			}
>>  			return hmm_vma_fault(addr, end, required_fault, walk);
>> +		}
>>  		else
>>  			return -EFAULT;
>>  	}
>>  
>> -	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
>> +	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>>  }
>>  #else
>>  static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>> @@ -384,15 +449,491 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>>  				     pmd_t pmd)
>>  {
>>  	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>> -	struct hmm_range *range = hmm_vma_walk->range;
>>  	unsigned long npages = (end - start) >> PAGE_SHIFT;
>>  
>>  	if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>>  		return -EFAULT;
>> -	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
>> +	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>>  }
>>  #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
>>  
>> +#ifdef CONFIG_DEVICE_MIGRATION
>> +/**
>> + * migrate_vma_split_folio() - Helper function to split a THP folio
>> + * @folio: the folio to split
>> + * @fault_page: struct page associated with the fault if any
>> + *
>> + * Returns 0 on success
>> + */
>> +static int migrate_vma_split_folio(struct folio *folio,
>> +				   struct page *fault_page)
>> +{
>> +	int ret;
>> +	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
>> +	struct folio *new_fault_folio = NULL;
>> +
>> +	if (folio != fault_folio) {
>> +		folio_get(folio);
>> +		folio_lock(folio);
>> +	}
>> +
>> +	ret = split_folio(folio);
>> +	if (ret) {
>> +		if (folio != fault_folio) {
>> +			folio_unlock(folio);
>> +			folio_put(folio);
>> +		}
>> +		return ret;
>> +	}
>> +
>> +	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
>> +
>> +	/*
>> +	 * Ensure the lock is held on the correct
>> +	 * folio after the split
>> +	 */
>> +	if (!new_fault_folio) {
>> +		folio_unlock(folio);
>> +		folio_put(folio);
>> +	} else if (folio != new_fault_folio) {
>> +		if (new_fault_folio != fault_folio) {
>> +			folio_get(new_fault_folio);
>> +			folio_lock(new_fault_folio);
>> +		}
>> +		folio_unlock(folio);
>> +		folio_put(folio);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
>> +					      pmd_t *pmdp,
>> +					      unsigned long start,
>> +					      unsigned long end,
>> +					      unsigned long *hmm_pfn)
>> +{
>> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>> +	struct hmm_range *range = hmm_vma_walk->range;
>> +	struct migrate_vma *migrate = range->migrate;
>> +	struct folio *fault_folio = NULL;
>> +	struct folio *folio;
>> +	enum migrate_vma_info minfo;
>> +	unsigned long i;
>> +	int r = 0;
>> +
>> +	minfo = hmm_select_migrate(range);
>> +	if (!minfo)
>> +		return r;
>> +
>> +	WARN_ON_ONCE(!migrate);
>> +	HMM_ASSERT_PMD_LOCKED(hmm_vma_walk, true);
>> +
>> +	fault_folio = migrate->fault_page ?
>> +		page_folio(migrate->fault_page) : NULL;
>> +
>> +	if (pmd_none(*pmdp))
>> +		return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
>> +
>> +	if (!(hmm_pfn[0] & HMM_PFN_VALID))
>> +		goto out;
>> +
>> +	if (pmd_trans_huge(*pmdp)) {
>> +		if (!(minfo & MIGRATE_VMA_SELECT_SYSTEM))
>> +			goto out;
>> +
>> +		folio = pmd_folio(*pmdp);
>> +		if (is_huge_zero_folio(folio))
>> +			return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
>> +
>> +	} else if (!pmd_present(*pmdp)) {
>> +		const softleaf_t entry = softleaf_from_pmd(*pmdp);
>> +
>> +		folio = softleaf_to_folio(entry);
>> +
>> +		if (!softleaf_is_device_private(entry))
>> +			goto out;
>> +
>> +		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
>> +			goto out;
>> +
>> +		if (folio->pgmap->owner != migrate->pgmap_owner)
>> +			goto out;
>> +
>> +	} else {
>> +		hmm_vma_walk->last = start;
>> +		return -EBUSY;
>> +	}
>> +
>> +	folio_get(folio);
>> +
>> +	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
>> +		folio_put(folio);
>> +		hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>> +		return 0;
>> +	}
>> +
>> +	if (thp_migration_supported() &&
>> +	    (migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
>> +	    (IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
>> +	     IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
>> +
>> +		struct page_vma_mapped_walk pvmw = {
>> +			.ptl = hmm_vma_walk->ptl,
>> +			.address = start,
>> +			.pmd = pmdp,
>> +			.vma = walk->vma,
>> +		};
>> +
>> +		hmm_pfn[0] |= HMM_PFN_MIGRATE | HMM_PFN_COMPOUND;
>> +
>> +		r = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
>> +		if (r) {
>> +			hmm_pfn[0] &= ~(HMM_PFN_MIGRATE | HMM_PFN_COMPOUND);
>> +			r = -ENOENT;  // fallback
>> +			goto unlock_out;
>> +		}
>> +		for (i = 1, start += PAGE_SIZE; start < end; start += PAGE_SIZE, i++)
>> +			hmm_pfn[i] &= HMM_PFN_INOUT_FLAGS;
>> +
>> +	} else {
>> +		r = -ENOENT;  // fallback
>> +		goto unlock_out;
>> +	}
>> +
>> +
>> +out:
>> +	return r;
>> +
>> +unlock_out:
>> +	if (folio != fault_folio)
>> +		folio_unlock(folio);
>> +	folio_put(folio);
>> +	goto out;
>> +
>> +}
>> +
> Are these just moved over from migrate_device.c?

Yes the migrate_prepare* functions are mostly the same as the migrate_device.c collect
ones. Difference being the pfns are populated by the handle_ functions with or without
faulting. Also small changes for the ptelock/pmdlock handling and context.

>
>> +/*
>> + * Install migration entries if migration requested, either from fault
>> + * or migrate paths.
>> + *
>> + */
>> +static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
>> +					  pmd_t *pmdp,
>> +					  pte_t *ptep,
>> +					  unsigned long addr,
>> +					  unsigned long *hmm_pfn)
>> +{
>> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>> +	struct hmm_range *range = hmm_vma_walk->range;
>> +	struct migrate_vma *migrate = range->migrate;
>> +	struct mm_struct *mm = walk->vma->vm_mm;
>> +	struct folio *fault_folio = NULL;
>> +	enum migrate_vma_info minfo;
>> +	struct dev_pagemap *pgmap;
>> +	bool anon_exclusive;
>> +	struct folio *folio;
>> +	unsigned long pfn;
>> +	struct page *page;
>> +	softleaf_t entry;
>> +	pte_t pte, swp_pte;
>> +	bool writable = false;
>> +
>> +	// Do we want to migrate at all?
>> +	minfo = hmm_select_migrate(range);
>> +	if (!minfo)
>> +		return 0;
>> +
>> +	WARN_ON_ONCE(!migrate);
>> +	HMM_ASSERT_PTE_LOCKED(hmm_vma_walk, true);
>> +
>> +	fault_folio = migrate->fault_page ?
>> +		page_folio(migrate->fault_page) : NULL;
>> +
>> +	pte = ptep_get(ptep);
>> +
>> +	if (pte_none(pte)) {
>> +		// migrate without faulting case
>> +		if (vma_is_anonymous(walk->vma)) {
>> +			*hmm_pfn &= HMM_PFN_INOUT_FLAGS;
>> +			*hmm_pfn |= HMM_PFN_MIGRATE | HMM_PFN_VALID;
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	if (!(hmm_pfn[0] & HMM_PFN_VALID))
>> +		goto out;
>> +
>> +	if (!pte_present(pte)) {
>> +		/*
>> +		 * Only care about unaddressable device page special
>> +		 * page table entry. Other special swap entries are not
>> +		 * migratable, and we ignore regular swapped page.
>> +		 */
>> +		entry = softleaf_from_pte(pte);
>> +		if (!softleaf_is_device_private(entry))
>> +			goto out;
>> +
>> +		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
>> +			goto out;
>> +
>> +		page = softleaf_to_page(entry);
>> +		folio = page_folio(page);
>> +		if (folio->pgmap->owner != migrate->pgmap_owner)
>> +			goto out;
>> +
>> +		if (folio_test_large(folio)) {
>> +			int ret;
>> +
>> +			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
>> +			hmm_vma_walk->ptelocked = false;
>> +			ret = migrate_vma_split_folio(folio,
>> +						      migrate->fault_page);
>> +			if (ret)
>> +				goto out_error;
>> +			return -EAGAIN;
>> +		}
>> +
>> +		pfn = page_to_pfn(page);
>> +		if (softleaf_is_device_private_write(entry))
>> +			writable = true;
>> +	} else {
>> +		pfn = pte_pfn(pte);
>> +		if (is_zero_pfn(pfn) &&
>> +		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
>> +			*hmm_pfn = HMM_PFN_MIGRATE|HMM_PFN_VALID;
>> +			goto out;
>> +		}
>> +		page = vm_normal_page(walk->vma, addr, pte);
>> +		if (page && !is_zone_device_page(page) &&
>> +		    !(minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
>> +			goto out;
>> +		} else if (page && is_device_coherent_page(page)) {
>> +			pgmap = page_pgmap(page);
>> +
>> +			if (!(minfo &
>> +			      MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
>> +			    pgmap->owner != migrate->pgmap_owner)
>> +				goto out;
>> +		}
>> +
>> +		folio = page ? page_folio(page) : NULL;
>> +		if (folio && folio_test_large(folio)) {
>> +			int ret;
>> +
>> +			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
>> +			hmm_vma_walk->ptelocked = false;
>> +
>> +			ret = migrate_vma_split_folio(folio,
>> +						      migrate->fault_page);
>> +			if (ret)
>> +				goto out_error;
>> +			return -EAGAIN;
>> +		}
>> +
>> +		writable = pte_write(pte);
>> +	}
>> +
>> +	if (!page || !page->mapping)
>> +		goto out;
>> +
>> +	/*
>> +	 * By getting a reference on the folio we pin it and that blocks
>> +	 * any kind of migration. Side effect is that it "freezes" the
>> +	 * pte.
>> +	 *
>> +	 * We drop this reference after isolating the folio from the lru
>> +	 * for non device folio (device folio are not on the lru and thus
>> +	 * can't be dropped from it).
>> +	 */
>> +	folio = page_folio(page);
>> +	folio_get(folio);
>> +
>> +	/*
>> +	 * We rely on folio_trylock() to avoid deadlock between
>> +	 * concurrent migrations where each is waiting on the others
>> +	 * folio lock. If we can't immediately lock the folio we fail this
>> +	 * migration as it is only best effort anyway.
>> +	 *
>> +	 * If we can lock the folio it's safe to set up a migration entry
>> +	 * now. In the common case where the folio is mapped once in a
>> +	 * single process setting up the migration entry now is an
>> +	 * optimisation to avoid walking the rmap later with
>> +	 * try_to_migrate().
>> +	 */
>> +
>> +	if (fault_folio == folio || folio_trylock(folio)) {
>> +		anon_exclusive = folio_test_anon(folio) &&
>> +			PageAnonExclusive(page);
>> +
>> +		flush_cache_page(walk->vma, addr, pfn);
>> +
>> +		if (anon_exclusive) {
>> +			pte = ptep_clear_flush(walk->vma, addr, ptep);
>> +
>> +			if (folio_try_share_anon_rmap_pte(folio, page)) {
>> +				set_pte_at(mm, addr, ptep, pte);
>> +				folio_unlock(folio);
>> +				folio_put(folio);
>> +				goto out;
>> +			}
>> +		} else {
>> +			pte = ptep_get_and_clear(mm, addr, ptep);
>> +		}
>> +
>> +		if (pte_dirty(pte))
>> +			folio_mark_dirty(folio);
>> +
>> +		/* Setup special migration page table entry */
>> +		if (writable)
>> +			entry = make_writable_migration_entry(pfn);
>> +		else if (anon_exclusive)
>> +			entry = make_readable_exclusive_migration_entry(pfn);
>> +		else
>> +			entry = make_readable_migration_entry(pfn);
>> +
>> +		if (pte_present(pte)) {
>> +			if (pte_young(pte))
>> +				entry = make_migration_entry_young(entry);
>> +			if (pte_dirty(pte))
>> +				entry = make_migration_entry_dirty(entry);
>> +		}
>> +
>> +		swp_pte = swp_entry_to_pte(entry);
>> +		if (pte_present(pte)) {
>> +			if (pte_soft_dirty(pte))
>> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
>> +			if (pte_uffd_wp(pte))
>> +				swp_pte = pte_swp_mkuffd_wp(swp_pte);
>> +		} else {
>> +			if (pte_swp_soft_dirty(pte))
>> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
>> +			if (pte_swp_uffd_wp(pte))
>> +				swp_pte = pte_swp_mkuffd_wp(swp_pte);
>> +		}
>> +
>> +		set_pte_at(mm, addr, ptep, swp_pte);
>> +		folio_remove_rmap_pte(folio, page, walk->vma);
>> +		folio_put(folio);
>> +		*hmm_pfn |= HMM_PFN_MIGRATE;
>> +
>> +		if (pte_present(pte))
>> +			flush_tlb_range(walk->vma, addr, addr + PAGE_SIZE);
>> +	} else
>> +		folio_put(folio);
>> +out:
>> +	return 0;
>> +out_error:
>> +	return -EFAULT;
>> +
>> +}
>> +
>> +static int hmm_vma_walk_split(pmd_t *pmdp,
>> +			      unsigned long addr,
>> +			      struct mm_walk *walk)
>> +{
>> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>> +	struct hmm_range *range = hmm_vma_walk->range;
>> +	struct migrate_vma *migrate = range->migrate;
>> +	struct folio *folio, *fault_folio;
>> +	spinlock_t *ptl;
>> +	int ret = 0;
>> +
>> +	HMM_ASSERT_UNLOCKED(hmm_vma_walk);
>> +
>> +	fault_folio = (migrate && migrate->fault_page) ?
>> +		page_folio(migrate->fault_page) : NULL;
>> +
>> +	ptl = pmd_lock(walk->mm, pmdp);
>> +	if (unlikely(!pmd_trans_huge(*pmdp))) {
>> +		spin_unlock(ptl);
>> +		goto out;
>> +	}
>> +
>> +	folio = pmd_folio(*pmdp);
>> +	if (is_huge_zero_folio(folio)) {
>> +		spin_unlock(ptl);
>> +		split_huge_pmd(walk->vma, pmdp, addr);
>> +	} else {
>> +		folio_get(folio);
>> +		spin_unlock(ptl);
>> +
>> +		if (folio != fault_folio) {
>> +			if (unlikely(!folio_trylock(folio))) {
>> +				folio_put(folio);
>> +				ret = -EBUSY;
>> +				goto out;
>> +			}
>> +		}  else
>> +			folio_put(folio);
>> +
>> +		ret = split_folio(folio);
>> +		if (fault_folio != folio) {
>> +			folio_unlock(folio);
>> +			folio_put(folio);
>> +		}
>> +
>> +	}
>> +out:
>> +	return ret;
>> +}
>> +#else
>> +static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
>> +					      pmd_t *pmdp,
>> +					      unsigned long start,
>> +					      unsigned long end,
>> +					      unsigned long *hmm_pfn)
>> +{
>> +	return 0;
>> +}
>> +
>> +static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
>> +					  pmd_t *pmdp,
>> +					  pte_t *pte,
>> +					  unsigned long addr,
>> +					  unsigned long *hmm_pfn)
>> +{
>> +	return 0;
>> +}
>> +
>> +static int hmm_vma_walk_split(pmd_t *pmdp,
>> +			      unsigned long addr,
>> +			      struct mm_walk *walk)
>> +{
>> +	return 0;
>> +}
>> +#endif
>> +
>> +static int hmm_vma_capture_migrate_range(unsigned long start,
>> +					 unsigned long end,
>> +					 struct mm_walk *walk)
>> +{
>> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>> +	struct hmm_range *range = hmm_vma_walk->range;
>> +
>> +	if (!hmm_select_migrate(range))
>> +		return 0;
>> +
>> +	if (hmm_vma_walk->vma && (hmm_vma_walk->vma != walk->vma))
>> +		return -ERANGE;
>> +
>> +	hmm_vma_walk->vma = walk->vma;
>> +	hmm_vma_walk->start = start;
>> +	hmm_vma_walk->end = end;
>> +
>> +	if (end - start > range->end - range->start)
>> +		return -ERANGE;
>> +
>> +	if (!hmm_vma_walk->mmu_range.owner) {
>> +		mmu_notifier_range_init_owner(&hmm_vma_walk->mmu_range, MMU_NOTIFY_MIGRATE, 0,
>> +					      walk->vma->vm_mm, start, end,
>> +					      range->dev_private_owner);
>> +		mmu_notifier_invalidate_range_start(&hmm_vma_walk->mmu_range);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  static int hmm_vma_walk_pmd(pmd_t *pmdp,
>>  			    unsigned long start,
>>  			    unsigned long end,
>> @@ -403,43 +944,125 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>>  	unsigned long *hmm_pfns =
>>  		&range->hmm_pfns[(start - range->start) >> PAGE_SHIFT];
>>  	unsigned long npages = (end - start) >> PAGE_SHIFT;
>> +	struct mm_struct *mm = walk->vma->vm_mm;
>>  	unsigned long addr = start;
>> +	enum migrate_vma_info minfo;
>> +	unsigned long i;
>>  	pte_t *ptep;
>>  	pmd_t pmd;
>> +	int r = 0;
>> +
>> +	minfo = hmm_select_migrate(range);
>>  
>>  again:
>> -	pmd = pmdp_get_lockless(pmdp);
>> -	if (pmd_none(pmd))
>> -		return hmm_vma_walk_hole(start, end, -1, walk);
>> +	hmm_vma_walk->ptelocked = false;
>> +	hmm_vma_walk->pmdlocked = false;
>> +
>> +	if (minfo) {
>> +		hmm_vma_walk->ptl = pmd_lock(mm, pmdp);
>> +		hmm_vma_walk->pmdlocked = true;
>> +		pmd = pmdp_get(pmdp);
>> +	} else
>> +		pmd = pmdp_get_lockless(pmdp);
>> +
>> +	if (pmd_none(pmd)) {
>> +		r = hmm_vma_walk_hole(start, end, -1, walk);
>> +
>> +		if (hmm_vma_walk->pmdlocked) {
>> +			spin_unlock(hmm_vma_walk->ptl);
>> +			hmm_vma_walk->pmdlocked = false;
>> +		}
>> +		return r;
>> +	}
>>  
>>  	if (thp_migration_supported() && pmd_is_migration_entry(pmd)) {
>> -		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
>> +		if (!minfo) {
>> +			if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
>> +				hmm_vma_walk->last = addr;
>> +				pmd_migration_entry_wait(walk->mm, pmdp);
>> +				return -EBUSY;
>> +			}
>> +		}
>> +		for (i = 0; addr < end; addr += PAGE_SIZE, i++)
>> +			hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
>> +
>> +		if (hmm_vma_walk->pmdlocked) {
>> +			spin_unlock(hmm_vma_walk->ptl);
>> +			hmm_vma_walk->pmdlocked = false;
>> +		}
>> +
>> +		return 0;
>> +	}
>> +
>> +	if (pmd_trans_huge(pmd) || !pmd_present(pmd)) {
>> +
>> +		if (!pmd_present(pmd)) {
>> +			r = hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
>> +						      pmd);
>> +			// If not migrating we are done
>> +			if (r || !minfo) {
>> +				if (hmm_vma_walk->pmdlocked) {
>> +					spin_unlock(hmm_vma_walk->ptl);
>> +					hmm_vma_walk->pmdlocked = false;
>> +				}
>> +				return r;
>> +			}
>> +		} else {
>> +
>> +			/*
>> +			 * No need to take pmd_lock here if not migrating,
>> +			 * even if some other thread is splitting the huge
>> +			 * pmd we will get that event through mmu_notifier callback.
>> +			 *
>> +			 * So just read pmd value and check again it's a transparent
>> +			 * huge or device mapping one and compute corresponding pfn
>> +			 * values.
>> +			 */
>> +
>> +			if (!minfo) {
>> +				pmd = pmdp_get_lockless(pmdp);
>> +				if (!pmd_trans_huge(pmd))
>> +					goto again;
>> +			}
>> +
>> +			r = hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
>> +
>> +			// If not migrating we are done
>> +			if (r || !minfo) {
>> +				if (hmm_vma_walk->pmdlocked) {
>> +					spin_unlock(hmm_vma_walk->ptl);
>> +					hmm_vma_walk->pmdlocked = false;
>> +				}
>> +				return r;
>> +			}
>> +		}
>> +
>> +		r = hmm_vma_handle_migrate_prepare_pmd(walk, pmdp, start, end, hmm_pfns);
>> +
>> +		if (hmm_vma_walk->pmdlocked) {
>> +			spin_unlock(hmm_vma_walk->ptl);
>> +			hmm_vma_walk->pmdlocked = false;
>> +		}
>> +
>> +		if (r == -ENOENT) {
>> +			r = hmm_vma_walk_split(pmdp, addr, walk);
>> +			if (r) {
>> +				/* Split not successful, skip */
>> +				return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>> +			}
>> +
>> +			/* Split successful or "again", reloop */
>>  			hmm_vma_walk->last = addr;
>> -			pmd_migration_entry_wait(walk->mm, pmdp);
>>  			return -EBUSY;
>>  		}
>> -		return hmm_pfns_fill(start, end, range, 0);
>> -	}
>>  
>> -	if (!pmd_present(pmd))
>> -		return hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
>> -						 pmd);
>> +		return r;
>>  
>> -	if (pmd_trans_huge(pmd)) {
>> -		/*
>> -		 * No need to take pmd_lock here, even if some other thread
>> -		 * is splitting the huge pmd we will get that event through
>> -		 * mmu_notifier callback.
>> -		 *
>> -		 * So just read pmd value and check again it's a transparent
>> -		 * huge or device mapping one and compute corresponding pfn
>> -		 * values.
>> -		 */
>> -		pmd = pmdp_get_lockless(pmdp);
>> -		if (!pmd_trans_huge(pmd))
>> -			goto again;
>> +	}
>>  
>> -		return hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
>> +	if (hmm_vma_walk->pmdlocked) {
>> +		spin_unlock(hmm_vma_walk->ptl);
>> +		hmm_vma_walk->pmdlocked = false;
>>  	}
>>  
>>  	/*
>> @@ -451,22 +1074,43 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>>  	if (pmd_bad(pmd)) {
>>  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>>  			return -EFAULT;
>> -		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
>> +		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>>  	}
>>  
>> -	ptep = pte_offset_map(pmdp, addr);
>> +	if (minfo) {
>> +		ptep = pte_offset_map_lock(mm, pmdp, addr, &hmm_vma_walk->ptl);
>> +		if (ptep)
>> +			hmm_vma_walk->ptelocked = true;
>> +	} else
>> +		ptep = pte_offset_map(pmdp, addr);
>>  	if (!ptep)
>>  		goto again;
>> +
>>  	for (; addr < end; addr += PAGE_SIZE, ptep++, hmm_pfns++) {
>> -		int r;
>>  
>>  		r = hmm_vma_handle_pte(walk, addr, end, pmdp, ptep, hmm_pfns);
>>  		if (r) {
>> -			/* hmm_vma_handle_pte() did pte_unmap() */
>> +			/* hmm_vma_handle_pte() did pte_unmap() / pte_unmap_unlock */
>>  			return r;
>>  		}
>> +
>> +		r = hmm_vma_handle_migrate_prepare(walk, pmdp, ptep, addr, hmm_pfns);
>> +		if (r == -EAGAIN) {
>> +			HMM_ASSERT_UNLOCKED(hmm_vma_walk);
>> +			goto again;
>> +		}
>> +		if (r) {
>> +			hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
>> +			break;
>> +		}
>>  	}
>> -	pte_unmap(ptep - 1);
>> +
>> +	if (hmm_vma_walk->ptelocked) {
>> +		pte_unmap_unlock(ptep - 1, hmm_vma_walk->ptl);
>> +		hmm_vma_walk->ptelocked = false;
>> +	} else
>> +		pte_unmap(ptep - 1);
>> +
>>  	return 0;
>>  }
>>  
>> @@ -600,6 +1244,11 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>>  	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>>  	struct hmm_range *range = hmm_vma_walk->range;
>>  	struct vm_area_struct *vma = walk->vma;
>> +	int r;
>> +
>> +	r = hmm_vma_capture_migrate_range(start, end, walk);
>> +	if (r)
>> +		return r;
>>  
>>  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
>>  	    vma->vm_flags & VM_READ)
>> @@ -622,7 +1271,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>>  				 (end - start) >> PAGE_SHIFT, 0))
>>  		return -EFAULT;
>>  
>> -	hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
>> +	hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
>>  
>>  	/* Skip this vma and continue processing the next vma. */
>>  	return 1;
>> @@ -652,9 +1301,17 @@ static const struct mm_walk_ops hmm_walk_ops = {
>>   *		the invalidation to finish.
>>   * -EFAULT:     A page was requested to be valid and could not be made valid
>>   *              ie it has no backing VMA or it is illegal to access
>> + * -ERANGE:     The range crosses multiple VMAs, or space for hmm_pfns array
>> + *              is too low.
>>   *
>>   * This is similar to get_user_pages(), except that it can read the page tables
>>   * without mutating them (ie causing faults).
>> + *
>> + * If want to do migrate after faulting, call hmm_range_fault() with
>> + * HMM_PFN_REQ_MIGRATE and initialize range.migrate field.
>> + * After hmm_range_fault() call migrate_hmm_range_setup() instead of
>> + * migrate_vma_setup() and after that follow normal migrate calls path.
>> + *
>>   */
>>  int hmm_range_fault(struct hmm_range *range)
>>  {
>> @@ -662,16 +1319,34 @@ int hmm_range_fault(struct hmm_range *range)
>>  		.range = range,
>>  		.last = range->start,
>>  	};
>> -	struct mm_struct *mm = range->notifier->mm;
>> +	struct mm_struct *mm;
>> +	bool is_fault_path;
>>  	int ret;
>>  
>> +	/*
>> +	 *
>> +	 *  Could be serving a device fault or come from migrate
>> +	 *  entry point. For the former we have not resolved the vma
>> +	 *  yet, and the latter we don't have a notifier (but have a vma).
>> +	 *
>> +	 */
>> +#ifdef CONFIG_DEVICE_MIGRATION
>> +	is_fault_path = !!range->notifier;
>> +	mm = is_fault_path ? range->notifier->mm : range->migrate->vma->vm_mm;
>> +#else
>> +	is_fault_path = true;
>> +	mm = range->notifier->mm;
>> +#endif
>>  	mmap_assert_locked(mm);
>>  
>>  	do {
>>  		/* If range is no longer valid force retry. */
>> -		if (mmu_interval_check_retry(range->notifier,
>> -					     range->notifier_seq))
>> -			return -EBUSY;
>> +		if (is_fault_path && mmu_interval_check_retry(range->notifier,
>> +					     range->notifier_seq)) {
>> +			ret = -EBUSY;
>> +			break;
>> +		}
>> +
>>  		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
>>  				      &hmm_walk_ops, &hmm_vma_walk);
>>  		/*
>> @@ -681,6 +1356,19 @@ int hmm_range_fault(struct hmm_range *range)
>>  		 * output, and all >= are still at their input values.
>>  		 */
>>  	} while (ret == -EBUSY);
>> +
>> +#ifdef CONFIG_DEVICE_MIGRATION
>> +	if (hmm_select_migrate(range) && range->migrate &&
>> +	    hmm_vma_walk.mmu_range.owner) {
>> +		// The migrate_vma path has the following initialized
>> +		if (is_fault_path) {
>> +			range->migrate->vma   = hmm_vma_walk.vma;
>> +			range->migrate->start = range->start;
>> +			range->migrate->end   = hmm_vma_walk.end;
>> +		}
>> +		mmu_notifier_invalidate_range_end(&hmm_vma_walk.mmu_range);
>> +	}
>> +#endif
>>  	return ret;
>>  }
>>  EXPORT_SYMBOL(hmm_range_fault);
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 23379663b1e1..bda6320f6242 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -734,7 +734,16 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
>>   */
>>  int migrate_vma_setup(struct migrate_vma *args)
>>  {
>> +	int ret;
>>  	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
>> +	struct hmm_range range = {
>> +		.notifier = NULL,
>> +		.start = args->start,
>> +		.end = args->end,
>> +		.hmm_pfns = args->src,
>> +		.dev_private_owner = args->pgmap_owner,
>> +		.migrate = args
>> +	};
>>  
>>  	args->start &= PAGE_MASK;
>>  	args->end &= PAGE_MASK;
>> @@ -759,17 +768,25 @@ int migrate_vma_setup(struct migrate_vma *args)
>>  	args->cpages = 0;
>>  	args->npages = 0;
>>  
>> -	migrate_vma_collect(args);
>> +	if (args->flags & MIGRATE_VMA_FAULT)
>> +		range.default_flags |= HMM_PFN_REQ_FAULT;
>> +
>> +	ret = hmm_range_fault(&range);
>> +
>> +	migrate_hmm_range_setup(&range);
>>  
>> -	if (args->cpages)
>> -		migrate_vma_unmap(args);
>> +	/* Remove migration PTEs */
>> +	if (ret) {
>> +		migrate_vma_pages(args);
>> +		migrate_vma_finalize(args);
>> +	}
>>  
>>  	/*
>>  	 * At this point pages are locked and unmapped, and thus they have
>>  	 * stable content and can safely be copied to destination memory that
>>  	 * is allocated by the drivers.
>>  	 */
>> -	return 0;
>> +	return ret;
>>  
>>  }
>>  EXPORT_SYMBOL(migrate_vma_setup);
>> @@ -1489,3 +1506,64 @@ int migrate_device_coherent_folio(struct folio *folio)
>>  		return 0;
>>  	return -EBUSY;
>>  }
>> +
>> +void migrate_hmm_range_setup(struct hmm_range *range)
>> +{
>> +
>> +	struct migrate_vma *migrate = range->migrate;
>> +
>> +	if (!migrate)
>> +		return;
>> +
>> +	migrate->npages = (migrate->end - migrate->start) >> PAGE_SHIFT;
>> +	migrate->cpages = 0;
>> +
>> +	for (unsigned long i = 0; i < migrate->npages; i++) {
>> +
>> +		unsigned long pfn = range->hmm_pfns[i];
>> +
>> +		pfn &= ~HMM_PFN_INOUT_FLAGS;
>> +
>> +		/*
>> +		 *
>> +		 *  Don't do migration if valid and migrate flags are not both set.
>> +		 *
>> +		 */
>> +		if ((pfn & (HMM_PFN_VALID | HMM_PFN_MIGRATE)) !=
>> +		    (HMM_PFN_VALID | HMM_PFN_MIGRATE)) {
>> +			migrate->src[i] = 0;
>> +			migrate->dst[i] = 0;
>> +			continue;
>> +		}
>> +
>> +		migrate->cpages++;
>> +
>> +		/*
>> +		 *
>> +		 * The zero page is encoded in a special way, valid and migrate is
>> +		 * set, and pfn part is zero. Encode specially for migrate also.
>> +		 *
>> +		 */
>> +		if (pfn == (HMM_PFN_VALID|HMM_PFN_MIGRATE)) {
>> +			migrate->src[i] = MIGRATE_PFN_MIGRATE;
>> +			migrate->dst[i] = 0;
>> +			continue;
>> +		}
>> +		if (pfn == (HMM_PFN_VALID|HMM_PFN_MIGRATE|HMM_PFN_COMPOUND)) {
>> +			migrate->src[i] = MIGRATE_PFN_MIGRATE|MIGRATE_PFN_COMPOUND;
>> +			migrate->dst[i] = 0;
>> +			continue;
>> +		}
>> +
>> +		migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn)))
>> +			| MIGRATE_PFN_MIGRATE;
>> +		migrate->src[i] |= (pfn & HMM_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
>> +		migrate->src[i] |= (pfn & HMM_PFN_COMPOUND) ? MIGRATE_PFN_COMPOUND : 0;
>> +		migrate->dst[i] = 0;
>> +	}
>> +
>> +	if (migrate->cpages)
>> +		migrate_vma_unmap(migrate);
>> +
>> +}
>> +EXPORT_SYMBOL(migrate_hmm_range_setup);
>
>
> This is too big a change for a single patch, most of it seems straightforward as we've merged
> HMM and device_migration paths, but could you consider simplifying this into smaller patches?

It might be hard to meaningfully divide it as big part of it is re-locating the collect functions
to a new context. But sure there is something that can be taken apart.

>
> Thanks,
> Balbir
>
Thanks!
Mika


