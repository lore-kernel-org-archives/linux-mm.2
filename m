Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 091D8CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E4C26B0114; Mon, 11 May 2026 12:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695156B0116; Mon, 11 May 2026 12:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55D106B0117; Mon, 11 May 2026 12:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 415596B0114
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:32:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED72316020F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:34 +0000 (UTC)
X-FDA: 84755682228.15.AA06BE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 19CCE40011
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S1SkCvWj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZwYRRNukOZeF8+0dkVi3eId6Icd36S+OD16wdsZoc4=;
	b=l6NZDZMEwDitNu+zgkm0KsJ3Y0zpiFUWHSNk55uvisxfD6OP+i3jb0Q0KO1F44bYQm0DYP
	7DZKRyvBzi3XPZ35uvpuFtpi2KJJ5VuaIasS5xqgnUM6PidAB8WUo4AYWjFYHCIRNmESlo
	M5wQ5h2hgV3ChLOOLPn0EqsigHw7cdU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517153; a=rsa-sha256;
	cv=none;
	b=W4PJHViXhfYhAmvZCJdFCBTFTHZSDJLkng2QX1PjZhVhm4kGAreAuX/PgIWNvuW80XdlWQ
	K/7/nFvlphuFDZGIR0JEsyXfybry4E6xsIVuPwf6Lp9uhEOvtjtVgzWQdzKizvECjXmV4R
	UDPxnEyfSP5y9+GEh4SN2J3NWYsBQjM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S1SkCvWj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4660C43227;
	Mon, 11 May 2026 16:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D0CC2BCC9;
	Mon, 11 May 2026 16:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517152;
	bh=55gDmnO5T45LMvku84PvaaMpLqFoz2ktrJOVSg+/AyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1SkCvWj7mrUnRTm3Zy84Z4OanDq535aEWgVexeaslU5b5MOaLWX/CaC7xGaftSKq
	 ZAgheTl9QnLISNZoF+o2nGJGyi7bkDvepDRVRXEKzoYrVld+WHFbRRe3mCnmFV/c61
	 GEuT+3bVH50GoXwfzWPQSdaSi9Tnsx5GqH6zFZqnCUcsOO/SEj8t6n/AeJjre4L/vd
	 /bnxd1jFTL/Fdnogkia1HA6GyUJqnSYLv9H8yPHScAzDZEK4E1qczsPxHVU3F7RE5R
	 S882e87MGZa5iybUMTtvzICPmbj0xxbSVA4WXk7VzFdDfDtShHuoziPmaLxBe6Wy1I
	 WXjxjqc4FmTeA==
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
Subject: [PATCH v4 34/55] selftests/mm: gup_test: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:18 +0300
Message-ID: <20260511162840.375890-35-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 19CCE40011
X-Stat-Signature: hi3urp4czpbtpq6b4ojazn5phzhwkbys
X-Rspam-User: 
X-HE-Tag: 1778517152-124425
X-HE-Meta: U2FsdGVkX1/mYVlQ1tYTn4Ye54xFc0K5aivuAV85Y6GW6QI52tFnVtgZyKRc170GGydyAeRdR/po+bjmSgeeNQfvxfqJCEN+MrKH2N3hoqM9NIEAU/wplivXWbEQp/N8BjCfdybxDON2aqHbO8I0CTrPP9mkjf9+Y/SZPbgcfS8OKwZIrcWX8g6VN/lGPxKqt03+42lQeeL91QE4ZtZ3szK8HkQaf7UUx3l3g+FgovetgvUoSc++6aezfWt9V8H7MhN+lghYT40pZkmBvsO/gE9qMw+QbqPCScb1gQM+83usxU3QkB74AjXy5sTgrkMKo0yXxMDlpWGqJL+vKmg1C1DzS5mmH+8uthLGmabXTWkxHfY0LBULQTDlW4WvoG3VcXUUw+szVdmI8iGkIRmwCTBP5s7eKVqezlIoiXZauggRTMI/ee27LLDDJAag8efwnP/txU7SQjsiL5bxdHWLgM5YHTsYLqVeJ3StbAqnEbHHcf9VmK6NjeUwVoYETQTBGChfQ9peQ5TU/hswRz7v4m4N3T6E/HJMvHE4otlQ/A5xJwESE/mbIu6VZZ03E6QEYBIDdTUe7JVrUhKQHp96OU3wsA38D/UrMGc6xChRUnLufdIo/bejQSfx+95uZMZ7DModFynBvQldNcycvutR0QAsQFsUA5SHX29joWI1wOxLXX5dJR78pSVlh7ArYnlhNBMHrxHkn3qZvsNt9EwQ94PYxh6ScaMeiSg/tZeeyDSf4hughXM2S+4PqcyqqFG9vG0FsFbVgZgBwMXM0hXhSBQw1PIIY1L7qZ5962jx6LsptGi3Te7yQFWJvbtsQQ4Nh1KiiYsTe4uQWW4vGvT4j2p3pf2ioZZCoZDN2POi5E3K5hgZeWokTeZb+6XyteLSgx/4o/p9nXRurD1IUquiFURAYyd0tgQgCq7ePEzZA/f1Pz1yRyESqkcsSnPfm9VgIbBWm7JY95jntR8A2ex
 MGHwjla+
 +Jp3pYqd44yXPnJ81M2nKoetOvx7WujUw0jnD6PVZj5bKuKNb6wAptsmBBZi0H0z8ROB6wPQM9PORSc+ziEn0xX/jTHbEvnLPlvoBawQHMbEpr4kfKDnOUG6PvCveNGYuLm4CZ3nRtPnhgDNva/Xxtlmn+G3JN9MBFRAkfZZOU1FRtybVjBcmcDUWSqiNGGI3Exxl3knhWie7NOQh01JNF3n/9BceV/6MZE5RJXCllbK3JkRuckB2DkRqlsJewQ6yHnZfJMA/w4HkNaFleAM9FXRpAym0FpvmqJHxmPEq0iWTxQ3fuZYOmZiOqzwGPdacT1k1QgZOsuXxeJzxJIYINU+LCremQkSZSo3g00evBFdDHfs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

