Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEE10CCD184
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 03:21:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B068E000E; Sun, 19 Oct 2025 23:21:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 362E38E0002; Sun, 19 Oct 2025 23:21:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2786E8E000E; Sun, 19 Oct 2025 23:21:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15C0E8E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 23:21:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD23FBAC75
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:21:02 +0000 (UTC)
X-FDA: 84017041164.09.0B444AF
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2577D100003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:21:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ADX6yUBt;
	spf=pass (imf05.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760930461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wHI9VYRgU9NCjspHIFvlmxvN8Co/N4RqDwPEZAFmUys=;
	b=783DZil5PqT97MiKZjUETCkaj9qGWi9vwvCs5uRma/S1EaY4EkGjBK8cl9iMQ9EiiqJKxQ
	q2wR15kAOv+ds4jD03l6dIcyRCma61AqF+XRQFOldZAWWYXh8N80efaNe+Bog45vJRrPKE
	yBsxmDG3q9B85U+zg/FBgVFQSK6Ck58=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ADX6yUBt;
	spf=pass (imf05.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760930461; a=rsa-sha256;
	cv=none;
	b=3qBPWguFneQLt4RB0JvHVRKsIpaqck1inlcHzbBFPWXgy9csFGZppXju7JikmK3u2PdO6N
	ezJgcQTA2sm90LBmoqh3FUFLmih857G6Zy0hTi8vRPeGGUsJy2c0nqAST96vXmrJT1OHT+
	Doc+7xuG1tFSC4brd4fO9Wcx6MQkDKU=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-796f9a8a088so3606788b3a.1
        for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760930460; x=1761535260; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wHI9VYRgU9NCjspHIFvlmxvN8Co/N4RqDwPEZAFmUys=;
        b=ADX6yUBtl4oydbQh/8NFntb6UMCZGWi4sKtJR76HuUIGc8ePA+0qIWoynP1rxO6LVC
         hc/nC6w9PyK4PjGziKpRMlA3pRtPwQV4Doya3E8YTrzNn9JrL03iB5wBI/vj4KYOT5DY
         B5mM/IKoH3dt2pKChehHtEFB+MsBVn2KjC+l8uuVrtgu1dmgQcc/GZ0c3/sbpsfrtTw+
         xdKYQAL5oFYzqF15j7Z79i6kpO0kZz/AWB/j19CerG4RPD2gnKV/F2FVE4UQxJ6oYguM
         5EvjmDDBxOqd8LNTHWqdBZNPuectrvXWYm+CDfivjjwyj2IzIEVMKLi11kxmO7eed+1v
         L4qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760930460; x=1761535260;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wHI9VYRgU9NCjspHIFvlmxvN8Co/N4RqDwPEZAFmUys=;
        b=BUA9UJ/aT/JvS7sQVVN01KSMuaDr4fXntrrN/rp9pZmjoQISAGVYF8d3ehHQfrzUkA
         Nun9BA8NdBtljomYfzoCnLp7MFuJ+OnEscCmpiHsY9fdy3vKjmCJBbLAJeYBfaGtCkZH
         noUsaZg/ptXDw+ybVXsunIarB4Rje4DB5JBrSQtEO06hNEDKLGPvXswFoO7uNeTbSn8n
         tNwOflbjeku3jVuNzuVPLrIiunpb7Zktzk6cIF0hDalW4xy4wwx80g3r0alk2imeluRS
         aAKvH63S5ff3+nPTUZ1bmM9ogT4c9k8ZfnTQWTiFj2qRHIatz8uC6aYWMaLMX1n4SiuH
         5PVA==
X-Forwarded-Encrypted: i=1; AJvYcCXyOk77iFGaTmcu9bYtWRtTKna1A2mY6S0AZ85XKUpIHQKTHWUJth6ybECb3JdVQZqG40mrOhaijA==@kvack.org
X-Gm-Message-State: AOJu0YwTMcU3/RU9UeuVoDown/f5vyl2mv1LMeX7GMkWyvLTWRy1jOwC
	RSWRHq34oNkLzgGRWF/xjkU8pSmkH7OD29Jzcmlsda4N4CePkufFBSlX
X-Gm-Gg: ASbGncs247qyukWP1dgh+66qqB1XbYEUJrKRLLH98lKgbp08zWCRsIQl1flE1W0Duw0
	GEl0eMVd/tZZ0zIpBtXJvpd5em208YCgN79lJAEHynBPHNyTgdBIuwZhafrMr8dW5TjmU9YUPgl
	f0RvNQdsxZchAGSNG5CmSiN5fi+uDMhl4MW+L3AKIjAuH6J3p/LHbi6atThaTbYgUeTU09VCfjb
	hf/ZNYnIYF5/zi1eWuoa/jW2hgaXQRP3BPqnpenX9IGEfyXpgAtg9iw1olEpGaOV+zV91HCpgJa
	m0CrPArct7lilgBsQ7AA+fJgC+YKPb29t1qd4JEozYfxmOdSAIJw7njO3sohSCnEKOLMKqF0HEY
	VytPci6Rp8yenKchJypZAqEt0HJo11ottEkz6l9YH3MUDmQGeus2237J3XU4V5DHH9HDw+Bs+7o
	VZlFhY0LDaj9r2wSAJiMoB+5CWUBgS6i0gFFfwiYL0w3ddog==
X-Google-Smtp-Source: AGHT+IHTS7P4RInRCl/RZbmpnrgZ1U3ouz5pEHqmpv7QdSk7Vr1Brl+6pmiWgq6O7vs34OVAviH41g==
X-Received: by 2002:a05:6a00:2e1f:b0:781:24ec:c8fa with SMTP id d2e1a72fcca58-7a220b2af8amr12763024b3a.27.1760930460008;
        Sun, 19 Oct 2025 20:21:00 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1da1:a41d:3815:5989:6e28:9b6d])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff39437sm6770459b3a.27.2025.10.19.20.20.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Oct 2025 20:20:59 -0700 (PDT)
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
Subject: [PATCH v11 mm-new 10/10] selftests/bpf: add test case for BPF-THP inheritance across fork
Date: Mon, 20 Oct 2025 11:20:32 +0800
Message-Id: <20251020032032.3393-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6uizf95xymofefrrkdbty8x4dnsj8fec
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2577D100003
X-HE-Tag: 1760930460-130677
X-HE-Meta: U2FsdGVkX1936tRvr38OcLPjsvdxHezDaYlEN5Q36/z88yEu9eVjmGmPI9c0Zym9lV5JMZ39TMWHSQkQVamQrnSr10lk2dBwJBm4gz++/OlaxVEy+WX1nYmgNNnUkM+lI3e3hwYSd7+N01N4NucIeqmIgepE6nU7jTYGrAYWuGmSOuyfzWfEUiGgAZLU0Z1buN67x6M6BUZjWetq31iE5CD4QOpOIEzCdOs4lLpIvxlpd+feQ7Fmw6fqUyNAtTgzytnb/RkrxZwlkUBlCyR+uDzYZ6N44Od6TO0OyItPerP5isFrNW+MyakRGiN2renRR6eRwC2HD9Gmj9fLF4HAgfMMrGlcKkyDg8HOUoPfzzUcLQ21pL+kRIYRQS1SY39iH7NjJ5kiD6ceh34bMn3S9Nx7O2ySeclFGP2gzpMw/k6Hiw5XkTxfbNdj2u6Umsox8B3l28QO1xdF6kUekyRaave8rhhV7cJiD/6wwJ2Q4p9LDrn3HEAw6UGZjBTwPZrGCyTKpJ+Gs1AL+ZNS5AIsYOecRhRMrWIzRcPoVYUyLO9uoG96AfiMiV6yExA2EChZkTpTsJSAnOm0h2T4awxvAiI/aZ5p81hZKyaPDrR9HMO8YhlrHagx6BFsubgGP4zD94Fl98IvOzoIx5MdCkB4aTO8s1jvO2NTYUo0ifF0/dBX6qtMTVpj7BMkU7aZfq3gbD4SZe6N/zsJm+GL/sA4gRMQPaoNvEqMo7skIXSWgTVUVGl3tAcj2H1ONbaBhPTvQ/gDCXLAC2m8+2b9AXuouLTuReSUvYwq9smIgbmJM0caQKxtF5gUsZjedgPhm5C8+mX7EbcKMGFgEVNi1U6RzB6P0QtpJxd0RndNo3nQxWSDiBbkjEuKsDuOZ/nRnguKdyuSU6C55Ee2Z3rXAkCre5edc6lLuBRXcZAPvxRtZvYvmWV1/CNNBKGWFzPP7rluiCgueUpJu2etXZqq5tH
 ymKn175p
 QpVLh7RX5ld0IK47VHXUu6fBJBbs2UuhRkPJ/fCWInFGbGtb/Xj0PVL/3FZnQ9d8PBWptVcx14n9LjfbJQ30Y5r7Iv6+8sp1hLDY69kaeEEkej6CtQfZer6+82B11+NKsPVZmU7TRHkkBhnM6efKFDAdkZLpDtzUrXgh+BXc3Z/NWxiRoo2RB7D/ZpvFSZCeGcVVJGhZYDs4hIcEZHDs8MYx3SGN3Kz/NVw6yRBypXO1+9BmP611iyoQz33pYkxLiK9YViTwJZCZd6xOYXAwQZIgaGpGVeBnerR0v512iE9psF69wiBLZklabLQwiqc184WHak+sbp4SV5rHUgvrsot49r4znPbTAxW/Xmu/Z2gWj2dz6MXucmRYcXVXB3b+BJmyu3a6eqLBVbRTonNoa2SYrrboMEht/so6GJYHtsujQ/4xwZLCHhK66+7499aY74UN+JXSMzEVLHJBEsGLKi8Bnj9fSuvT/Zd2VNZ0qNoLeiu58dtOfJS8WbOqdoJ9J/Sh0Tq92aJuWRwQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Verify that child processes correctly inherit BPF-THP policy from their
