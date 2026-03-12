Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6893FED2C7
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 04:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1550A6B0088; Thu, 12 Mar 2026 00:07:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10C5B6B0093; Thu, 12 Mar 2026 00:07:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02BF26B0095; Thu, 12 Mar 2026 00:07:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7B7A6B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 00:07:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B57A51A0754
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:07:17 +0000 (UTC)
X-FDA: 84536076114.06.F289287
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id CE907180002
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:07:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PfTA9XNZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773288435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/+1K6U2HNH5Jf/hAFVeExQ4SDvY1teH+hVqb1jlKGzs=;
	b=YG+Y4V2zgjSAA8FXFvcK3ww7OqlYzYh8zxJ2ZFYTG+kJidCUlXbV0OAlKO2HmA7IeA/U+E
	fhQrdV+ekhn+kXHh13MGoBv4m3arJfmEIyjoq9A9Vv9j6Iu6aHeEFzShVGxtwMZV2+Uwef
	P59uySJobKj+ZOWtkNbVmj4YxSERQnM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773288435; a=rsa-sha256;
	cv=none;
	b=2QQAEFCbukwZC0j0/eYhPbRaKnXnc/YxVpWVgnT0zAHr38uJuANn0OKbAS1KsTR1s5oM3x
	HCKxIYD88tbi3MrR+9L44klR3AymbM2/QseEc8GWWwTg5LAE4Rgjg68Lyi1QNHaOONarVY
	j/pNC5St/ENWyXHUU4/v90JeBROab2A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PfTA9XNZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773288435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/+1K6U2HNH5Jf/hAFVeExQ4SDvY1teH+hVqb1jlKGzs=;
	b=PfTA9XNZAN70TliS2vbaTnpUlhzM1XA/8L7L8rBSrJ4CM0UOWHQKUnLtW8FAaq3Rc1zm7H
	eCYupAyOxK4/FxVSbx67bOehLUgW0tcjz2WDtGVzefH0Og4NVkOt7RGSvT+mn5bOCriZYp
	LAgpmhMeNUotuLOKCP154+CEldUBEcU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668-u6ygS8FqOzGplCIXW1Kc_Q-1; Thu,
 12 Mar 2026 00:07:11 -0400
