Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA7A3CAC598
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 19:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70A5D8E001A; Mon, 15 Sep 2025 15:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BFF98E0010; Mon, 15 Sep 2025 15:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5826E8E001A; Mon, 15 Sep 2025 15:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4176B8E0010
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:52:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EBF6D140764
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:36 +0000 (UTC)
X-FDA: 83892531912.26.CC2C2AC
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1D832A0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="dP/fcaL8";
	spf=pass (imf25.hostedemail.com: domain of 3gW7IaAQKCMwxDv3y66y3w.u64305CF-442Dsu2.69y@flex--fvdl.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3gW7IaAQKCMwxDv3y66y3w.u64305CF-442Dsu2.69y@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757965955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2MjOcVaMGZCYXnwmJQZ57Yx+f6ZupaH/8SoD2+GME4k=;
	b=oxEZFTJA+bK8KWXHg2wEBmvJooLt8sePGk8kMS5dI7MvE4tyoGP5rWtoyeTipVm4An64HA
	8NiYUnCBftLRQg5BnbHxAXHcu4q41vLI2A80TQIObGCcRgIMVyapTa8iETAKQAr1YANIn5
	2+qHHcD6++/5KdhAgDZD5lprToc/r6E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="dP/fcaL8";
	spf=pass (imf25.hostedemail.com: domain of 3gW7IaAQKCMwxDv3y66y3w.u64305CF-442Dsu2.69y@flex--fvdl.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3gW7IaAQKCMwxDv3y66y3w.u64305CF-442Dsu2.69y@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757965955; a=rsa-sha256;
	cv=none;
	b=b/EW6J1vKaDA+H5Lqot1n+mHggFi7fcylmf/aIbs8bego7TpWmdH9sEvG+6u+1nX/iCiFW
	BJUqBVxXtrHGGOSYN7QN9Tjr2UuhsLobn44QMsndbbkqJ6/9Stwp35qivPZxKRBytjUrQW
	zv+TtzaCXtJgv1oTkpKMlZqlOsDsMS0=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b4e796ad413so6109599a12.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757965954; x=1758570754; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2MjOcVaMGZCYXnwmJQZ57Yx+f6ZupaH/8SoD2+GME4k=;
        b=dP/fcaL80d9kKvTe59E/+nDoZQK0hl3OFWE+47lzEy1Fb21XUMz4FcUUIL0jlZwyBD
         s/MOWX7tgwma/AxIo8W37UDO+mnQnt2ukJi+n1YwuChnM/Le7uWMdsJQkEPCXqD2PI4y
         Om89TvHhuKyb/y3kFr66YIxOw04K7Y3Y1OEn/aqey/7Mot84U9g65LTlSR7GbxUgHVPl
         fUaBcpoX4l6bKg1elfkqIGlOmHcZigesPgmpOZV2rnaVIlUNx8UTfI28OyFD45gdwW0l
         IjojSWtqvt8ZxHmbmyNFA2fkmbvh/39aB3TVr0q5MkzDOHgzAHXehiyBc8x7/bioNCa3
         emxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757965954; x=1758570754;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2MjOcVaMGZCYXnwmJQZ57Yx+f6ZupaH/8SoD2+GME4k=;
        b=plGRdy+PhXpjMzDHNM07qpc2KtEv9VW5rJLfFEj4QM3pvgzFl/aLtMS2Yx5zopy62f
         hTccCAN3AUohm+u1NdBLQ/g51+D1QvpmMV4ZuYw5IPsxx7zGrNJRukpZ2nCoLKDdkK+y
         x1+DTLawr8lQjMZ++TcyWL2FFAU6K3R39cUU+vTq1AyZXSWKZ+MVyW+4kNRPSt4duGAo
         XZs4rvcxOtoMSpHjocTNWp5xOEDYfSQrz2VQeG1NQ+ntHPqiQAZKYF8no3MDfWDIAwC1
         uMcAdWf0BGnJLzvnwd7NTWXeHxyCXX9ctg32MvFbTAlS8UU6aookrIdDdZ0Zpi4xT6K2
         isSQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8KAB/BgwxxmUJSJiZvpBR3TrQIEiwQ+hbA3DUDJZ48IPRKKUj91BTFFJn0AMsY1fi7i1GZyWbDw==@kvack.org
X-Gm-Message-State: AOJu0YyIJ5E6LUFFgZv0xpBUAep2GdXil2Yh0/ylBdHXb3ak4J2polwO
	0eOhBL4R6+W8fOZ2SfQAJOAMmAYzt++vG4cM2nXJJaD3WWMwALSlSQndOMjtg21Xa9fEeG7ipw=
	=
X-Google-Smtp-Source: AGHT+IG992kJ91SBgyRztXEp8ayRWD1xxYpYbjOHc4swJ2FjbvDWoErXzOXlzWzoeDsx/LEygczXUUjX
X-Received: from pjbqd5.prod.google.com ([2002:a17:90b:3cc5:b0:32e:6866:664])
 (user=fvdl job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f86:b0:32e:18b2:5a45
 with SMTP id 98e67ed59e1d1-32e18b25f33mr9160181a91.5.1757965953984; Mon, 15
 Sep 2025 12:52:33 -0700 (PDT)
Date: Mon, 15 Sep 2025 19:51:51 +0000
In-Reply-To: <20250915195153.462039-1-fvdl@google.com>
Mime-Version: 1.0
References: <20250915195153.462039-1-fvdl@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915195153.462039-11-fvdl@google.com>
Subject: [RFC PATCH 10/12] mm/hugetlb: do explicit CMA balancing
From: Frank van der Linden <fvdl@google.com>
To: akpm@linux-foundation.org, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev, 
	Frank van der Linden <fvdl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 1D832A0008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 1oj11idbbba8nxgomjxgdfkoyiktopwc
X-HE-Tag: 1757965954-211785
X-HE-Meta: U2FsdGVkX19Pvy7jf41C1IBqNsJ2ZZMqhjyrvN4HrNn7fPorHDmcl5v/2OZUC/Va32l1bYKXLwt45DTEGxKVSaDSH0NFg2ozviBtFp1VvpZFs0nKR+kWl9rJoRc8MKNIidBXEEuPc0LRdfgwhMxzxYn0I04pKnhVi7PvsfWx4Cv/R6qhebc1DmKuvk/E21LYSA7UK1FaGpCidftCEOmAiwfr72J0EBXz1VqJoqGgS0wJ2u0jEwK/X9kT2apesZs/HVKfugrKYHdFbqKxSe73g9JkQqmagayKBNC2rMBuDUMwnAmxB5GExitxFiITA2Xg3M21jD53L70Q0QtAfyXrAdlzyduBlhRtdsHMeM+9unD7tTg2MYJ2TKnCCTG9RjetgVXPz8Pd6/pO1fmhSasj/bq0xwICMk/klxpOfOGAN1eARNsGaxIEXNJlvsD+UsNHmvJUbevFXx0pCu7vF/J57SH0i5pRSY44lV2ebyHrHK0D+KsYAhc8vS2us9bj1gsXP9ZBHm6p4gLwLqEMYTab2COtp15RWlSrU7V8GLgu6PKAWfikgTvth0nLQlZGuobOU9dUc0sMucqPJXG7y/Fp6PwKW/FNBGy/y/wWkS4ATBWl7/iTPWzeUO3mw58Tljo4Nk/PK2TvGuvKb/zbb/x7cIFGu7r4Jk6TwCiHzknaS5vzPXdkQNaFflVNhVVLYu3D7yRkZw6C3DMtc8kpzv6D8tKAbffEGBSpf6fbqIC1xRsbqj1TpdooXK+/9elXQtlfISG7q1RJk0Vjg6VA4/K7rapyxGrdzoNDfpFnmVC6LFthj8Czw9OzJLNRgZeAzSR0TJC/wyo+uvZjXgI3XAe6heLDWxpBYaCjwYAKQPZGXTgLl95VH1dLAZ0QfLMIpvYcrcizh22LJSkAGMqmHQz/+z8Y3XPodU60DdpFPrQHSBfWjMI8HpRoI6FZNJqdgt/v4BQkh1hmPKnGjugInZ/
 tUQdtaGK
 i4lDCR/iCItGON9oMQwpaMdlptq2gCky4fKJc/TaFK6LzZ1tJeaIcVfFXoXOFHI9KbeIZgkqUcB8/KwZeUZXRQeuUXrV4+y27RSlCZLeDHM0W3Q0vqO1eclaSzrtPX/mrjUL+Tvro3m5r4lQHlbOWpzH/15sNuU/6va9iSjja9FgPuIlyCtqoWTq3HE6MxX/wUnPCrBqWWZxBXtNAoCoSbB+aZSos4ZPkctYwP2dUNbtKA8bnr4modLe3Dj7hUtAHH99PJVDOaey3ZGN0uI6TDQuR7fN+5N5YO4bvF1Q7w7+Zy5zVEsXoJsfQF02zROFgWM78bnmqLuRzFjSUjKMk4auFOSGOsCjzLLCFoPOfFy8ZNyg9ncGh0reiC7AFcjzMPkmSURN5E9lhfzIRv/jAAUAEHrcFPhb6ooRmAvFE/67TaSGIfYJfbL3n7TBwZBKxX0Y+6gi1ZHaioJ0AfWuVBrw2/PrmDecvpQX7jxF9RUcdV//D0Tn89roIUB5I8QLbp244LzrHGcDYpIYJ6odo9D05P9TcSd7TGk8deSfVITD1x00vrw2xwFjY/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CMA areas are normally not very large, but HugeTLB CMA is an
exception. hugetlb_cma, used for 'gigantic' pages (usually
1G), can take up many gigabytes of memory.

As such, it is potentially the largest source of 'false OOM'
conditions, situations where the kernel runs out of space
for unmovable allocations, because it can't allocate from
CMA pageblocks, and non-CMA memory has been tied up by
other movable allocations.

The normal use case of hugetlb_cma is a system where 1G
hugetlb pages are sometimes, but not always, needed, so
they need to be created and freed dynamically. As such,
the best time to address CMA memory imbalances is when CMA
hugetlb pages are freed, making multiples of 1G available
as buddy managed CMA pageblocks. That is a good time to
check if movable allocations fron non-CMA pageblocks should
be moved to CMA pageblocks to give the kernel more breathing
space.

Do this by calling balance_node_cma on either the hugetlb
CMA area for the node that just had its number of hugetlb
pages reduced, or for all hugetlb CMA areas if the reduction
was not node-specific.

To have the CMA balancing code act on the hugetlb CMA areas,
set the CMA_BALANCE flag when creating them.

Signed-off-by: Frank van der Linden <fvdl@google.com>
---
 mm/hugetlb.c     | 14 ++++++++------
 mm/hugetlb_cma.c | 16 ++++++++++++++++
 mm/hugetlb_cma.h |  5 +++++
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index eed59cfb5d21..611655876f60 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3971,12 +3971,14 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
 
 		list_add(&folio->lru, &page_list);
 	}
-	/* free the pages after dropping lock */
-	spin_unlock_irq(&hugetlb_lock);
-	update_and_free_pages_bulk(h, &page_list);
-	flush_free_hpage_work(h);
-	spin_lock_irq(&hugetlb_lock);
-
+	if (!list_empty(&page_list)) {
+		/* free the pages after dropping lock */
+		spin_unlock_irq(&hugetlb_lock);
+		update_and_free_pages_bulk(h, &page_list);
+		flush_free_hpage_work(h);
+		hugetlb_cma_balance(nid);
+		spin_lock_irq(&hugetlb_lock);
+	}
 	while (count < persistent_huge_pages(h)) {
 		if (!adjust_pool_surplus(h, nodes_allowed, 1))
 			break;
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 71d0e9a048d4..c0396d35b5bf 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -276,3 +276,19 @@ bool __init hugetlb_early_cma(struct hstate *h)
 
 	return hstate_is_gigantic(h) && hugetlb_cma_only;
 }
+
+void hugetlb_cma_balance(int nid)
+{
+	int node;
+
+	if (nid != NUMA_NO_NODE) {
+		if (hugetlb_cma[nid])
+			balance_node_cma(nid, hugetlb_cma[nid]);
+	} else {
+		for_each_online_node(node) {
+			if (hugetlb_cma[node])
+				balance_node_cma(node,
+						 hugetlb_cma[node]);
+		}
+	}
+}
diff --git a/mm/hugetlb_cma.h b/mm/hugetlb_cma.h
index f7d7fb9880a2..2f2a35b56d8a 100644
--- a/mm/hugetlb_cma.h
+++ b/mm/hugetlb_cma.h
@@ -13,6 +13,7 @@ bool hugetlb_cma_exclusive_alloc(void);
 unsigned long hugetlb_cma_total_size(void);
 void hugetlb_cma_validate_params(void);
 bool hugetlb_early_cma(struct hstate *h);
+void hugetlb_cma_balance(int nid);
 #else
 static inline void hugetlb_cma_free_folio(struct folio *folio)
 {
@@ -53,5 +54,9 @@ static inline bool hugetlb_early_cma(struct hstate *h)
 {
 	return false;
 }
+
+static inline void hugetlb_cma_balance(int nid)
+{
+}
 #endif
 #endif
-- 
2.51.0.384.g4c02a37b29-goog


