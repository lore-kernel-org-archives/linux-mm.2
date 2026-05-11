Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E788ACD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A7316B00C1; Mon, 11 May 2026 12:29:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558416B00C4; Mon, 11 May 2026 12:29:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 495EC6B00C6; Mon, 11 May 2026 12:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B8A16B00C1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:29:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DA3841C00E3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:29:24 +0000 (UTC)
X-FDA: 84755674248.11.1C11AE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 43162100011
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:29:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fl+YKUVU;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IM8N9cD/de22K9h9eMA4yKwJoy/dTO/VQ2iqm2++6EA=;
	b=G5JLyv/cF7ssVeYUu6Q9qeEaUPZtHoDU7P0lkeF+nEJGdY7+6jR3swGTtH9GSsWeH68pH2
	Rwoqp94ERCcvCLPOd48iFf92Alb+mtb6zU81LJjpXykhdI2JM4lPM3M8R5RFciYWPMuVt/
	nPEz8pl/PQ8Z32/V4rCN647oB5VnQD8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fl+YKUVU;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516963; a=rsa-sha256;
	cv=none;
	b=a5XpLwmHxUExLemuoL5wyfuafAHWj+eu8hnle/NHbIwkstHMNa7TWHdy4pP54VR9wqdWG7
	7djZOJ8yxHfCGfJsF8Hu1612+V8K8Gc2cSAqIzCjxJGPTdEZ6ivAWS3mRtMxyUXzJSJq3B
	pa4iyQVbFUG3FJB/p0gqDf9kSvsbG74=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C776060126;
	Mon, 11 May 2026 16:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2D3C2BCF5;
	Mon, 11 May 2026 16:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778516962;
	bh=zhjARy9ljfabBxOe2IlzFCWLsSTMxyOB0v613c3jUpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fl+YKUVUg+j7xgkf+CKEpIeEb9gvv+l/mxRhCRLm4URzO9NL0YyNuT9qJokTu5gQh
	 FpUlDzTHkRjNCM8rEekjrupWlaQdbqksFVaLeG2U0JUphQb8S4kE+mB90NiREIIipi
	 EdbxcA2cyRu1ywJPaBwiNpWZGPBhZiac4GcplFIxqZSefT5dIuiFIu92Oa7P0QVsn8
	 peqPdPklgsLv49VWMExhKaxfj74qr+5QH538MQzO+FzanupyFaDbESKykOb9/RvQKo
	 yFOuW7yc+ivYkHRCiQ25Su52N9V8UfdoJnLqE15REjPcp3CBQE9iqs8L7FRLVDcDcr
	 pENXAZoQKonOQ==
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
Subject: [PATCH v4 05/55] selftests/mm: run_vmtests.sh: don't gate THP and KSM tests on HAVE_HUGEPAGES
Date: Mon, 11 May 2026 19:27:49 +0300
Message-ID: <20260511162840.375890-6-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3prgkp5qpoc1en4twm45n9poxj1n6bfo
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 43162100011
X-Rspam-User: 
X-HE-Tag: 1778516963-843606
X-HE-Meta: U2FsdGVkX19dHaUl9mBSQ6N6ebzYcuJD9xzdiGzJjZDLamQ+3KBgC8ks/fiOhYfnQ3vwcrzy1RfzsM8jZ1fYA8minlo6JH0WfFmhw9Ms1WGyGUKotKK3dVnDB3M0tPdkXC94daNfxSjPhJDl9MtnYmOJFMkjHG5XipxU9zEr4vMYKTQhcp2MXy+NTULsxsP5AUn0HdhAR4fRn23EZj9FVc7IjJe3CaXhZhik2Vs4B2LrOrkES3w0svcP0xya5Po1Ys7CzKe57798KbTbF8i9vE1K/isEHTydY+3TB/PSQghMCbxNg57PO3ZHw/x9OOYOE50xGVtuFSR/USPQT/JaPGCGG+CK5kQkF2ZYGK+NYA08F+Ct9z4cxrX+XcIZVnBvK+KQOjgiuMn96c35XRqHAEKMCWlat4rZxRpyTi4GVuV+pH4xiv+AmlmZuPvuz7mapZlSvykCNlqjbi+Et0SyTGQFoZ39PAzaZqYI395Ka4ORdAvIvTbTQeOUO3vnrE4Osbx1oh1S9Cj+iMLYaoEp7Aa72YG8KD4Q5QknnZQqQjTG5+grInna6DHCSzQrHit2/jL2mI0q21cpJ0q98iHAGPnv80eYsDIjo72jYTA8oCLo5+AB5sAE4eCSJtW4pb2aX2Wl/WsKwTeWZkq0l0Dh0u0WxRWbwt994SFsVrAK4FV77s2NV2/GIyZiRFpxIBSU3RUE1n++sWL5Ki3f3vh3e3BKvVAms3KZlU/8egGpWFzBDK7+FQWypX32goMezNUB1OdkkiWfeyVJDqXThTIvEpe2ikmiz8Vrq+w+A0FadT8F1iuafbPDLa3qucKNI+BdSNZL9Pw2X6aGxW6O21jM6VflRL5IXPeTnSWz6gCS1zHJ4dBwNtUTWzVAZ5c1lNoqk3TSGfK8lLTQlPWfqxy6ARQzKTkGgp3vI15yih99In6n8fLK7v93uUT9znqiRpzsE7JPj6E9PyGgyTbucKt
 4IM2Pig5
 +a84SDhuHEDSEOc+wJpygqdJesVE/dItK1gMUVDnSP5k40NRi45NkVYOTGeGnP6SHElorAlUdfcujlqz6NtS5JxpSHiWRfVaogyDXs02IYAIOlk5U5t4CzQ/RGkxaQDBG+cP2XXfWi0DudgOtBCpiCHfyWVlaYgMtl7Nji+SNq2U6QoGa6u02DOF0UBjEPdQKL8CwUQzwg0JqnxInZ2faHpsE/OY2OuaL2uJGvJph5WjLWnXW22aKj/lzbW8ZRPJ9nOb2aYYbTUNolZgHnRfwUdAbODgOq0LdSqd/DnMvqBvNBWj/UuUjLqfYwQ==
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

Tested-by: Li Wang <li.wang@linux.dev>
Reviewed-by: Li Wang <li.wang@linux.dev>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
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


