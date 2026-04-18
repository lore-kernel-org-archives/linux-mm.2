Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEE9EF99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4393D6B0272; Sat, 18 Apr 2026 06:59:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411346B0274; Sat, 18 Apr 2026 06:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301086B0275; Sat, 18 Apr 2026 06:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9B46B0272
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:59:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D973B13B04C
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:01 +0000 (UTC)
X-FDA: 84671379282.16.0538FAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3D5A840002
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:59:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CifmbLgm;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umrK62tD842NVDgkjrkpVdzwMt3bzLGjIrm3m7z38uw=;
	b=cf8OUO/B7lVzCV53b9AR/yRcca8kValQJDhX/GYfERb6xX/JyZRm3dhEZok5o/QYTgddtR
	xNvhl368lKnJ38uO8JO+Depa8vnqQkP4m/iJIKOtAwrBubRqUK7YFO7uhMIPDBK98fPvv1
	r3dYg8unMl61dDkVeKSXHfhBTc+Bp2c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CifmbLgm;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509940; a=rsa-sha256;
	cv=none;
	b=Hvy86P0HV4bTenEV1n8ZvbrfJhBNTAfRaoof6GhlcIS5RtpPItL0Vh2k/gJzvd6evBbyMU
	1wSkg/2GJlm1qLbnXsWEXF5nlXvFKUcLzttW7sFbfXJGq5uRmfqCr7EcKbQP5rAydgekRC
	wsOiA4H6BlE6+7QBWhxH/pIlJcKDM9E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 620B843A32;
	Sat, 18 Apr 2026 10:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B129C4AF09;
	Sat, 18 Apr 2026 10:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509939;
	bh=+OvcjE79uMeuRExtXX4z8n9tjto6YL9x88apIU5Xm3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CifmbLgmAlYE+culTIaik2iqjJ4EbB1Ar4Y5N/59otRf5EXwd4Yr3umgje2Gx1GIY
	 f9JhTb5PS3bvcQR0AuKtiAIeukKIkSnvrIv4yVvaKRWGqrVlq/fqraOk51/Y7AHjer
	 2g22X79fpc84uQRYoyvTD1N1nJrc0l22Ncvsr17mKy4nxupfKQhBu1TYutvkppoGM4
	 wbENnbaiIuHYYa9AkuOVUljTKkfEC30uteprGGCkc6Q7aCcxgYFUL/APOU9Zh7tIUh
	 oGGJNFVA0uWyPGyc9BbznI4FUcS3FRuAZs2IDZ6VP40hTuWZUkp+B+HxDHK6q3m91b
	 QYQVHub0LcmiQ==
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
Subject: [PATCH v2 31/53] selftests/mm: gup_longterm: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:16 +0300
Message-ID: <20260418105539.1261536-32-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3D5A840002
X-Stat-Signature: uh55q5ud53qpghnpprybqzhs6aepmyin
X-Rspam-User: 
X-HE-Tag: 1776509940-87931
X-HE-Meta: U2FsdGVkX199Nh2iu1KKDCPuy1s4s9tEhgL5IcRdBuoiv4rlQxjqjHBoCOtchYb4YUgOnU4XDy6t0QZc9X73GbzVjU/QvqKtCj2tupJWNaDn2vcbf4okmjdTw/oprplFdB4Kwf4lYIFOAxARM/VnF0X5QBxGe1gofy6kznZhVR/3nBl8Y82BOUowHGWAjRTogNHRQStwn2/HcEW4x7BVGcXD8LQfGynRfoBWa5DDBJPJd9oGPXfEWGiBFIctYvbPL80yadmqHkyOYbmVE9m2swojEBwZGLXmgKIdU8eP4cquEyqg2cLMY/WTF4TJvrtlP8elW0/3uLuc9b0/pv4Ut9XX0O0RN7zURfaepVarjwH+pbIatUZqx9nKYcwVoBDTL8cNqMuvYzfmD+vfV2L5Gmu3jxi3fyPr4QnshzPfefufxcQL4/X0TkCDALEkuQ7P2mpsBijkR6NR9V15UXIoagMep9IkoT3bQThr7ouqExyc9PCAFKLNEsCZ5EVnzJTX9Pr+LJOGJ24B0diQIOak127aUf3J24mxuv5Fhkbo/m2e5UdobjezujufwSrMRvKhpZDpinIn0fnVmEpS0VavtIn8HXas4bTWoeKsbYZznRrUuiyh+fBKG6ov5yJgTGnqXwjuTVaN9+b9CqnTknaFYPXsul6xpToDCPW2qIoximuJBU3ZZF5mn9L8xntKiLYwqRhB7RZFN14jtvr/tY1Wf1hNOemNiaR9gh4nXBG1yeWK5A6bIwcN36HHWilQXojsQUa+ohlwHHsKbMGTxcmw1JY1CpqS3l/9V7oVBGcgrT/6t2s7nTN+D6QnaRaLHDB6GAjCmidIAoxoJzCV4fnwzEAxHs7zUIXSz8MLzU2QZZw4J9MqDWBKJHHcGRpZwEU1VOCvX2uUlTE0i+vbhWyIGa5DI4POWmU7q8r4k42c+ZUbY0Xj0TM2FbAf8ngM8GjEgiWaZNkQTIK/QvBK8JG
 Fmnutkoe
 kSN4NfxZKnNPmhPjCEH+/Ad44Vco1mT6+sUvz2YRP+Uwbsgz+n4v4iOxMEi1gnNNiagjg4N5YQ1CDA6VNgjt88LrNgE5TGGQIElg6hAd/GEb0QP+NkZR1rt49dl43SPA5wxAve5ZKTbjno7eSjwZVQgFIGHgvMfKbvIb1+/aYdlwxuPC2ZirphMcdN3A1NQantiOpnphN8sHDuL2RnGZ80aek9UH1jwOlnQWC85+E/z0QJDZPyxioCqdYSx1b37QkEIwGmLNmfM61PW9kVSnfo8/Cwm9hnFKgnvpT
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


