Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C3D7606A33B
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=t/E3vIXm
Received: by kanga.kvack.org (Postfix)
	id 536556B05BD; Sun, 22 Nov 2026 07:40:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6126B05BE; Sun, 22 Nov 2026 07:40:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC9F6B05BF; Sun, 22 Nov 2026 07:40:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 261FD6B05BD
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:40:58 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB047C06EA
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:40:57 +0000 (UTC)
X-FDA: 85462714554.24.47DB9FA
Received: from mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id ABF0D160002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:40:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="t/E3vIXm";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.54 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351256;
	b=BAoN9sdDNF1CMpoOM4llNyEChDkEuV+hEEDBHjmv9NTpTJYxsz20wN2eGIWcPKROoqcqjH
	lD2hzWgK+oE7BwJmcqeBQEUUW2yz6ET0xfXm90JXc264ohqF+75nSvqfJ7czdj1+gjMI/1
	128DxMw7P4cnx4mUzPG7D+9ZdB3m1sc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xpa97AJSETU/USrlzLhbXofN2h+6mzWI9qJO3gzBWbY=;
	b=0QNgdmClHHz0hl2ylxLL+ACZgkhWTklkum6+GHuWUdXGLH/G5LjNIgdIt8zJTKnnrZ3VnN
	EfgicIQ8fk0oo5KjHVh1KbBxBsQOIBYZgQHqwGXMlUiQn46/QTE0k598p97BHPvKnMAvpv
	FKRDZq3lWmuFRhxaiuc6C/2If5BFKeM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="t/E3vIXm";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.54 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YVRaYa2pvbDkVtOXVPQLtBRt3ZcLmHbUK9ZifXUzKRg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795351254; v=1; x=1795956054;
 b=t/E3vIXma+K0xuC2Bf08Mg3sEUhToG+VPykE6O8bkBGPI21FD7htDyIpZWERXF0AsMkBK1ox
 C3csbZctlrlhmGtK97ljJQigORedfsuD85sr2P5z9pBO5tKCa0QRlNPGUklZ9+8yguVtiwLQL6z
 X3IK2JGA59s/H2//KZlcQ4H8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 2b4268fdca5fad66;
	Sun, 22 Nov 2026 12:40:54 +0000
X-Mizu-Trace-ID: 2b4268fdca5fad66
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	corbet@lwn.net,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	baoquan.he@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v6 09/14] mm, swap: let the command line set the xswap device size
Date: Sun, 22 Nov 2026 20:39:13 +0800
Message-ID: <20261122123918.3486916-10-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261122123918.3486916-1-baoquan.he@linux.dev>
References: <20261122123918.3486916-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ABF0D160002
X-Stat-Signature: drufkwd9an7tpirk79neycd1i6hnndgy
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795351255-262270
X-HE-Meta: U2FsdGVkX19IC3jCCRADzGdtxZEpdBeC2WlIp481zItmKPTNrhi6DV1hx5pfqyYJrklb3yjvE36RtdgD3PkIGPm16rOZoh6GTUnDbTtNphS5hT4ZjjfFxW0xIIRw1zrWWS4XmfzN6LrPTY8xdzpkRchta9IuEz0Yp5Vsx9l8ZI2RVnHNr60tAhAUhXOSaFtcNRb3nzMEo/LPdmWiC7uDjlM3Dz63OUOP5fHVf13a5AziVqom7fu2yt3n63Bf+Mw2CwbfDiDZe86ocHcNfDsqZCNxw3p4wNk65+eXI+/JEIgXC4tx3RtH6+OGNSK/yU8M3SQJYyoUP5mXykvCnFLoCKw9JDROlzD6aUsWfw5eXuYF8MANqlkGhqIuMdmT6VwsFxA8sUBvfT09gJ20q3Y+6kBsRLKTXc82+7lnc+1V8h7PNC3Ri+uFdhmEolnZFQVCqH580DyAgeO/5V9NLXVz8+hAqmi2oCLwFAqQeeyfFXE74rNdCcYkSXKcNqIQtrhKtDN63M9hPn1XJNd1VCYVdi9GZUProyDnnKi7M/nF0YMCxGq/FwW+tJdC6xDRFzo/+6qCkwDiXG6tiFE3Su1XTKSLYrsJEjbW5P3hwQjI5CPbwT/pFWEWwuq8uDVr/Z418pg0NYha9vgIx+P0iIIHvzurBX9Z+UlLKVWPG7+Ozf5ZIpqVkoxVM2K537pnGusDI9cKRhwFpgSY0xu6dLJT26i3OpWJjfEP2cLCk65GkKLaOUtg3wuqYlAzE8AMEp15wi8dHbeyXP9ofrmjk+WWY78DWMQsxo3ySEkt7Cdd3j6xbfcLaVoo+6MpuxIdOsRO7Ftu1LRbJ//TswG69woH4j4d/5LR0kbxMZSNRrUjV8xZOLP6gQQJPOtMSJ7EEeU2HhiABazwTLP4AiVWmviaUvz5PDRcdNkHkN7XULCyfxxXjL4w3afjvvBa5Os/x5pRe0+fi2JDgLImMTCGcc0
 M577nyXX
 YxanyZSmN9B6Algaax2dQ6/LXVdDc9WoWb6xFpZBX6JB+MnLILcVVzBDbTil2OBq+LcY/IB8Wd9gxgjbKrTolcfx1LK8rX5yydbs7XJ98KZEOFTj511DLjugd2YLALzRZa+zsOpXIGBPbW9LXmgTlh+LTEkNPisuI61DROqZnfn0JsAGDSRKQsY2O2n9ZwloUTgJzvVsCe0WW/2skcSy1tNjrgR46LoyzqeKVR+D04x46NFMPbATlD3TpBe/8EYZ9l7Qu0QALi2nF+v5UtpNcUmmn5tXFnTwRHLaTQ22R7pzTPTHiiae4v5IG21F/S74mgbpLRW8pwRKPpiVaUtmVnveWx4nzUUqClKgeINmh0FEdU3MdIusrmq6YMxLJypy0lard6TJm1v8ZSz0gkm6yU6kpoy+O5WVVL396jJ8ZtxLaGBPRKkf2zr0CrxuQVrOKhlpgiiNApXqOQgqRM6XK6AZ0HX6M+lM8kbuB+fZvbiSn2L3tix9uKewhgN1JkXhUsvt5B3mBneIBq8Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

