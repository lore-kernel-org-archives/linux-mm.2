Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FF13C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:52:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE0F6B00AE; Tue,  8 Sep 2026 08:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5EF6B00AF; Tue,  8 Sep 2026 08:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A34BA6B00B0; Tue,  8 Sep 2026 08:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 772CC6B00AE
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:51:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07DB4C064D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:45 +0000 (UTC)
X-FDA: 85190581770.06.01C7B2A
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0B97C40003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="e P+Ag2N";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=E81WlkZP;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1unT87Lq7u+KlW9Co+t6ru/BE89W6ONlMNwMwp6MA8Q=;
	b=a+RXqz3VhLeDbepBy/q55cnoIHY5Sl7Tbvi6U6MUsEn2sC17D4Vj2UFV1HL9/82TG+5mOK
	TLRovqLE5CDS4KR5dO/QDc+uDM8EVHSgq9o+vKqDsn88x9zYOvgJ2nOReqg273UE4hDeKI
	wj1/EIxrN/VEMfx2UWuPqu/8fOoyyuA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871903;
	b=iwJdIiNYpaJ/T3n0AI0wBhwbzogrxyn9UVc+4/UkKLY7h/j+3Au1BqdORPiKsm1jambVoc
	q0r9lqhfY7M13iiy0nF6sBW4M3AcOH9m9d1nwlvX6Iid1iD3ZEU76cezHupA0cOAK2Av6h
	w9p1BuJuQSkdSAVXN/t4haDvarM3CxA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="e P+Ag2N";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=E81WlkZP;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 9471DEC006A;
	Tue,  8 Sep 2026 08:51:42 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 08 Sep 2026 08:51:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788871902; x=
	1788958302; bh=1unT87Lq7u+KlW9Co+t6ru/BE89W6ONlMNwMwp6MA8Q=; b=e
	P+Ag2NRIZMNyziFEN9mwwKvR/+V51pap20YIS89QVnGIMimoCWIkkWCTquTED3oF
	u2m6GzXYCAY1DwHJq/e8L4Tq6sCY45kz2x1w7WLvZeMZ2ruWySuCuD22ODRmmy0Q
	PnlPBUNzDmYsbNXEkrb9zv4P49ZVfJIRgGd3dpMHJOAWA9lnoQar9z5KnvFr89zV
	BkkG9t6a1OKFb1b4PH5bwYP/2QRigO0hSiZDNjpwBGZ8WP1O0aNGW4oZUv98rV8J
	2vU3q08fv3ktSLFMiOrV3n6EvZwZit0bSl/YxsV5o0qDxEptOFgkW606Di0h+32l
	XaegD3+UxInPQWECCLVhA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788871902; x=1788958302; bh=1
	unT87Lq7u+KlW9Co+t6ru/BE89W6ONlMNwMwp6MA8Q=; b=E81WlkZPALgUQPZOg
	F0iUxtMdXew8EETFfNpRVqVqKybwpLcSUXpo2RSozaqb2QAeZP+5Oj8S/ZH+XF+F
	sX9qf9qnByFlMZD6xN4S8C3vdHkS3is4lKyHiKnK76XQQXJlcF3irh+g9OTBrye0
	rYbmSUIcWXD2pmLbMLVJQcA8LWM9CZ9ctx3Dgl0bqY/xAYlbL/UKTcNBFeVTiT8C
	aC+Ru4Tiv8N6p/T3wL30AsR6No8UnvI9mx5D4byL0CTawwEtZFZQqdDlJN+JVPf4
	H7utQcEzMzImOVj61cvz7SpWNYvmBlAP2i9DEuSCme4GLabfumufI0HvxTjDi9ZB
	+FhCA==
