Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17961606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=GiKX1+Rj
Received: by kanga.kvack.org (Postfix)
	id 1023A6B05CE; Sat, 14 Nov 2026 09:53:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08C4D6B05CF; Sat, 14 Nov 2026 09:53:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBD796B05D1; Sat, 14 Nov 2026 09:53:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2C0E6B05CE
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:53:39 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 595E3C044C
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:53:39 +0000 (UTC)
X-FDA: 85434018558.16.EB9A64E
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1FEA240005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:53:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=GiKX1+Rj;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf11.hostedemail.com: domain of "prvs=7716eb193=graf@amazon.de" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=7716eb193=graf@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794668017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DUkCkLrBCsDmb/zGP0NU7kzHyOa32ewTN2QVFQyAKM8=;
	b=ssg0RLrZy/dRqGMzG+gnHR62/4Ow6q2YktvByNDngUhGSkk6zC2vG2ULZowoGFFQYWEt1w
	ELi4KRJTT3NJdFz8bOJ1t9f1gzZl/j5bjembsyasGcbtPftSmzbS+u36lVKruQm9bKtZGt
	fVfLoGKImPYNdG+3lZOiz3D2w4yzMTw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794668017;
	b=LtrXk0B/t1Q6ItQa9xkyn42pe3mtQsT7QMWePV1oCY29EwYSMK2t13RcHq9+YVdy5V047F
	U2Iq8OSyY0WSLsRpz7l8E/dLT/FnZlJGFlGctKlN0Srog84CTfSoCnQCeHCDeWGYwW9Uyd
	BRHD4nNAJ1qhR/FSqqsUoD4+ecyrAYI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=GiKX1+Rj;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf11.hostedemail.com: domain of "prvs=7716eb193=graf@amazon.de" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=7716eb193=graf@amazon.de"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794668017; x=1826204017;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DUkCkLrBCsDmb/zGP0NU7kzHyOa32ewTN2QVFQyAKM8=;
  b=GiKX1+Rjw201GzflDAGhgC3slcj2lF9Rj+oXCrkcqYha8QICNgy7thfq
   uns4PfkyzUZqPTPjjuRpWd1Rrt7XnzG1YXmdHopdsYRIr9gZDMmWoUKIS
   LpPwBEkDn2RD+6wJpG3JbWB+UErkaG4Hdp9dV3O5Wk3+rBZ4DeUj9BtK3
   B+2wmF+aivvuRLaSPE2K4yd46NTbdvpcApUnTQDPXJtA38OufeNezp8d+
   /CexwWqWWxZN86iLymB5UX/MKSOTQrMybu3RRCKi95uWTGEq3BUCW5BQ5
   g0/7Ei8g0KdlxgGk62TxOanzEQaNajYGTDyTm67btbCn4v54sWIE8SEkL
   A==;
X-CSE-ConnectionGUID: aXgLchuGQbWRwMiJ4x8l6A==
X-CSE-MsgGUID: WWPIB+CaTTa+sG9gJDBplg==
X-IronPort-AV: E=Sophos;i="6.27,213,1787011200"; 
   d="scan'208";a="33813177"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2026 14:53:33 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:9277]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.24.250:2525] with esmtp (Farcaster)
 id 77f70d93-d9c9-4764-8233-67658989107b; Sat, 14 Nov 2026 14:53:33 +0000 (UTC)
X-Farcaster-Flow-ID: 77f70d93-d9c9-4764-8233-67658989107b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Sat, 14 Nov 2026 14:53:32 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Sat, 14 Nov 2026 14:53:30 +0000
From: Alexander Graf <graf@amazon.com>
To: <linux-kernel@vger.kernel.org>, Marek Szyprowski
	<m.szyprowski@samsung.com>
CC: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	<linux-doc@vger.kernel.org>, <iommu@lists.linux.dev>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, <nh-open-source@amazon.com>,
	<linux-mm@kvack.org>, The AWS Nitro Enclaves Team
	<aws-nitro-enclaves-devel@amazon.com>
