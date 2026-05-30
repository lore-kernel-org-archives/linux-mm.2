Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED50CCD6E49
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 15:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DDAA6B008A; Sat, 30 May 2026 11:02:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5096B0092; Sat, 30 May 2026 11:02:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA176B0093; Sat, 30 May 2026 11:02:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39C426B008A
	for <linux-mm@kvack.org>; Sat, 30 May 2026 11:02:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85DE31C0603
	for <linux-mm@kvack.org>; Sat, 30 May 2026 15:02:56 +0000 (UTC)
X-FDA: 84824403552.24.32D8AF8
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2BC1E180006
	for <linux-mm@kvack.org>; Sat, 30 May 2026 15:02:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of whitebox@nefkom.net designates 212.18.0.10 as permitted sender) smtp.mailfrom=whitebox@nefkom.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780153374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lwnTSDSSoIV09XfK9ENwJlwD25izPgABDdhBGEWGrKs=;
	b=NmRwpIyJjUZD+uGnhGsUU3F44M0hcPm/FD0Aa0suY5xvuggnxMBHBH3HeKVQhnrEDNw5B1
	Nk7k0U8Lq6VyqONlelMm36Yq4ADgb2tFaV0NT34VQ6yamTYqDsqlXejNOtaMSQFntyrSDO
	SJcT9AXK2PuBAGZyBc0nPtV5ZNzeA+Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of whitebox@nefkom.net designates 212.18.0.10 as permitted sender) smtp.mailfrom=whitebox@nefkom.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780153374; a=rsa-sha256;
	cv=none;
	b=L/K3FMUFiHY48EDnbhGGbHNhJ3aH2CbiMto2m7PxeeBJc80wKNTT9D7rylM310/WGUaY9B
	Ik/EQnONqqZWqpe+4tgpoJp7eQrX71Q1SQtDg9umbu6gJ1WJ+20ALxFbb80FWtOwsIN2ST
	sOg+dgy4OLReAbT/u3n+WDIMsFl1Eeo=
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.10])
	by mail-out.m-online.net (Postfix) with ESMTP id 4gSNkg6Q2tz1sGWy;
	Sat, 30 May 2026 17:02:51 +0200 (CEST)
Received: from frontend03.mail.m-online.net (unknown [192.168.6.182])
	by mail-out.m-online.net (Postfix) with ESMTP id 4gSNkR4FCwz1sGWg;
	Sat, 30 May 2026 17:02:39 +0200 (CEST)
Received: from localhost (dynscan3.mnet-online.de [192.168.6.87])
	by mail.m-online.net (Postfix) with ESMTP id 4gSNkQ6bMnz1qqlT;
	Sat, 30 May 2026 17:02:38 +0200 (CEST)
X-Virus-Scanned: amavis at mnet-online.de
Received: from mail.mnet-online.de ([192.168.6.182])
 by localhost (dynscan3.mail.m-online.net [192.168.6.87]) (amavis, port 10024)
 with ESMTP id WSakR5QS3h7V; Sat, 30 May 2026 17:02:35 +0200 (CEST)
