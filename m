Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02865CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 11:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C2656B0088; Thu, 21 May 2026 07:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573446B008A; Thu, 21 May 2026 07:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4890B6B008C; Thu, 21 May 2026 07:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2FE6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:33:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDE2E140621
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:33:13 +0000 (UTC)
X-FDA: 84791215866.15.D553D73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 580A114000F
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:33:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y2i+qr0I;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779363192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+EoXkJOHHaMKKCSNNSB1HDpDEcGyHnosLWxzIMLQDk=;
	b=k2wVGi4A6EDvtG15j3FXebTBccMrCHeZd6omwI8NXF93KJIgZnYdaSeDF+HmkkPjV3CDpi
	G44hhF20dEsSjPGPahdLSqIA2GQjbswVgZqLMKOERBpBl+tJdskUkod5jugINQsZ0VFNLo
	tKy6tnqkisl4zjhlFxAFIT6Ikd5KO/c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779363192; a=rsa-sha256;
	cv=none;
	b=pSnWvSQWCOMMPP6tDIwIs1PiB4Ah1NBnkSJu3x0CczrQuJFKT2MUUU/PnFkFJfr/XawGz9
	S6O1p2rFiPUNSH/BtE+nISdCKFPoobXsZ4TSrgz+UaOG+K2XgsHqb/R9nHYBGR4SU0dCZW
	MEcGV+I203qzD/i52tAa9qSztQDnm68=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y2i+qr0I;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB28860220;
	Thu, 21 May 2026 11:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706261F000E9;
	Thu, 21 May 2026 11:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779363191;
	bh=l+EoXkJOHHaMKKCSNNSB1HDpDEcGyHnosLWxzIMLQDk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y2i+qr0IFNR9/uegvvo7AbfD9Oarz3B9H8p6zfxJGzUAAqZzObOfSM2BZnf57qqBX
	 HoOjNKOtqiWqoX67EKvVQaSB0Ia3hipJvcxR0DxASYaKbjxetBC/9lv+UEGWGm0u0J
	 QuPOkmXLjqQ504QovaC7JfqQBQ1GrbFuWl+Aenf7srOqM4tTYesj1FHPo41OuU0LVD
	 ffbdDP52nLULIySYUXjHw4Y9lTO7my4eUepC6Zl4dAZjZ5ecAk8ChKC7YtQfC0MOyI
	 CeGeYnoBZQ7ldi4QCvqphJMs9lz6m33rCDXLcl4ONUgZ5CMYdj7AKmF86I9YRaVvgk
	 7w0G3OY0Yinsg==
Date: Thu, 21 May 2026 12:33:05 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>, 
	Yury Norov <yury.norov@gmail.com>, David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/vdso: make offset_in_page() usable without
 linux/mm.h
