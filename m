Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3759BCAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96BE58E0010; Tue, 16 Sep 2025 12:01:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942BF8E0001; Tue, 16 Sep 2025 12:01:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 858E28E0010; Tue, 16 Sep 2025 12:01:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 763FE8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:01:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 47288140244
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:01:34 +0000 (UTC)
X-FDA: 83895578508.22.8D77F40
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 541E8C0008
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:01:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bg0sbUB7;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758038492;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xvXia67Cq9g+cEA2tdQsRO5nx9SORMf8wIBhDb/3W4o=;
	b=T+CCMgeLYXXv1INzgD8k0GtXiRxfWzkBRdzK0J4DrkNzAXNld9scA146v8ZdTE+I0mqV9D
	GK3CVA0W5Nde7fmVGVvWUp2hy/YTGAQOEYTbb+liRJM/kil/jyFfsTZgdc0mxHq59Xz80k
	TbqTFGypafQCKG8JCVrAe92AKxswd6U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758038492; a=rsa-sha256;
	cv=none;
	b=4dyzaq+lSaLp9oIhsHSSjh0J6xpXQMwg72Q++fjs0r38ax5k5waZRoU8hulV42uqL5Xj3h
	ub2MXNClkdoFU1DWp7qZBxQEnQJC5Z+gItZUgY6JhrJEYBmgBuIUAh1stiHBcAyZDi4D4s
	/HZYSDUB3qFsxzU4jRegDs3BKn+0huY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bg0sbUB7;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-62a35c99b9fso1347892d50.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758038491; x=1758643291; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xvXia67Cq9g+cEA2tdQsRO5nx9SORMf8wIBhDb/3W4o=;
        b=bg0sbUB7FNuu6xfygbsP38pGUrXUtTsYgUNTkEzISwVhfIjp0POn/sx8Rs0UU5CBIc
         rmpHjBjZfyLSbWMj8SbtmlFs5AtyYSQDYWi6CQMj2mfmVOHWGpZmcxBJo+ELmTtALoe9
         Ii1BFzTLwIEZZ5PNpweBOWHWfY9r103Er9nm53ujfHjQH3qanEuF5ktEM8UcY/i4j3Q9
         SkW7jmrjLYKfJLE7uAYSq7Ci9CX8OuMasyrv7THIeeG/39NhhU4JPfbd1WAOR0iCv4aa
         Nu2pBvkCTGce4EH+zegbHrior6BlLNmVczRveCKTaHSDbWGhH9T4TWA+FL1EVeBITzAE
         x2oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758038491; x=1758643291;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xvXia67Cq9g+cEA2tdQsRO5nx9SORMf8wIBhDb/3W4o=;
        b=W5ABZcbW3af/UUMLQMt61AWSPTE6cOoH8Tj4rk7u1yQyRgp1a7noBuc7Qlw78TYPLz
         2mTabTh/oW2QiGp6/Eqqndwb9MI+FKfHNV8WDJeKz1Ul01pv068iNOwqzHDtcBc559Na
         O/whyYVTz3y5wXgWzLoYE9c6mbPjxhbdpIyjs4ld1Pee0TJlZmqB4725yhrlULj0LWbQ
         Am8RXhkG0k41r8ZHZbxBYUaJkXcUHkdX4tpCrm45scljP+uTjeClaFGgMYF5S/Pn8G3D
         GMlYBkx/09rPsRzrzhVE9lcVV5yVvcsm2aCixXIQfCF7ixjtdLB6sHstHNXYe/4jxSXy
         d1Zg==
X-Gm-Message-State: AOJu0YyVaPXhI4wLahOarrDBoN5gDaii1a5sZDKzug2KVp1cvmNVw6Zv
	5Pf6JElHsLpK2wBe5GMO5rZ1MlbmFvsjQpKmWvbbnTIEpux75cQIR3R7pKB1WN1Y0MM=
