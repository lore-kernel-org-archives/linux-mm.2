Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E53B3C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 11:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 907326B00BE; Fri,  3 Jul 2026 07:43:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7286B00BF; Fri,  3 Jul 2026 07:43:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CF4D6B00C0; Fri,  3 Jul 2026 07:43:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5879A6B00BE
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:43:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 992768E64B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:43:26 +0000 (UTC)
X-FDA: 84947280012.09.28007CB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id C6A82C0011
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:43:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tVEge0Bj;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783079005;
	b=dTf4lM/CGXEJO7NKdGs+jHNcUK14GHdzOi7Fso3XayRugnq6o53TuZ0IqsAtJWU1cWp3g3
	NKa0qtFSRyOPBpLaOIcr+C8kEKldBCKYVYOPqdgYdQn9P8aYixu8XaKE5TpIg7nMfrF5NN
	06UcNEiFEZkkBeBw7QcKGPFQEgJbTKU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783079005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBfQ0Y2amoW1Wn3Q1LbOQJjLWTvXYln7NjUvp5UVSjM=;
	b=WMLeZwS6NQr+l9ous4ONaVhstfz5RFn+vYHmZ1LAH3wmMB7S9KQPolp17gKdVgaD2BL2Ta
	n+j2loIrli6I729blHR5gars+TeUbq1Z6cwj4+LkV7MNmk1sQdHJ/w5FNu9e7gV51rIxvk
	hgioZxqG3ZWgwnl/AQzJq8pZBqxn1YI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tVEge0Bj;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3DF41E2F;
	Fri,  3 Jul 2026 04:43:19 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BC5943FAA1;
	Fri,  3 Jul 2026 04:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783079004; bh=9JD/rGnP4z6sxKxaETbXjsBJM6V+qvu6dbKpCu5ZUWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVEge0BjP5FjjmbkU4psRvLiJd6bT9jhj1hm1Pa4vOf3rdbXx6C7YaGHpoigAPzqO
	 vKdTkxgcIiMBdS93gKBCSr4GR2SegSbmQlxjG4YynzgaC0GjPSQiSEhJAQWBhw6M0z
	 NnXaV/42Hn1Ubhy+dmLVElzAxQsZflcB0qbag9k0=
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
	apopple@nvidia.com,
	rcampbell@nvidia.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	ak@linux.intel.com,
	nao.horiguchi@gmail.com,
	mel@csn.ul.ie,
	j-nomura@ce.jp.nec.com,
	pfalcato@suse.de,
	tglx@kernel.org,
	dave.hansen@intel.com,
	jpoimboe@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 6/6] mm/mprotect: use huge_ptep_get() for hugetlb
Date: Fri,  3 Jul 2026 11:41:59 +0000
Message-ID: <20260703114202.365553-7-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260703114202.365553-1-dev.jain@arm.com>
References: <20260703114202.365553-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C6A82C0011
X-Stat-Signature: kjuxdj4k34et3ztiizkzmde3ina9fsg8
X-HE-Tag: 1783079004-477458
X-HE-Meta: U2FsdGVkX19IAfjVhXbsAnRCsSYjFTrdRD1L9UIaHT8Fuy4QhQPdqT9A90HfOk4qXYgj58HOV1q2PleqcYL6BHSn0DMxIUI+qwBK52jWxCJukVOXK/2LFLVDeb7vXdiJkaH4DqV/Ehpe9xFjYu4IZj9lYU0qY6nOmoW8L21HNNiQYOhgJMLzM5saCIEjpCGEFnEVREcN49WkPzWnyqWtCGUGvotbmomFiuy5Epq0TZQEsJSzF/3N9P0k8N+Dk/10d6DT0AJp7uF0s7IXIHnuanQ2Gc38cCKegKZNYaGjOJwe295E+VdM3AoBow/YXN9m+Z6Zc9eq874MKzqWyI/BewdMkUBLwNKU7ggKbwjKof1BHShzEc2LMEEpmMnDh7CiQCPFTRBfIBOqQwk8a8V6z/xNcCF8aW7Lf/g3g8bqTRFTKl8cysY0J18Pl2gZYOjM2tiHAGtseEGdMZeknzjyeL3VH/gdjb67wXiAiMgWKuPQxOW96QRfsFBHNytLBBbrAABmWziGwn4ZJEV3yI13Tnv2uBVffM+2fW/1hFbRRL/RksgpsmcXFTM3kpEUtzzUOKY+fWtARKAKcKS9jJiC6hYltvIiIrc7Awj0buYSD77T74GvuNj2UCZ2swOUd8xXD1o0WezDV92hLvMGnGyJ+8ndst44S3AZnpR41FmRUoS5ZjqiYBpof2czX5g9UJjRp3VqbLhVk7MU9C/CgcLghYMlzghtE26GTn/Gm/X3EX6Hbasile5KKFcus34UnQOpenr26IYsn+dYGcGJNygUlmhWQvZuhAH7U9nWgULARGWeFjBf1+cONlSg/3w0VPi6BzxMJF26L2rth8bilvrFJfC1MJeGJFULrdUWBT3eWeqPAwXpXkScPy+4vAktqa3GHiqATiVCO0v9TlJmVGGlyTMhR/XYtyECYKm9ZhmahOWcdq1GQKhF59WYy3NbqccKyrOHBIurjwjDBYSnuiq
 y3+DXWgP
 7ge/w6Nx3sX+PfndhkFoDNhb9bJ4cgCiaOcTsd4MDPwbNz8icsKSDXQNhqppTNpmUz9Jg+LhfuinvSPXlIvptFM322OhU7OHKAydAm3HU6tkJI5xEv5tC8xZlU52gtsVA8IcilfgFWFdPbl3/sGuL+8TZcZuwWyTVhXbp52bDQZL/cRNSrNxt/cb0qBoy/zUk/ky7EenSc+SWfJxytczcmVqordiqtwe8S1ct9mfbSJFyYeN6tr0ibvExWv0Lb4GTEquk+HCguAgZvhcidlKJ7DfCkkEmYb6z+Rq9WxaJncCkBsbSu1i8u4Ft55Fkb6ZZjPLeUFPTUSCtXOHROmRMlZ4TtzXX47tl8l1oH8RBSylRvpx1Mz4Kmw2Lzg==
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

So no need to backport - use the correct helper anyways.

Fixes: 42e4089c7890 ("x86/speculation/l1tf: Disallow non privileged high MMIO PROT_NONE mappings")
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/mprotect.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 9cbf932b028cf..6360d8a378023 100644
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
-				  *(pgprot_t *)(walk->private)) ?
-		0 : -EACCES;
+	const pte_t entry = huge_ptep_get(walk->mm, addr, pte);
+
+	if (pfn_modify_allowed(pte_pfn(entry), *(pgprot_t *)(walk->private)))
+		return 0;
+	return -EACCESS;
 }
+#else
+#define prot_none_hugetlb_entry	NULL
+#endif
 
 static int prot_none_test(unsigned long addr, unsigned long next,
 			  struct mm_walk *walk)
-- 
2.43.0


