Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 523DBC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 07:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB9AE6B00A1; Sat, 19 Sep 2026 03:13:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91CF6B00A2; Sat, 19 Sep 2026 03:13:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58C16B00A4; Sat, 19 Sep 2026 03:13:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B7836B00A1
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:13:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BAE39C01D9
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:13:39 +0000 (UTC)
X-FDA: 85229646558.20.F9B5428
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 02AF5140006
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:13:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RuR37j7D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789802018;
	b=GlOQEcJRMactTcIcvukLso4NOSBHzqtV0U2PiJni7fhflyVIoXkt6TAbsP9spa4nnVOdzV
	xIlfuzJMDPgs3NaX4XaPFmmxDwfk/Cx3dN8P2PzrDnjSW9GZChOwI0XgF9Jr9+EAKr6lFf
	R11Pd6NV1ClGbC7I8UriKqtSeukdmUw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RuR37j7D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789802018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OlJRvd2rG1Bz2EK/T/fTdnK/hmBMI225GJHFCiKFLUk=;
	b=IE1Lor6vNDuLcsqpg1StLSbRz/5QkqMub5tQwSySIoRISp9NsJsJdHZLFpCRB6b5XM28tq
	Jgx4kCSiEypQquTIETwbZDc+QJRorCU70AdvIAfYLZgmWOFS8PhczsdjIsW3F7iMS8C5wC
	iWpRtJixJV8RxTTC16L0a/dbS/413Xk=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-398a147688bso1527625a91.1
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789802017; x=1790406817; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OlJRvd2rG1Bz2EK/T/fTdnK/hmBMI225GJHFCiKFLUk=;
        b=RuR37j7D7lsOI0ZtnelYnMs5yjo1V5aNEHtKYgTIWg+9Vjp04FoARuXQ2lRvT0lwTG
         v5fAMG7iIyIf+9OH+Xo/PKz4JmWp+bV85jxNSDt3j2kS4YVeAlJ+N2hZGtzGwhm4OPPH
         OoWabAZDFIf1aoQ3cV+QNAME7utN9QvfyAzrSI8ilkvUuehEXGoS/S5cqEaeTGjnue5x
         6ioRK9MzMjUH0yUZDnNIl43HoqYoMrkpOk71QwU2IZhkKtOSaxXt2sc7H4n9NG3Irtld
         sjC966iqzmYDAmkFaHltLnMJOSh5900PxpxS6fBSw9EO3+VsSrelL9VNQG+IkckKNw1q
         5Sdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789802017; x=1790406817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OlJRvd2rG1Bz2EK/T/fTdnK/hmBMI225GJHFCiKFLUk=;
        b=yw35jPx4hngfh2ztsnYBZ1ymoeFb5jSHgQEXTXL3X/BC+P7gb+7RZjBLYb/MyxQZyw
         WQKoEDNfXgZ3guJZARbsc+uVkifkyOlTdWYYOhCQn1jZBxVEmfVcJlFDG5bS2Iqe3CUf
         KmNdW8LnoSOIu7j9IwD8UAJV5wI2FRzBtQwSnjL3p5tJ2K+wWTTH1Lcw6DgR4yZNouXF
         5jIpXGs1roi9IE6wvVxu7iad8gDnNFjFPUgbVcjqn90w6xtAZV9g1VyrFfVWFECMAYVF
         bcnu1viD4VnFZgtXC8D2GPY1XhDE7JO5h7OfspTd9kA+kPkFQqux/J4rj0d6aFf7hKzn
         8Dmg==
X-Forwarded-Encrypted: i=1; AKwUvBzoKBONKC8l0wyKRLuuH7lM7JFBskhWtOKgXD6zS04cxZH0Ncn+Vv2St0mqjDAQpULtOy/cyuxpGQ==@kvack.org
X-Gm-Message-State: AFuF++n39zmEX0g31FHw0EI+UxeaOI7/gk/HZtdUm5zB2q39cjz8lMNS
	bCD+JIYjJRU94Wq8h0mATM7FhehKoYdemkg+t8jUnJzvImqFSMOMNn4=
