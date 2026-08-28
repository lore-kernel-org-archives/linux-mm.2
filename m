Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD7D7C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 22:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3156B008C; Fri, 28 Aug 2026 18:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1846F6B0092; Fri, 28 Aug 2026 18:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 073F06B0095; Fri, 28 Aug 2026 18:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D30B56B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:26:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B6B8D1A053C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 22:26:51 +0000 (UTC)
X-FDA: 85152114222.23.F1FC27C
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf10.hostedemail.com (Postfix) with ESMTP id 15477C0008
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 22:26:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o1g7lEk0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3KAuSagoKCOEMWKRXJKWRQJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jthoughton.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3KAuSagoKCOEMWKRXJKWRQJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787956010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2hySmi/S0MNUtUUZ5XQrsRwLdmYAgAagHNThvawMZTs=;
	b=MmpFzjRyh1LVvDfEroWt052aWodoj05HmTBk3eB7e8ztEZrSFtjkTqP1cU6Bg/9vRXHade
	Eol53cwaWym5SezmlnPY/YD3hfoE/xoYZ8ql/y27sg1mlV/orq1YKckZx8y3nRSy//v+6e
	Q+ofe9BkaYxZ989RCF5YB/ghW3OpoDc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787956010;
	b=FqJ0kNTd7dCRUhC4QhAOp+r6xUmVlvp3EVxlhX8+HVeTDORjJbrF5dA1ybM9aCVYhNLzeg
	idE8a+OBxqOU/DLjDpLNM0SttjnqMEH5DQbb7xGydO1Sm0k02aW6Nc9MOgm6QV1Gx+lI1O
	OX+wPjO0Wr0s6oXHyBlbo8yU/EIxbpA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=o1g7lEk0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3KAuSagoKCOEMWKRXJKWRQJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jthoughton.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3KAuSagoKCOEMWKRXJKWRQJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--jthoughton.bounces.google.com
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84c4cd31b51so3513499b3a.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787956009; x=1788560809; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2hySmi/S0MNUtUUZ5XQrsRwLdmYAgAagHNThvawMZTs=;
        b=o1g7lEk0NDUvFpzSBU3KNeXCPmNAmiQp1pVxyN05UGEuPzgqjZW7kQAlewKfUvrj+k
         NBrYf0iJvA0kxTYanTMw9AAGxK0lR/T26Mzk+QqUIsaDH0ku46D9yp4Q7zOHsGzmxpT1
         CAswzucDKsVQ55ccM/S9J4ooONIreWJQ+jRbMN5dyWCj96iiEd+58bw8VHhutEV2+P9S
         RG0uEPHjcqnHc3VmEN11XFn6JxJHlbmIcQ0N2E0GaC/jUivFZ4pa4nSl/OokO/1QFLZz
         SS/vfhwwlOSJ/0GV5p3aprUG6Plo3WDmzzx1fme2dKMcUaBYMGJ9EAtWzQ4uDWnteMX9
         PYiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787956009; x=1788560809;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2hySmi/S0MNUtUUZ5XQrsRwLdmYAgAagHNThvawMZTs=;
        b=cxOpvAtieJIl7mE3Kt+xhh75lCoG8oIJ+0aDyhESGizA1yQSB8F9gjQxArZ+GoN+Mr
         Fzdxyr/LrN0Xil8AZig8ddY/q2i8jvjTs65PcfqmrV+JxChRLHx9AZ9Jov7zg6Hv+h+F
         6qZEVsPJEWXCplhmLNwUtyXR68JD93yzgOTmJy9pbqpW4yx7Wix+Mda5SxeZ5IHREQ+3
         3Dib8sCPR5rnK5Bp/lDGK+gOTs/tT1a8JelUsCTjJjr+a8+aTTcxz15v3IbPXwNmdFRs
         lWpo5+i7NPIvF5kE6mof8Tth1wjvoOJjdgYFmaCrLueuxsyTzCsAQfYT47TE6nlRmo0P
         81bA==
