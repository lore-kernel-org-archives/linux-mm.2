Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57C5F606A7F5
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 11:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=q3sJfVzJ
Received: by kanga.kvack.org (Postfix)
	id 5A6ED6B06CB; Tue, 27 Oct 2026 07:43:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57F046B06CD; Tue, 27 Oct 2026 07:43:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 495816B06CE; Tue, 27 Oct 2026 07:43:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 227366B06CB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:43:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A18171C43A8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:43:23 +0000 (UTC)
X-FDA: 85368220686.05.E855FF5
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id C324780003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:43:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=q3sJfVzJ;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf30.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.180 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793101401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZcYX7S/IRLmRwsATrT9hZb6l/1JqthXKat4XzKms4c=;
	b=QbcqjzUUxQVvnjSMzW+dJzNC+xJP0WXA4v6ti3JLFsrrvC8NQ4NkDl6DtYMFSCp7cQ/cdf
	khRd1ehzrxY1Nb4Joe9b4NYg0qaDuhClq/HwMeoxVYg+VQjYaV85HumJnBybJMVZgeWQxo
	DGx+ORbk0NmM1P8m82cokzcyCpu7nV4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=q3sJfVzJ;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf30.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.180 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793101401;
	b=2gEEc6lrUrS+db8kQznhtkzQ1Gd4YDd8CTJpMwYveMDXAMGVwN/0+ae5tytqPzcfkk6kKv
	DPJSLpDqB1RV37QkihZ0AZ2IxWcgpOLuqDwJKResbfS5K+I3jlkWsVIkSyOAZm3DTvcxy1
	gf6rq/0UpFfoC5seXQPSxMwGgwsQqRo=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8a594d313a3so1138314b3a.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793101401; x=1793706201; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zZcYX7S/IRLmRwsATrT9hZb6l/1JqthXKat4XzKms4c=;
        b=q3sJfVzJ7G1yhrVjQ/ZqHQjeObeFyNbI6V7owuRy/9Y7MAOb8DfPAWEj+aF18Wy9cv
         1FTe4rhKUxfhZIr05aCyse4wB/pNR4OQS8yTsO13d0CvJ7tQwpnhqmLytHsV5cf6D+RS
         x00/VTM34P6y+Sx08KEMsR/aVGC+LkjvMxxMM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793101401; x=1793706201;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zZcYX7S/IRLmRwsATrT9hZb6l/1JqthXKat4XzKms4c=;
        b=GOJfmSHE86tArL2uHDJV2Plg+YV4c1AiOWqLD6//S5gxs5qCvxZesGX6AXKmabp24Z
         Q9V/fLvb8frq0hOBVcgzIIzIN7378ZwxzSWrxKQsoCTp9Pv1a4DUzN7yhCSvr+AutIXY
         1A8ySbpwcfQsxppTd5ghKUcqjN1GmuReLoiA+PjNIHJnch+/AGvJMHeJ5b66ugNUBAw1
         02/bpqsy0KDu6FYVliibN6fGZdiKsvv9rIcs+qmmZhj/+knUpQWrhgeqBmkJq5ZBHBQe
         tQ56q0AiboxNMJm1CQmPeLOSGK+cqldtxPoe+fVNVkvzCz1XF3RFhk3Uu7/EZYa+QGgE
         eCoA==
X-Forwarded-Encrypted: i=1; AKwUvBwRV7fRgQrNfkw1FRGbAmzjICknEl6+lVVBPqb927+E3uhuhS5Mom4CHgLs6N6Em1ABnHeXFHDU2Q==@kvack.org
X-Gm-Message-State: AFq9FYKvdaDXBN7/50kYhpnpkE2btQhH15xQ1rDZCqFsjjR13bv+wA+k
	frEor2NWPDGZMdHdIVisH5GHEXhaWTsjtW3GRAEj3FlTvvIvmkMq253wPl46wpVw6xs=
