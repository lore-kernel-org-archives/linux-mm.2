Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6EA1D4336E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 05:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54DCB6B0005; Fri, 12 Dec 2025 00:53:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FE796B0006; Fri, 12 Dec 2025 00:53:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 415006B0007; Fri, 12 Dec 2025 00:53:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30BC96B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 00:53:26 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8AE4DB9557
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:53:25 +0000 (UTC)
X-FDA: 84209751570.15.460D7CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 039211C000F
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:53:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="AyO/BSfw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765518804; a=rsa-sha256;
	cv=none;
	b=zm0dxSrswewTYx08+qiuQLcgQdUeweDqk+W3FiVzdXkkBbzQWmSuoj/wPMzauSaT81mTr3
	PYPQlHX6I89ht6njiJfEJwjahslpWYanQNs4nsb6ZkaIKOyKftLhlw+wejKk0l4qgQ6619
	T5UEH63E6VqkZ7kJYq5YRwTTlfDk7bw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="AyO/BSfw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765518804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30hPC0hElSFF9/8gZsxu8yAR32063paPvI5Y2VDcdDY=;
	b=VRM8UKdq+mdtOIK96dedHypBowxnm/z5eL5iVwm7BhqwMrzR7xK8yhakw7dX8YIYVuwK0o
	NlLNv+AxijDXdvSb45AnJ4tDeDtacKtjM7A4GhlJhxhKtpyKLxJEOidI5eybu0+DF8Q/pA
	CNh53EKRBzbI8oELGVD8EaXgjuoM1Os=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 85EA040ACD;
	Fri, 12 Dec 2025 05:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C7EC16AAE;
	Fri, 12 Dec 2025 05:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765518802;
	bh=hqZiXxUv6smJHZEauESfPalDA9+KANqTpadXMEusfNw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=AyO/BSfwTPEnPYiKTNe49XE5ReOcZayLHxn1jhIueisyharCn+IGjtVnILr1TyT4G
	 nKspnHRVYrODD0i8/slxWhZO45GVoryW8+V/nxlc/cl74nTuJRbLhh3ggNHZOEBuYb
	 QDmLjiWrVjXjswh87/9uwuRkEI8eFewPySbNTeNTwGLTcMN1WG3UEMMW4dyWT3R8WC
	 usqvWUjSdiWX6RPs7TcBpBmWUvNqIWTkoQltHM7P5Np0sArdIfW5uDHthsrsmogOdO
	 hIkW5ifAR2CVWEU0QaSLWbDYhAy2B4dDGsH3opzA5PTXmucpnskg1uCN7anY9zjNbX
	 o+vLEGqelWAfA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F34E13809A37;
	Fri, 12 Dec 2025 05:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v26 00/28] riscv control-flow integrity for usermode
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <176551861579.2032148.13920544388182691102.git-patchwork-notify@kernel.org>
Date: Fri, 12 Dec 2025 05:50:15 +0000
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
In-Reply-To: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
To: Deepak Gupta <debug@rivosinc.com>
Cc: linux-riscv@lists.infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 akpm@linux-foundation.org, Liam.Howlett@oracle.com, vbabka@suse.cz,
 lorenzo.stoakes@oracle.com, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, conor@kernel.org, robh@kernel.org, krzk+dt@kernel.org,
 arnd@arndb.de, brauner@kernel.org, peterz@infradead.org, oleg@redhat.com,
 ebiederm@xmission.com, kees@kernel.org, corbet@lwn.net, shuah@kernel.org,
 jannh@google.com, conor+dt@kernel.org, ojeda@kernel.org,
 alex.gaynor@gmail.com, boqun.feng@gmail.com, gary@garyguo.net,
 bjorn3_gh@protonmail.com, a.hindborg@kernel.org, aliceryhl@google.com,
 tmgross@umich.edu, lossin@kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com,
 andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com,
 atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com,
 alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org,
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org,
 zong.li@sifive.com, david@redhat.com, andreas.korb@aisec.fraunhofer.de,
 valentin.haudiquet@canonical.com, cmirabil@redhat.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 039211C000F
X-Stat-Signature: tsdcne75db5xajhqzpsskownhhditc4b
X-HE-Tag: 1765518803-366495
X-HE-Meta: U2FsdGVkX1+rL3FSUs/QHWIWM08SQ2MAhWiOBsK5VKSVygRmh/hilOQAxGOL8SqwKQzwRDlaybhsAyEGby/ZeyjkQrAl8PN3fGDP/lKwY5HnDOYUyFd5qa57hc6M1Un+i6fyTBnz3MVKzNF1y9XEDryNjjU88Kl6mCDCbxt3F/E3uoFXjCHRj6UfFKK3orkf0T6prLDgcyhR8UndJPGWRxhFwmlLqaWpC21YN1rLUMmPPG315n+0yfQHqNwbPIqf6ZZA2XYIHgNkl3Xyl41ohOHq1Qq49CNU6QCkrJJjiBW47wTOTro6qDBWQMd1QFJgX4B5kBe+gyqy4Z5J3z3wNg7VKwR88MX1kc6o2MmNNU6OPp/Q3GyIfneP4a/muYSf7DKH95IZH760xVaWn8NYApjIES8LqeEnL7jjcvKX6dzkxYMNiU3TPxbD/yIDTy0Ld+b2Aj5EpkYc7XX6zEcr0ex6ETus7AocfUzmuc0+reMXMuq79+7/nZIQkOqFnr2jKrE6e134yKIPz26teSYChfkzuSoHa9FVGMUEAnpVHIlnSzHzuuk3U/UAVHN0TvvWCIqNboX6TzTTwYNRT2OJzpB7+7zP3DhG1aduqYVAalmtFJxY0aTAiPmWWo4dPDmfkAgGKG5sPjtKeFe+DSlCXdUmq6nsGMzTVIHNz942ZpTe7kWfBrcQ/sBSezmd+Yzpt/a81PRZq56tNj55dU2OKTtO2SFBdVzcRK5mlONPEmT5FZR1mrU71hCWYJkvKY8HPJwZQ30l/dcnIYYOePC80cg04waeDXKoiPHHvT1hJiO+wRZ1k0hizKo9O9GmmZwaUV9GwAhqvssh+Oh1vm6/zhaMiHHC2wWCd4I5oU4uon3gB0MIruj4GjnhVE5f7kpV6lZD0Zkaf9LQji+Bp3glbvdumIl21Z/OuS/2b7x07KxOjMBJUhLtxbW1XVGHOooY2K9/BLj37DNNNAZWwpF
 /45Uq/mp
 yqI3fcAgnPki4uhWqB1Tg7QAuUfZU1sXw6vaK/EdeKTWoD6PYYepufxAqWrlA4+6lMyHKwM8b+rlO4JY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to riscv/linux.git (for-next)
