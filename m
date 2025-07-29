Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C716C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 09:19:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F52F6B0098; Tue, 29 Jul 2025 05:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CC7D6B0099; Tue, 29 Jul 2025 05:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2376B009A; Tue, 29 Jul 2025 05:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4066B0098
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:19:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE43F113C0B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:19:08 +0000 (UTC)
X-FDA: 83716753176.27.8827B50
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id C9A534000B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:19:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ysr9t+wW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753780746; a=rsa-sha256;
	cv=none;
	b=yIZp8dOw2CWVjLrtykayLWiW2nD01cLrvFizjNxXRpq9kFJGdCgd8OOXJtX29fp311hzhP
	f3o4LCfl+hGz2rJUq6V05xpxXvy8IdCnSabhZ3YtZcOFvPFCIh+iTuH/rPL/yPIihZNVNt
	JkqhqrAVvcu+nJ9+Ovbezox4O7yVbLY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ysr9t+wW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753780746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cT/+Vj/WgCPErlp9XpFLiKV4dpfirygddhdeMhc0Kt0=;
	b=S9Kl/1TjESRgTSOl++UrqLQCiQ1GNdFsLUJHr/qPv3lnf1LoAykz/tsHG1Mzaltj/5QRvu
	SXJhKI0eQ/oORgjz9MIZZifnCOYp192T64YbUI8cIxUWC62Vlcx59jvlJtiIPY01VV+BCy
	ujBy41C+t5NgYVHQcpZPzfmuVIE4p/w=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-748f5a4a423so3677458b3a.1
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753780746; x=1754385546; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cT/+Vj/WgCPErlp9XpFLiKV4dpfirygddhdeMhc0Kt0=;
        b=Ysr9t+wWzGFcsfS+OEuAxcp9r/dibeK5E9vlFViOibCbemBd9GX7p1Pd+m1gsFRtNx
         tPCYvR9F0ab4f0aRo1RfTuL2U9N1ezkkFU7rIcMvVV1rDbWnNKbO9YVC+WjtrKTbpTp8
         A58fntX2utW4gs9Fn+Zg4Tew/89YfdzLgDVty8xe0sYJ5tTYtEaVqt12F6e6XOM38GXJ
         Uvj1L6c25W+6PPX+YcqQJ8badJYjSh32l9I55Mhw2DtLzHNORT2IipPpIMzy9gOFbdZP
         Jiq0HqeRYK/WmCNB3npnDfvWxoFkXubtKNTnoredfuPqH0CH+64ltiLK0cul1F+oZkSH
         133A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753780746; x=1754385546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cT/+Vj/WgCPErlp9XpFLiKV4dpfirygddhdeMhc0Kt0=;
        b=TxmKxLJab+TbBFwYOqbgnBiRx0jjqKaqO+zHW3z7J6n/nODaYZIqB+xXXbsr8QhkaR
         kp5iP6HcQXvA+G5msW5e72vZJREl2ekLxDaJW4BuGLCCjQFVFIq3uqm+QiLZzcXEWhDi
         MLzrS8/UuYM830RjBPNpMSKQlpZAuxGigefFVVZ/nBCnGbBMGvIbzQwKkVzsqiR+QccU
         XRG9nXLmW6aXW81wbgvCmwBravVOZaBQBm6Xh2CZQXWCzgDE6p+QyN8RMqJZ2bpwocsz
         YK7OI/y33pHyFXAHKbhbEQ1da11bgSvlWEg1d2YcqOAsab4Rd0ZfMZ0T4d0pMdHkBfLS
         4lrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUv8c0fa0uhbSOgNheCidVI5hrwBf95z36zUhnW9kk4nzd7elH4zEsQZTeAW7pqlh5+Lc9nCOF1Zw==@kvack.org
