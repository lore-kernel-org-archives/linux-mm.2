Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C5EBD58B22
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 04:44:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 005F76B0113; Mon, 16 Mar 2026 00:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F25D36B0115; Mon, 16 Mar 2026 00:44:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E35A86B0116; Mon, 16 Mar 2026 00:44:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D21AC6B0113
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 00:44:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A81E1B86CD
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:44:34 +0000 (UTC)
X-FDA: 84550685268.27.8A6021F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id A617D40005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:44:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="i42V/vnt";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773636272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IGvRhuyuajIbkQZn3epkDu7JWhW7+TuEmP6Npdox41U=;
	b=msrUNHFIWYv7l94YLt4/fnohZRrkiG3BXJh58jqUBGnBtXIOHvVeNAYr9B5HPwbpW2NH6L
	CmQrC7JYoAarG8e7IVPsRDFlo0wRyK4RN7IR0W1/hvWy7Egcc8ivY9ViClZ9koZk5N5CyI
	ZwxQwDeQyUS//V5o3HXhQerWi62FkJI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773636272; a=rsa-sha256;
	cv=none;
	b=095zu9QWGZ9rFY49cnyPV5bd3XZjP4SoHLYgJDCPTYtNT6wlMbEpswtIcIx5UoktMPw6sV
	2QraTSmOTah8SAfv4uXfB48OZUNIAFMnxfjq+4OicDXAxkDZCiUwVrGl1CwHymlHIMOQox
	unYrejMrkDz8sTRgppLXJONofxs4OPo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="i42V/vnt";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773636272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IGvRhuyuajIbkQZn3epkDu7JWhW7+TuEmP6Npdox41U=;
	b=i42V/vntB42/reDRh4eaorxpfRHk73l4Urkr1NpAZ14EPbgrWa/XZR2chcxaU7wAs56K1t
	XtHoTUNR+f+xIrDu6aiqO75kl8Qnl+QVQj3YI7e+GuyWFIk623TsB/YyHcbkkkl9NKHJUw
	RbnPXgq4/yvXFtoCLO0OcGUXI0AWjmY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-678-MmNkOmaHNyOUlOocgK9N_A-1; Mon,
 16 Mar 2026 00:44:28 -0400
X-MC-Unique: MmNkOmaHNyOUlOocgK9N_A-1
X-Mimecast-MFC-AGG-ID: MmNkOmaHNyOUlOocgK9N_A_1773636266
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC3E4180049D;
	Mon, 16 Mar 2026 04:44:25 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9091519560B7;
	Mon, 16 Mar 2026 04:44:17 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	chuhu@redhat.com,
	Li Wang <liwang@redhat.com>
