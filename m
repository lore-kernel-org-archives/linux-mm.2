Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA128C87FCB
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 17:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D25F6B009E; Sat,  9 Aug 2025 13:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27F5D6B009F; Sat,  9 Aug 2025 13:53:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 194DB6B00A0; Sat,  9 Aug 2025 13:53:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 081046B009E
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:53:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 90AE01DA8F1
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 17:53:38 +0000 (UTC)
X-FDA: 83757966516.19.6F653DC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id A7E5B180004
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 17:53:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gpqsAxnB
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754762017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8Q6okkklAaY14XcctlL0AEEZpbd7u+rIv8Yr4uepEE=;
	b=WA5Y1mUVa1gN6ZMUmcjwXEA490JSrVpvJMfC6hDnSD3x31SrHhMAHAx+hYYJM2vpl755XS
	T8Hh1wOp2JTbnwr5y/MUVJ/aA1dCBbRlGwL5IV7/0sCsoW9LebtrhCCVJ0MiLviBNERxsu
	qwQlZk2nZZWzZYpq/ffZr8N6x8jP94c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gpqsAxnB;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754762017; a=rsa-sha256;
	cv=none;
	b=FOUbGYlx3A4c9uaRFrIZXtXbw6Q8q/09l8n5GQE2TM3663Pmr7e7v4Z+DNfJYKiELJa4e2
	cHbEkam5VqgsmHaIUedgzxcg1NyPBNefr/67Adi3N0hMU48N8R6Y1fUdyS4zyQyAQ+NOmI
	cHHQDcut4f3siQaLATnCwPyFM+ej/z8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=P8Q6okkklAaY14XcctlL0AEEZpbd7u+rIv8Yr4uepEE=; b=gpqsAxnB8xdyNstaJEtm7JRXF3
	MVIX8LYpSosquRzL5y0WFAFNME3fv13XtgyzvjTYLfL3hUZq1qjYmIYYIUrYZshM1Nwr5GT3rekSH
	Afl8GCBA2t9PM2wnsUYR+mccdufSJn+8gCV3voifSOwwDa1tvROI9dzzTViTL5sdapHm27eNnjk+1
	4D5zdCSJLIUPZ/lJZOjGhQ/nviVpVmsWZXz502S54oPhJhtJKSgahZ7stHuvCV1PkJyqPzpI7nogH
	QFs26P9Bp5lQedCrOVrxBGY3qlrp39PXJ5yCI4TpIj3k13YoYiyzVPbBqgto+Fcy6rAGttKLetF/s
	2ApzsyYg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uknl4-00000002Qkb-400y;
	Sat, 09 Aug 2025 17:53:30 +0000
Date: Sat, 9 Aug 2025 18:53:30 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Subrata Nath (Nokia)" <subrata.nath@nokia.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: prevent RCU stalls in kswapd by adding cond_resched()
Message-ID: <aJeLGpT9vp7g0lj4@casper.infradead.org>
References: <AM9PR07MB78119166E41E86BE5E7DDCC0882EA@AM9PR07MB7811.eurprd07.prod.outlook.com>
 <aJdkmCP41RhNC9FH@casper.infradead.org>
 <20250809103845.21ca58f0a97c0c1f61c0879c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250809103845.21ca58f0a97c0c1f61c0879c@linux-foundation.org>
