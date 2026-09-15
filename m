Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA14AC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 411196B0095; Tue, 15 Sep 2026 10:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39C066B009B; Tue, 15 Sep 2026 10:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5F86B0095; Tue, 15 Sep 2026 10:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E91886B0099
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:34:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04D95160426
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:34:09 +0000 (UTC)
X-FDA: 85216241460.29.EE21C7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 658DE140010
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:34:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EVNd/IgA";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789482848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKHC2ohfBCTfxJBQb1w+ZA1oqxl4Tap4PnGbWDCoJ/8=;
	b=U+b+AGvGNqviwdut5ofichS6nr6ANdllrrzQBBj0YANEzdiNDbjkW1UPmSowks9nH4c2CW
	rQFmullxmRGPbctN76q1bed9W0z/4Tf4pUx7e6GHr75dftL0LWJy9TLIlq7EFko2qlnDPU
	7tnF4mvp3kwWAlmj2alHv44nNLzX4XQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EVNd/IgA";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789482848;
	b=BhWxYGcNA+blSSQMS4SqHosxovDlkzThMeB/VM6lLOSqB2qUDtGdhL5fnwmauPEiGbx7PL
	3+PuwXf3vzFJ6hhd8eB05DH9XCClFIY2SyTb6x3TP0Wv8flaaSe8A3FTwaIBQuV53XRpzc
	1eC8N2komaBHawyaB1epg4LJT0OwAKs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E30F43DED;
	Tue, 15 Sep 2026 14:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6751F000FF;
	Tue, 15 Sep 2026 14:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482847;
	bh=WKHC2ohfBCTfxJBQb1w+ZA1oqxl4Tap4PnGbWDCoJ/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EVNd/IgAH+l+uixqDvEWYj8LtwMLeSbPVrdgNwWKZMuT4Tk+9YyMOrBXL6Rz1OtND
	 36rL5RN1yTU5iX28D2orhL3+gdVQWQhq8HiYx+8t0piE5FyMyUf0YkWAaNhpksHjN0
	 LNmsMCxKrATaXZnPRigAIhirlUwcw7PVoWncpFRGzwbH9m23RWcNHExGQPNb0SWURy
	 DkvraZ2bsZcFrYD5vM69lBdnhd3Mrpw90haJTPOa+0UfXy64yM21oQXc/W7y+F7R6V
	 2JuZR+FfbStiaMgwd+Bb6gLyWUV6Wg+oXnhXmM9sH9txXb48LHpMj8hXUCiuMS8+KH
	 7tJYBqO2di30Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/8] mm/damon/api: introduce DAMON_FILTER_TYPE_HUGEPAGE_SIZE
