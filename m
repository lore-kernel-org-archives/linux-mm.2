Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9C0CCCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 02:10:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AB5A8E005E; Wed,  8 Oct 2025 22:10:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 282798E0002; Wed,  8 Oct 2025 22:10:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BFAB8E005E; Wed,  8 Oct 2025 22:10:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6FC8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 22:10:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A2A691A0890
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 02:10:19 +0000 (UTC)
X-FDA: 83976946158.05.413A061
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id EB3F7120007
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 02:10:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xgZom7xpWp/qR2Y91TVHKC9tjRGVEXTCKsbJ2b8YVG0=;
	b=Mh/KoGNbBsznihoHCoofbVI630DNktcbjN5YjyYL//eeT9SWG5UdkyeHp1MNY0qlw8Z62b
	WmpBKTAQXlZOToE8unA2FSCrpHvRtAmTfxyYgxZcl0taAoRITfDf2LWflnGxGJKfKudye4
	D0ZylhI8818G/k8eMLMqA3UBMR478B4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975818; a=rsa-sha256;
	cv=none;
	b=dfKoNwuLWnBLHEsrDxtYoaMgpF1uVNt+8k16mvcUB3srTm+Jn31rdKfiailt4llLhC+gxS
	QYrGuYv59QPtUOB1YqNe2xkepVO1R4l0xGTeEMFsX9SQeu3dNToBb79cn91Z/Mif3BBA+c
	fVA6Un2Kj14N6eCcH8Pii4A9tQbMpOA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06F7422FC;
	Wed,  8 Oct 2025 19:10:09 -0700 (PDT)
