Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA2FBCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3266B010B; Thu, 25 Jun 2026 07:31:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8C06B010C; Thu, 25 Jun 2026 07:31:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B056E6B010D; Thu, 25 Jun 2026 07:31:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D6096B010B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:31:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 32E831A0558
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:00 +0000 (UTC)
X-FDA: 84918218280.21.3E64C18
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7FAA4C000C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:30:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="fGeVw/tc";
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782387058;
	b=4YdhTADaHFPK4fT6tC98A1uKzuLE5hLIMUzrCYpnlYLggE3WhW/SFhVF+hJX0HwpctQIHg
	OHwfVdG85h4L7myhK8aJba4EfzTETwpyZIic046uTy20bLOKOWh9aPG4Pg6oVLIPbKdGvg
	iu8fCfkPszRvnFXiwncy1vPsVbGvI1A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782387058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BsPaog4kNgPW3FCqdshK91slNOja2dX3E4KCUd1UTG8=;
	b=U64e6Jk8bLW6OibVEHC4EPFkra0cyUhN6+ROlHjuIVODWskNtFwpmWUVgRH+1ZihclMXF/
	WSGDXBBAz0TaKeUrs1hHAgWn+orQ1EQxHQrnAY3wQYogwsNNLCyJphpdnQ6v8BpgpBq+jM
	iCwsRwzbw0a90y64YQIzX8+pyEL1SFM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="fGeVw/tc";
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E477632C7;
	Thu, 25 Jun 2026 04:30:52 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CF1233F62B;
	Thu, 25 Jun 2026 04:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782387057; bh=qIVB6gHmZfbfjR8XMIsltlHaNah8ksCbKAdOfhqwEPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGeVw/tcCrootoIsfVQzEyvJihR1IT/gQKpPyfG2UPZ+f0p9YMIzfqbw+2XT0/O5R
	 Tt48hVLDtCPKYUVM/fRRxpw6BRd4F3rXcYBux3do3SWHc4YwixZR6yH7j3YvnU9M35
	 bFbNTR4pdD5V3Wp8+6DBI1DZiSbicU9RrdLW0E3Q=
From: Dev Jain <dev.jain@arm.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	david@kernel.org,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcampbell@nvidia.com,
	apopple@nvidia.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	mel@csn.ul.ie,
	nao.horiguchi@gmail.com,
	ak@linux.intel.com,
	j-nomura@ce.jp.nec.com,
	pfalcato@suse.de,
	dave.hansen@intel.com,
	tglx@kernel.org,
	jpoimboe@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH 5/5] mm/mprotect: use huge_ptep_get() for hugetlb
