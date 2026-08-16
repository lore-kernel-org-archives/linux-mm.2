Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5101C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66C16B0865; Sun, 16 Aug 2026 18:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17746B0867; Sun, 16 Aug 2026 18:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E746B0868; Sun, 16 Aug 2026 18:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 625886B0865
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:46:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2684A2E57
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:46 +0000 (UTC)
X-FDA: 85108618812.03.7F9EF23
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf01.hostedemail.com (Postfix) with ESMTP id ED00840008
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="f ok10aM";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=TrtxYGws;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4gTJnRBaxE38n6SDCeLxvRHbIPeapcnn6D1U93IbHc=;
	b=ja81GzB1Ttkm8DNv3auuEOgUWf9SG9q/N3AaTSTt3XIjKAIuDHX5Aib5cQOUGHs5b/9L2I
	A1sw53R7yrICrXoWiIcaeceTIeBwbzFBjBc0w/mT2vcaJneol6hmtwdQMuMHX2gZPKKCrX
	VjnOIv5L4RUaoWGaVewwe5QO5K5T9JY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="f ok10aM";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=TrtxYGws;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920405;
	b=qu43sSg4TCPp5tTHgHu9re6oBld/ryMirkwIzmlENNVFFZF0LchjhVa4WF/ZH+zWA8Qh3u
	ZncbPOkpp+iFA5NvIte+yPMjd/iS7FenNMPhV8Z99JAlDPqJQigOcYNaDPmDE6FrEuIiA6
	QNaFhuAq2OigYZ751rk5hEPfPTGDeL8=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 82FECEC0242;
	Sun, 16 Aug 2026 18:46:44 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Sun, 16 Aug 2026 18:46:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920404; x=
	1787006804; bh=N4gTJnRBaxE38n6SDCeLxvRHbIPeapcnn6D1U93IbHc=; b=f
	ok10aMNy/39spNh7b/1myx2RlfH2nwhR07eiGD3+8tdIAOvvp3r1NxQL3CQm9gX9
	exPEu3E6Pdlh9OKlRymUvcO5Cmzlbeb4+y4Q5NIOYltWeSt52FARVhNOTlfX7wzq
	YEvXjYdtm0PmZR9mttTLi9jSYcyCAofqu4iS0gLe2HHbVtd7O5EPtSfv0Lgp7zgb
	im8tAy638F1YmQLRlL2DQ/UgB5oMXnMSThTlhpDR1LeuB5uUj8WRn0+PhYANlcT+
	0MtN3ZUfNaWZltx9paljgwQGHxLvQCLT/HBu+VZK+RNZHXnsbhgQ/uZ8AmfuvG9c
	3e9isqXU1mY3210uyeMzQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920404; x=1787006804; bh=N
	4gTJnRBaxE38n6SDCeLxvRHbIPeapcnn6D1U93IbHc=; b=TrtxYGwsmRjm2TbNX
	bH2PZ53nziOXdJwzUfYOv3I5MDfiZh8pAx4e7XFlTEijRD/9jZ2tlDasrBaZJ2lw
	7m2Bdn1SUrYy1yi3vhc7u7SrQn3p7JHEClnBiDja+yYiAERfEuhje4gme7veNGVz
	2Ac1taUOpSrRYF4Fb+1DT/lieHcmZhBqIssHPMVrclS0RTUWRxPPJ7cxzcZyNdTY
	mZ1ZRJW+k4SZmWpnZ4aJvzZIQQokDaLNmY03++LEyqwCFjn2EW0ZH4V93vG8yYDG
	Sfj0MJeDoaQoL7GpTBY+vgsEntLkdfHY0WxYIBbVm8xSk/k+k10VYvy/JwGgHgz+
	6fSzw==
X-ME-Sender: <xms:1D2CavTQjAXBZy2l-sav-NHqY4onD1BqLKhq7ro8-ducTCXPwEnCqg>
    <xme:1D2CamFlE-RYg1VUjoch3qkIkxqTAXUffiP0WMeQQroHNDEM8rEuz11slSJOU0Jqd
    TjBqE7ueyOdETr1O2o63R-VcDM8lRj-08dH9gaRsVH4RRUxcAgbxnU>
