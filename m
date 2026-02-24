Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C64EE9B250
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCCC66B0088; Tue, 24 Feb 2026 06:11:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA4A16B0089; Tue, 24 Feb 2026 06:11:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CADDA6B008A; Tue, 24 Feb 2026 06:11:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B3E7A6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:11:57 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 81AC51C577
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:11:57 +0000 (UTC)
X-FDA: 84479085474.15.664CCCA
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id 920CB140006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:11:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Gl3o/gV5";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771931515; a=rsa-sha256;
	cv=none;
	b=wiAYHutL/UPtpBONZd3qnebVsGQD1k2WkFF7Q4yayja0iJb3kbnlYRZTDPi/xM86GxxYRQ
	ybsSTGtGiSaje3Kx3e4MmHLzlOjbhHtN21pkBKijSUEKhJUtP2pL87o3j+Y7lDKICOXwp4
	ENAtmFee/5dMnqbjy6wbA25JoFkIfW0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Gl3o/gV5";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771931515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UwqR4mogOeV02cqzMt1+tF/fnlUYylAA5gPYZ8oxqZQ=;
	b=H3fZSucX0YJU8aR+evbZ3Tp/xubvyolrpDkKDnpVq2pBdQtXC4s/hxwIeaUsCXFpWFN96C
	79YQ2hg1cS4/yX4am4bu/JOyxUD29+6pKV5gOnpvVFAt2wZcsQm4DkHS1HZ6OLo6lX+Lfz
	87ttD81IjBJskW/NsalB7MO7cxvupec=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-483770e0b25so48435425e9.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771931514; x=1772536314; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UwqR4mogOeV02cqzMt1+tF/fnlUYylAA5gPYZ8oxqZQ=;
        b=Gl3o/gV5/bmOtFJ2XV5hsC62USqEfyoIRYk7Q5yenUaBR/6ihjDOazc0+xZHfFA6M0
         SDW+hnJxHBi8J6NopLQy1PNZnhCXx/8pUTjgyfXBoTXcxU6ucYjfI7fGJOP72h/TA/Kx
         2OjIlOOobTpHrSJyZHMXMg3H+IeJBamvreSd0XAjkETbCVrKakXG1c+gyAtDK33j99+R
         ZefxL8qprmx4vv49blROwsYWy9GqBkgAgUXlt36tjL27HHIhWsmTINVhEBtQHqjseAAv
         vbLt/abYlFnH36ydZ67qBNRPNaH85Z6TGzNEkqxhwVfMS8bNiES4a9v33T+AKPbZRVXH
         aPHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771931514; x=1772536314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UwqR4mogOeV02cqzMt1+tF/fnlUYylAA5gPYZ8oxqZQ=;
        b=Im5h0FxenDti+ml+f+bUaEku0wDYgV9EHKvUJbovKdQq6oyDjs2gEaLdhMsO0bwg6j
         Q/H2aZjsQ4zpMFnczY8wWJ6B8WOSEXkMJVDxTTekuAmBXlb9wL+VK8IWN0eV8zWT2Mi/
         P+d/vsFBcFbyy7BA7tYgvsHKb7S//HxcNglSHA/YGuc2zb8IFizLQzDVEziTrCB9Ua0I
         RfopZKRD4bpe4O3t0ehUyEXAdrjUyinVYtDfFsM7EVF2iryISeW/9gSq4dFYEMI3CNDu
         So0NFT57Ywlm5KWZ9uNl/RY6QbpLOBRjoAlYCD71HKqXhmq+OFWuEjkUIzWxm/x9QFVT
         U+zg==
X-Forwarded-Encrypted: i=1; AJvYcCWFtXMcnRNjLeNs8s7uy7TJ6lRsHR+HbkplrklJi35nQAbXJAI0gpR+3d8Z13MS4WiFs5fzUnhAig==@kvack.org
X-Gm-Message-State: AOJu0Yy2n3894vf5K9zTVaV8Su0HN8UMJ6bP6NnPZL+dY9Czc9FIIGwL
	aeGUyq6x0Dnh2sXYZYfb8MsXWf4LPgwZd4eZXQe/APAie1Hu6wgmzGPl
