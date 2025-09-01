Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46432CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBFC28E0052; Mon,  1 Sep 2025 09:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C97938E0008; Mon,  1 Sep 2025 09:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B887C8E0052; Mon,  1 Sep 2025 09:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C7F58E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:40:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 47B0E160864
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:40:56 +0000 (UTC)
X-FDA: 83840792112.09.0B56D6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9BE0D100005
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:40:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XWheIfvn;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756734054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5TIV1/bWJm+Qdj5NhVna0mevEXItOlds/WeSsTqphfE=;
	b=XC92biSPlPQfgIOpAeQWx9MOiVk4zpN2xemc6xj2iwYiGRp2M0aohnsARqCUtB1N2I5MqR
	x7afbbrTYPd2lpVVib9IOlcSgCZtrz4xFrGwIozp3J+6b4gqWIw1zB44+8MMVjkMbzEPJp
	l2JYrnIhRGA1SUpCUhjvRCKack+ASu8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756734054; a=rsa-sha256;
	cv=none;
	b=q9ESV1MRaF5LlvouISnfAVM3km170XScFduMpIIq36nzVv50ZD8HJfp++XqGT40kAmnPF8
	FOcwmrveBznKn5k2Bp19Ys04M2PvK78rwB2wpqytbWisczazYQGjpw4oYcQCkjjxkcvDC1
	nYQBq6PB/CwiXUbNA/m6X6zfD6xZN2A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XWheIfvn;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3AE78433F7;
	Mon,  1 Sep 2025 13:40:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C596BC4CEF0;
	Mon,  1 Sep 2025 13:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756734053;
	bh=Vu1T9oeflFwwseH4UwYLoCDw2rg5tyF7d+uoYsIwX14=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XWheIfvndLQvsXjP9U9awyBD8J03c71fo0eZYwRkAVaSegGnB6M8yAG84hKFTZ6pZ
	 WXUaILTjS2ome/lQZpmjWti4uXFiuyVUrpb9MBiadk9IDgWiqsTu18BgRH0di+kN+h
	 LhDkQjUzZNb6xENCZSOEF3wUqwM8kDc47n+sPCWgnRb4uQtSbYTCcKsSPLQDxajL6l
	 8PCIX1xJqXAxtHfu/yVArx49jdplr7KtB0xl0XPUm7rKpZaxJekitWoIygF9KUi4LH
	 2uqg/WgQVetTvdXYGzfVDRG1BiHpS1CgspIql52DpnP1dj2X6wrwoCXbq5RLo6BYf+
	 T+aIQ2gltLbOg==
Date: Mon, 1 Sep 2025 15:40:26 +0200
From: Christian Brauner <brauner@kernel.org>
To: schuster.simon@siemens-energy.com
Cc: Dinh Nguyen <dinguyen@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Kees Cook <kees@kernel.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Guo Ren <guoren@kernel.org>, 
	Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Masami Hiramatsu <mhiramat@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, John Johansen <john.johansen@canonical.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, 
	Richard Henderson <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>, 
	Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Brian Cain <bcain@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Michal Simek <monstr@monstr.eu>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Jonas Bonn <jonas@southpole.se>, 
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, Stafford Horne <shorne@gmail.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	Andreas Larsson <andreas@gaisler.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chris Zankel <chris@zankel.net>, 
	Max Filippov <jcmvbkbc@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-csky@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	apparmor@lists.ubuntu.com, selinux@vger.kernel.org, linux-alpha@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 0/4] nios2: Add architecture support for clone3
