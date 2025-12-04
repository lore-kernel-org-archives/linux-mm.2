Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A723BD1F9DA
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 12:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CD326B0008; Thu,  4 Dec 2025 07:49:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07DDC6B0010; Thu,  4 Dec 2025 07:49:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E876E6B0029; Thu,  4 Dec 2025 07:49:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D328B6B0008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 07:49:38 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAB471A010E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:49:38 +0000 (UTC)
X-FDA: 84181770036.26.3B93496
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf12.hostedemail.com (Postfix) with ESMTP id 431CA40012
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:49:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=crisal.io header.s=fm3 header.b=QWmZQmQ8;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="d 4LUKr5";
	spf=pass (imf12.hostedemail.com: domain of emilio@crisal.io designates 103.168.172.157 as permitted sender) smtp.mailfrom=emilio@crisal.io;
	dmarc=pass (policy=none) header.from=crisal.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764852576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bT7FHjsbQ8DOCUyp+kexyJRmQz7YtubohaLbP21dgus=;
	b=jkyr90MwxQ3kc4VbJMMr4L88+my/753DGgPMGfEKlWL+JJYsEejLK0eF3ZKQ9uGh7YVxr7
	bmIMfWHEbH4KJHodMqJyrIJ1XcOR73ylGkA91BthrvA/DB3Dgiu8fiX2qyW9BKwDNUipyE
	xJFSBJHxFwZENX2B5B7UUcKT5TKP0g4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764852576; a=rsa-sha256;
	cv=none;
	b=XGLfw9cJpVnBrMNW29HAt+VsG+ftKvK7Rg+biLfEqMfT6zfswNlN43oFUwk9ALRr72CS92
	Uajvy/rQKoNgAOeGnQ9TizExkKXEv0zdCJgNHwzDlSzmNrepKpI0OEL6FInGdQ4pIf34/9
	I5TyfeW+wBtiAov2ZEba93OvmhKUlQU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=crisal.io header.s=fm3 header.b=QWmZQmQ8;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="d 4LUKr5";
	spf=pass (imf12.hostedemail.com: domain of emilio@crisal.io designates 103.168.172.157 as permitted sender) smtp.mailfrom=emilio@crisal.io;
	dmarc=pass (policy=none) header.from=crisal.io
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 991E11400224;
	Thu,  4 Dec 2025 07:49:35 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 04 Dec 2025 07:49:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crisal.io; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764852575;
	 x=1764938975; bh=bT7FHjsbQ8DOCUyp+kexyJRmQz7YtubohaLbP21dgus=; b=
	QWmZQmQ8drjAUhtM3EKvi9IGmEYwlgKHmD6DEeMNgU1cDITtkm36or/GKRANaoSO
	ldYx9isB/WQ4SZXIerr5uQo+UxQYmmh/PJG6AXetuvXIoH07o0SDg4YUkdn0yR4+
	1OnQpHI2je4URQ40n6B3dLaoWnB/o008x8JaKfDUn7TrJRCDLtewnPFyBmKSUFS2
	ZOQl/zlrwFYab0Ve67HfSmoS29BlXzSWYaQxBMtlFC8jKw/dfjQ/wxKFGp4v4Pay
	NWU7TQLKGT8B+wsa3s/bSqkMwwCqbKZHhIaS3Q5DNDEb3foa0oWd7G5sRREhKkMZ
	8dq1SFoEIz0kWvxuRfalVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1764852575; x=
	1764938975; bh=bT7FHjsbQ8DOCUyp+kexyJRmQz7YtubohaLbP21dgus=; b=d
	4LUKr5Pp/AGMgk3O3ccRP4nFv4Io7xt6Yczuf7gA4oWo1kiWLWr7PQ9kDT/pG0Pk
	HM2MWOGHqfjtswp8SVvu0LG4Nb4fRm21E+/iG6elpHLVYM8YIXGb4G8ntt9S24WB
	XTgi15cJAKr+QS/7EdUStOb1gOb1emBxGgjWRb7F+rlsKOEDvn1pd8KepUyyLoro
	4C/XBFbXQM6IpoyFHLAaGANyvlxFW3ZduI3qT06GMX9VwaiV7Z6LXEiN87/bA9S2
	MeCDqCiAWvyOSQ0EnG197hSFQqQwHugp/S2JBAD5DeQRwPuW/rrltrlMBoLAE6TP
	Xly7EjxYU5YgnWddZy0bQ==
X-ME-Sender: <xms:XoMxaftIg9lrhKoIsI9yLzV99-PYFh6m5AK3y1GkUt051fQ6pfxc0g>
    <xme:XoMxaXZPsINg-X6_SpHYviYJ4t0xaxgJwE-o_NHkbfsQGUfZziOxUMo4omiiY9762
    AKGPXJ6TVr58smEizAy1cVxbzZwwD5w6L-8ZcKkVfvrFEvHkf7azUU>
