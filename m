Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CF8AEA854C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 03:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FADC6B0088; Sun,  8 Mar 2026 23:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A87D6B0089; Sun,  8 Mar 2026 23:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DF636B008A; Sun,  8 Mar 2026 23:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F6436B0088
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 23:26:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BE100BA6FB
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 03:26:57 +0000 (UTC)
X-FDA: 84525088074.14.0A0948D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9D970C0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 03:26:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773026816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=10aowuS9PCUSrI1PqWmJffjcW8VnzKQxSShHlzQUGAA=;
	b=emXtJBtnmUYWrs1tEM+5EoCE/frE365TGcPbW5M/8BkPIqRk9JeuSmuoDVPT5qJURkmZ32
	jcM0vUpDFaPdpmoMx3EvcnaJYiTGqfqA3vbQToeM+9KQ1quSuS1pofdlrC4a0cjWTMBbQ5
	a9orzEedJ2jyIvpiEDv0oFNEELwvBig=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773026816; a=rsa-sha256;
	cv=none;
	b=sB143E/Se9vZFEluEDi01yRNY4lI00Bvde8SMg1eazmLT7BbOZ1o34tUbWaVw6j6JsZbLz
	xvsRP4JtFprVfOrjvIvGSBP8ALEPgleDIViZMa1391ERpEIJ3mrOsvT5v3XtGnaIi5S6d5
	2WKf5XKNjBB557JGmUjD3eWb1IMOIfc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6AC781D13;
	Sun,  8 Mar 2026 20:26:48 -0700 (PDT)
