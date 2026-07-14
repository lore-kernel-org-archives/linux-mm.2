Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A15BC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F5CE6B009E; Tue, 14 Jul 2026 14:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5EF6B009F; Tue, 14 Jul 2026 14:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 696086B00A0; Tue, 14 Jul 2026 14:33:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FA2E6B009E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:33:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CAC0F80439
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:33:50 +0000 (UTC)
X-FDA: 84988231020.25.AACCF37
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id D23354000C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:33:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aIzc3pJy;
	spf=pass (imf07.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784054028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GxRwnz/utPYkA9CVNI0v4sXDVqY3MfYAVIwDwIjJvYI=;
	b=Sx85fr/vPuNB5GwBXYbO9/9G+XoOVi4FF8ZeFfYFl3Q49qOOGUpSbcIuRxGntBPd5bmhjk
	CTPU5IsvOJ1/SuPTkbyiOxS3E9uzihhqy3yGMZ3s7LJHj9TobcP10S1vyEgfrVThPC7Ip7
	cvEIELpxPsZSIIbU7ea8HICrLJb9NvA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aIzc3pJy;
	spf=pass (imf07.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784054028;
	b=kEMoNVf5GJQxeXtq6fOcAQwtgWS9RrrllkbI81FiN4sfKdd5c37HzNAvjtq+A4EEKYqYr9
	DfrBu2x5hrStineoz+j12abaVc5eVzlU1A1QsTZfNeMGZb/oGeRkpdYTa0rJXeo4EXCW0n
	8mLkJJm8bWRt+ffgBTqFviNN1B//noY=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c01089e8aso10192701cf.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784054028; x=1784658828; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GxRwnz/utPYkA9CVNI0v4sXDVqY3MfYAVIwDwIjJvYI=;
        b=aIzc3pJyIkhQ1SMwTWcF7T5IMpEjRpkh5sOKW1YwsLX5vAZSBCZiXK2ZtiEyNcu2G1
         BdgCtS1aULU0iDL1OjrHwmydhyal+bxLHsdsONM9JSZOF81JmgQOi7I3LS5tvKVZtJYC
         okYQnrMYOHFUc+0kQ/G16XgsFRX3lK83ZkjRpzSmtKx/diGK+6dKkBe6IBhFt3PDcTf8
         s/ZuSgVr0wVOkg5Me/vVzlAe4RNWScsJDiD1mAc3kFSJFGMqr20S6RIy+s0mZgbIUNqv
         bo2sTt8Ofg4eqLLhUu/S+IxK93BcA1ZB2/+0LDU+zoQDWthW6JjnREKqZUSqIWvQ28Cg
         yAow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784054028; x=1784658828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GxRwnz/utPYkA9CVNI0v4sXDVqY3MfYAVIwDwIjJvYI=;
        b=reog2c02uI9+eQIByK7sx3r+ORkFawS9jvnMwdKvwuy4Xew0TmDPRzrih/PqR2m+th
         l8k14cMSdYSrMQ3m5mgQtJRbigLn7D6/X3Vm1LKuH0SIMH4+gRUttXesQqkOGr6KJPoY
         b6S2SAfQFvrVZL88CATAXfik+6ApQrpIXwGFrt2RyOJR53Pxygte82HD+cSQRrovSx8G
         lJWt/hm+oEu7/dD9SR9ivFjUg1wuLkNuQzie64FOHf3t2ayWk4UnaBcFPADGN97kSe+Q
         oOl/t9S3/YNfYBkSlBnFjDy8ViblJLpaouJy1S9cSoy+gKNft6xgyIpWLbeumUmxpwbl
         GfgA==
X-Forwarded-Encrypted: i=1; AHgh+Rq79WZp2n1lLzceYueblVauSV/4ysAFBytshc3Q2Y+DwHWU2GLMwrLvdFtc2fs4eLQlSsYalOZ6PA==@kvack.org
X-Gm-Message-State: AOJu0Ywr4FTVlxOiZd0Zn5KZgtMPl9eD8f4mv1IXtss8zft8uq8TP/5x
	ehPOoQ6e5TGkAAgXj2Mc0q80jr+26yEU+P//cGVmy3Lr2bMviD6faVe7
X-Gm-Gg: AfdE7cmntA/tF++84g2d7JKvgqxfxP5OY87PI4Op1MG47bO2fh+ZHdtvHXLhCTD80Hk
	RgLLFABiqFas/uiaR+F1i78qbvcyybUtP9a1c98SRoTCFBBe/n0v5ai71A4+HCyb025I+v2qMqG
	Z9lonGykNQG+rZ1DjD4mUvDxFiro+yNh62ODx1ijnQ1EFqFKD/bnFEIqF6xsjuOfM/ULfhUvX0a
	jFPqjow3tYmk0G2F1F6scwroIJRTKMASfYmZFZveVXiqBZN6w7j4wbZNk5d1qMDzkBQG6xf9/Rn
	8wzczRpbL04x2VknnQdiVVw9DvVFYgEXXONn1i5aed2GR5N6ZE9UyKvpkfGPr90EYqvxLVmFtD/
	AvbbzMKFhPZmGH0Qs54aMt/QrJAlbLN7YEPbzIBANFFxSyHPai6TupTv2GOoQ95FusrIpYGzVZ3
	MnDdpH3A7CrBpJS7Y+Y1ooO9rb/yUasAP3tXIob0olTjUpxGieUuk=
X-Received: by 2002:a05:622a:993:b0:51b:fe7a:4eb8 with SMTP id d75a77b69052e-51cbf0e8c9emr148137331cf.35.1784054027768;
        Tue, 14 Jul 2026 11:33:47 -0700 (PDT)
Received: from localhost ([48.45.163.146])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd7c1d22bsm173718936d6.32.2026.07.14.11.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 11:33:46 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 12/13] mm/kwatch: add KUnit tests for the watch expression parser
Date: Wed, 15 Jul 2026 02:33:39 +0800
Message-ID: <20260714183339.13044-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260714182243.10687-1-wangjinchao600@gmail.com>
References: <20260714182243.10687-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D23354000C
X-Stat-Signature: pdfa5c91xaw6hrfpzs9kef7pg64zjg43
X-HE-Tag: 1784054028-86491
X-HE-Meta: U2FsdGVkX19zFJBB6PZEgAJ/c7eIR/3LGv753WRy2hcLaczB7NpcgZHXQiRjgn6zXb8CcjL8frnzCF9NCMv5g7ybLSZipftG/9j2GSIREGGdyKJbWsd/osCXBy7QepVKLva4oEinfBfAa3nlwo2sk1YirCoIS/dseOcCfb+JLYSRqyQM7oQHWMUAZTJyvWc/OkmLXN0I5zrIXLWDfxrmB7NMdonl897OEVTu3QSEi70dNXM4OSZPrdbYfDKDyy2mf5apWuKPSAIateczuzNDXeBYE/RdNm09cAwILpJOSctfz0Xo/4pKgoikkyhdArypoMSdf3Z03y510fpkbPph/Gc6XnX4+VsnVfFrQ4ueS3E6+b6ca/g8Q3vR/j+S/hClKy2/4OTOvq77DUHOCo0+fkyBesgXl+AN/WesN13aI5k972P0NSUPetOqcShASXP+wueKl9RAi1GSJQI/MNxP0ciacJkk9jKu12cpovEebyzKMTydImPYAo9+7aaLfkDp8CORmbnWgNcIFDghfoSO0OPHiIC/yqV2ov1wTblnaf9rYFBYdaPrWxJSfHi5rrczwrE3GvpraVA3uJGPUvW2rtdRIA+RI0ByqfAeTIdbdmNv00wJyTcFSv1rek3u1TnTVZZ7IvJ/88m4fMnXJkG5Mch7H+pgbc6TgVpknto7pE3SJvVMue93j9bwBUzOh5/kSWIvaIavUFsk1I2+ep/wIDViKcsc4DvkJmpobjKWgqlrogXTUzIHqUAfpwd90hEsPWfxVViJ+3F//G5rgvJu3tv7Xho4OT6UWArHOEO4Xr6cGw2oWWpSRoPHjiw7cHrqXlsOIBuUG/0IlcEJOi2AeAggTaTaI+H7TTH7kvm6eEjkY0eCv6UAF3Xy8YVBSa7dHqRWdbDUspOSC/8rm0LO54HW5EeaHowbiGyTbujtSm7Bf4ya9QSFavSxefnVECarwJuR+4/MY63JS+Z8wxz
 KnWDl9fQ
 8RxmKIaBozXel9l8X+BClRzS5+YUvW7JxTJtYl0EpYj7ztT5g0a03RovFtwH9K9iYtbp8JrKyEZWBZnDFSp1p/E81YMr6ugsA9icNmgbQhNBkxsQuzc6ts5dlBMQX6KWinEduCqlIwmqQuEohq6ntfStLNrsQJm6jfEMLorkt7NDiR7xnCljiEh/+GfguasW+WTQsI6QprK2pkE97FiBCOCKTk2apUlhX68Vb2Gh+k8VWiQ6kU6/zby1QRSU7CYhFoZhtL81k6UTLrQ3SXrlUeFO9wnx9yg4576Bharebcr4/TDEy+13JwSHgPfT3EhiDkta5b6zvt2Mzj7cPLLF+NMIUZJYgnd/sMf7E8eleeMhLzkMhiKarmvwA7yOL8c2PbmDLikWZQVxCyQ/YVw+iXDO7swzfMkRp3vYwxrkz0PB3h/J9gGBM7NTjby87y/1vYW0bg9/xmuGmUKvBJqp/5z1LRwfErWrGWkIxLxuam510adA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cover base anchors (stack, argN, absolute address), positive and
negative offsets, dereference chains, and rejection of malformed
expressions (missing offsets, bad argument index, junk offsets).

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kwatch/.kunitconfig |   9 +++
 mm/kwatch/Kconfig      |  10 +++
 mm/kwatch/Makefile     |   1 +
 mm/kwatch/deref_test.c | 137 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 157 insertions(+)
 create mode 100644 mm/kwatch/.kunitconfig
 create mode 100644 mm/kwatch/deref_test.c

diff --git a/mm/kwatch/.kunitconfig b/mm/kwatch/.kunitconfig
new file mode 100644
index 000000000000..7e977ddf0da1
--- /dev/null
+++ b/mm/kwatch/.kunitconfig
@@ -0,0 +1,9 @@
+CONFIG_KUNIT=y
+CONFIG_KWATCH=y
+CONFIG_KWATCH_KUNIT_TEST=y
+CONFIG_PERF_EVENTS=y
+CONFIG_HAVE_HW_BREAKPOINT=y
+CONFIG_HAVE_REINSTALL_HW_BREAKPOINT=y
+CONFIG_KPROBES=y
+CONFIG_KRETPROBES=y
+CONFIG_PRINTK=y
diff --git a/mm/kwatch/Kconfig b/mm/kwatch/Kconfig
index b1c37a829dd5..74083040a1a3 100644
--- a/mm/kwatch/Kconfig
+++ b/mm/kwatch/Kconfig
@@ -15,3 +15,13 @@ config KWATCH
 	  exact instruction causing the illegal access.
 
 	  If unsure, say N.
+
+config KWATCH_KUNIT_TEST
+	bool "KUnit tests for KWatch" if !KUNIT_ALL_TESTS
+	depends on KWATCH && KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Enable KUnit tests for the KWatch kernel module.
+	  This suite tests the core parsing logic, the pointer-chasing
+	  finite state machine, and edge cases involving complex watchpoint
+	  expressions. If unsure, say N.
diff --git a/mm/kwatch/Makefile b/mm/kwatch/Makefile
index 02d7917602f1..1d223d73b461 100644
--- a/mm/kwatch/Makefile
+++ b/mm/kwatch/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_KWATCH) += kwatch.o
 
 kwatch-y := core.o deref.o task_ctx.o hwbp.o probe.o anchor.o
