Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA2A3CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:33:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C3196B0125; Mon, 11 May 2026 12:33:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 473726B0127; Mon, 11 May 2026 12:33:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3625E6B0128; Mon, 11 May 2026 12:33:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E21F6B0125
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:33:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC6AE1C04C7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:27 +0000 (UTC)
X-FDA: 84755684454.21.568A8C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id E2D88180004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k42HtboT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z8BjFrxmykx2/XZ/2m/znseSNPChDrM5GraD4H/SC4E=;
	b=C6Zv8haHewlHN9kHjM/cASlaGrlaj0Xd4xNARKyw+RmC0HvJXu98mvq5ypDokGY04VXmSh
	TflJ6/wYc38K06nHB6m+ader6RIMJXgAejngoqdIkGutNIOYW9URbYKwE8pyU12yKWsAKG
	09K3F1RLQCLQq1qDzet+gTwAR3RPz9k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517206; a=rsa-sha256;
	cv=none;
	b=1/FsJiaNg99l1EIfbf0ikCIpSJJto2ZIvdsoC2nRa9Gt459tAFfEcPrNCiiQ1WaTFN3iqf
	zfd/AGpV/d5nJJW8e8CQeUjQNCPYE1P7fM0Dgspb46srJjeYe6xye6j2jgLg4nmI090LdE
	bG9SsyyIWVGnvC3q8KOCdd5Ahj54uII=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k42HtboT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E82DE417D3;
	Mon, 11 May 2026 16:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9ED1C2BCB0;
	Mon, 11 May 2026 16:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517204;
	bh=VvPKft7e4UoRoweRQCK7NLFIkQJlSJ9NiMh48taBM8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k42HtboTV8WAKRm3MxaH6S1Fe0FPHMkER5ce0wi0S+aT7ULqqZAz4NMQA1WDrjSK2
	 SvvFtQ702xMTDD/uAf969iyT0LGZEEmh9HydRh6VzswJQ4j2uX2wng1vRPDyUpZu2v
	 A8oq6F9wNCzYg2P1BkL+mnL2XxTWivRWTo88zCh7RYPb55j+S0erpB597LyFGba2rY
	 sDIyDl0Usd4fP1U7SBOV4c3tn7cJ93nJR+N9cq4W60YOGraMpIy4qwOUjUEoTu3Zgv
	 iU51eq33HRgj0FYan7F6IB1NcN1YpTEOWc8qoVb/f5VJMGRZYAYOcXIk7ObOhfF5I3
	 bLuJMLVxPSHWg==
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
Subject: [PATCH v4 42/55] selftests/mm: hugetlb-shm: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:26 +0300
Message-ID: <20260511162840.375890-43-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E2D88180004
X-Stat-Signature: sa5ci3buqjnpng8p4uw1ae5th6s4ssfo
X-Rspam-User: 
X-HE-Tag: 1778517205-735322
X-HE-Meta: U2FsdGVkX1+KwXPDG7VJvc0Armc/ZSE17wh25QBDN9yZU+obDF14b3+PNkbDa9iJT1PShs20665a11amIaY1c6+c1+MFelTAUqCyiw5Io2once+HDOseWnjf4hw2aV7YH0N/w/mku9997PAdMybyOW0YSfkV1qxH3XIN7zVkG8ejXVyJL21YkpOepaYxFwtiAdKhghbyY6LhBssbNknnTeK0ea6Duwo8GqYn7MuYLAgKYn+3PkP8Mb/Ky3l0nbwgrT/QwKkLgoTYDbwDjwCOs9aaL8u0zx5BydIFYIWKTCaZtipCyhKjzq2WuSzgQrd0B9ZdS74B05rRpdUyKZVO7ZmXCxPcq9G8TvVT8i9wIiCwLnE5SY3eemKnoQVk4Qfm6Y3wTd2qN7mCLHuhsIHSHhoxarzRyTh+ctxFqRoQBJH2fPpl9TPKGdoY+V5f6N5mkPK1eNAtDKurSlue97ewadwp5VTcAC3Re0157hV4hTFWd+smnz6cxx++WjAg8der5DE/diVz3uM6F0qWzA4PaFhWJRp4sQ+gqFOz8eUVxHZnFIX85dGnq6icf3iRFjKy4pYU/SiD2wc+G8YVIUElgrjqdoeFSq86P5AK9tlo7XzHTjyWl+1/rmPzffUgbqMvLeN0rTnlhp9JbBKPdY4W6pQo7zgjDphcj893F6U7QWHmwI+Shh+fft7lXcUw26PnC6seoPgtKHRmOs9TyTfnVIU6qSCYfd2VPlBzMjw+ncEHkq/d1XMBxlMZbW+I+Fn6YDWb4l6gMy9DiKcXJswufq44YARY4zp78KEWc0e9w+n0tQwjsh7h/6MVRZc/HAUopV2KwDRxTnqXivdNYSeYOBugom3MYcf3ltreA2i8LCDCkEODvoc3Tn2hBxyffVqhNQ2Z3VeQBi1gx38vMpx8IabHtXak3JWunyKm06GdNye05ZbrRdhG9jopfWsNJLyqPeZ/gNwdpI1XuCL9MID
 CYBP5KLu
 jJroc1rAVotpKDy7FFjJ9n4GmopI6Se0/MLnE5UtagUHmcQGLJWoZWvRlBuCasZJREyJTNpDhWnDR8J+rQxa2xXkl2Rj8g2NuwdDVOzWz6E6UXKZQKteAIUuMnVeayM7BoSL4yLqF4FI6Utw1MmZPTNhDoauTblGh+HTwkTO8m6LkeIABEaya3GxhV/s9Kr2uliTVZxUDlaDnA5gOV1kxWFWkAoEJtP5KfCO97K4EE3dBahVF7wO1zqQT7TOCBAuT8n3spOTMzwIzpJB7IKf9Qd+/sQNsA+b/UKo1UtmjJANamemBJDtbd3pmEGZLznrPiqsN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-shm test fails if there are no free huge pages prepared by a