Message-ID: <20250901-lammfell-kaninchen-c160a69e6b36@brauner>
References: <20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9BE0D100005
X-Stat-Signature: ptcjcc9tpmbqtufu3jodqid4npd4a1ju
X-Rspam-User: 
X-HE-Tag: 1756734054-448456
X-HE-Meta: U2FsdGVkX19ScgnoZGPk3ztDxBNisczpfxEZhzaJDgADlzkgLAWrKjEyXDzpfFacKgp/xYSb8JjlUeYc14VAVcQS9t59u3i3CBMJFIUHgZvlm529I1MBIVadsCsyIjX+nHjZpPvDWv70oHYsOheQ0YyaULfDcWZrPP6jLksDMVr+Pp49EK93yHlmTCqdEmiS3RXw9mLkEpXHJTq0b8lu+2Xfhv/GEu3vcK1/8tdtofuIIb7q8Jhpb/CPR3LQrFoXxGfofxT5DEEmeVrVD/jmnnhhY+U5F7d0bW7DXDCupmDbNdQ5I3sx7lgqMaY2fQYjVk/M+pmLEyC+msluw0vrOJQRGFZrNhATRJLgyycpiv11ETq833fCjE8U2+rcREu+9CYZWZNpOSlcglHxJzyfMo2MUzAF9GtYiIE3oxBv56jo8e6sdh7/gJwmU7dknANjSBy5n9t8XjQcibFCxPLQdAn3s5gCXYcJx1vFOmynRTYW6WoR+14CcGXz4h8Ox5cFnr4sb8beCPrevDLmCSl79RjbsBqIQbLlQu+/WG/XFxrrDLplvksXFR+5ytkd63UE+ZiVnIDZh6mdk3kk9WVW2tja/WKjLjN1oiVh0pAjhx8GjJSdCg8fR02J/nDavIXaSw0fOVTLG0Oxck7e2ARPVZQmbpagakJddI8SjvieCgAFJ87ZAVmQpYfrDt2yYvIMGHXPWcjtEvHwTirnHSOUmwCGF6KO0K+GG1b/G60rEYFlDG5ZI8w6NMILgtjFdIHAtCf1gh0cml7jx1WcWj9ZQ9c98EaWexSn0MaIVTjhuILiB90KFmt6hMOtamGUqJzgNT2fC5MSDqy5GIrW6vRpCNkcwLr/PHHDO7956AbuXn8C/Xm0MqsaO0KG1xA4Sy+H4BzRn23UiNOIwiorsf8gYkQ4H6NyYNE4Tg2wsYzDVqmqG6amcw6XjVT7PQ34q/mJNrO2xJb8s3QEc1OJDYQ
 1USf4+S2
 TPwNs88/Xxl6WvgcW0wyi/UH7vxYwU/m15Eep7QiwpU8RulHdKvUi2CFp5BjK0yptxjs8TW/7WX+F1gRTsAFhqKxIIXYCedlzVt611y+MNUgJXlg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 03:09:49PM +0200, Simon Schuster via B4 Relay wrote:
> This series adds support for the clone3 system call to the nios2
> architecture. This addresses the build-time warning "warning: clone3()

I did not expect that to happen or matter but fine.

> entry point is missing, please fix" introduced in 505d66d1abfb9
> ("clone3: drop __ARCH_WANT_SYS_CLONE3 macro"). The implementation passes
> the relevant clone3 tests of kselftest when applied on top of
> next-20250815:
> 
> 	./run_kselftest.sh
> 	TAP version 13
> 	1..4
> 	# selftests: clone3: clone3
> 	ok 1 selftests: clone3: clone3
> 	# selftests: clone3: clone3_clear_sighand
> 	ok 2 selftests: clone3: clone3_clear_sighand
> 	# selftests: clone3: clone3_set_tid
> 	ok 3 selftests: clone3: clone3_set_tid
> 	# selftests: clone3: clone3_cap_checkpoint_restore
> 	ok 4 selftests: clone3: clone3_cap_checkpoint_restore
> 
> The series also includes a small patch to kernel/fork.c that ensures
> that clone_flags are passed correctly on architectures where unsigned
> long is insufficient to store the u64 clone_flags. It is marked as a fix
> for stable backporting.
> 
> As requested, in v2, this series now further tries to correct this type
> error throughout the whole code base. Thus, it now touches a larger
> number of subsystems and all architectures.

I've reworked copy_thread()/copy_thread_tls() a few years ago but I
don't remember why I didn't switch to a u64 for them. Probably because
only CLONE_VM and CLONE_SETTLS mattered. Thanks for doing that.

