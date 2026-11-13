Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27AF1606E345
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=MnKcIp1Z
Received: by kanga.kvack.org (Postfix)
	id 642DC6B05D2; Fri, 13 Nov 2026 13:57:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61BFB6B05D3; Fri, 13 Nov 2026 13:57:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50A966B05D4; Fri, 13 Nov 2026 13:57:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4F16B05D2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:57:11 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A5C7D1201BB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:10 +0000 (UTC)
X-FDA: 85431003420.03.179AFF1
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id B83FE40003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=MnKcIp1Z;
	dmarc=none;
	spf=none (imf12.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.128.45) smtp.mailfrom=matt@readmodwrite.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596228;
	b=w0Cm7I3dlgKzsXIHt7t3DS1lhs/KUQlsLY2zBQDs+kvhPfNx45AbEswWIR8pUdAYXOKyvS
	jQplbJJWoJBo4vQTACSausmRi3zR4i81No7QGc3rJtF/QfaVeyBbXmu3CIPJZRAAtLcu6q
	LECxdNxU5r2ZlP7r11WSfaYaUUd0hvw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qsLrdL7sT/af1ui02yqpWUBVQva/Rfa3My1unqAhcwE=;
	b=Tru7Cl3s8JDQ0LylZLnPkGBMvYor+iaGZfpBMVnFYdoSOrTP1IbxTgkKjtAIWgwmKZng5e
	8m9p9Q6tKk2h4+psHfSi7uwMUoln6ycdz6ehppdnF4TsE15fbKx42UHQrkhp6viMNZONTR
	dx3qtH3Bbq8YIHKLI4uCFrid8lCIhkA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=MnKcIp1Z;
	dmarc=none;
	spf=none (imf12.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.128.45) smtp.mailfrom=matt@readmodwrite.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4b467581b98so10757805e9.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1794596227; x=1795201027; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qsLrdL7sT/af1ui02yqpWUBVQva/Rfa3My1unqAhcwE=;
        b=MnKcIp1ZLiT5mwPj2KxwDNGk8364WOjtNk+i/GMoKxdlWAQ8Vtb0eTpL8wsBl0GOpc
         vK8NlZtph4rO4M7w3yMz/lx+9G3q/F7M980rSg+6zVXdtChurF3WZCU/rmoPfgt4oe6v
         0GgGxhP44YnlcN0PdwtsJ+Tla7k4T4+dupofOQ7bpARZPxWhLZzN6CUAoP3PArCP3QV9
         AJeXj4AQ7piHIPHjA8m+Znh3DxyCHq5VvOxLSPh2X4n7W5EpoGI73JERRDBtxZOzLmlR
         uHneDIZbhExsu5ClS+Mr7sdS9YQHUbEiWIAQXK79abBUbM8ZOyTIRWjUfSbP+pd7+3N3
         q6iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794596227; x=1795201027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qsLrdL7sT/af1ui02yqpWUBVQva/Rfa3My1unqAhcwE=;
        b=lzGxyy5WnUQYw2z1paZa5jupNZl8wylBI+N7A77bhWjN1KDVOqHMZywfc8xxKiDQH8
         pYpIB2y7S0ES7ZS1t6kCAvzAOpd5ncBxZW8YwqYqQbf41atltAg0gXVafU3WONokGRWm
         v6oJxq+l/bIkNuRpXzU72Jnm4/10quGVSAItBY2O2O5p9Stcw/te1E9CNEUnFmERB+hM
         OePvk9gnmwSffHwQjwllNgNSRBe64DjQle3ixYx1QnjUIcMSrvYEzb4rbYO2bkIZHTeB
         8Wss2hkwMNofIbtV8K5jy9VcFZtTGbe9Lnk0R+CMM+vuAUgdhiFaAzilnf6nn037fUfV
         pD+g==
X-Forwarded-Encrypted: i=1; AL+hErHKm9op22thcY8SIQhM8FXWh+P0Y+py3zQHVds89Ze/Iqp0PKPIZReo+PVAoTzazMppBNnGXjCVPg==@kvack.org
X-Gm-Message-State: APuU4Z+gXaLswet+QFsgutjLZOQt+3MdlSiO+puOOORY48WUX+fBEXm0
	tRNfKgg/bxTHVs5nbwMarwl7Yg9ohA32q+brlJQps05OEcHcSTS7c6YwYUQlGlddsvQ=
X-Gm-Gg: AYBFou1j7kex4uhskeln6JFe74UEjTiseLkH6Sqco5U6AAwpFNaafXUBXTP+llIQ7UW
	wCrqOQUp53HIPeeikn2KUzvr3K7ydepm0jctKUN8w4xhRt6HWqVFoqUv4x9vXX+xWKyoYOFICau
	y+H6h8F53Qt1yTwq7C/aZlIh84mrb7n5jf8HIuirtzISWQPmtp0Eg+5hZsu29ilQzkFkufUqoh0
	mkiVlUT3ChBBeTuiXPNqTX3AF8seoGI6EFMba+vcKv1P8Zb0nfkJCDBtylopnmA4NRmkCiz1cTX
	NPjmEJzBl9Q7PtQ/v33R1lBXRWF4e63ISTE/HfSRoG0ZmRL8T9ohij53AEs3iETWo0PvDzDjlwd
	gp9fS3aoiZv8uYUWtyRhhnDHb+zZgnIMXqzITTnAZFAN/te5Vh9LY1BuRWWR1OMpSMo8WLofAY5
	FsfMdSF9lkbSFPM4/O2t28asMccl2eVSiEr5l19yNK68B9pNA1/j4+0kMdW/qmPAfTx6azvBlaY
	mkv1saiq4Hl4IaLE0U++w9Aee0mnFRIr0JQ76A5hvxiKFXWhYHQpN9fQXovv+2cnE8jppZFOhX/
	TNjNEXBjn7OMNFXf+K306V7Q4TZ/dA==
