Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72E7DE6FE29
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 20:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5A3D6B00A0; Tue, 23 Dec 2025 15:15:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B068E6B00A1; Tue, 23 Dec 2025 15:15:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A091C6B00A2; Tue, 23 Dec 2025 15:15:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0066B00A0
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 15:15:14 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F44C160453
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:15:14 +0000 (UTC)
X-FDA: 84251840148.23.9351E53
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id 54F67C0010
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:15:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cvrXafcv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766520912; a=rsa-sha256;
	cv=none;
	b=4XZHbuSHm4MQcgTxQ17VbC17IPuZjq71dNRJ7krJYGNofkK2EHPU+dYG+kdBaCzk0Lv4qT
	5OfkL8IB73ddMY5p+NoeWdgrUsnTyMWmpAX7j/QQBleMzEkQNwYw98LtRYv9+SN5BQIgcH
	N2pP4MAnGNIorRG9dTi5s1cYFSvwpik=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cvrXafcv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766520912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VlLs7P9pgO4eKILsAhoNSySRcyvhRmXbFz4fdi2tBV4=;
	b=Mh4rvceF8Th3bOuioIyshqtS0RBxu0p0cYQpV7a6VDY43/q6XL0sb1LtygI/yt+sapPB4j
	gV/ijTOOFmr/qQr76fRV1G87NV8OBwGNbidJj21738VIZdHTaN3276rmsH2sxsEu6pStrt
	Mfmg93r9KC5VVjPwGzbHQK4mK+mswF0=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-6467bed0d2fso2547732d50.0
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 12:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766520911; x=1767125711; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=VlLs7P9pgO4eKILsAhoNSySRcyvhRmXbFz4fdi2tBV4=;
        b=cvrXafcvpKtKsIYeeowgIwb/ymaHmYNqPtkOET5TRF6WlMDe3b1R1wi8vBI/p3MKFb
         4Wib55aqp/RcxFvRYwCESl1yp8dOq+2S9mwS+MO1cK8Rp+x2x9rPDxCw+VfUHjSrrr3d
         6JnhT6qg0guH9520BpznxI11tMENNe3f0xM3JwLKXXn0SXPxumtuCWy8Amd9IsBwV5N+
         uuDVVS/t4xJu6WQRTBNckZ6Y74KWRgfrY/7QhR6HEEL3jLhhVvoFq7RiAzCXaZY+JuFV
         L79Z99bBWlio6zZ+FXqacTq8jhLb2CFx39g2a7I1ANEn+4clPXSlNIQsAntwz5v/MZ3P
         zKNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766520911; x=1767125711;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VlLs7P9pgO4eKILsAhoNSySRcyvhRmXbFz4fdi2tBV4=;
        b=UIcOrxddowbitvL5efcGHak2ewNDalrFcQUFJLxEjWUV29yL5KX5Kwb1KZcds+lgIY
         /ooIXFYKGj5pDG5hkrn+NQ97ugaAwQH8pYJeq+XYlQB+qoxf3MQaHxKJy8OfddGSB4mg
         kVH/xFUphAOuTb9vYUyC0VjhAnIXKGsx0hl2ul4QDMS+Pd3KBzj+xQUfDX4JBP+Wiiow
         ZWMGdpBrkhwCgs4WyVjJyDSKCp+3DzyC/NWeC7LRoZbF9NSVrapbFP/RNRtQru6EG4Bm
         TAxwr5d5LLJ4Mtz0Iol1wjB/u9sux+d0rdLYvKpnqOSFejDi9zNTyr948Qwh8GOxJli0
         xVeA==
X-Forwarded-Encrypted: i=1; AJvYcCWddym4kuQrAmqgyGT1y4qX49G8H8zTPL5DiXwfQbWSYbXKY6sdZHECBFSvMySJtrdqEE6CnNIHAQ==@kvack.org
X-Gm-Message-State: AOJu0Yyuq0+HH/HOPVp/akh9Fx5XcLKh0c5x+ozooyaU9hXmKn/nOm3Y
	QE8R4In+piVkESME6ONVR1bD6GAAnRBmyuxFlTuoUaJJgJwtlZWn9tbtNbsJbEwP498=
