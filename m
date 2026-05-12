Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2FF2CD4F35
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 12:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 631756B008A; Tue, 12 May 2026 08:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E1BF6B008C; Tue, 12 May 2026 08:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D04A6B0092; Tue, 12 May 2026 08:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 362FB6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:08:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D91461A047D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:08:28 +0000 (UTC)
X-FDA: 84758645496.20.57E01BD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 818004000F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:08:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fOgjKmYQ;
	spf=pass (imf27.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778587706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXH5HtvUwwvubt7XZZtwSLlnbyrqCuGNkjWnyw6B3Tw=;
	b=zT/tKy54yr3NUJ9bQCP4XoK2zXje2JnYZDaxUS5cRsjHInvN8EGkQMxkJqll1rtsSy1zOM
	zy94TDcpO3aPZLlCtJ1OsqWjGMmd392+i35F5czeUaSKP71l4qFuXFeuVu3qLOpdCko8yJ
	3m1OmxGSFvy3b5YHkl3SYYZuF1l5bU4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fOgjKmYQ;
	spf=pass (imf27.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778587706; a=rsa-sha256;
	cv=none;
	b=3IO6E3N3d3DkZD5vYoiKq+csMsK+hejTdwRYREaojC9485sqQ6uPAdPcdD/FlAAcPjD55j
	BmUAkd3fM5a2CTfRM61a/wY7pJazWDnv0urfZ1QT1Dy1PXjRedt7R/InF3OkRnbz6bd8GG
	apngY0Tm8j8lEEHY+OKAbFdMD0LY/wo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778587705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dXH5HtvUwwvubt7XZZtwSLlnbyrqCuGNkjWnyw6B3Tw=;
	b=fOgjKmYQzyaKUCAJ2UfHXSZJyQ54ALvWtsIL0ExDvOhToBSrFQZO5wM9OmJrCGxH9X7s0U
	0rHg7shJqhzyUE1XB/e4i/z8UNeQWVMAXgHUH8LS4AAfnqq5Yb/cIXYmkX+1ClpBbhVEkv
	Ol3PBl2+znQ4kOAFsp9UQp62BshlmJo=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-a5QGWGd8N_yo9DDxuOvfwg-1; Tue, 12 May 2026 08:08:23 -0400
X-MC-Unique: a5QGWGd8N_yo9DDxuOvfwg-1
X-Mimecast-MFC-AGG-ID: a5QGWGd8N_yo9DDxuOvfwg_1778587702
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-393c9ff86c8so22821031fa.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 05:08:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778587702; x=1779192502;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dXH5HtvUwwvubt7XZZtwSLlnbyrqCuGNkjWnyw6B3Tw=;
        b=o+ZWF7p5S9DBdVMekyTXyYqLLCHWvL1PTVzisDhPl7aIEvk/b8LpPmbzOzAn7pAFsj
         f7zY8bbqwNeHpUfhtXgbs81frGm3IM2e80EwZ5Tskrm/86nZjgLmPydOLCABH/Ux62Af
         dK4QhRYlQzMNreZTGxC+N3Ssshe+0ubtXK3NzSkHDE5lB+Y/l/f0rX24Q1OGSa9F9RxP
         3YM+ox3Rpan8ALSUsVorGCrMGplLlbOUbyyRnBxpYVEE1R5ISebgDQpmcfQev4T5ieqX
         1v/kffUnKFY0bvX8nMLwHnp30ExGcIygytgyx3J4q3kACXDLRNdCsRO03K45acSnIgq5
         /6TA==
X-Forwarded-Encrypted: i=1; AFNElJ85MOpWOwl89qjTDfUyiM+gDtm1VqjZGwo5cTissSnr7ewJx1uTtlL7nxbphhgvajllhGBE05cBKA==@kvack.org
X-Gm-Message-State: AOJu0Yz+HRUri5eCl53v+8iXvk7IFq7hmLRACEqytq1qrRJzis7X34bs
	Owu2tgO3bJ7pDHAyP+Ug0SsRm/9XiElUP/m+mZ9lX5lPBjlubjJJEOJcOjZ5JvUJnE5D2+yQaMz
	shR7Wjh3HCbaJ33GllG9Vy6ZSf3e3aMseBg3mnFgOExePqbFsj6E=
X-Gm-Gg: Acq92OFkv52loGbm7s64AXJGvQoOKxBZoGdl0hkoBLUZlJjgomms3PB8Jcf9Z61X2TZ
	bjMx8toIxeu70123ELtg/1iUfYFMFkqsA+mNHo4VpfDbtF2bAYDm9wmxbk5nAsBjxx2tgTwgZIm
	hqEcn5N+1BZQLZfvH0gbrx9aBCczpbXahUlhZ7lCbZrwhsejqvzNQLVj4PQHrNQTI/q4B5BRB+r
	Fq9uiULkPOiNhZm14xH/VsRxTd3Hq5vSPdM5vBrnAACqAOd6F+3tV39JI951w3aVHUQjoFWJI7l
	DCaOrKBEIKWH+3s62owr/UM5/Iq7dUUjjmiELVubw6ZSbXHorfAWoIgCFJnPjvjAQX4Xl5It2x1
	TQB4x40piaFht5s+EQshTcy7SEj3kcWD+eDDerdsrmTjSm6s=
X-Received: by 2002:a05:6512:1281:b0:5a8:cdd8:1eb0 with SMTP id 2adb3069b0e04-5a8cdd81ed5mr2576292e87.1.1778587702187;
        Tue, 12 May 2026 05:08:22 -0700 (PDT)
X-Received: by 2002:a05:6512:1281:b0:5a8:cdd8:1eb0 with SMTP id 2adb3069b0e04-5a8cdd81ed5mr2576269e87.1.1778587701675;
        Tue, 12 May 2026 05:08:21 -0700 (PDT)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a8a95661aasm3290978e87.68.2026.05.12.05.08.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 05:08:21 -0700 (PDT)
Message-ID: <7e3abb7c-c57d-419a-969a-fcd150ccca99@redhat.com>
Date: Tue, 12 May 2026 15:08:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/5] mm: Add helper to convert HMM pfn to migrate pfn
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260505184421.2324798-1-mpenttil@redhat.com>
 <20260505184421.2324798-3-mpenttil@redhat.com>
 <4a9c4170-c6b7-424c-969c-19240f07e46b@kernel.org>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <4a9c4170-c6b7-424c-969c-19240f07e46b@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5VCPmSs5cqUjnOiLsPx8b1I_pdqSAMMXuGB6AdbeRQE_1778587702
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 818004000F
X-Rspamd-Server: rspam06
X-Stat-Signature: n8pqjb3hux9gmb56rttwmcs3rkcdz71p
X-HE-Tag: 1778587706-537101
X-HE-Meta: U2FsdGVkX1+ZqsUZ99XxAhEi+iQ4vwagHPy8SQ8dYmNIw+QqzShG+vpWexnjgr6lW/z1VF4LCe35ovkfxZGk0o9F3r3VEjQLc2PFbSO7MiavOyhObVI8j89bVau4BOqFhJ6Bi0lFD72yDDvpoT4Kxv9ciH70OqRIl6O8GjAzx3bE2cLA1oOo6Zewxoi8NFt9BQ+jJJdaAwZOge1Vwq4TtIUWTJU/UmFj3xEyZvB9YAWUxtj9dXlLL2TXlQPeihsrxWvXjBkz2Hi1ovVc5RIu7nHtlqP8ksLDKoxk5p9KcjmVVU3Nec/NCTNunM9lNTpipfK7DSZpCUDmujXqrFXvBjKOmVtqBSoB8rs69rD/QiallMrM8xL4jmRttQAxJsMnsNn6cFe167M6Ajeb9mzM9XZIXI71xh+HvEa0DVhMgXOUB4iP+yrIa6O2Patjpz7XXhWnKKtRZ6IBSw1eZZ5Pfb8hAZV1KJcBIGyfW56/yGCtFVrh35+OIFlitMM1P8IkBMINA6F8v7B9rr7saZum38Lru611U6YDcqgWG9U3Y9u78RaTa09/h2/hNvIvBu4dtA3A/DplzWC4lDkbHnhGAS+2v8U3Hua69eoLckU5qj2NvqNFDT2a0uEGlksLu8Q7uyeid5KwhscGhvnDdgG5O4vUy9pVb4KmDrg+PlU3q0BXds6jS0NSpbB5VJIDSw2hrcMNJNIWFWjQMUWmL9Co446c5GY9FpOmwrc3eupRbhl7UYzpPkc5MjhuYI/HwDu0OWIa/hIM2GmdbDKJvg9SUE8iW9bN6nZIXC6IkBIpD5b2+uQhC/AKc5rDSIB9rISQqyoUwvn62++QS4JsCg2Svfjv0HGwxUgoEyUhMPkAq0SuSVNSaN2TO/atFpWbjfpT1VrFnBXrBep0DQsvBMMX3RQscuRsz9AwKkP3Rk2pEZX7IQoq6pXr0zx0eRVEPUiCywUpX3SO7pX3U8Z/wC1
 FusbD8ZL
 7+TbRxPGl/cUDSoQqxeCdFFvnZ+ZMQi5AHZ3ZbN0dliAmk18lY3rq3WhjxG4t8QJMJL7E4LmcTjPkP9PMQMkw5+vgYwEZhWjBW9iHX1DPmpTMyusGB5wpmQKCuJdhEKI9H+bUrFGiMmR49E6t5lh0bQqYonLcUeXZHRX4JtCXVL9G1/x4RFCYQCzYQcMpGs8SKucWHHiAiOhqICa5wMhfSIWXLLetkofxy/A5FmnT1SzzEyI/TgErM0wWF6xWtwzUGfFmi6I5PACP2aUy83D/QchH5o6MF/UXU1LVgxMCY4b6sLhJDzJ9RmZ8W30ybvfZDHU0SpzaZcZzXgtKQJysKcZWEWVqzQo5aRZUNNbS/SDrjwk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 14:43, David Hildenbrand (Arm) wrote:

>> +
>> +/**
>> + * migrate_hmm_range_setup() - prepare to migrate a range of memory
>> + * @range: contains pointer to struct migrate_vma to be set up.
>> + *
>> + * When collecting has been done with hmm_range_fault(), this
>> + * should be called next, and completes range->migrate by
>> + * populating migrate->src[] and migrate->dst[]
>> + * using range->hmm_pfns[].
>> + * Also, migrate->cpages and migrate->npages get initialized.
>> + * After migrate_hmm_range_setup(), range->migrate is good
>> + * for the rest of the migrate_vma_* flow.
>> + */
>> +void migrate_hmm_range_setup(struct hmm_range *range)
>> +{
>> +	struct migrate_vma *migrate = range->migrate;
>> +
>> +	if (!migrate)
>> +		return;
>> +
>> +	migrate->npages = (migrate->end - migrate->start) >> PAGE_SHIFT;
>> +	migrate->cpages = 0;
>> +
>> +	for (unsigned long i = 0; i < migrate->npages; i++) {
>> +		unsigned long pfn = range->hmm_pfns[i];
>> +
>> +		/*
>> +		 * We are only interested in entries to be
>> +		 * migrated.
>> +		 */
>> +		if (!(pfn & HMM_PFN_MIGRATE)) {
>> +			migrate->src[i] = 0;
>> +			migrate->dst[i] = 0;
>> +			continue;
>> +		}
>> +
>> +		migrate->cpages++;
>> +
>> +		/* HMM_PFN_MIGRATE without HMM_PFN_VALID denotes the special zero page */
>> +		if (pfn & (HMM_PFN_VALID))
> No need for ()

ack

>
>> +			migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn)))
> Is there no easier way to avoid going through a page?
>
> I guess you really just want "migrate_pfn(pfn & ~HMM_PFN_FLAGS)".
>
> Maybe add a hmm_pfn_to_pfn() helper that does the "pfn & ~HMM_PFN_FLAGS" ?

