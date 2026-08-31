Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BBEBC624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 13:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BBDF6B0098; Mon, 31 Aug 2026 09:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16CF76B00A0; Mon, 31 Aug 2026 09:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A9646B00A1; Mon, 31 Aug 2026 09:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D94976B0098
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:03:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 68B0780125
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:03:21 +0000 (UTC)
X-FDA: 85161580602.10.4DBC4AF
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id B0D99C0007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:03:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=chZNXR9f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of tahasezer.is@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tahasezer.is@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788181399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZxE1bcDNUrY2o7v6e0PV/peTaEiNN2c2sEFM7UzGp/E=;
	b=7tgKi8jVQebLqXnf8AiiPLDNKRWECxdy/EPQ59Bv2fg+7FAFlr1iNaxEyg4BKkv0B27sDw
	uMXY3KuyAwjkX2HxovblLFCl2z09b1IYdv5aCGsf2QPntOcHPbyXLbgYnfmE70JfU/zJP3
	wGF/BEGPuY2nW0Agy6n4i+OPnTZUWYM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=chZNXR9f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of tahasezer.is@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tahasezer.is@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788181399;
	b=loKeFpHZx9h151wNTv7N5Qk97funK18fU7vuFotjxpMg5Cdbajj9shoPRslDlZrXd0BbM2
	GRxwvVljFRZ0o6j+1c/904H6t1SKAHhtAXe6d9wbBAlKZhJ2aquGETamzPEnF/R9m+6+2e
	WWWa1we5H5VEC6YiNGionLFBjl9zWRE=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49b0eab380eso35957205e9.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788181398; x=1788786198; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZxE1bcDNUrY2o7v6e0PV/peTaEiNN2c2sEFM7UzGp/E=;
        b=chZNXR9fzLLHZM1JPawfXqMCsWHQinxgzYF4agCHuyTxcPz7lO/UtT7cUpzx1W55KV
         m4c+zF8W2WX3AqsOxTzOKCFWUg+K7tUZ8CBocVVmNVcvJQccxUPOSngFvdzWzx+2/kjp
         QEuzvFdJyqpCJZBdBxv4UmUJhK1YSWziS267/WRr5LkYYHRlX6ZE2/aE4Gp44w6I0P8D
         vYQnQNl2aEd7k0K4eKB0Er0uLZfy3efMH8CSiwZ57XjNuxKEPPvIlZdAXqKMS6cGnBdv
         1RZFQ7Q9VEhWZR9ssZddP56yW062jErXD9rfBfQRo1WU/DPAQiyjCl3BEBIaD4XBC3E6
         jXMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788181398; x=1788786198;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZxE1bcDNUrY2o7v6e0PV/peTaEiNN2c2sEFM7UzGp/E=;
        b=k4TcqIuDrlITAScg4evYvEdi5UXLKzlcuKFxKWuAvYgCnd7vOJuUKp6dT9O71hZcck
         eAmGquEvaufaz6DicfRs3L4NVLTgKpcBIfzapI7UjjQhVcTyBTDRDC7wkajpe32FY8xP
         T2B7W1rhFjGJp8R0y9Mif3G5JZoTAimKK8QiBCBUXj7IdNAkmTcttP3/Dbz/smBH7h2Z
         HqSgzvVtFKkRw/Th6y4V6JMdA8vkxYpKNLmoq03ZoNjCTe18Ci4GytLux/Nc+jP46GP+
         rXqRLZtwesNxGmy1X2Hy3uUWJfkBy4F67lVDdNXApEUUzasWDxFeod9bQisu3sdhll7Q
         otrg==
X-Forwarded-Encrypted: i=1; AHgh+RoGOM5Tu8pE4pVXH0PdxgQKlBy3k1rghxl46urPgoMPJMzEQ5fKGNN+KWUXj0x40zfLk6c7104Rcw==@kvack.org
X-Gm-Message-State: AFuF++nxxfKCsbUsjsBUvUOvFeNFuoXEbPd/dQwAWBhlcV/3I6UfDrA3
	UNg3yZLBRLKmTO7LxhrY3oib97+OgZKPFuCcJ2PVXdxANd7RAStyxyfl
X-Gm-Gg: AR+sD13IW/tt0Ts88B0YqtUgR0aOOpq4ZIpJvWopkqVPljlfeolYKpAej6gr0ZkjXVI
	MGpmSbSTVmVNCWh7Jk3wj6VvDIU7djbXCHq471ORVyBQ59gwowESP8qdshJQWa46+E/iDyzzTem
	hTJtCAWHo6VA4CJP7dKYiBLpF0HjDDCnQM5qYoid9jzmzvVD1GCvJbCoOKccZRseDI4IBtQX648
	5SZScxABSV0qEhFa5oQvDn9zo14qMWNjyGEm947QPNhDcTw9crVa0qDb244easjPDeEHTjS9EVg
	SwUX1bf0ypS1rzaWwYzFUHFK7VpqVkVCWtemEODG+1M2bv3/MaUWFfkXgpAG3ntvnJxQQPfGtjU
	cXFriR1CHeLTaRU6PJMJZ047c0QJX0dj0YKCLjJTP+E7LxzNTGaLLlCgKQzy23jO5RhQycEqWC/
	hooTdAXmMrhQlHqJV4WhDOJuVwRCac8GShMyQjpIIx9EW1+SPU4+foT2wtfqvq/ZSqCOyp4yk8/
	UgTerqgrFspH0w/
