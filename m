Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62CF4CFD36B
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 00:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1D626B0007; Mon, 24 Nov 2025 19:29:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F4B46B0023; Mon, 24 Nov 2025 19:29:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909E06B002A; Mon, 24 Nov 2025 19:29:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E1606B0007
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:29:59 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 697BD4FA2F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 00:29:56 +0000 (UTC)
X-FDA: 84147246792.13.1CDEA3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C4E19180002
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 00:29:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vP0pDW+B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764030594; a=rsa-sha256;
	cv=none;
	b=0WJJLEXsLA+/zAemCPaSqOfOva1kkQFFX25ZqWJ2YpOPvXctY3eNcooaTJKYPsfBcS41MW
	2QZaCh6vmMLnUoG/amz+XpJ9aQDlYDrMwTWVNYxDKZjZqwKBlou5ZDXGZqeNKUoZprmq3I
	DW3g/bkej2Kk1MwIdvMR2OSrhDhTTCU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vP0pDW+B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764030594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GsQ0Rrft/2zJsF9vIPqGYfKXjTW4MDXp+SfE2VWe7yw=;
	b=FTIMCR55AI3oHSi2R3yQUNnMFYOyKxMRAz6OQOeadqNcZr4e2yL2N6YmcQBlgCqaYOQ1+X
	uLgYkY5s2wHApUbnRx8R2no29xqDCxd6EbhvFHcDvQuLgKGT08os9Y5f81OKXJuPJZm3YP
	EqAnAdHd63YCVvnaHUSOO48A8Ys957E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 838C4429EF;
	Tue, 25 Nov 2025 00:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BD8C4CEF1;
	Tue, 25 Nov 2025 00:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764030593;
	bh=4uLLAgDc9tGcrBcub+QCJwRh5UloS519zmliLS4+WTI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vP0pDW+BLmy48fCW+CGIvxSSOBpyZLYqJlIFcgFof2izgXQUBhwAbWrNhiXRBRkXe
	 GG4SgKT9qZsApPZSuXAOjUNhLTFptYI/vhbzI49vtWUzFvUfn/p6YDwl0QxXi513+C
	 Vpg/Fmf9P0BEeHtlxJv8H6UeuikiIv1VjgSQMa+6PjlBo5C3FpmcKscSFnP/utdse5
	 KZzgwabQE8amERyL/vtIu1c4gltor3c68XQs4cQIeMeTPM7E6vz91pqB7hmuS/+PW2
	 M9JbOdwp/XqZNni55nZnDncPu+HxP+OkBHc1AIn/vOCItrqo1Ru3C0d84jmTT2dC4q
	 SS3PI2PS8mJ5Q==
Date: Mon, 24 Nov 2025 16:29:52 -0800
From: Kees Cook <kees@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Marco Elver <elver@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v5 2/4] slab: Introduce kmalloc_obj() and family
Message-ID: <202511241612.6CF90E9@keescook>
References: <20251122014258.do.018-kees@kernel.org>
 <20251122014304.3417954-2-kees@kernel.org>
 <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
 <202511241119.C547DEF80@keescook>
 <CAHk-=wikqnc16e7yUTJuqnc5f4rL+y_-JpRzCLRu9WPnt3nmiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wikqnc16e7yUTJuqnc5f4rL+y_-JpRzCLRu9WPnt3nmiQ@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C4E19180002
