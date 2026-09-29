Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E1A8CA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 223036B009B; Tue, 29 Sep 2026 17:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FA8D6B009D; Tue, 29 Sep 2026 17:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EA896B009E; Tue, 29 Sep 2026 17:53:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCAF56B009B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:53:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E0A1140619
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:28 +0000 (UTC)
X-FDA: 85268151696.12.C9EC919
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by imf11.hostedemail.com (Postfix) with ESMTP id 88CF440006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZkIwRJtV;
	spf=pass (imf11.hostedemail.com: domain of 3VDO8agoKCAkwruj74jr1qpxxpun.lxvurw36-vvt4jlt.x0p@flex--nilayvaish.bounces.google.com designates 74.125.82.71 as permitted sender) smtp.mailfrom=3VDO8agoKCAkwruj74jr1qpxxpun.lxvurw36-vvt4jlt.x0p@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790718806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wAhFd0jGDjt7zoASvNiCqcMpRW3iwBtEszTc/DFImjA=;
	b=zPhIhhaEwcpwQF8yPu3by5tpr2nQy+mDVJ0M4uCxbZMyYhXwbZU843it4a3Wv2bvZHNS94
	dm4Jc6BMq1+r0Qtf1dNzv5tVvTvQOgsSXABHYaPHNlCQst70/zRVjU3czfvtz6G7H921Nn
	VC+Gja9Av9Mct9Hg8PC22tskGun/4bA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790718806;
	b=RDp4SqLRZz+KNwSnpq7o+FP9azbb2hkN70gzQKE/cLV+ODB3/eO6ZLlgTIFyID3u6wG37G
	/OxN5xEYsloZ3eipe8OagTmImJW8d6aeZ8M4tvNn2SiIvwW+mJzu5q6XJfFVQOup97yJ/7
	tt7t11E9bG72iYj/Pq5hImUgNjdKCJA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZkIwRJtV;
	spf=pass (imf11.hostedemail.com: domain of 3VDO8agoKCAkwruj74jr1qpxxpun.lxvurw36-vvt4jlt.x0p@flex--nilayvaish.bounces.google.com designates 74.125.82.71 as permitted sender) smtp.mailfrom=3VDO8agoKCAkwruj74jr1qpxxpun.lxvurw36-vvt4jlt.x0p@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-139b62317d0so1067772c88.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790718805; x=1791323605; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wAhFd0jGDjt7zoASvNiCqcMpRW3iwBtEszTc/DFImjA=;
        b=ZkIwRJtVdCM4hDY709BPoCNB7XuPFBF4EqjpgzBB4Nx2T/WgFmAw2qip4sK+kUgqiT
         uaH1mNbqSHBVtNtpnvtsRdUmxwVH/ia1ZgbuuuMR/OqnEZlKECG9Ut4W8ys5iKrmMU6s
         mjbYvFq5m0nyJOdf1L2ZCBCm1dcR+MHrT7Elz23tXgzrmThi8MeFJ8LRBzZZndrGLJyw
         lpesTdJYhPI2lX3ERKmJcuLqYaMFIewIS8bJxJ1+wfFY0i6CKYrcwRZ297YPtjlthDqr
         63LKOA3A1Oxpv+CJj0aII71AH9iUd1PN1YYnYccsJbGAYx3zj0LTNawy04QrjLXelfTo
         815g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790718805; x=1791323605;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wAhFd0jGDjt7zoASvNiCqcMpRW3iwBtEszTc/DFImjA=;
        b=k2Om+eNLB/4QsPqnjzFrGu12QsAVky/GLm/y88XaWalyggN8HY7u2IaXZE57TqdqCs
         cu1bx4w19+SS5Cl57Zllls29MU+D95nMUSgMAEcQyp4yjHiHPOFA6mH5SVKUuuMxNCj7
         g4pOOBoK533chpGuHqa6nnlVvaVaYAKFYxjSAH6C23Y4Nc7K9XXY1Snko5Bd+h6IRUEZ
         ByYZmIAc2nk3bu5C1NQXz458MaTcaKKgtp1UjiVnZohzoDr//kNDD/hpmUkr1UO62yLy
         MwGPLRt3Pn2eO0TrLhMnbyVJMxBtweRtxknUQ8QUh3iy/xJ3laY0RR6EUU1e8QjkBkwY
         BjBg==
X-Forwarded-Encrypted: i=1; AKwUvByXS5NE9NqqaHDtT7HiTByysBpE0CcFy7//bBVHnQZ+GBbnNdle5S6Q4DtabGK9YDVx0ddbfM3Qpw==@kvack.org
X-Gm-Message-State: AFuF++kfZciSAfJ5g4WrmIT1tw+OJr//NAsn6mAtlGiA1AAKVIaA8LG1
	+Iv+jA8akQL7KNLKyu8zcpJFOFLaKtmNigb07PTJdl4cUHNd6nU/1+cFN94IWRfrR8yGQTXk8mQ
	TP8jBLjGd2kax11lYK394ug==
X-Received: from dlbpt13.prod.google.com ([2002:a05:7022:e80d:b0:144:db62:fce1])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:1184:b0:14a:51c8:e9fd with SMTP id a92af1059eb24-14c9f405490mr543692c88.26.1790718804889;
 Tue, 29 Sep 2026 14:53:24 -0700 (PDT)
