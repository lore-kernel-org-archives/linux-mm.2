Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C7D6CAC5A7
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 08:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45B408E0005; Wed, 24 Sep 2025 04:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 408208E0001; Wed, 24 Sep 2025 04:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5C98E0005; Wed, 24 Sep 2025 04:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 052A48E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:17:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6DEDC0472
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:17:14 +0000 (UTC)
X-FDA: 83923438788.14.CBE6F4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 152BC160004
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:17:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UaZBnTzB;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758701833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gXNOPhLdKfYtiwpS8D518O8VnvPG9pMlFRHlCj+WU4c=;
	b=bQ3KgL1/yHaHr40ltkqZ5+gwXVs326n3T5RvYadC+Wtl0NHbS5Ax6z4gvVQtChpg1FtpeV
	v1DAEL+ZAtvpEbfQJi6neCuFeeE8EIZT2+dl003uLvbJOhUSFozr72Pj+78/nyfDUubEWy
	eONTdibaQghnK8bsO85ehOZVumP7hTE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758701833; a=rsa-sha256;
	cv=none;
	b=jNy3r4EXCZ5ZdE5iPB9/oL+B7xJE/v2fdRgLJWnQRrTfLzZop8ep5ZeytuNGWmTcgTuq/u
	AqLw19wRYFJr9VcwFvZRQhlDgPxe/c9mzjqJPXJG31P/8O2DLPMHDdGMjjmuQunwf2QfW3
	Di2pwNRjJShnbrkLZrn7Tb4ZwAxuRr0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UaZBnTzB;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 37E1560007;
	Wed, 24 Sep 2025 08:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57D5C4CEE7;
	Wed, 24 Sep 2025 08:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758701831;
	bh=80TBCq2xtbZyQwcjgk75oUDRl3DELO/Ho2DPzv73C98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UaZBnTzBosxoU0mr/La3OpGYNa7BmjoxfFelqB9/C7od+Q7f1WnTp9pU+r0kV+A+A
	 WmFNXsaJD+IiNidYvB0jCdtBVqlmDdgLsRyS1/R41XUGtR5ZGtg7Lk/Gv1lgQVZuYK
	 tTl4ax5VkEu2QqTrUjBdxQdiUbAUa2ONQXffNQsn/poQjL/+JEoQUiSg3MoPX4LKMI
	 Bsf1F3tBuKNRtWvGbjCfZDHcp7G1jfp+y3s9s8nHb46uYDswwzFb6u2Y60DPcUjnGF
	 GEgXkjndciK1Zgni08SrT8MZG+MWtgZUPCFPE3RFfmOOh5o/+Yc9pebjZWWveC8LKn
	 +LbxcbUXjiohw==
From: SeongJae Park <sj@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v1] mm: convert folio_page() back to a macro
Date: Wed, 24 Sep 2025 01:17:09 -0700
Message-Id: <20250924081709.63722-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250923140058.2020023-1-david@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 152BC160004
X-Stat-Signature: eg9wuqiw9agzbnyyki5epyp7s4ogiooz
X-Rspam-User: 
X-HE-Tag: 1758701832-796230
X-HE-Meta: U2FsdGVkX1+VmmEIRisvib4kREPGfKW+C7JVHPdSS3QxCeA2oBj7Satf+ZSqJpzfHxon3lCG0IZrAU1EvTtZLky+6N8bBZE0gsZcgIY85e+GoqWNvu4biqBtqKoZAFLVnbVibLJAIg47sPkA53GniSKtyHs7tJ5jJ5sUHiaxDpaIg6b7vDcnZny8JWggVGwuTDZUMlwf0lcL9VdNu/uba/6cILUV6AFfON5I+vvyUnnB+wjCB/l9wLFm8UQ1uVT5oLYiLgSLY6B8+yW+PFyU/58mYf+V5FFmjEje+wT3vy7/uNWmPX5+hioeQZZjf5mXWW+ZLbc9FRmrjwTlC02A656vjifLJyh9eMnT+bgkdKYEcSS/oiFWBdKF6pFAOrbDL1ghTVPzMKwj3WcuiVjVPQuQKVZMQupEU5g29ashiy1owFLlPU5qgI6kqZD+8dLf83kTAWwjir3WT/9gi3xFeNdOTMg/avxQvRU93JfawyBjYOFjIFyR99/wN1FFzPMWANTqovI4WB8XroKg1huqIDZf0+oetfdfS8pGWaYGd7xXi5WkMtLtNhfde4uhXsR8sIwZJ5kHfWyxGlxTy89fhfIe/SsJsxENKORxQ94+7KblXBynKgOz6Q2NLP7zVPKf2zQ6isQTWpi+cvMj2fbgUJPfNvbo1Tsv3UDQMudcviMLhu4wWLXUWTx6/2uCkK64zikc2qWjwTtfJEXFxi2RcpTUH+kcw2qzle8XJsBHLHuodtDzi91y4iWq+T6t4huGfHV/Qhdg5y5qUaIIhVzlwsuJ9T2pOfRSeSndDpRtQDgcQNdcgsWgi1y4GssxJLMn5BvmltqNW2b7cQ7VsmB7+JqAqWOfA3qImwCykrDJCNjAAvTh4oNzFGMXtWjbTqal6MxWRqgAbbkLv9luUwT2R+YYoIL99Teh8uopF8dCNT55WVGX8+pwPWqwi2JMWsQg4ggCDp1xGC3EsgZBp96
 eU955j0A
 7Ymz1DITS/xbH5RccbbyT5hfhG/1u/x3ipnAeTe02bjGD3Wb8jFn+Uza5xeNKyaNtnIlSdDCUDxWZRsAgFMNCrrsmFlVaN5UrgDM6xZuI3BShjt7wWxym2CXOHS+7lReMn5+0i/aH5SEWidwnWWPQptBXEjZDPoGLXEoAu9qX76CGkaVSODLcXOnMnJ4oTWvij64KRnMDJRvo2kNaHBj9h/J3qVDQZLy0xcNB+4sQngCPbXlxNgH2ZbOLSc1uQIQaSajMehtwI3Axd7lSmKGklTnulTd+N5YgIttNBwSiVVi7W0CZO+xs+9vohz9KNiVF7S44BGioNHjlSSL3pn+cvrS+J1o0ddcvqUiHD7oRGUywBDUKO9Eu67zm2BoMfV26uOjc3O+qBq5p6YRJ0EjoxBk4+gC5JaBriSQgH5X2jyy1RoNt/L9fgcx28Dck07JrVX4N2ebuEyi/A3+WJF9CFpoPfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Sep 2025 16:00:58 +0200 David Hildenbrand <david@redhat.com> wrote:

> In commit 73b3294b1152 ("mm: simplify folio_page() and folio_page_idx()")
> we converted folio_page() into a static inline function. However
> briefly afterwards in commit a847b17009ec ("mm: constify highmem related
> functions for improved const-correctness") we had to add some nasty
> const-away casting to make the compiler happy when checking const
> correctness.
> 
> So let's just convert it back to a simple macro so the compiler can
> check const correctness properly. There is the alternative of
> using a _Generic() similar to page_folio(), but there is not a lot of
> benefit compared to just using a simple macro.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

