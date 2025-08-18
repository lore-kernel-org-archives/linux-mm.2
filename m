Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9322CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61F508E003E; Mon, 18 Aug 2025 08:28:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CFFF8E0003; Mon, 18 Aug 2025 08:28:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C09C8E003E; Mon, 18 Aug 2025 08:28:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5138E0003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:28:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D808C1DDE19
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:34 +0000 (UTC)
X-FDA: 83789806548.14.1D59EA1
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 07642C0007
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="VoZ/DkYD";
	spf=pass (imf28.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755520113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/DpZ0VS7862Ajy+KQk2G/2dTQnm2+OmeTQP24iYLyY=;
	b=wP0BiiwribelaDcjIkd11Ys0J2Z2AfuKhUjc0wxb+hIJue5IdLv6SRwDU6y+aCwgk3Yy0j
	n1yAfeoOPsY5CrDOFYoHqbREAIzHK9WGvCr3biB9w9YvIwk7VDuhT93XRNW6RBdmxaL/c7
	Rj9eO9ksf+Pd3sVAlDYeG8fjUhKSAhA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="VoZ/DkYD";
	spf=pass (imf28.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755520113; a=rsa-sha256;
	cv=none;
	b=cnpZ4fWYiU1Pvq6y/MhZSCmMLwGILQi2i8UR5v9Ey4GndSLSTFdwOPay3kWoQM7xJl+4du
	iuZ6aBvUGk19EIU9Vskp6TRo8xPBwhiqfzgKogEdrYkDH4UGe4RqR1v2QqyrCJ6bOZvY7c
	dwB6IkTtVuNEFlXK/UJ2RGmiDD47LZQ=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b471aaa085aso2256886a12.0
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755520112; x=1756124912; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q/DpZ0VS7862Ajy+KQk2G/2dTQnm2+OmeTQP24iYLyY=;
        b=VoZ/DkYDWqyLSevnWtGU5E0rvkAk3R4Nhkc/Rw3Njthl1pmgdAwPo1Cnp0xLx/74Ej
         rY1IAogayaMvlT+3Cnr3Y3/hP5qOiNdkac4uxIDCSCtmpl9iHhVOB7w2VXQhnCJer13F
         Ps1R0BN7aoorAhypYshepQBfzCUXyf9gxD37iaJ7F5BQg9eN3osgx7LohsxqBwnrYxuL
         MOB3yJ3fT+9az4VvCFEce95E6tGykN1uJr0g1uZIdrRfenTWd9IG3onEOhQulTmQiNMa
         RqMl0T0djSufab4EnbXCvPghGw7ciUjwqgq8sW1XpMULRFB+/WI4Gw91cRaojdrbUgns
         gOlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755520112; x=1756124912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q/DpZ0VS7862Ajy+KQk2G/2dTQnm2+OmeTQP24iYLyY=;
        b=BUZz7jLQuH5DHkXpjsIOW9mbUE8RdR1ABsWzlSmvi8RADi43FTzw0CwX/eOMvczepk
         F+i3xEGPvkev/BhuE4KOVs1nRGUyKC6tngXWKDiNAT9OgB987PcGKrtCWjFGSTx9ZzTC
         q1r2pyCpO/IKUoQFqFIjZhy6sGpLXZEpAWFFszn4W0upBYjWJT8Do+aVhdubX5Uitjp5
         wO2NYhEH9apI6roS0iumdoiJiQIboqfXMOV/1uTl/MViwsETULP5cOz9wSI7m1C81xtW
         K/jO5fKcmTAlSG06nYDoHBaB6abSgNWIUFdwekqSpCtjZANEsMDqV/k0/M4CgZ1rUvSP
         6iOA==
X-Forwarded-Encrypted: i=1; AJvYcCUHmCy7XX8H094cxtTrrp4rWoqsJlvR52YtkSPKlKJqnFGCdIbSfRnyCPM/skklZHBq53a9MG6txg==@kvack.org
X-Gm-Message-State: AOJu0YwvIxqX0NFj0nCGLj1wQklnJDFLDk+HjUmAP1zDzBAwiNlbuWqz
	vW2cPzJ2tYhjAdyN9CURFV5i4xyYgXQJXVwq8VS1e4jMWhh0TAoXSsMxwFy4COHrHZ+LyA==
X-Gm-Gg: ASbGncv1LpxYvwi4koqhp/Qvp39aTZGf94vAUA5wfegfArpSHp9VrrgXKe9SPkDfYY8
	y2BS9XL8sjh8cDh/Wdsdu+wYBwKs0c7+5Drj/diW9ern3A/JSQcsHQqodcj51VKX++faBsyBYAI
	r2ZjBrUJw8l6f+zpAq/zlVqBrshpJLUvj50FJYscQxCnEyFQC7ebD9WvG6cX69P7gTNWGH9ekl3
	xc4sRd/fokTuam18t54DNlzgIHyoXHEvoxaw8Cr5dfnyTmpwYP6SxDipTraUwxjfcmNDnqqqMLY
	/CO/vMq3irr+WLFmxx2h0PkpBewqIn+u05Ww5zrQbDLY23G8xM/nF48jWQItoE4bpOZnuE4GRpv
	Ewtoq2+bjdErUYDcYRFI2ZNfyX1Et
X-Google-Smtp-Source: AGHT+IEvY/jwsGgceZVHHVEFZS6zGhiEPgpJ/TKsUEzDfEeP0f4EMRoUPlRe+ApAp6RTIagWz9PdWg==
X-Received: by 2002:a17:903:41cd:b0:240:5bf7:97ac with SMTP id d9443c01a7336-2445978bb29mr248116735ad.16.1755520111835;
        Mon, 18 Aug 2025 05:28:31 -0700 (PDT)
Received: from localhost.localdomain ([2604:a840:3::3008])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d57f12esm79236705ad.157.2025.08.18.05.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 05:28:31 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: akpm@linux-foundation.org
Cc: mhiramat@kernel.org,
	naveen@kernel.org,
	davem@davemloft.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 08/13] mm/kstackwatch: Wire up watch and stack subsystems in module core
Date: Mon, 18 Aug 2025 20:26:13 +0800
Message-ID: <20250818122720.434981-9-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250818122720.434981-8-wangjinchao600@gmail.com>
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
 <20250818122720.434981-2-wangjinchao600@gmail.com>
 <20250818122720.434981-3-wangjinchao600@gmail.com>
 <20250818122720.434981-4-wangjinchao600@gmail.com>
 <20250818122720.434981-5-wangjinchao600@gmail.com>
 <20250818122720.434981-6-wangjinchao600@gmail.com>
 <20250818122720.434981-7-wangjinchao600@gmail.com>
 <20250818122720.434981-8-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 07642C0007
X-Stat-Signature: k3ub4rfkmspbqbzpf4b7fz1yka9x1uij
X-Rspam-User: 
X-HE-Tag: 1755520112-457558
X-HE-Meta: U2FsdGVkX19eu00wT1aIoAoRng0igNCmGAOo/vmNdqKWzpuMGMinSl6RHpxbyHsuUGNLdwOrriYweSEMSFco8uC6QGXJpRViKPufbCkd7BP5Eqlrs5WIxTWMDDhTxAlUOcfjP7P0ic/DD80fJAjn0UqjDRo4BDnjMKtPJIUHFWYTiqupTfxAGMNqBKjtlEA8o7ZAMIOi5mq+IfCQEPr+ueC2NJ7CKG0im+fK+CIArrQGRZ0zg4ZzqgmJdCyx6x/IVK8uAilBEOiWtBJNv5i0RtE/+IqXN2SEbAgaXTA+p62zmabo+UvJtqd84Bd6gijYzAaWgwziVk0G+XhciX1JSqN0raGeD9DzKVs1GZfrEmyFF+zBworBeEdtcsU9qbmr6vcVOfB8UvjlOeuGYkDvC+1wnZXjYMno90pQ8hECZ2T1i4LyQbanWyCt0rVAJf9m6APOyy/f/UNy3liBJiUoNMGpxoKf2DhwmDNUUGVZ91BXyJZw3YEAv4wnFaRY37nfJMjebMsyO4b00lL8tuloJasz/rMC2eIgJsVzPxaYuLIi9/axQGaVAQzDTPe8H+Y9YbHi9PEp8ZLxAQmYC19K5ZNsqo7yu5vlVMJKbY8NiUbfoEXCMj2EXzLI47AHfXq+kPBrbSh9Je3fNluVwIKhqTXxtQSpEVbnkNfxeRxfiCo3SIalHc4dxeWnKpjAOoFwisgQMgRc3i2Q68/qKhossLrWYVfJS5ODeZqLcRXtYJtf6BGyXXAcpyivitk9YZf7Zl3AmXqPdf0vM2bXNQav2U6OHNhOOM2IVEe+IhsR+GH3T8CalaCuky5RZnl2/x0l81V9piCMDdcdrOaNEc6oYTK9PSQgL7UVgYqAJ96k/+PhsuMGXlYI60et+N9m/SowfQkvnzQVr6e3+FvJVCehXvKHNO7m5ELhWf/WWsw2MYiJnDRZgT4qJdvLhDsIZND0CW2xBJSjhb4lfmSz5N5
 RRilFuhM
 DfsXjr5EQGYsYla8TfgwDiX3CHFQpyeK19MTHZPWZZIIlcNvkSGLiEF4R1k0eSzSx3Wf2dOimauTRU21nFlLZKLRDZMCDjzlwPglCRKvBzY5qzis8QC04EJL7fSfxNrXqMmeASTW39TkhjgY+p8MifD3YT9Lk589nlsAsY1KgTW8O/R6pdZ7yJvLZqr/24fOSi48xnHDZOT/kmzJk8PjTt6/OpS206YN1RkLuR6C0oPgkLJijlOjAyXUlwYiRM+JCZv+qM0dT7UyZZtICTtQdTPxYY/1BHKNC3Mcl9Ws2Xuii/4eJd+G9FKzKp4Kgyg0OAd8PW4mvuBg4fkMMalgIEv7+Qsj7u9cJ+vr0vCjYIg8+HpgugBUgMLXVnDFzaSf+88A7CO6togjwO5M3Bry08dzk31odR8K8x0z001zfldlLgi6v4MD22XBQuZUN7RFxxqb5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Connect the watch and stack functions to complete
the kstackwatch initialization sequence with proper ordering and
error handling.

This patch integrates the previously implemented components:

Initialization sequence:
1. ksw_watch_init() - Pre-allocate HWBP on all CPUs (must be first)
2. ksw_stack_init() - Register kprobes for function entry/exit
3. Set watching_active flag to enable operation

The ordering is critical because:
- HWBP must be pre-allocated before kprobes are registered
- Kprobe handlers depend on pre-existing HWBP infrastructure

Cleanup sequence:
1. ksw_stack_exit() - Unregister kprobes (stops new activations)
2. ksw_watch_exit() - Release pre-allocated HWBP resources
3. Clear watching_active flag

This completes the functional kstackwatch implementation, enabling
real-time stack corruption detection through the proc interface
with automatic HWBP management.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kernel.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
index 726cf3f25888..b6366808e891 100644
--- a/mm/kstackwatch/kernel.c
+++ b/mm/kstackwatch/kernel.c
@@ -26,11 +26,29 @@ MODULE_PARM_DESC(panic_on_catch,
 
 static int start_watching(void)
 {
+	int ret;
+
 	if (strlen(ksw_config->function) == 0) {
 		pr_err("KSW: No target function specified\n");
 		return -EINVAL;
 	}
 
+	/*
+	 * watch init will prealloc HWBP
+	 * so it must be before stack init
+	 */
+	ret = ksw_watch_init(ksw_config);
+	if (ret) {
+		pr_err("KSW: ksw_watch_init ret: %d\n", ret);
+		return ret;
+	}
+
+	ret = ksw_stack_init(ksw_config);
+	if (ret) {
+		pr_err("KSW: ksw_stack_init ret: %d\n", ret);
+		ksw_watch_exit();
+		return ret;
+	}
 	watching_active = true;
 
 	pr_info("KSW: start watching %s\n", ksw_config->config_str);
@@ -39,6 +57,8 @@ static int start_watching(void)
 
 static void stop_watching(void)
 {
+	ksw_stack_exit();
+	ksw_watch_exit();
 	watching_active = false;
 
 	pr_info("KSW: stop watching %s\n", ksw_config->config_str);
-- 
2.43.0


