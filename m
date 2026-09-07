Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92D29C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66576B009D; Mon,  7 Sep 2026 08:40:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17556B00A4; Mon,  7 Sep 2026 08:40:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92DCF6B00A5; Mon,  7 Sep 2026 08:40:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A5556B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:40:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EAE7A160150
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:40:07 +0000 (UTC)
X-FDA: 85186923654.29.FD38222
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id B742A10000F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:40:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tvVmb+Po;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VoRH8w3x;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UBDLdDXn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vX0CPsyR;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788784806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pk4FrYT7aiylp0H0naPLYagevGfRK76pHeKCW/5mVIQ=;
	b=O52E8uMROm1GVv/+84IfseoOqO7TXZmcNgHQqoNrrr5chXjtKBLxb/UpolmzkbJ/VN6EQ3
	/H5MEIu9iThrzz/poOW2zcIWXu7xVob39BvzzzbF4tE4wxIj8xI01RnVfD82k7iBPluwOC
	NIdmQin6C8SqeCjcLzALZstS853gZx4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788784806;
	b=fbjoTZ8iM+DSahXEjCY87mpARfPeY4AYGOzTMQbe3AbYbk4T89HftzB17DK1cG1wDyGmp6
	UQVAuGCoWQmbM0fTETRD92toQ3cnAPBfYWW67JBuJBeFqRKdKAvGW+kEj2kmV1FlEK3DRQ
	zzBRM1YszaV+7+zEOmoy+DO1lX/d9PQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tvVmb+Po;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VoRH8w3x;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UBDLdDXn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vX0CPsyR;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 21C901F747;
	Mon,  7 Sep 2026 12:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pk4FrYT7aiylp0H0naPLYagevGfRK76pHeKCW/5mVIQ=;
	b=tvVmb+Pok2ZhZ4+p0aGso8BiJvkq8RyqMLDDtYppcpA6YsUEkmV8jmcWd8Op9MMyHKMhZF
	vQheBW3XOHbs+s79IbEZPcDxnhd7yveWPO5zr1s8MVEg2vlK+3MEMIMF0Am9JZbmk4miRd
	2eLodhcWkh2j6Hokv98tyKW3ELgrB38=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784800;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pk4FrYT7aiylp0H0naPLYagevGfRK76pHeKCW/5mVIQ=;
	b=VoRH8w3xgCULktwu9+LloVbLO/K2QUCTYYnqFp46So2N7hPodItUGH2vGbyRy13a3gMLyb
	6GkbSUHiN/8CS2AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788784796; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pk4FrYT7aiylp0H0naPLYagevGfRK76pHeKCW/5mVIQ=;
	b=UBDLdDXntRx+yaMxoHPtQCr7ZV+phbQ/P7z/8A4lJfCyPQntpu2gC8OpCND5BCetuE7fbE
	nhBv89knvHbEWq5SxIU3VaLFpo0Vyn2KZbq6WeE5WOArWXAOdGl2j8WbBz2aC8+meQ7fps
	7zPFHxcoWKwDkR64wJmRLEnBfvkPNvY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788784796;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pk4FrYT7aiylp0H0naPLYagevGfRK76pHeKCW/5mVIQ=;
	b=vX0CPsyRcLAfrUzNUGKte9vRDXHgaRCHmkiQrggfGSaviyRxMezYxRrb5+Z6QVQyV4MGLy
	lbt1TsnpeSFg0zAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F2E01339B;
	Mon,  7 Sep 2026 12:39:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VtrLD5uwnmpZOgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 07 Sep 2026 12:39:55 +0000
Date: Mon, 7 Sep 2026 13:39:53 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Mike Kaplinskiy <mike@recall.ai>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Subject: Re: [PATCH] mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on
 MADV_WILLNEED
Message-ID: <ap6wMOvQ1IID_koO@pedro-suse.tail5790ac.ts.net>
References: <20260904-madv-will-need-map-private-v1-1-6b83cc99fcff@kernel.org>
 <apriM1q4GzAgP7JQ@pedro-suse.tail5790ac.ts.net>
 <aprjOxDy3JCPb2oa@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aprjOxDy3JCPb2oa@gremlin>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B742A10000F
