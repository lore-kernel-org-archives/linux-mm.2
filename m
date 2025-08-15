Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81738CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 12:12:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E68356B009F; Fri, 15 Aug 2025 08:12:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E182D8E01EC; Fri, 15 Aug 2025 08:12:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54A86B00A1; Fri, 15 Aug 2025 08:12:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7C4E6B009F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:12:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6FE20C012D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 12:12:12 +0000 (UTC)
X-FDA: 83778878904.24.63EDBBF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9241D1C0007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 12:12:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755259930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k7djlgJKB5AbdLDRTA3sa6y8E/p7KUfRcePniXyQOCw=;
	b=5W6bBnl7nkVXZSNtH/31cYXkAX0wMv4kYgiQ8Zr4awfB+8Srv7yT9fS+8ySLdP/tFhsp9R
	dlDywKqQYjBJ4WBb5lNObqcrGgcMGc7KZAUK9hvIeXnMrLb9g3DSEOg+AsCyfQtGz3PeHm
	X5zLuED3LAc3iYJ7ML2rxIAzFp89HxM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755259930; a=rsa-sha256;
	cv=none;
	b=YhOGyEBSO/q9+3rWHQn76YHo1EZpsY3fxsduqzVA9CMd12UihiptRLI64puX2Ev8OQ/rRP
	i146W+xKDB1+Q5tqI8ta4OkqCgCyKAG9qCJtNp4NuJ4bKNFZvPOGUe9ycUiqfe37JdBCCs
	fJdjOpXXHBNjlEgWa38Y1s19scmoIVI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C3731691;
	Fri, 15 Aug 2025 05:12:01 -0700 (PDT)
Received: from [10.57.56.228] (unknown [10.57.56.228])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7CD4A3F738;
	Fri, 15 Aug 2025 05:12:06 -0700 (PDT)
Message-ID: <f53dd685-4e05-4fd3-a49d-0074b69a8ce1@arm.com>
Date: Fri, 15 Aug 2025 14:12:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] arm64/mm: Allow __create_pgd_mapping() to propagate
 pgtable_alloc() errors
To: Dev Jain <dev.jain@arm.com>,
 Chaitanya S Prakash <chaitanyas.prakash@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Ryan Roberts <ryan.roberts@arm.com>,
 Yang Shi <yang@os.amperecomputing.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Zhenhua Huang <quic_zhenhuah@quicinc.com>
References: <20250813145607.1612234-1-chaitanyas.prakash@arm.com>
 <20250813145607.1612234-2-chaitanyas.prakash@arm.com>
 <683f9f4e-c027-4165-a8aa-b561e304e132@arm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <683f9f4e-c027-4165-a8aa-b561e304e132@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9241D1C0007
