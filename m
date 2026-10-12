Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 918C3CA9EDE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81B2B6B0099; Mon, 12 Oct 2026 14:59:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC5B6B009B; Mon, 12 Oct 2026 14:59:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E1D36B009D; Mon, 12 Oct 2026 14:59:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2166B0099
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:59:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 99437A0CBE
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:59:30 +0000 (UTC)
X-FDA: 85314887700.14.0B80480
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf04.hostedemail.com (Postfix) with ESMTP id A68AB40002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:59:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=NsHntO7f;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf04.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791831568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qA5EK/Wa96FVW4oU58RgT4UF+JCxctbidCL6ltk8p1o=;
	b=Vpu3MlXupnt/3wfvhEqopDYcFwPfz0VDXyqNPlTAvtb9YVzmZiMXig69M1WjzMLYayuENM
	mp+GDUfKSnEudNWHFObxnKei7lljaZBcPfwTP7scC0gv962upsOvN5WxhbI1LzFcPXBf/5
	O74etS/RxNO+tSXRFFxDnlhsUjSomqE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=NsHntO7f;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf04.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791831568;
	b=DWAKHGstgX4YHUxFcxGSCvIjBxN3hkWz4rhcmISvxaNCup2f85gY7rzCVCoe76xKq/sgja
	jFjrM29cVv2O6MAB3VslUFI4ir4A9Biz81Z8kG1/RK49kwdkw9Jk9Qmiwn3p6YiXceiptg
	WAsEysqzgIplA6QSummJeHkakchgWn0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=qA5EK/Wa96FVW4oU58RgT4UF+JCxctbidCL6ltk8p1o=; b=NsHntO7fnZYNFH7wFAI
	Iyqnr4jJ0d4L9lU9rnQ7iOzrSQd81v5lxgyvYhHhYyIjLOo9PnLM1CS0K2s9Krqb63BaoAHKm0J3Z
	bJdvdvgmaoPMANUy5nqLKbngfJRSmT4M8lscLptxLDPOA5/7/LdjmJowTGWnX65GNnfCIxQ+bZnpb
	MTz1wSnFJ2z2Wco1WjzwITTkCYb1ifMMj0DuKLkC660lqp+sKnSZfHjeMO7WpuxOSlrRJhAidnyCt
	hiI5ntaM4FTmbpoIXBFTMPxFIf2h1pNog1e8MnwrKfpB4O0ul2UUUfvIBb0Z1Q7e1DS56h1JLlRjv
	J27dwsb62pDcjCQ==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xGLBb-007pPW-1u;
	Mon, 12 Oct 2026 20:59:09 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Mon, 12 Oct 2026 20:59:06 +0200
Subject: [PATCH 2/2] selftests: cgroup: make test_memcg_sock check flushed
 sock stats
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-v1-2-bc864b1950ad@virtuozzo.com>
References: <20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-v1-0-bc864b1950ad@virtuozzo.com>
In-Reply-To: <20261012-b4-prep-vstor-149854-let-test_memcg_sock-compare-flushed-sock-stats-v1-0-bc864b1950ad@virtuozzo.com>
To: Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>, 
 Guopeng Zhang <zhangguopeng@kylinos.cn>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7763;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=2bPcfVGTS80cMbqLQOtpnz41cUxttMSol2uwcpqfi0s=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBqzS4DgaidbMKjbP3IgO7QMgUbXfw4p7qrhlWbW
 f8xX0sK/nOJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCas0uAwAKCRBRlgpH+WFc
 KlOJD/0d2kRvQ33GJ+qflRrSnLSsOysIGJGWhBG3BnIqBP+Ve184OLIAryF81XiNiZQm5rmDM1p
 W5GdsV3nH39IsZMQCn6x71QVw48tGPWwrz3pAIIL839ayQAyHV9RxEBhepZTolStdUtJYONbhTm
 46TLxH1qzvECUiAeZlkr+9tOIjIn/k3E1YesZq0sIhfUVb47wAdq2kDnKN+q6AM9WQxNUVKeUSh
 DFjR63+RkY2hmrEKdMbDivtskEytCxZsOCYew6hQE70AUS6vHZhjBHYkWgwQAPuFGotjC7VraIM
 J8MDkpyJFQXnJf8rIohipaPn0gpwZy2ou73//aMVaEtqV7IQI9u5FsMb9egiBqCQHJXwpDbh6Z0
 EdY6r5iOowBsXpivcYBPO+rwIiA+oMZVrnYjT3sNnlbmMkGALvFhywDiDh0JNz2PD6CSUmIZGkU
 oVMKNIrCfxHAnj85ch9iJKoi7zt1Ne9TbxQXIoKjYO4U2yhYAnKwFRK9tBU4GnPNxx7XNqvrTMW
 3KI5aIMVFvToR0oLpL849XMfXJU9XEstZ0S+NhAfLjkNZwnN08PmL46QclOHLcJtKwy0TW1Y/3u
 oD2BrXy1eitotWv47ftKYBqAeVXaAEDdRAsuSOqOHFEWUC50mEUgx5RSD+a1582hnR1d9WOOxRR
 qirwr6ygfFqY9qw==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspamd-Queue-Id: A68AB40002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 9aiszfjqzhcn8czpqqhbpw5zw5xkepz7
