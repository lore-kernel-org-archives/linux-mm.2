Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35C52CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27BAD6B009B; Mon, 28 Sep 2026 13:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 253B46B00A7; Mon, 28 Sep 2026 13:35:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 191686B00A9; Mon, 28 Sep 2026 13:35:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E46D46B009B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:35:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 830DB1A0283
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:35:28 +0000 (UTC)
X-FDA: 85263872736.07.CBF54BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id BBFCF140006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:35:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JgJleyjF;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790616926;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1wgoeoJYPRfg3GcR5cNgIa+KIwSHuCasXM5odxS1hrI=;
	b=BWqKiQByakXUEi0hlywlhwExtk2MvDUoCfSWHOVtFRnIinDlUPKjmKvg1pLnv2s2XPsYFl
	mER4eRnjEbxVfGhITGswvXe/FCNP+sfQhckMS6V2Kdfw4Ak6dm+dWQ9B812z+ro2GHEZwU
	QJrLRSUwEBFIo5JuuWum8HeadAw6Wls=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790616926;
	b=6+1+yV1cOCyvIj77m+SYH3QXzp2ehS8RdeQwBlI2W6smXgnZcwLuEP8Nllf4aRttPO8a6h
	sDAoZ7B9SJXGIXdd2lQAuiBmtTeYxY49zsrRnTzp/4S+TW8s5Zd36UYnHDjzcowSLYaN85
	FW7f63u8H/BQ0LLS1/ImtdQOPlvDxjA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JgJleyjF;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E54D243EF7;
	Mon, 28 Sep 2026 17:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064A71F00893;
	Mon, 28 Sep 2026 17:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616925;
	bh=1wgoeoJYPRfg3GcR5cNgIa+KIwSHuCasXM5odxS1hrI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JgJleyjFQgWpfSJkA6nyiCqqkWAAQHtWpxUxiVpk/gtQMO+5K7zLj5gw60+XRVrxG
	 DOxpA1mOKjw+UpOYOeAT8dGi1rHv4aXAS/klnjPQQTsZ8M2A7aHg9r5h38IBTnycHr
	 Iq3i3uWPDRV0Ha6SOjYiot9MUb80bIaPo4t9fvVIUc5TN2bKqu+nC4zb5/1aJcNHSp
	 8yrxScOB5GeImFdiGk8r9MJ+cXNpADyVXtzcldQsWRluad0eoZommMs41pDQElhyDf
	 TXYaXwVdcTkN3AXpUXfrkwTpLtLbSwRpIfEdx6NbmMkCLCcvUN8Dc1I/37mSc4kT+z
	 YLFq0XLOxp1iA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 10/12] mm/madvise: Add MADV_CRASH_SECRET,
 MADV_CRASH_CACHE and MADV_CRASH_RESET
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serge E. Hallyn" <serge@hallyn.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Will Deacon" <will@kernel.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Mark Rutland" <mark.rutland@arm.com>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Barry Song" <baohua@kernel.org>, "Paul
 Moore" <paul@paul-moore.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Shuah Khan" <skhan@linuxfoundation.org>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "James Morris" <jmorris@namei.org>, "Jann
 Horn" <jannh@google.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Zi
 Yan" <ziy@nvidia.com>, "David Howells" <dhowells@redhat.com>, "Saravana
 Kannan" <saravanak@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Matthew
 Brost" <matthew.brost@intel.com>, =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Rob Herring" <robh@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Pedro
 Falcato" <pfalcato@suse.de>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@suse.com>, "Arnd Bergmann" <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, "Alistair
 Popple" <apopple@nvidia.com>, "Alasdair Kergon" <agk@redhat.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "Nico Pache" <nico.pache@linux.dev>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Rafael J. Wysocki" <rafael@kernel.org>, "Peter
 Xu" <peterx@redhat.com>, "Mike Rapoport" <rppt@kernel.org>, "Jarkko
 Sakkinen" <jarkko@kernel.org>, "Muchun Song" <muchun.song@linux.dev>, "Benjamin
 Marzinski" <bmarzins@redhat.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "David Hildenbrand" <david@kernel.org>, "Rik
 van Riel" <riel@surriel.com>, "Harry Yoo" <harry@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Baoquan
 He" <baoquan.he@linux.dev>, "Byungchul Park" <byungchul@sk.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Dave Young" <ruirui.yang@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Mike Snitzer" <snitzer@kernel.org>, "Usama
 Arif" <usama.arif@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, "Mimi
 Zohar" <zohar@linux.ibm.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, linux-crypto@vger.kernel.org, linux-mm@kvack.org, linux-integrity@vger.kernel.org, conor+dt@kernel.org, keyrings@vger.kernel.org, devicetree@vger.kernel.org, "Eric
 Biggers" <ebiggers@kernel.org>, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kexec@lists.infradead.org, dm-devel@lists.linux.dev, robh@kernel.org
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-10-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-10-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:35:21 +0000
Message-Id: <20260928173522.064A71F00893@smtp.kernel.org>
X-Rspam-User: 
X-Stat-Signature: 9k7ddgwkyces78qhcyrt6dm1abt98tzu
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BBFCF140006
X-HE-Tag: 1790616926-941870
X-HE-Meta: U2FsdGVkX1+xGrSh00H6Vp4EJGQsJTRMWTg15QvfZAVfXkVsuySGjBVeWjuTqa0GfjjpDO7u1jzR8MNeb2PMQsV+YcXFQAHp6WA2UHbLssR1kolcPhXnoBcBmEw9mMvOkpn6LewPZvGm+rgXLxxPii9TY7J1Ugca9FGdha2sFqkql9iv4h1KyOM0JdpBqVKVbBayKnMAp//nEQ6JVmhnWgxyN5gh3K1d4gI2sfCjzV9i0lm8XuAP8PImykHFwTIlrB819F16QmW67ZU3Gyn2BWT4DeA7yHcfJxM9Hig3jOHR6t7JxHFGfFR88N8ohD+zYSxDvhR9vGjaUZWAwdwjXYDrbZy4UaIO9gCslrXBY2cp5h3EI/z6V0zT0cntq5Cs0INubzRCrbglzu4x2tYqAuj40XQmWbUyhjLOVf40Q1HQtTAALFxJjVm2xEnqgOnkt0dqT1gvaf/C8g3cYSsx0Ok2m5wxheSBh8LaJWR4YYnndHA6mnMWW2S7q9PBKJzqpcut9uxmhk+qQ9e7UKhz86A9JpCFlppkMCah6C6tt3Bh1EzxgrddoajxXzyAe3c8wjJOhTmrA2KfZFUJCqRbv6DNkycsqq8dEVQwnGLMvAwDYQHAlaINrPHi+a2UdxjWI81auWdhb15C49P0NX8hB0qGWNwly2TpSjR0pQUeXaSnReelNKgDIAknLgh3rGGvkd5lgKYQ6JjXJVFtI1pjF4ABFtOnD8JVgMuIa+OPIadt2cBGJbS9qaaBkHW2Ay9I9qBjiVz3pGB7N5RXMmYX1l2o2fxPX2Zi5wLwiHI198FY+Bk/biRCHONSS4R/p5Mjfq+ZiSTS6vyGwhynkHDJR1vbDFrkqsGnv1fZahu3K7RJx/4zJB45NeHbIcE9XbU2iARvNxIMaxUpoSoHTuMyy0MLQClML2sH23R2b2N09U6JSh8tUjLts3cY88j1f6O/ST4J5O795WXkiYYx4rL
 U0FeDA30
 ClmfEWD+9PpQJof2GOunq3agugCSDjePTkES8eGbZv4QxzsBagjvv17sT8xJSEsrkobBH1XvB6kiwN0INjKgud8FbyJioKIhs9hwquri3QDYzYz3L3CZCrVS7GEGkja2F6ughXRdoM7Og0xTYLigNoMpxOOkzstKB/pPLE8ZuxLXc6X4sdhrkbnTBc3/GnfV9m+AfxwG2G56xQ2SflB1HR9JvTshPFXGOYlC2fK2mRo+iCLqshx3nBhTstRQ54CU+7QmHSpalfY9jAnVq1IXQh6+qnSk5QOUlKZcpwywENzOirml/68nq0mdB3RDSuV/tdrD9By1u5Xar8/3H2JBHuOwUnvGPhSTbWjvprdGkXN3rObGHyMDX7KBb/fDDnPXjyJuSM1pBi69BwPnQlvepuME2AatkkarH2CuENmb9j5b1Pkn21ds1B4KK/iZGp6cM4paPinhH4+qQv6n6xmjkUwfiAbEBzgWKo8cV+OZMzJDhMy5ezEukLQZiWVh0m2rLxDvl1pOQ6H5V6aHoB+BIA4c5w9c/qHnB/tDIFaaw7yEYxE+X48D5SK+6HgWgqvs4nY1u4KtGQS4hMJLFzOX1TzEOVtFARCm4+D9G0a5ZYiZnrG4MVWnlpttu8Prj3zTvY0EO7VWkmjvsEsxbV+6wRC3vN8U8yornKof+P+5+WASNluAU7rmo4Ebu4nwFZ2ttabiz/qZQjnW11IeeH8sN99vjR+Y7B+ZN+kC5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: MADV_CRASH_SECRET skips migration entries leaving secrets unpr=
