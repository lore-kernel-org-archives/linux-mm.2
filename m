Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F97ECD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9939C6B0096; Wed, 13 May 2026 04:40:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96A386B0098; Wed, 13 May 2026 04:40:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881276B0099; Wed, 13 May 2026 04:40:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78E1C6B0096
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:40:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 18242A05DA
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:40:16 +0000 (UTC)
X-FDA: 84761749632.20.0E82F7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 88B2C140005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:40:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=On2kQD50;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778661614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dd2jCgA0g+9Jt1cNOGSEycG7aM/VX2m51LI+39kcn5c=;
	b=vk8w71aToyI9XhYtpxyAGo9+s05fvkiczUckZMf79OP7EX1S4z1gV00VWPM8KqGQwm+juG
	ya/yarURpj9JvqqbUdmZuS/mIFORpA0KXzIOcKAQ0KlzR41xDeYD9Yi9lN8wN3RUkeMyfi
	mSS82CpMLKS+YXLFaLLHcek9BEWXcSY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=On2kQD50;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778661614; a=rsa-sha256;
	cv=none;
	b=xLe15pc/xNq0N2sjmg19dsF9SXPk/QlyhxkEELITfOxw2DidYT8yurr01ENPdoxp7EuAzA
	RtyxjlcRNnPQMmkoLYXFLWYPg3XE4MQhc4Finu0muo9zxyPMykfJSLVhDAhcZhwfCRkI2h
	StYvbSk4nE9x0Nm07QuKozf64vX2DV8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E5A7160121;
	Wed, 13 May 2026 08:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7544FC2BCB7;
	Wed, 13 May 2026 08:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778661613;
	bh=13LRFe622XguU1NLsfV3Ba6p09OZjDFhjXPDUplgOU8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=On2kQD50c1CeSLA0BlAVe3bh+GUVj4uncC/7cgHnMtbaOrrRDniULBC94dy6eSjz2
	 djLv6fWwvUdR+m85+VyTYLWyGPW1cp8lOngxujuunUkkTHFyvqi6iNQBMTMFHe3e6e
	 aTW03Op5p/T7d3KxJPF7AWzIDANS5U/x/W0pGNgFoLoBKlXL0DCvdQV1zf+aJFPPPx
	 FKUdczC4Y9UTrOVd25yGVEHsu+VFR/azqim6i572JU8Zum2z/G6jyDn/S29zSadSe0
	 kpwGcrcVJtwxyGRByZ9+vq6E2Wjjp/cxfoii/8CSxdmfaY3/tsBi/UVVNcU+Dymb+H
	 JRQtv3sKRxUKA==
Date: Wed, 13 May 2026 11:40:03 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 7/8] s390/mm: use free_reserved_page() in
 vmem_free_pages()
Message-ID: <agQ44zJDVpJXCfYJ@kernel.org>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-7-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-7-3fb0be6fc688@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 88B2C140005
X-Rspam-User: 
X-Stat-Signature: wdhpqqf74rbq8fq3uhxjf1qwc5tfcst7
X-HE-Tag: 1778661614-598291
X-HE-Meta: U2FsdGVkX1+7U3aCx6EZv32LM43Xl8qeL7lVp83N49sf3F0SfUPWrcwKDswEGiNUom9DRhei7nfxuX8aa/2BVvwhRTJ2V1Ot7t0P81BCrlUab+VD8WeX6VA/DT3E6N+XJ9zDHPKUoo9yl+t4/SqeYSq5JsGk4iyQZCxH9hIfk460qQKLYzrEhO6l85OJC3tNf+/cUyGG0m4H/P4oRbG6/f2DcaIMQrOnSgUROnLjUSLHibYtmYkrSgnjW0EQ5uxoKkidTpfgwqTZFPSETEFcwZof6yOm9NSDHlKboY8NeG21Anm+mBMcyKiKDgYLhRMN5AuznHl3+V0gEaeOG03G9rehsYnUVU1R1RWaedXO4ADDnR63yFGLO2O0hXgHI9Eyh4/Gs0XP0RNZ5iVDeOaipLNf89LMDEfvAGTDP7CLrW+074nhXppov31z5vuTXz5bEb/XsY/fp2JwWeK4dL2Mq4HuI7F6cB/O8UU2Pk4c8h6b+skLqj0GsTaRKp6Iz8BxxASIevypJvxG1NfpobV0db3/rTJJNOZYOXSnw7oA2raCwHucIsS4FdErsE8jvIhGmrsjdxyoEBkytGhITOr4Ecc1wI4fk9QBT4ahjQ6Mv2fugglc7Pw7zg1pjJ67oF1YWLN3vovfmymTaRTVDhCQeS+AEKZL7nmHZPGY4u1Ema/2yrdPQ6UOwa6MMKnCKcHNZg6axHnhoPXmuEBAnwBsEbSfIVr71JLLvH85LmdOi/8mZNo+ZIwoDu/qlMiY+zPJdRV4edZsIusTpUFG6grSgd+bdkD3u2n2NvujN61CnT3NuTARrZCqm9r2z7sUK/HUKokgx6hhIIdLJhMDOzwEtv+te3OQY2A0aMXZ6L0ZIU3wHUU6/F2G9JOg5IuXowdDu9IZHPhDFSJ+OGEVMhGOUwrhmCscpEtDQaHuiBnnNtofkqLEs1Hhm2lqfb9Kd878rLnaJ0CHh58OCR1FOHj
 TXqFnjMZ
 PGky/tnhJxFnwk4HASg/YuhazQq8eGpmn2HBPEdV8aUoQaBZ0yemaR9+6eXVdMt0pDBbrm8O+Goz6Duk25iZl5/P1j3pyhR4Lh+HTQjBEana2H6kHLYEPWUzS7U8bkhDcZ1RagXG1eHin5C4vO6sRptCeozxdfdnnxn9nAuR8M3/JH1g2KVnY0u/CS42W8KUtjTjmUjvNo8dVX4/sGU6uPJURd2aC4xkoBSKSq0OLR/4cgnrkL7JjkJVNmTvzScJVftNn6NfYkPq3OKg75MJIs6gkLMezVjfWvitqbrM/OxOkaW3kXCOjTOdFWpW47wcBCDQQX7CVM+vYP8S3GupgDHQwfREdImySoiTYKO/45EVKQJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:05:35PM +0200, David Hildenbrand (Arm) wrote:
> We never select CONFIG_HAVE_BOOTMEM_INFO_NODE on s390. Therefore,
> free_bootmem_page() nowadays always translates to free_reserved_page().
> 
> Let's use free_reserved_page() to replace the free_bootmem_page() loop.
> We can stop including bootmem_info.h.
> 
> Likely, vmemmap freeing code could be factored out into the core in the
> future.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/s390/mm/vmem.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
> index eeadff45e0e1..d8b2a60e0c33 100644
> --- a/arch/s390/mm/vmem.c
> +++ b/arch/s390/mm/vmem.c
> @@ -4,7 +4,6 @@
>   */
>  
>  #include <linux/memory_hotplug.h>
> -#include <linux/bootmem_info.h>
>  #include <linux/cpufeature.h>
>  #include <linux/memblock.h>
>  #include <linux/pfn.h>
> @@ -51,7 +50,7 @@ static void vmem_free_pages(unsigned long addr, int order, struct vmem_altmap *a
>  	if (PageReserved(page)) {
>  		/* allocated from memblock */
>  		while (nr_pages--)
> -			free_bootmem_page(page++);
> +			free_reserved_page(page++);
>  	} else {
>  		free_pages(addr, order);
>  	}
> 
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

