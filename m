Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09B46CC6B03
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 06:38:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DDD86B0096; Thu,  2 Apr 2026 02:38:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68DF86B0098; Thu,  2 Apr 2026 02:38:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5562D6B0099; Thu,  2 Apr 2026 02:38:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 40A356B0096
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:38:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE8AE1B8017
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:38:23 +0000 (UTC)
X-FDA: 84612661686.18.337668E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2300D20007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:38:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cRIsrKNy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775111902; a=rsa-sha256;
	cv=none;
	b=hMPzr5/ryJxV7//QaSCOdZ04go1C13nycyKuvrWslneyN5Se2ia5fyGM7vGghmuQY0kh7m
	xizv7dk07GXNBWAxXUq41cfqvvNOuDdhfFTTxeEMjeL+BxcEaVeQ0f0rTfcQctQH6chba8
	ibHN7J1OBzudUheyH9HJnRpl3+uI/sA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cRIsrKNy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775111902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LSR6JP1MlIyPdrrVRarFMh7ouoNO5yIpt67p9cGm3mU=;
	b=U1QkYNUAcs+EJaCTzIemAqi4wADVifFqjb8JU7zhvnKPYg3LmqUEil/60oJV8xRwoeq8aS
	t7AOBetWZFSDCY0yRk8ZqFdO8GbAq7M7zttI24meCUuRFC1KJawb5JSslicAgsqJK3Ibbb
	VRuIMFlERGSb0nEbF8ZzTp2xZV+LYAA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775111901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LSR6JP1MlIyPdrrVRarFMh7ouoNO5yIpt67p9cGm3mU=;
	b=cRIsrKNyugSzRYuV2nzW07y1/WXCoJ9lJvwVq/TilnUzDAW3hx88H48Y0iaHp/qq+JSL53
	yGALybTRut5JZzS4HnrHBC4d+l+kXfZxbAyDnzr2vFVKSaBRGfi+8SHRoXDX2aTqeZQ4Lz
	2q9ub16XM/IBpeghkbOl3YwgJqh6fYc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-282-Hl_RMtkzOY2MBUzmdjZPgw-1; Thu,
 02 Apr 2026 02:38:18 -0400
X-MC-Unique: Hl_RMtkzOY2MBUzmdjZPgw-1
X-Mimecast-MFC-AGG-ID: Hl_RMtkzOY2MBUzmdjZPgw_1775111895
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 694FC1800365;
	Thu,  2 Apr 2026 06:38:15 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.158])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B2A691800351;
	Thu,  2 Apr 2026 06:38:06 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	david@kernel.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	mhocko@suse.com,
	shuah@kernel.org,
	chengming.zhou@linux.dev,
	longman@redhat.com,
	nphamcs@gmail.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH v6 5/8] selftests/cgroup: replace hardcoded page size values in test_zswap
