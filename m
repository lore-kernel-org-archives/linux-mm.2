Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F5D9F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 794BE6B0274; Sat, 18 Apr 2026 06:59:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71EDA6B0276; Sat, 18 Apr 2026 06:59:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60D166B0277; Sat, 18 Apr 2026 06:59:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 49C496B0274
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:59:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10A1CE467D
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:08 +0000 (UTC)
X-FDA: 84671379576.20.6812544
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6799A1C0006
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e8ymaisa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509946; a=rsa-sha256;
	cv=none;
	b=QRRIG3DsiBNz5tIqdCexmW/jP2OtPR8ElSm50quf27GN2qJtWWwXqfmx5PCmEl0KSTkNJj
	MQDsaGGmZqlw1yHBbMy7bHpqkTxe+/KQ7Xs6Tug6dKuucUP83bnZ3no6wHqQNEpfR/gCP3
	m8z4EY6JkSxZ5Dz9wwMKJo7MYRJ38JM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e8ymaisa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H1liFTyal4bSjbOvk5FshkJIBykh5rg/CLceE50C1rM=;
	b=WBHvGmSIuamyv4nD3WQi/OoxCpEZsy18qJFmcpiQYLROemKMoCHLyJeYXg3uJMbI0cD3W0
	ZHsZpxM2hIRI1yDQqBchCTts+dZWN9RJbi1MhuqbgeDEsUf1BhOY9D513GxgoX5ezv24Qd
	Y2zMnFhTcZ2wlFfB+Bi/PMiN6SgWH0E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 87B0C40AE9;
	Sat, 18 Apr 2026 10:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF94C19424;
	Sat, 18 Apr 2026 10:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509945;
	bh=a9ftjtHwEJ6B9K8hvRWelWOu2y5v4+ZMDsKskwzolFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8ymaisahGMaTk0IOxyVJ0yECbRxXqnEIpYd+/kKN63pkJkrK5Hk4xZ4MeaaMn9J/
	 cDiRpns00LHplT27pTAiWVZBUh+WwIGLiiXi944++qV6r3B76B2MSCq4em97gZWyhk
	 /90LfTJD6LfCJ3UMDN34jeO3Msg9bLEVzmXVGNkCWS4Z3KuOa0eWQx/C8AngZ/z/Ul
	 6uIYVzAjlpPt7CgQDeYvZxjwAqk7I9BiXKfzfDsLc9iSnmyAn6uzoExP4EhJS/5S+J
	 1AWXRozzMsrH4fxd9u5Os+4TcV9tKdBtUslNncPA3rRJkXrv1CzSVx5i6qr3Ofu5sf
	 g58ag/p58B1vg==
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
Subject: [PATCH v2 32/53] selftests/mm: gup_test: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:17 +0300
Message-ID: <20260418105539.1261536-33-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6799A1C0006
X-Rspamd-Server: rspam12
X-Stat-Signature: yncmpywdkwhd9tzsetnp377szmprbn8p
X-Rspam-User: 
X-HE-Tag: 1776509946-602883
X-HE-Meta: U2FsdGVkX184jFxmBAv+12X0tFRcOX8umRLbB2TLoyQatYc8jWKJnqKPYdBdpvjG8gUV36jX3C8/+w4oeIDugsvzoWKM4oVRxDwtgkmbIbu/zI1gdHXQS1BVVK3HZt2J70OwHXqkX3l9woLppvtHwHSEPhxUeo/zPUNBICp2UR3EtFrPbBEa6Huv76ZFTKDU+blM4A3Q0djS+Tc0iBd0HBaGGqx50Sfbqhjt8ww7I0bOalSsdlthjYMz1wcCtn1lRd3vz+1vCnSB9QKbGzWNXbCHAcNCW+qmTmU8RBhzofLQPNW8RqnbKfmwN0RAA8l83rytIm9gxxzeu8m1mLqzi0OkRJCGicYELCht3tW6C6fYYJJvvYqjFqZpCn3figsnA4sLWDbS9whBakPK7eIy2mpgPFXNchjBvw5tEdipDZQaCVS95AfK4OFe/Hgg+UXxb++rpFTYsaLGDx9xtence3ytb9IXmo1rTuisthBBmd1JmNsi/KkjEu49uaO9dMn47KwkNHbfBl0nrFUKQINBW7bRRbOjztYneMS6mbx2G1O560nDEi+pWLCtvgH5PwdgQU172/o/ZeRUHhjASxcMFOPTmvZMm6/tfiChDfKRJr1HzdPoJQDM+l3Z1HEnosd46jgUb4COq123WGTNzYdxVSkwhqsoAlCvDpuxkcMqmpatV5jNH9KKvhpgUr138nQnEiGTDiCmiqiQttNCXaaLAfic0oDnCECfNR29/Gq1j7ub6YCCchlScUGfRCZ0MXGk5tfHl7O9aYu0dozEqFxcxon8csCqQkCl+iX9LOXw6tMlE3SPT6IwLF92YurCYhkdk8cblBIMiR054ygV1j4+lwzmVPA3lXsi5hO6K1dYdLu4hZpIUxgdEnwS4taaOoKdWOUJ7mwwpu3hi0GWymd3NOlamLpeG7tCxKF1c5xakrywgBEjla/JHkTsk5gZHS3GvX3Jz5eeMohQqfMqvj5
 zDiDLXA9
 6CmGCxmDOIcoFFRn0GhzyIkdSqx61IpeBGJEQ1y28gxKoixUdV+V76nNKIgBRHGP0+4frJjgZzo9KbxPXOfY1AGKiH86bvpvRozOZK4i4EFqS74bX5gP0maE0e8lwTT5O2t7rmgf0+jkUdjOfCvPrSJ8tlTWpL1x15n6atWs1rQuRqivE3qMKFHcULMtSyiAnAZ/pJNyGUMRBRynvWewKI9Pf61Gv4gbKgeEGLWyxL/4zqBgoo8xuCAAHOS5sm+R0Q42XCUTXFXV3T9mORhbcaS6Sc5GBIFcBZ1Zt
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

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/gup_test.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
index fb8f9ae49efa..ddd239a69881 100644
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
@@ -199,6 +202,15 @@ int main(int argc, char **argv)
 	}
 
 	ksft_print_header();
+
+	if (hugetlb) {
+		unsigned long hp_size = default_huge_page_size();
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


