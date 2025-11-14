Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 821D8CE8D60
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8608E0046; Fri, 14 Nov 2025 12:33:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68868E0010; Fri, 14 Nov 2025 12:33:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C57768E0046; Fri, 14 Nov 2025 12:33:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2FC08E0010
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:33:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 721AB1A0455
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:33:41 +0000 (UTC)
X-FDA: 84109909842.09.AC2B867
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A4251140011
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:33:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WO8IcdGX;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763141619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P85Bi3ZKtQRZnB23RdIsa8lwhMvYUwZo2MtEJouVc8U=;
	b=TzGe/VF+yTG2NqVtVoTlwjy4gBekGmz2UEUxqj5BHtDU6z+J+sSlmUjj4raleolczgNL8O
	Yspq1Iel0w1JjK4EJEAFwsyl7a3tq5S+5qYk8MRJ3K37ngAflXrBor3oKU/6ONsxUa1G/b
	liOrIJw/BXDsWChC/wAbpiOIKfj6MkM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WO8IcdGX;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763141619; a=rsa-sha256;
	cv=none;
	b=Rf+JGk2a9CAyIGf0IjyZlQ736St0JNc+qbd4rk0R7IHcn/1A2n509web91VjaVe4C1TR/k
	vG7otxwWEU0No02oRS41X8LGlf94NVYXZXB12u7bpHqlQS/ZsgYsZSU2ww6dT3TMJL6Or1
	nU5gzLpTkZo2ZCcSxfgjnSfIi0WdlNM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F3C7436B6;
	Fri, 14 Nov 2025 17:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DDAC4CEF1;
	Fri, 14 Nov 2025 17:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763141618;
	bh=xiOmpAH22LBPrHl3S2bglBGW7v5HJxbVPsI9S3i0sCU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=WO8IcdGXQ0Tc67QzXNWENs/BXaSCO+3Ot1YABbffhiA/Howp0f1asS2WJ2hTHFol6
	 2+0mylwMssClZNggRszcaeyQA3lzVdacjpZ26hZ444vOwuWIa0gHSefxSNYM2rxkyW
	 G12fyasFzCVdPS0pAW6JmCaLYYbiC2S7KRUcjMdZEapajKk9XBkyznNBsKu5U4AHZD
	 BQ0WxH4g1bB1fOO8CX67HpxY6wzgifK0xiGcHzg5kqfX6b8xI7HsRZONHAv4STd0A2
	 W6TnzvubponvquD2Ryd/MeCJlamvEFPworipOdoXNEXWFg+pXCw8xM2oGaQ/NBkdt6
	 gfLooe6TTju1w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  bhe@redhat.com,  rppt@kernel.org,
  jasonmiu@google.com,  arnd@arndb.de,  coxu@redhat.com,
  dave@vasilevsky.ca,  ebiggers@google.com,  graf@amazon.com,
  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v1 11/13] kho: Allow memory preservation state updates
 after finalization
In-Reply-To: <20251114155358.2884014-12-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 14 Nov 2025 10:53:56 -0500")
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
	<20251114155358.2884014-12-pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 18:33:35 +0100