X-Stat-Signature: jjf3qsf5w1cbmjrdr997mgri57ti54b1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A7E5B180004
X-Rspam-User: 
X-HE-Tag: 1754762016-706680
X-HE-Meta: U2FsdGVkX18OJDQd92qPYOiZw8fjCWHdjkY+1rFQHCTZLz3uPH/IAPOcGnuZ0njaSBXqWnsF4KHU/M2KZjJv6vsXx0IYqPGPkB9bSQl0cEXtVnPIY5/cKE4QaqyurC2bxpoxJ2Fz/O8f3k7MZR6odFbArlSL9wTwvC8Gn/wN37NMAxbLvR0yQkugSSCqGKY1dIgqb6aPk+z+pDFDoe/L4qnJe+h/docLelTHfCl/GEmi7WunLmDAN5iKAdyzzudCRrLQeuxtRLI5EoTXcOWOPG9Hly7pR8MHg/dbyPad5FdilDtbz1a4E+S4APHpaztbsyQx2f5qD1a+NUa5fDdmJE1wm7sY92qJEwoUvunL8J+MGuXBFQihkrhSrRHUs5/OG3NFjFHnDWk2x7wui7d+w/NlZVZwOcgeMhNFe30c30FokFIk6WSgs2zWxnYTo4CdSJg+bxR5HzRRMSM15bPpdve04qE1DgsqcV1CG3AANkW1HRRXHdvQeLLaAbK3UBeLsLVDqxJ0DrG+FUL8JL4cBTA3sgxoMea7qb7dCihY1OsRIBarSXTc6vnMwqG3OcxfOdVjdAGMQxbSM3lib69EZH/INptCSAJbcpgll3hC95YtzeCiHXJWNITVlvrQ/NGOJQH/gI8UBeF2k0Lispb0lcxXuQwB4XoseFPrgrKQtbMryiHQmx0GO6ywD2RXNbsCLUREZ0gnH3vnc7sDl9ALWKzpEQs0NtTrj8y/rrV8NXeyCDbFG50pQgKQowrisnxxFrlXzZl+L6/sUICLOcdrk29VILoq1jE5w8ItpXgeeH2eV8epI4gxFORMGls22caxKSAgkUq5JW6/XeMLqqTazYcs9+1Rz0bZbVVCFhT2Fbxp/TIoAbTylDgytZLo8gpINaTFmp+pbpj6I5EHIX756TR1bz4Wwkn+NhC56x25O+Q2yQlYafyzhOc1ggzDebmM+Xfyey6bcw4Ht+swzYQ
 Q7dBYW02
 mYwa5TuVu6VOXusXTNyQlvk6VAR6h5adhZJatmLvfMaYdhZbLVQqf/7CBnw1PL96iwt+r/rlq/6K5frVR6bijqxzIgAuB9VJf7YxGR+eXMNzDSk2Zqimml4dgpLB9uEkljABGXAxby4nQcp0+vbx9o5k6ivsW0GJL5HsuCpU/yFNAHagT5LgvcfqZ+hBh5uO3a8IjkXTPR+uCWNkh09aYHWQfjD2c+KLKRilpRosb6n0+HNARoaaUM0jnqweY9dJEfNqp75+TEssczCP3S/aldrsHPxOimcCG+toGmA383AbxrgEs/UQycLT6FYo7Hbum2arENXu1H3aa0L7IjiPuGV42Ua6tzoIIPaWVTkQoJGWpmOy+1VDbBJj19g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 09, 2025 at 10:38:45AM -0700, Andrew Morton wrote:
> On Sat, 9 Aug 2025 16:09:12 +0100 Matthew Wilcox <willy@infradead.org> wrote:
> 
> > On Sat, Aug 09, 2025 at 11:59:16AM +0000, Subrata Nath (Nokia) wrote:
> > > Fix this by adding cond_resched() after all spinlock release points
> > > in page_vma_mapped_walk() and in the main loop of shrink_zones().
> > > These calls, placed outside spinlock-held sections, allow voluntary
> > > scheduling and ensure timely quiescent state reporting, avoiding
> > > prolonged RCU stalls.
> > 
> > No.  We're removing cond_resched().  See
> > https://lore.kernel.org/linux-mm/87cyyfxd4k.ffs@tglx/
> > and many many other emails over the past few years.
> 
> tglx's email was sent two years ago.

... and there has been much progress since then.  Most recently,
https://lore.kernel.org/all/20250225035516.26443-1-boqun.feng@gmail.com/

This report is not from a recent kernel.  Subrata was good enough to
include:

Based on: v6.1.128

and I think it is very much on them to prove that this is still a
problem in 2025.


