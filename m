Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DCDF606A323
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 07:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=P+jtgdTX
Received: by kanga.kvack.org (Postfix)
	id D0CAC6B00EF; Fri, 30 Oct 2026 03:14:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBD3C6B05B1; Fri, 30 Oct 2026 03:14:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD30D6B05B2; Fri, 30 Oct 2026 03:14:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9AADB6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:14:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D8921C3E3B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:14:39 +0000 (UTC)
X-FDA: 85378429878.05.703815A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 43B151C0004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:14:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=P+jtgdTX;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793344477;
	b=m9ac3V6knTLC5tMBVwPeb1uZCxdVDx6vKlwmsI2n5JK3n/8eIu/WSukJZd3WVGvrfr/Cma
	i+4mvJepKGc6Gq8iIYSvrFD7lsges6OYeJ/ewFdMeLQCadb0SB6kjb/70KLfG0sTKjSGkC
	isAKVuufrkyF/JGChJ8mKU8+O4RkAZs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=P+jtgdTX;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793344477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2nwqEX6uVZ+D8u1+rxu1eIxt49K0H72sg6V9JucXvs=;
	b=v0vaoH0Lw6mAlOhTIBnDB6Dk61emSaxRTLmmAgJ+4KW4USgaXWihP0yBoSJAXmkIO+Wq12
	AoTA6Tr3RpfRAfOIA6RzNZhHgdtyqv+Hf2GwwL6km6njY+9MkxSsp377RR7W2aw8IS1D4v
	+TiGcYQ6YZfQepPnZxoJ1cNVZyjOQDU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1101615A1;
	Fri, 30 Oct 2026 00:14:33 -0700 (PDT)
Received: from [10.163.152.232] (unknown [10.163.152.232])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D0273F7B4;
	Fri, 30 Oct 2026 00:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793344476; bh=Jp/eodRxYkJLNGQk8olzS9xG6qObIMTBg1q6BMVZmBI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=P+jtgdTX69sEy90NVnhYUwff1Df/OdYgDe+/Oll2oU0iv4SgMtAerOkfvpkn4fqBX
	 bHrTkw2g7dShto71IFHPDpjzFhRFcDPHxQhkGP7LbYYciMVEjNypabXr9lGoDG0b9P
	 Dl6AC3L9oAHxYeXPdZCnniBAcCySVpa1QB2Dy4po=
Message-ID: <99f529e8-06f7-4a20-a60b-0330c5d3d91c@arm.com>
Date: Fri, 30 Oct 2026 12:44:26 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/10] mm/vmalloc: clamp an unaligned range in
 vunmap_pte_range()
To: Hao Ge <hao.ge@linux.dev>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>
References: <20261026080329.140244-1-hao.ge@linux.dev>
 <20261026080329.140244-4-hao.ge@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261026080329.140244-4-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 43B151C0004
X-Stat-Signature: g55c7a7a1153gt6axix78wyy3gccbi9r
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793344477-462442
X-HE-Meta: U2FsdGVkX1/3LJnIJSD069fZTgi6CHuHz+9yvo6P8Ixe1gGvwMTGmUgoOBhSAmm8T5U7Fsk5/twzfW5bWUn6l7XHJE6hsEp5KhgR8lA5deepflb6/h/meroxrvDP5DeN23C0ddyvAeolzIiCWws7VSj41F3srifMtRGDy4rPi9cZm5dHkiQGVAMfPrzziN4ZPZmqxm3ZRh+3+vdbgh2SWXHvB5UjeeC3OtMT9Vnv4+XpG65AStCam3iDrAlGaxgzxZTAXMW2xLjlikfs1pyixJsQ4NToN12ze3afxtgJXjWveRH0tZYb75iC4scEJ+7a19/rJW4Z+cu0Wom34RthlowxzWMdokjtwfh8LdOcU3SJRf/DxHPBnc//eyCQYL9GPlEKe1rhbK1Hs7U8fvhetnozL6FumPnwi16oAJKXmnhlKOkfdJZkuvbXNH9cje0R4YkuqowSfEyTLSF4JqizK1MQWl2lopnfYG4E8eWLDlkhG2IN3f/xbYx5EuKmiZX4+njlQcy/RZCwlaWIWoQT3SmjYSimWucNJJQZADYkCZ/tv6vbdtTTMjMMYzxGkTThpoWaxGBLNHerCymW/dzBzHk3yPwMOq6Nth1fyTOoBe+sSPoXG4ih0bsVEIffnzgGRraNWAElKbE0aLnHhYESnyheDG28aaWR/wBG8J0CN2cEHbcTgJW9IYW4F2O3p+I9Y/DfpcHorPYpeczjnJhV8rqpFTsf7lOzxJ89/K131Vc6UD19c32sz04AS6N7FW8Y4Mi1koXSPeGQ+4N97M3oGRmmNzvCn7s1cqCa0Ui0jSUjgSl30xE75kMbPc6wCkn9FhXuicf63+38KrnCXbg3eo7h86955A8QMNFg/LiWYvpBV3FNEttxpSv79ZyrzFwN2qpREqIaSTVpNrRV1pzZNPWLNcO9xVx/adIOh9gWPw92OesuchOZnn9lZmOxAFhqHO7/65P9Md7Ff2grlwx
 UjiZk3fw
 rD4F9R0LtpQcrq/p3rIqQ3P4hHw4pfCOXPTBuhFGtwKdAh8hoAk17UQP33+FOtUNRsDgEa1zpeDjXq8/t138LvCFX6P/HFh3Q1NPB5xUjqXZ7WHPXA+AMUD8/WdPBLKPqnjrUF8Ls0Ac6/dtfZsjYiwydJH8StHObnhMhmQ5XD4TBRgQFDxfoGZ7vGGQQeDAKRpx1CJHSIQoWQwntb5i7V4fqq7hbYDgafmhZ09/0OxKRBkLFVh+3FHCFI7SRNoMcXvGYXcudoAqewud4711EEjk1BuwC4TRCfT7Wx7KSDMxweOOdMU4KPQ9rPChfU4t7wPDfs3bcmfTyzJNouiRp30OasfNpJci9KwlqT+8G8RMWGzU2UPMmQnwZI4eJ/QXoOoEO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 26/10/26 1:33 pm, Hao Ge wrote:
> commit a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not
> PAGE_SIZE aligned") made vmap_pte_range() warn and bail out when the
> size is not a multiple of PAGE_SIZE. That loop steps in page

Why are we checking the alignment so late into vmap_pte_range? Why not
simply do

if (!IS_ALIGNED(addr, PAGE_SIZE) || !IS_ALIGNED(end, PAGE_SIZE))
	return; (or return -EINVAL);

at the start of vmap_range_noflush and vunmap_range_noflush?


> multiples and stops only at addr == end; with an unaligned size addr
> never lands on end, so the loop cannot terminate and walks off the
> end of the page table.
> 
> vunmap_pte_range() has the same loop without any guard, so an
> unaligned range would clear PTEs past end without ever stopping,
> walking off the end of the page table.
> 
> Add the check there too. The range is clamped down to the last full
> page rather than dropped, and the loop is skipped when nothing is
> left, so a buggy caller still gets its PTEs cleared as far as they
> go.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/vmalloc.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 44e0eb32708f..7131f60d1a8e 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -393,6 +393,11 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	pte_t ptent;
>  	unsigned long size = PAGE_SIZE;
>  
> +	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
> +		end = addr + PAGE_ALIGN_DOWN(end - addr);
> +	if (end == addr)
> +		return;
> +
>  	pte = pte_offset_kernel(pmd, addr);
>  	lazy_mmu_mode_enable();
>  


