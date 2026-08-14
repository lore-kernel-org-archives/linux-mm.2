Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20CDEC5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 15:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EA8D6B06D5; Fri, 14 Aug 2026 11:29:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C1EA6B06D7; Fri, 14 Aug 2026 11:29:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2E46B06D8; Fri, 14 Aug 2026 11:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A1FE16B06D5
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:29:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E6AFF4018B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:29:45 +0000 (UTC)
X-FDA: 85100259930.07.1C42758
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2FCE340005
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:29:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H8fMWOsQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786721384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tvyd01m5FmUtu3q6l/t0/X1UQi3FbzSuZHwJCHFz3QM=;
	b=MBgPslSEukt9+Aqv+crrOPVXRmzFzS5/5sPLJCr6Pg6JaqPlJ/Ek7Gt/XLUCjObUnXiUbB
	gbZz9KFfyZO2rU8mnGodZieDTvkrDr4uKlny1jsNai/+flRBeTLAfcy9lGk+hBbiUdIx2w
	NxICIvLJ+TENB+O3RNrtv0BCUYfDTGA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H8fMWOsQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786721384;
	b=k2/KvTAk/EB0oq5xzyOflMLkR5TFOwTOg8CciGu96EyWRsIRBq/gDPLoN/B+G8PefOBzNf
	IpmjfetfelSuEPk+LsQxbx3b2jk0EWG6ZCcziTiZQf+P0bxxnZeYGJ9pxwBjLofTz1D0R9
	KpcBkQAasdreEGgxZRuOOwJK1+B5mXs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9FC3360A69;
	Fri, 14 Aug 2026 15:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC061F00A3A;
	Fri, 14 Aug 2026 15:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786721383;
	bh=tvyd01m5FmUtu3q6l/t0/X1UQi3FbzSuZHwJCHFz3QM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=H8fMWOsQ2nY7rRYNXdC3Kxk3tP32Auay7NWiyJ65BNvLq38ZZSecEDKR36HmgNk7+
	 s3Z2rCk2cKe57LilC2o4MM4r9AMF1pxtXhXVntG0Y7DTuY4QHF6MUCMYnpIT3sNeCs
	 0U+jK63PneIHswJSFebrqfu0HdvP7pHlcGdZrXlYUQn6kUgvMdVEc6kb9nB1sd3p3I
	 uATLMVHvhtHrm6Z3HDjq1GXQZ0m/nqvNxNJC57soSA9lreXCC0LBBp1tHEywyqrlLb
	 NtWno1ofLqFfZl9KpPx7NGeFY5mLzpelryD8eu9n3eCqNhRiaR60wyRSRJKIIKQ5K9
	 qyZYSLHwIvD1w==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 14 Aug 2026 17:29:12 +0200
Subject: [PATCH v5 04/10] bitmap: Add bitmap_allocate() function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260814-tegra-vpr-v5-4-71832b5d0246@nvidia.com>
References: <20260814-tegra-vpr-v5-0-71832b5d0246@nvidia.com>
In-Reply-To: <20260814-tegra-vpr-v5-0-71832b5d0246@nvidia.com>
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
 h=from:subject:message-id; bh=wRtcGoPPtBVnuqzylzx/Ya02XdoWLRjgy09wPiiWfTU=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqfzRYn56w7dlp0eX7ejF+F4kvYppmzV/e3SCSG
 vxjhHD4yLWJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCan80WAAKCRDdI6zXfz6z
 obboEAC10PUKwRv39HTc5k+g4sCaMv90YqNR/4He93iCJA/t3/bYB392GuvI40e9i2b+/THKgUv
 owyRKvDL45Y4tLql/kYzRamz9NA9LdbBSs+ALLU7UX6K0hB081zMAGWc60XL5xShzAbvzibh6LE
 Fcm9PIozUNxtcXlYkrNlXUMOFJLN8mURsKvTmSFouWuQz4JpOLeCnBlLu5kr+IRVKq5cdoINN/a
 Hzj2JnV698uLUjjhtSdJB4o3vQePF6pdPbqW4OP7luNAhDEoTa9CATJYbSxPZZ5ANeliBOT9wor
 JbX5uyBlr1UDan0Y4nFQrXn1fYI3sRGT8uiHBnyBcJL5PQuGoXB1SCplKEPypB5tJ0DS1J6cCAq
 JQas5RDquiISPuJiUWJidJ4ziQT1a/yMHfDtZQF3aSwVJWMx64oD1pevUM3mhWEvkMxyaXG+VvN
 YJkx1v5lrMEpFxhFCjKEfg9eowCVBx82wk259dPU7bjlFrLrtb79fgN53JFj/cQ0Km50AOL1tm1
 26P/+JanmM3fSChpg06noCAj0hPxJuseICEeXumslr79YvJzC/24j36oU9o/y0EiyIBk9EDvjTV
 THzOJwt4mjTsP+pyu8XGptz4JPKzIveXxg+hFh09CEdbcj0Ad9lJdbj9DImFUv9p3LkDFqxBQC1
 XuMpNPPr6dO7P4g==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Stat-Signature: 6ozmm3yt9hxu5d3zqjuy5fnsmc8qn885
