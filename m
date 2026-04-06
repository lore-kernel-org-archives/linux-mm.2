Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29D42F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921CF6B00C1; Mon,  6 Apr 2026 10:20:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8E16B00C3; Mon,  6 Apr 2026 10:20:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8365E6B00C4; Mon,  6 Apr 2026 10:20:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7358F6B00C1
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:20:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 32D6D1A0462
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:02 +0000 (UTC)
X-FDA: 84628340244.10.6C05207
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A7CB440009
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dd+gFfhN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485200; a=rsa-sha256;
	cv=none;
	b=v7tG6jiK+CylSEgejtFLHrADKow+go3nQAIyDtQ2Zibqt7hqXmMdsOSLfu4j+Thbj3YF+D
	8Y4dHM12Ar9idE0NwaoIULoNZbAqpwhVl4c5Dfq7q6RlMuaKtU3H/iHzh3iMnXTP8iGXA1
	FCKV269zNOnRCSrTAtbeteGnrbPOWSE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dd+gFfhN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShoW+mtvOdyl1QExhIaW0N6EwTQUExNdZfr6eOd51I8=;
	b=drd7SiFErkqTk/bV1kK8LwUyAIJpPGy35yra6Fy5VXsQ5DQqwaZc7QEiGtAFV5mMF39d7A
	SzuZm8/ZEqR9AflFLyQKNd2P5hS0LbnNurzfgqPVK2FI0f8pgdNI2+q3LqALclqaDiIZBo
	1Z9tzEZyG+RSxp7xYGyXeXKKlyA/esQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CDDF740E4F;
	Mon,  6 Apr 2026 14:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1D3C4CEF7;
	Mon,  6 Apr 2026 14:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485199;
	bh=/Wvi9uebpP/hGBuUfLX+2dm76zvxNiYlkCrT9K3LAcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dd+gFfhNTjIpyf6jViQHbupUvZ+ogJxg6QL677/qqXhyKSc4nT5dRzgnutHQK8gzm
	 l3TEgs24a7NVKsagi6MHg9bW9VM4VawufoTlOu8zd/P/Qu9SNhRWkSM72tWZ9lrWP3
	 PP3EhJX6QtEpvex/Rf2mG1leektT/xEzXCDaukuQBTPjK2bvdrtDVUogSfr123Ieax
	 AThFAr+ZpdS/jGULRp6pDD14M20/saA/SROndo47qosOktmxx/z5wfV5hCR77Ne6to
	 cW9v7/WoR4huhWjyEqILPsX0THrD5zJUxqRkeOH2HRCrb8fZ3MnTKGLmsonenK76W3
	 4NvqGdb82EaOQ==
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
Subject: [PATCH 23/53] selftests/mm: hugepage_settings: use unsigned long in detect_hugetlb_page_size
Date: Mon,  6 Apr 2026 17:17:05 +0300
Message-ID: <20260406141735.2179309-24-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A7CB440009
X-Stat-Signature: pq1g9gff77qdaa6tx5wd38xo35mpw5do
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775485200-114933
X-HE-Meta: U2FsdGVkX1/xPgKnxVbaQFHMB1ne0BhvFwvEiDXMyeFtmLUh+MkHjTLPUKOdMvXEbOQmJ/tz+uSYI2qKRUc+CnR3jSAURGlpRbCaEojECayDLG40hBab4usQF2io9WvYtZY/2RGDGx156EMFYfnzVxPFWTCbfV3rIUQylmAKg19fgwqlWz3OAN+kjVlZJqcRt+R1P0lGYqPxWCKvG9LJA6jOhX8GrsIb5OShUUcqOif/r9Z/eJU6JfRQvJAJodAFT6fOnzcLEvsgFj1JUDYnCx3WQ7f1aQU7fPiI0/LeNk0h06X18NzurCsWfDW+V7k7DoKpNZLwpivcptNjNsGpI8s8i1+drcIqahuNRcARzHOwxwBqlIqWTK4Xlios0/H/2ZzRa0NzUesUqlVbenwm0mOtfEV2JXP20ZNVA6bwZ6sIiTXeXW+wUxpdxMEVqPS8GMJVugCjssj3q/LdJC3zTANs8/v1rvsW+aiBCviASbdBk1PDbND0DAFidz7Wg+DmSHTXC9ucv1jxUquyaUcJ2Nq6pN2pFJh4yA6KzxisSVRIhIiIV6Qqlx4z7vhnpkp0k7P+24s+m3oBIaZRjfwwlADqIuZ6dzWkV/s9JXbbclrBjBs4BniySfrrGm2IdBiR2rpsMC4rXALhZhkX6gywCPysXB/aTMnlX43Wg/2M43XeD5zsYDbMoauBpkMl7FOjbx/TM/eYuKZ9n5AlfFKx3zcDWTxo6W6dDjEY84HBsmi2eAz4Obwb5LU6K8e7DJJ/HyEpXCF8vYROTeZX1MCnpnIExb3mJokywBFNKgjYyYt0Waf6PwTbXxwIiHeKlkD6e2ahLBwsJVR98pVdalccO1Dxev34zc2sSz565P/ipaBjB1/+6NcfZu85vTcQVSivexBzvgxR1AACj6v6IammueyhFBJEqMuAdg8CAgXWco7xUFp+L6l3KH0FJND4XRIc8g5S4lR5viDl/sBVSQC
 XK3bXUnO
 ywl85BW/eU+3u48o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

... instead of size_t to avoid type mismatch in 32 and 64 bit builds.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugepage_settings.c | 2 +-
 tools/testing/selftests/mm/hugepage_settings.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index ebaa621c45c6..8f563315b1fc 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -399,7 +399,7 @@ bool thp_is_enabled(void)
 	return mode == 1 || mode == 3;
 }
 
-int detect_hugetlb_page_sizes(size_t sizes[], int max)
+int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
 {
 	DIR *dir = opendir("/sys/kernel/mm/hugepages/");
 	int count = 0;
diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
index 320b97e768e8..9357d07e6c1b 100644
--- a/tools/testing/selftests/mm/hugepage_settings.h
+++ b/tools/testing/selftests/mm/hugepage_settings.h
@@ -90,7 +90,7 @@ bool thp_is_enabled(void);
 
 /* HugeTLB */
 
-int detect_hugetlb_page_sizes(size_t sizes[], int max);
+int detect_hugetlb_page_sizes(unsigned long sizes[], int max);
 unsigned long default_huge_page_size(void);
 unsigned long get_free_hugepages(void);
 
-- 
2.53.0


