Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADB62CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 11:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C66A46B0088; Thu,  7 May 2026 07:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C166F6B008A; Thu,  7 May 2026 07:49:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2BED6B008C; Thu,  7 May 2026 07:49:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A0C806B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 07:49:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 57D991C0FF9
	for <linux-mm@kvack.org>; Thu,  7 May 2026 11:49:24 +0000 (UTC)
X-FDA: 84740453448.28.564590E
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id A157F4000F
	for <linux-mm@kvack.org>; Thu,  7 May 2026 11:49:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qC5KvtSC;
	spf=pass (imf27.hostedemail.com: domain of jillravaliya@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=jillravaliya@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778154562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6+zjW9mtW9U8pd+gqlznzNQ47C4c+N8p1poEgZPBXec=;
	b=fJ0xAUTy/w+dLdb3lHXZJftRoO8l1KCB4ZprfCRlq6KZu3cpcvpYxzhH577rkpx+1VCA7K
	b3W+nF2MrEyu8/CHZbdyvN3Z0NgtKfKmtcN2m+8oUilglXM2GpUapd9y0Y1fXy1m8O7+cc
	IgITA6jGBYawPCMmmeSiwtJc5Q+1KOU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778154562; a=rsa-sha256;
	cv=none;
	b=GpJsAX21Kr5N3vYgAuq1XmyeG81w9AXNmxqKTSVVQttxVFX3CSz7UBYi+PbaClQFgxVHiH
	8kRF9kiAuofKsZOb/LdcHMQjTQtpdRFUftAnHX69SN6FZNXzT60DIDVKATddq1XRk2y8q4
	rd9v52hsJqGNO3j9ENL5c9nCcAP7j5I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qC5KvtSC;
	spf=pass (imf27.hostedemail.com: domain of jillravaliya@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=jillravaliya@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c80148ae949so281884a12.2
        for <linux-mm@kvack.org>; Thu, 07 May 2026 04:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778154561; x=1778759361; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6+zjW9mtW9U8pd+gqlznzNQ47C4c+N8p1poEgZPBXec=;
        b=qC5KvtSCTjbocBEFGsNjHN5juheGt+O1aF5FrdckbETA/I9YayiVr8C6oXWO02RfF5
         oW3Id5KM4VtLUS2usS7JHD2Wr2FP3LuKmzsyZrkryDw+uJCr26xL1lo5Y/9CDH1UiL22
         fAuC73JLAUSkuwKagQ7u+jMs7rJwjj+72Z6s2JEXvEf9ltFKcjaLTbfMVnnKVhFf3hms
         ZmcBj2ht7df0r0jkSYmeNH840RaQdVIBvm2JSAm2xrFI42ysu9HcM6vHjeGrTtQED53K
         xv6x7XBojjh2yVd9swvflfmMLZenycuhMjOIzmkfyyDeoVGFeanj4P0rPsIr/YZ6HlfX
         U84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778154561; x=1778759361;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6+zjW9mtW9U8pd+gqlznzNQ47C4c+N8p1poEgZPBXec=;
        b=I6ZENnPgmfjtVg1ojruqPhVsXUlxyVWTDIcNtxkCbf/HOPF0OB0tgS33hfmIckzIkt
         LZFFV8gfEJInFiIJAykrB5NXA72WQlLPUue5FGKXwBcvnfXYYjUVQbaC4xEICEMtxAas
         /5PSqAPcDZvbJM7wgrwqOqA8h59wxS6PVAKCnt58kQd0pN4yeqVmu2ZpOySXVbZatG7a
         jwih1yVJ+yai8+xKYdFVT1XxwZBD0LKIwDnjjmFTYgirQo+rznWpkKdHmtnVb3wZiQhl
         Dj1h0dfqEDR6TwLPhXZzcc5VL8TtjNndX/OzIxePMAzBl+UhuyZL7qJlvOs5wBi2z9U5
         WnvA==
X-Gm-Message-State: AOJu0YyacfdQkR1pWC8xOzQy2BqMM0aIoaQxfWEMrwlxvou67yAZ2jx8
	hsluMZvmL3ZrEqqQR7rfES8cDO8NuVVfcJrRaZS4lE6fzMsBlZR4LL1s
X-Gm-Gg: AeBDiet8l/XTo4O9ws9q99Q4GtAbTTNH+KZQ9v+tBeBjFdqT0Jx6t2G9nI5A/tlTcUK
	wOEBZA9le21bDBLfjG9NkurshJi8v3H/1mD6luYT3RKUEOuCCyCyR5RJ35r1Vhm755En4lZt7LC
	MVi0Eo70CdIY9KhUrZ+35QFSRU1ZieQQ5G//26vmqPZBdw3xlRi74W2H5I0hJMqs74QEZei2/wz
	uMkx1iju25ezwQ6ciVhCxT7M2FYDD4TYcMsoAZD7Su7I13szvbbnLs5g9o8Kh1i//1qPaHhKJlC
	73QukwFnzmzJ9bedqU9HP+8uST/c8jxwqRgqBnK6yt15CpcT/HRQjTtxgzVJjz+fZQoNKBMacLd
	wu8wvLtmaV9MhwVTHoDUbmM/bBSFWfX376Z7YD7Ozes1Q4S0Uu5z9V/hddIVqWsjrn95tzmas9g
	UFws6t/bxPpku6fnAMf12K+HTzdfayacpEpfTr22oM4OfbUmOyBarXqxVXvZz1/kEL6EGv2G7Ed
	PaGKoITCWwDkuXGYq4wE6yw/+CW4jcp
X-Received: by 2002:a05:6a20:244d:b0:3a3:a69c:216e with SMTP id adf61e73a8af0-3aa5ac23e75mr8544443637.38.1778154561192;
        Thu, 07 May 2026 04:49:21 -0700 (PDT)
Received: from jillravaliya-ASUS-Vivo-AIO-V241DAP-M241DA.. ([2409:40c1:2022:5af0:565b:1ce7:b5ad:c8ae])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c825378fd56sm2014106a12.8.2026.05.07.04.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 04:49:20 -0700 (PDT)
From: Jill Ravaliya <jillravaliya@gmail.com>
To: akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jill Ravaliya <jillravaliya@gmail.com>
Subject: [PATCH 1/2] mm/vmalloc: free unused pages when shrinking vrealloc() allocation
Date: Thu,  7 May 2026 17:18:53 +0530
Message-ID: <20260507114854.41117-1-jillravaliya@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A157F4000F
X-Rspam-User: 
X-Stat-Signature: m4yhet1ztzjhxcmwx5s45h6c1tc4nn8r
X-HE-Tag: 1778154562-528026
X-HE-Meta: U2FsdGVkX19tzCuX4gbhcMvYHRROSXWjlWRLZeP1j7FXGoSNPWycNY1H/2PYrEKDDyReQFf7E42HIE+yH9up1eOrAdzqSajNDFGwykEc6D19qa71lrHmwSu8fba3e41EDjoUVOE8AS8qROXyWKHxfjllhK/OwsXGDCa3mZiGD9v+wAI5WU6dVo5VPVyaEqIxi/gF0yECsbKBlMAnSiiAtF8q0J+S0MwJq8hJ2pBOVPZTzO+tSXSSqivIeSS3vqxBDjcgwQqkJ7JAyyMGPzst5uitSBns7kC6BbjUPsQWzWtUptx4+PEnfUktEW2FVn2TxRB7g0WOuPbYX+Vga2gkN+/wAcqdVUWEqt9u4jYBg2JsLLOCHKBdmEARkpwJ17y6Nwq1MQilHEFuF1l+GXO+/FG+JyVh8OS3CyKHYqY+II6wteWwG/sIQwe3q7unydkodENLOPHTNDxuO7Z0FX55PpFnmqLqI83QoBbNrX3C3eJ22BOGE3gEjB6RGDfrjSavB4haEnlRCY65tmics7xa7yNXc3UVCT0pzV3VtquagWI6vA5qPM0xHTTQx0HHLcba2AJc30tvgk30wElPQ6BGxMK7kOIMbS+8VXmETuGAV+nZtDOJ+cvD420NiNUcKLSE/+WiBmYSpNHPLSSy3HfBnQXNrrG0N4Uj4FUPzHjuTgtk2WP8dSmAr0vuOZ4R8Us4TP1vM9A2f/xYOa01t8aFvP0/x51tKCLEX9/dlEe6pKCkdx6YCBcACBhtF5Pc5Hg4oKrxNOy9biAiFQwjbAi3qOvQ+X/ay8cpXl4WZA7w1llgWR9i9m8HCHGMNkeL3YdXseFp0Zc+ypTDoAyf1B5BqEfgVGnlrqCTaLuPqPhH1063wst1ysVaF5lDn8GQjXkLmOGauIs4/krhcSh2o6JYWA4iFvNDiGgFRItrY8jdsxWby/MfJyW/R3FMHh/8mVnRqYFFCouIOOZIhmaG/d2
 537+6Uy7
 aRpsff/alWRkYkmKpcgBfmw1FvZE+Z3cJPk5JU7OuOFFUCkkKE+XDZGMtugMOgCfwCTW51rAb61fHogmbqgNb7NEanVy6dvlVyJiOtpJgFTJW9/V6qf71Wepq+LYsCPo2iVrSuxQyWnrugufYzcjPuUzj+LgaZRF4g+2SDnzECvxStYNriGo2QYNUHF7FU7yDc4X3lDMZMnu5esXntME5WZDccSJbFisWCNP8hU5IAK4jTqXeVzyNtxjyPNvlyOGSdtHgo3PyGUQd4iN1ohLWro8Br4bQMAQGfs3dUjVBbDUq/R4QFGfIZFjw1mZUpc4Za7TkLBClkuOmoJyTRpPEpQCJpOh+ui837X7R8Y+5BtnTq4d7YWeXuoGy4rlTZ1wZS0O2zLKZa9fWehMUCNlGzxBsvF/JGq4YB6ooXGaBuMWo8/DBiFmW1Pq518s8ntm75q3rWXh8vILZAGywMxVNsxUbRIeTgGRmGHkXAWbvLlpRrazq7Cf0YD4g7RmfSIeVSM7PEcpx2xzx1OiVl1sfbwA/Nijm9Y8HZseo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vrealloc() shrink path zeros unused memory and updates
vm->requested_size, but never frees the physical pages,
removes page table mappings, or flushes the TLB for the
unused range.

When a caller shrinks a vmalloc allocation, physical pages
backing the unused portion remain allocated until vfree()
is eventually called, wasting real RAM.

Fix this by unmapping the unused virtual range using
vunmap_range() which also flushes the TLB, freeing each
unused physical page back to the buddy allocator, and
updating vm->nr_pages to reflect the new page count.

Signed-off-by: Jill Ravaliya <jillravaliya@gmail.com>
---
 mm/vmalloc.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index aa08651ec..a8cedfc5d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4336,6 +4336,27 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 			memset((void *)p + size, 0, old_size - size);
 		vm->requested_size = size;
 		kasan_vrealloc(p, old_size, size);
+
+		/* Shrink the vm_area: unmap and free unused pages. */
+		if (size < alloced_size) {
+			unsigned long new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+			unsigned long i;
+
+			/* Unmap unused virtual range and flush TLB. */
+			vunmap_range((unsigned long)p + PAGE_ALIGN(size),
+				     (unsigned long)p + alloced_size);
+
+			/* Free unused physical pages back to buddy allocator. */
+			for (i = new_nr_pages; i < vm->nr_pages; i++) {
+				mod_lruvec_page_state(vm->pages[i],
+						      NR_VMALLOC, -1);
+				__free_page(vm->pages[i]);
+				vm->pages[i] = NULL;
+			}
+
+			vm->nr_pages = new_nr_pages;
+		}
+
 		return (void *)p;
 	}
 
-- 
2.43.0


