Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEDA4CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 20:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01C526B04C8; Mon,  1 Jun 2026 16:59:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0F6F6B04C9; Mon,  1 Jun 2026 16:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24F06B04CA; Mon,  1 Jun 2026 16:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3A576B04C8
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:59:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 686F9162972
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:59:09 +0000 (UTC)
X-FDA: 84832558818.06.CD59F59
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1671B40013
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:59:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of whitebox@nefkom.net designates 212.18.0.9 as permitted sender) smtp.mailfrom=whitebox@nefkom.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780347547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lf8royKGKY/88tWjnvDeTQ3D1s3N+bR+jt5KeXdcXGU=;
	b=zUvGyR2hqze8JT/YPOTVd7Bjs8canIndcurZ9SIXdszwb03Qat+ozu4YcnLfCjN+bmyBzN
	Kl2jb2PHXdtpPb+EUYFnqrTdWNGmb9m3eLvoWWMxwEAkAGMg0KR3TNvkJvq0UZwJ3tZ7f+
	rBzakrLqh/eB5hevf1QnRA1sWhAu0w4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of whitebox@nefkom.net designates 212.18.0.9 as permitted sender) smtp.mailfrom=whitebox@nefkom.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780347547;
	b=JPLIZSB+ICzgaBZWLvY9XSYt5KOLbIIUpJ0Hi5UoajibqKWrFmSrXe1Vljseb2Enjb5Leq
	DJVp1VLfMH5MPWdKTPSoC1JBgzeEEfnPShpULyV8/7Ev0c+rhLjpHvZ6ehDTjtcZtjwpls
	4wdRiottqc5jGyyqWMaiHNl6zLW9RX0=
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
	by mail-out.m-online.net (Postfix) with ESMTP id 4gTmXn29XPz1r5Sh;
	Mon,  1 Jun 2026 22:59:05 +0200 (CEST)
Received: from frontend03.mail.m-online.net (unknown [192.168.6.182])
	by mail-out.m-online.net (Postfix) with ESMTP id 4gTmXb1NBBz1r5Sf;
	Mon,  1 Jun 2026 22:58:55 +0200 (CEST)
Received: from localhost (dynscan3.mnet-online.de [192.168.6.87])
	by mail.m-online.net (Postfix) with ESMTP id 4gTmXZ2s9rz1qqlS;
	Mon,  1 Jun 2026 22:58:54 +0200 (CEST)
X-Virus-Scanned: amavis at mnet-online.de
Received: from mail.mnet-online.de ([192.168.6.182])
 by localhost (dynscan3.mail.m-online.net [192.168.6.87]) (amavis, port 10024)
 with ESMTP id StDKLQCMjWpS; Mon,  1 Jun 2026 22:58:52 +0200 (CEST)
