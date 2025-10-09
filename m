Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 632E0CCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 19:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3E408E0037; Thu,  9 Oct 2025 15:31:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEE6D8E0002; Thu,  9 Oct 2025 15:31:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BD4B8E0037; Thu,  9 Oct 2025 15:31:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8906E8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:31:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 541E0BCB7C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:31:34 +0000 (UTC)
X-FDA: 83979570108.18.B90465E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6BD6B140009
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:31:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lLIc5Num;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760038292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVbPuzfP09yvB5jPXyqUbKYRv2EI0OjhEBPN2fTD9cQ=;
	b=JiBtiZOjVoFh4KvVt8DWZWPEDH1LqO6JmkOJF16BW+oBNerIaVev3Irjg8I/E0zK9CSVoi
	rDvAQj0GZAfdz94s1QpEnc1e49Zv2uueKNYA4GguWphX5lPrr8FIMr0tPzmq02lQLoBl2g
	y7N8tLqLmLKl0zmkSiAwj7dCCJBEZEc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760038292; a=rsa-sha256;
	cv=none;
	b=hbferpse0bf71AoASaPkSCEbjNwnk/GSCX5dzeMuKCN/RBXVytMgkdjb2qjPovx2plFJaa
	SgFNXypNbpzrMQ3nd3iCptxtG8y97rxkOg7Q51PK5ThgydivDzLAicWwtRlL4Mx/+03gqq
	3aRfQe4sPZnqulTw1OHC96XmEyc1J+4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lLIc5Num;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760038291; x=1791574291;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lQaJx5mf2Mcb86lyOVhEpWWdXR0OG4rqbcrV0v1p+lk=;
  b=lLIc5NumyuNDL58lCGimUBGIxKM3DzWDanO0T0iO196hdHcOMIHDF1mw
   eI5xmy1e/554SxmW1e+JRb0Z+2jJJ2YiPvDVAFRe0JDkoKw7+WFUXvazn
   28j4HVoMAaeizV1TVSzvQ10w8O/9Oqq0hnjPYneHGkQSntlr371Kdmudi
   X1j/SzIChz8abTJtx1heaNoztIF0Hp/W7mkilsY1oPXfObTH8X1yGw5jH
   VGc6kstqHJ0yoprCsgB2O9/D5Ipp24obj0MCuI9Ev0LWDMsgHPIzJoso7
   w4dKfiPlxzR5/0WN+hiZPXxV+e/K09pkQhhfcl0MvV+h4R8ELmUqIFGJ8
   Q==;
X-CSE-ConnectionGUID: vaC1gziATF+qMncyS/6Z8Q==
X-CSE-MsgGUID: AWvVSG1KTceK9m3Dm48dow==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="62286509"
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="62286509"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 12:31:30 -0700
X-CSE-ConnectionGUID: KuJYPbv8RnaazmneQeRSDw==
X-CSE-MsgGUID: 974nS1LmTwKbUepnyb6Zaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="180814987"
Received: from unknown (HELO [10.24.81.144]) ([10.24.81.144])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 12:31:29 -0700
Message-ID: <e4c0c578-50e9-4e65-8e7f-7a6d995b22e0@intel.com>
Date: Thu, 9 Oct 2025 12:31:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/8] x86/mm: Use 'ptdesc' when freeing PMD pages
To: David Hildenbrand <david@redhat.com>, Lu Baolu
 <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Alistair Popple <apopple@nvidia.com>,
 Peter Zijlstra <peterz@infradead.org>, Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
 <20250919054007.472493-4-baolu.lu@linux.intel.com>
 <9648e990-18e0-4aed-8110-b02f4b45aa47@redhat.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <9648e990-18e0-4aed-8110-b02f4b45aa47@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BD6B140009
