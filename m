Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7157BFF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:43:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAF506B0096; Tue, 28 Apr 2026 16:43:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85DB6B0098; Tue, 28 Apr 2026 16:43:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9CDE6B0099; Tue, 28 Apr 2026 16:43:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB4FB6B0096
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:43:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7704D1C06C0
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:26 +0000 (UTC)
X-FDA: 84709140012.25.5666A24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E0EE340010
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZwvvUuOC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3HHTatSrX/E1NRUlbwJ9Tx1FoI84G0Q2QWeNK6Lnnic=;
	b=0hFMAvp5WrLoZLyaSp0YpVx3P6X7AdC3mJIyrQFpDmj9TSHhE8wngSPXC7IKt9aemdi4Gn
	fj66E+BkdW5hxuGPBPcZsBazyPqKTYfDfnOIZa0bXFfGVQ6UCwlL6IFFIJhcGB7DET+qci
	bhOjVyo/nxiLGmtPsDmmNUYjecmAFgQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409004; a=rsa-sha256;
	cv=none;
	b=aVlcaXiVxGjGH8hvBsjOFUMn9nY26+wL6jmMPcoInUFdUaA7aIl5mDZJ4z8H6IvrNrzjwq
	DliHw+tyGic14vfP0Ew1LpUpIZ8Ou2gvPssrh51cQVVAvB04MeOMWkC7jFtUUaFBZIh2Lh
	q8jyXE70hVdZpP2/+xZgwvJ+9NWtUus=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZwvvUuOC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 61BFD61333;
	Tue, 28 Apr 2026 20:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BCCC2BCAF;
	Tue, 28 Apr 2026 20:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409004;
	bh=HP6NlM6bvsHL46OUqlPVamucjfq0ryG8JPKt7QsDS+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwvvUuOCRb4mLONa62MF14/EHPDaEgwTSspNatxARqmMq9p7PjYJ4NgH0MV6SJiYq
	 nJ2muU7549az2x13kF0bn39WJjyMhy5G8zKtabFWtSig1otK/YO4pgbWcWuXTcb2aI
	 hNT1OjU+U71QwUqdO4Y2vfcmMjakL2zZoGWBT/QPqzcsDeT7/0aL/Ohlcqh6itR3ly
	 LU33nqCupVcXYRzQGOdBQMdayd9YONVYEA6Wyo9eB5uC39TKD4/oCaqPDjIaBhbFKg
	 Nr/AE0eOnFfq9U7eN9rWYZ5/Q0VxHQ4uVUgWUlZHb8T/m+L2qvWzZRmyk28qTcs2J3
	 B9s9ySwwUgtFw==
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
Subject: [PATCH v3 05/54] selftests/mm: run_vmtests.sh: don't gate THP and KSM tests on HAVE_HUGEPAGES
Date: Tue, 28 Apr 2026 23:41:51 +0300
Message-ID: <20260428204240.1924129-6-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E0EE340010
X-Stat-Signature: y7fugfb35gbgp5r3wtdkemkjtkxy9qys
X-Rspam-User: 
X-HE-Tag: 1777409004-422346
X-HE-Meta: U2FsdGVkX1/FQg+9YentCO8GeWKBZ/Ks+SLyT2iizYjx/IW/diYqSKQQp6wylm/HOpGZmX2UXhupIFoGKqO3HsNgYcZySShtqUScyRg1ifSZL4dLtuJ4RJCMCC9JIiFFzLMx0cH5+2iNMneTOuqOqwOTprATXPo8EssP5TY8w2m9CU8WT9QuhB+Axj2Pf17jYSjzx9LDyoc3gtNH+CFJUNRVSuQypSrJwElW+2SXbeu0bsjBaBAc2gW/7n0OabJcJeXJCA0rZk8gU1AkE4w4NfwUxXbO0URcl762nnOUwAohq/t+mQB8gX2Hd+iOcPH8X+NlwiXe3fC96MncxxP2XRG+Ew6iDRgYE0OOlVuWgBX3nYgu9cFNZvbvUi+rU74BhbaVs+JJA7s55iWgNJA4ABM436BHahS5u4CdjkzVsGRPM1T437BV14AuSSInVSDX9hrR+Jj66d0RcItarn/igqn2DzMzv7H5LWsqejc6yKHdaSlj2gsnYt2cRgVvWMkgiX5ga7XrmyMaoPxiYbHNmQ5P/TyKbh4nBozJ9wBwdCIs9ifCymB28mgA5BvomclYTPypWiXEBQBw6WUtyEQOIX5UNoOtm+aAQLmL2u2Dbbwp3jjhPJHYDSsVVnE499BULUKSOW4eMwyQx/VpQenJGHVZaLbgmaSkNJHdPtErKcLnrfYSUMClwUaoCO9PpbNyZsN8acGCGnNzf6MmELBwbkjvyysu8oL2ILxf0yg8wR+Iy2ZIW5NfXLKNDgjTF7M76wpvk3AnW7P4rnT5Nt2AFpR+b+9jlcYdsJUMIHP9WjwWoI7X2ldXtfmmc4HG4IFHpHwmoMS28WjokR8Wyhac2tJ0PR5RWFQo4vVK9TifLjRTUrDd1BazprwDDpd4vwTaAATpmfkjO+XcyIJdH02gMCDiW/0U5yR75d/+Z8rmXs6uSdB7mB9rXdSNJrmMIoI+gxl3XuCCLo6IQBpe9TW
 qJ9hk0DY
 4FbtK/yulXktN00tCzaMONPxXBvdS5m7VzFVSCi1qQ4Q2mPs0NMfzFW9SKNSEcWKrZUrDyGTYl5yTCKKdYreQrXQmeFt8J+afvBtVeqzx3fOx9BKOkVnDjSEb+aV0bTyR+OgCH8mJxKKcN3pJrvEOr+DtH+X5kanOsJrNxdriRJCKllQzb5Ygh46QKOrZURf1Jl/M1t6+9sFfa1P1xP1Uam2QiYONlZJxBatZM29CTwUVSIhGO5L9LLYbfM99MxlM7NEW2G4YyabNvSyBkuXJLpWedQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

