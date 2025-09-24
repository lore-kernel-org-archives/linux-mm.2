Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B45ACAC5B1
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 14:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 784C08E0006; Wed, 24 Sep 2025 10:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75C038E0001; Wed, 24 Sep 2025 10:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 699328E0006; Wed, 24 Sep 2025 10:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 564CB8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:36:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 03CE511AD52
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:36:27 +0000 (UTC)
X-FDA: 83924394456.30.AD67EC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 453E8C0010
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:36:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sU4qbKHf;
	spf=pass (imf22.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758724586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eSVN/wBen/bEqFxSrYIjjBukQpRfQFn8nH+Z56Ghmns=;
	b=UkajGyIrCGyA/uWBCEEixNsNTMH5DbBcpVVdbsa06qm8F09XN4ZKzvAqS0oFPIOHhuiUpA
	mKTVx0KRm+gql+8fJXzyrfAc3QaCLdNgvpdGPFkMzJkSOdIloOKkun07lSHyDlJ+pXfuu7
	wfk4pm/YQQfIISqTQ8Dou2HhSEuEM8M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758724586; a=rsa-sha256;
	cv=none;
	b=2HIYJXHIQ4qSecfjTjfIfHTI3DJWYtzkC5HTTJ9HfYpxUEP64eXcn5PUoJ8uIMGim+Tt9m
	BnHGsVSNgCFMd4oLMTfYLe0W0Riv/TcD9rv8YMr4sK2n6Zx6kdV81c98MtYfnu8ZXkXAQJ
	+6qKcVPG8X8QNHn2bMpy2QL9Bo1iq10=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sU4qbKHf;
	spf=pass (imf22.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B60D54188D;
	Wed, 24 Sep 2025 14:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F373C4CEE7;
	Wed, 24 Sep 2025 14:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758724584;
	bh=dtMyGOLRj3HY14tPCzeUn90iQCDhGJqxqhE3t2ov7aU=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=sU4qbKHfWJn/GVEqOSKG90PR7kq8un4mmh2XnGkYWYj96nm0vP3t0kpMc9qgQDF/r
	 Njj8+x9+98clpezx9Qbexhjiiqb9LgGf2zO7zaasjP6Aw3ZwagcAIEE8M1xw+MaWmu
	 YUaMY0p/KqRd8zFg6n7QJyC9wlkAy1COyRWfXsjDCyXLlLAmMW+OOVMT0stiJlFThR
	 pSjukkkFK4og3+n0QfVwwodCBFQYwRR1q0tdqFB+L5GUbegS/N6BCgBwxdv/nKP85r
	 1KUsbDv30oxCq+omuKsOLciS1wr91DsaxnZLhDWTt7/0uf59+4ZuwoESQ7BQmcDgr0
	 wKP3Ex22F2I6w==
Date: Wed, 24 Sep 2025 08:36:11 -0600 (MDT)
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
    David Hildenbrand <david@redhat.com>, Andy Chiu <andybnac@gmail.com>
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
In-Reply-To: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
Message-ID: <f953ee7b-91b3-f6f5-6955-b4a138f16dbc@kernel.org>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 453E8C0010
X-Stat-Signature: r6x7zqbarbdrje76zsjrdhfyatbbjaoo
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758724586-502148
X-HE-Meta: U2FsdGVkX19Jk+mSwNS7prUNSfOi1taSKx0KhkgUIQsviSZTzmylgxMUkXicb6pQKisj1mDDQBNaJz8IeHa2pWexQpJXtIulzgbtG2cJcal+ft/2dbI40sDWAa6tQCKT0e/E+4klY+b6mRHDYtrnD8s0mEdFv4+TwKml4Np21yaq69lSudVOSWjY75RzMiULb6ZoNz+tgDQmyH4wDr7w8tNI8Mvc4th1DGQdmHQYLmQUsTi/ybJEc8C6RWa6rirURmc1UXnP5wceZ12lmz8K5vMQbL7+A/Em9XvuLGuog1TYohPxyykrvH9+hn87ND4/SZzqpdCiu+bEZ2ZwQWgWaAbyRgj3LpRZU0+Mgj0v2JnDuwkAR3Hmp/OUzyaNY7y0Q7weX8gp6pYxgGub613VvLuNb8IRmpxaRwkjo+Y/gEwVetMvBegxU7pCNCFYouENSiUrIgEkSZsfKhxK4pJ7gFGCo0s6Xf6y6EIk8lh7uNdXFf+5fOkBuQsZa7wx9jz5RyqOwqz1Y5rnQsWj23+9f9qbGxhFQBNLhEa5/sU5Iig57iOxYVURamsX/vRANZCUNNF0oJZQ3o8AQgg8KyVPsXXRImUNJfBkIrlKJaullA0/2+ELDmSWHeIBgSSo4U1PVWUS4ecIFv+vn2be+KB3R1m+rj6JDWs7je2scafezXJYGj0spfaA+cylOXbpw+JpAQlG8f9g93eORW4b8sLVHVDB96BhoiueG/0JreGA4GSgdNcRUyQTrDvdfgi/hjvsTtzv2SYA2YU5C0YqFpVAIxwv7pM4iewgjthgD7ab7noCBS0Q/yLDZpMuQf0SRRbTU2r6hSbXGiIX2+dMWIaovUAqepx9hP8KzdvyhC+BsWnylvjAhYihIXHRmjVV+pH1JgFdLIn131IQBKzPmHkNVJ+0TstGCfIOaPzhuBt1B0YwHbovVNU6Wq8IiqbzgmWVXKT5R4mKh4Xgn5fBb3u
 wcvXOyAJ
 aird1NSsB3sZFkMmORK0e3OX44HOOmNza1k5gHvXkvJQd3Qd5RTC5Vczla4Ddcy1UMDpLziPV7YMUUbdC6bjV9eebhqEzok9sQc4Yo+E11qFyOVwU9GEtLp9RmBvZ0994kwxloJWPAlWSNcP13UBgZicbJdasbTFeZ8M234uQzG0y3QgZ99S0LOWtomN/qa75gGHArdz9fBrErO22lG/K0t9XWIjY3RpO041C0an6uh6+BoN0sD+r7i4IaMEgr5GpOIoJsklqKrWFoLxSYn0T+MWYzOHhqvi5QGmEtgJLNmB1nBxusKR8rts9SpoQiD8KMEh11wPKzxDj440=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Thu, 31 Jul 2025, Deepak Gupta wrote:

[ ... ]

> vDSO related Opens (in the flux)
> =================================
> 
> I am listing these opens for laying out plan and what to expect in future
> patch sets. And of course for the sake of discussion.
> 

[ ... ]

> How many vDSOs
> ---------------
> Shadow stack instructions are carved out of zimop (may be operations) and if CPU
> doesn't implement zimop, they're illegal instructions. Kernel could be running on
> a CPU which may or may not implement zimop. And thus kernel will have to carry 2
> different vDSOs and expose the appropriate one depending on whether CPU implements
> zimop or not.

If we merge this series without this, then when CFI is enabled in the 
Kconfig, we'll wind up with a non-portable kernel that won't run on older 
hardware.  We go to great lengths to enable kernel binary portability 
across the presence or absence of other RISC-V extensions, and I think 
these CFI extensions should be no different.

So before considering this for merging, I'd like to see at least an 
attempt to implement the dual-vDSO approach (or something equivalent) 
where the same kernel binary with CFI enabled can run on both pre-Zimop 
and post-Zimop hardware, with the existing userspaces that are common 
today.

thanks Deepak,

- Paul

