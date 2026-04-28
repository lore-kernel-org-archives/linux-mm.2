Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB939FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:48:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42AF86B00F7; Tue, 28 Apr 2026 16:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DC016B00F9; Tue, 28 Apr 2026 16:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318996B00FA; Tue, 28 Apr 2026 16:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 20F5C6B00F7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:48:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E14AAC0F47
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:48:22 +0000 (UTC)
X-FDA: 84709152444.23.4788AD2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5BE811A000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:48:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MrBgAN7v;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eaw+4OjtWG2scfMcWirjo9PxqwCi8fA0+pBOmGItKy8=;
	b=L4FCZczSFVLiCkplOLZXXBOPpiLLLismaNLQp8whtcMN+8SPLyx7XkgL9yFJ3HDumBlSx/
	oteABtvehszXs1MPTTxRhk7SEs/82wtwNOzRQo9puYWxApXVGJ+zUxEA2pMu01ajnowI93
	C3EaQ/JfqglMT3MRfIZ6z23wg1yzQqk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MrBgAN7v;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409301; a=rsa-sha256;
	cv=none;
	b=HXOOKpsYnO/FeUruQp8dVWvf3PK6kmS1JjTRizXdCevSzkdUoiBNFst/G7JbxPuRJP2F+w
	zKvpodLN7bt+c19qonwAH4qpakKZmOWaXU+4n8GB256+Pj/3CkoN5vOnDasuB4HMY146Mo
	ttDjMtly9Gphb7Bg03KdXvORMfa6T1I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D103661119;
	Tue, 28 Apr 2026 20:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78506C2BCAF;
	Tue, 28 Apr 2026 20:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409300;
	bh=HtpaUkBbB7ijuw6rctcgEdxPGwj4VxmBP6AvOyp0uHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrBgAN7v0Gg/6OxNrbQotAn9rKocS0ALXFItaZnMWNG1OLuQmgJy7qdzFHSbrC5QP
	 zBQ5eDY7h59KZ3h81uYkJvJBierPcozQ7O7/7jo2eRoBfbscSY3a7+Frbk772e23k6
	 1xgrJx8QYXesKBPb7sy/GNogVChQtwZSsIf9nV6dNOA3wrA3BtrUVGP3hrME5j/5Hr
	 aWU51BXDfiNs7kbgjz+C5lKiW6hJFWmE4n/J4M2drZoiOhfQMCOI49Aj+eVojI956S
	 MvZ1g4qUF6KPNuZnHXpXa5Rqb0DksAHwCigbZI6LCPDyQTrHEcp5NbVyGbz/0pKi+E
	 bN9Ax4BP1jjTg==
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
Subject: [PATCH v3 50/54] selftests/mm: uffd-wp-mremap: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:36 +0300
Message-ID: <20260428204240.1924129-51-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: miwxshcix3br3djf1kim3iktziczsmq1
X-Rspamd-Queue-Id: 5BE811A000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777409301-698677
X-HE-Meta: U2FsdGVkX1+WD8SfDwAwV2A9rcEIQ6uOehZfBe22BvNRi9x321jzArVIDEEGXwspYN3jcFI1tBpZeBphus2Jnzs+1cLClS6wLy6RhDJ7ps421TaRzvfVjIlPN3pl4LGPSMKhBFWtuXPVL310POXfZK66fjSR+lX4adzxgYIY7e40sJtQN6hwyGW1Ch9Cx/aePzSwutEEO/zva8/V/BlYU5MGK9j6fVKOTGh9uPNtMFhR4RAJqu1U9JnrFar0msJx40USYNQa/6cGrqEX06k48rSvVDJNoIm+vUHFMb0M4oWEfr706Zy1HPk5z42bOX7DsZC9jNYuud8MMbMP7+asv0fVJJFSlpZRxfENZvh0NKBafvODHYxqkUZMTQTjQLS0knLLreHQe2ZCQJuqD7ny7eXmllTO3JVE5rRXAw1jXMKSqmTwXCAIZ60c1kuHQfmyefx/X6SvSxWwxne45IgDP6iohFh+KuMUe2ihy4CkRB4uuWQ4sDQ996MwMk9EUa8zdQF5co0+ESZ6PNOkyQegIqeve0mR2ChANp4oVLN7fx3M+boh3dS+O5aErP3y+O5Rvhbd89QR/OpwmraEuNTD/bUneS0Pc5CVwYGdGQSAScyeRnYid2y2TqTyXUC6mHRyeo44EjTCm1lmhfXYXJ8dct5OIW3wcq8LokUJ68GPVmdDz6WoZSGXBhKze8irZPPAL5Yt8qPkYsBL6aCtenuXM3y6bzVhW6iOy40zCfIzjrlZJpnUcdw0YW+GYhexX/hc5lXaJHc85TQgrPglcrv1T9wzPJ4GCevi/CBOimGsAh4JICFGz7cnUe/dg1cVRjzztRXb6pkyn6JxUTNwz1G26SvM7gZ9qTuxei51iOrvyNuwTF5UypKnddm0cWowegh5dYJRbSijCvO7JY1kDOJFja8YWLfZTHs+lYvUy5lXp+0FQWhvfF3HmahKYlOPtyU/hL4P1XYKqRZiVWhYwny
 G72+xZ78
 C1+K2iklXbfuOsucow2SK97/T9ugVYeD5XRDLcu+1Vf8XgKOgvV4PhDXoj/zqMhPlrmxi1jXi+a/NEHbA8ehxEIPQSKn2KE2jrfudB/WlWE6HIt992TWb3+Aor3ZC+ymJuKiKAoH7Ma+Jr+4thsRC5VkliDSOG8kI/ebcCKs1dYHl++3Xj1UPwOAMQOcwj2tiSq0+EX9XCghRrlqoX+pw6+GkPzWhQs9OQco01mL2TtqPyZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

uffd-wp-remap skips HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/uffd-wp-mremap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index 9d67b11c2f28..f63fe02f404f 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -336,14 +336,14 @@ int main(int argc, char **argv)
 	struct thp_settings settings;
 	int i, j, plan = 0;
 
+	hugepage_save_settings(true, true);
+
 	pagesize = getpagesize();
 	nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
-	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
-						    ARRAY_SIZE(hugetlbsizes));
+	nr_hugetlbsizes = hugetlb_setup(1, hugetlbsizes, ARRAY_SIZE(hugetlbsizes));
 
 	/* If THP is supported, save THP settings and initially disable THP. */
 	if (nr_thpsizes) {
-		thp_save_settings();
 		thp_read_settings(&settings);
 		for (i = 0; i < NR_ORDERS; i++) {
 			settings.hugepages[i].enabled = THP_NEVER;
-- 
2.53.0


