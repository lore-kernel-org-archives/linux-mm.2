Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FB0B606A332
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 08:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TDvf+CZI
Received: by kanga.kvack.org (Postfix)
	id 60BD66B05BB; Sun,  8 Nov 2026 03:49:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BD246B05BC; Sun,  8 Nov 2026 03:49:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8F76B05BD; Sun,  8 Nov 2026 03:49:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 147DA6B05BB
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:49:25 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9EE5816041E
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:49:24 +0000 (UTC)
X-FDA: 85411327848.06.415663C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id EB50F40003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:49:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TDvf+CZI;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794127763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vGNfBHOfJEaTODk0UVMUPWh2+98FNaAkNc8rBZooR1k=;
	b=iWD8JT5l5y5L8Zzc0s2LBkqOZGZkieobMX+sHAy3BbcuN1yrup4p6qdqEGyEmZ704e97Vc
	plgc/JS97DFOQQOnAgcjOLBz0NVRz14kEvYLYW8iHkdOGGO4ryqR7WM4+nUbq1VZsimkei
	nxSMWSaiWAKzL2WzdhzyGSt/7EV/0qY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TDvf+CZI;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794127763;
	b=K4VFZozgKZb9/lMw1mSioJVO0xTwzdcdAIdCA5afrvKJq18ocsbkNwsyKiCB8Z9Q+xXdXa
	/prxwAgLrV+ST14E2694Qt7VP1Z+ATrtwt9ygV11cwYGpH/TrxAXSHXmlWRvHVrNU0c/gj
	7A/5w/aIj4MsN3tkTJSzu25SlcNiZXI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DFC843B91;
	Sun,  8 Nov 2026 08:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222971F008A1;
	Sun,  8 Nov 2026 08:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794127762;
	bh=vGNfBHOfJEaTODk0UVMUPWh2+98FNaAkNc8rBZooR1k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TDvf+CZIwx7eB9ZyWvpd50vKyoNK51ivIdJam3KpGu4w9aEOJqt30YPL3qj0wK9MH
	 t6bxnEphSPMLZzCBCY5eYKnsjh4kC8gLOGI/63rCnsIEufKQXeEbADEyrT3NxS1ArU
	 +5NPvW7J3fTaVnhivnbq9uhOehuRHcj3TVdZv9D4lY0eIX2QafzffPmjTUw20js9bC
	 LGFTCAO/mN3qJWxne8iLoOg0xdBrJghNr7ZD2NhvnrJ4HuJG5wAgwTR7iVU7ODO2ta
	 Mms/cpMn55diPEThEBQqy08GpQ1P/KMm/lpxaS65wUzXHUcYMJQmtBuNVbXkXLbO1n
	 mEPecjudyA7iw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:49:02 +0200
Subject: [PATCH 5/5] s390/hmcdrv: Replace page allocator calls with
 k[mz]alloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-char-ready-v1-5-3db507722530@kernel.org>