HAVE_HUGEPAGES indicates availability of free HugeTLB pages. It should not
be used to gate KSM test that merges transparent huge pages or
split_huge_page_test.

Remove check for HAVE_HUGEPAGES when running these tests.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/run_vmtests.sh | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d8468451b3a3..e2dc9ac87bfc 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -436,9 +436,7 @@ CATEGORY="memfd_secret" run_test ./memfd_secret
 fi
 
 # KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
-if [ "${HAVE_HUGEPAGES}" = "1" ]; then
-	CATEGORY="ksm" run_test ./ksm_tests -H -s 100
-fi
+CATEGORY="ksm" run_test ./ksm_tests -H -s 100
 # KSM KSM_MERGE_TIME test with size of 100
 CATEGORY="ksm" run_test ./ksm_tests -P -s 100
 # KSM MADV_MERGEABLE test with 10 identical pages
@@ -493,16 +491,14 @@ CATEGORY="thp" run_test ./transhuge-stress -d 20
 
 # Try to create XFS if not provided
 if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
-    if [ "${HAVE_HUGEPAGES}" = "1" ]; then
-	if test_selected "thp"; then
-	    if grep xfs /proc/filesystems &>/dev/null; then
-		XFS_IMG=$(mktemp /tmp/xfs_img_XXXXXX)
-		SPLIT_HUGE_PAGE_TEST_XFS_PATH=$(mktemp -d /tmp/xfs_dir_XXXXXX)
-		truncate -s 314572800 ${XFS_IMG}
-		mkfs.xfs -q ${XFS_IMG}
-		mount -o loop ${XFS_IMG} ${SPLIT_HUGE_PAGE_TEST_XFS_PATH}
-		MOUNTED_XFS=1
-	    fi
+    if test_selected "thp"; then
+	if grep xfs /proc/filesystems &>/dev/null; then
+	    XFS_IMG=$(mktemp /tmp/xfs_img_XXXXXX)
+	    SPLIT_HUGE_PAGE_TEST_XFS_PATH=$(mktemp -d /tmp/xfs_dir_XXXXXX)
+	    truncate -s 314572800 ${XFS_IMG}
+	    mkfs.xfs -q ${XFS_IMG}
+	    mount -o loop ${XFS_IMG} ${SPLIT_HUGE_PAGE_TEST_XFS_PATH}
+	    MOUNTED_XFS=1
 	fi
     fi
 fi
-- 
2.53.0


