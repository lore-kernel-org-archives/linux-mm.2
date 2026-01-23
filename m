Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D12FDD72347
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EB4D6B044E; Fri, 23 Jan 2026 03:26:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AB4C6B0450; Fri, 23 Jan 2026 03:26:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF1D6B0451; Fri, 23 Jan 2026 03:26:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9D46B044E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:26:00 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 732B4B5C4B
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:25:59 +0000 (UTC)
X-FDA: 84362545638.08.4D2443E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id BA4481C000E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:25:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769156757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H+Ph4/HiAVNACiAQVzTRg9VZTx7FI1NIAhiZlTUmiMw=;
	b=JYLBLUOBOykj1ncOxFCaidmgpRzVtv6WSpGlpeqcdscjFjFbFMUjxmrJvU8vyvOsHU1vrq
	Kypesw8ehHQP7Tn4FnEJPBQNKEy4x38uTYhwa+y4HVMfqudmgAe0xL/KEtZrcx1w7MVApr
	MKB2h3nJ4EByM0/9u1MDi+m6uKMtMvI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769156757; a=rsa-sha256;
	cv=none;
	b=klqag9NA9OKrp3SV9QBgNZszZFVztONP3IatDjUysPC9B+4BwGzvdcmnGo1mo7Q0c2lH5r
	TQ5HumIMsFGvtsjDqu/oiH5zuSiMuJmHzO1ts2jZNG5UstF+8pEhQ1BXRUsF81o7mQeBFS
	KOcyTbsDZxAt59QFfSCPBEwVUkzjchQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4FC481476;
	Fri, 23 Jan 2026 00:25:50 -0800 (PST)
Received: from [10.57.50.81] (unknown [10.57.50.81])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF7B63F740;
	Fri, 23 Jan 2026 00:25:54 -0800 (PST)
Message-ID: <cf0a3f62-5673-47b4-afa9-1f2daab5e0b5@arm.com>
Date: Fri, 23 Jan 2026 09:25:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/9] selftests/mm: introduce helper to read every page
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Mark Brown <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
 <20260122170224.4056513-7-kevin.brodsky@arm.com>
 <a4c83b16-3307-497d-9690-0e31672f3202@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <a4c83b16-3307-497d-9690-0e31672f3202@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6mrgwrg7uekg3sjoa4hqp9d169oyxx1r
X-Rspamd-Queue-Id: BA4481C000E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769156757-275400
X-HE-Meta: U2FsdGVkX1+1TFTqAc14GOjr7XVQaX9GbtipAJbm7jRxSc5aRa8UTk5L+0CokHc5AtAwEXP2AinuwQDw5C7EhNdOgP+g/kpvCxKgthTe+yuHM803IBU3BuThIV58IjxmVQV0q8aWkdWwaa2jEDgpiOiDZIb0rCuUENsyxU3t/quBLKna5mXqEsRZuCk6/fTwTQSre8Lqu7grAx5/5KdHknXU+mdgzpU33NvwF6OBHeukvx6zIt5cRXMdqP6Szq9SxO/s4d4OOanoh7VX5nCy8u/n8P3GIJxDu3HO3lV1pc8AMRaj8Ob6tZuEUHEcW0jqSot5UgfIjPkkq6UOErQIQOhz2/q/xF7ik25gxE70Zsq4bZycCyGxKGlyqSPz6uQ72YX6twH7uL8vsbt+3/EAJsLlY3ENFp9fr448Lbi4uXaRl0HAFhxbZVZRBRbLTTxRju0OjdtlyCqbsTYUoOCL89TmNTtgD1R+ktuc/sLC1zsWKK6SiMrx/m8teA+GoxJ2acfgqMaN9fbaGMGBzClJAs1Q6Iofe4hW0R/vqjOaioH8/qUKZVTe+D5DRwKhtZmu389rVqBv39eLDaL3ro78BR8m66O4yMRdMc58PiWaTHWRWYeMrW+jNHSf3i+h/0FWCm4fTtx0VGHf4dTBkhPD6CpeQtLBuNBBM45HrsQIKFae3Na9B7Z6TR/uuD8PwXI92cVR9otcsfryBwYM59P/Gz08iJ/O0Njh7kJVmwArv8FUExjNSfEWIgpyebtL4HlVWP+mPmrw2SlpTd3+7A2OqkPdPuLdrDSph3EvYm1d78xfVbkVB3a9I4gh64KAkqxmfX/EKszKJQL24KrBDejpXXmystnlqkDALp096iOf67JDD8QHC4BKVmIq/QshCxxQw0uaU3YG6TYtRzDsTFfeofXFc4g4D4TLHDXDqopRXuNPrycqZ8KRUd8CZ4tVuScatCpXsFkS7lUu3ycAYam
 tx6r1yFL
 hzvHghfhEuUv9PCeXzbUiTluvWWetDkEZKW75AoDJTyv8gLcU96FlrZrqgtjgNQsdH3S2uG0LxSFUXyZOl87clCB9FphQTQzj8qXeskXsL+pPITI8kEMvE6aYzZ+FrwJdMasLfX0dFkPT164nl+TdWvRF8IgbZzJs39BTXO8tUlDdp40=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/01/2026 23:20, David Hildenbrand (Red Hat) wrote:
>> diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c
>> b/tools/testing/selftests/mm/hugetlb-madvise.c
>> index 05d9d2805ae4..5b12041fa310 100644
>> --- a/tools/testing/selftests/mm/hugetlb-madvise.c
>> +++ b/tools/testing/selftests/mm/hugetlb-madvise.c
>> @@ -47,14 +47,7 @@ void write_fault_pages(void *addr, unsigned long
>> nr_pages)
>>     void read_fault_pages(void *addr, unsigned long nr_pages)
>>   {
>> -    unsigned long i;
>> -
>> -    for (i = 0; i < nr_pages; i++) {
>> -        unsigned long *addr2 =
>> -            ((unsigned long *)(addr + (i * huge_page_size)));
>> -        /* Prevent the compiler from optimizing out the entire loop: */
>> -        FORCE_READ(*addr2);
>> -    }
>> +    force_read_pages(addr, nr_pages, huge_page_size);
>>   }
>
> Likely we could get rid of read_fault_pages() completely and simply
> let the callers call force_read_pages() now?

I considered it but since the test also has write_fault_pages() with the
same arguments, I thought it was better to keep it for symmetry (neither
takes the page size since huge_page_size is a global).

- Kevin

