Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62484606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JGadQBGz
Received: by kanga.kvack.org (Postfix)
	id 6B1B66B05B5; Sun, 22 Nov 2026 22:11:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6614C6B05B6; Sun, 22 Nov 2026 22:11:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 550AD6B05B7; Sun, 22 Nov 2026 22:11:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 281B36B05B5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:11:27 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08358A8431
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:11:26 +0000 (UTC)
X-FDA: 85464908172.26.D30C148
Received: from mta1.migadu.com (out-112.mta1.migadu.com [95.215.58.112])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6E5EF40004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:11:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JGadQBGz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.112 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795403484;
	b=xMllz9aq1HpS1YyQLfPEsL8XyGa2k+JotAHbGbzJqn2ZHAFxTEChwUIi3LC5TokXXPtXU6
	8YsYedRerElSLuU5jH3uIszvtJbsz1RN7UzwHWdOaHWuKxQRap9ycy9ImmAUvIEt06FeIZ
	fGy4k3lvk+u/xER2yUW1OCNuaZ1V8ew=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795403484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=liONQZO+EAHG7ixY8JmtuIKPPkmSaSHZeOcFjrgKJBg=;
	b=PRPjH3hHKoPt8NaELfXZhXig7h5J2XdGBPHLlZVFQIborCXlkyHhokWPC03+kzQqDOxuRL
	CMPdbd/HKXenGV+z0TNQHOKQ7J9+zZiGkOsd1Gq4KuIDDrA4CAsrb9jTOv31KTQlup70Vf
	OIHre9qhCdEGA/CIkkg1Yod7B0jaF8E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JGadQBGz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.112 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ujFplHJ3piEVGbgFTkod2LvOMRYY4YKywSoNgd1YTy8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795403481; v=1; x=1796008281;
 b=JGadQBGzfFBNNYjyltAprpVsqdwuxh74rGJo0/gdG6BKgkK3WoWFfvZqTjSrVZsH11H4nySR
 7Otk69J0vXze9+eLQvHegEs2g9gfCScNGv6g02SCUN2Ckb5vjPPCJwqnrAOGNxk6E5cLi4UltqX
 YHHa384z6KmxZqRTKy0lfPi8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6023f3f8b2fdfde6;
	Mon, 23 Nov 2026 03:11:20 +0000
