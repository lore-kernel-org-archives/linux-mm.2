Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46BB910854B3
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 22:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A4176B0088; Sat, 14 Mar 2026 18:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55B3C6B0089; Sat, 14 Mar 2026 18:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1716B008A; Sat, 14 Mar 2026 18:40:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3BFBC6B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 18:40:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D04B01A0757
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 22:40:46 +0000 (UTC)
X-FDA: 84546139692.30.DD87909
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1E1151A0002
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 22:40:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iynWM0D4;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773528045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d5CXTvukVwgG2im1OefMk16lV7ILOSF0EjP2wHKuGAU=;
	b=V0Lhmwf7t0+rCeiE/OeaagT9br6Ypf6RFhULY3qnXbKRCqioqPazb38LhDg0nhG2pjojcO
	Nj3jwdjfylCUL4yH6Ywu+Rg68/krVefZLZWTg2DAWBbpjCrHb8FQvFxbWdvRr3IerniT6v
	pH+ZKrZvnba3kiKG5uKl6S5vgJ8mIqA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iynWM0D4;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773528045; a=rsa-sha256;
	cv=none;
	b=6pKSVtgVLkwySkTmDmhKWgqE/tLdi2h+HTuAymgWWdPjFp3BqxkCBYK2sIIol3AoEPrjLj
	+f84sXDN8b7UqDhYNSLsLU2auHItA726Y2+I5JUM4Riu4O3p2mVM+QNiRqjYKHWEu/8Dhs
	GvfwqiqEAXT0mjM8ef9JcPEWasjRIes=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 248FB436A0;
	Sat, 14 Mar 2026 22:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A489C116C6;
	Sat, 14 Mar 2026 22:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773528044;
	bh=sV9PTCvMW2uwYIYWoDT7NCvHOX9y6njZbgMbRie3eZw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iynWM0D4SUypA8wlnsvN9Nb8wXTGYvUrZyHq3YXnX4a0GasUjitdrA6P4X/aXdVlJ
	 Uty182SdFlDkGEHq8oVt4FYAu0vfPMp+tZKOE9iUJCLbHXMD0JofkLOyoRWljN8aUH
	 HmTETDXB607mjyh8boIhMKHTnk5lUM6C/K5yNkVA=
Date: Sat, 14 Mar 2026 15:40:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: SeongJae Park <sj@kernel.org>, npache@redhat.com, david@kernel.org,
 ziy@nvidia.com, willy@infradead.org, linux-mm@kvack.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, hannes@cmpxchg.org,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 richard.weiyang@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm: migrate: requeue destination folio on deferred
 split queue
Message-Id: <20260314154042.327ba957b1a8c10f64ae0169@linux-foundation.org>
In-Reply-To: <b3805934-fb0c-4834-85ea-964ce006050e@linux.dev>
References: <20260312104723.1351321-1-usama.arif@linux.dev>
	<20260313001630.80081-1-sj@kernel.org>
	<20260312175241.01b876f3b325264f43312d79@linux-foundation.org>
	<b3805934-fb0c-4834-85ea-964ce006050e@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1E1151A0002
