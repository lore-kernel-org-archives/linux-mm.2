Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D34C606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BHmRvToR
Received: by kanga.kvack.org (Postfix)
	id 110876B05B4; Wed, 28 Oct 2026 06:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8986B05BB; Wed, 28 Oct 2026 06:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 025786B05BF; Wed, 28 Oct 2026 06:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D33D06B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:10:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F36F1C44CC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:10:51 +0000 (UTC)
X-FDA: 85371616302.22.8E06AB4
Received: from mta1.migadu.com (out-38.mta1.migadu.com [95.215.58.38])
	by imf26.hostedemail.com (Postfix) with ESMTP id C05D7140006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:10:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BHmRvToR;
	spf=pass (imf26.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.38 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793182249;
	b=eFeGlTYn2JZKAkwvd9+btcdg6t3FaPoq4JP0op5KcIwtlBhOEG9w7LLAiANb6gaJ41u+h9
	ZIVje1PMPKUI0P5iCLy73Bhk9Ocd2gMjney2ktHmJyW7qEOaT0X7CgHLR8xD/SedoVwsbA
	rnfftOAOQ8zF4Kkk24LucqB5J0gu5EI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BHmRvToR;
	spf=pass (imf26.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.38 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793182249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=19TPKFjxLxxJXmQTxvpO9mlfiQegSPOYzBZe/idkCsk=;
	b=fxBEi7Z7U9FM6XSPkRyninPSHYx4kJhj3g61k2eKknFJynY1fz8tmqZXSzzCAQsOB7ZnQh
	AbcpuD3u9sJoMgzUDPHMfhMEJ1Cy0Z7qg94V4mYx+KXfteV64MV02UAO+GSqRQHA34jB7U
	IuSG/rYSICtzrjD5q0dwaUdHaHKhyHY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JldTN/ya2t8xpYirdSsWzyVdXdbqZ8hQSNVyw7aaEbs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793182246; v=1; x=1793787046;
 b=BHmRvToRiraYLLfIjEp+euCvNL6V6Bc0ohukmhoFXIjfLezWLNKk4EeGgsHC0PLRAE0FXBpX
 O1zJVcngOxzevw49JVL9VDXhe+mg+4F/hem39W9YyV/UThU4cHH7dj0bNAmQKJ6xHaRwrPdeQpG
 L5v4C/M6GuKvdcDMrWZHl8+w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3eac00e914e20d2a;
	Wed, 28 Oct 2026 10:10:19 +0000
X-Mizu-Trace-ID: 3eac00e914e20d2a
X-Migadu-Flow: FLOW_OUT
Message-ID: <76f1df75-09cb-45ad-bb08-e34acf93518e@linux.dev>
Date: Wed, 28 Oct 2026 18:10:03 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/19] selftests/mm: skip collapse_compound_extreme()
 where the PMD is too large
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Muhammad Usama Anjum <usama.anjum@arm.com>, Usama Arif
 <usama.arif@linux.dev>, "Nico Pache (Red Hat)" <nico.pache@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>,
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Michal Hocko <mhocko@suse.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, kernel-team@meta.com
References: <20260919002451.496763-1-kirill@shutemov.name>
 <20260919002451.496763-3-kirill@shutemov.name>
 <5862cddb-a78f-419f-a5a1-15e16a422bf5@linux.dev>
 <atiQmWnz8zx2AKI7@thinkstation>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <atiQmWnz8zx2AKI7@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: m95m6boyzhxp79fr3cjuyie5b5qabsxu
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C05D7140006
X-Rspam-User: 
X-HE-Tag: 1793182248-263220
X-HE-Meta: U2FsdGVkX18aLcy1eMi5Er92l0u3TGkMu6wMS0DBXLtK5DB3qBftmX0pnaTjq16wvEtxC0xNS78sCD962Ui2/3+L43N6MZT9Qp4Iq9/ww9CGN995vUl+raYy8Yb6TxlwILis8XdkCel4WPxOYnGw3PhooGcouykSZhGUM/B0sGJ6NAm+fky9KIiiJOTryknObtzFIL0qwcIL0iep9tF8inYDTZJWJ+wSXXgGioFJLasGtFQ1aVEB/v/1RJJuXUETA0tQyPsJ5QPjyIOZIQDuZD0QL5ipuZkC7u1XN3q/tE2c9MP02Qg7H3YKwzw9GoZ9hMQ6vtp51OYQBfyxOfnXmXtC7JV4FhWgLfMteu4radHlwX0K9AOMUEKWUckNMoHB8nseDPJnOMAdtGtOuIL03u2Q8ID9rc3bbIQpUSgOwGGA6vYobiHI/YOOaCEwzbv7Gs9cPaDwb5QXfG2ambfBr9CZb38yEcAkTjYGtiMHTM/q7Jf0GsC/6tZFVy505UaVoykTwjMdyaBzCdehpuiiNkqWBqJ9kciffT6kFNFzxk41AwD+HukGPWYPp1Et6U7IhOs+M5ozfQ417VvqAI5akK7YhgKxX8ZYYzoOJ6VeD10314PI35nFJfuwT9pmxXegvCEXSvFO7KhOQYnKRGEY5GogRUrNaVV7SpPXYw9Pbko/75129heu12GgVbrSvDYPO4QSZ02FA7DuwsuHRDWoYgNEvdw6lJ3eOsXsvHJdk2639KqbYHcvfkEt/95SGqLS3T4TBUsXk3KLM7DqIpnA35sSSMqdbBU2SyvQ1OTVsyqIVTBPIUI1nC3Bs86EjxPi5FZLgFY4txuU7EAZdpkW6+bE1BhpxNZDMjnnTeJXws/Y45Ivp4EHrSqD9LyGm8C8SLBX1HUVK69qvf8+d5FZHDTk9vNuyOy39yO9lgwhza2v8JEcbIYxeXnrDGfLfw70FVVJHPWS0hHM9yeRaJR
 VUdlltmM
 4HnexJH0Hzj25K+QrDZKuEiApCm3xNwwbKkPaKWRBnxvEJ6ciR7hJL0918tmE7SrSbfzZt2Vb8CLKhYJ50kW7FikwSMuamtvawCoFkwCFbvDuf2ccrWbSvV2COqS2oQ8ReCPhgmmBg/bWyDFUOwKDhhd2jFGM62IFJQMMPcCHG5zYnrRn8MzYCGhGXqTpQmoItxYFE9MMudLcK6DOMQ4Kl8StoelIStcOSgMcZFbEMMRgA0ATsiObtzj8Ew8VfATcmeGNXXnSKH6oy1hNe/5Zerdvxpbr2+y4Z09MrUe3LfoLKIytWA3kUyYhzRjE/Uy1ozKGfoTE4FqplvS/IjWPPD1ckA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Kiryl,

On 10/21/26 6:32 PM, Kiryl Shutsemau wrote:
> On Thu, Oct 08, 2026 at 07:52:18PM +0800, Zenghui Yu wrote:
> > Hi Kiryl,
> >
> > On 9/19/26 8:24 AM, Kiryl Shutsemau wrote:
> > > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > >
> > > collapse_compound_extreme() builds a PTE table full of distinct PTE-mapped
> > > compound pages by cycling hpage_pmd_nr fault-time THPs through mremap.  It
> > > therefore needs hpage_pmd_nr PMD-order allocations in a row.  That is fine
> > > at a 2M PMD (4K base pages) or a 32M one (16K).  A 512M PMD -- arm64 with
> > > 64K base pages -- makes each of those an order-13 allocation, which the
> > > allocator cannot reliably hand out even once, let alone 8192 times.
> > >
> > > The failure is not a quiet one: the case calls ksft_exit_fail_msg(), so the
> > > whole binary stops and every case after it is lost.
> > >
> > > Skip the case where the PMD is larger than 32M.  The MADV_COLLAPSE cases
> > > still cover PMD-order collapse on those configurations, and 4K and 16K
> > > PMDs are unaffected.
> >
> > collapse_compound_extreme() failed on an arm64 virtual machines with 16k
> > pages.  The VM has 8GB of memory.  Not sure if this is the same issue that
> > this patch attempts to address.
> 
> It is the same issue.
> 
> Memory usage for the test case, assuming 64-bit page table entries:
> 
>          4K pages:  512 x   2M =  1G
>         16K pages: 2048 x  32M = 64G
>         64K pages: 8192 x 512M =  4T
> 
> 64G is a lot, but I don't think we want to give up on this test case
> on 16k machines completely.

Agreed. This test case passed on other arm64 servers with sufficient
memory.

> Maybe we should treat a failure to allocate a huge page here as a skip,
> not a fail? And remove the PMD-size gating.
> 
> Zenghui, do you want to experiment with this?

I've just sent a patch for that. Thanks for your suggestion.

https://lore.kernel.org/20261028100119.11340-1-zenghui.yu@linux.dev

Thanks,
Zenghui

