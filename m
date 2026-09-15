Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B86DC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 075376B0096; Mon, 14 Sep 2026 22:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3F136B009B; Mon, 14 Sep 2026 22:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D996B0099; Mon, 14 Sep 2026 22:09:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D51F6B0093
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:09:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F10B31202E9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:41 +0000 (UTC)
X-FDA: 85214365362.07.BE484AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 684F320004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O2Iis2E4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789438180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WsrL2oFK9840WoIrM7QJPBsnHu9HVCMK1ZcOyqnJN44=;
	b=cQwFjWXuDgSVE7Yp60icYe4g3/M6LIJvqTXOBd5usSbg4IFkToLP8RZg8Oo8AX607c5CWp
	ZMy8IimR95bpVKEhs6j8ruOisBDapKgyK0ShN5iFrq3B1ymgE73iu62MCHWKEKEbylgTzA
	viHhzPCF3oirF1ajEcfo+/MEWGBJMHg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789438180;
	b=gAkx1K33CS/Gryr50jC/Vi1aBHDM4cl+2/aynPpZ7pAtVpTNF7sOKv2Vr/ASbw6UT8U2Mk
	+D6XkyYwr7hA3yQQaG+JDLWiJwxCSrLNU2AnRPmFFWnIkcBZ6B26szbytozv06dPr2X1aK
	p/rtW7Yo+OZbcq7npBjWaFwJHjmKcaM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O2Iis2E4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 588B643DE5;
	Tue, 15 Sep 2026 02:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1694D1F00898;
	Tue, 15 Sep 2026 02:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789438179;
	bh=WsrL2oFK9840WoIrM7QJPBsnHu9HVCMK1ZcOyqnJN44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O2Iis2E4n44X/NA0Xw0mz+iXnyBqdsP7cavlY1qEktz/DTa6Amkian8eyIW7/Ckto
	 dd4UPljolRKOfCDrCD8PC2JDDZisiJoD7n5XCx2MzBlxTHwlFokV+soFX3qHlONLba
	 lg5+LAxy/gsWjXmAF2BCIAuMuSTlWuvUgf9CFgVwJ3UZD7v91lEIbtqjSMIJ2PYaDX
	 dtx3fVllb8bdGaP1GZGx5WkKqQokCf9blWMCrrA0/BD6VuBXLwjyJY+wPHncTMc31e
	 OOf2pCd+xgo/XwR4AqSqw0aRIJJ5d1HXJV0bQOtDCbbVVzkMRX8H+tyiZ4TgGRjbDZ
	 8APcSekMueGPA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 3/8] mm/damon/ops-common: support hugepage_size damon filter matching
Date: Mon, 14 Sep 2026 19:09:22 -0700
Message-ID: <20260915020929.102953-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915020929.102953-1-sj@kernel.org>
References: <20260915020929.102953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 684F320004
X-Stat-Signature: bnqhtbpxji9iity873u311o34ejcf43s
X-HE-Tag: 1789438180-544641
X-HE-Meta: U2FsdGVkX18qIxI9r9nAB+RMUDtMS1L+jhkwTUmoJ++cmtNul5GoaOW0ceb7jZp+QuUlIPlxfXuUlfFf424jYxYNvAaPYbR/Jrv9sbjD99ETxVl3edrdaYCk4IW9L2nnlHDwf8GUMRZewKqtaE6enoDEYLBU6914z1m0nvpazBdjS1oHgPzHXepdA3peYnEZ7BOWFLPsP3OAel1LjQofBOUyi3EubRFacIYhf2SAwbBNfm6W7bYcqlY33IUGl7upB9w+BWjYlpbyOQemqnJ5fE74V5DiC5KG1usMwkpKIUDapKt87uCq1+BTmcVnZUgVhTpA9X4cY6MakOxziTtBRBzJGoIjcHz0aH+vNnFWyOYCailfQxsHsb/tuvT2Oeh+8+K72A7EaLvQXhiahPntdv70iOQDc0b+fN73cigSQ2H0mkc0kq3WjR7LryBusvV92lr45b4Fp7vJWIdz1SOItvv1Y1aHCAkvA+fGaFONOVoo5FXlTQWjXYsdAt0hT4mod42xp0jxPi3MprNIRU6K7KoDhP0JmaZfn5z1NVUTuYVn+ERbw5gI1dBAWsWYC73jsTnHXRfxO8iWJ5rdB/LdY3mMOG83g3/eGdZcBUER+CDRSib8tTKc2XfwYU7u79AG0mFPAsVYqE++eRVSRyzOzYkkYwx/AIVM71C0EbDb0cBnWvrKpyq23PvbWAVl+AEZ6MbeQmq0240hrvCvxo1MM/t0qT2QgA1+CFOzPfpj0Vy4Vgxp9hc5L0SYPkPw/fhmShATSnsjF4O0Kzxt0pdry+SgTSmbLoQsGRtIov2dAm9daC1L1LIHePPI1W9ua4JTAic8pkaVSkRI+pQU9NgwLZPmNEmpuyjoqZSnm5CXdzaMV+iGG8qnQUbAH56ErblOvuO8Pnw09fHVLG76SZZFP7zfabGxUNae2Nt1JzFkQ9/TMHTtOxrKtQMdMXQDWdRRfmvxI6nkXevR7h6tXA8
 tlHG1zw6
 l0S6xiv5MiZrYRSrct9L7oENB0qeKYEaZI7xbLrXsuQXGjbZspaJNkxmm36ZtBhLAD08F4YVE6zceCMo/3izA+n69JAHhrcTnTIta91DE5E3wUEHoAaSnofk40nnfbklCN2UQ4MNllTbGt4Z+MZA/PImr7CuA/Th6Jsz8IkWPKelaORX9bE92U8XTUy0kYE8zdu8WN/OsusHq35N3qMvxNfYTbgX8yxJ423il3eSXqIts068FwCcKCjzJ98xc+nR/Czto3B7Mp060CS5fFmzgf+s+Ww==
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