X-Gm-Gg: ASbGncunshdy41ffP17Mn9Izok8gx5rVYIoCV/gOCqcB4Or1DElkaLMwH51wW2jFT94
	NI+j5S7czHj3ej5Qt+5XgVYV4XHe5U0SiCZpTFu8e7OffuHqvpu5sHqxX+63Awx1qJ0cAhbR/qA
	JiuRFbPlwMu98gM6Qh3S8D7zVzR76XT3r83EQ/7jRtOjaDlp0w7AuRiN6PBVHrBA3ZlQsoP3hoZ
	/mNgX2mwyEvygRRiBR7bcyfsgtF+i98Tnm2tpYF13naEWvqMhFDLLFp0KaSe/GEwmF7KSxdo3oV
	0QOIlY+iPe3J746bV2OUEhjD7OMVjwAd06n/4i0wm/uF0OOMIvjaiwDrAk4lokv5nBoaeJNnZtT
	5ZBMf2TOH+FP4jIHFRrtiOM5gkRDFcOUbkHk1w3LJwimzMZE=
X-Google-Smtp-Source: AGHT+IEH+JurO6Pqf+3vm5jI9TQTunBdyoFl7E4dFaoXc2kYbDIILkBmSJJMNdbYEyyRHGeHv0wzRQ==
X-Received: by 2002:a53:864f:0:b0:600:d00d:f4eb with SMTP id 956f58d0204a3-6271c5cfcc6mr11388302d50.12.1758038490342;
        Tue, 16 Sep 2025 09:01:30 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820cd703f54sm969765485a.37.2025.09.16.09.01.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Sep 2025 09:01:29 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v4 03/15] mm, swap: fix swap cache index error when retrying reclaim
Date: Wed, 17 Sep 2025 00:00:48 +0800
Message-ID: <20250916160100.31545-4-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250916160100.31545-1-ryncsn@gmail.com>
References: <20250916160100.31545-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 541E8C0008
X-Stat-Signature: cmnn96s9i3ozs1hb1uaq9pqru5hwjjpp
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758038492-286890
X-HE-Meta: U2FsdGVkX1+W3UzAIc66rok8fX9smt87m7SddIuFT4qjhjk3Ta3byAHN4Hfd2lOU6STx+2b2tQADj/2ZmlaY1nSpeJlKRL8qNE6P7Nyl4anv6K4TxOHw0lbdhW7eFXHL/T3kk8smc1uy/gwJT1vxXNclUUegSH7ECGdmfiFgULB1qMWUHKKOH/MZ2M1MWvp2Y5ln1mBQM/cc7LAI00c4i/HvRR/LiB9xCGxaXz1/6X1MI/TtKuxXZNYa+hPvOJqrtrTQKycYu6e2f76cqFQdhAIG88IOaE8TsNn7N+OmSTnQTfcNWGydZtTOgo9y3ZYxYPB5zCIsj352WoWJxzg21Eq5MXimqYkb4syzaDiZZTk5K89XA/VddNWlgHEheEi8ZW/BPnVRgHXnQjVZTDS/wmHh0CWqWOMGDyyD7H0hry7tb9yP540V1RVHYdT1KgrlSjBahwUd+JMfcBJdgOXcioNR0Bszlo9tExkgRBMOK7+QVwiRcPS8mZ0ZEgrDhU+l7mV5C7u/zIBJ4HpVOlVilIWAnjCozv4njYSpNVVvEO1eZ7o6CVMuRYsvY1qLRArHLBr/KeYS+pF5ngG9XYOs1f4b6G6LV8m2KsoErKazNTZuAEZLpTGP8zVvUHFCeLv5TO0yjqa/MMxDt/oa7Kj4w6L0iN33ZfXblv0wkEq1f9gYMmOWXjgPW8V9PJ7b4EE42kutAk4ajb3nLVwC/TZWgefGTB6o1WB1LfuOotmBypKJTaNrfnK/SiAjTF8rtpFUs57z1I6WhAk6MpxNt5nr3u0S/gt71ArkSTv67fpihpWt+g9ezeE+v7MXL0IswOoGh4/1fwkZ0YWhmfeU57TTJNX9OjhG9Guyptq4bOaUvxmRxebSEilyQtAt5xO7t95Xg2o3UehmRz2Yw1MO3Wx3hoMI2Gjrrbwu+6A7Xu8QzuSEuJhmQSUTGTZGhXxQn7OPRsbID7av08Ap0TjaLeE
 yepeY0Ha
 ZS1HcrbcQoy/GIS+0YSl4sf9OFj2eAneDvzUsdjMeqTceHom0Lc4Rwq6njKa0Rsqc9XhWhOOm4q0dsFV/8Kg2B3ADrLLUnE+St1lJ6aIVd42bXo/95LtxKEiHVcuXfr7TueSk8TwcezZXSaYwUUA71i13GJ3kZsg/VFOHAHimBc1bEh8oobpgcodpg/KJUVyvjFUl3bBxr1ipT2P6DCGFPFVyIBpm6rOlCDD3QhxrwVLLeakYcKhEygIYODRSMowcdnT7AyA0+NbYKOTZ5mKdbO+ctv8j1uMhqcfnQyJ+ZBmBG4r+31AwAxgl+ktTCPpBTX+//s9XOG9KtfniEnkx0SkU77Z20WrqZWA4PmUM2w+DA0veQ7ozZuICJjtnUCmZXndhKtI1MxxE5s8KajH0c8McFrevzM7PvP3iLb6AzRkh9AlOTr4fbaiKJnAfoRGo4RL3UaGQ4il8ax5x9AS4PUNkjE9pQQKzMneEg64r6GnLer8KyAynrDwC3UJBY/bGsDZWa4HGiEkhmckV0fpa/xM9oOwczdkdvq9APDJCBJwrl3NsFr2wzY3EtgJElrRVr/+9gi+2OXCDhr+D2/R7i1bQj63g7Y28Izuqpru16kF2JrFBczLfhQ/T/GTiTHfVF0y/i6P4rRlmc45y/pLJfA3K3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The allocator will reclaim cached slots while scanning. Currently, it
