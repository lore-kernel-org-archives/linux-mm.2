Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B15B8D1D892
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 08:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB71A6B0010; Thu,  4 Dec 2025 03:54:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8F486B0011; Thu,  4 Dec 2025 03:54:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4CC6B0012; Thu,  4 Dec 2025 03:54:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 94ADB6B0010
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 03:54:59 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90A6AC0943
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 08:54:57 +0000 (UTC)
X-FDA: 84181178634.29.FF9224E
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf03.hostedemail.com (Postfix) with ESMTP id 03CC82000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 08:54:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=n1Fmcq1O;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf03.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764838496; a=rsa-sha256;
	cv=none;
	b=RrFRPI5NyHLdg4yhF7KigreY11cX9ueNILq31OWxCgEQZTrUO9I08pZtHGXsZco/R0r8kl
	v2JGyiuNTXT1eIk8vfEZ5+MbQVUcgsmytp4Ortyo/oe+eQoqz1+h9KKqup3mYAyadYDqVp
	9w6RpqTNMVdGjCN7lu7pHOPqH9tkfYM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=n1Fmcq1O;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf03.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764838496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZKEvWFqVXW3ANMXU8thFViT+wrQQ/PtkxsPiuQj5uA=;
	b=D7Q81+3e4a6p1IQxT9Xf/TmFSXutwcEriTXamUJwGkV6m01nQ1Ha7lJOcHXEINY9yoaap3
	FZyDKTZpiqBbxfFR/pNkeobpCTsRSyR7ztlCtceeZ8Dg60d2jofIQSBCWD9FK07jKhPEzo
	s5SeOynyjkLKY4afJ84g+x8by9WDo+k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1ZKEvWFqVXW3ANMXU8thFViT+wrQQ/PtkxsPiuQj5uA=; b=n1Fmcq1Ozcb1gZNwIwt7tfRmcb
	6np3a9hJ2mNuV0iDdqz4vOjj8nB7hr6wPMYVcRAqwYqBJ/JYSg74MYNtYY6v7QOF6NWVH+Bm1jfjZ
	+3QSmdaLpOIdEBz9MhaV6ERwPjIwH9bzMBwG2Dsh3ocb+kM42BG640wLyfrUvZ6wVY06s2aoSVr6r
	ygMGl/Yg9Q1jwjZeqy7qoOX9MxbbcqqYExtP5uc6u05Q+BZc1iJzDq8h7ORVWT1xjQuCsEbJxex+L
	cDBWaOpNmzXuQIftV0tJE5yg2rPGn3y5hOIeN0UrM7PJRPGi+1xTjhfqIpsJX7J2hDo9FNmRRCFnB
	oI8a0szw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vR4FA-00000003fDj-3C2R;
	Thu, 04 Dec 2025 07:59:17 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0DB523004F8; Thu, 04 Dec 2025 09:54:36 +0100 (CET)
Date: Thu, 4 Dec 2025 09:54:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Miguel Ojeda <ojeda@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Marco Elver <elver@google.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	linux-hardening@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Joe Perches <joe@perches.com>,
	Christoph Lameter <cl@linux.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH v6 3/5] compiler_types: Introduce __flex_counter() and
 family
Message-ID: <20251204085435.GC2528459@noisy.programming.kicks-ass.net>
References: <20251203233029.it.641-kees@kernel.org>
 <20251203233036.3212363-3-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203233036.3212363-3-kees@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 03CC82000A
