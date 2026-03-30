Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D47C910D14A8
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 12:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 379886B0095; Mon, 30 Mar 2026 08:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3513B6B0096; Mon, 30 Mar 2026 08:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28E6A6B0098; Mon, 30 Mar 2026 08:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19EC46B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:10:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA0BC160776
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:10:26 +0000 (UTC)
X-FDA: 84602612052.24.22E8270
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id C4A544000C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:10:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774872624; a=rsa-sha256;
	cv=none;
	b=NraIeK6bCbrM+FBLiNAWta1CYQat9S7zUPs89cwBp0eZMslSUu86vrn+Yo7ebW8mMrm+wY
	38V27miT/AN3ooTPYFQP/JlyHC7TjPKd7cJtdLGzkMuGXdgqTLMm8eAddNe0w5FVXdxe/1
	jlh9pwOV7StL/uBTb1FiL/eid9JR7Bo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774872624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k7JyzGDh2V9hD5ppCKHdE8lqc25UY6zaRA17P+pQPiE=;
	b=SEqItTmSh45Jt80PsWQgkwRkiB3G169XEW3SP3NFX4I7JjCpG/xvd1wd7cg3o5tTEn4LcX
	2Oibi/PyRf/I9R2s7hs8203WyF2Kva6GxInPfa71F7kEsOMPGEaoD37uxQzeBCQL+kN9xb
	+KltRmMoxBp24JO9HO9uBLuEmQ6cXCE=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35d965648a2so1219144a91.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:10:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774872624; x=1775477424;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k7JyzGDh2V9hD5ppCKHdE8lqc25UY6zaRA17P+pQPiE=;
        b=kNAhFszzAsRaZr0aeeUjVl841UonE2Av/02FGxxhqXDbBi8veX1/RBBbRmik0xy6dS
         aFBA2ZuuoFwN+ez16sNHOguuEgv03I3+mOIuRXx1UenGAh69kacPz1qVs/BCXwCQ3Zv5
         t+KHpIw6kHRekPZOEhhh2oJGdRLZyvXZd/M0hnbOOkH2GQWaiiVpTX7PM1jxFg5rQW9q
         rZZoPJtXEnsFaJZn+kCOVG9/chzCrj84mJfaOc34/XTqK6IYG/xSmcSRhOQDEih3FPC6
         eK0y40TVmqf5RArSlSCpFsGRbFP0GrfkamaPRFW2knlisBIWj5fmnnVFs4PHXaQLTzk7
         YWtg==
X-Forwarded-Encrypted: i=1; AJvYcCUdJPHbvoEsSYENHXOql33wa5L3uKpNA3GLmQYYJoktWRef1gviePLlnv1mcHwVZ9KDRatzwYgCgw==@kvack.org
X-Gm-Message-State: AOJu0Yxsh++KA0e1nXrOEZ9zNAKbDjIFpqwPipBvrPX1gFa+HXBBaFkK
	x5Jg28mTVCcnUvp69GSKbpfIcjXfg8FNAixOdNk1nquBbOcRhYvf81APWz6I1MpB
X-Gm-Gg: ATEYQzw9Ei2ccZphH3M8RBbJMaKJz10X4vjCr6kky7BQxB/0VRM7cUGIi4ukyNfVRjH
	zOE863OaEeeDgXNsPprxtHHWMFiblBWK/HXx0oiI2UBuT5j5irWVA82G6e7Ahkz1s3pXG8BjE4V
	NZeZDolRyJsEu5fOy2LSHBBZXKAsb8vSBRy/IAUdkYrWpKo+WOuMuZj9xmxeGooTfQvW1i3YJ2J
	svWZJJBKAwla1g8NcqYD1+DK3tLo0J/QvpQ3P5KCt+met7HqaIZmqt9YyIDbhQ2M/KvmT4PFxY2
	KqhSSjAD9QCu0hRAzYXNmqy6wfnMtIEuM6KTsHI+4C/6oxabVHLrnlRlL/G7RPgFkavngfa/Opa
	zAG8gb7iX4+0kId8MyxwgYojOUiDAX9UMmMMqx9K/lLXsruUB03AFAGacU+ZeD8t+gO+H4KAQiN
	TnYe6edC/ReFV7WlR9zK1zO3vCu9hdcFEBUAAxN17BxzMVU+9hzWBGzktN518e5sk=
