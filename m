Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3669E10A62D1
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9779D6B00A6; Thu, 26 Mar 2026 22:15:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 928026B00A9; Thu, 26 Mar 2026 22:15:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83E5F6B00AA; Thu, 26 Mar 2026 22:15:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FC6D6B00A6
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:15:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 445D3BE4D6
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:01 +0000 (UTC)
X-FDA: 84590225202.14.536DD8F
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 75783180005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:14:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="u0/m9ASD";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577699; a=rsa-sha256;
	cv=none;
	b=tglLGBxTovBNb1lxz8RwsJRqNixX2Agh6uwtlinVI3zMcBcnrruMKM5ZAXkuUt7QK64U40
	HddzplFuzloKJjB4mrTKeqHUz94YuzseuDqq0dVHLvvqjpYaJCq3/TwJseX+cV+2Rg6ABy
	t7cHU/IBemwe3E39YgvQJdfAcr3DtjY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="u0/m9ASD";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YEV2JraEcWrcU0ZBvWVbflxwtxhTRk4GT952CPZuA50=;
	b=U1uQB7PIRLR1YCBl1/472FsjLGh0Rqbckl0pbw9DS4T4R+S90+7q/swcopQ73ndaZG5d6E
	vOLhND13HETAx9uUsFlR/FSuXZDWXpcmqt3XwcUef63CTE0e+/0Vt+MM1Oa4TlxMzpaiHM
	zsowO0zc4eUziErOrELT0QX5Ezc6MMo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YEV2JraEcWrcU0ZBvWVbflxwtxhTRk4GT952CPZuA50=;
	b=u0/m9ASDIyRTjYzRS9sw7YydNLKfppOx0RMOs35/i/y5Ni21Cb1jtxqZNy/yP+Kqi/QxXC
	k6dOK7+inks9R2SF5uInEMSGMi6RkUSEsV/nxpnQv+EtYjG/nOmRguIxK19Cw1btj+1eHv
	O/E1Nq01pdgTuk7/bByUiSP3Dm/a2Jo=
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
Subject: [v3 07/24] mm: thp: retry on split failure in change_pmd_range()
Date: Thu, 26 Mar 2026 19:08:49 -0700
Message-ID: <20260327021403.214713-8-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 75783180005
X-Stat-Signature: fecjhdhm7j6adg4a6a5fgzstbr1dt485
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774577699-134858
X-HE-Meta: U2FsdGVkX1/QZ/qdnakKQgIapbmwWDNhJFbxHA82ICi3rCw00J6uTddUqGoEtbE1dDCRiwaUw9lkFQuarcPk4ALv1QeIruSBjvKiK0gAeVsCxrJp+ggOOlGGGGj7fjwYhlWW4uHoeSMJz4dkoocmkyT+DvB3trXYTBiQNwyKD7cV/7OTvkLDPGOqk0UT6+GRnMC5yiSihapTHWpb2Ts2e+kebWKYZZ1Gdc0SMONVo1S29p5V1dfYAmHiq57bkIbxgleTDta6nj0uchlxaEwR1IsHVZpuhtxAnXfsDOBo5rm86TZvdDZ96PJ84VxMjLUHRt0bui2NpKTXL6YOArQjY/d9x86VCO1mjInAUbui66b8CTd4kX3wC5g1H2UYDL9qH66ymL8HEe1pBvjJ54BRL+UEAqPVvDTfoHRHWFlFLaS6d48S9/rvg3RwAC5vXgLAblfEQhItafRkAWfv1mLyCns7o/GN0OSDh9BFBd4meA+5AaIGKjVDrSizsAcE/KCvxCG6COtZWqWduxKWbfffDdfUe9FzqZD4p86Dd5gwFF10Ol5/TWoQErFolVT2yIPhL4YfWu7hJ1Drv5OEUjgtkgVJku77hANECxWCoEfyLWlRStF1dISW7SrCpSuP7rXXhPkTqBHHhEH3myeSD5MOovBVSLQVUup2Tu/O7FXtL6Q2UIZtrcCHrHOibmzfWDrkoQJ8qFHCpbU5MWP2UgmGtLo4Y5uhXmwJvH2Fc/Rj6U02F/SBjONcLMTXL0sg/WT59nC0vtog2L7A5xp1iI8Sa2NuEoiqmoqvmxAV6kXpiI3EH6edqShcofG74BVs4ahRUkyG83FBtw5xq+0O1J4L7G0OODyJBHP1pG+gSoekOITfYnjj9kpY3Tb6D5td4u5CRuXeo6+CgOYychRXU0u4Nk1dJI+c0OeWN31UsFrylroaimTx/3yqDYsFTkSOna9ZrPNmc8ROApGttijYOQ5
 waMctRqY
 o2A+Ho96KyOTBciVB9HYXik373APmjTCpuPcR7KJOU48fe9PAbYnk2MMf/0R9ZDsvpcSMZJVSKc79za3s0id3pmEu3EA/jnTchageGld1OLlM09WzGoN/x3doQMzCY0R4bNeqxhw97BrjjaOUjRrHrGJJxyXS/muoTLNgaNZM6xWqfhMHjYahiCbSbQUcbbbJZRZNK3ggm7gVCJZe7jJDWG7dTEHvMPlsyPApvqimpuPIv3ota8/+6bU7gK70xxc0akXkZ58JsawJhNWElRX8M/FfLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

change_pmd_range() splits a huge PMD when mprotect() targets a sub-PMD
range or when VMA flags require per-PTE protection bits that can't be
represented at PMD granularity.

If pte_alloc_one() fails inside __split_huge_pmd(), the huge PMD remains
intact. Without this change, change_pte_range() would return -EAGAIN
because pte_offset_map_lock() returns NULL for a huge PMD, sending the
code back to the 'again' label to retry the split—without ever calling
cond_resched().

Now that __split_huge_pmd() returns an error code, handle it explicitly:
yield the CPU with cond_resched() and retry via goto again, giving other
tasks a chance to free memory.

Trying to return an error all the way to change_protection_range would
not work as it would leave a memory range with new protections, and
others unchanged, with no easy way to roll back the already modified
entries (and previous splits). __split_huge_pmd only requires an
order-0 allocation and is extremely unlikely to fail.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/mprotect.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 110d47a36d4bb..e39e96963da8b 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -477,7 +477,16 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
 		if (pmd_is_huge(_pmd)) {
 			if ((next - addr != HPAGE_PMD_SIZE) ||
 			    pgtable_split_needed(vma, cp_flags)) {
-				__split_huge_pmd(vma, pmd, addr, false);
+				ret = __split_huge_pmd(vma, pmd, addr, false);
+				if (ret) {
+					/*
+					 * Yield and retry. Other tasks
+					 * may free memory while we
+					 * reschedule.
+					 */
+					cond_resched();
+					goto again;
+				}
 				/*
 				 * For file-backed, the pmd could have been
 				 * cleared; make sure pmd populated if
-- 
2.52.0


