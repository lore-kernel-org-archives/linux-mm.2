Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99C20CA9EBB
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 20:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1F76B00A2; Fri,  9 Oct 2026 16:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879C36B00A3; Fri,  9 Oct 2026 16:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791006B00A4; Fri,  9 Oct 2026 16:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF396B00A2
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:37:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FE5DA028E
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:37:41 +0000 (UTC)
X-FDA: 85304248722.23.7158F23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id DB1CF180002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:37:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O27aeL/A";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791578259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+yeFjVcsD3mWs4RmXLpWFJvwlsWddLCnZ3D+sDgQnM=;
	b=1bgYsdYiCKnDBY8dFl0XOwhQo/2t4nh25JFV6Oqdwd730NpmQq+wh1QXlzXp662LKSWOiw
	k7FXtPWa2AXr+JDCzIqhW2DhQp7YUil9YuqMtbMWyJh7q5QwGxToSfIP8tPMA6YO82BWKc
	eP69mBwVMppfKSDwwfKGLgWA2ZjXiE4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O27aeL/A";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791578259;
	b=XmXgqOT1EF0aOBeFe/FD/DT9l69p/hkqUpoWZ5TxK4XcjbbO+0/vJG0O+JdflkeQk4dK5L
	AslFPM1mJdUENmbPtc0gqCgw2aY8EMRGZei5brB1kV4ZDjrN9FWZEWoEi45RozlgkrnI9Q
	c05aMfScfN6HNEsaZSnqEyXiBHmAMQM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 574BF60120;
	Fri,  9 Oct 2026 20:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633AF1F0089A;
	Fri,  9 Oct 2026 20:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791578259;
	bh=f+yeFjVcsD3mWs4RmXLpWFJvwlsWddLCnZ3D+sDgQnM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O27aeL/A2mRiLDoNKzrDT1uVXrflSw3am10n700SW41y6hC+GG5MGlriX6dfzn4Fg
	 Jxit3FTVr8Kbzew+hraP42StynheUxDySfg0VcS6c/x9S4Jnw9ikSQN2EFh5H5bnlm
	 gkfuB2nvqoUWAHdJyVt+VpKOpbbp7gBoPQMuInJQL6uX8GKE6gWQi1W1cVMdTYsXXQ
	 K+Uhnkf+7Usv1EXOPi9VorJ/tdeAM6XBQbF3PwGnnssjdEj2qevxVa3B9TW1/IyIFR
	 hy7d24L6EKK4M07DeudSftjs+uIqJfswJH8C+bPdy2M49j38/w+Tq33cAlJbq6bTlx
	 Zv3SmbIMSDWgA==
Message-ID: <664510b2-3510-499f-aab5-ceddfcc82581@kernel.org>
Date: Fri, 9 Oct 2026 22:37:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] riscv/mm: fix hotplug page-table destructor handling
To: Muchun Song <songmuchun@bytedance.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, osalvador@suse.de,
 dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, catalin.marinas@arm.com, will@kernel.org,
 mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 linux-riscv@lists.infradead.org, agordeev@linux.ibm.com,
 kevin.brodsky@arm.com, bjorn@rivosinc.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, muchun.song@linux.dev
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
 <20261008073021.2512665-3-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261008073021.2512665-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DB1CF180002
