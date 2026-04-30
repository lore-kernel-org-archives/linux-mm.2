Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D20DFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 04:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95B316B0095; Thu, 30 Apr 2026 00:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90C856B0096; Thu, 30 Apr 2026 00:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FB6D6B0098; Thu, 30 Apr 2026 00:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D10B6B0095
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:04:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1634BC06D9
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:04:56 +0000 (UTC)
X-FDA: 84713881392.26.5E0C634
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7532BC000C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:04:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XmywiKhu;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777521894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=snB875P95SUbpGSGDIAQLGtDYkvzFzItmsNJKMa2UQ4=;
	b=4WKtwKpc2SNDbvFnOa6mmqk9XplgNukmzk9Bz6aWEqfekiJku3wqAM5FsYIqbmg2hInSgh
	mO+sRa9774f8D5LASORdibeYR7ldYz1i+jARHZkmy3r4yBvr7xVZbpDMrgHpQmhgJK9Vs9
	SSBwOguATZH6MfPRbcuqOg4mnW3h5x4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XmywiKhu;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777521894; a=rsa-sha256;
	cv=none;
	b=tA3AwguThix95tdxxsE9OwdGXvIQxyJzb97RrzPsjnnViEnLdaF24l1KCalDjgS6FboY2y
	uMbTGib8nFAHtlaMfMsdDfoSpeIgKkVbn7bI2W9D/AT/ShgeSRlSefPVERuDx6a5Q9tpaE
	AtNMg8GJNkvyYKgByoRMlvpjgTQbILA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9FF0960582;
	Thu, 30 Apr 2026 04:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6B0C2BCB8;
	Thu, 30 Apr 2026 04:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777521893;
	bh=SQbc6yap3IwxIjf5vkMZhpQlq9soeHHQjAS0yGku44k=;
	h=From:To:Cc:Subject:Date:From;
	b=XmywiKhuyr1+iRfR3PHU6v9GONpwVAKCcc0eTlQU9yjUnF6uRHR/EBTZ/UN8UVVVB
	 kG/ZtEEtVbHvFaU+7KcGKU5U2/IzqdlsTRcV5sdP0HYPRqvAozZqjFb0EOASauV2xC
	 xUaKzad/uIF07HjedFILdewu7IjvV/gAtfxZbzVm8Kt/pEV3hdCFjBHz3/a9JeCr35
	 5oYSoSs/WSqmNPs15idDrhOJSsG7WKscp9W5QVhlflYcPmOPSGHTGSFBqz1kz4GAV0
	 apuUfkjNj3pyaP8/fgBFyApKG9AU7GKaHlnxXjL4Jva5JTKwRj7lbU5sCFB18KTvNd
	 ycxSlp7jRcFKg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	willy@infradead.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jack@suse.cz,
	pfalcato@suse.de,
	wanglian@kylinos.cn,
	chentao@kylinos.cn,
	lianux.mm@gmail.com,
	kunwu.chan@gmail.com,
	liyangouwen1@oppo.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page fault performance