X-Rspamd-Queue-Id: 2FCE340005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786721384-405018
X-HE-Meta: U2FsdGVkX1/rHwEoAwXKsI6EAdzXcQ2NnSiKEd7Mqv5MMT9uyLtFeAjsSVPZeTu/RvqZqWy1oYehPcfeGmtcl4hhdJbSpHJPUYr2mKaAR1elQH6sKqMTZNMV7/C/TocPVstDOi3BUCrVd28c9biKeoS7nds5PjwW9KeqN8og6+hrtFVRdSKqHMvMqZYj5rbT4fcas8dPMVDB4SFffkQMKGeGwNNRLrGLw/N4nsszlWGAsHqelNIag7mXELCj9LWpAOHu589P1IY1T6ht9a9GkRetICqT4AOrS/3qpD+QOHKLeMcnsGVKjZ0s6m0Kb1RD7THgHYQbAmSRpazzV64HdpGUigtB8jhLPJdc2ST7J6rn7Y6FdR8FEIS8t1v+R3a2QdHQ44wcOdkPkuem/8Jz89bIIDGOjbYS4MKQmJHaU4XxTEM4Td3dQ0VmzHJRDvm26bvc0qx0CJXxaaoqCmLdb7xivWPi8o3dIm2sFhp037i8er/KevkTPd4WiKbFuVvsUBDX3vCFJIvmJtxfshQA7H4McVXN/MTA/SvoaUMzEIZirrHnR2T3Ohla/gRLuyEspQ1/0SerTxBkiIAw+rXzzQy65hQkifSEgD5uJeQZapQJlUAlZ4Ag23+QE+9VljgicBbuvZySdeOwnInHzz+UHqsq1us5cfRbGi8ZjVJww526lSOk8U0rPj/HOc2OHKvfkPMLtYQwtxBhEvq6OSgN/Jr79ZVTgmXcVaekAZxW1d7Lx68rpnVHQoOu7mFFRUHqXkdTCEUCsvtpmtsZC6Y32fB8g8fKWEMBAECIUEmd2Vz8rezVtPVb6aRDH1zItCA1nsLMiu/wDO7phGt0+Vs9aCBAk1+tXJFUAkhbDRcBFT6PYzQhSApAbYzdFCKKu2wIIsKzAqWU4t+MgOFD9TI9kKQ/uDVH+zS/GLLkB9CBPvxtSezzBkPGiETCBYVch9QP4otfIq/KBXjtXk+lA7Z
 WJlYSTl2
 3DtvmQJVJm0VXznyw7ywrS20GZHOShzmTMpOsVbqkRUeazv5iIHd73f9pNALrfBb/ZDgSi7L/iBVLqkItq984ma6ASbFa2NhYt0eFOYy4HspnV0n6B0RYKDletYa3SruGeyEk76fTOiLVA65nSLAiEHASHm7JR6hWtvKM/YHdKXNZj4npv4dbQ3VRjvbpr2nX8vaUyPg8gadlkUDhBd+T3ZfuqtiQKMXkJVN5CHeRQG/qfKsXUsGfbJYtD5c3tTz/Dzv26We8vpWwWw60Zp3KkK5lDqhtXGrtMviEHEqdFrmQR1ntk2SFMuXP9ZLGWUNd8MM11omDVY0dQ8941E63vKENwqY8FHztnJlwz5mgO70pfSkrpt5OHKr4q4Cfb88VYtK0pzgImEJRinKcdACB8Qt30ZR1j2b1Yb0/URILE16v0CWrL2kcaSBTFp69Q8rBZ2j7POqioBAzd1z7CKpmI/T4Zum+8SgEIk5m
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
2.55.0


