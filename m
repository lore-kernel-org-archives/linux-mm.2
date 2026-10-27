Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 492CA606A7D9
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 11:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=Rfn8m69s
Received: by kanga.kvack.org (Postfix)
	id 4BCDE6B06C9; Tue, 27 Oct 2026 07:43:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4937B6B06CB; Tue, 27 Oct 2026 07:43:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 382216B06CC; Tue, 27 Oct 2026 07:43:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 141836B06C9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:43:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 991BD409B7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:43:10 +0000 (UTC)
X-FDA: 85368220140.30.F2EA4A2
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id A3462100008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:43:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=Rfn8m69s;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf14.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.52 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793101388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ihSaCVGXoXgLVj2uB+0zOcIYk1LHOIcOLN85o/KJU9U=;
	b=cv86HpfXF2QX9I/AD4kS2K0WhvNPw5ELj9GoGr/fL7j0SVND64QCBp172lk1Gt7h7PYZSg
	hyeti33CW/g7yFXML6v5kI7J+CiUqqUvEKR5ppC8DBnZXh0gbZHnvBKzvlOjOjd62IgdKX
	GunTdlabFrAMc0kMsBliGJi3+a4hafE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=Rfn8m69s;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf14.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.52 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793101388;
	b=nGNIL1zUOd3OuRhjDlYFiisIwuTPBcjwvp/PH8otoWvVVVRF8zLQOWxUFm7Z/FFPYA1iCS
	6EnnEf8+Ka/hi+w5r1tLmTdfCHh4xe8pYTyUftn6vJ0htzdybwG6h7ww9d9nPt+VkkCvHb
	B5V80S6hmWQg88NdP+yj9smYIfUx4pk=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3adac5c10e3so2092701a91.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793101387; x=1793706187; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ihSaCVGXoXgLVj2uB+0zOcIYk1LHOIcOLN85o/KJU9U=;
        b=Rfn8m69sO0CLOncu6VEjJg2aGWCxZDTOjEpJj8/fqTX81crhabMPG1QD0zIGeo+HfL
         FJU0t8gqCjGf6cZ+yR2zjGQctucSjac0wlypDz23NEjTqRcAsyK5ER9NIntndelhc7vk
         CQG5JZeBlUriDpXN/QaU8zVVaUL2EmDKDjxts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793101387; x=1793706187;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ihSaCVGXoXgLVj2uB+0zOcIYk1LHOIcOLN85o/KJU9U=;
        b=vkp12X0JK49TbOMCesAgnMXR8vEemMxPD1UMTJE7zMoVjKTRvRDI8wcjXJJrvSco5f
         mK8Y5qcz0oQtBk83d+7ur5yw0II0IyGJ99RNxl0vh4FxkrWXNBPgb2Kvwd7IHWppNdet
         HqZzfRvFWgpVk5HIEeGf8dlfotLtw/FMOYZ0i+2GxvQ0RLvDUfbd4I95syNiA/24w8WQ
         KGJp1C/I1ow4YnJync0pqZ9ZcQJ14PYAuFNRA3SC9sq8iHg7ns9t8wq7v7sg2oBvjKkg
         Q710DjRoJSKhRJYBvPCRP6RnPtvxc3eUiWn1a4oVmVbQymOLhPTfRuCuJTwSmwmj7HE7
         RxIQ==
X-Forwarded-Encrypted: i=1; AKwUvBxzEOiO2ELUooSL38z5h7qew+xNUQicojixyy6qBzq9tOQbyFC0e4WIdz0siJw86ieAbAQFUsjmuQ==@kvack.org
X-Gm-Message-State: AFq9FYJKBURHu2jdE/jyoC+QOALtUG5Zrdb86Z9vEEG6icaILY68ZMy/
	rX2tRPZZOvi5QiBOrWliYkv+yp0eqhqIlEO0attX6G+PkbdFctd8wNI/h1E4+UsJMl0=
