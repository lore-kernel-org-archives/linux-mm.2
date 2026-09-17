Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B9C3C982D2
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 18:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143746B0096; Thu, 17 Sep 2026 14:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11B386B0098; Thu, 17 Sep 2026 14:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 058266B0099; Thu, 17 Sep 2026 14:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D57216B0096
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:13:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06DEE120454
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:13:32 +0000 (UTC)
X-FDA: 85224051864.16.E5F8B5D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2B8801A000F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:13:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aYA7qe3T;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789668810;
	b=a5X3awK7RvBh9irsTkfW6/JBH1xjfdUDZio3lSEPvfje+rFUG5/SuFPNY2R57CtBrikuyO
	I0LlkzB7z5fOUX1A+aYxkqsijntC2/5UO3mZV1occVi8yZXe0UEG914KKlsUvSq5PNtY2g
	4u7qgSx5Ap8PpxdkjHhG71NGoaBK5dw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aYA7qe3T;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789668810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QAr23lhx8wGsXT6yVi+oXiSZp/vetZhFYtO/kqi1324=;
	b=nfeUxg+TXFT8SR+degDzBo8XiBDzeLGcP+8ORHn3tpEVt4Wb3m55Igeh6S4XLuKvSZusRn
	7XXl5m8n1sEbgswCj8KVLSvcZvLVKbXjsIN3XuI2q96scCLX9i4qkulperxpIH59F/BnpN
	Idi544xLRPS58EE36FsRdcFqoiR6xlQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AB24D1F91;
	Thu, 17 Sep 2026 11:13:25 -0700 (PDT)
Received: from [10.57.7.135] (unknown [10.57.7.135])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D69F63F86F;
	Thu, 17 Sep 2026 11:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789668809; bh=QAr23lhx8wGsXT6yVi+oXiSZp/vetZhFYtO/kqi1324=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aYA7qe3TJmI5eXy7zuCDNvjC424BNkx9TqHpOMlyNEkNvwpgRn5lsECsH9o7hC0RG
	 5jIxS0q8ZHaQOP2dIWzY39HZw+w/QDzFAaZ5etprv7QyoTOG2UkZgMUVBbr0E0ztmK
	 wHMiHRGdA5HaFJ3DgcETN41w6QqxGhhxvHgViRbE=
Message-ID: <685fa7b1-af6d-4dc0-8764-5bcb169b39ae@arm.com>
Date: Thu, 17 Sep 2026 20:13:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] mm/execmem: use VM_FLUSH_RESET_PERMS for ROX cache
 allocations
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>,
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
 Will Deacon <will@kernel.org>, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 loongarch@lists.linux.dev
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
 <20260903-execmem-set-vm-perms-v0-2-v3-5-949b64a9f755@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260903-execmem-set-vm-perms-v0-2-v3-5-949b64a9f755@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2B8801A000F
X-Rspam-User: 
X-Stat-Signature: grtnsrpym617jqrhrc4tfaaex334qn4b
X-HE-Tag: 1789668810-248290
X-HE-Meta: U2FsdGVkX19zDT1zBizpjXkowSQptS7bjY6s4s+hvWPP0VW1v6vjM7dHXsZkchxLTC9EyzrH9to3GK2RYVldPJAt2S7I2RQuopiOy/xgwj9wzOv6FFb/7c7cOHp9dlgow7NeUtRmFBoAV6CThL9NGvIj5rv2rZaqgKbkpKh+iz0M5Z/txBn+ThJQbZ/la4dEHwpAxMAKwW3mRAPdO2HOxXqbci8P5nNYfnEkU1a+i11neEvKf2bvtp8ee7Uw+0+e2g/XXqyYHCsN/ITcWMCkPW4zaTdsUN1qPcoopP8LWLLwq26uQO+09FsR4RAJhUImCEwqxck+UtIHAlKfFhzwVfIU7F2CcR9X5Ns6B126h39CCMiwQMhB1jSTIOMRJ+egJ5nVVHvg3hfmU5LB15zaMQlIb/7D/Hh49SNiyTGMmTkA2ZMiBCqFIYoeeHeyDAXGxB2bQYr++u+cZ0ZvLoyraN/3hnJhjVFeCViDg35OicLkfpJhpewyGs7uOsmBMGHtZjRwjWqBHge2UawYIRG7gPBmYttuSj1ssvwr2iZ+pd6ebYjDU0D/ZL00eohTlbg6ZzAxNo2QvH+C/mycPOAo2SABhxtPNborKHpuo2fpot5VMS3A4y+IjJZ8jbhZ7oX7mPBaqzi7PlZoBU9j8fUnPlzbkgEZsbDcMr513FGWk7TeOtJOACBCvNeK/b6ZgEv1tRIn6nwSZVpJ7OyBHKACO9FROT3eTynEDZbC6ck9qjutd4mxpeiGXSqppAOaBLzLD2zeT6aIMaO5Z4mOHmCEuJ6JSOtV9O9DyynXYr09zXuDU5GAIXegj7axXrWfmKZyQsYYo8ehlAOD6Mj7kpiDINnVylL+7EQr8yHROJ/X6yxps/OMraYDjdLbe0dMsSR2mDWnx7XQ2FkUNS45yioavFYVGP+Wf49nwvaEh0Mj+5YdL2cqiV8dgpQJDGIw19AqN7QgcvKPV/26jldCOjC
 xdMwgV9X
 ulMg9c0LuriqyEPmAjVYLSmlNkas/G5W+CQ9DBK1Kf6Mf9yibXQq3BjBsnozyl1VJ/TBeBNQL//hVirv4zDGjWf2kSPghoNc12T0sZP8GJNH38xG43zyD2a9styubhccdzr6sijIb4TLqEA40iqWSjQIrtKRz2nGiQmX+FmLcmbrdldZfeUsBlwsQqTaxRj1iYDbQoTct0R7yuqv85yHaBDPD1WWrFI65vFNLJ7SmhntbXJEWty4GoZIU68i7LZXz8jOXc70B1IyI2gLj7IKLT2yzYhAKzQKxgVj35RLTnqjJ0E908wkxgUNp1j7EVVFTwNQ21WsoaSWSwHI7FeyRQiPWRzpbMv+BiE+LTRA9R0bwYS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/09/2026 11:28, Mike Rapoport (Microsoft) wrote:
> Initially execmem completely removed direct map alias for the memory
> allocated for the ROX cache in PMD_SIZE chunks. When that memory was
> freed, its direct map was restored also in PMD_SIZE chunks to avoid
> fragmentation of the direct map caused by vmalloc::vm_reset_perms().
>
> This required execmem to implement the wrappers for set_direct_map APIs for
> proper sequencing of removal and restoration of the direct map aliases.
>
> Since then x86's CPA gained support for collapsing the direct map page
> tables for ROX pages and execmem switched from removing ROX caches from the
> direct map to making them ROX there, so execmem only needs to update direct
> map alias permissions when freeing the ROX cache memory.
>
> vmalloc already handles those updates for areas with VM_FLUSH_RESET_PERMS
> set and vmalloc::vm_reset_perms() does not force split of the direct map
> for PMD_SIZE chunks.
>
> Set the area permissions with set_vm_flush_reset_perms() when populating
> the execmem cache just before flipping the area to ROX.
>
> This way freeing an allocated area on an error path won't incur two
> updates of the direct map alias of that area and TLB flushing in
> vm_reset_perms().
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

