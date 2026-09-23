Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DF76C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 00:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BCB76B008C; Tue, 22 Sep 2026 20:26:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1951E6B0092; Tue, 22 Sep 2026 20:26:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AA756B0093; Tue, 22 Sep 2026 20:26:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C55026B008C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 20:26:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29CA0A068A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:26:14 +0000 (UTC)
X-FDA: 85243135068.24.CD3E4FE
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf21.hostedemail.com (Postfix) with ESMTP id 610DE1C0009
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:26:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sdLK69ml;
	spf=pass (imf21.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790123172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=073LFNHYNcDRZAaaJHUMAvNgAbfdcL8a4X1+nmCa0A8=;
	b=fzNdxM+D3/s8AYVoq5EPWcGipdgj4D39DuB5VSB1g5eASK9vr8GmuQd+9ruK8RRJqK1IJG
	yUupNVeBBFNcslslh4AIh9fiUJmaLeRGZLbJi2N1c897V1GQft/AkWh+dPhMJpz1c64Ryd
	2rgZQArW/qGTzEvDW8Bs5UzN2jLCawo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sdLK69ml;
	spf=pass (imf21.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790123172;
	b=GUX7/UVfreiH7v3mVusG4KKEzHzhR+cxKrXvpdKSHEFU5X/ZvA4icVOm0ul9MNTH+xU5D+
	1azGxRWvuXVQKHOGATez8It1hIzYk1rSBKemwETxXG7m0aAxJttG8+46OSnSveDRjFIDzp
	C16uDcoOYYv+TOJ+1knUTTL+ReaKFmY=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d91a931f66so2164795ad.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790123171; x=1790727971; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=073LFNHYNcDRZAaaJHUMAvNgAbfdcL8a4X1+nmCa0A8=;
        b=sdLK69mlWXNLu/6OoBYHrrCWkpsHhgSTMiyJSW8442EK5y82JQXDBuZtEKlzMsxygV
         eh/x+Lk7TOD5sfqhCwLEeQ0Vo18ApFBv9MSYCerSS0C5F69CC/29UyFXPPRAPabmropG
         k9agO5b9tt2n2+3hkvtUCMavZ3mybr146yCWJJRY9eKUziNKJnZx28d4wT+t2/y85W9M
         byiHKDHQwriHOMDDr+pv32NMjqp0Iohst6XUt/emWsujCrzcQFVBzho9dzZWjSsa1b6M
         KoEb0TJRxaOnnW9XnOknu9LqP2o+lqU8f5PCUaz+PTYKfHd+hMDQuqRS9W7RelMzhaYL
         pFuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790123171; x=1790727971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=073LFNHYNcDRZAaaJHUMAvNgAbfdcL8a4X1+nmCa0A8=;
        b=hL+RO19nwd1/9Co0SHeZdH7zJE6qHCY+GwVe9TB4SjPdqSTmCl9dvM9+Bv7ErZ7phl
         URgQ2Hzky6NU5U0UGdIe+Cgt0NJjX+vODPujWnFewKi18AxFZ7B9n0BHvhGetdJApzzp
         FxNGAklZfhypq/jwlK/P+5ZAsfwOzv7V0+jkKCq9w5/dKLEtQ/7Y1vH/gxKaF89eYZPp
         RfGscQI5e3mpkbkFhcgRfNbt3ZEzvkY0NEa93vhDeH2YgKBas0rKXJv4Lvslgei2hdQF
         ixQ+NAlQvEmqJRmHHagERuzUKuEuw6Z7ILipPok2w7MlghFHr658CC+gW/mAU2Y4D4hh
         nGMQ==
X-Forwarded-Encrypted: i=1; AKwUvBx6CGQB/Fdx8lQypZgLkOaBWA6Fee6MhYgUbxKe90uvoKVutm9JfUsX+un2+cB+xBId9BpnVfL2Xg==@kvack.org
X-Gm-Message-State: AFuF++k9a3vfWuR5cBmOnlpLiXuSpfgltqBdCJpdhr1huidmxPKKCE18
	gbg1Hk0+Uqi5uvXzwMFXUYqtvF0ckTuOWgPDPD6BHBAF98uHXeb3Cb8=
X-Gm-Gg: AYBFou1tif6CBmS2jX9PrhnxhqcJOrivergIjxj0fIbKqmQuIh+x6rvQ0UszXXExQxa
	Y9oCUlEH6bbVdC8dVoYEEa8katSmVkzsudDMgVmXG2dUuPtXJmHWr4uMLiWcgP0FjdvOrZnOFdC
	XbHWgwma6/pSIuXqvdojwmy89Px7MaAgG9flZuUtxGXSRqiPSlORVbOSDh5qm0aYMROG5tJps+R
	AosMHyr8g7sKnmy994apoFAlDJHhFw1XnkOElbz6JJ6M4sXNztYNFWpNgCGBNMdrsk0bmq7VaZZ
	NK4v9BU0qe9ISBx0bwAKJ6RM5ts9HwfgygPmU/Huk63y5wqzPCO+uagTg0hZ1ca2oMFFO3f21NK
	BW7yQcDHarXuW1qEDf8HHHxRB13DnsPTEj1m9fItA9AjEgehWqoTDq/z+LEAyAMQmuuB58DjFxT
	Mn4MdrChHZg9shtQ5hCSPH5JOxkQyTXlSj7lTHISBD21QyKj02YjStcAsmQU/5RV5mkxMaimo0J
	f/6+dkN1WnxOegr1AmQ6ivKzyjX1fxjsGb8XXI=
X-Received: by 2002:a17:902:f683:b0:2df:3872:f266 with SMTP id d9443c01a7336-2df69d0c450mr8862005ad.8.1790123171214;
        Tue, 22 Sep 2026 17:26:11 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:2466:805a:e198:cde8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a5a7b76sm2176595ad.20.2026.09.22.17.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 17:26:10 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH v4 2/2] mm/damon/tests/core-kunit: test the temporal tuner's size quota conversion
Date: Wed, 23 Sep 2026 09:25:59 +0900
Message-ID: <20260923002600.1825448-3-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260923002600.1825448-1-donggeunyoo.kernel@gmail.com>
References: <20260923002600.1825448-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kapxact1i14i49pmeub13riqu7t9fh6q
X-Rspamd-Queue-Id: 610DE1C0009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790123172-662659
X-HE-Meta: U2FsdGVkX1+F3dWZdjhQDV9rmHjBJsYE29ZLEHs26DyXPwQZEj6t0gZ04UeFW5ELtJlqSgHxy8h6g1XXhdjHQ9EFz+s7wzEVRAhPo9rwt35pJ+8c7a9oveOoo3C/TI6N2FeczA0gyI1Yy51zEiLv1cLx3APSdnOZB1GsOKwFLESMVEqTzxxcAlXPxd6A6g5WSt1Hw1cGa+VbmuGgSKZezNFC1/5au0QuTVbqjz6AKtms4qZT51qqGD+D9U/q0HoL+QQZaAePk3kHhw5wjcWpDobLdbn8HoyLDkZTHl1l40unYa4+PgXi5Mjyom7kfvO10GuUfVhJ3/O7+spaAwrCm9qUs7WY/k0ft2cYGsSyyXSfRQGb6eCJzkHhgviiEr2VNUYEH2ji6VB3Z/GjBomIoVGad6u3MRlcjko68z+u+X8Om8vNgxtBB2/O1XEXZAlN0QEwCgyz22KSbkJffyXUZDUEAV05PysTmXguB3nptEtIq9bkL2HZN+KzAdc1iifSVa1G/NCmfYI/UrE3CSIJ/v1CopaiT8Fgho2OVg6sRX/HnbxwWgfO3Tncuenp9OEOs0ZSugdw9bMaYIfu8dBRSve9/VTMddthFLdg7ERjhrFUzaai2TMqXwEW0U4y0GvKicQ4WTM4KzPIcFwFsI+Ip82nZLgXh9o3o2JSuO9pQnULwWE/JAdbD96EqAvZ0eNbTqr9ulSX9vSXDPc+G5wipUbGakliD8hJ9uLSjpNYt2hooz3LxMB7lnoFT2V73wAX+DUbJ7BoQ5YdEeJPNdZ66doGwzPmnNlHX8kD/acipcorIRNemUyuUWJMu2F2LNf2mJlaHN3GmVY1h8OX0kOpkPY8Gbw8/jsqS8iFsdX0kRP00Yo8KxLhKlUf+tAlV99poc6z+fJv3OPu456F18AxOwepJMOMhubqyHbbRX558/fF9wPbmv7zoLHoc5kSa1JvZZGNZ1NfJUHUl7wH4iO
 Cpolv+Jp
 /gwJO4nR5Q2Qsr9KYceTiMUZsgy2hQNj+mwO7YYdwEy0m47PaX5QHBMTxyi+lBd/Up3yyu5AbtXzBgrMH8e8AeEZfnSUD16cP+ToKcREwEgAhYxyP/y8TMxiui3KsLFOPhuzSq6YD81EiF2Iq5l1SP7hLGQ0AW5tfbu+stPB6dEUUsYFmiB7KOeBBFU7DJmXsdrLixyvvXzFZIE6Alh+R7z89MhZ3erszFT2p1myAi8/9esJHG00NNvLm3m4b4tuIzIUhvvfhtBFHlG2pInmc5ecrWT+vcPYv9pioHyIA1824YxaII9I+1CheRnDn1q9jbjJX0KVpBmvtZvsnXpcrwLBoI7r6FS19Ro+DXjuKAKaNiQ/AVOR+7d5l9OfA0qgsqdMcl76W1trbTjTj1wFSdQIYx4YSbtl4N0g4o95jqL0SsfbNhyniTKdQz5eHSJtcnmW6zsNmcV9UIUlYUixLeUYDChgP61mIqS2MBZhIbTr/D4bj24W8J0opVBPr1k16P72vhYNxUaiI2yU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_goal_tune_esz_bp_temporal() encodes the size quota in basis
points, so the conversion is exact only up to ULONG_MAX / 10000.  Pin
the three sizes around that boundary: the largest one that fits, the
first one that does not, and ULONG_MAX.

Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 48 +++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index df84d9cc7d204..bb20c6d01b692 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -2242,6 +2242,53 @@ static void damon_test_rand(struct kunit *test)
 	}
 }
 