Date: Thu,  2 Apr 2026 14:37:11 +0800
Message-ID: <20260402063714.55124-6-liwang@redhat.com>
In-Reply-To: <20260402063714.55124-1-liwang@redhat.com>
References: <20260402063714.55124-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: LynSUFwmrXH27vaL6b2t3nZmDb_cw4efzwd5tzcgfSg_1775111895
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tfd8sxy5iej6hk8esnbytnx98ioj9i65
X-Rspamd-Queue-Id: 2300D20007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775111901-457550
X-HE-Meta: U2FsdGVkX18ny208DCB5US0ateHhMCKS/mHPsJer82WVkGw55Ot5PxkevvfAAgEtAOokxtnkVkjG7n17pYmNCymFkjaH/nSr0dEpiyF3WQWKNHr1wsjo3MvgkbVmUqKLJ2jtOfQFGBt8fz7f8V9XTHjrxPCdcIZyQe2U+zpKuhaAGcz9buT0iAMnxlyxqzt1jrmpLutO4HTWFa7w9GFHy7oajV6ZcX3STdRLCoEq+K1X08D2qDgaX3SH+narrMhgDJlMrEEUje7L9NS4wBNgT/7bVKFq+Myjar34B5YpgsEN6N7snxKlkFBcmRjzKmWMbyy7FzHj61NtUzuOXdS9isVL0kjgEWJeCzLEeVhAGO1f0BkGVvgPVchX9/eMl4UKUylxUGcVpxM9pi7u+kzxsVsQZJHBf9WL7wBQsadKrWspcheiV973ji7uTlgxs+ddwn9nBS39xnEARaAuiOnBPOEh11XTq6k6FmXGE4tuOaIRhLILr6dLsBLpPxBdbeh+ITnOgIKE0HIiNUUAjUFfWbz/Soma9rpHrHeiTQmn8R4pj1B20Wzk9Rf4Yz6ElcQI2bd2cKj7yjblHdVKO7e0DRU6ux+oQziUJNcZZjN9+ZG/JiZ8AXlgIFuCv4M/K0tpqKhRv05hGctoqhGcg9bTQwNB0TVNrp6qrxmrhZS40Xpw+s2sx/H5h8zeOQJ56GvMJLIJwdKyEl71V9TIhSq1ITR1sWc0pTB2jAJvJFdnatDurAzGSsPRDDqyVnXf04Xljym5mwwzX6onVe8Wh5bfplMDuoCkgusjcLgcVF6X9YfvSMTBN5fppAM24zR5xMHhMXK0kvW2b1C6/b5KCaRLwpiuwP2MEiAmQ3IPDOSqJ1uYGRsUUvanF5ZCqWd0CWdyjttsNsHEo/gvjlxZ7oziY4C53lRbjH2YFb9ENDe6FTRkFPlgyNvfF5T/0jOm7rBtuKvwnA9l58v0BVBMKR/
 VfFkicDN
 fDGerZTRFHw0+WHk+cmCYXNIxV+8QlMW+CiApKN1D4pbu5GceS/n+l2VHGWplHxNApJDEUlW2JSjUFeWueqGTGRJ3zaQVbe+vWxMGmS6R/cbtdjhJOLkch1LMdk9gdm5lM0EgrTCJYunC9EQPP9LDbZZ23jvFACFriD7ibBCPHBBbG39UEQf1IOTMjJ/xPEewo8XXshlWejKy+ohnxmE4Dk6Qw8ce56OYFe5NFKW21EHC3ml9VW2UVjJ2puPgNiJg5fzcvc29lGp5x/dzV9XfLa32IEg/JOVR/wJcrLjlUjX+9t4gsPGCVenVmJ9pnzB9YXT/UhfoMAuDMDBILQKBCuelNX0UjUFhz//MaeaqbF5kU7aC/NIXlDdZc+idAwotxlsyn51thauwQQvqIhYDM+3IiKErEEM4ElZG7g68DWyA3UrTXsMcdCgk7sZ6pSnyiFZwR5NgbCwScm/LxEW98uud3EdvBgiuUbhpY/1EYf6q/9qwPQ5PHDT9LylXSIfsUSM/oZ47cmXys9iT35mMqujvfGM5KL/8z00IcBp3PncwdIyllRLejnlWHxFEJ98cbkaL0bRxtPFPl9g=
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
Acked-by: Yosry Ahmed <yosry@kernel.org>
---

Notes:
    v6:
    	- Use page_size replace the sysconf(_SC_PAGE_SIZE).
    v5:
    	- Change pagesize by the global page_size.
    v1-4:
    	- No changes.

 tools/testing/selftests/cgroup/test_zswap.c | 43 ++++++++++++---------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 516da5d52bfd..db4889bef6d4 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -13,6 +13,8 @@
 #include "kselftest.h"
 #include "cgroup_util.h"
 
+static int page_size;
+
 #define PATH_ZSWAP "/sys/module/zswap"
 #define PATH_ZSWAP_ENABLED "/sys/module/zswap/parameters/enabled"
 
@@ -71,11 +73,11 @@ static int allocate_and_read_bytes(const char *cgroup, void *arg)
 
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
@@ -91,7 +93,7 @@ static int allocate_bytes(const char *cgroup, void *arg)
 
 	if (!mem)
 		return -1;
-	for (int i = 0; i < size; i += 4095)
+	for (int i = 0; i < size; i += page_size)
 		mem[i] = 'a';
 	free(mem);
 	return 0;
