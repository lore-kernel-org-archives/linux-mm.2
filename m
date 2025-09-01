Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A0CDCA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793588E0054; Mon,  1 Sep 2025 09:42:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A818E0008; Mon,  1 Sep 2025 09:42:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6599C8E0054; Mon,  1 Sep 2025 09:42:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 43BE38E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:42:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 126C5C04E1
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:42:32 +0000 (UTC)
X-FDA: 83840796144.15.83812F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 56EB580009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:42:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hhAgv3jy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756734150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D06UuwjAYlV6l7iTncZwN2SfO36CQk7GREFp9cWnrbY=;
	b=SuM86CLIIUCyHtSV1qNgSF/tBwS0an0/oiHjrccrWL8o6MvWJ4hSaWSxc5TeCiOqWAl2FC
	fuWuN3CRIiXbVSy606ZAnmhB3KiiDM9U6xAACJWFP2uI9feHfy+oc/assEfWIiaF/VUTDs
	N++WAVQjs/afFzNI3wq+p86UTqLHZO0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hhAgv3jy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756734150; a=rsa-sha256;
	cv=none;
	b=P9MeL4Blyxh55xMNiK6Y7qMvirpV5fiGb5QFUZ0ihvm1BuZJy6W0Zl98R6GsUB5i480KRj
	1+FBCVAkFCPu/a6u9Gcbo0v4FNw3N4B10Gn/Qnt5QuZGwDSoFTwScjt815ZWgfZGcdGMXI
	MOa1o8CPozzUCXNvXua+Gg0AFG0nDgI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A5FB7601DD;
	Mon,  1 Sep 2025 13:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2A3C4CEF0;
	Mon,  1 Sep 2025 13:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756734149;
	bh=Vh7XUBI8fbBk4XZ8pKOtZH1UfNJDpJTXo419bu2F3VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hhAgv3jysX69gBwri906yWypXEK80NcNcU75ZV9/QeXQCy7l2f36k4byfNVTER6IP
	 gOpTcCFplnwo778jgs8p6iIv5w82lNMr1NdsMRGJMrKmcMxP4YY2DKw+dekKbGSucF
	 fH1UC9E5PgUSkFcL53l8SZJBBuh5k12ZnrsQltX79STLRHqZnRwbCiiL2r1trnqoDx
	 puTp0teu7LJmcMXEaHizKLVFBrc6SbxJk1xEnU8p4L+3jrFGOH2GOvXFX8s+j/Uzcc
	 iESOxfINPv0beoEDy4YTocStDSjRMNPUi5KjJ3O7gh5nCTPwxK3fbka9qE414MrABB
	 Q6ziiIx0FS2KA==
From: Christian Brauner <brauner@kernel.org>
To: Simon Schuster <schuster.simon@siemens-energy.com>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	apparmor@lists.ubuntu.com,
	selinux@vger.kernel.org,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	stable@vger.kernel.org,
	Dinh Nguyen <dinguyen@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Guo Ren <guoren@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	John Johansen <john.johansen@canonical.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Vineet Gupta <vgupta@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Brian Cain <bcain@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Michal Simek <monstr@monstr.eu>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH v2 0/4] nios2: Add architecture support for clone3
