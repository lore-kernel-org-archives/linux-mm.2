Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DAEBCA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 12:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606F76B0098; Mon, 12 Oct 2026 08:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B7936B0099; Mon, 12 Oct 2026 08:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE716B009B; Mon, 12 Oct 2026 08:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 263FB6B0098
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:06:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7368160CBB
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:06:32 +0000 (UTC)
X-FDA: 85313847024.01.4C8EE03
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id D910D180002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:06:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BkUObp0A;
	spf=pass (imf24.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791806790;
	b=gjRr06j2wPMePMze9PSHivAcV0/vTPWWiYyjV4lyShiQkAhK6VfkN0Zn/pzhVkJAHLh5K4
	NWdk0e7baaptVvaiKdsgs/MkMQS5mdjHV17waOcVJzvBtmWi6yjSXG8eLO8IPa5K1bmPsY
	9YJWEO533QdCQkrkig/y+uoZx3aml84=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BkUObp0A;
	spf=pass (imf24.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791806790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hy+eARgrFpDT0ZhRfOHwtN1niTEnWD5P7Xvkvc+A7GA=;
	b=fUP1uxDpg4JV44VYJr27z3/msGnbBctKK6qGebvWgG7zJbUIA7uJbCNsqbiSFYORDIDyPB
	zN786jKpGMi6o/QuivB0D+IY/ZBIz7mUMgPKU7GewL/Yi0hRXTBipLSKnrB1eZgqf4/J34
	641ra3x6OvABTmwSYU3ym4auWL1OI5I=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3ab3260b35dso1104657a91.1
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 05:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791806790; x=1792411590; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hy+eARgrFpDT0ZhRfOHwtN1niTEnWD5P7Xvkvc+A7GA=;
        b=BkUObp0ATDQNjQM0/vtbRQh0Ev6LXY7BU/V41R9JSl60aYwxGdBarapfou0bZ6TCMa
         7UNgDTbZmbjXLOslZIenqmjjsNXtXb8H1QjT/fsUcLY1TxNDtVBp32QvV97MxjDPRdhh
         RyOzJYO8OhyiaoS82CmjjKw1S24x72Kt+Dli7+Aybxsq7NXn957zgU/47ACupFkUSUSY
         Gbn2LirCekmZyU02dtCha/pGKlYO48XVklCudjsUUMX09p5wKfGaOyv40I9OcIHThbFV
         DYZeXeZfTmjkvvfsssOidMIXeXnnIZh7MVoDdGq4H7STq5dgqJTR3MFAFYohpsp8oXDN
         O/GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791806790; x=1792411590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hy+eARgrFpDT0ZhRfOHwtN1niTEnWD5P7Xvkvc+A7GA=;
        b=cW84FWIxvQAJP/fj2cU80GkndYQ4mi28QV0Edx39USd3gVyzzVf2N5hX+dQx8JbrRz
         5MvpL6336iK2OZcvo8ryrxUS7VnuDsidgGPBxvhxcPdK/j4kFA2NdixFVCou0LRqk4Q5
         ONWOehmBtrOC69UBa9d1/xYtIU/22oDZRSAQfDH4Ll9Xil/hWsSJ4+HytlZwi6rCQgpD
         QRh5Qj5L4kHesbNYukTMZtAPW7EN9lrJzIppcWorPEkXpzKxZ9jy9TErcty7HxByrucO
         EJHAuvLtRzXrLFbp6fI9qxeB55ES/Er5rixerwiCvY7C6X5IMGHs+MnAZ0L3hEQuxc1r
         pG1Q==
X-Forwarded-Encrypted: i=1; AKwUvBzHqqvR3pztMtQIJJipa+P0v1lgel7IWtxDmfq9sRUHKntjpxqx5qOq6YXYMGl/i7fy5kdomhwW8g==@kvack.org
X-Gm-Message-State: AFq9FYIVS5nHy2FrVfR0nHrV867Lv0UPUq/ZlqSRwF/Et3kURQ3x0E8v
	whoHpUx/hY5Z/YP46mJbwg4hX66XOE3zrjON3YjK8gHH+rXICZyqgSSg
X-Gm-Gg: AYBFou2YFRMcGQAoYLAmDFE1VCo3IakXaQCj7LFM6N1gOKhf5bBi2L3ycgE8hS/puv9
	SIClFxpO0ZW5upBNHpq050MCQt9cvJwyEZp0Yz8hGKL/cSfMtcr1dZ+LDpZCceF+pb1+LYVP+lL
	X8guY6OH6/uupW7EYfio59Dt05AYndlCt2sSr7eQuZMShZFBCYVcQRXk0A3+szx8LD480WkSiF0
	No6v6kxqzTv7TxcHEJtRJ7U0z0sN10+lJA36Uqbz3HJGQcxtJB0N3UnEpB+V/Qeor0j/7nzrfdE
	CTfxhm1pD76iR4RrRuuiU8bXbyZ2V3/tKtoF+L0DtUWzYjsCQ5Et/IVuNykWIzRYz0rEnjsH9jg
	JCPkMbOZQTVFRR5CyRmQ+tJub5eJRHXZ+c5BhzUrvRt2q92bpMWklnnp9lOUwbCYrkUUM7c944y
	Qc3ZcE8UvQ7sog4psqU9R9CO+iR8plAW4FnmFD9n2Cne/HF482WApF0ElviGWge1hdirjn3rSMs
	iFfV0q3F2yGxr4MmN+efuFWlTNA5nn4lXHXGQln6fSxfKFvFLGqQPDa
X-Received: by 2002:a17:90b:5444:b0:3a7:9ad9:68e1 with SMTP id 98e67ed59e1d1-3ab3a735fddmr8030646a91.13.1791806789634;
        Mon, 12 Oct 2026 05:06:29 -0700 (PDT)
Received: from yafangs-Air ([101.82.170.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab371c32cesm15722454a91.16.2026.10.12.05.06.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 12 Oct 2026 05:06:29 -0700 (PDT)
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
	zhao1.liu@intel.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v2 3/3] selftests/bpf: add tests for the bpf_numab_ops struct_ops
Date: Mon, 12 Oct 2026 20:04:38 +0800
Message-ID: <20261012120438.52849-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261012120438.52849-1-laoar.shao@gmail.com>
References: <20261012120438.52849-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D910D180002
X-Rspam-User: 
X-Stat-Signature: n934r7r8y99jkju6tdp7ysx6rx1y835b
X-HE-Tag: 1791806790-278262
X-HE-Meta: U2FsdGVkX18HuP+X2A9kIXiFhFZ6Wjsx23q1diB0W3gcG29rxojLaqPGMtbk7Q0+UfB5gdDcFeCXoHmsGfruP4LS+DToTEuQwcvos8nwJlrNrXgRmSqY+Oc2XssKNp+S4O+9Z6D0luXe7q7GE6cF8AlB1qTV/T4dR2xtuVtlmEIrk6uNCeNXJTCrXNSN0y1lc0+VPqqMHYWkLx4iWuOEgv5gWq23L4y0kuDvXj0tjOtbcvOYyZEqI9Xy7zonl/7m/riT4jP0AcRSnvvbgriXTsX7S7BVLEKHy77SKRx5iTKiOBVOrLVXGzMzA61H6mdMqR9slYtgRHU1DWC8oW1UsyMg7NyZypb1TxhQ9s2UcwKiWKC/bk/iDvLDNCsEHLjKs3zafq8wyh/5zVnqwxmNZZpluNLm+TYaQI6JlgY1nIt05drQ7awzldiw09RCDvPV99jog8uSR+FFD3rEB0oV5EeOEZauUkdNtKoFJY+DVbJjj4SUodrb2WnGCJfFp4wMGUIGRnfg35CS9yL40RjVDx76S2hyjxS8CDglbk+zL/1FONsoflXBXW3xip/12ftihiBQ4/v7H88KJnnIOyZuf+dj4EU1ikswDWvp/Dz1Zc9rqvIazCjV7vyzvnOGCEKG+ctzG0MNs74n6dDIpOM4WIuxhz7rgSTG+TuNvFGyo2cvp750/broUiSkSqL4nQVOMLV2+Kbbae5dSN6qyGfs9C7zTSYupaCSyp+HuxsP42KIZr6Owfd103egPSFdoH0sWzZWWoOo9Fjlu59gx0a2HortH05XICCej/jHeVPwd7sxEDQGOnQi+PZfwEIFEg6RMr/sKh8Xi92ga0F/60hwQYKNT3Gaytr2HBM2iblEFUDB/T0PjDFZgnSBCvd8ZPo3L9qnNq1QUDjyiFtmIHBE0wRmAz0gcJVSAawSyIxzjV1QXOcJO4NHsoclnDfHypebJ95dKHAMoU2fJxWHDgP
 Vs9fhwDb
 Hjz5KJ52mvjFmtwRJQIrNoUfIuFUSBDdSS7b8Qf5EtPRIfTsLBFoUczc8PN7fbWtm9b0aDwyaDeUB+qmAF0lbrW1eQren8tSQEVaGY2Xa8FzEAwoWfsgw8lwg6DsfnBOUGB/DFxRhFAf3pO8N12lK3A6C7jJAaCCXnIRmRbzPi/40zO9xr1HCagMy0o3PAEgVXQt0M+Si8GQTnjkZyHC4q+OI/woYkBNBcsGgNfESmmzcphqFIphZFceNy5ZUwoVSilv6mA5rMYqg2C8Ib5C6AoMI90eMQTRoxdKnTt0MEAFo52pkDMoxxnkPqOxth5Y9Sn9ec648LjJlHgpcyluGOJGVMnHb8geo9ty+KCh61MHJWmbG4PY6a7qnfqmehdFuT7JtpVpa8P8u1cdWxvY0AmIw6tQQRtz2o5lXMxUJXoaPe6f0rVqg4wA8TngYHFXzBI7hk9Ia8KEt0RaW+nsd0VvwlMdRjnX5k4/sfiNqn2YH1F07IiwJ6gevgifP9p3OW+ofF2TNIEUpiajH1epBFSszRVX7F5rTu5Yx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Five cases:
- attach/detach with counter proof
- hierarchy aggregation
- multi-policy combination
- inheritance
- a surface-dispatching policy

Assisted-by: LLM
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../selftests/bpf/prog_tests/bpf_numab_ops.c  | 250 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_numab_ops.c       |  57 ++++
 2 files changed, 307 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_numab_ops.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_numab_ops.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_numab_ops.c b/tools/testing/selftests/bpf/prog_tests/bpf_numab_ops.c
new file mode 100644
index 000000000000..3e5dac8e3131
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_numab_ops.c
@@ -0,0 +1,250 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include <time.h>
+#include "cgroup_helpers.h"
+#include "bpf_numab_ops.skel.h"
+
+#define CGROUP_PATH	"/bpf_numab_ops"
+#define CHILD_PATH	CGROUP_PATH "/child"
+
+/*
+ * task_tick_fair() consults the per-cgroup NUMA balancing policy on every
+ * tick of a running task, so a short busy loop is enough to prove that the
+ * hook runs. This works regardless of the global numa_balancing sysctl
+ * state and regardless of the machine's NUMA topology: both the enabled
+ * and disabled code paths end up calling every attached policy.
+ */
+static void burn_cpu_ms(int ms)
+{
+	struct timespec now;
+	u64 deadline;
+
+	clock_gettime(CLOCK_MONOTONIC, &now);
+	deadline = now.tv_sec * 1000ULL + now.tv_nsec / 1000000ULL + ms;
+
+	do {
+		clock_gettime(CLOCK_MONOTONIC, &now);
+	} while (now.tv_sec * 1000ULL + now.tv_nsec / 1000000ULL < deadline);
+}
+
+static void test_attach_detach(void)
+{
+	struct bpf_numab_ops *skel;
+	struct bpf_link *link = NULL;
+	int cgroup_fd, before;
+
+	cgroup_fd = test__join_cgroup(CGROUP_PATH);
+	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
+		return;
+
+	skel = bpf_numab_ops__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	link = bpf_map__attach_cgroup_opts(skel->maps.numab_enable_ops,
+					   cgroup_fd, NULL);
+	if (!ASSERT_OK_PTR(link, "attach_enable_ops"))
+		goto cleanup;
+
+	skel->bss->enable_cnt = 0;
+	burn_cpu_ms(300);
+	ASSERT_GT(skel->bss->enable_cnt, 0, "enable_cnt");
+
+	/*
+	 * Detach and let a grace period pass so that no reader is still
+	 * walking the old effective array, then verify the hook stopped
+	 * running.
+	 */
+	before = skel->bss->enable_cnt;
+	bpf_link__destroy(link);
+	link = NULL;
+	sleep(1);
+	burn_cpu_ms(300);
+	ASSERT_EQ(skel->bss->enable_cnt, before, "enable_cnt_after_detach");
+
+cleanup:
+	bpf_link__destroy(link);
+	bpf_numab_ops__destroy(skel);
+	close(cgroup_fd);
+}
+
+/*
+ * Attach to the parent cgroup while the task lives in the child: the
+ * child's effective array must aggregate the parent's policy.
+ */
+static void test_hierarchy(void)
+{
+	struct bpf_numab_ops *skel;
+	struct bpf_link *plink = NULL;
+	int parent_fd, child_fd = -1;
+
+	parent_fd = test__join_cgroup(CGROUP_PATH);
+	if (!ASSERT_GE(parent_fd, 0, "join_parent_cgroup"))
+		return;
+
+	child_fd = create_and_get_cgroup(CHILD_PATH);
+	if (!ASSERT_GE(child_fd, 0, "create_child_cgroup"))
+		goto cleanup;
+
+	if (!ASSERT_OK(join_cgroup(CHILD_PATH), "join_child_cgroup"))
+		goto cleanup;
+
+	skel = bpf_numab_ops__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	plink = bpf_map__attach_cgroup_opts(skel->maps.numab_enable_ops,
+					    parent_fd, NULL);
+	if (!ASSERT_OK_PTR(plink, "attach_to_parent"))
+		goto cleanup;
+
+	skel->bss->enable_cnt = 0;
+	burn_cpu_ms(300);
+	ASSERT_GT(skel->bss->enable_cnt, 0, "enable_cnt_from_parent_policy");
+
+cleanup:
+	bpf_link__destroy(plink);
+	bpf_numab_ops__destroy(skel);
+	if (child_fd >= 0) {
+		close(child_fd);
+		join_cgroup(CGROUP_PATH);
+		remove_cgroup(CHILD_PATH);
+	}
+	close(parent_fd);
+}
+
+/*
+ * Attach two policies to the same cgroup. Both must run: the kernel
+ * combines what they return.
+ */
+static void test_multi(void)
+{
+	struct bpf_numab_ops *skel;
+	struct bpf_link *link1 = NULL, *link2 = NULL;
+	int cgroup_fd;
+
+	cgroup_fd = test__join_cgroup(CGROUP_PATH);
+	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
+		return;
+
+	skel = bpf_numab_ops__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	link1 = bpf_map__attach_cgroup_opts(skel->maps.numab_enable_ops,
+					    cgroup_fd, NULL);
+	if (!ASSERT_OK_PTR(link1, "attach_enable_ops"))
+		goto cleanup;
+
+	link2 = bpf_map__attach_cgroup_opts(skel->maps.numab_disable_ops,
+					    cgroup_fd, NULL);
+	if (!ASSERT_OK_PTR(link2, "attach_disable_ops"))
+		goto cleanup;
+
+	skel->bss->enable_cnt = 0;
+	skel->bss->disable_cnt = 0;
+	burn_cpu_ms(300);
+	ASSERT_GT(skel->bss->enable_cnt, 0, "enable_cnt");
+	ASSERT_GT(skel->bss->disable_cnt, 0, "disable_cnt");
+
+cleanup:
+	bpf_link__destroy(link2);
+	bpf_link__destroy(link1);
+	bpf_numab_ops__destroy(skel);
+	close(cgroup_fd);
+}
+
+/*
+ * Attach to the parent first, then create and join the child cgroup. The
+ * child must inherit the parent's effective array via cgroup_bpf_inherit().
+ */
+static void test_inherit(void)
+{
+	struct bpf_numab_ops *skel;
+	struct bpf_link *plink = NULL;
+	int parent_fd, child_fd = -1;
+
+	parent_fd = test__join_cgroup(CGROUP_PATH);
+	if (!ASSERT_GE(parent_fd, 0, "join_parent_cgroup"))
+		return;
+
+	skel = bpf_numab_ops__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	plink = bpf_map__attach_cgroup_opts(skel->maps.numab_enable_ops,
+					    parent_fd, NULL);
+	if (!ASSERT_OK_PTR(plink, "attach_to_parent"))
+		goto cleanup;
+
+	child_fd = create_and_get_cgroup(CHILD_PATH);
+	if (!ASSERT_GE(child_fd, 0, "create_child_cgroup"))
+		goto cleanup;
+
+	if (!ASSERT_OK(join_cgroup(CHILD_PATH), "join_child_cgroup"))
+		goto cleanup;
+
+	skel->bss->enable_cnt = 0;
+	burn_cpu_ms(300);
+	ASSERT_GT(skel->bss->enable_cnt, 0, "enable_cnt_inherited");
+
+cleanup:
+	bpf_link__destroy(plink);
+	bpf_numab_ops__destroy(skel);
+	if (child_fd >= 0) {
+		close(child_fd);
+		join_cgroup(CGROUP_PATH);
+		remove_cgroup(CHILD_PATH);
+	}
+	close(parent_fd);
+}
+
+/*
+ * A surface-dispatching policy must load, attach and run from the task
+ * surface.  The folio surface runs from the scanner and fault paths,
+ * which need a scan pass and foreign-node folios to consult, so folio_cnt
+ * is left for debugging rather than asserted here.
+ */
+static void test_mixed(void)
+{
+	struct bpf_numab_ops *skel;
+	struct bpf_link *link = NULL;
+	int cgroup_fd;
+
+	cgroup_fd = test__join_cgroup(CGROUP_PATH);
+	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
+		return;
+
+	skel = bpf_numab_ops__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	link = bpf_map__attach_cgroup_opts(skel->maps.numab_mixed_ops,
+					   cgroup_fd, NULL);
+	if (!ASSERT_OK_PTR(link, "attach_mixed_ops"))
+		goto cleanup;
+
+	skel->bss->task_cnt = 0;
+	burn_cpu_ms(300);
+	ASSERT_GT(skel->bss->task_cnt, 0, "task_cnt");
+
+cleanup:
+	bpf_link__destroy(link);
+	bpf_numab_ops__destroy(skel);
+	close(cgroup_fd);
+}
+
+void serial_test_bpf_numab_ops(void)
+{
+	if (test__start_subtest("attach_detach"))
+		test_attach_detach();
+	if (test__start_subtest("hierarchy"))
+		test_hierarchy();
+	if (test__start_subtest("multi"))
+		test_multi();
+	if (test__start_subtest("mixed"))
+		test_mixed();
+	if (test__start_subtest("inherit"))
+		test_inherit();
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_numab_ops.c b/tools/testing/selftests/bpf/progs/bpf_numab_ops.c
new file mode 100644
index 000000000000..c9abff2cd694
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_numab_ops.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+/* Counters, bumped from the NUMA balancing hot paths. */
+int enable_cnt;
+int disable_cnt;
+int task_cnt;
+int folio_cnt;
+
+SEC("struct_ops")
+u32 BPF_PROG(numab_mode_enable, struct task_struct *p, struct folio *folio)
+{
+	__sync_fetch_and_add(&enable_cnt, 1);
+	return BPF_NUMAB_NORMAL;
+}
+
+SEC(".struct_ops.link")
+struct bpf_numab_ops numab_enable_ops = {
+	.numab_mode = (void *)numab_mode_enable,
+};
+
+SEC("struct_ops")
+u32 BPF_PROG(numab_mode_disable, struct task_struct *p, struct folio *folio)
+{
+	__sync_fetch_and_add(&disable_cnt, 1);
+	return BPF_NUMAB_DISABLED;
+}
+
+SEC(".struct_ops.link")
+struct bpf_numab_ops numab_disable_ops = {
+	.numab_mode = (void *)numab_mode_disable,
+};
+
+/*
+ * A surface-dispatching policy: exactly one of @p and @folio is set, so
+ * the prog answers the task surface and the memory surface separately.
+ */
+SEC("struct_ops")
+u32 BPF_PROG(numab_mode_mixed, struct task_struct *p, struct folio *folio)
+{
+	if (p) {
+		__sync_fetch_and_add(&task_cnt, 1);
+		return BPF_NUMAB_NORMAL;
+	}
+	__sync_fetch_and_add(&folio_cnt, 1);
+	return BPF_NUMAB_TIERING;
+}
+
+SEC(".struct_ops.link")
+struct bpf_numab_ops numab_mixed_ops = {
+	.numab_mode = (void *)numab_mode_mixed,
+};
+
+char _license[] SEC("license") = "GPL";
-- 
2.52.0


