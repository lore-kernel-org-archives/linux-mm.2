Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C9DBC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 17:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390166B0092; Tue,  8 Sep 2026 13:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3676C6B0093; Tue,  8 Sep 2026 13:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3F16B0095; Tue,  8 Sep 2026 13:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0489E6B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:55:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 883E51C2479
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 17:55:17 +0000 (UTC)
X-FDA: 85191346674.20.AE9E763
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B6BC740002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 17:55:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hVzMVnSW;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788890115;
	b=Q9Rcnb6pzHjqjatrPM9RF3W9OkV+NnY/7fH8817U1Tf3dYdXwMXocESMXfUkbLbjCcYiUE
	8PxLsxqDsyVK4bUN/BWUbbdpw3u3k2UO6PjctO9nWV+wslgSBlFjwEKrsqOFQZA7m2KeSC
	OIrY3XJ2++Pe1o76N0vyFatixCsDJno=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hVzMVnSW;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788890115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBAuJhW7S3ZXQ2qvDNf9JatkhBim/pKGvLVV7RlONSg=;
	b=O61qutwI2Zf6Qcw/ZF1qpNhFbNGPzyXkcxucRfbz7hT7cZcz72z/NFNUeEmXjaCU+k9l7V
	eAK996T3qTVjgByuZI24OHij1233JPZohXVKm6faxyp5SipKm4atkb4rlLHHZ7LMKI2g7k
	TliSrAQfQpEIbns3okC5CvR6lmTfrrM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76F304034B;
	Tue,  8 Sep 2026 17:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703FE1F00A3A;
	Tue,  8 Sep 2026 17:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788890114;
	bh=gBAuJhW7S3ZXQ2qvDNf9JatkhBim/pKGvLVV7RlONSg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hVzMVnSWPNFrjH8TWsZOHxRl0Old2NxIqVPRlGr2uN94NqWa7kezMsS/g0wy4UcGS
	 UtnZwWRgJJenERfATUGgoXTtmS+YyDkVLwdKouJCYBrNjcAty6d+qSlcrdxRWgLtn9
	 ZHsMfwRfPDq+5GrIQa7o17bWgKDLvrbv6j4vVFcc=
Date: Tue, 8 Sep 2026 10:55:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, Zi Yan
 <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance
 Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Kiryl
 Shutsemau <kas@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel
 <riel@surriel.com>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo
 <harry@kernel.org>, Jann Horn <jannh@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Chengming Zhou
 <chengming.zhou@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/8] mm: remove page_swap_entry()
Message-Id: <20260908105512.8854d7972c82b6b6f417b0f8@linux-foundation.org>
In-Reply-To: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B6BC740002
X-Stat-Signature: ibjhn3p3zeyrffqke7h48eg4fs4wb7m3
X-HE-Tag: 1788890115-389418
X-HE-Meta: U2FsdGVkX19sU6JGksK7riVBFc1bE6z7ccpDu4E1Kblyec/LsiuR/hpRUDDqaXuVfpRnvv552BB7gwtna/8yz/7dYMc+ELqxfSafO1/vpB19VxtjShZNtGP8kygx3RAox6Y6+5nbYANF/tTguW22qRu0J0I+jWxEQQyaKz+pH0fXvIGKzEaa/briofJPivY1EqIaIgv9s65JkGLD5QYPK19i4SzogsMNbYxWYXtvLWhlUC2t3nf4TWAOBdcusyfRHPr/L6rFB2o1VPnuh3zJr/qZLfheAaoCidwLHdgLM03HzHak77yIwA6ITa3AMNnb8unJAu/qdquc5l+2QR4vDPrJetUsIbdyY0r8kllF41P7oDvLKOcUaJdj8UoEj0EKr45P5RATHB6SNWCTka8WSqPxINFpmwWB9fzjeVPlLJyoyZ/1hcg45jh6Hx6ccR4gLbkh9l928CPLc4QeW9E9l7W7bvJV+95zJSbNOrJxZvr6ovXki9VGL6xnA+YBYIUM7Ddhn7vMdRwmZ3XgFGqwx/B8cJHR3hFOijKlZRkbmDnudT3E7q8LVqk/x0N8env+RY86A4HU/Fmu0J/u+TeZq2xDvhPynjMaPtskXFojsspkbYGK09o1dwjQyxDMMTJKead+TztRdtWD5JEZ9YE8fITIcE+NtY9vuClzLcDqnUoNBr6fZMZhzoO5bk5IJQdXMk4rnWOpIBaFR1PPQozSNFEKJlJ5/hcSZjM/pCUBjYjtEHCU5nT5DdUFTifmGqBiliKhq1476ylNT2xatgB03eVvJf9xAZgqC9pjtuYGqj7o27X1jZbAm5dlWgWfg8c3b1+a4x/5v3Wp/vh+HDD8dtJxJUtipCiiJKp7ycw5o7Rme0rMAJyhxaUC2dkYoGJ+8g6GEbAnUxJBAaLes/aN0QSxDTQNJTG609SH8UhAmbFsLMDec8MEiETBGnftUQ2TB9Mv8xSS2hrOmF3Q4up
 I+hKJI1M
 ecR0KVWqnWdOOkwjjIRgzH8rpSoaFDyINC+pwnscYaZfuzmnU2xs1HvFhW8/VdpLItaBKgrFEXU4yLcrb9VuVczfWze2z86qAluCjM90ZsoF3LT23Yj0mWmNj2HomVRSrhnKJmTh1LVNTjKMb+ugShCgINws6t9Bd68TspIl/EiGCUm2sZ62JYUKMf76xpRWCwmHANWykzQs6i/XoKZQPT0Zj0vb2q6AA7U8BzWtbJbz+pJqU6DMUPcrefOoTvgNOao26X6ech4dn7qZ98aRyinWlgUu+yYrIHtiVlc2dY5p7sel9wVCppiySlpY28Lnwv+/mUAKXN97nP0ethfJhaoKJfSrO3T6Ty/eD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 08 Sep 2026 11:16:30 -0400 Tal Zussman <tz2294@columbia.edu> wrote:

> A folio in the swap cache occupies folio_nr_pages() contiguous swap
> entries starting at folio->swap, so a page's swap entry is just
> folio->swap plus the page's index in the folio. The swap entry is
> folio state, but the only helper for it is page-based:
> page_swap_entry() takes a page and recomputes the folio its callers
> already hold. Several callers avoid it by open-coding the arithmetic
> on folio->swap instead.
> 
> Add folio_swap_entry() and folio_page_swap_entry(), convert all users,
> and remove page_swap_entry(), with a few other cleanups along the way.

Thanks, I'll queue this for testing and further review.

