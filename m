Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEE7AC982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE9D66B00AE; Tue, 22 Sep 2026 04:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9B7F6B00AF; Tue, 22 Sep 2026 04:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62A76B00B0; Tue, 22 Sep 2026 04:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A79796B00AE
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:44:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 435A1403DC
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:44:39 +0000 (UTC)
X-FDA: 85240762278.09.2B7F26D
Received: from mail-pj2-f0.google.com (mail-pj2-f0.google.com [74.125.227.128])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7472F100004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:44:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bVnqcHfK;
	spf=pass (imf14.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790066677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JU/OT6l28quZrPrYfN7XUOSpOrASPsDzS2PQ3ztfmsA=;
	b=SXofi4kJUxPutYwPTsHJfejjPrIab3z15dyMM3xTDQV+EtmLWK6gCYY/KqTQOFveuPQkmU
	uCpefe3da/WMaOAFjFvxJm8D066L3GdFuiIFx6TSFfPrZ0o3wbgVeNPxVUk9wlpRLJ4qwz
	jT36glW6FZFIB38OAHCXrOPTiD49iFY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790066677;
	b=fn1xAEpGF185tLvLDzWm9ndC1D5TUa26gK5Xn/Tt0Xf+AFKoW37Zf8WGJ1kCcUMTL1tjvn
	iOhmoXj74p9dG+Bls14cTHHi4hPrruGM6WDwV0fe8FG08ADOyFsNNlWi8dYuqoIFek1cV0
	Rhr0/N4JYBKMUseDqcDABxZHoCfy7nI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bVnqcHfK;
	spf=pass (imf14.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f0.google.com with SMTP id 98e67ed59e1d1-39e0e245eadso1692494a91.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790066676; x=1790671476; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JU/OT6l28quZrPrYfN7XUOSpOrASPsDzS2PQ3ztfmsA=;
        b=bVnqcHfKMhaPVNZyIqZeeFhIwvGFLngtrJ1GYvHs98emMYUJK0PeyOxOBRief4hJSX
         HiKkIueW8exUKkz67gUjHuqa+4hRyusbvzA1afx+k7bfrTcqerwtNBQHCC5lt72Hqekv
         xPA+EEiVWtfvAd7tXe66JvfNOqqaTgWMxCDv3lZ7Ax/5YRJr3xrfq/lUjnMZOQEn4Zr7
         gNyT44lqHxWCAwRSWrLOjQWaL3PKMjXkJ0sCDz0TEXFtONjn4nb2W/3ZC6xxFzKLlvOT
         TGLBsYvFKUc4+T/avSv5fm1+jmj1ItOo5Fh4ZdfQDS2uUuxDGBhH7Dh5xCFG9EEcPLps
         YaRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790066676; x=1790671476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JU/OT6l28quZrPrYfN7XUOSpOrASPsDzS2PQ3ztfmsA=;
        b=eU72vKpsrlH8+njp84I/6gw+3dA+NwF4eJE7CstYvUUoqBGGmIZmnb3oA0EZP/n5n8
         SqGtbw4YFpiUfcFhhDv9vss+AEKrER90BWH4CcvRXIKpUjtpVXUdPWmmKxWI2SwzRONo
         NsMA3VLL0tXt5efOA45ZvDODV6U0h+iHHEcJwHlw84bftnoOjUKwyNJkzzNaYHxipj6n
         u/qxcjs8CQJox99ooX5i/H3bFhY183XWJi0RZJ7G0aufHc/CPy0UbBfJMLWi5PiwbndI
         h8JkPeMsyBUEPkEfG9hRv5lkdkn2KCSl9TGkPrLd1Z5f1yKG0KbBprZo7cHqttnRWuJE
         FoaA==
X-Forwarded-Encrypted: i=1; AKwUvBzrXe0Gba3EcY7nr5vTtp5YCLEtzrzKygIAI33AAQxd7WniZu5fYB+Sbughmd+t78TNgfuKWEtLtw==@kvack.org
X-Gm-Message-State: AFuF++mvmO/eTtL++0Vz920emZsFuSE6qxoufRvkRmapa1BZVqCgygs0
	4gpHOPZXvmqtUNmtvb6wOglgW7JfycefOLFrus1t6DO46eJtfzKhEbqH
X-Gm-Gg: AYBFou3cQfaiZXbQlIs1BfQ0scye0vQ8b0gr//pZR+t35ZoNqcQieMc3D2vak2Aexdc
	PONrBVYAx6GCq/BwALSPvIyQ+RYyL0t3N28cfm91fMkRC87m9qDn3+1p+Q+Q8p5ZDJdCQ6fEbIQ
	CdRUZyaKcpi2twMdPPr5b7rse1ZxfTWUWVy+2ty4URMQCoaw65lMMMbBHkKX7L5GqLN1A//U9P1
	Ar1Q4ut0V1TOyX/OG+AfcDtTgrByg7ryGfW5cqJiN5tM2opi1oEUTCASfGL9uvVmV29F77En+Ol
	+EbeQf7pI0rmP4xxgIVKxzXgmIrbSTbOTaCAf7749nyj2ef2B8fGy01t20dSfhbTMjk6+Utcaz4
	rYdvNRtS86SSq5S0k6dmdxJdzSzcZnKP0xDqd9k3YQdYV9BGAWhkvyiZvNd4KDXwYErRhQXx/Aj
	To0UxSq9ocFMMuPOPmgi8PDXzJzV/1rjpOYzzqorelJcpLUYqfZCh40s4HNApgjSsk5QICHcPQl
	bYCPFpcv3U=
X-Received: by 2002:a17:90b:5408:b0:39e:6a81:f34d with SMTP id 98e67ed59e1d1-3a07320077dmr483552a91.39.1790066676289;
        Tue, 22 Sep 2026 01:44:36 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0674a5ae4sm3670016a91.12.2026.09.22.01.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:44:34 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v7 7/9] of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
Date: Tue, 22 Sep 2026 16:42:54 +0800
Message-ID: <20260922084256.1515554-8-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922084256.1515554-1-chenwandun1@gmail.com>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dtg9qcf6yiw95obzdxqtttia3r1rh133
X-Rspam-User: 
X-Rspamd-Queue-Id: 7472F100004
X-Rspamd-Server: rspam03
X-HE-Tag: 1790066677-241889
X-HE-Meta: U2FsdGVkX1+0slgQVPzwiDgmhifas6AKwIG/3VyNgmAdETgze6+4ez07ojBrvpoMzCLr/kBVoOi64tnswz2g0MtDcqcY1ZRhMMYCSRaqvEh8CaRbdCtlIF07s+w7IB4MBJnNq+7DGxJ8uBPkgnloIgz6rrfqR8t+uF3ZGIQAhyqaKe9+GBC5tcrCS9DV/l5xLg2VIpJxuL180NBOmT+M/X6VSxcFsVd7FdwBPni7bm/JMdywXzlT1XTK72ApbtKjH2BLRf1f465WYf/lJeIO0Ed0FHAoh4nbpvg66ODKGxZXhAAKsTZjtcoMrig9LD/WCcKkuNTk6IdgP/NHzUjcKjBFJnRfvlHRpgvT7Xk42HeyVFU/BZnc2BOtWYMO/V/awk/OCe+msd6uS2YFu9Ku5XZbq7ty6/RfKwcohdgkEWf37YO5vzcbEie0OJAiMAv5Ji+RX1HF8fhBE61NsZGKCKQcU9CJxLCVcL8RLRRDfp4L+Zj23ajRvD8W/U77IF9KRSnQRdQUqa/LUwUMrd4tjdh3va3O0MoyA83xci7xGEtbmSDmsfkGxQiUCT3P6ZmGwgqd+/O3BWfZxcvJ2H1385eKDYZrvk/psmIIyiTTpLExEjS8IhBf2AbnP0ALMBuqm+d8kafLdmgk3PCWiSiqFKWKKGzp/OVmJzYhnuiIMqI1Ue3JKhIP7bhkux+J+2Sl3TOUQDuKR2aiBm6qTzmr64eE4dFMYdMQKL0AziNvDmrZbz+LtCefa59+g/Dj15+h2c5/dGAEWu57auVz+vXUv3qxdMODfyVwXTLtfGfQfChTPSpORdtDH54sl/EB1+/rh23yOjFxGHupMQiItFsoVuhPnk9ZaBMzcy4I8b/Pq2MGuj5SbpJzml4EPZjB5gFKp8fwYutIIL+Va8jckWQ7BGhFnmBL8C7VG8OOvkXkdPH2D6UShNgdwtGXJ2EwjVqfIPvYK16i3fiHHq2K4gh
 kewzUiTp
 WA3CIzBcrkbG9E554yrLKm4cUvBGhrDQ3U0OJeh2aideFT+VKSdizm1u4CPmFERLX9xrmKoEZWkLHHdlft33iZKOceqsdi8Qsys0rBjbnZq/g0ZdRiL78+XMBKZxEGhCvnTawjVoyCbtYs4K5+s+5GfgJWijwEspRnhyjI+lgljPqJbMYToBDmr5zmT69zjzJZCMR5PB02nsFxuRBUeF9d5/KKwg0+0JgcuIF7O4+jIbp8U1ecinCTUy+U4fvYPK/CwU1sGRSU8todvDd40dmeb4KL+S8//Olln6EURJKOs9SjIuGd/OCOK9BDvIQ20nPBqCPQrDx8V6P2ZSu5UnkFAcCdkOmNfsli01EqWX1iZGWeGmpPSyvYCIHyfjfYh2tNeq9zlD/LV9Ry1mH/DBJQ7MF/ZG23uRBe9wk4TilnYnb5t5wN4kwG144nwA14yIUapeUd/xhuozrxM58KLX2EZGCCKK3lyyFNx0S1KTUj9ArAzIRGb3Uyv13fnJ7cfmqiYPedT8HKSNPZNb+y/83gM76DDWsUzKjSd0E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Mark non-dumpable reserved-memory regions with MEMBLOCK_NODUMP so
kdump can omit them from the vmcore.

The marking is guarded by CONFIG_CRASH_DUMP so non-kdump kernels do not
pay the cost of splitting memblock.memory entries at NODUMP boundaries.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
---
 drivers/of/fdt.c             |  1 +
 drivers/of/of_private.h      |  1 +
 drivers/of/of_reserved_mem.c | 15 +++++++++++++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index a64afc3ded3d..286fd4db6312 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1285,6 +1285,7 @@ void __init unflatten_device_tree(void)
 
 	/* Save the statically-placed regions in the reserved_mem array */
 	fdt_scan_reserved_mem_late();
+	fdt_mark_reserve_mem_nodump();
 
 	/* Populate an empty root node when bootloader doesn't provide one */
 	if (!fdt) {
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index 0ae16da066e2..505735732c13 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -187,6 +187,7 @@ static inline struct device_node *__of_get_dma_parent(const struct device_node *
 
 int fdt_scan_reserved_mem(void);
 void __init fdt_scan_reserved_mem_late(void);
+void __init fdt_mark_reserve_mem_nodump(void);
 
 bool of_fdt_device_is_available(const void *blob, unsigned long node);
 
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 8c9d6395d6a3..f29a07e8fb23 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -677,6 +677,21 @@ static void __init fdt_init_reserved_mem_node(unsigned long node, const char *un
 	reserved_mem_count++;
 }
 
+void __init fdt_mark_reserve_mem_nodump(void)
+{
+	struct reserved_mem *rmem;
+	int i;
+
+	if (!IS_ENABLED(CONFIG_CRASH_DUMP))
+		return;
+
+	for (i = 0; i < reserved_mem_count; i++) {
+		rmem = &reserved_mem[i];
+		if (rmem->size && !rmem->dumpable)
+			memblock_mark_nodump(rmem->base, rmem->size);
+	}
+}
+
 struct rmem_assigned_device {
 	struct device *dev;
 	struct reserved_mem *rmem;
-- 
2.43.0


