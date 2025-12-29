Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D364E8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 05:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFF216B008A; Mon, 29 Dec 2025 00:52:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBEB06B008C; Mon, 29 Dec 2025 00:52:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2146B0092; Mon, 29 Dec 2025 00:52:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 957A66B008A
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 00:52:17 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A4D913C064
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 05:52:17 +0000 (UTC)
X-FDA: 84271438314.25.37BEF5C
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2FA2E18000A
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 05:52:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nF+88iId;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766987535; a=rsa-sha256;
	cv=none;
	b=vehs6pRDBdwV1y5wBvL9WauKJea2iCjq8jSbji63u6/SFxMcIO2jinfJfYVxs0FsYvO1VW
	pCFUMfOO2usNbSKsixVMgQZaMbxybUQ4/zvxOZ+m43mpxNchJhh634LCUWebLlBnril3Rj
	NWPzivANT/EJ+Z7LqvF4RBTqhgjFWy4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nF+88iId;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766987535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FIJuJHeLF/rAuxCLr8FDuBbtKBKNJj3d8hTlo90/eSY=;
	b=mkbcztey7krMgk4p3lKsTtB8KpI+mcrPT8hgwFdGrfDtj4WO9zycgprl2oMkRAHmyjWT+S
	dbOTadCj7n6ngDL6Hix1Ymm2FGk3hZQ2oI9/0eBNja40W4AVFhsdXQZ3zUvx1rcg1jYQg3
	A/tT8MfqCU9/Fv4t85aaz1Q9lligoI0=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-34ab8e0df53so8464924a91.3
        for <linux-mm@kvack.org>; Sun, 28 Dec 2025 21:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766987534; x=1767592334; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FIJuJHeLF/rAuxCLr8FDuBbtKBKNJj3d8hTlo90/eSY=;
        b=nF+88iIdwD7Wb1gojRXs2135/Yb/erbw1nN+hlUShPklcFg3MEvUwkkdsRO7kG3Qne
         UyrG5P9oHRBK4RjU46DxpSh9Iwf4/8ZPz68qmhtNCkWjeFFHUDQX62Gz8JWpyVndup8i
         uyi/4E822oiHg8AkAd0y+WVhTyti8JY4fPMNCZfV7ePkqe+bwcr9V9uk5ciw8pndUIs+
         dqAK66avbpGXTd3M9PpqEAahdauaIlJYfZpiLyllwPkduhQxlPxtHuycRSqGrHQ/kOZC
         F3AGIcVIj449zDIuNsJR8xdxM0YFQ8GroDpgRtTSXk3+TGzr5z+GM54bDcjO7jM/Kp5J
         F6gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766987534; x=1767592334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FIJuJHeLF/rAuxCLr8FDuBbtKBKNJj3d8hTlo90/eSY=;
        b=RRsigtXl/N2ZvjS4xt0Skk8zSMpfhw3+EFIfXd85GMDkIU9fAKc2FyjtGvzQJI7DMA
         N6yYt8mZzXmxTHzC5xQaR0UuhlPzamKsCpl3EN6SdGZv6nkQ1ld/1rEiEPONFmpwF/0/
         G3w/LsceQMUqcSxMIeGk87HL6wvg7kjUZy1vJA20n/Xej81gcedREzAlEOj7YMS+3RG1
         6zc4yb3NuxohwMCYrtk/VffwmS/oT8VKgEAkRHdevQ6RfJ3xUY4o/gORUEHyRucggmw3
         /p/lApAD/K7/aU0Ezm5eibq90frS88AdgZ+9MESnAxCn6uiIEev0BZfgkhtXFjBhsUJF
         TlAA==
X-Forwarded-Encrypted: i=1; AJvYcCUxo3Ku1fWYNiJs14z2qqiqrHPi206bxTAUyIM1wJWsImeHgmNAPg+yTYYfu7Ix4VxrqVXlOKgldw==@kvack.org
X-Gm-Message-State: AOJu0YwZ4jpbc0WTqJDGZSYdL21bTF/iq06cyGdd8dcHByTpPM2GYOkJ
	GU9FGcOxTG90/Tsk9W2Jyu16xvKWuiyQcUwukx00VQoi5A2uJIblUTJB
X-Gm-Gg: AY/fxX7QtSlyKl3PWAVYSPxV6cb38bsbEqqgu5YBw64FcYs+Jnx0WzVq8LcGsJA0l9T
	sGoA1ZvbNsy9OC8q+a4whENbytgOIJ8SUmuOhfrLgacxGJZy9tYtg8ZR6YTqJWZkt2/UpxPbg7G
	hzf2MVwncFR1I9KsmyS05rsaBaw/hpjRiDqFrQpqR4WdWTeWOyVbpstHJNw4Dr2MiPtc80nXSCX
	v9cTtfQYrWI3vreCPCIrrpgCwjnn3ORMuF7PLosiI0qZ8G+PHHNDgBhD7uSGv0/kQPBea/EjsPg
	4JcVG/JxeRNJodkXvsl6o3KhbdLubVx6z3g4Z03vxnaXMPUrh8+2a8+CdtS7h37IWvidoonRP0O
	n1p798jtMGOu9HCqU043S12QmcOLZMDOyLdL2SEyizFDAHSVVNDPdLCyH3laWXxhVqU173M9xBb
	V/6XC3QebT/WYdayiCW3d8ATlE9xVI
