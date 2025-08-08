Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A387C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 11:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF2E76B007B; Fri,  8 Aug 2025 07:28:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA37E6B0088; Fri,  8 Aug 2025 07:28:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB98B6B0089; Fri,  8 Aug 2025 07:28:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBB916B007B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:28:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 681BB56433
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:28:37 +0000 (UTC)
X-FDA: 83753367474.11.48615F1
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf22.hostedemail.com (Postfix) with ESMTP id B391FC0003
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:28:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EM9N/akd";
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754652515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SAHcgC2dCT7lVWSIBQiGXToCZB1mcTit8Lv2oRnEaqE=;
	b=e3yNG9hxAokyUfH1S5zwDdoQhZa+gSJbqmWZqi5vGtfxmcdAeUQEF5fTAA8QvIHTlPBeEg
	GB5imfuF3DbEiRP+Y+cgL+ufNbAKzixxDXJkG+EuXaxcVNzBq0VuqmbPgT5NXbwxbtrqpa
	2f1w4igNwFlx0OqvcL6VuPJOOamJQOQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754652515; a=rsa-sha256;
	cv=none;
	b=0vJb/HV6W4mvcDcQp9LMgKa6rt963vYyleiuhxhxeg0LJO+Bn2mM8ASFocIWcZrtx8cGRf
	0iRRcBY8W/qHF9P+T2f1BQvU6KOg9lzWnEXxY+P/oRAfyGlXctZPPyd4Wu2+2DW+qQ4uJ6
	U1bPGY3S9vEuB5VINNWTZrFafDausBA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EM9N/akd";
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 986955C655A;
	Fri,  8 Aug 2025 11:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D52C4CEED;
	Fri,  8 Aug 2025 11:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754652514;
	bh=7bjZzLfO9fl1ghbHcTqWmndQHxP4RCvD8GzQZJjMcHE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=EM9N/akdd5EknCUIRfNSycnmf+GuuLwx9r1iowOgI1VM/jPQJJWuTe2M0lx0BCn62
	 7ZJZSQ8QPw4PqxA3E7U0+yIrHQZQeATd5AYlunMxnVVvZWTDPCfTicAT0WobVXjfdP
	 qAaqRL8W/f20T5FDrzmj4TI/NVMtel/Vur+PgekEOSgDoqkTqBWpz3mfJiTtWKT3kK
	 pRUnPPM6tBDkZBCEfnDCMrAeK5NqhPOWuxZQ+FkxBCvlkPB5K7ZFj5NdL//rfUHp3r
	 JQSeLsGt2mezuOoIzXIH5b/tSYvkvtRRvvukOVKBp96rhpHiU+4ZKlUa79r0A3m4lW
	 p+zYV/qcchcFQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: kernel test robot <oliver.sang@intel.com>
Cc: Mike Rapoport <rppt@kernel.org>,  <oe-lkp@lists.linux.dev>,
  <lkp@intel.com>,  <linux-kernel@vger.kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Alexander Graf <graf@amazon.com>,  Changyuan
 Lyu <changyuanl@google.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,  Shuah Khan <shuah@kernel.org>,
  <kexec@lists.infradead.org>,  <linux-mm@kvack.org>
Subject: Re: [linus:master] [kho]  b753522bed:
 INFO:trying_to_register_non-static_key
