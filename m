Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41C3CC44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 08:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3477E6B0092; Thu,  9 Jul 2026 04:16:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31EF86B0093; Thu,  9 Jul 2026 04:16:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E0A6B0095; Thu,  9 Jul 2026 04:16:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F39876B0092
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:16:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C3BA140426
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:16:18 +0000 (UTC)
X-FDA: 84968530836.19.0A91DAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E6295A0008
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:16:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NmHmTCee;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783584976;
	b=fqWhAU19VBAlKMC1RnMTcmnc+emxcSmnlmczd9fKcbKVoR7kY067qXyBANSVYDjUNAPEuN
	gj800LEgOtsLzQzwvNpHgJRGES2mU25E/Iw3auTnsOqJePwYJa/qwFrNmouvfySoUsjQry
	i52XPrr9TzFJ2eM8+J+5VSKqevAhH18=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NmHmTCee;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783584976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWqM26o6P8eM5Qx/ljoWpy23OEgj04qhT8EVjOatyCY=;
	b=BaWN174DAlcfalrZlMC5HlanAPvrFgXqLa4d86Q8NIehdMJQrBtpO39ErLpM5IJxmfxcPv
	tb6EXIkXwnOGFfNapw0cuk6RAXLgde/ik2bkBe583vdGJBsQcnnyKgxhOKPnBQbGES7wxP
	gqYC0Up1xqFevoSgzonCFppmE1/cz0s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 821946001A;
	Thu,  9 Jul 2026 08:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E161F00A3A;
	Thu,  9 Jul 2026 08:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783584976;
	bh=aWqM26o6P8eM5Qx/ljoWpy23OEgj04qhT8EVjOatyCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NmHmTCee3X8f1bLKrHgQmWnc0gi1/z2V0METrdkfkYmtXlPdxEn7npLiM8VFckiHx
	 EY4OvD6HMEdARwOCDp9H0aIxHGeCUIXHGTReZY4uBN/4soQF92WrW+r0dCajeEUpD2
	 Mk/3jgt6H0xwxR78ymzhjxMQ5xLThLKyr8VV0fCJaUGYx4gv/L6c42nektKrNlLgLt
	 YW2lTta3ApfMmPEyoIA2/QenKZk8769nTt0R1uqp+Ds5jNw4C1HbkUw6D7B6MKoEwI
	 yEHlDeUP7kv50G8By9qdKH24xmeNYOl4a8NpxPx5OocOUfj/fftN/lpPD6v4PBizD7
	 RRjsgMMp/SAXQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	david@kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Cc: baolin.wang@linux.alibaba.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	ziy@nvidia.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v2 1/2] mm: allow smaller large folios to use lru_cache
Date: Thu,  9 Jul 2026 16:15:35 +0800
Message-Id: <20260709081536.82768-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260709081536.82768-1-baohua@kernel.org>
References: <20260709081536.82768-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E6295A0008
X-Rspam-User: 
X-Stat-Signature: p6bxc7spondrzgdj17ez9ir6nwdsn8xy
X-Rspamd-Server: rspam03
X-HE-Tag: 1783584976-100397
X-HE-Meta: U2FsdGVkX186dKF6hhYPdq5RF2y5Pv00Ispbqf2XVD8dgTv+Q9aAwB5NCQcwpFDe992Io0ab+BQktA3PwUdbhuTWpBlCm1udG3t5H178Fm7/bRPc7s4n9QOjKoAzmbSt/1fTYogpPhzfX4qclktXzrQ/blozV0Nwvi2NCs7cwe18yJH7QGLBD9236k5/dRxE/tXCiucoKk6S5q22FQg017Gmc6OKNI1As2SmLPfUHDDslMZtVQ8aXKnL2JfalLYawb97HZYadky1M+C1Dc1xeNr+Q16onkq6y8qBq5u+6yKPfvUGpNXa3q2RKaRTRJE3QCjbB7LEYVXSyzpfgnfYxggn5jV7G4KKgfb8VSTS8nxYxhX6v9oYL158i83Fs86Nh6s8JiKYfiDz9r7pG0L3GfO5Y/kJ7OnD7VweJ1ykbyCOIZ9rqqU43u+5capy1UapUQ9/Fg3g09lZ/1nsGZdC19JEIsnV0ITPXnnZ1Tcfcv0r69SH7xfEErmHIx3wypEtCwogpy6R+EdBwhXln+GjzTy4VTBYhw7WhDEFkxkpAExOYCUb+hvduk72owVrORAihPxSRu90mnPgJKL6kHrXWQYmfa7Za8NaEKI04JAErzJZ1HbH+frF28wWMxGIOGXZ+yCdYZ4c0a9j6le43xqHmB5g8sZqZvLYBo2mC9DgQwRNeD67x2Etkm2E+bELLDQzPLii1BrYO/YJdamgg9xrbtIqlVA7AqFXTKGljQFZ+TdJleB0b3ABv8l3ejMhQlBvU2GOneAoedf6CuLjS8iEu4AhiN0HGRHIeCdjLHECbN6vnVX4nMA/uDOZ1fZVwKBQnShbyei7/aXx23N4V34dG9MUfR1KZB7KxLxtGgGvJLd8edIQ4zMtaUy7Izz6q5rrQ/Egl7Eh6SbRRf5az2bAZS0CHDocRkmB5LXsFUjsInPfzKGwkR44HFpt7NRWvmzJkuI9axrWKkKTgoB6N5X
 BUdeLUwp
 vVktjFJ3W5NjOlNL5CQ52U34XTev97NwT+xkJ2wXiGWFbODnY3eCeQLBnsvGekYnp8nnloUF2+kmHbJQlN5Lu1OupyXW0nGsPEHyurQ+EN54WPlkxpdYDVRbYxQ1zkmzB+O29u3bpU6p1WiN8VSxxCSLde0Zi+luw71oEv8+06wMrp23TEm6Q5jdEge8laq25jw1CAUdHLw6GyrVl6248BksoOmNmPpGaVqoB17efo5eKGr1nW2+mXY+E960ZdQbttoXcxeBQE4eEFXb5qEh6cHvRJtQCPISBYGKi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For a system which primarily uses smaller orders for large folios,
