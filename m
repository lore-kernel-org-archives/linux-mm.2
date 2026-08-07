Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0470C5AC82
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 15:55:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3197E6B0099; Fri,  7 Aug 2026 11:55:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F1776B009B; Fri,  7 Aug 2026 11:55:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144E26B009D; Fri,  7 Aug 2026 11:55:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0E826B0099
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:55:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5324BA0457
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:55:04 +0000 (UTC)
X-FDA: 85074922128.18.FCE5231
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 69C9F140011
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:55:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MuIHmetm;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786118102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c6zA2T4YXfwsdHoNQLbL/JyAvXh3qkO2k+ehgfnDE/A=;
	b=4tnwP4tZBWLQnyOtqZdlJlwHn6xOZ9nKZm8oKWzPtY9Cws2MGSoTfXW6DgeQNgVWRFVIP/
	E4NgHdOSv76UJdUB3mRRtZ14sGL48gIGu9jEXowiPCDn88TWo8si8WMoHuUrE0jEBf44uF
	iBf2zFeg5jpcfnVxB7nq1p3lbuSbBx8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786118102;
	b=o2ymOucuWEld1IR4s2mDKuGOa4IknvC30Foe2Qda+8VI1BRMvOZT26nEC7J5XaH4o8a7Ak
	A3OTpCmtZ1UQcpKYYkrAiXwV2wEfvgXgpeWc07iRcOVkmgb/gR4+T7slCXGv3LchNXEY36
	bJ8b/msC340rgP/TW1vOMOtufYPGV8w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MuIHmetm;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D0DD42000;
	Fri,  7 Aug 2026 15:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F1C1F00A3A;
	Fri,  7 Aug 2026 15:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786118101;
	bh=c6zA2T4YXfwsdHoNQLbL/JyAvXh3qkO2k+ehgfnDE/A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MuIHmetmub+VK1FGo+A9UmBhQfepI95uUeW4UfOYW/ptyAyUy/t96xh6HH1vAE/73
	 8e4/FhHnhytFYUlZG27iUUtGL+MtYro36oYbZ1KzernGOmHBYvm5DvpCOTtwZjsGRc
	 JaXVw9Xh6ODJ4vVnjVJUAOcKb1fUNM044TYgxQTLkvcOMzu1DTtuP4jLUVlvxQPrBz
	 LTRcbLUoAu+DBqE18XoVWIV8185djbKhs1j7xN3M62sCezj2/GQnkcwY+2GU0TXAOA
	 vpiut17alZeD7ktUOkiA7gYZo2Bgh0g3Ae3F8N17ngW/egLvb/lIpif0kQSTsxTs9T
	 FrnFKF0/po+Hg==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 07 Aug 2026 17:54:24 +0200
