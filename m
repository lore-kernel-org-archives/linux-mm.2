Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 966A0C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 17:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C0656B02C0; Thu, 13 Aug 2026 13:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94B0C6B02C2; Thu, 13 Aug 2026 13:54:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727D66B02C1; Thu, 13 Aug 2026 13:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 369456B02BD
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:54:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B3D6FA23A0
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:35:28 +0000 (UTC)
X-FDA: 85096947936.23.5984A0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id DDED140002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:35:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XNf5Wqev;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786642527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X99YrB4uFf+BkWFFnJLytE8bkb5ZotMsaFUlyvfCIZQ=;
	b=Unrcc1gksVt3dVJSMYxe0yDmy1IrK4LzZHQGd1q+XF+Fb+53nve0NgSgCHq9KK3rooGz3n
	hLIQgUu9tUN/OPIcW1vLRJEjBJJWq9f71Oubs7CvE4/rtrGfMb5FWD4dCPA8p66H8Fjh0h
	bNTv6w55WoU4IrEsrGV0/d6sjNzL1x8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XNf5Wqev;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786642527;
	b=a914IQEPtgJuGMZR73KHtvaDevQ0yugmVk3e0UFLrjMOuI32+Z7k5JJSDJCqNMR3/Zw/SZ
	RsxiRX7yhdDnZPlgjKScC2haiS3xxD4NELrL02O2kd1aUviWhouNBlzFz3dAY0fO7uB3PS
	XqdpCzD3xqwzILB43iDSqNE/Nc/TvtM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B32A4031D;
	Thu, 13 Aug 2026 17:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3501F00A3A;
	Thu, 13 Aug 2026 17:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786642525;
	bh=X99YrB4uFf+BkWFFnJLytE8bkb5ZotMsaFUlyvfCIZQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XNf5WqevkY16a6WJ2U35Q3OHl/tyzB1cz5rTvdXpzbP6zLFiN95i55598rx8OAokr
	 pAt7jjRlHuk9RD+4vZpkMJzcqKLxezgQf77U/kqBSynG0MeCmG1Tvxp9+bvQB+HGzc
	 hpPffbwvYrFa6DyItZpYfJuijUl+Q4SGIE0zvG85wwJq6ybwi1lt09dr3WEblMKiSE
	 gKii5/3FH+zzeUXlpmZtjcBB2kh3UuEN2q/H9PWmVTA2n8k5eafEdV4AzRd6xtju+y
	 aFBZY6bfsuFCQen98b16YCyG8l+tx77HOZ1rqjB/IAIskliMSgfLdMybbLDj5LSRb0
	 mVoJD2PYoWxDA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 13 Aug 2026 18:32:24 +0100
Subject: [PATCH v5 07/16] mm/vma: fix self-merge check in copy_vma()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-b4-scalable-cow-virt-pgoff-v5-7-c21581c0c3c8@kernel.org>
References: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
In-Reply-To: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5550; i=ljs@kernel.org;
 h=from:subject:message-id; bh=iRuXFKdiG3IkLvRnILJFDmJ//0Yv8O86ToLE8ObFySw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJq/6/+/Ep125oQKTu+H/vzcu/edg7UWT2J586dghdq8
 m0CyYxyHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhIfR8jwzbrbNGa5mgTTpnY
 dZzW39vq2y7dS5rWIvdz5lqhFJetXIwMm++YLbCKOdf9y/WU3Yb7O1+d1TDb+iCo9cidqKWPy6a
 xMgIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DDED140002
