Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E6CCCCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 23:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A394F8E000C; Tue,  7 Oct 2025 19:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9948E0005; Tue,  7 Oct 2025 19:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FFAD8E000C; Tue,  7 Oct 2025 19:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7AF538E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 19:40:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 16EAA14034C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:40:31 +0000 (UTC)
X-FDA: 83972939862.24.B2D80C0
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 392641C0010
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:40:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QQwYGDnf;
	spf=pass (imf20.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759880429; a=rsa-sha256;
	cv=none;
	b=2Bx1dy53rlpivKKxAcuMr2XvJL3SGd87HDAKWTtP1O9PMJU+NRbjtwCImtoj1VR9wQ4QUE
	4EgV7v1A9FW5vjFlQymioHCGr8u4+F01mTpKto7gRrWpU2tUDhGcZutGuB/HC1aHq16P4Y
	G7GzMVtp+veF/RmVRrmhBPYf20LWfqQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QQwYGDnf;
	spf=pass (imf20.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759880429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKja+MW72xoxssH4FoUzg9b9lYAFP0NscU4QRLzkw/w=;
	b=z8zue8NjSLZvNqPO0vx/KBGPMtVuXf47IXBxDvyQxKY/BpVNejJ821AbCVly+6hF1eO4E+
	wB08Ht56w7bDUB5NkVDPmx0rolUiSNgl2YgqGY1ZpPskGTLRC6wCGoFfXWFOkc4Kg34HG5
	Bv/cFdM1bnKlRjbKhckStJwUnIr59Aw=
Date: Tue, 7 Oct 2025 23:40:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759880427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yKja+MW72xoxssH4FoUzg9b9lYAFP0NscU4QRLzkw/w=;
	b=QQwYGDnfGC+BjMzSWhdtP2Mm6J0fN66xBNaMU/Gpm0HQgyY82FDF2eelIAZPCd7HLi/ojy
	rQvEb3GS4EKks00ZFIT02TMeGhjoBfJJO1Zor0Li6Uc/z18wVGfADNWB4hA7xRyqs2T3Ba
	mIx/gTUE9eOHzBZ6EuZsqdvppJ02oL0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Nhat Pham <nphamcs@gmail.com>, kernel-team@meta.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm/zswap: remove unnecessary dlen writes for
 incompressible pages
Message-ID: <xdsrooh5v7hdkfzr4rmwg6bmg2kd7wediwk7efjexu3ken3wec@so6hlaxqvafh>
References: <20251003203851.43128-1-sj@kernel.org>
 <20251003203851.43128-2-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003203851.43128-2-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: jfshfp8swyf6gw86r3d7z87jp9xn6ntx
X-Rspamd-Queue-Id: 392641C0010
X-Rspamd-Server: rspam09
X-HE-Tag: 1759880429-91154
X-HE-Meta: U2FsdGVkX186FfNuHL1kco80Ov2KfOCaavj4csrOGofrCx8jwve+c6F1o6ruYSTS/ABmmOMtTyRu3i0v4rhtl6xLVUOrrveW40L14VZPbjWMjcugMhzOnsgi+cWDEcP1qhnyqXzr10Q1pdklH2RwAmXFzkB4kyA5GybIa5eacS0rEmf/IdGb2GIPX+st8iuor+Rzaa4zUhYilHDWPVmWVXhq0a3wgnl8pg4n52yq1YwbhAbkyMUYcshK61P51aDM00Jn0psFxjS2H9hp+BjjjyQKqsEC52asfrVe/UAsvygk4QJr7ugYiZWh4U6P94SFoBRRQvXNC7uVk06fviH0DXp76+rhy+VJtxQmPld+1v+jb6HvXAIK560pBQax5F5vd6V5sBxp0ncXIo2LZfIRFfAwQa7LhxjwB9kCz9JIagAtX+IkEwdGtlc58SXT37hgRRGwg/pcCsf5fqc3yy2Bnukvvatad9/rjGF5jM/UVY7CkEr2zUXty7Q0onS3M3kRwCuEYfn3rat7joGkjl2o5GsgAbcA3+YPaRP9aP+PukAkNqfsbIszLc5dAo5VplA32ZFNZiPbNwM8zWJiI/gKg/KdbNY0tFHYwHr8hcSjGuBBYVuwJW5wHK/uOCJPvQ0mA7b4jPFaXTBdEt8jGKxRaOewiKLnjVZAL5WXZd/wkzvr1m/GqrzV5jZqeDzaQ1kKK/HrPyhpMsRgjGqxYSyg7xupAeqHG60Lc6lpZXKIyoKbGoKjoCxJKh3gAFNsrUgU8pcCg/0jaRxbafTC5KcV7mWrNqvdCF2GrNG28dIb0Pi9TB6KFsD1UljKuy/FZI2Z5U7IwNZy8qPtDsjavX7+Yoat+MteGzPqZD/3C6MDaMlv7rInD5/Gsnt3q1DaxfTni0C6X2wQv7lFFOc41sJ8CHiJffx08S2RffVVDEdKRY0fkcbewoXGyEycgFoeCe25k0EIefbDH1q86oWV6hE
 PZ+Wl3dG
 d1NkSBYHfs8bIT2/VfjVt05Z8AD/KH/h51fQc7vmUoobeFCQVZDdXvAyFJjn3/SCnmvvjOsm9h+IGLBq3oDdzkY81xxEgAmmnVL6desCXz2ILM3j/Oq7+kWPTOC8mCdWQESv9yCK/BOOToJLqYakmyFLMl+G7KUQ11Qn/pVBcwOiHHEuMnrZv8n5/HZZLW+om4VvrAb5YhxdYYkghB1gjJczhuhHUpfANKBXR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 01:38:48PM -0700, SeongJae Park wrote:
> Incompressible pages handling logic in zswap_compress() is setting
> 'dlen' as PAGE_SIZE twice.  Once before deciding whether to save the
> content as is, and once again after it is decided to save it as is.
> But the value of 'dlen' is used only if it is decided to save the
> content as is, so the first write is unnecessary.  It is not causing
> real user issues, but making code confusing to read.  Remove the
> unnecessary write operation.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>

Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  mm/zswap.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index c1af782e54ec..80619c8589a7 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -894,7 +894,6 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>  	 * to the active LRU list in the case.
>  	 */
>  	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
> -		dlen = PAGE_SIZE;
>  		if (!mem_cgroup_zswap_writeback_enabled(
>  					folio_memcg(page_folio(page)))) {
>  			comp_ret = comp_ret ? comp_ret : -EINVAL;
> -- 
> 2.39.5

