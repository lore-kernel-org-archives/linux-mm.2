Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3483C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A3166B00A0; Mon, 14 Sep 2026 10:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3783F6B00A1; Mon, 14 Sep 2026 10:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 245746B00A3; Mon, 14 Sep 2026 10:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDE066B00A1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:45:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48A941C03DA
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:45:00 +0000 (UTC)
X-FDA: 85212639960.18.C037BA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7007440007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:44:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dsJJx57D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789397098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WsrL2oFK9840WoIrM7QJPBsnHu9HVCMK1ZcOyqnJN44=;
	b=NI3l6+SiC1qFdKhqyoLtGTAI7+IPhoiy2AM1pLmRGUE5YH66ivdl96doR22LJryPtZUZhZ
	k88Tb1VFybo0DWI6bI8/rfCOc5PwpSpJjpdWMu8kuy4ySdKv6YSRoZ5UZ8ZH8wcaXCLMj+
	Yj5uJRxxRNunRaE25DJlRbMNFZmYLYg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789397098;
	b=J4alKAkkumpepgYOWizIBlMlqnQsMEWYBcVKCyhdNNivkKCGjbpbRIc0fSaP+Rg4Wb5rBQ
	EzI5Zt9ut7UwM+aalTNqSQ1Lh/SSzbLacdtLmxJN+vdMe3e2ZJudHyLyhqf8MdTM0iOaHC
	hVVF85aRz9jHKNkOKLYp6sh/WCST5s0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dsJJx57D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DA3A43C63;
	Mon, 14 Sep 2026 14:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B55E1F0089B;
	Mon, 14 Sep 2026 14:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789397097;
	bh=WsrL2oFK9840WoIrM7QJPBsnHu9HVCMK1ZcOyqnJN44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsJJx57DbIA0yLwgZEFPsiVAQ9E/HPhEGkVn80+zXts6AqF9XSt9ICtAptmYkOQf3
	 o5yH7Sz+GUGGscu3j1x5Qtip0m3O4ZQNboofdw5bv0z2o53478bhvebVvaex/Wx2dt
	 kmTqN/UiyfwTm0kKGTJwa9ZQTShaUU6TGvuaYKs1RZbLM5yoU8ViUPY8gji6h9/eLs
	 y0AqkHIl7Pi9UV/7XkjCiZQKxz8ZnxnWXMF8tF3kY+426M/lov//9xhI+F34JJ3T0d
	 vFtnwR5f6ncU8wzSGtagMWEdtft4s17bSrCQKLt83QsyeRVRTtcjHo3nnelGUD2TYU
	 vemiadlmIVvPA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 3/8] mm/damon/ops-common: support hugepage_size damon filter matching
Date: Mon, 14 Sep 2026 07:44:40 -0700
Message-ID: <20260914144448.93732-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914144448.93732-1-sj@kernel.org>
References: <20260914144448.93732-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7007440007
X-Stat-Signature: b1a1ezrj7hj5sxhyae4sb7d9qfc98ugi
X-HE-Tag: 1789397098-5100
X-HE-Meta: U2FsdGVkX1+4+w/O79vSEFfplJmK1oyuCpcmqsiH3IDMHaUTycC1LvFCAF5/nEAFsBp4f9eugbTsa42MR8nUVvK1EOnRQXFK46kBmXkyDX1FpbZ0yUI1HPo8wCWChjy+HrVEYHWcN8qnTfgfIKZnZezRquk+bbvMxqsXJKAwgKEB1ujF4OdrJYw9lzsUerEBM1tzs7WaxXOndsE+S48oeaPkSweYrM56+f1gVTndRu3fT2xrEDQWIdiZ6WztmwmQQjFMA3Yl+qf6PoQUlNPIBXM1HLNKhknhP7a1X9DcLWT5o4APovZQRtBJ0LL4o0W4hF0Sq0pbrM0pB/5a6so4UyrTft6Rd1RxFOfRemhhJCbCX4BmSRo1ZwYGS/SSRHAb5OASHlQQnLo+MTKSIMZ1n/C/DsnEL152XHxX6SLc6wr770/mFE8qB0wd7uJ2gt2MP4W3mjQWOBAxsqfQg9Ck47lLc2A+Bt6+hORx0BH73HbBKNcztEplPvPsoskftbyEXc0F6XFHZrwDgKRsFF2gP39MI+/J0nZp9Do/QTbyEFyMeRd/T6rsCnd4arkCi5LymQmMgCOswplhysZAWXDPjbW3e29fKTD2vJ5sj1lPZpvx0R1VXg7FTyQBfHC3y3jaMyS6bxlHOWdSatWhqTHm9ZOYZhfbBcbWiybdPBiT+1VZ8egI0tomT8okBgaZ3C3BWZQNR0w+dfzjBbgC373VWN5UYFe2jp9NjCwmTuOPY8fWVoUb6hh3d4XgRLu1AGhYSEnWc9dzkA79qyqS4LmrpNQG8QsvfQE7s7ysZTiwin3w670/84tJI7MBQQZlRVCw3SdO0xzb6uJzr13dYwRQorjHnYKxNfGgaZLNKjhmEUNmGvNLlmCnYrlhwZaArKb9h6EWgeAYMRkLqM4jisUNphhOCmrgt0gBTvWSuzqSpMiL9SPpI77e/iY8ibjVisPNamq5gTXgHocvFZ1pEdo
 9cznXyO6
 rYwfxbcCEQVJUXVHFrS+Pvw707CKVvK8/Bxj4w8Zg2OxIzP+5+PMnIbC1d5teiv7d04Pfjmn8/CQbLbAxazNnmcsykmspEY+X7GYeRdTJBpg3BytiMwmGYxhUsEKcGVPKk28YqLqb1LxlYTN9bIvQFnw0PlSLTBqJSsH57SSmbvyFLESIwGpLUelA31YpruD7A5cOW0nnBmjPZjXnnK1JjFyyeZv7P2VincMuNpf7AYA37tq/qczozxiSJOOsqd4dTEJQwN3zb1yv0HmTIwLQwl9hew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update ops-common data attribute filter matching logic to support
hugepage_size filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/ops-common.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index c36cc39cd2c70..77366f42b3e5b 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -536,6 +536,7 @@ bool damon_ops_filter_match(struct damon_filter *filter, struct folio *folio)
 {
 	bool matched = false;
 	struct mem_cgroup *memcg;
+	size_t folio_sz;
 
 	switch (filter->type) {
 	case DAMON_FILTER_TYPE_ANON:
@@ -558,6 +559,15 @@ bool damon_ops_filter_match(struct damon_filter *filter, struct folio *folio)
 			matched = filter->memcg_id == mem_cgroup_id(memcg);
 		rcu_read_unlock();
 		break;
+	case DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		folio_sz = folio_size(folio);
+		matched = filter->range_min <= folio_sz &&
+			folio_sz <= filter->range_max;
+		break;
 	default:
 		break;
 	}
-- 
2.47.3

