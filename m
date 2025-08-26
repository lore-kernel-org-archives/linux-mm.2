Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A6CBCA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52A4B8E00B1; Tue, 26 Aug 2025 03:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DB248E00A8; Tue, 26 Aug 2025 03:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0C68E00B1; Tue, 26 Aug 2025 03:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E22C8E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:21:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E030F14062F
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:21:19 +0000 (UTC)
X-FDA: 83818062678.26.6EA73C3
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0607710000E
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:21:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I2JMgTR7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756192878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNFSBCN6lqIthB1BT4X2pG6EGdMuodbSotRt2MhRMUc=;
	b=NF3ClqhZC48g/LLWxYyHOePOeT/8cA60oGOeBclNAod8EMycJiTyx9apgTgPjrYUe7KbvW
	mogzqctz5xnyeYbnu80rh9/oXh6npekqFOq+ZNxM34YBQTQ4lkQR+gqXA/cmGxtsKq/Ehk
	lINqzZuVlabiBlAXRNkxigT/YWSzD7g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I2JMgTR7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756192878; a=rsa-sha256;
	cv=none;
	b=m8386hrkk6i/yqNIHEkJbevZ1t6ZJHxj43ZBnVtGhMrew8Fd0MBPg9lEBcCCbvIGBpYxHX
	WGBmc12qxyL8VgDEsEJMVTUvgFiBYpYsCfOcSGMDpM/uS11OE7iI5QGjdAY2oUD+vxvo4S
	PRxeBbu6oOE3zDNJToyx8SEtg6o4f+c=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-771f3f89952so658731b3a.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756192877; x=1756797677; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yNFSBCN6lqIthB1BT4X2pG6EGdMuodbSotRt2MhRMUc=;
        b=I2JMgTR7xeDxjyf4Gy2RFFZpUPg7PYVrlyiVhbiZaWWqq3pvWyQXLIPRHWswuPkX6H
         HL4V2d9C3sVGtfi8V1fRb5oBkX7y6d9vtCt8vK9o1YurWvAo1dDGKJaxYF8M34xRtgb+
         5nKZNWBgwMXKUjQCelzAkPvUnz0WI15olgld05ZfmicJtte9taFIuBf4/hLOOyM6MxQY
         fMbTqeei+uetpBY1DqhyGY88A3WUnPSJsnBDOb0/TIvBYB0X0VSq7LcNE32vpRgd/rGr
         nF6qW+NXDtwQ/YH/l6yj3wqq704v7RlL4GFFKn8pg72daNuuDkTlG0AJNELGUIMbpUU8
         wh1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756192877; x=1756797677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yNFSBCN6lqIthB1BT4X2pG6EGdMuodbSotRt2MhRMUc=;
        b=iquEQ5K/r7PlYRoNPhu1FV4cxtapxn9c0siy5MpYWIAEJOodoeZnqkyY7uGga4PRGa
         U4CkFQbo/kv1DWyE65GIrXxFPTUQTc1lyKmWVch1wFdRQ3DngofElnPPfL9AMzNaMAlE
         8N+dfoofMcrcWhNlXl7k5+BYY04x9DKu5MhGoi3wAhvvPQlAVqKxu00bGz2cPHFJmAAz
         81incaKpl3Bzw1dmckmx8NhDqkFvXbXHCLMcUCNsJP6K/aEUbeOTYpULCWk+SCJNzt2f
         WTx71bbYvrQFsLM2N/QoECte5/7mLyTqOgAvQfnGig+zUfaHhilCpPFbAWfNKt74NJh9
         8VnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRR/9y4EuVHSw4WIKvgesK4ll4lOM0YqpdMxWN5wC6z3E2PkbITWJGxRl3tTd3v781sJUstbhBjg==@kvack.org
X-Gm-Message-State: AOJu0Yw6Uakl+vYkM4nJU502sPqzhmG39SWOT67BBgyvSe6nz8p5Nn8c
	jNhtsoiOJotukGOMxltlFgiyd9STZCIz+K/bjuSxROWk3K0b9VNhokVJ
X-Gm-Gg: ASbGnctqJH0lzVwJICPs7d0zy1QAgoUb0m6M+2GauranH0SD5z/Q9P55Q2cboXaQuPQ
	pYek7gZMEet0mhiamQI8MRwv69iMatsTsVhxih2lG8gSCnZT+ZCDNIuSdBzp3ifkPdJWrHj4fJB
	A+/iH8BdZqjYoO/dOx7R8jWkwqRUxCbe6uKjNTq/S+Pgp86SAOgQmQ+HcELzRSa9bvvMCv7Vluz
	9ekV6nOIrxzZ/r75SVAbaqrFtdaGBf66AeCXu1V+dzkiWtSJuohfr4AU1Id2T21dtXII7dITp3v
	vyj2vglRbYjyjK/9Z0N4FgGe6BzXNU2Ie2UGH3gXQ+n7RiyOMnrEL+WTp89ikMgUZk/8O9SxvVO
	zs+3tmBVDt0VF67iFMRNT5bfzgJUVyitfWGSEpgxYzwUHwCPqxF7Mk8y/f0VjWGOYflcSrphYqD
	Q/0F38FDLTpxX1MAd0pbhmersI
