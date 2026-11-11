Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DBE2606A339
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=aSw1KnWA
Received: by kanga.kvack.org (Postfix)
	id 2B6D06B05B5; Wed, 11 Nov 2026 09:04:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266F76B05B6; Wed, 11 Nov 2026 09:04:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1582B6B05B7; Wed, 11 Nov 2026 09:04:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1CE26B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:04:54 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF424A7C51
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:04:52 +0000 (UTC)
X-FDA: 85423009224.26.4B9A0D3
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9D07EC0008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:04:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=aSw1KnWA;
	spf=pass (imf22.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794405891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ajXEYqjwM+nCEIVJkZ6WILdonbk+OIty74QS6bYQ+DU=;
	b=0rm/d98qG7lwJdeQMUSS6ys2//QAW7/ByM5AsJWiY3o00OqbtNnYT9x2ybpD9ak6KGKCEV
	7z+zMt1IqWUzEjRfhcFgX7Kw1/zDmZpPvOh+NAL2by/FyflMl6e0/H+ZcUvSVRtK3UCpku
	LuKFSKaAZJ3jDECK5VBKN/j141/tuyM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794405891;
	b=5/TFA9LCxH3vdbZx4/YqK6n+SFId9DpCZE/LKWhsFndKyz3qNiZiRkzgBUcuPP9v5r1ZtY
	xDNr3dsZtlNnimiE8TE+hgcFGlxpqfxuxCO11E2DqCyFw9p/xgnzRWV/2IYKoVCUZL3yOn
	NUxMrbMYNZfB8aNpzt+e1rOg5eNs0as=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=aSw1KnWA;
	spf=pass (imf22.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794405890; x=1825941890;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ajXEYqjwM+nCEIVJkZ6WILdonbk+OIty74QS6bYQ+DU=;
  b=aSw1KnWAg3YBBQp7jv+kqqX5BYSYpW7yCBk9DKqvFZuR0oWxmvRRNbvi
   9YbsuDCos1MyvwM1s0dKQ/jBmkt7Q/3iF+jcC3rzbcl+Ws6+jpS3XjOQ5
   2oq2Reta98Vk0MQQSB0JL2tUrl9KsII7d2NilKNOpfhUJoxMXH1NYGF3s
   aDd+dP/Ph6KikGr1VdmXVI8bVsrDKU7kSf8R+a6WLbnUmMWDWGyVekIMX
   NT8UrmIEXdVA51H1QZGJQGPoE8AK6oSAsZfGmtH0Xp7L67T81qYXOors9
   F4fsUIdzJNNasYH1rfoC31tQn1rj/Cbs07hfAFPuQD3QQujV3wUPW4dSZ
   w==;
X-CSE-ConnectionGUID: mp+qsCQeQSa3lZBPareIIw==
X-CSE-MsgGUID: OV2cOm+zQAGswQmM5sZIqw==
X-IronPort-AV: E=Sophos;i="6.27,207,1787011200"; 
   d="scan'208";a="33751363"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 14:04:45 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:17225]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.142:2525] with esmtp (Farcaster)
 id 5ffd8552-4597-40d9-9dd4-121f17a20803; Wed, 11 Nov 2026 14:04:45 +0000 (UTC)