Date: Mon,  1 Sep 2025 15:41:21 +0200
Message-ID: <20250901-sauer-stunk-49def0170f7d@brauner>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com>
References: <20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1648; i=brauner@kernel.org; h=from:subject:message-id; bh=Vh7XUBI8fbBk4XZ8pKOtZH1UfNJDpJTXo419bu2F3VE=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRsXbQgjNu70HTe/oL9c9q1am5UpWv3Rf4/axBS2d225 DLTetc9HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNJDGb4796daOqUVCMcef3h SZ6HDAFLrq8xmcSxzTOQKT+CvTO3n+G/d83ztvwDXH+ZHPU+vLlcvOafQ5/X9C+bSnabHoy/7bC TBwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 56EB580009
X-Stat-Signature: xeh3czw48e89qwgtgnp5gkg9kcqmt1p6
X-Rspam-User: 
X-HE-Tag: 1756734150-52756
X-HE-Meta: U2FsdGVkX1+B+N/7aW5DYvpK0pCVs8so6DMJ/nvUfUOmkjfX48wQarP11GtvHAsV9e0+5GPD6eNyV1lUEfV6l2xZLYwTaCh9CDf8th+6cwJU4kQOksw3gOOkISrxwYMYYDrisieUItkEl6tkY7drIGKzxJJsmXlPCwx4yIcaFPc7EyGQ8mYKC7W71aOZY9vy3ZGDvLaQQOhUw/fYfCA3sCDPc4qL1os84YrWXxZIB8I0TdxSK6jXbMKcNVJPUG8Wp1r7cjm92AZraMWJ74U0d9XuSz/7qeovxcplheDL5CrflakLm0aM/FMBU9P8zOjB4FvocF22QCJAmrmFH+3jPQsCqDPaAWfRAZMWb567d5ozb96Y2sZFR6Qs4BLg6e/aOSS9BqkCC5OY1B5oBm/InVTku2Lre6C5m0KZsPtkymPfo8LwzP3NlOWihulGDi9yn5ueh7FV1fsvv/BsVTUj7gTLcb1V+tndR0uZ0n2KweNdSOsIVu/NIbnm722Re/0G9aqS6D+1S5of16rTCxk3QHaObRbr2JM7n0FV36ChW9EwYvC0OwQfYsQrNWm7CPhE/IasKgaJQpkb7w29fqjYiDgyzRYAE8UfNm5ZBT0QCxfbO/9o8XOr9zH7td8/aGDjY8B4dNOwRS855lqjVBvAyRY80/eQUHccSPiTMhLkr9DxujFx1Tyg5QRdD4MmESV00QO8d3neuuhbMv1kbqyr4srSnTdXvbGDlKc3D2Uy8WvQFE35RhFle6xR83VAj164B3rdv7NKm66u4kB6dMZ53Yy/j7fJ6MxCY6owrpQb4XCbSukSJUj31H7QOVYBwawZSMXH5XBQaIiZhpVUIePuFTQVLSBZ+F7RSmecwcphLcurCsD9r9a7agYgwUM0/uqfXp8doyyLrr7RYhb4+w1QcXycC2L609M7JKjTPPA8UlCQ2dtL1HHmae75vycierMfhSzldKXOVFxjfzi95Uo
 82H6Dr7x
 ymeSDhv8F28XP52XRtybVBMZlLuUb2XcWD+osHaTToKc4XHzHg2w5qE62GSo8WHfSXPrqoIaXRV/M2wk5WPXIX/RUJHBmcZTGQiv00yqF7umASkXfpAnxqTxAUNh7CaUCFEasx3xFhogAmT2DTD0kJ+0gS9ZLLaiLq8aH91RskJkBPTLTcfjC/oQ2UITLLbnavIYjcyR8wLLlSGaifaUal8WZ7N2tmb2cTRuM6TbFB5zMUPFkkNwqO2uZ6mnvdnuRljZSxothEJG3JYgNZ1K6/qYxUaWZPrhPIuwVEXo3QAzy9eMc5usWa8Yv3qQT+M03XWRhJz3MDtL342B6XF5AggKgJYfGxcjoAasI5KbDok/m2uY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 01 Sep 2025 15:09:49 +0200, Simon Schuster wrote:
> This series adds support for the clone3 system call to the nios2
> architecture. This addresses the build-time warning "warning: clone3()
> entry point is missing, please fix" introduced in 505d66d1abfb9
> ("clone3: drop __ARCH_WANT_SYS_CLONE3 macro"). The implementation passes
> the relevant clone3 tests of kselftest when applied on top of
> next-20250815:
> 
> [...]

Seems fine to me. Thanks for fixing this.

---

Applied to the kernel-6.18.clone3 branch of the vfs/vfs.git tree.
Patches in the kernel-6.18.clone3 branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: kernel-6.18.clone3

[1/4] copy_sighand: Handle architectures where sizeof(unsigned long) < sizeof(u64)
      https://git.kernel.org/vfs/vfs/c/04ff48239f46
[2/4] copy_process: pass clone_flags as u64 across calltree
      https://git.kernel.org/vfs/vfs/c/5b38576cb8d3
[3/4] arch: copy_thread: pass clone_flags as u64
      https://git.kernel.org/vfs/vfs/c/04e760acd97f
[4/4] nios2: implement architecture-specific portion of sys_clone3
      https://git.kernel.org/vfs/vfs/c/d7109d2a2358

