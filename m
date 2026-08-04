Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E67C55172
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C031C6B00B9; Tue,  4 Aug 2026 00:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3D26B00BC; Tue,  4 Aug 2026 00:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACFCA6B00B9; Tue,  4 Aug 2026 00:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 839CA6B00B9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:21:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1246812086F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:21:28 +0000 (UTC)
X-FDA: 85062287856.17.04B4E05
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6155240004
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:21:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hAQpaePe;
	spf=pass (imf11.hostedemail.com: domain of 3xGhxagcKCLUraZgdkZbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--wfelipe.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3xGhxagcKCLUraZgdkZbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785817286;
	b=V5ZP2TfOXNfsNwnHduWbgr4Pav8zQ0+ialB35FykFgxOhVKsLdNBITAaUcjYZqBZljUiCd
	5zQk3tbR9Rykfc+TLrrO3ZooVS+BS1wDcZQtpdI7DFvf6l5DkTMk3ONDYXExm6T60w93pQ
	I94DvLiyNlC2dtviKeVMFu6v+ne6P9E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hAQpaePe;
	spf=pass (imf11.hostedemail.com: domain of 3xGhxagcKCLUraZgdkZbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--wfelipe.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3xGhxagcKCLUraZgdkZbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785817286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c05RDdz6OIqKa9ddqGc6Vs3UmFH3RFQyxs0qMB66mW8=;
	b=j5gmJpXeGwRcVbPdI2zjYatU4iPo+HOaR/dhQSxF2EkmSyzgrBE1rmvdPQDMuLP0KhPhBZ
	DtGtfH1ULj4As61nvcbBTmVHGc68gMRhZQewdwAflLuDbHKlj6X9awv+OLyg7zv1cPuWUC
	/kMzDvWgpQdCmz1Ty64qPNc8ThrY7NU=
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84865f326efso3935461b3a.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 21:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785817285; x=1786422085; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c05RDdz6OIqKa9ddqGc6Vs3UmFH3RFQyxs0qMB66mW8=;
        b=hAQpaePeDGFZCMnjW1ThffA7pCE7Rq8EdTOO5yLupBOmwr7mXhq3OGIp4QjEe6avRW
         IEIGC9MofTTkZN29Qgauk6VfSdVvTxLywjzl42dInV3e7DhHlWMp50wlSVKGkk4dYWaV
         HPb1F0x9gooZuwMoASu3PhZgIiSC4rsBizNBtw6b+y6Gvgnwwq526k2sqJskAUvhSn+X
         /we2DOU5o0U6KJCFID0pcEicI4kOMIkbgpF1fU+h99bHQrOdDRVCbbyt7SO2y/nTk1iR
         PzqCD3EC8mmPrfCLJKrNTfoqryX2sEdJcHCuPbujD+4Z4OInqNMOiYt5zFE7mMcW5bgd
         VucQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785817285; x=1786422085;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c05RDdz6OIqKa9ddqGc6Vs3UmFH3RFQyxs0qMB66mW8=;
        b=R74ybAxdVGoKr+jk+T5ocNj53A1vuvIwu13ymXUaY9WGENIsiqLPUnzxbGLfkNfSwb
         BOfXU9MlO12zFN5muPlB5RP9VjcnEHaOslb7aaQiA4MPqH20Wz8hz3DQQCERAxcjzOif
         Ex917CmHCBHinwbERHV/tZE75BPd/FUmYB8/PfhhyDf1cXyPAo04aftMacZ2xrx4RABm
         NFYp/kAqFechsMEnh9hd4rXH647JSfHIMRovv8DnoS5DSPfjwSMc/WoGZ7hVQNaPCpsm
         Cowsnn3Yf8XLHS0v7nA+De/hs7DF/v4h2BfCSIa0O4wATYPt3nPxshEipGJfCxriJ3xj
         wZKQ==
X-Gm-Message-State: AOJu0YyZAzZgF1rqlZgoONEEsBPGKhYUI17LyjphIIKqsUkqGnIeh0oW
	fZnYROVFHjtHyZVsWsP5LC5uO1Uk0Sevbq+cLKlLFuJ1GC14Vu1dtX7XItn8cJMhotw9Xd47Bcb
	EEniq+ANPSg==
X-Received: from pgay6.prod.google.com ([2002:a05:6a02:4966:b0:c9b:c3d4:2a18])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1791:b0:848:2f71:b65b
 with SMTP id d2e1a72fcca58-84ee49ac7d9mr11925666b3a.70.1785817284851; Mon, 03
 Aug 2026 21:21:24 -0700 (PDT)
Date: Tue,  4 Aug 2026 04:20:44 +0000
In-Reply-To: <20260804042053.56940-1-wfelipe@google.com>
Mime-Version: 1.0
References: <20260804042053.56940-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
Message-ID: <20260804042053.56940-2-wfelipe@google.com>
Subject: [PATCH 1/2] selftests/cgroup: test_zswap: retry subtree_control write
 on EBUSY in test_zswap_writeback
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: zbadue7jepgjkgko81jgtfb6j6h3zazs
X-Rspamd-Queue-Id: 6155240004
X-Rspamd-Server: rspam08
X-HE-Tag: 1785817286-737646
X-HE-Meta: U2FsdGVkX1/mXn9aKxOej1v0Sg4xfaKHZmhc1ccggqHLtOdEjTwA37GKCoxRIVOYXQrfCALGi34KUAcQjFrbs+7HMWVDc2FeNuNufxB6HuL6nGR5KoNbfrcD5jRgyKtLzM5lOzqJuxbiWcCGjgInx6xLxc8XRzMHv/GYqew2uoUuScggaImuhlOTqkUN7s8EQ2zaauSAbAoOJkUfNHZTgCpfkdT1QazjVbPq1NubIjSFL96ricoUUj+qKrbbFY6e9MQUx4W6zrlG/OTl+uCszcRMWX+EuJU7uT4lR3AOgANCy/bnh06XnYygQdd2W9OrcBDmpfnnDTVva3KcA8Ood1dmQRqsqV8WWF7OQma0C2WCCLf7Cdu5rQqCm8no8JDEKIPhs6KpLc9pnS4EWHTGZmExqULFzVOFjqW9PhTev2ddggUqm/LSdROaxK7N21NAdfBXA/Jd9djxujX1RJolT5Bwto/bbq+HXyQOxRS4lGVuE2LfuwFar555mNI3BOrZqIU0+Bq8xwD+c8Ykkwqib766aL+PzvlO2ZN7Oz0ozEFiMJoIRiQLgZHlou1fCvaRnC17POHFpKuuFmZ3IuzxHZwP/BoCILUrRIHxIX/eD60rXHr9U5Y0Klfb7T808mCxD95yQLn2QWWFdHVKFjGvVnAbYeiMwSX1s6f68Pd1i2CvexrCA1Zcy2D6YeXHe026QthpaoCCeNDnzLT0s0voyo2bSRCHrO0lg2/zpKrmyW8qBCzzLhQ1NNKe9jeG93daZL7bgk1lQO8DU1baMzdMPEne0R75OC2xccuX1gmkDZlFo0wKLpAVSGiUtrql7mHck9UmieB3NSZuBZnG3i9B0bkvLQ6AeMFNqAIXFXBqVMcIbdUyNek/0DYCWZsX+wgxEk7ck4BdlO5OmFeO65/o/L1cA7mR810XLLlVLvaDnVrnmvXW3rObTLa+9u7FF4kywquL3Jh+wvEhppU3UQO
 jt5S1we6
 jVQQpA7I2a13+nOs/HAJ1J4MjhYHyxZf1ePxRj1cmso+hiiDCNWvHWSPugFCEJIM+TR21vbbWg4rVASTP70Y468P/iymAF/Uvyr8Cqgtd7Tt8bQYmqMBpV6bqvPCqAf3QwpZWytLEqKPogZQiJXb7f9OWgQ5Q084+pIrlf73VIQWYz7mGWXWC5QHFBSYFaYcXG90/VwM9MgZMHChH1qRHB29Ev96wwREgAmWVKc+HAfnVQUQjpr3xdIIQHff+WQHz7wFawJu36ZJH5nQ+9v38CuSi00ZowpiJRRbsjYzWgXA7eLaIrZLK/tc9OmzACBQtW+lBxjBvnTPWUiPTNJ2dYf01RXFyojTAe7tBEy3ROs7DjMD3ec6+XKAodnPdlYEiL6HbqooYVKfJ0XVY3xu8SaMCUrtMZG8Qddgm50eGylmROVsjP1x2tta+v1N3MNWjl1fBrQKUftQSDeNLEI/mFgXX96bwZIO9OubescFx7/JjQRKQWDN0puJqNNBGsYRVkbx7yaCnkqfMArk8djsZFZ5RKGNPTasVZTwK17D+ykw7oIiGfNBt6mJVTQ52u1QrXKSXU5Bi/FYOyR32RnKBZ4Oz+v5KRBlmZKZv3UnLAao2DbU7nnspdnQXf3qwxe4CUwfs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When running test_zswap on a single-core VM (-smp 1) with 4GB of RAM,
test_zswap_writeback reliably fails on the initial run after boot.

In test_zswap_writeback(), after waitpid() reaps the child process created
by test_zswap_writeback_one(), writing "+memory" to cgroup.subtree_control
can fail with -EBUSY. Under Cgroup v2, enabling domain subtree controllers
is forbidden while any tasks remain in cgroup.procs.

When a child process exits, waitpid() reaps the zombie PID immediately,
but the removal of struct task_struct from the cgroup task list is
performed asynchronously via an RCU callback (release_task). On
single-core systems, this RCU callback is delayed behind CPU softirqs,
causing "+memory" to fail if written immediately after waitpid() returns.

Fix this by adding an EBUSY retry loop with usleep(1000) around cg_write(),
matching the existing cgroup cleanup pattern in cg_destroy().

Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 49b36ee791606..312d51887a1d8 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -407,8 +407,11 @@ static int test_zswap_writeback(const char *root, bool wb)
 	 * Thus, the parent's setting shall be what's in effect. */
 	if (cg_write(test_group, "memory.zswap.max", "max"))
 		goto out;
-	if (cg_write(test_group, "cgroup.subtree_control", "+memory"))
-		goto out;
+	while (cg_write(test_group, "cgroup.subtree_control", "+memory")) {
+		if (errno != EBUSY)
+			goto out;
+		usleep(1000);
+	}
 
 	test_group_child = cg_name(test_group, "zswap_writeback_test_child");
 	if (!test_group_child)
-- 
2.55.0.571.g244d577d93-goog


