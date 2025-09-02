Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9B38CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 11:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 087738E000D; Tue,  2 Sep 2025 07:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05EF08E0001; Tue,  2 Sep 2025 07:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8FBF8E000D; Tue,  2 Sep 2025 07:22:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D98128E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:22:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 995C41A0C06
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:22:28 +0000 (UTC)
X-FDA: 83844071976.08.104C529
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf21.hostedemail.com (Postfix) with ESMTP id A20631C0004
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:22:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="O 2BXkUr";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=ZNXlwNZn;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756812146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1PQWOI3a1pzWEaj/X6sn3yaZC01tqfWyJfPg2he1FmI=;
	b=0RVJB9H0rCqzEHFqvpxFXV6mLYPBN02vstT2dQ7zozADpsItUhpv35zUNBButSMEbyiEJs
	tjVIWCOQgW1sFO3ey5yM9pkaV0QH3lFS9pSXVu2Ns506kq8DdRW7JOzbaM9H71uBoCSP6L
	z5zTBs9AEUIGUGNHyslJj5o6whxMnEE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="O 2BXkUr";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=ZNXlwNZn;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756812146; a=rsa-sha256;
	cv=none;
	b=4Ew7rDgHrxMt5e0DdzT2NzBQ5yteIrFBtlDp7DTF8lMpVVG4E4YVYc5fExj+aGHbB4gq92
	EhpVF9n1AMogT//Xco1k2TLttpQxD2e1QPIqU48WIy+xBCHDYgf2Xd2JCXuXTFvjmop0d2
	ELfY4scVhBtLlP0dgecVRIfptvWdXls=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D4DF31400246;
	Tue,  2 Sep 2025 07:22:25 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Tue, 02 Sep 2025 07:22:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1756812145; x=
	1756898545; bh=1PQWOI3a1pzWEaj/X6sn3yaZC01tqfWyJfPg2he1FmI=; b=O
	2BXkUrqvLuL+UWU5OQYXJu0kyuYAsiMomEZcPRG/v9lKlSSKliWZYSm4cvmfgljt
	4DoX/tsWceI2cczYpdKobkmEgh83TdlVw3CLbRAfvcnQVYxPVlanbVpnB0EsaKG/
	Iosk1jDizAsiUvHlLlb9gGFCzdKMqUCvKMD9avWzeFtBBvWML8kqeBdS1CpE2Yx/
	bqbXEQD/i+qJwoIbKLmZ1jmRJfqboI7Ym01swWVSFjmakeGN8Qgbj+xEfTH/F4xP
	Rr7XlJoiHKaQ19yXbhoEyC+QEEZ4RbbZLl71waLlUW3W6Tb9SKGYP/ezYpMOprQr
	sqKc24Q8l873Ti36fE0Pw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1756812145; x=1756898545; bh=1PQWOI3a1pzWEaj/X6sn3yaZC01tqfWyJfP
	g2he1FmI=; b=ZNXlwNZnwp9xeh7bSCn9UtW/TgaTmnO0KqaUh4ejc/p+qfFfX1t
	KC2D83H58rVgwPl8gNYxrlFt1QJH80R6WY5ci/DzVQeXHpgrIlYpqPbyw296PnCT
	HhJ1kwUcyxGcDgHQkeJzPJgDEqr70T2g/dZrCL7dCl2lKhhozslW5loK08WlF86y
	6c2riHUSiqWGBApf2aWu15mMN6k9vdJyjv1bU0YH62TRrMe199oZRiszUlS8xu35
	fpeJ+6JK6dLUbE4LJf8jV3aWfnrkvTrG5O+d00uYhaopkDVgVAGjTPH91d2NtopJ
	p3LApxp0TjW7A15FfhOAL8RYToY8YNQPlNw==
X-ME-Sender: <xms:cNO2aK6WYbFv5qhE7G8KyCkzLRfRcCULV2BMK1Y6dd_znpubMH3ukg>
    <xme:cNO2aOsNjs_QQzOWduYtTrkAPKa8lZrt798LMglLLk76Wa39oOfgZqoo0kKDkuH13
    KI--l9hGB_V-5rsuiQ>
X-ME-Received: <xmr:cNO2aHvbyHBwh-OqHWDO3TAyQaQCzcyMoTNZ0PJ4l7N1i5q6VRMHQHVBPqzb>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegrihhl
    ohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpe
    ffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfuhhhu
    thhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrg
    htthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtleduhfef
    feffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfeegpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopehkvghrnhgvlhesphgrnhhkrghjrhgrgh
    hhrghvrdgtohhmpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghp
    thhtoheprhihrghnrdhrohgsvghrthhssegrrhhmrdgtohhmpdhrtghpthhtoheplhhorh
    gvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepsggrohhl
    ihhnrdifrghngheslhhinhhugidrrghlihgsrggsrgdrtghomhdprhgtphhtthhopeguvg
    hvrdhjrghinhesrghrmhdrtghomhdprhgtphhtthhopegsrghohhhurgeskhgvrhhnvghl
    rdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehnphgrtghhvgesrhgvughhrghtrdgtohhm
