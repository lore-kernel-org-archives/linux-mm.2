Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85CB7606A333
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=T7GvXMgx
Received: by kanga.kvack.org (Postfix)
	id 6E0DB6B00EF; Sun, 22 Nov 2026 07:39:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 696C16B05B0; Sun, 22 Nov 2026 07:39:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7A06B05B1; Sun, 22 Nov 2026 07:39:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33CE86B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:39:43 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8CA480680
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:39:41 +0000 (UTC)
X-FDA: 85462711362.14.E121DE4
Received: from mta0.migadu.com (out-2.mta0.migadu.com [91.218.175.2])
	by imf01.hostedemail.com (Postfix) with ESMTP id AB5D940003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:39:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T7GvXMgx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.2 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351180;
	b=wMCriqYc2RJEBiLoJVLzUjo4kSdn3XSt3KKIEWuX6bVleaUHk4DFxUZa96aGZ5H4wqARxE
	FRPCZxxb024ayB3ITsoCtDmRvobjdx4widn2grk+tgwHyKq/RMI3asr3Kzc9Ps8Kmy2tj3
	ggLAysAjymZfvQgP8EC+Ef9oqhP+61o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MjleVL0tqY4h5vvQVikisyp95jaXgvwRJdn4ki2WBHY=;
	b=a3SibBDGwN/iHi2Xc7a68M+1eGTikwMsg9wtte/M/LEFSxQh4Hdbydpzobx+ejvevHYvLR
	EpAKOj5RDUsa1mXpVQQB6tsIwnfTFFGeN9dSoqSrdHf+WKPwa06viNMpkLee3XgK6u3/R3
	G+5KzroGLVJzD8UmG/QodiB1qqOISyA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T7GvXMgx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.2 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Ky7YtxIAbOQTCVzCi1Gw2/0sLzylAhZ+y2+tOAS/5rY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795351178; v=1; x=1795955978;
 b=T7GvXMgxRQa0apTe4L/KHmxRF2BPglsixr0c0mvfzAETVmUwnt6fn+wMOr6LpgQvfLB2Blt2
 oUi2daUTpXo+xzbU1gFY4kHL7aVVfHtRhu5WtN4buL9HGNDDh4pZGS3eIq7LV5V2gX7IR8794ve
 BBYkuFlIft9JX436N3Z29Wu4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id e28ef95bf9ccf3aa;
	Sun, 22 Nov 2026 12:39:38 +0000
