Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC84ECCD184
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 03:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272A18E000D; Sun, 19 Oct 2025 23:17:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 249F88E0002; Sun, 19 Oct 2025 23:17:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138F68E000D; Sun, 19 Oct 2025 23:17:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F40798E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 23:17:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AADD4160709
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:17:49 +0000 (UTC)
X-FDA: 84017033058.01.5B15CCA
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id C8D2340008
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:17:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jVmtrO2f;
	spf=pass (imf12.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760930267; a=rsa-sha256;
	cv=none;
	b=0zz1wB7qD6/+o81rFPjM6OzG7N4yUA3aItHEj0U7t4lD0Xc0NZLRxRX0z7DOeJAHL6HgC4
	axNlS2PL++9eOiYXH3P2tGQLVXy78LHCk+73BRm0rvUELjj+FSZhuHfXCdArS6YlNb/nyv
	bTVorDuxVeXIEE6mm9/qYoAKYB5j/HQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jVmtrO2f;
	spf=pass (imf12.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760930267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4o89aqQquJfXg8DHNFFwhPZpHBrXkamiWZUkDvNw/U=;
	b=mLeBLuqLiZolNJGdzaHXWMwh3sngCkWZaXxFbP9OsHXKh1XTR81H5HFXXUJoovwtoX1l1l
	pbpQX4hVzIwSnetSU57f0zzkor4M0xTEnDi0N2JRpKv5zHZKEP3uecfrZdxl9S294ZS521
	KCZgKUcScqPhqjnriUx0mgVojFcLckI=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b553412a19bso2615519a12.1
        for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760930267; x=1761535067; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V4o89aqQquJfXg8DHNFFwhPZpHBrXkamiWZUkDvNw/U=;
        b=jVmtrO2ffLmlI1isUjXDpZ5B3cK2gG5/Un1ZffbK1cqhwNIufyQG9rvYwLMctlImk8
         /mSZ9fQdVW3tTmM/NiqQl/YE8hSMlQBMABmkHQjkJ/0617fUDSPtinQIQJliyS3lLoAU
         DPH8AHepi0YfOfA8LUkIyn1dvJtgRipLWS3Xe4XzcpF1V5qNeO7cJaod0lcDfcByG9mO
         st42qCCh6uJCtwQcfruScsb4KlfUWWN6ydFYj3pdjrPGAXiLW44JJpyx0Crjl4LJuahI
         bE28540PjLiikxHJMhj62OlEtlHSIksdxGWPpeSQxUKaphhHP55iLZop5zhkin0dkpAg
         V9Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760930267; x=1761535067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V4o89aqQquJfXg8DHNFFwhPZpHBrXkamiWZUkDvNw/U=;
        b=XYJtX7Xi5eDneJy/msUbcyMcWf5RdgH9qccFo7WOCoR9yKHf4LX2Hup1q0iPqwy3Tg
         8PmEsP1DsTFZDUq4oZ5WAByHYdbgbGHbMf23sPka3QENLG6GYJIEfCidouPnhbzmabz9
         UVianatQD0SfxMB3EEZRNETwNJyawfR6whQLF8FiudNLnB0Eildh+qkqiEYTibDg7v0X
         P52uP4t7G4U29jEijmDFXY/dtdHz6b8W6wfB63djd4p5crUTYVhR1oYq2o/j8q+HU2E/
         gIPxcqLVGpAw8xYJ4jVCQHGLxAOJY42fjECi+5bGRyOEgvOlkoatG/JtP9qyteBur6Nd
         j89w==
X-Forwarded-Encrypted: i=1; AJvYcCXvVwnaplGrzNb1ToYclRZHsNA5ia+nGQBgwGXz/HxSbSwFIA8qrLGK5eck0eb5tGNWN4U8LbXByQ==@kvack.org
X-Gm-Message-State: AOJu0YyP7k/u7R0ql5Y/pyhO4eDxHOn8NPKkD7nXc/nQ13B5ZSFaGnJ+
	uaAxXBetTSiH3a2y4eWodSR/b613wX6AjxeTL/fBqRsUlXmnxQMeuBWu
X-Gm-Gg: ASbGncupz+amSeRZdx9gJm1LbhCsJ1Fu76v1rxf3hBL/fCiEX3Yc+BVVQBZtwWD5V6R
	XkIfJvlSBJuRER6s9OVVKzJAFa8yj1QMZqsRtqqPlNG+4ljSEZyLLGzc2FEJnf6n6+SPiWi19Be
	tSkOZMapbTMZXrl/tTnCj8vb7slCmSL9cifG38rGm5RNS0gQkXQIDtFUkHai0VX4Xk8cgHF1zkm
	kawIMhcwpO36jQ//6PsPqp9SYLOG50NbPMIbZ6BjV49IBZtvbT5leG1ZhBKAdMblpiJmkNooAj+
	6mmRUcoFIr3A32jdxm4grSYs8ggqVJyVLsS19cLNyVG/8IK2ifh8HIoBIzEQiH6rDoyEqYezBFj
	TfkeZerKNTjobKceqUFDPXmJLUNlXl4okcj0Ph7auD45pKDTFH7jfyBd+116xd8Vo+nLI27dkW7
	6RiQewvNyqyvgz3Q9I/B1tfZG6AjoKxxggqPciEw8Egtg52w==
X-Google-Smtp-Source: AGHT+IGalCyWkc7C8LmPCGO9urIs1Pwdm8eNflQX/0Ho3b+S9hSSF1w5msjDxjkD1RQDifOCduychw==
X-Received: by 2002:a17:902:d50f:b0:27d:69cc:990 with SMTP id d9443c01a7336-290cb27e0bfmr152822005ad.49.1760930266552;
        Sun, 19 Oct 2025 20:17:46 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1da1:a41d:3815:5989:6e28:9b6d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471fddfesm66373435ad.88.2025.10.19.20.17.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Oct 2025 20:17:46 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	david@redhat.com,
	ziy@nvidia.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
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
Subject: [PATCH v11 mm-new 09/10] selftests/bpf: add test case to update THP policy
Date: Mon, 20 Oct 2025 11:16:54 +0800
Message-Id: <20251020031655.1093-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251020031655.1093-1-laoar.shao@gmail.com>
References: <20251020031655.1093-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kxezbmuqw9psfo44zdcox8bsgr7jmkbc
X-Rspamd-Queue-Id: C8D2340008
X-Rspamd-Server: rspam09
X-HE-Tag: 1760930267-982992
X-HE-Meta: U2FsdGVkX1+qWydjw4gHYPV5OvCefFgeXHP/D2IhCgzzYPPVinVVEFknQk7QGR6a1yYoKU0lJeen30acC7WdCX7Pd2VeCANwwHPdL/LzLmUw0XtP0KIm1hc93fE7dkbpfX4gFsdSXeQChUnZvwL74BrCeM6bkvE0dxCM6CSISCBJIu6i/bBEYB4sMAkquOyWNue8zIPmwZpWESlVy6CfN3kwWH6p1rcO/yVhxdP8+9D+93ciWLMgEXEAFd6/2bv8iKvBj57OaOsSfcn62naXXierk/LuHOA77Nut08cfcZjyVOQz6PjQQ94CkyS1ieELKLWNmMEZ9sqyQL+HrmdrsPWKnOy3PICJ3BE90kNf+ii8sLMgQ1gzZKOZ5GHYhEjshYfkaGsnp2V2xYuHP7vB6/M1IJU5JsBFLOkSHqJyQuxu5lxSyNhaGilheDHktOdbU3LYqamzGmdy2XPF2YoPbvndGn48s/qjkK5l27bY9YTamIn8joaukrI4LOvURGxyDhQx0eXtDf+5KPZm/9cHskK4eYdmpA7XwsCfqmCr6Av4gZkfKtLZLk8U4r2dqY05Sjo+yvpy1frR6ofZu3Kfjrharzd+vHEngyLHax9NAfpW5NYDkcX5VAqnwnlldO/mwpkUANOmybDaW41rap0XD2i7WiGcfPhSP7D5Uo/4lfKuEaKfEy03CmnnYESjQmmbBKFX3QkFCbNPQTin1k43q4Tc9W85IB6s8qqo+BhFNEydhX01BTzFT85nQQNPrQTMFMFgTEOkmHO7iU3+rBjVzufh48MsX2W8oxtQ1fPbNDHIS/+hxjj4Jzt8WuXKcwQUDrLBg1MP5os++81bI8yqGrfCW/BIRM6pGCZEy/QOCkGsuI6aW4fqomnxm3Vj08/W0suNCDsMrdGRImCGI9eEqv8SCNX18DGC011lfmG7AU8fEoSSolBbXPCpWtbhIq420dtA8sKo3ujLYHlB+Dp
 jLDswcsM
 xaRH3+00nLSEJPKv1u1hd3jO6P5DAIBk/fMSv3AednMlyek2pn4yECbq+5C0KrDh9Njgjo+Rmei53/6qTLBD4GVeX6iynhUsqst+sdx3h3xEmPFbNMLNvllqeKQAd/11zMqYDPZcdFxGO3LUMOIQJR+6PYwT5qknhFFmoNgyUMXaTyPFh+hd8iy0Zt0zTRm1r6H6gWpc628EZES7l+S5FSzixA+oWZlJJu4LcOP6cnR7PHcOBB7XHOnkLPhA1SYoQyLfaOvuxwYBeoaDTyGkM3YyiGuGxLPHzcyy0hdqa/5KOStDrnitTVNb9tHfdYsnGWp2iStrdj/lUwde9g50CO2/lxbUnpIhaAr7NzhNYPqe4vUfqrkECZzDCqt+bj+9lTvd9zC5ncjnFUSX2PlgFOYAXAd/CjVVVusMJ7lzppIWgXRpn5GFt3TfUdBXUrm4SKlrEvDm9x423v3MXOLvzElx3BpcSwdTHiAj3uvfDpnuC1/Hn9zrgMyfQ2PmtK+zb6q8yQ3sxJw5e0dA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This test case exercises the BPF THP update mechanism by modifying an
existing policy. The behavior confirms that:
- EBUSY error occurs when attempting to install a BPF program on a process
  that already has an active BPF program
- Updates to currently running programs are successfully processed
- Local prog can't be updated by a global prog
- Global prog can't be updated by a local prog
- Global prog can be attached even if there's a local prog
- Local prog can't be attached if there's a global prog

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../selftests/bpf/prog_tests/thp_adjust.c     | 79 +++++++++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     | 29 +++++++
 2 files changed, 108 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
index 2b23e2d08092..0d570cee9006 100644
--- a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -194,6 +194,79 @@ static void subtest_thp_eligible(void)
 	bpf_link__destroy(ops_link);
 }
 
+static void subtest_thp_policy_update(void)
+{
+	struct bpf_link *old_link, *new_link;
+	int elighble, err, pid;
+	char *ptr;
+
+	pid = getpid();
+	ptr = thp_alloc();
+
+	old_link = bpf_map__attach_struct_ops(skel->maps.thp_eligible_ops);
+	if (!ASSERT_OK_PTR(old_link, "attach_old_link"))
+		goto free;
+
+	elighble = get_thp_eligible(pid, (unsigned long)ptr);
+	ASSERT_EQ(elighble, 0, "THPeligible");
+
+	/* Attach multi BPF-THP to a single process is rejected. */
+	new_link = bpf_map__attach_struct_ops(skel->maps.thp_eligible_ops2);
+	if (!ASSERT_NULL(new_link, "attach_new_link"))
+		goto destory_old;
+	ASSERT_EQ(errno, EBUSY, "attach_new_link");
+
+	elighble = get_thp_eligible(pid, (unsigned long)ptr);
+	ASSERT_EQ(elighble, 0, "THPeligible");
+
+	err = bpf_link__update_map(old_link, skel->maps.thp_eligible_ops2);
+	ASSERT_EQ(err, 0, "update_old_link");
+
+	elighble = get_thp_eligible(pid, (unsigned long)ptr);
+	ASSERT_EQ(elighble, 1, "THPeligible");
+
+	/* Per process prog can't be update by a global prog */
+	err = bpf_link__update_map(old_link, skel->maps.swap_ops);
+	ASSERT_EQ(err, -EINVAL, "update_old_link");
+
+destory_old:
+	bpf_link__destroy(old_link);
+free:
+	thp_free(ptr);
+}
+
+static void subtest_thp_global_policy(void)
+{
+	struct bpf_link *local_link, *global_link;
+	int err;
+
+	local_link = bpf_map__attach_struct_ops(skel->maps.thp_eligible_ops);
+	if (!ASSERT_OK_PTR(local_link, "attach_local_link"))
+		return;
+
+	/* global prog can be attached even if there is a local prog */
+	global_link = bpf_map__attach_struct_ops(skel->maps.swap_ops);
+	if (!ASSERT_OK_PTR(global_link, "attach_global_link")) {
+		bpf_link__destroy(local_link);
+		return;
+	}
+
+	bpf_link__destroy(local_link);
+
+	/* local prog can't be attaached if there is a global prog */
+	local_link = bpf_map__attach_struct_ops(skel->maps.thp_eligible_ops);
+	if (!ASSERT_NULL(local_link, "attach_new_link"))
+		goto destory_global;
+	ASSERT_EQ(errno, EBUSY, "attach_new_link");
+
+	/* global prog can't be updated by a local prog */
+	err = bpf_link__update_map(global_link, skel->maps.thp_eligible_ops);
+	ASSERT_EQ(err, -EINVAL, "update_old_link");
+
+destory_global:
+	bpf_link__destroy(global_link);
+}
+
 static int thp_adjust_setup(void)
 {
 	int err = -1, pmd_order;
@@ -214,6 +287,8 @@ static int thp_adjust_setup(void)
 
 	skel->bss->pmd_order = pmd_order;
 	skel->struct_ops.thp_eligible_ops->pid = getpid();
+	skel->struct_ops.thp_eligible_ops2->pid = getpid();
+	/* swap_ops is a global prog since its pid is not set. */
 
 	err = test_thp_adjust__load(skel);
 	if (!ASSERT_OK(err, "load"))
@@ -240,6 +315,10 @@ void test_thp_adjust(void)
 
 	if (test__start_subtest("thp_eligible"))
 		subtest_thp_eligible();
+	if (test__start_subtest("policy_update"))
+		subtest_thp_policy_update();
+	if (test__start_subtest("global_policy"))
+		subtest_thp_global_policy();
 
 	thp_adjust_destroy();
 }
diff --git a/tools/testing/selftests/bpf/progs/test_thp_adjust.c b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
index b180a7f9b923..44648326819a 100644
--- a/tools/testing/selftests/bpf/progs/test_thp_adjust.c
+++ b/tools/testing/selftests/bpf/progs/test_thp_adjust.c
@@ -22,3 +22,32 @@ SEC(".struct_ops.link")
 struct bpf_thp_ops thp_eligible_ops = {
 	.thp_get_order = (void *)thp_not_eligible,
 };
+
+SEC("struct_ops/thp_get_order")
+int BPF_PROG(thp_eligible, struct vm_area_struct *vma, enum tva_type type,
+	     unsigned long orders)
+{
+	/* THPeligible in /proc/pid/smaps is 1 */
+	if (type == TVA_SMAPS)
+		return pmd_order;
+	return pmd_order;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops thp_eligible_ops2 = {
+	.thp_get_order = (void *)thp_eligible,
+};
+
+SEC("struct_ops/thp_get_order")
+int BPF_PROG(alloc_not_in_swap, struct vm_area_struct *vma, enum tva_type type,
+	     unsigned long orders)
+{
+	if (type == TVA_SWAP_PAGEFAULT)
+		return 0;
+	return -1;
+}
+
+SEC(".struct_ops.link")
+struct bpf_thp_ops swap_ops = {
+	.thp_get_order = (void *)alloc_not_in_swap,
+};
-- 
2.47.3


