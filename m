Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5032CC982D7
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 02:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ED516B0092; Sat, 19 Sep 2026 22:31:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49E716B0093; Sat, 19 Sep 2026 22:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365FF6B0095; Sat, 19 Sep 2026 22:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3EE36B0092
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 22:31:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 50DF21A034F
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:31:25 +0000 (UTC)
X-FDA: 85232564130.06.1740BFE
Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8E43B40004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:31:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="loJbBlW/";
	spf=pass (imf11.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789871483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MCQCwXtMyVG3gFC0VFWbPq0+zT3uX69pml+4GH4Kjjo=;
	b=naB+t1z3xXEBykQyjLbBczV/cWOrhsfnKz1a/ZjZhNyf3fbBvpjxYWHG2FuNjPRWOxAy2h
	itOcuSKix4ahmhOR11USFc67wHTMHKvmsuAX6j6T/WhJNB6DRb9PkPXf9UxkTSm+jE3xK5
	0wMDQYFFshsC/cmbR0zCzRMkj8bEpuU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="loJbBlW/";
	spf=pass (imf11.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789871483;
	b=YbcnbcrPJZmPi5YUD5lbrtHz3sFYCWoTpd3/bLf0lY1OqOg2kx/pb9EHkfs6Qkjz5GAJ93
	/rUeWRpIjGHEFc5I/FFoE0uukTJNMhsZrA69KP24bNybVRyznykRTUeIjstPJwmXD1kAQo
	a/1zsMflX9777UXKfbKJCefw9x0kMZ4=
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85a4329731cso1494535b3a.3
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 19:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789871482; x=1790476282; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MCQCwXtMyVG3gFC0VFWbPq0+zT3uX69pml+4GH4Kjjo=;
        b=loJbBlW/6Lww+3wenH4idMD8CVstufyzala91COLs9pgs8aXJMjz4VAYlBjc57Ydyy
         YNZDrhfjgIeRIJA7I+fy9s31UtwsUfwlrPDoM1kFFSdA3MaL1oHKv/mYtsa8X0WlJuoy
         /K62rgCfWj/0mJ+FWVXFSKIKD/869Oy6/jULRo6NEvS7csTOQUuHwqBeEaQPS9JjsDZ/
         5Owq02/EEME7y3kNKCRCDChbJXdM+FXoJsPR7uI+As0bqsDYvOZ2fn3tqNLEFOIM5nvu
         TVhJQTUXYsnERTJPsqGFZMr98O0TjGSvu733UVG3UV5B2nxW0RwJBQal0bKgNRyNo6fX
         Bsag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789871482; x=1790476282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MCQCwXtMyVG3gFC0VFWbPq0+zT3uX69pml+4GH4Kjjo=;
        b=lYNcGLU81CBi/of/xwM+6ELiwcYOe3DnmsfOCwUM7KF/wS3rkIChS+CTop+XXRREXA
         JB81UfkVDXqKN1rI95cGFFiicZ9AUsTuqOpdZ1H20M2FPEGmKOH5bJTJDzifU3MOgUuY
         /0svCFPnQn4ouiNZoYYxa4rYs+9qlyCyB87IR1r6mRdAptSJtUWPdKwUzZxrvoIiPXlg
         5Ho/kx4z0wj1cfRQU/LqFGmSG7M0JZwqocrLkgVxwaiFkQxEFZnpG04j4qz43u9+hrHw
         +Niw9MC80qTlAfyMPXEYjHIHrxLKPgFzoUfVzE5sZdme8Mo9tNULLvSaebAlecXxwMXY
         1xvg==
X-Forwarded-Encrypted: i=1; AKwUvBw+rj4WDGdkocTS+fTBt6hazdQLG6T570HYkHWfn9zLEmgHaKGulaI2Lderme/Ay6aiTanRgB8N+w==@kvack.org
X-Gm-Message-State: AFuF++kwrUYrsltGx6VCTnogLBAOUKzMP+QgKZ8DTXRRXKspgH7Qqrcf
	T3oAe+57/ZfAd1r1UQDadrgs9/aum2ShqxEyZuhNmRYjTV3uwFxbH7s=
X-Gm-Gg: AYBFou0nWD253cNVU4/L1QYbFe0dPGob4tv3DrRAsOvN9Yc/ALlAXjqpBcfOxZ5icnM
	Ckas3sSbF23DabqBjNyPKdJ57deC7B1nUOD03MV588iD7aMACvZTn1vp8JqHHQ+pZXHpRVWOKrS
	2AMcDQXCJBGMSyv5pejFFbqv7voH596paxy1tJWh2ksImurcWYDr9rWAjBTlOL9lm8tC7hSixB2
	p1DW+L5tvTY/LHJpplKBb4ajXt15UerL/a48crcjejN9GnSop0e0b+pF8GS+TAVp3dSc+9dPPaJ
	APiWvZJgTuaknc/Ql/XwBYnpMa4+g9ChNRbor6/kotOeIFWAK46UL7I1qU9MPvw5SUeljjRpLPz
	W8YlQuOcpDLh9/wBrG8+SSMtyGPyJfL1qtkkJla5h+TePzJYwZqCI4hpIoqziIz4lhAne2CGSuy
	DfffzGVd4sbEBbEpJ+eYIMNPZ6kL8M+nBNjwU70NtYRrhUCQHvU1W9znTgeHOlOOqJM7Cgs8lTP
	242nNRtAOyV5KmN69dZfds+rg==
X-Received: by 2002:a05:6a21:3510:b0:3cc:c7cf:5a44 with SMTP id adf61e73a8af0-3dd8c3fbf58mr12345243637.2.1789871482415;
        Sat, 19 Sep 2026 19:31:22 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:36d8:54a:e0bc:3e5e])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc72aee03efsm1481341a12.24.2026.09.19.19.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 19:31:21 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH v2 2/3] mm/damon/tests/core-kunit: test the temporal tuner's size quota conversion