X-Farcaster-Flow-ID: 5ffd8552-4597-40d9-9dd4-121f17a20803
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 14:04:44 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 14:04:42 +0000
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
Subject: [PATCH] dma-contiguous: support percentage sizes in cma_pernuma= and numa_cma=
Date: Wed, 11 Nov 2026 14:04:40 +0000
Message-ID: <20261111140440.43024-1-graf@amazon.com>
X-Mailer: git-send-email 2.47.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ytwyn5wywggr65s6x5azaqx3ytpxi4b3
X-Rspamd-Queue-Id: 9D07EC0008
X-Rspam-User: 
X-HE-Tag: 1794405890-88170
X-HE-Meta: U2FsdGVkX1/J9uDwToDwt+9KNw9RkvqhuRWkNDKj0oB78D4uwbNorhreqMi5DuO2IJEVwtXVYF82XPOtoFVHKSqFWGrfQdw2zlPL9XfWStofnwtCA0cHRYYqZ1lu/qRc8kp0akOpsSdwlcP///bvsFakgRw9S75VgFrkEy4BLsMURF9cAMJ+9myS5p81HfbgBbQ0hYwIPl7l8OrzStS8oYkV2ZDLVqqcxW+PWezLrVJZ8+Qd9/4xmnOLNIafEx4+S+pYiaUL0IhhnNdA54qOf5b4qaC1QDGgdQfTruOhAzA1MK+jq7k/JJb//ldZR+bdTgrckEGuHNgihnIId/088Xv5p9+Eeq9C96Qi/H8U31cvsCK7WJYc1jqNfdE7beckktkKExVIerg1WclL6MUCeEfgFX2B6Th2OjiN3cjRrKKZcY1/jr0ytCYRO5RflGKtdP846HszOEga0bqleAQusTVGn1NxxbKEtU69t/XOX/poiAPZuEe+7JcWL+WuhG38NpWSuGbLZGScli3JUgQ0mymskhfUFiH6TcNhek1YdSSlgRwBYUJKM+XADFoEgARSt+CaPLroQdUALEpNtEUxSjH+ZVcGt9R+or5w+h7xNaj4yMJ5CMmLDN184vZ3wIY7b8C5pQlxrc/MwXS3MpJNdcTvy3H1euWCJWhr0ohAcf2uxmPH0L/E93pqLzO4WiIRm2FABX9E1AEYOx4CjiFPAw1nNjih3HHC5YpPWqngxaAXZmx/49NrRluZ3qTYKbLK5QWQL6n01/h0x98PQdiNE9VKtrzbHDAq2XlPHiWysYVk8azoSH/6gq1R1dyx75Bawm1zMD3xImzTlrOuGB5DkolDxcY+lad85y37jPGvbpNU+aPIEVfI2685M37aFP5pU1r3cfBm/bf9ZghL1Z0ElzO1x1K7Pc59+KlZj/Q2pWeywvXz4etFJLVUzx5un9GHd4s+N+DCidFUzyqq1yN
 9mipP0e4
 55BaKLsnpsJ+NhLtjmEa2H8UZj7di78//szpvpM/WYQ0xsPbVchr/8LVGJ7IO6SFMzUjGCeQH5DL7AHsPknO3XIaa1B467FEZVO7K66uJw3Qete+V1YoWcYqB6nlG4jOKt0j8DsjhZJGLXi/TuEpnW7pEmS8/+u93zeoDd9fgSLJ/vhP+iCM6y4rAz1TjoOHHu8Wuiw3hNPh4NTbnzE5Hczt8Pyzb7D9vfYnKUv+lg7aec/aZ+nLFpTBOWzsyc7lJqdgMg2UH0IOtLno1/XBroCZ8rUPh4hL1wRdhNjxU7QFnTwp+/CeeP5zr7wjZwl3hPrEr2L0Rd5rrbqPEMovii2MqfoCUOB7E8p736BmjzAPLmi6Nkk/5LweZF5azCQ6zweKS7JSfydq+8gWlVH2Vvo73RRgLA0ekK0pV/fmtgH/w0fPh2GWGtS6Gw5FZNjSsHFSG39OHcJxuLCaoXIgvC1z9GB8jDsXerSQgqsqEnECF/VSDSlgiyxXMoWm4m9pG0dRCW8mKLz1nx2fXVtgfh4sWZaXzyLfqFz8b0YEZmkHAO9TSbu3DPyYLZDZb3Xek3yz2pQ1ziQIIiVkTTBeWNwK6a4zDgR0vG4SsAA2nHeHm2Dp58iY+jRF4A+xYeE0vkHfRLvQHE3AsxaHtnErsMYHFySz0XcUIbAZa5gENIvRXzkjtzc0O9YVMKkE0sRa6zrRSyh0yS1KnwfA=
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

  cma_pernuma=80%, numa_cma=0:95%-1G,1:4G

