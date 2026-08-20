Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63221C5DF88
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 12:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24DEB6B008C; Thu, 20 Aug 2026 08:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D7F86B009B; Thu, 20 Aug 2026 08:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A0906B009D; Thu, 20 Aug 2026 08:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D88826B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:41:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D6AAA1400
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 12:41:25 +0000 (UTC)
X-FDA: 85121608530.08.3288B09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E36B318000C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 12:41:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SZM7xzv5;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787229683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=js6jAO2AUeEOFbqOxU+HLRNThDEIhIFO+cIerREkqQs=;
	b=3P9COzr0SI2XK4gr3fEClkRuqnA1R9WRD343qLzyqYA8zDmKJuv+uWtMPHK03fOlZ/hzsN
	BAtw5CVrZBegSW2tVut5k0abkLYKnPqiMAvTlin6aWln47zqmAISvuc1ZfgQdZvWlZPQIi
	x0fN1fnGfMxPOi4mhppT5oXz6Psw8jI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787229683;
	b=jmMY0kgCRmfrnoRHhEkIRHQ6l++O890ArOj4LOqPqFKXIKgWVIsQoYT/FwqFnNMxY/v+bA
	GO5oQNE5TAAZNvIQnFQBo52KBOM05vomTUbrXhG+YnCpuJpKxqaYKAdt+gE8YZdcEy0DFW
	W7i1tCT2S1Bsh0pG/9RXsXHLXAvvMfY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SZM7xzv5;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F04460A58;
	Thu, 20 Aug 2026 12:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF131F000E9;
	Thu, 20 Aug 2026 12:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787229682;
	bh=js6jAO2AUeEOFbqOxU+HLRNThDEIhIFO+cIerREkqQs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SZM7xzv5RyViQyk7T5ux5VHSy30/Ovpc1co4dXTt0yUMR0DGnbQL6nnkqlkMxc5v0
	 7eZDtdZFCdRftkOhRA7+qITeRVGi5EeKra7/7XBrweRjFW9mM8xkr3iG+4vRAH+EYr
	 mClL1oNRsoMiKnITCbHn17KJkGQ+jD3VKk/I/0/hwDrYu/RQGcDk7audz/D57orUiy
	 /cxXXdFp5AJ2yRhq93nzsLVAwZvg6PBbpG3oF7QlGXyQo5XrOjnyen+SWh9PTgbNbQ
	 HQ8qct/WIMoot9QSzLZ/jzIUombzU018pC25Q2vx9AlNuzKIAjmTtia3NJvPyZF/Gq
	 pNRIf98mpsKfQ==
Date: Thu, 20 Aug 2026 13:41:17 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 02/16] mm: provide vma_[flags_]is_cow_mapping() and
 remove is_cow_mapping()
Message-ID: <aob1goSSPH6sTN9y@gremlin>
References: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
 <20260813-b4-scalable-cow-virt-pgoff-v5-2-c21581c0c3c8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813-b4-scalable-cow-virt-pgoff-v5-2-c21581c0c3c8@kernel.org>
X-Rspam-User: 
X-Stat-Signature: p64i7wrhepmzi7wedoyz985t1kcc6kew
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E36B318000C
X-HE-Tag: 1787229683-375490
X-HE-Meta: U2FsdGVkX1+U3gYJgRO48EO36UsboukPHl2XLuSrE1Q/AkvPb/9mWnLOjfXp5T3RPAv1dpyKuUliYQsutzktjjtmFiODgFAMCXNCYATFt0MWnQCBvagmqZU8/aNA1epQgB53ML5i47x89ewxCAocRID+uOtS0oqTewYXEO1cAr6bdB7GE24EIwpzLh8GgRUl6WgJii4n9IMP7Evx7V6xZK1XxwSe2PEFQWd/gp9KxTYTZeqBwgP7919WIBAw8TupjyYkkcEVujUgY6OI/d37xyvGfPyMO0vG1Y4OSNczPHoBjBKSTEeFWQIbjG2k1VQYCu6+w8P0rBtq2D1S2Umz3gMnm9aXUWAv9mNqfkJjY20PA/yFjhe1gjjuPU6Tl/8rwUKFb9KdjCZ+YYc9vysnYd2CkexdFg0pSdMqRLmWLnavP8Jqq7FyimbYA9WO/1XvKx+f/ABHVW+YSS/BY3ca7BoI0FwFBcPokfpT2lh1chn/wPwioUzxuaY5+oj/3jBIg8VailYrlYJDywkgByZYzKGhWAHB5xCVxnf/uT8IZlJh0ba/Cb+xS70AtQxcDkKv6G9yR1IVfFLtVCD8svibqu4MiNqfZPnNnoxqvUWSBvddUpjPoR/kRMZsVdQsWoIR2WkLpYq+anBqgwLP0KbgCnvucU4t4C+4QALCIpoxaHxM93C0Yk5Sfwg3J791/1tQnneCbJ/rlUxWMx3wFxt+knc76pQ86mIFcIorNlqXH16KmW9FO4uawjEqws9FoJtA8L3pnBIww3jqUq/da7cwXBeqPB3fLO6oXSjYAgqEqlQsvY7pHCGo2wrha4jACorlSpan/DF0tnb1mlSYTvVCGS3br197v5hIPEmU8oX10eyJ2CN/qecTy4eCf554uJCjchB5VlbrStBm9/9ui45MkqFbnUTycz8sH+/Cs5j0dwH9y16EJKRpDDq/WdA4PtctEmRZ455Upb5vxX+St6w
 OG0mZatO
 Len/bLFWje2jGXkEpIGPbaWHZfhd3PZajuYb/5UWVbAVE8g1Wd70A8N784X0TcSsDqP1YtQXAY7MmfB8RzYgAtvRGYTzvMhN8H2NPV9JolZHMksLG/GkRDaLxaVWjKZhu3u4Gzbalp1uj+PyO5f8JnPxl5VBpnGqK3/ACohSmD4FN/txh4LY9iiaVsx8/eDBxOskewty38+jo1Dfd6vTsZtU1DcJxB+MVjlgW3tSxZywgaIahBjebL3bFtu7ChouZ8hTIp5oJHgnNxO10jEuDT/Urdk/TmRNWy+dpy+o9ALsApe0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(trim cc-list)

On Thu, Aug 13, 2026 at 06:32:19PM +0100, Lorenzo Stoakes (ARM) wrote:
...
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index df78847f5f07..199d0a64b14a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2271,17 +2271,76 @@ void unpin_user_pages(struct page **pages, unsigned long npages);
>  void unpin_user_folio(struct folio *folio, unsigned long npages);
>  void unpin_folios(struct folio **folios, unsigned long nfolios);
>
...
> +/**
> + * vma_is_cow_mapping() - Is this VMA a CoW mapping?
> + * @desc: The VMA to check.

Andrew - a small typo here, this should be @vma not @desc, are you still to fix
this in place? If not can always send a fixup patch next cycle :))

(Credit to David's scripts for finding this! :)

> + *
> + * See vma_flags_is_cow_mapping() for details.
> + *
> + * Returns: true if the VMA is a CoW mapping, otherwise false.
> + */
> +static inline bool vma_is_cow_mapping(const struct vm_area_struct *vma)
>  {
> -	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
> +	return vma_flags_is_cow_mapping(&vma->flags);
>  }
>


--
Cheers, Lorenzo

