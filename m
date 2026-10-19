Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B427CCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 06:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CC876B00C3; Mon, 19 Oct 2026 02:43:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4766B00C5; Mon, 19 Oct 2026 02:43:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BAFE6B00C7; Mon, 19 Oct 2026 02:43:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB6226B00C3
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:43:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3BDCA8254
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:43:19 +0000 (UTC)
X-FDA: 85338434118.27.F66C8DC
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2D68F120005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:43:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HFgCV4xS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792392198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QKAdquM1bwNLsWoLZwLO17OYT9kkSEaiRwexFyrn8po=;
	b=Duq3Ikd6946XtjnCxbLd3ln2LzE3Y5FOJ3yl0GzWeDqQo2q+W2Olostn7kCUDquSzEu6Zc
	GxX2tCqagR4KaFkosluQSjKCCozS8D9lBkdhYbmxmqj+ejQ5rSA7XkpfEk5CzIe0KrnUyq
	eMPTUBy+5dbigvbWgWdRYWtnxaJuMGM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HFgCV4xS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792392198;
	b=ccV+fEY/0hgt40Ba4hjQ2FmUO9vGhiBN+1srQAQr2gwAhlAHSPB5P6BdTSmphoGWpq1z15
	+W/t90kLsjdvnHdiKxGf5r4/WQN/m4oLOcTEBJtLN+cI34b0kzS6RkLTF5th/liaCeGTw5
	H8EBMdJnMJC3dqVUbOl5Qjm+WKHtGrs=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3a7cfe8f761so1854811a91.1
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 23:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792392197; x=1792996997; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QKAdquM1bwNLsWoLZwLO17OYT9kkSEaiRwexFyrn8po=;
        b=HFgCV4xSClVHNUJzuMuH+s1LQG7RYjJfR4sdvzS5XIKoz8PU2vyoe+dm3YW06b/Kyd
         8rw1I5OWYlanI/xvK0ehHeYj346CcFys+VP2mlP/Am9VwWmuOmNEJ3PqHXstGS2CLXiF
         7arOsHhzOGA7A+T+Bd+CEm48xBdsY5QN6K3M4y8bXnMptpUdGmnH/mJ5BOjrzUr8qUEu
         v87FiCUIVACgO7MDrQR+kqwIGGMchlSI5JFK3MWBE4UeoHz9FB4NM+8jNFRFTqojHABL
         U7UoUuC63iVzZNsjoCiuc+f0gWrq79aPhX71YJ9JQDGWNlYmlVoJ3gop8EiLQbTSTRhV
         Hs6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792392197; x=1792996997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QKAdquM1bwNLsWoLZwLO17OYT9kkSEaiRwexFyrn8po=;
        b=CpCy6Y609/PY0XBylp464Jzro0uZWKxXwmtt/cbrW83a4QjHjwozUhTkA1x2emieby
         iL0PZgLeHffzEYoqJBJtQgUN2zpFjUYo4YoLI/NKIEjBvLWxjttoK+SqbY6PN0ViI3S8
         2fgwBwxR4x5HECn6Zg5h3VkYCXZAElqqI1Gj9oHgQfSKv+Hf8wpsVMkiy68hp0Vn7J4U
         7UQODVM6L8y2r2tNO0tDvtsun2pQ73jNG7Z42KUsJEouXMP1LjrMy4A9DbHRcPytOlm2
         WRiLKfCC4C/UkTJ0La0PZ0Sp08/ldGdFCjO2abvRj20YEs1M1czmjKvI4tC4ueD80WMG
         NaYg==
X-Forwarded-Encrypted: i=1; AKwUvBxoUMVNB1wym1PvjAC9m/qN4k39yb4We/J70dH47LqLkJONociWcYkmnqwrvQ/wcLk6AKmUbbI7Hg==@kvack.org
X-Gm-Message-State: AFq9FYJOYIGQmPnSKJ4LYVUNW8438VXaunUrJSqlhNy4bfS2UHwY+kYj
	pMV8sYQFj5A4GIBEZn40tRH/2UhG1JHAv+J5qk92D3QYNLTcQoJjznXh