X-Rspamd-Server: rspam07
X-Stat-Signature: p5kz1imujhmb89e5cw1jrfzrx9u3gssm
X-Rspam-User: 
X-HE-Tag: 1773528044-826654
X-HE-Meta: U2FsdGVkX180nnEYsyIauSvxPS5716VPCau0nL0tR/sUIaqQQ4QcxSSD8fEOzStPjU/mXQU5D2qec7thr/q88rcXvu6sUvvuztrFjzy9bN8ODIV+ao40W7IRxKKbPLgetdopKLfGtgQKpLyVFBm4NrmpXxyrgTX2zXLUsmn6Stkwnt/oIeX6cafH14CEjuWgrXMC0gY0llp4qXbP5RyDG5OWVM7V5weQfQVZo4pYVVMD8URT4Z1yb5Aio+1dBH8cLPHKx0ugTy3xQmNQFbb9Orgo4gYirLSy/0193XRdpKemqYH5b2zVpuaXc04lUpEsyYUT4wQLa1a+OtSspajdY6mbEnSZZdIIUP4HRkkb+MYZ88Zt7V2FccKv2XbUGPOXQWproDMvyCvvjFvZSWCrOtFhNH91b1Q0FQHi+kWFfLFwI6IsJ/w1qzdzEHbqch/3NLjQIss7DPdPinA0RxApiXywI0217TDvE1EATE48dASfN9t4MW7tf1W8wk9gpFBCGL+JtlDtWgKOs5DOy83zVuNVhp4blLU0mC9jQaU9LLFJWN96PI5LfgceLjr/buuAz64NJMHxRJAIe4zZExgw2IcM70fnglPFOZaN8QqoskWzeddMRF7QzZFEtOnCszEeDz8KReVnnGI8RAVWusWmbpIxYrLWj7eSY66XEN69kNcTRGJyzTFpsST0SyNHo9VFF3yLKiwk9hBziUIAAIOGp8vrCjk9kCjpWcEdStOwxWlHbUo5njftamM4a+MKxvQZyi/DFmDGcEJR+MmzsktafhR8Y7qlCLThOZ5iP43Y22p7ogX8EZ5WYlqtLr1Xru1+s+4Q9Xzfl2vDBg4yUUzVWljjSzcipUi4H6sVvmRYv12nwm2qlQ9dtu8iPngbAubbzc5pNAErgo+/mSz+nDTiV0aKJ7DGH16LV1V/44bucnjeC+Ih8MPCaaJ7QsOKO7bZibYMmlfATpYhkk26MDC
 mYmWYTSD
 Ky4kYqozwFRp/Wk3DYaWbE9TyeyMhDokbboE0uNJEmg9z28rZ+7beO/Rb46C+6ibobIrvuiSZtR7F12slTx2uQncrIX2pDqOwZB9ldordGzFh+R4MDEQASXuNvLnlR55m/Df1X3+lGrDcvXZEDBrzl/ebRR42jAT0uUIuqpI7AMTgRSWmJGhEwVVOVUNISfd/j/cScyQEveZ6mJFeQpR8CpwaL6OMmEEU2QHmCJA35cgDES8hhD2Kg4DCowysYVZPzZ5WxkCUF3qfW9Md6bf1REmpT6gIYdv+gfAqbg/vjErbgvMWrvPfnlUO9R/LbqnH21LbuYx8wF8403gOtGVkOZx61GL2WIp3zq9G226a3XjonN+88tJpJ8AqiGIyDl6QfCruEjcbAgMz7rlzlJe1peOSqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 13:40:29 +0300 Usama Arif <usama.arif@linux.dev> wrote:

> 
> 
> On 13/03/2026 03:52, Andrew Morton wrote:
> > On Thu, 12 Mar 2026 17:16:30 -0700 SeongJae Park <sj@kernel.org> wrote:
> > 
> >>> By the time migrate_folio_move() runs, partially mapped folios without a
> >>> pin have already been split by migrate_pages_batch().  So only two cases
> >>> remain on the deferred list at this point:
> >>>   1. Partially mapped folios with a pin (split failed).
> >>>   2. Fully mapped but potentially underused folios.
> >>> The recorded partially_mapped state is forwarded to deferred_split_folio()
> >>> so that the destination folio is correctly re-queued in both cases.
> >>>
> >>> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
> >>> Fixes: dafff3f4c850 ("mm: split underused THPs")
> >>
> >> Seems the commit is merged in 6.12.  And I assume the user impact on
> >> THP-shrinker enabled systems is visible.  If so, should we Cc stable@ ?
> > 
> > I think the user impact should be visible to backport, but the
> > changelog is elusive on details?
> > 
> 
> 
> The original patches added THPs to deferred_list at fault/collapse, they
> got removed but not added back to the list after migration.
> This patch adds them to the deferred_list on migration. The user would
> not expect the THPs to get removed from deferred_list on migration, so
> this fixes user expectations.

Maybe users just won't notice?

If we can't identify any benefit to userspace then I don't think this
patch meets the criteria for backporting.

> I have CC-ed stable@vger.kernel.org to this email. Should I resend the patch
> with CC stable in commit message?

That's OK, I update changelogs.  A lot.