X-Gm-Gg: AYBFou3rBVJKj2Cy6r5AYVee5KI6hm/L1/oGmYttDKNsKKOPdz9qr6ScBx2G4Tqu00q
	7RqGYlF4YPCBX6zp95p7oUka0uOrMd21CHbMhKqbUgpdhY49LeXyNvezKwLaXZLUdXkeKhjs2uL
	3wa+IQEnlGWHPiaJ8IUkGoaI0NUDIyyN7xF7lh0SfoZhHWkQOtVUwZGNKW2zFC4OkWUnNzlOLZC
	86JHj3kQP1OxXMS79MJWbmSTPsZpKqS6gMS/p3l6ZWUE36Gh5BBlq6D33ZKHouDXZuFI3Edgzgu
	hpmo3yiFAh4tVF89pdawE/ifweQOnSgfazBNV1j3AEjfTKbE69IqHnmCVOE2p2jevnijDfSVHHW
	rkoI14QrFaRnj7jyKn/vM7hDsgUuhxup1jD8+2XAx9INhNIrbfxDi8jW1hp1nm7Kd+HNj4qXhrK
	wp9kKjVbrTZbbzVpZc7kG+uOcGIngm/c0ALH0dUDbFmRloktBFbubc1cCRUy52UTDedu/laiZvO
	QviNxmAOKh4uf89YA4D0pwfXKIkPmPkwjqLDM5a+lBnnOPI+dyzuYtkVMsGY3DHTydovHmKBnLE
	RKIyJiMXMX0nVHloUUYQ1MXWv37rc6EbvZZnyQoZIiVdfuzorZpMjprcmdPX6/pA2jsr8LsHrU0
	yCAIMxWE1cLO+Qllm7j8/3Co=
X-Received: by 2002:a17:90b:3e4d:b0:3ac:adce:60b2 with SMTP id 98e67ed59e1d1-3ade9b2ce76mr8135222a91.2.1793101387414;
        Tue, 27 Oct 2026 04:43:07 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae40469a44sm3591664a91.14.2026.10.27.04.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 04:43:06 -0700 (PDT)
