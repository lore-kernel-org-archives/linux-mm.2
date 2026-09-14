Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC382C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 03:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 864CB6B0088; Sun, 13 Sep 2026 23:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8133A6B008C; Sun, 13 Sep 2026 23:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 728A76B0092; Sun, 13 Sep 2026 23:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0F36B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:34:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C922F80F2B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:34:13 +0000 (UTC)
X-FDA: 85210949586.30.2090F45
Received: from mta0.migadu.com (out-251.mta0.migadu.com [91.218.175.251])
	by imf06.hostedemail.com (Postfix) with ESMTP id B93AB180007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:34:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pk0/Pa+r";
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.251 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789356852;
	b=3nVef4JsFRhTdLGk/EKWnepz6CB823qPj2WOY+17FgOCygTKYvezs8NVYRrk6SfKoCO8m8
	OfgvVoo8mF3fiDaEbUVyALwEIIcjKZ07W/e6v4v/kjPWka9KpwfPHSlX2wcqA181aUBD5x
	mZxLV4tsUDoEb+d12sJf5D+Q3WVSmq4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pk0/Pa+r";
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.251 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789356852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tYGxwFQOT5ACuv1riYGzPZ4lpT0UYkgTDkA6072mTQg=;
	b=6Mxg38cvMSbYCKQoRASUzO4vQMHftY3qrAbVG6KV3I1PhJnsf7yOpsT20CEHcFq/wPiupA
	uyZ52IKj0y4v5XulfOCzzZ1b0tyRmD7Op9dHAhp63fAKWt7Itd1iZLYMSzFN1D8DijWNNI
	9kSAUx7E7Q1DYb0Kdn59RSwlaATepKk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1JX6OxGw6Fen5q/U+UOj7/291svvQ/6DqcLx9AxyrxE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789356850; v=1; x=1789961650;
 b=pk0/Pa+r9mOLiQQBK7V0hbCUvySlkwAqzNzUrObbc7GDWkGBCzm800KqmKT3ooULSdjR4ee2
 Mpcg/Fn5r92bk0Lk+7jLdJGWuhFPiGvIBd/z60aKIAzHwhYrOinUnMTTCIP3kBOkVYPLBSa5KQl
 QPPXaz4t44ohfzJiT8HCX1NI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 135d90a541b7fc0b;
	Mon, 14 Sep 2026 03:34:10 +0000
X-Mizu-Trace-ID: 135d90a541b7fc0b
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Subject: [PATCH 0/3] mm/vmalloc: minor cleanups
Date: Mon, 14 Sep 2026 11:33:59 +0800
Message-Id: <20260914-vmalloc_study-v1-0-526f68559706@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACdrp2oC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDS0MT3bLcxJyc/OT44pLSlErdJOO0VPNkc2OLNKNEJaCegqLUtMwKsHn
 RsbW1ABo2iYlfAAAA
X-Change-ID: 20260914-vmalloc_study-b3fe7c738f2a
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B93AB180007
X-Stat-Signature: fdwt767asm4rbek6disdejym9yr8qjjd
X-HE-Tag: 1789356851-766262
X-HE-Meta: U2FsdGVkX1/Kow8kWhD8z6bRDlst+o1C23WJHp5fvFGz/pAyzqy2h1LIl14ekPUPbsASfH8i6KZm1Q4Pc0lrzaTwPMf1enC17cW0OM/FWPAPJl65+mP49OB0VlYxBZvP+NRF/AggXplV7YN4Z5XAwxJGxWWz6TIYMTSv5pr7acnmbzNoJL11wY6kr2sw3WC7IxDprHTCB4AWuC5rwbDNV9FilBLTVS9N/3UdpznKmuey00AFnFyDD86FSKUHHg/iCcsAvk6r6Bl/vHrClzoXDgPwVwbxbGS3y5zxytlIUY80cQJf2gDWaovHLQSOZkvYFTtHOU7ajavbeumjtt6JLUUX1Sxx6YpMs2/aZBD6LTtAAxxnMEqa6akYBeAynG3RuSgN8WFrlSKTEjsiV3F9xhrkD0BvrDfc254fDPKY/ZOX9Ei8UaotJl9m9hAd9HdKMA1s5Q+JBlFWc2rNF2Z5lFFnn2OaOaoKSf7XdoAYe++vhV3ycNpqb1iJvFp7SH05bnAtGaKMp9hwo94yzARBxpCm7e/UXZ2Y7cpL7CRSov8TqtB961DxCLxFwu2F6cbqqh7atLX0s1yWpkCgY6+h1sNhGNgs/fK0cIDAaW+Mj9T+9B7Agf34vLExpv2pQZ+GJH3yZyfFQB82gqTTV0bVva09Jmfs7On5dFFTSv7Zwn3OorAl6IqAgl3yCwVErdeolfP84XKyKzVTldLFM7CqXqSYq/3rqZOqf9euLiTz2bOtJjQ/IbGmGp2T7C7IDkjAV7KqE0ZP0VZM3SsmVgj6eTDfqjpnbyD8LtnWD+182qZuvakNHVHkkNCh8Fgwd/I78HEBxMYP1CxWis4x3I1NOPt79jUyreOmbiXff2jQY6FMAG4Xw9B+os0g09eDzmTG6Di1kreVASUzz9oMZoZx9kpNSfid5iztgI01TjLY4Plk7AvlAsGXpI4YQRyQZnIUZiBxl8sgn2HJyFpV/7n
 jMEvU+s/
 a3PZxH7JLm0jcon3bgHPwbiqPhaJWiZBb/zvLMNHzZ8FMqD2DfQjjSPG23b9Ozbpv12I93FfMAgVtwDS2VHV80rGTlMNEq+zMNfSYRsx6zgMMwSBR54bp4No3+AbSGdu7O3TfjkuA2aLTzyrYisZBD+eqKaCNqeL/i4HZ8Ko/z0w/0CBIOfoZILzOqiC6/PazkLswkaqPFrrVLX2FFVbmIbkh1evK9EdAeyZR2oJo+j7HgrA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Small cleanup series for mm/vmalloc.c, no functional changes:

- Group xa_init() with the other vmap_block_queue field initializations
  in vmalloc_init(), instead of after the unrelated vfree_deferred setup.

- Extract vmap_insert_free_area() helper to deduplicate the allocate-
  and-insert pattern that appeared both inside the loop body and after
  the loop in vmap_init_free_space().

- Extract show_busy_info() from vmalloc_info_show(), mirroring the
  existing show_purge_info() pattern, so the top-level show function
  only orchestrates the two data sources.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
Ye Liu (3):
      mm/vmalloc: group xa_init with vbq field initializations
      mm/vmalloc: extract vmap_insert_free_area helper
      mm/vmalloc: extract show_busy_info from vmalloc_info_show

 mm/vmalloc.c | 58 ++++++++++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 28 deletions(-)
---
base-commit: 68142f986ff04b2b70b31db00f719bf690f64a9a
change-id: 20260914-vmalloc_study-b3fe7c738f2a

Best regards,
-- 
Ye Liu <ye.liu@linux.dev>