by Paul Walmsley <pjw@kernel.org>:

On Thu, 11 Dec 2025 09:20:33 -0800 you wrote:
> v26: CONFIG_RISCV_USER_CFI depends on CONFIG_MMU (dependency of shadow stack
> on MMU). Used b4 to pick tags, apparantly it messed up some tag picks. Fixing it
> 
> v25: Removal of `riscv_nousercfi` from `cpufeature.c` and instead placing
> it as extern in `usercfi.h` was leading to build error whene cfi config
> is not selected. Placed `riscv_nousercfi` outside cfi config ifdef block
> in `usercfi.h`
> 
> [...]

Here is the summary with links:
  - [v26,01/28] mm: VM_SHADOW_STACK definition for riscv
    https://git.kernel.org/riscv/c/e53803e4a8c5
  - [v26,02/28] dt-bindings: riscv: zicfilp and zicfiss in dt-bindings (extensions.yaml)
    https://git.kernel.org/riscv/c/d6c9672baa77
  - [v26,03/28] riscv: zicfiss / zicfilp enumeration
    (no matching commit)
  - [v26,04/28] riscv: zicfiss / zicfilp extension csr and bit definitions
    (no matching commit)
  - [v26,05/28] riscv: usercfi state for task and save/restore of CSR_SSP on trap entry/exit
    https://git.kernel.org/riscv/c/2acf75f432dc
  - [v26,06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ | VM_WRITE
    https://git.kernel.org/riscv/c/813c549f5b08
  - [v26,07/28] riscv/mm: manufacture shadow stack pte
    https://git.kernel.org/riscv/c/d3cea05f52a7
  - [v26,08/28] riscv/mm: teach pte_mkwrite to manufacture shadow stack PTEs
    https://git.kernel.org/riscv/c/444404ff99bf
  - [v26,09/28] riscv/mm: write protect and shadow stack
    https://git.kernel.org/riscv/c/5da46726825d
  - [v26,10/28] riscv/mm: Implement map_shadow_stack() syscall
    (no matching commit)
  - [v26,11/28] riscv/shstk: If needed allocate a new shadow stack on clone
    (no matching commit)
  - [v26,12/28] riscv: Implements arch agnostic shadow stack prctls
    https://git.kernel.org/riscv/c/46f2da262367
  - [v26,13/28] prctl: arch-agnostic prctl for indirect branch tracking
    https://git.kernel.org/riscv/c/5b23a2d70976
  - [v26,14/28] riscv: Implements arch agnostic indirect branch tracking prctls
    https://git.kernel.org/riscv/c/2b1bd48147c5
  - [v26,15/28] riscv/traps: Introduce software check exception and uprobe handling
    (no matching commit)
  - [v26,16/28] riscv: signal: abstract header saving for setup_sigcontext
    (no matching commit)
  - [v26,17/28] riscv/signal: save and restore of shadow stack for signal
    (no matching commit)
  - [v26,18/28] riscv/kernel: update __show_regs to print shadow stack register
    https://git.kernel.org/riscv/c/35d89b5390a9
  - [v26,19/28] riscv/ptrace: riscv cfi status and state via ptrace and in core files
    (no matching commit)
  - [v26,20/28] riscv/hwprobe: zicfilp / zicfiss enumeration in hwprobe
    (no matching commit)
  - [v26,21/28] riscv: kernel command line option to opt out of user cfi
    (no matching commit)
  - [v26,22/28] riscv: enable kernel access to shadow stack memory via FWFT sbi call
    https://git.kernel.org/riscv/c/ef83c58ab12f
  - [v26,23/28] arch/riscv: compile vdso with landing pad and shadow stack note
    (no matching commit)
  - [v26,24/28] arch/riscv: dual vdso creation logic and select vdso based on hw
    https://git.kernel.org/riscv/c/fbe7823a03f1
  - [v26,25/28] riscv: create a config for shadow stack and landing pad instr support
    (no matching commit)
  - [v26,26/28] riscv: Documentation for landing pad / indirect branch tracking
    (no matching commit)
  - [v26,27/28] riscv: Documentation for shadow stack on riscv
    (no matching commit)
  - [v26,28/28] kselftest/riscv: kselftest for user mode cfi
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



