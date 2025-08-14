Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4691CA0ED1
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FD9790013B; Thu, 14 Aug 2025 06:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58661900121; Thu, 14 Aug 2025 06:23:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4757990013B; Thu, 14 Aug 2025 06:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34AB6900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:23:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA4BA1405F4
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:23:51 +0000 (UTC)
X-FDA: 83774977062.12.C4D8769
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	by imf08.hostedemail.com (Postfix) with ESMTP id A33D216000F
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:23:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf08.hostedemail.com: domain of lirongqing@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755167029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=5SeDNEhbzLQZrdIJEO7M/n5pAwUnC+OYtNRDDKEKb/o=;
	b=5Sk+IGa2uJtBieZvd4amj+EpKhPkfAjntwRmlSnLReBIwzEi/c2alR9GDEwEaZkwMXmp7+
	ykZ5wUxDmiag0pLdZZvnrzkcHTOBcSItey+LdYyGZMKqtDw8THrzg/o1wO/EnfH2ybseYz
	lbUalqdNZ6UAgMJuTWWsWPtkft6SfaM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf08.hostedemail.com: domain of lirongqing@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755167029; a=rsa-sha256;
	cv=none;
	b=FD1sVORK45KiPCbIwXuFMV6ByqelkW7XQXRmDRAv5xmbx2hGdLX1lhHg+mWaw2PH84Lrk0
	gaznVviO4oIi9dqjJ1WZRIxR0fNM1m5MLULBrOmXKJzdEDmTLlRQZHUlF+6YRKGvcJArgP
	m/e0yXgivdHMtjwYgMm5Pq4lezxgVxE=
From: lirongqing <lirongqing@baidu.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@redhat.com>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH][v2] mm/hugetlb: early exit from hugetlb_pages_alloc_boot() when max_huge_pages=0
Date: Thu, 14 Aug 2025 18:23:33 +0800
Message-ID: <20250814102333.4428-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.127.73.8]
X-ClientProxiedBy: bjhj-exc2.internal.baidu.com (172.31.3.12) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Stat-Signature: t8ntno9gcx33x4nrjtydtx5ggfixajo6
X-Rspam-User: 
X-Rspamd-Queue-Id: A33D216000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1755167028-184156
X-HE-Meta: U2FsdGVkX18rdZcZ8XiktBtpkwSuIYxG4otpRMoTxvITkzSXpAE2/Czd78SmUiMq5VQmstjMWGdADXnPHCacxmXNlzS3aFRxRdDUbPYGgZQ1G+RMxcvODYnUcsAgNVKxt7PGy2ecOJi41U1G01xOtp6DZqVCT0BL34jI+8QnAQc3a/BEhJLULssjhH9cXxy2aWwNYUqV83JuU1/bxMDcCASUgTSB7MDyXPW/sk4U57CIpgurYYVZsVtwTO0Er6Nuf/DpfteDPxaGgi59IOppBdpdpwToGaVWhY/5k/5Q8SCzH9LiyxYd1YaWaBC8oTjWD6Tj7a63IfKwBIVA+RGYeYGJVbbMQ+gBCICjlb/++vyOm5ttGXDKCNnIeU7trIi03Gdkopg6BGG+FJCntpd01IJ/jdk1iHQm355fF/fMaidiNUR0TU1pfhc0j3LYqkFgn5WlUYDzi0+eiXSSimUyLlJHDSik594BMsCXcHTZknhMccTchUTgc60C3BeUHE/RW3OwRUo2AWeRokVbe8rd5TXMBeayrW091K2slOJXgh7O5IvhMhbmHIx0EfuFcDGhhwzFu/nZ+gJ6SL+74tJlcmC9Dd7qO2TxDkmns65mDajPQT+ZHeiX0b6RYc1azp38wV6trAJNAL27EtoOTU/0X0FuzHA6+EcTumYLWKYq7PM5F0GEqKcek+oF0ipRc7hVHMJcJ17zJKdXRw2reOpDp+5mPsnacMi+Qc2LdJCiyc4LhbpcHD4qZlhuiuRyQi2WgYhL0jGP7dqwrf9Q2tZZWJymSzS/YQehrRSe0sbnGMVuGzx10ziYuBIHLYAFXtRpwxDxMxHD738fcn8984IeIWhZeydvuyezXBbZ64BSCa/gPwLbxy2qCg6mDxA8D8+5qYPnUv3mHBHNZv/2z3EK0qNAGF8mpaTHB2FVDShvNqPQQKS4ilt9aDuTLJpkhoMbETJtYXfhehxBI98s4Vt
 iHGrRhEH
 7NZ7Sr362YMVpvqpCBRFX+B9hggphcLL/cIm5Ri8AXig5Ey7nmZvwhiYr06rj79P4WGxovthcnN17PkDkWnfqBvU1nyPQKc4OY19XCvoVd8R7nSSCLCU3qUk4cCntS471ghApZnApX6C/osMThFnrR78AUXXmUkrHwY2o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li RongQing <lirongqing@baidu.com>

Optimize hugetlb_pages_alloc_boot() to return immediately when
max_huge_pages is 0, avoiding unnecessary CPU cycles and the below
log message when hugepages aren't configured in the kernel command
line.
[    3.702280] HugeTLB: allocation took 0ms with hugepage_allocation_threads=32

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
diff with v1: adding the reduced log messages in commit header 

 mm/hugetlb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 753f99b..514fab5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3654,6 +3654,9 @@ static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 		return;
 	}
 
+	if (!h->max_huge_pages)
+		return;
+
 	/* do node specific alloc */
 	if (hugetlb_hstate_alloc_pages_specific_nodes(h))
 		return;
-- 
2.9.4


