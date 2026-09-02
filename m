Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F424C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447EC6B0095; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39B416B008C; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C88C6B0095; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F20186B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:47:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7750A160697
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:57 +0000 (UTC)
X-FDA: 85167740994.02.0A33AEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D335540002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oEm8c7hM;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788328075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yo9QjrgTWYiC6GWBBDQBEXVvC3vOUMrhoR21RBzshVk=;
	b=txSp/ycDFDTTQsBxsp4lGCs2GwA45FtIRerjJuaF48W/P+acpOGBNqw5X7XFAOr9mawugK
	+MtDhAIeftly1LAWnt2OLKhb4PnGaucj+M/90UOKjaBcD/jaUs/ayPYG/R4QvTaXFmOV2R
	ed7N5NJvPyL9sDFscMPd5Yz2tb+cbX4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788328075;
	b=07wRrNl+yB32fERotxAunN1ojNbzNKI7NJbDiLVXFD5vrEIXpulitBO0gQ6NzvVApCQheq
	Tss62q4cPIhKftTJwebEu8skhs+D6qiHtppbbeJW8Mvo6uh1tSOd3TodY+9EXel1HcCDGx
	RDrdt9K52CftjZItWUpDONZ7kzhCZFc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oEm8c7hM;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDDF943EB7;
	Wed,  2 Sep 2026 05:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF29C1F00A3A;
	Wed,  2 Sep 2026 05:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328074;
	bh=Yo9QjrgTWYiC6GWBBDQBEXVvC3vOUMrhoR21RBzshVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oEm8c7hMoRPz9m9rjweoXDQRDxabJ+dkCpT+zUrhyK1lIccNeAKHx7wjLe/W6stDq
	 VOqEAbtXSKBwR0VKJqrbw+7wMnUlqNhixI9b3tTnhhEqGH/uDvhy/i8P0vBK0OUxty
	 Hy66xld6YZShV+HPP0SWUsX5GYnHUdRCEcVf8zTiaDKJSk2q3tMDXjGUTEKWVMxH7A
	 miszvuJ/FaQbOsnd860+/o2ej7TMeuMDv436icsfXQ6PglfqnGw0h9gZMi2fLYyoRA
	 DORXNCz849FE1La8Drz8IvJh0aA5ZLLnvEORvITEcl+LgLXF/FhJyM5Eikys+pL1Fb
	 0mIuOv38Q8P2Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/12] mm/damon/core: use damon_nr_samples_per_aggr() for max merge threshold
Date: Tue,  1 Sep 2026 22:47:34 -0700
Message-ID: <20260902054747.99370-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902054747.99370-1-sj@kernel.org>
References: <20260902054747.99370-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D335540002
X-Stat-Signature: j6okqt1zkireda4ap3m3b1esy5fsm64s
X-HE-Tag: 1788328075-930159
X-HE-Meta: U2FsdGVkX1+alIDu87JorA/+cGhBTNow7jgFUFUCKZUCSEoiYGwmmT83SLodFaLabvt5+G9DM6mBoGpFJp3kwZA8i9+6rjcTvgKdiR2OTWpp0dotNXFwNuMj6Lx6rzfTuGViqkyQ+QSDZMof5ko71eFZcZibzPQniTybyeJ16Kk3DwnCnaZVn0jmZO+HmILHil2DNBaFoeorPKuwE2jjwYTzYxrJYYsHpgR+WgS0mgMRWDCj+vOFZ/dXgcnlEtMAv/h1veCGKYiBTyCqzKYpYqzBhrsMOfxs/L+U+n0EaNQwNgwVPqgHXTFejfRkYRu5c2/SnRB5TfinOyFlTf3ZWNiALpAgq0VVUHAvj/YTeEYp9ckaRSA5D3Zirs8jVPc5qU+7gBgwyzvlUAu+ej8msr5sg8GcCkC0CvJOydxiZ8CBfBkaCJRSun3jFROrAEQCjPUy8GaAqEK9YLW+kOEXdRbazYuikqjEJyFwlhbYLCRbofQHW02D/zBhjuUG2N5Lg0X/XWbfHjQW10mBekgAzH9xbMGBXO9/NE1aixx4/lijEoKiHReM9pDY23hn8gzYxZwNylHbt+HkNr1IrxUuWqjut34bcP3OXVqsI0Q8mi3zrD1Jp268BAqLj7uEepHh1G+6HnPuAqAYf7NjsGB9s/KVs74mrl1sJS0sMfbwa5BTPZXvzc7yix9srmv86C88LTKaBjhdAWHjQ5x9fLjWboWnI3UssQji3jB2CdO3yvnKrP2TIfID9lFJiv8wn0IQP8+IFYwRJq3+TBUM2hrIdByJLH7c8JCa6Lhn0E3F6oU9OeUojfJfOWnwZBN4X6Q8uyweJGGICxvokumsmpm9Mk9mt86isllfsY7qJHdR36HK8npulWjGI0YZDGGoHc1unC4qQcb+AjJ1Y0ajWd94cV8IVxqsjW5Y2Ov8rKzp41BFybpIXOug1OxKLW7abYnbSCvFyLloCPM/M4hZ1iA
 rjFzbMtb
 YxBgFkG8mBp/Km4S1KSwWo5gMMulG4ziGOZfNO0NoWQY85rJa8rCH5tiSTM6Ywkges/PWEJmmKU0uCFnwKn1m0JlLNwvm44Y52RcPT/Jz7LnZ50N+9WBMWmTXBWxU/snUvolwnAvtVH52ltksgoERXPhfDEfcjp0RN0FDDk8fTqaGoIeglLPZjMU3p42eRm5qsrXvf77kAe7b5dR/6OvaK7XvbzPwMoAwlxD4tC6dHpcVYk7BhihbZoT6bfsrpWoFCIpDMugBMLMTfJP3FHHtR6zPIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kdamond_merge_regions() open-codes max region merge threshold
calculation.  What it does is fundamentally the same as
damon_nr_samples_per_aggr() but missing a few corner cases.  The
unhandled corner cases should be rare and make only a negligible level
of monitoring results degradation.  But having the inconsistency could
increase future maintenance burden.  Use the dedicated function.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f748acd6bbd5b..846da6df5b552 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3509,8 +3509,7 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 	unsigned int max_thres;
 	bool count_age = true;
 
-	max_thres = c->attrs.aggr_interval /
-		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
+	max_thres = damon_nr_samples_per_aggr(&c->attrs);
 	while (true) {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
-- 
2.47.3

