Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7A14106FD79
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 04:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33C8B6B008C; Fri, 13 Mar 2026 00:36:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3283A6B0092; Fri, 13 Mar 2026 00:36:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22A956B0095; Fri, 13 Mar 2026 00:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1134B6B008C
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:36:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B41E013B9CD
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:36:17 +0000 (UTC)
X-FDA: 84539777994.25.B548725
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id C0DD8C000F
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:36:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OlRvBqjj;
	spf=pass (imf10.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773376575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AgscDGb8pb9Gegot485nSUiYl/sLdOaPVgxH0ipJXH4=;
	b=oAKbNQQIdrUOLWiE5dSVDnvQ1otNJQ+yPiuQL9kwliPzsGrBdzORPM6EhXyy960+sSJg3w
	Qnze7u9UdfyRqHFDHmY+OFZA+AWUkQQrQD+CGO3WfLH2kEKCH++HIbN9qnVRrA54IuYdZf
	ATLcJUzYivR6l+6CbQNbvhndv1fZjmM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OlRvBqjj;
	spf=pass (imf10.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773376575; a=rsa-sha256;
	cv=none;
	b=BpmRH2pLX++uLbKlHQnW5aJnDrwJ6aLGsvicbYQtGNPbaKZcpzKysAbQ9vOT5KqW7W9Er+
	AFI2ENDG2MbxkXDcffDg5hoOBDVBY5DRwGNUNsYcXdrdDnY3MX86Hc5MAQTnCXNwetdeHI
	X+86JkGKJNKQSn8DXdSX20DKTIkBsGw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773376575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AgscDGb8pb9Gegot485nSUiYl/sLdOaPVgxH0ipJXH4=;
	b=OlRvBqjjeQFo8WE4sLAzPOODg77wQTshHfBup5H34TL9++N6umOkxSG3XhoS5DETsAhetu
	WaRutW8YL7G3+N+OLser9hewycH/Z69YyuFaIio5zhqxThHy9bC2+jiTwSzAuGNVlyAdGe
	etDVtMnCorkixPIfd9ODfMB7mwzlAn0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-671-GHm8LYEsONOwyAalF4RPoQ-1; Fri,
 13 Mar 2026 00:36:11 -0400
X-MC-Unique: GHm8LYEsONOwyAalF4RPoQ-1
X-Mimecast-MFC-AGG-ID: GHm8LYEsONOwyAalF4RPoQ_1773376569
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C19F18005BD;
	Fri, 13 Mar 2026 04:36:09 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ADF2319540C2;
	Fri, 13 Mar 2026 04:36:03 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: yosryahmed@google.com,
	nphamcs@gmail.com
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH v3 5/7] selftests/cgroup: replace hardcoded page size values in test_zswap
Date: Fri, 13 Mar 2026 12:35:30 +0800
Message-ID: <20260313043532.103987-5-liwang@redhat.com>
In-Reply-To: <20260313043532.103987-1-liwang@redhat.com>
References: <20260313043532.103987-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: 7P2e06OWMHexRD_wBPtpZSc1-IoxswaEFs_TLK7cD9Y_1773376569
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C0DD8C000F
X-Stat-Signature: j66sdo7j1y17rs9q586xdejodq47op5h
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773376575-493496
X-HE-Meta: U2FsdGVkX19ILY01GsjGLsaKtJRMeKsBhiNxI+rLMTBG6zMBUvDRNp8vKGWUnAURDLp+0VJUmgZhvnYPjsyTWlKlgZYnf+W0tCv1R8emDkH2hKfATYcthP9JQ+cYNo9L/Tx4fANAAhEtA9YOhudTIL+2tnZGiBlYeq/ezFMnLLXWTRD9o8roRYIbzZJSkGymcANYDdUqvASJXoHZ4KL9Iet3RyoTD56R3VMHgywnD5z39h2ub5gLyKAo+DQA6HiyJ3RLlvLFqYI8hLeutVRk95ZGCQTJU0f8h5eNxQC6sLcD35sVhH3iUHZp699BqqKiPb+zUHm1LQPU2adGlQAUtJg1oJK0XokYmFM6rVoRH4nYTcx3bDNtaCLhdQ8H4IcQhfbm0EEO8c3Fw3CsFM+F1cgtFbb6LmDohnKtd/unynX5kB2BSKQpggOkp2X8ySSPzjHuybGdqzT3YDo0dgCo81BHHbNnUAH2ExCNL4YvdYKsK/hHHj1Dzop/kWNgasvcj/SNepPGQiqVbuSd4wp1vfIqnXOQVwAWfV3CFCMKKkhgBBbaS7yZ7HRFH1FasdOhncLlW+BXwlfXM+i56FWY9x58aJWQ0+qKb+X+Lk2ZvJPe1CnFihQHQniYk3sFNMtEBDoq/qqg5G4jGtYEQm/VeJcEC3/iW87wLHfRHXbVqxTT1ipVp12gyYXPM61O1fVR1Tu4QDvxrexp0C3JkI872oRScggyvsR+DyAUJym0M5lzYoYnwfdGKltvzZesEkz3XDueuql4eT18boJT0bclkvPBpGrzOErKm923PL0HZuAJXuVV0GJNOXkELP058f7Q9y2Zwat6AoOKH4ZTVFDhfyKSj1Q63ks6z0nWVePmzxKR3z1UaaB4ho3klv7DftfFosvnEZtIDmyp8BmxoJdUcbCEgm2uwjwKM8cIBCs1Su8cfR6iW0jnNesWG9H/x3OSTdqKqPeCrXAYjyA1EvX
 zHFhY9Ao
 oW7kCUoV0fGq0Op8VE5NBKz5BsgR/AWso+5WIwWo4lPES64Pw7OACdELP9qITBufV5+MYHQSMssVL9c5aenz0hTTjEyoz+NpH7al4tVGqfMhnBMb1iuLh/rXPbRj+TDd40PQ/Ugpa4qzFuHqz7CFwrNNK4aRAYfwvWhSp1IpN3dekYiquoTk2KR+tBJ8u9D7KInYk1y6RuS0WCzUuHFcqZmIpaq7M/iu176XfppvCMnaTW7TtlbRsFjz1uw02Er26zZc5V2QKXtoufuzaVhiHal2TcKg0aqqtDcBp3k7qQ8m09w/3Z5I/k0+Wxi+obablb1Qvua9w++Gw473BG9Emqt+G8rz+xfka2XwsCS69cVO5NFb+biJ+khadds1kMYH0SlCEIZqKU+zqW9Yia+SXtRbiJzgqzsvWNsOG/VmJdimuxeKQR7zQcNypntlEY3nC1aNBIu3r7JNHsxBg1aqld7IPA/rDezFWiPDd/myy8c8/LmBDY7anL5n9PtnWBVdYLcilpAKwguVpqnUUAMAp0STySywDY73VuzmCIxMSEJ3L1mpZ8vERKDVtSyHB9rQ3Z7t+XTqF06EAv1EArIx64pNdcs9w/j1j3fa/
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
 tools/testing/selftests/cgroup/test_zswap.c | 22 +++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 74b57331cbf1..cf5b1531c827 100644
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
@@ -88,7 +90,7 @@ static int allocate_bytes(const char *cgroup, void *arg)
 
 	if (!mem)
 		return -1;
-	for (int i = 0; i < size; i += 4095)
+	for (int i = 0; i < size; i += pagesize)
 		mem[i] = 'a';
 	free(mem);
 	return 0;
@@ -267,7 +269,6 @@ static int test_zswapin(const char *root)
  */
 static int attempt_writeback(const char *cgroup, void *arg)
 {
-	long pagesize = sysconf(_SC_PAGESIZE);
 	size_t memsize = MB(4);
 	char buf[pagesize];
 	long zswap_usage;
@@ -436,7 +437,7 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 	if (cg_enter_current(control_group))
 		goto out;
 	control_allocation = malloc(control_allocation_size);
-	for (int i = 0; i < control_allocation_size; i += 4095)
+	for (int i = 0; i < control_allocation_size; i += pagesize)
 		control_allocation[i] = 'a';
 	if (cg_read_key_long(control_group, "memory.stat", "zswapped") < 1)
 		goto out;
@@ -476,7 +477,7 @@ static int no_kmem_bypass_child(const char *cgroup, void *arg)
 		values->child_allocated = true;
 		return -1;
 	}
-	for (long i = 0; i < values->target_alloc_bytes; i += 4095)
+	for (long i = 0; i < values->target_alloc_bytes; i += pagesize)
 		((char *)allocation)[i] = 'a';
 	values->child_allocated = true;
 	pause();
@@ -524,7 +525,7 @@ static int test_no_kmem_bypass(const char *root)
 	min_free_kb_low = sys_info.totalram / 500000;
 	values->target_alloc_bytes = (sys_info.totalram - min_free_kb_high * 1000) +
 		sys_info.totalram * 5 / 100;
-	stored_pages_threshold = sys_info.totalram / 5 / 4096;
+	stored_pages_threshold = sys_info.totalram / 5 / pagesize;
 	trigger_allocation_size = sys_info.totalram / 20;
 
 	/* Set up test memcg */
@@ -551,7 +552,7 @@ static int test_no_kmem_bypass(const char *root)
 
 		if (!trigger_allocation)
 			break;
-		for (int i = 0; i < trigger_allocation_size; i += 4095)
+		for (int i = 0; i < trigger_allocation_size; i += pagesize)
 			trigger_allocation[i] = 'b';
 		usleep(100000);
 		free(trigger_allocation);
@@ -562,8 +563,8 @@ static int test_no_kmem_bypass(const char *root)
 		/* If memory was pushed to zswap, verify it belongs to memcg */
 		if (stored_pages > stored_pages_threshold) {
 			int zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
-			int delta = stored_pages * 4096 - zswapped;
-			int result_ok = delta < stored_pages * 4096 / 4;
+			int delta = stored_pages * pagesize - zswapped;
+			int result_ok = delta < stored_pages * pagesize / 4;
 
 			ret = result_ok ? KSFT_PASS : KSFT_FAIL;
 			break;
@@ -616,6 +617,7 @@ int main(int argc, char **argv)
 	char root[PATH_MAX];
 	int i;
 
+	pagesize = sysconf(_SC_PAGESIZE);
 	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
-- 
2.53.0


