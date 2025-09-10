Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13473CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 475A48E0036; Wed, 10 Sep 2025 12:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44D448E0002; Wed, 10 Sep 2025 12:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3627E8E0036; Wed, 10 Sep 2025 12:16:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B0538E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:16:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B77CB140147
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:16:48 +0000 (UTC)
X-FDA: 83873844096.10.0DD13A3
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9C9D0140010
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:16:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=hpe.com header.s=pps0720 header.b="Mf9J i+u";
	spf=pass (imf09.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757521006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=deRTkyES2dLsCA1RpfhzllRYA0poesvFhy/5lcXgJUI=;
	b=b+TXukQaDF6cqCVnBaTihSRYojrJNipn/BLvKfrDUGe9sYCWju5kTVN4jRCNrgmB8x8uz/
	CCcmW1NLQSRdV2KFJ6XxTLXM2DGobDpkFM0AYpWjgq0DEOY+A348QUUB551bw85m9TFtnY
	dJoMkYMXwsxciPsSyx7JEWdfmX1GTiI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757521006; a=rsa-sha256;
	cv=none;
	b=h9uj9Gy9Q459/9MmsSuRt5DcqZG+F5eY9SqN65LjmXiM8gYeRjdA+xSaOJ0GXEubf/Dr7P
	MwMoAthyyl7xeqqltMiAYl56FjmzAbSI/X3VBf+qgma+D83RDTNj/CYc3ogBs2xUg7ZStE
	gah7o1eqUSg6CfvOyrREVmNFFZlLMr4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=temperror ("DNS error when getting key") header.d=hpe.com header.s=pps0720 header.b="Mf9J i+u";
	spf=pass (imf09.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AD2wWH032060;
	Wed, 10 Sep 2025 16:16:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:message-id:mime-version:subject:to; s=
	pps0720; bh=deRTkyES2dLsCA1RpfhzllRYA0poesvFhy/5lcXgJUI=; b=Mf9J
	i+uKOdk2RrkZoW1x9ziX2I13/gxX+blB0dPG2G8/morCpl+JIfBv8j8rOloT+a9K
	22roZheiEUDbrYuxbpuLIiuZ/Spvpse2K7Qo5w2/ikDyljLpE7iEsnj4lC142sUY
	2sWVKI+t/qX/XnTFmG7vQK9PdwW+c7I+/VdY9kZK4wvqfoa6J5Yg5DgAJ1ygLvn+
	rnftoZwvsObzVjdnJSd5tkwHWvV02K8bj5E60xHqjLUurryf0HMxS5ETBOWJ0kzJ
	L5bFCvkYw5ZtxUs7bBAUzkagCJ3aGrUcMPLFWQvJNX6JxlIQdELReT8RB+qjjPIg
	fxd4Lpc3A1EVcDP7CQ==
Received: from p1lg14878.it.hpe.com ([16.230.97.204])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4939d1hygn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 16:16:01 +0000 (GMT)
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14878.it.hpe.com (Postfix) with ESMTPS id 0557D130DC;
	Wed, 10 Sep 2025 16:15:58 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTPS id 5B49580CCD6;
	Wed, 10 Sep 2025 16:15:56 +0000 (UTC)
Date: Wed, 10 Sep 2025 11:15:54 -0500
From: Kyle Meyer <kyle.meyer@hpe.com>
To: akpm@linux-foundation.org, corbet@lwn.net, david@redhat.com,
        linmiaohe@huawei.com, shuah@kernel.org, tony.luck@intel.com
Cc: Liam.Howlett@oracle.com, bp@alien8.de, hannes@cmpxchg.org, jack@suse.cz,
        jane.chu@oracle.com, jiaqiyan@google.com, joel.granados@kernel.org,
        kyle.meyer@hpe.com, laoar.shao@gmail.com, lorenzo.stoakes@oracle.com,
        mclapinski@google.com, mhocko@suse.com, nao.horiguchi@gmail.com,
        osalvador@suse.de, rafael.j.wysocki@intel.com, rppt@kernel.org,
        russ.anderson@hpe.com, shawn.fan@intel.com, surenb@google.com,
        vbabka@suse.cz, linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] mm/memory-failure: Disable soft offline for HugeTLB pages by
 default
Message-ID: <aMGkAI3zKlVsO0S2@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-GUID: kqIpDWE2DAQUz9T13ajLU0ZtpoqC-0MS
X-Authority-Analysis: v=2.4 cv=BYfY0qt2 c=1 sm=1 tr=0 ts=68c1a441 cx=c_pps
 a=UObrlqRbTUrrdMEdGJ+KZA==:117 a=UObrlqRbTUrrdMEdGJ+KZA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=MvuuwTCpAAAA:8 a=2-6KEjCLdOzKJHZFeg0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEwMDExNSBTYWx0ZWRfXyMed/oh4zI0A
 zRZHpa9vgSdSo26PmP7rwF3/kqBMgtDUfgdff2eIvZ4fP2AKZKQcKu0IyMMzHN6I1K/8rPc+7sF
 KGFRvGgBFkWUQmuioxZhsVH6NYnzeTnb1d7pUtwLXtEDJ32Xr+puBkrL1DdGLMrlgCVOIrZwa0I
 Uo9zzUKhsBJD6/cuVlJMLaME0TWtRvHlwN6G3G16EB9xfMwf8GpfDDn3UammV7d8qMc5VkdVcb7
 G7GWYw9ulMrJf1FfFQJHQDGBFIMPy25n7RhR9keciIKhmASdzlf/FW+WFHse44tyM4AWtBIeN9l
 IUYILDNnt2CaAokpMCa3dV6zIk9ncF0Ijc/1u/I7SBf7WfnV98tEPmzY+ntov9FLtR/kX7mQd4X
 4jksBjJ0
X-Proofpoint-ORIG-GUID: kqIpDWE2DAQUz9T13ajLU0ZtpoqC-0MS
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 clxscore=1011 phishscore=0 impostorscore=0 spamscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509100115
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9C9D0140010
X-Stat-Signature: rd6c3gp8jwik4o54imkc5bctngcjxps6
X-Rspam-User: 
X-HE-Tag: 1757521001-627313
X-HE-Meta: U2FsdGVkX19booimdYKqdwf6kvDEVqh23AbLJMqpghusTJZ9xW02WSAM844XMI/dEJF9DmJCPUWU6IQplSEAVmmH/D0FK4EIrLB9l6CcP3A9o9hWYPUKzEDXEj3PHWdMjN+0zPGTMU52EFGzGK7pZCZpSHhzAOP1hwURNSGrek1zsECddWerpDO2qITjIBVRDRK6EZib4UzxHOxodAEl0RAGCxfe/urOzEue92yrcpUp0R6c5o2UbXJMJ1HkCVthGZ/UAn00TsN14OAnDAhRhKth1gyqYT+BxbANbwRIHw8G0Fn/zcUj88uDTDcw3zORE+tDPz3pmhErZncWTpXLdyeno07XVIeka3LKt03gyJ37A5/OlGPHsZhGEUABzs9x0iMf5klb9RqSsj5XYfDIisaNVzEdW+dOl+W4XKeJ8CoUlASWhdEY7g0uU+dodfPszCEwioFuIFDJ74PCKVwz9OnLTHCd9EkLazz1eVCODr3DAc3hYQms9uUR3U2P/yJNfUvQk2vTNAlVOxXtu50rHPcQkvxIwP9PiKHsZymwyKY8aFYSO0hZi4OwLi8DLG6SMOrz1bmz/3YGoZU0qyfJJvotQ+MZs3+SSaw2qKW4IZxX0wkp0RG5m0gDQuyjqH1Ai8mUWS7URdK4vCH6tqz1MBKtSXXlNy4Ct4jKugJ8oawLOYn+Q7tpZ3nypcDMUEhqOrU127Tkpk2fUwEgkUhRt0hZlXHmsezJbcEyRurjevMhrxjswNom+shQe8G9OSKWoHUPpUNJJO9wVf2wjlmmFBubxAyh8X1szWN2y/UB4Q8m01Lpmrm2Vc87ftTSz8M0Vn32cGeSMdga/IrCqP3KZMcYuX72XMXoGIRWb3OMQtyXAoB4GVtuZxmEpztCEdyeArHtK1Ko8FAgVCXdA1OAapz9maTlANXZwO29AdpWmvg5YJUQJMfxwF3Afs+rl//3zStw0DF4jT6rVNnyaNb
 TmswwAP0
 /rLNLWusIqEVGbsCs6ea8i1gwybEPySfRLskEc+IxLB9rKx1ZtYfaKxDqbisF222Hq9Es88sh9BICQ0v5fJBLpRlF7D4NNzH82xhltqWlfqJ5qLhq/Rt+VOqIOz2bkdtg1ue/yi9jdEb9GESypbvRsmFV6XpJVs7Sb/btuEcZ5BVDZWFoYLQ4gdl7FSG1NJ5IPGIxDB0puQIypVeB2Wh/Wlx7Gm+M84xSJR/dPR5eGVxgBOiitsZiOTiJqfWQgLp6XUZv5tX3HdK5i/EIXyRzN38PWj+dFKDndazi26aTWjq/xU3mQkHKYrZ1e5tqtOVYpgFL43j+faD98/NdE9jyIQSf96YqDr+cXbqLvLFmtdpeQmE2CJ+RrghKFy2MryWO6Gv/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Soft offlining a HugeTLB page reduces the available HugeTLB page pool.
Since HugeTLB pages are preallocated, reducing the available HugeTLB
page pool can cause allocation failures.

/proc/sys/vm/enable_soft_offline provides a sysctl interface to
disable/enable soft offline:

0 - Soft offline is disabled.
1 - Soft offline is enabled.

The current sysctl interface does not distinguish between HugeTLB pages
and other page types.

Disable soft offline for HugeTLB pages by default (1) and extend the
sysctl interface to preserve existing behavior (2):

0 - Soft offline is disabled.
1 - Soft offline is enabled (excluding HugeTLB pages).
2 - Soft offline is enabled (including HugeTLB pages).

Update documentation for the sysctl interface, reference the sysctl
interface in the sysfs ABI documentation, and update HugeTLB soft
offline selftests.

Reported-by: Shawn Fan <shawn.fan@intel.com>
Suggested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
---

Tony's original patch disabled soft offline for HugeTLB pages when
a correctable memory error reported via GHES (with "error threshold
exceeded" set) happened to be on a HugeTLB page:

https://lore.kernel.org/all/20250904155720.22149-1-tony.luck@intel.com

This patch disables soft offline for HugeTLB pages by default
(not just from GHES).

---
 .../ABI/testing/sysfs-memory-page-offline     |  6 ++++
 Documentation/admin-guide/sysctl/vm.rst       | 18 ++++++++---
 mm/memory-failure.c                           | 21 ++++++++++--
 .../selftests/mm/hugetlb-soft-offline.c       | 32 +++++++++++++------
 4 files changed, 60 insertions(+), 17 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-memory-page-offline b/Documentation/ABI/testing/sysfs-memory-page-offline
index 00f4e35f916f..befb89ae39ec 100644
--- a/Documentation/ABI/testing/sysfs-memory-page-offline
+++ b/Documentation/ABI/testing/sysfs-memory-page-offline
@@ -20,6 +20,12 @@ Description:
 		number, or a error when the offlining failed.  Reading
 		the file is not allowed.
 
+		Soft-offline can be disabled/enabled via sysctl:
+		/proc/sys/vm/enable_soft_offline
+
+		For details, see:
+		Documentation/admin-guide/sysctl/vm.rst
+
 What:		/sys/devices/system/memory/hard_offline_page
 Date:		Sep 2009
 KernelVersion:	2.6.33
diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 4d71211fdad8..ae56372bd604 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -309,19 +309,29 @@ physical memory) vs performance / capacity implications in transparent and
 HugeTLB cases.
 
 For all architectures, enable_soft_offline controls whether to soft offline
-memory pages.  When set to 1, kernel attempts to soft offline the pages
-whenever it thinks needed.  When set to 0, kernel returns EOPNOTSUPP to
-the request to soft offline the pages.  Its default value is 1.
+memory pages:
+
+- 0: Soft offline is disabled.
+- 1: Soft offline is enabled (excluding HugeTLB pages).
+- 2: Soft offline is enabled (including HugeTLB pages).
+
+The default is 1.
+
+If soft offline is disabled for the requested page type, EOPNOTSUPP is returned.
 
 It is worth mentioning that after setting enable_soft_offline to 0, the
 following requests to soft offline pages will not be performed:
 
+- Request to soft offline from sysfs (soft_offline_page).
+
 - Request to soft offline pages from RAS Correctable Errors Collector.
 
-- On ARM, the request to soft offline pages from GHES driver.
+- On ARM and X86, the request to soft offline pages from GHES driver.
 
 - On PARISC, the request to soft offline pages from Page Deallocation Table.
 
+Note: Soft offlining a HugeTLB page reduces the HugeTLB page pool.
+
 extfrag_threshold
 =================
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index fc30ca4804bf..cb59a99b48c5 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -64,11 +64,18 @@
 #include "internal.h"
 #include "ras/ras_event.h"
 
+enum soft_offline {
+	SOFT_OFFLINE_DISABLED = 0,
+	SOFT_OFFLINE_ENABLED_SKIP_HUGETLB,
+	SOFT_OFFLINE_ENABLED
+};
+
 static int sysctl_memory_failure_early_kill __read_mostly;
 
 static int sysctl_memory_failure_recovery __read_mostly = 1;
 
-static int sysctl_enable_soft_offline __read_mostly = 1;
+static int sysctl_enable_soft_offline __read_mostly =
+	SOFT_OFFLINE_ENABLED_SKIP_HUGETLB;
 
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
@@ -150,7 +157,7 @@ static const struct ctl_table memory_failure_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= SYSCTL_TWO,
 	}
 };
 
