Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED983D73EB7
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 04:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3DA6B0005; Thu, 29 Jan 2026 23:29:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D71096B0089; Thu, 29 Jan 2026 23:29:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53466B008A; Thu, 29 Jan 2026 23:29:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B4E036B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 23:29:44 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 311C813A9FE
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 04:29:44 +0000 (UTC)
X-FDA: 84387351888.17.8208F69
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf08.hostedemail.com (Postfix) with ESMTP id 623C516000B
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 04:29:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h96SwgeZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769747382; a=rsa-sha256;
	cv=none;
	b=TtjvSshrSlPbCzYKl3R3d9JJBKAKF3OUfYBK8fOVUHAbRlaWaHkBN8KzqjnQeEPdQWuusr
	V06AF0hQJqJ0VgaH5tMpouea1kX6IRdF7KRdZ0YcrALFnuL8+mOhDdIxkZa6vJfYLRQ7aO
	WEl8Buh5cYHsIl8muk6O9v/7IwOmy9I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h96SwgeZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769747382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gXklUk6N1YogTH8BAIYkPkvta0Ydd8XfF9+GbqyXKBs=;
	b=iNU9RNYkAsQAbKiR/jswf8L3YB1J+m8ihMStxAt7SWh9AhaEGvDkizczg4v4SzqZJZWe+U
	6WIafOpEtre2MoTQFkC/EFN+ch85fLhGZ/+nnHtOFtXqiRRDzLJ5fyhIyCEIN2kDMKHVW9
	TgpFofGqi4pGxj3RVdiObjytz0sCjXo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769747378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gXklUk6N1YogTH8BAIYkPkvta0Ydd8XfF9+GbqyXKBs=;
	b=h96SwgeZWLx0lvw1WHXU4jVBCr/0kn7+7UP+V6RvJOoq9NybvulozWhUeyWBEznu60ssFs
	igGY9MTTKJ6pUv+wNV9JWnW3MZyohYvuF1AVM8kiSYAjyLVaKRa4di9n+tufN3v5eqdYEK
	MwodB6qvmj8DbnDhutlyBdlvVb9krJk=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Rik van Riel <riel@surriel.com>,
	Song Liu <songliubraving@fb.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Usama Arif <usamaarif642@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm: khugepaged: fix NR_FILE_PAGES and NR_SHMEM in collapse_file()
