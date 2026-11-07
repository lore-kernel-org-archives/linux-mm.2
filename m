Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56B16606A330
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Bsx36rBC
Received: by kanga.kvack.org (Postfix)
	id 5353C6B05BF; Fri,  6 Nov 2026 21:30:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50D096B05C0; Fri,  6 Nov 2026 21:30:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423276B05C1; Fri,  6 Nov 2026 21:30:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF4FD6B05BF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:30:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7888C120290
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:30:05 +0000 (UTC)
X-FDA: 85406743170.18.E9EE44D
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id 969DB100007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:30:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Bsx36rBC;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794018603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cNsmR0WvDvGFxNjwREIYmv5MbBRrNrv89Il3eE4jcuk=;
	b=4mCQDu0heE2bJRbPJawFgYVFotE6blTgWZqKfgrCw62y+YozKNxSapIu4KADq/fKiJbENo
	SB1bltCjliLqHPqSA2kYFz9vQyPvS4XNOb3migJl/9AQl1z1pd26M1cbit2TZQAd+7XNOR
	u9n+YFZdgikkeqVrQ3ySeU6cxmBHUy4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794018603;
	b=PIt5vYUckYjdpnZC2dYrvZmQ/u/HclwJcGXOxl7qXvrGJ4w65cjpxrhiMB2fq5vMTqeXl3
	lo4hmAOCXYDsppS2CzhtYjtNeUBWRKgupm7+lJUmn7K2ZmeHYBToKweeRoEf7tkfELbHkF
	fAWjHfL7QRLKVRUVIm1rlevEZy0uoE0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Bsx36rBC;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-37000e7234bso1627988eec.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794018602; x=1794623402; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cNsmR0WvDvGFxNjwREIYmv5MbBRrNrv89Il3eE4jcuk=;
        b=Bsx36rBCPEbJ+j2rFwkO8kFti5F/tlbhoEoQ0F++lohLNnfBokA8a0JL7LnzAxe+ZU
         tWqTOR3ny1Duq1MiXWy4excb/dxg0vXmr41GXfl6WT9L3nwu3e49sq0zWU/fx4C1i09v
         sQ/SGa45to/cYhiSEB8TXyBes6AKi6qnEzzM1svXtEB7Qye1JVY8hZdSrlV07CrYUUpN
         lGZFMx6aS4aLnd/yQg8T7LDRpQX9bbshGLSRRlsAQVNFHOYaKR9HbLrQMi8M+jNGhjDy
         7ghoWrTMhZxEomLbzzLOQFvkTa5v04OZL0QEk/qO96ws2WIN7dxQbYSSvedMNmtxi5yX
         h9Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794018602; x=1794623402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cNsmR0WvDvGFxNjwREIYmv5MbBRrNrv89Il3eE4jcuk=;
        b=HYoal03aTf0RC1NJb5WXPcU5hOcGnyN0aO6WIOIA14fRxE98Hjtv9vnHQCkUUuGK74
         M3DM3+SLJk6ub8Eam+aLVIG+4XljvjuUFlePxtwUxy6pwo28ymQUIGvjLkhH1HS0ctyN
         Kiwmc0Vl/LZUE08kMC7JsoCRA33xi6Hww7pL/JqrZhB+KZYl6QHAqbbR/IYIHjt/GPr9
         ixHbojpPjOxcPc7BCBq5cHTX6fjq6w8rv6yxPXsYdFQkjGs43ecGqSINGa3qpz5exbce
         gqL5467PSCcPfYb92EpupCA/UTUQeeLoLkTzXyNyR/I5SLMne35RANNYnzJtzvjpx5Id
         v7aA==
X-Forwarded-Encrypted: i=1; AL+hErHZVxjoINMFuohxARMyGH4nnQBqhNmFtjjmYjDN/gKqhy2mOvumR/ucfmm+gJZHuMmLWTI4x+XpYw==@kvack.org
X-Gm-Message-State: APuU4Z+cOuiY0zSMPAYZTFhzRCoIh0EpgIWpKlHYtqANvGLHxk95jBj2
	2lMDPywkwIe60H8J6brVrYwZXeZeHDTXli7Uz7X7cI1e5m8kwCNP3HSz7IsmjD7p4js=
