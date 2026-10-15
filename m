Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48151CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 17:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 252F36B0088; Thu, 15 Oct 2026 13:06:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202FB6B008A; Thu, 15 Oct 2026 13:06:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8BC6B008C; Thu, 15 Oct 2026 13:06:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB6CB6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:06:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 71696160283
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 17:06:02 +0000 (UTC)
X-FDA: 85325488164.05.03BC0AC
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id B670414000C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 17:06:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HNs3bwCQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=4ncienth@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792083960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=F6mWt9wIVZrB4sjNqoUTGMgCNXO6bXLWh2pklh5yhSU=;
	b=Uqdr8o5TdWn0sNw9pZlFlIcBAP0p4gHwBWukUwOHnyM2IsfzoLULT42rqffTKP32vfQ/U6
	GWPuY4WYriglKauxA7Zcl6hEtN+kRgp0sVB9KWjqKzli0wUsMr74z5c7J+gTn9U7GINA3o
	3I+8Fv6iNy+Qdr888I/K0VG1PuCSx9k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HNs3bwCQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=4ncienth@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792083960;
	b=YVlEcNV/XRVmB1AZOfbyjPkHTqbjciKBLJ/+7I5k/t0E8k7/2h6tLWisT09cfctyhLS4LP
	PTyts8Q50jPUywgECVxmachXJIjFx1DJac6HJYILKwJ4vanSWkGeb6mHQ7AmQp3yZmlPlP
	mlB7OldXYbmjMDrdKw2eztGgIQ833u4=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-85377c8bc96so2576479b3a.3
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792083959; x=1792688759; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=F6mWt9wIVZrB4sjNqoUTGMgCNXO6bXLWh2pklh5yhSU=;
        b=HNs3bwCQ9ldSLV2FrTPXAAdQHHUDgGgBNs4uk454+FDN01OcKyUK/wE1sXVM0AF46O
         LpGs9snAAMc0AR7vLDqqZSQOhI2Dn9SWyHeDMlg3eTagIwjqx5xEATHrUDnkg8fNprdv
         OY20poh3zs0cTucFLDLCJmD63ClH2VDv12Ntema5BcFji3EegZ4KQ2vGtnPVqJQHnSqv
         ic6iifB+ZYsdU3mMWdyaXW6DBuHjAK5/RZuGnt5heHRUC2Y4rvZ9gtG8kD2bmoc91ZIC
         h1EOwHglMc6yVx3tkULXI8mFEy+hQh8oAm9d3qOd8PDStRry2z+ZQX5kMPO+oONnqYy6
         07VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792083959; x=1792688759;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F6mWt9wIVZrB4sjNqoUTGMgCNXO6bXLWh2pklh5yhSU=;
        b=XfrRVjlGc2vqepLXQVr33Uze3NiGy3KSHpqFJInBjMvem0Qy86SnyKxue0VfsC20Px
         5i7Dx2DX/x2iGq4d37AAzzy1uNkVTrADENwG/Y0VJRTEaw47m1g6LII2c6Kyi3o00LwZ
         AGkNMI/cjGaAwbogsceFDl0CGVfeg9Ozyf/UluemXHA3Qerqb2qH7auIg/ZIUYA4A/e7
         KEBtfsVaxyTOuic3dvRGndvSDWHBLblkQlazyF+fJnwMnfO0A/SN3QZJUyFjr/gKHvoH
         DHPgvG1+bgh3FfwsgnDmn2NNTHX9LrmO9zBCwjYEhm9gFVwPOcW0vS9guZllPVUXbG52
         Ybuw==
X-Forwarded-Encrypted: i=1; AKwUvBxc0caFwmmIY8HFlChVqrFMZFiAJy4RioWtUQ7W9CqIjZaUscT1JLsL0ryvWMs+sPA9K1psXtKwuw==@kvack.org
X-Gm-Message-State: AFq9FYIWpFOKPD0kzIGOWM72FKY3ODZTGH4s6d6mO/PadsmpS5pF1U34
	5D+iO6DLDG9ran7ckoRZtVRWPDB2nwM5K+CRGx11h2ztgvezDUtRFxhx
X-Gm-Gg: AYBFou3sg8374hmHfxn2dI0FBsjmbBUogDYhaPGHNoLsiGjjaOdi5sgGLTwIa2mGbhd
	Nn5CXrXZXztBy8fAHSbGXjx9LVQH9HhzxRotqnIlobOW8+94OsPAn085DekfsZLbHIY5w+/gV7u
	R8Je92jgAsMt3GHKhX4JYPkjnBo768hUbYufDqE9nxQOdL2TvLaMkuxcuv9sB1JNA9/GJCnEfqx
	QK2DxVGqzwJwmkdBF3ZVzuLm+OKuuiIkLIqsFhAC8K/g/WJsXZUQM498Gm9XLDJjUsmiMLRTiif
	TY7jOhqi2UjRNxWA8hVVXP/qyqCkf5iY0A31jOBtdBpJkezqrYNrPmeotANlggZ3oDA3VY2YIly
	SPx1ovjB29BS0aXmfoeTGDuRs3dRxFU4/LXQUHTy54JDRJm/KgsDxTDeuEs+s46+uZe3tzXzcce
	nDTRr+L/GJa8/4hFiWzkEklM7AfRDCEd1eJVckXz9BSJ+/2CXqpA5uR6YpiXIzr2MhiNnJMaO/3
	QGpFX8xVdg=
X-Received: by 2002:a05:6a20:431e:b0:3e0:bb59:7fc0 with SMTP id adf61e73a8af0-3e16beb6bf1mr16704479637.52.1792083959380;
        Thu, 15 Oct 2026 10:05:59 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd635c57edbsm1575938a12.15.2026.10.15.10.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 10:05:58 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hugetlb: retry private VMA locking when unmapping folios
