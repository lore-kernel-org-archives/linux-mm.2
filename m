Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E33EC5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 18:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6036B0095; Sun, 23 Aug 2026 14:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C557A6B009B; Sun, 23 Aug 2026 14:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B45266B009D; Sun, 23 Aug 2026 14:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88BB46B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 14:43:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DBEBF160389
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 18:43:35 +0000 (UTC)
X-FDA: 85133407590.07.CCDFF30
Received: from mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	by imf30.hostedemail.com (Postfix) with ESMTP id C173D80002
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 18:43:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wbV7435I;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.15 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787510614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=80U5/1z9O344hzgJgSz/o2r0kPaRJXeQatCRvLC5ngg=;
	b=tWzHOhSCXaZFIovbtWmyckZ3hwvvD5WATfVOVop6ZuU1yki/SsIvFQ3Sag3tHUOQ2Dx2ZF
	12Af4DtLV8IfPI/oLT6zI2GeGWWl6tC0H1WpeBAfyFWysHTAnhAFjLopkntYYBk150SGec
	Tqtq0nIssH0WcOHXf1V6A/ZlY6Q+WfU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wbV7435I;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.15 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787510614;
	b=bgw9m+ZnBGu0MuFEHJtAGW118YvJqLWShG5Y/fREIOcif/KNuAw+5XQeukUwY9WlH51gWy
	2++9YqIHlB7Rfjh3NnLO3h6GG+6EkVrE1pzL9PCk09qlY5Wkl0q/EN6JfXOE21NWJGR7A2
	Hkde5tXU1hiKhms495j4/Ce+mqEdZU4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2cRtSobj9DpAWdrabwHpR7MWbs04ul1EeZDL8CjWVAM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787510612; v=1; x=1788115412;
 b=wbV7435IA+1QO165eqrBuWJyCQsbAXXoibrGKfIsjwKTp8wjZvPLQH/TAQWusc0Y2LcTqNGS
 F78ImbGUmv+LkvaZlAr15d5v2jTKw4jHPsEma9oKvmqbtOrKr8Wkci0empEkYzibJZtDDomsR/P
 q4Wk7Tu9oyYLbUWGdeCXwkJ0=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (218.247.43.97)
	by smtp.migadu.com with ESMTPS id 040bf0f4d0e4635f;
	Sun, 23 Aug 2026 18:43:31 +0000
X-Mizu-Trace-ID: 040bf0f4d0e4635f
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	shr@devkernel.io,
	ljs@kernel.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] selftests/mm: disable smart scan for ksm_tests
Date: Mon, 24 Aug 2026 02:43:14 +0800
Message-ID: <20260823184314.45044-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 658uhtg8u1sqjs6gdtufk6kzsdq3ur63
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C173D80002
X-HE-Tag: 1787510613-711172
X-HE-Meta: U2FsdGVkX1+lLYHCd3aDp6ann6jAroSUHLsMu05kqw7Sr7sKx0zwvn+4XRylUZwOJpzdcodCtxAMQngJGG3w/JOM0yEcqLiDgaZSFXulLfnVQjW0t1mIlXZrh/1XZQPCf+5sB8EpjmS0fBNkCT2fpU/7ojRPDpoChIvghGuAELw4CYoDUhSVNL7pH7u70ZzPDBxDygWdf0vjJaZYec3fTJl0RN4TfUM/LyinM3xTmY6xdhYksfpIPIWhpliQwUzWtQZKsnqdj6xOID4UkSLKMKbxX+zgmbatZR+KXOjwG0/dGtYLkBfCRCcG2a2ADvsJSOkB5zkfANbzrjevI8cZRXtsk22CYg8qCNMMCXhzQXfJ5It+LBwIpfxB4pJivK8O9v1fW780vVGPqLTlnLsP8+ROl8GjlJDQlhVz1ypCpY/jIWMyhEGHZyHH/xzwC+qixKVAnAY3GmdHP1Nq1cWmPs3Go4QIUqWb5hU9WkCmPXnC6xFg1mRyRC56vg5MSikD5jIkITbtYwuhlZFo+MIbDCfvqjazn5dtWDmIAAGKgqRVcAilQjT/E5XvIzU6UhLE8931+qH6fnzuxCewN6xTQJ/mRRNulIBI5qDFt+rjbb+EwxCL+88BrajoAYXBzfnQb5Mhn2bPyRZRlVXGzypPrQrJtKzNLNWmNp4YnVXVlV06vHKeVTDw7unIE14wLL6iMYPyB3ZiD2YdqyZq1ZQNL6qB310SqDRpSRZsGXfhxxdCq20i81hrbx+v3CE/+HpzQL2xIF5d66CI7Ax5DJiozObXzqt7rFdoVkIEpJQnSJoeIXBXUa7y/FwVgTmWIsvm/vsDDediu35baKFtCoH1UrtYHywMYQcJeU3BV1ZFbLoBeVorosQH1ZBY93msoYbdIa7Sm5Wvup9jo654cH7M0tC7OqdpSm/fGskv+NbkbjChm8a4AafQC4T+p8vZUDradBNAClFXL7ENwKCFMP5
 nbTeEanm
 s3+Ra0BZ4taOlJc06hg7opkBFhl8IL63k42TBj0RuA6+8tvynrLzrh//WQE2H8apLnld31zoJcipdcLct9mL18pXrU6YTmNKouafQAtK4NQuML+E5haGkTsaRv1osSo7hpYCrlHg15wtDbPwqRyxNdJJWtstVw3MYvhGQqGOvJTvGBC6AGOkN3ALvTbtqclzv8UaoBbwFzCdZNuTQN42qKi5AmM8ZKQw0C9Tm3Vnz0sGNqnwrBND24qCHQ0VLzH/ZjRTgpt2CLR/3GB27NOjXggoQPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