X-Gm-Gg: AYBFou07icNJ48OpNffiHCU9abq/UFnIvcOSjhrsC5fsBL79h6qJJB/e3KlUhu46zvG
	MrcCWOXk3nxoTVQeEv0f+QfJDEuuC3fbtYP/Tg6xUXflRA7Q8FG9a5xJfbOCTYI1DwQfVZty5Xs
	RZYGmrKsWG1QwUXhzUyLRQINs3ls2xAigfNBrucrB346GlGaHUM0RIQo0t9urM9YMyMT8GJ/Cno
	kPhy+CwOCAxylFDKL7Ssp2fzj6b8PO5I7eyEYRK8jdjB+tkvIJcOmBanl+hZ5+M8z5o77U/KDiY
	4dhQZ64nxMRO9VEuWB8RjS5e6+uhc/E/Fnje+2jPCfF/L0HEFZxyKune3kkBi9GkjzdGSOqA+yP
	pRdwXrBuT9+2zwP6YHi8C0qeFMAYCl8q8sopmkoGLpZgDTuVpykLj2LNzeRjfj4MAfugi3i3m0l
	SlaL7svZdAEqa3Xx/Wk3V+V77iy9SgXvmIXSA0s3VJ/K37BI08PqhWy6tsAfVySHXgl97zEv5Ya
	HzOCeOzygH7dO89odvd/jWlxyWXjgJhSw3otUjUCW/vz5jm1wjVV8EuEfuIDos+L62FJaYTJ7vJ
	dri+qy69r7Dn9dHrewUE+7OjA5T+1T52Jm1du8Rk8E9wFmdvsjvG31dzyWiO
X-Received: by 2002:a05:7300:c8c6:b0:36c:b138:651e with SMTP id 5a478bee46e88-36f767156a6mr6292051eec.22.1794018602204;
        Fri, 06 Nov 2026 18:30:02 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faa4b8aacsm10457077eec.23.2026.11.06.18.29.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 18:30:01 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Yili Zhang <zhangyili01@baidu.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 09/13] mm: hugetlb_vmemmap: move alloc_vmemmap_page_list() next to its free helper
Date: Sat,  7 Nov 2026 10:27:52 +0800
Message-ID: <20261107022756.77731-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261107022756.77731-1-songmuchun@bytedance.com>
References: <20261107022756.77731-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: yuam31j964e6zp77r7nghmaywfipnioa
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 969DB100007
X-Rspam-User: 
X-HE-Tag: 1794018603-141836
X-HE-Meta: U2FsdGVkX1/RUa9OGE1EC6udJKwMK9LzXG6xRP3e4/ngKeLV84m4F8PqzWf1Y16cDafIZjpjA/oWaub9+mKm8+XMY95y5wZtpdF/3n/6tI8YsWocAnrdlt6km6zCl+/hLJLWqOOQAf92sfTsvd8JsTjXXhIE9/Rp8tGwUlwnI9osBejCcf26txYi/VskKI1nMUmdFrlgdisgxhqcwOBNSRAQexIZMtrv3B6lhAoAiMq/RqTVCzAuZRz+A70FKCM2FjepI2trCn4ue88YO/XDfXWs9suR2zUlBTrlEILWJpOmRMIYM8SBT1ZH9aiOYCgUNmYaCwgbryA1FXroWtfcC7g82ZzjVi5Y3GRczW4Zj5dnxt/hAJrFC4dVgTNakkBWWydOYAhqUD1GDW0u5QV4V98mnbU770CvXyl9EB0XqlyrNBX/hRf4mP4YvGJzNVTFLBXdLta0a/MW/ZK5eFFRFFYbGMo+vkxB7gHAoQCqhSvCxmOmmWGSnarpLhYcP3DLtC+CjdiCiR+iWml4ygoYtcJg3A07AxCBG14nVB1XL76j0+dTV+07X/OmEXwd0J8i0MdrG2HyWwZspGaKg0gRF+UEMGshhnN70kwtplMLnYhmZyJLXraTlXE/iqstYUiQQqubQsFaOmxscRjsD+5NtBHl5TqkEEUfLL/OZzBX3sIWVk9ckpJ0V0jmGsY1dQfaCiNoWungy80zK+RHqFyYfO1CiR6CwmCHCu9jD4xEGkLv5zTw3UigkkS57RIRfb+MQxGqTW9HeNL9//joDu8VUqHUYktRM0F34kMNkexSYDFog8IKmo2yBWG5On+Nk5l2E9OTexKkMWIVcJbxHMbB9Ju1vZBrWh11YW+3X1zfS4dGMfVqoZWnmlUuimgRjo6I3JMH5DJ4Kx5E2Acp+98ZhvRovSUaseh3YL8kxmhaWTTUIi1x2p4VNUfvNLq3fBbUImiubPBkn93HE86gitb
 ktqfrj1w
 lyK5fiZMeX8qDcd/prfZcev1SUsM7YwysKm+khBcf2QN4wveQ8PiGNyampr5rNKPaBEeGVRWMfLJRAbQWIorfd6IUFxRhoBr+rxM0qCRBqHxMNzzrAdJEqHPu2rPcL0wpJ+ad86WwXBNUpKU4ui0xbCw7/iCjxOTiqVL4c58jyousjjzKqM3gjCWSSGL5c6SXjgxCrD+AEJvLmBz86Ukir1ar8cwOylZKkkcMvs9o51/oAxCTlKEgcAMMMPmNvJXIHMt3X+BeBW71xd0N3lM900RXV32aIFDxCvfXrJehU1zS5ZO/vgl3VOVgLH0c4tqsnAnrqLGu3hubdm5IoLTE5ZYBbjxZCoRTPa1EWSIxluIZcYDkwO0Gyi4DUCJiXRTBNknS3vgkzLc0+pGpNhQu6iVKh24gzzEIUfUTkjN2GlOuPsgqvVr4sQ8rTdkxCMSrR68d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Keep alloc_vmemmap_page_list() together with
