Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 170A4C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:05:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116AD6B009E; Mon,  7 Sep 2026 11:05:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE886B009F; Mon,  7 Sep 2026 11:05:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1FBC6B00A0; Mon,  7 Sep 2026 11:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BDD306B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:05:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4F8D41201B0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:05:42 +0000 (UTC)
X-FDA: 85187290524.28.C4A2122
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8169A140013
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:05:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Yx/3ACoS";
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788793540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JlSeDMN2jmSTABqqEIctjOg+tQu+DQfCbO0qC9OI+Tw=;
	b=rFTbzlUo609LogVaNWdF4ozKPKmdpePOG8RXVQGRtTBkOz1aRqEc95Oa7falv78GQoS00A
	r78hFPMmFZp7FkIMhSLleAC2mcxBhD+ucrM8Jd4T54CKc6gxZP5/a6C5J4J8ZiZndpQ5TS
	vBoZwnc8S/IK31Kw5lufa2PWAW0MzPs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788793540;
	b=4QKMDuoBzguu6FnIYh7w/F7dnfPaWFlrNVfKXkp6L2aI9L9mPkUeVwV6RGC4YiCPjbiX5r
	mk9O35BgKDrHujVXJEWo62qkYPVBPkVNBxZw2po9fwT9pVM/aqupnh/Jhi4xvmZveDu1ee
	hS3vlU3v4G5CsSIMfJLx3UVKF1PHwTM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Yx/3ACoS";
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2228C60D86;
	Mon,  7 Sep 2026 15:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE80F1F00A3A;
	Mon,  7 Sep 2026 15:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788793539;
	bh=JlSeDMN2jmSTABqqEIctjOg+tQu+DQfCbO0qC9OI+Tw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Yx/3ACoS+eSknzC9zJq2nxRFIY73ygaAgoS2pkih9AvQKgcI5qSHKoCcA15d51nsw
	 IYHRc7k9Gj1ZIduSJW61jrMGsjTmRHCuATPs5gCuRhuhutFxcbixBC5QBv47+//Ymp
	 rWiJqaDUYM8e3SBslqMajZUj9bqGjL6T2ZuGhUnh/TO8KK48Bw21RKALvfl1WyDT3K
	 6CxvVOUX3A5xBWCTSpOqA0NkhzUeaDsdGfOp7jKRYOmdWnqEYpJIPhhu0WC+bu8Ka4
	 eS+HwhBl8rZy1CjhBnp8GhmVOOMYh6xSYTTPL//ptFMtJbCk/IlYr2cUOQYIe8HHE1
	 nvOTaetlbp2RA==
Message-ID: <d366dd1b-b14e-4a42-9737-8c0555f714d0@kernel.org>
Date: Mon, 7 Sep 2026 17:05:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on
 MADV_WILLNEED
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand
 <david@kernel.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Mike Kaplinskiy <mike@recall.ai>,
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
References: <20260904-madv-will-need-map-private-v1-1-6b83cc99fcff@kernel.org>
 <apriM1q4GzAgP7JQ@pedro-suse.tail5790ac.ts.net> <aprjOxDy3JCPb2oa@gremlin>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <aprjOxDy3JCPb2oa@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zkzqz5qtpnkc5a111jrczxp8qe4xf583
