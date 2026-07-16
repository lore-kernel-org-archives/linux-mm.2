Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60E10C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001316B011D; Thu, 16 Jul 2026 11:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21C06B011F; Thu, 16 Jul 2026 11:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56E26B011E; Thu, 16 Jul 2026 11:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB4326B011C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:02:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECE66401A0
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:43:32 +0000 (UTC)
X-FDA: 84994757064.06.7403391
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3D89720004
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:43:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZndhMEV4;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784209411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Sj/M25oVbH+rWO7PSpE7fI/tkji4kX40FPXf3ZlljY=;
	b=e6jloebTCxWfNk+X7lR4F6hPYCTIAH8aEsKm+muOqnvNR37OrsM1R3DyxxSJZkVVXj6y9Q
	B41YwaNyDXbPfauS5JcKlBR5nKXsL0ZvBgegls02xZKZu34L97Z3eTgU8U4MgDkkU2PGtB
	Qo2frccvy1mhPgNsrs7ERbfAZepVw1Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZndhMEV4;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784209411;
	b=2V9bgHiCZsvzxooe6SLBOWIUxcq74aCKKY9NwneEU0vG02KykoWrqOK6BsAmIv/McjwLTI
	EabTJmlfWMPWP3jFJvZ8F9YaEqoQzr5PKI8n8/L9Em7gZlTtevUMXeCZ+CARr8eMzm8qO6
	NGbOGgSSh47Chjmoe3FxZGjR8f19bB0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BE60A6136C;
	Thu, 16 Jul 2026 13:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0763E1F00A3E;
	Thu, 16 Jul 2026 13:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784209410;
	bh=8Sj/M25oVbH+rWO7PSpE7fI/tkji4kX40FPXf3ZlljY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZndhMEV4yXOR6uNgwH7/Yu7m/bBTKhQxI9l2/KGYfYj3sBtF5tnwNJOTXnwJipmPA
	 VcMu+NnjqrdT+xJ+sH/DN1I7Hcu011RnzjyxWUPZAYD5fvy21omYi/9+FrNp+jmIyX
	 PTm13cGymX6UBlZXC1C2iTYMQGZek5Fz158O9hHJXv654tNbE7QDq6+3AFurFPuVU0
	 OZveC0rkxatzoD8hnNkeh+mC5Tw9nWzVpcz6q8Ds8mcQC9KOfK2rGKaJNakK9hKrzH
	 rHAwyOO4knuImOwmEDflobCq3ftAg6uC/bKphsVJsZBKPkDzM/E6+AtfTGbhPjNk82
	 kNK03QGsCS6CA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 16 Jul 2026 14:43:09 +0100
Subject: [PATCH 1/3] mm/mseal: remove superfluous comments, fix confusion
 around mm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-mseal-fixups-v1-1-3a9609bf041b@kernel.org>
References: <20260716-mseal-fixups-v1-0-3a9609bf041b@kernel.org>
In-Reply-To: <20260716-mseal-fixups-v1-0-3a9609bf041b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3144; i=ljs@kernel.org;
 h=from:subject:message-id; bh=JEKI5OwncHBGRVO2u9xfmyB4w0tHgvkQ1WO1V8Kh+So=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIi7n/M1bye0Ojznz8pYLrszfC+B7v0a8U4D6e9+rp+z
 V5rXquYjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEykrp2RYeOBxUbdL953TMux
 4lW7ELFuo/pJLRZd61AFFj2dmXc9pRn+19kYn4+3OzvhRJ2Fc49jjOh0xxfXRdoW+UlFvdr3/Pt
 3bgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: sqr9edw5jg7w4ngpcday1dxkadhhijyc
