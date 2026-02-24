Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 357E7F55431
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 23:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ACB86B0005; Tue, 24 Feb 2026 18:45:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55A746B0089; Tue, 24 Feb 2026 18:45:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43BF96B008A; Tue, 24 Feb 2026 18:45:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29ABE6B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 18:45:17 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BA0E8B1FF
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 23:45:16 +0000 (UTC)
X-FDA: 84480983832.13.28F98BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id F408940003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 23:45:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="i/UCxPaF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771976715; a=rsa-sha256;
	cv=none;
	b=emKhVsdsFDgkWqY3FOKtsZ3lo8mphkiPlfU+NX1Lt5RGkcCLepKoyLvZd9N5oexK0kb5ee
	g5GzQFZR6hdM86wsnQpAvMSf8wNza/b6F/KZmpB0IRtR2ziv0Tq/efT1l09PHKrx4kxGP/
	MUaoHCY0QH+pdapKuyGwJNjv3Sb2f+g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="i/UCxPaF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771976715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ezX10oK5/u+NTgYSFdiQ6Hdd1Z6R4dOgw7jwXcbCAZ4=;
	b=AYUQ7c9Xrn3GhDjo8pDITWC/wK2jIHFBCtcDPTCDPOlL/9YZTFAo2FsnVqw5/dZkwxylQa
	VF5axR4C6dKRp1vcleaqbRqkVaJE5I5KJAVDrfawYWh8im3GkJtn1eHyj/JmLxzlhfRy3C
	Q8kLUHhF4yTq6Gzwrma+46Ykfnw2dAw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 44E6860053;
	Tue, 24 Feb 2026 23:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2756C116D0;
	Tue, 24 Feb 2026 23:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771976714;
	bh=5uvJhF5LDkPTld+1CeJL8wog5w0F76/q9pZPlIbrTVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i/UCxPaFsPqa+xdPI+yB+vtq/dghbqe5ao7qw2QhsssZyTjiJFZoRDeDg0C+V+F6D
	 btqHA6Ce0RsaFpsCG0phcfSDCWCGHEtDFifDJ/fGz9vUe9gQb85sktY/zDkOUPRBTy
	 lbVlB+mAMllViQm2yDW0sYPLNKChX2FtIXxjXvIByDit8prF0wE8RrNrSPE9aDHfgE
	 /YkMvY/DRKm4lF/LlPMBpgYCpc9dabq0AC3SjzEkhdpBRp5qYxa87cFPqpyTwx4z0d
	 AL8uxuu9jRkVzCPb3IiX2g9AHxWa9hGVNE1d39cKrtH4CXqWb6u3ZcbXuDyWwQtmbo
	 IitiGV/DnD/+A==
Date: Tue, 24 Feb 2026 15:45:13 -0800
From: Kees Cook <kees@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-hardening@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Joe Perches <joe@perches.com>,
	Christoph Lameter <cl@linux.com>, Marco Elver <elver@google.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v6 4/5] slab: Introduce kmalloc_flex() and family
Message-ID: <202602241541.65DBBD8CB@keescook>
References: <20251203233029.it.641-kees@kernel.org>
 <20251203233036.3212363-4-kees@kernel.org>
 <675ec547-dac8-465f-b3c9-a0f97c5bdef7@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <675ec547-dac8-465f-b3c9-a0f97c5bdef7@lucifer.local>
