Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FA73EB5955
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 03:15:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABF1C6B0005; Tue, 10 Feb 2026 22:15:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6C986B0089; Tue, 10 Feb 2026 22:15:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962186B008A; Tue, 10 Feb 2026 22:15:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84B1A6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 22:15:35 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C878139C36
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:15:35 +0000 (UTC)
X-FDA: 84430710630.13.CF69140
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id 43DBE140002
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:15:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=nv0TTEEG;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770779733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=01daNgyh98hRxmah5eHss3cRfBv0sClEGtF5tzXRgN8=;
	b=TYvTdoWly3hnUfJAZbjoDKu9cFrsXXbsBI1GT0RG/sKVfiQ2hJV70bS/sTor/9bpkv40Bd
	KnFSf7YM7Am2VRSDCwoVWMyZ0o91e/Rhua8zIObLt6jqfg3wQLLrprvNdkdDpXnd2ygH+s
	8Cmc1unmXs2V/97Lmwz+ewmgPxbYF1I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=nv0TTEEG;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770779733; a=rsa-sha256;
	cv=none;
	b=ck5JJexVxWG8NPFPVA9JVgqaIf+pLRuDQHgLyJurzwQvZYAs5wCif7jaYQjVPBoQE/Km0U
	1xgozFbj1XAW5XdrUmPpYrgZP4ay8LdUO8j+IawdozMFdmu8gcEUlYI9xdYMp6+DIPLrP3
	6DquABkqOJAnApzZBFTVO6ngoG5knJY=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-824923c7059so599788b3a.3
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1770779732; x=1771384532; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=01daNgyh98hRxmah5eHss3cRfBv0sClEGtF5tzXRgN8=;
        b=nv0TTEEGGJvD1Yg7xA7r4xvrEuh07ANWAaR+Gn7HqR2PNXDFrzc/QXnwFEw9xYaG5p
         qkpg96Gc6VPojm6P4plFlNiQJlCbAHTTAh186pJUhqHR/XFaV5kS/hCqhI1QBHctMPZc
         p0hsWHcgAxlsNAtTTzqWecdbA6azekJd+Sa2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770779732; x=1771384532;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=01daNgyh98hRxmah5eHss3cRfBv0sClEGtF5tzXRgN8=;
        b=GE4NDkK9nL06smM3zn2PqzpvCQnven0XrGPKYInDURi0Wxk2601KrlYFqS2kqPo90E
         Q9UFUY9q4LWJ0ehWas7/FtERgRmYA5tvVp1FICjc+vKPBV+ungnVS/h7pC1IkcRDdsoK
         MfLZLVdmMQ0m3JvGbSHwTQ9eMRu3rBolZH0v7wmyEgPygyvFGfLm+Yv92uhONO/8MVy7
         qcBRMgdoOfp0MjzI23EiRFx27DGvAJpfAuG/uIyxshcQrRE+85FJw2HrYOQvgcsMYaQp
         CQOx9uZXttXtwWtRzsaUksbhqUbmuzCpOnnHMq3TBf4Hz40LKUU/BFLWBraFgtOMpAzT
         QmnA==
X-Forwarded-Encrypted: i=1; AJvYcCXn08Z3VUzStTZO3zV7vzHZY8qQQV2TbsuUywuEsektH5DyNgnPuwvCcl7sxljZexS9VfXtGhviwA==@kvack.org
X-Gm-Message-State: AOJu0YyFeQ9t/kV/+1daK7ro1O413xAOMUuo310DRtiuM8tjCSSnKLuu
	ljdaDbS7bxNwEicXQWxBnO8rNkzzA6da+gpY0Ip9DE6GB5VqMBLyPrq4YPWBjV2v7nwm87LSaUy
	ZTvE=
