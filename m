Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED8C9606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 12:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dAUOmnUw
Received: by kanga.kvack.org (Postfix)
	id 1FACF6B0923; Thu, 22 Oct 2026 08:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2EC6B0924; Thu, 22 Oct 2026 08:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EB526B0925; Thu, 22 Oct 2026 08:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E19786B0923
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:11:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7541A407D6
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:11:21 +0000 (UTC)
X-FDA: 85350147162.29.2BB8E2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id DD4EA16000E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:11:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dAUOmnUw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792671079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R45se70P3EMmhMkKtYLGOoSJA2q332w3U9R9/qm3AvU=;
	b=NwFYUx57f+8PNPXWmSjD6HZWjNaZ9n9EVPh/oHWZMCB9XI4jC6VGUvKRK30JaGbZvoTozz
	L8GUelRDSCEa1cmRwvbaKbt96UuWOXcBPwVUqwwLgxtujpygnYZ1RPmM8ofE29bZvlcTPW
	cvpv2nCmzA29v1Xi8muAaBy7nG9b/FE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dAUOmnUw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792671079;
	b=u8AkKf7hhzWMdjaHjGtgARcolcM7Vr1DeqfY9pnYx0l0pdD7f5VdR66SyRAzz7FnWCRtAH
	EheC/OXYuR9m5cg3EUv1duBYAINYzGbZCSHhI3sLTAIri7J9tGbtMuyES3htZ5ZGl5BAe4
	ue+585tG6V9rfA+bGcoIVNFyqpqST7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A77B60018;
	Thu, 22 Oct 2026 12:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5AD1F000C1;
	Thu, 22 Oct 2026 12:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792671079;
	bh=R45se70P3EMmhMkKtYLGOoSJA2q332w3U9R9/qm3AvU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dAUOmnUwYmXnqjnb7xpvzxZUOGMYgicvXndxs7prGd8mnPM1HRCMzBTCy5Wqgajt0
	 7ydupNhuB0KEpvBHR5rfrH5IvHMKVlKDABORylIiEdm8FrF1lNL770+I6n0iaPeAVl
	 YC1M6XYdYp6OHunXm7cWdAcaU2dlpD3/998uXguRKcEj5GyZBrTEdi5TpuzW9WUY6V
	 uR+cGqMYiHlpxwrDQC84R50dPT0QbaRbkx4eFfEHe0Fx1GsqR0lASPJUmBltm4xaIO
	 vLuGnuxQA7/bhka5CHm5PNZw6Q7Lk2fsakVxVTvA/ssGxs5iP3VkeQW16AkZtzvLOY
	 hPwMuhCsUC5Uw==
Date: Thu, 22 Oct 2026 13:11:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
	=?utf-8?B?TG/Dr2M=?= Molinari <loic.molinari@collabora.com>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 1/4] mm/rmap: duplicate a PMD mapping as one in
 folio_dup_file_rmap_pmd()
Message-ID: <atn3SPG5MKpj2Unj@gremlin>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
 <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-1-66f00b7a564c@virtuozzo.com>
 <atnEFyGRYGGf9shA@gremlin>
 <71101695-339d-4f8f-b9d8-dfadf7dbd0ed@virtuozzo.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71101695-339d-4f8f-b9d8-dfadf7dbd0ed@virtuozzo.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DD4EA16000E