X-Gm-Message-State: AOJu0Yw/xGBreV14OIo1yT0pGc74CKCyTG3SrAv6HhBQw1XPbhIqW7CP
	5TsWJLYzIzTA8gkGCMczeQB8HrKr3acfBZ2POVafkyMxfwNi8isPUAnb
X-Gm-Gg: ASbGncsTTKIM4JB8ZjzyjByqdHVgS0OjBxR3AbzmANZfixWM/DOH1I+vDqHJ5zWBHTI
	q+MLC5AqS/DKpsKEQc9ns7GZBRWFz8PlW+L9LbB5gWqYiMIDiPbUQVQw951HbDbMYYjSRstQwO9
	4IHnUbuDOaOPekHIyW18tZE2dMNWpZTFFGJPHhVu184/rELTxdniqHSFSInOGGgxcu3jq6fsidR
	R6SpK0nUo7FMHcMCbNM20/xj3zHNgt6j2sQesKqbN8ESVpOQF9dot0YMzsjvDCjVSuyubsaP1E3
	nTbxOzvvwo2XpQLCL+egfsq0pDUGhdqDFlf048huJRLLHir3wvCy4iPmIErMcrhovGF3X2ygPbm
	YHSaekD0pIn/cnM8qpMQWWcobegvQrlqfdQi+0X2ZfO/KedbY
X-Google-Smtp-Source: AGHT+IGa4X0xRoc67h+AzZSsejMIDdMXqt6jt6opygwXwUJngDgycWDtdoNq7WirJcTySXhCP2ekaA==
X-Received: by 2002:a17:902:f30b:b0:23f:f983:5ca1 with SMTP id d9443c01a7336-23ff9835e51mr94639005ad.12.1753780745487;
        Tue, 29 Jul 2025 02:19:05 -0700 (PDT)
Received: from localhost.localdomain ([101.82.174.171])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fbe30be01sm74337015ad.39.2025.07.29.02.18.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 29 Jul 2025 02:19:04 -0700 (PDT)
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
	ameryhung@gmail.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v4 4/4] selftest/bpf: add selftest for BPF based THP order seletection
