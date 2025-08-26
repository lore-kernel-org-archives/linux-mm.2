Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9712BCA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E52BD8E00B3; Tue, 26 Aug 2025 03:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E03AC8E00A8; Tue, 26 Aug 2025 03:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D19438E00B3; Tue, 26 Aug 2025 03:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C13EE8E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:21:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 51ECF118AB4
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:21:41 +0000 (UTC)
X-FDA: 83818063602.07.2ECDE91
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 78619180002
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:21:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Y2/HApZh";
	spf=pass (imf24.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756192899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bz96bAWfKvUeaQwW9qQof1i2mU24aQ5U0XcdPEkrqrU=;
	b=qHRi3iBVVy9J8oxX1uhRFwmhtI1d9xUfKO3zC30uqXSPuozAefykeNYVfJPFo1AKgnkGv/
	qNZ1gA+aj/Ydb/Aq4OnqJrZmN/Rv++Si6//046z6Gp39GWl2T3om4KyyJUo8C4iqt599w9
	Tv3WCB8uPn0+XhCVJ0e4I821+Uqvg/U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756192899; a=rsa-sha256;
	cv=none;
	b=150GePSt49LWDqsJAHqrfK95DhFKCd/NwhGI7CQ4UBlSlN4Ee05dm3lIiP01XFK6sTLiKM
	PLyJ3re7JF2DO0VPXcpvbxvxk/DTQyvlYgqZmAwEt0dysMnrEzzL4b0KsONFB7wc4jPq19
	hInvz9WywR9i5Mg/0erx1Y8JBUncZGk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Y2/HApZh";
	spf=pass (imf24.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-76e2e88c6a6so4599064b3a.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756192898; x=1756797698; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bz96bAWfKvUeaQwW9qQof1i2mU24aQ5U0XcdPEkrqrU=;
        b=Y2/HApZheZ8spqI4CQTzqb3w6yHvkYvO2bA+tmLoinUQz8EpcTudsyfklSuAU8IG9S
         1nZ6JccqGDKTzToHoJmWvMQJTJ2dGdd8rupEyOQpAkxQcqkOwICdNiQecOXT4tI5YOU1
         g6ej+xQjSe0cCezV2DKWc7Na8AoOFJf+Fnm8jdjPaECQrYn4fj0J/6fXiLAtshErPGrF
         tq4jkliSmgXlomcfHPVPhtJvXrsAhg6FqWyayS4ln0/MYvVIgy33Rpk1+7Ag6Fltp/7q
         47MZH7Yet2aVIsVppm1iScxxi9igTt9F0YY4pcK2p8d/wyEkpBAKR3vZqq0g4nmHyx08
         gqAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756192898; x=1756797698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bz96bAWfKvUeaQwW9qQof1i2mU24aQ5U0XcdPEkrqrU=;
        b=a324SMIjerercOzwsiJMIGzDJRdUbTC6zknvpWnySOD1RnjfZzXi5tJPZsFVT/zdTc
         H7zr1wf+4KRC2qja3PlGH0uFqEaygNNi4X93BujSZ5ObgrMTkfKDhY2y0ddeJ+fnkSED
         n+NuGtGCmtIMHMw8pY/7xE9a43yVP8d1dajQhyd22ExZaq+sttw8DCaRyj93INxNA/Le
         6fLuCBRrLMx92BXXFxPZ5bumSycVOL0qpNQ0yWXBgArrN/Dvs7y09WAlEZ6rK3PZ4AqB
         aSQR9HGmEoztqffY2kDe5aqNJCpOrl6XA42ZTDxoJGa3KdbUNtlJDUq088u9f5GPUk75
         knjw==
X-Forwarded-Encrypted: i=1; AJvYcCWnUb0WegMxz0I87NqvCaastzyaA7MKBbbQM924vcdmO6evck9CI30moYeNDe/gn9glf/3oaf7j7A==@kvack.org
X-Gm-Message-State: AOJu0Yy/P2RZkFxiesQiJ2kjPiLepXjx/N86rDocccHyqXswK+jw/nxB
	qs240Tx7fhGXturPbVMOdceoqU/ROALUn9r1iPTfGDaXIGoVYRL+x8JG
X-Gm-Gg: ASbGncvzzcHw36Nwo+Cxa/VdS08KoNIAb7oxTOowJ+Kn4T7GJqUY4rNtHHN8hk7qsXT
	jq8pjd1aJhBPdhN5hdixDGWqQA0Iw3lGmb4AZdluBxujxr55FK+uiUVI+g2LIUVjN7u+jXzYq9U
	H2TsQxuLLKNNcjLWbts1cdXAPrfeF18uwavWoPYt/CopimnNXykjHu4K+wzP9KGnRD4/HHf/bhE
	Y+2ASZ18Gkln1kliOCiDT5LPVynY5dqjYKUgzRC+ZnLv4nJgGoIN1j6hiaGkHP0meyvFGHreMW+
	AxsmyOoBTDL00G2TyZ7P8brCXjOU0CnM+D4dH1teHOqFHgba83BRBT5o5qw0n7xRFVStMw/ld11
	AZq1GbJbrE/JaRh0yn6UWwwqlBo8EC8Db038vX075jwdhdv0A7uPQcPc+9aP3YoirW/x3NT8nVg
	+AMZoKWKiFWb1JIA==
X-Google-Smtp-Source: AGHT+IHYvLUPX3UVhLFe8oerWPn+sp10WcjZPcf8Lvgh+d7IM89u6xbawEntdDvzZ3ZPexMDp+HCUw==
X-Received: by 2002:a05:6a00:4189:b0:771:e2f7:5a12 with SMTP id d2e1a72fcca58-771e2f75d15mr9184474b3a.6.1756192898165;
        Tue, 26 Aug 2025 00:21:38 -0700 (PDT)
Received: from localhost.localdomain ([101.82.213.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401ecc51sm9686052b3a.75.2025.08.26.00.21.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 26 Aug 2025 00:21:37 -0700 (PDT)
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
Subject: [PATCH v6 mm-new 08/10] selftests/bpf: add test cases for invalid thp_adjust usage
Date: Tue, 26 Aug 2025 15:19:46 +0800
Message-Id: <20250826071948.2618-9-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250826071948.2618-1-laoar.shao@gmail.com>
References: <20250826071948.2618-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 78619180002
X-Stat-Signature: iifqye6fzbsnfpseh7mrnew4fwjhz5q6
X-Rspam-User: 
X-HE-Tag: 1756192899-29953
X-HE-Meta: U2FsdGVkX19W40OONAL+3iavzFnA+aW/ZcAHoymK3WcRv0nMZzdyz/vXTa8p2lAlo56cUculdI91xhimmzQtcGow/CWGLv7DRmqJgyatW5m8vQupZw+Jg0ouaV2xExN7LN8vx5WHnJj1C5f9mNjBDtj4aLEx+r5ePAEXf6JUhgO06+XMPQXr8QP0PlH478KXmuw/akPvQ3aXsgO6yigflmR/l3LggsTAloB/HIUTQqGKyI0+cAZI2uMz2Q8DrNZ0jlNJ6I67MYW7E4zyvBDYz97/J/Rh8nVx1PTTTqVM3WJNfRTmlcXgu8Ow5Ua9EDpifCBTcJo8BU2kIN1rAfvv/uNfQABvQrpk4txkAaPMwiusKMhMIUimqLvjeaCbUCGnriLZfdWQYcER5HnP8FMaO80GWnUNPRkyG8wtSsGODYVDkju/fPoR4I6fG24fF2FdzX1c/6B6E+anOInzf6dkWaSpir4ebSPlrwLQFQQrNhn62EjbAMNYvTIkXCymljb7HfI7gzj7H/4Zb8/4Fy3nCg/j15oEQJcvb7U1sfJkyIdn5fxATrLGyXv/q6cgnNmlDa6Y+CGejb//qO9FLngNrKErhE5kiey0eOqon6fKY8MsNDdX+cmt9NY+hXI7wI9MIwSS/TjPgNikWe5UuFuw1NX+/kYm1ncj7w7Ew0FO0ImstImKDVZngOQauRQtMaKWcTr+2Cwt2CyLuVQBmQeriuf8d0Jj5rp0VQjEA1QjJn6gGFs5HnLS9yjxm9TwX2wzVfpaNMjMl450FX4QB6HRxEItM3Chpv7swnuiMDDpo5o2CBhZZ+JWe84kY3M2TyGBzkgM7QvFwLe7lGKKlGHg4SBBvUIIphrE7cKRTMiMp+30feoRtdZ1Vr3XYJ9cYqOMPIhpQBPdvd9zbGfUPRxkuM2eh78fPznr55eB+1S6QsTIArez4A/6du2WObpTUBBSCapVVD3r7UYWQ/YjMdN
 UheUpDws
 QU6oruseDYXIBdHpWub7BkQwOIYae3jcFOuIWmvBdgY26Lb7E060sRm+HgDaSQpm+WDeL272UNsAyZruhfFxi9cSLm7ThrnawcMfiPS/l/3XelyTFG8km5uT0lBkAXCFnvlk1nN3CVJEsGwqoFDCn8fgE7SbWWqAH77TvmisIrTb0uu8YeZ9xT3TJ2xw4uMPpQ6PuB+qU3/VQxKpCRmeAVdwbV1AiIQ3c8qvPxO4wp7HBHaVakQEoEQJLq1jwC/heVb6aLNhqb8MMJ06Z0/+QvyjItN0dINCuetNlfWN1KiR02A5mAGmR31VICJQLDai7UBAzmoWHrfVX9ABhC0LhsIFscdC2DfFbPMyTnpGxbyJTZVXeYmy9OYeY8gC1klQa6kcQUiiuzzHwMIkjX+mjTfwYEeRdKMWtxoFOrwMrsWi1LOi5a0QxVTNU5gM/jU0Db7SKfGTJiB2xjSEbLkGxJ3Vqg6NmeHnlcxEzd0Mh2fprBY4Gf391jExLhtFRhvC9iZitNNUEIrEKTG6NE1pW1LIRWCyH18ZQ5iLg7yba7zxOiVlo2T8JlmESIL3Z0bm7JHUm9P+HSX7MluGa6Weixp+3vCfuSytyCwj2GorJDuOcq1ABDKH/lt26rdifV4/k9sYT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

1. The trusted VMA pointer can be null and must be checked before
   dereferencing.
2. Resources acquired via bpf_mm_get_task() must be released with
   bpf_task_release().
3. Memory groups obtained through bpf_mm_get_mem_cgroup() must be released
   using bpf_put_mem_cgroup().

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../selftests/bpf/prog_tests/thp_adjust.c     |  7 +++++
 .../bpf/progs/test_thp_adjust_trusted_vma.c   | 27 +++++++++++++++++++
 .../progs/test_thp_adjust_unreleased_memcg.c  | 24 +++++++++++++++++
 .../progs/test_thp_adjust_unreleased_task.c   | 25 +++++++++++++++++
 4 files changed, 83 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_trusted_vma.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_unreleased_memcg.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_unreleased_task.c

diff --git a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
index 6e65d7b0eb80..846679acaff2 100644
--- a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -11,6 +11,9 @@
 #include <test_progs.h>
 #include "cgroup_helpers.h"
 #include "test_thp_adjust.skel.h"
+#include "test_thp_adjust_trusted_vma.skel.h"
+#include "test_thp_adjust_unreleased_task.skel.h"
+#include "test_thp_adjust_unreleased_memcg.skel.h"
 
 #define LEN (16 * 1024 * 1024) /* 16MB */
 #define THP_ENABLED_FILE "/sys/kernel/mm/transparent_hugepage/enabled"
@@ -333,4 +336,8 @@ void test_thp_adjust(void)
 		subtest_thp_policy_update();
 
 	thp_adjust_destroy();
+
+	RUN_TESTS(test_thp_adjust_trusted_vma);
+	RUN_TESTS(test_thp_adjust_unreleased_task);
+	RUN_TESTS(test_thp_adjust_unreleased_memcg);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust_trusted_vma.c b/tools/testing/selftests/bpf/progs/test_thp_adjust_trusted_vma.c
new file mode 100644
index 000000000000..caa73bebefcf
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust_trusted_vma.c
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+#include "bpf_misc.h"
+
+char _license[] SEC("license") = "GPL";
+
+SEC("struct_ops/get_suggested_order")
+__failure __msg("R1 invalid mem access 'trusted_ptr_or_null_'")
+int BPF_PROG(thp_trusted_vma, struct mm_struct *mm, struct vm_area_struct *vma__nullable,
+	     u64 vma_flags, u64 tva_flags, int orders)
+{
+	struct mem_cgroup *memcg = bpf_mm_get_mem_cgroup(vma__nullable->vm_mm);
+
+	if (!memcg)
+		return 0;
+
+	bpf_put_mem_cgroup(memcg);
+	return 1;
+}
+SEC(".struct_ops.link")
+struct bpf_thp_ops thp_memcg_ops = {
+	.get_suggested_order = (void *)thp_trusted_vma,
+};
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust_unreleased_memcg.c b/tools/testing/selftests/bpf/progs/test_thp_adjust_unreleased_memcg.c
new file mode 100644
index 000000000000..467befebb35f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust_unreleased_memcg.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+#include "bpf_misc.h"
+
+char _license[] SEC("license") = "GPL";
+
+SEC("struct_ops/get_suggested_order")
+__failure __msg("Unreleased reference")
+int BPF_PROG(thp_unreleased_memcg, struct mm_struct *mm, struct vm_area_struct *vma__nullable,
+	     u64 vma_flags, u64 tva_flags, int orders)
+{
+	struct mem_cgroup *memcg = bpf_mm_get_mem_cgroup(mm);
+
+	/* The memcg should be released with bpf_put_mem_cgroup() */
+	return memcg ? 0 : 1;
+}
+SEC(".struct_ops.link")
+struct bpf_thp_ops thp_memcg_ops = {
+	.get_suggested_order = (void *)thp_unreleased_memcg,
+};
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust_unreleased_task.c b/tools/testing/selftests/bpf/progs/test_thp_adjust_unreleased_task.c
new file mode 100644
index 000000000000..50d756810412
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust_unreleased_task.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+#include "bpf_misc.h"
+
+char _license[] SEC("license") = "GPL";
+
+SEC("struct_ops/get_suggested_order")
+__failure __msg("Unreleased reference")
+int BPF_PROG(thp_unreleased_task, struct mm_struct *mm, struct vm_area_struct *vma__nullable,
+	     u64 vma_flags, u64 tva_flags, int orders)
+{
+	struct task_struct *p = bpf_mm_get_task(mm);
+
+	/* The task should be released with bpf_task_release() */
+	return p ? 0 : 1;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops thp_task_ops = {
+	.get_suggested_order = (void *)thp_unreleased_task,
+};
-- 
2.47.3


