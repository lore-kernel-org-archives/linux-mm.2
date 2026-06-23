Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0780CCDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 18:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E42626B008C; Tue, 23 Jun 2026 14:20:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF3806B0092; Tue, 23 Jun 2026 14:20:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0B2A6B0093; Tue, 23 Jun 2026 14:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8AB36B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:20:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 240AF1C5AF5
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:20:30 +0000 (UTC)
X-FDA: 84911992620.19.9B751F1
Received: from cae.in-ulm.de (cae.in-ulm.de [217.10.14.231])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3855D20006
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:20:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of lk@c--e.de designates 217.10.14.231 as permitted sender) smtp.mailfrom=lk@c--e.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782238828;
	b=NUXo4C8STwP2e9ZgvGcU8fr6q82jVJW35rtoTJGoBTdTTTzbux6W9ORvD3qovqtlug3Nl/
	bnxciSS/qH4HaO50JRIf1Fg57NNRKKJ4xnyzO6p1InY8jk8uCKYJMrcFTvY7UcfTJL6M0n
	sfYZ9nLB/0wNIerWQ8IkOm7zovtTEfM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782238828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=efqGrB8ETzsh4BM75JuEawgxVYXiuQIPjgC9ZruIEFA=;
	b=0eS4GFa7PnSbkmLWGtOe2CSWrCghbt05iTfg5z1YVoehhw8LoFEHH3A6j32m8/nln5ejlC
	/pE/Z5sXQkNAtmG243U0ccpIWi9GI4sZxA6Oaod/zdwNJQ+WzTTAGfpXlq+j7AdPHKcbXI
	VYK/pAV/U/mWrUB9L1SvhsfFf/xkwS4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of lk@c--e.de designates 217.10.14.231 as permitted sender) smtp.mailfrom=lk@c--e.de;
	dmarc=none
Received: by cae.in-ulm.de (Postfix, from userid 1000)
	id B3C15140033; Tue, 23 Jun 2026 20:20:25 +0200 (CEST)
From: "Christian A. Ehrhardt" <lk@c--e.de>
To: Boris Brezillon <boris.brezillon@collabora.com>,
	dri-devel@lists.freedesktop.org
Cc: "Christian A. Ehrhardt" <lk@c--e.de>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] drm/panthor: Check VMA boundaries for PMD mappings
Date: Tue, 23 Jun 2026 20:19:42 +0200
Message-Id: <20260623181942.1536598-1-lk@c--e.de>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3855D20006
X-Rspam-User: 
X-Stat-Signature: 8be13hkptbohzrpomj3ozr9xrjhj4wtf
X-HE-Tag: 1782238828-376262
X-HE-Meta: U2FsdGVkX1+8WJZ4ExjVUpL5+JmEqmjbzKrYyz6NagD9BbUejplaRwXWP6FALBBAyaqsk9wyIYb9d2Iur/mSjMWUD4SBbhEfxVvvUN4DNgtffuCb007apHtg9/NK/Hzqy/7kV7+SLgAw/VjpJhe6fjwe4gCbFhyqWUBhoN8zZh4hkoQsME0/te/TZey5qVsIHk/yPoV3R0qGnRr/VUkSCHeVJe9nDpnHRGpfJR4BTURRC2sZTpNeXqjMntXsQNxChwcX+z7a6a+uCroTCUHC6b1+7cFLmhImLNmy8Ju3NNqO1ZB0QX0Dl7FYeiDQFLL7aFANut5zjDpQzIVd3pfllc1mpPKdbMNnV3BYJoES6Ewctnp1cZSO1+5jTkoQbaKbnCh60H1On7edfZc9wwv756NnYRTiF0Ae6GPBKmnjxJ7fMxTwI/VC7419zRrHWOe3sJRBTgVJCObgF31AWbZWnQWBLLwZHy8QbXQbPK+exl6aaGs2pCXD7OQE7XChPBOS/NxO+fkmq0DQgjm5QBCkSojLAuj/J2xXqP4IaBi/EEW6YtUzCtqr99F8D6WXhoKiT+/2P0OiDyq24bzSQkpZDGTXDKvl8bDtBkasm73TioBZkwdecFi7MLDcTu4s4fnhlE+whEp/6o1jJVIw2m3oniPfWFOSHk/VjBfBsQ1e5wHAMyYjR0p13vPVlOeaBIbASjIRCL6DaHsM0PJyYBlLiRBaqSC5oolYOm32KXCufmEbyLHCPwrAHhSt+0Ub6hexm0Y+btNwXjAB6C/8E7vh7qC5+nK7rvwUTyL+mK0PAkNmGBRPqj4xMQbRALnyWoOB7ezGKzGzcMIcxr+VORhRWUsiDIH2e4tiq2eJI9BD5GJU+EGvaMAg8fkGiVOz3E0wLsTu0sltueBf//Wmv1jz1Cy07JQd93gXBL8xLwsMCLySvaVYs1I5CDEkpfdT5LSCH4q9sI90OnjsB7HBqBB
 FXBHyvfN
 3oT6/km4QN0F4Tsk5nLCKiXTWV4Q0a464qAoYjoVhV/GWQyD8UKQgKdcPMQ+Cj/p3anrnx2jLacJzoWSyRKo5geUuhxcrpgjv2PnhW+AGKn5Whq4psb2aaQg1RaJ/xKNGZtJZRzs+kM48P7KwPorFqh9h6A3jpApoN94X1MOkPHHJN9hJxwsdORnbbJHgeSsO2DujCxRn8C0CNGXU/L/awvTcLvp7BIUzJ5PRuIC7wh2V/tw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When checking a different patch[1] sashiko AI pointed out that
panthor needs the same fix[2]:

In the ->huge_fault handler do not install a PMD huge page
mapping if the huge page exceeds the boundaries of the VMA.

[1] https://lore.kernel.org/lkml/20260622215718.1532689-1-lk@c--e.de/
[2] https://sashiko.dev/#/patchset/20260622215718.1532689-1-lk%40c--e.de

Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Fixes: 68cbf96b1e9b ("drm/panthor: Part ways with drm_gem_shmem_object")
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
---
 drivers/gpu/drm/panthor/panthor_gem.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

NOTE:
The panthor version is only compile tested because I don't
have the hardware. However, the code is identical to that
fixed in [1] and I have a reproducer for that.

No need for for stable backports. The code is new in 7.1.

diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index a1e2eb1ca7bb..54535bae2b0c 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -802,9 +802,13 @@ static vm_fault_t insert_page(struct vm_fault *vmf, unsigned int order, struct p
 	} else if (order == PMD_ORDER) {
 		unsigned long pfn = page_to_pfn(page);
 		unsigned long paddr = pfn << PAGE_SHIFT;
+		struct vm_area_struct *vma = vmf->vma;
+		unsigned long start = ALIGN_DOWN(vmf->address, PMD_SIZE);
+		unsigned long end = start + PMD_SIZE;
+		bool in_range = vma->vm_start <= start && end <= vma->vm_end;
 		bool aligned = (vmf->address & ~PMD_MASK) == (paddr & ~PMD_MASK);
 
-		if (aligned &&
+		if (aligned && in_range &&
 		    folio_test_pmd_mappable(page_folio(page))) {
 			pfn &= PMD_MASK >> PAGE_SHIFT;
 			return vmf_insert_pfn_pmd(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);
-- 
2.43.0


