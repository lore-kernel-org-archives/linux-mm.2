Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B372ACD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 05:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D096C6B0005; Thu, 11 Jun 2026 01:15:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1216B0088; Thu, 11 Jun 2026 01:15:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1E186B0093; Thu, 11 Jun 2026 01:15:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B541C6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 01:15:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4B8A98E0D7
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:15:16 +0000 (UTC)
X-FDA: 84866468232.18.84E4A84
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id BF5D5A0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:15:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DKZeSYIW;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781154914;
	b=EDvFV1xTtBTSpSifRj+G7geypl0i4YbsmEGSYIyFUPUvX/oK0ukVpaCTP6cEOt8leCJAgv
	cDNUPezIz3zIK7VeOCP9sIsFfKdwAoAiPlsJ75uK08nKbp+ZBSjM7/fU/WOtZ0WOwH2nHE
	4mSmhG5VAUY5EcTeWWkiE830vy3X2N0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DKZeSYIW;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781154914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9Lv7rtoem9UTd4iNulk9BM9Q3lD6deBqM35Hu0yrcw=;
	b=eEhaIwRqUDwnpYBRXgfkz4ZR9Ib3zx08o7RC45gjJrD8N5w9GtiLA/790VRgdx2gjNT7M+
	kfMAEJmNW6vVpV4nAv5vZleSU17UrJ6p8rzqmEQs/gvNnhc7kB6GGKLae1KEb6MltyaptQ
	9CC1FOETA6He6OGCuWTKSrJD2M3Cv1o=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D3DE1CE0;
	Wed, 10 Jun 2026 22:15:07 -0700 (PDT)
Received: from [10.174.41.206] (unknown [10.174.41.206])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C9D0D3FD88;
	Wed, 10 Jun 2026 22:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781154912; bh=pH+sfdKdScjYmUghnyFVPRGy/nPtjO9y9SSPXvvHtmg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DKZeSYIWlSISVN8kuabxuHiC0PrAooIqi6wB9c8DowZp0v8z8DZk+uQpqcyUmOJhk
	 if3aBfqMPt70Sg+RDV6ff8JFPVoMuB23AndBuvJ4zr4B7veefPH2DZBZY7elUji5Vc
	 4y3CDenmfIYo5FcL3Q8GLF/EWi19doT7qsoeL3p8=
Message-ID: <919d334b-16a3-4412-82f4-b4cd6a35be0d@arm.com>
Date: Thu, 11 Jun 2026 10:45:01 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 1/3] lib/vsprintf: Add support for pgtable entries
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Petr Mladek
 <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Andy Whitcroft <apw@canonical.com>