X-Received: by 2002:a05:600c:8708:b0:4a6:30c3:1114 with SMTP id 5b1f17b1804b1-4bb55a7ece6mr79207495e9.12.1794596227289;
        Fri, 13 Nov 2026 10:57:07 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:ec8::179:1b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f5972a7sm6417589f8f.21.2026.11.13.10.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 10:57:06 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <ckan@cloudflare.com>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v3 01/10] stackdepot: add caller-owned stack trace fetching
Date: Fri, 13 Nov 2026 18:56:53 +0000
Message-ID: <20261113185702.1332171-2-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113185702.1332171-1-matt@readmodwrite.com>
References: <20261113185702.1332171-1-matt@readmodwrite.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B83FE40003
X-Rspamd-Server: rspam12
X-Stat-Signature: 56jmdixgwtjr64yy9spiy6bzj5gph4of
X-Rspam-User:
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794596228-102455
X-HE-Meta: U2FsdGVkX18T3LchvJChXJYZp9Ix6OFkVrIyeQLJ6GK9bJ5H9KZDjos81A6gLedQL8Hq1KtzSFxKkBXJ0Edn0eM/YzNQu5T5tiPLtv+9F+OdailxEdS7rBc2wh8kPs4f9poHJT1P0gZ+CkVMQhgRXsqvLjSnVTJ6wE7+2BlhuQQLIvr6ybTSXFowIfkTl1sXhfjlyo9rd27oJs3T1w26FS/Z8zLyCLiusAOvqP8qCgY6vPkiWR2aP55/qd7DvoG2GqDF7eT6l+VDUHWLNuDKU0VzcMY3nZqGXLVIkh39gQHLfFST0ilQB8E7T8cKqp0xB1veH1DJc3dmtbDKDziPRn7ROyjBgZueI3e3V4JUSmB5sY6jbs8bk8JKI57CRw+Qaaavxf6e6Xl489ZwSZsBKqkuXQOshM/2Ct/NFjS1qHe32uO6kCzTWYIxQxcUrk+BynkjWV/n02Ie+gaPAFryh8NfKB4wsRFRhzuZ5ncd8fkix7tkNZy0OCBalXe0khfkTDo3v2y8A5nsuf1NWEuzZ1fmFp4xhSSHKh6BWtAio99ZDIDOYr6xk6n82OTLPd3HSfgmeXH4hSQxh3zT3TQYhdWPu6cgZpiqAkYYY90xbMB8bW8e+kYB7vu8YtWZ9Sp1r8x/DNWxhvbIkDvYDXMoP2O2Nrau0VI6jar20A6Vsy5omNqZD9uf0AwTJkIoLucUzsmh40NoBwOfxapc6VCMZUej4xg6vMUJixTIN7Wv3iYIf8uWLwa75ul2BbSxVtGdQzNjaAcJf3AzxCJCWNCtwKMxCwedBiarMbHt/H3rjZxkZqqk0gH3Pb27NVwxAi1JT8w+BKl/ThtrYn746m8oh9tqk/EJ+MHnonKpw8uxpbzBr/kXCMBtuf0LgYAlF1C6d5hJXxhSjgQBh2d0+tRZeNYrUVtl2YJAM08ZEY8ScAb32xEK8aBN+OmyXOYD3k2h0pOLZdfwi5AWMoWFeMT
 MA0GeKkS
 yYUS6hbvjSRFC/qhgoVeTv7qWGgcLw/+vDb33l+rdcsPgGr3ZBXxTZrFOMHd3pgxyPiRspnHOyFfQP7SZjXkunZijOI3AV4a2O+1V5H1RXETxEWWaEW2mryY2hK6hX6cPcRvGSj6z9d6pCBslkNs2YsLk+M+WyWUH/p2gq5Wuf7gkr8E42ngLGIz0jOana59a4EyHk5QCvtFn9xFmJ4G1BEWCOjn1d54bNfExx5HKR+66jZx+mhpNaYCB/+Mv3tNlH2Lx7AtYMkWpt5f9gZ43iUC/n/CNVyPS0TGm1lZUws6xe9egkJq38wf3OZsX2fnsleYn1LkrteSJHZqwm4J5u+R3vXkstx/J8Dfry678uVkpuRfAezLONoxo5ePEGROTMZq968WUd6wiUKTskK137r/Ug+2HSwPa2Ph45IrpggFck9ujFT+ddmDu7mSMKnsoshjv5htJd7NmIx4AdhYn8w003Qw31FzaIZ7bTMJIofOqRA+kOapbj1Vldkxpq7DXZDZ16XuRhFOTi/G16gaE9eKZnZMsbL3JavmBsrwflxaY3dYDuh3pgjckdzmqcrZdzWu3hFCKZDdAyeU=
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