X-Rspamd-Queue-Id: 8169A140013
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788793540-262587
X-HE-Meta: U2FsdGVkX1/5RetIsugZWfhCfcG2a7vrQswdgDOBPMXVFucFUwB1YH/pW0gWA5mcwy0XdyqjgxcKlnQtg9jpdFBvpsMB3vWfuQk7clpy0xnr7vzw+p53GBuw0AO41nkuYJHQjdHq5CYQAq90/Dnrz5vJgsN9G1XeJiwaJWyOC5FiQbIZxYfP52/xYKZ/OlxZOL9CstWu64g80LZppr1IK5NqLbzjltsDPTTU9320colBDyo2QAFIz4+OdW9RRhKooq2z7cg1U4bpwgpQMAbkgpec7dzHqDLP1iEXa+pCb6CKXsQPVFsRMaLeY7EafyuM7DY8MBIQjobASethLUZfydLWtyUFHj0NbCtruSkOwhDzmEjhGNxe9/N/GpE5YYPCnlCSCYJD1exQr1x7BCYTYp0ecWfcJdLgVoE28N5KUz1BwEm2brgHQrXaYa7gl3hMX40xfwoGNbw199hRErz+6nd7beA5jXEa1sXhzUjLjHfqV/jjA8xBlgBayicEna6McloJ5evUcNGBOFoZ6Hh+zJha86wWrGdhNe4WNTzGT2uWLnRqKVC3Qo4pC+C6Wl3+5yHEnF5ZxddiDJE0n74O6cg/Rc+rCj75Ph69R80W5Z+00cRg5kCMQ8MPmyNyNvWOe05iB34UgUr3tM/iYLdJbU5wnjyRGkXFrt1MoOurLGHZW4/nYNpvJg2IR7YSIugEZ90sFjlTay4MuEWtFkIQ3P3z3fksrB0VP1eSkZ6TrJVURLzBxsOtT9PQ8HrMGsCCWmo7y2oc31LctoNVrHTVu1YMo8njUBtOx4XEjfCy3F7RdrIyFBzK1wmIlcMHWWZskymRZkVT74++l3QLEr+kEO7TUQWY6NKsKr8E0zxzrh6qRWgDPr4iyDMDQLWteglscDT/RAPtnnfzzAI2lOSGCREJLTAsjGcvF2ih8YvGhT74ydnb4f38Iu0aSSmHMOuxuYi5pEKztlTo48b8hak
 hTdKcqhN
 SPYwXLJXUmxDem72ujfFPc8tfwB1UAy/40byIJGOX7Ot4tl3m/6mFJx8kzXTt3Uo8RkJcuPw8mHyPwH3d8ydNGokx0Jg5KVLNUJKF/mA/MHLj0npmst7JJ7ai0Qep51SO9uVgniVuRFlypiImbCwoCSEcbewrf6/wBPb/XEyBROYF9sPIuPmqahm3JvrYiaEvjtxvckIcWw7tefk8RGb91w5Wu0qe80Kbpy3jUYLqmG5hYLTqT6r0qk4sN70tV04kiXIyf17LXoQupnbm/702ltbl+XHA2/nlxMiy0hq1TsUcaJpTTWBLBfNjSGKfF9YtqRMnXQ+ZJvVCAjR1rvUCTlvkuqSzYrTz/pUE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/26 18:01, Lorenzo Stoakes (ARM) wrote:
> On Fri, Sep 04, 2026 at 04:24:59PM +0100, Pedro Falcato wrote:
> Andrew - could you swap the patch out in-place with below? Thanks!
> 
> Cheers, Lorenzo
> 
> ----8<----
> From a706374a1186b6b4409a0e760e8728bcadba0c96 Mon Sep 17 00:00:00 2001
> From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
> Date: Thu, 3 Sep 2026 20:08:39 +0100
> Subject: [PATCH] mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on
>  MADV_WILLNEED
> 
> Currently MADV_WILLNEED treats file-backed and pure anonymous mappings
> entirely separately - using POSIX_FADV_WILLNEED (equivalent of a readahead)
> for the former and a tree walk and swap in to swap cache for the latter.
> 
> MAP_PRIVATE-file backed mappings straddle the two and currently get treated
> as if they were purely file-backed, meaning any swapped out private pages
> remain swapped out.
> 
> Resolve the issue by explicitly checking for CoW'd MAP_PRIVATE-file backed
> mappings and performing both walks in this case.
> 
> Since the logic checks for vma->anon_vma this means un-CoW'd
> MAP_PRIVATE-file backed mappings retain only the single file walk.
> 
> Reported-by: Mike Kaplinskiy <mike@recall.ai>
> Closes: https://lore.kernel.org/all/CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


> ---
>  mm/madvise.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 73c2901b9adb..963337f93a7a 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -297,11 +297,12 @@ static long madvise_willneed(struct madvise_behavior *madv_behavior)
>  	loff_t offset;
> 
>  #ifdef CONFIG_SWAP
> -	if (!file) {
> +	if (vma_is_cow_mapping(vma) && vma->anon_vma) {
>  		walk_page_range_vma(vma, start, end, &swapin_walk_ops, vma);
>  		lru_add_drain(); /* Push any new pages onto the LRU now */
> -		return 0;
>  	}
> +	if (!file)
> +		return 0;
> 
>  	if (shmem_mapping(file->f_mapping)) {
>  		shmem_swapin_range(vma, start, end, file->f_mapping);
> --
> 2.55.0


