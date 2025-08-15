Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15F8CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 12:00:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C5518E01F1; Fri, 15 Aug 2025 08:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39CAA8E01EC; Fri, 15 Aug 2025 08:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9E68E01F1; Fri, 15 Aug 2025 08:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 190F78E01EC
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:00:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C15AF1A012C
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 12:00:16 +0000 (UTC)
X-FDA: 83778848832.03.3D09B39
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9687620006
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 12:00:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755259215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=faS9aKsYo+kMSuRXBtsCQxNAk1nb/xXS1Q3KueB93ek=;
	b=vnNMf4UehQXhLCD9lU1RR4Ekx7tU24F3JW7KMJ1ReDmulv295eoN/sFC8bOaapDCPcbJVJ
	rZWPClJ2GKdKYhHhFsuASXfup3T2vSjg9aRXd/4U13p9NWevplltr/KCBBAgzh05asGoTM
	Kgv8v1sc1GlnH9t0W97SWEb1ggEF7tQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755259215; a=rsa-sha256;
	cv=none;
	b=09uCSfmVWBVw81krLhfNsyzI7372rt8JmryGFk0kKj8r7C9ULR5DmcxD3cVMbVDQI753he
	4yFFoMLbj2oaQWy8IyO2AXVLGfaD5uL32nqGeoTEWncR6aMPp69FB072qQSgYJVGou1XHA
	Z/WnOVpzffzf3+9qu120ZAwUAsCCD1g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B3531691;
	Fri, 15 Aug 2025 05:00:05 -0700 (PDT)
Received: from [10.57.56.228] (unknown [10.57.56.228])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E4A373F738;
	Fri, 15 Aug 2025 05:00:09 -0700 (PDT)
Message-ID: <34ce1000-8d15-4d7e-bf67-11e2bcd135a5@arm.com>
Date: Fri, 15 Aug 2025 14:00:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64/mm: Update create_kpti_ng_temp_pgd() to handle
 pgtable_alloc failure
To: Chaitanya S Prakash <chaitanyas.prakash@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Ryan Roberts <ryan.roberts@arm.com>,
 Yang Shi <yang@os.amperecomputing.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Zhenhua Huang <quic_zhenhuah@quicinc.com>, Joey Gouly <joey.gouly@arm.com>
References: <20250813145607.1612234-1-chaitanyas.prakash@arm.com>
 <20250813145607.1612234-3-chaitanyas.prakash@arm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <20250813145607.1612234-3-chaitanyas.prakash@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wo5m9duy7n6aojqotak1ju9njec56nxd