X-Stat-Signature: x48tboqojrooronpagfnarywqnw516og
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792671079-633190
X-HE-Meta: U2FsdGVkX1/pFM4g5Mh6U8eNrnWDh0sMIx3PzTQ/ai2z99YrgCp7yrn4Q9pVtbOmFsSMvZFWUFXBm4t28JElJ8NrCOGrwUFWtU6Y91WC2Y1BNlUnAXVOaZsjrt0q9vb3PsEiiIQ5oyxHjVMC+2ZNpg7R3f7Klun9lijF6fsT7gV4qflFrq6EbAWRiFyEJVI4OkuBc+uUcTzrsStfju1As9snkkdYwlbr3oPDIhFyJW1LT1BGOeRfaZfAqHYPFMovd4ICe8DEFaj2EKqxpE3AvoYEvl7wGYsawaoh3tC96+fh4wCHQT1O8jfIQXbu+Ca/pgKwQEZCGKZeefANVvtelTcxKSsZsKbYOLMA3N5BmHKTmtv7PT93IDb/lu+ms99mToCJ5jzHvLgv4MKg3vcgga2jyTsVbNiw6d8zpsqaaQdxT5GQd5OutJ0JI1njNPtAD4VeFGVcw6+80p7AC7ye8zahGbHO7mzvE6oANgxUhmqRFMFUpIq/gu3Af35UlHyyMAv012NWngB03dzZ9Bbp6yyKkTodNt9caTFe5Nvq/0m/A1MZsnGo+gzJY9JFkDHT6GplPiXJW7O8Zn0CQOoFfcTpFkeylLyuV7hPke1CjOh/OGm+2muYxaRbdnLP9TIjZgqSgEbsRqw6yE2nj9UuNxQ15M5vsAqf6iXw1ncfHnCuRUH49Ljz95XPK754ahNP3Cwdp52ceDw9N6x22y6RlmwFxpYGWSCZ84NIW1c7J5jhDbivqDYyanAX6BONRxqDQNiw6DmswzDVvbfz+i7gldJFR7zVmDSok/XHN2l4p6+diiaM+mMOMEFNlPrxRPupfTk7Pj18AnJJ0E6g32BTnKG3DT21BLNkCADSNDJG1aKIei+6cCt+Qk8niQzcJvEruNKxqJJqhWiaS6qVOO3kPNay0gs3Xf/70OKI3b752wDrGI1uFsUBPMNCUnnGAeHZH5ul0NygxmBImjZFQV9
 8Arcoi86
 vWKBRWBQGEZ/6P0KmLY7r+y2QDrD8maNIKtmMgTUk3HGkOVa0vyXbZlWp6KertEUAf+xUrzyQIuHad4Zh7ucj3qlANteOWRTWbskJ2iCLtck08j0tlpMYnYdorXfFAjD5n84UImHasH9phAxuqfQ6R/6PSVot+h4dVwV5beZ4AiUu+S0piOsneH/FlcO5lCpKCrTYYjfqtCOi+omDDHVcbQKorz63HLqN2yCoHEUqA8l4WktaJj7eZXw5PVwXo11+FImQJBKRryR6iDD8OTOO+7OPOxp248vu1qFTBT7MCPFPkXII3wSpX2nE3lWxXzJmeAXTNb93WXj2vMefiNI4EH/iKyYBj1dyph8OTPSxYhNYeU6N1QsIW+NlJwfKL6h5hcfAzaxUDLw3n40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 12:44:40PM +0200, Konstantin Khorenko wrote:
> On 10/22/26 10:07, Lorenzo Stoakes (ARM) wrote:
> >> Fixes: d8ef5e311d7b ("mm/rmap: convert page_dup_file_rmap() to folio_dup_file_rmap_[pte|ptes|pmd]()")
>
> > Was this a mistake in d8ef5e311d7b, or actually intentional for whatever reason?
> > If the latter this shouldn't be a fixes.
>
> commit d8ef5e311d7bfde54b60ab45026f206eff31b2d2
>
>     mm/rmap: convert page_dup_file_rmap() to folio_dup_file_rmap_[pte|ptes|pmd]()
>
> ...
> +static inline void folio_dup_file_rmap_ptes(struct folio *folio,
> +               struct page *page, int nr_pages)
> +{
> +       __folio_dup_file_rmap(folio, page, nr_pages, RMAP_LEVEL_PTE);
> +}
>
> ...
> +static inline void folio_dup_file_rmap_pmd(struct folio *folio,
> +               struct page *page)
> +{
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +       __folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, RMAP_LEVEL_PTE);
> +#else
> +       WARN_ON_ONCE(true);
> +#endif
> +}

OK so it was just wrong at the time :)

>
> Both functions were introduced in a single commit, i think it's a simple copy-paste issue.
>
> The helper never had a caller, so nobody could hit it. If you prefer, I
> can drop the Fixes tag and only mention d8ef5e311d7b in the changelog, as
> there is nothing to backport.

I mean, it seems like a bug to me? If there's no harm in backporting it I think you
should add Cc: stable@vger.kernel.org in that case actually.

--
Cheers, Lorenzo

