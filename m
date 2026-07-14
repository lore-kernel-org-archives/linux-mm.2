Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DE4EC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8066B00FD; Tue, 14 Jul 2026 11:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A84A6B00FF; Tue, 14 Jul 2026 11:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06FF86B0100; Tue, 14 Jul 2026 11:15:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5F836B00FD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 35702803BA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:30 +0000 (UTC)
X-FDA: 84987731220.21.54CDBAA
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf18.hostedemail.com (Postfix) with ESMTP id A88191C0017
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nVv+Aae9;
	spf=pass (imf18.hostedemail.com: domain of 3jlJWagcKCOUcPWPUZONVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--vipinsh.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3jlJWagcKCOUcPWPUZONVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4NITAiOyX61WSGfTGRgV5OG/+gstw4nR1bSZsXufP8=;
	b=d+n+pwTtBBw23QSsVo6podaR6zx+PETso+HECGSraXY4H0dQc+pwM79FEUCGM8j8dWK+GO
	MKTRSceBpnITp2Q4MwuoPva4y/BAkoBLvNSfbS57MHXj7Zdq2baQDp+HkIXgLqyURzMiXA
	UeYsbEDgbnxw80WwSg66sguWE3il8MI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nVv+Aae9;
	spf=pass (imf18.hostedemail.com: domain of 3jlJWagcKCOUcPWPUZONVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--vipinsh.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3jlJWagcKCOUcPWPUZONVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042127;
	b=NH145iMkROVc2JhnFuPHYtRIQdFCQGLNIGyWe9uK+Lffu+maCdPYf+G7kCapR4T4lVT4ll
	JRxrf1RmoCqAugQGH9BaTtOo3d4LXR8ojZRizSE3DT3tfuJWJBNNsVVoHcTQIFBTxh06GZ
	FsrrXsC7gJiRKpU3dnXy4ROueGEL6VY=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c88aab7c1d4so6898327a12.3
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042126; x=1784646926; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w4NITAiOyX61WSGfTGRgV5OG/+gstw4nR1bSZsXufP8=;
        b=nVv+Aae92ZDMziM8TGpiecIsFNkWuxKmhUJlmM32bsNqKDYfj/AAelkddFBC7uFQvC
         0X2D6rM4EWBM+LWOdBoXbjkP9rx4DLexuwRk6gaWEUb8zLqs6Atp3Zqv3xyPxTSYGmQd
         lDAIQNmHuqEO/87pJRAkv8poimt8JLcri2+FPLdKU3LM+b0WTT1gA1+Fav++nv1Mc0SP
         tnNBmR3eDISgwWRwE35Fc9HHBC5GhOX28EQf5Y7eboFHh36qi622xp+iD0Brj/trCjJb
         X7LDB3vu/t86ESnRsgzGb9eO4OzThHiLygBVPWKS1I2J12yERP6HVa36YpBU4qqFDH3X
         N5gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042126; x=1784646926;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w4NITAiOyX61WSGfTGRgV5OG/+gstw4nR1bSZsXufP8=;
        b=NxYPMxFlYmaWmvBWsqFaZEN0roBoVkhcNJaW3FkD0BSCILDhuu8+Qx1m+tg6TMtDGc
         ZqY+i8OstQ98lsQtJ1o1sSeUlXiFDGJ4c+CHRYkuYEsUA3TXwhYwn8Bcmb0wN/BdkAxJ
         vc03iJMSgOUZ2/mq3RyllEs0jN9NqC5gKJuYhOJGXeGw9LcFaZM3CRdt0iFXdJALQqV/
         GCd2zp1y3gSVGBka2bLQfZvyYjCEq8yKrn8Xj4Q2sC63rhpAZYLYRXxe3HHB1y9PY0p1
         VXbLdWbaPfdGpsbaq2xlBAoKEkBWgx+F3pCw7bDD6e86yAGzWEO6K5EEz6qL+5zEdEuT
         F7XQ==
X-Forwarded-Encrypted: i=1; AHgh+RqY/7yp8xf+5vN4Xk7NVfBUo/Tr4TWhPMUbNFOpO3PMZj5YhviI3+1PDENSnXB066i2ELCTHdXjQg==@kvack.org
X-Gm-Message-State: AOJu0YywIyYRHuTp4Cci4Rh3+s1oPolFwn4JFis3QYlyL08BljKPZXqy
	czaN81gI4lRCn/ihm7gNkYJyYVrwvsC3aFadprQoC51sKFa/M18brQjJenYOj/oCCJJplYssLSj
	N+cf9mZahjw==
X-Received: from plbkx14.prod.google.com ([2002:a17:902:f94e:b0:2cc:61be:8bbb])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db11:b0:2c9:d539:61e7
 with SMTP id d9443c01a7336-2ce9ead007bmr140240975ad.19.1784042126213; Tue, 14
 Jul 2026 08:15:26 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:15:01 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-17-vipinsh@google.com>
Subject: [PATCH v5 16/20] vfio: selftests: Add Makefile support for TEST_GEN_PROGS_EXTENDED
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, 
	rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vipinsh@google.com, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, 
	yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9firkz7nq1hpdhn1m6grjd5t3ijjm96t
X-Rspamd-Queue-Id: A88191C0017
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784042127-289714
X-HE-Meta: U2FsdGVkX18b6LN4kaRvo1iKuDDo5d0JLmhfpATFnBxRqAXVlHgAUKoaHUjZoJU8xorTVTlbjEJ7SkHKHCKmRaEtuGgE6PCCZ5xo3H3PATKrRd7LhJLUoE+yJRESPHXUHs94k8bNl/8kFknO+eDNYcYTZdU8H59+ajq20nOqlmCobybIiHoCCTaVgkwsOhe2uU3A3EL+p/4IdAuzfxVQtdUAqTUXINXGI9kAfC/Bm5uwPY7pEEkCmKsc5YumGlpvObXM2j5SlVwlzDhojVW+Q3Hd3FouJKaRbwSrMgBdq+6GzulDxGSyiHC1NULc0dNha8BcMSGip2ZTtGW4etlooDlQ+yCW5/cgDnyTkW6y22tkZESFsOuO00pCuFwIaNCVcXYLM8r1dgaXBlga2Uox2cUADH6k1W6xyNasDqEhFs6BGRXlbbYYitrdBtU+Px7Wlr5pEmHP05zns5N8OTk1SUckg5v9CCtaGWRavy1jjzp3oSg/J30QqtSqyy2l/GDmI6uIScmi/UPLKHpb342/OdMQlFhzTM9wzpq4jGRvbiU7aDqUZe5mwUqCA5/zJ16S3SMSQcD01uoF3sMlQuwF5e6CB1sfgwycMlV3goeCapUyt3iQaPjRsMR05tsAf6uZ1DrpIWN6h03emm+qyOJjUq4oDqX8pLJ5jHFjFlXOfHg/zUDwIygbiZs4Ec2/9r8bNNdvrbSgVGBDh23+YjIqdmlsl1CkdGBUw+aByzZK9gZrPl+z2nMi2JBvA5SaYm2KUdYd51q8gpcSSgE3k5EsBpQcxfcGqNV3/d7CY/jwdzYdqH6iQD3PlI9qVUb7WQGobxYXun2iRpIPSaO8Z5aPm/pQ9oV1CdV2CHpTCDj3uJTucSij7v3hCP8MVodKRhw7WnOvn3BBGLc4HISL7q1dOLlENK0ldMpBMLvjRnifOwCyt4XGavf2TwgAUVbIN4L7zyzMBkgyx8SNrT/RP1f
 gFwzL1TD
 3iObCqOlMgQd1nfJr7arq+Y0Y0YqA7dMPSUqlQ7p2QAHmkXOeamy8yCbb4Cs5xf0cAaGvvjyhzNu0RI3CX5stpm61Ob8rgtrTLH22kbUxkzaP0GlqrRQGJ/W2FGD6vtnXDCoJc/C38L9AglALJE7ibKR2gosbWN9BZJ4RyaUTf4HhTURMG3Se6LE4Kdp6YdnYMKTY+gDVebLtKg/ae5FNpqLcvXIWMsHSiLB8ykuyE63xqGIHPpT3+jE2wlY8MtIiQJxNv/PdCTSysv6lyJxKkZdB9Cvw0NDKVTkCUnaf25doSsHFO1s828aK0JOx5ZIQEpZs9opgg8NvUr9VhNZrfYdPz5SNKto7p51bwx8nKNRZf2wbCKtbiVUAXJrikYNIjQApgxl3R9R+etuCzoqT3PSb05e7i9A4uqTSjhA7VNqq2OZrOnK67rHigQBwnWerIwj2jHOsKoVZ5+AOAPcqyGPwvzmkYKZXpkZPS4chExvikqJ4OrWsPkNOjWsXcZhXdzUOCtdoFthymNoJ4igO2OFiANw+QYCedtEajjP/6eb836YhO6tlcRPoxV7vFX3zwb76mMTXQ2ZeGsSerd3O0DW9GCZQEtY1VrA3MgW9wTAybghczNwH/go1OcY1iqRz/E4qfcqlJNXaHsQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Matlack <dmatlack@google.com>

Add Makefile support for TEST_GEN_PROGS_EXTENDED targets. These tests
are not run by default.

TEST_GEN_PROGS_EXTENDED will be used for Live Update selftests in
subsequent commits. These selftests must be run manually because they
require the user/runner to perform additional actions, such as kexec,
during the test.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/vfio/Makefile | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index dc06fddcf855..591f1a52c310 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -36,16 +36,18 @@ LDLIBS += -luuid
 LIBS_O := $(LIBVFIO_O)
 LIBS_O += $(LIBLIVEUPDATE_O)
 
-$(TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(LIBS_O)
+$(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/%: $(OUTPUT)/%.o $(LIBS_O)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBS_O) $(LDLIBS) -o $@
 
-TEST_GEN_PROGS_O = $(patsubst %, %.o, $(TEST_GEN_PROGS))
-$(TEST_GEN_PROGS_O): $(OUTPUT)/%.o: %.c
+TESTS_O := $(patsubst %, %.o, $(TEST_GEN_PROGS))
+TESTS_O += $(patsubst %, %.o, $(TEST_GEN_PROGS_EXTENDED))
+
+$(TESTS_O): $(OUTPUT)/%.o: %.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O) $(LIBS_O))
+TEST_DEP_FILES = $(patsubst %.o, %.d, $(TESTS_O) $(LIBS_O))
 -include $(TEST_DEP_FILES)
 
-EXTRA_CLEAN += $(TEST_GEN_PROGS_O) $(TEST_DEP_FILES)
+EXTRA_CLEAN += $(TESTS_O) $(TEST_DEP_FILES)
 
 endif
-- 
2.55.0.795.g602f6c329a-goog