X-Rspamd-Queue-Id: 3D89720004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784209411-257356
X-HE-Meta: U2FsdGVkX19vH/ngAGAziCrbRm7vaxdUI7N/S11JGnXoOwzP84sE7YIgtLq6+tzlzK/c6kHt4Q92OPKvmXi2BYj2GMZsgkGOjq+B8tXAwAhkLMwUpquU6+CA8wNIOabTRVpcyWVHZpLL8DzijMoFt5xvXBOGDkCKAxFRj/cDKwsUDLyAnLRymlfNn2KH/WclFcfb8isqJqZTkklcJyRLUdX+KH9QQ6vdht8iZfh9eLOLs1d8JkL1CiviSkYpKGpiRrLQj3Gg/qWWylKZpweedJlKw28LAGHF5MaFHgN/HlMdbB0GOerj87s73p0/HGHsDoq31+hlM1FuEdXbtiHS5S7NOVAcbeJlat99Piqn1CgCrHAuSRBO7JrEd2E5em1+K8NkNWfBc2X25s5AveDZXl9bYqQXgtTtNltzXMwpMsngIrYGBEbtOG77e5qjYYHSxtCUBnZ1VYZ9UGwL1PZD6ZjvB18es3uj8nWytPrFM26bCzbygktWGK4umBT+1yXaTqAkkXii+W5Gqapx3Og2LEIPU7AS7wBGlDbuBVT4t5hcisj/9x492Si+IrSAFn0pfbnD6I5JGSCojd5Vk+HlJniNwvU+K2kqV5gB25uLI8bVGj79yeLDq84sxGaKlPRKjkLotw2HyTT0fkiR0+WRU/KvbNIvhQq9gzoDbU+V7wQ6mAlP4i+OAB3GJv3MSKIyzrsEHr+wf5LNCK+GVmt4YwlXyIu3700fhaO31wgVxPePuJYD9EWih+jH/O/3KWGMvIrwmdPRR+1/wcS05seG8/tNXGI1NQ3ErnxBUVITBMNeekyH4dv23QfbEcgwZ0Hb8Sq06kZHNoDNANfnS9hK57myuUhQDoZtOW1pS7XB3TdQZEVVyQ9R++DInD8qTL730VSk1wU3r+O7xGd8GUMwR+OMDKxO/Q2U6M936cAPczSvuktfYkcahcPV6e9bFYX5xspk5WIK8ZtOWRMoDfo
 1RJhoshB
 ukEx3h7VZUeWl1E/PVfIbEPMCaOZPYj0TSEZGCHJ1ddlnT80cK5SIP33NQwN32Hcs+T4Rou/nd/z0A5D4cgVWhCrrWiC7DhPm0LOaP+BdgikxACb7cCrid8YPslgRMg+mMuTFqPUT4Sae7VtwTEQWMGCDIXA5Xc84A33VS3+Pf32nXFwBSCOmZv6DqdsV1ZN/h3LUuBassA20PnWw0Q73KPo4kR4MUJoINMHmzabbS97++PO0wsKjBjr+5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove comment blocks that don't add value and eliminate any confusion
about whether or not we permit mseal()'ing of remote mm's by explicitly
referencing current->mm consistently.

Also avoid ugly goto by using an else branch.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/mseal.c | 48 ++++++++----------------------------------------
 1 file changed, 8 insertions(+), 40 deletions(-)

diff --git a/mm/mseal.c b/mm/mseal.c
index 9781647483d1..207fea89c61e 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -16,28 +16,7 @@
 #include <linux/sched.h>
 #include "internal.h"
 
-/*
- * mseal() disallows an input range which contain unmapped ranges (VMA holes).
- *
- * It disallows unmapped regions from start to end whether they exist at the
- * start, in the middle, or at the end of the range, or any combination thereof.
- *
- * This is because after sealing a range, there's nothing to stop memory mapping
- * of ranges in the remaining gaps later, meaning that the user might then
- * wrongly consider the entirety of the mseal()'d range to be sealed when it
- * in fact isn't.
- */
-
-/*
- * Does the [start, end) range contain any unmapped memory?
- *
- * We ensure that:
- * - start is part of a valid VMA.
- * - end is part of a valid VMA.
- * - no gap (unallocated memory) exists between start and end.
- */
-static bool range_contains_unmapped(struct mm_struct *mm,
-		unsigned long start, unsigned long end)
+static bool range_contains_unmapped(unsigned long start, unsigned long end)
 {
 	struct vm_area_struct *vma;
 	unsigned long prev_end = start;
@@ -53,11 +32,10 @@ static bool range_contains_unmapped(struct mm_struct *mm,
 	return prev_end < end;
 }
 
-static int mseal_apply(struct mm_struct *mm,
-		unsigned long start, unsigned long end)
+static int mseal_apply(unsigned long start, unsigned long end)
 {
 	struct vm_area_struct *vma, *prev;
-	VMA_ITERATOR(vmi, mm, start);
+	VMA_ITERATOR(vmi, current->mm, start);
 
 	/* We know there are no gaps so this will be non-NULL. */
 	vma = vma_iter_load(&vmi);
@@ -145,7 +123,6 @@ int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 	size_t len;
 	int ret = 0;
 	unsigned long end;
-	struct mm_struct *mm = current->mm;
 
 	/* Verify flags not set. */
 	if (flags)
@@ -167,24 +144,15 @@ int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 	if (end == start)
 		return 0;
 
-	if (mmap_write_lock_killable(mm))
+	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
 
-	if (range_contains_unmapped(mm, start, end)) {
+	if (range_contains_unmapped(start, end))
 		ret = -ENOMEM;
-		goto out;
-	}
-
-	/*
-	 * Second pass, this should success, unless there are errors
-	 * from vma_modify_flags, e.g. merge/split error, or process
-	 * reaching the max supported VMAs, however, those cases shall
-	 * be rare.
-	 */
-	ret = mseal_apply(mm, start, end);
+	else
+		ret = mseal_apply(start, end);
 
-out:
-	mmap_write_unlock(mm);
+	mmap_write_unlock(current->mm);
 	return ret;
 }
 

-- 
2.55.0


