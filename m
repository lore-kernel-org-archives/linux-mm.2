Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C10B0C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 13:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C92A46B0095; Tue, 15 Sep 2026 09:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C410A6B0096; Tue, 15 Sep 2026 09:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B579E6B0098; Tue, 15 Sep 2026 09:46:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2996B0095
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:46:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3AC8E1403F7
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:46:52 +0000 (UTC)
X-FDA: 85216122264.26.B821733
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3BB24C0009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:46:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="A gV6t3h";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Y6V3Zpeq;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789480010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hLr8f1y6OpCVlFZxNEDzkoNAdcjT5mP0qSfI00lGolU=;
	b=8VdwndFMKuhJzcUXojJu4YsL/TR1MuGGb5rsHKGZQNoOuzGeiVrP9wH4I2RTBqbwtWlQlm
	iRM3ZzlKGezM86it5guthN2GBSTQISxdVStu6yLHr+p23IcZ7C7pdKEKSE7c4h46uYDRPX
	dL/rYTwGZrU+ZRcuSjtGM/yo7pJM/QY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789480010;
	b=TRSpki6NfsBmudiIEdUrosgOmKS6vmWuYB6/M8Lx0Ekztf7747Qk5slqJ4XeD9l7P1Apcy
	ZiQ95ZwqCCHB61oBfKMvk7GGYyj6HfvJGB1URgI/UtxroiTuT1xEPJYStW0IyjYJ5c3ELS
	M4h2UcdhNW12o+5wFy6zycyToXjCbQo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="A gV6t3h";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Y6V3Zpeq;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.stl.internal (Postfix) with ESMTP id B71531D00285;
	Tue, 15 Sep 2026 09:46:48 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Tue, 15 Sep 2026 09:46:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789480008; x=
	1789566408; bh=hLr8f1y6OpCVlFZxNEDzkoNAdcjT5mP0qSfI00lGolU=; b=A
	gV6t3hpNgBBM/0P7KIfeQzhPefkDLArILyqAZJqtGPohuNmIb3pqNuebuH8TG5gw
	0ThVd119vrssfi7xWCMcw05Ik7AgphgpuroqZUacbs3fCnDjfuMukSDBpvBWWxkd
	X7Tvdm2cONPF8fZFdqmeF+0uhyl3LxxWZB2Z9+/iezqsHv8fUy8XtI7RwIzS2TaN
	+T1vX/KOpVTuK4yVUP1hXxPyKyO5zMzUOCrXb/bEga4qoabLbW4xSqxv5HwBMyzH
	SVNEbO7dkcUQJteu4Rt+mrJTjag9xNaA73pQMUme1Jvcu9Mi0WxiADR/lBS+i6FW
	lkM18/u1lRFDoK0vamKDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789480008; x=1789566408; bh=hLr8f1y6OpCVlFZxNEDzkoNAdcjT5mP0qSf
	I00lGolU=; b=Y6V3ZpeqOBjgVPJH/XkT56SZbdl8JdJhFd4tJfQP9QtypVpFu1f
	H3813v8YcqcW5mUhHGguoEpEEkWvKsHV4fdzoZnCN3DEMC1AanEMkMVKVH0R03e+
	ReVK0RzLVbYatnBHR4tZTGbsfGuHBcGHLxmaM5gJPKA1gsmGs3gEwZwoFSEM7i71
	qmoiK+X8FsVYFxO7erFyU+/qtfeRKC/8Ujxtd/lmxgLPZG44D0IvjJRPSPqA+P1O
	zflPywY6+dUnU39iQ3635eVrrTuS6IuzH/6LTfyMjQItKvzhDeYI4PQn719xGpKJ
	bO9QE/qxZdl43lm1qUNtsZhU2+ihABXXdAA==