X-ME-Received: <xmr:1D2Cag5IkXnyZ1SVOmTQ7RN6qAMgwKF53zWhMXKZqi_WHTwO_osndMjH_X4>
X-ME-Proxy-Cause: dmFkZTFt7uwKlsd4UyzlmYX1bnlzO4+qp5TmvoTS/qzkFKfMuj25xYssUPl6UU5Ie9xRba
    Y0bWuaC/AePVMhqrkCnU3j3fo4+kQ4lrNr0qcDw4ZM2xDmZI+m2r8oZbGDZU/DcLlRMJvk
    pxa8BemzxDXpf0p5hqW+oOweEwIQBvnr/hc1O3uCrLqxLkUCX+QMvT/AmKStBz4XcOBl17
    ynvfoFkCi5Qu6ZndF8QgBKMwimBrechIaqu56LTRaFtWn2N2FSoSPFDDGPAClh8o3Wii3h
    WmXtU4UIpdlwyanZt6DS7CEKxM1G2yBGNUvAI/9KSggaAyLfyuWlS9a0iep84iGUQaZXq0
    6iNUpsqBIpwRdfrQa0A+/xTO+yk5knsx0U/h5BqCJ/u1O6PL0q6GeYKIPmzYx5SPzHQ90K
    GAQl6gjHLUnYI9oTVvITQFNmfjJjcdgjAyhs8xQcvwJyiAhikc+UIMAcAhfI3zKYiIIkcE
    WWpUS08yMoVNcqLgXdHgmzFrsyxbCXZdYepPx80Bk8ZUo4Cdg7gHz6+AsOQTtQ9KnRJVSf
    zc0rFuEWWRtO/usObjtA2Xve2VvTlmFG4Do92vEmazEoslwtpBFG6WA8NGs1wLiiUhFvIP
    MwKHN3wYSFQyJeGVeoSpJLqXArC8iLMvgyAGWm0y3Soa8UTQkYadjlc9KJgw
X-ME-Proxy: <xmx:1D2CarkkDbiyBCmmdXd2DnetY8l_aoXieUNHu6AkfV5J8HcWMn82jw>
    <xmx:1D2CauwZhHRmA6_BF_MWlXNUfegA8zPocJiFh0ykFcP1-Uztx1G0Cw>
    <xmx:1D2CatMvGulIIu5d-lo4RY3jvd76IBvp3TXLqfBTyLM1IwaxzDbx5g>
    <xmx:1D2CaohDajSQuHgu0y3UWvO1YC0OiZx9O8hubnsxMG-yXeuJ-QEp_Q>
    <xmx:1D2Cal3Ds4hhaYr35_6H8tt7OCWFMyVfJ428HJsPrYzTBnOcr1CidTK_>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:46:43 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 13/57] mm/collapse: revalidate a round against the VMA
