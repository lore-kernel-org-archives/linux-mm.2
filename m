Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6920AC88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 23:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77AD96B0092; Mon, 14 Sep 2026 19:50:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72BDE6B0093; Mon, 14 Sep 2026 19:50:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F49A6B0095; Mon, 14 Sep 2026 19:50:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 326DB6B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:50:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63F33A0249
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:50:19 +0000 (UTC)
X-FDA: 85214014158.30.7AA2070
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	by imf23.hostedemail.com (Postfix) with ESMTP id CD1A6140007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:50:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b="Spi3 IfK";
	dmarc=pass (policy=reject) header.from=hpe.com;
	spf=pass (imf23.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789429817;
	b=BdDScGSsvf6p56rpMT/keCwvp/W7ZFJVn3DDMFsi/1FAbFOudbzULNcLFCVgK84FQFn674
	OhNGOj/LM6Lpnl/n2KjG9LXllTq7u7wQpkF1B/xQ5pLmawQPds0Jz3UTHYiOwzBH1HRJY4
	a9hyQGnsloGR/PCo7cWa8jDvBcywlyI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b="Spi3 IfK";
	dmarc=pass (policy=reject) header.from=hpe.com;
	spf=pass (imf23.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789429817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BgixqtpyB38o3XY2oscHlzHiD+X2kqerFNseLSwBY1w=;
	b=TPgEWzEF675OvnsWe7Imso9ENy0RrLMkQDuOS51s7XEG1FsP9au6FZ/I7H3RqIMo5a7D8S
	+bgEvQNSnpQrXaKRlIaPNZYM5M3XCC1mEsFpUM3cjqyKdoOG84aRCcKgAg2XXAcddTjqJ7
	rKTJFpaMbXkLofQi4xDn/xRZhJNAXTk=
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68EN1ZkU3352244;
	Mon, 14 Sep 2026 23:49:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:message-id:mime-version:subject:to; s=
	pps0720; bh=BgixqtpyB38o3XY2oscHlzHiD+X2kqerFNseLSwBY1w=; b=Spi3
	IfKJOoBzqCTThh26JAsodV1anoacuSWzddRtaspX9w8+bDruCYP0IufX/uMog7YL
	7bwELT+8a5H86Dww2S88k5Ve6TXagVcdpp+3eFgDN3tNRHNrMbVejnX10PxfRPRI
	JtlFfmaMrGMPVn5RdM03JfhsAMBzAuBGkEO4NqtJJyFJIY8uJhpFR/LypLg3bFjB
	gWswAt5H01c3huEkhkezkvARahj9xjenAwYnRsfkrIgCQlFCvH8QZlEW8bW/qMc/
	XAOcsax6+XfLFfV/CIr7HQHZcOYxJTSRIhMY5HjRbKxEmSzV1hGN+BvE/MEkBplq
	BFGYe80gt3qsNNfxgg==
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4gpn7hcf6f-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Sep 2026 23:49:50 +0000 (GMT)
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14878.it.hpe.com (Postfix) with ESMTPS id E4BDD147A9;
	Mon, 14 Sep 2026 23:49:48 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTPS id 14E84806B64;
	Mon, 14 Sep 2026 23:49:41 +0000 (UTC)
Date: Mon, 14 Sep 2026 18:49:38 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: akpm@linux-foundation.org, corbet@lwn.net, david@redhat.com,
        linmiaohe@huawei.com, shuah@kernel.org, tony.luck@intel.com,
        jane.chu@oracle.com, jiaqiyan@google.com
Cc: Liam.Howlett@oracle.com, bp@alien8.de, hannes@cmpxchg.org, jack@suse.cz,
        joel.granados@kernel.org, kyle.meyer@hpe.com, laoar.shao@gmail.com,
        lorenzo.stoakes@oracle.com, mclapinski@google.com, mhocko@suse.com,
        nao.horiguchi@gmail.com, osalvador@suse.de, rafael.j.wysocki@intel.com,
        rppt@kernel.org, russ.anderson@hpe.com, shawn.fan@intel.com,
        surenb@google.com, vbabka@suse.cz, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v3] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Message-ID: <aqiIEkrc6aDBOqRg@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-GUID: -OZ1egiv-0_rkLUWk5mvi5IhLB3ihwUa
X-Proofpoint-ORIG-GUID: -OZ1egiv-0_rkLUWk5mvi5IhLB3ihwUa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDM0MCBTYWx0ZWRfX4EeDazthgUzO
 LLUjnQKXrkHQlp8jhLNGNx43SiXHtlBtXji0UEGn3qiw+18ZH+Jhj5srbWJq1/j7ImlH1i3LgXq
 1YgzqkM+ylPp12jNi2pPyw8CpaUuoxMun346MqrPr7EqeAJVBTm1quCi+yzGbmVcHKhWD+UYz0Z
 WFXjTKNIZW3LaU2IDaG7C2qcm6AKONPEirctifQkVmjr3RaEZrgMT17D7pvO16oBxWokp8ZJ7Es
 1xZqXkE8M10JaVQCxd3pk+8jHwgLhIxG+lyJYNn3jDGv7vcUJi4Od/mdnnwDR8hyhTFG9vzOxd0
 SF8fUyCct21W0YLDOQC2Gt0i1Fc5ftsauv0yJ+c7pBryDhTdP9lOHh36cmitFTRIiyQdjWYPer2
 hlJRom+y/sXFZYYJxdd6mMSEtZOVewaOW+qcSZHnCS0DpTTmSXUOAJIHEa1N5XpV9Qdj9CNkCV+
 makygRo9TYkhHrfTnCQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDM0MCBTYWx0ZWRfX02HMWpRZM5hP
 7iUGhR6Ql5A7+nzFh26BcjaPUAuqtrP7ZTNF5qQuCJ2cH6guavuDPS/P+QjgNlQOqiw4yOeKRNj
 nuH9JiWolp/1e7UKTdIWN0Dkfm8NZZ8=
X-Authority-Analysis: v=2.4 cv=Gt3XaU1C c=1 sm=1 tr=0 ts=6aa8881e cx=c_pps
 a=UObrlqRbTUrrdMEdGJ+KZA==:117 a=UObrlqRbTUrrdMEdGJ+KZA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gQcMVamqm3wCPoSYhaRC:22 a=3haJ9R1Aw3gUfsUHDaCR:22 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=MvuuwTCpAAAA:8 a=Sg6dGvN4MyGzWyVrZPUA:9 a=CjuIK1q_8ugA:10
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_05,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609140340
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CD1A6140007
X-Stat-Signature: h4kb9xeuchw3jy96dz766yh55tc3t1ok
X-HE-Tag: 1789429816-981497
X-HE-Meta: U2FsdGVkX1+LtZ4+gOXWXJdtoFH0Hew+A3iKNYANijtIJ4aYwQly5E7TxrEWG/ZloH7e89atrSYYimmxZNQNXtVLgx3YQPrCnL9pKkr/AqEV/pO7mhq2MAUrgB0XNvKbelMWojvvsml/djOxzFyMVCEnnaW8Q3JIDnOEEtHLSmJKgvhWsgK0qoaMZf/BAw/fUV+lAEWhJHdEgOza55Xsy+aXD6EEae/w/lr8memKbC4ftQUr1GzMBIRpScvE8BDdJFGKoZ0We81PJimTtuaGqurdBWJrZ1/pkbWx2uHCMnSEmQAgBfWHmS1Bmilk3MUGAG3U5SKz+A5annbcv3rf3LeyT14WIGN7SmX69QRwjQjVm8eEo8GbGJiOAMNoiOfXLW9FqK/AiiciGxBoxKXOq+7iEXeq02Qo1jDsnVhJeRfqdqzJIcIH8JPQaBqQuZgDQYxN4kmmQtNLPIJQFlh5pNcBFeUESazE8i/eIh1wjvcAuXJsks1bDG84lcoOqduWzTvX/bqkJ8sZcTi6YJRlAR/bUV8xsHXbF0RywvgtJ0CcnkNEympLsG6HFHYrznx3dmA726kDTFSbwR1jXFtWLoG6tLWq3sxYXr/46G73umbPaK0E9/crB4VdMA21Z3X2I5Yx5laCxGO/p7gnX4YDiBehw7rRySf0FbFFH0JX7XFXfS2grC3fkM6jUYNrdpInrIAH/Jz7raYpTYmujIjSgRcdjG4nxk8RAWaLfLL0Rse9xnsJTG0oxN6fzx/JlkxQj2UFyGSjP3xtrlwUwaDoRVXqDwRjB1e//oXPCBrAky/cHCLXpc/rtGltOQvQvgnE/n0nUQS44JthaxxjUyKHaZWNq1QuqoTFC98ZSc5UMyfFkwaDVIfaBY5vx2sGNejVUV9KVjO5ejLZtHmV9UGSc/iMCQhixuxv0eraVrQp6k+KAdQdwk7J2nYLsNaN6jxNDHaYvzYT2MZg+NjJ3K2
 ivAmPf90
 8y68fgpCVDe9XpOceiAjQQAODfxblCqyhee0lVTHKY8y/D8VSr6k+zmjbQdJCDlqr3WNBgvECiTmcp+rsxes9kPltGKZZ/B4BXk2n3GM3nA6aTRFFEIjZRzcHsmAbwNjER1FFaI0pRCy/K43OqvjNOyD6AST2Bcy7ikIG9gUwCSoKj940zWBCw+ZGNdbiBBz5n4wFn6wIX9uTtkXZ67tzVJzMRgSisVhvH7iwElaiaHDwntBTGBWXCZUR4yVcV72liScaQsisF9Gq7hrTpwfLiQI4rBdDwXJJlF147W6qmqqeRFLhduC/mDDAsx/4YKUUiU5ZSM7R9zkFnmlX20HgYnK7gBeYp54H95a3Nx39bOhysy1NrYCDAbCzdqG6tUmqYO1O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Soft offlining a HugeTLB page dissolves it, permanently reducing the
HugeTLB page pool. This can be problematic for workloads that depend on
a fixed number of HugeTLB pages.

Currently, soft offline must be disabled to prevent HugeTLB pages from
being soft offlined.

This patch allows soft offline to be disabled for HugeTLB pages while
remaining enabled for non-HugeTLB pages.

Commit 56374430c5dfc ("mm/memory-failure: userspace controls
soft-offlining pages") introduced the following sysctl interface to
control soft offline:

/proc/sys/vm/enable_soft_offline

The interface does not distinguish between page types:

    0 - Soft offline is disabled
    1 - Soft offline is enabled

Convert enable_soft_offline to a bitmask and support disabling soft
offline for HugeTLB pages:

Bits:

    0 - Enable soft offline
    1 - Disable soft offline for HugeTLB pages

Supported values:

    0 - Soft offline is disabled
    1 - Soft offline is enabled
    3 - Soft offline is enabled (disabled for HugeTLB pages)

Existing behavior is preserved.

Update documentation and HugeTLB soft offline selftests.

Suggested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
---

Tony's patch:
* https://lore.kernel.org/all/20250904155720.22149-1-tony.luck@intel.com

v1:
* https://lore.kernel.org/all/aMGkAI3zKlVsO0S2@hpe.com

v1 -> v2:
* Make the interface extensible, as suggested by David.
* Preserve existing behavior, as suggested by Jiaqi and David.
* https://lore.kernel.org/all/aMiu_Uku6Y5ZbuhM@hpe.com

v2 -> v3:
* Minor documentation updates.
* Use page_folio(page) instead of pfn_folio(pfn) for HugeTLB page check.

---
 .../ABI/testing/sysfs-memory-page-offline     |  3 +++
 Documentation/admin-guide/sysctl/vm.rst       | 27 +++++++++++++++----
 mm/memory-failure.c                           | 17 +++++++++---
 .../selftests/mm/hugetlb-soft-offline.c       | 19 ++++++++++---
 4 files changed, 54 insertions(+), 12 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-memory-page-offline b/Documentation/ABI/testing/sysfs-memory-page-offline
index 00f4e35f916f..19aa539fb910 100644
--- a/Documentation/ABI/testing/sysfs-memory-page-offline
+++ b/Documentation/ABI/testing/sysfs-memory-page-offline
@@ -20,6 +20,9 @@ Description:
 		number, or a error when the offlining failed.  Reading
 		the file is not allowed.
 
+		Soft-offline can be controlled via sysctl:
+		Documentation/admin-guide/sysctl/vm.rst
+
 What:		/sys/devices/system/memory/hard_offline_page
 Date:		Sep 2009
 KernelVersion:	2.6.33
diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 5b318d17aa4b..ee1941e44643 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -309,16 +309,33 @@ physical memory) vs performance / capacity implications in transparent and
 HugeTLB cases.
 
 For all architectures, enable_soft_offline controls whether to soft offline
-memory pages.  When set to 1, kernel attempts to soft offline the pages
-whenever it thinks needed.  When set to 0, kernel returns EOPNOTSUPP to
-the request to soft offline the pages.  Its default value is 1.
+memory pages.
 
-It is worth mentioning that after setting enable_soft_offline to 0, the
+enable_soft_offline is a bitmask:
+
+Bits::
+
+	0 - Enable soft offline
+	1 - Disable soft offline for HugeTLB pages
+
+Supported values::
+
+	0 - Soft offline is disabled
+	1 - Soft offline is enabled
+	3 - Soft offline is enabled (disabled for HugeTLB pages)
+
+The default value is 1.
+
+If soft offline is disabled for the requested page type, EOPNOTSUPP is returned.
+
+It is worth mentioning that after disabling soft offline, the
 following requests to soft offline pages will not be performed:
 
+- Request to soft offline pages from sysfs.
+
 - Request to soft offline pages from RAS Correctable Errors Collector.
 
-- On ARM, the request to soft offline pages from GHES driver.
+- Request to soft offline pages from GHES driver.
 
 - On PARISC, the request to soft offline pages from Page Deallocation Table.
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a8b03e2920ba..6c4ce39f46df 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -69,11 +69,14 @@
 #include "page_alloc.h"
 #include "internal.h"
 
+#define SOFT_OFFLINE_ENABLED		BIT(0)
+#define SOFT_OFFLINE_SKIP_HUGETLB	BIT(1)
+
 static int sysctl_memory_failure_early_kill __read_mostly;
 
 static int sysctl_memory_failure_recovery __read_mostly = 1;
 
-static int sysctl_enable_soft_offline __read_mostly = 1;
+static int sysctl_enable_soft_offline __read_mostly = SOFT_OFFLINE_ENABLED;
 
 static int sysctl_panic_on_unrecoverable_mf __read_mostly;
 
@@ -157,7 +160,7 @@ static const struct ctl_table memory_failure_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= SYSCTL_THREE,
 	},
 	{
 		.procname	= "panic_on_unrecoverable_memory_failure",
@@ -2982,12 +2985,20 @@ int soft_offline_page(unsigned long pfn, int flags)
 		return -EIO;
 	}
 
