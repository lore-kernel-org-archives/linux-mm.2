Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BB83EA7948
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 22:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0E616B008A; Wed,  4 Feb 2026 17:31:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBBB76B0092; Wed,  4 Feb 2026 17:31:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABAA36B0093; Wed,  4 Feb 2026 17:31:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9814E6B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:31:20 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3A332C1865
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:31:20 +0000 (UTC)
X-FDA: 84408221520.08.B91D6C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id AC6FE1C0009
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:31:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bkZWq0tF;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770244278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T23CRuOPDQJwu47oMVvhQWdbFgk6N7dbhDlWZMGtmoo=;
	b=bUgArPO1BQE6sqzxjjfs3XWU5GNjCjty+vktzg9x831VIcSiVPM/o6BeBP/4AyG1CgWfmT
	OvVpJCdCpRPXsf/Nnr7KY0NxFVR1j+RVpL/0MThxqbQVpvrBRNtSao91iOPxCrJrKugdxX
	rhWfOc8KYTRw8IA9uV+Z/3mJG3v1pPc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bkZWq0tF;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770244278; a=rsa-sha256;
	cv=none;
	b=XmwH408lIc5fFc/oYUu5ZOENtC+crJEtlJzFNiGMR8ubIdYVHxGAyNjDOLvyQtI2gzQJ/S
	yqNbko/IrDDh7aMS8qzudIoKIXajr/mmN/TfecJVB3dJxkqCAGZGMfuZ+ndamjJmpSxNvR
	Tn++d3zTkq02w+Y/qn0vs8KcFCafsjU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D187060054;
	Wed,  4 Feb 2026 22:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D8EC4CEF7;
	Wed,  4 Feb 2026 22:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770244277;
	bh=il7aJ3eIWZeVJd7eT+iGQ2haRY0GHhIg8kpdTR7XNp8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bkZWq0tFfzkTtKtN9z61RnYCdolEQZCrTfV/oYrh/sDwDq0gdnXdY1AgNDzqUlrg0
	 AR3I/AtvQpwKFs3KFEzCcHdDYlLZc5FLAhWHu0DCrlhNqY5jPKTOcNb+shpL6YHDUR
	 Ql8O4/bWbC6TEorw5hpeY7Gd5/JAKNbLuI8mGsbg=
Date: Wed, 4 Feb 2026 14:31:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
 mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com, kernel test robot
 <lkp@intel.com>
Subject: Re: [PATCH v2] mm: folio_zero_user: open code range computation in
 folio_zero_user()
Message-Id: <20260204143116.968730e769500aea281809bb@linux-foundation.org>
In-Reply-To: <9206a7c4-bf88-4138-b8af-961625a82439@kernel.org>
References: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
	<20260128185943.2397128-1-ankur.a.arora@oracle.com>
	<9206a7c4-bf88-4138-b8af-961625a82439@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AC6FE1C0009
X-Stat-Signature: zig4napqhjow588xnxadwqb98wyhc66t
X-Rspam-User: 
X-HE-Tag: 1770244278-581205
X-HE-Meta: U2FsdGVkX18kZT0Y5iGl+OZnPcyFEVoMGp9gRUTbEkYcwHJ9KBJW6JJKvaoUmAZ1W7QGULEe2SEC7wIQQG5Gfoc8eHdj5VW+vvGWuHfGdDbskNRfL7sczyEE/G0F013oliks1n53rNDcEvq+LtdpWngTREPqDUpw3UO5yruBFNp+WtLLd1youzh4oosdboHTTXI6lV+OhXQz5uGrrfUBEBIm0HELTyt2ooVcFH2qrsvcf1UGA/8uqioUP5ACb6fAPeI14qVskBYTis3N38LQKWSeorUrsB9bvcgOZLd/iPxo/p7g3xmKCtsUN6RVYviWZA82SquqVVXt8wboV+t9I4tFGY7jiNrTULB11KfuRbaAQu/2kiBtIGONRR2pdxW5iJf7UoUaSwq9VeTQnw2qbc68WCrlU4t94aTsAj9zoCpyGpAtWhx3QqNT1XsS73pZpHZzkggIZVLfQ8w0sTKfPTXtTo0uYYVW38vBlR3QaL3GPviVGsZm6lM+D9runAti4l/JRzHRot9vrhLYX3jwV6mPhJ0UyOETqKeTZaVWOccgQscAnkuSkvsYSedOQHFiWW6t72YAeTC/ZCHU6T8TfausSQ/gqGYo9bPCcEXQ8ffFl+9u9OgTDc9qIHy6fJMm2XhpMpxjgn1FDBn8/Gl5R0MuPLA125pGGy1mBtvMbqFQhjRnsJvRQBsQ9XEs3jnuT16noKkKd1+gH4R5u/1jWXTwTfQnZTKUOFbq8uFIL6FniJdHSHUGNlRbNdd416ndP7uxUXy8pYMBBINf84tk9bRV/xlXU8e912A/aQyYrOMeRVN0pFWx4S1+SduGLfgjvqcRD8qR+zHNshKYSBOhbuqLzpvXuPQ46Mn6XkT9RU9pOFACwkBVDmr7IkP1GUG/5wvnCUQfrMEwM1s0y2UCdH90jPG7J6g+NUCFWkN5Y7bOs3taE54Fd0eq1impxmhthaOZm9VD3t/DX1vyLM+
 zskx9VHP
 3IlVI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 4 Feb 2026 22:01:42 +0100 "David Hildenbrand (arm)" <david@kernel.org> wrote:

> > As David pointed out, the previous open coded version makes a few
> > unnecessary changes. Could you queue this one instead?
> > 
> 
> I'm late, maybe this is already upstream.

It's in mm-unstable.  The second round of MM upstreaming is two weeks hence.

> >   
> >   	/* Region to the left of the fault */
> > -	r[1] = DEFINE_RANGE(pg.start,
> > -			    clamp_t(s64, r[2].start - 1, pg.start - 1, r[2].start));
> > +	r[1] = DEFINE_RANGE(pg.start, r[2].start - 1);
> >   
> >   	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
> > -	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end + 1, r[2].end, pg.end + 1),
> > -			    pg.end);
> > +	r[0] = DEFINE_RANGE(r[2].end + 1, pg.end);
> 
> TBH, without the clamp that looks much more readable here.

me too.

> >   
> >   	for (i = 0; i < ARRAY_SIZE(r); i++) {
> >   		const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
> > -		const unsigned int nr_pages = range_len(&r[i]);
> > +		const long nr_pages = (long)range_len(&r[i]);
> >   		struct page *page = folio_page(folio, r[i].start);
> >   
> >   		if (nr_pages > 0)
> > -			clear_contig_highpages(page, addr, nr_pages);
> > +			clear_contig_highpages(page, addr, (unsigned int)nr_pages);
> 
> Is that cast really required?

Seems not.  The types for nr_pages are a bit chaotic - u64->long->uint.