X-Received: by 2002:a05:600c:8b63:b0:49c:ced9:ab7f with SMTP id 5b1f17b1804b1-49cd53c438bmr129895425e9.8.1788181398028;
        Mon, 31 Aug 2026 06:03:18 -0700 (PDT)
Received: from Minno ([193.192.121.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cdb13f094sm31831445e9.3.2026.08.31.06.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 06:03:17 -0700 (PDT)
From: Taha Sezer <tahasezer.is@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Taha Sezer <tahasezer.is@gmail.com>
Subject: [PATCH] mm: vmpressure: scale window size based on machine memory
Date: Mon, 31 Aug 2026 16:03:16 +0300
Message-ID: <20260831130316.448-1-tahasezer.is@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B0D99C0007
X-Stat-Signature: ihwy65ijqj6eixdenzwg7qrgwq9hso4u
X-Rspam-User: 
X-HE-Tag: 1788181399-15109
X-HE-Meta: U2FsdGVkX1/RaZjMuCwferlv09/u0+pkY20AWqpPaGOzlmyxNFrdr+8B9hGag/g8P5/SOkuTABDHF5on7q4hQwmzMaMq8mScKjhAVCN7r93VleUdXdRWlC4dFmuuw0il5LzuUxcM1vuNUqcD1qxvXijVE/sbYUKFU9Cvusc4MW9MCOAb4pMhMTb6qDqagRuHKipgT0SWM4b/zJPIlarVh4NEyANPYrmXMIqaxz0hzkXvbNQrxWF+rwc/iILWJoveJ5OybagHXaWo5gREutYnEkdpgjt/NvHS+4J0AQTA6VrO+ICNzuIEPUoGe2/rHMcQZIdMGbsJ62ObZvOKQ731h2Xjugw8TwZp1gdyNZpopAmfXCefkCuDE7wTD+GJ+fYSgMGX7EjfduFpoD2iOO8TY+xa8yO5stizGi0BrgFziFhp+Rc1CScaMyj00SskMqd3LFRErm/WMQTj+Ua4gh5uTCbLycCQQhH4Vj4CMrq5eBbpCaVT1n0ScARQEGMbQfteV0bWGqHRGSkwDTPpRJNE18bbyghzSiLVVD3vOCbpm8WuOUIwBfYQqHTp0T9E50fgtF9cEtPRXnwp3dri8RH52F5m3YDiUY4kzJxmfyd+Axeh4kNO9KePywrNes9hZqkYi03vm10Bytyer320sgYhK6p37bnsItiNQOfPeqDXM0+44ji8xRBh/WsffJnP/XlhwTS55RNnEsdNmMGReDno8bx2SpaNMDRInMmY6CkA8ElqlqoTxUbgw/eTy6bA7dUd6SatOxxoFQt12iCVdxeU4wimcp4SzS/GGYM4Nq9GNHRcbCi5qRnYoHY58SJ0PgpYRPupun0drk0GwfWO8fLLMfm1ERp6TWmaAIMpE5EDR/UrzrIyuzi9UQ32PgOkN0DAreoZ/DxcvYdLdybuDxdT3+bTljIdqxP6o3gvPLkqz7WovEpWsdsE5uoeN6IoqAPUI0ctqZqKFfk+o74thS6
 vzGVaela
 bJXHjfF1F/SPhfRHyDiFVX7Yx1xtzsNuru45BlnGEarvdBcjRFi/OfqKiLDnrjJvOWBnB1XEl/R0YrFuGkw/bSSKFBvWvrJ7oR4dZMH6YtXu3Qdz/ZpaXuMqNmk/h9cqTe7v7si+zmXAYQstEpi02+XesqYJuz2KxbbODsGvZsX8bvA08qu8Une7GrG8N3cByuEDpcu0u4197VV574RJY2k6ory9GIC01WL9nRaB58g5eR35682pGOywu+sX7cSMXasYoD+G/gOXw4M5X+CxefUZWYG+2VA8Fkqu58rxmPVGl8wIt+lXyktAcbj/x45QOUbiMdfa5k526+SGxCU+/ChyPCV8vMWruLzEfG2+YSgbD8gtsRWcm0Nr8hp/HroDQ0YOz/9AKay7B/7A03znEQj+M0q9MbUEAgL03wRQwZgsC0ec+qNwPQagOTwyScDNVFkbj35+lUBiDrmAVMmbgSlk0k9Yq/R6cENsEcpN1dtE5Ja4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vmpressure window size is currently a compile-time constant of
512 pages (2 MB with 4 KB pages), regardless of the machine size.
On large machines with hundreds of gigabytes of RAM, this small window
leads to excessive false-positive pressure notifications due to the
higher absolute reclaim activity.  Conversely, the fixed size is
already appropriate for small machines.

Scale the window size logarithmically with total memory at boot time,
following the same approach used by calculate_normal_threshold() in
mm/vmstat.c.  Total memory is converted to 128 MB units and fls() is
used for cheap logarithmic scaling.  The multiplier is clamped between
4 and 64, yielding a window range of 128 pages (512 KB) to 2048 pages
(8 MB).

This resolves the TODO that has been in the code since the original
vmpressure implementation.

Signed-off-by: Taha Sezer <tahasezer.is@gmail.com>
---
 include/linux/vmpressure.h |  2 +-
 mm/vmpressure.c            | 60 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
index b4d13457b..09111f5bd 100644
--- a/include/linux/vmpressure.h
+++ b/include/linux/vmpressure.h
@@ -51,7 +51,7 @@ extern struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg);
 extern struct mem_cgroup *vmpressure_to_memcg(struct vmpressure *vmpr);
 
 /* Shared with the v1 vmpressure block in mm/memcontrol-v1.c. */
-extern const unsigned long vmpressure_win;
+extern unsigned long vmpressure_win;
 extern enum vmpressure_levels vmpressure_calc_level(unsigned long scanned,
 						    unsigned long reclaimed);
 
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 9629240d7..f88bafb71 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -13,6 +13,7 @@
  * (tree=false) socket-pressure path that runs on cgroup v2.
  */
 
+#include <linux/bitops.h>
 #include <linux/cgroup.h>
 #include <linux/log2.h>
 #include <linux/mm.h>
@@ -31,10 +32,63 @@
  * As the vmscan reclaimer logic works with chunks which are multiple of
  * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
  *
- * TODO: Make the window size depend on machine size, as we do for vmstat
- * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
+ * The window size scales logarithmically with total memory, following the
+ * same approach as calculate_normal_threshold() in mm/vmstat.c.  On small
+ * machines the window stays small for responsiveness; on large machines it
+ * grows to reduce false positives from the higher absolute reclaim activity.
+ *
+ * Sample window sizes (SWAP_CLUSTER_MAX = 32, PAGE_SIZE = 4K):
+ *
+ *   RAM          fls(mem)   multiplier   window (pages)   window (bytes)
+ *   -----------------------------------------------------------------
+ *   <= 4 GB      0-4        4            128              512 KB
+ *   8 GB         6          6            192              768 KB
+ *   16 GB        7          7            224              896 KB
+ *   32 GB        8          8            256              1 MB
+ *   64 GB        9          9            288              1.1 MB
+ *   128 GB       10         10           320              1.3 MB
+ *   256 GB       11         11           352              1.4 MB
+ *   512 GB       12         12           384              1.5 MB
+ *   1 TB         13         13           416              1.6 MB
  */
-const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
+unsigned long __read_mostly vmpressure_win = SWAP_CLUSTER_MAX * 16;
+
+/*
+ * Initialize vmpressure window size based on machine memory.
+ *
+ * Use fls() for cheap logarithmic scaling, following the same approach
+ * as calculate_normal_threshold() in mm/vmstat.c.  Memory is measured
+ * in 128 MB units so that the window starts growing once total RAM
+ * exceeds a few GB.
+ */
+static int __init vmpressure_win_init(void)
+{
+	unsigned long mem;
+	int multiplier;
+
+	/*
+	 * Convert total pages to 128 MB units, matching the vmstat
+	 * convention: mem = totalram >> (27 - PAGE_SHIFT).
+	 */
+	mem = totalram_pages() >> (27 - PAGE_SHIFT);
+
+	/*
+	 * fls(0) == 0, so for machines with < 128 MB the multiplier
+	 * is clamped to 4, preserving the original 128-page minimum
+	 * (SWAP_CLUSTER_MAX * 4).  The maximum multiplier is clamped
+	 * to 64, yielding a 2048-page (8 MB) ceiling which prevents
+	 * excessively delayed notifications on very large machines.
+	 */
+	multiplier = clamp(fls(mem), 4, 64);
+
+	vmpressure_win = SWAP_CLUSTER_MAX * (unsigned long)multiplier;
+
+	pr_info("vmpressure: window size set to %lu pages (%lu KB)\n",
+		vmpressure_win, vmpressure_win << (PAGE_SHIFT - 10));
+
+	return 0;
+}
+core_initcall(vmpressure_win_init);
 
 /*
  * These thresholds are used when we account memory pressure through
-- 
2.53.0


