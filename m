Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 818F7606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 17:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a10+1FQX
Received: by kanga.kvack.org (Postfix)
	id 83F456B05B7; Tue, 17 Nov 2026 12:48:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816DA6B05B8; Tue, 17 Nov 2026 12:48:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 709096B05B9; Tue, 17 Nov 2026 12:48:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 46B0F6B05B7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:48:45 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2C63A053E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:48:44 +0000 (UTC)
X-FDA: 85445346168.08.CDF9558
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 208B9160010
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:48:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=a10+1FQX;
	spf=pass (imf08.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794937723;
	b=F1Dm2B/5e+3dq7JJSc6dqooPczg5XeXdXxMO3Yvl51S0M6PzIJo0zGtSBd0lHRw+APj3gi
	tCkv+lKvQvGj284JjPlnwMGLp2h4iCbvN851o7AtFkVVGb7ROlPMAGt6rq9JwY6ok/+hPa
	T58JeE4PXFKxp8FhRK1M8JCLWAjJ4aw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=a10+1FQX;
	spf=pass (imf08.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794937723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rA3XzT8tXt6/+XP+fsrdKUtHJCQ7Tr9McEClsG+Hib4=;
	b=CrS+LpGT828utn68rUmGAZquaUYkBfoRCddLHs5VD/WDPk2nRJBaYBVR0pejSE+6PeMBeI
	pGddyTC6nUilsQ76QhBdj2IZP9v5fO0oSv4bwopEyM7VBdGY0+zHmFpEuWXo4Wg0AVp6Zt
	xlBzVQDt43hOBmo2kdg2WZ3MAvbiqBc=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-376a4059061so19327eec.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794937722; x=1795542522; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rA3XzT8tXt6/+XP+fsrdKUtHJCQ7Tr9McEClsG+Hib4=;
        b=a10+1FQXFb5aJX0JoBMGUOLgv0ztiBQLLcqk1k6MuFbup2FWQdXyR5QxSUcQNBw7Ti
         VALVyt8C/NJdnox2XWoo1pjCrsEM2p1BfJKetGJ17xXFpNwYx7Kia92BMGeIOHNphmeF
         97dByAiUni8HxlbJbIH1t07TRJSKnehcB9GzQhpi2jrCiTq+hCF/TNBl7nNJCW4BmaOh
         K8Be9rb4IfQCxWQonYAQHjXye2vRO5qXYwRhfQIP7PoseSEXC+oyqXiVunI+GXy/n87x
         tttu4GSzkVFav8FNdUocAFcCTv4Bp8RVprPIQvFBPogtWOXu1DJa7EndqcwYdd57dCNK
         Nc4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937722; x=1795542522;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rA3XzT8tXt6/+XP+fsrdKUtHJCQ7Tr9McEClsG+Hib4=;
        b=iX3v+LVJPFPdPfUTqPuw57BOE3G8OgO2bag/o/DOMoJrpU6kFsK6O8cUjf2aI397nH
         Rl9IpjgcOIGbo821agzNCmCWrJHrIHdfGPsubRY9QvtHVB2Z8IpVM00Xi8aTDuuGv+tG
         UVbjEVrwkD3rgtQFBeNbhtxoC28rNm7stiIYZ0Jhuo0EoJj5YpYr/TzxH3DqR7SpxTH9
         cYIl6iOErfUB0sMNH3BwnjurTJpSeUoCRgsVmWK8VMrll/v7DSnTMP6msjagnY1ifL50
         0e9cXwlH7b5UvdXrA6X64O8KmiTJ+MERGwQZeDreIPPEp46QGceyY86mK4Vyd2dYeERX
         hAxQ==
X-Forwarded-Encrypted: i=1; AL+hErHBCPoZfbJyU8iXzEFZoH0BLIIRay2yjzfQr7X4gLgHjeQxXqIDFYN2cWvQuC/Cnk/7TQpVoceMqA==@kvack.org
X-Gm-Message-State: APuU4Z8QMlWTccejbPQuEkIdUeZn6ulLljVVP1BoJ+bvofR6WTUwfTDY
	zzGGnabi1iNlGOP4syaNwVzQZmUCYXvFEMPQSQFZgAyFkg4PFF+2n0oOGfp3kTRP
X-Gm-Gg: AZFdTZcW5Mszs7gh3vOnxT4BMNjrxzg5A2jQdONRR/XNhZtVnO7bNNR822owLvrVhZD
	UUw8C1YRfbj+VttlHuPMx/UOHyip7TIo1Y/cXysFvH2N3scJpA70Z15h4HSxtTGzbq9Pm7Xhf/t
	CPHEYDGuQtyI3v7O70+URIMFFuk1P117wbdfwgK7qk/cQgRIA5tTg5n4qi5mUHY3hixUCzJMAMT
	flkiCSYtChUWmIMbDIJbBzT8HO7ZkQCM0HtVgemE7uErZwZ0cMGnKfE5L1oA1A9KAK4/RQQxhGU
	oYUq6l4IHxHn/lyHVRc7yb0Z+gJQ68dcSJb3yjJMX1vpb7OiFtJYYNXTOwKvvWnwBLFJCL/0IBU
	zS368fv8rFZaABDc6NWbyiYR7gm+cvepAPbI6WFbn0sb/Zm4j4PeTdu+vmHkiseSG/xsqvgRA20
	Ki5cpoPcMeB6JhDx8kVy0RpNOaoJiM90vVP44DORai6NdKjhlPrTx56naSbuhEQ7qofRng1MvGE
	swWgXFEXcqRD6nIG7UhiDZgN+gsYXpGWeGTLoePBNQ+vKvfQPs5qQpoeZux2sK1qzXatQqx/7pO
	Diwk0arecoB1p9bdrNiuQDUNbsRsOCGAYzX/KNcDtHQmXyTXeoJf4g==
X-Received: by 2002:a05:693c:894a:b0:36d:5fbc:8c8d with SMTP id 5a478bee46e88-3828036c8e0mr197352eec.2.1794937721763;
        Tue, 17 Nov 2026 09:48:41 -0800 (PST)
Received: from localhost.localdomain ([38.254.175.116])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3815045b90esm7025750eec.13.2026.11.17.09.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 09:48:41 -0800 (PST)
From: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Subject: [PATCH 2/2] mm/damon/tests/core-kunit: add test for damon_call() with repeat control
Date: Tue, 17 Nov 2026 23:18:34 +0530
Message-Id: <20261117174834.29182-1-saileshnandanavanam@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uyqkbz3hydcwf69sc8gpw6foij817zrb
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 208B9160010
X-HE-Tag: 1794937722-458274
X-HE-Meta: U2FsdGVkX1+2HrzfjRwSRKpaPyDqT4X934/q5gnft1NMBUBIG3rxQBAWTeeIy6GJ9z7jEDHGLr0Z9QANK3rg/29LDNkq3eUxD2btuZ4bPFDnd4lJL3JMWmZWq3Wqv7UftR2CThAfYQI2Je67wcybo5lMso+jHhdIhep60q3pTShKVu4X8Hy6NnjE566bPnu25c0h5G98YpwiNLaWSK8xPdkj+UMrEU1+RwRHV7Ub/w/uPKM8IWEPhs7nTPeeem+n1FQF8cReBmtwJNzx2bdlF7pf8LOxTy8nwirqWa02+WFWIHfs0Lee3cPxdqY/nbsTWYXRYRs2cuJNfJIt5P6+e8fqyjJa2CxLEf0JlAKl5ZWQP17cW30pIMgG4upTOXrDw0ljwnDiErz2KO/1xNt0Bd9P6OzW0lpw5smsSHmHezzoZ596KFSmvtpMPTrB/dk0ZLKP/2KzApgm7nZlOc/PPtHDPnArtpvwamuVyci8rmUs3g399AC4Vz9OTf7AswEDH3IAG0+fjWzP2kuzUzYSUkZz7RPSKjFp/PRb5wLAl1VmbEU+UjtaZ5RrgqSD/kg+ATiLukLL9ZB3mzQoFx7FEnImgdKCvU8pj/JyFLNMJ8LpGR1Zy0cZOyLkBPTc1S+aFfrid07Hmdzq7eruTFmOBglJqxqbgG849WtKoAkVWq8nC7SP0kJiaKmF94E5qrEcA2TwB8VCnqpKgRy+Bk96si5pndTUcYzzjz3pWy8PUibX+st+DsawPvkfPqQDEHPWioowRvx0be5y6+g700S8Kv2ZM6pGv55BQbNN9E1BBF3tY2YdFXJKbPAKCvqxcxOidSbOWWtRggj+QmWx9q89ej/ouUjMORInaxTdHb9jmLInTKfEzUXQ3zN/COOUXQnErsGcea/3A2Drtd8ikSZtqeuavfuMHFXkHF9hm57enV1YmkjSRF1pL0I3j6UBEetcBvP/pWup1Y/0UT6ksw9
 dFmDHaN0
 uOKIfxhHapWi6GnDIaHKXmTLqi8NJZJfwKEuJ67xPjcbgSHcjrD4zwcYGD8qLnYkz6Mi8IHDj0yE+GU0AS3Z0Z6HjLVsYildjLGMd6Ykxsvcg2i+Noj3OP65vQ+6uVt8zzawikc8KiKVsL20cB0xjHvgYeSa+mGk3nP6RUlmQ58ubuVswG7LFDQGB0kfxShU/6JPRvmEzXFeXoi7GvwZhNOAPenJkYXkehPHNuFuizwrZAXxwoUpD5RtYL5jGZwgaTlMRRbW/0jnq/58CbjX3GSDjKWrJlVapDn5ltPS+lBzd3IvLLnItIEb/xeJ+kJFvCV2d3xwp2+sUFgWOpRV+xaR24J1fge7ivtsSaGbkhsYxoJvTMTdd+cCbwf/cMaYnfgnoZ9cGviZhPagcXgQq+Vitd4eODOQIT3vN2k+MOGh4aKDnLp0NUSNCvfKwQ02rLjgV/OFnyQttUE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When call_controls_obsolete is unset and damon_call_control->repeat is
set, damon_call() should queue the request and return 0 immediately
without waiting for kdamond to handle it.  Add a kunit test for that.

Signed-off-by: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
---
 mm/damon/tests/core-kunit.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 13315291f69f..bc93677487b5 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -2499,6 +2499,30 @@ static void damon_test_call_controls_obsolete(struct kunit *test)
 	damon_destroy_ctx(ctx);
 }
 
+static void damon_test_call_repeat(struct kunit *test)
+{
+	struct damon_ctx *ctx;
+	struct damon_call_control control = {};
+	int ret;
+
+	ctx = damon_new_ctx();
+
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+
+	ctx->call_controls_obsolete = false;
+	control.repeat = true;
+
+	ret = damon_call(ctx, &control);
+
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_FALSE(test, list_empty(&ctx->call_controls));
+	KUNIT_EXPECT_PTR_EQ(test, ctx->call_controls.next, &control.list);
+
+	list_del(&control.list);
+	damon_destroy_ctx(ctx);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -2544,6 +2568,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_esz_goal_temporal),
 	KUNIT_CASE(damon_test_last_region_quota_reset),
 	KUNIT_CASE(damon_test_call_controls_obsolete),
+	KUNIT_CASE(damon_test_call_repeat),
 	{},
 };
 
-- 
2.34.1


