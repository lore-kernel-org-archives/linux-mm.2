Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16EE3D44144
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 08:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35A516B0005; Fri, 12 Dec 2025 03:30:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30B126B0006; Fri, 12 Dec 2025 03:30:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220376B0007; Fri, 12 Dec 2025 03:30:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 116DA6B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:30:49 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D1FF59036
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 08:30:48 +0000 (UTC)
X-FDA: 84210148176.27.68D1174
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 177E040013
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 08:30:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcBuqNIl;
	spf=pass (imf01.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765528247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nl0zEU2Zc73faKKjdjinury8Ej4lUOtL6xr59x29zsc=;
	b=WFJWhudB1nnob0sBBe2XB+vYZO1hyrZ9me7ktiNm/vN56GsUeQto4FMTR8IYT39NzDgOyu
	K6ha2SyIk8ow/dnJFTlIG7OZG9llNW6ehqNp2Nr3u2cIv0XkN1cQ/V5rTPFWYXCeo2Bhpl
	sWDm3ZKDnh4gPFRGTV9OYfjUGHRk3B0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcBuqNIl;
	spf=pass (imf01.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765528247; a=rsa-sha256;
	cv=none;
	b=GUdGI0POpj4DI5rsu6MuEKZ+g5WZjtJSPAlFdGL/lauGU3Vu8fUAOjtZeChU6U4vP16NUp
	E0Hk3aKMx4ZXvYvB6fLq+Ysv8JS66TebbD391/TrmffL1JZyXW5pNG/lCLHT563/imj8ND
	ovEYCoSuevUVWI24o/Wv3P0QShvxmdY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 47839600C3;
	Fri, 12 Dec 2025 08:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FF1C4CEF1;
	Fri, 12 Dec 2025 08:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765528245;
	bh=DRPzZm8wRyj4mY54tq0jM/zwgD0vFMbcEQzT/w8zFyM=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=dcBuqNIldXTL6nxc9vHRFmJK1q+pCEpPXDnMynSxTcTE0f5CMeYb1YC/QYimK7HvL
	 yW9ZIAMunbbNR/XddaD+W2WBzK9ITEOc9Jpd/WF/oFxZGqgMxWJaYnhPdWS/2ZndYV
	 QvTcZ2zk/8XusiG2mEKWiyswaxnlL8kucMpgGRGKUFvBmh6HToRFzmjdMzC8iFklZ7
	 C/w/rAiweFwaGnDV+0vs7+eq/kMNQh7nLuDIAH4TZjY2J30aoCpasEx9IT9zYH+9Ck
	 kNK9eY7wcDmJuvc2ytWrBRu1KTkw/s4QBwSvxfmd6ToD+GB5v6srhdPSZeTpE9iyRE
	 95/u2RrgtAxkA==
Date: Fri, 12 Dec 2025 01:30:29 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Deepak Gupta <debug@rivosinc.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
    Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
    x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Vlastimil Babka <vbabka@suse.cz>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    Paul Walmsley <paul.walmsley@sifive.com>, 
    Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
    Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
    Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
    Christian Brauner <brauner@kernel.org>, 
    Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, 
    Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
    Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
    Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
    Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
    Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
    =?ISO-8859-15?Q?Bj=F6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
    Andreas Hindborg <a.hindborg@kernel.org>, 
    Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
    Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org, 
    linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
    linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
    linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, alistair.francis@wdc.com, 
    richard.henderson@linaro.org, jim.shu@sifive.com, 
    Andy Chiu <andybnac@gmail.com>, kito.cheng@sifive.com, 
    charlie@rivosinc.com, atishp@rivosinc.com, evan@rivosinc.com, 
    cleger@rivosinc.com, alexghiti@rivosinc.com, samitolvanen@google.com, 
    broonie@kernel.org, rick.p.edgecombe@intel.com, 
    rust-for-linux@vger.kernel.org, Zong Li <zong.li@sifive.com>, 
    David Hildenbrand <david@redhat.com>, 
    Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
    Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
    Charles Mirabile <cmirabil@redhat.com>, Andy Chiu <andybnac@gmail.com>
Subject: Re: [PATCH v26 00/28] riscv control-flow integrity for usermode
In-Reply-To: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
Message-ID: <e052745b-6bf0-c2a3-21b2-5ecd8b04ec70@kernel.org>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 177E040013
X-Stat-Signature: rpu3fs549or35y7b16sgthdbdh6yz4mq
X-HE-Tag: 1765528246-441184
X-HE-Meta: U2FsdGVkX1+gJLOGNLISJh8x6furTGUvYQQsPPxi2oNyatEt0zls/+cSnzdJQD3ZmHLmX5nHUCTmvl1/ubvP4/dMHFPlvFgrRWFnu+eB5U2twmeEOMvQYU/MFQpCybVoCyQT/6bwbuf7VcKgC5I1Igyawuy6Z+rd2Y3KuiKaV6yU55VK7yHnX61TNMiXZk9LspB9N3hdfsDAsjw63//mWjMWnK+gnAsyi59rdNBYHAkYKcZSnsR4hPOjlcAGBoEXiSbtF5hPQin7sIzy7qKSOHlHflh3b+DX5bZUUhH1hr7FAp3mpVo4vZ5yKvsrQDd4FPSvekLI+l7p9BONvF8pQsL8STa3iXmNObTTB2MfIe1Q/Q+FByQbtqtuycIJHLvoKtavrXce9DtCodoUOergAzA9XlcXug7DgvMw5x7hSCNMtKuXbGujm4K4dFWHYxZOSEzkyxL3TOjEiRWeOj7yiSVxpoWNEjIGxarKzT/Jr9vUUP6fyG9SOCjE3MIWnqWjZYe1b52jgB8tiON/CpjIH57am14or9fDq3vN0wh+RZniy/d8U8TshIKkM/VKWTFOkbc6er1/mxISEB+NeU+et23t0tMrdSf8t2qAH9UM1o0CI9edZcerG16wXTNzvYCRNCimnMYVGt/I56apSk/zOjaCfueTAX0+mf/DJdgBfLKXumOYdEnPf7yrrt4uz8llMaJkUCPVqh1xdYuWGOOhQQNEj4aulPFo4fhSzw3kzZd/ZVoHq0tmrlY7ZOC7pPR1ubTi2o92WwUjZbrqHERN9hidnYPACH4A+1nVRAVwfAUSK5KhMWQV6FLJBfGalARaE1tAuA9cdXV9VOZwn30xVXcEfMYw5sZoUl31dvBNgzt1uwThQdIclUhHmUuO3plW+TO1DMJ3k/GHfsWAT1XyzBS1OTjvajVEk/IPxcI0lUQG4wdjIit6hZxCkYnKJwRki6A6hPIrLd/fCN1TNDr
 FH9kGYya
 ubCHtvl8/AXITtM0hXnCUFcGIPrQukkqu+rp544HA8bAP4252q3sLdgWx9HydyQBCGj74lDh6fLYlhNSyPe+45iynUkk+V5KXg/YuKwOfdE6m9XbISeHI/al7/2aNDoB1trn9DjP78WmmfV6eNDslWmmzHPRoAZv+JaKU0rLd8MmwxQ4fGaHFqRYPTXYpR5xAF/fMUvIjVogWdnQDOg0pSL2ZjChzchcQ5MCG6z62ZPYYXyWF1wAiqGGRp9R5oPJbx9LKgPZAkMxG1SyQI0/ozTkPjB1m7QeueM/IojOVVl+2BtyWbTHJ3w7OuyS60oZTlH+86yOqSc10Wg4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025, Deepak Gupta via B4 Relay wrote:

> v26: CONFIG_RISCV_USER_CFI depends on CONFIG_MMU (dependency of shadow stack
> on MMU). Used b4 to pick tags, apparantly it messed up some tag picks. Fixing it

Deepak: I'm now (at least) the third person to tell you to stop resending 
this entire series over and over again.

First, a modified version of the CFI v23 series was ALREADY SITTING IN 
LINUX-NEXT.  So there's no reason you should be resending the entire 
series, UNLESS your intention for me is to drop the entire existing series 
and wait for another merge window.

Second: when someone asks you questions about an individual patch, and you 
want to answer those questions, it's NOT GOOD for you to resend the entire 
28 series as the response!  You are DDOSing a bunch of lists and E-mail 
inboxes.  Just answer the question in a single E-mail.  If you want to 
update a single patch, just send that one patch.

If you don't start paying attention to these rules then people are going 
to start ignoring you -- at best! -- and it's going to give the entire 
community a bad reputation.

Please acknowledge that you understand this,


- Paul

