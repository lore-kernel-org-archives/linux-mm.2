Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C092FD9E29
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 01:12:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65C426B014C; Thu, 26 Feb 2026 20:12:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62D0A6B018E; Thu, 26 Feb 2026 20:12:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 502A06B0191; Thu, 26 Feb 2026 20:12:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 353896B014C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:12:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DBF4C1B7392
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:12:14 +0000 (UTC)
X-FDA: 84488460588.02.4D0C4C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 35D09C000B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:12:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KoJ8+tCq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772154733; a=rsa-sha256;
	cv=none;
	b=Jk9rv9fXpn28qA5wCyIn7gzpu4HbB+Ppv1bI4yEXmARgTGgEqYCVMdrM/dOMr8pSEaHGjt
	w0c3fOb/ptor0Hu0l7XwZzSESO0iezD1yx3RFPR9p2D0pkzHPPNPXuice66T+/fWcPLkTR
	fwf71qGBm116XI3U0AufCw0WUEiIPCc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KoJ8+tCq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772154733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F7xcG82KoCzVf+ILAQLPvwcDvKWxBJ8HrfV1mMDBZow=;
	b=TC4C9qfb6kYv6yVTr9korc9J3F7qn5j5Ns0A1BnWaW15WTEGUm3aSxPcnzLwjUVGnN0/PM
	L5z0hq75aecWpQUu8NKHXbvOT4zSD8o9BPj1XssbSRn0CrXIAu9JUdnKKMkl28YOeKnRHD
	CWb6orUjlZPqUqPUeXDRhuXmn0nCONk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B4E040A01;
	Fri, 27 Feb 2026 01:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9074EC116C6;
	Fri, 27 Feb 2026 01:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772154732;
	bh=toaYxiPZ/lCeBM7C8uOMFWILyi4ngU7RTn1w2G8GD5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KoJ8+tCqPmwPW2nqtGZARcr0hjJVC/K5l9WBoZd+sqMpYELts0SvdJ6gtiDYPzAgz
	 OQ/CcOVyraLKD0E3KIdka1B8z5QrL8zcn8u2QaGrs8vzS/C8opOdfGi3T3yStQloTv
	 +ZTXamB6IlPyZo/YDSl6DdvljAwHRWiyTJ+XNX7Xz4qlFUNJBfyV719DCt2RZjJJgW
	 cKTOhCQCbPzohQxVEb3L+aD56RDxTv6YR2MQMdS9mlx3hS4YQtU3lKLGFHq5hwHpeZ
	 uO1bb/xOgHTqADagudFMUPAK+NpI74MLlpRy39MCk4aJoo9835DfH0viTRBwtxmNQp
	 KF2Ze1ivOMkiw==
Date: Thu, 26 Feb 2026 18:12:01 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Heiko Carstens <hca@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH v17 0/3] Improve proc RSS accuracy
Message-ID: <20260227011201.GA1577380@ax162>
References: <20260217161006.1105611-1-mathieu.desnoyers@efficios.com>
 <20260226120422.8101Cc2-hca@linux.ibm.com>
 <59b28cb4-4fff-4888-b562-7b7236e29d27@efficios.com>
 <e0af317a-d6ad-4de4-8bb1-215d5dce7351@efficios.com>
 <73e6fea9-caf2-4404-b511-11646013f8db@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73e6fea9-caf2-4404-b511-11646013f8db@efficios.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 35D09C000B