Subject: [PATCH v2] dma-contiguous: support percentage sizes in cma_pernuma= and numa_cma=
Date: Sat, 14 Nov 2026 14:53:28 +0000
Message-ID: <20261114145328.1307-1-graf@amazon.com>
X-Mailer: git-send-email 2.47.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: 4z8do3m7c68nrfoypd86rkyg149mg1jb
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1FEA240005
X-HE-Tag: 1794668016-911140
X-HE-Meta: U2FsdGVkX183LPRSxva+gSO21wjYMmVHSJpBlF60LdoXmr48hUhJMuPjl1n/8Lv5qthIPmJqT1TLQYWygGBecdIMkqjkJeMoOaPbu7tl8zUJztr5aeX8ybhz3aFeOnm7EV+qvbVTLa27l3QGtvnVrZhvPtcjdsMDZPEBwrUslkwgYjbmYI7ZK7cwetKHOiv8WilTBX51tkff0GY1aZGljBvD3PQ/HeMIq5jYRCL3dDn9ZXhkFPGSUmZ5JGw/Li4d70ti/tWVG3cyeZv8MbUkJHMW0VoHhvUMj1NvqeD6iw4MFkOmM6CmsA+ZN374sh1xMs9WpjI8Di59JVMi3xWCQdvZexEfb+7alX0iuG+vsQkF8tb5Opp+pTySIuiusj+JO0Jxo+20EN1jpWoiHac+2XSBtwguVUIlv+SM309ywhrv3hMQjwrKmUtg24Rlpq0/VmKwmHr0oMzfkUFoyRcUTX3EMWg+vYCZlwLai5/m8gIfEmL8cz0XcOkvdFwBkR4GCXEBDegdf9Q+JHJHiJ5SMJU0ftLkijvkeZ5JvBHJBg+oOLS6BfJFodSwXjrG95OMMt2xJoOvlULYjR55AmbHmN+9pj9uoEnRw4qF+dsJUI//8kbN3JBwOxXp/eCJwMByUhcgCtd9U5hkW0ZCTnsAZKw+Yr1NwAEKP5a4wwQuixOfnzMD0RCF1GS1Bv1lt5rGKpauuIKYdSdxu5sLYAxE+lFvz/GDGNjJW6YQQILG6nm+9SYXP97Z7183h+3jtBG5UGl7FM2WFoPi4o2cFPtKUqZYPWeSIr3ymr7Jb1qqRDBRHeedNke7S8NlB5mtqC2jJ3rH8+0Hi/T7zDylilkdVnHV366sZEhkAy1KFiNavLC65x4eavAaoSEhtuMB9SCHFDBEtVZH4J9EYccyX9qVfUDsNWEEQI0WZIefselE1x1qjh1WjxLNs4FsmjuXT74Ap2KLzsQIxnCyTu7x/wl
 mfCd/5lr
 WeyQu1yuuTssMKjxpJQPAF7uBhxk7EtJtasVNlEtkG0BhUVlzzMj5TFSgOl4149Zu9G/JoX0RQsdmV3yhCjhNCtUE/hb9CCBtG6etiU1fnA0ToMEsPyS5NGj/BHPmTnZgtglmsJTXjp+w9Ur+z1tS2jQb0Bu/5ieauSW33HSvnuG/0tvzptj+CnjNQUhkmnGvws6jDu6lOZ9HATQGNLhaqfL5gcpgf0d2xEqN8RnowXwLpOrMHZkPZaSbtN8xs2G9od9ZmV60pgl9lG8VPeQ1zFYK2O1JXfNCJqfn8E0oA/tVCud0eXu3jt9mfqjay0XhQqP11NUJ2N5eLEmYFM4oBfH69Z+OikgPGLHTm4B3DQ/eWbACOFhfg83vlWv2LGChvHZ7xqY+igr3AIkwVwgLXbIZOb260kOwXdI4PZc6MU2kD4Ont2sVe1C9tLCF5eWw/JxlJPFhmWDXAbyrMATchRBf9zCH0A2KrKczLUhkZ0GBTHvkzHdGPiw/newVl5d/z0CN9Y66ejbVeXewkMVtIGVR1GmeAscGlY0UVLqHP5EEEc5SQzfiDMP91Q769NKIemYMHeea95RrDA71DYNTS1rMFiur3PvdkFQgD6gqAqv3/8PF27rTt/BfUL5hIptZcxCyjRJxR+o/3D4L18DENTM/daMkEULzp/2194VgSLD/tBB4aog8D3ZO8kd3bp1WWQ2pKP0IkoGbwy8AWffR+WVdhHVbz2SDg3/e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

