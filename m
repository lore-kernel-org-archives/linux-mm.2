Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0E5BC79F9F
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 14:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DBFC6B0092; Sun,  6 Sep 2026 10:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88CE76B0095; Sun,  6 Sep 2026 10:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77E946B0096; Sun,  6 Sep 2026 10:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8C86B0092
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 10:41:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CC9C3C0519
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 14:41:27 +0000 (UTC)
X-FDA: 85183600614.17.FCC49CD
Received: from out-2uec-a116.jellyfish.systems (out-2uec-a116.jellyfish.systems [63.250.43.116])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2DA12C000B
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 14:41:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=HeP+2KOE;
	spf=pass (imf28.hostedemail.com: domain of hi@tychen.cc designates 63.250.43.116 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788705686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BMfLqBwWKBeYU1egJqEuEAvuOmS9JC9iK50RUqn+x44=;
	b=y6mwXaoDPPZYo326zWGIONjLj1ZHHSLyjim1YlPhgYMCv40+ilbOZZNekp3Z47V/8akbpc
	95pI765YlK+cnQQAQYs5+uly1jaeYiIaO6AyuqA3cdjbjCLQbjoPFRVCrFGgAe0V+ztGrk
	hrX6LIqHhQEtOac+FPXwkTHuCkqIZVY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=HeP+2KOE;
	spf=pass (imf28.hostedemail.com: domain of hi@tychen.cc designates 63.250.43.116 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788705686;
	b=6qSgawd2fry6aA5GZd4fVbe2RJZia9RovDdd2uMznbFbWYmvIZuG03H5GMNfVmiZ7SvsB+
	LsA1PZdC6o7b7ASq3xcTsQwZ/llyVsLlPfBVHbpvKwV70q3OGKLJzHIKg5bF3p3xgBuahT
	7FSsg2NC68lKO8C/1On0m8RpjswzN8g=
Received: from fedora (unknown [69.5.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hdCYy1G73z2xBH;
	Sun, 06 Sep 2026 14:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788705673;
	bh=BMfLqBwWKBeYU1egJqEuEAvuOmS9JC9iK50RUqn+x44=;
	h=From:To:Cc:Subject:Date:From;
	b=HeP+2KOEVEQwsAKbaTMLXL4OIo8jhFeapg2UDWFk/ihtHhBlMn0G7rLDNZQb0RUZg
	 oG4fQ96wIcnDA1bVrRudHsIg+0JF0CXebElLDaqeTDNRjE3UZO2oniUBtwvAVS/R1U
	 p6+IoLYu9X2dZZ6Eiv1DpMqdlpwhgSeYLUcl2/LOqyDZc8ba44BB7N26ig3QGrnPrW
	 I74xQgrzk7yd8GJtYvSucSMgxghZOn44uos8PAAJbO+3C1+5VQntUEeOC47mdpB9gl
	 RiMWukYLciZ9B8viExOLR88mODHjcckRaDLnGK3nYqCQ6oS6c3tj4bevfKTDopCWKb
	 MCXN60d00Op6Q==
From: Tianyi Chen <hi@tychen.cc>
To: ljs@kernel.org,
	"Liam R . Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Tianyi Chen <hi@tychen.cc>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] tools/testing/vma: cover hole filling through __mmap_region()
Date: Sun,  6 Sep 2026 22:41:00 +0800
Message-ID: <20260906144100.849288-1-hi@tychen.cc>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Stat-Signature: 1a7haxygbc83n3eyg7m1yuwo5ukze63w
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2DA12C000B
X-Rspam-User: 
X-HE-Tag: 1788705685-591558
X-HE-Meta: U2FsdGVkX19SPK7z9NWzazAJrid2mW3A+i3G2FZDzOxz6gJ+Qwgt0gxowQ2mC14MYv4uPUDePMXWhDnt9XkfDMMAAOMa78R7i0o+ZMgs+8gOWlcFfm3Zy8+0Z+Oa4MW1q/6wjlF3uKOlt19bfC45Poazhx5XunYblFd86ItwTOaq+DpCBWM5KufQqwQ6GfsmfDp5Pj7/7NplvgX+JasL4Du5e7VEuDptomntiV9iUL4f76QlRO64KXcRoXZdYwgDIJFhbvPVIaq+13ay2fVCWKZahD21V0jER0Iadz88Uvx4fBvei44LfRjkV4bHrLrsOG4aVoqGLH6FSnQjfJhLyHFsogXA7K4g3DRLnfPbxUJab4XTsAAnDKMfJMcqa7G32qGreTZiTW8K+94LyC8KtpFja899ezk0trqcHDby3NZL/r3gZsSn+5bIfpxcE4Z3ejja4jQ2jmt/NmRx+pdsjQJ5+UMXlldrUEg7AX8QrJAxL3le97vXUpK0CzO2Y0WquUgno2AMhNBXpesTlF4Dl3ebsa3kmcDjaxi99u8T8JML8+525oBvUU7UB6XkI5QVGP1EpUxWkqWVnoscl4VZ81hPhQl+/56AHCxI1RKml2UA/Svw2WjWSBqo+KyIW5s9nJPI8YN9cn+PNd5jxlkBaZ/AGmbErw9mFtw89G1ZtPVSvSyAVLa9M3CCG8wwRbd9UQ1lHdsdOZo5/2+sYdOxGt4rS+eFn2ia4qoGnde3HemKNwuT1G6FyHCdmdBFYMG/cX07wFwgR7Z4LgUPtCO+LhIJ2SuSyvBSKHzjREu/RPkvYmvQ4X/ZOsvbGfeIX03ri5l4saXU2Fc1WzCeYaotF3Ij5uv/uJJ0AQXbhLs/acaw9UFMWpDi9ZHWmIZRoFUt+ovr4+7M6DByspFFT6MuJpRbfvnAT8my/I+FFZzo8KNmu7aRLj0cTCVMrrepJx/AzFCsEWKWfVv+ssidpuX
 6U9qc5VL
 rM1+E07dOaKHPX59HJd12MeGnLK+vBTjCiRu3+W954O2C0yiEuBcltQSVKDBQFZcgFPmDLsnp7ehx7NCQ5hTot7TXJSFblk8BsD8Zf29hmRN2KfWv6EqxOKOSupU4VZR8BKaJci+bH5RbsZsqmxpNOWxp7hN1X1jCoqwOJuib1CEGiSwuSoPixlNNgcmK8gOYi9QskFO3E9UOG9dCzwFKM77roWZ9jEfIAGFMeUF6p4qeGeFzE/TeTXYs7J4GWEhMW87GvLMv3483qtFIOqf77Fj1wNympyrNnjMSeIVEWzAiqoF/9l37ifnYsanyuyfSzHzCysWnWepzmc7GKaLZSEXb8p+/boA0gIjO4Tc7K1YM/a3Gg+J/f/xtigj/5oFKsZ/K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mmap tests extend existing mappings one neighbor at a time, while
merge tests construct merge state directly. Neither exercises filling
a hole between compatible mappings through the mmap setup and completion
path.

Fill a gap through __mmap_region() and require both neighbors to merge
into one VMA. Repeat with only the new mapping's execute permission set
and require three separate VMAs. Check boundaries, permissions, page
offsets, map_count and tree lookups across the mapped pages.

The full VMA test suite passes all 28 tests with ASan and UBSan enabled.

Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 tools/testing/vma/tests/mmap.c | 75 ++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/tools/testing/vma/tests/mmap.c b/tools/testing/vma/tests/mmap.c
index c85bc000d1c..b66ec932a75 100644
--- a/tools/testing/vma/tests/mmap.c
+++ b/tools/testing/vma/tests/mmap.c
@@ -45,7 +45,82 @@ static bool test_mmap_region_basic(void)
 	return true;
 }
 
+static bool mmap_region_fill_hole(bool merge)
+{
+	const vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+			VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT, VMA_MAYEXEC_BIT);
+	vma_flags_t hole_flags = vma_flags;
+	struct mm_struct mm = {};
+	struct vm_area_struct *vma;
+	unsigned long addr;
+	int count = 0;
+	VMA_ITERATOR(vmi, &mm, 0);
+
+	current->mm = &mm;
+	if (!merge)
+		vma_flags_set(&hole_flags, VMA_EXEC_BIT);
+
+	/* Leave a hole between two otherwise mergeable mappings. */
+	addr = __mmap_region(NULL, 0x300000, 0x3000, vma_flags, 0x300, NULL);
+	ASSERT_EQ(addr, 0x300000);
+	addr = __mmap_region(NULL, 0x306000, 0x3000, vma_flags, 0x306, NULL);
+	ASSERT_EQ(addr, 0x306000);
+	ASSERT_EQ(mm.map_count, 2);
+	vma_iter_set(&vmi, 0x303000);
+	ASSERT_EQ(vma_iter_load(&vmi), NULL);
+	vma_iter_set(&vmi, 0x305fff);
+	ASSERT_EQ(vma_iter_load(&vmi), NULL);
+
+	/* A single flag difference must prevent merging with either neighbor. */
+	addr = __mmap_region(NULL, 0x303000, 0x3000, hole_flags, 0x303, NULL);
+	ASSERT_EQ(addr, 0x303000);
+	ASSERT_EQ(mm.map_count, merge ? 1 : 3);
+
+	vma_iter_set(&vmi, 0);
+	for_each_vma(vmi, vma) {
+		unsigned long start = 0x300000 + count * 0x3000;
+		unsigned long end = merge ? 0x309000 : start + 0x3000;
+		VMA_ITERATOR(lookup, &mm, start);
+
+		ASSERT_EQ(vma->vm_start, start);
+		ASSERT_EQ(vma->vm_end, end);
+		ASSERT_EQ(vma_start_pgoff(vma), start >> PAGE_SHIFT);
+		ASSERT_EQ(vma_start_anon_pgoff(vma), start >> PAGE_SHIFT);
+		ASSERT_TRUE(vma_test_all(vma, VMA_READ_BIT, VMA_WRITE_BIT,
+					VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT,
+					VMA_MAYEXEC_BIT));
+		ASSERT_EQ(vma_test(vma, VMA_EXEC_BIT), !merge && count == 1);
+		for (addr = start; addr < end; addr += PAGE_SIZE) {
+			vma_iter_set(&lookup, addr);
+			ASSERT_EQ(vma_iter_load(&lookup), vma);
+			vma_iter_set(&lookup, addr + PAGE_SIZE - 1);
+			ASSERT_EQ(vma_iter_load(&lookup), vma);
+		}
+		count++;
+	}
+	ASSERT_EQ(count, mm.map_count);
+	vma_iter_set(&vmi, 0x2fffff);
+	ASSERT_EQ(vma_iter_load(&vmi), NULL);
+	vma_iter_set(&vmi, 0x309000);
+	ASSERT_EQ(vma_iter_load(&vmi), NULL);
+
+	ASSERT_EQ(cleanup_mm(&mm, &vmi), count);
+	return true;
+}
+
+static bool test_mmap_region_fill_hole_merge(void)
+{
+	return mmap_region_fill_hole(true);
+}
+
+static bool test_mmap_region_fill_hole_flags_mismatch(void)
+{
+	return mmap_region_fill_hole(false);
+}
+
 static void run_mmap_tests(int *num_tests, int *num_fail)
 {
 	TEST(mmap_region_basic);
+	TEST(mmap_region_fill_hole_merge);
+	TEST(mmap_region_fill_hole_flags_mismatch);
 }
-- 
2.55.0


