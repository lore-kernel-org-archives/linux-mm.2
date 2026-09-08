Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9FCEC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAE3E6B008A; Tue,  8 Sep 2026 05:55:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38B66B0093; Tue,  8 Sep 2026 05:55:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDB0F6B0095; Tue,  8 Sep 2026 05:55:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94B4C6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:55:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C77A120480
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:55:40 +0000 (UTC)
X-FDA: 85190138040.12.AB1818A
Received: from out-utut-a220.jellyfish.systems (out-utut-a220.jellyfish.systems [198.177.127.220])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1BFA614000E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:55:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=YLHRykSU;
	spf=pass (imf23.hostedemail.com: domain of hi@tychen.cc designates 198.177.127.220 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788861338;
	b=mbD19ZyWEGRbmMTtRxWvVc5LsKz43g7qHIExF+iJ77DgWxWlg9AHunfVUxCBRJnU00vtMb
	jjzUTtJLizg1/a2sEz9w3g7wyXB4YVH0lRXhH9JsQtvTjPJm7XM4PXW3dtfc/zROL7RHzP
	aKINlcssN79hN39tL3bC6Y3X7psTOCk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788861338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aqU3LuAqQb/xeTEGHX/5XlAw8+0+r7gANB1IqPfKmKs=;
	b=C2MXpigeKvXGH5dgULyrOy3zjgD3KJFaIsXwDUVGqRX7jzCjxNbygMiTVSLBJsATZk02FT
	U3Pc1EoT2YyQClvb4JepcmfI2r3yp7ewumZexQR6KXO3SOZzIeTPxxFr/yze559kuEC/TJ
	PJXmZlXgDGcmDw/5h19R6l0O2P31enY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=YLHRykSU;
	spf=pass (imf23.hostedemail.com: domain of hi@tychen.cc designates 198.177.127.220 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
Received: from fedora (unknown [69.5.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hfK7J4xm0z2xGX;
	Tue, 08 Sep 2026 09:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788861328;
	bh=aqU3LuAqQb/xeTEGHX/5XlAw8+0+r7gANB1IqPfKmKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLHRykSULgmfDk5NT2skjV+cSCpjsLrUbk5082TKlzhcXnapZrPytc9Ly2AncswY7
	 K3NIyvpmok1RCiIKsRz08/Qi4oOR6156KK2FM/AEbHFMq317NRxFDYJ45eJ4+33pLP
	 2ud9d7F54cEM2xSy2O2YNPYr5DTwXxNnki0iuoCNOK16Qw4/T/yUnD+4FBSIlSOTuU
	 PL9stulPqVy31efueRNvW2oEs9ykGp/OC4dWNXbDtX+GC4XrTwGpkIjUo5WCBUSJUb
	 9+AZLOL4Xw3KXi+UKjHgdEOnhn9VBxw8Fxg+hV5U1zgTxFVe4oIIH4DZTzxxWnHsvb
	 O/s5flGhQd6JA==
From: Tianyi Chen <hi@tychen.cc>
To: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hi@tychen.cc
Subject: [PATCH v2] tools/testing/vma: cover hole filling through __mmap_region()
Date: Tue,  8 Sep 2026 17:55:15 +0800
Message-ID: <178886112560.138404.17741948638665342936.vma-v2@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906144100.849288-1-hi@tychen.cc>
References: <20260906144100.849288-1-hi@tychen.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1BFA614000E
X-Stat-Signature: akmg6q7is5e1yc59ekx6e4m6yotm4jge
X-HE-Tag: 1788861337-752181
X-HE-Meta: U2FsdGVkX1+eCK2U7nf4FqqQt/kNVplrcIt8/IpvzAaT2yxMaQTVKbGubWtGjyDfNbUF6ht2qWUrabncz78sQLgrslaOAVVpmIXS2OnwHiOYlAEcwYhdMdbD2DT3mppPVGVbEleySG9hkl9W6cwDxUUsicfY2okV6RPp3Kq8r9DVWrxmsTn4sbymkxVp3SyQPU6rHGkVko1kJ/X/codVSgGqOwafmaf4HmIL2HC4RD1Nal/PKUSHFZMBERH8vp+h9uKoLTHfDnBLc6LBWv8yuFnw4ohXt7R6k9YHEe1P5/mOoEtQpK4muamKR4dIacLl8HhZSMUQC+utDGe+a+yF6exnpEXw9x+Ss8kk7Al6nr3GV4JprwVNiKh3+7MAnNsoozEG8zJLHWgIMgsR4QecvOPpWEhSgprWuz9LDfsCr1TJUDN3EVDkB5sTEuQk+YhH8TCH0vSjQ48i/wS68Pu8azYCh1vT5Z1G69cS6k3HWYSC5KXxNYhLxGbL+K3wDQ1eEb/C3VGZhBdSUpXpXTGStimUofMS14asOeuyBbd0leezrk+HffXEYrmr53Z9/W/YSMnFaGa/qZbMhJMfNGm9gNTTqG4sCO3VuyqpmT9TOw5fOUebvhF4zfx4Hvi0dtDWJG4EbGBsX+o7XwZGW84/kLFVpgowzjznZCJk3xYjUfAlkkyr6/Ij1rOL1xaProxiAEkoPjJboqumfgSvNSM6O9Rc6ZOBZ2wRSwOtI5TBCxdhlqG8vUvAGuBtFeA3Smq9Dpa33zCVlC3k/RPgiBTFZz/hhoqDHM44b4qz1Oyr0UvvrVGfF8nz1esOqUBwud4R9Mw8EeYUJBeAIpfxdgqEgo5FXuMydeyJy3uWl9OHJw3mtQTEePdLbdAKC5zCnAFBhyOzsgFu5I3oTiKRZIoW9Vg/ZHFpZpcHq4ErKjk/GPz4+wvITwEW6vylHPJQfnpqSmjHr/O6Cqhnpo6Ivo5
 NBJBXydS
 666nSYh+E21g0mLaPzgskMyMGzy8h0bIUAlnVdJyiaV3eBglYAg5MKCI5+2biRvIgWPZxEod267Nof1lWmeW3Lfz9UO6KTSYkMvdWVRUSkdacXMSZKIC+llcKPS5/+M/BdGqCPE+y4KWx2l/oxBLhhaO1MYT/Mh3rQIS8u7x+skxVDGa33MMG3BYixzZDmJXn+EIWsbNPk/jXDFRQ/qYqFR0wET6uKBs4QMLUYmRKZ24OOv1lZ6TJtssevwOIXM6St4TviAVwS3zcqng82aj8S3U7buUASOetTIQdoqVsEtK2cdMFkg01kv3aLDx/r7m2a/FtrCchSr1pWm9abSH3JCJTivJWmwDEPhnRKg4j+X0ooq+yXx3e6e3uN+/k0PLUYUl/c9FqfUaYiv4KLYATjpK5RQ==
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
offsets, map_count and cleanup.

Signed-off-by: Tianyi Chen <hi@tychen.cc>
Assisted-by: Codex:GPT-6
---
Changes in v2:
- Rebase onto mm-unstable, preserving the new /dev/zero test.
- Rename hole_flags to middle_flags and describe each mapping's address
  and length in its comment.
- Remove the redundant hole, per-page and outer-boundary iterator checks.
- Use const bounds and named booleans for the middle VMA's expected execute
  permission, and separate assertion groups for readability.

Validation: all 29 VMA tests passed with ASan and UBSan enabled, built
with clang 20 using the existing VMA Makefile.

v1: https://lore.kernel.org/r/20260906144100.849288-1-hi@tychen.cc
Review: https://lore.kernel.org/r/ap5pmX-RddQ-c90O@gremlin

 tools/testing/vma/tests/mmap.c | 68 ++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/tools/testing/vma/tests/mmap.c b/tools/testing/vma/tests/mmap.c
index fa73faff226..53e4abe6a63 100644
--- a/tools/testing/vma/tests/mmap.c
+++ b/tools/testing/vma/tests/mmap.c
@@ -45,6 +45,72 @@ static bool test_mmap_region_basic(void)
 	return true;
 }
 
+static bool mmap_region_fill_hole(bool merge)
+{
+	const vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+			VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT, VMA_MAYEXEC_BIT);
+	vma_flags_t middle_flags = vma_flags;
+	struct mm_struct mm = {};
+	struct vm_area_struct *vma;
+	unsigned long addr;
+	int count = 0;
+	VMA_ITERATOR(vmi, &mm, 0);
+
+	current->mm = &mm;
+	if (!merge)
+		vma_flags_set(&middle_flags, VMA_EXEC_BIT);
+
+	/* Map at 0x300000, length 0x3000. */
+	addr = __mmap_region(NULL, 0x300000, 0x3000, vma_flags, 0x300, NULL);
+	ASSERT_EQ(addr, 0x300000);
+
+	/* Map at 0x306000, length 0x3000, leaving a hole. */
+	addr = __mmap_region(NULL, 0x306000, 0x3000, vma_flags, 0x306, NULL);
+	ASSERT_EQ(addr, 0x306000);
+	ASSERT_EQ(mm.map_count, 2);
+
+	/* Map at 0x303000, length 0x3000, filling the hole. */
+	addr = __mmap_region(NULL, 0x303000, 0x3000, middle_flags, 0x303, NULL);
+	ASSERT_EQ(addr, 0x303000);
+	ASSERT_EQ(mm.map_count, merge ? 1 : 3);
+
+	vma_iter_set(&vmi, 0);
+	for_each_vma(vmi, vma) {
+		const unsigned long start = 0x300000 + count * 0x3000;
+		const unsigned long end = merge ? 0x309000 : start + 0x3000;
+		/* Only the middle VMA in the non-merge case has VMA_EXEC. */
+		const bool is_middle_vma = count == 1;
+		const bool expect_exec_vma = is_middle_vma && !merge;
+
+		ASSERT_EQ(vma->vm_start, start);
+		ASSERT_EQ(vma->vm_end, end);
+		ASSERT_EQ(vma_start_pgoff(vma), start >> PAGE_SHIFT);
+		ASSERT_EQ(vma_start_anon_pgoff(vma), start >> PAGE_SHIFT);
+
+		ASSERT_TRUE(vma_test_all(vma, VMA_READ_BIT, VMA_WRITE_BIT,
+					 VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT,
+					 VMA_MAYEXEC_BIT));
+		ASSERT_EQ(vma_test(vma, VMA_EXEC_BIT), expect_exec_vma);
+
+		count++;
+	}
+
+	ASSERT_EQ(count, mm.map_count);
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
 static bool test_pure_anon_dev_zero(void)
 {
 	const vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
@@ -84,5 +150,7 @@ static bool test_pure_anon_dev_zero(void)
 static void run_mmap_tests(int *num_tests, int *num_fail)
 {
 	TEST(mmap_region_basic);
+	TEST(mmap_region_fill_hole_merge);
+	TEST(mmap_region_fill_hole_flags_mismatch);
 	TEST(pure_anon_dev_zero);
 }
-- 
2.55.0


