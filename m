Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5539FB5191
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 05:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9AE36B0088; Tue,  7 Apr 2026 01:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4BE46B0089; Tue,  7 Apr 2026 01:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14156B008A; Tue,  7 Apr 2026 01:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB2B46B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:40:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D77E1A068D
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 05:40:00 +0000 (UTC)
X-FDA: 84630658560.29.2B0DEB6
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5A9E1180005
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 05:39:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pGA5GoZT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of linux.amoon@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=linux.amoon@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775540398; a=rsa-sha256;
	cv=none;
	b=s3S5lpHmkcSBvLII/DHykUMa6q7WaGPr3kZlLczGRMBWxvWQMJiRytximeNeyz+aOv4CWb
	6erMCyERFqFs++TLwphYmKSuvRyoYF3nvEv98IsN1ltbt++SqwAWZLSVc5355ypZcaJZHT
	M9XYMNrGb8V84xsjEsn93cwhDbPySZw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pGA5GoZT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of linux.amoon@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=linux.amoon@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775540398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=c6aWKXGZ6Pq+U28ptkw+X3vtfA+Mw7YFFm3cXv1/n54=;
	b=3eFGIpLkGzrw985HDWYLl9Lc5lMD2looDEfkm3v9pIB/D5O2B/ivu0dhnykv1X0T1x41rl
	tQDLqSjXQasKKMtGJ6U2VRkfRT1yEb27+yOlOsOqEEkq0Ft4wQO8EZds6V9lCvEFFIDE3B
	7QqnxAFszuWgjWV/cWs4gVozMTExvyQ=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82ce0a9b3f7so1947494b3a.0
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 22:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775540397; x=1776145197; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=c6aWKXGZ6Pq+U28ptkw+X3vtfA+Mw7YFFm3cXv1/n54=;
        b=pGA5GoZTaaqGOYwLnVPM77keVkqHrn53S56IG52Rt4CFOBVy/ZkCdjKhizoIGf4Ed4
         Jl+9z1qCmL8nAgS9fWU/0m/hf1Yb3WD2p/aBdbrTNQTm59WbioIprZw5KFGriw4MZAAe
         RO3I/5o6BuB+isCMMj0vcPE8LzJ37HQmssYVBpVsrShzW+K0Bbo7am83z5VgL52ys6S6
         XgHYwYQaMw21Vdq7NLKMNDDK00pdBdPPcl3MBEDFEz+cRFyTYOTuH9WBLAZFUEXqiGfl
         neYm7gF9/VovWECRvfQj6x8lFVbJWgyk1jBXlVnahNCsfIl5d3T+5jUXvlyMx1j7msLG
         B5ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775540397; x=1776145197;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c6aWKXGZ6Pq+U28ptkw+X3vtfA+Mw7YFFm3cXv1/n54=;
        b=VkgEggYzVhnAgN2wAdt7BCZwoAtQ9QgPE1VmZP+IE4DV55Ua5gdcc6b+tr9UwEaM5P
         4n/KxXLsYjwC+LASPD2weN1vLOH4qeYlg6BTypvNAtp7U8hmZp5q1PIIvIiTMiF+S6AB
         tLhpm7YWCfgkJ9tt6f7+qL70qs1GV573by0+NrkMmDPq4AUIPTdfBRCC2qq26BvjbhnJ
         qzTmd7C+6GhbC0LH/5MzOsWZuvE1+d3d/5BXnjRrSPz9DQ1IRhpnnUIpKSV2Y51+5P8V
         7glpugjMAW7ZVGq8AfvGeD2BU//67qzjFIju/22wMm/TLHFE8EAhlM/se3hLUlltMknE
         Jy4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVt4Sy1AUS8HTXTCyrSXoWZPTcu1UYeEHK90b4LAjOhxbhSB+e2Bp2oB/Px5VcGwtxGrJri1AJ90w==@kvack.org
X-Gm-Message-State: AOJu0Ywo1lpN0CpAsJItqYgCXZvtAKTh9x420SV7s3TmWqlWNrgtQE7h
	y5fji9c1PgjtgLiEn7SOQeziVGnRvQmFGTAevRuCs03BiC2XO1of0xox