X-Stat-Signature: korjnst49c7as7ceha1qpwnii54nm4uw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F408940003
X-HE-Tag: 1771976714-253063
X-HE-Meta: U2FsdGVkX1/XEJMkeHEZHXxzz7AA70VAi9cBR6MKRIbkO938CadSZaKiV0hqTuzjUF3nQfYzE6EpmwTmy8BdDHwI5Imf9TvMSaGSc/+gOHGZqgFoTgRf+QmSOkxsREjck1VgQy3mKaSCpBJam2+b90baOsuCB3M+yeJwH2dXRe5nNHjfEiQxqkOoaczsXij5reIhbH3hU8fyMZogkEPCGAyVVoNo7Aq0/ik0Z/qp7bQqcpalFSLiAuI7K+cPHq4wYnXAOlylwoA2WXpvTuBFU4Cv0u0pln4nUPLmOrbt3lb2Pf/0nTL7AfkIcNvh1kd4cJvDC4gQykmGmdZwUzq30Flrblcnt5NTQzPqi1LSHC/Korn7bva+R9MV6zXQhToMxFTL50fQHdas7S+zMig0vgGFmzBLax4dYxGQ4PdZllZDs6UwJPuKDtNkDs6cxPJu+G7b1mietxaR04FHyDmRuQ2HuYfh7ARY50McczuADKgPM87RHUFCzYZjjsrtzwEzD7U1DOOynEtagCBHeotpSAlQEkFMeYSjbcwrrOQbUE79OGN9xwGnzvkCHKyYfSoO4kll/sMYgD5s1u33gY1mNqAxGkeKvkKMK6+j7Q6w7bVo/Mpv23Ym2zfSQWMWBTITDCDvsYUof7/xIBNydeucvFi2HxqxbI2sAS3nmBa6k7a51nqsNLm1n5qK2ODjOK5yn0GBkfBwVuwsDKfpB0D4ZPTvGazJX21HhtmwDqUMQZW5DMC9uxQ6mUW9rLZTsGOCnscUmu2pjJHX26u+19l6ioQRRgLla6w9N0cfo4zttow3BdeSwVTkEdiOf1meaqBoNDnWVOo78AwHwTppXcSmnwTyT/Xr1IQlZejDVsgu2Eaa7d69SfD1g+RgSetkq/rSPIiv23Fxz5N+H8O4pnFzPObBWfirtV2WhOTMaIf7kIITygE0WtYGTXvqni1yzg5C0c/x6NSjXGIS6k0M5I7
 7CMQY5oZ
 Fx2uz6tFMXOwKGc0qYW7Qtec6smVcjPUWwQjyHefZzoTMNIvF09Nonhyqpu4jvOYUEbltINhqs/mSMjIDkxOh8TzpwlEHTuS2Ntx3J91wlySOJqniG5yntjwRiNzf4Lw7BpNcAVPaxC6kQP4/ZHX4dMViv6QnuDPavFCnIzy0AOBXcLUpcbPBInR1fy8EVQQUmklZR8l9bfzS3qLMB3loBV/ptempB4h1HM8rh79EVcxoM59R4eRUV3S28Wx4EI/fFItTURL4PpX8eKcvvEWVPhkb4HB/MTVywAYiWmqsu07Ix2ekWqwl3LUh66MxIKVkVue0BaUEIDJejYSBVcCGTFsRAirf/TRRLmcapiNDwlG9llZ3wG3EKkWLEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 10:26:36AM +0000, Lorenzo Stoakes wrote:
> Annnd now I typed that I realise that Linus fixed this up in mainline and I was
> working with a stale version of this file :))
> 
> Anyway, I see that the comment isn't fixed up, so I think that's something we
> should patch, like:
> 
>  * Returns: true if @COUNT can be represented in the @FAM's counter. When
>  * @FAM is not annotated with __counted_by(), always returns true.
> 
> ->
> 
>  * Returns: true if @COUNT cannot be represented in the @FAM's counter. When
>  * @FAM is not annotated with __counted_by(), always returns false.

Yeah, I'm working on fixing this up correctly. I think Linux is right
that we need to put the overflow checking entirely within the counter
setting. That way the checks will only happen for the cases where
counted_by is actually in use.

I am, however, still pondering that the size check (as I _intended_
it, not as it actually manifested), would catch negative sizes (i.e.
negative can't be represented in a size_t -- the default type when the
counter type is unknown) and refuse to allocate, though honestly the
allocator would probably also refuse to allocate them since they would
be very very large when cast back to size_t for the allocation itself.

-- 
Kees Cook

