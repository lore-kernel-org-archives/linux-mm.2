Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D04ACFD35C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 21:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C35546B002D; Mon, 24 Nov 2025 16:50:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4686B002E; Mon, 24 Nov 2025 16:50:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF9026B002F; Mon, 24 Nov 2025 16:50:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9802D6B002D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:50:06 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6163C05AD
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:50:03 +0000 (UTC)
X-FDA: 84146843886.03.634BAF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 31335120003
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:50:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lg3mWYHU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764021002; a=rsa-sha256;
	cv=none;
	b=EbP1w8FGhUjSx7++a0lLsroeWt/RaN4hWGcSFkJ3JhFbvk/3KyKx3DIuPVq4Ogm8rXLsA+
	gyYmKdB7ZJnStCozd7p+VcS3UimD6PMIGhTOiLhPCgXQpLTgEBPUgYWV222TdjFP5mmByA
	9v+P3R/4NComEaojzHbRlYaPYJgkfKU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lg3mWYHU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764021002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0hYb0ckUgutJxmejD8lrg32Ts/OE3u23WLau20AsUk=;
	b=urhQtE49U3yceKB9rhQtiy8SA2egb8stZqWsSab5FnLUi0FdlomuVuP2eYYhJBneToH9c6
	rntGo47RcgZVnMK+CaTlTlr+KKvYYYstiHsgDh5jfXa+WOqW9ljGZwbZ1oPPfdY+ar+Rcz
	byttIN4/t04Lg7+SzNszm9pr4GUjHg0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E4142403DD;
	Mon, 24 Nov 2025 21:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1119C4CEF1;
	Mon, 24 Nov 2025 21:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764021000;
	bh=RXREYcS3eD9QLzWOuycj1YtfjQVIS/r94kQe1cH/yZ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lg3mWYHUHm+9sQe0h0IVVvf46zbWO/OKPf1vaPwDN2Re0d81XGYko10tNsXGhBJr3
	 4gZWIMWKu+2AhwVzSsVRrl8PKBSmz5mCqQR6dvytAXHUzKJuZy8Tb2R7b91w+015H0
	 LdwPoXWiJgl/t4YPGdLx2cBcb2FplZ/rM5i1yq/S3cF5cbqW63qKXbaNxxLKpMd7s5
	 cAsfJkUm4oR1MRGYCOsyip4ZPMP96+6VEJoV8rDWJhcnR5akI1ol/v9o/THTGoBHqj
	 QjAxOZg0kJW2wJClUpjBtMm9oqVSwupJO1crsUY4BBZlSNl5W0Fac1tkIfu1CIc/BU
	 fgbiBfdDHsAgA==
Date: Mon, 24 Nov 2025 13:50:00 -0800
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
Message-ID: <202511241347.AF6790AFB@keescook>
References: <20251122014258.do.018-kees@kernel.org>
 <20251122014304.3417954-2-kees@kernel.org>
 <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
 <202511241119.C547DEF80@keescook>
 <aSTKLsRNiEKtDqPI@casper.infradead.org>
 <202511241317.516BDE7B@keescook>
 <aSTRsIUPeT5EC5An@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aSTRsIUPeT5EC5An@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 31335120003
X-Stat-Signature: oefk5zz9kzxx7mib1hxwmrhpkdn6w6q3
X-HE-Tag: 1764021001-825499
X-HE-Meta: U2FsdGVkX1891gRrkdpJWMnydf5W5qhPu5GlFrIMRBBguzu5SfZ5QoGmkSGkvxHJpdo6IEVpdEklqlGP+HjA6QYeLaFVT3Bjq3nkvB07vnlthPtR/K1XALUFz1sXkMGVpkAcI6F6cxpD0CWQjTDJevVh/yA6/tarZxt7I8pIGhM88HOwB3giNriuJmpJk+feN9lFyfU+DPyEjEH3G+mfSiOgZrJ0dMfjgYPmSFBDEc/3v5xHxMLLWIwIYxTIZPQkFXpJiemqHXAKpNXQjR7Ntnsvp/dWK2pj7kHeK25eb3sCntLnpBWfxDJkZFpJChs9YjckOK6vXPTOSPNSY0bHHKOpQNwCV0oN/EqzLwyetpAOAoncyP2lUVmwq8Zf5KU4SoLnbEdpkAO6R4TlWxPjkaPqQQbn/pt6TMWU4xod1rx8KXfQU+Tw5IaZoh7sLplmkc+uQtp6f++tXOASATEWdxUWLQgiGkWLKWTxtnDoMb9UGgbV0UJxJTQrUO/MvTQG9RcUr8+gFPsiwYxzxYvJMvl45olIoPNYiiJfood9+bsil9w7PFqCkni5xY7XBpovWbYReTZQc32QihU7cdleUV24S2IrWHM1sktnhAlThnD3fGwwqYNUBV2MyD1M1w1SXXADM0HJtskDyR2UGI5/+B1BzmzFmpaVkRuU4HV0hhSnJXqXivrRs3+BhnOc3LlpVjWIqHY0HJxDZgy2lMu64r7dXiV7bDF4L/yCCWK/6Nth/AX8lwbFsuda07e1a7IKn6Xx1988q7DvEWA3dlY0+4LvK6/inn21vJPVSyeNW/LscS0W0g4jNSjx8Ibh055OJvv+m2KqGS+r1F22rQa4Aav9pSBIDfe+6XBaSlQ48EMijOW6NYMnSFunqAa6Lr0oU0RzgA8ImuzO9EAXNNLYogRnnbLrNXtSz+PY3onwgVHf/oELTMfGBEMnpf+pP+ZE0JubRzvQQnlHQZBp6nu
 +oNayVCC
 rDnjnmnctWm7L7hb3yRcMz/X9k7cNn22/euzmY5STZvbn6oOXosiiyKLa1xBsSjajTVDg07kESTCeAfQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 09:44:16PM +0000, Matthew Wilcox wrote:
> On Mon, Nov 24, 2025 at 01:20:21PM -0800, Kees Cook wrote:
> > Yes, -Wconversion (W=3) is mind-blowingly noisy, unfortunately.
> 
> This third one is interesting.
> 
> include/linux/jump_label.h:126:44: error: conversion to ‘long unsigned int’ from ‘s32’ {aka ‘int’} may change the sign of the result [-Werror=sign-conversion]
>   126 |         return (unsigned long)&entry->code + entry->code;
> 
> static inline unsigned long jump_entry_code(const struct jump_entry *entry)
> {
>         return (unsigned long)&entry->code + entry->code;
> }
> 
> The warning is ... not the best phrased, but in terms of divining the
> programmer's intent, I genuinely don't know if this code is supposed
> to zero-extend or sign-extend the s32 to unsigned long.  I know what it
> *does*, but I don't know if it was *supposed to do that*.

This is my core frustration with C: we have SO many things where we have
ambiguous intent. Yes, C may do exactly 1 thing with a given construct,
but it isn't clear that the author's intent matches what actually
happens.

> So I wuold be
> in favour of enabling this warning ... if we have a small army of people
> on tap to get the kernel to build.  There's 374 lines of errors to fix
> from the header files included by scripts/mod/devicetable-offsets.s alone.

I'm for it, but that is a LONG road. I have so many other hills to die
on first. ;)

-- 
Kees Cook

