Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72EA5FEA800
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 03:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D82EE6B0093; Wed, 25 Mar 2026 23:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B5D6B0095; Wed, 25 Mar 2026 23:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97A66B0096; Wed, 25 Mar 2026 23:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B74296B0093
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:27:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C5335C32F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:27:53 +0000 (UTC)
X-FDA: 84586780026.10.6BF7F94
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id A071340005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:27:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QC8pWvKl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774495671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cPJkc7Lk4qI4ZA2OHZYE0osYDu+lYGmpcUChp6ka55s=;
	b=VZsAHU6dJX8W+UDPWJdlaM+h9CRdoCsi/4WhKf3ct4xPTggKrhbbTBEBFGwQuAS1JOvh08
	KeAKi3Apet9dqNUtiNtLv5GPX4/DiZUmHSJyVtenFy+meV9ProwetFVRbN+XeYj6sq+L8V
	BRcvBAfXwunAGlZxnzlKO3/sEYZR5/U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774495671; a=rsa-sha256;
	cv=none;
	b=eTD78XsEWvddiPBVPPlXEF5UBTsiYttAwmsVolvkMDMAGT/gJmclwnPbOsKnBbR7W1dTr6
	ZEXGsAe+Zd38FnyipcCEJ1QDrfhzFQ26uy1Ne9JWclx7CBdGe5VeTpCwQ1t8kSB5de0LQC
	DZZBs/KFWBPyYJBBQb/V8fkl5e6VZyA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QC8pWvKl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774495671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cPJkc7Lk4qI4ZA2OHZYE0osYDu+lYGmpcUChp6ka55s=;
	b=QC8pWvKlC56WZQZM4AwX/pmDpH6smJvXq/tmpCYQWb66lMRRX2t7Ni2W4maWVAjc48voeY
	PbXuc5kOqvC2kNsdWhDaS4U5gB3TFt3EMBE2/Df7SyQao39Iyz12NQdZ6tNPhFqFtzmDPa
	H6GA23NUkSLrLjUp3gL7+ajf9DtN0VU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659--zYwZqH-OqCHBGKG4GzQeg-1; Wed,
 25 Mar 2026 23:27:47 -0400
X-MC-Unique: -zYwZqH-OqCHBGKG4GzQeg-1
X-Mimecast-MFC-AGG-ID: -zYwZqH-OqCHBGKG4GzQeg_1774495665
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E7781800344;
	Thu, 26 Mar 2026 03:27:45 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.83])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A2EA61955D84;
	Thu, 26 Mar 2026 03:27:39 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	mkoutny@suse.com,
	muchun.song@linux.dev,
	tj@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Cc: longman@redhat.com,
	liwang@redhat.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v5 5/8] selftests/cgroup: replace hardcoded page size values in test_zswap
Date: Thu, 26 Mar 2026 11:26:55 +0800
Message-ID: <20260326032658.96819-6-liwang@redhat.com>
In-Reply-To: <20260326032658.96819-1-liwang@redhat.com>
References: <20260326032658.96819-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: dkUFiMUqN3-YjZQYbb-mx6hJbLh7unnZmhOofehFXtQ_1774495665
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A071340005
X-Stat-Signature: qxe1uqk1swxdxe7bpran9uqbuz1znip6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774495671-730160
X-HE-Meta: U2FsdGVkX18Tg9QBklKKgrdkArE9lqSJ3uZAzggzlpcNSryQ7tohOW6aqU+AxaNruDXMJxoYz0aqrKxXcL7HSNid+kcOexAiu9bfy6ybJA5z0KRK6pjLXu2ki+Fzlboko2vpxHgVElVwnPQ0Oovv9vGDCjt8+ol3U3vIQJt6e8gCvLZc5wxibHcMB7/zCl0V8ZsFcVwf2QWXSryAasuJxHMCUq14cqRYavTaVG/vzKCt97SlMFtKustZzxRYmz2RRY9+l85xY2sQWHqcV5E+5aSXygSJiULfc5Qiw0mYdxYirQ7z0VJnzaXMDAsr6LE6LN9xUejuUScUlVcTd+RXcPGmltYAVGtpyAceUA7p15K/9499fnUGhREegyG64JdxQka7E/vi58PEO4Gyyan8x5zFUEUQ5Q4rxs/KRoh5yG7CxiVgkwnfO3SHlvo3wTl24FowpidwkoxfRu00xwS9FAJOJZxBj22Jo8HWArky6g6XJBzvNFkxnyNiFeFSUpiLJooFWMY3KmwQ2+Cvmi8VIGnbp8a59ATakWIvDtkMB5DL2paEdpdlsbUsjOY9DxbCe2y2iNQf4+XSLO7gYUeGCcvJE165+JBUknSROyp+MkYq64Yh4/cC/F7X9/b0ZPM/tNcHqBZzoSGzR6F/kjBn8Ttkr6jD8NoKRJs+U1ipdJq+LWfQqYqA/Xx4EKuO+cozrnuuUQBVyjB//CwVB8IcgL1l5Pdc7H31aXENfrwT8tcej5r02Az3hxvu3QAjBsHG8PlCq6+a3i8Qphz2vL2FL1Wd4SZQvdi28qTuo9+5rhBlDlMtThQCMSeIaXOBSgZcaX5MBtVp5+JbLp4g6Tvvf1khIe9xZvkCaIm5beYWIBz8rP83vHB+xWLRXDfpv9MQEqVZzz0Npjvog5NU1vic0AJn16aljf/2/yFEYp4Q6OuI+IXuLvzs9Ib7KyzRoSkGhud3ueaZqfoVNhrokqy
 zyEl0AYL
 AYfPuaAVSe9FI5yL1R0VvvxyK2Asb7PCbOFwa9rupIXgN7D+ywQjhdmzt/Jq4k9hQupb5r0jDFVA+vbi++q0lemc+QihUnVjUFGN6szrP4uRj16DEhA+55j1HFxSyMEkepiVWfNh+i6IPPVVXd1RghV5v/CnlcyXzLY9pfmVfpIk54yz/6R6DMPcfIZkz3jnkQc0awodV/skqnPucjTFe70eAuzGKdHHnSklUSRDXKoK0sqMgHLrLINeq3I9Vn1Tto+5VsMYg6dZLLTVaR2TRG+gEzrwtsh6+8u2k636mc8QJ8NOztzjquxW+1kaFiNXb6BqFYtATrelIu+otzy9CnKrS2MPCRnTmFYBQwiqQ0+eSoOSMegXJbDOdqn+AR3y+Om+0rnFj2k4WssqjWML0fq2ioxyv9+RXjbNiAtumeEatSXjPUBYg2BqABLU3sFXbZqNnDWMzeYo8Bf4jNKfonSSTrPcFfvzWKsSmXbzagsbQ+Dwb0MEuY707pQdLwMnhy7oxzxjZVL0zx0XV4UZNubQvVs64qT4FSqRVI3RF3IKcr5jS7BvyK6v8/f8Cz6eiXJcQdGe5O8ihzXg=
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
    v5:
    	- Change pagesize by the global page_size.
    v1-4:
    	- No changes.

 tools/testing/selftests/cgroup/test_zswap.c | 39 ++++++++++++---------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 516da5d52bfd..fc7a9aa27e27 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -13,6 +13,8 @@
 #include "kselftest.h"
 #include "cgroup_util.h"
 
+static size_t page_size;
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


