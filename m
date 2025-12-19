Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7D67D711D6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6C76B008C; Fri, 19 Dec 2025 03:13:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECB5F6B0092; Fri, 19 Dec 2025 03:13:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCDD16B0093; Fri, 19 Dec 2025 03:13:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CDF5F6B008C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:13:22 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5CDD8C0601
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:13:22 +0000 (UTC)
X-FDA: 84235505844.21.1888170
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9A4474000A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:13:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bvV56RgS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766132000; a=rsa-sha256;
	cv=none;
	b=HKp3uirw15BqJl5l/cbMcGCvtpFQwtvWE3sGWYSXkW8bfuw3PBUfxgyUw0/BgwVdV47isQ
	oRg1MPvRnz0rRHnZpTOuy44dvvZWBRGN8n4S86MV9U13nzs610BW6lRgggZ73RQYrRUX7s
	JwxaqXYL+jvaxTi+OgQhzvByVTJz5ak=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bvV56RgS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766132000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4kZkHpdaiDkkZcvv8EinliAFULym58ZDDfTLrx6tdQ=;
	b=0at+zsTR0GxSOBr2a9O3uLC6CiXJX+kjRYxBRj6urAwYvElh1rGbgbmvUM9JKZvwyp51q+
	gGZDOFdMvZfoMnIK52HppyD/LsPnYF7mx+7Gn4LfbpfuREcBGxP1P4mqq+Mh9oQG/LsZDw
	HbLP1+KlkR45j+QszrpF0mWWQBRfgPs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B70624416F;
	Fri, 19 Dec 2025 08:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C38C116B1;
	Fri, 19 Dec 2025 08:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766131999;
	bh=c8UdFBb7F8dmejdnU77Se4Vh0A297D7YwvyeUjSzvGs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=bvV56RgSwPdWBOuOtUPVcXSmtsttDdT6myfmjpB+QZDRMIVyr7unLn+z+isWBP0Wy
	 Ny2hKlhPpLoymTC6JQ0DzSc0lTtu4IdOjoxflDk5ls0qr9rZjX4H6YN/PUpzbnQdAP
	 YpBOlDFBUmVl0ocWFf3MbPKhlUbei8L4bQwXt0Rf0W+fKMNrpn0yKASpPBE+phUtE+
	 eS0MjQp6QSCCa4q9q8ZjhuUYyTNuM7t+D6ja4QPtH8eUDpUit5SxogEKu15rseJwgW
	 mLfXoM8WdWG/4ZWUCIaOk3MfOwvaMmfztq3vshIPQCpKqjoQqXVEii+dxxDbG6AI8Q
	 Q/PUXYGj8Kqgg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B5B5D380AA50;
	Fri, 19 Dec 2025 08:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 00/31] context_tracking,x86: Defer some IPIs until a
 user->kernel transition
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <176613180853.3684357.18339473690014642605.git-patchwork-notify@kernel.org>
Date: Fri, 19 Dec 2025 08:10:08 +0000
References: <20251114150133.1056710-1-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
To: Valentin Schneider <vschneid@redhat.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, rcu@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, luto@kernel.org,
 peterz@infradead.org, acme@kernel.org, jpoimboe@kernel.org,
 pbonzini@redhat.com, arnd@arndb.de, frederic@kernel.org, paulmck@kernel.org,
 jbaron@akamai.com, rostedt@goodmis.org, ardb@kernel.org,
 samitolvanen@google.com, davem@davemloft.net, neeraj.upadhyay@kernel.org,
 joelagnelf@nvidia.com, josh@joshtriplett.org, boqun.feng@gmail.com,
 urezki@gmail.com, mathieu.desnoyers@efficios.com, mgorman@suse.de,
 akpm@linux-foundation.org, masahiroy@kernel.org, shenhan@google.com,
 riel@surriel.com, jannh@google.com, dan.carpenter@linaro.org,
 oleg@redhat.com, juri.lelli@redhat.com, williams@redhat.com,
 ypodemsk@redhat.com, mtosatti@redhat.com, dwagner@suse.de, ptesarik@suse.com,
 sshegde@linux.ibm.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A4474000A