X-MC-Unique: u6ygS8FqOzGplCIXW1Kc_Q-1
X-Mimecast-MFC-AGG-ID: u6ygS8FqOzGplCIXW1Kc_Q_1773288429
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5C883195608A;
	Thu, 12 Mar 2026 04:07:09 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.57])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E2EA219560A6;
	Thu, 12 Mar 2026 04:07:03 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: mkoutny@suse.com,
	yosryahmed@google.com
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH v2 6/7] selftests/cgroup: replace hardcoded page size values in test_zswap
Date: Thu, 12 Mar 2026 12:06:26 +0800
Message-ID: <20260312040627.55257-6-liwang@redhat.com>
In-Reply-To: <20260312040627.55257-1-liwang@redhat.com>
References: <20260312040627.55257-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: p6wXLF8Hva0cxv6MFJJZuZJR_RG-BXUjSfM1gt_hfU0_1773288429
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CE907180002
X-Stat-Signature: 7uf754z7qs1ajpq5t17py16tf99hbnc1
X-Rspam-User: 
X-HE-Tag: 1773288435-122477
X-HE-Meta: U2FsdGVkX180X4NMzJc0vxinuZjny2oPLgvt1AuuBV4lBrjeWqt/p7cqqBOqmhEQ1lusfutAlFU1ioviuLEGF7z83AbsV5ZagwC8UjwOyM5+UtYFj2gt5clIj1lAeum+/jTbNRKy1R3/e3MF8bqTqHmzQHMnjibnMy3PPt/k/5XM30dWCwd8eN1Uf1Oky9tUO7oIyodzH+t9fHnA9vj8x/DP3yyBEcrzaBU1qZCIXNGKmroiAohygr9CcvL+rQKGeHyXO0YbS3LRW8BjMjAUy72zl77YRrp/3ZnF1uA7JOPi6uLkOi8VVZOju5rJTbL1ew0+JVl7b+5uGvEQQFEV4WpTDEB1gMKm3xSMmbPa4FMBvqLEBqMkzvf8nHKfX7zaPYDUPtPleRiySPKwv4lefdB0ihLmYYbpz3OTdrhM+0mao3mOf9MCzbBTfz0O3kx4gc/nvp9nW84a4oVkicPVIJ+wqIuqvq1P8rERkFFnWc80UdpaeB/7FxVaSikOP43BlHdAgu0XtsXzzYOwOzmXU7pRPYQ0GFQaZaKjgTxmDzHMWg0DNaY4l3UZKHNI/3nh1eJuAzKZxNzCAMDY+YNqkslBx6HxKQmZZkKkvV7q99cHGjfFardA6hTpUqpIvgdWcqunSR7AD4CRh059CF84yC8YI3V8mRX2RcquvZBiDVXXd9yAagPWUg1WiLs9U6TxMeKkHTojUPH0LdrJNCVZ1wH9nT73TBGR0K1WRvcLKebxlx2TtShNEq4jUmnrYsXWCieZFmuwCsCxStIgkonhfdsuvzCj0T0fDSuTvuEBMAV/dCuEwWHiLfWAJbXGS5pmKuGOJ7IT/hHcNIM/so9IUuJZSGit80qMKvtVBn3lND2QFIHqsqyPrg7q545oPOaIjnJSO14v+93lvaXa6oMiuL9r/27O8RplC5EB7HZjOZW7W+JKCG754/gRawOrhOdMFtjp5JqtFS2YfV3EiT3
 0hru73vR
 vuN10vY1mL1fgPTPOclHUeOG/BHwvsxGy/LoaCzTd8eMjRLf7a9hfOTpOlu0KITn+cBnwT0fxqQfXlf8P8NsplW8aiRixPD/QtogpGuZyEox8BQtc9JgaQGDWI/JoqoOX/zN6iU0mONuPQXvUOQlioaTitk3Zeth0ZMeXyzPq9ssyuzNCkLRGSk7fQKpsvUvuyTFlFat8HBT5Vuu+xIu6iWsRtvZFlg9GXSeKoLKBdUd09fILbvqPdb6UOjFzekyQ8q9ik7qS10uD7SM8P3LRpvRo6kVTAwXzGbG6G0GE6lhkYoIcYr3sXX88fJJhlY9pMPcQj85nNoYrIfhcxn49lV77Hprrb9dZB/RWFydCAdWdOCJilrpraSC9QJMPOo9bId2tPhSWcX0gA5u234kBTiNLCh6/ua1Qpwar/jK3+jWXcfkKXGV5SW08T0gVT5Or2n4+WWMN4nC6D8E3wms/u1mzCpirViPSoP/Tf/V9txjwfHYDt6dAyMFDrX4Qr86J5CLTPbielW/Lw0xMZog21hGfFyT+m4k9VHEayNRqsnbPuO5eNuyOtjCDkXiNtdNhNhy22y3EXuNHJ3b3YCVFBGus2jnT2pKHblrR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_zswap uses hardcoded values of 4095 and 4096 throughout as page
stride and page size, which are only correct on systems with a 4K page
size. On architectures with larger pages (e.g., 64K on arm64 or ppc64),
these constants cause memory to be touched at sub-page granularity,
leading to inefficient access patterns and incorrect page count
calculations, which can cause test failures.

Replace all hardcoded 4095 and 4096 values with a global pagesize
variable initialized from sysconf(_SC_PAGESIZE) at startup, and remove
the redundant local sysconf() calls scattered across individual
functions. No functional change on 4K page size systems.

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 654874fb371b..4eb88930b45f 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -13,6 +13,8 @@
 #include "kselftest.h"
 #include "cgroup_util.h"
 
