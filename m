Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09792CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 05:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EB1A8E00B2; Thu, 18 Sep 2025 01:04:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C2E78E0093; Thu, 18 Sep 2025 01:04:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1F68E00B2; Thu, 18 Sep 2025 01:04:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3863E8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:04:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C62C8C0748
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:04:52 +0000 (UTC)
X-FDA: 83901181224.11.CEB8A31
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id E2E30C0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:04:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758171891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=haDiPSY51WpyxaPZb1knOMrIoT8o6NHcAH5Q6EVWoj0=;
	b=bxD80zHUuxpnTIi/n75Nz2BAYk6RCEDtKO84yW+Ug67LrOZb6WZ7Zp0oyh8xFNmS2MrvHd
	IFDVwLrjfw/KW58y5BklEx5/0A733srgtMqt2w19sCJJWTu+WF26Ui2OaWxdhNk+a7tcNW
	oxrZQA1FyhzDomhQmHmF2rmKqJOMp78=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758171891; a=rsa-sha256;
	cv=none;
	b=0XY78qBmAbpwMMxKUGdLGzL+m8eln6lFubbZSmJ4SwGOVJ8HKmfbKKjQMDZIWR4VmQZ9wT
	mLZmfN+Kq3M50pvDzTA5DeW9ylzPXpYrP5hw7UkaF8+ogo7GxyXEEK+AQ/QJ3Y4lXdLWpN
	d5j3SLhU9mEKlSOq+LRAmPwyjl6WY70=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3e8ef75b146so344528f8f.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:04:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758171889; x=1758776689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=haDiPSY51WpyxaPZb1knOMrIoT8o6NHcAH5Q6EVWoj0=;
        b=ISIr8DGMZN/CgD4T1FtMPeCpwJ56VezfCUBz7MCcfVZbrCMxnCE/5zrf9bpgcpIbyY
         tMe4FOT+iYHjrgC5G5YLh/jH6be/bmcUxoHWgQGFj6O3o1HW6GLc300YV6A6SuBEndIq
         yTyKtFmjiZ77heUdGJhPeR6jHD8IBoIfN+/o+v4RicXcuVy4NGmilR27KcsEtqsHPTF8
         g7DNvT00nNkMnTp9rK1fAQuATwR4jMN3X+4W9ORfjVnyyQl/Bl60qA05KJ2nfNfWVY6U
         ggIfbTb88M4V5liI+B8jIckH4RU32X+oA1iMlc5VfHTH0w8u3OoOCTenc+SbXZRMG2xz
         PS/w==
X-Forwarded-Encrypted: i=1; AJvYcCUQJroaIj6t7l4ZZN9B2tHjrporJCb6Ecl91jgvp8HhMfSHokk0r8ddcKYof/aHKps2+HIQyY3z1A==@kvack.org
X-Gm-Message-State: AOJu0Yxc7XpGqtBUUNO91StoRG9FdKoZglDsQgdYmP6nuIxLs142EiB/
	yfNd7OAiOYQtPs9G7oC1XVGbN+HO9Ub0N8Ymmw4FDFbLU5OVgOMJFcZZ
X-Gm-Gg: ASbGncsrLRT9mIcS8Gj23a8MvkHoN/DQHKExwi8/Bb+11Nuw2l0eQfDhbhFVim8GyDo
	PhXHEoO2TF02LvEI94plowhIdiO09oEEfI3XALccX4EOo63ls+8J6GsIKovlzzoAQY5ZyRMPF5P
	Tv11TJfYFm7rCdKRxIHgzRL5gC7FhLu4RJ+PEoeKxzYNU+vuq/nDSqutbMiC8jkrOZxfCp47Aw1
	WmgUA9En9a/GVB9PE4Q84wGD4PBxRW639fyXhVmtjtGetMteBAPfzB03MJhR41Q/uwS0FG/iay2
	5hm2/kLAZNMeu53UBlionxsNa9D563PG0f7lbrniMRCv6UVMgCm3oFMGDKZQjU5cLMf17JDVJVG
	ShJ3Il3YCeF7IZdVLO3Cf4JqPve8=
X-Google-Smtp-Source: AGHT+IGKPgASo0zj6nOd7C1PVcpDYMiRoBAUkpl4xN92bmh7D2grzC8f307rD3nF/krqA7stBkuhXw==
X-Received: by 2002:a05:6000:200c:b0:3ec:d789:b35e with SMTP id ffacd0b85a97d-3ecdf9f3e2bmr2809812f8f.8.1758171889281;
        Wed, 17 Sep 2025 22:04:49 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a09:0:1:2::3086])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee07407aebsm1994409f8f.14.2025.09.17.22.04.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 17 Sep 2025 22:04:49 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	kirill@shutemov.name,
	hughd@google.com,
	mpenttil@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-new v2 2/2] mm/khugepaged: abort collapse scan on guard PTEs
