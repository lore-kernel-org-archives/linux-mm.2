Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4857CF8FA78
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 14:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFF6F6B008A; Tue, 21 Apr 2026 10:15:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD68B6B008C; Tue, 21 Apr 2026 10:15:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ECA16B0092; Tue, 21 Apr 2026 10:15:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FEA76B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:15:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4334DE5DAD
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:15:53 +0000 (UTC)
X-FDA: 84682761786.13.3374E43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id EA740140002
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:15:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i9oQMpZI;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776780951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o1x2h0wvQDBS8Fe01hhrP9Aa7KDi1bMEIo5/RIYJiEE=;
	b=LEjBZXFhZSf+yKzeHIJRlYZWZdfkK4n4J+HlBG9bua+ktuuiNqC4zvXPe02IcH2dFGkUnY
	Mcq8RD7kXa4p8wOutZ+Cm2DdBsUBS+aYxEyENGrHeXHNOEbfGLlAPAoFAQzDBfYlMz9DVb
	ea0MoMXGZ8raUbAjljv2guAufnMS/m0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776780951; a=rsa-sha256;
	cv=none;
	b=mcCscAJw0/mfXR6Ec2Dcx7KJOBsXukQloWkSXXW8GiTHXXwK/pna1OqvmM+P42sWPCp/ae
	p5XjAdG4s23M71QBa604+Ua3oonO1+XZ4LDCM0r0OcnLqgEEpJfMJxhzMDR/n6dYYHIu2w
	vr44grQp0ULV3yry2/CCydEmbCgrgAs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i9oQMpZI;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E6112404EA;
	Tue, 21 Apr 2026 14:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854CEC2BCB0;
	Tue, 21 Apr 2026 14:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776780949;
	bh=078Y92oKtVm6JEaZesj5rhwZKMHbAna64KrdSsEQIfs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=i9oQMpZIY1uhH0+44ae33445UDB7IEPaoe2usB9oftVTiBX8AcKxOtWv8uH66qByp
	 XySy4CfY73X8OEb4xzEKEvLyvipLaEFw7NCEIlLzX/Y7EE8N5c5YePSRIGkvJFPR49
	 evHp/0KXRFY5FuLpU3yi0OwUYfKSh/fiPrAcn7LV4FpGV0u+i8BWXUUK/Mq+M7y+2s
	 qozO7v8Lm/LBKkeNIqaS3JLEYCg0p3PpyERV+sXgIaLDIuZCNjNsTiSUeViGLhrBGO
	 DSgnJWiHAdi3rHLNfo6jq3bI4a1Lt/AaAy1QHnF1TMBQcJYpT2s8I+eaS68VakM/Fq
	 8M3L04tqtNvcA==
