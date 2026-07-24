Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14A33C531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:25:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14AB06B00A9; Fri, 24 Jul 2026 06:25:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FC2E6B00AA; Fri, 24 Jul 2026 06:25:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2CC76B00AB; Fri, 24 Jul 2026 06:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCF556B00A9
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:25:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D5401A02E9
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:25:16 +0000 (UTC)
X-FDA: 85023287832.17.A25CFBA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7AFFAC0009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:25:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RyUi2Q98;
	spf=pass (imf28.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784888714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5IZ5z+tB9go2eRh7hY/hXww9tj8Mkml0dXjZEmFzd2M=;
	b=yWbRZ23ivB+QwOinxBvmIwM78gqhE9/gobGeCit/+bUYD7t+C6L4CY6Wjs2qxKWxaBn613
	ty2ax+qD6lbY6BnibF6CmIbSiAz7+wZkD3XE5yUs2i61VLktU8fBrjHGfVgTOvMm7gCIX6
	6f4JnEQjOn5b+/IyHmH+s3UihzC5TS4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RyUi2Q98;
	spf=pass (imf28.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784888714;
	b=uZ49GlKSMBw9vNbEgjFanR4QKlXhAV/hKdoVP9Zd+qxT88f2IS+MBlGePgrsz0UTHGp+a1
	G7AkdsU1cBajWipjjwE9QQ6g4cgylTFoIwAnFD9Oo/gvSlP6dlGdadLHO5wjyum3YTff6a
	t935FIcYHHXDw45gCqVl2fA9ELHaIk4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 854BA1595;
	Fri, 24 Jul 2026 03:25:08 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 99B2B3F66F;
	Fri, 24 Jul 2026 03:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784888712; bh=MakI4ukXwu0PoXIFZ3JJzT172oQaQ64yT7zlKhSuUTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RyUi2Q981HswYqVpjbuDTwj78A3tH8i5UuXyjlM507jXF24nM0iAqloacy8W8SZGq
	 Dvyh7DsZXMH6UZa5BzH/h9DKlmHQ75aJzUG5l/zDDHBJHo9mI1AUhOBZZX0jOspoiM
	 1qqdagny8325f26PjfsJ2imrsIsB9FyvfRnyIzsI=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sarthak.sharma@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v2 3/5] selftests/mm: skip khugepaged swap tests without swap
Date: Fri, 24 Jul 2026 11:24:26 +0100
Message-ID: <20260724102431.1199519-4-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724102431.1199519-1-usama.anjum@arm.com>
References: <20260724102431.1199519-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7AFFAC0009
X-Stat-Signature: ugd5b1p7mxx8wp5fzy4gg1tuy5cadbhs
X-HE-Tag: 1784888714-245871
X-HE-Meta: U2FsdGVkX18F8anr84jePLbTazfcaELvPu8A4Uns+UMwZgfFieMLEqbohXQoWjHh2lcqx49p6gnjGK0KFP5b/PZ+R81gBWxIl5SnXtNkNicfMKam2Kfr2diG4fhoGo650BjBLcrqpaq6Kk+eGRKIla0Y9wHA5gdScMkAeJEY88gi/3FpyVQSjN6/vu4l4cYT1ebQfM9pA4qyZlSwtgzS5EbqqZHKIRvTYpxyQIUGNgAgfUwxTDNww/OHZUIVV7IMGBX+OH2OAZZGi4KwpOL53pfJKY5vLQ4XUh6KzH3VonBEBksPabPsh0QNVGcnbgub/vhPy0ND6ceUZc78uKWeEv9ESCPZGStBgoU4q69wmb8Omnabnvsc0WjJMB8BmQBugDuPIXGLO+lNzWl8Rt7G7BNGNnTyWhvpSOcHSjZry1G1PZJ20erAUSG3PoOPHptFbs8CoF17Nm6pdGspZw2wzt6ulEENyR+474b/WeAJl5POMfbsMIVFSN/PiRYlqaSxIoqvaTFeNOlIbTkzCFcpq/JDyirF/D2x8ysNQ0x/Pr0KCBlklCfh3GuThMcdv1DTOl0WL6fowMh/effkSpMDIxATuRE0zSnAqYGiorve73bHlKyy1wPuSofrui6mpWItdWxKs7/t50N0rEU1GeByPJrF7FeqdFu5pr7qUECosfE9jrOSrBuRKTXOKq/a0rkN6hrWk+Lf6PKXxIq5rIdkgOOzNBhoZDTaFsEgnaIxZi6v1EG2pefQPns7FNAt/Gx/MEZQJTVBMWmM8V1qUGrZhw29YTf0y8oGC5Xp31LKVNRH/yrtfQ9tAOCy5+oV/mb+tqdqbUQ5bvzHbKbI/QeyezCu4SfWe/vMHV7xYFkYZiOLeo5Go+ZnNg4qCLobRWOntWveL/EEGun6xmsg5o1LJZ8kbgeEp+SIypMfwAbheQ80cZs9G19rcdkwuapuN6ebWjAFR5o8TLv3pQ7DIMM
 LT+5o2bq
 l0oYZjwMOXTqJAaI+IOajWUVZK+PTUN6nZK9X2lwcrCJqP46XeBYD16y83A5YF1qvNUyl6tTBRAKv0sIALg75h9FzNSXPrxbIEkgWwd5kypfa8HPL2Md1b6+ebSw/NgwqP4YwIbr6ZcoJw2vPrtEZHSGFlXExS9KuST13DBq5QZwZQGkRlSR7lF+1OGPUeNpPoO8adcna0JZKmxrqiOOc+Q8bf75ADbCMiDmB9QdYvbc6RxHuHbF90Ma0vB74pA367b9mKadUgO4PPi2BS8GCpnSBx2rmGlNI3L0MnPdsb6Bn0mxXIHm3ztWDMuF+BvIKovLE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_swapin_single_pte and collapse_max_ptes_swap require
MADV_PAGEOUT to replace anonymous pages with swap entries. On swapless
systems there is no backing store with which to create those entries,
so check_swap() reports missing setup rather than broken khugepaged
behavior.

Swapless configurations are common on Android and other constrained
test devices. Failing these cases obscures actionable results from the
rest of the khugepaged suite.

Check /proc/swaps before either swap-dependent case and skip when no
active swap area exists. With swap present, retain the existing
MADV_PAGEOUT and swap-entry assertions unchanged.

Print each existing swapout diagnostic before the prerequisite check
so skip() completes a KTAP diagnostic line instead of emitting an
unprefixed message.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Print swapout diagnostics before reporting no-swap skips.
---
 tools/testing/selftests/mm/khugepaged.c | 38 +++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 10e8dedcb087d..54e888eb48bbc 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -100,6 +100,28 @@ static void skip(const char *msg)
 	exit_status = KSFT_SKIP;
 }
 