X-Gm-Gg: AYBFou3N7VMoWmWazOhw6VCR6uZ7CDtjY92H5NGTSvARtTvkYYnGxbOBaJ/f3g082xi
	JbsyIh2VfERXA/jqeuuOps4Wf3Q4CKS7AHbmgrl4HjWhBXW7q2zZOCJaKTWCvzbYuiRqqc3klmy
	lnYmB3sCXyXtW+hl13ix04bkxmCZfWctN5IE3AWl4xVt6MfiiVCGeWKyfNy+yod0jZkBF1deJhK
	34M8psrsCQ6CaP0Mzuqr1umy7DBEv4HJFduyidVQsKysc5gmvu/nm8dD/5BQTFqJbTaA+EdnzHl
	r4bphOtQBw4tLTtEk9b6LrhDNa3LL7QX1u349Pot6vLMi3Kq9FVNNY6vUnV9pWfWiOJoZ3qN/hO
	CO0cF3FHgosmTALlJiTZgoIdf90wZcL97h3BfFCXDsfhJc/B21x2H2yi+FOyS0swATMngXDmw4C
	FVnxmD+mr2C3SbJcZP6yEi/FCaEa5thbnSgf0NE9krhsuGAfCsRBBltWy8R6lsYhO1ls52Y5EAM
	4SrSIIcfe3j1y+MoxOqoioy0X0=
X-Received: by 2002:a17:90a:e7cd:b0:395:7fff:a08f with SMTP id 98e67ed59e1d1-39e549bd704mr9273357a91.0.1789802016898;
        Sat, 19 Sep 2026 00:13:36 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:45e5:9e39:6356:6164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a02738654csm1050170a91.3.2026.09.19.00.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 00:13:36 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH v1 2/2] mm/damon/tests/core-kunit: test the temporal tuner's size quota conversion
Date: Sat, 19 Sep 2026 16:13:24 +0900
Message-ID: <20260919071324.1583280-3-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260919071324.1583280-1-donggeunyoo.kernel@gmail.com>
References: <20260919071324.1583280-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 02AF5140006
X-Stat-Signature: ogxrkcepcppkmd9687x9tx1sqi8pygmg
X-HE-Tag: 1789802017-15221
X-HE-Meta: U2FsdGVkX19uEfWKdH9pBDEGrF+Ix4T5v3i/mYOKmMt6gSBbbwviHeOVvnA92Z17n2BZ/NgiO/4RjSjcw7XDp5kyzemy4GiUr3JThC8wR1Q5eqrWyoght3rQF4z/Rq5eT/YwAccZJRTfGgjHbJ2Eg6F2YisAIxWu1u+Wl2Ie8iflDfS+C97V7agPtb4HuPK6ciJVK3H8jgh+KbuYiqm72BvNjdnyvuzSrd3+g8013d+KNOmMOzDnDVNkj4nrNw+MyJ/QR1prSGxqVrzrB4hjhOZCr5Dl+BLsICE7QFNsnP0OqlG0cVRX3cj3II/Y4enAj4rzdKgc0+QYm5FyS3iTJ+GEyVbbrPFRe4W2SY8c2vTGAzhUI48SGlSjikJ7OBcykAHM+BUK2VbO7tyw84AfkIliTYBs7JoT5/InFyhLkco97Jvlvok6PNwEeXuTdLkwuMnGbJMoYyDblHz35YGk4sfTEUV4V+xT2tgkNWF5TyCazToWPkffLyIcJtTsGxYqQvRbm4MFzwa7DCUmv3au0BZH4VVb9SyE8ScReZB+xILdV23XtFHqLlgjaERfN1Vwvb3L374vkrAK9LHeiXueHBdIx9IRonuZdDhZ62z/5KmjmBElPi65fDMu6IhOOqpMLqHd/sQGG/LE/bnzhFCa+uq+Ok55S/hxswCeJoBSRDRb+YM7lrIttZzsQ0HoeSTiDpQXQU4e7MbfvIgFg/EUmUhzc8mLCkoddg+sgMXRGTgWD7+/YJFfxovJWLCPCjmH/XRvIyxG37G1Vh9hJAR77JWlIvdwb7ph6Dj4slxEaT0ybDIzgXNOmdr25bbcL1mypHrDHXdSxSORasozgFvfmnZqQRXA0jPCX4E3jafKoLpG37YduoHEGz7V6X/kFqE3cIKFJY+tydSkN6kfjpyGMfFc2VWe5a2XnMpn7nplyPrX8tn6yUqH3HwLAXGcuKNvU2QRaSNS9MdUs/YTPZv
 7Yh6nOYO
 cilZNfMUuhtrSHNjw6bbwpq1GKIRAdk64uhxU+VFeL1ff+SSU0h2PUNN8FEDosKfJkhLYDH0u1ttNubzEOE8Ovn8mDbn4agXTJH43iBGQhotfhrF+NPyPw3zu41zvXrm0A+gH2MRftq3A6WQ9nqVWTN2YkZV/w0L0isCn2AJyKpNZ8dD1gaODdwnZiskHmfl6vwWABF6AJQjhBdVKdMx+RK7lwr124vFXiMKQTZ+s2SedfQ4wQ/Ff/0hDVjlvcPnZKe0yTVq2LZNBpT7Q2O/msDZP8FLyvW+dF7KfgCb6D7/ECgqX+dSwdHWUFmF2hou62kfdFi25KT9JAy0wUVrNudjJGzDEQMYxYiYfF+s7Wzs5KQ5VgORvIGDMaz+DXoTTYNQ1tX9+p1nvmlt8Igo62HV0hVr54h3kA5C2Armq5bHgxOwS99wY42xGsT/6gjVJ9FND11ytvcL2D0/Bt+Vzx95t6ttgwy+s/mi+SFnO+o8qSpM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_goal_tune_esz_bp_temporal() encodes the size quota in basis points,