wrapper script and shm liimts in proc are too low.

Add setup of HugeTLB pages and shm limits to the test and make sure that
the original settings are restored on the test exit.

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-shm.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/mm/hugetlb-shm.c b/tools/testing/selftests/mm/hugetlb-shm.c
index c2c7aee85b96..3ff7f062b7eb 100644
--- a/tools/testing/selftests/mm/hugetlb-shm.c
+++ b/tools/testing/selftests/mm/hugetlb-shm.c
@@ -29,9 +29,27 @@
 #include <sys/mman.h>
 
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 #define LENGTH (256UL*1024*1024)
 
+static void prepare(void)
+{
+	unsigned long length, hugepage_size, nr;
+
+	hugepage_size = default_huge_page_size();
+	if (!hugepage_size)
+		ksft_exit_skip("Unable to determine huge page size\n");
+
+	length = (LENGTH + hugepage_size - 1) & ~(hugepage_size - 1);
+	nr = length / hugepage_size;
+
+	if (!hugetlb_setup_default(nr))
+		ksft_exit_skip("Not enough free huge pages\n");
+
+	shm_limits_prepare(length);
+}
+
 int main(void)
 {
 	int shmid;
@@ -41,6 +59,8 @@ int main(void)
 	ksft_print_header();
 	ksft_set_plan(1);
 
+	prepare();
+
 	shmid = shmget(2, LENGTH, SHM_HUGETLB | IPC_CREAT | SHM_R | SHM_W);
 	if (shmid < 0)
 		ksft_exit_fail_perror("shmget");
@@ -76,3 +96,5 @@ int main(void)
 	ksft_test_result_pass("hugepage using SysV shmget/shmat\n");
 	ksft_finished();
 }
+
+SHM_LIMITS_RESTORE()
-- 
2.53.0