X-Gm-Gg: AeBDiesCh6mioRrRZMtfUwt0rBf5d48TKNRkiRw/94YM3DfKAWAFSI+HkfUeC1sRoN/
	EGfm3878XAycJiCvZSiu6dtMxwUEwBfk4UJMhBXVYFEiC/FE3+DMmWUf5x7+NHcPao43PE2Q7LX
	KWTQe3CEkmIzpZk30qQADod5i002s/qnPtq/d9IH+PxNhldp5+IDn2kPmO7T/Xt/sc9a/zAtdy2
	s19lpH4ZSHZ6Mg3gy26+V4ccGJg1WqkXnr8YUE3oyd8b9EkrG4aYUZXup29x6lYcFLM8VJ0tKWc
	uFEoOqkESGpYoi0j5eCHKqCNdpxqFVTXhT6jU0gjNtfDXuT8Y+EPSioztNIPH6ejckxdjcOiP7k
	nV2CKQTUUlAc+5bA3b7HNrZ9wvUiaJuICF5X/ueEw+6P6VDX315D7sFQVKSURWfx904QvwcvP+S
	W1M7yfejgrGyjEezA6EEDh
X-Received: by 2002:a05:6a00:ab87:b0:82c:dc9c:e770 with SMTP id d2e1a72fcca58-82d0dbb2ad9mr14100756b3a.40.1775540397159;
        Mon, 06 Apr 2026 22:39:57 -0700 (PDT)
Received: from rockpi-5b ([45.112.0.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9b23c6asm20873248b3a.10.2026.04.06.22.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2026 22:39:56 -0700 (PDT)
From: Anand Moon <linux.amoon@gmail.com>
To: David Howells <dhowells@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Douglas Anderson <dianders@chromium.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Randy Dunlap <rdunlap@infradead.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	keyrings@vger.kernel.org (open list:CERTIFICATE HANDLING),
	linux-kernel@vger.kernel.org (open list),
	linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and infrastructure)),
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - CORE)
Cc: Anand Moon <linux.amoon@gmail.com>
Subject: [PATCH v1] treewide: Fix indentation and whitespace in Kconfig files
Date: Tue,  7 Apr 2026 11:09:34 +0530
Message-ID: <20260407053945.14116-1-linux.amoon@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5A9E1180005
X-Stat-Signature: himsduk4ia69iqdp98u3dcj8hnhoukxp
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775540398-889656
X-HE-Meta: U2FsdGVkX19U04zy6z4SaT4w/gpZJRusV9kgbIaklkh35teHkUcex6LIgb/dn83TKSr8Ml9K//5d6VQACaVo6juayBOfhQY6FBSg94ooNQP7vvD/Npq/UM7KR6ULX9ppBQlXdd/cBwDmB/bZRmW2FJ8xD8P7RGWW4brru4IdgnG1bECPZqtc/hKuhsuLkkXTDZaKkwRMeffK9XOQuOT0ZzGv/j0mnMATTV2rlFpIqslbV6B9g0rqhgceeXMyOITWSvNIzEVPC2VTdE5DOdtgH1PtENWF3sn2CCeHV0ZB8yhevM/ZGdMduVvN2xOKGZD2xCqHpjzO46lAp5Aw4ZY4/T2Y1kIeQ2KbVurYHBuXlqBzyilEYpL0WE1EEFS2e3grn8TxHz+XtYcuwRp5b3y21l4TaE1f+pJuZGqVcuViVIIzzmCIQuPTFusqCBJ2G/UQDtYERW6sTyTLmdaQ7fTnSsrgD2syq/WzllJ/mczhYG0oF0x3F2X206/ciDbYSZSPtNFNe6gptpBSXfjU6QGrB4NALOaJTIBVEm1J6RTAjcSxVd98iMMg2hOltTKDImjnxXapmjvBEXRTQGHqEDfgnHwGTZm6PNcBDwultM52ahksZs6dwVMbA30PBO8Wj+1iypILzh67PBUroeFRbpSjLjJKPT35neuxly+eq9ekkMtjDwCNj1QXKAbcrSn7+1mO3KQqAdYfxSdCOgzzW4kwVXupHOsT1oIMSV0cVo/DiSlgQHWO2raWkZFkbX5Rt35jxLlfGOhkCYsGLj+07svCUtDbON0iBk8aHwCdx7m8rHy1cY713jG/YUAANLRwhHxudN4j9Bp4teokCv4xclCxuqQTMgXQ1Yf6KE6exW2earaJBU01C6407x2ssXgDAfdQ6r4Siurjs9mojSJ+e2is1JKsuijoQrismi+58EAaVo+Rt+QMpMsRT6A6XBvKBJj+MXXQdTPzkb0oZVwTnpS
 Y8yzoUwa
 aMYKcjN/n9q7t0vSuDH1fQiRID9Mw5ZihCRgr6+Iaw3x1xIterEcfBmkHbAt5I4DOIr7vgjuFSf46f/NqupuG42WNUp9eTqziq8Tp+6kJObpkLCjeweH5iH8loUBdVimrLRJqeZ1ZXuzeYxAmoFSk6+/IdtTqa3CtYw+92rkYAzEIVE+Bg9i4gElYKhY2PJJc/BZXykUjzp5lqUSDFEVO3cgEU9wOnSVY46INT4ytruhPmbN4K+7mk+zB0kgNC/+UmhbI+tlief/smMq8qas3eCYsUK8D6jO06DESG0GpClJqDwy2opgE4qnOnjlU4H+dHM/erxwkWmIhWyk9elVQxgjeH/opoNhhKR3MH3Nm/w+cFNvL1i31fZXfWGcbZQIUcX3GCiPEScxijWy775vRjnlx0XpwOB9F9Q8mKLMC5x4BgBEUiKcU1QZqPDBNJHNoSbIJtmmysrUMTJxMHAzYSGWCeXh90gxiMwXTH3rJvtaRGaIs7Y/JfHMNcluZ7GWfOwjSfOlcprbnD/tQiwc/9Bmjkf36sDboBaZfN1FcX6/WeemH9sAA48lC4CBTwDjOx6OEQqX1a6PI7B8RlnJxYU6ocDg/YsPdws7qrz92zu0QLGTAO1V9AnoEBNohHJ5GZwQ7R5ONywL8djrCXny++GcQxKCWbl0jJ1DEthGISEj7QMNY6esL0cVItXy7JDE20IMTdZE/HC8vYueEvMBdOV+Fh5I4t6rHjlXfLw3hFqoWqQOC9YW18npD9Qkf3WbjGuhcmrOl4goaDarL916D0YHhWZxJm88uFaepkTRIQ0QFjetm+OyYtUR0Qccvt0OX4lTVAxyzxllscdtSKEMvH8uLT0wegM9S4It6AHEQGA54QV7YqERD8tbm8YKHc/WfQ6ZeNoqOVTmH52mjxda5oiCuJeS6LSjP26VNDUtOo5zuJw2q+v5XyOJRd+H64t73NQND8tCsKVSnbviKnu0m2UieTp31
 4+8XUotC
 0X20HPRQsMYOZj93o8iHdHt9aYGJTld0mF0EE5WYX6ON4V9iNnq9TGiAMTi5FV6YkmC2uYWjWhLsVZkpr75E1mNmPEF8kef5NMXUnrn8bMFmhYoJoGJlBv2y/QVKT9fqLUXFxHSnFxFlZRSFYOjrcOCaZvRiTr+uNTyNi02/Ws/x5A8VNhhtOwkYKFFkYvDojGFvUP4Q5FZKa1FU20GgC8MOLxaN7jsN9IlYcMOMAQ+Bxg4m2bD8uXtanhJaUAtSRqCTTxLbSJ46qGNzLxUsoHUQt2JFrcju2BwT5+xcQW8/wJ3fHyHKM9EzxccUgAbSm0AMfc1FXVMgNMJy+fNY1nuPII62+BcdOYNj5elu5X8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Clean up inconsistent indentation (mixing tabs and spaces) and remove
