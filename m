Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28AABD73E87
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:26:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 032BE6B009F; Thu, 29 Jan 2026 16:26:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C366B00A0; Thu, 29 Jan 2026 16:26:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B266B00A1; Thu, 29 Jan 2026 16:26:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2C066B009F
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:26:00 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82551160174
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:00 +0000 (UTC)
X-FDA: 84386284080.18.4D7070F
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf04.hostedemail.com (Postfix) with ESMTP id B5EC140009
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DKIRUbWm;
	spf=pass (imf04.hostedemail.com: domain of 3ZdB7aQgKCEgnwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3ZdB7aQgKCEgnwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hp3td6uMAaTZjQV6oFbLUGjv1pGfeS9Cq/BNEG9/dt4=;
	b=ScQ+0CL9U9CTMx0RrQ9EVJ3pUZMQ/QEWpZ+yht3c3H2VdCwouSvnVIVJEetmxE7zmqkpN8
	okBk1Z+DsxL4fylLAhRo5dEINT4h38EF0vt6dbxZBiW0IiI8zqlv0U0HO/sgGhtCZG4SwG
	5LHBjPXgBGVX3b41jaDLAZHIi2K8CGY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DKIRUbWm;
	spf=pass (imf04.hostedemail.com: domain of 3ZdB7aQgKCEgnwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3ZdB7aQgKCEgnwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721958; a=rsa-sha256;
	cv=none;
	b=b82pI2AL8eNOfyfTJ9UCMfdzNiDG726uTaDsorJvtOiJdwpFaudvd5CddoIKRA33De00I6
	D1lcgRk1gPbf29xLnWuO9/R7cSUdy6DA4eN+vNJ+N2juTX/6I8MY4fEtCOzr2h2LsF9oAD
	6RDZPvmUInCcKrrBr1BC2E6BB5k5cDU=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0e952f153so35452075ad.0
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721958; x=1770326758; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hp3td6uMAaTZjQV6oFbLUGjv1pGfeS9Cq/BNEG9/dt4=;
        b=DKIRUbWmDuuAEeZglBw/Lhubc6D3Y2cyZ1B6IOcAcxvfDyZQG2P+TATdfyhlL0Db+a
         q66bstHxFzRQNg3QtrPipmy8hPsLVnmEcqWVNwWwALOHbQK34waMIKWuencrcRDD1ieo
         iiwOfoN3YcUofqxKR7JoL/bGVw6DijVooj12JUrH0qAXij+QP2H57QIMmXASMmFh8t/T
         Nw7WJ6RbG/L2JNnI1HBp7H7ZsbeM82MJ0/cOHeQhWH++NTuIHiR5HzVWeh2KtL02BNmz
         qoo7KlSBI4ElJ4hfox0lx8C2HON6c6yk69PdqQft6geaMnyp7tLwSIb2CS176yfuTRdK
         k+2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721958; x=1770326758;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hp3td6uMAaTZjQV6oFbLUGjv1pGfeS9Cq/BNEG9/dt4=;
        b=w87OOWerGu/Uax1hLCmwXmVOSI8DPj0fjevknJJLyW0oZ82iJv9GBObVcFJxC0VU79
         gqsH94Hm41+/nW9ZjSYlevVk9VBksaM/vhFQx3bOoqgVLfCN1C5MMm8cft3xIgE4QNwL
         fDlR6n7oNqZVuWa6o1hc9SQxwjPo+eIoIT7KsY8V/av2QfAODqlIgWVCOdRT28dvrKJN
         A03tgxMcAhYurao8NHft5unMw9JuJRyv2xmVNlj4iVxuGHuSp2usYWcDLx7jjzA3yhe4
         CkoO484ZY8frR5SYbx6MZldLwoF2oagsV9wt373CMvHRbnkuXa53HDM0McBjGolNPGdP
         62rw==
X-Forwarded-Encrypted: i=1; AJvYcCV0mH3DVlONvOXq0R6c4fdBK54Z+r12G5RJcrJl6yjRQlQwa8EgERXIqIS+tAps/iX/RfNalDt89g==@kvack.org
X-Gm-Message-State: AOJu0Yw8Fw7hLeUFfnYZJxMQ1X9vvffBvYKRxQJ5QcPcq27mYqOLug7b
	z0NnuCVlrqJlFp8Q9bnV9Fj0WshPo8SZBZDMMTIs365h3w5fX4AJ/Z2uhLd+fq3mgUUxouukHfv
	MViVWLgrfG6bKfg==
X-Received: from plgb8.prod.google.com ([2002:a17:902:d508:b0:295:50ce:4dd])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:388e:b0:295:596f:8507 with SMTP id d9443c01a7336-2a8d89464b3mr6954275ad.0.1769721957393;
 Thu, 29 Jan 2026 13:25:57 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:59 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-13-dmatlack@google.com>
Subject: [PATCH v2 12/22] selftests/liveupdate: Move luo_test_utils.* into a
 reusable library
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: s4n173diuxxb81yihstg6u4g1bpp5e67
X-Rspamd-Queue-Id: B5EC140009
X-Rspam-User: 
X-HE-Tag: 1769721958-357284
X-HE-Meta: U2FsdGVkX1+IUk89ftyB56P2amu9jIxSbbHM0KyCq1C2CuZRklUgdMmOszpu8CBsHFuCJJHY0tuoTDS74bnHGkNGDwi5h8FQx36dAjd8yQV84D0rxnb/w1SfNiX8rI0IN+it+faY5VoRH3pKXeSgnMpvMLaYYvt5NNbPsnpDarEHbQ6KXLLBNa/OkVZetF+wNMTPOayRl/gvckAvVB1frnLyDb8ObzxcSwRjRggbT7NnE3ussaEiaUixFD4vgJsomQ3oh1GaLOj3cf/KYhsWTXQWXie//RSSRzv1iNsabf6AB/O+hsrVPCWtmZmao2KEADE1znJLNsJQ0t1aDV3b7r231tbzLvJH8Jchh28wFb3fO6xIZrbeONWob4BL6FTLDkhAcSZDz7AOZlBL+GETTYHwn86e6WBblAMGixBDzE4gmaG+7GNFQAok8o46N+olA5LfQ9vd5LpA0EmP8SA2Xq/q/996NfBW9IniQOTDejAaeqK+rYwVReR71to99K70yt6aYMJh9lRLt0/9nV1YmFE3rapZ1rpmLu5fehk64J2ptmQFh8+bJgD4pqBQQIu4BOoew/BctyVfmzfXyn+/GMcX5IucKdxBRITtSbU3dtnkfClG3m5HCUDG+3Pg4RyLf1JQ07ugSqfK/Y7q7B2j93FtgBy6J9ZXVByGyLISlgCTivz/VydiUy8xESWyvnnSI43bJYlhBN40RKzh5Vc7K/nnjGAiNCK04dA0rkJhukLDZ6NZzj90jaDhPtojX/HcVxcLNQUDG6Se6px0thCTbi2puXyDa3hKXX696w3VAAJmDIxjpfEyY/T6lmgcisjQuLohpDkrxy5d5mIpSfQggkj4z8EjYaTUyXebZJLcZGGCNEYvbmxqCrup0Gw0ItjXJJNeAsLF3H7MmZyQ/nj7wJHsWzTu58AXNOV9FEQ1W0XM8fO/N7bXVf84L7EzzqaT0+FOKL9RP4qSbNos0Fn
 zgIc5kvp
 v4MnsNBznBXzW+JfPlyGPTrNClD2hSs+Scr1v52l/xJ/DT6Ag39TZZrXMyuRxlfcvp3aOvo1OcxqW+vgA0+TBm0z+M6LcX1yRQlEN4XusUWtTMQqNBOL9plScVGUFaWreQPLRpShOwY5V1A/PHWM5Efc4iYgF9Jkxer2sQIr6NX+6lAQ1LtILQ/+6b9YpNH+ZPR61edzBEjDj3SPXKoD/2fhaTsFYjKQ/yOnpfVsFEIxUHO/Omls61Jp2r6RN4e1rOVtw6hTj/uGZMsX9LmqNGgMl0U77AIxep5fjHTbPenjYt6q+YjkZbw3dPnP2c7lZVvSQP2uZXQ89XhmmJWV3oLYSq4NAwo6cxXrS/1DpXaf1qx4n694Od/NtFhn80gchS0YKNcdgzJGZnVs6sB3tZp1cUwpyitHs2MTFbzHEJzVq0VXD1lSA4/2ljfr1cC4F8tQc5gej3vswxeaaJrYg6rE5qsdqX0WAuxD+z2raqYyG2Tq7/qnF8631PfI0YAWUvaVvDg2Kf6jXWPvjVUwPW8rJAqt+r+eadO/pYj00qH3qOYWM9kozjAY1fCFoRD2Kh7HyA6nBidPxQLGNvmjaLlAmhwLAcHL0a99ZeMG8P8k6bL8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
2.53.0.rc1.225.gd81095ad13-goog