X-Mizu-Trace-ID: 6023f3f8b2fdfde6
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 06/19] hugetlb: Optimize bootmem folios that were not
 pre-HVOed
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261122184453.2668189-7-jthoughton@google.com>
Date: Mon, 23 Nov 2026 11:10:55 +0800
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
Message-Id: <CF94E7D7-87D2-4523-9343-512EE00094FA@linux.dev>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-7-jthoughton@google.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6E5EF40004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6r8xmcohh85ytwscieqp68aqyqc6wd3d
X-HE-Tag: 1795403482-236940
X-HE-Meta: U2FsdGVkX192/P3oPK4yrDIm3cBqDgM6m7P4CLHItDMgBC7f62GGlkqqhz6nHIOplXy+Px6A3/2VM0Q+VMCoUh5gb00CAB6sUcQaD4w+fcejRWfHE3n+GUnb53cz+0bptDJyQjiXSeOoKfE8997PKmQRyZRdBHnwxJBBleLw4JC/tc6saqqGCo+lG9PqvTzbMv0QiNtjHiCn85/XJJPV45y3LWLduzmbow0Jum7GtyKR6M7bt0wlk6d5MVU01BFkrIDOWPf9p54Vzzcg0NDKIdWxh5pcNUBzZMR4tQBD3HcBJt11WquVFA+RCimQfRc18KzY5HL1PTMWOMBpu3cbLecnaSa8jJjgop/4m2E9gYaANc5k1zuDNUP8pI+RyctSFxyedhhXUA4QUR39X1IMS9gHHQNOf9GUznJ7TbhfLbKFwNYSqcaGnqcTb0pvwos9RdGzWVZvep6KnQgIcuHgbb0BYReJRI5d3PfFSogTuw3ZBO4kGEqvmyIUTRKnJYyEQ7c+e+VABR2kYY4DiQPdqE4X00/3dsxnSrHa6ezXBpP3kYjLADtQk5syB/7fcqpS5C2KwIbzBoX13yXpgqTbZUFiVDETnzP4RIQOjQfuZh7zuXOMA2nxNhp6mabVIe1d47tw/700Pwrrg6Q+1szqKlH0nakbyrd9cM1DtxCVutYJqlJDqOksClg3S+iXp8egMwrk5J7kzfArN0tHVeyw9vLd1h4mBL7NkDIvT+SlE2VQY++7GYJ+0Bsl8yjM3NAsADqCXTvkzsJBF5504eF6ESKPekiYa82x992Sd4+lwgDFUVqk65txtv++msF0m01apP/jxkuSw0T2FZVL9fkYeBVnf3z5f4oeEhD4SySKJynkMs2/rk8mKRllBUmWUHQ00+TZxcY7xC72hS7CjM+5mmsZgYLBDwiQ/wX7JULvs6cr5CT925t8L5DhVPunklv9G3kYPqvo/t0e8QtUshB
 R8K9ptKj
 Ivgd9VgAX4ShDMBESpR9eBngKNvx65Aui4b2tE4Apa6sEnuHd0Hu2cXR+XbkylfPzq1iB68v9lIJGhygsHhr8Wpdn+4hgMZXfbi4AgDEUZQCnjhOSP62XZGW/WljxuE/U+mhswAMghpFDh1lahVJg+NFpwtb0tAazh09jTyWubKK2ZrQwlZhnxcrAYT5js6xyC5g+ZEQg54xDiIxjJkKnRhA1dltKHk/8q2mV6jJZI12+bRKdmcp7dsvl9BP56lX86feHC1VtjsTW4KqmhynibT3iWyqZDPEhGK/4F0vpGd/qLbQw3SskstdhMThPFdNqAQpC6g7MvnXYi9dy5/io+9vvEw2EV2iJsR+0+ZOJZ2JKYEIPIR8P1EJ49uIVW7M5OmBMv4Nx7KMitYMhz/eWfgLoQ4UAcSNJVHbAOdQRd0/wMR3f/oDSoexjtlGVuzgaX6nFWlUFEWa3Hm5eCA+IuCF/F9hB9j45JykLgiT3PXOGeGryraOUL9EJ6w==
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
> Boot-time gigantic folios are expected to be pre-HVOed through the
> section-based vmemmap optimization, so the bulk optimization pass for
> bootmem folios was dropped.
>=20
> However, arch_support_vmemmap_remap() may not yet
> return true when bootmem folios are allocated (e.g. on arm64, where
> support depends on a system-wide CPU capability), while it does return
> true by the time the bootmem folios are gathered. Such architectures
> disable the section-based vmemmap optimization in their vmemmap
> population path (see section_vmemmap_optimization_disable()), so the
> folios are not pre-HVOed and would never be optimized.

Yeah, when I removed support for this part of the code, I figured you
might add a new patch in the future to add support back. It is fine.

>=20
> Optimize such folios when gathering bootmem folios. Their tail struct
> pages have all been initialized by memmap_init_compound_page(),
> as they were not pre-HVOed. Pre-HVOed folios are skipped by
> vmemmap_should_optimize_folio().
>=20
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
> mm/hugetlb.c | 11 +++++++++++
> 1 file changed, 11 insertions(+)
>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 72839e98f998..8756c0206922 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3325,6 +3325,17 @@ static void __init =
prep_and_add_bootmem_folios(struct hstate *h,
> 	unsigned long flags;
> 	struct folio *folio, *tmp_f;
>=20
> +	/*
> +	 * Bootmem folios are normally pre-HVOed through the =
section-based
> +	 * vmemmap optimization. However, an architecture that can only
> +	 * determine whether it supports HVO after bootmem allocation =
disables
> +	 * the section-based optimization (see
> +	 * section_vmemmap_optimization_disable()), in which case the =
folios
> +	 * were not pre-HVOed and must be optimized now. Pre-HVOed =
folios are
> +	 * skipped.
> +	 */

I'd like to condense these comments to something like:

/*
 * Some architectures do not support section-based vmemmap optimization,
 * so their bootmem folios should be optimized here with folio-based
 * optimization.
 */

Thanks,
Muchun

> +	hugetlb_vmemmap_optimize_folios(h, folio_list);
> +
> 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
> 		/* Subdivide locks to achieve better parallel =
performance */
> 		spin_lock_irqsave(&hugetlb_lock, flags);
> --=20
> 2.56.1.809.ga0b61035b5-goog
>=20