X-Auth-Info: seVX8pClgJ+A7Up8GdLsTTricyC7V41/AnuhQ+0oY9yeyNcy+IKvt/IaX2Iz3oot
Received: from igel.home (aftr-82-135-83-65.dynamic.mnet-online.de [82.135.83.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.mnet-online.de (Postfix) with ESMTPSA;
	Sat, 30 May 2026 17:02:35 +0200 (CEST)
Received: by igel.home (Postfix, from userid 1000)
	id 8848F2C16CE; Sat, 30 May 2026 17:02:35 +0200 (CEST)
From: Andreas Schwab <schwab@linux-m68k.org>
To: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,  Ingo Molnar <mingo@redhat.com>,
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
  Benno Lossin <lossin@kernel.org>,  debug@rivosinc.com,
  linux-kernel@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  linux-mm@kvack.org,  linux-riscv@lists.infradead.org,
  devicetree@vger.kernel.org,  linux-arch@vger.kernel.org,
  linux-doc@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  alistair.francis@wdc.com,  richard.henderson@linaro.org,
  jim.shu@sifive.com,  andybnac@gmail.com,  kito.cheng@sifive.com,
  charlie@rivosinc.com,  atishp@rivosinc.com,  evan@rivosinc.com,
  cleger@rivosinc.com,  alexghiti@rivosinc.com,  samitolvanen@google.com,
  broonie@kernel.org,  rick.p.edgecombe@intel.com,
  rust-for-linux@vger.kernel.org,  Zong Li <zong.li@sifive.com>
Subject: Re: [PATCH v23 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ
 | VM_WRITE
In-Reply-To: <20251112-v5_user_cfi_series-v23-6-b55691eacf4f@rivosinc.com>
	(Deepak Gupta via's message of "Wed, 12 Nov 2025 16:43:04 -0800")
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
	<20251112-v5_user_cfi_series-v23-6-b55691eacf4f@rivosinc.com>
Date: Sat, 30 May 2026 17:02:35 +0200
Message-ID: <87jyslndo4.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2BC1E180006
X-Stat-Signature: 3hhbxzgccs4r71zk7hoh3p8f811zm7t3
X-HE-Tag: 1780153373-784314
X-HE-Meta: U2FsdGVkX1/gjjtiEN8pLwSxbsiTnxA78kC3txuLdsSjuwLkNOj/NQgtqYj3GoupFiC3sYbBOTkdDhgueDCSe9QiPMce7aG7ZAchs0bF2NDMiq3TEgRcAJzSwOhuPyZL+W7/yXCqnhHv8iH4YZqVzmBTilfKr0lQtQ3OLJS5NlOef+GaCJOVqrjuPkftsv2G//Z74C18gqF/ZvQHf7mWf12i8lgCW1qPvFs8YfUqiHkxZDHM74TaTSTKirX8W+hwmo5l0MAbsa1vOpgYwrYIxqTRUYyLHM9h0HKYh7tBeLY07nziTYBnThcIoxwkES3lgJ/zIyzm44GZhgw0T8vWAkfxhmG1Hqxp6LL0B6lCfeoKja4T7BXLUgP8DyZ6jyKLgirCjLlrMwvJd0RW0elyXtOAgAv9KaYbgFwlUV2YXkkr0dpy/ttZk6uHgUZ+iC8Y5W2G5yocB3DwCAKBuWETkaPWaSN8Coh39Q3/kc9mDAK7otxang1s7WyLthqea1E8yPLIKn4WhLodTYo6EF9dl/lpJsVzYAyJtH3eC3ZQTHXZrwriWh3rtR7qRFmApQWKsV0bb2wJTGnvREQMfO4Sek68r/p/YyAsCHQaZ4OXqnSHmRQS/BjM1d34D9J/lJ8QbaakQOlMQ1AGsDZXsTAJ2Am23VVbKV4/pu8g5oKHipjWTwM/AtI2eqUvnHatCHpcpUyHMVfr4MVBU4IMvYcWZlrfaygocA02VHA/PAxcBtrP9wyODkteLTjoAoZCZd/5Aqp3tugtfjyPXCVjlLC61oiJPgf8rhW9oeavg8MlUSe8sEHdO8wNvU4na38PnWTB/whwS+/hxg+VEk+nS7Bas99Ss9eGBmTrFODxTUN1OkaJ5SOVSj9h1Wb64iUbvtOt1fWdmeQ877ma5unpPd47oPHRTuIGA/4SdF11WtwIJZ3PnE3gBp7+DOPZI7wEOoJV2sBood3V9ixEKo9v+5p
 iFnJGdpD
 6wWs8GecLvfwZZXwHRqDWNnXYhFmKiGvrGbGbHdOngeJqDsx73G2lZMv2xJQQLVn/dCAen2UJMdZ9PqKFtANfbaeouV/pwsYToHTdKqr4yZqWjYxqa873Im8JFLEQY+x9PvoaFl9uvXEJxJrSrNQ1min8p7O6q/4SY2d/VJXDT/rSl1xLyJE67NPvxDWMtCR3ypOQecajSRI4Knt2POfwQkGv5j0sUVWQtFtsCXBppC0UeCpBKzyX1RLjA0654rXoOLvFg32z7k5iROo0fKogJfD/dTK5EQcguzwnIbfuQxDLS/Iqs8xgxR+OfnK+rJ5kbuNuQj7NPP/dGUY2mYSczIkXPpSPHQ7/ZJ8Md0uQkir9AfW/403Owr+Abkl+ElVjPkg59xyTK6ou4CKWhI1oImaxUWpD+3G56dKH8kwWZ7GwpIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Nov 12 2025, Deepak Gupta via B4 Relay wrote:

> From: Deepak Gupta <debug@rivosinc.com>
>
> `arch_calc_vm_prot_bits` is implemented on risc-v to return VM_READ |
> VM_WRITE if PROT_WRITE is specified. Similarly `riscv_sys_mmap` is
> updated to convert all incoming PROT_WRITE to (PROT_WRITE | PROT_READ).
> This is to make sure that any existing apps using PROT_WRITE still work.
>
> Earlier `protection_map[VM_WRITE]` used to pick read-write PTE encodings.
> Now `protection_map[VM_WRITE]` will always pick PAGE_SHADOWSTACK PTE
> encodings for shadow stack. Above changes ensure that existing apps
> continue to work because underneath kernel will be picking
> `protection_map[VM_WRITE|VM_READ]` PTE encodings.

This breaks LTP mmap04:

$ ./mmap04
tst_test.c:2042: TINFO: LTP version: 20260529.5ccf816f
tst_test.c:2045: TINFO: Tested kernel: 7.0.10-5-default #1 SMP PREEMPT_DYNAMIC Sat May 23 12:09:09 UTC 2026 (bb95589) riscv64
tst_kconfig.c:90: TINFO: Parsing kernel config '/proc/config.gz'
tst_kconfig.c:753: TINFO: CONFIG_FAULT_INJECTION kernel option detected which might slow the execution
tst_test.c:1870: TINFO: Overall timeout per run is 0h 04m 00s
mmap04.c:66: TPASS: mapping permissions in /proc matched: ---p
mmap04.c:66: TPASS: mapping permissions in /proc matched: ---s
mmap04.c:66: TPASS: mapping permissions in /proc matched: r--p
mmap04.c:66: TPASS: mapping permissions in /proc matched: r--s
mmap04.c:68: TFAIL: mapping permissions in /proc mismatched, expected: -w-p, found: rw-p
mmap04.c:68: TFAIL: mapping permissions in /proc mismatched, expected: -w-s, found: rw-s
mmap04.c:66: TPASS: mapping permissions in /proc matched: rw-p
mmap04.c:66: TPASS: mapping permissions in /proc matched: rw-s
mmap04.c:66: TPASS: mapping permissions in /proc matched: r-xp
mmap04.c:66: TPASS: mapping permissions in /proc matched: r-xs
mmap04.c:68: TFAIL: mapping permissions in /proc mismatched, expected: -wxp, found: rwxp
mmap04.c:68: TFAIL: mapping permissions in /proc mismatched, expected: -wxs, found: rwxs
mmap04.c:66: TPASS: mapping permissions in /proc matched: rwxp
mmap04.c:66: TPASS: mapping permissions in /proc matched: rwxs

Summary:
passed   10
failed   4
broken   0
skipped  0
warnings 0

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."

