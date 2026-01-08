Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BCADCF6ABF
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 10:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0FFD6B0098; Thu,  8 Jan 2026 05:16:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9DE6B0099; Thu,  8 Jan 2026 05:16:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B58E6B009B; Thu,  8 Jan 2026 05:16:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C26D6B0098
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:16:34 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1BDEDBA526
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:16:34 +0000 (UTC)
X-FDA: 84308392308.04.7A357A0
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com [209.85.215.194])
	by imf24.hostedemail.com (Postfix) with ESMTP id 595E218000F
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:16:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e9SX2msj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.215.194 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767867392; a=rsa-sha256;
	cv=none;
	b=3ec13L60Ip+hJMN3eNODkAdothpYDRSt+SxGlJYx35o9NvCY/41lrG+VgRfow/5oVR6Thy
	LDIGk9s1ScQ+d84R+49XWKpJNU/BqisIwIkLHCq1YPP0HOxlSdSEEFdSurcMo/SafVSDOc
	ronFuOUGUGmcza2w9A57iveD1Vxbshc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e9SX2msj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.215.194 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767867392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKs0XTtJuJVxxVwPA++DZZZ+CNpKQV3ASKLDqcig+Cw=;
	b=Xr1mt34A/JNoQiksbYl5mYbO7MnGX0dA7GK3srxGmaWWLdjE6XhJv6XPUpZHpyQHDIm2Y3
	R/K281cgaGubZ0EI7bCpyFrBcqeWfzLSJpCTcspoSPU/f/aLIpICMTH/lKw9eCWp9n/7IS
	9j5eyN93Xc0CAoXb/MEC95ZA3r1sQoc=
Received: by mail-pg1-f194.google.com with SMTP id 41be03b00d2f7-c0bccb8037eso1515361a12.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 02:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767867391; x=1768472191; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WKs0XTtJuJVxxVwPA++DZZZ+CNpKQV3ASKLDqcig+Cw=;
        b=e9SX2msj1geoaYC2Lt6/7nNy7yu/x6h9JqXOI/+y10NgaZs3a6ecUjzTfL4DWlKD5+
         FHFh/YQlGpv6KL7hhPRQl+KKLGFmds64fMPEhAL6ziuBj+XVKKSrtgoWiCTMaSAZsGi5
         RoQwLOl65nkgVmizJXy85sd+bYtErjpJSZqxrnCMaYw3epJqPWbgLQAfbqWyHA7LLeUa
         5nz49Kglu4OvY9rHhjTEy7vj96X/RilfOoCtl6dkdtNNyVyQOuNB/C+ctIMTubYSut3j
         8tkUtjWapCV827ltOKZfTw/W9IlypC62Iz2HodczUfJliLd43mFbW6IFpIUvFIBklIpE
         ksMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767867391; x=1768472191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WKs0XTtJuJVxxVwPA++DZZZ+CNpKQV3ASKLDqcig+Cw=;
        b=ge1AfCP4WtuAoDs/1c4ajSmM81pqEVh0Rk+8kPbA0Nlipc3/bQnWZhFDs8QEqUZkhI
         4P3JijXOHskb781O/X3/y1RU4nh2U5YmOJP+CcMhu/mmloDm4UDLr5x4hRKVYdROlsXc
         UE+dLGKwCs7KioBYHeeyYKexnofpmwYaomluAwzHB7rIoAMgNzSI+Rk1sB3WVVsYfFC/
         XxKHx8oPlMZTY3Npux0ADhqdr1fkogr1x5hzSwowh2+z7ZPwyifhKQovD075/zZu3MuU
         X2oCXKsUdsacAAaRVeDiKsvX1kbud488KGcg2B6zuCIDKIFDNuMKeX/N1bf+CHZIVeIk
         amhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIX5Q0LDn1cBaMT3jJQZwZ4YP1ta7LtJDUprbjfPpZEcJIEPV5NFhe9GqFnd8AOAbb+9afxSSn9w==@kvack.org
