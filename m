Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 643F7CF8863
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 14:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF9676B0024; Thu, 20 Nov 2025 09:42:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD14B6B0031; Thu, 20 Nov 2025 09:42:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0DFD6B0032; Thu, 20 Nov 2025 09:42:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0E46B0024
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:42:26 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66A4E12DAE3
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:42:26 +0000 (UTC)
X-FDA: 84131251092.13.46629B7
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf07.hostedemail.com (Postfix) with ESMTP id A7AD64001B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:42:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=T6DiTPF0;
	spf=pass (imf07.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763649744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VqtJVjFf2VTiEsbahcHSK1+SUTx0HAzBAG6cy3z+p1Y=;
	b=M4Cirdt2JfStI4cM8UPrS+Fx5KHWpQHQtluhHgdFrUHBwzpSTZvMvjPr4lyQzKq5tKhtDj
	qZn9xJ/elZsoq91XBSP1Z/aJrgoENrtDg6g9+PK9mUmKpPMnHTl5ZHVi4RXZ7TfgDPbyRC
	uaRwQxfBBxflQ97FKKMRx4UOeZTpD2o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=T6DiTPF0;
	spf=pass (imf07.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763649744; a=rsa-sha256;
	cv=none;
	b=iTxmPspvvXap5KE30VBsbOpAe2T5lblWFkkvnfgxYvlJfsz7fAsASbF7RubHemiTOVhhdq
	l8Etr53PgmruvPjaADBHHkRddwYFaXtNEJa4R4hGDgK0qvrqLXTE+1BYKnComp18f8VeyP
	aJXzb1bQ6Iojju1+V5SF5NIy/4P7akQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Vq
	tJVjFf2VTiEsbahcHSK1+SUTx0HAzBAG6cy3z+p1Y=; b=T6DiTPF0QphyeJ6ynn
	rpY6XD2TiGV6q27qAf8VLfdX98bhKJJh+KtuE1Hrjnxm4LekyutigidujNaJZWUG
	r84wyEXl/6O4Z5VDNM9CPz8nx5HVZn7NGs0xkQwThGDFvJjgCC4iACP8KbFJO8vA
	U8CfGhL9bNzEy5/5EKKrUSi7E=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wA3yJmuKB9pTEQrBQ--.727S4;
	Thu, 20 Nov 2025 22:41:55 +0800 (CST)
From: ranxiaokai627@163.com
To: catalin.marinas@arm.com,
	akpm@linux-foundation.org,
	graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	changyuanl@google.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH 2/2] liveupdate: Fix boot failure due to kmemleak access to unmapped pages
Date: Thu, 20 Nov 2025 14:41:47 +0000
Message-ID: <20251120144147.90508-3-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251120144147.90508-1-ranxiaokai627@163.com>
References: <20251120144147.90508-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA3yJmuKB9pTEQrBQ--.727S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr48CF43Jw4DKryfuFWktFb_yoW8tr4xpF
	yvkF1DCw4jy34jqFWxZa4v934Fga90kw17AFyj934avr9Fv3s3tws5ZryUtryUXrZ3KF4j
	vFWDK3yruw4UZFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zEs2-UUUUUU=
X-Originating-IP: [117.176.242.6]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbBEBwMTGkfJUZRjQABsE
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A7AD64001B
X-Stat-Signature: h8oi47b4p3kuz3ze7qsjuja3yafuspj7
X-Rspam-User: 
X-HE-Tag: 1763649743-284241
X-HE-Meta: U2FsdGVkX18HFsXxO8zqgyJDCyTJWy7CuB/ZPVHtsuzlIa2K1+YwsBXI6bObYh1d5xOabLZN2Jg1cRbFDSeCMTMqvO3BZpA8TKpEEu7RqMUAJeEE0SbpFYlme8DBLH8Nj+huX8kbaYQg51astML5kgUkEVKK78R0FeBcudLdh8mPgWUv8KMrkNQb6NUkMA7uJ4OnXdJ1a2KHMTUPbfhLoYSH5ckM63MTHujYEYPKcN4BMVfKKZdt4POphixEMOnYu2BX4Gy/z4DyWA+8moe1nfEn+rUaMzhEBdT1u535deJdUhltucbq3qkS0Cvdm1vNO3AN41s7bJ2xWL9rrnX8W5xWcKJFQqPrDlPS97or95Hqmkgk34hui8321dui13mA52plOa5MtxxpAnWHyY6e6MMuxzKDWq2KN0q5gGlwehSPvKnpAsu3HIXMHYTL633RUG/zVyQn7LODSj1CDq6nbAHCRGHsJlbGULSnSJ5M8W/K6sqezXuE1JLFasIHPRZj6UF/IDFOnVUM5NVR1g8ffbeueDM7L5kPvZNEnfFehV59EdsCYMKVeRwL1fAKjd+UdtDICt8QB96FT6fP2yKoCtmeDvBBzaJGOy8xTyI9veGm/bKUKbDFdOWmqvYT7Xpd6/1JLn6ppK6kVqv7DIXJtd0M20gSu4+G3UQ/F7xYh3WqxGtCI97gwdXlrlxyHaMJUjOuM5kbc2QPiPlOAPymOKrWhw5mXsaKh0f2kKqyVpT9jZ4q0BDlwmiN5zkftm+MqBS2D5MBBm/v9eN3xB8PgauV82aNhXssqco8LrmUz/hozWQFoTTf2n+veVN8A2GKY9Ho0dTjADtLLWtKzCrCUtyCmSgCuAN9QRJKm3r3ycyHj1oMcdxjZxmsbzKlmiPFbN4LFl1CD3Q7Y9DOMAoNdDIE+amNqQZx4hLiTycfOIYPQiOkrc0GggKeXRNZbI+2yct/jbOVY9djob81Ei9
 dAwszdZv
 oNRG3ON6oT4zePgOnOKrkHVlpvFJ/8pezwk2ksk5YTLfUOFRK+gtUnxWwegppvAvaY/IP9UI28DUsZzSOVX7brv8C4G8UaZ15giRKvyTYUBaQ8p5FJNN2hPC6xzyIAbvUbHT+4BrXmpzeVkGmad4Zu1hkJrRjghajd08XssEvXQDFjXEiC6LFtaqmMV9/9xIngpbOuxJql0u47R6wqIwJeuC9XUgUMn/iPhSMtF8oSt0lSFan/nQqt8GSliy4tDrbHdeTTA4wC7XndgzhaCL5MSezda+afrFm0AdUA19yURTKVTRK3GMYfzsuAUigkkhLzrO3WuHUXBSomFAp8EFllug1ryqiBnAE4bVjzKaq/M3t7EDEZnsQZ9yG5M6Vqyp/1WgKXhHn4g9igs4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

When booting with debug_pagealloc=on while having:
CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=n
the system fails to boot due to page faults during kmemleak scanning.

This occurs because:
With debug_pagealloc enabled, __free_pages() invokes
debug_pagealloc_unmap_pages(), clearing the _PAGE_PRESENT bit for
freed pages in the direct mapping.
Commit 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
releases the KHO scratch region via init_cma_reserved_pageblock(),
unmapping its physical pages. Subsequent kmemleak scanning accesses
these unmapped pages, triggering fatal page faults.

Call kmemleak_no_scan_phys() from kho_reserve_scratch() to
exclude the reserved region from scanning before
it is released to the buddy allocator.

Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 kernel/liveupdate/kexec_handover.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 224bdf5becb6..dd4942d1d76c 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -11,6 +11,7 @@
 
 #include <linux/cleanup.h>
 #include <linux/cma.h>
+#include <linux/kmemleak.h>
 #include <linux/count_zeros.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
@@ -654,6 +655,7 @@ static void __init kho_reserve_scratch(void)
 	if (!addr)
 		goto err_free_scratch_desc;
 
+	kmemleak_no_scan_phys(addr);
 	kho_scratch[i].addr = addr;
 	kho_scratch[i].size = size;
 	i++;
@@ -664,6 +666,7 @@ static void __init kho_reserve_scratch(void)
 	if (!addr)
 		goto err_free_scratch_areas;
 
+	kmemleak_no_scan_phys(addr);
 	kho_scratch[i].addr = addr;
 	kho_scratch[i].size = size;
 	i++;
@@ -676,6 +679,7 @@ static void __init kho_reserve_scratch(void)
 		if (!addr)
 			goto err_free_scratch_areas;
 
+		kmemleak_no_scan_phys(addr);
 		kho_scratch[i].addr = addr;
 		kho_scratch[i].size = size;
 		i++;
-- 
2.25.1



