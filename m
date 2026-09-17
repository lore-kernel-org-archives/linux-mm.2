Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F5A1C982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E85C76B0095; Thu, 17 Sep 2026 10:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F506B009B; Thu, 17 Sep 2026 10:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFE146B0098; Thu, 17 Sep 2026 10:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99EB86B0098
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:22:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D3B5120392
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:22 +0000 (UTC)
X-FDA: 85223469324.22.84AE664
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9A6DE40010
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S1hpqEWp;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789654940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WNxPb3XuWgcy0/vqXG1EDhrYQFj1MOLwj/rJkugHFUA=;
	b=KxHg+fnui702rviMW9BOdIkKjVjutXsNNO95xC2tsXNZCH85W/zAXSWFM0cJYMQYFrBbqw
	4xAAa78A/tievVFvw5+Yojvz0ADJACiTPJJy5BKj9qUR5fKgOkUsp1BfzGDyVAOLyPwuHA
	FC2Iuv0bRTU+XFqSKZuEFPT4HmMcx9o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789654940;
	b=79OzvjvmTYXOSHh+fw7stcrDaRfURd4TInheDTBC0oZFwodxwlGHpnr315ijaU/8l2GL1d
	KNDtei3QQK5SN+TCiCgIMFdbgYp8zW+BH9eG3r0QBNQvfwwY/WFgtWEZaCZ98234tp7I0y
	ieAHNu34V2DE6PZ8E5H16fUkDrJGnnE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S1hpqEWp;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 30BF360210;
	Thu, 17 Sep 2026 14:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B693E1F00893;
	Thu, 17 Sep 2026 14:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789654939;
	bh=WNxPb3XuWgcy0/vqXG1EDhrYQFj1MOLwj/rJkugHFUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1hpqEWpn31KrLILxhWCBo/lIaLA/WzcB+GWEsWclJ9eaByXVTLpKXFT79jsgU5Vy
	 vj+P4VWwlw1yYKdttn0iOBhl47oTAediQNbl5XUIxvn6kcCm4omfJpKLui6JnluBmq
	 zuX7tX2Y8+odZgbyYkyOW2klETk7FhwZo8NbUznZoTLpWGmKAJyHpoh7urajPDp9X8
	 H4jREz1CUgFL49RuCCfPhJFVxw5Dj3ExhIy10ccs3NXECT2QkgCpNUR5atvq2C4G0k
	 WCHfA1BjXVwXg8Um5F97DSGMmRktGhos4QiSk5djObLvCdyA10vL6+ZeNr6Rg2MLcu
	 an3F3bitdNnqg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/10] mm/damon/core: set damon_ctx->walk_control_obsolete in damon_new_ctx()