so the conversion is exact only up to ULONG_MAX / 10000.  Pin the three
sizes around that boundary: the largest one that fits, the first one that
does not, and ULONG_MAX.

Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
---
 mm/damon/tests/core-kunit.h | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 5ff0436c5844..4460dce0352c 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1929,6 +1929,40 @@ static void damon_test_rand(struct kunit *test)
 	}
 }
 
+static void damos_test_esz_goal_temporal(struct kunit *test)
+{
+	unsigned long max_sz = ULONG_MAX / 10000;
+	struct damos_quota_goal goal = {
+		.metric = DAMOS_QUOTA_USER_INPUT,
+		.target_value = 10000,
+		.current_value = 0,
+	};
+	struct damon_ctx *ctx;
+	struct damos s;
+
+	ctx = damon_new_ctx();
+	KUNIT_ASSERT_NOT_NULL(test, ctx);
+
+	memset(&s, 0, sizeof(s));
+	INIT_LIST_HEAD(&s.quota.goals);
+	list_add(&goal.list, &s.quota.goals);
+	s.quota.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL;
+
+	s.quota.sz = max_sz;
+	damos_set_effective_quota(ctx, &s);
+	KUNIT_EXPECT_EQ(test, s.quota.esz, max_sz);
+
+	s.quota.sz = max_sz + 1;
+	damos_set_effective_quota(ctx, &s);
+	KUNIT_EXPECT_EQ(test, s.quota.esz, max_sz);
+
+	s.quota.sz = ULONG_MAX;
+	damos_set_effective_quota(ctx, &s);
+	KUNIT_EXPECT_EQ(test, s.quota.esz, max_sz);
+
+	damon_destroy_ctx(ctx);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1965,6 +1999,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_is_last_region),
 	KUNIT_CASE(damon_test_walk_control_obsolete),
 	KUNIT_CASE(damon_test_rand),
+	KUNIT_CASE(damos_test_esz_goal_temporal),
 	{},
 };
 
-- 
2.53.0


