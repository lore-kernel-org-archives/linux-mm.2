Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C973CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 11:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D46EA8E000D; Thu,  4 Sep 2025 07:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E918E0001; Thu,  4 Sep 2025 07:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34728E000D; Thu,  4 Sep 2025 07:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B34408E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:51:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 575F2140147
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:51:17 +0000 (UTC)
X-FDA: 83851402194.12.CE5B960
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id B9440C0009
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:51:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ONZrZBBC;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756986675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PaUu8yXIfUVX4+XiuOu2bdl7lNOKQ5Py35yboYhpyqE=;
	b=pdh9PbNxTDjcEzqFhDYI+nlMRaPrabOAIJaeS0tZgwMMphann53i314RhfQlJUFyBjxaXW
	GweUzI0EpT8/oerlwEwUlWbNP/W9W2Y/kXtYYR7hecw6GWNtqx9E1bZPRJv/BnRr+25X5X
	X+AXcIjjT7g7RdPEIj7RCy3FhAeKY9I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ONZrZBBC;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756986675; a=rsa-sha256;
	cv=none;
	b=zC9Tv/PHoorRDm9gLvJLEGZxdPcCm5Dxv2tI8OCwP0tjNjABcZ8Q1keJG9IdlgRaPgzpQJ
	Ck83y2WWmojpEdV0DRyJbhmzyapXTRv+GSha1DMNBuYwwyneL/uS7v+KMBp/d0r10lrArD
	IQeRdHo0St0O8os5JCKOlvCjfX1KJvI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B905860212;
	Thu,  4 Sep 2025 11:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620D2C4CEF0;
	Thu,  4 Sep 2025 11:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756986674;
	bh=ayu+VFEFtlDXiKEZkYUc99UQyXAFV18iajSKbdBa3uI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ONZrZBBCpuGwxh7arUAFmUebG80sJLxBC4MYYjuLVToYlzCW6RgNeQ07liMrV5F0N
	 s/GiABu8diRs9Wt/8jy4v4GdTRk7UaVeB2bU3bZzobOKQryEy6GqMFzq3t2S1nPhmy
	 MYYXXmjZa+R/jKyVAYEHCunJx2vEG8gVEeWMRqTlPy2r3VPODqu98SYt3INH8q6udv
	 shoDQchLJ25xZPDhxEmUrOQCrsuE8Ft+HRhKOkDAURhrzQw8cQ9kMaWmoI2beur7nq
	 TLvA7seUnmO3BltYWiXoiXISFP+iXNO3ejHGJ8SKbLXn7BVURmvpmM9/uaf0fTxflh
	 /lCPuv3tqRbcA==
Date: Thu, 4 Sep 2025 14:51:06 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-efi@vger.kernel.org, virtualization@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 3/7] x86: Stop calling page_address() in free_pages()
Message-ID: <aLl9KneqOYTujcCh@kernel.org>
References: <20250903185921.1785167-1-vishal.moola@gmail.com>
 <20250903185921.1785167-4-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903185921.1785167-4-vishal.moola@gmail.com>
