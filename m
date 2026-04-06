Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CE07F46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575B96B0095; Mon,  6 Apr 2026 10:18:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54C566B0096; Mon,  6 Apr 2026 10:18:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48A3A6B0098; Mon,  6 Apr 2026 10:18:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9586B0095
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:18:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFA431B7DD4
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:11 +0000 (UTC)
X-FDA: 84628335582.06.0E6A0D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 453F514000E
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eELZP2t5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485090; a=rsa-sha256;
	cv=none;
	b=uYGqtMj0iPG7u2getQJQGqzE0c4FY/zcwkHn9+m8aFGLt0QQEx4x+gIqqDdrPUe1RYU/kQ
	6xlDG7OJstzdukqQif/6gHHg5QsoDZF5KC/adFTmoha8ufnp+ry68K5SzSaUt/rd1TbihV
	yY+2jzNmenzqnwJtf7LvwY3q6WYTPmA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eELZP2t5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3HHTatSrX/E1NRUlbwJ9Tx1FoI84G0Q2QWeNK6Lnnic=;
	b=HWSBoXeqxE6uPhL2tbJqKUJyCNYWkCkVUiVlPX7D7zN+gwuXaHbqUTwpaTfG/VYH2tw6n3
	C9o2ydyxlYR52v/jteSuaHF8xhESqTis0fgM4jjx83yCfcuCFdFrC/h7Zwk+XXKvILj4J2
	HKMIR+ool1STUFZ50KwWYgV1X0bU1aE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AF42260131;
	Mon,  6 Apr 2026 14:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2644CC4CEF7;
	Mon,  6 Apr 2026 14:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485089;
	bh=HP6NlM6bvsHL46OUqlPVamucjfq0ryG8JPKt7QsDS+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eELZP2t56SEYYr6dEjupCpgolItnOiDrwIk1wz0W5Vy9Ch/B1tOSnB4OzpnrymdFU
	 R/J/THWiCmNjAJJ5/tsILSLComfIP7fi+rE0pZmtDQ47sziKEIVLrGFOwXjV3gtS0m
	 cSQuLnAxofX1UE8/gPLwyEdwRTVh8Wu+47cNS8PnMkSjgE4cR4Cm4HnmoLhvx/xmGv
	 fGc59rO9V8vM5RcbKdvRaUjgD69N8Tv8roXoKyr0HQMfMOZ1h/zrJn7qeCPSn+jGwO
	 lpRSl6K6wKW5ZqoOTLvAS+aZ1ST4dh14P2sKeeVZ6BLUGyGPseW1OggOX1b4ueNrrQ
	 PEwKZ/Turz28g==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
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
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/53] selftests/mm: run_vmtests.sh: don't gate THP and KSM tests on HAVE_HUGEPAGES
Date: Mon,  6 Apr 2026 17:16:46 +0300
Message-ID: <20260406141735.2179309-5-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 453F514000E
X-Stat-Signature: zwm55dmaemf8ch5mhapmnyb6qe5oa5g3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775485090-825619
X-HE-Meta: U2FsdGVkX1+lSSg01P4COniuuc+LGMqm8TZDD2nvPEZxgbn4oJhxk0YwBlXeZylvr8JoMP6gkT5AtN0QwhXde/eSnG+1ecNyJyv4t+xpNJbGhB/s9MHdE4ztsSutxsPrywGQUcp2K5nRWfC7vY3n+QE/hwdH7GUM8eSnb9MekBbQME8xt/zvAJpK3zWnXYjhiVNoyDGdmmhg5DTbo7bIhzAha4pgOy1SIkCERl8jSTJtgEUnwfoXYw30V1NqrWyTwwobc3BJUaTdNcR/omq3y1IiMMdoqlvuiSqWEU0piJzFOiz+5dPiO51Yj6S5ZVzPh5XLrr6sUpw/fvkR9fpvz/dyOPh58N8peXu/MWAm0EgzmXU6hEsBmh5WQFzWGCFWDtXLSSM7ntAzQ1C74edhrUkLS5pcK9AiLDjLVH/PbF4cq8EWLM0UUH2thSgqiu0BhZ++Iao66NA/2nlvyVJjWwr+eDktbiWdbecyuTaHq8gfhhr23TScSpJRNfCfoG5DgB4KLej9gsL2IIYL1Jm8d8w2YQ8hHs6REyCwItmloKDnKvHsNLpKetFnPwXQ3bK4Wnaxip6dhRGLwWbsypc80E1i+cM6GiudHeTBOH2lSLgp2+yqYkPOcTvpvuRs4aj3b1KwI5W30Z4Tf9eugIc5Q7J4weFd7OUZKsA7vZHSpFieIRhdtUvo4ZGSi/qsuQvs1IOg2+8vzxN+eoTr35LyuICDrsN6kePvMRN4gx9x4yI4wROtsBAkrgkgxAO823Y4HrfsOIU3KF7GpzJmjZYgYwihM58N0ogNwp4P7jkFHz6JdhUrMARz/sez43HDK4AMwggdq5hsG6r2+h9NwK5HFeXCZo0hkjKGnaHkt1V+m0G4sgz2I0XI4yUn2+aRj/ctoG+Q/EofTBtUZsdy3FWmgvRYd4v0G4betEBNOLlmlVgHZd7EH+AMmKDdMZzGLU5F4+rg+ZVvwIDrEpHaPhG
 dpyP+MGl
 Y3bxN1f8IqKJbSuPCmgN69aMBTvpwDxQ4Tr6QOMO3dlXijFMQUpNsFKQhQmJr9WdSc6kf5w+lFsAqgGpYfCFio8WV+k3/SlNjuhkbZUaMjsR0PQeco+Yl+Gg8wdUYcKZmRl2PQPAkISTtKlupNidhdrcRWk/5u7V++QxZP1Ys+cVb1eEqVKk3x9aIAExqQk9EF3dzfnClew/oAmcBXlUqqFmewRqDzac7/04v7fZm2pT+Xoah761v9Z4fjZywkvBvZ0R7QWWDMPD7xAvJaFwDhsF8OA==
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


