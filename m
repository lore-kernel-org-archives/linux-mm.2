Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD633C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26CAF6B00A2; Tue,  8 Sep 2026 08:51:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21E286B00A3; Tue,  8 Sep 2026 08:51:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D916B00A4; Tue,  8 Sep 2026 08:51:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D5C1E6B00A2
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:51:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 63E9A120614
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:27 +0000 (UTC)
X-FDA: 85190581014.05.B829902
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8FFB41A0006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="N sU2itK";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=EuYNbeoz;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871885;
	b=dzZTnyYlChkW93Tbi0HtkhATGXhe0WYdYw+DGyAjgF2i+LGldvZMI45II9AYlBDxe1FiHe
	jwEw/T9uwAd2J91opMUEBzkkpdvmhHu2qZXIOUjIlPh541sfJgtyVLCWmkfA/7hJiXpREo
	CqnBxWaei9Ec14hJXlsGXqhdM1O4LuU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="N sU2itK";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=EuYNbeoz;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U0YBLkbI0LHkxqjta9AIDEwH3CtLA9e8x9xPZXdAjJE=;
	b=K09Vqt7k/z8I/Kao+kB4F7foiJ8ksvep/7Csz43LVRj5mwaU1sHISa5f/LGsPTrllZd04g
	IrpOMfZzmNw4kCQsUErKErc+M1XPBxhFqSZ3DHohi3yKgzHvhM7yxh/M2Hcrd8+QI/uf9c
	nD1BgK+lf9JSlRWkE2ZQbOXTnf2Uh94=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 29F9014000FA;
	Tue,  8 Sep 2026 08:51:25 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 08 Sep 2026 08:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788871885; x=
	1788958285; bh=U0YBLkbI0LHkxqjta9AIDEwH3CtLA9e8x9xPZXdAjJE=; b=N
	sU2itKAKWd+EuTEFp+MBfrLa3Ev857xAWFwM1H1vaR8x6gMu4EPAOmT/X760cTUD
	GeGcwd1nLR7QgmNzmdwq7WB9NtUpX8VUnNSnMzBBtxKhpWhzZWL31giZPEmAOeOV
	6s0DycCAhiUWk0ScZvpNvYGAPTQ/Ljt/VKJzkCo43D75/v2QkPuLR+7AnMgPP8Af
	ztcme4beNB0szeinsmmvx4CtW7GhTCSwelWgxcIlyLIA+ga7B9F4XUdbfabnyuxp
	YsIu9rwCTSYTpZHHBAcHeNYnJ7k8+edAD35A7Oa/xiH0GUU9w5Mp0khI7Atm/uIB
	ky2lJsLHVJH0HU0NYdysw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788871885; x=1788958285; bh=U
	0YBLkbI0LHkxqjta9AIDEwH3CtLA9e8x9xPZXdAjJE=; b=EuYNbeozRzz2MoSYq
	8gxGE4Gx1ZIIdq4nTZ78Wxs7oNXAICb8UtBsfqfU+2qZQ4qCrEgtLWW/4UDMP2up
	cVSHRed3YYuLCdVgI+1iXxPnwaV4h9SjmhwrYKyJdUSeT1NTDsGhjHw4Q46Pi49V
	kJtZDAZds+IK0v/A9b5gUDpT10CYDU8Cral7IsbTrzUfTou5uVw6oTJg/mKGRbzh
	oA8QasxgXhLyBTAUC/P9nJrMon97IC+4TEDDkeoLyLQHi8G+pxWHdqM6H/4W5y4m
	9BPjFV/SCTWkd27B9WRKsjes9K3DP4mb+DdNNE3sKzAooJ2VZylWPoAhCjgI0vNc
	OiSeg==
X-ME-Sender: <xms:zASgaud7y8CX7WzeM39WnUi3pxGXSEVpLqZs_nDKb6GgMr8HsMH_Zw>
    <xme:zASgagnkLd0tpe6i5kwwTmwaOaMXklc0f62wVJ0jiR5QMTJMYgnFuG_rx-apOo2Wa
    5gTyEz9SgEK7MAN42ziCyVpLnurE-G3OLj3PzwGQ3RfyNabDKdYPwY->