X-ME-Sender: <xms:R0ypau26tS0Z2ysNwy4NdcHNNF_oHWQ8sVS1MxPRn-lOT1epS8NJnw>
    <xme:R0ypaus_beJEOXTtUizhzPtohyw-FW-B-YZj-rxMI7RFyvoUELYws1XSWw4GIlFjB
    -JvHPUmbHXz_FywyUUPb8GGqybKSa6msC_FkxuafGXtFWU_wYY6Cvs>
X-ME-Received: <xmr:R0ypauTqzRU1qGNcZxhVWQbXyqzFbzO0plGh6sIIewVwvV-dWrkXEnPi8dY>
X-ME-Proxy-Cause: dmFkZTFbupHd3aPtCR4lfORY2OjlErP/qJYOfeuGegnVlxf0rTctNWhzELPFqv8qBN+p6r
    yyxTtWqHsC5sajM90RNnkSnExQFUiaZMFrvJQ847xQMm2JaIAvfn+54liTzjnHWYB3Fti5
    2aExYz/+zZi9zAPebVEG+nJ8INTDyYH+sLrYp/PBrRCwHqBu23kvk8KzpFTHNk5A/OqUk4
    prALBRulTyMaMnmpbfdaFoy7b41NCz79wnifsWIV9PRtY0z08Ly08SlZn1DmhZPII+jTas
    yhx+3SGKyJUHBRCV0If7frXa3bXFCsIDo1/Q1j+VsPu2PCNTGdmvBGBf8z9TdvPj8098px
    bgtwR0dRddnYAZZqsQ7Frq9NOue3hGoMPtP7y091EnqlMwB8wyNcCz1RbFYPeJj2B/SZol
    7Kf6hYqL0e9DpzjuPnaL3orOrbCY8+wcwf7GS4X3y/uRB0IORYQmBHvRrvWPjwFNPEXSvy
    8kAi/BdqohVycyThOG6AH9BYZGUoOqPbIyGrgUKh1WTSENfMoqsrP+S5C3Hez6LcSoqHbN
    sRN/47HLj+KTnB3r7akUX0iIeLmgjVo8O6B8ZZmQE3Tr1NLT/mTOj/cTFYZQWYt1sTwfF6
    nuoyqS2bxpYeC+h/Hm1YL9xsPGJ5ypDcONgocgb+Y+FhJ5QfH1Ytadyibt6g
X-ME-Proxy: <xmx:R0ypaoCnDV77kuVSf-GB3L815LrAKvYBeYyg6ul1gLYDBFSQqKWizA>
    <xmx:R0ypaowJNcS9gO8_zJPrxwCXpjsG-xQRYmj5T8BwKJLBb7UXHS_4-A>
    <xmx:R0ypaotZyEmAMv6TFmaYSAZEWvZHrxn8Gc-_yuUQbZCd1q3JU_EJMg>
    <xmx:R0ypahlNw4uqQNOviO7AQmnzgoEHaA5DbJt5COy8k96RnESsZawi1A>
    <xmx:SEyparZPtsrzqIUBofL2iNWKiDvgJIBndHuVqQeik1G1DpRa6ARUCQPK>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Sep 2026 09:46:47 -0400 (EDT)
Date: Tue, 15 Sep 2026 14:46:46 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	"Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 08/12] mm/collapse: separate scanning a PTE table from
 collapsing it
Message-ID: <aqlL5s0iTz9HWwCk@thinkstation>
References: <20260910120238.2529819-1-kirill@shutemov.name>
 <20260910120238.2529819-9-kirill@shutemov.name>
 <1e91c48c-cfdf-4a40-bf1c-88d8e0295c5a@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e91c48c-cfdf-4a40-bf1c-88d8e0295c5a@linux.alibaba.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3BB24C0009
