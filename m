Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FECFC4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:41:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 407EE6B00DC; Mon, 20 Jul 2026 10:41:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DFD66B00DD; Mon, 20 Jul 2026 10:41:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 281026B00DE; Mon, 20 Jul 2026 10:41:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB6E46B00DC
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:41:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7AE531A0184
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:41:19 +0000 (UTC)
X-FDA: 85009417878.18.23D3134
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B3A8F14000F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:41:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xk2CwfJ8;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784558477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+hgooHeYYaYv/oiqa66MnVBmMzHrm3fz5OuZIxN9Pg=;
	b=hSIna3iGm8q7LUSjoO2Yu/2d1w8SsQ9us5cveVVHcHnZWyhiaiw8qCR4F+9jaVZJVHBrHy
	+dZ6q1DmJ6TfndyquCGfe9NoE8gUZfZ73OXR7bae7jys6KZGaqYEfp2Atfd/GYdxNsDsBl
	tG8PQFEJj2//dAyBy2DZVoAjaPFbiVY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784558477;
	b=IHSkBeR0t3B1BrPp3g5LE2zPx23QBfjF2zoe89f/iP8wEzOHKxTFncvZFT7FOKcsc/4IhU
	1zNv5zeVMxannzx1vd6wz5fdndQxCwsikvPryGT8kjiK37k/E9ZXbii6VhvZULN2u5+jlB
	Vs7Q5Rivd3C+EHRoC7cFSjXg2m7DOzg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xk2CwfJ8;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EE3040960;
	Mon, 20 Jul 2026 14:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2F51F000E9;
	Mon, 20 Jul 2026 14:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784558476;
	bh=Q+hgooHeYYaYv/oiqa66MnVBmMzHrm3fz5OuZIxN9Pg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Xk2CwfJ8HL60DsiwzkTy2dmx4IPJaGvy3clwtXHfOLctb/PRF8MP0UeVkjMrXLpqc
	 X4WS2W9ztgR4zmOxglKsN2/48CgCJRBHJz+cSbkn4tO4QjGaKM+hOEcqKQw0wDRnWT
	 1YUs3hTGnP3EmFHMzbNR4oBE0n2xLUnb6tj8NCpjKgFm16oYCurumYshQqUxynh/4d
	 mbxBldGkcKwB30spX3j5PmyTcJ8UQBYh19Cm1HJ2sVAMTNVNTdn44Lw9deeuDJZv0/
	 +t5EMQKy+EU8TaYggE9ITM6hRmzQNfyNSb6wj0ah73drSYYTUrn74+PvqOFUFb0kSt
	 yOrY8tOVutBqA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 20 Jul 2026 15:38:41 +0100
Subject: [PATCH v2 15/15] tools/testing/selftests/mm: add
 MAP_PRIVATE-/dev/zero merge tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-scalable-cow-virt-pgoff-v2-15-2d549757a76f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4278; i=ljs@kernel.org;
 h=from:subject:message-id; bh=yk0gma+yTZdel+ljE629bRHp848gvZkgeJregd069ZY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLijN7e2KP42mx2UHD46n83TbO3N4hM99A7xOvx7uKNe
 Wn5+TtndZSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiD00ZGVr436T+lTnYI/ak
 hVX305pn4i8W28Q1+z2XUYlY3hn3bC/D/wxL/51db5VPmGhsm7yu7Furo/iUVL5MyQXzWlTV0tf
 u4AcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B3A8F14000F
X-Stat-Signature: d8noqwiictkwkdz67p1dym9mg46ge1m9
X-Rspam-User: 
X-HE-Tag: 1784558477-617210
X-HE-Meta: U2FsdGVkX19jFWlqgguOtNFkzMM+uPIfvYjzqeq+wv+OJsuqvj/KubgCXm89CG1UKFrGpFrzD2oFttVUNGtr06ebAiMYsHWs2ka1tBXSsfMxpTQeSpCgxF4xWKDRcEq3RsgbJPN8ax7fZsOnW1yQyA+cnTJQH9QcIADtXvWzOea5tX9LJZusvDIDOxmL42eX4FzYBRcykJwdS5ZnfBjjxXg1DlstChVfNdKkBLyQ4BDwnpwtorvl296T+RIudF/HtvaY+lYI9LIFbFPiSPgOeV6SOY0yYy03N/PggUVMdgkqbofJBm/J4cxqn+EC9x4+9im6idTMdfREe9fyGt8gLmpucWPbJjWUNhVmscM79upzvp+7ae+yY7nxkfew4QbdPwNcMODRE5OTgrkM6bSnHJTgWnPu4yGqlvVJHxgBIWmGDVFdVHLTenDkIjvaqTCzW4OrsBM/0Q3eeBmxtYOcqjmw9szUlPE1vFj9qZGgh57gyAC0aKaY8w5TXUUWOWAjYROIT94S9YRuTSO2weUJD0yJlhwQw18oLlI0Jlffs50s/zNnbpxZxRPv7vM85nypwQdNskEoaEnFj3MTX7fODBx6nOUwZ8yLMAb56lPdzQ9AMGhUVROZFmlh0v7vCdqJWjI0fTe8hk7QzftIVdk0hKvCjRwxah4QJ391tFP+B2TDzZ2Fxo7hyE2n8jtnNDweHKEOZmGp1TVUnUcFLfCnHRK7Cnq/VaSPzuZMXMUq629EH73mj8ojOKrvQAg6dz1qxAkBiUhXi/UhJSAQTjJd8MAIqvrDCcVpxo288hD2k+Fm9NHRYtYKWIml65aDbPExkaSlHJpjprDTEH23SJ/PB+FTTft7x+zqzAJYwmLotZLAfN4r1WEM8t2nK5HHszk2SsodjyPC80oTENXu1t8vFYxuWjP4FWlHBdXzxcU1ByyhoVE6xp1DqBibiGQUC8PEeeyMSnPFXPZwhLJc6vx
 5Kh+kjJa
 G27LGuwaptrpsjRvGi2fl43zfnWIX12SR15DhoyC8z+uWjZuDQMGTL2d7RXOVt+TXJTCBSvmlpTfMjcoWvOWHMr4WlST0PCuxSZNRDnICIWsrGH8M1S2oJeKLi6UfJhh+YVSCow3CE3/ZyKj8/M0LrmQf1ycbCWyFzCYpOrvwGLPXvS+9CpQUlAuZKvP+twqREn+TJUvzHloo8mMD1s9Lt4AMdof8LgHsv0Cg1MLAERJJ7VOnWHTbZs+X6rzxCj5sgbA+oa9fAy80U0uFQA8eKCim76dv1eMy+0eSyY6rOILj9dOGdxeqU2u0ylkk0y3mjMNGPAqWoinCMQxhc1t4BLO8KdFboVRta7iRew/RxrX2C4+HAu+PBQwBSw==
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