X-Gm-Gg: AY/fxX5ztdrnnzQ8xWwMYRa+p3EjlFkZbne1rpfQQAXsJ82gnFenVE+OTbzt00wAY6w
	jjaZdkTjgZ+5HuUAGzGcWuWAkvf936aK7/RqQL8k/FCkmLIDoH4fSFZJOfmLTG4+MOYdglUga0A
	uZtRkeJDuEiCZTaO1Rk03WJV1sxRIlaFWKNXwVEejKVQ4GAgGtOSmrF6MjutpoIvTLc/7wv7XUb
	L73+pIPXMOYvWRl5LhKINBSvwrBkiPZhIfq1rHHNwcvXx6J+48LnhH8rC+oVJ4pJ68Cxwf0R0zR
	kyRlreLuAWbTRFgs6d28Rthxdglm8EPjn5EnbaoofJb78YO5cW5KdTk+UjmvA81+FHk3xab2wEh
	UJ44lillWmnfPoLVveRGdV+3TNlQk+eFvi+4tN83grPO8nuPiv7izWLjthSo9mT/PX9P6yR6vCk
	Hasq1hJeUFnJ9OEly7w8rtGpvL26n01JS+BAuuLVCD8G7CTxPQV2kfU6ORIRWxbgTtey/XNvfOg
	md3AnSzGbdnfjfDe+DgtK4hyFnmcU8vpemM0w==
X-Google-Smtp-Source: AGHT+IE9hkWfg/wdg+y79EHOSLumqYhte+VdlGUYNiXwnb13zkCzLpIQx0sZj2VsFDL0IjdRdTFEQA==
X-Received: by 2002:a05:690e:130d:b0:63f:bf9d:e530 with SMTP id 956f58d0204a3-6466a86bd2emr13280316d50.29.1766520911203;
        Tue, 23 Dec 2025 12:15:11 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fb44f0d57sm57949307b3.31.2025.12.23.12.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 12:15:10 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	pratyush@kernel.org
