Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB4F606A32E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 13:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dfqKVI6g
Received: by kanga.kvack.org (Postfix)
	id 17E0A6B036F; Fri, 23 Oct 2026 09:48:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155FF6B0372; Fri, 23 Oct 2026 09:48:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0938C6B0374; Fri, 23 Oct 2026 09:48:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE6786B036F
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 09:48:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6270E803D6
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:48:04 +0000 (UTC)
X-FDA: 85354019688.25.A398856
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 91249140009
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:48:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dfqKVI6g;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792763282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DjY0J1rY8s6eI0pi00146/qxLG5XIFRaa8H6rSeRSdI=;
	b=FbEnlkdh5r1L6ebCPqiNLbvBMDe7RHR+KaNEfmyPVLq/nC0tlDD4tgsjqBi5h1kLEMMhb1
	sEXAtzXeNo6tQ4mFPn7lNFb/ESSoLYQZbHoS4YG/VyhZ4S6YLsg1GFyFcYLzwF9PMl7b0m
	bOL/asWLWnEuQ+aGgpNEVI5VWDBVq60=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dfqKVI6g;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792763282;
	b=PWMZoCmtN3ypXFCJz4wcD+EF0KYDGAfT5SOzaxgYd3CDbL/TDAFOTmo+R2n7FtsSuyDaH0
	Du0xP3gOXQY8ZkyTpcRRJduWrf5fWAwMWDii1iJjC4HkMR0b3byDHpUKJJgt82Z1gVuFu4
	M/GNVZzdrCZ2X++rVc3n5Y8VG+dr5/c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D73B344452;
	Fri, 23 Oct 2026 13:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E311F031E1;
	Fri, 23 Oct 2026 13:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792763281;
	bh=DjY0J1rY8s6eI0pi00146/qxLG5XIFRaa8H6rSeRSdI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dfqKVI6giPzt5zbodp+Y1rpDLUD/m3efycWZdeUMPGiIL7r5+EnNhAsnZJ5ftfgo7
	 Cien+WUpFTsX+Uvqev3Z7aqzdnx1iXRYPHn5ZfYwDzI1SY0IBLtpUV1LGL20y7e+fp
	 7vtGVZh5y+n9V4m6Vfy2RbW/ErwbMmvcFmOCEQa8ItSKJBZREYjLj9Be23Oq67oaJx
	 NH/Y4GI346SxjhQckJ18s/BSiXQVHtFP/TXTtZp1HiIgNcoHz4e2L+0AJHiFBAIAob
	 F9QyxgcB91Bw7/EQ3JJ6GD9ijywRpjS+93OHzjDqXBw4AgE7d6Y7JcY8iEJxP66SaP
	 LaSiL8GJz7WLw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 23 Oct 2026 14:47:28 +0100
Subject: [PATCH 2/4] mm/vma: write lock source VMA before duplicating it in
 __split_vma()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261023-fix-vma-atomic-v1-2-8ff4fae1fc85@kernel.org>
References: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
In-Reply-To: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Davidlohr Bueso <dave@stgolabs.net>, 
 SJ Park <sj@kernel.org>, Kees Cook <kees@kernel.org>, 
 Colin Cross <ccross@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2019; i=ljs@kernel.org;
 h=from:subject:message-id; bh=pBDKonRJs5TA7YWHg4RHbXCo1gcPUiIEkJW4rM9Bgss=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJup7ZwnTcrklmpLv+v7b5ZTk5rgu3W38Kusn8WXX+/P
 +DA96yYjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzk52GGvwI27BPt4hz1fVt+
 GIvef1ex+25XdOuMn8UV36YvjTrWIM7I8NIhpL7vNP/EEvbTHnKC/83mnWg2v2t7j23qWYOY0zu
 XcAAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 91249140009
