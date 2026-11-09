Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB6F9606A32A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uUiqqCE4
Received: by kanga.kvack.org (Postfix)
	id EDD216B05D0; Mon,  9 Nov 2026 00:57:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4586B05D1; Mon,  9 Nov 2026 00:57:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBB346B05D2; Mon,  9 Nov 2026 00:57:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B04856B05D0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:57:04 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 491C6A05D2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:57:04 +0000 (UTC)
X-FDA: 85414522368.07.9335160
Received: from mta0.migadu.com (out-192.mta0.migadu.com [91.218.175.192])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3A5AD40006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:57:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uUiqqCE4;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.192 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203822;
	b=O/KnHiK0QTy9nQOZfcqkwd2U6M9QMZoQGdVPeWs5zWbhFs8ZDdKhvlXcvaxG+ssLcHsW92
	IFnq/5R4Ail2O3gWVZMnwCUo+0tuL7TeFdR9NAjB+kq/2mBtH5QDyNNWfo+AVlMyaN4//S
	23ASnFt0y1lAt6t4eYi2AsFm8VjEwHg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uUiqqCE4;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.192 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kSmmp9v6vncnhzFzbNk1b+BeLQB+Xppvc2OdJ7fK/aQ=;
	b=nzFVggmkRiv7dfF64vvZVjVm8Vh2Fe3WEpFqfN7f69ZqYS/ZlA0qkA/Tu7G/bbYp1aCyvh
	220vpQroQcUXFQwuXPIGEsEo3jZbsjXEdxYMjCTe1PP9S9rdfrzgU5sSBcCh3OmqAXeP85
	i+pv+qfrKaCzYDjWG+RGAYUBwrLfCjM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6e/jGgT3foSA9psEQl1VWtIINfD0s81p21YzwZ3MAHM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203820; v=1; x=1794808620;
 b=uUiqqCE4mNZCA2gSY2PlcU0m66HYDSDToft4lv1qAHTstBmTV4+kugjrwjmfSZHc4t7ayPPe
 K0dOiLUe5geFBxDDfTqheLtXIFTxNXDQComAYYw3GhxHVSTJ/ifydPpAOwjI053nqUFmjnIjRIW
 myAALcuDc0P7YqR1m7fOckn4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id d708437a31d01fe9;
	Mon, 09 Nov 2026 05:57:00 +0000
X-Mizu-Trace-ID: d708437a31d01fe9
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
Subject: [PATCH v5 12/19] mm, swap: let swapoff destroy xswap devices by name
Date: Mon,  9 Nov 2026 13:54:48 +0800
Message-ID: <20261109055455.536925-13-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g1fzzt4e6abgogtbuhpuwzrbzmad71ee
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3A5AD40006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794203821-250718
X-HE-Meta: U2FsdGVkX1/t+InsG90AnIV3hFITXe5SrJZ7AXycD+R1fQEZ74qlJJdBWYoQ5lOsalpcif4tn0kH4h0RRG3W4+jmwESb65KSHw2UTh/ybRo3P/0sbdLD7Lsr+JfpLo+jrXPpfDym+AtyLsNalpthdSKFlZ+w/7qHA9D+5wWVgJ11SalZYvjXKtjqvwaQdu+uzmBsMT7jpWdWSnd1JFgjJK+pupUNM9BH2/5JWBqUhwHgqpb+7xyWD+3qtry6adibQ9C8I/jjMqHZ1960IMByVMSW5EAj/+SV6AJ1rD9N1z72F/4V6yh55Bf7Kgsqzlmrdy+RlaSAsVDM2QIWfunNk+wadk9kuWIAkWOrb3PcpU29sti6K8ioB/W8jlcVdnpmsHWM/0PG9fBm8U1Tu7XYiqGK112gUkkWcJDKf995XSN86nUdj/js7vkEXdTY1gS4iUMOj+wDsZD7Q4rpShWJw97D38MBl9KvSkgBDpuCCDxzALm7oTlLHLdVcAGhXfwwRFij8qF4L90+VTY56BWaGn2su7saIvcetu5cWFzzE+XFSvK/L61OsQDNZEexnFDPSLyXEAytZugryGq1Z83P4VG3E1R1+aOtkPV7u4csZrdDRMOwdriAiqtlsdJCwFERf1dvLlFy/5DO1LR4deusw89fFm8/gvY4mSl3iN5a4bbjS3d5PaHBdEn/ubf8nwT5vtFXkcHYF2qfmoTzE3Qi3dorUKEOXifGgVDwxJvdanjHOfgPH9DynOlt6BeMdux4YRvmR0C27iee8AHgkQWfk9MgsynSwSBTyvrRuPg/ZdsnIpHE+t51/Ww2ZRIjfC9HzO4ydZVq/IxpYcerODVAuKfs+41yS9hiLNuZRJzmi0vDPMAlGvLsw1eD0jb+zbEkZwX0yNg72hVn88ik891dleWk/H+dw645U58J4Gcqeyicv2yEElq/8A4Vk1qWMdwn+aaUDYZBIMaM6/sBctt
 hBRBRo30
 JxIDlIDecxvMGTYw+VXJbJCxinTOsLwyASgSYAu6iglIZlbmjmamUS23br2CEZvumh7U1XKiQDNuI1evuDcHVFUe3DbRwGc5+J9jwf+UsGH//XFCutX9TZ/90XowTds7z5YPgPcwFC7oP3yidb1+P8VkHC1GNLwdxp91lSiJzyD0tTn9ENfFsZJrS6pr5daiIxHcPpTlJRj2oEOxV1h6mErR2rEhdKkPOdjFplA5TikCT1e3sdncL3RL8eoLkDV95HOi9OpXdAIZAGjV/UyCVQsgisBMIxGODZoTn0cwaWgpnhOZ2Av8zmzgXTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