By default, a new xswap device is 200% of RAM, which is twice RAM.
Add xswap.max= to set the size of devices created after it:

  xswap.max=300%      three times RAM
  xswap.max=8G        eight GiB
  xswap.max=max       the largest size the device can address

The default is fine for most users. But a machine with a lot of RAM
and a small working set can get a SwapTotal much larger than it needs.

The size is resolved at device creation, not at parameter parsing,
because a percentage depends on RAM, which is not known yet when the
parameters are parsed.

An explicit size that is too large or overflows is refused; the default
is clamped instead. A size below one cluster is also refused.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 .../admin-guide/kernel-parameters.txt         |   7 +
 mm/swapfile.c                                 | 135 ++++++++++++++++--
 2 files changed, 130 insertions(+), 12 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 176648941aec..9928f0937514 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -8731,3 +8731,10 @@ Kernel parameters
 				memory, and other data can't be written using
 				xmon commands.
 			off	xmon is disabled.
+
+	xswap.max=	[KNL,SWAP]
+			Maximum size of a new xswap device. The value is a
+			size in bytes with an optional KMGTPE suffix, a
+			percentage of RAM, or "max" for the largest size
+			the device can address.
+			Format: <size>[KMGTPE] | <percent>% | max
diff --git a/mm/swapfile.c b/mm/swapfile.c
index ba899e349e99..6ce5dbb3b103 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -14,6 +14,7 @@
 #include <linux/mman.h>
 #include <linux/slab.h>
 #include <linux/kernel_stat.h>
+#include <linux/overflow.h>
 #include <linux/swap.h>
 #include <linux/vmalloc.h>
 #include <linux/pagemap.h>
@@ -74,6 +75,102 @@ static int xswap_destroy_by_name(const char *name);
 
 /* Serializes create and destroy: at most one xswap device exists. */
 static DEFINE_MUTEX(xswap_ctl_lock);
