Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC1F2606A324
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ebl8P1Hp
Received: by kanga.kvack.org (Postfix)
	id 11E986B05D2; Wed, 11 Nov 2026 18:23:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F68A6B05D3; Wed, 11 Nov 2026 18:23:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00EEB6B05D4; Wed, 11 Nov 2026 18:23:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE2A36B05D2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:23:19 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6124B1C3AAE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:23:19 +0000 (UTC)
X-FDA: 85424416518.02.C0611A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3EAD2140003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:23:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ebl8P1Hp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf26.hostedemail.com: domain of devnull+ts.perfloop.ai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ts.perfloop.ai@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439397;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zE4AdyJ1+yT1NztSJ3PyUf+wR+cmqR5P4rzXtjdrpsY=;
	b=HefkPNX4IsGCd/iakvZJE+jVKo13EvyMeNNHbVy4v+xRx0qS1jDKj8t2IVa74nKABITPEe
	1Iz9cn4UXypVHHP2ewFxQ04/amkzdL43hlOE8vb8prSzG4jPJJ1fXmI10d+/ZmO0zWRr1K
	n7+KaVU9IxvmgIRCPpoE0eBndIkKOiU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ebl8P1Hp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf26.hostedemail.com: domain of devnull+ts.perfloop.ai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ts.perfloop.ai@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794439397;
	b=korG35g3lqNXNETlW2TpUKDDruUTcPxFK52rspyku+dF4OfFJzKvQgYx6mh7U0D/3dNbZZ
	cdVyvQ4X8JDq2J4e5e1FRgQ+AaE1vSUry7Z9z+huxp7qPZIZb9EbvR6viAM1Zk9af4Jwp7
	kdFPuLBkhuVTJCjL19tCdC7qjxtrr+8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 718DC6372A;
	Wed, 11 Nov 2026 23:23:16 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794439396;
	b=dG16uP+DVgoc0xh7+xxhbKc3Ep79FfAmAvu2dUiqgFqwKcz/TLlHndqsJsmX3JlsmpPn
	 edBfox1udBD0OUSWNHQFJWq4V41W4VwW7bVBBK4l6vt3YOv5FhgaIXdeF7JLBEnxalW4Y
	 9JDlhnvIzFxoMzUPtfNrslFKB0dC1ZVtu4ynp8zkHSldyIS8n9fB/goW5GGeCy60MVEk5
	 amzx+N1p5T95TkcKqGdnb943gV35d9oN3R6uDKW1xXixDcTzdKdOorhrI/iZk2lyzoOpL
	 ll5o/wajTKr0bWITQwKZxtZexjghdd7MP3NAVR0DkmJCoLkRaZxJP/Okp8mKDAp2oXg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794439396;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=zE4AdyJ1+yT1NztSJ3PyUf+wR+cmqR5P4rzXtjdrpsY=;
	b=tNmyOQjbq5tPqV48IZxZgVKNUKO5QhIcogu1omu+Lsq/11FeMgcDa+FXoTjI1uMI1Egq
	 VAwqXoF+/JlTbR+ot1ye32Ak+OZZk6LulDCL6FhvC9lKto9LGNkMv+c9if7oiEXFh45nT
	 VBnd8Fubm98mQNmXsI8Njqx7bfVj0hg/CmLrrPjpSivCkpsxJd+1sfO0yBJ7PcNSmY8WN
	 jWAOS4nz+NKXzjmJOznaDNZ9Uv2H4BhNZ4Jf7RRlrcKRDdE+2yyXScHrDXTIA88q+jdth
	 tMMMf7lDdJA0H85yB+dBKkUcRYOoc/sgJWVYk9rwoAKzJOJBO97M9iNQ3qGO7DSCdtQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 762B11F00A05;
	Wed, 11 Nov 2026 23:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794439396;
	bh=zE4AdyJ1+yT1NztSJ3PyUf+wR+cmqR5P4rzXtjdrpsY=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=ebl8P1HpraNn40FLfpgT+Lj69xbIQoBguHHHiLjbxho7unXpae2j8h3WXfDTgI3sS
	 PVUEXi6ry2rXoXLhh8dDIzVePPf8Lt0qctxxJ/Ll1Bpy279g+walCsirXdwS6WGNug
	 /C+flCM3iN3pvE98LwRglpwPxKbcqwZgSfE5q2JQ83KUpvdJ3Kmzp/2gaht2VRdmxZ
	 +q11UVj7f2auiAnIWYlNaWgzx0T/IkutIoa3Pbd/Y1AyD+YKtnAi6SQ9Bf9v3Wsl4z
	 l3DEWBYinJ/1ZRBJAVJbvlWnBqJYxg5SKbCVBc5bjEFWN+rbbgP9aU+83izumQJzHr
	 +h5uUnWXYt1xA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C04C44916C;
	Wed, 11 Nov 2026 23:23:14 +0000 (UTC)
