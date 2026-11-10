Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B587F60A2623
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X+rANZFM
Received: by kanga.kvack.org (Postfix)
	id 86BE56B05C7; Tue, 10 Nov 2026 11:03:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 845A66B05C8; Tue, 10 Nov 2026 11:03:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70E346B05C9; Tue, 10 Nov 2026 11:03:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3AF426B05C7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:02:59 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D8B912094F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:02:59 +0000 (UTC)
X-FDA: 85419678078.06.FDA570D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id CFEC740011
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:02:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X+rANZFM;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794326578;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2J0bHwo7Nm+XHd7c/BVtqZ3FQ1emJddLNsYAfeJ6ojA=;
	b=KhS8ns3odBQlpVqJ+VYe+n73A0h1gLapzhB1naQVc7t1kpwW8I8iBkZiWptBIPHbZS0G2/
	mNeb2cOppfBDw/CvDQhIIrvCp1TH3CCMijvJsPxlXwdZ4+B5WTx6VsOl4akBnE91gvLxkg
	JgCwZGpykMC0ZDl6JkhNEJdXS5glopM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794326578;
	b=xYhf1O1VrOY4+wPdM2/8oxvnBWExKr8f4NsBC9Mij/Lku97Y9BXTSyVqW96dBpSOHZDk58
	N1mdoUwwCfGn6mz4/7hEX3K0QnT3niNPw8J4gLRALM9EAe9UDEUY7CQcV85i75EtreLWXk
	0iyRKWijF+P6ktUSz+jlKaHsJYQoGvY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X+rANZFM;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1827344F77;
	Tue, 10 Nov 2026 16:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6051F008A1;
	Tue, 10 Nov 2026 16:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794326577;
	bh=2J0bHwo7Nm+XHd7c/BVtqZ3FQ1emJddLNsYAfeJ6ojA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X+rANZFMBgkBXGJj82318D+O7DqgGdQIEVbu4tyCPmOIydqYiPM9cSeAE5n+Co4UF
	 n6S6efAo+Uf/Kihg/kEFqrImLqC5XPHBifb/1M6zQdhxbQtYT4CueEW5Jo1GGVnDLV
	 Z/VgawhlHyO9PkysB+dbJJPlxd9h5Edn2U30svbVb/lFPgJ719xOozaEvWYxrwaa9Y
	 IGTGmZjfY+n0ZaLUbo6mShQPqk/LRMfsNimvFte2M7n0mXUF/BNPuF66wdzcR6j9cG
	 RsE7mi5Vc18MpIvXaEVhFOIgJLrBQer35ZBoZBL1w/yZuvIzNKEoaASq0cufPCUjZ4
	 JCsH/lEpBdxQw==
Message-ID: <sashiko-outbox-207333@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v10 19/22] arm64: kpkeys: Batch KPKEYS_CTX_PGTABLES
 switches
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kevin Brodsky" <kevin.brodsky@arm.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ard Biesheuvel" <ardb+git@google.com>, "Andy
 Lutomirski" <luto@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, =?utf-8?b?RGF2aWQgSGlsZGVuYnJh?=
 =?utf-8?b?bmQgKEFybSk=?= <david@kernel.org>, "Jann Horn" <jannh@google.com>, "Jeff
 Xu" <jeffxu@chromium.org>, "Joey Gouly" <joey.gouly@arm.com>, "Kees Cook" <kees@kernel.org>, "Linu
 Cherian" <linu.cherian@arm.com>, "Linus Walleij" <linusw@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, "Mark Brown" <broonie@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Maxwell Bland" <mbland@motorola.com>,
 =?utf-8?b?TWlrZSBSYXBvcG9ydCAoSUJNKQ==?= <rppt@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "Pierre
 Langlois" <pierre.langlois@arm.com>, =?utf-8?b?UGllcnJlLUNsw6ltZW50IFRv?=
 =?utf-8?b?c2k=?= <ptosi@google.com>, "Quentin Perret" <qperret@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Will Deacon" <will@kernel.org>, "Yang Shi" <yang@os.amperecomputing.com>, "Yeoreum
 Yun" <yeoreum.yun@arm.com>, linux-mm@kvack.org, x86@kernel.org, "Ira Weiny" <iweiny@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>
