Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED9DFCFA761
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 09:44:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49EED6B002C; Fri, 21 Nov 2025 04:44:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44F7E6B0005; Fri, 21 Nov 2025 04:44:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F0D06B0095; Fri, 21 Nov 2025 04:44:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AE9E6B0005
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:44:23 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F60DB9DB5
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:44:20 +0000 (UTC)
X-FDA: 84134128680.13.9D21488
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id A6E311C0007
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:44:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I9c5iy93;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763718258; a=rsa-sha256;
	cv=none;
	b=Zu9wnQn7iiWZEit6fwVAEC+meGcoFamDYkJd/RZ8tsqKrQHz/TEzuZ7pSeiHHWag8mjCCR
	e2qAKKTNrelOVAfeCHk4C6axIWWyRXThrO1xAkCfy2FjEO7Q/emuFj+ApVAC4WB1Gs2jSI
	1uEnF8HmkfoTA7NfMlzCVRg42ETTVXo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I9c5iy93;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763718258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ViWHsxO/UANnvPPe7gIpM9Rg1HONabQOB3jUU84+K6k=;
	b=rLet+X2h57raEocPkrlsI/bW9cbSSggyq1uZ6ZfRrGrDZhLXy6ze5KqaiDnOBH1cm1cJk6
	xZLFzgtb7gEl3z3r5fyPZQ4drE4Zn01Ie8FLMKLF6k7ZSiSLLQU+E2al5JAHiRTBMpJ/S3
	N9FN+cLQAQJcD+fZONBMa50lHk30ng8=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7ad1cd0db3bso1599437b3a.1
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763718257; x=1764323057; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ViWHsxO/UANnvPPe7gIpM9Rg1HONabQOB3jUU84+K6k=;
        b=I9c5iy93MkhibYPwFGMHVOGYcLqiR9HAE2n/zOMgTuHaPeFli1ftHWaxJQX8u/ketV
         7mryl63UtlOeXlQVtIeCl4RArc4dmTRGUgfzQTk9eboR0ykdT1h/i8yEMeSQnn7Jb7AE
         ieFMbHL3mex1yy2nKa3wa4gL5IVYMLWEEDP1+2SFv5HukQ596PAmsA5N/GZF01+Id7VB
         jUj2X/Jz1R2d+kjrgrIH8dd46ygsJYJGHCfq3eljH6Lgv84Mj10zyWp6ntvbql4cDQXx
         ZhnaQoJNZKtUiVBneNAsHj5ZlDQ8+c+izf7vxS6ZsDS60/Xo7DLHfitk5gVn4j8+fo+T
         qk+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763718257; x=1764323057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ViWHsxO/UANnvPPe7gIpM9Rg1HONabQOB3jUU84+K6k=;
        b=M7J2R/Wa5jBZhhYAw9dMMNeaJ9rrI7TpedAQDLgJ4xFnp9y7C2XgI/ZWlgfe0yhq3m
         enlfbVY0LNsQ0uZ15pKf9i3+xq2JguWYpEzq9tUH+aVnsAeEvi3Uhd/MTtPvcOUI6vT8
         XY0xnYwqXCo10nHfz0FszW3NhwYC4xeLcDj10LcL3K+4NfKCMI1rBhWLDhhevxoNeHvp
         n4mdQ1V4gxTO4fn/jHONUzpWTZ9rkprCf0PZLaun2k1aWnaEG6DLdrRFxp8eT4ygHi+2
         Fxkgy7Ajl7IedueaA0fa65hZolY1rvyBgRg3RCwnnWEtkF1IpVSf46IF6ggJMnyLAiBt
         EiRw==
X-Forwarded-Encrypted: i=1; AJvYcCU2qu68Mg0kJmT0gFlnyaq5Q+ATQ6eFL0lN+AO2MncZ4Z1GmkktwgCQlqNXpHZ6xwITmrC1e8VoUw==@kvack.org
X-Gm-Message-State: AOJu0Yx/jz9mi5gKbx2NOYmhWiqmtitIjFImpQa2lzBG9+LldFubaWMH
	af2pac090REy+jWFjeMGsyb/mCafopEBIHffFZsc+L6XNOxVY8mLMZPC
