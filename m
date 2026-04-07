Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A39CBFB5178
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 01:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD3B56B0092; Mon,  6 Apr 2026 21:05:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98316B0093; Mon,  6 Apr 2026 21:05:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9CF26B0095; Mon,  6 Apr 2026 21:05:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9909F6B0092
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 21:05:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5076B598F7
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:43 +0000 (UTC)
X-FDA: 84629967366.24.271EFDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8B8C68000E
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L7yb0Cqh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775523941; a=rsa-sha256;
	cv=none;
	b=Q5ZnZGCbW2fydTytT7F8mHK0fEJyrQr3knXgvTBJcYvLKLKKTiirEk6B9RVlE+CAMwcxqQ
	Uc0q3gfvPYRIq4RVOMpTZehVYEhhK/QvIp/V0G6FH0v+a8NGVQDj2OZ3j5LgARO0pExqzM
	/gbhCHjz3X+34hk3RezNE5LzCt5matk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L7yb0Cqh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775523941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xWElpx9BPXj0+wsjNjdn9RNmFXx5C/9gNfThdascLeU=;
	b=mUtDLsmFj3p7CEIJrci7DqzcwhxPYz0fA+wMNyfIolT6LaTA0L94Bm7saV6wh1TNVg2ucd
	ja9C1+uPVeNZIjJ5sqaBmEqhH1/BYsqqDHt9nfLVxwz/v14+evyhPwvKyUwYJBa3OLuQAp
	NDiPAFXcL6yEZ2T1HWtrU3X4U+KChZU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F7924453A;
	Tue,  7 Apr 2026 01:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8ABC2BCAF;
	Tue,  7 Apr 2026 01:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775523940;
	bh=zHTyjXw4y+b0yGyHvR7VlEA/Pe9whFzT7niQ8ge5IZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7yb0CqhTUvm6fdsVbjosf2laMLDVXZ+GXF3roEyy1atQDLruOFhgwXoQcIQYG4iU
	 u1w7FyOk/11obccmkI5MuHXUGxgSgkYudXogh/r0U1okDZdkeQ34d+mrllztFyk7K+
	 mwCNvPQ++cc48LkWawrLW+/TDC7sEgufZMnsYM2ZzMR73aIeLjXUC+2P5Vey6/PN3N
	 YudrR6buqFOU3mtlekY10Il+GOyO0A//fA7QuMsGEbs97/s0nk9jqb4kvYJqom/UGD
	 1TnodkhJrmZjaoyLoczFwmWqouHV06DtzEfX+N9e/vyPdsfEsxuBmpuQNnre1aNJ+h
	 AHW5A/rzIUIeg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 01/10] mm/damon/core: handle <min_region_sz remaining quota as empty