Message-ID: <3daccad8-cf08-4543-b9ec-b34711a4ed14@kernel.org>
Date: Tue, 21 Apr 2026 16:15:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] mm: Make lazy MMU mode context-aware
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1776264097.git.agordeev@linux.ibm.com>
 <8809412aaed8a515fe2e149c822543d640060936.1776264097.git.agordeev@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <8809412aaed8a515fe2e149c822543d640060936.1776264097.git.agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jskibrwt9kiazk4wdbo5561k6kxmxt1q
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EA740140002
X-Rspam-User: 
X-HE-Tag: 1776780950-732132
X-HE-Meta: U2FsdGVkX18Oq43vsbwnafAu7xcJhcTZrAVACS1kXSlMvD2B5FmvpY4XbWv/kkqZSCSiEuiu8OUMA6wSw0rrt1i6YCRJ6s4N3hLVfmm7EG9jXooTCGnctvLD/h8pedGwT1qqOWIxd2QHgS04ZDPwNdPYOXr3ShJTGgDgNXK4c4muShTWarRzsIjbJftl1jRNZzApSdjE/n/qDJ58LY0002v8aOxRZOxDM3WzK3nEr6eVJES6JKgT8esd397zWhNhTjh0VGoiYEbwDZ9GbTJH6jsuNfa+d6Jt3evktx6sDa9op8AT0C7GiLrjtgzBE+XfLCczFvraEKg27U3DzswB7KUUCP1u3GX6yVnxVnuCnJSqkCPALGstN6aDYKzFn+Iudpl7ttPK/wkXI1+PJCjYKgS1gnSoEfVFj4GAJLOGDL3zw1GRJVteVkDnTumk2lacFhq78fjeH0IqEFlgdbj4XlzX6lCp9ZFt01ol6rtZt+ThqE8OoDugmWkxde5izXbPhp5zYWyDh5bIA4l/4kY+3LbFTUM3ZykM9Rxb9uSkTC+V0vBbhb0JMNk5cVYPwfK9+Yfq8Vm6bEuu/MWeveVc4o2Zty/xu4szzcMSQZm5P9U5zqUdqIIFY+XQi8xv3/0hUkcWLYA90GmGEaVQiZfet5RVy/y1RXP218OmN9I5OjFLtx/5ZpYagK6960GmrnJ1X1OYiqBlThSLjSy5+yEV05UxATMWZiLI2U0ZvwjvrG+AcRn4MHtC37zjkv7UKf/c1IgqKL4KqNmmY/Gm+5KWXQi6wzWSNSWMAq8JSFU9T+1EugvegeezON83qJvTYHeVAfcF4VcZwDuYo14RuZsXAd79eLs1wlY3b62a8EV/s2dfRHKrnzB73Er2O14RV42FS1JsJ9qfeV/FC8bZkcxH2UMGPFwGPjtBy0giU7qkAJvdKt45T6aD/79cybqi63PAp+VR7LOcyo929l9EB0t
 cmUYpApc
 zBA9qDQ3LyyDNvCqm8wCwEFYXc7CXcc1Kav0qF8gq1w7+uK6q6QWDJQXLF087pmSbez4YgyNoCZO9pnId82AjLssGTatyjk8vSJFCSwP//ESmDOZro32Kkzs8yfq5/QQPyvgziTMNBjQrsu/yWJpXMjstDpV1wBmriKbk0riu7Rl2JoHonMT5W1+XjmFF5D8Z+7yDVBp6QdxKEo73ZWk/fLnkfy6y/psYkClDBiwSY3GsRVOzGhOAt12Se6dzHGqyjuJA33Uj6lZDbxIh69CuPOX+e/qSYiWH5/aiEHSXv8K7GUlsxeSnDJ3+/CSKtI4QOQto
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +/**
> + * lazy_mmu_mode_enable_for_pte_range() - Enable the lazy MMU mode with a speedup hint.
> + * @mm: Address space the pages are mapped into.
> + * @addr: Start address of the range.
> + * @end: End address of the range.
> + * @ptep: Page table pointer for the first entry.
> + *
> + * Enters a new lazy MMU mode section; if the mode was not already enabled,
> + * enables it and calls arch_enter_lazy_mmu_mode_for_pte_range().
> + *
> + * PTEs that fall within the specified range might observe update speedups.
> + * The PTE range must belong to the specified memory space and not cross
> + * a page table boundary.
> + *
> + * There are no requirements on the order or range completeness of PTE
> + * updates for the specified range.
> + *
> + * Must be paired with a call to lazy_mmu_mode_disable().
> + *
> + * Has no effect if called:
> + * - While paused - see lazy_mmu_mode_pause()
> + * - In interrupt context
> + */
> +static inline void lazy_mmu_mode_enable_for_pte_range(struct mm_struct *mm,

I'm still wondering about a better name for this. "enable_for" indeed
sounds like it's only for that range.

Maybe really something including a hint like you previously proposed

	lazy_mmu_mode_enable_with_ptes()

	lazy_mmu_mode_enable_with_pte_hints()

I think lazy_mmu_mode_enable_with_ptes() is neat.

Thoughts?

In any case, on the general approach + semantics:

Acked-by: David Hildenbrand (Arm) <david@kernel.org>


> +		unsigned long addr, unsigned long end, pte_t *ptep)
> +{
> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
> +
> +	if (in_interrupt() || state->pause_count > 0)
> +		return;
> +
> +	VM_WARN_ON_ONCE(state->enable_count == U8_MAX);
> +
> +	if (state->enable_count++ == 0)
> +		arch_enter_lazy_mmu_mode_for_pte_range(mm, addr, end, ptep);


Okay, so the "hint" is ignored for nesting levels, that works.

-- 
Cheers,

David

