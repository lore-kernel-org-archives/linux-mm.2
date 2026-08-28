Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DC90C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 13:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4CD6B0096; Fri, 28 Aug 2026 09:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076146B0098; Fri, 28 Aug 2026 09:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECDA36B0099; Fri, 28 Aug 2026 09:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA54D6B0096
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:46:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 518C11203CA
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:46:41 +0000 (UTC)
X-FDA: 85150803402.07.9B1C3E4
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf16.hostedemail.com (Postfix) with ESMTP id B3C57180008
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:46:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="PyJeei b";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787924799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nQrVV3KHaCazWFUYZXrNswbqv+h44byMvxeCDxp4JpA=;
	b=GraC1qdyG5Vl2q8wGtDqL/SbBoxpAppoDuS10sxmecsby0MbTmzJklG8c80umxDpeMcrQ6
	XS+1AD4YWlRzQUHVJb07TfNgjyEFSxiGYqZgi9hDYqpzeSiJlVA9TqDrWQK8BLYWWtC9N6
	6X+tx1lQPjTtk3BenaYtrSnoJrTc2G8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787924799;
	b=Xx9Cm5EmLgYL1XdINi2aKYryi+xHLjKz7mGQwXpYSoFigtUh95vK7vZxLZUx8qxClReTHW
	8wuhy6gM0Re7hp+MUBKt7i0f0qkPZ18/LxpkDwety3h+VNEWd0hZZ61ZHazWCClqyP+uTL
	nFS/NKjvUWZbCJ1/J5IPh0QoDnb/tb0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="PyJeei b";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=nQrVV3KHaCazWFUYZXrNswbqv+h44byMvxeCDxp4JpA=; b=PyJeei
	blAy2nprQ6IN8qEa87zXIN0nK2Eqq/oKUaRUx7D+RBs1PVvPN8RkO/vUg1nLLg4+dPfd16y1HaGCe
	DiF6PV40n3/aUHMOAQ/JqMVITDOmpJhICcf5PUZM/VjfOGGRuVCVXhLSIdXJPUxo7bUFqhoLyWapS
	vf75N5xdIiD8z/90t2OSpIhP8N72KmNW3qZk6hPqc1gaud4iG1SMaBaMUIICnaJoE6qqYBWQOVI2p
	neyOefzQUwgsSvGvkt9rREwPIIC4v6U4p6ZFLTFa3EU6ZnBkv+kCVWYDrLcTgAxyTQgeZOJgeTmEs
	0rcighijt0+LV3H1ZhBOXd9IwGTA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wzwuY-00000008zmT-0pBE;
	Fri, 28 Aug 2026 13:46:26 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@surriel.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: [PATCH] mm/memcontrol: extract stock drain predicates into helpers