X-HE-Tag: 1791831568-870326
X-HE-Meta: U2FsdGVkX18N1fST8IVrCAefUFCx7kdxEBF59L2+jUShEp7pPDwqFsFI9NaJWHdtgHdQU+4CN0hFRn8t5+Zp/dktu/RBavg57y818m+9OzRBHU/4k/dXGD2hHM8zKRRxWv+9nQWRXVHTbAVHGiqDgyfcYAyQlxfcgEViYUIBkra+JNRmWw2QaOYR8FuMuRtJfs5ZvN5AAuDa2EZCF4DUih1/cH0KgEYt8j0VZo0ue22OLuDQJn32AYCkScLb1rX4qhDXZUlHT4301Ou403clB8Sk9SCoiJxMhdufhffMxc85ivCfej10mHcgSze7djfaHJlxysPlGRidQZg/j49KI5M7Fpq3iRhXEyojAK8/VsGGvPaQbbH3c7DTFHhBh8WYFtfbxbhIO12XbkN0Magw8ofP3S63XCsCyPMYeEuGOSekjXVkjFCxWeOLJEob5z0R2nUg1d0hWB7III7ZCnMdBuScdCB/u4AffdyrmMv3mN3X4+bvwv9YMTxBymGQT+oD7lhKLObV4v6mip+A7mRthds2Kjedhb8NK6U+5MnA/KI4QCPwoJTGu56xhEKuYZdxlmsPw2eEZ90rST0fyY5UlD2MyoHT+UvCulmAo+4dmbyNhQhEVOvZqu57yquLeWGNRqGHh5769GnSlxeB3bWFGuAbPRDE2FijRmb8VuCqfUzIRJTMTVwjPLDQUEULB2Gk05Uq024ffoGhEfRKHACoy/kBibLONz7jqDpktup4lnWMPorUgkNLJkgw07x5+hLblA/7Sv4Tpp41fTB4gFNFcVUT2VAPEsEaw5fFkxbudqFqhkPPxWzY0KzzWEXk+5v56heudXAwmMg++hke+972FPNYPycjpGcwBe6n9T3kevgrreWf/cbxmvs5Iy68yrslpuW/CwB2Os+Gju8QBjk+TqzQlFhsMZRFdVyJtM0ioGdkCiamkjrDTvnmUDTPo2LFMzhzsdIoP2ofgwqnGui
 jZHikgjF
 DvT5tYOJ2pc0vcAgU0iKdFSGekDp/mgGUSQWZznceS3wWIW9ciM1Nyxp9z1zK2cHFTGWW0UelugLPPdnyk5rSc5YCAvdsQK0qsjocpGyGIjcW9xOrDQM9eUv2ltKKBHU26oLNiB6sK2IDk44uGWbJSnlJ++S066foxhve3hFSa2vLhJU8OaiUV3/P5GwcRU2XoTJ8KIivSBeZQPA8FXIva8o76BJ8c+zGO6BbGHLPPFri59QOEl5jnvAasj5pxJcCrGBsmJKGiYr+bDitHMGHS4MTtldmJxCNw4CBawEKArMDx7gi8skkdX0sMhBaQ6J7/MM1XaerAUHNsd4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_memcg_sock compares memory.current with the "sock " entry of
