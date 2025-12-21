Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D09CFE67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 12:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 322BD6B00E0; Sun, 21 Dec 2025 07:42:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0F16B00E1; Sun, 21 Dec 2025 07:42:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DCE86B00E2; Sun, 21 Dec 2025 07:42:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD476B00E0
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 07:42:51 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 944C513BCA3
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:42:50 +0000 (UTC)
X-FDA: 84243442500.16.2AC8469
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id B94BB100003
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:42:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SmgP8D6+;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766320968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GzdhnR2YNZXQ+KYGbrDA5WK3eQTd25rFnUcMaLp5Do8=;
	b=qvF03fSURCt+VWS2/EIxKSsdo6BaT5kHI3UsD+6x70Cxrjalqm5YoPTMmSQeOe/SHQvfVZ
	QVrSZzZXDB5vDK159xuHLuffLGSN4buNkIn3teGyf2geRlr5X/g3ZR/fYCqT38JAQ5dGCd
	p58bAQYVn8y81LGqzCbNL8FAo5OTMAY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SmgP8D6+;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766320968; a=rsa-sha256;
	cv=none;
	b=hOld4j/96DpV4997mxMlrjQVMf6G/Uh/JJr/CyKaDeiR4qcp+tpKmbcc9CHQ0BKt4NkqFN
	QFv29ThCoHNLy+dFz2mxlMpLeWwjF9UIpivatUAyUufgreDuwPDsR+0/5/uInfJWgnYjdq
	5/Jll+VPnhV6vkj/NNGJ4u+c0NT2N2o=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8bb6a27d407so299681585a.0
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766320968; x=1766925768; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GzdhnR2YNZXQ+KYGbrDA5WK3eQTd25rFnUcMaLp5Do8=;
        b=SmgP8D6+fTNuVzwi4S1Gn24UW5epYPnme+IJOvf7liEinR4WQbe8TrTqPmr9NLg89G
         O7sSBirWiyZ+iHbYnTPiqq28Z8MUfhDcCFon5OFQK1OO3+nsleQqnmmZ7kbpVsYkEAYQ
         EwBSEmpuPAHDMlZnHe60ynmQigWTvSVfvaSFY8rnHeeKzKvyIGSgkB1dSZZbaIHIKUut
         pDHkhECJaYbfcRGSWLLyLkARrWkR7MUKWY4j/6OJULgrm/CkdSkBNruelbrZwFExFBoz
         lVlv7Kosie4nQ9srrkqQ+p8JUSAKNix91iNWH4crKU8xyuBg1geVyTKdjFGGGJx6qVgx
         TLIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766320968; x=1766925768;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GzdhnR2YNZXQ+KYGbrDA5WK3eQTd25rFnUcMaLp5Do8=;
        b=lHO9sQwKSpSFFDrYhECjgN4xF3tuxmzcBz1FXhCiE1cm5TDB9r5UoBQFtztx+zkVWk
         GMdQl62qz/nfzdE5nW9V0a/QYyvUoP+/IWMhpaCZudKGsgD3bYUWu1lGNJd5xouwuqY1
         MgnovFaCRdmuOKSK4SZ+RqB5/LbD9bhI44czCPicZfNPbLp+lIVNTSCD//7QKns/KK2V
         c4zZAg3R59gITgn8UtrxujDVOegiBGYucKMfixHzNEfQT0YtTRtCjrSyskRVpp44EJUt
         i7gGvtO7Ew0TLIP/cUBFgRASz6yOv1rVhiJqNrhWn30SN6HZP9InInYajw6kMfIS8WTI
         j0GA==
X-Forwarded-Encrypted: i=1; AJvYcCUSlWAN0uLME9+rDlGfezZk9RcqTRfHGbZpssOiU7nICoRuwOAvuYm9ThJrioPEzcMK5Wwkdh2HNA==@kvack.org
X-Gm-Message-State: AOJu0YzGm5Pqq1c53RhbAPNz3/YJTa6FbQq8nZfwHWtz0w9ieHBQptVJ
	MKYEYGV9jZ4Opof/gSwz1eHzAp7xvKvTN7JR44966QMHuXxEorqgXhw2ctlsyyltFXE=