To avoid incomplete allocations on parsing errors, check for them
before actually allocating.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 .../admin-guide/kernel-parameters.txt         |  64 +++++-
 kernel/dma/contiguous.c                       | 184 +++++++++++++++---
 2 files changed, 217 insertions(+), 31 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd94..1ca82f8c29f97 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -862,10 +862,13 @@ Kernel parameters
 			contiguous memory allocations and optionally the
 			placement constraint by the physical address range of
 			memory allocations. A value of 0 disables CMA
-			altogether. For more information, see
+			altogether. The size is absolute; the percentage form
+			is accepted by 'cma_pernuma=' and 'numa_cma=' only, and
+			CONFIG_CMA_SIZE_PERCENTAGE sizes this area as a fraction
+			of memory instead. For more information, see
 			kernel/dma/contiguous.c
 
-	cma_pernuma=nn[MG]
+	cma_pernuma=nn[MG]|nn%[-nn[MG]]
 			[KNL,CMA,EARLY]
 			Sets the size of kernel per-numa memory area for
 			contiguous memory allocations. A value of 0 disables
@@ -875,14 +878,61 @@ Kernel parameters
 			first try to allocate buffer from the pernuma area
 			which is located in node nid, if the allocation fails,
 			they will fallback to the global default memory area.
-
-	numa_cma=<node>:nn[MG][,<node>:nn[MG]]
+			The size may also be given as a percentage (nn%) of
+			each node's memory present at boot as seen by memblock;
+			hot-added memory is not counted. It is evaluated at
+			reservation time.
+			A percentage of 0 reserves nothing, like an absolute
+			size of 0. A value that does not parse, such as a
+			missing size, text after the value or a percentage
+			above 100, makes the whole parameter invalid: no node
+			takes a size from it, and
+			it does not fall back to mirroring the default area
+			onto every node either. An absolute size takes
+			priority over a percentage whichever order the two
+			were given in. A 'numa_cma=' on the same command line
+			still applies.
+
+			A percentage may be followed by a size to keep back
+			from it, so cma_pernuma=95%-1G reserves 95% of each
+			node less 1G. Keeping back at least as much as the
+			percentage came to reserves nothing on that node, and
+			warns as any other percentage resolving to nothing
+			does. The size kept back belongs to the percentage: a
+			later 'cma_pernuma=' percentage given without one
+			keeps nothing back.
+
+	numa_cma=<node>:nn[MG]|nn%[-nn[MG]][,<node>:nn[MG]|nn%[-nn[MG]]]
 			[KNL,CMA,EARLY]
 			Sets the size of kernel numa memory area for
 			contiguous memory allocations. It will reserve CMA
-			area for the specified node.
-
-			If it is setup together with upper 'cmd_pernuma='
+			area for the specified node. A per-node size may also
+			be given as a percentage (nn%) of that node's memory
+			present at boot as seen by memblock; hot-added memory
+			is not counted. It is evaluated at reservation time.
+			A size of 0, absolute or percentage, is the same as not
+			naming the node at all, so the node falls back to
+			'cma_pernuma=' when that is given. An entry that does
+			not parse, such as a node number of MAX_NUMNODES or
+			more, a missing size, text after a size or a
+			percentage above 100, makes the whole parameter
+			invalid: no node named
+			here gets an area, and there is no fall-back to
+			mirroring the default area onto every node either. A
+			'cma_pernuma=' on the same command line still applies.
+
+			A node may be named more than once. The last value of
+			each form is the one kept, and an absolute size takes
+			priority over a percentage for that node whichever
+			order the two were given in, so numa_cma=0:4G,0:50%
+			reserves 4G on node 0.
+
+			A percentage may be followed by a size to keep back
+			from it, per node, so numa_cma=0:95%-1G reserves 95%
+			of node 0 less 1G; see 'cma_pernuma=' above for what
+			keeping back more than the percentage came to does.
+
+			If it is set up together with upper 'cma_pernuma='
 			(unlikely), its size setting takes priority for the
 			specified numa nodes.
 
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 90937dc7c627d..c04d50ee0f7c8 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -41,6 +41,7 @@
 
 #include <linux/memblock.h>
 #include <linux/err.h>
+#include <linux/math64.h>
 #include <linux/sizes.h>
 #include <linux/dma-map-ops.h>
 #include <linux/cma.h>
