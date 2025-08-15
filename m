Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6674ECA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 13:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 481168E01FC; Fri, 15 Aug 2025 09:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 430A28E0003; Fri, 15 Aug 2025 09:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F9198E01FC; Fri, 15 Aug 2025 09:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C6918E0003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:56:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D04A38195F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:56:07 +0000 (UTC)
X-FDA: 83779140774.26.2B94C03
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id 004E4180003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:56:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rd28LtPM;
	spf=pass (imf16.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755266166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PDJg+8VWkXRRI01/m0uJH2Q2Hi8ld8jM3wHbWmjFcUE=;
	b=WHNwasYL0j+CWSEQAsmHjgI4cHCptiJXxOM17Xy3fPzm7ZXjVv83GEk8Twss5OzjanvMlM
	PRlrc4xf3oYjO8D1PUKhDxVaYFgZCcNyPFE1vZrd3gN7Lxt0tZ2lhe8827HKsQZVqxwDXN
	OPJXY7yrLPGpZQDTXeacCz3++Qac8cw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rd28LtPM;
	spf=pass (imf16.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755266166; a=rsa-sha256;
	cv=none;
	b=FuQ1GGwAcT+uYeXzX+RMDnnaUitpVMuD4gU6EFuZOyOdzWQ9s6YnzQgObRp2TUFnKqOwZa
	081BrgWOD39+yc3mZH1iJtwcjgOCIcxhE9fgQxO+ESr7RZmd9w00qm4XXcXP7NZyolMG8z
	i7k30T0UmUV8bA9GdfEpk+wY+ssH8Cw=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4b109c5ac7bso21037301cf.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755266165; x=1755870965; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PDJg+8VWkXRRI01/m0uJH2Q2Hi8ld8jM3wHbWmjFcUE=;
        b=Rd28LtPMbmEGjm/3dshKQvaG9jQj+jJNgq2mnKO3BEV5vJLLliN0cXLnms+GXtIoI5
         IWJ9hHoPtzSgW+2j4uZGwsk6+KeBkr44pG1nIeoM5BYdvrfkQVV3NWn8ZcFNhYKNKj2V
         vgVQSQJ7pvN3ecal5/rnXrOjVln4iBEqzIeLNDuU1f6GFRXkxLVUQA+jo77ME3lY96HH
         nmLgMM8BIJMAfhquwgv9SkEe+WPS707F5w+VWZRee4AnyytGEWKOyWu1Ivjl1oixt/pS
         LR2wxL9G2xw+mnI260RH7El3D1/W30ri1U9TD4aD/+2LlXmvgMr18yOlUGcUpmbEU3yJ
         l0iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755266165; x=1755870965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PDJg+8VWkXRRI01/m0uJH2Q2Hi8ld8jM3wHbWmjFcUE=;
        b=dBEWs+PZ4FlG990JlfTcADMPDCiH+V3HvqJQfCFZ/zOi/y9KEmCQgvv/lRoCgeZHY8
         W29O70+95X4jFD28O+QraxlY8C/KOZHJsuSxU8FA9ze6/vPlnHJRA+4wQL8Ss50u7VRu
         T84XuZ6q8IDXvScfn6bK1fAqDHEOHYF71EbHAEB6WkSQehl5bz9nPVDLTfnfSDQYNx5v
         GMkWc0bNylFp/GLnj/+9ivL+53gR1ROmNZJVQjThmOHiaDrlqnSge03BJhGsEiu5+n9s
         f/RTf0/QBn7VVxxhuX1XJzGsDqI0VTF9WyBvxrtp1GhRVCg9JETdn/MBueR5ur9NLEc0
         t2pQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7FznGJMh6bOWL1wI2Q6qVCWcxjSUVX2UNoRnFp/qrrolQtzZE1zk/AFgNS3XeRrZUC83LT23RbA==@kvack.org
X-Gm-Message-State: AOJu0YxOmxB1geH/1ttYwY7j+ZyYk71T0FaulKkA1STgPrXAZt9GqxPI
	jXOo0f3ewM73unhZNhOal3CEVMDSJnrxqe1bjofyGn2NhyAnn7Zld2Dl
X-Gm-Gg: ASbGnctYI1l61GD33BJRzg6pv3Wyp0DM/Qs6vX3ybgwGVgVyorTMxFXiUIgENLuXRJQ
	oVoUSm1hf3yFHAg9iz5l/xSS1zmZwLgrbsA7tFib6un+cqyKnvh/PX8BH5o3vN1igu0e/W9FaoP
	pl5y2XdtuHPNAPTfIwsJxPscT9RJZZwlsDdXGl0gFG+cT1espS6s6NLj0CllJmSWkwofcNINnZ2
	RMWGc+J+DcvEAtIBHaJy7IUCQ2dFI/TV+yV8JPYC9vyWpTC19jUGhL7oD7MS4F09401Kih2G/0t
	rmMatDBvO+SFcDoExfXxndKujoxD3VZgfgPx4Fw7IYBGLRqjP+vUd0+MB4ieQRzSzkOqtp2JQKL
	Mtcl7AjWdAKtGZNuTXxY=
X-Google-Smtp-Source: AGHT+IGiowQqpHScj8TmKBlVlJNsOwsO0+vsYR/6GIDeAkEcuuhXzeHkMw4QTi8JVjdMqvbPaYNdmw==
X-Received: by 2002:a05:622a:8ca:b0:4b1:103b:bb6b with SMTP id d75a77b69052e-4b11e315af2mr26902261cf.61.1755266165043;
        Fri, 15 Aug 2025 06:56:05 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:7::])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b11dddb0f4sm9436461cf.38.2025.08.15.06.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 06:56:04 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	ziy@nvidia.com,
	laoar.shao@gmail.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>,
	sj@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v5 7/7] selftests: prctl: introduce tests for disabling THPs except for madvise
