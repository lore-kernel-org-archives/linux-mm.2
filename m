Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A458F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3BBA6B027E; Sat, 18 Apr 2026 06:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13856B0280; Sat, 18 Apr 2026 06:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29066B0281; Sat, 18 Apr 2026 06:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B06BA6B027E
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:59:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D2961B80A7
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:38 +0000 (UTC)
X-FDA: 84671380836.19.BB02555
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id DE470180006
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j2DTbIwr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509976; a=rsa-sha256;
	cv=none;
	b=ZzPKaFEqsTWFbeCE10T9r9mdn5enPiFB3ykdI2tv9psdP+f+vricvXQZMVeLgpj+uk2+LQ
	m9tOnQbuvogi8Y/9r8iWsTenRrT1vfGf8vIX7DwOKfaHk6c72jsOgrlWdTXZpQH/PYsPFs
	4+qkMDHeBnIbzUDUIY2Y53586rBnJTU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j2DTbIwr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EpAGWcuUwzk4tuQGzyg1x4+kMp0pK1Lu3diDB47CC/M=;
	b=HZeuL7nlu58cMHpjlpZ2Ag4Rz7XxGb375DC934Q2e24juosC9Vic2k5VAqTqimQPL8OEqF
	3326nqPzDrgQThg1UFEHTOAW80e2QJli7eqivmUNAWusurQiO+4d9Umye6zl6dLLur6C20
	Ux3kJIZnTidJExcC56wGxb/BqlBlHrM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 697DE60138;
	Sat, 18 Apr 2026 10:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A51C19424;
	Sat, 18 Apr 2026 10:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509976;
	bh=nlprzoVHw1LmFezPWbTzVMDcbCMocVKEurNVLRnJdhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2DTbIwrrSa8Hts3VR6qfY1RNGaG6RknLFZcI1ZvFwC0lB0XYhXR4Reo2MvniGN6n
	 xFvPuudLgzqPjC4UwZ7OgqnA0dXtyIo62m7iwpdpGjJsr1fwmUsXfXPFJvSaVOPRsA
	 smLkx2xZ2wbR4WSlK8ebQREmRy0WQmjbaYN4AXOQTqwO4adnnhmhEoR54jv3J12nUK
	 j9pDULmHCpb5iMCF26LTlVlbtNs+ysvPptTaoFVDymklFNsQUJk5nUAP4En8jEv0Ig
	 lPONwHZoUYAg54kSqDXEFsbI0bHj2CPD87SGUBzdmYnWk08rLNRTTqndJjlJYE+BnC
	 eD6aVcNWGzPvg==
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
Subject: [PATCH v2 37/53] selftests/mm: hugetlb_madv_vs_map: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:22 +0300
Message-ID: <20260418105539.1261536-38-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: 53w63soe378akkfuqzeqedw1ano36juo
X-Rspam-User: 
X-Rspamd-Queue-Id: DE470180006
X-HE-Tag: 1776509976-54325
X-HE-Meta: U2FsdGVkX1+tud0w3OHjZqPPxhw+bSGJ5qM2yjxHNgQnt63n7zojnjr8pUFZMZZ9QYi3zuhpPl4haWKOamg74jiMRB0b6Q9slsC+jvbVQ1rReZnD0TQwUrhFi+/GJALS971xlARB3PIdvbw+a//lyOUZVgZBoP4I4u9QQcZshPL1SYlkv76zxL8+zO081vdoqA7bO15BNczXS9a3H9VlSvJNkGgqn4fXzOw411Li8zvBO3tCzCvctwlZ5QV40jRVgU/aqAiQcY2CiGDvh1E6gLI0Vn6HoKGNP5gr8x9PsEOsBCWdub+iuRFK+VgmDtLQ1PL0uoaGUbSvvaqOwFzv8VJh03IcC7p6OHEZZKx/Wevn5r2fM+hKP6D/qPVJY0ey/vLXuB78w7QKYv0I2GsowB3PPglxeVr2I8HNK2y/8rocL3zMiPnh/YlRXoxL2WqVbplgq4+Gq/q//uIB6za+dNhZwTSNzACB03RYK+J6CViMEoetzPDDV+TxfCS5B/2atEGipxd/fVrnUSezrh6+0JWtlxZd+tBwsUEDf9QbMMVHDMapBgggGwlwW8gHAaFPHdNvXs+UJENQQlmnO9uLW8rEmyd5NWpJo9PbxxjedKNYwaNQ0E3cJuHAdiou2H4x8Hdga5KOafsc6X9d0dPvkoF2GYe6j3MBt48M+G8VhSTJidpuLuAo9BKH2C7eryTPUQaphVrgQEjpCMaFb1GQaXodjSd3NCRrHeDZBaN+Kig7LaGUQrOrONFh6D6+mHSHdFkPeGlExR5qQ2zTrQAvlxjT1+/4dpp6/a3cepvIgOlM/r1w0Xgeaq6AbMfzs3/M/BR/ca1tUdDKgDpp298TNpMCFbMssulQz3/1slunwdAhr+UQ+OXK3TmoJqFoAbzCijrfJslKF7GglAE5f+sHgLP3xDwEwqpXDzz+p9Bt8tvksFfDzJtA8QT4j2FdX7yJGo/yoeycSI9XiLp6MO8
 j9GvgoxE
 GTvUNOPpsIFnbvXqdakxLSbpNdVTKMXU0ngbMoH3W4H2GJtCsKjg/9GOBTF5T3Fkt+svpCr3/YQTVllqYe+nG9TX7w6MfpWnp9klVAhQzz+dqqzqWDrLZkd9eHPkCn8mdVmJlHuyeMbpGUu3FBEXlmaAY8f4XaO6vEHduwOKCVsRSLOVEbVTsAOl9o9zDzWPDQ6fFJsz4fcc/oUFbH7DBfx0sQdionxyQ2w7Wa+CT/ui5qpacIwSJp8SiBg5otF7O07FyWSYEBUknjgL3lxQZIQPJ3oHEBabtq/Kj
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


