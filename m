Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 500DF60A3830
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=FzopNHd/
Received: by kanga.kvack.org (Postfix)
	id D44E56B0689; Thu, 19 Nov 2026 10:32:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13996B068A; Thu, 19 Nov 2026 10:32:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27C46B068B; Thu, 19 Nov 2026 10:32:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C03F6B0689
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:32:08 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90ADAC0ADD
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:06 +0000 (UTC)
X-FDA: 85452259452.11.9128FA0
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 853E1C0009
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b="FzopNHd/";
	spf=none (imf10.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.46) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795102324;
	b=5i9s+23uVoiukAIU3/OBu3+wva5zRmmDp+Ey/VyoaN8pUlws14UqlLD+3V151hOSl4rzfa
	J12+ku+yhRoyjUJ0OCTWbP3E5vbTAoye/b5V/1sUf4B002tJMQXgr61yfsQSesscVbGayp
	jmSEjM241fwvT3YEaaRhKARSC+ra3hg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795102324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qsLrdL7sT/af1ui02yqpWUBVQva/Rfa3My1unqAhcwE=;
	b=2jFCejR0zBIgNsmBenzJt1XjE7CVwcHoFnwKqRZUsLJxmU+z3nSwZkGv2KreYQGsGGvlEd
	7We0Vh0w63Dh1nJzFyjkXvinN++3+4j3GbYgxVfR/gOcbdCrzolcRTtyd3rQnkUgNtlQmX
	P9Q+xUaH7wT3ctBZEuqnaMTCX7s16nQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b="FzopNHd/";
	spf=none (imf10.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.46) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-492f0a1b685so1687960f8f.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1795102323; x=1795707123; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qsLrdL7sT/af1ui02yqpWUBVQva/Rfa3My1unqAhcwE=;
        b=FzopNHd/OI0nVDsydRP9P7JFKYaFDqyYf7tLOCBdmMQc3b+wVV8SMCdrxa67yzbOhT
         yAC8vjJgvmtCTcMUz/d89aHwapg4Rszp9LQ5dK1zS4qABeAxWIlw1mOoYhaCzQWOIEcs
         eEPO4u38mr1QXPFc0iwxl5Of35rqBP+BT3/wzHyhLD3U1+Ag3AJyILbWDPo4VqErcxrZ
         y5+qsrD8xZSrk/mMqKvnc6Uennohin6pTB8I27GO4IaJC6a4ktM4K8qVn18CGn8D0GTo
         9qqqomofqOtUJx3YmU/Ep85gQSg3duj1QVYM//rXch3mWcWQleJewhPnAq4QQgrU75BN
         9Sxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795102323; x=1795707123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qsLrdL7sT/af1ui02yqpWUBVQva/Rfa3My1unqAhcwE=;
        b=x//sbMiODlHH0bt1qAaKQo/SXIFEHEyJDpX5FUPLc2RzhWWG3IFXS1b6bCOIP7NxHo
         nRTyeGDMfVSsA5E5QLgpdOPM0ajMf5FbJCrbYQuOmrbLkulc5F2acgSJ4R4VppJt3brw
         ONYvqkxWsmz6VocZA3Dx8/E/wP6EycELoCt6ck/5C5xwNFsfSBTlslTrW155LwV+SL+o
         5U/ipjIorT7Yyrrcby26lZWaeGZXcHy9lwvgv+r1mh/4DN9UwpThYBKAvkQYKKZNxJ6m
         BbsgEBA1TtRvueWvpnLlyePdJJBT9/vYlR/8rjXxOViXmVYkpHcaePIn7fY3BlSijb68
         l6fg==
X-Forwarded-Encrypted: i=1; AL+hErGMmHuPEP4vIO3YoC5ZoHdtz7ZyLeIG4R8Epqztm8sJXxz3QU6iPFQ4rd9uMt2zeY6FUIx9geDNmw==@kvack.org
X-Gm-Message-State: APuU4Z87DYGGAdysHXbC7nzYzknTf2d9L3vpsl0/k23p5tsv0rh+k58f
	Amm/032XDAtF1zcni1pJc6ztp91cHVRCWsRew5sLP4fcGVx77DPqss/4p+PnLg9fq3g=
