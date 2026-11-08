Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C19F6606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 14:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AyEeCcez
Received: by kanga.kvack.org (Postfix)
	id B7DA56B05B0; Sun,  8 Nov 2026 09:26:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17206B05B1; Sun,  8 Nov 2026 09:26:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A06D46B05B2; Sun,  8 Nov 2026 09:26:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7301B6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:26:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C5A7180418
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:26:47 +0000 (UTC)
X-FDA: 85412178054.03.006DA95
Received: from mail-dy2-f4.google.com (mail-dy2-f4.google.com [74.125.229.4])
	by imf05.hostedemail.com (Postfix) with ESMTP id E819E10000C
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:26:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AyEeCcez;
	spf=pass (imf05.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.4 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794148006;
	b=Z9ysACAYvNHtH+2y54iMkd4mqHoIphw5cwdTv5hZt5PjInjrz3Vf7NLlXHyNndYhAYOk5W
	P0fN4HNHZfjxNbkNVuVGZaMmRHAmJI0oxRywIJBddGFSP2SjIxKm77VLUYq3xBuWUnVY2t
	kd2iG1Pc/UDoDAsA4M5uL7CPtv8wwE4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AyEeCcez;
	spf=pass (imf05.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.4 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794148006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=anI1ChYfeZjCgF1xgVXnWSsm/4XxjRJS3uHT+I8cNNc=;
	b=gPfP2kd7bth6+oKWuKnZbLThv9J7IjVdmynQHO1Juk13xsL1pCsXwEUj8g2tJwR6KWA20J
	dWdLc2d+GPXQRHhOUVLnQtHo468WamfMcjo2thENR39DdGwMKaujnWneprDSY9/u52R3RZ
	dFxb9cbPBihbyKVlL/au6INVCHQWBWY=
Received: by mail-dy2-f4.google.com with SMTP id 5a478bee46e88-370231dbf90so103111eec.0
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 06:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794148004; x=1794752804; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=anI1ChYfeZjCgF1xgVXnWSsm/4XxjRJS3uHT+I8cNNc=;
        b=AyEeCcezei3+/oOrehCKLKA4K9QiHUY9lm/+k6YZUWOSkxTBedZn247Hc5RJDL85FX
         wF/PQkALzIbFD+F9UWZmJzTCodvoKfxlwoqasmfg9zFPZEGsU+Ichpb3Pa8rYzskI1yu
         H3RaAqsWKxQ5F7+lzvHSPR0haOBZRzYOlKCFe5K9UaExG3Uw42YtNjkwEqjmupmmwc56
         CekvY99Ips8eV/25M5ung06wz/t+rN2oRbdvuYFOj8anfxoL1BHgDQ22QFDlIAMl+2z7
         KvoIoeEtjnCj1Z544k9rxWDa2qX/im4AUmtIqjg+PAMeYcAb57k+eOaW2Izkfyiy24tN
         dd/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794148004; x=1794752804;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=anI1ChYfeZjCgF1xgVXnWSsm/4XxjRJS3uHT+I8cNNc=;
        b=Q3ezSofRsS5/+VnryjTfQK+pEj/e5PttFyNqNq30UF9KdQSQpA/IU9QkEOsmwDtybm
         ttEt3o4fBe9aBfOt8CEmceiW0LJ5xYOzMktqiwG1UlPpgG5ySgauA8fzKVudzVouzzrh
         BDgHIrJfT8XNS1g27AM4fsa5YWIkTuJXScZEN7L/YHSMIY0RVLFXd4ANZJ4jKgGntDIK
         +X9pUjZcnu5nDeFJSdVw/sueLv7JobX7YzeKYddIYaNwGF8Q8+IXtAVo2tmX+DuTnA9D
         Cgt+djQUad2pPceiFDYGWg34dUp8sPVyPxNATwqcI2Loxp1UCYh+rjgJJnVybZVvKxzL
         ehRQ==
X-Forwarded-Encrypted: i=1; AL+hErGSTpV26+UlTcRNocEi0B/e0s9ADaGiytYhTUfbapKm7LUhd3BiSimIr6jYogrNy1bfwSwvVffJSw==@kvack.org
X-Gm-Message-State: APuU4Z/QJ20EnvD/QD/txrB55Rq1F3pj47z3HPmFehNjySbF7jxB+OrT
	XIHSruAgOifKCP/WP8nVXxXBe4IbkPJP70NOjnGMDPwZPb4sSmiK6l1C
X-Gm-Gg: AYBFou2DQ1lq+reshu6yCtKQdg28JPrXHq6IargDGwANQ/8sKBDWr7e3KO1a24p4Jpx
	AFmJFyOpVu1JLG4dGJvNVNmrCQZCh2Mwj2Y5e4WDjmie+16A6u0mW0It5r6fZubdvTFTbSOGEDr
	qBIts34Jy/GLr7LoHjGD1PBiH7u2e5YTbd2AqB2neerZfkpIixIWh0LXIa34gbLPEIexcALzz2E
	3eCZgcE3BEfSSXtY+luLlzOv9RBInQy6Og9Nbaolm1rY1l0eMQXtg1lW3BMDho1i9EHZdg548Sz
	dQbKDwQQdBd0vFRoMVi1qIpBkPfH5ry294gfgrXJ3OcnZZNE7yJMiaSR+lSFBL0diocCiLPdXCf
	WzijPPKsSVvpWViTCiRKgilVk3oBuGXlc4nXVfAnnax5XiymKIayoxZ9IBBp35569/uZCBZZDYM
	u+XL5mp4Jykx1IYBXIeK+WO8HATwHWucAsQxfTOahGl1cUcVl30sz8XKKxbyffL1ySnwicjrVG0
	mSqdngl6yoXfjbvSo0snmbBlHOy+Rw0WDwx9UVbdUKE8M5Jnk3rLd+krEuKPpN2Rc8eCcJusciy
	8HIA31+x7WE4dUG9BqF6FAEzXUbsk2+avkuoEUW2ItAoWURp4Klx6vIcI425KO+wt/r7eP9uBpr
	yjQykBq2BjSOn/0xs5A2QKs1yMFwB5pn+PCWw6MSrlvj8pbY=
X-Received: by 2002:a05:701b:424b:20b0:1b2:32e1:3bb4 with SMTP id a92af1059eb24-1b39fed71a0mr2656735c88.18.1794148004300;
        Sun, 08 Nov 2026 06:26:44 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3771e5728sm5601098c88.16.2026.11.08.06.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 06:26:43 -0800 (PST)
From: Aveline Noir <jm5905938@gmail.com>
Date: Mon, 09 Nov 2026 01:23:46 +1100
Subject: [PATCH] mm/damon/paddr: add KUnit tests for addr_unit conversion
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-test-damon-paddr-addr-unit-kunit-v1-1-bd10bb87be98@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/zWN2wrCMBBEf6Xss4tN8P4rxYdctjZKtiVJVSj9d
 9MEXwbOMJxZIFJwFOHWLBDo7aIbOYPYNWAGxQ9CZzODbOVJiPaKiWJCq/zIOClrA5aY2SV8ldS
 yP5MUx4OlC2TNFKh333LR3SvHWT/JpM27LbSKhDooNsNWVW2V/W/33iPTB9b1B4FX6YSyAAAA
X-Change-ID: 20261109-test-damon-paddr-addr-unit-kunit-b2f7e2154de8
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, damon@lists.linux.dev, linux-mm@kvack.org
X-Mailer: b4 0.16.0
X-Stat-Signature: qdjfmhap5z9qzfwm4ggrffypyezbrn71
X-Rspamd-Queue-Id: E819E10000C
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794148005-225003
X-HE-Meta: U2FsdGVkX1/vv8Mrvjd2VIUFUPspw4SRxrJEemIEYAwtFuIkzBZh38XF2xVU2O8j2o9R4swIDRwglA3JIGLZHWOsFneSW+g7KU5/MD7W6EEy5FXLIONx4Ldo3Ag8Z7xx6cCL29pY/gKUd0RXJ6jD9TT5NTyb3x8TqEtXUkWr8u9sJl5vfkOcajWo8fFeWfoMnNYpBb5eXFsG2LGkrjSrkcG9ywurdUGrxYq140sI1UzYh14y6lCnqafqf+fxxE6HnQrsb3IRwZHK9RX1Escamc+6yky2OUWu+FXxA2ZVLL0niJVcq/bxEeZPMnhsm3EJ5wCOhDzviPFWzgDBd0Ty6jpt68xK0O3TIVsasNVKetdU0qiQYM/2iZUyOYwy8NEEUcJh7tiXdse47eaclOp6i2Zzj3CRrHpiAJ/eu+3zXXaqhf56Xpd2AMgZTNySndWd6ya5l3YqcjlYeaGOgKYviYLFBic/HTYZlk2naQdu3P+07NKHSDgq5CGyzvpdO31yMecnl5YVe20/qvw662/Gf6B6fXfaXk/qSTqruKkrCSsZzLqOEinS6XHTjkdAEzLWC0FdEaVbX7MlPp/o5/y0Vo9YRAlXnOuSYJrVvYAKVufKyvyExi8c7zestKTVv9YiWLMhLn1529MxPkU8V2mzd/j2Ie/awaQQUg13ZCZtQXZbAo5FuFo+LpWxVOd06xtrDQWvfvHxLQivNfNSAsN0ryT0LsBt1fNEAkQN+Nc1cYT2zo+ocz5YxGNvh3wQipNCoTvSqbtB8dxqY053s6PVKxS6O5Ufe0O1+yY/AMyAemcdAwTNtBInZU15biLOxY0ASEost2tZZ0Y7UNRZ6Y2EQEA/gdopGO/aSl6J+Yk1pqAJgYvBrVCuSV8y1RvUNUw/GzzM1VO/b+eaKtSkiEz/P24FF6cfYw250pfCwcjHRcCHplGtMO28AALB4y6qfL+nTdM3ObESzzBeWc2Lalb
 6nyp3ixl
 XOgBmVNlG7EoGPPgOMCaTGVL1/Z+aLpCnfdzVw7+dyAVo3zkD+iPtePrspT0GOCJp68biU00bRRj5FhYyZ0x9tZjAPmTvTBwf1ZrLNHCrL+9ctjNn61dLwEPjSggsLwRUJ/w0CVbmZPkmR4xOVDq28aiZESIin07u5FnrdvVGGuzY+9oNqhUmx052F+gDDu34RoCNbeFvskTWzDlcwfqo69cga2STFG2VKmh6oo5IAviz+QM1WfESHKZI9OlujySP5R1LWAz+zqRJUWRBTIilq/hPHpk7ex4Qfc4ntCTbu67WMpRauLyrdRlGw7bnAvNrle61w/iuGTzbmXpfYWQw4rO/IOs5TzuRaHAhCv9G8X8B0mOTDEGIIJWGI+kbPrHz7rdKv5de16KunnmjqInRMefctOlus3AasLujl783eO7oeHqf3dDc2MoBUTIj7wQV1Bu+nayCVjGiIfXIBePid4OOyrm/gw/JukG4KWqBWlvxk/1CsdotIJNQevjFzDrgCtKx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_pa_phys_addr() and damon_pa_core_addr() convert between DAMON core
addresses and physical addresses using addr_unit.  addr_unit lets 32-bit
kernels with a 64-bit phys_addr_t monitor physical memory above 4 GiB,
but no test covers the conversions.

Add a KUnit suite for both helpers, including a case for addresses above
4 GiB that is skipped when phys_addr_t is 32-bit.

Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
KUnit passes on x86_64 and i386.  Selftests pass on x86_64, except for
damos_quota.py, which is flaky even without this patch.
---
 mm/damon/Kconfig             | 12 ++++++++++
 mm/damon/paddr.c             |  2 ++
 mm/damon/tests/.kunitconfig  |  4 ++++
 mm/damon/tests/paddr-kunit.h | 55 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 73 insertions(+)

diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index 34631a44cdec..6f8722fcf464 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -65,6 +65,18 @@ config DAMON_VADDR_KUNIT_TEST
 
 	  If unsure, say N.
 
+config DAMON_PADDR_KUNIT_TEST
+	bool "Test for DAMON physical address space operations" if !KUNIT_ALL_TESTS
+	depends on DAMON_PADDR && KUNIT=y
+	default KUNIT_ALL_TESTS
+	help
+	  This builds the DAMON physical address operations Kunit test suite.
+
+	  For more information on KUnit and unit tests in general, please refer
+	  to the KUnit documentation.
+
+	  If unsure, say N.
+
 config DAMON_SYSFS
 	bool "DAMON sysfs interface"
 	depends on DAMON && SYSFS
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5b773012a876..e89cb14ee17b 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -479,3 +479,5 @@ static int __init damon_pa_initcall(void)
 }
 
 subsys_initcall(damon_pa_initcall);
+
+#include "tests/paddr-kunit.h"
diff --git a/mm/damon/tests/.kunitconfig b/mm/damon/tests/.kunitconfig
index 144d27e6ecc5..9279f0c82be7 100644
--- a/mm/damon/tests/.kunitconfig
+++ b/mm/damon/tests/.kunitconfig
@@ -9,6 +9,10 @@ CONFIG_PAGE_IDLE_FLAG=y
 CONFIG_DAMON_VADDR=y
 CONFIG_DAMON_VADDR_KUNIT_TEST=y
 
+# for DAMON paddr ops
+CONFIG_DAMON_PADDR=y
+CONFIG_DAMON_PADDR_KUNIT_TEST=y
+
 # for DAMON sysfs interface
 CONFIG_SYSFS=y
 CONFIG_DAMON_SYSFS=y
diff --git a/mm/damon/tests/paddr-kunit.h b/mm/damon/tests/paddr-kunit.h
new file mode 100644
index 000000000000..9839cc233071
--- /dev/null
+++ b/mm/damon/tests/paddr-kunit.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Data Access Monitor Unit Tests
+ */
+
+#ifdef CONFIG_DAMON_PADDR_KUNIT_TEST
+
+#ifndef _DAMON_PADDR_TEST_H
+#define _DAMON_PADDR_TEST_H
+
+#include <kunit/test.h>
+
+static void damon_test_pa_phys_addr(struct kunit *test)
+{
+	KUNIT_EXPECT_EQ(test, damon_pa_phys_addr(0x1000, 1), 0x1000);
+	KUNIT_EXPECT_EQ(test, damon_pa_phys_addr(0x40000, 0x1000), 0x40000000);
+}
+
+static void damon_test_pa_core_addr(struct kunit *test)
+{
+	KUNIT_EXPECT_EQ(test, damon_pa_core_addr(0x1000000, 0x1000), 0x1000);
+	/* The conversion rounds down. */
+	KUNIT_EXPECT_EQ(test, damon_pa_core_addr(0x1fff, 0x1000), 1);
+	KUNIT_EXPECT_EQ(test, damon_pa_core_addr(0xfff, 0x1000), 0);
+}
+
+static void damon_test_pa_addr_over_4g(struct kunit *test)
+{
+	unsigned long addr = 0xffffffffUL;
+	unsigned long addr_unit = 0x1000;
+	u64 pa = 0xffffffff000ULL;
+
+	if (!IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
+		kunit_skip(test, "phys_addr_t is 32-bit");
+
+	KUNIT_EXPECT_EQ(test, damon_pa_phys_addr(addr, addr_unit), pa);
+	KUNIT_EXPECT_EQ(test, damon_pa_core_addr(pa, addr_unit), addr);
+}
+
+static struct kunit_case damon_paddr_test_cases[] = {
+	KUNIT_CASE(damon_test_pa_phys_addr),
+	KUNIT_CASE(damon_test_pa_core_addr),
+	KUNIT_CASE(damon_test_pa_addr_over_4g),
+	{},
+};
+
+static struct kunit_suite damon_paddr_test_suite = {
+	.name = "damon-paddr",
+	.test_cases = damon_paddr_test_cases,
+};
+kunit_test_suite(damon_paddr_test_suite);
+
+#endif /* _DAMON_PADDR_TEST_H */
+
+#endif	/* CONFIG_DAMON_PADDR_KUNIT_TEST */

---
base-commit: 2c5dafa7f289d760f4492260b0988029aab478b0
change-id: 20261109-test-damon-paddr-addr-unit-kunit-b2f7e2154de8

Best regards,
--  
Aveline Noir <jm5905938@gmail.com>