X-Mizu-Trace-ID: e28ef95bf9ccf3aa
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	corbet@lwn.net,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	baoquan.he@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v6 00/14] mm, swap: extendable swap devices (xswap phase I)
Date: Sun, 22 Nov 2026 20:39:04 +0800
Message-ID: <20261122123918.3486916-1-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AB5D940003
X-Stat-Signature: ud3pe877wt3kz8gifkanunrw8su3jdsp
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795351179-34783
X-HE-Meta: U2FsdGVkX18nN5hIzu6YbXpMt1qk+Qx3tmTNha3pnWhFMnYwoMgEb2Enk06A1m8T5UZdq74in3gW/dy8GNi5Wa/JunUN0r3cUyBT9dpoO49xxlVqz6j9dZnyA9InK0Vv2BYsnyEGVhq8OqHWFucV1/LtJoZvuU5uyEjyrR+q+/XPdnOH5rdhI09AvnRP1eAgSgUneWJPjt+edSYp18ZN7nkQ7NqMuhlze+NE3VIxHpAHzs80f1ftMyo8jUyPe++QOlCIpiWslDOuo7aBNLoiMdvxe6k/IRI51dtuoK9GK88v/C2gUtpG8hywZqAfQYWW1Z+2+N58lWP5RFABkJ8pJv0R84FUd6BqgBea3NDWVmZpRupcOpLz3t0FuumK734PqgLOBcna4X3rTyuuYOKK5ay9GjbTSu6YVAdR1a2/HPBydbMMPJu9nHvY6ira13wCKWMBLBd62zsBq3yApAOh+QJgRreqDAsGpoHyaYxsmTyjeqU7N3Tx7ymfvbbCdbco72xE2YtyxNyPRN0XY1WrC9SzWoFJkrs56RWfVbvqHvZOC2iInN574A1NSBc9sPjice0Am0jplHtr/Y4mNlPHAsW4/WCHM8t7UaAM31rR5NYmh0fNBRzacFJfUbUSXgUbJSIpgGckgLnrSYxbQwlUa5A13wx/y7UJfJkJvwlcrQ5aTflbh8BDh2s8mRVu2m/P6oKJrZuIDGCX6HKou90mJaaRaWgmFY0YNYV/+4rYHifVxhGEeIgzN3q3g0MgzptYW5dLYOFo+rjQTDUOppBq5POGDGsqKfMZwo+iOkLPTlnE3PjautX3uxBqJ5LUmmr5TRDGDDH6SeUn18G+naReI52LATIcp4jnhY7eUxxvm8fo9GGtg3V3h06/L7wE1sAaw8OQLA+elrYYMoeA5M5siTEdFtHEUFRCIqoUl6pfB2xG58V1o26FDGng+yYroaG+TLLhl09ODM09HrH3xw1
 E7Qy69+c
 pQGbOQWA0xVxq9uADx683GYkWAMPcTvZadRKJR2Z6TsxuqT4y1UO5ZxDAcqG+LM9AWEpb/O/Vxtrk0+6fFpFztwv2q1l/2n92ird/PHWeKItV9M/AyvvX7uPgkwbJbrxE1C60FFNYC98o9WrFQhqits4xJJCoOJq4lgBKEGuWMDyXRLhnnKPZlZ2rLBNK24kGibTcz346Z/qS9ATMmHac3INCojO2zf5MLilyj4+G/rmEywqakp7NRhpb1vsZ0YK9jkEjwgo/JDyilq71DdOQwDnOuWoT6PmAbheF57eHXFRNTqugUoxIY7HnOdmKikcasMsYCXgx2Yq2Mx17/olRRSFapXQYb8IRsVTpQrDTAdkqKIGiOIMgRdl0A8iNLI30SzGS5XMk1euc87dVLvVvs0W82GJLAZ25I3zDcmw0gAoB/EwOTGFXXqco9vb+X3aQAwq7Vq0xbeRER04+wWwJoLkb+fuzeFbNHiax/3FhIxsNlEyq74/KIYgy6qY79SW3iBloUKLIj8qTKosVcGP5hqJ20KO4Jn1Tty00EZ6FDvxS2K9drvfdApVU0FiScjPTRnLG+LgUZPykKRB3qXar+OOUcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

A normal swap device has a fixed size, set when it is enabled. This does
not fit zswap well. With zswap the swapped data stays in RAM in
compressed form, so how much swap a machine can really use depends on
how well the workload compresses, not on a number we pick before we know
the workload. Size the device for the worst case and most of it is never
used; size it for the average case and the machine runs out of swap
while zswap still has free room.

xswap is a swap device with no backing file. In this phase its swap
entries hold pages in zswap, and its cluster_info array lives in a
VM_SPARSE area that is mapped a chunk at a time, so the device covers a
large swap address space and costs only the chunks it has actually
used. The device grows as the workload needs it.

This series is the device itself: the sparse cluster array, growth, and
the interfaces that create and destroy one. It is phase I of five; the
physical backend, the swap accounting, the swap-table backend records,
and the runtime shrink build on it.

Runtime shrink is left for a later series. The plan is to run it only
when the device has nothing live: no entry and no backend record points
into the tail, so no swap reader has to be tracked. It would lower
nr_clusters_mapped under si->lock and unmap the pages behind it; cluster
0 stays mapped because it holds the bad-header slot. The details are
still being worked out. Note that without shrink nothing breaks: the
device keeps the peak range, and only the cluster metadata for that range
stays allocated.

Design notes
------------

In this phase the device is only a swap address space. si->max is set
when the device is created and does not move for its lifetime; what
moves is how much of it is mapped. swap_info_struct carries
nr_clusters_max (the swap address space) and nr_clusters_mapped (how
many clusters are mapped, always from cluster 0). get_swap_device()
rejects an entry past the mapped range, and the walkers that scan a
device stop there.

