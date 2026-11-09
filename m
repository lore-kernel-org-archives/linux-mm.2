Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 702AF606A330
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DRk1+mWD
Received: by kanga.kvack.org (Postfix)
	id 7B1976B05CB; Mon,  9 Nov 2026 00:56:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 761B26B05CC; Mon,  9 Nov 2026 00:56:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650326B05CD; Mon,  9 Nov 2026 00:56:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31AF16B05CB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:56:51 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEAC11205AF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:50 +0000 (UTC)
X-FDA: 85414521780.01.A42F5F8
Received: from mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id AF674C0003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DRk1+mWD;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.176 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203809;
	b=yU3xrSgJPx+U4hjpAxsfHEqS2reJ8SRaGAeKeOkiKx5JMZ9+l4eB40r1puqKnYW9sWznYz
	4pzExN8q1heErL5+JZBuRh38tShPhqKWQuBoR/JWF9NYYGKzPJUl41gl+ZrD4A9RYWJ+wN
	BseJzRfG9UAzspw1/4GYTb0UkJu62I4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DRk1+mWD;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.176 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sVucbjapRHkFi5A8kcECistOx5jjdhJJRy/CQV2ING8=;
	b=3q4d9GI4jchxQ+o4r/zlgNUY4qORCoNKiJbYdAOTPaH2wjzsJ/yWSWvJc2Fb+rEd3X+ZTW
	wDFkRb6/tp/IsG3OYwWheSO7P8NAgZA9VzqbeJvpBFnnPu+PTUDsC9XIWvsR/K9pW9MSwG
	7yBKUeV0zdpiVr16qGtclQZW66MEgX4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mckKJp3udcFJk+QeqOHBO929R9nkM1Xgjw5azrxlv4s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203807; v=1; x=1794808607;
 b=DRk1+mWDKqcMEqA57afkqyV/D9xb3QTSzAnOKJs1SnlfmHOFV5jGxiJQTq7cP8OOXflchd23
 18h/ynND8K9Ke9e2cTq1hz8UW2bc84zYDEJaAtnzVw2ysn7JyIR5xSSd8Mzj+t2qO74W++R9TfN
 rZQ+9KpIh10Jn8p78bS6pxNs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 3812f45ae6465a56;
	Mon, 09 Nov 2026 05:56:47 +0000
