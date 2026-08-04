Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1B3CC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C75306B00C6; Tue,  4 Aug 2026 09:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4C5E6B00C8; Tue,  4 Aug 2026 09:42:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62196B00C9; Tue,  4 Aug 2026 09:42:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 937936B00C6
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:42:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0203012011F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:15:54 +0000 (UTC)
X-FDA: 85063332270.13.4D56DE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 70BE1140014
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:15:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DCdqhtW0;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785842153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1BnYhgvMr/FHPkS0bNJFQoIeIyjuwgqHxPYj6YvNKVc=;
	b=wiyk+A3SDMfLbZUFSH0EWVPZccCVYcyiZviXdQamF3yFkr+jyp0PDJOdw7jjhBh1jWIiPX
	0/dLdJgPTEqDV80CCFCHx3NRcIwUVcTQ84i2Lh2gt/kFsuQnOzv7wglrtJglAjKO1iBnVI
	Y9bsCXusK93Co7NO+Ed4J4RPc22qb2A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DCdqhtW0;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785842153;
	b=1MY5BJZOXGGMoKltIok35qz+W1RUKvd3xrTnlcLEwhZuBpUzrAR+E6R9M2j+ozeYXyFjNW
	JEpUCAZ4MsNCNd2yM/lCkH1ZsxCSQude+MwKKm4D8u+JlYpLVl3nFIXPD5kha0AAijkM9w
	/kMqkXV8PMOf/5SnWlWhI47v8/a3He0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 116CE60A73;
	Tue,  4 Aug 2026 11:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046C71F000E9;
	Tue,  4 Aug 2026 11:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785842152;
	bh=1BnYhgvMr/FHPkS0bNJFQoIeIyjuwgqHxPYj6YvNKVc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DCdqhtW0GuGx813a1jz15OF/gAOcKlGQQMgstOkscJnbZ80cNSpXodL8obchTcvvY
	 KQN/nV7kGqJm+LgZAMxiWln9TvZ9vdXnXKBNn04G5L50+Jtsera2TdakLrWXQPjpRJ
	 x8VVNbIUYTfqBCCHJia88Qyqm/NaABhvVg7mu4+1dGtQVeVDCeexi1Iy6rImYBMNfi
	 yuvK2QUypp85rdG0Cu3jYFHIqsB3PJSA8ZplOmQs5oOP8mjC8gas04Nptnlq3h+Y8s
	 Y9VUnlv4cYWu2FTlz34/ZW1CV/hhjFHJB7a6P2rmFU++gl2FT7ktYhKgMqjMNRVXzR
	 yYKcYv6kfq3MQ==
Date: Tue, 4 Aug 2026 12:15:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 5/6] mm: constify generic pte_get*()
Message-ID: <anHJtpEpXWITllqk@lucifer>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-6-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803164400.531199-6-pfalcato@suse.de>
X-Rspamd-Queue-Id: 70BE1140014
X-Stat-Signature: e4zxi94zhi9ttogzynpzumqffruq7jji
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1785842153-767347
X-HE-Meta: U2FsdGVkX191nG1L+agi4CKZfGluNt0+O4R1Je/AN6cJJbCmIxkrw7BJQmPb14tuxPPtaeyxQmEIdyFTldZlyus4cfvhVZw0NujXc8ktqG3p3ibBFLPnXxV04vlRKfqKQGr5yv5WvDaWgXA4wL9SIEfodELN2PCnKe6p/Li5UyskLMQXZhG361y4YCjlA/YzgsEYvqQMtDLqCclOsjQtbk4N7LqTJ/pzYOO38dcJCv+2sO3ScAbsHCBiFMonnKlNc4gIZVLlgz7fOTsTrCUjftL32h8qXKTYJHIyEzvcO7rrwzwMcnf3zkHjZYwpB6vJsfXtPV646IZa0lI3YKdRFa/JfX26O8DUywuO41rFu4kK4f6EXr7dFMds7Pij1Fz3JEHWzzUQcxpJ5K1TeZE7VaCxRcTc1jBUVzjQmEIImoBh0rn8ZCXZryB3tGdyZabdk95CRnn4d1U8FQP6dpE18ZnL461vBsjWvrJpl5Cj35fLkSgL8FZnwKpzALGA+AnGfDkCJZG7NyKPpCQKAfJWHPAxMDs0o7oRyFnIIzibaBkQNdCAYtPOvzo9DlXBiQm8AVqt3x8nvQJV2o9efCRcAS0yP/20BHkIAuZsDkOiHxJrOk7JPm/dra0SBotwJI+Y185C9s43tRojR9vh6VbUkMJ9xKm5eHwgoQFw3YnH5k0WLy2KekDQ/8PebwzqsOuDuLHsMzGmLj3bT23+yp/GyYp88PYRrMWGLXWXtboj+phhdRFH9lr457BUaLstsjDScePfZ119D3yI+StH9cxPnAUsLI9PAyB9BfFQRDr3WDDC7SFYodTpV9F6nj1Lxh/A00KHUwMYNwmuaWv7dEWgySqJnLzLPSzYWCxBbHg33kFm/8jg0AO3fnNDUBaT70uZBnOHhOTkv2N2jx9OFPzoI9SZlnzzYnJBMCv0MQ4nzy6WI4An6cownI3NavS8KDaizBgQ99ljrjQnARn5j8m
 8UlDTDKU
 mse6di5sNdbkUlPpnKRgqowolOAMVi+7NZqH3EQR3Hn/JaEIuVelxQvi6DryegmgQ6tAdmKRH2PvCJ90926ODoUC0YvlaRHND6kdU15Y0HRRKLAwcW4FJ9OL9JHFquT53FfC/JSYsAqiodLqP/oMAQruMPorV6yMz0gRdI5ufdz/AyImdnbHc8B265ILrgA+0x6aT/9F/74u0F+d98aZ+17xCZwuHhWPahH7P/76AhaeJNA4Fjycv1XTGIqnQzotACcZwfLBpQXJfBnyo8BqAbUFE2r/k/0Lvvkwp9uBqkykrEe4DhBgChkaTb1Jl3/gAzP0TC10E0JWvtGU4qZsLwv9c1XgGJiXmfdlCbw/A0+Y0heMmJfGwchfNthWuOVO27g2jgqsYYMQ4b+A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 05:43:59PM +0100, Pedro Falcato wrote:
> None of the helpers need write access to the PTE. Constifying the param
> allows for const typesafety.

constity?

>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/pgtable.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 8c093c119e5a..dc418553e57a 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -490,7 +490,7 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
>  #endif
>
>  #ifndef ptep_get
> -static inline pte_t ptep_get(pte_t *ptep)
> +static inline pte_t ptep_get(const pte_t *ptep)
>  {
>  	return READ_ONCE(*ptep);
>  }
> @@ -739,7 +739,7 @@ static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
>   * present bit set *unless* it is 'l'. Because get_user_pages_fast() only
>   * operates on present ptes we're safe.
>   */
> -static inline pte_t ptep_get_lockless(pte_t *ptep)
> +static inline pte_t ptep_get_lockless(const pte_t *ptep)
>  {
>  	pte_t pte;
>
> @@ -777,7 +777,7 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
>   * We require that the PTE can be read atomically.
>   */
>  #ifndef ptep_get_lockless
> -static inline pte_t ptep_get_lockless(pte_t *ptep)
> +static inline pte_t ptep_get_lockless(const pte_t *ptep)
>  {
>  	return ptep_get(ptep);
>  }
> --
> 2.55.0
>

--
Cheers, Lorenzo

