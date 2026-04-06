Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AACEF46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D41C46B00D0; Mon,  6 Apr 2026 10:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D19276B00D1; Mon,  6 Apr 2026 10:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C563C6B00D2; Mon,  6 Apr 2026 10:20:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA4136B00D0
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:20:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E1C01A0480
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:48 +0000 (UTC)
X-FDA: 84628342176.02.F121FD9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id BE33818000F
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kh7lIewu;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umrK62tD842NVDgkjrkpVdzwMt3bzLGjIrm3m7z38uw=;
	b=OdYEraH6QGuTYMljT/U1Xw5+CPb3KgKSAJv3rBSQcqdykSvm0curBzalZlAHZ1Dwn85jec
	N7GN6+HelpN+aQojWGIdha8kKh3X9GiB8BToux3agr1Eu+s7iKZU07EQ3JY3kDJdCOIsTd
	28kwv6YYrRoSs7rbeCoeJvHf5RTmQ4Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kh7lIewu;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485246; a=rsa-sha256;
	cv=none;
	b=YFkPt3RXNgk7Jz/sRcS1Dn9hLjdXyS/dHiPELRy4wVHQ8MATwkXR4YDIbB4zU9X+Pvt7iO
	fhs/vWdw/P5iCuMHEJNewPjQdbTmShknxUcv9Ev8S1gvb+wUdOnWo6uc5vpSeq/lJ4/HiV
	cUD2akEsXAkWa5Ym0cm2pNr+10h0+o8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F2BF041970;
	Mon,  6 Apr 2026 14:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923BCC4AF09;
	Mon,  6 Apr 2026 14:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485245;
	bh=+OvcjE79uMeuRExtXX4z8n9tjto6YL9x88apIU5Xm3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kh7lIewuH7ZxH4vwRNILWRsv9NlJNHTXsSnYUpgq2l/WNuuBZx0XliHgIKHhoYFf+
	 zxnyKYkPWlwCii3h0SZ9QYJOaKSitw9nRxTalEYvs2su8PELBIRwZk5tYW8ZlfbhUt
	 yKwZE0bym6znEQ9B6U75eQZ0n8MtRJffTYkb0GMEUQ0Cgwt40MXOj9ETOgnnxh48Ny
	 OBBCxTEjn7SgnLDZF+EFbk/NXFxn0UvOtyCm4p3NVW2PnsyQs9lmLv6glrww1IlPMZ
	 ToHU9uQ+9VFbbZuEzqL0rCT+1+d3xv6oEz1h45p1TfF+uah4oFgDBe1xY3YE/5qT3Y
	 961td+QDP21dQ==
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
Subject: [PATCH 31/53] selftests/mm: gup_longterm: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:13 +0300
Message-ID: <20260406141735.2179309-32-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BE33818000F
X-Stat-Signature: twai3suh7az7oh181yuuegcjzdsj9p57
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775485246-325274
X-HE-Meta: U2FsdGVkX189ACYIB0WvBxMdbyFs/JbI920XxT+OZOjWnK16DYSzPcGXRCnIdY05WNoqGg3D0t379t5huYOKqrBml4BJapZ5vJ+cSiW/i2I1UO9vaW93TrZLg4yaTcekqRVxF+Hv0I8lwecRqJmBKqcMhVswwri+CzsEeGLCMXaZ6oHmGsEBviLJaXPLwbtGuzFroBk7lzYX21Vli8KXEMGya5Mkqupmgsqu79iHj3IAJOzl2rGvskejSEcppZgl5oIocILWXTE1c5mgYZRoNFRJSehA/jyIKmc64qypfWYWSfam8MXgm/4yw3QdoTbYcsTDjT1MC3lRDFbcfq/lvHdMVsxsXkCJsB5OAlsRSbht59jynXzivGXo1tm6oE3dJfIAfBJ3iBcJQrwGZ/yjohZz0C75xTQl8+kKjmgzDm/ZQktAjSY658EnlC1gKWhnWuCKLjYIEL4lkGBvR7+FX3+8949Q8eF8kpHCZE6Ocla1UWJqyMcBrQrfFJ8PQJy3qCxG25g9HiuQGs46z7VJg7+akX1CURXayq3RCTmwY8DYTOfmzad9My+U4IFf9bHcnW8wCDttMJyMYtUdMPklOMKShLON0LlE56TLEH/QHqztdFSb3I6Yp2VmrA1VTG/jSZywPKN2PSMu1y+KvX2REX2CyA4Xd/96hliJL3bWRpfP48Uj5hMs9+XQpGGSwop6QgjiCGg0oqLviG9bKFXAELyoP6kGl+K/2Z4YBgbNDYsOc3mOFGBqp7AmMmAqaXHSamN6PfofhfR9AcpKHLF/+ITzutg3Svb/ur4VIQ5/yYb+E6XonTncbhX0lbVm+KylPKSFo2E8QMd1uSPTFHP6wpKr6tBsVHS1S7uT8sPsXtkKrG6oxqRryhwEq2lpnN/vR/uGeOzIQAh0ot7hKN5TBpgp4k1+w1OmatEJIfhDci8LliEmrlJolOcHMcjgCDnVutsKT9FtZTnxJZSXyxE
 QoJcGtdp
 JO9/jjgtRnkk7AFQq7lC6znXSi/+g5cqn5z2dk0Tz+SUJAV3BiQOJ7R3oqiy66BkujmJBiATJDd1ZSCCKGeBCUkZSkgRHbbEd1BflnMj5g2AAgweVCTjSlGNaTBf1GHWzSY+Sd1BlCS6mvruUKRhRhKGYFRZl8cy/yAuoB+c43WfhAfkqgdE1Zuh1stPkdOnob7FjnPvtA/ifcU124xqXj4ne5rX/calUdPJtfEWU9qB+9zN7plhKHvDFEraBMWTlcnoM1Of7hUMcW/EO8sRb+MJsFMWo3UIs+BqC
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