Date: Thu, 30 Apr 2026 12:04:22 +0800
Message-Id: <20260430040427.4672-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7532BC000C
X-Rspam-User: 
X-Stat-Signature: dumzmu5kh8pf8de89ck157wc981z3uho
X-HE-Tag: 1777521894-704639
X-HE-Meta: U2FsdGVkX19Pxz6hkwvusuxUxUvaM7/zkg6FZgxgr/DJRIeN+C9h/LoxO/x5KtvDR3Y11XXkqIbCwczuA0J0c0zm66qV7AqylmoA8xwCHNWGdl5F+6T7XZUiivd0VRlHT7g77yK+yDVWwa1Bmcl655fv41Z5eSFCuFjs4TATUbvM5Q5fpGvvYO1mTlO4Lx7cP22D3mc8zgs064j0UYF55zCA8myjZP56WpRU5S6FudClTMcvrXaID2yRGrdSb5lAltGFnjt95KmZWv02ldgiT6rdowVC6N2+ZamvG9zIpqw7PzkQt+NdI9nuwJjmlxxzxTecqUe9wjz85OjcFr25RVdgGdru+dWE8cTkbKkE9Ivczy08WVew1opjj2Ca+WWGR9aaNkNHBYIEcGJfwwVed1qfiqD+RTPn+XJnBoeZwUkjOgAYAUGhQywJ5SV1IGk4oEmjVc78GhsLdWNkOvJjlP+b98n2V9bdl6JgLPzUHXThtFVrJlwD/zzKc9zXCoRVqoKTOd9S/9C7wS8XcmB2n4V/4dpupjCLXpdJquZE0+q11hhHXt4wCCMetFl1FKgKNFy/rRD5+lDxkZ+vmf4n99+bMaNsrZo7ZLHmqhlzlJ5bOukiyQuk6lGcLGjDpRzPDwspaTmlm7tfoJXxcWBswdaGIocloHh5xNGO89+r4Fh8Krf28D/6EnfX7TiTqZ2X19StvIDFhj8hvEBsqIoP3lKdVaj+SjmbH3Fk1+x/wTWMM6O1zvoKqWYLWhtjNz/LHOhJySkhIcvhOBjAlkEn6myHb//Dm1h8EbJtOqiFHRpXQsUW6DSWV5QkZdHXGEqPb+F60DoIFkResIkGSmbz/4Ov3IHnngEju+XB0nbz6EiwRSx1PFkTIQCQzOSVyGpvb4nOfoEzRGlMwJjyF2+WiP/kSZCx3fvL+3U27loBezZ1UiZeAEQQ8skp5uI4Q6d1qtaTWszXdQBXcbxbPCl
 KinWbLH4
 FIQlIxfHBN69pnxxtDQDyp88bPLH2QCnjDEo/Neus04LMVUsEZQpWV9Jb+/nBNzkpBOGQ2q2wKAqM3nEfD7oev9g/rbz2vu3k4d/eRESmLyB72dRXgTphIbxL0TVxz11qoT/FU8oMQhQXpmimC4VsV0QVVMWno8kB7scfruXyc7DV392W81OJEOtHZey7/U/4ovjCg5ot1lIEyHWsKoAzM4UiEagPuug7e7hMCEcG3eUpB0FQBKAL5T3guFSRSv2TSp8WHnzJJa8OGin0+BqPJPIbCY3Ze8TISnFb9lsa2Ufc/I1IAZfBouObzdmhbZVq0iuT4GeuFOrOiCRge6kQVRRUTbo16hcqwPFcBQogaer0ajeCTxLTuws30JVrewd45R1UDC3RIZ9Duf5XyHGwvkGijcnsenMWZw4aMqB5/B8vAevDcvd+eea47ypPXh3qNkqXObLy58Bs1WhOdJzOx8idUEg2S5AxWfdWnxFOBhtZpsU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Oven observed most mmap_lock contention and priority inversion
come from page fault retries after waiting for I/O completion.
Oven subsequently raised the following idea:

There is no need to always fall back to mmap_lock when the per-VMA lock
is released only to wait for the page cache to become ready. On a page
fault retry, the per-VMA lock can still be reused.

We believe the same should also apply to anonymous folios. However, there
is a case where I/O has completed but we fail to acquire the folio lock
because a concurrent thread may be installing PTEs for the folio. This
is expected to be short-lived, so retrying the page fault is unnecessary.

This patchset handles two cases:

(1) If we need to wait for I/O completion, we still drop the per-VMA lock, as
current page fault handling already does. Holding it for too long may introduce
various priority inversion issues on mobile devices. After I/O completes, we
retry the page fault with the per-VMA lock, rather than falling back to
mmap_lock.

(2) If I/O has already completed and the folio is up to date, the wait is
likely due to a concurrent PTE installation. In this case, we keep the
per-VMA lock and avoid retrying the page fault.

With (1), the dramatically reduced mmap_lock contention leads to a
significant improvement in Douyin performance. Oven’s data is shown
below.

Douyin (the Chinese version of TikTok) warm start on a smartphone with
8GB RAM.

== mmap_lock Acquisitions And Wait Time ==

Metric                    Before (Avg)    After (Avg)    Change
------------------------------------------------------------------------
Read Lock Count           20,010          5,719          -71.42%
Read Total Wait (us)      10,695,877     408,436        -96.18%
Read Avg Wait (us)        534.00         71.00           -86.70%
Write Lock Count          838             909            +8.47%
Write Total Wait (us)     501,293        97,633          -80.52%
Write Avg Wait (us)       598.00         107.00          -82.11%


== Read Lock Waiting Time Distribution of mmap_lock ==

Range (us)                 Before (Avg)    After (Avg)    Change
------------------------------------------------------------------------
[0, 1)                     9,927           4,286          -56.82%
[1, 10)                    9,179           1,327          -85.54%
[10, 100)                  191             88             -53.93%
[100, 1000)                57              6              -89.47%
[1000, 10000)              328             9              -97.26%
[10000, 100000)            328             6              -98.17%
[100000, 1000000)          0               0              N/A
[1000000, +)               0               0              N/A

== Write Lock Waiting Time Distribution of mmap_lock ==

Range (us)                 Before (Avg)    After (Avg)    Change
------------------------------------------------------------------------
[0, 1)                     250             300            +20.00%
[1, 10)                    483             556            +15.11%
[10, 100)                  52              41             -21.15%
[100, 1000)                12              5              -58.33%
[1000, 10000)              22              4              -81.82%
[10000, 100000)            16              1              -93.75%
[100000, 1000000)          0               0              N/A
[1000000, +)               0               0              N/A