X-Gm-Gg: AY/fxX7XxFUYK99aF9uTryvvtGA0qxWpYuOPtW/+rCwTBRPcr/6dDNiCOxsTtlCdXUW
	V7LFV284A0BTTlunFEjdUqxaow6YyMUKQZlw58V4brlg6Mm7yWugVb8R/SC5Dn8SKhK0fLNaq4C
	AEv7t987gLUxl0DB07RLP6tderzn2Pdg0kq3X2JmdwBJ6x/Qg5ODOmKOlbOv8L8hi+g1kaZhhZx
	jjodVeXwMo2EmCtWhjONnc5lIfGTN8THbOY133ZrBFrRRN4JSSiwmAQQq9mIm7RCGKZsmasVcug
	l2lZ9Aq38cmSULHn0IJhd3+LpSvvv3x6NTs5FmZ0rMxsMmn1lTuKkL78+L95mxQnec3EJcsiQtX
	YrjcVTQV6cubJPCNLEkQhf0v5xnb3K/3qvFCWVIk+LDQRQPOud9z/R2HyVBRXVs3mJEsHwyeyFi
	qLJpQAuf9auqc1OcEnFP6vxagNx7CyfbGE09mXI5wGOojsNk6MWRtECC70eZKE+sHH3O5i+A==
X-Google-Smtp-Source: AGHT+IFxDZsXvwA/Wlu/ERs4meUfrrEIdfd18oC9/D5bfx1lMCs5IZH+WWgu2rqfTgF+yU2gaqHpOA==
X-Received: by 2002:ac8:7c4d:0:b0:4f1:ea37:cc6c with SMTP id d75a77b69052e-4f4abccef5cmr118092311cf.1.1766320967720;
        Sun, 21 Dec 2025 04:42:47 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac650703sm59927451cf.27.2025.12.21.04.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 04:42:47 -0800 (PST)
Date: Sun, 21 Dec 2025 07:42:10 -0500
From: Gregory Price <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	osalvador@suse.de, rientjes@google.com, david@redhat.com,
	joshua.hahnjy@gmail.com, fvdl@google.com
Subject: Re: [PATCH v6] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aUfrIqfo0mcGTSVU@gourry-fedora-PF4VCD3F>
References: <20251218233804.1395835-1-gourry@gourry.net>
 <20251219000800.tnpqzvcdyeqcwryt@master>
 <aUVgoEiaXj94IBmW@gourry-fedora-PF4VCD3F>
 <7EED2D83-AE17-49CB-BDB6-954793EAFDBF@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7EED2D83-AE17-49CB-BDB6-954793EAFDBF@nvidia.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: 6qxxm73xmmjy9srtdzqg8a3sbeda7k3z