X-Gm-Gg: AYBFou338g//ZxuDaKILSJgo4FpIRdIqCLn5/P+Hv0ipa95FMXoRPkwzRgCekjS8J/a
	vbe62aqEaxY9p5Tf1T5RUbN2bBDrTkhbINH/Vakcpemxeut2/7Jb7oB6E71EG5ubrQ9Idkszjco
	Fwd84oQds3IkFQr3JOLuBOG6YoAYMNNwnYSiZr7oYxGML79U5W9OR6ghqZF34zXrqvLT+46eLIE
	JrJcmkl5Oo2KwsIPHWkZ+DsP8CtWoQ8fT/VPlos+G/tiLZJnLEb1RisgGUBcNViK9s9TD0GEB7W
	m/FhotUS8MjInyoWqyva9BKsNmEGeD5yMFmWNtJ0TMXgLNd3AIpyi+4L9CrpfYtjuqy12vEWVms
	uj1txDxE1aklQ+PlxjWzzOZ1ZZKVCtuciC4wCq9mqVzBePu1StRNEmRlMImbBYE4u5RLn4tOP1h
	Zem5ytxPoVSsyP5DXfXC0xcNqMVHfcsBpYR+5l54f9azmzUwP9d/Tkn2993yDvw8YngIEOlZjyD
	K+Z+rR4OJ3YijWLqp9yT5ap8A4j8nyOPoW3/41x5/m1IO8aeFkES/CoDy+jOXZb7wM1n9h39usE
	mMh2YBga+KO0jsqYpDjK1pG5RSHMWSLCiHbuiFbPIoWi9Yt7OGx+Sgj5YTamge2LeX/Hlrmhghj
	yQQ3ypW4c1Hu7RNh2uDSmnOY=
X-Received: by 2002:a05:6a20:db95:b0:3de:7dd6:ff8f with SMTP id adf61e73a8af0-3e7bfc0fce4mr7504911637.50.1793101400652;
        Tue, 27 Oct 2026 04:43:20 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ccc21274sm2604064a12.8.2026.10.27.04.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 04:43:19 -0700 (PDT)
Date: Tue, 27 Oct 2026 19:43:17 +0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>, Andrey Vagin <avagin@gmail.com>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH 2/3] mseal sysmap: Allow with CHECKPOINT_RESTORE, default off
Message-ID: <7ff59c2ab6c234ca4d799f862eb7c3f22d671f99.1793094611.git.chris@chrisdown.name>
References: <cover.1793094611.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793094611.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C324780003
X-Stat-Signature: nckrudwk3os5sgxyukn5chtrhertnimd
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793101401-113899
X-HE-Meta: U2FsdGVkX1/TmDl4zQLZBteQY2l8AJzy3YsREj1cqlmyy8gBaXviav77uia3L8o9oCJeBKvfr9AeCGB+CMBXsqsOPxAdJzN3J7qHWducqKbl9tAYw19AQjKJO7NiiYKAJcGzmub9BwdEvnSxBv8oBISiJSV2JAn8c7DTwZXw8Tk2yy8eaZfQ4f08/wuML6LjN9xFJs97lkmncQIpJTVHuJzEHbUjq7yElQoKtVRqW5PQqj884tm9S9fefpCHyCL+qYM+8l+9YBVXXGQKL21Gr5vCbaZfM3hiHA2tF8pXd65PA4jmjrE3FAz3X2hSq7rGZcmoAfc1gqqP2uMBKKna8y3At0LOS4l3yuZhdMMklqW8PC4IJO9Yo1wbEo/ZLnNAV8gyFk67qcRwD5LRfhU1qe1bKrfVo+IkYCrMN5eVxDMPJL6Auc1q3Ium3IdUlSPo3xXjMBFQpiEwSNDM6JeWS3yLJuXNrlLiuFRVesdbUp3+9sKVbp8ZQh0TmFhXxZshkO4nRNGA1K+Z2D+yZHZUNfaBXZWJ1PPD0cvn4pjemVxKAJmum3bso7KoKU/8m5if2LiShHXTKtDZdMHWFnKDk+7H+quQj6H+rAIEemRYz7CJaifAwrMZFvz7q1UvnDGvqVBhWgUlNajM0U4x5YPmQT26bb1YXDcB3MFsmCy60EZVeMBfw/2LNMH0mn8tu09c8ARfjkhe4jZhM7c+9W5/+GdG/UNnnZEyfqOD0kO0LPcP4QWuDTjvwRWFzoJV4SiuZ41yuD6CBfjo+VSuI5Pg3MIh4Qx7A7uCyJ7O9UgeU0AW+2dVtqCTrzRapLH8oJjkc70TO+5m+6EhaFVyz8df/6iTxGYytPMknG34b219mbaK9tSgG0M2Zg/Px00KB788gmDw7nO3pLsuWvUyXbP/gA7Op/QL4aqecOB2CKJegsXShABaErUnsjXu/JErmUYNbECSNl9dfSfbZ9Q3nMV
 yBl/XfjH
 q1B9E9SowSKK91RemXfYeFTK8hciJcs+mMOgeFFqxAfFC+qmxgJcl6OWjftFuxiedFQjWTcsiJzDPHBsp6sZfYkrD8pR9VOihu0lmsPkwxN9W7+pQCAuEFDa5u6mDSvrK1aJv1hC8yHZDF6OC8lHnzJ6nmkQki9Feiv+0FobLWSSGZJ+xo6sgjIxk9rppVuuCdWT6kH3F57oN/ugBxA7U+pUm2gkikPQRlYSBU2gOdeMUQyvm5lwmb7JNm4bfmNdf6KNTYjE8UzgfA1c/Ttw74QeStQVrz5LB/cKempUu55cJ/k5WBF+DTSxV6prCX9RJC4utcAlKQYPOJiRW9q+61P+8VwoUpfJWrCYJbLC4468xqDX6K5OLZFX7D5xBbJweHLCjDsSGH3TkIlWPxWqCkev5H2P4T0Q19UzpgCk+wgD624hx5b7rGEqY9wkSNT+So6hkkjhdcbEPKjcM25S/X1JSxIrHR4DQe1/JsVV+CgJA1U/h+ySAwEf58686wLNZiQk7lWjjhnwB/uY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