X-ME-Sender: <xms:3gSgautXhlzYRyAAq9U3vDv4QHDV0GwTI9f0YxRzu3hlTxVoBPHvuw>
    <xme:3gSgar0pGVmD90lcsWbzCnm0bjpMYpQdMtKEQiKs7YqT4E0v2WZGlc4HoBDrzY1bB
    rA58dejfYkgbRFLew41kkYqeiHFZJQOBQFJzQt01qdho0WX0X2Mx7O-aw>
X-ME-Received: <xmr:3gSgar_rNhYYVh6FjsdzaDUwTaYoZuCq-scRk8OR0SQoHfJ95eXPZuBgOGE>
X-ME-Proxy-Cause: dmFkZTGnwUGLVSeW1BZjwXwEzw+urlx3mhNN4Gat/Zr8Ko3PyRi/hbLWgybpr9vD6UiZtB
    ClgmaF+ewm3/RMVDG5HlNC86fy+pq7ADG2BzYUhbZNKO7wBVrMzlr3sUqSigFGZOoBtGTx
    gIvu2aAZGSG1tp9oBvzbgbiiOvG8y4h9kz65seWrJfEwnZ8Rc2pC1MQmnPT64gFUFWDzlM
    RiNFVZKD8mgg9fzzj8qOYTQFdG4jKe+gjSJLicGunwl1BDHVIlxYuc9XbgxMGsYndbdG+r
    SzwA5wdO/TxhNOptcwVG8cZe537iFTZCjrnNerCLGxDTvjjKWH9WqAatCO1tL0baXTf7GZ
    V4/1MI+BTYGky+EORQHNm/ZYYfA51lJIaz8iylC59cZlzuxyxRL5X4q1PzdsENX9BGsyx1
    jjdke+FRHts/VsjgDXPJDGe/YqWek7MchK8FXjSWA7+9LG4b/EsdrzM+zEpEGQSrtL0o0h
    Qxk/szdej34GnhL65VVVASSQLvrd9JQvw/oiVAMQDuXX4dedh9uqETxPhcohwvRV1wQ0i9
    4p0P3UzyN/u9e6d1vJLueLlufStargN8upWAycGtp+n5qGi8zw2PkoyZlrFxl7E5BeYfhp
    SXvRXQ3Je/bX9ERjacLe+1ZqxIhnEJPACPH0MJKzWjphP4lWjZ2dMcGfr/8g
X-ME-Proxy: <xmx:3gSgahAsorR91vs0sPzN9aFqocZ4FPp6DA8iv22PdHfG9OGxeLdwKA>
    <xmx:3gSgahCMNGWNBxz5UBfm-IhGLKvSmmUCtc8Tv-GLGD8W_Gj4cxQROw>
    <xmx:3gSgahJiBZCArUBp4f2uwL9gv_Fcxzg5Wr5XLZr5gfMQ0yTEUUUs5w>
    <xmx:3gSgarSX8NBWFsR3ljpyISUZLcc6HY4yUVzUuBeVNDY37XZ5Qx8Tog>
    <xmx:3gSganfyqNZQJOhcp6_tXsPdWseBBsPvIGj3uQNFqmPzdK26hz9bck5Z>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 08:51:41 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	usama.anjum@arm.com,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ziy@nvidia.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	agordeev@linux.ibm.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 16/19] selftests/mm: add khugepaged race harness
