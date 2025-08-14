Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C3AC87FCF
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 01:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA0AB9000E4; Wed, 13 Aug 2025 21:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A76A6900088; Wed, 13 Aug 2025 21:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B37C9000E4; Wed, 13 Aug 2025 21:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9EC900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 21:15:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D62F138096
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 01:15:02 +0000 (UTC)
X-FDA: 83773594044.07.DF677CB
Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by imf24.hostedemail.com (Postfix) with ESMTP id D9031180006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 01:14:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=codewreck.org header.s=2 header.b=tPycMhMr;
	spf=pass (imf24.hostedemail.com: domain of asmadeus@codewreck.org designates 62.210.214.84 as permitted sender) smtp.mailfrom=asmadeus@codewreck.org;
	dmarc=pass (policy=none) header.from=codewreck.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755134099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=VSS/GzTf7mRkzo4sO438c/imKZ2sgMqL0KjQB+0sB9s=;
	b=cWTy2owQKlYpsqYE5jKAsvt0MWdSjk+NDTxnaxwj+YRmXjm/j+nG9YP0521FBVKUCG/qU/
	SToU5TRbWnY7TKERi4K1y6yzXffBcHqJSjPw+Yanhw5/kL+6NWc2tNvnSK9vdeh1EDbH1C
	MZqtb4eBJjmrAqBfm0+O5d/z+bfQccU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=codewreck.org header.s=2 header.b=tPycMhMr;
	spf=pass (imf24.hostedemail.com: domain of asmadeus@codewreck.org designates 62.210.214.84 as permitted sender) smtp.mailfrom=asmadeus@codewreck.org;
	dmarc=pass (policy=none) header.from=codewreck.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755134099; a=rsa-sha256;
	cv=none;
	b=qU9uD4nw9GSsr1zewASfVh1OCFgY1m/ZTGk0qQ/UwoK4eQK/3Rt1bfgKnFfnIZ8tRwTx5T
	emp2tNW0zQ7RpZdzF4BurCU41ieucnPm20v9+4/Z595puN1GHZbUzFp1VauNal3eVd33wZ
	DeDo39vMTowA59zU1YpaTR2yM2iiang=
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 468D714C2D3;
	Thu, 14 Aug 2025 03:14:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1755134096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to; bh=VSS/GzTf7mRkzo4sO438c/imKZ2sgMqL0KjQB+0sB9s=;
	b=tPycMhMr7X0wubaDHNZnMqB/VEiz0UUE8omXCbl8cVPraMQEqlPqNl3No+vWVKYafyfuSA
	xhjW37XOoQV3q0j5uHaXh7YYbCRG3IZ+tEUlLhY8SaSBmV/WqNdlGIekaFWtvKennOmXOg
	0jP8VHStgbUj1JeXRD4kB6OG5m1l26zOxuPZDjMXERijZSNrQI3moAFxCHhbi/gpYqBfCC
	2bzC09Ecy/3pG2mjK78rVDFpscJKNFoOvRfr4bJcTgSUHhKrooXlVZISs1Qm35JZT+XjI1
	2qZyXvNOntTkDnzLDvryfNjAjjTCBnXfmst23VvZ/ZElMoQUN43e9Adp+48JMQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 5e52dd40;
	Thu, 14 Aug 2025 01:14:49 +0000 (UTC)
Date: Thu, 14 Aug 2025 10:14:34 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Andy Shevchenko <andriy.shevchenko@intel.com>,
	"Paul E. McKenney" <paulmck@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Dominique Martinet via B4 Relay <devnull+asmadeus.codewreck.org@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Maximilian Bosch <maximilian@mbosch.me>,
	Ryan Lahfa <ryan@lahfa.xyz>, Christian Theune <ct@flyingcircus.io>,
	Arnout Engelen <arnout@bzzt.net>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iov_iter: iterate_folioq: fix handling of offset >=
 folio size
Message-ID: <aJ04ej2P3ZXiBjOG@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f389ac0d-de77-4443-9302-3d8895e39daf@paulmck-laptop>
 <aJyYp-3VA9kJ5YMd@smile.fi.intel.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D9031180006
