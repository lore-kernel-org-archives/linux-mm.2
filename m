Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EEAE606A33A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SGMR0g2y
Received: by kanga.kvack.org (Postfix)
	id 2FA3D6B05B3; Sun, 22 Nov 2026 22:26:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D23B6B05B4; Sun, 22 Nov 2026 22:26:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210946B05B5; Sun, 22 Nov 2026 22:26:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D75796B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:26:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4940D1A077E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:26:41 +0000 (UTC)
X-FDA: 85464946602.09.9925688
Received: from mta0.migadu.com (out-79.mta0.migadu.com [91.218.175.79])
	by imf16.hostedemail.com (Postfix) with ESMTP id 40EDC180003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:26:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SGMR0g2y;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.79 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795404399;
	b=TDXPJkoZ0bToTnMt0Izww8ncVyN3yXEF7uS8vtlQ1t4eTNRdpDNW9Io5bVDaT4F0bCRuwa
	sIOtFPJblAtzMOWgkoDrJ9EFZ6COfARSDnrgx+YtCyan9fg58bBM1xpiBkiKTt1U/fPtVq
	Da53PjY8Bs5jawfge5rbcuoW4M9fJ/g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795404399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1+cegTBR/Mxg4hlkws6xLAzLLN9NMMKBynuAC4t3778=;
	b=0GsR982lllnO2ALwqNRxCFkFH9jtl2ob2wHkp7+umZpy+zw+pEqDDdtK3mTD7EsKZBBwLu
	IEHj5fh6qse92sm3rlReB+KHlD9bUcKj8xDluK3oGF81m23Jo+aItv1e8tG4ICETlRo3II
	FXhFCa/nZH9MXz4vJp4J3x1Oawau79w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SGMR0g2y;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.79 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TkbWYCa4MJQ1BBcXLO39QWi9ZKwMLeD/PRh+069eUio=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795404397; v=1; x=1796009197;
 b=SGMR0g2ysyRhEClMqRQFseFUIrDyr0M4S+pk0yHCer23GYL8Lvu578d2pPzUlcnTeK9mJr+i
 Xd1BziDVTP2R919tmNm966/at3n5YCHGBXAFsr2DJ5nFpLANzVzJxR+x/ypn2Y3eY9Jb1K2WD+J
 glEVjcZZEcd3nsoOdHacvYag=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2ca7b3a68f8feb45;
	Mon, 23 Nov 2026 03:26:37 +0000
X-Mizu-Trace-ID: 2ca7b3a68f8feb45
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 12/19] arm64: Support hugetlb vmemmap optimization
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261122184453.2668189-13-jthoughton@google.com>
Date: Mon, 23 Nov 2026 11:26:12 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Linu Cherian <linu.cherian@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Nanyong Sun <sunnanyong@huawei.com>,
 Yu Zhao <yuzhao@google.com>,
 Frank van der Linden <fvdl@google.com>,
 David Rientjes <rientjes@google.com>,
 linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <64639588-CB39-4980-A9E3-8423AB0DF268@linux.dev>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-13-jthoughton@google.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 40EDC180003
