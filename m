Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77DA6606A335
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 06:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LPUwG9DY
Received: by kanga.kvack.org (Postfix)
	id 69D476B05B3; Fri,  6 Nov 2026 01:10:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674A36B05B5; Fri,  6 Nov 2026 01:10:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B8B6B05B8; Fri,  6 Nov 2026 01:10:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2DBD26B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:10:04 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ADA3E1209D2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:10:03 +0000 (UTC)
X-FDA: 85403668686.26.01A2F27
Received: from mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9A59B40009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:10:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LPUwG9DY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793945402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=odu5xQIFS9JlM9FDfnwszB/Td3i57T5yLrDAwemp88g=;
	b=Yrpn1tit8edmf7KUQ/3xRu2l7H5u39zE+MTPKshtoEFjWWBf+xH7Wp+xHq/4BjirYcRz3Y
	0QC0hwVmI3+Ol0Y5ZXBXGc3XyXtzpOrI2KkjTV5CaX7vzoYbKg2Lt0qNBMYB4zk35h3xDY
	IL3b8kvTICmoBg7w5IbE1HfS3Ie0lPw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793945402;
	b=vpfl62r1q2kC9QYbBcWlBXEw9nLbQA/CwibfMsg8G12snuFMK87+qiwrZ2QeeB3khBFfUs
	L1TpUzElf11G5JJe5PaCLRxuCichDODMoX8OUEZNcGnbMpOkUv4V9EtPrxrOL4HWvUBTWJ
	8Yh/fqt9Qs1wZ61xRlkLO9OsCRfZu9E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LPUwG9DY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=96w6STjHwYkE35n2l9bpIcIdDPfklnzi3TLMb74lvdA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793945400; v=1; x=1794550200;
 b=LPUwG9DY+37Mw47I04qtDylr24akTAUKpuuHl+5P9OIhn0B4ba2SW/p0v/RPgl3W/VAkN+iY
 rArmYPbQoJE9dqX9LLgkA3iiCQ63d16uVHTV1yKiy/l7mkcFE5gJbU6PQ0Ouh1XS6bxXoTYFMM3
 d9L12BGO6tLvlABqfAArRQKw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id c4f90aeb3fa4551c;
	Fri, 06 Nov 2026 06:09:59 +0000
X-Mizu-Trace-ID: c4f90aeb3fa4551c
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 2/5] powerpc/mm: drop powerpc vmemmap_can_optimize()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261105080241.57241-1-lance.yang@linux.dev>
Date: Fri, 6 Nov 2026 14:09:39 +0800
Cc: Sashiko <sashiko-bot@kernel.org>,
 Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>,
 maddy@linux.ibm.com,
 Mike Rapoport <rppt@kernel.org>,
 akpm@linux-foundation.org,
 mpe@ellerman.id.au,
 npiggin@gmail.com,
 chleroy@kernel.org,
 ritesh.list@gmail.com,
 sshegde@linux.ibm.com,
 osalvador@suse.de,
 Qi Zheng <qi.zheng@linux.dev>,
 chenhuacai@kernel.org,
 kernel@xen0n.name,
 linux-mm@kvack.org,
 x86@kernel.org,
 linux-s390@vger.kernel.org,
 hca@linux.ibm.com,
 gor@linux.ibm.com,
 agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <2AB0A0B1-1613-44CC-A007-2453F6206D77@linux.dev>
References: <sashiko-outbox-198652@kernel.org>
 <20261105080241.57241-1-lance.yang@linux.dev>
