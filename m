Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58684C982D2
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 06:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63FCE6B0096; Thu, 17 Sep 2026 02:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C9816B0098; Thu, 17 Sep 2026 02:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E08A6B0099; Thu, 17 Sep 2026 02:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 268726B0096
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:07:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF1DAA0262
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:07:21 +0000 (UTC)
X-FDA: 85222221882.21.24617A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id F08F240006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:07:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nGkDGwFp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nGkDGwFp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789625240;
	b=qBWYNfnuLdNM6nGm8VgZKaBzXeS9SueMuCqLI5hha59LjBMaibKx+L+z0wNDqnufUvyyGb
	dstnlTxrbo1eeMaK6bw+dqSUO8+gqYmJRaOp+tGBz4/sijZwZ/UcWX7Tyy5ciLIbK4bvrK
	CEDHPcdU7U7gYlTHUoW1QNa+/q1FYbQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789625240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zcr/x42AyuJbteFIUSbRt7NE7r8kK6f6hxYF0x24ATg=;
	b=F6zgjwN1JgPwYTHu2OfMoGvKHwYsnNON0ns5EqA1x96aIKfLMzXLfCn6EyKSuiw+znysQd
	uBs9NdCD904w3bxCTPtljA0bVtDWhWv1Nshe/2Ltwd2wQluWvbsbkTN/DjTGniIjpRO7sX
	7w7aJKpf15Dfvj5gRWhE8I/qKdzQGMw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33E4B43C76;
	Thu, 17 Sep 2026 06:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2A11F00893;
	Thu, 17 Sep 2026 06:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789625239;
	bh=zcr/x42AyuJbteFIUSbRt7NE7r8kK6f6hxYF0x24ATg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nGkDGwFpngi6i5G2ESc773MyIgCDZDhHc8VdmeusjALxErnfk/HYMvpC4YJcpnCnJ
	 BvhzztHEQPU2KaYO/gyP8+aKDbtdLRirkdvtMfc7T+F2azgjrIpViZFT49rEMgx5rr
	 rj5zEXorrYHf5tsggawCqA0c2Evgh2FdbMHCFWgEkUBkYTDmVNA//eLE/K7oUFZjVS
	 6H9QDoW8Slt3E10VijhMx49EPNKhHFVV/fvd6pclAVsANt4m1MKgNaLdOuEwOHsPYC
	 QGKa0A+ms7hPUP3jjqDvog3mB/pPa8EwEiH3t7gZ1011IJSdQtvvFJh8ov3Ejfq2Bv
	 uqmzCqSuWP/xg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 17 Sep 2026 09:07:03 +0300
Subject: [PATCH 1/5] hibernation: make swsusp_page helpers static
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-hibernation-v1-1-7f7dfae3dbe0@kernel.org>
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
In-Reply-To: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Potapenko <glider@google.com>, 
 David Hildenbrand <david@kernel.org>, Marco Elver <elver@google.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: F08F240006