Date: Tue, 15 Sep 2026 07:33:50 -0700
Message-ID: <20260915143359.91472-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915143359.91472-1-sj@kernel.org>
References: <20260915143359.91472-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 658DE140010
X-Stat-Signature: uuqip7a87t9ajsrsja3qzu6q1g5qs9s8
X-Rspam-User: 
X-HE-Tag: 1789482848-455656
X-HE-Meta: U2FsdGVkX1/2fk9IUpFZst/9NtDkBv37ZKaC5Hq4srsFENJ0HBsKny7FPYGdeHhkgC9trNLMNxboNnZFc8xzQMYYiT5u0HBJOZrwRZIwzoJvmIJKQwO1wsC3g7S9ctpWa8Yy7fYzwsI7VIa+hPrvl9U7ir1mfYoxShpZ0DbOlaptywO9lSE4nsu6Te1b1P65ixTygHLsFFYQO4SkL4fT0WGQ2sVfKQj5zOgySf7J8+TtJVyZss88f9H4f8FRu0v+iZB28lPy0dmA94nnxp0zLtJuaR0E9eqFzk4t3hFQSXVZv5STMx6OlaOpIUab8LCogzxHa9Yo45AB3mi6ipWBZr5MX3B6V8YBKx0xcyFB6eW3ga7B8g6iYdZgd7EtMTALl+yyRLsjQqRvIRQGdpv0NZBRMu8SsUVPmlF2Vi1YPvmiGQ4uczjBFZLZJkHrNxbYzMemzFNpWW/I0hD/v2D3ECwLrLpqBlVx9mn4nApkavcgIeM3YwwbWGR3qG/UQ+WlAPFfUnS2R/woTZwDkZYh1/KFJF8EeCIKJco/dxCBJqetz0F8/abyuvQWYV0DLyyTBQKlSPof90HR3TdBx3+oN5ihC9S/JCX2TPl9LkEhx5ecMiteYhmj7/MS/fmNf/qpwGtdWnsWbb7hRO0dQmBg71Q7+EMTGML1s0JTVBftYg+5RgY2KcQJuJGLm87uNjyAmMBLjRkzAY9p1KuG65Pr6JDaMIrNxuUUTTEeN5PVQTGqeEG90DXzDVlJY3IAXqsq4Zn0/meqLcGqQmpQPLXTRRnz/bg5hlMR5TJ0gS5oK0e+IvfTE9cVkh7Tlp/zdwmr4zvbUv1Amkn9YES08QSPp51XGgsYnRUTLTl9cBpC7i1awQLYnCnWOgT+MQhd2eaBeYSWp/j6vfWHFHXd/LbJyn6L/9Gl0pLkTr6R4RkF/LaBwJXyBZtwOcTrdwxaI6RieFfeG7lIYMuDmmxEv5d
 YewLgNeI
 1SOc38+YshCxovaj/89NIa9jMxih6o7K8Nrsjt9RjguzhINO3kwQB55hvQS9/eGJ4Ok0QVRO3u1h9GN1iRkSszHEyHLKYbkl7rPGwLO2ORUUyESp74JQYl9uaJXAUa1knZItZgBPEi4SYmzQf2iws+C9gfdprkbTlxS2umDjVAt6wPumHGthc/2f64sBVW5d2SDMWlbqymfjORptMsZnRHo01H501FxxDFWQF4ibCqSNPkwdmO1xU9KtUKrZ3hys0vWOV9e6iZEzjB7wQ3E2w0GdHcP1QTkyziQQfCtRwpiNF8S/FAQ8qtO9wds8GqJ+FB1jjm3zUorIBpx2QHIXvhu0OJuAjyXGzTUN6NxycG1Z3sgE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new data attribute probe filter type, hugepage_size.  It
will work for memory that is backed by a hugepage of a given size range.
Add a new damon_filter_type enum DAMON_FILTER_TYPE_HUGEPAGE_SIZE to
identify the type.  Add two new fields in the damon_filter struct for
saving the size range.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4be7d1df8e71f..bbb190b474015 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -783,12 +783,14 @@ struct damon_prep {
  * @DAMON_FILTER_TYPE_MEMCG:		Specific memcg's pages.
  * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
  * @DAMON_FILTER_TYPE_PGIDLE_SET:	Pgidle is set.
+ * @DAMON_FILTER_TYPE_HUGEPAGE_SIZE:	Page is part of a hugepage.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
 	DAMON_FILTER_TYPE_MEMCG,
 	DAMON_FILTER_TYPE_PGIDLE_UNSET,
 	DAMON_FILTER_TYPE_PGIDLE_SET,
+	DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
 };
 
 /**
@@ -798,6 +800,8 @@ enum damon_filter_type {
  * @matching:	Whether this filter is for the type-matching ones.
  * @allow:	Whether the @type-@matching ones should pass this filter.
  * @memcg_id:	Memcg id of the question if @type is DAMON_FILTER_MEMCG.
+ * @range_min:	Minimum value of range arguments.
+ * @range_max:	Maximum value of range arguments.
  */
 struct damon_filter {
 	enum damon_filter_type type;
@@ -805,6 +809,10 @@ struct damon_filter {
 	bool allow;
 	union {
 		u64 memcg_id;
+		struct {
+			unsigned long range_min;
+			unsigned long range_max;
+		};
 	};
 /* private: */
 	/* Siblings list. */
-- 
2.47.3