Subject: [PATCH v1] liveupdate: separate memfd support into LIVEUPDATE_MEMFD
Date: Tue, 23 Dec 2025 15:15:06 -0500
Message-ID: <20251223201506.2334991-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 54F67C0010
X-Rspamd-Server: rspam10
X-Stat-Signature: 4nfjr5k4ikangrbemtehgadgrwmmofmg
X-HE-Tag: 1766520912-263923
X-HE-Meta: U2FsdGVkX1988tv/W3HvedJg6frwdM/hhu7uBAS77Fz/NioUeKdcK/3jlpRpSCxk7yjIMGKsWUTCno0SuSZqMSYjMPEJkMYrYgMlP5nFSxCa5A0+MeBm9Y3Srs0JMfzLP4H8MC61QMSDjVcAgKkc1oBZFmIeCB0PWBnY/3sUh39byYt5bqFToNDK8Ptem0epM8ybhQyPc7zYg85Zt22IMnC8hkt16ytmV8SE2MVPLTRjW7iYWY9eERUtk/YIXzouKRf0Lu/Wp3ZVr4TSIHiW0cDsJ362Rlca1A+ztirCAC+CqGx394gOcMbagfyDxKy3qG+dCrK5MVN/OlU+LNWPImpnHxebK+NtepACqdYdsatfAiw+5o10KMv0qG+u7D1NiN7P4ufLIXBazyOYl9/UmmopJGvZiTE2UKrGxxCjGYvJeC8+qTrZ4vTn0jWnaXi1sP/K0M5adBxsHttMMLvmbXTR5jz6dWOXba9HSh54ciLlMLoWeGb8yHNDY6ms0J91tAF5v7Qntebr2aNl3289jSg6F+HihFnKOJtbZszW6Zewnw/vs6KI1W+Z9p1YXBiX7w6WduK+OEFhvjn+Z786fcdxdPv4qeOQASDcoohQ38e0o9ilSwRzOcychS7SJcnzJAOmCMTEEN3RGvMbTI/NXOTJSoxF0OTo9Am/odJvM88J0UevR6OilJCrfY7qcrFSdahL6rrSzncQORQhL1BE5jd+cWEmZxQBli/JPuzvHao7YdGSs8TsLub1kP74tve/RxdO3HGS4PhX7Rne7gx/I/NuCZTFzHI1XUtToxiGF9p/1HIcYLkl+1ZKs++z2IcO1qXOvcoM6XqETGrsXGbzNh3xTYKDmlWkFoMy/CkaLBkqwAwTEvFH9z+nzM5U5E9J41I+6QrkdPixWnG5Pl4s0ELISfSjG7ABEg1XNKe9urklmgiZLrHKZyKBylzoFNu5WkHUk1+eFA8HKbeuGnH
 14b6BN32
 xAfYFqwqKtmEej88GKQ1YD7AdITmwJKceV5XFDmK+FNUYLRB3udF1cP+CrLwyswP6twdDdGFhgeXfT7CyBiOVdfDbg2SsaT1GK7cnyywafbOsuzQ7HlHEW54B2APTq+B9H65XQKKj9efajOZzYtmjD8hLbh3eAfOHqrIqptzv5TuyHsTGBykYNnF5nWnOb51NS1nvjDi9vpQ9l2T+5NlNXcXbigAaSIuBZNu1egXPsP5zFRMfHDlQh1AE+CguYLf6fNFeIG1CMUYZ4UMVzY+1uXrC3KinloxKdXQCRSN3kQ3oHUx6VdWZcz59N/BJSnHi2SkpR218BZVsETIuEYsMOtgQMrfPGizt8wU0MzvgtBJnGU9ZjcLT6D6k1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Decouple memfd preservation support from the core Live Update
Orchestrator configuration.

Previously, enabling CONFIG_LIVEUPDATE forced a dependency on
CONFIG_SHMEM and unconditionally compiled memfd_luo.o. However, Live
Update may be used for purposes that do not require memfd-backed memory
preservation.

Introduce CONFIG_LIVEUPDATE_MEMFD to gate memfd_luo.o. This moves the
SHMEM and MEMFD_CREATE dependencies to the specific feature that needs
them, allowing the base LIVEUPDATE option to be selected independently
of shared memory support.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/Kconfig | 16 +++++++++++++++-
 mm/Makefile               |  2 +-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index d2aeaf13c3ac..9a1a8cdcf16c 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -54,7 +54,6 @@ config KEXEC_HANDOVER_ENABLE_DEFAULT
 config LIVEUPDATE
 	bool "Live Update Orchestrator"
 	depends on KEXEC_HANDOVER
-	depends on SHMEM
 	help
 	  Enable the Live Update Orchestrator. Live Update is a mechanism,
 	  typically based on kexec, that allows the kernel to be updated
@@ -73,4 +72,19 @@ config LIVEUPDATE
 
 	  If unsure, say N.
 
+config LIVEUPDATE_MEMFD
+	bool "Live update support for memfd"
+	depends on LIVEUPDATE
+	depends on MEMFD_CREATE
+	depends on SHMEM
+	help
+	  Enable live update support for memfd regions. This allows preserving
+	  memfd-backed memory across kernel live updates.
+
+	  This can be used to back VM memory with memfds, allowing the guest
+	  memory to persist, or for other user workloads needing to preserve
+	  pages.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 9175f8cc6565..798f04233d71 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -100,7 +100,7 @@ obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
-obj-$(CONFIG_LIVEUPDATE) += memfd_luo.o
+obj-$(CONFIG_LIVEUPDATE_MEMFD) += memfd_luo.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
 ifdef CONFIG_SWAP

base-commit: cc3aa43b44bdb43dfbac0fcb51c56594a11338a8
-- 
2.52.0.351.gbe84eed79e-goog


