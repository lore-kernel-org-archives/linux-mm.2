Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA758CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44DDE6B0123; Mon, 11 May 2026 12:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE656B0125; Mon, 11 May 2026 12:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C5BC6B0126; Mon, 11 May 2026 12:33:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 157FA6B0123
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:33:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CBAC74021F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:20 +0000 (UTC)
X-FDA: 84755684160.17.58481A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 12F33A000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hiXQ1ybr;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eSdIVC/9q/NR2xw9dMof5QoFYv1esI47Iq3v+x8Ftl4=;
	b=bVGzTEraJvij4+Ck0l5GKVQT7LgPTSgtu6kwBEFgFs6osCphTpHe7rSiowFIu0SyKqUcKF
	o+BEdOymIQGFXDPR54U4APOr88zHe+2Rk7/L2gAmByRYnC+/FjegKwMamD0m9OMEX5darp
	+Hys6BX3gh144mpvH7gQkkzgjLGLU0I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hiXQ1ybr;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517199; a=rsa-sha256;
	cv=none;
	b=qjQ112V5ldGXpr/IvPuHmXw0GG83q34stQ3f2xto0TJf6mROgTd4xptzChBsGUpSetLjby
	0K4KxawwSnOSoOb09Dk/X8puySy0p7KIQUFzpg5DVlQhonaMys5NAnl4WYR/3HOgJ/61CX
	kzEJC342lHEoW9+ZrSqQCuL3NhPNrdA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9927D60120;
	Mon, 11 May 2026 16:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49389C2BCFC;
	Mon, 11 May 2026 16:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517198;
	bh=M5ApfsSYjafUfJ9qgwq5XnAC9wVA2+57J0j6FC98Eww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hiXQ1ybrKjokkKJjCSwm36wQtUMAEH2YBFMm7TL9Yr5/Vq8P+7qKZvDqLrn3yQwsy
	 eK6GiWeSaPif1iphBUI/XT8nW49DvFlZlOHZ3jaCPjuFmhZUMwDJQwuKxdoZ/w3qRw
	 2iG8Y3KRiT+6rN/pQpFECf3/+Hwmv/5tM+bU4kExEp5eVhWHwQmVbGRHBvJVicNrv7
	 zOrtZpPGUyEoX4cxaPi3CESQYcQR6x7bRQRxMIB3IJGHWlFCEv9b9tlDbyUFR6EsMI
	 45AOKO/DIjo4/mOt2aBmhrE4ebGFyvmqdlVNMLj/Jv/vH5fI75+X15mNDS2fcFKN9w
	 xpesQcidZaW4A==
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
	Li Wang <li.wang@linux.dev>,
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
Subject: [PATCH v4 41/55] selftests/mm: hugetlb-mremap: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:25 +0300
Message-ID: <20260511162840.375890-42-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: azcx8u845kuuucp7bh1uiqubtjb5mbys
X-Rspamd-Queue-Id: 12F33A000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778517198-844679
X-HE-Meta: U2FsdGVkX1+Wo+LG1ZAwetm/hX8Gbq8MnzgO71UGRD1xX9MSxp9+oR71rvHztsMS3nSozLSL/t54JKyy2/4+AkC+OWgG3fjzHMDZbq4l3t1Q7KESyMI5h/7rLvevmqhQfrpi2Fir3sTX8sqJDH6qprzSGPVvJBCmZHMWZyhbhHLaGZOj/0ClPQj3kZMAcOX9l5osrtW3E4NbfltiLYrDdo5rcO03tnYG1E++TSgCDa7j+shOIkFYM14wU4cQpm/Cr2jRSUv/T9mwbtveBZ8A0xSPr75xOoLI2dcFwDm6IRsY9IFHW3sUYIeZQephF4lemGdKX22fzJGkTlA/5tYFbNk4YmPnKfdXqFXhF05QdIr2xFJqtC++61l7c18FN9lzZfjjXEYElOnpC+NMjoUgljuTWEIxU46z4RxIKdouu+K+J5WbCZlKdQuszUBqcVVlJ8/vRyHalfUIjnOwvKd3OQ6wt1/degPHpkd/M6ik+tMnvyR8F8CCE/msDx3kn0QrVJdkdJbdo3llYHa3kFrqKCMMCzg0+0zc4t6QS/qwzAUa+NIDD8EzOaPFMr9BOU4NeevJDKxO3LN5KJiFHYDwEFc0jmX/WuXHlkk6QkrNiWsFUC9ZWAy62Chdle2eoKLc38nheJGdXmdnwUEV2uEgrTbrVJxbo29NUHZBGD19dN33bZSWa++AARb6C9XhSQx1qfmVltBFA31ZvNuvuHt0KxNsw3c/eUPl9r8l0Gw840XtqAd7BQZimAgIDr4SwRGbLrxW37sFX7waampsghm1vrtzuQ5xIwnJ/cW0pk92Liu3AjNyIgrzyIReRiI/dz6hSguLIDC3qheO1w8I0Z6P7gMGVuuiETk08+eIFG5pNW89YVgo5pFWHqrpl46KygPypOhuNQPTxM/fTPiODyytF8dgMJeX2jsCv1CfCl2CexrKsmrMKb49PVmAQnXkTExq+whG1P0NwfE+I1KcO1C
 +g1RYCc6
 2cNSL3xDru/XPJ4kOJvjtkXgJcSHLZM9lsISXKvEhvoz3YTYOjmpgWjmNhC2DDYXLRuwtyrmO2LkFufnqdbKvYP7Iv0B/sKh9Q5k/pFJLSxrzotldyAwiC2KYj5f9gfc7C3wkbV2ynZdbShSLzOSNRoZdrMeJKX8/K51/RyDpR0hpwbe/arQD39/zvAvxP+pWw2x3M9S2CandwQFc/0X+jvTm0GQRxRL+IN2uW6xfN8K19omcG0S2sQdihqfrxFC9fqBYcxAc1JyKAnhFvR407aMYkYz1VBYc2UQBd7kvMI04D2oSfdSqNnP8xFJHEszAnjKF
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

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-mremap.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/hugetlb-mremap.c b/tools/testing/selftests/mm/hugetlb-mremap.c
index 1c87c39780c5..d239905790dd 100644
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
@@ -125,7 +127,16 @@ int main(int argc, char *argv[])
 	else
 		length = DEFAULT_LENGTH_MB;
 
+	hugepage_size = default_huge_page_size();
+	if (!hugepage_size)
+		ksft_exit_skip("Could not detect default hugetlb page size\n");
 	length = MB_TO_BYTES(length);
+	length = (length + hugepage_size - 1) & ~(hugepage_size - 1);
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


