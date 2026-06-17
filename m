Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06B15CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 13:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07F5D6B0099; Wed, 17 Jun 2026 09:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02EA76B009B; Wed, 17 Jun 2026 09:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E877C6B009D; Wed, 17 Jun 2026 09:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBC896B0099
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:31:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3828E140447
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:31:32 +0000 (UTC)
X-FDA: 84889491624.03.B947561
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6F7E540012
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:31:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="TxRn0/0e";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781703090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZoQ+njTdYNVTgBntMdcaiqvX9nvcsW2jhlY9QL4l7LM=;
	b=L4KdH9QV00Gy6pQ5cJkIb+egQnJo9s6P3av7AQzujZOB+xGT+xhqcndcCN69dL4sFqFAZM
	9XeBDi6qpRJx9WDaiuB+hQWblzX0GUxq7tmzdeyUTMr9mTLvp36j0oX0jVMo2qPdAv3B6s
	Hn14weAl1OjIa63R3MRmMrUlHG2Vr0g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="TxRn0/0e";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781703090;
	b=dvPWrUvoIw5qBAfah7UgzbuEIoXhFpcWZHAXb+b7EehpPWwhXqlFfMQ6AK8l/kmIhxkGxs
	vX/xl8POhOEH8fb94EJnh8P+6ax7q+nLaDcXXsp4UdCvCmitVGUEXSe4aj/9B94QmIk0L8
	K1cJfFO6J2VGLKH7CJTKfuH3/XucibQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZoQ+njTdYNVTgBntMdcaiqvX9nvcsW2jhlY9QL4l7LM=; b=TxRn0/0eQWnW49u4GjEoH/4qlk
	8g0x98WEyDIxku/4H2dLE2i8VqS1R0tcBo2njcTS9bqsAxlDPGvwlMD6kLu33qOGpzCGneFz0qzGd
	lCFEJ8nuY+Yx/ndKzG9PuPu7yK/kdvLx+icggl6d3qBBBzFlWdpsnd8d45AoMql4RcHDXE+/ReTXh
	P8v0kAh5ZqGBJvqqiUJOVOUcFZPJhStVmWMyZ5HpwKfPsFTRy9jsCBEVJBTz667yXuEfzs89/Mf8w
	OXU/RpvD58XrIyR+tskLMBlUjflgryUoCumbeONAklARVEmitmKfgvFPTtww3w1c7/+Y4M/3xcuOd
	rjoQ3xZg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZqMZ-0000000ChTP-28h5;
	Wed, 17 Jun 2026 13:31:27 +0000
Date: Wed, 17 Jun 2026 14:31:27 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: Document the folio refcount a little better
Message-ID: <ajKhr08JtjqA9Csh@casper.infradead.org>
References: <20260526200032.353868-1-willy@infradead.org>
 <aa419310-de31-4119-84cd-67474d2ba917@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa419310-de31-4119-84cd-67474d2ba917@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6F7E540012
X-Stat-Signature: 8chc7bw3uqys8sygp7ecgz5hof1d8485
X-HE-Tag: 1781703089-627234
X-HE-Meta: U2FsdGVkX19k/CJpK5Cjtw+JyZDUVvCvtF3khsFqke+2X1vnedcTzHsko+5+OSJNVAjydlLe229ZOjRbpXbE1A0NQhIohuv5okqoHIG7QwEuJukRbArwDxzzxIDC9LRYXB0k+svbw7dVPzoNYmsRk/AJJJU7B0Z2PZVgUy0iw9CSZ047sfgpikdj2aZOg62rtFq+grxkAdtuCuZsKkJfmIkkcIB8muJTdBBF4qngcgOiWUz5PEVdTjvH7JkscY6vS2Hg+8y2Lr9oasCsFl9eJ9JtDKcjeBnF008+z27YwA9DhKacZ0we43SgZnAcrM5VZbQtGKddZIcgR3PWJb776qRxh57v/GihuWWhGwr9OGxZ2G+tMplD+KaCsjCOGQYXK26ojgCWMvm6y4eYFDQczGlTU2rq5ozLtB74C3iPfFnrmVXsKsBbjG2XJBPjGCugXq8Q3d8wTBnX8O02LLOlA/ujxf4i/XAvvFPNuGlPc0P3V5RDkd7NwX76KS4QbpYkPcjni1S1V2dZC9tbwd8fPpi+nlQpv90byWfJcuY5zpuWDL5r0+CC9sMqOkUe/83jB7a+eqyb2QNc+Vmyq+8BaBMOiH1U4sKguydVBCqDLPG23956FiujQy0mfTfvZ6mdOpK0mknGBNnklRDyWavHmqT7Y7pZZbVY67BcNyENAjmG2QsCjzJ8VYyxLzrfJFeWUiOhTJe/0/0f7PzHdXBwqTa7hDyGYhBOfdn5O4u3Qv2RN4al54jjQW2DQwh+zTcyNPGUr9vjnJlOQEeLNfFPIXUrv6v7yPUxO5GRcvzbX2yLz/eQwSG8Wc240k2L/e4tSOJNeVtW0uZe2Syyxlzhr2tuyElJS1IPyUUnffPaBpkkYm8ccomQecgqo2ZIw7/zNl7+kq4TaTtjCg2AIj/YVtaHFBkHaWG/EBtmZ35e9e40tWFLIBA6dDaecgVvca0cDG3dPWmaAMQYUPdlza6
 f+IlarPX
 2/OKtouk3O0KRuIWw+W99EjKDT/Dzqc1CSQxXoXqAGL+0DFaYmeNb2+akz/VuQrU96kTRWOASQJj3N2ak2IVqOjCfR005sAM3qrksXQ1GdBCDlZSiZWr1DSfRORmoDp8leBDc84srOvJR8vP42Swt82Ans794S7Xc3hJGKeqArIOrBpMeXyqBteK/JUw0TPTMe9U16Kr3r5VmMO0TsevmULCCrCDKegBJc0Y+geIujCV7o/W8c9fLIRPcUkqFV6Pgp+8Yw50cudnWCsc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 01:22:16PM +0200, David Hildenbrand (Arm) wrote:
> On 5/26/26 22:00, Matthew Wilcox (Oracle) wrote:
> > + * The reference count has three components: expected, temporary and
> > + * spurious.  The expected reference count of a folio is that which
> > + * we would logically expect it to be from just reading the code.
> > + * Temporary refcounts are gained by threads which need a temporary
> > + * reference to make sure the folio isn't reallocated while they use it.
> > + * Spurious refcounts are gained by threads which, thanks to RCU walks
> 
> I think we often call them "Speculative references".
> 
> Not just RCU (GUP-fast doesn't even use RCU for page tables). We also have PFN
> walkers that don't involve the pagecache or page tables at all. They don't find
> stale pointers.
> 
> In essence, all these users use folio_try_get() and friends to grab a reference
> speculatively, while the folio might have been freed concurrently, or the
> pointer from where they might have obtained the folio could now be stale.
> 
> Maybe it's clearer to explain it from that angle.

From the point of view of the reader, they are indeed speculative
references.  But from the view of the owner of the folio, they're
spurious.  If you look at the code flow, this folio hasn't been exposed
to anything yet, and yet someone has already gained a reference to it.

But maybe it's more important to just use one word for this concept.
I can change this to speculative.

