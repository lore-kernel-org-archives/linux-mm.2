Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E829DC83F17
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 12:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7BF6B0099; Thu, 31 Jul 2025 08:22:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369286B009A; Thu, 31 Jul 2025 08:22:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 230566B009B; Thu, 31 Jul 2025 08:22:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 11DDD6B0099
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:22:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B27E2BA6E5
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:22:03 +0000 (UTC)
X-FDA: 83724471726.01.C069B29
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id D0C2040007
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:22:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k9kJglha;
	spf=pass (imf27.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753964521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ayWZPS7L38ZOhjcOnH9WSUS7UcJth2Mxw9Vr7h3Jt6g=;
	b=Wx0tuFrj3NrJAWKZnmBClqnXClYxi5uCJZp+wbVkb4Me6Lbn3f7QbBX7IUripkH00695ZK
	fGjLKmzmKWG4DkEPYkjcLAjc9IppUL2XCJdhSNHy9q++kUE+pnxA8EVHfwNZhO9ifXdX53
	Jab4yVKlS94ReCrejLLyl2fL5eG4BsQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k9kJglha;
	spf=pass (imf27.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753964521; a=rsa-sha256;
	cv=none;
	b=V6zyogvQf+mH9ExMoBAGIjOW7wstDXE1mfy5FVEq0qqFZaxyXlN9u9DJteBs42nCMyfhd7
	pCk4TbQTRYS+MouL00DmrBYmdF+Xn/0L5eAsRWD/swStiH96AXfvzd8M4r+9EgPSMjgR3V
	70UI80sMQvPA6/Mvvsk3F+9zyjAhkEM=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-70748a0e13dso7401126d6.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 05:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753964521; x=1754569321; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ayWZPS7L38ZOhjcOnH9WSUS7UcJth2Mxw9Vr7h3Jt6g=;
        b=k9kJglhaoX4G1FcHWzfykLuhmSWunkUTJMKs+pqgyaW38nXJ+ZSRhm3zJbBjqe77ar
         V5R+Bhs2Z6LcYV0+0NW7RCjJ82S7wRefMqvD3RuOi0/YenF9NtXNzNpQEacbEmFW0r8m
         QTKXACLTqRUsp3nE8WT8OzVq5bmbrufgMlnufISpy2ugUfHOB6nFhs62RSQs8sj2Jdv8
         pZ3OOWVcP3HHdU3JS3BnSjLye7f9QdsMF5XYfgIxZB84VWjdkY1Mn4oDRupjNgjRNm+B
         r4xsGozH4oPFXuPuyAwtBzf1eEhE9q8vO2X/fqCM50D4pwKclyBLAum0XioCpNqh1J0p
         K4Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753964521; x=1754569321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ayWZPS7L38ZOhjcOnH9WSUS7UcJth2Mxw9Vr7h3Jt6g=;
        b=WMjrjYZu7l3fxdMU4vV4SqoSTyIv0JneB8W34hqnE+kVvwrS+Aj2HgQHVxHeVTt8RC
         EvaP2EkwsqZca0xuMyAhYXi3S5Vleu3CaVfzEwHJqQutXVKsnZ/PR9+Dl08gcLWmw4+i
         mwhwcmTaYMaEcXNYYqE1nJOIvwIUvGuAvmON1ansPWvcp4EdfLS9drcGY3UPfU/hrhZP
         u6ZtMAzB987pDF95A7QoFuNjyu7c8MpZ2Eu4DUFXZpf8g9bl9HqpsL2QQxCPYB/mYCoy
         94FUDOLneqZzCzriEKCfcVhxrEbgT4g2KIyDYpVhivjqDet5cVFRVsvR6nWFtgwZ1AD2
         SQFQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0QSdIIq81grQZ6pXvynHN/fStHbzJwBQogvZaYphquaw8MQZd5kzs39WY64ZQ6w4KgrDZt3dDzg==@kvack.org
X-Gm-Message-State: AOJu0Yw7Z5waPMHP27f5S4o+j+F3dkyK2nA0kdSt80UjTA68RPT8A54G
	tKd11imEr6bkYInKWvYtzVk8v6hU2SeXp6NKZ/EL62Hy1ykdOP/XWbGT
X-Gm-Gg: ASbGncsI8pdHQb58s2bS75RzX05UcGZ3JDotPMHDCrRjpocoLvLyqczAmWF6PSSO0AT
	tM6YrLXkA8SFHWKSTaDylOx9RGKSB3VuOnIn2T3iChW47fSlj14vXW1fsgz3sux5QjBfWe/pzEq
	waz8yqDyd8js980B508+lWzRdNL/ye4ko2Sl4j5w0xP8ZJCgcWlg3B4BhlDcGqFDW7AXNvbNbBj
	nu2j2Y0do93qcaSV9xE91CLVcDJG1cGsu49iIZb/6ujkpAWFQlSdY4B+UU+5OduTA3/tejrsfml
	n0KA/JCw4+gRYWt6fVXMo9zPE3WmRC1jsdBfltD+DSiCj+Pqob5qjJukZwiUyJZUUNyHYwFhcFl
	84R2bzTpKEZ85C4M4laR1qz97CbJofQ==
X-Google-Smtp-Source: AGHT+IEG8qEX092BNX445pCTiZvfAk/8cPS6Yyb/65Po+og4Y3N0gHtq/q6lu9fesOTaaOoDzml9lA==
X-Received: by 2002:ad4:5aaf:0:b0:707:5ff2:aea5 with SMTP id 6a1803df08f44-7076726bf32mr94934336d6.47.1753964520748;
        Thu, 31 Jul 2025 05:22:00 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:8::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cddc290sm6477556d6.63.2025.07.31.05.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 05:21:59 -0700 (PDT)
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
Subject: [PATCH 5/5] selftests: prctl: introduce tests for disabling THPs except for madvise
Date: Thu, 31 Jul 2025 13:18:16 +0100
Message-ID: <20250731122150.2039342-6-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250731122150.2039342-1-usamaarif642@gmail.com>
References: <20250731122150.2039342-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D0C2040007
X-Rspamd-Server: rspam06
X-Stat-Signature: puduebgfbkocw75fnabw1x1hga5frxua
X-HE-Tag: 1753964521-69157
X-HE-Meta: U2FsdGVkX1+erAAUzwqxCTE9VCT/3JqakU55f46usZS2MqPhFt+4XQaDOmgKdI3lR0E+VJAD5l1lW71aj9bz0D4/nm2JVU7ZsXFCJV14TcSTqVi8WCAM3GxuqFZE5iY0nB9ZVlAW8vGOWH+SxV81ZJzsKU3OuhW58zzzzgc6aBmKH8ptpUZY8YVYxtcH8Ys1zi+8I47C8QZaAVyRSDI/Q1v6JR13OhTUUYJJO7+Mf1P05VdbasZ3BICH3+vNcws/Y3aGNEM8vrZcEQSEbbccXZqeoQ4MnnRYFS9Wzh7oFVqDHb6/Mo2OM/7hVR7H7YIB+RBZT8bz3Xjb8W9noum3fWkpAPz/A26yvoxehjfi0sPfc3J15z+VcxtApE7gPfB9vz/ifYqqVlLrIginNKeRXa6i2BIyI/LjdBZkvvo3PYzr/xI/WB5dX3tGCLQELHTrxPPDan6O+xAI3Lh2115V2Lk7k1pVkv3VeCX5FkjcFoFc26DnpGGeN7LwhXpP7+dMuA3eG/1oi7ERLVXWmotU2eo0g0sdwpj7F9vNTuVUXM55zQZwD/RL6Ln7akmjPRgGGUDzTtJNki8lpj+HgGRVRbx/l8BfOtejWf5vE69SokyiHSNseNtLbi6LNV4gwA7cIjAarwJvfiFtT/WDAQ9qI1J/b0tGL/9OXr5TWMAaE5ElGh7xbTIW+frm1AmREVnY6vUs49TP4japN91UUebeRbJAY8m7pLKKBlMDVvfsirhKERV7/bGhPlJCNmQuOAcAz6vIm8bZ1oTiVEb3IBqFhDtYUjdAmcuNHTA89Fk+24vTb/Y9yzQ7EiqDxEBgj/rxJ/16FGVM4FZqiGeehH95Xl18M2I6TcA/F1yPqZsUx0tAEoER5lXPKmR3LXX/BLvQWL3QbnCAQsDZGkupeHKuaq1SUh99jQ0A+qgQ7EtFdFhUV/dZx+zMsPBYaQvdJGn2OZugohXmGnjAzqxYYrf
 V0mcMkGH
 /MD2UL82+PL901KLHRTrMCtUf89SYoGwsgzHctvyRD4SBvHOHEBKKzTzv8nBD6sq51JNpuInfjBdjToDBuclMJHYxR2T6N8r60VgPdI/Sltl0Q87T+7Ch4vCf27M1xnCGZjjinXJm0ykNS3IbwFKgqw1zSl5KXBCHttCQClyGy6nfwacvfogJTMSlnmD2a3ZgdL+jOCcw7sudpCkRdgeFVSp65NckJ1nL8kSq2UCE3Hg7IL8pJdZHgZ2cqemCZAko0Vt9fncPZ0Pr2wOlNV21WielqcEYXfvLqNa200HnceXCtaPsSg9nJ3ptSntPXUMcENV3mtAkO+IJvgk4Jc2z5p5YEuygNtwn01kMgyWkiR5cvpEPzvgKCfrUuriNbXMMGtk4sXL/bkDzvy55vDZi7uO4qEJhp3KVOI+Ysz4rXIAmy2QPc8VVNYffyuWFuwe6uIKtk3IXyNyMO+KVMmM/EZv84C8uWJrdarXrv8xR7n543AhkXG8+S+aBi6DFV6Dp9PvHVfXa9k2XovARp8zQA5khVRG2xPeyfWmo/3Okj9ukMhfX6qpmpa9cJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test will set the global system THP setting to never, madvise
or always depending on the fixture variant and the 2M setting to
inherit before it starts (and reset to original at teardown)

This tests if the process can:
- successfully set and get the policy to disable THPs expect for madvise.
- get hugepages only on MADV_HUGE and MADV_COLLAPSE if the global policy
  is madvise/always and only with MADV_COLLAPSE if the global policy is
  never.
- successfully reset the policy of the process.
- after reset, only get hugepages with:
  - MADV_COLLAPSE when policy is set to never.
  - MADV_HUGE and MADV_COLLAPSE when policy is set to madvise.
  - always when policy is set to "always".
- repeat the above tests in a forked process to make sure  the policy is
  carried across forks.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 .../testing/selftests/mm/prctl_thp_disable.c  | 117 ++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index 2f54e5e52274..3c34ac7e11f1 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -16,6 +16,10 @@
 #include "thp_settings.h"
 #include "vm_util.h"
 
+#ifndef PR_THP_DISABLE_EXCEPT_ADVISED
+#define PR_THP_DISABLE_EXCEPT_ADVISED (1 << 1)
+#endif
+
 static int sz2ord(size_t size, size_t pagesize)
 {
 	return __builtin_ctzll(size / pagesize);
@@ -238,4 +242,117 @@ TEST_F(prctl_thp_disable_completely, fork)
 	ASSERT_EQ(ret, 0);
 }
 
+FIXTURE(prctl_thp_disable_except_madvise)
+{
+	struct thp_settings settings;
+	struct test_results results;
+	size_t pmdsize;
+};
+
+FIXTURE_VARIANT(prctl_thp_disable_except_madvise)
+{
+	enum thp_policy thp_global_policy;
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, never)
+{
+	.thp_global_policy = THP_POLICY_NEVER,
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, madvise)
+{
+	.thp_global_policy = THP_POLICY_MADVISE,
+};
+
+FIXTURE_VARIANT_ADD(prctl_thp_disable_except_madvise, always)
+{
+	.thp_global_policy = THP_POLICY_ALWAYS,
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
+	thp_save_settings();
+	thp_read_settings(&self->settings);
+	switch (variant->thp_global_policy) {
+	case THP_POLICY_NEVER:
+		self->settings.thp_enabled = THP_NEVER;
+		self->results = (struct test_results) {
+			.prctl_get_thp_disable = 3,
+			.prctl_applied_collapse_none = 0,
+			.prctl_applied_collapse_madv_huge = 0,
+			.prctl_applied_collapse_madv_collapse = 1,
+			.prctl_removed_collapse_none = 0,
+			.prctl_removed_collapse_madv_huge = 0,
+			.prctl_removed_collapse_madv_collapse = 1,
+		};
+		break;
+	case THP_POLICY_MADVISE:
+		self->settings.thp_enabled = THP_MADVISE;
+		self->results = (struct test_results) {
+			.prctl_get_thp_disable = 3,
+			.prctl_applied_collapse_none = 0,
+			.prctl_applied_collapse_madv_huge = 1,
+			.prctl_applied_collapse_madv_collapse = 1,
+			.prctl_removed_collapse_none = 0,
+			.prctl_removed_collapse_madv_huge = 1,
+			.prctl_removed_collapse_madv_collapse = 1,
+		};
+		break;
+	case THP_POLICY_ALWAYS:
+		self->settings.thp_enabled = THP_ALWAYS;
+		self->results = (struct test_results) {
+			.prctl_get_thp_disable = 3,
+			.prctl_applied_collapse_none = 0,
+			.prctl_applied_collapse_madv_huge = 1,
+			.prctl_applied_collapse_madv_collapse = 1,
+			.prctl_removed_collapse_none = 1,
+			.prctl_removed_collapse_madv_huge = 1,
+			.prctl_removed_collapse_madv_collapse = 1,
+		};
+		break;
+	}
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
+	ASSERT_EQ(prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL), 0);
+	prctl_thp_disable_test(_metadata, self->pmdsize, &self->results);
+}
+
+TEST_F(prctl_thp_disable_except_madvise, fork)
+{
+	int ret = 0;
+	pid_t pid;
+
+	ASSERT_EQ(prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL), 0);
+
+	/* Make sure prctl changes are carried across fork */
+	pid = fork();
+	ASSERT_GE(pid, 0);
+
+	if (!pid)
+		prctl_thp_disable_test(_metadata, self->pmdsize, &self->results);
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