Date: Fri, 16 Oct 2026 02:05:51 +0900
Message-ID: <20261015170551.2656546-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B670414000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: mfx7gewixunrh76d8eqw4qfco4bu446h
X-HE-Tag: 1792083960-996962
X-HE-Meta: U2FsdGVkX18h71Ryx3nQ+1uyBXTvJTbB522iw/GJXQWkIwpS30FUBqiUG2TChFsX1T0qy89fdLBycYbrHOJDDiI1elJMuIEbtq9Wvz5BUzk/dpJKMxaly1U2iYxzOakXBbgMyMOw6iPQBF9a4Hv4+1Frm+fzZU+QvfeTI8wDPiRC2q6eSuTGpv6W/BWAqem9t6WJlG7G/Qlp+OTHkf0s5EfzdwWm01N73Vvy8VrbqccBYqYLRZ3X86VLJwgLBj0aT1U9k1ZpCODRzeRbHcN8wWMHSNUqIbTraAJHr70pHHMPNT8BW1Nh263cHudm29ygw/BuDSRYUtg7gVLSGEYYL6KCDbxk4Z+Tu4yA258uI1THHOCwNNlLLeWZ0bk/GyH0TbzAF5F6vl1mS4VqITrdueNCGyuvL42LXxYQvOg3uHu910AqkezwTptsB78vc4s5x1IJjjYXcspiY99MMkH4Js8rjUkcGCwLQ8b8WFXIP+1f3Q3XsJQgh/yeOhCsSfQtebmdoKfdv9t93/MzJWR3Ch0hJOvonTExUq3xcS8syAhxormVh/DzF/NFNLHbkFzIDiP/eQ42ay6fKLcVy5tFXd7A+M3wEOcfRoy7qj5aZ32C+NgxnUnn6VDnMRQGbvOKrgp5Ml1opeFxZBnaAas9q5APvcHyzWg4GuUmeUMZCVnXvP3CWdbuwZ6yzgilxpS+qSAIx6yVlDpBId5UqCAdpNWY5xFaQwAhrWTVKgBLRm/AmOg5KYr2AJOjrl8i7IQAQoOKYlVkaMU8jqQFITbgXh9SSetLk2DWpbu3PFpATz2hd1FAaVjWN4H3m1/yFnuxbys4yLcQvhi2wSn/jnL9bWVWoHW/60vxgnPQVkCsIc8VrSCoAGOJLy4acPosHvRj8K6KZjZwVhfRI9+9u2mFAxUWvb58RCpi1CaD8nPJxTIJRBXVpYulOe2jPfEwzkO2C/4EjFByo0HIiR50wQC
 NyAzW1eH
 eiuYBQxxM5hjnM/f7NA60cftxrkommzNDlmjh3w8hgR5VE2hYQT1CV+xuh/T7i7n5tfmZ2EqaGFFR4i0cYPgVDIU/1dZivb+BaUIthLZW9N5ERceQo4Q2b8POLvkWPdmBd5gD1nyy3rjWTImuMKCLWnJ+LfJOEbUtt0XxtY7+OThjvFIJDdwA1B85/q8pjhTVKKIwhoIgmSyErIeNdujob4xMUE8G2elv5i6S56WttkfQRd3oFoPaFhWKwasvoIYCWFKe3+hK7XX1JV8TL+pMzO9v2xFRGeljoEvMgjBphdSYs2mqjd+HAQ076PY/KmnA5uYOiiEG8NjqSefo3103X5/YNQOfEBPsqS4kBvxLv5nHofvuAPc7qmAGdeAD8vYJRHBwkLnU3Ww2XVeZZ2ZOLeGH9U6RGMnCSEx+pzMKJkNpVaXScV/EJOgbNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_unmap_file_folio() takes a reference to the hugetlb_vma_lock in
vm_private_data when its VMA trylock fails. It then drops i_mmap_rwsem and
waits for the lock in the established order.

That fallback is only valid for VM_MAYSHARE VMAs. Since commit
bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs"), the
trylock can also fail for a private owner VMA. Its vm_private_data contains
resv_map | HPAGE_RESV_OWNER, not a hugetlb_vma_lock. The fallback then
performs a misaligned refcount operation and treats reservation-map list
fields as an rwsem.

Private reservation maps have no stable VMA backpointer. Drop i_mmap_rwsem
and restart the interval-tree walk when their trylock fails. Keep the
referenced fallback for shareable VMAs.

On a system with a pre-provisioned hugepage pool, an unprivileged
reproducer racing mprotect() with hole punching triggered the refcount
warning followed by a general protection fault in rwsem_down_write_slowpath
on v7.3-rc5 and 6.12.111. With this change, a v7.3-rc5 KASAN+LOCKDEP build
completed 1,000 rounds and 64,000 hole punches without a warning, lockdep
report, oops, or panic. The reproducer is available privately on request.

Fixes: bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
---
 fs/hugetlbfs/inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7611a8470ea265..9a676228e2070a 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -402,6 +402,17 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
 			continue;
 
 		if (!hugetlb_vma_trylock_write(vma)) {
+			/*
+			 * The referenced fallback below is specific to the
+			 * hugetlb_vma_lock stored by shareable VMAs.  A private
+			 * owner VMA stores a tagged resv_map pointer here instead.
+			 */
+			if (!(vma->vm_flags & VM_MAYSHARE)) {
+				i_mmap_unlock_write(mapping);
+				cond_resched();
+				i_mmap_lock_write(mapping);
+				goto retry;
+			}
 			vma_lock = vma->vm_private_data;
 			/*
 			 * If we can not get vma lock, we need to drop

base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053