X-Google-Smtp-Source: AGHT+IHAlItJ4D9z1T4pSNCT/Cf5usyVIQcZ0V+oVX5SZibP+hWnTdYG9tcFTQj+hZZZU5jqvd6JwQ==
X-Received: by 2002:a05:6a00:3392:b0:76e:277c:32f7 with SMTP id d2e1a72fcca58-771fc293b43mr688451b3a.9.1756192876804;
        Tue, 26 Aug 2025 00:21:16 -0700 (PDT)
Received: from localhost.localdomain ([101.82.213.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401ecc51sm9686052b3a.75.2025.08.26.00.21.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 26 Aug 2025 00:21:16 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v6 mm-new 06/10] selftests/bpf: add test case for khugepaged fork
Date: Tue, 26 Aug 2025 15:19:44 +0800
Message-Id: <20250826071948.2618-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250826071948.2618-1-laoar.shao@gmail.com>
References: <20250826071948.2618-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0607710000E
X-Stat-Signature: dgd19r8199exjfjy1b81cbtjfsozshz8
X-Rspam-User: 
X-HE-Tag: 1756192877-849694
X-HE-Meta: U2FsdGVkX1/prbBb4ok726SHG3H+n6nUfv4jumDyJ8nFHJWuBX00Z/kb6nRGjY72wFfsxm0w7TvOsopAk9Drd+r3jiBVocYbLlMXz+alBL7hI8EjqmHVmi8eadDPpg64lyHkzt0c0Bdv0ndFOC7pZyrt51zUSGjqdrn2Bs3N5+quMfxlU6nVQ/ytXi/N1XyfWKR8FADqPt1x8G8ueEf+byifIFT19oFl99/zHGIOzR2cOUgm3vJEW7DbJDt4BONT85zFDTOuZ/9shgjP9rQpKX+3JVhLvF7swlbBKapWPIzkJxtsMYhh67dbVFy4yv7VPTtRHWOojhMuVSIES4IoL+xnhQekW67pK63yWvfTH5ThcAMeISMRk2k6QorhESVykLX76jRDTAyAL2VUjL7tLrZyK303Ybm8ZZ0ewizr3BgC2HgGhLClB1UYVWngh2g5YAWdJolc92yXwfIlpMSmAiPrfCjLJJfgOjsgaeJXj1mz7060ALMznflMB6u+iXrAeEBNQoKDYTRME5qAqGeRbJdDxwtA1o6Mde26cVNuBHxPzQaWt5G6xQEUuescCk+uFR/wXh+N1IL3q9nMA89RgoSjE9sZbR9xlcNVnA292O21DxppbQJ/4Op+TFgvdnQ1dnL3TFkp91LcLoJGPLbO42snUZ9dPnphI2jAd9WJnTRmQHbi7Y3gHh9pCaOvgyiFSsuDfP728mXKjeK/oIML+hfwuGlq0YVSnBdt09T/NDEGbGCDrs6eG+SK+x9vYBuWKBsevzwVk1eqXSxSp2xDBrfEm5QtO4YaaSTNXiLZB/iVHXDE1TRZX+eDZSlctigTipe4PXk44LNXbav3FgPXVQA1CiPO1l6yqT7DznsmVz0jNo1742aEtqvxoxHUJIXfvqGDzmkosjvarZ5tfwpV2UijIP1h0enIFk2696GC8SwdS4bBuWgf/LmLOtMy9wlVwBORKcVG1/+TGfAztf9
 6Fp1iGaY
 TvrEmht0QI0Cac884ockl2a4APq7qerBrV1ytrsWqktK26cWBHHHcn0K+OI/A+N1qbEf6gm0vlqhEQyFh8bnHoGUh4conokQqAQKqDX/l6ayhDRWOvUivKa74HBr1uHk1x3vkseEghXNwGZAgTzICiJnCnRCEUpYZipqtXmo0s8ENAJg3lAbUz3EdnZAnfh3snOgx92vsm2wYDKIIwNJkS8x3AnXnuCazghmsyejR0MUPTVxzgkPZ7eqSL/x7nFwsPjyfer2USBx4M24AfkhAs0O+6UpfkzVsMOv4L01YxDnWRjp+vKrFwoBlnw+R6xVij+WuRzCdI4pjUUtA1FzQhpciwuqw5vmwxuWF6Xfflcl2+OAbzaHWQndwuPheXdvURX6UJtoduiT16iW7o1UcjZ3kWBj942Yb9qOCwPK1Dn02Lf9nxor4wTDhggjdfEfl4uJATeNyqrq8nG8vp3JBBLoJj3yTBrwMKSJTohAGQ55nCRdAaDyX/EW1u0s8S19fTYfEkQ3m9CE+3eY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In this test case, the parent is allowed to alloc THP, but the child
forked by it can't alloc THP.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../selftests/bpf/prog_tests/thp_adjust.c     | 59 +++++++++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     | 39 ++++++++++++
 2 files changed, 98 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
index a4a34ee28301..bf367c6e6f52 100644
--- a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -1,5 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#define _GNU_SOURCE
+#include <sched.h>
+#include <sys/wait.h>
+#include <sys/syscall.h>
+#include <linux/sched.h>
+
 #include <math.h>
 #include <sys/mman.h>
 #include <test_progs.h>
@@ -170,6 +176,57 @@ static void subtest_thp_policy(void)
 	bpf_link__destroy(ops_link);
 }
 
