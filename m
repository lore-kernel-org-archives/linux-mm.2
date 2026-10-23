Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 330DC606A335
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 15:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TSVb0oU/
Received: by kanga.kvack.org (Postfix)
	id 50C806B0B90; Fri, 23 Oct 2026 11:17:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2D16B0B92; Fri, 23 Oct 2026 11:17:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41F916B0B93; Fri, 23 Oct 2026 11:17:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C7176B0B90
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:17:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98811A012D
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:17:43 +0000 (UTC)
X-FDA: 85354245606.13.E4B0A84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id DB916100010
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 15:17:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TSVb0oU/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792768661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9oPHb6UkUAuCeIoTZhGqRaYjHQ33ICgDmbmBczj7A+U=;
	b=urJVBom0UpGgA18zz+qEitsRKUCSsCG0gWGADo0FuqQgstRgQhuqHpeD+7fS583osjMPpD
	5LDKNXx1MYbvKRfeym7rOUazxreqFgZeXKGzAQ8Na3CfgDfAx1Mp+bJl43wbOBn92MH5nJ
	n5Np9n2IRYrWClNG7+rR5nd+chXe/cY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TSVb0oU/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792768661;
	b=aRXexKuyUuJJf0z8yDmMoy1yR86AldpPSX5R6x17lmeH96ZxETazoBwBpYhua/9ml3MkbI
	U1HrPrU3kiiZdF9LvWGbaOiY2+6KSnsQcSZlAbamw8koNoxhBmzaQXW26YOTfnBe0cKMs3
	zHdxG0OJg4J5Bl2g7mP3YvSAy4eM86w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 64AC6601E4;
	Fri, 23 Oct 2026 15:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21221F01825;
	Fri, 23 Oct 2026 15:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792768661;
	bh=9oPHb6UkUAuCeIoTZhGqRaYjHQ33ICgDmbmBczj7A+U=;
	h=From:Date:Subject:To:Cc;
	b=TSVb0oU/0DYQRlWKzFZ1+M5bfA2fsQELDWZJ7ouo4RY+HG3qghgtFgLKhqqlv0q+w
	 jB4rnZVo6YJeBeCxsIDdByS+TqolKBBNMCYKJL+Wg9QpzxNmlkADIdv1OM9cMW1tHj
	 NEkDqxR6G+9DmGSlP6t3axYabc4WyRwFsDEZXaWFkrzSIKa6lA7iKMGvdEcrki9PUz
	 udtcCGV5Bh/Nxzv922razMhC95ZeyqgJwYiGq/txLyPgiMRNd5cUcwquHojkdaeNnP
	 i5CDcxvz+pf1v5NsqSIw++7RgdM3orkRbpc8nrbLZAYqA1uUMQCYkKZe0sp0P26yLa
	 qdbdTKswvKnFQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 23 Oct 2026 16:17:31 +0100
Subject: [PATCH] mm/vma: fix expansion of VMA_MIXEDMAP_BIT VMAs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261023-vma-expansion-fix-v1-1-6142baf1f46b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDAyNj3bLcRN3UioLEPJBK3bTMCl0zCxNjY0tDQ3PzZBMloL6ColSgMNj
 M6NjaWgBsDj5AYwAAAA==
X-Change-ID: 20261023-vma-expansion-fix-6843391177c4
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 =?utf-8?q?Jakub_Mat=C4=9Bna?= <matenajakub@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
 Luiz Capitulino <luizcap@redhat.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3534; i=ljs@kernel.org;
 h=from:subject:message-id; bh=5ZqmiLxzSYfJofiKd8XjWTm3Ne0Gvwb77tpCkLEm588=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJuV/XP8VY5dce4c5ahhBbniy2r97RPebTxewuXi01+y
 XmBsoZ9HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIcxvDP32LqMqwvT8m+k7g
 Dk74+9X2QX6V2JT8hYe0b0Vy87/Tq2H4K+bKsElzzaLlmUa9rDbGspysSwJWbpPzitY1MhWdp1L
 CBAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DB916100010