References: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
In-Reply-To: <20261108-s390-char-ready-v1-0-3db507722530@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: zmcedwusac6te3y78eqbno6ymfm99c4e
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EB50F40003
X-HE-Tag: 1794127762-537639
X-HE-Meta: U2FsdGVkX1/wW2RAAuhvIhGZ4ljhu4gnIVpFpbfMrsXw7fParGDO1gHNZAS45BEYNo6zR6rlbfLUGDlt5vrMXwqGbMsjuAR3gCwghcJNvazv/58FTuRwTKcYbRixKaPaQUlTQfQUOtvPuONujyo8T4t+YD4Poo2/n6TT381wlwqvDl9bsl0RK6cux0GWAZPs/4WTYBvXV6z6aH5YLTBbgOvJsZat927mWGhMVoDHAFSUuJIAa1jgs80mNDhlgbVUhR3YGHN+R5yjLDeMoV90bX/t5AN7tSzfvWbl85IY2vy7k73V9Kzz41j1kjMEZwsOPKjtb8MdCC76drHpPBmj1nmUWHFoiH6f9gMDXaWipbIto3RzPoqcFtHRZZB26PSxFcpZece5DhJ7/9bcMmsrxtTI9krKFCx1UAbXBRRCqrcVFB6bETHwxhCpfChjmD5tuBIFxhKL1o3I3HePPFrdiI8QdGtKMYZK4qghdCkK2O48QrCvEKsQVs6WUXpgCsxkCgbv0ZFdb1BE5xddQdo/YAkH5ewd/9TiUGE3iJYsPbrJYrklXsDi97lRWUO6LSp9Bbw0MaLvuyleS5x1fzwVCflzLUgXmbCVDP98banhawpdKsny66TunqZMoDBE2nP/LvofLIebceaVJnh1H3qk8ULmfRYZkRlq5RL6f/BTyZJckyc9zSPyZunaC4Cu/VaOyWpT+7pwHBlKs4BIOBS/BWhueC3SX2kMQ2T+dHlZ+vS7px3jF+RhmCSaNOLE86Yg0QcGoTlzDchA+xmqd3yWlQ5KyZTCfZ2AQn4WjzbI15ueZlMG7QV9iTViWZ9fmAkNwF+o3QSiPZPHGiUcmOm/rjZmmfW8YDYdwlsDUzEAzwQN1fbN4tEeVGxW2rq+vQDDf1IkvZQfzCqyFIJJzAUcw6EEvKPocgPTQj5qCQm+Vov12uXWg85ZvoZ3QteX3MLxsaSGwiQdKNuvrRKnsNG
 XeGb/Lq/
 zzODZny/+bL+AkcgS5a2Q84epO5uEDVWiA6GpNH4gvu0t8dVL8dgHxrpw7JYeyETn0zLcEFVjSRaUzmfBb5ty3f/8R9Tzd9P3IQDX87abJBnihktctsNEQKW9kpbppOGBxArNUPwEtU6xVLxa6xfs1eXu0ZHqrrdaDpnH6jxh5ADHE7tiRtyw4Bn5R9IKAduu/qWMKLH23sxL2+JbMM7Q2e/yVTYTuZ5A44kdA+XEaM7CM29X15V3rtpzM6gNX7cKsgJFzgkGWT6R+04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

diag_ftp_cmd() allocates the DIAGNOSE 0x2C4 parameter list used for HMC
file transfers under z/VM, hmcdrv_ftp_probe() and hmcdrv_ftp_cmd()
allocate the data buffers used for the transfers and
hmcdrv_cache_startup() allocates the buffer that caches the contents of
the last file read from the HMC drive.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() and __get_free_pages() with kzalloc()
and kmalloc() and free_page[s]() with kfree().

Round transfer and cache buffers up to a page for the required 4K
alignment, without rounding to a power-of-two number of pages. Reject
unsupported sizes before rounding.

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/diag_ftp.c     |  5 +++--
 drivers/s390/char/hmcdrv_cache.c | 18 +++++++++---------
 drivers/s390/char/hmcdrv_ftp.c   | 14 +++++++-------
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/char/diag_ftp.c b/drivers/s390/char/diag_ftp.c
index 0a506559799eb..174c65a6e6052 100644
--- a/drivers/s390/char/diag_ftp.c
+++ b/drivers/s390/char/diag_ftp.c
@@ -10,6 +10,7 @@
 #define pr_fmt(fmt) "hmcdrv: " fmt
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/irq.h>
 #include <linux/wait.h>
@@ -152,7 +153,7 @@ ssize_t diag_ftp_cmd(const struct hmcdrv_ftp_cmdspec *ftp, size_t *fsize)
 #endif
 	init_completion(&diag_ftp_rx_complete);
 
-	ldfpl = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	ldfpl = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!ldfpl) {
 		len = -ENOMEM;
 		goto out;
@@ -208,7 +209,7 @@ ssize_t diag_ftp_cmd(const struct hmcdrv_ftp_cmdspec *ftp, size_t *fsize)
 	}
 
 out_free:
-	free_page((unsigned long) ldfpl);
+	kfree(ldfpl);
 out:
 	return len;
 }
diff --git a/drivers/s390/char/hmcdrv_cache.c b/drivers/s390/char/hmcdrv_cache.c
index 85fb689594ca8..4857c543a2ef4 100644
--- a/drivers/s390/char/hmcdrv_cache.c
+++ b/drivers/s390/char/hmcdrv_cache.c
@@ -11,6 +11,7 @@
 
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/slab.h>
 #include <linux/jiffies.h>
 
 #include "hmcdrv_ftp.h"
