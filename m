Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E66A6F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BB826B01F9; Sat, 18 Apr 2026 06:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545186B01FB; Sat, 18 Apr 2026 06:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7146B01FC; Sat, 18 Apr 2026 06:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 260066B01F9
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:55:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC56C1404CE
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:55:57 +0000 (UTC)
X-FDA: 84671371554.15.BB0CD06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1C96620009
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:55:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O5z+Rrvk;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aPhewVopcZgyuNnvZor9eUMfbYUXNp7puYe2VCiWTAc=;
	b=NdC1Sb7c2iYRb6NGqbjUaWXTLUIfKlTE8aIv2lT/sa2m5JaWMS+0tfPc83suwID+VqDTcR
	YN6uuqcfUvVT8455ZUTgRO8HvzASzoviQMxR5HgBpRY1ISylQI0mvOdMTdknfeSw4G4Tib
	8MEJbQ2eBq2FeWMUiRfIat64sLsqJyg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509756; a=rsa-sha256;
	cv=none;
	b=M4/xRYdMuZM4MyTjXYFEx3wq/09XbEs3U0A2c4wtJzp2/ZLH3OCz5Ea+552xhAFFkUFmQV
	uqrVFM3/ySFX3gZUj3pNul1l/5HsU0mbWFzMBZSs9i8l0bSvBZgsZ/nOccIfiRMJIc+p/u
	Nwm+OPVUofMhKTNqOSTi8afjFSMX7f8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O5z+Rrvk;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BCC0D43376;
	Sat, 18 Apr 2026 10:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F184BC2BCB3;
	Sat, 18 Apr 2026 10:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509754;
	bh=9Wa6cmQ8SR+FAIiSEI++oU+tCSCF1FiRlP76nYdhufU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O5z+RrvkWvpGRd2Oi606nTqAMrStsgmLQogJFcc14oNjX4NOgarAONnFUn1ckpEKM
	 UHHWJ9WIebiENCdRnp00a03rjG5aGYat7V5qv8Sg+orergh+YDnTclSaqBQbmaRIup
	 cPHcSHiqOSGcwYdjKzNcvF4FDvTCnYsn7Kc1XXNfvepQWFZn/kxAOrpLN7nLPBZVfN
	 6Fz8uDbJ+86k/C1x9VkeVcJm+pB7NvkfgYu+qiRVAmsk2o+9yKgIG2VvYlq/Nm43ls
	 k1WNUOhqGDySXcIGZlIpIyxnib5h5wlHaJVSMllrnUXwz5URq0KdvKHpxkllNi/nZw
	 s1XvwDbXB6SgA==
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
Subject: [PATCH v2 01/53] selftests/mm: hugetlb-read-hwpoison: add SIGBUS handler
Date: Sat, 18 Apr 2026 13:54:46 +0300
Message-ID: <20260418105539.1261536-2-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wod3mc6ip1iq18rjhj1ibq95q6def3r5
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C96620009
X-Rspamd-Server: rspam05
X-HE-Tag: 1776509755-228601
X-HE-Meta: U2FsdGVkX1+bqwDf0B6HZRZh28xiZmw2T0UeTnV1xaoFp46xkLm4QWbN3ozxNLZKHJBRFh6jLIfNHezCePPTSi9quMCHaSp9SkDLWEFmlGGKa0Vjh7m+JZcqEAtLz5rts6cvTVbQ0LTJKSzVzGgg9nT5dHVeIWrmxYYxJuvgclUWBs9+uenLNbZcusd8jH/HRZqiHEP6PONZUfstICG8eaLrzZYJTh4Dg3VnuEmaYl83WOHBgrLOOL3HVl0OVFVaSyHUQu4s/Z47R0cTcxdDBEqd7HVMG75Tb4JhpzfitVt+rIIFM0HCHIBauPl1NaJYmoT0+vrGAgEJWxzjp2ndYTsrOVzpu+j+PBwMh0CjjPxjgwcX1yw+P89ddFt34pplaQHNJL3l2ddUEGE2zpDB+eXa8glqeDQEOpryOIrcNaKOzHKfnZfSQSNamCatPA0JPX62sBQ9fwk32P/2Ln3M8lvVU10lFSaYFDhnd0SHauismkC4oeBoAkbLXxoOUrkqZSTcc2N06eQS2GNohzoxYHTAbodsYZmw7mip6i5NXOKeV82bl9qM6taHxJCHVYVxqa+4Zrdj0kTza0GK6on4bslgKhbliQOZfBrfQANY9kZwR3ZBmeQJsiro21lktw8YSCRnjoberledCLyUQPaoBwgUR0HQA9BLy1RObq1bkxTdadIpcXTSsvsQJLodJk99DepFPu3ATJi+s4CTojQJ+VoS66qp0OjcHXeWzf7tPyUOEvjVc2f19+LlszfndIvLVKVLnyxwM1delnSkgVQOrAWWV9AgRNGq52sICvQhXqCQoQMpX8P6S6OqicWmOeS5t7QAuhIAEceVO7XRv/K4yPTc9hKAV2Eh5NcV8K2HCTzd2ZhUmK1dIL2nl0NFgrQmVGUUPPNEzUcIQYA/iHxrQh192UkodiHVEqvPgqljjuxoLrgzgdG0Sx8htE8DBoC5eCc8ZGREohOyp7W57rP
 wahBIpHM
 YoG8K2jnW9FkYmpmqKSS3AU6TrMK33iZDfmmep5tajuWEgmXxEP13l2dgzGPMDX3LYUwHuQVCYuzvSGTq8m5Tk1XlbdS1LU+g8IdX4xfbelFYTnxCWBCVx9mtCl0NT62vCXd2pDRZERbgX/lynpk8I+yd6I+8ISIK0sV0qdz7zXGnRgMZ4WMPJbTzVlnD6+bpBWBc4qs6uLOOME7v623Yku6CWC+wPx3hmxS/YkATycu2r3JA0Cxg4sh60J/tRWA2PW722sChKCGP0/E1lIGiNzy5ZJCu/P866gfO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Access of poisoned memory causes SIGBUS, which terminates the
hugetlb-read-hwpoison test prematurely.

Add a dummy SIGBUS handler to allow the test to continue regardless of
SIGBUS.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-read-hwpoison.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
index 46230462ad48..6bbf15f78061 100644
--- a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
+++ b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
@@ -10,6 +10,7 @@
 #include <sys/statfs.h>
 #include <errno.h>
 #include <stdbool.h>
+#include <signal.h>
 
 #include "kselftest.h"
 
@@ -261,6 +262,11 @@ static int create_hugetlbfs_file(struct statfs *file_stat)
 	return -1;
 }
 
+static void sigbus_handler(int sig)
+{
+	printf(PREFIX "received SIGBUS\n");
+}
+
 int main(void)
 {
 	int fd;
@@ -273,6 +279,7 @@ int main(void)
 	};
 	size_t i;
 
+	signal(SIGBUS, sigbus_handler);
 	for (i = 0; i < ARRAY_SIZE(wr_chunk_sizes); ++i) {
 		printf("Write/read chunk size=0x%lx\n",
 		       wr_chunk_sizes[i]);
-- 
2.53.0


