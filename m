Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 784D9C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 11:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F0C16B0096; Fri,  7 Aug 2026 07:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62C9B6B0098; Fri,  7 Aug 2026 07:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 409726B0099; Fri,  7 Aug 2026 07:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8FB6B0096
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:37:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B1F501202D1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:04 +0000 (UTC)
X-FDA: 85074271968.15.CEAD7EB
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf29.hostedemail.com (Postfix) with ESMTP id D7394120004
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="u POnI7R";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=bPeb5TJt;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786102622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUc0tI3FwUfzqFn1GnkruP1SC6LnWC+xRZZtn+0X3kI=;
	b=ELck2Q7QDmKfIqABh+05g3FasV0Av4pDRNTKhfl2Q08omHAU+tnMLB5ZOdCR3b8Akx4NWe
	rwSqrTF0mFOjzUJdw3sUeuV/9ai6vgq5NXJaK096kJeepoAirAHmM6FSM/+SpPOjLmTrEq
	5CtSc5qKSOe7glmd2+YGO1xAA/RnKGo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786102622;
	b=tOVtBmfhXbszbU56Mzz0QZw4asLeZMT/Kk1Fc6RFy9KEB9oqhxS8jJ/rWfUeBU4SpNtTYt
	yYmL76+jn/7Ha/I26qGn24N6WZr4PnD0Pb8EexK/2qT25r4s7s2d8YUN0t8SmTJE96+j3x
	rPxpH+vLdpAM6dmLq10YC+nXtVEhCvE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="u POnI7R";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=bPeb5TJt;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id AB9D07A0120;
	Fri,  7 Aug 2026 07:37:01 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 07 Aug 2026 07:37:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786102621; x=
	1786189021; bh=JUc0tI3FwUfzqFn1GnkruP1SC6LnWC+xRZZtn+0X3kI=; b=u
	POnI7Rkap0jtzxCvqzP2YGcxkmZK+a/4axyilNMdTDvIcESS1Y2fPCsL+Prjfqb5
	NrcEy0Ufy2kVDlhavodIHVvz2Mn5DP0jkowDH04+3Spnxeol4U3HpEu6UrwDD2b3
	FRCi0ILFLGYVCvBSVP8AvKY0KWcrJjifkEfgRhKe8q1MmjmYwjnhx60guPiOHsHH
	0qLBmy3DWvImXH8Z1x4CmlAyHDn8Mds36rP4b2ikudSphU1pky8BR4kTVeDLnvA3
	AW/XR4tElu2w8mrvyPODUbu6XP9BA9j7Pwd2kM6OWOYsBuKG9b+/ZV/+tKZcWS3u
	IA11TA5j1QFC9eBeqsZ7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786102621; x=1786189021; bh=J
	Uc0tI3FwUfzqFn1GnkruP1SC6LnWC+xRZZtn+0X3kI=; b=bPeb5TJt0Zq+0BPTM
	R7G/KrPUR1OO54THEGlZAFS49jMnYOV/zYURrI/PVdi/nQEfE5PpS+6x/RUsHxin
	aqC+ex4XEnWGP4yiocvfK8BwU4tTCbJlTp9vqIj/cD9kY0JNj0KGMTtQ8PgfR18s
	srjMzQOAsuPY7yS9ZJjS14hOf2JhTNs73024TUsZjhhiK34By2DrSxqn2tohY3kH
	OYCOJ5iUt9gO0ARZ/OXVy2e1GMft4ASSjG03tf9GbWOCHpu+wf126okY/vBSoLpq
	rQWI6HCCvV0YSXFQHHmIbrAl1wqrEPwpK7vrW0kof55QHF/K1DSOTcmzlqSaF3EV
	vKhFQ==
X-ME-Sender: <xms:XcN1ar-loQHiKkYNMSwrI4WSrf-IKUZ-XCf2YiwLfk1SDgoZHr910A>
    <xme:XcN1arpz-yjoRbLGPjjiw3TcQ1bnZVCBlJgTsjWCdYPNY7SHQ8wEUcSuP2m1tIMzR
    gKeenR52ztA_y968KdWsPLCi4oVYldhgJWRfnt4hnxp-wvnGFe4-t-->