parent during fork() operations.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 .../selftests/bpf/prog_tests/thp_adjust.c     | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
index 0d570cee9006..f585e60882e8 100644
--- a/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
+++ b/tools/testing/selftests/bpf/prog_tests/thp_adjust.c
@@ -267,6 +267,37 @@ static void subtest_thp_global_policy(void)
 	bpf_link__destroy(global_link);
 }
 
+static void subtest_thp_fork(void)
+{
+	int elighble, child, pid, status;
+	struct bpf_link *ops_link;
+	char *ptr;
+
+	ops_link = bpf_map__attach_struct_ops(skel->maps.thp_eligible_ops);
+	if (!ASSERT_OK_PTR(ops_link, "attach struct_ops"))
+		return;
+
+	child = fork();
+	if (!ASSERT_GE(child, 0, "fork"))
+		goto destroy;
+
+	if (child == 0) {
+		ptr = thp_alloc();
+		elighble = get_thp_eligible(getpid(), (unsigned long)ptr);
+		ASSERT_EQ(elighble, 0, "THPeligible");
+		thp_free(ptr);
+
+		exit(EXIT_SUCCESS);
+	}
+
+	pid = waitpid(child, &status, 0);
+	ASSERT_EQ(pid, child, "waitpid");
+
+destroy:
+	bpf_link__destroy(ops_link);
+
+}
+
 static int thp_adjust_setup(void)
 {
 	int err = -1, pmd_order;
@@ -319,6 +350,8 @@ void test_thp_adjust(void)
 		subtest_thp_policy_update();
 	if (test__start_subtest("global_policy"))
 		subtest_thp_global_policy();
+	if (test__start_subtest("thp_fork"))
+		subtest_thp_fork();
 
 	thp_adjust_destroy();
 }
-- 
2.47.3


