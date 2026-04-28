Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A5B0FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B55DB6B00DD; Tue, 28 Apr 2026 16:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2CD66B00DF; Tue, 28 Apr 2026 16:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6A6F6B00E0; Tue, 28 Apr 2026 16:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 947DE6B00DD
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:47:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 552F18BA09
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:04 +0000 (UTC)
X-FDA: 84709149168.19.7B3330B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B4F49100007
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V57v9J9a;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EpAGWcuUwzk4tuQGzyg1x4+kMp0pK1Lu3diDB47CC/M=;
	b=Kh2vprjduR7941IOwDio5CxV81U0pkwCKr6qQRNAttzo0zPZLkeS7Zg+AgaiWxEEQKjHxn
	biPNv3yBlrJorcLqmAM/tZTswlmSxTdV2RKniMmeymWL9e6YlLRr35tCkx+2ImmGt1YAeQ
	BLPYtd1lqb+uLnQXgYCyDPFbC17doko=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V57v9J9a;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409222; a=rsa-sha256;
	cv=none;
	b=zlF/wt/5d7oD/Sd89lMdVxqKvcZn7w5efJrn9VJwyL7BuwyR3yzoay35Nj/nB9G5cBA779
	gpY7/6k+amEBnI2NiGs2sPdJoVM8M0ewjWTKOICLPsn0CIZsPrE/ton0v0KesdNlFXtADd
	E4MImeTbMi1oVWGwZNHs3ZsNHrf4HgQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE5C040056;
	Tue, 28 Apr 2026 20:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732E3C2BCAF;
	Tue, 28 Apr 2026 20:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409221;
	bh=nlprzoVHw1LmFezPWbTzVMDcbCMocVKEurNVLRnJdhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V57v9J9atU6/t5FqptjBfJl92fqfYl9DPBz55qkgpDwRR/I6sgRiD6xQBGTgY8+Qs
	 goM8lUWUX9kY3Qguku7H3K6DSrqBJtSIMCumto/brJOewZFHrh9RQ2e96HV7uO9ejA
	 fzP59wwZuKOfemit0p/p9GaY8roQbtYVk8GqjqOfWnsC0daPMrpNFfbB4c+TX1qzIT
	 cfEot80Lv8cNZk81LAyiIyNrHyz01HGdLP10fSzc6I0QWGObIVRBP4ZoiGenOVXLjx
	 UGHj6odI4NSyGl2+dvvbphiPfz/BrfVlYKSs377nPAvac/iKmloBNmsHIN48xCiv+H
	 Ta/n56MnZpn+w==
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
Subject: [PATCH v3 38/54] selftests/mm: hugetlb_madv_vs_map: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:24 +0300
Message-ID: <20260428204240.1924129-39-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B4F49100007
X-Rspamd-Server: rspam06
X-Stat-Signature: dqch7ijb6fw9q9sd5scygfbieyfng985
X-HE-Tag: 1777409222-576486
X-HE-Meta: U2FsdGVkX1/jj1G8YJEff5+HpyBmNnvUcgVNy3KhZtXyM6uzMVSX8ugJ7c+mEUJlZ1RPeme57Y4RFT/cRTc0kd8oc9sUysEa/oGJN3UZEXQTkFgC0wQaiRtVu3RTGNPpVou3Xns7bLhZIWPUlcc4rxZlsXLqPB9lSrx01ml9jvKxuCEJTC8N8luHJe9b2B9lCUYebjVSz2Z3zJaItcP1ZghmIrNJ4+LxutLIHZZbvlMGr/AmmNN/qiy8ao95VrJy+J8eQd05juSb5MGjdhyhdQbxtu5a0RRTciKzIMKUmlcvpRbXrrTKZt9dafsv0OyP2taQLZPkTQlnkqAwBFXMsn8/bsAL+hrjFYctqSjkgbJFRICqlHEyFyvEZyTGeuPMIj4Y9c3SY0xri946mL2zJfLN1gSdoz622blT7dtVIADe1zYKsDIIrx91wf2qs1ZXm+6zu2qC554T9Wg55kFqXiTE1JBnByy4rAkxC/e0if+3KsgpCCzYiVZK17i+jYhuP0on00x2jQ816KztocWOC2CK8gGOlho/bdEsl6amjpPU7j8Teeuy43CIcGCkPGioENZli0f/z+OITeTWvLrJdmizzA2HmJRxWNtU13ftoiutgrbCnnPgoyFyacFUUHsLjzPTNrDvv4PRoADIzdgfHlOe0aeNUCWIzkgVY2uoraaRhgdTIGnNfM5Z/cKhy3h+Ey2wnl/Q2+Ctv8NZ29J24Fr2NLZDFbHdfiag7dEeTv51FWbOp0nnUCH7hdmd2FKUCA0MMSYOen9TEX5yA4oc8QX0WCMmepx2GwHoF2PsOmGo3UQqFRmChTCNp+qmZnrwpXxzaEkTAXeKMO8Q+CEH/XBmhacpWPGIqkG23zE2YHcrKD72F2YuSsp1PD5rXeCI9nt0AAhDPyvNOA8dbVmXShHr4kKXXYTKji5+Og4x95s136crMcAf5qV4sGQemp6f5wiDbnJq4H2OEEueAbV
 QgzxxIdd
 GLe5dRE7dnwb9T774zmEOOq0oRz/EcL2z5wG56fTVLcw1HYcJ7qHrNb29iEK3q9J7N1yBWgbNy71G5ws7r3Y4H6pGtZPyz5IiQBu6+TPGoBS5bsFMDs+1kVTFJ/PDcSe5IEwI2KNY5yTdMidUFaK2hihUs3I7ke+tXfW+4t1Rl069LdF0ygbQAEnThgH2Svnscj6dm8XqekFVdIzUeAflUfjxdHC0d1PZ4j+8EcgjczD0XZnMVC6e4HpBTIgQYQzHvXfgjDafwH65MAmvO1p49nvom3llOHd5FFMi
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


