Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0112FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 562406B00E5; Tue, 28 Apr 2026 16:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 539A16B00E7; Tue, 28 Apr 2026 16:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4779F6B00E8; Tue, 28 Apr 2026 16:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 367516B00E5
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:47:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02740140414
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:23 +0000 (UTC)
X-FDA: 84709150008.10.E414124
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 59129180005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DMV9bb2z;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93iloeb7y1ONVOPYlCIEPmAfy4TFKSFk81gr6hkmpYE=;
	b=T3YkOK/0kXxZO/p8wzP54Novdfv3/uNRV1SXpX1KRLgc8xFK//INZu0+Zajuh2sU2VXLs6
	1JRQEi4b9YAHz784yhVy90bGeLdBn+4ZABOMUXrkxgHznzcUJL6j7Hn9kPb/Mdjbgt7boW
	E32+AHfvNyNRxRAZvQxrDy9O+relPbs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DMV9bb2z;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409242; a=rsa-sha256;
	cv=none;
	b=5UomShxWRxNMhjMODEg+Un6rUoOHvn5kNRTfqe4cXKEphOqodLMeKdgIFdqVd+r/o3WHeJ
	KwM8d6L4gdmX3C9Clo/aL0kX+/6CGzUQ5XnrRdyaMvc7NKtBzivDk+TPwuzpfymmoepbv4
	pHi1Fd29YcmPeMoXbT6PZp3BzS0g8qU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B10E40771;
	Tue, 28 Apr 2026 20:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6A9C2BCC4;
	Tue, 28 Apr 2026 20:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409241;
	bh=V9dhOZl4qkCAKpS16UITNdHC3hzDFxj10poJSetGe5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMV9bb2zu8GSXHA7ukg/OlvB5BQkbNZuTTEBICiE7WqAdpr/W9GQW1X6W/Q8iMxG5
	 Iq8bqnlt/UNTLPSvDHk5hMP3i5vF8kLy93Y1rKY46Vmmh9ALvtbkT3VQ3q+1yutp2T
	 y/dOziXrr3AlbCwSzOlKMdkqYAVZRWOJWXopEBpdgK25NZmC94qVPMb/tY2uc70R9D
	 SMw2NJaOy6nRiUKbIpnBbHbB5OdIauJNYcgUS3v1Q9wEWLXBXZkjEZbi40uQTE390i
	 9bo+M2uolmyGuMCQOsLX7QF6anNDNywpN2xNgEbcS20hmo/INUx8E8alTDo67TtDEo
	 /SDmsdNw/Nsmg==
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
Subject: [PATCH v3 41/54] selftests/mm: hugetlb-shm: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:27 +0300
Message-ID: <20260428204240.1924129-42-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3e9kqw8hxnzf56ti6rpxjswb38cgnxhh
X-Rspamd-Queue-Id: 59129180005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777409242-346099
X-HE-Meta: U2FsdGVkX1+SIBL5Y+zwVMxKG3sDIVyz1Owr+xelUXRALtgmNMtHs3xMWxPKAzduvBYPyBxge1sgY8ev42CUiuCYlI5sfZF8K91cnUJMQZDRty8+PyR7RcjX927ap9FNksnirRrs5ST+ORm7QIHMtqBSuw64c3m6izty0dpuJB9lASNSGjwopcloaPqZSvQ4/GkCELQMKBRjdF/CEE5KIaOF0+LCBozmia02//SkXxuvIjF0CcI93oL11vee6WBVZqsftpIlO2i0YWirrTPw5OywWO0qFe3cStGWXvtpK6lBYVY9MzLF1NF5l6Br6E6r+FIi5dUxplr0EVa7BKaLde8CDUNS0SNTZ2eC/oAoAbGf1imDCw8hMa9HVKiqPOxo3598xvsUTj2P8pprmqWeYuGM3JlZHrBJDTfIuHaptx92LeHGG0IX6D1NoxOgoMZiPicfvhQV8xETrJDkYe10KrV3TT3/Gre3ULv8Rc/+0poiNezRIpYOfevPSdfUaX3JzIROO6suT4eEEWE29fnN0UFIfTPwUlfHx3XZSGMg7gpcUwbCeb0ZZgnVg7Cq5LqSYAg0EYDtg2yaxKQmWZkSJCUGJOyYy1AlgO4xlS+K/aOqtUu1VxtJLt6jHardBYTMyFrK8nmr86VPb5I2a1MtofWh4ZXBOliv14Gr7I5a8f3HVXzAEY1nVokr24U23jd5CABGgv2laV0J3Eqs1k5oUOsINGaMCq/e09TszYGXw3C9J+kfD3Rk202FOJHrv0JhkrL8D1xKWxPIwY+Dxveh1ikvTzP04P8pgmSE8Rq2IcEcP0RjU6gB0LFqLq0gmHlugf2jHY+oNsrqxazZW1uSOg6VdZ9w5x3hMWNz5umx9W5ZLxRuNH63gXaBZ+JyGgAYJy8uIHVl43rNhETYsRGWPTpn2sKTTOiPdsqasYegFJAEfV3tkMQW01YXGCNoeY0Z0NbQ7LkQmFlD0wK175w
 LTa92BVZ
 Z8Z0ND2DlJv8YgZKW1oTTMClme3x1R9FQ7e0dpc2+MH/VtFTJ2LVxLMfMS7rY0Iux1h4Od4NvyTTaMDs3VPCC8QI5XFMYXqrV4naJW5huzIwC0880XznErIT+AE4hqkMI/zUOd4YuEChiLcsJoWa5K09qIN0osuUpUj7XIaLTdUWacgdu1NlKL8y5iVgZXOGYdYWvtIAQMFJqksNb6kvn/Q55XBT/rZ7OTp4laH4emdUhgzI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-shm test fails if there are no free huge pages prepared by a
wrapper script and shm liimts in proc are too low.

Add setup of HugeTLB pages and shm limits to the test and make sure that
the original settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-shm.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/mm/hugetlb-shm.c b/tools/testing/selftests/mm/hugetlb-shm.c
index 0f70b1a50b6b..7b5a5cefe458 100644
--- a/tools/testing/selftests/mm/hugetlb-shm.c
+++ b/tools/testing/selftests/mm/hugetlb-shm.c
@@ -29,9 +29,24 @@
 #include <sys/mman.h>
 
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 #define LENGTH (256UL*1024*1024)
 
+static void prepare(void)
+{
+	unsigned long length, hugepage_size, nr;
+
+	hugepage_size = default_huge_page_size();
+	length = (LENGTH + hugepage_size) & ~(hugepage_size - 1);
+	nr = length / hugepage_size;
+
+	if (!hugetlb_setup_default(nr))
+		ksft_exit_skip("Not enough free huge pages\n");
+
+	shm_limits_prepare(length);
+}
+
 int main(void)
 {
 	int shmid;
@@ -41,6 +56,8 @@ int main(void)
 	ksft_print_header();
 	ksft_set_plan(1);
 
+	prepare();
+
 	shmid = shmget(2, LENGTH, SHM_HUGETLB | IPC_CREAT | SHM_R | SHM_W);
 	if (shmid < 0)
 		ksft_exit_fail_perror("shmget");
@@ -78,3 +95,5 @@ int main(void)
 	ksft_test_result_pass("hugepage using SysV shmget/shmat\n");
 	ksft_finished();
 }
+
+SHM_LIMITS_RESTORE()
-- 
2.53.0


