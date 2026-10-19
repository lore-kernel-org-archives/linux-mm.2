Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2650CCF2E5
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFF676B00EE; Mon, 19 Oct 2026 10:28:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0AA6B00EF; Mon, 19 Oct 2026 10:28:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C6CD6B00F0; Mon, 19 Oct 2026 10:28:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DDB76B00EE
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:28:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F3D12806FD
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:28:35 +0000 (UTC)
X-FDA: 85339606590.05.6DF3472
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1E5844000C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:28:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R0tceiBT;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792420114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=a0eu8oJCqbVdCYPiFjU8ZN1euvr9n6L7NmwFCs6qrSo=;
	b=WDXObwLBKRmRheSDysq+yux4bUpPWQpfsA3cbYR8OJ6ESJw7Ys8xXNJRzDflD+FzZCMxCO
	PfNb0yxanUEW5/cJzOnDyYk1/g7zAA3syR1Khy6zjtTGMEkcF/ZJESzT/5sciM/iySDZna
	arznKb7YZ7MltrLw2SfBj03ajE8H7Sk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792420114;
	b=iXtoDtKJbIqiDqtIAsC7ruOhI0W7gQ+0bGdIvqAIfJ0Nzb+nDObe3cwSZZb3+dJVji0Ucl
	0dISPAwfGoX9JnYTAkxRCjpTz7b5afKdoIRd4bvtmE5b82auKbPMpo7sRn00r8sLB+Zqqf
	6w2WlHJ85jDrtTttitNQXzir3FoSGog=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R0tceiBT;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44DC643AB4;
	Mon, 19 Oct 2026 14:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A281F000CB;
	Mon, 19 Oct 2026 14:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792420113;
	bh=a0eu8oJCqbVdCYPiFjU8ZN1euvr9n6L7NmwFCs6qrSo=;
	h=From:Date:Subject:To:Cc;
	b=R0tceiBTdz93YJdfHeH8pZUiTkWguzroOhkkNnGd4l02iujB4nuCLY6w7JpjZAQli
	 tNRk1jPdbOUxETxdoint4A+ivorhOlzSfkVh0iOq4DiRYiDgo9b4C971SNl657Txpv
	 /eU/p8GtkpyL+1c1nLliUW6yRKn9Q8myCatKat4igI2Ulgq2g160ubptBeMz+uz1Nr
	 HVb/RYaJcu0mdiiH1UHYx2Jn9SPjO5Y85XcbxpPMKFzW0KHNgyV+CewXhQWKXBokxR
	 EBfuBaX0Z2A9z7fFDEs+2NPKK6ZvoEo3sJ/w6VjTVGBwC/ZpuR4KHyPc+Hg303h3aM
	 tobUBwbRV+VFA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 19 Oct 2026 15:28:27 +0100
Subject: [PATCH] mm/mremap: populate calculated fields in vrm state
 correctly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-mremap-fix-shrink-charge-v1-1-a3ce209e5360@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3M0QpAQBCF4VfRXJvaWSJeRS4Wg0mWZktK3t3k8
 q/vnAcSq3CCNntA+ZIkR7SgPINxDXFhlMkavPMVOWpwV97DibPcmFaVuKE5NTdw2bjgC6KpBpu
 fyob+665/3w9JyZs/agAAAA==
X-Change-ID: 20261019-mremap-fix-shrink-charge-be490a2311d7
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
 "Liam R. Howlett" <liam@infradead.org>, stable@vger.kernel.org, 
 Nickolai Zeldovich <nickolai@csail.mit.edu>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3473; i=ljs@kernel.org;
 h=from:subject:message-id; bh=1KwnnSydsrMowhW6/UrPI5beylcA0+sO0VKAeZUDuRc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKuafKsWPJgxxzPY3+XHFw5Q3ZZjFanlDxPwJ+ilX2ZP
 R1nJ7If6ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEnl9g+J+azVxxzaNamMPJ
 u3R6bLbNv8wdrxTlmlf2vly099XKr/oM/yN/XSzlbWm0MLG8ulvixdb0ppvcyg//Rngsfv59sZu
 CPisA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1E5844000C