Growth starts when 85% of the mapped range is in use and maps until
65%. The call comes from the cluster allocation path. Growing maps pages
into the VM_SPARSE area, and mapping can sleep, so it cannot be done
inside the allocation that would otherwise fail: the swap-out path would
then have nothing to fall back on. One grow maps at most four chunks,
and one chunk is PAGE_SIZE / sizeof(struct swap_cluster_info) clusters:
85 with the current struct size. Mapping a chunk and putting its
clusters on the free list happen in one si->lock section, and the larger
nr_clusters_mapped is published after the clusters are linked. An
allocator takes a cluster from the free list under si->lock, so it can
never see a cluster that the published range does not cover, and a
reader can never see an entry in one.

Creation and teardown
---------------------

The device has no path. swapon(2) opens the given name as a path first,
and only when that open fails with -ENOENT is the name taken as a
request name; the exact string "xswap" asks for the file-less device. A
real file or directory called "xswap" keeps precedence, a path that
fails for another reason is returned unchanged, and "./xswap" or an
absolute path is a file as usual. This is the same rule swapoff(2) uses,
and the path is copied from userspace once.

There is one xswap device per system; a second create returns -EBUSY.
/proc/swaps shows it as "xswap", so swapoff xswap and swapoff -a both
tear it down. Its counters are in /sys/kernel/debug/xswap/xswap.stats:

  type 0
  clusters_max 5120
  clusters_mapped 85
  usage_pages 0
  tail_free 84
  grows 0

With xswap.max=10G the device has 5120 clusters (with a 2 MB swap
cluster); an idle device maps one chunk of 85 clusters and the tail scan
leaves 84 of them free.

Hibernation device discovery skips xswap devices: there is no block
device to resume from.

Configuration
-------------

CONFIG_XSWAP depends on SWAP, 64BIT and ZSWAP. CONFIG_XSWAP_DEFAULT_MAX
sets the default size of a new device; it takes a percentage of RAM, a
size, or "max", and defaults to "200%":

  CONFIG_XSWAP_DEFAULT_MAX="200%"

xswap.max= on the kernel command line overrides it:

  xswap.max=8G          8 GiB
  xswap.max=300%        three times RAM
  xswap.max=max         the largest size the device can address

The address space cannot move once the device exists, so the size is
settled at creation. That is why this is a boot parameter and not a
runtime knob. The default priority is the highest, SWAP_FLAG_PRIO_MASK,
so xswap is tried ahead of an ordinary swap device; a lower priority can
be passed in the swapon(2) flags.

The device needs zswap: without it swapout takes a swap entry and frees
no memory, so creating one fails with -EOPNOTSUPP.

A cgroup that cannot zswap (its zswap limit is zero) is not given an
xswap slot; the allocator skips the xswap devices for that folio.

Limitations
-----------

This phase has no physical backend. If zswap refuses a page the folio
stays in memory, so an xswap-only system can run out of memory once the
zswap pool is full. Keep a real swap device on such systems; phase II
adds the physical backend.

An incompressible page is refused for an xswap entry even when the pool
has room. An xswap entry is not put on the zswap writeback LRU in this
phase, so a page stored uncompressed could never be reclaimed. Phase II
gives xswap a writeback target and the page can then be stored and
written back.

xswap does not take large folios in this phase. A large folio goes to
the first device in priority order, so at the default highest priority
it is split into base pages and a lower-priority block device never gets
it whole. Creating the xswap device below a block device avoids the
split, at the cost of trying the block device first. The data is still
swapped, in base pages.

The device does not return its unused tail while it is enabled; destroying
it returns the whole range.

Under extreme concurrency the per-CPU cluster caches can hold all mapped
clusters, so an allocation can fail while page usage is below the grow
threshold. The folio stays in memory; it is not a correctness failure,
but it can look like a false OOM under pressure.

Overcommit
----------

An xswap device advertises its whole swap address space as swap
capacity: si->pages is what /proc/swaps and SwapTotal report, and what
nr_swap_pages uses to decide that anonymous memory can be reclaimed.
The backing is the zswap pool in this phase, and real swap devices in
the later phases; the swap address space is not backing store in either
case, yet it raises the commit limit that __vm_enough_memory() enforces.

Which semantics this should follow is not settled here. Counting the
swap address space lets a workload commit memory it can never back; not
counting it changes what SwapTotal means. swap_info_remove() skips its
commit-limit probe for xswap, so destroying a device does not fail on
headroom the device added and a workload may have committed into, and
real swap devices keep the probe. The limit can then fall below
Committed_AS; new allocations fail until Committed_AS drops. This is
left to a follow-up, together with the rest of the swap accounting.