X-Gm-Gg: AZFdTZfwbz+5xbtBKWCF8pzEaXCDGWoKiwIj45NO9OaxJcV48D2JY+05UPIXVVqijSO
	YR9yveNr3G9Ajz53v4mJ/GDJ4EK9U0s9HT/vrqG/982mxPrBxNHLY0pLA/886gGzVYC4jJJ3FMR
	aTfwqqjboamsLfwnQk9LGf6xe9NvyanVp9T8E3u2wJ0BoUUZQpTheQxr1huFO46P6AtyP2UVOIz
	JevPSRZiomwsO2z9MrP10/pwhRLk/srbyi7DSrsPGxPdl51bq/z+/29foZwn3hQgvz7UoYt5lEZ
	UkMIzvsqMqij0w++agVE986n7vTLQ/ZKqFBO10HkyLy1lJAGkZsW2MLGJm3ZQrOUE8xxJ5D+rsg
	SByEEdMuHLLLiKaBPKOZwTtifbSBZtZ0prhIEzMnhtsT0fFTBZJxBfqK3RindCMmQPC0f0t+/g8
	ZZP16BCIdHYw4PhvjVSD9Q1BPod23J6ws3vsGmMcnDNppp3wagV/JDWc9OVL/8YoTEn2q2EnmiN
	YUVU402/sPdFzuR2NDeQqRdL0uGH8IjL0ojgZ4x0y1SGASWvti+gM44cRZTSyzpjDl/WGoROR57
	Y6k+r4hB1WMsURP/WN2b7RSlZQhsHcE=
X-Received: by 2002:a05:6000:658:b0:48e:6812:5ef1 with SMTP id ffacd0b85a97d-4a63a1e1041mr10988480f8f.25.1795102322897;
        Thu, 19 Nov 2026 07:32:02 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:294b::41d:4e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab65cb41f4sm237463f8f.7.2026.11.19.07.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 07:32:02 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Caleb Kan <ckan@cloudflare.com>,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v4 01/10] stackdepot: add caller-owned stack trace fetching
Date: Thu, 19 Nov 2026 15:31:34 +0000
Message-ID: <20261119153143.4099483-2-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119153143.4099483-1-matt@readmodwrite.com>
References: <20261119153143.4099483-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: obkdzriqoig1q5rck45jk9k31bconakk
X-Rspamd-Queue-Id: 853E1C0009
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795102324-181864
X-HE-Meta: U2FsdGVkX1+gWCk25xEalUOltTRYKqdRgA00Si/wIk74a8P2t/3o3NtQn4P0ELo2CC8J0L0+HeYYdUwIza4w6SSk+XLfxYs8bAH9Om37xz2xTZmNqMGkWUYIBd6rYo2pIj7BbkMVynjt57Y9/gbc7ZsHcDpTZBm6jRW9Pr8d9r3LobAHksO9D9kOrJe8/NWb13k4qp6nhgh36siOGX1+KOJEMa6+EhvCf98Dh5KhizzcbooBllwVhFMh/j6Z74gIBevhMYxwSX044JxCNt2RZdlv+Hr5z4WiFLLPVM3rG43ukHNKBslC968H25P5Q61MSDWzPgwFkH0markeJnWYXDvXWBn3eGn6lV4FGC5IuoUB4KAkzCMGOFg33j9IlyvnpQKTLDmR8N/2QLJ0BhbJn+gV+eYgfcgQDbX2bglJPH7StluwxZiWNC/YQzbC8fwvKSaPM8Asc0Q2M7dvJdlJV8Eb2BfLB5sDgPk2D9GC7yXDVh9txat6GLRer8N4gS0pi5xKsC10EmZxW4dcFqcVsRVRgNpCqssoSn2vP8/pR0QPcdGvO9HxPJ/CT24lDSH0m4MFPU7Q2DnZtyjhUsdi/AIOVxtjL9WMEVjHcxl2wJio7NCca5dL7VVvOaxtv+AB252vDeLzyieHEhQoo+XU8DjKMtVevTCMqzm+8hX1r/xroam8n7vQic586oebHR2NoWoI1FA4WpixvN5q03scbWJVVubTk7fAClP8wyKCYYHW5LpjDqvCQ4SsKYVEojnUBFq1g5wdungAn9USl+727ALMeXjW9H3ij3sCDsclCd8mzREkhGX6IiKbh5UcMIfsZVUEFbpRlpSL4G9GVxiy0JXZShHETiroOm3Jiycpwh4GPW5sh7rfJJF1sh/o5aABRcRV6aQc/2uHdbDwJQJVjB5P8o18nkvYB1fF+CA5MssHeTynEN0wJzCMKM1XKZm/lxn2cUmq9WGgjY9rByL
 nXBKvg/w
 HrVRcQ1J5vzgCBKgc1ri0vaB5RfXVT2psvkflJ8wykrSM2tuuBeQrmhe+uoWKo5v+ZueyEGzir3Ws5GUH124GDxuDMXF2dGwKxmn+WvOfmY2VevP80oq6I/OAwYQW50YRdU6Fd953KH/tfpv0rzPeEXRtNgHBZ7tM5dFXsj+wOpBxBxnWjQjEFKUjy6RWSNN3/kFbjgoNZXJRfxkunUtfTPtokX4nAh7ywoX1TgaISpZoJweVr7WhCFNBdu/zkg1POdc/ZmqYyxsVoUOpSnbZ90Sxdq4WHa25EJQV0pt3p8DsqCTqBmePpARfu2nx/0sgXrtZ4qP4GSHifVFHJUPgVCVMCwPyxAEIWsuYihVQmBTOvK/NnOXa/nB/VgvigoYXVPFaAj4HsMy5HQdxST6ua5O38MhCrMG9VtK83+AQlYw1WjChzebO/dPH2Q1avsynypsGHV8818qdMqWL+AwVVkswiwuYBNjkCCxqkOnDivECnYyLMVYISgQeA54sAgd0EnamIl+S9w6340tvxRoy9jqeKCh+qSWH42i8/aeiuMqieE071LLMisqQtR6jsVPNUEyvI9iymCMcUoQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Caleb Kan <ckan@cloudflare.com>

