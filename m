Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3090CAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 13:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A33F8E0020; Wed, 17 Sep 2025 09:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273A98E0003; Wed, 17 Sep 2025 09:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1627D8E0020; Wed, 17 Sep 2025 09:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE2358E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:33:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 915BA1A055B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:33:58 +0000 (UTC)
X-FDA: 83898835356.06.5571BED
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id B64B2A0004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:33:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758116036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=PB/dLP6okMS4UB2K8/m8T0leXGzvWyq468DHfShm8FI=;
	b=I32YKZe+HP1YaiQovAllUVFMkKlYiZhpD9A7zNpMGO0cqvmjowdKVWboLwQdjqcMKDRKS9
	iZVyqrDXSQnAICpuFGozYe9YHK0ymUXwrpX70hU+Nd7hR+oVHrbIaFYvig+09nahSPiUIA
	COHCjNBwTztr9pNMkOOE23XEhjIG8O8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758116036; a=rsa-sha256;
	cv=none;
	b=j6DQRFteqN8lb0ueVcthtEtNGx6U+AIBz3rE6y4eyFHQEpkQcqEDxE/SqZjS/adrjKAHf9
	uZkpGkwJvqwc3EmyQxpKAHndCceykEB37cY8vcoMJ1UC5zPT9LzhbfKMpTmIzr3TvFSTfk
	Fhw8ox5Gir+vio4OMJtB3CNdySSBN+0=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4619eb182c8so8725635e9.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:33:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758116035; x=1758720835;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PB/dLP6okMS4UB2K8/m8T0leXGzvWyq468DHfShm8FI=;
        b=F7CSYlfWFpCtpHRzkfq4O3gKXqILbDsk4iuS1k6VgElagjt16Z2aUey7Deo6cpaezP
         UOqdlHcpM617btlpYtmzPucegQT5OrfFmW/xumj/SfQ68kFtwM4cmYu3iD/LL50hyOaE
         V50eaLe7+3b0w2PudyKOkMCoFTHAwdRfRTGJ3pJcyt7lMfgGSnb6H1GPg+/SibbxsMRT
         H4wAMQJFmfxvUvWol86qAQb2huud3wtESwElx/WDcoSifICjWssMAuyARGxCCheiKnY8
         JZq9sdmyV+8l1oxc1COXXLXhwg2+XPiicNU6jcWIh/5EtnGW2xpM2hAu+Ji/dIFql2hH
         bvkw==
X-Forwarded-Encrypted: i=1; AJvYcCXCRfIpQ4AvK8YdLLSDHw/GLUygX4X8unalRJZcJvVKq5B6FiyWXaW3IWzEb77MiCTE8DHmtCg89Q==@kvack.org
X-Gm-Message-State: AOJu0YwMpWf6uczmUIlIncypWqRa2qbm1IdZtZW7EzaBllAjpme6xXjl
	AZvr0HIupV5SZmMK8dlt2HgJSTbo2y8bxTi+3v0visHJWm7Oeutq0OqV
X-Gm-Gg: ASbGnctb4Tyhe4uxbTXVSXZreqZZv6JNZHpPWFi0atsZGlgr+dcgQOE/EhZ1vrA/naE
	6XrdQdcLV0yNvYXJ+pqmaZSuUa0DvjS60huta2e+cOhl420T1ZOm2FF26XbfYX5ddcOaQr1fe2Z
	kltHnIA89cbelzZvKBLANBY2WSfGnj4aQREm6NdQoT4wz73gGb7Bhhw6U38en69V7U7Q3p44GGt
	YFzo1OnRhlkk+dyCxboAKF8O2l5EqHp5a9HkUp5nI/RmQWPx02kpj1yzFiZM+801xe7TOjxIIdN
	V7Yq+v1UCSnL93d2RSYMSo+QHZyPke0xlaqkmJ80U3I2zYiDKKcwDyqEi26syvuK4rezTqutq8F
	pvxp6/EJddgs=
X-Google-Smtp-Source: AGHT+IHct0Y/HPdTudotgDrMkhOC/Gqh0P/h5DFuXgasUmqgBiIUkvyCvRBlCVJGcbLI22/xe1VfaA==
X-Received: by 2002:a05:600c:3547:b0:45b:8039:6196 with SMTP id 5b1f17b1804b1-46201e96069mr23430525e9.4.1758116034842;
        Wed, 17 Sep 2025 06:33:54 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::30b2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdd4d15ecsm3871446f8f.11.2025.09.17.06.33.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 17 Sep 2025 06:33:54 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: shuah@kernel.org,
	ioworker0@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v3 1/1] selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled
