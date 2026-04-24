Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25A71FC0360
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 04:01:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 736C76B008A; Fri, 24 Apr 2026 00:01:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70F416B008C; Fri, 24 Apr 2026 00:01:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624F16B0092; Fri, 24 Apr 2026 00:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 516036B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:01:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D802014043F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:01:30 +0000 (UTC)
X-FDA: 84692099940.14.1B3719F
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1B860140015
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:01:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oeHyCQPN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=li.wang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777003289; a=rsa-sha256;
	cv=none;
	b=ua/vUm9CP2BBdZK2OQtJ9ot1kCCfLY3o9iYZR1XdhB/BZcryQszBcMjDxHDIsaVSQH7euI
	7eCDHsoEBReDR69XRbWo+uzeOsQgq730fWEW8hEMgeFO8jtVzFsMFxVyIXcEMKhRvZoLvA
	VEuqwyFq0fS/cUL8qXZZx9wUkbwboaQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oeHyCQPN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=li.wang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777003289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gr8asudXbZcTLEQoBtpdGFZE+1tjsTEgxDXHfEmUBuk=;
	b=zRwOIjyYlRWA0WJuTPOiipOniA78foq2g0IUz53rQiIciWDOGo8VBg+aofOZfGRmONDedn
	b7WEjo5WNpvt08VkpXktopOs1SZU0vuhxpiRlnoKT/sAb8360S+IjTujsy8K/V99uZ/Qwo
	OhNzUiU3cGLvdm1B8LQWSlPvtqFyEUg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777003286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gr8asudXbZcTLEQoBtpdGFZE+1tjsTEgxDXHfEmUBuk=;
	b=oeHyCQPN6+7SzNn3zyt6SJZNgJ5tcf7mfOBQNDb1ZmDi/X56dFl5cpn+kLCtEXxwA4x31x
	tTcK0JLkTWi8s/gOpfklOW8MpGl/JoIh6j8u8MeRtBdpu2GYmpOTVF9Ujdqzh7mSpYFkxP
	4qmDHAwU+GLrCHoCPn8itn3iGnIBjRY=
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
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v7 1/8] selftests/cgroup: skip test_zswap if zswap is globally disabled
Date: Fri, 24 Apr 2026 12:00:52 +0800
Message-ID: <20260424040059.12940-2-li.wang@linux.dev>
In-Reply-To: <20260424040059.12940-1-li.wang@linux.dev>
References: <20260424040059.12940-1-li.wang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Stat-Signature: emw5mfoot7pyeeb63ns7w31thwoxsfnd
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B860140015
X-HE-Tag: 1777003288-595907
X-HE-Meta: U2FsdGVkX1/UEBSEsEBkHsDSUYRRokqAGaG0Ntf74uAvQ+wVxW5CIRlPK/z43mt7+uuHwYvzmnihoJO+tlynp44foUYjZLtsdeUeQyLCPNKOsnSe+7mMLkW7BX+dF7rugKRr+2rWo3Ds0bKX44DVHKd+cMBiYeO0IfwLsnmI6W4r4YnizP5+zO2qkhOMeCUZHqAS1fyd9XZcwMMKNnE0lLGiMgV71O0V6rllV5EvWDrGMP1MBa4BktF9O5JoIg87u0WTaRugOAmiv9Zdua09HcVvhhG6ANN6hm+G4VojXseEAdk4X76NdAIqAvOaJwKxbVm7LPqgfmeB4I1mgEvyM5fSHVUbrJDYNUff3d8Q3Kp29bxJzrpEjln9VOM1bwLRxBtfunpY9uguBTu5hLN4+87EpO849hJ8VQuLsnZJ5DVCLWiw49eOWOh9dnKr7qaLHngKD3iSDOkQbqFjxQus9Er8s4Q8pLyDLOL1sDE8bKpTrMhQzkn2/Jwpx/GnuixyFBJusblv/Aun3Bdk/vC4CgGrTOr4YBctg5eEJXqE5/3JwyEeCY2oJhdW41l9tVjOjM9VQhUBEVFoRwXJ8+5vNncdRLAjQJ+xXLvqGBQ0pwCzE/S8rYP1Hfo8I0bClgme3130RrfOCtenLoN8nyFOpPUKpAllp4sEB7LBRjuOleFAoQs2dAeMUdjmQTudVegd1JLVujdwtG2aUh+wM/ZsLwuX1tfDXkWgpmm7/MYHhnlSFeMT4uXrBDknVp7ZB9sG2PqjjfTEzlwNDexQXmc0x9tNUWV3NdUfcTQcMuizfqVkjj7Z2pVYfAEOL2yhP6rgycbl/b35eMX6g5yKurhd+SkiMNDRMkEQj6G+KZziNW/3xqGwoSQN27aJpjdMR/wyMeH2M3R880AyJOx4GCxM0aUsrL1902fOKNhxu+uy2Oyulju7VUGCnFzl2AHQbG+aZofJoQrlsDWSwPasdTE
 z24Q/lhf
 5owNDOeau5Xg/cXBED6+I9X04OylmCpBL6GiIZtiMWhhtIHBUFjqV/vu/cbd+9yMUIvurYXWxJ7lNWN2krxYFBZ/Lf4p9dz7iuJQiu8GxPZFcR1C2e0cx1cQ4RIie+Rp4Cg09y9Fyr3pg49kTIiBYPGMoC2s0TR7lkMUo35gI3s4S2gjXGSBNFqnn87CfUJDTf/zuOIk6t4x2sHaJCI7Ql6yc8e+hCqeK01xgKcrlaZPCmeOKYn5g1lkbWxtaoB1IztrXGWjhIR1gVOyP7GiNf/c57+QyJgPqgboix70qJ6XpjyGc4Pq2dS52KEN50CSXdCqyr+lzcb8tP7uU3nQ8ThYOMACrjRX89AyG57+qfXw2SNkJ9IFVggcifDp15mDpa/RB1OyyWTh34DokgL15Pbg+J/PoayqaqmU+hs3wY050lYieEFXZH0a1hUAwzBr/KIoyRPZoSUVd/5VOzaqla8TxOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_zswap currently only checks whether zswap is present by testing