free_vmemmap_page_list(). This also allows the folio-oriented
optimization helper introduced in a subsequent change to reuse the
allocator without a forward declaration.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
---
v4:
- Carry the caller-selected allocation mask through the helper move
- Collect Reviewed-by from Oscar Salvador
- Collect Tested-by from Andrew Morton

v3:
- Carry the revised allocation cleanup through the helper move (follow-up
  to review by Mike Rapoport)
- Collect Reviewed-by from Mike Rapoport

v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 3968dfe7f5a0..6c248e8fbdde 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -197,6 +197,28 @@ static void free_vmemmap_page_list(struct list_head *list)
 		free_vmemmap_page(page);
 }
 
+static int alloc_vmemmap_page_list(struct list_head *head,
+		unsigned int nr_pages, int nid, gfp_t gfp_mask)
+{
+	struct page *page, *next;
+	LIST_HEAD(new_pages);
+
+	for (unsigned int i = 0; i < nr_pages; i++) {
+		page = alloc_pages_node(nid, gfp_mask | __GFP_RETRY_MAYFAIL, 0);
+		if (!page)
+			goto free_pages;
+		list_add(&page->lru, &new_pages);
+	}
+	list_splice(&new_pages, head);
+	memmap_pages_add(nr_pages);
+
+	return 0;
+free_pages:
+	list_for_each_entry_safe(page, next, &new_pages, lru)
+		__free_page(page);
+	return -ENOMEM;
+}
+
 static struct page *vmemmap_dup_page_from_list(const struct page *src,
 		struct list_head *vmemmap_pages)
 {
@@ -324,28 +346,6 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 	return ret;
 }
 
-static int alloc_vmemmap_page_list(struct list_head *head,
-		unsigned int nr_pages, int nid, gfp_t gfp_mask)
-{
-	struct page *page, *next;
-	LIST_HEAD(new_pages);
-
-	for (unsigned int i = 0; i < nr_pages; i++) {
-		page = alloc_pages_node(nid, gfp_mask | __GFP_RETRY_MAYFAIL, 0);
-		if (!page)
-			goto free_pages;
-		list_add(&page->lru, &new_pages);
-	}
-	list_splice(&new_pages, head);
-	memmap_pages_add(nr_pages);
-
-	return 0;
-free_pages:
-	list_for_each_entry_safe(page, next, &new_pages, lru)
-		__free_page(page);
-	return -ENOMEM;
-}
-
 /**
  * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
  *			 to the page which is from the @vmemmap_pages
-- 
2.54.0


