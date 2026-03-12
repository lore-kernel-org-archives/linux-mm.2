Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDC06106ACD3
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 17:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E90306B0005; Thu, 12 Mar 2026 13:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14006B0088; Thu, 12 Mar 2026 13:26:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1F936B0089; Thu, 12 Mar 2026 13:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C01396B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:26:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 42411140318
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:26:48 +0000 (UTC)
X-FDA: 84538090896.20.9C209CB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id CE744100011
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:26:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=A5ixb3ZC;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773336406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Xk+xvnF9xI6oTX/V6wddcY3doLv2wOIBRVBX9CcSwE=;
	b=UpQEuH2wZbSQVjBLiPyImZDkfcRo91peu8MNdjWIf28UlVGGg0CGhNF1idXx+1SHkPYtcO
	d4afkQeYYoZYG93oGj0w3kOlHt7nPb8lsFW4CZPQgKf8nEqA5j0sD7ZZdmK7rK5mNVhhNX
	O/+Ejj1ae9mMP3LbKIxfEOr7xXPmZGM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=A5ixb3ZC;
	spf=none (imf05.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773336406; a=rsa-sha256;
	cv=none;
	b=KLHq36l29SrGvyehR/hQN0u/D8uiN5enp1AMHOYK5fMAHmZ1LIC0UG7O3sPkGupJrhoHV8
	uvvpQAGnAguFIjwOJCjawAUHp1ELMp/Cz3u1wUq+zcoyNwMTIckRXyWxfimJLKOTpjadow
	gHwyYdpf3NYxEDcuOBq+OFerMvo2Xgw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7Xk+xvnF9xI6oTX/V6wddcY3doLv2wOIBRVBX9CcSwE=; b=A5ixb3ZCSIGvqY0U4o0uZpiRAA
	RYWQNKre/gWA/GiwQdJCm5s8H8cLG7NR9KOoeTUraZYUhst8RunSXrThvLChgTJ1vM732NJ7v7X9q
	zT3hGJUUHgtjsD7MBNnHJSUXV0VrfnzCgB6DaHwvjJpIQsCArgcj8GVh6YM5/Ql/H4MfgT0aZlMm6
	hIaf8jFGxSEOC0lo6M+A+gXJ6wn/j4i5CwX9I6vshn5vves/iKElSkz5xaMoIDfUWtMl0pl3JNJuD
	E6nbs7F5kpYu7n4XkEvlXWfWyvG4EPhrjABIOaAt2dbAkUKm0TIX/ttQm3pHTB54tuDBK0ntE1Aq3
	osJwafxg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0jo3-0000000Bfz1-2Ld8;
	Thu, 12 Mar 2026 17:26:43 +0000
Date: Thu, 12 Mar 2026 17:26:43 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Josh Law <hlcj1234567@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Josh Law <objecting@objecting.org>
Subject: Re: [PATCH v2] lib/idr: fix infinite loop in idr_get_next()
Message-ID: <abL3U3xm9c4oSbKM@casper.infradead.org>
References: <20260312171238.7961-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312171238.7961-1-objecting@objecting.org>
X-Rspamd-Queue-Id: CE744100011
X-Stat-Signature: sppwhnmfhfatbjs88gxnwanmhiecny94
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773336405-134841
X-HE-Meta: U2FsdGVkX1/WdCGLdNhKEZx0bH073YVvcbrg2SLlWLCHWmVu3LwHwPjPXQ09BlfZsfEalMEqBhKCIiPyylmWKh4Qj6lxp5QEMwzQDmCt55BoJLJr2c0lXC4JdmznwTe4nrIBGthfnGFtA75Z3bCBATpLiywGqmExAcMgK5GPjwusZG9aJvhvtnBU6wi2JIcvrCdMF17bwRUM8jgHMBLEjTm2UlQgVevXPsiOQI2Htf+/JsGqwORhG5DXxSPxTNxQ7/gLLXzQagvpR31QxBcHPlw5Q96WjCAVONRJ2GAlwiZUMKIyRuudQNg3zBfcCln6XAROCchq9whri5O8fZISX6nSLpnmJ06sGJtdtV/f4jqE9imsIiJ4YwBwKV5J8Fg9wlNyWz9ox84ubWBK72ULJTk7BVzCNTE0F8fma1aoeD5pgr9Owa7tfr6HEKUI4SBlEK3hB/J3pgf7za3eHa+MDjbhDq4xPZNyiB5c+Bzy0d+jSxewqR2d+Tnq+Q+fmEmTAgw73K+5t5+i72flHFWriRejnAvG/mEtGhvepstUSx4fo30up48n5wZ94LOb3n+SVDcRVMvCfKFd/z9U62CRajbXgCqrCe0wiruuniJ/209B9xruEXbcSfH8yLs3oXywtgOUDGvS7E4rN+nGqNosjFEHY4FzNL9qRtfYJbx1xeXpev7tbxfIDTfGc2mYpkgdcIr8iWteg/Nfr0wp6y5J75tv1qPD+j39vmV54sY4UOu/ApmFQP3EVnHWw8WOitPfpi3sExGX/Hhx1PU5TFbGFN+8r+wblEEnwR+UrzZnF0LZvjUOyR8ApDeWUL/WIvWT9AkZoi7f/69ptobQZ2iD7bp8tG3H787JQcw0prEcSUvNWuNVkq7lXkBrzM9QvezGGyR0c5V9QsCKWcFU+qY3d2jpSeA1MJPljZDRllwiDHUXfAnLRVN2GpeZQ/QlVsESk4RXdCxQIdsgW/1SBGE
 /XBRoe68
 CeNenXIXYXPMGwTKyZHJUOA16VKbu+710dd4Q3xwdP5PQxWlM9EFnXQDZ+NRa/08YTE4YfHRmb6YPDNLkg+Q9Nw12LAXKoA3CZ5P3E2X3Og9NWAyb0kwUDCTlvyp9umNzn8c0OldUCHp2XU5YW5HLD+ugAbxewC7rMxMo88KS3hvFEHL0wfHIWeR6ax4GDdWe1KjM5cf6QXtmPt498KE2HN3O0tBLCGUM44HQ7akvzFz2dtDRRI0uzARHcSYBVA+0paq+x7yqPFZgUgRESf752W4R3302v/4ESmqfTM/yNnB5tZRupxy+cPxIdqEaKKijBtcNaInx1qX4Bvt7wcHL5vE5jjnhgm99o5Ky
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 05:12:38PM +0000, Josh Law wrote:
> From: Josh Law <objecting@objecting.org>
> 
> In idr_get_next(), if the returned id from idr_get_next_ul() is greater
> than INT_MAX, the function issues a warning and returns NULL without
> updating the *nextid pointer. This causes a soft lockup for any caller
> iterating over an IDR (e.g. via idr_for_each_entry) because they will
> receive NULL, fail to advance their index, and repeatedly query the same
> state forever.
> 
> Fix this by setting *nextid to INT_MAX when the bounds check fails,
> ensuring the caller's iteration will terminate.

Can you add a test-case for this?  And the IDA patch you also sent?