Testing
-------

QEMU KVM guest, 8G RAM, booted with xswap.max=10G.

The shell's swapon(8) opens the path and reads the swap header itself, so
the util-linux swapon(8) cannot pass the request name through unless it
knows about "xswap"; a matching util-linux change, will be posted separately,
lets "swapon xswap" do it. swapoff(8) passes the name to swapoff(2), so
"swapoff xswap" works as is. Without that change, create the device with a
small helper that calls swapon(2) directly:

  #define _GNU_SOURCE
  #include <errno.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <sys/syscall.h>
  #include <unistd.h>

  #define SWAP_FLAG_PREFER	0x8000
  #define SWAP_FLAG_PRIO_MASK	0x7fff

  int main(int argc, char **argv)
  {
	int flags = 0;

	/* The request name is never a path; stay out of any cwd file. */
	if (chdir("/"))
		return 1;

	if (argc > 1)
		flags = SWAP_FLAG_PREFER |
			(atoi(argv[1]) & SWAP_FLAG_PRIO_MASK);

	if (syscall(SYS_swapon, "xswap", flags)) {
		fprintf(stderr, "swapon(xswap): %s\n", strerror(errno));
		return 1;
	}
	return 0;
  }

  # echo 1 > /sys/module/zswap/parameters/enabled
  # ./xswap_on 100
  # awk 'NR == 1 || /xswap/' /proc/swaps
  Filename                Type        Size        Used        Priority
  xswap                                   xswap        10485756    0        100

A functional tests reports 30 checks passed and 0 failed; the
overcommit case was run separately with vm.overcommit_memory=2:

  - create and read the size; SwapTotal stays fixed and SwapFree stays
    in [0, SwapTotal]
  - grow past RAM; stop at the device size (the cgroup runs out of room
    and the OOM killer takes the workload)
  - an incompressible page is refused and stays resident
  - a cgroup that cannot zswap gets no xswap slot
  - swapoff xswap, swapoff -a, and a recreate at the same size
  - 2000 create/destroy cycles
  - overcommit: with vm.overcommit_memory=2, 8.15G of RAM and
    overcommit_ratio 50 (CommitLimit 14.56G, Committed_AS 4.65G), a
    10.49G device and its swapoff both succeed

The functional matrix, the swapoff name cases and the 2000-cycle leak
test were re-run on this rebase (7.4.0-rc3, mm-new). The latter two
ran on a kernel with the later phases applied; they still only cover
code this series adds:

  - swapoff name semantics, 11 cases: a real file keeps precedence, a
    dangling symlink reaches the device, a directory is EISDIR, only the
    exact name is accepted, a stale name reports ENOENT, -a tears it
    down, and destroying with pages live keeps the workload alive
  - 2000 create/destroy cycles: no per-cluster state is leaked (largest
    slab growth 115 objects; vmap_area's +613 is the known lazy
    vmap_area freeing)

Performance: the numbers below were taken with the complete queue on an
x86-64 server (2 nodes, 72 CPUs, 252 GiB of RAM), on 15f114dac9a7
(mm-new, 7.4.0-rc3), against the same tree without the series. The
pageout run and the usemem split were reproduced on the posted base; the
pool peaks quoted are from the earlier run.
They are repeated here only to show where the series leads; each later
series reports the measurements that belong to it.

  - 128 GiB MADV_PAGEOUT, 144 threads, interleaved NUMA, two boots with
    five rounds each: 86,594 vs 87,026 instructions per swapped page
    (+0.5%), 3,280 vs 3,287 MB/s pageout (equal), and about 40 seconds
    of pageout on both. The instruction difference is at the level of
    the run-to-run spread. The same run on an earlier rebase (67f3b04b)
    measured 87,999 vs 86,818 instructions per page (-1.3%) with the
    same pageout rate; the signed difference moved between -1.3% and
    +0.5% across the mm snapshots, with no change in the pageout rate.
    Wall time is about 8% lower with xswap in both rebases, but the
    pageout phase itself is unchanged; the difference lies outside it
    and is not attributed here.

  - usemem, 64G touched in a 48G cgroup with no real swap device: under
    cgroup memory pressure the same-base kernel writes 3.62M pages
    (14.8 GB) back to a swap file every round, while xswap keeps all
    6.83M pages in zswap and writes nothing back (zswap pool peak 10.6
    vs 1.8 GiB). That is the phase I trade-off: without a physical
    backend, the capacity is the zswap pool.

  - Kernel build under memcg pressure: 1G memcg, 40 jobs, one 72-CPU
    host, two runs each. Both kernels are the same tree; one has the 46
    commits and the other does not. "No writeback" is the cgroup knob
    memory.zswap.writeback=0, set the same way for both.

      config                elapsed        major faults/run  zswap peak
      xswap, no writeback   3:44 / 3:44    63M               186 MB
      base,  no writeback   3:50 / 3:50    63M               175 MB

    With the same zswap knobs the series is 2.5% faster on this workload
    (3:44.4 vs 3:50.2; the two runs of each kernel are within 0.3%), with
    the same major faults per run and a zswap peak 6% higher.

