Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C30BACA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:46:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CB7F8E001F; Tue,  9 Sep 2025 22:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27BD78E0016; Tue,  9 Sep 2025 22:46:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A9D8E001F; Tue,  9 Sep 2025 22:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 007288E0016
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:46:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9854B5A37F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:46:38 +0000 (UTC)
X-FDA: 83871802476.29.B894A30
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id AC71920004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:46:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JqA4lX0G;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+2gv1wJrgJWMZIsaNiF6AyZaglC2W+vNxpLY5k+pOlY=;
	b=3QoNroGdo/ihLCph748wRi77Fe8MnN+DhgRnGS47qNFndibOG3qrZShvYCvdK5T9K923UN
	F12gGqbub5zPJpaOkX+Q4NElrTb8W/iqJ5UPUGJ6Lg6CnrdpPl+viUKrapUOe7WZ7rRT4T
	vYfXrbmgFS3w6bireVYAMOW41gHkO0s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JqA4lX0G;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472396; a=rsa-sha256;
	cv=none;
	b=PwAR5R3snNKUoTCHTcpQJXGpSAF0WV+DGAaglj1AVP/9Vhx2bLsBlafy83srBiFqfpSiSf
	cIANrZy6Ra0tggdbRTvaQ6D29bW5ZfaZkL8+kS+2SAKc6r/xMAvtqf7l/w2zqnVjZGE6B5
	9oR0/GbuMgvlZZwVnZg2TT1SLVloNZ4=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-329b76008c6so5229869a91.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472395; x=1758077195; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+2gv1wJrgJWMZIsaNiF6AyZaglC2W+vNxpLY5k+pOlY=;
        b=JqA4lX0GurBxRSnS9K/I1yncNWREWXeN5VhhmzRmrmybHGr1+XuFmlmDNnW4dvMyHR
         Dwj2j25PJjavbr5AxxuaGf3oeaGDh8NWGvegLNnmxLg5bhUeOrvQ3ORGbEZ1rmujkdz5
         C8LsSZ4K/FyjvIgKBO8W8Y/4jP9//b9wM1j7k0To1MdbxtFPecAwVjSKboVcYPkOaeSn
         gtyFVfdbAwNAgW35fHcB2jyCd6KsifAnXaubjlggGs8yIUI6b7L00UGcovZ6LvKwn8Sf
         Ql6kxp0TWdnBx/uC+OrslJMVpOqrXArDHCmKEE5z3gDxzaYIRmRbrLgJ80GpQhVPeEgr
         jbOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472395; x=1758077195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+2gv1wJrgJWMZIsaNiF6AyZaglC2W+vNxpLY5k+pOlY=;
        b=CduJkLdlRXuQZAv01k5YBRYCvd6J28KjkdVAJAry2ntR2L8nTvJarpPY5AWz/fyuqF
         +PMJc/3kvLFoXBkMB0fm2NwXrOC7GWvhwQvV6on1xnuexvAgVlh1vNP62+VFQgjPUIvF
         5wiRjTEMdhXX8scPLQhVur7qUWQUZ8vEltzII5X39vS4U0ffbCmbiOg+uEzpCC5mzQDy
         ZTEUu1KtXU9ycSJ8nSvbOcavXF3YK5LbdZh4/Wkd4YTORDKTdQbkTrKQ3jcLBKsmiONW
         2exyO1t7JlGKSyVRCARXuEJCc6GdObMX6Xq8TShlkrOHWZHOZJvnFtU6PxI20M5qbeYZ
         QGfA==
X-Forwarded-Encrypted: i=1; AJvYcCV8w0GZHA87C3fcgiF3S9gtIzlMDw/9z/bN2H3tZUwODHmSZwdGeiSGOAYryWTgZnuMhUY69LGdKg==@kvack.org
X-Gm-Message-State: AOJu0YyRl2imAV5kRmyrSaWD/nB/1VE9EP4LyGpB8H4V5w4EyrRElJQY
	RoIkcWhOl//rz4yyjyucMzM2tPsQOSBMKCGypum5I1f0m+ZYzZPgsL7D
X-Gm-Gg: ASbGncuIBKw43FZwv6AwrqomupBIQSZCs3Z6DnXkQPXZaICS7frF4zJGJuOYqNFB/Uh
	BQYIiHMPdxJ0XdVNRhorwRt/NJ7ywjt7Lw5W9c9s7pAgq0FxEsYaG8epCMt7oCE/WBzVEySLY6H
	g7FTrdjm2PrB0tAfQ5B/Mb7T+yAcbcQztBhvwd3TGmfndnUyXurG+U3sueIFEZE5a6x1JKZxOb1
	bEp/3m9WKnVSm/SNgrUjahWNNIVZ+RcxxF0mArUMp6Qm6EXlsiUpZGGdMB3+CKn0h3zIutgC2lS
	2/N2CAvnIrBc5HEVrqYWkVp/7NvI64/dATSigvgyobU6Nypwd1LQ/IU9IKsvSK5djg7Gn6nUH+Y
	mlBxSOEzKlOBtO8g2kh+5p1sssiofMZu9jAqyOQxEl9CFx9jE6yv7mrsNEn+bpKu02Krr0//ipF
	ofnF8=