An xswap device has no backing file, so /proc/swaps shows a synthetic
name, xswap<id>, that file_open_name() cannot open. Teach swapoff to
fall back to xswap_destroy() when the name is exactly "xswap<digits>"
and the lookup failed with -ENOENT.

A real file or directory keeps precedence; other open errors are
returned unchanged, so a file that exists but cannot be opened is not
mistaken for an xswap device. The ABI documentation is updated, and
the destroy attribute remains the unambiguous teardown interface.

A well-formed name for an id that does not exist asks xswap_destroy()
for a device that is not there. It returns -ENODEV; map that to
-ENOENT so swapoff reports a missing name like it does for a missing
file.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 .../ABI/testing/sysfs-kernel-mm-xswap         | 11 +++-
 mm/swapfile.c                                 | 56 ++++++++++++++++++-
 2 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-xswap b/Documentation/ABI/testing/sysfs-kernel-mm-xswap
index 38eead0b1b31..f7e7f3e4d216 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-xswap
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-xswap
@@ -9,9 +9,14 @@ Description:	File-less swap devices backed by zswap.
 		for the lifetime of the device.
 
 		The name shown in /proc/swaps, xswap<id>, is synthetic and
-		is not a path.  It cannot be passed to swapoff(2), so
-		swapoff -a reports an error for these entries.  Use the
-		destroy attribute instead.
+		is not a path. swapoff(2) accepts it, so both "swapoff
+		xswap<id>" and swapoff -a tear the device down. A real
+		file or directory with that name takes precedence: if it
+		opens, it is looked up as a swap file and the synthetic
+		device is not used. Only a name that cannot be opened
+		because it does not exist, including a dangling symlink,
+		is treated as an xswap device. Use the destroy attribute
+		for an unambiguous teardown.
 
 		An xswap device requires zswap.  Disabling zswap at runtime
 		(enabled=0, or max_pool_percent=0) while xswap devices
diff --git a/mm/swapfile.c b/mm/swapfile.c
index cb53f9415de8..7b1d16226b7b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -34,6 +34,7 @@
 #include <linux/backing-dev.h>
 #include <linux/mutex.h>
 #include <linux/capability.h>
+#include <linux/ctype.h>
 #include <linux/syscalls.h>
 #include <linux/memcontrol.h>
 #include <linux/poll.h>
@@ -88,6 +89,7 @@ static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
 
 static int xswap_create(int prio);
 static int xswap_destroy(u64 id);
+static int xswap_destroy_by_name(const char *name);
 
 /* Stable device id, assigned at create and never reused. */
 static atomic64_t xswap_id_counter = ATOMIC64_INIT(0);
@@ -275,6 +277,11 @@ static void xswap_sysfs_init(void)
 static inline void xswap_sysfs_init(void)
 {
 }
+
+static inline int xswap_destroy_by_name(const char *name)
+{
+	return -ENOENT;
+}
 #endif /* CONFIG_XSWAP */
 
 static void swap_range_alloc(struct swap_info_struct *si,
@@ -3513,8 +3520,21 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	CLASS(filename, pathname)(specialfile);
 	victim = file_open_name(pathname, O_RDWR|O_LARGEFILE, 0);
-	if (IS_ERR(victim))
-		return PTR_ERR(victim);
+	if (IS_ERR(victim)) {
+		/*
+		 * An xswap device has no file, so /proc/swaps shows a name
+		 * that cannot be opened. Accept it here so swapoff -a works.
+		 * Only a missing name is taken for a device; a real file or
+		 * directory that failed for another reason must not match.
+		 */
+		if (PTR_ERR(victim) != -ENOENT)
+			return PTR_ERR(victim);
+
+		err = xswap_destroy_by_name(pathname->name);
+		if (err == -ENOENT)
+			return PTR_ERR(victim);
+		return err;
+	}
 
 	mapping = victim->f_mapping;
 	spin_lock(&swap_lock);
@@ -4504,6 +4524,38 @@ static int xswap_destroy(u64 id)
 
 	return __swapoff(p);
 }
+
+static int xswap_destroy_by_name(const char *name)
+{
+	const char *p;
+	char buf[24];
+	u64 id;
+	int err;
+
+	/* Strictly "xswap<digits>": no sign, no trailing newline. */
+	if (strncmp(name, "xswap", 5))
+		return -ENOENT;
+
+	p = name + 5;
+	if (!isdigit((unsigned char)*p))
+		return -ENOENT;
+	while (isdigit((unsigned char)*p))
+		p++;
+	if (*p)
+		return -ENOENT;
+
+	if (strscpy(buf, name + 5, sizeof(buf)) < 0)
+		return -ENOENT;
+
+	err = kstrtou64(buf, 10, &id);
+	if (err)
+		return -ENOENT;
+
+	err = xswap_destroy(id);
+	if (err == -ENODEV)
+		return -ENOENT;
+	return err;
+}
 #endif /* CONFIG_XSWAP */
 
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
-- 
2.54.0