Date: Thu, 17 Sep 2026 07:22:02 -0700
Message-ID: <20260917142210.90829-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917142210.90829-1-sj@kernel.org>
References: <20260917142210.90829-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7f9gi4oizwoihijuajmjiikz6j1qfn17
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A6DE40010
X-Rspamd-Server: rspam03
X-HE-Tag: 1789654940-51148
X-HE-Meta: U2FsdGVkX1+J1cMCtHo5bHwa6NlhGjoAv74dgNBBMeOGzR2qInZKGfv6ni8ibWBRBCVZLjOeJcc33L8N0nE5lsY36sLtbOaSLwZnZdfDZbwv5uEAPCX9pW9D2VNojIZc7Z7DVNdA66XAmD85CvDprd8oebtz9O2IT089Xz3JAQElXktbve9BV4xgj1QHa1zvTDesPcfwszDyh9jUKxO8Ext7hPrwzHfqdHa1D9d4zYto4QKO0WeQOVC8trv/5La3vdqzQyc1EcBiMJQ3bpNUB6oGMX6LY/I+eQ+J6bGYAjXs+wehUlpxg2BZ3JK4RQ84OwrpqkdcPiQK0ISxOsLBkZqoxR0LQ6BDLr5hhRvtxsTi6Xi7vA2nACfRgLJp1r32gjMuhcPH41Fmpo/eL99XP2wf3+kqgvqFQkDApklfgILrsOxLvL1XclbXr0hcJqy4L61aJOb1/VdZsV+Y4RdM6sK6m+buZsGsHO0MZq8yKlG/GvO2AT1BbG/Xw7+KDsMuBRIdjjG474ul8buBfnk8sMN/1we1L3hgnMJ2E2DtDDIyWv5gNtbMgC4ud8w/QzeFs/rv+p+pHeP06lAoPcyN8UZ4f06sRu10Fi+e74XTPfEsbffZ3WAuH38QOpqCZ+mhV9gcPTy5q994wlS7wfj9a+y+etYTCJsnL6SF7YoFi9GwSE5qbTENRxNCKD7UqwyuWWAnyN6RkvodYipWxUFCK32ge0WQ1oJXnXhIp103Zgeeu8bZdXG5MFLszedeaHHPvla9Ga26gAzaXqZzkqMgwwMAGoqZwJOF8dL+9wP6k3YxtfutadZnixz6HdGgXybWEJS1a109Kt/4F6+ooQ5uxXEGO1eAeMN+sGrcy5gC4L+uD6/RY3Z95M8e2CV3zzxssP5dUkjqOHmSkkTg93HX6cGjWxCedSkqleeHCZ3MsEROfX9dYhPAHsGLFAxzx8e6MopexjmvzJ1XdYXqeEP
 QOL7EWZ5
 OL9JePCK7O/xF81kbfgijmiSZFt3XrJ93+w6fDMOj5/9Xm7nV7RbnF9HaevF9l95vVPtm3ilQFyqga9AFmTle0CYURlK48APc2aYN+vloQOs3cbmxyBY2UC4F5aD/c0HVgIVnhy8drzYQ7x/7cpSUpZXP4Jf899AgwwmNr/3wRv4PszFZ4o2x8XUaXFcIk0JLxnk0N3NCyAFl+Ro0hw4/CvcRRztffw5t7TcPX56mP/UevZYb6PywaHwey5x8/MyNAHlDska/YUTbH4202WSlO9M3vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_walk() should be called for a damon_ctx context that has
successfully started at least once.  That's because
damon_ctx->walk_control_obsolete is initialized when kdamond starts.  If
the rule is violated, an indefinite wait can happen.  There is no
existing violation of the rule.

damon_call() had a similar rule, and it turned out keeping the rule is
not easy for damon_call()'s case.  Hence, commit 8023b5f47e09
("mm/damon/core: set ctx->call_controls_obsolete in damon_new_ctx()")
added the initialization in damon_new_ctx() and removed the rule.

Keeping the rule for damos_walk() is relatively easier.  But having
slightly different rules for similar functions could be confusing.
Sashiko, for example, repeatedly asked questions about this.  Do the
initialization of walk_control_obsolete in damon_new_ctx() for
consistency.

[1] https://lore.kernel.org/20260915011614.102342-1-sj@kernel.org

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index bc41ac7ecca43..c63b09d4a2d0d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -939,6 +939,7 @@ struct damon_ctx *damon_new_ctx(void)
 	INIT_LIST_HEAD(&ctx->schemes);
 
 	ctx->call_controls_obsolete = true;
+	ctx->walk_control_obsolete = true;
 	prandom_seed_state(&ctx->rnd_state, get_random_u64());
 
 	return ctx;
@@ -2308,10 +2309,6 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
  * passed at least one &damos->apply_interval_us, kdamond marks the request as
  * completed so that damos_walk() can wakeup and return.
  *
- * Note that this function should be called only after damon_start() with the
- * @ctx has succeeded.  Otherwise, this function could fall into an indefinite
- * wait.
- *
  * Return: 0 on success, negative error code otherwise.
  */
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
-- 
2.47.3

