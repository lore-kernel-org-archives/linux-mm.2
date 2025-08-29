Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B77A7CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61B58E000B; Fri, 29 Aug 2025 19:39:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4FB68E0001; Fri, 29 Aug 2025 19:39:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B109D8E000B; Fri, 29 Aug 2025 19:39:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 846808E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:39:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 521E31409C4
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:39:57 +0000 (UTC)
X-FDA: 83831415234.28.C527A6D
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 70E4C120002
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:39:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h1ZY8xAc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756510795; a=rsa-sha256;
	cv=none;
	b=uSgeV6F/Hwmkk8kidoDy+LyzhLtCIbxx3VdeFC1cVI1bwyL5/vcqkSoQBVEjVouXxpQHE9
	yAdDuqCMNVHAbixdRSHcBYuWT1UULKKjW9jQEoIORj2ReBFbHJvP7ZMsSzqoh5OSbKmb23
	mwHm8BXhLuO+xG6pIMJV6ix7siYMBJg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h1ZY8xAc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756510795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJA038u/hVaTfJzlpSdIW82J/HgeOkdB6HYf+GuBfk8=;
	b=5nNdOvwQV9G8KzrsVZhD+2fmmhBrzfPpUut1Kp2mGltBmcLt1d6qSdXa3FegEfMmsDxhCF
	bN/apvi4hV59W1eqJxvqgiAdt3+e347rOEZWzN1qx9KUZ7u/Tem96P9WyKslsOBeD6jqGI
	x3uGopfO07KIK5J9i2oL+pygnFgLNFU=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7720b23a49fso2967619b3a.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756510794; x=1757115594; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FJA038u/hVaTfJzlpSdIW82J/HgeOkdB6HYf+GuBfk8=;
        b=h1ZY8xAcia1YWKvytmoENzC8k8pQ+9nFYwvIvACCsYb1w6X1QWZSnPIs5dshVTyY1d
         S+v/EH9UgPvb7vor51h40xyxncjdjr5Oxaf3bImZpE+vRMojmGpzPgUCPXieCz7DqOVL
         lZUvClNoE3auaXsmiSyLMEmamdgk8lCkAMhv8DhW5xtd2hZihCMai8V3hFAsVlrdhL2b
         uFzzaSSLetjx8I0ehAXYkwiQyFFgvH6CXpX4L+Gh5x6XdN0rxqYy8dpO9ArGIOdUDPLm
         ivv0lmyxz7xmu8MV11NecAvpY+8zAu2hJFt3My9EOpobWg/FIEqj/Xh65tStzE0YYhQn
         jPjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756510794; x=1757115594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FJA038u/hVaTfJzlpSdIW82J/HgeOkdB6HYf+GuBfk8=;
        b=j71q8XK3yLGlijNbFht/89t/9qmP2rBgQhkbZpUGG48GBPIin9ZZjJZdUwoCUmNVdp
         GS9kmL4O4OeY9JWzACWfpZtjg9NKbMc2uLcJdxxWHExKmDuTJW8b5MLoFK0RSGq+r+wu
         vHKt+E558M1NrtuO434T8nnT+xqGhviSPrzvB9NcVeD58y1o006wBLnwcCgVK0n96b31
         /uHW8lWyJ6xmflMaP/66E2LlXkKhb7M1bDc7K+qEmfS/9sWy/RLkXWeQhpqEutEBF13f
         b8jL1q68ljh7YhE2ORbOijHVirOAhb9GY4M1UFzjiea4+eah1l1nZ8KrZi2VH7AQ7DnF
         nrqw==
X-Gm-Message-State: AOJu0Yz2Drd4Kycv5AvZ1YWwO8DuLKgVjiHNdpZE0i8l8xEOvDvU8J2r
	VWKwzbrtLmNuAo+aoCQTTGyP41f66v+QyX6C0HfUf0LP9RP6fKS3IIKxZ9Vunw==
X-Gm-Gg: ASbGncvyyybAbVFKE7/D7xVSw04XD0quObLfCsXbMxXCbpnKjFwZ/E7sL/K+j0/VjaE
	LxafVXLGMtBwKa4WL1WMH8JzeRQMMer1fmUbpOapMmh4oCkXGAHUR05om41gXPvVESpGqnRi5Ye
	rY8E/IAs3Irf8UVVOfK+V8WmFBBvA8XMmPJxos2+dw/cBnwqzdRHgYDgIA0wtqa0fIwBHC+WMG9
	OFDwAdpSGTry9Fct0QuztYLuh52UusmH36mYuuLOLkngGo7yYD7NIXd3vOFAV5ljHl3eiELpafd
	hDRsUjUI9pPk+EaDVdag5Qm7ultR5LYUnBcGnuRcM+mRTN7NrfLjogMDa1ekyv2zVwC603MexrN
	ALkfQOjQi08bH1FsqjQ==
X-Google-Smtp-Source: AGHT+IEBPziX3AMkqRWppj89LkOFryUfRsFbxlcudKr1XhSz9+T7ZzWbMWnph4rPkKvGAQaf5UikVw==
X-Received: by 2002:a05:6a20:244d:b0:238:3f64:41a4 with SMTP id adf61e73a8af0-243d6f37d92mr537160637.44.1756510794143;
        Fri, 29 Aug 2025 16:39:54 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4e::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4cd006e546sm3226572a12.4.2025.08.29.16.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:39:53 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	jlayton@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 03/12] mm: add folio_end_writeback_pages() helper