it could be beneficial to enable lru_cache to avoid lock contention.

For large folios with higher orders, the number of folios involved
would be small, so the contention is less significant.

The following small program runs on a system with 16 KiB
mTHP enabled.

 #include <pthread.h>
 #include <sys/mman.h>
 #include <string.h>

 #define NUM_THREADS     20
 #define MEM_SIZE        (16 * 1024 * 1024)
 #define LOOP_COUNT      1000

 void* thread_worker(void* arg) {
     void *addr = mmap(NULL, MEM_SIZE, PROT_READ | PROT_WRITE,
                       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

     for (int i = 0; i < LOOP_COUNT; i++) {
         memset(addr, 0x55, MEM_SIZE);
         madvise(addr, MEM_SIZE, MADV_DONTNEED);
     }

     munmap(addr, MEM_SIZE);
     pthread_exit(NULL);
 }

 int main() {
     pthread_t threads[NUM_THREADS];

     for (long t = 0; t < NUM_THREADS; t++) {
         pthread_create(&threads[t], NULL, thread_worker, (void*)t);
     }

     for (int t = 0; t < NUM_THREADS; t++) {
         pthread_join(threads[t], NULL);
     }

     return 0;
 }

Before patch:
root@barry-desktop:/home/barry# time ./a.out

real	0m20.233s
user	0m21.739s
sys	6m21.143s

Perf lock report:
      Name   acquired  contended     avg wait   total wait     max wait     min wait

             21158662   21158662     29.20 us     10.30 m      67.83 us       884 ns
                13547      13547     14.68 us    198.93 ms    135.39 us       982 ns
 rcu_state         41         41      1.83 us     75.21 us      3.46 us      1.27 us
 rcu_state         34         34      1.83 us     62.09 us      2.60 us      1.16 us
                    5          5     21.31 us    106.57 us     25.77 us     18.17 us
                    5          5      3.01 us     15.07 us      5.19 us      1.53 us
                    3          3      6.42 us     19.26 us      9.63 us      4.22 us
                    3          3      4.20 us     12.61 us      7.45 us      2.10 us
                    2          2      5.03 us     10.06 us      7.88 us      2.18 us
                    2          2      2.79 us      5.59 us      3.34 us      2.25 us
                    1          1      4.70 us      4.70 us      4.70 us      4.70 us
                    1          1      9.77 us      9.77 us      9.77 us      9.77 us

After patch:
root@barry-desktop:/home/barry# time ./a.out

real	0m17.796s
user	0m24.962s
sys	5m28.774s

Perf lock report:
      Name   acquired  contended     avg wait   total wait     max wait     min wait

              1407013    1407013     25.44 us     35.80 s     127.83 us       972 ns
               845113     845113     47.96 us     40.54 s     152.86 us      1.21 us
 rcu_state       1920       1920      5.87 us     11.27 ms     25.02 us      1.76 us
 rcu_state       1889       1889      5.80 us     10.96 ms     30.35 us      1.61 us
                  140        140      3.97 us    555.52 us     12.51 us      1.20 us
                   10         10     61.34 us    613.42 us     96.90 us     44.48 us
                    8          8     24.03 us    192.26 us     37.64 us      6.95 us
                    8          8     12.32 us     98.56 us     25.55 us      4.16 us

Both system time and lock contention are noticeably reduced.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 include/linux/swap.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8d19be675baf..9c5f7a11c7b0 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -316,9 +316,9 @@ static inline bool folio_may_be_lru_cached(struct folio *folio)
 	/*
 	 * Holding PMD-sized folios in per-CPU LRU cache unbalances accounting.
 	 * Holding small numbers of low-order mTHP folios in per-CPU LRU cache
-	 * will be sensible, but nobody has implemented and tested that yet.
+	 * will be sensible.
 	 */
-	return !folio_test_large(folio);
+	return folio_order(folio) < PAGE_ALLOC_COSTLY_ORDER;
 }
 
 extern atomic_t lru_disable_count;
-- 
2.39.3 (Apple Git-146)


