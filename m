Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A66A5111227A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 03:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11F1D6B0089; Wed,  1 Apr 2026 23:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7166B008A; Wed,  1 Apr 2026 23:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00CE16B008C; Wed,  1 Apr 2026 23:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E63636B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:19:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A948E0683
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:19:17 +0000 (UTC)
X-FDA: 84612159954.15.250AC25
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id A1A3C140007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:19:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ar9vBvcI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=yintirui@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775099955; a=rsa-sha256;
	cv=none;
	b=1VyuXezkplt6jCBdrNi3qA1tPPXpfBXpeBQGmMkI3P3ifhHLAiyCDC4nCkVOTD0J58ZMAA
	ecjpRuy/dQNnoPuas8V5RNz02uCial+vY1gCAasU/yKaoJDCI0BML5Uqrpwpc39meSP95s
	bjEuOYdyr7bI2U2Q8xuzxGWHW21eZY4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ar9vBvcI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=yintirui@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775099955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MHxE5G4ZM34avWaCstTdsFTjHHP64KskW/w6SQu9UbM=;
	b=xV9G5M59k6JHyjS4zqHceS9yM17oDbDQ18z+FAh9AtxtftD7I3ni5k59+P8f5JQTRD/vCK
	r5mZ1OysgUhXslqYG+BQlKfs+nu+sm5eKHjE5QJLBi7Pd+DFMC/uLedm9w/zJeRbdE6+2J
	LrUMvCSAH2b4wNG9gSmgDgImwMJHRL8=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-12a71ade78cso627825c88.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 20:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775099954; x=1775704754; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MHxE5G4ZM34avWaCstTdsFTjHHP64KskW/w6SQu9UbM=;
        b=Ar9vBvcIyQduwBjNwtt22Y6kP/kuzIIpYr8chZctOZPxbLOJ/V80WNDoywfUtAhLGe
         4WEsSlCUfrg6Zsbpq+QKoKYrIGXxjY3a2mheZhZkwyK9LJW2R486Emhc8A8qlBa1+dtR
         /KqdURsSXIY5RgP/lCrxBQyTaL+k44ed/DIuzokzGnmzVT6enCdT6hZY4ZCqwUlZiNhg
         kpbj7YDgKY8gu9IrinTBfOP4i3oePAZmUK5iq5mBJ3ouLFnzIP7CbOUnWs41Tm0UQMBj
         OTkFP3wPuVBG22yanOO1WlPmd5/41ge42YKJ+TE9fWyMQv7OjaTiKHtx9gxMZGp89j/D
         voYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775099954; x=1775704754;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MHxE5G4ZM34avWaCstTdsFTjHHP64KskW/w6SQu9UbM=;
        b=OJtpuldh1vP1THVp7l4tO6jXQxxanJoQEEy8dUM5XeTRV3rpgUyV/JXJtgvSQnT3qj
         FszLsz6gZ6iv5W8aMebJYr/NiFyyweIIkfb2qTmmCTpzv8ku4j7Vtp5Vbhlczg9l7tRS
         EMcFGcI5RJXBASRSHqVvIqiL8pB6DwiDpViYV5soXbw0jiXGCagb+oU0Mnnjuwr8JMgK
         3r273HGHOYuAOsXO5p5TjmrRsO53Gmt0+yp28W+LxxCjM4M1ZQixPRL3iMaHZf0DLu2f
         xoRLtKokQHxAhbVHpZZeViWRkkIh5+XCc2oEv6WYGJQgoJ1mkOif2Z8liH04Fr/Bzjm2
         wCLw==
X-Forwarded-Encrypted: i=1; AJvYcCVB+WmuH2QU7317plI2ro+HJDjxMMrXJzgeZXjmKpIaSrVsSlZ2je1Kmrv+uVftQktBgdCyEfUBaw==@kvack.org
X-Gm-Message-State: AOJu0YzeSUrwzr1N95j4imw/P0nNU7VyunYZtKG8tPren4UTJgwKty42
	2rJR2bRNpPn9Ky5hED+9HG7MY89y3uVdrxKrZoOFLiMRJenAOq6idSxf
X-Gm-Gg: ATEYQzz7euU1KK07psClaDfYyaW4TWC5uQsEKE6lB30kscOOwtV+nAiyO47iNpxY4Pn
	Y1j6MLVvMjh52UofGRon+8Wxsx2CLhebfTLPfXYQHFZaKGH9WTyVxzygNh7VsM3JkAipxaM+tPv
	C6b9E7FOFsKR1B4RqjOoDRvATfqf4lSDNwLZpihMqw5n2oMecRvv5JZnSQBfMBlqugMsqYPgMRO
	btnXLgoOFUlAZxyvDb/JIgpOYwmF2g2NMsjM4gsTufV00zVYn2dnUP1v6oASsWOCKNtCwihUkHQ
	B0gUjk50NV4vwcXT3gRJUmCtvCGpoZyH9o6sMl3DN3dGnx/LDk5YPvoN9RNfAmPT+eVFhIlunj5
	oHok/oTbVqR/ZxC+vGo6RK30Qqial9iZ93Afc4aG8MemWOnrX017PqTrhHa2gK4Smkd9QrX6tZu
	92lfjXYVmsR5nTsCctnjhsgKr+xkWiaIpPn62/2OPbpCEJy1SJSrkAx9rxZ79RQzOjdMkhWxOpi
	uk5UQ==
X-Received: by 2002:a05:7300:8626:b0:2c8:7172:3b8d with SMTP id 5a478bee46e88-2c930e6bcb4mr3428964eec.2.1775099954147;
        Wed, 01 Apr 2026 20:19:14 -0700 (PDT)