X-Gm-Message-State: AOJu0YwQM98JrgNtwjCF609vRY1w23pbV2hXBhBKKAAize2ofdtPwXYu
	U6hnMBxv+ILivFG36VMfUB9lKaB94ofeLhRdpBbw6XafBjBCrYZl0FxM
X-Gm-Gg: AY/fxX46L2LTIvP/OM3jHFHGXihcd56Exg3gKmhWK2UB3POdivKwbQwW5eDJdZc1H2s
	fDMxPXRdcoVjihy4+WwdXWt29SPLvDeUa4lHKLDB3O0Co4XykWMbZHAUhwL3NsrMTcjNHh+nWNT
	SxSbVfrDO4r7MLWMI6oRRq3jBpfsfior+MWBKstGlc48ZcuTP7jHgaoBfVsTrM/+Zv50foV09/P
	07skYPpZse22jXALIyYkRqDXCNU36ojJGIa7Qv+7WGnj63dg7ueSq1dlvHGuOl7guqErdmhlq4j
	lA6ahdFXlXIlHbYGKcLBs8UbdM1Siix5ejtMnaMjrAJQoI7x8E3QWdOK1W/LnOYJQA3g/iIISHo
	A1oIn33CIvEksm+DGy9KetsEfZ7+o2qNu6E+l136xyvtYpMk19Mk12S8IJHkErKjG0bLlorOu+l
	H0n8d5y6fJtBQ7xdTLzaYvYxcw
X-Google-Smtp-Source: AGHT+IG5cjHWe4nCIW20Z8QJTPxi/x38oc0S4rLZqrg1Nkqq2kgc6NrGn9A7eOqoxL6kXyUHFyaZNg==
X-Received: by 2002:a05:6a21:3285:b0:35f:b96d:af0f with SMTP id adf61e73a8af0-3898f94ca6emr4948333637.26.1767867390988;
        Thu, 08 Jan 2026 02:16:30 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:8352:dfa:3b18:eb4e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c49299sm73785245ad.42.2026.01.08.02.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 02:16:30 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akinobu.mita@gmail.com
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	bingjiao@google.com
Subject: [PATCH v3 2/3] mm: numa_emu: add document for NUMA emulation
Date: Thu,  8 Jan 2026 19:15:34 +0900
Message-ID: <20260108101535.50696-3-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260108101535.50696-1-akinobu.mita@gmail.com>
References: <20260108101535.50696-1-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 595E218000F
X-Rspamd-Server: rspam10
X-Stat-Signature: ppt4errzyqzp559jw473xh3quqpn1pz5
X-HE-Tag: 1767867392-19057
X-HE-Meta: U2FsdGVkX183gOxyEhTO8jfwnVNu4rWQh0V1asyB211+5O8oZhem5nGZqJnQRZoazJUJfNyGn4zaN/bmgnUjoN2rpsKybeZmUaq2ZE0nxHqy7lUoBmmDeeDm8uPhpVdM5XNCSVl1d2bufdBBjkG343fkrjOdICgLAGXWVidC3CdGNhzuwkJ4SzigoN7PcMEP/EFWxmYCtxfKmTb7Y2vmmrpcZpCT/FiSK3HxsIXqNGBeeyX5YYyzCGPZV92sF1QDTyQkA5Ig4ruGXDcMcpOtCytzoOOA19NpBqvjo16/Gg+53/ub7uHdITsSOF7QJFNUtGXSeSj8WqVL4UumQ8pJ8QlUo/89PAk34+shSgc+JvjcCd0sFmIfLWclHBoWR/xJhm1q+f+C4zGJxbKKGZCJQuQWAoPsBGSl5bO/hPoaUBEToacDdmCq9biD5RGUMqcXOHohxz8+Y205rSnKBE9ZSdy9w3xbdoNSTo8NlpGe/XeEd6vfC4otXytdj0BVcCnauJHZ2Ed3W/KEkv7dorXJpyi/KN44Teu6by8k60BscltjmHMdoN2ydhy13wVF6QX9RPwxgTkRYo6dXY/iRvAO4cgpc29ogKWYT+fXLbnnnjNJ9b40Tc56Nem4hK/Dx1I9U9U03CvqgO0iOUyLfgKk/pRvpRBCfuwWi6+ylvDIQoNbQUndkdJnhbiQdhDWgL15qUvOk8/qkb6fgkwjmsMaBTEufrjFfLfhlX50dT8d1wwnA+Nib0qg97ZgrbIb/+OyFxCLbnlKUdvSUp8skhKqf7WL3iClP2QJsXLNgouHMl2ohtHIJvDDrFjzF5UEaHAGZDHVu12ney5y8/Jj6Osjl+CWSB7vFFuCvW/uRJR+7Kh2QUNiikmorQD5gr7kfUlM8+lEpka7zVXc+FxfxxQwSUoVlajX4ktU95hYjhuipnzGC+HtN9YUe3WVIafcBeRniuwXMaw8zImpwIW5mHH
 yYKv125Y
 oJ5W01BKO4ENb9vl1AxcZ4i009Iz3Oa+MWVc2G2Ln7H+z1kndsKOJ0VxfpHNLxXSqxwY+cJMsB86SN0/DmIW3iUz5zDnD1dPt0pAos1EPl0stgpb1qZZKeHYJWyxk/jjsSd1dkyhHunRGO6+5JlZJA/mf1bcu01Fkyz3UVMfexAsGWj66X9rMQ/V6EB5ZBmJPCiUWY77fUs5x0AVsiOJsywSEyFGNZQ+xvFZ6D/AQbGlp8ZSUjbo4s9ApaFPqL66fDGYBXERcmMmFlrW2Mc4jGsXiZxNpKPkkeVPO2XmVeuR3ru0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a document with a brief explanation of numa emulation and how to use