In-Reply-To: <202508081032.1450e413-lkp@intel.com>
References: <202508081032.1450e413-lkp@intel.com>
Date: Fri, 08 Aug 2025 13:28:31 +0200
Message-ID: <mafs0sei2aw80.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B391FC0003
X-Stat-Signature: np8tphjxwoewyub6n3bo847rxbnjeh5j
X-Rspam-User: 
X-HE-Tag: 1754652515-151743
X-HE-Meta: U2FsdGVkX1/FuJDmvM1Tuivwc2PWKhx3MwmfiDdkt0kytbpBr5aTjZPcBmR4Bj+CR/RGrdK/7Gb7eGCVEL6bG/E2xbfR3jeBdWFI3BXFYZpxHlsBq+uGV0AZutnatsP0d4dPATIfpQteUFk/8HiWDedmV5WZZzr34AIroh9Do7mYOd74o1jXQCy8XeMzTfDa19HG94N5JSCfQtp1q3I4KanWPK/yuXRuJAdZJ4pPxtAvMnUcEMs6aFRALtXysCQTclL9ANgQIoOQrHEhn9xLv9NIppo2kQdOqJrauu2RlVYjekRkEAYb8vuOhEfG9sEZ6D9kRL0oMADC7YhIwyq4i42hZGD1XlHB7pEmETlRri/To/YFqns/FbElFYj/WUZIJt7Kue97uo25A0kFdkY6GbY1fxEr6Q8dakQRQQW4El8LL1dn114KAPdcu8bqg0bQYKPMVYRqW3Kx7EikPAmX2WK+OfqnZvetEkhERPtDJ5qvOvz4vxA9+gQv4sEk4eC9CPSadMA+F/sD+YbM+pApUplWeI+Nib6sFGoJbB3zgPM67vO4+GYzLwtnOSGe4GUDlnKlAfpB+80ZAIV0E1srMpTI1PD3G6HPL6OzndkaqIdRg7S3o2WcfvgxFHntCZ4jXn41t0pPrQyyWYCEJEjslRXqKNiY/C1hTcljrnrLLNfC3fjEa8H/X7uLfCTCQ66n0KFlnIfFvsVPP4zYsw/Xm4JjPJ99YIQKhlHlBpKjnVIjoshO6vo7dWlL+m4Jhgukjutx+2RFlUbmURPu4LzwerPy95LO1cYFcTt9ACqLGAKkpTc9oMzY2h2iXGNmY7j88/DTLX7tAH7pfwh9LbNy05e6+TcNIMGna3MDHRl6ab8fDU7Uz1I/wzAMiUzEGWZ0yDinAxh/ixz3qaU5OizChbQCIJhtjx6QJL4H+LiCqo96J5Qji2pWJoP/kKA7CpXKe1DWwamO7CJZFk4djeu
 WyhW9eVe
 TmdYp7Zv35IUjYK7zdx+/8W1VuAdId8OySbMpxpiWb1lBlR+FMeUyn8HL7J7p+RFQTaJzi/Dvllncdg6oKAPQxXUzk4j53OR35zE1PuHlzfEW+XB2euZkBVR0NL7BKMGu0YSACYSGChwE2HCkWKwACzmk1jkQD3VxvPEj4RtnPx+nxYGQkPvuyO2nBYQtBhx+QsFCzWo/Dj9D0LaRiQ0ntrmPb+K18SItHbejHw9uISgZQ2X0QK01qKAw1/dZ/RXz70mnMnNDcyvRwcgeDEqWnbzVXhGt+3pqMSw6C2VTXHib9ag=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08 2025, kernel test robot wrote:

> Hello,
>
[...]
>
>
> [   59.011407][    T1] INFO: trying to register non-static key.
> [   59.011783][    T1] The code is fine but needs lockdep annotation, or maybe
> [   59.011783][    T1] you didn't initialize this object before use?
> [   59.011783][    T1] turning off the locking correctness validator.
> [   59.011783][    T1] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G                T   6.16.0-rc5-00079-gb753522bed0b #1 PREEMPT(voluntary)
> [   59.011783][    T1] Tainted: [T]=RANDSTRUCT
> [   59.011783][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> [   59.011783][    T1] Call Trace:

Pasha, I think your patch [0] fixes this. Perhaps it is a good idea for
it to land independent of the LUO patches, since those are likely to
take some more time?

[0] https://lore.kernel.org/lkml/20250807014442.3829950-2-pasha.tatashin@soleen.com/

> [   59.011783][    T1]  <TASK>
> [ 59.011783][ T1] dump_stack_lvl (lib/dump_stack.c:123) 
> [ 59.011783][ T1] assign_lock_key (kernel/locking/lockdep.c:988) 
> [ 59.011783][ T1] register_lock_class (kernel/locking/lockdep.c:?) 
> [ 59.011783][ T1] __lock_acquire (kernel/locking/lockdep.c:?) 
> [ 59.011783][ T1] lock_acquire (kernel/locking/lockdep.c:5871) 
> [ 59.011783][ T1] ? xa_load_or_alloc (include/linux/xarray.h:699 kernel/kexec_handover.c:106) 
> [ 59.011783][ T1] ? tracer_preempt_off (kernel/trace/trace_irqsoff.c:412) 
> [ 59.011783][ T1] _raw_spin_lock (include/linux/spinlock_api_smp.h:133 kernel/locking/spinlock.c:154) 
> [ 59.011783][ T1] ? xa_load_or_alloc (include/linux/xarray.h:699 kernel/kexec_handover.c:106) 
> [ 59.011783][ T1] xa_load_or_alloc (include/linux/xarray.h:699 kernel/kexec_handover.c:106) 
> [ 59.011783][ T1] __kho_preserve_order (kernel/kexec_handover.c:156) 
> [ 59.011783][ T1] kho_test_init (lib/test_kho.c:84) 
> [ 59.011783][ T1] ? __cfi_kho_test_init (lib/test_kho.c:271) 
> [ 59.011783][ T1] do_one_initcall (init/main.c:1274) 
> [ 59.011783][ T1] ? __cfi_kho_test_init (lib/test_kho.c:271) 
> [ 59.011783][ T1] ? kasan_save_track (arch/x86/include/asm/current.h:25 mm/kasan/common.c:60 mm/kasan/common.c:69) 
> [ 59.011783][ T1] ? kasan_save_track (mm/kasan/common.c:48 mm/kasan/common.c:68) 
> [ 59.011783][ T1] ? __kasan_kmalloc (mm/kasan/common.c:398) 
> [ 59.011783][ T1] ? tracer_hardirqs_off (kernel/trace/trace_irqsoff.c:412) 
> [ 59.011783][ T1] ? do_initcalls (include/linux/slab.h:909 include/linux/slab.h:1039 init/main.c:1345) 
> [ 59.011783][ T1] ? kernel_init_freeable (init/main.c:1588) 
> [ 59.011783][ T1] ? tracer_hardirqs_on (kernel/trace/trace_irqsoff.c:452) 
> [ 59.011783][ T1] ? tracer_hardirqs_off (kernel/trace/trace_irqsoff.c:412) 
> [ 59.011783][ T1] ? tracer_hardirqs_on (kernel/trace/trace_irqsoff.c:452) 
> [ 59.011783][ T1] ? irqentry_exit (kernel/entry/common.c:311) 
> [ 59.011783][ T1] ? next_arg (lib/cmdline.c:273) 
> [ 59.011783][ T1] ? parameq (kernel/params.c:91) 
> [ 59.011783][ T1] ? parse_args (kernel/params.c:?) 
> [ 59.011783][ T1] do_initcall_level (init/main.c:1335) 
> [ 59.011783][ T1] do_initcalls (init/main.c:1349) 
> [ 59.011783][ T1] kernel_init_freeable (init/main.c:1588) 
> [ 59.011783][ T1] ? __cfi_kernel_init (init/main.c:1466) 
> [ 59.011783][ T1] kernel_init (init/main.c:1476) 
> [ 59.011783][ T1] ? __cfi_kernel_init (init/main.c:1466) 
> [ 59.011783][ T1] ret_from_fork (arch/x86/kernel/process.c:154) 
> [ 59.011783][ T1] ? __cfi_kernel_init (init/main.c:1466) 
> [ 59.011783][ T1] ret_from_fork_asm (arch/x86/entry/entry_64.S:255) 
> [   59.011783][    T1]  </TASK>

-- 
Regards,
Pratyush Yadav

