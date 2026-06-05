Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B70FCD6E75
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 03:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E51F6B009E; Thu,  4 Jun 2026 23:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BD356B00A5; Thu,  4 Jun 2026 23:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2906B00A7; Thu,  4 Jun 2026 23:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BAFE6B009E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:34:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 229BA1A055B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:34:26 +0000 (UTC)
X-FDA: 84844441332.12.088376D
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 512251C000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:34:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NaMPgv3S;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780630464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rfxlNkzCx8TA3SebJdSu06wI/is0K0+hQNvlMemiJzs=;
	b=SoxRuTZgdlw2boA4MRQ1zSVVQ98GRK/qnS87NdvglcolJoGymrj3bA/ei5xb69e/HzDJNc
	QyC7Gm4XtIROL9RRLlTAN3B2d5bar/x2CTGpP5qKEG2A+hGNP7LiA7293qcC0s7fy/eJzk
	SOdX21KEH4SCQ4/vXc/U1FiCmdTjEpw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NaMPgv3S;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780630464;
	b=gGtmuhN6ZEbcKajfapC9cp9lgubfhUVlzT6wwPJHE5NRBUAGuMYV4aALVKE/zMX1ifqZTL
	jGpgVh/OF6btCPsEVNxtVF0aJZejJPNsKUtNyoBObD9WzyneIAf5FRMELQgdTuaAHjpGJC
	h6bHEbFRhgMBfvo5F+yuEuxXtlqFcIQ=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-516e1525aa3so17514031cf.3
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 20:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780630463; x=1781235263; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rfxlNkzCx8TA3SebJdSu06wI/is0K0+hQNvlMemiJzs=;
        b=NaMPgv3Scr0Cu3SlrrfZiLkJ/rcO75EphkV0OgRKMztGIdKNroiYtt+EbxQxQ11rVT
         UyIwmP/7/lp7+KQSsGWjCFRVmerWDeLcPjZ2cUyzCP//ETyIzRdyypIpts7a1HYxAJeb
         d3k9hlLZZiEPuc/tLL4IYVaRg5u/CKdYKuhXJlMy8HHmIeJdF1LlQrAeGdzBVixvGyr1
         SWH3jQrJJYEX9Ul0R9c97Ftp+Sfcrv1TWM1sUdQc9GCxZr3zF/MCAmdH/Z3yuyxoWQqm
         wmtXLqXiK2YN+ap6wUiZu+PAjhJIkihoCOC6CN5YmOswsZ5ORyFMQt+7s8DaMNt0BXP+
         80Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780630463; x=1781235263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rfxlNkzCx8TA3SebJdSu06wI/is0K0+hQNvlMemiJzs=;
        b=S2knDvYxvFYR7shmKsBKgf9J56S/yQl7ERG2f0jMAE3Jnv+3xyLPrW+9miB9ljM7qw
         tfsJIa/1/NMatdRsKj9bWhzXy0Xj903qs31plX8d0QyYX4vt/HUN+pseFcslgAlx57VC
         toqwLpVcDj9ic1LvXoK/073WqZMZ/F2xaysV9d9xoNi9Q9PhgPATx1yiihaIFviF1Agy
         1FvwXb/v2379wZ0ffxJTeBWUbmNmGVkne2i+JAMKRxgMbZH8tzHBvJcvCc3gHY6gtLHV
         5hTf1fCS5rhNR4mZmyyM3HeOw+bKDtrmLfyI2lwzNrMZSU+6yEMaaQ9c/d/ZuktZK/Wf
         A0Fw==
X-Forwarded-Encrypted: i=1; AFNElJ8pqczx+9t1hf8jUWTUI0RVXg7Ssg4JuZLu8my/K4fjFkVwc3Gf9dRSyrq8iPz339NBXINybTML7w==@kvack.org
X-Gm-Message-State: AOJu0YyL7XKRl0FhbGWrRfnMQGjTi5Crl8DSC5Pl60gRL7kLZ/tJklRK
	MSupwrLSzx07JOo0NzFWNUgwsjB54a+Ll4eX5mgEsh9zCmWx1pnDukL5cl8lqs8QMqc=
