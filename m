Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B281C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 10:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C7196B0005; Mon, 29 Jun 2026 06:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A0416B0088; Mon, 29 Jun 2026 06:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DD946B008A; Mon, 29 Jun 2026 06:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F0266B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:21:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79AF91205F1
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:21:22 +0000 (UTC)
X-FDA: 84932558004.13.80B7D64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D7C59C0009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:21:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k4VqO4OP;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782728480;
	b=M6beFDF4/0d7Q8WgSqDbj6a2Y3Pnylnn08nNF4KrTctU2g+BO4xl9XOSr52GSb0ndCdzBm
	ZtCNo1JodtnLJoStc3nfkll0uKOCucmRsKhW0UxkMNIIYJ3XUYZ4x0t7PVv/o/We6oAwFx
	3+EccVcfcxSw3tHcruWaB6pvcz3fKQU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782728480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWacwzXDsthaKuP5l9YfT3wOuzUJwz+T9Kp6WoULqsg=;
	b=sXpSile2qD5rExRY9URwZ/wDk5uq441LlRlet75WzzSQvL+x5zd56ZuLSD6qGOmKebEmTA
	i4LfTOKbwZAlVLIllcr/v9XuABPNUpao8wB3g/YzBiPevjXd/GDDCOky00veRQqASfoWJi
	VSwNFBh0Ly/zlFv2DfIrg0YdB5BxAHw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k4VqO4OP;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6051360008;
	Mon, 29 Jun 2026 10:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BD21F000E9;
	Mon, 29 Jun 2026 10:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782728480;
	bh=hWacwzXDsthaKuP5l9YfT3wOuzUJwz+T9Kp6WoULqsg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k4VqO4OPJ1P0VvsP9GW4oTWLcs8PBpWPWCTU+JUJEjwiSGou7TB/CSY1pd/QfM0Z6
	 V+eJAqwcid7N8P4lnv+QbGlS5sVkRfVSgcGwfFsJjHIPvX2TUGzYXYufY0VC467/8i
	 +GyGXkc2NOd97DZDMCWtvUcpj2jbJI0SWw7N7/K6ZChB5mhILggGHXx+xd6OCOOUVd
	 S43lV0tvGH4n5XkOMuff93KHY0AFMdZ5gDjvitOEmzUEL+EjsUZSkG+I4F7AZpAFe9
	 zEntDDN2jVfGNrCexLn2MZrL7QzkLgiMqrVBmMQ2fZLhci8b5/YTQTC8H78TvZJqnG
	 xLGWdxP6ETgaA==
Date: Mon, 29 Jun 2026 11:21:10 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oscar Salvador <osalvador@suse.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Karsten Desler <kdesler@soohrt.org>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Andreas Larsson <andreas@gaisler.com>, "David S . Miller" <davem@davemloft.net>, 
	Huacai Chen <chenhuacai@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/8] Stop special-casing hugetlb mappings in
 get_unmapped_area
Message-ID: <akJHBIF2RDsm1zhe@lucifer>
References: <20260606035003.529685-1-osalvador@suse.de>
 <20260627235512.787d09b15b3d2ff9441e604a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260627235512.787d09b15b3d2ff9441e604a@linux-foundation.org>
