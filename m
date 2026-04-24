Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7801EFAD3F3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 04:02:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D536D6B0096; Fri, 24 Apr 2026 00:02:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28C26B0098; Fri, 24 Apr 2026 00:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C676E6B0099; Fri, 24 Apr 2026 00:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B74E66B0096
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:02:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50F481607B7
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:02:16 +0000 (UTC)
X-FDA: 84692101872.27.D20C310
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8B337C0002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:02:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EYE+6658;
	spf=pass (imf28.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777003334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LjK5yqAtFeuYG5/nOFq4FfdHS80zSO/SlqOxhS/ymI4=;
	b=vw5Pseu/9xgVtdLpoRzhKBA3tL1txR6sGjiNhT6kNgfc8+GLZ7fzs79NIa30Ud6qAqP5S7
	tT4LGNhNn9wt4K8hWjVBZ7/cRV4otZXSp40abKRBybuypybQZW2FvFe/EvwYGM59viHANg
	UyPITiNSoT1xGh5zr23bHggXhbBJ3cg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EYE+6658;
	spf=pass (imf28.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777003334; a=rsa-sha256;
	cv=none;
	b=JvidKjsjS+QNWyxAGjDLFlq3zhZ7NruVYa0QL1vr0br+UTN9STn7Dk8c4uXr5G1tSXNtXK
	cuTtzJv5ylbegxm92Qava5rVOCx0OpbkMzLektEcNCKkcOqSII/omfNH0koGByAfzFBAfv
	F9D6yy8YzR3yyLum1bU669Dgzmeuz8Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777003333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LjK5yqAtFeuYG5/nOFq4FfdHS80zSO/SlqOxhS/ymI4=;
	b=EYE+6658+qzlpBjMB4PwDElgXgGp08FhPENSxTQNPqUc2aYW6jcVr8xj5pVl2S8ssOcadu
	5Y9WvQfr/ISxYT0+eZOIwq9T3Iktejxsx6zV+H0Cil3nxWlUFg+sMhZixIwGfmRbJX2DOd
	RSqabsSufhgie/GRrHt+vheFhUyEghs=
From: Li Wang <li.wang@linux.dev>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	longman@redhat.com,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	jiayuan.chen@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	mkoutny@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH v7 5/8] selftests/cgroup: replace hardcoded page size values in test_zswap
Date: Fri, 24 Apr 2026 12:00:56 +0800
Message-ID: <20260424040059.12940-6-li.wang@linux.dev>
In-Reply-To: <20260424040059.12940-1-li.wang@linux.dev>
References: <20260424040059.12940-1-li.wang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8B337C0002
X-Stat-Signature: 8qkwy7hru3848c4p86w434kxhetot13w
X-Rspam-User: 
X-HE-Tag: 1777003334-524261
X-HE-Meta: U2FsdGVkX1/FFlo9T0Oj4KDUBN3eOCHPOp42rxjfodb2DVp57BUsRvj7aTGoalVwMaC2zI3S0rdECDuo+ORQfW5X4ZuoPi0zQ6bK89J5AXAONFxjOPvyteMGfqAGsP33XxCZs+XSA4LWTwTRR6e+AnQ/Qd1LraeIZ50A3rMX2ilgo49vXRwM2QtkaksdxChG93RN3YkcU1YfIYQCfxICZmlUQlNUzZCt3buJYCvOhaJOcQk1jdJ5RDEWFYgFIRShR7jR1cYO2nDw9crJuUFdpqpHltIt++2tare9h7orSstd0m5qYm7iYZow9rttQqxmBIdzyoJJgJ3Pt1tQOdwPinbuzgHF1h01IA+Yc08Sr0WsIBw8rl5Hf8xTND7cHyswM5/OIRnYXc/pirJBJ+C+K681wVBNk3ir9OKPlVzlxmcm3/r+TnyKyvYnEzLTALX51NEB62p+295NRbyZbUghuIbqXem7HZG5Ygr6uzmrDaqyD3tsQKs0zLt+lTGjpsQrxRIZf+PwCrJ0Vl4Rj2CyCBaOJ1bKdqX69LfNAijylX/NoBJPzeZbXROKMVPWEIfPy2PWUrqgHqxEYmZVb/i9VwKSBAkou0psj5j2uGrEGBLB9c7/IaxWCGWXEinRaNnB2q5zBypvS89rSGPLqmcK8Lxx8DtRsEXqEdNlQZIxKfuTQxP4ieGErWczYHgIP1h2CqjpP2IA6+cbvQz2jEGQgNsh2v3i3V865jaVF8HycB1njugwoW9wp3S8kidInyd6phwSnnNYP28ey2W/XMivqU5lWsHJYRdUbO/YFQw0w6M+g14cIND4sK6agWu55RzN//yqeRZsB6+peyLNH3XSzVPrXKgKw5Rw0IiK5Pfor9WGmmGQmMbK9Wdp/RMLqYGgmnaug32OpVDeZgSKvIHf0aqJqnldzh/9R2TGaLAPIePki9qfzDEU/ADTZ4SCQ+grIr0o8ePYddV43iZNg5G
 er+UcPjW
 +Muu5upjhjn4OWU69nU2QgZBGfRtd2Eqt4IvswJG829DXQIqI5rF4LocpriW0JkJDyRqetxt/ELhcaLZvHJqzt6R+eCSUUvAX+zg7b/mWcqeXE+JgKSzkBWUOY8QFx9mcydzzSzbAdVqKsoCEjwGdOZcPLYJZpiw3K+LzVQRsJhZlezTX0gPbIZrmUQJo/+AsWu+yby5xw6CG9TaNL3RdMMd770YsV9zh+HP2UImhdrtzfz4ooy/Cby+RAcxazTSa3CqgzFY2LqdcNh4yuI+v7h7rSXbkAkVO/dcunWFKb4i1XL/Qz5cbbKxjDwpR2B+xn7k7yBcFoYuOGnb0kjDBVh8Z63fTF0ZzW8O0kBrhkLcMnMUaPxIBFsvLCW5v64r9ni0yFjJZ1Oc9g+/DOwPaL9AWGlAqdSb/ALKDZ5u/nzAny1iavxxl5SeHQJgr4XbPo9NI
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

Signed-off-by: Li Wang <li.wang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Yosry Ahmed <yosry@kernel.org>
---
 tools/testing/selftests/cgroup/test_zswap.c | 45 ++++++++++++---------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 37aa83c2f1b..23ff11390a3 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -15,6 +15,8 @@
 #include "kselftest.h"
 #include "cgroup_util.h"
 
+static int page_size;
+
 #define PATH_ZSWAP "/sys/module/zswap"
 #define PATH_ZSWAP_ENABLED "/sys/module/zswap/parameters/enabled"
 
@@ -73,11 +75,11 @@ static int allocate_and_read_bytes(const char *cgroup, void *arg)
 
 	if (!mem)
 		return -1;
-	for (int i = 0; i < size; i += 4095)
+	for (int i = 0; i < size; i += page_size)
 		mem[i] = 'a';
 
 	/* Go through the allocated memory to (z)swap in and out pages */
-	for (int i = 0; i < size; i += 4095) {
+	for (int i = 0; i < size; i += page_size) {
 		if (mem[i] != 'a')
 			ret = -1;
 	}
@@ -93,7 +95,7 @@ static int allocate_bytes(const char *cgroup, void *arg)
 
 	if (!mem)
 		return -1;
-	for (int i = 0; i < size; i += 4095)
+	for (int i = 0; i < size; i += page_size)
 		mem[i] = 'a';
 	free(mem);
 	return 0;
@@ -167,7 +169,7 @@ static int test_swapin_nozswap(const char *root)
 	int ret = KSFT_FAIL;
 	char *test_group, mem_max_buf[32];
 	long swap_peak, zswpout, min_swap;
-	size_t allocation_size = sysconf(_SC_PAGESIZE) * 512;
+	size_t allocation_size = page_size * 512;
 
 	min_swap = allocation_size / 4;
 	snprintf(mem_max_buf, sizeof(mem_max_buf), "%zu", allocation_size * 3/4);
@@ -245,7 +247,7 @@ static int test_zswapin(const char *root)
 		goto out;
 	}
 
-	if (zswpin < MB(24) / sysconf(_SC_PAGESIZE)) {
+	if (zswpin < MB(24) / page_size) {
 		ksft_print_msg("at least 24MB should be brought back from zswap\n");
 		goto out;
 	}
@@ -272,9 +274,8 @@ static int test_zswapin(const char *root)
  */
 static int attempt_writeback(const char *cgroup, void *arg)
 {
-	long pagesize = sysconf(_SC_PAGESIZE);
 	size_t memsize = MB(4);
-	char buf[pagesize];
+	char buf[page_size];
 	long zswap_usage;
 	bool wb_enabled = *(bool *) arg;
 	int ret = -1;
@@ -289,11 +290,11 @@ static int attempt_writeback(const char *cgroup, void *arg)
 	 * half empty, this will result in data that is still compressible
 	 * and ends up in zswap, with material zswap usage.
 	 */
-	for (int i = 0; i < pagesize; i++)
-		buf[i] = i < pagesize/2 ? (char) i : 0;
+	for (int i = 0; i < page_size; i++)
+		buf[i] = i < page_size/2 ? (char) i : 0;
 
-	for (int i = 0; i < memsize; i += pagesize)
-		memcpy(&mem[i], buf, pagesize);
+	for (int i = 0; i < memsize; i += page_size)
+		memcpy(&mem[i], buf, page_size);
 
 	/* Try and reclaim allocated memory */
 	if (cg_write_numeric(cgroup, "memory.reclaim", memsize)) {
@@ -304,8 +305,8 @@ static int attempt_writeback(const char *cgroup, void *arg)
 	zswap_usage = cg_read_long(cgroup, "memory.zswap.current");
 
 	/* zswpin */
-	for (int i = 0; i < memsize; i += pagesize) {
-		if (memcmp(&mem[i], buf, pagesize)) {
+	for (int i = 0; i < memsize; i += page_size) {
+		if (memcmp(&mem[i], buf, page_size)) {
 			ksft_print_msg("invalid memory\n");
 			goto out;
 		}
@@ -441,7 +442,7 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 	if (cg_enter_current(control_group))
 		goto out;
 	control_allocation = malloc(control_allocation_size);
-	for (int i = 0; i < control_allocation_size; i += 4095)
+	for (int i = 0; i < control_allocation_size; i += page_size)
 		control_allocation[i] = 'a';
 	if (cg_read_key_long(control_group, "memory.stat", "zswapped") < 1)
 		goto out;
@@ -481,7 +482,7 @@ static int no_kmem_bypass_child(const char *cgroup, void *arg)
 		values->child_allocated = true;
 		return -1;
 	}
-	for (long i = 0; i < values->target_alloc_bytes; i += 4095)
+	for (long i = 0; i < values->target_alloc_bytes; i += page_size)
 		((char *)allocation)[i] = 'a';
 	values->child_allocated = true;
 	pause();
@@ -529,7 +530,7 @@ static int test_no_kmem_bypass(const char *root)
 	min_free_kb_low = sys_info.totalram / 500000;
 	values->target_alloc_bytes = (sys_info.totalram - min_free_kb_high * 1000) +
 		sys_info.totalram * 5 / 100;
-	stored_pages_threshold = sys_info.totalram / 5 / 4096;
+	stored_pages_threshold = sys_info.totalram / 5 / page_size;
 	trigger_allocation_size = sys_info.totalram / 20;
 
 	/* Set up test memcg */
@@ -556,7 +557,7 @@ static int test_no_kmem_bypass(const char *root)
 
 		if (!trigger_allocation)
 			break;
-		for (int i = 0; i < trigger_allocation_size; i += 4095)
+		for (int i = 0; i < trigger_allocation_size; i += page_size)
 			trigger_allocation[i] = 'b';
 		usleep(100000);
 		free(trigger_allocation);
@@ -567,8 +568,8 @@ static int test_no_kmem_bypass(const char *root)
 		/* If memory was pushed to zswap, verify it belongs to memcg */
 		if (stored_pages > stored_pages_threshold) {
 			int zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
-			int delta = stored_pages * 4096 - zswapped;
-			int result_ok = delta < stored_pages * 4096 / 4;
+			int delta = stored_pages * page_size - zswapped;
+			int result_ok = delta < stored_pages * page_size / 4;
 
 			ret = result_ok ? KSFT_PASS : KSFT_FAIL;
 			break;
@@ -622,7 +623,7 @@ static int allocate_random_and_wait(const char *cgroup, void *arg)
 	close(fd);
 
 	/* Touch all pages to ensure they're faulted in */
-	for (size_t i = 0; i < size; i += PAGE_SIZE)
+	for (size_t i = 0; i < size; i += page_size)
 		mem[i] = mem[i];
 
 	/* Use MADV_PAGEOUT to push pages into zswap */
@@ -752,6 +753,10 @@ int main(int argc, char **argv)
 	char root[PATH_MAX];
 	int i;
 
+	page_size = sysconf(_SC_PAGE_SIZE);
+	if (page_size <= 0)
+		page_size = BUF_SIZE;
+
 	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
-- 
2.53.0