Date: Sun, 16 Aug 2026 23:45:25 +0100
Message-ID: <20260816224609.308019-14-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 66iedoshjtenmn7uj9gsnj46qhpjkc39
X-Rspamd-Queue-Id: ED00840008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786920404-994788
X-HE-Meta: U2FsdGVkX19thuLuP5q1X6k6GYvuVeDvo++OwIl+TpJys4udP8ueo7WXTsWIrT3cvs09qVGP8VEJxMBQnFao6PwFVv34wa5nHiSoLAIXRdmJd79H4dx8twgwldrgyQ60+EDfm4cCqPpVPFJzFnbphnML0wCJ2YuiSgwhcVCwpfBxN+SM12pD9xOegXbhmZvE6+H77y7Fp5UQ/EwcGb04vIZ7c4V9yTKtOXwunp3NSH/fbontwnRbgrndu9YDYyFeInecgyFG7352qvPhmtToHtq60wKLQ8Ozq7LlJVdN/EQVs5EVwYZ8ROSZdBnxqFycbkudDiCnZF43A2wG9dM9taND+igrg/sccUTykbx6EX9pEQLiMDQ7zpXUJ4buu+StF1BxZPn8aWWYBt4hOktQ2D5dzmruWqsYHV/Eq1jDmWEczmYSUQgfOb4XGTOeDV7rP5F4ZrVX/fj8dj7cf42avskWEITnFQLwQ/7OliIVeSnVMujDFggDKO6/Zg26NL2iftoglBzpYNJ5Adau0t/7ve87MaU9+xsKcZot4sE0ThXv8PjJRk8BUUffJmY88zb2Zx2Y7DMOOknXAgmii8mf4IaoaGtf7xSGPateT6rcZl2Oe6ZwUnoEYySFCuKJlRkmtkTto4a9Q52F/iv23f0oOPkNogg52X5Vj4h/uwJ8DUak3IkHOo30DOrBMAKkcV4Z6yWHzZkNF9Y8dDa/FzV41Bs72tZLwXpNapd1EjCHIR4SYk75tWK0Xq9Rz8TJ1vgzZK/8IHKBViU+halEfXYRC+ImnysxTlNZZKbvgVO+MWg2shcNdWVKkqZhg88TN1cABtuKjQ3Btv8KGuShiobitazofujCfCI2VX7COgg/DzzwaXlz0cPmcXQ9Liajs1LRqoQ7cQvDaC4wiJEbG1QdSBt+++fsPtUIRRjMRd47aThB1KI9A54I0c3X3IA7E3u2JlLRXJXqPyHCZxk0Jg2
 +x4jjCmg
 kYjifXyj8VYRE2cNGDAOYpSoaVQSHo3f/LOuv61vKFwkKDvY2ZnxJPCf9T9kwgzTTsxVQgXRtM+4GvGbrj3J4nfwHiK1EmQ1/Fp+BAxu+c5QHZNt0h8EtWRVAuexGJ+ycqlva9MpZ6aBSSPAjUjfjsiv8Zc9ll/B4XDIkBLQc51dNGwW03t1HnG8Q/S/+QErX0nGCHRCxwt+O/bHyh/mRs8LSm2yI+XIKRJB7EIyna3tspmcV/NZc8Nua9xXhzDNTptGkpZpBPVMSzMUDCUoD1lirwezL7cJJeikrLQafdkgS2iAJu0cS0j7gsbdiGtETV8TSqZTEAfndzgKFr56KlLbNL96oFEKe+BSsVM4t/8YAD86KsSUP1b07RaUvdYPoWBu8tkdI53e7XsT0VEoKS0vta9tTwDfWDpZUSBg/EELdSIDJX4SY8YMiUHJ2XZIDMuoU85TIbx3vCJ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Fill in the pass that re-establishes what the round is working on.
Selection ran under mmap_lock and the allocation ran without it, so by
the time the round takes the lock back the address space may have changed
underneath it.

Check that the mm is not exiting and has not had THP disabled, that the
VMA the round looked up is still anonymous with an anon_vma, and find the
PTE table again in case it became a huge PMD or went away.

Then re-check each candidate on its own.  A VMA that shrank, or was
replaced by a smaller one, may no longer hold a window that fitted when
it was selected, and per-size enablement may have been turned off for its
order since.  Such a candidate is dropped and the rest of the round goes
on without it.

The check is per candidate rather than over the batch because a window is
aligned to its own order: thp_vma_suitable_order() on each one is the
containment check in full.

What the walk leaves is what the round goes on to freeze, so it also
settles the batch's span, in cc->batch_start and cc->batch_end, for the
one invalidate the round issues.  A candidate the walk dropped is not in
the span, and a round left with no candidates has no span and nothing to
run.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c   | 49 ++++++++++++++++++++++++++++++++++++++++++++-----
 mm/collapse.h   | 11 +++++++++++
 mm/khugepaged.c | 11 -----------
 3 files changed, 55 insertions(+), 16 deletions(-)

