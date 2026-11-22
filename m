Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D05F5606A331
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SvdpW7rk
Received: by kanga.kvack.org (Postfix)
	id B10636B05C5; Sun, 22 Nov 2026 07:48:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC07F6B05C6; Sun, 22 Nov 2026 07:48:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C6786B05C7; Sun, 22 Nov 2026 07:48:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D76B76B05C5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:48:26 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 58C151C402B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:48:26 +0000 (UTC)
X-FDA: 85462733412.20.C2B5278
Received: from mta0.migadu.com (out-97.mta0.migadu.com [91.218.175.97])
	by imf12.hostedemail.com (Postfix) with ESMTP id 46B6A40006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:48:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SvdpW7rk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351704;
	b=WfBoEiUz7kWZlTaW0SSk+EcQos0YlbVuO2VrqvWRUZj3z7ivtWRTvyZ37rIptBPaOWdZ0B
	UfqRI29u0GfaKa341WcK1Nn1uJx6bxcE898Q1I/oWD+CoiWdM6lkxMgqVCKtgu7cgbbccM
	cImNeaMkPSWKjzidvJRMxYKbuzH93Q0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SKq4d78n01SVC2VW19hE1ndR5ln/BxTtcRQujOEifIQ=;
	b=wL+GJjocOgYZbeHXtW+qIZHuLHgDkxUdx2h60gsh1y1P87f9G46STw79f2B7XSlmJVZDVU
	i29T2FrBwOyomM00Lo4Uq0/A6EduBAdTGCE0UMLI3GDpfDE1YwYEuBQx2qgGs4fiILIE4A
	cdPHZXamugpEu61QIG0jCxBy7h0Qrts=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SvdpW7rk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ujquToUOLxKJlHHoO0pZiNh3GDpoieF8dRRQL2lLvKg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795351703; v=1; x=1795956503;
 b=SvdpW7rk2TsOJZhrK1pwrudM8iJbm3T238k/Cdbw82s6bz5PRZde/dfs+MTaYrCy45CBwXHj
 31DsW/LdjeHmm7AwpsFD6OSdxtnRAqwjiyIjqRtGMkkssLKmIB00dxMtTLNZ1gb0g8eRLump2pd
 bahFe4WtbcyRaKVLgUwe7n6Q=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 92e1b5d813bb7811;
	Sun, 22 Nov 2026 12:48:23 +0000
X-Mizu-Trace-ID: 92e1b5d813bb7811
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
Subject: [PATCH v6 10/14] mm, swap: add CONFIG_XSWAP_DEFAULT_MAX
Date: Sun, 22 Nov 2026 20:48:10 +0800
Message-ID: <20261122124814.3489077-1-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261122123918.3486916-1-baoquan.he@linux.dev>
References: <20261122123918.3486916-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 46B6A40006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: m4stmebj9rc57dcgubuxknymiqw6r44t
X-HE-Tag: 1795351704-581920
X-HE-Meta: U2FsdGVkX1/3rjIMImoWgUOPbU61QD3ErkZLCpNXyj6Sdg73mG3NTLRxIGNRqXvBn98DLlhvZfyb6DPWFoyP1odwb3GanBXbf1QW76w1U+BB4zxIlB720qEhlNzqx6KqZtBuA1C85ylgFC0W1ypTCVao/lCVgnqbp+z7KD1WMYo8nlroeSlsTrK0VXD9JdHSg6xyzObrom2fO/NmQCviRZduEpGOYI5PtZnQbPiLIjdgvIy0svxjaahdRJrdAF53UckOKmiXJ5/+gjFmJVEFMOoziC1eRJVDvWac1R6piAsriNkKiUh3W5Vh0yMIZRC+NYkX96D9jOCugs35w000pIFrjPXFTxNEFFOY1t+xuACfbJ2wkWPuecJLXR0EyNgfEvfHYHKa687wKGrDkv1/+83wCm5dvCAjNKpQ6+OPMgW14Gvgf0s8bqgIcueO/atNfbRMATPMSnPvyoS+mGPrgBGxn4kmy0a+qCPa+V7E8FTw6vZErDo6nlC5nx9G11WIqiXzrEAUSG67z0+ceXM3ide/l3ApB2OUTclVfsT67K1hZMJPDiAX2EyIj3q5hwS+eq6Uia23LX9JYaJ7SXHzXqie36mnPMqLR5tvwvVfQ5sFCNgm719b6UCcmiwWplEVwWMjK5iHhzRgUqyKfUTMiKxuIaTK+SfmBWPl9owjNUEaoVoRqSzeSu74/P9DanqdF2vHnR67toKM3kSQv5XEa7YKISpy+Q0KkWwgmzYy1kXGMIPfrKrnNhPP3vHi++HCskKLn4DAbg09GrKPUxbfa7qtmwY+ykE/+QnOIMyG0iUJqtAFWaaGTVPsnPhNbz2IYguWzrdmw71Y+I+0gbb1+k6/O1U31o+a69b5/UJJDDjj/vEh1T7fEpmGkIPcwzHpue6NjlmOpheUa+WDxydhfV116w/5cRKHX+FHU+Dr7gR110vha+aqaWdPCHXpOvEDQBbUeO6CNcXl1/w5/yT
 4qEHEyAE
 v2UC35qB1ueGREyyGsdSH1K5tgjOYZX/Wh+aPxDy1O1Iqp+WLX+rhjHcvYfBQvTrzQzq2nJxidxiFoEndLPYixeYDuinQDyvqYjwqAcGLsHa014FGX1ejekVBHWLjwbKk+T8KWZNFYiUAYVn3oHAmD5AzKi6jPIHEz0QYqvHXnyMXjZg+ecRNidzQ/AwAMst/AFjLFixbTNioTkYhqTGk44S6l1XN4urzrMCQCyj4aqYgiuUzqLQqw9GFoA+qv0ibTyZdLvcnGyWiR+K3YcRXDv93DIMFA3ia8l8ntC7DbDDdAs3/Tl6Q58tx/HNPVjQ4PIsRq4EDE2QuGf/GBNoRkN1raqg5xWv1hztNhQoD1o+la6SJFWamMLvfaL+Px4iaW4VfFMJ9R9qWCYAsrE6F+s52nAO8HAJWFhvu68LFKvuS372SdR8jz89oQHi3P6oMupuLRcby+hhXZbaGxSR+E9f3KTwPrfUaMYAUCVMyDQqbXsHRhOmIMF3dkDZ3H2gsJ81QHnesMe49OjKSueR1j9qaZI3mzplsVyMCvz51r88mQ9106mwu28gaLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