Message-ID: <ag7tOVIswaXnCIFV@lucifer>
References: <20260521090655.160282-4-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521090655.160282-4-thorsten.blum@linux.dev>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 580A114000F
X-Rspam-User: 
X-Stat-Signature: 4w95opommj9rn31coqsgw4rgq76sstnh
X-HE-Tag: 1779363192-929792
X-HE-Meta: U2FsdGVkX1+cOgmIRp2GsR+4PEIx98KbYLbKmbTbjAXpkXWOwYLwAlWuRqZwQURsfIaP2ykHTIuvCykj36XzC8dg5enzW2GuCSWgU24FFG8xB0hfGorKlTaLHNFyZS/tGHOuZpc9wnCdsk0jdwTB8LUJxYBJZqcFsPEUJA1wZzLh6YSgBIuNvDOGmhcxHCsWJChijIxMXyXVx6ZLQxMrkMu4j87UokVQThFAlNv5GtW0LNTLImBB1lgDYYQHMG6CCLP0Btx1RgYJ2NG/kRSomf05an5iNYz5ejASUxwfdzcdgq4LAtPRrYqJoi7vE6FwFp6j3ntpXG1rEmqCAsLe4hasqBOvZuqBEnNQI/Fncv63sFBIFLW7VuuqsuVnZJZepfQ7h5YgJzEBqLo6CjxxAZUZbrTeVHWgw4l+HTOLw+S2qThgPuCmetvcqac7DvKeuQN3xJF5/RDLTS8ZPnPu/HsImkT6LluO84tD4HTrbjB/KF0fu0GewvIjliDrUpsiXZzkrlkxyeLPFcf97su9NBvsfN23Uw5F421iv62s793NUcGQqrBDrpiSGQBffpjbEEdKem68QXU5nQJhUR6vJuaWzgVVFsna+QwqJ0vCaXQaQ45LLL+bR6IXW0uqhOdHrfYYEu2T0r1lTmhqmIn3EDCf9MFu5pbRUoiWISDHAdm2UwLpVeXDggvvrdHKhqBtPCRSqv41f2NYEHIFAaF7vJYQ7egvoiKgwhPv8R2mbAbh9vE5QcQaOp5ojVHHq1X6ROChJ/BHD51E1keWgSFnL8hdixRlhOhE0/+uQwr2Qs5I0vWpSo73LATcAoNcMAgjBnrl1bPdeHvih1+hk7MhigAm2y7RUNw5KRbKNIiFainJZ8fAjT5STa0hrc8OK83kdjosP3RRTJLEo+fJnuKST5LeELI7051VVFrNfJyvDE+mgQYuCnTU8NP2cwQygKSRD2VhIbIb4blDWCPqKdA
 VqlpXROr
 BLQSWrs+a47IhRP9f+qhK36wVtfiJ+ixGOVUhmgHgfUqmY4eZuNt3ok5g+cwkgBAiIvNJ/OLbUJq+HdG1cdIeOA8dymtKLslrHZZArpNKg8wy6XzrhKlI1Bfb1jbUXZ55ds0dtOPRrRNN+Q12ji5yFtX4Ov6/MA1wLNcOHR4GqVaI4t7VKt6aN66fm2dkLJ0cJvm5QF6RH1IQz2hCS8seE4aVqVfr/BIVD1/kYGFMJW7sQnhNITf1puTTHdPM6kpJZydtQHNAsNCNlauCEKbCRqhOXGZk6Z0JnDAdaXSBBQVCQwBmDa/IB/twYwIEggJ0IQ+qy5fGuMeBvA8WqnP6a4BCzkaAlOKkK07FK7usnwVhrPqGvNX8LL73jqy5OxNh39KbFktC3dzsy4QTUA2LrckZ6RmdmvRdmKs1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 11:06:56AM +0200, Thorsten Blum wrote:
> offset_in_page() is a small page-arithmetic helper that has been around
> for 20+ years. However, page-offset calculations are still open-coded in
> many places and in different ways:
>
> 	(unsigned long)p & ~PAGE_MASK
> 	(unsigned long)p & (PAGE_SIZE - 1)
> 	(long)p & (PAGE_SIZE - 1)
> 	...
>
> Some of these open-coded instances may be due to offset_in_page() being
> buried 3000+ lines into linux/mm.h; others may have avoided including
> linux/mm.h, which is a large header that pulls in many others.

This is good but I think you're still missing the 'why' here (as to why files
don't import mm.h, and thus what this series addreses), which presumably, is
compile time.

>
> Patch 1 moves offset_in_page() from linux/mm.h to vdso/page.h, which
> keeps the helper with other low-level page definitions and allows users
> that only need offset_in_page() to avoid including linux/mm.h.
>
> Patch 2 shows a concrete example where including vdso/page.h is
> sufficient and including the large linux/mm.h would be unnecessary.
>
> Existing users of offset_in_page() do not need to change because patch 1
> also includes vdso/page.h from linux/mm.h.
>
> This series is based on akpm/mm.git mm-nonmm-unstable commit
> d067a83c8063 ("string: use min in sized_strscpy"), which is also in
> linux-next.
>
> Changes in v2:
> - Add a cover letter and drop the bytes_to_page_end() helper
> - Move offset_in_page() to vdso/page.h as suggested by David and Lorenzo
> - Use offset_in_page() in lib/string.c as an example since
>   bitmap_print_to_pagebuf() in lib/bitmap-str.c is being removed [1]
> - v1: https://lore.kernel.org/lkml/20260517123428.1181981-4-thorsten.blum@linux.dev/
>
> [1] https://lore.kernel.org/lkml/20260519163058.953690-3-ynorov@nvidia.com/
> ---
> Thorsten Blum (2):
>   vdso: move offset_in_page() from linux/mm.h to vdso/page.h
>   string: use offset_in_page() in sized_strscpy()
>
>  include/linux/mm.h  | 2 +-
>  include/vdso/page.h | 2 ++
>  lib/string.c        | 3 ++-
>  3 files changed, 5 insertions(+), 2 deletions(-)
>
>
> base-commit: d067a83c8063d1bdcbd9af8e1326d846f85138b8

