Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05635C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7A36B00CF; Fri, 17 Jul 2026 13:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 188536B00D0; Fri, 17 Jul 2026 13:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C51C6B00D1; Fri, 17 Jul 2026 13:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C762D6B00CF
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:29:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 442371601EF
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:29:29 +0000 (UTC)
X-FDA: 84998955258.04.C878F76
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4A81A14000A
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:29:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="gy5ls/v5";
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784309367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShAyE7VO4VQr7VJkjYidYF7ZGJiAyrO0e9dbnSofcoE=;
	b=UHZBM/QvgFgBRzbnif0iUB4woI9/iNNMEu6lNMMzHg5POJq11RRRbcb7bCHCPePXMvxfH1
	QbrqzkFCjiBpKVUM/SoBHPUbjo0ThBx77wyea9DxFa5MNRqJ29a6Cmbv46mD0FysqizhTH
	cuklglwC4O4A0T4BWsRCBjV3yAb6HHw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="gy5ls/v5";
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784309367;
	b=aHnDVcQvLVDEP29VztIvnudF8t93h0vVWbAhc5XxuHEw9QA+lgJRNDURGDMQipIdZrh0yn
	jsm5Ego+jMf4yD9u8fK05y8/eOIq9FRa4NJeUamVgYcydEXnkpj439LtPrQnCuqklFrlqr
	6TrsiuMrIFOFdGr5sMXMFxlE5K3VmYU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ShAyE7VO4VQr7VJkjYidYF7ZGJiAyrO0e9dbnSofcoE=; b=gy5ls/v5DFYXBSnSkHKb+74z4S
	3SIaALod+T3PkugLOkqOq5a7IxkBzRu7hUwQqDukFRsLBCOSHDDUeQ0SjsWzwG5v9bpH7WNOcaec6
	oa8mSwRytBv7+ZsVtTWOMrScFxcjT5QDFdjmWKcsZBFQHDjIaftMSO06aOJ+62snr3IAZoXV72b+k
	jnoyr9Q0kyIN9e2wp4S8znnsGy+X2D7M/oC0cgj8Wka1PhmTy47Y23igH/9cSWRTSGPzYsu0eSXyO
	exrgXEfLAWAeD7iiclU+jS1uq+Rb7Hd9xUx/b3NDf/hYQMw78GLvlIJ13o1jO2cDK747fE4zpCbdp
	oV58RPqA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wkmNE-00000005QQB-2KcZ;
	Fri, 17 Jul 2026 17:29:20 +0000
Date: Fri, 17 Jul 2026 18:29:20 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/folio-compat: Drop superfluous return statements in
 void compat wrappers
Message-ID: <alpmcNoufw0T2EU5@casper.infradead.org>
References: <20260717072054.74260-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717072054.74260-1-hongfu.li@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4A81A14000A
X-Stat-Signature: xy7rw9oxxtifjmxwpjm6enzzwmq1i7t1
X-HE-Tag: 1784309366-646069
X-HE-Meta: U2FsdGVkX1+rTp5I6TAVvgIlAO1JnzAzFAdjn1r/EwEJBmLFGWqsp+vLn/rqCcsKDL8e/7VKgXuxqqxUQ/gzxZ0B/1IVqYqHuKElsGgYznn7bGYOBIcUQzgNtZcSE+vBRkOllUckJI5I/d2aEycKavtlIMV5QiLATsLhGy0ndaYN4C8r8Rq8TXHVsY8J9bd4k69cQfzey1UuGJ3/VIsRTzR/lddws1zEOySFZv1y6r1wZh5FkoGOiTcECzE0XVzu+zmvGHhrsVzZra7WpQMoKd+fIkaiwi+wEKuRJEyqudSzt4ZOv80vii2TDQgpX/QU372fI6dz5Eq52kSqNKjvWWeVqIydT2F8SdqonuBiH1f5ksI2lWCHY9pEcdGJQR92IiWTTC7y9T4nl0RqKnHB52levm+chulLu6GnC2kSZ8vG7I0M3Hon3cWxbTFuF/yfCB+kAKnaLX6cEERwyvlqPzA8NHk2k2FNVY2LZ6RWXgRrCMYMqbLgV7IFciQuqQ+eHIDc9wmdHKuUPpLJDwoEfcQn8gog42fiGTOV5JTlFqhJBsHATbEw0mcaK5CqioNAtc7L9EKnmUHiGNtSCUm7C5tODQe1AmLHZ+uW7FICnBq9fouNjYRE81jgmH5BgYJ93/dJeuYrWAnU12iFyhsoHAvVrrdD6XSF41HwSXJihju9Og6mj6Nx0xkn5PeTt5bKlsuG5qZeJcykO5IqzIxmv2qG7WQDVJNGpVM/S3wRa3KPlSd274X5GYBF6rwYwYLx47akfTRNuDlxYZvFHSAPPHDgVWO/EfVgYC5Mvk+2USTenSXQXmpngb4iQhfcr5lvDid6ZU/zxyaruMW8JqM3TUqsPfrgm5k5KIR2rEozDdNEvd5miCHdIrWV2Km+Y+iS0P7tchL0v9fmqqcGCvzdrluaeL3rPneBY01rBwAfrnDrE43puUpDgTpbu/70TQ74R5omPuzKuJghD/TSnnY
 /iSwaabO
 GTh50cAjxqM7m8bIwkqtqGEvMZirCk4wO1jGVjyHUe2Cq+9seiHNj2L/c5QlA6BDQl+NvvU/FfJAzPBE07oSErigVQmGQE60Zn3/nUgrX0L5EDZOJ3bihg9jOQUm+XNbcUoniwGJKIWD+jpz/0N9TDOPYA1Ry80GHgRFxp18jorc4sSPMUhJ/kQ8EjKgE2foU5B3eaNDfiLa6qSyJxEADDAaEum5py2ILyOG2iMDKTHWnVTUj/SSlANDWaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 03:20:54PM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> unlock_page(), end_page_writeback() and wait_on_page_writeback()
> are void wrappers forwarding to folio-based functions which also
> return void. Explicit return statements here are syntactically valid
> but unnecessary, and inconsistent with other nearby compat helpers
> such as mark_page_accessed() and set_page_writeback().
> 
> Drop all these superfluous return keywords.

why bother?  this file is temporary scaffolding.  if they offend you so
much, work on removing the need for them.

