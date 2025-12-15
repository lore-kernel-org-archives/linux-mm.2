Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF6AD59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 09:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 129B46B000A; Mon, 15 Dec 2025 04:06:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 101686B000C; Mon, 15 Dec 2025 04:06:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 017346B000D; Mon, 15 Dec 2025 04:06:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2E206B000A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:06:20 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AAA0960DED
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:06:20 +0000 (UTC)
X-FDA: 84221124120.22.4245400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id EE88CC0007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:06:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IoL0QQD0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765789579; a=rsa-sha256;
	cv=none;
	b=RFM5ZYzMC4W3FgWAJYe/7NcK2XMaW2lTgZTVuuWGyHa1ZHc83D4eyJx9aL+evtNrdrEGbs
	MpL8n1pu7DPkNaTFTuObMlV9JDf5LPWPVlJaosOVDecLr195cyuHShN8HEIORe0VPATT1+
	yM4MD0cHg0HRLnBRWznM/VnID2JP5HA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IoL0QQD0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765789579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4oBTIsoOygiD0s+5B1YDZo7zeVCet+58utYNMPDTAKY=;
	b=xlaCI0fYB9+TlBa8wdhGeZuMEvW0O204XB/oHvuNdKUBWtML7webIyWkwSnMxOdYZFCFD1
	ENMVQifT87OLwp/ZaGm5hb6CwOSgj5BHbc6WcgaOyy5MfutW5FJdN5vGF4gh/I/uo42vVD
	kpS5UJyGfzFEIh3qKTSGPlkMVtsMXdc=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7b6dd81e2d4so3176832b3a.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 01:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765789578; x=1766394378; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4oBTIsoOygiD0s+5B1YDZo7zeVCet+58utYNMPDTAKY=;
        b=IoL0QQD0YAYme57y5QOF1E6iCJaRZyC/vlLIsK9qTKeq8vBD1n0DI7OfffIeHnRyf7
         nRbTMq2+cZpdtN6wGZMlshjKAlA0SkMHx6043CPKD/KKC2qRNs6S2gGMp1pFQBFdTnlp
         +fqgXyJfKrZgFNg97CiIltzoQRiR3JsX89fKSSmrZ1TefB826kbTN0PSwDaq3vFeDDj6
         kcNfdhri+xbI9peBtjDgWhnl++LT+3UuLgGqrsCe9kXxOTLMP2BsgPau5mU7K25Dj/nd
         losDtjyVvaWmwgQw8V5bbE5fgZoXt7RVb7Ive9N2Sa03RNRWvfMx1JKWI4fLQQpU7E7G
         +iCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765789578; x=1766394378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4oBTIsoOygiD0s+5B1YDZo7zeVCet+58utYNMPDTAKY=;
        b=s2gyD0jr6820m0CJBygrN5wBlZAz9LOBOigUss3nfOgmBWIyJaenysEv/SQTYqGAhS
         aCkSOniHOOQaiQm/MQp1UfXSf8nPcyiORn5iV4gb3sov+qo/2LB5x6vkQ0OHNgNUEKDK
         wfzfuJ+0IWc2miqaZvEb5dITdZjoMUbguWE2PLG5jiNUQhnNDl+s2sRYzeJKB0Qojqhp
         XR/zBJFHCYOgcfk8kHNGK7pgV7im9F6zTCbJ39IZrNY/iDcoNCsD9P8raqMXq5KVDo1r
         7qr/bte/TzhTnFfIjsnYPkj6qEjViyJAKt9CiCKq22cQFcgOBebtUlXLtvRz8eAO73Cu
         uOkg==
X-Forwarded-Encrypted: i=1; AJvYcCUIp9VRgdjvRoTqFEd0qyLWdL8rV5EAEYE/r44Gc1/VqwSWG6Q2vGioxxtlXIzhk5j5wx3b4WrJfw==@kvack.org
X-Gm-Message-State: AOJu0Yydm7BE3yRV4Ov+KMiQPOZ+Njr+B63G6qh9NH4Z+qLkk84D5KS1
	MgVMUbeWfLO8xamTqnSlqPDTP1+ajr7+bRJMmk+3ByZyL2RCjKHxMzSv
X-Gm-Gg: AY/fxX7NRf1t8EPqmxanH1ky0t0DaiXFlApouRiLodQ3nmPC9SdfdHDg1/quh+RmfSC
	ZKEQuLBfaDXUPRJFpLYvexYOa7BpBl8tak3zz2+0C/JdpZo+n6cZcV8+i36LjVqCsoIDiNrpOGk
	oXAet9nzCx/vYEpPnWLAA0qW9WEYv+WeOqofmyTQsjdSOm0wkarRveIR8wxHe17QWYgtMJfZLMh
	LW9hdX2RREGBYeqKssZOWSlCnvxfkZOUTgQklrrUqqzVQm6rumxGzKkZfvXwXiReJUxFwy5goQP
	xa+a5o/1Klng/g7MOgE5qdSs/DXATR2WO5bm5TMaIbPU+TYt8OHrLsbtoCl/y2BKlfPu5CLUbug
	IilIiXOzYz2dqr3d3WE7pqXGt39e+MVSp/10reTZYsEC7n07pyhJSrKArvr9crWZ7RESv/8JPrx
	6FnqE9kkjFSFJfGq48EHKuPUlybGysdQ==
