Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A501FED2CA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 04:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CC516B0092; Thu, 12 Mar 2026 00:07:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A3C86B0093; Thu, 12 Mar 2026 00:07:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 582D86B0095; Thu, 12 Mar 2026 00:07:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46E856B0092
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 00:07:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 110341B88A4
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:07:12 +0000 (UTC)
X-FDA: 84536075904.26.063EF1D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1F0D6180008
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:07:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YJiFH1W7;
	spf=pass (imf24.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773288430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LVa2mXy8mi+FQJYiVHbYk7mU9xR/sNQXxGYQvpMvII=;
	b=KuS3fjfSS7TvwdTOr/JNu5gC5S1uhD06aUj6X0gln/+365oo9CknCFS4mJ3mJBmewcDt/Z
	fPvkEKgmQuj447syFYp/s2kuo90TB+/pi4goaqq0MRfOOTLB5K/kQUBUG9Pf0dTHv8w9MZ
	2XvwL2tGCq489GiBW9DPCnf7yExiY/E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YJiFH1W7;
	spf=pass (imf24.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773288430; a=rsa-sha256;
	cv=none;
	b=ubFdcO/rNzP9PoA5HL/k24qYN1dtIapXk6rlt3EhDGcLs/stReZsOKZaxTNfhFCg4ZUVLH
	IQiHoVOzKK18aVDvUh2iSjbSeEWS/4YpRynb7aiGwpaTXYBMi8nWDeBFsUWn1KeaRvuBQW
	9y+ijhfAdUw72KUUz87/EIC9pbH/BvQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773288429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7LVa2mXy8mi+FQJYiVHbYk7mU9xR/sNQXxGYQvpMvII=;
	b=YJiFH1W7Jy2Rx3Rmn2Y8OV3SCMA+zp23j9vHDqA5UBHJUtbs9al1mYudgqB+g+bzx1iHVG
	Y3NEFi0bKtBuw7R47clYGdpVZr1tznlQfcm0oppLK1umpJzGDF6O6NLICtMArXJGhG0+Aa
	uB6qbED8b64YUUtsimgoBQwsb+Yus94=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-N2ucGk-gOIaSE-K57NMJag-1; Thu,
 12 Mar 2026 00:07:05 -0400
X-MC-Unique: N2ucGk-gOIaSE-K57NMJag-1
X-Mimecast-MFC-AGG-ID: N2ucGk-gOIaSE-K57NMJag_1773288423
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2CE4A1956053;
	Thu, 12 Mar 2026 04:07:03 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.57])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E35C19560A6;
	Thu, 12 Mar 2026 04:06:57 +0000 (UTC)
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
Subject: [PATCH v2 5/7] selftest/cgroup: fix zswap test_no_invasive_cgroup_shrink on 64K pagesize system
Date: Thu, 12 Mar 2026 12:06:25 +0800
Message-ID: <20260312040627.55257-5-liwang@redhat.com>
In-Reply-To: <20260312040627.55257-1-liwang@redhat.com>
References: <20260312040627.55257-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: shJk0_1yP6b575vxIxtddyu1iuGfJ_S4Es7JwZmOlNk_1773288423
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1F0D6180008
X-Stat-Signature: b1ihkoh4dimzamj5ygrpzxogq5k3zhd6
X-Rspam-User: 
X-HE-Tag: 1773288429-381805
X-HE-Meta: U2FsdGVkX19E0GcOp71hdb8AKVvpSTVZIW84EHuArj0quAZyB7DtNhlfnEMnZZsZucNor5955iJx5tN9ZWjVutZrypRqT4ZdcOSRdlVtlxu6MmVDN9584rl4YVJusbSPvh+4aGyaj4CEW8MgyT2Nd30H9CpnB7XKrNn2IfZgcBOPwkJQT0IsPrTv7OBjOnbyO/1Kmmrpm4rB7FFiawETTSiuE5YRIO4Z17DIg1qGhQc1L/BoRLIO/H7NP3HubYLlr2VE5zfYAKuj0Nodf2z6R2tV4akpmr7JKcate+FzqQgrmf59bEpolafduGonOOo+zfphkh6Jk8kxSxfM59snS6fv5rTaoENu1XErD5rXjDfPZid/50C/JtYOTTfXb8zvVpxGCkLX5BpYTXMpEwMFZlKRvaR+ERv5HcblUVIs1L//Ic6s28fIOdqTQt0G87v4Gvx7Xggjd2AQ9Vw7HxS7xkfhDau3ytqsCFkkckaFN2JFR2t3hpY2FxrhSkAQP9jxZa6Qu8fb0+OU5RNH5RRdKw1hnBCkyt0fKnW9iQoQg1JqaoIFs00U84njTkU0m2PuFtSAK+bb/fDBUjrfI2fHgfwCuHErS/WbbSLgGcHAXBP7YtTFlsSS1S89U64r4syID7jIgvmTACeTnaQ3ujhOiKv0ktefMNQfcNYqlIEP6Urmt7ZypjCfOvd+iQHCIX/2kXxYcR5ltvTQMWYposJoe+CzftLdJHIdVLFC23tobk1kxPK1r214tE9eyuBYkri9Bd/0ANYSK+ZywHCCFUTriPyDVqIe+LMow3KozjSM8AKurMctazFM1O6uDUfbCkyuoIrL7Vm77sOZdkX+HUdCOh2rYpGGXO86503QWcZPUL/RkrzZr9R9SYf9Y9jtyW0+zwbshp+XuLMxpXOEx36EXim+1jw3JVUrQp6DH7T6xBa0jqH3B2YSBoHjXXSCjbWipobWrG17aP9gpqM5hfM
 3rPuhEO8
 LtMaDsDqS1YKd/opp+aSLG2tNwVUd1riZUiSJv3jfY7fNmd+FdjAhiy20jIIP+OsjJTjfs3BvoQ+u3+VRAcPIt0t7juh+m9cR5WKPHqKknjDNTRFcVpkwHVNesFFzqwL1p2FLiJCxpg6ZHKefGNlJTT1ikvLQP8XWVxDRp1Wav+CFMuhM0EXmFfyZ33sF8C+bPo07spN3HN+ggWpwAdbRWw0BLidoVsduIzMt7VTQWcInCab9+6CzQu2N4mBATdTdk1vTph9svCwWw07HLO2e/icWc5ZtqHdFP2JXWqHG5vZiTO4EpSAwHMTKMI9xnY/UsRuQasZaW+A+B4yIVa2CfO3/42n3zaU8E/NjJeKeiYOD+ccy5k6N0PWaZKdKyVLpKlqe2g4vpNrKL62rf+QxPBkg+YDMCSVYYFvzUbguQZmdcosvyBYTrpP/8j9KIeb2+0jgaMkd/8UwwXDcqwl+4vb6KgNheG5bBxVFLKKmHiSikabyoam3oMUadAS6C7fbPX7XuPBvujo3sfXWVjAEDQCRGX3YEZLUmEKiIpfGKNQC2CFtc7nlYgE1suifnVW/RwvtsyZu/dKsb21+kgDxvTmnUJ4chbtPAYAv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test_no_invasive_cgroup_shrink and allocate_bytes use a hardcoded
