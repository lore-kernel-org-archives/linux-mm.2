Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAEBAC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 17:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FCB08E000B; Wed,  6 Aug 2025 13:15:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D46A8E0003; Wed,  6 Aug 2025 13:15:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710EE8E000B; Wed,  6 Aug 2025 13:15:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61A928E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 13:15:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0994B136373
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 17:15:27 +0000 (UTC)
X-FDA: 83746983894.29.82E4BF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5D31A12000A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 17:15:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vw1aN0hN;
	spf=pass (imf29.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754500525; a=rsa-sha256;
	cv=none;
	b=O/qrlBeXTf5qYpcM08KkW5HGnvG9QfVe8lgJHKqrMe6Zhy5vceeOXq1Do6wb/VTTtIKZ4c
	Z15MgOzPijWqRLVdB5VbOgxA6PqEM8RDksLn+xd1IwImXfye85+RAPxVySIU337rkgK2yL
	F7jswN1ddrpOtWjrSTqtOGodtiKeSZY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vw1aN0hN;
	spf=pass (imf29.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754500525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhkAYcyUkHe7iiZXASHY9terOMAjIpcAW252vrO9S1E=;
	b=KiGqtKYuCDI3GS/V/wXex+1ZDQWIeYM3hmZ9TgBI7nik+6AimcmxnXgnx3OwUXAUKKMuDB
	fLJmiGGfqNi8ZBQfY/+387aLjKMGV2vGBeSECFd9xHzVJEH1WAvWsX6qGqvIF4nRiO2EWM
	Quz+JUJb5sFdwF1R+K03XoLZZe0mBvU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 61D65601DC;
	Wed,  6 Aug 2025 17:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283FFC4CEE7;
	Wed,  6 Aug 2025 17:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754500524;
	bh=iP1Vp96AUt0/1/dByJQwxu90FSDRv7L6wCxaXLDltks=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Vw1aN0hNtZowJgcCAWQjQrvy1CggQwRgv1AmfnF9BoNdbhKbl20bmLNFFEinlAXHV
	 +w4BhSV/iS5VpXCOXMfVC2oib1f4+cK4iU7lMkZEEuSYSsXQwhmIdfXIRMLMtdLxW6
	 1KnFFSB4y9bLqDKwrY6nypuQDbyPsoApw+aSreNqSOIMJO1YmARi/cvjsO8onAay8V
	 3XHxzDEvk/SD9mXgpLU2s2lQtZBsUaTRQ3dxYTNcVGbq6wDyDapPIA5HrbwYZl6fkH
	 NAa/SFX/I0dxSzNBYT1szqKceE/kuRjMhUic9aZIibRYVGurAM2E1C6y9jEaDfnJUq
	 YZcwSJ3tFPqFQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33C94383BF63;
	Wed,  6 Aug 2025 17:15:39 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <175450053775.2863135.11568399057706626223.git-patchwork-notify@kernel.org>
Date: Wed, 06 Aug 2025 17:15:37 +0000
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
In-Reply-To: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
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
 zong.li@sifive.com, david@redhat.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5D31A12000A
X-Stat-Signature: eayjzxbsihytza4wmxii71dgubpaiy8i
X-HE-Tag: 1754500525-667218
X-HE-Meta: U2FsdGVkX1/Jlms5m5Z2/418Pbst2z7ttWs4wpladMAVquzdnTiSUeefRzNUKI6Nlq62pKiV127Dahcl+ucreece8cdLVo0oipjMa9zoJ03eSXEMt24ZFKT7sve0gUXiHHIn+2w2e/NwCE4ZidD5/xRFSgBClvJLrKI3m4CVEGUww5EO72C754VqGiv4tLgy2SeHx2F1GbfGAokOxJlGHvEqB5hi++kjY0dfq9vJ0SdOobXqWzyGbCKG4vXtZOSWnGGs8yC6DcB/1f1/Yq1KXPl+SRbP3EnlPDPJoURk8F1E27eBB0RydDbO0l37z1oEtbhbShTqYtewwpcf4dQgfjFoSpIEycRLyGyrRg149k6dPNm278EElDnTHg0jUwn/U91pgmzrn6FvdR4a/Hlam4zWEJI0gkpulUJ4xKK+70Jclr4DQGlezOPRfmYi1kcFv/jcxcg3BWhVPkkTEeK76x31KFwbg8wUEwSHDrzeE8Ud/H8zUjOnfHhqvuM/JZ7R0ypQPskwRGtF03QOvVZSs9amEz5BPx5iBnkZZZKyiSozk6Qg6zVd7vX75z99OsN0GLMYx+3u/g++MpLU/rOci79WL/oEp53Jss/HbaS5lENAJE7sok9Eta8OXqjPWiE4a64swFYbj/xr/a3nUd5LlTHlmsXYAH7n4Xux/OALQYh3aMVG2/l41tb5aVcPp1eWXofWFzsd+rvu4c5VareqdhuGlJEQ/Cr0u0WNIXv7LbNB8vYcXedl9J1hT67LIW9jbJ0l+E3TzyCvbiQDI4WE9EQNWdJaPa0QheqvQmMHo2MxSz9BEiuqio23j5svXcwVgey469Ccl1Mdq0zKgJ9c6vln43zTSfdyULea1sHeuRoCyB4ysvCG8BMwsWl+5kgHi3Cz9YVVUVwARP2o3QVcGySmtFAhTYWYbKDfHG8ink7LSrKlfAKP4SN/Wt5QLpPh5nnI0nzKwi7+z8wtmti
 C+Jm2hBy
 ZCA31e8SbjG72IY4e1ekC65CGeblcMdHcHlkR4r8Agyj10Ov05l4Sbf2LJO5Zv0JfJieDeSvtpeK8IsfGIaA7BAD9JH+bDX6CSRf9bl/zd42P8/cZD7KXgT18hnTeUmJZai3+WjdUmXHshIB9KogzYKg8XXYono0svessyf9Pfuv7XLXI95VOJOmQVh3s3h/b0Od83+vzPnDWADdGIMriB4eoADxlzveZNfYCYQ70cRmyMdUtJeu6jKwczhGH9uaJ+TDvA9hax+cZMIh64CL0m3CYhjvRPWDc38aM5exublK5GMANWRmG+PC6I07Ew6RetYivVvCCRk1sqH0uNh8yhfVbEOf0BWfRgS3koRtvYRJwyoMzb6JULrZ7Hm3HUHq7yH6j3daGphQ7J7Q1nO+w58n7FDBY4d0ongeqLoD4P1I0Z+dd7678BG/rwREcMiT2w/Ivp+Ir3xTk1cv9XsfomfGWRurymdpuXloiMvItWd6RMtocay3Aid5P1NQLjqu/5uXE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to riscv/linux.git (for-next)
by Alexandre Ghiti <alexghiti@rivosinc.com>:

On Thu, 31 Jul 2025 16:19:10 -0700 you wrote:
> Basics and overview
> ===================
> 
> Software with larger attack surfaces (e.g. network facing apps like databases,
> browsers or apps relying on browser runtimes) suffer from memory corruption
> issues which can be utilized by attackers to bend control flow of the program
> to eventually gain control (by making their payload executable). Attackers are
> able to perform such attacks by leveraging call-sites which rely on indirect
> calls or return sites which rely on obtaining return address from stack memory.
> 
> [...]

Here is the summary with links:
  - [v19,01/27] mm: VM_SHADOW_STACK definition for riscv
    https://git.kernel.org/riscv/c/cbac1921f599
  - [v19,02/27] dt-bindings: riscv: zicfilp and zicfiss in dt-bindings (extensions.yaml)
    https://git.kernel.org/riscv/c/529ea23b9724
  - [v19,03/27] riscv: zicfiss / zicfilp enumeration
    https://git.kernel.org/riscv/c/2672fcca7d45
  - [v19,04/27] riscv: zicfiss / zicfilp extension csr and bit definitions
    https://git.kernel.org/riscv/c/9c6a894fd8b3
  - [v19,05/27] riscv: usercfi state for task and save/restore of CSR_SSP on trap entry/exit
    https://git.kernel.org/riscv/c/b01f6537153c
  - [v19,06/27] riscv/mm : ensure PROT_WRITE leads to VM_READ | VM_WRITE
    https://git.kernel.org/riscv/c/c13b2d7c1365
  - [v19,07/27] riscv/mm: manufacture shadow stack pte
    https://git.kernel.org/riscv/c/68cd7334a8d2
  - [v19,08/27] riscv/mm: teach pte_mkwrite to manufacture shadow stack PTEs
    https://git.kernel.org/riscv/c/50c9b9607c89
  - [v19,09/27] riscv/mm: write protect and shadow stack
    https://git.kernel.org/riscv/c/cbcccac1eddc
  - [v19,10/27] riscv/mm: Implement map_shadow_stack() syscall
    https://git.kernel.org/riscv/c/26e35e774a64
  - [v19,11/27] riscv/shstk: If needed allocate a new shadow stack on clone
    https://git.kernel.org/riscv/c/9c72a71321a6
  - [v19,12/27] riscv: Implements arch agnostic shadow stack prctls
    https://git.kernel.org/riscv/c/52eff0ab5f8e
  - [v19,13/27] prctl: arch-agnostic prctl for indirect branch tracking
    https://git.kernel.org/riscv/c/157690650241
  - [v19,14/27] riscv: Implements arch agnostic indirect branch tracking prctls
    https://git.kernel.org/riscv/c/e97ca201e919
  - [v19,15/27] riscv/traps: Introduce software check exception and uprobe handling
    https://git.kernel.org/riscv/c/d88b76756b34
  - [v19,16/27] riscv: signal: abstract header saving for setup_sigcontext
    https://git.kernel.org/riscv/c/63e713f29efe
  - [v19,17/27] riscv/signal: save and restore of shadow stack for signal
    https://git.kernel.org/riscv/c/5b04bbd448a5
  - [v19,18/27] riscv/kernel: update __show_regs to print shadow stack register
    https://git.kernel.org/riscv/c/1400341403b3
  - [v19,19/27] riscv/ptrace: riscv cfi status and state via ptrace and in core files
    https://git.kernel.org/riscv/c/982c862820b8
  - [v19,20/27] riscv/hwprobe: zicfilp / zicfiss enumeration in hwprobe
    https://git.kernel.org/riscv/c/07b1d75233e4
  - [v19,21/27] riscv: kernel command line option to opt out of user cfi
    https://git.kernel.org/riscv/c/2c268d3d21f9
  - [v19,22/27] riscv: enable kernel access to shadow stack memory via FWFT sbi call
    https://git.kernel.org/riscv/c/4ff7e8937f22
  - [v19,23/27] arch/riscv: compile vdso with landing pad and shadow stack note
    https://git.kernel.org/riscv/c/a82422297e63
  - [v19,24/27] riscv: create a config for shadow stack and landing pad instr support
    https://git.kernel.org/riscv/c/5bb36633ee56
  - [v19,25/27] riscv: Documentation for landing pad / indirect branch tracking
    https://git.kernel.org/riscv/c/9868b87525d9
  - [v19,26/27] riscv: Documentation for shadow stack on riscv
    https://git.kernel.org/riscv/c/a56a53730eb6
  - [v19,27/27] kselftest/riscv: kselftest for user mode cfi
    https://git.kernel.org/riscv/c/fd40e4a14f45

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