From: =?utf-8?q?Tom=C3=A1s_Senart_via_B4_Relay?= <devnull+ts.perfloop.ai@kernel.org>
Date: Thu, 12 Nov 2026 00:23:13 +0100
Subject: [PATCH] mm: zswap: honor zero cgroup limits after successful
 reclaim
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261112-zswap-zero-limit-v1-1-19f33081b09e@perfloop.ai>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/yWMwQ6CMBBEf4Xs2U0A00b9FeOhLYuswUJ2AQmEf
 7fVub3JzNtBSZgUbsUOQgsrDzFBdSogdC4+CblJDHVZ2yoFN/24ETeSAXt+84TOmEt7vtrSNgb
 SbRRqef0p748/6+xfFKbsyQvvlNCLi6HLVc9xXjGXcBxfTwK4rJEAAAA=
X-Change-ID: 20261111-zswap-zero-limit-a558f39606d5
To: akpm@linux-foundation.org, yosry@kernel.org, hannes@cmpxchg.org, 
 nphamcs@gmail.com
Cc: roman.gushchin@linux.dev, tj@kernel.org, chengming.zhou@linux.dev, 
 mkoutny@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 mhocko@kernel.org, shakeel.butt@linux.dev, muchun.song@linux.dev, 
 cerasuolodomenico@gmail.com, linux-kselftest@vger.kernel.org, 
 shuah@kernel.org, cgroups@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794439392; l=8065;
 i=ts@perfloop.ai; s=linux-zswap-send; h=from:subject:message-id;
 bh=hFoFA37/xPMSR9gx/RxcnOaVQHs9U2AHzWcDrxEi6Ls=;
 b=KH9964zzP1eOc4pd4uA+hh/AtHL3SDkaaIbkZR1HDNd7DnO/Opx+CWiMuhnE9oRrNEze3lj5z
 3pw2bW4hYupBF1Ql+ufpYl/jifbVbje1YooETPBo6snUJ/2u43gd4+F
X-Developer-Key: i=ts@perfloop.ai; a=ed25519;
 pk=b+DBayzsW8pO9vRMlsrjlegfP4eogiqFEXM4mEKusH8=
X-Endpoint-Received: by B4 Relay for ts@perfloop.ai/linux-zswap-send with
 auth_id=1492
