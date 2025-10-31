Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4595FCCFA02
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 20:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 603F78E009A; Fri, 31 Oct 2025 16:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B48E8E0068; Fri, 31 Oct 2025 16:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47BB18E009A; Fri, 31 Oct 2025 16:07:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 316018E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 16:07:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A41A0C062B
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 20:07:41 +0000 (UTC)
X-FDA: 84059494722.22.DEFAE60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 113288000E
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 20:07:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eEbaFUeP;
	spf=pass (imf30.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761941260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBCY1kTc2p+huwnbZSMFMRD57uR16hOAJcemNSqmBg4=;
	b=0X4En7w9qyy5LO8ODCk6ei3igY2NOrchtydW1z11MdoUQ/UgKzVYBsYXOhxkiKe38PqbIl
	5xLjH3rIh1Qbu3VLxXwxAfS9lh57UtwAe2Uwb/YcwxA4/dyDUKfdw1Jlao8zr61M+LxeCY
	GToVio1XUUJJHpkyi4KIgdTAMqfOr4g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761941260; a=rsa-sha256;
	cv=none;
	b=HTDtHqzUTQP2uS+Ut3vwDGWavkxKvUGKCfb2xcqhU0Rs6o+KmiEJWgdBieFUDVAePOt5tm
	/dYjBfNgGtvCWtccvVkgkfTY/5ZSvfsVDI4d/hKYf0O/XrciAcnOvEnz/n3v6+pucvDc/W
	3+rbCZXuAOmZONJS00BWOsCGOhJP2dE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eEbaFUeP;
	spf=pass (imf30.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1627060235;
	Fri, 31 Oct 2025 20:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC5FC4CEE7;
	Fri, 31 Oct 2025 20:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761941258;
	bh=wQet1zpVA979LHOCAKnvDe4vIz5lgogB/RiA4rvDzcE=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=eEbaFUePEqsqd1xqvFj6PfHBe6jOCi2lEMdH8TycHl0Q5Auluk8S2lpJXmv9TxFx6
	 NusxPnTpJc0X0f0CeYGgWHWJPP+pm9H5h9r65gPGw/KCR077Hi6MKNwd20DNPMNN6b
	 WeahrAxPZQa10FjP/DdR4c+HK/1h5x2nUAasMuSHcOITJAiV483CzwcXL5NGIqys+P
	 mY145nVNkpzIC2zpwBWy190cfG4RZuldrQmgNpuR1kKC8i8XpoLRbm6nuQrl1TbMCc
	 xrhLxkelxND1eIrhNaB+SV+lyaoUFqxJyBOJ8iEADXR4rSsgSzl+qs3Ga+6/bKM9QS
	 dwrww+Tnxquiw==
Date: Fri, 31 Oct 2025 14:07:32 -0600 (MDT)
From: Paul Walmsley <pjw@kernel.org>
To: Deepak Gupta <debug@rivosinc.com>, Andy Chiu <andybnac@gmail.com>
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
    rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v22 17/28] riscv/signal: save and restore of shadow stack
 for signal
In-Reply-To: <20251023-v5_user_cfi_series-v22-17-1935270f7636@rivosinc.com>
Message-ID: <a8f469b8-5750-dfec-2390-09bad4515f99@kernel.org>
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com> <20251023-v5_user_cfi_series-v22-17-1935270f7636@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Stat-Signature: tg73okybw1ikqaspigqcei433uohmd6a
X-Rspam-User: 
X-Rspamd-Queue-Id: 113288000E
X-HE-Tag: 1761941259-109903
X-HE-Meta: U2FsdGVkX18fULkTpo0yNwlKu4G3WrCMzYQOLmb9utZoGm3zyL/lli8oem1/gpsr76lCua8BlMQsC80jHiCN8iWvK5MVtdN6opOcnZXl4oRFoRIoe5gVoo9UMb4BKzswEwQvzmWL9W4EF+qPL1FdnfYkZO0Kkl/CVenw6UVCcdMZMOnJU1YetkfDiDFy9d312/iIF9W/jvjAhlOgeHTGEj31Yr307VaL1bJ9wS9VTdKlGTpnRMW9M1odAH7P+y45USsIJjHeElQnkHCNaewKIc4Bcw/6DXKDQMdlG5BICtVUePoLWcEewSyObpEAMSFDu+A/8UiNA7i8Y6M7nllqWm6nLAfF8sGPpaCBhPPzM8YKPw2yXUEo/ibYLPyVHGP9AaltuRzpBF3afar9X0soItMa0ynxDk7VMdQF8p6H6RXKAood2O4q/sIOqeqg3fNl4CIQkqljvA2UqDHGqpynDkKlTE8X7jL1h3E04qGbvdOXsZBqmkteudty2T3PoUyLAih9QcwoG3drBEzLbRExGHNeJbELHhPF1VDTsWru4GyUZJEhy8HLQaAZQGucJc4dvYf2xlJb6uySrpBI2ThsU7jsRM19mBk859HyHsxW1S5i8ffHiTAraZCf9dAbw+1JGG1Tm+t262yfNnkPs7WZdug0PG1qFmKgx2KWjwo4MAQKrpOCnTlaOClWrhPsqDmkU8LhtnVvVKCdCJYB3CJ5Ylz96e5f0lHNmI2B2ZBPc9L1XfXg5ls1snN/qKdBMAqQd3EdfurOvtlsUtCYv1G/SrcO0eeFTlN4s/XAokUq53hK1jSTQT2jMTxFDdOkiB+pc/N/BtESUUZG2ycdgXLbJCXU1wMaejlpcqL3MwcuZ4te1JspPViKyO6iK7wmPKXOdzy5hpgg5ySroNynFYswe2y3U2AFw/XJriV083suD8krAZguPSlkeKueG1mfjUWNR52tUB6AeiRLeqBpIk+
 HYscmnnf
 BvQlVZmnAk6X4J/3cw4hAV+DgwWtdJn4peWeRGF3l57oMNO9yEImSTYglFb48h0EO4/pdI4D8hbC/g2tSqEPYHx9cMoLQAjD0tb76NNJ+O4RcFJcsJettAQmIYIiemS5BeBb3hzKJZ2zseAtzmM3PGV98Sv1p1b0jJ6SUVA4zX8mYGt5uvou6GZfynIKxzs25sT9Dm9WOIifmzXVwf2bnyJ4gzEEUmv2voBurUn3zyB3Tj5vp5TbJKCM1Ymc/cBm2+TP7Or7xmKLsPzlihoRsLWP0EmBJrPNS+3/TeceF/QjQojbEfVSj8NfcrHcDQ2t3dwgrP1ZkeJPFbOxkXYaguB62AGGJ2WKk5aWzDHw8UKiYgefGP7pVXWftXmTuwqfWYYRyF580F6k8r2Ok/4Vw5Dwl/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Oct 2025, Deepak Gupta via B4 Relay wrote:

> From: Deepak Gupta <debug@rivosinc.com>
> 
> Save shadow stack pointer in sigcontext structure while delivering signal.
> Restore shadow stack pointer from sigcontext on sigreturn.
> 
> As part of save operation, kernel uses `ssamoswap` to save snapshot of
> current shadow stack on shadow stack itself (can be called as a save
> token). During restore on sigreturn, kernel retrieves token from top of
> shadow stack and validates it. This allows that user mode can't arbitrary
> pivot to any shadow stack address without having a token and thus provide
> strong security assurance between signaly delivery and sigreturn window.
> 
> Use ABI compatible way of saving/restoring shadow stack pointer into
> signal stack. This follows what Vector extension, where extra registers
> are placed in a form of extension header + extension body in the stack.
> The extension header indicates the size of the extra architectural
> states plus the size of header itself, and a magic identifier of the
> extension. Then, the extensions body contains the new architectural
> states in the form defined by uapi.
> 
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Signed-off-by: Deepak Gupta <debug@rivosinc.com>

This patch causes some 'checkpatch.pl --strict' messages:

CHECK: Comparison to NULL could be written "!saved_shstk_ptr"
#271: FILE: arch/riscv/kernel/usercfi.c:186:
+	if (saved_shstk_ptr == NULL)

CHECK: Lines should not end with a '('
#300: FILE: arch/riscv/kernel/usercfi.c:215:
+		pr_info_ratelimited(

I've fixed them up here in the event that v22 goes in, but please do the 
same on your side in case a new version is needed.


- Paul