stack_depot_fetch() returns a pointer to contiguous storage owned by stack
depot. That cannot work once a later patch stores compressed frames, so
callers need an interface that copies the trace.

Add stack_depot_fetch_into() to copy a complete trace into caller-owned
storage. Leave the destination unchanged when it is too small, keep a zero
handle as a no-op, and document that callers must keep the handle valid
while copying it. Warn and return 0 if a caller passes a NULL buffer or
zero capacity for a valid handle.

Unpoison the copied entries before returning them because
lib/stackdepot.c is not instrumented by KMSAN. Add built-in KUnit tests for
exact and oversized destinations, zero handles, and undersized buffers.
Later patches add tests for stack depot internals.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
[mfleming: reworded for compressed frames]
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
 include/linux/stackdepot.h   | 36 +++++++++++++++
 lib/Kconfig.debug            | 16 +++++++
 lib/stackdepot.c             | 29 ++++++++++++
 lib/tests/Makefile           |  1 +
 lib/tests/stackdepot_kunit.c | 89 ++++++++++++++++++++++++++++++++++++
 5 files changed, 171 insertions(+)
 create mode 100644 lib/tests/stackdepot_kunit.c

diff --git a/include/linux/stackdepot.h b/include/linux/stackdepot.h
index 2cc21ffcdaf9..734529767c8a 100644
--- a/include/linux/stackdepot.h
+++ b/include/linux/stackdepot.h
@@ -199,6 +199,42 @@ struct stack_record *__stack_depot_get_stack_record(depot_stack_handle_t handle)
 unsigned int stack_depot_fetch(depot_stack_handle_t handle,
 			       unsigned long **entries);
 
