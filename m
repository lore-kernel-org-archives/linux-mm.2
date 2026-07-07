Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B871C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:28:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C1096B00BF; Tue,  7 Jul 2026 04:28:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94B6E6B00C1; Tue,  7 Jul 2026 04:28:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EAB86B00C2; Tue,  7 Jul 2026 04:28:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0766B00BF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:28:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D05701C7E70
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:28:45 +0000 (UTC)
X-FDA: 84961304610.13.74D2763
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3E4B340004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:28:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DUplStSV;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783412924;
	b=WMjLvMgQP0x77DPN9IH0nE8D2EnX10CnmIkbJh8l0qlXWBcx4NrXJYzyct0QOpVrnuIybq
	3kCGf5eOQiKLJBK8S87xD0XvFT24w2V4qTs90WICYgjKcqWQXp+jo4lNR0TOxuDsbh22k7
	J/he29sjgFoCe/miEB252RmtTMHvHhQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DUplStSV;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783412924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bTtHLLXkDckXLsTZ5c1jk/iglU4PY26Dt8wxlN3Kfqk=;
	b=oyiCdIY5r3AXvhkrCR0VkQykb8Xcfk5l3d74dctFCLATRPmrxsgFxZVduP/QhuXUow1VIA
	dkTQI8DH3EcafA0qU/1UY8G4KY9yVwiy4kg++6hchqMC8CVkaDq9LvGdCQEt99b8RgtA6x
	VkiekGacaBi+9f1Ph9Y6G2YQxo6uVss=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4AA0618A8;
	Tue,  7 Jul 2026 08:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4B91F00A3A;
	Tue,  7 Jul 2026 08:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783412923;
	bh=bTtHLLXkDckXLsTZ5c1jk/iglU4PY26Dt8wxlN3Kfqk=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=DUplStSVMjQ4eMbQb1O4U3hnTIRLMbLr+7eVVek9js6dIYtO3/cRtjHE2vV9GyzRc
	 SB2PKKP1OJ7HHAz6SFw6xObPp6N0e/gn0fyHiY/NTB7+QF7ltiwGt89ArCgiaZorES
	 4Opz3NETbD/AZV/Eq3UjOibyjjdpH3EoCHQzEyJEFhm7ycoXi4btnH8Vn6LeZU9oIC
	 tx4tkriauR/+NflqKKFHY75H7H+jRRGlqLik8nOaxmmYv+G44vOFLp57DbbSEApRj4
	 WyqsJmAAJ3MTa0Ta++TZUEU2TSzhMGdNZS3jhXcQTI9e8EZ05eDouhf8XzUc88sQe3
	 NrA/OfWrTalpQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH 3/4] kho: Implement page-aware refcount restoration
From: Mike Rapoport <rppt@kernel.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260703020832.1731864-4-praan@google.com>
References: <20260703020832.1731864-1-praan@google.com>
 <20260703020832.1731864-4-praan@google.com>