X-Stat-Signature: tb5mjeg1dhkkd53e36mfz5butoqbn77s
X-HE-Tag: 1788784805-665549
X-HE-Meta: U2FsdGVkX1+XCHqosGBBLMceiMpPSDmfT6tV8l62Mc2LH9yJF4tjMrY7pCJs9DYawLaL8YgTsdXxLm3CIVDGCrnAP+7G/pZfpakFQK4TMPVD0UiZWW7jXSJpb/CrdU08RbG+F075gu2uSIqq4D97GOHglS1dbZsgSYtzNCfAPWkufStq6ADKuXN+mIicBFhug1BTynReJe2sF2T14AzG8Y8XrlKY/qg2IJHvDPJRA1mr9lV/+OmTdqe19BsPS+Fkhm7hhRRjIyeHlUTWi+uNemJ6DcIXbGOd0/ySWBNPkokwnTy1YOJ+81UwyrngF6LJxuol20UgyVoxYlSmzjJmluP7nBb4uMZwroWVjqQSzN2U+FDBmWXMw9PuMp/w6Rs/NM0EyuNle6juaMWKjSfUMh6d9oaT9v2nkb4ueuSZzZ9INQP1IT754rVkTeMjVb/pv4aABc6vmbqWSaMQf6Hfrx6NY7m2gWkVRkbntdtDoYS20Ba4UoPoc7TmAYVXyQNL+rNP/oXxoVSJ3SyF02jGldd+Y8jFSrORi0IRd4rPLTU4F2bEWz0fJQB1R/u3HyOPdD6E8AkilVq/tO4b8jtcbH3ou3v+CBItfDMCFoq5sHfroW9rBEfXeY3AhM2z2e7CgS62H56xuSk54MZYsk8aLFqFzMhkyXJg0JtfOEspJ/qxsr/6jHRb+ojqFvI3NOQXfN5wgijwvkqeEFoTR2cGf1GFl7JmCkoCoFUjYQI+ZQ9Uo9hsT1fY0MgEslAhRV9/bcNiGa4X+r4tJLBB1yWk+6dZ90qx7XTph9PdgM4QVyTDZ/vZJfGmY2yX2JMhxtlU4nqwUGOV6v+ZJ6460HUMzZJNA0Ae62xC0tlzFetWYzdj+/75fPNLYReArifeEnIS8FfWPu10ey6YueioshDnSgnyQrgS+qLkoTb8sh1JCnr1Wf3OQrx8O7mLxuOb9gVaYC+hIlr2hrE2kCKasNa
 l8dIe2HJ
 M9ormu6DrqJb+TjpqH6053efENGBRzbSeVhvqhye88BdIR2Umb2k3iubBAJnY/eXjuPzRMFj5cIgOhKUQgXPZs69L4H2LQaQA6gU/k2A2Sr+aI2S7GvdLeqLx9agv6t+/TxWTiFkGrrHMfJo9XqFl9WCbl+vD6+UlFe42daJN72JtWZF02MM4XKVCiy9UbgG49gNhqnV/9uYpwYbZ7TlyC29F0Irnw+7gzDMcfZ84GtHd4CcrjuaGOCOijUyj8uKYWdlmsZaUU8rk1aCP7h/8zprAsIiYyancRBqw/fVi/4GYqiRaDxXMSJaziO69F/fXUvSlTny8s1YwxVnsmOhWKZy8v5SDbia4ix9UGINb/5f+UiY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 05:01:37PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Fri, Sep 04, 2026 at 04:24:59PM +0100, Pedro Falcato wrote:
> > On Fri, Sep 04, 2026 at 04:12:53PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > Currently MADV_WILLNEED treats file-backed and pure anonymous mappings
> > > entirely separately - using POSIX_FADV_WILLNEED (equivalent of a readahead)
> > > for the former and a tree walk and swap in to swap cache for the latter.
> > >
> > > MAP_PRIVATE-file backed mappings straddle the two and currently get treated
> > > as if they were purely file-backed, meaning any swapped out private pages
> > > remain swapped out.
> > >
> > > Resolve the issue by explicitly checking for CoW'd MAP_PRIVATE-file backed
> > > mappings and performing both walks in this case.
> > >
> > > Since the logic checks for vma->anon_vma this means un-CoW'd
> > > MAP_PRIVATE-file backed mappings retain only the single file walk.
> > >
> > > Reported-by: Mike Kaplinskiy <mike@recall.ai>
> > > Closes: https://lore.kernel.org/all/CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com/
> > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > ---
> > >  mm/madvise.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/madvise.c b/mm/madvise.c
> > > index 73c2901b9adb..d0510dd49dde 100644
> > > --- a/mm/madvise.c
> > > +++ b/mm/madvise.c
> > > @@ -297,10 +297,12 @@ static long madvise_willneed(struct madvise_behavior *madv_behavior)
> > >  	loff_t offset;
> > >
> > >  #ifdef CONFIG_SWAP
> > > -	if (!file) {
> > > +	if (!file || (vma_is_cow_mapping(vma) && vma->anon_vma)) {
> >
> > Couldn't this all be simplified to
> >
> > 	if (vma->anon_vma) {
> >
> > ? swapin needs anon pages to have been faulted-in. Non-cow mappings won't
> > have an anon_vma, nor will fully empty anonymous VMAs (and that's fine).
> > Right?
> 
> Hmm good point :)
> 
> Though the
> 
> 	if (!file)
> 		return 0;
> 
> Would have to be outside of the block to avoid an anon unfaulted (nop) from
> being skipped.
> 
> And it's a real improvement to have unfaulted anon skip...
> 
> But I find that version is documenting what's going on a lot less.
> 
> Since both anon and MAP_PRIVATE file-backed are CoW mappings we could just
> reference that.
> 
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

LGTM, thanks!

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