X-Stat-Signature: ek4mdqnppex63nnofoxkmrbgxra4sf9e
X-Rspam-User: 
X-HE-Tag: 1755259930-408229
X-HE-Meta: U2FsdGVkX19naOxq9p+/JY98jq4kn0TsBwPtwZCuyKGsH7tKCy0ZxKZaYRHaKMlhgrz870WmNgUZ86/ucKEg8EtdCEiAOu6I+PjmXXGLPkzMgPUv3Z3kwzxdhqPX0TZmw9iiAQfUFdaIWv2GL4wSVjRCvPq9B/iITR+mo71r7GXef0qIfr0TZnFAAIsMgsopEo+PBhWkZWG5aPT1+0KvQ8naGE+svegtduSH9IiQVinqXKT4c0Ylx8CokQBz6DFemYWoIXnWibd9rQwuZ58jvRz4IY1fXQyOW/f8obU0ISx7ayVzE+LGn5grrLS+MPZAG45jJ2owd2643ZQihq7hCZRouE1bnuAmRurdum9iKF/uUpBTAkf3EM8n4Y3gJBmR+vcdAuUc4TDUb1VY3W9PlCaxqMKRg+kVEz4+ET+JtSjI5veYsdNPpDi1R/cPSb2inLixub4oLC3mgLNrx/8qj2TYjrBYBt9up5Ub42Jdo4ruh0KtRzHsQqB5xHYrN2jdEX9wvg5KBHtnz1UKWbe111yT/ctRpgyGm4Vmxpf4QnSm99ZAjLrnkWklRIqFgpyowvEZiBMCYkCgWWOTwbKuq5cQmAndWrUzLdtuGmgpwtJwsHjOEc4YwtaH8LQ2SfqfUMDGEPNYdQYlUknVma+5SH4oG9E/AK3HjQtpwval8gNz+Vqj2OJdvgjkZy24fMveYve9EiQQdI/DK3lDlQIb8ZZmHVVvhkfV8Xkn1uHQWjIkLEZSJ3nQoQxDR6G3jKhiwZCRZN+mJqA3mnqx8S6iV0hKLdTPFhh+MBu52O4fLgKCNXYDgubtntDEpkV20LQXZe8E0mtyZoeVXzAi2hQYkiTEY5IWXVpA+vAjP8yYifrxtBFaLBxbIsaf/2Sb4eCWT+TfJ55L0IVckFoQ5xhZqUKjwbl1XYDyO9st8r44mxqCLzJHvaxO2tgDSO68EhOuwsQTmBgbsHpoPU4BmqD
 oy9T0hej
 7kWzbe6pMLHN78K+Prr8EVwCemIIM7WxSa7KaR/qaySqV3AXfiZAtuXH88nblcen/u1ReC6Zndwwp/2F4MH9xFqwel+rGeTqCnUSjJ3tuZfsFbTxuqfcNwvcPTIHZfdJQ5jEuq/OW2x8manOlzU91O6JY/HBDwYvgTQo16kTK3tVClS8ZQ2x4/sMZrT9drAdScGr8cAmo5BEDG98rCvP7xyMpjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/08/2025 09:30, Dev Jain wrote:
>
> On 13/08/25 8:26 pm, Chaitanya S Prakash wrote:
>> [-------snip-------------]
>>   -static void __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
>> +static int __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
>>                    unsigned long virt, phys_addr_t size,
>>                    pgprot_t prot,
>>                    phys_addr_t (*pgtable_alloc)(enum pgtable_type),
>>                    int flags)
>>   {
>> +    int ret = 0;
>> +
>>       mutex_lock(&fixmap_lock);
>> -    __create_pgd_mapping_locked(pgdir, phys, virt, size, prot,
>> -                    pgtable_alloc, flags);
>> +    ret = __create_pgd_mapping_locked(pgdir, phys, virt, size, prot,
>> +                      pgtable_alloc, flags);
>>       mutex_unlock(&fixmap_lock);
>> +
>> +    return ret;
>> +}
>> +
>> +static void ___create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
>> +                  unsigned long virt, phys_addr_t size,
>> +                  pgprot_t prot,
>> +                  phys_addr_t (*pgtable_alloc)(enum pgtable_type),
>> +                  int flags)
>> +{
>> +    int ret = 0;
>> +
>> +    ret = __create_pgd_mapping(pgdir, phys, virt, size, prot,
>> pgtable_alloc,
>> +                   flags);
>> +    BUG_ON(ret);
>>   }
>
> A triple underscore calling a double underscore isn't natural to
> reason about.

Also not the most readable (easy to confuse the two).

> Since this is the function which must succeed, how does
> "must_create_pgd_mapping()"
> sound?

"must" isn't a prefix that is commonly used in that sense, not sure this
is very clear.

Another idea that comes to mind is early_create_pgd_mapping() - the
BUG_ON() being justified by the fact that early errors are not recoverable.

On a related note, it would be possible to return an error from
create_pgd_mapping() and create_mapping_noalloc() as their callers
already have error paths. That would be a bit cleaner but I don't know
if it's worth the hassle.

- Kevin