Date: Tue, 27 Oct 2026 19:43:04 +0800
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
Subject: [PATCH 1/3] mseal sysmap: Add mseal_system_mappings= boot parameter
Message-ID: <5bd3c89d733ad22224f296dfa8900769de937de0.1793094611.git.chris@chrisdown.name>
References: <cover.1793094611.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793094611.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A3462100008
X-Stat-Signature: amcjzp4kfngoycpmmpm1znuq5j3tgx3p
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793101388-417214
X-HE-Meta: U2FsdGVkX18qpNmYSfdwA8fCjO8QpjbYEINhMsy8Qmiai3093dXx5FUhcLp/WPTIU/4tCxXlF3bhVEF153q81s1jywIZXudk6s9B4Buk5EkfIOCeTv41IQ//d9As8cWWLBl7zzHuwa3vEXjiLs6f+I50dydkB24hcgBQzo2fmTDzBwASb0JabOqkqZ1uT2CX5O09E9rcJF6t5Td9CRwdloyXm3fqJnnbq5aqVcxDqXYoGhHqyBLFZmtVDlssqlf/xfAbdXRon8DiHZxp70nbwPyv8wYlGL+s4O+lKAfcd7VY0zWEZR+eKVSjlci/bpyvO+OFtNijnzG3e2cjmRyWKOJ2i2qZpVafJTN/BEnZxyIBZmIEERfUYLrq+lJwn2TJq5tXOIGMTm/1gxm4ZtRYEd5XxRclUdyl+OTlwQhWdiq59GenOKkzj9Jz5Nsbs5QrpWzipchXikZmHIyWv4HVEtiM16RRCrDAq8kqk00KOh6DIIqfr9EGGSNsNrrBuEVCXxvNRovN2bH8FJJjBEfa8qLpI6zWieCFgCIrwuRFrhyKYjDNqEWswYOPXNzz0kfkR/ThCrlR9HeKFADsqHl5hh5m2f5S1mxlfnoNiT9xdMwzsHaVYT40Rlr70q5kR12CT4HWARKVUEmIC2GwENhgL0BdLP82yRYsOVh7hYwozycPNMu8QGy/g7zXPCWM5aQhIvierl8V24QMtaLVwqWCyQvDlQ3L5mpEUggpelzXDUMo6ohqb7aPXl7SW2maB6BJfrRzSR8LQcxpl2QXPpYA1yWeN/V/PvB9AAHQ8joZFFL8zIMEpdd1Hz46nzlcvHrotcoxGtTmWG4fjJjYFiAUWHt2bmbnB6Bh3fG9zolcwNQDVrFlNK4cwxiDxf3KarTRPdYG9L4dyDFp728XqcCE2Evpbi8g8v34aN22vCGa89F1RWgm+4NE1Lzxi/fmv4ePTRUOVjyNEtcGJgu2M+y
 WGkPVslm
 DPL2S6iV+IqBmias0VrzPhy7Hai/p/lweprwqpBnuFQL0gMMMqWi6DWKXLr6vXdtjOJHLNEnXqTrWMw/LmGb7/3dbej0y6MtqUP99h5mvFSyyEhprZ7WXYXUXK/3iiS5SKn/OT0VMCb1TA0OJkcui9+GL+KoVHTfPJ+2CYAi3RRqAOYk0XS8p2w8S0ozk9PfYLkI5YMwUEjdnZ/Fkx5tp0OjsTPGEeF43AU2XcEHhvyDzQZnlKXJp2DAWeqsNRrCvsRCMI6WDrWQ9LiUJ0v9K63/yWJZbd3rD2tEf2iWwwtntWBIVYmc2lEuvFwoDce2WPx0hWn9ES4sEsNAezqB/+nn7NzV4VhWJmC+/y9w2e9aofve4WX47A3JFCb3asam2ZMTb4oUROlSkW/e857mneWCOLuc4tiqLZ1y+F4+xVjuBNQz/1EPLoKFEPfS/iCk+5BRnWjovw3qi3Z/DXq4lsFYumQxErXtGbigYlTN2ZmdvdvAmlf5z7Tct/j3YI/fsopkaDW4X2Vsv7sGLHwFv6W4qQ7528aPgiNcv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CONFIG_MSEAL_SYSTEM_MAPPINGS seals each process' system mappings when
they are created. As it is today this can only be toggled at build time,
so hosts that need sealing and hosts running software which moves or
unmaps these mappings end up with separate kernels. This is not ideal
since it adds more complexity of deployment, it would be great to be
able to have one kernel which can configurably do both.

So, to improve this, let's add mseal_system_mappings= so that this can
be chosen at boot.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 .../admin-guide/kernel-parameters.txt         |   7 ++
 Documentation/userspace-api/mseal.rst         |   3 +-
 include/linux/mm.h                            |   3 +-
 mm/mseal.c                                    |  12 ++
 security/Kconfig                              |   2 +
 .../mseal_system_mappings/sysmap_is_sealed.c  | 104 +++++++++++++++---
 6 files changed, 115 insertions(+), 16 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index e75344f4e0cd..b1ec9a8a979e 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4270,6 +4270,13 @@ Kernel parameters
 	MTD_Region=	[MTD] Format:
 			<name>,<region-number>[,<base>,<size>,<buswidth>,<altbuswidth>]
 
+	mseal_system_mappings=
+			[KNL,EARLY] Under CONFIG_MSEAL_SYSTEM_MAPPINGS,
+			whether system mappings are sealed for this boot.
+			See Documentation/userspace-api/mseal.rst.
+			Format: <bool>
+			Default: 1 (enabled).
+
 	mtdparts=	[MTD]
 			See drivers/mtd/parsers/cmdlinepart.c
 