will try again if reclaim found a folio that is already removed from
the swap cache due to a race. But the following lookup will be using the
wrong index. It won't cause any OOB issue since the swap cache index is
truncated upon lookup, but it may lead to reclaiming of an irrelevant
folio.

This should not cause a measurable issue, but we should fix it.

Fixes: fae8595505313 ("mm, swap: avoid reclaiming irrelevant swap cache")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Chris Li <chrisl@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/swapfile.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4b8ab2cb49ca..4baebd8b48f4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -212,7 +212,7 @@ static bool swap_is_last_map(struct swap_info_struct *si,
 static int __try_to_reclaim_swap(struct swap_info_struct *si,
 				 unsigned long offset, unsigned long flags)
 {
-	swp_entry_t entry = swp_entry(si->type, offset);
+	const swp_entry_t entry = swp_entry(si->type, offset);
 	struct swap_cluster_info *ci;
 	struct folio *folio;
 	int ret, nr_pages;
@@ -240,13 +240,13 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	 * Offset could point to the middle of a large folio, or folio
 	 * may no longer point to the expected offset before it's locked.
 	 */
-	entry = folio->swap;
-	if (offset < swp_offset(entry) || offset >= swp_offset(entry) + nr_pages) {
+	if (offset < swp_offset(folio->swap) ||
+	    offset >= swp_offset(folio->swap) + nr_pages) {
 		folio_unlock(folio);
 		folio_put(folio);
 		goto again;
 	}
-	offset = swp_offset(entry);
+	offset = swp_offset(folio->swap);
 
 	need_reclaim = ((flags & TTRS_ANYWAY) ||
 			((flags & TTRS_UNMAPPED) && !folio_mapped(folio)) ||
-- 
2.51.0


