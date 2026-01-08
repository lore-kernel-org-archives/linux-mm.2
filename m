Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E77D0D1D482
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 16:26:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 541066B0092; Thu,  8 Jan 2026 11:26:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EED66B0093; Thu,  8 Jan 2026 11:26:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C67F6B0095; Thu,  8 Jan 2026 11:26:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 298446B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:26:03 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C6AE2572FA
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:26:02 +0000 (UTC)
X-FDA: 84309323364.05.2A0298E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 66AF620008
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:26:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XrjTyWmG;
	spf=pass (imf13.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767889561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DvwHNF0682S9ASkYk1ACbHMfBzqeS5w+nn/tykZmXjU=;
	b=VU0Y0aHiJU7SKhBbBQL/chtznsTi58kOK3EyOABx2ctNbio3P6Jbc7VBTv6bpa/y8ZAUug
	bPibW44X9YWLVf1VbeAvH+dyhhVozzXU55eoi2yvr9dOjDUY6a7QdTzY5m5dXJUDwJl25C
	dnrI9V5njxKq7rL4dTe/h1QpfqyJ0TQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XrjTyWmG;
	spf=pass (imf13.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767889561; a=rsa-sha256;
	cv=none;
	b=Y/ndcqgKPRPQ4uQuo5tkRZn+kMm4KORHbqYVrDoBFUhnF3poWKGKg6kmeIdp/LRHuFoCkl
	Z15XM4Lznr/kXML7egxTTx0vTnHPAqRy/bBONvt6cuL7fGQEXy2IOViWtHWWcncRyN4RKj
	5ImNu4ZVdP+tSpzOclWlPJlFU9HuVV8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C9E86012B;
	Thu,  8 Jan 2026 16:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1C6C116C6;
	Thu,  8 Jan 2026 16:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767889560;
	bh=OQxDuNgfE6e5tF4qpwq4v6IWP64NBvnqK3wmGYcyRBU=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=XrjTyWmGlM9ynS+kE26WK4jWibbKKPLMLH4CBpcdhpleY8DPE45SA/UTzeXmERy24
	 mJ+bBrcHNSnuJqBMo+ZxKOtxxbkobRs0QELFpHk2Z7U3owKAcH3fcdtz0syeOcU61U
	 z6dikvGvgVC7qTCzSXkLBy2Gjmac25yXoX7s7Y79wP8niEBFgC87wv5ceryJMxvtbQ
	 PbUU9O8SUola85nvSNQju0ZcS+8OELA8AVILAo1bGJJHXBHP7pwHVwU5R7IuZVsKeG
	 5NT85m/20ljCZqQrzL3XnjHB59ocPhq3OMPbh0ThCl2b812NDixOgLf0NFWIUrBAwy
	 ijChpFvHraCQQ==
Date: Thu, 8 Jan 2026 09:25:53 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Deepak Gupta <debug@rivosinc.com>
cc: Paul Walmsley <pjw@kernel.org>, x86@kernel.org, 
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
    Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
    Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
    Charles Mirabile <cmirabil@redhat.com>, 
    Jesse Huang <jesse.huang@sifive.com>
Subject: Re: [PATCH v26 00/28] riscv control-flow integrity for usermode
In-Reply-To: <CAKC1njQ-hS+kUJ0C_v0oqZW1EZw2zAXMp-SnnA-ZXh_H-SoVdQ@mail.gmail.com>
Message-ID: <30f969d2-794f-937f-53b7-3af3f2b88ef7@kernel.org>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com> <e052745b-6bf0-c2a3-21b2-5ecd8b04ec70@kernel.org> <aTxf7IGlkGLgHgI2@debug.ba.rivosinc.com> <CAKC1njQ-hS+kUJ0C_v0oqZW1EZw2zAXMp-SnnA-ZXh_H-SoVdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: crw9ab4s7rkaar78kdzeqaiorbp6gy5o
X-Rspam-User: 
X-Rspamd-Queue-Id: 66AF620008
X-Rspamd-Server: rspam08
X-HE-Tag: 1767889561-934098
X-HE-Meta: U2FsdGVkX1+A2DuV0ufqH8hD65+umLRvU11M2YZr7KUTx3sYRL3mwc2/KriYbHU/p400PFQihwzQKmJvfXeetsGzMAGd1Yo+OjVnaL0StNao1q7qOr0Os584QAeD9esP+aqf4nllvchj14aDEEjdDwet8bwzenNAlQ7tlCr9ACwm4IfmhU0lSbzTqkQqu87ZzmiQKSbafmKlNuo8Xh3ltf0ouKwjaS69KHljwN3+9llkStBhV5Yvl7qRAhfHieWxDerZmXT9O8xD0K/ncp5FpfcAB1myzQqsId0Aq5Nf1oKenleqySmClcBLKkCYE49wClZTdtreN25OnWz+x7POD7Bxcu1Svx7ziEw62UrPHut55QF9+89lpkm+o7UqmXikG4Urkpp9delLY7mRdkFzYgKR6J6zGOnWb6P3jNGnBUc+RoUkP/WSGMDE4CgAdJ552G6LdmfrexEdLNEYbFVEUfi60yyYxQodC6bT3xTmiCHL0I1jjKYLPOU6Jvd4g7UJsoxf+uNpdY87Ai+CLAJwCJyoCYDAEOjSn8YxITQLHsitvjyDMS/xYehkWqVa8KCsLxQMCgIkNCMjntEp8wPU6RbPxAzKTHo/pz7BsPF+YLpu28MdNXFtJreBrUT54lQmamUZ1PKubVH7DFVwhGhs+qYmB1EVJh1/YvY85kZM0haye6tTQ1XSsXbZbbXPnV/U0RZFrnuLGXigcCpbXmsbKjTsvbtZqNArROCGsWEMenFtHaxlL1dMEMAQjRJdIkEjD2UI7aspUM8HwSXEJrcI4hmbOWTKveKJ3ZpmYwful36zCDwVYMRajSkTSKkTnKG1mkt2PS6kjyA7zaDOYIytuj8wfyLszXHKjKUGojemhBfbltzthenUSWbCXexQti1OOvV2i42zafzactLvfgx1TNTNcrp4CNp1kO1g75H4VwgCKpUVc9lPWEriMH0fpzV8yAMonubboKh8U4WiC19
 ACEnINwm
 zG3DP3khFdMNMxhd7roH+X5Kntg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Deepak,
On Thu, 8 Jan 2026, Deepak Gupta wrote:

> I have a bugfix for a bug reported by Jesse Huang (thanks Jesse) in riscv
> implementation of `map_shadow_stack`.
> 
> Should I send a new series or only the bugfix-patch for implementation
> of `map_shadow_stack`

If you just send the bugfix patch, I'll roll it in to the patches that I'm 
applying.

Thanks for asking and happy new year,


- Paul