X-Rspamd-Server: rspam10
X-Stat-Signature: 4p9ho4jbmk873wtrfguc389pdxn5g945
X-HE-Tag: 1766132000-780418
X-HE-Meta: U2FsdGVkX1/wz4RDUlYFv0Y1Q3Z4U/dphW/wH0omnopKIhSwd/6h2b/SvWj6j8CoMHiu392USxQKNgP8i488hNnPa8XG1wbAfnZoKgMsBVUVB8SDV76fB4CBuMm8WOZcEPchXvWTpU43UrW6G/d3Yz0Bg8k7Ee3HTwQb0W5cJVo1jLvD232EE2oGgaGmCsqMjZCVPyyZVgxr682FtdYPlg3uUyKTgtnnEgmPJnKcnx1LEGrisnI8z6TjMyMuZvhzCnwqsPoEVwsldippYB9UYSXlDth7uXE8AFwEI8l522k0RGHoWKs1agV6B/JlMXWqwLO/pPa3EYxF/Sqk51IoADVMgg07bQbx8yEH99uQg9qR7cZzApp9H4EVuvV94B8WR18fsuTiefMyv1lo7aUuzXtqaEncYO5DKXcWNJJ/cJk5dw4MjPsQuoySYv8/JkVnyZEHfSyzZ6j4p0a5hq9GKfK3Ur6WmdHVS/xiAMa4B+75A/WAH7zKSz81ws6Popum20P1ei/ZBSE9qGD6uMOeUIgUNDDJkdBFx/Z1zQmunSjzhEiQySYuV7SqiPWZPrT4A7ieI0q1bT2obzL3iz9T+HWtTif3UxEyJj3Hh911wlOhxojea0bZ3kd7MgoFWlYPw6TkHUhQHOPvdq79Ter15ayPAF54p0hAN+QsLU4cIkA/FPIhkslZueYIAJHRNGWXr6F5h+sdTmtpNiAN5/6/VQVQTA5vydqoFbLEzzlcbHOSHElNkWIbJIRSxD3t2OtLAKyHyTXTtR+Stws0IExlulFE2g8hAKd2zt7RuxFyT7iIC+dHfICSVrgf1WqlTJXzEi63g1Dq2GHjlS/5WY6e/npZtaOombYR81GYctM8vWozXCoNbGk0TA8FgPAJlRRMjux7ci062BWNmefLODvhycvmtNeloPGU/tIxEOehiRkSw0bRGvW5NRGQOmVvNaWaO2MzQQrdbGgygfaCZMS
 VPH/amfm
 /p/iSNPVk3Tvr4Hu+pT7u6wwKLGyMb//oqmkniXG5T/8Nq+yIOcjjA6M+pqYxGvwnrwm5+qJYPeqAFPF0ARzLR3piy3mNFGIMbw0S64rpNKF9volHsmVOQ7kQJryfcyiKzMU/p+p2Jb8ESeO65PNjFRYeR1mb27DHj9nBcHvWxri8RH3LsK9G6su9llpHBj9YfYWQRRaNeV0v7WeJ/vQEERWvgnQvL53hyMu2yDm+ibARjtKVsiM0AEewVhq/lPYS3zGkfW8eWSQnjagZpKy3rTfoo3FshIhzCL5e5oLKVjfJ8UWf1EtsUvZffbnKB+ihzQ26RWZj+b1CdfPZBhfBxuBmO3OstpBxhCit/L8FVwwwVzy8RoYYf9+l+BSpUxm8ZZt91UFvbZf9EcMLn2s0nAMg4hyvfkzPP9lhzYl5S1zKac432jcPGFD55mqI70su+R5gMWORTiqPQLc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to riscv/linux.git (fixes)
by Frederic Weisbecker <frederic@kernel.org>:

On Fri, 14 Nov 2025 16:01:02 +0100 you wrote:
> Context
> =======
> 
> We've observed within Red Hat that isolated, NOHZ_FULL CPUs running a
> pure-userspace application get regularly interrupted by IPIs sent from
> housekeeping CPUs. Those IPIs are caused by activity on the housekeeping CPUs
> leading to various on_each_cpu() calls, e.g.:
> 
> [...]