X-Stat-Signature: fokdoafdfrouqnwtjj5ukrhuztmfmr1o
X-Rspam-User: 
X-Rspamd-Queue-Id: D7C59C0009
X-Rspamd-Server: rspam02
X-HE-Tag: 1782728480-509083
X-HE-Meta: U2FsdGVkX1+yzyUmiXsKOFyy2lMZnbfryJ21RaX0YvvBi1hnp//X7Ft/SqacwM1rCZHVhHX3wycNFucX/mBMtyMpXI3IAmbVexuUskqnwrIMjiZAONRocBpBYqjOKG2hIFPS9B1vANyaXU7pRmbXOYW+gfzyUQSG/Y4NufnhCarhLzlFLJR//RL/vs0CLBGQnn0BdXTWb2Wn/jCYkjZ1Fyq5woK05MKX9AWyfih1CxnX5PNNuI7xCSdXz6z3JmDZKj90UAQBr5hPwUMufePKQweueQQ/bCvHuB87pVQ3LyFWP53mz5sF51DJb5JG8rUL2Px8Vr9yj0G2cSOUHLhb3WKDZAb0dIH6UXJ1uPJamGFJomgGDvzn86G02efmucErGgfesrqSls0GYap108drNACQPKaqR9TN29elPn33p7eEfC0p9+wfINt5K6LlOdAbFvcNmXL8Es69mm0u/oIgaL62Cl61j/EaH3FgBwWJ83eqB6/UBTuzeklmfjJqzsvk9YD5AkqSgYgH3aJrNCq3fJYigjNXPbYiMALub9a+Q57e4vHWiryuGoZnWJWorSwjv1UuFWwr21eJOqqGtEaOIT6blWvX5cJtTM783V3hNm3MPatH0p4un0MLBspNiDI5jZ5I6Nk/IKNqfvm578jIHPlczxgdwxfX6VbRdI5MBvlgG0PdICV/Og3Q+m+3yZlcdoezZVo5B88fASqE/VnEOUWnubWCOyRqmBamyJrT2HD0NL2TRTK4+BFDZMO6E0P23MD/pp8UW17ufQnKKqVtPbIeWxZ3xHUW4mbXfRZ51oCoW1WlSBtyggL/GzEBIGYsLOS9TvSIynAk5zlfHdEAt5nl5U9BbE6TB1QZ+oIEkoFINIcmqFh2JExizR9mhCO88jMf0dtdJPatdNRFXd5eaw+3efFcwlIwAW7BlxrTvixbxwwO6AeNlnI000JmkC6lImcW4NcsQoEc+iTokFc
 y2LZBtlE
 PAn/iI5fGMWhODUysmrAkw0NyxFYKai6urTQLtuPmR8EATHXdg6BXftiAf2K4NR8snziqe5gg3pmCHDO2055AU5A+aX8pQwi6PEUuzBYZq0Jvn/HUjIiLnUbOx+Voa4U295YBJw1WNfwj/k5KBjRE9RHlgavzp/lADeTGv40m7KFEFeB+9/+OtiLEC81JwlicPZkT4beu1u4gDgcuUWl26TloaBvho63yYzxyYcwybYglBl7jmwt3srrx4A+0doWq891ZB+3qj/2IunCoYzEmyTTK7PabmPda4pc4/a8QJZgZ7bngh63SfLwz1kVpTWi4Q83Pgm5J/fw1Ose5DFn+LUTfdzZ8g0dMT+4ytN2wil2jzvI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 27, 2026 at 11:55:12PM -0700, Andrew Morton wrote:
> On Sat,  6 Jun 2026 05:49:55 +0200 Oscar Salvador <osalvador@suse.de> wrote:
>
> > A regression was reported on AMD 15h Family for hugetlb mappings when 'align_va_addr'
> > is set [1].
>
> It would be helpful to say right here that this regression results in a
> runtime BUG().  Helps get attention ;)
>
> > Historically, for hugetlb mappings we always ignored 'align_offset' in get_unmapped_area
> > functions, but after commit 7bd3f1e1a9ae ("mm: make hugetlb mappings go through
> > mm_get_unmapped_area_vmflags") that was no longer the case for x86.
> >
> > While we could fix that by work it around in x86 code, the truth is that the current
> > functioning of hugetlb mappings with get_unmapped_area functions is a bit clumsy, and
> > we can do better.
> > This patchset aims at two things:
> >
> > 1) Fix regression reported in [1]
> > 2) Stop special-casing hugetlb mappings in get_unmapped_area functions
>
> OK, so the offending commit was about 1.5 years ago.
>
> Do we want to fix -stable kernels?  If so, can we start out with
> something minimal for backporting?  And narrow down its Fixes:?
>
> The series was sent at an awkward time in the -rc cycle, which perhaps
> explains the lack of feedback.  I suggest a refresh/retest/resend to
> help bring people up to speed.

Yes please rebase + resend :)

>
> Sashiko has quite a lot to say - I hope some of it is useful?
> 	https://sashiko.dev/#/patchset/20260606035003.529685-1-osalvador@suse.de
>

Cheers, Lorenzo