-	if (!sysctl_enable_soft_offline) {
+	if (!(sysctl_enable_soft_offline & SOFT_OFFLINE_ENABLED)) {
 		pr_info_once("disabled by /proc/sys/vm/enable_soft_offline\n");
 		put_ref_page(pfn, flags);
 		return -EOPNOTSUPP;
 	}
 
+	if (sysctl_enable_soft_offline & SOFT_OFFLINE_SKIP_HUGETLB) {
+		if (folio_test_hugetlb(page_folio(page))) {
+			pr_info_once("disabled for HugeTLB pages by /proc/sys/vm/enable_soft_offline\n");
+			put_ref_page(pfn, flags);
+			return -EOPNOTSUPP;
+		}
+	}
+
 	mutex_lock(&mf_mutex);
 
 	if (PageHWPoison(page)) {
diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
index bc202e4ed2bd..9837c315a81e 100644
--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
+++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -5,6 +5,8 @@
  *   offlining failed with EOPNOTSUPP.
  * - if enable_soft_offline = 1, a hugepage should be dissolved and
  *   nr_hugepages/free_hugepages should be reduced by 1.
+ * - if enable_soft_offline = 3, HugeTLB pages should stay intact and soft
+ *   offlining failed with EOPNOTSUPP.
  *
  * The test allocates 8 default hugepages
  */
@@ -31,6 +33,9 @@
 
 #define EPREFIX " !!! "
 
+#define SOFT_OFFLINE_ENABLED		(1 << 0)
+#define SOFT_OFFLINE_SKIP_HUGETLB	(1 << 1)
+
 static int do_soft_offline(int fd, size_t len, int expect_errno)
 {
 	char *filemap = NULL;
@@ -55,6 +60,7 @@ static int do_soft_offline(int fd, size_t len, int expect_errno)
 	ksft_print_msg("Allocated %#lx bytes of hugetlb pages\n", len);
 
 	hwp_addr = filemap + len / 2;
+	errno = 0;
 	ret = madvise(hwp_addr, pagesize, MADV_SOFT_OFFLINE);
 	ksft_print_msg("MADV_SOFT_OFFLINE %p ret=%d, errno=%d\n",
 		       hwp_addr, ret, errno);
@@ -82,7 +88,7 @@ static int set_enable_soft_offline(int value)
 	char cmd[256] = {0};
 	FILE *cmdfile = NULL;
 
-	if (value != 0 && value != 1)
+	if (value < 0 || value > 3)
 		return -EINVAL;
 
 	sprintf(cmd, "echo %d > /proc/sys/vm/enable_soft_offline", value);
@@ -128,13 +134,17 @@ static int create_hugetlbfs_file(struct statfs *file_stat)
 static void test_soft_offline_common(int enable_soft_offline)
 {
 	int fd;
-	int expect_errno = enable_soft_offline ? 0 : EOPNOTSUPP;
+	int expect_errno = 0;
 	struct statfs file_stat;
 	unsigned long hugepagesize_kb = 0;
 	unsigned long nr_hugepages_before = 0;
 	unsigned long nr_hugepages_after = 0;
 	int ret;
 
+	if (!(enable_soft_offline & SOFT_OFFLINE_ENABLED) ||
+	    (enable_soft_offline & SOFT_OFFLINE_SKIP_HUGETLB))
+		expect_errno = EOPNOTSUPP;
+
 	ksft_print_msg("Test soft-offline when enabled_soft_offline=%d\n",
 		       enable_soft_offline);
 
@@ -165,7 +175,7 @@ static void test_soft_offline_common(int enable_soft_offline)
 	// No need for the hugetlbfs file from now on.
 	close(fd);
 
-	if (enable_soft_offline) {
+	if (expect_errno == 0) {
 		if (nr_hugepages_before != nr_hugepages_after + 1) {
 			ksft_test_result_fail("MADV_SOFT_OFFLINE should reduced 1 hugepage\n");
 			return;
@@ -190,8 +200,9 @@ int main(int argc, char **argv)
 	if (!hugetlb_setup_default(8))
 		ksft_exit_skip("not enough hugetlb pages\n");
 
-	ksft_set_plan(2);
+	ksft_set_plan(3);
 
+	test_soft_offline_common(3);
 	test_soft_offline_common(1);
 	test_soft_offline_common(0);
 
-- 
2.51.0