Date: Fri, 15 Aug 2025 14:54:59 +0100
Message-ID: <20250815135549.130506-8-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250815135549.130506-1-usamaarif642@gmail.com>
References: <20250815135549.130506-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4hwuyrsxuzypnc6gobaw86wf76kmbjpy
X-Rspam-User: 
X-Rspamd-Queue-Id: 004E4180003
X-Rspamd-Server: rspam01
X-HE-Tag: 1755266165-236710
X-HE-Meta: U2FsdGVkX1/SqqyFwnmacQ5T0FjT8Fr48TCOeYZqF/csB8zV5aO+S/VAeKL0n08RhKMd2qvRToeJNQTs7DYVj079F3KMXnp8MM7UP9bJIoFPize/lVM+lOegr5cHWAxISldrogzFknpmLYvvEjtqpGeyouvX3STQBVTMimxlJ/3CM29O/nlJ24pDzEa/s8INecoNlU55LAkhIo3CmRS5LK9VCmGo2xHMxnSnld9hvMvj4WhpiQZi8wHQyWNTKksyuV7Aze92HYmgm4RjmRje25Cbjopjxw6dkYZPAI6iga0kD0ZomU/lCBpYNSmzSZGvvMoCVxHoJGe1mWowVcts+JtwP7VvtgJYCD4rVJYK2e3TPH6Vc7uB++Y1ggeLcYCg/VaFmajr74m1CcKWd1KajD09bkWZ5pqZsoAm0wlHpp5YiL+LpQ9u+/7KgZbugBZpmXbNqAKnnt0ZHUgHYuESUNYCDRdJtqBzap9vj8Lbb58pdvSLyZdJfp7NW3BaNHJjqOiKkUuzCfyagbcoudrbqBRSIvcIPt6TnH6WhByo7O4O8DYI8WYMvNICV5Dy5mZpXhnOnMKkSwPLe68Aet8HUt63a4wY6BhOnEJlXo7VOmugwO/kMLV776bSuIArMJKYCKyFEyxnL4cNCBDvWbXK3Y5XWZrwHU7FcnQ6HHk7f12+GxX484auSJqbKxt1Bc4OE0gAuZeyQBFptam8LBW57ULC34zrTt64zsnVUTm8XH1OsxxpmOkAVHlD+jhH717EX3bocFG+CJg09m5GcQqMDevQ9GqgTatvIxhBEveGxAnjkqlxzzrUHI8tetqrIiayDyTcmVUm8zGtk9H98UDPcVw0GhIyAYwTTnFtl/oNsfCI6eZ+TqcpU/f+7Zo4UsZKGgyGEbVzKW4YOVH4gDowxyDTb7ejiezUFhENPG7eJucKKrkXxjHeWpxh8yE/8t4vDDYCir5M2oEmMgm+7gw
 VhhLxyun
 HoYZ2X/7vAa9rjpHUwcNXrO3oWPr0u3RwEKERIffocgqPOSh1ZDxaxVVeJVn2HpJ5SsUV5YEKpPcRR5DMz2uT1y3Umu6vXEUVAndIpz+qkXnCPA+pIIa5cjpOaf0viv249uFAbdCWF5IaEPLVnJSmMD5my6ltUv1J7gVOeWgvH9vv4GXfFvNhoR3sxHD7o8pUMvBktvUPz7ZGICEGuOkmUvc2dosg4Tg7pdQneeMPsI+SMgiy6ddwqiHayv8SFIKG2e57MpKz8UTFV03VWY3IK4M1qt9uLAZrliMnI6I0HsHnXNtwcuB6R/vujHb1bTlvWxFIed0ORMYMg0HUMNrvYzQkzHrPiOkS0EovtDCibUGlqFny7fBWw3gOHtCKrt8v3zB7Dp2ML3hs5O/lz7bkkD/Gs8z8FkiJG2vsZ4nZYT5srPfT6J5L4kkCS6oKFFgytAULHAmXx0fvbDvqIcAPaLCeCvpIQllccugvKtkFG8VYqhFBnJgqfXR4o7uajhf+T04adfLranjGti7nBaSCPrFRXE1oIxYMXGW3TouUPfptXVIvhJZ7BE/0Hw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test will set the global system THP setting to never, madvise
