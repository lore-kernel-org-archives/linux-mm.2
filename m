Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 024C0C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4DA66B00B0; Wed, 29 Jul 2026 12:50:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFCFB6B00B2; Wed, 29 Jul 2026 12:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3EAA6B00B3; Wed, 29 Jul 2026 12:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8F7C6B00B0
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:50:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32ADC160703
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:50:52 +0000 (UTC)
X-FDA: 85042403544.02.8289BFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 60210140004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:50:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mIct7j6h;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785343850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KczwmOEkPfLLbqBnfEvcAyssnLq2RkwLW6Rzj5IDQO0=;
	b=62gA3KaZhNc4eCo/38uEfCEK86WOY6+p5XzZxQ2ygistWOupQ1lbrwFKz1DBKsVHnng3T6
	scwA+l653VFVqs6kUD5brkLM92YoW2wBwyNIf9yW+U+rhyZ7bF3QoMmI/WO5gkLkZnxzkj
	D2zjVo2ZO1BvgV3m24da7k2LhWg7I5k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785343850;
	b=TC/hPEdLAozQbMGIBQzdYK9hF1n4/q358Qb3HqdnJkxUS1LM/59HdmrmekPJ7gGhjxksDh
	o3UOYqEb+e49tazOOVelsqkq1YJC7GH4Vhjetb0spGVGdqrZlCHkCQt1kE/1xIromZc2Ms
	LdK02ZD1VVPrd9Itt640wafBTzw8MEg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mIct7j6h;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ADA324021E;
	Wed, 29 Jul 2026 16:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5759C1F00A3D;
	Wed, 29 Jul 2026 16:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785343849;
	bh=KczwmOEkPfLLbqBnfEvcAyssnLq2RkwLW6Rzj5IDQO0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mIct7j6hBj5KGgO3qOm4HxySF/V1bE5mr+ovPGakDXbD7cNspMw89i504mYM48ICY
	 kfaEh5IUOPmyn6jn9yAL5Y+Lyo9qTCWA/ng0usBgQ+0g6EGRMKPw1mv5NTtuarAQnn
	 j+6BGMLVPyAcfTrOn4CdVrSFAMJbFoJ4EgKGM3Ww/BSvHJnD+jtIg5vgaCdCxTk1jA
	 rIiOeszyx9WXZZRaks4Tfy09vAFQuvSAsayOIHTO1HB+eRN6mcg71b6/RLD5ib80Eq
	 bA1c7UWTpUPk99gnk8uu9TkDD38YlbJz1LLGWoJ9ehT0qnShZ4iPkeFd5eu2yfrfmD
	 Nr/Qun1czJyPQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 29 Jul 2026 17:48:49 +0100
Subject: [PATCH v3 14/15] tools/testing/vma: add test to assert
 MAP_PRIVATE-/dev/zero is anon
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-b4-scalable-cow-virt-pgoff-v3-14-e8ecfefea812@kernel.org>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2651; i=ljs@kernel.org;
 h=from:subject:message-id; bh=LrCX7jlOp0eZY4mbJRb88uMuNt7kQbBaeHu5WfpNvf8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKy9H4yh64/1ySheGNjNctayxu3FB5q//1gPCVqxwQ/X
 56XbrOYO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRG1yMDJ231gqcOZzTMWne
 u+UeM9hMTWoC9/6N7recFOZ54Uqoli0jw24Gvzc3H6et5J1c1VxpUHK+fs31vDKHf5vfasxw/mf
 uzg8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 3g4nnipsojc7sod5ski7fia7beyhqewk
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 60210140004
X-HE-Tag: 1785343850-410875
X-HE-Meta: U2FsdGVkX19f79cTGuW+qvAfO7+k4y12arAj07nZTSIo+Xi8NrFqGO1GEALdoZm2eVET/S6RnSdsp+zBafoFKOV0VdEFMm3JPrGKBtO319wsS7tfFK4poWPYgGFKp1emgaadON7M8yWKUEQ2D0TcvB7aa+5uYnxBgCkskcPkM3vv2kBUfs3IPiNjibh0q8t+i72M4OjryjSFwDg+EzveVvEO78HBgXjaGjgW7+0QOzifVz386q6hAq2uWJtOcJN+qqagiQAOPKiXzviDNHcS8GpPzIMbaGeh+JOWUauH2rc6mWoQpCGyW/oA1bt/orLXHo0NkSQd42cNx0wMwkRK6YRb/4coboszheSSqm7kHfs+fq7q8jDM621A/f/uldqGzoD2+jkHb0x6cgBsVe4GuZgGM24uO8wa4Wbwh/8ULx8G6PN9864a4XtvO7+Mb0kGOGLz+KO7db6te7EjzVN8jnbxDL5n0w+uB9Hqzk338yhXz/O7ZBDAOhth08przN5KT2N33+3daq1GusS0aQfHwjn26pbXYuZcXVeWiNYOgNMlyLj9E9Z3D3eBte6z0pjK4CV0gnShvA/f0cYnA2ReMLDQ8RKgg0ZTLsO5+er4BzkdPOG6zpgC4GWr0fGjpvQx/krMW2cmGyp5AJKTIGkfjxk3KD66z4HTMoOi1dvLo+GuoIHB4E+ZNm+e1/7eLpsUTFL0Ncs/jNmOJkV8ymXptHZ9y1OCVegNRIjGiCedY3kVUKgjTggWd3AmwxrSvvKuz8RVjrnJlID2uTEpg7+QZpYOmHnsR+++nu6BexlltANdkKw1MRWK+bVVL3rROJ5aGSM6dJnkBKNoo1o93o++E63a1ISKSWYuN7/MPVDjnLUZX7bz1XW+/K3wiIzgzKr1LdTCAl9NsphUF9nuKZaHh0iUlEtA0Oh6Ok0KpuFHLQJ1V32pOZB1oYJ8Cf+mDE/yzmHPjQ3N1nGoN63ocI/
 Sy/Qr7Df
 vi4HTTr4p5neFbVQfhzT96+tkGLPeOPt0JirDYp4bFPX0ljoVESD33624/AdKztCT8w0NfrR6tUwIQSni18WOaV4fic2Ko7csFOaagI1nApHxry/M8YOaYqvwWVONXYWTMFdEvgBibt9VZjPIXMv+5ROO/6SUGxdPxDycAGPYROZj3rmU3AEulc7a/Xeu6vzRuFZyIIqLLMzunBQSHp8/JVcFKysOL0gKj2zBHwfAHGuEGWL7cZyCsIqPs7uqdgYP9Zkh5MsRkcejDf5NhBC6ZfCbWPFuaGE0vE8Yny/1GIOwv+IJGkIokF+oh0x9SttYbXLjpynDivOhGyzXG/G5hCRy0qHZ8x8T9u+fbZQNeDZcHieKgJGheEcGCQ==
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
index 556a57c48a75..b595e88ce98a 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -20,6 +20,7 @@ struct task_struct *get_current(void);
 
 #define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
 #define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
+#define MKDEV(ma, mi)	(((ma) << MINORBITS) | (mi))
 
 #define S_IFMT  00170000
 #define S_IFCHR  0020000
diff --git a/tools/testing/vma/tests/mmap.c b/tools/testing/vma/tests/mmap.c
index c85bc000d1cb..ebe01362e530 100644
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
+	 * offset of 0x10, which we expect to be reset to the anonymous page
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
+	/* Expect anonymous page offsets. */
+	ASSERT_EQ(vma->vm_pgoff, 0x300);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0x300);
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