To: Lance Yang <lance.yang@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: kjnz57zndp69fxcjtnoz7xpo4unaj7oc
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9A59B40009
X-HE-Tag: 1793945401-252261
X-HE-Meta: U2FsdGVkX1+HN7lstjQKiltOXhOJ/jFJp1B14gnNv2VZtyI3lrAIC2UNvQEDTS7iLWKAOQSQ8u2+r0eQuC04BVixJXzzKHofKlo/K7CPvBVWyg1ZCZzkH8au7+C622REqF8J8OZmne64XjPV67MkYIXOWS6922pcIDWrXf2unV177s7h3n2k6FGlGnDwkXTmwRfqeG1KiCOPp1cb/I9ZqlYlUiheLXrR1CQhjnIeBSho8zPyJkhAua70Dfxbt5HGh8csh04Lidky7oour6Q2idKHvkVBqGEotDToQTpDS1BF8OQ7t7W1g8u7k4/Lq3xvmHqM1Z+OqTS5hGMxJYLxP7h0INLjXCeIwXLXRZes9hWBXEKEaPYPoBauYEEHpJ9kU1LK0LkGgzaK0Ebk2B273q0gmvpKVHsrUuUEc+0d68dck8GjbD9N1ChLfwyCFqQDvDxnYSTM+Y1eqL2kgXmaCSpW+mko5oj6HtzaP1SzUM2eoIyDeQXwkw/gLpXnBdnR6im7qtD4eeNEfqahU/rr5yX9IDIvQPLK5wxNLDGootrNua8gVT1j4lvljYx2VRNWe8Z3czExhIlE2vCJrTsuaJXVdPdC3k+0E5JUzhGgSQrrz87Y425FW/2SsbdX/9BqXRR/mpD6CYr+RwQI6YdGsIBGqqSwLtTSpG+mN2meGJqUn7PZ2m1upDtiOJUOuPAAyvefyvySBjPN7YUUYxgm59pat5Xm9dpvsjcRZrzDlgQSNNXf8jV2IvVqOlWa1ZlqRSHzD2dfM1WzD3XrNpL4xQ0Xjasiw7utXXQaRjU99gh5OncTJEW5IaUF8ItOq+J+dKfLmlYlTTctj/VWNdIk4e0FpLQ+QVCispewInPWHSUKLLMBnFK9Ge5/3/IxvTjNXi4o+5JXxAspiPgE9ri/+MSfY1s4TdP+opeCFmC+0hns72RJsm3i/CQuOBnGdb/XmD3kYgOKCYr6VVR6HRK
 Zxj5y9r5
 NeP4Ai+d1W+76NeR/d1w/b9nTWFgkTx5m8kKDNE8XRsszltnoCzLFbGPjROur2qgP8fjjN1Ic0S1fNAiZ/GjRQ8BXnvs5NeNyftSSDg/RIdlfi41NDowYS7kAbtWnDJPhNZD8FR6GvtcclxCPe2OAHkqr+iGMDTPLCR3bdHzC5vOmVm4FmqwOSOa0qctm2vL9T+K2X9Iep/YGYsQKXg+IBg84hxVs1ITgJEBRm5YvVIxrfTvCG6l9GYziPi2pYDIcT7OGa60XBO7xTChOPLwpjAU6L0bcATUmiaVrmnmA9ScqvMSoWU0gRXpCO2hKVhbyLzXwvypNJdpA8+JywbHcyh86FlPfuzCo1ayiHKltYmVfDWJWf6YGMdDyZNiEBtZFxaUXQ1DeoutBNao+vEBq/fPPtO3cuHDUHrR1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 5, 2026, at 16:02, Lance Yang <lance.yang@linux.dev> wrote:
>=20
>=20
> On Thu, Nov 05, 2026 at 07:16:48AM +0000, sashiko-bot@kernel.org =
wrote:
>> Thank you for your contribution! Sashiko AI review found 2 potential =
issue(s) to consider:
>> - [Low] mm: undeclared vmemmap in =
section_vmemmap_optimization_disable()
>> - [Low] mm: define vmemmap_optimizable_order() before =
section_vmemmap_optimizable()
>> --
>=20
> IIUC, on LoongArch, asm/pgtable.h includes vmemmap-optimization.h =
before
> defining vmemmap.

Yeah. Really nasty.

>=20
> How about taking a PFN and page count instead, and leaving the =
conversion
> to the callers?

