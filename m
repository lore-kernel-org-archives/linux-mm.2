Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63A1F60A382A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nhgEZOPf
Received: by kanga.kvack.org (Postfix)
	id 801516B05BD; Tue, 10 Nov 2026 09:43:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8996B05BE; Tue, 10 Nov 2026 09:43:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C8716B05BF; Tue, 10 Nov 2026 09:43:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49B826B05BD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:43:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA875140895
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:43:21 +0000 (UTC)
X-FDA: 85419477402.11.A844DBD
Received: from mta1.migadu.com (out-124.mta1.migadu.com [95.215.58.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4D6F820002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:43:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nhgEZOPf;
	spf=pass (imf31.hostedemail.com: domain of qiliang.yuan@linux.dev designates 95.215.58.124 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794321800;
	b=rhVaVHnldCHZcNvx1wKHK9B/bMguI5l4kupLPn82jQPUb4K1qAnLjqeKd7HmeEqEdhDPxr
	fQmyQX4toLdBmcWZLFYQ5kH7NT3oaiiOClWpPqlQh11bPS5ZB2I85UDI2vX8eziIxHKJuo
	T9LYlKyD2JR79q3T3/eJ7G0bbh3k+z8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nhgEZOPf;
	spf=pass (imf31.hostedemail.com: domain of qiliang.yuan@linux.dev designates 95.215.58.124 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794321800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ONtiqfBY7XF9tcsGZa6BGd36+aq3hcBRWhYmk4rQLvM=;
	b=gnfORaQGRuQ+yp9ZQUo+EZvNHnKYDivCPDUlHHXSObohMoIFvzdOmIMtNszbT55DDQcrSH
	GWsvYP3GS0Tlaqe6XaL9N34yhvArk6jU7oHsh68Rt30uiCYqbzmt8KRSXWSX1GyXntOd/b
	/14P8rmC/yGFLMYi/O9ZTT5XPqYA3i4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=x8taPRgwxDpWF2n1mLGTs5sZSctanW78ZPHgi3RsjbQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794321796; v=1; x=1794926596;
 b=nhgEZOPfXyqrxK2Kd1sLKf8FyfBDXX+1LFf24hZCfiaUOAcahMUM/FDuRhq2kChjnO9QxCA3
 lyrgx86DoLqc/s3VNrURV0k2XAzR56ufMbKCCTkYAglq/+K4rUsrFx9lcize8UCNPNOl/57UMWH
 K6rC3IhRAMJ4Cd+6mwySI7xQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c0dc64717c01038c;
	Tue, 10 Nov 2026 14:43:16 +0000
X-Mizu-Trace-ID: c0dc64717c01038c
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Qiliang Yuan <qiliang.yuan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/compaction: defer failed async direct compaction
Date: Tue, 10 Nov 2026 09:42:56 -0500
Message-ID: <20261110144256.3841504-1-qiliang.yuan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102-bug-mm-thp-async-compact-defer-v2-2-b407e974db54@gmail.com>
References: <20261102-bug-mm-thp-async-compact-defer-v2-0-b407e974db54@gmail.com> <20261102-bug-mm-thp-async-compact-defer-v2-2-b407e974db54@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4D6F820002
X-Stat-Signature: zfockatxth8hj9z4tmg9e996nj11xdfg
X-Rspam-User: 
X-HE-Tag: 1794321798-77590
X-HE-Meta: U2FsdGVkX19IBn//5BzGA4Lh4/8nY+XMTAnXbmHX2Vu5bd6zOE5aowzfILjS78CePXX6rFnQDw7yHkvlzh18VtdW2+253b6qj99LBpeqrGTqovWED1nU5WaJEgw1kwvUv7Lu7VnWth/ukeJ63VL9DNagVankk4qt4bRNN1fKsOevPOluSbubngtQxJBa+KpanT6CmL0o1WOUchfn33Jt2zgAy2G+9HXRtytqIId08+taK+iYfADff63zy8btB7Xb9mcUlrjCOXthms1ZnbRkHPxzUuW88VBLJUTkt4S6gV74wao/zBFumQt4vbNdSGKYpkbsBfZN+KmPnNbXwIeSyYhS4CmPheEYmkPDMigCi/3Wsjaagq8fC9SFohc3DyuMjLckA8/nmzJC07jEqq9ePY4/kVkjBy79YHWP61SWdXyp2rf42/rhLvuy0VrMvrQ1NOZK+7eVjL2+6Qc7R/sG2zsno8DKb1pWrqHfQQXHZvzFNCs4aUoYzMvTylOBB0hMJdfpszfBclgUuEo0+YEncMCIEMraFlhdXBM8Lg8Ex6WyTyGg91c8UCJWq27SW1qbBA093SFzsG8s8bPLvMK/pRgxLBwYiUZZBYDKOJ0cfShe2SbtTKOfBHJkGe45eJdqx7iXEMxH/IIsGnvfGkjHHIOyIZkhyaCTvQSCRuhFwdLFE36QPqTQWV5jZ6OCSohH7w+YBWGjJhKUNa5Fgd+m8HBJOeuCWMCRb5RijFh7Vt6FBJfMAS+IMkZM7QeMsAAdAe3B57bzLNLOTom7CCIp/N8Nzhbe4Juyc/EXdmfof95HVK6vNOXZUTjovpjLVxXwUWLt9ZW/6ckRYSBK30HRHsEv3tLOkNwlSDAFTkbbtDUaNfu+gVKmHrT3/Njr9aRfArwyw2AuuPsYKmNS3MG8LZAfKCQ68lwqtFXMSYAj9Khd1y8zTS2duThRb6P36QwqMutkYTRI2vfxh94ZmR9
 7LQUI9FK
 MAPeeMd9ksKb9Jcux+RJfKvWLZxUTyueYWURpNX6ycoonBRQsh37dkCIU3KHFU6zrvqvjoNw71wYqHsxaGwZKsLzecCm5g/2jBE1Thk2rn/1QJrANpz5QddIBgRWT4LmQhZOg5k5ea6ru4t2ho9PqfPRFckeKL6HPPjK7w3ZLsj93NZ+vENr9PUOuKsVbotdIC1U2dQeS74ZykcGHEr3Ivf9reo+ysQs+VCxs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 01:01:08 -0500, Qiliang Yuan wrote:
> @@ -2600,9 +2600,12 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
>  
>  	/*
>  	 * Clear pageblock skip if there were failures recently and compaction
> -	 * is about to be retried after being deferred.
> +	 * is about to be retried after being deferred. Leave this to sync
> +	 * compaction: async compaction relies on the skip hints, and clearing
> +	 * them on its retries would rescan the whole zone each time.
>  	 */
> -	if (compaction_restarting(cc->zone, cc->order))
> +	if (cc->mode != MIGRATE_ASYNC &&
> +	    compaction_restarting(cc->zone, cc->order))
>  		__reset_isolation_suitable(cc->zone);

As was pointed out to me off-list, this test removes a recovery path.
I'm not asking to reconsider the series, only leaving the analysis and
a reproducer here in case they help when you look at the issue.

The async run a THP fault does on the local node is never deferred:
try_to_compact_pages() calls defer_compaction() only for sync
priorities, because the deferral state is shared and deferring it
after an async failure would defer sync compaction too. The async path
checks that same sync state in compaction_deferred(), so as long as
sync isn't deferred, every fault scans the zone again. Patch 1 splits
the state so that async can be deferred on its own.

Skip hints are cleared in two places: in compact_zone(), when
compaction_restarting() sees the sync deferral at its maximum, and by
kswapd before it sleeps. Madvised THP faults don't wake kswapd, and
with proactive compaction off nothing else resets the hints, so once
the pinned pages become movable again, the reset in compact_zone() is
what lets local THP attempts use those pageblocks. After sync reaches
the maximum deferral, that reset comes from an async retry, which is
what the test in this patch blocks.

I reproduced it on the same QEMU guest as the series: 32 vCPUs,
node 0 with 16 CPUs and 24 GiB, node 1 with 16 CPUs and 8 GiB,
compaction_proactiveness set to 0 and defrag left at madvise:

  1. Fill node 0 with anonymous memory, free every other 4K page and
     long-term pin the rest through io_uring fixed buffers.
  2. With defrag set to always, fault in a 1 GiB MADV_HUGEPAGE buffer
     bound to node 0, so THP faults there run sync direct compaction
     and fail until sync compaction reaches the maximum deferral.
  3. Close the io_uring rings. The pins are gone, the memory stays in
     use and is movable again.
  4. Populate a 4 GiB MADV_HUGEPAGE buffer from a CPU of node 0.

Compactions that succeeded in step 4, one boot per number:

  mainline              1184, 963
  v2                    8, 0, 516, 400, 534, 521, 495
  v2 without the test   1025, 994, 906, 957

v2 recovered in five of seven boots without resetting any skip hint
(no call to __reset_isolation_suitable() in the two boots I traced):
with async compaction deferred, it scans few pageblocks while they are
pinned and leaves most of them unmarked. In the other two boots the
marked pageblocks kept it from recovering at all. Without the test,
the reset after the maximum sync deferral recovers every boot, as on
mainline, and the steady pinned case stays as cheap as with v2 (7.8
to 20 ms in compaction against 310 to 332 ms on mainline).

The reproducer is below, run as CPUS=0-15 sh thp-recover.sh.

Thanks,
Qiliang

---8<--- thp-recover.sh
#!/bin/sh
# Run as root on a two-node machine; CPUS lists the CPUs of node 0.
CPUS=${CPUS:-0}
D=/sys/kernel/mm/transparent_hugepage/defrag
echo 0 > /proc/sys/vm/compaction_proactiveness
echo madvise > $D
echo 1 > /proc/sys/vm/drop_caches

M=/sys/devices/system/node/node0/meminfo
free=$(awk '/MemFree/ { print int($4 / 1024) }' $M)
./thp-recover hog $((free - 300)) > hog.log &
hog=$!
until grep -q ready hog.log; do sleep 1; done

echo "steady, pinned:"
for i in 1 2 3; do taskset -c $CPUS ./thp-recover fault 4096; done

# Fail sync compaction on node 0 until it reaches the maximum deferral
echo always > $D
echo "bound to node 0:"
taskset -c $CPUS ./thp-recover bfault 1024
echo madvise > $D

kill -USR1 $hog
until grep -q unpinned hog.log; do sleep 1; done
echo "after dropping the pins:"
for i in 1 2 3 4 5; do taskset -c $CPUS ./thp-recover fault 4096; done
kill $hog

---8<--- thp-recover.c
// SPDX-License-Identifier: GPL-2.0
/*
 * thp-recover hog <mb>     fill node 0, free every other page and long-term
 *                          pin the rest; SIGUSR1 drops the pins and keeps
 *                          the memory in use
 * thp-recover fault <mb>   populate a MADV_HUGEPAGE buffer and print how
 *                          much of it got THPs and on which node
 * thp-recover bfault <mb>  the same, bound to node 0
 */
#define _GNU_SOURCE
#include <linux/io_uring.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <sys/uio.h>
#include <time.h>
#include <unistd.h>

#define MB		(1UL << 20)
#define MPOL_BIND	2
#define RING_BUFS	16384

static volatile sig_atomic_t unpin;

static void on_usr1(int sig)
{
	unpin = sig;
}

static void bind_node0(void)
{
	unsigned long mask = 1;

	if (syscall(__NR_set_mempolicy, MPOL_BIND, &mask, 64))
		perror("set_mempolicy"), exit(1);
}

static long vmstat(const char *key)
{
	char name[64];
	long v, ret = 0;
	FILE *f = fopen("/proc/vmstat", "r");

	while (f && fscanf(f, "%63s %ld", name, &v) == 2)
		if (!strcmp(name, key))
			ret = v;
	if (f)
		fclose(f);
	return ret;
}

static long thp_mb(void)
{
	const char *key = "AnonHugePages:";
	char line[256];
	long kb = 0;
	FILE *f = fopen("/proc/self/smaps_rollup", "r");

	while (f && fgets(line, sizeof(line), f))
		if (!strncmp(line, key, strlen(key)))
			kb = atol(line + strlen(key));
	if (f)
		fclose(f);
	return kb / 1024;
}

static int hog(size_t size)
{
	size_t npages = size / 8192, done = 0, i, off;
	struct iovec *iov = calloc(RING_BUFS, sizeof(*iov));
	int fds[4096], nr = 0, r;
	char *buf;

	bind_node0();
	buf = mmap(NULL, size, PROT_READ | PROT_WRITE,
		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	madvise(buf, size, MADV_NOHUGEPAGE);
	memset(buf, 1, size);
	/* Plenty of free memory, but no free 2M block */
	for (off = 4096; off < size; off += 8192)
		madvise(buf + off, 4096, MADV_DONTNEED);
	/* Long-term pin the pages left, as RDMA registration does */
	while (done < npages) {
		struct io_uring_params p = { 0 };
		size_t n = npages - done > RING_BUFS ? RING_BUFS : npages - done;
		int fd = syscall(__NR_io_uring_setup, 4, &p);

		for (i = 0; i < n; i++) {
			iov[i].iov_base = buf + (done + i) * 8192;
			iov[i].iov_len = 4096;
		}
		if (fd < 0 || syscall(__NR_io_uring_register, fd,
				      IORING_REGISTER_BUFFERS, iov, n))
			perror("pin"), exit(1);
		fds[nr++] = fd;
		done += n;
	}
	printf("ready\n");
	fflush(stdout);
	signal(SIGUSR1, on_usr1);
	while (!unpin)
		pause();
	for (r = 0; r < nr; r++)
		close(fds[r]);
	printf("unpinned\n");
	fflush(stdout);
	for (;;)
		pause();
}

static int fault(size_t size)
{
	size_t n = size / (2 * MB), i, node[2] = { 0 };
	long stall = vmstat("compact_stall"), ok = vmstat("compact_success");
	void **pages = malloc(n * sizeof(*pages));
	int *status = malloc(n * sizeof(*status));
	struct timespec t0, t1;
	double ms;
	char *buf;

	buf = mmap(NULL, size + 2 * MB, PROT_READ | PROT_WRITE,
		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	buf = (char *)(((unsigned long)buf + 2 * MB - 1) & ~(2 * MB - 1));
	madvise(buf, size, MADV_HUGEPAGE);
	clock_gettime(CLOCK_MONOTONIC, &t0);
	for (i = 0; i < size; i += 4096)
		buf[i] = 1;
	clock_gettime(CLOCK_MONOTONIC, &t1);
	ms = (t1.tv_sec - t0.tv_sec) * 1e3 + (t1.tv_nsec - t0.tv_nsec) / 1e6;

	for (i = 0; i < n; i++)
		pages[i] = buf + i * 2 * MB;
	syscall(__NR_move_pages, 0, n, pages, NULL, status, 0);
	for (i = 0; i < n; i++)
		if (status[i] == 0 || status[i] == 1)
			node[status[i]]++;
	printf("%zu MB in %.0f ms, %ld MB in THPs, 2M ranges on node 0/1: %zu/%zu, ",
	       size / MB, ms, thp_mb(), node[0], node[1]);
	printf("compactions: %ld, succeeded: %ld\n",
	       vmstat("compact_stall") - stall, vmstat("compact_success") - ok);
	return 0;
}

int main(int argc, char **argv)
{
	size_t size;

	if (argc != 3) {
		fprintf(stderr, "usage: %s hog|fault|bfault <mb>\n", argv[0]);
		return 1;
	}
	size = strtoul(argv[2], NULL, 0) * MB;
	if (!strcmp(argv[1], "hog"))
		return hog(size);
	if (!strcmp(argv[1], "bfault"))
		bind_node0();
	return fault(size);
}