@@ -2799,12 +2806,20 @@ int soft_offline_page(unsigned long pfn, int flags)
 		return -EIO;
 	}
 
-	if (!sysctl_enable_soft_offline) {
+	if (sysctl_enable_soft_offline == SOFT_OFFLINE_DISABLED) {
 		pr_info_once("disabled by /proc/sys/vm/enable_soft_offline\n");
 		put_ref_page(pfn, flags);
 		return -EOPNOTSUPP;
 	}
 
+	if (sysctl_enable_soft_offline == SOFT_OFFLINE_ENABLED_SKIP_HUGETLB) {
+		if (folio_test_hugetlb(pfn_folio(pfn))) {
+			pr_info_once("disabled for HugeTLB pages by /proc/sys/vm/enable_soft_offline\n");
+			put_ref_page(pfn, flags);
+			return -EOPNOTSUPP;
+		}
+	}
+
 	mutex_lock(&mf_mutex);
 
 	if (PageHWPoison(page)) {
diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
index f086f0e04756..7e2873cd0a6d 100644
--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
+++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -1,10 +1,15 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Test soft offline behavior for HugeTLB pages:
- * - if enable_soft_offline = 0, hugepages should stay intact and soft
- *   offlining failed with EOPNOTSUPP.
- * - if enable_soft_offline = 1, a hugepage should be dissolved and
- *   nr_hugepages/free_hugepages should be reduced by 1.
+ *
+ * - if enable_soft_offline = 0 (SOFT_OFFLINE_DISABLED), HugeTLB pages
+ *   should stay intact and soft offlining failed with EOPNOTSUPP.
+ *
+ * - if enable_soft_offline = 1 (SOFT_OFFLINE_ENABLED_SKIP_HUGETLB), HugeTLB pages
+ *   should stay intact and soft offlining failed with EOPNOTSUPP.
+ *
+ * - if enable_soft_offline = 2 (SOFT_OFFLINE_ENABLED), a HugeTLB page should be
+ *   dissolved and nr_hugepages/free_hugepages should be reduced by 1.
  *
  * Before running, make sure more than 2 hugepages of default_hugepagesz
  * are allocated. For example, if /proc/meminfo/Hugepagesize is 2048kB:
@@ -32,6 +37,12 @@
 
 #define EPREFIX " !!! "
 
+enum soft_offline {
+	SOFT_OFFLINE_DISABLED = 0,
+	SOFT_OFFLINE_ENABLED_SKIP_HUGETLB,
+	SOFT_OFFLINE_ENABLED
+};
+
 static int do_soft_offline(int fd, size_t len, int expect_errno)
 {
 	char *filemap = NULL;
@@ -83,7 +94,7 @@ static int set_enable_soft_offline(int value)
 	char cmd[256] = {0};
 	FILE *cmdfile = NULL;
 
-	if (value != 0 && value != 1)
+	if (value < SOFT_OFFLINE_DISABLED || value > SOFT_OFFLINE_ENABLED)
 		return -EINVAL;
 
 	sprintf(cmd, "echo %d > /proc/sys/vm/enable_soft_offline", value);
@@ -155,7 +166,7 @@ static int create_hugetlbfs_file(struct statfs *file_stat)
 static void test_soft_offline_common(int enable_soft_offline)
 {
 	int fd;
-	int expect_errno = enable_soft_offline ? 0 : EOPNOTSUPP;
+	int expect_errno = (enable_soft_offline == SOFT_OFFLINE_ENABLED) ? 0 : EOPNOTSUPP;
 	struct statfs file_stat;
 	unsigned long hugepagesize_kb = 0;
 	unsigned long nr_hugepages_before = 0;
@@ -198,7 +209,7 @@ static void test_soft_offline_common(int enable_soft_offline)
 	// No need for the hugetlbfs file from now on.
 	close(fd);
 
-	if (enable_soft_offline) {
+	if (enable_soft_offline == SOFT_OFFLINE_ENABLED) {
 		if (nr_hugepages_before != nr_hugepages_after + 1) {
 			ksft_test_result_fail("MADV_SOFT_OFFLINE should reduced 1 hugepage\n");
 			return;
@@ -219,10 +230,11 @@ static void test_soft_offline_common(int enable_soft_offline)
 int main(int argc, char **argv)
 {
 	ksft_print_header();
-	ksft_set_plan(2);
+	ksft_set_plan(3);
 
-	test_soft_offline_common(1);
-	test_soft_offline_common(0);
+	test_soft_offline_common(SOFT_OFFLINE_ENABLED);
+	test_soft_offline_common(SOFT_OFFLINE_ENABLED_SKIP_HUGETLB);
+	test_soft_offline_common(SOFT_OFFLINE_DISABLED);
 
 	ksft_finished();
 }
-- 
2.51.0