Date: Tue,  8 Sep 2026 13:51:02 +0100
Message-ID: <20260908125105.1510704-17-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908125105.1510704-1-kirill@shutemov.name>
References: <20260908125105.1510704-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kjrepwrd1i6jexcexwageb9q9tb59br6
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B97C40003
X-Rspamd-Server: rspam03
X-HE-Tag: 1788871902-209975
X-HE-Meta: U2FsdGVkX19bHTJDkJ6QvwEweBIjRs+O6GM/0x9Se7hc0cqwQlCQiDHZNu8SxYp1aoYVeIv/wzgp2OqHWbhXSNRrYipSyRinLJGvi4xb5PkAeDMvqZI1lH6sUZv71Wcy9G2YL3+9z1bnYQEdvGdAzhxKd4pYIYIvIZLmNQ6BACYWCCWis8UczzKn8iJ2RLPM5L6BPOuYN7+6EdEq1IiMuMU4idZh/GE+IPy6E55Qj9Kn1R4pjuc4PHw7MoXerMEhspkj4eCGlBdFFnGPCJ7LnRGppRZ2DFH95Vs0By9RpvnS20uPh1MoLXo7DunS4GdcSMci/5OqtCIfNyG1R7FI2H9TO03WRNHBzz8L+cXKwXJXz0aDkdYZLF0TExCIIN6mmP7AfcMazvxm1toqkHNk2Nx8Mkyros3BueG2xBaYnpDKgw2BUJzscDlGoxw2/p63X7cS0mmomVAgN7/zWtTHv5GpvrPiTm5v/BIom4FJJvFKbqYtJMAdPBIWi+9jAALIe3ZSrUdWS8xYZxJyeEnnaS0fMDQzaRhterfFDm/GqqTRSlLBgZR5lfgNd2nqMYMDNUBiCP+aQamCa3LO0/DbR8Ti5cWiijCEDae50gdFwPMnqzqlxbuFSWMQ+/GzEctJG5ZTSdlSczpWoW8Z2zUK9xZKcU8M0qVxLNNuu6ZIki0Gz0bVh/w75oFWp7ag+g8r/RXdOzrlPKaZxk4dTDoL0AkI88TlL8RQVHhRoY7HOM+LfNwJQ12qz52Mb+nD460wHVK1dqiuDbmuwI+mFKC93Eo5kPY5tECF/2MpJBYNUXXZlE5/IyHEsmfgNcdjRQdjg8qjeBEYlRRzUAOHXp3hVI6jHee3Msb8WmwcwuXBW/ptmSh5A78HnhZD+aCatevmmsyKTxAFI8tU7+6ZIqAdZmAKii1A6QsRWY0ubPiu80TcKrGqJsbbXbhqQvk0jTLyzr78OyfhrwjHbWxSoWx
 qgcyGFWl
 bQTAqhWMH846ihFwENVs5lJ3/JulJyNOYJoX3Gcj2jb5CPw4i4GM55tHVP75eGDfnRxaSw9HPdeup2m5iWXgd+5blxdcq5NJMGARTCevvD1MARpIrJjOesMPKFrT8V3VIFk7bYmfAC+9QLNV3UggilyQbFdG9JjcYdXn/Pz7hw3SumGNJO3+GxBfHiS+sG3RW+U6M6a72/5DU6/ckKqmn5rZLVw1BL2hHZFFeyxURBZsCAuWLWOMPdvREu2mTaX798NPOPDaoqGcDFdzLUF4MH+B8CKlRofDLk43Iy6HjIvxtu5xD2fR767Thm6rm6+fkjBMj9+hYlQzMi+3o8w7pZq8M+vGJCerVnAkGqQDEc9IUfLdvw61E8eCfyW/8msvJSl7yqLPA40DAQ2qCmn+CjIiiD4iHZ8vYpvitpBiMjMC6e7A57wWM3EUDEyaq0oAyWy6cjmlJTXjeDby1hzezqjjFLiNCbIqpdcoaQ88DvNBxKf8g26C02aLzYuwKFGbBvVna
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Collapse serialises against faults, GUP, fork, mremap and zapping through
a protocol of locks, TLB flushes and refcount checks.  No khugepaged
selftest exercises any of it under contention.

Add khugepaged_race.  Six racing threads work the same address space:

  - two faulters
  - an MADV_DONTNEED thread
  - a transient FOLL_PIN thread (gup_test)
  - a forker
  - an mremap thread

One of three drivers collapses under them:

  stepped   khugepaged, one full pass at a time via
            khugepaged_full_pass(), so each step covers a known extent;
  free      khugepaged left to run (scan_sleep_millisecs=0), for soak;
  madvise   an MADV_COLLAPSE and MADV_DONTNEED loop.

