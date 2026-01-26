Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B9DEC88E42
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 05:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25D626B0088; Mon, 26 Jan 2026 00:08:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235C16B0089; Mon, 26 Jan 2026 00:08:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DFA96B008A; Mon, 26 Jan 2026 00:08:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF2296B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 00:08:21 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84C951606D9
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 05:08:21 +0000 (UTC)
X-FDA: 84372934002.12.4CB2305
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id A6FBC4000E
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 05:08:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U4dycU8k;
	spf=pass (imf04.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769404099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bsbA3S4vvXnWg6PVwhDAv4/t5NunrqZ0yk7Z9wsyNZU=;
	b=JxBCJIalbn9wQOsrqUIlSSNbGeao4XHfeswvsY7Vhu0Nu7YMXDH0Y3QHE6vM/hXhTaXrVc
	wHkvwhvJhDJyuDeEXbomdQJ9H8vmzB3v+RJFlfMrEGJWWjA+IOXHlEFLja6t2WeTh4N5dB
	VdrJoBSmOnWxpTrwmjOhJyDXRsbqGd8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U4dycU8k;
	spf=pass (imf04.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769404099; a=rsa-sha256;
	cv=pass;
	b=J0evKWhmEOIP7pzCpK5UICnvZOyi4hylTYxbps1CrznmFiedGjB01HLUlzKffZgylzHafM
	kUu9HJraOAMwqqxN3sL8wguNWTHJnU2+4LJEyh9p2rVFkANA257OpUog8VA2c0DHq5n9o9
	rSQ7ylwGlQ5HJCLv07CPA8+2vOXHrhg=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2b1769fda0eso431221eec.3
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 21:08:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769404098; cv=none;
        d=google.com; s=arc-20240605;
        b=GzqWGZQab43mLQJ102hOVhR87NDiRhTampIw2sdwlhudcSDcKV+YN0aoQZ6Sr+aWKJ
         FosGR/2iupc52Z45aFngYRm5kNFswosnHS/vrSDGBaby5hmDW5JwznZaHTC9ZqMVjYDP
         xlbdPC9FWjdy0vgKze+yvgYwADsEIinYY2Z574mkS8hDw1cr/U2DeLD9wFcCqki/WMNq
         4dGouTvO+R2AOGm3f04VuJWvLAhLlEvuM0jYitWvypVL2lbirXWcGixDNTnZkW/dcWxt
         TpbLN/MD4tvxGhZdzF5xHxpMUiFUHmil+IDLprArmLjC6PgrRx+WgSYoGkKQKrGHkPZx
         q/Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bsbA3S4vvXnWg6PVwhDAv4/t5NunrqZ0yk7Z9wsyNZU=;
        fh=8Xatgyy9l2ihOzCCCRq4ZOU/Yuhq0XhhdTN3A8G0f10=;
        b=EmWz3GwFxaSTiakuCesiEoOTwC7yYEY/Olw6+d4znmpr1odS6sJC2GotsOxL93zZg7
         maW2CeqCptsaYTncp2X888W2kU+S2blFKPBb30+OGsil4lHfNE0ZAQu680n/CUxOFdE4
         Ks0eHO6GjVJ4xvRejtTpnyDcpGkaGaoXLCygn5qbWrB735w2AyF9PGdDZjiBbqj0mqV9
         EcV2I9c50dTp72PS+cPPClTzmzpDRgWEAKhV4vJd77+Dfl9nizDfzNCenYQ/wwWhb6ff
         M4C8tK027acqhhQh4P4Ix6dwMLlXBpwNsRW4ZsE7cER5IdUGHvouwk7SkhFBWOxXOCrI
         98EQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769404098; x=1770008898; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bsbA3S4vvXnWg6PVwhDAv4/t5NunrqZ0yk7Z9wsyNZU=;
        b=U4dycU8k+0s3vTlz2SxFmrgbWkTJU5CfpWhqF/OT4SHcG1bgs8cc1uXe+SpPPYXfH4
         baq8Z5bMBN98bnYTiyRIFGwhat2o2yGQJop6H5DCbm+AZEJs/6CpT7oLKOBRvEt6AyiV
         1pCb154wyrju3enEoRiK7aUalM5/w0BUs/dSVXy4+Mv6f/Kn2XdrK7xu3srYKGKNPKu8
         CAqCJXoGKzVifpF2dO8oVtADGqBwbn/NeUQd91n+qyThaxATo99CSwqOklCJZ/FBPCCY
         b6JSkFOZEYxx6P7yDjsRKgtx1bhW+zBnnRErHtls9V7Cc6JS7NaJXSbDhohIb4dr9OAI
         IItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769404098; x=1770008898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bsbA3S4vvXnWg6PVwhDAv4/t5NunrqZ0yk7Z9wsyNZU=;
        b=gE65rdpDYld5f0A4ub473mVhhQ3q1cHmL81/YstKvyMLwlwtTF+BB5HxT+kRAQTJ2S
         BTdmzqTktfbHdNg2OiuLWc+hq7ejJjATKRlOfe47p9pIdhrvmDUl/5oil1rI0gs9PJVR
         I197lj0FkEPeOpVGfzkp0l4NXYQwTTm4iKEZ1fYJ0aKmX20lsdKR92xNNWhTLegXvg/i
         zmrFCXPL4oZG2VPcXhTMf6B1MmaUJnAk3GZggKvY+hN8T1fAR08f3gmN/amDxiGtKruK
         joVotNzvLPUWDWvdzU5yyDitLysTE4Zdf4x7L/TDxxk5b1sjuWJZTRq29lt3pb/uiK61
         Eyqw==
X-Forwarded-Encrypted: i=1; AJvYcCXS8kEJDJZyvtRPAuFegF3vOCQM6QbDuj7LdDbu/fuasZrI2P2/CF99/EEuTq+DO4ezZKIUdhDMhQ==@kvack.org
X-Gm-Message-State: AOJu0YwdQ8EOwsawvfJztZL1neufLjLpa2YASj9DG/bV20FPyVmmWJ7Q
	kKFCL8VWxEzwWr+AIYOfNicBGTAGsgAQ4OwEJr+rRlSl1LM+lII7PXClqAUVind9WW9WTWN3slC
	p2TgdkUhDPKXfOtLbqqJV2gk/A5NIdxA=
X-Gm-Gg: AZuq6aJN6FgcYZiDyGLfl082goHrv2hYTkzxZ5EkhLygYQ0LYB/r7qOmT2rIMWs80Rk
	sVkHn509Lw5bbi/SvGZRvKof63B2Zq35yFC3eAScdCx4qXvplIvpE/9AqERAksWBEUfPUWCLgjY
	lH1JNz0+EiH4rz597vGs1u+qAlmpATDPdC5gNSNkvdohipXRz8z67o58VCXx3NeH24Q9nabVaf/
	QLudrFO8vsgFue04o8Vqf+HAZip2YUGZ1hopx5ab5kn5GgUFkHXsP/b2LY74d5LNtjkWpNGnXOS
	87a+rTd6amS99a+lGefaq6KV2J4XSinZOE1ODltrHdovC8Zd2KcWC5+uL53mctK8lU86cAuuvo+
	mYk0uxIbeJSY6
X-Received: by 2002:a05:7301:3d10:b0:2ae:5b8c:324a with SMTP id
 5a478bee46e88-2b7644f41dbmr855051eec.4.1769404098278; Sun, 25 Jan 2026
 21:08:18 -0800 (PST)
MIME-Version: 1.0
References: <20260105-define-rust-helper-v2-0-51da5f454a67@google.com>
In-Reply-To: <20260105-define-rust-helper-v2-0-51da5f454a67@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 26 Jan 2026 06:08:03 +0100
X-Gm-Features: AZwV_QjC45jcqbNpvCzRgWaUDtcYZvulw1uksmCYv_NCU9WJD69mYzMDZ_yhpJo
Message-ID: <CANiq72m4hBinKM4jRrkpZ5nM_wraQ8FMsYtjgKRkNDmK5sS8dw@mail.gmail.com>
Subject: Re: [PATCH v2 00/27] Allow inlining C helpers into Rust when using LTO
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Peter Zijlstra <peterz@infradead.org>, Elle Rhumsaa <elle@weathered-steel.dev>, 
	Andreas Hindborg <a.hindborg@kernel.org>, linux-block@vger.kernel.org, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, linux-clk@vger.kernel.org, 
	Benno Lossin <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <sergeh@kernel.org>, linux-security-module@vger.kernel.org, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Jason Baron <jbaron@akamai.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Vitaly Wool <vitaly.wool@konsulko.se>, 
	Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org, 
	Daniel Almeida <daniel.almeida@collabora.com>, Michal Wilczynski <m.wilczynski@samsung.com>, 
	linux-pwm@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>, rcu@vger.kernel.org, 
	Will Deacon <will@kernel.org>, Fiona Behrens <me@kloenk.dev>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>, 
	Waiman Long <longman@redhat.com>, Mitchell Levy <levymitchell0@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz <jstultz@google.com>, linux-usb@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Tamir Duberstein <tamird@gmail.com>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A6FBC4000E
X-Stat-Signature: gs174pocjp93qtfi7mz7n8jckea7fk1j
X-Rspam-User: 
X-HE-Tag: 1769404099-826288
X-HE-Meta: U2FsdGVkX1+v7WqgRowfq9MuxRlYDLbgyXOpGhDYDehKN4C2YqxupVTvzYQwcyCmoOZdGyW0XPg1OBSzPYEdjGcbgAlgYxCm4vYCCbwcYsP8gb0XejZMeAnzdE/ICLimwwBl9YXFlx+tMorZO7UnzznWhFPQbJluhydwoecQJY2XtQMMDLJ8e1XZYQgJLJr5xODDqosSliZSqrbMyHoO9FAysj8svVcr2volOTWfWl+CnUz7gb/tQelNmt5ZP0K8VTdsi+w1kgMmOCLtCG9uEqRrzYNPH9hOCcTAcmoG/dDiP76cnzNjtKa/J+S2HNrqQSgFpBuhjGEEl3OF5qgu24alaufloVmvs5ui/P9X6NeWWUd+U2YNDrMCh/ObpdYG8HYNWr2A8oH1Dsvy8sz9ZY/nxA9DW0n80vmXuTbkcpgz/uhJ1lK4izFcD5XTHUxmtbtzjsgRMcwatQw5OvjmFy4ah1p4KCfqh9SdKoaW0Idm/4uqTmPOuJPci+94l9aLAMysrEOANOPX9urXm1DCQidFNN4blOjWlSFrN4oGaxsMiBC7195wGvbCY5KTrOfDgXj/QCylxzq6YFL6C5TExof+HwBrs3MdqI7MmYDLhLF/SLXAx1YufplnXBgBBjO+qEDlbzIcJxoH6LGiZqiFXDHindYyVTWB6x4W9PpowjNdcPFsjZGZ543hsyUOz6Tpc55J1gydQnF658p653uD3NY/dYpe1Ayjr7SP14X43HfevHWBMkGne+P/YR/eFanPacqZs5HohPb9NY+Hevc6jUmIq42Bt5Kx/F54SRwuVz1GPpQ5GdKgHNfv+olHhQyRioqtIFgJ/cTo0iCMmS1qEAfLCwBLdNDvgv5y3LVZ2AyhheXNqhOS1A2KvQeq8CTdHVV+9U5z2HFeORTPxUdTuzX1+NyVHUFupNn+WHuoGU8Hfk3IVUZDIT+IzcUghrgZqxQqEDn88I4hGSXoXYU
 D7tMFIyL
 AgEtloiN2tg/xUHKXO5vK8XbFh7jNkY6PDTYprRHojfoOtpaRaJdCKNymX3ZfZeCkCpVN4XN3TfV025GcEnZfj7SYY5a9o6lRukAsFT3OCNFpdBHOFEUS1M7BlZSYPBuYUtUqHJuwckm5zUgudBll7Hs2KtV7bJwKrXCK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 5, 2026 at 1:42=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> wr=
ote:
>
>       rust: bug: add __rust_helper to helpers
>       rust: err: add __rust_helper to helpers
>       rust: maple_tree: add __rust_helper to helpers
>       rust: mm: add __rust_helper to helpers
>       rust: of: add __rust_helper to helpers
>       rust: rbtree: add __rust_helper to helpers
>       rust: slab: add __rust_helper to helpers
>       rust: uaccess: add __rust_helper to helpers
>       rust: workqueue: add __rust_helper to helpers

Applied these to `rust-next` -- thanks everyone!

If someone did not intend for me to take it even if the Acked-by is
there (e.g. perhaps Andrew wanted to pick those nevertheless?), then
please shout.

With this, and if I didn't miss any message (plus looking at
linux-next where I see Greg picked usb), then only clk and jump_label
remain (plus any new incoming one).

Let's see if we can get them done next cycle then.

Cheers,
Miguel

