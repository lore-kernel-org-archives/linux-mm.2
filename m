Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C271FF47CBA
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 19:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EA746B0005; Thu,  5 Mar 2026 14:24:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06E2D6B0089; Thu,  5 Mar 2026 14:24:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB3406B008A; Thu,  5 Mar 2026 14:24:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC58D6B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:24:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 99C251B70C6
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 19:24:44 +0000 (UTC)
X-FDA: 84512986488.11.4FBF2FA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id DF8311C0011
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 19:24:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Wm66T+DE;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772738683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ukeKHsAJYN16f/Xu0LO5gqLwIT6xwI1wOVLPLX/DdPw=;
	b=M7lZY6OQVxHoM52JynlmQXv8bhYWJAMm+DMW++3MvXc+cboaeS25OtNrx0Ip7UofcwRZ0z
	rlb/7aC2lMRsFd9q4PLOoh6BnyW652u8diN85fIiXtHyeDw64lSysVwJssSlFnw/wRWpCB
	x9dxNiGMlQX+ickkniFNUB+8QFEedTY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Wm66T+DE;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772738683; a=rsa-sha256;
	cv=none;
	b=HD19X9J2UjWv8Dr2LHJaoscxfagfi8HVGGLglKNecYk9oaWJ0a0Kpi/2ZjLsEHDYcIm8sp
	9+Cgy7iTROjFVVR1ZfO6GdR4wJYnBkPolQa/yZI22jhwWcl1Goj2EMWVonxVIfVTRzPCPh
	ryAx0w4ZqIblUx7n0rlFP1CSsRXua0k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ukeKHsAJYN16f/Xu0LO5gqLwIT6xwI1wOVLPLX/DdPw=; b=Wm66T+DEZS/jmgLAh1khMDshCD
	LTVFgMXFWTkJiQ8dy2V2YcnuU/pnomtNDnR9dvE6npT4TD0E3c2b2dhey0GkfpNIS/qgxprSXQwK2
	I0LjaOuzgAn0cuhs8m/fUyNsgulq/roXtzjCLmql+dvViBi9q9HaCFhi/e0BvvrtzvlVVRs5bhWR/
	PfzUvNM0X1nTTkox7poo6hboIpQkUxCZ3Or8P49NpeWxZo+hQgxEhV75pTAsPcDlFoF1S8v0KCphY
	/ag1Dz21FJ3HV2gUJNcSpLAEJFexPp8MTTTwcMmsw+6iyp2jJr1BRBBjVm1xLORVhfTxGESfO/uEn
	WvBqSbBA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vyEJK-0000000FW3u-1Z5T;
	Thu, 05 Mar 2026 19:24:38 +0000
Date: Thu, 5 Mar 2026 19:24:38 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Chris J Arges <carges@cloudflare.com>
Cc: akpm@linux-foundation.org, william.kucharski@oracle.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [PATCH RFC 1/1] mm/filemap: handle large folio split race in
 page cache lookups
Message-ID: <aanYdvdJVG6f5WL2@casper.infradead.org>
References: <20260305183438.1062312-1-carges@cloudflare.com>
 <20260305183438.1062312-2-carges@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305183438.1062312-2-carges@cloudflare.com>
