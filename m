Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32B30C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:40:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280A26B00D3; Mon, 20 Jul 2026 10:40:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 257E76B00D5; Mon, 20 Jul 2026 10:40:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E676B00D6; Mon, 20 Jul 2026 10:40:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DEED06B00D3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:40:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68C7BA0325
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:40:42 +0000 (UTC)
X-FDA: 85009416324.23.6B6924D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id BB6A440009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:40:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DBlFwrbc;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784558440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TVlIRx355t0P5ERcL5Eqs6eD8BqACD3+tbQgzhdx6t4=;
	b=AsqXMWIvFZS4lrP33Uftiu+cvzduIAzpylC4VDaX2Nz5+ytfJ2+K3JGN/jH7alQptX8LSp
	7r0xzYBoGtG6szNjnMFugY8gO9SDqUgeYY5F1mLJVwNjs8hqZnzRsLYS1TspwLbyu2mKS+
	ptXBFkEHAKvk6ow4pmGaWZ/SpOjM/N0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DBlFwrbc;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784558440;
	b=hWsAp5vnuVfts+lBg/oKOD4h2NWVV4BnLduBP8SlHmtRs0+c2H2v2GwH8GLLwodysqzXm4
	DJBCseaBLMVBpIsCEvmDN7bn/NqNo33achbrku0Y+6TXiNw2VbmiZ6kbhJ4B8YNgn5AY+V
	dC0PQhiIzjiGZdtmgRwgp77XyxU+XZA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D98660254;
	Mon, 20 Jul 2026 14:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFCE1F00A3D;
	Mon, 20 Jul 2026 14:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784558439;
	bh=TVlIRx355t0P5ERcL5Eqs6eD8BqACD3+tbQgzhdx6t4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DBlFwrbcQK7NIHiOTWSbYwYx5vuMNdKkZ3yv+rVCQxXAy+IKejV9jI3sTSLGepXFb
	 U3HlKRj2+VM4tWmW6bq5EL3xVNL9Gz3oAKq1pX2/mpBDJ5f9/rANd7OXK1PINS7xWs
	 pvzDzPjpJFjBva2QRIKA13ESwBdRmoa+MF/W43r3mgDSc4mOCVvpS3JPZdPCdAgfXN
	 USioCtYCaOZYrkCSxQmiOqz7XvgLf9awJ2sPjXnqK/fw2Whw2nZ1bk9BXVz9oVcQRG
	 sDBgUuioIcSEVKamGn9uAZQ3OOazJJRM8peS+fTBK8HtpwcA8FDEMZ4iiiKzA/oNb0
	 h50qkc0wSdwPQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 20 Jul 2026 15:38:37 +0100
Subject: [PATCH v2 11/15] tools/testing/selftests/mm: test virtual page
 offset merge behaviour
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-scalable-cow-virt-pgoff-v2-11-2d549757a76f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2961; i=ljs@kernel.org;
 h=from:subject:message-id; bh=01jUabKK64NHmCAfzlhC9tplycbpQo1xdwDkiXe4HZs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLijN6sLZ3ad7Lv8YRNe6fO/TBlWX/cZc++rGIN9Unz9
 /86/COpvqOUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATabrE8E/rV852sxhLh/W1
 UazLN4SzH1nNsO5N3PeCj9MW+Eu79ocx/A8xdszPMt5u8Vt330o7y/cB07dmPte1uNR1IsScg1P
 7Mx8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BB6A440009