References: <20260610111339.2465922-1-usama.arif@linux.dev>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260610111339.2465922-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BF5D5A0005
X-Stat-Signature: mojaex9b1h4fo1wqs31es8mp6wpzoanm
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781154913-790463
X-HE-Meta: U2FsdGVkX1/a+bVz5r7upJa4LRz9tCq9K5Uc+kLp4E792P+BoZvd7sq8Dx4hnylpUTU0YDn5S0ijD61S8HmrIUDCroEcsfI3qfVvlq1CfZLtO4yETKzx6UP+do2zrSPVBH7Kk3qoCce7MwccO88Lt9PlXJ7gpsLM84l2DTB3xY9xbveblr4hAGs0ygu6ihGtB1lFOfHl7a7mDacc6UrKRQLN0xW2U3W5tlqPRS3W4F8fJGshnAvYaBPrgn6fSObKZD70Un3utf2AyVwHU5ER+Ubf5Zh6L0vR1aidwfXbryO6X2A4oYctzp/oxZwrGVt1jczF7tH/+RgrIQ7yw6ARjcxn2EcnXgBt5ULrhvp4o7ZhDo43+Gg/zVW6YNIZd90AzNDVaFbEZyyLOrhr/WRpZBBaYYa/rGB0TzvnFbiq8kxgRS9El+Hwn59hiahmZqjIWPD9BUPW27uDSiF4jaDcIQmhaecQe0rZOKDeINU1C3XEongnrS82ZMpXDDoHH+XgBABUcZ2eejl0OUApTC2hkmZ66AQyz+vU3E4O9scSbdUNeNOBePBkex8vvzxWKThvH62bcwnZ2Ujl0hAz6TTQ3ZsOYotqj1gYiCE30WzTYhTseMTN5DCOlqJ6DXwy+7t+NnFWqiV+BvllsWdeCf7ERR3wLXtNorBCH5g8Fm46eBT+JcbAOKPW98u8Hz4cHrRT3ITpEBSbiWUuvXV78io/0QgyWCmvMu0nXR8d7XEd0oPrfFA3LlQQ0AVnHbe8iPbv0m8RfqmZwyilbKlrQia/YSYC5PzY4sJWPUK/4rTWjcAXJr6+EO7j9kCFPWXE294vp//QTp3fb7VNxuOo38+JTzx7YfEDtaxhWb7eU0whQvcM9dEGQZJHPkBMSVU3plWgYiuabA8BqNLpS+5uia4Qh/49zlfg8zjG9CdbWNzSm7gRSC8Mdp8hCT37mZjac95SFPgl6z7lgywg//N8evL
 Y9TI1XI+
 Z2ltYabQvSF6ytRh+sxQmyCwBEyjM6CTlD8Po9V5MaM/ec4+zW6nudAlXw8pWQUlQLcnggq8Eb359G0RLMD1T/5WkjkolSgJSvlMITqdoJ8R4tj6DNHC74vxHhkABR73JFHeYmEAzMIffY0uZy2HYTKHVC+CiSjsYV/dDjfgvmYBtfK3NUc3pge7A6yLL2KOitkNBjdO/dWnV5czzWB7ihATh2N59zk3e1iBW4288H+3DXfgRqLSPEdVD46bg4hNRu+FULXfQJVXXvq5bWerGlyEUQdxHBpD71+f51GxpOihrMQLFsgZQDsWdMJOCeYp/zJ6jUB71Xy9YuBFQfxJBFsRfu8unGzpTKYiOVTPQn+CbVqCiLjGyukxbdjgxFukfujRe5ddNZsee4rL+hldiOkyZ3Z8toGjYzt/c8wvL0EsXJowdk8rT3/BNs20YqR2hYRlF6g0uljlFHDoxjUma56vHK42zIY7XeGw8IEKOUqyTFG/Q12yY2kiO44AXrEizVcRcPhwNjSg+tnxxOk14vzp4Tlqnc5fHT6NfWtAcOKIGq4NfBLbRNsxwNW25mzx3VABSvAmAjuKrRKtb16RrJ7GiVqjS46HEEpo610lHdxGw+PuLzn3Eksv05J4JSLavJjoKEV08CvemG7JWhhJ9HQoEgfUs0irB6EwmxDDnlBtgiU8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/06/26 4:43 PM, Usama Arif wrote:
> On Wed, 10 Jun 2026 05:35:43 +0100 Anshuman Khandual <anshuman.khandual@arm.com> wrote:
> 
>> Add some print formats for pgtable entries at any pgtable level. These new
>> formats are %pp[g|4|u|m|t][d|e] i.e %ppgd, %pp4d, %ppud, %ppmd, and %ppte.
>> These currently support both 32 bit and 64 bit pgtable entries that can be
>> extended up to 128 bit when required.
>>
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Lorenzo Stoakes <ljs@kernel.org>
>> Cc: Petr Mladek <pmladek@suse.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: Andy Whitcroft <apw@canonical.com>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-doc@vger.kernel.org
>>
>>  Documentation/core-api/printk-formats.rst | 19 ++++++++
>>  lib/vsprintf.c                            | 58 +++++++++++++++++++++++
>>  scripts/checkpatch.pl                     |  2 +-
>>  3 files changed, 78 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
>> index c0b1b6089307..e69f91a9dd9d 100644
>> --- a/Documentation/core-api/printk-formats.rst
>> +++ b/Documentation/core-api/printk-formats.rst
>> @@ -696,6 +696,25 @@ Rust
>>  Only intended to be used from Rust code to format ``core::fmt::Arguments``.
>>  Do *not* use it from C.
>>  
>> +Page Table Entry
>> +----------------
>> +
>> +::
>> +
>> +        %p[pgd|p4dp|pud|pmd|pte]
> 
> s/p4dp/p4d to match others

