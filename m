Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F56606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 02:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YT0/6zfF
Received: by kanga.kvack.org (Postfix)
	id 531696B05CC; Mon, 23 Nov 2026 21:58:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E38D6B05CD; Mon, 23 Nov 2026 21:58:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7FF6B05CE; Mon, 23 Nov 2026 21:58:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 149976B05CC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:58:36 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 099F81606A7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:58:35 +0000 (UTC)
X-FDA: 85468504590.16.D505B03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 60288140005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:58:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YT0/6zfF";
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795489113;
	b=QAK1k1oyDdMidLeolsDF8KM7V/svVuJ+F3Lc2+gCPna8Hub0Vt02GgJxw6KjiSPf/qMshp
	PeW9ds0GNTZcbwmIPhLMKLrzqMHaVOgSQib6nvn/gzM+804KSS86/jINXuFv2iKH0t63Wi
	FQL53m5X8tOoBCnPaM+NhbFScQ3XtuA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795489113;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3cKmPnbh3Asj7wY0nGQjAWSFwz0N9DszuqGSRPlzi1s=;
	b=ACkftPUe5NQiJcfHu3WhATCgdaesOTLINI/pghBJasfg/0Ar+McqBAi5+8j2Nxw5Y76sDS
	+jL9T8rn5l//6EP658RNpQyPvjARdeMgHIHbD9vDakMBcgvosLvG8Ux77SXe1GH1ple+i+
	hSGjFHSsuiR4MMVVUxdp14FHgbDvrEs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YT0/6zfF";
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5ADE140B3D;
	Tue, 24 Nov 2026 02:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992C11F000C4;
	Tue, 24 Nov 2026 02:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795489111;
	bh=3cKmPnbh3Asj7wY0nGQjAWSFwz0N9DszuqGSRPlzi1s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YT0/6zfFM8qoNZM7+AU/RpaxJ+xexGpK/KQvZpiAuMzFQJ/y6cCpihfvCd+EQLFQ2
	 ZdJLnjUWVezOUuT/bQ/wOGdwUvtM+QniIz1VxUtZ0rWUV2SlVrAK5FFjz4ypdGcpzX
	 uEJ/xOq85MCzxAa+aW8bFMQAKGmCIX2P7dJQVzb+8uANMAyanpUh0/FJstSncZ71Af
	 nq3he7bMQnb7VHt7/tU8mbggP9euEwIfEaojTo88qGFQ5EKcscWEWkYM9w5KcbDn54
	 DIcy4jYKESUh5a6i00AzvqT7z/0vL/0gElrem0vCDXQ6ej72ykq2tGiqMHNkK9WbT1
	 nF0HQScW5oDVw==
Message-ID: <sashiko-outbox-230432@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm: fix cachestat NULL pgdat dereference on DAX
 mappings
Reply-To: sashiko-reviews@lists.linux.dev
To: "Henry Martin" <bsdhenrymartin@gmail.com>, "Matthew Wilcox" <willy@infradead.org>, "Jan
 Kara" <jack@suse.cz>, "Andrew Morton" <akpm@linux-foundation.org>, "Nhat
 Pham" <nphamcs@gmail.com>, "Johannes Weiner" <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org