X-Stat-Signature: gcerqkha9k3oq16h3zcpf39w3z3i1z4p
X-Rspam-User: 
X-Rspamd-Queue-Id: B9440C0009
X-Rspamd-Server: rspam01
X-HE-Tag: 1756986675-446414
X-HE-Meta: U2FsdGVkX1/6dQ+4YQtz7DpGs6XRGD/JR40IopbTWlFaipSBQ1r2OeHn1VVzy+8ZIlqftaiELMvulcHxrjYAPERjPSboXeWnnFnlyQ6z9bFmIR0JXApjsNaaL04zi//BXjUkE774rA5JMzughbbJTWBm8sAxUodFuz1slvGDENoXqTLbT0i8ns9HAw9UUpOsS0ss3bIVvXn0CE/vuvMjvSEPKWHOfWqRA2WIgWCDcuWvVGjioaoRK+EnOa0Tc/Bl+iJaWCtxumdCRNqbhEHGt+utWH65/zOuEh2cIO3GIaVa2ZSnejENEc4aKVfdxW9uBa2juLdex6QYspAvAe83qcxQ19yTm6rbL89M+I02WRNJgCnxZF39NMyZTmbYzleIqLECy/SOxfmFDZCMyMhOp9a4Vx7yCzwndf4BqRmrJFYzBg0+i5X4a9Q7BE2iHB65tNNKmFoWEWp/QMZl2NMSbVmzpCEujpmgJLLkOjeRSZBpUccKWag5k3/Cr8pGytWtLpd2KKcXrptwX7nV+N/x56THRPtLhz+fTJcqWnrMJBzox/+7Dz1TQPB0tviHgs3/cytiRH50e6xfay7J/Rehme707ThmHHArfvv8+tZY8KtX5qApIyEq8HM9uRL4hPqPJi0reRfRbdaVsBoLsYlDHFYXkT1CbOutggEe9V95+/gUXmlOoDpKxJsum8+wljmVAYDf1F6wlnTBspPM7Z3NlS2M+zOfiX9kgHEtVL0zIXL8x5MBpxODWgwhhqiekPkUmiM7hl48ixDOdXjGKMJMhdEBTBQNXb2uLBwL1NJQhFvOL6duiv9hrByd6w9PDuy607FwjHsz8KrMsg9c2aNcjPLVu9lJBi/DJ5HNXoS3xnElNN1A2GCsFrwJ7T03F3cBEaki4KAS/nUPTNJ0/d5k54638mdMl/mzCueQ5QzX4Tt1owM7FV2Wp7WY2BxVRMreMn9LEFyu1Rr/8R7DC/+
 6FD28Y6r
 TmASasFjNkyBxxhHjUrx1hVgInma1bz6AuOK5uvNQoacgxHhvaOYQ5XDsg9tUnBApoLq8BZXu9YxZmpeW2oSmZhfz+R1TStt4D9R4u7oXdj/SvXld5ai82Emmy3qAvG5a0/7/QAKCo+rOusQpOp/ExDRL+5w/9cYV2gD/0neqN0c/MVxKsOUI15gcIshM0eAtEQfPsO2C1vEST4PscXmG7iDdRUvk5XA+sNk8BfZhupqNjUOib+jIQ/sU138jJYJQiZKmLkAWnGTJMGUJgbRdid36Rzwd3SXY6usnDXltHLJsfsh5kWPo09soMNEjz+H1gPzs7VtYGufcniUUrNyhuy/1m+zrczSb5xNNXdpr56ttLXBL2iZ9vRPFLeRiqdashnayQg+SQ6FEM2bADrhrdXX8rCZTuOgLu0lc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 11:59:17AM -0700, Vishal Moola (Oracle) wrote:
> free_pages() should be used when we only have a virtual address. We
> should call __free_pages() directly on our page instead.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> ---
>  arch/x86/mm/init_64.c          | 2 +-
>  arch/x86/platform/efi/memmap.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index b9426fce5f3e..0e4270e20fad 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1031,7 +1031,7 @@ static void __meminit free_pagetable(struct page *page, int order)
>  		free_reserved_pages(page, nr_pages);
>  #endif
>  	} else {
> -		free_pages((unsigned long)page_address(page), order);
> +		__free_pages(page, order);
>  	}
>  }
>  
> diff --git a/arch/x86/platform/efi/memmap.c b/arch/x86/platform/efi/memmap.c
> index 061b8ecc71a1..023697c88910 100644
> --- a/arch/x86/platform/efi/memmap.c
> +++ b/arch/x86/platform/efi/memmap.c
> @@ -42,7 +42,7 @@ void __init __efi_memmap_free(u64 phys, unsigned long size, unsigned long flags)
>  		struct page *p = pfn_to_page(PHYS_PFN(phys));
>  		unsigned int order = get_order(size);
>  
> -		free_pages((unsigned long) page_address(p), order);

Could be just free_pages((unsigned long)phys_to_virt(phys), order), then
the page is not needed at all.

> +		__free_pages(p, order);
>  	}
>  }
>  
> -- 
> 2.51.0
> 
> 

-- 
Sincerely yours,
Mike.

