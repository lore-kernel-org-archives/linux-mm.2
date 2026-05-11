Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2BD4CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13EF36B0110; Mon, 11 May 2026 12:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F0176B0112; Mon, 11 May 2026 12:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20826B0113; Mon, 11 May 2026 12:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E11176B0110
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:32:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BDC47A01DF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:21 +0000 (UTC)
X-FDA: 84755681682.24.1BA42E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 272464000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OIbPEUBt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517140; a=rsa-sha256;
	cv=none;
	b=erQlXw8PJou6Q3J3jHXFPxLBm4wfvSGp3Cvtlclj11eCesbksUpTVmClKTEJBFBDuk5WDx
	86NU/NnxLUva2TCR0QhxUrhhg0bHqc5GxWfyOwL5P0glUgXXtfVBUTQVNhNWHTjXYxRt7C
	ah5AvRmcHXxcPwxI3N11mleh1yzMJFk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OIbPEUBt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ey6MursIq46BVJioKdEMtkI7vqEjOURwkXrbheOCIAo=;
	b=M9ATv114gf5lspppWBww9ECE7fH3kleIwcy1aPd3SxvjQXcarrtSCdPOQq3kU/fPHzMw9N
	jVFxMMLK0OuptHrFAcJXXpbP7RVhTNO1A2NHxlwkgxszfrQeAcRtb3AETizyO3uViRkzhC
	wfEhZhw8xHgs2rmlr9yL3AxAeR7cgac=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FF3C401BE;
	Mon, 11 May 2026 16:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4EFC2BCB0;
	Mon, 11 May 2026 16:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517139;
	bh=YVYXWaui0hqfWP3VUtK8ikIQcrhT3q00nNtMudFfz4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OIbPEUBtB8qXQdenD2EU7G6GvPIRrXbPSmQ+OGUCez3b/mhQVrKznUnjXBj7qjR7s
	 QZyccsSFwpoLb/QocoSC1CzkY3PVlyOyLAJ6ACnJi7gNyWvpTrnV3s/e3XUN3k/w66
	 AzWeTIYdpdEh0gaKIVKTpFUdUxgKEocnbIBzgtWMuNrFi8oM6nBr1eW6nXIL99SW1P
	 14xKJ/iWHcmVHWh3eUOdfL6g08r+GmZSQZN1zEKs9vBBDto2kCIxOH3NpSfMnnH8Ne
	 bme3A46bRVVgpwOrN8HQtbN0vvJhWfAFw1om9gvufWLtdbafy4JMR4NNNOpbtpMsqy
	 jAmaRtCdVvvFQ==
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
Subject: [PATCH v4 32/55] selftests/mm: cow: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:16 +0300
Message-ID: <20260511162840.375890-33-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sofqjdqfk55c4jt15u41b6fog6s6tezq
X-Rspam-User: 
X-Rspamd-Queue-Id: 272464000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1778517139-631814
X-HE-Meta: U2FsdGVkX1+SRoMlouuOiCo1BpPYkonqFpi8/z4KNUBncMqUc8Qi2eTKHHhWqHcOqoPjYU8xcSJVdRry0A19v9S4PccBCSr5iFmvrgMVLoz3hqelZJQzZnPUnF8fEJ3zE6qcliUP+bOw+/pryFrkjmx5CIKlWpzT/7RTxrEStnikitKa+b1v7Ghyo9gRZ/y1UDPptMnyQA7o8SunuR6viT/0VjYC4IMayqr7krxS16QfSnZ+0zAVphjxc9vRa8eNfucmSsvA4vvORjTUnbD8sBebBN6+ce28vXPaW8hh6BxvSkItQXcABGguTYt0EJSf9H29JAx+Pknm5wLIeYqcoqJPYXdah5GwIjbSy8iskFQCZvrF2HuUSOCH/JVAVybq9ETN8NORwB9pGg3mj1lURFBO2UddVSFXRbhqJlWahZ4pYi05M25+w3oi8D8Nhy4KzjLPC9dflamIijoQ5yoy/pAEpqH6DFaPCHGSnKHt5OuM7bujlKAIEfIUjloFm5izRCwB1f7HyMrClAsN87cbI/5N6yTnbUYUi78TtQRR2l5wloNkoS57vDCnYz7EPTyBfCp1UMd1/VLWY++388Sf6SD8OfN5t2lAeuUy7sr8G9adKNTPCocste6aZfILLKw1W4+grm8HjAp/8/weR2wJzcaM6Z2x0OzluAmXCAU3WRHSOdSRokjS7G5EkYyhoat6YGjMHnG/MptRPK8K0aDNdKVpcLp2813+5qOJaWQDTTXAVzRPZ3WEnE+SrNl1sVJ29cN+xfSqrvaJ0wOjgPLZ5nSK3ehfzqa0ujIhWzAgofgMb/H5W1FUc7/h09XYV5910iAtu7qn4aNY9oy6VfaAjITRulxCg2fciJYMIVDCkSsaMwz2ETqScLDh/itrKOfuLpGxSw9efS15ZH09UjM6Wrcyl9DWEwE3d/IULUKkMw9O/sowPYiYcYuWsiNqWWnIGQZsBXah/FyCXoqOAyU
 f+mSrxE9
 bfFj3PIuLtd1HHsgkr95UaqZuUhVs92ItCAFhE64H4Pc3G6ye1y8OZj4JRytl9Kllg/yCWn392lL28s0qVdYUGn1hDDYoDovIwXXuQyevKoyOtLvIJZWM+o67yuR2+UMCl4b5/DuHgK5YrABDlXn8nHvnSzY0p62kZL01a3woJFhRr8V5iQQLyJ41SV18lyTPbMDrz6EliaRiQiuMkUoG9sdYUDpAvUi7fwQnOfeVTgtdNHOn0ZONt51R2E/LXCVRg5lEtg1tOw29CK4PZupt1Kd4Aflh4LldRVpHgmF6Hrk18D3dhsZFIBBAHUnj/lhsxu7m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

cow tests skips HugeTLB tests if there are no free huge pages prepared
by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/cow.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 5e571216b8d2..0c627ea89ff7 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1881,21 +1881,21 @@ int main(int argc, char **argv)
 
 	ksft_print_header();
 
+	thp_save_settings();
+
 	pagesize = getpagesize();
 	pmdsize = read_pmd_pagesize();
 	if (pmdsize) {
 		/* Only if THP is supported. */
 		thp_read_settings(&default_settings);
 		default_settings.hugepages[sz2ord(pmdsize, pagesize)].enabled = THP_INHERIT;
-		thp_save_settings();
 		thp_push_settings(&default_settings);
 
 		ksft_print_msg("[INFO] detected PMD size: %zu KiB\n",
 			       pmdsize / 1024);
 		nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
 	}
-	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
-						    ARRAY_SIZE(hugetlbsizes));
+	nr_hugetlbsizes = hugetlb_setup(2, hugetlbsizes, ARRAY_SIZE(hugetlbsizes));
 	has_huge_zeropage = detect_huge_zeropage();
 
 	ksft_set_plan(ARRAY_SIZE(anon_test_cases) * tests_per_anon_test_case() +
-- 
2.53.0