@@ -42,7 +43,6 @@ struct hmcdrv_cache_entry {
 	size_t len;
 };
 
-static int hmcdrv_cache_order; /* cache allocated page order */
 
 static struct hmcdrv_cache_entry hmcdrv_cache_file = {
 	.fsize = SIZE_MAX,
@@ -214,11 +214,14 @@ ssize_t hmcdrv_cache_cmd(const struct hmcdrv_ftp_cmdspec *ftp,
  */
 int hmcdrv_cache_startup(size_t cachesize)
 {
+	if (cachesize > KMALLOC_MAX_SIZE)
+		return -ENOMEM;
+
 	if (cachesize > 0) { /* perform caching ? */
-		hmcdrv_cache_order = get_order(cachesize);
+		/* the buffer must be 4k aligned, hence round up to page size */
 		hmcdrv_cache_file.content =
-			(void *) __get_free_pages(GFP_KERNEL | GFP_DMA,
-						  hmcdrv_cache_order);
+			kmalloc(round_up(cachesize, PAGE_SIZE),
+				GFP_KERNEL | GFP_DMA);
 
 		if (!hmcdrv_cache_file.content) {
 			pr_err("Allocating the requested cache size of %zu bytes failed\n",
@@ -239,11 +242,8 @@ int hmcdrv_cache_startup(size_t cachesize)
  */
 void hmcdrv_cache_shutdown(void)
 {
-	if (hmcdrv_cache_file.content) {
-		free_pages((unsigned long) hmcdrv_cache_file.content,
-			   hmcdrv_cache_order);
-		hmcdrv_cache_file.content = NULL;
-	}
+	kfree(hmcdrv_cache_file.content);
+	hmcdrv_cache_file.content = NULL;
 
 	hmcdrv_cache_file.id = HMCDRV_FTP_NOOP;
 	hmcdrv_cache_file.fsize = LLONG_MAX;
diff --git a/drivers/s390/char/hmcdrv_ftp.c b/drivers/s390/char/hmcdrv_ftp.c
index 3312b2ac00a9d..e22789b532de2 100644
--- a/drivers/s390/char/hmcdrv_ftp.c
+++ b/drivers/s390/char/hmcdrv_ftp.c
@@ -194,7 +194,7 @@ int hmcdrv_ftp_probe(void)
 		.len = PAGE_SIZE
 	};
 
-	ftp.buf = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	ftp.buf = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 
 	if (!ftp.buf)
 		return -ENOMEM;
@@ -218,7 +218,7 @@ int hmcdrv_ftp_probe(void)
 		break;
 	} /* switch */
 out:
-	free_page((unsigned long) ftp.buf);
+	kfree(ftp.buf);
 	return rc;
 }
 EXPORT_SYMBOL(hmcdrv_ftp_probe);
@@ -238,16 +238,16 @@ EXPORT_SYMBOL(hmcdrv_ftp_probe);
 ssize_t hmcdrv_ftp_cmd(char __kernel *cmd, loff_t offset,
 		       char __user *buf, size_t len)
 {
-	int order;
-
 	struct hmcdrv_ftp_cmdspec ftp = {.len = len, .ofs = offset};
 	ssize_t retlen = hmcdrv_ftp_parse(cmd, &ftp);
 
 	if (retlen)
 		return retlen;
 
-	order = get_order(ftp.len);
-	ftp.buf = (void *) __get_free_pages(GFP_KERNEL | GFP_DMA, order);
+	if (!ftp.len || ftp.len > KMALLOC_MAX_SIZE)
+		return -ENOMEM;
+
+	ftp.buf = kmalloc(round_up(ftp.len, PAGE_SIZE), GFP_KERNEL | GFP_DMA);
 
 	if (!ftp.buf)
 		return -ENOMEM;
@@ -280,7 +280,7 @@ ssize_t hmcdrv_ftp_cmd(char __kernel *cmd, loff_t offset,
 		break;
 	}
 
-	free_pages((unsigned long) ftp.buf, order);
+	kfree(ftp.buf);
 	return retlen;
 }
 

-- 
2.53.0


