Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D065DC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 15:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BE936B00BD; Mon,  4 Aug 2025 11:43:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 670186B00BF; Mon,  4 Aug 2025 11:43:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55E1E6B00C0; Mon,  4 Aug 2025 11:43:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 426C66B00BD
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:43:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7DFD160757
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:43:47 +0000 (UTC)
X-FDA: 83739495294.24.C928E0F
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id EED6C40011
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:43:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VWf9AC8+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754322226; a=rsa-sha256;
	cv=none;
	b=3u7R0uoPeATGv4VQaJGYTibZE+P7r+8B4Xjm9+ljyV8U+Z4jnuV96xnwCBiOY/GCTvqkvP
	47iylCgA3mktOxtT4zItq/gXTnC1Yq0vkWzTwl/0XFOOpjPx/7qND5rWuiULTEvr2wmeLm
	W3Yplkf5wbsDDXxLoOk5OBud8JCj8lE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VWf9AC8+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754322226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AlmQ4lQBL2kHeox9ZT3orgIvobThtulJfDV9upDXFUM=;
	b=R7ZBkYXx2FNBworQC/yfDC3UdSjZ96A1y0J/qCBLLlLSSZiKvbCof7ICN3Ktbj0XhCpaVN
	s7EptMnMFb2rSLHJXuloSCS1bonEmKG5NWozNrIAvR/v6aHfXI5f+QSKU2RfnrD9EAEvWh
	Dqa0VDRKOO4Vcx+7/kceKM0wV3LLLvc=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7e7f940a386so73616585a.3
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 08:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754322225; x=1754927025; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AlmQ4lQBL2kHeox9ZT3orgIvobThtulJfDV9upDXFUM=;
        b=VWf9AC8+4eeTZW2EhFuvBvnnBMqc3x1GolW3nR2CayAxXeHbc7cmFaW875JwyMktWN
         LzH8Xygb1cKq1NQSR1NpwllgtvA7y8ws9VQa7Z66047yiUMk0MetSNG3Jx3fwW0CzZM7
         o02myO6PRvz9bm3qUhywnnplr7NXLYj7wTQ9+HTSQ0+9K18PLYjqZjbclY5+nsza0Wgh
         D8mRcFLTgr9pI6gk71NenIBuRGzP4t5t3Db5eJEEmnRMmZbl6Bzj/ilxF4vvCvhtHi3A
         drqCtHatmoS7w0AVJFKXm5uiYmLt2k1e3b/ld44HoLPrFoIJCM4EE+HSh9wCyaSI7F6a
         GT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754322225; x=1754927025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AlmQ4lQBL2kHeox9ZT3orgIvobThtulJfDV9upDXFUM=;
        b=Ek8fXljCig8ofmOgJCsBD+wtLJO4kQsA+bfKbSzL/h8lGAhlhjwIeN1uqSUdkDVTSB
         zrcSrq77cdYiczKVkWArOr7WqAnRwrUrG7QaTtRtk2eo3xv94jZfD4HyeWAPFbwv6k7s
         G6z/pIX0rOXLuUYpNVrJjXMzSmSKE8EFMU2j1z5wYubiIXEoJwjwzRwgVzPDmZJ0R3WW
         zx4QbPSW6hS8KUfGYw7sb+SF8miUIjnQsu1SDBwS9yo+aRElyIwYXdp4RrefAVZQYPnH
         UWsL+K9ByDbUu6TFd0+UGNllGRYQYfSubLY+yXvIZpDDQsRKAlNPQK2QH+3hX9VquyNp
         darA==
X-Forwarded-Encrypted: i=1; AJvYcCVWJuNGFAITDANMcn1Hjw6vxWXec71JAU/Rp8KSlX9wHeRXbe1IJgZhYDmLg94Z/XTTi/hJDijHoA==@kvack.org
X-Gm-Message-State: AOJu0YxIullvQKtK4bt0qouV4iiVq7esK++Za9eU2Fdz/iP1m+I+yYX/
	3qRJm0EY9H3rY7yVl1VKGqcy6Xnmh2hUngO3dsz9whUE/zTqq73JqOAP
X-Gm-Gg: ASbGncswl9f/nd/GXVv4Zb90G2eArmV5WmP8TsgaWqmqDdNucfPwVGpoyK7WtKt9W2G
	IK/VR3dCG2GEh7jD+0KIQmYudvsGTOIv0MX6b8RYUgTDz/kqAR/FDE/LJjlQzCnkL0Ae3js2ccm
	qchWqHfGAgmldrxfzzgRs0mwcaFhV9Xc1PTWBbFTPCQN050JiE+1V90xPhvlrJlTC1hAmzucloB
	7npEvitpyhwM2TOi3KkClYiJHaGmK76y6dk1olrOPGZ/jP405B0sA1XYnZATZs28MVRnxTbNMmz
	/FNfY2JC+/XLF30bI36kTeC1dWcO3QisOvcSfBvLP0qvZi33r6y5a0Dverw36YW42O6HfVid8H7
	k6iQ0y/8ZSKeG7jUixXw=
