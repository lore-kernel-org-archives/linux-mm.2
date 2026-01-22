Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 579A1C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 03:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A180D6B00BC; Wed, 21 Jan 2026 22:11:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1D66B00BD; Wed, 21 Jan 2026 22:11:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EE826B00BE; Wed, 21 Jan 2026 22:11:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9E36B00BC
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 22:11:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0B5019128A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:11:10 +0000 (UTC)
X-FDA: 84358123500.08.F3E108F
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1E5C5A0007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:11:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UjCCfmCt;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769051468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xvA1wq0qreituDJh/hMPrxm5rJ40HKT6I2SwEUTel6w=;
	b=XxhtoVoszUOb6H7mIUMnrEun9AdUI46SDyTTHPxPj04iHAvmQpOsEJV+45CPgS3QwqqIBg
	0iPh/xjAkJepmDsEHIl5NBl5UqdlhJF7D4D3cEWvU0Hk+JuvUWRAG+I9tFPVJxoCwwk/6w
	7yuvwDFsgUtSJQPfSdB0OVF2ifuuvXw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UjCCfmCt;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769051468; a=rsa-sha256;
	cv=none;
	b=Qvu0R9h3dhflxnwgap/wfL3KuhAhvYvGbYFpydZS1zSl/mM8aX5PvUm6jc3ldgZSyNPx+w
	VsjwOkGiLAfVQZJShLftRaPbNBoklGtQBOdMohTzhR4DlCvuHQ4kmAB2wkY+lKUihSGebT
	IfQ/SXf4T9705Q2ylx7qIfXHqFKqGt8=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769051465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xvA1wq0qreituDJh/hMPrxm5rJ40HKT6I2SwEUTel6w=;
	b=UjCCfmCtXXXGGrvHicWu9/ktRUefIaFeWghRm+n3yZOagd0wHt22hJMOXGuVgKU6qMXd+3
	2Koitgh292ACg/8cFqBNXbxbrz6i4oOm8eVGTfauPatCgZ+EoDa0GvPAuijwHr3f9fQZam
	YEewmn01tWJrJotrZ7HlTldzd6KqBzI=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv4 07/14] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260121162253.2216580-8-kas@kernel.org>
Date: Thu, 22 Jan 2026 11:10:26 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <71F051F2-5F3B-40A5-9347-BA2D93F2FF3F@linux.dev>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-8-kas@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kqhom16qqkr94wgq4358dcjdu31fr3gm
X-Rspamd-Queue-Id: 1E5C5A0007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769051467-204730
X-HE-Meta: U2FsdGVkX1+fXvUVGmbbSLCb0DBdBsceGGrGgwEM6fOoAxUZvwtC7tgynSgW2u35XfF4IjquJm+CQU+lrQMS7rRv6g0zX2whR8gEJbFTSVqF1zs1jYKRtdknUwsaTXILmta+JcfV3NpzWtZhf2V1NBLkVE8B6QB3cNgUseESzOg5fq+ocvDKLdDK/DbYgdIPYxM8KPjqmMxCnuIpWghVH6qFogcslWSKL6tVoVO2qpJrL6bLBYeqrl3hf2oeER0QLI8ZvE8MXMVifLir6Zp8+LnxU3B3/SJNZQ1Kq6jU6EJ3ZYT807Fse+H0qO5b9AnLhQp4GGxPgxZ7ShjDZjDAQoLSo4rraqEVoGiJ8Ro4871E6iS10y+E1lwDPCpUZ24Vrpkr/cJwQpEqlRMw4jxO7o+7wXvXCh6eCfq+Fo1sT7b733Ot/kJgjGiPN5TzdG7jj9OCtZJAccsrAHntVLb8EYORa3MWdlFK33N97SsyuX22pfeV6w2/q4+scFgc3HXZLSiFY8MVZhKa9yzQzV4L+mvgimhXLY3/6Pp1hmx29EEdCC4sv3/wBBUEJd2z8EdSqSHioURnt0hPVJAR4u847a3x2PsNXzRoo2Xw7TJZ2Pa0BO2hv0NgnNTBiG7SE92siPOICgEC3iyZY+U4OeL+8XoEFaD/E1VwIgpTa2rV5g+X1p8Pjwj37y2k3DluGmWnM6xkGsUqMXi+JppBUr7o7spQEIq7ZE5GR3Djd/HZPd6bCDr8BkyrhaYuBFf6E2gwkpcSRXbJpj1TNpfEmwTM5nHfDqZVN4Qze18SU5kKqL8Lz8XeIJj5zAliMyfcOv0Y66zFE/5he9kwR1oyHDtwhla3emduy4dUKbYvFZMHZHYlZGgw8oc6+AaGyLUUEbzzuRKPLYw4gaMgCiu+69hiH1VfJDQfpKGf2LXESlpm4EHN6IKi0R2JtdAer4LkRuw7fUhuQM4uPUZ2k03eqP4
 q5Dlj7GS
 KUjXvdgkpKsXsxw9hJAoAkmhYsd2/d2m5toi9RuGam71/OxL05fSw8Q4x3NLELqb/h3lJdCA2YsnlK5iJ0D56IobOjp4LDmar/cAj391ZEVDnBCi0aRSacp/gF2IcCD4hazlsMkuPNdyGQHTlFImoqgJAa8OFDy9GkkIPEsfr2iCOXGXVdq4ACPyhIt1k0ngQpfKxHE2skB1naUnZke8jdJtVnaR72yt0EzjWtLYNTflhP6Jt1K0DK2c7P04ehShX4hxTVKfy5S1vQFABMuMM1oLfQVNN76rXJdgCsthamD01+FzUsPM2ZrQ4NQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 22, 2026, at 00:22, Kiryl Shutsemau <kas@kernel.org> wrote:
>=20
> If page->compound_info encodes a mask, it is expected that memmap to =
be
> naturally aligned to the maximum folio size.
>=20
> Add a warning if it is not.
>=20
> A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the
> kernel is still likely to be functional if this strict check fails.
>=20
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
> include/linux/mmzone.h | 1 +
> mm/sparse.c            | 5 +++++
> 2 files changed, 6 insertions(+)
>=20
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 390ce11b3765..7e4f69b9d760 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -91,6 +91,7 @@
> #endif
>=20
> #define MAX_FOLIO_NR_PAGES (1UL << MAX_FOLIO_ORDER)
> +#define MAX_FOLIO_SIZE (PAGE_SIZE << MAX_FOLIO_ORDER)
>=20
> enum migratetype {
> MIGRATE_UNMOVABLE,
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 17c50a6415c2..5f41a3edcc24 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -600,6 +600,11 @@ void __init sparse_init(void)
> 	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
> 	memblocks_present();
>=20
> + 	if (compound_info_has_mask()) {
> + 		WARN_ON(!IS_ALIGNED((unsigned long)pfn_to_page(0),
> +    			MAX_FOLIO_SIZE / sizeof(struct page)));

I still have concerns about this. If certain architectures or =
configurations,
especially when KASLR is enabled, do not meet the requirements during =
the
boot stage, only specific folios larger than a certain size might end up =
with
incorrect struct page entries as the system runs. How can we detect =
issues
arising from either updating the struct page or making incorrect logical
judgments based on information retrieved from the struct page?

After all, when we see this warning, we don't know when or if a problem =
will
occur in the future. It's like a time bomb in the system, isn't it? =
Therefore,
I would like to add a warning check to the memory allocation place, for
example:=20

  WARN_ON(!IS_ALIGNED((unsigned long)&folio->page, folio_size / =
sizeof(struct page)));

However, in order to minimize the impact on the buddy allocator, I =
personally
suggest changing `WARN_ON` to `BUG_ON` here, and changing the checked =
size from
`MAX_FOLIO_SIZE` to the maximum size that the buddy can allocate, in =
order to
ensure the buddy allocator works fine. This check requirement is much =
weaker
than `MAX_FOLIO_SIZE`, so I think `BUG_ON` should not be easily =
triggered and
therefore should not be a problem. For non-buddy allocator interfaces =
(such
as `folio_alloc_gigantic` or `cma_alloc_folio`, etc.), we need to check =
whether
their struct page address is aligned as required. If it is not aligned, =
return
failure and print relevant prompt information to remind the reason.

> + 	}
> +
> 	pnum_begin =3D first_present_section_nr();
> 	nid_begin =3D sparse_early_nid(__nr_to_section(pnum_begin));
>=20
> --=20
> 2.51.2
>=20


