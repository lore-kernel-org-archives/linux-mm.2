Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D181DC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 03:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF6B26B009D; Mon,  6 Jul 2026 23:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACD2D6B009E; Mon,  6 Jul 2026 23:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6756B009F; Mon,  6 Jul 2026 23:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7777A6B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 23:26:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC909C1938
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:26:50 +0000 (UTC)
X-FDA: 84960543780.20.4935203
Received: from va-2-114.ptr.blmpb.com (va-2-114.ptr.blmpb.com [209.127.231.114])
	by imf09.hostedemail.com (Postfix) with ESMTP id E6BD5140004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:26:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ICbc6Yzf;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783394809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SlatkrEAWoB+y6LZ393h4sLUiuJx4jpAjzGhZ6jaKUI=;
	b=qaKOUYXIi4k3rvnj2IrkpnHZjsr6kHDCrfq/xDM2AhDbJRvJ4rtFKnCriqbKrbm705gd61
	mHSN63prPgWN+EzZdxBJEr0rzTRO/EIQJ7b/yp9yLsWytUHeoDkN/gNOqgNwTWAxrUwaEu
	EmqY1CDZELoLLfF9927YoqwGu6GChw8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ICbc6Yzf;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783394809;
	b=kDXubTdpp51/OxCWu+unNUP+mMuLm8bPmuep1aY7kJ5avHuv/+vyTUyZtGot46fy2/Hn4k
	QzA8gD9EHZzG6EKwrSpG0FsRLpJGYL9eQGIq6xLO3TLYyNpOsg8mDv/jHRW9xtlGaG6P1E
	/tpInmeOnRO4l3OM/eJ96KhtYEdKr/o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783394803; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=SlatkrEAWoB+y6LZ393h4sLUiuJx4jpAjzGhZ6jaKUI=;
 b=ICbc6YzfZzXq36v7jd/D4NQthSnyK7c+sifrvuwWVOaHNe1Vb2UzuvUUvn1FjN0OnGWZJi
 yA0W9+RKMjh7CIvSLIjt+1UkQZhf8jDa5qbS98cfl1Cw1MI5N5qN/wKlXAOvQCiCU8w90H
 okYyMkXS1WF0435sxrIU090ExeNzKHaMr5r7uWC/SvKq0/Up+k5sgoSLRM2iHfFbo13Kz1
 r3ufno4vTEwtvwicVMQiHIOIoxx1Ppg5wbgY0HqA6YLrhZwKELOoIWhUpFdMsp3Mn9myg0
 4oi9v/y32UgzwAToqjRksPNYIJaONd+BZRarP0/hz0anCJkd4J6L8c7ABlo+KA==
Date: Tue,  7 Jul 2026 11:26:20 +0800
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <kees@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>, <x86@kernel.org>
Message-Id: <20260707032620.22595-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a4c71f1+813597+kvack.org+lizhe.67@bytedance.com>
To: <david@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH v5 3/8] mm: add a set_page_section_from_pfn() helper
X-Mailer: git-send-email 2.45.2
In-Reply-To: <efd55e0c-8caf-4633-b876-18e8e788493a@kernel.org>
References: <efd55e0c-8caf-4633-b876-18e8e788493a@kernel.org>
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E6BD5140004
X-Stat-Signature: whczsc3shpagzai75dnzyeneyjqcmbz3
X-HE-Tag: 1783394808-647883
X-HE-Meta: U2FsdGVkX18UzEq+s3k5DG/+v7fs/qX7OAzjYNxhIqrkyiDmPHRJ/QjBQcqMvad0jE5RQa51LM+olrvdRKtDhUa+yGekcYvnaMbQwzZNKB96AiXa+ztHBej3GrJsOFiPy7j2ol/oZArpIPWzGL7PN/oBDJ67+tcDtRW2nMuj0F1+W+a90PLsngE4H+OLnJIHtxRsf+4uRY0YobWOI47mfMQgU3eTJ6SQKN7AxOyVa91wjMAGjIllluKvhw/L7jsSITlzugOQYzvqlFFNhn/LUm0MtGabFORxyosuijYHuNpzSGgaCABESCT1oJawPRSL/4qsL/eYW24qBB5Sc+Ez83GgMjBP9IqkJchIr7+MwE3kgXDFqSrr9SXxvgCaop276e2QhaCnQfTx1HWEqeyOTNrYWW5NGgPkAiQI0TqbhnpDwo13j669E40Cij6DIxnieFlhTTPxvYZ+aSYNH8JulS9Qva8Ou9uSEqKwch405qtx1HxMnO7gcUnJQZl9ZQa2PrA9AzHugndJFy5jin1MTyO8TzDCrq/r4ISpZo2n7T5/lB+EQZ54w2y+ziqHG9lpIjFfIIAz9B2L070xM4uatGjBvemk9yEMNsJ17l6RatXsEA8t0U0mWMOL/Rme64X/Wn81Q2DvDr/GAeooXJigiqglONT0igK1iU4+PADjng3XCK8IuBbb1DBoN4TZtA2c6TFExYD3UNx1gEJM6n2rfi5qN+SQUBhTJqL9lbAK89eyuydM+GIQ+252KeJA4BRmc83xptQYp7g4v1vlBDBs1mHcKXUSxHOVFEeZPAb2fR9KZgf7WgI016QPZhzU5HbltvSLbX9BTEIUufbvB4rzV2I7VVUf3H5i+VDd4EO9/gFUEAsW9naUNHYMvvdtJWymtUCNC5TdW6ws04HxChrESaOYCGwyQEBrtMRfdpd+ywBvmpYUo+VSnugboV9g/3N31BScB1rRWgPhHr/sEaX
 bm4pts9f
 A27S7SOtdotIABEAHMfG3/27pZa1wKLcyqaR83Rojr8mrxBbrX1Qhmc7hogeU25C3PvrtsT0DBvcZzDF0dPElih6uez7LvOYni0nDUlQI95LYPGbrZW2KXqrmgNIUqkaJ1Z2ss0u+OFQa54pFiDT63g0B6Y1o++VwO0E0zcMvEXo9dU+MM8etc4OwKuqFdOulgVWdVvLBNZxbTmXq7fg6XvasBZBZ+YW1E3luKE+xczvcGG3QJ4TF3sxPWkwy7Zs/cptdrBUWIn40HL4+bwt4+OmfbT8nx67DNyFEmQ0d6UfICuXz2kmVo2WjL7letSxfY0thqPeq9bP6nvwD13ouLO42wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Jul 2026 15:48:16 +0200, david@kernel.org wrote:

> >>> +static inline void set_page_section_from_pfn(struct page *page,
> >>> +					     unsigned long pfn)
> >>> +{
> >>> +}
> >>
> >> Dito.
> >
> > The no-op set_page_section_from_pfn() helper is still needed for
> > !SECTION_IN_PAGE_FLAGS so callers can use a single helper without
> > open-coding #ifdef SECTION_IN_PAGE_FLAGS at each callsite.
> 
> Sorry, I meant two-tab indent :) Why we need that was clear to me.

Thanks for clarifying. I will fix the indentation in v6.

Thanks,
Zhe