X-Stat-Signature: hy3kym67f7g5ccfcsprzie18d95cuw4t
X-HE-Tag: 1784558440-290667
X-HE-Meta: U2FsdGVkX1/wz2CiSny7vZDlw9lRKNswZqQoemwLwmM55L0/fwpT5s0dRVSIC89caecH53FU56bVN/4kzvVcSnUqbnzUwF3fRrWXSsashFfOoe6U/7kWscOHF0Fmd/1C4+lkmb86iVfhlbA6y7LC0W4WzxRZ7/EFl8fbdkXv7u/Zl0/Ny/1XvLd5W0/G0Q5/3dDod4+DemzAI3PQ+5QvxfWyAMGfqiOznPtFxtbWIUJQAsGrhsnqeJpa2frhWXPR3WF+PemX9rJfZU4XahNsnNxBsVObawOwy990DnIU+2ikn3i59ldXLnCNmko//3xUOMr8X+gdr5lkoIh5O5OaYXb1GBq0BuneTuGI1iZKXLbFl7Uc6N/8wOjtbfujBBK67+9fDDp03tbONocILTy5rG/0wDTzJIDe9GCJdD4lJu4X3w3eUunJvcjO1CiRMfw014nmIf6jYDhPn34s+DbNiuGbSahaQQmCtblQEC+JkEhrHecgf797g8ncR017eBphGt7lWbkMe1uFLJXrSVwxE6RjIQK+AAqAOoDkUejnkJzr+ZmoX2Qb6HDvqDBBKLNBhH+ZKy1c9Wlluf1kskXoJcW4oQLrhzvM5Cm2ZuFzlYbzwMyiTsMzi16W7uJcut1NqPeSMbO1k4YwSJ2sh6j2ZdJQefbvSlkm9fgxt5nGcg2ewpRdZjhxNeX2WAiAJnq5jIy6/vW7dtkwSuB2Rl/aAZjlfPyPr1WtUtBWsycuLroMxihYAk29cYluT7kWaBqYERn0ssbi5MokszyzNQUFnBpO9rU95bjftlANgMcC/m14kY7V9dM+zaV4e1qPvtKKNbR+7YYysvmojS5tWaUeFtX224/CHdjmIX0gURcezOTrvco0n0hyRLntIrt7e5EhwGmZ6U4cSATGcNZ5aPwHZoi7COvPaujlZH2BG6fID8ZEmRPUYBTSawLJqm9cyNr/pMWirpGIpIKp0ph91Z1
 zHGm+RJV
 4FjMGF1DYQbeybnNoQTiHaq6FP+mqgtdfw3CIt8KiNW9FcPyjNqxhpVO4383Rh+2bMrf7yklawKeoQpTIbWXGnplJK5lzxgb842BzTxqnAXDjt1Plo7zHkrvk/hmasYu0X7/42X8lnc8frf40/eS3OI6cCvMzzz0+uyvnAq9T9+piUCowjFPHdNoSBVn7PnxkZAOknRSYd1REOYu3sRgg/pDEpLHAIQrgVXfveip1buVqzCpUXGGOagdWSH/Fbl32rNUDTdFTis1ftrNSnpqjnXjusQTVojxV9O6NvrDHAkuG5AALmNx9rLcwZaiVkK1i/rn9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While maintaining virtual page offsets for VMAs has no impact for most
merge cases, it does impact MAP_PRIVATE-mapped file-backed mappings which
happen to have matching page offset but not matching virtual page offset.

Assert this behaviour by attempting to map an unfaulted MAP_PRIVATE-memfd
region with a faulted one with compatible file page offsets but
incompatible virtual page offsets.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/selftests/mm/merge.c | 57 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index 519e5ac02db7..c093e27d0aea 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -1305,6 +1305,63 @@ TEST_F(merge, merge_vmas_with_mseal)
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
 }
 
+TEST_F(merge, virt_and_page_offset_mismatch_memfd)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	char *ptr, *ptr2;
+	int fd;
+
+	/* Create a 10 page memfd descriptor. */
+	fd = memfd_create("virt_page_offset_test", MFD_CLOEXEC);
+	ASSERT_NE(fd, -1);
+	ASSERT_EQ(ftruncate(fd, 10 * page_size), 0);
+
+	/* Map a region using the memfd at page offset 0. */
+	ptr = mmap(carveout, 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_FIXED | MAP_PRIVATE, fd, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	/*
+	 * Map another separately, and fault in, at page offset 5:
+	 *
+	 * |-----------|           |---------|
+	 * | unfaulted |           | faulted |
+	 * |-----------|           |---------|
+	 */
+	ptr2 = mmap(&carveout[10 * page_size], 5 * page_size,
+		    PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE,
+		    fd, 5 * page_size);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	ptr2[0] = 'x';
+
+	/*
+	 * Now move it in place:
+	 *
+	 *                   |----------|
+	 *                   |          |
+	 *                   v          |
+	 * |-----------|           |---------|
+	 * | unfaulted |           | faulted |
+	 * |-----------|           |---------|
+	 *
+	 * Because virtual page offset of the faulted region is now
+	 * &carveout[10 * page_size], despite the two regions being mergeable
+	 * due to file page offset, they are NOT mergeable due to virtual page
+	 * offset.
+	 */
+	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED,
+			  &carveout[5 * page_size]);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/* Assert that they did not merge. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 5 * page_size);
+}
+
 TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
 {
 	struct procmap_fd *procmap = &self->procmap;

-- 
2.55.0


