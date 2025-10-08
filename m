Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65DE6CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 04:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 907AD8E000C; Wed,  8 Oct 2025 00:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DFC58E0002; Wed,  8 Oct 2025 00:20:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F61A8E000C; Wed,  8 Oct 2025 00:20:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DF148E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 00:20:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 01F6F58B58
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:20:19 +0000 (UTC)
X-FDA: 83973645000.01.D835E7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7098F180006
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:20:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J6CHq2N3;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759897218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yr7z8PhZygVSoS108WVvwngH/9alXoXTbymUYSPCbfg=;
	b=oKGUtcDMSYB1+GaQ8gGLOYep4C2KjOhTH5EFe7vCB2qTYOq5Pg/hXW9PByzhs/HQOfJfm1
	9lk+eRQlnEDEe9n4tipLaJAj55DiaCWwXtXv0++S4ebzdMWZKGd36Qgn+LSxrPxjtm7aKL
	MH89RDdNOGVyMsDYE4j3F2RfXiFpIpw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J6CHq2N3;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759897218; a=rsa-sha256;
	cv=none;
	b=UXOfH1KCoDLTb+ZFB+eZuqZMLIWA/XlJR/oheVJVz70XwKsfKENEwOPIc0j2fJ9BBBu/op
	TFzeU81SioGsSv643GLBy1twaQKraj1qqO63J6uwKID8a4ViXc/ueRGQ724ldrbx/V6uSn
	0xpcXDwgUf8kx1ifIPz2dVsYMqjmGKE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B9D0160260;
	Wed,  8 Oct 2025 04:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2A7C4CEF4;
	Wed,  8 Oct 2025 04:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759897217;
	bh=gIXJCsumt6skJ3sfqf5pbZAzlXWzbFT/QpJ0QJ0WoEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J6CHq2N3l4B147CgJt+zLqKYq2OtHwUWOsO4RanJM4icby3afXquF+ndgYR6fOYWP
	 H6OZ/NXfzhSG3ZWIrXgmRzfzJY6TdzUbkHIqcFx9jRuywjXfZ30C/ThFcJTssakaHa
	 8Pl8ETsSK4AyBuzZstrEd3Z+lNP+xUGQozD3xFAuMI7GnQHPjOrN8VoYC7s+PuJIdL
	 Sl/LucC+GWoVX24kZ80gXhCu1Zs8uXu1c7fSbZPdvVAmGxtpf/98jY+G3TKds5KbWT
	 ai2+dQBiC4bZTzbrfJnZsICkltmpxolSNNxBAdpghqjU9ZLCyE+8IndaxY2QfLJdx4
	 9jMu/5qAYT2JA==
Date: Tue, 7 Oct 2025 21:20:17 -0700
From: Kees Cook <kees@kernel.org>
To: Marco Elver <elver@google.com>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
	Miguel Ojeda <ojeda@kernel.org>,
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
	linux-doc@vger.kernel.org, llvm@lists.linux.dev,
	Matteo Rizzo <matteorizzo@google.com>
Subject: Re: [PATCH v4 2/2] slab: Introduce kmalloc_obj() and family
Message-ID: <202510072114.52B93ED736@keescook>
References: <20250315025852.it.568-kees@kernel.org>
 <20250315031550.473587-2-kees@kernel.org>
 <aOR15Xb6DfolYM0z@casper.infradead.org>
 <202510071001.11497F6708@keescook>
 <e019c59a-ba8b-ec04-dc5b-923cf9dd9d9c@gentwo.org>
 <CANpmjNMsSGY+QEn=GV8S2sXuuQsioikPR+OhGa3+6EoTqYPkHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNMsSGY+QEn=GV8S2sXuuQsioikPR+OhGa3+6EoTqYPkHQ@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7098F180006