memory.stat. memory.current changes at charge time, "sock " only when
the memcg stats are flushed: by a memory.stat read once enough updates
are pending (MEMCG_CHARGE_BATCH per online CPU), or by a periodic,
deferrable worker. Nothing in the test makes sure a flush happens:

- tcp_client() takes 16 readings right after connect(). If no flush
  lands among them, "sock " reads 0, and the test either passes on
  0 == 0 without checking anything or, once memory.current shows the
  first charge, cannot pass any more and fails:

    not ok 11 test_memcg_sock

- The final check waits 3 seconds for "sock " to drop to 0, counting on
  the deferrable worker, which can run later than that on an idle
  machine.

Make the test cause the flushes instead of waiting for them. Every page
of socket or anonymous memory that comes and goes in the cgroup counts
towards the flush threshold, and MEMCG_FLUSH_BYTES (twice the vmstat error
test_kmem allows for) is enough to cross it. After that much, either
another flush has reset the count or the next memory.stat read flushes.

- tcp_client() sets a small receive buffer before it connects. Only
  the server's socket is charged to the test cgroup, and with a large
  receive window its data moves straight on to the client; with few
  CPUs the client then drains it between reads and "sock " stays near 0.
  A small window keeps the data queued in the server's socket.
- tcp_client() then keeps reading, comparing after every read, until
  "sock " is nonzero and matches memory.current, for up to four times
  MEMCG_FLUSH_BYTES. A comparison can still miss after a flush: one
  that came midway leaves "sock " behind, and memory.current also holds
  the per-CPU charge stock. The budget leaves room for several flushes.
- After the server has exited, the test allocates and frees
  MEMCG_FLUSH_BYTES of anonymous memory in the cgroup and reads "sock ",
  for up to three rounds until it reads 0. The socket memory is
  uncharged before the first round, so any flush that has gone through
  all CPUs since sees "sock " at 0. A flush still running in parallel
  can reset the count before it reaches the CPU that did the uncharge,
  and the read then misses the uncharge. That flush only has to finish
  its walk over the CPUs for the next read to see it, and each round
  gives it the time of another allocation. Three rounds are a margin for
  a flusher that gets rescheduled midway, not a guarantee: nothing
  bounds how long it can be held up.

MEMCG_CHARGE_BATCH goes to cgroup_util.h, and test_kmem's
MAX_VMSTAT_ERROR uses it too.

Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 .../selftests/cgroup/lib/include/cgroup_util.h     |  3 ++
 tools/testing/selftests/cgroup/test_kmem.c         |  2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   | 47 +++++++++++++---------
 3 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
index 5d39c709ac7a4..5307f3bf32a09 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -21,6 +21,9 @@
 
 #define DEFAULT_WAIT_INTERVAL_US (100 * 1000) /* 100 ms */
 
+/* from include/linux/memcontrol.h, which userspace cannot include */
+#define MEMCG_CHARGE_BATCH	64
+
 /*
  * Checks if two given values differ by less than err% of their sum.
  */
diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index 437f2d35f205e..30af47ad69793 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -24,7 +24,7 @@
  * the maximum discrepancy between charge and vmstat entries is number
  * of cpus multiplied by 64 pages.
  */
-#define MAX_VMSTAT_ERROR (sysconf(_SC_PAGESIZE) * 64 * get_nprocs())
+#define MAX_VMSTAT_ERROR (sysconf(_SC_PAGESIZE) * MEMCG_CHARGE_BATCH * get_nprocs())
 
 #define KMEM_DEAD_WAIT_RETRIES        80
 
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index a24c1e07b2035..e9d3a04ecf7fc 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -18,11 +18,14 @@
 #include <netdb.h>
 #include <errno.h>
 #include <sys/mman.h>
+#include <sys/sysinfo.h>
 
 #include "kselftest.h"
 #include "cgroup_util.h"
 
