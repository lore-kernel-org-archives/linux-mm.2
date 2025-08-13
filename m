Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A452ECA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DDCD90008E; Wed, 13 Aug 2025 09:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0195F900088; Wed, 13 Aug 2025 09:57:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD60690008E; Wed, 13 Aug 2025 09:57:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BED52900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:57:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 791B75892B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:57:39 +0000 (UTC)
X-FDA: 83771887038.07.3906DDB
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id CCC8720006
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:57:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mbyP+gV8;
	spf=pass (imf13.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755093457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NhYoYaOUMkMJm97VAKTBrfYYMNfg62ONv3OFOKZnE0Q=;
	b=OUT6BVI7b4DlEkfGitGIUhGqDKghRDpr7DSnHh5U4oO4XpRjEY4C0GPbitP7QA8vFuQRZA
	zitmlSEUWXt5u3k2h+LB6rUTWbbq0ZDMhjV4D/3ypRqG4v8wiQZyj0PvorhkkQI7mqtI6J
	XctjtwXDIVGGyAA8gpxjnHw62b28w/c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mbyP+gV8;
	spf=pass (imf13.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755093457; a=rsa-sha256;
	cv=none;
	b=qrNgI/IJeUGRinLHdAmGjcLZDWHq1XKzWWRh9iI6kpfDi15h/2czBUFymgVvfLmYmAZ2Gj
	LLTwq45ALy47KmXztRyjbz8HmMdYeLmJbTnbjlHLfS2t6h4NpGXWd/2IpTtICABrzm5k3L
	vqxAJT9R3p9v3of7m/UEc2bWWFjDc88=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6f8aa9e6ffdso64807706d6.3
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755093457; x=1755698257; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NhYoYaOUMkMJm97VAKTBrfYYMNfg62ONv3OFOKZnE0Q=;
        b=mbyP+gV8tUBzE3eMv6GBlPyy9G6CXAaCU3l9wUmTp6cOPORE78kW7L16yo9cWv5F4A
         TFIo2WG+zI+UCinZkBJVTnxUpcfs8tfJFwQCcFYr6JpF2U4qzAVCcIjkk4QCPTGlzg4f
         1MERyUDbUJxBLtvmSgslcbPisyNQgk4iVbFp9LcArPs0cCD6QUuh6BspJIk97yj4v0xQ
         enoNwt8x9y/DFR1Kg34TnzuDLzt1zd5lY716hBzqEgGP9NDmbhuHaGSRuLZ5ILzRaKe/
         OVgc/zyx7gzZRP+8DdEFw0keM9eQXynG/oePZb6lfeFfKGT2E0JaN874rLg1vpmp9FwF
         CjUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755093457; x=1755698257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NhYoYaOUMkMJm97VAKTBrfYYMNfg62ONv3OFOKZnE0Q=;
        b=iwuSeexNx350tLf3q3ZG5/myKV+PobcaIvPtuqUrWDDex0tD2bMjb29Xf+UXlxMaYB
         lLWABDaJoa/YAJ/s5KKnUWSpf5Fh4IaSgpUApsmOoyGAoob5dEapkXoQIy1Lv7zqmxVB
         QsTS+3kiqYYrqUzOPPiHdC2XU+Z+/u7wU6rxeLqvFlCS5ie+nSPiazh1wY1F7R9Cmb7p
         eIv6vsOzb+REyM6gvSOL6gqbiJmFpoqyAY9MlDPcdS7fVODPa98a0sizvji4Y5xFTDON
         Hiwc+P7++I9HN7vMtSVM9QWm9uYCSEs3OcvTy+dM/DhkfeC5sFFTCTQWZVB03+pPOdMq
         JYew==
X-Forwarded-Encrypted: i=1; AJvYcCUuPlh/Qsvl7HnANgxty+65JkoVMKoGfolCSqYmztfzJ6Ochk+Zi7QeNToS/Qv3g6xp79d2xf4F2Q==@kvack.org
X-Gm-Message-State: AOJu0YyXo038yr2AWfCFBNkKP/AuZi0lLPtW2YIVKWGKcrWCi06AVuyi
	mDcZhN0ePIP/HAHPco/NiohnoaCYt5AngBPSpKE+WxRRMTgc3Sugi8mA
X-Gm-Gg: ASbGncvHWkmQMFxFpbcAA446NN2uC9bArAufiX6QWFNechahzHKtXSJzDtMqYRMW5aV
	DeC66kN5I0PJLCfPfXGtOWbD0JTJq1K6B4xk593FBdx804/2nwXLrhG0d/gWa3pBFWQ/JAjlZl7
	kQUJlrCCsXpRVvUYqx03PGxutc9yIqQYY4v7SZuNgRfG2RmKxCrveaWz5Ya+gqdwJyQwBzGXbu3
	MLEfg/gOtS9ySKWd1VgaCRQyOQQQlO+fpxnm+/G3cUWCd+ZeFLbKaurhOfnU/vOWz2sLlEZoWz6
	zQn3U3nJeJyF6R81Uq+AfQ2gOJef8ijhM8BiqjNfqC6jhARpC39h9R+QvBygKUWUNgUQ4feo0b2
	sjiyZFw8v1VKoVFtfj1zUVCL66fDO3g==
X-Google-Smtp-Source: AGHT+IH0aNFGdT37nfMrLCaAZe/cVvkGkftyTgbVTAS04COtTvWgOnAfg0kobetjfsL/1x4PZf63Ag==
X-Received: by 2002:a05:6214:1c82:b0:707:6364:792f with SMTP id 6a1803df08f44-709e87a7fc0mr35875056d6.11.1755093456671;
        Wed, 13 Aug 2025 06:57:36 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:6::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7097398b38csm125600306d6.72.2025.08.13.06.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 06:57:36 -0700 (PDT)
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
Subject: [PATCH v4 7/7] selftests: prctl: introduce tests for disabling THPs except for madvise
Date: Wed, 13 Aug 2025 14:55:42 +0100
Message-ID: <20250813135642.1986480-8-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250813135642.1986480-1-usamaarif642@gmail.com>
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CCC8720006
X-Stat-Signature: gzxkwc9ixcxc8iunzex1suhrwxq9ket7
X-Rspam-User: 
X-HE-Tag: 1755093457-917434
X-HE-Meta: U2FsdGVkX1/ADH6wg2j56uargH0Djw+DqM09b4HGyMdCuBQHV+MRmdsVzCHWGLHHO/twwvRrfDWIVVWSBxSrrb4vcHVibbHAIT3diRkOkCoCfMVYkBbPYqsFlWCSNmppq/H14Xlg2noU9K5BmZdWdiBnTWmWTq5X0BBbBEtU5mwvWDhuuhfritNS1WH5rv/tRhxrLJZcr/P/Y2qka6/a6ofBUQ6NpgrEBXdNnPoDMl//GkE4OYfWJM29NoiUfmC6y4mWLQ6+qbgpFTRnt1QqZ98/3114s7W/ioD0sHpQh5qMx/MtglJ2naBSjktP+A3Wlt8I41PWXYLrZy72EKzuT+JU71AtyR1VTnUxqxTM1KZGjH2ZDupQGc9XkOXnElqOMfGMmbJytdVsll05+FTBKN/QTcXiKL9Namd3n0CuSxDvCsf1aiDIsu77vieN+S9ZhE9HVz+kJuO48/UA8DYT1wbkzmM76v+iZIBIUtNocCDCCpLesZrjKhuArVEbZP096MVnOeTvaryfRPs8/DOTSu+4a87+42tm2UXsVIGEM51ltoQA1cEHoHlMzMgHuy//IJKTOB+dRqmFFFpR3fAeBuNPmHbWgcYpZZOo1HMnk+X2kaNv3vEuUQ7nZi624wvXB4XsDdafgUq1XT0LBcSm5OFIKLMDKhFKOlRngxe/C50YMoyBcSF2xMiKhM4ypFevB1I/9GO01n6wj83QTCeQboOWdtvYdCuDmYuKz0uGIoYk5A2tnlf+E3HLWnv06RH1uprwU9eO87SvSDsWWYZZLR3COh+XZ11SVV3853jhVFiPv9t3hNbl1F7ezI2SLB9M7JmpQ98Ow5Ljab0PMSAYlZICcC0+xHdTVHUEL6N5nn3NJC1DNbLTlBFeRsjzDjrSnNdbC5KPmHfCmDZRWMDb1iLy1KJvzOEs600BKklpXCzMjkj4GwJA+7LrA3CVYZwJVzE8Pspk8Yzykof+QPP
 rJdeuKF6
 sZTmxNa/ttgGn4nb0Eg9okXCSrpMuShlAcxThxVTJ5RZX9GcUtaFjLclnw2mtYQyvl5wbtrPRzL/8TwTOk2Ge5ZkVMWbeKuihZEyHlSUYLwrIyLUELOT/zDKvir4UuXi6DLXzbO4FRM1T3od43wrlUALkzQRtCYkIUEAOMXVkUThPmsA=
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
 .../testing/selftests/mm/prctl_thp_disable.c  | 107 ++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index 8845e9f414560..9bfed4598a1a6 100644
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
 	THP_COLLAPSE_MADV_HUGEPAGE,	/* MADV_HUGEPAGE before access */
@@ -165,4 +169,107 @@ TEST_F(prctl_thp_disable_completely, fork)
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