X-Received: by 2002:a17:90b:4d84:b0:359:f43d:4a6e with SMTP id 98e67ed59e1d1-35c2fd5eb02mr12581579a91.0.1774872623529;
        Mon, 30 Mar 2026 05:10:23 -0700 (PDT)
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com. [74.125.82.179])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35d9caadaacsm2753700a91.4.2026.03.30.05.10.23
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 05:10:23 -0700 (PDT)
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-2c54c68db4dso2226343eec.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:10:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV5fkVUoX9P2QgQUIVWbcqw/x1SQVC+b+xK0YN+J6YSCsd41bpWfQc/G0fgIglJzvghLDFTdmy8DQ==@kvack.org
X-Received: by 2002:a05:6122:1824:b0:56a:e46f:2cfa with SMTP id
 71dfb90a1353d-56d4a5f2e5cmr4217124e0c.12.1774872216490; Mon, 30 Mar 2026
 05:03:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260322192159.88138-1-ojeda@kernel.org> <20260323000327.111235-1-ojeda@kernel.org>
 <acEP7tl8pqFA3tK8@shell.armlinux.org.uk> <acUGAsjYvNvTEO92@google.com>
 <CANiq72mzPpkELXis1CiSbKUmBXNQYMiMmjj-7-sYiLh4T_JSOQ@mail.gmail.com>
 <9cf5a94c-0f37-446c-b63d-ddac5674d220@gmail.com> <acVOL5Psz6kHlhq2@shell.armlinux.org.uk>
 <641592e3-2354-4238-9eb8-a1f5c2a13126@app.fastmail.com> <CAMuHMdUUfVCBZFi2WoOYibJLVnyPY-joRDJDowgHwjN_DGeEzw@mail.gmail.com>
 <93439e91-cf81-477b-b880-a813bb01ad7c@app.fastmail.com>
In-Reply-To: <93439e91-cf81-477b-b880-a813bb01ad7c@app.fastmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 30 Mar 2026 14:03:24 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU-+dm83TVttfarT7QxE5ySpQ2LJ_k6oFKMWRcbaWcCdA@mail.gmail.com>
X-Gm-Features: AQROBzBixIQPiuCOL0pIFbgyC_M26WMZwTpKOw623Sg5KUyDyMzQqEZKs9RSoco
Message-ID: <CAMuHMdU-+dm83TVttfarT7QxE5ySpQ2LJ_k6oFKMWRcbaWcCdA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>, Christian Schrefl <chrisi.schrefl@gmail.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Alice Ryhl <aliceryhl@google.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Jamie Cunliffe <Jamie.Cunliffe@arm.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, acourbot@nvidia.com, 
	Andrew Morton <akpm@linux-foundation.org>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Danilo Krummrich <dakr@kernel.org>, David Gow <david@davidgow.net>, 
	Gary Guo <gary@garyguo.net>, Johannes Berg <johannes@sipsolutions.net>, 
	Justin Stitt <justinstitt@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-um@lists.infradead.org, llvm@lists.linux.dev, 
	Benno Lossin <lossin@kernel.org>, Mark Rutland <mark.rutland@arm.com>, mmaurer@google.com, 
	Bill Wendling <morbo@google.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Nicolas Schier <nicolas.schier@linux.dev>, 
	Nicolas Schier <nsc@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Richard Weinberger <richard@nod.at>, rust-for-linux@vger.kernel.org, 
	Trevor Gross <tmgross@umich.edu>, "Uladzislau Rezki (Sony)" <urezki@gmail.com>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C4A544000C