X-Rspam-User: 
X-Rspamd-Queue-Id: B94BB100003
X-HE-Tag: 1766320968-636429
X-HE-Meta: U2FsdGVkX18w1bSQC4DB1QiDekUdIS5zhFYIDdODuJyLBEnaG1gktQJ8ACQY6i2FqwXaNaBli65WLy0RH+Ov/550rC6BZ0IYyskNxbW0PlokAl4LSRrGSEVyBs098q/sJjTPn+se6NpQtZMFVja7szi+u23CCcEzGNGKTucIU51wkYtvQSX3lPLwVJZp2mjllLZFR0JoFcULiNOKsm2miYx5bq0KHQ3vwf4qwZNS1Klz94dEVP7KYbaQYQ3r8MEX5/9DCXLduVklHnqYVq5Er0KGJW2xwq6JSrzoXFKQxZ2t5FbshjA4O9cXF3aRyb7XFMwtYnWU+/orNCH8d9m7RAWrQRaslAUapV8/4unNVPc8Ze94nUujMyBa7ltc2bb81U8x6T6Dk0DOoY6Yd5tHgohu/t/LmUcxgKw8cY4uqHVfEfx33K8+oItscizBFtPRhc0bwTG+ZAMNnAv4tvx7AmmUkg00dtb/jvagEm6EOlD0RJ5OGgrWXHnlagWqm4WmZxYqLTB1glO6KlsinrjBX7IGFugDeUvjxiMcLls9ewtiz6C96y9tzpopUDYMzxI/7cfGo22Fcc4+k9vnkgupufssupud0/PgroauXuPJrP/fLQVkXZFWYLitKeuxbtsrLX4GYgTRQof5eTu9K/FYWn6woAGQxCeuFlO/PlVvyTDyEGx3HiUiWVwPkYat89VGijN1IgY7DPhGGqwxiOGWtYJMMIC9lb3//nCVAMIvRYWdcup521v4rQCKy7ioPDxupKYAIcZU4nCW+zFn9eBJYd2WJ0gns7ZwWMyQDw2c3//Eei5xa0bj9h0vb7d4EGKDmAuOzT1i5stW5AN0nQDuFykgXdkmjtVd+xkPC1KLHMJznQHnFiNd4QQxYeiDtkO/UMNp94z+ceTHd8Eb3wD9h7fKDFekzvA3lSGhC2QdBHQgFi7DvZ6Tf1uHM15AcCWhVmWbVqLK1NJNAAjMwtW
 x3G71CVd
 iwWGculC/q9dzSXlQ0KnS06iLZwkPdy9sbhARo8gWg+Uau0MljWigqlQLLoxtxjsU27c+p7ch7HF6GBdoHrY3xSmStbrFKMX1S7dkdmxIF3Y4vjZXOT+Lf3XqepRE43C5+wcyfXjQ22pxQfkDjpaoGkio/8KTMYcOpHdKbFvoyYz3Wop+RfVvhBQdX5m9DPXdcZgKldRZ+vCW1fTrrbpqmDmqYlFDdNtfmVy2tVynwXlL78le7KImpZDNYxbo5qXN3am2CaZFWFB2KiarXq3R5pa304+BNxYYRcfLLQLyOmOT7SvGdE8jy2ZUCjP6aEyayWMdgNRiUl1iIsYiJGVKurAIgHdsyp2T3vswLqlxiO/9WklHmKWK2TjBpb1EiHQ3oBvMUUDYA9yjGcWiqeuwZBB8bSLty666muhV1KDYPhfOJERU++S5cQsTQbSo3g5DdEQR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 03:46:25PM -0500, Zi Yan wrote:
> On 19 Dec 2025, at 9:26, Gregory Price wrote:
> 
> > On Fri, Dec 19, 2025 at 12:08:00AM +0000, Wei Yang wrote:
> >>> +
> >>> +			page = compound_head(page);
> >>> +			order = compound_order(page);
> >>
> >> The order is get from head page.
> >>
> >>> +			if ((order >= MAX_FOLIO_ORDER) ||
> >>> +			    (nr_pages <= (1 << order)))
> >>> +				return false;
> >>> +
> >>> +			/* No need to check the pfns for this page */
> >>> +			i += (1 << order) - 1;
> >>
> >> So this advance should based on "head page" instead of original page, right?
> >>
> >
> > hm, I think the thought here was that since we're moving forward from
> > start of an aligned chunk, we'd never hit a non-head page - but this
> > may not be true.
> >
> > Will think about this for a bit.
> 
> The sole caller of pfn_range_valid_contig(), alloc_contig_pages_noprof(),
> scans from the beginning of a zone to the end. pfn_range_valid_contig()
> should see head pages all the time, except it scans in the middle of
> a 1GB hugetlb when alloc_contig_pages_noprof() is asking for a smaller
> nr_pages, like 2MB. But in that case, the if above i += (1 << order) - 1
> would return false without reaching it. Basically, to get to
> i += ..., pfn_range_valid_contig() needs to search for nr_pages larger
> than PageHuge(page) and nr_pages is always power of two based on
> alloc_contig_pages_noprof() requirement, but that means
> pfn_range_valid_contig() always sees such PageHuge pages as a whole
> within nr_pages range, thus cannot see a tail PageHuge page at the
> point of i += ....
> 

Thinking about this a bit more, it might be worthwhile to detect this
condiition and just skip that hugepage in the external code.

while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
	if (pfn_range_valid_contig(zone, pfn, nr_pages,
				   skip_hugetlb,
				   &skipped_hugetlb)) {
		... snip ...
	}
	pfn += nr_pages;
	/*
	 * TODO: If the last scanned page was a hugepage that caused
	 *       the zone to be invalid, skip the rest of that page
	 *       (e.g. if we hit a 1GB page trying to allocate a 2MB
	 *       page, skip the entire 1GB instead of scanning the
	 *       same page 1GB/2MB times).
	 */
	 ...
}

But this solves a different problem than this patch, so i will defer.

~Gregory