Date: Tue, 29 Jul 2025 17:18:07 +0800
Message-Id: <20250729091807.84310-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250729091807.84310-1-laoar.shao@gmail.com>
References: <20250729091807.84310-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: trs36f75ya4aez6bp45jki9kbrqwome5
X-Rspam-User: 
X-Rspamd-Queue-Id: C9A534000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1753780746-111961
X-HE-Meta: U2FsdGVkX1/vZpLyBCvs1GrEXFB59OicHx4iJ305DCkDuLM9phpsCMIFtmVTa4FGAKpVeBqqb72NXLJTey2s/o0wvtAei2lD6T8aX+naRRhmXqfffTTdZTwqzHdoemED2fGjwn6Yb5aM+W+XPV74EF8yS8riaddSC/ECGYeQnLCMEVP5oSdDqZgXBD+sSoD2TObQKNmUTsodkX8XIuvilfYo1u/ujDEhTJPjOh7mUW8sxBR+inBk1MGvr5gJ1FC49SZLk8PqEWG7gc/Fm8IRO+IMnDv9YTFJ/rKn9nCMh9azv/kHZzzds5Bua1Z99XQ/Po5wXwidPY76CLwcxsLxSyxGEBhlaC9ySKE0Dh5PvVFxJCZPmqiV72/5ZVsPaCvoJAJHkKY3INwza3LzjmWEkMbci2BpMtypKzqLDtbdmTR+IgPY69DkLhNgxiXtpV/UK5WdYbOMlaQNcx4SCqNK8t4wcZ4jo4UpbE0ygUN9RYtI2Pl/2fh++GPYDdub/MG2l7N/Fw7qDNfEsmQklsJBcYixV3NnP9b5YLx0HUoThJkvYvBzU5c725wwxmpqVtaPIHlF6n/kKUqVKDFyUI+uDN4BUFZIOHsyFIMaFRGsurYJvR7oJFWMMTeo2uQ7iItQSTCqJNZOhMfeT/RH8bjyG+fQ2ALHPM6lRoLo/R9sBqAEtACi4pvPA9oxTcCpUJbbCKUWPLWH18DMDAO93+itFXhKjEGqa9zEBsrHxDNePGCrMldRksMjpPvWAIX6iuODZv3y8L8sVzL6F0ft2lDdzpVwHkQdxiDlWzbFBSNmLz4TdeKSgl4z7yFp7dZ4/0xxcy6vD4Ms+kSiH4SrDLjXu4MCbQWZX9GInBBXSjo4vnsae9xQGZJsyNvejQSnkv0+QfmLWOCuaMRlhHPy+1qBJHn3JO0Xa08+ULaAbemhwWP9g9qUDQTLnl9q0W3BmB/Ihg9S07rizhKgIsvV3Xp
 0A09eFal
 +7bpxsEZB2poE5bRyHed7icbh5CJr7fi33PkAunrKDhdTckhLzqU+XVlRpvsQSi+t9LNtgLTt2XQRq24ysoF9xZPjsJ2icvAcO1aY2d4w/iZCmqJ9P59JJYNuBLAD6htN5J9XRcCKSBasSykZ03x9zchoJDrverm/FjOmivhlTCU0nj/naLFDfSIylDkPBAFfLWP4x/ID9015RQj3tvLYiv2A5oE7yGiCbnWJBEQektHVPksTtzbPA5hLa9aCXD2wk593B37S3QKJDvcNAuQkEvN1t+90QK4At3lhXr1gxiwL8xFuPoHlzLVz6lrNMhE0uAUOE9NftxpWQDQWtSNRLaanms1fc8wM+fXHwd+Th2OjUZ0WpiQ1heiWdITsSyieVyo2Ccpwxv8A2ZhwnHeF28rX5flCabZPS265RepK475NdusV+gYz7cReyCJEGPvrZafSZ2vLWQ3cK1UfYXrHr740n2FQo6AhNle4kT1gBGXTC6T8L37iC/IJQTjybcO3PU+DEaBTHoj2Td8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This self-test verifies that PMD-mapped THP allocation is restricted in
page faults for tasks within a specific cgroup, while still permitting
THP allocation via khugepaged.

Since THP allocation depends on various factors (e.g., system memory
pressure), using the actual allocated THP size for validation is
unreliable. Instead, we check the return value of get_suggested_order(),
which indicates whether the system intends to allocate a THP, regardless of
whether the allocation ultimately succeeds.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/thp_adjust.c     | 183 ++++++++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     |  69 +++++++
 .../bpf/progs/test_thp_adjust_failure.c       |  24 +++
 4 files changed, 278 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_failure.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index f74e1ea0ad3b..0364f945347d 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -118,3 +118,5 @@ CONFIG_XDP_SOCKETS=y
 CONFIG_XFRM_INTERFACE=y
 CONFIG_TCP_CONG_DCTCP=y
 CONFIG_TCP_CONG_BBR=y
