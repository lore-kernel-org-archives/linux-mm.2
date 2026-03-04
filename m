Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 532A3EF8FF0
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 14:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497C46B0088; Wed,  4 Mar 2026 09:51:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4458C6B0089; Wed,  4 Mar 2026 09:51:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348006B008A; Wed,  4 Mar 2026 09:51:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 203756B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:51:45 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD1171B8273
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:51:44 +0000 (UTC)
X-FDA: 84508669728.26.463AF10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1F17E4000E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:51:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AcvONXz6;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772635903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zFqXSL8SHgH0wb2/oRDk4ZVQzYDlT7YR1qGjR28RvJE=;
	b=T0tkjnf1RH6PPAGfrMuRrnkN6coAPHUyDq7GSvhJJFZllw9epO3DHa1HC0jUuEr1u0Gk6c
	quYgBTTlm32IhH6vuXBXWDs3d+OyMqgfbtqgLnV6emYfBtsDpjGeIOciYJVH2KJ3YqgChA
	sY6CkhvsA9p1RyYFGNZ40OXIdX6/EiY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AcvONXz6;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772635903; a=rsa-sha256;
	cv=none;
	b=CJetxyhRiN5GUFBxBQWEuk1Tz0b76yLCYTnTrqkeeDaeT5slDRLLVdlheOsuCMnYu/W/od
	cbpra1CSm57td6QcdEsGOoRr8lHO3oiVFtj/kVcnlDte7/COaTx9aHl9IGITiR/6j0P7lm
	K4SKf/IU13QD4lB3K82YDjKPOh+b5oo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A067600AD;
	Wed,  4 Mar 2026 14:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE61FC19423;
	Wed,  4 Mar 2026 14:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772635902;
	bh=AXcGOV3rxB0t3xLwBtUstDgx4cx8kG184IK+T6OhDic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AcvONXz6T5whljb9Qjj+WgDoNq1cZjnLZS2qowLy0d71QtwIsMlIkiqZUzllY+Ql2
	 e3/shG0jjz6LnHB1A4NskTc5n7opsjWQEi3x5U1LStETOPymKX4Mx+OzR9njBKuqPA
	 cEQQkOtvo7YkFK8cIZdGN1wfWIOKVGSq8X5sgVLUqekkQHKLCiIQFg0yZEsOLYbekZ
	 IiGVDf/lsTPCFKbWI+lFm6+Vw0YgkpBNuBlrOKEscdr6XHH9wqF9tNeEyGUYIPgBra
	 Ow4r7YNnAewNV1aYTd7WBIthl0oRMjzsqPLNcPM8dPcaKiqSc+uIdHwxDyRDfMtuEu
	 9RDdAGyWBBhHA==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 02/10] mm/damon/core: allow quota goals set zero effective size quota
Date: Wed,  4 Mar 2026 06:51:39 -0800
Message-ID: <20260304145140.172293-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <abdb1acc-5f88-483f-af49-45276ab66ff0@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1F17E4000E
X-Stat-Signature: qytsgsb11nmwmaa6uza64stmx1pa43op
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772635902-231840
X-HE-Meta: U2FsdGVkX18Wwqvh9tpihUcCi/ZKRml6bptW+q617OkrRK7rfR+366tNpmqXJv1N8fSrKrsze6xxC0VgO0uDEEHWrLdRyN0N6FomAbFmxcIvb676Hjz9XhB8m1A6v4/mgb554zB3kbAXjRlQJLah+73XgDGdqfqrJhHgW+oNEJcpFZlJFfvBMBUNevAfXHR22dRJOW10sybSgtrS+ClCGzbD3oiXoKprH+Zrwvc4qx1XS8C+FEFMfv6Q8hkjx2zMD+Vk7ZeYVRXvL36jlWQP81yvfYcKJzAufewHSfGARnvpNb2Dkp8MqtCmeaIt9POfzmnzjP7qETf4MYUsdHdhMLcv17bcj7JeuDquTtvniKiWg4Zg1INU69NoprMrpVsHiCF1D8gUh5SjPTeLZisYC5BqEd4BahV2HJAOMCfruoNi+MWFMud958bJ1TMmjzAjTOvSK3T2JDxOXUbMKpK/TBNjzK9dlFovnGYcuTSgMeD6PcA9P59YU/2Tb8anWsOU5uRt1poFNQ6NYi7h4GqzKS+1xdSVWxEGgwOb47B73POR5btJ54X4PCL/RiVA2Wffut/FBEpl7zRgRnyd9eHW2fwuMZInu3CLTu7pOJHleY/SULAGva9sog8/DzloUjCTo3RBha3z61pqXDDC4lf3RiRjxuZCPZMaMI09EVxUAEoV3c9w7AnvRbOXKOmJuBLM2Cb/IOmA1+ImfIM4BPVEZz9Z2kd1TXzag46wB4CUZUIMSmC/c4FS2lF8usmPwlvv/n9i9spYHPgzQTMwoePa4UdmJ9Uyx5oMDRLF/8TPKe1+W7xVwsJZi8kjZAlambjAesVNf/UaV0oq7cj54x+EJO5FhwDfjPpbg6XHGz57+ISOIqgPjfF7KCiKDlnj0pMibakmt4OlGxG53D9n21DK+FrbXXxF/lU61bBKbqNkINMdRDQFDCEuKspWvNJG2fI0DPg9m4U5zpjoGNWyXel
 MumQs+it
 DdFbGnNtUlygkbrBu7VjpHcBIY7y73HWLA/4a9Vz7QLXekKR/T0DgB+0maJUQEoVC0du2GLSl+JMizZ0NlJUjhAIHeNeT9mnjUBd/2hIIAkYS+kTJpjP0I9hLOEZrtIzt4mAmMiN0ar/oEF45fxfGrLnPyV3yT7dhTjO340Ed+BoyVM8atsuSEi4DFHdc+Xky+Hm/yzDl2I7H93UWdMyqzJ/NzahGTHoIGAZa+YpK213QrVuJKgiHaZ2XdkMrjr7hgozae+UjWBgaIJuV/deTWcg3q3mBI0IuJbOm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 4 Mar 2026 13:18:16 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 3/4/2026 7:41 AM, SeongJae Park wrote:
