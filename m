Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A7F6F4613B
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 16:01:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876C56B0005; Mon, 23 Mar 2026 12:01:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 827D36B0088; Mon, 23 Mar 2026 12:01:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C8646B008A; Mon, 23 Mar 2026 12:01:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 55FB86B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:01:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E97F55C701
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:01:00 +0000 (UTC)
X-FDA: 84577791480.22.ECD0061
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id DCFBB18001E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:00:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bitbyteword.org header.s=google header.b=nor4dDN6;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of vineeth@bitbyteword.org designates 209.85.210.49 as permitted sender) smtp.mailfrom=vineeth@bitbyteword.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774281659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7SscKSPRtp5r0bOyZYtc8orw97P+lM4BuDDRyRnpM2Q=;
	b=ouokkADGZ+QdWarjAoxI6oUOIBZ+3WrYMI3Mjp02zIkenjIWsn/YYLOWcHpM4cPjSLNHVh
	5EbmcT5IzHgVSeOvk77GhE6bKdR6ITlqD+yBCfxlidJ9iVx/P8CGjpuI5Ce3CpoFUCmYIf
	FUlxQ8TNnHGVyHiPZG/vSWQaK43pIY0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774281659; a=rsa-sha256;
	cv=none;
	b=BypaFw+m+reBe6AHtEmNNk8QAzRRYhTlzpmyzPZafj6vCHISws3l4MRijVs8N3YNmXNbBh
	Dv5NsPaqMOFhEWm/CPM0RObi1GWqzSXa8EsveMQRZjveoHXB2eNYHzUUH1f6Av/jAHFeJg
	TBEuT1DzHOkyjkH+NpUog4toke+5gbM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bitbyteword.org header.s=google header.b=nor4dDN6;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of vineeth@bitbyteword.org designates 209.85.210.49 as permitted sender) smtp.mailfrom=vineeth@bitbyteword.org
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7d7f9285560so1263462a34.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1774281658; x=1774886458; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7SscKSPRtp5r0bOyZYtc8orw97P+lM4BuDDRyRnpM2Q=;
        b=nor4dDN6P4ycawZkYCb9Rp3l7UeouAhSY38aS+R7klBgqWOJhB8+3rsz3FCWClN0ei
         n182MBuNwCrZMiF+o5vKv3SZsQFRlif3DOnaoC2ZSB/FENH+mtboqfxuWmohjms4GlJn
         5eO/CADIpBJrEFBAtIaaZ/cjQVkf6OiJ7dvHbGk0/I5AKJ7joylE5ukePOpJvSUT/2z3
         4eJ+/BJiBrVNjyiX15yjVBHhUxs9txJnE1lPSU9EELoVYcCKYPI0Q3RjyXvPUOEtIf1K
         MoyKuzAp8p/IJIcmU/4hMTYJq06+3F8IThuJxmE26ovJgQOGXA2PBp3Vs4yNyUoUDxFN
         USmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774281658; x=1774886458;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7SscKSPRtp5r0bOyZYtc8orw97P+lM4BuDDRyRnpM2Q=;
        b=Ga9gM6iupVTgE9sFRn8h6WfI48QusESNBnVMwWZQoMk+kxpfZV7Y2Ano/N41rMtCuY
         9+OOl/RdqC2QoKAebef4cIPpcZQZIM6NiZCIGI9svKZc8fLtMuaSbMmxkB7osyVhTLJg
         m/+Nv3utE8PDxT0nsyTNmAeOJ5RvamI/wmwXQ5BXIptPswPHH5p0I7wUcK1eQ0jU3EJp
         T/90a7O92MZrx/Iji79jv6Rl9BYAmv3OVi2bqSQ9Dw2JMGo3f8+sf5FqG1Osqk5qC0Lm
         aQxVP65kc3Bw+AeN/J60+NrVkvZE65i6W6dVkFW2Sk+Kei3S8Vi0lGDS41/PpMUBiBdN
         +mPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBaIAp7babET3rNW6ThXM3ove0RhNfsGefz5fdz1sKBVUtZI0qWwDLKK/Dfcm38hmJBjgYhIrmsg==@kvack.org
X-Gm-Message-State: AOJu0Yz1EkPlrWqdy5pLh7IszxiX0dLhN1GTieKITqHAjovK4J+BYISv
	ODVv32C9cR40JhlBTx3CuCTBSr7jvX+HMvP51JNyv5XFPs3cv3hyVLsGzYBgStng3wU=
