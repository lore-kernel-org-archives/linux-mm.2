Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F577CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 956816B0121; Mon, 11 May 2026 12:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 906876B0123; Mon, 11 May 2026 12:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5A86B0124; Mon, 11 May 2026 12:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6AE2A6B0121
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:33:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 283781201C5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:14 +0000 (UTC)
X-FDA: 84755683908.25.5300B00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 86D38A0002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RvdcrMVx;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eYwQDqpAESu4HdKpIHMpY+xmm/eBm6IA2j3HFZZjzIk=;
	b=cccQknSLjBsCDLDYg1iuFfb89Y10LH8f0mci7fP2HaKwgnZk9Y0PWjRSd/vIM/T7dB0b95
	itI8j/QrjU7zmYd1sNCVSegHiXAgg6Vq0oYVnHaX4TCfnYWg1RQPkeRz4oAXwgxz4sbVy7
	RDPn0LoFjVPLnDXhFo4OZeY/Eb+Yq98=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517192; a=rsa-sha256;
	cv=none;
	b=iTtiAX1WKV9tOuOCiszXEgM17pP8TA0R/cZUg3mO6CbBuy8Xha7n854Gt4MFeTDNfS2IOM
	IomStqiyJohXQQXTxZjbCXhlebSa4Vt0z5bUocnfjcBPrlxHHuw7Lxr0WsF9xtVKZsaRIA
	5mdXcZJxVLCcQttDhmhaelAHCNONJ7w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RvdcrMVx;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 18DCE60123;
	Mon, 11 May 2026 16:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB2BC2BCFB;
	Mon, 11 May 2026 16:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517191;
	bh=HSX9kg2IS/ubAXfSb84boVRWxEKf4aiyTi8nFn1g0Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvdcrMVxgTlD0DLApCar0Phrt7oyJOPve7nnS6YFXtQJvp6pDdFEBBDqOkpaGriMX
	 MOsqY29mubuJ7lbNZWYNpsjvJ+BEmiXitkC+yLfg/uCkG0QMnwd04wHlSzyLFrVHgc
	 e+516ign+YOGQ4MZ2ZB/YhnWQrx9rSfRBSum2+YoFc/TgS5DQ0g06FjJ1IbMiJ/LaD
	 AaH9axL3mRkwBP/Zun5odG3Ndo9n59idae/On20pAQoiad8uLCgMFnm471z7CG/NCa
	 W9aaJ64kZw/5ifkij2S8v8snkmv7NSbsirSx2FUwne1Ng2R1jjugfI7qz9Km7eg7Gc
	 wWoVDysxchadQ==
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
Subject: [PATCH v4 40/55] selftests/mm: hugetlb-mmap: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:24 +0300
Message-ID: <20260511162840.375890-41-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 86D38A0002
X-Rspam-User: 
X-Stat-Signature: 386bereg8c7dx8xg4hecmsa86ce9sy7a
X-HE-Tag: 1778517192-882940
X-HE-Meta: U2FsdGVkX1+OcTY+4sVCBNO9WlZh54GQE7GLVpmCTxwwdU6c3Q0aEVK24ZXeZ+xQ5ibjVJwRbepBgT7k00K2L9pDtsXOIioI1FnSP6ApmFmUZjZpwZLTKhBkB7QHfgU0ZOzH3PiAecEBVcxnqLNP6G0I+cosVUcK4R87H0gV1EHiCp/iR4xwuP7U2sgFgZwawRA9LivmNnD47Z0knPbDK/w4gA3H+V+uczqYcAZd9kxcEoPXp3WjYSduKUODqvRESEZEvInYL3KfTlu7XWhGWDywVSuU3o0slGh9hVm3fG+VdgOhO21TRygSvzVFlZ9EBHwJy+5Z304gCegoRSwxTJwiYuxPKFAdG/nFMlbUg0k0ZZIf9+89L6L+JAXUPT6APaDoxrx4JWG9orHqbmCevKiLUKwV7t2Y0T7iEKrhvkvNbuvKotWfTUgc+cl5NL3vFXLcvo+ORtQpmP745HHJl7+Oh9ZCEReI2T+Dt0QoIJnsnTqnLMT8wk+1EG85vy+BCrPQhwDCXQ0t7XCzRy1qXlZJ2IwWw7iCIo8sLkUq/ewJCQPZS5+dacOoQVpSpdeYwn5onJ+gWqVDyXAzPTMGV+1vnCL6ODOkxnl3ypRXDIa9jqGEZomEanheEkfmMs5S/gLt3iraaCjWY1iEcXyjsrdy7O4D85druUQvSkXqT4RdtdZfk7/5qm1dFO8rCiPrcHZ5Dn04mUc21xotLfOWjDn6RK5QhGSlzRKQhe/4tUtBVMiVpNq4WA4jR1NlDBTThc2UP8Fv/m/piQwFFVxkulpC+/Xs9/HzuoXm87VNDI/Un4jT5nM08gBxUX1MMRV2aYGw9GD4fuy8zH7QEXPhiBIg2NsGWxNnd22hFh3mF/CnaDbAEe6qkL7BKsuDcqCYXy+IUSaCfj5HyCnt9Ejy6KKGg8IOE+oxXzEoXYVp0W/+Ow3DRmv/Ss9sZlN9mVSW7Arc5iho3vUAMt4Ab0t
 Nen1qe1Z
 s8BLLIhqA9Rs0WsS1T5unHvCqUOAe4y9bssnZ16mvH9iyfrFGCHNBSA/k/9zZOaLO73I8QGT4Ly1BH4/3YOC151T2ZGy8exAMhS8ElInb8fkfKoumnxdYkjnjpH2OTN2v2O44uJI3pOPGL9t3cZLd2Euj8jZABWCulX+YwMAF4rg+kTm5IQSeBG2cK1yE2Z/bisGdHzUCV40J6GJAML1aG/MNhmF681X/jjE5YuoGrJQFZldmcMPbub5yZYLoyAn/J6qc4LCZGxPOnaimPO18+AfBPymRgJi9NdFEuvHCwQcwPPkTIqe1jW1scg==
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

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-mmap.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
index 395be5d0dc1a..0f2aad1b7dbd 100644
--- a/tools/testing/selftests/mm/hugetlb-mmap.c
+++ b/tools/testing/selftests/mm/hugetlb-mmap.c
@@ -105,28 +105,35 @@ int main(int argc, char **argv)
 {
 	size_t hugepage_size;
 	size_t length = LENGTH;
-	int shift = 0;
+	int shift = 0, nr;
 
 	ksft_print_header();
-	ksft_set_plan(2);
 
 	if (argc > 1)
 		length = atol(argv[1]) << 20;
 	if (argc > 2)
 		shift = atoi(argv[2]);
 
+	hugetlb_save_settings();
 	if (shift) {
 		hugepage_size = (1UL << shift);
 		ksft_print_msg("%lu kB hugepages\n", 1UL << (shift - 10));
 	} else {
 		hugepage_size = default_huge_page_size();
+		if (!hugepage_size)
+			ksft_exit_skip("Could not detect default hugetlb page size.");
 		ksft_print_msg("Default size hugepages (%lu kB)\n", hugepage_size >> 10);
 	}
 
 	/* munmap will fail if the length is not page aligned */
-	if (hugepage_size > length)
-		length = hugepage_size;
+	length = (length + hugepage_size - 1) & ~(hugepage_size - 1);
+	nr = length / hugepage_size;
+
+	hugetlb_set_nr_pages(hugepage_size, nr);
+	if (hugetlb_free_pages(hugepage_size) < nr)
+		ksft_exit_skip("Not enough %lu Kb pages\n", hugepage_size >> 10);
 
+	ksft_set_plan(2);
 	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
 
 	test_anon_mmap(length, shift);
-- 
2.53.0