X-Forwarded-Encrypted: i=1; AHgh+RrKAxXRQLD1tgtg3MY3KZdx5gwomIaIqMjwbHS67Mrp9XDK4Ym+TE8yJe4bbBUEv+jBM6SQmUgAww==@kvack.org
X-Gm-Message-State: AFuF++lZA7lyc2Iybm4k2Swri9MTs0zL+SIp8Ijr87Be89a5Ofgnd1E3
	ACMFMfRpNXIV6cwGnJhJu2R3F2pV3oHTNY22q60VR3XnQBmEAlgIdqxULUnRNKiTQnla46wkqdA
	a5SkhUinSY1P5E8gRImMi0w==
X-Received: from pfo26.prod.google.com ([2002:a05:6a00:2fa:b0:84a:3b83:9673])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2d0b:b0:851:80de:db56 with SMTP id d2e1a72fcca58-854c892307bmr20792523b3a.13.1787956008574;
 Fri, 28 Aug 2026 15:26:48 -0700 (PDT)
Date: Fri, 28 Aug 2026 22:26:40 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260828222640.1638457-1-jthoughton@google.com>
Subject: [PATCH v2] mm/khugepaged: Don't install PMDs in uffd-minor-registered VMAs
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, liam@infradead.org, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Yang Shi <shy828301@gmail.com>, zokeefe@google.com, 
	hughd@google.com, Kiryl Shutsemau <kas@kernel.org>, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 15477C0008
X-Stat-Signature: p1kwx7kgwwtgbz69ci77eft1urip68d7
X-Rspam-User: 
X-HE-Tag: 1787956009-501908
X-HE-Meta: U2FsdGVkX1+P81S1V/n1SenwYWSqjoyijY2z6RwMX8rciG4DxwSfhGAhfqA576B9OkjadtRZqdD6suZSnV0MZtUSJZun8xQyyUWjYWqYu6YfiwVm+QbdQOqLYhp+E/O6bjpRlZRrA6T+b0OUTNZh3YDRYpioUq1E4ifYOUNtLOSWNpIqRZ6WwpF+Vd98vgnZ2/dlMVuaKAhd7koRO/p1VsIH3gzxGriKDLmHM8fK8Ux3w/6242Z97JQBVCbTMX/bayfqUv4zpWZtxXvPtetw+fHiG2V7BZm1IN9hTiH94sa+P+CHwJhxW2FoO6Ub9nC2fw1GC0yy4Lrj1panenB561QIpBDsYGnoaon/2QwIJOdGe7FNveth8U77iZta1THdgeVHUsjJl9Ap8tESAIHainNjiuiIHFH85U4TakCwSUHllG6rZOYSpZGADXyzuZ2hclJMicitpR338VfRlKrs8YTUwR5lB34ACBH0Is8xGZW5Hzji9QQIhaUGRynXfnJfSylFdiInFrQQ4CQzko8RNbgBe9jOq9dhtPjuw2i9pfYtuWrUKypHDDeSLVqzTXgJpX5mWLor/P2ONj6uKN4816nLk7ysdwx9/X9mvSUpXVvE5tkwoVWJRpbKd5sGJ9tQUubx5hklsdLfsPbQKe7h29iMhSEuSOU3gu7BUBJhw29JqO90A3B7PEH5rF1/DS4WYm6u8MeXLWeHZ5LY3MIz7nsNSsvvh56he/nzd3MHDAAr3LNla8tzLobvKQxADjSL86FSRiHOut8EUrlc2HkMSze8gf9lzqKYWr8+BRArpnQsf0na7jJ3EbnnvL9RPK6DpOkb4FqiTh/3JsFv95mZ/W9bAjuGdrP8uEKE4h1Q6zNpmAtnQoPzx5IcnqIuY20IMHGHPKS0W3Qkn9IpTIKZbiYBuOJJHA+LdSBjzuGWzU1Gr2WZUPcm/eHX7LOdZQZRV0pa1In+grrpHUEQIJv
 Ktq+7khy
 HTKc/TU1rgUwPmAem6g9e9ljbJo/XvG4zvlo8iNvo3r/fsfBX8z9o3nytyMbKD8N2zFSyYXzVrZQYwS0+3gIvkQ5XFvFzwG5CH+J/dl4qs5QjMmYnr95Mdq/ATicHMrjnpasdsHS8g+FepzD3KaVNakUTG1G7eZVlItdA9xrohYsOteiJWu1q55r1avcXv3IAPrSs+gT7s+GF7rOwwGxMC5bn7GGS5haEC0Wa+q0kUfn9X1EupeaRcNW/tdqEKS5hiazyCXnTCSlRnB1iaQGRRAnxlXe5tM6/ky0NrqKACNoCJe9x/6AnXb5tgLHg0ckp3GFYj5zUaRc33JtKp8OWYrM3YIuBt7xnL9Y1qKEAPUowptxXQ5IuP9i+30k5TfU0cgAFL70vuO98CWNVfXMbPuvRwkIuLYUuxOAktUC/ieu1hwbmbnj4Ik9yTH6ETWqFXwV7bWZUinvNOrvF6ORc6nZvrRVjTy/W7a6yzXw4+94n/GrejESS5GwFN8lxhhasbfjogiPYQTWmwwCXTLD2fMlUh6avbbTFlLbL1pbYhPnjnB/r+Wo6weDfKsBt+TlaTpsUZWKmfOoa2ePAERyX3zNF3b3BgnttLcEpoY4Fc5H+nsuO+qdth5UJF2IX15uujM8P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Userfaultfd minor faults provides userspace with the ability to manually
