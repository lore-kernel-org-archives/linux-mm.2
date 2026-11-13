Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3835606A882
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 09:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bfZm7sKj
Received: by kanga.kvack.org (Postfix)
	id E495F6B05FA; Fri, 13 Nov 2026 04:03:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21286B05FF; Fri, 13 Nov 2026 04:03:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5E376B0600; Fri, 13 Nov 2026 04:03:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE0BC6B05FA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:03:57 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 386101603E5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:03:57 +0000 (UTC)
X-FDA: 85429508514.18.D0F3AB8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9A526A000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:03:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bfZm7sKj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794560635;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TkRJZzzYg2xep3JjqjGT3W8LyrL34jwgFRhoxH3T4Ks=;
	b=GxRa4QRiw9Hka/lh3deNIgwy5w719QX/Qq+s2SFnS91QOgRoSYmzeGkCwnUxYw63xBS++Y
	Ikh/MIGHzmLfRvriSUs5ooFKZfYmm+iQoSYdQeMlIHxpN7MfokL15B79JXTObFow6HHoQx
	Aud7Xo7QPkg6dTznvKJHas7iOFl4Nik=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794560635;
	b=qnYhSi8U3llqsgZmC/zQe6V7aDi0Nu0BKwSOVH9v0wQqJzCos9AjoMbxk0Z8+oGUVgsEO4
	APWrG+/rg2699YG96QR0X66/KbtQCLMU2pVvOeC2gKfJsojXvtvrCAAR+ViQJN2XKz9zip
	Oo2Vlqthl2K2aypkO1Y49G95fsZ9XcU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bfZm7sKj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C9B216145E;
	Fri, 13 Nov 2026 09:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860AF1F000C4;
	Fri, 13 Nov 2026 09:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794560633;
	bh=TkRJZzzYg2xep3JjqjGT3W8LyrL34jwgFRhoxH3T4Ks=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bfZm7sKjdNNn6ZA/sNDRyZ15I1+kjqBoEeN9JWRaWHELOzLr1mOwggD34Dp43jrWs
	 gu2TZG06T6C0HLy0qPv3zVBNXN3AQOWMYt/Oqw6tSr5lzYjOIEYy/DYty//SW+FotP
	 MyA/tvpmrUHb/pVd4Ur7J1/p1S3Q7nyESICqo1dYgw/gLAy1pPo6FCKRNfH3SRCKDw
	 th58I+A4zAJBsSHhS56142ykH5kgoxBKjpFaWkvpfFDFcwz3mJoIrEe1QX/B8TK1ux
	 6932spchh4dyq4gy/sFZTgBqNG+2x+ABftFHkJw2uaZBSwJPV0leIpmopUv64ZpUcP
	 oo51xa17eA99g==
Message-ID: <sashiko-outbox-212498@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] selftests/mm: add a THP compaction selftest
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sarthak Sharma" <sarthak.sharma@arm.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Shuah
 Khan" <shuah@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Anshuman Khandual" <anshuman.khandual@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, linux-mm@kvack.org
In-Reply-To: <20261112090250.334344-5-sarthak.sharma@arm.com>
References: <20261112090250.334344-1-sarthak.sharma@arm.com>
 <20261112090250.334344-5-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 09:03:52 +0000
X-Stat-Signature: bc4wzfo6535y4adfgjarmctx8eh9enc8
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DIET_1,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9A526A000A
X-HE-Tag: 1794560635-792643
X-HE-Meta: U2FsdGVkX1/Pieom0QiTH00OBfVjh7frsV9KVXXZaCmGBs85zuUEvNWf/RpUmAmoqALYLjNTLZmwzNwma2DL4K4NZmTxL8vxa3O8gApa/ywupnftQ0QJ3iMASagy05F5V57YRg6rOOM7YWpGNwKyoYdugY91LaN/tneQsFjS1f0mo8/7U0fXhogMMvnGTUaTymlyiGa/WUPnVIitplW2yg/OfsWdhn2EyACDNET10hGiPWdbdSnmc4oL3nfBebMX9O6KrQW2B6bvIWVDqiaXw0hABq7ut287tqjf3AfOws9L/sD5ZNPWyjWkoOSCz3ojwzcHYM4zwJ2YBzH7VFeHsnWi0KFeGlj8EGpIprPmF1etV8UbUwklFPhpGFGru02hT1gMLsn2tZgOZBKAl3MFqZE8lE4bFeNLMA0YZ/u3dtgJAgZ4BUpJHhvY7z/jF75Suospn/3K6f/aviTK4nE5IKuQMId8prd7jgFrDPr4p4HYdRwtw+mNjN/xUSu0QXjbotnIzt0lskGgN2kFWn6Xk6jZkMhcBFZI84hCWolvmaE+GYh+9t3BaBK2WI4k+hYbIsY3IWp0wSHbo8NzSRafNAgi4ObT3zydez3lo2+9jOxR7KhMDmNgRzBzSq2SJqSsic9uc5DKrZiSd5mofC5CW+BRQoL4snKW1e6mjuIZwRFS0ncIsbJDc1oniMb01b+4mbCsE7w1oUp+4SZnnZOqOXT8NpJzH354qu/HdSSQqZ9r7bI5xfejVvDzNplNZCdQ8WLoZJK0bftRNaFaPTPwPz3bK64w60+ZMZ1xE33N3ZzQB8fLQeW1Q/jYA1H7WboJWyNzplvmThRXJ60azKEiEQo3Bo1S7Wevb9EKkGHUWvbRpN3vKZwkYGTAsMbRmtwTagJbvtTVck8RuwKJf4rtgKikFk9yw9oNQph4vOQ1JktFXQUFO3pF756DBqQPocj0olGmbcmbwGzFtDDUtmk
 1kDKUWKS
 6z6nBQC5PPYKuA5H67v4kQfEkT3YfChrmN96DFocvX7lttSdeH6mnSQMwPrYrQbLeXmYXIAUOfvppMuHdqhETMwPiBA69+vKCy6xGzkee5NXG4qEoF0Zg4edzpnhp93EE4DrPkc934fma4L+F75arPxcCSUzjx7QjJfUg10M0PARK5QcZ5dTqdzZHEmhfNzcUu+bJXScZgXZesPTLf8Ei0+XKb3x2CRDUAJeKxODo2cEwsVkcW2K/JjKdV0U8V6vOndLv8Ki7NIvLgWm7dwbFTgX8axjJOf84XagXFwYRnL91qCk9hiLNp4pUWmf6te+TK8QJQkzO8G2gFMAItq6C7jVqf+FNyf528FhocamnK2N6alE2LEjaNnMAhC7Hs2nXuUH1XgpIfwN8oHSxeJwFWjc8urEIn2Bi811K0AYiKTqBba8b/HpbKLNUxMQVXvp2MNh1p7OpnLzG2wnKevboAQ9WUZ9dFkHfJmj/J0xSrZFFk4X0HnDd08Z+LDtJ3qhlIlXr2UOCyLSPDb/6JddwakMZfUg/jNeoP6ShRQUohZvrOIc8dhbs9vanC8ri0DQ1AUDRSC7vou7cgOojzB/E6LMwyG7OpSaDZMQhLn7uW7LoN381qKP5ldlpBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] selftests/mm: unwritten last_page freed via zero page on
  split in main()
