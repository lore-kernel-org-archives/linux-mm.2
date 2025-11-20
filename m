Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32869CF8863
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 14:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 913186B0031; Thu, 20 Nov 2025 09:42:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EABD6B0032; Thu, 20 Nov 2025 09:42:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800D96B0062; Thu, 20 Nov 2025 09:42:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70F5D6B0031
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:42:29 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15C1112D97F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:42:29 +0000 (UTC)
X-FDA: 84131251218.25.1548877
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf13.hostedemail.com (Postfix) with ESMTP id 863E620006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:42:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=YFhlBDO+;
	spf=pass (imf13.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763649747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C21VWiTFnCtjKUC3lRTNib5t5KU/n8R+0YWZGg6WN4c=;
	b=trP2mDPq8aDWt/ggQqx06kYBERDam7614de8WFVdPmpOVyRee8A1wT2UWd9/qNTrpYqeK7
	oCcRWEGvALi4s9x0TkMMxMpRtCAdusXPjD6EGQUxpS37aWzRGdUDpJd4pF5JdnmPIzNGGJ
	zlNS8D3iiSZA9haddCSGTdjf3U2IpDM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763649747; a=rsa-sha256;
	cv=none;
	b=BXOatviki3EbMoa6En/lt1H4e7LIbfbzs644ZOO0TgMRbfyvcYNGQp+vOwNhe5qE43QYYm
	XRLrqtxJEpHDmiu2vtwOVhzCxu9eJI9+bqmWTbf8gBrTaq5b1PexyChYoRxzHAuoVU+hSf
	XC9K6GijoFXKQ2K2x2L0E34k1ffb4mY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=YFhlBDO+;
	spf=pass (imf13.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=C2
	1VWiTFnCtjKUC3lRTNib5t5KU/n8R+0YWZGg6WN4c=; b=YFhlBDO+wGNN1bMmpY
	2qb/OX6/Mho6hh50nJn0j4E+Yf5o2M/RCV8iDnbqUEQ4ys/Lc1AuUDKfwYQN792v
	zBkZRsZD938tJhpCzPqFBrylDLRy1XFGCUfoAqHFb1ywCa93l1kzzgzonMTKKQfO
	y/yg9YsUNLwblZTUiUr/Q2TUo=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wA3yJmuKB9pTEQrBQ--.727S3;
	Thu, 20 Nov 2025 22:41:53 +0800 (CST)
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
Subject: [PATCH 1/2] mm: kmemleak: introduce kmemleak_no_scan_phys() helper
Date: Thu, 20 Nov 2025 14:41:46 +0000
Message-ID: <20251120144147.90508-2-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251120144147.90508-1-ranxiaokai627@163.com>
References: <20251120144147.90508-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA3yJmuKB9pTEQrBQ--.727S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxZry8XF4rKrW5Wry7tF43Wrg_yoW5Zr47pF
	Z7Cry7GFW7Xa4Uua9Fva48Zw4DJws7GF1aya42kwnxZF90vFn7Aw4fCrZFyFy5Jr97Gr4Y
	vrWxtFZ0kr48J3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piXyCPUUUUU=
X-Originating-IP: [117.176.242.6]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbBEAcMTGkfJUZRigAAsZ
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 863E620006
X-Stat-Signature: akzda5z1hcqqe7f1d45xsyru7tfgzkpb
X-HE-Tag: 1763649745-453961
X-HE-Meta: U2FsdGVkX1+/pD+ARsdKe5Zs+Oxisoxx/2S2p8sDSOCYs/p9WlLUr9NX/AqJQLvHdE5dho+594UxB0RWmfu+amXOf0+0QpNWbRi+Au2vcr1vIMCpkJ6DO5LT1V85REYxGOfd+JBvaGpxUKv9EuxjnH1MrhRCQrCF2+RzVRPLeja11QIpx0JlD62Ibtoxfs+ACNn4m8lP5iazvJMZ+W0X2TmXb64D8WF51FExAt959xrW5UGhLDDqALxzG5+NsjxHAt9pce+YrhEi0ExdXSWNoVcuuvfd+SPD5SEVpwNvLanP1EYZlLw6WoSrWzSQa/6M9e0uwI54KycAds4PaIqWDO55JDXcxN2aZfTvCrucq0BK/aVxiaGTGAB91jzBDRVgGhVdrzuSpZ5gjMcm27kGPT6/D85N0x+zEgWTKOEoViUIKAulohezaRaTYP9vqsLCAw5UXsK5wt8+gmpeMyB/A1eHYy+Ea6qQoikvkrf57Uy+r4BKdKHvdNfw+3nRZ+lgfMOXC/6steuOIAm/CUilO4NXREATnCAN3iPPk0+X2KY+GH/9851sOeSXxr1Xj00VNPqsYP7KO+0uvjlswjDChcQ0WE4ga6sTcm/H5o8AQbx019LBvA2RWRXjWD37NaWmLO5M3zxk4pzGywhkEf1PnrD55yFiuqXdgpjNFE5lhH/fbsSmG70LfIwzcKjBaOTU2Yg0ZsVgGuk6TgAUh8u3gGPNVxHD+FENTIQF72957WSmKndiiegFOTHyxckaMUuvUopEZoyiBWpHyXuCRLV14V3Gw57Fi1b3Xh276ove5EbUfRft/hlFAqiPNQgPu6vL1RT3v///yS1tIKPVTITL0BR6uesc9naDAQ1RT8RUpWmDG/fXtzrPAXDc3h1KUSPu8EerjMCywzVAX1qU7zUB8rECCCgtmzxIUrDqsNcvAe3r+tEkGkkkYPMoNHvm2Gu3SHrokCAfJxi4IigIE/r
 yk6F98cS
 ZW0meMSoLarpmrJ+6iGIjiNtW+kbqPVTsd/Y/r7bJGUXB7wdpyc7ae3YgBytAfUn7VWDv/n0tUQbu96Mun7025EI2y+4OelhmvzY5zKDJFr255zt9wGTiAzbtapU/hv6KCYDsTWTAJlOnMHyXHhwxv5DHXixgWXt3x69AeqAJdIwBL0urldGr3vTtjW22lJI62trCwmTOuaDnhCgjVnmlLwGAFOySiup/Oj92YdnYZlT2iImd4Jr65DdeW0RoB9PKPmpkcL0P3ZAJn1E6xs8qE9c1v+w3lOp2jFSSJRr88EtQvy5MvcmApR4nKH+EFqihyo2kUFyQprj57Nv8F8CN4gYpZbJXeDgfHdxxoXH+56kYfo6wdJD6pb/qerFAHhTERTgbSGkJdsL/K5HXdyQsBCMtQNhbpiDE3LOA03ylXiQ5qSahmYx7OU00ZWPD87bdqwjJ0J7F/a6LMLGD70dvbh+H7rUQsF3tQ8VU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Introduce kmemleak_no_scan_phys(phys_addr_t), a physical-address
variant to kmemleak_no_scan(). This helper marks memory regions
as non-scanable using physical addresses directly.

It is specifically designed to prevent kmemleak from accessing pages
that have been unmapped by debug_pagealloc after being freed to
the buddy allocator. The kexec handover (KHO) subsystem will call
this helper to exclude the kho_scratch reservation region from scanning,
thereby avoiding fatal page faults during boot when debug_pagealloc=on.

Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 include/linux/kmemleak.h |  4 ++++
 mm/kmemleak.c            | 15 ++++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/kmemleak.h b/include/linux/kmemleak.h
index fbd424b2abb1..e955ad441b8a 100644
--- a/include/linux/kmemleak.h
+++ b/include/linux/kmemleak.h
@@ -31,6 +31,7 @@ extern void kmemleak_ignore(const void *ptr) __ref;
 extern void kmemleak_ignore_percpu(const void __percpu *ptr) __ref;
 extern void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp) __ref;
 extern void kmemleak_no_scan(const void *ptr) __ref;
+extern void kmemleak_no_scan_phys(phys_addr_t phys) __ref;
 extern void kmemleak_alloc_phys(phys_addr_t phys, size_t size,
 				gfp_t gfp) __ref;
 extern void kmemleak_free_part_phys(phys_addr_t phys, size_t size) __ref;
@@ -113,6 +114,9 @@ static inline void kmemleak_erase(void **ptr)
 static inline void kmemleak_no_scan(const void *ptr)
 {
 }
+static inline void kmemleak_no_scan_phys(phys_addr_t phys)
+{
+}
 static inline void kmemleak_alloc_phys(phys_addr_t phys, size_t size,
 				       gfp_t gfp)
 {
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 1ac56ceb29b6..b2b8374e19c3 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1058,12 +1058,12 @@ static void object_set_excess_ref(unsigned long ptr, unsigned long excess_ref)
  * pointer. Such object will not be scanned by kmemleak but references to it
  * are searched.
  */
-static void object_no_scan(unsigned long ptr)
+static void object_no_scan_flags(unsigned long ptr, unsigned long objflags)
 {
 	unsigned long flags;
 	struct kmemleak_object *object;
 
-	object = find_and_get_object(ptr, 0);
+	object = __find_and_get_object(ptr, 0, objflags);
 	if (!object) {
 		kmemleak_warn("Not scanning unknown object at 0x%08lx\n", ptr);
 		return;
@@ -1328,10 +1328,19 @@ void __ref kmemleak_no_scan(const void *ptr)
 	pr_debug("%s(0x%px)\n", __func__, ptr);
 
 	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
-		object_no_scan((unsigned long)ptr);
+		object_no_scan_flags((unsigned long)ptr, 0);
 }
 EXPORT_SYMBOL(kmemleak_no_scan);
 
+void __ref kmemleak_no_scan_phys(phys_addr_t phys)
+{
+	pr_debug("%s(%pap)\n", __func__, &phys);
+
+	if (kmemleak_enabled)
+		object_no_scan_flags((unsigned long)phys, OBJECT_PHYS);
+}
+EXPORT_SYMBOL(kmemleak_no_scan_phys);
+
 /**
  * kmemleak_alloc_phys - similar to kmemleak_alloc but taking a physical
  *			 address argument
-- 
2.25.1