the newly added "numa_emulation.adistance=" kernel cmdline parameter.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
v2:
- added in v2

 Documentation/mm/index.rst          |  1 +
 Documentation/mm/numa_emulation.rst | 30 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)
 create mode 100644 Documentation/mm/numa_emulation.rst

diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index 7aa2a8886908..7d628edd6a17 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -24,6 +24,7 @@ see the :doc:`admin guide <../admin-guide/mm/index>`.
    page_cache
    shmfs
    oom
+   numa_emulation
 
 Unsorted Documentation
 ======================
diff --git a/Documentation/mm/numa_emulation.rst b/Documentation/mm/numa_emulation.rst
new file mode 100644
index 000000000000..dce9f607c031
--- /dev/null
+++ b/Documentation/mm/numa_emulation.rst
@@ -0,0 +1,30 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============
+NUMA emulation
+==============
+
+If CONFIG_NUMA_EMU is enabled, you can create fake NUMA nodes with
+``numa=fake=`` kernel cmdline option.
+See Documentation/admin-guide/kernel-parameters.txt and
+Documentation/arch/x86/x86_64/fake-numa-for-cpusets.rst for more information.
+
+
+Multiple Memory Tiers Creation
+==============================
+
+The "numa_emulation.adistance=" kernel cmdline option allows you to set
+the abstract distance for each NUMA node.
+
+For example, you can create two fake nodes, each in a different memory
+tier by booting with "numa=fake=2 numa_emulation.adistance=576,704".
+Here, the abstract distances of node0 and node1 are set to 576 and 706,
+respectively.
+
+Each memory tier covers an abstract distance chunk size of 128. Thus,
+nodes with abstract distances between 512 and 639 are classified into the
+same memory tier, and nodes with abstract distances between 640 and 767
+are classified into the next slower memory tier.
+
+The abstract distance of fake nodes not specified in the parameter will
+be the default DRAM abstract distance of 576.
-- 
2.43.0