X-Stat-Signature: rodwpdqr7pe4x145unexi5p969s3iuxc
X-HE-Tag: 1791578259-954325
X-HE-Meta: U2FsdGVkX1/8eD/Fhx6F+vODE4YChZx4Sf8qOaTgDml93+r8zOMJzQHlLcVKpozUg7sD5G4FTVtvS1cNNph2RU/AKkmKkdtmgbsyRqwOAWesHWHTCLXiCuU3Az9/6CkiklaQmkeCTNHFeACVK6pDnglWqaB/uXbYIZ0hnur8Ync7es8rGK5Mo9z+EM41xYXby36NXm595xyYPh7dZ5WnZx7Mm2rW+8SHJ2Tjkw0Bhi5xmCuJhBUvun1b0mV7HsUZ9paIWaZ/Dc+XE2ZoTmSo7Wt1OXvcqAGHE+tDg4v3j6JybO12rGUAl1WO6dB6R2e3SVN6FemOkgXAnkaHt9BXK92aEb5mhhf0L7o6TPH0A3I2ygxJE56Awlv+X/FfRDUB2ZZ36MzklV3LC3ojROVHFLyfmQtHjz6SEUShcFvherZvJwEpLfUHrZEl9F9kcltsFqxFD1jIrKLi4TW079Hnl/3YCzG/Kgh/SP6r9d1SElUxtWGwKqcjRud155AVM6vLz5+3Go8Ie9ZglHRBOb1VLDNwkXfhqbiyEqZS736+b9TLSB+RGmpAInNjySFr0wVhPvXApz5zEYl+DLOniTzq4MpnhKFJPm6ulRpZsr63at05Es19DyXdRq/8q01ZcgwAaQWz303JTJtByX7o+jBrI/r5e9+unv4T3BQJSglb4aMTAgYTsR3JSRjLoRXsUZMI1z9VvhtVebhe6+ALRicsUlr4gUVI3h1J8w4LouVuWVW5ny7z70G0oaomopm2FxivuLStAi++eY1MdxWxqv6Ydtn5r8SNYU4agB+QjaoMrHOyS01oNewW9no76tT/wRMrIRHvRpdc0HtemNY8OhcEvHLq9QN8vEQU1u+CXGNkFmnv6RMphBBd5NiDiKDF0ft0AghNl9d5Nvkv4Gi09g+PorPafXGB+czhSyKII7fy6CypD5MVE1X22/QQQhbHqwpGhYAG0bmwVPcUvYWJ0uo
 Y3F+LEYD
 MFNeuEnLOzOJMHh/KZn/qASUeXq7nPmD6gfthXtrsgvf7ahPf5wJfkwANrw1XmMaR1dpvPBDKBN5gLT9/XOaJUDv9Qub4ZiULLjHh5etr/Yf4nLyR6HMRwphjhMvd5cFdnNj8iOcKh5FcUmqOT6M3XFAYOLK+dUWcyDu5CuT+4BexN48lXOfX6mFxIwHmqOHu6p8hBlisM1oeKlFAUx285tMgtgUSsQMoBheR8gfVUJx5MKKz3KGHi/x1Cx+h5IlPcj8Qh4pbyQNWZvYJ/ul4af+hoUX4QRytz84I3gbFMqGvPSC5/ICjErtxlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/8/26 09:30, Muchun Song wrote:
> RISC-V uses the same memory-hotplug teardown code for the linear map and
> vmemmap, although their page-table pages are not always allocated in the
> same way. Late linear-map allocations run page-table constructors, while
> vmemmap and early allocations may provide constructor-free pages.
> 
> The PTE path unconditionally runs the destructor, which is wrong for
> constructor-free vmemmap tables. The PMD path avoids that problem by
> using is_vmemmap as a proxy for constructor state, but that assumption
> will no longer hold once runtime vmemmap allocations use the normal
> pgalloc helpers.
> 
> Page-table constructors record their state in PG_table. Centralize
> page-table freeing and use PageTable() to decide whether the destructor
> is required. Keep reserved and constructor-free pages on their existing
> freeing paths.
> 
> Fixes: c75a74f4ba19 ("riscv: mm: Add memory hotplugging support")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  arch/riscv/mm/init.c | 29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index 857f9a55039c..429a0b015ec1 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -1486,10 +1486,19 @@ struct execmem_info __init *execmem_arch_setup(void)
>  #endif /* CONFIG_EXECMEM */
>  
>  #ifdef CONFIG_MEMORY_HOTPLUG
> +static void __meminit free_pagetable(struct page *page)
> +{
> +	if (PageReserved(page))
> +		free_reserved_page(page);
> +	else if (PageTable(page))
> +		pagetable_dtor_free(page_ptdesc(page));
> +	else
> +		pagetable_free(page_ptdesc(page));

Similar thought, can't we detect that in pagetable_free() somehow and avoid
requiring callers to handle that?

-- 
Cheers,

David

