Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D3F5C98305
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 09:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 609836B00A0; Tue, 22 Sep 2026 05:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B9BE6B00AA; Tue, 22 Sep 2026 05:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D01A6B00AB; Tue, 22 Sep 2026 05:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D7176B00A0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:02:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A90D51A03D3
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:02:57 +0000 (UTC)
X-FDA: 85240808394.27.CA61D82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id E8D5C1C0003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:02:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e17ouVhx;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790067776;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JnhzTAx413FwpdKahXPNOcr3FwWYv2J2Y6dhd+67auQ=;
	b=F6ACPV7t62+xTujc63xuh+6GggOjWh1H4mE4g9wLdSCqqI8Mj0AeshVaWvCMyjma1JYZ8a
	qd0B4t9boA6xmxZDfqVhwOTjw6LUtPppCP41TVFbqvpIlCNPJ7Zz3j1BV669gHAYb++8f2
	ysR8ruY0rOsCnkEFSZGUzA0kLhcf45A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e17ouVhx;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790067776;
	b=afyd32GrhZbFnwqJ9bxOJTI8heepizWKrkJRgjONO/i9EyZyNl/+0lbtJkvy4a0YsfekQG
	232zvemskiO+bn+PFIls+SJ1xesMFJmkR9I35dpVLLlBuDV1YFe2dWVjC8qS2oo+qpZUlg
	GzyQAC0X6Xo/RXHSlb8AjuAQ0vcQRhU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FB6740C4A;
	Tue, 22 Sep 2026 09:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01541F000FF;
	Tue, 22 Sep 2026 09:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790067775;
	bh=JnhzTAx413FwpdKahXPNOcr3FwWYv2J2Y6dhd+67auQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e17ouVhx7pCa4EJXvSkinhLyV94jWOdGlljXb86UFt04mTtWxN7lu6AysEmUU3QLo
	 AY/5/KTGz63a1+nHe+QBAv7i9L3bkjvPynyjRfU1ZKNv39Ud+MifCRynvPn4HfDheh
	 /qodv7Z+OrXbHXZqlzP36IohhsehpVwOMtTCPMRaUWthRowSEohGKneZhUzEIWf48B
	 +RQ0gOP/EPvltRkXJ/AL9wU/EPgrO8maZ0xKOAvkdpqMfAX5JcoShYoS+IQIzmWQkZ
	 cfWweH9aPTBakCZQdL3x6Uw1Z/VAMetOe1jYzWpZLI1Hjn9BkaGnmlNtDWAUYaCfP/
	 WkRJ8YEnGI6hw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 5/9] memblock: introduce MEMBLOCK_NODUMP flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wandun Chen" <chenwandun1@gmail.com>, robh@kernel.org, rppt@kernel.org, baoquan.he@linux.dev, m.szyprowski@samsung.com
Cc: aou@eecs.berkeley.edu, palmer@dabbelt.com, akpm@linux-foundation.org, conor+dt@kernel.org, bp@alien8.de, pasha.tatashin@soleen.com, ruirui.yang@linux.dev, mingo@redhat.com, hpa@zytor.com, saravanak@kernel.org, x86@kernel.org, robin.murphy@arm.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, alex@ghiti.fr, pratyush@kernel.org, kernel@xen0n.name, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, iommu@lists.linux.dev, dave.hansen@linux.intel.com, kexec@lists.infradead.org, linux-riscv@lists.infradead.org, pjw@kernel.org, loongarch@lists.linux.dev, tglx@kernel.org, linux-mm@kvack.org, chenhuacai@kernel.org
In-Reply-To: <20260922084256.1515554-6-chenwandun1@gmail.com>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
 <20260922084256.1515554-6-chenwandun1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 09:02:52 +0000
