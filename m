Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8512CC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 11:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7822A6B0088; Fri, 28 Aug 2026 07:20:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 732636B0092; Fri, 28 Aug 2026 07:20:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6229E6B0095; Fri, 28 Aug 2026 07:20:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4003F6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:20:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60EB9160308
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:20:57 +0000 (UTC)
X-FDA: 85150436154.25.370E33A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 86C081C0007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:20:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oxZKMQwU;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787916055;
	b=gUqAV0KefKEaC3iHHz4fg4J0JWA47Zkk6oHSsfUyt9Xz6ZIqhz+ANrX7SdFJ+Stbm8+fjj
	EpFvYcSLyhgxht7XEDT420qlMzEtPOIDireSSuMExsexBm87N6UxK32lPGMotUMKEeFwQ3
	VdupQysQdAMQ0xUnfi45BC1ITGwSRuo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oxZKMQwU;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787916055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/pc6re8PSjo9zjwKnd2Zf7CA9PyDezj2GQ4G0IaICR4=;
	b=WqbB/6pSunoUHcg/Hb7XKyW/5/GMtR9ScYAzJ1QIgdDxvFFs8CRMTa619g3sIA//uC9u/u
	0OlOWDae6i+Xc6BL/6ssDBUH/2oBpYCLs2OCSH6+5Cj+Y3yfnolXUkKSARqQ5VryYfMSWy
	zvg052GpyhMwPOJJvuhPF+dOVsE/e0Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 53D56410A4;
	Fri, 28 Aug 2026 11:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2AC1F000E9;
	Fri, 28 Aug 2026 11:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787916054;
	bh=/pc6re8PSjo9zjwKnd2Zf7CA9PyDezj2GQ4G0IaICR4=;
	h=From:Date:Subject:To:Cc;
	b=oxZKMQwUK484geEAy0aRc/4rxzyuz1n99jKBDpSjxzvpmmMVllFFQjHFwzBiCd5di
	 U4oS4gipBZEoqN5loE3X2wthQFOvzlrWGoySsd60wzig4xcNhTfAHNqIjqkhBHWgOK
	 8w4mW9sQOkR5v9D01d4HOqHpXl48fDwt+tsbh9lepHIwFpCYXcukQQdnWyP1zMqAG/
	 z6iIiY7sSOWCz+ruPEkNhFwqs4k0t8HNQcIqAfqtdvj268U7XZSspPoZ0U2GCoSdQn
	 qR4YLb5oVjOIxgPTQ/6qho0o13PXwNuNnJuV3+ud5ty5xXtThV8BS2CG4mTa3apBZc
	 EG/zhX/VXGG+g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 28 Aug 2026 12:20:37 +0100
Subject: [PATCH] mm/mremap: account mm->locked_vm correctly for
 MREMAP_DONTUNMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260828-mremap-fix-locked-vm-v1-1-c80be7505d1e@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQqAIBAAvxJ7biElwvpKdDBbaylLFCQQ/550H
 JiZDJECU4SpyRAoceTnriDaBsyh752Qt8ogOzl0Sip0gZz2aPnF6zEnbZgcrmochbWmF0pATX2
 gKvzbeSnlA71oK+RmAAAA
X-Change-ID: 20260828-mremap-fix-locked-vm-b8991ffc4181
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 sashiko-bot <sashiko-bot@kernel.org>, Kunwu Chan <kunwu.chan@gmail.com>, 
 stable@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2839; i=ljs@kernel.org;
 h=from:subject:message-id; bh=MPZihmBDJp3NmShFBO9v65wDHg8y158TzBgEEqykUB0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIm5gucmiU3z/fgPv3a9oQrPHM/dDz+ftbxgGd5rvlkx
 sC0ZxpcHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhIvjEjw6VjDzZvPmMzYbex
 LpPXD67JCp9a18z9VN7Rpfegbeq2Q1MZ/qfwvDAKmOvmuuultKL0rpN3379PTTwY/Vv5cdOKsFY
 jMR4A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: d8fm9kxkbhypku637xu7npj53qrtossu