X-Gm-Gg: ATEYQzx2yjKxNsUI4qBQdSDIx8FIzjxHDqh2wGme78fPqbCW9dfEzY7i4q1RqEa1uMG
	ALk32IrqdYzQoKgK+QjNv29Kjr4U3EoMLWtY3wBh+2r67vaNmx0XFj6VTGtEkP5s2JKxvy0/pgX
	lk9DvDwDiQkOJZ0j4P+CB1jbLIpI3v8V6ICutZgpu+CnwuefhGM6o20IPqCjUp5OWDmTNgPpz1I
	wGE+nUbX8RXNDswAHQ8i+a1lDTjKaqnPYZ5+M4Nk3BfF5z114iZtuiOGT7x2qHXq5dZoZracu2O
	5JbM5GCdpKRPgI6E4Eb+Po19GK1jPieAGqW191SK+TWzABPjX4NpuWA8U3efDrQm3h2az5mVaPN
	09amh4yyzyb77osuwQNZvb1IU7l2CebKKnDnLj3BetNsob5pXqdnJJ1aOq54bWqYNKzQORqA0HV
	IQ3phEBPV9EQM43YHq65DVISirhMtt3+JnCHWHCO7WmsY69+95akVLNV7kamm/Cu5zoQ==
X-Received: by 2002:a05:6820:3091:b0:67d:9cc0:968 with SMTP id 006d021491bc7-67d9cc00e0dmr6486936eaf.63.1774281657494;
        Mon, 23 Mar 2026 09:00:57 -0700 (PDT)
Received: from vinmini.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc9088df1sm843364185a.25.2026.03.23.09.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 09:00:56 -0700 (PDT)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net,
	dev@openvswitch.org,
	Jiri Pirko <jiri@resnulli.us>,
	Oded Gabbay <ogabbay@kernel.org>,
	Koby Elbaz <koby.elbaz@intel.com>,
	dri-devel@lists.freedesktop.org,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Len Brown <lenb@kernel.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	linux-pm@vger.kernel.org,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	linaro-mm-sig@lists.linaro.org,
	Eddie James <eajames@linux.ibm.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Joel Stanley <joel@jms.id.au>,
	linux-fsi@lists.ozlabs.org,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Philipp Stanner <phasta@kernel.org>,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	linux-input@vger.kernel.org,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	linux-i2c@vger.kernel.org,
	Mark Brown <broonie@kernel.org>,
	Michael Hennerich <michael.hennerich@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	linux-spi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/19] tracepoint: Avoid double static_branch evaluation at guarded call sites