+kwatch-$(CONFIG_KWATCH_KUNIT_TEST) += deref_test.o
diff --git a/mm/kwatch/deref_test.c b/mm/kwatch/deref_test.c
new file mode 100644
index 000000000000..094b7afeb235
--- /dev/null
+++ b/mm/kwatch/deref_test.c
@@ -0,0 +1,137 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <kunit/test.h>
+#include "kwatch.h"
+#include <linux/string.h>
+
+static void kwatch_test_parse_deref_chain(struct kunit *test)
+{
+	struct kwatch_config cfg;
+	int ret;
+
+	// Test 1: stack
+	memset(&cfg, 0, sizeof(cfg));
+	ret = kwatch_deref_parse(&cfg, "stack");
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, cfg.base, KWATCH_BASE_STACK);
+	KUNIT_EXPECT_EQ(test, cfg.offset_count, 1);
+	KUNIT_EXPECT_EQ(test, cfg.offsets[0], 0);
+
+	// Test 2: arg1
+	memset(&cfg, 0, sizeof(cfg));
+	ret = kwatch_deref_parse(&cfg, "arg1");
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, cfg.base, KWATCH_BASE_ARG1);
+	KUNIT_EXPECT_EQ(test, cfg.offset_count, 1);
+	KUNIT_EXPECT_EQ(test, cfg.offsets[0], 0);
+
+	// Test 3: arg6+8
+	memset(&cfg, 0, sizeof(cfg));
+	ret = kwatch_deref_parse(&cfg, "arg6+8");
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, cfg.base, KWATCH_BASE_ARG6);
+	KUNIT_EXPECT_EQ(test, cfg.offset_count, 1);
+	KUNIT_EXPECT_EQ(test, cfg.offsets[0], 8);
+
+	// Test 4: arg2-16
+	memset(&cfg, 0, sizeof(cfg));
+	ret = kwatch_deref_parse(&cfg, "arg2-16");
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, cfg.base, KWATCH_BASE_ARG2);
+	KUNIT_EXPECT_EQ(test, cfg.offset_count, 1);
+	KUNIT_EXPECT_EQ(test, cfg.offsets[0], -16);
+
+	// Test 5: arg3->8
+	memset(&cfg, 0, sizeof(cfg));
+	ret = kwatch_deref_parse(&cfg, "arg3->8");
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, cfg.base, KWATCH_BASE_ARG3);
+	KUNIT_EXPECT_EQ(test, cfg.offset_count, 2);
+	KUNIT_EXPECT_EQ(test, cfg.offsets[0], 0);
+	KUNIT_EXPECT_EQ(test, cfg.offsets[1], 8);
+
+	// Test 6: arg4+8->16
+	memset(&cfg, 0, sizeof(cfg));
+	ret = kwatch_deref_parse(&cfg, "arg4+8->16");
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, cfg.base, KWATCH_BASE_ARG4);
+	KUNIT_EXPECT_EQ(test, cfg.offset_count, 2);
+	KUNIT_EXPECT_EQ(test, cfg.offsets[0], 8);
+	KUNIT_EXPECT_EQ(test, cfg.offsets[1], 16);
+
+	// Test 7: arg5-8->-16
+	memset(&cfg, 0, sizeof(cfg));
+	ret = kwatch_deref_parse(&cfg, "arg5-8->-16");
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, cfg.base, KWATCH_BASE_ARG5);
+	KUNIT_EXPECT_EQ(test, cfg.offset_count, 2);
+	KUNIT_EXPECT_EQ(test, cfg.offsets[0], -8);
+	KUNIT_EXPECT_EQ(test, cfg.offsets[1], -16);
+
+	// Test 8: stack->0->8
+	memset(&cfg, 0, sizeof(cfg));
+	ret = kwatch_deref_parse(&cfg, "stack->0->8");
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, cfg.base, KWATCH_BASE_STACK);
+	KUNIT_EXPECT_EQ(test, cfg.offset_count, 3);
+	KUNIT_EXPECT_EQ(test, cfg.offsets[0], 0);
+	KUNIT_EXPECT_EQ(test, cfg.offsets[1], 0);
+	KUNIT_EXPECT_EQ(test, cfg.offsets[2], 8);
+
+	// Test 9: arg1->+8
+	memset(&cfg, 0, sizeof(cfg));
+	ret = kwatch_deref_parse(&cfg, "arg1->+8");
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, cfg.base, KWATCH_BASE_ARG1);
+	KUNIT_EXPECT_EQ(test, cfg.offset_count, 2);
+	KUNIT_EXPECT_EQ(test, cfg.offsets[0], 0);
+	KUNIT_EXPECT_EQ(test, cfg.offsets[1], 8);
+
+	// Test 9.1: arg1-> (implicit 0 should fail)
+	memset(&cfg, 0, sizeof(cfg));
+	ret = kwatch_deref_parse(&cfg, "arg1->");
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+
+	// Test 9.2: stack->->8 (implicit 0 should fail)
+	memset(&cfg, 0, sizeof(cfg));
+	ret = kwatch_deref_parse(&cfg, "stack->->8");
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+
+	// Test 10: Invalid base
+	memset(&cfg, 0, sizeof(cfg));
+	ret = kwatch_deref_parse(&cfg, "invalid_base");
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+
+	// Test 11: Invalid offset
+	memset(&cfg, 0, sizeof(cfg));
+	ret = kwatch_deref_parse(&cfg, "arg1+abc");
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+
+	// Test 12: Invalid arg
+	memset(&cfg, 0, sizeof(cfg));
+	ret = kwatch_deref_parse(&cfg, "arg7");
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+
+	// Test 13: Absolute address
+	memset(&cfg, 0, sizeof(cfg));
+	ret = kwatch_deref_parse(&cfg, "0xffffffff81000000+8");
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, cfg.base, KWATCH_BASE_ABS_ADDR);
+	KUNIT_EXPECT_EQ(test, cfg.sym_addr, 0xffffffff81000000UL);
+	KUNIT_EXPECT_EQ(test, cfg.offset_count, 1);
+	KUNIT_EXPECT_EQ(test, cfg.offsets[0], 8);
+}
+
+static struct kunit_case kwatch_deref_test_cases[] = {
+	KUNIT_CASE(kwatch_test_parse_deref_chain),
+	{}
+};
+
+static struct kunit_suite kwatch_deref_test_suite = {
+	.name = "kwatch_deref",
+	.test_cases = kwatch_deref_test_cases,
+};
+
+kunit_test_suite(kwatch_deref_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for the KWatch watch expression parser");
+MODULE_LICENSE("GPL");
-- 
2.53.0