Subject: [PATCH v2 4/5] selftests/mm: split_huge_page_test: skip the test when thp is not available
Date: Mon, 16 Mar 2026 12:43:34 +0800
Message-ID: <20260316044335.1390608-5-chuhu@redhat.com>
In-Reply-To: <20260316044335.1390608-1-chuhu@redhat.com>
References: <20260316044335.1390608-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: K5L7bEbu78NyPN8giL3V5hoVbxsDd1azITY8Cx0NJdw_1773636266
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A617D40005
X-Stat-Signature: icop7euzd5x176gacxs3c13xejeg7wzp
X-Rspam-User: 
X-HE-Tag: 1773636272-597758
X-HE-Meta: U2FsdGVkX1+2b0I1EwhIYQZk37UPnINlgYKlrnXU/zW35/VZutmu16g5cdNwt7tw/7q8q1SDPFVwYOfuWUfk2toGzYAjjNFVGf5H9rZCqxHwLY1RQPJ9kwi/1BQd1Vx+jB2GKCoD7AGcezaZqUBqWU7rglnx9WRZ1+bFu5M2rVmw9y8LXA7PI7W23GsPHcJ3pdkVkN3UatWwHp2EcIXFMkuIYQdDnbykxndneh38sq4jbcQ+dyItLRncKPwY2WmomekbmYDoTcafEqgksPX/rJXHEE/T8H+Y+/HHVuiEm4epFoCE3P8EtF7be/A/3PaS+Lm5pCtBFdnDFG//pNeayUBaE4nrqmEkMbEP6/iqLk+6fw2Hd/eP3wBWoO6ObtwAiw7/YRzI2EtIfsTrV8L+eDF9VJuKcj1RxzCG7tB/1/73xGP0nGwOdJteYVY8Br6AycJNcUG1q5RQpS5elg+j4Sum1jIzZC4t1I8VPuzZWbo7UuCDPq4A9UAJ3SoRKllwcdj49rgrtAS5OuBYPG9MAtvxDYFhJ9nR1v8JgHauhbdQ+RNoqFnnZEiNRQZNMoAWWA+N1HKkzATAPvPUZeqGTqNa+0GFX6+NW3sv3Rb+nZbl94yOW//ZLOa1UE6bT5dYL7t+OvO7tw/FRq8e68AMg7OdyHc4gOQuPH9tdSR/vUC7QyxQGWYb7mNHX7+tlq2lbfNuAepXIBWzACl+a23lv+O+S9CuIikBhwjumm/EN7f+O1yur46llXjPeCItAj2t9jROa9dnH9Ane679ZSkBguogs4Ujf97KH5uUmrGyGkBmGXytGFbLpzbw7vYprXkkVbfnF4KTC0nGKrg5HV7EdTicFKNU285JNfKHelXTjIbmtYoeO+Mu6ZQImQf1GAsZ/XB/vn7s3aqCuFqdaYB+p2nm6hycbju4YuLm1NGYz4LV6w9eV5+Tou+UIu+DgyR5lSl0GBhpjvz4JpX7gze
 8XAnHH7a
 nvz0YhCIKVutwTSKJedBLvywi9VICjfVo2Au9WC1XzdLGxEqxn0QOdZdcHs8kB/Y+97n405Kysz2eh9Gy+Sc4y/pNzuBa3JLh9Bsm/4v8/eWTGTcZim5celJOpuxOHG0XVyt4oe4dEhpCL2h/XdLAIdDP7Ilmcj1vfRkVpfTPhD2TujM9iuO3BKhITI7iwcCFkwsEClXlQArD6GFCmTAZUbIQFI7gEtvDvKXPh2IqH1H/YQl+5jVsoVhtOeEHo8zS6ejB7lWlhqmiKs1IcFnlzP9jarfFj79YFDhLEmYAhJnvCE9rjbkG3SPaSOR09lQ0V/EOusKu2S+N0ouslAuzwoJhYYWSG4kT/tHPIX1JXvGLqW12MYOROh9FieiDVH0dasR4Q5z4W7BYufPVBRsMav3tGvpr39Xh4p9HfQF0OxIJnjOE0SNUDpoAGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When thp is not enabled on some kernel config such as realtime kernel, the
test will report failure. Fix the false positive by skipping the test
directly when thp is not enabled.

Tested with thp disabled kernel:
Before The fix:
  # --------------------------------------------------
  # running ./split_huge_page_test /tmp/xfs_dir_Ywup9p
  # --------------------------------------------------
  # TAP version 13
  # Bail out! Reading PMD pagesize failed
  # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
  # [FAIL]
  not ok 61 split_huge_page_test /tmp/xfs_dir_Ywup9p # exit=1

After the fix:
  # --------------------------------------------------
  # running ./split_huge_page_test /tmp/xfs_dir_YHPUPl
  # --------------------------------------------------
  # TAP version 13
  # 1..0 # SKIP Transparent Hugepages not available
  # [SKIP]
  ok 6 split_huge_page_test /tmp/xfs_dir_YHPUPl # SKIP

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
V2 changes:
  - removed the {} in if block
  - removed the write_file helper rename chunk, as there's a new patch 3 to
    resolve the conflict with thp_settings.h by moving it to vm_util.
  - Add reviewed by from Zi and Lorenzo
---
 tools/testing/selftests/mm/split_huge_page_test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 93f205327b84..500d07c4938b 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -21,6 +21,7 @@
 #include <time.h>
 #include "vm_util.h"
 #include "kselftest.h"
+#include "thp_settings.h"
 
 uint64_t pagesize;
 unsigned int pageshift;
@@ -757,6 +758,9 @@ int main(int argc, char **argv)
 		ksft_finished();
 	}
 
+	if (!thp_is_enabled())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
-- 
2.53.0


