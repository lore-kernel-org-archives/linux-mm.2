Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F311CA100B
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 07:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E2586B0008; Wed,  3 Sep 2025 03:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB248E000A; Wed,  3 Sep 2025 03:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4816B6B000D; Wed,  3 Sep 2025 03:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 355596B0008
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:03:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D835E13B072
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:03:04 +0000 (UTC)
X-FDA: 83847047088.04.A443FA1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id B447B100002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:03:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gwH1HYha;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756882982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2sRWSVC6muW7v9K/79DawocgKSZMBM0YbSqQ+7W344=;
	b=GHIH31utiCVV0tXWHq5tAnns/fKG9I8USy80oC5RTglZuH6G5R3g79/n/FPUFzH/50FFGY
	AqKzDyXbrh1sDNCCJE7l5NERjW/HWSc4I1c+boatxqE44Ja7+zEjc6GH4VSG2oiXisL7Yu
	xRxr8FsNzQmX5FVoSD9Fqo+66Av7dkI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gwH1HYha;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756882982; a=rsa-sha256;
	cv=none;
	b=3CEjnqnkaMUhJzJl24sBVyHXwfCkTxA4lpc+mKbRKNUhB0Z4iWPuW5In1cmWJNyMjnZcPN
	FUNJZ0JsE+1/UbuZiCAScX14rareLsrW7FZ2H6NDKjNUaV/0+V2a6hm72GCapWlsAIhqFl
	ogemMrI+myA/2/e6TXCrepOtCHJRaRk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756882982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J2sRWSVC6muW7v9K/79DawocgKSZMBM0YbSqQ+7W344=;
	b=gwH1HYhaLz75DSNCyuPXhxmkCjUNzvvuTZrYaOUllxFQJ1LTR8c1AA3tqb8Q1wthCl6TTO
	TP/jrj802ERb2EP4MJsXjkgFFGLWgRvxU9yGiXdUm3W7I1OiilaAqBDY2yB06rtPyGK50N
	dlIv4ftuxpCd0zTouiZ3n83dBv/ZOEM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-I72pBIf-PyaTjHgKd3ciiw-1; Wed, 03 Sep 2025 03:03:00 -0400
X-MC-Unique: I72pBIf-PyaTjHgKd3ciiw-1
X-Mimecast-MFC-AGG-ID: I72pBIf-PyaTjHgKd3ciiw_1756882980
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3dc3f943e6eso395335f8f.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 00:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756882979; x=1757487779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J2sRWSVC6muW7v9K/79DawocgKSZMBM0YbSqQ+7W344=;
        b=RRE45qlcXqxEWPWgd+vSyFnRG5r2BUN8CYi9QnwDNMgxJ4zu0/yYZqbMtBILN16NRQ
         tJPp4bSlDvhgA4GH2FjN7nGeRU3KC+XOuy8OKakKR2+e1H9qWWl4EPgmWxsw1oxhF/3h
         KgsHgJQQVSdbDLsawLPwQ15aq/X0IiaayUSqShzkVp+HevuZatSGhqRH5G1EmQoEHEP1
         lerUQ5ImVsEYpu1Zw3jycYnQ/jbZ4bbM1t66df4tRtT5RRxhdkJg+jrli48i4zYIE/SW
         a61OJNMsD5RP6YdIlSD4O3pVMzfSXz8mqFk/hRbjYK4lf4couEyU6bpY8y2gRnTud2L0
         4I8Q==
X-Gm-Message-State: AOJu0YxONBJRuCqOuBdGuUpnO8uJehBOyyQntF3sedaSd0AJWR0obpc4
	Z5xO7PMRgK4ntbbFd2YgxymXnZ5Zp83WYHlLUXzUoylkpZtAxWlgLUVn3OoCxfAVltgb0ympqgn
	dmpqzTu3CCyvaN+UgYXtS5f59buCMaJO10EKErR8AY+qSQ98qYofv