X-Stat-Signature: wund5s91519nwinfab8n1udx1t8izfba
X-Rspam-User: 
X-HE-Tag: 1759897218-745702
X-HE-Meta: U2FsdGVkX18cTms0l3c8qJn8rKBXItjfFS6Yf7Ja8NzlJI9MoaptMQIJee7Ms2kUcOrQ4lAKOSKkCZoJ6hpVpLEyIvtq7yi/rCjwYllBF/ypJKlFHxs/e/3Jijh4KqDsdvddcVX0PVZN28DJ/IyJlnRhdeD3qGLApkN32NiuohRzyIcg4vgYrW3VG7AvFGv1No3u0XAZMeb4AQ4UYQpY+jNP/lKK8sULWiIVHq5OjyqWE61OzcI1pADdny8DcS9uq3DD7odt6kXopchxTmp9/k30TMHt2eoG42GQv9L9WhCALGQ8Wh/nALLUODCHKJjqqjvpV6PJMomf2alXwgvEuJ7uVL+qq8r9x65oQgjGbpjn80cQJxiEuifF7B9xDRJd6K0H4DlbQ0W7NzyDuSszotMWCJ8yOQrDWW+jPis/Q4IXs+BIHxMypyEUwm/NKllWPA1jwGXuJcO/Xiytet5R27aHdrDvx+1Ae8Dp1EUL55gTdG64dePz3XidRg2f3LlW3/VQOB5Yn3Ok6M3puhCg/nf9sNq5A0rMn9IIRxzfP6rf+Zd8PpfbECbwkyLEIo77WLJ/24bCNSsfeRimnF4o2W39GmP4qA37hsb2Cqu9E3KjV6FXcTBz+WHgmQ/G2eEB8TBVJqbpkGIkkbbpnAeQQKtGQB9B6wkIVUPljwvZzi/3y7GO+6UBEf8jjiOe6fjONLDC76/0MwJo7E0/qnV7B0w9KwMX8I8USA7PtVBolccoIR1FuHHK6eH8utWBcv0z6kdnGg21MfMjQvTmc/JLJ+XIx1w278mM7v5EIbFRP4t8Hs/STQ4YXENXETgQ9GBCOqa84+YkqKut+ZweyNWYkrrExaLvkr81oVQbWZTOHZQPuUwZJFxbe06DuTH6GEr/7QSaIZmFIKlHYLhrMQm8ry4tpqVoYrJx503R/P4pQs8iJPoOPXTeDsJ10alrIpylHavH6rHQDdIwm5RNQwP
 UrKST9P/
 2ohSomtPXDdPdPLrvX8U8FPQkD1o3ItTkELMWtMa6xf9fSu50FOMBW6S7QnnvCaEsiMyl6QvUDkjMbdkXMEaBEkm7AKGgZaNP64rjkaUaS1jUj9BRKpjvRmPi0EaS5oTQhSBWTHAGdE+/hCpkZtHfQE/lhynZJCKZU3mMJFMU111fRSzC31nQxXRtxS0Vj4cPwYPNZb18jbfcT+vVq/ehVQ1C54sIRa6BJGrVBHC12NeiTL+lqwFwj9O0SxSKXsS01+zq08A3kogCtIOI8UbsEIXTrsxksWBmMhZZEN467XWGAI0rIymjfgGnPUVT1l3OH4d5bXfk1bV/MMJ9kZYYYLzrsA+Rebr2++N870gK3xeEiOIVpHarf4TvpwKLkGMLlpxWNTU4uhHFUax7jIQxFgSQyR2rwb7gdS7Eqd9sNtsxpfHI866+fbhQAtlvKZ4856NuYYcKspgvd9zWUUUGGJO4YmyxLzZnCtkydZHqXF9AS/esrKcfYnts2e6xrMUBrB+E2h1AqGWnUBOPn0A/tv0fAquTY+UaKRXlnw6N/BRnR+aToA+Y5T4wMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 08:18:28PM +0200, Marco Elver wrote:
> On Tue, 7 Oct 2025 at 19:47, Christoph Lameter (Ampere) <cl@gentwo.org> wrote:
> >
> > On Tue, 7 Oct 2025, Kees Cook wrote:
> >
> > > But all of that is orthogonal to just _having_ the type info available.
> >
> > iOS did go the path of creating basically one slab cache for each
> > "type" of kmalloc for security reasons.
> >
> > See https://security.apple.com/blog/towards-the-next-generation-of-xnu-memory-safety/
> 
> We can get something similar to that with:
> https://lore.kernel.org/all/20250825154505.1558444-1-elver@google.com/
> Pending compiler support which is going to become available in a few
> months (probably).
> That version used the existing RANDOM_KMALLOC_CACHES choice of 16 slab
> caches, but there's no fundamental limitation to go higher.

Right -- having compiler support for dealing with types at compile time
means we can create the slab caches statically (instead of any particular
fixed number, even the 16 from RANDOM_KMALLOC_CACHES). Another compiler
feature that might help here is getting a unique u32 for arbitrary type
info, which is also how KCFI works:
https://lore.kernel.org/linux-hardening/20250926030252.2387681-1-kees@kernel.org/

My main issue is that I prefer explicitly exposing the type instead of
having the compiler have to guess. We want it for more than just slab
isolation (e.g. examining alignment).

> Note, this mitigation is likely not as strong as we'd like to without
> SLAB_VIRTUAL (or so I'm told): https://lwn.net/Articles/944647/

True, but both "halves" are needed -- SLAB_VIRTUAL isn't as robust
without the type separation either.

-Kees

-- 
Kees Cook