X-Original-From: =?utf-8?q?Tom=C3=A1s_Senart?= <ts@perfloop.ai>
Reply-To: ts@perfloop.ai
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3EAD2140003
X-Stat-Signature: 6uy6wircua5fikf3rfcx8hwiddndwy3a
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794439397-960474
X-HE-Meta: U2FsdGVkX1+iSHLbjhgUGBoVKOA97MFpZxyQFIckPHsclyKeuyfyhQ6od8diBd0l7C9f3GrF4/kAm493ZWR7dtCUjTFp7s+67y0a+66ujo5Za3foA2Nw04yDux5Gnz4eE/rAd8Y/eU1/6W8roIJdHqtorbmo6sLXLGK3A/MgX9j6Vd4oS3o9ztM/xv2V3Sm2j/aNXx+Sz6pBjZXzpIqgI+w+Lo5j5f+G+xOckW8DQ7GBZqlOqGdirMvSPNweN49NHaNU81jWX4ibTiA6bNIrexcoG0KLPsAFxcjs6BwdHcnuHM3dZSfpX6FrXPC5+nhI0qVEs5qK6/Q2X1bgzkq1jtRJDRJPVTBKGR3oP20Oq3IbgmrEYO5nFJIkLvk+5fmop5BStlOYhQWJTDXg+t6hn/+CDNRV6N92qJm1+uH3F9aQuQPkbaKES0FaAjEs16zA2VYLwFzZCTTsvYpWI3tddHbyrq+C3NDaX1JomXUclMaGjqQ6khpvyU2cmaFabgeCzk2qXURScpANhagkq3neb4Xl6U2U5929Noa0osWVLN08PkFk0SRuFuHlVqMTJ8UFzvl75g2b4SHAO4EaYymV6xtsSL8X2fGN6Qy+SwfcFHc+OKpIvKYKoYFihATcXb16IPlPIEmMrW2C5C+bsLsii0cx1HQhC1V2kxL9iSBLCiR7amtrk+l/eYF2YDjWExUmlCfT9mza/lsrWFMhmmOGpxptoXsW0YXpUy5k5wTZDF02EkpU7l/K1QXXehgovSS8FLOSWP1i9Ri41SwxyKCUx+/YEcDBTbwUgNbrSsu6uuOdLwCXQE+7nbd1/9bgU/95mvnMyd995ijCKub4azR0elEICBB9dDlOKcikxFMMaU4u4U9ho9cvVbth0IYgHAWWgZY3jLvbsNIeJU+k3JTDfUHjCkivyWQH2fReChCEMm3VtolGejAqkTHR5NciCmrtle+VIfW7L4+7fLMIkvI
 VDZhmZC+
 oX9PXd4qewMuwUxVe5pHSVNb7089bpA51oxQ/ijKsjP4T8dcOHHCiNMXYFZJrZxrZOjpe9YMLLIO6zCH+Ch202qwQERzihUaIRO0+ceqE3ckr381KTpSPV7Kvodw2rnVbR8BPglVz2B4AQbvecwia0/xpCD99B1jD+b1bEUhJtDnaERbO5XzHp2I48gMkagZdZmZhyxLQ9HKOvLz0qz4yC2ENt1i7idB/3mm7PHRVC5rUsVo9XoHTFKATecC4jQcobj3TO7BuBQlh5YvGFtZK7MjZrOeaFv6wzGAAf5IT6OdpQTfNyM1eNPYSn6438KSrnmeCa6oOEyly2DHi+NAVsudK2wfZu4V+6fFbgJ255z0Xi+aM/+dNKeLXFzE3qxX98nmcXtuteYnic7WaB4PfR1jCDVUstRT+Y0YskUevsSYukhoBucT79jRET4k34b9GrU9mFHo75lRyyjGKNnWOrjQKPXDmkfNIRYuTJx/otkyywI0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Tomás Senart <ts@perfloop.ai>

Commit a65b0e7607cc ("zswap: make shrinking memcg-aware") lets a store
proceed after a successful cgroup reclaim. That also lets a cgroup
whose memory.zswap.max was lowered to zero replace an old entry with a
newly compressed page, although zswap is disabled for that hierarchy.

Check for a zero limit again after a successful reclaim, before
compression. Use a zero-only hierarchy check rather than repeating
obj_cgroup_may_zswap(): a nonzero limit must still allow replacing cold
entries even when one reclaim batch leaves usage above the limit. Keep
the existing reference release and stale-entry invalidation paths.