X-ME-Received: <xmr:zASgahuGepjnv419Mt5mLHZrKdxshktmSJ5KorgO8fTcQN6kZ4LDYQs5uLs>
X-ME-Proxy-Cause: dmFkZTGuvEMc9jYu2f0uyTmUF7l0J7NybVdULRlrJFmokmmiolg4yH1+7h97U05D2w+OYm
    AZhWoHmMPT2EsIB4AC7PxRFoqN+CF4x8etMK41ayTMd5Tw55ZxqvSYpb69cNUy0p/dfOGv
    05P0JRk7g5kt5eTL1k2cO9e1oUb7lrROdNyUSbigYjG7Zs/tNKx+L8+9HHw+CSw5cJpWIQ
    j2DrX13NeCZvnLN36sWkEk/U0EX1Q1izKAtzdjMuXhus4PGMhEw3kJKafKZkgCRsnWRxXR
    Wv8osDa5aTh9mnjCTFnYcP83hQ8y7tmPYrDENim+Q79mFJR5sJUGN5QsCu80CUB5y6e4pl
    rS2MddTK+RkN65CROPf5h/Hb5YbHbiCNRTiVKxlDAxSXeim+ipmXoINvh/pG24ZHJwjwYJ
    i6kEnAsMDSVuDJ0jNxiIIpjM0nJvb14BfXRSkXD3zDR4wesKMsUR8NJpaGhLA/VfY2rQWC
    bNbouAaduzGJfuaV6Jvi3zZORk+qlUo4npAiIvyMvLXYEM8I1zBApYZFp0BTcb1DWzO9r7
    47yVzIzsj8CzVrdAhngKUkopAw8wLbGD1IVMwjpsZBBDNJ8yCdHqI/htY7lTluzf8yez/d
    jdzfB2sycOTka9P9hG1T9fxMG3QEgnb8x5/xHL9Z+kRJRwsLx+6b5XOxu5GQ
X-ME-Proxy: <xmx:zASgajyN6fz6aoFJklJyLOZ-emW8GO1gvwqFH-GCwm1K3X5WBCj4dA>
    <xmx:zASgasxzdglc2_7Gk0H5cLJFBMx7fwBeMD259Oo4Uixvp8fsuHmt_A>
    <xmx:zASgah71l19XY-v2cPAk8AUmj6T8QVHU1JXbcRggci-e-I-UUzKtZg>
    <xmx:zASgatD7hdk58sCc55HRH3dOd9_LezFRgxZuNr8XWKx6s9GZMKn41Q>
    <xmx:zQSgamPx0x2WGEu1GtLQGn-fEL0v9TTym9VuhoK0x6Ngchwm9hX3WuY_>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 08:51:24 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	usama.anjum@arm.com,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ziy@nvidia.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	agordeev@linux.ibm.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 07/19] selftests/mm: move is_backed_by_folio() into vm_util
