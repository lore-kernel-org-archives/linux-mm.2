Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 814C2CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E16D6B0088; Thu, 18 Jun 2026 08:16:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B93D6B008A; Thu, 18 Jun 2026 08:16:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CF106B008C; Thu, 18 Jun 2026 08:16:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 464C06B008A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:16:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B54A21C2F37
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:50:26 +0000 (UTC)
X-FDA: 84892563252.13.EDE1E5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2C85840004
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:50:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YxqGFQBh;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781776225;
	b=i0zWnssIRkmm270AVSCdxNP5RZEk6nYExdIFxR3Outrz9YF73zBFdAJHJOruQ//tUH1v0A
	uUCEdRpzcXIzfifvcrFsJGkxVQzJ35ebNT4NcBUGzsQtSv2hQ5bG8WRfsAP8/zKccsS88f
	KHJLG6UpnjfZPlVPUWY1CGmAoa5Z3QA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YxqGFQBh;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781776225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BWwwCWEs6k8jntGbl6gKaqqrPpfzJ0y/J83NkZ0wKkM=;
	b=FXHXJQ/mckAC0YJAJ73CbVCdOidlDgZJtvzkBA3Itss9bRw6VvOXqOiVHXE+OJ9B/Cw1oe
	OXdSH+00W2ATtBXWH877VnIo5qPMuH8cTRNXVbNZmLd9njHlrz+pSyemR4MC7rOyEUhnWC
	Phgv7ebKdO23T0278mibvIdSpkISBi0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 550D043ED5;
	Thu, 18 Jun 2026 09:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247ED1F000E9;
	Thu, 18 Jun 2026 09:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781776224;
	bh=BWwwCWEs6k8jntGbl6gKaqqrPpfzJ0y/J83NkZ0wKkM=;
	h=From:To:Cc:Subject:Date;
	b=YxqGFQBh9rYaT2yOGmXP+bDnc2URzBXy0IkTpq9liQGs+U9DbtfTzEAtneEcieh5l
	 5x9htkhbdrDnl0Sot0soTd87KwFdwqztJPJJbMdyOE0hdJ82AdXhJXC8z/A9A/ti+W
	 asitA/IUXGo2M9KJvp4rcHC9ETTy9mTHrPFP/qqDcgItj009sK0UThX340K87CyF3x
	 S1h4DThiX8JD4JtJ1Loj/WyZUGt+UuL1M1X+MbH4b6/VCjlssUrEiviMf7M8xqf05i
	 KeZ8eZtbcWMDw7ZMRQA2/7PUgJbRG1Rgq/qFCKUPYNWZb3y8zkoDn1ypTAH90+17X/
	 5T4TIpQVFtB9Q==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	vova tokarev <vladimirelitokarev@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH v2] userfaultfd: prevent registration of special VMAs
Date: Thu, 18 Jun 2026 12:50:17 +0300
Message-ID: <20260618095017.2553004-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2C85840004
X-Rspam-User: 
X-Stat-Signature: ijprd3qm5guyc4qnx5bcsusb4ur4fb7u
X-HE-Tag: 1781776225-526090
X-HE-Meta: U2FsdGVkX1/9cRJSJ1HnSqCpSRakjlWZs2pX4SPE9POe+dfP/PbQ4y0ZhNFfN6SA9VIjEB9yysqUw7GARSAuck7CSQP5fUgAvhENvls2u97x/LEH9iZUFsKfgp9v+dsPqjHrSfK6PTyD9Tx6IFSL+L5MTPDr/BVpo+vKSycrARgU7zlKKz1vYsvTdJnO+4LMvFDfPjRyhn5SwxDy46Y7E2nuxuZuNMYr7AcXDSx6KD1EzUVXWzahNz6yYLPPQikTpHNcirPlLmajoGRk0lwyiJXda7olQsEMnOxAQH+Z3ZZQW5hN2Rd79YRmVxYGTp23uKZ9psXhfbpeSez0qtDTwVBmysSNNHedbgVAsAPwPCUJ344IjbjsY/yrOHAyd890T+Yhe8gb5GfVpXgpWTiJew7QzaJ+4bcen0eN6AXcxOh2OYU6BkRVSiSjvlHhyitvOGRLiuqyGBkH8aT+n2YDQym4TWS/DqBCwzaYSHSNt0dbXKBiuts5m2klZj6bMJG0W+SuuLq/n2bUvOkZBb72gF23nr1KJtInTCENMZyTwud2HMbvh/QAU7RvAe+JdNZlz5QIuuiA6BSc4gDapT3B4MgoGgaouac8WxP6RwB+5z2lj39XNdwJBia5Ly2z6g2p40Qy0eeu/VbcBI/9lVN8urAGkYmlTsWyXFk1QKAEQZ2seFpXWwauK8sJ11oLU3Virqzo5qeo64oMZ1UT0aZ793Ne9TVSlBl8RU3wyutdnW5l+WR4gDEjSJsGDcqouQnmO6vTv68iI9omrZnoY/d/aylVT3gcSRVsg3J2tFIDjhqBvc+Ubh5oCftyeNsgz3y5WtSIihqEvIncTS6VRjk3c8hoIpeUbcopzUORbfpgzk83h2PmOJyeor/m3ZhV0QevSegKAzvrvDxG0d42dLKWJF6LpmrhHB8uD0Jo6tHmv9zDzG7yJlkwrJeEhvG+JviPaLE6wkOBjnrMrpR0PkJ
 CdTErMvd
 GcKFzeW7yfY6B0t0rfraSAO2Q1KgCwHHjI63gN79uwOnl/ek5/aHj44xoVtQOB+pkevPNQ9nLYyqEmnrvtSrmOHYycoQYrpMDZ7mJ07F96EcgRr7ydt6UQTyKifVgzevSyYw6MEPelpJhpGgWsT6ol2ccbsJopaGBbavNNyYAxmX1hM8JgBcPRdM2BCctm/LPJ3kCqm8eFHn1bFzVj1Oc0V8KnLg2GDl36F0Ilkhb4BWK3dSjVtnVs3nxrPmVpxyu+ZPB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Vova Tokarev says:

  userfaultfd allows registration on shadow stack VMAs.  With userfaultfd
  access, you can register on the shadow stack, discard a page ... and
  inject a page with chosen return addresses via UFFDIO_COPY.

Update vma_can_userfault() to reject VM_SHADOW_STACK.

While on it, also reject VM_SPECIAL so that if a driver would implement
vm_uffd_ops, it wouldn't be possible to register special VMAs with
userfaultfd.

Since VM_SPECIAL includes VM_DONTEXPAND which is set but hugetlb,
exclude hugetlb VMAs from the check for VM_SPECIAL.

Reported-by: vova tokarev <vladimirelitokarev@gmail.com>
Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---

v2 changes: 
* reject all VM_SPECIAL except hugetlb

v1: https://lore.kernel.org/all/20260617194059.2529406-1-rppt@kernel.org

 mm/userfaultfd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 246af12bf801..c3adedaaf7d5 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2111,7 +2111,10 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
-	if (vma->vm_flags & VM_DROPPABLE)
+	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
+		return false;
+
+	if (!is_vm_hugetlb_page(vma) && (vma->vm_flags & VM_SPECIAL))
 		return false;
 
 	vm_flags &= __VM_UFFD_FLAGS;

base-commit: e3d8707358ea76b78bdec9928937bb9a797f2c8f
-- 
2.53.0