X-Gm-Gg: AZuq6aLdxb/tJSVGe8AwU6Q28BBNndxaUJaxQ+KKnREp7splsEzidQH8QGrpvphHjJt
	4/FawuU711Xcx1mQMb38p0LOBcnLQF8GKhx9vgghi8Jonmn9TtWozr8vVZCj1Q/kpXQtcf+SFjL
	gvlrQ/9PvoM0EMLc7hoGwHCdVLry+2v2IK5uY694GQomPid6xxh6f2lemzROBMjgVln+EdBVgpo
	CxklhT9J7NnNIAM9vhYkczCYi1UH1mHOcEhXIjAfzZpvKbQofxMts0VPeAo1yLDVQO585HMj+Xh
	rKrRQ8fDPh8ENE0W45NEfU84DthZQZJZXU/xyjgZX/tYsCOKQHa2qAvMjSggqH7vFDvhvFAB5yL
	rBEQDrQPNnfVCi+tlBdDyXYTtn87rz/QS/N32s7tEz1ViFg5TOfIlAwsCBBLlXuySIWfQrJqHYr
	ua9lz6avgCKcT8IaetX8tTM5tGD9cKvL1r899mXZYleifnrdhfUO740KrbbORj5vz1nYsVZWSnZ
	YWPHzNmhdQLjllUiFvy8OE=
X-Received: by 2002:a05:6a00:84c:b0:81b:13c5:b6b2 with SMTP id d2e1a72fcca58-824416f7977mr14231121b3a.33.1770779732059;
        Tue, 10 Feb 2026 19:15:32 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:ec5:3497:e96b:e7be])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e3bd5cbsm430069b3a.20.2026.02.10.19.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 19:15:31 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv2] mm: khugepaged: make scan loops suspend aware
Date: Wed, 11 Feb 2026 12:15:00 +0900
Message-ID: <20260211031512.261127-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 43DBE140002
X-Stat-Signature: nbqcje1pfa11ju4a4mdjrtgbwih36dkm
X-Rspam-User: 
X-HE-Tag: 1770779733-99584
X-HE-Meta: U2FsdGVkX1/gxIJUCTlwQyUw9QMXnDAWSKE6nIfjktJeYJ2+hf4mTS/F3ZdmRXYhR1YmohxE71dr1ixnMRBgmIeLwIBSEK74kTpnKr1cbOLKwHIcXSydNyTEIr0trmQgp+hNPsoy8ugPMeH2tSGfPxhjRF2D4/AQsjujPbcnjFHq2xiIl3qBKwpMpjjgHsOIH6SYS8zkMU1Rig5v6zvUj1Qi3QNmBmNCF68cr274jTD0parGOFxnMV8OiutwTQ3Too949HOVMthpo/80+lDIngOT1If2Ops/NTfJG5xClqnXojDQFEnDCsq5XN/66N5CMULl3bNlYjD07Kbp3eOtFRHCrf5w6r1rOQ+bfmk2tdt3f8zQRLxJdMEpaoOAMhwn0c672eon6XCB76nbzJp4w0pKL3TZHTK6OiKfsiAl7vH8q1kt9dJ/2XjedzE4AelU3FnUiqSCv9P9bwqtdpGZB+gwPFLcQTOvt+U/0j8aGPJU8JJohzfMOL0Hs0WW65+KAMRCcxeKqSOLoX7IVMbrCgfIuwm+e9rX6dR2wcv+XrFOTL20oYItaCEX/qQGJLuXLMj+k/Icbt0X3IqRoG0iuBxsjAXJt4a7rMzGu9YKYgPcnJm+BmbVZrkKEm8vKIrGYGEm+5xKKLNlNZ42b+VlDkZqOOil2OdxqXf0HB9YpcSCwbIVLuL+64neG4J3frrGSuw3I4FmH9wcU+vBeE9iw+uVALznWZzug7WQCX6sv6ebm+xDH5jQadvbhVan8myfPjXQ4InpZtYv/ZE4RIdjApPgpzmCgNX1sT2FpU6EOIUHIfQouWHhKllch+0pn5VRJRIT0AIe5LeJSgW3oNWHwF378HSc3mbLOyv+bfcIgEgSWb1mP8dDQMwWFWEC3wjIMc09VOdXnGlCCg69CAXOEoFbJ2XV3Y5MtHBoPjg5V3rJWqheXM+gQ5X6iitiwzW3HkLXLBi1nwcJxpPItgs
 xeH6JgL/
 ClnNUVi1waLvrS/VNZjazAZndYrZY6+dTzweR5t7KI9CHQW2fv07PKs+5uo0E/xzwgu/pHYedhuVPC5WXcUiOr46EsOnDi89saXLBX/77Aaaw2ZCPg/aIwb7oVzIlDpQu63C2p8ihHNvyz8A6ZrZkqJXIh2dyU2ZShiHa8h4UbrikjERx2+KFGjcCMtoqYX/aIUle0wFHrWAaAtYsbXTaoOXrDSmVEP4Ba5ccWnfFmQHNdohTtEYt1gCUKMujNUDJCsOrInd0mcnl3V7+Wo53udg1ox64QJ+Z2rdw8Hgt4+dk2uRBPMb/fsH5kAtqwy+vomyfOwe7g5sl0CtHiGr3v6XCcEkoGmJ7GTk4LV9wkeCyem0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A number of khugepaaged's loops, e.g. khugepaged_scan_mm_slot(),
