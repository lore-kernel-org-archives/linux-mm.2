Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F6C1F46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E1F66B00A7; Mon,  6 Apr 2026 10:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 092646B00A9; Mon,  6 Apr 2026 10:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11AC6B00AA; Mon,  6 Apr 2026 10:18:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E0AB46B00A7
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:18:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ACE45B96F3
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:46 +0000 (UTC)
X-FDA: 84628337052.03.F39F0C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id EAE3AC000C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FMSJmZTP;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zyaie0LXjEj3Afg1eqqZm9fcQVA4VV7pHfq/Mk/ebeI=;
	b=gmX6gZb4cHhjQgDg/l/HmepRDa61IdfE1o/m8o2iIaHzXxmId2NXlhcW3vtojTD/GW3njx
	6eWghcJdcTBZkVKjTzGyMTGkUWqIG9Hp7bVd6CyYXXvuANdxuu/ir3YE++8s7haabc+k99
	i8amrzQe6DEZsv3KNAdQ+q9PSHkeolg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FMSJmZTP;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485125; a=rsa-sha256;
	cv=none;
	b=FNKVebv8f1TUJ9As+sxaH21L2dwtMCmDT67mW9vxAN8h7H7IyHbtFpd1d22yE/bZSPPQn8
	1N84sP09B7DAEeAXpVYEyE7P49NL0YLBlV1W/HhMHGTMVSSatNSXvmd0rNqZaUZnb1SjJW
	X72qO26kCe0xX7HQVWHm4slnaWXEMSs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 28EA84156D;
	Mon,  6 Apr 2026 14:18:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80BEC2BC9E;
	Mon,  6 Apr 2026 14:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485124;
	bh=8GoszL+JlmoI+AJRMJnrANTWZ3idAH1q8ZSfdoO1bk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FMSJmZTPIf4Lm+nJxlliwe5kTMfXJpD49yadYlY8EPUpUqYMU3Nm9wxsF3OeXaOBs
	 FVgBEfH7K1av3dwXyRatUaZRu81qC7g//vAM9+zHHhVzg6Wwood6LqvKeXvwAxEvmf
	 AjTzS513KfY93/izuCzCFR07snMZHIX1fwswEZA0bEOxY4M+dyLL+nabEJk40lUofo
	 F9BTFfRQ3Zt+qo6tta+PUc/nawX/IbI5LHZMZFi0DX9QXrTvzj71c8K8AvuRtySfnO
	 5DOBbQmBCYHl035tHCN67xKZsujIhumxokhkvgiO/LGSXVTt+Dc+nzAXUKzY2mi8rm
	 dIPwbdsmWdAYw==
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
Subject: [PATCH 10/53] selftests/mm: hugetlb_madv_vs_map: use kselftest framework
Date: Mon,  6 Apr 2026 17:16:52 +0300
Message-ID: <20260406141735.2179309-11-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EAE3AC000C
X-Stat-Signature: 71w46wgmfogms6kxcbkp4jsfgbe9g584
X-Rspam-User: 
X-HE-Tag: 1775485124-49184
X-HE-Meta: U2FsdGVkX1+evfIw0/UUzq5p/LmtCfKAyXnuuGrF8gdjmyCqqEnnedS0d4w39X9f12ECIb/wpaVnWm8AawDX1IPKqz5tAVdVy6EsDzx+1xfEhOtWVxN6bYqfeoTLojuSkcSBhlTwYGrjaTjasUZqQqfB7eVSTVSeudfKiFeV2h8OTA2Q1MnJm+ygIl23S2p14Glt4bNmKGawkldstN681S8fMMF+fQGHpZeBFeljTrFMkbSAiMWkKw8pXCGw6+mJWIDjkf9AWC/xjqe8kQp0uIvrfU7cam80qRz2MjUiFZklrRvgUCHjWiK2SqeOA5NMS3LAbyB1HoT5mzD8FN9GdDVwFgu9erMVfUO4jVk6w9we1IgmBaFHvHicTrdX4nw+7N2OxtQyR2F92khl2k0+4cHqbq8dKpcjqa9AskuqVNooOSGSV6DI9B3pnv/qsTn8WYGWCqAobD+PygAL3eHjxzf1EE6y0gvaCa1OX8RzrOJFVt7vOJP06D9kA3VeVpFv0UrOzxfHT5tKWo8xzUxi2VAxPD92ebOpgv/OuX47bCt1SDmxfL6Yw7yty+wkP8z15UqYFmid37BzYhyC4lLMhwgjG8DC6fnlj4NLYnOkJ9X3WxfZA6eC/FY+6ncjAeKiJRoTm06Riua5jJi8HgNuv9jn+AeJVOqPS+Eq7mEMMruhQ/T5iV6wI+vnwEjxsFiJersfsMIkAXKXVWe7mxEJwuQjYtAVxLBRsZUrs9bkyPyGc83FAeu6XMQjuLfEnfKPzBPPNKNK0OuMHATKkM7xrgCzTCbUfBF2dEijbmFElsVAbKXvSqfe9x2pdU7S94u73+QdbZWspmT225czViEdHlSAmdFgogz/duZ0JEBTq5OBPdb3wnqM9q38MT3pKz2W7cOUtjXKJTPraWrCiudnl6JPRhKiCP9udyy28dminB0SXvehGdQ6O8dv/Mgpf09Ifsah5XnEOPZqxKT7twd
 D9XA7LcW
 /GXwHsAbXaivjzyP0d6xI21JkY2K+yWeUq4AbZ+zVcuFoPWR9FKx3dwwljKxR1lid0INS3uHplP/zf5BWeheKWYHxlOgr4avBNKiP6vlV8R5/sSC+P4ThrY5kpdii7DOn4+XC/Qg2iJGmXMqu8p8AYYfK5H4d72RCBiIZOUQU+6F9gF0Uy36VtkhrSF3X433BHRbuKxeOA0icmzBffErJB18+bDWtqxfEzuj3BYfjmeq66EXpOxcRJZkZCR24/QaNT2jQ4sOFmzdEzk6FoA3N5FoDzLVMEYS1fhe8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert hugetlb_madv_vs_map test to use kselftest framework for