Received: from [127.0.0.1] ([154.17.3.126])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca7cf010d7sm1317425eec.25.2026.04.01.20.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 20:19:13 -0700 (PDT)
Message-ID: <41b1ff54-c120-42ae-8b74-54767abf3554@gmail.com>
Date: Thu, 2 Apr 2026 11:19:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/13] mm/huge_memory: add and use
 has_deposited_pgtable()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774029655.git.ljs@kernel.org>
 <f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org>
Content-Language: en-US
From: Yin Tirui <yintirui@gmail.com>
In-Reply-To: <f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A1A3C140007
X-Stat-Signature: mjm7b5xpbe5ykdmkegmy6atf9s4wn9ch
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775099955-192850
X-HE-Meta: U2FsdGVkX19aFY52vKBXAmyFojqqUeikyprjnA9X+pZL2uE8bGL7g+GyAr5Rg5/4huEiLW6cz/eWem+nnp9noUXz+24gkWCE0iAON27+tvLQfFSlZ8CSmvgjlpkQd87/rW+l3qMzWnaWYv5hpcoK5wbJC0rbZdkbiwONMFwCdmZPGBKGvfl2F2/zKlKyVKX8Pr6Mvs0srkw1IeiI/BqZRbArVWtKI/C4mhhou8QU8Dp5LoSMUzr7wNsZZYnEqyxsYDDOs6OvW/oy0M2rf2yqtGi3Uny3Wi4fcNvV7sXwKpj6iWdQWuBn2m/mwtAf7Y1x8fBvUaVkuJ2XD38rVLC+8nPlqtTH+Zlhlc+LD410Q8HdMoA+BkWkOi3ILYYorGlO1+6umBll0r2D61h0Pd7O16qkywHf9UImM6zu96Blvx7qNuih5EUixNc470GkGrX/HPuwqerDpju3GUOk5XFnWF6sYtVHIUacatdjj8ITyLMqwQW9r/dDHrJT48lF8JRQjlSFrMXmqPwFnLcemyAF4rEu1MvwJM3WlqPfO0ImwLSYedgF2d+50931IRWfU6B7GONgZexiMWO1d8Vkp798ga/bzo1OISkvG+ki1SeqLtDjdQLwlkYkCf4LcBAvNjxBoZl0TL8qHnZb7KiMyV9/odLV/LlIS3AAKD5tW6C9pjVqRIijfLHfdemLAYjqBZWEDWAhUSPDTemvR/24KysEYDDsZg/BX+Ea5NOpXs1BOnCDhS9QpBOj672vECgMGMl/CZv7gfHeXEaxpXQmjZWocxN0KiOxeGxquXvL0oUeQ2q4w9jCTuneaC18i0PNxUrLFSEFUt+yRKWef+ezP7J5lK5LeV5IMV2QpcTNIGrBdrdrf+4P6T+Tw0isjetV1B0enMqjnu1PKtwnqacRSgY14WaeYsJb1/3csQ9qz4Z5kMTCrl+/nEpzvaCQhXa9vnOZXyru5ly6e68xIBTExvm
 j33WzhMt
 xAHIZVw5LH9+GSXzTqiGcd6N8uH+VhxOLX42GBZTPSEIMZkdqtDHeY36PM/80jhb2uodfQiolOjsF3MufiYjY1EPwfjwj7wkoepmjVmmIIhlscNQbrTYcgByAvS7CbzvI+QfdkwbUiGEU31E7xtdj6XDl53WrbFwq9PGSMSJ2CqO2TNdkjnXKYZ+djHwVE03pqq18x96Tj/o9b374dn+pzopeIPl/XDuV/XrEdLsMH2YZ6IGVy/OFkgHofyIe6BS3lE1p304x8ENwqa+YcMPSgwyolYdcDskzyPudPL6cceQFb3AEXoWop8Vdwwt7gI/y0XvwnaET1cH8yXkoGL9M7f7WKNDq0vfwFiAl04jr6+J5HLePhuamCnHIYtNp6mW62kPmsm+N4F4a0lqEbybZhEkNmNyFS+0F1awoZyVrWIM1xfwahAgGPykBttuMAZO21r+ZEwIxSoiCLGo48KOU0FPRXmWFi4JzWHtqcdm90sR4w8hdXDweisgDZn9lmmS+jVBvaIp/DVsTkH9zDqx5DZp3cu/vaNOAip9ACsVSJPniC8EpWqGSYclxP1FBvTnq8+fc93lmfmHIABA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/21/26 02:07, Lorenzo Stoakes (Oracle) wrote:

> +static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
> +		struct folio *folio)
> +{
> +	/* Some architectures require unconditional depositing. */
> +	if (arch_needs_pgtable_deposit())
> +		return true;
> +
> +	/*
> +	 * Huge zero always deposited except for DAX which handles itself, see
> +	 * set_huge_zero_folio().
> +	 */
> +	if (is_huge_zero_pmd(pmdval))
> +		return !vma_is_dax(vma);
> +
> +	/*
> +	 * Otherwise, only anonymous folios are deposited, see
> +	 * __do_huge_pmd_anonymous_page().
> +	 */
> +	return folio && folio_test_anon(folio);
> +}

Hi Lorenzo,

I just wanted to mention a potential intersection with my upcoming v4 of
the "mm: add huge pfnmap support for remap_pfn_range()" series [1].

To safely support PMD splitting on partial unmaps, my series makes
VM_PFNMAP huge pages allocate and deposit page tables. However, they
neither have an underlying struct folio nor are anonymous.

Given the has_deposited_pgtable() helper, do you have any suggestions on
what would be the cleanest way to integrate the VM_PFNMAP condition into it?

[1]
https://lore.kernel.org/linux-mm/20260228070906.1418911-5-yintirui@huawei.com/

-- 
Yin Tirui


