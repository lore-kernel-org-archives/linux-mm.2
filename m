Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF0D2FF8860
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 11:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33F466B0093; Sun, 26 Apr 2026 07:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C85D6B0095; Sun, 26 Apr 2026 07:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1694D6B0096; Sun, 26 Apr 2026 07:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00FAE6B0093
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 07:56:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B285E4060A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 11:56:56 +0000 (UTC)
X-FDA: 84700555632.03.1CF3E1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id EFFAD40008
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 11:56:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CC/YcSoD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777204615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NvGZvTit94zeupT5noPQReXjBUXfyG+hqS0xbuEAo60=;
	b=ztmSfuGV0LHUvwmPxMytssqxEp5e4kWUsVvE0pZ+X1gDnob/ZLx1D3bDgydHON2hbjTCfx
	57vDxuSsV+BE4UBhOumhXZhM2E2Har70Gs45BBny5wWNsxqonQd6+fVB5Am5UfGEQjHpJk
	uObolHszTB+O85hLKMaU/SYt5qcWn8A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777204615; a=rsa-sha256;
	cv=none;
	b=2Tj0s+tD1Jf2DZaE2g2gnNMC/G+IGct80bOjfdKm6ym8y/oHYkxunhJMNjDEubkqXkz/88
	1kIShfGXFPNhsPe1eY3ujz0AE9gvkxGnUH+1moWNU+7TjwQIw7RvSqpuEFwAPewoSdsqTo
	AgV296SF4kZ+zCKtT6yDSl0tQKMBSN4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CC/YcSoD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 01A93600AE;
	Sun, 26 Apr 2026 11:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4117C2BCB6;
	Sun, 26 Apr 2026 11:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777204613;
	bh=t/R0Lqby4vE+4rsuqjribBP4UQlS9qH9tnTihBcaNTk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=CC/YcSoDBgO7YOw6BcnnYzyAZtNOxzfHE4E9/G+4rW16ARliUxxBsvxPj000g4eQJ
	 CW2uWFVaZ28PcNuNOoltyy6EBZwyGStqX5RXMfU9w6MHSYV0uamw3lwKqxjM30kl2i
	 jRnRC7ONUON6BAEmMFQqYJyMew4Q2gTGhc/aSyr69H8hKchUZeYxJLwPZHV+5CGUvy
	 GzUaLm+VrQHq+I/kZBxHD8d5rm5cS2ju1VpIAdZ6yoSb0hvPq3vAks+uSu83RUm4gm
	 SqNp8sSBj3O7/Z9pEH/hw9Lj/t7aWf26PNzf87Kpnn9bCwkbVzHJXBdpZ7ByshA+l2
	 wrtdpgSTuFBtQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Sun, 26 Apr 2026 07:56:10 -0400
Subject: [PATCH v3 4/4] testing: add dontcache-bench local filesystem
 benchmark suite
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260426-dontcache-v3-4-79eb37da9547@kernel.org>
References: <20260426-dontcache-v3-0-79eb37da9547@kernel.org>
In-Reply-To: <20260426-dontcache-v3-0-79eb37da9547@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Ritesh Harjani <ritesh.list@gmail.com>, 
 Christoph Hellwig <hch@infradead.org>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
 linux-trace-kernel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=28555; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=t/R0Lqby4vE+4rsuqjribBP4UQlS9qH9tnTihBcaNTk=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBp7f102l7Yh4nSLrER4g/6pBLdkja4EDvtu3fKJ
 pXCVH8/RK6JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCae39dAAKCRAADmhBGVaC
 FX7KD/9PRhQbbIAwPAsF7EPip+54p2ogFRLNciGY2ob3lHYxLUQ642jZ+rVbRdTvsZsnILwifvb
 66IfHoSorFbeqEDkokKtG5fgW3HH4oms4ZVnQRKgs5LOc1rZTXvJdD2k9TnMbt42WWX5cnBtkRq
 EB720xJD+T8mqbl9J0M+i19FgFlIId4Ev8CmyYpbUgv6ywDpZYNna8kWbB0lSlc3/qlYU/5I3ps
 WT4RDCaCWSVg6AfRQg/pTzrV+g6/I7Eponq/k5QHPeZHbL/LUNK1Tz9iP3zHGBLkPF+vuBaIrxP
 ujey+Rk+7W3FNWEgjDZZSjYdtP7b5n7No5WRXdIhxS3/4MYe4uG0QdbBsFC48MEj/q1Emmm/iYs
 p+TCFi1bqukjwsIdUdaMljydfEjMq0iXimszI7Cwj4wneyfxZKRm6XK5+SDHBSQ52JZnE3Y+LZz
 vGJD1cWtkTQCdAB9K6KfRmCsdn8tIgpCYfvGIZPJuvrKglrpvrbIsRhgF0od2+14qSdgGwkEtD5
 Gfo9NCvmjJtcy+NFY4nS70CADywPPGJ7x/CQbluvT47keNqsHhw+ZzHif+zHJ6Mmwrnw/0j0PGO
 HN+qKU+RlV5O05bkBbPN7EDfZs01kAhAjE0qOuSX1ONzHMX/sqjofNZtNMJZhilnkQXMuaRZTiJ
 PPiWK8v0vmXURWw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Queue-Id: EFFAD40008