Date: Fri, 29 Aug 2025 16:39:33 -0700
Message-ID: <20250829233942.3607248-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250829233942.3607248-1-joannelkoong@gmail.com>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 70E4C120002
X-Stat-Signature: bpwi3iaq1afuhmzmcyoq1n8h1rmsqy3f
X-HE-Tag: 1756510795-881785
X-HE-Meta: U2FsdGVkX19yEX4VkbVlfBCR13M+dsw6EY2rsVjtCkHa30N8Dg1pRtDMqJwcWMX54w6lu/zEPhy5GKfEdCxZWXdSqyUqc3Sf+qEsYE2xKVa2oWvlfuhax9DpZxz65+3DZiOztc1iV2tkS6lCxoGZbnRAUeAMKjpNY1sViejpEZgEwfCH6jSaskUgbv7Ji3YAapbHPDATwuYsA/ZQEdxm5BjcyT1duLApg+qGFgbxVjWum3FD2pSLOs3fgzjThYCIKJepe2oJi8RiBmihSqASB0ipSGIvXJQQ8UqUmC5WjFJPb1wtnJnn2HhtuTMuYXeedRTOdHWOogYbQWH1UsHhzkadHZGfTBLnABed9XhTgagIsordj6OqCxf1kxghLViugcE04fjvvezPQjJ8QC+sGxNJx20/VsajMvaqMYNoIk3K5XtHEhn77Ks/owwH77NNjO1lzkn9uUj2uBZO5hpJvslRL/7y7J5MfJrfOJT7jfhZB4zsCuQlX0JYJWgJgIT11BEvdk3dJslIYGi4Rr1zO5eBIw8g8GRmvjGlxJkSAj7tg9tzmxUcLbVbtYm880JhE0XLfp3acfTTCzObIUM4QnHbi1Cw0QlovBEI8vj2Rpe7nNgihvLf8DN6zwlfsVXsgtTC7IKMfljJiJF/qNhRoTkbfCwxD7IybykTxriBSmnOeiqhwqqj+TnafmtoaRkh+4iOE/OSqB2VZsjUJ89qJn1dKgv0+kCwQp8BeaNxxvki9kHYnzjA825DoB8zVIBxrNJN5kfPrAyOVUgF1dFQovW5k28hPrrqTpMkqe28V/heqohLbbbvOyDqzaC7/9Y+HmuULvPsHZlrnYuUvDE+Cz7rHvZQ7iyyf7ycCbz3umZ8w8Y7UuVxFkAIIqZPwyQdcEZUC+l1ah/Lit1zrlAlRQ/VyS8y81BvnMc/Xwgafhw/ttgmPXS7uNnZdx5xXwIvL2BjgmOeFUMR2AGPkGZ
 L2Dn5NwL
 mVwzqY9+/P6elWSAAcJoRj+IhsH43n3nuC8OKyYBhx0wlKNb0amQL6DioSVYFwyJQTbjEISi0UQ2FC/RWg5ci3bf5hwrVAaQecIw7goxUdpIVb41Vv3u9K2v+isRNr5kfdfMda3PmThtYea22D1qSpDemx23IYYbAVXBlriyDVWsseTFg2SP9R431RoQFXkfoh/AKsdIFcipX8HVdJnirwyu/zwkqmK6nyxztXnD92KxUR2gFVd7+QP/+NXiIvM4RYoJNkt13UdXiycuiI0SA9Ec5GKL5e74MRLRjV9PJTkFG7+yUz6cXmdpkdrubvXxZkPDPOCvpABe/xVsQasncmppkzJQSxD8tFUTq3mcHboKHqYqn5PMKK64Pe1LC5wRpufbvwpgAoyglEZoEZ2qmIS+2Ar7nR3mzxBJ9j9NmBSmEOGhDus79a716REyhYVY3DWXk2px7cavUv8I6vqRe1mO09npCCT1ZZW4fF4+tNVwdOtSHRS3hkL9rcJQo5wdHs7qTJzBec6vJvWklrR+Px5EhPsQqpB9pqXbfTSD3tYSqPMI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add folio_end_writeback_pages() which takes in the number of pages
written back.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 12a12dae727d..362900730247 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1221,6 +1221,7 @@ void folio_wait_writeback(struct folio *folio);
 int folio_wait_writeback_killable(struct folio *folio);
 void end_page_writeback(struct page *page);
 void folio_end_writeback(struct folio *folio);
+void folio_end_writeback_pages(struct folio *folio, long nr_pages);
 void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
diff --git a/mm/filemap.c b/mm/filemap.c
index cbfb0f085eb6..6d50afaff930 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1627,14 +1627,15 @@ static void filemap_end_dropbehind_write(struct folio *folio)
 }
 
 /**
- * folio_end_writeback - End writeback against a folio.
+ * folio_end_writeback_pages - End writeback against a folio.
  * @folio: The folio.
+ * @nr_pages: The number of pages written back.
  *
  * The folio must actually be under writeback.
  *
  * Context: May be called from process or interrupt context.
  */
-void folio_end_writeback(struct folio *folio)
+void folio_end_writeback_pages(struct folio *folio, long nr_pages)
 {
 	VM_BUG_ON_FOLIO(!folio_test_writeback(folio), folio);
 
@@ -1657,13 +1658,18 @@ void folio_end_writeback(struct folio *folio)
 	 * reused before the folio_wake_bit().
 	 */
 	folio_get(folio);
-	if (__folio_end_writeback(folio, folio_nr_pages(folio)))
+	if (__folio_end_writeback(folio, nr_pages))
 		folio_wake_bit(folio, PG_writeback);
 
 	filemap_end_dropbehind_write(folio);
 	acct_reclaim_writeback(folio);
 	folio_put(folio);
 }
+
+void folio_end_writeback(struct folio *folio)
+{
+	folio_end_writeback_pages(folio, folio_nr_pages(folio));
+}
 EXPORT_SYMBOL(folio_end_writeback);
 
 /**
-- 
2.47.3