In-Reply-To: <20261123030014.3116755-1-bsdhenrymartin@gmail.com>
References: <20261123030014.3116755-1-bsdhenrymartin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 02:58:31 +0000
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 60288140005
X-Stat-Signature: kdhutc9y5j6dxtegqe8kxgwaj53qw5eh
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795489113-354705
X-HE-Meta: U2FsdGVkX19YYd445495e/zNAyIq7v6Zx6Ts/AGakW4S6SyPYOjydG3zEWY0vFbO/2TE+Mp2x7+R1wrtxQFIjltpccMuFSbdmTrPInlONU46vyO4aVBa5wlSOR7KefT7tQNSxOK4Kz0Gpvnb/eoB4RpWv/jEKeyg5NrQOvtIBpUAUZ9mS27gjGuLtYJXJkjw9zP2C1hppIGUWL5O0BE6rsFIRYDGfvj6xVCVNiVigzgSPJ2dCK0Caf/T/Z9WZ2F+SRtXfEUpsDiKpHteopo0Tf3ZbKa4lToz2ppjgdif00yDeJoweFMeoUCILlAX3qklzOIfQBlWu1hcppPD18CBHC0x4HRUnXYd4SIEsZ03SDSGvJPECOZJfVJPdK4EzbdDyQnXOUX6HJOIOVnXnKLl9QcYk/62uOx2xI5JQr19+aLT3aeTkQEp4MbdqMJx9Af7G2yxHVGso+DswytPKyJ6c9KjaM5bS9jwSy9xi8gHLhhwQ6B21cnYZ0M8c6kVL8zANrUo5klTGdrtN1i3VEtng/go9thZetb9uverg76see5lr6eifSgNCPdTjQKY9xJl8ZRA38XwDva21wyKcIvS9p0RWKemObY16JkALBK7jHBSNfzwUyeYiUUYY//bxBmsNfoRSU37ZcluHo5tneS818Aw7k956zFaHucvEevYyrieGQ5WKIdjHRNIc9nTuFDVt3gXF4lD0ZR1oEkj8wQRtwt45J+yUepjWlxRbUyR+QUzxF71BqlSrKbY0ilueDNd+KP8o4TAVHGniFEVTpCauw6LRQ8KnNxGd2UtbKEODwkzFv6G3lue5UCCXTqWjsVe/ONIX7KXepKAXdH2N5zUVWnIXD9akCVCC/1AL3xeKTikF0yVPFnjdXgem8EctDNN8m6lztEhmy7z65jW2akmkMd4MmJhW5/fMEHirYbiY01prGahO+cC3ksZSQvN2ugvj18DYXLr+lIqKXn/oj4
 fkzky7a3
 7O+YCmY1l3p0sqT7fWWHeCmpyrUTXYZiz2+Fy7FHL4wa0r+RFZcJ2k7c4laB/qQYmx2Si9/hVlBP1Hp3VXVPD9zud+QJ0Q3OIQLGPNBJbCg3JQymWIeBo2qToIPys9jUX+mqCPpSa3trRUXLAzqOoyCJsW6fd9agYAS9bU4QEiR5lH6m483XfK7buVCr77s8Fg+X3C0rGpK6xXSzid2fRYh7niRZ87dWXwO4feoy9y6Xc7hXMbB4sq/dDb1dlnhlNUEFd2razr+RB0gn+Z9ceObpi524SzZpeDtFXiYLjBkWtTnUUrRgRN2OkbfCo+r/Q9x6dRHLmVZXV11wR1DNlYwCc6pNRkEKmdvAhpuHYkUGA/cx++boA/wtUZJcvr2Gv9BOUu3qh1vLuVilQIucdH9fBLCDskRL/oOwhULow7d3hz41bIZ/QhXZrXZdssrAXagp/2pf8AYgK/u8zyFp8qqkiLDwg88mDn/V4atzfljjqVbKYtrkRe1+JIwR5COND2HYXHZIQi4Zb7tgObvlrmKP418LwmlmBVnNsPnTQFTgyU1ZfDsb6oxas2bXCTtli36bFH+0tsbqeI21OupTuUBFZwlDw/Mi71PGwUmWddgOP8fkx/XZ2f1+7suSniCrObl8viy+cw+prwW0hPdp39rKuFUiDNh1B0C+3nbKzGKh44ZnXjqkMpH9kubUP3HzuJbgpeohW8+FA7+miGHB3AyMeaKNeuFBErPi2yr/mqvQMd8r1MvKFrgOVMZi4VqsK1CiLjNndMUvtPUjEuCdpVSsVG4TPL4ZErav2fYYiPkpCb5nmo1VFkZLQWQ==
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
- [Medium] mm: skipped dirty accounting for DAX entries in
  filemap_cachestat()
- [Low] mm: inaccurate commit message claim on PMD-order DAX entry count
--

commit 00a07291e64203188f9848c4b4c587fb6f5215ca
Author: Henry Martin <bsdhenrymartin@gmail.com>

mm: fix cachestat NULL pgdat dereference on DAX mappings

This commit avoids decoding DAX exceptional value entries as workingset
shadows in filemap_cachestat(), counting them as cached pages instead.

> PMD-order entries
> are counted as one page, as value entries carry no order information.

[Severity: Low]
Is this statement in the commit message accurate?

dax_iomap_pmd_fault() and dax_insert_pfn_mkwrite() insert PMD entries with
XA_STATE_ORDER(..., PMD_ORDER), and filemap_cachestat() derives nr_pages
from xas_get_order(&xas) before checking xa_is_value(folio), so PMD-order
DAX entries are counted across all pages they cover.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index dc0ceaa58a0f7..5d12230de32d9 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -4706,6 +4706,16 @@ static void filemap_cachestat(struct address_space=
 *mapping,
>  			void *shadow =3D (void *)folio;
>  			bool workingset; /* not used */
> =20
> +			/*
> +			 * DAX exceptional entries track present pages, not
> +			 * evicted folios.  They must not be decoded as
> +			 * workingset shadows.
> +			 */
> +			if (dax_mapping(mapping)) {
> +				cs->nr_cache +=3D nr_pages;
> +				goto resched;
> +			}
> +
>  			cs->nr_evicted +=3D nr_pages;
> =20
>  #ifdef CONFIG_SWAP /* implies CONFIG_MMU */

[Severity: Medium]
Does jumping to resched here skip cs->nr_dirty accounting for dirty DAX
entries?

DAX marks dirty exceptional entries with PAGECACHE_TAG_DIRTY in
mapping->i_pages (via dax_insert_entry() and dax_insert_pfn_mkwrite())
until writeback flushes CPU caches.  Because the in-cache path below only
queries &xas and never dereferences folio, guarding the evicted branch
with "if (xa_is_value(folio) && !dax_mapping(mapping))" would avoid
duplicating cs->nr_cache +=3D nr_pages and preserve cs->nr_dirty reporting
via xas_get_mark(&xas, PAGECACHE_TAG_DIRTY).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123030014.3116=
755-1-bsdhenrymartin@gmail.com?part=3D1