Add a regression test to the cgroup zswap selftests. It seeds an old
entry, lowers either the leaf or the ancestor limit to zero, and pages
out fresh memfd pages. It counts written-back entries as well as
retained ones and verifies the data on readback. The test fails without
this change and passes with it, and the other test_zswap tests still
pass.

Limit updates that race with a store remain non-atomic. This change
does not make nonzero limits exact.

The problem was found, and the fix, the test and this changelog were
drafted, by Perfloop, an AI coding agent.

Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
Assisted-by: Perfloop Agent <agent@perfloop.ai>
Signed-off-by: Tomás Senart <ts@perfloop.ai>
---
Tested with the cgroup zswap selftests (tools/testing/selftests/cgroup/
test_zswap) in QEMU with TCG only, not on hardware. The patch also
applies cleanly to mm-new.
---
 include/linux/memcontrol.h                  |   5 ++
 mm/memcontrol.c                             |  17 +++++
 mm/zswap.c                                  |   2 +-
 tools/testing/selftests/cgroup/test_zswap.c | 101 ++++++++++++++++++++++++++++
 4 files changed, 124 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69e1bcc67..948bc5b1b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1944,11 +1944,16 @@ static inline void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
+bool mem_cgroup_zswap_disabled(struct mem_cgroup *memcg);
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
 void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
 bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg);
 #else
