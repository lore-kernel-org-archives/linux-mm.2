Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9E4DD1F9D1
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 11:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DEE26B002D; Thu,  4 Dec 2025 06:57:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18FAC6B002E; Thu,  4 Dec 2025 06:57:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A59B6B002F; Thu,  4 Dec 2025 06:57:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E81386B002D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:57:46 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94FBD160978
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:57:46 +0000 (UTC)
X-FDA: 84181639332.28.E49B093
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id A13BB40002
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:57:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WuxZ1I2p;
	spf=pass (imf07.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764849464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jy74VhsBG2iXSHso83Jci8BnfjXIZJpeGjIa5hx2ujU=;
	b=HAGFQdJDzja8a6MDgN6OmHVUM1cbj/++wQz91EQjCeFAcJRznaaX4Ca6lNJgGzg2IkmGZg
	dEc3welQY4gcqjfZ8PhZBwZpnVj9szEl2Fdg1BuIvyu1VVEEy6QY+NYeZDSsmkJeTR118P
	k3qUQW7+4Hz8tq184L40Pvs8L+4Moks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764849464; a=rsa-sha256;
	cv=none;
	b=YJELShYZk843IRnLdQExSw55sojTzaq3cG5xnPNZrqLM+tNPp+X5rAsYJy63zNUTSS+YdH
	2aHleJl0PAW8i9kltXf+nDO2BDpzxqhnnh2QgJ3RqL9t5KJFmnWI+jlGqjzTsE5IQufi69
	ZV86Ia2CfqIRYkp3ZKj4hjgpOMdOYwY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WuxZ1I2p;
	spf=pass (imf07.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7d481452588so68436b3a.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 03:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764849463; x=1765454263; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jy74VhsBG2iXSHso83Jci8BnfjXIZJpeGjIa5hx2ujU=;
        b=WuxZ1I2p5wK/QTWzQh3whtnu/PFeABXY17PgAWbT/mJzrNLKzJ4gufRMUmWKroQ5Gi
         cvc29haWhxjcQFMfvZVSgnHShFPMxe2EUcaoWQMjX5a+5tk4OmVi1kpzgwdZN3RZTAnv
         n6S7CPKAQSo1scNdxtwyHs3ufyCk8DunalU6St6xTBlrS8VtQXyI8X+GMbTUb+TCzeXu
         AhSgXjoul24YI/5c9Th0kPdXLB75QCYoHwOmX3ZfN8RJ3BOHYRRIFnmDRYr1xZwFnVKk
         Med2OOpkhGOWWJd9CQinvjZ2NHN9VRD9MeTftYzL4+uQhAYgImmAkyps+UwQl832Gd0L
         LWBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764849463; x=1765454263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jy74VhsBG2iXSHso83Jci8BnfjXIZJpeGjIa5hx2ujU=;
        b=dwWOJ7oj1jmoGGNrudHK/d+9zAWfE840KU7ss8Nd+smJFtKHyO52wbYCezvtMY4STt
         RWzsyoyyIAj3Nj1MGi2kBnmzfgR/SphefgWiACvV7nsbBBphCx79VbeQw8errNwVmKC0
         HGl1/tzpTNZcSq4vkUf3DbdGCOhCCggtPGO83y7xSUVZiH001uzJ5NSBtRxtFYBD1UOY
         5JV/A/5K7pKeF6Wsl/AhEAgCP7Dd3U811lDvk4Nii8kcuVNa+pehzbB9HI6TwtGuFDBI
         WLG7ooFUAu52jsiJc8objlJV8+2s9R2bCLmCWvxU3J90jerE6kDJ7dJRd9GnKTHBb09J
         18kw==
X-Forwarded-Encrypted: i=1; AJvYcCWaKecsKcG0PatMe0PoyWuXewVvdyYdSvYsu1Ddx7wcz/WPrBdVnNFDnJdxDo4VHuthN8+FwbLxPw==@kvack.org
X-Gm-Message-State: AOJu0YzGvkAw3wLPM4sn7qqkto8OvcEj4dkqYiWIhC0v9Ek2n5O7omSo
	lpzRet5FZ7sQJGl5TU9+Ac4yH94/okXx1nYkGfBil4GJqm5N2cGNRUloOp7dYn9gI19anXbdYGF
	PXJzKcB9krQZKCSa/Bmy0pbmMEcMCCjc=
X-Gm-Gg: ASbGncuTpTfLcE/6zaBs2eE4tbQsM0CfeRCm3MCA8Azb4dERqb72dUKimnzMnXcNo6H
	YhaSxAhMZuTBuW/unurdNSZxH48rKxL2AzhqvC64/QMuwQArWPigw60TVdJBJtzlsXe6HYu34ix
	rc8261v2C5nViXPUJ88WWtMPUWCljdQxCclAB5hGcno2Mq43BacVu/YU/MqqBS3yqlkEq9P22nc
	hnB3y4Mzlzg3Zz61ZHiHuGKUD7gSOZI4gbVPgSNZWYzqN1F2ZbVJI6npISEnPUolXCKBqbD1Isg
	dgxlPTYZoMO2iVkvykm3Nrywddd1JEXoxvK0om4CgePCN8NOFyWeRuKqU/Cpj0p3n4IHLOndFwW
	on+L+UTZzcMhUtA==
X-Google-Smtp-Source: AGHT+IGeyoDrjBm9pUlwr3L1lIhuYxiVR/nMKBo3Q8beIteuq1z76e1BQfFIgP3nnV9ieQFXYxZbKA8xY2mkFTTQZGc=
X-Received: by 2002:a05:7022:49a:b0:11b:98e8:624e with SMTP id
 a92af1059eb24-11df25f6eb3mr3361650c88.4.1764849463230; Thu, 04 Dec 2025
 03:57:43 -0800 (PST)
MIME-Version: 1.0
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <20251202-inline-helpers-v1-4-879dae33a66a@google.com> <20251204100725.GF2528459@noisy.programming.kicks-ass.net>
 <aTFhFXCqvy7nmDOp@google.com> <20251204111124.GJ2528459@noisy.programming.kicks-ass.net>
In-Reply-To: <20251204111124.GJ2528459@noisy.programming.kicks-ass.net>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 4 Dec 2025 12:57:31 +0100
X-Gm-Features: AWmQ_bndz8ZZuXxUaBe-jxDMfOtEPNEq7y8MIf5_IqbpeKBzcbrA6kGhc4U4gvc
Message-ID: <CANiq72=r+Fmu0uuNF=6x36GWWQZGZk9gApnMZxakJavviwG+ug@mail.gmail.com>
Subject: Re: [PATCH 4/4] build: rust: provide an option to inline C helpers
 into Rust
To: Peter Zijlstra <peterz@infradead.org>, Antoni Boucher <bouanto@zoho.com>, 
	=?UTF-8?Q?Emilio_Cobos_=C3=81lvarez?= <emilio@crisal.io>, 
	Arthur Cohen <arthur.cohen@embecosm.com>, Gary Guo <gary@garyguo.net>
Cc: Alice Ryhl <aliceryhl@google.com>, Josh Triplett <josh@joshtriplett.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Nicolas Schier <nicolas.schier@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	nouveau@lists.freedesktop.org, Matthew Maurer <mmaurer@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A13BB40002
X-Stat-Signature: 11qk3aq1yif9ssg9jahbny5m6erohjs8
X-HE-Tag: 1764849464-483403
X-HE-Meta: U2FsdGVkX18szBnXQKzqOaUHrlFe2nnGb6sJfZCt5HYcZbnbNQXTLjz5PCESjKNsTJEDnJPGAk99BbY771EUzn0Sw5zoaZ7Slqv06Y3MzS2kvCDj9zNHTrQKuDsD8dzplNV6M0TF1GrYQ3GacjiLstiCf0xcQ62zo7dOH8bvoa4Nwo9fs57nmAeKLVuegK39bCJdElS43Clw/ERU6oGDXb0+mxrd8BGFsoUI7hAToG3N6EK9sOnEuhP45rNPHcFafNqwUDvUipr/pSkCecmX+7kCcKr+4uhsjzQalRd/Hh+OFjSmYT0BKB8DkKSEHeR2zo4LF91EyEnZXGnqLJMb7vxtN1IRD7lTqHzaUCKgNYYeYCLonBbcqBjgjllt1xjmtZuFhzQNX2TEnmlo9i5leejsq9Q1XTsCyLZku9ivFHW37qSmO4awrmQNpDZTgmKQH6jug/AN0EgCrUUv1fi8m4oJtVws5/mq7H9Nuc0WhFRDo71LJufArDvHqlwEXnMWjwl2o5EAqL4SgYxNvC5fb4Mv23Bx3VwpMpIjPLqBkGH1g2fTAHghUP31bMl4YfsyCelL85zULUvHIjtzHb8hD8sOzuhDgetwoSW/wkvYJ52koGhKupxTzQR6UP3nzQWkc2Azoeyh9d0fyuD9BSXW/K6u8i920ZG1uVAkmV05AEEeiMqjIpamb5YuDyRRCOTmKHYWbGZBryCtxUsAAYpZ7liqu2S2oUUXfZsN9KcPG7h1N3pkYkaninpjFrl8ymMYbfziXooW9MaGe1JdpkT4pLFieMmxX45kfETizk6rvz3b23bNjD01+e5gtccZDS7E8/BPR93csn86GVKZTTejIJo5VlMEWtAsot/hv6m2WDF9OIAUSXF1khxhvapFn6QZ722DrZ39y6tisptK4xQX7n8G0SOoSwYIQBGWiGwHQilNRGSWb7h3uqMlcxV+qQMcVEuaX1NS4baDgwVXec5
 7KSUggv6
 1y46baVq/8UFZgiIKcC/MYeGGCqHoKjc6liw/0inxXOka0N4CjVGGb/yFQzhA7VpbwYa5BMF9VDfJv5b3jf8jFE5/x0GVj+ndg8vJR7eNwM3JTnRyBmlBZDomGA90uMwWncHQx4yrAXhoUvoWMMW7XCDfo3KpQITXDS4yeTgHSA8yeBDUXU+4lDTnDD4uXIlXMswyxntKA8PMG6P5hO+kPzW/oW2sSOw22ebfprdMlrGFLchTC4MtKwvp834UgpDF0NVUbb2iUIkTm0za54AUnzGcJmLnjKGzX0bEKlxk7wmQ5LHYsnuBZk97/wfvwMoLwgiR1z2Nrd2u+v1c/G0VgqQtqYHNvdD24BYp/7uDO/SLAKzjEile70QvZCp8edA2d0ogLb96QASBQ9mCd+J4Qhzf/EWHzRM6KGbw53As/5O5cD+itw9LHG5ANhCdI1PDLiN01UAUSEOH9ZIvCX591oxQtvHeSlNQ2MJ2vsSuKao5PUIJsMbgBO5QiYngtWCw8uIs4GI/XDE9V8Q1GltN/sGlTH3aJt4P/nwhFwXSwtR5RpX/BYe4RpY0FnMALc0zPadlJ11SI6JpNl+R+Pr0wglVGmIYSiny2EmQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 4, 2025 at 12:11=E2=80=AFPM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> Right. Earlier I also proposed using libclang to parse the C header and
> inject that. This might be a little simpler, in that..

Yeah, that would be closer to the `bindgen` route in that `libclang`
gets already involved.

> ... if you build rustc against libclang they are necessarily from the
> same LLVM build.

So currently there are 3 "LLVMs" that get involved:

  - The one Clang uses (in LLVM=3D1 builds).
  - The one `rustc` uses (the LLVM backend).
  - The one `bindgen` uses (via libclang).

If that is all done within `rustc` (so no `bindgen`), then there may
still be `rustc` vs. Clang mismatches, which are harder to resolve in
the Rust side at least (it is easier to pick another Clang version to
match).

For those using builds from distros, that shouldn't be a problem.
Others using external `rustc` builds, e.g. from `rustup` (e.g. for
testing different Rust versions) it would be harder.

But I mean, anything approach that gets us into a better position is
welcome and I think requiring people to match LLVM everywhere should
be easier now that distributions are starting to enable Rust (even
Debian).

We have been talking about this since the very beginning of the
project -- e.g. I remember Wedson and I talking to Josh et al. about
improving the situation here (in particular, talking about integrating
a solution into `rustc` directly) long before Rust was merged into the
kernel. Even on things like a `rustc cc` or `cImport` like Zig (but
Zig moved on the other direction since then), which I recall Gary
having opinions about too.

There is also the question about GCC. A deeper integration into
`rustc` would ideally need to have a way (perhaps depending on the
backend picked?) to support GCC builds properly (to read the header
and flags as expected, as you mention).

And finally there is the question of what GCC Rust would do in such a
case. Things have substantially changed on the GCC Rust in the last
years, and they are now closer to build the kernel, thus I think their
side of things is getting important to consider too.

Cc'ing Emilio (`bindgen`), Antoni (GCC backend) and Arthur (GCC Rust)
so that they are in the loop -- context at:

    https://lore.kernel.org/rust-for-linux/20251204111124.GJ2528459@noisy.p=
rogramming.kicks-ass.net/

Cheers,
Miguel