X-Mizu-Trace-ID: 3812f45ae6465a56
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	chengming.zhou@linux.dev,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v5 10/19] mm, swap: let the command line set the xswap device size
Date: Mon,  9 Nov 2026 13:54:46 +0800
Message-ID: <20261109055455.536925-11-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AF674C0003
X-Stat-Signature: wharkfg8s31jqhqmfn7rq7aw4siytm7p
X-Rspam-User: 
X-HE-Tag: 1794203808-425775
X-HE-Meta: U2FsdGVkX1+tkwbHXtsLM+NLVRM2oYoWN1eWs1B/nhc8KyhIwhM+BliIldYZRfKjcwgOxcq/xtGquAJAA/uwNX01oqic9RzD9bJTw1lvDObY3wxgQFa/QXLAguT90ln7w9HpayVRjSiKCfwT7GFp4F1qMtRIfyAALiPwJ3VzaZTm2WmxKzUju6Mj3MKQgRD+YhshB+sjpfh6Yi5tlmvVwVmcBPKAl2fjNQ2bC3ql5TAwDLOzQVaQT40FkNSdHJH3nSu93IPIwQL9hXk/jolaQjuiXDkTHdSG7S7JxUysuLqrFlqM/uDLnw7auNmWjKLkg8xYHoaTB9UUHnjy5BpSy3DNcJjJqA7lTx3da5TJtYmR8RQXHeTv12H9w03xuQ+6wdLfmvVzgT/eVDjdEVLj+hKO7biaWDz72X/nURPh4LKw/YJePtMJY5a378yW4mMlfrwu5Lzgk5bOUOazYDVMi+dsR9+LeaZHNZw9L2M1VJ9zGZWfu8K/HHIrO8EPuhPPwLKIp61fcEuqiwaqjWpXGrK92T6ou8oRfC8u4DCx8ggYzPpr9dYaYA9GFlm32t7hjSqK12qZGzwLbfAKhLQ0E5RXXSjQ3xdxGoRWYF9P1y+qk/tp0G6TQBLuNynj5+6r4QU3Zw0mqnwnQfCV+iOf7IOUeMcudkeif/ZKTdQ6wAACSfSYvfQxsu4FujPBxOcEWSIPDCIcueax+8W31y98Kv6pDxYAfOop96R5GdrEHCot3+pK0AAjD47aZhmt+f3ynIw/Mp6V52dBcfBX2wtzgPLJMtXUE706FSEhx88f1EmMgb78esLlC43KRrKCR/SrKYhCrdUh8XkUrwdMXHsK4IGFdxcqXhMf3MX5T4DV3JyQuJZIj0aWFvTt5e6gixFVsdNw38rduxt3qEBqTcfeAAsNOkftd9n6zfXwFRhANe6RWJq+K/HvAxP17eRgdP5ssPeR2Ah4llBLtzJ9fCy
 oIAvr3So
 5OucBmZA4rgZxIZSu0I+B4iEkY2MG/lNB9QofYpQxYRXUNkYFKbJ41k0vDZBP5ODQUfLPD0dT9LytVraxKAF+3mj5E3PsjkCTKazDhVu5n/x3O8uZ33AHUOIGQ3cXxA9eNqT44qfNTc93gTPa/h+/XTaDQb0iW+voYGJvf4NzJBycti804ajMnHFRp/Kh3QPbvlgVAlWRnz1OwvMmrZLYynsnlE8cdGJNUBCi9l881003gHM39SoO0cRm1SwUcQGy6FhwIrmuAGvNIuACm2BxNdEZNUbiKrh3yCJGfbVfNWG4TubGT2CCMQqpKQ==
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

The size is resolved at device creation, not at parameter parsing
because a percentage depends on RAM, and totalram_pages() is not ready
when parameters are parsed.

An explicit size that is too large or overflows is refused. The default
size is clamped to the limit instead. A size below one cluster is also
refused. "max" means the largest addressable size, still bounded by the
unsigned int cluster index.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 .../admin-guide/kernel-parameters.txt         |   7 +
 mm/swapfile.c                                 | 130 ++++++++++++++++--
 2 files changed, 127 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd9..e92a1b9062a6 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -8738,3 +8738,10 @@ Kernel parameters
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
index 44b54118d10a..498fbf6df1cd 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -14,6 +14,7 @@
 #include <linux/mman.h>
 #include <linux/slab.h>
 #include <linux/kernel_stat.h>
+#include <linux/overflow.h>
 #include <linux/swap.h>
 #include <linux/vmalloc.h>
 #include <linux/kobject.h>
@@ -150,6 +151,100 @@ static struct attribute *xswap_attrs[] = {
 	NULL,
 };
 
+/*
+ * Size of a new device, from xswap.max=.  A percentage unless bytes is
+ * set; "max" asks for the largest size the device can address.
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
 static const struct attribute_group xswap_attr_group = {
 	.attrs = xswap_attrs,
 };
@@ -4268,7 +4363,8 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 static int xswap_create(int prio)
 {
 	struct swap_info_struct *si;
-	unsigned long ram, maxpages;
+	unsigned long maxpages;
+	unsigned long limit;
 	int error;
 
 	if (prio != DEF_XSWAP_PRIO &&
@@ -4279,6 +4375,28 @@ static int xswap_create(int prio)
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
+	 * Below one cluster the device is not cluster-aligned, so its only
+	 * cluster would hold slots past si->max.  Nothing masks those, and a
+	 * slot allocated there is past the end of the device: it can never be
+	 * read back or given up again.
+	 */
+	if (maxpages < SWAPFILE_CLUSTER) {
+		pr_err("xswap: xswap.max is smaller than one cluster\n");
+		return -EINVAL;
+	}
+
 	si = alloc_swap_info();
 	if (IS_ERR(si))
 		return PTR_ERR(si);
@@ -4286,16 +4404,8 @@ static int xswap_create(int prio)
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