X-Google-Smtp-Source: AGHT+IFyD8g0MtnJcE2vXRcQWMhGTOBNHVDi7wi14ga9RWkNywrlmieoCk6BJXjRwgXYDf93kVU2Vg==
X-Received: by 2002:a05:6a00:bc90:b0:7ed:2cd6:58f7 with SMTP id d2e1a72fcca58-7f6694aaa51mr10086224b3a.36.1765789577836;
        Mon, 15 Dec 2025 01:06:17 -0800 (PST)
Received: from localhost.localdomain ([114.231.217.195])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c5093a40sm11993160b3a.46.2025.12.15.01.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 01:06:17 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	npache@redhat.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH 1/4] mm: khugepaged: add trace_mm_khugepaged_scan event
Date: Mon, 15 Dec 2025 17:04:16 +0800
Message-ID: <20251215090419.174418-2-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251215090419.174418-1-yanglincheng@kylinos.cn>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EE88CC0007
X-Rspamd-Server: rspam10
X-Stat-Signature: pd77r9ms18hkgddr3mddf7rzaoq77wji
X-HE-Tag: 1765789578-694224
X-HE-Meta: U2FsdGVkX19BYv+AlamQyhR7+8QKJviesDDmZeb+sh/Lqb4yKznnoPC66NArjam/0dfcElE49v+fYd5t847MS6XjyIABO5lWElQP/qHGwhtZYiM0KAuZHrVX4YC0MI8VGdD0INoCWKw2Ax7mg8IDLyTBzFshPfvpfBGGWxFMm0QDM71OlZ1c9NMB+1S9hDYwRhhRbYZCpE3AmTuKYPXxgzUBxACdR9AqeU+rA2aYFkdzcwEwDbn7Ep30362w+OfidaYSfm3LLAo4EEzpcEUT7rc+pSQTN7vtdH4nj9t79NOczrrf50guv2jl9zE3/wgx1wAljDNc3mbx/ROl9yT4dscsSxnwhvOQv1RvGWdLh1J77MPURiDm+rQsauik6i+EOV11BbOkjVOjuPWgBj78tM+3Y5cS/2U6jpSEweBlfoOva98KfUSbluC7WCnaEggnNT2zAvRjIGW7pvlxL5GPl3I4V86TAPnB42TTVm1tEtLVmC6/QX8/8N1v1fN4jEZDQntzydpcCoewzzGRomfI91l2RV/KiLa6xvJGCNoQd3g0Z3X/MmWrRV8rVcMqnE2lRYp6QDXDgsQHI7Y0nVJ+hynqz8TI3H82aey4Sodc2RwtXzDDMLaj14q6arP05WBiJfeoG/JUmpR7GJeKCtWs1LOHgOY+yFHmbmsz6O+hqfvk1wtqjAnX3EsPc3uO8JwTSzrKM4hD1qXvliSDSjDIAJ+0R5FD3dX9T5hnllHcCMFGNYv8xrWpcTRK8HRla88Pz9HZ254956CNTfA0k67yGg6vkS6sYvir4c5P9Q9k7Z0IylYCfLrJIHOyLpSVu8OyiglAB2h51tU9mV1N045KG3o3OV+JC1V6PRVhZPFraABaCtXkOMkiSAA0h1fbWZxjCZk2h7G/WwFt3gP4vugCXGa07v882R1J/PjNqLnBudKys7MQ7gzATzrM4RfDSUKH2LIK5tlO9AcGvgx1nl6
 RH5UgDGC
 hriNK7s9Av4eYPCrh/jWooezY/WgGDZKlRqQJniPupYpbS3uLWj7d+OcmIr5pDljDiKaVcnqb0Q7kqYOGsYHYVinEanCzQvj2l4AxfkBLHZU/lynQEj5HJxoilQXyjfs3LUYePbzha/Ln6FF+JoVc4cYs619nYGk4qA2i
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
---
 include/trace/events/huge_memory.h | 24 ++++++++++++++++++++++++
 mm/khugepaged.c                    |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index dd94d14a2427..b2824c2f8238 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -237,5 +237,29 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 		__print_symbolic(__entry->result, SCAN_STATUS))
 );
 
+TRACE_EVENT(mm_khugepaged_scan,
+
+	TP_PROTO(struct mm_struct *mm, int progress, bool full),
+
+	TP_ARGS(mm, progress, full),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(int, progress)
+		__field(bool, full)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->progress = progress;
+		__entry->full = full;
+	),
+
+	TP_printk("mm=%p, progress=%d, full=%d",
+		__entry->mm,
+		__entry->progress,
+		__entry->full)
+);
+
 #endif /* __HUGE_MEMORY_H */
 #include <trace/define_trace.h>
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index abe54f0043c7..0598a19a98cc 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2516,6 +2516,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 		collect_mm_slot(slot);
 	}
 
+	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
+
 	return progress;
 }
 
-- 
2.51.0