X-Auth-Info: FqnxIDPc+CejjKHAe9u56JUkf8btEszKYhyFrkdtC5LkcdNUzyTOWALY7FYpYrLU
Received: from igel.home (aftr-82-135-83-133.dynamic.mnet-online.de [82.135.83.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.mnet-online.de (Postfix) with ESMTPSA;
	Mon,  1 Jun 2026 22:58:52 +0200 (CEST)
Received: by igel.home (Postfix, from userid 1000)
	id 6F0742C16DB; Mon,  1 Jun 2026 22:58:52 +0200 (CEST)
From: Andreas Schwab <schwab@linux-m68k.org>
To: Deepak Gupta <debug@rivosinc.com>
Cc: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>,
  Thomas Gleixner <tglx@linutronix.de>,  Ingo Molnar <mingo@redhat.com>,
  Borislav Petkov <bp@alien8.de>,  Dave Hansen
 <dave.hansen@linux.intel.com>,  x86@kernel.org,  "H. Peter Anvin"
 <hpa@zytor.com>,  Andrew Morton <akpm@linux-foundation.org>,  "Liam R.
 Howlett" <Liam.Howlett@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>,
  Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,  Paul Walmsley
 <paul.walmsley@sifive.com>,  Palmer Dabbelt <palmer@dabbelt.com>,  Albert
 Ou <aou@eecs.berkeley.edu>,  Conor Dooley <conor@kernel.org>,  Rob Herring
 <robh@kernel.org>,  Krzysztof Kozlowski <krzk+dt@kernel.org>,  Arnd
 Bergmann <arnd@arndb.de>,  Christian Brauner <brauner@kernel.org>,  Peter
 Zijlstra <peterz@infradead.org>,  Oleg Nesterov <oleg@redhat.com>,  Eric
 Biederman <ebiederm@xmission.com>,  Kees Cook <kees@kernel.org>,  Jonathan
 Corbet <corbet@lwn.net>,  Shuah Khan <shuah@kernel.org>,  Jann Horn
 <jannh@google.com>,  Conor Dooley <conor+dt@kernel.org>,  Miguel Ojeda
 <ojeda@kernel.org>,  Alex Gaynor <alex.gaynor@gmail.com>,  Boqun Feng
 <boqun.feng@gmail.com>,  Gary Guo <gary@garyguo.net>,  =?utf-8?Q?Bj=C3=B6?=
 =?utf-8?Q?rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,  Andreas Hindborg <a.hindborg@kernel.org>,
  Alice Ryhl <aliceryhl@google.com>,  Trevor Gross <tmgross@umich.edu>,
  Benno Lossin <lossin@kernel.org>,  linux-kernel@vger.kernel.org,
  linux-fsdevel@vger.kernel.org,  linux-mm@kvack.org,
  linux-riscv@lists.infradead.org,  devicetree@vger.kernel.org,
  linux-arch@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  alistair.francis@wdc.com,
  richard.henderson@linaro.org,  jim.shu@sifive.com,  andybnac@gmail.com,
  kito.cheng@sifive.com,  charlie@rivosinc.com,  atishp@rivosinc.com,
  evan@rivosinc.com,  cleger@rivosinc.com,  alexghiti@rivosinc.com,
  samitolvanen@google.com,  broonie@kernel.org,
  rick.p.edgecombe@intel.com,  rust-for-linux@vger.kernel.org,  Zong Li
 <zong.li@sifive.com>
Subject: Re: [PATCH v23 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ
 | VM_WRITE
In-Reply-To: <CAKC1njR+dTdvp+BmLGPtgd8dufiUwBtkQ9a-qinELT_Fmi13sQ@mail.gmail.com>
	(Deepak Gupta's message of "Mon, 1 Jun 2026 10:57:41 -0700")
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
	<20251112-v5_user_cfi_series-v23-6-b55691eacf4f@rivosinc.com>
	<87jyslndo4.fsf@igel.home>
	<CAKC1njS=AHu6uHrH4ae8VxcdEbhgiPXYCAoN3F_mnppBd3SwOA@mail.gmail.com>
	<875x44o9hj.fsf@igel.home>
	<CAKC1njSn_rtCj8ii876PNQTk0nsCTfWsb4DzdymufHVthh1Rkg@mail.gmail.com>
	<871peqgp9v.fsf@igel.home>
	<CAKC1njR+dTdvp+BmLGPtgd8dufiUwBtkQ9a-qinELT_Fmi13sQ@mail.gmail.com>
Date: Mon, 01 Jun 2026 22:58:52 +0200
Message-ID: <87wlwif04z.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1671B40013
X-Stat-Signature: apr8j7fw5a7neyrcxojmm9iwoawyc1i4
X-Rspam-User: 
X-HE-Tag: 1780347546-58127
X-HE-Meta: U2FsdGVkX19JkfPvw3srq+ZvY8kqt6P9HfaQ3y4OuCiZJVLwYlsr/Zo5dD472hJpAEoqxSDYOiEcILhFJxZXYyYjUMlG+mOFGCNHowEyTsX5QlHOaPhEO1YpK1I/Zc6HPQHA07fK+GiL4WnKi6rvtPzsJU98FcEjbAvutG39EexPEcQxhiZMyEBUS5MhlCFmggnKI1cEQ3bexGrJ17hYV1ud6PU5UrEn69RI/xOTr3+kB97bIIqyCg+sNePBE7jatBvAKfCmRtjHMeYCf4ff7iBEr13wqJ/yOuLDt33zDLL0NkuuSqQWrDLAbOiQ7nhUbYs3wb4mUgAOu0pO9fUDxWCH8uiew4sarTpDmjV5t/KUfbETpV9NJfn3+qDKRVEEm0JVdFMNjTOBJXKVXAb1owiIozGe2Qzc8txxWR6/m42fuPfyEr8TTJ5COQGyt91x7sjnbWcdJgldwVsE/nHSoG3Zgi8Hc3rTrYJ1aMF/OBzXtoF+zfX42qpPaJw8ifyLl3zq3UG6yWc+VU49NL1QVmFPSVJSg41SIncFJde592isxtT6pNAzBnNNqlngHA8IOVmcjNF5AHKcJIEwLDLtpsWrMCi9YleLszMfWK5er8F7rY5k0f7ADBsD0ir/tYhungyKiqQxArbW5Ml1TGEdwhBpN7o+6kdFkJoqeN1r/lbgvkyZ6oA5g2Zl6D9+PslhGZcRvrhJdyohqa9CYkKNmhnHKfKJSnBcre8mljMu48cwt/xJ1KeXvmkqy8c65gWDZzxFK8PYjcs3d0/yfOY9OhnBE2OUBMD0uEpH7N7RlPd907HJEqKi5sDRlVi6ePjFQ03I9kQJN3fFGMxGqFxfiA+ob7sTPIZI3tpZXyxtwra7Ydcg8EtUCQdZ6gxqJDW4JvaXYi2/LVgF45bxbaX0ZtI/7hBdv5zf5XZevprTEcdsTBePRVtYmGkrTyFGaCAgPujl0mH0mSzvwdnKApf
 gWxaLbxw
 5BfjLYQJvvUatj9JKY3LejOvTB/y7K+HFml3lzh/YkuUoD9+IkzjbWuPpHcOzvsNeYEFwYeMq5iv4l/nGyplqnCCiIKRpdk6/2L9zlukiyeW78LJPvCKqpQKbHZXf6vN+xq7nlbHFc23hcTXtcGr46yjnaQ6UuO50p5ZSwTgnivYf4R8HK722kQw4cqQfcxPpxsW1hJ93s3do+hYmXgjNLooT7Xdf9TSukHJ/cCh4N+GsqB2XogfOBDc81AW2NKXqYwSm3/YFKBERzMVF9x1V+dxBt7GH1Kw0kzo4R7uaRgnApkpwXH46jLXmApyptMysLjZuoINxmFtz5eHZrfuoVdX9mFLNmjQBoYgPOKga6GXJ3d97jUIqmOpC7bOtfkZwvMzyq0UKuB4yZyKVTZ7qu9/KlChkGmRbv3FNRe3Rmj6E2v5wPrr/vtFh/yfFObyUM7lm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Jun 01 2026, Deepak Gupta wrote:

> riscv uses `VM_SHADOW_STACK`. It's just very simple to use `protection_map`
> with just `VM_WRITE`. On RISC-V, `-W-` is a shadow stack mapping. It's not same
> on x86 or arm64. So `protection_map[VM_WRITE]` simply picks shadow stack
> encoding. We just ensure that PROT_WRITE is converted to
> "VM_READ | VM_WRITE" at vma level.

That does not explain _why_ you need to make that user visible change,
when others can get away without it.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."

