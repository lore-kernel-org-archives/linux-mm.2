Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8808606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 20:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LTAwnfME
Received: by kanga.kvack.org (Postfix)
	id A9C796B05B9; Sun,  8 Nov 2026 15:15:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4E116B05BA; Sun,  8 Nov 2026 15:15:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914D76B05BB; Sun,  8 Nov 2026 15:15:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DDD7B6B05B9
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:15:11 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E7B940500
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:15:11 +0000 (UTC)
X-FDA: 85413056022.25.802A14C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C56DB180003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:15:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LTAwnfME;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794168909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dECklwOd4xlNmvN3OSaJ4I8wcJsGZw3Lw9lBlak0+Zw=;
	b=gKcXdk02BTcDwJrS2Igmi0/lLcS34zXFQb1sTZoD/2i1BwbXf546NNV8fOWKGMIED9iP6C
	4sChXyBQT+PxlIHghW+hkdtScJWMyoXqoN4cKP0hkfo+qOz8OXTciJ2H3zQFwBzDt40J0n
	zOjq5viaQ7c5JCQykIWsKjElh9+erNk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LTAwnfME;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794168909;
	b=YMrsWpknN/SXBx7MXVqmqjWvexevtowMEsqca6Ef4eRuKR0uBKDssShZHpme4QLYZ7Zmhd
	gVGA6+YbCn52haxGYJsIkRUXnPbwyfrfPx0CiAnXai4o+eX1bkPgFgSVyZYjmXeWALolGp
	aOJOyC6k/35RF+ZdczRQLL1utGT9zBw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 62F2061CB4;
	Sun,  8 Nov 2026 20:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14481F0089F;
	Sun,  8 Nov 2026 20:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794168909;
	bh=dECklwOd4xlNmvN3OSaJ4I8wcJsGZw3Lw9lBlak0+Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LTAwnfMEsvSFbLjwqnFYcCAs4S0/lDhCFRuaXuAZCX56sSlXQ89h4tUvh7dpLlZ1m
	 krBONDu+XOF2umWiJZ+Vsovl47kKYjM5fH7bUuSum0TIKyFgvKQB+H0KnUP9nT1NJ6
	 iT5k79I8qztVPOM2PTxKxn7b5wTA/t+ZNZyh453TJaFCat1RSacv/YMtsiIK7qyP7P
	 hMwGD1wd+7sWDTLGO51y3CTTiKoysKmRnQTPHtTLPXU2o1d1El2ZcYDl7aTmZXokJF
	 5smheUGWZrticD8L0UndQcKTeqTwTbD3hMDibg3NCrNawRXxMRWx3H6vgVPdR5HTi7
	 FutAhU7JzBr3Q==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.6.y 3/3] mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Sun,  8 Nov 2026 12:14:55 -0800