X-Rspamd-Server: rspam04
X-Stat-Signature: uag4agwcabqrdfbjjxz6jjoeitj7r6r9
X-HE-Tag: 1777204614-358790
X-HE-Meta: U2FsdGVkX1+Foz6i5VajAoQq982HA0bWd0W7WxjwaDhYIBfClir9fGTqAb2tIrBn1U0CxyMeJL5kGt9+hBpuu7Ue7vTX5bwrpri4ONmy3BniH+QaHQ4Psc0qQrbYWhpOAeftG0mjq7byJQepBHUzMbIob0OCth+1k2UBsU4zgfeflPavRXLHXXHQqjyFC5iv9p7sHVW2uD27h9Hbsi3oFZY7roievZIYGceyeEZn8a1USMfYbok8kWFmBYKrvChimGAMQomphLOsWCXCTwwq+4D2aWvCcwmhfPPKRKLoR/aYrvyZSC1TvWACUdeEYveER5x0ekK2xQbDvFBBlD5lD0hdmhsFDyfeZ4IvZFjcy/neFo/IxKJHc4YKEmFg70LUaCaRWH01NgbaZK1eWZKgPq1QgG8MbtBoP0A9xzqpDwZEvjxZ5RxPtBnyTsRMuSahFlPB2oisehgjYQT/Ffaa4LTeq5InW/t5NHks8ZqSZKq0q8Ym5kILq0PACPyYBfNxPpxDP6lySFnUTl4DOEhasvnZp9D4v16QiMYaTl6DGgQXhk6EXbys0i6Lx8rm2ZV5GdHODhti/MsLpFxlqe6QXjL/HFYcRTrZKLzCqtprcwTzecr1GlDEO6fbKaHRugTtEeDaW65D2eiqMvxRI4B5dtIJwNeyRX2rbcnZzNkIEVhrMMbcrn4BxZAT62FSWZep8kpYxqsMoOPEj2ZObHt5Vd/lkJBe8R3eBBdmbDqCdrsgDlarZQwpzwKTxnOPBbDExjU4aEyMFOgSr/1vXeeiHtZfTvfop6a5mU1vt1tzqMIqrIReBVucQ95skC4hC2X9/FsafzIlHARkXpfpv17yMNrYkWXoNyupwQBQvyRkcm0qVFWOSsMbKG3NC9e58J9G2WqxVOoQJOQCAmSbewYZESRbXwPw7zYAPrSFCkxbVlshAyi+kkFoTgOp1wQPfujxet8a6PmO4RTY4dcN7ZE
 DrHuZRj5
 2Cgc2o82rXWSVyJc1MiZXZ8cnj8kAFWKIO5EiSNq7uzQEfKPEQWvz1Nq5be0JWV9Jh1tzzimYnS7YY/3jZC7//BMNQKxyn2y6EA69GIiRQRopTH/Vi6pH9NZaje7vHPlO/MjIraT6eibRDhjZRdA/wN0oqMJxipIkXRkVY0eDWXTZKE4kGY4dgFrYMeUqVUgifSc0dzFvaTPcRdcSZzeSvtxlkcTKTY+qvrAKrJ1vSGEAHg8nLZL8JYFR9uET7/wz2gjdYMTfr/LCL5syDle4Kpbuh1IZpGTqQmd/tt0ZXTCiCWZcjPuAwNMwtlfIltkve13iTiUmM9QR0ClXE4uQkPXgJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a benchmark suite for testing IOCB_DONTCACHE on local filesystems
via fio's io_uring engine with the RWF_DONTCACHE flag.

The suite mirrors the nfsd-io-bench test matrix but uses io_uring with
the "uncached" fio option instead of NFSD debugfs mode switching:
 - uncached=0: standard buffered I/O
 - uncached=1: RWF_DONTCACHE
 - Mode 2 uses O_DIRECT via fio's --direct=1

Includes fio job files, run-benchmarks.sh, and parse-results.sh.

Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 .../dontcache-bench/fio-jobs/lat-reader.fio        |  12 +
 .../dontcache-bench/fio-jobs/multi-write.fio       |   9 +
 .../dontcache-bench/fio-jobs/noisy-writer.fio      |  12 +
 .../testing/dontcache-bench/fio-jobs/rand-read.fio |  13 +
 .../dontcache-bench/fio-jobs/rand-write.fio        |  13 +
 .../testing/dontcache-bench/fio-jobs/seq-read.fio  |  13 +
 .../testing/dontcache-bench/fio-jobs/seq-write.fio |  13 +
 .../dontcache-bench/scripts/parse-results.sh       | 238 +++++++++
 .../dontcache-bench/scripts/run-benchmarks.sh      | 562 +++++++++++++++++++++
 9 files changed, 885 insertions(+)