X-Stat-Signature: 8iqho5asx4ph1z9hyb481r5ug47eq1c1
X-HE-Tag: 1772154733-336407
X-HE-Meta: U2FsdGVkX1/PU7SFuTCYFBKi1PkZeWxEG6Z3WEg1TVaDyq4kvLl4ri2npgI0svJNhqIXsyK9qpSIq7XrBObt7+TB8Nul5PVh9jNI5wfhTH7t28DuEFlp020IrZrEZY75DWWj6MXQIAUyebHzz/SeHw/bEiuSkprQDW/GNxYefljWqh7hS/rXJ2jXQcjZt9mjTEXd4sUczTvxYQPHNbsLUvfLUy/+l2Y36p49qfrT0ccwWG1X+Gle1GsyEyAhYBb4TLSQqmYdiLsh0wKRvK1t9lrETn2+Rs1AV/m68A3qMr+gl1YvsQfAeRd8d9TFLwYm0vxPUXhf59tmC6jPebZXPoiKMm99xEm0fkviWY5gN0iTdtE8Mn35Ni9zOe9zUjA/TXrvJ/9F7q8/rD0Zi/HJ2wMZqdlxf/aV4Ls3tm//QXoBe4/hgX1D2i6OezDTkHl1CJxfX8nmUIbQwF1iJVpCZ+KsqVIOMyMr1WDlT1Y0tBj/frCnPuc03BJlfvn8Fw7/nQ3zyyvzSKf47MOkt1oPcA+/Td5wp9n6vAQndu4+T5lOH/RCrCWsoJzn8nCl2VnhGDwT32+0K8zO8rEG6A7bBAO3noiAi7HcPyeDdBqrqWp6hmJf22o6P5vGNzRnocuNZiFXxKKJe1PwX9O0n+SSfxx7lIMzasgJg+XGCVOaWO6sMjyPI46RG/yCsn+Dfkc0NdZK/fCK66NqAhwlRDtjMqNcrIiRdV8SkWHLf3cT9VRDyvJXMWrly+w2pdQoVfHLqX53nz6f6sl1EhxjQ1Zoz3CrqLMY+3igItcFXA/cXwpHx7ahmj64RYeGKEzYt5LBXfVRr+jtrDYK0AiOPzHjjQx0+D11Na5CwUzJpgsPyj8JswaTzwEU1iDgx9uLNUaSjK7Iu87oDbrob9gXrD9KM01RCmwha551Ws8dJS08rX5ZXZJCz7sZ9UE8fdwN53p39nSTdWRtAdtdFf1wKg5
 iLhbPdg3
 HdEW7RyW4oKRY7AYmQE5KFoQDzKAaObTuzSedNJO3n1gh/ZCCUrZ6H9NJQb61W6H6c0r9QSQnm6p/xR0S0WHa3erSjUecP35EsTQ4fD9gapRG49UkcO4sVtGTztuek5aVAu9t3GL5ORR7KV7n3gsmiJguaogV4HHXp25B8r74MNXPaFK+2QU98TaI5FVtggSMOElQGBQaWbglnUBicD/3ILOi19ZDzfwfi+W01SygM88heDuR/c5wtF+y8MthXMY2E3S2FfpNB4El2hMGranbGg0P4P3nXBtDB592JfJnSGF/Xh7RuA7noI89YysIIrxmT1V3YMN6gdJpt0Att0NDLI9y8lksLi5k9BsuGJW1AlZ60Ozlws9BMhE8VIU176gBQ1Jd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mathieu,

On Thu, Feb 26, 2026 at 02:38:04PM -0500, Mathieu Desnoyers wrote:
> I've successfully booted a defconfig s390x next-20260226 kernel in qemu
> with 1 and 4 CPUs, and within a nested s390x VM on 2 cpus.
> 
> I guess I'll really need more info about your specific .config and
> command line args to help further.