Every mode runs in turn unless -m names one, five seconds each.  Every
supported anon THP order is set to inherit and max_ptes_none is 0, so a
window collapses only once fully populated and the racing MADV_DONTNEED
steers selection across orders.

The rule is that a racing page reads as its pattern or as zero, never
anything else.  The faulters and fork children check it throughout, and a
final sweep checks it again.  The other half of the check is the kernel's
own assertions, so read dmesg too.

The pin thread goes through gup_test, so the harness skips without
CONFIG_GUP_TEST or root.  The default playground is three shared PMD-sized
areas plus the mremap thread's, over two gigabytes at a 512M PMD; -a
shrinks it.

Assisted-by: LLM
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/Makefile          |   1 +
 tools/testing/selftests/mm/khugepaged_race.c | 410 +++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh    |   2 +
 3 files changed, 413 insertions(+)
 create mode 100644 tools/testing/selftests/mm/khugepaged_race.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index b2d6e5c12934..308bbad73c11 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -106,6 +106,7 @@ TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
 TEST_GEN_FILES += folio_order_check
 TEST_GEN_FILES += khugepaged_sync_check
+TEST_GEN_FILES += khugepaged_race
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
new file mode 100644
index 000000000000..448256704ef4
--- /dev/null
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -0,0 +1,410 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Race collapse against faults, GUP pins, fork, mremap and MADV_DONTNEED
+ * over the same ranges.  A racing page must read as its pattern or as
+ * zero, never anything else; the kernel's own assertions in dmesg are the
+ * other half of the check.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/time.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "kselftest.h"
+#include "vm_util.h"
+#include "hugepage_settings.h"
+#include "../../../../mm/gup_test.h"
+
+#ifndef FOLL_WRITE
+#define FOLL_WRITE 0x01
+#endif
+
+#define BASE_ADDR	((void *)(1UL << 30))
+#define PASS_TIMEOUT_S	30
+
+/*
+ * PMD-sized areas the racing threads share, plus one for the mremap
+ * thread.  -a shrinks it where a PMD is 512M.
+ */
+#define DEFAULT_SHARED_AREAS	3
+static int nr_shared_areas;
+static int nr_areas;
+
+static unsigned long hpage_pmd_size;
+static unsigned long page_size;
+/* nr_areas PMD-sized areas; the last one belongs to the mremap thread */
+static char *region;
+static char *mremap_area;
+static char *mremap_scratch;
+static int gup_fd = -1;
+static volatile int stop;
+static volatile int corrupted;
+
+static unsigned int pattern(unsigned long page_idx)
+{
+	unsigned int val = (unsigned int)page_idx * 2654435761U;
+
+	return val ? val : 1;	/* never collides with the zero-fill */
+}
+
+/* Zero means never written; anything else must be this page's pattern */
+static bool page_is_corrupt(unsigned long page_idx, unsigned int *val)
+{
+	*val = *(unsigned int *)(region + page_idx * page_size);
+
+	return *val && *val != pattern(page_idx);
+}
+
+static void check_page(unsigned long page_idx)
+{
+	unsigned int val;
+
+	if (page_is_corrupt(page_idx, &val)) {
+		corrupted = 1;
+		ksft_print_msg("Corruption at page %lu: %#x != %#x\n",
+			       page_idx, val, pattern(page_idx));
+	}
+}
+
+static unsigned long shared_pages(void)
+{
+	return nr_shared_areas * hpage_pmd_size / page_size;
+}
+
+static unsigned long rand_page(unsigned int *seed)
+{
+	return (unsigned long)rand_r(seed) % shared_pages();
+}
+
+/* Clamp so a range never reaches the mremap thread's area */
+static unsigned long room_from(unsigned long page_idx, unsigned long want)
+{
+	unsigned long left = shared_pages() - page_idx;
+
+	return want < left ? want : left;
+}
+
+static void *faulter_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+
+	while (!stop) {
+		unsigned long page_idx = rand_page(&seed);
+
+		if (rand_r(&seed) & 1)
+			*(unsigned int *)(region + page_idx * page_size) =
+				pattern(page_idx);
+		else
+			check_page(page_idx);
+	}
+	return NULL;
+}
+
+static void *dontneed_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+
+	while (!stop) {
+		unsigned long page_idx = rand_page(&seed);
+		unsigned long nr = 1UL << (rand_r(&seed) % 6);	/* 1..32 pages */
+
+		madvise(region + page_idx * page_size,
+			room_from(page_idx, nr) * page_size, MADV_DONTNEED);
+		usleep(rand_r(&seed) % 500);
+	}
+	return NULL;
+}
+
+static void *pinner_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+
+	while (!stop) {
+		struct gup_test gup = {};
+		unsigned long page_idx = rand_page(&seed);
+		unsigned long nr = room_from(page_idx, 16);
+
+		gup.addr = (unsigned long)(region + page_idx * page_size);
+		gup.size = nr * page_size;
+		gup.nr_pages_per_call = nr;
+		gup.gup_flags = FOLL_WRITE;
+		/* Racing MADV_DONTNEED makes transient failures expected */
+		ioctl(gup_fd, PIN_FAST_BENCHMARK, &gup);
+		usleep(rand_r(&seed) % 200);
+	}
+	return NULL;
+}
+
+static void *forker_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+
+	while (!stop) {
+		pid_t pid = fork();
+
+		if (pid == 0) {
+			unsigned int val;
+			int bad = 0;
+
+			/*
+			 * No stdio in the child: a thread may hold stdout's
+			 * lock across the fork, and printing under it hangs.
+			 */
+			for (int i = 0; i < 16; i++)
+				bad |= page_is_corrupt(rand_page(&seed), &val);
+			_exit(bad);
+		}
+		if (pid > 0) {
+			int wstatus;
+
+			if (waitpid(pid, &wstatus, 0) < 0)
+				ksft_exit_fail_perror("waitpid()");
+			/* A child killed on the read counts too */
+			if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus))
+				corrupted = 1;
+		}
+		usleep(rand_r(&seed) % 2000);
+	}
+	return NULL;
+}
+
+static void *mremapper_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+
+	while (!stop) {
+		void *p;
+
+		p = mremap(mremap_area, hpage_pmd_size, hpage_pmd_size,
+			   MREMAP_MAYMOVE | MREMAP_FIXED, mremap_scratch);
+		if (p == MAP_FAILED)
+			ksft_exit_fail_perror("mremap() away");
+		for (int i = 0; i < 8; i++)
+			mremap_scratch[(rand_r(&seed) %
+				(hpage_pmd_size / page_size)) * page_size] = 1;
+		p = mremap(mremap_scratch, hpage_pmd_size, hpage_pmd_size,
+			   MREMAP_MAYMOVE | MREMAP_FIXED, mremap_area);
+		if (p == MAP_FAILED)
+			ksft_exit_fail_perror("mremap() back");
+		usleep(rand_r(&seed) % 2000);
+	}
+	return NULL;
+}
+
+static unsigned long now_ms(void)
+{
+	struct timeval tv;
+
+	gettimeofday(&tv, NULL);
+	return tv.tv_sec * 1000UL + tv.tv_usec / 1000;
+}
+
+static void usage(void)
+{
+	fprintf(stderr,
+		"Usage: khugepaged_race [-d seconds] [-m stepped|free|madvise] [-a areas] [-t mask]\n"
+		"\tWithout -m, every mode runs in turn.\n"
+		"\t-d: seconds per mode (default 5)\n"
+		"\t-a: number of shared PMD-sized playground areas (default 3)\n"
+		"\t-t: bitmask of racing threads to start, for bisecting a failure\n");
+	exit(1);
+}
+
+int main(int argc, char **argv)
+{
+	static const char * const thread_names[] = {
+		"faulter", "faulter2", "dontneed", "pinner", "forker",
+		"mremapper",
+	};
+	void *(*const thread_fns[])(void *) = {
+		faulter_fn, faulter_fn, dontneed_fn, pinner_fn, forker_fn,
+		mremapper_fn,
+	};
+	const int nr_threads = ARRAY_SIZE(thread_names);
+	pthread_t threads[ARRAY_SIZE(thread_names)];
+	static const char * const all_modes[] = { "stepped", "free", "madvise" };
+	const char *one_mode[1];
+	const char * const *modes = all_modes;
+	int nr_modes = ARRAY_SIZE(all_modes);
+	const char *mode_arg = NULL;
+	struct thp_settings settings;
+	unsigned long end_ms;
+	int duration_s = 5;
+	unsigned long thread_mask = ~0UL;
+	int nr_areas_arg = 0;
+	unsigned long i;
+	int steps = 0;
+	int opt;
+
+	while ((opt = getopt(argc, argv, "a:d:m:t:h")) != -1) {
+		switch (opt) {
+		case 'a':
+			nr_areas_arg = atoi(optarg);
+			break;
+		case 'd':
+			duration_s = atoi(optarg);
+			break;
+		case 'm':
+			mode_arg = optarg;
+			break;
+		case 't':
+			thread_mask = strtoul(optarg, NULL, 0);
+			break;
+		default:
+			usage();
+		}
+	}
+
+	if (mode_arg) {
+		if (strcmp(mode_arg, "stepped") && strcmp(mode_arg, "free") &&
+		    strcmp(mode_arg, "madvise"))
+			usage();
+		one_mode[0] = mode_arg;
+		modes = one_mode;
+		nr_modes = 1;
+	}
+
+	ksft_print_header();
+	if (!thp_available())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+
+	page_size = getpagesize();
+	hpage_pmd_size = read_pmd_pagesize();
+	if (!hpage_pmd_size)
+		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
+
+	gup_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
+	if (gup_fd < 0)
+		ksft_exit_skip("/sys/kernel/debug/gup_test requires CONFIG_GUP_TEST and root\n");
+
+	nr_shared_areas = nr_areas_arg > 0 ? nr_areas_arg : DEFAULT_SHARED_AREAS;
+	nr_areas = nr_shared_areas + 1;
+
+	/*
+	 * MREMAP_FIXED unmaps whatever is in the way without saying so, so
+	 * claim the mremap thread's scratch address up front.
+	 */
+	mremap_scratch = (char *)BASE_ADDR + 2 * nr_areas * hpage_pmd_size;
+	if (mmap(mremap_scratch, hpage_pmd_size, PROT_NONE,
+		 MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED_NOREPLACE,
+		 -1, 0) != (void *)mremap_scratch)
+		ksft_exit_fail_perror("mmap() mremap scratch");
+
+	ksft_set_plan(nr_modes);
+
+	thp_save_settings();
+	thp_read_settings(&settings);
+
+	/* Base of the settings stack; the bottom entry is never popped */
+	thp_push_settings(&settings);
+
+	for (int m = 0; m < nr_modes; m++) {
+		const char *mode = modes[m];
+
+		thp_read_settings(&settings);
+		settings.thp_enabled = THP_MADVISE;
+		settings.thp_defrag = THP_DEFRAG_ALWAYS;
+		settings.shmem_enabled = SHMEM_NEVER;
+		settings.khugepaged.defrag = 1;
+		settings.khugepaged.scan_sleep_millisecs =
+			strcmp(mode, "free") ? 1000 : 0;
+		settings.khugepaged.alloc_sleep_millisecs = 10;
+		/*
+		 * mTHP collapse honours only 0 or HPAGE_PMD_NR - 1 here, and 0
+		 * keeps a step from being spent on PMD allocations that racing
+		 * MADV_DONTNEED will not let succeed.
+		 */
+		settings.khugepaged.max_ptes_none = 0;
+		/* One wake, one pass: the playground plus the forked children's copies */
+		settings.khugepaged.pages_to_scan =
+			nr_areas * (hpage_pmd_size / page_size) * 8;
+		for (i = 0; i < NR_ORDERS; i++) {
+			if (thp_supported_orders() & (1UL << i))
+				settings.hugepages[i].enabled = THP_INHERIT;
+		}
+		thp_push_settings(&settings);
+
+		region = mmap(BASE_ADDR, nr_areas * hpage_pmd_size,
+			      PROT_READ | PROT_WRITE, MAP_ANONYMOUS |
+			      MAP_PRIVATE | MAP_FIXED_NOREPLACE, -1, 0);
+		if (region != BASE_ADDR)
+			ksft_exit_fail_perror("mmap() playground");
+		mremap_area = region + nr_shared_areas * hpage_pmd_size;
+
+		/* Populate so the first pass has something to collapse */
+		for (i = 0; i < nr_shared_areas * hpage_pmd_size / page_size; i++)
+			*(unsigned int *)(region + i * page_size) = pattern(i);
+		memset(mremap_area, 1, hpage_pmd_size);
+		if (madvise(region, nr_areas * hpage_pmd_size, MADV_HUGEPAGE))
+			ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
+
+		for (i = 0; i < nr_threads; i++) {
+			if (!(thread_mask & (1UL << i))) {
+				threads[i] = 0;
+				continue;
+			}
+			if (pthread_create(&threads[i], NULL, thread_fns[i],
+					   (void *)(i + 1)))
+				ksft_exit_fail_perror(thread_names[i]);
+		}
+
+		end_ms = now_ms() + duration_s * 1000UL;
+		if (!strcmp(mode, "stepped")) {
+			while (now_ms() < end_ms && !corrupted) {
+				if (!khugepaged_full_pass(PASS_TIMEOUT_S))
+					ksft_exit_fail_msg("khugepaged pass timed out\n");
+				steps++;
+			}
+		} else if (!strcmp(mode, "free")) {
+			while (now_ms() < end_ms && !corrupted)
+				usleep(100 * 1000);
+		} else {	/* madvise */
+			while (now_ms() < end_ms && !corrupted) {
+				for (i = 0; i < nr_shared_areas; i++) {
+					madvise(region + i * hpage_pmd_size,
+						hpage_pmd_size, MADV_COLLAPSE);
+				}
+				madvise(region, nr_shared_areas * hpage_pmd_size,
+					MADV_DONTNEED);
+				steps++;
+			}
+		}
+
+		stop = 1;
+		for (i = 0; i < nr_threads; i++) {
+			if (threads[i])
+				pthread_join(threads[i], NULL);
+		}
+
+		for (i = 0; i < nr_shared_areas * hpage_pmd_size / page_size; i++)
+			check_page(i);
+
+		ksft_test_result(!corrupted,
+				 "%s: %ds, %d steps, no corruption\n",
+				 mode, duration_s, steps);
+
+		/* The next mode maps the same fixed address with its own settings */
+		munmap(region, nr_areas * hpage_pmd_size);
+		thp_pop_settings();
+		stop = 0;
+		steps = 0;
+
+		if (corrupted) {
+			/* Memory is suspect; the rest would prove nothing */
+			while (++m < nr_modes)
+				ksft_test_result_skip("%s: skipped after corruption\n",
+						      modes[m]);
+			break;
+		}
+	}
+
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index c0f69da3fd3b..fc61907aa3b2 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -406,6 +406,8 @@ CATEGORY="thp" run_test ./folio_order_check
 
 CATEGORY="thp" run_test ./khugepaged_sync_check
 
+CATEGORY="thp" run_test ./khugepaged_race
+
 CATEGORY="thp" run_test ./khugepaged
 
 CATEGORY="thp" run_test ./khugepaged -s 2
-- 
2.54.0