X-ME-Proxy: <xmx:cNO2aGutAYR8QsCu4heOsa7cvNQb6cLbJ-cX6uv3yIRcnmRTxml1fA>
    <xmx:cNO2aH55uEKW4Lbuud_CAiE-z-Nyf7YJ9eqRxRWt4vkPUR-iuf0TwA>
    <xmx:cNO2aJA5uXS3ir4_jHW0kavejFGjtmIBQHbNwWHhtUVPnXMVXVfubg>
    <xmx:cNO2aHv-qcobKTpSxUZ9hqBMxqUy5BykxK7oI2CfHELYJrceAYQtTQ>
    <xmx:cdO2aBV3jHOQrMrU6aMYVpHDh4cCi7JP7c9iLvUUbq__f954LbeJFu-U>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 2 Sep 2025 07:22:23 -0400 (EDT)
Date: Tue, 2 Sep 2025 12:22:21 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: David Hildenbrand <david@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	willy@infradead.org, mcgrof@kernel.org, gost.dev@samsung.com, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH] huge_memory: return -EINVAL in folio split functions
 when THP is disabled
Message-ID: <qh7s3j26aac3hyzgnr2ee6byjenstxhjnlwn4qxbvz2l32ohqc@qbhdxvpnuhtp>
References: <20250902084036.208921-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902084036.208921-1-kernel@pankajraghav.com>
X-Rspamd-Queue-Id: A20631C0004
X-Rspam-User: 
X-Stat-Signature: jx8ixfomz6mx6ydxp5e449pjjwh5hkir
X-Rspamd-Server: rspam09
X-HE-Tag: 1756812146-359103
X-HE-Meta: U2FsdGVkX19s5sE8MeBEXVvhA1OsRC4wrEuXv1LbImoEqHgM6wcctJrge1DSeRFN1KE293bvF+huzawiETYPA2uPHLFV4rLyDhu9JhC+GSHrsi9kKmQkCa+U7DLaoILfS6N/n9rYijbSE6A/1V3IHEMycaWfnMvaMf0UBxa7DoQdSqmaa0U0cokYGEzmXuLXqG0RpUluJAavxgG87ZVSbpSyMl7dWjqKXPnSXwsjmyXEsv8EESK/CxZeY5OKIkPjTUA1R9E+NKFbHEEJwJD3llXmUQoManZIFoECvFOj5bvFgFCxccHakoEKQcx0N589fTPORHFM3578UQhIRp8eSGsXU3IRYZ+tQnGv8QNRdCBX4DYlCjevltGI/TvNcyXTBoTtYhHuZLWT59WvTR0dpeH9pMiq/cwWBVfZhBqWRFdUAjrSYtSuDty+a11iKsIXIlEX5ZXYXckMOl11y5PH7tPcb9c0DHBWWoAt58SS0x3na3wN6xYnObr3VVi60eHt+mjLpr2WmDFAt9bK9v0fso7czJmIiVlwNz6OW0JUjSp5mTaf9fJ2A0h8EGzxbgDKQ2s7y4wy5rEp6z7swQntPlvwAj7H8Y0L3ne+jfMWvU20Q4yAIwedSN4UTqVHCvyGcBgsaQUkcPfFLfqnDliH4HCAtX7xp/HzpSP23c3mKR8dHVqoDUbjgF7VuuiISv68BuN4+icxs9BV5Ih1CbzsYjo1b5YttRVfbtGGqza/LgF0omLW12PWn8GBnexokqDUaYEzGuds9TdSAhlBOZ1yfoROGn/+g4QXqSSi+qqlqnarWrlyzz2F+HLAdJWpDuEJ+tM9zr/FKuaF5JZRd2XKdvv7TLVoBdYlAOTEufRd6/5hBSq25SH2pJMPcnUvLHOf5dHVRux3hlzxuutnNu+MgW41/p6LXSZ7DZIBW1UDiuT2uHg6fcY8y15xqYmr4+HU2HtLCjWfczYMtps3ypN
 LPCLQcPb
 9bf9B17/FuLkB6kXTT85fsQG1AhaaIfTOsKKbveYB0loAMsXOF2FxGe5/6dJgbjJlWo9Hn8LItknnGyJwEkwCdIEVy1tAUBTpYsa4kAG3VtQduMaoRnJ/mOY2Zwxeo0nOKR7wl89BEu3kLlxtEtr94gwdngtkOKkQKcXzniZfAW/GVu3Thadl7B3rQR2Ylm/3AJFy1zgkXvCYn0y6RdGl8m873gIN6rGGeVPIFmt4o588/w31gB6tq67JnWgjFhC+8eSsOpTegDrusIrWW9NjWwqLsIj2L5G7krIZdxURHGhA252kKLpegza2tFmlg8H6vc1sbv7YdhofmL58Pj3+potXgJpTE7Mjr3MilAQDE5CAhmBj0hq0nowJbTHTKUkmA60YD+Ne8zjLnm8iGMlinDbznIMppzt+u5gTFSTXZJSSZHZDwSvnUa8npw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 10:40:36AM +0200, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> split_huge_page_to_list_[to_order](), split_huge_page() and
> try_folio_split() return 0 on success and error codes on failure.
> 
> When THP is disabled, these functions return 0 indicating success even
> though an error code should be returned as it is not possible to split a
> folio when THP is disabled.

Other view is that the page is already split therefore nop.

> Make all these functions return -EINVAL to indicate failure instead of
> 0.
> 
> This issue was discovered while experimenting enabling large folios
> without THP and found that returning 0 in these functions is resulting in
> undefined behavior in truncate operations. This change fixes the issue.

Could you elaborate on the undefined behaviour? I don't see it.

If you argue that this code should not be reachable on !THP config, add
WARN() there. But I don't see a value.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