X-ME-Received: <xmr:XoMxabsOsdheTnf3G4xTEk0PswJW9moz6ytx3ZYLJYQg5IdWKx_sr3rOm2qP-iF00UcAUJGcxEF1ndCSM3PnF3iYfM1mzW1o_oI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdehiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epkfffgggfuffvvehfhfgjtgfgsehtkeertddtudejnecuhfhrohhmpefgmhhilhhiohcu
    vehosghoshculmhlvhgrrhgviicuoegvmhhilhhiohestghrihhsrghlrdhioheqnecugg
    ftrfgrthhtvghrnhepheeuieejvefhkeekffeklefhfeevteetueethedvudelieeuveev
    ffejfefgfedvnecuffhomhgrihhnpehgihhthhhusgdrtghomhdpughotghsrdhrshenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegvmhhilhhi
    ohestghrihhsrghlrdhiohdpnhgspghrtghpthhtohepfedupdhmohguvgepshhmthhpoh
    huthdprhgtphhtthhopehmihhguhgvlhdrohhjvggurgdrshgrnhguohhnihhssehgmhgr
    ihhlrdgtohhmpdhrtghpthhtohepphgvthgvrhiisehinhhfrhgruggvrggurdhorhhgpd
    hrtghpthhtohepsghouhgrnhhtohesiihohhhordgtohhmpdhrtghpthhtoheprghrthhh
    uhhrrdgtohhhvghnsegvmhgsvggtohhsmhdrtghomhdprhgtphhtthhopehgrghrhiesgh
    grrhihghhuohdrnhgvthdprhgtphhtthhopegrlhhitggvrhihhhhlsehgohhoghhlvgdr
    tghomhdprhgtphhtthhopehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhgpdhrtg
    hpthhtohepohhjvggurgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepsghoqhhunhdr
    fhgvnhhgsehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:XoMxaWA_0XGjWUyj_omVPnW4Dam6xBxCotJNmgzJmPJ3qtDD2osQjg>
    <xmx:XoMxaaMeFf-Cwgb1A2pglnMdApsgjs1BngwagP-9o2gnEr-PzItVWg>
    <xmx:XoMxaY6-KS1B4Ffc8pO7e9EuUPJVxSPDC1857Pwst1BJTdjw6ODvrg>
    <xmx:XoMxac3U4poM50Z6o2Wd1oal5GRpfXfVWeXWEVSl9yFtxXjBu7b5kg>
    <xmx:X4Mxae_ro2UZcjWQsPKA-TMcEQ9dSlR2xZk6FPrIbaiE5NxqtEzhotki>
Feedback-ID: i2e3c46c1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 4 Dec 2025 07:49:31 -0500 (EST)
Message-ID: <dd5856a8-e120-4884-8828-9d0c9edc60f0@crisal.io>
Date: Thu, 4 Dec 2025 13:49:28 +0100
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH 4/4] build: rust: provide an option to inline C helpers
 into Rust
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Antoni Boucher <bouanto@zoho.com>,
 Arthur Cohen <arthur.cohen@embecosm.com>, Gary Guo <gary@garyguo.net>
Cc: Alice Ryhl <aliceryhl@google.com>, Josh Triplett <josh@joshtriplett.org>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Nicolas Schier <nicolas.schier@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
 nouveau@lists.freedesktop.org, Matthew Maurer <mmaurer@google.com>
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <20251202-inline-helpers-v1-4-879dae33a66a@google.com>
 <20251204100725.GF2528459@noisy.programming.kicks-ass.net>
 <aTFhFXCqvy7nmDOp@google.com>
 <20251204111124.GJ2528459@noisy.programming.kicks-ass.net>
 <CANiq72=r+Fmu0uuNF=6x36GWWQZGZk9gApnMZxakJavviwG+ug@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Emilio_Cobos_=C3=81lvarez?= <emilio@crisal.io>
Autocrypt: addr=emilio@crisal.io;
 keydata= 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
