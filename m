Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA769CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 00:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEEA48E000A; Mon, 15 Sep 2025 20:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9EDC8E0001; Mon, 15 Sep 2025 20:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D665E8E000A; Mon, 15 Sep 2025 20:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA5B18E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:28:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4944EC07D9
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:28:53 +0000 (UTC)
X-FDA: 83893228146.14.0512E71
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	by imf09.hostedemail.com (Postfix) with ESMTP id 73053140006
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:28:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b="VXTH Cz8";
	spf=pass (imf09.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757982531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JeQNhzfrN0EKJc5m3B6rgoGZeoNOz02TDwWp+7qV6n4=;
	b=3At6Oe+nBSQeCS6vuVxOjugup2u6xRv0AIcPvXRGfU9ON6y83rIeSgKPrBGlokFoqa7LWS
	uPaAph7zJ0K0J0n0zWR4JgsGd+jI5M9fBaiVmFGii/i1X7+lQJlKPlpQvCyB/f6/sIuBb/
	pic/7xx9WwqJWSi7Wip3qfZpDcM1HA0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b="VXTH Cz8";
	spf=pass (imf09.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com;
	dmarc=pass (policy=reject) header.from=hpe.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757982531; a=rsa-sha256;
	cv=none;
	b=XR8bBaX7QApO9kMPjj218iXrdtQM1RdrTGN+LZti3K1ldQotDhOi/Q/NrzGgQ2MalCtkv5
	z2Zk+n2UudG17s7vEHMaSclo5dS0v5PtrsAtVdl54zmNyVJhZOKhvaDgOMEEKseZey+dPN
	bJa2lS6vdg8YlWzfXJMcwvR2xWoUQmE=
Received: from pps.filterd (m0150245.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FMWfWo005974;
	Tue, 16 Sep 2025 00:28:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:message-id:mime-version:subject:to; s=
	pps0720; bh=JeQNhzfrN0EKJc5m3B6rgoGZeoNOz02TDwWp+7qV6n4=; b=VXTH
	Cz8Wndbr56Z/+TNwqIADM/dW+6vJ9hchmFdGX7n+LBohfMru93AoZ4zEpFgz+7NO
	zUjqy0N7qwPpFQX/iwiZwAIyuvLg4oU+3hmJrTH3EM3FQBGhjNABNLC4PNg2yuG1
	KxIKeNQTb6gKhE+cifdUqCDNVkSpOK4oENebK0mphC9ghfUXx2yNMO7sgDXCWUZA
	C6EKvHCkRImdVUo+wMpNvRdsfr5el7OfAo9SKl+OIFhbpJ65AGIkZ8zouKwCXPh0
	PQ04gEVtmSDcWFGLNQbQsgO7WUVaRqHSpyDteL+QvTcbt0w9Sqktzza6fwNR5gWf
	L7yk63l0re0e09FTAg==
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4951tv0d87-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 00:28:12 +0000 (GMT)
Received: from p1lg14886.dc01.its.hpecorp.net (unknown [10.119.18.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14878.it.hpe.com (Postfix) with ESMTPS id D3CC6130D6;
	Tue, 16 Sep 2025 00:28:08 +0000 (UTC)
Received: from HPE-5CG20646DK.localdomain (unknown [16.231.227.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by p1lg14886.dc01.its.hpecorp.net (Postfix) with ESMTPS id 917DA80FDF1;
	Tue, 16 Sep 2025 00:27:53 +0000 (UTC)
Date: Mon, 15 Sep 2025 19:27:41 -0500
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
Subject: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Message-ID: <aMiu_Uku6Y5ZbuhM@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Authority-Analysis: v=2.4 cv=A4ZsP7WG c=1 sm=1 tr=0 ts=68c8af1c cx=c_pps
 a=UObrlqRbTUrrdMEdGJ+KZA==:117 a=UObrlqRbTUrrdMEdGJ+KZA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=MvuuwTCpAAAA:8 a=OTHRfgTbXkvfc_ALrMIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: bHHao-PP1aUuVyGxBvtgR0XoZ4QQJ_X2
X-Proofpoint-ORIG-GUID: bHHao-PP1aUuVyGxBvtgR0XoZ4QQJ_X2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDA0MCBTYWx0ZWRfX+CKGST4nKMub
 YRJ2fPK6XENK2tsNJk6ATlsHUqmDBGgBm1qFaniRG5lR0YYS/upvUud9ElAsZ5VRtoaZ+14/I/H
 TFm5O0CJgZnN6NjzgHoemXIDpqP7nTBmoHOfxVdNHDd82DmQiRKbuJs++/qrENrSSjYGGAfUVIC
 rq4EUgc6obc8u5hvD+QvxSbDE9IVROn+9TJfYMUain3PO23GbAQ++YoBYmeKIbYQcnmrHVcQOx2
 fWGVTFtu0HmkAYjcgHYSRx5WLtVS2F1uYKXXeaEhu7WSgu3Cc4n1WzGO1b5pdqgIEj1TKDKqU5C
 ZcDF6Ldys1UDiCMf45egb293pBycFm0AyqTvRnA8vtOF1IIbn1Q95VluQiDmXtX7OgKq/2klCit
 TFY065/l
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_09,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 bulkscore=0 adultscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130040
X-Rspamd-Queue-Id: 73053140006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: wzmieepo8i384jbmymaz9mtjbcr1umbg
X-HE-Tag: 1757982526-352445
X-HE-Meta: U2FsdGVkX1/5YdbgYfWjzSATHfuunpBPIFSERIDMMIbiWEg61qdlDKkTVgmgqDX3JpzoGgl6OYWFdfBGINtjqOL2ASxaR/AhnjQIMYuBr7dupH/XqNX18Gpd+ZgShDRqMxYjYhm00dM1VRamnrd4GGkMhGRIa1mb2BZi7yXIjgJTO0UNZlt4n7ZLU9spQdj08TWlzf4d7WuiMq5J7OlDqVY1aRXs58H8TsHWhAHVZ5k7BnxAfS60D8JmbyvCmDJYYD/K3bWMToe5zhmJ6IxKF//U1YFCymwJ1DMUmxU6LxBN+AKXA6KRf4DaEwg9PIefkL7/tNrOKtzq4wtxrhzEX6teppr3oWI+z+tb4FVsqjYPV0KW/r5WDIO7lDtnP0zr++mGYYBomsFTtlInP+EWpGL5S4PWcjBbbFd8GasdKx3mZHTk3HMlelrHY0Q2QeTpHZYXNO2RRhaTHCBzlMsfK49YBqVwG1wqCb3iPL1ZZV2z7FQiO8kJyJFV4HM74tAIyPmIrvsa2TPHthjEm1hAGnIumXqkcnwmxvNcrCaCm/S+WsTC9ipPDOpZA1wokIqcggl1XeCQB5AU2KYI8XcaSXiiaEXS9CHtBb+zh51cIEvllqwiLQryfmaL6OA8cfjWB5w0v0IB0xv/ewop5z5e5J1QX8vdPSuaji4z2SYkwygqKla1F10t5tnuPjpamdKV+eZzNW/tes9HNGta2HwhDcYUeUntvrVdQXiFaZyF3hdyvHD28Opam+B5e6LJADAwvkEHPJtistB/2+JLvNRVbLvKzGo32q5ypi4PIF/7WHt7XV/60YyHKE2tm3bfKOUfg3COzDWqw9fZtBbart+1EhoG42670fJoQKUBqXeownYjG8n6Okxw8NsQa/6hzqraNdkFVA4h0iSaJtxCqEodXiu5XMKmFta1ZL3MVo0roPO7xMcOfNQQL/gd/Nn73mAW+s1iWtBVX47AYV8glB1
 EK/ZDFNc
 fNy8R0Va+BRZMVUN9wx5FImcWtljozR3du8PCmteSpSD23IKmIsudKLyeIsWXM75vTJp4pwL++YGTKdmHbMVLeEGcC3yYWXZSs8tUNHkfTdleHL1gRd2PhCavpkB8qIv7Rtymb0gKUBKHidn5FqlYXFMGm4qCB6OlQtrrw3FFvPsgLFvs4i6AkGfIfSoG7AlmaTo/kTL6jp/7bGS4/qUa1ssPDJN1YuOin7eV3l/7PlQps9c0wPJlUgoRyM0Z5jUgAlz8f6qDAVoyjRO5Xe1IhEIPdzyroLbNOXmvwysCphrmsnPxX6lQIFGPUcLHpiv3cBYHUUNKKus235fQ6bxFAmrwjE4hj0RxiaaDeH8xdPWr9f5VTUoe3/79mA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Soft offlining a HugeTLB page reduces the HugeTLB page pool.

Commit 56374430c5dfc ("mm/memory-failure: userspace controls soft-offlining pages")
introduced the following sysctl interface to control soft offline:

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

Update documentation and HugeTLB soft offline self tests.

Reported-by: Shawn Fan <shawn.fan@intel.com>
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

Why clear errno in self tests?

madvise() does not set errno when it's successful and errno is set by madvise()
during test_soft_offline_common(3) causing test_soft_offline_common(1) to fail:

# Test soft-offline when enabled_soft_offline=1
# Hugepagesize is 1048576kB
# enable_soft_offline => 1
# Before MADV_SOFT_OFFLINE nr_hugepages=7
# Allocated 0x80000000 bytes of hugetlb pages
# MADV_SOFT_OFFLINE 0x7fd600000000 ret=0, errno=95
# MADV_SOFT_OFFLINE should ret 0
# After MADV_SOFT_OFFLINE nr_hugepages=6
not ok 2 Test soft-offline when enabled_soft_offline=1

---
 .../ABI/testing/sysfs-memory-page-offline     |  3 ++
 Documentation/admin-guide/sysctl/vm.rst       | 28 ++++++++++++++++---
 mm/memory-failure.c                           | 17 +++++++++--
 .../selftests/mm/hugetlb-soft-offline.c       | 19 ++++++++++---
 4 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-memory-page-offline b/Documentation/ABI/testing/sysfs-memory-page-offline
index 00f4e35f916f..d3f05ed6605e 100644
--- a/Documentation/ABI/testing/sysfs-memory-page-offline
+++ b/Documentation/ABI/testing/sysfs-memory-page-offline
@@ -20,6 +20,9 @@ Description:
 		number, or a error when the offlining failed.  Reading
 		the file is not allowed.
 
+		Soft-offline can be controlled via sysctl, see:
+		Documentation/admin-guide/sysctl/vm.rst
+
 What:		/sys/devices/system/memory/hard_offline_page
 Date:		Sep 2009
 KernelVersion:	2.6.33
diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 4d71211fdad8..ace73480eb9d 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -309,19 +309,39 @@ physical memory) vs performance / capacity implications in transparent and
 HugeTLB cases.
 
 For all architectures, enable_soft_offline controls whether to soft offline
-memory pages.  When set to 1, kernel attempts to soft offline the pages
-whenever it thinks needed.  When set to 0, kernel returns EOPNOTSUPP to
-the request to soft offline the pages.  Its default value is 1.
+memory pages.
+
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
 
 It is worth mentioning that after setting enable_soft_offline to 0, the
 following requests to soft offline pages will not be performed:
 
+- Request to soft offline from sysfs (soft_offline_page).
+
 - Request to soft offline pages from RAS Correctable Errors Collector.
 
-- On ARM, the request to soft offline pages from GHES driver.
+- On ARM and X86, the request to soft offline pages from GHES driver.
 
 - On PARISC, the request to soft offline pages from Page Deallocation Table.
 
+Note:
+	Soft offlining a HugeTLB page reduces the HugeTLB page pool.
+
 extfrag_threshold
 =================
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index fc30ca4804bf..0ad9ae11d9e8 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -64,11 +64,14 @@
 #include "internal.h"
 #include "ras/ras_event.h"
 
+#define SOFT_OFFLINE_ENABLED		BIT(0)
+#define SOFT_OFFLINE_SKIP_HUGETLB	BIT(1)
+
 static int sysctl_memory_failure_early_kill __read_mostly;
 
 static int sysctl_memory_failure_recovery __read_mostly = 1;
 
-static int sysctl_enable_soft_offline __read_mostly = 1;
+static int sysctl_enable_soft_offline __read_mostly = SOFT_OFFLINE_ENABLED;
 
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
@@ -150,7 +153,7 @@ static const struct ctl_table memory_failure_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= SYSCTL_THREE,
 	}
 };
 
@@ -2799,12 +2802,20 @@ int soft_offline_page(unsigned long pfn, int flags)
 		return -EIO;
 	}
 
-	if (!sysctl_enable_soft_offline) {
+	if (!(sysctl_enable_soft_offline & SOFT_OFFLINE_ENABLED)) {
 		pr_info_once("disabled by /proc/sys/vm/enable_soft_offline\n");
 		put_ref_page(pfn, flags);
 		return -EOPNOTSUPP;
 	}
 
+	if (sysctl_enable_soft_offline & SOFT_OFFLINE_SKIP_HUGETLB) {
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
index f086f0e04756..b87c8778cadf 100644
--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
+++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -5,6 +5,8 @@
  *   offlining failed with EOPNOTSUPP.
  * - if enable_soft_offline = 1, a hugepage should be dissolved and
  *   nr_hugepages/free_hugepages should be reduced by 1.
+ * - if enable_soft_offline = 3, hugepages should stay intact and soft
+ *   offlining failed with EOPNOTSUPP.
  *
  * Before running, make sure more than 2 hugepages of default_hugepagesz
  * are allocated. For example, if /proc/meminfo/Hugepagesize is 2048kB:
@@ -32,6 +34,9 @@
 
 #define EPREFIX " !!! "
 
+#define SOFT_OFFLINE_ENABLED		(1 << 0)
+#define SOFT_OFFLINE_SKIP_HUGETLB	(1 << 1)
+
 static int do_soft_offline(int fd, size_t len, int expect_errno)
 {
 	char *filemap = NULL;
@@ -56,6 +61,7 @@ static int do_soft_offline(int fd, size_t len, int expect_errno)
 	ksft_print_msg("Allocated %#lx bytes of hugetlb pages\n", len);
 
 	hwp_addr = filemap + len / 2;
+	errno = 0;
 	ret = madvise(hwp_addr, pagesize, MADV_SOFT_OFFLINE);
 	ksft_print_msg("MADV_SOFT_OFFLINE %p ret=%d, errno=%d\n",
 		       hwp_addr, ret, errno);
@@ -83,7 +89,7 @@ static int set_enable_soft_offline(int value)
 	char cmd[256] = {0};
 	FILE *cmdfile = NULL;
 
-	if (value != 0 && value != 1)
+	if (value < 0 || value > 3)
 		return -EINVAL;
 
 	sprintf(cmd, "echo %d > /proc/sys/vm/enable_soft_offline", value);
@@ -155,13 +161,17 @@ static int create_hugetlbfs_file(struct statfs *file_stat)
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
+	     (enable_soft_offline & SOFT_OFFLINE_SKIP_HUGETLB))
+		expect_errno = EOPNOTSUPP;
+
 	ksft_print_msg("Test soft-offline when enabled_soft_offline=%d\n",
 		       enable_soft_offline);
 
@@ -198,7 +208,7 @@ static void test_soft_offline_common(int enable_soft_offline)
 	// No need for the hugetlbfs file from now on.
 	close(fd);
 
-	if (enable_soft_offline) {
+	if (expect_errno == 0) {
 		if (nr_hugepages_before != nr_hugepages_after + 1) {
 			ksft_test_result_fail("MADV_SOFT_OFFLINE should reduced 1 hugepage\n");
 			return;
@@ -219,8 +229,9 @@ static void test_soft_offline_common(int enable_soft_offline)
 int main(int argc, char **argv)
 {
 	ksft_print_header();
-	ksft_set_plan(2);
+	ksft_set_plan(3);
 
+	test_soft_offline_common(3);
 	test_soft_offline_common(1);
 	test_soft_offline_common(0);
 
-- 
2.51.0