X-Google-Smtp-Source: AGHT+IH63XzFCnyuKu0Wgj97o/tbzy2W8ufp0/6+lca0YfQu/VsLM3I8AlkxUXQCVC5mDh8izDSaoQ==
X-Received: by 2002:a17:90b:54c4:b0:340:c261:f9db with SMTP id 98e67ed59e1d1-34e92143acfmr22203621a91.10.1766987533986;
        Sun, 28 Dec 2025 21:52:13 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e920c9a7csm26164019a91.0.2025.12.28.21.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Dec 2025 21:52:13 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	richard.weiyang@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v2 1/4] mm: khugepaged: add trace_mm_khugepaged_scan event
Date: Mon, 29 Dec 2025 13:51:48 +0800
Message-ID: <20251229055151.54887-2-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251229055151.54887-1-yanglincheng@kylinos.cn>
References: <20251229055151.54887-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2FA2E18000A
X-Stat-Signature: aqyy6exi6e7eu5je3s8ryyap16sdaq5g
X-HE-Tag: 1766987534-511720
X-HE-Meta: U2FsdGVkX196XqlUaCSQp+jEW1+HPvXzqvHQCE2ElS4TjeHHVJYVBkdXqrbpZF/86k8F20n2y9P7Gb0uZ0xhvAJMHUICk416hbU8tgt51yWvmYlv8Rx9LHFGNbxdQnlWstmdzzKX5jGUEfCt/EoOud+cOUbcwLyGVK2KF3uGOZoCN8al74J9Gqmnop+TQX4juWFRhqi5wqGoCn4d0hZ+ddbJoARgeXtK/VBtdORBNpkQbZEiA53yjaThtio/Llx4xBYA+SAVWzr6ps79yU+iL5WbfSJOvaAByK4khlDTpglP1HmhtXIc406wxApcwqJXHvRlZ3jgpx8YcckQ9ml5rIYCZjN63T+c72I2d4kCtYU4dKMAYYJUY0XWj81slh4UHfYbnxykHeXOC//cfYuRa4FU8t5t72PkpNxL6OpcMh6K8GnJgiJRPcYLNC9ZOR5eB3U0LYd7JRp5IC77TtCcIAmQW3tUuRyeLGRe05MHZi9YY2OkmzRmwdhUek3Ya0ZqabnNQFs2YWNgcQek6swQx/tI2iRl1oBgJoMEpUm+GBErCiKSuTcY+fWmsLzg1xytQ8dP6vGKm/VQvPRbdR9TieiVxCVg2rxIA54LW5Ih8ahe8NqCrp9mVTqLVUGYVn0MPKjcrIkQ4TEMod7HJPuxqOOPFhRwXg7HevSdDRxySEg0eFfQuCslTZmtTjqpLhpSaFY2j2jsjSDvQMYniBelCd/5y37OxSNNvAqnTKraBzKF19FfdVcYtstprvc1M8lDN0OZlt7MrMJdx8YV1lxCIw+T5nJqXdvsSgtEF/4uFWZOVHUO9KTxUutJK7fdIZgZbs9coOaized22ytenoRP7cAbvPvu1UXdZFWJwEKh/XCe4QciIfmnj7H68QQgPntBpFC8RlwhSGX4xxNmwcg0dOpEc+n737Az5pG2/9VrReYdZ6WW/35BltCxpi6BF6rfSRQMsqfkPWmCzpH5g0m
 LoOTTa2V
 Uv8gjQCkARFV8bpH1myMYWYeOF5VEnxaIwMEn/cxje36F5fOMUZarXnAYEjhIRkrP7B1DA9KjimYE3MONc0/xbq6xNjnuWk8iDI586hRSwzX5UUM4jtqSh2zaQDBgx0eJ0T4AwSw7d6Ky+hqhO5oAuyYamsctEfo5V64MhsYCrH7V+X19EfMq/CsAPkLEs0FF2rv//gxb67EvU9T47jUZxmi1kYG51Hq41n2w5Ic+5FsC7Mrm18j64J0bbQMpsvlSv737ZuXPE4zguAxhgevBRW4Ykgc7JHnVB5NemHvGoS+GecDBOLBmtTZBRDp3w3jGnO+pZ4P22iAvmpLe2WEi+v0dBMluharXXTbYhHX5ETZ1MuNRz1HGV8HmymcldXMv7gO9yBSVkVDqPBfirFmiSqmbPxBdqiNq7PE3b+DT55q3oGDYk7t6/wOY+wha3Wv7JUUXkLVDwn8n4kpy8EuYk5R4jPKeeK4NHlmfdnKNI4hztaPUUj0DGLtf7pj7prl4KKbzuUWf5Hb4/8g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add mm_khugepaged_scan event to track the total time for full scan
and the total number of pages scanned of khugepaged.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/trace/events/huge_memory.h | 24 ++++++++++++++++++++++++
 mm/khugepaged.c                    |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 4cde53b45a85..01225dd27ad5 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -236,5 +236,29 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 		__print_symbolic(__entry->result, SCAN_STATUS))
 );
 
+TRACE_EVENT(mm_khugepaged_scan,
+
+	TP_PROTO(struct mm_struct *mm, int progress, bool full_scan_finished),
+
+	TP_ARGS(mm, progress, full_scan_finished),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(int, progress)
+		__field(bool, full_scan_finished)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->progress = progress;
+		__entry->full_scan_finished = full_scan_finished;
+	),
+
+	TP_printk("mm=%p, progress=%d, full_scan_finished=%d",
+		__entry->mm,
+		__entry->progress,
+		__entry->full_scan_finished)
+);
+
 #endif /* __HUGE_MEMORY_H */
 #include <trace/define_trace.h>
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 97d1b2824386..9f99f61689f8 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2533,6 +2533,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 		collect_mm_slot(slot);
 	}
 
+	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
+
 	return progress;
 }
 
-- 
2.51.0


