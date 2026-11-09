Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3198606A331
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=C97qM9km
Received: by kanga.kvack.org (Postfix)
	id F2A316B05CD; Mon,  9 Nov 2026 00:56:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDB056B05CE; Mon,  9 Nov 2026 00:56:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA9C36B05CF; Mon,  9 Nov 2026 00:56:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFAFF6B05CD
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:56:56 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A804405B7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:56 +0000 (UTC)
X-FDA: 85414522032.29.393874B
Received: from mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	by imf22.hostedemail.com (Postfix) with ESMTP id C2551C0003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:56:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C97qM9km;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.187 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203814;
	b=K6SeIc5ao/j7jXJGRwMNpnp2FE9NZ9v+zb3XvPBnz/0Wm4AAb7sUP5eWCf7M5DLED/QVem
	+CjL3XZFcvUkvOJzTT0ItsnnMkEZNJ330eCcl9QNZhQQUEUMX+WbvuHOdwF6Li6acHDa7i
	WCzTW4bzJjizEhzr7MGoqUz8+FWcA+Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C97qM9km;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.187 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5ITN//LPFqp0ZHi5BiMZ3TdldQm7dw4fN0sp0t3nnI=;
	b=YscECiuCkYmoUkJ0ctfPb+QjVTG9edCHGYU3az7aCFBvXrE4bhfJhawitv4kQobt3hf1Bm
	rSP7IRKRgFLCdRtZxPBQemcdJFFVzlVulrPhhFU6EJITLt8kYwwF7hbTXEIySeKTo/08CU
	5X6h1XrlPA0QtO8PINuW+XRV0AO8w0s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=U+AEFg6hgKrg63ESuSGaXNv0t15O3WVBZkSpGKs849o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203812; v=1; x=1794808612;
 b=C97qM9kmQE8c+t/QZul7iNOfH86vCkou63QmKsKHX/NhLs6XsW18eF48v49uhx69LsgUWtIa
 QJcVuJ9soM4FHNig+xHiya5//R0YU0Ad8fxPVktcJWlxs+tQh2efTZcI88qjirgPK85kqQKVsYf
 wKFEvdkhv6FlbuQ8g3khKvTQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 30f76fd69c558bf5;
	Mon, 09 Nov 2026 05:56:52 +0000
X-Mizu-Trace-ID: 30f76fd69c558bf5
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
Subject: [PATCH v5 11/19] mm, swap: add CONFIG_XSWAP_DEFAULT_MAX
Date: Mon,  9 Nov 2026 13:54:47 +0800
Message-ID: <20261109055455.536925-12-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nfz6844iu8n4gkwez7kb4bccks1mhdoz
X-Rspamd-Queue-Id: C2551C0003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794203813-871215
X-HE-Meta: U2FsdGVkX196rCx7RS+/wDPktn9e4Aq2QXwC/qqtoLvIHzV95MYlp6u5KqZN1v5OmmaCFw55CXbVZGlJOio78y8zOZ7yibdOZs2OztBKeQgaYxRoFoVfbLO4zVUvGFI1TlhKee2uTcd2hSfP9gEVQ83STabcIlGpwDoFFGYsPE6Ea2TJxJTIw8zAtqnhlbqTLokXzQTa5cyXimn8IwrHy/jYVCIJ6VOrJFM5neND2k3u8gMvuWAU7RlFz/zhM+NeI8gfc5y9zXO+d6VP242b6PRg9gT0s6r5YSkknsXJpVSmlMYn2bi7b/moB44oZrnVxdZGiU0UVdt2xzJhgAzLBbfLdimTEeFZqAkhtwVXTsYTNFW5uzaPHqdLPe3fhwtujtHnhlc//grqefq5BjoPp/chA3pJieGOL9Ax69WpH2WpnOK3ezRzNZlxXxXnoRkRuVwGVx+meJOXUoy5ql/+QM17OVfcwoidAuPbcVGSCK+GMLwZaki8l44DI2u0KlZEwAzmmowwBdeVIjlb6bY+Hm5DmKjkw0GtvRmJGFZb4RlpRUMWvva+UjfQd9oSTpnL15/q4VQv0ugn+p4fBdWPnZG0W4ZVJVlmtknB1jHoCRMCzleUdH/RGcgdRXHcnd6pfOFVw2dn05E5ilS/12p3VElv8FeV+HaNpoYuCrRtn2BXhYooZz8/7ruQA0F6iTg5o4Dw3ZtHErBLIiXF81ST/qqB2u39Dc1W0VANywpDnetydF+EGkNiR/gG2szz1uyZErgRbnOXN8hKszZhAANvblNEGXulmvnf6FWYCL1Huk+kuIpdpLy03y0emmflDUhPCj/AqjccAnulGYyrrSNkAsf3WEq/eswIuVBRZ0bERMQ6n2Yce7nKA9EwivjHwP4eezj0/AX3eN15O48Fu6g0pUXWhA4uRfLrQTC2WWI1s/iu2lwud55lOt/eJg/M/j46Hzxisq6Zl4WdBytafa5
 EDbMcS5T
 PmOeS30tnoBwpR2/wCYDaa6py8SQgVsuoGKGWNhwrp8zuWbSivPNp1/Dt1rrXmAEoQtRlgSh5T6bNmA8MVDVyecw4aUAaSQz19x9TCrrLP7Jq0ZtyaNXJHOAvlF1LdVKh/SgA/sUOjFcZLF1UzV8ZpL/+Rw7IXKtj+LvFbXUCXZe2FrEu4StB36CdH8vnwtOGZQ/NZB/P3hNRKvwDBOGqHx1NAhnBKhG6YAz726wXQ6/y2TJcjldxrU9/9P9V88jiSjydEmYbCfqLObLrCfv1k/7LsOY1pDxahugPboU1O9UnPDiOwFJP0ghpXoiv/mzhR46kPwIvTqgIwPtJW9XR+azLzDSk2SMZrxFdL2v/7sy2DhtPshj3UD7WXNMV4T7qkwvBblViHOpyTKDecP5QsYdPa3VBrvejVMaoiHprPONbsKmrS94rPhoIqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