Here is the summary with links:
  - [v7,01/31] objtool: Make validate_call() recognize indirect calls to pv_ops[]
    (no matching commit)
  - [v7,02/31] objtool: Flesh out warning related to pv_ops[] calls
    (no matching commit)
  - [v7,03/31] rcu: Add a small-width RCU watching counter debug option
    https://git.kernel.org/riscv/c/d1e6d2773898
  - [v7,04/31] rcutorture: Make TREE04 use CONFIG_RCU_DYNTICKS_TORTURE
    https://git.kernel.org/riscv/c/82a224498005
  - [v7,05/31] jump_label: Add annotations for validating noinstr usage
    (no matching commit)
  - [v7,06/31] static_call: Add read-only-after-init static calls
    (no matching commit)
  - [v7,07/31] x86/paravirt: Mark pv_sched_clock static call as __ro_after_init
    (no matching commit)
  - [v7,08/31] x86/idle: Mark x86_idle static call as __ro_after_init
    (no matching commit)
  - [v7,09/31] x86/paravirt: Mark pv_steal_clock static call as __ro_after_init
    (no matching commit)
  - [v7,10/31] riscv/paravirt: Mark pv_steal_clock static call as __ro_after_init
    (no matching commit)
  - [v7,11/31] loongarch/paravirt: Mark pv_steal_clock static call as __ro_after_init
    (no matching commit)
  - [v7,12/31] arm64/paravirt: Mark pv_steal_clock static call as __ro_after_init
    (no matching commit)
  - [v7,13/31] arm/paravirt: Mark pv_steal_clock static call as __ro_after_init
    (no matching commit)
  - [v7,14/31] perf/x86/amd: Mark perf_lopwr_cb static call as __ro_after_init
    (no matching commit)
  - [v7,15/31] sched/clock: Mark sched_clock_running key as __ro_after_init
    (no matching commit)
  - [v7,16/31] KVM: VMX: Mark __kvm_is_using_evmcs static key as __ro_after_init
    (no matching commit)
  - [v7,17/31] x86/bugs: Mark cpu_buf_vm_clear key as allowed in .noinstr
    (no matching commit)
  - [v7,18/31] x86/speculation/mds: Mark cpu_buf_idle_clear key as allowed in .noinstr
    (no matching commit)
  - [v7,19/31] sched/clock, x86: Mark __sched_clock_stable key as allowed in .noinstr
    (no matching commit)
  - [v7,20/31] KVM: VMX: Mark vmx_l1d_should flush and vmx_l1d_flush_cond keys as allowed in .noinstr
    (no matching commit)
  - [v7,21/31] stackleack: Mark stack_erasing_bypass key as allowed in .noinstr
    (no matching commit)
  - [v7,22/31] objtool: Add noinstr validation for static branches/calls
    (no matching commit)
  - [v7,23/31] module: Add MOD_NOINSTR_TEXT mem_type
    (no matching commit)
  - [v7,24/31] context-tracking: Introduce work deferral infrastructure
    (no matching commit)
  - [v7,25/31] context_tracking,x86: Defer kernel text patching IPIs
    (no matching commit)
  - [v7,26/31] x86/jump_label: Add ASM support for static_branch_likely()
    (no matching commit)
  - [v7,27/31] x86/mm: Make INVPCID type macros available to assembly
    (no matching commit)
  - [RFC,v7,28/31] x86/mm/pti: Introduce a kernel/user CR3 software signal
    (no matching commit)
  - [RFC,v7,29/31] x86/mm/pti: Implement a TLB flush immediately after a switch to kernel CR3
    (no matching commit)
  - [RFC,v7,30/31] x86/mm, mm/vmalloc: Defer kernel TLB flush IPIs under CONFIG_COALESCE_TLBI=y
    (no matching commit)
  - [RFC,v7,31/31] x86/entry: Add an option to coalesce TLB flushes
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