MSEAL_SYSTEM_MAPPINGS depends on !CHECKPOINT_RESTORE because CRIU moves
system mappings when restoring a process. Now that sealing can be chosen
at boot we should instead use this to determine defaults.

Let's add MSEAL_SYSTEM_MAPPINGS_DEFAULT_ON and move the dependency
there. Existing configurations retain their behaviour. Kernels built
with CHECKPOINT_RESTORE can build sealing in, but will only seal
mappings when explicitly requested with mseal_system_mappings=1.

Hosts can also share a kernel built with MSEAL_SYSTEM_MAPPINGS=y and
MSEAL_SYSTEM_MAPPINGS_DEFAULT_ON=n, enabling sealing only where needed.
This lets hosts which need sealing share the kernel image with hosts
which need their system mappings to remain movable, which simplifies
deployment.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 .../admin-guide/kernel-parameters.txt         |  2 +-
 Documentation/userspace-api/mseal.rst         |  4 +-
 mm/mseal.c                                    |  3 +-
 security/Kconfig                              | 17 +++++++-
 .../selftests/mseal_system_mappings/Makefile  |  2 +
 .../selftests/mseal_system_mappings/config    |  2 +
 .../mseal_system_mappings/sysmap_is_sealed.c  | 42 ++++++++++++++++++-
 7 files changed, 66 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index b1ec9a8a979e..628f4cccd38e 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4275,7 +4275,7 @@ Kernel parameters
 			whether system mappings are sealed for this boot.
 			See Documentation/userspace-api/mseal.rst.
 			Format: <bool>
-			Default: 1 (enabled).
+			Default set by CONFIG_MSEAL_SYSTEM_MAPPINGS_DEFAULT_ON.
 
 	mtdparts=	[MTD]
 			See drivers/mtd/parsers/cmdlinepart.c
diff --git a/Documentation/userspace-api/mseal.rst b/Documentation/userspace-api/mseal.rst
index 4e50215e4762..c1d6dbb006dc 100644
--- a/Documentation/userspace-api/mseal.rst
+++ b/Documentation/userspace-api/mseal.rst
@@ -143,7 +143,9 @@ Use cases
   If supported by an architecture (CONFIG_ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS),
   the CONFIG_MSEAL_SYSTEM_MAPPINGS seals all system mappings of this
   architecture. The kernel command line parameter
-  ``mseal_system_mappings=0`` turns this off at boot.
+  ``mseal_system_mappings=0|1`` turns this off or on at boot. The default is
+  set by CONFIG_MSEAL_SYSTEM_MAPPINGS_DEFAULT_ON, which is off with
+  CONFIG_CHECKPOINT_RESTORE.
 
   WARNING: This feature breaks programs which rely on relocating
   or unmapping system mappings. Known broken software at the time
diff --git a/mm/mseal.c b/mm/mseal.c
index e0563796cfa3..8f2f2a149915 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -19,7 +19,8 @@
 #include "internal.h"
 
 #ifdef CONFIG_MSEAL_SYSTEM_MAPPINGS
