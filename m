Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E964CE9D42
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 14:48:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4EF6B008A; Tue,  6 Jan 2026 09:48:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D821B6B0093; Tue,  6 Jan 2026 09:48:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8E8B6B0095; Tue,  6 Jan 2026 09:48:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B7C7A6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:48:26 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6056C8857B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:48:26 +0000 (UTC)
X-FDA: 84301819812.05.C53EC65
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	by imf19.hostedemail.com (Postfix) with ESMTP id 546671A0018
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:48:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="DHk9/egB";
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767710904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zcDYYUlSpjZtiuhui593Rk5sJ8xjAAB2MtRfUEdlRcA=;
	b=n7/MNnTl1XGIiaajfyCzgP7mQ7HGf7Ppc8ffgy/o3xwzZS4II0GQMITTeTEIIeIhTBKCPg
	yBhEKWRc7wLH1o6GgZBm9bJVQF9QIUbAhjfQ407ZX2wfExMZfWxTnxL3oHh/J2rbglmn4Z
	T00nCtmzvKzGvrU6JJqb9xjN1iA9Gao=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="DHk9/egB";
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767710904; a=rsa-sha256;
	cv=none;
	b=PwzaXty2lvaiVjp5/u9Lx5ZLTQ9Z1O6ElRowES4XgpdenaQ0P2cXRIvedx8k1J78/j44Gl
	IJm4r3UouorM+5YPJ1opIB0H1sKPKMgPk0TZSN1pxlVBMj5zR+H6XEzq+9lyJ1eUecCJn3
	uDLkJkrG0uVLHUJFvaiQm41FLNlzPpk=
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-477bf34f5f5so9627735e9.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 06:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767710903; x=1768315703; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zcDYYUlSpjZtiuhui593Rk5sJ8xjAAB2MtRfUEdlRcA=;
        b=DHk9/egBTeqmvMvpQz3L+FElWQ1rJlHDYAFU9wjAGlyV8TwQt4lvlCn8kEOW/ipDLm
         Go/jkHz+7TDSCJvQNYCBUswNqDdcop7hOXvM2TLeoNQuqkKqO/ioC/IcJW/k14vBp2DT
         aIqQLQNHbDP5JbTWiLJaylObdq9j7T4BFxVreG9dOGAaye8MloOl1PCtLTj11II6ijap
         IRnZzccq3iylCcOgpTMfAHttaGaYa4Bb3Dq7UI0Cw68M8rFwby2J3LSXaJD4QsIeZbkt
         jAgQbbbZ3c/4w1uCctrEmVftoOXQnFyMQaGHDux0V2Ihb57ULpj1qypc5lPJPT819New
         NKNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767710903; x=1768315703;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zcDYYUlSpjZtiuhui593Rk5sJ8xjAAB2MtRfUEdlRcA=;
        b=Hi3A44ApttEXlT3A2ViLr3/yMw8lSZbofB7pa+5hxni7Uycq4bPW+zRWjb+2XmEJKX
         do7Fv9LiTkqXrcOMPZS3Q8/51Q5ukcyDip+zQpDxyAuRKPCzCYizUh21EAhAPwtOuEEX
         gPoB1Reng3bYYpDvnvrXBRLyVI8a6tTipC6Z9Mo6cnP2IQkdjrvQLOVVlAicBCd15EhL
         um7rBj0Y3fDRdOK3CKRZw89TgbDJ5sisTXEFrzqQlkKBBxpIJsE27zdkyps2tb2uxFyk
         tGMKiLMXGdBb0iz15gLF6a8YJXtp/ynYRMUyuyu6DPZ78jl6FhvH/EbRM/Q63dgI4Q+1
         AgRw==
X-Gm-Message-State: AOJu0YzSICMzCNeMoQ6WazbneqhIasmoApst+HuMagPVfX/r8BtFt0r8
	fqMoJtnYFAtJqR5C8kKDdVPYIwfaBGWFl68FUG64KeVkeyaW1rAWAgebgNfAVYHKBME=