Date: Thu, 25 Jun 2026 11:29:54 +0000
Message-ID: <20260625112955.3254283-6-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112955.3254283-1-dev.jain@arm.com>
References: <20260625112955.3254283-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qb9gh7qqpbbr591bm57w69whkm1haxfa
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7FAA4C000C
X-HE-Tag: 1782387058-588497
X-HE-Meta: U2FsdGVkX193dDwqvsNvPBesgCY75vTx+s130hzv2EFuKOj72eRNmgZ2ty1KmFkPFmpz/d7TQ+Jw4pVFsi0TtQIITp8NlUcOXENcGmJGyHvM6EZThT1CHFZi+X8ley0PmtCLcw3qezTGG3OY+vZYaEMhKv9FhXoXGOyUR0G76nMN97Rr3Qa/A2HuJ7/EvN47VUtJtojxwdEYflvHvjs1Fw7+zVIuGzoq+WjtUjGLSS2H3WcU3IeglO7oB5JE2Z8te9vCGhHSeM0rX4uDBwLcJO3TyXYxbA0AupOywVNRRnWZa8/DPRAo0JuCJnkWLBMJZHII89+Ys9TQqRvxYKTo/wsI6eYZJTGC0lJa+NB7zenYExEsaMRso6Gr+Tz+C+F56ni+mg50wQH1PxYBHGT8a2BSuFb7P1KDtUz456Nh03Rwc+I6SIl1FSf0eWVv1y+d/BfwsceyUiB5+bFwJRwPrHgVBSPyChlnovpIqCOiSdzAtWjr2vPFZ19rHLslxmqppcbYExeg8DDb5ycuR9WU2f7U7+uyXPS+GgPpfZ9q2/frd46LPVHIi+1+USofKWC9mskqVYcroRQ7wi7UrDNcLUVeXqdI7s8A6pLatL8Fvy+stQBJuIlR21So+MfWwIWwAZkxYW5gPN5SZE7DOkqfHlQgnv5WtK8gWPqrzB9wZo6p6xsFCP2n18EyP5+ES8dA3Pwe6uimPkPxV9/NHGzD9loAd62BPV5z/O/jq1j1hgXEaFXppMBl2pCCH1GCs4HMihmHSLFYpvzfLxovSGf2ccvXCFlvFlF2yHDfXgjkV5TgQjqUUHiMh8JSY37R+bTRZiDt776zh5PiG0mAcFSO3yEVCxCJm/MduJz6ElVE99b378Uu20K1tKzQj3NkZM7KO3zrwBhJSwh1NsRYs+SIcKxVn36iL2suuRzZ6S98pmRExygYdsvVPropQqJh2lBZtl6ErKee0q2PvUzUGuT
 fhVU6yIZ
 ++eBOJsGBNJmI1BowfLGS8GRA53EBLQKIyVhNrI8mYE+Om8QL/xuEmV0DFTj0oGthKjYGth3p7f/NtJ59+amo59XVMjyknfMPGqhpVbPQKr90OnG7m7A93NFJMNo0Y9K4pbwQSsk+dLM82m8qmyv54wVf9dWXHs9NtAJvRvF2O/mgPJGdXYQvU1pwk/wfFjXzi86k5JLpyppvbdaJLFadjG6kPPHRBsI0nEDKsJ/o+1qtIWKW+EE3aONtWX8r0cQZAs3NOVycTor6tRGRUVNjkB1YZyaD43ZL/MLEt6kQyjIFA3OuAQ0eAKL69uk18NbCBkHRcU/qWKEdS32zAqyRyEZNOZyNXtBgMWae0uw6CVs2dIEqpuhkAmYF7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

prot_none_hugetlb_entry() is the hugetlb callback for the early
mprotect(PROT_NONE) PFN permission walk on x86.

The callback passes the decoded PFN to pfn_modify_allowed(). For a
hugetlb callback, the pte pointer refers to a hugetlb entry. On
architectures where hugetlb entries need huge_ptep_get(), reading that
entry with ptep_get() can make the permission check use the wrong PFN.

Use huge_ptep_get() before decoding the hugetlb PFN.

Currently there is no path which can trigger a bug: huge_ptep_get() is a
simple ptep_get() for x86, and the prot_none walk occurs only for x86.
But use the correct helper anyways.

Fixes: 42e4089c7890 ("x86/speculation/l1tf: Disallow non privileged high MMIO PROT_NONE mappings")
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/mprotect.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 9cbf932b028cf..23779632d18bf 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -699,14 +699,20 @@ static int prot_none_pte_entry(pte_t *pte, unsigned long addr,
 		0 : -EACCES;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
 static int prot_none_hugetlb_entry(pte_t *pte, unsigned long hmask,
 				   unsigned long addr, unsigned long next,
 				   struct mm_walk *walk)
 {
-	return pfn_modify_allowed(pte_pfn(ptep_get(pte)),
+	pte_t entry = huge_ptep_get(walk->mm, addr, pte);
+
+	return pfn_modify_allowed(pte_pfn(entry),
 				  *(pgprot_t *)(walk->private)) ?
 		0 : -EACCES;
 }
+#else
+#define prot_none_hugetlb_entry	NULL
+#endif
 
 static int prot_none_test(unsigned long addr, unsigned long next,
 			  struct mm_walk *walk)
-- 
2.43.0


