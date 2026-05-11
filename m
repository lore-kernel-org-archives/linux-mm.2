Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6DFDCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1673D6B011C; Mon, 11 May 2026 12:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 117D36B0121; Mon, 11 May 2026 12:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 007056B0122; Mon, 11 May 2026 12:33:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E0A146B011C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:33:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF12E1C00EE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:07 +0000 (UTC)
X-FDA: 84755683614.16.5DA4377
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 21A0B140002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IB8vbeSh;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7mpD9UfxvehYOg646bhzkoK0b6p+8krtBEkPGEbyFLM=;
	b=2tcaF4FEIVNuWnUXrKj8ord/pyzsYaChWnUzsvAPRJnxDV3b4xzPSijmzeQdUjrzaPZNeI
	wVckpGUgTOjpEjpjUlL8hdOcC91Fwbsp64owHBeVIDHImOnszhbmbIA3bGvLIsE2IDmOkV
	fnmRbEAlA82/PJK7h4XJ7femBUMJQLU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IB8vbeSh;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517186; a=rsa-sha256;
	cv=none;
	b=awUG3JTUtcvg4XbLKQLYhOA5wIlYeWo2IrJa8v+DaGf67X61TltylvBG1tOUcqIoLrM0GC
	olcFDzElV/Z6L5RYpqVlEKTy/46htk81V/N/wR3fZFSYSN+IZ3Rs7aFG4MyRUr+JV91EiK
	00iqnUsh+rCvhnS1l2gRHakL8gOoX2A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EDFC60154;
	Mon, 11 May 2026 16:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0429FC32781;
	Mon, 11 May 2026 16:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517185;
	bh=PGUNJLeTrs0+FxJCoiMscYft26irwSFdLVHwxAtSeKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IB8vbeSh6iqRbtZTF5PCCe4501ekuh6NNGhPiFBBOn01TnQc1c+mXrAQ6UYXFfUCj
	 MHCirvop+trNmfNW44+8CjPIBDZr/xhsMgVS+Ix39j3EgzALihfshFL5ckjEeLC2+I
	 2UP4mqFvdA3L7cEeXhTskt4swO8+bWSXYdNJpPPBO9ERrWkDj5GY4KvfWApNIvMN7G
	 q68MeL+KESlYY8aAvrNkhaWjG53Y7zGlTfwpyRaZSbv4CoczDmw6hBIRlazjDmvj+3
	 CTO3/DrJPgCCxYGv7lODWIsLrsxTkL6fXlQJ54n7cmSQ/4tkSwAgd9QZ8MziTcmvuT
	 7qLknUDEbDMJg==
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
Subject: [PATCH v4 39/55] selftests/mm: hugetlb_madv_vs_map: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:23 +0300
Message-ID: <20260511162840.375890-40-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 21A0B140002
X-Rspam-User: 
X-Stat-Signature: def6ogf8a3b84r7udgengmdpmhtbh5q5
X-HE-Tag: 1778517185-555651
X-HE-Meta: U2FsdGVkX18PX7AZCgJwtwHi0vsP/8KkVv9QI3/vVZzRVYNVGChZ6Ac4dk7RE6auINwOFVhHblb5XPNLl37OZnH26MwAAcMpv19hm0qpnOW5kfj9lyRoZKgnW4eZXgADo08Cry1v8qDjgLQN28EZCIcGofzAyNGnxTM/zLGx+VmUE1hLYvCOtiwva4FHfnp5NB8voObhX+CjxPo79BJAN1Mb8f6eU/JyH1tfXUw/89w4U69q65o9cwEIvFtCyf1kDId9i6Azi0afdlbW8KQikJtX4fz7FK6v0WevEzOwFOTW8RDLlNNOtS6id2i6L//lCbJ5CpyNXD423J6xJ+WhfHiwHkQIonDFmm17AjRajLkdQLvcxRCCDU4iG3dLid0aHTtIlMKz5uph0S4uLaz/XNa4s8bJIizIyrdssLcUvKAaclcYhm9SWN5THQ6F+ZxAdYVYiDpnujEWcH6p/HhChdBJve+RmFwBd2zFC2Kr7LC6f+xvNFXp0bbt6JtcKEfQ2RpAqLITxPVYoLQGRmx8B0Am5ZusMJN6fh2t9oaLWBKhORXk+c7uOEaLKl4TIh9ySVsWEdBjL1/ifgtDiDNBz5RvaEDUmUZEyX7myTtDxYhRLQemWbI3jS8uc9kNVjgIkT/DjvdQWbdhbRj2v7VCsUh18e2gyujVVkyP1jkrf6evsMJsOj9I/1GOr7o4SEeCfgxPrfbWA+W48/xeM7AFRbhHoAuO65aBoajt43WSp/v3uW0pIjmVC9BIYwhqpU6j+U8CoK9pzUDhODyQ62P87++zLVM4BYQTl2yEu+U5XUjK2EwkQBHd590SdoAWaoajgLuxGnypSAMVZwCJlBXqjZDzWPbD1hHH2S5/2/+RtcE4e19anRQ+oi7iEyU8GIjDL5Fvmh2UMUYDIyks2D0NcbHDSMcF7/LTN4g0JoCabqlzWqiqmQb3peErNkirVd4LOyd7gn4NI+0XR1kE0IP
 WPHAWTBI
 l3xqzyqW3fyMcoYcqEIeF+lTOm6fLTpDz61YH21twVQd2vQqGysZHv5ulKr6SE56HrcS4cBmORUHYX+sbsBL+j0F+VlMziTaKHz888kJiF68fr1BW3dWfzs5uClP9bN2MCPACTa0XFwMrjsxFb8mI8sfw2w/qzJtmH1ocwTMjncbsEj0fJpH13gMFWBHdi0bZx5MTgyt0vOgCDbqNvrxWAwyR0KhnZbvMGD7Nbrfvfnaicf6obw7cIVX1Kn98ZfyNQTCYkECVMoi0GnZU/4AEM5wkI76El91jPTF/OwdAH9r3p9KJxpcE8lnl+YSEx6w/Pz7zpWjYhM7caL6xIFpV9UJbXg+r/1GpbBWes9Ta0VVyX74=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb_madv_vs_map test skips testing if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb_madv_vs_map.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
index dfbd71a7f709..f94549efcc6f 100644
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
+++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -77,7 +77,6 @@ void *map_extra(void *unused)
 int main(void)
 {
 	pthread_t thread1, thread2, thread3;
-	unsigned long free_hugepages;
 	void *ret;
 
 	/*
@@ -89,11 +88,9 @@ int main(void)
 	ksft_print_header();
 	ksft_set_plan(1);
 
-	free_hugepages = hugetlb_free_default_pages();
-
-	if (free_hugepages != 1)
+	if (!hugetlb_setup_default_exact(1))
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
-			       free_hugepages);
+			       hugetlb_free_default_pages());
 
 	mmap_size = default_huge_page_size();
 
-- 
2.53.0


