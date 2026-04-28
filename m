Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6136AFF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D04ED6B00FB; Tue, 28 Apr 2026 16:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDCF86B00FD; Tue, 28 Apr 2026 16:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19FB6B00FE; Tue, 28 Apr 2026 16:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0F0F6B00FB
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:48:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 790BD1A03FF
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:48:36 +0000 (UTC)
X-FDA: 84709153032.05.45F3785
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C02E61C000A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:48:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W+uVDnSU;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYpMquKvrJyhX3/sFE/ffrv2sKbdmCfUrBQUCeY6gRA=;
	b=7jnCOxy4mM2hOokkmWwPODlbRrrTgJtw07v+7257oUY/mCp0BekhYl6VHQXZ/k+egTVr9b
	Fip47vlOSbdiaeJW+n2wdRGYVpi0dUo3+jW4wVgTxFYeXVgYG5LjrKBax5kYZLiAnrfqBP
	U7CsjDx1vIDCcR+GzaeI6G7LBqgGeBI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W+uVDnSU;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409314; a=rsa-sha256;
	cv=none;
	b=DM5LSKJOZA8ZdViF5Xhz/Faae0SAkaPyAWQ7FsOjheGMi5Kc5Yye5BoXO3ymti2OzXtEek
	CtFaZyzQTxblZJOTGFp2MjtUynIREUe1vyLL2J8Ju7phWksIf8CqyhZQcMyyqpmyXtsrxj
	c8+XjviXohDeZWA1uHxZ240ruXrz2y0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C8BC540771;
	Tue, 28 Apr 2026 20:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4D7C2BCAF;
	Tue, 28 Apr 2026 20:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409313;
	bh=Y+6CuufKGBRmaBQ8v4yV5d9wcJCiC93SEawkGDgeJlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+uVDnSU0GDGxd9dYc1UPrAi61qoOsqwnWxGzKpcS+fQCXupvYkTZPohSGMiBNDiP
	 f+cp9C8F8EEsm7aTf6gCKRx7ql5Obp58kL8u1g9nVgt6VeohkCRMfZxcvzOBLsxgC5
	 D8QrvdaAZtyZ79cNKZhjoo97ScLImtZyeNcm4rkAK12SbORcATSeYX3XZoZrVOOTtN
	 9kP7LagU9W5xXiXnpYz/Jt3Lgriq9l2tsB4gIsLIQeau7TbrkiOyddJAb9YL9DcIvi
	 hGwBOL+/bjp7pVO/+KlXHURo6UEC3GL5t7Mls7zO8DjTrwKQ2umWFsNWK+8VfRfmps
	 Oij28WScEgXhA==
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
Subject: [PATCH v3 52/54] selftests/mm: va_high_addr_switch.sh: drop huge pages setup
Date: Tue, 28 Apr 2026 23:42:38 +0300
Message-ID: <20260428204240.1924129-53-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xoi7ppqg5rgu4jqz1x4ibosznbf13wqy
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C02E61C000A
X-Rspam-User: 
X-HE-Tag: 1777409314-13801
X-HE-Meta: U2FsdGVkX1/H/Pf8HNdNTfHChCvQ1d+Y9OdcJNmavPkXoBYJutFNPWI81Q92mrKHN1FD4HsAMRFHhoPVvAU/Da0JZ1H1qoztmgYzNaKZXlkoD0hF37H2uYIJf7sNIO/0hc3X5NdOaGRU3zfNf498NYiKw1st9b62KysHDStdQk9T06Zcf4/vynlmOgn34wi/hcC9FRq8bRER8BebaI/FmWu5Fn7ih9SRZIsBsnQ3X5xZ/4sUcz3D2R11kIEVzjxCRK8ZYG/+zPPp1sknN104UZkP7G3EOFXXZc4SVXWyKYtPvJN7RzU8xuBddisLgPtXBu/sWpeOzA/yzHKVVTO61XIMk5RQwVqSFHcPh8YarsBfj4/CDJRSSHgq7ukerpmidZmUrpn4wQA9AY7e+WjJ4HMpLWeZdtieBJS266Iv9RPXpTqi0WvPgFWG1fSXZSP9cQ7lwdb+J0braFstVggc59CExr6XQFl5IYSYTQJpI3zOewoHB27nAKljNO+RaU2Yeg6VsHMj+bgm5S9fjPiMZS1uCvXLSgeco4GFF/Q2RYHumOwNBzfuDNG2nhCJVBeETASU0tIuMJ2AoY01jwbhKCHsqgrsra+VhyXtEv5SHOp+GazDvoWN963eU73m7iY4TgIwHVhqbcYFicLynvhmw9Ec5iPS5l+mSLT25In6A3aPKBbG7iSTqvQ5tUeQ/w6N9gpeF1szxxyBOJ562I6xIY9cc9V+ArvEolJBJ4sSUftiUL5Lfq1LX/ndGqQsWfT4cfMjOf4AB70ieF3zQSPmjszY4giPBiFBU5nmxyIscErL7GiOs9B+jVGtLPaFN0MejMkfra3gR4YgA66GUZDpMS/o7QGc6DhPDfFSHyitOD87KlpPpMczH6rISQkyUpq0GWy3OQHnkxSEuw76fnEYmG8wuNLuNrjwyhuF31VQThReE8MRNpkxrgbHebRO1033yKU7UKgrE71/iJgnM4E
 36WP3rem
 nD5+BO6rQDrJqJuz6/6NHOvc6GOYw7FMGRy0gAmF2I98IZ3RjUhVENHV92HLBuos1KfSuACQeoWHX7jmh7hOOJAWh0ER7sM1GYpyCND0gmWRDh9+N9DJm9yAiBSk2DRXk2ZEz+IkwDeh3XYHT7AdnOymCPoMljJzZPU/3cCm7USppr1dqH0aRaWQK+DWzVTA/EtmEEBkKrC0WFlMJBmpH7yg5xi48ic4vTaLo8bhGBpVznJnpyi8Ak1evMd5jgBNGTAtJORdKSQrkcEY7rMM1ETLLx9OLo9jQlExuTLZtRUuc0ADHtyUhVefwp3spRESsGamm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Since va_high_addr_switch takes care of setting up huge pages, there is