X-Gm-Gg: ASbGncta4QO4l5OkqQof8dKoCkICbUzDTyMzibzdefQVQkWUqroRAy7Fs/iSIUacd1u
	CAKT049HeyFMjivk19SCIGWwawQzlojL7Rd2M5XHlRLC9t1a2ZRpSVpt7LDBM4shqqM3N98BP8q
	tK6tiNohJBVmpMeirsNyU1N1wIyofzbB9qg2oS08FXx/ggPqXBCVn7eEDW9R3fsRIqjJeTNpj4R
	KPbK4cm25ZtMzvq0agArwq7hQLWPw8PkfyyTMv+exBBv3wZWQvAnt9gWepMo5En959GQTeIeu5k
	IhQ8sCu3+AcA0qiFUAtxlvNJh8MUYBrSreHSuS8wVsbzUzJmPC/w4OaEDiBZS9BdFAx+9VHyvVM
	CXahAfuDLx1Z6q0RMwpT8yw+uLY0HO2dtVHXtFfxAgBK1fU0uS3W0zMoPvdBrtVHVKcQLy6AyKy
	uWZJmgCKdzttzdirje++XsWENkfF+ZmR8P31DiPwPgSL0=
X-Google-Smtp-Source: AGHT+IEBVg8xenpQZC2zUyxsYRjmmWsvyuM65CCQfvuZWskDwPwgrGBlf27FiKxaCLQQWiTQytaG+Q==
X-Received: by 2002:a05:701b:2702:b0:11b:a892:80a5 with SMTP id a92af1059eb24-11c9d711be5mr337609c88.13.1763718257235;
        Fri, 21 Nov 2025 01:44:17 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-11c93db4a23sm22430736c88.2.2025.11.21.01.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 01:44:16 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v4 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