+/**
+ * stack_depot_fetch_into - Fetch a stack trace into caller-owned storage
+ *
+ * @handle:	Stack depot handle
+ * @entries:	Caller-owned buffer to copy the stack trace into
+ * @max_entries:	Number of frames that fit in @entries
+ *
+ * Copies the stored frames into caller-owned @entries. If fewer frames are
+ * stored than @max_entries, only the stored frames are written and their count
+ * is returned. If more frames are stored than @max_entries, the copy is skipped
+ * entirely and 0 is returned.
+ *
+ * Passing a NULL @entries buffer or zero @max_entries for a valid @handle is
+ * invalid. Callers must provide storage for @max_entries frames.
+ *
+ * Callers should size @entries to match the save-side stack depth cap (for
+ * example, %CONFIG_STACKDEPOT_MAX_FRAMES or the local stack_trace_save() limit)
+ * when losing diagnostics on an undersized buffer would be surprising.
+ *
+ * A non-zero invalid @handle, including a post-put handle, may WARN. Its return
+ * value and copied contents are undefined because the record may have been
+ * reused for another stack.
+ *
+ * Callers must ensure @handle remains valid for the duration of this call.
+ * Persistent handles saved without %STACK_DEPOT_FLAG_GET require no extra
+ * reference; handles saved with %STACK_DEPOT_FLAG_GET require a held reference.
+ * Callers must not call stack_depot_put() on persistent handles.
+ * Racing this helper with stack_depot_put() on the same handle is invalid.
+ *
+ * Return: Number of frames copied, 0 if @handle is 0, stack depot is disabled,
+ * or @max_entries is less than the number of stored frames.
+ */
+unsigned int stack_depot_fetch_into(depot_stack_handle_t handle,
+				    unsigned long *entries,
+				    unsigned int max_entries);
+
 /**
  * stack_depot_print - Print a stack trace from stack depot
  *
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2d22638ec13a..861d0caf9391 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2818,6 +2818,22 @@ config RESOURCE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config STACKDEPOT_KUNIT_TEST
+	bool "KUnit test for stack depot" if !KUNIT_ALL_TESTS
+	depends on KUNIT=y && STACKDEPOT
+	depends on STACKDEPOT_MAX_FRAMES >= 3
+	default KUNIT_ALL_TESTS
+	help
+	  Enable this option to test stack depot API behavior at boot.
+	  This test is built in, so KUNIT must also be built in.
+
+	  KUnit tests run during boot and output the results to the debug log
+	  in TAP format (https://testanything.org/). Only useful for kernel
+	  developers running the KUnit test harness, and not intended for
+	  inclusion into a production build.
+
+	  If unsure, say N.
+
 config SYSCTL_KUNIT_TEST
 	tristate "KUnit test for sysctl" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index 90c52f2e0d3f..556f3ecdcc8f 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -785,6 +785,35 @@ unsigned int stack_depot_fetch(depot_stack_handle_t handle,
 }
 EXPORT_SYMBOL_GPL(stack_depot_fetch);
 
+unsigned int stack_depot_fetch_into(depot_stack_handle_t handle,
+				    unsigned long *entries,
+				    unsigned int max_entries)
+{
+	struct stack_record *stack;
+	unsigned int nr_entries;
+
+	if (!handle)
+		return 0;
+	if (stack_depot_disabled)
+		return 0;
+	if (WARN_ON_ONCE(!entries || !max_entries))
+		return 0;
+
+	stack = depot_fetch_stack(handle);
+	if (!stack)
+		return 0;
+	nr_entries = stack->size;
+	if (WARN_ON_ONCE(!nr_entries))
+		return 0;
+	if (nr_entries > max_entries)
+		return 0;
+
+	memcpy(entries, stack->entries, nr_entries * sizeof(*entries));
+	kmsan_unpoison_memory(entries, nr_entries * sizeof(*entries));
+	return nr_entries;
+}
+EXPORT_SYMBOL_GPL(stack_depot_fetch_into);
+
 void stack_depot_put(depot_stack_handle_t handle)
 {
 	struct stack_record *stack;
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index df0537e1b91f..bc6532d88150 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_RANDSTRUCT_KUNIT_TEST) += randstruct_kunit.o
 obj-$(CONFIG_SCANF_KUNIT_TEST) += scanf_kunit.o
 obj-$(CONFIG_SEQ_BUF_KUNIT_TEST) += seq_buf_kunit.o
 obj-$(CONFIG_SLUB_KUNIT_TEST) += slub_kunit.o
+obj-$(CONFIG_STACKDEPOT_KUNIT_TEST) += stackdepot_kunit.o
 obj-$(CONFIG_TEST_SORT) += test_sort.o
 CFLAGS_stackinit_kunit.o += $(call cc-disable-warning, switch-unreachable)
 obj-$(CONFIG_STACKINIT_KUNIT_TEST) += stackinit_kunit.o
diff --git a/lib/tests/stackdepot_kunit.c b/lib/tests/stackdepot_kunit.c
new file mode 100644
index 000000000000..b0c44c096976
--- /dev/null
+++ b/lib/tests/stackdepot_kunit.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <kunit/test.h>
+#include <linux/array_size.h>
+#include <linux/gfp.h>
+#include <linux/stackdepot.h>
+#include <linux/string.h>
+
+static void stackdepot_fetch_into_roundtrip(struct kunit *test)
+{
+	unsigned long entries[] = {
+		0x101000UL,
+		0x102000UL,
+		0x103000UL,
+	};
+	unsigned long exact[ARRAY_SIZE(entries)] = {};
+	unsigned long fetched[ARRAY_SIZE(entries) + 1] = {
+		[ARRAY_SIZE(entries)] = 0xa5a5a5a5UL,
+	};
+	unsigned long expected_tail = fetched[ARRAY_SIZE(entries)];
+	depot_stack_handle_t handle;
+	unsigned int nr_entries;
+
+	KUNIT_ASSERT_EQ(test, stack_depot_init(), 0);
+
+	handle = stack_depot_save(entries, ARRAY_SIZE(entries), GFP_KERNEL);
+	KUNIT_ASSERT_NE(test, handle, (depot_stack_handle_t)0);
+
+	nr_entries = stack_depot_fetch_into(handle, exact, ARRAY_SIZE(exact));
+	KUNIT_EXPECT_EQ(test, nr_entries, (unsigned int)ARRAY_SIZE(entries));
+	KUNIT_EXPECT_MEMEQ(test, exact, entries, sizeof(entries));
+
+	nr_entries = stack_depot_fetch_into(handle, fetched, ARRAY_SIZE(fetched));
+	KUNIT_EXPECT_EQ(test, nr_entries, (unsigned int)ARRAY_SIZE(entries));
+	KUNIT_EXPECT_MEMEQ(test, fetched, entries, sizeof(entries));
+	KUNIT_EXPECT_EQ(test, fetched[ARRAY_SIZE(entries)], expected_tail);
+}
+
+static void stackdepot_fetch_into_rejects_missing_or_short_stack(struct kunit *test)
+{
+	unsigned long entries[] = {
+		0x111000UL,
+		0x112000UL,
+		0x113000UL,
+	};
+	unsigned long fetched[ARRAY_SIZE(entries)] = {
+		0xa1a1a1a1UL,
+		0xb2b2b2b2UL,
+		0xc3c3c3c3UL,
+	};
+	unsigned long expected[ARRAY_SIZE(fetched)];
+	depot_stack_handle_t handle;
+	unsigned int nr_entries;
+
+	KUNIT_ASSERT_EQ(test, stack_depot_init(), 0);
+
+	handle = stack_depot_save(entries, ARRAY_SIZE(entries), GFP_KERNEL);
+	KUNIT_ASSERT_NE(test, handle, (depot_stack_handle_t)0);
+	memcpy(expected, fetched, sizeof(expected));
+
+	nr_entries = stack_depot_fetch_into(0, fetched, ARRAY_SIZE(fetched));
+	KUNIT_EXPECT_EQ(test, nr_entries, 0U);
+	KUNIT_EXPECT_MEMEQ(test, fetched, expected, sizeof(expected));
+
+	nr_entries = stack_depot_fetch_into(0, NULL, 0);
+	KUNIT_EXPECT_EQ(test, nr_entries, 0U);
+
+	nr_entries = stack_depot_fetch_into(handle, fetched,
+					    ARRAY_SIZE(fetched) - 1);
+	KUNIT_EXPECT_EQ(test, nr_entries, 0U);
+	KUNIT_EXPECT_MEMEQ(test, fetched, expected, sizeof(expected));
+}
+
+static struct kunit_case stackdepot_test_cases[] = {
+	KUNIT_CASE(stackdepot_fetch_into_roundtrip),
+	KUNIT_CASE(stackdepot_fetch_into_rejects_missing_or_short_stack),
+	{}
+};
+
+static struct kunit_suite stackdepot_test_suite = {
+	.name = "stackdepot",
+	.test_cases = stackdepot_test_cases,
+};
+
+kunit_test_suite(stackdepot_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for stack depot");
+MODULE_AUTHOR("Caleb Kan <ckan@cloudflare.com>");
+MODULE_LICENSE("GPL");
-- 
2.43.0


