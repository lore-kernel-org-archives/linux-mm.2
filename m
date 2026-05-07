Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22D22CD3427
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 11:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BCF76B008A; Thu,  7 May 2026 07:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86D646B008C; Thu,  7 May 2026 07:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C9A6B0092; Thu,  7 May 2026 07:49:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6606F6B008A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 07:49:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA9E71604F5
	for <linux-mm@kvack.org>; Thu,  7 May 2026 11:49:56 +0000 (UTC)
X-FDA: 84740454792.10.4AD96E7
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id DEBC6180010
	for <linux-mm@kvack.org>; Thu,  7 May 2026 11:49:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=saQpYcJt;
	spf=pass (imf06.hostedemail.com: domain of jillravaliya@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=jillravaliya@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778154594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z6CMcPMHo1KjTKUz3wKsL1u6+inZkBTTdzPKKufaP7s=;
	b=1WpSHj4TICdAmMEtHVcYorEeKUrGwLcLIj9+Z+USGPveSrz8l8ynIqdSV4QdapolR7jSgo
	oMtHb+cJEfPw6r5boamgsRzIZw7l8VWRUHJ20096Ee04LflamRfJ+VdThrAtYv1XRb8umS
	0cnhMbO0i1m/sq1VHTQJCz6UvvOXCPs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=saQpYcJt;
	spf=pass (imf06.hostedemail.com: domain of jillravaliya@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=jillravaliya@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778154594; a=rsa-sha256;
	cv=none;
	b=Szlb2Lu2YTd0zSFb60G1DnC+F0xVHzPDHG92Hv9SEHyKAdjdZ6gMj9SmnGlSzceb6gCpyT
	3IxUCHWu45Glx9YKSLO3zVp4D79CwJJ4uX/Jzz7xEXFPIcpv/JeieQgB0LsI3wPaJf/7zO
	HaNS9E6t1AWRbazEDsS39ciYaxhaoP4=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c70fb6aa323so258916a12.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 04:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778154594; x=1778759394; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z6CMcPMHo1KjTKUz3wKsL1u6+inZkBTTdzPKKufaP7s=;
        b=saQpYcJtA32eS+CY2vVjFft9tw6L8SkAFVRxoavgGZxijzEBG9RoyqnRBeIevUPYAJ
         71euiq4wFv6YYRuwy8LlQ816+xwRtv4SW8ym9NmUD9YmmjILCwgUtmNkylCo3iQApDpc
         0uthiUjTEt4ps6rMUvuqbcUOC6pnWQnNrOuVExP9nVRpBhJXPekPSxzvHq7W6LBVr6+h
         5aYCfI3CdjBMic6oS1n2eukkbEbX33Alzd+kCvvzMN7CeOjA/r5lNxPZSUa9EPIrDlZS
         y8hldc3wz2PRAf9AZ0++OzinARc3vL5Xbfe39oTqQcJlcl3MVdkjFAO3TYzw2NBIkslz
         DX5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778154594; x=1778759394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z6CMcPMHo1KjTKUz3wKsL1u6+inZkBTTdzPKKufaP7s=;
        b=NXVzgZkOrh9BAI2gAsV+GwJGtLX5m+/nDM7b0lFBWKt0vNIzFZ+FeugjAghfHj7Wv1
         h9RG5Y+IEFrrqoA6F6et+EgJ+lm+LNwsyxzEqV1YAzGuN+yqBFNuo7uLJxtjqd49O5JW
         dCxplPIsrtIRUs9ATzVHgE7M685/oXTIPti7DSrjpsAdUc6dhb51rB+vYGxGTTsviwyP
         dC06mfG/XohDkec75UZ3XhradQDfh2//+FOgCh1+uylhwxf6MtlqpYaHcWDQ+Ex3bFES
         1Wxsz8Gh7o5zuJ2XdsXxaC+1l5EEPkViqE6xW8BZJp6ELYbm+FA3/frc3l2boPJ7Crxt
         XYwA==
X-Gm-Message-State: AOJu0Yxt6qc1dR2gPokFzwTqlEXJ1y3uWerSWqVeFaK4mQbXnhO6z6rv
	12Zo0Y2L7W2dp9T0crPXxxf/ZE+mjasGBSdJX7PmTSix69ROH6up6Ab+
X-Gm-Gg: AeBDiesPU0VAbKCmEpkWACR7ySqOJ72RbvMpF9fSXBwKnRSRewiDwq2rLgQLgDiDfSa
	wLKViFvhAD+jW0U3vG6Kv1/kMT3MOdFajL92VQ8jBNCpnbzQg81qo/t8Y9YDYB3xAxLpBmNNq7h
	JhiyF7M6DxJn7TLg9wWYMr4+H0aXCTRWOGpK4PFWtoabIi+2IO1c3MMm+sHWYj3CMB7IE9BR3z9
	pOM9NhGDS+iFR106ySo1zjZ3THpYkEQF0amwqV82HmPG77geG6oh2iy0jWekLqjO1HBJ5EZdpwD
	FBBaWpl9Ju4fPTs8OXWhA9584H0nE10Ces6U25Mma/jLde8SNFyF0wUwIwaLxawVZBRhwXuoX10
	nP0yka15R1JsplWgGYn2JSJDC10qs/AdH//chjDV8N6f0okE9fAR5vH8jYXu28fGW1aPLBMByA4
	nqm/jsvO2jDp700JrCUM1RDgEoARtmUYZHwt2CwlzpMOW3a18bBgBG528WbQoJ0oxTOcH7vR/i+
	gY6UIWICEw=
X-Received: by 2002:a05:6a21:338d:b0:3a0:aee6:acc1 with SMTP id adf61e73a8af0-3aa5a9aee9fmr8053006637.33.1778154593516;
        Thu, 07 May 2026 04:49:53 -0700 (PDT)
Received: from jillravaliya-ASUS-Vivo-AIO-V241DAP-M241DA.. ([2409:40c1:2022:5af0:565b:1ce7:b5ad:c8ae])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c825378fd56sm2014106a12.8.2026.05.07.04.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 04:49:53 -0700 (PDT)
From: Jill Ravaliya <jillravaliya@gmail.com>
To: akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jill Ravaliya <jillravaliya@gmail.com>
Subject: [PATCH 2/2] selftests/mm: add test for vrealloc() shrink page freeing
Date: Thu,  7 May 2026 17:18:54 +0530
Message-ID: <20260507114854.41117-2-jillravaliya@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260507114854.41117-1-jillravaliya@gmail.com>
References: <20260507114854.41117-1-jillravaliya@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DEBC6180010
X-Rspam-User: 
X-Stat-Signature: gkan3kbsy4y1yexsppgyk47ag4rkszy6
X-HE-Tag: 1778154594-624680
X-HE-Meta: U2FsdGVkX19c6OVrw0fakcbVXwTBwQkJPnU+Doe7nSYogQ6zZ174az0RN/tSP5xqMYPnzHDXdo/VHBKIQ4tgFMaE9Y8FuAH6z9ouI1yI4RLRORrcoIkMdBWfnB0xCYQ8rG+WdovHrnbMlrVIX2YEkraK7V/r+1IxHTNcmvP88wPUOv/+FtoVaMkzvSG6vjzx3kE7IubCXVMHLfMUuccE0empQZn4yrsJ8ZVZ4Rokq1kgcTMCvaTL0fHO4EhG5m3PIl+7b7FZui8860bhDWo7xP7QKjXCh+W8b6pkSkiXAaMc2Wf6pMQfJQydeBONBpkyehWB3hNI3P7brJ+xj7+vKV/iHKKB9hE76OpQXJ/km2/r04Eza5npg/ipE0jZDjBcJoL8ZOGzRRhKcI1yX/auBabe1xLmwvHLrAiXHE/c4L0dyUQBOc9or6FSvLGFTNmaKerut6tKaLjS7DtXaIKsFpmW0iuk3c67601Qs1PNHG0jCHUtvJeYub9ib2CQ7TWBC3jLCzAsreovzhclUEdi2v8FAwzY72CDtseG2rr9PFulkyeUEm52yZA/ValgpgPnuNxNOi4uOLKLNBpqAPbJGj0GJm6t66OYnt2xp5JpJ897paN3WHbA4EQwOCbnqIPQh88TUr5tYMn7CSCI62nb6xRbOagyw53JHhfQeMdKjosuNC4ca6TkhBi5BdfcL1mXRpNChJYabuJDH2asmlCZMH+OZ1U5hEVELU/36IzC0FOHgsLkChDoIyPLquA0UyQOQ+2/ybZ/+NL7uLWaOqUWYWSGMW9AH5S970pLuKMMubQ9fDDXUp7EPNzrb8XTYwhaKZ5c83LznEb3Dn0R0v5EBktUQpgRix8DV4nWqCYHX+zXC13XA/vtUEGPeY52XMSTSeHHTvsnvFixRWneaSFKFE8qg+FYtgqZWDqvSX5t5DIiWvFPELRToiHxXe8gG9wbC3L/C3QocPc0N9CCaPz
 mOrS0qOS
 jLRYbMVFX9PdrG9B41Wt3cIUhU65RFX6xOWD90lpEm66RMpnD4PB+0dx1fA3xFIKryJX+GR3y+KJ69qJpF4J7jPajSqLbQ2qviKrTXGq3NWcJ1vyP/ZzuRGjwnAhEqImVHV2okTFn4AS07udnjl40LuSNrU/i2dyY6w9Dimvus9f2YZ0cnB+IA+lPn6DVWLVRhh3aIu7h1P91ktMoetzs0LmyMcqGP964IyMTn9mNWx/uf9NZ6LCuQwQL5HGnzOvnJtd57BbXybNrPwzOE0WVJmE5VyXENUNMWUOlEFyTDTX1G8sd5dkHmxolyYxFsZTp+sYHEc4GHezLvEaVh6BO2x/hT4GzSj7/sCfPKwr9fjJYw4e3A6qQJHcoA/D+pTvwA0nwyNaukGykem+W14oViYxbcJe5Y6rEWQmJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a selftest that verifies vrealloc() frees physical pages
when shrinking an allocation.

The test loads a kernel module that:
1. Allocates 10MB with vmalloc()
2. Touches all pages to force physical allocation
3. Shrinks to 2MB with vrealloc()
4. Verifies free page count increased after shrink

Without the fix, the test fails because no pages are freed.
With the fix applied, the test passes confirming ~2048 pages
are returned to the system after shrinking from 10MB to 2MB.

Tested on kernel 7.0.0 in QEMU.

Signed-off-by: Jill Ravaliya <jillravaliya@gmail.com>
---
 tools/testing/selftests/mm/Makefile           |  5 ++
 .../selftests/mm/vrealloc_shrink_test.c       | 65 +++++++++++++++++++
 2 files changed, 70 insertions(+)
 create mode 100644 tools/testing/selftests/mm/vrealloc_shrink_test.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index cd24596cd..4eab7c76c 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -104,6 +104,7 @@ TEST_GEN_FILES += hugetlb_dio
 TEST_GEN_FILES += droppable
 TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
+TEST_GEN_FILES += vrealloc_shrink_test
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
 
@@ -282,3 +283,7 @@ warn_missing_page_frag:
 	echo "Warning: $(PAGE_FRAG_WARNING). page_frag test will be skipped." ; \
 	echo
 endif
+
+# vrealloc shrink test module
+vrealloc_shrink_mod.ko: vrealloc_shrink_mod.c
+	$(MAKE) -C $(KDIR) M=$(PWD) modules
diff --git a/tools/testing/selftests/mm/vrealloc_shrink_test.c b/tools/testing/selftests/mm/vrealloc_shrink_test.c
new file mode 100644
index 000000000..cf4263074
--- /dev/null
+++ b/tools/testing/selftests/mm/vrealloc_shrink_test.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test that vrealloc() frees physical pages when shrinking.
+ *
+ * vrealloc() shrink path previously zeroed unused memory and updated
+ * vm->requested_size, but never freed the physical pages backing the
+ * unused portion of the allocation. This test verifies the fix by
+ * loading a kernel module that directly measures nr_pages before and
+ * after vrealloc() shrink.
+ *
+ * Copyright (C) 2026 Jill Ravaliya
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include "../kselftest.h"
+
+#define MODULE_NAME "vrealloc_shrink_mod"
+#define DMESG_PASS  "vrealloc_shrink: PASS"
+#define DMESG_FAIL  "vrealloc_shrink: FAIL"
+
+static int run_cmd(const char *cmd)
+{
+	return system(cmd);
+}
+
+static int check_dmesg_for(const char *pattern)
+{
+	char cmd[256];
+	snprintf(cmd, sizeof(cmd),
+		 "dmesg | grep -q '%s'", pattern);
+	return system(cmd) == 0;
+}
+
+int main(void)
+{
+	ksft_print_header();
+	ksft_set_plan(1);
+
+	/* Insert the test module */
+	if (run_cmd("insmod " MODULE_NAME ".ko") != 0) {
+		ksft_test_result_skip(
+			"could not load %s.ko - is it built?\n",
+			MODULE_NAME);
+		ksft_finished();
+	}
+
+	/* Check dmesg for pass/fail */
+	if (check_dmesg_for(DMESG_PASS)) {
+		ksft_test_result_pass(
+			"vrealloc shrink frees physical pages\n");
+	} else if (check_dmesg_for(DMESG_FAIL)) {
+		ksft_test_result_fail(
+			"vrealloc shrink did NOT free physical pages\n");
+	} else {
+		ksft_test_result_fail(
+			"could not find test result in dmesg\n");
+	}
+
+	run_cmd("rmmod " MODULE_NAME);
+	ksft_finished();
+}
-- 
2.43.0