While CMA_SIZE_PERCENTAGE supports percentages for built-in defaults, the
CMA allocation kernel parameters currently only take a fixed size argument.
That makes it difficult to have a single system image that sizes its CMA
allocation based on the available memory. To use CMA as backing pool for
large, physically contiguous guest memory, I want to be able to say
"allocate 90% of system RAM minus 1 GiB for CMA". Per NUMA node.

Extend the CMA parser logic to accept command line options like this:

  cma_pernuma=80% numa_cma=0:95%-1G,1:4G

To avoid incomplete allocations on parsing errors, check for them
before actually allocating.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
v1 -> v2:

  - Reject an empty numa_cma= and a trailing comma (Sashiko)
  - Keep the last valid size for each option or node, so an explicit 0
    now overrides a percentage (Sashiko)
  - Parse percentages as plain decimal, and reject sizes that a 32-bit
    phys_addr_t cannot hold
  - Reject a bare cma_pernuma or numa_cma without "=", which mainline
    dereferences as NULL
  - Rework the kernel-parameters.txt text accordingly

v1: https://lore.kernel.org/all/20261111140440.43024-1-graf@amazon.com/

---
 .../admin-guide/kernel-parameters.txt         |  37 +++-
 kernel/dma/contiguous.c                       | 188 +++++++++++++++---
 2 files changed, 194 insertions(+), 31 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd94..d132b14ba4f73 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -862,10 +862,13 @@ Kernel parameters
 			contiguous memory allocations and optionally the
 			placement constraint by the physical address range of
 			memory allocations. A value of 0 disables CMA
-			altogether. For more information, see
+			altogether. The size is absolute; only 'cma_pernuma='
+			and 'numa_cma=' accept a percentage. Without 'cma=',
+			CONFIG_CMA_SIZE_PERCENTAGE can size this area as a
+			fraction of memory. For more information, see
 			kernel/dma/contiguous.c
 
-	cma_pernuma=nn[MG]
+	cma_pernuma=nn[MG]|nn%[-nn[MG]]
 			[KNL,CMA,EARLY]
 			Sets the size of kernel per-numa memory area for
 			contiguous memory allocations. A value of 0 disables
@@ -875,14 +878,34 @@ Kernel parameters
 			first try to allocate buffer from the pernuma area
 			which is located in node nid, if the allocation fails,
 			they will fallback to the global default memory area.
-
-	numa_cma=<node>:nn[MG][,<node>:nn[MG]]
+			The size may also be a decimal percentage of each
+			node's memory as memblock sees it at boot, optionally
+			less a size to keep back, so cma_pernuma=95%-1G
+			reserves 95% of each node minus 1G. Hot-added memory is
+			not counted. A nonzero percentage that leaves nothing
+			to reserve on a node warns and reserves nothing there.
+			If the option is given more than once, the last valid
+			value counts. An invalid value is ignored, and it still
+			stops CONFIG_CMA_SIZE_PERNUMA from mirroring the
+			default area onto every node.
+
+	numa_cma=<node>:nn[MG]|nn%[-nn[MG]][,<node>:nn[MG]|nn%[-nn[MG]]]
 			[KNL,CMA,EARLY]
 			Sets the size of kernel numa memory area for
 			contiguous memory allocations. It will reserve CMA
-			area for the specified node.
-
-			If it is setup together with upper 'cmd_pernuma='
+			area for the specified node. A size may also be a
+			percentage of that node's memory, optionally less a
+			size to keep back, as for 'cma_pernuma='. A size of 0
+			or 0% is the same as not naming the node, so it falls
+			back to 'cma_pernuma='. A nonzero percentage that
+			leaves nothing to reserve does not fall back. If a node
+			is named more than once, also across several numa_cma=
+			options, the last valid size counts. An entry that does
+			not parse, including an empty list or a trailing comma,
+			makes the kernel ignore that whole option, and the
+			default area is not mirrored either.
+
+			If it is set up together with upper 'cma_pernuma='
 			(unlikely), its size setting takes priority for the
 			specified numa nodes.
 
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 90937dc7c627d..ea094d2238136 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -39,8 +39,10 @@
 
 #include <asm/page.h>
 
