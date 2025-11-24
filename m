Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 480A9CFD356
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 21:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BDF16B0029; Mon, 24 Nov 2025 16:43:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547216B002A; Mon, 24 Nov 2025 16:43:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435BF6B002B; Mon, 24 Nov 2025 16:43:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2AE336B0029
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:43:02 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7B4789B98
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:42:56 +0000 (UTC)
X-FDA: 84146825952.02.60B7B18
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id 88933C0015
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:42:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=g5r19vNc;
	spf=pass (imf28.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764020574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NoAYUzaUy2oENd7JkoqDPVCvDLLlV10MU8wdc2FsfGw=;
	b=I4pt6o/XShYSstYGPeW8uiQxDkV1w0msXXOC1D8LzqU+wqCv/BNUq/wc6wk5fiV18O6U8z
	dJShVJ4hWkewMzxVqTCezTzpK93sLVN5tsnNP2vgaMhLcCbzknIQkAgpZgpOluXz4zBFsl
	5PDiIYndFI1orhkYiIHlH4Woxy6dSLI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=g5r19vNc;
	spf=pass (imf28.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764020574; a=rsa-sha256;
	cv=none;
	b=6aeo/rGF5Gw1nzm4IAUsT+vwZaBZzGxkSfKbecNPRzcBIBQZm1AvHf+4xj8vfYinhMp/DB
	d9XSEpi8jQnUrg0g+uGUfiMvBcWcvq/Cswz0R//rhTw6PznR+HuvrCPWu3eWzc8fQy9pQA
	AUlNwLH1GfNKVX8m46BVQF0kncFGIhE=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b7355f6ef12so1013353066b.3
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1764020573; x=1764625373; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NoAYUzaUy2oENd7JkoqDPVCvDLLlV10MU8wdc2FsfGw=;
        b=g5r19vNc6RYRpiub6A8vOzLrEUUb8e+8QS1RswKviijfmSzoQafiVaD3SnQjQWj8Ry
         cZxDEEi8n0c0texcRPP0J5sHAW9LnTLkYm1T4PT99h/3c14SWr3SARU+OfdXbCpqPAf6
         xbztM/j3WwcJu8f7kjTvv6z5uKT5RXVflqTQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764020573; x=1764625373;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NoAYUzaUy2oENd7JkoqDPVCvDLLlV10MU8wdc2FsfGw=;
        b=hLu8goOk46aP3hT7DD6csQ5MqAhdXV/Nnw9TaM9mfLqMFlzpYNRVr4qM8M68xssDYO
         G6W4yXoTObDZLTSU/GkBztt2NIvWyn/dPAyYahk7Dw93B6CHpOfKAUOJIbab7qSjh83N
         mDe/QNbdu1waerfDNQyg8Ahj5vFl/H7dZFOTahvJC7oDV20dljEzmQdr8O7Qgw+EyLZJ
         aEpZzFr5RK0O/t1Zix+JgbRnO/RYCR5n1q+dODHSxsvI1MeJ9qFqFwOx3SN4SFJXbnt9
         a6bhEp/NCiUcjDFjGWZwZXEHA5weDuP5RVC5OEO9VWz6m9Se9/vb4w6GA74l2eqf1Lga
         TgYQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/Ir32uQOz05BCbm4zpbOv1W43lNlYN2c9QncFcBYDClRuxPReP23krO0VhcGMDkyjTJYKCdueqg==@kvack.org
X-Gm-Message-State: AOJu0YyX8Y8dLXRBDDzRzYjKIPjYt/whW2Dj15wXTai4EkJdIfOVo9Ow
	1xLcOiALbLCYWwh4EI8aSkYqEcQ7owXPMXIP5BtBGm/k5KFDM9U0MO1WrM0LarZTHN6XwjN/Ll5
	v3dXxQys=
X-Gm-Gg: ASbGncsyszem59Mc43PW/GbYKNw8nLF3tiAG8H2Ka1KF4Nhx6fc8nZ0YUsSlMbIY/Gb
	MOwk+/tSp0STYhTDXnqly7t3oWufHGt7zv4tFn2lg2E3gtdyGPABLY0wrYJiPyU8y/mX5Pihif8
	73gmK/UV26lI6vn6rfYeOB58S/5O7BqGGbZvql6y311DLMOGAvvVRjLJOvURWnVPWCaTIyhueg1
	3m1DOWMlyAzHHew89T2YaUa6hQpV2nBwsEQIKdtmB8L025XmNgt9BKBou9ijjmf7Jc/ZzvXMKWO
	4mc9t+QLo8ytXSEQG8giDz3NJp45dGLJqDP64H5SLeNlheONSKp5ceYVBrrSbGkOd56HC8X3cdt
	2oaSsUQtCpWywrJN0uqpoRkWp0OldZrWw+EahSxVzHjUOkEAdHW8jBqsGfV+7USud/s2UEOU802
	f4M4pfjyKegxQfa+S76tN93hDgWajwQZFv8vvunmVdboSZBt1rKGp1W84GgIjM
X-Google-Smtp-Source: AGHT+IHF4rWrw6vh8iGlo67n5wF5pw/sIhtqsseTUA9P1k7+hrJkPQ8T43WR9w5mMYC76i73UfL8fg==
X-Received: by 2002:a17:907:7286:b0:b3d:73e1:d809 with SMTP id a640c23a62f3a-b767173270emr1761093566b.48.1764020572485;
        Mon, 24 Nov 2025 13:42:52 -0800 (PST)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b765504828esm1389665066b.64.2025.11.24.13.42.52
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 13:42:52 -0800 (PST)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b7355f6ef12so1013348466b.3
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:42:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCULZBfidnjcC7lYWL+EDT8M3wNskrRueDJVcj1SVL+SCkHVKad6m2aaf6ZdnEGPKW0DHaDQHn+KqQ==@kvack.org
X-Received: by 2002:a17:907:dab:b0:b73:4fbb:37a2 with SMTP id
 a640c23a62f3a-b7671514106mr1495344566b.5.1764020128744; Mon, 24 Nov 2025
 13:35:28 -0800 (PST)
MIME-Version: 1.0
References: <20251122014258.do.018-kees@kernel.org> <20251122014304.3417954-2-kees@kernel.org>
 <CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com> <202511241119.C547DEF80@keescook>
In-Reply-To: <202511241119.C547DEF80@keescook>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 24 Nov 2025 13:35:12 -0800
X-Gmail-Original-Message-ID: <CAHk-=wikqnc16e7yUTJuqnc5f4rL+y_-JpRzCLRu9WPnt3nmiQ@mail.gmail.com>
X-Gm-Features: AWmQ_blKFpIgLGtxfT-s5R89X15xCb9TiduKsCJf35qbsynIOkmHF3dcQigtmSE
Message-ID: <CAHk-=wikqnc16e7yUTJuqnc5f4rL+y_-JpRzCLRu9WPnt3nmiQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] slab: Introduce kmalloc_obj() and family
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, "Gustavo A . R . Silva" <gustavoars@kernel.org>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>, 
	Przemek Kitszel <przemyslaw.kitszel@intel.com>, Marco Elver <elver@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org, 
	Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Vegard Nossum <vegard.nossum@oracle.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Nathan Chancellor <nathan@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>, Yafang Shao <laoar.shao@gmail.com>, 
	Tony Ambardar <tony.ambardar@gmail.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Jan Hendrik Farr <kernel@jfarr.cc>, Alexander Potapenko <glider@google.com>, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 88933C0015
X-Stat-Signature: hdmmjg15i7567fwfncqobfninmhjjois
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1764020574-785249
X-HE-Meta: U2FsdGVkX1/Y7OvhQ6iGk57WAW/tNkHq5I+ond3GlS5oNG4wbcBxyHdHs+GtQaIGuEp5lMKyE3o+oinJTv5mIaEx9O5Irb4ql+BAxnDhtD4odOIltN+OQWPBcnHGcYu7bKwY+99TEOKmd02iXJnVr9uO5KDWslFQcf+Q4fWUjnIJEMWydKQoCdEhRVbbvmaLHSQUvYxMsnB7vl7FQZPCNfxCfZlbppd7NAz1TroPv57NQEUfPa7qGed3It3E2YqGvyjpv09e5vLPt6BnYSQ9fGI5uX7hhQt5J9v2apv+FlJhGUWV8QSHE87ocdusyusgd6PHaX787XS9cxtcFaCTSna8SdhLEi22630//l6UNTM8D/hTJ1msysHoQCQKmQK+d58bzy9fHvDw+WEHzd8kkmyK9sFt6R5OONho1ewpYubSnR47qLMqbui5fhoMiXatkFYqBMOFB3I5jxpMvW1ah6RuiZuoLBpw3oe6GUZwwDtGg+GU5Eqfszak98cAuXlZKdanFK8/7nN9uujXc1FYNBC8wINQ3dZ6FmX6PLEYZGmHg8AxSj32wOeg1JfEAV1M4J99KBk+saZqSSIDLLfeSORgj2sLOgJD4Mim1xaQZTfwvMAFWsxDWY2JoMBPQvHK1RQVKvKRHqzygT3Dkh2uyk0Xwg59XuiyEDANptFuSUHbCKjE4LwTp6LYkWyVV/GgE5ofXDguc2mWdUUDBKcbjb9Bzc9PJho8Lxt8evG+nwRj6QDNBv9mFNc5vY4Z01Wak56l9n8lsdj1CDFt2kd2zMrRslC2zulvcQgct2FEwXdAI8K9zSG3Cezhp/0JnKlfyCMIn8eHOSjuqc9DZPrE8WF4IyqGb+jYCzgDwBRjgXyfOusREcqY8lbGM60V6jP9slTTRqq42yhrhoiXTpLQy4otTCZGR4ZniEqEjRT/qRkh/BkAHlO8zo398CsOq9lDSynnDnQs8dBrnD6p2JT
 z1ITN8Xp
 ep79Rr5IGen5REmx8FFzCwWxnvs0Ttt486HcX5EKpjOjofl2+xVXBCjTGOsJy8m3PAwG1oDJ5Fj4jQbNP9bIpNO4g2BNCyqRKcZLHWZnzXc9xhVVZTj0u+lnf5+brq8ZQYvimCU+jFcp0a99qzjhhBuElBF6yTIQsKBPKO/kQiioOweGKN5b7VQPdoYxeHZ13V+Kp8lqgV9ID9VXLwnZX2iKdlfi7CoLrioIYoWvE3GmY9GOaf3lJ5mTJ6FVQx28DMbJK30vJKQqv/3HIYpifZIf6dPsZFxpNjzhxWnDvGt+h44I7CPLKZif6ILeUYE4q7+bfPidZpIZE5Y86Qb1S42uogp86Wo6KE/VXiy4Ga30Kgdq1Ay8kJMTwyNqCkGnre9XYfFb2LH1pQJ71oKWmCW4GG8Qw+al6U/WAIaVqxFQK/MMjQz6lJ3MQwReirEkpGsg4MrG+ehdMNvfvqEU22u86BEGJob1Tl+6tA+RPu2uC6tSsmqxyFCYPwr58M/O403ItlHt4HH3PPwOgs32MViNsr6m12El+M5LZQ2IR+M+mcdGj/qWlFZefUbBktnzs/ZJBycKzOR2NgUzhDO4rJ4GOJSYPSBs6LXLyTh3HIH2yY6xQpPv3fnKo8cAPM9TmrnXXLvzYPDcaT3Wx6JbPc2Cm9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Nov 2025 at 12:39, Kees Cook <kees@kernel.org> wrote:
>
> I'm not sure what you mean by "limit to pre-defined size". There's no
> such design in those helpers, except from the perspective of "detect
> and refuse to truncate overflows into too-small storage". Is that what
> you meant?

I meant that odd combination of checking both for minimal size and
then assigning to it, but upon re-reading it, I realize that the
"check for minimal size" was actually checking the size of the result
variable.

Those macros are illegible. And 99% of all users DO NOT WANT ANY OF
THAT COMPLEXITY.

Yes, the wrapper macros then pass in NULL, which then - using yet more
complexity - turns into a dummy thing.

Basically, if *I* find those macros unreadable - and I'm actually
fairly good at parsing those things - then they are way too
complicated.

And they aren't even complicated for a good reason. My alternate ones
did *more*, and did it with less code and less confusion.

And you added the complication to make the users less legible.

So no. We're not doing *any* of that. You make it simple and targeted
to the *common* case, of you don't do this at all. Because that
over-designed mess that actually turned some users *less* readable,
but one line shorter, was bad.

                    Linus

