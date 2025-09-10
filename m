Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C068ECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 09:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C79A8E001C; Wed, 10 Sep 2025 05:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A908E0003; Wed, 10 Sep 2025 05:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED1DA8E001C; Wed, 10 Sep 2025 05:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCEDB8E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:23:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8392714077C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:23:13 +0000 (UTC)
X-FDA: 83872801866.23.6E02DC5
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id CFEA7100012
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:23:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j22250Ja;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757496191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=OwSyD1o10iWevPOrFf3B/r+8Rf/e3UQsb9Sr9K8qp9Q=;
	b=AKuTmJ/t7JjMjKsZ6VP4rMssEo8sqMpd9jf9/95its//SuWME1NNDfSQraSRJyGAXcWpiL
	N7BxJU+jLW8sNO1pYPjxQl7UaeKjTn71yolEMxf/VvW8UXqHNx0J4DKhj1bH+GeI3pe4fF
	3FakbxGBQZfyGQonIx8vSEMCnfXV2rc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j22250Ja;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757496191; a=rsa-sha256;
	cv=none;
	b=UJYPKBdbiDLqevtdObvqri4UyySpyUjEwiS9L/SlV1Me3Yno7BKK1MPsLnGI7QeJ3YiM9A
	hzlNqh9Szt7p9feeVzLIPU/gQ2ecdvSoxbmyeuN1RkyWBYxlozztZ4R7Ow6WAMN21MzRYv
	wnNjPZ4doJKqKQrjb9Szz9qrbkeVo7c=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b042cc39551so1173703366b.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757496190; x=1758100990; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OwSyD1o10iWevPOrFf3B/r+8Rf/e3UQsb9Sr9K8qp9Q=;
        b=j22250JaQEDNxoSrR0km54u89FFsuaKMaDs1ZicSW+RQdvgNSzgAcgfSlXiDe1mzZH
         pnWCvBiJQIdHW3LWrEIh8t66avZ/wNQDtq25grvGgg+f3tuJjJYYPld+u/txPZvh7deB
         VsOkXUQnv2NpIZ4SXZlTCyiW5kXHI82vxZqhYOpI3y6ZOuAipa6Ng6vQ7zcwV+WLuUcQ
         PzzsaLN9uoSDgiwEgUVHobDq3G7IO+lfC/nPB9KeSMvnApOOiAmE3J8xt2TLEpW+MWuL
         iQGaCfyzwAyQkXnVUpjJNEVtGHzbemRjtUyJBKsYdYjBkvkrpEdQPiseHGQNuhgRt1XG
         HSaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757496190; x=1758100990;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OwSyD1o10iWevPOrFf3B/r+8Rf/e3UQsb9Sr9K8qp9Q=;
        b=S9SSVhrNbD1NTFYb2qE70DJnJAzL0FSqKTvSNcql1t/CClOqJFwRq30k6SxrnSjAuo
         ejlG7lhNT7TQP7bOX++lLpfw2jG/omFO/Q8j9aoKrEBKBrPvBsmivZmc053fNVsVj/wA
         f+eirzgtgGgj3W4q92WeL05KB3jXaBfAqVWpsCLQwRQKciWyp6ob3lnwLPO3MBNJjY3B
         3H7slV4Ltv48U98GTqzI7s0UJa877vQLQLALrKHiPUPEyKn2nyUFxeoOwJqfe5XZzlIC
         dVgu5BIq88GiTSAAolCSJWUEpbHhojR3yWQymOOpjNeboU3NUokfg1S1ykP5UFGc+Iil
         wK9w==
X-Gm-Message-State: AOJu0YzuIEyo54Q55Fec3uIKydywULfNgBGXc2Rr/0JscIAaK21NHkas
	OJr1/Dx8evaThpcvCaOU+hrRl5RYzYwQ54lb8SjGTb05Fq9GvnCtAV8T
X-Gm-Gg: ASbGncueLFGRCpfNNtV0W44HjDPMqfsoWRLGzB5365NSWHHSGnQuJy1tVA6CzQZMXW7
	swzlfwCqhjCeuRIPyP6jUjDX/pI9rWoVSxjShlTuztF+JbtsNYMGwuIp405rgt/0HIJTnu28EwJ
	r3Lt5pBl4hknF70B2G1vbNt2jSpT4x4rQMsgHJTBu3Vi81qmtPMv/7Hh+9mYQLTlcS+HatH4Lsz
	kTfKyMSGqA5z5qyzIOAcEKwtL3itWINdLO8R3VY3/H7BCo6wW0y1EayBAs6/fbYhIh3Or7sHX3i
	hXj1OsNZJ6T063PeSDjdQmn0RVOvzCrLBQ6uh3jhd9Q/p0ZgdqJuWITIfNkNLwZGHsXBYHXRgPU
	lZ+4pxPuJammmLgDKkHtlaNFTKg==
X-Google-Smtp-Source: AGHT+IF6sGad5ha3UD3E3awsNKxDEohMXtNXimOfu9lNMG5tf8Vbig9ysj7imBiyHb5bp/xmnzSwvA==
X-Received: by 2002:a17:907:c05:b0:afe:a615:39ef with SMTP id a640c23a62f3a-b04b13cfb31mr1323185566b.9.1757496190022;
        Wed, 10 Sep 2025 02:23:10 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07833a0d7dsm136216266b.74.2025.09.10.02.23.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Sep 2025 02:23:09 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	wangkefeng.wang@huawei.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Date: Wed, 10 Sep 2025 09:22:40 +0000