reporting and tracking successful and failing runs.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/mm/hugetlb_madv_vs_map.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
index efd774b41389..c7105c6d319b 100644
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
+++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -25,7 +25,6 @@
 #include <unistd.h>
 
 #include "vm_util.h"
-#include "kselftest.h"
 
 #define INLOOP_ITER 100
 
@@ -86,12 +85,14 @@ int main(void)
 	 */
 	int max = 10;
 
+	ksft_print_header();
+	ksft_set_plan(1);
+
 	free_hugepages = get_free_hugepages();
 
-	if (free_hugepages != 1) {
+	if (free_hugepages != 1)
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
 			       free_hugepages);
-	}
 
 	mmap_size = default_huge_page_size();
 
@@ -100,10 +101,8 @@ int main(void)
 				MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
 				-1, 0);
 
-		if ((unsigned long)huge_ptr == -1) {
-			ksft_test_result_fail("Failed to allocate huge page\n");
-			return KSFT_FAIL;
-		}
+		if ((unsigned long)huge_ptr == -1)
+			ksft_exit_fail_msg("Failed to allocate huge page\n");
 
 		pthread_create(&thread1, NULL, madv, NULL);
 		pthread_create(&thread2, NULL, touch, NULL);
@@ -115,12 +114,13 @@ int main(void)
 
 		if (ret) {
 			ksft_test_result_fail("Unexpected huge page allocation\n");
-			return KSFT_FAIL;
+			ksft_finished();
 		}
 
 		/* Unmap and restart */
 		munmap(huge_ptr, mmap_size);
 	}
 
-	return KSFT_PASS;
+	ksft_test_result_pass("No unexpected huge page allocations\n");
+	ksft_finished();
 }
-- 
2.53.0


