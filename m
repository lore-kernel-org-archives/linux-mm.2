Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D6F4606A32E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 06:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pQ0SCBKK
Received: by kanga.kvack.org (Postfix)
	id 448BC6B05B0; Sat,  7 Nov 2026 01:44:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FAD56B05B1; Sat,  7 Nov 2026 01:44:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9D06B05B2; Sat,  7 Nov 2026 01:44:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F41856B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 01:44:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E735E1402B6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 06:44:14 +0000 (UTC)
X-FDA: 85407383628.23.1BF286E
Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	by imf17.hostedemail.com (Postfix) with ESMTP id AA55040006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 06:44:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pQ0SCBKK;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794033853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xliLypkGqol0qEpEVa+hTfnI8y9iuSR0fJnpOdphoZo=;
	b=Maz4K0l/ylmRNlYM2q/Jdr+bt7x6PHlixt4aWTSHgZIKblP56SWGfeYp1acw7tFejF0Brd
	/yL78RK0GhR1QJGHmNXnXmFY00ngMkHppVBM5gXUR2nrhKMbwPlVzg7op5YAJsfnL5Rk4z
	Zj53G5dskHyE2Zt8INJVJbeO7W0wSFs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794033853;
	b=he1kf3xejJISFkuG+EURkTDywuU1PQAOUVXcWsdXc9lS5KKejig93bpfNqnZ+oPs59zWTf
	xpoN4yMaIMrl7s+rW/hqKWQkkJJl++kxy1w2b/cT2Fc6p7QfxXHq/PkyVWDWAf9AV9Uh9H
	8eo4oUBcuzmYG9M08nWgAxUlktcvtP0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pQ0SCBKK;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kGVxC57LJnQRDgXx8D0xd95zTBOZXo4vhbKbkir4GP4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794033851; v=1; x=1794638651;
 b=pQ0SCBKKF7yDkPQypqSgjzhBa3VCul4hGS28NKFaCvJ7kGf+XlBoRRMmfzDnIhJDevuOCQ2d
 V/NWfIQMo4t+1jZ4VpyCbdpo3NhceM+djnPUO90G/DCzOGyrM1kpKy+850qChY2uucOR26e60Ho
 oaasVK1+mOQNviKkfI+YTKnY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id d37edd97d7e39205;
	Sat, 07 Nov 2026 06:44:10 +0000
X-Mizu-Trace-ID: d37edd97d7e39205
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 06/20] hugetlb_vmemmap: Allow architectures to
 dynamically disallow HVO
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261003002123.505555-7-jthoughton@google.com>
Date: Sat, 7 Nov 2026 14:43:48 +0800
Cc: Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
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
Message-Id: <8814E4B3-5A5A-4874-863A-71FC6E4F3B34@linux.dev>
References: <20261003002123.505555-1-jthoughton@google.com>
 <20261003002123.505555-7-jthoughton@google.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 7zi11saohu16muqsocu49hqhwh9dqft5
