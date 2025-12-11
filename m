Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC134D43356
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 22:02:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2FB76B0005; Thu, 11 Dec 2025 17:02:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE04B6B0006; Thu, 11 Dec 2025 17:02:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA81D6B0007; Thu, 11 Dec 2025 17:02:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 976946B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:02:33 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B1DF89B30
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 22:02:33 +0000 (UTC)
X-FDA: 84208564986.10.D3B31F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 532932001F
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 22:02:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P765zWgb;
	spf=pass (imf03.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765490551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b2XTzmhqknncNd62m/+i8Tzeo1fjy76Z4ZwuAyVUD5c=;
	b=tOkfOWHQMUMfM/7vRQXgzFBYPn2Xc70JDKcWHVlRqjHJstmJHbGufPAEN90blrNijfsnYw
	+BhrvDfF3ogLvWPUdkx+z7ewG7i9vSQ34B3m2klEXHdUjv+xL1bd1wimNOcmat841BOC4M
	irHe1HUy4ZX50sDZbNpodjGcNZz2hyk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P765zWgb;
	spf=pass (imf03.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765490551; a=rsa-sha256;
	cv=none;
	b=LH/p4b8dxOT2y/Di1u52e1/ErYbFTDOF7szFlJ8Pca6jquI5tee8+JdsOAuOlBDOneeNoa
	1tPcWIQtgq8EzE8dkI3vmzXYgphf/oWEZ8q1UpJgY0kqvJvrqupg8N/FTeapEg3PJ5lSkz
	CvqqVPuQ6DFTV0AB5tASJcq7WgGOsE8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 366DF434B9;
	Thu, 11 Dec 2025 22:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00344C4CEF7;
	Thu, 11 Dec 2025 22:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765490550;
	bh=1jUgFRDwVLlPWU+cRYkz5ms19z7NWJCY23qeUoAcv8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P765zWgbp4XZhTszJMCeeDUVNp10Rd3K8KYKkwkNcXitSFm5Wh3gK2hkGiYR/ZVsB
	 FmAa2JgHELGwNTiEre/bcZF9ZAGyj/ycg7TK1LwCcU6yZfgJhGDYBQg/fqTqZZlnfu
	 QWprdOkdYHOQBhSAK/PqaLXJ9wfCJr5mJ77yqxB5plHt8nb/lBctR+ymX2osMGBDDs
	 J6+sbTCUPcxDE01wOymOruBEgfAHfi8zW4v0+u9m5cAqGOM0PbSGFtCcId1PC9nOxu
	 +GSqoovogCnNL+zXwsi+73UATSs8J+b0f9+SK5YiGb1TW7wNZz1/bNqIPphNOHKkSv
	 zCJMLNUHPW3VQ==
Date: Thu, 11 Dec 2025 14:02:29 -0800
From: Kees Cook <kees@kernel.org>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: cocci@inria.fr, linux-hardening@vger.kernel.org, linux-mm@kvack.org,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Vlastimil Babka <vbabka@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	llvm@lists.linux.dev,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>, Jakub Kicinski <kuba@kernel.org>,
	Jan Hendrik Farr <kernel@jfarr.cc>, Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Justin Stitt <justinstitt@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Marco Elver <elver@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Pekka Enberg <penberg@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sasha Levin <sashal@kernel.org>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH v6 5/5] coccinelle: Add kmalloc_objs conversion script
Message-ID: <202512111400.135295C20@keescook>
References: <20251203233036.3212363-5-kees@kernel.org>
 <22e31f45-55fc-43c6-bede-fee1c829aefc@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22e31f45-55fc-43c6-bede-fee1c829aefc@web.de>
X-Stat-Signature: ouhhmonphp8mnp8h64aw6ufaofajyz3f
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 532932001F
X-HE-Tag: 1765490551-56385
X-HE-Meta: U2FsdGVkX1+TxB6KID4vaaj1EQrJZ1LHg7uiyPnR/vvm7tAA1tpc+9TEq96nsXlujtRZYsPf7v1R6ljNUpviSSMyVSfRebSC+fpkwDPmbqvydKvtDFtH0t7o8i7HRRbqhcE5By4ooUWgvStdcVH4pt26WldOF5f/puF2O7qQIWKRyyaU3gemr1wt5cGmFPnKFXy+UC4b+hmrdMj8e3wQIrmMmLmcoCMCW+kunbq5/TiECr3T8b2i+nqbqIhladgfgthShFaU8d1/abJi066ePptFAseobXx05ocuq7I2/DZaF7RP9CRblBWyz+/zN2Z3Oz54vMV3PxdRnJ1fGnXZJ3XtTGhBwBdiVZlOyrLc4ELfY1srXOIvdqZ1jwhVV9I3+bvrOOA3v3U/ernywKE8jgkBS20rFHhZTwD4Ca5jd42NzIpSCtTD2POz9iltPECpJ6qPPR05RXi2kDQnYNweftvn4wHWZGdPZ6UmVN9LRt4C+Y21sIMYuA5LGdbv4pF/+MhkqlKjMYMOBFnWQ+fHKk4GfsuDkQdD38F0ihCYBvbT6MY2/F6Qf41zlCw4HkOR6zf5E9+CPO+nBTV9r1uMKdZHTujQUHzzEUKdZ9mdDXO0/Pqa5k5+HOzBaGXhdcP0a1iN0y6es66PMwORyRRVqyGj3smbt+HjbR7d+eEXg1KN5l5C7LRPMgUjTr5+H9zrSLV7QGV4J9zrW/s25j6zdCTHESjZCx9rjjM4vPhoShbi/oFZ0gtPR9YzMMxLPi9P7lf7fvrSGME+ENeXIZFupW5gvJlm1bftZfMDmaWxEESvv7PJouSMonlQCLmukMm+Wz1rr/EfzuzUbnnqVMFnINvLRl//Mf4pCm17Hzch4lpQZzLSN0ljLMbYrGLZ9TbH10OTQvaaX0NwoT2qxZLFg3ht/iMZqYIy//DFy2kh0qVe12IAbkVH1lrMFdIJKDL9bF1sFNimroKVyE/f0Yx
 eH5ff5u2
 Z8SjpMyTuu7hcRh2k0HBT5I54fOUrQCO6zbx3kzkM/ZVQiCsdJj13KGR3UR80hhFLB3yWarJnsTjMpZTqwLSXiy+nyHSDkqdZMdkllLZWt474Vq+1IlVMYhXvPwEOHg9XdtwdnqegohhSa1lodAhINL3VDUKqOKpLUPC+Xplm9iz5U+/xDa4GUz893xiVA7L9GOZ1jswlmm7O3pFxh9WKb5M3xnJL6FvR4l8bOgFtSqlB2QERaAxw/jOConQ4F4A5zMpoKmTc4Me7nqS9/lhKGbXmPqdMpwyTYv98Vbt6dwNiUW+CjuL3ta53MBqU2hTRBBWvmc9WeKPyTUTb8WPEHKJRODEVuSszLCXo3B9yWUZ6KGV2VPTvuftMflooh/piwqqlFZIG7DvaR03oDI36kdPKJKBamqKgGz7e03wyyyh+RrVsJJD2FHTBXEbrpFnWa4JEtY36XJZjhckkwuK3K8oCIbeG7/kf5ZoivtE9QwgG/qg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 03:15:08PM +0100, Markus Elfring wrote:
> > Finds and converts sized kmalloc-family of allocations into the
> > typed kmalloc_obj-family of allocations.
> 
> Can previous patch review concerns get more development attention anyhow?
> https://lore.kernel.org/cocci/71d406fb-9fb1-44a9-912a-7a0d270b9577@web.de/
> https://sympa.inria.fr/sympa/arc/cocci/2025-11/msg00066.html

I've replied there now. tl;dr: I already dropped the empty Comments line
for this v5, and didn't want to make other changes to the .cocci without
a better rationale. I'm open to suggestions, though!

-Kees

-- 
Kees Cook