X-Gm-Gg: ASbGncvY89xLUXR66XIOOaJEpVYojonyy6vgzhyxMGImUkqMCR5MyRRDw5xlDC2udtI
	FqWssxiTqBTcq/34AGHbax9yQjPP4eJUClx+v45CtA/X2F76EPq2B06sjtYAUc2cY5eaVBJXdBI
	xDcBBgJmYRY1HJvjpZB1m8GSabiYvyAT7BqarvKvPwOPBelDj9OXDUSjZihO4BACzYSEciSNpoh
	UyG91+HDM1+SQN5ym/RYrU1mAh7UMdSoLkUKhq1meuA7qAUgScSUrs5NSp8VrAGlY/f15fwndZq
	auFrh+Lxmz8v0SP1dojb8gW+tP7Lll1W81/bHjRjAu5iUqaCh1S1J3h0gHwinkCbEKucb1SoAOt
	l0PEALtd+B1djCBE+wtYnZSUU
X-Received: by 2002:a05:6000:1789:b0:3dc:2136:7523 with SMTP id ffacd0b85a97d-3dc2136754amr1475810f8f.0.1756882979525;
        Wed, 03 Sep 2025 00:02:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJPnLNL5I9w+xcg7OB1s/KttczlD4Bt2mn9lDViDhx6EVKHlJPHrKwqtJR3u79EyXcvnt/VA==
X-Received: by 2002:a05:6000:1789:b0:3dc:2136:7523 with SMTP id ffacd0b85a97d-3dc2136754amr1475777f8f.0.1756882979050;
        Wed, 03 Sep 2025 00:02:59 -0700 (PDT)
Received: from localhost (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3d701622b92sm11105604f8f.58.2025.09.03.00.02.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 00:02:58 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH v2 2/2] selftests/mm: split_huge_page_test: cleanups for split_pte_mapped_thp test
Date: Wed,  3 Sep 2025 09:02:53 +0200
Message-ID: <20250903070253.34556-3-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250903070253.34556-1-david@redhat.com>
References: <20250903070253.34556-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 11-rhHQIIyVmeiMJZqEguQ4Ck1Z-7R7FsK09lfq5QpU_1756882980
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B447B100002
X-Stat-Signature: g5qmkze7upc6ahop1m56tjdsqatxmdpk
X-Rspam-User: 
X-HE-Tag: 1756882982-902652
X-HE-Meta: U2FsdGVkX1+6S+eSKY2uYibH8HVdebnu5ejFCPCO8YOWFi6JfR2O2So4m2Txqf1srsbmVrQBQ5Xu2kAJWWJe0uvMBEAxi2DGlAt/0RDfOvwCmQGyZRuWlztneIOhdL9ktu+nrpW1KPSX3CE3hLi6VY0sCnFzt212hTQnZ5cJDiz/1sw0T+m1bqLYK0s6g0jQByr9MN9fJfevQzQ9ZFMEexlhvIIxAmmSSKPCY5CrjqRkIINPUtZS1UOiUYTvjh9hMg4YNU4ksEj75XlNrI47Ubkn/VBeY1B/WnYxxDwv/JP81reJRDJ1q2bEDGw8IuFNQUW4wmiEooav+eeoGcLnuh7Fc3jeY9RGCN2YJW0acDx5daPuTRMXxVlEmf1gmWoT5uWGe4LU9IPORKgx0+6oUZqujGqBiQPbjOPoT+rFYW1c5B8gL2YtjtCfrHndlSTWvYjTX9sxlNDmgVZAVBMNI0ghKOeUHYA6rES+LT3aWFJhis+WKM1wkiWF1CEK2dZVOm9S1cWhCaBq65idK6IyWReXPA/RSR0TuWx48l/99MhM/IUCM4js8mfMAFm2BXJzvoHxWM+o2jC+KR05hYBeG4IzuTqD+aUR8yE4LXEx5YKZ736Pc9Tq6Bhu10ZfG1+Om6IL2dzsZTv3QXCHCt4Yz3qnhdBV62q8WRQfsrQa3GfVBnlsNy3Sf2FsVsW0ndzJTxjiZiRQ4w26xmcqkG9GprnGhzN3EgkwEM+0yGPv0mkj6U5PvQhlvLNf0UxDKMpI+BLvIHwMCLI4jXTRaPcBohyVnhNAKfNFNiouHssxy6DtTEKIw8j/qcl0yOHOM6qg68reeokgJJvrNmN/Q83+eX/wcwwPY+OsbASmcG9ugOI9e5F3IFirGZ9b7I0hmaBePan7I6rzR3fssjsQsQJa1Oqaoq5GxbF0xnZ1besw0ORgESjd190DEHSQeC9YE0pfk0zknpG6Ne9rtL2MaKk
 sRRuNxds
 M8XyvhYZ0w77Xdh0UIb6lTXVDxfwu+CgZhKP76HT7CXve2w/eSC5UsYQQ7nWcy8CarO2lnyZsq2QImm8whgDcvp4UfNrIpa+jJGIplY491O/oQy07NkP+JjcUwB3F8kFShZ2o12+b0qLtX9vKQI/SPB2umfg0MMOOVqd1CPb116WRkpKtO/qLWaGSIAAO554kPJaqJdRtVwy+wufwR4tOrNfRf/xZxoBPRAHxzHG2gXsNq87SAZXEqbpzAtGis4OaU9cepbPvZMNgDk1CGAxinRxYlNv9IMokKKg86aAh4jBdIVPljsKaUp+K8YHVrJnxCdzLl8XBgy1GBiv9M1/tYRaKv0A67RKPHnSOLcInJ0oaz8e97oGhhLoa0nOUGK0jaMv8Pyib2sld40GCu9FLT8PQBFqs9ACASKcE8KAPUKckfC6uU5CRz3zqqtdi18+YyDcMW2h1M/k4d/Tk+2PN4rAbah5U/rBdeg5plncZ49BisovStcCUCPEULri5+PpiLWM01V9ZhsMTzArDNSy9Ylsi1ewoHibgijAqrMLiZtMiOau7xkilQAlBBD3WtNyoeTlVsXRmCITC68/kdd+aEocHhcTZLDg2XEibZcwEQpGlpxE6DF97g38nxFjz/VD4B9PXWNilQ/OenHu8yCvcDICPwzcWijwcV1mJFiVdNyTTNOg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is room for improvement, so let's clean up a bit:

(1) Define "4" as a constant.

(2) SKIP if we fail to allocate all THPs (e.g., fragmented) and add
    recovery code for all other failure cases: no need to exit the test.

(3) Rename "len" to thp_area_size, and "one_page" to "thp_area".

(4) Allocate a new area "page_area" into which we will mremap the
    pages; add "page_area_size". Now we can easily merge the two
    mremap instances into a single one.

(5) Iterate THPs instead of bytes when checking for missed THPs after
    mremap.

(6) Rename "pte_mapped2" to "tmp", used to verify mremap(MAP_FIXED)
    result.

(7) Split the corruption test from the failed-split test, so we can just
    iterate bytes vs. thps naturally.

(8) Extend comments and clarify why we are using mremap in the first
    place.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 .../selftests/mm/split_huge_page_test.c       | 123 +++++++++++-------
 1 file changed, 74 insertions(+), 49 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 72d6d8bb329ed..7731191cc8e9b 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -389,67 +389,92 @@ static void split_pmd_thp_to_order(int order)
 
 static void split_pte_mapped_thp(void)
 {
-	char *one_page, *pte_mapped, *pte_mapped2;
-	size_t len = 4 * pmd_pagesize;
-	uint64_t thp_size;
+	const size_t nr_thps = 4;
+	const size_t thp_area_size = nr_thps * pmd_pagesize;
+	const size_t page_area_size = nr_thps * pagesize;
+	char *thp_area, *tmp, *page_area = MAP_FAILED;
 	size_t i;
 
-	one_page = mmap((void *)(1UL << 30), len, PROT_READ | PROT_WRITE,
+	thp_area = mmap((void *)(1UL << 30), thp_area_size, PROT_READ | PROT_WRITE,
 			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-	if (one_page == MAP_FAILED)
-		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
+	if (thp_area == MAP_FAILED) {
+		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
+		return;
+	}
 
-	madvise(one_page, len, MADV_HUGEPAGE);
+	madvise(thp_area, thp_area_size, MADV_HUGEPAGE);
 
-	for (i = 0; i < len; i++)
-		one_page[i] = (char)i;
+	for (i = 0; i < thp_area_size; i++)
+		thp_area[i] = (char)i;
 
-	if (!check_huge_anon(one_page, 4, pmd_pagesize))
-		ksft_exit_fail_msg("No THP is allocated\n");
+	if (!check_huge_anon(thp_area, nr_thps, pmd_pagesize)) {
+		ksft_test_result_skip("Not all THPs allocated\n");
+		goto out;
+	}
 
-	/* remap the first pagesize of first THP */
-	pte_mapped = mremap(one_page, pagesize, pagesize, MREMAP_MAYMOVE);
-
-	/* remap the Nth pagesize of Nth THP */
-	for (i = 1; i < 4; i++) {
-		pte_mapped2 = mremap(one_page + pmd_pagesize * i + pagesize * i,
-				     pagesize, pagesize,
-				     MREMAP_MAYMOVE|MREMAP_FIXED,
-				     pte_mapped + pagesize * i);
-		if (pte_mapped2 == MAP_FAILED)
-			ksft_exit_fail_msg("mremap failed: %s\n", strerror(errno));
-	}
-
-	/* smap does not show THPs after mremap, use kpageflags instead */
-	thp_size = 0;
-	for (i = 0; i < pagesize * 4; i++)
-		if (i % pagesize == 0 &&
-		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
-			thp_size++;
-
-	if (thp_size != 4)
-		ksft_exit_fail_msg("Some THPs are missing during mremap\n");
-
-	/* split all remapped THPs */
-	write_debugfs(PID_FMT, getpid(), (uint64_t)pte_mapped,
-		      (uint64_t)pte_mapped + pagesize * 4, 0);
-
-	/* smap does not show THPs after mremap, use kpageflags instead */
-	thp_size = 0;
-	for (i = 0; i < pagesize * 4; i++) {
-		if (pte_mapped[i] != (char)i)
-			ksft_exit_fail_msg("%ld byte corrupted\n", i);
+	/*
+	 * To challenge spitting code, we will mremap a single page of each
+	 * THP (page[i] of thp[i]) in the thp_area into page_area. This will
+	 * replace the PMD mappings in the thp_area by PTE mappings first,
+	 * but leaving the THP unsplit, to then create a page-sized hole in
+	 * the thp_area.
+	 * We will then manually trigger splitting of all THPs through the
+	 * single mremap'ed pages of each THP in the page_area.
+	 */
+	page_area = mmap(NULL, page_area_size, PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (page_area == MAP_FAILED) {
+		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
+		goto out;
+	}
 
-		if (i % pagesize == 0 &&
-		    !is_backed_by_folio(&pte_mapped[i], 0, pagemap_fd, kpageflags_fd))
-			thp_size++;
+	for (i = 0; i < nr_thps; i++) {
+		tmp = mremap(thp_area + pmd_pagesize * i + pagesize * i,
+			     pagesize, pagesize, MREMAP_MAYMOVE|MREMAP_FIXED,
+			     page_area + pagesize * i);
+		if (tmp != MAP_FAILED)
+			continue;
+		ksft_test_result_fail("mremap failed: %s\n", strerror(errno));
+		goto out;
+	}
+
+	/*
+	 * Verify that our THPs were not split yet. Note that
+	 * check_huge_anon() cannot be used as it checks for PMD mappings.
+	 */
+	for (i = 0; i < nr_thps; i++) {
+		if (is_backed_by_folio(page_area + i * pagesize, pmd_order,
+				       pagemap_fd, kpageflags_fd))
+			continue;
+		ksft_test_result_fail("THP %zu missing after mremap\n", i);
+		goto out;
 	}
 
-	if (thp_size)
-		ksft_exit_fail_msg("Still %ld THPs not split\n", thp_size);
+	/* Split all THPs through the remapped pages. */
+	write_debugfs(PID_FMT, getpid(), (uint64_t)page_area,
+		      (uint64_t)page_area + page_area_size, 0);
+
+	/* Corruption during mremap or split? */
+	for (i = 0; i < page_area_size; i++) {
+		if (page_area[i] == (char)i)
+			continue;
+		ksft_test_result_fail("%zu byte corrupted\n", i);
+		goto out;
+	}
+
+	/* Split failed? */
+	for (i = 0; i < nr_thps; i++) {
+		if (is_backed_by_folio(page_area + i * pagesize, 0,
+				       pagemap_fd, kpageflags_fd))
+			continue;
+		ksft_test_result_fail("THP %zu not split\n", i);
+	}
 
 	ksft_test_result_pass("Split PTE-mapped huge pages successful\n");
-	munmap(one_page, len);
+out:
+	munmap(thp_area, thp_area_size);
+	if (page_area != MAP_FAILED)
+		munmap(page_area, page_area_size);
 }
 
 static void split_file_backed_thp(int order)
-- 
2.50.1