Add a build-time default for the size of a new xswap device. The value
can be a percentage of RAM, a size in bytes, or "max". "max" means the
largest size the device can address. xswap.max= on the command line
overrides this default.

The build-time default is clamped to the device limit. An explicit
xswap.max= that is too large is refused.

If the build-time default cannot be parsed, or is a byte size below one
cluster, use 200% instead. A percentage default can still be below one
cluster after RAM is known. In that case, device creation fails.

Document the sysfs ABI, the stable id, and the synthetic /proc/swaps
name.  Also document that zswap must stay enabled while xswap devices
exist.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 .../ABI/testing/sysfs-kernel-mm-xswap         | 38 +++++++++++++++++++
 .../admin-guide/kernel-parameters.txt         |  3 +-
 Documentation/admin-guide/mm/zswap.rst        |  9 +++++
 MAINTAINERS                                   |  1 +
 mm/Kconfig                                    | 11 ++++++
 mm/swapfile.c                                 | 22 +++++++++--
 6 files changed, 79 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-mm-xswap

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-xswap b/Documentation/ABI/testing/sysfs-kernel-mm-xswap
new file mode 100644
index 000000000000..38eead0b1b31
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-xswap
@@ -0,0 +1,38 @@
+What:		/sys/kernel/mm/xswap/
+Date:		October 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	File-less swap devices backed by zswap.
+
+		An xswap device has no backing file.  Its slots are backed
+		by the zswap pool, and the device size is set at boot with
+		xswap.max= or CONFIG_XSWAP_DEFAULT_MAX.  The size is fixed
+		for the lifetime of the device.
+
+		The name shown in /proc/swaps, xswap<id>, is synthetic and
+		is not a path.  It cannot be passed to swapoff(2), so
+		swapoff -a reports an error for these entries.  Use the
+		destroy attribute instead.
+
+		An xswap device requires zswap.  Disabling zswap at runtime
+		(enabled=0, or max_pool_percent=0) while xswap devices
+		exist leaves them without backing: existing entries can
+		still be read, but new pages cannot be stored.  Destroy the
+		xswap devices before disabling zswap.
+
+What:		/sys/kernel/mm/xswap/create
+Date:		October 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Create an xswap device.
+
+		Write an optional priority (0..32767), or write nothing for
+		the default priority.  The write fails if zswap is disabled
+		or if the configured size is smaller than one cluster.
+
+What:		/sys/kernel/mm/xswap/destroy
+Date:		October 2026
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:	Destroy an xswap device.
+
+		Write the device's stable id.  The id is the number after
+		"xswap" in /proc/swaps, for example 1 for xswap1.  It is
+		not a swap type and is never reused.
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index e92a1b9062a6..6e2d2747a26f 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -8743,5 +8743,6 @@ Kernel parameters
 			Maximum size of a new xswap device. The value is a
 			size in bytes with an optional KMGTPE suffix, a
 			percentage of RAM, or "max" for the largest size
