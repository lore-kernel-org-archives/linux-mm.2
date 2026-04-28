Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFF61FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 560E36B00CF; Tue, 28 Apr 2026 16:46:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5119F6B00D0; Tue, 28 Apr 2026 16:46:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44EE66B00D1; Tue, 28 Apr 2026 16:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 32EBF6B00CF
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:46:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F20B51B9758
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:46:24 +0000 (UTC)
X-FDA: 84709147488.04.7FC34E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2EAA440010
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:46:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TZqr0eLx;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umrK62tD842NVDgkjrkpVdzwMt3bzLGjIrm3m7z38uw=;
	b=AAeq/4OemHDEpi9wnRF7ptdM64FyJs5mYQStFhgfqq1C7572asld6JdIWKKGJdkyipi+7H
	DZaOOty8o00Qtaoy0tfKd6cDL1HhlgBeQFe6E7VUMIRkP/R7+iQfEAvJgekkTsSVZvAOtg
	mqjJu8IbPzrnIvvIyDuKAXZKSbItjd4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TZqr0eLx;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409183; a=rsa-sha256;
	cv=none;
	b=a4nnnb2N2qNBLNGrDO+XTlQClTyQNgPDbeFuv8FBbMP/tkNkRU8EX0TVSqxJf6/rkAo8J+
	megoa7/dedZF8ja3e+q4H++GWu3pONpu2PvN0Kb9WZFMnqJL0sxP/wDmO6fEl3uG/3OGg5
	Eh/UT/NVQTQZgCjSdK/iwehvQ/ChhjU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30EEE40056;
	Tue, 28 Apr 2026 20:46:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AD0C2BCB3;
	Tue, 28 Apr 2026 20:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409182;
	bh=+OvcjE79uMeuRExtXX4z8n9tjto6YL9x88apIU5Xm3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZqr0eLxhEfqMiZsaMVHWOG+AucVJcmqXOKoenveGucYc/fzs4gVFRV5G7wVa5GK4
	 OROazvxv4pdeMLn0lY91hU4Quqp6lB5WxBbTPvVC0ReBBQSTq+zN0Y/Xmc+r40OKJs
	 FAuZOYgIzij5EmMXivP+r8pGWuhx68Qv4j0XRpHUPk1iSS2m1c1x+rRsUmGsnjJR3D
	 iKAVc6PtW4qhsoUSUop8ttE4zeV6+NyaWlsg3slI1241DqcEaqRkplVMFcRpnE3/n+
	 vBoLSds6+Yp3MNFKBLOhaNmd7xLy2yktHRFyR4piFz0lhFdWx7/FSLbzb9pOOx2oSt
	 gqnrzutgv+pvQ==
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
Subject: [PATCH v3 32/54] selftests/mm: gup_longterm: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:18 +0300
Message-ID: <20260428204240.1924129-33-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xxw95f3i3qeju31369fdnhptjp73891y
X-Rspamd-Queue-Id: 2EAA440010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777409182-117825
X-HE-Meta: U2FsdGVkX19tS610k4kDCeOhy2vDpztF7nFZwZZQHP1M2Nrvtcn4z6TWSUyvSzTlKOnKd1j5s52hRuWjq9nWA5j9/FDqRjRpi41l6Bntv+PcUPx7zJvlystFJlVajnIEeCfxOCwRyixyc8II53xg/g3/kUA7ZR1DH2352IxHdjGBJ+rDA92oo0mX9lulg+ltp/aPRu7bkVTBcmUXX4eO8pbZphVE3tdeLQISfy4iFSlHjeHydklsCIOR50lXRLJYmZI6Ae67eKw4mQyWp9/AC4vJlBN6WfqhADmWnmyojCU1zN914+5kWFt4cmjcJt2gxYS0YLxtsFU1IuDfglSMRZKURi5RtkDiPn4ecLAblAsIYN5IXj3ZXqC2F47Sv+Y8wekrbdsW+KKtDCdvm4xLvauYUx96en8GXCFRDTNcLtnQ8WZKUA9v+S05EQvWUKa0Gl2YqsKQgVqallyZdGuK9pemxhAZDVr31/G0AxSWC0j1mJ7RbSn9G+BwuFg8m6PKYmDUBkU7JOmte0RHAiQ8GM7EoZPN4AxhMKXWu4ErP2KhIU5du0uEQCpiAJ/nLtvwox7XpA7ocYxV0wzvrYZBP1/3hLwYTgI95vYyw++fRk1LAy/SS4K8jOk7i1Xtooygkp5zlqvcEg2dXkavZ+uE5BCkXyPHvytyPx1e07wuWgmtHdPD9YfRHuXQJaopPfjdQ5cDJkLBmrsc/Eclk+MK9njMmw3GRr6s9AFxRtCVh8K6qdV6lfY5o2pkz+pioN/u5kZCeIwCgNRAtHbTAPvRHlXwRNAr5F+/MrCBKVZk+wR/FifwWpQP5FvWFXH+FkEFGDY5qFEIkoXQn7O51J8KeVFI7JF5ik3VFL8TlIj7aaKpgsx6NyZHMWcd8BlsG4QVII+QBnfEEPeAqDlfiGlIa0JXMlunjvTFPHkcoA8Na+7Q51JrBSemgVEcOfRa9zrVutwkw0bc/K1ZUkcTXNW
 iuVtlhrl
 0uVGWTYfO2C1dqpfATmtXUWJQCuIBZzz3TkxQO61xE1YCFrPFFAIWSvUCZcDqBl98F7mQh6jF8IdRi+vqmI2TyioAiuf4Yw+ss2IQkRAyqVCZ693vG6MwIwEjieKfWlIptz05YBFvh3w/swDY07yhreN7WIJY+sirAbXk84lQAYi5MND0GZAxeGCa5HnawHdnmVYEAwmBoumw1Kc8pgYyDZWY4C1HFjnQux1+9rno0VO39Npxs7vxStJ1VaT5RILYSGxyyt8VHUhncfu7HcnJ77VCBXBpTtzf1Hng
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

gup_longterm tests skips HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/gup_longterm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
index ab4eaf4feb7c..6e1de12bf28c 100644
--- a/tools/testing/selftests/mm/gup_longterm.c
+++ b/tools/testing/selftests/mm/gup_longterm.c
@@ -510,7 +510,7 @@ int main(int argc, char **argv)
 	int i;
 
 	pagesize = getpagesize();
-	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
+	nr_hugetlbsizes = hugetlb_setup(2, hugetlbsizes,
 						    ARRAY_SIZE(hugetlbsizes));
 
 	ksft_print_header();
-- 
2.53.0