X-Rspamd-Queue-Id: AA55040006
X-Rspam-User: 
X-HE-Tag: 1794033852-301939
X-HE-Meta: U2FsdGVkX1+agokdDU/A33qtHeXhfdUEt6xIyZEQvq2H/vXQeiTRgvbexn7NBT8TRkQdUeJnCUV8HvVbfpP0ak+ZCARH7OV+CodgcO+ocoEpUZ7gqyX83+miJ/clgAQuUGZCtabXphFrPDJu2hZQDlLuzsFOR0mF7J2gYbNWBAq6FXSASY9Uc+SwnhWKFicfqvWyo7vxvvUkHQ0Np4WuU4ym9dECe3pjqiyRj89Kw0VCImXcnBn6Fw0gEPC12338+76A7KuKNxwTtWRHDmAkerxZyORKZ6uixHYMpRU0Q4zlJWcaTes34AxmNyNxAFrVzGZXC/L9uIJ7hhlHyaxU89fkAfEKnKXqBKKkMQpcDK/G8M7LYik75Yild76Oxo/zujnZN25NTftvdobAIxFC/dQSP0FcA2dxJtNgUxPoRPowO//v2LyUN/+GN90t/V3meVj5vpxYoV2YRmRjuGG/m/qCSYogPsxCGOzBRUvx4NMRRe+w4tvWvcUKbvhKDqd7J/M26+cjYLQ+sw2y83iZ/BMB1NJawSl34Y/ZqqUnUlvR+Ei+1i1ZPnXLuP5+UZJHlEJr3UtrrtBkEnvKGAgskICogy5ad53t4YQvxvheXwRsq6ZV+kzobVag9mD6uiWm0XX41Jg31581JoU5DQEbOUG5Wz2n2WWlL2ipYZyggzFizhoKxoK5gC+y00qO6oIeFTlWm4tcuPp0O9OMTk7tSBfxdjaEaA5xELvTRByd5kUpmZJ4QswZU1hPkb+V4f8egmMMk4jsm4sKeAvtgEp7ZeQEwElVTX650SM4P6EiNoFO9f8UrvHFFBK1xjzjGuucI5FPQAPmBs99Gjt0gKBcT2HZR2bcqrCj+5FVBzMnHgU6k9YbwJpJjsbUnc40TIQiJqtwCw98UAa7oS2sTsbDx8v4filioHnIy4Hb8/DEhtM4jPZ1HjtZDN8FDkn5AsxFsSEcSUC/pd+v63A7mGl
 Os+6Qslo
 glK8xuc0m3wUwBDCcSvv4q61MShDzrJYrlMbLB7hAdThhkI6W8KGMlUsFBP1Ol4cFMRrHtnCKYspYag7EdfS0MCz/gNPL6EQTVYZn9UZB+LUt5NwK91uVcJdji5Yh1A+H7Zo/4KubsN9W6UtKcxA/fHLf17z6zocMNxDTmPbv71818Vsegf3akERF+5nluVBacLAbZugtWwZSIQzCqJ6QwkGgQnFD5p6rn8PtSO5k5b+f3ZXqjs1XuztzUWKnJApANfTN+RKgYa2keT0SsduPax1o8IwCgtJGngdQ9jkE2PwEIfr9cmtlalPcv339Es9YIlejfxDShrwDxsa8K9Jk9FqcfGQ+HKQz4D92ulcES3vrQDWaMl6+qjFOj7DHwaY+jq22
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> =
wrote:
>=20
> For arm64, only some platforms support HVO. Add an arch hook to =
prevent
> HVO from taking affect if the architecture lacks support.
>=20
> It may be the case that arch_supports_hugetlb_vmemmap_optimization()
> returns false at first but eventually returns true. This is the case =
on
> arm64. When this happens, bootmem hugepages won't be immediately =
HVOed,
> but they will be optimized in prep_and_add_bootmem_folios().
>=20
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
> include/asm-generic/hugetlb.h |  7 +++++++
> mm/hugetlb_vmemmap.c          | 12 ++++++++++++
> 2 files changed, 19 insertions(+)
>=20
> diff --git a/include/asm-generic/hugetlb.h =
b/include/asm-generic/hugetlb.h
> index 635c41cc3479..8d24075d53d4 100644
> --- a/include/asm-generic/hugetlb.h
> +++ b/include/asm-generic/hugetlb.h
> @@ -128,4 +128,11 @@ static inline bool =
gigantic_page_runtime_supported(void)
> }
> #endif /* __HAVE_ARCH_GIGANTIC_PAGE_RUNTIME_SUPPORTED */
>=20
> +#ifndef __HAVE_ARCH_HVO_SUPPORTED
> +static inline bool arch_hugetlb_vmemmap_optimization_supported(void)

I suggest using arch_support_vmemmap_remap (see [1]), which can also be
applied to FS-DAX.

[1] =
https://lore.kernel.org/all/20260903122128.12264-2-songmuchun@bytedance.co=
m/

> +{
> + 	return IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP);
> +}
> +#endif /* __HAVE_ARCH_HVO_SUPPORTED */
> +
> #endif /* _ASM_GENERIC_HUGETLB_H */
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 3fdb1e4ce1a1..8596a462fee6 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -16,6 +16,7 @@
> #include <linux/pagewalk.h>
> #include <linux/pgalloc.h>
> #include <linux/vmemmap-optimization.h>
> +#include <linux/hugetlb.h>
>=20
> #include <asm/tlbflush.h>
> #include "hugetlb_vmemmap.h"
> @@ -529,6 +530,9 @@ static bool vmemmap_should_optimize_folio(const =
struct hstate *h, struct folio *
> 	if (!READ_ONCE(vmemmap_optimize_enabled))
> 		return false;
>=20
> +	if (!arch_hugetlb_vmemmap_optimization_supported())
> +		return false;
> +
> 	if (!hugetlb_vmemmap_optimizable(h))
> 		return false;
>=20
> @@ -731,6 +735,14 @@ void __init =
hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned in
> 	if (!READ_ONCE(vmemmap_optimize_enabled))
> 		return;
>=20
> + 	/*
> +	 * Architectures may return false here but true by the time
> +	 * hugetlb_init() is called. In this case, although the folios =
will
> +	 * not be pre-HVOed, they will be optimized in hugetlb_init().
> +	 */
> +	if (!arch_hugetlb_vmemmap_optimization_supported())
> +		return;

I plan to add a new helper, section_vmemmap_optimization_disable() [2],
intended to disable vmemmap optimization in the architectural vmemmap
population path. Since arm64 does not support section-based vmemmap
optimization, section_vmemmap_optimization_disable() should be used =
there.

[2] =
https://lore.kernel.org/all/20261107043122.25650-3-songmuchun@bytedance.co=
m/

Thanks,
Muchun

> +
> 	section_set_compound_order_range(pfn, 1UL << order, order);
> }
>=20
> --=20
> 2.56.0.rc1.315.gc6ed9934b7-goog
>=20