Date: Thu, 29 Jan 2026 20:29:25 -0800
Message-ID: <20260130042925.2797946-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 623C516000B
X-Stat-Signature: 6dhugx38sj93dr6p9joew1ri1uenrbxh
X-HE-Tag: 1769747382-625450
X-HE-Meta: U2FsdGVkX1+VfcoDTRzMdrN56FADcLmLualDhXx98QC58cEdhX4DkOp0nEHQmpl5QyykrBaNsk1no37byvBgGoPJcC6v3+2wAKKEKD0RhU7ivyapIYnvIG9JeoDUkYBrXVmIE3mJRtaFo+LHCB9mys8aC5wZI2gvjdxlBFq1jbvb+Hs3jYRWc+cHJk6a+gtqmBckLawP7JDADaDmbF/8JNLI60r3KrtQW8f3ga7FC8ta7Zaam9bVbavNoakmVY8XR+/zM51mmvUIMHEBXD0Ce8gQ2ohHLfGyofdv7iLsmfF9wfElyLIa+I4728CSU9wE0cH+TZF9BpDf9XiPezcMwRQCeCp7T7NpJ43vaqeSm05nOW548+nUIaU8Y+1PCRrY/6NcSDeFfPHUVtGIq8MTdWOpL+LjftIfwKEAgrXEOETqq6Vm44b5WUJCPa9ikVhrhkohcvRF9dqpp3D0BBJlVATzYNzoaTK9Ye6OQodcL2Q7Lr6NPTqEdKZ4DP8i5hJoORSwMx0Vn7ykXLL/tXyCoMuiUamhwUqLL5Xniq1EgdgZEhAK5dIwgbmnylCGW1BI7TM+NnoBVzdFCLfaS0qiV4zpptAH6F0j+tWEnELv23Sb9p1wuc7yZjLwyXgkyb2ukdsXGzasrwJWXallSi4/ANSYWI4/6QvdHGsvSyQcEiLV297Rn4bY0zz0w4ZSjM+Gc0lgk8XI7Oc9oho9z8s2YvWJ6FzOFbQDWD2PHSwH/ZmcKRaOfaCaH3Z0agXdEHdR8gDB4FNJ5znCFIiVm/tH0L+uyAWwY4zjET/vZe2glBRXCZv70Frtx+lBU17OE6cSqqbdkGtNvdm7JnzUWvjN07rLIp36WbDMCjc5d/a5Q3oiEqoAg5NZ0cJj/QtkvWICXOV5J1BC0jC1CyzxoIH23myuFsghLqdD8mzs5jQq8jB5Uu4f34qdznPV8IWUL6nnc+3IgltW8oALGj3zE1z
 2oP5pkDY
 FrLywY17Jmg/3hOrWldd/Jg1FoHzGTFx0fFxnin2ivxVVyzahmQ2dtYq0Uc7csuYFRT5km3Qas6PuiwYVTf6iFGJ3uZyvn8+Y8YL3P/Iw9T8YnVyCvmA78xC4w50HajNtDoYGwyu+NiH+TQ1XeS83vSIXgxOu1wjAwN2AtlEdznWPZoCecz3B/4JuVMNQAqRt3q5wNxn0HSQy216g0vH1H4hNUB/WOojMiCvx0xsLDSadvRK3Z/X7MiF1ojri4F6ha2e+xI31tjqsRydRVjVcKOtGfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In META's fleet, we observed high-level cgroups showing zero file memcg
stats while their descendants had non-zero values. Investigation using
drgn revealed that these parent cgroups actually had negative file stats,
aggregated from their children.

This issue became more frequent after deploying thp-always more widely,
pointing to a correlation with THP file collapsing. The root cause is
that collapse_file() assumes old folios and the new THP belong to the
same node and memcg. When this assumption breaks, stats become skewed.
The bug affects not just memcg stats but also per-numa stats, and not
just NR_FILE_PAGES but also NR_SHMEM.

The assumption breaks in scenarios such as:

1. Small folios allocated on one node while the THP gets allocated on a
   different node.

2. A package downloader running in one cgroup populates the page cache,
   while a job in a different cgroup executes the downloaded binary.

3. A file shared between processes in different cgroups, where one
   process faults in the pages and khugepaged (or madvise(COLLAPSE))
   collapses them on behalf of the other.

Fix the accounting by explicitly incrementing stats for the new THP and
decrementing stats for the old folios being replaced.

Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/khugepaged.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1d994b6c58c6..fa1e57fd2c46 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2195,16 +2195,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		xas_lock_irq(&xas);
 	}
 
-	if (is_shmem)
+	if (is_shmem) {
+		lruvec_stat_mod_folio(new_folio, NR_SHMEM, HPAGE_PMD_NR);
 		lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
-	else
+	} else {
 		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
-
-	if (nr_none) {
-		lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_none);
-		/* nr_none is always 0 for non-shmem. */
-		lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_none);
 	}
+	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, HPAGE_PMD_NR);
 
 	/*
 	 * Mark new_folio as uptodate before inserting it into the
@@ -2238,6 +2235,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	 */
 	list_for_each_entry_safe(folio, tmp, &pagelist, lru) {
 		list_del(&folio->lru);
+		lruvec_stat_mod_folio(folio, NR_FILE_PAGES,
+				      -folio_nr_pages(folio));
+		if (is_shmem)
+			lruvec_stat_mod_folio(folio, NR_SHMEM,
+					      -folio_nr_pages(folio));
 		folio->mapping = NULL;
 		folio_clear_active(folio);
 		folio_clear_unevictable(folio);
-- 
2.47.3


