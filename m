Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33269CAC5BC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BFD28E0016; Fri, 26 Sep 2025 05:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870118E0001; Fri, 26 Sep 2025 05:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75F9E8E0016; Fri, 26 Sep 2025 05:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8998E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:35:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0ACEEBA727
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:35:28 +0000 (UTC)
X-FDA: 83930893536.05.6C3DE28
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1B619C0002
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:35:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=COO7cGcV;
	spf=pass (imf10.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758879326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=huK0MPI+64vH11fsWziyabmXxqecdshCDlVy93FTD7M=;
	b=uIDVdJQAJ3EKca6CtWKdjRZoGZ5kL4/Wy/5WGa2tG+HutuREF60k3YXeYhUwIgm+sRAWuC
	Q4RXaZxwRLm4I14sIEwJ2I3CcqM9A5nRloFb+N/fXOk+P9zEtAqVRj4WU3f4Asj1+ZiHaU
	6YC31PcszOF8Ec6sdvLhEg0JeKz680w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758879326; a=rsa-sha256;
	cv=none;
	b=QCMHn7gI156jj7wuJRxsKVBDkZ0sYpvoF+CH5Oe2vheV310SiNy+BFXnuHH4UCK8boAZGg
	8h8Tnb1R6NruRzr3KkTx/o6vVc6bOHSy5XxrolXlfXlMU0LfUn5keO1a96LemcYPRJ+zv4
	an0WW5YwLnu25X68BTMdTaQsu1qpqig=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=COO7cGcV;
	spf=pass (imf10.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b553412a19bso1519868a12.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758879325; x=1759484125; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=huK0MPI+64vH11fsWziyabmXxqecdshCDlVy93FTD7M=;
        b=COO7cGcV5cYtL7eUaqswt0ox/EWI+myNTDDujzHQ4ruY+vMutPA+Hw27OIhpUL0Gyt
         NwuiHbJtuxozjv+U84ViOLWqYmfdnLoQrew/msfT1K4OETM2BU2onxARg0JDnv5Nwj4r
         SNtuZkCrL9gBdMRa6C3JypT07UpGj7BQtpaGHl0EXZkqVj4pHfT63rOw4KUOfGXrV7Q+
         9Lw1y2mvU5ttm/Hc3tHKRBdhY7gCtN2zBm6fjYVdB+Sc6C6Sx/15Bf9YlwNeEPCbgf4o
         eiCr40p2Qc6hXMYHxHDL2kQ2Q6WPvuAVtiHt2sFGLo5rJiFhe5ym34l4LsFa9Bza3+/b
         2jgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758879325; x=1759484125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=huK0MPI+64vH11fsWziyabmXxqecdshCDlVy93FTD7M=;
        b=tEWOCnAg1zGaTfpCbJDK9Ek4W30B4YIukwSciO99YtPEL1dvLrNhTxEDMBOBd/Qqh1
         APj86+CMfOdPeqzym6gewbQ1qdipW6iS2eCLFK+0kHs7pyN0p2XdWBZWralhjtCEcsn0
         xO/VDId5Ej9Bs/WCXaOPCvfgRzo24d6YIsYLaeEVYtY6UXKrRShywtS8xzOHP6t8Fhjh
         uGbCdYviim7RNCudOfzPeejpHQrFxtD2nh26FFfuyFT2ObBhOLcopJgOABKrILMCricp
         aBFoVG4a1+3qxutWWnE4p2UfdxBfsF6RoKO5y/TkLCLV+oumy8bjnRfOiml/clEis7ai
         FWlw==
X-Forwarded-Encrypted: i=1; AJvYcCXjx+aJC8c9V5mqUMEHIzQZhSrNNQSaOQSjgDY1xB5EBmYh9PvM4kZK9+Lxrg2M4a4txhuEB7MzYw==@kvack.org
X-Gm-Message-State: AOJu0Yw6IPmrSm8wP1KzAgs5Ougkrgu2pVPWDxMQVUXKFxWZ0iKJY/te
	vSnBQaIFmbiJNu7R/OjFD2niV93fAWk/xZ5eKuExBrBkmSuFqeDB9fVj
X-Gm-Gg: ASbGncuXsD5mfg2glDoqR6wDhmrId2wf6ci6z2nM0H06mPwtzfIfV6K3BpJQ9PmKD2g
	0ib8fmaSNgszF/cbsuzyBseGUnYaMJLLyimtys96PPPJKImy4D1y2rIu6SngDeIvMmR/DfGrZgt
	Xi8+lNxvg1oiewdeqp3hyRFuOI367t1E6ikzRoRD7ei8E952VQUwp73jcUh4MyQ80Uz+RxNayR3
	2xsO8243vCpXmea2IH3NdGcVJFWoKir8LqucUtM5fLM+6pj8F7+K1tY0ZzZJFe/JRJ34rW1SRR8
	BSUWVl43LuStJD+/hVNWchPC58F1z2cYxHpOT35VEt6D2h+7ty0wOA3NDKBwUTJczsANirML/Be
	nL3/BwlHkWglvqIt4zFPWMlU3ExBEniiV13SqlUume0+tWwbwKEMz0DGO7NE/OHKL4qLYUiliVU
	0IC9lCpMDoUWIG
X-Google-Smtp-Source: AGHT+IGaBFISMjqZ56jhqOkqG6YgWjBFJGtoPxP49Jy/1yngaLT4ocjmKacYDQWcrmZR3MpcJrfLmA==
X-Received: by 2002:a17:903:1c2:b0:26b:5346:5857 with SMTP id d9443c01a7336-27ed4a3719bmr75144915ad.24.1758879324875;
        Fri, 26 Sep 2025 02:35:24 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1c21:566:e1d1:c082:790c:7be6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cda43sm49247475ad.25.2025.09.26.02.35.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Sep 2025 02:35:24 -0700 (PDT)
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
	lance.yang@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v8 mm-new 12/12] Documentation: add BPF-based THP policy management
Date: Fri, 26 Sep 2025 17:33:43 +0800
Message-Id: <20250926093343.1000-13-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250926093343.1000-1-laoar.shao@gmail.com>
References: <20250926093343.1000-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pp85jjdwzrzsgbr8p53xanruqzhbnzqc
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B619C0002
X-Rspamd-Server: rspam10
X-HE-Tag: 1758879325-703267
X-HE-Meta: U2FsdGVkX18wcUDEFtBR34BLxacWBl7UKg9dLB8i/0i/nSVyT7/OHkgsUceZwsHU/dH3e2/GAWH/gRp/eZsh59r15WWNapAuqFa6RPrr9W0TPidGPX8iXvLcdSP9voGIk81LDsLf5kOLJcr+WLET6kK/r64tn1bStHYY2UPxSqpF+H9yK7XMuVLCl4D/tU0CU84VZ9tCcY5Y8kV9lV68GFcMRk8NVukvhw47iDDi+2yMIX/a5rxr06SLE02mqQoOyl9oWDIWQKeYejrsDH+GSuYUEkG7fzJsSkT60lzy8G6x5nkiTpMef3CEVLK0Z0gU9MSGv+1n/Xd5Rap+US/g7Qh8aB/JlhVr+PxhdtEEFZ2kCaT3SDx62dhlD2WfQE4vPNM2eozB34RiPAGUt1khzfW/sAr7qMWQOtsIgJ3fYpZFzxRcWLKe+B/iuvHQw2S55PIfrhNl2bqW3GwaClxqA5rPZvEpXDrtnPgm3/mNvSLbMniSyrucutiBGF6xwXuND3dbVdM5IPMSl/YMtspqBla/uTDuBbJ58A4WchP92akzLyFvlS3ybW6xYs6uQtiGoItdwN21W8hwnFl/JH9oXaLpFq2KMkFzdMrx5tWtzp92Pj6hqh6Xq4CulekpqwtHrGp5wbNpzu9e8qhzUMi1qp53W5tRsT33hnYv6Iz/kWXU2EV/9303Qz2EFGXf8N67u+g0YDScdD0+cPRgDbZC0LvePgq01p/7yOFH+MdSY+KYdwN/yHr8VnytfalJ01J12AxA8ChdfYgDufl2phq79K08GIM7wJR0qQ17kO3QZLj8FfVDvHI7BQOrPtmD8hotBbrN1chivHdG+e6HW8MrWs0g2Vpb3LXGrLEdhO2OHGfkJ7hUD5XbbLZNNGTNjRT6G1CobWCQuQWKkOUHB4u+8SYtF6kXCW08XFeDL3DqRAUzN7xH4ZvVmGCuCaVvrF53qS6gBR4UofYa7SubL6G
 SIUGaVIl
 Vct4qngc+s0qnJ+jxky1ai5D6Rq5JkZBYc3DQumjnLwp4mdgS9aS6srdwNY4kQN+QUDGysfQuyE55G22dLbNpxFSkMOlUgmwjmnsANCpXNnjscBbu1UrVzD4eAPQo3CbBRMU7nO2L7zas5O9XqUy676ISvb8uZpvk8xUz+9eA6NpZyszOdD5DS7bkruBTKTCUrT15fyfMB/2VxYBfeGB7H4rLOcDsqSiabyyHwdvbsmI1dj2VK+X/vgo/eNTh/GmQmp0SCLwBqBOwxLyxFek+dwdXs0wYUMg4eqPdmgitX3SqmHFTrgq8dfXwzIljtlIsyzp2S50XsZBwGtIZqL2CJ+lFq/cW+APInky+K9d4UcEOam5YVX79GfpUYB9SALJ0rj9XsSxLcLLBWGh42AwRupQ0JQi2ZNHDc8pv2n8XfTnd/X/X8GzmwT1VBJVgfBsfq3eDGAAdwpicrOo9CKBJTnw0F76at5TiaTn1w5VijFFuJY064MVL4RLqQEptSg4u+BAYIQVXcuVbkeU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the documentation.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 39 ++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 1654211cc6cf..fa03bcdb8854 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -738,3 +738,42 @@ support enabled just fine as always. No difference can be noted in
 hugetlbfs other than there will be less overall fragmentation. All
 usual features belonging to hugetlbfs are preserved and
 unaffected. libhugetlbfs will also work fine as usual.
+
+BPF-based THP adjustment
+========================
+
+Overview
+--------
+
+When the system is configured with "always" or "madvise" THP mode, a BPF program
+can be used to adjust THP allocation policies dynamically. This enables
+fine-grained control over THP decisions based on various factors including
+workload identity, allocation context, and system memory pressure.
+
+Program Interface
+-----------------
+
+This feature implements a struct_ops BPF program with the following interface::
+
+  int thp_get_order(struct vm_area_struct *vma,
+                    enum tva_type type,
+                    unsigned long orders);
+
+Parameters::
+
+  @vma: vm_area_struct associated with the THP allocation
+  @type: TVA type for current @vma
+  @orders: Bitmask of available THP orders for this allocation
+
+Return value::
+
+  The suggested THP order for allocation from the BPF program. Must be
+  a valid, available order.
+
+Implementation Notes
+--------------------
+
+This is currently an experimental feature.
+CONFIG_BPF_THP_GET_ORDER_EXPERIMENTAL must be enabled to use it.
+Only one BPF program can be attached at a time, but the program can be updated
+dynamically to adjust policies without requiring affected tasks to be restarted.
-- 
2.47.3


