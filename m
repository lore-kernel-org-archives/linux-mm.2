Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D85FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD7D06B00A1; Wed, 29 Apr 2026 09:57:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAFB76B00A2; Wed, 29 Apr 2026 09:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CECBC6B00A3; Wed, 29 Apr 2026 09:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC3306B00A1
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:57:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7044B8A2CB
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:57:38 +0000 (UTC)
X-FDA: 84711746196.22.54CEBA1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id B68664000B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:57:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VZYMMPru;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777471056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQtZTpELJ1liX6xujaqBk9rq103ELoK9RGJIqb5f6ZI=;
	b=BtbZsX1hnlv1maJ9qYNJIastsJG2DkViJdXMocGe1XEU+ZG5XzuPiHhTSxm0XnudbhjeEg
	3HlsMVup7W3PeNiG9rv3MLo0nE5/imSzj7Yb3MhqAvN7HQQ8/EPv0E4vJXtZiwsYL4B/sR
	vWgyE4ENRlSImm1Qh7iOJvG6iF763wM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777471056; a=rsa-sha256;
	cv=none;
	b=uG1DFXgk9difwqZiVrtnVSYcSt1QNnRC5SZ7q598svwVnojUcV5ZR3Y64m5ch9sqhn5n6t
	KXt6yUXQDc+LJcJQRQFgZ7gCfEE7NkLdGDvYpqeJwLwJ9rEwSgUM0bAhPj1iWl3ypYfMhS
	WWRYQng44ZD7kNiISRbwNi+ufKcGJ8A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VZYMMPru;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FB45337B;
	Wed, 29 Apr 2026 06:57:30 -0700 (PDT)
Received: from [10.57.62.76] (unknown [10.57.62.76])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B54813F62B;
	Wed, 29 Apr 2026 06:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777471056; bh=51AOjeUHqGDov+TlvZ961wTG4/ToLBw1MVjjZ/EnINw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VZYMMPruwp21m0Xl4JeKfECbeTob5+cc9VVBwFqewef4YFQpd9Inm1HT5mWQ5/6XG
	 ItElSh4Ig+yLgjTKWv4g3SNaz5OOVx2Ve3sKphhXFiZ/dF5OXmmvFug+NBjU9oGbIA
	 5KSpb9He9n9hVC8WDP9z/KmEA1lJ8qPdpTJ9HzCk=
Message-ID: <21a547ae-7121-4cd1-b203-4d8182eb7cc9@arm.com>
Date: Wed, 29 Apr 2026 15:57:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 15/15] arm64: mm: Remap linear aliases of the fixmap
 page tables read-only
To: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-32-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260427153416.2103979-32-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B68664000B
X-Stat-Signature: b95qqc64sy96dhtjhmfhgjwhcp5fackq
X-Rspam-User: 
X-HE-Tag: 1777471056-885826
X-HE-Meta: U2FsdGVkX180gCBGpX9EkCKCBUK5MPMJ5Z+iRPqX4vvKV6naZ3IRIUy6l7xVECEF8IyQJKdwykuO9/g2eGtpfyD1RkgPWKfLs4zAgBduUb1A1FesbVu7EYqN9bjsH0dzGNL4A6h1T4mzXdzUzWa2oNiZ8BSDVmWE3ZIfCO9E1HRQR2wqPXKf3VQkwqyBnG2xYSo1l0iHmgGWcr2FNZmmZUiKNCMMrBIrf6qtvwgbz4auOjCwmC3TuEBSoAfkBtpZGcbqCDRbVAg3aoNvbUpGwIndCC4G2fJzK7hsygIdSoRY38z/p7DFqVZB/SuKblycRabfm0WaCDZhQxBy/HbjZJdzHOxcjARzaVHbq/sNb/PbSA/zrH5hdTa8gb1MFKrc/KleoekM0jkQhgdN/Gsxrid8C9Pe3S7uKN4Jto+DT3+zjfIqRGZHKpww2D3ufTdMgSn+emSc1HfEt+Lw3viPAiEe4223qI8Enq/dzy2Vx73cgG91WLKAT3bARVHS0HfyIzx9eZjjHXUPWMLx7Il9RjLE0sV28d5FzApWyx09eLCLmoiHA7bpSNxN1JLKW+E0iGDysZx576SpaYLwRZ+jye/dTlJ5cwlvCJnrD6KnLCRbsN7cSDPOZd7gi4f2eANGVqWaqiZlVLnPHnAaUyFZacJZDFfCP03iUmaCpMQjonZqfJnO+t5e4kJKINVua2AYEyCxYc4D3K53SztDfq5NgKAFsiLO+lVo4E9847UAwmtJV/Z1+1Aa3lWNm1enTIoAlo4ZE22DMiE+vo4vUhY+GR/BDAr+2je1H6LTUPFBCfu9fAGJrNf7/TQArbvtUlpNGOKBOhqnEnR/yZvlc5xKu9+8RKZpwvYtqwQigLPdB7eD3cprrhT3amuzuNlcQZHcFGH99WeDchkzYyeSCckfBOHIfLqMcwdJvxoArQU4A6vEc5pm76hgKlnYK/0ckQN55fqMhm3cTsGH/t8Qs1S
 COl+lnwW
 6ouZhc+e4sFLuUIHZjOQZ6lbYG425gSE7D4GiLl7b9geTvbKwNwpBJwU7EkPYN0WguxJPOHsbm9XiNnqlHOP8h3r9Phj3M0jYl0eijO7G0MzgRU390mPxeUihduNtVE2E9IKlrwLTTWbgkjxWDnd2RJjmFiHFxiigribpn+yXe+PsMqu9PNezG+PzgE2991dWcTBXlR13ELB/paDPxPOUIegduqL09BO2OJY3Rat1qylt3ZaU7IHzeYC8EvyMd+XPpZhW+2k/N6EKgrCmfcpiFxlqsSAuWRAar+/NB3xbj9nlhRGK3U2cH36u0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/04/2026 17:34, Ard Biesheuvel wrote:
> [...]
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 84d81bae07a7..e76fe5b0c5fe 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1076,6 +1076,11 @@ void __init mark_linear_text_alias_ro(void)
>  			    (unsigned long)__init_begin - (unsigned long)_text,
>  			    pgprot_tagged(PAGE_KERNEL_RO));
>  
> +	/* Map the fixmap PTE table at __fixmap_pgdir_start R/O in linear map too */
> +	update_mapping_prot(__pa_symbol(__fixmap_pgdir_start),
> +			    (unsigned long)lm_alias(__fixmap_pgdir_start),
> +			    PAGE_SIZE, pgprot_tagged(PAGE_KERNEL_RO));

Is that definitely just one page?

> +
>  	remap_linear_data_alias(true);
>  
>  	if (IS_ENABLED(CONFIG_HIBERNATION)) {