Date: Wed, 17 Sep 2025 21:31:37 +0800
Message-ID: <20250917133137.62802-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B64B2A0004
X-Stat-Signature: cph8xuw7bcd3uge5rkuh5bsoyykygfqg
X-HE-Tag: 1758116036-204458
X-HE-Meta: U2FsdGVkX1/SoQ6ezoDb7jt/lOhonP2M6sEi8zlIxUPQ2jcjCHq4wT9TZ6hspY6Vnvyi6KGHB872FNeM4T11yAvGgRnEgegKzQ86JDxqDYMyDVLsBKu1fUzAqYC2IJBlvZ+PU9TTuVU9JKfxWGRUk2t3rpnY7HYQJ5IA4IJXno00wO3wlbtBsZWeQJGeVD34cZXLnm37/G40O6Ax4CH362hBaXb2DnmkIyHqpUcZv1Osa1ZefTLM+q9qX5cw9trYyE/YCW8AqTB/cKyOcoUJhdsKitPIj7bIdXJuv0p0p8Rp0sOVivia2isWAxPfXFGx2kstTstm9H4o+ixXMcjDeMU0CZmVzkfrcR6d6gVyxn7oxjl60vgX4HbRh16g22DmsmBYj9LliUb8jc9SlWlvXM1gUlFEVtw1tF67FxByTunObUyHd0//FOVj3AcVy4u7LzHqca4VTOBseaTiFz+oXvNcwBtQfyU1m9qsAJp7MdXrpwAuxZc+6zJfiw08P1+hsDbN0Edhqwh6tgsY9wN1th1gSv0omKAsIbPaQMOrRzapOQSqBQoDLPAlByMNq7/RnGUv15W9zwMgUMcljMASStMrP9buin1IDrH7kPn931D/u4f2aoUtmZ8IIKB2kINlLEDBbKdyBIYoGgpbVtUIMSNI65SsEHmBRs9NnFR/ggNKm9Dx/0pJTkGo5Ja01ys+WcDJ1VzKJaMq7jo5y02aVXN3gntSOohhOtBY51K3lVtuYsvqRfkrZVfmdAW8i/CUgo5WOoNXXlKNH8eJxeDmpKxnc875ALaTZhbD4wGBLCs1lFItJacCX3c9axrhSCGSFUWOiuIH04LTcCcXWK6LKHpWoy4wg7aOhmlAjrLS71rLx4VW1ZVQA0YOohj6G8sGor35hsPkAvMdcUoqZ1NyL8LtdlwcO2j2SWaJ79A20TgZEcK897hCXA1aU1UJHI+FCjOseu69/RdrVKwr/88
 aNBsMNy1
 pOUCU2Zq9J6N94I+3ZnCxYaer2eob0+N8UcPkyFkGXtGB75kNmSzPMQ6o0e5kDH3AYvhWiPkJE2Rri3Y5HKqMLo00XN6Ul5CbpjvNH07AJ01c2IDV0FqOmpXXVzUJUs2iju0db1Zp8KVz7gyyIuzCBDCrPPDZtUuQYKE3PipDKfsLx/gZ37ZFASR0GtYM2NJcRVlsg9wtWC5PnXnRh6Nd1F/tNCwnT3eOtBNWy+xcESjku6Xxogg1Kn4x7fLm66jjFtVPa6I7QDJ11L+RqfhHINUhBhWlCJkKwWdrpKjn1KQefz44gZiDDC3aGVCn6CqPrFAMdh6KgQ2HB3LzNN30VpI5M+/4CdU8aM2BmC9m8WJtq+kGNJcJGhGKCX4iZGYwxtvWeP0MJSWXOf19LLleGUqA6WQ2/lNHPHhfUnkFNA1mSF5rcuI/s9ACX4GNZEOtgr8Q6cC+rQjeKl7wrhnfv0uT2QiVFqmnaGAAO/pYye4E5eSF+3BzpnXSLWN75xA1eYY0lnQQsFIwS46KMtjQrU9ludN0QOkNpAQI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