X-Gm-Gg: Acq92OEITqSO50sS72tNZ8oNc4yQVBSNKlp+nSZYmjdE11oWJt+u9ggPeIckr0Yz7xw
	1Mu5PrczrgPrk3SJFhGkvpHNWKk/Rh/WAOJ0MpUe1dg359Ekhf0wUvSjNU0pFuTpWZFwcjPS8/h
	MjeoyzkLoEaaRAine9qnBii2vEBPRA9mICnpIoRFudHuERHNV5/I/yndPGtoZ4A+ohwyzohVyg3
	O7msggsO6+0zPWaQs2vh58M4MLJOLUUCal5P9WtO23eRKmuvxNVSd6i4F/xZb001hHXzFbjTICR
	pEs4MCYI8yqV9SBtLivxxgDIBmKc7Z2HKGAHhwkcTAIi/2QvibIgfmKQyRXwY7+BrFsRpb5On1O
	Jrh3QPIhKrgvqz49Frh4vzl1HhoXnGyt+j0t0fU074J6bnYNIY9CpDLGIvpEbgQmJGQrBZcbAuU
	GMGB2T/5lIknD0daneJiV2NgT+ymBqzQnU53E3+6E7J6Tffbflt8hJjF+GNGXwzA==
X-Received: by 2002:a05:622a:4106:b0:517:6665:2a9a with SMTP id d75a77b69052e-51795c920f2mr28080531cf.50.1780630463488;
        Thu, 04 Jun 2026 20:34:23 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51775df4dd6sm67871381cf.27.2026.06.04.20.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 20:34:23 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	jasonmiu@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	ran.xiaokai@zte.com.cn,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [RFC v1 9/9] liveupdate: add KUnit test to verify alphabetical order of compatibility strings
Date: Fri,  5 Jun 2026 03:32:35 +0000
Message-ID: <20260605033235.717351-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260605033235.717351-1-pasha.tatashin@soleen.com>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9oi9ebo81zkausngbatkosc6g7bmn58p
X-Rspamd-Queue-Id: 512251C000D
X-HE-Tag: 1780630464-81475
X-HE-Meta: U2FsdGVkX1+lI/dMmsRgE0o3JB8RkXCLuPj7z2uR6nqbN5aGar6QcFs9LDADNaC8KELXKX3kwiLaYkZGayiDYRqYNgvGT/lOA5mprCnxWN474p8It6FZUuBxBzmi55D9f+dZPSj/GVNd1dkUXlZC18Dnhw9zvkJ5TH8fwAj/oYPS0Yy0ZKiv1/Cu/jXS3l/tGpebTH4B0pSvAW+4isSd0uhzlkOYCHaadM9xtonZ2R6j9N55vg4hpx0nwqPTRpJdWnjYrLYc6/9GT0WLG2ejpLD+v7tGUpXlu251UqBl0JrIq8qEwz8f1ttG3y9kE/bTfhF1ulgFR6szPf0NaJRBrHbbfIMznEACXf51PtUOmGnPc18OTyve59JyE8UoO9kXxHgk3Kwc2yv2SeAwYZ5IaQBQS2pBMdZ1hPOqewOMFJm+LxgQRWTFvOV47KufhjrQV42ePoed+hBQ+MGAUN1HAEjpgklnWlHHCL1DiBT52ma5vWUVbxs5VGSzSkCH2j/pNA2S/qi2tm+GjU0dqKu0SCLRmt4/fod4VPWpMdeL5E5MVxLWC/D9Cpzgnqyo265v0n3ku3Tni/689MMvzIlG0zMhVAbeep1F3kgWBMg7/kK2n7AFjQHfSsDT0h4aC+ahDgbUjrOie3w2WqDAbRO+WQyq/VwIe39pb7TZvNFfa4vSR6BQD/mYp0coz4nqPyJOun8LwY8kGWGuwWANiNv0WQ9L1Cj9HvB+of9/Xo0ndiqaqqHeJhsjPISU7mGAc+NceKnZSuH+9RtV0zM3PvZ0KVZufJuU1LSOaPGu7dDF+UCUjVvEokyWwF6q3HjvaMNZWifNCqMQjljqZqidNw6bYW6SXyniWkAx7gWfZm9QkZM/xzWQ8OmStZSLgBK4rTykw5Hd5BRLatwKGtmRfafFwbxUzdO2baThXtpFb62tCdBZmz+wg2AJ8iwjI3IiYTS/3um+EIJH+SdkhQXUr12
 lnLk43XT
 gEJjlro2Ne2i7gV4dbP/raIutOEdKv1u++H7Y+0KAe2RpE7JEfUioVtdXTQXoOLTw0tT5OlbIpdLzNYzMtHYeDCdmaxr+NRyAysHjYO2Fai9FtjyVzot9C1kC8cTd7yQZaV6Ktm+9TPrFXm7+fAi71QYc2ilr5W6Vo/sfq/INaSchOm0YlDDDsNkqhZN7myoHcFuAa9vk5bnDBHP9+k7pmrKS1ySAdrhE49uQbPRHx8C7eKW/oFR8mcOFfrOqmjDa+w0FWaj8t4SrXcpSI3utN+EsaO06tplvq6qFRgeucR/Qd+YHWAYMWjk4uLUxHiZR6X3eMy70lI64EkWP4wGYs6gYF5QAIzyCjPaTZ1gEYgRSQHip6U+fJ35mFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a KUnit test suite to verify that composite compatibility
