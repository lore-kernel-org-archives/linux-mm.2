Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F04DCFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 21:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326A76B0062; Thu, 27 Nov 2025 16:14:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7556B008A; Thu, 27 Nov 2025 16:14:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6816B008C; Thu, 27 Nov 2025 16:14:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 089CE6B0062
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 16:14:13 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D353B7646
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:14:12 +0000 (UTC)
X-FDA: 84157639944.14.77F93D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id DF40C14000A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 21:14:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=khkgOJ3j;
	spf=pass (imf26.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764278050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nsDNn26TAQW6xjlLQ8JyUcY14JvPxenmWyCHcJA14a8=;
	b=bAOarcGG+1xtQW2N6w1/ysxn9u1xq1Bkriun/80wGM2ipxDdqpQWhYjC6ZeB1aCTXiepgb
	E19gC8HZqPZ2toNUSj3nmuhzT1q3virS9stZXREpSATDb5lw2ludnxguA4d56yQWuIrYJ6
	Utk/0tLY25sA5FmFtHdSJkaznFh+LJU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764278050; a=rsa-sha256;
	cv=none;
	b=QJhfOwpcGmJdDfP8TC8YRL1IQodSutY4wzR8U2kfURGsJym1GRVWcpD1WdQ2jwA82Slmni
	t5fQ9BwXJUITq0S2DAkzkVYmcfKT+CZ24xZFw9rbv92MFc3fYkQ2QRjMkFS66NKQPaESqi
	m5VhFujNhv6CXtaVLxsLF5PASG7MaOw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=khkgOJ3j;
	spf=pass (imf26.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 29E5D60242;
	Thu, 27 Nov 2025 21:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA79C4CEF8;
	Thu, 27 Nov 2025 21:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764278049;
	bh=Fi9uBpjCD9vm8iluPdYQEZRrTQxH47uO4POYpNrObW4=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=khkgOJ3jyY5Z1bRFubXx8+PfzwwpzTLhKmfop/KpcKgOZsNorgafnpms8HWthBlZm
	 Qjd+fBibf2KNWHwA60kRIHSzeqjIvG22F7oj5vdloc93fv9hv4l8KaBkJrRVc+ix3A
	 qNW9H3ZKe0qRJMBV3nBa8qM1pz0GxGYSnGlezZ1NnfqTcyE8nX44WgR2tKPkYUEgbJ
	 3hnD1zdApuKj+qKpcUvRaPdSb99IEx4ut3J/Re5H872dPTVyRnff2sxsVeH6S+e7Jz
	 l8F4gH+/wnKZ+XCg81W1LX+OH0VsQa/DCQaWbyYoHg+PnmOL68kDGpGTByinNHagPP
	 od+aoTIJWdbgg==
Date: Thu, 27 Nov 2025 14:14:03 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: linux-riscv@lists.infradead.org
cc: Deepak Gupta <debug@rivosinc.com>, tglx@linutronix.de, mingo@redhat.com, 
    bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
    akpm@linux-foundation.org, Liam.Howlett@oracle.com, vbabka@suse.cz, 
    lorenzo.stoakes@oracle.com, paul.walmsley@sifive.com, palmer@dabbelt.com, 
    aou@eecs.berkeley.edu, conor@kernel.org, robh@kernel.org, 
    krzk+dt@kernel.org, arnd@arndb.de, brauner@kernel.org, 
    peterz@infradead.org, oleg@redhat.com, ebiederm@xmission.com, 
    kees@kernel.org, corbet@lwn.net, shuah@kernel.org, jannh@google.com, 
    conor+dt@kernel.org, ojeda@kernel.org, alex.gaynor@gmail.com, 
    boqun.feng@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com, 
    a.hindborg@kernel.org, aliceryhl@google.com, tmgross@umich.edu, 
    lossin@kernel.org, linux-kernel@vger.kernel.org, 
    linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
    devicetree@vger.kernel.org, linux-arch@vger.kernel.org, 
    linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
    alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com, 
    andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com, 
    atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com, 
    alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org, 
    rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org, 
    zong.li@sifive.com, david@redhat.com, cmirabil@redhat.com
Subject: Re: [PATCH v23 00/28] riscv control-flow integrity for usermode
In-Reply-To: <176423222224.2476283.17736612090314280039.git-patchwork-notify@kernel.org>
Message-ID: <b82ffcca-3173-8c07-4a8a-c42d8d092a72@kernel.org>
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com> <176423222224.2476283.17736612090314280039.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DF40C14000A
X-Stat-Signature: r3y679eb5czf5931g6tjp41msifbpwmr
X-Rspam-User: 
X-HE-Tag: 1764278050-25970
X-HE-Meta: U2FsdGVkX1+MxHTdMBVe+KIf0vVjeDMBOGLAp+N0xiEa+JfJM2+/meP1jix5nf3Bjhxi000lKC69kAARk4uZ3Y5hzPdA9sN2oFmqOf8WMomQMzdf5L0UCn9BTZA5t1ozhETMOMrdCLV3qWVcjegROQ7ZwrvjWGAEZGjXFAjlBj4Hcwn6Kux1yfjr8DSphWYWVLBP50skRrU3Avy4p/0RqnJ4MCK8JMXXykT4NKuOYQMdPpn2cYxUCTAqto89O2NkwGis06cJgjmYMIRP/yIp3SQokg61dScoP+dsOrY32YIWSdnIvG863lkQEESJgAR6OpKPrHCZy7UCEyhHzowqJYEQXOQpK6aHmdNG+W6XNBNxOi8nkGXxXF0vQDX98Y9kDHAQNB2aUu4v0MF6sDO67V5gNZTjGIXRo5frC8cH0OlRTlp26TDVrsEYxQj7Ejuc6DLxNY6hH9TE74CFmaIytHoP+2EO1CErfhVqH7EgPSMuOwIF3Of+9vlW14w1PNM0Jm/1rgwARZ3z/dPgEFs9k0uHhdOTMjyeVV04H9EhadXbR9xsUIQu1HMX3LZeOMQnZLxjzmmKcnhzY7I879eYxD0JbqZ7jSebgx5QbTM3zdQ6JoUWIUcpbA8yXa+CDl5IVwNXI0L+xEE+97a+HbLq4oJ/w6k/6//tyXGkExXM6S5AwIuUNt5luZOhQiI+1cwGt1F8uNTsMwykTFC5qGCVCC0zZ2h2X19BaUWy57jdkR2VYEdKQ9GAnzoxhwspy7pNQek4MzYiqx1QOOKz2CE4pYHb05NL3ufv+1X2ZshDYFuM/a9VSWMEYXFBfLaTHE+9WhJRHLnfdD2JUDMjSfx9LXJZjn8bKrPkZrrkKQjrAFhrDWzW2OrXHT7Ad9VRiE6bC6yA8C7cWGSW5HcatbXuyfkEVCMlVmc0RHJImXDBkuivpAryyLdHlrb2pubTQ5oB2TBcIpGKitZ2r1TMvwm
 H2BxcGrX
 1lvlW/BpCqeosJmGz5CDC+TFwCngxsxZi7IqexQIOnFOTyE0gsaqroMGkZED/7cQaNKsGprE1lXxdSkY98OwoVP4HDGN9L2EmQMvgo6WRvUyCCYSoBdA1CdC3quMDTOGRNR3on4QkBqMfCB5cJIwmud2R53lIf5R2k4UN0W6MhOo/HOvK3s7i/xFfA0XrI0/3VJONj8Eh/Ld3uqV00cQ+rH84i/bNCVzBemF9DKuua+xHcFFaMGaa58+qd+E78boXde98cBmCg9qPIh//ZaS3b/kUFude5Kt9DFGZucksaoVGrOICD1ViZuxQMgP+06Snd61+ssTm385BZWIKKjGNwGsg9WJICbca4meY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Nov 2025, patchwork-bot+linux-riscv@kernel.org wrote:

> This series was applied to riscv/linux.git (for-next)
> by Paul Walmsley <pjw@kernel.org>:
> 

[ the RISC-V CFI patch series ]

> 
> Here is the summary with links:
>   - [v23,01/28] mm: VM_SHADOW_STACK definition for riscv
>     https://git.kernel.org/riscv/c/ae8460ac9db2
>   - [v23,02/28] dt-bindings: riscv: zicfilp and zicfiss in dt-bindings (extensions.yaml)
>     https://git.kernel.org/riscv/c/b32ccfc268db
>   - [v23,03/28] riscv: zicfiss / zicfilp enumeration
>     https://git.kernel.org/riscv/c/55a811a7f304
>   - [v23,04/28] riscv: zicfiss / zicfilp extension csr and bit definitions
>     https://git.kernel.org/riscv/c/92c96b16548e
>   - [v23,05/28] riscv: usercfi state for task and save/restore of CSR_SSP on trap entry/exit
>     https://git.kernel.org/riscv/c/7720cdd21962
>   - [v23,06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ | VM_WRITE
>     https://git.kernel.org/riscv/c/e60eb198b13d
>   - [v23,07/28] riscv/mm: manufacture shadow stack pte
>     https://git.kernel.org/riscv/c/f8fcb7b5bf30
>   - [v23,08/28] riscv/mm: teach pte_mkwrite to manufacture shadow stack PTEs
>     https://git.kernel.org/riscv/c/0276a5ea1105
>   - [v23,09/28] riscv/mm: write protect and shadow stack
>     https://git.kernel.org/riscv/c/ae615676bc37
>   - [v23,10/28] riscv/mm: Implement map_shadow_stack() syscall
>     https://git.kernel.org/riscv/c/d291fd38f841
>   - [v23,11/28] riscv/shstk: If needed allocate a new shadow stack on clone
>     https://git.kernel.org/riscv/c/d209ea2fa4bb
>   - [v23,12/28] riscv: Implements arch agnostic shadow stack prctls
>     https://git.kernel.org/riscv/c/8b49f512abc2
>   - [v23,13/28] prctl: arch-agnostic prctl for indirect branch tracking
>     https://git.kernel.org/riscv/c/3363a8d1044e
>   - [v23,14/28] riscv: Implements arch agnostic indirect branch tracking prctls
>     https://git.kernel.org/riscv/c/0177891ccdb7
>   - [v23,15/28] riscv/traps: Introduce software check exception and uprobe handling
>     https://git.kernel.org/riscv/c/6f71171a7448
>   - [v23,16/28] riscv: signal: abstract header saving for setup_sigcontext
>     (no matching commit)
>   - [v23,17/28] riscv/signal: save and restore of shadow stack for signal
>     https://git.kernel.org/riscv/c/4f9da7ad3478
>   - [v23,18/28] riscv/kernel: update __show_regs to print shadow stack register
>     https://git.kernel.org/riscv/c/320c96a55d73
>   - [v23,19/28] riscv/ptrace: riscv cfi status and state via ptrace and in core files
>     https://git.kernel.org/riscv/c/7a39f89a817e
>   - [v23,20/28] riscv/hwprobe: zicfilp / zicfiss enumeration in hwprobe
>     https://git.kernel.org/riscv/c/c09b490a9267
>   - [v23,21/28] riscv: kernel command line option to opt out of user cfi
>     https://git.kernel.org/riscv/c/6e0dc40ceb45
>   - [v23,22/28] riscv: enable kernel access to shadow stack memory via FWFT sbi call
>     https://git.kernel.org/riscv/c/dfd087078357
>   - [v23,23/28] arch/riscv: compile vdso with landing pad and shadow stack note
>     https://git.kernel.org/riscv/c/2cfe57e3bd9b
>   - [v23,24/28] arch/riscv: dual vdso creation logic and select vdso based on hw
>     https://git.kernel.org/riscv/c/418316aa61e8
>   - [v23,25/28] riscv: create a config for shadow stack and landing pad instr support
>     https://git.kernel.org/riscv/c/c5f5ce714457
>   - [v23,26/28] riscv: Documentation for landing pad / indirect branch tracking
>     https://git.kernel.org/riscv/c/73d0ccec35b8
>   - [v23,27/28] riscv: Documentation for shadow stack on riscv
>     https://git.kernel.org/riscv/c/6b8214c8cbd6
>   - [v23,28/28] kselftest/riscv: kselftest for user mode cfi
>     https://git.kernel.org/riscv/c/0f226cf6026f

As I noted with the SSE series (before we removed it from for-next), I may 
not ultimately send this in a PR this merge window, for several reasons.  
The series has been around for a while, and although I know some vendors 
have tested it privately, I'd really like to have more public testing of 
this code, particularly on hardware emulation platforms or unreleased 
silicon.  It would be good to see some Tested-by:s. 

Thanks to everyone who has helped test this so far over the past few weeks 
- particularly Joel Stanley of TensTorrent.


- Paul

