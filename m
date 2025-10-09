Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F2FDCCD185
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 12:07:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8876F8E0090; Thu,  9 Oct 2025 08:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85FA18E0002; Thu,  9 Oct 2025 08:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 775578E0090; Thu,  9 Oct 2025 08:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 636348E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:07:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 04E6F5B94D
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:07:50 +0000 (UTC)
X-FDA: 83978451942.14.D344FDE
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1CEE71A000F
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:07:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FDbzs5zt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of elver@google.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760011669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+p3lQzk+If+FfstGkjdjKHCQavXIY1wiQDGCM90CDQo=;
	b=g+m9pAzOujBUjD4ux8/it6uwEbz8hFP7ybkITiUDUSfg8c3CJhFURll/ktoarlpevjkHCg
	5jIoZA4VmmgHXAPinDrOj7Q9xk5CeKVUQEfCnRYXI7xBL/B3tENjwyNn8iKGdg8DUaRhYo
	ScG1Cefqx4WNd2Ky5GJqXdpqja/4gu8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760011669; a=rsa-sha256;
	cv=none;
	b=j36fd0LxbrxK53fNbkMmESYbOI67XBQOTBOU5FPau60R1rIoPZwikCL+1JDi2lcfxbvK42
	fwrBYQsQFGCIl9Tg4N2rffP7XXmbEozmxdgzkrIBP0z4XFZBvtck+NVzZpSjRBjcNksikN
	mW+0Ek6rj9L5Lze6TILJx8c0IWpjlu8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FDbzs5zt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of elver@google.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=elver@google.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b6271ea39f4so561966a12.3
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 05:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760011668; x=1760616468; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+p3lQzk+If+FfstGkjdjKHCQavXIY1wiQDGCM90CDQo=;
        b=FDbzs5ztAhZo2lcvdnCp1Cz42bPqblYFq1h/CDtyvOGKLJWZgm3uL2h5OyBxlZK/sN
         xvTAZSBPRedXB1Z7axNstKRs7LCYW9LgPcv/IkJTcbEiE/CsE08P4pQZpMdUf9C2ADdI
         nfLSUQMh5LodNejy8vGbjeSXlQ2RsqPsq9b6QaDuY4d0C37Gx+6zuJq9sd8RtSEq6Zuo
         Ou0afNaJ2j75pc2ijOf/VGjckL4GP0MeLHeJ+vaHQayL5u/o989pPSoqQFHdBQz9k1is
         d7DAoYsFyz/dcjbGxrUW55i33O9D6Aij8qiyPpDM/bhiBXhDLlk1ZKvtSd4a3nYan0cY
         IYzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760011668; x=1760616468;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+p3lQzk+If+FfstGkjdjKHCQavXIY1wiQDGCM90CDQo=;
        b=w6YVeL/CZzRWFcoHf1DRhlfCrDeiI16SLjj9uXLOqo82rV5HU6XyYy8cVWC20VDdKW
         COgeu6yacBiMYf/7vEIfLpFHNgTC3H04idJIFX8TcTfzb9BATr/juc2xj+LM2RT/+uGp
         xRkIN/WaJhKu9ciZjlJgf2XMqyPW7uknefeyz2JhUWvLV/kxgUJuvio2t4bUaBClH6LJ
         YW1sK6FIso+1TCFvVXKwMCGQPZYvDJDvaiKqpYlAjqoHZYR3701cHmlW0RRA/FllTDNY
         3dXO5aT4w7h19DGwST3Qtqw7EMNamvLL4u2+VryOuVW1XhZlBf4kKrC9CVR3ECKSl0pv
         am/w==
X-Forwarded-Encrypted: i=1; AJvYcCXDsWcmCEir4JXKm50W+85cMICdpWexaEOtSKkrNtXEkS/AeysAkf8m1HQX1LvVBObW4succ1FxeA==@kvack.org
X-Gm-Message-State: AOJu0YzFt+9vxiEmiy+gvFHuHMFBmvGB14/24uXomeADPTVcBueky2wm
	WIKe+1P0tLdRgsf6tHrYHQB81HSS+kWzu863L1fbDra8QlQtAKHKjOcDGN/w/AKuViuAGY2WxdR
	xLHcTwMTE0WyKvJG4KcKLUbLvTPtZb37Qpl2vapbm
