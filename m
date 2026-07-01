Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71FCAC43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0ED6B00AF; Wed,  1 Jul 2026 12:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A89B6B00B0; Wed,  1 Jul 2026 12:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86FA86B00B1; Wed,  1 Jul 2026 12:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49DA26B00AF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:08:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE8F21C3441
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:08:57 +0000 (UTC)
X-FDA: 84940691514.04.0ED4ABD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2454C18000B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:08:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNYKF6zx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782922136;
	b=qnQltAGJQxU5ZC9ztNkQC6/E9nKOKKJoM+zMyGEpPzFGVc5UkkLVzjGaq4+/PWLTQLQ23t
	0Bwy2sscJpS+4WCrh1YvZoiLOds4QYs6B0X7c/rFugmk4QgKNzw/KbhoyZYlwFtlRMxxv8
	vIcJmbZDBfHgUMWWrQcUz13HpmJY64A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782922136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bv2mbusdTvV92u03LkLsnqd7ImB7l/m5WEfHrMjrMas=;
	b=yYX50XyVLMnA6SPvEnQQEk3RjJozHUVb3kBdOek3Q2pnN53gJ+XhFE6NsnE0Gcgmp673m2
	qSlKvYRCN9vC9felFukka827B8OE3ngLMDmZLvk3vrDfOeysh5QYK4sbWhMrURQqDfSL6Q
	gNAlYwZRAA1PtfZZp0zhf6tMDCB6pV8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNYKF6zx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B01D46001D;
	Wed,  1 Jul 2026 16:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B171F000E9;
	Wed,  1 Jul 2026 16:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782922135;
	bh=Bv2mbusdTvV92u03LkLsnqd7ImB7l/m5WEfHrMjrMas=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SNYKF6zxBSGYmAbusApOFFCWL6uuUs7pq21mB+LUSsno6qF0/nSaTI6zYzlqtNAJr
	 ZeoEH9Nt1QdK1ka8A8IPKNNTtdogOL5guN4e9X5Iq9XQGF+LfhVtQDo3DE1If4LtHV
	 dsdyLAQfXp0H++qlkxogtml72/gCJ9hzPymFLFTpF5dVYcgiFKtPNkgdlVn997r71d
	 A7syKbp0Bz+to+n93Qbjcgsl/GNMlv5wXyQHfyO7pdnzVnTb/EUvzLxLzIo3ygEPIm
	 iLnFY/gkqNNMpaWrlxkib0XaThC79et+ZcfBJIm8f8M0/ezBxGE9aFACoRniIT0WYc
	 4ekBB8GISLNSw==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Wed, 01 Jul 2026 18:08:16 +0200
Subject: [PATCH v3 05/11] bitmap: Add bitmap_allocate() function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-tegra-vpr-v3-5-d80f7b871bb4@nvidia.com>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
In-Reply-To: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
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
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, 
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2300; i=treding@nvidia.com;
 h=from:subject:message-id; bh=DGBpv2lJgXf+7uFQCQC0wiy13z2JKXDNp8H/H8fGu1M=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqRTuFau1YcqnQD2R1zcsMxdp2c/3VaTKjhCkvY
 IESBd2vNyKJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCakU7hQAKCRDdI6zXfz6z
 oa0JEACzF7v7uihOjhMHBe5Jyz6Q2xPJdUiI8nSwpJ1qTuDnpYhGEg57sn6hJthxEOVFSqy+9xC
 aJiUzj9sSDpEZcNC9b3yysvyM+MEsFUldBvNkaD/9DBzJShfzXdfRhDBVdzzd35ov9szxi4Qlby
 Dybso/w7L4uaO8o+hUivrNLWb2vRu00g+oLjNRJZqiJVsw6MWeWYP5Sovk0XPl7ZJZ6pXCs0uSz
 vJjSrHTAZ3S5I1Ilr86LUB4r5OVtnoLaswv3mHFoq9o9H70HXdV8g9SYbV1rkpGoyoLKjDpTVUo
 EtB5qCMFGGDPcSAgHGMImuXAigAOEmwuSA6DwGMY7BWkkY2x79/jvSC18Z3YgCjUNcXV0epfc9k
 KkcBK2ITzuaGuxkO3SWmm9473jXAb3BijmJFG7JLJpN6pMMIHrFpF0UOn5oOyuofQkZXU9R7++g
 okGECjKuyIUDcuVu2j+ch22XpYaTR9nmM2QTX6SR1tzQBLUDTjrUFmLdRcChjdPnsJD4MUIHA9c
 yfkgIsuSY3yYvIEaHlbWbj2A9B+rIdn5ROhfXnqreH1HiNthbMS3E8M5s9aeUgJAz1P8wTNij7E
 rH8B/EoeVBajcIixSYvzs9WVg64E3OW4ZB0cku6fUKvn07U9vXCs7mO5D6vZ6ARKOfeJncKEntY
 TtjrxqyrEmq4DDw==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2454C18000B
