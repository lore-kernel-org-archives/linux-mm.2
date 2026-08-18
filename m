Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB78DC5DF7F
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 04:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 755F46B08C1; Tue, 18 Aug 2026 00:01:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705356B08C3; Tue, 18 Aug 2026 00:01:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 641DC6B08C5; Tue, 18 Aug 2026 00:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4061C6B08C1
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:01:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C18571C1ECC
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:01:02 +0000 (UTC)
X-FDA: 85113039564.15.DE23B37
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1DB841C0003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:01:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=utTgpugZ;
	spf=pass (imf21.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787025661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JgNJFkCkXVBCFeyWnDgafPWJnvI4aeQ+9PWN4ml6THI=;
	b=uIK6F+aYpYaH9704h2y5oMz5ye2MkX5fdA+Nm1/1Bc+GiuikVFA7qpM9vfHp03H3ZlN0p2
	KE0g+QY6/bG/1zgV/Gxc/BnDkMwz9nrLUb49NSLcMAbqlESIMj+B/eDfWetNyohqtbCKT/
	ywgP5TiQo8TNKRTPsuvNqZbAkC+lb7c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787025661;
	b=U8iJN86Rd5OTM7W+bJkKTgJjwG+MXPEvU7uWHkkkVbm8CGGoAc6j5GvRAKSznC0bh3L5zR
	rADH+mB3U1y4A6vgd7GdmuYyP8AIk0Aj+M7s7/dwXJV51j66WgiISEvMZTff9Q58MRmy6F
	tLh3uo+pU6aapwi2LvQ+911Q+k4lrww=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=utTgpugZ;
	spf=pass (imf21.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 552C0176C;
	Mon, 17 Aug 2026 21:00:56 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 439313F66F;
	Mon, 17 Aug 2026 21:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787025660; bh=jNvZ3ph4tfzqvfYMPDWyq7xHUxNcpHCKh93HJ34Xlag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utTgpugZygTuDjhpwxzKPuJMIDZz0EKonCrgJRpvQKS6INxHgHOfXIDFV+nOSQ7jF
	 7Bgl85I45aBhnw6MHWp+5DDIFHvHyFt07H8kgzKVC+zsqZqfrwYRzS13GPJp69yMK5
	 AJqMStMFmVH1+FyJHrLz9sBA+2QOVy632/sBTjjU=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC V3 4/8] parisc/mm: Directly use generic [pmd|pgd]_clear_bad()
Date: Tue, 18 Aug 2026 09:30:37 +0530
Message-ID: <20260818040041.1891769-5-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818040041.1891769-1-anshuman.khandual@arm.com>
References: <20260818040041.1891769-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4dps913xjnhggmbe7k8j61jexatfmico
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1DB841C0003
X-HE-Tag: 1787025660-160930
X-HE-Meta: U2FsdGVkX19V4abc3mjZpfSNGY5YP3Lg/rJufcE5QARwTOgXgWCL4VC6gM7T/JWo+Mlmb7hehRrdGaQl/h4yawKDhsrGaxpKMe/oboI603PPpWceULTysMYpWf6oqXpGn9w8OTwXc+uCQAANA6tr+pKyCs4eo7Zp9KkMGFv1EE6zIYX15f3cx4ZsvuhaYt4A5SiGJdMqgq6WsdPdn0HMWrY5BwN1gXi/okmxW0YcS1JE3GSTTIWVE3hFBRme0RCUT/8ZjLR0i+8Mmj9LyQ3gCHUkrVg+0azOWF1U6ObN420TCmv0Pj8CWSxJJaxCS4vgP1ydD4v/9P1JUlHLCTD5qBtHvu4M955jd68sd+a52LwGV7rYgwGHs29HeC7aB4R5+wopPGATzEuibhrrPjXBe4zmQm10Q/CkCgSiLyTTgH/416mxWde3u1RC9vySviVPyH13QQ5soDL+8ykMBf5qspHbnQOJc8XCsqgX9pQWyxbQeeZvICJ2/bpq1EmNdRnLbu4z/7MutRAKgUbrUPZ0tmN9yZBX5xh9lzU7zxXmgIqisU/jSHAaR3DqrAcfSTz7pVFYh/zEhhcFeiEL5rUzccrDzs8rfpOAB2Bqge6A8q/utoYX3d4KMHHr5wvJVQ4TBzJc5+8LNONXH/zFchUBSKymiULnUEyu+cYBR0BOTyE3YZ3k8xWIKe3XxTe0W+NplCbICzD9yURik/h6DGYtvUscGBDf+uDtLjfsYsCNu17r5pjDQkZPL56Qk4tz76Xt1tvLWVbcsL3Raq0cWufUhSJXgcCElO466JeUiO3nQIp8VH1HNEUycTRBB9b8xu7Foyw7Pc3TvY0iqFbU2BzsjJ0qDF1qVEZ9WdB+FYq0c4m2IICCkA5gr+DEqgbi8SQHbcPc+cH0hwG+NJDBnUIZmzMllDyURuV8Pdw41BFkrmSiO5FUybm2eUizTd4jZ7CtE4C5R+n4+8oyP/pMXom
 zSUgzgXI
 7y3dK0lj1ZFG7SrJ32tiGTczF0CkRcmm3ikzDcAg94sO56ZgeK5fxZ8Ss601szqZnc00IUGlkgKwSAhIXHqdF/9jwrpcL57+w1fHqKk6SiqaMly2UktsvGC82kuMzHTqCnKe7Js/D/IYqM9ktu7zfsoQBPJ/sowxDRGuGCrQYDey26AimCSvnPv7fxB9UZxxoa618pmLWbZWlOQJpD2k/IM5aA+6j0bDLFovOOavT55wAdP8MiqJDtYhU57s7HkY6/l37NO8RdswGrOGWWs+V9cuEuaOL4oMNIEBw67VhhXmzdPzEitLfGdGZ1x4DhCl3s8H5KMIWcOimNyChk+UDQ62Uw3aBdIDEAOuA8GPgkBwRq4eXNCX+DPJZJS4+IZqM4OaDvhvNQqVjx1o8m3LDwqYuPvF2qVcmiBAv12H639PWeDBrTf6U9oSrHmbjlhTd4cZdrVXqGmehBiezYLNRIQejbgHtJFmmoyVlHhPrhpCVbGMSe4lBXyj6qQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Drop [pmd|pgd]_ERROR() followed by [pmd|pgd]_clear() instances. But instead
directly use semantically equivalent generic helpers [pmd|pgd]_clear_bad()
in unmap_uncached_[pte|pmd]() which helps in dropping their corresponding
[pmd|pgd]_ERROR() macros across the tree.

Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/parisc/kernel/pci-dma.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index bf9f192c826e..84e7309a8266 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -160,8 +160,7 @@ static inline void unmap_uncached_pte(pmd_t * pmd, unsigned long vaddr,
 	if (pmd_none(*pmd))
 		return;
 	if (pmd_bad(*pmd)) {
-		pmd_ERROR(*pmd);
-		pmd_clear(pmd);
+		pmd_clear_bad(pmd);
 		return;
 	}
 	pte = pte_offset_kernel(pmd, vaddr);
@@ -196,8 +195,7 @@ static inline void unmap_uncached_pmd(pgd_t * dir, unsigned long vaddr,
 	if (pgd_none(*dir))
 		return;
 	if (pgd_bad(*dir)) {
-		pgd_ERROR(*dir);
-		pgd_clear(dir);
+		pgd_clear_bad(dir);
 		return;
 	}
 	pmd = pmd_offset(pud_offset(p4d_offset(dir, vaddr), vaddr), vaddr);
-- 
2.43.0


