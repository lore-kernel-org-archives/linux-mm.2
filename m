Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76252C982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 05:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286336B00D9; Mon, 21 Sep 2026 01:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25D836B00DB; Mon, 21 Sep 2026 01:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A796B00DD; Mon, 21 Sep 2026 01:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E50686B00D9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 01:42:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2E636A055D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:42:37 +0000 (UTC)
X-FDA: 85236674754.09.27A0AD7
Received: from mta1.migadu.com (out-130.mta1.migadu.com [95.215.58.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1A91A100002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:42:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y96xcgCg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.130 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789969355;
	b=Sv01a795n76AQGena7k0OLXZ/m7bbaTDDk/y0vQXM4Eteqn8n9qrUXuwUlG0RUergLZ2rs
	eELMYe/wlOY4YbcNh+25M8Bzwmv5UYCOkL9VCpCQ8XmkUmByUzMB0vldmpfA0VWUzVaoK1
	8Ypr8eBLL57l65HEYOEcDMkgQa8t3IA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y96xcgCg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.130 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789969355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FqIXKrqAKPWNZs/g/HfAybvNGHQ49//8+m/r+E7bpy8=;
	b=mR4ToeNb6qIgSo6RiGX4ujnCm/ge6lBbYxSjsHZS9Fqj7YcKj2TY9M1X4Oc+d7IOuPqhCW
	nDpJxDSl1JXm9pX6AE3CAlCvyD4iWv8+R1bSPRrzGOfYAHYhilcm82OWe6NrBAt5uRllkb
	FWehZF9OzdCV9Crz47qbONev2FEd60g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dJPrO7Nw3VzzKVit/1YL9fAEnbejIvHCUFAGxCCzIG0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789969353; v=1; x=1790574153;
 b=Y96xcgCgu5hSDbEI9y+gBbk2QT84/vG9Ke6lID/JKh96yrKI0UAbbN1hc7/8ULmsdTB2RGPq
 dsgrFvQ3Ha06fxQCrkR2IKBpQ1mmHUg43Idd0DUtz3gj6LkMeqdFegfK5a0Kyzu8fNtmOkbzbI9
 LhkiWPdqzHDkK7uXrF4eAj8A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7dc0d847ad9390a3;
	Mon, 21 Sep 2026 05:42:33 +0000
X-Mizu-Trace-ID: 7dc0d847ad9390a3
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] mm: disallow raw PFN mappings of huge/shared zeropage
Date: Mon, 21 Sep 2026 13:42:25 +0800
Message-ID: <20260921054225.28537-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1A91A100002
X-Stat-Signature: ix5pangkzyhkujo77u87gi1scqzegrrx
X-HE-Tag: 1789969354-882259
X-HE-Meta: U2FsdGVkX1+bCrmmnAKINCj+cZRR24xMqadxRHlvlvcq70NdRWspjBjlZI+W0K9dQNc8liDbBNDAW8JA65NdXbuwm6DrKVdDvCb2SBz6OHVjYRrRwJfEDvbJxvsbLAx/7tdforR2gebf6ImUntSrWJa574EQJQjgrnGv6NxW3qQDbZvvyeeijxTakVnKDRrYYIRyeHQKbP7F6Y0XlaJKc1qp2Ab7ewPi9wDqA2sJArmiw/kx/JG7CbEklvWWZ38DzT8qEOE5Gop3Iwk15V74Yju4uNx+ocHaeYGsrlj6tCFHGcCY+rVAgzg7VAjjahwkE8+QO2CyGLwkdyhqJx+Z93baEK6s4W5zb9Ax/salDkIFA24l9Tg5taw0lMqQoHofC+4H1u7WbL6FdvhSDcF1Xvx/S8qj45U7cofUGd6WJd76oRtoZxaz8p/BFhAuzmAwqTVplRSDe9ZLyAzxL8PFwcgv0tSpYOE+5SDLXlki5UOyKSolG9VNGT5Uy5hk+5zBaIOM05IEl83EDWE019Riskf/4xkqDG/FNiEVluLjTCLsyU85g54HYvZTluwIWs4JDBH8mqiikMtmCqQilnqyQ642uL/x2H4smXgcJngVE3mf+dDMsgz171FGGRBo6/q8yVfsHSYZztalgknxH1DwrDlbFClolthJ9dY16YS87j2TXg/JKdcv0GY65UV8aXy2gtQczM+D3cMRI3jPqjHGAlFvhnQhuWNHisghaOcm7hROKbkEGlwldrhLfFDcfD5NV5ovRvLV3xXJydUM2CILhLEmURht9RNG00J1beHjml/cG9so3MnljLt+p63m4JMwSoUpsBRi1OR5JEj0HyViXWHLj6GRt+SNVEpYX5cVObQAMhfM1nCHNwFhtu+vxyPJboqZ8lurCumQjlfNO3YxBicL4dPYSwdoO1KFSM6MgMc6UWDEXqRE/sLZow3jEhvoYQDpi0AlHbT5PmMx4iB
 5EeQ4+89
 tRzUlcHOsr/+iFxMmTBKZqGCvpAzZjEBM5EJcFUWN4oZGCB1eqYnyz+SIhJ60UgNHC2d/IQHgUjYfFqY0WDCkAgZ0CHbmHzLvGCOje4aIMZFej3c1ECeSojM3eTrE7xhcfJhJS7oWuyAa3ymQhjrdOnwy4pX1yNcfHxTHgw/9aydB8gQfkdp+B5stC4iu5s0Vp5eODspROv7rXTsoC28Cy4zi/dp0gIw1Zyf9W9GJjS66pUbAMGbt045gwpkQMlGFd62nw4QRA9PU1LS1dQD7SXhVVenRcvRFRXNC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Handling the huge/shared zeropage correctly in vmf_insert_pfn_pmd() and
vmf_insert_pfn_prot() is more involved. We would need to check whether the
VMA allows it and keep the mapping read-only, similar to the checks in
vm_mixed_ok().

No in-tree user needs that support, so reject these mappings with
VM_FAULT_SIGBUS rather than complicate the code for now.

Link: https://lore.kernel.org/all/20260917121010.60966-1-lance.yang@linux.dev/
Suggested-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
v1 -> v2:
 - Reject the shared zeropage in vmf_insert_pfn_prot() (per Kiryl) - thanks!
 - Explain the VMA validation and read-only requirements (per David) - thanks!
 - Pick up Kiryl's Reviewed-by tag.
 - https://lore.kernel.org/all/20260917121010.60966-1-lance.yang@linux.dev/

 mm/huge_memory.c | 3 +++
 mm/memory.c      | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8aa2daba3739..1d4fe4452c98 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1728,6 +1728,9 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, unsigned long pfn,
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
 
+	if (unlikely(is_huge_zero_pfn(pfn)))
+		return VM_FAULT_SIGBUS;
+
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
 	return insert_pmd(vma, addr, vmf->pmd, fop, pgprot, write);
diff --git a/mm/memory.c b/mm/memory.c
index 926276d41920..7d821b110df0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2860,6 +2860,9 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
 	BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn));
 
+	if (unlikely(is_zero_pfn(pfn)))
+		return VM_FAULT_SIGBUS;
+
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return VM_FAULT_SIGBUS;
 
-- 
2.49.0

