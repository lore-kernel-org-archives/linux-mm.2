Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7532AE909C4
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 15:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3FE86B0005; Tue, 17 Feb 2026 10:50:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1DD76B008A; Tue, 17 Feb 2026 10:50:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C40A96B008C; Tue, 17 Feb 2026 10:50:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AFBAF6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:50:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 546308AA92
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:50:43 +0000 (UTC)
X-FDA: 84454386366.29.174AE45
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 88F27180014
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:50:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ql2CJqSU;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771343441; a=rsa-sha256;
	cv=none;
	b=LNBcy03eLOihLTmF+evc2gn4IPWCUhdBFC4ibXU6NvmHJoZzm40RpaadPYJyldtJKsBcOe
	Kc9Nzr2BrKdJ1CP7L+MNdUJyE21vF1Zca5YbWXqBBDMa+rZARXYAXLV/5IfpUpBRof/e9U
	LqJNuxS9Jplknrh9V6UZO3oDfMLCR3g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Ql2CJqSU;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771343441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rQDqCdZpJsTt3Mav7l+A0YJOBunkeNsBUDQhyvkmVgE=;
	b=aBrwok1Gia0UWgirlN1CXcooYt7AAeGyIqm3aXL8OxhbNaLLpjqbm5caC1y5IUPbtciNPN
	xJ3Y4LXQlVXPuzyDCM8RlUVW4P6Xz4bdXTPDSziEOmqSzLlrijSNUCrL0ugmPHNNp0gC/3
	/vm660rQ2K7HA+Wrfq2WttSEZIckBLc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rQDqCdZpJsTt3Mav7l+A0YJOBunkeNsBUDQhyvkmVgE=; b=Ql2CJqSU5Yjr83Q8ykEBCYZQjd
	uabSdSC89l8T97xXW/UI4nH4U/1l0Z+uX3AhLNvg2MOoYSDqy/SLvqLyipthOi6sOOOLO+39LLDUJ
	frJeGRFJOr2Ht55ZEH67hiHtrfGK6BLTNvb90WQc7ELhtFiBK3YCuJZCRBaF0FkaqHKDUIWFkur4o
	jC+T9zGhFDx/1Bo9V9sqcbtnzzmIXxZIwWWvmzbsIKt8/NwfEkbbMsEBrI9eS4T0sql1Csp4ktAiu
	LUist8KrrZ5ScXX8Q/almp/7p5jiYP+qwvECOuyYVAyO4z1YkZKawH51TtZ4naiq2naQTcWiEJj3K
	R4hzrviA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsNLQ-00000004cf9-1Iof;
	Tue, 17 Feb 2026 15:50:36 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D7283300CDE; Tue, 17 Feb 2026 16:50:35 +0100 (CET)
Date: Tue, 17 Feb 2026 16:50:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Boqun Feng <boqun@kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
Message-ID: <20260217155035.GZ2995752@noisy.programming.kicks-ass.net>
References: <aZQ19FEeGgigdwz9@google.com>
 <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
 <aZQ8lJJ-U_8j03Z4@google.com>
 <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
 <aZRHJ7pSzOHruPA2@google.com>
 <20260217110911.GY1395266@noisy.programming.kicks-ass.net>
 <aZRWOIPThLfIZ1Ph@google.com>
 <20260217120920.GZ1395266@noisy.programming.kicks-ass.net>
 <20260217130024.GP1395416@noisy.programming.kicks-ass.net>
 <DGHADGXGWS45.1A6EHNMKM4SRH@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DGHADGXGWS45.1A6EHNMKM4SRH@kernel.org>
X-Stat-Signature: m9gdc8o7af5yb1zgzi5uox9zk9t6b49g
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 88F27180014
X-HE-Tag: 1771343441-953874
X-HE-Meta: U2FsdGVkX19avJHHaSuTplaFjSNjOH7BWTIWfkduoXqfcVuovJdynqv3ir/4ycdhB5jsTCmIB3hg96URIXcaho6JqqZy66/DTBxJWnSNE7KWyj1nbWSFnqOh3eyGdFifsk0+wyhSrSjNCtnohE9LDG4cGSOFllkyP07nDgJb4ZdwSjZiHDkBvMjpl1oSpCEOBQFpVhQlqnUOlzcZb44YCfSjwIIUFUqyrUMxCcf5XwSqzV9P37Imby5gLhFIaSMysatfPwXWOAlagghYfbNx5m+CdYFF6ceWpj2VQ4rwY/NWdDGkJVKvA2njMYwq6YLpp++nxSgPmEFLbVyzDsM/ordsxc/Slir6hM5T8NpTtK1/lbgaUEbYi1lmRhDpqEn8zN3HhcwD53SDQjE1O0YD6y1B8Gv6D4d+o9miGSWjUPsbtiGnDZ3wNCrSAiqFVmAeukH8FILc9IouIBcN2UUuFSuh/FtCByt4FHaqiQ7xwZwcXM9B06Nhu1Nx1j+/BHTlTkjV9LytmXsC5K5akfYVehiJYLY5NHhQjeqWZ/NW/cMXIOVCNgPfJw95acQYwrgglO9hXa2iF2D09hFZa/x3YrOwYfr6ydVhbVUcC+J3dIbUqgiz/rkWwS7gZkLcqhuNd6kGG0KbPP8e+LiIJDw9Pqm2Wt8uqYrJQXwaPrKQUNhiHsWe/BNGYV1x/M2B+5vKTvFJp+pcQ5FoyKK8GZCa5R/NMmmLL45bnpiQBQxmUcBtvYqzn3c+7kZEpFc8QYEnkxK9P/H/pL41Po1mer0028ZPAlrWjV2LaJufDmm9VolwVlrPCms1GdigsCgGAggPC1SQMpM1e5BabHCUOCDd91AtYF1r9qlJn+1TYiaFNuOdUJjhTSV2vn7QMGB22+XTboTsYKkmXzB0GycgcA/cIhOHTZKfZQeDxorfDj1Z3ukjYPWeigq8DsIf6SHQLu1LiUH87x5cNRzVsKog7RI
 21T7EQ1j
 U6JqMMKVs1KWd2WKWLCslDZ2Arv9jF43H60ocTCV8ZLBfOJ/QYC2YExF+1RTdB3zAQ5SHgeP2K3ajJ2w9KlNAwWBHrIJIGmJ+frYga63auE4w/E62w1VhXBzn7SBGtYsa25j9LiGPTBcT7oMb5JaizhHVss36aOxWW8Ys82LB3LQ0yDD5WromnAs/EMjQtTdbgnyLdT8dqN21Rrwr5LXsPnquSSm5IykqC3qojHV8jP3lBN4mMAqLLWc6LpIF7D4htYzTbJd1wLEhNlHijIp4Fn8iv9D3KDnuxDMzt39jrAm4UMsrhNMJOwtPlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 02:54:30PM +0100, Danilo Krummrich wrote:
> On Tue Feb 17, 2026 at 2:00 PM CET, Peter Zijlstra wrote:
> > Anyway, I don't think something like the below is an unreasonable patch.
> >
> > It ensures all accesses to the ptr obtained from kmap_local_*() and
> > released by kunmap_local() stays inside those two.
> 
> I'd argue that not ensuring this is a feature, as I don't see why we would want
> to ensure this if !CONFIG_HIGHMEM.

Because of the principle of least surprise. For the HIGHMEM case 'ptr'
only lives between kmap and kunmap and any access must necessarily be
confined in between those. Having the code behave differently for
!HIGHMEM is surprising.

> I think this is not about not escaping a critical scope, but about ensuring to
> read exactly once.

It ends up being the same thing.