+static bool is_swap_enabled(void)
+{
+	char buf[MAX_LINE_LENGTH];
+	FILE *file;
+	bool enabled = false;
+
+	file = fopen("/proc/swaps", "r");
+	if (!file)
+		return false;
+
+	if (!fgets(buf, sizeof(buf), file))
+		goto out;
+
+	/* Check for first active swap entry. */
+	if (fgets(buf, sizeof(buf), file))
+		enabled = true;
+
+out:
+	fclose(file);
+	return enabled;
+}
+
 static void save_settings(void)
 {
 	ksft_print_msg("Save THP and khugepaged settings...");
@@ -734,10 +756,16 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
 {
 	void *p;
 
+	ksft_print_msg("Swapout one page...");
+	if (!is_swap_enabled()) {
+		skip("No active swap");
+		ksft_test_result_report(exit_status, "%s\n", __func__);
+		return;
+	}
+
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 
-	ksft_print_msg("Swapout one page...");
 	if (madvise(p, page_size, MADV_PAGEOUT))
 		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
 	if (check_swap(p, page_size)) {
@@ -760,10 +788,16 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 	int max_ptes_swap = thp_read_num("khugepaged/max_ptes_swap");
 	void *p;
 
+	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
+	if (!is_swap_enabled()) {
+		skip("No active swap");
+		ksft_test_result_report(exit_status, "%s\n", __func__);
+		return;
+	}
+
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 
-	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
 	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT))
 		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
 	if (check_swap(p, (max_ptes_swap + 1) * page_size)) {
-- 
2.47.3


