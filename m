Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85A03CA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 21:18:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ED7F6B0095; Thu,  1 Oct 2026 17:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19DA46B0096; Thu,  1 Oct 2026 17:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08CCE6B0098; Thu,  1 Oct 2026 17:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBFF06B0095
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 17:18:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2FA718054D
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:18:19 +0000 (UTC)
X-FDA: 85275320718.10.C4EDAFA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2FA3112000D
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:18:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Jyc8ZHCL;
	spf=pass (imf29.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790889497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sl6i3rrMXHMwq64OcowBKU4ydvJxEXr8IWC9j05j+cM=;
	b=76z1p7J0iHN36OSSC1MkcpJNYJqlPqUdyKA/NiRkDPUZrCCe1QZWjqbLp5iHASSzX7lL1Y
	+SfI61r3hu3aUm7D1vGLlaU6cL5OBuqYFodsV6C+5aehGwU8jD2nuL4j2NPDxuQunIjFU/
	DgPpWEKYOGbik8BAzz7eXn+dbR1cKms=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Jyc8ZHCL;
	spf=pass (imf29.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790889497;
	b=ByntGppalFBRgL3s8qPppoPs7BPnY8XDe9iIg4AXZM65Qlg26D6CGwdWzzHpS1IqsW3HIG
	2Tok0+NZ0Nf+bcjPzAkL0zJ+jbr0+0f+pOhwDFveerx0GPOplZvwDyhIGlDQXIE8/H4g5J
	GnHFHt1xFYSUFMf8sF/9v5vQ+wNvefs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E28FC175A;
	Thu,  1 Oct 2026 14:18:12 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 760703F86F;
	Thu,  1 Oct 2026 14:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790889496; bh=2X2FQ5S7yrfALnr5wL0BPfM4xpUXDIjXutG9mQQGSqY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Jyc8ZHCLLwHG7ZAjNektnsZz+9/XDYtttWyz6ywgnTwFBdgk0KDILlPvQJCT3DS0v
	 pZCjTNEgpZPtI86+8WsM91u0rdSQnJJmQSoEw4qwZYx7f2P7/SfK2pgbMxw7eT9Ssi
	 VCHpcdrkBuiWBq9B6kC/UNGfNwJaAJHaYaTfsz7I=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Thu, 01 Oct 2026 22:17:53 +0100
Subject: [PATCH v9 3/4] kselftest: mm: integrate huge page checks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261001-fix_split-v9-3-0f4ba8bbdbdf@arm.com>
References: <20261001-fix_split-v9-0-0f4ba8bbdbdf@arm.com>
In-Reply-To: <20261001-fix_split-v9-0-0f4ba8bbdbdf@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4868; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=2X2FQ5S7yrfALnr5wL0BPfM4xpUXDIjXutG9mQQGSqY=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqvs4KL+VYw6FuAkln8r6pGcnUOji7ghXv/E3by
 IiMsp4UQWqJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCar7OCgAKCRBt1cPRWsUx
 M0jIC/9Oy3YDlqMQOhtpXmcTDqbmS5SkuMsJsSQegOcTd3+vfXfZqnpayi20cf+I5ubDV4o26nt
 zR1Nhof1I4hMA2nEwK31tHk/BoP/2RsUCE1RYnn3R89XHG3+XiPf9LsnADGoNmNu24a0P4VokFf
 wZmO8/OJOvcmjaaQTNEuEx6zXtjwixBF02wAajUwx+Qrgy6qGxeLvABPIMLfX90lYg6ZXlYedgD
 OluxL6Tuquk3RF3i4jE2i7DdPnf6XAvpumDRVCoTrfwpH0JXq2iP3OWtcxpn4CeJkJXerkinXqu
 Hms/moyVKy+DM5tj95L7n3YgBBvRJz84O+grm3hrcEhk89cZdbMkVAApzZAsdOrUAOXkapDUB9C
 ezyJvUABMz5LbRWu0avPrt+Gz86J5UsnYhXGQYFwtiKSVoeRdSVH7ulYohSYocg6a33DCNyUZol
 o1QyLj9+m/C/Q3N2zbyknCrTAjbVZEnDiFZrEFBGrkF4bl5sIBQjHWduISVQ9Nw+K1M10=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2FA3112000D
X-Rspam-User: 
X-Stat-Signature: ix4ts41bru69mmpz6mu5pgxh8fd8npyu
X-HE-Tag: 1790889496-908505
X-HE-Meta: U2FsdGVkX18lA9ubx1YQH5hmiZ23KlSjQf5lJA3fG9XUfS09SF+syc7MQ9l+L7c6LMIKA5OFJ5UF20enDzi/Axp83LwmFJ9UUCpM/FejwskQQfUnWs+nqphNcLoVq4/XkShADixKlakSvvVSZEhCS/JIQ6IxEpQzZoCKHqgveoC9Fgk6IhSGygCIokprNI2mVpsrd0sCIny6vYHpV26d7ZgNYwy6NNU8EBdoB3W3mlHk8U0vrMsg3xvAUScjlP5h5umf8FUNiaZ/shA+i/g8FSyH6QdyX3qiI5A+CuHwqoXj5/WWB10McDNYumobA67/2u7gdn26YjQdkZBhobp6xakQDBRsEw/PZxWvxXodtY31x6fqBzVEJXckCcKsCEzOLLAN9F70jwGWOKnCr5X7Qt9utyMeI8+Ue9ksVfIEDHEU2ns3kkbBoa/tOjmrSPzjvOQYU2nhvpMDyRa8ovjBu40/NIN3u4cIuMQoX9cgSedloIQzQnuKPShwYq9WHv6HxSxT0ydcfvLssRvl56pFIGev+YmTBq7KVNa9SI0hJEx14/96NjD/5jxshpVPSKM/6f+b8LWK9rz4Ghg1f/Eeo/4KwNb+8Mo27WDmEx4Jk21JsHLGNfkU32NUyBtNR/whiJAYA1P/oMkToHnusjp8HbsXFl1hbwj+rAeczm0ZqQksaTc71HXGju3+bgz0n5+NGapV8e5Z+lzAG0rQQgC4pJVi0gDaZGN60BFifa7I1RQBWabhh1sl0FaJjDpK4df8z6eXWfv64qeQiDzj6Edc4mpyejQj3STaR9Fkcitzfe+alo1YFUKdTdp6DkxDelqC6Uy6m7hIduVad0R02+nRZNY1IOOQVUeKi8CNX/HoB57zme0s3guCE1rsDFIXdlMoZtgw90T+coF4XeQegFAriCXCzQ69ebMTeEDglISZXcNSfXJgB35JqqR9goMVux2Uf5LbQCG/9K0XboL6xVi
 8NvWc244
 R1jgB+9hGJ86qFQ8UN27/oDuWEzRojTrqfwjBZOBOXkWwJxSzC4a4/ntTay0qLe/XOh2rVE7585EOZVNdsBwTBotFxd5fve24U6Z3me/sbMq2sfzhfj4CRr35oOpYFEkl1MmBKAJuUqJ7d7dAdSl5VJWPXfYFUwulpNX9JVELa8LOnBbDAiHnclGiiSHUjxwOOqMRa8TQr+psDcT8m4NCzlpvEaBbFP5vCqHo7zDmpeEFwlO3S0QIJKkY2XqHNfws8OZZQ2rRte9DQ4064KM7SWupKkBkkXIVTdmUbij0KX5eGzmebf9/mAisBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

check_large_folios() only checks for large folios without distinguishing
between anonymous and file-backed huge pages.

To add huge page type checking, integrate the huge page checks into
__check_huge() and __check_type():

  1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of using
     check_large_folios(), since only the mapping type matters. This
     identifies PMD-mapped huge pages.

  2. Otherwise, use check_large_folios() to detect large folios. This
     covers mTHP cases.

  3. Check the folio flags according to the huge page type via
     __check_type()

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/vm_util.c | 90 ++++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 34 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index a3c3a2706c22..65c06e17c326 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -392,76 +392,98 @@ static bool check_large_folios(void *addr, size_t len, int nr_hpages,
 	return ret;
 }
 
-enum check_huge_type {
-	CHECK_HUGE_ANON,
-	CHECK_HUGE_FILE,
+enum check_type {
+	CHECK_TYPE_ANON,
+	CHECK_TYPE_FILE,
 };
 
-static bool check_huge_type(uint64_t categories, enum check_huge_type type)
+static bool __check_type(void *addr, size_t len, uint64_t page_size,
+		enum check_type type)
 {
-	const bool file = categories & PAGE_IS_FILE;
+	bool ret = false;
+	int pagemap_fd;
+	char *start = addr;
+	char *end = start + len;
+	uint64_t categories;
 
-	switch (type) {
-	case CHECK_HUGE_ANON:
-		return !file;
-	case CHECK_HUGE_FILE:
-		return file;
+	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_perror("open pagemap");
+
+	for (; start < end; start += page_size) {
+		categories = pagemap_scan_get_categories(pagemap_fd, start);
+		if ((categories & PAGE_IS_PRESENT) != PAGE_IS_PRESENT)
+			continue;
+
+		if ((type == CHECK_TYPE_FILE) != !!(categories & PAGE_IS_FILE))
+			goto out;
 	}
 
-	return false;
+	ret = true;
+
+out:
+	close(pagemap_fd);
+	return ret;
 }
 
-static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
-		  uint64_t hpage_size, enum check_huge_type type)
+static bool __check_huge(void *addr, size_t len, int nr_hpages,
+		uint64_t hpage_size)
 {
+	bool ret = false;
 	int pagemap_fd;
 	int nr_pmd_mappings = 0;
+	uint64_t pmd_pagesize;
 	uint64_t categories;
 	char *start = addr;
 	char *end = start + len;
 
+	pmd_pagesize = read_pmd_pagesize();
+	if (!pmd_pagesize)
+		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+
 	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_perror("open pagemap");
 
+	if (hpage_size != pmd_pagesize) {
+		ret = check_large_folios(addr, len, nr_hpages, hpage_size);
+		goto out;
+	}
+
 	for (; start < end; start += hpage_size) {
 		categories = pagemap_scan_get_categories(pagemap_fd, start);
-		if (!(categories & PAGE_IS_HUGE))
-			continue;
-		if (check_huge_type(categories, type))
+		if (categories & PAGE_IS_HUGE)
 			nr_pmd_mappings++;
 	}
-	close(pagemap_fd);
 
-	return nr_hpages == nr_pmd_mappings;
+	if (nr_pmd_mappings != nr_hpages)
+		goto out;
+
+	ret = true;
+
+out:
+	close(pagemap_fd);
+	return ret;
 }
 
 bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
-
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
+	const uint64_t scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
 
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
-					CHECK_HUGE_ANON);
+	if (!__check_huge(addr, len, nr_hpages, hpage_size))
+		return false;
 
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+	return __check_type(addr, len, scan_mapping_size, CHECK_TYPE_ANON);
 }
 
 bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)
 {
-	uint64_t pmd_pagesize = read_pmd_pagesize();
+	const uint64_t scan_mapping_size = (nr_hpages > 0) ? hpage_size : psize();
 
-	if (!pmd_pagesize)
-		ksft_exit_fail_msg("reading PMD pagesize failed\n");
-
-	if (hpage_size == pmd_pagesize)
-		return __check_pmd_huge(addr, len, nr_hpages, hpage_size,
-					CHECK_HUGE_FILE);
+	if (!__check_huge(addr, len, nr_hpages, hpage_size))
+		return false;
 
-	return check_large_folios(addr, len, nr_hpages, hpage_size);
+	return __check_type(addr, len, scan_mapping_size, CHECK_TYPE_FILE);
 }
 
 bool check_huge_shmem(void *addr, size_t len, int nr_hpages, uint64_t hpage_size)

-- 
2.43.0