However, although this can solve the compilation problem, for the =
caller,
it is not very straightforward because they need to calculate nr_pages.
section_vmemmap_optimization_disable is only supposed to be used in the
vmemmap population path, and in these paths, the most direct parameters
are start and end. I think this function could be moved to
mm/sparse-vmemmap.c, and that way the compilation dependency problem
would be solved.

What do you think?

Thanks,
Muchun

>=20
> ---8<---
> diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
> index c91afce46136..5a3a225135be 100644
> --- a/arch/loongarch/mm/init.c
> +++ b/arch/loongarch/mm/init.c
> @@ -143,7 +143,8 @@ void __meminit vmemmap_set_pmd(pmd_t *pmd, void =
*p, int node,
> int __meminit vmemmap_populate(unsigned long start, unsigned long end,
> 			       int node, struct vmem_altmap *altmap)
> {
> -	section_vmemmap_optimization_disable(start, end);
> +	section_vmemmap_optimization_disable(page_to_pfn((struct page =
*)start),
> +					     (end - start) / =
sizeof(struct page));
> #if CONFIG_PGTABLE_LEVELS =3D=3D 2
> 	return vmemmap_populate_basepages(start, end, node, NULL);
> #else
> diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
> index 4d6928f717cf..43c98aec29aa 100644
> --- a/arch/powerpc/mm/init_64.c
> +++ b/arch/powerpc/mm/init_64.c
> @@ -283,7 +283,8 @@ int __meminit vmemmap_populate(unsigned long =
start, unsigned long end, int node,
> 		return radix__vmemmap_populate(start, end, node, =
altmap);
> #endif
>=20
> -	section_vmemmap_optimization_disable(start, end);
> +	section_vmemmap_optimization_disable(page_to_pfn((struct page =
*)start),
> +					     (end - start) / =
sizeof(struct page));
> 	return __vmemmap_populate(start, end, node, altmap);
> }
>=20
> diff --git a/include/linux/vmemmap-optimization.h =
b/include/linux/vmemmap-optimization.h
> index 9d9f7a67d195..0501234ab16b 100644
> --- a/include/linux/vmemmap-optimization.h
> +++ b/include/linux/vmemmap-optimization.h
> @@ -76,11 +76,9 @@ static inline bool =
section_vmemmap_optimizable(const struct mem_section *section
> 	return =
vmemmap_optimizable_order(section_compound_order(section));
> }
>=20
> -static inline void section_vmemmap_optimization_disable(unsigned long =
start,
> -		unsigned long end)
> +static inline void section_vmemmap_optimization_disable(unsigned long =
pfn,
> +							unsigned long =
nr_pages)
> {
> -	unsigned long pfn =3D page_to_pfn((struct page *)start);
> -	unsigned long nr_pages =3D (end - start) / sizeof(struct page);
> 	struct mem_section *section =3D __pfn_to_section(pfn);
>=20
> 	if (nr_pages < PAGES_PER_SECTION) {
> @@ -119,8 +117,8 @@ static inline bool =
section_vmemmap_optimizable(const struct mem_section *section
> 	return false;
> }
>=20
> -static inline void section_vmemmap_optimization_disable(unsigned long =
start,
> -		unsigned long end)
> +static inline void section_vmemmap_optimization_disable(unsigned long =
pfn,
> +							unsigned long =
nr_pages)
> {
> }
>=20
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 5777f2e29684..64bc346d0fc5 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -474,7 +474,7 @@ struct page * __meminit =
__populate_section_memmap(unsigned long pfn,
>=20
> 	/* Altmap-backed vmemmap pages cannot be optimized. */
> 	if (altmap)
> -		section_vmemmap_optimization_disable(start, end);
> +		section_vmemmap_optimization_disable(pfn, nr_pages);
> 	r =3D vmemmap_populate(start, end, nid, altmap);
> 	if (r < 0)
> 		return NULL;
> ---
>=20
> Cheers, Lance