In-Reply-To: <20261109-kpkeys-v10-19-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-19-aa6c4d9603bc@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 16:02:55 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: r899ejs4q156qji6cye65zf3wyxm18k7
X-Rspamd-Queue-Id: CFEC740011
X-Rspam-User: 
X-HE-Tag: 1794326577-838220
X-HE-Meta: U2FsdGVkX1+YMhwp0VJcf5b3At0vWlIEi7zmTSJl0O/aIL3wKSGvyTE0Oo775wf13zzw/seXW/LlcnfIAseOXgPXOcdKfmz/ydx9pV//jzEUaZFinm2MGr/dttbmv2k3UsyNUofxDnRfq5br3MWjutxEnC7ywDeWUJtidjKbIp/SdfmXL5NSjH9G+i5M6+1mZxj6Y+nIND8sVG8yfrYkwMIrZH0tFcGT8GvrdPulsnkvGhafpFHF0sG81WNpTj4y4pzY7vc6F9K0AYymHcyCTUq63t6/10sJi8NroxCjWEND47FWD4zLhszKiQ4sZyjAU+fWXklvqgihtTIG4yODsCg6jZrE9/e8ZjLCVbHc5JQYkQpnOut+OlSEQLhh6lkc7gf4HkfZhA7Qm9rIhfEd8ZJbOx666ZY9DX6qLCw63fZ5QGm4gLrIK3oQIowPsnBBzmvIEUeta1vUnk3BqafAyz/udc+6v9Tdyx1sQT/dDb6JvCl8FDaEWhBvSKRINTksYE3Ttu+sOk09P8TBvA+PKzw2mzByLHPayRNzgceyDZxCYZSDW6uRuKaZj+9+1yfrVrQca/tf/i61KTwkRN4EtgsccErKyTxDzF4U3b02734zAHFTZSjyjyFKbiNDXHAII4o6tOsiX6oZP15/b+gFN20Vpbyb/pqMqHjx05imYCCa57MEfMx0H4kOh8WVknqn1TBlYFlHs9dgfv89p4vQ3m2+ZBLMfkpqqe3oALy08pL0JFyE5Q6aBPWS/FzHjgXOkkoBA3nlp5NHitHjbCSkpbqKhH8YziRQ0pRU8S7dhYpBprRlQ/Q8pDKub+/ajac9LtjNYLJv+tHqmt6l1BiXTUPjtW6e9dg4t07gSx2qWT7aKO6X6ZDSDBvs7qbFr6DIfXhBFaMpjLReSNOFGCOAskExfk8f0d+0AywJ/4fwoTKmvtzcl8o7+XKB4zCkAp19ZMOGVLv7zwMWSg/w6HG
 M59ACuWY
 mtVzzvKZRZvg2CHVz8GyLIGVDgU0HFd7pkUKOTe2L3osVOtCY97Jv+arjvRGrFc6wd5vZvIH0hgA3daGZb553L16yTfbiU8kPN0mVJxAbicgGlmWfdvhxhZt5/trPJGJWxX8sfYoPZ46n/5eahi3fn65eTKebczWB/ELTExoBJiMIx2lhaymKkVsDtFTPMz4Ae1c1ABEW/VnlOsIHh1HZypMzB7Yt1VpYgHyRdKswAEiJ2sk44ahjzjU3VTOLNEuh2s1tauIhtCxWIqeChvpHozdugg5XV8fRhWk3JURdvKzxMcmzXrE3Cdxsm1PqoGHVn516v8ElWJr5MyB+7MCE2TvodM/MX9VEYUFWJAXqTVWkeoataAOJUjwwfYBRswE/0fOTtM1O/H+Ioaiyq4GzqH3o+Bq78F5XW1iqdJmdRx5FpWmWlZ+IzR99oaB59pzwRnUljURfWkW/qwPwwwkWOhHms6ilD5cjw1eB4IZFA2zs19C+WJ1r1MLQx+vaXs8Ndrs5AbWQWRk54/GkBsVyZHz/kOrB7y4tnXm73FAMiBI05uO2N5KlJN+k7MTHLikTeY2gRW48FJJ78OBj8JSoFFv8Ap8CeOT1QSCiHCYGKplXz6qI0rkSR9c/uzZ/hDCbTTiZrsimW7p94JvL80ej/ksIrAS5hJRJknvJwkatWbDe2vHxHbPkNbkqAaGl996ALub3JRHOga7TL301yKTVFPnEakd3lQ25qFw6A7uadepVKBTIFd/k5awZ1frEfCs72cxWy3kMY2BH375zEbilQxt99A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] arm64: kpkeys: POR_EL1 desync with is_lazy_mmu_mode_active()
  on entry/exit