gup_test fails to run HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the
original settings are restored on the test exit.

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/gup_test.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
index fb8f9ae49efa..3f841a96f870 100644
--- a/tools/testing/selftests/mm/gup_test.c
+++ b/tools/testing/selftests/mm/gup_test.c
@@ -14,6 +14,7 @@
 #include <mm/gup_test.h>
 #include "kselftest.h"
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 #define MB (1UL << 20)
 
@@ -94,6 +95,7 @@ int main(int argc, char **argv)
 	int filed, i, opt, nr_pages = 1, thp = -1, write = 1, nthreads = 1, ret;
 	int flags = MAP_PRIVATE;
 	char *file = "/dev/zero";
+	bool hugetlb = false;
 	pthread_t *tid;
 	char *p;
 
@@ -168,6 +170,7 @@ int main(int argc, char **argv)
 			break;
 		case 'H':
 			flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
+			hugetlb = true;
 			break;
 		default:
 			ksft_exit_fail_msg("Wrong argument\n");
@@ -199,6 +202,18 @@ int main(int argc, char **argv)
 	}
 
 	ksft_print_header();
+
+	if (hugetlb) {
+		unsigned long hp_size = default_huge_page_size();
+
+		if (!hp_size)
+			ksft_exit_skip("HugeTLB is unavailable\n");
+
+		size = (size + hp_size - 1) & ~(hp_size - 1);
+		if (!hugetlb_setup_default(size / hp_size))
+			ksft_exit_skip("Not enough huge pages\n");
+	}
+
 	ksft_set_plan(nthreads);
 
 	filed = open(file, O_RDWR|O_CREAT, 0664);
-- 
2.53.0


