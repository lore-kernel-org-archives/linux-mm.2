Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3324DC4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 18:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5EF6B00DF; Fri, 17 Jul 2026 14:24:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19CA06B00E1; Fri, 17 Jul 2026 14:24:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08E5C6B00E2; Fri, 17 Jul 2026 14:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCFA26B00DF
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:24:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59733A0443
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:24:33 +0000 (UTC)
X-FDA: 84999094026.02.0206375
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 862DAC000E
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:24:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=omXE4CsQ;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784312671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+hgooHeYYaYv/oiqa66MnVBmMzHrm3fz5OuZIxN9Pg=;
	b=lDkkAYpXM/bbM0PN8JCPmRjl1hZDudnCm+4ORdWCgsdsB/dyBQIqZWizpzN6xijoM9T5qY
	T3Vs5L2fgKm1Ted8CQRBpmJ1mEe6hP/AFDEE3gDP/nTbpwXLU52/RvCOUg0R7m5FLylGBD
	xgQsIAp7H4MaEjgfeRzGeStp/+84TWQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=omXE4CsQ;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784312671;
	b=YkvxANkhVuGRZz4xxcZ+XoU0FFSXRjJN0ymeU2mje53xTL3NvFbMLpidVnJRZKCk5ksKSm
	LKPSqZhb3z4p1QmUOiccCqdRmYcf4eY9Q9RrgONiGKjrWy+7ls45JInoL0OT/z+XcOhitf
	AOtPBwI5Iron90dOgdh+NSYsKiPWtds=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF23840BDF;
	Fri, 17 Jul 2026 18:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCB71F000E9;
	Fri, 17 Jul 2026 18:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784312670;
	bh=Q+hgooHeYYaYv/oiqa66MnVBmMzHrm3fz5OuZIxN9Pg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=omXE4CsQ2Z64k5LeffWwtnN50HMH1/GHkEgGbyKyF+mXWBnl8u4Ei1dERW0FAekOB
	 zQLtjUZRKIg4sQD1ChlPZUv/HdqV3J9HP4cBFR9GIUVhiUfG50Ij9EbHeruFLhsyOT
	 2LeI0NkUowD1qy9ds0ErFPOqZFEcCPHtNLQ2A12lkujjycPHc+BhEV3ecB3iZIb4rI
	 TMCdXJBdgeyKiCbtMA7pIdPANJrInzPE8TG0Bh03d4R6HLx3I1VDk4BILnb+jg89A5
	 QacXczPre4f19oIX8EhVmBOnv4OL0FXLjd+A+LAIRiOYDXQdLLtEEkAVfAB9/1zmGL
	 9JeWLb0BtKVZA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 19:19:53 +0100
Subject: [PATCH 15/15] tools/testing/selftests/mm: add
 MAP_PRIVATE-/dev/zero merge tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-scalable-cow-virt-pgoff-v1-15-cf24910ef094@kernel.org>
References: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
In-Reply-To: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4278; i=ljs@kernel.org;
 h=from:subject:message-id; bh=yk0gma+yTZdel+ljE629bRHp848gvZkgeJregd069ZY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKiivYVNv2si77OGnzswM/3ItzKPx4dfOBkKvBj1cI75
 ucurbO83lHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJ8FsxMjzZUBtmE/Eifvml
 ncobjFkv3K4I6Ww9zvHr6NL/sqf/1j1kZGjbHRG2r664eP6GNL57BXHqtjtMuvLiW19+mdY/80C
 cJhMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 862DAC000E
X-Stat-Signature: w14dkhihemqsum8qyucxjes15ofw3mri
X-HE-Tag: 1784312671-536082
X-HE-Meta: U2FsdGVkX19JtT7G8MQaDm6A10vpo5v7beR5XNgGRoNpdAlEircQ+MNZsjLxoNse9GCJt8ORQdxgcKryIsloNdK76NChsLzuDq3Tsg1dC12SkxKjJS40ERF0F+hLgwyzgL/kMr2Ke81OMZWXjBAYLXESaQ1EPQexQpA+HXhz6YH6OwFtfeSHeCLBUgiyLP7gj/0UF9o+QIoKFP3QbtwEbZrXFBMXaT10l4qhQ+b1V2ZPdR6HTJadL1SqLTb2Niif2vl6dBgKWGVxFj58/3tDM9YnkvbXpJN0NfF+FuJUZKpYePPa7b9J+XiUqwqbDHEe2y+EKiInequXc0csZupXWXxXB7hMzvZf6j4mWHfGhLbLfAkRr2m+NbGWzlTz2YxhOAR+x1yeu5D8akhIw8Wxrmtz/li1xTuYU6VsjCCJ9+o8bGfqbXubS3rTlBsqyNH88+Au1Qgdxw3o0VNEmI8cYjZV7FDTq5e2AQO8issSa5agGO+k53wk7sCRGVwH5PEQvnNFGiH98tIRH7eOfnWzVCm5uj3zsJQyXPHBMoK6V9KhObjRSeS7lDnSgEuCSv8HC9MrYTZfHGzj18+sU6lbYCMi/qirxHT8vDYl8KJdtr/4kwOMVGCzOlThDa0oYwChSQKbg3k6hFH0HMbtc3H5dFr0QJlD/M/j9MU+YaY2W7lvPsFlpc6mYgH5T+jyHQTtaIcz2WuNQ5mK4tmW/3OJlsPsq9jJkwcn7cO+Drq3IlvdkhqrbTd7BQNA5ovDFRa4NZbx4lJKELuywB9kQtW86iEe8zsemSPra9Pv8wzoPfbFGwwqaPsHYHfcDbnEbqlPHLBWpdWOq5zjiwLqCwQncYxvYJFYPtmxd2+NDB08RQWCwX4SyOhdDys1PeObvnGoHWqUXBzE8ipzdOwMnM7RATFRSXFDj36LxchS3suZDgzwCypPNexwcTSK4n9/ecsTejNhmWUdtdKNCpgwZZH
 YLEPnS0A
 7JMDjdyfHC9d+VL57PipGKmasLwMbA9gYMo56XXR5QiqDwUYE2axR0ZekuHwcQngHRlFJ5AmD748JGQWiJSOktgI7b6GcI3vl/N1yznkhmMY5r4xD544z1D6sGlu4y7BPjK9NrTCN+skBW9I2dWFm9RRlZQ0KIJqRKWogyZOwUAIJdk1H4TIknXizI1MH8ORlYni2uG4AxNnwY2Y93wugIPi4TgHjm2Neu8Fbg15FYjjn748sLU+PXSLOTAgE1kghb0IeGiZxUvMgJUqwGZ74yJMk2yDMEbhVEAPms/2e7RH79evvxAwmSpF69H+RQD2cozZ1iLJtYQ3SGj83w/4r9l4+iMxNZCOEKFr5jWkx3rYwNd3Mp1lwyuJTZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Assert that MAP_PRIVATE-mapped /dev/zero mappings behave like they are