Date: Mon,  6 Apr 2026 18:05:23 -0700
Message-ID: <20260407010536.83603-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407010536.83603-1-sj@kernel.org>
References: <20260407010536.83603-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8B8C68000E
X-Stat-Signature: xzgoffp3cgyoqu9yjq7wwxcd15jnyb7r
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775523941-228010
X-HE-Meta: U2FsdGVkX1+/syFfxZxBRTAtOaFWhczw/z61m3A9lFP4t7hHzkI78G9ez3/g5BgmD1GYy4xCGjHTCqUbMhrRkZTjBDl1oE13FxeP0Y1zlO7ARfQETELk/MeFou6w7AxuOedXOIoRwzKrYfd40zKEK8hdXVsAelkvuwuOmCGi4SSb3hWoJkedKNkMHqrDwX7/IhYyaLfvypZUOc/tE1j9yoyyYg8TtI8fN7/ioQtR62HzdB5q3uL3nwIgGjeGVAaqDbO5fLM1+1b8n+BSlHT+ipdM1iBunr5RS9dfJ/8Qx8L7Qot/qP5OLIXgdT/SAAhfX5A2x+bniycxxiiDkWikzFEBS4qLbM0dogAYpg8tE6XAVCJd3guEbXAnVDJ1oCItzA+eyEAgIZfkaF03q+t5+6KpRIUlyE6BKC0ILjpsuDD2u4inKLWGwRRNqI5KfpxAuvR/RmpqKHXr+6Hu8OAusTUB5h4sntpYO9hVg+S24eLBgpPk60JuyAl9NMXvOQ3IV2Ip7ra8FvsK19QhYYKGEIiITPzrLlb1I0hqE6b/Audpxi1LWp4PVEhV9UE9B7iQZysd4ND/K3ji3SdEVTcnbJNyRq4wI+LBkEAn9MMGpd74BZG8Ha7N3pUuKuk35zUkblWpr3tHuRjAZ6U2gdoqRGO03NhzUgl95rClc+X+PgTqhPf6Frs3UdkxK9kXOJtJH20YXXaI03eVYTMPLorENjpYF50AUOHAKwCAOw3B7dJd4dqRDIWM3vgJg6EoiBSiHg38J9KxcqtWaaQTsVFomMLG9eN9MaeIQxStaRUrA1FRJCvuL7AxkUb1lIKy0RdK3GtXH20psXCs3iXWLkiDIum2e1bgNPKjgfIRQiAOx9zOXSFusPdG8tYfC3JCNRs/GOV6j5Ifx7P81MUE7o0YAU/zELdCiALKD6etIkRO3LkCUeqA3x9BGr3K+8TuPJAuI06kLC15NM6q2F1PRTz
 mx28Kz8B
 TErTKLuZkdyapdx/6iUrqWHbGOqxHwovZA5nKGKo+3oKrltnaM8PJZL3Nbu6R2Dn8JWLqT86XvEQjK2peXhrNaDRI9eSJODe1EKey+5MqMelTeTqbI8eOPtTlpoyKWtexErryDD5wOH5FS5S9hd5Zg0D+bzOCmhZ2QJJvMOUSOw81vLS0ceMWB0UqxwpV6zG+TJ5oWg5KPlHtxs+ae3qJxp5oSZ/MN8T8obpCV4/FHZ8uprjMIlU9Ko3QZpKyKOHtbqY3vQkiyqgHdZifqmj3TFOsNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Less than min_region_sz remaining quota effectively means the quota is
fully charged.  In other words, no remaining quota.  This is because
DAMOS actions are applied in the region granularity, and each region
should have min_region_sz or larger size.  However the existing fully
charged quota check, which is also used for setting charge_target_from
and charge_addr_from of the quota, is not aware of the case.  For the
reason, charge_target_from and charge_addr_from of the quota will not be
updated in the case.  This can result in DAMOS action being applied more
frequently to a specific area of the memory.

The case is unreal because quota charging is also made in the region
granularity.  It could be changed in future, though.  Actually, the
following commit will make the change, by allowing users to set
arbitrary quota charging ratio for action-failed regions.  To be
prepared for the change, update the fully charged quota checks to treat
having less than min_region_sz remaining quota as fully charged.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e680716972506..2a2f767d1a46e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2042,6 +2042,14 @@ static void damos_walk_cancel(struct damon_ctx *ctx)
 	mutex_unlock(&ctx->walk_control_lock);
 }
 
+static bool damos_quota_is_full(struct damos_quota *quota,
+		unsigned long min_region_sz)
+{
+	if (!damos_quota_is_set(quota))
+		return false;
+	return quota->charged_sz + min_region_sz > quota->esz;
+}
+
 static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
@@ -2099,8 +2107,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
 		quota->charged_sz += sz;
-		if (damos_quota_is_set(quota) &&
-				quota->charged_sz >= quota->esz) {
+		if (damos_quota_is_full(quota, c->min_region_sz)) {
 			quota->charge_target_from = t;
 			quota->charge_addr_from = r->ar.end + 1;
 		}
@@ -2128,8 +2135,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 			continue;
 
 		/* Check the quota */
-		if (damos_quota_is_set(quota) &&
-				quota->charged_sz >= quota->esz)
+		if (damos_quota_is_full(quota, c->min_region_sz))
 			continue;
 
 		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
@@ -2455,8 +2461,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	if (!time_in_range_open(jiffies, quota->charged_from,
 				quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
-		if (damos_quota_is_set(quota) &&
-				quota->charged_sz >= quota->esz)
+		if (damos_quota_is_full(quota, c->min_region_sz))
 			s->stat.qt_exceeds++;
 		quota->total_charged_sz += quota->charged_sz;
 		quota->charged_from = jiffies;
-- 
2.47.3

