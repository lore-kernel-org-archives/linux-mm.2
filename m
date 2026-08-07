Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C052C5AD05
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 00:39:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828A96B00A0; Fri,  7 Aug 2026 20:39:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DB146B00A1; Fri,  7 Aug 2026 20:39:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CAF86B00A2; Fri,  7 Aug 2026 20:39:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD5176B00A0
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:39:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DE7AC026B
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 00:39:16 +0000 (UTC)
X-FDA: 85076243112.10.8083651
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 59492180003
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 00:39:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Qd1huAJg;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786149554;
	b=i4lIAtF0KNiBZRyKA4ZxRuAnxfBwd6HeUKOSE/1JZESxe70U78IFQE8L7nvHgz2713PhYl
	LdNV4aFl6JkXxzEkPdLxC1dJhmW65fUwqgVHGHhW5VsW3RrxCFWgQqNdjb7JZDPAt6F5cR
	4ytDM7Zmug9+YP05N7pFcWk7H74Fph4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Qd1huAJg;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786149554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sdVOFuwDYAK6n59S3MJdqkPXQEejr/e0uJr3YI3UHF8=;
	b=bmy67l1RkgheJPJFcwkw5usjGbrpbcc59L9jlMOItcq+gog9qcfLdjEO6ifzqRvhi+dDzH
	fR6QygHQEAWxr6svEljz2/8B1ClZicVJ5DRAntawYpRkjAYmJKU8Rjo/ZAj9bcsebdp8s3
	juJLT6UFclRtC8hTK5epNIvxFf/INkA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sdVOFuwDYAK6n59S3MJdqkPXQEejr/e0uJr3YI3UHF8=; b=Qd1huAJgq+y6tWJWIkwng5bFa0
	gJ/gLRc2Vn83n3w5bWzzz4IwJVPMLKtJSPSGgPKA3fReEL/671FLEbozEKlZeq0tiSwTtGIORkDAO
	Pt2ttl0Li9xhLWRElZtEKb6fzS25cmKkJzXgw6Cksf0bU1S9BvIMZ9y5WBmZXV7MqtFWVUDf1e5uq
	OypCJMtGYfKibkYndqnci9lpCuN0Vwdz0YfwJTqN7dEWEf6VQgz7Xv+ysjIRyMvwdvKhG9HNtigE8
	/npCPNbjJ+wfOGvLg8Gn424rBIaMOrzBDlS2WDDqcv9srp0/B0r61HGquG9s3k69bDosdMU96FSBI
	xY+wo6Fg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wsPc8-0000000DLLs-2nyS;
	Fri, 07 Aug 2026 18:48:16 +0000
Date: Fri, 7 Aug 2026 19:48:16 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Christoph Hellwig <hch@lst.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] mm: remove PageReclaim
Message-ID: <anYocInoXy7KRcZ8@casper.infradead.org>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-2-0899bac3b826@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-b4-page_io-folios-v1-2-0899bac3b826@columbia.edu>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 59492180003
X-Stat-Signature: jd81w5gpccwxgyc1u7j199xgcwcdcx94
X-Rspam-User: 
X-HE-Tag: 1786149552-754573
X-HE-Meta: U2FsdGVkX1/i+/r3t7PFvbOdwfKL+LnwJjs8msxaVQMqVqEm5EW1EbMBzsvVfyAjTaPP8x3JNHKnhTkTiRHw61E9LrElOMBYnAwTtfRG54U/tTD3D/N2cg4bzlx5xjtBUkOeLqbYSHH+drOavj9RRgaVXRXZ+TvWYsrSKW1r2ka7LDSENRUeJrcG3Np3oLvdcAWaOtzWW4ne+syok/H+1vx4/IrffYCfTfFufWCCbaJ3KcV29ZmnbybjEE0tr2q4JTRk6Xyqg5kgMO/rXdb5DfS7PLR/vkKe/LEJqzb+BjcgaAcmPFRtFUBvDsoGrL0VO6ya52FYOOBPH5hSj0dz5U0yTELSFWRyYWczW0s1ihvM4NYBMPug9b8WR5MBrUTYBuv32cnmu3jl/95ySvx7NdfiCBP10IeNlwPzZma7Ws4RHAIi1OYnAIeLps/Ht5/KfjtqwFGg+gc77Drpk6zd8jMKF0FbDP9ce/14niJBkrrsxmqz2yEFYDKoYupI9CkdJX8B7LCBBqhJNZutcmebbeORj2NzCdLB/LAKk8Mf3Xc8R9KNe31VOA7r2CkpZPNRTKhDQoebCgNY2rqfYtN+dUHTas1UGYLme53CWPgTjaCR3j117/PLWYWQwjutVERYPJS15ZXs6cY5JdmE3m3B3TSIdhFYJ4BAI32kJO69WoDqy9YtH0AWLGgsfxPGn8MtLUUKMd0SvurV16C7kZosvNcv1DO4JIOmHtXuQ5ii4nFBWXW6LM0d9Vac9H8PP8l6RcvhECVqZ0mqQ/ulNroGlafLdB5oZwKQlvovNNhinNKDFaMOCLX62aRUkc/j1W9a24oKKo3YEXRZiCOO/2wLfFCw2OfH274BQ5obBEwmXRHtchRB26EE6qc/XMSsBIdklzF8s5A/0B9Wzksj2a9ThSMyUTqhFzVegKJ5B/JrEFhpBm131yb0rSWilM3M6TBtgFpaalJuXHKQAn2m9vf
 5rV3z3Zh
 /rDlQLg+guc76k6V5VIT4+FcYUQzcm9+/JRgUuYDPojCDnLpzaATTJ7qW+AAN+ROY3u02D3uCqEZLoRszu7SXJDBqn9RN4koierHDsN5GK8qI0hmbctLT5c/zYuvukRRB3WSosck6iDYSEjORTS7Hwg8w4+EfEa/JQ+miog7+j6cjBkaxC+z7ytYi2H0EimrlLLGz4dfTSkZVSYQxx8/5oGRC6n3xCfDrI5AORpChubV5IRc9X/WTGFtg3AC+ujURCeJu6xKP94cxwtH+/c2RFyCA38XKd7wEjf1jneJpOH0uXPI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 06:55:34PM -0400, Tal Zussman wrote:
> This flag is now only used on folios, so we can remove all the page
> accessors.

And we don't use folio_test_clear_reclaim() at all (it's mentioned in
a comment, but that's it), so we can drop that line entirely.

> -PAGEFLAG(Reclaim, reclaim, PF_NO_TAIL)
> -	TESTCLEARFLAG(Reclaim, reclaim, PF_NO_TAIL)
> +FOLIO_FLAG(reclaim, FOLIO_HEAD_PAGE)
> +	FOLIO_TEST_CLEAR_FLAG(reclaim, FOLIO_HEAD_PAGE)

With that last line removed,

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

