Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 075E1CD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 21:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF7186B00A9; Sat, 30 May 2026 17:47:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCE9D6B00AA; Sat, 30 May 2026 17:47:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBDD86B00AB; Sat, 30 May 2026 17:47:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB4216B00A9
	for <linux-mm@kvack.org>; Sat, 30 May 2026 17:47:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A05F8DBD6
	for <linux-mm@kvack.org>; Sat, 30 May 2026 21:47:47 +0000 (UTC)
X-FDA: 84825423774.12.EF2799E
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1145B180008
	for <linux-mm@kvack.org>; Sat, 30 May 2026 21:47:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of whitebox@nefkom.net designates 212.18.0.9 as permitted sender) smtp.mailfrom=whitebox@nefkom.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780177665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=govl2alLRoEPgl2CneXa/se9i3UKC79Bp0SQ7TNnIO8=;
	b=F8QOqAw8/M9PhpLaQld008/2wQ3038XvcoPl9qVK52cql4WvqBfmSWAtg0lbEvhgNCHMO+
	MfU1aIKZVxZ0hLUzBXWo4W1bkySyuuXZXxEmNzJwYJiC3XsJ9N1Wtjl0zdhc/ykCX7Seln
	rpQFLYDBrxb/oX3C7jkMgOH3vebsoDc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of whitebox@nefkom.net designates 212.18.0.9 as permitted sender) smtp.mailfrom=whitebox@nefkom.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780177665; a=rsa-sha256;
	cv=none;
	b=1A0J+Rc2rTGdXIA/OEsSzPsnSGqEfgmf95KVuOLKOCMY8pHCo+Tkph3cb9GCR9Kr6nzVlM
	b5O2W59Mo9jSpLaXBT5HN+asAMRV6BSYUrlR6CcptfuMrvKxByw1K2KlQqDfwVs5S6Hc70
	bl1sKOmQPjtgZRoahpK2jOko2BEK3wg=
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
	by mail-out.m-online.net (Postfix) with ESMTP id 4gSYjq1B98z1r5Sd;
	Sat, 30 May 2026 23:47:43 +0200 (CEST)
Received: from frontend03.mail.m-online.net (unknown [192.168.6.182])
	by mail-out.m-online.net (Postfix) with ESMTP id 4gSYjk4hQGz1r5ST;
	Sat, 30 May 2026 23:47:38 +0200 (CEST)
Received: from localhost (dynscan3.mnet-online.de [192.168.6.87])
	by mail.m-online.net (Postfix) with ESMTP id 4gSYjk0Sg2z1qqlT;
	Sat, 30 May 2026 23:47:38 +0200 (CEST)
X-Virus-Scanned: amavis at mnet-online.de
Received: from mail.mnet-online.de ([192.168.6.182])
 by localhost (dynscan3.mail.m-online.net [192.168.6.87]) (amavis, port 10024)
 with ESMTP id S_RzmYjTOuSj; Sat, 30 May 2026 23:47:36 +0200 (CEST)