X-Stat-Signature: mdkykdz3qc9w68sahwcwfxx5965cfntc
X-Rspam-User: 
X-HE-Tag: 1789480010-965891
X-HE-Meta: U2FsdGVkX198WnMKW8Muop3FF0YSZgvzwtHvTt5aY3w68HpSsUhGGFT7ZyB2EzE+k8PkSnmAnFrDM4fqXcO+RXsjhtxob2gRIlpKU6fFczKbcfnNixmHqKDy1zdC2oEL25siuMathwyhPOnn7wauV4u5x1slUkVheaw4KAfvmhVs10Jzi5psLkGEKSxBvqoziIS7fNLFXhdFhMmx6krN3S3pA9TMfZtVG6Lt3rTniQf/Y/sbqQjcOWKPgyUxTfXsOAfkTSsSreGrJlLtNnYCcCAJSawLEMML27jRVPMcWjQdPIuHEXIOmenSmCIm4ssasRGT0LrmaxywGhgtIs3Ip3V3HyMdk7t6L961XkfhVhcZEbagbtFRaYJioTsi6EpYN+2cSCp8JJdyYDr5EkfbIU+jtrNmBA4t/DB+66THPTawgcCp1oyRyNxtQp1uLrhexuAzM0uPWtkMdfcbMxSfqmiB5AA9ONRFYP21Wcr7rGNJdnH6m0HavnzzCfKLKDJTuRPZITY9sbynPlgsvMJ68QsBxU1Y/xe6bjVmgcbVBqqt1F4RF2eGTzzx//Z7jUnpdQYh4IobXNxT66/tuew0W/dXvM0hS3rE6MUuy3l9GDBhLO+FR7DFrFlco2BCDR1LFHFWYJMF1xsS1wo4ek5EqgZb8M8MypaPxTmO2YfYp6BEvVkafyf+Si7ol+l/VxVdWW45jMEVr7+l0znqOCmfowSSSWJQVFbuaN8salKbc/Y3dkBgNkaCy+NiJ+ixE4sq77kCv45xd5nTs8EUESruxf00r2RHE3ZXLDcJ9y7ebOVd3nt6hp/NMLLXegoW2qg9KDYgUqsCpmyHHP4N6+f08Ix6pCSa3DbVD1ahg2LtpuwtDB3CbzHPx3tBDdFnnk/soqXvBcAGztdYJzwaYv9aGzRvQmlLkAOy8st5YXbh5GIszSBGYIEfTOdyl9NQU9s0lx5QL+Ej5PyvW+VBWoV
 SH2nhOs6
 4u3NNi8PPlo2BaWk3xGri8Ou4otESPuqPWlaOhGIS2qt+Jc+xYNi2zu9NhrcMxzQ251VvkNpFDDEx3jla2HH2HJ4O8RrqD8TW54J56wnzASGCQAsxJ68hW3DpS3RoQGDKCOPE7/LkC03WgSgYHhtqlDFL2ScjAfRCA+/XP4jQO9/xW95e+okGotlyE10Ltw3tV9+1lZ7mySS7vaacbxqq873DwUXhWvq+hxTtjgRGY58/MV5BbcyD6GowomPSN81959Ih7ClEUiHrIxS1uWnv8gT7NviAHsA1fzi15rL99Os0BmokljP5DM6r0qQNr6/i+6TDL46brUKTMz8m0YUAR5VOi1KfPF49btob7kuDhqNnC84GFX2ro95vR043IO2Fok3q314x3zFIyKOazyTABwbRlA6aJ+GTDB1wRs/2ctoSxatLbs+O0p2yv+GgMY0xfGUZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 07:09:06PM +0800, Baolin Wang wrote:
> > +	if (!file)
> > +		return mthp_collapse(mm, addr, cc->scan_referenced,
> > +				     cc->scan_unmapped, cc, cc->scan_orders);
> 
> You already record scan_referenced, scan_unmapped, and scan_orders in 'cc'.
> It looks like simply passing 'cc' as a parameter should be enough.

Fair enough. Will do in v3. The same applies to collapse_huge_page() one
level down.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