+/*
+ * In this test case, we clone the child process directly into the root cgroup.
+ * Consequently, the child process is not permitted to alloc THP.
+ */
+static void subtest_thp_fork(void)
+{
+	struct clone_args args = {
+		.flags = CLONE_INTO_CGROUP,
+		.exit_signal = SIGCHLD,
+	};
+	struct bpf_link *ops_link;
+	int status, err;
+	pid_t pid;
+
+	skel->bss->ppid = getpid();
+	if (!ASSERT_GT(skel->bss->ppid, 0, "getpid"))
+		return;
+	args.cgroup = get_root_cgroup();
+	if (!ASSERT_GE(args.cgroup, 0, "get_root_cgrp_fd"))
+		return;
+
+	ops_link = bpf_map__attach_struct_ops(skel->maps.thp_fork_ops);
+	if (!ASSERT_OK_PTR(ops_link, "attach struct_ops"))
+		return;
+
+	pid = syscall(__NR_clone3, &args, sizeof(args));
+	if (!ASSERT_GE(pid, 0, "clone3"))
+		goto detach_ops;
+
+	if (pid == 0) {
+		/* child */
+		if (!ASSERT_NEQ(thp_alloc(), -1, "THP alloc"))
+			exit(EXIT_FAILURE);
+		thp_free();
+		exit(EXIT_SUCCESS);
+	}
+
+	err = waitpid(pid, &status, 0);
+	if (!ASSERT_EQ(err, pid, "waitpid"))
+		goto detach_ops;
+	ASSERT_EQ(skel->bss->fork_fail, 0, "fork_fail");
+	ASSERT_GT(skel->bss->fork_succeed, 0, "fork_succeed");
+
+	if (!ASSERT_NEQ(thp_alloc(), -1, "THP alloc"))
+		goto detach_ops;
+	thp_free();
+	ASSERT_GT(skel->bss->parent_succeed, 0, "parent_succeed");
+detach_ops:
+	bpf_link__destroy(ops_link);
+}
+
 static int thp_adjust_setup(void)
 {
 	int err, cgrp_fd, cgrp_id, pmd_order;
@@ -249,6 +306,8 @@ void test_thp_adjust(void)
 
 	if (test__start_subtest("alloc_in_khugepaged"))
 		subtest_thp_policy();
+	if (test__start_subtest("khugepaged_fork"))
+		subtest_thp_fork();
 
 	thp_adjust_destroy();
 }
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust.c b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
index 635915f31786..034086ce2f3d 100644
--- a/tools/testing/selftests/bpf/progs/test_thp_adjust.c
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
@@ -6,6 +6,7 @@
 
 char _license[] SEC("license") = "GPL";
 
+int ppid, fork_fail, fork_succeed, parent_succeed;
 int pf_alloc, pf_disallow, khugepaged_disallow;
 struct mm_struct *target_mm;
 int pmd_order, cgrp_id;
@@ -74,3 +75,41 @@ SEC(".struct_ops.link")
 struct bpf_thp_ops khugepaged_ops = {
 	.get_suggested_order = (void *)alloc_in_khugepaged,
 };
+
+
+SEC("struct_ops/get_suggested_order")
+int BPF_PROG(thp_fork_test, struct mm_struct *mm, struct vm_area_struct *vma__nullable,
+	     u64 vma_flags, enum tva_type tva_flags, int orders)
+{
+	struct task_struct *p = bpf_get_current_task_btf();
+	struct mem_cgroup *memcg;
+	int suggested_orders = 0;
+
+	/* Only works when CONFIG_MEMCG is enabled. */
+	memcg = bpf_mm_get_mem_cgroup(mm);
+	if (!memcg)
+		return 0;
+
+	/* The tasks under this specific cgroup are allowed to alloc THP */
+	if (memcg->css.cgroup->kn->id == cgrp_id)
+		suggested_orders = orders;
+
+	if (p->parent->pid == ppid) {
+		/* The child is forked into root cgrp, so it can't alloc THP */
+		if (suggested_orders)
+			fork_fail++;
+		else
+			fork_succeed++;
+	} else if (p->pid == ppid) {
+		/* The parent can alloc THP */
+		if (suggested_orders)
+			parent_succeed++;
+	}
+	bpf_put_mem_cgroup(memcg);
+	return suggested_orders;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops thp_fork_ops = {
+	.get_suggested_order = (void *)thp_fork_test,
+};
-- 
2.47.3


