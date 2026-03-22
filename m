Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6064BFC72AA
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 06:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6F8C6B00A1; Sun, 22 Mar 2026 02:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47306B00A2; Sun, 22 Mar 2026 02:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5D3A6B00A3; Sun, 22 Mar 2026 02:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5F796B00A1
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 02:11:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C36C1B88BB
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:11:33 +0000 (UTC)
X-FDA: 84572677266.05.2C48FB0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9215BC0004
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:11:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CdL8eXnI;
	spf=pass (imf10.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774159891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dCjpbk9shfMvsTLeYWdQuK6o2QNz7TDr6M6Z2XEj8E=;
	b=cleuhLGUpgKQu9oc6gToNC0j+xbspdpxF5nMxWi7xOmIESie45Dm4hllif6+suNaU5pS1Q
	GDAUfSPTysl7Uq8rMdtBtHgsoSlOKjExcrJfhPeNSPu7vNPmkc2zO8R4MMRr3Kb3tW3826
	RhX2bRZacqhDoqc6SFDFvHecPtBZJwY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CdL8eXnI;
	spf=pass (imf10.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774159891; a=rsa-sha256;
	cv=none;
	b=uuabUnSzp7M4S+aVTTarKdSAf/bKi18BIfd8pqSmYrzSSGcl3MUxaWIHeSde7l+7QfmX9r
	yvF4bFp2w99M1D43ooEXdbV/yATfZic/eXu/uWIc4NXNM+jS1Gf0jHuh5+gGJEHND4ZlrK
	S7Qa1HFWtUM6n64Xb3aR9r2jkSTKNwo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774159890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7dCjpbk9shfMvsTLeYWdQuK6o2QNz7TDr6M6Z2XEj8E=;
	b=CdL8eXnILqfJUag1AqNB5y+SupL5LG4NisajGhxAkxFqyBnLP2rkwC8m0Z/4NHyRpvUQzn
	ygELwyhPc8//zIskBYl7rvDBAoEj0ENCr14B7fwiXF+QHfmTsvzkD4pWXjmGRHxY0sfPlp
	4GYvshHMKmUROtmqoLBEu3SQuCVEXFk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-507-U2Bm-i80O8m2tIqlio_K8Q-1; Sun,
 22 Mar 2026 02:11:28 -0400
X-MC-Unique: U2Bm-i80O8m2tIqlio_K8Q-1
X-Mimecast-MFC-AGG-ID: U2Bm-i80O8m2tIqlio_K8Q_1774159886
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7694E1800345;
	Sun, 22 Mar 2026 06:11:26 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.34])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B19C1955F21;
	Sun, 22 Mar 2026 06:11:19 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	yosry@kernel.org,
	yosryahmed@google.com,
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
Subject: [PATCH v4 5/7] selftests/cgroup: replace hardcoded page size values in test_zswap
Date: Sun, 22 Mar 2026 14:10:36 +0800
Message-ID: <20260322061038.156146-6-liwang@redhat.com>
In-Reply-To: <20260322061038.156146-1-liwang@redhat.com>
References: <20260322061038.156146-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 9gudENTiTmBbw42ugsdxp4fya1RdWwEi5IGfbBNfQss_1774159886
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9215BC0004
X-Stat-Signature: oawu3cn8nkndeqdausbe1of8indeszf9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774159891-981271
X-HE-Meta: U2FsdGVkX1/ItFK6BOPXK+9XWpNai+fxh7/nrq0apSg57g6tYJTSOmbEPwHjhfTSdMBul9izpEXEHs606wKkTkUpBo/lP3L51F9TvbES7SgwB7JJecY83YqruQy1WqXSIkPb0LhUyEoHZdbV6PbM+6BQ9eSoYg6RiDvN6gviVSd/ytqA2b/OPJ9rppC/f6dqvKElbY/osBrxkoc0w94VFSoNVgmJ8qD5xhbc/dzUivOGl2VGTp9pYMHp81atHQ9jyL9YGkfvO54pfY6SnC3NliZO2ZBZjxOA3swmKOot5LsoK8aVkRRKb/TUbx4r7WIgYfpfiDM7Pcr+7JzpNc3rxvt+oZkkKfUrDMWrts0minOH2Gn9oDGeUafWqKdseHosuyuxa5HxXnc+tR+JQzyr9WFTFXfzLa003ACmiX4x69wkpvbeLgDkeL6w1kpXqSHgr6YBqA9Be2gmBJ+3sZiONohHgbeDnf7ROMT57lz51aG4V/cueA9DeHG/eJ2AvgvBtKfEmIvSyJU0jHvlousy3SOXS4MJGquvoirVMvbX+1yntxELYQLFPaY1lRDqG9kS3qKlQelJ7MEDyhxMMKLnrneCaE0x2xTif/cyZLc1pHoaFtHfJfOPitzFa7jY/VEBZBCSciudJ7dD/Gn2+gDBC4BfNXz0MhPvyWCIcF50y2lJ5DuFAHJ+/4J0BvOr2vXE+HdPMSXw3zhR0Fl0Y7pLVxMtE1XTJZmVq2YXVyUv2cHh9od+Vf1nsEBTn5+cpn4kfXXYk3VMXdpkeV2PExNwsz57C9LluRq6rHR/JAgstrbLdv9Q5TR40F64TcUYOjeNq/pqBEUwgoGJXMW2YRV4QCbHQg0Jv+qGtnkWtb72yyk+5KnZHjOA1cZIQ43W76oqUjgFOt9860QU3pWmKJJOYI/o/6iIME3Cm8VM0HY5VXKve0PbApeW6tQdM5GGu9zcMdJBwI1cmvFIs4xFYpA
 l0WnH1Ci
 dARxIUkDysCwlnrKzhBMYGBWKbdJqYiUrA2L9YwWLnxxR2TbBB5YsFKnojyOlIPWXcjbZmmoXCOd9c+aWHB8JeQWJ2bjKiaAezqhjvJLbDx9EvFAY2esNh06FrQAES6SMfdcyu0Y6DtuUpHrXUfl0pclfXopl17R3jVtP3Ony7C+BBWL8jJESq+VZIVIzTOq/vkCIXkEQXGXk0NytL+grkLiAKItdVFkoztOxYOknAVI8ydaxr9M6eLzR1YdRnGH7IsLwlceubSiL6RKwuURQe1yEY+cLi/H/DwJRvkGC16ukJyi1/CEBFKzhoT5w6QhBV5Pgzw1zCkbgOHLbN0Yx2VjjJsph4JngoClqHeWwGcXvCDbuuApuCYp+8p4CO5wQ8bS+AKefJ/QQVc2IW4qLpw0gy/dhDVc689ESCE9X/SBQQtC+ljqPkXyd3fBKBF38J21equDstITNirR/AXgDxRvuOQHu0yV/Co3vyNyAkCD2n8bS3pnsDGU2xYhTu4Y7fe+sx7w2lb9fYrL9tbGPXJERd+r4Ixxqv18GRV2frf2GomzZWY/TXWcJHQZA3eRP0i0WSz/3O+55xbws8dpE5iev4ovFGAHRimHT
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
index 4982e8c4759c..407cfb6ae34d 100644
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