X-Stat-Signature: isrg6ssic8uduwkfganthyqqg7te5x3r
X-Rspam-User: 
X-HE-Tag: 1764838494-607462
X-HE-Meta: U2FsdGVkX19VNjYQozSFjMdiOtrFRvNN+r9nybXzPFpj+n6RPQX8mOJJ3SKNwMZPar6jnydGkqiEnoFWLeTWz/2Amy0SQm4Tfs6zM2rx3OSnXWFJFWYX3dGrmWZylKUFrCy0HHh1MWccUcANNu7jD9RynMPutTIZHm9Os6G2zA19q6k+HLyIxk8hWNvGn3EeeraMjnzTDyhBHT+pLdkMfYomHxtzCJxJnruL66THxODcX9zNAd2P455FLqy8ASzStDofPk4qYFLJqJ4yzbA8/bs7AlSo71Xo5PIeKGQPO3fBbnJ+uruGBE51kx8lXsflDsVaNm8mvQ1eljUQAcpU5LCPNmFeg2Kn5i6KPUdUdbJ/H5Bdrf/rVN2X9YjmKNWSiZflcK4Iny92wfsFb+Q65ri2hGSSRbX3OVWw/8qdIeD+N0WgiWD1dDStGFQq749bB5vjm1O8WevBKAcDRUI92akOFEFiZucoJSYiEoZmc8hT9K54T9jTKh9FDEpw829dmC0mJMJGLYzNM5caaAu3ggu+YIvDSThRVn2hq8eVCJdIg5qY3j2Lp7PO5opmNTOW+GcWWaNGVs5xuMvQ+hsPPe5kS2KvSOKFBRyGLdBNQ3F/J+1M1cFwR2iCOy+I46J0mCgBjvwNJHx+aufddvXXNaCtoiFy7+UMPONZsluUrRBslT5Kxliwi0x2pLeYDepyPx2sasNeuEj/9uXjcL1PduGtz35jYKhuB1ob9+Bv0JLMAqAOgKc3CyzWqDdEWuPEzytUQFItS6zZ374qQSCrhK9IKHmK+0my1RIsKLrIlFr0VUG584U+bC9El7qmz1+I4ooWDCJv1h84f5u7cxPKra8VDGBmEUsd3AbPR6fDcymO0nmt1RCWj39dw9HUBMrBsp43Y2iEiKnnH2ub0ZdL9+3tzofKJ1gb2brBl3lt/AKUlIQ3YWTMMKCeW0g8F1DkcV8U7Ox6b3hBaYrdylN
 jfvaEFAo
 SJNeczd6p8XmVHSLTm1Knqwg8iVkEF4jcj2awCs+QYbDe3c4HYH1sLAvwOik9G84qfVYx2DW74J3jwmCUdX6UP5hhMsupoRwGEbL/v3IK+ytzz9ibSGSQr1Ux7cqjB12RN94irKsBUgBI7jIUgFWtS5Ew2lmrvWXC0+7YPtVcnxyjxMq21d5N2kT5/1vWaai2q5ZU/afHzqh6TNZ3KLqKYGBCuAPjww7NiZMLFNzHkf3bpPJcyn07OGpzQoeGNohBcPEudQvclgN5nOajOvCABpSFFI7DWv4DT/6avlwqyrPQaX2JZmv7SEUPzZpIr69nFqpMTb/vwAC9bybwr6Ej2dRyLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 03:30:33PM -0800, Kees Cook wrote:
> Introduce __flex_counter() which wraps __builtin_counted_by_ref(),
> as newly introduced by GCC[1] and Clang[2]. Use of __flex_counter()
> allows access to the counter member of a struct's flexible array member
> when it has been annotated with __counted_by().
> 
> Introduce typeof_flex_counter(), overflows_flex_counter_type(), and
> __set_flex_counter() to provide the needed _Generic() wrappers to get
> sane results out of __flex_counter().
> 
> For example, with:
> 
> 	struct foo {
> 		int counter;
> 		short array[] __counted_by(counter);
> 	} *p;
> 
> __flex_counter(p->array) will resolve to: &p->counter
> 
> typeof_flex_counter(p->array) will resolve to "int". (If p->array was not
> annotated, it would resolve to "size_t".)

Uhh, how will this interact with the proposed extension of
__counted_by() to normal pointer types?

Because the moment we have __counted_by() on pointers (remember, you
promised to rename __counted_by_ptr() to __counted_by() once GCC-16
releases) using __flex_counter() on a ptr thing makes absolutely no
sense.

So perhaps just name this thing __counter_of() or something?