X-ME-Received: <xmr:XcN1ahiiPqFw79EpaRhkM5LYWASmr0XQXmW_o7PKjNWQsGNMFIdQahMBPR0>
X-ME-Proxy-Cause: dmFkZTEfW3x2Qrq7ELqxlr/x69vk0aYaa/E/2AWrFAl7yu0Vg+jIGlS0mjOCk5J5e5/NJH
    T3J+l8M+cQ15gxg/u6FQhwxKudsrf7tN5cWcEThveGDS0KcOU0uMrzGx0YBmylEV4PfT2X
    SbTqClZY3SINVohR/2NzYRxeOu5tU+SgKqY1sS5oM8U15+ky277S+G1Ww7YAUM5Z6EK46p
    TQK1COWwyEQl/dhwe51H5lWCLFzTj8K9hkk/JBO/DvOgEgoe5sMihzFP04eKTIrZCF8dte
    tQwhoNU+zszgTlPncqprVsvTwAgpjyPciGBDZXKQScTz4u1orAuTZg8Fi2VomZsbF2qQsR
    eL1kaiHBpp80M4RzDUsAZRJygVAIesBLxby3W54tcHXPJqAPjdtHEFumnKAwb74kc0+J3n
    KlS5iazk/Ooe6XFvlIqXdqyrpLbfIPetzbxMD3rM8ypA4CDMjbgME1dXJFHpFXaauetX3L
    dh8aaJt0hh5AXjzk1uAO2icErMYCxtpqxWilkvL508lIKOkNHC29LP6kDYhGogrbbnZu/K
    rjMBlZ7WOIsjIAt+8knDO1/FrYhkE2E37Z0jou3o9BEH9zLe9kGb6x90gjYFmd/JtJtTbu
    eT2eET2AvAWQVqUvwVJG9CwXzvl7U10CCbLigNt/K/4Q64lGhESar78BxLJQ
X-ME-Proxy: <xmx:XcN1ahClSJ0UeYIe1AXgr01Pk0pu-NkRJDyMBwv_uOvkGUM6TTiNow>
    <xmx:XcN1anv6whV4nGC_Xm1KnkSrLL8EqcIsIvZQj1oO2tXgzWnUswI-NA>
    <xmx:XcN1aj46vAPQzXD3_gLtdtQLdFRrsNAGWUaDcmtCptMWUSXRYSkuuw>
    <xmx:XcN1apemkXi2nQnIe7VmCJJ_1unvME_v6O8QzwmnPJ6g0S_xm2h_nQ>
    <xmx:XcN1agfw6YOpQjs0Lj9EL4rn3Yy84uU8QN4HuMiYY8iSaqbBl25Z5lNJ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Aug 2026 07:37:00 -0400 (EDT)
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
	kas@kernel.org
Subject: [PATCH v2 04/17] selftests/mm: retry the swapout the khugepaged swap cases rely on
Date: Fri,  7 Aug 2026 12:36:34 +0100
Message-ID: <20260807113647.3744609-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807113647.3744609-1-kirill@shutemov.name>
References: <20260807113647.3744609-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D7394120004
X-Stat-Signature: jpd143hsjyboigxxfu4wb6x5frnu6t9y
X-HE-Tag: 1786102622-178422
X-HE-Meta: U2FsdGVkX1+4w1cC9FVZhFk2xuZkm65OXCUqovJ26yMRakHetaJP06oF46HmJ06bfT9tox1hI3GuL0N3F1lXamwkzBYrw04vF3h9m0+kJTcuieVn3hbyNunneBAMX6d+4bD5aV4meQjxCOAimM4KxzHd6TM7OcFZSYNXsQrJixcVMHbwtB520j55S9C5XywMQA90DCaXCUztK0zE/+vXxUFOnjZIIiZmvX0A5TNAKIZk9gXGLB5W03XBFvxHC076k4sqAT8bgXT7xrQlDlAhn8u7h9aoY5Lk8w83QRib4rzroJ7WM8/oKQ8/i/TcixWB2lmgNsv/FKH9tsrY9Vz6hDbweC1JMm4XkpGL6BDcDCyZ76vFJGYjDJLII+h/yxOnLbixRR1Ppvl1E6UtLv8t25vgSF2IdwSadYJXPQ0RjPHHYGFaThUmhn8dMbDmVgjj7NDBkfcW6fg09VCj9c18vtoCtuVlQrp1bLRKv/7gzlGpCRH80fXuWVOXaA/AxjX4rcgt9fTUHMmqvavZjgOwHr1sQvmE1Z8XiFOUKMuyXWTZrVWl+CATRIn0NckDkfFhWEQmgMYgHKOifj8c9pO/lBPRoCXc76QQvjem00uXTMGWqQTjH/oew5Iv6SAZk7xIl3zdzYom+pioPI9Lmre8l2gBbKtwWGcKCUA7DKydmxXD5H1SjnKBaYuk+KRINeMJ2Kg2wLBMZvYvVAnjP8ZOoxAH1I0Dnu6yGoHUmNL/YKxLD3mM+iVpvR34vEocWQFuGyXmhi+bvwrGDzFbktCPimDF7tz9EcIbJA0EFpvzz5K/xREBPlsqVPEtcpnDQrOa6s3XAn8yo/WMyT7ZciSS78ZzaJDRCxgBQhna0ND9YlH8F18YB00iDQRWUflbebyxkSt1uOk/EHzQfdn9WqH1UCixjJKwn4CQ9HW+8i8O0d2KzTFttX66Gw/T5lDkiZeWAeL429Lo/gd1LWmIT5r
 MHEDSban
 QWVsx72iw0ahaEZc5BbcuObcWwYkSWDUwKZhkJ5/P/TtZha8+DZOt7Jp77OedaCpGCy8GAiB7ECATnlMByE/xLlC3g8BkJ0wZ2gnjxZXzTsFD8a4uXQBk4vzDmpqXtoWEe1x28t9k+XkQGmRgCp1EnZX7cTaD/h1WAVC1o6UqqhLWZhqu3atjC+i4AtErnqexabDgtgBpLT1ZKwHzG2ce5L3bi2JrQzOhfLiv1JNg89VsTlr09IqZ5NFRGhxXVjX4N8EcEjKz9vNoGHELi+NzNkaKr8VJNhtgyK6ERMRIaEHGrGbSSb3V6eAmZ85aAJNVMKkyh63bZT3ZC8TIg8N0K8UqOZ+DmhGiF/AGQhUggCJXSXLYNuAClwZVYFDH40G9sL30rOw+8oIDX3DD1UGzeKjuXQtBRqxeVNHxpAmozfifmQBvT7tkdniTiWrZUkvg/it9KxeCnTavHR8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_max_ptes_swap() and collapse_swapin_single_pte() set their