Message-Id: <20260922090252.B01541F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Stat-Signature: t8umenq7tn143opazdgj6cp93nitd1pe
X-Rspamd-Queue-Id: E8D5C1C0003
X-Rspamd-Server: rspam07
X-HE-Tag: 1790067775-92999
X-HE-Meta: U2FsdGVkX19DnufAI8lW7nXlX2uzVj7QZJETTcXhU9fJELEk2RuP1s2v2hSsAURanJT2gG3Xfc9WQ4+E2uyVqlXQ/DnqCHJdreuXN9BDwwzVWP98bLPXP1T0LKi8zkq/9M00vem0VwcgYv406V8EDrMCMhIWGMAdUC5K+krIo/1vxRHcb5qE/bClVqtTwvpSL/YnM68NU9jNSGqVN8S7AORapmsNzCp3FSG4YeEY5Rw6Q9bsO/gm9WrcImKXMzvaoCwUQ3j6J4euU/zSq0syRcK8Fq/l8mqqdsYQsb26iW0rBGimoRC0CDKLPdkGkvPEc7I8gR+OlcOn+KWasOds6qjtEcwXXGse0Lfc3FN4W4ZHDsUFlcpK2YPNnAkkYhWJGLKnEb7hg15wc8ffOX43pJsU1K2Ctneo3kGlhqrmISxHtnG9Bt3LeRfQv1MWBohLl3PVv8eWQdmTE4u6pJd+AfW0jPjKfno3A5QQPkUNPEx3/3glbQWbRYgyk7fA3fvxs2Es3XmDa6aq7CPCi/5CxhkF6QY7WPJm2xYK1iLcTFBOrXc9RWdMVvW1vyNO8vRYiHppfbf35OMA5RcQPy7qxrN2OIHf3Vc5UtWxCdF0C9AwNCJqsGJpryctTZ5zRMu48HLJTe7YjfbFgjiSL3pN3ktWWuwZaH99LXlHxrpp3FW5J/p45tBBrK0PV38JLIkdBxEI1ZaH0h1Y9kNia28em58WP0LSzIJCvU6KHGMZHUzjqqBRg5kPlPNOqnMy5Sdn/ZDlmkre+ravzq5veOflRL5xXas3AfWeh7XN3EhaxfKW8AupmiKI3VS939f1cid84dZpNDvnyqSNMmpIwVuUuVih/0k7iehq+SiK8i4irS/e6cfPKGfdsVrKZnO3P4EBU8800oM0EMITE8B6DrJuxFaJtf2TSoPQ48lCn7vh/TzjulZZ7lyON0D8r7OvRfZJaSEAEdrZ4HoM/quLzu7
 4bWAASaW
 cDcMS7HXqGw8aZM2JQgBtdDaiFYbnedAHkPYXEcyRfiF9vQvl3fEh2FAJF2MEa5iVnmJ/2rcwMEItxdHOSpuuqdPKffVMfepNiEuPniMCwvalPzSm1rDNqz3USEX2/EoC2PJHeeTXmS1EnI12/L/v5V3tRVa3Em0eKuUSDxpxOUIas+wYALaOczV/tsegKklOYn/y9XQhfuonZWU+NMyxAv7ZLRoDf344OFOtMxQKvXJNipyp7yK9MXZemm0f8qhJ/eWBNflRs3XsyLfVwsiLoLxr1ATdpCdt91CWDfKHKEEXp+xTedVvNZ6PwtirwSuABi3jlKlHp6Mdi4IaCiz0/XS7ld77cRDqkG3gtn+JXmCEjFqWeflr0QX3MMJrrIfLSos+be1/dpArCs+ukJ87DtKCsKnLLZXrxB6RL/tpbipW520fVHFggNAwO7UPEMsML6XMaHH9K3enN8+gU35H++erX1Jm/iomeyvp5cDN1XQEDFp52OGvp/7X+Otr4ksDeNBIaEWGLmh+14Fs3XpSBX6WAJ0Tr0wZgPwdagTwjOfd3T/oL3B5h+cN+LLKmxZkr5PvIloh3n4zi3cOJLQ+4G3bngk8vDWXhr79rBzsqfpFm/i9T4GIcwwVp3x8LzXl3VDb9nJ6zElvqW86FP3ISL4h+PVhqWevlaXis3meYyYv8KtLMkzm8+pR7vVZQNgVGXV0VnJrLkuvGeDSaDyYyvORAdDsOHVcY2qD8n0uA+Dpz3fmOMZr7VdRmxT4aOnC2gxcx9JrjRDFIPQtcLILX/7Bb4pv5tl4e5zZ6nUQRo83s9oBovccDwWljA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: lockless mutation of memblock.memory causes UAF in concurrent =
readers
--

commit 3e0d4f57949330268c708beeb66dc1c0fb65db32
Author: Wandun Chen <chenwandun@lixiang.com>
Subject: memblock: introduce MEMBLOCK_NODUMP flag

This patch introduces the MEMBLOCK_NODUMP flag to mark memory regions that
should be excluded from kdump vmcores. It also adds logic to clear this flag
when reserved memory, such as the initrd, is freed so the memory can be
properly reused.

> diff --git a/mm/memblock.c b/mm/memblock.c
> index ea0de4b5f3568..48cabfe5cdf16 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
[ ... ]
> @@ -949,9 +951,13 @@ unsigned long free_reserved_area(void *start, void *=
end, int poison, const char
>  	}
> =20
>  	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
> -		if (start_pa < end_pa)
> +		if (start_pa < end_pa) {
>  			memblock_remove_range(&memblock.reserved,
>  					      start_pa, end_pa - start_pa);
> +
> +			if (IS_ENABLED(CONFIG_CRASH_DUMP))
> +				memblock_clear_nodump(start_pa, end_pa - start_pa);
> +		}
>  	}

[Severity: High]
Could this lockless mutation of memblock.memory race with concurrent reader=
s?

This code path is triggered during asynchronous initrd freeing
(e.g., via do_populate_rootfs using async_schedule_domain).

Calling memblock_clear_nodump() modifies the memblock.memory array lockless=
ly
via memblock_setclr_flag() and memblock_isolate_range().
memblock_isolate_range() can split ranges using memmove(), which disrupts
array ordering, and can even call memblock_double_array() which kfree()s
the old array.

Concurrently, subsystems rely on memblock.memory being immutable after early
boot. For example, on ARM64, ioremap() calls pfn_is_map_memory(), which
performs a lockless binary search (memblock_search()) directly on
memblock.memory.regions.

If memblock_clear_nodump() splits or reallocates the array while ioremap()
is executing during driver probes, could this result in a use-after-free
on the freed array or an out-of-bounds access from broken binary search
invariants?

[ ... ]
> @@ -995,8 +1001,11 @@ int __init_memblock memblock_phys_free(phys_addr_t =
base, phys_addr_t size)
> =20
>  	kmemleak_free_part_phys(base, size);
> =20
> -	if (!slab_is_available() || IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
> +	if (!slab_is_available() || IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
>  		ret =3D memblock_remove_range(&memblock.reserved, base, size);
> +		if (IS_ENABLED(CONFIG_CRASH_DUMP))
> +			memblock_clear_nodump(base, size);
> +	}

[Severity: High]
Similar to the above, does this introduce the same lockless mutation risk
when called during runtime module unloads or CMA frees?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922084256.1515=
554-1-chenwandun1@gmail.com?part=3D5