@@ -135,45 +136,132 @@ EXPORT_SYMBOL_GPL(dev_get_cma_area);
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
+ * Parse one numa_cma= string: a comma separated list of <node>:<size>, where
+ * <size> is a size or <percent>%[-<size>]. Anything else fails the parse.
+ */
+static int __init numa_cma_parse(char *p, enum numa_cma_action action)
 {
 	int nid, count = 0;
 	unsigned long node;
-	phys_addr_t size;
-	char *s = p;
+	phys_addr_t size, sub;
+	char *s = p, *start;
 
 	while (*s) {
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
+		if (sscanf(s, "%lu%n", &node, &count) != 1 || s[count] != ':' ||
+		    node >= MAX_NUMNODES)
+			return -EINVAL;
+		nid = array_index_nospec(node, MAX_NUMNODES);
+
+		start = s + count + 1;
+		size = memparse(start, &s);
+		if (s == start)
+			return -EINVAL;
+
+		if (*s == '%') {
+			s++;
+			if (size > 100) {
+				pr_warn("numa_cma: node %d percentage %llu%% > 100\n",
+					nid, (unsigned long long)size);
+				return -EINVAL;
+			}
+			sub = 0;
+			if (*s == '-') {
+				start = ++s;
+				sub = memparse(start, &s);
+				if (s == start)
+					return -EINVAL;
+			}
+			if (action == NUMA_CMA_APPLY) {
+				numa_cma_pct[nid] = size;
+				numa_cma_sub[nid] = sub;
+			}
+		} else if (action == NUMA_CMA_APPLY) {
 			numa_cma_size[nid] = size;
+		}
 
-			if (*s == ',')
-				s++;
-			else
-				break;
-		} else
-			break;
+		if (*s == ',')
+			s++;
+		else if (*s)
+			return -EINVAL;
 	}
 
-	numa_cma_configured = true;
 	return 0;
 }
+
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
+	numa_cma_configured = true;
+
+	rc = numa_cma_parse(p, NUMA_CMA_CHECK);
+	if (rc)
+		return rc;
+
+	return numa_cma_parse(p, NUMA_CMA_APPLY);
+}
 early_param("numa_cma", early_numa_cma);
 
 static int __init early_cma_pernuma(char *p)
 {
-	pernuma_size_bytes = memparse(p, &p);
+	phys_addr_t val, sub;
+	char *start;
+
+	/* See early_numa_cma(): a rejected string still counts as configured. */
 	numa_cma_configured = true;
+
+	start = p;
+	val = memparse(start, &p);
+	if (p == start)
+		return -EINVAL;
+
+	if (*p == '%') {
+		p++;
+		if (val > 100) {
+			pr_warn("cma_pernuma: percentage %llu%% > 100\n",
+				(unsigned long long)val);
+			return -EINVAL;
+		}
+		sub = 0;
+		if (*p == '-') {
+			start = ++p;
+			sub = memparse(start, &p);
+			if (p == start)
+				return -EINVAL;
+		}
+		if (*p)
+			return -EINVAL;
+		pernuma_pct = val;
+		pernuma_sub = sub;
+	} else {
+		if (*p)
+			return -EINVAL;
+		pernuma_size_bytes = val;
+	}
+
 	return 0;
 }
 early_param("cma_pernuma", early_cma_pernuma);
@@ -198,6 +286,33 @@ static inline __maybe_unused phys_addr_t cma_early_percent_memory(void)
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
@@ -214,16 +329,37 @@ static void __init dma_numa_cma_reserve(void)
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
 			continue;
 
+		/*
+		 * A percentage of a memoryless online node, and a percentage
+		 * entirely consumed by the size kept back, resolve to nothing
+		 * to reserve. Say so, since the operator asked for memory.
+		 */
+		if (!size) {
+			if (numa_cma_pct[nid] || pernuma_pct)
+				pr_warn("node %d percentage reserves nothing\n",
+					nid);
+			continue;
+		}
+
 		cma = &dma_contiguous_numa_area[nid];
 		snprintf(name, sizeof(name), "numa%d", nid);
 		ret = cma_declare_contiguous_nid(0, size, 0, 0, 0, false, name, cma, nid);

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.47.1