X-Stat-Signature: 3y1muxyyysgbckb465ug1t73joi36xu5
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792763282-13047
X-HE-Meta: U2FsdGVkX1/3pacwXd6GnsRweEpPREI5wuknCnLYbe7eqouqvcGQxzxEyNcWDjONUh4L/CnorfLkL82AX7XG5GkYVs5YUj+EJOy1jB5PQHGaIQH8m/HT7iVs/RnnF4KfFdr7qbBFSNS7JWKCkPWXu1ygsTRFUh6XRU06Se6jlZG5zNZghP5yk7sARaneepitCPlDFTVA7mRw4K7QcXK2kL4rySb99f+I4V99tUAFy9WoJ4YOxILxrvaoEHAo2migkxt2YI9rWFSHQNj7OhWFSzE+OKEN+SwYyo0Bj2DsatNInUPViruAVgG1PFcbDTO5DlOHH8OeV7lZyFM9lNztlOw3+Z0+Dpi9322AWBx2oh0SDGvroJQmm1krFfLNN03uieDCDLvHf5oXFquAQg1vu+pJHKaZZ2Ve0FDyxmuQ0PUIbpxQ2chyZqh+voTU7LqG4UH9HFpROQ00uE60ITX+pvKcS29wbISD7upmyUpvXGlqDYhFLOMCuUsi6yHhbJh2E7toI745HxBEp2b0JLdsFRGK75T1lQ7heL0pO1O8GvpIBV6rmZJJv5edKHcILld8FbFQ7FMplk+JbjMcmPLruDfYlZW4seFGQlCyAQoLz/R/tCIJ5ynhtG3wT3sHR7jwG7yoalki6xRDbivShFN+TvYD81A4zGg2nkR29zU/XOArIbY45+HIr4Hy5d8KkL2FyDtIr7t9Yh/q6wrLyUywjgX5V3aFwzH2pAbZKoq2R1BsJ4Ib4vR3D3wr6MIJFiwj37iH5+GJmpUReVeBFL7ASa9mb4fGd9UelBc764IIczM6rw4rG71exdYsgmxC0Oj0yoaIb6c2s27K1UerNDE/DYmXTrVgZyzN7SYWroaTOOFgEMpLZ76MW5z212+rXZiX6WpACtNFxHeZUIHL4fTVX66qVfHxtDDDFSlkZLeLER2JO9ksymeN7qnj1pqRhGODtAiKFT3NwPjpE92ZRRL
 cln6GSmB
 ipi4pKVO0oipv677ZH4vPYcTKbDWSLVPb+2Rt3QeP1e0zSlIqBC6Cp+1b/cummAFeHW/IxFTTRik3tKaR+tMxR1MMNiwDcbjPUfjC1aKTQ/A+yTmh+meIiwLbOIneMuwzCrYmYIgOwT0+Z7pyYFXXY6gAYFy5jmpDoFZfSzMyMofHWA97qlUqwCUMOHW/Q3DDPrKWUY+5bS0JNB+qkxTMEwZOUqsCIqxc2Ig+To5DergI1T7+wQtexqKpVitCt2829NCWawrdWZ+xv2DMV94woPjMpvRIlfpZJULU1Md6rDxg7VXduAwAByse2OJYoyO/HruUQ2DL9a88CvQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "David Hildenbrand (Arm)" <david@kernel.org>

__split_vma() duplicates the source VMA before taking its VMA write lock,
and until the VMA is write-locked, a concurrent thread might set
VMA_MAYBE_GUARD_BIT, resulting in the duplication missing the flag.

If this happens, then fork may fail to duplicate guard markers and, if a
file-backed mapping, THP collapse may also discard the markers.

Resolve this by taking the VMA write lock before vm_area_dup() and, since
all callers of vm_area_dup() now hold the VMA write lock, assert that this
is the case there, and add a comment to explain why it's needed.

Fixes: 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove under VMA lock")
Cc: <stable@vger.kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
[ ljs - add VMA write assert in vm_area_dup(), commit message touchup ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c      | 2 +-
 mm/vma_init.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/vma.c b/mm/vma.c
index 1be613044b4a..aa59005e2f42 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -538,6 +538,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 			return err;
 	}
 
+	vma_start_write(vma);
 	new = vm_area_dup(vma);
 	if (!new)
 		return -ENOMEM;
@@ -568,7 +569,6 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
 
-	vma_start_write(vma);
 	vma_start_write(new);
 
 	init_vma_prep(&vp, vma);
diff --git a/mm/vma_init.c b/mm/vma_init.c
index baa7e82f47e3..d661f229a734 100644
--- a/mm/vma_init.c
+++ b/mm/vma_init.c
@@ -127,6 +127,9 @@ struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig)
 {
 	struct vm_area_struct *new = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 
+	/* Must hold a write lock to stabilise atomic VMA flags. */
+	vma_assert_write_locked(orig);
+
 	if (!new)
 		return NULL;
 

-- 
2.56.0