otected
--

commit bd54b0316a2281079a7116bef1937bfde7198adf
Author: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

mm/madvise: Add MADV_CRASH_SECRET, MADV_CRASH_CACHE and MADV_CRASH_RESET

This commit introduces new madvise flags allowing userspace to mark pages
containing secrets or unimportant cache data. These marks are registered in=
 a
bitmap for the kdump kernel to process during a crash dump.

> diff --git a/mm/madvise.c b/mm/madvise.c
> index 00b1be655a8b5..37f08334e95a8 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
[ ... ]
> @@ -1173,6 +1175,98 @@ static long madvise_populate(struct madvise_behavi=
or *madv_behavior)
[ ... ]
> +static int crash_mark_pmd_entry(pmd_t *pmd, unsigned long addr,
> +		unsigned long end, struct mm_walk *walk)
> +{
> +	pte_t *start_pte, *pte;
> +	spinlock_t *ptl;
> +
> +	if (fatal_signal_pending(current))
> +		return -EINTR;
> +
> +	ptl =3D pmd_trans_huge_lock(pmd, walk->vma);
> +	if (ptl) {
> +		pmd_t pmdval =3D *pmd;
> +
> +		if (pmd_present(pmdval))
> +			madvise_crash_mark_pfns(walk,
> +				pmd_pfn(pmdval) + ((addr & ~PMD_MASK) >> PAGE_SHIFT),
> +				(end - addr) >> PAGE_SHIFT);
> +		spin_unlock(ptl);
> +		return 0;
> +	}

[Severity: High]
Does this code leave secrets unprotected if a migration is occurring
concurrently?

If a PMD is temporarily unmapped during a migration (such as background
compaction or NUMA balancing), pmd_present evaluates to false. This
code skips the PMD without marking it and returns 0, leaving the entire
2MB range unprotected in the crash memaction bitmap. Once the migration
completes, the restored page remains permanently unmarked and will be
dumped.

> +
> +	start_pte =3D pte =3D pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> +	if (!start_pte)
> +		return 0;
> +
> +	for (; addr < end; pte++, addr +=3D PAGE_SIZE) {
> +		pte_t ptent =3D ptep_get(pte);
> +
> +		if (pte_present(ptent))
> +			madvise_crash_mark_pfns(walk, pte_pfn(ptent), 1);
> +	}

[Severity: High]
Similarly, does this loop silently skip non-present PTEs like migration
and device-exclusive swap entries?

When userspace calls madvise with MADV_CRASH_SECRET, it expects the
memory range to be marked. Checking only pte_present skips resident
physical pages that are temporarily unmapped for migration. Since the
rmap hooks only see the flags as folios arrive, these skipped entries
never get added to the bitmap, potentially leaking sensitive data in a
crash dump.

> +
> +	pte_unmap_unlock(start_pte, ptl);
> +	cond_resched();
> +	return 0;
> +}
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D10

