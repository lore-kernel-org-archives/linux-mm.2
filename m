Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10A6E109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A7296B0110; Sat, 21 Mar 2026 14:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528526B010E; Sat, 21 Mar 2026 14:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B196B010F; Sat, 21 Mar 2026 14:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 199FC6B010C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:13:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A91468C034
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:55 +0000 (UTC)
X-FDA: 84570868830.10.4E655F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1CA794000A
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A+dtzIni;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+mnpUBcaxOl4e+JfY2hQqiI4L2byVL7kdeMcp/zbY5s=;
	b=XnYCmM80YPtR6/4PTL4CZwwCnu99uOmGQq24ICM/Gl5wyrN/zu55E9AW0RxNe6oNKZPRrH
	zDU9Lsi/HW3sDbSYmnSsUyY1Z3655TC7kImAJI5YbWyZMHPL+DngGkhEgfnj6ECacLmpDj
	HQ/R0j16CVErBM+NUKgufaygMkcY9KI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116834; a=rsa-sha256;
	cv=none;
	b=02zLaB4yyxdO2B4h6nqQqD7AwcdvfoXfzIImicK67tWZEfn1JauFeno4J421lezlFuN6ZQ
	qM75gydhOkBW/3llKtbDRlf5bs+wZXBKElTvEWSKPwEt7vA/KgVKad7s/xlRhBuiNBl14J
	qQJLwbMAIEytURP03SKzdP7YhhCvlZI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A+dtzIni;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F94D60123;
	Sat, 21 Mar 2026 18:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1867AC2BCB2;
	Sat, 21 Mar 2026 18:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774116833;
	bh=In9pNSVI8OEhXXcMpw7pEozpwRJ9LmKQ0qx3IoCdr7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+dtzIniz737VuBV3Q4xy+WjlaM+VX1njXxLuhhyT/HZjtxoReCzvmOvKSGoh9BqM
	 x9OnbfmEMiLjExZia/7q8I/tiEdrsqUzYG3GxRd4ufNQsVPkuGTtlQ2T8DX9ue44R2
	 hCmDAxymFLHvdo6REd+Nd5mg0Sp8jbcL/0nwFaDkBkneSluFQDbNAkFP2/t08z/500
	 5IyBflUpaXg0QFX6Fxj5nGRpf+be31Hj0Cr4wCsGeU/7KGTKUaG7S0BhBRMTd2wqcu
	 I9GmOQz0ciOQVsQOYGG1d6ZXGXuxEctEMCOyN4kHfK3+Dn8ROqUAacJ5D0mxTuGqjl
	 jnqyKlHv91ZTA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Sat, 21 Mar 2026 11:13:31 -0700