X-Stat-Signature: kd1n67yir93aoxgw67eqrw9skef6ruy8
X-Rspam-User: 
X-HE-Tag: 1786642526-634904
X-HE-Meta: U2FsdGVkX197pM9wxmPNOqT51odcVDBsGO8D+fM8eNgSmqPoL0lrqI455M7SdCGZyX3hXKpSDRziql5VGYU17ihuduUhxQoJpJ3+oL5FRm2CltfBtgNZW/FsglMkSLF16SZBxBxshaEIVP7CW4zQ2RzjCzMDsSWd1fBlECxeFooMy7tycQ+7bS8ih3T8B1f0BMzSV6hQQmCXCh3V3wocm1pHCKEXuc6soq3eGn/xeOpJXWTxAPdTiGamFDMU6oLereQSb0BQ5C4FjFgTArKK0zpATWdKMTklyPQLtHbfVVHtBB5lGtRuL5Jgzsc9SendZCJUDlTirE/NNlgUMZxwYBgn3APUAHh2U42jbHjGEL/OADHAHB4CiTL28NQsF2D/qp+h1biLGp5qIik1z8lmPiqhjL2lFX4wdJhYTKOT0TFwB5TwzJVSIQKvrhhgq2kD6knNGD81qedaVuzCMPA+VCN5hsdecqmgRulKEL2HFoJtehmQrxb0kNEOsBn43/FoNjIMeHi6IEEccbLo8LTiyw/F68ZXmHPgovdKzOsliv7AbebVpe/gBVP33N1/OWYYs39HzTUd1JVal4Ip4DZA81GqpBBZ3O3z2kbJyqWY6lSQt6hKZUAVxJhee54t1vyKgAnQJUBEQSqHSEq1Mlyii1kXL+Ff8Sp6ScNSYeq/Zi1AZkN+m+u3BTNnXv4mAuCJ3ecdWZI1xJkkQnJkOGxwVPBEfcTW66WHNYmmPMNbI/IvpYwP16SXOTvLB1NdKdqDCZb/6hR5yNi0dCJivfVTkyurV25wdssx70OsdTh+Hda/aMVszzY2gOnvi4+04KaiUUR9TaDYtsJRto/WVmFvAI1KHcxuMRy3YDBNtmPXUZqyZoBfiSQ8v1/BOUuz/RmK0qbxNLWipVWhwf9twal6LlAZiqwhd3dD9Op1N6hSxGyUoW5/P1+MEylg5O8vp4kb6mkVPi2C/Eee2BRQ2mO
 YDM5b4GK
 FYmXjdAyyzL7JJOvRHZPSYtQfPVSNf6g26PsJwGV4JaRjcBU18qrp7/g3MRSzjTIOk3kMZ6CyovIcvsB9gq/vFjxLRaiOMTKS8l/i54gTlJS4sD5MhP4mey/Nl/o2eERJKHQNlqXysaPu7+D3yD50Hg3fNJ9QMt97RNHQ8IITRXB7Ffu5TwUbyjNIfI3M+3C2PB8w1aaCCHd95qgHaF5e2p3hMgcwD1KO+D67Mk/0ePXZylGeu6pEH+GhPcmWS72vWD7TFil1tEAA/VtnSET1sXSuDyW6EPcrULuSmrBfFfwPVz/L3kU+Y6SwKYE97DEtd/OpirCnA5X8SUoVqExQe9L6shJ/xdodmWngueUsgY+Cl/it+zcYYVW/QQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing logic is very confusing so improve things. Firstly rename the
confusing faulted_in_anon_vma variable to can_self_merge and update this
when the page offset is updated.

What is being checked for is a 'self-merge' - that is between the VMA being
remapped and its prior VMA (remember that this is copy_vma() - if a
non-MREMAP_DONTUNMAP remap the original VMA is only removed afterwards).

This can happen if the VMA is moved immediately adjacent to
itself, either before or after it:

		|----------------|----------------|
		|		 |                |
		v		 |		  v
	|...............||---------------||...............|
	|      new      ||      old      ||      new      |
	|...............||---------------||---------------|

In these cases the old VMA is simply expanded to cover the new range.

It is also possible for the move to both self-merge and merge with a prior
VMA if it is placed between a preceding VMA and its old self:

				|---------------|
				|		|
				v		|
	|---------------||...............||---------------|
	|      prev     ||     new       ||     old       |
	|---------------||...............||---------------|

In this case, the old VMA is removed and 'prev' is expanded and replaces
it.

Since copy_vma_and_data() which calls copy_vma() intends to reference the
old VMA after the merge, it must have this pointer updated.

This kind of self-merge is not possible with a succeeding merge, as the
merge always prefers to expand the preceding VMA if possible.

