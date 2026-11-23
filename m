Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7806C606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MbmIxTcQ
Received: by kanga.kvack.org (Postfix)
	id 7FE5C6B00EF; Sun, 22 Nov 2026 22:22:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D3A16B05B0; Sun, 22 Nov 2026 22:22:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC1E6B05B1; Sun, 22 Nov 2026 22:22:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41EAF6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:22:49 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0859712079D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:22:48 +0000 (UTC)
X-FDA: 85464936816.25.29980FA
Received: from mta1.migadu.com (out-4.mta1.migadu.com [95.215.58.4])
	by imf03.hostedemail.com (Postfix) with ESMTP id D2E1F20002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:22:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MbmIxTcQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.4 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795404166;
	b=Hrg1/eCUnUTRzEL26UkWeWPGVnBsbeU47lHa7wDMXos2oKECslquXLJ3jV9HKjdd+7V7RS
	grHAcudH/T+sgJduWUw9GDO7PsSHr543Jr3Jx0wH63PgLdgfRvJmRMkVug48a2/SpiuhRM
	3WZlm/9uUSSQ89cDRrsryRBJmaQ2oYk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795404166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mmVRvdK02N6AgoL3Fkb1Slsd4s0/SBaF5vDPeDu6iRw=;
	b=aTgOqaCoFN+SskjyoqAUlX54jkJwwyFUzLoFB8f11umk3MhiqAqvLGiJi+nMtpeuVEqdTL
	Xblm6KOBcOp/m/bFKfjIO5uzNvjYRWXnRo+PTRGxFQ2c8Pdi5AW4pFUbAsQN15CXetDgrq
	QReUTB2sh8tBC62e9rSPPVJTLjREpYE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MbmIxTcQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.4 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/mnPk6TbiEx963fDemDdeJymjABb+Fn9UESDkxFlWro=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795404164; v=1; x=1796008964;
 b=MbmIxTcQ3G8tt5wpa6I92LbDuMVfs1806E7cCC5PBI2vMou21aB8rNHj0nuJts8H03VVD2PI
 9TAupc99w0fWffVFDQy168Kz8ejfAY9iYpPuItzqQ6Uyb/Izcz9NyUgvR3SABuMbZKKvSgRXEae
 vJQh1W78cvOAENKbObhR4Edc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a40b5ee157b951a8;
	Mon, 23 Nov 2026 03:22:43 +0000
