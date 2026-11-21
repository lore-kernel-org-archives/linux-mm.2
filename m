Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A30D1606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 16:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OflyxjEh
Received: by kanga.kvack.org (Postfix)
	id AF0726B05B9; Sat, 21 Nov 2026 11:03:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC8AE6B05BA; Sat, 21 Nov 2026 11:03:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DDA96B05BB; Sat, 21 Nov 2026 11:03:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AFCB6B05B9
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:03:44 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6EE416053A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:03:43 +0000 (UTC)
X-FDA: 85459596726.30.9EA8D1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 026C540005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:03:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OflyxjEh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795277022;
	b=TKil8k3sz6OlqOPZM9rbqwerfoeZr2T7ntpQzJuLyEC4/OuUHiIncQL3hvPLtaemPfkQOS
	Q864KxNpsClJfH1T5E2nhemsKyVkAc5FzOFmt6MBABDLudQ5cahX0g5V5xP76t66G0uYMk
	Q4Vh0szkWi71p69x/hhQwqWx+iMIgu8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795277022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+C9l+IS7SCxPcSHtzeCDE4TxFlpud6Kg+iAbboFgMPs=;
	b=w2Ae0t17hegW5qFBqWO6NDdrqYYfjrPSDFNHwqoqH2P0oljO7H4ZrCoW8pDh8a0x2I7mL1
	b5794eZan8kJorFaWcQbiMgXCiJkQmBjHEG8dc3tGpwRdV630vmw6qlhzkBvsHLceuoCPg
	8fGutx6EaT1n6tvW9zMZH3X5rC7E4fs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OflyxjEh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D8FC43872;
	Sat, 21 Nov 2026 16:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE49E1F000C4;
	Sat, 21 Nov 2026 16:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795277021;
	bh=+C9l+IS7SCxPcSHtzeCDE4TxFlpud6Kg+iAbboFgMPs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OflyxjEhoD0voCnNCY2R4mds+3ZOkH1KDw1OHvIBpX7XBt8KynH5tr+nm8jt49Ghb
	 Bm9B6MvN3DhyFx/reQttoZW5upnQ5lvbQKTOh+Dqt2M9lb10xyOTI4bI9lbRz0DcN7
	 zs21McIaO1VBXKcQgDPu9rEfWhU7unsQXE+KMBb20r+kTYbZNyisZw8K3XY7Gz+zQt
	 CPOdbOMwp17PxlU/HZrLW9K8RRFLS1EBzPNDhfKzt2+W/0XBwT4z3I6eCcFACiW26q
	 2EzDsXttSK4pv9ihhDuY4rA98g+k+MhZxiuyy9TOXYpo5dhy7HX7/GyTzibWRnsfsR
	 55PQ3x1aIrESQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 21 Nov 2026 16:02:31 +0000
Subject: [PATCH 5/7] mm/mremap: apply the mmap() offset limits on expansion
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261121-some-more-ai-fixes-v1-5-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, 
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3113; i=ljs@kernel.org;
 h=from:subject:message-id; bh=xSyHxzLxvrEBvMH92UdZdyEHtxwSf4VUzODUn24kk2w=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIZD2wPe/IvvkVZ3OyvcOL8yLWGMYF83nuDn+WdjzT5a
 cKsHKTeUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIn4rGZkuLD8SQu3kt7505qV
 xh7Hl8k8+Rhsrarnt+nBz+sMd1P1Mxj+O7ZJ7zqblJytsv7+3jPez75w8p/y2Hfg+Su7xENT7z9
 34gQA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 026C540005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: qyzrzgqzw518um7owqejjk5j39rqbrux