X-Gm-Gg: ASbGnctieKsN2EU7O4INDQKdxPG367cYWXNXlcUJQfeYZUz9fBq6tQcuzGa8VlardAf
	7UPG89st7q6pC3UdG+94/FqWm2axzpc2D77dSeUKjGt15MUfQk5eCgr1dd2mzI/ldJT0nzOn0PA
	XZwv3uzM+KNGli+3V8i4ja+t2PMNRM3dQ+Udd9yiDQtOBgy79WbKPZxCeGDAK1B4OJduGVrcOl4
	zzEybC+2c6w01nC5QKXpwLNnKV+NECgy1i30m9B73mzPgbvriFUMoaxEWQ+bGX/+Uzy
X-Google-Smtp-Source: AGHT+IGK2999Kxnf1WRLkrVBgJlG2sfTe8NQQmLvAYHDshQ3OJDYVTnqzxr7Hq0u+SA2CL8Dip3ynt4DcSFfDVGoOE8=
X-Received: by 2002:a17:903:2350:b0:27e:ef96:c153 with SMTP id
 d9443c01a7336-29027379a5cmr98765325ad.19.1760011667351; Thu, 09 Oct 2025
 05:07:47 -0700 (PDT)
MIME-Version: 1.0
References: <20250315025852.it.568-kees@kernel.org> <20250315031550.473587-2-kees@kernel.org>
 <aOR15Xb6DfolYM0z@casper.infradead.org> <202510071001.11497F6708@keescook>
 <e019c59a-ba8b-ec04-dc5b-923cf9dd9d9c@gentwo.org> <CANpmjNMsSGY+QEn=GV8S2sXuuQsioikPR+OhGa3+6EoTqYPkHQ@mail.gmail.com>
 <202510072114.52B93ED736@keescook> <b17ab23a-b0fb-4fab-afa9-41dfce65675a@oracle.com>
In-Reply-To: <b17ab23a-b0fb-4fab-afa9-41dfce65675a@oracle.com>
From: Marco Elver <elver@google.com>
Date: Thu, 9 Oct 2025 14:07:09 +0200
X-Gm-Features: AS18NWBVVE-SSQe4ScCSB1Ze0NxTS0A8p2TAsqA4RTj9KK9B9ZbDa15oefynRbc
Message-ID: <CANpmjNN3UH9vL6x4P29MjSg5L7p3aBScGv5tY9ex7N-xYmqrPw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] slab: Introduce kmalloc_obj() and family
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Kees Cook <kees@kernel.org>, "Christoph Lameter (Ampere)" <cl@gentwo.org>, Matthew Wilcox <willy@infradead.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Pekka Enberg <penberg@kernel.org>, 
	David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, "Gustavo A . R . Silva" <gustavoars@kernel.org>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>, 
	Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>, Yafang Shao <laoar.shao@gmail.com>, 
	Tony Ambardar <tony.ambardar@gmail.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Jan Hendrik Farr <kernel@jfarr.cc>, Alexander Potapenko <glider@google.com>, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org, 
	llvm@lists.linux.dev, Matteo Rizzo <matteorizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Stat-Signature: 3fbr4itbdkiruxm99cubu33ofzyet7qt