The "KSM NUMA merging" test allocates two identical pages on two NUMA nodes
and verifies KSM will merge these two pages after 2 scans (see
ksm_merge_pages()). But when smart scan is enabled, pages that have
previously not been de-duplicated may get skipped for some scans. Verifying
KSM behavior after only 2 scans may not be enough.

 $ ./ksm_tests -N -d
 TAP version 13
 1..1
 pages_shared      : 0
 pages_sharing     : 0
 max_page_sharing  : 256
 full_scans        : 211
 pages_unshared    : 1
 pages_volatile    : 2
 stable_node_chains: 0
 stable_node_dups  : 0
 general_profit    : -128
 ksm_rmap_items 2
 ksm_zero_pages 0
 ksm_merging_pages 0
 ksm_process_profit -128
 ksm_merge_any: no
 ksm_mergeable: yes
 not ok 1 KSM NUMA merging
 # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0

This specific test fails because KSM started scanning the second page
whilst the first page had already been scanned for 16 times
(ksm_rmap_item::age of page 0 is 16 greater than page 1). It's not
difficult to infer that should_skip_rmap_item() cannot be false at the same
time for these two pages - they cannot be merged even after 211 full scans.

Given the current implementation of smart scan, it may not be appropriate
to enable it for selftests. Let's disable it for now.

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 tools/testing/selftests/mm/ksm_tests.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index 5fd7792a0d47..e72681090ff9 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -33,6 +33,7 @@ struct ksm_sysfs {
 	unsigned long pages_to_scan;
 	unsigned long run;
 	unsigned long sleep_millisecs;
+	unsigned long smart_scan;
 	unsigned long stable_node_chains_prune_millisecs;
 	unsigned long use_zero_pages;
 };
@@ -293,6 +294,7 @@ static int ksm_save_def(struct ksm_sysfs *ksm_sysfs)
 	    ksm_read_sysfs(KSM_FP("sleep_millisecs"), &ksm_sysfs->sleep_millisecs) ||
 	    ksm_read_sysfs(KSM_FP("pages_to_scan"), &ksm_sysfs->pages_to_scan) ||
 	    ksm_read_sysfs(KSM_FP("run"), &ksm_sysfs->run) ||
+	    ksm_read_sysfs(KSM_FP("smart_scan"), &ksm_sysfs->smart_scan) ||
 	    ksm_read_sysfs(KSM_FP("stable_node_chains_prune_millisecs"),
 			   &ksm_sysfs->stable_node_chains_prune_millisecs) ||
 	    ksm_read_sysfs(KSM_FP("use_zero_pages"), &ksm_sysfs->use_zero_pages))
@@ -309,6 +311,7 @@ static int ksm_restore(struct ksm_sysfs *ksm_sysfs)
 	    ksm_write_sysfs(KSM_FP("pages_to_scan"), ksm_sysfs->pages_to_scan) ||
 	    ksm_write_sysfs(KSM_FP("run"), ksm_sysfs->run) ||
 	    ksm_write_sysfs(KSM_FP("sleep_millisecs"), ksm_sysfs->sleep_millisecs) ||
+	    ksm_write_sysfs(KSM_FP("smart_scan"), ksm_sysfs->smart_scan) ||
 	    ksm_write_sysfs(KSM_FP("stable_node_chains_prune_millisecs"),
 			    ksm_sysfs->stable_node_chains_prune_millisecs) ||
 	    ksm_write_sysfs(KSM_FP("use_zero_pages"), ksm_sysfs->use_zero_pages))
@@ -846,6 +849,7 @@ int main(int argc, char *argv[])
 
 	if (ksm_write_sysfs(KSM_FP("run"), 2) ||
 	    ksm_write_sysfs(KSM_FP("sleep_millisecs"), 0) ||
+	    ksm_write_sysfs(KSM_FP("smart_scan"), 0) ||
 	    (numa_available() ? 0 :
 		ksm_write_sysfs(KSM_FP("merge_across_nodes"), 1)) ||
 	    ksm_write_sysfs(KSM_FP("pages_to_scan"), page_count))
-- 
2.53.0