+static inline bool mem_cgroup_zswap_disabled(struct mem_cgroup *memcg)
+{
+	return false;
+}
 static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
 {
 	return true;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4..448955327 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6267,6 +6267,23 @@ static struct cftype swap_files[] = {
 };
 
 #ifdef CONFIG_ZSWAP
+/**
+ * mem_cgroup_zswap_disabled - check if a zero limit disables zswap
+ * @memcg: the memory cgroup
+ *
+ * Unlike obj_cgroup_may_zswap(), this ignores nonzero limits so that reclaim
+ * can replace cold entries even if usage is still above a nonzero limit.
+ */
+bool mem_cgroup_zswap_disabled(struct mem_cgroup *memcg)
+{
+	for (; !mem_cgroup_is_root(memcg);
+	     memcg = parent_mem_cgroup(memcg))
+		if (!READ_ONCE(memcg->zswap_max))
+			return true;
+
+	return false;
+}
+
 /**
  * obj_cgroup_may_zswap - check if this cgroup can zswap
  * @objcg: the object cgroup
diff --git a/mm/zswap.c b/mm/zswap.c
index ae19e301f..60a725680 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1542,7 +1542,7 @@ bool zswap_store(struct folio *folio)
 	objcg = get_obj_cgroup_from_folio(folio);
 	if (objcg && !obj_cgroup_may_zswap(objcg)) {
 		memcg = get_mem_cgroup_from_objcg(objcg);
-		if (shrink_memcg(memcg)) {
+		if (shrink_memcg(memcg) || mem_cgroup_zswap_disabled(memcg)) {
 			mem_cgroup_put(memcg);
 			goto put_objcg;
 		}
diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index d50acc1b8..7632aadd8 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -22,6 +22,7 @@ static int page_size;
 #define PATH_ZSWAP_ENABLED "/sys/module/zswap/parameters/enabled"
 #define PATH_ZSWAP_SHRINKER_ENABLED "/sys/module/zswap/parameters/shrinker_enabled"
 #define PATH_ZSWAP_STORED_PAGES "/sys/kernel/debug/zswap/stored_pages"
+#define PATH_ZSWAP_WRITTEN_BACK_PAGES "/sys/kernel/debug/zswap/written_back_pages"
 
 static int read_int(const char *path, size_t *value)
 {
@@ -244,6 +245,105 @@ static int test_swapin_nozswap(const char *root)
 	return ret;
 }
 
+/* Lowering the limit must also stop stores when old entries can be reclaimed. */
+static int pageout_zero_limit(const char *cgroup, void *arg)
+{
+	const char *limit_group = arg;
+	size_t stored_before, stored_after, wb_before, wb_after;
+	size_t size = 3 * page_size;
+	int fd, ret = -1;
+	char *mem;
+
+	fd = memfd_create("zswap_max_zero", 0);
+	if (fd < 0)
+		return -1;
+	if (ftruncate(fd, size))
+		goto out_close;
+	mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	if (mem == MAP_FAILED)
+		goto out_close;
+	for (int i = 0; i < size; i++)
+		mem[i] = 'a' + i / page_size;
+
+	if (get_zswap_stored_pages(&stored_before))
+		goto out;
+	if (madvise(mem, page_size, MADV_PAGEOUT))
+		goto out;
+	if (get_zswap_stored_pages(&stored_after))
+		goto out;
+	if (stored_after != stored_before + 1) {
+		ksft_print_msg("Failed to seed an old zswap entry\n");
+		goto out;
+	}
+	stored_before = stored_after;
+	if (read_int(PATH_ZSWAP_WRITTEN_BACK_PAGES, &wb_before))
+		goto out;
+	if (cg_write(limit_group, "memory.zswap.max", "0"))
+		goto out;
+
+	/* The first attempt can give the old entry a second chance. */
+	for (int i = 1; i < 3; i++)
+		if (madvise(mem + i * page_size, page_size, MADV_PAGEOUT))
+			goto out;
+
+	if (get_zswap_stored_pages(&stored_after))
+		goto out;
+	if (read_int(PATH_ZSWAP_WRITTEN_BACK_PAGES, &wb_after))
+		goto out;
+	/* Writing back old entries must not hide newly admitted entries. */
+	if (stored_after + wb_after != stored_before + wb_before) {
+		ksft_print_msg("New zswap entry after setting memory.zswap.max to zero\n");
+		goto out;
+	}
+	for (int i = 0; i < size; i++) {
+		if (mem[i] != 'a' + i / page_size) {
+			ksft_print_msg("Invalid data after zero-limit pageout\n");
+			goto out;
+		}
+	}
+	ret = 0;
+out:
+	munmap(mem, size);
+out_close:
+	close(fd);
+	return ret;
+}
+
+static int test_zswap_max_zero(const char *root)
+{
+	char *group = NULL, *child = NULL;
+	int ret = KSFT_FAIL;
+
+	if (access(PATH_ZSWAP_STORED_PAGES, R_OK) ||
+	    access(PATH_ZSWAP_WRITTEN_BACK_PAGES, R_OK))
+		return KSFT_SKIP;
+	if (cg_read_strcmp(root, "memory.zswap.writeback", "1"))
+		return KSFT_SKIP;
+
+	group = cg_name(root, "zswap_max_zero_test");
+	if (!group || cg_create(group))
+		goto out;
+	if (cg_run(group, pageout_zero_limit, group))
+		goto out;
+
+	if (cg_write(group, "memory.zswap.max", "max"))
+		goto out;
+	if (cg_write(group, "cgroup.subtree_control", "+memory"))
+		goto out;
+	child = cg_name(group, "child");
+	if (!child || cg_create(child))
+		goto out;
+	if (cg_run(child, pageout_zero_limit, group))
+		goto out;
+	ret = KSFT_PASS;
+out:
+	cg_destroy(child);
+	free(child);
+	cg_destroy(group);
+	free(group);
+	return ret;
+}
+
 /* Simple test to verify the (z)swapin code paths */
 static int test_zswapin(const char *root)
 {
@@ -824,6 +924,7 @@ struct zswap_test {
 } tests[] = {
 	T(test_zswap_usage),
 	T(test_swapin_nozswap),
+	T(test_zswap_max_zero),
 	T(test_zswapin),
 	T(test_zswap_writeback_enabled),
 	T(test_zswap_writeback_disabled),

---
base-commit: b3dfbde62cf1981c4638939c159dfd087b7a72e9
change-id: 20261111-zswap-zero-limit-a558f39606d5

Best regards,
--  
Tomás Senart <ts@perfloop.ai>



