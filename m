Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8BCDCAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 18:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53DA78E0007; Tue,  9 Sep 2025 14:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EEAA8E0001; Tue,  9 Sep 2025 14:55:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 404A88E0007; Tue,  9 Sep 2025 14:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 278838E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:55:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B080C1406C2
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 18:55:51 +0000 (UTC)
X-FDA: 83870616102.26.1FA9D53
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6C6A44000D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 18:55:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Lrp0e/5l"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757444150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OtcLIF8X9oqlBjOTtgPJvCmNVCyFXnL5E7XrJWZSxKY=;
	b=g5MyqeAn6Jgr86MSUgndNDXVzRLS98wREr3BtYCFjAqms0/AMyzLJKGdWQWq1T+utDjsBR
	As38ccS6XMHoGEN8jGVUY7gYll15sTlYBk7X/GnOzIL730mpMeZun6VXfgMeVqKmp5AeKj
	wmXHqEgFrpQDRQYB2TxdhxIggdWNrOM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Lrp0e/5l";
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757444150; a=rsa-sha256;
	cv=none;
	b=mjwmFdkhEwFR5OWrVuNuMo3+FGwp41Ug1fRzvx8CFJSbxGfc0rQbR8rwPtmSi6nXDA1Rw/
	QGglZDxJMFKwixumebx7smkXVJ71c//a1S0VhUCdNhCirjy4Rxfp04n9eYZX1cLipsLYjk
	GEClLyY1iPsBFfLnKYjXvO6l19c+Fs4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OtcLIF8X9oqlBjOTtgPJvCmNVCyFXnL5E7XrJWZSxKY=; b=Lrp0e/5lBa4ERHhy51/8nZyzmn
	IM0DpkptRHXlpRbBAJIUQ+xIAQyIrna7exz4rtS0mS7Y7YTZw2hGez1xC7dC7sXuHOgdUF6kx3B4O
	VqZQ1NpYAXJNvSdQhkVFGOALXtT0H467AbE0H3JMU9q1kw+j1EObQrin41AoTWLnpv5NpiylD6QNP
	/KubChYYeCGi5IvXFnPwjEiygEuwNiTwEFi0H/by8Mqu6oD6kc+CY0xlZKmeCgr8K3EM5/OHT47ai
	cVtuNfOjKRkuwi16mntE01JiUYup0UC0S1SebXH5Qaoz0vgYcSAwrt7CCrr+v6oFiZELlsZplI4MU
	r5s6oANg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uw3VC-0000000CmOd-2NmJ;
	Tue, 09 Sep 2025 18:55:38 +0000
Date: Tue, 9 Sep 2025 19:55:38 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
	jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 6/9] mm: page_alloc: add alloc_contig_frozen_pages()
Message-ID: <aMB4KhOX7IeFXaOZ@casper.infradead.org>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-7-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902124820.3081488-7-wangkefeng.wang@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6C6A44000D
X-Stat-Signature: hnsj1tai1onasp57pf9axqbfcczt1f4c
X-HE-Tag: 1757444149-312904
X-HE-Meta: U2FsdGVkX1/oTMp6DadM72enN17afbuqpnZNZaG9P/FdiqkMQbFu04Ns7AUxi+ya/MGXC1KmqSKxFyTn0XBHF5Hmn+ZbTi73zH8AgIS9O5KDI2AG/C2vlxEZaqe07D+/y8zjwHmD7BlfjV7w4eES0mc01VnfLc5SskQGLvoqO5TTLC4DtFIgAtzXkn0XKX1QCIEbg5pGNUqveUUl9/2hWY34Vk0DT8vnyT50S6TXS6pN2XpqZNt1JOG00Kvkf4DyqanDS8T95cJgQisR42asvVxzl25dUUCYov6YBqSGdRIA4rRliohFS4qZUaUgbuJO6t1mMSStls8u0959AnYWtr2MFazBFlQ5JVXL1Vy1YwdPqZgpB4niEnhKeihfoiTvaDePY/2hLcN+/Y1dDiBGg4NAKYniGbh6Gu8p0CltFy9ZYKx7d85EaQDtMIrmnMq916FxpCKaTkKznGHN2tk45xDv+Yn6940rEop8iQLmyq6CL5Uizx1JJsEu5o1HaJzKaptAYg/R8r5D8KBzhv4AtnL9CAiTQI641P0nK8oK7kIAozDbP5Z2lzOp+f/jBLzo2c40Z0mkpEzXindrnLbf6A2Up7M7tBUrSReieoykC5q0V3lzVhvboPaXcAynpk9E4MGK5weNfd+v6V5JTDY9FR02uuhf4R8++jl/M8tXHTssmJsbHSEhHO+0KmopK8CBdwJkNkf8u0NNfZpObzG9SMeyPaXPhlVK8xV+APAUuH1gMSY/IibL3B69GzRDOTZgHYWgxUFP+JpiO7+bTAd19W8u8cqxzteY0qNUK36ppLuigqoKPDkM8yJ5JEiKSLFdj6xfj+q7Mce55/6z6mMtVkCDvOtvWtzNLyMBDmZK0TjOGG2K45vEGGIOAB5RZ3S3GN9e7wvg8+oj8s2Ms15ibNFkJkW4F9fiA+imCmX56qqDGXdixr0+STcRZ/A+Pb8KfJir0vI4GBxJWJQJ1Ek
 58t+1S+3
 gyM/tlow7F2GBnV1BfpQxksGMlJgeg1KrJcqNwO1htpT+H2LZOFyPnqhOvmA6TbjhN0P/G13yOvaS03GbymB1j5fkgdm5qrs82y61WpeYc0ox6jfENcf5Sl1ANR9aNGlV16ZE/8ElM1EW30C0+midJoCwAku2cINQs9LJbGpVtwf67nuPEzlfKF3NeNlV8FnHI8H+Gpo7iOGkMuA725azO898lYW3XFFOOdcD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 08:48:17PM +0800, Kefeng Wang wrote:
> Introduce a ACR_FLAGS_FROZEN flags to indicate that we want to
> allocate a frozen compound pages by alloc_contig_range(), also
> provide alloc_contig_frozen_pages() to allocate pages without
> incrementing their refcount, which may be beneficial to some
> users (eg hugetlb).

No, this is not the way to do it.  We're moving towards a future where
pages don't have refcounts (their owning structs eg folios may have a
refcount, but struct page does not have a refcount).  So work towards
that; if you need to keep compatibility with some users, then by all
means keep alloc_contig_range_noprof() as a wrapper that calls
alloc_contig_range_frozen_noprof() and then calls set_page_refcounted()
if alloc_contig_range_frozen_noprof() does not return NULL.  But I'd
be looking to see if alloc_contig_range_noprof() can always return a
non-refcounted page.