copy_vma() accounts for this by explicitly checking to see if a self-merge
occurred and updating the vmap pointer if so. However it incorrect did so
even for a subsequent merge (this is simply a noop so it had no impact).

So change this to only check for the case which matters - a backwards
merge - and rearrange the parameters to make it clearer we're doing that -
i.e. check new_vma->vm_start < old_vma_start (having already renamed
vma_start to old_vma_start to make it clear this is the previous VMA).

Also update the existing wall-of-text comment to be a lot clearer.

While we're here, replace the VM_BUG_ON_VMA() with a VM_WARN_ON_ONCE_VMA()
and update the VMA userland tests accordingly.

No functional change intended.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c                         | 35 ++++++++++++++++-------------------
 tools/testing/vma/vma_internal.h |  1 +
 2 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index b5bc3eec961c..18c8f2546765 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1911,10 +1911,10 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	bool *need_rmap_locks)
 {
 	struct vm_area_struct *vma = *vmap;
-	unsigned long vma_start = vma->vm_start;
+	unsigned long old_vma_start = vma->vm_start;
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma;
-	bool faulted_in_anon_vma = true;
+	bool can_self_merge = false;
 	VMA_ITERATOR(vmi, mm, addr);
 	VMG_VMA_STATE(vmg, &vmi, NULL, vma, addr, addr + len);
 
@@ -1924,7 +1924,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	 */
 	if (unlikely(vma_is_anonymous(vma) && !vma->anon_vma)) {
 		pgoff = addr >> PAGE_SHIFT;
-		faulted_in_anon_vma = false;
+		can_self_merge = true;
 	}
 
 	/*
@@ -1944,24 +1944,21 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	new_vma = vma_merge_copied_range(&vmg);
 
 	if (new_vma) {
-		/*
-		 * Source vma may have been merged into new_vma
-		 */
-		if (unlikely(vma_start >= new_vma->vm_start &&
-			     vma_start < new_vma->vm_end)) {
+		/* Self-merged and VMA replaced. */
+		if (unlikely(new_vma->vm_start < old_vma_start &&
+			     new_vma->vm_end > old_vma_start)) {
 			/*
-			 * The only way we can get a vma_merge with
-			 * self during an mremap is if the vma hasn't
-			 * been faulted in yet and we were allowed to
-			 * reset the dst vma->vm_pgoff to the
-			 * destination address of the mremap to allow
-			 * the merge to happen. mremap must change the
-			 * vm_pgoff linearity between src and dst vmas
-			 * (in turn preventing a vma_merge) to be
-			 * safe. It is only safe to keep the vm_pgoff
-			 * linear if there are no pages mapped yet.
+			 * The only way a VMA can both self-merge and be
+			 * replaced is if the remap places the new VMA
+			 * immediately prior to its old self ('next') and
+			 * immediately after another VMA ('prev') causing the
+			 * next to be removed and prev to be expanded to cover
+			 * the entire range.
+			 *
+			 * This should only be possible if the page offset was
+			 * updated, i.e. the VMA is unfaulted.
 			 */
-			VM_BUG_ON_VMA(faulted_in_anon_vma, new_vma);
+			VM_WARN_ON_ONCE_VMA(!can_self_merge, new_vma);
 			*vmap = vma = new_vma;
 		}
 		*need_rmap_locks =
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 4f6c5666ac07..8a48b231aa7a 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -53,6 +53,7 @@ typedef __bitwise unsigned int vm_fault_t;
 
 #define VM_WARN_ON(_expr) (WARN_ON(_expr))
 #define VM_WARN_ON_ONCE(_expr) (WARN_ON_ONCE(_expr))
+#define VM_WARN_ON_ONCE_VMA(_expr, _vma) (WARN_ON_ONCE(_expr))
 #define VM_WARN_ON_VMG(_expr, _vmg) (WARN_ON(_expr))
 #define VM_BUG_ON(_expr) (BUG_ON(_expr))
 #define VM_BUG_ON_VMA(_expr, _vma) (BUG_ON(_expr))

-- 
2.55.0