install PTEs with UFFDIO_CONTINUE. Right now, khugepaged collapse can
map holes in the VMA when a naturally-aligned THP is present without
explicit action from userspace.

This is a problem, as it bypasses userfaultfd minor faults that
userspace is expecting to handle.

If userspace implements post-copy live migration using userfaultfd minor
faults, this situation is currently possible:
1. The VMA for guest memory is userfaultfd-minor-registered and nothing
   is mapped in the page tables.
2. A stale copy of a page is present in a naturally-aligned THP (from
   pre-copy live migration).
3. khugepaged collapses the mapping of the THP, installs a PMD.
4. The VM now has access to the stale contents => VM is broken.
5. After installing the correct contents, userspace attempts to map the
   page with UFFDIO_CONTINUE; it gets EEXIST, indicating that something
   unexpectedly mapped the page.

The naturally-aligned THP case is the only case where this is a problem.
khugepaged otherwise requires all PTEs to be present for
userfaultfd-registered VMAs (i.e., max none PTEs is 0), which is
correct. This check is essentially bypassed for naturally-aligned THPs.

No changes are needed for file_backed_vma_is_retractable(), as zapping
PTEs is safe. Userspace must already handle cases where PTEs are zapped
without explicit action (e.g. due to reclaim).

Fixes: 58ac9a8993a1 ("mm/khugepaged: attempt to map file/shmem-backed pte-mapped THPs by pmds")
Cc: <stable@vger.kernel.org> # 6.1
Suggested-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: James Houghton <jthoughton@google.com>
---
v1->v2:
 - Applied Lance's change to move the userfaultfd_minor() check to the
   right place.
 - Suggested-by: and Tested-by: Lance. Thank you!
 - Adjusted the commit description.

v1: https://lore.kernel.org/linux-mm/20260828005004.2870750-1-jthoughton@google.com/
---
 mm/khugepaged.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b237f6e7662a..22356229c1e4 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1899,6 +1899,13 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	if (userfaultfd_protected(vma))
 		return SCAN_PTE_UFFD;
 
+	/*
+	 * Userfaultfd-minor-registered VMAs should not be collapsed, as
+	 * userspace is expecting to explicitly install PTEs.
+	 */
+	if (userfaultfd_minor(vma))
+		return SCAN_PTE_UFFD;
+
 	folio = filemap_lock_folio(vma->vm_file->f_mapping,
 			       linear_page_index(vma, haddr));
 	if (IS_ERR(folio))

base-commit: 26260251022fbc2f248a3d747a9b2b961b18d2d8
-- 
2.55.0.897.gb25b4bd76c-goog