diff --git a/mm/collapse.c b/mm/collapse.c
index 58c8d83f3468..1367ade721f7 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -177,18 +177,36 @@ int collapse_control_init(struct collapse_control *cc)
 
 /*
  * The scan and the allocation both dropped mmap_lock, so nothing seen before it
- * can be trusted: find the VMA and the PTE table again, and check they still
- * allow every provisioned candidate.
+ * can be trusted: check the VMA the round just looked up and the PTE table
+ * again, and that they still allow every provisioned candidate.
  *
- * This is also where the batch's span is settled, for the invalidate the round
- * issues over it.
+ * The VMA was found by address, so it need not be the one the scan saw, nor
+ * still cover everything the round collected -- thp_vma_suitable_order() asks
+ * that of each candidate, since a window is aligned to its own order.  A VMA
+ * that shrank under a candidate therefore refuses that candidate and no more,
+ * like every other pass.
+ *
+ * What survives is what the round goes on to freeze, so this is also where the
+ * batch's span is settled, for the invalidate the round issues over it.
  */
 static enum scan_result collapse_revalidate(struct vm_area_struct *vma,
 					    unsigned long pmd_addr,
 					    struct collapse_control *cc,
 					    pmd_t **pmdp)
 {
-	unsigned int i;
+	struct mm_struct *mm = vma->vm_mm;
+	enum scan_result result;
+	unsigned int i, nr_live = 0;
+
+	if (unlikely(collapse_test_exit_or_disable(mm)))
+		return SCAN_ANY_PROCESS;
+
+	if (!vma->anon_vma || !vma_is_anonymous(vma))
+		return SCAN_PAGE_ANON;
+
+	result = find_pmd_or_thp_or_none(mm, pmd_addr, pmdp);
+	if (result != SCAN_SUCCEED)
+		return result;
 
 	cc->batch_start = ULONG_MAX;
 	cc->batch_end = 0;
@@ -196,10 +214,31 @@ static enum scan_result collapse_revalidate(struct vm_area_struct *vma,
 	for (i = 0; i < cc->nr_candidates; i++) {
 		struct collapse_candidate *cand = &cc->candidates[i];
 
+		if (cand->state != CAND_SELECTED)
+			continue;
+
+		/*
+		 * The window has to still fit the VMA, which may have shrunk or
+		 * been replaced, and its order to still be one the VMA allows.
+		 */
+		if (!thp_vma_suitable_order(vma, cand->addr, cand->order) ||
+		    !thp_vma_allowable_orders(vma, vma->vm_flags,
+					      cc->policy.tva_type,
+					      BIT(cand->order))) {
+			cand->state = CAND_SKIPPED;
+			cand->result = SCAN_VMA_CHECK;
+			continue;
+		}
+
 		cc->batch_start = min(cc->batch_start, candidate_start(cand));
 		cc->batch_end = max(cc->batch_end, candidate_end(cand));
+		nr_live++;
 	}
 
+	/* Nothing the VMA still allows: no span to invalidate, nothing to run */
+	if (!nr_live)
+		return SCAN_VMA_CHECK;
+
 	return SCAN_SUCCEED;
 }
 
diff --git a/mm/collapse.h b/mm/collapse.h
index feb2e0d57339..0d6f77a7233b 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -138,6 +138,17 @@ struct collapse_control {
 	unsigned long batch_end;
 };
 
+static inline int collapse_test_exit(struct mm_struct *mm)
+{
+	return atomic_read(&mm->mm_users) == 0;
+}
+
+static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
+{
+	return collapse_test_exit(mm) ||
+		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
+}
+
 int collapse_control_init(struct collapse_control *cc);
 void collapse_control_release(struct collapse_control *cc);
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 50b520961b9b..1244e161beae 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -421,17 +421,6 @@ void __init khugepaged_destroy(void)
 	kmem_cache_destroy(mm_slot_cache);
 }
 
-static inline int collapse_test_exit(struct mm_struct *mm)
-{
-	return atomic_read(&mm->mm_users) == 0;
-}
-
-static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
-{
-	return collapse_test_exit(mm) ||
-		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
-}
-
 static inline bool anon_hpage_enabled(void)
 {
 	if (READ_ONCE(huge_anon_orders_always))
-- 
2.54.0