-			the device can address.
+			the device can address. The default is set by
+			CONFIG_XSWAP_DEFAULT_MAX.
 			Format: <size>[KMGTPE] | <percent>% | max
diff --git a/Documentation/admin-guide/mm/zswap.rst b/Documentation/admin-guide/mm/zswap.rst
index 2464425c783d..886b50ca90b1 100644
--- a/Documentation/admin-guide/mm/zswap.rst
+++ b/Documentation/admin-guide/mm/zswap.rst
@@ -136,3 +136,12 @@ selected.
 A debugfs interface is provided for various statistic about pool size, number
 of pages stored, same-value filled pages and various counters for the reasons
 pages are rejected.
+
+xswap devices
+-------------
+
+An xswap device is a file-less swap device backed by zswap.  While such a
+device exists, do not disable zswap at runtime (``enabled=0``) or set
+``max_pool_percent`` to 0.  The device would have no backing: pages already
+in zswap can still be read, but new pages cannot be stored.  Destroy the
+xswap devices first.
diff --git a/MAINTAINERS b/MAINTAINERS
index 0cf24eee20bb..66078761b746 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17910,6 +17910,7 @@ R:	Youngjun Park <youngjun.park@lge.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-swap
+F:	Documentation/ABI/testing/sysfs-kernel-mm-xswap
 F:	Documentation/mm/swap-table.rst
 F:	include/linux/swap.h
 F:	include/linux/swap_ops.h
diff --git a/mm/Kconfig b/mm/Kconfig
index 9bdb905a66ef..902e3b1a6e35 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -131,6 +131,17 @@ config XSWAP
 	  array is backed by a sparse vmalloc area that is mapped lazily
 	  in chunks, avoiding static pre-allocation overhead.
 
+config XSWAP_DEFAULT_MAX
+	string "Default maximum size of a new xswap device"
+	depends on XSWAP
+	default "200%"
+	help
+	  The maximum size of a newly created xswap device. It accepts a
+	  percentage of RAM (for example "200%"), a size (for example "2T"),
+	  or "max" for the largest size the device can address.
+
+	  xswap.max= on the kernel command line overrides this value.
+
 config ZSMALLOC
 	tristate
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 498fbf6df1cd..cb53f9415de8 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -161,9 +161,12 @@ static bool xswap_size_max;
 static bool xswap_size_set;	/* xswap.max= was given */
 
 /*
- * Parse "200%", "2T" or "max".  @str is not modified.
+ * Parse "200%", "2T" or "max". @str is not modified. @cmdline tells an
+ * explicit xswap.max= from the build-time default, which is clamped
+ * instead of refused when it is too large.
  */
-static int __init xswap_parse_size(const char *str, const char *what)
+static int __init xswap_parse_size(const char *str, const char *what,
+				   bool cmdline)
 {
 	const char *pct;
 	char buf[16];
@@ -192,12 +195,16 @@ static int __init xswap_parse_size(const char *str, const char *what)
 		bytes = memparse(str, &end);
 		if (*end || bytes < PAGE_SIZE)
 			goto bad;
+		/* A default below one cluster would fail every create. */
+		if (!cmdline && bytes < (unsigned long)SWAPFILE_CLUSTER * PAGE_SIZE)
+			goto bad;
 		xswap_size_bytes = bytes;
 		xswap_size_pct = 0;
 		xswap_size_max = false;
 	}
 
-	xswap_size_set = true;
+	if (cmdline)
+		xswap_size_set = true;
 	return 0;
 bad:
 	pr_err("xswap: bad %s=%s\n", what, str);
@@ -206,7 +213,7 @@ static int __init xswap_parse_size(const char *str, const char *what)
 
 static int __init xswap_max_setup(char *str)
 {
-	xswap_parse_size(str, "xswap.max");
+	xswap_parse_size(str, "xswap.max", true);
 	return 1;
 }
 __setup("xswap.max=", xswap_max_setup);
@@ -4830,6 +4837,13 @@ static int __init swapfile_init(void)
 {
 	swapfile_maximum_size = arch_max_swapfile_size();
 
+#ifdef CONFIG_XSWAP
+	/* xswap.max= on the command line overrides the build-time default. */
+	if (!xswap_size_set)
+		xswap_parse_size(CONFIG_XSWAP_DEFAULT_MAX,
+				 "CONFIG_XSWAP_DEFAULT_MAX", false);
+#endif
+
 	/*
 	 * Once a cluster is freed, it's swap table content is read
 	 * only, and all swap cache readers (swap_cache_*) verifies
-- 
2.54.0


