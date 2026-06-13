Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41A98CD98C5
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 16:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BF156B008C; Sat, 13 Jun 2026 12:15:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66F836B0092; Sat, 13 Jun 2026 12:15:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 586056B0093; Sat, 13 Jun 2026 12:15:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 46EAC6B008C
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 12:15:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86BE4A042D
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 16:15:34 +0000 (UTC)
X-FDA: 84875389788.07.646B442
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 159B71C0007
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 16:15:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NxCGY0uv;
	spf=pass (imf18.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781367332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JFSLvO6lacXDS1M4MjlvSD3QCJFp6gqwb5JykZl1KsU=;
	b=qGKCJW0nkljUZi8sQJMt21/uhmkL9fjsd2OoQyCk/A1IiOuZ8+11mL86LcnSVR4kDGWQIl
	3raTmooo81+X3aBluWnlC89I0Y77LE9s046mDXBcVM9wP7QrVX1MQ4hH+CyqDALTFkgdBM
	ZKYZDoXQ9IM/eO3rda50w9ijDxRAGTo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NxCGY0uv;
	spf=pass (imf18.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781367332;
	b=aIQRBhco+HCbZYHcHIdWQ2KzsTzVoQrA8iqCgmCPJoKnVbhgjlgrJeflb5S2E2v2TC9Wws
	6dWKjIcE8YCQPGJ7jeLKIGZ3kY2pgLv2Qa7G6OsFz7jvN2aSGGcss8PwQ//nvi+xu+1zdK
	CpSU3kw/6ZhaZ7IREc/WG9WnbEOU/4U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=JFSLvO6lacXDS1M4MjlvSD3QCJFp6gqwb5JykZl1KsU=; b=NxCGY0uvjFzYhSjwQECIASiSA7
	Qpk5qinecD5gVkrLZLtQGNry9rQ/Y7gb3xnypGXHETOo8lipL5YMo+zhwA58AAZ7bQjQIyXCDXPw1
	1HvKForhY89Lbdgpo3M0obRyUobmObSJq0G7vkrjtu9/Exz3KIMyRmjdhGBG6wTnLCRd+F1FvA/BY
	IpVEmmoofWHCRVrzXYmzOiEfqqtAZibNgQ2ygAR6r6hDhnWwLL2+3+dsrOcIEXsWSoM0D/+GbvWRP
	swPIrWnqOSrGth2D0Ns8JCKjLuNwI8D3rmzIK2TBrAlkldTtV4SQY8QubgarreBQfXUIg5j2YHy9A
	CG1n4sZw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wYR16-00000005jo2-1uBj;
	Sat, 13 Jun 2026 16:15:28 +0000
Date: Sat, 13 Jun 2026 17:15:28 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 5/6] show_page_info: Remove printing of page index
Message-ID: <ai2CIGzlCeqbOz5o@casper.infradead.org>
References: <20260608210618.3437216-1-willy@infradead.org>
 <20260608210618.3437216-6-willy@infradead.org>
 <20a5a752-3ed6-4fde-96c9-e8369b15524c@linux.dev>
 <ainCu2HZTTdP4skd@casper.infradead.org>
 <11cc4dca-7841-4897-8665-e27d7555f246@linux.dev>
 <aizL_QrL4dNWMJ8Y@casper.infradead.org>
 <661b47de-af1a-488f-a691-82df7add1f49@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <661b47de-af1a-488f-a691-82df7add1f49@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 159B71C0007
X-Stat-Signature: erhz93d57snsaj7my3ck3w1us7oknje9
X-Rspam-User: 
X-HE-Tag: 1781367331-372393
X-HE-Meta: U2FsdGVkX1/O936s/5U+jqH+aUqxm2hQlDdhf7jSl72WSJM4KXH7NYKdffORstTkx4FViIWNWiBbQ9I+W2xBxQq0HlgbuzKl/VfqR+kyc0Ot2jBgMKt7TdALCbSK7xkT5gq78EHahrmBLKmgPFE/M8Cz06H+YwetcSl9PvqswQ4WsTIh5Ij9QBEFJSl9tniSD8iBiuwXDGKyTrNlm8OYRA3KVbCNJeqvKrNJrHOeqTko/ZThbVMne4CHnob/50YebSGMkgXRvKgLTvxR8pQOY0I5lCs6mcg/xgq6h7udULtc++S0chm+KvnAGm4z0Gogpim4dnuLsdOzj9wdXK6/BoE4HIEpNOD2Bb/a2hej1wid7SXTBt+nLavA3FsSZJkmw9DCUGbHVVRcP2OObtGg9QchOpc/q9DcvYP8Fl5aiJhBRFVIIlcD4srXMl3fqTbk9uzKhKjDJvVjj6nKyO/I6qGCoo4A/WHdZAuHdSE+KAGGy3HgsrJwjFoO3dpWXNUiSlmmi8n0uN2B1Fj8PtpgnOzd8nxuHTu1xWWGEqnoKQ2cIsWA0E6Fmi9PcBlPMI0XH5n4JkW1bFz9eGAG1qh3i7It2hRW6rd5dKlkA7GVxAdVnPQhjPYwGRQDmR/OQ1jGEWM1uvE/EgReEG1LKFzgkI3WwZTy19iILekQsuyi7Am1Gp4SiPxwYs4rFcbfhTtwz6hjEbEEwKTSujAUdpAbcWZUFyZ9bcIOt/T0LMJMYDDyTJGL85msUwccMbcK7JVi9xbG5wBJHEBGDCklCl69SXm2bzsYzHL5eyE4bfcfJa+oFT44AJEs84UafPbwi3lOIEij+2BPC+2OIfL9psJL7pJOjNX6cVOzLRRg4VKAG3F2OdVbzG41kg4VHSsIdgGR/mu5krohc08M4VRJIeDAuOjUdsBK8CdwkpEYQjb/ch0Ve9m9XTGX25s6+CxvaDS7FdCgxB5SuPEZXVa1sNI
 XPYC4RdS
 fimOaNWvPlGGR3sPBvKc8VPEIIsTqWpbW7I0smpXl6wW83JfBCjq1ri4+4VWf2UbthFYBP7Dusx5krGOmotnw1l8cDmyhNy3Pu2o+RPPEOQvPn6zt2zBf3ImVHLVrWU3BG9rOxDmiKOLuTPPa0tFfqya+DSDWRPfNKF2noVRkQQ9nm4Tv5b8Y7NDxjh8HBEQrggNDLUnVItfLeWLvHZ9AUGYrNxYPA1Kj7wMnVwMVLEj20rfimJvPhdPdTCvLT5uuQxnkOw4Sf0PJxtI8Iz+u1uwhs9sbEuTmltLD0AydJ8aUxIrQdqGitKDoYO2NatCcSgJupfgZwqXGzn43Y2IhziKFBCGi+JNi5bDORa3BqGITqIpQJW/z4OasdOxsip2pYto8t9y5g7dz4DYrZiHMB+ENrxJHEKpLaR0Nrk9eAUM8BY4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 13, 2026 at 12:16:38PM +0800, Ye Liu wrote:
> 在 2026/6/13 11:18, Matthew Wilcox 写道:
> > On Sat, Jun 13, 2026 at 11:02:06AM +0800, Ye Liu wrote:
> >> 在 2026/6/11 04:02, Matthew Wilcox 写道:
> >>> Thanks, but could you explain why you don't just call dump_page()?
> >>> It's more comprehensive and will continue to be maintained.
> >>
> >> This script is based on the drgn tool, but the drgn tool does not
> >> have a dump_page helper. What kind of method do you mean by      
> >> directly calling it?                                             
> > 
> > void dump_page(const struct page *page, const char *reason)
> > 
> > in mm/debug.c
> 
> I’m aware of this kernel function, but could you please clarify
> how to call it from a user program?               
> Or how to achieve the direct call you mentioned?

https://drgn.readthedocs.io/en/latest/release_highlights/0.0.28.html

