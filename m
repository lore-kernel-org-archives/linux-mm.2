Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6CCF1099B4F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F3196B0125; Fri, 20 Mar 2026 18:40:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CA8B6B0128; Fri, 20 Mar 2026 18:40:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B9DA6B0129; Fri, 20 Mar 2026 18:40:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE8156B0125
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C12031A0423
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:25 +0000 (UTC)
X-FDA: 84567911610.11.AC102DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 40D2840002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KUQ4yJnN;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZyonGh3pYuncKNqDG1N1iOelEUZSz6yWkO1vXIE4Hg=;
	b=NhZ7+llAIj/akiVeayxDo7xFWEtArJAz6F9JRLHi2FdeaavtrEaKLsIIp0z/i/CedeqKdC
	oJyYsBVaw3G9Ifp9CbEgTHhhQaZXM2Ohut84yj8GUyq8JIoyNsckDhkPsn48StOMc1Y0LR
	7IDpvMW5heHEJkqB6u0udzrzo2GE2Ic=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046424; a=rsa-sha256;
	cv=none;
	b=Td24dAQml+G2NS4mXSvIuV5Cg+KuIoMYRgxIG870w8XIzpB1P1SL3ullXkh6HJCW/8kMTL
	oIuMoab0pePcW3ob+S6wANsX3G4KrrF++KFg+lJC33iT/V+vChW/GYOx5z5x7byjEIFsxR
	IloTgyCxuU8APHG5EuXk+u3m/LH8h+I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KUQ4yJnN;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BD65B61118;
	Fri, 20 Mar 2026 22:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF76C2BCB0;
	Fri, 20 Mar 2026 22:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046423;
	bh=5B0UudB5t6IvoUSjas4gSsitxv5wljP/xv5/LMRSwMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUQ4yJnN/WuHnEHkwKNXjPL29+3niu71Tepf6T8MO4WkDdogsFLE72V8PeJFDVlF4
	 Bgq2IUCnGX2DqjqxgG9VU/AJ9tvaRvZoXCJ/edOpA2ecyHNMPx/827tzdtxUxlno1b
	 kB/jx2f29BxgqysOfNJm2thngFQSBiZldAHGABhZEbYYZtllNjGAzqunIUk7syMpWE
	 q4F2EYNQ3xjEpxq+z70oW/TZyTdZnIe3eNlH70hr0fh7kvql3+XaNSIzX6J9joDX/J
	 Wo7adkEJHy2wBoh1A0sfY4bHYjqE6KjPrlgSkBE1+cXFhZzg9cVq3BIUNXtQCYbYf7
	 VMR8sVXp9E6aw==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH v4 06/21] mm/vma: remove superfluous map->hold_file_rmap_lock