+
+/*
+ * Size of a new device: xswap.max= if given, otherwise the built-in
+ * default.  A percentage unless bytes is set; "max" asks for the largest
+ * size the device can address.
+ */
+static unsigned int xswap_size_pct = 200;
+static unsigned long xswap_size_bytes;
+static bool xswap_size_max;
+static bool xswap_size_set;	/* xswap.max= was given */
+
+/*
+ * Parse "200%", "2T" or "max".  @str is not modified.
+ */
+static int __init xswap_parse_size(const char *str, const char *what)
+{
+	const char *pct;
+	char buf[16];
+	unsigned int pct_val;
+	unsigned long bytes;
+	char *end;
+
+	pct = strchr(str, '%');
+	if (!strcmp(str, "max")) {
+		xswap_size_max = true;
+		xswap_size_pct = 0;
+		xswap_size_bytes = 0;
+	} else if (pct) {
+		size_t len = pct - str;
+
+		if (pct[1] || !len || len >= sizeof(buf))
+			goto bad;
+		memcpy(buf, str, len);
+		buf[len] = '\0';
+		if (kstrtouint(buf, 0, &pct_val) || !pct_val)
+			goto bad;
+		xswap_size_pct = pct_val;
+		xswap_size_bytes = 0;
+		xswap_size_max = false;
+	} else {
+		bytes = memparse(str, &end);
+		if (*end || bytes < PAGE_SIZE)
+			goto bad;
+		xswap_size_bytes = bytes;
+		xswap_size_pct = 0;
+		xswap_size_max = false;
+	}
+
+	xswap_size_set = true;
+	return 0;
+bad:
+	pr_err("xswap: bad %s=%s\n", what, str);
+	return -EINVAL;
+}
+
+static int __init xswap_max_setup(char *str)
+{
+	xswap_parse_size(str, "xswap.max");
+	return 1;
+}
+__setup("xswap.max=", xswap_max_setup);
+
+/*
+ * The most a device can address, whatever xswap.max= asked for.  An xswap
+ * slot is still a swap entry, so the swap offset limit applies even though
+ * the data never goes through a physical address.
+ */
+static unsigned long xswap_size_limit(void)
+{
+	unsigned long limit = swapfile_maximum_size;
+
+	/* A cluster index is an unsigned int. */
+	if (limit / SWAPFILE_CLUSTER > UINT_MAX)
+		limit = (unsigned long)UINT_MAX * SWAPFILE_CLUSTER;
+
+	return limit;
+}
+
+static unsigned long xswap_size_pages(void)
+{
+	unsigned long long pages;
+
+	if (xswap_size_max)
+		return xswap_size_limit();
+
+	if (xswap_size_bytes)
+		return xswap_size_bytes >> PAGE_SHIFT;
+
+	/* Let xswap_create() refuse a size that does not fit in the type. */
+	if (check_mul_overflow((unsigned long long)totalram_pages(),
+			       (unsigned long long)xswap_size_pct, &pages))
+		return ULONG_MAX;
+
+	return div_u64(pages, 100);
+}
+
 #else /* !CONFIG_XSWAP */
 static inline int xswap_create_by_name(const char *name, int swap_flags)
 {
@@ -4079,13 +4176,15 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 
 #ifdef CONFIG_XSWAP
 /*
- * Create the file-less xswap device, sized at twice RAM.  Called from
- * swapon(2) with SWAP_FLAG_XSWAP; there is at most one device per system.
+ * Create the file-less xswap device, sized by xswap.max= or the built-in
+ * default.  Called from swapon(2) with SWAP_FLAG_XSWAP; there is at most
+ * one device per system.
  */
 static int xswap_create(int prio)
 {
 	struct swap_info_struct *si;
-	unsigned long ram, maxpages;
+	unsigned long maxpages;
+	unsigned long limit;
 	unsigned int type;
 	int error;
 
@@ -4093,6 +4192,26 @@ static int xswap_create(int prio)
 	if (!zswap_is_enabled())
 		return -EOPNOTSUPP;
 
+	/*
+	 * Refuse an explicitly requested size the device cannot address;
+	 * clamp the default size, which nobody asked for.
+	 */
+	limit = xswap_size_limit();
+	maxpages = xswap_size_pages();
+	if (xswap_size_set && maxpages > limit) {
+		pr_err("xswap: xswap.max is larger than the device can address\n");
+		return -EINVAL;
+	}
+	maxpages = min(maxpages, limit);
+	/*
+	 * Below one cluster, si->max is not cluster-aligned and a slot in
+	 * the only cluster would be past the end of the device.
+	 */
+	if (maxpages < SWAPFILE_CLUSTER) {
+		pr_err("xswap: the configured size is smaller than one cluster\n");
+		return -EINVAL;
+	}
+
 	mutex_lock(&xswap_ctl_lock);
 
 	spin_lock(&swap_lock);
@@ -4116,16 +4235,8 @@ static int xswap_create(int prio)
 	INIT_WORK(&si->discard_work, swap_discard_work);
 	INIT_WORK(&si->reclaim_work, swap_reclaim_work);
 
-	ram = totalram_pages();
-	maxpages = min_t(unsigned long, ram * 2, swapfile_maximum_size);
-	/* A cluster index is an unsigned int, so cap the cluster count. */
-	if (maxpages / SWAPFILE_CLUSTER > UINT_MAX)
-		maxpages = (unsigned long)UINT_MAX * SWAPFILE_CLUSTER;
 	/* Cluster-aligned, so no cluster holds a slot past si->max. */
-	if (maxpages > SWAPFILE_CLUSTER)
-		maxpages = rounddown(maxpages, SWAPFILE_CLUSTER);
-	if (maxpages < 2)
-		maxpages = 2;
+	maxpages = rounddown(maxpages, SWAPFILE_CLUSTER);
 
 	si->bdev = NULL;
 	si->swap_file = NULL;
-- 
2.54.0