X-Stat-Signature: rf3i6xhciewkw9j717aqiytcmob8jd9y
X-Rspam-User: 
X-HE-Tag: 1755134098-182847
X-HE-Meta: U2FsdGVkX18iDFmOYH/nZc96x3EXz4doasOHPcZ7SHVHErClD3vBLFns1KgefLidpRKUfn0V9zXLPxsxlUk0z32m8HnT8r2oY/Q+GQPIG88Gzsen0NqGKExMS8jOSL9YqUBJnJqVpfrjA3BFtehE6+TxUkMcdYLT8shNI2sEGqWiqc+lFOUJ2Z75ewLx2RXe/b6sOFQiFVZUeZmIEmFSIALFTqEcRv2hbk5NsWuVTaJO6aZwvTmkM80GCQwWwk3sYRxEnvlP47qF+JMoQzrDTPWqoXgCSA5SD1ScBfJliCrCFIys6SiF68BIFzZ6zMY2/0vDkz1ABe75Z6AbpdYookUWmieQCY567Q3xMYNIbeVcCV76SnyWRasrXiGX/im5wMhgPvdA/7FMd0Z5wzFZiC15WHN3BfkDFQ7oRryBAH4JmgJYswHa4LxpJFIvbUodxPQy0C52mTfHSMVAC/XrWJGk7eWYxdazifyLzF7MmN2AjMveZNSCv9t626bS4wdPS3KlYC7b64GOY1wFribP2G9UF+EFEKovfCKAj9YbnfsQGvnga0jKmT0bAN1a3fufbNxzypDVjCFi/c/QQEzc17h9CDK+z9R9GSd0NMPsbvnaOIabmvXK65pbgjACoQqMqayDoqV/UJn+2mjdh5zLEFQX57AdlMbNvdAbfUbe4YJwuuuQMxwL/3rbqqLyTuWTW2I5RtPcbjSDyXrSLQuzb7Dy7aMspnRM/cmp6E+1qYzoJf4Nw7Ky6M/PRYwewa928fu04JK1mpqPXfqEkBVfWkX+nKLBSgKH+Ua2BdBiBnbvKsUhbkL6UsUs+YT0qYJSdHIblWz6toae8H0BQybTRB/bKdPzzBWiofYQH45RbOJ4EkaRJYnHcTlJ4vjQV9e3G67KmHjYHV+pJ4E81WlNIJ9eExL1xZrMHafUZQ99WpwJQkPsv4ax4Z597zxZiVfWw1np33pGE3+6dg+di1B
 63ayJh0w
 Psxf96J15ilwBCJx3Wi9auCK+yhnZnDcMrEJgzC7dh39NYFwUSMCiKG6V5/ocZDbYazqvSO6YKK58ewOcguH+ZBqiY79eeiir5ODZzhAflzWGdLNvSyDuyOPut2eufGBcomgj12tFkyZtMWSlzrkOT57SLISNac5B6Ru03Q5L8Q01gZXckQ3AzAz2RpzeumMfiGhV7ZhhPoi8cAVKSzO8TB35PjVVDLkmYAvIj+K7L9xUvaYbG4W+UhvmDsFSFKy1idmchm3+zCRtu8rQypw9ivAAZ+lWzX2B8rMYZVLb8dJtP9QhC8INlEbGlIBj/rAzJH4yF0RdlQjLLdZ8RR3xxfouiBF3VUKCbTs5jH78+74v4Q1ZErIpGXb8/TfNJ14sa1JrPHJ5nnwi86yUyDRzXdvXFGXbvWJr4eSzyaHEpkNiFH4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andy Shevchenko wrote on Wed, Aug 13, 2025 at 04:52:39PM +0300:
> > I actually test with W=1 too, but somehow this warning doesn't show up
> > in my build, I'm not quite sure why :/
> > (even if I try clang like the test robot... But there's plenty of
> > other warnings all around everywhere else, so I agree this is all way
> > too manual)
> 
> Depends on your config, last few releases I was specifically targetting x86
> defconfigs (32- and 64-bit) to be build with `make W=1`. There are a couple of
> changes that are still pending, but otherwise it builds with GCC and clang.

I meant it the other way around: the warning isn't showing up on master
+ these patches for my config.

But now I double-checked, 'CC=clang make W=1' doesn't actually use
clang, I should have tried 'make CC=clang W=1'...
And, yeah, it just doesn't show up with gcc so I'll know it's better to
check both compilers...

Paul E. McKenney wrote on Wed, Aug 13, 2025 at 04:04:19PM -0700:
> > I hope this to happen sooner as it broke my builds too (I always do now `make W=1`
> > and suggest all developers should follow).
> 
> This build failure is showing up in my testing as well.
> 
> In the service of preventing bisection issues, would it be possible to
> fold the fix into the original patch?

Andrew just picked v3 up, so there won't be any such problem, and -next
will stop failing after today's update

-- 
Dominique Martinet | Asmadeus