X-Rspamd-Server: rspam02
X-Stat-Signature: etr9wtihzgbwt6d18ffy4xxijdyfrmwd
X-HE-Tag: 1760038291-978915
X-HE-Meta: U2FsdGVkX1+J56htzE/wnp6uvWX4cdWoK36qFfI+VD/gWiQ3R7mH99oRluV1v9Wan2eJTwaRjT/ljcaeh3Cplq2tuIYvMtEjWph74gA89SDxobJ7FFJBh23auvNfY0NaY4Am1pJI+hXllbjbJnfH9useL43XJHKt4gCJKMvS7OoNlV7rTVII2VIEJ4ZFqLNHn1bvghO1GkaHDrqNWkLuiHInmLhEyMaa7Mb9lbsQ5s826fl2sK48c6qIJvyWiuvFUt8zO9cs03wFAlkHVisAEMdGsBXA0ektGBiCQ8z5tt1WPcJ1oipSFxdk1UinkgQJTE5ZMPJpD21QhxmE4Ke6ZY9Z7ZhS+p7O+jDS4sFxs0SiRtgEkoCYLgJvI78HQEkzvNhfIwcLaRobOPpDrqas6G4gD7BfobU27C3+kZJSJOR+0F61kysNOAzp7hMk3ClMJOjI/mtt3DZKnMtu6r+uaR+hiKuA/TXwWwK9LGcekhovQKTOeA4kXpH889TBj5NFOTo70pihLlrdbiQ5D46Ccl4N4j7je4DjMIlWJyAp3Vf0LISWKZjRZ5YmPsultjp+8inySVztkcc2uevh9SHFVoXChJM8p9MBFxkHIDm0Bl94e4TR0ibprc33HO1lu/Ow4fuiLSVKiR3tZVBmen91suZQLmSpC463l5MCM8NCslysiRebL2K+fdPdkwkqjhFjK3RvQfdfuFHzDIjhHpU+I6vNJp36Ol8vNvX7yKLakwoVfqjCpc9vhX9nnmnFE3iq2oosItciXbHiYl4zEW/VHh9jqqV/MkNoj9HgFdMCRHd8lO3clx9LCM9VYKElH+FQgDXFYQQiCIIv4xaxPqm/iDXMOdGQ4gpPMLCALJAh1ZR1Oh/JWLRA8juaPMUFlWHzTkMcJvbimKfRY2NiKSlvyZ00TDCxTJr+MJCqtnyhnsGzOCuTTDGv3LUFfKB/w5RzflgV8JZ0JMgvnYtxCMp
 P4OTlzgx
 4cIkxG9WR1z7a78wSThYIFhjuGWnFDiVxm54i9XZKh68vvoRgPKkWJ+U7df/CMAzrledXe0rnJWgkJHxqRp4idLlcXhiK2lAjiBkVAqHC7/qDbhsijW4UbuHur/3rINc7xN+2sYovLAUu+KqjIpljy5yBkMkJdUnvG/ZEKlkOoTKOpfNgL/zkaHkiUMMEZqp7OkcVC0UbVkpV4unV/669k6sqcWKafkiHABGXnax2kC0VqRHmSD24Wzc9rF1VFBWkuA4iW/JR6pJFt2NLBDCt3L5Q2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/25 12:25, David Hildenbrand wrote:
>>
>> @@ -750,8 +750,8 @@ int pud_free_pmd_page(pud_t *pud, unsigned long addr)
>>         for (i = 0; i < PTRS_PER_PMD; i++) {
>>           if (!pmd_none(pmd_sv[i])) {
>> -            pte = (pte_t *)pmd_page_vaddr(pmd_sv[i]);
>> -            pte_free_kernel(&init_mm, pte);
>> +            pt = page_ptdesc(pmd_page(pmd_sv[i]));
>> +            pagetable_dtor_free(pt);
> 
> There is pmd_ptdesc() which does
> 
>     page_ptdesc(pmd_pgtable_page(pmd));
> 
> It's buried in a
> 
>     #if defined(CONFIG_SPLIT_PMD_PTLOCKS)
> 
> Can't we just make that always available so we can use it here?

Yes, that looks like a good idea. I never noticed pmd_ptdesc() when I
was writing this for sure.

