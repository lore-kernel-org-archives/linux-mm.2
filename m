Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E507C5AC81
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F8EC6B00C6; Thu,  6 Aug 2026 16:28:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A9FF6B00C7; Thu,  6 Aug 2026 16:28:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 373A06B00C8; Thu,  6 Aug 2026 16:28:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0DDB76B00C6
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:28:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 984DAA01FC
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:28:47 +0000 (UTC)
X-FDA: 85071983094.11.D7D816C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BFF9040005
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:28:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YD4TxlIu;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786048125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ay272yfGladg93XZw7/G7XjdroJLmcVvLtXjw10G00=;
	b=nShKsv4+GDUz7pVQQ2/n9z1RoSQuCNa5mX0tSZV47V3dqH7nhDamZ/FqW1XXmfSGePXTvo
	HhLbk3a0+S0gVHCxsMqLdtJYbLYjytFhzAmn2TAnRr3GvPRiKpuMdI0pLtjr4a+fTCbWT8
	ET5YUa9Iuah6bPomINKZRRN2sXCTfog=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786048125;
	b=lVQHRL1WBqD2WLb5PrEz68wZiRSc3/3HXQh6o5R9EpkCNaUE+GyceGMMS/gU2d7ewY9kNM
	S9gJ00ac2X6Mk4IbXL3SkKolf2yctNHrZbdULqj+Hu+j5Z6/iIYh5AdX60yxmIxx5tTQna
	uxb7wMPqXO1CgbNFpi6dUXdOKIMF7hw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YD4TxlIu;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F17A34368A;
	Thu,  6 Aug 2026 20:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4BB1F000E9;
	Thu,  6 Aug 2026 20:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786048124;
	bh=9ay272yfGladg93XZw7/G7XjdroJLmcVvLtXjw10G00=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YD4TxlIuxzp5v5Z0ZTEodCRXT8YGzqpa/pxpaWKPvQtUbMFMXa2a/qwHZ5bHfXywc
	 IURsjSYbpRrj/JgN/dgejv1NKIRo671upsDn0dO++7Ik7SMxy4jn9JKKzsJztBoNi7
	 mr7bcXfaZJidIQLujafYpaoUPrilhim3f91/DZPdrHk1F0X7XnaOrxW7T9CW/GFnh+
	 JznKvb+O6fxZEbJmlRPmnFQjBOmOU/9xv2jvq7CMcblsTvxhJgJ4ih8couGTCweKZZ
	 OJ8rq8uytZHKRS4sc2XXejCQMrK3vTIs3ha3hf1+gr0E4PbfD9E+P8eWtBIYa7GXCO
	 6m1UOvM5fNvDA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 06 Aug 2026 21:21:44 +0100
Subject: [PATCH v4 19/20] tools/testing/vma: add test to assert
 MAP_PRIVATE-/dev/zero is anon
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-scalable-cow-virt-pgoff-v4-19-ab318a350404@kernel.org>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
In-Reply-To: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
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
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>, 
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
 linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2651; i=ljs@kernel.org;
 h=from:subject:message-id; bh=DUhVb18/709QqMXpsBMKsajnvyrOaD/dsQci+RSxB/o=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJK3lxMPHH2k32mEdv5l05HBRk8s5YcP77yGMs873QpJ
 amKzyFXO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRO2cYGW7x7VtwXGHGux2p
 JSIBGxNmLvt/4mREzMsWK8GlNXmVaUsZ/ud/7Q5pO7NsueREbWXFBqlZN7OOfmh8pPT4U+3X33M
 esvABAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: BFF9040005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: r5e5h7gzq4kodu93wc9zpezfzcx9ybrh
X-HE-Tag: 1786048125-203131
X-HE-Meta: U2FsdGVkX1+FaA7wzy4o/Dq2vPn3hbxp41SLI6CJCBnLBNOdw4WyJGllzF5wZhRDmVaLZYG7pzC0anV8QzDniZHV/2u2hNkZ2VWT/QDnq+2ZBkPGhTaD7kLZPGNWeypHXEZPNRwoYEqknvfGxj5xZ8f3Bj2lXPbsFT04zwSAZxIewd4Y4hZKf9TCU1MYOwE5ott+PMwf0mfShsPcPuWvuvYMtWEIzavIIQfQc6IMEALNuBkDFIV2nI+7L+yfZ9YeAd+VLrtOB+lIDxhP9EcplOfYsiFnCdO/baicz/bJuBPAlQbPkQcJQWPyMnvKctZNo/c63hV70XeIsiuxercZzzj2PE6gx4zar3JVYTP5hcixhPZ1HV9JRZ48BY04hmGEfXGTDleo7U3Kvb3GA5zcrHTD/jEm4rC9qneHGl40BCE+YrOApjCeqUtcMvMy3vx8bhLQGr0+u0eAbbcHhRzwkuGbSX9oas2dqtFOAxPv/vMVP/Kby+2KCT4gwfFWsbTJdqNKm946hlVUjna3TtoL58s+sxbsLv2P805EQDoZGWuHi31VAB8ZgWhhZ217lMAjFXy74qUukloGofWbKQBfNmKfwd1ACuta2hrNWPn/UetjULB9PiGBqoPJ57dah92BVd7FGZgE0KB0ngrsksdaB26iNWz5ZYHn8tq4dD74X/E4NNwGC2UTv4ayqgQuxM5xAZO8p67H9YFAyaEHZE9xHfq0jt+CDT4Kr+q/SHXYfdsdZBNOPk0effy766IC/PrcC2ci7ZoXd/g2mysxo8z/XlTRVN7azZWa0uMx28gQHuqeIVkvOZlRBXh33PIjsZToaubFqa7Y0Hgc4A4d70IOJYePsSKbzQ3q6KxPknc1ID1fcPd5Btp5G6TKFDcOzB94IcvPNYrZITOd0nV8adpERoKq26eLM4sy6sMosiDiqLcFqcXJhJwyG5/IGZUWYsdTIUqloyiFXT0huhc2Qy7
 3cwAdSCc
 f9bDbDtdAE5SJ4zxRKxvU63J/bd3GUGhgSyrgTW313wm8IaV5LDuZ3w92wkkplWR05v5MxljRMe6n1yg7UEZCvFc1w2IPuB1aAqYOtqRbjwJ6b8+t5rO295i123vlvdWM0LCa+760n/qPxxBDGd4PMMcrjjpprTrCNiJd43OFzDnHCUNy/y8sHu6HdWbT2UUiHjpg6SXLEw/DrBZtKpYylBZduErwubNN3DQCNri5mvgX4BZZzayhudepP3U/RXwQX5y0RaG0wcatnE+tvPc54wRa/LHMTP0cGs5Rez0vxA57ZKP4Wp8yN4dbVerFj1aK+7D7i06qZA/1DiWcyxIutRvmbRrh9oOwBI5Yt+qcFai/JQi1tmNW8JGmRw==
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
index aee36707abdd..41203b1c2323 100644
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