diff --git a/Documentation/userspace-api/mseal.rst b/Documentation/userspace-api/mseal.rst
index c039d782f9f5..4e50215e4762 100644
--- a/Documentation/userspace-api/mseal.rst
+++ b/Documentation/userspace-api/mseal.rst
@@ -142,7 +142,8 @@ Use cases
 
   If supported by an architecture (CONFIG_ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS),
   the CONFIG_MSEAL_SYSTEM_MAPPINGS seals all system mappings of this
-  architecture.
+  architecture. The kernel command line parameter
+  ``mseal_system_mappings=0`` turns this off at boot.
 
   WARNING: This feature breaks programs which rely on relocating
   or unmapping system mappings. Known broken software at the time
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5f82be0fcde5..2329d81b7d46 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -568,7 +568,8 @@ enum {
 #define VM_STACK_FLAGS vma_flags_to_legacy(VMA_STACK_FLAGS)
 
 #ifdef CONFIG_MSEAL_SYSTEM_MAPPINGS
-#define VM_SEALED_SYSMAP	VM_SEALED
+extern bool mseal_sysmap_enabled;
+#define VM_SEALED_SYSMAP	(mseal_sysmap_enabled ? VM_SEALED : VM_NONE)
 #else
 #define VM_SEALED_SYSMAP	VM_NONE
 #endif
diff --git a/mm/mseal.c b/mm/mseal.c
index 7a8ac66dc215..e0563796cfa3 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -7,6 +7,8 @@
  *  Author: Jeff Xu <jeffxu@chromium.org>
  */
 
+#include <linux/init.h>
+#include <linux/kstrtox.h>
 #include <linux/mempolicy.h>
 #include <linux/minmax.h>
 #include <linux/mman.h>
@@ -16,6 +18,16 @@
 #include <linux/sched.h>
 #include "internal.h"
 
+#ifdef CONFIG_MSEAL_SYSTEM_MAPPINGS
+bool mseal_sysmap_enabled __ro_after_init = true;
+
+static int __init early_mseal_sysmap(char *buf)
+{
+	return kstrtobool(buf, &mseal_sysmap_enabled);
+}
+early_param("mseal_system_mappings", early_mseal_sysmap);
+#endif
+
 static bool range_contains_unmapped(unsigned long start, unsigned long end)
 {
 	VMA_ITERATOR(vmi, current->mm, start);
diff --git a/security/Kconfig b/security/Kconfig
index f7bf6cdc6229..d5e83af1bfc6 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -67,6 +67,8 @@ config MSEAL_SYSTEM_MAPPINGS
 	  of writing includes CHECKPOINT_RESTORE, UML, gVisor, rr. Therefore
 	  this config can't be enabled universally.
 
+	  Sealing can be turned off at boot with "mseal_system_mappings=0".
+
 	  For complete descriptions of memory sealing, please see
 	  Documentation/userspace-api/mseal.rst
 
diff --git a/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c b/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
index cb0ca6ed7ebe..97348c2a0689 100644
--- a/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
+++ b/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
@@ -1,12 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * test system mappings are sealed when
- * KCONFIG_MSEAL_SYSTEM_MAPPINGS=y
+ * Test system mapping sealing and the mseal_system_mappings= boot parameter.
  */
 
 #define _GNU_SOURCE
 #include <stdio.h>
 #include <errno.h>
+#include <ctype.h>
 #include <unistd.h>
 #include <string.h>
 #include <stdbool.h>
@@ -17,6 +17,73 @@
 #define VMFLAGS "VmFlags:"
 #define MSEAL_FLAGS "sl"
 #define MAX_LINE_LEN 512
+#define SYSMAP_PARAM "mseal_system_mappings="
+
+static int parse_bool(const char *s, bool *res)
+{
+	if (!s)
+		return -EINVAL;
+
+	switch (tolower((unsigned char)s[0])) {
+	case 'e':
+	case 'y':
+	case 't':
+	case '1':
+		*res = true;
+		return 0;
+	case 'd':
+	case 'n':
+	case 'f':
+	case '0':
+		*res = false;
+		return 0;
+	case 'o':
+		switch (tolower((unsigned char)s[1])) {
+		case 'n':
+			*res = true;
+			return 0;
+		case 'f':
+			*res = false;
+			return 0;
+		}
+		break;
+	}
+
+	return -EINVAL;
+}
+
+static int sysmap_sealed_expected(void)
+{
+	char cmdline[4096], *tok, *save;
+	int sealed = 1;
+	bool value;
+	size_t len;
+	FILE *f;
+
+	f = fopen("/proc/cmdline", "r");
+	if (!f)
+		return -1;
+	len = fread(cmdline, 1, sizeof(cmdline) - 1, f);
+	if (ferror(f) || !feof(f)) {
+		fclose(f);
+		return -1;
+	}
+	fclose(f);
+	cmdline[len] = '\0';
+
+	for (tok = strtok_r(cmdline, " \t\n", &save); tok;
+	     tok = strtok_r(NULL, " \t\n", &save)) {
+		if (!strcmp(tok, "--"))
+			break;
+		if (strncmp(tok, SYSMAP_PARAM, strlen(SYSMAP_PARAM)))
+			continue;
+
+		if (!parse_bool(tok + strlen(SYSMAP_PARAM), &value))
+			sealed = value;
+	}
+
+	return sealed;
+}
 
 bool has_mapping(char *name, FILE *maps)
 {
@@ -30,7 +97,7 @@ bool has_mapping(char *name, FILE *maps)
 	return false;
 }
 
-bool mapping_is_sealed(char *name, FILE *maps)
+int mapping_is_sealed(FILE *maps)
 {
 	char line[MAX_LINE_LEN];
 
@@ -43,7 +110,7 @@ bool mapping_is_sealed(char *name, FILE *maps)
 		}
 	}
 
-	return false;
+	return -1;
 }
 
 FIXTURE(basic) {
@@ -67,53 +134,62 @@ FIXTURE_TEARDOWN(basic)
 FIXTURE_VARIANT(basic)
 {
 	char *name;
-	bool sealed;
+	bool sysmap;
 };
 
 FIXTURE_VARIANT_ADD(basic, vdso) {
 	.name = "[vdso]",
-	.sealed = true,
+	.sysmap = true,
 };
 
 FIXTURE_VARIANT_ADD(basic, vvar) {
 	.name = "[vvar]",
-	.sealed = true,
+	.sysmap = true,
 };
 
 FIXTURE_VARIANT_ADD(basic, vvar_vclock) {
 	.name = "[vvar_vclock]",
-	.sealed = true,
+	.sysmap = true,
 };
 
 FIXTURE_VARIANT_ADD(basic, sigpage) {
 	.name = "[sigpage]",
-	.sealed = true,
+	.sysmap = true,
 };
 
 FIXTURE_VARIANT_ADD(basic, vectors) {
 	.name = "[vectors]",
-	.sealed = true,
+	.sysmap = true,
 };
 
 FIXTURE_VARIANT_ADD(basic, uprobes) {
 	.name = "[uprobes]",
-	.sealed = true,
+	.sysmap = true,
 };
 
 FIXTURE_VARIANT_ADD(basic, stack) {
 	.name = "[stack]",
-	.sealed = false,
+	.sysmap = false,
 };
 
 TEST_F(basic, check_sealed)
 {
+	int expected = 0, sealed;
+
 	if (!has_mapping(variant->name, self->maps)) {
 		SKIP(return, "could not find the mapping, %s",
 			variant->name);
 	}
 
-	EXPECT_EQ(variant->sealed,
-		mapping_is_sealed(variant->name, self->maps));
+	sealed = mapping_is_sealed(self->maps);
+	if (sealed < 0)
+		SKIP(return, "could not read the mapping's sealing state");
+	if (variant->sysmap) {
+		expected = sysmap_sealed_expected();
+		if (expected < 0)
+			SKIP(return, "could not determine the expected sealing state");
+	}
+	EXPECT_EQ(expected, sealed);
 };
 
 TEST_HARNESS_MAIN
-- 
2.54.0