Date: Fri, 20 Mar 2026 22:39:32 +0000
Message-ID: <42c3fbb701e361a17193ecda0d2dabcc326288a5.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6zpgcyb9o6y97w7iwqnibcayfkpgnx5x
X-Rspam-User: 
X-Rspamd-Queue-Id: 40D2840002
X-Rspamd-Server: rspam12
X-HE-Tag: 1774046424-307914
X-HE-Meta: U2FsdGVkX1/kynFGelSqhjKQ9tJmRZP4cEa1Dz5ysyShBmz/nMBV6GbSvOUaqQ1cW2ul+pQp62H+QmJ7jz06zHVEf1g0H286rPHtfPVPiy5VbDAwki1Gcwpa4RMTr9YQVCgCt18tj2IsqD69G78rqr51A1JBAJxIAIXVq5TVpsrU82QIb2lVBQSUsLSx0Nn6igPixywmqYElxDTRmo1SuniPttd9EXo6avLoyrvKSEZqi6JMLK0Qj6dsrQwU86LmAmbjYUOxJdbGObhhXVraQutSBRvMsjFTkiX0FQxNzKsN7oJrUmGrFzXTGVeHhQT+p/jLP+Colx2uazht5jLVSoh6he1X9qn+OuAfLt/V6zMyuqGx5q82Q8/ekEAuHwb4aKbfH4Pqvn5nIFzykOAybuabjFeO0l6Azoz37zmeaVyZducfnmst1yG4ISBc/IWgbwrqteumtEj+09X4ZSz8VCmG4r/l965aH7Ym4SMIa2LarHChcc9J+ko35Bx1ihm50YRgCaXcotveYoFYZDXwxnM0a6h8Ny5tawIu44g25v04JDetNZs0Ypi23Xa6rYm8CtcXaP2xSx19exLsPSbsvWp1VOqi9HjbcDhNzpPI5MIBzSBe4peuE1aHb26TtXxDhn0qtXI5lYFoNtEZ0gTU0x/A5THkLs4Kn35GdEQ9e1CGxGDrVXzIDweTUymDOJSazgOWXH8Mg/ws759az17isxo/mEs/uWMfKTXR15HAbzg5JfdPLVDMAYrx6pz9+Bh6Rp5vzpR+dKY0slqSluC7bekT6ezVJwH7uxfWSQfwcP5MITj7DhRZoPcgVcJX7law4xexX5oUVLeTCMee5ZQ1gI47T5/cx0H0zJkCyMMwTXgxyxcPPovzGQnUbVfTkCmOd4SsdCUWd/NjYg6sxj7O0mfBC28/x4tkiWHpR4PcRimtCWZFkEr/Pr+XxiJhn0QMSt8aQqXwmTgd29i0+Yz
 9b7fCcBm
 ftGdIEZU0JJUbfaDbZLcn6fOAwDBiuWUFCzBw8+wqwu6sJ5yJqqARaFD6p/3HAsQwgTUDeebFYiXvL4DJxeK8wk3Usjz/atxprCRzfID9WNXATQPbUaD7hMIt8NaIl59zNm03UWWqcgNx3jX168Bs8z8JgCHGs8P+0C/sHPtDoYfk2nh/VbP8IkezYwOjoHJqNYDh0X3Ls0jYH0J+rJBHCkPsmNIPcaungaq7KsgL4SoD5gN/oIdyciy0JUEepqtRQ83xfQUrbQWkqdsevs+dUWfL4dVsz4XL/MacFe+LFXDb/FweOtCuwaMc584b4+12jYpdyZTBK78T7/QA9yXjM7EzW5tFUT9Mev/N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We don't need to reference this field, it's confusing as it duplicates
mmap_action->hide_from_rmap_until_complete, so thread the mmap_action
through to __mmap_new_vma() instead and use the same field consistently.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/vma.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 3fc5fe4f1a7c..6105f54cea61 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -38,8 +38,6 @@ struct mmap_state {
 
 	/* Determine if we can check KSM flags early in mmap() logic. */
 	bool check_ksm_early :1;
-	/* If we map new, hold the file rmap lock on mapping. */
-	bool hold_file_rmap_lock :1;
 	/* If .mmap_prepare changed the file, we don't need to pin. */
 	bool file_doesnt_need_get :1;
 };
@@ -2531,10 +2529,12 @@ static int __mmap_new_file_vma(struct mmap_state *map,
  *
  * @map:  Mapping state.
  * @vmap: Output pointer for the new VMA.
+ * @action: Any mmap_prepare action that is still to complete.
  *
  * Returns: Zero on success, or an error.
  */
-static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
+static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
+	struct mmap_action *action)
 {
 	struct vma_iterator *vmi = map->vmi;
 	int error = 0;
@@ -2583,7 +2583,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
 	vma_start_write(vma);
 	vma_iter_store_new(vmi, vma);
 	map->mm->map_count++;
-	vma_link_file(vma, map->hold_file_rmap_lock);
+	vma_link_file(vma, action->hide_from_rmap_until_complete);
 
 	/*
 	 * vma_merge_new_range() calls khugepaged_enter_vma() too, the below
@@ -2650,8 +2650,6 @@ static int call_action_prepare(struct mmap_state *map,
 	if (err)
 		return err;
 
-	if (desc->action.hide_from_rmap_until_complete)
-		map->hold_file_rmap_lock = true;
 	return 0;
 }
 
@@ -2741,7 +2739,7 @@ static int call_action_complete(struct mmap_state *map,
 	err = mmap_action_complete(vma, action);
 
 	/* If we held the file rmap we need to release it. */
-	if (map->hold_file_rmap_lock) {
+	if (action->hide_from_rmap_until_complete) {
 		struct file *file = vma->vm_file;
 
 		i_mmap_unlock_write(file->f_mapping);
@@ -2795,7 +2793,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 
 	/* ...but if we can't, allocate a new VMA. */
 	if (!vma) {
-		error = __mmap_new_vma(&map, &vma);
+		error = __mmap_new_vma(&map, &vma, &desc.action);
 		if (error)
 			goto unacct_error;
 		allocated_new = true;
-- 
2.53.0