The madv_populate and soft-dirty kselftests currently fail on systems where
CONFIG_MEM_SOFT_DIRTY is disabled.

Introduce a new helper softdirty_supported() into vm_util.c/h to ensure
tests are properly skipped when the feature is not enabled.

Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
v2 -> v3:
 - Optimize softdirty_supported() by directly assigning check_vmflag()
   result (per David)
 - Pick AB from David - thanks!
 - https://lore.kernel.org/lkml/20250917122750.36608-1-lance.yang@linux.dev

v1 -> v2:
 - Rename softdirty_is_supported() to softdirty_supported() (per David)
 - Drop aarch64 specific handling (per David)
 - https://lore.kernel.org/lkml/20250917055913.49759-1-lance.yang@linux.dev

 tools/testing/selftests/mm/madv_populate.c | 21 ++-------------------
 tools/testing/selftests/mm/soft-dirty.c    |  5 ++++-
 tools/testing/selftests/mm/vm_util.c       | 17 +++++++++++++++++
 tools/testing/selftests/mm/vm_util.h       |  1 +
 4 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/mm/madv_populate.c b/tools/testing/selftests/mm/madv_populate.c
index b6fabd5c27ed..d8d11bc67ddc 100644
--- a/tools/testing/selftests/mm/madv_populate.c
+++ b/tools/testing/selftests/mm/madv_populate.c
@@ -264,23 +264,6 @@ static void test_softdirty(void)
 	munmap(addr, SIZE);
 }
 
-static int system_has_softdirty(void)
-{
-	/*
-	 * There is no way to check if the kernel supports soft-dirty, other
-	 * than by writing to a page and seeing if the bit was set. But the
-	 * tests are intended to check that the bit gets set when it should, so
-	 * doing that check would turn a potentially legitimate fail into a
-	 * skip. Fortunately, we know for sure that arm64 does not support
-	 * soft-dirty. So for now, let's just use the arch as a corse guide.
-	 */
-#if defined(__aarch64__)
-	return 0;
-#else
-	return 1;
-#endif
-}
-
 int main(int argc, char **argv)
 {
 	int nr_tests = 16;
@@ -288,7 +271,7 @@ int main(int argc, char **argv)
 
 	pagesize = getpagesize();
 
-	if (system_has_softdirty())
+	if (softdirty_supported())
 		nr_tests += 5;
 
 	ksft_print_header();
@@ -300,7 +283,7 @@ int main(int argc, char **argv)
 	test_holes();
 	test_populate_read();
 	test_populate_write();
-	if (system_has_softdirty())
+	if (softdirty_supported())
 		test_softdirty();
 
 	err = ksft_get_fail_cnt();
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index 8a3f2b4b2186..4ee4db3750c1 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -200,8 +200,11 @@ int main(int argc, char **argv)
 	int pagesize;
 
 	ksft_print_header();
-	ksft_set_plan(15);
 
+	if (!softdirty_supported())
+		ksft_exit_skip("soft-dirty is not support\n");
+
+	ksft_set_plan(15);
 	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("Failed to open %s\n", PAGEMAP_FILE_PATH);
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 56e9bd541edd..e33cda301dad 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -449,6 +449,23 @@ bool check_vmflag_pfnmap(void *addr)
 	return check_vmflag(addr, "pf");
 }
 
+bool softdirty_supported(void)
+{
+	char *addr;
+	bool supported = false;
+	const size_t pagesize = getpagesize();
+
+	/* New mappings are expected to be marked with VM_SOFTDIRTY (sd). */
+	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (!addr)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	supported = check_vmflag(addr, "sd");
+	munmap(addr, pagesize);
+	return supported;
+}
+
 /*
  * Open an fd at /proc/$pid/maps and configure procmap_out ready for
  * PROCMAP_QUERY query. Returns 0 on success, or an error code otherwise.
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 07c4acfd84b6..26c30fdc0241 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -104,6 +104,7 @@ bool find_vma_procmap(struct procmap_fd *procmap, void *address);
 int close_procmap(struct procmap_fd *procmap);
 int write_sysfs(const char *file_path, unsigned long val);
 int read_sysfs(const char *file_path, unsigned long *val);
+bool softdirty_supported(void);
 
 static inline int open_self_procmap(struct procmap_fd *procmap_out)
 {
-- 
2.49.0