X-Google-Smtp-Source: AGHT+IF7HoYJibvAsuo8aUN7uLmw94uj7XXz4N/ZsFYwAn1QFmBP+rxV+edO5IwAqpFP8zthp2dBaw==
X-Received: by 2002:a17:90a:e7c1:b0:32b:5f76:9e29 with SMTP id 98e67ed59e1d1-32d43f9a56dmr17489450a91.32.1757472395440;
        Tue, 09 Sep 2025 19:46:35 -0700 (PDT)
Received: from localhost.localdomain ([101.82.183.17])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dbb314bcesm635831a91.12.2025.09.09.19.46.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 09 Sep 2025 19:46:34 -0700 (PDT)
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
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v7 mm-new 09/10] selftests/bpf: add test cases for invalid thp_adjust usage
Date: Wed, 10 Sep 2025 10:44:46 +0800
Message-Id: <20250910024447.64788-10-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250910024447.64788-1-laoar.shao@gmail.com>
References: <20250910024447.64788-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xentd8agqi19sj4sf64mcrtkpoxiecq7
X-Rspam-User: 
X-Rspamd-Queue-Id: AC71920004
X-Rspamd-Server: rspam04
X-HE-Tag: 1757472396-904112
X-HE-Meta: U2FsdGVkX18wAeYsgv1Yf2d8kkC2vTjGGjw0+JE8bt4mDPwaTiu7U4mXavTx3MdZwftZ0/KoQf7jCjNx8ApQEPvyVMkpfEbNWWY1dz3DZ2gvCrf3zbYpetkI3AmZ8L3YZXYb7lug+ehChZwPTDI7D3zi/tj0JYtlP3AiswjQxZJUDrwqDhCJdqIWIqPnGqkhtgCRpTUFvaFq+nLkcptOH6Oaqcdr4FGuqcoo6dvHPc09HCUTPDlo15+fuIWvoTuBJH2DCDiWq19kYDlfdGEWH0NMN4uErFHv95UBZx3uMF+EUDpPUi57vz0uj03HrM2LIezFKgCKhy5m/0HuuYwZtMuA5v9xLKLnLMEDtARXU0ukZbv8Es+YlGtlQJPTuElv66RujpdKW3eLWnKc4Uc6KSbZ2nvxbaXlE5SUogDVO+G7jC94XJm3jy8Oe4NAyLyLJzj9Ut+orOG5hL0uReI1IdT+jPx3Cv1BtMZIcRmxh30R1WQXx3D3HxexGIiObYoJfm09FKevGc79a4Su3DcEjQx9FczyVQns/A5WDDVwMhpOvT+Tz8s+HBex3NYHM92tyx9X6Sf23EEr2XSBdetOptyVLwzsTntmMkvzSTTjvlxuS4tijozAm5pJ5vmvdqwn1ofAdOqzqjPs/MGZ00QLM/H05Ys93gQ88PVquYGah5VRsdrT7B6aZjA5BeQAMG8Zaa7Z/4Dah5U/CdpNlrk78DJluKnMRwEnQM1JFMFpeBQN0wA4OEmdfNxUPnTMBPSO9XNljTHOcvjGt/47qahl8u8BOS2Mho7JXB3FKrLG7LmyBaIX1yaKsW88TUsW29xufPKzDoztgBwZpt0h0C/I1DjuTaHoRW9FCQqZVFg5roBsIQrONXA49Rd9efrshltGTgVa4AnfI7xIdB8hYHG9RcCWucthVbVDQv0j5vODJs+8HSDXfKDedeLx7tjHJrSXmvRnjvAgLC3dK3dE73j
 eXUdmawC
 wTRmZOFGmXl9lDPABqfPyeB3QC/Fxz1nceUwswGJAEecwsg59OtMJxqFAR1GGwvy43nt78kiZD/k6/FwZ3XB4IeYd0Yt0bhH5cZZ2CtwyEo6CB2CRzAYNDJ4ms0K6Lvd9CXPt46FhVz5XX0XPxKdenzrmiQG3L5/VmrpfKgPZfkUwnxRisWcV5Q70fhxf7MDydQoaJ0yBHS5/bHah8YofCctXTzX7JfETr+A1WdmJNsIjQoYSzb+tUcZiVKc92fY1boFx+FqXFtS7A/bfgq1KP6YdGi59axV04EKfOfAOKZVQ1/qgvhU5aH9uLksnldBdm8rVPa9oV8XAGgpAaITtWAFjqmDsCkJ7ijtYCjxdWGkOWBguDhxOtM/0pPiH4q21J23WcnYwInFaO46R1DiXntzbOtrppBSp1a9ZRpBvGfdwzF0SCTzYi8lgwGHa25B47jZJqowC/b4UYXOKXNjGnSsqcOyZXOHemw3NijKX0fc5ydHgHT7F+98ZwSKb8osybmJBDx8XsZIVncpLvOP7xW9HoVLnmS1Lgd+2ve8tsz11X2SeIsEDPRUUqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