Received: from [10.163.35.84] (unknown [10.163.35.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4DDB43F738;
	Wed,  8 Oct 2025 19:10:13 -0700 (PDT)
Message-ID: <c6371fa1-af9c-47b0-988f-aae3d7fd58e7@arm.com>
Date: Thu, 9 Oct 2025 07:40:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/18] mm: Always use page table accessor functions
To: Samuel Holland <samuel.holland@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Conor Dooley <conor@kernel.org>,
 Alexandre Ghiti <alex@ghiti.fr>, Emil Renner Berthing <kernel@esmil.dk>,
 Andrew Morton <akpm@linux-foundation.org>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
 <20251009015839.3460231-5-samuel.holland@sifive.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251009015839.3460231-5-samuel.holland@sifive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EB3F7120007
X-Rspamd-Server: rspam02
X-Stat-Signature: yphyith6beiebjcawrdm7x4ggy4tf8x7
X-HE-Tag: 1759975817-320873
X-HE-Meta: U2FsdGVkX18QMgEk44VmJMx8vrGgHopvHE4GHDd2uRxMykfijZziRRueGAZhiCqjyjksujE1Vp9IK3xQMo8/Nb9HtE4VEdSn2oqg3DAdEgm/AHLPCLEmGhnxxdS0DPWy9fT0BuVF/alFCT2WIQGLYbtnW2RSBny8PR4/Jv0vQvrQ1LkK4AGEXtTWP7rg77X+/9ub+HfrhnTAae0XARZsesm5lXnVzL1UjWDG/Min7n1LuY6u5OY7ySYVWptv2qkUBLhrnEWm/Fu7oWD27j97LEbolUAvobrMm0BacEc9Z8G/xuJ1eEKZu7I/oT+9/5e4Rsx9MEFGfpDlbHdVkJvXqpZu93XerNGZaa2pLbPIBHK7+51vTsppt385qOBJAqvb2z8HJ5stbcZrHlZC2J8J94ZpWU1wBFxwktxzlvIQ1JwtIXODNyqqSI91d7J0s22ywCXzSsh2R3p2tQKypKt7rXQl4EORGA8PldSBilbfK8xxhMLfK8LYgDlh0Q1c4Kl5NH61gHF5gLcBJBD7hwTUOtI94uZlEGZR8u+MbXB/cFfNFvLcpuiFyreNKLa4X7SMvdn7oLVlv+01Sx+J29DT+FSiTUaPjSxFJYQssVozQyWSu/kYjM4OY94MBD5mRD6qTPLcDQu/DMoCUKk3cjhrN3REkFCb05EskofxVeHhPPofEqA360QiewagcMZTPhektg9aGnWh77XzywikK/ppDBpnIzun+ySKutYyKn2cqcFssgFTIugd9v62PicOTNVIqK/oHm+npy5ydQYD0xwEHC6HZc2LwdC0OX4cVulyWVLRqSraaeq7Ptv965doh9skoG8sOXq+7+qHHn9LifLeFuisiiChouFZBTI6+7RdJUBNxkJ+UthR5zpcPSA/RBCa9dB/9yBdn9m0gzgIosnLQu19tBHH4pa48PkGEiWxibkQeZ+HbPbCVOjlRUWhJJx2jGTVHwoZuLayM3rA+Ru
 HMpWeksL
 PqkLVOpwrawc06k9Cp1MDxe12m3iErNHQjaSjkwzR1whKpWNrR3HgnO6NmlyW5UEdOZCZ7ruYeZ4e7MSHYrAn0Y6qLJ7bYIGUtGwH1Z3n79ft5lDbqCvDzHMGdZUFUePh3ICSghEU4TY50Yr4jHucEvUArEHQebwRxGIvxDg9B7ohlLONoCAFc2fQ6ThR3xxUrGT3d5GY/ndCSkkbBnK4XZB3KTizlm1O3fV8AQmC2MdUiPW10l+Oyx+bM+ZmDIgABiu5goLEfl+8IiiZkGlgl+sWEx0dCZpywNeu0QAKt1opXl5NhxT2+NF2DwVVq1iY8kTyruxq6b/VcV4LItGmmVpUwCehV4fFfEHqdwU+c8xxx20=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/10/25 7:27 AM, Samuel Holland wrote:
> Some platforms need to fix up the values when reading or writing page
> tables. Because of this, the accessors must always be used; it is not
> valid to simply dereference a pXX_t pointer.
> 
> Fix all of the instances of this pattern in generic code, mostly by
> applying the below coccinelle semantic patch, repeated for each page
> table level. Some additional fixes were applied manually, mostly to
> macros where type information is unavailable.
> 
> In a few places, a `pte_t *` or `pmd_t *` is actually a pointer to a PTE
> or PMDE value stored on the stack, not a pointer to a page table. In
> those cases, it is not appropriate to use the accessors, because the
> value is not globally visible, and any transformation from pXXp_get()
> has already been applied. Those places are marked by naming the pointer
> `ptentp` or `pmdvalp`, as opposed to `ptep` or `pmdp`.
> 
> @@
> pte_t *P;
> expression E;
> expression I;
> @@
> - P[I] = E
> + set_pte(P + I, E)
> 
> @@
> pte_t *P;
> expression E;
> @@
> (
> - WRITE_ONCE(*P, E)
> + set_pte(P, E)
> |
> - *P = E
> + set_pte(P, E)
> )
> 
> @@
> pte_t *P;
> expression I;
> @@
> (
>   &P[I]
> |
> - READ_ONCE(P[I])
> + ptep_get(P + I)
> |
> - P[I]
> + ptep_get(P + I)
> )
> 
> @@
> pte_t *P;
> @@
> (
> - READ_ONCE(*P)
> + ptep_get(P)
> |
> - *P
> + ptep_get(P)
> )
> 
> Additionally, the following semantic patch was used to convert PMD and
> PUD references inside struct vm_fault:
> 
> @@
> struct vm_fault vmf;
> @@
> (
> - *vmf.pmd
> + pmdp_get(vmf.pmd)
> |
> - *vmf.pud
> + pudp_get(vmf.pud)
> )
> 
> @@
> struct vm_fault *vmf;
> @@
> (
> - *vmf->pmd
> + pmdp_get(vmf->pmd)
> |
> - *vmf->pud
> + pudp_get(vmf->pud)
> )
> 
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> ---
> This commit covers some of the same changes as an existing series from
> Anshuman Khandual[1]. Unlike that series, this commit is a purely
> mechanical conversion to demonstrate the RISC-V changes, so it does not
> insert local variables to avoid redundant calls to the accessors. A
> manual conversion like in that series could improve performance.
> 
> [1]: https://lore.kernel.org/linux-mm/20240917073117.1531207-1-anshuman.khandual@arm.com/

Portions of the changes proposed here are already in discussion
and fetched for testing via mm-new/everything.

https://lore.kernel.org/linux-mm/20251007063100.2396936-1-anshuman.khandual@arm.com/
https://lore.kernel.org/linux-mm/20251006055214.1845342-1-anshuman.khandual@arm.com/