X-Gm-Gg: AYBFou1OvDYcImJfOvkVJkOGPMZ3U6S30Yn1/KQLZ/hYoks7gW0QiNmGIGEHS7UzoZ/
	i/QyAycFKKNIZsTqz2pPip7yBWlKG0MaINOinir0oF72QFmTYBQfLUakeeRIoOhxKI+bPBRKTsa
	MyhYhWhS+RHQOp+3jqOdpzaWpdWTky3RFyKIomeMNsFLq4nH60KBqcT+edRUuKl/eMHBqpqdCPy
	RqhnWQHbic1K+81a1jAMGidqFDi/kwYKAExXxCcvmfmR2KRf63GQqf0F1CKv93NkZJj0rOEQW5M
	BZp775FyFsS8UsGgridhNm3nY65T9HV1s7V5stQoz2D77VhquhQINpffCJGoSRr/bpS7nnaJdj8
	EtdVuj6m14QeuoGbfHCmsuShfgBX5roIA7d1ofafg0fSCark4rXJEaK2NP9ylrQzyAlr1KR9cWy
	XbdmP1uvyZbzPe38AMGviZT7sfZ0ftaqzfQ1m3cu7tA5U3TQGD0qvRCwH1txCvMK+9JvyPrLSdA
	WbaCY/UjCKcItk6A6oDNUeUgGw/2pMK8DpjN+vNK7u3u/yMM7uOLo32ifxKhskXo7Kqbw==
X-Received: by 2002:a17:90b:3146:b0:3a4:9416:a2f8 with SMTP id 98e67ed59e1d1-3acbb879edcmr6758743a91.9.1792392196871;
        Sun, 18 Oct 2026 23:43:16 -0700 (PDT)
Received: from localhost.localdomain ([240e:46d:2100:3fed:6938:3f14:63eb:c479])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd654a3a592sm3688960a12.30.2026.10.18.23.43.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 18 Oct 2026 23:43:16 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	yu.c.chen@intel.com,
	zhao1.liu@intel.com,
	tim.c.chen@linux.intel.com,
	lizhe.67@bytedance.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v3 bpf-next 5/5] selftests/bpf: add tests for the numab kfuncs
Date: Mon, 19 Oct 2026 14:41:57 +0800
Message-ID: <20261019064157.29885-6-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261019064157.29885-1-laoar.shao@gmail.com>
References: <20261019064157.29885-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2D68F120005
X-Stat-Signature: 1n3j3zxk3dea1anmfpfukins5d43w1mx
X-Rspam-User: 
X-HE-Tag: 1792392198-799660
X-HE-Meta: U2FsdGVkX1/X/ddZBI6BkisZ3PtiWla0JP4rKoVDZZjtErbfGwho6rPnSU8d53AKD2+pcCDMeof4QJNibWT+Hs5tB5qvN3QLl34oGuYksOfAY5nagLJCjk6IA8A2LL72TzUGbkiSXq0AsyDMEQhuRnhHfnIOVNnXmrXDSH4bUk6Nnt98ZWRvfD6ICUHJn3+0Ucvux1d9ajN4g6RZYrHDs5stx9Px316DqgYv9ehOpTL2QxARrWAj1gKw8He+qPM6O0B8eOT6BX4D2Fh2ohK5jUIBgJ1m0qc0gFuklvmtigKtS5GmqhEBrhh2KK2zii3Yu0UmQVMJDJhCxTxkWnONYVaQOhQr35yWCGkke410tq0Yc5EP5boplTzo83OXHlZOhaO7OU3p2/NZA+15rHODZn7z0YYr28zllUnPO0CDidr0IEp/mVI6dMvBT+aqb7YiwgBD9nQf3ym+eTkKAb3FRxIToGHFQNq2UaTDfSN7EyFnFSSxic17MAZVEEOXh1ZlwfHlFhG+/A6O4s727GXegBriAIV4+UcIEaaHn11TBpg4SUOJaA3fHd2UbG8LplGS8w+w4rSiBrGcvgU/gmEExU9H03FDI0NOHb7GtbDQOpOmYybLq/jvaFqVHw4a1tu7IfuYDELP1Tt/WUWhfh9wklvxnp0RiWccpzu8RO5Jmg5Egs8CVCWMGBV23qqdXbfGkicJNKDQpAAVuj/nbyMxOEkoYcckjunK2F9/CVNzflFG/Nlbtsiono9j71O87/rWzuvpDG7SEqIug1jG4+bj/wCryOsEU6TI/sD2mH/XBpHSneJyatDzrRRB+tKsVq02dmOycBZGAO+L7kAztyPAGS44SWqkhcQIzqOwsDp1ZIzTq9sqCuT+p74VcdDJxw/CsOPb8jCgnjlcmQnlRXnzHIjHMf4rFx4/e5B4E+Dcbtx56IuqwjILLZb1I/aAMAVBpgpUbzdAFaoRO39byN8
 CN/jsDGe
 XRPGtM9wXMjDGLM3gn4LjvIp5Vrkgc+xS/lytNEBHgyA9hx8jWd6QvBvQyonsjles2fVrTee0TJWy7NbQ/4XYhpBFWsUY7UYHO8M9qp/ZKTaK6pdJ8Irvv7+iklmT+epZaybI4iAkDReYvqzEHb+7fkO2v6P/Xq/bREpfF3QJqnR4ef5EeoYtY+t71gj1wdA7f0GfCn9gLY1jrNvoZBOgj2BYKY4azjmfH7dj7oheExh/0nEzQswgwViBX6alptCJpxfiGxcw0zq0SDDbfvDyUe9lXuAUUc26AUJ2FFZL8vrcr3sMGwpkMr/9qGjHmdu6lPNoLXAsZJjaaBZDLfg6jakSHL0DrTHAtDyg83xQqCXqg46XnbAHxOQPC8ZuXuSvNKDFgWmcoNEQlXmCVDbo4UL+JI42i5LA+m0MrvVG2wUQ90wSPZfbn3tDIiZ8RzagzI81zkis1Oces4HxTI7NY/aStXWawWrKIeIXeFiFCFcrYbJfD4rIYS0jCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Exercise the bpf_numab_set_mode() and bpf_numab_get_mode() kfuncs