X-Rspam-User: 
X-Rspamd-Queue-Id: 9687620006
X-Rspamd-Server: rspam01
X-HE-Tag: 1755259214-614589
X-HE-Meta: U2FsdGVkX19m5JVc5P5P8NubcrwiBftcvmBI8Vu1bKanxocXNkD9UK7IiOnUL01+DxqfmqoHfLJCuVEBtIGqGteJ+ofgN89ih5fyZgli1Hs9dfoZmFiogkjrfNfiAvZJr6lym0XJLKsPxPElCeyh2EGXXHaota7pu29wHt6Qa/H1Te3NYd/BJc4aW8/NEHtDOHe0Mq9cZ/6bxbeHVn8IwTNi6zhNAWFYehye/9DqOSXPIhxXJQ9NT9c4lClrxoXiv68tFaFAocFDq4Q6uvsNznTnf/ndA4LljjjE0YQZvuARSyu6tBY8JRuZTdo4UN+DIrETWBoD8RXeiuk+mTz+LVV6q9xFbFH4nkvpMgZzTx1RNtgabuSGi6ZOd1y1lbjI4BRsO3D36QHks3RwrS/TCKnq5SwartHJihdbB152OMXdc880v6kl7Dr5O0lgjaFVy7kThltRjGszDtZEwRF3IQJEvNRW5rrkTzmUzUUoLCJPygXM0TTlmjqBi94GFIalabfVcT4rHbWLeY5A2Zbu5TuI3QuWgsmTEBoFj5PKH16dkLkleGFENanHn9/3fwg0bwZM6dvMhcADFWQmFyx+UbxDBY+/ZYY+sDnuJnRcmPrEshc9ox1TBX+R2fOCmdPqozngMznDQfMpwFcFwmoC1RC3Sb+62kcAWrHUqcEH08O1WmgcADjKooc3OhFtQNELeTDi2j1CUzq35nulDc6BxMyJAYhHqxaCeiOXIQumLLueG8LbjtWYy7d/IgT+K7Pj5oWahZwdoijnfPhBv7hhreCrZfefyopPFzQKuQq0jzHnuqqVa7GINUx3l7rvqhXnXKP1wPAf7sAoAxpp5y0TzJ+C/qtX2/SoCgRBaxKk2/bGt7IMhT/u1Tj8KUQOwtyvOl4IK8qhY5feDDs3dSeBbON7kIdSSEhMy2+26WeM3+uQM9O5FjPy8/Ym+v5rawB7D3r4EB+XTAZgflX+Q2e
 PILy3WTX
 5IirdV1VeLGdP4unxKQjaIjG5IWIWABNOvZzlErogIUvpFqNCtCxLjfI2hfmSFsVHBonhCyLAqVn9J0WSXt1fBf+zsUkKnZ1wiX00Xaj/zgND1ktrT6irs35ytlKNwcG2xmWDd4MJ8ICQx5u6Xi/iMYBNDEK2rRzWGza554Vuja8iHVQKzv1pans3Q0jvaNJN2VZoWeFyPPQz+zKe2s+BmyK8yB9hRQ/CAQ7oOQek9OGrCHI0JQa3iI6Msw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13/08/2025 16:56, Chaitanya S Prakash wrote:
> create_kpti_ng_temp_pgd() was created as an alias for void returning
> __create_pgd_mapping_locked() and relied on pgtable_alloc() to BUG_ON()
> if an allocation failure occurred. But as __create_pgd_mapping_locked()
> has been updated as a part of the error propagation patch to return a
> non-void value, update create_kpti_ng_temp_pgd() to act as a wrapper
> around __create_pgd_mapping_locked() and BUG_ON() on ret being a non
> zero value.
>
> Signed-off-by: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
> ---
>  arch/arm64/mm/mmu.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index db7f45ef16574..19cbabceb38bd 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -76,6 +76,14 @@ EXPORT_SYMBOL(empty_zero_page);
>  static DEFINE_SPINLOCK(swapper_pgdir_lock);
>  static DEFINE_MUTEX(fixmap_lock);
>  
> +#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
> +void create_kpti_ng_temp_pgd(pgd_t *pgdir, phys_addr_t phys,
> +			     unsigned long virt, phys_addr_t size,
> +			     pgprot_t prot,
> +			     phys_addr_t (*pgtable_alloc)(enum pgtable_type),
> +			     int flags);

I'm not sure I understand why we'd now need this declaration?

That function should really be declared in some header instead of the
strange declaration in cpufeature.c, but that's unrelated to this patch.

- Kevin

> +#endif
> +
>  void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
>  {
>  	pgd_t *fixmap_pgdp;
> @@ -541,11 +549,17 @@ static void ___create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
>  }
>  
>  #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
> -extern __alias(__create_pgd_mapping_locked)
>  void create_kpti_ng_temp_pgd(pgd_t *pgdir, phys_addr_t phys, unsigned long virt,
>  			     phys_addr_t size, pgprot_t prot,
>  			     phys_addr_t (*pgtable_alloc)(enum pgtable_type),
> -			     int flags);
> +			     int flags)
> +{
> +	int ret = 0;
> +
> +	ret = __create_pgd_mapping_locked(pgdir, phys, virt, size, prot,
> +					  pgtable_alloc, flags);
> +	BUG_ON(ret);
> +}
>  #endif
>  
>  static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm,

