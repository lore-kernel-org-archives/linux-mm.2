Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37A34D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 08:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5760C6B0011; Thu, 27 Nov 2025 03:31:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54DBD6B0012; Thu, 27 Nov 2025 03:31:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48A6A6B0022; Thu, 27 Nov 2025 03:31:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 35E7E6B0011
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 03:31:04 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D840A1609E6
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 08:31:03 +0000 (UTC)
X-FDA: 84155716806.09.BE6303E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3A49D18000B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 08:31:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hy3wn4pI;
	spf=pass (imf16.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764232262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTLRZz4KtHST3+qtwY0peYd8mxioXsWdJcqMaUk9YhE=;
	b=nCjje9enBbO2ZZTr9l1dbHWo+xMzciWWmkPrAEfRUvJ4Ym0shA7IpGP97MBSOCJqNzttQn
	OXAudNAN260lSpOgQnx1HxeBgMIgseFuKaW0l9zVJatRnoQ4mOQHN5Ki+g+vhlOAcA6Nww
	kB2oVrPdHk525kxoNz03iI8MCNsTTxs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hy3wn4pI;
	spf=pass (imf16.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764232262; a=rsa-sha256;
	cv=none;
	b=Nt0C85K3Qw3nizDp5XkjxS1KMdAzptRVIPt10TvupRLZRQ+ldtU4PSJoGvWDnCjHmLz/97
	H0fofDE275gboAJZEcpvfPEnVT1L7sPX1J6hKYCYLe8v+VA711f14zsey1rfzT3w8bLHxI
	56VOWw9o2LNe2j7j/jyOReqH9kG8rG4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 567F460178;
	Thu, 27 Nov 2025 08:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21C9C4CEF8;
	Thu, 27 Nov 2025 08:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764232261;
	bh=Hw3rpyjIs5q2m80mOXGPqWY/yNyazFCdz/ULb4y5eE8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=hy3wn4pIoJRjHnOpzYoslQqGho8xq0Z9RYYtBYN7+2U4rmY+LWmfVf7QjhnFLU0Mv
	 QEDP6WThf6o5Q53L7jnlkEhpeYY48FZgFAt4ZuoKkLd8wdchRSGHF/bEWGOnGHYBBT
	 FZ8xnt7DwDjwc8HuYv/UEioqMANa99L8z5klJ7kXO7QR9T1fKlc6GLVl08SqYFo5Lg
	 RaTsa2Z8ARaoDxgBAXOvRTYOfrpd22vE5+10ciSjeYr16NsDt0ap+IHbaB2YhBdfA5
	 1+WTRwoaMqCQwXUJPSdoVgujZPRxtohgp1aIb2iJZsXu+3yC16Y7s79nq8I1k8N+Fe
	 fXBu/eflyUvhQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADE9D380CFC2;
	Thu, 27 Nov 2025 08:30:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v23 00/28] riscv control-flow integrity for usermode
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <176423222224.2476283.17736612090314280039.git-patchwork-notify@kernel.org>
Date: Thu, 27 Nov 2025 08:30:22 +0000
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
In-Reply-To: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
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
 zong.li@sifive.com, david@redhat.com, cmirabil@redhat.com
X-Stat-Signature: u5jr8hbqzw3sbh7n61gf9weyi1o94ihj
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A49D18000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1764232262-267486
X-HE-Meta: U2FsdGVkX19zJzMcyitgEsIytMV93wwJyLO+/fA7KsUUMW/sOqt2yoJedJL7myx86oGesdo0qlOQFG7qGEgxxV3gI3JahBiqXF3ho8q/uJemmM20vsOxoIk05zCERgAMt6lriLaH5vTqy49RsILZDUBTwQ+W/209udc7f92tkd1/svIXPvWRlyAppjIDFYff9Y5SSJicQjYbrFd3tOKo0jXrhlRGBPR/Qijyej5iAJbtTzCA9tOjcO/kCUyqCYOGsUysRnDoA/a6DjWiC9IAwa1xf0Hy06QaqN59+3lm+rFY8zXGhrdnyxGV3DS98b828tbusB1Bgv7640R8/sGsfXAAgrwSLyIrIyeyF6GZAZkXg3qCOmOnT7UVqg7CNg9h5aJVIalnBYTWNnIRM9a6ivyXPiKrZmT4fwV7HeiXp9/pWlwFXfKTjGyB/T4d7+L40f9xjEvCCP3aazAyMvctQaJggyxeIK584+kLO5Rp5XKuWRWKz2G5QHGIzNxTTPpn2V3njCX+lIDD2a5fKH95o18PoLMsduXdmqsJM5Q+PkR5iPTDiD1cpTrq66hypndWr0Jg8ZsQU/AOOFZrgIq2exMvnb4HcDe66jOtv0Mr6x2UTH095AkjSWl+NCY63XcEQhDnj9UPU7aVEgixhICwKBFXNYd0HAYDXEqUvqVzCVwQDKVKEomkYSsvD3bu+hpMW1FNPzwEIPjvrCtCu29EINMu2ID6ho303nZRDxWYiweXZfM1dS+hNbRj2U/qX1GzROzIGhm5JOsEHMZfyozgbG/8D59ETHLiizK/tW81cGHn9bReL9bQGgJo53Yi0++fbdLgq7N3ZMwcS0jbEwtKCBY2xF6W/Nst4jvALbYpnBFWZ+xgTzCHXoOeXwB5qgfow0FR/Y8i62AuG/9ZZWD83VrLlkBXf94jGWmm1/J86+kCbIDzaI+GSsY8dtl0pSnBNepWn/tZPkqRFlFmYxy
 eAfFgxLH
 kJHo4mBuChw3TTjBm6YpLNQD4+AIud9+E5IUM7EnrYGuCl2B4rAXmGiVGKRci+yuo90OPl9qzYyBLblTSbJoky0mhDo7y5WJcqzbhxEDNmgA/9jRFeeeQvYuU9XXTneoee3WfcYvHsdB5crlWHoDrSXmGDi7bSKHN11GT1vyXgYdz0gCdA14GwjnXvmtoWQAFLTZRfN5hIB76nLiJXSXmAORzRA2HPg1MikPgjww7FfjAw+e1ONZJhtuLALQfdYBwUi4HvYK+n1MWjkQaONFkYCOJkeAbXl/CYI36TXPm0pCu9OtZRncFQuqiJTgXDQ1EwAxeySYrOX0OuShrHR5QatYPFSwLBL6bUDAgybwjofZ+sGPxmQJh0RD4FM0XY16JgQIQBy18qzGsgOF2zNO5LQ/Uet/zEviuEmLIpZhrbRXlh587VGNo04LppQpLIvFy1/ci
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

On Wed, 12 Nov 2025 16:42:58 -0800 you wrote:
> v23:
> fixed some of the "CHECK:" reported on checkpatch --strict.
> Accepted Joel's suggestion for kselftest's Makefile.
> CONFIG_RISCV_USER_CFI is enabled when zicfiss, zicfilp and fcf-protection
> are all present in toolchain
> 
> v22: fixing build error due to -march=zicfiss being picked in gcc-13 and above
> but not actually doing any codegen or recognizing instruction for zicfiss.
> Change in v22 makes dependence on `-fcf-protection=full` compiler flag to
> ensure that toolchain has support and then only CONFIG_RISCV_USER_CFI will be
> visible in menuconfig.
> 
> [...]

Here is the summary with links:
  - [v23,01/28] mm: VM_SHADOW_STACK definition for riscv
    https://git.kernel.org/riscv/c/ae8460ac9db2
  - [v23,02/28] dt-bindings: riscv: zicfilp and zicfiss in dt-bindings (extensions.yaml)
    https://git.kernel.org/riscv/c/b32ccfc268db
  - [v23,03/28] riscv: zicfiss / zicfilp enumeration
    https://git.kernel.org/riscv/c/55a811a7f304
  - [v23,04/28] riscv: zicfiss / zicfilp extension csr and bit definitions
    https://git.kernel.org/riscv/c/92c96b16548e
  - [v23,05/28] riscv: usercfi state for task and save/restore of CSR_SSP on trap entry/exit
    https://git.kernel.org/riscv/c/7720cdd21962
  - [v23,06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ | VM_WRITE
    https://git.kernel.org/riscv/c/e60eb198b13d
  - [v23,07/28] riscv/mm: manufacture shadow stack pte
    https://git.kernel.org/riscv/c/f8fcb7b5bf30
  - [v23,08/28] riscv/mm: teach pte_mkwrite to manufacture shadow stack PTEs
    https://git.kernel.org/riscv/c/0276a5ea1105
  - [v23,09/28] riscv/mm: write protect and shadow stack
    https://git.kernel.org/riscv/c/ae615676bc37
  - [v23,10/28] riscv/mm: Implement map_shadow_stack() syscall
    https://git.kernel.org/riscv/c/d291fd38f841
  - [v23,11/28] riscv/shstk: If needed allocate a new shadow stack on clone
    https://git.kernel.org/riscv/c/d209ea2fa4bb
  - [v23,12/28] riscv: Implements arch agnostic shadow stack prctls
    https://git.kernel.org/riscv/c/8b49f512abc2
  - [v23,13/28] prctl: arch-agnostic prctl for indirect branch tracking
    https://git.kernel.org/riscv/c/3363a8d1044e
  - [v23,14/28] riscv: Implements arch agnostic indirect branch tracking prctls
    https://git.kernel.org/riscv/c/0177891ccdb7
  - [v23,15/28] riscv/traps: Introduce software check exception and uprobe handling
    https://git.kernel.org/riscv/c/6f71171a7448
  - [v23,16/28] riscv: signal: abstract header saving for setup_sigcontext
    (no matching commit)
  - [v23,17/28] riscv/signal: save and restore of shadow stack for signal
    https://git.kernel.org/riscv/c/4f9da7ad3478
  - [v23,18/28] riscv/kernel: update __show_regs to print shadow stack register
    https://git.kernel.org/riscv/c/320c96a55d73
  - [v23,19/28] riscv/ptrace: riscv cfi status and state via ptrace and in core files
    https://git.kernel.org/riscv/c/7a39f89a817e
  - [v23,20/28] riscv/hwprobe: zicfilp / zicfiss enumeration in hwprobe
    https://git.kernel.org/riscv/c/c09b490a9267
  - [v23,21/28] riscv: kernel command line option to opt out of user cfi
    https://git.kernel.org/riscv/c/6e0dc40ceb45
  - [v23,22/28] riscv: enable kernel access to shadow stack memory via FWFT sbi call
    https://git.kernel.org/riscv/c/dfd087078357
  - [v23,23/28] arch/riscv: compile vdso with landing pad and shadow stack note
    https://git.kernel.org/riscv/c/2cfe57e3bd9b
  - [v23,24/28] arch/riscv: dual vdso creation logic and select vdso based on hw
    https://git.kernel.org/riscv/c/418316aa61e8
  - [v23,25/28] riscv: create a config for shadow stack and landing pad instr support
    https://git.kernel.org/riscv/c/c5f5ce714457
  - [v23,26/28] riscv: Documentation for landing pad / indirect branch tracking
    https://git.kernel.org/riscv/c/73d0ccec35b8
  - [v23,27/28] riscv: Documentation for shadow stack on riscv
    https://git.kernel.org/riscv/c/6b8214c8cbd6
  - [v23,28/28] kselftest/riscv: kselftest for user mode cfi
    https://git.kernel.org/riscv/c/0f226cf6026f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