--

commit 1b260fb8242fe345fd5e4bdc00ba9a4272383991
Author: Kevin Brodsky <kevin.brodsky@arm.com>

arm64: kpkeys: Batch KPKEYS_CTX_PGTABLES switches

This commit batches KPKEYS_CTX_PGTABLES context switches across lazy MMU
sections by switching POR_EL1 when entering and leaving lazy MMU mode and
skipping per-write guard switches while lazy MMU mode is active.

> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pg=
table.h
> index 5f46d4cb38828..5e958531e6abe 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -43,10 +43,44 @@
> =20
>  #ifdef CONFIG_KPKEYS_HARDENED_PGTABLES
>  KPKEYS_GUARD_COND(kpkeys_hardened_pgtables, KPKEYS_CTX_PGTABLES,
> -		  kpkeys_hardened_pgtables_enabled())
> -#else
> +		  kpkeys_hardened_pgtables_enabled() &&
> +		  !is_lazy_mmu_mode_active())
> +
> +static inline void kpkeys_lazy_mmu_enter(void)
> +{
> +	if (!kpkeys_hardened_pgtables_enabled())
> +		return;
> +
> +	current->thread.kpkeys_state_lazy_mmu =3D
> +		kpkeys_enter_context(KPKEYS_CTX_PGTABLES);
> +}

[Severity: Medium]
Can a synchronous exception between updating current->lazy_mmu_state and
switching SYS_POR_EL1 cause a fatal permission fault when writing to page
tables?

lazy_mmu_mode_enable() and __task_lazy_mmu_mode_resume() mark
current->lazy_mmu_state active before calling arch_enter_lazy_mmu_mode():

include/linux/pgtable.h:lazy_mmu_mode_enable() {
    ...
	if (state->enable_count++ =3D=3D 0)
		arch_enter_lazy_mmu_mode();
}

On arm64, synchronous kernel exceptions (such as kprobes or KFENCE page
faults) do not set NMI, hardirq, or softirq bits in preempt_count(), so
in_interrupt() remains false and is_lazy_mmu_mode_active() returns true:

lazy_mmu_mode_enable()
  state->enable_count++ (0 -> 1)
  <synchronous exception, e.g. kprobe / KFENCE fault>
    ...
      __set_pte_nosync()
        guard(kpkeys_hardened_pgtables)()
          is_lazy_mmu_mode_active() =3D=3D true  <-- skips POR_EL1 switch
        WRITE_ONCE(*ptep, pte)               <-- unhandled EL1 permission f=
ault
  arch_enter_lazy_mmu_mode()
    kpkeys_lazy_mmu_enter()

Because is_lazy_mmu_mode_active() is already true while SYS_POR_EL1 still
maps KPKEYS_PKEY_PGTABLES as read-only, both a nested
lazy_mmu_mode_enable() and guard(kpkeys_hardened_pgtables)() skip
switching SYS_POR_EL1, and the page table write faults.

A symmetric window exists in lazy_mmu_mode_disable() and
__task_lazy_mmu_mode_pause(), where enable_count or pause_count is updated
before arch_leave_lazy_mmu_mode() restores SYS_POR_EL1.  A synchronous
exception in that window that enters a nested lazy_mmu_mode_enable() sees
SYS_POR_EL1 already set to KPKEYS_CTX_PGTABLES and overwrites
kpkeys_state_lazy_mmu.entered_context with false, causing the outer
kpkeys_lazy_mmu_exit() to leave SYS_POR_EL1 writable.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-kpkeys-v10=
-0-aa6c4d9603bc@arm.com?part=3D19

