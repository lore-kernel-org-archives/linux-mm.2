Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40BCEF532C3
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B93266B00AF; Mon, 23 Mar 2026 19:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69816B00B1; Mon, 23 Mar 2026 19:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E4646B00B2; Mon, 23 Mar 2026 19:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82BE96B00AF
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:59:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3204D13C278
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:05 +0000 (UTC)
X-FDA: 84578996250.25.3C57D13
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf19.hostedemail.com (Postfix) with ESMTP id 72E321A0007
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eL3VgxVV;
	spf=pass (imf19.hostedemail.com: domain of 3xtPBaQgKCMks1p80przv33v0t.r310x29C-11zAprz.36v@flex--dmatlack.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3xtPBaQgKCMks1p80przv33v0t.r310x29C-11zAprz.36v@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=omO2IOfE0pDlFemBHvNO/nr0zzMPm3bDzAx2yMbkgWA=;
	b=ft3pshooGbiF+aIMwk1nFd47Bfav8QOX+urspcUobrh3MXzB/EuaWdEMG380tJNKj/BFie
	TJnJD3xhIf3iKqZinP7xMA1inMcFK533L4gd0Ahn0+SrCgbdxgt8poK/x8gF4CKS2RZEGT
	a+K0clVxNKlhr5Z7J20t372kdhLZRbI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310343; a=rsa-sha256;
	cv=none;
	b=DwRW71/1EySV0Lk4Etke313n5uXwV7c0mHflakA5D2wicEkEofhhDv29GmvDst/0m4UAwr
	19NKspCWYjRlLG79IodSFwCZXRxwtxolvhxyTzqk9/mgL5JpOJ4SmETcQsrXB84T+x+OLc
	zALm838SUKNlfJ9mOC9ZtdiWaM3WZXI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eL3VgxVV;
	spf=pass (imf19.hostedemail.com: domain of 3xtPBaQgKCMks1p80przv33v0t.r310x29C-11zAprz.36v@flex--dmatlack.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3xtPBaQgKCMks1p80przv33v0t.r310x29C-11zAprz.36v@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c74262a2988so13982589a12.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310342; x=1774915142; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=omO2IOfE0pDlFemBHvNO/nr0zzMPm3bDzAx2yMbkgWA=;
        b=eL3VgxVVdA6rs53O9ZD1DHO+Wg6teZfnOUkfhGrL05wnphI4lGx2xo9sAIh88hsvnC
         j4jZ7ep5hEv2VIk2wxjMWGzCLJ+neVaSj4TIHnO/1je8Ll0EX1YX521WrLtwnkKHL9hP
         wvC6oKl9iynz9KW6SSNVN11SMA7EPSMdSJk+7WhUxHYb9kiGqX5RMMyrIgz0jB3H/eJv
         VwuGEzjLp3oj5++eGAkSyBZagkqZKxSj8zsrH7FZq7R7USAbPpP6kdhGd6fZgQzZa/hc
         PWogxmf1b8d3W771k0C4J8JVMN8pHfoHreqoT9emRBkq439nbuPHM7v8pIVsGZ7dQ1C5
         D3lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310342; x=1774915142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=omO2IOfE0pDlFemBHvNO/nr0zzMPm3bDzAx2yMbkgWA=;
        b=Iy/ycHGfbk8xs+gwzj8Df73UAVS+eXi3NQcfNzKjzvs1AlsMzsybMPUmDLgPL8KSs3
         bYHQ4Tzg+OAua3A00ijtg2NVp2j/KJpfIHNnZ0fsDhuUpIsFNOS+I7Ss1S0qFX8LpqMI
         pZi7IdfchBNfYUGWgpXQZtbJCPJjKi1yt5YvOYK3kmUzQucQHlg89pVS/rjYrOetg+aq
         3pu7b5fST9PcghzSdcVcUct0eDGE/ohLoLXB97i3PZF07DSQUtQkZb6Z8h88AwIOPYBT
         iM4FjD0cuv80A+hbgElviDDnBTlDpAR3Ed1JGsrdb/NiBQvGIjg+3I6fBK0f9onn3Kv8
         PfVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAyTeFzE2tAjQI2ouCcFrGRRGaJC6YWOlWVfV4Q+UeWV9ksW054pc8P3skUdCo79H1W83wW87FPg==@kvack.org
X-Gm-Message-State: AOJu0YypUc68SvBnUttXiWsvB3iS1oBpcPruWEr2lhyQotWUfxCGvmJ1
	PZ82nlz7nhfH3bUk4u0M3EWALeYOBJXX1QJwkf3swgsVOYYUFmW3aR+p7sUVS082l8XGyxdnw9G
	zHSeczZEFqR5qRw==
X-Received: from pgbci10.prod.google.com ([2002:a05:6a02:200a:b0:c74:12b9:ee05])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:33a3:b0:39b:e710:e2ec with SMTP id adf61e73a8af0-39be7111013mr9375027637.43.1774310342018;
 Mon, 23 Mar 2026 16:59:02 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:58:06 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-15-dmatlack@google.com>
Subject: [PATCH v3 14/24] selftests/liveupdate: Move luo_test_utils.* into a
 reusable library
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Feng Tang <feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 72E321A0007
X-Stat-Signature: x1doogq99abopzixed8qfhawqp7ted9b
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774310343-730858
X-HE-Meta: U2FsdGVkX1/q7wVE69MjVZ0cej5IzymxgZmYLo8qXcIHJk4xgkITDWSPD+VdRjltri4sUoqam4JZpphllfog+0LB4GPP9AfGksoMMpADD064u3WqQOEs+d5FCpzofJ7Um40yXD3wwYJRd7gbIS019dx70/p6JUA8Ikx5Gkd6kOqLtqq20Cqn6uGAHNiIQr5F+BACtIE86j7+GOjajuH4+400TOjYHsM0i06jZ9RlaLqbRLs438lM7DQXoTL8V+ZajoQiIV5UeYhyUlksW5ABwHrj3zi9DXnZhID5eSnYXifTjirS7M2gen33zr+JVGYBs0lhXknVhmUPoC+M8LWXmkMVNVjBUOuxoAnjkONA6tDj0s9NhQILxSIZOeDIMdI0bhmNxu+7Z/VqqXXpdkOvUym2sZqfOzJs431YcZuS/2DAznd6Ikj7Kjaky96iavLCRUkrUQzSRznka0JT86CekOdgHPQUhy+cL6LhxeMetkt4Li9CxSD7F5u8wgnUt4NzN/MZZDLdhr9NWiMGc3k4eLxUEKrsvWkf2uYGJK3lFDirs3m5Ied52bp9GXZLugotoGbk4ZGJuLxupAhTIETqehzWDiqMRtzwE0LWVmHF15D+I1Ckocq7qRv2YbhnLv+uDFBe2CukpivFK9PWF6JMQnTa2z3Hl5I9vqtitXNbl6+9SkZLjYY9q2CbB8DEFsUPKm2BO9rzsAxsfIug3M3U5MYmqJQH2GGxwzfQfYYRrn7GQKoQnJDu9bJ/m6PIj1IHt1AxVXBhAxGVNM4jtT364sH21OWFItiQzY792Hr6Yp3/OO1LQ60glxFhQyNgxojyCJjRAT7ETa5ZSLSk5/OvbJ+B1LVskqmsSX4NKLlmSY+FVwC3/wYSU+q4/EunREnq6OEAvidPiX4BmzjbY+YXPy7xlluNDpCLyINeULmhNM6dtQyN/5F01wAgODa1XapqE+RxYpFtIL+88rYXEkN
 glvJxoWR
 0czcZoFB/R89yNUGcuE5euNi7QrjIxcbfzMJ28A8SlVZbqYjqwBGmZr+Yd+0VNgYm3m/q93IF+67G30g0wIldT88qfnirHCdKXXPhX0FIosnvHP+zPbzvDs2saYsnwv4u7K1CcSET646yKf7YKKdsyAIFstiCO05FoKAt+iJXi04RABM3JhUsc06wAC38FAIALf1UKi5dsxN30uNyTEofa4k5gYmUWd+uwg6FBytXAeTtKG0+oAElf5vpn7lMFSPghDxQTqGm+rd/9FofqLALy+UTD88w43Us1dCCsJoCfktWarVQuUzeGbEan36nm0xuQMjCUlzdJ+roZ2OJ4PD/JD2lDBMhtniIJn0HBwtOg3ghZ7PeJBCCrSZ2eVPN48oIRHhN7haVuCwOKiInzRuNdIvnAJaCm5xyut60OCKT1VFubxz13mOAYIrhg68pz3QUg77e4KEsW3bBXBay+oq327tgnMmtE0DE2GWfqEtYYfMRPBrXg+y1NLcul1iT+goF3/BjAUQ6vFujET3L5Ca5SfY9gkVgLvIBggfx7foGsOIOMSZKPiQXOynhq5NYveWxZpoF0VIcBCi0gYGiVg5W8uOAXwZbq/lKka7Ijh805bhhncAriMuVOrBnPjpP/yDP+s45tghiHybm40zc+JUHkiKC0PiTWNpc686vlIjGRp906v3Sp2cIuj+ApzIoMI3z1SMl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vipin Sharma <vipinsh@google.com>

Move luo_test_utils.[ch] into a lib/ directory and pull the rules to
build them out into a separate make script. This will enable these
utilities to be also built by and used within other selftests (such as
VFIO) in subsequent commits.

No functional change intended.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/liveupdate/.gitignore |  1 +
 tools/testing/selftests/liveupdate/Makefile   | 14 ++++---------
 .../include/libliveupdate.h}                  |  8 ++++----
 .../selftests/liveupdate/lib/libliveupdate.mk | 20 +++++++++++++++++++
 .../{luo_test_utils.c => lib/liveupdate.c}    |  2 +-
 .../selftests/liveupdate/luo_kexec_simple.c   |  2 +-
 .../selftests/liveupdate/luo_multi_session.c  |  2 +-
 7 files changed, 32 insertions(+), 17 deletions(-)
 rename tools/testing/selftests/liveupdate/{luo_test_utils.h => lib/include/libliveupdate.h} (87%)
 create mode 100644 tools/testing/selftests/liveupdate/lib/libliveupdate.mk
 rename tools/testing/selftests/liveupdate/{luo_test_utils.c => lib/liveupdate.c} (99%)

diff --git a/tools/testing/selftests/liveupdate/.gitignore b/tools/testing/selftests/liveupdate/.gitignore
index 661827083ab6..18a0c7036cf3 100644
--- a/tools/testing/selftests/liveupdate/.gitignore
+++ b/tools/testing/selftests/liveupdate/.gitignore
@@ -3,6 +3,7 @@
 !/**/
 !*.c
 !*.h
+!*.mk
 !*.sh
 !.gitignore
 !config
diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index 080754787ede..a060cc21f27f 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -1,7 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-LIB_C += luo_test_utils.c
-
 TEST_GEN_PROGS += liveupdate
 
 TEST_GEN_PROGS_EXTENDED += luo_kexec_simple
@@ -10,25 +8,21 @@ TEST_GEN_PROGS_EXTENDED += luo_multi_session
 TEST_FILES += do_kexec.sh
 
 include ../lib.mk
+include lib/libliveupdate.mk
 
 CFLAGS += $(KHDR_INCLUDES)
 CFLAGS += -Wall -O2 -Wno-unused-function
 CFLAGS += -MD
 
-LIB_O := $(patsubst %.c, $(OUTPUT)/%.o, $(LIB_C))
 TEST_O := $(patsubst %, %.o, $(TEST_GEN_PROGS))
 TEST_O += $(patsubst %, %.o, $(TEST_GEN_PROGS_EXTENDED))
 
-TEST_DEP_FILES := $(patsubst %.o, %.d, $(LIB_O))
+TEST_DEP_FILES := $(patsubst %.o, %.d, $(LIBLIVEUPDATE_O))
 TEST_DEP_FILES += $(patsubst %.o, %.d, $(TEST_O))
 -include $(TEST_DEP_FILES)
 
-$(LIB_O): $(OUTPUT)/%.o: %.c
-	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
-
-$(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/%: %.o $(LIB_O)
-	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $< $(LIB_O) $(LDLIBS) -o $@
+$(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/%: %.o $(LIBLIVEUPDATE_O)
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $< $(LIBLIVEUPDATE_O) $(LDLIBS) -o $@
 
-EXTRA_CLEAN += $(LIB_O)
 EXTRA_CLEAN += $(TEST_O)
 EXTRA_CLEAN += $(TEST_DEP_FILES)
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.h b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
similarity index 87%
rename from tools/testing/selftests/liveupdate/luo_test_utils.h
rename to tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
index 90099bf49577..4390a2737930 100644
--- a/tools/testing/selftests/liveupdate/luo_test_utils.h
+++ b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
@@ -7,13 +7,13 @@
  * Utility functions for LUO kselftests.
  */
 
-#ifndef LUO_TEST_UTILS_H
-#define LUO_TEST_UTILS_H
+#ifndef SELFTESTS_LIVEUPDATE_LIB_LIVEUPDATE_H
+#define SELFTESTS_LIVEUPDATE_LIB_LIVEUPDATE_H
 
 #include <errno.h>
 #include <string.h>
 #include <linux/liveupdate.h>
-#include "../kselftest.h"
+#include "../../../kselftest.h"
 
 #define LUO_DEVICE "/dev/liveupdate"
 
@@ -41,4 +41,4 @@ typedef void (*luo_test_stage2_fn)(int luo_fd, int state_session_fd);
 int luo_test(int argc, char *argv[], const char *state_session_name,
 	     luo_test_stage1_fn stage1, luo_test_stage2_fn stage2);
 
-#endif /* LUO_TEST_UTILS_H */
+#endif /* SELFTESTS_LIVEUPDATE_LIB_LIVEUPDATE_H */
diff --git a/tools/testing/selftests/liveupdate/lib/libliveupdate.mk b/tools/testing/selftests/liveupdate/lib/libliveupdate.mk
new file mode 100644
index 000000000000..fffd95b085b6
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/lib/libliveupdate.mk
@@ -0,0 +1,20 @@
+include $(top_srcdir)/scripts/subarch.include
+ARCH ?= $(SUBARCH)
+
+LIBLIVEUPDATE_SRCDIR := $(selfdir)/liveupdate/lib
+
+LIBLIVEUPDATE_C := liveupdate.c
+
+LIBLIVEUPDATE_OUTPUT := $(OUTPUT)/libliveupdate
+
+LIBLIVEUPDATE_O := $(patsubst %.c, $(LIBLIVEUPDATE_OUTPUT)/%.o, $(LIBLIVEUPDATE_C))
+
+LIBLIVEUPDATE_O_DIRS := $(shell dirname $(LIBLIVEUPDATE_O) | uniq)
+$(shell mkdir -p $(LIBLIVEUPDATE_O_DIRS))
+
+CFLAGS += -I$(LIBLIVEUPDATE_SRCDIR)/include
+
+$(LIBLIVEUPDATE_O): $(LIBLIVEUPDATE_OUTPUT)/%.o : $(LIBLIVEUPDATE_SRCDIR)/%.c
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
+
+EXTRA_CLEAN += $(LIBLIVEUPDATE_OUTPUT)
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/lib/liveupdate.c
similarity index 99%
rename from tools/testing/selftests/liveupdate/luo_test_utils.c
rename to tools/testing/selftests/liveupdate/lib/liveupdate.c
index 3c8721c505df..60121873f685 100644
--- a/tools/testing/selftests/liveupdate/luo_test_utils.c
+++ b/tools/testing/selftests/liveupdate/lib/liveupdate.c
@@ -21,7 +21,7 @@
 #include <errno.h>
 #include <stdarg.h>
 
-#include "luo_test_utils.h"
+#include <libliveupdate.h>
 
 int luo_open_device(void)
 {
diff --git a/tools/testing/selftests/liveupdate/luo_kexec_simple.c b/tools/testing/selftests/liveupdate/luo_kexec_simple.c
index d7ac1f3dc4cb..786ac93b9ae3 100644
--- a/tools/testing/selftests/liveupdate/luo_kexec_simple.c
+++ b/tools/testing/selftests/liveupdate/luo_kexec_simple.c
@@ -8,7 +8,7 @@
  * across a single kexec reboot.
  */
 
-#include "luo_test_utils.h"
+#include <libliveupdate.h>
 
 #define TEST_SESSION_NAME "test-session"
 #define TEST_MEMFD_TOKEN 0x1A
diff --git a/tools/testing/selftests/liveupdate/luo_multi_session.c b/tools/testing/selftests/liveupdate/luo_multi_session.c
index 0ee2d795beef..aac24a5f5ce3 100644
--- a/tools/testing/selftests/liveupdate/luo_multi_session.c
+++ b/tools/testing/selftests/liveupdate/luo_multi_session.c
@@ -9,7 +9,7 @@
  * files.
  */
 
-#include "luo_test_utils.h"
+#include <libliveupdate.h>
 
 #define SESSION_EMPTY_1 "multi-test-empty-1"
 #define SESSION_EMPTY_2 "multi-test-empty-2"
-- 
2.53.0.983.g0bb29b3bc5-goog


