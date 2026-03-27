Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69A7710A1E63
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC12E6B00A2; Thu, 26 Mar 2026 22:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98F56B00A4; Thu, 26 Mar 2026 22:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5ED6B00A5; Thu, 26 Mar 2026 22:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9CE296B00A2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:14:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 683DC140CFB
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:14:46 +0000 (UTC)
X-FDA: 84590224572.01.94FF6B1
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf20.hostedemail.com (Postfix) with ESMTP id B30EF1C0004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:14:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HOqb9c3q;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLE/jttxUNtNWJGXfdbfQ0fLOQxN3ImdDTn6kFnTkPI=;
	b=8plVNDcuDF96YXd8PEPStkz6Eos0u2Dfao85o6fz5W9NDnNuSDgxpm6ok0Ltp23nVXcrxJ
	JxDIgF5YqWHI41x3YENR9Y4zio1HqSlozuzUcNryHYxKaTVVXk09eyszkLaoycCzzFXCnC
	7ulEsvuFxudhetUccSFcLiGKU+55fu0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577684; a=rsa-sha256;
	cv=none;
	b=mzozi4/zMFw3324DYsuSj/i1QCs8ig+ApbaM48/FgUR0CjoQHQbHAd0UUEAWjpgrKn6POv
	wUn1jg6jk/8CPy93oTweLdW7YMkyB60tE12XaZtbQJJ2HWHEoKxYuuqkIS0oI3Xzu5xeHF
	jTdjV+Idcy6gOlLOLLAlGR+3Vez54Zo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HOqb9c3q;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sLE/jttxUNtNWJGXfdbfQ0fLOQxN3ImdDTn6kFnTkPI=;
	b=HOqb9c3qtURSYEfsDks7zbx2QDtDTH9l8hI6RIZbNZVZjMBH564Y3pW5ZPIcsI8NKoiThq
	EoKp0vqkwqrK6t8HL7D5u0ey61UVlkvaX3oR+haZEDWM9M+SC4Ti9llRE18ryT8ip3fCx4
	H6PgMQ7rNNkpgtUJP6NJzF9wyR2yris=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [v3 05/24] mm: thp: handle split failure in zap_pmd_range()
Date: Thu, 26 Mar 2026 19:08:47 -0700
Message-ID: <20260327021403.214713-6-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B30EF1C0004
X-Stat-Signature: cpt47xpaezzcase8yri8fskpnuhc4zsh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774577684-13643
X-HE-Meta: U2FsdGVkX18DvW6AuEWRPrLiG1jWYJkMjIfKJvt5fO4l1BtbxV7keVhyjm91ieIpBxua0/H7oWeheQ9/66NixHzU8DWiQRKVNB+mQzpkY97vkHxysRfl3Na/lv7a3+SviA+BwMduhsJccO4ogbcjTFJZX20CObKKCxtujvXubEiUryFyfbJQ/v/ih+PgPJHJh+74SuYB9woLjnDyoILJg8oOtqKvxqLQU8V698OEZP0vEUBSoFF2JG8jUHbzIACKMzCSArgskQM6dFBE8XduxiRMUIWIrpaztOfFzI/vukp6sr3io8PaJLWnQBmnDXBS3c0VZxnZPyde7aB34bNyezfKpST6stG9vHzAb/Jor2cO/w+20DfWR7FoGklInbWWR61C2RILqUn2CsURcykDh60rHiotY66B0TthXp0CIvQk9/1ipvJWQAIhXuRHdWaR0z0PCI0aLJjJ+E59Gi2bCnr8ezmWxW8zuJrxBX6FV7CM1fwRzqvVLhlvMMXa48b/YwAq7w5PZVOTtbONDDhpN75vGQTcite1Yzy2PPbdfsPQn2FlBJTWd5UK4+6Zyz51KsvXsze0p0A/SvwOEOsgWDTOvoWTMpblZ/B0tgk2A+aX9FbjhtltJTOIs/JQbaiRUUIjbg1JnMyvukQZxgf/HD/ErLj40cTQAOyVfymEzy+Y7B5AOQdClQRB4d+0Dmny3yUSyqPpJgFXjI/beVKQq1cBwmiVSX5/XidiX3VFGtznP51bUd3P0FF6HJUXcwkdHImgvPgpR3e1/Z9mDGVko8UAojiEdGpCza2Z7pyxjOssTuafYyWwQPdO/MD6myczLjUShlQ7mFdPOlTAAl+jDbuNl4EdiHLgYCRYk7dW6GaZhLozK1vWTEAEaUpt+lzBYdGhxIQr8GqP2VNlb10DKgsmn1lBaUhRx1h2qnxmxTRJ4xjbNhiJ1SW4P3ACogdsDc2CDp3Aa9Kg7FUOYbf
 iee2vIjX
 qg4jyEf9XrZABAXZojO2dH6JIedAAVjT8Z55/hK13FIpYbFpXoC3SUic/1VtvDnC6flxdpwfDCkNBLu4WAmtvuNTtx8isAQdbdwqLeqRlCB7v0Zqxh/eCdoghESN3GIPV2geUxxLgJASLEnsWY+jHCux7YTVQPbOtRllL7Il+nndtJEvuVnfixT0JE8TGogU/1fRepKNGk1m2YEsZlY04kZYcv8IFYg+yrojcY04/ixTd8EFMq38K3t8iptm7jw3wCCJHOP3BoL9g4UgttoGq/KPpug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zap_pmd_range() splits a huge PMD when the zap range doesn't cover the
full PMD (partial unmap).  If the split fails, the PMD stays huge.
Falling through to zap_pte_range() would dereference the huge PMD entry
as a PTE page table pointer.

Skip the range covered by the PMD on split failure instead.

The skip is safe across all call paths into zap_pmd_range():

- exit_mmap() and OOM reaper: the zap range covers entire VMAs, so
  every PMD is fully covered (next - addr == HPAGE_PMD_SIZE).  The
  zap_huge_pmd() branch handles these without splitting.  The split
  failure path is unreachable.

- munmap / mmap overlay: vma_adjust_trans_huge() (called from
  __split_vma) splits any PMD straddling the VMA boundary before the
  VMA is split.  If that PMD split fails, __split_vma() returns
  -ENOMEM and the munmap is aborted before reaching zap_pmd_range().
  The split failure path is unreachable.

- MADV_DONTNEED: advisory hint, the kernel is allowed to ignore it.
  The pages remain valid and accessible.  A subsequent access returns
  existing data without faulting.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/memory.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index e44469f9cf659..caf97c48cb166 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1985,9 +1985,18 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 	do {
 		next = pmd_addr_end(addr, end);
 		if (pmd_is_huge(*pmd)) {
-			if (next - addr != HPAGE_PMD_SIZE)
-				__split_huge_pmd(vma, pmd, addr, false);
-			else if (zap_huge_pmd(tlb, vma, pmd, addr)) {
+			if (next - addr != HPAGE_PMD_SIZE) {
+				/*
+				 * If split fails, the PMD stays huge.
+				 * Skip the range to avoid falling through
+				 * to zap_pte_range, which would treat the
+				 * huge PMD entry as a page table pointer.
+				 */
+				if (__split_huge_pmd(vma, pmd, addr, false)) {
+					addr = next;
+					continue;
+				}
+			} else if (zap_huge_pmd(tlb, vma, pmd, addr)) {
 				addr = next;
 				continue;
 			}
-- 
2.52.0