Date: Tue,  8 Sep 2026 13:50:53 +0100
Message-ID: <20260908125105.1510704-8-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908125105.1510704-1-kirill@shutemov.name>
References: <20260908125105.1510704-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8FFB41A0006
X-Stat-Signature: eepfnee9sbenqf7k5zn8g1d8bz1q7p3w
X-HE-Tag: 1788871885-727184
X-HE-Meta: U2FsdGVkX1+tk0rY460NcRAH1MprYkKTL7ft3vzRHcWQyUASilZ5JI2JnRtffmn0MGpb/oCOg4e+cZPpUb8iztLFFNXSIgpeRZBes7HwOxTY+Q79HLCJqkTehLYv2oZ/C1Y1j2ERHxTz9BfFblGgyPS59qKKhAU2a10Q64dIWPwzYgOG6VPYYK76tzFescO2KPbgqL9+cHi3k5fbZk7dQU8837LNvha83O0kqLnQpVoxanDMtjg3xTaTu2RJ6tyDyZn6AydTbASsAAr59g9gEpQAFgq8amd30KX6tD6IyBWlCPvhdgTO3WneSMr382QLEKjP86/ROMxABQ93R1KX0TqmETU1QW8iXchTRkSopipvIsP1OpulRc2P+qBkXsg336hosJ3Ii4a1E98tRNi1ThNqvPEXSTd40gYK2WYQoGXHpvTuxEIXMBtElBjcVbUb5p8gLDx9c1pzpphQZmAUGntsHdcklZ+aRrAr0sk7vo7ivpP4gAs5rdCRv2nqMDQZYLAI69aUgKKARTU5qCW6ElInMR4UyhqLWA58H4nOeH+l5z2fOGYW1udxSih+V0FSAhTiHxNVMCySQLWhVwyK4ubWj/xapqqzNO10qVz1ie/agzhoT3mQkupPGJvQdEOzjbKpZMd7gl4g5n+qVN93HqYIvRa10BgszNqO01u0nTs/Q1LcmrlDSjcteQTDmFlHGjDCGE4+ZuZU7Hef5S1I6HfLM/STi8ozzZBUc0Y25iM2l5duj+R9B22BHZDqB/7ekmP0LUxh05Dsu/ByurkgzLBiPDgNIke/lEQtQsmjqkiBu+TZc73UH1szyBEk0soQxiNhJAkxcok5syjW+PYxY4dC0DqJwEvWozPIJCMJaGbyVojsJG0xfJtyBNKocfjOwVt7AiDSJLsNdLFjU4+zS79P9OkCgOVLxXeeUhn4vwJVN8t1Z5cJu7eQNvfIjZXMnK1pubOe0nx7YY0Cxrg
 ThTiOIbR
 nJpSsoroPr/F+XuIWK9ZEJKfknu5c0eC5U1vRf+TyIPPAL+QA5V4N/X0DA/KFPgJ9QIzzRVZhROPVXh7oGxApdO0xphMakAJohT9urHsXRJl2q+PAGj18a/eP+AYSyJf71OpqLyEkyRgcQs14o62Tcx1FE5pdwG5uag79eOCw2F+foe+ThlZx7bVH4994bLsUvaXSZjWkBzFQMOms1xh+E0n+u0D23UpIXpIyqDkCQ0aEVCgwH/POdum/pAEO+8UGlo4CMN8Bo6SekShrC3rMAi+9IBry24k79qAg3jNS8Dl/TI0uQxWmYg+n0jkfG571oeFO7R3iKRcRjbHRSPgCtchNZDFxzVFWvVKKHo3wZHnL9hrb/b8kED0aOmQlkru+xBLaH50xmymdU9nK1G554apvmvcFOMGBm8zBLmI9OHIn9UVUIYiYQzDKYze0W56xHFO/di82s2KAJXzSn3IgNBp2SdBoWXGjJVZq4n9TbhhnHGmYzIKQ33isHUuq/gBjfdct+YtsOKsK1wArB9Ahm3NuzhcgbuGxFgB7Oop/2ns4hVlS+R/vbS0IGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Checking that an address range is backed by a folio of a given order is
useful to any test that builds or collapses large folios.  mTHP collapse
coverage in the khugepaged selftest needs exactly that.

split_huge_page_test.c already has the building block:
is_backed_by_folio() reads the compound head and tail flags from
/proc/kpageflags to classify the folio behind a page.

Move it into vm_util so other tests can use it.  No functional change.

Assisted-by: LLM
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 .../selftests/mm/split_huge_page_test.c       | 62 -------------------
 tools/testing/selftests/mm/vm_util.c          | 62 +++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h          |  2 +
 3 files changed, 64 insertions(+), 62 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 86a603692826..0adfe7dde7e5 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -42,68 +42,6 @@ const char *kpageflags_proc = "/proc/kpageflags";
 int pagemap_fd;
 int kpageflags_fd;
 
