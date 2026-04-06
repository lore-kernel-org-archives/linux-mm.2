Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FA4AF46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:22:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A841D6B00F1; Mon,  6 Apr 2026 10:22:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C316B00F3; Mon,  6 Apr 2026 10:22:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999826B00F4; Mon,  6 Apr 2026 10:22:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A49F6B00F1
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:22:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4CA1E140440
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:21 +0000 (UTC)
X-FDA: 84628346082.03.7B455F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 68A8D18000A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HVQdV5Nj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485339; a=rsa-sha256;
	cv=none;
	b=5lQyOToK/lcvD+KxcDBv9uMf5pKjl0/AUhDuOnL/Cj9qnx0XWrs35YXxoxsuT2N0YiTzX2
	kp66sE3+eCb4DErO4UIbsapVpQK4a14zHVSMimg4nfHD7BJ4g8c4aFG6s1dK9D4m2bbe2a
	igpteDKFeDjUrKL+lZ0gmyBn//BhsqA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HVQdV5Nj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IfwxdIULrvPYbCaT0rC7nJp3cgiUYWThgSOqSi8ytkA=;
	b=0ibETCVbehKA0ImgNy1JpO1jLguwG8SUd/Vukz0Q/R4i1mcOH0Fjk6CaL7Dks0+7YLxKcg
	OQLkjKV7JulmorYR1hYCjX5OpkjDc0FcMRKceE/OVC2Uyv+wVvrd25VTPvJX7qtgECqnQT
	HLjaLFkpzWTESjoscQqbPtftJM3iVBM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6099940619;
	Mon,  6 Apr 2026 14:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024D9C4CEF7;
	Mon,  6 Apr 2026 14:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485338;
	bh=n2KgdfeDkv6qGICkBg3Vwdx+MRmhbjeNlFxUjnQTB8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVQdV5NjOMae23YnkDJqbhXIXRIvarXLiGjQXNzVM1HhAdxTHA473+q34g55LSTac
	 +5Ic3jvWPiNUGJpsG2uFYh7yZs8OvMHrkXBVedvuRYGYipe+UY4//sbJKeg8G/peh+
	 G+OVu7eMqtC3fbRRBnQNpexqPfNnBENZM1Fc6yrAXZ6uPcH8PBASGM1RcMDGN3T4kX
	 RwmwF1jYqQPiW73FOCrlY8fblS3zwrks7eIj5di3ZWIO0aijiia7q3uVw8JqGNYv9Z
	 wpvvhhSx+81KPECoqbjFMVsBcAEWWMCJccHepUog8B0+9IZ72YU3O1x7aPuPUc1gsN
	 cWH3yZDX38qOQ==
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
Subject: [PATCH 47/53] selftests/mm: uffd-stress: use hugetlb_save and alloc huge pages
Date: Mon,  6 Apr 2026 17:17:29 +0300
Message-ID: <20260406141735.2179309-48-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ftg1n6ryy9kr444hchnh4kg6mjecs97t
X-Rspamd-Queue-Id: 68A8D18000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775485339-234555
X-HE-Meta: U2FsdGVkX1/fMROD5fbCB2/YAZeGTu4CXnx7Fd13RBC+1d7otFNTSlhOyUZLUaU8bdLA25nokG8R0RMRiI3oAFctwhlIzNTjD9BL9fxjyOpGd6kYMtY3hTi0LcxfxBPnENYjyYntIEomTX6NiKFbS96AmkSlBR7RUpinI3eA3ccxWDDMijRr0gUGKDO+4b2ioW9dO20xLHS7QHoUBzXFZfCnVBpty2yw1pxn59YBrrDGh4aMQR/cTqktQ4VVYWEMLEHNdPuXXbs2F8HDzhRVZ8VeS7BXkB3Ok8nW4LTgNBmyWiWvUWQ4k494F90Xx+3efkd56gDZx2bBdxVYtNBWg1n8+c0HcPvx19483j383K/wvbEdS0si1aAp3fxczWaoaYSHHcoSnhPCGIT39zBqxeUO+6OqlyHTTeVIvpRUOjmw7Tvr0jeNJegKKrQF4rMNgHVkhZwEsR2nm7ZFkq0CxyAUXwtrDWYXtmXKpj+gJ8SDNOflgcvfDxAz7A9eg0NbPO++jxnBen31tyfZWZve/DHaUTY/JDulvbKGG3W3zEmdcSlcsepEfz3OzdLwPjaUVjMIGKk4U5HTRC+z8SkaCyM7RAt7iJVsDyQAhPkDgDwsuboDonDtxJ9smF1wQDYA/KPftNIOVoussp04JJ5Axj8IpxWztDBkwsckNd/KCo/PlHfeQoUGeC+8GO79eCBEfA8cyMHmNubNvDDrbeGVQFnLmApVX3ZWeILDOqH+Loz4vF3rk6D16PU2cg50HMTJTM48gltryTDptvQdICOLbjgYp05UIzRsJrYcJGbmldbzatwaVPMzgHxmtOKOF0ewfd8eVq/aQ9L/xQLIQQvC/iiy8bkfC8zJqYorwCrvCfUzk9WxRSKclsBnfloRvE9MOyNE23bhUZX8OVqMOf2pVvAMIr8bYKwYmzW/3LcUVTT3BfBAoKSknLEfd6Fp4Gb5W33oaWn3H5hBOz4zXkU
 MHGhflw0
 pwRIMurAyHLn2Wp1rsPvz7/y3qRQVnqWgfGWEreIx8oeeXtLDjzRuaaFt7M08CnWKkvkxRm52SIa8w3ThVBbZuHdNjc0hPDzhhLfbKcIY+xxKbjYvpVJFzXlmruD/4RmtsQ0J9+8hk19U8yO8K5w7UtpYmXzhfien5bVxhCOODaV3DWzHKBNH/0wlNFcz3FdTejxlvc+gmZHmintKbiwUGf3esBME+b6XwZ+zjDyVzGQUxK/wBPNbbzr/DY/fICoxWzoPN+xOAZ682QcVzi0gXB7TT3Xo+CpJKYCi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

uffd-stress skips HugeTLB tests if there are no free huge pages prepared
by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/uffd-stress.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index 7e37cf3d27f6..9693d042f16f 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -479,9 +479,12 @@ int main(int argc, char **argv)
 	 * Ensure nr_parallel - 1 hugepages on top of that to account
 	 * for racy extra reservation of hugepages.
 	 */
-	if (gopts->test_type == TEST_HUGETLB &&
-	   hugetlb_free_default_pages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1)
-		ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
+	if (gopts->test_type == TEST_HUGETLB) {
+		unsigned long nr = 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1;
+
+		if (!hugetlb_setup_default(nr))
+			ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
+	}
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
 	if (!gopts->nr_pages_per_cpu) {
-- 
2.53.0