Date: Mon, 23 Mar 2026 12:00:19 -0400
Message-ID: <20260323160052.17528-1-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DCFBB18001E
X-Stat-Signature: ruy1gfk8rm163htu7kgcqmjfuku17hcm
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774281658-960233
X-HE-Meta: U2FsdGVkX18gG/yjGlsp+Df6RQyNfoDb4DEAogr7IJ0j8XeHqBokbqV6DDK6rqf36oz9a0gzlfxnEwP9tzhBTJI/lTE4O6wvsyOi6amnv2fZrcN4lmeyciRuahpIuDZGwK41Ng6RkKz7Ya93qwMs4+JCRjmOFSL+jMOGnX5pdZM6ioyl27zDLMBTwOxqojpxsTxWXXlcLc3qgtLC356gyUGKoSDvTJ8VDS30zioJoebVpj77i18gnfqDom4qcA2wDD/9H+h5H+vIT1m3FP3t5oUPGKBq/bzid4tyjqESHfxT7/g/9/STd3UDUT+4UJXpr+pzUPnh1BxBk0CXIoBM9u6ub5B+5K14zaYyq53OwX8BMFuGu7w0/xU0oJJNzQ0f2octOYuzkvr4h2q3yasXX659+ELKokPx5D/I3YjCxL+9ra4QCQSeIbgh5kyl9amV3+vB2QvTFZW87+OxrVlkfh0Lx4qEWW8RUcUf0d8A37e/VULZuLwadxynTEsgRaUQhfQPBhnacensG8vHdtgGwg/Grnx5JKd4uPa/TRd6sJgHUYtEN6y/CqwlU0/4acZXvn8IOnqYljRWw5tEk2BHKswxcz6YsmEe/OwRDiJGYMJQflBpRV2N7hcmTFe69syHNErKAMcE+8/rhHCdrQhhbLBG2PhIi3Wi5eDpxeRgO5pFJvWt3DlNH05JuFjmTrLim4ypAvGzBS9l+IdTUbXyF764fxLuoB/DX1vOmKYMFOi6z4WsNCAH86QSFsQELDDNNhTtIGcaLpv2fwVME0WeRptE+d6NbpFGlJX9zjNtf/KpfTA2XkZZmC+/QlkIAlI06lYSM1pjMONehh86sPePDjWrrF+z3fLRIY5pGrjHZa1HkF5O5Qg1DVQjzbblZH4CHhFEV1Vzz0UbgHBoq+xWnekJ7f2wjezEXOO+Wx1shgSP3CJYI3Fn3KnpMiQoeLi4cSfBJkQzXvYWsWOizre
 YXgwC2VH
 Fby7qiloYf/M7P1KAagp92xQpgWOo5GU1dfQpDpzpFUUr1cewa2WocAmg4pb+0U041I7/gY2guCHhvELT64eMNZWJVeVk5c832d3zHM5dTl4r0LuiFHGMbsQOk7Xy0fP1iGutG8/ZBuBYnc6ngsNc/C2JMpOdJq5pp3FneYSCu8TO1SJ3Dl+KgXyCmP0Dl0fhtc60a4tCi2E/sN4SOpCScOyuds86Acu/SBwV0ToZpA9Adgj+SC+ysTmYLMCHZBeC1blXl1lPy5lth1o/ayfJ5dYZwAkaqVoIybyXvlBOdY33Im+RST3EgwX2m3NEsHg1X7tevtAKKVgTVRyeF1PEZVNyNE+eiF4XV1GVwXHy2WIlMmVRzhYItxOWfpfcyvORhwNPS/Do0ErLSJspX/oBZz3USvJJh8cGFBoJ3hAErgUAVvt9xbACoUA05hCZEH0hRGWYf1VaOnOk6RPHhiHJNjQrrUkZi8pduk2dnS3XvCXvB67HRYkZeot4bi3gerFRqUN0h5PiA10jD8mENsCxSwVrLlcTdwOjCThTaR2HJvFiWiCPEZmvZCGt46EytwGXt9Tb2PKvTaaCtpt6orKLJtXYbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a caller already guards a tracepoint with an explicit enabled check:

  if (trace_foo_enabled() && cond)
      trace_foo(args);

trace_foo() internally re-evaluates the static_branch_unlikely() key.
Since static branches are patched binary instructions the compiler cannot
fold the two evaluations, so every such site pays the cost twice.

This series introduces trace_call__##name() as a companion to
trace_##name().  It calls __do_trace_##name() directly, bypassing the
redundant static-branch re-check, while preserving all other correctness
properties of the normal path (RCU-watching assertion, might_fault() for
syscall tracepoints).  The internal __do_trace_##name() symbol is not
leaked to call sites; trace_call__##name() is the only new public API.

  if (trace_foo_enabled() && cond)
      trace_call__foo(args);   /* calls __do_trace_foo() directly */

The first patch adds the three-location change to
include/linux/tracepoint.h (__DECLARE_TRACE, __DECLARE_TRACE_SYSCALL,
and the !TRACEPOINTS_ENABLED stub).  The remaining 18 patches
mechanically convert all guarded call sites found in the tree:
kernel/, io_uring/, net/, accel/habanalabs, cpufreq/, devfreq/,
dma-buf/, fsi/, drm/, HID, i2c/, spi/, scsi/ufs/, btrfs/,
net/devlink/, kernel/time/, kernel/trace/, mm/damon/, and arch/x86/.

This series is motivated by Peter Zijlstra's observation in the discussion
around Dmitry Ilvokhin's locking tracepoint instrumentation series, where
he noted that compilers cannot optimize static branches and that guarded
call sites end up evaluating the static branch twice for no reason, and
by Steven Rostedt's suggestion to add a proper API instead of exposing
internal implementation details like __do_trace_##name() directly to
call sites:

  https://lore.kernel.org/linux-trace-kernel/8298e098d3418cb446ef396f119edac58a3414e9.1772642407.git.d@ilvokhin.com

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>