Date: Thu, 18 Sep 2025 13:04:31 +0800
Message-ID: <20250918050431.36855-3-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250918050431.36855-1-lance.yang@linux.dev>
References: <20250918050431.36855-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E2E30C0008
X-Stat-Signature: 68kz15pbadfknuowwws13hbnaxw6djyf
X-Rspam-User: 
X-HE-Tag: 1758171890-9602
X-HE-Meta: U2FsdGVkX19DxFZrte1EHgxSt6nuZEahEAzXE6SX1Wprd0Y/9hwrglFTVBoKkSdBo/ji37ngAbOiJXAYFMuTfp6L6QEnTZEbgEK5+KPoYZtqqwT1na36+VwCqOB/Qn2wGHs5XoOonsG6PZ5m3AaljjueP2iZTKezmSMZuXwKHLITCr83fnnRMJTpf6OuHLJWl8Lh5Dzk29g3EGuBhAVRj599CEBHDZT8jwH9mHORb3YPe3IPu75IHxbfIK6drvZyq2ovS2dcfVguWiQLqSivlQdcgVbtwQgYnFkoYAeruZ3CXsOo+IfeSy8jaWK1gNplqT1PB+AV+48C0NdAnA1RGPEMc+K2c07+z25GcHKe8EFGLh+pQrgAVamGbW/QGHIgTuTToiGbRncT8FxgOp31A+sOQqy03jD50ixSnrSvn/OL+SWQ72A5mhLkT4FBJbLkg3oUV2MjuNwH+DyooB5wj1QoLnoAxCBt/wuP3g4twqrZuVvbzpFeLsz8y/N5jusi+i0QTIijwoWeAhqJt/avJZL6kH75v75XpZ8zn2EOul/7H63bIHot441ZisVv9/105Fc1ZIeQmY+r0xGHJuyifRIay9fZuAB9DQcIa4fyDLftpuSt46cCHcGdPTJ34B7kzNRRMVZtfaxCQZhqfk/8l4Nszs2sca4n+WRgS89q9MvGaKPj74biVxrdgVShFuJa2eNMTiqfE7J5sBKRU0q5GFLBin3zlppIb/JsY8n84RDPP7HO8U7dipjLLHHxInv6FtyT1xssuQw1VveaLPQ54/+GBzauGl+FCb0NH+muZ8DVGsSwovDNmq7P1McEF3OFeGu8th0UzJA4Pl5/G+vUA0JQdofFpxo/mC9gVbC0ZCee2YZNvtK2TURsEMoDKxC7j0GNC3Q+JrqwqolpdjiEK/CcdKx8DP3VzkFzZI1rMETn0h9KyRoIx24RflTIs5h/VPdUuQvqlXV6EZHv2YP
 QxM2RUXX
 rRJ58wx1WJbZn56hut7QA8mxpmsrNBazZd8QofZ8MzuTKyBuF6H6N8yBokTRRIbDDlhTPOl2T17afmVwXOePgesUqFvTCAuBAlqn2mAckHUVlukYzYgwi6NPtO0JefA7cH6kbQ6G5JFyvhki6plbcjx3bESStAOlj28a+yO/Bb0rYAqdpb18xIFlhehrHzOw8FJY55z9ct8TJlmbWYCv92nbhSmZ0LiLQlsAH7O4bUmWHChS6/zHfO8wlZTXkHpjy/BB9CyR2CIa0l6851jNG8GDWt1xnaoxdyCUh4F27SzRnNAKH+skgF/auhSz6XqiNYxkU647BJv1FCDp6j/VXgueTYCSt+hhm3BBjKZOoCjRKJTEEe2fUGvnk4JE36AJA9NsWopzeW+AseEVVE/8ajsVGZ3xDYy1e3WKTc9GtFrpUj5EjD19fH0w3s6VE91QFhoR9rNBRQn3hnPRpYS2K8ij2cPcs6x8dlWmn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Guard PTE markers are installed via MADV_GUARD_INSTALL to create
lightweight guard regions.

Currently, any collapse path (khugepaged or MADV_COLLAPSE) will fail when
encountering such a range.

MADV_COLLAPSE fails deep inside the collapse logic when trying to swap-in
the special marker in __collapse_huge_page_swapin().

hpage_collapse_scan_pmd()
 `- collapse_huge_page()
     `- __collapse_huge_page_swapin() -> fails!

khugepaged's behavior is slightly different due to its max_ptes_swap limit
(default 64). It won't fail as deep, but it will still needlessly scan up
to 64 swap entries before bailing out.

IMHO, we can and should detect this much earlier.

This patch adds a check directly inside the PTE scan loop. If a guard
marker is found, the scan is aborted immediately with SCAN_PTE_NON_PRESENT,
avoiding wasted work.

Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/khugepaged.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9ed1af2b5c38..70ebfc7c1f3e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1306,6 +1306,16 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 					result = SCAN_PTE_UFFD_WP;
 					goto out_unmap;
 				}
+				/*
+				 * Guard PTE markers are installed by
+				 * MADV_GUARD_INSTALL. Any collapse path must
+				 * not touch them, so abort the scan immediately
+				 * if one is found.
+				 */
+				if (is_guard_pte_marker(pteval)) {
+					result = SCAN_PTE_NON_PRESENT;
+					goto out_unmap;
+				}
 				continue;
 			} else {
 				result = SCAN_EXCEED_SWAP_PTE;
-- 
2.49.0


