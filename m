Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5B8CC4452B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F051E6B00DA; Mon, 20 Jul 2026 10:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDBD16B00DB; Mon, 20 Jul 2026 10:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCC136B00DC; Mon, 20 Jul 2026 10:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B38926B00DA
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:41:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F6BD1A01CB
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:41:10 +0000 (UTC)
X-FDA: 85009417500.15.46A5B54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 79F9720005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:41:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=or2RLRHU;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784558468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mUfRyzu4r4T3oUIBL7M02RpvtLmtjfRfrYDjBQ2+mno=;
	b=avVEkhOQ3iVC2oitM/kLg08gVMEwBESMxKVLasMXX7irUe77+HnXA9J03lwmTOYwAQoGcF
	Mq0p+AuV9Omlf2Huy/K306GyNFa6Hl6+f2fDHf0Fi/vwzxQWe5zYoXgnRexAqCae/pCwmy
	9k1THeyq4AVWiq9KrH0gk/qpvYYQPr8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=or2RLRHU;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784558468;
	b=VgSQ0e2nxrmEB7qF12Qos5YCbTsaPRd3ookmYsAlClMdqtBN7wLEgiIsWjL75i3Wzk9rP3
	9mrqio5tu8dGNas6HiZ/yRviDgG+l67iTVOuSBJ4QVqgd5jWcVtJoiCiDYMqlib9I2LY55
	4dbnEBsAy08cSvxRGVCQ3CDiXcBIq0k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1EB241AF8;
	Mon, 20 Jul 2026 14:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01771F00A3E;
	Mon, 20 Jul 2026 14:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784558467;
	bh=mUfRyzu4r4T3oUIBL7M02RpvtLmtjfRfrYDjBQ2+mno=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=or2RLRHU8FZwq15jHcSooMC21IyoNtOp2GAZj/MrF6axYBvTNV5uuVRhkwy97o22r
	 OtDicyiXwFPWkpvl1dOPymS/Qe/t1Y8TtBDz1vt8shmD8fc7fVZFjMsIIGq0pDAbMT
	 NEunsqU5yT3+joKbcNdlW2MFk++0CSOSMMj9cUFxSY/qCI6bR+MzJKHdFNP81JYzWT
	 RgoknuUd+ZMEk3ra5UvSUMW9jiyLbnWKqUF8YBlVMfNVK0LoF6bQZujd/XSteqQhyf
	 UNDN78ZwWWQ179KcfKz6vHJsHmgTxY4KHFmfaCQgv/KM3UKNe4+dl/kRMUpPxTguPd
	 6fzeDCZTPffng==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 20 Jul 2026 15:38:40 +0100
Subject: [PATCH v2 14/15] tools/testing/vma: add test to assert
 MAP_PRIVATE-/dev/zero is anon
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-scalable-cow-virt-pgoff-v2-14-2d549757a76f@kernel.org>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
In-Reply-To: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2647; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Ek6diG5p2xt2cOjPk+/pZ4HE6uM0F3720J7ylrqFTU4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLijN76quqn5K107j4fvE6K3TnS47qE7YWVRk2REkVey
 geW287rKGVhEONikBVTZHn+RXx/kEjYvM4L/m4wc1iZQIYwcHEKwETu3Gf4Z1JTuHbi4ju35yhz
 fVfL/51gdelDycsli5nXV0zqua2/I5/hn+3//4d27ee+rvoqR0m4wfroafmaoNzze3bv22idx9N
 gxwQA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 79F9720005