Basically yes. I noticed this was helpful for instance with the "separate address space for device_private"
patchset not to depend on the coding.

>
>> +				| MIGRATE_PFN_MIGRATE;
> We (MM folks) usually put the | onto the previous line to then properly indent
> the second line

Okay I will change.

>
> migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn))) |
> 		  MIGRATE_PFN_MIGRATE;
>
>> +		else
>> +			migrate->src[i] = MIGRATE_PFN_MIGRATE;
> It might be cleaner to just set migrate->src[i] = 0; here and to unconditionally
>
> 	migrate->src[i] |= MIGRATE_PFN_MIGRATE;
>
> So you don't have the MIGRATE_PFN_MIGRATE on two paths.

Good point.

>
>> +
>> +		migrate->src[i] |= (pfn & HMM_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
>> +		migrate->src[i] |= (pfn & HMM_PFN_COMPOUND) ? MIGRATE_PFN_COMPOUND : 0;
>> +		migrate->dst[i] = 0;
>> +	}
>> +
>> +	if (migrate->cpages)
>> +		migrate_vma_unmap(migrate);
> Can you remind me why we do this here, in the setup() phase? The function doc
> does not really describe that.

It is to be in par what migrate_vma_setup() does today after the "collect" phase.

Thanks,
Mika

>