are time unbound, which can become problematic during system
suspend:

PM: suspend entry (s2idle)
Filesystems sync: 0.003 seconds
Freezing user space processes
Freezing user space processes completed (elapsed 0.003 seconds)
OOM killer disabled.
Freezing remaining freezable tasks
Freezing remaining freezable tasks failed after 20.004 seconds (1 tasks refusing to freeze, wq_busy=0):
task:khugepaged      state:D stack:0     pid:1345  ppid:2      flags:0x00004000
Call Trace:
 <TASK>
 schedule+0x523/0x16a0
 schedule_timeout+0x23b/0x6e0
 io_schedule_timeout+0x3f/0x80
 wait_for_completion_io_timeout+0xe4/0x170
 submit_bio_wait+0x79/0xc0
 swap_readpage+0x150/0x2d0
 swap_cluster_readahead+0x3be/0x750
 shmem_swapin+0xa7/0x100
 shmem_swapin_folio+0xcd/0x2e0
 shmem_get_folio+0x237/0x580
 collapse_file+0x247/0x1280
 hpage_collapse_scan_file+0x26e/0x380
 khugepaged+0x43b/0x810
 kthread+0xfb/0x120
 </TASK>

Make hpage_collapse_test_exit_or_disable() suspend aware so
that khugepaaged's scan loops can terminate in a timely manner
and let system enter the sleep state.

Co-developed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---

v1->v2: Actually pass "cc" to hpage_collapse_test_exit_or_disable()

 mm/khugepaged.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index eff9e3061925..d32a5ad27097 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -392,10 +392,18 @@ static inline int hpage_collapse_test_exit(struct mm_struct *mm)
 	return atomic_read(&mm->mm_users) == 0;
 }
 
-static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
+static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm,
+						struct collapse_control *cc)
 {
+	bool was_frozen = false;
+
+	if (cc->is_khugepaged &&
+	    unlikely(kthread_freezable_should_stop(&was_frozen)))
+		return 1;
+
 	return hpage_collapse_test_exit(mm) ||
-		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
+		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) ||
+		was_frozen;
 }
 
 static bool hugepage_pmd_enabled(void)
@@ -895,7 +903,7 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
 				 TVA_FORCED_COLLAPSE;
 
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(hpage_collapse_test_exit_or_disable(mm, cc)))
 		return SCAN_ANY_PROCESS;
 
 	*vmap = vma = find_vma(mm, address);
@@ -2420,7 +2428,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 		goto breakouterloop_mmap_lock;
 
 	progress++;
-	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+	if (unlikely(hpage_collapse_test_exit_or_disable(mm, cc)))
 		goto breakouterloop;
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
@@ -2428,7 +2436,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 		unsigned long hstart, hend;
 
 		cond_resched();
-		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
+		if (unlikely(hpage_collapse_test_exit_or_disable(mm, cc))) {
 			progress++;
 			break;
 		}
@@ -2450,7 +2458,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 			bool mmap_locked = true;
 
 			cond_resched();
-			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
+			if (unlikely(hpage_collapse_test_exit_or_disable(mm, cc)))
 				goto breakouterloop;
 
 			VM_BUG_ON(khugepaged_scan.address < hstart ||
@@ -2468,7 +2476,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
-					if (hpage_collapse_test_exit_or_disable(mm))
+					if (hpage_collapse_test_exit_or_disable(mm, cc))
 						goto breakouterloop;
 					*result = try_collapse_pte_mapped_thp(mm,
 						khugepaged_scan.address, false);
-- 
2.53.0.239.g8d8fc8a987-goog