or always depending on the fixture variant and the 2M setting to
inherit before it starts (and reset to original at teardown).
The fixture setup will also test if PR_SET_THP_DISABLE prctl call can
be made with PR_THP_DISABLE_EXCEPT_ADVISED and skip if it fails.

This tests if the process can:
- successfully get the policy to disable THPs expect for madvise.
- get hugepages only on MADV_HUGE and MADV_COLLAPSE if the global policy
  is madvise/always and only with MADV_COLLAPSE if the global policy is
  never.
- successfully reset the policy of the process.
- after reset, only get hugepages with:
  - MADV_COLLAPSE when policy is set to never.
  - MADV_HUGE and MADV_COLLAPSE when policy is set to madvise.
  - always when policy is set to "always".
- never get a THP with MADV_NOHUGEPAGE.
- repeat the above tests in a forked process to make sure  the policy is
  carried across forks.

Test results:
./prctl_thp_disable
TAP version 13
1..12
ok 1 prctl_thp_disable_completely.never.nofork
ok 2 prctl_thp_disable_completely.never.fork
ok 3 prctl_thp_disable_completely.madvise.nofork
ok 4 prctl_thp_disable_completely.madvise.fork
ok 5 prctl_thp_disable_completely.always.nofork
ok 6 prctl_thp_disable_completely.always.fork
ok 7 prctl_thp_disable_except_madvise.never.nofork
ok 8 prctl_thp_disable_except_madvise.never.fork
ok 9 prctl_thp_disable_except_madvise.madvise.nofork
ok 10 prctl_thp_disable_except_madvise.madvise.fork
ok 11 prctl_thp_disable_except_madvise.always.nofork
ok 12 prctl_thp_disable_except_madvise.always.fork

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 .../testing/selftests/mm/prctl_thp_disable.c  | 111 ++++++++++++++++++
 1 file changed, 111 insertions(+)

diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index e9e519c85224c..77c53a91124f1 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -16,6 +16,10 @@
 #include "thp_settings.h"
 #include "vm_util.h"
 
+#ifndef PR_THP_DISABLE_EXCEPT_ADVISED
+#define PR_THP_DISABLE_EXCEPT_ADVISED (1 << 1)
+#endif
+
 enum thp_collapse_type {
 	THP_COLLAPSE_NONE,
 	THP_COLLAPSE_MADV_NOHUGEPAGE,
@@ -172,4 +176,111 @@ TEST_F(prctl_thp_disable_completely, fork)
 	ASSERT_EQ(ret, 0);
 }
 
+static void prctl_thp_disable_except_madvise_test(struct __test_metadata *const _metadata,
+						  size_t pmdsize,
+						  enum thp_enabled thp_policy)
+{
+	ASSERT_EQ(prctl(PR_GET_THP_DISABLE, NULL, NULL, NULL, NULL), 3);
+
+	/* tests after prctl overrides global policy */
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_NONE, pmdsize), 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_NOHUGEPAGE, pmdsize), 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_HUGEPAGE, pmdsize),
+		  thp_policy == THP_NEVER ? 0 : 1);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_COLLAPSE, pmdsize), 1);
+
+	/* Reset to global policy */
+	ASSERT_EQ(prctl(PR_SET_THP_DISABLE, 0, NULL, NULL, NULL), 0);
+
+	/* tests after prctl is cleared, and only global policy is effective */
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_NONE, pmdsize),
+		  thp_policy == THP_ALWAYS ? 1 : 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_NOHUGEPAGE, pmdsize), 0);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_HUGEPAGE, pmdsize),
+		  thp_policy == THP_NEVER ? 0 : 1);
+
+	ASSERT_EQ(test_mmap_thp(THP_COLLAPSE_MADV_COLLAPSE, pmdsize), 1);
+}
+
+FIXTURE(prctl_thp_disable_except_madvise)
+{
+	struct thp_settings settings;
+	size_t pmdsize;
+};
+
+FIXTURE_VARIANT(prctl_thp_disable_except_madvise)
+{
+	enum thp_enabled thp_policy;
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, never)
+{
+	.thp_policy = THP_NEVER,
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, madvise)
+{
+	.thp_policy = THP_MADVISE,
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, always)
+{
+	.thp_policy = THP_ALWAYS,
+};
+
+FIXTURE_SETUP(prctl_thp_disable_except_madvise)
+{
+	if (!thp_available())
+		SKIP(return, "Transparent Hugepages not available\n");
+
+	self->pmdsize = read_pmd_pagesize();
+	if (!self->pmdsize)
+		SKIP(return, "Unable to read PMD size\n");
+
+	if (prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL))
+		SKIP(return, "Unable to set PR_THP_DISABLE_EXCEPT_ADVISED\n");
+
+	thp_save_settings();
+	thp_read_settings(&self->settings);
+	self->settings.thp_enabled = variant->thp_policy;
+	self->settings.hugepages[sz2ord(self->pmdsize, getpagesize())].enabled = THP_INHERIT;
+	thp_write_settings(&self->settings);
+}
+
+FIXTURE_TEARDOWN(prctl_thp_disable_except_madvise)
+{
+	thp_restore_settings();
+}
+
+TEST_F(prctl_thp_disable_except_madvise, nofork)
+{
+	prctl_thp_disable_except_madvise_test(_metadata, self->pmdsize, variant->thp_policy);
+}
+
+TEST_F(prctl_thp_disable_except_madvise, fork)
+{
+	int ret = 0;
+	pid_t pid;
+
+	/* Make sure prctl changes are carried across fork */
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (!pid)
+		prctl_thp_disable_except_madvise_test(_metadata, self->pmdsize,
+						      variant->thp_policy);
+
+	wait(&ret);
+	if (WIFEXITED(ret))
+		ret = WEXITSTATUS(ret);
+	else
+		ret = -EINVAL;
+	ASSERT_EQ(ret, 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