After the optimization, the number of read lock acquisitions is 
significantly reduced, and both lock waiting time and tail latency are 
dramatically improved.

Kunwu and Lian also developed a model to capture the situation described
by Matthew [1], where a memcg with limited memory may fail to make
progress. This happens because after I/O is initiated on the first page
fault, the folios may be reclaimed by the time of the retry, leaving the
workload with little or no forward progress.

A stress setup made by Kunwu and Lian as follows:
* 256-core x86 system
* 500 threads continuously faulting on 16MB files

The model was running within a memcg with limited memory,
as shown below:

systemd-run --scope -p MemoryHigh=1G -p MemoryMax=1.2G -p MemorySwapMax=0 \
--unit=mmap-thrash-$$ ./mmap_lock & \
TEST_PID=$!

The reproducer code is shown below:

 #define THREADS 500 
 #define FILE_SIZE (16 * 1024 * 1024) /* 16MB */ 
 static _Atomic int g_stop = 0; 
 #define RUN_SECONDS 600 
 
 struct worker_arg { 
         long id; 
         uint64_t *counts; 
 }; 
 
 void *worker(void *arg) 
 { 
         struct worker_arg *wa = (struct worker_arg *)arg; 
         long id = wa->id; 
         char path[64]; 
         uint64_t local_rounds = 0; 
 
         snprintf(path, sizeof(path), "./test_file_%d_%ld.dat", 
                  getpid(), id); 
         int fd = open(path, O_RDWR | O_CREAT | O_TRUNC, 0666); 
         if (fd < 0) return NULL; 
         if (ftruncate(fd, FILE_SIZE) < 0) { 
                 close(fd); return NULL; 
         } 
 
         while (!atomic_load_explicit(&g_stop, memory_order_relaxed)) { 
                 char *f_map = mmap(NULL, FILE_SIZE, PROT_READ, 
                                    MAP_SHARED, fd, 0); 
                 if (f_map != MAP_FAILED) { 
                         /* Pure page cache thrashing */ 
                         for (int i = 0; i < FILE_SIZE; i += 4096) { 
                                 volatile unsigned char c = 
                                         (unsigned char)f_map[i]; 
                                 (void)c; 
                         } 
                         munmap(f_map, FILE_SIZE); 
                         local_rounds++; 
                 } 
         } 
         wa->counts[id] = local_rounds; 
         close(fd); 
         unlink(path); 
         return NULL; 
 } 
 
 int main(void) 
 { 
         printf("Pure File Thrashing Started. PID: %d\n", getpid()); 
         pthread_t t[THREADS]; 
         uint64_t local_counts[THREADS]; 
         memset(local_counts, 0, sizeof(local_counts)); 
         struct worker_arg args[THREADS]; 
 
         for (long i = 0; i < THREADS; i++) { 
                 args[i].id = i; 
                 args[i].counts = local_counts; 
                 pthread_create(&t[i], NULL, worker, &args[i]); 
         } 
 
         sleep(RUN_SECONDS); 
         atomic_store_explicit(&g_stop, 1, memory_order_relaxed); 
 
         for (int i = 0; i < THREADS; i++) pthread_join(t[i], NULL); 
 
         uint64_t total = 0; 
         for (int i = 0; i < THREADS; i++) total += local_counts[i]; 
 
         printf("Total rounds     : %llu\n", (unsigned long long)total); 
         printf("Throughput       : %.2f rounds/sec\n", 
                (double)total / RUN_SECONDS); 
         return 0; 
 }

They also added temporary counters in page fault retries [2]:
- RETRY_IO_MISS   : folio not present after I/O completion
- RETRY_MMAP_DROP : retry fallback due to waiting for I/O

Their results are as follows:

| Case                | Total Rounds | Throughput | Miss/Drop(%) | RETRY_MMAP_DROP | RETRY_IO_MISS |
| ------------------- | ------------ | ---------- | ------------ | --------------- | ------------- |
| Baseline (Run 1)    | 22,711       | 37.85 /s   | 45.04        | 970,078         | 436,956       |
| Baseline (Run 2)    | 23,530       | 39.22 /s   | 44.96        | 972,043         | 437,077       |
| With Series (Run A) | 54,428       | 90.71 /s   | 1.69         | 1,204,124       | 20,398        |
| With Series (Run B) | 35,949       | 59.91 /s   | 0.03         | 327,023         | 99            |

Without this series, nearly half of the retries fail to observe completed
I/O results, leading to significant CPU and I/O waste. With the finer-
grained VMA lock, faulting threads avoid the heavily contended mmap_lock
during retries and are therefore able to complete the page fault.