Date: Fri, 21 Nov 2025 01:44:03 -0800
Message-ID: <20251121094405.40628-3-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251121094405.40628-1-vishal.moola@gmail.com>
References: <20251121094405.40628-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A6E311C0007
X-Stat-Signature: pr7wg9xwjcmktp3uhtg3uq7xqrjbhpbx
X-HE-Tag: 1763718258-684189
X-HE-Meta: U2FsdGVkX19M1XIEU9vFtzWfdONbgyBZzcGq3x6XuPD0C+e1z5/KX65LBnyIiRmWpkS6YprdtDE9IalXg6bQbOIdSdQm1+MKTEO/d+ZHT7Kour8vHtI1MkhPe8fSFdFVO1auCsbU+1yZaF01Hb5LXjTRY+s1/uHUR56KWSX+rH1laynlasQwU+3nEj44PNL0SpYK0mvDL76r2bb6/n95LvpWfjkh7lfdBsG66WqIsA84Pk8x5KkvtsJJNO1V5hpeaoxS+rTOy+g6Du27MW+LohqYcnY0CndfcOSKSxgOFWtDd7EYi8y/VXEtR+RJ4E3WnEj+FnecW/kuOYXLXjrC10AjdNoPOtfdHDtu+P8gl601ylreUR+hdI0mtA+Uk5c4uCGxqZByNj/Azp2rocDIVtWh5cCUTtrAh5Tjs3YtT37ZJLPjtx5uDEJgSBaurFTr+EWsgygu9n4567B1HKQGHth2Nk+K4Aj0glryEHMAuFU/i8OxIqM2xLrBh7zWoAdxAOXn6pby9YhAM2JdjJ2H0vtm1EAA6jtK3t6zwwgjY202tFIh4iVsY3vtnLNKEpnzhl/jKV49YlXSa44K74c5IyGJ0egcKloZaukF2N5sO8kt+rhUNTOa4DR8DogyxGD3Ph6xB4elNsGo3Dfnl3qFT2CZzGFSy41cGNnpV2wJrjlBgt7tEUSeD+561rVNa8VGInQ2Si/frh0e80wR8BwSXITVPXMBIMzeJU5lMME0NizEEhFxC4xUI/l5qpYefP04e4GIgbZx4u2dSeHnau4Vu9aI8ydZxzAgas2PUGTMO9ekq7WnDFxs/epJ2o4UFEdTmcsJbAYAWPHqNVbcs+i/oySI8xj/THhEHXrlSzMW8Z9xpsYNJY4+87R+xmxrFYjbYl4DZ6QSYxzeWHjcRSNBujBALWVdKmx397wUdecep2+AoztKgdw1GH3TpTDmqWTlMcuyAebKn3eLyYhJtAe
 Wg0DIeOO
 SlCqLgZznA3BBRs366jCB6NrxGFKI44OaLvCWJBL5sijQrItN6EgywxAGTIcDF6RWa+9lEOIoZR1oEYCr6fIOUfsTRbTo/TLGIdLHOZVJ3K4TizG7TBXsPXniRyiZTfPGz8Fmqq/gdK0gNx0ETjFxoe7xG8TL3AMvnoxOxKRX2hyVlEIqD3/an4oh7v+2pFaBtjTNA6GEXLfFMQnc3ocxaKj/GMMhOFVUE1WLnZKXjKVxn0jRgpTWX6Q4dtASJW4kHgIV7CRxcxV+ADqj6BXhy8VNMnp+dA2tkU4409Vj8Fgo9ZNi2cIKX7hgWlAo+3phvtaXQHtMhErJBpK11bofdXwvzHUzY51RlK//Bl6tra765LHfcYBNstKq5ZTStXgYyN2AuHjBK8NUiT0m86rLE71Q2hh/tH0EPZanZH2Vi/rZmRdWmXBWawHaDttVdEybjwLAGKLpqbvPgLtkwARPfOlg6kmo3owgj+IRH6LtcrxT44SVdd07c8ow03XUwS1lnU23TM9ZliXB4N93GLB85R+U54jC0ZPDpLXPrEgUv8omxJbyzJ0gEbDqVrA3jnxDdS+4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm_area_alloc_pages() attempts to use different gfp flags as a way
to optimize allocations. This has been done inline which makes things
harder to read.

Add a helper function to make the code more readable.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Acked-by: SeongJae Park <sj@kernel.org>
---
 mm/vmalloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c97c874b6666..185add3f5606 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3614,6 +3614,17 @@ void *vmap_pfn(unsigned long *pfns, unsigned int count, pgprot_t prot)
 EXPORT_SYMBOL_GPL(vmap_pfn);
 #endif /* CONFIG_VMAP_PFN */
 
+/*
+ * Helper for vmalloc to adjust the gfp flags for certain allocations.
+ */
+static inline gfp_t vmalloc_gfp_adjust(gfp_t flags, const bool large)
+{
+	flags |= __GFP_NOWARN;
+	if (large)
+		flags &= ~__GFP_NOFAIL;
+	return flags;
+}
+
 static inline unsigned int
 vm_area_alloc_pages(gfp_t gfp, int nid,
 		unsigned int order, unsigned int nr_pages, struct page **pages)
@@ -3852,9 +3863,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	 * Please note, the __vmalloc_node_range_noprof() falls-back
 	 * to order-0 pages if high-order attempt is unsuccessful.
 	 */
-	area->nr_pages = vm_area_alloc_pages((page_order ?
-		gfp_mask & ~__GFP_NOFAIL : gfp_mask) | __GFP_NOWARN,
-		node, page_order, nr_small_pages, area->pages);
+	area->nr_pages = vm_area_alloc_pages(
+			vmalloc_gfp_adjust(gfp_mask, page_order), node,
+			page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
 	/* All pages of vm should be charged to same memcg, so use first one. */
-- 
2.51.1