> Therefore, another test was performed for ARCH=x86_64 (as a
> representative for 64-bit architectures). Here, the series builds cleanly
> without warnings on defconfig with CONFIG_SECURITY_APPARMOR=y and
> CONFIG_SECURITY_TOMOYO=y (to compile-check the LSM-related changes).
> The build further successfully passes testing/selftests/clone3 (with the
> patch from 20241105062948.1037011-1-zhouyuhang1010@163.com to prepare
> clone3_cap_checkpoint_restore for compatibility with the newer libcap
> version on my system).
> 
> Is there any option to further preflight check this patch series via
> lkp/KernelCI/etc. for a broader test across architectures, or is this
> degree of testing sufficient to eventually get the series merged?
> 
> N.B.: The series is not checkpatch clean right now:
>  - include/linux/cred.h, include/linux/mnt_namespace.h:
>    function definition arguments without identifier name
>  - include/trace/events/task.h:
>    space prohibited after that open parenthesis
> 
> I did not fix these warnings to keep my changes minimal and reviewable,
> as the issues persist throughout the files and they were not introduced
> by me; I only followed the existing code style and just replaced the
> types. If desired, I'd be happy to make the changes in a potential v3,
> though.
> 
> Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>
> ---
> Changes in v2:
> - Introduce "Fixes:" and "Cc: stable@vger.kernel.org" where necessary
> - Factor out "Fixes:" when adapting the datatype of clone_flags for
>   easier backports
> - Fix additional instances where `unsigned long` clone_flags is used
> - Reword commit message to make it clearer that any 32-bit arch is
>   affected by this bug
> - Link to v1: https://lore.kernel.org/r/20250821-nios2-implement-clone3-v1-0-1bb24017376a@siemens-energy.com
> 
> ---
> Simon Schuster (4):
>       copy_sighand: Handle architectures where sizeof(unsigned long) < sizeof(u64)
>       copy_process: pass clone_flags as u64 across calltree
>       arch: copy_thread: pass clone_flags as u64
>       nios2: implement architecture-specific portion of sys_clone3
> 
>  arch/alpha/kernel/process.c       |  2 +-
>  arch/arc/kernel/process.c         |  2 +-
>  arch/arm/kernel/process.c         |  2 +-
>  arch/arm64/kernel/process.c       |  2 +-
>  arch/csky/kernel/process.c        |  2 +-
>  arch/hexagon/kernel/process.c     |  2 +-
>  arch/loongarch/kernel/process.c   |  2 +-
>  arch/m68k/kernel/process.c        |  2 +-
>  arch/microblaze/kernel/process.c  |  2 +-
>  arch/mips/kernel/process.c        |  2 +-
>  arch/nios2/include/asm/syscalls.h |  1 +
>  arch/nios2/include/asm/unistd.h   |  2 --
>  arch/nios2/kernel/entry.S         |  6 ++++++
>  arch/nios2/kernel/process.c       |  2 +-
>  arch/nios2/kernel/syscall_table.c |  1 +
>  arch/openrisc/kernel/process.c    |  2 +-
>  arch/parisc/kernel/process.c      |  2 +-
>  arch/powerpc/kernel/process.c     |  2 +-
>  arch/riscv/kernel/process.c       |  2 +-
>  arch/s390/kernel/process.c        |  2 +-
>  arch/sh/kernel/process_32.c       |  2 +-
>  arch/sparc/kernel/process_32.c    |  2 +-
>  arch/sparc/kernel/process_64.c    |  2 +-
>  arch/um/kernel/process.c          |  2 +-
>  arch/x86/include/asm/fpu/sched.h  |  2 +-
>  arch/x86/include/asm/shstk.h      |  4 ++--
>  arch/x86/kernel/fpu/core.c        |  2 +-
>  arch/x86/kernel/process.c         |  2 +-
>  arch/x86/kernel/shstk.c           |  2 +-
>  arch/xtensa/kernel/process.c      |  2 +-
>  block/blk-ioc.c                   |  2 +-
>  fs/namespace.c                    |  2 +-
>  include/linux/cgroup.h            |  4 ++--
>  include/linux/cred.h              |  2 +-
>  include/linux/iocontext.h         |  6 +++---
>  include/linux/ipc_namespace.h     |  4 ++--
>  include/linux/lsm_hook_defs.h     |  2 +-
>  include/linux/mnt_namespace.h     |  2 +-
>  include/linux/nsproxy.h           |  2 +-
>  include/linux/pid_namespace.h     |  4 ++--
>  include/linux/rseq.h              |  4 ++--
>  include/linux/sched/task.h        |  2 +-
>  include/linux/security.h          |  4 ++--
>  include/linux/sem.h               |  4 ++--
>  include/linux/time_namespace.h    |  4 ++--
>  include/linux/uprobes.h           |  4 ++--
>  include/linux/user_events.h       |  4 ++--
>  include/linux/utsname.h           |  4 ++--
>  include/net/net_namespace.h       |  4 ++--
>  include/trace/events/task.h       |  6 +++---
>  ipc/namespace.c                   |  2 +-
>  ipc/sem.c                         |  2 +-
>  kernel/cgroup/namespace.c         |  2 +-
>  kernel/cred.c                     |  2 +-
>  kernel/events/uprobes.c           |  2 +-
>  kernel/fork.c                     | 10 +++++-----
>  kernel/nsproxy.c                  |  4 ++--
>  kernel/pid_namespace.c            |  2 +-
>  kernel/sched/core.c               |  4 ++--
>  kernel/sched/fair.c               |  2 +-
>  kernel/sched/sched.h              |  4 ++--
>  kernel/time/namespace.c           |  2 +-
>  kernel/utsname.c                  |  2 +-
>  net/core/net_namespace.c          |  2 +-
>  security/apparmor/lsm.c           |  2 +-
>  security/security.c               |  2 +-
>  security/selinux/hooks.c          |  2 +-
>  security/tomoyo/tomoyo.c          |  2 +-
>  68 files changed, 95 insertions(+), 89 deletions(-)
> ---
> base-commit: 1357b2649c026b51353c84ddd32bc963e8999603
> change-id: 20250818-nios2-implement-clone3-7f252c20860b
> 
> Best regards,
> -- 
> Simon Schuster <schuster.simon@siemens-energy.com>
> 
> 

