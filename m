Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1B22C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 09:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7C696B00AC; Thu,  6 Aug 2026 05:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C1F6B00AF; Thu,  6 Aug 2026 05:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1C3E6B00B0; Thu,  6 Aug 2026 05:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D3B56B00AC
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:36:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E9C51A06D5
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:36:27 +0000 (UTC)
X-FDA: 85070339214.09.A2888C5
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4236016000B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:36:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e3LO9zcO;
	spf=pass (imf08.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786008985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JoRhdZOCeEiS1VMpBUeU4kVAqK2jVYvx0TEggrSzApM=;
	b=lHdqk81degWapfJbYYCj/p5j9BB48O4K2raXpeho/pT69dP0YtPbDXUzlp2uLHMbnYL5N0
	Hl7kAlycUTvavG8p52rIoq+6k6n1lXBY5lQDKQQW5Qj4I9VNJqNXpyF6N4fuf2semLoxMl
	5vy7VK02aj/sDE3+E6eHjYhGMfb+biA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786008985;
	b=n4PcK85OtX0XblWaUYXb3BmylEUUvXlcunSkPv8tLuZiSyEihlUkpbAdP00L6MOZnyxlBi
	YofvCqHjvGGav+qmibagE6eDh4HI2o04EVp1WhTRueHX5gSQCPCKfaqSZzKcMQQkk+HRk9
	BKabj2b16ijPW/7rA51sRU1Aq3sRcbI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e3LO9zcO;
	spf=pass (imf08.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-84e84a6c4bfso851618b3a.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 02:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786008984; x=1786613784; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JoRhdZOCeEiS1VMpBUeU4kVAqK2jVYvx0TEggrSzApM=;
        b=e3LO9zcOdyjZ534jxBJZ232M1uD/tp6h1ufbVWvW3cyRT89J+YOixo+/p98yEcz0Jc
         kxplvnmQKFsYTbyWOxLERwQiQHcCfjwEIkLQL5xUqU9PwQS02uQ/m6GdXkX3WLzhIS6N
         4p4OkFr2g59kDEBDman/aAqE701gbat/NhWoGd/Rjkr7RoEND95gc+F3atndv9cKwJwS
         IXxBrO6w21xmSMFhK9nqAPWDrTvYgV3owvxhznUSSrsYcJ1xrS0TiInl2s8ju/6KHR5C
         KW9l5ZH6GfqhiEM37FtMvjIO/cpiTZYDqkMOPzPKrPourhvstKppIS1fWc/I68qfy1It
         7gwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786008984; x=1786613784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JoRhdZOCeEiS1VMpBUeU4kVAqK2jVYvx0TEggrSzApM=;
        b=iDmj24OvKGVEMHTlp2B9EmxIM7eh/jOEO99BIBaplkJZdhYxdlyexRNgxC7mxIpqw4
         ZESLpD29N2sMamElGV+GZESj1HVrcpsD+S0R4jNwkDGZRF/DmPDe7r+zC8kOrF+/ehyE
         TpnsAs8dlDAmFFewx6W6ucDsg36bnYP6jITT2SKRfT45kuz+VCPzIXnhIUjdO23hjnr6
         /LTCHSh7vNkE5EB4SUlDpE6x/uZXEdt6Ajw1pb/reWnW3gjIubKoJn7h6NPqd+MBvCPP
         TXhe3KQdMVMxEk0vgpKod9sTcQQpMfWS/Ktv/n2PvCwNhRL74vC/pHv+joGVUWX8CyjC
         G0HA==
X-Forwarded-Encrypted: i=1; AHgh+RqFlMmBuKSvYCxq/d9TP3MkhYv5A29OdSE4xKq2FlXDC/hl2YViZxtFIJvObWmNKzdEqA9kpyAqiw==@kvack.org
X-Gm-Message-State: AOJu0YxuBqq/zk5cGaun022JQ5frvWpDNOM+yRtyjqCRNyjc82XUBAfm
	vLAEWEXt/wkyugsRqgK/UcDr2/tq3w1S/lr9boAjr5KbOGNswmmF9+5V
X-Gm-Gg: AR+sD12rLLIHdUI5cGV+GeVdxRTZCDBgo9WQDIlMPpAwyRdV3DYNthV3YkfrLejVxcu
	aLmmAIl7nFrtTPrKClBQ64XuxXHS7zS+D8iODcaiBy6YSR3CK1NcAgi1u22X1dzBMiP9sOTNrRi
	VPsQOtEeWBeW2trc80k4EwGzMlHQISenM/1d7tY6M4Ci4Tmqj6iPCqCl2DpyLZxpCPl19dR1Nbp
	WAn2MQ8OalkSqYWkf3M5cnkfxUgDVY9CO5wVx5psP7c7oYmzDzSx85wkhE/b+o81hCkCZHzVGvj
	lPu1vtgepCR4t+SwamNGQFndHd/1oTfdRp1BuRA+C0HN3fAQU6KV1vImz1fR5ntTn5VeOO+fOUf
	5+DGhtN8V1V9gxAEOBIOhtNSe5165dIisqZYXALlszHIs9pyqgPrGohsVMIr/vH4Ulxb5cH9kcS
	sbz6EX9/wX/SK02ST5kZH4jNCnTUMN5+4U8hnqBKYuQXgI3H/28RNEn2R2LKOZxCLvbrTsgeYPh
	A==
X-Received: by 2002:a05:6a00:f8a:b0:847:9dd7:2683 with SMTP id d2e1a72fcca58-84f41df42ccmr6551184b3a.9.1786008984000;
        Thu, 06 Aug 2026 02:36:24 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f453b0aeasm1043878b3a.13.2026.08.06.02.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 02:36:23 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	chenhuacai@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	baoquan.he@linux.dev,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	m.szyprowski@samsung.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org,
	iommu@lists.linux.dev
Cc: kernel@xen0n.name,
	alex@ghiti.fr,
	akpm@linux-foundation.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com
Subject: [PATCH v5 4/8] of: reserved_mem: mark /memreserve/ entries as MEMBLOCK_NODUMP
Date: Thu,  6 Aug 2026 17:35:15 +0800
Message-ID: <20260806093519.2907771-5-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806093519.2907771-1-chenwandun1@gmail.com>
References: <20260806093519.2907771-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4236016000B
X-Stat-Signature: ksfuut7of5bkwgjytbrmycg5ae87thkd
X-HE-Tag: 1786008985-800838
X-HE-Meta: U2FsdGVkX19MvpkRVI8Y8j2kCHIy8LyM1Xt0VnE+ya/ACN8DkhlTDIRURlXAC78Ovvi6iqx5xaqClDs8LLFIZVwjHDm2HiScE0aWyT5YecU5cQJwwP82Yx6psrfk6mf/edbmK1PUsV56GpqzKHs1E02Rqb4y4mdALE3e29FnUsVWiQ2tOtOp+g6I7HMXN6GFzJJG+UbZ3PrlTiRwdx1QgIp+OOATuj0VnANy8GYzG4yza8fZhHTNq50wSp2gMEfIPP5lEo080Is1UIAhNsZMo5hoDLViUJrKhc+KprDpOaQ+R+cMshNKu+HQZV2QVxMU3zZT/WPVASUDFDPsQm2Xj9H3LrU73hqZzOQYFBMC1duMXpmdXz7vXX+Juaw6SAG8Ygwy5acMcecLRIZqQReqdBGtePEAN/vbhjJFV9tnk483V4EJ5DK6SQSAmWsikXOpGi3PT/wYLod6eep6PWQsU5zRZi5/+KtFKX8MdqT3mCZjMkIREBlAERM5aEBrSEWtwSJDVkt585r+jA+Va1/gItjEegeW/kE0nDGaZmqxO2zrm1fFceI0QaKDb+mdH+fq5qRXfyznIcYTHPM+cR7kYOteY0evVqXYLsMnJYlEmyyVLK2Upt+E/6TfHRvY6Z4LcDpWT5dMaVjsW3ySfENy8QJ2xBEJ9Bi0YqyEx6M79/eqP7PHIZybt9ZINaym8tFqtw00A3HLn+ezwY/6BRJ257EEblQPY3PYJBAbzGpZ2/rNC3nKD3j/t5RkqPkjFtxPXG/cNlCtS6gVwl+1SSBWqV1bHr+PVlHxLet+e+Iwv3F5eO7yOBXfT8pvCiFnyRN/qBeJAx451TTfF3/fTqFWJna4QKU+q/VUu6Rx93b2HJwH9SHaVbbpqW4kQSROzzhyMJzYHL0iZJZwNMiBXCh/BlRmMJGqNo0+hGim0CrYM+UawzEQtQMS0k3SYqKa8xzECi46OVWpFgr9dRzgp37
 EzqFQT06
 ztyLW4UX+YEaE8eFzmrOrRCDJKSyC0RuDPV4Jt3BixP8o1H2YMa+aH9MnwbMjSkT5hHBh2+rNqAwQOVbzZl40Dx8KnnLhwhrwibz/xb9IKRbH+oWYRmX4GzjtqL144kC8WRZamFIEqY5jKtmtStthLYmeHWrPMvNcq6pMzkLfzMcXlNB8fTNqAtQxCE2Bt4xuA50P9Q/7w7h7E1UB0SQhuYmDkXLTUG7VwP0L1DlEgogaz9hkgFXMMqW/+zuWpK7bLPsrpD9M65R6tsqk4bAN2KkFHdgkizq8VgzFAfySU7rrPXZXRc1LnVteZCclh9OaiZ0DiWr2PSHglrpee5i1Y94EfAKdUAji8g2yXvX34TDe1r4FXAqmo2+xO8bKGVUpfMuohh84mx//9PR4uevRF/H1pyKHvds7D71AbNuvdl33Y7HDal4kww9P2VB9RxUYGaXnmSIcBOY7Atm0cULrJCPcjpt9ulXT0vcrRx3Jl3d+TRwGI1odijaLLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

The /memreserve/ entries are memory reservations made by the bootloader
or firmware, their contents are not needed for kernel crash analysis,
so mark them MEMBLOCK_NODUMP to have kdump omit them from the vmcore.

Entries that overlap a dumpable region (such as CMA) are left unmarked,
because the pages of a dumpable region may carry crash-relevant data.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 drivers/of/fdt.c             |  2 ++
 drivers/of/of_private.h      |  1 +
 drivers/of/of_reserved_mem.c | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index a64afc3ded3d..2aa888997e9b 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1286,6 +1286,8 @@ void __init unflatten_device_tree(void)
 	/* Save the statically-placed regions in the reserved_mem array */
 	fdt_scan_reserved_mem_late();
 
+	fdt_mark_memreserve_nodump();
+
 	/* Populate an empty root node when bootloader doesn't provide one */
 	if (!fdt) {
 		fdt = (void *) __dtb_empty_root_begin;
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index 0ae16da066e2..667ce9e46aab 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -187,6 +187,7 @@ static inline struct device_node *__of_get_dma_parent(const struct device_node *
 
 int fdt_scan_reserved_mem(void);
 void __init fdt_scan_reserved_mem_late(void);
+void __init fdt_mark_memreserve_nodump(void);
 
 bool of_fdt_device_is_available(const void *blob, unsigned long node);
 
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index f38d11df6f15..f0683b5d77b3 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -251,6 +251,38 @@ static void __init __rmem_check_for_overlap(void)
 	}
 }
 
+void __init fdt_mark_memreserve_nodump(void)
+{
+	u64 base, size;
+	int n;
+	const void *fdt = initial_boot_params;
+
+	if (!IS_ENABLED(CONFIG_CRASH_DUMP))
+		return;
+
+	if (!fdt)
+		return;
+
+	for (n = 0; ; n++) {
+		int i;
+
+		if (fdt_get_mem_rsv(fdt, n, &base, &size))
+			break;
+		if (!size)
+			break;
+
+		for (i = 0; i < reserved_mem_count; i++) {
+			struct reserved_mem *rmem = &reserved_mem[i];
+
+			if (rmem->dumpable && base < rmem->base + rmem->size &&
+			    rmem->base < base + size)
+				break;
+		}
+		if (i == reserved_mem_count)
+			memblock_mark_nodump(base, size);
+	}
+}
+
 /**
  * fdt_scan_reserved_mem_late() - Scan FDT and initialize remaining reserved
  * memory regions.
-- 
2.43.0