Date: Tue, 07 Jul 2026 11:28:28 +0300
Message-Id: <178341290877.3292146.335016287917708290.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3E4B340004
X-Stat-Signature: eorwoauzejjt3eptekj6jrrc5m9zz6kd
X-HE-Tag: 1783412924-51307
X-HE-Meta: U2FsdGVkX1/Qac36LypdNde83Uv37YVQYU5wFNnxKG8Utd+JMfMcA5/W1FF4vOtOQL4EKGvmKm4HrAFziQcynDp5V/9dzQNz5+pSP6OxVp+iyt9BHDsjL16sSW/vPyMKxPm1tm3ep+IG6QPi630NXS8lHZ69ijAZotirQjJgGcT0u8Ozzz6jBHsAXcSeUkbgkPUUJYt07Cnj+IT6yZdEMpDmlwXt+inSjKChOnLdaOqaB3Vyh3a3bsMEvjGAGyLLdoBWdyzrpxO7gr5UlqyrRJpv4Kv7HmOcPDIoOUjRSMD0d7yEREMhP1TRAOac2l1mMoX5WihhiL2E/wr9+jjwYWsnfMIHrE7QKQFiGCi2+KoMxsa2w1pnT5pgF7zCw9wVi59PzeCpG4BNWPL31h+XiUU/8oonJM9EfzJ75hx2UxRvJ14Ybrv0x8ceF/aDj07jdvpsW4sNoAnyI2L8YrEw1flc6++kDSV3gPtPgeJvUvTvKCUMZ8jOCTurNWFeLtLnJFM3E32kbqmm/co1ihY8lhx3Epc2vT/HhWfFdPpUPBZJxZ+ALmyJtoKtERnrirHMPI7D5J+BNvWeZcI9yKz3Uf9Elvy/kDIiE23Kjt9N8LU0unxaSY4CIa6KlrUXs6AaE9f8Oy6kxqZMi8qBmh77t5HETH0rAWNqaqMZOKL29YfZv7WxA4t/+2lZTMXJWTi0R2n5pHt51QO2xGJ/r2+Rl91tAMz8xeKja+vl7UMi05Cpse9cPv1jYi51UKo/71md09wCh1P1q4r5z/9oAJ3LIBa8hdUqUdx4DykWJlLOvXm0QeaK442QwpADoAE+Se1X2rwRs6kYyRzDIE0vCWAoxGiGVvlutzPAyAwDluwxqIafA1febR11b/vgyOLSqqMOFcpx+aZ8xu+f/juGk/mLsMbNVSR6ix9BcM5azKbGtQSVYU9XWejPb4HOzqGUv94SA1P8Afp3uLNS7o91T18
 bYcO98HL
 DUfj4l9pwpL+N7IiBOj+HWka9bAzLYEpIFUFj/Yw6Eo+HkMgQ864ZZV+I1zGyMG22IFrRlegr3a6me1UaGNJeXVCfbvEa0e1it+YHYQlcBjWz3jMuw4fpyl2Z+ZL0r4H2kKs/y33JjhfuEYWhNWdYM4YYI5JUGxo3+O8XpA1efge2yiWCcI7CyXjIzjEwkPSNYuxRSIeBw61rA12MgFboXpvWMoXBzh5WWtdfu9bDZ+fBVCj9F4Ska8i4ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The KHO restoration logic currently forces a refcount of 1 on every
> page of a multi-page block. While that is correct for split pages, it
> violates the expectations of the buddy allocator for high-order
> non-compound pages allocated by kernel user (like the DMA allocator),
> where tail pages are expected to have a refcount of 0.
> 
> Update the restoration path to respect the preserved page type stored
> in the page->private metadata. For KHO_PAGE_CONTIG blocks, only the
> head page is given a reference count of 1. For KHO_PAGE_SPLIT blocks,
> every page is given a reference count of 1.
> 
> Signed-off-by: Pranjal Shrivastava <praan@google.com>
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index d6e81f72fe5de..f6ca5e24c7407 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -375,11 +375,18 @@ int kho_radix_walk_tree(struct kho_radix_tree *tree,
>  }
>  EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
>  
> -/* For physically contiguous 0-order pages. */
> -static void kho_init_pages(struct page *page, unsigned long nr_pages)
> +/* For physically contiguous pages. */
> +static void kho_restore_refcounts(struct page *page, unsigned long nr_pages,
> +				  enum kho_page_type type)

Why did you change the function name?
It's there to ensure proper initialization of struct pages for preserved
memory and refcount is the only part of that.

>  {
> -	for (unsigned long i = 0; i < nr_pages; i++) {
> -		set_page_count(page + i, 1);
> +	/* Head page always gets refcount of 1. */
> +	set_page_count(page, 1);
> +	clear_page_tag_ref(page);
> +
> +	for (unsigned long i = 1; i < nr_pages; i++) {
> +		unsigned int count = (type == KHO_PAGE_SPLIT) ? 1 : 0;

The count is same for all iterations, why not initialize it outside the
loop?

> +
> +		set_page_count(page + i, count);
>  		/* Clear each page's codetag to avoid accounting mismatch. */
>  		clear_page_tag_ref(page + i);
>  	}
> @@ -387,16 +394,7 @@ static void kho_init_pages(struct page *page, unsigned long nr_pages)
>  
>  static void kho_init_folio(struct page *page, unsigned int order)
>  {
> -	unsigned long nr_pages = (1 << order);
> -
> -	/* Head page gets refcount of 1. */
> -	set_page_count(page, 1);
> -	/* Clear head page's codetag to avoid accounting mismatch. */
> -	clear_page_tag_ref(page);
> -
> -	/* For higher order folios, tail pages get a page count of zero. */
> -	for (unsigned long i = 1; i < nr_pages; i++)
> -		set_page_count(page + i, 0);
> +	kho_restore_refcounts(page, 1 << order, KHO_PAGE_CONTIG);

Ah, I see you wanted to reuse the same code for folios.
In this case you could add a helper for refcount initialization and call
it from here and from kho_init_pages().

-- 
Sincerely yours,
Mike.