strings are formatted correctly, specifically ensuring that all KHO
sub-component compatibility strings are unique and strictly sorted
in alphabetical order.

Maintaining alphabetical order in composite compatibility strings
is required to guarantee consistent, predictable, and reproducible
compatibility string representation across different system configurations.

The test suite validates:
- KHO_FDT_COMPATIBLE (the root composite compatibility string)
- LUO_ABI_COMPATIBLE (the LUO composite compatibility string)
- MEMFD_LUO_FH_COMPATIBLE (the memfd file handler composite compatibility string)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/Kconfig                 | 15 ++++++
 kernel/liveupdate/Makefile                |  2 +
 kernel/liveupdate/liveupdate_test.c       | 56 +++++++++++++++++++++++
 tools/testing/selftests/liveupdate/config |  1 +
 4 files changed, 74 insertions(+)
 create mode 100644 kernel/liveupdate/liveupdate_test.c

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index c13af38ba23a..617a31dcee73 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -86,4 +86,19 @@ config LIVEUPDATE_MEMFD
 
 	  If unsure, say N.
 
+config LIVEUPDATE_KUNIT_TEST
+	tristate "KUnit tests for LUO and KHO" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	depends on LIVEUPDATE
+	default KUNIT_ALL_TESTS
+	help
+	  Enable KUnit tests for LUO and KHO. These tests verify that the
+	  composite KHO, LUO, and memfd compatibility strings remain unique
+	  and sorted alphabetically.
+
+	  For more information on KUnit and unit tests in general, please refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index b481e21a311a..5e0deb85e1b1 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -17,3 +17,5 @@ obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
 
 obj-$(CONFIG_LIVEUPDATE)		+= luo.o
+obj-$(CONFIG_LIVEUPDATE_KUNIT_TEST)		+= liveupdate_test.o
+
diff --git a/kernel/liveupdate/liveupdate_test.c b/kernel/liveupdate/liveupdate_test.c
new file mode 100644
index 000000000000..15688d69735e
--- /dev/null
+++ b/kernel/liveupdate/liveupdate_test.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KUnit test for Live Update compatibility strings.
+ */
+#include <kunit/test.h>
+#include <linux/string.h>
+#include <linux/kho/abi/kexec_handover.h>
+#include <linux/kho/abi/luo.h>
+#include <linux/kho/abi/memfd.h>
+
+/* Verify that compatibility sub-components are unique and sorted alphabetically */
+static bool is_alphabetical_unique(const char *compat)
+{
+	char buf[1024];
+	char *string = buf;
+	char *token;
+	char *prev = NULL;
+	char *sub;
+
+	strscpy(buf, compat, sizeof(buf));
+
+	sub = strchr(string, ';');
+	if (!sub)
+		return true;
+
+	sub++;
+
+	while ((token = strsep(&sub, ";")) != NULL) {
+		if (prev && strcmp(prev, token) >= 0)
+			return false;
+		prev = token;
+	}
+
+	return true;
+}
+
+static void test_compatibility_alphabetical(struct kunit *test)
+{
+	KUNIT_EXPECT_TRUE(test, is_alphabetical_unique(KHO_FDT_COMPATIBLE));
+	KUNIT_EXPECT_TRUE(test, is_alphabetical_unique(LUO_ABI_COMPATIBLE));
+	KUNIT_EXPECT_TRUE(test, is_alphabetical_unique(MEMFD_LUO_FH_COMPATIBLE));
+}
+
+static struct kunit_case liveupdate_test_cases[] = {
+	KUNIT_CASE(test_compatibility_alphabetical),
+	{}
+};
+
+static struct kunit_suite liveupdate_test_suite = {
+	.name = "liveupdate-compatibility",
+	.test_cases = liveupdate_test_cases,
+};
+
+kunit_test_suite(liveupdate_test_suite);
+
+MODULE_LICENSE("GPL");
diff --git a/tools/testing/selftests/liveupdate/config b/tools/testing/selftests/liveupdate/config
index 91d03f9a6a39..28c54bb473b8 100644
--- a/tools/testing/selftests/liveupdate/config
+++ b/tools/testing/selftests/liveupdate/config
@@ -6,6 +6,7 @@ CONFIG_KEXEC_HANDOVER_DEBUGFS=y
 CONFIG_KEXEC_HANDOVER_DEBUG=y
 CONFIG_LIVEUPDATE=y
 CONFIG_LIVEUPDATE_TEST=y
+CONFIG_LIVEUPDATE_KUNIT_TEST=y
 CONFIG_MEMFD_CREATE=y
 CONFIG_TMPFS=y
 CONFIG_SHMEM=y
-- 
2.53.0