> 
> I find the name of this function confusing. The function doesn't
> actually set anything. Maybe better damos_quota_is_set()
> > +/*
> > + * damos_quota_set() - Return if the given quota is actually set.
> > + * @quota:	The quota to check.
> > + *
> > + * Returns true if the quota is set, false otherwise.
> > + */
> > +static bool damos_quota_set(struct damos_quota *quota)
> > +{
> > +	return quota->esz || quota->sz || quota->ms ||
> > +		!damos_quota_goals_empty(quota);
> > +}
> > +

Thank you for the nice suggestion, I agree your points and like the suggested
name!

Andrew, if you pick this patch to mm-new for more reviews, could you please add
below attaching fixup together?


Thanks,
SJ

[...]
=== >8 ===
From 9599524cc5e5bbe8263c847b6f20f0aa919b3853 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Wed, 4 Mar 2026 06:46:55 -0800
Subject: [PATCH] mm/damon/core: rename damos_quota_set() to
 damos_quota_is_set()

damos_quota_set() can be confused as a sort of setter function.  Rename.

Suggested-by: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index d657b87dd99e8..c58430a4cd6ef 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1788,12 +1788,12 @@ static bool __damos_valid_target(struct damon_region *r, struct damos *s)
 }
 
 /*
- * damos_quota_set() - Return if the given quota is actually set.
+ * damos_quota_is_set() - Return if the given quota is actually set.
  * @quota:	The quota to check.
  *
  * Returns true if the quota is set, false otherwise.
  */
-static bool damos_quota_set(struct damos_quota *quota)
+static bool damos_quota_is_set(struct damos_quota *quota)
 {
 	return quota->esz || quota->sz || quota->ms ||
 		!damos_quota_goals_empty(quota);
@@ -1804,7 +1804,7 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
 {
 	bool ret = __damos_valid_target(r, s);
 
-	if (!ret || !damos_quota_set(&s->quota) || !c->ops.get_scheme_score)
+	if (!ret || !damos_quota_is_set(&s->quota) || !c->ops.get_scheme_score)
 		return ret;
 
 	return c->ops.get_scheme_score(c, r, s) >= s->quota.min_score;
@@ -2074,7 +2074,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 	}
 
 	if (c->ops.apply_scheme) {
-		if (damos_quota_set(quota) &&
+		if (damos_quota_is_set(quota) &&
 				quota->charged_sz + sz > quota->esz) {
 			sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
 					c->min_region_sz);
@@ -2094,7 +2094,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
 		quota->charged_sz += sz;
-		if (damos_quota_set(quota) &&
+		if (damos_quota_is_set(quota) &&
 				quota->charged_sz >= quota->esz) {
 			quota->charge_target_from = t;
 			quota->charge_addr_from = r->ar.end + 1;
@@ -2123,7 +2123,8 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 			continue;
 
 		/* Check the quota */
-		if (damos_quota_set(quota) && quota->charged_sz >= quota->esz)
+		if (damos_quota_is_set(quota) &&
+				quota->charged_sz >= quota->esz)
 			continue;
 
 		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
@@ -2408,7 +2409,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	/* New charge window starts */
 	if (time_after_eq(jiffies, quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
-		if (damos_quota_set(quota) && quota->charged_sz >= quota->esz)
+		if (damos_quota_is_set(quota) &&
+				quota->charged_sz >= quota->esz)
 			s->stat.qt_exceeds++;
 		quota->total_charged_sz += quota->charged_sz;
 		quota->charged_from = jiffies;
-- 
2.47.3