+static void damos_test_esz_goal_temporal(struct kunit *test)
+{
+	struct damos_access_pattern pattern = {};
+	struct damos_watermarks wmarks = {};
+	struct damos_quota quota = {
+		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
+	};
+	struct damos_quota_goal *goal;
+	struct damon_ctx *ctx;
+	struct damos *s;
+
+	ctx = damon_new_ctx();
+	KUNIT_ASSERT_NOT_NULL(test, ctx);
+
+	s = damon_new_scheme(&pattern, DAMOS_STAT, 0, &quota, &wmarks,
+			NUMA_NO_NODE);
+	if (!s) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "scheme alloc fail");
+	}
+	damon_add_scheme(ctx, s);
+
+	goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
+	if (!goal) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "quota goal alloc fail");
+	}
+	goal->current_value = 0;
+	damos_add_quota_goal(&s->quota, goal);
+
+	/* The largest size quota the basis-point conversion can hold. */
+	s->quota.sz = ULONG_MAX / 10000;
+	damos_set_effective_quota(ctx, s);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, ULONG_MAX / 10000);
+
+	/* Any larger one saturates instead of wrapping. */
+	s->quota.sz = ULONG_MAX / 10000 + 1;
+	damos_set_effective_quota(ctx, s);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, ULONG_MAX / 10000);
+
+	s->quota.sz = ULONG_MAX;
+	damos_set_effective_quota(ctx, s);
+	KUNIT_EXPECT_EQ(test, s->quota.esz, ULONG_MAX / 10000);
+
+	damon_destroy_ctx(ctx);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -2281,6 +2328,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_is_last_region),
 	KUNIT_CASE(damon_test_walk_control_obsolete),
 	KUNIT_CASE(damon_test_rand),
+	KUNIT_CASE(damos_test_esz_goal_temporal),
 	{},
 };
 
-- 
2.53.0


