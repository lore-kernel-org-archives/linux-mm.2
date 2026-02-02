Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF99AE7316F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 13:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 126866B00B3; Mon,  2 Feb 2026 08:42:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DE836B00B4; Mon,  2 Feb 2026 08:42:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 009B86B00B5; Mon,  2 Feb 2026 08:42:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E345E6B00B3
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 08:42:42 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B0EEC02E3
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:42:42 +0000 (UTC)
X-FDA: 84399631764.03.276358E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id D0C33140006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:42:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cML3Fvhx;
	spf=none (imf26.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770039760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYBvBVbQkUIJwBmMc3AmsjMQCAxLks2LNy5Ykb6Sbho=;
	b=f6xDHOWJxOVB2TD7yNChUECKd14uGkY/DyM7PtGk/KBUAVsuTU/f6huQYzhxKqMkfAxlkV
	Vi5llFd6Vnm6IHa9LienHCQVlleU721G9UY2dpsHJuBqciewoaZ7hTsonQRJuCm+g/I+fr
	QicAnCaLxqmtvSDHkFPtSoe07RySpFM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cML3Fvhx;
	spf=none (imf26.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770039760; a=rsa-sha256;
	cv=none;
	b=mPyIgWc2KVoZMCCX8L0d4/5WPYBRmeL+tNY07wE55Exnl5P3USS7uLhdPtkWuIEDC9FARZ
	LMhZsfNS3AReaXYCxT4PT3iDMfPpoTiWrh561n6Cxn+bBwm52Ku5g/YuJZixR7oDZpG6a5
	Yftj7wKhflLdt0IB3sb4iFCfLAbRf1g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FYBvBVbQkUIJwBmMc3AmsjMQCAxLks2LNy5Ykb6Sbho=; b=cML3FvhxJ1RsP4ckPgCxzFMSSr
	9X3dZB/+mAIDMaVtX8ICs5bLtkwwc0zKhd8MTQKfuLTvwhz+EGXgnS53RvFh2k6KEDFqkrKNAMm6M
	Juo4Yb1Tr/4Sgit3UdkfczDLuNCxto9d2UbIUdz8V2s4dzvLQE+wzTyGsMF9GYawGWhFYGr/Y0upH
	RSMOH379lYU0kjXrDJKiwIJvPJg+TtTISWh7WOVQmjW4HKcBUMNtwepXv/Y3veDlKrdjnTttUCSid
	ZznXVmu493xJXmiHSYKXiZ4a/7XVyfCfcW3J2Z9BmrABABfgFvF3w+Z3AFCvIUhLqTdukfLSfBwTU
	3bSohcPQ==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmuCI-0000000GYdY-0git;
	Mon, 02 Feb 2026 13:42:34 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A9BFF3008E2; Mon, 02 Feb 2026 14:42:33 +0100 (CET)
Date: Mon, 2 Feb 2026 14:42:33 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, shy828301@gmail.com,
	riel@surriel.com, jannh@google.com, jgross@suse.com,
	seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ioworker0@gmail.com
Subject: Re: [PATCH v4 1/3] mm: use targeted IPIs for TLB sync with lockless
 page table walkers
Message-ID: <20260202134233.GG1395266@noisy.programming.kicks-ass.net>
References: <20260202074557.16544-1-lance.yang@linux.dev>
 <20260202074557.16544-2-lance.yang@linux.dev>
 <20260202094245.GD2995752@noisy.programming.kicks-ass.net>
 <0f44dfb7-fce3-44c1-ab25-b013ba18a59b@linux.dev>
 <20260202125146.GC1395266@noisy.programming.kicks-ass.net>
 <a79a6421-ca97-4a3f-8ec3-55e88da1ec83@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a79a6421-ca97-4a3f-8ec3-55e88da1ec83@linux.dev>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D0C33140006
X-Stat-Signature: 5r14bo34u6gt9uthbx6ukt89upzhzu5x
X-Rspam-User: 
X-HE-Tag: 1770039760-337536
X-HE-Meta: U2FsdGVkX18hOfiViWR4NuVHG8/RjdloMxTOZ15vHO1s7RJ/pNfb/+wZhM/luUMtqq+ltvIoh2xIvmfCBSDyutKdlwToy7x0A4XezyxBr/Oei0X7vo6qVDNLIYSFdY93snYpMna9I1c2C7aF9PiUTFkkmIGQD+en9FZvlGmynVqD0MJS17o74GR2VuF/E5tWNLprd8/5XkgKB1wbeLaVjxK64sLWYVE/EDeygDYjwo2702wDNB0kKBzixJ0VBOPRNDEHbMKt42ppP0dO8SwlK2mlfPM7q42FyZIQJzkIaCGJdmMX9JIh4GYXrgL18VtCG9AevSMXgl/+THyuOxclO/Zo3Mj0qw492d7s4ctoIzv6XeD8+SdT1Oe0WuFvbkAKhZhSDq8Oy0rTaBZgeGNiDP94/W+Ec8urrbxR8GdSeR0a5zcxqQgaAUDmvSWr6XzJeq/BlQizeBK9ZxEdcbEHjVVZKZoz+tmxWJ5wuv+33ATd7sk3+QDTk/aEjHjSY/+2TsLSA0U1MZ943zFZ9Tv7x3VEw5nrECZt6f5/kTbvNzK078+2Qm9l0GwgazBLfTIzLEJvLIhr/QXmvHuAx4V4zcGlU/mE90MLN68IPlmzVvuwbHj0SBYWyWkoxRUC5XKPvZ2xfHu+b4FBTmwfxOx4ppPDKgkrRDhesyIAVk9eezpv4fICYX8RVNjk7Fpe2yQBf495+9kilBY3NIdIN9R/9yEgmR0AAnfKQysdsieZwRWzdZSsHUwhekM6+r+pAVbzi7D9rmbLjuHip/hQCmXJx3B7MwyG3RXOgJiKxwsOXurGvAVxJGVCXhrhDFCAXB14OOjYrwVZUnF59hAzAUwEjOXpBTYLUHFeLn1cxVCmEcG7Rri0AoQ5pXrNsa30TkPyu2PxM/YVKdVfxJvPOX/r7+qpO566nLXjEDslvZPCqWrMV2gh3Zqt3y7ZmHazZz86YZfRj6BfzEB3JQXkOdQ
 aWz/wqJa
 U+SgWg1Lc9H8UO4mrQB9+opDg/isCCD8wzmFfCmZsIFlucYCyOun2GowCTDhFh+lbSyyZdwXodtsqCVc0KY9dnrfhGqXktdfbRh9mkjjjRh0d4NidJ3+OVyJOx1spfrbAMahCl7RtJ6eoVGDGyZg8yJF7DKbxDlkysU74bB+ONDcoQKosES5Em8XW3dif+Geyr6BY8NLuMTuTajTIZ2k0kexnsfKRBXO8jlLrmb43AqDwyyM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 09:23:07PM +0800, Lance Yang wrote:

> Hmm... we need MB rather than RMB on the sync side. Is that correct?
> 
> Walker:
> [W]active_lockless_pt_walk_mm = mm -> MB -> [L]page-tables
> 
> Sync:
> [W]page-tables -> MB -> [L]active_lockless_pt_walk_mm
> 

This can work -- but only if the walker and sync touch the same
page-table address.

Now, typically I would imagine they both share the p4d/pud address at
the very least, right?


