Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3437CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 18:19:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8928E0007; Tue,  7 Oct 2025 14:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E68948E0003; Tue,  7 Oct 2025 14:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57908E0007; Tue,  7 Oct 2025 14:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0EA38E0003
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 14:19:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65C3B13A477
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 18:19:08 +0000 (UTC)
X-FDA: 83972129976.26.EBEA46F
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8EDFD1A0007
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 18:19:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UFYfBTNM;
	spf=pass (imf19.hostedemail.com: domain of elver@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759861146; a=rsa-sha256;
	cv=none;
	b=0QLZ3tDXqXxBnF91o7TeGGzE60PLHCQqLpe42hLbbnvx9B4VvsYFdaEI3PLMHLL5mrDqnA
	ImxzJ+oPMQENOFn+jzfrv8AEMX6VlyRlrYRGGvzstRUkQd4TgRYBSnYQ/umlfVEWS/X/j8
	NL/bKdnY6dEuMM4yOac4YKXjQLkteJ8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UFYfBTNM;
	spf=pass (imf19.hostedemail.com: domain of elver@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759861146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1NYA5NXCfUNHGAMPIDINqsi5FPnYmleHEw4ndZr/cwc=;
	b=A9KOoh6Q67GtXyGiVca2PLnhAtCkekpJQT4DvGNVbfTc4E8Zpakb1bwLKLAhO4uWgGBwI/
	k2pbxYEEp87+McwQ+865erJJEgjdYdTS5UnyRCDWsMLE8AgUc5Ucm1yFkAV+apeFuq8PWr
	UaN7PwFshYVduUjepvHChh3hNqtN+cU=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-27edcbcd158so86234195ad.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 11:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759861145; x=1760465945; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1NYA5NXCfUNHGAMPIDINqsi5FPnYmleHEw4ndZr/cwc=;
        b=UFYfBTNMxHz8R+6lqyZXQMRmXCOAKFDMAAm42/9LcEX2Uee8o5tkJesKYAPPm3JUv9
         xSW+g1xMvCxFa9y82W0M+2p8XzJiII2CBQLbRcLAba0qjsZELE/nMeghRtxAkejaXiR6
         d7/h/GrM1+QKT44dOR8070VzTQI5AB8bPqJzZZoKWom4zTb/gFCpo4RmnE5BGrDIPSjx
         45bOmhgBUc3sD77+V++/a1OZIWY5DT8ryf+HooI5m8VncWLSFKIRC2wZx+g6jqRIyQao
         5zHsI5v7INRWPTydl0LCo/ftjqEDoCS4KVxz17IO5JD/e6etRDjpekJO5W56p7k7OMmZ
         2uPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759861145; x=1760465945;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1NYA5NXCfUNHGAMPIDINqsi5FPnYmleHEw4ndZr/cwc=;
        b=SWivn8UYhmYcFtJsvu7cBKRn26QHszxnff3y6q6KDd9PkMVIfYe1YQEwfiT+c678D6
         4n22jmOt7JHTgE3uI+fxDpt56jPXz3M8Nv2Mi5OYF8+052WdUOvr0/Y7qLOzDg17Qr0e
         TqAyb5Ptb+O6hMPb3t/avH2fbKmrQbo18cHSgiz74ZNxHrQRgO+WvVmCqFaWOtuFf56x
         0iVoTjHu7RXAHxRX8jLsYLf6Huk/G/x+w5ajNCO4YKWGrQK7aRXkH9n6FZccNnWt+Jhv
         fdXhsYbNLuqCY/U+WZqUVBtbw4F4T+lgAD7n3i0bSTWGWIMl7uqA0oHvtmwjht7a3+fd
         UcUw==
X-Forwarded-Encrypted: i=1; AJvYcCVLJK0OHiI2TBrsS2JvOrNBgGa8qwd5UqW1FtfQVJZGd5srF4H6txkQPZGJfbds78i4Zo6Wu4+p4A==@kvack.org
X-Gm-Message-State: AOJu0YxI56JyK/7kh1WOodzVYECEus9MHSLxKjLViZ/g0T659fvOUWXD
	NmtljFNJOuTnRSrsj2dC/BvjGCQCgDAsVpbgQCmdTgQl04K0Jf74FztQ4YsYvuOkFH3bIEPnrrE
	YAGD6dozXTh30XYSIrJ3meKp2BWeMzbwyHGFhV93K
X-Gm-Gg: ASbGncuF0iWvbFStrP+xtN71oan+4W+1a/8GUnHvQGMQIoEnutwa0h0tykaEp+se1el
	7SATxI2VFW4NVSAYv4chcSoWBrs3+cLma0Q2L5535a/lATO82ymBOLU8XzoyxQnjd7k3ytgIh/d
	iLpGMJQWvNbGuzSn5K2kqvjr6P8zkTZgV5AMCGM8FfVIDoHg92jCd/ENvbTyOHJ2UgIhrTFSmKq
	Sbl3JzH3eXBMYY55G87EdpzgOqE+qUD8v0qUnkkCMDlQCDMio6Pvp3gtz1hBKimeF0fFfK9ECWf
	ihc=
X-Google-Smtp-Source: AGHT+IHw6dFIKAHzPTv9mVtUGHjBlx7WlkdXf8MR1ZgGcxSTfN3zEfUpxsIIe3xlxd6CYLBEcLBlT5+Vp1Gkw1TXYKQ=
X-Received: by 2002:a17:903:2343:b0:28e:7f50:5d80 with SMTP id
 d9443c01a7336-2902721336cmr7056975ad.7.1759861145158; Tue, 07 Oct 2025
 11:19:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250315025852.it.568-kees@kernel.org> <20250315031550.473587-2-kees@kernel.org>
 <aOR15Xb6DfolYM0z@casper.infradead.org> <202510071001.11497F6708@keescook> <e019c59a-ba8b-ec04-dc5b-923cf9dd9d9c@gentwo.org>
In-Reply-To: <e019c59a-ba8b-ec04-dc5b-923cf9dd9d9c@gentwo.org>
From: Marco Elver <elver@google.com>
Date: Tue, 7 Oct 2025 20:18:28 +0200
X-Gm-Features: AS18NWCHLWcuBl7emRjgyAd7xCJevIo8qneqm5GOzEKlmO2F3nZsj3gxx6OmYQU
Message-ID: <CANpmjNMsSGY+QEn=GV8S2sXuuQsioikPR+OhGa3+6EoTqYPkHQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] slab: Introduce kmalloc_obj() and family
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Kees Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
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
X-Rspam-User: 
X-Stat-Signature: dath1mesaak5rjp9bmkckgmx1fwbcx7d
X-Rspamd-Queue-Id: 8EDFD1A0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1759861146-666703
X-HE-Meta: U2FsdGVkX1/ksvTXlc2FayiPSUW5O0AwZ9li92XUnjxrWbK6PnFqkByMrjkZZno4WmJDO5NHp2bHnnDSJkpphDk7d2N1s5HfxnDzDJA1dsQ20/K1L9uj8i6lSJ7/K6l9g7CbsHT+jKQw3jfvjkRNeGEKZO4GLrXlJZpCJdNOEu6IXmy3648AY80AtH0xQRk+mCxOKA6oFiVjo53wTftW+C8R82yUQoKay2H49fhBe13qV6YE/DUCnHMeCKC6573jN7TcU/PksJCwz5OE+B3nQygAfKxt6QbuFVTz+3q0a6oMRz6eDDDfkNiF0pMXCLwwBjRWcQCYVZp7e7PuETB6Mnpz5a/M6D/yjKGu4pMpN1m6EzF5IGYHRM/V7vm9XFDu+go6cAK5kELhS2VdJ/wmiw4uHQ5hkjwoQWAKQxz1FtpHDp3fReJFbOe/CigXDETeBbRUP1K8J9aLhTpb9fZSaH62TI8eZyV2t/LBqL8XqIeoOrT54xKCBlZxf0CYRHjcCZAqOYEIFAFHoydNkdw83/ipCMsT9ItIQCrvskjma5QNYgqCv2UHQFejyuWxy/lITjb6mCCwXGd094IEQWqozPbV5yAiRK3jiOwv6LycreVKudADTNBUd1krNueVX4iemIMrTOrGG8LF162AkOJMNgJvc1+xAV6DE+xCIlgTbUdWPN2jsuuTp43NJ1opReJJ66sMtksY6e/3l9kc444B7melCGd5YOUjYGCnPygXRMOicakfBNjYEPlr5xpyV1DY/AatoE20A7TOObT4QEmg7iHJkKUylOADo6zCSNmlVtQ2bgB/k3ddvGgV7i2mV3v3O4bU26OSjGSQ0s3jGN8eXhyP+bvdUyRoQ2v69voeDw1wRHItYQ9pLyZC7PHC9tSv5Qwf1s3cXS//r4Svf4T3jm0vy16Up41h9DaV6xIbk6WqWhCZQTs7u4gtLbJgOM9oYArBSvDvjVRcK+1ZV9L
 V60d+3Es
 bjGyMP62iTGnN+tn3O7M55nlaXcuQsGFkmJE9OmGfJC5JXhUqSXcOhBDZnIrIWtNsXEz/04czrSvbrROzizwKtd9Cr7KrZbS1fFVaf1BINR4Uf4FyAzPKhdAZ4Dt6/x4xX5L6OYZI/kspstuY4hVszi/4ipqpU87t9sS6Db+MEZaDjzI5dLpFMl/hhgzHxEynu/TMs2kyAtkfRBtyfJuenujhqiALfeKUexgkhcTjxEMAa9z3WsLGUKLiKg4Xk3EyjVO2Po61nUK3kmI8bWx3c/gWn4ld0fupsEbj9Bevud4SqcBYR5r00vs5mX/jBYlvzvdjmSbIAUcXR6oOl9NQTjw63QP4ppuaJpFRplbNassyN/+qyTxYlwk3Uz0sjTl8IW9uJ/4i8t6ZZf70gjYl+WOW440sFnRtNNaQT9cHZZ4AGUll4Ay8EmPT2/FlPPl7aD1qkS1WklXNa/ePOlOjgkNxhQJaa6Jy9QZYGwwGtgPEXRppaB7SnDIi88mYlSy326/eCQk4FMoE7UyFyhdblqNPyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Oct 2025 at 19:47, Christoph Lameter (Ampere) <cl@gentwo.org> wrote:
>
> On Tue, 7 Oct 2025, Kees Cook wrote:
>
> > But all of that is orthogonal to just _having_ the type info available.
>
> iOS did go the path of creating basically one slab cache for each
> "type" of kmalloc for security reasons.
>
> See https://security.apple.com/blog/towards-the-next-generation-of-xnu-memory-safety/

We can get something similar to that with:
https://lore.kernel.org/all/20250825154505.1558444-1-elver@google.com/
Pending compiler support which is going to become available in a few
months (probably).
That version used the existing RANDOM_KMALLOC_CACHES choice of 16 slab
caches, but there's no fundamental limitation to go higher.
Note, this mitigation is likely not as strong as we'd like to without
SLAB_VIRTUAL (or so I'm told): https://lwn.net/Articles/944647/

