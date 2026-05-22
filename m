Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B8B0CD5BB4
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C27456B00B0; Fri, 22 May 2026 11:40:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFF756B00B1; Fri, 22 May 2026 11:40:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A025E6B00B2; Fri, 22 May 2026 11:40:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9706B00B0
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:40:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5AC381C1859
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:39 +0000 (UTC)
X-FDA: 84795468198.10.1C89977
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id CF81C1C0013
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VlmjDOdw;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779464437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KBZztZ9CgAPOtUYZD/myJUluALlI19duYVzM65uSmUs=;
	b=oJhSMn6/tCJOE/6UQfs9QGEM+pwguyTZxrk/RcZztbC/Q4ZVZUoguIBGcQL3Gtav2XNYp0
	0BYWfBBVyQvvw886xzwYhw/72vrqB610D8Wsh5gaQxsIj17hxVFpvOrIjI14FaBWcZAuAb
	+btdfl6pEhF2QvB6pgQBaS50WsP1lts=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VlmjDOdw;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779464437; a=rsa-sha256;
	cv=none;
	b=xBqkTp+xH8wVPp9HH6d1f3Xjd4HBrGiHBoKJS8+BPf5B9VKrWVaNBNioqijYq82/7idWem
	dzejE3gV37T4t7sW3TbVnomEXWXqF3dUJyu3lT3NOMXqvQz/h+QETt2K9SB+iCnf3CNvjb
	dAXDT78safy32lLnw9HIaM6gOR35GjM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CE3760204;
	Fri, 22 May 2026 15:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12A21F00A3F;
	Fri, 22 May 2026 15:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779464437;
	bh=KBZztZ9CgAPOtUYZD/myJUluALlI19duYVzM65uSmUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlmjDOdwSp7wC35g8KCXMA+63FgKXTc9F1fK9JJrixLW50FOPpSszFDV7j5844uwk
	 Dx7FKCNcRnshJEe45tBADG+FazFFlmv6/zLvBVIe+L+7v3ogedQeAFgwQmePcPZADl
	 MojlSWmMSp5W2DWVstld9uOLrLxGyo44brGLKIytwkDI5iOb8JMtI7c1RhQZGeNeYr
	 n5AsGlAqVdOCb5c/WWqCc/seAc50WWMdK0X5p8B+FbKO5frEqcYh/FdLgnDrsZryaO
	 ripTniyHRPOjA7TlsjdULC/xNQ3dm0z+lnzZYuznzwlah05t7uxafToLO9ULKbuEPU
	 0W8rczn/OLSgw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/14] mm/damon/core: hide damon_destroy_region()
Date: Fri, 22 May 2026 08:40:18 -0700
Message-ID: <20260522154026.80546-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522154026.80546-1-sj@kernel.org>
References: <20260522154026.80546-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CF81C1C0013
X-Stat-Signature: 6759nru1r81nx5jg6zgy4cx7dbigcikk
X-HE-Tag: 1779464437-247398
X-HE-Meta: U2FsdGVkX1+lH7bsOZSGyopVl5u2F5jjvzMdqXoSjfu137pg/IOmjef5K/1pmKKNJBC77g3hO18qtth48oMZiXEbPDCnkmWGyw9RVChtWyh8CrvavbkKRS9uVXlHtOugWLRIwN+wzC4zusZ/QqnT8Mn7Zw3wmM8wzKJy+UhcrnkGfghfOWRaIr21/eX3/9SmHCV4+rYsNgfMJYc9M6YBTJV+0gh/9TYqAand5u63hXGCiSzB/Vyy2KD0/adC5N8TKZ8UPzm/QG2HK+/KHa1B3TqtJhOw+BGf+9LyWQEznRMsVLBL5CEQcPjr5TkMg500u9zk0nSLgd9qBXS4vLBmNv5AXOfz4foevNGsVqEiYHrSLjgOZxyUTJBqtNmS6z96n/QwgegDL7qviGoZkfwsi9Cmduexzdl3GhTH1etCPgt/XK17HDnrOePIcoYyXFbMnaqzSIYRVQfibnTjFTqVJ0QucNDCnbUnvMHAxJldu3Z02G3OoK3uIqpVoyI/6cvRi3uOsyfodTc8bszXVqV8wONM8MqdlI7jL++xuDcEVz5/NvEUh1QmDowPktieKkuPJWYbYDLuJt+GNgLUF+sNKH+/nak9T1TYpN9oaPNuBKEBBLrkhhBbH25+locUnefn6dIvhagKORrZCsOFKHYmwpg+tfdof1ubozvI2cvmB5r/DwTNOjA2hnDjg4moX+rg2zOiA/R5l5xN9nZ/lGQY7dsUwn2W9oN1EIHVhvBaDdxhs2dh9r75CqF5Wu5XmGtcfK9I/rvQmbiRpI09IIuuNlmSlYaVJfkyRBshIdgzpgZUNplC2N9ISyhQc3ZG9jEAGS7ufYU5rfX5ekIZpvtFsAXLFrqSnOGoAvJwe1IvdPQtK0ZpX6iw/LPOG/+1ZUBKIH4wQ+GuZH66/kvbSG365dEttkDBko+/T0TdRnzcsPVUVbiGEsRor66w0O1fTMzWDHZZhOMBYJdrQXFgO33
 YZnM8DhY
 Ht14m3vtbragF35vBJPodZsVjLTpvEt/S8F/P0QVvND/Mdfa/W/So2BShHtrViYwEDn8fiE4cvSy5FeQ4raVa8JFVtVTYY3u38dTWJRQ2cm+QmEDyYH8z46cTPfp1pCd0+B/DgM6OifwfZorMONChIVoWGHMenfjnVWATng/peyKJvHx+qK9NgzIEpdKWvAoE7yOi5aggHN2EYqc/vM8PLBnsxxaz7R7NIX3QnpPosq0QuGY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_destroy_region() is being used by only DAMON core, but exposed to
DAMON API callers.  Exposing something that is not really being used by
others will only increase the maintenance cost.  Hide it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 1 -
 mm/damon/core.c       | 3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 05682839e17ee..6f7edb3590ef9 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1013,7 +1013,6 @@ void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 
-void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
 void damon_update_region_access_rate(struct damon_region *r, bool accessed,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 53b4bdd27b39d..8a9202937781c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -291,7 +291,8 @@ static void damon_free_region(struct damon_region *r)
 	kmem_cache_free(damon_region_cache, r);
 }
 
-void damon_destroy_region(struct damon_region *r, struct damon_target *t)
+static void damon_destroy_region(struct damon_region *r,
+		struct damon_target *t)
 {
 	damon_del_region(r, t);
 	damon_free_region(r);
-- 
2.47.3