X-Auth-Info: VhoZGXqafEl8xd2Vn3898hxCrPZhtM4EMxNmVIF69poad4TwEdSE9C4PLgF6bHrY
Received: from igel.home (aftr-82-135-83-65.dynamic.mnet-online.de [82.135.83.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.mnet-online.de (Postfix) with ESMTPSA;
	Sat, 30 May 2026 23:47:36 +0200 (CEST)
Received: by igel.home (Postfix, from userid 1000)
	id 42A002C16CE; Sat, 30 May 2026 23:47:36 +0200 (CEST)
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
In-Reply-To: <CAKC1njS=AHu6uHrH4ae8VxcdEbhgiPXYCAoN3F_mnppBd3SwOA@mail.gmail.com>
	(Deepak Gupta's message of "Sat, 30 May 2026 12:40:33 -0700")
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
	<20251112-v5_user_cfi_series-v23-6-b55691eacf4f@rivosinc.com>
	<87jyslndo4.fsf@igel.home>
	<CAKC1njS=AHu6uHrH4ae8VxcdEbhgiPXYCAoN3F_mnppBd3SwOA@mail.gmail.com>
Date: Sat, 30 May 2026 23:47:36 +0200
Message-ID: <875x44o9hj.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 49jf7njbheut4xsfapo1bgap87spnk1o
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1145B180008
X-Rspam-User: 
X-HE-Tag: 1780177664-833639
X-HE-Meta: U2FsdGVkX19l3N4dg5VlxR8tibOYNAkDssKZg6ex1KI4bLSKsZTpMarvs+WgcTAdO96StxaH0VIewaeLlLtVHy7EqVwhAJ3AoYrs9UFOaibDEj4waNn7CMKGI5VXSrEsn4KqXAfZZOxMTEqhdKsrWFbEpGylq+GHP0F3Qh9yOHmHQTdbIdgNKcyF3KoC5BZbSKKLgvVqtIm1YT8L81dC/S6r34LUHnEOfGpN4J9xuvQB6j7HxUkOW/+8xv8UTvYrTGxY28fHgUy9982TCK/3p7np0mutOcNkpSAlZFVaGSFx326cLdzUk/sY0PU/osp+Ta0jKcr18nyatIoiH6BcVU/0jN6c0y56hqXbj2mm9amGK+pIeSVGlYRYwl0w9HI89Y4rLjB72IbtvZULZQxp7UCvtRBO+d2eiOKDIzmk4nFDheEUZRZA4oduoKbYolyh50SEOJl7y+CnODPXGLlKUM7dtuIYNSaLbN/Pv7SxhwCcdN0hCjv6KEJy83w2QkY2OMm7wDrNM3WXMvTFtenhNiQ+2v0rPl8gaC15un0u8An/emGBOja0ROVWNVIJfib4BqDCBkGgqtx4HAImPsZEqCyye3sUoRZUsK5kpohTTiYbgqNq7EDSbyBcFYuqccjd9jVjiWDt5Frr1meXFVsNPXhOVlthOI36OhP6ol1U5NEbMdbLDJZhCvqRKMKgixHcV0WPGur0NTmxV9Bw6blurIwwVOs/JxjmKXdeMqNDeiqg5LNLRLtMCU8M+vYiJhHI/D6bg94S3bhKQEKMtA+2SfEGwEdPQTbj2VfO8ej0pKoNggr74F6zvm+BXSWW7XxbwdZIiMipTBI5gQpMNXg+HrReWBvTWuZbo+pUSc9+WQFujEsI0saBMd7j1WYLjJLgQKJ3kD29lU6kNvPvYt/hZi0GMmDK6gZ8e7/xs6vYhqO4e7w/x7XCJw1LvEroUG23k7gTFHy3mtVlWFymeur
 xmIV7pxR
 mOQaw12oUHgWDxgRfyZ3naKdb1Qd0nQkNt7LXuLB0BSVWBWpTy3aBTDAQj5MNaZp2OQWmUnUwiTc2wyYioNRrOQhJpRfwE6DcPEO81n0fy1bHlnfAqUOj0qEIUVKNPF5aiSO+XT5gnwDhYbSGu1qWvAO0I/m30Aqr/joYWn1Uh1M0w1Bt1k3wFUvnuXbZqGkn1U8vdsk0xDS6QXM7/fpGXtgWAQpz53pHEiZRsHJxkCEtMKPCwDQm5FV7YHfQsL6V6Lu2GZ4Q4ANoOp8VnwoGn+Ef0XkT4XMzRRVKBxP2SYHyqOWcfOTju8n3YxsWcaNDe+XjXV72rb0PRIxJD1s6D8E6zpk5CNfYJbm4Pmv4F5t353UwrYy4T8duQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mai 30 2026, Deepak Gupta wrote:

> I see two ways forward:
>
> - It can be done in generic way where incoming PROT_WRITE means
>   PROT_READ | PROT_WRITE irrespective of RISC-V. Although others
>   (x86, arm, etc) would have to weigh in.
>
> OR
>
> - mmap04 LTP test can be updated to expect either of "rw-p" or "-w-p"
>   whenever only PROT_WRITE was specified.

OR

- Add a new PROT_ flag.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."