Date: Tue, 29 Sep 2026 14:51:58 -0700
In-Reply-To: <20260929215206.516490-1-nilayvaish@google.com>
Mime-Version: 1.0
References: <20260929215206.516490-1-nilayvaish@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929215206.516490-8-nilayvaish@google.com>
Subject: [PATCH 07/15] mm/page_isolation: use folio_page() in page_is_unmovable()
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Greg Thelen <gthelen@google.com>, Roman Gushchin <kfree@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 88CF440006
X-Stat-Signature: 99mww76nw1wpionaohxgcu1ba6jk9uz3
X-Rspam-User: 
X-HE-Tag: 1790718806-113711
X-HE-Meta: U2FsdGVkX1+gn/410Csu6SFZfYjdHALTxX74PJ/taP9KtViIBoeWFbWkXADBiF0wHlYAlas73MbYv9UZgTW7/OGYxBiQKNFxlr8aSOYoYhoKDEFvyErZ8t7Edejp3Wv/0khphV/+Ape7W/VGOPWCdntugGlaeYYhQHyHOEZYe217vtObS+ek/NOu1yey3QpMHy3GROcHsW9f6D7m81WWBDzLVSb94yPBnNRCWEAVs8JQ7Ozk41AQdxEGCHe2UwEuV7ynbDWrjq5Bb3zLJa7qZlLD+0rCjBlnF8+gkkRsjXEKXdh2IGk1Z9G2sekk28Cciy5P0uX2/kF9tpVw7/fpgUnPk7USTjLo6J3it5eOFQnX+CLfcJZ1CLnjAQ883z4atx0KiTPuPaUxg5+FCRj3htJl6fOgvlMPCh1BD4rmWdK3mtJAhcp+LxHyxUdDpu+Op06W5n72n8p7R4/od3wWxaZavlM439Q/U5MbqaaQvKPGtA2uTyJSZNgvSQ3Iis+3XQcXzmC6pAS9KiRoY9mDESEcxKv2U9dBkRMSdxoxiqu+SsbiCMJp3OEefoM0DjKUE/xy8WXRjW/8kj68winFojtx1Iveht0lSgSL3s9e77zT50sCJi6NZxZSnl62wwKWsFRuWM/DnqEIIhNEANR3S6Z54hpzU9kAx2CHxGOLppQ4kiOEXfOr2AqY490DLREtmva2U9d//zoslIBuLmH+5z5lh6b2zHzM1sz7+xdsym+VO14ZmMjwXnjiL4FCwgayFi1z56p/Om32+fa1Fy995GR+67+3yIcnLEHD1moWhCJbOJCGaWtoNBG1OJipf2iPzPfO3Ss785pWMZrmr73ZwycHTF3McOquLjKkQNg04sCJPHneb4CAtgWNEuMZaHEzkrXGBA9az3ZncmviNWsOlXpVqFcGQ0SU53N4u2YU6grbsdPD6PPlHJtSAkxR48tCCYKzcAzwdIoigTONnN/
 XdUrlkQZ
 k+zln+KgyJ5OEGW9tfUyCUEL7/k5ydAGz3lNRTc5Dfmc8fccMp9zJ9gAEItfwY+E7a1uOEdZf5oOUqgqCZWAlV5zQEZP0DXcpI7t7337/0UGwVMBTfRVnPsoKM3T+Ir0gr5hTcFuUlmunFPxv8DKIoSflch/sTJbKZVRjSyeEz5cODpILQnIxPxsobe0xQJI3auj7u7+oJyKMWbLYnQ3eNSg1fmJi3X1Kk8YQfsMtqtFCwhSM+fCiea99ep2Ff2qL3yVvJPSt21vREkkxnaJ0IbFF1BpasHSiBoF61xKFVX8wPEvJvxs2WmhvtyqEelhMUcTefny9WfzflBynIFJ1FQE369PjQ4TFNt+B0CUNS5PS8NapqGqc2lH5u6xKLtLeeY4RgJpFXWLq91xmUUPTFnR+x7V358nlV77GMAbvqDAsiFumTp5agEAIkV7LECfKnLN65kG2UK+sXz7gc2M+vOgCGXaXcCGfmFSe1odmdXBud2LHK+s+WDfSm/MhvLMq2MVwunD8o9GJC9cxXPQD7WRgtvyZo9K/dHG4SKY6aIUXjzYR3LiRBPrIWKxCzTrhxuOMcxWnJbFtmugI0r2SlU9Rwlc1mpLQHXtpizKo257yrx9Qlel61fn409Cdmsaja8j2ra0Scwxq3iut7jA5Z1h0yg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of the memdescs effort, struct folio will be allocated
separately from struct page and will no longer overlay the head page.

Replace &folio->page with folio_page(folio, 0) when passing the head
page to compound_order() in page_is_unmovable(). Keep compound_order()
rather than folio_order() since page_is_unmovable() inspects pages
without holding a folio reference.

No functional change intended.

Assisted-by: LLM
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
 mm/page_isolation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 5aaad037384e..29c9e108b2e5 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -47,7 +47,7 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
 		unsigned long nr_pages, pfn;
 		unsigned int order;
 
-		order = compound_order(&folio->page);
+		order = compound_order(folio_page(folio, 0));
 		if (order > MAX_FOLIO_ORDER)
 			return true;
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


