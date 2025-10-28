Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC104CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FBCF80157; Tue, 28 Oct 2025 10:03:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ACF28013F; Tue, 28 Oct 2025 10:03:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39CBC80157; Tue, 28 Oct 2025 10:03:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 23E548013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:03:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF94288881
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:03:26 +0000 (UTC)
X-FDA: 84047690412.05.012A1FD
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id EC81A100024
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:03:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H7iclBlV;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kl2sza6IcUK9wJN5eVQSzKCSp8AzW1LJjYyxxBCgR78=;
	b=ADwAmwO0v1AMD5wt62N10swXXwvYaaENLE1a4N1dJa10puIDUpfgFS3BlJU09oex1vw8NA
	XNLr59Xnt0Twsu0+0fBkI/itgCw5Ph7Okma2F4eCfiDUsDfcmXRs7N8ou2Kzs0egJmb2AH
	OTMPOh8Pqy3ZXDpdOVVf/BR6Of5Sj1w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H7iclBlV;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660205; a=rsa-sha256;
	cv=none;
	b=L6TKRAtzCW1vYHWjQGEtJPqI35h7FdmMLvkyk0Gl+0eUsap3Iwugo1YKY38fgxK9b+WnhZ
	r7LRy7C7Le2wfm+CRnVbpw/C1H6T0TZ0MgjbwtSRwAhbw3YsFYvhEDq2XmW5OYW1RyM/2Z
	8gatcsMMkMgpAdW+6DEgTtzdums7+Kw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kl2sza6IcUK9wJN5eVQSzKCSp8AzW1LJjYyxxBCgR78=;
	b=H7iclBlVKKGyl5kABnOqTcFgYu4LyN2DakLdUh4eUBdDZZKIf7nXXfSrmelvGDHdZ/RE7R
	JiOTF3qla1+kXPKP7kNhzLw7lqeqAYyiS8DvVBp+Kkx3JJEd/2hF6rjGF95YeVK/Cv0NB8
	s6zT9kgDPlM9lfU1CZd/lJ9D8N0y+eA=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 11/26] mm: page_io: prevent memory cgroup release in page_io module
Date: Tue, 28 Oct 2025 21:58:24 +0800
Message-ID: <3076467321061767e16ca7abbaa33998bfee97cc.1761658310.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: bar1ujpki7hgs9h941rro7zpu491ujgx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EC81A100024
X-HE-Tag: 1761660204-444054
X-HE-Meta: U2FsdGVkX1/iL/YkuzyNw/Eu1vYWEe2n8y8oCvCdcGlJh1iXJu7nKkZFFEGsHUpbTP4BkNGHUebt16LEKApYELQ5AlMJbQoZKaiWzqkE+Qi5EZxGSZ1i7JkDcfBj2dUxUr8YrU7pbpU/NX2nSUiJm451VLWi1uyiwIGSGVPvkKJV7bcDcju+qoKyPfb6v3AKshv46n3w25aHLifzvTQnF7I0r6y8HLBW52c7GKL2hvonVP62wEuxnSF17ILfwhPIKNJ5rtp1/FBoBKpSjOZZk+MOqUoYrgxQ5wWlvlpPyta7d3fxqUN0w9WG9MKQnvFPLWsIrSELHJ0JLm9JRiQZpsOIrmSWdPaSeJHk4IPdMmaKgTQZy05rfh3iPMXufSDX09yPRo+ih3P8L8A1q7b6NxPC0k28sNA5Eu3RBPOA75sVvaAbHpLNZtsG4pwhlZJMb3PZMmagK2rUvQMLM1R6mu7ZFQmGmCAHYerZ8Rjmkk+g9e2hLvVL9uxYtpO+qLpUb8pwClJaODnCz1VlLxGKPNiHLfJvsMDxGrRUzER2ae5BXjuO6vVYxibi6VdfhGkV03SW+K6zW2YykdgCYJGobg6ts6PX7IK80l5sHTZHZZqkIoM5gmkcm1RNz2KCoE7c3Z2ew0NI6iCvYYb0FT4XG7cUwUbf/fuiCE/AvCkN/MjqXsTrCVyvUEqcDkrnkuD6Y1A/WUFGFd535h6deIh5JUnW1ZdzJdW4JFfK0mzlvmWP4f7KXM0Y3AJUxU8Y7cUvfUQ979fWMbpZLxVXZmFFeTY1Vxl0tvomnlrN/+5Ne5c/bd6I5je6p8AczPFfMwWwVnDU2gAYmlZ/uehrCcUdewoQleATdDCAtpoSkZHb/9C4NlbvvGupXLXjyOkBQy/fZ6QVSZt2ksaRGFxJ76zSDl3TNalXlf7ad77UeTBKPDS54uU5+5iQnNta4iRJOMGuegyHVVS/P4G74pZOz+x
 Go4anH4+
 CZMCWRVuYq/eGNk3+DA+CV1Gom8vlMG86YcN2CQzhfW9jldrj6JNk9LZhMxHeqV0CLkcd1QsGXBCUOXVueYDPxANdQwe43E/Jfyj0UGiMnre/poFytqd/2Bh9VLSChPHU2vHzoOy2kJiDG3DeE8Y7lDwBiKbCkA7H1AhNle/aX+uxSvB0rEBCqtV03BI0izbOY7cBNLHeMpy0juPYqySE6/T97tL40Eadae9+j+KfZsBEPFQpJ3DbJqZZkkCw1VsdPKqHTA7lkbYim10=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard
against the release of the memory cgroup in swap_writepage() and
bio_associate_blkg_from_page().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/page_io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 3c342db77ce38..ec7720762042c 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -276,10 +276,14 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 		count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
 		goto out_unlock;
 	}
+
+	rcu_read_lock();
 	if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
+		rcu_read_unlock();
 		folio_mark_dirty(folio);
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
+	rcu_read_unlock();
 
 	__swap_writepage(folio, swap_plug);
 	return 0;
@@ -307,11 +311,11 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 	struct cgroup_subsys_state *css;
 	struct mem_cgroup *memcg;
 
-	memcg = folio_memcg(folio);
-	if (!memcg)
+	if (!folio_memcg_charged(folio))
 		return;
 
 	rcu_read_lock();
+	memcg = folio_memcg(folio);
 	css = cgroup_e_css(memcg->css.cgroup, &io_cgrp_subsys);
 	bio_associate_blkg_from_css(bio, css);
 	rcu_read_unlock();
-- 
2.20.1


