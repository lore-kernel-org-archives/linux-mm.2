Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D8A7CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2338E002A; Tue, 30 Sep 2025 02:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A996F8E0002; Tue, 30 Sep 2025 02:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF458E002A; Tue, 30 Sep 2025 02:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8BAD78E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:00:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5215913B4FC
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:00:33 +0000 (UTC)
X-FDA: 83944867146.27.9C38A56
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5CCBB2000F
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:00:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jgsr4H0v;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759212031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+baDWNJ3e+prJbakC2u9YwdVipZEa6rsDQvMsjkRx4g=;
	b=Tskz0XU+/Z11noLTxWkFGlgwukjFDZsvSJtMXgC0C+FGYz678LClXaJXdCBilT7MoYqpAm
	1YequrNnHigRfYftAGfshMqg4WoB++Mxpi5CdFIwxQ4I2yt/E54ZaozILPqDozS6fBlmpk
	9mJP2R6K5zwbep3JDrDS0Vj64bHB51c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759212031; a=rsa-sha256;
	cv=none;
	b=KAIjHiKF+ojb1cCPqAqWNbNb/HDmshPWJBAsc8omrVAgroMXfLA6kliiIzHzODugy2Oqwl
	za7tUNgYGRdgPkWlQISyYHVjNXB9QVEJ21fOxp2hc1jeX6p/0dmciDmXFurHCx2+IkaTCl
	mMgBNF0tpl2RdpS1hatcy5Fo7G1jOoI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jgsr4H0v;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b5507d3ccd8so4765489a12.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 23:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759212030; x=1759816830; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+baDWNJ3e+prJbakC2u9YwdVipZEa6rsDQvMsjkRx4g=;
        b=jgsr4H0vcsAocKCAL/78L8XE1FQ/R4+qCGBycLs/ZAMharCGUQ2Gd07gWc9oUvZ5yp
         s8CSmUCLRPfZzPHVZiGf6+E8I/UZrJUgn8aNVGw/DfFirfgX8cvoazpkJyP6eqOFW1+R
         pSNIyxo/xuqvwX+J0+lH/svf3mTVBUAf8BOSMY6rhEfZnpjdRJXz69gSM+oBEBHRTo9A
         zLi+nLHjOdcG5XpyAFXuFXMqNjAj0gvwHIoPqtOO+Eta3U/JJUDP1k1MPJptZwb1bebM
         +J4mrTOBcT7PtCYpYKyU7w1qAbtqmG/jQXqHv+eQc/w/C98QXUMQpzC6nOeifZypM8gb
         182w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759212030; x=1759816830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+baDWNJ3e+prJbakC2u9YwdVipZEa6rsDQvMsjkRx4g=;
        b=FpW821S3fmVsfQM5Gsg9cfjCfP7nc60CJR0P1ZQjt9/TRvv1Mg1WnXM0HWkCCkfDwY
         aHd8OXp82JEg4rOc/w8tstnFWusNEN1Q4Hd5pSRWFo24uAvLqUAE7UR53WNbtO5TJ3sy
         k1/KuZEXCH6pjmcbGOkekM+hHlSgSasjErwgdsOEgxEBUjWnq25AoDxzXh6tbv4VfIKt
         B1NUY2Gdo0Adu+POua0E+QKqVlV7ju7rot9ZWaG0b8aAzhhGUeUhVVgy9b6qR7gTJywp
         ppR99x+w1u3FcN/Uaw156vHawKElYoHZm7Ks/m3YBEzrhjYKfOimlFQiehgUIV0cn8Zt
         ki/g==
X-Forwarded-Encrypted: i=1; AJvYcCVJuZSix2h89Ybgqb5u7259OVBwJy2G5M3qPmC0Sek/E13gF5qAyp6NN+Fg00muVj4OOvBVacpFew==@kvack.org
X-Gm-Message-State: AOJu0YzhXPPe0iKf8AIUkdQN+47ito8JsROA/3DU6TZUXu1qkeGJFcsB
	VugoMFQMPd5+BP76xVClDCmSl36twhUBO5242BSQ6lH3NumesMqj3lAI
X-Gm-Gg: ASbGnctQMQ/OrFXs5JZAWM1Iu+138+RKbIjMtldTf1bnN6w8D2aQ7x5dH+kwhwnmypg
	uXtlBh0SquInEx44/6j9EJiZqFUjXmz5S6IrcDjyWh9Xit3yqfUTwrDmBBs1B+mzOo8lAFCZItf
	F7bS4Xv9IlcTizouDdZD4nUXDNJBGS0ENvCdGtlvbCIp2ayoPV4HT2Xx7b97QqboSbU61ZcBV9f
	PiwCwpZ4Uy1fmkpFIKXXDd9gJfQi5JiEdAQjRbmVqDnQFFC3IZuzMANTFU8O4uYyWxod69Vr0u2
	uQCKrkSNEAAHDX5fqGCWM4y9wU2bXpP4etC/naqB/srQcbI65lB2aoEr+lxqOJq6m9zu4khfekl
	4ptRGHeiaJJ3jROSDXzcCTdgeNhOQH5+86lIaaaC9g0TgCbWHMbdN8gGprQVUSmBwTsTFNj+QvA
	p/1BV82DuJAN2ml2Jb9qMxih0Wk4E=
X-Google-Smtp-Source: AGHT+IF3u3CwEhxn4obFOsd5k7ipKHjSB6CIP+P0m/CZ4RrSdU6mgZTJEKlhFteu0bsxBMQFdSQa/A==
X-Received: by 2002:a17:902:db04:b0:265:9878:4852 with SMTP id d9443c01a7336-27ed49ddab3mr250832865ad.15.1759212030159;
        Mon, 29 Sep 2025 23:00:30 -0700 (PDT)
