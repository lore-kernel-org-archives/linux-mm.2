Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1729F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181F66B00CF; Mon,  6 Apr 2026 10:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1592E6B00D0; Mon,  6 Apr 2026 10:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095DB6B00D1; Mon,  6 Apr 2026 10:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECBBF6B00CF
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:20:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5DB6B9662
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:42 +0000 (UTC)
X-FDA: 84628341924.03.301FD18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0BA361C0004
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SMrtrC0F;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3CydojST8YyCcBkw0GPuSQcYMWLZte5wcCWbjyBKns=;
	b=T4tRdXU+mA8CyPfWB/k8mH8jT2xVGcfWdwvGcSKduA5QqsL8RjwAzrwGO6HK6C+6kIrxwA
	D0/0IY+0qMc37ENbiSHO0TIJo+qF8mRi38G4aLLOd0bPA99C9h0XduVc8sxKW7DxdaElVk
	PZEySpAXc/EIxvsN2NQlG8uiWTt5NXs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SMrtrC0F;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485241; a=rsa-sha256;
	cv=none;
	b=rXP+5CxtkO80+hBKzpVIB3yP6xjIK1KZ7Yel8REZWI00gNtISBfBYcguqCOYWPL430MEaW
	Xv+REEgDXCslDfevUt8kOvd5YAz/BtYEFZ/KdMUUNLsJCXjsrMnl+Rrs1J7byCcfyq6vIw
	7kYIGaJJYD8pLhNU1Gv3y+Y5SjHxprM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3769D42DC2;
	Mon,  6 Apr 2026 14:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFA8C4CEF7;
	Mon,  6 Apr 2026 14:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485240;
	bh=1/ugYRnvvCSRn7Fw/zm14SmACzlAtT74uoyJWfVmAG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMrtrC0Fb0vXUxWdcq2IeM9vlYHdik0CVDmSy+BNmVRULOd6Yits0G5VhY3e4fU+o
	 gRFKKG+lufn0l583rAWj1+Br5n3N/rcFo3k+9BaajBuw+Qn/djN3OlVNkqe+381Eew
	 EjPSXCG1l2TB9Tk8TL2Jvqenuku/XeYZ49HvN8KZpdIJ+XcdTn7Exy7KvSKaFCZFZv
	 BktJ84OHoMyO/anyVfyIgRRLv6MSPil9iq3gBfHlNI+FEYzbrd8SMQAWLeO8J/fiZ9
	 lagWs3GdjznjlJOgMmpmIjm0i+fHhyH5ZfcLyzjXgO7LXrKU1eC1NvmUaNA2qfUQv6
	 lfwIqXgI9hxMQ==
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
Subject: [PATCH 30/53] selftests/mm: cow: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:12 +0300
Message-ID: <20260406141735.2179309-31-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: f1q48ww39qqd63cph8aunrfgtmeof7ou
X-Rspamd-Queue-Id: 0BA361C0004
X-Rspamd-Server: rspam09
X-HE-Tag: 1775485240-513626
X-HE-Meta: U2FsdGVkX196vq3kR/+mvNs2z0Bf4BwUbO4J6XEf9HHeaoygh6qAmGYp2iZegsQ/aXcxSNrYnXDMghEnwsQ6COsDQvv6VE0A2ubrS/a1CSATZvIAVCZsXbqEnmjMjTaYbElOGunpQypXpVZg1FUYRs93kAT9hdxQ/JgT/xd1jzSZgWTclMjFItO7yXAPnIBGG/jdvLD/uopJ5DgNVqGs2pBU9YsIUaGIKhJfCHwgqNnNCzhvLPTMyaBjqL78z7mlvhEtU8RLWIk55EEgGO9N3VHEzfwB241P9dI5Zh8orNqNimfHbRoWbsYozYSD+KHqzzlhUvxdXctunyu/fbPSFf9v35LwfytAdxZJGI2VIfjpczW/0ZCT4/8q7rtkGh/yewa2GOdFVK6CTQHzMpQlsFd8HljbWX5ABXKe+/P2svu+NAsb9iHcvEHtcJS57KRUyET74BU+FUHC39+Xn5sFXcSlJ/JKCEUh9t7wEGq805Yc81XTAQZtz0jeZwOxXIXiE7L3UnmcElFKZM8cFSwDJBKiIk3MqF3GytQk2VNg2Sr/2jHba+ctdAO6XMCWWJNG+DE3IKJGKxxfIcsSOd18qGJwRZqAK2sGR6+mKbTZDL8SbKWfeOA2e9p7P17214/cucXIbH/JB5nwtq8IeTVaoMKEXbImRaGg82adt8RRhoMjH6xaMfX4rK4PHiRt6IH/hqWeobpfKvJs0WYKhb+HOsUdCE1IhBEcOI1gqDY67jIg+clurnnaklWQe4zhzx31opqgpXtxWVL0bVs3g9RTVADdtub0w0ex8Z/Laklm/oM/4O5y99BexV9UUu/3vRY5eST2yX3fNC21dFZt+Wi0ufVmIAPm/KeK8MuQ5DkSV3wc4atfCPDoGi/NuH9FPKpo9reHJ2+HDfQhbeebvZ4d/RqRuu82rAPdxMWTQOr76mP3qh/fBlAM9D/twhg15OUxVT/IV7j5Hrc3MGWoyPC
 L/b4cQpQ
 OCFdX4KCowoC7RVH30Dv6oQFln64WVsc6oYaB7q95URpihp59jKTHlljU8JeRkbtLd8d7/P8INJ7pHV8clQUGFwL9iNHnYNousSqCSxYVJ6EFWEeTtFw2G7bL3WeoyR196QHHBDfLtjdzKGgOjRO8jMGVHbmrLxAqBZYeHonbrIcvE8KL44H87nDJPC9LBz7Z4S0lix7KAVK6lXWFI7tKedlBfXOjfcdTyHLlZU/W20Q3bRc=
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

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/cow.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 4321f4208fe3..1df513bf362d 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -1881,21 +1881,21 @@ int main(int argc, char **argv)
 
 	ksft_print_header();
 
+	hugepage_save_settings(true, true);
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