X-HE-Tag: 1795277021-476951
X-HE-Meta: U2FsdGVkX1/Q9WzVLduUXyqTO/EREDbZEF/8ZT2Ogjqzq219AjLK3xzKzWAqtV3ljFobFHHbgp4foRH4JeNBusphlsMULiwf+77HdWxrXTS3ApsUkDF0L6mCjR1sFnxzUTvsJduk46I1kPADezfANy0Z3U7Ndpk3nPXHEv/y5xLxioey5TJALrX8kiEdIfDL25+yGrnEo1eCD2emYUhgBX5oedzIEA0lvClOI03GIoaCaOVozvx3pbM7ZPcj0TYD9H4nRq6oolWcStK6UFVhupBBnedc/d6+q7IyeNvaaOdMsuUMOat47+dqr6qO4Ux3Fae6Yr2D0MZg3RirHePs2elEFNLcbuS2PQG2PYcOZ1klNlSkV800QWARJLChu2hczXfHVlhJiXAdMM+qkBw6cEg/W9fEJR5QE6uj8k++ppKBNSbs4Z7XSXlgJjAd8q6dm201ub1z3ky8amMkZKIGyva0IyPoWs4k3mP81LM7ZjCykLKrugRI5uRz9uEBYZzFs0i/n0jeBvngV2OfPu0OzYTAgAIrVxSS30K9VxsAfQXcHS7EcHI0c7QfjQXq3tt9NaUb30FbMAxMf3+nlNAuvrmytXBY81TDAIho+CBxMwCFI7RkgHvhQHu1kMjAIHboN4boFFmYfnNEGakKRuPufdTtqNE6OUYgDexpOahgbLjEzLl1VrgHPhyL8p5ceM55Sugbd9Mh4bu9CSWfipVB0eEOW+hYHhIAyzlQlsqH+NM//pwg/OINjd3SuU2/3Um8JGQCo4pASm9lAJRVdzcCh0o+9TkCrW7HBQwS0OByGWx8cjIF5odpsXOztlXUKfBN4GnSIZMNWxxq0lFminqep5Rn1mC/o6oIKwRMtmHMRrzvX2vWSD9K8zJLftK+OVozcyuR9XNOhV8jRYA5ChqKPtFkPuweJX/QqNy6tAh/rcFDzt2NIqDQiRHb6mXqVbPuG8xuUIgIvh9VRR+U5UN
 ML15k0yf
 gpqO43xb3K4x36ylNZGQMn5GAhszsFsHBwhCimXiB+MkPnj06XgkKuYsEyuiQvePFwOTkS/blY99wx55m7Cryh3+9UhtJ896VTSMKUIWt4PKk+klUivTgLJIbh2ldhJagHGAwSx1cbmV/lAeXpSE2cBaDxsJOaA+iLPzLz0Vlddbf1INQfRQYf5XsM0A+5OW49+BLZm2MpcLvORd0dJ7a77+7hG4yr0SjMN6jQ7T/yzc8kCSAG9mAMjFY+ZRgS4cJGV3/mXG5YgcbaISb0FC2LW778hZ5KxWuTrSPLwgY//5amug6wR87etrjDHKxq0jC7OGKEu6DwqWg+rNd/CV4qpD6QNN2dCTL6K3GjMn0ryggbHycPoXKoKc/YTQ5ZeoC8oy4UJhcM45E7co9vSWL2foFbnZ32ZLqBf9OkXG03WXmUyiyxOSaEst3W9x2Np9chsmxdDmnYo2CUBNu1pj6wByITUBZT278+vzoN9fiaippm6Z0jzRSD7kzFGP+/Y+jF9JS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

Commit be83bbf80682 ("mmap: introduce sane default mmap limits") made
do_mmap() reject file mappings which extend beyond the maximum offset the
file can support, via file_mmap_ok().

However mremap() can expand a file mapping and only checks that the page
offset does not wrap, so a mapping can be grown past the limit that mmap()
would have enforced.

Fault handlers rely on that limit. For instance dax_iomap_pte_fault()
converts vmf->pgoff into a loff_t, which overflows for such an offset and
defeats its i_size check.

Fix the issue by applying file_mmap_ok() to the expanded range in
check_prep_vma(), failing the mremap() with -EINVAL if it exceeds the
limit.

This means that mremap() now refuses expansions it previously permitted,
however no file can have data at these offsets, and mmap() already refuses
the equivalent mapping.

Fixes: be83bbf80682 ("mmap: introduce sane default mmap limits")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Mason <mason@kernel.org>
[ ljs: fixed up commit msg ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h | 2 ++
 mm/mmap.c     | 4 ++--
 mm/mremap.c   | 6 ++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index a09dbdfd615d..aa7fba0a1c41 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -941,6 +941,8 @@ extern long faultin_page_range(struct mm_struct *mm, unsigned long start,
 		unsigned long end, bool write, int *locked);
 bool mlock_future_ok(const struct mm_struct *mm, bool is_vma_locked,
 		unsigned long bytes);
+bool file_mmap_ok(struct file *file, struct inode *inode, unsigned long pgoff,
+		  unsigned long len);
 
 /*
  * NOTE: This function can't tell whether the folio is "fully mapped" in the
diff --git a/mm/mmap.c b/mm/mmap.c
index 7618e72766a5..79702841c06c 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -264,8 +264,8 @@ static inline u64 file_mmap_size_max(struct file *file, struct inode *inode)
 	return ULONG_MAX;
 }
 
-static inline bool file_mmap_ok(struct file *file, struct inode *inode,
-				unsigned long pgoff, unsigned long len)
+bool file_mmap_ok(struct file *file, struct inode *inode, unsigned long pgoff,
+		  unsigned long len)
 {
 	u64 maxsize = file_mmap_size_max(file, inode);
 
diff --git a/mm/mremap.c b/mm/mremap.c
index fff0465f5e06..8043c425b5df 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1791,6 +1791,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 	struct mm_struct *mm = current->mm;
 	unsigned long addr = vrm->addr;
 	unsigned long old_len, new_len, pgoff;
+	struct file *file;
 
 	if (!vma)
 		return -EFAULT;
@@ -1870,6 +1871,11 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 	if (vma_is_fixed_mapping(vma))
 		return -EFAULT;
 
+	/* The expanded range must obey the same offset limits as mmap(). */
+	file = vma->vm_file;
+	if (file && !file_mmap_ok(file, file_inode(file), pgoff, new_len))
+		return -EINVAL;
+
 	if (!mlock_future_ok(mm, vma_test(vma, VMA_LOCKED_BIT), vrm->delta))
 		return -EAGAIN;
 

-- 
2.56.0