Received: from [10.164.18.47] (unknown [10.164.18.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F32E3F5CA;
	Sun,  8 Mar 2026 20:26:51 -0700 (PDT)
Message-ID: <54c48bb7-5991-4706-b562-4b52f88f2886@arm.com>
Date: Mon, 9 Mar 2026 08:56:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] perf/events: Replace READ_ONCE() with standard pgtable
 accessors
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260227062744.2215491-1-anshuman.khandual@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260227062744.2215491-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9D970C0005
X-Stat-Signature: dw6to7apsf3wzu5k6w5czp59c7smo8mr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773026815-553222
X-HE-Meta: U2FsdGVkX19WnyzYdlO8YGgAZs1TNSxe73B8BfUXhpwHltaStEYXC9NYE61xMGlBgQ/RjWIynvZfiZRZHnajEtA/uKVOrOKxyphVQrH3JsspLVezdlsJrfl8uPOVPH2daFWiWAvEa2y4Efl+3FLuxTQQB9tO901TcsLwqQrfMp2cQxBcwmf7JRFVp0FNMw3ZmHu1ZA9NbaSZiPNHHvZoPiNl++lT0sEQJG2x+RQl6A8o1/a0BmgF7hdpzS/ZLnhvK+8lKcLItvM3Fq0KcLxm/dFi2dFqBEGNyuIzcknpURelrcYCQk4VosuCTvPH01qes5Yjb19ewDUOtRHh26X/3EZz/AYRZr/z5ZnEOvCk4HxcAHEI/ZJ4UhjfpnDbeSTKjWKgalb94QRQH6Dz6rWgggrI20Ljy2G+gTO/GlsjlDgg+5uU3DNlUVKzn6RUNLAvi/8kRlFZInm6WCZHKpQrTljF2nM1NxHH5wf/7uvUSv3U3ZMzXc69gnwYYbibTfO5PugugQX7Iud/HPrfqXJ9khi4tL+09lVtR0RK8Syvs3uL7YcKW6lWf2V787gO17uvFDFdcJcWQ4cHhVFtDuq3X6JcG8hB6zMmBawCUGuy1x9A7Yhc0AsTdxU0Gyoamvhslhju4zy3wM4QA16+wij0jsg5wkfh4EMCvVJX5ZY4YSMToHfC6A2CxSlF10FWU1nTongnui4eZiIOOPeYvBzOZFm2GYn50fuHrb/+HQGGbXBjOilGkqYfqOZiD7+jKlElLQpWpAcwh9xTzLOvOOx28Dav4nViKjPzHMXIFW/pzBefUtfNNS09MCXmXSfzBkG85WOjm+WM5dkmx2ZXL6WN7t0NlKvldRQMZ+u1W8CPc8iApktW+lFPBWxNCBKMRDBBXFyIFTo+R1DfHEAsfA2AshVzr3XaNUjIiZiJchYUtXCScbxAvkFMledR6GGnzS3cUbg11SXqXsMsUnn4usP
 q1nxkGbg
 1jCam5Vd0miXpyNoedkbNZNqPScvcAylVC4P469n8D5x777Y5+VVpD6qDSHtt8WnsB0z3noC5mjoYL1pJAa+uBF/p1fH2xVV2mv/jiMFnhaoxrIaXRlmYjTtCjQ6o4DOT+fzMFkz6dlFxuX/0YNi78JUgESskPELAxzWVfEXDWlOzw9EgWtFldQ8QRzKJQK+4Nw8SlOavYTO9aneOgXcIc5Tpc+OPrxgay/O6OR3JzeB4VPki+OdRsVS0weoFLS6eFHPUknNMiFIP59FFYkTtu4yn2Fc78s8YDHez9SDnFyPOfRG3TKsfJsaBxNL9IXCMhqtrthCAhfJMA6pWhYN1hI5SyignrWlnCuhikBQ3OPQKxRHT5qY1UAs1YNNM88yvEm6E0fJn9bU5TDvXJgh8ucv4osFqjYpswwATBV0EM1fbtdSXjSSaq0sKW0w5ZfGqWm6jhYUqENnjKzQbEvA++RpnukSzoYZSdI3q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/02/26 11:57 AM, Anshuman Khandual wrote:
> Replace raw READ_ONCE() dereferences of pgtable entries with corresponding
> standard page table accessors pxdp_get() in perf_get_pgtable_size(). These
> accessors default to READ_ONCE() on platforms that don't override them. So
> there is no functional change on such platforms.
> 
> However arm64 platform is being extended to support 128 bit page tables via
> a new architecture feature i.e FEAT_D128 in which case READ_ONCE() will not
> provide required single copy atomic access for 128 bit page table entries.
> Although pxdp_get() accessors can later be overridden on arm64 platform to
> extend required single copy atomicity support on 128 bit entries.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: linux-perf-users@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> This patch applies both on v7.0-rc1 and mm-unstable.
> 
> Part of the D128 series but independent. Hence could be considered on its own.
> 
> https://lore.kernel.org/all/20260224051153.3150613-5-anshuman.khandual@arm.com/
> 
> Collected Peter's tag from an off list conversation.
> 
>  kernel/events/core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index ac70d68217b6..4ee151cd2c6d 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -8422,7 +8422,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
>  	pte_t *ptep, pte;
>  
>  	pgdp = pgd_offset(mm, addr);
> -	pgd = READ_ONCE(*pgdp);
> +	pgd = pgdp_get(pgdp);
>  	if (pgd_none(pgd))
>  		return 0;
>  
> @@ -8430,7 +8430,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
>  		return pgd_leaf_size(pgd);
>  
>  	p4dp = p4d_offset_lockless(pgdp, pgd, addr);
> -	p4d = READ_ONCE(*p4dp);
> +	p4d = p4dp_get(p4dp);
>  	if (!p4d_present(p4d))
>  		return 0;
>  
> @@ -8438,7 +8438,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
>  		return p4d_leaf_size(p4d);
>  
>  	pudp = pud_offset_lockless(p4dp, p4d, addr);
> -	pud = READ_ONCE(*pudp);
> +	pud = pudp_get(pudp);
>  	if (!pud_present(pud))
>  		return 0;
> 

Don't see this patch in next-20260306. Is not this being picked for testing ?