X-Gm-Gg: AY/fxX6DwxVVTdKXErsPMjjNAHMcH8rhVyLVJAVZbI0ZM/5fyTKH+hZsqkOrmR7yipa
	4hnjsCCXFfqoYU6epYbTroVnaNjjDKTTyo6E01sAuskGXH1yth90qb2bCov4tEmlC69A835VJCa
	Qpvmb8cV+sAmi/STlx7kp0rB97S+uJT9jWh+0tB+P6aRaGxki9ipRSIJ25n26iQnnjZ6aZ+Ml5d
	qovfZ2Tjh09Q7rjARXpTvAuNHvqYV0Jfm3mMzVyPKdkoV8F2PTzg16cckvbKFSk13/iLJ24L6sz
	WqFYsoKlQx/HEGEnvwe/IPMGQqOkSUSy6PJfD/baxZuqkh5iPQXCZofZGi4tV91XU5Eb9jtJ1Sm
	j5XIXa8Kx0nNZ1uyN8frlPBWSuNZKgmWJQ1V27jUWubsYAq9e+RWTcHDEAYWLuMuqo7Le8oAKdx
	41cbaBl1W/khsIbn3Hpl47RvE9
X-Google-Smtp-Source: AGHT+IG+fGx05jjqgVtGpbmzaDFhFjx3lqKyFTpOmlDCBAFJagE9HL0lIyPb6OYzFukf4RkWIHBZRA==
X-Received: by 2002:a05:600c:5395:b0:479:1348:c614 with SMTP id 5b1f17b1804b1-47d7f09fe13mr36724665e9.26.1767710902546;
        Tue, 06 Jan 2026 06:48:22 -0800 (PST)
Received: from localhost (109-81-90-116.rct.o2.cz. [109.81.90.116])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f9a31bdsm19312725e9.0.2026.01.06.06.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 06:48:22 -0800 (PST)
Date: Tue, 6 Jan 2026 15:48:20 +0100
From: Michal Hocko <mhocko@suse.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	richard.weiyang@gmail.com, David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v7] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aV0gtOs5cuLu57Mk@tiehlicka>
References: <20251221124656.2362540-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251221124656.2362540-1-gourry@gourry.net>
X-Rspamd-Server: rspam02
X-Stat-Signature: xsis5fw1h4jerkcu1ux5ute7hsjh1tfu
X-Rspam-User: 
X-Rspamd-Queue-Id: 546671A0018
X-HE-Tag: 1767710904-266536
X-HE-Meta: U2FsdGVkX1/Vk45lYNyDfFpCihlabsPpmdQuGonomk9oWQB3yLkuPMlLWTs6CeqYTQlB/u91wjCqDTOsTZrIaCYiStrUlZVGF1AMyiGHSCJsbGpXrxK7Va+o7+rhtt45l9iV87FVKeb0pwlAPlXotMCr/qKWirYXNULDdIWNBeBbl7qQiGtQkurq34fmiYg0uZk64bY15P31cQ9M5KMsvOU1z2RlFEfxmLg4fE942zEVcdg2TA6mUr4diUl+KMVCvz5QGZMBXXjTdMk1IbXycbkDZwJflU0aTghTJuT5d6MSMRxIvJSr8YyxiHq2wAMdNvDK65/nPWEuMsr4/FVYj5iBTsE9deWc5rbohOfIb06fLFmsBi98ux5JvsJMG9KDCfjvSTKvSo+O+L1qHlum37gj7EeWKfXgEJqdB0Ct6KhMfGMt0XjcajpS8miUgYNh9xBpKBppOGFy0pTIDmQf0ZoZ38wV6keTe/+y3kzWR0v/7QqUaRc9EIuBYlR7k9uSTCWzj06ZYWiHMfH2PR4PNOdgIQ7darRPDzCEyV/LwCBN7vytwZ9Y3kpGVCgfVrZ28IefU/tf2baXI2+j8F3v7uTMbe/G7mMjnb7b8gsf+ZBwDXQ6YVK/5EBVvO9fMXK6LH93o4KMoHTe1wNNMG5/NwJWgkMcnx166Rijohzesi/gF9vX7XpKVHpK1Pe8k44GURl1t2/Y/oOal4zJMyww9zGx4SJhnmm6w+UBD+sOTyYG5ak8BYa0Apznh7jMvYXtQVPAo98lTu18kkjgt1jkQUPrfTGeR9XqObNoNN94t2JEipxTeLjp0lhxH5GxeMdbAj2vy18eaunNkpvRNV6Orczy4f8rLt/WRKQ2MCDfx2wGNy0OxGit4ByJ2ZS2b0iNBwfYL3p7LC7blBgpnOm6v2zofaToW10shuRwnybvHaJWCRy0GcqymBfXnFzBmKOoDTxBZiIlaDXktLRj7e1
 KYRXkOlF
 jXpuPChSsiAW3/holbYlftM0iJMqruEQjPBq5Sdc5HtRfvEWQ2DeLwLBORy5PiO3KsoOcO/t+fjWD6X+t2wlcUofflFc2/VXrPSE8q5GaI2RCFlsSOJP1j1flcaAjy+LQswiYKC/y9qcqlEL9y8Bm/f9oQw0b026YHXL0HGJmTa7xUd5ZEQ8nfItOR/X/HdmRQjFGdE5GZgXUT7lDPM8mOogbBZpv1M4G6nl4utfskkJjBpQFJYeH0BfrnFk7CDLJI1sBXmiFEPSVXXpRW40F7+cWKmvkAIKA5Z+WNc+Cvr8NbqsmFJP9gjSpFxQgBj6xipn6u0MDgH+A6J8oaHFphRGUaN7eOLmE+IVkoE3HJAv6Tpt3MqIMh76swC9Fp4DeUVsJWcz6oCaKVgjNa+zu0ncpNikxZX4hV543/qPg4S4xw/o/qiq1mcffjALjtHfWywlF0lnASS/4+/FNsTgxoOZ4i7+9FVLg1NZv4G+V2R2gk3qrZjomy1/urBw3mDIXGpHyMj99SjMy+9DTc4E5Yzs2onJgVBqUAfl6jlACSPIzzU3K5xi4Gr/da3U9nur6xWRKvatoc+C+S4Z+ph0IIZ66oCCQIK/dVJIF5tV5iPZ/eAa1m1mpMTTM6qEKzhXzD7e/8PQ/E5ho9Hy3Ck5EfWGZiRBu5x4ziurwUVXTrlSezz5tABUqcez9ky6e8igxIK/OqSfN+M+skDXLpGj2wlpKslVt8/Zf3Y17eEurwEbnpppHupqFR79KtTa9iHMR4XZIcP8hweW5GRE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 21-12-25 07:46:56, Gregory Price wrote:
> We presently skip regions with hugepages entirely when trying to do
> contiguous page allocation.  This will cause otherwise-movable
> 2MB HugeTLB pages to be considered unmovable, and makes 1GB gigantic
> page allocation less reliable on systems utilizing both.
> 
> Commit 4d73ba5fa710 ("mm: page_alloc: skip regions with hugetlbfs pages
> when allocating 1G pages") skipped all HugePage containing regions
> because it can cause significant delays in 1G allocation (as HugeTLB
> migrations may fail for a number of reasons).
> 
> Instead, if hugepage migration is enabled, consider regions with
> hugepages smaller than the target contiguous allocation request
> as valid targets for allocation.
> 
> We optimize for the existing behavior by searching for non-hugetlb
> regions in a first pass, then retrying the search to include hugetlb
> only on failure.  This allows the existing fast-path to remain the
> default case with a slow-path fallback to increase reliability.
> 
> We only fallback to the slow path if a hugetlb region was detected,
> and we do a full re-scan because the zones/blocks may have changed
> during the first pass (and it's not worth further complexity).
> 
> isolate_migrate_pages_block() has similar hugetlb filter logic, and
> the hugetlb code does a migratable check in folio_isolate_hugetlb()
> during isolation.  The code servicing the allocation and migration
> already supports this exact use case.
> 
> To test, allocate a bunch of 2MB HugeTLB pages (in this case 48GB)
> and then attempt to allocate some 1G HugeTLB pages (in this case 4GB)
> (Scale to your machine's memory capacity).
> 
> echo 24576 > .../hugepages-2048kB/nr_hugepages
> echo 4 > .../hugepages-1048576kB/nr_hugepages
> 
> Prior to this patch, the 1GB page reservation can fail if no contiguous
> 1GB pages remain.  After this patch, the kernel will try to move 2MB
> pages and successfully allocate the 1GB pages (assuming overall
> sufficient memory is available). Also tested this while a program had
> the 2MB reservations mapped, and the 1GB reservation still succeeds.
> 
> folio_alloc_gigantic() is the primary user of alloc_contig_pages(),
> other users are debug or init-time allocations and largely unaffected.
> - ppc/memtrace is a debugfs interface
> - x86/tdx memory allocation occurs once on module-init
> - kfence/core happens once on module (late) init
> - THP uses it in debug_vm_pgtable_alloc_huge_page at __init time
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Link: https://lore.kernel.org/linux-mm/6fe3562d-49b2-4975-aa86-e139c535ad00@redhat.com/
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

Sorry to be quite late with this one. Making this two stage process is
a reasonable compromise. Have you considered using hugepage_movable_supported?

Anyway
Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

-- 
Michal Hocko
SUSE Labs