extraneous whitespace in several Kconfig files across the tree.
This is a purely cosmetic change to improve readability.

Adjust indentation from spaces to tab (+optional two spaces) as in
coding style with command like:

$ sed -e 's/^        /\t/' -i */Kconfig

Signed-off-by: Anand Moon <linux.amoon@gmail.com>
---
 certs/Kconfig | 16 ++++++++--------
 fs/Kconfig    |  6 +++---
 init/Kconfig  | 24 ++++++++++++------------
 lib/Kconfig   |  2 +-
 mm/Kconfig    |  4 ++--
 5 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/certs/Kconfig b/certs/Kconfig
index 8e39a80c7abe5..9d2bf7fb5b9e4 100644
--- a/certs/Kconfig
+++ b/certs/Kconfig
@@ -6,14 +6,14 @@ config MODULE_SIG_KEY
 	default "certs/signing_key.pem"
 	depends on MODULE_SIG || (IMA_APPRAISE_MODSIG && MODULES)
 	help
-         Provide the file name of a private key/certificate in PEM format,
-         or a PKCS#11 URI according to RFC7512. The file should contain, or
-         the URI should identify, both the certificate and its corresponding
-         private key.
-
-         If this option is unchanged from its default "certs/signing_key.pem",
-         then the kernel will automatically generate the private key and
-         certificate as described in Documentation/admin-guide/module-signing.rst
+	 Provide the file name of a private key/certificate in PEM format,
+	 or a PKCS#11 URI according to RFC7512. The file should contain, or
+	 the URI should identify, both the certificate and its corresponding
+	 private key.
+
+	 If this option is unchanged from its default "certs/signing_key.pem",
+	 then the kernel will automatically generate the private key and
+	 certificate as described in Documentation/admin-guide/module-signing.rst
 
 choice
 	prompt "Type of module signing key to be generated"
