Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E960DFED9EA
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D9E46B0005; Tue, 17 Mar 2026 12:10:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18AD46B0088; Tue, 17 Mar 2026 12:10:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07A046B008A; Tue, 17 Mar 2026 12:10:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E8D1C6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:10:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 622C91C361
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:10:58 +0000 (UTC)
X-FDA: 84556043796.16.1A0EC12
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id 725E3140009
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:10:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ETKtABop
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773763856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXIH1tXdZIJ5fkYaX4jFP9QBJPuyNx5b18M8eLitWko=;
	b=zOULZjWt19Yax2bwjkFsu79iHojr/loEajmw4RSgeylk4d5D3pI1tWIZpaRNoV/69cLcuz
	2ETelgpQhUSF7+FHLhkl0SmJtxo2WzlD6h9pHn6FxNrBtKmP6hduTAIbYHZlt98Ju3Hf0X
	YZg/ZYetIIlqjK+IKdZW7nGBzI5QhCM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773763856; a=rsa-sha256;
	cv=none;
	b=rHNhdeubrKRuY+K6QDH2K8quAslVt84E0hy62uXtmAkEqWMvFWNtj3Ww7mDgl3Bmt9sTAP
	QFqF/5ZzrMIIaQNspvPZ21b0ZTdh4f1JUh/bSK5kE9qAFE0T5gtD1toha/JDlXzpEpA6pW
	eQK4g6ANqS+qCo9h+ep3ne3QqIa17Mo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ETKtABop;
	dmarc=none;
	spf=none (imf23.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=iXIH1tXdZIJ5fkYaX4jFP9QBJPuyNx5b18M8eLitWko=; b=ETKtABop8RMB1N1hwh9qdAsbfQ
	muP3R5voa2dogweh/AO6SVg93WDAQDr6d79b5H/PerHFv0YstYa4X1z9b/Tymv5Dx19Rou5a+Gtpu
	HPESMY/67fZYvlvgDjc9aW2TIKE+BhfERySa+V/WEwA4KnJ8G1CUZQXL6dzM7ssngsh5e4aoOKX5R
	97ivItPtiPAikXLh50PTY2BdRhrW/5uLEI8SOqpO5OycL2+zMeboou6gkid3cJl2aJqp7i971BlGH
	IRS3n3M3EWkJOh+8QA0UD+aGsVD5nQ1uvaLxp0J/kV//tz8JIUsAK2zKy6ZqjGGXP/Dm1WAsatJtG
	Ut06+pDQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w2X05-0030Cj-M7; Tue, 17 Mar 2026 16:10:32 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 17 Mar 2026 08:33:56 -0700
Subject: [PATCH v7 1/4] mm: khugepaged: export
 set_recommended_min_free_kbytes()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-thp_logs-v7-1-31eb98fa5a8b@debian.org>
References: <20260317-thp_logs-v7-0-31eb98fa5a8b@debian.org>
In-Reply-To: <20260317-thp_logs-v7-0-31eb98fa5a8b@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1398; i=leitao@debian.org;
 h=from:subject:message-id; bh=lZahW99RTlxb5nSjc6Dzfk6SVjr8wXe8geyfqZrys/g=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpuXzqij5aGVzOFfRM+umycL/9gIY0a7yS9b4bl
 68lokWPD6GJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabl86gAKCRA1o5Of/Hh3
 bbIsD/4m/znNJe40MQE5ofwG6vFNP3YWTVf/fm49nE+Q9zY6ku9griom1UxaprpDVRjKv949eF9
 6l9Hw9IXB6ATAXX+LNcn8u5dlAYH+2Nj0KCb0xokAz6itx5ryfuRlCrGZCvLPJgRQpx7Fz9PTKQ
 4B77AQ6bIAp3m/Wyq22IkPXBmwKtsq0YxCOtm3lEvN4GJrr+1Ey0j0Z0dkutk6HuWgO+dawk5J3
 Ovyn7PAPHj62pG6TfvlT//tIeiyl6b6EIiy6ithYqdRZhNlIjUTBijbsZzhoGPaH21mv6tPvvJa
 wEcDmaro/jDdDOnGZBDZsiBrDRxNLzWfCioymLq48KdU8r2eLZ3psELlJZeWTUu2Xc+hndl3XXG
 8mpt73PiDlIeDyxQIa0i1GaN1+/vaPqmqxZSv7uf/SdEniTDF4ODuc8or8RKYdIltEi3al3uzM5
 l5+MdxWRqy9ktECgUdW65J1FhwZ2zrUwGUqMrj7Uw5hrg9rRZBeKO9L4u7na0Is5op2Wdai4GZC
 4ityfFPvziO1KCtvDrp3frSQ8vcYAaafCS5470PhxnVxFxlJIagma56Xe/Nror/7ylzJga7Wfzy
 iD/tUZ0IzW0y2EiMELepylKwjVsCe2W8daNE3zkltIZTSjGyxC1yApaIjE6q9pq5AwG4J/R/5BB
 Ivwct7PqCI0G41g==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 725E3140009
X-Stat-Signature: 56m4r4ibkw5ywauutxqru6rcdqjspmcc
X-Rspam-User: 
X-HE-Tag: 1773763856-70790
X-HE-Meta: U2FsdGVkX1/EegdHAGPTEJ0uyQwcYNdXGJEwEoBc9KdurOMZbUNYGEzKqv+TB5eu68yR0PPQhicq268cm52kUB/V7EwlVdjNWn5qrjpSrxKa7NpjQ8DEHGwQCp4nQMN+1qFXyvzeHNZhKVbhleJ2PA+H5zo/8Uc8RPTCusUhb+Fw6MfMka5jSDuHZjxFBntiXDPuZkvFEjZT2cRZzNPz7U0VeDmIqduj+YV6RVU+xZe+nfZ3aXamNX0crOHubQBP/G9Ifb79EetjnCmfIf9w6tDc/UUnBCZpDbZAe130MmJ7rbrpbwRTYSncB5TthkG2zMpVjKvXOG/VLEVs0zC5uNHh4tob86v1tuXMjZuQUZDVzE8zfO+/tAJlTZWGjpqDt2n0JqvTpvoJX48f2VbOtiIbp7D7UjscYxGsFPJBBKCVM8qeczhaSPs5pypV0hiHxnkJfqGNjP9+xJMELt06w1HqCB58Mq5t/HTVTWV0BhfPchokb4ep2XipHkUHVvQtUJFVVESA7nNpbvMXLEsQGYShJxr5Uq3vrwcw1wygjLfHg/USZeo439l5ukR5fQB6YnVlu47mwBfvz2D/gPHaqWd4eTN/9B5GKsEczmj18Yla9NVwdqXH+bSfDrSFxkSD4SYA1+d1ejSf7tdrJ1CS5e8kT6u3nnYXcJeRDdtgyCqqo8aszOzPbCR1Y5SO5NDeMbyExoXWtr5Pje2VuulcsQ58/zzil5IFCcoPMt+Lh7HVQYUVxtcpuLZfyYkGgcOfAgTGu9vvzlQKDQul1x3XTBFjkVE0J5LeBZJ2grqwraUa0S3musSafebEdCrJw9Yogy+HmMf86PUlt2//p1VH9Uu5TU2mYlcJ2kJGV+r4k50Wd3d9qwh1mtk4sYWawvwkvtJS6kL1gbPhDYrNhCRoCHLm4DBcobdI3TDnH/ewKBk1HrKtSjarwxldTI6567WTneGGmUl6c1Kqw9syEg/
 BrSNnNVC
 yu2EQZMPfXQjbmZdX9YqnKLqAUHFquGHst7TgikFmZOQSzZ0SUN4hE/ouEIX40FrTNy8n/reIgJL8ilHVUPRUaDQZZhlmNaUKc1ACCUShZjNlKrAY4Xghp2NMMKd+xINIOdql6eiobUdbpEzlVzTrXN83rMfPS6Ijij5KBSK9NkM+0BpUvS0H/m3RBab2mLKMdnnbPiFjusru9s/CprAKikxZ8qT8UfeS9W3eU+y2KOU8BblV57Sz9mvJ+fI6JGE2HHFz/xLXe66PL19oANbc3+R/OWKnq2Gd7rnW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make set_recommended_min_free_kbytes() callable from outside
khugepaged.c by removing the static qualifier and adding a
declaration in mm/internal.h.

This allows callers that change THP settings to recalculate
watermarks without going through start_stop_khugepaged().

Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/internal.h   | 5 +++++
 mm/khugepaged.c | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d99..7bd768e367793 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -623,6 +623,11 @@ int user_proactive_reclaim(char *buf,
  */
 pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
 
+/*
+ * in mm/khugepaged.c
+ */
+void set_recommended_min_free_kbytes(void);
+
 /*
  * in mm/page_alloc.c
  */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1dd3cfca610db..56a41c21b44c9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2630,7 +2630,7 @@ static int khugepaged(void *none)
 	return 0;
 }
 
-static void set_recommended_min_free_kbytes(void)
+void set_recommended_min_free_kbytes(void)
 {
 	struct zone *zone;
 	int nr_zones = 0;

-- 
2.52.0