Message-ID: <20260321181343.93971-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321181343.93971-1-sj@kernel.org>
References: <20260321181343.93971-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: y3ipho9ydyjxte5wbxurd9uqsucxfxh5
X-Rspamd-Queue-Id: 1CA794000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1774116833-341029
X-HE-Meta: U2FsdGVkX1/IpPbyD5yKLw4SwjQN+CAxm2F8CGldJKLSOSDRqam/q18KpgVUAWI3iuUQVoJc2O5jSmKxOMohSsZvfrFdPrJ+nVMHWFGrvARu7Mv+NZrqQPxA2CwHysW/W/UWkS/uTgNlKvTsJtYvWBC1vh/SrGcNuelV1eVO0mQw060RBQ3jnu/djfMWyQv+cblD16GCKMC1PrEnmh8GaM8La1WQ6WMsD5pLN3HmkmhjDHy4/1PjGS9qJiZC5+HgrqU9KF1jEOt6GZyz68r2kKHqYYhSJ6l7aBR2Y4Y7TBJ1sEbOyv9GnVHUNcKPZkxdEbqA5KbynrIH3jaZjBX/M4wtnUlbUjrjkqEIFf8o1wlyYsa+Z8uRYkxTZuIzotlRsMi2ZUSIsAL8EXoQjKQ9AKwNakaTlOqFRY+vAO2fmujfcjviF+hiG50dIlT0i5fqdByEIVerG8lxr+h4fuyjno41BfsUL4htg8ZOXtSeZtKctynRLvBhDeoMvxPv3x6KvBcr1KyGDnNeeIjiks8KBYwS6xrewh10kypjsLhyevKujBdR8yMZD57+i/BQ/+o3kKtN74TNt5c1wyndNER9/CNlS7waOwzT0g/6+86T1ogq6HmYoq59/REsh3TccT42q+3q5TOgsGcKGNicY5eMSP592PcfaOThUpsP9AFujYmUou4PCgiMPz+Man4x82PL2yFkW/K0DuEnnQEOOaVgl9QqJHqUvX4huXjJB435o6jLHID40aXMFo6/33LDJYcp5hodxGWu8ZVnJAo7L0WAjAZrA8gbSStvUqfs/k+fxYEuV57NCXmecniGoJcf9haBAWulMNwPlAOa3yS6zeuGf2X2wHJ5nYKPHSRkcSo4sJX3dllOn1H7OQAAWfyaomlApOelbqY4JOUk3c9rHx1nHnlBc+hUfTRMk+OzObCBwYnfhENSKj8QgSMLDQ8Z2h1/QRBgJpyfA3Bpcm+ThBB
 cNh7mCP0
 mo2NwuObgBcVrREOvlBTY2sfjRb+B0qPLAY+2FlHGulFlIYnEuHPtDUcFEdYhkzEIs1IuvAKlyTi0KXodh+bNLXnC4eNfQOtD6uVeknahS9sXEM28cpVNllkmktecu87Kh0TZ0y0GQETzg2rNp0bmoSLHiCNbWxivOSWoKMfVbyv3g+DvZq7Tab77YFBUWi3v17HmxJp1DubelFqDpXpjdlGXeQEr8HNvu7odWq8R9TlaW5Qtjelu+UMa2RL/qsR7t4WAD6jGAt/XYRGprErX4TWVbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON supports only start and stop of the execution.  When it is
stopped, its internal data that it self-trained goes away.  It will be
useful if the execution can be paused and resumed with the previous
self-trained data.

Introduce per-context API parameter, 'paused', for the purpose.  The
parameter can be set and unset while DAMON is running and paused, using
the online parameters commit helper functions (damon_commit_ctx() and
damon_call()).  Once 'paused' is set, the kdamond_fn() main loop does
only limited works with sampling interval sleep during the works.  The
limited works include the handling of the online parameters update, so
that users can unset the 'pause' and resume the execution when they
want.  It also keep checking DAMON stop conditions and handling of it,
so that DAMON can be stopped while paused if needed.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 mm/damon/core.c       | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d9a3babbafc16..ea1649a09395d 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -787,6 +787,7 @@ struct damon_attrs {
  * @ops:	Set of monitoring operations for given use cases.
  * @addr_unit:	Scale factor for core to ops address conversion.
  * @min_region_sz:	Minimum region size.
+ * @pause:	Pause kdamond main loop.
  * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
  * @schemes:		Head of schemes (&damos) list.
  */
@@ -838,6 +839,7 @@ struct damon_ctx {
 	struct damon_operations ops;
 	unsigned long addr_unit;
 	unsigned long min_region_sz;
+	bool pause;
 
 	struct list_head adaptive_targets;
 	struct list_head schemes;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index db6c67e52d2b8..ce010009ca136 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1349,6 +1349,7 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 		if (err)
 			return err;
 	}
+	dst->pause = src->pause;
 	dst->ops = src->ops;
 	dst->addr_unit = src->addr_unit;
 	dst->min_region_sz = src->min_region_sz;
@@ -3003,6 +3004,14 @@ static int kdamond_fn(void *data)
 		kdamond_call(ctx, false);
 		if (ctx->maybe_corrupted)
 			break;
+		while (ctx->pause) {
+			if (kdamond_need_stop(ctx))
+				goto done;
+			kdamond_usleep(ctx->attrs.sample_interval);
+			/* allow caller unset pause via damon_call() */
+			kdamond_call(ctx, false);
+			damos_walk_cancel(ctx);
+		}
 		if (!list_empty(&ctx->schemes))
 			kdamond_apply_schemes(ctx);
 		else
-- 
2.47.3