Message-Id: <20250910092240.3981-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Queue-Id: CFEA7100012
X-Stat-Signature: cukxk786sg4m1oea34up37mz1j8ftbp9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757496191-850500
X-HE-Meta: U2FsdGVkX18AiEbEFysV7FAPQGE6VEQX79PoKo75l+qPRFOKnef86d5oNU3epnaxGEigWCb0299IKm4QFAk8AJ3mOJfHXrDGbcSP+kq5ikYRDhDFRNgTcvx8kLJOsARF1mHvoO3EP9BxiTboaliuyipz3fDX5GkWtQVE3hkmFNP6tFKfxa+qEC1Ttdld3wjEt32mR0QUdec5Mlzx1P1cUOfVMiP3m6cEjrhilM/JTHi1BLDP+tqU31So57Y7+u3xoyXslnw8SuWLEAOnRyDo61/x62t7/U7uE0/tfCP1MJDbfdjwcF5wB5S8Ghl2PqJlLwxZZvP+ZKIXzX+Id6haI2f67qt2+SJ5mZ5at65i+aqqKVXE5nD3ZH1FeB7ADRPxz0ygEN4cVhSNXPQmyCJI1V5U26ymq+zXr7svAzX+ViS2MuJPXNn2kkiEZWfPJZ1WTkshFUVBSNNpMY0FDaZJVkiBhmuVtQ6p8GNnOXkeq7y4Qh2ewOi5My/H/7p+AjO1wIC4zInN8RWFJ3KEU30KEUZjt8CGBoD6Nan1ZAikbyXrqGqwGC5MIWJqV4oQPm2NNCQJgvFwqrgZj3U48BsNMJOgGOx6KbXN4TD/DnsnicEkq1PU6nZ0GQ9BsqjDQ8wPKGaOptQvmcTx/CVI0fk0ToJw6+dTxxs35AxL1k1EMV3sezBpazGxjoIfNE65srMD/GDJKRI5+8bGWLRLBiacvtgAH/LaPQtbBgPeXzPQXxXUCQRyJLPY/GhJ45jacfQZ2ljA5TLVotD+Cja4w3DoXr/ybuAIKP1lCkQe63KYuV0BjSmUwOnHQ8B67WhpVexyrjbhDoftiLB3i1By5HRMynnXWlA8GkxjIQqj/Mpd/vdi9l1K+UQ7nAirtVRoUGCMF6ZDtU+NfTTgyHOMCLhOIe0kJS7Hmi6ye7VeRM6pl5GnC3NnD5JM2xWWVMbDKRzhJZNbxiJxsXGQgIe3lGN
 CKtVeFYj
 A9t/XxzFBEYtfDRHMQE2OkhcZ73T56D7rSOWhP/MaBqmSJl+XkEZHMGXipfnRN3zlp/AXS2cqQ9HZwQFe9nclwG18mb/Fq4/pcnMWjotRJ+noobgMuWVrXEr8jvl5qA+GrssfTr4lRZuRapfu7qAZXWzxgGs7XWcZ5hET+W9g83kKr7WB6EFQST4bceZetwO6ORQdhjHUXc2iwYwOdWMoiPetO1qMb5J+ya0NvnXw5+UAcWRSJv+CVV57UhabmTesdWeEJQpEMhMqponiQ6GiPD5L8O8wIPgOdDZHqBG3Evt3SBHmNdCDvrON1uaD9AfBJpWMUhNqt05OrGpkFYkfUkwf08Rp7BFqW5FTRuUr5SYIp+yqSPObcZKeH0FNQ0z/IFjjTIhiC2b728faw+IKNejAfXdja9eD52kTW/6W24ZF7FGsZq3ESGOZWTxtlh8+w2bfMCu7m1N5CaM2Jks288pklrQiWFC8ndViijlXp8G3biJVT4oChOF5FsRs5e9EPLtrrUvX2FmA/BFknJUBIVl5VmIAapxBQDkfpXPrAlHzqXjIxMpGKRoNSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
isolate_migratepages_block()") converts api from page to folio. But the
low_pfn advance for hugetlb page seems wrong when low_pfn doesn't point
to head page.

Originally, if page is a hugetlb tail page, compound_nr() return 1,
which means low_pfn only advance one in next iteration. After the
change, low_pfn would advance more than the hugetlb range, since
folio_nr_pages() always return total number of the large page. This
results in skipping some range to isolate and then to migrate.

The worst case for alloc_contig is it does all the isolation and
migration, but finally find some range is still not isolated. And then
undo all the work and try a new range.

Advance low_pfn to the end of hugetlb.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in isolate_migratepages_block()")
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
---
 mm/compaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index bf021b31c7ec..1e8f8eca318c 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 				 * Hugepage was successfully isolated and placed
 				 * on the cc->migratepages list.
 				 */
-				low_pfn += folio_nr_pages(folio) - 1;
+				low_pfn += folio_nr_pages(folio) - folio_page_idx(folio, page) - 1;
 				goto isolate_success_no_list;
 			}
 
-- 
2.34.1