Will fix.
> 
> 
>> +
>> +Print page table entry at any level.
>> +
>> +Passed by reference.
>> +
>> +Examples for a 64 bit page table entry, given &(u64)0xc0ffee::
>> +
>> +        %ppte   0x0000000000c0ffee
>> +        %ppmd   0x0000000000c0ffee
>> +        %ppud   0x0000000000c0ffee
>> +        %pp4d   0x0000000000c0ffee
>> +        %ppgd   0x0000000000c0ffee
>> +
>>  Thanks
>>  ======
>>  
>> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
>> index 9f359b31c8d1..d4ad3048a4db 100644
>> --- a/lib/vsprintf.c
>> +++ b/lib/vsprintf.c
>> @@ -856,6 +856,59 @@ static char *default_pointer(char *buf, char *end, const void *ptr,
>>  	return ptr_to_id(buf, end, ptr, spec);
>>  }
>>  
>> +static char *pxd_pointer(char *buf, char *end, const void *ptr,
>> +			 struct printf_spec spec, const char *fmt)
>> +{
>> +	if (check_pointer(&buf, end, ptr, spec))
>> +		return buf;
>> +
>> +	if (fmt[1] == 't' && fmt[2] == 'e') {
>> +		pte_t *pte = (pte_t *)ptr;
>> +
>> +		static_assert(sizeof(pte_t) == 4 ||
>> +			      sizeof(pte_t) == 8,
>> +			      "pte_t size must be 4 or 8 bytes");
>> +		return special_hex_number(buf, end, pte_val(ptep_get(pte)), sizeof(pte_t));
>> +	}
>> +
>> +	if (fmt[1] == 'm' && fmt[2] == 'd') {
>> +		pmd_t *pmd = (pmd_t *)ptr;
>> +
>> +		static_assert(sizeof(pmd_t) == 4 ||
>> +			      sizeof(pmd_t) == 8,
>> +			      "pmd_t size must be 4 or 8 bytes");
>> +		return special_hex_number(buf, end, pmd_val(pmdp_get(pmd)), sizeof(pmd_t));
>> +	}
>> +
>> +	if (fmt[1] == 'u' && fmt[2] == 'd') {
>> +		pud_t *pud = (pud_t *)ptr;
>> +
>> +		static_assert(sizeof(pud_t) == 4 ||
>> +			      sizeof(pud_t) == 8,
>> +			      "pud_t size must be 4 or 8 bytes");
>> +		return special_hex_number(buf, end, pud_val(pudp_get(pud)), sizeof(pud_t));
>> +	}
>> +
>> +	if (fmt[1] == '4' && fmt[2] == 'd') {
>> +		p4d_t *p4d = (p4d_t *)ptr;
>> +
>> +		static_assert(sizeof(p4d_t) == 4 ||
>> +			      sizeof(p4d_t) == 8,
>> +			      "p4d_t size must be 4 or 8 bytes");
>> +		return special_hex_number(buf, end, p4d_val(p4dp_get(p4d)), sizeof(p4d_t));
>> +	}
>> +
>> +	if (fmt[1] == 'g' && fmt[2] == 'd') {
>> +		pgd_t *pgd = (pgd_t *)ptr;
>> +
>> +		static_assert(sizeof(pgd_t) == 4 ||
>> +			      sizeof(pgd_t) == 8,
>> +			      "pgd_t size must be 4 or 8 bytes");
>> +		return special_hex_number(buf, end, pgd_val(pgdp_get(pgd)), sizeof(pgd_t));
> 
> You mentioned in the coverletter that pgdp_get() is the reason arm32 builds dont work.
> Just wanted to check what the issue is?
> 
> I had a look at arch/arm/include/asm/pgtable.h and I couldnt understand why
> it reads pgdp_get(pgpd) instead of pgdp_get(pgdp)?

Right - that's a typo.

Following arm32 pgtable header change enables the build.

diff --git a/arch/arm/include/asm/pgtable-2level-types.h b/arch/arm/include/asm/pgtable-2level-types.h
index 650e793f4142..3f1d52402129 100644
--- a/arch/arm/include/asm/pgtable-2level-types.h
+++ b/arch/arm/include/asm/pgtable-2level-types.h
@@ -31,6 +31,7 @@ typedef struct { pteval_t pgprot; } pgprot_t;
 #define __pte(x)        ((pte_t) { (x) } )
 #define __pmd(x)        ((pmd_t) { (x) } )
 #define __pgprot(x)     ((pgprot_t) { (x) } )
+#define __pgd(x)        ((pgd_t) { { (x), 0 } })

 #else
 /*
@@ -49,6 +50,7 @@ typedef pteval_t pgprot_t;
 #define __pte(x)        (x)
 #define __pmd(x)        (x)
 #define __pgprot(x)     (x)
+#define __pgd(x)        { (x), 0 }

 #endif /* STRICT_MM_TYPECHECKS */

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 982795cf4563..349e1f819385 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -141,7 +141,7 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,

 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];

-#define pgdp_get(pgpd)         READ_ONCE(*pgdp)
+#define pgdp_get(pgdp)         READ_ONCE(*pgdp)

 #define pud_page(pud)          pmd_page(__pmd(pud_val(pud)))
 #define pud_write(pud)         pmd_write(__pmd(pud_val(pud)))
>    
> 
>> +	}
>> +	return default_pointer(buf, end, ptr, spec);
>> +}
>> +
>>  int kptr_restrict __read_mostly;
>>  
>>  static noinline_for_stack
>> @@ -2506,6 +2559,9 @@ early_param("no_hash_pointers", no_hash_pointers_enable);
>>   *		Without an option prints the full name of the node
>>   *		f full name
>>   *		P node name, including a possible unit address
>> + * - 'p[g|4|u|m|t|][d|e]' For a page table entry, this prints its
>> + *			  contents in a hexadecimal format
>> + *
>>   * - 'x' For printing the address unmodified. Equivalent to "%lx".
>>   *       Please read the documentation (path below) before using!
>>   * - '[ku]s' For a BPF/tracing related format specifier, e.g. used out of
>> @@ -2615,6 +2671,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>>  		default:
>>  			return error_string(buf, end, "(einval)", spec);
>>  		}
>> +	case 'p':
>> +		return pxd_pointer(buf, end, ptr, spec, fmt);
>>  	default:
>>  		return default_pointer(buf, end, ptr, spec);
>>  	}
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
>> index 0492d6afc9a1..f68955858e29 100755
>> --- a/scripts/checkpatch.pl
>> +++ b/scripts/checkpatch.pl
>> @@ -6975,7 +6975,7 @@ sub process {
>>  				my $fmt = get_quoted_string($lines[$count - 1], raw_line($count, 0));
>>  				$fmt =~ s/%%//g;
>>  
>> -				while ($fmt =~ /(\%[\*\d\.]*p(\w)(\w*))/g) {
>> +				while ($fmt =~ /(\%[\*\d\.]*p(\w)(\w*)(pte|pmd|pud|p4d|pgd))/g) {
>>  					$specifier = $1;
>>  					$extension = $2;
>>  					$qualifier = $3;
>> -- 
>> 2.30.2
>>
>>