-#define MEMCG_SOCKSTAT_WAIT_RETRIES        30
+/* enough page updates for a memory.stat read to flush, see MAX_VMSTAT_ERROR in test_kmem.c */
+#define MEMCG_FLUSH_BYTES	\
+	(2 * sysconf(_SC_PAGESIZE) * MEMCG_CHARGE_BATCH * get_nprocs())
 
 static bool has_localevents;
 static bool has_recursiveprot;
@@ -1333,7 +1336,8 @@ static int tcp_client(const char *cgroup, unsigned short port)
 	const char server[] = "localhost";
 	struct addrinfo *ai;
 	char servport[6];
-	int retries = 0x10; /* nice round number */
+	long budget = 4 * MEMCG_FLUSH_BYTES;
+	int rcvbuf = 64 * 1024;
 	int sk, ret;
 	long allocated;
 
@@ -1347,17 +1351,25 @@ static int tcp_client(const char *cgroup, unsigned short port)
 	if (sk < 0)
 		goto free_ainfo;
 
+	/* keep the data in the server's socket, the one charged to the cgroup */
+	ret = setsockopt(sk, SOL_SOCKET, SO_RCVBUF, &rcvbuf, sizeof(rcvbuf));
+	if (ret < 0)
+		goto close_sk;
+
 	ret = connect(sk, ai->ai_addr, ai->ai_addrlen);
 	if (ret < 0)
 		goto close_sk;
 
 	ret = KSFT_FAIL;
-	while (retries--) {
+	while (budget > 0) {
 		uint8_t buf[0x100000];
 		long current, sock;
+		ssize_t len;
 
-		if (read(sk, buf, sizeof(buf)) <= 0)
+		len = read(sk, buf, sizeof(buf));
+		if (len <= 0)
 			goto close_sk;
+		budget -= len;
 
 		current = cg_read_long(cgroup, "memory.current");
 		sock = cg_read_key_long(cgroup, "memory.stat", "sock ");
@@ -1366,7 +1378,7 @@ static int tcp_client(const char *cgroup, unsigned short port)
 			goto close_sk;
 
 		/* exclude the memory not related to socket connection */
-		if (values_close(current - allocated, sock, 10)) {
+		if (sock > 0 && values_close(current - allocated, sock, 10)) {
 			ret = KSFT_PASS;
 			break;
 		}
@@ -1411,6 +1423,7 @@ static int test_memcg_sock(const char *root)
 	unsigned short port;
 	char *memcg;
 	long sock_post = -1;
+	int flush_rounds = 3;
 
 	if (memcg_sockets_disabled())
 		return KSFT_SKIP;
@@ -1468,21 +1481,15 @@ static int test_memcg_sock(const char *root)
 	if (cg_read_long(memcg, "memory.current") < 0)
 		goto cleanup;
 
-	/*
-	 * memory.stat is updated asynchronously via the memcg rstat
-	 * flushing worker, which runs periodically (every 2 seconds,
-	 * see FLUSH_TIME). On a busy system, the "sock " counter may
-	 * stay non-zero for a short period of time after the TCP
-	 * connection is closed and all socket memory has been
-	 * uncharged.
-	 *
-	 * Poll memory.stat for up to 3 seconds (~FLUSH_TIME plus some
-	 * scheduling slack) and require that the "sock " counter
-	 * eventually drops to zero.
-	 */
-	sock_post = cg_read_key_long_poll(memcg, "memory.stat", "sock ", 0,
-					 MEMCG_SOCKSTAT_WAIT_RETRIES,
-					 DEFAULT_WAIT_INTERVAL_US);
+	/* the uncharge is done, but a flush still walking the CPUs can hide it from a read */
+	while (flush_rounds--) {
+		if (cg_run(memcg, alloc_anon, (void *)MEMCG_FLUSH_BYTES))
+			goto cleanup;
+
+		sock_post = cg_read_key_long(memcg, "memory.stat", "sock ");
+		if (!sock_post)
+			break;
+	}
 	if (sock_post)
 		goto cleanup;
 

-- 
2.43.0