Add a build-time default for the size of a new xswap device.  The value
can be a percentage of RAM, a size in bytes, or "max".  "max" means the
largest size the device can address.  xswap.max= on the command line
overrides this default.

The build-time default is clamped to the device limit.  An explicit
xswap.max= that is too large is refused.

If the build-time default cannot be parsed, or is a byte size below one
cluster, use 200% instead.  A percentage default can still be below one
cluster after RAM is known.  In that case, device creation fails.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 .../admin-guide/kernel-parameters.txt         |  6 ++--
 mm/Kconfig                                    | 11 ++++++
 mm/swapfile.c                                 | 34 ++++++++++++-------
 3 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 9928f0937514..06d37212399f 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -8733,8 +8733,10 @@ Kernel parameters
 			off	xmon is disabled.
 
 	xswap.max=	[KNL,SWAP]
-			Maximum size of a new xswap device. The value is a
+			Maximum size of a new xswap device, which is created
+			with swapon(2) and the spec "xswap". The value is a
 			size in bytes with an optional KMGTPE suffix, a
 			percentage of RAM, or "max" for the largest size
-			the device can address.
+			the device can address. The default is set by
+			CONFIG_XSWAP_DEFAULT_MAX.
 			Format: <size>[KMGTPE] | <percent>% | max
diff --git a/mm/Kconfig b/mm/Kconfig
index a8707bbd8d62..f13639a811e2 100644
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
index 6ce5dbb3b103..074c5114d129 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -77,9 +77,9 @@ static int xswap_destroy_by_name(const char *name);
 static DEFINE_MUTEX(xswap_ctl_lock);
 
 /*
- * Size of a new device: xswap.max= if given, otherwise the built-in
- * default.  A percentage unless bytes is set; "max" asks for the largest
- * size the device can address.
+ * Size of a new device: xswap.max= if given, otherwise
+ * CONFIG_XSWAP_DEFAULT_MAX.  A percentage unless bytes is set; "max" asks
+ * for the largest size the device can address.
  */
 static unsigned int xswap_size_pct = 200;
 static unsigned long xswap_size_bytes;
@@ -87,9 +87,12 @@ static bool xswap_size_max;
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
@@ -118,12 +121,16 @@ static int __init xswap_parse_size(const char *str, const char *what)
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
@@ -132,7 +139,7 @@ static int __init xswap_parse_size(const char *str, const char *what)
 
 static int __init xswap_max_setup(char *str)
 {
-	xswap_parse_size(str, "xswap.max");
+	xswap_parse_size(str, "xswap.max", true);
 	return 1;
 }
 __setup("xswap.max=", xswap_max_setup);
@@ -4175,11 +4182,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 }
 
 #ifdef CONFIG_XSWAP
-/*
- * Create the file-less xswap device, sized by xswap.max= or the built-in
- * default.  Called from swapon(2) with SWAP_FLAG_XSWAP; there is at most
- * one device per system.
- */
+/* Create the file-less xswap device from swapon(2). */
 static int xswap_create(int prio)
 {
 	struct swap_info_struct *si;
@@ -4694,6 +4697,13 @@ static int __init swapfile_init(void)
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