Message-ID: <mafs0zf8o5xjk.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A4251140011
X-Stat-Signature: ss3qs9sy3bh4nngyfeypd7jkxhpnsnuf
X-Rspam-User: 
X-HE-Tag: 1763141619-279558
X-HE-Meta: U2FsdGVkX18xsTNm8I6Hg+U7NYjvC3+FbiVNQGesCatb+Sn79kMJcaBxYsiRfpHDzjTEQ0kud+uSsEE+Y1Q1GO7gbnF5ZqGrs3H/xFLTuI6rF69PTqJgMziBJ1efYt46IiV6fW6kM2Ng9NbMOQrMBfmQgWFLhQ5oRO+eY2naL0mgUFBL9Wqv3hns+grDP1sKQVelVgJZYOagfxe5lHTHdaYI4wZlwLmhTEZkeWjPLT25pEXAHVS+cERwVtPBwFap1cpzQWLmlSNKK3ljDI7bSld1zLJjUCAFqdW1r/td1f9Rqbalsjbu6XMyISZj49r3aO+tj3y4baIpqmLO8x2jg3vnvzXqUvbqC6KxvrGQuXsK7CjyUkMGNLnfkFnvd95OgUHiasAOHOWxX+VqrN8GaOL9yL3RwyqzW3SI7ZRWL2IcijRmhGR31PAVW8auIsxFxlu1EP03kqWJdJCJHEUBT6urJoJ65hcC9OMMDQQUNNYBhkrbvHguApZzOFv8V+nAJqVAlHVWT4CYw+vdsXBGsY3JTIhJqaQ+xjoPwU1x8JxnS8ZJrbcfwpcmJDQWXxtJ0ECcbk5XRE9hHh56vXzwQXRJEY5L35nQLNHtxiqJFC62+DtKyEm7nIHxF0AmU+LO+8NI6+qednJbw5H4MzHDPqmBcLtG2l8gwZ7V/bvX86p5qMqmsQIw0gTqnQOczj6DBzpxNl4GCeMbcHKU25INZRgyh3i6fLpMw1E0ZP1p3Xke69f4P4M3xIwFhtoWXzr/WHiRI+ZEngWuL23FgSqNYz6tTt/5s7bi60ZtBm6NhZt7b4OQkI43vSUeA29P3M2rIR3s77JayH8bpixi3fc4EQNEDfCeAS/l59pDpPWR+Q+UdVxqNj8YBlgLwb25UaSch8U+IC+EKKsg+Ep9ELqTtvUtMElpTWtPwZJG0hxDuF94eGZyr7Zta0hNUzBUM/MnfMRlNxzvxs1IvVER/m+
 eMywheMR
 dmnMMv2YdCpLw22k18cnRJsyw76AzwTfczL0JpOw1tyslViyOvQP1q7ltdElp8PNXa3NoqfT0ac4dgtU5azVgENNR7wYantY7/QoDOYGZd2/UJBkovMTrWv0yngk5z+/DwJSzgdsgHXN22mhaU5aWsKFcSfR3NUhLMHkSC/npYDtGMrdJ+GMfX3KjYUfUKpXUB5aFyCjBdkNt57b5OuCvlJs631zSIrmwhyKktF9RvZVzukY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025, Pasha Tatashin wrote:

> Currently, kho_preserve_* and kho_unpreserve_* return -EBUSY if
> KHO is finalized. This enforces a rigid "freeze" on the KHO memory
> state.
>
> With the introduction of re-entrant finalization, this restriction is
> no longer necessary. Users should be allowed to modify the preservation
> set (e.g., adding new pages or freeing old ones) even after an initial
> finalization.
>
> The intended workflow for updates is now:
> 1. Modify state (preserve/unpreserve).
> 2. Call kho_finalize() again to refresh the serialized metadata.
>
> Remove the kho_out.finalized checks to enable this dynamic behavior.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 13 -------------
>  1 file changed, 13 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 27ef20565a5f..87e9b488237d 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -183,10 +183,6 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
>  	const unsigned long pfn_high = pfn >> order;
>  
>  	might_sleep();
> -
> -	if (kho_out.finalized)
> -		return -EBUSY;
> -
>  	physxa = xa_load(&track->orders, order);
>  	if (!physxa) {
>  		int err;
> @@ -815,9 +811,6 @@ int kho_unpreserve_folio(struct folio *folio)

This can be void now. This would make consumers a bit simpler, since
right now, the memfd preservation logic does a WARN_ON() if this
function fails. That can be dropped now that the function can never
fail.

Same for kho_unpreserve_pages() and kho_unpreserve_vmalloc().

>  	const unsigned int order = folio_order(folio);
>  	struct kho_mem_track *track = &kho_out.track;
>  
> -	if (kho_out.finalized)
> -		return -EBUSY;
> -
>  	__kho_unpreserve_order(track, pfn, order);
>  	return 0;
>  }
> @@ -885,9 +878,6 @@ int kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
>  	const unsigned long start_pfn = page_to_pfn(page);
>  	const unsigned long end_pfn = start_pfn + nr_pages;
>  
> -	if (kho_out.finalized)
> -		return -EBUSY;
> -
>  	__kho_unpreserve(track, start_pfn, end_pfn);
>  
>  	return 0;
> @@ -1066,9 +1056,6 @@ EXPORT_SYMBOL_GPL(kho_preserve_vmalloc);
>   */
>  int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
>  {
> -	if (kho_out.finalized)
> -		return -EBUSY;
> -
>  	kho_vmalloc_free_chunks(preservation);
>  
>  	return 0;

-- 
Regards,
Pratyush Yadav