-static bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
-		int kpageflags_fd)
-{
-	const uint64_t folio_head_flags = KPF_THP | KPF_COMPOUND_HEAD;
-	const uint64_t folio_tail_flags = KPF_THP | KPF_COMPOUND_TAIL;
-	const unsigned long nr_pages = 1UL << order;
-	unsigned long pfn_head;
-	uint64_t pfn_flags;
-	unsigned long pfn;
-	unsigned long i;
-
-	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
-
-	/* non present page */
-	if (pfn == -1UL)
-		return false;
-
-	if (pageflags_get(pfn, kpageflags_fd, &pfn_flags))
-		goto fail;
-
-	/* check for order-0 pages */
-	if (!order) {
-		if (pfn_flags & (folio_head_flags | folio_tail_flags))
-			return false;
-		return true;
-	}
-
-	/* non THP folio */
-	if (!(pfn_flags & KPF_THP))
-		return false;
-
-	pfn_head = pfn & ~(nr_pages - 1);
-
-	if (pageflags_get(pfn_head, kpageflags_fd, &pfn_flags))
-		goto fail;
-
-	/* head PFN has no compound_head flag set */
-	if ((pfn_flags & folio_head_flags) != folio_head_flags)
-		return false;
-
-	/* check all tail PFN flags */
-	for (i = 1; i < nr_pages; i++) {
-		if (pageflags_get(pfn_head + i, kpageflags_fd, &pfn_flags))
-			goto fail;
-		if ((pfn_flags & folio_tail_flags) != folio_tail_flags)
-			return false;
-	}
-
-	/*
-	 * check the PFN after this folio, but if its flags cannot be obtained,
-	 * assume this folio has the expected order
-	 */
-	if (pageflags_get(pfn_head + nr_pages, kpageflags_fd, &pfn_flags))
-		return true;
-
-	/* If we find another tail page, then the folio is larger. */
-	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
-fail:
-	ksft_exit_fail_msg("Failed to get folio info\n");
-	return false;
-}
-
 static int check_after_split_folio_orders(char *vaddr_start, size_t len,
 		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders)
 {
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 4821a3563036..3ea42a7a2a3e 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -490,6 +490,68 @@ int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags)
 	return 0;
 }
 
+bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
+			int kpageflags_fd)
+{
+	const uint64_t folio_head_flags = KPF_THP | KPF_COMPOUND_HEAD;
+	const uint64_t folio_tail_flags = KPF_THP | KPF_COMPOUND_TAIL;
+	const unsigned long nr_pages = 1UL << order;
+	unsigned long pfn_head;
+	uint64_t pfn_flags;
+	unsigned long pfn;
+	unsigned long i;
+
+	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
+
+	/* non present page */
+	if (pfn == -1UL)
+		return false;
+
+	if (pageflags_get(pfn, kpageflags_fd, &pfn_flags))
+		goto fail;
+
+	/* check for order-0 pages */
+	if (!order) {
+		if (pfn_flags & (folio_head_flags | folio_tail_flags))
+			return false;
+		return true;
+	}
+
+	/* non THP folio */
+	if (!(pfn_flags & KPF_THP))
+		return false;
+
+	pfn_head = pfn & ~(nr_pages - 1);
+
+	if (pageflags_get(pfn_head, kpageflags_fd, &pfn_flags))
+		goto fail;
+
+	/* head PFN has no compound_head flag set */
+	if ((pfn_flags & folio_head_flags) != folio_head_flags)
+		return false;
+
+	/* check all tail PFN flags */
+	for (i = 1; i < nr_pages; i++) {
+		if (pageflags_get(pfn_head + i, kpageflags_fd, &pfn_flags))
+			goto fail;
+		if ((pfn_flags & folio_tail_flags) != folio_tail_flags)
+			return false;
+	}
+
+	/*
+	 * check the PFN after this folio, but if its flags cannot be obtained,
+	 * assume this folio has the expected order
+	 */
+	if (pageflags_get(pfn_head + nr_pages, kpageflags_fd, &pfn_flags))
+		return true;
+
+	/* If we find another tail page, then the folio is larger. */
+	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
+fail:
+	ksft_exit_fail_msg("Failed to get folio info\n");
+	return false;
+}
+
 /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 9a49af88702e..56a28ce7d029 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -97,6 +97,8 @@ int64_t allocate_transhuge(void *ptr, int pagemap_fd);
 int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
 int gather_folio_orders(char *vaddr_start, size_t len,
 		int pagemap_fd, int kpageflags_fd, int orders[], int nr_orders);
+bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
+			int kpageflags_fd);
 
 int uffd_register(int uffd, void *addr, uint64_t len,
 		  bool miss, bool wp, bool minor);
-- 
2.54.0