+CONFIG_TRANSPARENT_HUGEPAGE=y
+CONFIG_MEMCG=y
diff --git a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
new file mode 100644
index 000000000000..31d03383cbb8
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -0,0 +1,183 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <sys/mman.h>
+#include <test_progs.h>
+#include "cgroup_helpers.h"
+#include "test_thp_adjust.skel.h"
+#include "test_thp_adjust_failure.skel.h"
+
+#define LEN (16 * 1024 * 1024) /* 16MB */
+#define THP_ENABLED_PATH "/sys/kernel/mm/transparent_hugepage/enabled"
+
+static char *thp_addr;
+static char old_mode[32];
+
+int thp_mode_save(void)
+{
+	const char *start, *end;
+	char buf[128];
+	int fd, err;
+	size_t len;
+
+	fd = open(THP_ENABLED_PATH, O_RDONLY);
+	if (fd == -1)
+		return -1;
+
+	err = read(fd, buf, sizeof(buf) - 1);
+	if (err == -1)
+		goto close;
+
+	start = strchr(buf, '[');
+	end = start ? strchr(start, ']') : NULL;
+	if (!start || !end || end <= start) {
+		err = -1;
+		goto close;
+	}
+
+	len = end - start - 1;
+	if (len >= sizeof(old_mode))
+		len = sizeof(old_mode) - 1;
+	strncpy(old_mode, start + 1, len);
+	old_mode[len] = '\0';
+
+close:
+	close(fd);
+	return err;
+}
+
+int thp_set(const char *desired_mode)
+{
+	int fd, err;
+
+	fd = open(THP_ENABLED_PATH, O_RDWR);
+	if (fd == -1)
+		return -1;
+
+	err = write(fd, desired_mode, strlen(desired_mode));
+	close(fd);
+	return err;
+}
+
+int thp_reset(void)
+{
+	int fd, err;
+
+	fd = open(THP_ENABLED_PATH, O_WRONLY);
+	if (fd == -1)
+		return -1;
+
+	err = write(fd, old_mode, strlen(old_mode));
+	close(fd);
+	return err;
+}
+
+int thp_alloc(void)
+{
+	int err, i;
+
+	thp_addr = mmap(NULL, LEN, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (thp_addr == MAP_FAILED)
+		return -1;
+
+	err = madvise(thp_addr, LEN, MADV_HUGEPAGE);
+	if (err == -1)
+		goto unmap;
+
+	for (i = 0; i < LEN; i += 4096)
+		thp_addr[i] = 1;
+	return 0;
+
+unmap:
+	munmap(thp_addr, LEN);
+	return -1;
+}
+
+void thp_free(void)
+{
+	if (!thp_addr)
+		return;
+	munmap(thp_addr, LEN);
+}
+
+void subtest_thp_adjust(void)
+{
+	struct bpf_link *fentry_link, *ops_link;
+	struct test_thp_adjust *skel;
+	int err, cgrp_fd, cgrp_id;
+
+	err = setup_cgroup_environment();
+	if (!ASSERT_OK(err, "cgrp_env_setup"))
+		return;
+
+	cgrp_fd = create_and_get_cgroup("thp_adjust");
+	if (!ASSERT_GE(cgrp_fd, 0, "create_and_get_cgroup"))
+		goto cleanup;
+
+	err = join_cgroup("thp_adjust");
+	if (!ASSERT_OK(err, "join_cgroup"))
+		goto close_fd;
+
+	cgrp_id = get_cgroup_id("thp_adjust");
+	if (!ASSERT_GE(cgrp_id, 0, "create_and_get_cgroup"))
+		goto join_root;
+
+	if (!ASSERT_NEQ(thp_mode_save(), -1, "THP mode save"))
+		goto join_root;
+	if (!ASSERT_GE(thp_set("madvise"), 0, "THP mode set"))
+		goto join_root;
+
+	skel = test_thp_adjust__open();
+	if (!ASSERT_OK_PTR(skel, "open"))
+		goto thp_reset;
+
+	skel->bss->cgrp_id = cgrp_id;
+	skel->bss->target_pid = getpid();
+
+	err = test_thp_adjust__load(skel);
+	if (!ASSERT_OK(err, "load"))
+		goto destroy;
+
+	fentry_link = bpf_program__attach_trace(skel->progs.thp_run);
+	if (!ASSERT_OK_PTR(fentry_link, "attach fentry"))
+		goto destroy;
+
+	ops_link = bpf_map__attach_struct_ops(skel->maps.thp);
+	if (!ASSERT_OK_PTR(ops_link, "attach struct_ops"))
+		goto destroy;
+
+	if (!ASSERT_NEQ(thp_alloc(), -1, "THP alloc"))
+		goto destroy;
+
+	/* After attaching struct_ops, THP will be allocated only in khugepaged . */
+	if (!ASSERT_EQ(skel->bss->pf_alloc, 0, "alloc_in_pf"))
+		goto thp_free;
+	if (!ASSERT_GT(skel->bss->pf_disallow, 0, "alloc_in_pf"))
+		goto thp_free;
+
+	if (!ASSERT_GT(skel->bss->khugepaged_alloc, 0, "alloc_in_khugepaged"))
+		goto thp_free;
+	ASSERT_EQ(skel->bss->khugepaged_disallow, 0, "alloc_in_pf");
+
+thp_free:
+	thp_free();
+destroy:
+	test_thp_adjust__destroy(skel);
+thp_reset:
+	ASSERT_GE(thp_reset(), 0, "THP mode reset");
+join_root:
+	/* We must join the root cgroup before removing the created cgroup. */
+	err = join_root_cgroup();
+	ASSERT_OK(err, "join_cgroup to root");
+close_fd:
+	close(cgrp_fd);
+	remove_cgroup("thp_adjust");
+cleanup:
+	cleanup_cgroup_environment();
+}
+
+void test_thp_adjust(void)
+{
+	if (test__start_subtest("thp_adjust"))
+		subtest_thp_adjust();
+	RUN_TESTS(test_thp_adjust_failure);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust.c b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
new file mode 100644
index 000000000000..bb4aad50c7a8
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+#define TVA_IN_PF (1 << 1)
+
+int pf_alloc, pf_disallow, khugepaged_alloc, khugepaged_disallow;
+int cgrp_id, target_pid;
+
+/* Detecting whether a task can successfully allocate THP is unreliable because
+ * it may be influenced by system memory pressure. Instead of making the result
+ * dependent on unpredictable factors, we should simply check
+ * get_suggested_order()'s return value, which is deterministic.
+ */
+SEC("fexit/get_suggested_order")
+int BPF_PROG(thp_run, struct mm_struct *mm, unsigned long tva_flags, int order, int retval)
+{
+	struct task_struct *current = bpf_get_current_task_btf();
+
+	if (current->pid != target_pid || order != 9)
+		return 0;
+
+	if (tva_flags & TVA_IN_PF) {
+		if (retval == 9)
+			pf_alloc++;
+		else if (!retval)
+			pf_disallow++;
+	} else {
+		if (retval == 9)
+			khugepaged_alloc++;
+		else if (!retval)
+			khugepaged_disallow++;
+	}
+	return 0;
+}
+
+SEC("struct_ops/get_suggested_order")
+int BPF_PROG(bpf_suggested_order, struct mm_struct *mm, unsigned long tva_flags, int order)
+{
+	struct mem_cgroup *memcg = bpf_mm_get_mem_cgroup(mm);
+	int suggested_order = order;
+
+	/* Only works when CONFIG_MEMCG is enabled. */
+	if (!memcg)
+		return suggested_order;
+
+	if (memcg->css.cgroup->kn->id == cgrp_id) {
+		/* BPF THP allocation policy:
+		 * - Disallow PMD allocation in page fault context
+		 */
+		if (tva_flags & TVA_IN_PF && order == 9) {
+			suggested_order = 0;
+			goto out;
+		}
+	}
+
+out:
+	bpf_put_mem_cgroup(memcg);
+	return suggested_order;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops thp = {
+	.get_suggested_order = (void *)bpf_suggested_order,
+};
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust_failure.c b/tools/testing/selftests/bpf/progs/test_thp_adjust_failure.c
new file mode 100644
index 000000000000..b080aead9b87
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust_failure.c
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
+int BPF_PROG(unreleased_task, struct mm_struct *mm, bool vma_madvised)
+{
+	struct task_struct *p = bpf_mm_get_task(mm);
+
+	/* The task should be released with bpf_task_release() */
+	return p ? 9 : 0;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops thp = {
+	.get_suggested_order = (void *)unreleased_task,
+};
-- 
2.43.5


