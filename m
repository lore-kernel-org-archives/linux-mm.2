Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6FBBCA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 23:50:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E25346B0093; Thu,  1 Oct 2026 19:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5AD6B008C; Thu,  1 Oct 2026 19:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7BA6B0095; Thu,  1 Oct 2026 19:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 890AA6B0092
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 19:50:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4B2AA35BC
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:50:24 +0000 (UTC)
X-FDA: 85275703968.11.5B81FEE
Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	by imf03.hostedemail.com (Postfix) with ESMTP id 78B2720002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:50:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=WJRKtuN+;
	dmarc=pass (policy=quarantine) header.from=honeycomb.io;
	spf=pass (imf03.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790898622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=J3mLsk67P0VbHulsunTuCatRpU6R8+ZFzTl/8DDevE4=;
	b=nwdAq7aDxE0s2JQ/MwXG5mFrkGU2eeyP9jQODNaEDpGEfXPGMlsStDpQwU4PMdxN8xQSM7
	GLKbJefveXqYmHViIM3szq06bjQoGDyvHjst77c+ty6yqzxoD9jSkrStvNgSAFW+ltGbab
	FLfzT/mILDN14jTHTeOQsluri9rTznM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=WJRKtuN+;
	dmarc=pass (policy=quarantine) header.from=honeycomb.io;
	spf=pass (imf03.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790898622;
	b=ZKFRZ0saLUkvH1m1lBRmosP/6lm21FTfFA8kLaR+tgLTjpfjLnHLT+0w3PogJK1LknFU0c
	9RRKk9W5H+eUQQFdvAwcBm+xE8qyjc/9yfXlyl2VpGanWfwkSxhZYZ0MU/97aUPipfLZBP
	E7LiWkl6sumOFsjrstA4iQ20qYg9NtI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:mime-version:content-type:content-transfer-encoding:
	to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1790898620;
	bh=J3mLsk67P0VbHulsunTuCatRpU6R8+ZFzTl/8DDevE4=;
	b=WJRKtuN+vZe2jxKmse8INsKKwXdOdpd3OJ+VqwrsOyFzwb3YA9VHtQy8T+twi3MUsoga
	4OeBYXG1ymgmWrObyA3FsGgEiaEcemT+CUSYewBLbpBbEBSJTUqFt4ok//aivQSIJI+pmh
	G1bQNvcP/oAQ5sqiOzvrw6lJIepI2UdoUrL+s2hkyw1cyZM8MiURZFjJ8UgEb6P7YFuxTb
	GHkPzBYPXCySzDRva8ysWjs281w0SbWAzDkr/eQ9+LMcOMkfvEt4YRQE8eYV11HS7XDnlH
	K+F5koPEXWq2l9Mw1+ocatfIdeL6Xo+aKOaBbvhIIQwL9h+4su43jppI27JvpomQ==
Received: by recvd-79d8dd9bd4-m8x27 with SMTP id recvd-79d8dd9bd4-m8x27-1-6ABEF1BC-35
	2026-10-01 23:50:20.260345841 +0000 UTC m=+197336.482616862
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-1 (SG) with ESMTP
	id J0FJll5KQGSnp7yE127PgA
	Thu, 01 Oct 2026 23:50:20.177 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: [PATCH v5 0/3] writeback: let foreign flushes reach dying cgwbs
Date: Thu, 01 Oct 2026 23:50:20 +0000 (UTC)
Message-Id: <20261001-wb-dying-cgwb-flush-v5-0-8361eb8c65c6@honeycomb.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/43Ny26DMBAF0F+JvM5Exi9MVv2Pqgs/BnCU4AoTW
 hTx7zFkgyJUdTdXM3PugyTsAyZyPjxIj2NIIXY5yOOBuNZ0DULwORNGmaIVU/BjwU+ha8A1eay
 v99QCVZi3yIw1nuTP7x7r8Luqn1+vnO72gm5YqOWiDWmI/bTWjsVy93fDWEABRntdaaql4eajj
 R1OLt7sKUSylIxsy+h9hmVGKiuF86YUNdth+D8YDhSQS14KrYVS5Q4jNgyn+4zIjPWoeKkpN5V
 6Y+Z5fgIAGm/OoAEAAA==
X-Change-ID: 20260926-wb-dying-cgwb-flush-06e260e2abad
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8716; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=9YIL5ZMLr+YRiQEZVnxUUVo/YOAF5YsWS3nQ1/rYu2Q=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBqvvG74WF2TgiwEKd8tLRomVTGwhntlREW455KX
 BMk5eNVI1qJATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCar7xuwAKCRClztTjl62v
 wgl+B/9eS5xRiDl2yYvRxDTC+ecJl4/0nBufRPU1pZwFNPQTWgDa7nNckn7wCyBEIVeRaAYWhNn
 fpvE9EaEzd6y/bYMGmTvuKpb4lHXBRpik28vT8AkdsQTrhsMiZAZprWsLA9P82rYZkqogG13GPC
 kVUtE79Sulv03piFowWDe1cuEWxzmK7to2Yc9dIkRmuElMJDPj/VNfYr5xVaZqAVpwo1ubrPkAo
 1QTu7gMCEdf65o9KT7AeRA46KR16Fh4K2DOVqOAKcFmiwe3eLBSpSVNB+glH+XqXITDlZ3j09bC
 KkVTFIdSbMs900bSXct07EBCo48gpILk91XTreFeIcJO8C2Q
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeYU4BpcB4bEw?=
 =?us-ascii?Q?sEbj2BWEEecut2plYOFkxQCdcF69eKXmxC5GgbN?=
 =?us-ascii?Q?HWmcir6NOb6qnnunVwI2NmrAg5xSz5IlsHdRH65?=
 =?us-ascii?Q?2+UCPdoDoOptUZlD3yHScpjtOlnyJNkpHmj9MCJ?=
 =?us-ascii?Q?B13GMTYzxtz9KIbvucA5+ESVr8u8tx9Ug4xLCiY?= =?us-ascii?Q?voic?=
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
X-Rspamd-Queue-Id: 78B2720002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: qxm3ciexhnb4r4ctgcgsext11buzk3me
X-HE-Tag: 1790898622-341251
X-HE-Meta: U2FsdGVkX1+mPqqdNegkyJ/OHeIxQI7NuqeVZgc1qTxuTRxe0Fb6u6UX4k2L6xWirV4ltqUUfqwNhMU+rOCUzpWtmunRAAyLogm4AZqCakJXREtl8qlIqxyXqqmWmAHT/sn79gb3Cakn9YyV7jg2mpN0G0lEIrLLUuVRxSzEOZlDM/yCqidjD+BJtoVbV4PclZykIQHcLDoLwyeqxtzkHOyQ4PlwomtYO+fJORSNLi9Dtwr+Ppex/NqHlqSFdraaittdgHCFO6TQ4Xiq9SlheIY69RIzQ8wl5FKsxiRtKLucNStzwVSb5pqscK8j3V8y+gzpgz0p+htPhxyqaBN1WfjValsoYnu9NY46edUY0LgdmFP3nTeiOo60lxISi2t+VXUpZUmtUqCxJ7lAMfz/1yZ0QCfQtTTCjZ0yaRhXyZRo7ve6i3dk2KMcLjCgtTTkMF9hwrhdB6fKOknyKodN14KWenMW8y4M+gbA+g3rqwDdZfNYBoVF7Xrn36rVcXnU49rcpiVTwffiavCMe0SM3FpGKcrG83svNWscZiHyFpX2eDuEkkLEmEUmmrFbfZl2gjflA6Rh2lF2LL5nrJaBpOKKbetxMkjW4E94aiuehC7oQfmSF7kFkYvciVp+aebyAZdyJJh4uYo7hv+RRXUBDoqpVWxTvyBK+0vhD84Dsto3R8SddEx0yqkJyMreQJkwSwFDHN5bNSlR3gbOXa25r67NAW5AWFh541iQkD6ioHB5okNEM+Z8mc0FQTHXY5GPpKMoFMQYyFQbJO4aICwGUovSrjjc1x2fSIeROs+ekmldhFmEmELvQEWtdfvf15hytmuNOavBXX5JE9lvHtGVvjG8/xtPN5aDzx+xhD6SHEeFQbhVebnhtguzybPm6n5rMhcSmddQAh4TXYzo+J9/h5Cetm51pAbO0naXVWPkPIU7gcf0jCbm3VKv1UgN7cpwbZ7dHV0uras+eRMFgT7
 J5qLt65p
 1xyNFJgXemXnJhEWZK5cqcFSstXHZggby/zWm7WNVt5D2/Gq47eHFBP5OSc/vEv2+7tVkADzRBcusm6+myC6MtOzX5n2PJzkJU16E34e74DA55OvHZpcBdyjlWk6GE93O3gmavivxZ77lCFsf7r/EpZT5nLcOHsPxCmMrTqAHXWMqMmjZM3bxEMsPRD9zF/KjNG8sM+m2lSMHrYCTR5F8QnutnSl0d+vwrNfwrKMlB/kFsrxgHa3pYESIOAT7NtnipkjILLdX8Z1tXm2qiQ5MmJuuVgmhMAvZYw/atSPFx36zcU7U2PFB9bYeVAu7sgbMdxw6ANcia5FiWZyhhTKd6vj5ItDCxrRHDLvxplmilARZA9AwDzPktYVYQ7juknAwyeZ2B5DJ01RIhUmsj0LzBJa6iFcdWYyLWt4P5iRHTRCWpmuo5ZW2Mz2xmY/cO6bKMR1T5G/YvCd3CctbUS7U+JOl1ts1CtY1lEtxU62w+dR0pe+rcY3+cdBQmuxhbSxAVmmCxGTIXPqn8wMyIwIeFynXl5vd0zYx+AIykfPWCtxCsXYXrtkcXiUqB1xS4fUtpqE1xx7qapTH+202kkfTemW0Yd0IsXB+s5JyHRpbjVnPPEDQO3pPaNgmng==
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

Patch 1 is a prep fix: switching a dirty inode away left the old wb
counted in bdi->tot_write_bandwidth. Patch 2 keeps killed wbs in
bdi->cgwb_tree until they are released, so foreign flushes can still
reach them. Patch 3 handles the other way a wb leaves the tree: when a
memcg's blkcg association changes and a new wb takes over the slot, it
switches the old wb's inodes, dirty or not, to the new one.

Based on vfs-7.4.misc, next to Xin Yin's 168a8c13159c, which fixes the
sizing but not the lookup of a removed cgroup's wb. The series also
applies to and was tested on current mainline (d24e8ac715de, 7.3-rc6)
with 168a8c13159c, where patch 2's test gave 1.0s, 1.1s and 1.0s worst
lag. Patch 3's loop follows mainline's 407a5d205179, and mainline's
f6988c90671e bounds its rescans.

Syncing before the removal isn't enough: cleanup_offline_cgwbs_workfn()
skips a dying wb with any dirty inode and only retries on the next memcg
offline. On ext4, syncfs can leave inodes I_DIRTY_SYNC: at 5000 files
one syncfs still stalled in 7 of 9 runs (19-26s worst lag), a second
syncfs avoided it in 5 of 5, and with this series one syncfs lagged at
most 1.5s in 2 of 2. On XFS one syncfs left the wb clean in 5 of 5 runs,
but a single 4KiB append from the old cgroup after it stranded the wb
again (15-28s worst lag, 5 of 5; 1.2-1.6s in 2 of 2 with this series).
In production, our writer synced after closing its data files but before
writing its final Kafka offset to a small shutdown file, and moving the
syncfs after that write mitigated the stall for us on XFS. In the
reproducer, a 14-byte file written after the syncfs stranded the wb the
same way, whether created directly or via a temp file and rename (16-29s
worst lag, 7 of 7; with this series, 1.0-1.4s in 2 of 2 created
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

Tested: arm64 KVM guests (virtme-ng), ext4 and XFS on virtio, on
vfs-7.4.misc and on mainline with 168a8c13159c. No KASAN, lockdep,
PROVE_RCU, DEBUG_LIST, DEBUG_OBJECTS_WORK, DEBUG_ATOMIC_SLEEP or
DEBUG_PAGEALLOC reports, including a stress run toggling io on the
parent of two writers 40 times so their wbs are killed and replaced in
the same slot (240 calls of patch 3's switch, 16200 inode switches,
counted with bpftrace), and the patch 1 and 3 tests in their changelogs.
W=1 and checkpatch --strict clean, no new sparse warnings. All changes
are under CONFIG_CGROUP_WRITEBACK, and only builds with it enabled were
done for v5.

Not tested: x86 runtime, this series in production, linux-next, and
patch 3's fallback for a successor that is already gone (not reachable
on demand; it is cleanup_offline_cgwb()'s loop).

Workaround until this lands: syncfs after the old container's last
write (twice on ext4). Lowering vm.dirty_expire_centisecs from 3000 to
500 cut the worst lag on unpatched mainline to 4.8s, 4.6s and 14.3s, but
did not remove the stall.

Related: without 168a8c13159c the flush is sized from the dead memcg's
own dirty pages, so this only helps while it has some. f6988c90671e
(mainline) also matters: on XFS with 500k synced inodes and the pod
cgroup removed 10s later, the handover was slow enough without it that
the replacement fell 21-22s behind (vfs-7.4.misc), against 1.0-1.2s with
it (mainline), both with v1 of this series.

In patch 3's test all 5001 inodes switched within 30-60ms, and on
mainline the sibling lagged at most 1.3s. As with today's per-inode
switches, switched inodes land at the newest end of the new wb's b_dirty
with their old dirtied_when, so periodic writeback may reach them up to
dirty_expire_centisecs late; background and foreign flushes are
unaffected.

Tejun, I read "fall back to &wb->bdi->wb like cleanup_offline_cgwb()
does" as that function's fallback, the nearest live ancestor's wb and
then the root wb, which keeps dirty inodes under the parent's io limits.
Going straight to the root wb is a three-line change.

Developed with Claude Opus 5.5, which wrote the code, the reproducers
and first drafts of this text, and ran the builds and VM tests. Claude
Fable 5.1 reviewed the code and the claims in this text before v2 to v5
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
Changes in v5:
- New patch 1: clear the old wb's dirty IO state after switching
  inodes (Tejun)
- Patch 2: drop the css_is_dying() check, not needed with patch 3
  (Tejun)
- Patch 3: if the successor is gone, fall back like
  cleanup_offline_cgwb(); report a Tasks-RCU quiescent state per
  pass, as 407a5d205179 does (Tejun)
- Also tested on mainline (7.3-rc6) with 168a8c13159c
- Link to v4: https://patch.msgid.link/20260930-wb-dying-cgwb-flush-v4-0-bde637803a96@honeycomb.io

Changes in v4:
- Don't link a new wb for a dying memcg in cgwb_create() (Tejun)
- Patch 2: switch the replaced wb's inodes to its successor instead
  of kicking writeback (Tejun, Jan)
- Link to v3: https://patch.msgid.link/20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io

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
Liz Fong-Jones (3):
      writeback: clear the old wb's dirty IO state after switching inodes
      writeback: let foreign flushes reach dying cgwbs
      writeback: switch a replaced cgwb's inodes to its successor

 fs/fs-writeback.c                |  65 ++++++++++++++++++++++
 include/linux/backing-dev-defs.h |  14 ++++-
 include/linux/backing-dev.h      |   2 +-
 include/linux/writeback.h        |   1 +
 mm/backing-dev.c                 | 115 ++++++++++++++++++++++++++++++++-------
 5 files changed, 175 insertions(+), 22 deletions(-)
---
base-commit: 168a8c13159c6e3f0f08da6f8fa2f633a91ba9fd
change-id: 20260926-wb-dying-cgwb-flush-06e260e2abad

Best regards,
--  
Liz Fong-Jones <lizf@honeycomb.io>