X-Stat-Signature: 3jbeynu83ydqfwto79stfhkbona1s9fm
X-Rspamd-Server: rspam01
X-HE-Tag: 1789625239-208081
X-HE-Meta: U2FsdGVkX1/OobscaIB+Uvp7kyA+pG81v1SpFWQ56OpFxyXfnda8RW5GJi95WQXZh3rgbeD5Q5FJ8wrMpJYMyCAWSzDhYBPF90sVKfCnlVVRtxfRZa9YA14T/h7GtaFTRNTL7zHmCpcTbOntLgCfPCaLXyqMEhDTzpkdmmz8S1KedfDL0h7ANtolZ25fEhc68hMHWFB74RDabi2CjSZukymzwwrt0Vgimx/1YGSflryh+HeJiXbLvxsLmNBAeJ91MTGSrLd/zxrBukCFUWWrPivJoCZHnrQMlYjGxTWmsJVJ1s5u/Z1WxY1z4q0oiCcRVCWEBhZyXCZqVwAQ/EwNXHJBk/DDYPngB40QVXmOIGHTS+l5pU6AIygBYHpWMBG/big1i/J2Ak0BppP+uQjtr3omfKawkw8X2Nkd8RAir/2ykWzHDnvN8Rxm+Ieg/mpemYRSML77is5f9QzHsh0BQBKra1wokqJRVCPHR1vx0OnNMJ3P075djLRmegMXdDm9R4QlZzdRytvROgqTlR0pe/AC1XNZNdUkxk8v6uVWTjhigz2bJvcHdVpvjLCEIZcwoA74kNJBaf0/Sc5vbhfGo0Qw8UmkqJ0C279UUBv6Evymb43lI9h/HUFYWcBCAI4O+0PaSB1oLiwTuH+ZUcVU6zei+wUW9x++3k2qklNL0mVWALGKZljh4FB71i0yNKAoa/wKudYsTTpmoAm9FmY7reXBXeAaan0V+DTPm1zFkNR3prsADjwQcDIU5iW5l0qYqe8buVk5q98/IdQ7Juko5yVy+J1zguoZssKY7Lq+Pe/av0p5QHPWgrpPvHpkPpnMxndyQWUdk3oSPPi8Ea6j2xHe60faBEQoccCEyccrH7NlnatzdI/QiOnmijlWFsks+AyiyktxprUIPEkL3UlRusKYIwHnq9l5GWgYT4f3q/Wl+RFNUCXDpSIMSoX0NYX/zliZY6canXvK4Am5fgI
 ChcuAQqm
 a4XUcTOCTZu55M+7+9MiXKwA3cDT9d35mKxTKzq21hQm3pQ5bH3m0OEo42159FAs+95ZdYtdAM2conuDBIArF0/D2KMUphV1keXayuLJZFzuLzQbKtzxRQ6NXS2L/srq2cXllfzlIwpiyktiJfjXZAXck9IOq0mvdETS11Q6MSG6DkeAlRWmZp5q+EHv7inpMJPVU3V0L/KsSjc0vpuqZvFYCpV4n6j0rSmpy9kUi95tBa24kpVrzGh4RgCRVXpThDvHjan+BATGCBqZEMOHCX98DQuyYHFjj8irZ/fLkrIiZ+no=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 31a1b9d7fe768 ("mm: page_alloc: move mark_free_page() into
snapshot.c") several helpers that set, clear and query free and forbidden
page status are only used inside kernel/power/snapshot.c

Make them static and add necessary forward declarations near the existing
declarations of similar helpers.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/suspend.h |  6 ------
 kernel/power/snapshot.c | 15 +++++++++------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index b02876f1ae38a..b3435c5ef63f7 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -381,9 +381,6 @@ struct platform_hibernation_ops {
 #ifdef CONFIG_HIBERNATION
 /* kernel/power/snapshot.c */
 extern void register_nosave_region(unsigned long b, unsigned long e);
-extern int swsusp_page_is_forbidden(struct page *);
-extern void swsusp_set_page_free(struct page *);
-extern void swsusp_unset_page_free(struct page *);
 extern unsigned long get_safe_page(gfp_t gfp_mask);
 extern asmlinkage int swsusp_arch_suspend(void);
 extern asmlinkage int swsusp_arch_resume(void);
@@ -404,9 +401,6 @@ int arch_hibernation_header_restore(void *addr);
 
 #else /* CONFIG_HIBERNATION */
 static inline void register_nosave_region(unsigned long b, unsigned long e) {}
-static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
-static inline void swsusp_set_page_free(struct page *p) {}
-static inline void swsusp_unset_page_free(struct page *p) {}
 
 static inline void hibernation_set_ops(const struct platform_hibernation_ops *ops) {}
 static inline int hibernate(void) { return -ENOSYS; }
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index d5dba0e50b2eb..e732bf6389e4c 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -112,9 +112,12 @@ static inline void hibernate_unmap_page(struct page *page)
 	}
 }
 
-static int swsusp_page_is_free(struct page *);
-static void swsusp_set_page_forbidden(struct page *);
-static void swsusp_unset_page_forbidden(struct page *);
+static int swsusp_page_is_free(struct page *page);
+static void swsusp_set_page_free(struct page *page);
+static void swsusp_unset_page_free(struct page *page);
+static int swsusp_page_is_forbidden(struct page *page);
+static void swsusp_set_page_forbidden(struct page *page);
+static void swsusp_unset_page_forbidden(struct page *page);
 
 /*
  * Number of bytes to reserve for memory allocations made by device drivers
@@ -1036,7 +1039,7 @@ static struct memory_bitmap *free_pages_map;
  * corresponding bits in forbidden_pages_map and free_pages_map simultaneously
  */
 
-void swsusp_set_page_free(struct page *page)
+static void swsusp_set_page_free(struct page *page)
 {
 	if (free_pages_map)
 		memory_bm_set_bit(free_pages_map, page_to_pfn(page));
@@ -1048,7 +1051,7 @@ static int swsusp_page_is_free(struct page *page)
 		memory_bm_test_bit(free_pages_map, page_to_pfn(page)) : 0;
 }
 
-void swsusp_unset_page_free(struct page *page)
+static void swsusp_unset_page_free(struct page *page)
 {
 	if (free_pages_map)
 		memory_bm_clear_bit(free_pages_map, page_to_pfn(page));
@@ -1060,7 +1063,7 @@ static void swsusp_set_page_forbidden(struct page *page)
 		memory_bm_set_bit(forbidden_pages_map, page_to_pfn(page));
 }
 
-int swsusp_page_is_forbidden(struct page *page)
+static int swsusp_page_is_forbidden(struct page *page)
 {
 	return forbidden_pages_map ?
 		memory_bm_test_bit(forbidden_pages_map, page_to_pfn(page)) : 0;

-- 
2.53.0