X-Mizu-Trace-ID: a40b5ee157b951a8
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 11/19] arm64/mm: Align vmemmap to maximal folio size
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261122184453.2668189-12-jthoughton@google.com>
Date: Mon, 23 Nov 2026 11:22:18 +0800
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
Message-Id: <ED44F18E-E7FF-4B53-9B5B-3201F1100154@linux.dev>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-12-jthoughton@google.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D2E1F20002
X-Stat-Signature: ofg5b7qk345ce47ars3b94j3icjrourc
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795404165-576488
X-HE-Meta: U2FsdGVkX1/LFev3A8tfimzTEFSbGj1o9hLSmgRDsSno4zmyIa3+3FGZdKumF0b5B0IvxofCxYrJfXqv4c3wNmukEOeld2sORgKivwPf3mRh48jygZsMkBzEhjGr4gR/0eMR3pjxnQfqBd9MBHjQM5d7y5eeJaV065tA60SwR9JyHCmCe1/BRzW5gRyjRSsok55UxjvhC56ndXmgOq2WTNrQSdbxPMi1C4Kjl3JUcxm19aXJFj0ALEzsvkbhA3QbltFLxcXFn7b89ezr99BABCn2WitKiy5z/fUeGE6pt7CzNC8yIH4yGSfSZoKFgUAaW5moR/b90WbPb7tO94ziYnS3m4bmX750WKTsSsngQEp8qMi0LpvdqYVmES89D6XeLukkdEjijJTyTqp3f7BzaRRNi6oDBrBddxbV43yaoiv4crgfTHoC0EANAIo+BThbi5gJQfBS2+p+mns8LbRsvEGi4TSxwUs/5+DEnL6fMR+IUVdXUomyDjrZh3ASIo46qsbbL25FODJ+dICI0l6SzeFtGyCLoehcxD87c3z7ezLITzCYK+rHlYMYH36SquWl8nn8uPEfIvww0hCLKyhpTH0Tx6qNs3kkkEjD16CG64ACPxkK6zZMGvrBfXd44lzpnK11IfvtC5xXsl/1p59fvs3HgcmCXbRJFebeXe+KOn5nSnHut6HS7+MXOa0rYYKHQOebZmk8TpGVSWG1YKfw0j2RxueWdNBWLfJAiDikYjPXWbfe7Hmcs/h22KkLNyFQT447hf6spAmba4+pgLTHI6dqKKktvMCm+QU50SALn6E3qh3u3M/mO6XH0vjYGKyl4ERgjgq4V6LZAVyotsIw3qrA+P/3TNdlDmUFFGh/3EIc1FQxJ47ah1AT43F5C8IdyoFi/dHc6J2UIujjTi+8k1kk4omdeU5De1wYxcoSogncu6n05QBfHTZvRThdhQY+PB8u/5wFMU4mUbCt2Un
 pWpEpatx
 +I2OGht8YrD34i8cymR6EV+R5C0o8rsjzvWKTleGCR4oC/1M5mQRX03ZSMOEUl5WKqs817Nj6IVM6f2ubQ5DmdEUW+o6jZvX6Ip3CTnM2EhL5hJfntNvJwkFiYlUQNcb1BIgr0DSHkCCU7SxbLOjsb6IbrhYLC01lpCFENusHAkrigkyV/RO0cgeiSFrwoBJPpwsLWQ36RX8ZrXo/tHeyEwaAKkvGRLFs5xbJgaV96bPU2i0hjUdjtnt96+NuzoT2SRLj2/+woJZOe+Fw27sEvRBuZzEcen6cfqdI3Kj87eo+3umyWpBMBGKappqB8vdEiy5DMgMYJwVmMD6gXAbyFQTiEN4unVhQv84N8+IBnkxygZCKJMsEEBegvp4xL4ye0GJHC8S1O7vSHkfQfmXhzZf2LeBjl1MZG79WY34BF5KGs0C7XkSuNLpOrEGA2Y9BJz5Pjp9IFlRdEIMbhO92AF3qSSG7WwdEL19D/UrqvtJ8gX7vbRzcjF3GzA==
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
> With CONFIG_VMEMMAP_OPTIMIZATION, compound_head() derives a tail =
page's
> head by masking its address. This requires the head struct page of =
every
> folio to be naturally aligned to the folio's vmemmap size, up to
> MAX_FOLIO_VMEMMAP_ALIGN.
>=20
> On arm64, the vmemmap is offset by memstart_addr, which is only =
aligned
> to ARM64_MEMSTART_ALIGN: as little as 512M with 64K pages, where 16G
> CONT_PMD hugetlb folios exist. VMEMMAP_START itself is sufficiently
> aligned for all supported page sizes and VA sizes.
>=20
> Raise ARM64_MEMSTART_ALIGN to cover MAX_FOLIO_VMEMMAP_ALIGN, and =
assert
> at build time that VMEMMAP_START is suitably aligned. This is a no-op
> until arm64 enables HVO, which selects CONFIG_VMEMMAP_OPTIMIZATION.
>=20
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
> arch/arm64/mm/init.c | 18 ++++++++++++++++--
> 1 file changed, 16 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index 4e7682dfe366..7186d86afc41 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -35,6 +35,7 @@
> #include <linux/kmemleak.h>
> #include <linux/execmem.h>
> #include <linux/arm-rsi-cmds.h>
> +#include <linux/vmemmap-optimization.h>
>=20
>=20
> #include <asm/boot.h>
> @@ -92,11 +93,22 @@ phys_addr_t __ro_after_init arm64_dma_phys_limit;
>  * in the virtual address space.
>  */
> #if ARM64_MEMSTART_SHIFT < SECTION_SIZE_BITS
> -#define ARM64_MEMSTART_ALIGN	(1UL << SECTION_SIZE_BITS)
> +#define ARM64_MEMSTART_BASE_ALIGN	(1UL << SECTION_SIZE_BITS)
> #else
> -#define ARM64_MEMSTART_ALIGN	(1UL << ARM64_MEMSTART_SHIFT)
> +#define ARM64_MEMSTART_BASE_ALIGN	(1UL << ARM64_MEMSTART_SHIFT)
> #endif
>=20
> +/*
> + * With CONFIG_VMEMMAP_OPTIMIZATION, compound_head() masks the =
address of a
> + * tail page to find its head, so the head struct page of every folio =
must be
> + * naturally aligned to the folio's vmemmap size. The vmemmap is =
offset by
> + * memstart_addr, so memstart_addr must be aligned to the largest =
folio size.
> + */
> +#define ARM64_VMEMMAP_OPT_ALIGN						=
\
> +	PFN_PHYS(MAX_FOLIO_VMEMMAP_ALIGN / sizeof(struct page))
> +#define ARM64_MEMSTART_ALIGN						=
\
> +	max_t(phys_addr_t, ARM64_MEMSTART_BASE_ALIGN, =
ARM64_VMEMMAP_OPT_ALIGN)
> +
> static void __init arch_reserve_crashkernel(void)
> {
> 	unsigned long long crash_base, crash_size, cma_size =3D 0;
> @@ -218,6 +230,8 @@ void __init arm64_memblock_init(void)
> 	/*
> 	 * Select a suitable value for the base of physical memory.
> 	 */
> +	BUILD_BUG_ON(MAX_FOLIO_VMEMMAP_ALIGN &&
> +		     !IS_ALIGNED(VMEMMAP_START, =
MAX_FOLIO_VMEMMAP_ALIGN));

We already have a sanity check in spares_init(). Doesn't it work? If we =
really
need a check here, I think we should use compound_info_has_mask() for =
the guard
instead of MAX_FOLIO_VMEMMAP_ALIGN.

Thanks,
Muchun

> 	memstart_addr =3D round_down(memblock_start_of_DRAM(),
> 				   ARM64_MEMSTART_ALIGN);
>=20
> --=20
> 2.56.1.809.ga0b61035b5-goog
>=20


