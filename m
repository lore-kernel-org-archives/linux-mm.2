Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48C5AF46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20CA6B00F5; Mon,  6 Apr 2026 10:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF8D26B00F7; Mon,  6 Apr 2026 10:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3CD46B00F8; Mon,  6 Apr 2026 10:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 958EB6B00F5
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:22:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D3C5140346
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:32 +0000 (UTC)
X-FDA: 84628346544.08.8C5AB06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id B590E80012
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TF6tEmT4;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eaw+4OjtWG2scfMcWirjo9PxqwCi8fA0+pBOmGItKy8=;
	b=tlF3fdSiQYKsDLWdQOtmKmfeFgnJ7Q+RAawYZdxfzuc0EHrDrk84iOBknOui1HpWtEPWog
	MjV3biH1ECO5lWXgPP3lN2UtSqAp+Ew3c+ycihRlu6fv3Yy3+s40nfDfUj5yfa/xqcusTG
	XgFd+zJQlM2bIn1p/wLQG50GDRvlS7w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TF6tEmT4;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485350; a=rsa-sha256;
	cv=none;
	b=lFLXKMfg5IMTPI60nOoE/lxznxW0phx9Za/E18PQn7twPnwZUNbVJLVX7vwjPLXkc0PQop
	J3wKYQu+CiQU/0IMpuiz76PcAD4eJguN16OEMqNBgu8ZtPogNU2RODSA4jEeUNgnwYe6A5
	obDLPVwvgLBqbje5K/1zxmDF5O/WBqs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E266C418EB;
	Mon,  6 Apr 2026 14:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C65C4CEF7;
	Mon,  6 Apr 2026 14:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485349;
	bh=HtpaUkBbB7ijuw6rctcgEdxPGwj4VxmBP6AvOyp0uHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TF6tEmT40RH2kGrtuZAt24+jBc0o5j7vcOmyMvGR9T0mxP6K0eLAhbyCN4X1nA6OS
	 nEEoZvaemSaPAWM21Nkl3+WNZgmNvC1gwpBpv8490Wbh5cbb+e+bgvUKbnAR+VkhOl
	 3ux38WwEk7d2SCxDEsK9QwK+UQ8Cm603XgTOr6IdWpAjkKNhLxt2R5Kz7B01lCwtrX
	 UBtcM6Irm+1F7denqZNEghot7G3mjLTJ446YuOk0kYO44tCBZJ7ygblrUDFeDGbZcU
	 9b2ShSGbfziy7ItIYBg93yF/2oSu8EfLkHbR2VmLrQ4AkgQpvGi6/A7aXHvwMpcyJL
	 +y5ajsMM7FeMg==
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
Subject: [PATCH 49/53] selftests/mm: uffd-wp-mremap: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:31 +0300
Message-ID: <20260406141735.2179309-50-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: h3jf7o3a5hx9953tggjy4je91xa319i5
X-Rspamd-Queue-Id: B590E80012
X-Rspamd-Server: rspam09
X-HE-Tag: 1775485350-918676
X-HE-Meta: U2FsdGVkX18kj9IS7RaLa36ynhFQg2csULerlygp9nv6RlzoSO6JhvBpRs3fSKYBUuP36QxTeXIEBm5V+dtWWoU3bVPLzL8tsrlU5dDzu5VGQmLD3UHavBeIipfJlIjT0oK0Cgo6RqQF37xel5FPHS64H9mmcjsEGzbKELF1whdCqf0uwceS3VNqOUWk67zbR4m1bgYYQaavlzLzxrGTjikkOAE0EyfN1xbcxQpmwOFx+lDDqNgTY4YxyKpGF1AESH4XZEuuwVtK5823Eo+BGZGg/ejPfd24+giHOjsTqk1KZ60Xx041CEgyfr1SHQG48dDhMGAPI5xx/Q2Tl54NR6Ao2YrQKwe1pBJAsI2tEgVejoAzLExt9ogol9+uL2DIaWoGh1VFQrYIkLYMe5QQWOV+EKcKTYQT15LH5KI4juS0TMsJTwh0/bKtdRwwbRru3FILvo1qkwEneFjqdgHU6gz8YcZGRWmOvb493kqHVHe7S4lP7IRrY1g14edec6UBNFuNfVK0P2pDzCxLiBQUF9bUxNWLP3lDdKIMTygE+Qky9h0vUGo1OsbQvzR2ngs+o79DOKwnmBhuQtEG7m+FUrIbfoSknFvUAyroZaVZocmBKa6UqeCSoyWVldgSD3kPMwB+jZ2tKOC8ExQKj84sCBVOdNqC6IIRlsBnos3kNyC0eslNmjz3sKLYJjCEWDf5AwhjOiH6o7X9jjAP+mxTRS1/d0qTzLtTxMmR0sEERFyk7Qwaxrk4ulUfNXsEIy/aqf5256rQsVJsykhHPj5MG1geMzA4zL88K/g3qty3w50IEpu9YZrIHp6E4t9V9KedJgSu0IRPZU73UyIGCAgiU2LQcgji9lueKozNfW755kOeqcvRWm2Rg2RRR2kpZd8n9Cz8R5jO1827uNUNQKhtnKW1TG+gKq0xb5SJicoQHX9x68TErQPjb9aUIz6VoO2D0OUOJW+8rP5pJzW7i6S
 0H26FxVc
 BVPNq3NBQwloUC/VghsZhgFdyBV/IPHIlSo4DcR1ZtBiENCs50E7Tt77PVhTW0a5KkNqeVfi9qyBd7ppnTGAv1/G2TwrOLNwNZcmV1xdSGhDPyg8Nq5iBBX3qoTouxThYmc1lsjsLKHRkA47Mn7wKf3PmCG3PNDZK5gPePA5a1Qz04oxPzeqTH9bFHhW5eGK5wvToT5CSfiXcz6xCm2S1wWZb0mM9J6SbQ47ENiaRJPcfDz4=
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