X-Stat-Signature: 7fkdtapp3mw7trch8yaoa5a6qkgntqy9
X-Rspam-User:
X-HE-Tag: 1795404399-963219
X-HE-Meta: U2FsdGVkX1+/DtaXaxsl3lnaSWuM37/ZptI0Zya8u7AqdlxxPtZrQdYuXzywv+YKFla+EwBC1wY+EWJZ4TMXfuaGzabVHwHZ+Xsx7EhYGwmQLdUBPYvB0pBNvjU9ksjCib/gvJaZ3ASOli+w1+l6t4Q6ib4F/REMj3xLaIQKFEONODLdJOJkeoYui04GQo3qPrLsmIH6LnS83+NFPSOAc9q8Dweovnq/PKzQKgzZAW6QEyhoqWx4zed2Fhe3taZWv/2Ub6i1yFNYgiTqA9Pd90kq5RdRuAjp2ictqxa20Tx5OvIuiItOMBy37W+SyrhuwCfQXLkiFU70ARPTT4fVLHN6CRfsWuu8I5gbRdcQ6W9wRL0+K3Y/SYTobBdUcSJstq27/d9W88ADXUZppb4dGFm4xhKsLb10ynar+A0NPqQ68rDq4ugKmKHqApHQdRGHZVgUK22gywOwrm0ELerBNaUdfRgoQoRuHiAFGHNUPBy0OjimLn68eHPwNbnd0J18or6E0MOl2e4K0nQr+14pBzhLzVHiTMhfXAFKL8TKeyrnIplC1YiFlDGm9516jYM52xz/z8B8C8fQsycb4HVKiA1VkYdaQRyM994ck4VD3wOrt1hEXHOzZtgVuVU5vwVXnBoXZ3SslI/7qRPnXE+iQk4Lta1vkoqBof6ISIj5ocE5mWrJgnhWiIZROvOYmr/65Hni9ft9AQZIA1dGqlBFNJ/WnVxlb4rfFonIOPaIj6vcfcTuv61cA5CR/4C+qp233yCGzUgI3iybqduS4upis1GMKTQPpr0a4OmTFda+Lqpqud7QQjbCc9qDDTvXfLdQAjc2OnVoUcdv9c+emffSt+JHvi6bXrt50WG/qeT+b1cUQJNvKKrFZgLyE1ay3iHmK/3N5hqVChfrG0bZgJpfDlokKbE9f6nsDK6FJuV42U7Bq8V1k5ZqSMjZe5gfSaq4gBfj7kqNRgH3Suma93s
 d3ajg5Sq
 A1azU5hMxvAxEh4ax1PIf/ugvTzHXVk9nFecMcuGB42LKAhFiBqAOgOOEMys2LNUEOKSp82VJ90XjTESXtMAuqiIoEUoNmx8dOhWYr/CkB6djLPIhw+29qqojCCjKxYgUY/Ey5vm98SWH06a/ahpVcWpfF0YY6BioAGhQrcDWTsN8f0Ii4x9kZn4UY84pSdEyVk6+2GYbbHINnkxpCCO2BO4pu5AR4DWNAI7+SHbnEvjruTR1DzveoB6wABsK4wETqUnHSvX643Ss8wT0qOYSJOigXpSi2Secp/TJhHmf4we36ToGvqQD+ZMCyicZl9zqyVf5pXfFDaft7WWfbBjuExEGi5GX2mgvM3f2cLnbezxzV/9bK0fDu4o1O8NtcbP9epg9ZADiiv6IIrccFvtefChKTWvdcCljlI1XJKtMpdAJHgVRX1wt3aJwWLTMUFFVWKBNu+JBvpphlB/e4jgw6fgglUrRLG4XseBlUPaWUDlv5QlMTjybC8DZDTlKZiq3LbLMe2qBRm7R3gS+/7sDOKC0Adx1UiSOc4No
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 23, 2026, at 02:44, James Houghton <jthoughton@google.com> =
wrote:
>=20
> Support HVO if HW AF and BBML3 are supported. These are the required
> features for the vmemmap to be modified in place.
>=20
> On arm64 systems that do not have the required hardware features to
> support HVO, the HVO sysctl will not appear, and any attempts to =
enable
> HVO (either via the command line or via
> CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON=3Dy) will have no =
effect.
>=20
> Because HVO support is only known after the vmemmap has been =
populated,
> disable the section-based vmemmap optimization in vmemmap_populate(), =
as
> LoongArch and powerpc do. Boot-time HugeTLB folios are then optimized
> when they are gathered.
>=20
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
> arch/arm64/Kconfig               | 1 +
> arch/arm64/include/asm/pgtable.h | 6 ++++++
> arch/arm64/mm/mmu.c              | 9 +++++++++
> mm/hugetlb_vmemmap.c             | 4 ++++
> 4 files changed, 20 insertions(+)
>=20
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 4cce60c2de66..b13618f0ace5 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -95,6 +95,7 @@ config ARM64
> 	select ARCH_WANT_FRAME_POINTERS
> 	select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES || =
(ARM64_16K_PAGES && !ARM64_VA_BITS_36)
> 	select ARCH_WANT_LD_ORPHAN_WARN
> +	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP if ARM64_HW_AFDBM
> 	select ARCH_WANTS_EXECMEM_LATE
> 	select ARCH_WANTS_NO_INSTR
> 	select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
> diff --git a/arch/arm64/include/asm/pgtable.h =
b/arch/arm64/include/asm/pgtable.h
> index 7421c0a048ff..5dadaac54bef 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1931,6 +1931,12 @@ static inline void =
clear_young_dirty_ptes(struct vm_area_struct *vma,
>=20
> #endif /* CONFIG_ARM64_CONTPTE */
>=20
> +#define arch_support_vmemmap_remap arch_support_vmemmap_remap
> +static inline bool arch_support_vmemmap_remap(void)
> +{
> +	return system_supports_bbm_through_af();
> +}
> +
> static inline int try_update_vmemmap_pte(unsigned long addr, pte_t =
*ptep,
> 					 const pte_t pte)
> {
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index a61464cf7367..bc3eea16004c 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -30,6 +30,7 @@
> #include <linux/mm_inline.h>
> #include <linux/pagewalk.h>
> #include <linux/stop_machine.h>
> +#include <linux/vmemmap-optimization.h>
>=20
> #include <asm/barrier.h>
> #include <asm/cputype.h>
> @@ -1843,6 +1844,14 @@ int __meminit vmemmap_populate(unsigned long =
start, unsigned long end, int node,
> 	/* [start, end] should be within one section */
> 	WARN_ON_ONCE(end - start > PAGES_PER_SECTION * sizeof(struct =
page));
>=20
> +	/*
> +	 * Whether HVO is supported is only known once the system-wide =
CPU
> +	 * features have been finalized, which is after the vmemmap has =
been
> +	 * populated, so the section-based vmemmap optimization =
(pre-HVO) is

It's better to avoid the term of "pre-HVO", It's an obsolete term. All =
infrastructure
of it are removed now.

> +	 * not supported. Boot-time HugeTLB folios are optimized later =
instead.
> +	 */
> +	section_vmemmap_optimization_disable(start, end);
> +
> 	if (!IS_ENABLED(CONFIG_ARM64_4K_PAGES) ||
> 	    (end - start < PAGES_PER_SECTION * sizeof(struct page)))
> 		return vmemmap_populate_basepages(start, end, node, =
altmap);
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index fb6da64bd80d..a01377c37c96 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -79,6 +79,10 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct =
page *head, unsigned long start,
>=20
> 		/* Make pte visible before pmd. See comment in =
pmd_install(). */
> 		smp_wmb();
> +		/*
> +		 * On arm64, this requires BBML3. Its support has =
already been
> +		 * checked.
> +		 */

Please don't add an architecture specific comment here. That is =
something architecture
itself needs to consider.

Thanks,
Muchun

> 		pmd_populate_kernel(&init_mm, pmd, pgtable);
> 		/*
> 		 * Modern MMUs allow overlapping TLB entries with =
different mapping
> --=20
> 2.56.1.809.ga0b61035b5-goog
>=20