stride of 4095 bytes when touching allocated pages. On systems with 64K
page size, this results in writing to the same page multiple times
instead of touching all pages, leading to insufficient memory pressure.

Additionally, the original memory limits and allocation sizes are too
small for 64K page size systems. With only 1M memory.max, there are
very few pages available, and a zswap.max of 10K may not provide enough
room to store even a single compressed page. This can cause OOM kills
or false positives due to insufficient zswap writeback being triggered.

Fix these issues by:
- Using sysconf(_SC_PAGESIZE) instead of the hardcoded 4095 stride in
  both allocate_bytes() and test_no_invasive_cgroup_shrink().
- Increasing memory.max to 32M for both wb_group and control_group to
  ensure enough pages are available regardless of page size.
- Increasing zswap.max from 10K to 64K and allocation sizes from 10M
  to 64M to reliably trigger zswap writeback on all configurations.

=== Error Log ===
  # getconf PAGESIZE
  65536

  # ./test_zswap
  TAP version 13
  ...
  ok 5 test_zswap_writeback_disabled
  ok 6 # SKIP test_no_kmem_bypass
  not ok 7 test_no_invasive_cgroup_shrink

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
 tools/testing/selftests/cgroup/test_zswap.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 032c36658a15..654874fb371b 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -83,12 +83,13 @@ static int allocate_and_read_bytes(const char *cgroup, void *arg)
 
 static int allocate_bytes(const char *cgroup, void *arg)
 {
+	long pagesize = sysconf(_SC_PAGESIZE);
 	size_t size = (size_t)arg;
 	char *mem = (char *)malloc(size);
 
 	if (!mem)
 		return -1;
-	for (int i = 0; i < size; i += 4095)
+	for (int i = 0; i < size; i += pagesize)
 		mem[i] = 'a';
 	free(mem);
 	return 0;
@@ -415,34 +416,41 @@ static int test_zswap_writeback_disabled(const char *root)
 static int test_no_invasive_cgroup_shrink(const char *root)
 {
 	int ret = KSFT_FAIL;
-	size_t control_allocation_size = MB(10);
+	long pagesize = sysconf(_SC_PAGESIZE);
+	size_t control_allocation_size = MB(64);
 	char *control_allocation = NULL, *wb_group = NULL, *control_group = NULL;
 
 	wb_group = setup_test_group_1M(root, "per_memcg_wb_test1");
 	if (!wb_group)
 		return KSFT_FAIL;
-	if (cg_write(wb_group, "memory.zswap.max", "10K"))
+	if (cg_write(wb_group, "memory.zswap.max", "64K"))
+		goto out;
+	if (cg_write(wb_group, "memory.max", "32M"))
 		goto out;
+
 	control_group = setup_test_group_1M(root, "per_memcg_wb_test2");
 	if (!control_group)
 		goto out;
+	if (cg_write(control_group, "memory.max", "32M"))
+		goto out;
 
 	/* Push some test_group2 memory into zswap */
 	if (cg_enter_current(control_group))
 		goto out;
 	control_allocation = malloc(control_allocation_size);
-	for (int i = 0; i < control_allocation_size; i += 4095)
+	for (int i = 0; i < control_allocation_size; i += pagesize)
 		control_allocation[i] = 'a';
 	if (cg_read_key_long(control_group, "memory.stat", "zswapped") < 1)
 		goto out;
 
-	/* Allocate 10x memory.max to push wb_group memory into zswap and trigger wb */
-	if (cg_run(wb_group, allocate_bytes, (void *)MB(10)))
+	/* Allocate 2x memory.max to push wb_group memory into zswap and trigger wb */
+	if (cg_run(wb_group, allocate_bytes, (void *)MB(64)))
 		goto out;
 
 	/* Verify that only zswapped memory from gwb_group has been written back */
 	if (get_cg_wb_count(wb_group) > 0 && get_cg_wb_count(control_group) == 0)
 		ret = KSFT_PASS;
+
 out:
 	cg_enter_current(root);
 	if (control_group) {
-- 
2.53.0


