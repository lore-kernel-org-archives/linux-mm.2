Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F29C8F46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664B16B00DE; Mon,  6 Apr 2026 10:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63C7E6B00DF; Mon,  6 Apr 2026 10:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5791E6B00E0; Mon,  6 Apr 2026 10:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 497366B00DE
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:21:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F675E1573
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:23 +0000 (UTC)
X-FDA: 84628343646.07.EBB5375
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6EEEB4000D
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=agTROMm5;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EpAGWcuUwzk4tuQGzyg1x4+kMp0pK1Lu3diDB47CC/M=;
	b=jp8yrbb6bD2qBZAy+5ElwdJze6j9u7b+Ssq31sYZaGlxHnxvO0U5pk7OSXbGoMB8h8mz53
	wyS+AqTemtYkA4BmaiU0RDd6HyPqhOrtZltad1+3lto6B0xUVYvLxs+0Z1axE6QmdZOuBT
	tZM3wUGCN0YI3LFf2Tz8Go0JntX2B6A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=agTROMm5;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485281; a=rsa-sha256;
	cv=none;
	b=u60fMESTT8BuJc75QUwZIpFKvyTRelN+X2QU7H9M2RdvQLXrVR3WCDi/ijXwJ63oFDuEd2
	RrJ/6DURVST48h8zjbHN5aBoiead/3FYLNa3vhSnosoU0+5Hf4mH2/SjXuq/nKp6fKacHF
	oJe9BjXb/AZXXRMaXfMmo0aTBs6Pe5M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A086D4393A;
	Mon,  6 Apr 2026 14:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4163DC2BC9E;
	Mon,  6 Apr 2026 14:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485280;
	bh=nlprzoVHw1LmFezPWbTzVMDcbCMocVKEurNVLRnJdhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agTROMm5+/L8PA1PIQV1DOjILhrJF9lyrFuWSR9Agki1LfX/O7YJ+Wt/YZzCklDnA
	 b5G65oUCYtqzd8uRbHvsRvXd2xOQZsstAZ39uwds7uqJgd/AmanlNN67uxcQQb+0pe
	 MXdbivHX+Vi+Udi+aeK5w2FnWf2M1jA1HQwny+3a5s3UfAVTOTxamd9nchmpZTzKoE
	 3LGGwveUGotGzyOsFUZqX5BQZMAU26x2kuxoh1g2IX0+ubDe4ef0Zcwoz0h74wf7tk
	 y2zGFwbfWWtaFz28ZAxj+SEgJru4P2bJXx8ufTwZh6Fw3yd0hcsNlX7E7Tp3esAFYi
	 8vDfQweFV7ZwQ==
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
Subject: [PATCH 37/53] selftests/mm: hugetlb_madv_vs_map: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:19 +0300
Message-ID: <20260406141735.2179309-38-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6EEEB4000D
X-Stat-Signature: oxrxoqcyebx3gpww7rg6kdfrscjpnewz
X-Rspam-User: 
X-HE-Tag: 1775485281-328881
X-HE-Meta: U2FsdGVkX1+b2daLIR/LkxRXx2cclnIgqHL6UtCxAzmdGzfrSZO1XIcBHNBwo6KfjA3RRcAZubrRx1x0+vSBAlFG0LB4oYUHgrtPvHO+NRmSgzhN7uPG19NOhlVyqIdf+u3MtDfMniail4JbUlgP6fyJuhD6uQr6Io/3RP4zxaboU4xE34mKyXPQgesmoj0aRNkZETFvVhmazgqXGxRrPQ+e8Oy6F9N8KvaL615CzA9LsAUfq5AzD5pJ1S8Wy8LGfV1KJVyFPglspngguJKbvDY5Do+BiHRNRS6DGzUcjjRkHJcxXe+5kQPV1OW3BX6Vkt0X5geGDm6JE50NGfCOhqKGreeC1WQco07B8/GBemz4EoRj0V2rBY0pkyI05znp8f4hj8bMjVy6IR72pdu71MxllXJGYR4GeW4ZUzQ2ZOWaYP2aI0iiSu5URvU/jABWc4pIGa6vkKzG6SPKLWAJSUo6OOwh986xag143bfZFAhMk7uEkLM/OJC3KCzHKfTLwT6vJX/WcF5i0nlqtErGNGuZ3bsHYUAWDgHPdsiapHKdhYBXYeeJAFkgp6HU+lOMuTGEReT5l8bMRgRmpXGNEdAJvBce3y3fei9+82l/aT1XGbEwsO+87/+trz8885b6RI9jet/QwrbrlpzM7cX1ym1ks6RFK7KSuZr1Mnp6JyjRuKWiUX8GDhEoLdYRvBmaHg4eoCD1eUJBQ86fo2vZmPSjzhQ2XhOvWw92owt/vZ6XV89dDVboxgCn1AVF2daNEZM5t+nr3aEN+xcPzZMcZywC14F5rM3etEayYKI4c3WPDQHVCr2wN6hemNcIaYvTXw8RvRHWXzL8njkUimM4CXCkjW5n/dG48Ko0AB6AGhW4zZu2V0Kb12+ssWTI9yKnWiQiMWtqZe7cEOmV43b0jnBpLtHKCWjpCquYklbm4z+IBLz3VHB6wyLXjm7tCQUImpvAi1p4niYLu3/tqZ2
 17dxzaCu
 2PRL3nEnKjj1veN4n/KaAHbLQm4arGh5Dqo5At0mwv/t49Fa2+FgcreRsaxpWHYzBy5upy6U4SXlU/uzpI5mFW7rx5d0BuNnYddJTRBGrcIO9gjVImnhT3XqiOq05pSr9GNFzCqEgcLSPLW0s9IvktwnTiWXgDH9Eu+xsl8eApRwc7xz2gcYmxFOU8nUkrToSVjKHqS/+FYipZpVLMCM9MC/pDEYPgWOlkOBA40NK8oxhWxZnxR06HjhllJqvv8TgangnWAhCyLzel1O1JXWle64iwsLZONF39ofB
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

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb_madv_vs_map.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
index dfbd71a7f709..6c95dd23ca81 100644
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
+	if (!hugetlb_setup_default(1))
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
-			       free_hugepages);
+			       hugetlb_free_default_pages());
 
 	mmap_size = default_huge_page_size();
 
-- 
2.53.0