X-Stat-Signature: xoceknkpqfgyc81ne6g6rgxcwm8e3an6
X-HE-Tag: 1784558468-397764
X-HE-Meta: U2FsdGVkX184UyY/vdq+jNw2mDuJUeOtC0thFhF+ZzTZkbfkRSRY+YvKBdxX75YKF2nihmb7jcGy1dcn9WRUxVLGwoOqP3ONec2tPzuyLUhi47IxNklVD38dAhDRkaMqMrOFjNe60cpomCnoV39wHyvbWlMimCo0V0gxDC3jbeePOFGx9w0/6dFhGnw5+z0eokv40nZpSOq35zoHd7/mTVUVZq1YzvFmiYM1a1J0mvEt2hxmKFin8Pcl1CLSLX6wqHaYyJjqwX4ry5o3FM4EqJp7CQ2rwoLFXKITi/zC16gVHZ1EttghIfiQ8Os7VrYnSN/c2Q0kp8/Yz+NroiLcrBsBV/bmIUBl7cUmmIQdnYq21IacPZkhIQdFN6hbzvmAoE88PwGjxYlqXldEt+U/GJDSZ4Cv0t4rxiEKnkDN1pmEqaMNNU4I8USILp8D5Ru3fm1II633VmUqIes2YJz1Tp/ZvZJrwAGm7zNzXxGAYaDOn/+yfqwPvW39NQfEkAyILvc4uGWyRhazyWpWmc/0iUoNyWRhLkKx8Sh3+MRt7z7ins/Un3kePq86FG1h4yzaGNxPfL63+BegVIKckNqVflFYk8mslrcb/JaLbVaYIzFK2VUlfk9/kxhlGOUfAF+Gr8Bj2ERutIqjisNtBELufqMC9l7Eu48IJx+C8g9mNyKVp4i00TY+4uZj1WTEjFW8Oc83T3PdKSLMDNnR43IgHeWHgU8Fe3dDYcaQfGWp7OK3mtBucpG03FDosVxseZQp7ReKF7VxuaaXlX/S5sEVQ2tFycCoIEcFMFfwd76L8+X5r+nRBSzpdn+WW0k/xmO1YB8/VgPIrjrlvyCgmB/e4Uzv230w3n6QYpGZbiP+JAH6jKYXgKQ8z90aBDh3UXwuXluB7Y2E19igCEasnf7ZAiHt/9zAKGzKmEhATB+L2sbxlEmBNV8+vaFRGrdAvf28wUfOEaMzLAmZv3dETbd
 YYoGIn8S
 S/2pJxJChU9qoa7Pzk5+COIxx9xy9MR6aN9Q/Yc5tcW2W0kMq6FbRxovVsZ/W6Dr04x2F92hZVy/uaqKJCW1fuL7Fy9M7r04ZXNYQpr3XIwRmmAZpWtfxWxklo5jb9CRPuFX3KTRQQSkjIwDLgEaWEUvyTbnsRiHvr5iFn2g9Gsteb5Oly3vPJr4RcDcTCvGNDtLnj1DIEEfQw9nMzI/3fDvvXAQxChGEVYlVh+Gb203s3xyq5SOyoPkgaV1FmYQxTKrhft7V1oJ7quXxwQgSC+8M8pBYlzMgktUL98dvhW+bNTnL1+Dfj/CpK0DD/Eel6C6LUwygC99+5lI53URvfHb6ImWJU2tEW515vUMb14dt5y6grWvmD1MSew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we've made MAP_PRIVATE-mapped /dev/zero mappings truly anonymous, add a
VMA userland test to assert that this is the case and everything is as
we would expect for an anonymous mapping.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/vma/include/dup.h |  1 +
 tools/testing/vma/tests/mmap.c  | 50 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index c5191b9718fd..47a91e35efe5 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -20,6 +20,7 @@ struct task_struct *get_current(void);
 
 #define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
 #define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
+#define MKDEV(ma, mi)	(((ma) << MINORBITS) | (mi))
 
 #define S_IFMT  00170000
 #define S_IFCHR  0020000
diff --git a/tools/testing/vma/tests/mmap.c b/tools/testing/vma/tests/mmap.c
index c85bc000d1cb..b720deb4227d 100644
--- a/tools/testing/vma/tests/mmap.c
+++ b/tools/testing/vma/tests/mmap.c
@@ -45,7 +45,57 @@ static bool test_mmap_region_basic(void)
 	return true;
 }
 
+static int dummy_mmap_prepare(struct vm_area_desc *desc)
+{
+	return 0;
+}
+
+static bool test_pure_anon_dev_zero(void)
+{
+	const vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+			VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT);
+	const struct file_operations f_op = {
+		.mmap_prepare = dummy_mmap_prepare,
+	};
+	struct inode inode = {
+		.i_mode = S_IFCHR,
+		.i_rdev = MKDEV(MEM_MAJOR, DEVZERO_MINOR),
+	};
+	struct file file = {
+		.f_inode = &inode,
+		.f_op = &f_op,
+	};
+	struct mm_struct mm = {};
+	struct vm_area_struct *vma;
+	unsigned long addr;
+	VMA_ITERATOR(vmi, &mm, 0);
+
+	current->mm = &mm;
+
+	/*
+	 * Map a MAP_PRIVATE-/dev/zero mapping at address 0x300000 with a page
+	 * offset of 0x10, which we expect to be reset to the virtual page
+	 * offset.
+	 */
+	addr = __mmap_region(&file, 0x300000, 0x3000, vma_flags, 0x10, NULL);
+	ASSERT_EQ(addr, 0x300000);
+
+	/* Assert that it truly is an anonymous mapping. */
+	vma = vma_lookup(&mm, addr);
+	ASSERT_NE(vma, NULL);
+	ASSERT_TRUE(vma_is_anonymous(vma));
+	ASSERT_EQ(vma->vm_file, NULL);
+	ASSERT_EQ(vma->vm_private_data, NULL);
+	/* Expect virtual page offsets. */
+	ASSERT_EQ(vma->vm_pgoff, 0x300);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0x300);
+
+	cleanup_mm(&mm, &vmi);
+	return true;
+}
+
 static void run_mmap_tests(int *num_tests, int *num_fail)
 {
 	TEST(mmap_region_basic);
+	TEST(pure_anon_dev_zero);
 }

-- 
2.55.0