+static size_t pagesize;
+
 static int read_int(const char *path, size_t *value)
 {
 	FILE *file;
@@ -68,11 +70,11 @@ static int allocate_and_read_bytes(const char *cgroup, void *arg)
 
 	if (!mem)
 		return -1;
-	for (int i = 0; i < size; i += 4095)
+	for (int i = 0; i < size; i += pagesize)
 		mem[i] = 'a';
 
 	/* Go through the allocated memory to (z)swap in and out pages */
-	for (int i = 0; i < size; i += 4095) {
+	for (int i = 0; i < size; i += pagesize) {
 		if (mem[i] != 'a')
 			ret = -1;
 	}
@@ -83,7 +85,6 @@ static int allocate_and_read_bytes(const char *cgroup, void *arg)
 
 static int allocate_bytes(const char *cgroup, void *arg)
 {
-	long pagesize = sysconf(_SC_PAGESIZE);
 	size_t size = (size_t)arg;
 	char *mem = (char *)malloc(size);
 
@@ -263,7 +264,6 @@ static int test_zswapin(const char *root)
  */
 static int attempt_writeback(const char *cgroup, void *arg)
 {
-	long pagesize = sysconf(_SC_PAGESIZE);
 	size_t memsize = MB(4);
 	char buf[pagesize];
 	long zswap_usage;
@@ -416,7 +416,6 @@ static int test_zswap_writeback_disabled(const char *root)
 static int test_no_invasive_cgroup_shrink(const char *root)
 {
 	int ret = KSFT_FAIL;
-	long pagesize = sysconf(_SC_PAGESIZE);
 	size_t control_allocation_size = MB(64);
 	char *control_allocation = NULL, *wb_group = NULL, *control_group = NULL;
 
@@ -479,7 +478,7 @@ static int no_kmem_bypass_child(const char *cgroup, void *arg)
 		values->child_allocated = true;
 		return -1;
 	}
-	for (long i = 0; i < values->target_alloc_bytes; i += 4095)
+	for (long i = 0; i < values->target_alloc_bytes; i += pagesize)
 		((char *)allocation)[i] = 'a';
 	values->child_allocated = true;
 	pause();
@@ -527,7 +526,7 @@ static int test_no_kmem_bypass(const char *root)
 	min_free_kb_low = sys_info.totalram / 500000;
 	values->target_alloc_bytes = (sys_info.totalram - min_free_kb_high * 1000) +
 		sys_info.totalram * 5 / 100;
-	stored_pages_threshold = sys_info.totalram / 5 / 4096;
+	stored_pages_threshold = sys_info.totalram / 5 / pagesize;
 	trigger_allocation_size = sys_info.totalram / 20;
 
 	/* Set up test memcg */
@@ -554,7 +553,7 @@ static int test_no_kmem_bypass(const char *root)
 
 		if (!trigger_allocation)
 			break;
-		for (int i = 0; i < trigger_allocation_size; i += 4095)
+		for (int i = 0; i < trigger_allocation_size; i += pagesize)
 			trigger_allocation[i] = 'b';
 		usleep(100000);
 		free(trigger_allocation);
@@ -565,8 +564,8 @@ static int test_no_kmem_bypass(const char *root)
 		/* If memory was pushed to zswap, verify it belongs to memcg */
 		if (stored_pages > stored_pages_threshold) {
 			int zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
-			int delta = stored_pages * 4096 - zswapped;
-			int result_ok = delta < stored_pages * 4096 / 4;
+			int delta = stored_pages * pagesize - zswapped;
+			int result_ok = delta < stored_pages * pagesize / 4;
 
 			ret = result_ok ? KSFT_PASS : KSFT_FAIL;
 			break;
@@ -622,6 +621,7 @@ int main(int argc, char **argv)
 	char root[PATH_MAX];
 	int i, state;
 
+	pagesize = sysconf(_SC_PAGESIZE);
 	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
-- 
2.53.0