diff --git a/fs/Kconfig b/fs/Kconfig
index 0bfdaecaa8775..74110311968aa 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -78,7 +78,7 @@ config FS_DAX
 	  --map=mem:
 	  https://docs.pmem.io/ndctl-user-guide/ndctl-man-pages/ndctl-create-namespace
 
-          For ndctl to work CONFIG_DEV_DAX needs to be enabled as well. For most
+	  For ndctl to work CONFIG_DEV_DAX needs to be enabled as well. For most
 	  file systems DAX support needs to be manually enabled globally or
 	  per-inode using a mount option as well.  See the file documentation in
 	  Documentation/filesystems/dax.rst for details.
@@ -116,8 +116,8 @@ config FILE_LOCKING
 	default y
 	help
 	  This option enables standard file locking support, required
-          for filesystems like NFS and for the flock() system
-          call. Disabling this option saves about 11k.
+	  for filesystems like NFS and for the flock() system
+	  call. Disabling this option saves about 11k.
 
 source "fs/crypto/Kconfig"
 
diff --git a/init/Kconfig b/init/Kconfig
index 7484cd703bc1a..6fea1453c2941 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1036,14 +1036,14 @@ config PAGE_COUNTER
 	bool
 
 config CGROUP_FAVOR_DYNMODS
-        bool "Favor dynamic modification latency reduction by default"
-        help
-          This option enables the "favordynmods" mount option by default
-          which reduces the latencies of dynamic cgroup modifications such
-          as task migrations and controller on/offs at the cost of making
-          hot path operations such as forks and exits more expensive.
+	bool "Favor dynamic modification latency reduction by default"
+	help
+	  This option enables the "favordynmods" mount option by default
+	  which reduces the latencies of dynamic cgroup modifications such
+	  as task migrations and controller on/offs at the cost of making
+	  hot path operations such as forks and exits more expensive.
 
-          Say N if unsure.
+	  Say N if unsure.
 
 config MEMCG
 	bool "Memory controller"
@@ -1125,7 +1125,7 @@ config GROUP_SCHED_WEIGHT
 	def_bool n
 
 config GROUP_SCHED_BANDWIDTH
-        def_bool n
+	def_bool n
 
 config FAIR_GROUP_SCHED
 	bool "Group scheduling for SCHED_OTHER"
@@ -1625,10 +1625,10 @@ config LD_ORPHAN_WARN
 	depends on $(ld-option,--orphan-handling=error)
 
 config LD_ORPHAN_WARN_LEVEL
-        string
-        depends on LD_ORPHAN_WARN
-        default "error" if WERROR
-        default "warn"
+	string
+	depends on LD_ORPHAN_WARN
+	default "error" if WERROR
+	default "warn"
 
 config SYSCTL
 	bool
diff --git a/lib/Kconfig b/lib/Kconfig
index 0f2fb96106476..4b0026954a370 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -589,7 +589,7 @@ config OBJAGG
 config LWQ_TEST
 	bool "Boot-time test for lwq queuing"
 	help
-          Run boot-time test of light-weight queuing.
+	  Run boot-time test of light-weight queuing.
 
 endmenu
 
diff --git a/mm/Kconfig b/mm/Kconfig
index ebd8ea353687e..10a4ce4247fa1 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1304,7 +1304,7 @@ config ARCH_HAS_PTE_SPECIAL
 	bool
 
 config MAPPING_DIRTY_HELPERS
-        bool
+	bool
 
 config KMAP_LOCAL
 	bool
@@ -1435,7 +1435,7 @@ config ARCH_HAS_USER_SHADOW_STACK
 	bool
 	help
 	  The architecture has hardware support for userspace shadow call
-          stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
+	  stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
 
 config HAVE_ARCH_TLB_REMOVE_TABLE
 	def_bool n

base-commit: bfe62a454542cfad3379f6ef5680b125f41e20f4
-- 
2.50.1


