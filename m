Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A496CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 417266B0005; Mon,  1 Sep 2025 09:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1BE6B0007; Mon,  1 Sep 2025 09:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E296D8E0043; Mon,  1 Sep 2025 09:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEC1E8E000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:10:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8EDDD1A07E0
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:10:53 +0000 (UTC)
X-FDA: 83840716386.14.874BEA6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A762110000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:10:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iaoRKEYs;
	spf=pass (imf05.hostedemail.com: domain of devnull+schuster.simon.siemens-energy.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+schuster.simon.siemens-energy.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756732251;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9h85W+fSSI+7uZFmaVzkxnCdkX5mPfS4n/17CJoupQ=;
	b=HgXvVonMM/laWUJPvnidTBYKZztNLeAGxBoL3waoN/X0Omlm0CaV23mJ2d74nysAKpuYjq
	PcR2qpuHwfUQuRwENh/CV/z7dE/AHG0+d4gc6ZresYvXkwjWFUqlgNzJxth7WTI5l+iqvs
	wNdlsODrdr67ZmtIZ2gaWzhuTFYCKYg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iaoRKEYs;
	spf=pass (imf05.hostedemail.com: domain of devnull+schuster.simon.siemens-energy.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+schuster.simon.siemens-energy.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756732251; a=rsa-sha256;
	cv=none;
	b=sMyc1TRgriBHZveNRzp5Mas41hPDQVLqcLcOwGfXK9V8BdnXz49dPKPu4JvSpakv5Qefw5
	Kg3OZImpYFv7wSqJHHEpzRZ9g5Zeb5xaNLjyP6zeMUoIAgAU7UzWjvTUj5sGLx2YGqmSzb
	ccn2sfeeJ9gxTSq9ksHumXRMpBaTZV0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D227D601E3;
	Mon,  1 Sep 2025 13:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45B16C4CEF9;
	Mon,  1 Sep 2025 13:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756732249;
	bh=GpW3AHZfYEj2qBnLMRG4myPQbSyXtECqk6ttoxpv2os=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=iaoRKEYseCqQuDc8g1DT9Ylgds2yXTGrRDMFrMWem9akxSs2kSuDZh8RQy7GyhVc0
	 DgRW0DslNS/vaFDraU32r0MjYx+fOSj7uoPNFHlkuuXYvgF1l43svB/w5612yBF+xJ
	 25fgVdHp0mlGc/VdDsfBP4qIyALFA7BKLsJbQ73ickI5yAaCdxOpDZAB0XQL8T8L5F
	 dx5EwoZS2e25GQhGK0HQZUzgv2mCfV/qUx5aQ/SatgfyRijgLuYK357zFCmZazIp6+
	 A+uvFfZ+PHpkq8v4BfU9r2WTm7F1rYTj29lF0zZTwKApQf/GIGwsNmiQOBYAXmaqwU
	 H9oLgllzFmmaQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2517ACA1005;
	Mon,  1 Sep 2025 13:10:49 +0000 (UTC)
From: Simon Schuster via B4 Relay <devnull+schuster.simon.siemens-energy.com@kernel.org>
Date: Mon, 01 Sep 2025 15:09:50 +0200
Subject: [PATCH v2 1/4] copy_sighand: Handle architectures where
 sizeof(unsigned long) < sizeof(u64)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-nios2-implement-clone3-v2-1-53fcf5577d57@siemens-energy.com>
References: <20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com>
In-Reply-To: <20250901-nios2-implement-clone3-v2-0-53fcf5577d57@siemens-energy.com>
To: Dinh Nguyen <dinguyen@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 Kees Cook <kees@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Guo Ren <guoren@kernel.org>, 
 Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Ondrej Mosnacek <omosnace@redhat.com>, 
 Kentaro Takeda <takedakn@nttdata.co.jp>, 
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, 
 Richard Henderson <richard.henderson@linaro.org>, 
 Matt Turner <mattst88@gmail.com>, Vineet Gupta <vgupta@kernel.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Brian Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 WANG Xuerui <kernel@xen0n.name>, Geert Uytterhoeven <geert@linux-m68k.org>, 
 Michal Simek <monstr@monstr.eu>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 Andreas Larsson <andreas@gaisler.com>, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Chris Zankel <chris@zankel.net>, 
 Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-csky@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com, 
 selinux@vger.kernel.org, linux-alpha@vger.kernel.org, 
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev, 
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-um@lists.infradead.org, 
 Simon Schuster <schuster.simon@siemens-energy.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3-dev-2ce6c
X-Developer-Signature: v=1; a=ed25519-sha256; t=1756732247; l=1758;
 i=schuster.simon@siemens-energy.com; s=20250818;
 h=from:subject:message-id;
 bh=jiicr5q6EjOw72QZuuzAVeCE1iVdBx6rJ537Y02m/X4=;
 b=n8Guw0NV6Suno8Y591Jo1ssUzIYYJXAn95WjDsM26gTG4Diqo4wBaGcjduFDj4CyxOi+UP+1Q
 bc9vUqGSvG9BfaNZEbUUprgB/BwuM16c7iW1ZlIRYBMLPMmyTCfDYFP
X-Developer-Key: i=schuster.simon@siemens-energy.com; a=ed25519;
 pk=PUhOMiSp43aSeRE1H41KApxYOluamBFFiMfKlBjocvo=
X-Endpoint-Received: by B4 Relay for
 schuster.simon@siemens-energy.com/20250818 with auth_id=495
X-Original-From: Simon Schuster <schuster.simon@siemens-energy.com>
Reply-To: schuster.simon@siemens-energy.com
X-Rspamd-Queue-Id: A762110000C
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: yef5pyfpris37u3rtz5qgfxdjj43n381
X-HE-Tag: 1756732251-909326
X-HE-Meta: U2FsdGVkX1/lae9WGghkp99WaZGRtAsi3EDgOrHnzjx0ZWU5g1ml2K+BI8WyZtSM9S+dhDrTZA/rYCoE1ULO3YVNFHxZqTgV+lKxDo0Ayt8NNEkjrqztPrcU4APfhysLs0jhSSwK0RnaJ/LzQXJIUo8hA6XqM9F/hEgt+n+Sk0mUU0x2Im5ybKmW2OT0rv5fAkuRxXYrt3SgotYGqz7fFbG00HUmpvoKgfw4Uy4EQeyy8WI+usy86VedbQAmKd4mCJ62wxweT9y//EceEQzy672XeeqjVupeRrQKfLefj8N0WvKNZD7Vg5kkPI5SdXQQgvmS8LZtzc7oP2OXrRFFERTZv8z1aCk+8NH8iGO6DJYH6pQ+JJ6ijLIScE66AkzjYQeM+HUYjFtx4r7NjxqdB2xfKE+EMJCtWtkTVIqubOp8ByKTr29My/YPTkjyhXHKUFJYyLOYDlKtvQqJr7BVOFDn3plXZqywULLvxf5GJc1mOkPXUbzlJAhHrlVrB+zF5YL5Mr27dFuuN/E71lTBy5Ou0TpPlaGhdXJQYykCJiAxCFkW2nyzHR+0Q7NVzMBoXiqU4xuMiX3mDlUS0qu9A6mcqOVNJlBJLikk3MPaIqCne7l9iTJ7RBlAn1ryQlp8hsB54gvizYW7FI9V/hbIR2cVjKgBQXfpKaJ93pe5yNSuvgMRCMLIeS52dNBwkFGffMnmuh1KdfnUfuaxpXRdVqpSQ4oQRDmRGRmGi0kuiBuwpaqqL6G7nGtqpQThEryzJmBqOnoy2wrC3MbjtSetHkgy2HsEAZP5p0USe4FUyHesdDnKZ+fFPnAUWTKBnoPr6i1ekUe6eitzpMj+XgNQajouBr7Q6CpprSc11hkNnuS6kfH8zmopAGa0UNJK7ydn4wGyGcw5TixoyutixjG/W/YSywfl92f7wc51TByHJSmr85BVk4xrDrfEsMNIlc9ruxzq45gNiY3qb41mHJi
 6pNtSnzA
 FZBoiXq7R+EVEqgtwuPBtHJdD0nN6LD2w4wGdNWnzZdcommUaQBGkBs/rLEs8oFDBSAhenb028xM1lTTvtznTHoGRIQ+6C5Q/73pk9OscWhp8xLG/wJeAWFSxEB4ppqlfUalmvpagkSVPyumnWpPAp64c6VlOoVkkXlWKfsvmPtSvhTaypmkwqPU9CFLRVwiUstt6ssnwoL4fgiKVmLrKtFYkg67vqeUYSLrcbHZgQvr2i3FbVVND1Pdk5EHcRr0wRdO2smzTrNH/z3VZuV0EYORGFV47oSW1HPTQU1Yd3gsZQGFEMZaE498ijugLCiWi0c3lhZnNbkqAiqk9pm2wtSq1eTnWAqOR+sdEEpGZEttsu4snRMKrCvstbHqjHhka2Oy2LcFuIjPbhTfMclrTvabtXKmuE+OjMTr30XoSEUUVsQ9k36s6ea6UxbQyRGbTV3WgtnvA2V3YdESH9dnJss0ALQXZF4gUCNCAQNqCP4sE9zUEy6UcgsRIBN/GBVL8yiR8OVHhz91rjMpiSVfXelpZvNuAS+8kYOgNqAqWbUMist/cscN6Y6FqkEUeU1uIHATA3wOSroO6YAD/4k0q3fLGGNsywjSd2M9ELoNYKm2FXO9yWCKMBbXjwiD/PyyxRWnn9VrPklBM3J8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Simon Schuster <schuster.simon@siemens-energy.com>

With the introduction of clone3 in commit 7f192e3cd316 ("fork: add
clone3") the effective bit width of clone_flags on all architectures was
increased from 32-bit to 64-bit. However, the signature of the copy_*
helper functions (e.g., copy_sighand) used by copy_process was not
adapted.

As such, they truncate the flags on any 32-bit architectures that
supports clone3 (arc, arm, csky, m68k, microblaze, mips32, openrisc,
parisc32, powerpc32, riscv32, x86-32 and xtensa).

For copy_sighand with CLONE_CLEAR_SIGHAND being an actual u64
constant, this triggers an observable bug in kernel selftest
clone3_clear_sighand:

        if (clone_flags & CLONE_CLEAR_SIGHAND)

in function copy_sighand within fork.c will always fail given:

        unsigned long /* == uint32_t */ clone_flags
        #define CLONE_CLEAR_SIGHAND 0x100000000ULL

This commit fixes the bug by always passing clone_flags to copy_sighand
via their declared u64 type, invariant of architecture-dependent integer
sizes.

Fixes: b612e5df4587 ("clone3: add CLONE_CLEAR_SIGHAND")
Cc: stable@vger.kernel.org # linux-5.5+
Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 5115be549234..82f5d52fecf1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1599,7 +1599,7 @@ static int copy_files(unsigned long clone_flags, struct task_struct *tsk,
 	return 0;
 }
 
-static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
+static int copy_sighand(u64 clone_flags, struct task_struct *tsk)
 {
 	struct sighand_struct *sig;
 

-- 
2.39.5