@@ -165,7 +167,7 @@ static int test_swapin_nozswap(const char *root)
 	int ret = KSFT_FAIL;
 	char *test_group, mem_max_buf[32];
 	long swap_peak, zswpout, min_swap;
-	size_t allocation_size = sysconf(_SC_PAGESIZE) * 512;
+	size_t allocation_size = page_size * 512;
 
 	min_swap = allocation_size / 4;
 	snprintf(mem_max_buf, sizeof(mem_max_buf), "%zu", allocation_size * 3/4);
@@ -243,7 +245,7 @@ static int test_zswapin(const char *root)
 		goto out;
 	}
 
-	if (zswpin < MB(24) / sysconf(_SC_PAGESIZE)) {
+	if (zswpin < MB(24) / page_size) {
 		ksft_print_msg("at least 24MB should be brought back from zswap\n");
 		goto out;
 	}
@@ -270,9 +272,8 @@ static int test_zswapin(const char *root)
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
@@ -287,11 +288,11 @@ static int attempt_writeback(const char *cgroup, void *arg)
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
@@ -302,8 +303,8 @@ static int attempt_writeback(const char *cgroup, void *arg)
 	zswap_usage = cg_read_long(cgroup, "memory.zswap.current");
 
 	/* zswpin */
-	for (int i = 0; i < memsize; i += pagesize) {
-		if (memcmp(&mem[i], buf, pagesize)) {
+	for (int i = 0; i < memsize; i += page_size) {
+		if (memcmp(&mem[i], buf, page_size)) {
 			ksft_print_msg("invalid memory\n");
 			goto out;
 		}
@@ -439,7 +440,7 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 	if (cg_enter_current(control_group))
 		goto out;
 	control_allocation = malloc(control_allocation_size);
-	for (int i = 0; i < control_allocation_size; i += 4095)
+	for (int i = 0; i < control_allocation_size; i += page_size)
 		control_allocation[i] = 'a';
 	if (cg_read_key_long(control_group, "memory.stat", "zswapped") < 1)
 		goto out;
@@ -479,7 +480,7 @@ static int no_kmem_bypass_child(const char *cgroup, void *arg)
 		values->child_allocated = true;
 		return -1;
 	}
-	for (long i = 0; i < values->target_alloc_bytes; i += 4095)
+	for (long i = 0; i < values->target_alloc_bytes; i += page_size)
 		((char *)allocation)[i] = 'a';
 	values->child_allocated = true;
 	pause();
@@ -527,7 +528,7 @@ static int test_no_kmem_bypass(const char *root)
 	min_free_kb_low = sys_info.totalram / 500000;
 	values->target_alloc_bytes = (sys_info.totalram - min_free_kb_high * 1000) +
 		sys_info.totalram * 5 / 100;
-	stored_pages_threshold = sys_info.totalram / 5 / 4096;
+	stored_pages_threshold = sys_info.totalram / 5 / page_size;
 	trigger_allocation_size = sys_info.totalram / 20;
 
 	/* Set up test memcg */
@@ -554,7 +555,7 @@ static int test_no_kmem_bypass(const char *root)
 
 		if (!trigger_allocation)
 			break;
-		for (int i = 0; i < trigger_allocation_size; i += 4095)
+		for (int i = 0; i < trigger_allocation_size; i += page_size)
 			trigger_allocation[i] = 'b';
 		usleep(100000);
 		free(trigger_allocation);
@@ -565,8 +566,8 @@ static int test_no_kmem_bypass(const char *root)
 		/* If memory was pushed to zswap, verify it belongs to memcg */
 		if (stored_pages > stored_pages_threshold) {
 			int zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
-			int delta = stored_pages * 4096 - zswapped;
-			int result_ok = delta < stored_pages * 4096 / 4;
+			int delta = stored_pages * page_size - zswapped;
+			int result_ok = delta < stored_pages * page_size / 4;
 
 			ret = result_ok ? KSFT_PASS : KSFT_FAIL;
 			break;
@@ -616,6 +617,10 @@ int main(int argc, char **argv)
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