- [Low] selftests/mm: missing MADV_NOHUGEPAGE before split_huge_pages()
  in main()
--

commit 8fc76b939a1f641b9678f19aaded037c1f80ae5b
Author: Sarthak Sharma <sarthak.sharma@arm.com>

selftests/mm: add a THP compaction selftest

This commit adds a selftest that allocates PMD-sized THPs, splits them to
order 0 while retaining one base page per range, and verifies that a
subsequent mapping can recover THPs via memory compaction.

> diff --git a/tools/testing/selftests/mm/thp-compaction.c b/tools/testing/=
selftests/mm/thp-compaction.c
> new file mode 100644
> index 0000000000000..8935f1968a6da
> --- /dev/null
> +++ b/tools/testing/selftests/mm/thp-compaction.c
> @@ -0,0 +1,215 @@

[ ... ]

> +int main(void)
> +{

[ ... ]

> +	/*
> +	 * Split all allocated THPs to order 0, keeping only the final base page
> +	 * from each THP
> +	 */
> +	for (size_t i =3D 0; i < nr_initial; i++) {
> +		p =3D initial + i * pmd_size;
> +		last_page =3D p + pmd_size - psize();
> +
> +		if (!is_backed_by_folio(p, pmd_order, pagemap_fd, kpageflags_fd)) {
> +			ksft_test_result_skip(
> +				"Initial range is not backed by a resident PMD sized folio\n");
> +			ksft_finished();
> +		}
> +
> +		initial_pfns[i] =3D pagemap_get_pfn(pagemap_fd, p);
> +
> +		split_huge_pages(p, psize(), 0);
> +		if (!is_backed_by_folio(last_page, 0, pagemap_fd, kpageflags_fd)) {
> +			ksft_test_result_fail("Failed to split THP to order 0\n");
> +			ksft_finished();
> +		}
> +		if (madvise(p, pmd_size - psize(), MADV_DONTNEED))
> +			ksft_exit_fail_perror("MADV_DONTNEED");
> +	}

[Severity: Medium]
Does split_huge_pages() replace last_page with the shared zero page and
free its physical page?

allocate_transhuge() only writes to the first word at p, leaving last_page
zero-filled.  When splitting an anonymous THP to order 0,
__folio_freeze_split_anon() passes TTU_USE_SHARED_ZEROPAGE to
remap_anon_folio(), which remaps zero-filled tail pages to the shared zero
page and frees their physical folios.  madvise(MADV_DONTNEED) then frees
subpage 0, leaving the entire PMD range free in the buddy allocator rather
than fragmented.  Because the shared zero page is present in pagemap and
has no compound flags in kpageflags, both is_backed_by_folio() and
PAGEMAP_PRESENT() succeed, so the retry phase allocates from free buddy
pages without exercising compaction.

Writing non-zero data to last_page before split_huge_pages() will keep the
physical tail page mapped.

[Severity: Low]
Could khugepaged collapse ranges in initial back into THPs during the split
and retry loops?

allocate_transhuge() calls madvise(MADV_HUGEPAGE) on each range in initial,
registering the VMA with khugepaged.  Without clearing VM_HUGEPAGE before
splitting, khugepaged can collapse p before is_backed_by_folio() checks the
order-0 split, or collapse the single-page-retained ranges (which have
HPAGE_PMD_NR - 1 pte_none entries, matching the default max_ptes_none) and
consume compacted THPs meant for the retry mapping.  Calling
madvise(MADV_NOHUGEPAGE) on initial before the split loop would avoid this.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112090250.3343=
44-1-sarthak.sharma@arm.com?part=3D4