X-Rspam-User: 
X-Rspamd-Queue-Id: 1CEE71A000F
X-HE-Tag: 1760011668-144598
X-HE-Meta: U2FsdGVkX1++4aGU/O3EoQzq/A3du1+2f+UY2gxOaeuaXpmFiCimsVausfLh+ELg1Dba/I4RMTZOg39AVkkVxOL6OhJQupkPJpRYm+uPEALL00ljS2StywTTtxFOopbMF5W/lk/XwWRXcART1zU0E5XZi3Vznijsxp8q/r2L31IkuvNoZQwCesXhg6kHu+djGQlFKfpn3XKv4dhwrsr9RAQp3FZkvPy/3sUzUxeVdVIOK317aAX3geHVnr6YtM8BRvL2+DMmTU5iR5YHvcu/KzX/lZjkgCqcDPIFGelkDe507RDvE+TlMEo8p77DYdAswgLnBdeuiwS/u3/j5pVcw34BR7A6Ho2G+C95CuzFqVTcPXdgGZA5q4mHicXxzpqoRYzTHl1tr56kiDn3K8Y4lp2temZ875lxmqujFE0dBZA4toul1Ndi1krPK5h8TuJpbUN7gGOEj/ZH7FTvNZZjLggYpL5g1iLEbuXfFBv3703zJwhGew519tCyyxPEqVWRojoAtsR25xVeE7AVZQ0x523R8yy15jpd7/ola0MEMVwj7lb175BxgsBwBtWE/tvTO0JrOu3fAZaLeq0FAqxVpHmGEJP94dhs7QYVEAoCqSapWNbaj45/IewFHp/KHsLqqPc9jv74vkRv+WkACcWC8DDxqtTCvWi/Vie+Gw6thvzALyNz7ttuer801hTljqGkrREJo0IpGzX2mxW8u4fIM0OE0lTpl8R7WnNIu2ElKkmzg0zq/5wkimpdYesiFykvkUb8DZda6KT1nFWNPyVob+zU6epIufuuN4/J0Cu/hTPDR5eeEkvonyXnHPATmbVaWaWN0EiwAMY4rBFnup17UzRDM0/0CSOUiKVKmehgMUh1I5j0tVVg8bPYx3eknaE7AfNNLj4oW5UrEvFnaQYH5UDfd2+9WDiriG9j7FpIWyf1/8nQAyQ0cN4XshZVbPh9tVkvsVT642pm6G9dJVI
 evNLVFJM
 Z241RIHVJwuGejZ6sg/P/wx8nIpl6JW8TNAAIYohUJUidZ9Dw9mq/oA6k/sPA53MOxLporZvo8E2+nIoUkhKPxqIXTe+CeABJdBP7m3x2L2I9pthy3TXFvBS0hZDLU8+4KOa554D5lOF3I6QXdziXyYwtuQ/cmpGGUosKWq5Y/+yG1JksQ0EXT80FRzrTTSHdJ7+br6p3qNj4/5Lzat6XgtOR47rEeFB+l4Zpizcl3Q6ltcMlpn1RsMqenoLcvIXNwibjAZaSWXXappASsz18qJH0vl9dGf7KtrxiYGpqCfOHishnaqrH+UcRjMdIjdUIuoD7y1UyeBdf3Sc5ourCpfS2hfOkH60dhefLiQJ6MO43NZl1TqCVemY4w9ePqjflDf3y0jGZkvUAG9HVV+9TOMm1V9aPr9fKZYUXusXGEciiKBMAjVed5ObkpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 8 Oct 2025 at 09:49, Vegard Nossum <vegard.nossum@oracle.com> wrote:
>
>
> On 08/10/2025 06:20, Kees Cook wrote:
> > On Tue, Oct 07, 2025 at 08:18:28PM +0200, Marco Elver wrote:
> >> On Tue, 7 Oct 2025 at 19:47, Christoph Lameter (Ampere) <cl@gentwo.org> wrote:
> >>> On Tue, 7 Oct 2025, Kees Cook wrote:
> >>> iOS did go the path of creating basically one slab cache for each
> >>> "type" of kmalloc for security reasons.
> >>>
> >>> See https://security.apple.com/blog/towards-the-next-generation-of-xnu-memory-safety/
> >
> >> We can get something similar to that with:
> >> https://lore.kernel.org/all/20250825154505.1558444-1-elver@google.com/
> >> Pending compiler support which is going to become available in a few
> >> months (probably).
> >> That version used the existing RANDOM_KMALLOC_CACHES choice of 16 slab
> >> caches, but there's no fundamental limitation to go higher.
> >
> > Right -- having compiler support for dealing with types at compile time
> > means we can create the slab caches statically (instead of any particular
> > fixed number, even the 16 from RANDOM_KMALLOC_CACHES).
>
> Maybe I'm missing the point here, but I think we can already do per-
> callsite static caches without specific new compiler support:

What we want is not per-callsite but per-type caches, possibly with
some smarter cache organization based on the properties of that type
(does type contain/is pointer), where the latter is required if we
cannot have as many caches as there are types. Per-callsite caches
could be stronger than per-type caches (with the exception where a
single callsite can allocate multiple types), but neither per-callsite
and full per-type caches are likely feasible due to performance
reasons. So we need some scheme that allows bounding the number of
caches, and letting the compiler help us out with type introspection
is probably the most reasonable approach.