X-Stat-Signature: xeni6f5ods6eazs6ob17mdw1gardsibw
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792768661-825048
X-HE-Meta: U2FsdGVkX18SrhRSa4Uu5fqelOjKoEcQv2IJreUEpmlhhIaOX60m8GvC3/bYDZNmttg650yp0ymcB1IpSD9bjr7Rk+Ti+UcAPYJ6ijRmQm5/K4JNEOVOWIX3EYN1E4shtA7kny5Kwvf02+y0sMe2ecokYsFFjLL//0QeTi1MjUXQluFaWvOC40hmi2PsXSeKhG9VcMifPMgjP6fihdOTBjbKaa77Dp1oqummJ0t9V+E4Ne6hyzCfciQqzx7WCXC98QT+GcRCR5A1L0FpyghfDyd5BTduQyeXp08Nm43OOPpDQ+J0wwAa53r9TYMDHej09Gu7EXUkH04P6mrQR3qs1Q3cOLkxEehHwCNA1y0/fKWjlM8XdZi/8RjhbsdYj1BjXajK562G9lAJjaC1JopWJPzy0bNt/dvS6cI39cRcvmaQ+aR+NLjKENBL648Oa84iVuPZlH0h2ueelo0VVoEQHY4RzQvYtm+V7OAP/G6p/hBA6pJ2gqo5dZjQluYuMg/ug96ih3Bb96WXpPPaV+Rjp0XeASi9AVOcWid6xlbkespBoH416jX53bEdaTi+P7lME5xPlFgd3w7qJLaKk64LPcHrbJp7E2oeyDka8CqVtI/QncNgQw+7mM2FqlkBeJglH2KSnUtJEa1uFynmvt/nFVn8TuCMGtO3BHPyqRAe1OJv9xY/s3luPzH/mmbZan2Zr8wzUdePiBgjaxxvHyzhqK+MHw4NIP9fOdtsUU7GpPibDuHmUrx/2lGMZFcTUyPlxIK1qkmlByr1C4Veo46VX/QsvjK9aVMT4YSIvV547oklhRruZVoYpbHefEeyXAsgwUXy1rQ1lzDSk3X+3TgkMkPxlN55pDlPzJ7OwcW85Fm5QoQF6jqKm4NfVh56iDlZ1i2MWOohuLIuBuk+oqVm3d29Xf3GeI6P/X9PSk2ZW2iPpM/G/I5kE0kaa/kaReQCcIlHEKZMn2UOO1dTMuN
 TB2yRpEY
 1WB9tfV5wyQpMgvld37aCUqgwIoprqk7CeWYxTkTEdku0R9WKRKdryl5gUAq2e7MIIJcL1+qYoYrOXXNQPYBWqfJOoyNriS241bj4ndEV5LqiXEzIVQvpiXcyt34c7tPCKVZkpr96DYOa33ubtkeACw5xAOv1qmSSLsuQJdgyKJD+cD5P4xe1jbhKp0/iHXqopPx3Mwk4anI6tHUXztyQctFIlrgbIH0z0h5zmChZkQjikg6YC6hP+556PWg3slvSeOtj2/yjkoT9kBPTRX2Y6YuRMbFqjwRMvAEPiIzCgefsn9vq7T7/EKZIEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit ca3d76b0aa80 ("mm: add merging after mremap resize") combined
merging with expansion of mremap()'d VMAs, however it also unintentionally
disallowed the expansion of unmergeable VMAs.

Previously it was possible to expand a mixed mapping which mremap() had
already ensured was a legal expansion.

This is clearly seen in the mremap() logic, as it checks
vma_is_fixed_mapping() to determine legality of an expansion rather than
vma_can_merge().

Additionally, copy_vma() allows for a failed merge to result in a new VMA
being instantiated if MREMAP_MAYMOVE is specified.

However, this is not attempted, as a failure in vma_merge_extend() is
assumed to be an -ENOMEM failure.

Since vma_merge_extend() is used exclusively by mremap() to perform a merge
and/or expansion, resolve the issue by invoking vma_expand() for
unmergeable VMAs there.

Explicitly assert that the VMA is both non-fixed and a mixed mapping.
This provides double insurance against broken changes in future.

Note that khugepaged_enter_vma() (which vma_merge_new_range() runs) is
redundant in this case, as a mixed mapping is not subject to khugepaged.

Also update the VMA userland tests to add a required predicate.

Reported-by: Luiz Capitulino <luizcap@redhat.com>
Closes: https://lore.kernel.org/all/20261023023106.515365-1-luizcap@redhat.com/
Fixes: ca3d76b0aa80 ("mm: add merging after mremap resize")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Confirmed that this fixes the repro and passes mm selftests and the VMA
userland tests.
---
 mm/vma.c                        | 19 ++++++++++++++++---
 tools/testing/vma/include/dup.h |  5 +++++
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 1be613044b4a..88ef92ab24ec 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1851,12 +1851,25 @@ struct vm_area_struct *vma_merge_extend(struct vma_iterator *vmi,
 					struct vm_area_struct *vma,
 					unsigned long delta)
 {
-	VMG_VMA_STATE(vmg, vmi, vma, vma, vma->vm_end, vma->vm_end + delta);
+	const unsigned long start =
+		vma_can_merge(vma) ? vma->vm_end : vma->vm_start;
+	VMG_VMA_STATE(vmg, vmi, vma, vma, start, vma->vm_end + delta);
 
-	vmg.next = vma_iter_next_rewind(vmi, NULL);
 	vmg.middle = NULL; /* We use the VMA to populate VMG fields only. */
 
-	return vma_merge_new_range(&vmg);
+	if (vma_can_merge(vma)) {
+		vmg.next = vma_iter_next_rewind(vmi, NULL);
+		return vma_merge_new_range(&vmg);
+	}
+
+	/* Mixed mappings are permitted to be expanded, not merged. */
+	VM_WARN_ON_ONCE(vma_is_fixed_mapping(vma));
+	VM_WARN_ON_ONCE(!vma_test(vma, VMA_MIXEDMAP_BIT));
+	vma_prev(vmi); /* Reposition to start of VMA. */
+	vmg.target = vma;
+	if (vma_expand(&vmg))
+		return NULL;
+	return vma;
 }
 
 void unlink_file_vma_batch_init(struct unlink_vma_file_batch *vb)
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index f449129ea97a..e0eab4eca998 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1727,3 +1727,8 @@ static inline bool vma_flags_can_merge(const vma_flags_t *flags)
 	 */
 	return !vma_flags_is_hugetlb(flags);
 }
+
+static inline bool vma_can_merge(const struct vm_area_struct *vma)
+{
+	return vma_flags_can_merge(&vma->flags);
+}

---
base-commit: 2bba28e98578de622ef307d00875aa8f8bca3d10
change-id: 20261023-vma-expansion-fix-6843391177c4

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