-bool mseal_sysmap_enabled __ro_after_init = true;
+bool mseal_sysmap_enabled __ro_after_init =
+	IS_ENABLED(CONFIG_MSEAL_SYSTEM_MAPPINGS_DEFAULT_ON);
 
 static int __init early_mseal_sysmap(char *buf)
 {
diff --git a/security/Kconfig b/security/Kconfig
index d5e83af1bfc6..6a6323e0897d 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -53,7 +53,6 @@ config MSEAL_SYSTEM_MAPPINGS
 	bool "mseal system mappings"
 	depends on 64BIT
 	depends on ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
-	depends on !CHECKPOINT_RESTORE
 	help
 	  Apply mseal on system mappings.
 	  The system mappings includes vdso, vvar, vvar_vclock,
@@ -67,11 +66,25 @@ config MSEAL_SYSTEM_MAPPINGS
 	  of writing includes CHECKPOINT_RESTORE, UML, gVisor, rr. Therefore
 	  this config can't be enabled universally.
 
-	  Sealing can be turned off at boot with "mseal_system_mappings=0".
+	  The "mseal_system_mappings=" kernel command line parameter can
+	  be used to enable or disable sealing at boot. The default is set
+	  by MSEAL_SYSTEM_MAPPINGS_DEFAULT_ON.
 
 	  For complete descriptions of memory sealing, please see
 	  Documentation/userspace-api/mseal.rst
 
+config MSEAL_SYSTEM_MAPPINGS_DEFAULT_ON
+	bool "Seal system mappings by default"
+	depends on MSEAL_SYSTEM_MAPPINGS
+	depends on !CHECKPOINT_RESTORE
+	default y
+	help
+	  Sets the default for the "mseal_system_mappings=" boot parameter.
+
+	  With CHECKPOINT_RESTORE=y, system mappings are only sealed when
+	  "mseal_system_mappings=1" is given, since CRIU needs to move them
+	  when restoring a process.
+
 config SECURITY
 	bool "Enable different security models"
 	depends on SYSFS
diff --git a/tools/testing/selftests/mseal_system_mappings/Makefile b/tools/testing/selftests/mseal_system_mappings/Makefile
index 2b4504e2f52f..d3b88af06c94 100644
--- a/tools/testing/selftests/mseal_system_mappings/Makefile
+++ b/tools/testing/selftests/mseal_system_mappings/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
 CFLAGS += -std=c99 -pthread -Wall $(KHDR_INCLUDES)
 
+LDLIBS += -lz
+
 TEST_GEN_PROGS := sysmap_is_sealed
 
 include ../lib.mk
diff --git a/tools/testing/selftests/mseal_system_mappings/config b/tools/testing/selftests/mseal_system_mappings/config
index 675cb9f37b86..493bbf834a84 100644
--- a/tools/testing/selftests/mseal_system_mappings/config
+++ b/tools/testing/selftests/mseal_system_mappings/config
@@ -1 +1,3 @@
 CONFIG_MSEAL_SYSTEM_MAPPINGS=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
diff --git a/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c b/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
index 97348c2a0689..ea75ad537620 100644
--- a/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
+++ b/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
@@ -10,6 +10,8 @@
 #include <unistd.h>
 #include <string.h>
 #include <stdbool.h>
+#include <sys/utsname.h>
+#include <zlib.h>
 
 #include "kselftest.h"
 #include "kselftest_harness.h"
@@ -52,14 +54,52 @@ static int parse_bool(const char *s, bool *res)
 	return -EINVAL;
 }
 
+static int sysmap_config_expected(int *enabled)
+{
+	struct utsname uts;
+	char line[MAX_LINE_LEN];
+	bool default_on = false;
+	gzFile config;
+	int expected;
+
+	*enabled = -1;
+	config = gzopen("/proc/config.gz", "rb");
+	if (!config && !uname(&uts)) {
+		snprintf(line, sizeof(line), "/boot/config-%s", uts.release);
+		config = gzopen(line, "rb");
+	}
+	if (!config)
+		return -1;
+
+	while (gzgets(config, line, sizeof(line))) {
+		if (!strcmp(line, "CONFIG_MSEAL_SYSTEM_MAPPINGS=y\n"))
+			*enabled = 1;
+		else if (!strcmp(line,
+				 "# CONFIG_MSEAL_SYSTEM_MAPPINGS is not set\n"))
+			*enabled = 0;
+		else if (!strcmp(line,
+				 "CONFIG_MSEAL_SYSTEM_MAPPINGS_DEFAULT_ON=y\n"))
+			default_on = true;
+	}
+	if (!gzeof(config))
+		*enabled = -1;
+	expected = *enabled < 0 ? -1 : *enabled && default_on;
+	gzclose(config);
+	return expected;
+}
+
 static int sysmap_sealed_expected(void)
 {
 	char cmdline[4096], *tok, *save;
-	int sealed = 1;
+	int enabled, sealed;
 	bool value;
 	size_t len;
 	FILE *f;
 
+	sealed = sysmap_config_expected(&enabled);
+	if (!enabled)
+		return 0;
+
 	f = fopen("/proc/cmdline", "r");
 	if (!f)
 		return -1;
-- 
2.54.0