X-Gm-Gg: AZuq6aJYJ3li9AxW9nb9/X4ZRQaJ6WkG74a7nOKdiNi0Cpk9yX2xkd0Vys95QH3wmZa
	kVuTv9KZM8MWMyBcmvRRF+pz3Dd92QOWMSK5Wi98gERDI9w7VSH17f2tqAM7qKN1C4Up9BExqiK
	D5X/T1cAsO9KF+7oIRVpDofeoYo1Co9NhnM1XFs3OxT0qoKx82DA+l9M5l+U4ih1wLxjIWHCGfh
	wJe9T7wW6mruzeDcL3HKrx3+8Y9Y6FAmjadqvQI6+v9/3jN3qVERG9IXBNTzRVbuKKAlud1li0n
	x7HlRK7YfzAb+lrpamKVlqJDmt8JgOYdzaAgg5WD61W9ztKw0T10tjBiUTz+3+qtOWDMajrsJdb
	A0bzusmQuQ1JwQrAOdi3ZKujF+rrxGrIhcq5PvMvB4yu3iEPpqArvmTp2qnnkOg8rgHno0f0Yw0
	HNOe8ITm5w3BeUuJuR/j0C7TvwlW9VcSUnTpkJFwMe7NCsoz7vT0hs6yIFRf6ejXqG
X-Received: by 2002:a05:600c:8b16:b0:480:68ed:1e70 with SMTP id 5b1f17b1804b1-483a963de73mr263902315e9.35.1771931513686;
        Tue, 24 Feb 2026 03:11:53 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a9caadedsm216756765e9.10.2026.02.24.03.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 03:11:53 -0800 (PST)
Date: Tue, 24 Feb 2026 11:11:51 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Jonathan
 Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo
 <harry.yoo@oracle.com>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 Miguel Ojeda <ojeda@kernel.org>, Przemek Kitszel
 <przemyslaw.kitszel@intel.com>, Matthew Wilcox <willy@infradead.org>, John
 Hubbard <jhubbard@nvidia.com>, Joe Perches <joe@perches.com>, Christoph
 Lameter <cl@linux.com>, Marco Elver <elver@google.com>, Vegard Nossum
 <vegard.nossum@oracle.com>, Pekka Enberg <penberg@kernel.org>, Joonsoo Kim
 <iamjoonsoo.kim@lge.com>, Bill Wendling <morbo@google.com>, Justin Stitt
 <justinstitt@google.com>, Jann Horn <jannh@google.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, Nathan
 Chancellor <nathan@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Nick
 Desaulniers <nick.desaulniers+lkml@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Yafang Shao <laoar.shao@gmail.com>, Tony Ambardar
 <tony.ambardar@gmail.com>, Alexander Lobakin
 <aleksander.lobakin@intel.com>, Jan Hendrik Farr <kernel@jfarr.cc>,
 Alexander Potapenko <glider@google.com>, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev
Subject: Re: [PATCH v6 4/5] slab: Introduce kmalloc_flex() and family
Message-ID: <20260224111151.6154ce59@pumpkin>
In-Reply-To: <675ec547-dac8-465f-b3c9-a0f97c5bdef7@lucifer.local>
References: <20251203233029.it.641-kees@kernel.org>
	<20251203233036.3212363-4-kees@kernel.org>
	<675ec547-dac8-465f-b3c9-a0f97c5bdef7@lucifer.local>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 920CB140006