X-Stat-Signature: uadoo5yisw6i3owpk3ieyhywsq639t9d
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774872624-123894
X-HE-Meta: U2FsdGVkX1+IaW/DP9bPzkchYcJaJG1nOlr/W5VOJw1/bEpbr3cI3s4vNj9PFlr9jdfIj5D10u+8UAbeoS0X3H3bfKTB4cXvfT26AY1LSHQRjbG0YsHnp90wm/AGWU28nudIylRL6GuQXxfOZHMzU0juPdTWispJa2yl9s7vez0d66OFDgcrc6GcNQWeUeeVZ/dcDYPEK4xe9AS0daQVz4/cVEn9FFCanYZpljWwJqepQTrM8ZDCIu6Hg1lv9IoVK19oi7LU18DtGE/l0TY7rU4685W3fMpSVE+X7NUnOExcOmXguvlTRCe/AtTMKnUlXsbjKcnFWnc0PkQckM4O1N/cj7wNMDnFrLA63auB9lW+NcVgYaQo/cgvJXhQI4KI+YGgasWZCZuYtMVPJkhlclcNmfZr5vzNlJ7esOsVTEhEjunm/ScUGNMPR5wjqhM5yB7H532YXlYbGvgU9OcDRugMZmWdZzVywJUioghlVcETUiDBYdPH+aTlWy2RBdJIaQKQ3ZW9p9vMHA3lE+IgGJJIc1Bv+t+bFnKrsbWONHkemYPrmpyxjWgkcjh9T/9+Di9un+I+ImhD74W0gskNmimWbbarkt3QROnyIdD1j2/LqszhxqONo8K5yx6LRQsnJJt2XNtjfSFcMTkhmUAflw6q8DbXS00MT6qz8e9TRFyz7NSFob/O+HVheuFFgmYyXR8WpWKimbIhbxql7lDOKsSNH546LiWwuOm1P4mEra6F03+v02lN6oI4xvZgW/TnOcSgeS0EpX1V/rCSE0BxfBGI6qLXS4NRndAyB+WFgxafoO+g053d72epq76b3IgHesWzGMYFG3zItC6896iCDVdsVvWOlWEb6hABKYbkq6SUNGiJ+YHqlpn0+FPWMoJ67jgh+zMTtMFj4tMqdPnzszpJPnx+Cbv6JN59VrzfDfsHhZwWCDQ/o5KlnLz3YKFeppusEguoqZCvoTnADEz
 nohO/1+H
 l+s+JqvJ3sPl6At8aiy4aIOhiB+ji/angs3scWGhsFFA/smFHjvo4W+mRfa5UC3eLj+A+tIPOK9TjjM1wM+mUWEG4lorzSeHNdaLTVeKR7UwTmY7tfnoBHMFB72srqUEpFpavNRRxPbK14lsFUxj6uF52JfVCJ/jJk0o80YlbHLD46r16tryY7HUC9B84JFsKmYO92BXfhqsN0VeYlrBlDgs2A7NVrZHHOYlmi+yAV2cqPyuipBRfTE5BptgXqDmd0/sbiijwLz9UY6IPgNh3xGBK+2DMIBJYy2DLdaAHxWIhndLPGvE5gwKsLZ4GSL7dKYzJVFqB1puwx3LkdiORUK2VXHHdesRDUizFkeXlYQZ48r3I8KABLC6cgPdH7oAIGuGDdcNRcb/pGt2TnL+0I0GsTxDbwdC8L2/sLh6aPVOivZCMexdEbgFH2H8PMLWFUGAZdGELG6wKcYrGkk+nJ/AZv0P6+xwIzNOBrvJgQ391IbQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Arnd,

On Fri, 27 Mar 2026 at 10:02, Arnd Bergmann <arnd@arndb.de> wrote:
> On Fri, Mar 27, 2026, at 08:56, Geert Uytterhoeven wrote:
> >> I noticed a similar issue with m68k-linux, which has a bitfield
> >> alignment different from anything else on gcc, but uses the normal
> >> behavior on clang.
> >
> > Ugh, I wasn't aware of that. Adrian, did you know?
>
> To clarify, this illustrates what I mean here:
>
> echo 'struct { short a : 3; short b :15; short c :14; } x; int y = sizeof(x);' | m68k-linux-gcc -xc - -S -o-
>
> this produces '4' on m68k-linux-gcc, but '6' everywhere else. I originally
> thought this was related to this 2009 change in both compilers

Oh, now I remember.  AFAIK (holding wood and a rabbit leg) we don't
have any bitfield members spanning multiple base type instances in
the kernel.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