anonymous.

We test both unfaulted and faulted/unfaulted merges - each with the regions
having page offset of 0, which would not merge if the mappings were treated
as if they were file-backed.

With the recent change that makes them behave as pure anonymous mappings,
the merges should succeed as their page offsets are equal to their virtual
page offsets.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/selftests/mm/merge.c | 104 +++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index c093e27d0aea..edfbd39ae58e 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -1362,6 +1362,110 @@ TEST_F(merge, virt_and_page_offset_mismatch_memfd)
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 5 * page_size);
 }
 
+TEST_F(merge, merge_map_private_dev_zero_unfaulted)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	char *ptr, *ptr2;
+	int fd_zero;
+
+	if (access("/dev/zero", F_OK))
+		SKIP(return, "No /dev/zero.");
+	fd_zero = open("/dev/zero", O_RDWR);
+	ASSERT_NE(fd_zero, -1);
+
+	/*
+	 * Map two MAP_PRIVATE-/dev/zero VMAs next to one another with offset 0
+	 * each.
+	 *
+	 * With these being made truly anonymous upon mapping, they will
+	 * merge. If they were file-backed VMAs the page offsets would prevent
+	 * merge:
+	 *
+	 * |-----||------|    |-------------|
+	 * | ptr || ptr2 | -> |     ptr     |
+	 * |-----||------|    |-------------|
+	 */
+	ptr = mmap(carveout, 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
+	if (ptr == MAP_FAILED) {
+		close(fd_zero);
+		ASSERT_TRUE(false);
+	}
+	ptr2 = mmap(&carveout[5 * page_size], 5 * page_size,
+		   PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
+	if (ptr2 == MAP_FAILED) {
+		close(fd_zero);
+		ASSERT_TRUE(false);
+	}
+	close(fd_zero);
+
+	/* Assert that they merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
+}
+
+TEST_F(merge, merge_map_private_dev_zero_faulted_unfaulted)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	char *ptr, *ptr2;
+	int fd_zero;
+
+	if (access("/dev/zero", F_OK))
+		SKIP(return, "No /dev/zero.");
+	fd_zero = open("/dev/zero", O_RDWR);
+	ASSERT_NE(fd_zero, -1);
+
+	/*
+	 * Map a MAP_PRIVATE mapping of /dev/zero with page offset 0, then fault
+	 * it in:
+	 *
+	 * |-------------------------------|
+	 * |           faulted             |
+	 * |-------------------------------|
+	 */
+	ptr = mmap(carveout, 15 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
+	if (ptr == MAP_FAILED) {
+		close(fd_zero);
+		ASSERT_TRUE(false);
+	}
+	memset(ptr, 'x', 15 * page_size);
+
+	/*
+	 * Unmap the middle:
+	 *
+	 * |---------|           |---------|
+	 * | faulted |           | faulted |
+	 * |---------|           |---------|
+	 */
+	ASSERT_EQ(munmap(&ptr[5 * page_size], 5 * page_size), 0);
+
+	/*
+	 * Map in a new unfaulted mapping in the middle with page offset 0 -
+	 * this should merge and would not if it were treated as a file rather
+	 * than pure anon:
+	 *
+	 * |---------|-----------|---------|
+	 * | faulted | unfaulted | faulted |
+	 * |---------|-----------|---------|
+	 */
+	ptr2 = mmap(&carveout[5 * page_size], 5 * page_size,
+		    PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE,
+		    fd_zero, 0);
+	close(fd_zero);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/* Assert that they merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
+}
+
 TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
 {
 	struct procmap_fd *procmap = &self->procmap;

-- 
2.55.0


