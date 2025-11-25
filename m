Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62AD0CFD37A
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 03:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4116D6B0007; Mon, 24 Nov 2025 22:47:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E93C6B0011; Mon, 24 Nov 2025 22:47:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326326B0026; Mon, 24 Nov 2025 22:47:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 233946B0007
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 22:47:39 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43FA81403FB
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 03:47:36 +0000 (UTC)
X-FDA: 84147744912.06.50747EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id B19DF180002
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 03:47:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OGziSLEa;
	spf=pass (imf06.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764042454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=etYzjyD7K2FJY2Z+84Z9BvU06IP3oouyGik1vvoCwZ4=;
	b=2vXcakgqSfBrE50ppHZVXibFMBsGbf0W1hwUBWBaw3J42bvQIB3oTpV8p1XZzhzrydjTLL
	s3vveKrX6tQ8cTu/2+3Jj7nHrPjpok8PgFikZA4nEiRPyGL09BZHPukJYkE81tWtphLetm
	QQNik3n2I5uy6WuPOHIJr47qiHF4O0k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OGziSLEa;
	spf=pass (imf06.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764042454; a=rsa-sha256;
	cv=none;
	b=xemIPUBcsbf+VRrjMRjPh7Dcu+vpIiJ/2TdcqImeeMvkPDTz3g6S8RfCLnRJNLIFXSbvRL
	xn47XD2Wi/vioCutisnuoEIp+L5U7gr3q7AFQnNHzkLFKL+kyppMZG1YTKdYjMiy+bKCr5
	dTqymoqdhcJW8Ww6Os4ixbVyAekbwXM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C015960189;
	Tue, 25 Nov 2025 03:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6754CC4CEF1;
	Tue, 25 Nov 2025 03:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764042453;
	bh=MbpfEtH3HJcUPzsyYyfonxu3YFWwAuq54Fd4/ZnOAYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OGziSLEakKaN74XxtWFkEQAX82reG4g0Bzr3N0r1SXQRAsKAwa/KVzFV2e/REZ4w0
	 xhbGxJRYjhznVK01OwKYSNn4NQtIXo0hoi1hCkP0IPbmwK/HnRedWaqODnFG4AmJCL
	 MfCvzdsGWuo8MKMflYDi6J6KTTEJuOHNLzreuG2NUyWWDqklqYmtYQtJPhaLzB+cQo
	 VILMiaJrn137unmpfOgmPmALxdMSga2zxdOsuqp06tMQ1iolXaW0qBNZI5Iw13Gkmq
	 XlXaaDmBhVwxro9sMg3EkDmFBH4NYlh3kL9SjI3y+AS6+sfpjP2v9t4fBKhcCXz/Ke
	 1CuRmbBRPZ4MQ==
Date: Mon, 24 Nov 2025 19:47:32 -0800
From: Kees Cook <kees@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
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
Message-ID: <202511241940.8278C53C@keescook>
References: <20251122014258.do.018-kees@kernel.org>
 <20251122014304.3417954-2-kees@kernel.org>
 <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
 <202511241119.C547DEF80@keescook>
 <aSTKLsRNiEKtDqPI@casper.infradead.org>
 <202511241317.516BDE7B@keescook>
 <aSTRsIUPeT5EC5An@casper.infradead.org>
 <CAHk-=wgn-2ieKtaHAXLLge1UFckLKa88vo3XOdLz+fP+DLpHGA@mail.gmail.com>
 <aSUB1qrfhXp3suGn@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSUB1qrfhXp3suGn@casper.infradead.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B19DF180002
X-Stat-Signature: whzgntxcinupyy7n6h7utaneoocbk5an
X-Rspam-User: 
X-HE-Tag: 1764042454-877720
X-HE-Meta: U2FsdGVkX1+NscQfis0uYuqvCj6QOLjXk3/psYBX0Vetdr/Q8biCw2PPewhf6dROxYY8sCHAAdlUdUrauOH9kUrNKrbZUVnFc1u8hVAgKW/XVI9TL9ymmqzp/+WSFh5i/sYkCN52qc9OXwjwe3ggnFLfCzE9sKO+9Ukq6LiMwIuiyeUksUcSDqGDu25/IRZkkbOkXXxWhjrflXLH3txITVSZL78CuXgdQyP/uTs4FkMgYm0K417wF0uAXINSWOWh8Ws5mG54xJPK7Z7NAZDGVJLBQkwO8lWpdhVr3HUzLsKQAhJbUBMjPD7ZZIbdRFGbJYZLQ+mTmwoPCD+8bXnIa+AGpdqJTR5B2R+Kck6+rZzmTlxNHMer7Rk33KQBY0+Efrfovt6D4LqiUv4Pd9SeFbRboRAVqJyEFwaQTTIaHNVUmvxaZc+6vx0Uk2bFvSVnAJtZCPv2xOF1n3Des7FRusbVw/jEfs/nFpjJ0GL9oVRtGs+dwgVsrc7kfUijSDm5mF0sscFgUmd+/TD8+7zBdSj9T+YTELCrEGVu1jSRZj+HtP7WTzN/51PD5S4lcSGXhJuIxRehwwBAWEWMngjKtYAb+1tfYsIIkxhjjcmiYyhdNEB/NgTcl0U/kJ0fhycuGYg0rcYhSM5YYhMK0dKUOccyx7bDWTdib0JW0bRmdx8oAJEejufUZv5yecEo5Erk9Am0MvClU9uh8nEs4m0OuzAL/NWFgH9FRm7L755/ITSLjcXZxLrv7YguXGHw099697DeMQCAk7KIFnq01TegHhHyk4tUSXchjuq1H8oR/HL0RiD5ievX9fiMR45R/iHhx2uwsdCU1mIds0gD3XmKx1g8vEgiK1S9Z0AN6z7bQZBqPOXEBJ+l4jaC1bP52y8dXW/d6SNUZC8pMhDwu7ZAGOifL4R9TDeTB3nhM7peFw53/COSi4N1hEwY5zcR7BG+guxhCe9vvaXNc/LmFfG
 15ItVdYv
 9V9XVbzspUtpWDz+h4Nnu6BmZ5adpVlSU9pXApOz4zl9+tM2pK2kGTAspR+mDP9QLlbyiLL/GoegroL9TmOaRpwX6UClXpnlKrkIcgHZGS1xfGVnYorwBIywMx2zuMOWsmCivoDFAAyG82KwiIxMB5NyH0HwJ3JNEb90qMv5oDMftVwRbj35fyjdkZSxmYoNH96aRRJhPmTTHHlszpt6o/5vgxNsqn41I/egepmU6qD/5XT//YRuzg+83Met84jJepaCHlVBjxH2Ga+w5LN4neOEc1ZMf7uNGaKuBEuBVFSiEVjzct2pZgWGRpkj1lNhAHYvfRPtlXSW14rL+8v5IpF8gUBWBpqIzZfpNdos7lMZd9hTvYGcaIHUhaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 01:09:42AM +0000, Matthew Wilcox wrote:
> so the Rust language people have clearly decided that this is too
> complicated for your average programmer to figure out, and you need
> explicit casts to make it work.

Yup, and this is correct: "intent" becomes explicit. Doing implicit
extension, narrowing, and truncation is just a mess. As part of the
Overflow Behavior Type work, Justin has also been looking at something
that would allow a typedef to not be allowed to be mixed with other
types (i.e. to do so requires explicit casts). For example:

__strong typedef unsigned short only_u16;
...
only_u16 foo;
int bar = ...;
...
foo = bar; // Build failure: mismatched types
foo = (u16)bar; // okay, explicit truncation

-Kees

-- 
Kees Cook