X-Stat-Signature: uoduiyxda19sfrw5hxs3majx5wsgkwgc
X-Rspam-User: 
X-HE-Tag: 1764030594-170043
X-HE-Meta: U2FsdGVkX1/6Dt6f0cBgzp0HcG+aUwTUEBQD3RGmmP0GTalFKurm8Fz7XDiwfGO/bOOyx5OsBiKqS4ztiQkJnzvA+/jLrTOZPbLXGjpNPe9vfpSyBOgqkv8qwLwTc8KDcUmPr4gly1UKRGIzRmtlv03vEwVjOPsQCvRjXEefbfpEpP4mnq2yUomKxN1d4MN1im4OYsMOy2+ibw6tgYFvwIinxHnPUsYjEUw18cYKebwxiwSYIC9Oe4agDPTmiLgkvT0ZhcKf0c4PBkQry72ihkrJZp4snebw756f8UL1x7rYsLb7KCidFNu2HEeOi7JnxjgLi5Mu7pwnn3L0kqKywbGNQ/svel7xpI8KUwABNY0AQt/J4hbKPqt1Pqt6XX5iYOGzDQuSZASqmuMJYI4wUUkn1H/530rloga+NxHGiISgrcMi1/LOFYQVWG9rL2Pv2su0tkHSwmfX4kMIwvrs1VE3e+kab2+gR990zclNYGr6IfkRq0pc/qiyp9yVmAbf2X0s72A1TiunryC8AXSZhC4CK68UIOcBkRCmD3jp3RjGFyXTwO7ftNDNd8nDhatxSoIIVFEyCEVmGSp2ZLmdwmRZ+XksYcXU4PqWcCogrSh/ThKyjLbwllvXUvxhPC4+YqKFlQhqgKIyapdBNjEbTcxRtJR6oxA2g0dtotl+5OFR9jUKjtAaIGCFDfYZ8zV8UuTS7ZzOCRH5IzSDSXaPq73OsPUgZM7q+fk3ZJ2ikSkc9CAOCzX7lkmKAmjCSAMvES4t/XT+dzTe2On16FqhgL8imQ79tOVIDJudKGNTLJppmxv9/u8iWdKTgPio22Tu6vq/jnzyyHAPAVFOprYJYU4VYK1MnQB5iptGGECYw2fTNRF58BiCK7jLz3VPe/eQKVRh0GbtkCY+OJe4U4xYIDvEzj5l9DwYUz3t1muB0Co9YmGbl9QXb0dR1btbUk8SjpRod1lBMqGLukxxl2G
 co9S/hM6
 Zwn0JVB1Hbo+JJ66iBH4lzwy7mG1ydVXdnkS3Y7ss0AsYYXhLrCQ9xmAEPzfB9xTdpvjf9CDx30YsDeF+M4UXcF+S3IUVXiMPLZVONq7l0MW6615+usWRq9e/xsGeYouOCbee4e+8yS7ysjZvhn9fOFmx0qyFpY2LiCU0wK4mQN2/gjf/owhAM4aQfoQxPJTZoZDk5OFAUlliW42F2jX7giR6pPXOxWmf6CHlmmdt/XRM29s44DQXw2UA5HRI3LgorgWExl4j2UEI/m6qcqf+0b+6qIuYjl/+91nZdPCRn/DtWLy9qYY9Ak9BnOiMGZO1JteXgAElfLGd4hxiCwQtouqHPikfJi8eC7d+L4eI5ugpvmZxe5wZbVcrZ4UqatIOnidnj0Sb1pKbTD1qg3pizh+FlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 01:35:12PM -0800, Linus Torvalds wrote:
> Those macros are illegible. And 99% of all users DO NOT WANT ANY OF
> THAT COMPLEXITY.

Okay, I think you're saying "I don't want the common helpers to include
the infrastructure for supporting the ..._sz() variants"?

> So no. We're not doing *any* of that. You make it simple and targeted
> to the *common* case, of you don't do this at all. Because that
> over-designed mess that actually turned some users *less* readable,
> but one line shorter, was bad.

Fair enough. Looking at the treewide change I prepared[1], it's less
than 1% of those mechanical replacements:

$ git show f79ee96ad6a3 | grep -E 'k.*alloc_(objs?|flex)\(' | wc -l
17473
$ git show f79ee96ad6a3 | grep '_sz(' | wc -l
114

I'll respin without the _sz variants, and try to improve the flex stuff.

-Kees

[1] https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=dev/v6.18-rc6/alloc_obj/v5

-- 
Kees Cook