In-Reply-To: <CANiq72=r+Fmu0uuNF=6x36GWWQZGZk9gApnMZxakJavviwG+ug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 431CA40012
X-Stat-Signature: znydwrq8ggqafc8swgd4a7bfb5z7cgjd
X-HE-Tag: 1764852576-881914
X-HE-Meta: U2FsdGVkX19jgrJuFrEDH/whbeYMjga/YBvsY/4R0+cQOkcnfnw8O1HD+6A1cVsNcO6jR3YOVHpHfXs98vb/wynkhxBHzpcL9w6FRm8N4JCHx6ewbWrh0rlWrmFb+5uH0h+zPbXI8+ueidkpKCARJb3m68et6+Ql8/yLfzQU8zWEQufcR67Lx7ByLUi6wkwmg7Q+gzhwPtqOK5ACBc4+L2bfrGvRdISyPFtcLkAQGdnO1v5n0cFF3L5bkf1lEdzYS1SVRE6tS+MfPfE49HuOBCFWdxiaHf4y7DiKe6+6uH1uFsasebpfV2/be7Cq/j4lDXKyqRPt2sBw05/1cYnWSYD+SXpyA7NRRSRjWqVSqbvgOldbhcT/K+JoXhiBBjWzHmDbtQccEW2tQhrfKAAbaB9dmuUr2RTi4LvGQTsK1oGFbDdYQFJ2kbI4Tw2MNjvaHhInGf5Ip+64vVOMRwJMyzbyP/Pqg3ZBLZmK9VtiKigZ2Mpt3KlcL8os2jA/QEWRcDPwLLMjRhTQUCj0J1+NbSlAPFJiTQ60JUbhLDVYPO3JGIViQHi2YnpwWjXGR2RILbUJAhSE04GsLm9XJIn87UjyYpWaPGvfmxvpYMaQf1piVbXwj/XOJlyRCkScgpmXwEQD0VWa5te+p6c26GfkFSS6VpVaM2B5fL8gMPOCcmVLQngmCJP4HszGqwuf7cLQG1tXnjHADGKQZ/sH3mBmk3x0ncI8b3jiKK52zi8bkRAogN2ysw0vST14V+asbKmYffnN4zvPUuLX/DDUNrHJRKfMnWjQ7LduRxdDBZCO06Suh7ChctyKGzSUWOBd+fERHs0JW5vG6Gj2W78HQdB6TUGQXHdSYaHzkBu5HYdJbcm1+Hn2/JabFNtjXUEsl7/5Q2Q4N6wgrfefDzdOozKt6msztM+L0ARG2b69NRKwDGWed59/RIAdOffALkrujFEHhd+U1fv5A8O50JiOr+g
 oeuDtIQ1
 SnqD4v5ao+gxyGBKmfVl6TyCfVnX2R21NM2CPIis1ulCLJAYn6BGkMLaM19p7H5EHfxDzmRTE9Q8nircpMAtOuyHmSbscwimf9gjfTUrpMClJiAVCuKxYI5U9qODVFM3/kqq+Su8My91ADdOxMm5FoJpwYd5ewLaTYG0yjJHvRHRZdxGIuYdLRdN39ue2oSDuiBp9z/PW/EHBzdIsH3TlkV85Lg5R4Qt07kX46U3evq/wZD+bitUySAtu7BP0MQeruywCWUy05FGeCNI8LinEeH6PHeLZcxPK3K9iTNbL8Cs1CxoeCEZRDC7/dSau47pwr3ptRT/EU1m1O1evdMVxKdN/casHELaIO+bAPoGB4+wT/Z+dwf/4f6I5htKATrjB+Ncyunk2xzKH9khRK3DsyyU5F8xwh0Zv3yV3n3+q/Df2/f3zchI/w0/WozDOyAvhCzN5E8AkpgTGtV9MCk71PdMC32et5+Xo0fsecD9nmgEuBQZ+y2pGBqtVpRXyutckdKfQK/axeMOYJLK5msg9j8Mz5191HjSV2wEsODXMpcp3jwOMSRT8P37tFZUjdnaPPnBIunQSObOlHW2dkrIjEwkszJeYIS9qcg5wSEmCvpvsArwQCau7q56ezVGw3NZiXCkwK94cS0N+eEe+KyE+D6FO0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 12:57 PM, Miguel Ojeda wrote:
> On Thu, Dec 4, 2025 at 12:11 PM Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> Right. Earlier I also proposed using libclang to parse the C header and
>> inject that. This might be a little simpler, in that..
> 
> Yeah, that would be closer to the `bindgen` route in that `libclang`
> gets already involved.

Yeah, so... there are existing tools (c2rust [0] being the actively 
maintained one IIUC) that in theory could do something like that 
(translate the bodies of the functions from C to Rust so that rustc 
could consume them directly rather than via LLVM LTO).

I think the intended use case is more "translate a whole C project into 
rust", but it could be interesting to test how well / poorly it performs 
with the kernel helpers / with a single header translated to Rust.

I personally haven't tried it because for work I need to deal with C++, 
which means that automatic translation to Rust is a lot harder / 
probably impossible in general. So for Firefox we end up relying on 
bindgen + cross-language LTO for this kind of thing, and it works well 
for us.

If I'm understanding correctly, it seems the kernel needs this extra bit 
of help (__always_inline) to push LLVM to inline C functions into rust, 
which is a bit unfortunate... But this approach seems sensible to me, 
for now at least.

FWIW Bindgen recently gained an option to generate inline functions [1], 
which could help avoid at least the bindgen ifdef in the patch series?

Anyways, it might be interesting to give c2rust a go on the kernel 
helpers if nobody has done so, and see how well / poorly it works in 
practice? Of course probably introducing a new dependency would be kind 
of a pain, but could be a good data point for pushing into adding 
something like it built into rustc...

Thanks,
  -- Emilio

[0]: https://github.com/immunant/c2rust
[1]: 
https://docs.rs/bindgen/latest/bindgen/struct.Builder.html#method.generate_inline_functions

