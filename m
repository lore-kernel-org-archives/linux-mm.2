Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AD2AC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 07:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 578F86B00A0; Wed,  2 Sep 2026 03:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550926B00A1; Wed,  2 Sep 2026 03:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43F476B00A2; Wed,  2 Sep 2026 03:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1556E6B00A0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:33:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9232840746
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:33:19 +0000 (UTC)
X-FDA: 85168006518.01.AC6A8A7
Received: from mail-pz2-f7.google.com (mail-pz2-f7.google.com [74.125.228.7])
	by imf28.hostedemail.com (Postfix) with ESMTP id C8AA6C0006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:33:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IOx28oqa;
	spf=pass (imf28.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.7 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788334397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTBZpbSvsidLVDHHiShy9f+wnGid6sRS2qRO19KqwKw=;
	b=Ro1kBlYMebobXA+wNaoaEMSuhdVnQ5Ky7uYEMXdOSYdeLqHIzjCyNZrE4tdfk+BWo1uH71
	QNAdMUDtrP+rPiOm2hKFeo4/Wgm0rml9fEGnM2ts7+tAU8sVCSXPhhitPcobX4un/zqAfX
	zvtfgPSs4oL10eyAse51g4rHOZxT9tw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788334397;
	b=NvgRiexcP0GVWqwG9Bz/9bFnOyofpHKaamQ5ps4X2mBs2Zdomn6umpzmyzLbOX1sZFGnKB
	YOlo6o38yVmnDVbTglcKyNJ6S+Y9WELl5edpZmUBipVVAh3JhwQSkWDhnjhBreR464CBve
	yhs2jR1XSOm+BzsJDjBdKQS9oaMAQnk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IOx28oqa;
	spf=pass (imf28.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.7 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f7.google.com with SMTP id 41be03b00d2f7-cc1ddb3ba3eso440132a12.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 00:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788334397; x=1788939197; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fTBZpbSvsidLVDHHiShy9f+wnGid6sRS2qRO19KqwKw=;
        b=IOx28oqaatCcEJ5TyARiWfpvkqH30ZY06a4NHuH1teH72/ZL8Q7EiGQJZO+dtr6mvb
         6fFV8O9bdzTPsLdXsQNDWwiWc/os2uPtFXL48z7RzAc+mR1D6ZMizyjIhyaUm5bGOeof
         H+ftmDqw4Fu88xg8c/qeo0JO8dJCP8bfIssutEowMvZG8Y4QJTPCMuXdKEIE3PF161SQ
         zHok6jG2fO8jLAlEClnEY6npEP+W0awLYlunbVsbRbmEpiC07KNuYwHfA/AfeXjCqzff
         9FwOv3H+iLtIohD8cMJmIG+mOp/6p85Qf7w6L9Pv9PyRQuPGajE3L1HAn8C2aiPxsRr5
         A7YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788334397; x=1788939197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fTBZpbSvsidLVDHHiShy9f+wnGid6sRS2qRO19KqwKw=;
        b=TdOht1Ax9+ADneHKqnlfioSCZFkzhypzwzOh6+OSftdKD+YtRFXl3urnNKk2hLhniu
         1D2/lg9GVserejyCC7uocX0b4pLTwsqpT9WC8ipT6Tn3MzkqK46xTlNdYkGp5HOOJpfL
         UgaurFRJ51lAVqMooSWb+SrMuWkoMs7zWtsE8tXDK3PZhYU1O8byFuiwU7ureujAQ+DG
         Bf5RYubjFrxajwd4CECouc5/DeRHpOrqc349MjXK6O0nCf+TzaNrxgLXXbMLDpye9ySl
         b/Kk8wrXUecM1F/h80vQZS6aMOKWaKhdOwJZc7L61P71RKGsIcdFLPxpfC5ZzROFqika
         flTQ==
X-Forwarded-Encrypted: i=1; AKwUvBzFe04BavXR+LEpKsDzijHMMRDj3wMDwxUe0ivufXHGiBHXju583Q4f9UfiPN1yi4MBJAGmBXjfNA==@kvack.org
X-Gm-Message-State: AFuF++kseLq6uVJ0ZxrG0qUi6o3LDaiDBgG4DazjlP9qEDMlG2TQJ4Br
	MTUCUi4gs9Vjh2UNTPm7h1qMkFDqRLLJI59rJMtXnyrWkzvHRdsHzMKh
X-Gm-Gg: AYBFou3nq2HETVeOL+vppmRSqPHJOUjv6nipXyOA61tynehdhbBeh2Ad5VcyEkIznPr
	03xi2cN0AuPCl4L4z0RCW8/Jz4vIRg/77IZby2X0GcDLSHS15GM5svzVaa2zvg0MAAsi+6lmqc9
	SepRF2iiUbYz7dpAClmj/YqRBRhXdzskQ5DZNzO0pKfxNApNC2HagSgbN2kg6FHa7iINARsmQNa
	R0frn8rcYB42/0Eo/0QPrcqRY/xkP3hanwMc/ob1Rw1jqfwosuW2mQHduLwvAIaIn8PpXfREXPY
	Byb0wHtrHZ4FRLfpVOKEbvEL1xZ3dzNv8H/9PBh+Yj6AagkiAR+wuugP9Xmsa852LJaG0q+6vhO
	h4ZxmjntVfrWZDZOwikcVJcO2GNp4U9sFHiXI28dso77ycmkRO/eIZh83SfB989lWgWm4hgT7br
	znExKrb6a6jKPTnCVkxi7KB9n3hgQ3I6lFSEFY+XrhhktyU2SIQEzNhDjGa9T2xtolxfO8p/3pS
	DVGcqj36FY=
X-Received: by 2002:a05:6a00:4f83:b0:857:72f8:dc99 with SMTP id d2e1a72fcca58-85ed8fd714cmr4354975b3a.26.1788334396619;
        Wed, 02 Sep 2026 00:33:16 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db2adcbedsm926914b3a.20.2026.09.02.00.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 00:33:14 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	chenhuacai@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	robh@kernel.org,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	m.szyprowski@samsung.com
Cc: mark.rutland@arm.com,
	kernel@xen0n.name,
	alex@ghiti.fr,
	hpa@zytor.com,
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
Subject: [PATCH v6 08/10] of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
Date: Wed,  2 Sep 2026 15:31:14 +0800
Message-ID: <20260902073116.802752-9-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902073116.802752-1-chenwandun1@gmail.com>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C8AA6C0006
X-Stat-Signature: nybgurq9yit5g46tbfsai9degk99whge
X-HE-Tag: 1788334397-824153
X-HE-Meta: U2FsdGVkX1+LXX/6L8UFe1Hr80u6Kvp4poqPrYsMvKehEwcYIQQMMNeCrONkKr+wbT9X1NSmUN8tPR2G4AVuXZNJvTt/CzNlz+SEuSQ7vygjQgp6zU0AybD1sf5YCgDXPHVpf5yKNsalAeqQsa+QsFslBQuNWND2Pr2SH5XQBDWDvDvmy8orW937ZPVqrse1JHRxbccLBPFxyZ+McRMF08sZF825UgawLkob/XOqBObcOaXQjzT8PyoE7sqYJLAkfsZg+Qq2R7vt+QvfVzUJrv2Lr41xMMbgPzBGHOVfnqI+OjVIxsNbW/xqO/G5fb3iUAreyYPxRdyRtMl/u4ZIvqi57JFLRk9GfYG3Ej1Nj+tOvc3HMtYSAQXHvtSJKJqpxHJexa1Uajjsj7uy88xSnCNbTFNLlpa9X3wObcXcqhMcQlIrGhfCBIBuTJkWhYSx+tIsqVKFPNeJZPGCEbzsVZQ7vfwVcArl0VxM2f6Gdh/cGpxpHEL/LUXgGtGm8RjZmRtkCsHZFQf/kJWywROs9sduxcfya6RW6JdzJS+MjH0+K2hJhq92/tQGlLnSW6ytXlSapdFPFReO2mMzKtJdXa/fj+e/chnUWfwgKR+OWMndZAYNdMqE9kMVeOXoEx9CZcCNhQqStZweppn/u4wS7nrvA6cyvbzKov+bCvnNFqA+wKJ22KDlU4REW/aa9dXkMT9EyEr4GGo8H8g1vRHZJfFpwoEpkiHLvKC+2X043hMqefs7Al0g2NMCmdKprIcQOyUHKhwBTxBHGKYkWCID349TqEUkbDa/Nabp3uRXf7pasFXdqPG3+P+OdHWzY9dIf+KW3wY0l+08ebDAl2qORHwFCRhCxyflC/7xVV3C8LHfb0G/HrrJIw+92GKvFgNONahYNKJGUGneYeKo5d4R0Gq94H44ZlOUtZPBb+a7AeM6ZkOIeEk0wmuzIojEmQyLrIy4ThOHAseFQt76xWd
 R6mVt+rQ
 qIrZ8b+cISLyIgWm83uWHoYBTjut6YJX1Ie4P6gSl5noipDwfatK8D2ehCF2m7R32duaK9BMfgmp7lXXDkOrBzCUiOOYFiHdKjiK1CymO7NM4n0Ok6nywrLoGA7zxeVx3eP+c0z9XfUjQ0jGo9oVa7Xeewn7lh8jXgrCE7H8znbohoSTVm9OfNTKWTq+4Tlt0RoEVmPBXs0fMr+DN3GpAQJY0vx+xqpUzdaMBinUutX9eibSCwZa9yJcsaVOrj/AnQ86a1uANyDswrL2ssJzPN2HOEROO/PsE7BvyqqJWY3mDjz9vloYaNmtcb3BjwBg2WIoIC4WQVEfIlWyHi9TCgpbTFSMM8aa4DStBQ3+bQJOlJ0zZR8vU/jD7jfq255RxiLyvvF9KhtLixOO3z5GaKnckM72wxBFKla0YPyGyGA9iithF3w98yRxFuIwiV5YYFhXLEcAfKQK3x1bwPLMeLhLDzAFI2mkBgOd+8OnyxMA+z766HfbTjylkygwy5/UDwV5YmxuwynuQS0R7kVmrz1xU9w==
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


