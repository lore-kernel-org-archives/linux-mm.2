Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E597FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:47:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2E7B6B00E3; Tue, 28 Apr 2026 16:47:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05936B00E5; Tue, 28 Apr 2026 16:47:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A42D66B00E6; Tue, 28 Apr 2026 16:47:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90F916B00E3
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:47:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 62F1F1C05F7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:17 +0000 (UTC)
X-FDA: 84709149714.12.2E7E9BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B5FD340005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q5frIw2F;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EaR8yeTCKZs02E0BVkQWSjQGL8ahxPBCta8dW4kYNk8=;
	b=MeTAaoqyeKjnoR0iCnwjgkc8LPdUAGLMwGDvLCfi9smGZIdvYg6gnp38vraxVFNI2BblGP
	dWIOsRJI5zoViCRKZWYCzOMLz8jXU8QECXkr6+WY13VJTYVvZh6EG+mvWq3TphxnqtACaJ
	fKRMPxCTKtLxGVT+C3Drqg4AAx+uoRs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q5frIw2F;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409235; a=rsa-sha256;
	cv=none;
	b=W1HbZYxW/8rREKW8lQebF6Y10Y9ufL+NLZ14Aoksc4mbh/9DkLjFKRHI9JbIukVstwOQyn
	B/o0l2W5cl+/AcZZmKh0zLu3fQrjXw96jeltXX3OXuYhWwtN0fYlfZ59+AT1jWEyfEv75h
	hwMYe/acizXrDBG0SCDrZW68fnn2vD0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E1ABE40A57;
	Tue, 28 Apr 2026 20:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B72C2BCB7;
	Tue, 28 Apr 2026 20:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409234;
	bh=53qqY7PQB/uAj+zPP1JxuvnMAG3AtCcj7DDDSb0K5uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5frIw2F9h3j3tr/ZuaBgEJumVaCnozxARfMNxbPw4TvdEq+hTbY/Bbhgpvs69+l/
	 yTKrQL1Les69eP+oLRVWYDb3RjY52lt0DqJZx2UHfnvMKIcQN4Bop+LlvMhhKWNQwQ
	 k8i4Iqa74XD1lFdCzKO0KQIlI4njUh2zZ3e8GpFdECDU2W37DghWfakwPnjxAvhRNE
	 wILGlLj/dKqeZZ3Mg+6D5o+EpegtLBtGvQcj21Ti8/XhRYwtj9zdpii8jojEERa7OR
	 IeDg6HWxg3oprDwDV22pRZn6uxfTqGWyxEAge41rkAddkkqo2K77p+dq5iRFd1wVwh
	 pBfLayLsjYHFw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 40/54] selftests/mm: hugetlb-mremap: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:26 +0300
Message-ID: <20260428204240.1924129-41-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B5FD340005
X-Rspamd-Server: rspam06
X-Stat-Signature: yf4rpka1dyywinfkrerxwcbewjy4fd74
X-HE-Tag: 1777409235-892091
X-HE-Meta: U2FsdGVkX1+9VSMHod66ll7JTJOeb5czlIHhPwGTNI4HLx+NNXRV0dLML11sU3K38Ze1xW0lVDO3xEkHuqHytM7sFU/5/FBIFCCbxNVCVSYqU683+llXPCMlT5tp/HTTXQHQAUwwmKwXzkloNC9YUKyrOIqgYBYFI6jIEqF1wbTPKWWrsFxR6J09ZLcN0iHMsIXBYQRW3/4/r9mC/yc+nFLTYhBszKV2aUjWhTV4liHY2MTUodwWsl3FkD4IszrXTZLPWp5Jw5f57VCwDowypzzPEdzGjjFaUE+BrGo9aZB/7XwroyKEUXVeSgY3mHsNeuRRVT/4uueln7TJ1++4amYyKtrRrtg3TPyCjwb+sZt8uoEe1qCbB4TVVcLbasgS4X0XIGQgqpgSJWRQWB3iBRX0t0eKrR4h58A02XB2VzycslZaUuZRbLs0kr00rd+Z+K+M1kr1V1Ko1zOs/ojnURN1ut3dMXCdWIsiPH5ibDp+bMKxEOY4D5bvWd44sczyaiJj6uW4wo7Aa/eFR/6g58AuxL15hhlOhDt0h5buvYaItw3xYRuWLRcPU4wt3UcY1tbmTdNiXdH7s2ACTS/F54UExDKKaFT2V/SkjkqeS/v1tFWTyaloBqa7Cb8FnwM22EeNQ4KTySjRqqXctMg4UCyiZ61WZkc883WWLRgZMKsxrr1hp+KxKtiX12xQ2cBpC1/Y+DltUMgmrsLR5cEfa9OPRw1mVB6FwcFkHtjeCYvBDwFFK8LNeTNtz7XEnTHeUUQspKSYdnZlZboUBm33d1/as7A5h0fPZqZlby/S1gBNyg+XKagc6rmGAPudbuY3Em0bkILN/IF6isTFyums8NNYD+UrBdrz2nwnTrsjlIRYCdKyUVVQXqw8IZ0Ih82g+c4X9Rupt4Fji1HvEFt4IWsE3dpUVIfgvf2dggQ+7XJx7xLI/LkULKiTk8aT4uFN0gb6tvtoTFt0tyhznIY
 8uOcxR6y
 +UE8byT+sy3l3YGlniRA65qcrp4SH+/00tOocrPAupJucAnnpHOoLA+G+jiBkpW1aW178UlqMgeczh1BFODdWdJ4Amr4ncyQOUcN25LzHMKJn+WDhJ/49b8gORPqfB9P+t3oE66GY4pDj8UBOOuAcvq93iflTQzD9Zp8Hgk/E6DiyRrJMGcQ/XhpiapwugBNA5qXWWDck89m8CjFk7+REp98y1oIynupR31YGbjDPlF2mlxU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-mremap test fails if there are no free huge pages prepared by a
wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-mremap.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/hugetlb-mremap.c b/tools/testing/selftests/mm/hugetlb-mremap.c
index 1c87c39780c5..09241a279ec2 100644
--- a/tools/testing/selftests/mm/hugetlb-mremap.c
+++ b/tools/testing/selftests/mm/hugetlb-mremap.c
@@ -26,6 +26,7 @@
 #include <stdbool.h>
 #include "kselftest.h"
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 #define DEFAULT_LENGTH_MB 10UL
 #define MB_TO_BYTES(x) (x * 1024 * 1024)
@@ -108,8 +109,9 @@ static void register_region_with_uffd(char *addr, size_t len)
 
 int main(int argc, char *argv[])
 {
+	unsigned long hugepage_size;
+	int ret = 0, fd, nr;
 	size_t length = 0;
-	int ret = 0, fd;
 
 	ksft_print_header();
 	ksft_set_plan(1);
@@ -125,7 +127,14 @@ int main(int argc, char *argv[])
 	else
 		length = DEFAULT_LENGTH_MB;
 
+	hugepage_size = default_huge_page_size();
 	length = MB_TO_BYTES(length);
+	length = (length + hugepage_size) & ~(hugepage_size - 1);
+	nr = length / hugepage_size;
+
+	if (!hugetlb_setup_default(nr))
+		ksft_exit_skip("Not enough huge pages\n");
+
 	fd = memfd_create(argv[0], MFD_HUGETLB);
 	if (fd < 0)
 		ksft_exit_fail_msg("Open failed: %s\n", strerror(errno));
-- 
2.53.0


