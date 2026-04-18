Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5960AF99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DE1D6B0200; Sat, 18 Apr 2026 06:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719F06B0202; Sat, 18 Apr 2026 06:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56E576B0203; Sat, 18 Apr 2026 06:56:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3395C6B0200
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:56:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0CD31B7F21
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:56:15 +0000 (UTC)
X-FDA: 84671372310.19.D3485D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1ADD8C000E
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:56:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W4kalYgW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3HHTatSrX/E1NRUlbwJ9Tx1FoI84G0Q2QWeNK6Lnnic=;
	b=0BUElMrKwc/lebnYu54cZFnET3CVL2vI9M7+DqXnJ6Rdt7lv+gYYtdNq7eJq3IF8jBJY3r
	c/zF5Uap3wrjoZONt56Xu5pqFhimiPbkWMKGdpFtFb8RV4BVHw/yzD74t2ijODdqbvYs0m
	hkenXCHCMWJBINVObz5KNRMLNLxyuxs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W4kalYgW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509774; a=rsa-sha256;
	cv=none;
	b=WAVWKeIhr11lrGQDg7gelhz+L8EYMSocwfsEkhgxPZHxZo+xHkFxr0RW3W5au5SQumke80
	7CFuyrb6FMMUxAkoDtzvDKs1lFirhbcUqWu6++VmZCq4Grigpz4dqjqps8aGxGs/S6KZaZ
	jEewYalzfl+tnZYhWtKVNXddq8oLPBI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E5D540BCA;
	Sat, 18 Apr 2026 10:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F13C2BCB5;
	Sat, 18 Apr 2026 10:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509773;
	bh=HP6NlM6bvsHL46OUqlPVamucjfq0ryG8JPKt7QsDS+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4kalYgWBmniwZj5jnpop+e/P4c1WJC28zCTQ+zd07l0YWEcSTchDRZgZyx6KVf0y
	 8qs7Te53lSeiUUh2fnrWPA4ykN/M0r9sYMKaSee7x9FeljPHiufOPZxXGU8Kj1isUF
	 /rOnKeo17zyLHV+tpII15eQ+aaqd8AkBDkAkTLUUtZH5RP4AaNYUAVXf9b1Eyr/vR0
	 u59+/eTR9SVFjQrNE6yz7zmPn4AQ7G+k5S1xQyinmuF52ZTd6rxKIkz06z6v3CuBm4
	 RAs/zzhgT9AzYW8UIoBLwRnhiSLD05SrVfSX79iQkSWJBiQny7Caa0ERFbaBeCHHmI
	 CcnPYud+GCFIA==
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
Subject: [PATCH v2 04/53] selftests/mm: run_vmtests.sh: don't gate THP and KSM tests on HAVE_HUGEPAGES
Date: Sat, 18 Apr 2026 13:54:49 +0300
Message-ID: <20260418105539.1261536-5-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1ADD8C000E
X-Stat-Signature: bzz4qouw3czio9nwbs94rex9y6fxqjuo
X-Rspam-User: 
X-HE-Tag: 1776509773-314002
X-HE-Meta: U2FsdGVkX19DW7OzLLugmr4E5m1EQzf6uyQGdcDc6oEmU1zFIA9QtgQCnVDSHIbVqELvoRzSviq9U7BEXWyn5zc/7oH3pCaa52yTKW8gkx465X7BmzH1oHcbWMJGcogTijEypV/ObZG0blNgXWpAO3WrMDML1d+IKUQDyXB6Q79L+eEXVg6lxk7mHXWj8FoSNTxctaw1FzK79DMMFKIZGrFKSe2k6CkSEUQRP6CBHpwAKMm4wNmhukuCZ28K6S29Ar4fjBRWnNW47tyWLVxmix4jmc1s8hUZO1DfHF3qKUiIvF0FLu1oU/NH658Yro7mafOzMzuTOS0qwEq9bQrq4PiXOe1kC+KBVPxdBAC6V0j/++iBgmkpPz/v3XhjoNBULSKJh3DjRz+Tal9am6rYgpOSYThW6GUTQiWRmwG6WspyeNldsNLQwt66v+HCBKciyFARnv2hQGIn3Xnt+m2TviY0iAPG4mMTfKe2V9R9UsMhdcS0Fpb0A8y8G4Y9qNnSfKWKCXzOTwYIya2aZRjbwiH++bBFnFLepqEm9BsmWCRDn0pwwYSBRh89GSvWo2OtrhGW/GughWlL8tG5gZnh1mmbTxaLEZxUFumVvocepV6hD8WNByvHgQEpAmplDAbR6hLsKw0iSNhJ6oWIFizyqeV2HmG1VbLh9nWkBDMNf+3uW6rkKQvU10MUaadHGrQ2k9Nicq5k0rtbA7P0RJjwSPQQMsjlHeGf2JhP5pLe70wfXo3FDAxFsHYBf0bvFzJbpiZQT/8BycdGQvAR/ZiHjpbBDkfeK5VZlzg7DHOSqsJHdIeKLUPVAA3iNTbhX0acPxIDiW3E11NFrTLEp9/oBSWQAjD9FRE+e22EHscDw1tFXsYwEgaygDIHMWJmDasvCeh7sG0aFydeOloiQ+X7AMO4MVg8eJ+Bd4V5u7IxizIqlg3y/JFw8hxOn26w/Ebq/IyJ9OxNlpPPk7WEI14
 GCi6Wups
 JYqw90O8F5Ejj72LnL3QNrcrT2Dm9vGtK8Mem2ZABe0jMF9yyoVRCRAn/FJy77lG8fcS24QE0Jd4CMVAXLw0NoGU5ilUjlY3ERLyvyToIZGduDE1azu7X5C9cmQRWE8U3Imn5KLLlyXpkLJBFq4FNObEt2rQM8H0upjTezpHc6rf4Xy9V11+7qH6MNGgNNF1VqYrM33UOcGb2rohHns3p8pXFhse+tgbmMTbDtVlM/insQO7w1bwtMYyLmxXjmZ/SvnHRqD/n5CcYczaznYyCvtUOsvdAu6gt//aI
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


