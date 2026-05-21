Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 929E2CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57FF86B0099; Wed, 20 May 2026 23:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2476B009D; Wed, 20 May 2026 23:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B736B009B; Wed, 20 May 2026 23:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8BB6B0098
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:54:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DDA511C1584
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:04 +0000 (UTC)
X-FDA: 84790058808.22.61DE619
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4BE4D16000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AnJrB7cT;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779335643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ITBL4yRv8OcoOU4P8OrL5kgNMtEVib2v8kU4r8mcDLE=;
	b=RKAFzRksEiKrdy6ocrQNciE3j5R+IDhdYol1AZkvvNrPGNdSR7ScsHHj2mRPxxN/Bmh7hx
	Tb+BpWntHnJYaVYfshKAlPCrgPtI07Hznw+kjZ/NiKdxK/iiflg7cQ3D8P42NpLE05iApY
	PLExKxpNPw6oTsBYqeREFEEgA0TtzPI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AnJrB7cT;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779335643; a=rsa-sha256;
	cv=none;
	b=hf5AQB3DLmDyM487hpPi9Aj6vg2oSv99BVCdXkjZF6jbfrWWR88UjD+m5lZyVKj6ITgNwX
	l3kSTlkwjuLIhWDOpJe017kkzgc+3qACwzZV8aLPqtoy9GPWhoO1Nxten3ykb50QdQiisX
	MiD/9Tc+m3t9sfXss3DAPjQI9PAjMBg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8983F42DC6;
	Thu, 21 May 2026 03:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407141F00A3C;
	Thu, 21 May 2026 03:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779335642;
	bh=ITBL4yRv8OcoOU4P8OrL5kgNMtEVib2v8kU4r8mcDLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AnJrB7cT4v3dYGSTNMSiwj11LmzPl3hj4+zec1b/QKOlZmz6Jbv18DBi2cq4Z8vIu
	 QSSFsb3zfslf6R2teLc+/GMdrw7Ehs1pXQDfeMo9sm7mi31Eex0LsHseyjm0UuIkUZ
	 /eCjIagNJjvgnHVGkQGZ7+XAYlIcDgLQ9ARyoxBvhEYBKbYv3Nq3UFIOp7pYrMDNaz
	 BG7V4mztpawULh0xTOyvpyPv+VXNoEEeTAdQ4ufCSL9/zvxGNyGJy9u3PJzzpaXnYP
	 vVh1CJeEHjNiPvikfAABfjIMvl5xQ89kJG258ePEvNra2GGFkYVhqaSQcLovHhOe0e
	 aESjE1abkRpmw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 07/14] mm/damon/core: hide damon_destroy_region()
Date: Wed, 20 May 2026 20:53:41 -0700
Message-ID: <20260521035349.87565-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521035349.87565-1-sj@kernel.org>
References: <20260521035349.87565-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p1f7ndw7mzsr3487jgzyt4k7yypu7yyg
X-Rspamd-Queue-Id: 4BE4D16000B
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779335643-827855
X-HE-Meta: U2FsdGVkX1/bwsKYhbufJ1gKReP1xKeAyD6dfwDoGd5e+JVZZ/N4ziUpI856m2tNZjPlM6lorZLnFCgjl5NykKWeenDNv//i6QKlKxk8Colcu3mOTSsOhN3TJYPuMsix0PNq1c7brr12UhQwg+hMjTUSM9WU1WGgtxmZMtSRrZRTdMEfiiWOYj2naUmwKTjZrNH+zeX/1RphxyoLPDCozorGNJRlAOMPcSUmRAgFbBr6wUgfn3U6BLMQbZIkLvof4bPFRKCFyRIWbd6zgNZaxCORaoFzFNbX2Nk0CFe7NTV8QnTzHkHgMCWrCs/rD8B2fPuLsWF+vyt8eU/bPpl24xZ2lFDpsV6uwOUO1Gzk0oV8xG1HLRun42UCDZlSOiLP7Wcsqmw8dDhpmCRKtkHcv8pQXzNxB0Wls2zlMp69FKJP0+8BX9G6eGmoIDJXhB5smIpZh8/gCm2izAaFJa+dMiblV2gFfw/mSIOH3RCoTcyn/ftbRxmubJxmJ+2LFb7Yaru7moR1zXsuOI6WbCOCq7NkGOps0XhYmH2yg+wSLyINCR26dn47dP9jgnAMBzASqTqzxQtxQweQ5o4JOSJWENZ5Ls4qlyPIg+GWqKR4mXVvwGM4KSV37qeU5hNUNYO9jcZVqBHeoe9PCaTVPEBDXoFfiHwgo5R9Vwp7ixRHIk6BWp6l09JKu6GhzylciIhNktWfLr3w+jFFQg9lKM48ySJNZY7hznQaApH4OR54MVQzjX63GmBGNX/3LK42gsrh6jjfCwicNPSCCXzfFxqCUS3bSUaPi57nNZ0ZIj+DkHiBGyt1qqMINidLRwGD9q+q31KVJsgPT3RPPJbU8BXjX8nRFfmnyvTcRdVa4jmKxOeZqHztUFOdrFw+RfwDjqIYw+dJJezQj3odnmMSw9yOeo8EQ5xIoEDx+AZLEFZ52GWZltTV7lmiY+o30C6b3iRlWHCv3CQoCOHoxvmHNXz
 ChDeA5hd
 tRx/08ZfqjFtohu8CNonnWOt7HRlEa8eivehIgXRYs6Fx/Jzgrg5z0sXlxpGyK4OziQmoR7yqYIZihiU4+Dn2mKCd1b0d3HFcXsXn29gStNiulWofrKX8qlDCsBNyv1o7wkcv/fw6O7Dq2hjfNYLjgsjD/PqOvr94qqDwnMPCGNFPx7ApviixJ2urC6T/QDjSviKpMSlzKAvoYXBxZCaDts3v5jppVDSMQf6ldIkEfCvb/J96SKidu7RG5eHT1oMT9YlIgNEL2YAAMbTPuG9BQQS8KA==
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
index 3acca7deb1693..638ee65f88dcb 100644
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