X-Stat-Signature: r5kg6fi6zmo8ug5rnke1k9b3zgkoihgg
X-HE-Tag: 1771931515-29160
X-HE-Meta: U2FsdGVkX1/GoRKOXZt1G/RX6xA79KdRKbrBnuk0HBKuxVnoL9S7c3m/EY2wW0cR73XYFZcyY4gGWPzMq/+rd5K0bLS/S0QH07hdeASOjJ6OOTzOFVwJPbPSD68t+nTNLdZSHCdY5FYLNsV+aw0uTi0iydtrY1AUjfCqUsVvEBqpZE+rwfUVCQynDek7ek2Fye1ZNOyD5yYlB2ZEqMHsBS7XEmLbr6KhRUkTIs3Ux4Jt3np54F8evCxV8YTjH4OflXwjR/Vxg2JTmW3miN8w3h0Oy37+z9uE+WzryCOt1JnqTQnHb+HTT3rPa9VlUmnCQvqv4kjPXlYWaQW4UcWtrlflhqFG6lW6SXdwWRavxHiD/NOEo0NKp7baE733gUHKGq3Mm3Udku8kXCADEbwUHp86jCpS1ZdNaI5L3mX0u9NJz2HVJj/44T8VpVUS0HOnjBHC0zFHyrLknM8BxCqvUY5UbpLYufNrz/Qu/FWbmv3Yr7HRVUjPtF2V9Z9eFV1xOYmspCzh432RJlTfzN5ZwL0KTfRk/Jmxqzlx6MZFn5H4/Nvhqz70ke8CEj6voLeNcgNu/2dvUUeb5j1umP1e1RQxwmzSEx22Dts+bmBGxG1GFLkPvqyQR96Pt0hd152cYlnKvKdrkhNn991JfQcuT57NCmRIHPtMGev+18+q+j4vwM5mji805GcFTWH7TBQ970qew00sbu298csAw6GCtyTDrKGp3FzXZ+1SKHxYuspxLVkb3taGY0o+dYGC3SIeZNm6PemjBsU1pnqAzrx7m0YNy8jFMKRFoQ7q3o1KWD+pskqOlmYpkwwL/a4ovd2troyKSCHiv0p6RQ901mBWCaPcjtkx6cHMM10qIuzo0xS5/Q9LAoLdmKj2/Az6RJHwHuzm2RsL0cdnjB9wsFxBINCmDk1uSNEKi3LicGwhHp4Jj0O9TVb0cXZf4xBF79zlTg5d4mYXf8L1VXpdB+D
 lklhHT63
 aNSzzhD7m1xxLBZ3EKu1Muhih0Hrol0dAzxqDKUGsXDtqTb5vGcq9qKDOtR8NYUVwC5x3f8X5B88fYWEERdbrYCykTIUeK4lvUXE4FcTLMGUANcKZS9GdIYrhcOEGQku/2Jo3et20kjwpzIdlcmFQE6TIUEQyvT0R6abMXOWCv6RPof0hhT/HscmrhZwW601442SkyfyERqkE+VWB4XCEx3J1ham1BfQjL19UAms7qrSfiW9FEzj8eV3DRQOFLxF+UkzKKzRddftFrsXKDW4ZAAaPbK60y7isQx0IaWC4I7ZzbQv0cC41vf0RBD/Bm0xww82Bwzs3etihYJUkhAaasUWTInfPDlsykglfwJUkxoo5Pp435aF5jZy0Rx/ACIqHmBKcM0tikC2uNDDEfbu83HTKTbscg+UfUCOmjxL/DRt/zX0vmMnN0oLflzNOnozL6iR3Vtl8GdN05zR9pyOJmDJpC7KTBbH+fF9oQDncUxXLiff8cP91rdi1QH0C4HIp0GRbgLqrYqESB0c2FOcKbw82Xwgp87JsntpaH4aaML412KGqJJ2HCNh4rjQc0RxAfzOvY/89mu32bCQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Feb 2026 10:26:36 +0000
Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Wed, Dec 03, 2025 at 03:30:34PM -0800, Kees Cook wrote:
...
> > +/**
> > + * __alloc_flex - Allocate an object that has a trailing flexible array
> > + * @KMALLOC: kmalloc wrapper function to use for allocation.
> > + * @GFP: GFP flags for the allocation.
> > + * @TYPE: type of structure to allocate space for.
> > + * @FAM: The name of the flexible array member of @TYPE structure.
> > + * @COUNT: how many @FAM elements to allocate space for.
> > + *
> > + * Returns: Newly allocated pointer to @TYPE with @COUNT-many trailing
> > + * @FAM elements, or NULL on failure or if @COUNT cannot be represented
> > + * by the member of @TYPE that counts the @FAM elements (annotated via
> > + * __counted_by()).
> > + */
> > +#define __alloc_flex(KMALLOC, GFP, TYPE, FAM, COUNT)			\
> > +({									\
> > +	const size_t __count = (COUNT);					\
> > +	const size_t __obj_size = struct_size_t(TYPE, FAM, __count);	\
> > +	TYPE *__obj_ptr;						\
> > +	if (WARN_ON_ONCE(overflows_flex_counter_type(TYPE, FAM,	__count))) \
> > +		__obj_ptr = NULL;					\  
...
> Annnd now I typed that I realise that Linus fixed this up in mainline and I was
> working with a stale version of this file :))

I think someone else mentioned it, but having a WARN_ON_ONCE() is there
is really a bad idea.
The code bloat must be stunning.

I won't ask why the #define parameters are all UPPER CASE.

	David