FWIW, the ClangBuiltLinux CI sees a boot failure with sparc64_defconfig,
which does not appear to be clang specific. I can reproduce it here
with:

  $ make -skj"$(nproc)" ARCH=sparc CROSS_COMPILE=sparc64-linux- mrproper sparc64_defconfig image

  $ curl -LSs https://github.com/ClangBuiltLinux/boot-utils/releases/download/20241120-044434/sparc64-rootfs.cpio.zst | zstd -d >rootfs.cpio

  $ qemu-system-sparc64 \
      -display none \
      -nodefaults \
      -M sun4u \
      -cpu 'TI UltraSparc IIi' \
      -append console=ttyS0 \
      -kernel arch/sparc/boot/image \
      -initrd rootfs.cpio \
      -m 1G \
      -serial mon:stdio
  ...
  [    0.001502] Linux version 7.0.0-rc1+ (nathan@framework-amd-ryzen-maxplus-395) (sparc64-linux-gcc (GCC) 15.2.0, GNU ld (GNU Binutils) 2.45) #1 SMP Thu Feb 26 18:00:08 MST 2026
  ...
  [    1.339282] Run /init as init process
  [    1.340037] Unable to handle kernel NULL pointer dereference
  [    1.340515] tsk->{mm,active_mm}->context = 0000000000000000
  [    1.340684] tsk->{mm,active_mm}->pgd = fffff80000402000
  [    1.340838]               \|/ ____ \|/
  [    1.340838]               "@'/ .. \`@"
  [    1.340838]               /_| \__/ |_\
  [    1.340838]                  \__U_/
  [    1.341260] swapper/0(1): Oops [#1]
  [    1.341575] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 7.0.0-rc1+ #1 VOLUNTARY
  [    1.341937] TSTATE: 0000004411001606 TPC: 0000000000465674 TNPC: 0000000000465678 Y: 00000021    Not tainted
  [    1.342199] TPC: <init_new_context+0x14/0xc0>
  [    1.342584] g0: 0000000000000000 g1: 0000000000000000 g2: 0000000000000000 g3: 0000000000000000
  [    1.342815] g4: fffff80004170000 g5: fffff8003e1d2000 g6: fffff80004134000 g7: fffff8003f814598
  [    1.343047] o0: fffff8000479c0a0 o1: 0000000000000000 o2: 0000000000002000 o3: 0000000000000000
  [    1.343276] o4: fffff80004621200 o5: fffff80004006e00 sp: fffff80004137331 ret_pc: 000000000062a520
  [    1.343513] RPC: <kmem_cache_alloc_noprof+0x1c0/0x560>
  [    1.343681] l0: ffffffffffffffff l1: 0000000000000000 l2: 0000000000000001 l3: 0000000000000000
  [    1.343917] l4: 000000004fd6805e l5: 0000000001503c00 l6: 0000000001423800 l7: 0000000000000012
  [    1.344144] i0: fffff80004170000 i1: fffff8000479c0a0 i2: 0000000000472030 i3: 000000000180ac00
  [    1.344371] i4: 0000000000000000 i5: fffff8000400b500 i6: fffff800041373e1 i7: 0000000000472044
  [    1.344601] I7: <mm_init.isra.0+0x144/0x1e0>
  [    1.344751] Call Trace:
  [    1.344871] [<0000000000472044>] mm_init.isra.0+0x144/0x1e0
  [    1.345054] [<00000000006602ec>] alloc_bprm+0xcc/0x1e0
  [    1.345195] [<0000000000660e6c>] kernel_execve+0x2c/0x1c0
  [    1.345345] [<0000000000be4060>] kernel_init+0x70/0x128
  [    1.345496] [<00000000004060f0>] ret_from_fork+0x24/0x34
  [    1.345652] [<0000000000000000>] 0x0
  [    1.345823] Disabling lock debugging due to kernel taint
  [    1.346046] Caller[0000000000472044]: mm_init.isra.0+0x144/0x1e0
  [    1.346229] Caller[00000000006602ec]: alloc_bprm+0xcc/0x1e0
  [    1.346388] Caller[0000000000660e6c]: kernel_execve+0x2c/0x1c0
  [    1.346553] Caller[0000000000be4060]: kernel_init+0x70/0x128
  [    1.346707] Caller[00000000004060f0]: ret_from_fork+0x24/0x34
  [    1.346864] Caller[0000000000000000]: 0x0
  [    1.346985] Instruction DUMP:
  [    1.347007]  92102000
  [    1.347135]  90100019
  [    1.347204]  f85e6490
  [    1.347281] <c6588000>
  [    1.347349]  c25e6388
  [    1.347416]  fa5e6488
  [    1.347485]  82004003
  [    1.347552]  c65e63c0
  [    1.347619]  83784c00
  [    1.347689]
  [    1.348041] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
  [    1.348649] Press Stop-A (L1-A) from sun keyboard or send break
  [    1.348649] twice on console to return to the boot prom
  [    1.348940] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009 ]---

This series is not bisectable to see which specific patch causes this,
as I get

  In file included from mm/init-mm.c:2:
  include/linux/mm_types.h:1419:57: error: 'PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE' undeclared here (not in a function)
   1419 |         [0 ... sizeof(cpumask_t) + MM_CID_STATIC_SIZE + PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE. - 1] = 0  \
        |                                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  mm/init-mm.c:50:27: note: in expansion of macro 'MM_STRUCT_FLEXIBLE_ARRAY_INIT'
     50 |         .flexible_array = MM_STRUCT_FLEXIBLE_ARRAY_INIT,
        |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  include/linux/mm_types.h:1419:10: error: array index in initializer not of integer type
   1419 |         [0 ... sizeof(cpumask_t) + MM_CID_STATIC_SIZE + PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE - 1] = 0  \
        |          ^
  mm/init-mm.c:50:27: note: in expansion of macro 'MM_STRUCT_FLEXIBLE_ARRAY_INIT'
     50 |         .flexible_array = MM_STRUCT_FLEXIBLE_ARRAY_INIT,
        |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  include/linux/mm_types.h:1419:10: note: (near initialization for 'init_mm.flexible_array')
   1419 |         [0 ... sizeof(cpumask_t) + MM_CID_STATIC_SIZE + PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE - 1] = 0  \
        |          ^
  mm/init-mm.c:50:27: note: in expansion of macro 'MM_STRUCT_FLEXIBLE_ARRAY_INIT'
     50 |         .flexible_array = MM_STRUCT_FLEXIBLE_ARRAY_INIT,
        |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

prior to this change that removes PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE.

Cheers,
Nathan