X-Rspam-User: 
X-Stat-Signature: 344cwb8oawbybswmxqmhof9yqtpyehiw
X-HE-Tag: 1782922135-623624
X-HE-Meta: U2FsdGVkX1909b/8sczJb5Rz39swa1bqeuXlzoc4BuUzPrgbBM37NJJPMjG9JZEktQUiUUhGiL6smCsbxoTF5l2HM5iON8p2JQIHGoWGfaRbvrIsuZVasZkkAcGLGrnSG1NwvqCdmVwHCbAhAoJnoLXcgIZkc0MFfvTFQQEBUSL7+Kf9v9a/pjZBG5OE0i5Tv4TjEezLsN8rVGvwKGKqagzwU43jzxlu/5B98jr1hY2NlhpM/Bi7TT3IZnISdSrBhNOLLHhpGdBGRJDsVOT9DO2VGZOtyHicCeoO16wUIIkC5mL4xcs2CpMuZzhYqMGQaS9DqtJhuAcmw4NwG0MfJ/9HbNtzLRnJuL6+rGdrnljGx1/+HvpP4hLMWbPDkGgPJb1YStSb2c+JlIWor/g1fPCI/GOMBSoQKduCp12GUN7leSZELyfbxcP1elCAFYqkYe5riHvgaZOz+v4iaGrLKeknSi6LiDbEqJUYgF1AAWGQly19qRbApGmlk+NPWDuZ1LuqAbGO1TLbpCW8RkaxVn19YqbRmSGAI57nzM1HeZEDr2FU52U1nrLKgsz+hzSZS6Y0ROIiqrwJPAMDofU/aseD0RlTPCMHo/OcL0TRrgqCW9Svn2dLlzJqQ3UlbpZcrbMqyZDrd7Roo0Klo63eiwKSbR5wivjdGRRIc/+Kso0/kCs8NDVIX9uzQHIflftSYnBVFs5QfhHaTtI8DYH8e3bHHj78ECzgcOmtrl0DriyOqIipQM3dNEY4c5jUbVgDlrIqr5gNC7KaJV8Kd7/hJ0S2ZNujYsA2unQVTAHMnkcpv4T6zPV5ieXEv0C5kqFU5XmD5UlEcbU1cl8tRX+ZgyS+tPluoUqpI+amDGoc56660GG+gUOgXY4+J8KAgyyV2NT0p8FI+bg/H3+OD/YUJe4YZZO4EKuPqt7XtbZXzZWBxQ51jgs32vLyjTayTTj/jMmh4isDCdpXYmvtCGA
 PaBgfONs
 427EXiFiYDraxTwSXcc26s6QT57zNYS+mSJI7kLJKt8XadMcrMW+I2HIv7ViprB39b7ED+Qy8MNngkYC5NjNGCVEPO4kvi/tWRcTOtFc6w5hzvMhtbeu6XyM0UZzd6+eT2MZlAiz/9FOu9+1ZL/q+vnUVS3sag7NRQVruBEWIE1hD6o3Vohj4MybOPJzmcYn9HnjBdKfDJQm0kF0rH2ecN1B65cX/xV5Rhz17oMIii6mO1grFSGqjrES05+fKrZsS/xFU+euPiOfLHBanV9FW3NFwVj5EKF7sCZGILjgeyHSB1gapxgjdhBX0YkZLVPEW/og2EsPTOaI98gyuF7baV5PgWsktZBFgc550OGxQAxFt5SU=
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
index 8854acf77869..fb0aec4b17a1 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -721,10 +721,10 @@ void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order)
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
@@ -732,16 +732,31 @@ void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order)
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