no need to set them up in the va_high_addr_switch.sh wrapper script.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../selftests/mm/va_high_addr_switch.sh       | 41 +------------------
 1 file changed, 1 insertion(+), 40 deletions(-)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.sh b/tools/testing/selftests/mm/va_high_addr_switch.sh
index 9492c2d72634..01c15fe3c799 100755
--- a/tools/testing/selftests/mm/va_high_addr_switch.sh
+++ b/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -9,7 +9,6 @@
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
-orig_nr_hugepages=0
 
 skip()
 {
@@ -77,43 +76,5 @@ check_test_requirements()
 	esac
 }
 
-save_nr_hugepages()
-{
-	orig_nr_hugepages=$(cat /proc/sys/vm/nr_hugepages)
-}
-
-restore_nr_hugepages()
-{
-	echo "$orig_nr_hugepages" > /proc/sys/vm/nr_hugepages
-}
-
-setup_nr_hugepages()
-{
-	local needpgs=$1
-	while read -r name size unit; do
-		if [ "$name" = "HugePages_Free:" ]; then
-			freepgs="$size"
-			break
-		fi
-	done < /proc/meminfo
-	if [ "$freepgs" -ge "$needpgs" ]; then
-		return
-	fi
-	local hpgs=$((orig_nr_hugepages + needpgs))
-	echo $hpgs > /proc/sys/vm/nr_hugepages
-
-	local nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
-	if [ "$nr_hugepgs" != "$hpgs" ]; then
-		restore_nr_hugepages
-		skip "$0: no enough hugepages for testing"
-	fi
-}
-
 check_test_requirements
-save_nr_hugepages
-# The HugeTLB tests require 6 pages
-setup_nr_hugepages 6
-./va_high_addr_switch --run-hugetlb
-retcode=$?
-restore_nr_hugepages
-exit $retcode
+./va_high_addr_switch
-- 
2.53.0


