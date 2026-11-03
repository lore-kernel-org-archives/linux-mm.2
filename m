Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C73A606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IwhpBTM5
Received: by kanga.kvack.org (Postfix)
	id 6FC726B00EF; Tue,  3 Nov 2026 16:08:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AD436B05B1; Tue,  3 Nov 2026 16:08:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59BDA6B05B9; Tue,  3 Nov 2026 16:08:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A10D6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:08:59 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B17041C36FC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:08:58 +0000 (UTC)
X-FDA: 85395047556.07.F3B295B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9C73180008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:08:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IwhpBTM5;
	spf=pass (imf02.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793740136;
	b=jMvpuEjc3pD5r5H2aTubFHGcrDmj99YRbCYJZTBybXH8BY80r9l+x4sgV1n2l1c+kFg05b
	RcNDhQAj7DgGLwQNjCqPHcfy9OyVIySWk1zc/NJi4TiPKDkRQYLghxW9tZC1riHFGSwWpU
	LUX/AcelNmIx4qvFriIUYgx8c9Xs9Qc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IwhpBTM5;
	spf=pass (imf02.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740136;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SHYGP7YdDrluRd4VWQyjYbq8NHSmfkSt9LBV7zxwYfU=;
	b=P2UEMM9+rm6KALRN5Q6TNpj2tBTNYtNv0kMwgFluzT2chsDEnyop9IKXYfDQZHsJUMkin7
	yFplaqh1jaEepYPPt8Ga8U6fLYMbYAAa5p5Y/hJfbjVRQpyOvUdM72NUFeRiSH+++Qk7cY
	djsdntbEaiTPxgZ5nWU/kgHCUKBKYU4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D78C60136;
	Tue,  3 Nov 2026 21:08:56 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793740135;
	b=VjuKyfetme59n3j4S0pM/xKGZzcwidq2leVyhd5lk1p63OkEV8bfLNNQ30+bkXnMljH6
	 /fiY9LyKc5fZXs5xIvQ7Y1EN4akjTNG0FPjc2nmMNH+0LegSBO6lUQNfTZ5ziAFa3/1bA
	 WQg8hWhvy0e8koaW1TXTuiCcXguCigOIY8laOi2ojFvo+9D/Rus3aQx2/hLOw/CraJ34J
	 +8/Z5hrHWndCqHuAGxwFialTzLT8eM4CS9nckLfAm7cQcyTtL6Uq8TKQzs2ERAMfvRPkD
	 XiCVHsEMbYSRyIAw5M8Fz/K2if0NWFvdmCgNBx3RswImDGLdeMeOJa/H3AhE4Pr1GqQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793740135;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=SHYGP7YdDrluRd4VWQyjYbq8NHSmfkSt9LBV7zxwYfU=;
	b=yHiC4T2WH6/Iy49TZUy77BaltArbJ8mcxISUT+F10o6PA5GRsEQSyiAFlFNfy8JJWmbT
	 5v3zKtMWyLMCJgF4hZfBFdpoFsVwwj0/92SBo5tbf1Y5I1z7vtZ8pkl7aa5TtHJ9GHVbz
	 xwDZj4zqlzXtVMGZizoEjphQMD5pApVe9OwULJ26ZLENaEZ0r0WLtMP7286a2OIKKLAIi
	 h2Ya2mgTNfMVsn0NTvJsWuhEjTwb/RBy7cnhwKip34Oc5pW5LiE4Q6neMvW3yvkScelIi
	 e/VVQP3rE/XRhAkDrNrBGwHFTkOfGn1yjg7b5cUb9Yu6oYRNlxzLw2XmSTs3MwYutMQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 03E0C1F000C1;
	Tue,  3 Nov 2026 21:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793740135;
	bh=SHYGP7YdDrluRd4VWQyjYbq8NHSmfkSt9LBV7zxwYfU=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=IwhpBTM5K54K1iQEs/6DNB7oaPizr7IWrEaG0RdCtObNHrbuJXRvnxwEnSKePVtG0
	 mN7Z87+gkRDlmkgsIWIxd5UDLwM/UMrEIFA4wXiJJZTLQvyhQl9HGZ3HFe8pffxVBd
	 cmE8CAMbae6Lg5V+8B3eKigK+KnMuu85NF11/T7kZHTL9X6g3L9zb9kY9VAdrPnuPy
	 U3WgiEvRTCv78kjphZzZN7IKF2jhaPSGB45RJbCc6s48squhl1gmUs+J5O6jijCg8K
	 f80t0oFQPuICwVLjEK619RiPoCR6wCF8scLyTabmfaD2KJ96JWjQdrqguhDSFQVFdm
	 YC9jjm0fSiAwA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5450C46B12;
	Tue,  3 Nov 2026 21:08:54 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Tue, 03 Nov 2026 16:08:54 -0500
Subject: [PATCH v2] mm/memory-failure: set PG_hwpoison of a non-hugetlb
 page under hugetlb_lock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261103-hwpoison-hugetlb-ro-v2-1-43876fc9eef1@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22Nyw6CMBBFf4V0bU2nQoOu/A/Doi0DHYOUtBQ1h
 H+Xx9blSe49Z2YRA2Fkt2xmASeK5PsV5Clj1um+RU71ykwKqUBcBHfvwVP0PXepxbEzPHheNGV
 ZglZCN1e2PoeADX1266M6OCbzRDtuqm3hKI4+fPfsBNvuKICAv4UJOHCdy1rlANao4m59l16G9
 BnrxKplWX6iq0beywAAAA==
X-Change-ID: 20261030-hwpoison-hugetlb-ro-5f8881a60af9
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Mike Kravetz <mike.kravetz@oracle.com>, 
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793740134; l=7194;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=1F4vtxF/OETYZMMsAx/an9+en/AsTwNgpWrKWjVH9+s=;
 b=36qX1N4lsVP5MFwUZeAQ1y7uk2rexo4x3/XUNeYm0dqNg3zcPDbnsyeLp2sMTGDQolR+TJ8VC
 LT0k2JgrqVFAcMOQCxNNO6yyIUGyzrUXC/qdyEQtYC8Of1b6KxxvDHO
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7n5goico1p64ir9emnyjr47pnqnao6ke
X-Rspamd-Queue-Id: 9C73180008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793740136-137123
X-HE-Meta: U2FsdGVkX1/GWNXEEVuUkPgiyszfbu/ghlVoI1xR50dh3WPrrEJI/a8RbSls5u0AxlcU3O7WN5G5axoGn9vKFJh1V+7uENdHtcKtWYwidKIj25TzqFeUAo+tGeQZiHX8ZaC0m7vWorecVwMUvpbnU3pRq2093UmeOO/MWZhPiaU65PcV5R9Xf5e/gs6DkUOuYSJGMIgyRvWq/1OSJIAJ0ltxctw7CNxcBgMvhXcDs+2kqedOB8//sLZYBlVW+BNPble/n/7czRnjzf6W7G1OJ0I9dKC4wSaq9fFArQN0VHFNTdXCQAhKn+zV85t/9DPGN1Jzqsk2gF74ZGGGSYuyKKzJXwpWT6H6xrVgUtGEZ64RMCSYFFjP1fox8Ns2SPVGXebfwTc8JI15YcBSY1tiygoRAnKvtQgOk1/w8iKPELh3IBbBKBHdGoBi+Z1kYM3JlqtHqwfIN7CZK1XbS1E1nWXUVoYYWAQiaVQCelmulJCxeNBes10pkeJEWYgnf+fBeY+TA4/fwpg1tgMQfIxgFXoQlNVkRk0AYuPbjIIdAYRSLhezyu9QmwX2cXINGT39ojMhZuxm5Y5WnYFosKUbN3KWGflKlVAFw7Uy8yXCVgvKyJTawIsCeK7rjufGiNuMk/dS575gj6fmDipwE0wd3hX2gpK4S6pnpRrjBdRQYKuBQ3MmxyV41Oy+P64bp0+Ipj50dWNbymrxh76ymAV3vbACECXeK89m98ih1limj6ymViqatQ6LZqeHh2NORXCM5aOaB1NkDF9QTnr9aNIsLjFK+WdVWuOVZ3iDvsErg/d8QrrRBncKizgU/pRMVsT7luzW6J8PYuiOjMIUOM+p75fonb4yIkppQOqXu4tXJPfQwSbwlNh8xDXrfM+mHcB7pdlrsoDJ3wfhqXI9bp3+2eMXVUnlDq9QIMYXh+Llmss1lHsLuk6M9YedhwbqiwNl3LrApXQtbe2C6YbKMtl
 ASgB5GTx
 T6Bi++f66whCJtxrhpiDlCkqbagzF05CRAU/76V1skP1LAmReHsO6NYRVls1vZ1o6bGtPmjQD9pO+syVo/x/tQgRmnuAMU2rDYbTYozGQL0T+F5SbW62BXByxI6M2TH3GMD4wMe25KkzIumxyJwqemshgLAjWQspep8djenNQL241VyawQeNfvVp9qBmkwANIlUsi/zBitaIQNpvjDZ8gNYGWHP8iIreSkar/zlDzOFQT6X+TIg68WFc+C2/2HNut9ipoNsbzq3kReFbzbxAwg5uwU2ZFWPd1EGAlIXcrgQmKocAMSZq7j0bGU41mW9ZajpGzKIDBTR19DxC/3osz/f9ceroj1af+SsRSHgXcWdkMEXeNAbeKbPLm+VyOAIXhVCUEhJolNxByirvm9q2//Pwq48WOwpD1pmt2rwzKsmx7LPDCpAOu1NBzPrbCi1vz788u1Y59YRzDwKX0uj7X9UeHlGF2ZBbbBVRhNCpfPR44Kle5JlzZ2zzRJQ9yQzYi9OdXR0bUoOjCqygVVHZVVLAhRvidjLwnkBnBF7sEkaUfn2/tWU14biAZ8rfQFbv85hhqBAW5U+azIww6nRYeXRNyEOQ21F+W78de7ki1PduJ5YKY/3zCi6v6RWIsvpB9/YUZdFKWjO7pp6/p98r1nBz9pNxJ4jY6zvmdKGYAXMi+auI9oGlo33YbIn6UuJBwo9PM+uj/fDKg0CFJ7a7qtN1cLs0/xyNM5cpI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mani Tofigh <mt4022@columbia.edu>

memory_failure() checks under hugetlb_lock that the page isn't part of
a hugetlb folio and sets PG_hwpoison only after dropping the lock.  The
page can become a tail page of a new hugetlb folio in the meantime.
With hugetlb_free_vmemmap=on its struct page then lives in the tail
page that all such folios in the zone share, so the flag lands on tail
pages of every one of them:

  Task A (memory_failure)              Task B (nr_hugepages write)
  get_huge_page_for_hwpoison()
    /* P not hugetlb */
                                       alloc_fresh_hugetlb_folio()
                                         /* P becomes a tail page */
                                         hugetlb_vmemmap_optimize_folio()
                                           /* P's struct page now in
                                              the shared tail page */
  TestSetPageHWPoison(P)

The error on P itself is ignored, while healthy pages of other folios
stay marked and are never reused once their folio is freed.  After
freeing the pool, /proc/kpageflags shows them as hwpoisoned.

This is the allocation side of the race that commit 32c877191e02
("hugetlb: do not clear hugetlb dtor until allocating vmemmap") fixed
for freeing.

Set the hugetlb flag of a new folio under hugetlb_lock and set
PG_hwpoison of a non-hugetlb page inside the locked check, so that the
vmemmap can't be optimized in between.  The retry path clears it under
the same lock, unless the page has become a tail page of a hugetlb folio
in the meantime.  With the fix, no healthy page gets marked anymore.

This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development.  The C reproducer below however
hits it within about 35s.

Fixes: f41f2ed43ca5 ("mm: hugetlb: free the vmemmap pages associated with each HugeTLB page")
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
Changes in v2:
- In the retry path, also clear the flag if the page has become the
  head page of a hugetlb folio, so that the retry doesn't take the
  folio for already poisoned (Sashiko)
- Rebase on mm-new
- Link to v1: https://patch.msgid.link/20261101-hwpoison-hugetlb-ro-v1-1-a42d6411cb65@columbia.edu

Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/hugetlbro.c
---
 mm/hugetlb.c        |  3 +++
 mm/memory-failure.c | 45 ++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 779b1de33c78..dd409d7f697e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1792,7 +1792,10 @@ static void account_new_hugetlb_folio(struct hstate *h, struct folio *folio)
 
 void init_new_hugetlb_folio(struct folio *folio)
 {
+	/* Pairs with get_huge_page_for_hwpoison(), see there. */
+	spin_lock_irq(&hugetlb_lock);
 	__folio_set_hugetlb(folio);
+	spin_unlock_irq(&hugetlb_lock);
 	INIT_LIST_HEAD(&folio->lru);
 	hugetlb_set_folio_subpool(folio, NULL);
 	set_hugetlb_cgroup(folio, NULL);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index b215312f261b..80bac8d544d4 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1956,6 +1956,7 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 #define	MF_HUGETLB_FOLIO_PRE_POISONED	3	/* folio already poisoned */
 #define	MF_HUGETLB_PAGE_PRE_POISONED	4	/* exact page already poisoned */
 #define	MF_HUGETLB_RETRY		5	/* hugepage is busy, retry */
+#define	MF_HUGETLB_NON_HUGEPAGE_POISONED	6	/* not a hugepage, already poisoned */
 /*
  * Set hugetlb folio as hwpoisoned, update folio private raw hwpoison list
  * to keep track of the poisoned pages.
@@ -2040,7 +2041,11 @@ static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 	spin_lock_irq(&hugetlb_lock);
 	folio = page_folio(page);
 	if (!folio_test_hugetlb(folio)) {
-		ret = MF_HUGETLB_NON_HUGEPAGE;
+		/* Mark it before it can become part of a new hugetlb folio. */
+		if (TestSetPageHWPoison(page))
+			ret = MF_HUGETLB_NON_HUGEPAGE_POISONED;
+		else
+			ret = MF_HUGETLB_NON_HUGEPAGE;
 		goto out_unlock;
 	} else if (flags & MF_COUNT_INCREASED) {
 		ret = MF_HUGETLB_IN_USED;
@@ -2091,7 +2096,8 @@ static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
  * PageHWPoison) should be done in single hugetlb_lock range.
  * Returns:
  *	0		- recovered
- *	-ENOENT		- no hugetlb page
+ *	-ENOENT		- no hugetlb page, now marked hwpoison
+ *	-EEXIST		- no hugetlb page, already marked hwpoison
  *	-EBUSY		- not recovered
  *	-EOPNOTSUPP	- hwpoison_filter'ed
  *	-EHWPOISON	- folio or exact page already poisoned
@@ -2110,6 +2116,8 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
 	switch (res) {
 	case MF_HUGETLB_NON_HUGEPAGE:	/* fallback to normal page handling */
 		return -ENOENT;
+	case MF_HUGETLB_NON_HUGEPAGE_POISONED:
+		return -EEXIST;
 	case MF_HUGETLB_RETRY:
 		if (!(flags & MF_NO_RETRY)) {
 			flags |= MF_NO_RETRY;
@@ -2169,10 +2177,32 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
 	return identify_page_state(pfn, p, page_flags);
 }
 
+/*
+ * Keep the flag if the page has become a tail page of a hugetlb folio in
+ * the meantime, as HVO may remap its struct page.  A head page is never
+ * remapped, and keeping the flag there would make the retry take the
+ * folio for already poisoned.
+ */
+static void clear_non_hugetlb_hwpoison(struct page *page)
+{
+	struct folio *folio;
+
+	spin_lock_irq(&hugetlb_lock);
+	folio = page_folio(page);
+	if (!folio_test_hugetlb(folio) || &folio->page == page)
+		ClearPageHWPoison(page);
+	spin_unlock_irq(&hugetlb_lock);
+}
+
 #else
 static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags)
 {
-	return -ENOENT;
+	return TestSetPageHWPoison(pfn_to_page(pfn)) ? -EEXIST : -ENOENT;
+}
+
+static inline void clear_non_hugetlb_hwpoison(struct page *page)
+{
+	ClearPageHWPoison(page);
 }
 
 static inline unsigned long folio_free_raw_hwp(struct folio *folio, bool flag)
@@ -2450,12 +2480,13 @@ int memory_failure(unsigned long pfn, int flags)
 try_again:
 	res = try_memory_failure_hugetlb(pfn, flags);
 	/*
-	 * -ENOENT means the page we found is not hugetlb, so proceed with normal page handling
+	 * -ENOENT and -EEXIST mean the page is not hugetlb and is now marked
+	 * hwpoison, so proceed with normal page handling.
 	 */
-	if (res != -ENOENT)
+	if (res != -ENOENT && res != -EEXIST)
 		goto unlock_mutex;
 
-	if (TestSetPageHWPoison(p)) {
+	if (res == -EEXIST) {
 		res = -EHWPOISON;
 		if (flags & MF_ACTION_REQUIRED)
 			res = kill_accessing_process(current, pfn, flags);
@@ -2486,7 +2517,7 @@ int memory_failure(unsigned long pfn, int flags)
 			} else {
 				/* We lost the race, try again */
 				if (retry) {
-					ClearPageHWPoison(p);
+					clear_non_hugetlb_hwpoison(p);
 					retry = false;
 					goto try_again;
 				}

---
base-commit: 74d73ffcffe03804f97e9fb82301dadf75671282
change-id: 20261030-hwpoison-hugetlb-ro-5f8881a60af9

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>