Date: Fri, 28 Aug 2026 09:46:20 -0400
Message-ID: <881654a39036c55ef90c9ec864d4ea9cab0a2821.1787890328.git.riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1787890328.git.riel@surriel.com>
References: <cover.1787890328.git.riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B3C57180008
X-Stat-Signature: amxgga7jfmp6qi9z1pn8kha6a8d95ckr
X-Rspam-User: 
X-HE-Tag: 1787924799-802747
X-HE-Meta: U2FsdGVkX18DA0Qa7Sf6T553YxqHwrSpYMYjfJ7kR9EkobRqFZDKtJ2OqkXucKghM9keZmNmogELeGh4pgUCO2F4Anm5IAgZz/QT/Vd7+MCoJc3QYpSQMTiDSytLxTrxqDJRfI5/TGBmTs7jT9q5yP1S+Hs/VniOYbIgSbbTZCGpPQxShPL+PKN5dW4XneCw/6NXwB6CmcugxAKbmrrUIEZORiZw+fzwf6nBaON2a5vT7z5p00b1DBThj0FWsosnQh4iJISYN2qsfCdQ6a3zKOoGhg+8TTr9AlbXmIzs4Ok2cEQRDm4azlt9IdAGnFFNwyIwpGTWfeIFioAP2ul12uJhbtx+EfLD17VxaphFzvcqqDZMkOpNLxzI0LItOPqhAEyL/SSc0poVXoUw3PQ3dtWjUyEww2O/lDUOsWvGYxuatXrUVS62diMS49nTz4U+j/PEMcUTCRp9Xzy4nKSqvle9qXkuWWO6BvduKuz7r0FjDjDtLEIE0DOObU1aBoYZMWsxFNeDl/m3DGZrkdsk/37rEDCKgJWKp0oJ+H9j49VSzxJIU50PAGXo7kFIa2ssmeJCe/PI3ATH8r0Zj12o7s3e2JhxdXESkb3qwkGGIFN2OTV8eBR5OCSu18xIzkcJPJvntGpsPVk7JwrCacM+n8qPe7FCIKOOOTBva9dN0jk/dURm/jZCKa1MS6JPe6n4lCD6+UCj9NPcGSBa+SpXwt5iTFhsyt1wMz4yDiO+IyXl8hCwhlVKHQe+fNG3FjjHwifbCJEeJvTUXsEq6kxrwTRYM7r2/+fn9eqdFbPhKmMxxvdYoqWxkiT5fS4sytUcGt9dBwKIYF+yAiZ7Ul09QTf5fzrTPiFZWJi/kw6svvGkPQaz0wyErXWFa2HISk1rMbL1xROY7fste5Yp8Wv4rE3En021myuUTR5HpsB9nah95WdP6NwvTbVC/NJMD4QOZmXl4MLrtbDXwdcQQ81
 c3WXM5VV
 HWdYBZP3ux844nPoz29s74ME4lQOqoW7W3kt71cGlrL88tWntr0VSWNYyV59NaT2bHBh6+KgMPDhMhWTcajHzETo81mCfIdiLRapnDjIr+fcAjcZg+ekHk0Y1o0gdXjrtZdhOOElAjR6R65vvo0ChD2VAbiJ/Fdxj0BMi1ILY3jLs92drEnKBF6RDLzl5+tQE58mJANh9zGHU1AxA9f0kNiDupOGC4v1dkfe5U41nV2GO0nk6vlXzwYtFU9Z+TCa9fNO33pmdAVlTKPJ3F7xD7H+zi+aoqgJFARu6Fk4ZDcEJ4gPxMSJABAovc7LHmP9/7f1ieLdl66SpV+HsVT9qJYIWSnksAJtbd5RU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Wrap the FLUSHING check plus is_memcg_drain_needed() /
obj_stock_flush_required() and the test_and_set into
memcg_stock_should_drain() and obj_stock_should_drain().

No functional change.

Cc: stable@vger.kernel.org
Assisted-by: Hermes:muse-spark-1.2
Signed-off-by: Rik van Riel <riel@surriel.com>

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..a660ea0f820b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2306,6 +2306,30 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
 	return flush;
 }
 
+static bool memcg_stock_should_drain(struct memcg_stock_pcp *stock,
+				       struct mem_cgroup *root_memcg)
+{
+	if (test_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
+		return false;
+	if (!is_memcg_drain_needed(stock, root_memcg))
+		return false;
+	if (test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
+		return false;
+	return true;
+}
+
+static bool obj_stock_should_drain(struct obj_stock_pcp *stock,
+				  struct mem_cgroup *root_memcg)
+{
+	if (test_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
+		return false;
+	if (!obj_stock_flush_required(stock, root_memcg))
+		return false;
+	if (test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
+		return false;
+	return true;
+}
+
 static void schedule_drain_work(int cpu, struct work_struct *work)
 {
 	/*
@@ -2342,20 +2366,14 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 		struct memcg_stock_pcp *memcg_st = &per_cpu(memcg_stock, cpu);
 		struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
 
-		if (!test_bit(FLUSHING_CACHED_CHARGE, &memcg_st->flags) &&
-		    is_memcg_drain_needed(memcg_st, root_memcg) &&
-		    !test_and_set_bit(FLUSHING_CACHED_CHARGE,
-				      &memcg_st->flags)) {
+		if (memcg_stock_should_drain(memcg_st, root_memcg)) {
 			if (cpu == curcpu)
 				drain_local_memcg_stock(&memcg_st->work);
 			else
 				schedule_drain_work(cpu, &memcg_st->work);
 		}
 
-		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
-		    obj_stock_flush_required(obj_st, root_memcg) &&
-		    !test_and_set_bit(FLUSHING_CACHED_CHARGE,
-				      &obj_st->flags)) {
+		if (obj_stock_should_drain(obj_st, root_memcg)) {
 			if (cpu == curcpu)
 				drain_local_obj_stock(&obj_st->work);
 			else