X-Stat-Signature: 9drtwm4kp8wdhxsa31i587119mufj9fn
X-Rspam-User: 
X-HE-Tag: 1792420113-221547
X-HE-Meta: U2FsdGVkX18TYhZuL5hVEvdZvnXy9B5GGD2DstW6AaDFFXAMqFJDnHyLLU6wuQQX4mLm6hwaTf+ZtXHu4tvqEpye4gkKuFFAq2zO5ENZlH640AoW/CqlQcz5VpTszzPsIoBRipFM0qfCE8PH23pV9mVJRXujb9HmKj39vGtWXhU8VWHR58ZWMXpF/oWM6EqUQJk6UCd/MAau87uztdWiWb3DUk42044cuVlsVvOuU+Ot/BTkmAzj4y+ter6b859AwxUTboAZGrcjCNuJS4Z02GOYCajOPIuUV6LbUCylmhzG6vJlwWaKNJnbhDrBsU1Dhrlf1YEBdUhp2h/WxKZ0936u9BHjEvXhALgY9HjL/vfxu1uykJ21g+FvlJ4TfplPj7JalT3x5gF4RgoEPEsNM3bKA5YWbrt3r7X2QPy7grYfFHLcdsyH/RTIhC55sw6NxNxlhFZswM5wrHbfxZwIfTwAPSclYrLiflLj4rwNJBui7E2UMJb5I7fIU8nsxxhyJvvSmJlLQuYWJhqMWCWKshT6qUPt74m6n5bgKWKbwuFKKc+q62wy5TX19eO4eaBqjFjQ7q+NrPUxNuRrf8qQdF4Kwja1MRx1WJG6b6Xz42Rktjyhf2ELxxOpZBr3LQzM35Tx4I7RmiiNwTrucwdJqFc+GphEAwk+c1f0qgsgLlShxDzWj7zWZ2rkpmx37I6rckfA4EyWvMllUjWSp5I0Yn5dTZDrI6u/iO1iz6hUoYKt3g+H7WZUqySh1gVjLWa4U3xPt0bUYfqR1iIgxwq/nHZzEFQpdmqp2GMXaYj9VmNW7eaHAoPBiDR5c+OKfHm0P8oQdawxldGFkZbFUGsBDmbUnPB6U7ebjx8iE+ylhKwk/Hb00so9nd7rHrWTziRb/gyWgJwbVbUiegiqGWGgWeSCGZOlGkOVSjvINZgQQxapZx3bnszj7JdjMbmouGwmsDdGTB/3uiOYCc5ue9C
 jqsGgegI
 QRU9q2ol2Blff9JixGAcz2LPpFr91tEX99JdFbCylKurxqfSXPddJQTSPaSUznTddIDhjPmpgKgi63FiUUSeZAdubLOKXDC/LkS389+zQ4eM1WYNAnhmOMwmemBvwVfRXhzeTMdUb0G7WugFqt9akHEMxWun+Z5DdhHx7v1EC09PnnvvewiRyBvASrtwn5zhwFzotvknZJ2YR/2Btrf/CIAtaafv1f8fhPHpLIPURKqXAE0w2P7f7w3CpOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit d5c8aec0542e ("mm/mremap: initial refactor of move_vma()")
introduced the vma_remap_struct helper to pass state sanely through
mremap() logic.

Part of this state is vrm->delta - equal to the absolute difference between
vrm->old_len and vrm->new_len (the old and new lengths of the VMA,
respectively).

This value is used to correctly charge accounted VMAs.

When shrinking a VMA, mremap_to() sets vrm->old_len equal to vrm->new_len
having performed the shrink of the VMA first, prior to any potential
move (e.g. MREMAP_FIXED | MREMAP_MAYMOVE specified).

However it does not recalculate vrm->delta, which results in incorrectly
overcharging the VMA.

The charge leaks to Committed_AS globally, meaning a mischievous user can
cause allocations to fail across the system in strict overcommit mode.

Resolve the issue by abstracting the update of vrm->delta to
vrm_populate_calculated() and invoking this from mremap_to() when
vrm->old_len is changed.

Additionally, update vrm->remap_type whose value depends on
vrm->delta. The field is not read again after the shrink, but it is the
logically correct thing to do and protects against future changes which
break this.

Fixes: d5c8aec0542e ("mm/mremap: initial refactor of move_vma()")
Cc: stable@vger.kernel.org
Reported-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Closes: https://lore.kernel.org/all/20261017233527.797191-1-nickolai@csail.mit.edu/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/mremap.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 6970783fc445..24827e13e617 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -887,12 +887,6 @@ unsigned long move_page_tables(struct pagetable_move_control *pmc)
 	return pmc_progress(pmc);
 }
 
-/* Set vrm->delta to the difference in VMA size specified by user. */
-static void vrm_set_delta(struct vma_remap_struct *vrm)
-{
-	vrm->delta = abs_diff(vrm->old_len, vrm->new_len);
-}
-
 /* Determine what kind of remap this is - shrink, expand or no resize at all. */
 static enum mremap_type vrm_remap_type(struct vma_remap_struct *vrm)
 {
@@ -905,6 +899,13 @@ static enum mremap_type vrm_remap_type(struct vma_remap_struct *vrm)
 	return MREMAP_EXPAND;
 }
 
+/* Populate calculated fields. */
+static void vrm_populate_calculated(struct vma_remap_struct *vrm)
+{
+	vrm->delta = abs_diff(vrm->old_len, vrm->new_len);
+	vrm->remap_type = vrm_remap_type(vrm);
+}
+
 /*
  * When moving a VMA to vrm->new_adr, does this result in the new and old VMAs
  * overlapping?
@@ -1523,6 +1524,7 @@ static unsigned long mremap_to(struct vma_remap_struct *vrm)
 
 		/* Set up for the move now shrink has been executed. */
 		vrm->old_len = vrm->new_len;
+		vrm_populate_calculated(vrm);
 	}
 
 	/* MREMAP_DONTUNMAP expands by old_len since old_len == new_len */
@@ -1795,8 +1797,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 	if (vma_is_hugetlb(vma) && !align_hugetlb(vrm))
 		return -EINVAL;
 
-	vrm_set_delta(vrm);
-	vrm->remap_type = vrm_remap_type(vrm);
+	vrm_populate_calculated(vrm);
 	/* For convenience, we set new_addr even if VMA won't move. */
 	if (!vrm_implies_new_addr(vrm))
 		vrm->new_addr = addr;

---
base-commit: 4dbe24720eb3811563cd56b35d87ddf3f9beed2a
change-id: 20261019-mremap-fix-shrink-charge-be490a2311d7

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


