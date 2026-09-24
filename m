Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85A6FC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 13:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A029B6B009D; Thu, 24 Sep 2026 09:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9C66B009E; Thu, 24 Sep 2026 09:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0896B009F; Thu, 24 Sep 2026 09:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 725826B009D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:12:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D06E16032F
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:12:25 +0000 (UTC)
X-FDA: 85248694650.22.A42DDD8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4886A1A000C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:12:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=e9ypsXuA;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790255543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NpqhjGqVIixU6okLk6Ml9UfeFxYF+fjWz6tD3inWrF4=;
	b=Wa5yeVonRkS5cZxiWbrtI6fchMpQfk5BQdHLeMbN+1e1B99WgHYULo5XsL0OruzVwxE4Lt
	Moy9xi3vx0nEJ6NxYq/0vdJzY4cwV/v26iht4ku7bMYQ7Z4abpT9nGFk0BAJVtCw0pyhMr
	65tuJDc7Eg9yylpC75+LWvQF73yTUQ8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=e9ypsXuA;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790255543;
	b=0ry/VmiYWf9d0U1jAjLWYqJEvZqi5rkK+Q7A4YPTecdIpqrirtn53ri/dqXhPDJxsW6zI3
	XxN1H2MOLRbQSfZEbkiEo4aNki4xE0zyUiP5LDuseWucFP3dQoJ0biEW32y2r2jCkJEy8T
	VZs9BnwLmcbz8uIKNxKEcInz5CRGwJA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC7691C14;
	Thu, 24 Sep 2026 06:12:18 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3D3483FAA1;
	Thu, 24 Sep 2026 06:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790255542; bh=zg4Gpqj8nP6uUFsMj+aijEa4Qysw1f63qlOvk3k1K+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9ypsXuAUEFUhUGiy2kuIWnONzTqWzmAlFPKs4AetqbG7BtTn9f3qUlgSGgefbBFk
	 TolsSjzBbvi0sBApOPtUgZ/la9iLY1I3EWzAWzImW+e6a+yk4iaRJoyXCpF2qrQRgV
	 DNGkB4orI3Y2KQ0YV5/f+7q+t2n9XurcSsoRDn14=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	davem@davemloft.net,
	andreas@gaisler.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	jgg@ziepe.ca,
	thuth@redhat.com,
	sparclinux@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 7/9] mm/memory: use set_softleaf_ptes for uffd-wp markers
Date: Thu, 24 Sep 2026 13:09:35 +0000
Message-ID: <20260924131106.1730494-8-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924131106.1730494-1-dev.jain@arm.com>
References: <20260924131106.1730494-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4886A1A000C
X-Stat-Signature: hyuttuo713op8x1j48pqseng3xuy4dtb
X-Rspam-User: 
X-HE-Tag: 1790255543-774658
X-HE-Meta: U2FsdGVkX18RSuG583a5ljy3DmFzUPQCIS4WHt9X7To3cOV96VWhkdAqhgVJU2D0RAv/LXwJ+uR2gSrwKq34OclnuY1OZ274YWyI9gi9ACoDK3nODOhSAwLmDR+8F5F2f0z0KI0FcFwtFTIfb7E9XVp6D/OPUwf3JyEwJAU52Elv4+CzN0rKXJ34w+1jsDr3V9ksCsb3zPCjChQlmtqHZoZkduGRS5qfyaalgrsWv2bfzta4bAhVYnUUf1IMfYHUNnIu9vdkC9qENmpbAev1bRV6p+XKhOShbpFqCLOqwF9eFvzH8gdQAx+BWv/3E97ljaHE7GkpBM+BZ/F4M9bxUW5nlRiPTQBL7eqGtgmFTMQ8PgWX+jDP2Tst7blA/eV2nSXcHFwMItfjcaevMRNoxXHnk5kHxM+RaFzKDPfM3jhWLb7taSECqUdfDExHFCAJy0Tpq3whlX0UPsffnYBri3/Ot80CeiOah58Wqb+wxUuFvfIJLoCYikIdZk2Z8Y2FmBimcKjTH+k7WvT2WhERau06qlqrGXDNQeNg2HruNrLBEpPzlHtRoAlTihs8cxBrDQFp9mhyLPB7gTM5Af6C/w8nLzSde7xQEdy57/2f/lTENLdv2H0E/iPfLS/ASXhj2fOsUqZpWTP3deTV+vlpM3GymbKYeJUHzoVw9FfnaWo78HnkEpsAYS60xeL48Bld4OUEOC+G1L9t8qbsbisjot+OYoQqXlDkvAPleMUCBgY+h7m66CoIaMXbE9ffUwFTC7GEVBtwAaA8UgxQEZMUW1RB+EEOpDxiTTCv6L37+gWck6rTb/wf8Etf+hXTChC8cbW/95Ibuv+bbmTMmKYmEEyR5C8TLNB8SUZv2Rhf4cbySfX+5QUEecWWp0theGriuIGecP/acEYTYwo6Y5InHTc/2Nxxx5mLIZzqtXAH+M3/RVYhlG59J+h2hC15BSHP/vfeNUkPpld9uc4Gj0d
 O3O2unjj
 e3Ie71vKjjG6DmZUp9AdID1h8ymg+JlvwcIEhFm6F2MI96SUPvMCNLEP2irlhCbqNeBlE0dvEAhApLmKa7gsl044NKx6z8x9FztKeoMc9+Zp0v9a/BGIt1BQizuKa+gkk42IUtx1HqB9ywVK0Ujp+wUjWCc4q86UWv/H0LylUypJP0cTvUSqRipd/40HcMB9t3/5b0+dVRhjQv3pVdMjA3YrqkLTGG4L4Ic++uDoBTrEFsZFsRKDtut516EdPPym49uqdoyPaEOWHlmPej6MY34J5dmoMQl+BPSQDPMJlaOCwXAUsv3IBDsUr3eU9QCkhFiWt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use set_softleaf_ptes() to store multiple uffd-wp marker entries instead
of open coding the batched setting.

Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/memory.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 60fd0a08b35f5..bed5cd90356f4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1700,14 +1700,8 @@ bool cond_install_uffd_wp_ptes(struct vm_area_struct *vma,
 	if (likely(!arm_uffd_pte))
 		return false;
 
-	for (;;) {
-		set_pte_at(vma->vm_mm, addr, ptep,
-			   make_pte_marker(PTE_MARKER_UFFD_WP));
-		if (--nr_ptes == 0)
-			break;
-		ptep++;
-		addr += PAGE_SIZE;
-	}
+	set_softleaf_ptes(vma->vm_mm, addr, ptep,
+			  make_pte_marker(PTE_MARKER_UFFD_WP), nr_ptes);
 
 	return true;
 }
-- 
2.43.0