Change log
================

v5 can be found here:

[PATCH v5 00/19] mm, swap: extendable swap devices (xswap phase I)
https://lore.kernel.org/all/20261109055455.536925-1-baoquan.he@linux.dev/T/#u

v5->v6:

- Rebased onto 15f114dac9a7 (mm-new, 7.4.0-rc3).

- The device is created and destroyed through swapon(2)/swapoff(2) with
  the request name "xswap" instead of the sysfs create/destroy interface
  and the per-boot stable id. There is one device per system; /proc/swaps
  shows "xswap"; the counters are one debugfs file, xswap.stats.

- The request name is only tried after the path open fails with -ENOENT,
  so a same-named file or directory keeps precedence, as it does for
  swapoff. Only the exact name matches, and the path is copied from
  userspace once.

- An empty path is rejected before the request-name fallback, in both
  swapon(2) and swapoff(2). (Sashiko, v5 12/19)

- Runtime shrink moved out of the series to phase V.

- An incompressible page is refused for an xswap entry. The entry never
  reaches the writeback LRU in this phase, so a page stored uncompressed
  could never be reclaimed. (Sashiko, v5 01/19)

- A VMA readahead skips a cross-device xswap neighbour instead of
  reading it out of zswap. (Sashiko, v5 01/19)

- The zswap writeback worker stops when memcg is disabled and nothing on
  the LRU can be written back, instead of spinning. (Sashiko, v5 01/19)

- A large folio that only an xswap device could take, in a cgroup that
  cannot zswap, fails with -ENOMEM instead of -E2BIG, so the caller does
  not split it and retry every base page. (Sashiko, v5 18/19)

- A grow links the new clusters and publishes the larger mapped range in
  one si->lock section, so an allocator cannot see a cluster that the
  range does not cover and a publish never leaves a mapped range with no
  allocatable cluster.

- Because of the shrink split, the grow threshold comment and the
  debugfs counters no longer mention the shrink, and the counter for it
  is not added here.

Baoquan He (13):
  mm/vmalloc: support vmalloc-backed VM_SPARSE areas
  mm, swap: refactor free_swap_cluster_info to take swap_info_struct
  mm, swap: use a VM_SPARSE cluster array for xswap devices
  mm, swap: widen swap_info_struct max/pages to unsigned long
  mm, swap: create the xswap device from swapon(2)
  mm, swap: refactor swapoff and add xswap_destroy
  mm, swap: require zswap for xswap devices
  mm, swap: let the command line set the xswap device size
  mm, swap: add CONFIG_XSWAP_DEFAULT_MAX
  mm, swap: add xswap grow trigger on cluster allocation
  mm, swap: add debugfs counters for xswap
  mm, swap: do not give an xswap slot to a cgroup that cannot zswap
  mm, swap: skip the overcommit probe when removing xswap

Chris Li (1):
  mm: xswap support for zswap

 .../admin-guide/kernel-parameters.txt         |    9 +
 include/linux/swap.h                          |   15 +-
 include/linux/vmalloc.h                       |    2 +
 mm/Kconfig                                    |   20 +
 mm/page_io.c                                  |   13 +
 mm/swap_state.c                               |   24 +-
 mm/swapfile.c                                 | 1026 +++++++++++++++--
 mm/vmalloc.c                                  |  149 ++-
 mm/zswap.c                                    |   34 +-
 9 files changed, 1183 insertions(+), 109 deletions(-)


base-commit: 15f114dac9a7bde1796f0e54e22726fd31cfa8a5
-- 
2.54.0


