Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B8D4CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 15:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E4098E0089; Mon,  3 Nov 2025 10:59:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66D8E8E0057; Mon,  3 Nov 2025 10:59:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55CB78E0089; Mon,  3 Nov 2025 10:59:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 414CB8E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:59:46 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E19EE1601FF
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:59:45 +0000 (UTC)
X-FDA: 84069756330.26.D6C9A77
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 130C940006
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:59:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762185584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j33smVISVrnN0itzkGV4Zm4MAj8OlVMwAec9wNuydK0=;
	b=hhLkLJhdLJa4zaK5KoZW9kbkcemZyXWcylXBT5eO5wVYe9IsrH6CgEgummcqSgP23Ahw7s
	bveKzoi3G+8nIk5mcd/BNbC6LaOZTcqF/w0ap94EiQQP4XsOJ+RuTLVhl+lKHEZmGoegOx
	0vlTsstGH6ur7xRCT8x9lfLcO9iHalo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762185584; a=rsa-sha256;
	cv=none;
	b=sJ3mdp0gv56+zUzzR08ByEG74Xm/xgW1X6DBBkJohVGbBN3/EcEMn++FAUaBbDEnGHxPKl
	vcorrqyBIgWW5zO0bxR9Dqgj7qh79RvGujmRjRzRUS+Nlxc3ukyOaCpLNvu+QeDGGbRWsW
	8FqlNUVyi9dqgXckyPpA34TzOi0z4BE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F9C11D14;
	Mon,  3 Nov 2025 07:59:35 -0800 (PST)
Received: from arm.com (unknown [10.1.25.188])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EDEAA3F694;
	Mon,  3 Nov 2025 07:59:41 -0800 (PST)
Date: Mon, 3 Nov 2025 15:59:39 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Aishwarya.TCV@arm.com
Subject: Re: [PATCH] mm/huge_memory: Initialise the tags of the huge zero
 folio
Message-ID: <aQjRa-Bh8J8Smgur@arm.com>
References: <20251031170133.280742-1-catalin.marinas@arm.com>
 <aQiu-hU3x5V5drHF@finisterre.sirena.org.uk>
 <aQi8dA_QpXM8XqrE@arm.com>
 <79a1f2dd-6752-426c-84c1-a38d300eb78c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79a1f2dd-6752-426c-84c1-a38d300eb78c@kernel.org>
X-Stat-Signature: c45zm6o76nbtrgf3shim7a7akr4fq7qn
X-Rspam-User: 
X-Rspamd-Queue-Id: 130C940006
X-Rspamd-Server: rspam10
X-HE-Tag: 1762185583-393314
X-HE-Meta: U2FsdGVkX18fbTIl/9MDktGLFc/tZf/A2oJqaYnmxwM1FSKo0U3eqPa89JzSRq2lENgRTvTeoXKX3HYNInnJjAaD+QjYhFV8KXJByQ2GrW97A+Ew57tWp8vPPxEA5akVatLtYEeB6syB52YaUDWDBrlOGYw0QXeev7pk4jlz5NErb1OyqpmMnwWimi54hAmlz7W7MBJFLBqGyPT6KJrPN19Gc+wbSEaP7ukRwGDHc1Qjy/l+5tqkc+/LklDaEApkNuNAEE4L0IeywhbmZdlD2ZwUCxaBettlXO+8I1VOciqZYXCV3cEuJHlQDrYjpRTTYyJ5rOOhmdpFZ7MlVxpEAbP5G8tSyHsmMobuDxbGz4kwxxW510MU6ONFr0wWdz4CQysPv45A7L/rq3iGaZq8PK641PTxviw/oW8Zj6CB34G7A6B/7hXXXy7pL2/xyklI0s5sfHyV4sCI9+oGGqVSq0GrFze3ZSzbf432F8IWyLSvneHdJ4cMBTp5/dFXYXSLA93CeCY3vISXgs0nDGwBoPDIbkpPJjlIacdcUjOXXpKbkd40mZYDZ6xrFGj2mTCtxjEgK5P3/Kix8+MjWnKrwO4QTJA3XENQZ4wlX0BHLQHVu6xuxc5+X5Eq3y3xse/t84KRuPZRG5f6FTEpjehxseYGN9/aIMgcdFVZmYzlil/dY1t12+RMRmuYuHCNnnToyxjiZ8ERGtqYRxhPpjpXkL1LliI+hX4MUkqhhSJCdv1mBgKcl0SkBpnuZal1DpZiDmUMyi8hbrjIFxrWxt7wunaimkGL5oJ+svb5cwZi2RF02NzLTVZHjOlHdbPFGNtMwsrn91oNuxpLD87r7zhiPJRH71oM7g1HQhjK/cRFCc8E0Vwxy+fqelbSkh5qStq2Kjzcg6HSHzs6eUvsLKrEhFWdP1xvu01xLsA/KNttU5HS3IVytv8Oxd5GhkirhT3/8+44uBEA+OeVp4Nmzvi
 JH9i2qmn
 97MC7JyYWNZHcdo+BCNN+h0JBRKRGXQzogYn9yDmVthk8SfitRYMCeDAeVzYcaLYXwQsonQRBgyoA+PFhn+5jDdqMID903/w5PO22cxJqJaBFxQAeosL6lxrqYNQV9e/QBSuVEVeOhhMKA8dSvmtDkoZfSujGGe7L43stiyv9/nV939V2BBDglQE4wQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 03:41:03PM +0100, David Hildenbrand (Red Hat) wrote:
> > diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> > index d816ff44faff..125dfa6c613b 100644
> > --- a/arch/arm64/mm/fault.c
> > +++ b/arch/arm64/mm/fault.c
> > @@ -969,6 +969,16 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
> >   void tag_clear_highpage(struct page *page)
> >   {
> > +	/*
> > +	 * Check if MTE is supported and fall back to clear_highpage().
> > +	 * get_huge_zero_folio() unconditionally passes __GFP_ZEROTAGS and
> > +	 * post_alloc_hook() will invoke tag_clear_highpage().
> > +	 */
> > +	if (!system_supports_mte()) {
> > +		clear_highpage(page);
> > +		return;
> > +	}
> 
> LGTM!

I tested it with and without MTE and it works fine.

Andrew, would you like a separate patch or are you ok with folding this
into the previous patch?

Thanks.

-- 
Catalin