through BPF_PROG_TYPE_SYSCALL programs: the set/get roundtrip, the
mode domain (NUMAB_FOLLOW_SYSTEM and the NUMA_BALANCING_* bitmasks
accepted, anything else rejected with -EINVAL), unknown cgroup ids
rejected with -ENOENT, and the hierarchy combination the ancestor walk
produces (inheritance, OR-ing, and an opt-out winning over every
request in the chain).

Assisted-by: LLM
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../selftests/bpf/prog_tests/bpf_numab.c      | 227 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_numab.c |  32 +++
 2 files changed, 259 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_numab.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_numab.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_numab.c b/tools/testing/selftests/bpf/prog_tests/bpf_numab.c
new file mode 100644
index 000000000000..7ce4b8153c42
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_numab.c
@@ -0,0 +1,227 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include "cgroup_helpers.h"
+#include "bpf_numab.skel.h"
+
+#define CGROUP_PATH	"/bpf_numab"
+#define CHILD_PATH	CGROUP_PATH "/child"
+
+/* The per-cgroup request domain, mirroring the kernel constants. */
+#define NUMAB_FOLLOW_SYSTEM	(-1)
+#define NUMAB_DISABLED		0
+#define NUMAB_NORMAL		1
+#define NUMAB_TIERING		2
+#define NUMAB_NORMAL_TIERING	3
+
+static int numab_set(struct bpf_numab *skel, u64 cgid,
+		     long mode)
+{
+	LIBBPF_OPTS(bpf_test_run_opts, opts);
+	int ret;
+
+	skel->bss->set_cgid = cgid;
+	skel->bss->set_mode = mode;
+	ret = bpf_prog_test_run_opts(bpf_program__fd(skel->progs.numab_set),
+				     &opts);
+	if (!ASSERT_OK(ret, "set run"))
+		return -1;
+	return skel->bss->set_ret;
+}
+
+static long numab_get(struct bpf_numab *skel, u64 cgid)
+{
+	LIBBPF_OPTS(bpf_test_run_opts, opts);
+	int ret;
+
+	skel->bss->get_cgid = cgid;
+	ret = bpf_prog_test_run_opts(bpf_program__fd(skel->progs.numab_get),
+				     &opts);
+	if (!ASSERT_OK(ret, "get run"))
+		return -1;
+	return skel->bss->get_mode;
+}
+
+/*
+ * Roundtrip through the combined view: the test cgroup has no ancestor
+ * making a request, so the combined mode is the stored one.
+ */
+static void test_set_get(void)
+{
+	struct bpf_numab *skel;
+	int cgroup_fd;
+	u64 cgid;
+
+	cgroup_fd = test__join_cgroup(CGROUP_PATH);
+	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
+		return;
+
+	skel = bpf_numab__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	cgid = get_cgroup_id(CGROUP_PATH);
+	if (!ASSERT_GT(cgid, 0, "get_cgroup_id"))
+		goto cleanup;
+
+	ASSERT_EQ(numab_set(skel, cgid, NUMAB_NORMAL), 0, "set normal");
+	ASSERT_EQ(numab_get(skel, cgid), NUMAB_NORMAL, "get normal");
+
+	ASSERT_EQ(numab_set(skel, cgid, NUMAB_TIERING), 0, "set tiering");
+	ASSERT_EQ(numab_get(skel, cgid), NUMAB_TIERING, "get tiering");
+
+	ASSERT_EQ(numab_set(skel, cgid, NUMAB_NORMAL_TIERING), 0, "set both");
+	ASSERT_EQ(numab_get(skel, cgid), NUMAB_NORMAL_TIERING, "get both");
+
+	ASSERT_EQ(numab_set(skel, cgid, NUMAB_DISABLED), 0, "set disabled");
+	ASSERT_EQ(numab_get(skel, cgid), NUMAB_DISABLED, "get disabled");
+
+	/* Back to the system setting. */
+	ASSERT_EQ(numab_set(skel, cgid, NUMAB_FOLLOW_SYSTEM), 0, "unset");
+	ASSERT_EQ(numab_get(skel, cgid), NUMAB_FOLLOW_SYSTEM, "get unset");
+
+cleanup:
+	bpf_numab__destroy(skel);
+	close(cgroup_fd);
+}
+
+/*
+ * The mode domain: NUMAB_FOLLOW_SYSTEM and the NUMA_BALANCING_* bitmasks
+ * are accepted, anything else is rejected with -EINVAL.
+ */
+static void test_invalid_mode(void)
+{
+	struct bpf_numab *skel;
+	int cgroup_fd;
+	u64 cgid;
+
+	cgroup_fd = test__join_cgroup(CGROUP_PATH);
+	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
+		return;
+
+	skel = bpf_numab__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	cgid = get_cgroup_id(CGROUP_PATH);
+	if (!ASSERT_GT(cgid, 0, "get_cgroup_id"))
+		goto cleanup;
+
+	ASSERT_EQ(numab_set(skel, cgid, -2), -EINVAL, "set below domain");
+	ASSERT_EQ(numab_set(skel, cgid, 4), -EINVAL, "set above domain");
+	ASSERT_EQ(numab_set(skel, cgid, 0x1000), -EINVAL, "set far above");
+
+	/* The rejected requests must not have stuck. */
+	ASSERT_EQ(numab_get(skel, cgid), NUMAB_FOLLOW_SYSTEM, "get unchanged");
+
+cleanup:
+	bpf_numab__destroy(skel);
+	close(cgroup_fd);
+}
+
+/*
+ * An id that resolves to no cgroup is rejected with -ENOENT.
+ */
+static void test_bad_cgid(void)
+{
+	struct bpf_numab *skel;
+
+	skel = bpf_numab__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		return;
+
+	ASSERT_EQ(numab_set(skel, 0, NUMAB_NORMAL), -ENOENT, "set cgid 0");
+	ASSERT_EQ(numab_get(skel, 0), -ENOENT, "get cgid 0");
+	ASSERT_EQ(numab_set(skel, 0xdeadbeef, NUMAB_NORMAL), -ENOENT,
+		  "set bad cgid");
+	ASSERT_EQ(numab_get(skel, 0xdeadbeef), -ENOENT, "get bad cgid");
+
+	bpf_numab__destroy(skel);
+}
+
+/*
+ * The requests of a cgroup and of every ancestor combine: an opt-out
+ * wins over every request in the chain, otherwise the requested bits OR
+ * together, and an unset cgroup inherits what its ancestors ask for.
+ */
+static void test_hierarchy(void)
+{
+	u64 parent_cgid, child_cgid;
+	int parent_fd, child_fd;
+	struct bpf_numab *skel;
+
+	parent_fd = test__join_cgroup(CGROUP_PATH);
+	if (!ASSERT_GE(parent_fd, 0, "join_parent_cgroup"))
+		return;
+
+	child_fd = create_and_get_cgroup(CHILD_PATH);
+	if (!ASSERT_GE(child_fd, 0, "create_child_cgroup"))
+		goto cleanup_parent;
+
+	skel = bpf_numab__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	parent_cgid = get_cgroup_id(CGROUP_PATH);
+	child_cgid = get_cgroup_id(CHILD_PATH);
+	if (!ASSERT_GT(parent_cgid, 0, "get_parent_cgid") ||
+	    !ASSERT_GT(child_cgid, 0, "get_child_cgid"))
+		goto cleanup;
+
+	/* The child inherits an ancestor's request untouched. */
+	ASSERT_EQ(numab_set(skel, parent_cgid, NUMAB_TIERING), 0,
+		  "set parent tiering");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_TIERING,
+		  "child inherits");
+
+	/* A request ORs with the ancestor's; NORMAL does not undo TIERING. */
+	ASSERT_EQ(numab_set(skel, child_cgid, NUMAB_NORMAL), 0,
+		  "set child normal");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_NORMAL_TIERING,
+		  "or both");
+
+	/* The child's own opt-out wins. */
+	ASSERT_EQ(numab_set(skel, child_cgid, NUMAB_DISABLED), 0,
+		  "set child disabled");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_DISABLED,
+		  "own opt-out wins");
+
+	/* So does an ancestor's: a task is never forced into balancing. */
+	ASSERT_EQ(numab_set(skel, child_cgid, NUMAB_TIERING), 0,
+		  "set child tiering");
+	ASSERT_EQ(numab_set(skel, parent_cgid, NUMAB_DISABLED), 0,
+		  "set parent disabled");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_DISABLED,
+		  "ancestor opt-out wins");
+
+	/* Unsetting the parent re-exposes the child's own request. */
+	ASSERT_EQ(numab_set(skel, parent_cgid, NUMAB_FOLLOW_SYSTEM), 0,
+		  "unset parent");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_TIERING,
+		  "child request again");
+
+	/* Unsetting the child leaves the chain with no request. */
+	ASSERT_EQ(numab_set(skel, child_cgid, NUMAB_FOLLOW_SYSTEM), 0,
+		  "unset child");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_FOLLOW_SYSTEM,
+		  "no request");
+
+cleanup:
+	bpf_numab__destroy(skel);
+	close(child_fd);
+	remove_cgroup(CHILD_PATH);
+cleanup_parent:
+	close(parent_fd);
+}
+
+void test_bpf_numab(void)
+{
+	if (test__start_subtest("set_get"))
+		test_set_get();
+	if (test__start_subtest("invalid_mode"))
+		test_invalid_mode();
+	if (test__start_subtest("bad_cgid"))
+		test_bad_cgid();
+	if (test__start_subtest("hierarchy"))
+		test_hierarchy();
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_numab.c b/tools/testing/selftests/bpf/progs/bpf_numab.c
new file mode 100644
index 000000000000..b386cbbc19fa
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_numab.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+/* Inputs, set from userspace before each run. */
+long set_cgid;
+long set_mode;
+long get_cgid;
+
+/* Results, read back after each run. */
+long set_ret;
+long get_mode;
+
+extern int bpf_numab_set_mode(u64 cgid, s64 mode) __ksym;
+extern s64 bpf_numab_get_mode(u64 cgid) __ksym;
+
+SEC("syscall")
+int numab_set(void *ctx)
+{
+	set_ret = bpf_numab_set_mode((u64)set_cgid, set_mode);
+	return 0;
+}
+
+SEC("syscall")
+int numab_get(void *ctx)
+{
+	get_mode = bpf_numab_get_mode((u64)get_cgid);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.52.0