Message-ID: <20261108201456.116824-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108201456.116824-1-sj@kernel.org>
References: <20261108201456.116824-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C56DB180003
X-Stat-Signature: 4b837ktrjokjetbq6ik3irhuobsqkg6r
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794168909-516866
X-HE-Meta: U2FsdGVkX1/p2olBq2JJLNyCGOtf9+onSKGrixf0uk+dezNfFb5c8F/uL61Hoj4dwvNQA0J/4WhokLC1McJ3oUf5wM457EZmWK6i/tkqr08FIlTKOaIGg5vk98vc7M+qn62scytLCENdel5mSrGNA4Wu4qXRhPjPbCJWwzsUWL6b0jTOzBqY5a0uS7/aErcFoz3hiSbAdtsfz2kqcbyMW+NSTJ1lfGif9rhJdlu9Pti9Sv0FT6UlQwao7wy6tGOX1AL1epc7QHa5tnAKfJV4kUogJAXVyuRLmOLTpdTy+nIiOSXP4vSsqT+8eZFXal4OeoIz1wWaGHlO3afBmwMxGoH/lctrBa7TGaSIe61MnLmgBpFSvqJ2Oje7JyV/h8t+LN61SNOsdMl38mWUjq7boWfsrghs2w0sO8ZyHbZFozDg6Jsfj5O1onf4w36WK32Vcgf83arQemO/OvHCQJly6gxb3dlWL/xvjJMP/bGBPUcB7arYfPWd7I/gdmPONmS/jyjb3vZDaH1OmIk5x3XmZCeL2Grt3z25ONg54X6SJuMnBupaePjuL9/J0H2EPxaRaSid6/jfSTLGXd2aI3fh4DmZuYwU40yYt8rFETyonW+iBZRTsuwHpQ2p9BjZhbBuqt4YNfJgqKtwYMyBYmQMQCT5qWgaW3lyP4PWEhu1xjUXeDOMHKK7C6KlzJga9GciDwG8OhEKD9UYjK03tiaQdr9YWonyBccVoKSehUVGTzNMAleKT/i2Xw0sVNvZvFdY+znjfBUKXS3Zlk89ClSG31F7bWcrbjNV3nqMqX6bDS6aRkYPe8NkMSTtE0LjJhzH0rcWK7zUVMOsw6c0EQd41o1VG4+xlALC+ATVwUpq0yED4Iw4Jdqp6zo6KKKtjXTIZjV8p/cm4kJz37XfJEcI7wkM+eZr6JfaPXSPOuFBjdYlWAflcYNFYHA5SdH8OMhoYreHb6CwMAujLuwl9k5
 5fR0aFkO
 noLto8RZUBggWKteKP3Tk/CcLB3hrwDd6An4kpCsCYLstXJeZS6Ek8oEA19TQLyKWhJBaZvxA61fyDdl71h2vzeCn4lPKeLjvbER/QJ2VAlGlvjX6pBN3c5/hNYm1WFLUrZ4TzFGTUU2STxl7M8WBkRVZ5goiC0jDzuzkAMSFX0wxv7bljM4x2ILI+KqdjkJlDIzpktt4TQ6G4jCHHM4XgGejPk8sj846BDAiHhqK8jISHTLx/DQ9Zqmtc5d8QvQiDdJBz85pPQEYuJxvApOLfQSdFltNN32IZU/mOm5oou3FB+qD5DqHNl3qLOjOUbPcCulrGzRsLKNQjz5+Tvp9muGqGljzSrgnOwyUvISvUoUxyxx/wLq5JEB1jeuVZadijudodha/HWNL3EOQ6/k4qP+HIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damos_quota->charge_{target,addr}_from saves the target and region the
scheme's quota limit is reached.  damos_skip_charged_region() skips the
target and regions before the point.  The target that was assigned to
charge_target_from could be dynamically removed from the context by the
runtime parameters update (aka commit) feature.  In this case,
damos_skip_charged_region() cannot find if the point is passed or not,
so the scheme is effectively disabled.

Similarly, the user could also remove all the regions of the target
using the runtime parameters update feature.  It would be uncommon to do
that, but it is a supported feature.  Because the skip pointer detection
logic (damos_skip_charged_region()) works for each region of targets,
this result in the logic is entirely skipped and the scheme is
effectively disabled again.

The user impact is that the DAMOS scheme could suddenly stop working
under certain uses of the runtime parameters update feature.  It could
surprise users. No crash or leak happens though.  Users could also
simply work around by re-installing the scheme.

Catch the corner cases in damos_adjust_quota() and reset the pointers.

Link: https://lore.kernel.org/20261020023958.108276-1-sj@kernel.org
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-cd0c55fc-0cc8-45d8-9637-3334811c49b8
Cc: <stable@vger.kernel.org> # 5.19.x
(cherry picked from commit 5695abc4e742b947f586bfb6a080a80ad9957e5d)
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 99e934a6d1ce9..61d45d40fc1d3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1088,6 +1088,27 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 	quota->esz = esz;
 }
 
+
+static void damos_fix_stale_charge_pointers(struct damon_ctx *c,
+		struct damos *s)
+{
+	struct damos_quota *quota;
+	struct damon_target *t;
+
+	quota = &s->quota;
+	if (!quota->charge_target_from)
+		return;
+	damon_for_each_target(t, c) {
+		if (t == quota->charge_target_from) {
+			if (damon_nr_regions(t) > 0)
+				return;
+			break;
+		}
+	}
+	quota->charge_target_from = NULL;
+	quota->charge_addr_from = 0;
+}
+
 static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 {
 	struct damos_quota *quota = &s->quota;
@@ -1115,6 +1136,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		damos_set_effective_quota(quota);
 	}
 
+	damos_fix_stale_charge_pointers(c, s);
+
 	if (!c->ops.get_scheme_score)
 		return;
 
-- 
2.47.3

