Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00F23C4452B
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 01:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FB6D6B00B6; Tue, 21 Jul 2026 21:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D3466B00B7; Tue, 21 Jul 2026 21:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EC586B00B8; Tue, 21 Jul 2026 21:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 679266B00B6
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 21:25:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8B45A028B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 01:25:28 +0000 (UTC)
X-FDA: 85014669936.28.52F71D5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 791AF80002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 01:25:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AH1yMPga;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784683527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36tslyDQzMK9DRsSYiP8yJ4Xvp1NbiX3KOlD9FuNW60=;
	b=KtNc4q023JEayfVWhTJat8mcDCpUBcyvg47kcyk4LKIkeZuJIN/Lu3hOdJRxzzkxiXai1z
	4R/bgzIG0D3Rozxz7EhPuMQqbuZq7zH5qDNN41aKzq/AjtlGlKN3x03FigcG//QER77vVT
	2KMxlP+wVAUc2+rY1IVadUjyJQ1rnmo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784683527;
	b=iIuBNQF0LZLPvrWQC1P7OI8TcgJunUrGKfpvzzAbuFPogJ3dQIIA/r762RoPzaTu9vmYDD
	2qRN+FtHtPxd/Di7Nt48EtYQTJ5i4XiY8XboxHU6MS1KJmudgOmMyonow23zjIknKr6+oe
	N02122iahbVuGFCXIuuQns+9G8xqIFY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AH1yMPga;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=36tslyDQzMK9DRsSYiP8yJ4Xvp1NbiX3KOlD9FuNW60=; b=AH1yMPgaYJ/ZlOAHjTj5SGmh7I
	QiQZPsy3nXrc4392q/ZquqOfl0aVU6Ko0rQVoORy2IY2z19Pu2dOb28emR3YziOcDADlBvESUkhfD
	9HetugUAak+A0Ym3QtekcB/rKxtjmMFrIsuSAnenmbmB69NthJDJIAlMf52LY9WhJbJerg0s9CMJT
	iEl2eMZ8e3Y44hF3e76KUH9yxeug+o2lzVqtFe8ydtwycPlZ3URwk0wnMpC9H2Tcmh9c27F0qB8oc
	KlySH53LQHX7UBUGPzmzlWoSbub5hynL2VqhyqOxOlL4ApsJEHm9micWfNF3bq2BEF9rM62KWBHBk
	gd00kk0w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmLi5-0000000ERcV-1Heb;
	Wed, 22 Jul 2026 01:25:21 +0000
Date: Wed, 22 Jul 2026 02:25:21 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/memory: use folio lock/ref helpers in do_swap_page
Message-ID: <amAcAVdFT4O59Svw@casper.infradead.org>
References: <20260721013347.65698-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721013347.65698-1-hongfu.li@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 791AF80002
X-Stat-Signature: pqz5c13mnije9q9xuj555zdzhx9p3p63
X-Rspam-User: 
X-HE-Tag: 1784683526-230162
X-HE-Meta: U2FsdGVkX19eTz3ZPLJHNuAwL0xWGYWjr92xLKdKjEQeBba1vck2OG7WC9UBpd0swT0OQbZXnnSWDuHIud6FR9V38w16yXoTwua53XkstK+M2dmOaPeGLQ5uXxPblcXMAUbsdfduwAzCl4TqUxLi9fpIVrOipI7ZpM1EK0AflRrCt90FrzMlavYr6kOdFyCoGYYrcOTmAQylcfb3MhYJ8Y8bHQMju2VrKCtBMvCZ753OsIOBsEyB0hMw3emDr6vKkEp5EoMnokQIJJ/svu2I4I3LijyWOOCeT5XM2KlYZ5tM1b9elWVs67eI1AANEgNGRsMHSGFW4VZKPWqPIMdAVB7txqzn6p/we4qLUh2FBeSVvu/I6SRgME+jszwkZqgqvAuSsoFjO7uZWj65vGQq72CLDfPB3RBIZmBpQ3MR6GKLwKMJD1kvVUGexp+ymPxd8DC4JM9IWHHjdJ2eCluM6fzMFB64sVwMCyc+MQOCp9v8xm/eDFsSap/hInrEeM17NkRg8ojdw/tmz/fuqqPV57PaiLO80bcu9QI0BAAUSXqlgHiIWRB26QIM71PGw9bO7v7IkWF2QMM/Ny0aN6b83lYV4Wmqms2j//cNxEdtPzXGSGDyiEOda8I2KX2B3+iJESocnGpQk7ygjZ/zTm6Qn7tHMVQvmU67Bjl+FY3u2LeTapFc2gqqfDdWKGcr1QXdnIhi34SsoHoSUPLJNDhRWBZsjNlmJcU5fSKTLneEOyX5YraQgCvfu+yzMFHIcC64qlR8aRHovwW6w2hG0sG78jzmSIIlC4hqdfwzjUAP1iMTgXYS1cwHujn6qJxgXyvwWpQWhPVO41mdgoln+LfUmHOmvWnn3StAR3kERImZC0Ks/bmMei5Q1iwIzLjlDG0wfSq7P8639cYjRvandDXU1m827SvPiz54mui2QXPYBvkFWpb/gmhZSyPteLz9H77Ts9bIpeuRFd+7a54HHmI
 hugO82Ei
 WUfAPDOyQLoq3OLpngZwXyblMTPbOzBpEh6OrHT8OjSbXpDrQC4EI258v9iQGKkxcUTWnI5c/81uKr1ddJoQYj0f4IgRYvSYM9tSMtXe9HwfKINPYdrsck4pucPm/oCA50EynCLP6abpDN9tGtXu0WYDuZb5Lnd9aFfXpNL4hYm4SkxqSWelAikin/wOL/c9fNtV+HvEdAoEJ9w94IrIL7V4te2xPg1uCE+ixpLJpJmQkRdQH+FSq4zW8cyVJWvC4GUnv2cKCKjPZvCj02zaJ7MALfbgSeHNSpvzSGeJyMj+vTMdzKkNp54ceTEvjPipqymOJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 09:33:47AM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> Replace page-level lock/ref operations with their folio equivalents
> in the device_private migration path of do_swap_page().

When I do folio conversions, I like to mention the actual advantage
of the patch.  Here, I'd say something like ...

mm: Use a folio in the softleaf_is_device_private path

Use the folio APIs, replacing four calls to compound_head() with one.



> Introduce a local fault_folio to hold page_folio(vmf->page) to avoid
> repeated page_folio() invocations.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
>  mm/memory.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index d5e87624f692..bd27372a1052 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4852,6 +4852,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  			vmf->page = softleaf_to_page(entry);
>  			ret = remove_device_exclusive_entry(vmf);
>  		} else if (softleaf_is_device_private(entry)) {
> +			struct folio *fault_folio;

You can just use the existing 'folio' variable.

Although this function is far too long (400 lines!  14 function-scope
variables!) so I don't blame you for not noticing that.  Pulling a
do_non_swap_page() out of it might be a kindness.

>  			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
>  				/*
>  				 * migrate_to_ram is not yet ready to operate
> @@ -4863,6 +4865,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  			}
>  
>  			vmf->page = softleaf_to_page(entry);
> +			fault_folio = page_folio(vmf->page);
>  			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
>  					vmf->address, &vmf->ptl);
>  			if (unlikely(!vmf->pte ||
> @@ -4874,15 +4877,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  			 * Get a page reference while we know the page can't be
>  			 * freed.

You should also replace 'page' with 'folio' here.  Pages don't have
refcounts, folios do.


