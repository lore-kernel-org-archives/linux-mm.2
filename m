Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4693F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 469306B00DF; Mon,  6 Apr 2026 10:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4403A6B00E1; Mon,  6 Apr 2026 10:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37DB76B00E2; Mon,  6 Apr 2026 10:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 285C26B00DF
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:21:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB319C1C5A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:28 +0000 (UTC)
X-FDA: 84628343856.16.9EBE513
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2E0411C0005
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GMGesjNd;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdbsLCLcNs0Nk17wCqyaVrUu2ir28Rx9/vmKK99uBUQ=;
	b=wFyqtUb4v82ueDcZ3QRBGPoz/G27DGvshB+VDW/SxwtqhlmicVGFGBuq5RhE6ZcpULjgTD
	RHQezUtLcdw4M+GsWsaPcXSfAD9GxFBa5R6EutT9KaY7T012mZVrCE/PKmw2sbO6H27oFf
	B3qeGMrTNeKvC1FRa8akiSSg1sDu0C8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GMGesjNd;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485287; a=rsa-sha256;
	cv=none;
	b=PA9wkodgTT6d/YWRKHgTHE7gSAjGS598c4u2xN1C2zllBggufJHhAt/6U3i5zzEAKFMVv0
	b8U+P56/1aExIsLtdoWtPvsIGRwJ8I3UOD5pGR1ByyBEKHnGV3vNYRhI6d9tBNFu9UQ2n8
	s/nqM1f1vG+n37uw5AEGod+V38y5dTs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 917A460126;
	Mon,  6 Apr 2026 14:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A6EC4CEF7;
	Mon,  6 Apr 2026 14:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485286;
	bh=dRPuiqqQJpQXjw6cIRi4fzLi2hziGrsSJ9cBq+BFA+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMGesjNduweHgKIV8krEDAGqLHO1r7xXJwYnceTnP6WCbRkgyqukMlbpdcz1Tn5+Z
	 KFRjqfaIPsIRfpjqovZhkQh6g464H5Qzjb8YNPudW9iZ6K3lqB6V1ENeS61eQy0daZ
	 dc9j/XUPWpDM/uNWmNamftKB9kX5QSiwEmZN9pZXEnLckPGSXG/OGka4lZwpNHb5uY
	 WxcD7uqyznnQ2O3UV3jHPgjGBUUOfWmNeba26uYXcPz0l78sBxA5snpMZpJo+GAkSB
	 s7DmLkMhGKqBkDueA5vx5yaoNA8GzsNNk9uFKCdxqmhJp0HU8jdOqxd+WOUdGJ1IOO
	 iD1OseX1StzOg==
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
Subject: [PATCH 38/53] selftests/mm: hugetlb-mmap: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:20 +0300
Message-ID: <20260406141735.2179309-39-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xjy3pxwrg8otz1mdumoe1ax8wbfot445
X-Rspamd-Queue-Id: 2E0411C0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1775485287-165075
X-HE-Meta: U2FsdGVkX19AVKFx6WhH2hLv9TdHKxKIFkQpDC2fzh1vPIvbwVZyg/yehxcL7JMx0eLebYFCOtXaBVy/HjtpiZmBz4Ftp+PxHlG0ZhG8dr+eCdJLw3j80Q5A5gu51PcpcQU8QXsrp1GUShuv4rIYSH+8xYu7BeC4RJo6x/eBNrsavPnD/7Vp0hh32orR6NnWcN5fIdfPyBK3BLJt3uPLCtlkkawN6ySmgnDM7aoD8mjSfb2CdTZPgFPjGbjXwaM5ZmPxkQ7DCWd8jQHBQKGrFBX7oAN9lBBq7oBDrIAycLT+cSYz6VJfjKp7v1loXOtPSQB90xp5B6EqGIt70aFzqn9oi3R6ffwgf+qYOkc/3BH0x2Q8hBrBj9+EilOVLW5kPcCOl7iXZhCqSu0vqQAuhpyZ688IOA12X9et387fUCSAXcKDM40qXhfK2YBK6S/WJQ98uqdDLzMqq5RvSzBSDz78lrlUoVFuNZoCya+8JYgxRhJ1WMdke1Pr9Z4wESmIGY8pCHJWO0XNZzfvPucQ729azLlzG6I37oaY/ElmoloqqB396aEnIvND9WGtQlnA4QZlhnGgrErDV+gFkpzuaU20OXQPMH8lQPg17LWNR/QO8wmIEOnI0rjzFLVmK6rRJKFaQuz5HuUJG/eSQrrI94W8emsoXVaRJLd3w9B8v5kJut0yJfPq67IUa1qJqOP7ybOD1G9D6Att/d6dgKA5QIi77stpTe5xsMuqfztHRge0/zYfyyD2WkTMEMuk6/+qR4qu19vRu7Sfl80bOr54ZtkBJdpYAe7e6DOCfJjZFnGFXpmhrALkmuu0C9PU2jEnQFsv57Md9/58yow5B9hZ8/amAAXAwAhcJzNn8DTHYxrFcz5Zws/V/gbtMQ2HFX7lM3tDqRDXSp94LDhxajrsp2TLt03Y0RgBZvGie6xbpB9KnWREEGMjlRFa8p1JI1gydwHrwtZqwyUs1CTsxBW
 fY3ripoI
 4rtf4rF5uN3giPrJd1vi5cQk8MpE29CWgso5yLntWlMPoZzE1LO710EBFc1yHFJ0CdBcIjtLuQNoARohxjzdwLnUmvEF1CQTnuze+x7pmDp5nzMfcACNqaXis6z37rpep1+2wUvXBgS+65MiIl7kcDP9GmLylp+lqcXqejlOmDR/H4JZ8kwuXk6dp0gGT9MvPQyE72c40yHWNaSh1Y+Rl6nFjuPx9ktu27Xxx0X+MjbGhBKU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-mmap test fails if there are no free huge pages prepared by a
wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-mmap.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
index 5be68fbc36dc..d4edb233101d 100644
--- a/tools/testing/selftests/mm/hugetlb-mmap.c
+++ b/tools/testing/selftests/mm/hugetlb-mmap.c
@@ -107,10 +107,9 @@ int main(int argc, char **argv)
 {
 	size_t hugepage_size;
 	size_t length = LENGTH;
-	int shift = 0;
+	int shift = 0, nr;
 
 	ksft_print_header();
-	ksft_set_plan(2);
 
 	if (argc > 1)
 		length = atol(argv[1]) << 20;
@@ -126,9 +125,13 @@ int main(int argc, char **argv)
 	}
 
 	/* munmap with fail if the length is not page aligned */
-	if (hugepage_size > length)
-		length = hugepage_size;
+	length = (length + hugepage_size) & ~(hugepage_size - 1);
+	nr = length / hugepage_size;
+
+	if (!hugetlb_setup_default(nr))
+		ksft_exit_skip("Not enough %lu Kb pages\n", hugepage_size >> 10);
 
+	ksft_set_plan(2);
 	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
 
 	test_anon_mmap(length, shift);
-- 
2.53.0