Subject: [PATCH v4 04/10] bitmap: Add bitmap_allocate() function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-tegra-vpr-v4-4-5510d16af89e@nvidia.com>
References: <20260807-tegra-vpr-v4-0-5510d16af89e@nvidia.com>
In-Reply-To: <20260807-tegra-vpr-v4-0-5510d16af89e@nvidia.com>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Jonathan Hunter <jonathanh@nvidia.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Sowjanya Komatineni <skomatineni@nvidia.com>, 
 Luca Ceresoli <luca.ceresoli@bootlin.com>, 
 Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 Russell King <linux@armlinux.org.uk>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Chun Ng <chunn@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, 
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2300; i=treding@nvidia.com;
 h=from:subject:message-id; bh=6mWNitHDPhlAiwoCi35Z6UVDAPmizX4WXMqdhhFXGJE=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqdf/GqjkfBqa0m/uQVblFJkD45pC7oLSmL+n/h
 //sqaTyXrqJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCanX/xgAKCRDdI6zXfz6z
 obx8D/9jABBh3HqjC5A6IGDuCJwknLCrh/q4jDo7TiLDD/Cl77p3iET5sXHP39p2y8q/yO1cGnf
 sA0+BjzaTEDGF9euWc824Z0QEEvFI59P3rmGkiJSn70i/967s12OjQjR06JX3F5owiERgHBqyNQ
 o1d01OKlP8es7OImVIEfbKmx0n6/VCJXlFfy+QUhlCFvS+eIiFEKo8k0pb2+M954Wd38gWLRKtE
 OCVGAIWwJxZfVfp069wfgIwnHLsfTHlLGFTkmS9meXELnRbzArGITAuARfy2GgDtBhaksqfyZqM
 +7tjQ1ak6nFybAMGdwkPIGIALpwCQwxfVDHV6aLJATEFHxX0VRP3q5UTp8ERVjHGkK0MtBF9oJn
 SgEwj9C9qg39Fjp6E9Zqww+2BVKEK8wsFEr1c8l4Q4Bv4OQJR7rRMktO/B49+0/x/jMiYDvgMWR
 89X7aLiP8sf4HGfpz5rNwzL6P00X+fuo/sqKx1EgNTzX+XRRT7GMTHxgFqbB7iI9loGTUcVdOBL
 n7SxcR2lI7Mw7OVwabw0GKPqcJlwogaODQHzF78PJYOTY8fiyV/NE2XYyh+Ic+gr5vf6DEZeHZf
 soNO+hucYzTMTMQXYeuB5qyhtri1RASEjVuqAq/kNWLVLIxNx4WVtK4o1RPz4flFKftK7CxWCbJ
 IJjBjxmTONLk6BA==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspamd-Queue-Id: 69C9F140011
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9i6tt1it1udp9u3fyccjgudnr8hywc5n
X-HE-Tag: 1786118102-463101
X-HE-Meta: U2FsdGVkX19/g98hmE8/sgykKQaNxuNJRrhvaJlUBZJ9UKzBYgbvGFuT7ahU5JRIODP/ZgbTksbl+BohHiAzFPlydGCLEnPRGXTAIM2sjVdtS0cI+GklkNahavMWeVlS9Dc20zW4zn/SNwNPPDCnSrEqwXjhA1P3oIVKahqf1SbiJsIJXY9Zt7RT3V7t3xXhKnz2vji+UqEX5GdYwurShOTHeI7gYgt43dpdIVXWYdJZZMLASl6NqHoQsDm13xN5UYMybocoJdj9Yz6J4q0dL1ecEfQiL1xYgzejh6gZ5XI6abItNj9YyUZB1rznLoXah7W2XmGVBiWlyAeFW1Ecg5jDRbbvNwqt0Rz90r9JB3m7bkQKaZsT7lSuP1jjjRfKKnogpT0VnGqkv/HjQd0vQaL6rk9TxqOyGX5nl12EIlSrwJJ91ZYdjdsXabursqPA0Nn4QoDuJdJTP6/qYHVVU8eQKT639zENHhlTTfCPmSYSwuYrek4iJt4Wt6dqEyIowZec4HHa6ZVoeNgJNtzqGNR3HsCZ0a0aV79vB+AGCdqdY1SJjHtwMeZDwVkd/u17nPAQtkykTIcs9AUlmhfvGQCP/NqlVxl0niKz33mP/W2eamXHzqTzKMuYoAbadVzEVZXbOCHkqnCRwaKmfiL+3KDRz4qyqfGePw2/y97USdmM57tjE+/76DhBeT6JGVrl0zP1NeE8OHw9/QKwelR6dAqq6ei5bmQo/vWsqshjBTDmtopZGLnCmRljbL86Kxd+RYaWDFWsWTY+HJcXXCo2Bofnp8RJ8BcG/uPOJaE43uoPnXl9lSBUVJTGNn0Z2/K9qK3R0TKdURtBoxGM3RfwHFpJeNl9Ix0muz40F0lf3Egt4oWlsV9BxnNy3/6UMVQFIHpOVrs4YpxAKH5yBkuHfi5eLYtNKKcOCc+N4hqw3/io2/yhpzbFA9f2BpJtYXtGwzglQOw1kfJzVkUhq5P
 9eERmVIA
 EL0nCO09IvRO5+YO2Om8mQGk4DVxruzEALQgUDVfxeeQgkpfCGlBvp40MLfylnsILVceO3S4jljzahrneTJe5tl5fyxkAoufyZ+12HXDl6g9r7//6F4Y9BtF2FZ20Deox+Srpz2K1Vgi6XRyAQxJkDvatuJR7B1Fl4j4qPNpn9WmOGKsLvLEc93R0ubYeNW8RHcjmDNdDoRFee2+4pBIPXMae8o/xOT3+TZQk7xnvdUVFBOGrjcr8asaCVY9qmYKAcoBfzaS19lQP7L4yskXsbCW2K0+vGil9F6KQlciIKjKSRpaVhMCru5LdFtwJrLs4PYTv5bRmilLA0nX6+RWTs4tPs/s73RWgjAf57O2HGAIxRKc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

This is similar to bitmap_allocate_region() but allows allocation of
non-power of two pages/bits.

While at it, reimplement bitmap_allocate_region() in terms of this new
helper to remove a sliver of code duplication.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/linux/bitmap.h | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 7df1573a409c..c2ab02985b5f 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -716,10 +716,10 @@ void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order)
 }
 
 /**
- * bitmap_allocate_region - allocate bitmap region
+ * bitmap_allocate - allocate bitmap region
  *	@bitmap: array of unsigned longs corresponding to the bitmap
  *	@pos: beginning of bit region to allocate
- *	@order: region size (log base 2 of number of bits) to allocate
+ *	@len: number of bits to allocate
  *
  * Allocate (set bits in) a specified region of a bitmap.
  *
@@ -727,16 +727,31 @@ void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order)
  * free (not all bits were zero).
  */
 static __always_inline
-int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order)
+int bitmap_allocate(unsigned long *bitmap, unsigned int pos, unsigned int len)
 {
-	unsigned int len = BIT(order);
-
 	if (find_next_bit(bitmap, pos + len, pos) < pos + len)
 		return -EBUSY;
 	bitmap_set(bitmap, pos, len);
 	return 0;
 }
 
+/**
+ * bitmap_allocate_region - allocate bitmap region
+ *	@bitmap: array of unsigned longs corresponding to the bitmap
+ *	@pos: beginning of bit region to allocate
+ *	@order: region size (log base 2 of number of bits) to allocate
+ *
+ * Allocate (set bits in) a specified region of a bitmap.
+ *
+ * Returns: 0 on success, or %-EBUSY if specified region wasn't
+ * free (not all bits were zero).
+ */
+static __always_inline
+int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order)
+{
+	return bitmap_allocate(bitmap, pos, BIT(order));
+}
+
 /**
  * bitmap_find_free_region - find a contiguous aligned mem region
  *	@bitmap: array of unsigned longs corresponding to the bitmap

-- 
2.54.0