1. The trusted vma->vm_mm pointer can be null and must be checked before
   dereferencing.
2. The trusted mm->owner pointer can be null and must be checked before
   dereferencing.
3. Sleepable programs are prohibited because the call site operates under
   RCU protection.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../selftests/bpf/prog_tests/thp_adjust.c     |  7 +++++
 .../bpf/progs/test_thp_adjust_sleepable.c     | 22 ++++++++++++++
 .../bpf/progs/test_thp_adjust_trusted_owner.c | 30 +++++++++++++++++++
 .../bpf/progs/test_thp_adjust_trusted_vma.c   | 27 +++++++++++++++++
 4 files changed, 86 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_sleepable.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_trusted_owner.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_trusted_vma.c

diff --git a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
index 30172f2ee5d5..bbe1a82345ef 100644
--- a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -5,6 +5,9 @@
 #include <test_progs.h>
 #include "cgroup_helpers.h"
 #include "test_thp_adjust.skel.h"
+#include "test_thp_adjust_sleepable.skel.h"
+#include "test_thp_adjust_trusted_vma.skel.h"
+#include "test_thp_adjust_trusted_owner.skel.h"
 
 #define LEN (16 * 1024 * 1024) /* 16MB */
 #define THP_ENABLED_FILE "/sys/kernel/mm/transparent_hugepage/enabled"
@@ -274,4 +277,8 @@ void test_thp_adjust(void)
 		subtest_thp_policy_update();
 
 	thp_adjust_destroy();
+
+	RUN_TESTS(test_thp_adjust_trusted_vma);
+	RUN_TESTS(test_thp_adjust_trusted_owner);
+	RUN_TESTS(test_thp_adjust_sleepable);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust_sleepable.c b/tools/testing/selftests/bpf/progs/test_thp_adjust_sleepable.c
new file mode 100644
index 000000000000..9b92359f9789
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust_sleepable.c
@@ -0,0 +1,22 @@
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
+SEC("struct_ops.s/thp_get_order")
+__failure __msg("attach to unsupported member thp_get_order of struct bpf_thp_ops")
+int BPF_PROG(thp_sleepable, struct vm_area_struct *vma, enum bpf_thp_vma_type vma_type,
+	     enum tva_type tva_type, unsigned long orders)
+{
+	return -1;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops vma_ops = {
+	.thp_get_order = (void *)thp_sleepable,
+};
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust_trusted_owner.c b/tools/testing/selftests/bpf/progs/test_thp_adjust_trusted_owner.c
new file mode 100644
index 000000000000..b3f98c2a9b43
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust_trusted_owner.c
@@ -0,0 +1,30 @@
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
+SEC("struct_ops/thp_get_order")
+__failure __msg("R3 pointer arithmetic on rcu_ptr_or_null_ prohibited, null-check it first")
+int BPF_PROG(thp_trusted_owner, struct vm_area_struct *vma, enum bpf_thp_vma_type vma_type,
+	     enum tva_type tva_type, unsigned long orders)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct task_struct *p;
+
+	if (!mm)
+		return 0;
+
+	p = mm->owner;
+	bpf_printk("The task name is %s\n", p->comm);
+	return -1;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops vma_ops = {
+	.thp_get_order = (void *)thp_trusted_owner,
+};
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust_trusted_vma.c b/tools/testing/selftests/bpf/progs/test_thp_adjust_trusted_vma.c
new file mode 100644
index 000000000000..5ce100348714
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
+SEC("struct_ops/thp_get_order")
+__failure __msg("R1 invalid mem access 'trusted_ptr_or_null_'")
+int BPF_PROG(thp_trusted_vma, struct vm_area_struct *vma, enum bpf_thp_vma_type vma_type,
+	     enum tva_type tva_type, unsigned long orders)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct task_struct *p = mm->owner;
+
+	if (!p)
+		return 0;
+	return -1;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops vma_ops = {
+	.thp_get_order = (void *)thp_trusted_vma,
+};
-- 
2.47.3