+#include <linux/ctype.h>
 #include <linux/memblock.h>
 #include <linux/err.h>
+#include <linux/math64.h>
 #include <linux/sizes.h>
 #include <linux/dma-map-ops.h>
 #include <linux/cma.h>
@@ -135,45 +137,135 @@ EXPORT_SYMBOL_GPL(dev_get_cma_area);
 static struct cma *dma_contiguous_numa_area[MAX_NUMNODES];
 static phys_addr_t numa_cma_size[MAX_NUMNODES] __initdata;
 static phys_addr_t pernuma_size_bytes __initdata;
+static unsigned int numa_cma_pct[MAX_NUMNODES] __initdata;
+static unsigned int pernuma_pct __initdata;
+static phys_addr_t numa_cma_sub[MAX_NUMNODES] __initdata;
+static phys_addr_t pernuma_sub __initdata;
 static bool numa_cma_configured __initdata;
 
-static int __init early_numa_cma(char *p)
+/*
+ * What numa_cma_parse() does with a string it accepts: NUMA_CMA_CHECK leaves
+ * everything outside the function as it is, so a caller can validate the
+ * whole string before NUMA_CMA_APPLY lets any part of it take effect.
+ */
+enum numa_cma_action {
+	NUMA_CMA_CHECK,
+	NUMA_CMA_APPLY,
+};
+
+/*
+ * Parse one CMA size, either a size or <percent>%[-<size>], and advance *s past
+ * it. A percentage is a plain decimal number up to 100. Exactly one of *size and
+ * *pct describes the result, so the last size given replaces any earlier one.
+ */
+static int __init numa_cma_parse_size(char **s, phys_addr_t *size,
+				      unsigned int *pct, phys_addr_t *sub)
+{
+	unsigned long long val;
+	unsigned int n;
+	char *start = *s;
+	int count;
+
+	if (isdigit(*start) && sscanf(start, "%3u%n", &n, &count) == 1 &&
+	    start[count] == '%') {
+		if (n > 100)
+			return -EINVAL;
+		*s = start + count + 1;
+		val = 0;
+		if (**s == '-') {
+			start = ++*s;
+			val = memparse(start, s);
+			if (*s == start || val != (phys_addr_t)val)
+				return -EINVAL;
+		}
+		*size = 0;
+		*pct = n;
+		*sub = val;
+		return 0;
+	}
+
+	val = memparse(start, s);
+	if (*s == start || val != (phys_addr_t)val)
+		return -EINVAL;
+	*size = val;
+	*pct = 0;
+	*sub = 0;
+	return 0;
+}
+
+/*
+ * Parse one numa_cma= string: a comma separated list of <node>:<size>, where
+ * <size> is a size or <percent>%[-<size>]. Anything else fails the parse.
+ */
+static int __init numa_cma_parse(char *p, enum numa_cma_action action)
 {
 	int nid, count = 0;
 	unsigned long node;
-	phys_addr_t size;
+	phys_addr_t size, sub;
+	unsigned int pct;
 	char *s = p;
 
-	while (*s) {
-		if (sscanf(s, "%lu%n", &node, &count) != 1)
-			break;
-
-		if (s[count] == ':') {
-			if (node >= MAX_NUMNODES)
-				break;
-			nid = array_index_nospec(node, MAX_NUMNODES);
-
-			s += count + 1;
-			size = memparse(s, &s);
+	for (;;) {
+		if (!isdigit(*s) ||
+		    sscanf(s, "%4lu%n", &node, &count) != 1 || s[count] != ':' ||
+		    node >= MAX_NUMNODES)
+			return -EINVAL;
+		nid = array_index_nospec(node, MAX_NUMNODES);
+
+		s += count + 1;
+		if (numa_cma_parse_size(&s, &size, &pct, &sub))
+			return -EINVAL;
+		if (action == NUMA_CMA_APPLY) {
 			numa_cma_size[nid] = size;
+			numa_cma_pct[nid] = pct;
+			numa_cma_sub[nid] = sub;
+		}
 
-			if (*s == ',')
-				s++;
-			else
-				break;
-		} else
-			break;
+		if (!*s)
+			return 0;
+		if (*s != ',')
+			return -EINVAL;
+		s++;
 	}
+}
 
+static int __init early_numa_cma(char *p)
+{
+	int rc;
+
+	/*
+	 * Per-node CMA is configured either way. Leaving the flag clear on a
+	 * string this rejects would tell dma_numa_cma_reserve() that nobody
+	 * asked for per-node areas, and on a CMA_SIZE_PERNUMA kernel it would
+	 * then clone the default area onto every node.
+	 */
 	numa_cma_configured = true;
-	return 0;
+
+	if (!p)
+		return -EINVAL;
+
+	rc = numa_cma_parse(p, NUMA_CMA_CHECK);
+	if (rc)
+		return rc;
+
+	return numa_cma_parse(p, NUMA_CMA_APPLY);
 }
 early_param("numa_cma", early_numa_cma);
 
 static int __init early_cma_pernuma(char *p)
 {
-	pernuma_size_bytes = memparse(p, &p);
+	phys_addr_t size, sub;
+	unsigned int pct;
+
+	/* See early_numa_cma(): a rejected string still counts as configured. */
 	numa_cma_configured = true;
+
+	if (!p || numa_cma_parse_size(&p, &size, &pct, &sub) || *p)
+		return -EINVAL;
+
+	pernuma_size_bytes = size;
+	pernuma_pct = pct;
+	pernuma_sub = sub;
 	return 0;
 }
 early_param("cma_pernuma", early_cma_pernuma);
@@ -198,6 +290,33 @@ static inline __maybe_unused phys_addr_t cma_early_percent_memory(void)
 #endif
 
 #ifdef CONFIG_DMA_NUMA_CMA
+static phys_addr_t __init numa_cma_node_size(int nid)
+{
+	unsigned long spfn, epfn;
+	phys_addr_t total = 0;
+	int i;
+
+	for_each_mem_pfn_range(i, nid, &spfn, &epfn, NULL)
+		total += (u64)(epfn - spfn) << PAGE_SHIFT;
+
+	return total;
+}
+
+/*
+ * A percentage of the node, less the size the boot line asked to keep back.
+ * Keeping back more than the percentage came to reserves nothing.
+ */
+static phys_addr_t __init numa_cma_pct_size(int nid, unsigned int pct,
+					    phys_addr_t sub)
+{
+	phys_addr_t size = mul_u64_u32_div(numa_cma_node_size(nid), pct, 100);
+
+	if (size <= sub)
+		return 0;
+
+	return size - sub;
+}
+
 static void __init dma_numa_cma_reserve(void)
 {
 	int nid;
@@ -214,15 +333,36 @@ static void __init dma_numa_cma_reserve(void)
 		int ret;
 
 		if (!node_online(nid)) {
-			if (pernuma_size_bytes || numa_cma_size[nid])
+			if (pernuma_size_bytes || pernuma_pct ||
+			    numa_cma_size[nid] || numa_cma_pct[nid])
 				pr_warn("invalid node %d specified\n", nid);
 			continue;
 		}
 
 		/* per-node numa setting has the priority */
-		size = numa_cma_size[nid] ?: pernuma_size_bytes;
-		if (!size)
+		if (numa_cma_size[nid])
+			size = numa_cma_size[nid];
+		else if (numa_cma_pct[nid])
+			size = numa_cma_pct_size(nid, numa_cma_pct[nid],
+						 numa_cma_sub[nid]);
+		else if (pernuma_size_bytes)
+			size = pernuma_size_bytes;
+		else if (pernuma_pct)
+			size = numa_cma_pct_size(nid, pernuma_pct, pernuma_sub);
+		else
+			continue;
+
+		/*
+		 * A percentage of a memoryless online node, and a percentage
+		 * entirely consumed by the size kept back, resolve to nothing
+		 * to reserve. Say so, since the operator asked for memory.
+		 */
+		if (!size) {
+			if (numa_cma_pct[nid] || pernuma_pct)
+				pr_warn("node %d percentage reserves nothing\n",
+					nid);
 			continue;
+		}
 
 		cma = &dma_contiguous_numa_area[nid];
 		snprintf(name, sizeof(name), "numa%d", nid);

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.47.1