diff --git a/tools/testing/dontcache-bench/fio-jobs/lat-reader.fio b/tools/testing/dontcache-bench/fio-jobs/lat-reader.fio
new file mode 100644
index 000000000000..e221e7aedec9
--- /dev/null
+++ b/tools/testing/dontcache-bench/fio-jobs/lat-reader.fio
@@ -0,0 +1,12 @@
+[global]
+ioengine=io_uring
+direct=0
+bs=4k
+numjobs=1
+time_based=0
+rw=read
+log_avg_msec=1000
+write_bw_log=latreader
+write_lat_log=latreader
+
+[latreader]
diff --git a/tools/testing/dontcache-bench/fio-jobs/multi-write.fio b/tools/testing/dontcache-bench/fio-jobs/multi-write.fio
new file mode 100644
index 000000000000..8fc0770f5860
--- /dev/null
+++ b/tools/testing/dontcache-bench/fio-jobs/multi-write.fio
@@ -0,0 +1,9 @@
+[global]
+ioengine=io_uring
+direct=0
+bs=1M
+numjobs=1
+time_based=0
+rw=write
+
+[multiwrite]
diff --git a/tools/testing/dontcache-bench/fio-jobs/noisy-writer.fio b/tools/testing/dontcache-bench/fio-jobs/noisy-writer.fio
new file mode 100644
index 000000000000..4524eebd4642
--- /dev/null
+++ b/tools/testing/dontcache-bench/fio-jobs/noisy-writer.fio
@@ -0,0 +1,12 @@
+[global]
+ioengine=io_uring
+direct=0
+bs=1M
+numjobs=1
+time_based=0
+rw=write
+log_avg_msec=1000
+write_bw_log=noisywriter
+write_lat_log=noisywriter
+
+[noisywriter]
diff --git a/tools/testing/dontcache-bench/fio-jobs/rand-read.fio b/tools/testing/dontcache-bench/fio-jobs/rand-read.fio
new file mode 100644
index 000000000000..e281fa82b86a
--- /dev/null
+++ b/tools/testing/dontcache-bench/fio-jobs/rand-read.fio
@@ -0,0 +1,13 @@
+[global]
+ioengine=io_uring
+direct=0
+bs=4k
+numjobs=1
+iodepth=16
+time_based=0
+rw=randread
+log_avg_msec=1000
+write_bw_log=randread
+write_lat_log=randread
+
+[randread]
diff --git a/tools/testing/dontcache-bench/fio-jobs/rand-write.fio b/tools/testing/dontcache-bench/fio-jobs/rand-write.fio
new file mode 100644
index 000000000000..cf53bc6f14b9
--- /dev/null
+++ b/tools/testing/dontcache-bench/fio-jobs/rand-write.fio
@@ -0,0 +1,13 @@
+[global]
+ioengine=io_uring
+direct=0
+bs=4k
+numjobs=1
+iodepth=16
+time_based=0
+rw=randwrite
+log_avg_msec=1000
+write_bw_log=randwrite
+write_lat_log=randwrite
+
+[randwrite]
diff --git a/tools/testing/dontcache-bench/fio-jobs/seq-read.fio b/tools/testing/dontcache-bench/fio-jobs/seq-read.fio
new file mode 100644
index 000000000000..ef87921465a7
--- /dev/null
+++ b/tools/testing/dontcache-bench/fio-jobs/seq-read.fio
@@ -0,0 +1,13 @@
+[global]
+ioengine=io_uring
+direct=0
+bs=1M
+numjobs=1
+iodepth=16
+time_based=0
+rw=read
+log_avg_msec=1000
+write_bw_log=seqread
+write_lat_log=seqread
+
+[seqread]
diff --git a/tools/testing/dontcache-bench/fio-jobs/seq-write.fio b/tools/testing/dontcache-bench/fio-jobs/seq-write.fio
new file mode 100644
index 000000000000..da3082f9b391
--- /dev/null
+++ b/tools/testing/dontcache-bench/fio-jobs/seq-write.fio
@@ -0,0 +1,13 @@
+[global]
+ioengine=io_uring
+direct=0
+bs=1M
+numjobs=1
+iodepth=16
+time_based=0
+rw=write
+log_avg_msec=1000
+write_bw_log=seqwrite
+write_lat_log=seqwrite
+
+[seqwrite]
diff --git a/tools/testing/dontcache-bench/scripts/parse-results.sh b/tools/testing/dontcache-bench/scripts/parse-results.sh
new file mode 100755
index 000000000000..0427d411db04
--- /dev/null
+++ b/tools/testing/dontcache-bench/scripts/parse-results.sh
@@ -0,0 +1,238 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Parse fio JSON output and generate comparison tables.
+#
+# Usage: ./parse-results.sh <results-dir>
+
+set -euo pipefail
+
+if [ $# -lt 1 ]; then
+	echo "Usage: $0 <results-dir>"
+	exit 1
+fi
+
+RESULTS_DIR="$1"
+
+if ! command -v jq &>/dev/null; then
+	echo "ERROR: jq is required"
+	exit 1
+fi
+
+# Extract metrics from a single fio JSON result
+extract_metrics() {
+	local json_file=$1
+	local rw_type=$2  # read or write
+
+	if [ ! -f "$json_file" ]; then
+		echo "N/A N/A N/A N/A N/A N/A"
+		return
+	fi
+
+	jq -r --arg rw "$rw_type" '
+		.jobs[0][$rw] as $d |
+		[
+			(($d.bw // 0) / 1024 | . * 10 | round / 10),    # MB/s
+			($d.iops // 0),                                    # IOPS
+			((($d.clat_ns.mean // 0) / 1000) | . * 10 | round / 10), # avg lat us
+			(($d.clat_ns.percentile["50.000000"] // 0) / 1000), # p50 us
+			(($d.clat_ns.percentile["99.000000"] // 0) / 1000), # p99 us
+			(($d.clat_ns.percentile["99.900000"] // 0) / 1000)  # p99.9 us
+		] | @tsv
+	' "$json_file" 2>/dev/null || echo "N/A N/A N/A N/A N/A N/A"
+}
+
+# Extract server CPU from vmstat log (average sys%)
+extract_cpu() {
+	local vmstat_log=$1
+	if [ ! -f "$vmstat_log" ]; then
+		echo "N/A"
+		return
+	fi
+	# vmstat columns: us sy id wa st — skip header lines
+	awk 'NR>2 {sum+=$14; n++} END {if(n>0) printf "%.1f", sum/n; else print "N/A"}' \
+		"$vmstat_log" 2>/dev/null || echo "N/A"
+}
+
+# Extract peak dirty pages from meminfo log
+extract_peak_dirty() {
+	local meminfo_log=$1
+	if [ ! -f "$meminfo_log" ]; then
+		echo "N/A"
+		return
+	fi
+	grep "^Dirty:" "$meminfo_log" | awk '{print $2}' | sort -n | tail -1 || echo "N/A"
+}
+
+# Extract peak cached from meminfo log
+extract_peak_cached() {
+	local meminfo_log=$1
+	if [ ! -f "$meminfo_log" ]; then
+		echo "N/A"
+		return
+	fi
+	grep "^Cached:" "$meminfo_log" | awk '{print $2}' | sort -n | tail -1 || echo "N/A"
+}
+
+print_separator() {
+	printf '%*s\n' 120 '' | tr ' ' '-'
+}
+
+########################################################################
+# Deliverable 1: Single-client results
+########################################################################
+echo ""
+echo "=================================================================="
+echo "  Deliverable 1: Single-Client fio Benchmarks"
+echo "=================================================================="
+echo ""
+
+for workload in seq-write rand-write seq-read rand-read; do
+	case $workload in
+	seq-write|rand-write) rw_type="write" ;;
+	seq-read|rand-read)   rw_type="read" ;;
+	esac
+
+	echo "--- $workload ---"
+	printf "%-16s %10s %10s %10s %10s %10s %10s %10s %12s %12s\n" \
+		"Mode" "MB/s" "IOPS" "Avg(us)" "p50(us)" "p99(us)" "p99.9(us)" "Sys CPU%" "PeakDirty(kB)" "PeakCache(kB)"
+	print_separator
+
+	for mode in buffered dontcache direct; do
+		dir="${RESULTS_DIR}/${workload}/${mode}"
+		json_file=$(find "$dir" -name '*.json' -not -name 'client*' 2>/dev/null | head -1 || true)
+		if [ -z "$json_file" ]; then
+			printf "%-16s %10s\n" "$mode" "(no data)"
+			continue
+		fi
+
+		read -r mbps iops avg_lat p50 p99 p999 <<< \
+			"$(extract_metrics "$json_file" "$rw_type")"
+		cpu=$(extract_cpu "${dir}/vmstat.log")
+		dirty=$(extract_peak_dirty "${dir}/meminfo.log")
+		cached=$(extract_peak_cached "${dir}/meminfo.log")
+
+		printf "%-16s %10s %10s %10s %10s %10s %10s %10s %12s %12s\n" \
+			"$mode" "$mbps" "$iops" "$avg_lat" "$p50" "$p99" "$p999" \
+			"$cpu" "${dirty:-N/A}" "${cached:-N/A}"
+	done
+	echo ""
+done
+
+########################################################################
+# Deliverable 2: Multi-client results
+########################################################################
+echo "=================================================================="
+echo "  Deliverable 2: Noisy-Neighbor Benchmarks"
+echo "=================================================================="
+echo ""
+
+# Scenario A: Multiple writers
+echo "--- Scenario A: Multiple Writers ---"
+for mode in buffered dontcache direct; do
+	dir="${RESULTS_DIR}/multi-write/${mode}"
+	if [ ! -d "$dir" ]; then
+		continue
+	fi
+
+	echo "  Mode: $mode"
+	printf "  %-10s %10s %10s %10s %10s %10s %10s\n" \
+		"Client" "MB/s" "IOPS" "Avg(us)" "p50(us)" "p99(us)" "p99.9(us)"
+
+	total_bw=0
+	count=0
+	for json_file in "${dir}"/client*.json; do
+		[ -f "$json_file" ] || continue
+		client=$(basename "$json_file" .json)
+		read -r mbps iops avg_lat p50 p99 p999 <<< \
+			"$(extract_metrics "$json_file" "write")"
+		printf "  %-10s %10s %10s %10s %10s %10s %10s\n" \
+			"$client" "$mbps" "$iops" "$avg_lat" "$p50" "$p99" "$p999"
+		total_bw=$(echo "$total_bw + ${mbps:-0}" | bc 2>/dev/null || echo "$total_bw")
+		count=$(( count + 1 ))
+	done
+
+	cpu=$(extract_cpu "${dir}/vmstat.log")
+	dirty=$(extract_peak_dirty "${dir}/meminfo.log")
+	printf "  Aggregate BW: %s MB/s | Sys CPU: %s%% | Peak Dirty: %s kB\n" \
+		"$total_bw" "$cpu" "${dirty:-N/A}"
+	echo ""
+done
+
+# Scenario C: Noisy neighbor
+echo "--- Scenario C: Noisy Writer + Latency-Sensitive Readers ---"
+for mode in buffered dontcache direct; do
+	dir="${RESULTS_DIR}/noisy-neighbor/${mode}"
+	if [ ! -d "$dir" ]; then
+		continue
+	fi
+
+	echo "  Mode: $mode"
+	printf "  %-14s %10s %10s %10s %10s %10s %10s\n" \
+		"Job" "MB/s" "IOPS" "Avg(us)" "p50(us)" "p99(us)" "p99.9(us)"
+
+	# Writer
+	if [ -f "${dir}/noisy_writer.json" ]; then
+		read -r mbps iops avg_lat p50 p99 p999 <<< \
+			"$(extract_metrics "${dir}/noisy_writer.json" "write")"
+		printf "  %-14s %10s %10s %10s %10s %10s %10s\n" \
+			"Bulk writer" "$mbps" "$iops" "$avg_lat" "$p50" "$p99" "$p999"
+	fi
+
+	# Readers
+	for json_file in "${dir}"/reader*.json; do
+		[ -f "$json_file" ] || continue
+		reader=$(basename "$json_file" .json)
+		read -r mbps iops avg_lat p50 p99 p999 <<< \
+			"$(extract_metrics "$json_file" "read")"
+		printf "  %-14s %10s %10s %10s %10s %10s %10s\n" \
+			"$reader" "$mbps" "$iops" "$avg_lat" "$p50" "$p99" "$p999"
+	done
+
+	cpu=$(extract_cpu "${dir}/vmstat.log")
+	dirty=$(extract_peak_dirty "${dir}/meminfo.log")
+	printf "  Sys CPU: %s%% | Peak Dirty: %s kB\n" "$cpu" "${dirty:-N/A}"
+	echo ""
+done
+
+# Scenario D: Mixed-mode noisy neighbor
+echo "--- Scenario D: Mixed-Mode Noisy Writer + Readers ---"
+for dir in "${RESULTS_DIR}"/noisy-neighbor-mixed/*/; do
+	[ -d "$dir" ] || continue
+	label=$(basename "$dir")
+
+	echo "  Mode: $label"
+	printf "  %-14s %10s %10s %10s %10s %10s %10s\n" \
+		"Job" "MB/s" "IOPS" "Avg(us)" "p50(us)" "p99(us)" "p99.9(us)"
+
+	# Writer
+	if [ -f "${dir}/noisy_writer.json" ]; then
+		read -r mbps iops avg_lat p50 p99 p999 <<< \
+			"$(extract_metrics "${dir}/noisy_writer.json" "write")"
+		printf "  %-14s %10s %10s %10s %10s %10s %10s\n" \
+			"Bulk writer" "$mbps" "$iops" "$avg_lat" "$p50" "$p99" "$p999"
+	fi
+
+	# Readers
+	for json_file in "${dir}"/reader*.json; do
+		[ -f "$json_file" ] || continue
+		reader=$(basename "$json_file" .json)
+		read -r mbps iops avg_lat p50 p99 p999 <<< \
+			"$(extract_metrics "$json_file" "read")"
+		printf "  %-14s %10s %10s %10s %10s %10s %10s\n" \
+			"$reader" "$mbps" "$iops" "$avg_lat" "$p50" "$p99" "$p999"
+	done
+
+	cpu=$(extract_cpu "${dir}/vmstat.log")
+	dirty=$(extract_peak_dirty "${dir}/meminfo.log")
+	printf "  Sys CPU: %s%% | Peak Dirty: %s kB\n" "$cpu" "${dirty:-N/A}"
+	echo ""
+done
+
+echo "=================================================================="
+echo "  System Info"
+echo "=================================================================="
+if [ -f "${RESULTS_DIR}/sysinfo.txt" ]; then
+	head -6 "${RESULTS_DIR}/sysinfo.txt"
+fi
+echo ""
diff --git a/tools/testing/dontcache-bench/scripts/run-benchmarks.sh b/tools/testing/dontcache-bench/scripts/run-benchmarks.sh
new file mode 100755
index 000000000000..11bf400ef092
--- /dev/null
+++ b/tools/testing/dontcache-bench/scripts/run-benchmarks.sh
@@ -0,0 +1,562 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Local filesystem I/O mode benchmark suite.
+#
+# Runs the same test matrix as run-benchmarks.sh but on a local filesystem
+# using fio's io_uring engine with the RWF_DONTCACHE flag instead of NFSD's
+# debugfs mode knobs.
+#
+# Usage: ./run-local-benchmarks.sh [options]
+#   -t <dir>    Test directory (must be on a filesystem supporting FOP_DONTCACHE)
+#   -s <size>   File size (default: auto-sized to exceed RAM)
+#   -f <path>   Path to fio binary (default: fio in PATH)
+#   -o <dir>    Output directory for results (default: ./results/<timestamp>)
+#   -d          Dry run (print commands without executing)
+
+set -euo pipefail
+
+# Defaults
+TEST_DIR=""
+SIZE=""
+FIO_BIN="fio"
+RESULTS_DIR=""
+DRY_RUN=0
+MODES="0 1 2"
+PERF_LOCK=0
+SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
+FIO_JOBS_DIR="${SCRIPT_DIR}/../fio-jobs"
+
+usage() {
+	echo "Usage: $0 -t <test-dir> [-s <size>] [-f <fio-path>] [-o <output-dir>] [-D] [-p] [-d]"
+	echo ""
+	echo "  -t <dir>    Test directory (required, must support RWF_DONTCACHE)"
+	echo "  -s <size>   File size (default: 2x RAM)"
+	echo "  -f <path>   Path to fio binary (default: fio)"
+	echo "  -o <dir>    Output directory (default: ./results/<timestamp>)"
+	echo "  -D          Dontcache only (skip buffered and direct tests)"
+	echo "  -p          Profile kernel lock contention with perf lock"
+	echo "  -d          Dry run"
+	exit 1
+}
+
+while getopts "t:s:f:o:Dpdh" opt; do
+	case $opt in
+	t) TEST_DIR="$OPTARG" ;;
+	s) SIZE="$OPTARG" ;;
+	f) FIO_BIN="$OPTARG" ;;
+	o) RESULTS_DIR="$OPTARG" ;;
+	D) MODES="1" ;;
+	p) PERF_LOCK=1 ;;
+	d) DRY_RUN=1 ;;
+	h) usage ;;
+	*) usage ;;
+	esac
+done
+
+if [ -z "$TEST_DIR" ]; then
+	echo "ERROR: -t <test-dir> is required"
+	usage
+fi
+
+# Auto-size to 2x RAM if not specified
+if [ -z "$SIZE" ]; then
+	mem_kb=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
+	SIZE="$(( mem_kb * 2 / 1024 ))M"
+fi
+
+if [ -z "$RESULTS_DIR" ]; then
+	RESULTS_DIR="./results/local-$(date +%Y%m%d-%H%M%S)"
+fi
+
+mkdir -p "$RESULTS_DIR"
+
+log() {
+	echo "[$(date '+%H:%M:%S')] $*"
+}
+
+run_cmd() {
+	if [ "$DRY_RUN" -eq 1 ]; then
+		echo "  [DRY RUN] $*"
+	else
+		"$@"
+	fi
+}
+
+# I/O mode definitions:
+#   buffered:  direct=0, uncached=0
+#   dontcache: direct=0, uncached=1
+#   direct:    direct=1, uncached=0
+#
+# Mode name from numeric value
+mode_name() {
+	case $1 in
+	0) echo "buffered" ;;
+	1) echo "dontcache" ;;
+	2) echo "direct" ;;
+	esac
+}
+
+# Return fio command-line flags for a given mode.
+# "direct" is a standard fio option and works on the command line.
+# "uncached" is an io_uring engine option that must be in the job file,
+# so we inject it via make_job_file() below.
+mode_fio_args() {
+	case $1 in
+	0) echo "--direct=0" ;;           # buffered
+	1) echo "--direct=0" ;;           # dontcache
+	2) echo "--direct=1" ;;           # direct
+	esac
+}
+
+# Return the uncached= value for a given mode.
+mode_uncached() {
+	case $1 in
+	0) echo "0" ;;
+	1) echo "1" ;;
+	2) echo "0" ;;
+	esac
+}
+
+# Create a temporary job file with uncached=N injected into [global].
+# For uncached=0 (buffered/direct), return the original file unchanged.
+make_job_file() {
+	local job_file=$1
+	local uncached=$2
+
+	if [ "$uncached" -eq 0 ]; then
+		echo "$job_file"
+		return
+	fi
+
+	local tmp
+	tmp=$(mktemp)
+	sed "/^\[global\]/a uncached=${uncached}" "$job_file" > "$tmp"
+	echo "$tmp"
+}
+
+drop_caches() {
+	run_cmd bash -c "sync && echo 3 > /proc/sys/vm/drop_caches"
+}
+
+# perf lock profiling — uses BPF-based live contention tracing
+PERF_LOCK_PID=""
+
+start_perf_lock() {
+	local outdir=$1
+
+	if [ "$PERF_LOCK" -ne 1 ]; then
+		return
+	fi
+
+	log "Starting perf lock contention tracing"
+	perf lock contention -a -b --max-stack 8 \
+		> "${outdir}/perf-lock-contention.txt" 2>&1 &
+	PERF_LOCK_PID=$!
+}
+
+stop_perf_lock() {
+	local outdir=$1
+
+	if [ -z "$PERF_LOCK_PID" ]; then
+		return
+	fi
+
+	log "Stopping perf lock contention tracing"
+	kill -TERM "$PERF_LOCK_PID" 2>/dev/null || true
+	wait "$PERF_LOCK_PID" 2>/dev/null || true
+	PERF_LOCK_PID=""
+}
+
+# Background monitors
+VMSTAT_PID=""
+IOSTAT_PID=""
+MEMINFO_PID=""
+
+start_monitors() {
+	local outdir=$1
+	log "Starting monitors in $outdir"
+	run_cmd vmstat 1 > "${outdir}/vmstat.log" 2>&1 &
+	VMSTAT_PID=$!
+	run_cmd iostat -x 1 > "${outdir}/iostat.log" 2>&1 &
+	IOSTAT_PID=$!
+	(while true; do
+		echo "=== $(date '+%s') ==="
+		cat /proc/meminfo
+		sleep 1
+	done) > "${outdir}/meminfo.log" 2>&1 &
+	MEMINFO_PID=$!
+}
+
+stop_monitors() {
+	log "Stopping monitors"
+	kill "$VMSTAT_PID" "$IOSTAT_PID" "$MEMINFO_PID" 2>/dev/null || true
+	wait "$VMSTAT_PID" "$IOSTAT_PID" "$MEMINFO_PID" 2>/dev/null || true
+}
+
+cleanup_test_files() {
+	local filepath="${TEST_DIR}/$1"
+	log "Cleaning up $filepath"
+	run_cmd rm -f "$filepath"
+}
+
+# Run a single fio benchmark
+run_fio() {
+	local job_file=$1
+	local outdir=$2
+	local filename=$3
+	local fio_size=${4:-$SIZE}
+	local keep=${5:-}
+	local extra_args=${6:-}
+	local uncached=${7:-0}
+
+	# Inject uncached=N into the job file if needed
+	local actual_job
+	actual_job=$(make_job_file "$job_file" "$uncached")
+
+	local job_name
+	job_name=$(basename "$job_file" .fio)
+
+	log "Running fio job: $job_name -> $outdir (file=${TEST_DIR}/$filename size=$fio_size)"
+	mkdir -p "$outdir"
+
+	drop_caches
+	start_monitors "$outdir"
+	# Skip perf lock profiling for precreate/setup runs
+	[ "$keep" != "keep" ] && start_perf_lock "$outdir"
+
+	# shellcheck disable=SC2086
+	run_cmd "$FIO_BIN" "$actual_job" \
+		--output-format=json \
+		--output="${outdir}/${job_name}.json" \
+		--filename="${TEST_DIR}/$filename" \
+		--size="$fio_size" \
+		$extra_args
+
+	[ "$keep" != "keep" ] && stop_perf_lock "$outdir"
+	stop_monitors
+	log "Finished: $job_name"
+
+	# Clean up temp job file if one was created
+	[ "$actual_job" != "$job_file" ] && rm -f "$actual_job"
+
+	if [ "$keep" != "keep" ]; then
+		cleanup_test_files "$filename"
+	fi
+}
+
+########################################################################
+# Preflight
+########################################################################
+preflight() {
+	log "=== Preflight checks ==="
+
+	if ! command -v "$FIO_BIN" &>/dev/null; then
+		echo "ERROR: fio not found at $FIO_BIN"
+		exit 1
+	fi
+
+	if [ ! -d "$TEST_DIR" ]; then
+		echo "ERROR: Test directory $TEST_DIR does not exist"
+		exit 1
+	fi
+
+	# Quick check that RWF_DONTCACHE works on this filesystem
+	local testfile="${TEST_DIR}/.dontcache_test"
+	if ! "$FIO_BIN" --name=test --ioengine=io_uring --rw=write \
+		--bs=4k --size=4k --direct=0 --uncached=1 \
+		--filename="$testfile" 2>/dev/null; then
+		echo "WARNING: RWF_DONTCACHE may not be supported on $TEST_DIR"
+		echo "         (filesystem must support FOP_DONTCACHE)"
+	fi
+	rm -f "$testfile"
+
+	log "Test directory: $TEST_DIR"
+	log "File size: $SIZE"
+	log "fio binary: $FIO_BIN"
+	log "Results: $RESULTS_DIR"
+
+	# Record system info
+	{
+		echo "Timestamp: $(date +%Y%m%d-%H%M%S)"
+		echo "Kernel: $(uname -r)"
+		echo "Hostname: $(hostname)"
+		echo "Filesystem: $(df -T "$TEST_DIR" | tail -1 | awk '{print $2}')"
+		echo "File size: $SIZE"
+		echo "Test dir: $TEST_DIR"
+	} > "${RESULTS_DIR}/sysinfo.txt"
+}
+
+########################################################################
+# Deliverable 1: Single-client benchmarks
+########################################################################
+run_deliverable1() {
+	log "=========================================="
+	log "Deliverable 1: Single-client benchmarks"
+	log "=========================================="
+
+	# Sequential write
+	for mode in $MODES; do
+		local mname
+		mname=$(mode_name $mode)
+		local fio_args
+		fio_args=$(mode_fio_args $mode)
+
+		drop_caches
+		run_fio "${FIO_JOBS_DIR}/seq-write.fio" \
+			"${RESULTS_DIR}/seq-write/${mname}" \
+			"seq-write_testfile" "$SIZE" "" "$fio_args" \
+			"$(mode_uncached $mode)"
+	done
+
+	# Random write
+	for mode in $MODES; do
+		local mname
+		mname=$(mode_name $mode)
+		local fio_args
+		fio_args=$(mode_fio_args $mode)
+
+		drop_caches
+		run_fio "${FIO_JOBS_DIR}/rand-write.fio" \
+			"${RESULTS_DIR}/rand-write/${mname}" \
+			"rand-write_testfile" "$SIZE" "" "$fio_args" \
+			"$(mode_uncached $mode)"
+	done
+
+	# Sequential read — pre-create file, then read with each mode
+	log "Pre-creating sequential read test file"
+	run_fio "${FIO_JOBS_DIR}/seq-write.fio" \
+		"${RESULTS_DIR}/seq-read/precreate" \
+		"seq-read_testfile" "$SIZE" "keep"
+
+	for rmode in $MODES; do
+		local mname
+		mname=$(mode_name $rmode)
+		local fio_args
+		fio_args=$(mode_fio_args $rmode)
+		local keep="keep"
+		[ "$rmode" -eq 2 ] && keep=""
+
+		drop_caches
+		run_fio "${FIO_JOBS_DIR}/seq-read.fio" \
+			"${RESULTS_DIR}/seq-read/${mname}" \
+			"seq-read_testfile" "$SIZE" "$keep" "$fio_args" \
+			"$(mode_uncached $rmode)"
+	done
+
+	# Random read — pre-create file, then read with each mode
+	log "Pre-creating random read test file"
+	run_fio "${FIO_JOBS_DIR}/seq-write.fio" \
+		"${RESULTS_DIR}/rand-read/precreate" \
+		"rand-read_testfile" "$SIZE" "keep"
+
+	for rmode in $MODES; do
+		local mname
+		mname=$(mode_name $rmode)
+		local fio_args
+		fio_args=$(mode_fio_args $rmode)
+		local keep="keep"
+		[ "$rmode" -eq 2 ] && keep=""
+
+		drop_caches
+		run_fio "${FIO_JOBS_DIR}/rand-read.fio" \
+			"${RESULTS_DIR}/rand-read/${mname}" \
+			"rand-read_testfile" "$SIZE" "$keep" "$fio_args" \
+			"$(mode_uncached $rmode)"
+	done
+}
+
+########################################################################
+# Deliverable 2: Multi-client tests
+########################################################################
+run_deliverable2() {
+	log "=========================================="
+	log "Deliverable 2: Noisy-neighbor benchmarks"
+	log "=========================================="
+
+	local num_clients=4
+	local client_size
+	local mem_kb
+	mem_kb=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
+	client_size="$(( mem_kb / 1024 / num_clients ))M"
+
+	# Scenario A: Multiple writers
+	for mode in $MODES; do
+		local mname
+		mname=$(mode_name $mode)
+		local fio_args
+		fio_args=$(mode_fio_args $mode)
+		local uncached
+		uncached=$(mode_uncached $mode)
+		local actual_job
+		actual_job=$(make_job_file "${FIO_JOBS_DIR}/multi-write.fio" "$uncached")
+		local outdir="${RESULTS_DIR}/multi-write/${mname}"
+		mkdir -p "$outdir"
+
+		drop_caches
+		start_monitors "$outdir"
+		start_perf_lock "$outdir"
+
+		local pids=()
+		for i in $(seq 1 $num_clients); do
+			# shellcheck disable=SC2086
+			run_cmd "$FIO_BIN" "$actual_job" \
+				--output-format=json \
+				--output="${outdir}/client${i}.json" \
+				--filename="${TEST_DIR}/client${i}_testfile" \
+				--size="$client_size" \
+				$fio_args &
+			pids+=($!)
+		done
+
+		local rc=0
+		for pid in "${pids[@]}"; do
+			wait "$pid" || rc=$?
+		done
+
+		stop_perf_lock "$outdir"
+		stop_monitors
+		[ $rc -ne 0 ] && log "WARNING: some fio jobs exited non-zero"
+
+		[ "$actual_job" != "${FIO_JOBS_DIR}/multi-write.fio" ] && rm -f "$actual_job"
+		for i in $(seq 1 $num_clients); do
+			cleanup_test_files "client${i}_testfile"
+		done
+	done
+
+	# Scenario C: Noisy writer + latency-sensitive readers
+	for mode in $MODES; do
+		local mname
+		mname=$(mode_name $mode)
+		local fio_args
+		fio_args=$(mode_fio_args $mode)
+		local uncached
+		uncached=$(mode_uncached $mode)
+		local writer_job
+		writer_job=$(make_job_file "${FIO_JOBS_DIR}/noisy-writer.fio" "$uncached")
+		local reader_job
+		reader_job=$(make_job_file "${FIO_JOBS_DIR}/lat-reader.fio" "$uncached")
+		local outdir="${RESULTS_DIR}/noisy-neighbor/${mname}"
+		mkdir -p "$outdir"
+
+		# Pre-create read files
+		for i in $(seq 1 $(( num_clients - 1 ))); do
+			log "Pre-creating read file for reader $i"
+			run_fio "${FIO_JOBS_DIR}/multi-write.fio" \
+				"${outdir}/precreate_reader${i}" \
+				"reader${i}_readfile" \
+				"512M" "keep"
+		done
+		drop_caches
+		start_monitors "$outdir"
+		start_perf_lock "$outdir"
+
+		# Noisy writer
+		# shellcheck disable=SC2086
+		run_cmd "$FIO_BIN" "$writer_job" \
+			--output-format=json \
+			--output="${outdir}/noisy_writer.json" \
+			--filename="${TEST_DIR}/bulk_testfile" \
+			--size="$SIZE" \
+			$fio_args &
+		local writer_pid=$!
+
+		# Latency-sensitive readers
+		local reader_pids=()
+		for i in $(seq 1 $(( num_clients - 1 ))); do
+			# shellcheck disable=SC2086
+			run_cmd "$FIO_BIN" "$reader_job" \
+				--output-format=json \
+				--output="${outdir}/reader${i}.json" \
+				--filename="${TEST_DIR}/reader${i}_readfile" \
+				--size="512M" \
+				$fio_args &
+			reader_pids+=($!)
+		done
+
+		local rc=0
+		wait "$writer_pid" || rc=$?
+		for pid in "${reader_pids[@]}"; do
+			wait "$pid" || rc=$?
+		done
+
+		stop_perf_lock "$outdir"
+		stop_monitors
+		[ $rc -ne 0 ] && log "WARNING: some fio jobs exited non-zero"
+
+		[ "$writer_job" != "${FIO_JOBS_DIR}/noisy-writer.fio" ] && rm -f "$writer_job"
+		[ "$reader_job" != "${FIO_JOBS_DIR}/lat-reader.fio" ] && rm -f "$reader_job"
+		cleanup_test_files "bulk_testfile"
+		for i in $(seq 1 $(( num_clients - 1 ))); do
+			cleanup_test_files "reader${i}_readfile"
+		done
+	done
+
+	# Scenario D: Mixed-mode noisy neighbor
+	# dontcache writes + buffered reads
+	local outdir="${RESULTS_DIR}/noisy-neighbor-mixed/dontcache-w_buffered-r"
+	mkdir -p "$outdir"
+	local writer_job
+	writer_job=$(make_job_file "${FIO_JOBS_DIR}/noisy-writer.fio" 1)
+
+	for i in $(seq 1 $(( num_clients - 1 ))); do
+		log "Pre-creating read file for reader $i"
+		run_fio "${FIO_JOBS_DIR}/multi-write.fio" \
+			"${outdir}/precreate_reader${i}" \
+			"reader${i}_readfile" \
+			"512M" "keep"
+	done
+	drop_caches
+	start_monitors "$outdir"
+	start_perf_lock "$outdir"
+
+	# Writer with dontcache
+	run_cmd "$FIO_BIN" "$writer_job" \
+		--output-format=json \
+		--output="${outdir}/noisy_writer.json" \
+		--filename="${TEST_DIR}/bulk_testfile" \
+		--size="$SIZE" \
+		--direct=0 &
+	local writer_pid=$!
+
+	# Readers with buffered (no uncached flag)
+	local reader_pids=()
+	for i in $(seq 1 $(( num_clients - 1 ))); do
+		run_cmd "$FIO_BIN" "${FIO_JOBS_DIR}/lat-reader.fio" \
+			--output-format=json \
+			--output="${outdir}/reader${i}.json" \
+			--filename="${TEST_DIR}/reader${i}_readfile" \
+			--size="512M" \
+			--direct=0 &
+		reader_pids+=($!)
+	done
+
+	local rc=0
+	wait "$writer_pid" || rc=$?
+	for pid in "${reader_pids[@]}"; do
+		wait "$pid" || rc=$?
+	done
+
+	stop_perf_lock "$outdir"
+	stop_monitors
+	[ $rc -ne 0 ] && log "WARNING: some fio jobs exited non-zero"
+
+	[ "$writer_job" != "${FIO_JOBS_DIR}/noisy-writer.fio" ] && rm -f "$writer_job"
+	cleanup_test_files "bulk_testfile"
+	for i in $(seq 1 $(( num_clients - 1 ))); do
+		cleanup_test_files "reader${i}_readfile"
+	done
+}
+
+########################################################################
+# Main
+########################################################################
+preflight
+run_deliverable1
+run_deliverable2
+
+log "=========================================="
+log "All benchmarks complete."
+log "Results in: $RESULTS_DIR"
+log "Parse with: scripts/parse-results.sh $RESULTS_DIR"
+log "=========================================="

-- 
2.53.0


