Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F54FEA82F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 07:38:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B28B6B0092; Wed, 25 Mar 2026 03:38:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ED5E6B0096; Wed, 25 Mar 2026 03:38:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63F7C6B0095; Wed, 25 Mar 2026 03:38:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 527B36B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:38:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 18A201B89B6
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:38:21 +0000 (UTC)
X-FDA: 84583782402.05.355A821
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1FE811C000C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:38:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=fbVrU3DR;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	spf=pass (imf18.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774424299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRPi6sx9pUKCMoRSmLUMPuhiHVNdSdGX+Y2fr4B7g8Q=;
	b=8mrcufBa5qW5JfdRWNAiEiDiwACSRh9vDzXvS7Km+1Kt5m+gg7/QkYHHL7ye5g6ZvayS7q
	7MdweNgidbIOLO6rZXoQ72F/Vyl6tmZFmWUY5YDLSYL1h5WdatLqG3ZJr4swDLNL3edy5U
	UwHHOU3v/kG0lIy4oTV94FRmTpa7WdY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774424299; a=rsa-sha256;
	cv=pass;
	b=gf6RZ/MqGL1vUVyTwr0j7si5pA/ofPb3E5l35xpc2oDJEp+43puEKn/yRqGTb4n3le9kQo
	+vwjJyKluKNX+rcD1gFcHZEWEE9+zprffjX4TyhBN3ipxQafvnS2hB4F4Mv/+n6sZYlbMb
	0o/uTu9wIgJtx5tnArPf2bx3rXBiFzo=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=fbVrU3DR;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	spf=pass (imf18.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1774424286; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=NRRI2Q0Ohsxx0HZ9KcDp6zyvPHeqLAD8MbQWobJSzSOE/ydMZV6B0Qb3+AagqDJG7LIpkr5uN8OQzmgKYvQCViLx+aKw+J7b2zwBpgXc04XZUhzIj4KEjT5HOaV8AFBaep51L93DnKfxaVfLx2yxaltz/8Fgl4lRqs5jXy6JjS0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774424286; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=JRPi6sx9pUKCMoRSmLUMPuhiHVNdSdGX+Y2fr4B7g8Q=; 
	b=SQX+2LSyTaGlDmItVIdn4zXuHdyN0Zc1qYVz6nxrZBDa4RPDOpnB9cthjhIwPfAOZfiIZ58X/bncGxiHAsL6vwtq+Aw0mZIrt0m2iseCruRd7pfPmLkaFXh/cIud6y/ltaECDD3CltM4K4GRNFafb2U5lJOuG2hjFjPXqiIk2QA=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774424286;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=JRPi6sx9pUKCMoRSmLUMPuhiHVNdSdGX+Y2fr4B7g8Q=;
	b=fbVrU3DRnQAeHOVx5L/kzLx+I+sP2XwtO95wcyZIj/KNc2wdzzzCtf0wG0AwRb4w
	nTSNMVqSZCiY9Hs+uWVcQa43JCWn5C6m9NaxPimXQ7Wkm490XcXLdpTdLv3bxhGZe0h
	F0oplsXpNI44yFRI+ItsWZt+FEEPO9+z66Puic1k=
Received: by mx.zoho.eu with SMTPS id 1774424283679760.5080198368752;
	Wed, 25 Mar 2026 08:38:03 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH 3/3] mm/damon/core: move last_nr_regions from static local to damon_ctx
Date: Wed, 25 Mar 2026 07:38:00 +0000
Message-Id: <20260325073800.141756-4-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260325073800.141756-1-objecting@objecting.org>
References: <20260325073800.141756-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam12
X-Stat-Signature: oi8fy6rqh3cg3xytmnfkqcz4jheps8uw
X-Rspamd-Queue-Id: 1FE811C000C
X-Rspam-User: 
X-HE-Tag: 1774424298-150552
X-HE-Meta: U2FsdGVkX19KQLudfiBhj/26aZtZf3x9XVz/GHBL73B+mR+P55qlBIG9laJiR/+GB9NVU3KVqdxQDlar95T/vhlqhd2LyTM3ffYl78Y+II0+5GJMs2P6CcASIePZn1fo8tkkC453E+mOyHHD6/9UcpUPTj39ClNqb9cIusgsk/MUdqhWgzhpDDegg+5/CdzPaJBMUudfHQr0cR4EgLrHeRjaxIr3EULlWFDxUd6Yg/dGw1a+4C1YqQ/q8Gp+GIIqpY7mQReVT37uz0buC2YvewG5q22MQd5GCA4G4kKNtfNfjpkzIoTzbbcx1KzVNEGog0bR/ax5Nz76wrejuKKH+1GcexQb2WALm9FBNb8gG8zYhvgTCelrafuTGvgneskcRa9IelfYS0uudk6vfe7QKEL1Ww/KdiaVKWUkaxXZJQTQa6qtKHmP0rCjTEJZh3NU6DzX9Mr2O4U09HDs4IU1tdPZLrfls4LX6DVSwWddg/Egi7/zgxiGz8DW0fIpVhuhajWOqh+0s3OaJEwy4K40iqzypnUsPTaKNlYRNIrxs/1Svn388mSuDvBMltXL8+XglZsTgj9U4cZR4aZBjBv5W2ewoDpjZdK4qYZ14+wgOOrlQQxlfC/oVdnq2iYoxyxMFYtEkGatZth9WwK9cv7ZsEtks5zIBL37kIPFt4e/2jrevF4p5gRY39s5E8uj2OUtjgaM431il1ytJ0JmWDFS94kHv4I4Brmb4EBeG1ctblXnTUloB4FYRtUV3ON8GFK5uJcKZfea1dnUkHUZAqI/htcKA6WGltfSK1y7uEnnM7acNqO+NgID6Pi+ApiAgWgrVk4+aNXjiAYsVeJvvGiYcSpRsmiS6Odd8Gyq3feNqPpoxgpn2k/YW+BR9wSkta358AUqdwmRS6ZgGQQ7rccOzcRcDUwuxD1uwKbed9XuaKZv/HXQHDTlASJxJqkceXZ2luKOSIxArZvDWBNRx0x
 AMtO9HJ3
 ozM+Y2TBbfGRMLEf33ITEkXSYbIduvOHoRK6bwxiIrQ//RESbLr7TOKcTmM79GcaPyxxYKOH3rl9PbiA4L1FA2z9N2lkuPOZeSRtc11BrN5ijki+rnWUxgz04uVPge5p8E1gC/BRLisp0F+fJTuvhhBHvySHk35LDeGW1QhcLNI07jUHReW4Q5UCMBxAy0evrvibERDHUuerMzySJLyzF8Zuk/H6WIj5sS7OiF0KaFprb6I5/9AkG2AHlIwrToIVO3ciFNcf5RDVHKmJ8NBwTNWu5eS7iP6KQUrODB3StXy4CKifCi7OmljgNmytfyoCTgfgzLlPay44iAOjbvUbyLZtIHHvjvP/2lf31yjbuRWxOKHb4DHzUVkzYzKnH4KMbXnYuzrS7ZyKZUdA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kdamond_split_regions() uses a function-level static variable to
remember the previous iteration's region count.  This is shared across
all kdamond threads, so one kdamond's region count leaks into another's
splitting decision.  Move the variable into struct damon_ctx so each
kdamond tracks its own state.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 include/linux/damon.h | 2 ++
 mm/damon/core.c       | 5 ++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 438fe6f3eab4..85fe33ce7be4 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -803,6 +803,8 @@ struct damon_ctx {
 	struct completion kdamond_started;
 	/* for scheme quotas prioritization */
 	unsigned long *regions_score_histogram;
+	/* for kdamond_split_regions() heuristic */
+	unsigned int last_nr_regions;
 
 	/* lists of &struct damon_call_control */
 	struct list_head call_controls;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6c1f738e265c..50e8bdeb70dd 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2722,7 +2722,6 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	unsigned int nr_regions = 0;
-	static unsigned int last_nr_regions;
 	int nr_subregions = 2;
 
 	damon_for_each_target(t, ctx)
@@ -2732,14 +2731,14 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
 		return;
 
 	/* Maybe the middle of the region has different access frequency */
-	if (last_nr_regions == nr_regions &&
+	if (ctx->last_nr_regions == nr_regions &&
 			nr_regions < ctx->attrs.max_nr_regions / 3)
 		nr_subregions = 3;
 
 	damon_for_each_target(t, ctx)
 		damon_split_regions_of(t, nr_subregions, ctx->min_region_sz);
 
-	last_nr_regions = nr_regions;
+	ctx->last_nr_regions = nr_regions;
 }
 
 /*
-- 
2.34.1


