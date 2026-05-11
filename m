Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17C52CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 818526B0092; Mon, 11 May 2026 12:28:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EFDD6B0098; Mon, 11 May 2026 12:28:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C986B0099; Mon, 11 May 2026 12:28:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 655B66B0092
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:28:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05ECAC08B1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:28:59 +0000 (UTC)
X-FDA: 84755673198.20.DC0D3D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 55049C000E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:28:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rOJzuJZh;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0lR/R/RllgBqszd0qpTub9i45QbVa/afPkEw5Way5Pg=;
	b=uQNmYEKzFmcUTax6ZmE0YNkp4LFkrkd1ezewIDXXMurbciQOzZcLHF00qfaQn4VDUB+axp
	MYTwlxziHj5yNhlzCcUB/6H8Hwqbq53i9eDshcGUeQtw/MRFQejZdcsencLA6F3XpSVh1Z
	rLcv0nt5xLHCLIkhePOT7F9TmsOJj8Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rOJzuJZh;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516937; a=rsa-sha256;
	cv=none;
	b=TzMgRiVdBwB6ycYwCP7vKbXsHDOdxwI/lJTm4puL9aW6v3Gris0L2lDRv3YzdNLc+TD9Up
	/LawRK8n/dBoZ2bZRjeqHFNRvmTeFlgD8B3P0G0A9M6Xw3kG/DQS5rXqzf/iKriBJ04xSI
	c+c7LsGnJKo6PrNHGW+RHKh8m35mal4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 74E7A44415;
	Mon, 11 May 2026 16:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53511C2BCB0;
	Mon, 11 May 2026 16:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778516936;
	bh=yYoPhsk9Y08XlKnFDSwEbmRzMpt62PawpVHiZcaxIcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOJzuJZhLe7c8QR0fEQht2CNhgwN3iYrNBE2nB+JfBAxbaf4HyGHYyK0QEQPi1+aG
	 OazlEDyQCOt19iCINDDAng4KTjZQht8m7vxtZW5LO8enAg6KnskUIf4sjhhifP6cr4
	 WD3+KF/Uz8rQ/xoNh2Zrv9vux3/rOIrxL4pIRALQRgVg7hue5bJLTtyP2SGWrvDKxA
	 9RwV6fgMgMiW4EjMMT+BCYzTAvnsG09Pogr1iTF5aVC3JVYR214Iz6aA5uwo9RgqHJ
	 7881aqw/BdYOHywxDMaMTZRgqLp8P7+/4OBTwmSnugcukkSFLK1rhvD9gGqAffRYzd
	 BihqZ+QCuCgrg==
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
Subject: [PATCH v4 01/55] selftests/mm: hugetlb-read-hwpoison: add SIGBUS handler
Date: Mon, 11 May 2026 19:27:45 +0300
Message-ID: <20260511162840.375890-2-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 55049C000E
X-Stat-Signature: 8ufnynofeqo4hgu85c1k37rmnqrpmjmm
X-HE-Tag: 1778516937-258779
X-HE-Meta: U2FsdGVkX1+iZHZAoNMzH446YoGCFmhiy+BKdSpKOiCPsMda8RCWEVRf6GgcLZCiAJTtVNJplj79kVEj30nuDp6e8L5XX4u5uCPM7khx9UYyCqQnjwGUCVI3xoSzhpoG+LHpCuTVukJWj9ZXynAPRUYjiFr+FEbzIyJz0uAbAV1UeQ1TivQELHkQipk099Fk8vSDDcEVH+aJcDYeCNIr7N0dpst2WsPNH2Xg2oEZfBLihWM0ePYkwJaaduFHxv3a3j3oU1XXo6yhQFqqEnELJBQ2Fj30ewTOg8qjT3Abrwd9Qdxd38PJ1TFr1ivrxRusAFvi8uZWuvg7wrC4Kl5xc6RiafdHE8BnZiYDwApX+oXVDQNus/cJh0yQ9DpX4nWqmlZC7ivBAGy16xfQ93I7VfQflsajxixx0yk851sPZd7Vi5hWgdEa8PHeFWoROkcnu9Ogd+M81KHMSDhn3G92eFBIYUr4rpJ4qn7xiMIzxFAymFwhm558ms32qvrth5SABOH4QtnoPmudbZNHMZZ/m9o/9dV0JrCH1wNT+7FV+9VExIgY2Jyjz4En4SqwxaDZOniISvHzffE5op7F4O48hHldtycJHNaBCnU6fvt4GKdmqOzn3TwEIyRBEcbJ8nKn3a34e3eh5B/F5EJERfLh6xLSQ48w5tZdTb+Tl7ywTZdwILekAsORfptTXfUMf5zRxL4VmylbLGIvoVfyMIV9rb1S8p/l8GjegA/4Qe6jNdFE2vTl4aWm13PC3NtASi/qfJXGKFqGdeIsFSWf5DxeGy8aNI8JrQrzgl2YfpGarIlA3m9TXHeoMo2DhqG+Fz4FuPdgPV2wSraEz5bbSS6/GlwjObTy0SRNU6GUOUZ7WLTPUTFSa2clvKn4Gj/l1UeVrnREdTDhWeqz2sVa6sVLxnDjpwzjINJmfGtxZ6UJ/WW+WhMl7tnXSSyDLgR7Fk7ggoiMi8PvE4zIREOXYp4
 EQKSCYSe
 luiP0PbyHR5MowiP7zOunt2wQLe8r3o22HVFvzMBo5lYY5KJCAbRww5pzvj+4reQVz8U6KSXk7D0KjreFL+Sh7z7Vvwv7Ma3H+Ml7TSl5yfaffvzmAqQqXhhW+bgGtR0jLiSNFu0JPhOkBpkAztori+7ZnQ0rz5B1iIh+b7KX5cZRQfuS9zw/9GJb9JGe9ayU440LFlFtFoED/i0BlKrxFEm9QC1GZsHnSNQKzGyXqQgWRy7Xy+w33zcHWFSPJI6zwexYR//QtUFS2YoD0MRR3TLPrMyjN68kE+zCf+dnpt2/3AKwsWCiwbBHtoL15Ud0ynHJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Injection of a memory error with madvise() causes SIGBUS, which terminates
the hugetlb-read-hwpoison test prematurely.

Add a dummy SIGBUS handler to allow the test to continue regardless of
SIGBUS.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Li Wang <li.wang@linux.dev>
Reviewed-by: Li Wang <li.wang@linux.dev>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-read-hwpoison.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
index 46230462ad48..ad3198b444ce 100644
--- a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
+++ b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
@@ -10,6 +10,7 @@
 #include <sys/statfs.h>
 #include <errno.h>
 #include <stdbool.h>
+#include <signal.h>
 
 #include "kselftest.h"
 
@@ -261,6 +262,10 @@ static int create_hugetlbfs_file(struct statfs *file_stat)
 	return -1;
 }
 
+static void sigbus_handler(int sig)
+{
+}
+
 int main(void)
 {
 	int fd;
@@ -273,6 +278,7 @@ int main(void)
 	};
 	size_t i;
 
+	signal(SIGBUS, sigbus_handler);
 	for (i = 0; i < ARRAY_SIZE(wr_chunk_sizes); ++i) {
 		printf("Write/read chunk size=0x%lx\n",
 		       wr_chunk_sizes[i]);
-- 
2.53.0