X-Rspamd-Queue-Id: DF8311C0011
X-Stat-Signature: kxtebxj4kgm5jn6uewchos5j3yxr37st
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772738681-943477
X-HE-Meta: U2FsdGVkX19HAt5VhdgRePqUbvnSX/pnstCz5giSZF5M5gFZjdaSu7AccDgL2nQXvRLrhcNR1aDfozZVvrDQ+NcNiLZGlblpt10VKuxl/c1IEmeblFof2aiaMEHHkx9rt8nlh82juSONzBAtSh1tgY8iN6ymVf0gBOPsG8YfucWkdkGNDQ8AELyh0/C8YwBMJOZhKbC1DD6MlwL8OT5T1iw3p3f0fspYpX7nGpeoFO/XFqsIDwNvDounRpA7GKZ3YsiWJ8z6g0P44d6zifeHGgFtsDeMWpOEN4i2f+pExvQTvjJpJS+RND1c7S6/xVaaI7GVvqJdY/WQIdXy8xLRiB6UJjO316AEAaMI+4INADXJ6XUWgdPxsk3TVp2QEVh6b5SWVrADWcRd4h4OXWaJMBiGCmf3oZp6SwHYAurhoQb64LJjJSUBawV+QIymGDzSwkHtymkam4OM2Sd+A3/6Mn22nyaF4yiFD3m9EQHN+E8dz95yL0WGo8PrB6fPlXpB79BOETR1NMLaUHvg3TwiEG3iU0iAfYWiq7IXmpkHLfHCCXidTGlTfNi5NC668XaDgrCnnVJky3OxqOtlrxXFrWhgCdqn++8LRzaegV4xM2/xMwZiTWafll3DXeC9RFRuumVhDNYrbL5j8WAV2nnb1h6LnPrtGLkaw4+2KXjqW6n2Up/wtvwZ0arlufRrfmc2WdlmBua2dHdKnNKdKNtReoJLMVDMx/3cd5gbYXycydnFAnTEOkZKpzN2K7wyKV6oxks9vAg1lgjKW37c+UgWEr5h8S8HUQjvHmVNI2nrmKPNA+zHGDbjdiO0dxH2sRcQMWQ7gB61o/H0pETY55ejZMVmBeO7il6xxwUc11N9Bn5WN4N1oKreuwDH9fK17Gag2oTH3tFzqBx78T314ZVrJRSV5z/JLqEhavnmLnnbA6hmOgkHifE00fpb05QcTD6WxbpIpzaU1ybAAQ022Df
 6JCmjJQv
 bsh7kX6/owne1ZoV+bYQkSK8LEHXSuOEgfNzDwMyDiLhTo3/1b+U1G6wUo3lAHR6s0UKmhQrPZNjOkPTKkKy00fdZ4p+IXr4RuGgbdG1xMaCuRyU+Vri7z8S45kSNPWDDJopHDsu9KCR22TBFCOm1kzoJn4WJ/tz42wJu/Y38IeZ4l8FdPL87KCGse3NgJfa5YEZTPyMor3XipLNqBKlaQ7HlEnTu0KIlddYVvC9DPbWbC/hHW4kDd3g2NA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 12:34:33PM -0600, Chris J Arges wrote:
> We have been hitting VM_BUG_ON_FOLIO(!folio_contains(folio, index)) in
> production environments. These machines are using XFS with large folio
> support enabled and are under high memory pressure.
> 
> >From reading the code it seems plausible that folio splits due to memory
> reclaim are racing with filemap_fault() serving mmap page faults.
> 
> The existing code checks for truncation (folio->mapping != mapping) and
> retries, but there does not appear to be equivalent handling for the
> split case. The result is:
> 
>   kernel BUG at mm/filemap.c:3519!
>   VM_BUG_ON_FOLIO(!folio_contains(folio, index), folio)

This didn't occur to me as a possibility because filemap_get_entry()
is _supposed_ to take care of it.  But if this patch fixes it, then
we need to understand why it works.

folio_split() needs to be sure that it's the only one holding a reference
to the folio.  To that end, it calculates the expected refcount of the
folio, and freezes it (sets the refcount to 0 if the refcount is the
expected value).  Once filemap_get_entry() has incremented the refcount,
freezing will fail.

But of course, we can race.  filemap_get_entry() can load a folio first,
the entire folio_split can happen, then it calls folio_try_get() and
succeeds, but it no longer covers the index we were looking for.  That's
what the xas_reload() is trying to prevent -- if the index is for a
folio which has changed, then the xas_reload() should come back with a
different folio and we goto repeat.

So how did we get through this with a reference to the wrong folio?