precondition with MADV_PAGEOUT and then require smaps to report exactly the
range they asked for.  MADV_PAGEOUT is best effort: shrink_folio_list()
leaves a folio alone when it cannot reclaim it right away, and a folio
still under writeback from an earlier pageout is the common case.  The
count comes up short by a page or two, and the case fails on its
precondition without testing anything.

It shows on arm64 with 64K pages, where max_ptes_swap is 1024 pages: 64M of
swap per step, and the second step pages out folios the first step has only
just written back.  About one run in four ends in

  # Swapout 1024 of 8192 pages... Fail
  not ok 95 collapse_max_ptes_swap

A probe around the same two steps hits it on roughly one attempt in twenty,
and asking again 50ms later closes the gap within four tries.

Ask again for up to two seconds before reporting failure.  The wait costs
nothing when the first attempt is enough, which is the usual case.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 32 ++++++++++++++++++-------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 9b1da0dd0f8e..69e0fc4b12fb 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -241,6 +241,26 @@ static bool check_swap(void *addr, unsigned long size)
 	return swap;
 }
 
+/*
+ * MADV_PAGEOUT is best effort: shrink_folio_list() leaves a folio alone
+ * when it cannot reclaim it right away, and one still under writeback from
+ * an earlier pageout is the common case.  The swap count the caller asks
+ * for then arrives a moment later, so ask again before giving up.
+ */
+static bool swapout_range(void *p, unsigned long size)
+{
+	int i;
+
+	for (i = 0; i < 40; i++) {
+		if (madvise(p, size, MADV_PAGEOUT))
+			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
+		if (check_swap(p, size))
+			return true;
+		usleep(50 * 1000);
+	}
+	return false;
+}
+
 static bool is_swap_available(unsigned long size)
 {
 	unsigned long swap_total = 0;
@@ -881,9 +901,7 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 
-	if (madvise(p, page_size, MADV_PAGEOUT))
-		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
-	if (check_swap(p, page_size)) {
+	if (swapout_range(p, page_size)) {
 		success("OK");
 	} else {
 		fail("Fail");
@@ -920,9 +938,7 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 	p = ops->setup_area(1);
 	ops->fault(p, 0, hpage_pmd_size);
 
-	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT))
-		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
-	if (check_swap(p, (max_ptes_swap + 1) * page_size)) {
+	if (swapout_range(p, (max_ptes_swap + 1) * page_size)) {
 		success("OK");
 	} else {
 		fail("Fail");
@@ -937,9 +953,7 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 		ops->fault(p, 0, hpage_pmd_size);
 		ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap,
 		       hpage_pmd_nr);
-		if (madvise(p, max_ptes_swap * page_size, MADV_PAGEOUT))
-			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
-		if (check_swap(p, max_ptes_swap * page_size)) {
+		if (swapout_range(p, max_ptes_swap * page_size)) {
 			success("OK");
 		} else {
 			fail("Fail");
-- 
2.54.0