/sys/module/zswap. This misses the runtime global state exposed in
/sys/module/zswap/parameters/enabled.

When zswap is built/loaded but globally disabled, the zswap cgroup
selftests run in an invalid environment and may fail spuriously.

Check the runtime enabled state before running the tests:
  - skip if zswap is not configured,
  - fail if the enabled knob cannot be read,
  - skip if zswap is globally disabled.

Also print a hint in the skip message on how to enable zswap.

Signed-off-by: Li Wang <li.wang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index a7bdcdd09d6..a94238a2e04 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -15,6 +15,9 @@
 #include "kselftest.h"
 #include "cgroup_util.h"
 
+#define PATH_ZSWAP "/sys/module/zswap"
+#define PATH_ZSWAP_ENABLED "/sys/module/zswap/parameters/enabled"
+
 static int read_int(const char *path, size_t *value)
 {
 	FILE *file;
@@ -725,9 +728,18 @@ struct zswap_test {
 };
 #undef T
 
-static bool zswap_configured(void)
+static void check_zswap_enabled(void)
 {
-	return access("/sys/module/zswap", F_OK) == 0;
+	char value[2];
+
+	if (access(PATH_ZSWAP, F_OK))
+		ksft_exit_skip("zswap isn't configured\n");
+
+	if (read_text(PATH_ZSWAP_ENABLED, value, sizeof(value)) <= 0)
+		ksft_exit_fail_msg("Failed to read " PATH_ZSWAP_ENABLED "\n");
+
+	if (value[0] == 'N')
+		ksft_exit_skip("zswap is disabled (hint: echo 1 > " PATH_ZSWAP_ENABLED ")\n");
 }
 
 int main(int argc, char **argv)
@@ -740,8 +752,7 @@ int main(int argc, char **argv)
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
-	if (!zswap_configured())
-		ksft_exit_skip("zswap isn't configured\n");
+	check_zswap_enabled();
 
 	/*
 	 * Check that memory controller is available:
-- 
2.53.0