Changes in v2:
- Renamed trace_invoke_##name() to trace_call__##name() (double
  underscore) per review comments.
- Added 4 new patches covering sites missed in v1, found using
  coccinelle to scan the tree (Keith Busch):
    * net/devlink: guarded tracepoint_enabled() block in trap.c
    * kernel/time: early-return guard in tick-sched.c (tick_stop)
    * kernel/trace: early-return guard in trace_benchmark.c
    * mm/damon: early-return guard in core.c
    * arch/x86: do_trace_*() wrapper functions in lib/msr.c, which
      are called exclusively from tracepoint_enabled()-guarded sites
      in asm/msr.h

v1: https://lore.kernel.org/linux-trace-kernel/abSqrJ1J59RQC47U@kbusch-mbp/

Vineeth Pillai (Google) (19):
  tracepoint: Add trace_call__##name() API
  kernel: Use trace_call__##name() at guarded tracepoint call sites
  io_uring: Use trace_call__##name() at guarded tracepoint call sites
  net: Use trace_call__##name() at guarded tracepoint call sites
  accel/habanalabs: Use trace_call__##name() at guarded tracepoint call
    sites
  cpufreq: Use trace_call__##name() at guarded tracepoint call sites
  devfreq: Use trace_call__##name() at guarded tracepoint call sites
  dma-buf: Use trace_call__##name() at guarded tracepoint call sites
  fsi: Use trace_call__##name() at guarded tracepoint call sites
  drm: Use trace_call__##name() at guarded tracepoint call sites
  HID: Use trace_call__##name() at guarded tracepoint call sites
  i2c: Use trace_call__##name() at guarded tracepoint call sites
  spi: Use trace_call__##name() at guarded tracepoint call sites
  scsi: ufs: Use trace_call__##name() at guarded tracepoint call sites
  btrfs: Use trace_call__##name() at guarded tracepoint call sites
  net: devlink: Use trace_call__##name() at guarded tracepoint call
    sites
  kernel: time, trace: Use trace_call__##name() at guarded tracepoint
    call sites
  mm: damon: Use trace_call__##name() at guarded tracepoint call sites
  x86: msr: Use trace_call__##name() at guarded tracepoint call sites

 arch/x86/lib/msr.c                                |  6 +++---
 drivers/accel/habanalabs/common/device.c          | 12 ++++++------
 drivers/accel/habanalabs/common/mmu/mmu.c         |  3 ++-
 drivers/accel/habanalabs/common/pci/pci.c         |  4 ++--
 drivers/cpufreq/amd-pstate.c                      | 10 +++++-----
 drivers/cpufreq/cpufreq.c                         |  2 +-
 drivers/cpufreq/intel_pstate.c                    |  2 +-
 drivers/devfreq/devfreq.c                         |  2 +-
 drivers/dma-buf/dma-fence.c                       |  4 ++--
 drivers/fsi/fsi-master-aspeed.c                   |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c            |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c            |  4 ++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  2 +-
 drivers/gpu/drm/scheduler/sched_entity.c          |  4 ++--
 drivers/hid/intel-ish-hid/ipc/pci-ish.c           |  2 +-
 drivers/i2c/i2c-core-slave.c                      |  2 +-
 drivers/spi/spi-axi-spi-engine.c                  |  4 ++--
 drivers/ufs/core/ufshcd.c                         | 12 ++++++------
 fs/btrfs/extent_map.c                             |  4 ++--
 fs/btrfs/raid56.c                                 |  4 ++--
 include/linux/tracepoint.h                        | 11 +++++++++++
 io_uring/io_uring.h                               |  2 +-
 kernel/irq_work.c                                 |  2 +-
 kernel/sched/ext.c                                |  2 +-
 kernel/smp.c                                      |  2 +-
 kernel/time/tick-sched.c                          | 12 ++++++------
 kernel/trace/trace_benchmark.c                    |  2 +-
 mm/damon/core.c                                   |  2 +-
 net/core/dev.c                                    |  2 +-
 net/core/xdp.c                                    |  2 +-
 net/devlink/trap.c                                |  2 +-
 net/openvswitch/actions.c                         |  2 +-
 net/openvswitch/datapath.c                        |  2 +-
 net/sctp/outqueue.c                               |  2 +-
 net/tipc/node.c                                   |  2 +-
 35 files changed, 74 insertions(+), 62 deletions(-)

-- 
2.53.0


