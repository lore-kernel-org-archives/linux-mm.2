Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC4D606A33B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=uR+T25uH
Received: by kanga.kvack.org (Postfix)
	id 714666B05B1; Tue, 10 Nov 2026 20:09:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C59D6B05B2; Tue, 10 Nov 2026 20:09:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DBDB6B05B3; Tue, 10 Nov 2026 20:09:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3AB866B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:09:52 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BD9041201D6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:09:51 +0000 (UTC)
X-FDA: 85421056182.08.8BDAA5E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 89B8CC0009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:09:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=uR+T25uH;
	spf=pass (imf22.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794359390;
	b=kY+zHZLdXCeBIG/rrxBvseHBQ/+nV7IVKaNrXbR1SNZkmCiIiXB7sRKe9UQsivFgqII8a4
	fa7Z6hF/l1UXDLdL8iwoI5fh0BlKsQEu9HI504vGBUdbpT7iDJysCIFq08ZRtgey8BYhg3
	tPpDobLuNQvsHXP1QeimLk9Z0IeckBM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=uR+T25uH;
	spf=pass (imf22.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794359390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FIA9nXl5MDGFx7HCmxaQOKJbU8t3S2XBCcL09Ok7ifY=;
	b=TJMdyqVKiNAAzXD5NqaDhiFGzW+lgRx9vpaRIsNq+s01pDiOtGGlesIq07HrGLX7OWrIjO
	6UW79KfbfQGtdDMmxaSxfn7VnuPGsFSYMaUAAZL3Zop6yYsQoLQZM2lNadn910EI1IHvvC
	ezkSG9gMZdBaYBWPkHI/BjqsAKrPAwM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FIA9nXl5MDGFx7HCmxaQOKJbU8t3S2XBCcL09Ok7ifY=; b=uR+T25uHbz01nyBGay5Gh1MBgZ
	/NPRZJAfigCeg+6QKsOKXI17e/9ODt5JsEwMnMPAThYeOtYqhOzey0yCWvVvqA65grMx1oJvMIlPU
	hiyej0FSXvZgic4InSM3u2IIa1dPjG7tQEslpgs7bt5R98UTeoCVKo5UZzUZuDyTkY6vEnNVXidAd
	EEVUU0otdIOlIc4sAO1F2/xphx/gJ6a4og4UeVM2k/ZgJdX04kMdJ/PP2HJXzUHndZ5SLRVpx4ODf
	yJcqTZVELoRVYMY7DhFazyKNsZBcd0i84m7++VskFr9d8CRHXKUD/EiM9K8S/ZN262fcFr+m+9ZqS
	WoZPChmg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xQwqR-00000005Lwb-2Ptf;
	Wed, 11 Nov 2026 01:09:47 +0000
Date: Tue, 10 Nov 2026 20:09:39 -0500
From: "Liam R. Howlett" <liam@infradead.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Frank van der Linden <fvdl@google.com>, 
	Ivy Lopez <skunkolee@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/cma: simplify cma_declare_contiguous_multi()
Message-ID: <2h5vqasbyjxmdpzvtnsih2nhrjxmblpv46zl4phbn4huqadn3u@w4fcjow2wcvu>
References: <20261111-cma-multi-v2-1-4e2dddb2a2d8@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-cma-multi-v2-1-4e2dddb2a2d8@kernel.org>
X-Stat-Signature: ywpzdkrnyxd1b6u4tisehweq1hsu7ub7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 89B8CC0009
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794359389-964139
X-HE-Meta: U2FsdGVkX19U6fJZBqytldrOkJsTKPYomlYxUBq2SjtQlFH2u4gi5fhQ4j16r3eVFgVcmDhYNTdoYFa83uFS1tqMZlZxwIqK8mDSrxnP0QHzZiKcLeQXPICK0R9Uu4vRDB2zMVOObvGuxJkNqJzQHT14AYENNUvufCtJ4oiWNFOi26uEr3hDsOAgklfF2Jb3tlJY/YjwONTohvGl2MgNo+Sk6nTxfSapnFBD5+lxCv9LIk46/Kv1f2E5XpxXKyYmIafPtgqCzozF6tXXzR8wQruWuOmndVCgGGa2vUkmLVmKQzGKezx+ziUCKmEdXGP99IJWpasEQH3eA72mm6lOzZ/46opcUt2ruXZaIup4AR7VAa1182IyDMayYUrZ32DUIKNrs5Wv2ts2zirHkcRyw9vs+J+drHg4fVh0vOTF24y7ftvIPI+pAsUhKxS8Nl2llx07XXqbGJX9941sGmI8kMF1Gr7qSNjfnK9G8T7hDBqWx5djMsNMwE/uQUoUoX6S54eZxO2+xG+l7bvMvzPtujZHtTVXVAhM0TysJThcTfVqEbyoAjz2wsFQXUsE5J0K++CevdTnE4a9iLw2w9Cw+Y/b6fjAibBWbndvFAcmapsxd9Fl/VpmYbO9MhZll3CW2oNAAlaN4uyp6wGAeFoSsoEtnleQdJt0jQnwRrCucYIdKtXze1N81QtdM1P7NwH1lry295y7U0Ok+Z0LVCEEtAApk1M6HDbPsgwQOZJjeIc3h8hSaI65rsPMu74oiQIBx3wc3g2e5xnuyHmIDFo4oNGBYSsWx63RxgGpYY1VYrYJXSAwUjr0qM7/V9NltteE1Yio+/65vgx3ZulcMhIHK80ovcbosbiA1hpY2wUt7f+FVZvSDSi/N1G97hgDXdJiam95Oj0cZg2kD3X7A64OxR2jaCSF0CR+blzzaOBOEMh/mGQsos1fV+Qr+THv5URghc7fwGIXd6TSEDPGhZR
 RwEZL/Z0
 UZU+dC/QK9Rr2Eo8e74xgi2q/5FLSHGEUmXQVveyqRz0IeUZQvf8Lrl/iZHCE3JNF5mCXOjqXj7EhK4fxeABGZNHn2K0XThPYPwwfqX6XqxVqH5o/iOZjsmV4fxdnx7HqXNBWJC/XPL4DAm4BzIQ9/Y0zka63vBCpkVN07lsyIK2DuuLUgDeku35GoGdQaPO9so06TbA665O8wnu8V14Fw+iDxIxs1G/HZiieDoSefBbeUy4V99p2BLeQ8m6IIsJdyrLLTzOCRp7QoyOICMtxd9TkDQ2LCee3JyPMc39o3945CpMxJ+ylPJMvpX3nvwXLWmH5q4ZbmlUx6NCzXV4Vsay1gZqEcVCLl7b8QbCJ5Q90GljQ/AZhDAATGClcxyis4h/K91LhsZY074LDdFD29Y2wFJPV9xJK6s/PWS9oQsSS4QBe2MX6pM0Afw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/11/11 12:14AM, Mike Rapoport (Microsoft) wrote:
> When cma_declare_contiguous_multi() cannot allocate a CMA area as a
> single range, it falls back to collecting a list of up to CMA_MAX_RANGES
> largest free ranges above 4G, reserves them in memblock and adds them to
> cma->ranges.
> 
> The list and subsequently cma->ranges are supposed to be sorted in the
> order of base addresses of the "allocated" ranges.
> 
> This implementation has two bugs:
> 
> * The allocation may fail even when there is enough free memory because
>   list_insert_sorted() sorts the list in the wrong order.
> 
>   When the list is full, the largest range is evicted rather than the
>   smallest, the final list is not sorted by address, and the smallest
>   ranges are used first.
> 
> * the function may report success while it reserved less memory than
>   requested because sizesum accounts for ranges that were skipped.
> 
> And overall it is a lot of list management and open coded range
> selection for no real gain.
> 
> Replace the current code with a loop that finds the largest free range
> above 4G, reserves as much of it as needed and repeats until the entire
> area is reserved or CMA_MAX_RANGES ranges are used.
> 
> After successful alocation sort the cma->ranges by their base address.
> 
> The new code scans free memory once for every range rather than once
> for all ranges, so it is slightly slower, but it is way simpler and more
> robust.
> 
> Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
> Reported-by: Ivy Lopez <skunkolee@gmail.com>
> Closes: https://lore.kernel.org/all/cover.1792032699.git.skunkolee@gmail.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>