X-Google-Smtp-Source: AGHT+IGJQDqEPSNpcfXCQ0ziPzID1H18Arno2+qWA4NTYcPCKy8chybDSbutvMVp+JOvqicFgo31Nw==
X-Received: by 2002:a05:620a:458c:b0:7e7:faaa:e7c9 with SMTP id af79cd13be357-7e7faaae8eamr591769285a.12.1754322224787;
        Mon, 04 Aug 2025 08:43:44 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:5::])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e695e69ed5sm335521985a.46.2025.08.04.08.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 08:43:43 -0700 (PDT)
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
Subject: [PATCH v3 6/6] selftests: prctl: introduce tests for disabling THPs except for madvise
Date: Mon,  4 Aug 2025 16:40:49 +0100
Message-ID: <20250804154317.1648084-7-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250804154317.1648084-1-usamaarif642@gmail.com>
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EED6C40011
X-Stat-Signature: ebyppye5d9bwzirqcqfzqardga3n4mz6
X-Rspam-User: 
X-HE-Tag: 1754322225-956922
X-HE-Meta: U2FsdGVkX1/mBepgRN/KKkClToapq14TymvSQtHO+EoVibCYeAUJ24KF+OiLd4StpyAXC6zlep2JmKArvSU88Su/rIrcr4vxiuPlbJ4u2J4wqSIOGIJ8ozNmwwK+UyQbU8Sq7MC/p0ZZjcWYvUeI6EkHgynBfSffilPYQXzZxg4nWj5pyi2VcQTtB+1QwLJSCD2tGD47HNM9hkGAyOvBM3Ux7PCI/EYIeRWsXobEjnQBCW6KspVkJxQxx12CpExKQurL5ocVOddE/k5t+m2XnREVa806nBhJkS13vdH4fkuYIUDcUK3NN/JBVs4u1rJEOuzixFI/vVEjJdPALyyuL2HMrT2NBcjshcid4wGO1NqXA8J3iIuAu5Am85h7TYf+f4CYwX/xxrxiyk+kJtRxkW5ckqdtZ3X+7T0SXpxktpHIMpuxXlYgPMgBgHWO1GzzxmGTP+0HZAABkQrpfxzmsaajpw7jnIoueVAFZlbbclLjwrJv5j/HjnCVsHqAt11g3t3KmzUiAKK744xoHWpq2ta/PiPgd62nWp3inggKhiKZ3gPvvdFDJWzt0OPEwwwrt+2xi+QM6xrQJoLEWUuPu2/D2l983Ud7potNbLZWzy8O4nmW5Dsuq/rGcynTDZjuE1ssHfvmhqUzClrThinU58z/9lyrn+MfURfD21Sanlf8mjge+NyrdkOlsp5d477gskzCorFkB3C1QHiNgJ4Z0Sdc+gTtFRZbGgD4Vv1D1Mje4HVTUOQ3454aJGCqC97In11vD7LkNI3LrDKKESn6MBl56hH6eAw1NZtl/gAsV0xyXN9Xr51heK8fTEwsDhs1+XtfvpZZUkr1b278NR4zHXx+LjBWbb82F8zN2KTDfnttGEEMTW61G4j4OkRXN5TOUQKdf+bHAyzYAqZg5BB7VsoquJ0LuFoZ9xWvc1lpH/2zDvC/00bGjsExvTVX6s/0qABWTDVU8ozfGBmqK1z
 0/L24Cks
 FPB1Coh6lYifeTwQcENyYiIG1fEamnqDg89bof7UUjvHVxe6EREAwM8jrjL5aDu8voVzFL9z+XM4mWDp78fDEgnmxp6zl3MlJQYS8+ri/vw2vqYvhLq5OTXCBl/KZU8zF/K5ItBBYO/hOSTdk71kHLPRH9peiicnm5Ia4s8cZe1Q0GnKXx3zcJ0Iu9mga7FQjgRwtn2eeXvWbV/HxDrXf7mrkNRxVb9iYP2NyAeKlIyZmj7iHKv6jIOYYOKjIGmHE6hW8wD6xCebTikqB9d5rTzNHvA9iN2r8XQ7+0zBg/bKL+USJKvQgrplDXX0ejgwbD9gboEh0gHkLgxypIrP+CWSbM7DC88khh8rxf7aOk1roLYT5u5/td9CJFi8kkptGh0hRvG+g9HOlloy0S2vRqUZSttBFUWJEE6OzxdekTsAsmM0ogoil9zSFOKj2JQeUTcaXcFJn+tQHt4IpPhWgOqUfAEiV9jFsUAVmp8sZf4xPSSrSbYBUXGOt7g6G7DSEuKR0xMdnaTaRZXYybHgxbOorKXoSMPqH4QuDhk8QQMdnLkQhHlHbDQ6XRQ==
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
 .../testing/selftests/mm/prctl_thp_disable.c  | 107 ++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index ef150180daf4..93cedaa59854 100644
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
@@ -170,4 +174,107 @@ TEST_F(prctl_thp_disable_completely, fork)
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
+	ASSERT_EQ(prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL), 0);
+	prctl_thp_disable_except_madvise_test(_metadata, self->pmdsize, variant->thp_policy);
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