X-Rspamd-Queue-Id: 86C081C0007
X-Rspamd-Server: rspam06
X-HE-Tag: 1787916055-323831
X-HE-Meta: U2FsdGVkX1/uJNPMge1Vm49WFC1O0v8H07oRIPgAhf5fC9bD+Tf83OGKSNxHjpaI7qdRn4VZlP1EzfJs2KlM7Y1IpfYSCq0FovS8z7ghCwg7W1amO9yyt+TXh7bUuwGTBtEpJkM5wmS1hRnZA/3xYR30bxFinbGWX/1jMn5/LMQUZuk7nQl0kiTGgW/5oWJJNvcTQIsBnioHHLt4CA0PfIB+ubYKUpf6m40oRBplj7gicKN4xj7ZvpYN0RalzMvqVn7w4xifoYJLIbrY5tz8ZyJfX746JUgTpwVhhHc+MulSd1fTH5yHe+uJS5FpviSjFcVgG9Adv8d1AT9U045+rvcVdIV9RN5S0HMJp9jbBVRVoRK0i6f0AkGpjy7Xs3KqBY1GEk/BO5zyZ5dLBb1rebzmO46R5H3hUBz8e8fDVJvlYM9Xfv2XRr+6DTXzSIhcqZOn00OvDvSwcYLXhTwfk2SH5NXItnjcCOxgPyN/WI8IXhOLdQT5/bPpGyqJAgo9oKVLIMDPh2/mqpr+Bn7vp852L3YSUAY9GObJuHQeQCLMcrnlw/vR3YyC4Uz5MmTHGhUqcZFf9EeIkd79Qc1pCoCLzsWkKfjUkYbhetUIOeoZnSPBVu8eGeTerov0drWrS7mht4E91N+1c3SaAV3wYs2QqnzO2cNub1hajV14v6avLcboQ2mA0lqHqL/a6MBeZb7qUWaLNgNhC8UgaGewsJcI1TayQBuo+eUytwD1/ToCrPdukxHYMvTdQ3mQ8/PJC7/9yILvBhUkbF0lBZ7xqHR4+qHZy/y1wC1xtE1IHHIZThchum9yhZWqlLj6YEQj8tYI/Vgpl0KWQYvJHhmfDDNfmp0ZTnZOx4kHo766nXTTwsY2b+GOWQgKnG7urEoH9F41o9cIJUrQHySz1EuYUD93SacWN8bME+q87TKyWZb/Ozy8Dq56Cu4gcG4R5l9qiCIo5aFiMgAvaxivijX
 c9r8omOs
 jNqM/9diAYcJSI6qMbhOeF0zasLDNGvsRXwCB+E+hVSH1OAKfEmki0a/RhzD3RkVCbHGyNkUpV0SNRH9khpG+oqHzMuRE7zXzcvPQgaOITeJbV9UEwJZH9WaDLl7oMpO/nFDGUoows97jUu0q/ALMKRjNdyOueGybVmiJjwDNR4nlzqM3sl0lDi6V0lUa7YiQBy1gYdkbTdZbRxfyg7N26Ml3XNHFlui1TIqjHITnkYTUqo2km0UWgHYZ54Y+7OtHqlUcSfLVzumbmDdS+rYhIG+sXcFzCCX5qRYYbf+a31AoFgmT+ILzC8SnjQlQ4dM+10VxKLJN1nDQAStjr6cNchMMQxj3zvKvBFpIwJuKsSxIq4za/2n2EBCkjP0rqXiY7CRiUQgaKNpVT3xEcvLnU1rNwQck6tDNCrtyTJLamM6lUUs0StK5VroQ0pMT8BcBbHNz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a VMA is mremap()'d with MREMAP_DONTUNMAP set, that results in the VMA
being copied, but the source VMA not being unmapped.

If the VMA is mlock()'d this is a legal operation, though the source VMA
has its VMA_LOCKED_BIT cleared.

However this is done in dontunmap_complete(), after mm->locked_vm was
incremented via vrm_stat_account(), resulting in double-counting.

Worse, this is not even corrected when source VMA is unmapped, due to
the VMA_LOCKED_BIT flag having been cleared.

This all works fine in the usual mremap() case (without MREMAP_DONTUNMAP),
as the source VMA is unmapped with VMA_LOCKED_BIT intact, at which time
mm->locked_vm is decremented accordingly.

Resolve the issue by invoking vrm_stat_account() only after
dontunmap_complete() has run.

Note that MREMAP_DONTUNMAP requires old_len == new_len, so no need to
account for a delta in size in this case.

The bug was introduced by commit b714ccb02a76 ("mm/mremap: complete
refactor of move_vma()") which incorrectly reordered the accounting and the
clearing of the VMA_LOCKED_BIT flag.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org
Reported-by: Kunwu Chan <kunwu.chan@gmail.com>
Closes: https://lore.kernel.org/all/20260828094823.594279-1-kunwu.chan@linux.dev/
Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/mremap.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 2b4b523a86b8..7c368440fafe 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1355,12 +1355,11 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
 		if (vma_is_anonymous(vma) && !vma->vm_file)
 			vma_set_pgoff(vma, pgoff_unfaulted);
 	}
-
-	/* Because we won't unmap we don't need to touch locked_vm. */
 }
 
 static unsigned long move_vma(struct vma_remap_struct *vrm)
 {
+	const bool is_dontunmap = vrm->flags & MREMAP_DONTUNMAP;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *new_vma;
 	unsigned long hiwater_vm;
@@ -1401,10 +1400,10 @@ static unsigned long move_vma(struct vma_remap_struct *vrm)
 	 */
 	hiwater_vm = mm->hiwater_vm;
 
-	vrm_stat_account(vrm, vrm->new_len);
-	if (unlikely(!err && (vrm->flags & MREMAP_DONTUNMAP)))
+	if (unlikely(is_dontunmap && !err))
 		dontunmap_complete(vrm, new_vma);
-	else
+	vrm_stat_account(vrm, vrm->new_len);
+	if (!is_dontunmap || err)
 		unmap_source_vma(vrm);
 
 	mm->hiwater_vm = hiwater_vm;

---
base-commit: aeddb4d52acfcc5ce5e988acd48f2906fe966ca3
change-id: 20260828-mremap-fix-locked-vm-b8991ffc4181

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


