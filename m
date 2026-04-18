Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A963F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:59:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D14D66B0284; Sat, 18 Apr 2026 06:59:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEC906B0286; Sat, 18 Apr 2026 06:59:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C02796B0287; Sat, 18 Apr 2026 06:59:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AD0FC6B0284
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:59:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 806FF1B8047
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:57 +0000 (UTC)
X-FDA: 84671381634.12.BF81AA8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C67A31C0007
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hck/0fD6";
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PUYzOy/oIyWF+FJuYfujbmuxlVziUD4hD0mgHQDxE90=;
	b=6NhsQZAjAY9Se5yJB8nuXUVtVLGttjBDTZSLVJo95bYyodGi2F9YBb7Ylw+gBw8ZYwpclF
	wRytASJRr3U/8IJX78kaWYJSl4XwlzaVU4T+rWfIXmnK2b3GaxCBwftMX9uCRK0Y97a5Dy
	KQDIGI7GP3verHCb72i/CHrHJRSzdbA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hck/0fD6";
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509995; a=rsa-sha256;
	cv=none;
	b=Nckr2ISsB9yM4+QuX1nuUdrtCYeQmhsii+sEV1wQyIXIkQtJQkXFPbQ9HWzTpjaYXb54G9
	hqBW69sMAPjlrTH2DwbHfjM3C4goHNGDhpM/7G+SYlGRpkdYFP4B6urTbp9p69fuTIVcPb
	7dlftFFTi9xVJdr4pJPgt/eOFaywFLg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A936042ACE;
	Sat, 18 Apr 2026 10:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1107C2BCB5;
	Sat, 18 Apr 2026 10:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509994;
	bh=CuwM0pZ3/JhUx+ejuVCSFOxrDGLqHKrdn9rmOFHqvFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hck/0fD6kBeRmYUelAYLVSVRScYzb8KKajzyxSdM835XQp9VAOSH/EmXsnmXbxnpc
	 5XTHW+uOzh9NxHY8osB3U8utoYYAIdaJezyI75KH/bHM137fHmdoIu1VKmldX1fluo
	 mvAfrxUe9dLeO+N+K7cmgs+teQ0FCdu3JjQyGDAgk9DfUSQ0yeIRRqCCGh/V1y1e2P
	 ReHnsjQZ8nHI/Asv1Ws6S4iDHbRURH7oJ6+kwnEmUgaL2cqrUZS9R6p7WIWMywPxth
	 Fty5rD7gVAwqT+//KtpNeyeRNt/qYAHqF2SMgTNLeI3X4nrytDJTiUpHYHQpLI7F68
	 7kA4dorkRNF0Q==
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
Subject: [PATCH v2 40/53] selftests/mm: hugetlb-shm: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:25 +0300
Message-ID: <20260418105539.1261536-41-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C67A31C0007
X-Stat-Signature: 93j81581m3faw195i8qqx97ya9tf6rqk
X-Rspam-User: 
X-HE-Tag: 1776509995-732591
X-HE-Meta: U2FsdGVkX19wELDcV5e5l5YZwMDQoZY20kXUMalbRMJCCz7skQCOW7F3G7Uv15DttcDj8EeVQB14T+eDxtUYgM60Ud7fkg3F2pPgl/xj4eNaS7beWKlpt6xtWfoXsRtv9yKmXSf//jZyXT6y0IL1bd1Vba2AOusVSqHU3YbuZGzCxHtwFuD9XOMzyKN/LF6klOAagRTHy0hKMTDo4Qmt97Vj2IWJKOZEnP71wQ0ReCW7pLK/YdeXAQzYtVJMA3yqICs0G5ddL3tZ/RL5lfKrKQWifGDxKiYLTdsQHsHCDPcgm624Js2uTDIb0S6aXkkgiYxio2ghPDuFKGkUPDCC9AwRjVy+tzlPAN9r84H7T4PEF+Po6+KNmcpe3ewLaBf05yxqRiKfo5Is9bDodcwP26jTQLE5gJfI8Wwi24levZzSdr7SBZ6V6hI6XkjZAxL3/lRGkFjmrIKmUNtj3XrJ06jBfkuVz27fYqDPDXZA6UlsSzSHE/NrTVP0qz99h1uo3BbO9g5S0PAgLC5BhppN24eFdyTiCvYrTok1TD+AyU1vJtEBitE29ca3qUwtmPzjOixOoAFy7j4O6y0vply78gK/Qgh+RkG83MR9X0LWox7abihlOj7JG+hDL2xomeNoktTfC9oc+YOdwBuwSijRaDEs0VqxQ9F3luVOejMB1yhXxGtbBNccdRqtjeklEVuNK1w1XRWPh/wPdgE1LM7C/GpMC8u/x7XwV1vuWE2AR8dw25veRYoCn3c4tIzfeBrfbeB6zHOJfIIqNzzk8gFY4n30iOaKfWKzaeypS6vmJHPvsCSHyRF4/X+CLMBHhvo8xUUojGchexs1O6JIsAfDy9vxVVac2JvKvGIOyJxaTuvoTXkphFnZdcfSKfYaTU48tfIx2cuQ7qkhJW2l7iYSXOdEJtz38rCPTsgSp9zCrhNi+TwkDQGZbyDlkptZUyR1VaNGTSo094GKZlnfVv8
 q/Fatrgt
 56Ea3NOQ5Tdc3Veg2dMRyTdYsk8pjceEUTBoEqkcOkselbWdfmmHccbuj2iIuKONNLxLNxy43qS/uaHaD0iQLNKsKKrIdNQTro0d72SKeGqMbLLoxCkcHkL4nechplFEduCDlxDvw74GsK4GuYgz2gVirCguauxc6UrfVtOD3bbQcCmcrOaC/OhPKR+BOj4Hb4WKlorP99DwC2vAnXoy4qynLJgztL5eZXC7+e1+8JBBQr6c=
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

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-shm.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/mm/hugetlb-shm.c b/tools/testing/selftests/mm/hugetlb-shm.c
index 10e4baa091f2..e721ef17974c 100644
--- a/tools/testing/selftests/mm/hugetlb-shm.c
+++ b/tools/testing/selftests/mm/hugetlb-shm.c
@@ -29,9 +29,24 @@
 #include <sys/mman.h>
 
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 #define LENGTH (256UL*1024*1024)
 
+static void prepare(void)
+{
+	unsigned long length, hugepage_size, nr;
+
+	hugepage_size = default_huge_page_size();
+	length = (LENGTH + hugepage_size) & ~(hugepage_size - 1);
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
@@ -41,6 +56,8 @@ int main(void)
 	ksft_print_header();
 	ksft_set_plan(1);
 
+	prepare();
+
 	shmid = shmget(2, LENGTH, SHM_HUGETLB | IPC_CREAT | SHM_R | SHM_W);
 	if (shmid < 0)
 		ksft_exit_fail_perror("shmget");
@@ -79,3 +96,5 @@ int main(void)
 	ksft_test_result_pass("hugepage using SysV shmget/shmat\n");
 	ksft_finished();
 }
+
+SHM_LIMITS_RESTORE()
-- 
2.53.0