Date: Sun, 20 Sep 2026 11:31:10 +0900
Message-ID: <20260920023111.2466265-3-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260920023111.2466265-1-donggeunyoo.kernel@gmail.com>
References: <20260920023111.2466265-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8E43B40004
X-Stat-Signature: pgnioosyekcjuww9381pxdc8t6qbzjii
X-Rspam-User: 
X-HE-Tag: 1789871483-951836
X-HE-Meta: U2FsdGVkX1/HiWeSn0Fyyc78/pw/eySKyz6r2abdVNpNxeUXFmip0QuUtG/tn9kVUu/Vn23tBVG6h3e/j5Ma0F2ohoVj7j22EPyIWJ7Ns/s3Wy9oZS8VVGwojfr5ogqsgNofqpwGCTYCvOM3bXJu0Zk7gVnMJ+Mj6Cjm5nXk4DFD+e735Xo2PFBIr3MrTCqZGYl3OlXfUiI8a7PZHlM+ALohWsRC/oUjm/8Fcfgcl2xdNQpjba/kvvIsT1fve1ayqqjYRcOsiTyp+CmgLFXaFTHnNtJoupPJXyD1gJPYGVCyVzXIBOhGryZTjKllpOhrm/UjIrhCNZYYv+mncBzBYgRyemEneo3h9qsK6IjwtjaOvF+QOpNjBC5B6+wUjz4gk0D10B37XT05VluCiN3L1WLoSV+48q/ZU8BJ4x1JxHTewpxBBMt5ITH5qZXV+VVIYCqkgokyLW3+JfO73xkPPpjQHzzVPlcdvnfpEC0veqCE2C8oUpUJ79bienILkWh+BCg35wPrcnY8IY84lBIhfCFubbaRf8PD/xyDJRbWrULwloz/z0KxaSYzQH/newJfd5bd6+RWLfWvuOW97A5L/d4WiHtiRtdIsua1v5lL/d+pzseGqAuaZKGq5DAQvkssXlLIBhj5tLhHHy7cMOQJ9NgI17uWl47uUvX8lq2xbWTeL/gLUES33aqImBYzxu3jJs9lEkorW4ULUozZDpXkW35cMp9gxLtgAhiHrvp48PrntFWbZqnrd641ZR/gFt4+IZjBk0aLGqV6Td6m/DA4otElNrnhDnhHgMOYGq+6eW8Fyot6CeegFML7wj5r8yIsQ3/zUuOkhmLS4m2McyGtt25vlkidEmNVqqgeoy7E9r1i+nMSvrQsd7anx7mvPQVwJLQ76osxZHd5UJ6uvMe9E3c5TvoWoaQmA9hlqwZ0//greGfQB3+ZmeZRF8TMTwxQLctAiCEvJNeYAPnWlUV
 izwYre8M
 VrUvqLB4tNBqvQbfLD3oZz7SRO3vNGzDguBxLqHKcR4SwSyTmdH4UsKxycQpTBbvuIVASpa+Wp45wlPDZadVt/5xcn0socI9m4venZgCiPWK0VpWQd1GzYCRxx3N6uYqO2jCX7L+5vJ7FOulfKukfxH90gebaj8lUExN082koGGHOvGqvPAk6yC5AJq32R+ayigBj+fEaVTqrnuzCBVAkwNjsUby/uGmC1J2/7HIgVpLBFHQDa4QGOj3BJ/xNCLBOg1hnXXFyK83qtQI8sa5OTL1XxMndsklAakm7j469njBFWrKu0/mTmTd8BDM/UejdIA6ERoeeFOBLKI0DoBYt5zLnTCAepWfaEVYyUT3B/YqH+2KIJiLG37OECmKa+O6K5E3qYQiE+RQyWlFdJd3Sw76BDMhw5cRlPpw3o9eFhzXOj9Tu734/QZsib1ch7C3mMFNLpHX18mTFZWBgdNwg20/kIKljn1pqsyPH2nPYWq2exU0=
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
 mm/damon/tests/core-kunit.h | 48 +++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 5ff0436c58441..a0604788bc638 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1929,6 +1929,53 @@ static void damon_test_rand(struct kunit *test)
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
@@ -1965,6 +2012,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_is_last_region),
 	KUNIT_CASE(damon_test_walk_control_obsolete),
 	KUNIT_CASE(damon_test_rand),
+	KUNIT_CASE(damos_test_esz_goal_temporal),
 	{},
 };
 
-- 
2.53.0