Received: from localhost.localdomain ([61.171.228.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66d43b8sm148834065ad.9.2025.09.29.23.00.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 23:00:29 -0700 (PDT)
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
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v9 mm-new 10/11] selftests/bpf: add test cases for invalid thp_adjust usage
Date: Tue, 30 Sep 2025 13:58:25 +0800
Message-Id: <20250930055826.9810-11-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250930055826.9810-1-laoar.shao@gmail.com>
References: <20250930055826.9810-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5CCBB2000F
X-Stat-Signature: 8eifw3qetpycpiowp7gemirtrwdks9u3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759212031-817877
X-HE-Meta: U2FsdGVkX18oWeR27ySsPOx3o+59oUpsTS7k0P4XIVrQnLiuhIq8u1ExM1LZHV51pkuC6lLcoLZ/9MvamzCYVosRedScO9ly+STNky2rqIUnPSYWS/JygeeMfRyvBxANG43HfaE25b/Nmnm2qs0denpOrmGIlKMq93HSa2a/z6C59ICUd233dkc+kreOiirrTTEkuBz/eg7371iMHUl3na+SrR9tk19AYqMhBbuSLwIKOzmS6u8ToQsOM58ALORt/k9SCCfiewTE8H4egmmJ8sud2z1jZ/TpZ0rjCnA5w74kww2y+wJRfUucq6QTFd8KywTm7vD0rvBpcYEiZkTeRei2sT05FNByuow6zLgr4cj894wB9wA8H8PNpmKABbaX6VohrkMK6CYWTd90LdQBn5MiUiWFUHAr3K2ZDDpgaMjiD6Pjwl82DiBKJQq9CreNanWGVYNjNCyyWoDGqa9M9eyh3HAOoHapsEUJLX6dWcvVCKq7fTFS8qvSVwra6gWCzp+w8vgemKi//XkZkeBSuoDB4XsdZ2CRtXsfkrmisPV54gVGjCuPZ8A69Ze/coKBgx0QIssr/coMIdD+cG0jfsu3yKqgtGvxIDZYU24iZ4GCANyJeloH5dy1tDW77C/cSz36sG4+t2QyGUW7/ARfFqKJlJ06OOaUigdmZYMiw9Kyg+D5mg3TYoT6voK8/wLWJ9wnKoS5KdCVvKUCJe/hXo/90dSoRM/USHKIYjBIxC6xtOMgbsjUGcK/0UGWSbOjTVEeq0RfLaMTcnos0mJPEB8FejUbgVLr+7T+xSU/PWksR1v8kjBpw9zVHq2EKTChXFcKa2/8Sd76wpGQrWa1InD+2CLpGKAqS5qMBmCvM+kHt8hGyRGmIikzOf+4i0gWugsDqNcZDLmuq+sIMft/XNr5pp0M3qm2TkPZ67BhDAlhqQeg/dvVgadmkBMtJnpeIUeyiz1sF/7HGRYzfxA
 om9XD5am
 ZDVbHSlf7qXqQNr/kmnaF8flY2YcW4GvVBgXEMbshAJaiuY1OmZ0/iKNDUX5RJeIeLSwC7PxzBFOaMvS3Gv000Y1hzv49k3ECdsg4EINwjjG/OKcUBpKC20SLHr/25ZS6M9WQk+v3PNQEp6ttQZjSjJxvxoFxd1VAEl6QhUEiecRb+oYiTXnTgcTvXtEtMeWdiX6U6w+BGNT3UGVimc91MblRiP9PXv6H3RKvzNtE3QVVpwaWSqBJ9HPpL4v0lQzWeqigfpDXJaabtsTyz8JiYuDdKgWpwBHqKweZMN2orjN0/UIU2NPE6uie75sRPQ0lZzGNaXXtER3UII6kgZ0qTzk2PsVX84IFRWVfUthexTkQHacTW6UpVsdNcGuV3igj8ZyEvww7ehfLTmeMD6/OTTuFygPBUzXuhFXsOrBkwt9f586xbwVM1+gh+WRecuTTUXmyQlq/tgBTdc4R3XRGuygcgm8zI1ohSy0FTh/7KU81IanE/XJg5+LpeWffFotXcGLHkAgnCtleoIcinWsNNLfel9OaGQsrC69m50mTtcrzBu3r+iu0fHR3Gw==
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
index 409ffe9e18f2..90af0322f775 100644
--- a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -3,6 +3,9 @@
 #include <sys/mman.h>
 #include <test_progs.h>
 #include "test_thp_adjust.skel.h"
+#include "test_thp_adjust_sleepable.skel.h"
+#include "test_thp_adjust_trusted_vma.skel.h"
+#include "test_thp_adjust_trusted_owner.skel.h"
 
 #define LEN (16 * 1024 * 1024) /* 16MB */
 #define THP_ENABLED_FILE "/sys/kernel/mm/transparent_hugepage/enabled"
@@ -277,4 +280,8 @@ void test_thp_adjust(void)
 		subtest_thp_policy_update();
 
 	thp_adjust_destroy();
+
+	RUN_TESTS(test_thp_adjust_trusted_vma);
+	RUN_TESTS(test_thp_adjust_trusted_owner);
+	RUN_TESTS(test_thp_adjust_sleepable);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust_sleepable.c b/tools/testing/selftests/bpf/progs/test_thp_adjust_sleepable.c
new file mode 100644
index 000000000000..e3d70f258d84
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
+int BPF_PROG(thp_sleepable, struct vm_area_struct *vma, enum tva_type type,
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


