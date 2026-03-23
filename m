Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7E26F4610E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 13:26:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9AE6B0089; Mon, 23 Mar 2026 09:26:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA956B008C; Mon, 23 Mar 2026 09:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C999D6B0092; Mon, 23 Mar 2026 09:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B54DC6B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:26:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6993CC36F2
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:26:19 +0000 (UTC)
X-FDA: 84577401678.08.820CBA1
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id 680D7A0012
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:26:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U6jNl6z3;
	spf=pass (imf25.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774272377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8yk/BaeTksLn5Ogx8FpbgVk4TSQec7gWJcIZVnJOpI=;
	b=029Bgf7NRCxukhKn8uykDgdKh+kFvTg5fYvMYoU5XsQtgv2Y59eDystmJN/y3jx7KUgl1+
	ZfMyPtrhu9PrjopLuX5VuhD3G4Yw98grELZOrOyrI2zQqDjBe2XAoelhJI+hf265tcA2wi
	5ptQa204vhIF5oobnfnTPokoRo2uXpA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U6jNl6z3;
	spf=pass (imf25.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774272377; a=rsa-sha256;
	cv=pass;
	b=4XpBVvslLSmlpa82gyY+0ubSWi/LpB5h1fJqNLat6QKWPnMojXNvyTsnEp4ghklkKQImFf
	5HNvNYpTdNwJXE6peEY103myWGXj6+DEYmaARTOcU4Zpi9wIdQmE6olaxIQMqqmp9WDk/x
	QTPS4fQi6Iut7OME82jcNJ+xV2d5Isg=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-12734af2cdcso242440c88.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:26:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774272376; cv=none;
        d=google.com; s=arc-20240605;
        b=FfomqevDo8X5Pt8eQuzUJHMqoizVK3W7zgYu5OQLKACwsXLLhMjwfx53ftUHYId3eO
         GEdwZvC8Ix4D8s9Avrzq2/DdKHBHFIR+rUDikPFZKYKf4wj7/bs2DucUSFO7p2ucNGt6
         CdYO+29iyoJlofHzCTagTCZbyx5ybs06QMCiCFRKdB8QbfulCbwWnImMFqM769UvzOtf
         yy8pcD5JIbmQaE6gsBdxnAgbJVJl9QXMRawR3JuWbsQBYzElQ0++nxc7MCX+l62cQxwG
         ndMZomyBv5B169Eg9RdnwSl9HKr/PJHTlmoz5Gqu3LpHKCpDo0pggH92cFEZXIoDAn1I
         nlpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b8yk/BaeTksLn5Ogx8FpbgVk4TSQec7gWJcIZVnJOpI=;
        fh=e35j3KwpP1c5kdmzLNHcHqW/CsXinemcT5+rdrBH/1I=;
        b=GTgN5YFNvqqv+lMjaeiqVNuXL0T5fZwBoT2kqLvVyiQuFMtEXfTJWatm6FDxrOPCLo
         WY1deYArekUCDKGotq/HMkHR+9YKRextEXmiIxNglyDegFUuYXx6eDB/OZYjzcl/o6bE
         nwFpV46NnXOpjugR2ImRQLE2rHCZ0ITz072clTlfI2rVoBr75JYJH0/QIp/HuBvzVVzx
         WvkpovRUxsU/uKlumE6XQINklJ+HD2W87cBGmPazMX3h5lGDmYzGokjW94LLmXELyqOC
         2oC3bWy9GMiX4ElXQc2+Jk3wZOhcRbVheMVK5MDAAMczmrfsM/MMV5zXulDnfJFobZ2u
         ATIA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774272376; x=1774877176; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b8yk/BaeTksLn5Ogx8FpbgVk4TSQec7gWJcIZVnJOpI=;
        b=U6jNl6z3Z59lGeJ/6COmY6CP9fvVeB4nlmh5g1fME08UPzv0IHe2DSmNGc8j+8BPJg
         I05HymDhcWUEZerL+W4u8wIT4GT0sZB5ru3YMzdDlHg4AuLhE10yPaHYIZkjfmCwV++F
         MM1lq6lItJRB7mwOvB9cv3RLahvhKy1cpqvSZDLT2Znd6JknCJ6NsQybBmBPaaCMu8Ij
         CElKEctYMYxlIMgg2QsPKa3ysb0kpRLspze+5Ojv1uNA8nl/ibW5ajj12gs3gpDRgm/C
         NnhoxqnQ4kgGQieIUiQm+tDk5yuHrkNzFm7TpFwfy2vPLXP6JtdipltdzJBH8gHzs20U
         X/+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774272376; x=1774877176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b8yk/BaeTksLn5Ogx8FpbgVk4TSQec7gWJcIZVnJOpI=;
        b=g0x8HroIcdH6AiEyv/+aaaOdhsc2vb2iqxY71DvfssbJBdK4iySk0KoI6QAKMKHVam
         V+CHeoD7JXEg1A9ypx4AfylB0VdReimCqlg0U8LlVHmgyYjCcnGZVZg+k/3k69RlKuo4
         CjEpAOWHwsHnOadTsZj98nl/gntErZpSaHRLyp5uA37xK/OItzyVGCpUWpj6G5wEikUF
         X4gRKT/o60fUf9tmT4nJZHTlx0SOiIZsndA83HCkKiyK9Qhd/kbxD7vyu7U3oWj0nX9Z
         ZEUNRugWK9COCxDB0234YTgiUaoi65XV0zSJFV4fUBnjnxDzhGgIWuUaOVIADf3AOd76
         b2kg==
X-Forwarded-Encrypted: i=1; AJvYcCUcCAKHrkyZqKJ9sH1Lg+s0OaUuJtumDDSiuvYkr4sE3MyHi0Ch9e1EtlmOGwNRpQ0TzpGug4nl1A==@kvack.org
X-Gm-Message-State: AOJu0YzZb9WmKGqaX0BfrlnHwJUjOj/m1LA7cN28AkC2Hsa4Vagg/BUM
	2ayYvj9aSy0gncuya9XgftDwHjDPU8FT1uLQF/VyBqEO1vysvaNIHPiPhD44V1BzVrZ7oHjx2tV
	6u+QiTJ5d4VvcqHQYRZ3fb1kvy8BLid8=
X-Gm-Gg: ATEYQzxHAOyU5abdxUdtvDHPrCCG8vs7WPIrgwfNk8vxX0PbUKJmBNIhaLydysSYJTu
	iHYIpDZjfli4ElgH1KZTmZPeTVqnia6+Qw1eCP81ym+FF6xqr3sxofUOAHW8p60+HaftGd6TJZP
	M33pOPBqepUklwYsw1Noc+jMXg1TBBkpjhQ3ztH/EZAePEoTHEBu4Rzd3CfdNR+M1pHTaUdl7gU
	c1dQULo2b5znaH/E+AP5TWd8VQlwDItqoSs9w4lvKgfmm5B8Ad8GLuyff2+nmUcjdU84UYj8+Vf
	RXUIF9/poB7c9w9kb2M/wfp17gIR/XkhfURDpzn+Ne5WyO0E1S40wPokdD78ZgEo7nH1mn8Q4Mx
	VcrFAWd8rHx8dWY1Gpx419iOAQgnfvunxJA==
X-Received: by 2002:a05:7300:3215:b0:2c1:27c:758c with SMTP id
 5a478bee46e88-2c109938d44mr2298180eec.8.1774272376046; Mon, 23 Mar 2026
 06:26:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260322192159.88138-1-ojeda@kernel.org> <20260323000327.111235-1-ojeda@kernel.org>
 <acEP7tl8pqFA3tK8@shell.armlinux.org.uk>
In-Reply-To: <acEP7tl8pqFA3tK8@shell.armlinux.org.uk>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 23 Mar 2026 14:26:02 +0100
X-Gm-Features: AQROBzD3BkPQaIE4qxn0GaZ9qpo8tZ7H6ULFyxikznbiRv24VDJjkNXoA95umyo
Message-ID: <CANiq72=dh=jTORtmHfv3Z56qJoK4K-0Bpzew7CTYn1qO+sR9_w@mail.gmail.com>
Subject: Re: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Miguel Ojeda <ojeda@kernel.org>, a.hindborg@kernel.org, acourbot@nvidia.com, 
	akpm@linux-foundation.org, aliceryhl@google.com, 
	anton.ivanov@cambridgegreys.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, dakr@kernel.org, david@davidgow.net, gary@garyguo.net, 
	johannes@sipsolutions.net, justinstitt@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-um@lists.infradead.org, llvm@lists.linux.dev, lossin@kernel.org, 
	mark.rutland@arm.com, mmaurer@google.com, morbo@google.com, nathan@kernel.org, 
	nick.desaulniers+lkml@gmail.com, nicolas.schier@linux.dev, nsc@kernel.org, 
	peterz@infradead.org, richard@nod.at, rust-for-linux@vger.kernel.org, 
	tmgross@umich.edu, urezki@gmail.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 680D7A0012
X-Stat-Signature: qj4w8btiyodprzbqseup6u9t3pn1yty6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774272377-185751
X-HE-Meta: U2FsdGVkX19beHFfwd2ZGt6V8iQ8LdQxkNFJpy7da6kZuTs5K2YDPi/uOiI4CwBBbdxW6hDGEkjZ/M7ZbRlphsbNme2ZCxsAaN/KJMv9IlZ4g+nUaDqbzjuKUvbFjKQ8wdETDaBbAxGjcp6iE/DuqocyWOCcOxL1fR7F2E05UKuy+Vd3OUGSBDpPOr2BLZPMRiweg/KLYtza3Y9Y+3ZXHKD1QDvHDivay87I1iK9EmjOsfm2vACee3VCsxIag8/MJ+qNvZhltOsReLZqcssccEjNvUqQBJtJOQYVnVdIk8QAmxgg3Iuk/VoS/ZYJLC98siuGfTE1AD5XeKMoslkLEa1vo9PYp0wJHoQpewPFN4eYzErDhAtDZq+Bwweh7xdNOqoMJFCUvrjYgXVDZUN/In6foFX32DCgkhNPIivQc0nQv+us0E8QqWYrZq23RpO/IZXwTzno9iuXFQECe+9xFg5691dmGPBHL4g72CdN+/WxiWW7OScPPnHl+GJoNSQRnnqnpulTa3GTUQJh8RN3dl99XyD8HjcposxTbyXoImwHgMbNO3+Qg/UPAiziWHo3YFrndxnWjZV/btKz7q4xWLVQb7+E1QGSonFC0Krw7f8/KqUI0DdJet7qpTzXuqkiYLf1CpdDj0vT+TwlcWTE9pSvwPC7bs9FVxkwOoP19SShvVj3fNHsCU5FQFugGtF7AcUjMZT5iKB1Av+MW6EDB5qQD8AR5a8lCWL4dhHw8l5+rEs5+l5nAZzePPeHA+WZo0j0JUhq+Pt2+YTwoJ/QtbvIP/eHEhFC4Ab6n/VTpf8SJpKXL0WHep8PHRq+J8CaxttXWm0NnDAVZ0svmubQXkV0dT/33PVrt90kXYovKuOXPNgD2MrW+k1Dum3IcU4lenD+3KuWyVjCGfCGh2XqEAVssNSyObzcHsT7WspZiPrCccWP8RKy58De/KSLTMmHEtGaqtZneyYZG8Xo0J6
 y4bHFHwG
 8Y5fzwImJwntsDoBLhkuID6NIvW/gztpbQMKL2cWj8yyDXlkI9jBcoGtULM9ddGIEIr+hb4OLixyV9QXtbUNxKc5v9KrWoaiUydwt0CSzpSOL/CKQTEpS+4KnLR45kyzEJjzbYx7dQHXqPLXcOvtWZV+dZWpvB2Rvgb/fcAn/cabnzCFpSIlNvTu98W8q2CXdJbWla8AMyOb1qTc7sa2EyoQ67mdDbPTHRmMJWiKxDXENjjs137DrOK+WERYIP0J/Ty6/iw+MoyN3T7y0Ld1tS+ODyXw0vTTVZCCRAH+ihhp50JfWBInz9bsAMRXFYgqPGteX8Dc0ZIoX//O8+AvGs9mpLnyl2x1A9bHhCtCTcEMG4SRv6HtWrBblPKjvggdzFFUxzNV4jB9/mSXByuX8PwQAwJON9EEAxijGUCObOdYaAQse0J0DKpVffqRfnf9deO/0YXH5R5UUxyyIVLrAEgiyOs0l+Kcr4sY2/QHj3zofM8qIflx3HfaFv/Yxy0jqTpKYceKliveZjHL/AyKp/DdU1Acl4+e9nmmomo18ADqLjm4cvVm28BCWMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 11:03=E2=80=AFAM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> Why is Rust generating code for userspace thread accessors for kernel
> space, where userspace threads are meaningless. This is totally wrong.
> The kernel must not reference __aeabi_read_tp().
>
> Note: I know nothing about Rust, but I know enough to say the above is
> pointing to a fundamental issue in Rust for 32-bit ARM.

If it happens outside this patch series (i.e. the new opt-in mode),
then yeah, something is broken.

That is why I proposed to gate this new mode to the
architectures/configs where it is known to be OK (and where
maintainers may be OK with it etc.).

Cheers,
Miguel