With (2), there is a clear improvement in swap-in bandwidth in a model
with five threads issuing MADV_PAGEOUT-based swap-outs and five threads
performing swap-ins on a 100MB anonymous mmap VMA.

 #define SIZE (100 * 1024 * 1024)
 #define PAGE_SIZE 4096
 #define WRITER_THREADS 5
 #define READER_THREADS 5
 #define RUN_SECONDS 30
 
 static uint8_t *buf;
 static atomic_ulong pageout_rounds = 0;
 static atomic_ulong swapin_rounds = 0;
 static atomic_int stop_flag = 0;
 
 static void *pageout_thread(void *arg)
 {
     (void)arg;
     while (!atomic_load(&stop_flag)) {
         if (madvise(buf, SIZE, MADV_PAGEOUT) == 0) {
             atomic_fetch_add(&pageout_rounds, 1);
         }
     }
     return NULL;
 }
 
 static void *reader_thread(void *arg)
 {
     (void)arg;
     volatile uint64_t sum = 0;
 
     while (!atomic_load(&stop_flag)) {
         for (size_t i = 0; i < SIZE; i += PAGE_SIZE) {
             sum += buf[i];
         }
         /* One full pass over 100MB, counted as one swap-in round (approximate) */
         atomic_fetch_add(&swapin_rounds, 1);
     }
     return NULL;
 }
 
 int main(void)
 {
     pthread_t writers[WRITER_THREADS];
     pthread_t readers[READER_THREADS];
 
     buf = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
                MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
     if (buf == MAP_FAILED) {
         exit(EXIT_FAILURE);
     }
     memset(buf, 0, SIZE);
 
     for (int i = 0; i < WRITER_THREADS; i++) {
         if (pthread_create(&writers[i], NULL, pageout_thread, NULL) != 0) {
             perror("pthread_create");
             exit(EXIT_FAILURE);
         }
     }
     for (int i = 0; i < READER_THREADS; i++) {
         if (pthread_create(&readers[i], NULL, reader_thread, NULL) != 0) {
             perror("pthread_create");
             exit(EXIT_FAILURE);
         }
     }
 
     sleep(RUN_SECONDS);
     atomic_store(&stop_flag, 1);
     for (int i = 0; i < WRITER_THREADS; i++)
         pthread_join(writers[i], NULL);
     for (int i = 0; i < READER_THREADS; i++)
         pthread_join(readers[i], NULL);
 
     printf("=== Result (30s) ===\n");
     printf("Pageout rounds: %lu\n", pageout_rounds);
     printf("Swap-in rounds (approx): %lu\n", swapin_rounds);
     munmap(buf, SIZE);
     return 0;
 }

W/o patches:
=== Result (30s) ===
Pageout rounds: 1324847
Swap-in rounds (approx): 874

W/patches:
=== Result (30s) ===
Pageout rounds: 1330550
Swap-in rounds (approx): 1017

[1] https://lore.kernel.org/linux-mm/aSip2mWX13sqPW_l@casper.infradead.org/
[2] https://github.com/lianux-mm/ioretry_test/

-v2:
  * collect tags from Pedro, Kunwu and Lian, thanks!
  * handle case (2), for uptodate folios, don't retry PF
-RFC:
  https://lore.kernel.org/linux-mm/20251127011438.6918-1-21cnbao@gmail.com/

Barry Song (Xiaomi) (4):
  mm/swapin: Retry swapin by VMA lock if the lock was released for I/O
  mm: Move folio_lock_or_retry() and drop __folio_lock_or_retry()
  mm: Don't retry page fault if folio is uptodate during swap-in
  mm/filemap: Avoid retrying page faults on uptodate folios in filemap
    faults

Oven Liyang (1):
  mm/filemap: Retry fault by VMA lock if the lock was released for I/O

 arch/arm/mm/fault.c       |  5 +++
 arch/arm64/mm/fault.c     |  5 +++
 arch/loongarch/mm/fault.c |  4 +++
 arch/powerpc/mm/fault.c   |  5 ++-
 arch/riscv/mm/fault.c     |  4 +++
 arch/s390/mm/fault.c      |  4 +++
 arch/x86/mm/fault.c       |  4 +++
 include/linux/mm_types.h  |  9 ++---
 include/linux/pagemap.h   | 17 ----------
 mm/filemap.c              | 57 ++++++-------------------------
 mm/memory.c               | 70 +++++++++++++++++++++++++++++++++++++--
 11 files changed, 114 insertions(+), 70 deletions(-)

-- 
* The work began during my collaboration with OPPO and has continued through
my current collaboration with Xiaomi. Although the OPPO collaboration has
ended, OPPO still deserves more than half of the credit for this series,
if any credit is to be assigned.

2.39.3 (Apple Git-146)

