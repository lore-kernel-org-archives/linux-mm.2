Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED3E0CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 01:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C078C6B008C; Mon, 28 Sep 2026 21:40:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6B2A6B0093; Mon, 28 Sep 2026 21:40:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 995D26B008C; Mon, 28 Sep 2026 21:40:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6161B6B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:40:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D6BEE40386
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:40:52 +0000 (UTC)
X-FDA: 85265095944.12.2A44453
Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	by imf29.hostedemail.com (Postfix) with ESMTP id D4968120004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:40:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=J+anqOgE;
	spf=pass (imf29.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790646051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FYidPasWaXjAPYk3Dy/s1s1Hir2o/n5IvqOLUGZZbIc=;
	b=SqRvhzh5zJ4NvAS1TpY9LvH7MKlH+us7GOHcwsFlnSVZnasvd1609bm+KUGjEWfrVmBcT1
	l/rc6UFbIQnGaVj27e3RGUJXQMNHiGPixNzbZAzhZw0mnoq7El6kdM7AQcuxLXHfZCV4it
	ARUAXfRV6UYj7g9zI5U+ZNjAnEzwB18=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790646051;
	b=tKXhNWAeibrCTB5YV5ovlBaE/QfHTLwtrb+lop7dSOMn9bOIkAHfCWOVs5GZpzt3Ac30Mk
	mHz7HrAd6IEORMLIP73MOzNOxZdGb0giiC6SvFiQZiIz4sT3h4Ec51vMmzkGsiPS+BPCmF
	kctJztgFyYXlY9YcKzpAsxQIZ2jwJhE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=J+anqOgE;
	spf=pass (imf29.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:mime-version:content-type:content-transfer-encoding:
	to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1790646049;
	bh=FYidPasWaXjAPYk3Dy/s1s1Hir2o/n5IvqOLUGZZbIc=;
	b=J+anqOgEgKf3SgYTGZMbymkbe3g2Zb21pR/ACzhWPMEm+/a64Q9ht5EJJclcqr0WSnh2
	ntk9846l1dpTLfME59LrRAOrIEQOXEKrgE5DUv2LYbrtdou4AlhNta/9CibvJCwIkMGIe3
	efOxOIV9xbiKP/8Jtx3DugPUyqcEsKXT+8+vzFUfopJ/xuJd6gOYEvToW0am21CVISerPw
	1W4qc9bBIvu9cxidoQTRlwfPiOSWfsQTIu0xDD5bL5XGD0D17WiuwGU9bOnFaTleY9492q
	pkmLVPZBV37T8wV7aRqOWxAogQJ7ie52eNLJ57N40g1Uh9VBE6dnTyoKfhoc9Esg==
Received: by recvd-597f69d6cf-jpxxc with SMTP id recvd-597f69d6cf-jpxxc-1-6ABB1721-33
	2026-09-29 01:40:49.573398085 +0000 UTC m=+366791.762543163
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-10 (SG) with ESMTP
	id m1IBuXr5Q0qLjTPFBMUn4Q
	Tue, 29 Sep 2026 01:40:49.537 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: [PATCH v3 0/2] writeback: let foreign flushes reach dying cgwbs
Date: Tue, 29 Sep 2026 01:40:49 +0000 (UTC)
Message-Id: <20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32Nyw7CIBBFf8WwFkNpi9SV/2Fc8Ji2GAUDLdo0/
 Xehbowx7uZk7j13RgG8gYAOmxl5iCYYZxOU2w1SvbAdYKMTI0ooIw1l+CGxnoztsOrS2V7H0GP
 CIH2BCik0Ss27h9Y8V+vp/OYwyguoIatyojdhcH5aZ2ORc/8XYoELLLjmDSe8FqU49s7CpNxN7
 oxDeSTSTw3/raFJUzNZV0qLfdXSL82yLC8X6YTWEgEAAA==
X-Change-ID: 20260926-wb-dying-cgwb-flush-06e260e2abad
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7614; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=FlSwq10fpwOe+rVjk1KVSJzK0NCyqkRnCyVrGOzUL5U=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBquxcgCNQTKBqqaROAmubisWey8LURlR3t3Uk81
 QoQ5ynDQPiJATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCarsXIAAKCRClztTjl62v
 wnE/B/9xS9/3l0UZ1Frv9AiJ4R5roP9rUyvfVtLKkdqgHUJhDlKi2vUPkybPMvVXVICTQ/BxXGT
 tPkziLPhide98bf8vsCu5l6YqXr+87/nFGQEi/2dctn58IvPbRAsWXAx5LUrp/QQ5LpNL2N/Vjv
 7Csoi0VKqBgKRcZt21wccReBeaxrfx1Zf6V+IbVfTHjORvOkjHRy4fkg6MkTy6S6cCyGaZjs7TB
 gb7TTCCgxmR+VDQC5aRyMXOEunCqQUkJKEGqOlfhWvwSTdezV1ofzE7BGZE0A1D1kaYp1PN1ow+
 ePVomy7G99qqYrTjUu6IEcp3FAFEY2u2elINcamzy4pph7dV
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmed6EibRi2Q90?=
 =?us-ascii?Q?BqbUnLdfs45F6CAlvn1dTuFM2bHIDJj14zXYAXu?=
 =?us-ascii?Q?YEqmNTN3Oy1ldXwXRvDuRO3y+Tv9lTdiuwM8tv4?=
 =?us-ascii?Q?p2mBM6IaL99m+XY0sjLLJC73DV=2Fyh5VU4sEPupS?=
 =?us-ascii?Q?e174O68YpaDg042ky1n+K8=3D?=
To: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Tejun Heo
	<tj@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, Liz Fong-Jones
	<lizf@honeycomb.io>
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D4968120004
X-Stat-Signature: ci9qwe54otix9pwk1ahoan4r3o5db19g
X-HE-Tag: 1790646050-144788
X-HE-Meta: U2FsdGVkX1+ULU9FCWR9oxCP5i6ini4q1SoNH29muyVr0/7E+dcz76T4ZyU+Igswgfa+uaqjFI2DR1TrdaCnL4U3CF7dTAzW7lgOdlvn8vMCHgj8d9SblVUrBP1yVmOPIwuJodkZ5YK7CLC/JF7uVYOAgMKs+KlJTfv2zWBBdJ9gkxK8D+/vdw3RnlduJakS1BbFBae/yvTlKfmhFpGVTrhG9QiqcOtAd+ZArA6LxYca1JzPZDT3W4ItHGlAfF8tVdNUM++47dvA9VEGX1glJNqvFKL2ln5+V6JSnSBZhyaKY6DGiLxx7yaaCMtd7w4zUeEibULkz6Oc2Y5xC7QqgJeG0f24/So9ZFqbfHY0is4ECW1Qa9eIwa40p72H9CbNhvyAp+lkPo8GrpQYdGpLKjhcc/ivz3SwaF2x1fEp17qUeP2yzR+W3IQ9D52ZqE4C/D83/kijqCAWtC35UZ7jwAREw3W6xiBBdWpMqTbi2v1brfL1PyNNNrCUKuTrmEUqq2kMQX/W02Ld+STg0rS5jNJLMissdVjH+49wYs7TZvf9fGm21TzShu0ZPV2cr15Y10LKSRE6vYCNBk5Mf7qRdU34GVtzS6AbHKqOzSlga5Vjjad41B7M2ryUfPtSSGHVbcZDSPwI5qkQTYqATTglKi6J5UM+xBntgNMZVHSn+Dia0MaBRDByfJQ+5gZmA8AkcOG7J2hjV+8xLvYW5xP9kmlzVuVKXYS7PDvOuEATxnXS23yCr8PH88Iftf0eke1Ev7DkIi/+mpbs7xGoxnTLHURfFjiZQc3oh1vy0M8Hm9fpSLqS4scLDSepf1fACSJ0bnVXCpzn6vzUzuPEtgJWiK2v6bMQE3IvKFvAD8t8qsWtfe7zNM4yve3TAvedkO43DQ2nm+IWS0eORoWtpqDLr0Wj0U3S/R7shuApA1vDDzBc4cd5Vh45RAi9/3kYmte27zGAjYeFtXjeTK4F3Gu
 h1ODOe3v
 jwtuV2VxodAYpZOpiLpK3sZei/LjGiCrCoDCPpKKonmPc2RIx1oTefZCO6sxFUCI65EFS6Q5WMVnlv2jkN/k4h3b4eQMXU+sdJxXBH4N/IHpd1zMixtfUTwj//tEHwRqvgKaD2zaafIJ71pUZgyTUEHUvcSR/9P5qBUvGiCcyNftssVFZarqv/e3rZ5caCbMIz9r7HunKDy8taW7ZhDDQkZ3sQP5yMJIZn0ar5bUAt5H9PxykFFQWx7p5u0IxLPCuH3Ho31PUqq0aauHETzjLEyl4tDgdjVrlVLkCl+np5X1JOa5/7OxNZvY6nzr+IQqf9rZLnZWrgE8XTtuBJaCPdT7bLjgIHnKMDtMW1mVLRxRpoWid3CfG5UgT6ljzjfkH3r9QdGTTizU2Xm3yIG2euSoDap89dUzKe14zt5Wp1PpAPLO+IJYTnSKh9NUaQexG0/Pi/E84l7+h2foO5NZ6Q7hCUParx3ytxLNNnkfdSfWShFaYDEJQCCUx3YzIWYDLyDdPXwzaH7SpaBvMbMVFyCE4vsP44CfJN9v2BWS8MObrLeUGmwfJJ2WaFuc4i3Yijok86FZwzwIklAUr6pz0Ol5txhNVBp7TQA6ICHw712ch4cQ+1gXP8zzYnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At Honeycomb, a container that reads from Kafka and writes columnar
files to a host volume stalls for 30-60s after each deploy replaces it
(v6.18). We're increasingly confident this is the cause: the stall
looks the same as in the reproducer (little CPU use, lag growing
linearly and then recovering), and the mitigation it predicts, moving
our final syncfs after the last write, worked in production (below).
We haven't caught it with probes in production yet.

Patch 1 keeps killed wbs in bdi->cgwb_tree until they are released, so
foreign flushes can still reach them. Patch 2 kicks writeback on a
killed wb that a live memcg's new wb replaces after a blkcg association
change, which patch 1 leaves out of reach.

Based on vfs-7.4.misc, next to Xin Yin's 168a8c13159c, which fixes the
sizing but not the lookup of a removed cgroup's wb. Each helps without
the other; this series also applies to mainline. On mainline
(fd179f8a05be), without 168a8c13159c, the test from the changelog gave
52.8s, 73.3s and 5.2s worst lag before this series and 1.4s, 1.0s and
1.0s with it.

Syncing before the removal isn't enough: cleanup_offline_cgwbs_workfn()
skips a dying wb with any dirty inode and only retries on the next memcg
offline. On ext4, syncfs can leave inodes I_DIRTY_SYNC: at 5000 files
one syncfs still stalled in 7 of 9 runs (19-26s worst lag), a second
syncfs avoided it in 5 of 5, and with this series one syncfs lagged at
most 1.3s in 2 of 2. On XFS one syncfs left the wb clean in 5 of 5 runs,
but a single 4KiB append from the old cgroup after it stranded the wb
again (15-28s worst lag, 5 of 5; 1.0s in 2 of 2 with this series). In
production, our writer synced after closing its data files but before
writing its final Kafka offset to a small shutdown file, and moving the
syncfs after that write mitigated the stall for us on XFS. In the
reproducer, a 14-byte file written after the syncfs stranded the wb the
same way, whether created directly or via a temp file and rename (16-29s
worst lag, 7 of 7; with this series, 1.0-1.2s in 2 of 2 created
directly); an empty file did not.

The harness that produced the numbers (paced writer, lag per second,
MODE=alive control) is at
https://gist.github.com/lizthegrey/2209d831930588f63076bdc0ac7b78e2, and
a minimal recipe is below. Settings for all numbers: MEM_MAX=max
POD_MAX=4G RATE_MBPS=250, plus NFILES=5000 SYNC_OLD=1 (or 2) and
DIRTY_AFTER=1 or SHUTDOWN_FILE=offset|offset_rename|empty for the syncfs
runs and NFILES=500000 OLD_SECS=120 SYNC_OLD=1 POD_HOP=10 for the
500k-file runs.

Also reproduced unpatched on bare-metal arm64 with Ubuntu's 7.0 kernel
(ext4 on a loop device): 12.9s worst lag with the old cgroup removed,
2.5s with it kept.

Tested: arm64 KVM guests (virtme-ng), ext4 and XFS on virtio. No KASAN,
lockdep, PROVE_RCU, DEBUG_LIST, DEBUG_OBJECTS_WORK, DEBUG_ATOMIC_SLEEP
or DEBUG_PAGEALLOC reports, including a stress run toggling io on the
parent of two writers 40 times so their wbs are killed and replaced in
the same slot (160 takeovers, each followed by patch 2's kick, counted
with bpftrace). W=1 and checkpatch --strict clean, no new sparse
warnings. Patch 1 is under CONFIG_CGROUP_WRITEBACK; patch 2's
wb_wakeup() and wb_start_writeback() changes are not, so v3 was also
built with it disabled (arm64 defconfig without BLK_CGROUP, W=1 on the
touched files, no new warnings).

Not tested: x86 runtime, this series in production, linux-next.

Workaround until this lands: syncfs after the old container's last
write (twice on ext4). Lowering vm.dirty_expire_centisecs from 3000 to
500 cut the worst lag on unpatched mainline to 4.8s, 4.6s and 14.3s, but
did not remove the stall.

Related: without 168a8c13159c the flush is sized from the dead memcg's
own dirty pages, so this only helps while it has some. f6988c90671e
(mainline) also matters: on XFS with 500k synced inodes and the pod
cgroup removed 10s later, the handover was slow enough without it that
the replacement fell 21-22s behind (vfs-7.4.misc), against 1.0-1.2s
with it (mainline).

Patch 2 was tested with a live cgroup whose io controller is disabled on
its parent (its wb is killed and replaced) while a sibling keeps
appending to its files, on XFS with 5000 files. With the kick, the
replaced wb's inodes start moving over right at the takeover; without
it, they started 12s late in one of three instrumented runs. The sibling
still stalled in most of six runs either way (worst lag 20.3s, 1.2s,
10.8s, 28.5s, 3.8s and 17.0s without patch 2; 2.8s, 22.3s, 25.7s, 17.3s,
1.5s and 19.5s with it), because writing back the old wb's backlog took
up to 27s and the sibling's foreign flushes reached the new wb in the
meantime. Should foreign flushes also reach a replaced wb until it is
clean, or is that not worth it for this case?

Developed with Claude Opus 5.5, which wrote the code, the reproducers
and first drafts of this text, and ran the builds and VM tests. Claude
Fable 5.1 reviewed the code and the claims in this text before v2 and v3
were posted. I drove the investigation from the production symptoms,
designed the experiments and controls (repeated runs, parent-commit
baselines, testing this patch on its own), and reviewed the analysis,
code and results.

Minimal recipe:
	#!/bin/bash
	# As root, cgroup v2, in a directory on ext4/xfs/btrfs ($DIR).
	cg=/sys/fs/cgroup/wbmini
	mkdir $cg && echo +memory > $cg/cgroup.subtree_control
	echo 4G > $cg/memory.max
	mkdir $cg/old $cg/new
	append() {  # append $1 blocks of $2 to each of 1000 files
		for i in $(seq 1000); do
			dd if=/dev/zero of=$DIR/f$i bs=$2 count=$1 \
			   oflag=append conv=notrunc status=none
		done
	}
	(echo $BASHPID > $cg/old/cgroup.procs
	 append 8 1M            # old owner writes the files...
	 append 1 64k)          # ...and exits with all of them dirty
	rmdir $cg/old           # its cgroup goes away while they are dirty
	bpftrace -e 'kretprobe:cgroup_writeback_by_id { @ret[(int32)retval] = count(); }' &
	sleep 3
	time (echo $BASHPID > $cg/new/cgroup.procs
	      append 4 1M)      # replacement keeps appending to the same files
	kill -INT $!; wait
	rmdir $cg/new $cg
	# Unpatched: many @ret[-2] (-ENOENT) and the append stalls.
	# Patched: @ret[0] only.

---
Changes in v3:
- Use wb_dying(), scoped_guard() with the offline_node list_del moved
  into it, and {}; filter dying wbs right after the lookup in
  cgwb_create(); comment wording (Tejun)
- New patch 2: kick writeback on a wb replaced in cgwb_create() (Tejun)
- Lead patch 1's changelog with the problem and its trigger (Andrew)
- Link to v2: https://patch.msgid.link/20260928-wb-dying-cgwb-flush-v2-1-56b54cda74f2@honeycomb.io

Changes in v2:
- Keep killed wbs in bdi->cgwb_tree until release instead of walking
  bdi->wb_list (Tejun)
- Drop Fixes: and Cc: stable (Tejun)
- Link to v1: https://patch.msgid.link/20260926-wb-dying-cgwb-flush-v1-1-a8d898085a3a@honeycomb.io

---
Liz Fong-Jones (2):
      writeback: let foreign flushes reach dying cgwbs
      writeback: kick writeback on a cgwb replaced in cgwb_create()

 fs/fs-writeback.c                |   8 +--
 include/linux/backing-dev-defs.h |  13 ++++-
 include/linux/backing-dev.h      |   3 +-
 mm/backing-dev.c                 | 102 +++++++++++++++++++++++++++++++--------
 4 files changed, 101 insertions(+), 25 deletions(-)
---
base-commit: 168a8c13159c6e3f0f08da6f8fa2f633a91ba9fd
change-id: 20260926-wb-dying-cgwb-flush-06e260e2abad

Best regards,
--  
Liz Fong-Jones <lizf@honeycomb.io>


