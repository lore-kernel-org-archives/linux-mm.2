Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6B51CAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368A88E0015; Fri, 26 Sep 2025 05:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318C88E0001; Fri, 26 Sep 2025 05:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0E38E0015; Fri, 26 Sep 2025 05:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 030D08E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:35:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B59CB13B8C5
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:35:20 +0000 (UTC)
X-FDA: 83930893200.16.8A64354
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id BBD1C4000D
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:35:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iRAApHhH;
	spf=pass (imf01.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758879318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjEsZ2zZ0gswTTfZGuAqtKyUugB4UMlIc5tO04MQRtQ=;
	b=thWhdAmGhSLNCwxN8FhbVt3wxN17MZNopevsG8FkrrA8wRsm+li7L9n3bxRsrYnDec2XbG
	C3MeY3KqUXbqkrCGpwq/MUXY6qgRfL861pUnLCSen0Ha/cCtZ3BhD/Sgl14U6uSAPn//+Z
	fEV90kOlVCmxvjn62kmH7Wav0ly/sxY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758879318; a=rsa-sha256;
	cv=none;
	b=wKljD+pOi3fI0zZYqq95bXGMj63t18QsnCmIH899XELfBe0yWwbBqdn8a5dViNhW+sb880
	uA4xrM0xep9xLVHoo+5ge6N52xpxUDxlH8mijlD6HE68zHXvyBIdHhTPCwveHA12hoXVrL
	vvthA8UTTVL1hfqtNTE4a/1NAsTfgYM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iRAApHhH;
	spf=pass (imf01.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-27ee41e0798so16181015ad.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758879317; x=1759484117; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GjEsZ2zZ0gswTTfZGuAqtKyUugB4UMlIc5tO04MQRtQ=;
        b=iRAApHhHPqODI8QH8PD08/UqGQahMK7r7vJ3PGk0+PiGhpXSE6WQyr4cgcoe90veHk
         GYcG2nBonC6yiAjUop114jWS4fB40av8H7iOFbnesfOS/wpBX68xiGALDa2X3/r62/jD
         h9P0ms5byhS/Srq//Lm/5TT4A+uD3aT5Iv8zA6CK77BjyyjkYjseLE4YmUaTJd434Q8U
         Jhb+KZNgYCvV9YFQBQMxUTv05UQvGIh/l0j4m+zXjKgqjmLyCVZCPK+nyafK1RUN1/GW
         y2yKIBE/Kw2k0/yuM/3/41QVSQrBtAlOUHuwplEvP3Pjf9CGlUKdwjavqQUw6ZwmudmG
         2l1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758879317; x=1759484117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GjEsZ2zZ0gswTTfZGuAqtKyUugB4UMlIc5tO04MQRtQ=;
        b=w4qi4SthftDPuuDfSwGko/R3RM+mgJLTbDmWxhlFB4zTUn+nfTJ/tOyzxBUhlHCVBz
         afOZz6ACBGKmuo0WJyVr8yrNpq1En1920ViiiR6VsDSu4unF/ngOO6n2sJZ4bfA2ITD4
         Sr3SpDoOoz/qJv0Q/Z0HFKP0X7QeeOQKk5FaPahRkNyC+a5lhEsI8byeEBNqE1LNpF17
         j9vDZFEJczx2ZTh6+tPh8jocYc/+YjDTfC2DbAs8HXUTx/vIT33wlEC8buG+dIOasr6n
         OEYr48Ob2qnKBhBcmQvEYxQfDLvDoxOIylO5gIKBmTGl4oepWG+98Ljf6HJ1pmCyHnv/
         xKOw==
X-Forwarded-Encrypted: i=1; AJvYcCXiJZo2JV8CXcjKrWsz+LNZFLTisw4WHioiUQAAEr/h3fF2IHPDUb2cCmllNH8w4UV20+Je2KF+vA==@kvack.org
X-Gm-Message-State: AOJu0Yw4DCEP63chEd9eVqTkoHiUeqJgzdi6k0GxbFp5bVvcOwBC17Sz
	H4ZtSSJinZ3bY0pi9sgSktAYTScA5OxlEvoBC1VJ8Jt67PC2wrJUQWe1
X-Gm-Gg: ASbGncvB1e9hz08/crzImOwyE+3H7ZvOX9l7yjEUrGHY2zym+3auOdC61DfVNVEWlj/
	vILuszuVjAmJfwnKXJOZezUc5rFVLbP6WMjl3Hu7xYylIawkYf+YTygwVfkGdZgifrAzy7WxRQw
	wMcVlw7E3lJDnckaOmwgPDJ2SwMnFvuVc66c59I9ExJ3qlBeW+lyQ2+IRy5A3o3tDrSxynmzDEa
	vDj6G9l23a60oxcKxML4yjsdumgXVMF/RzZz3Ken8HWykIzO9vha0VnYO8olKJn9iDm1ZsfmPbZ
	bZkiTbP4aS0rqYKXxt02EfxFTSPNBRVfaFF1nYFYFRZj+YIXYZ3t/Xj56prDGv/lQ/1Y4wJCilC
	T9Qx7eznx72cmFVAA1Z6uffs9iqEaaXzLRGxZT4ExDCuGVQDhKTJF5IP4AZ5qJb8SF698Qj7Eb9
	PNUonQ/xqH/t2B
X-Google-Smtp-Source: AGHT+IGyv8obkrIygTqJyqvVbel1FZKkyg7zW+CRqiZxE8ebTcWIuicJPPFReDEq4JzQ2A2SZCWUTg==
X-Received: by 2002:a17:903:2847:b0:269:4741:6d33 with SMTP id d9443c01a7336-27ed49d2c35mr46947235ad.23.1758879317548;
        Fri, 26 Sep 2025 02:35:17 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1c21:566:e1d1:c082:790c:7be6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cda43sm49247475ad.25.2025.09.26.02.35.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Sep 2025 02:35:17 -0700 (PDT)
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
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v8 mm-new 11/12] selftests/bpf: add test cases for invalid thp_adjust usage
Date: Fri, 26 Sep 2025 17:33:42 +0800
Message-Id: <20250926093343.1000-12-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250926093343.1000-1-laoar.shao@gmail.com>
References: <20250926093343.1000-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BBD1C4000D
X-Stat-Signature: 9aocw3h64nha5jp497zp15ngqzrnk44p
X-Rspam-User: 
X-HE-Tag: 1758879318-317723
X-HE-Meta: U2FsdGVkX19Z2XCzmWpCNT6nUHOY+NaYIfPd58VzTCCKrRh+tXLuO3cjIzxCtpR7001m3NN1bcg4I6Hal35KIde5/AWfVff0B8zDdxF8D16+YqOgKOCvoCvoXAaanV8vQGExzp/dm46lybXI9fHLC+BBuXNI6YDGetvgkcatufW9Ezc8XyBqTj/AlzRsVfmLkGCrJcpdQY/3cw5zONnBtQHuOn9j3o04Lcq7jVkdDVtQO0G2+Y24ANttHRp5pD8WR51d5YCCq/GDu4XnF1mPh+35ZhRKd0kwnYdbibL4Tuyb045JpWwvf1sOvqyRImTlyK4lr0oVQAS8yodNQbzXD4zfB/imNsZjxKBwBZG2yJxpBsQXdRLCm59PTgtvVgyQrhqDiV6HBMpf0UhVT98Ow/aFpM/FtROdGdji4QPGVDI/0vS8/LUmSh011sACdocAqaTI+Af1uY+SbAKGb4Zq8Ymlj7db0G1m1EGxj35sOR7w6sspsn1UwhCWgv5eRDkfpuGBtkD4fpXpr5Uy6OsYD12F6z9PDtZKEHqodV4wLkfNDopXwlSrC8LdFFgW+fiTeu/mqC1ri/0gHMv8gHgnM0zy4Agp2349tRvdC0vlrBnjw0cfDsAbXhKRASdykmcwMdyw6oBUV4Guq/8wKvOvRJlfCOCt9FN7C0UrJzHmqZj+vB5DA3ImlA9my8GGkfrr3iZhFgGLORNCujuYRaKnOX8iXUrG3oMibK6XGEshL9E43Znm97NXSZaKJsCEsDTt2Em/Z2ndts/rQ5BRxs/9zoFPAVLGXj8B6IIErb5fQiyJvulNXcz4F10ix8HycLVfnp9ua1DGR6P2nOKNOG4wFiCT/YzYwvxv5DLhMmJhx69d/PMWBSJBnFAMS1hI1Iehzt9I9ZCM/xhWQxqCXiuG8d3Gg5RiuujC2NIi+/cdS2JQ5iNAo8SCt/eonitCW8JS9nIKI1L/CQYHvqcCdQm
 +HXAkXaW
 +oKnxaP8GojtxQObV7EyO6Tjl1U6/pwSzzrOWK0x4EB9dk4ipRowhcqys6AIipZfXdVK90YH6YyXqCKBfxw5uiOTMh8s6l/XixD/iiBX+09OO3k2KRQKYWjzvZg1n+DtWfZLQz2Qdq5WaixCJoeGgVqKLsPbqI1+QWtUQgOtETY+2itXuJqMqUo7DSzKJjUTRTtVdsNQtBL7BIiWgLoU4M4JvNFuEx4HlSRRJRdx/iHzkMuyKncWJkT8Eg0u7+vkNTQWHPcMmTF2xcqhdS96pdszRg5LCuPdIJK79mA4ScXG7Hk2TBQ/jBPyaSHkJv1nplPgYBnOF2wxNbR2CdXXNmsNdXy9bQj/CWOogA7kPlKfUl01dJ97+IS8O6EVX0C7pMI4CSafqO0md5S7qKh7O3JJ1PelNEYGHDKX+qxzK+XmBQHp0CyhTJcAK+zE3gObCuSitsfG+kzR5RAKPHP6PbB8tCF3doRUn8XzcPYMa/alBBcX9uZ+X22jT3FvldBa2kpVbaAb0uMtNNBDagwm8+mM26M20Sfd75DLVeag/GJmuGiL1zoHLe9yBp94sZo/ot4PTIDAws8dsKNycNpZEAZNPG1g8comSp4Jsn/9skpeOhaY=
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
index 72b2ec31025a..2e9864732c11 100644
--- a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -4,6 +4,9 @@
 #include <sys/mman.h>
 #include <test_progs.h>
 #include "test_thp_adjust.skel.h"
+#include "test_thp_adjust_sleepable.skel.h"
+#include "test_thp_adjust_trusted_vma.skel.h"
+#include "test_thp_adjust_trusted_owner.skel.h"
 
 #define LEN (16 * 1024 * 1024) /* 16MB */
 #define THP_ENABLED_FILE "/sys/kernel/mm/transparent_hugepage/enabled"
@@ -278,4 +281,8 @@ void test_thp_adjust(void)
 		subtest_thp_policy_update();
 
 	thp_adjust_destroy();
+
+	RUN_TESTS(test_thp_adjust_trusted_vma);
+	RUN_TESTS(test_thp_adjust_trusted_owner);
+	RUN_TESTS(test_thp_adjust_sleepable);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust_sleepable.c b/tools/testing/selftests/bpf/progs/test_thp_adjust_sleepable.c
new file mode 100644
index 000000000000..4db78f2f0b2d
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
+int BPF_PROG(thp_sleepable, struct vm_area_struct *vma, enum tva_type tva_type,
+	     unsigned long orders)
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
index 000000000000..88bb09cb7cc2
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
+int BPF_PROG(thp_trusted_owner, struct vm_area_struct *vma, enum tva_type tva_type,
+	     unsigned long orders)
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
index 000000000000..df7b0c160153
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
+int BPF_PROG(thp_trusted_vma, struct vm_area_struct *vma, enum tva_type tva_type,
+	     unsigned long orders)
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


