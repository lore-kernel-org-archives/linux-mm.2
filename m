Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2D0DC982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 08:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABDF76B008C; Sat, 19 Sep 2026 04:04:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6E826B0092; Sat, 19 Sep 2026 04:04:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95C636B0093; Sat, 19 Sep 2026 04:04:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71A0C6B008C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 04:04:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0944E1C0CA1
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 08:04:53 +0000 (UTC)
X-FDA: 85229775666.26.D9A1329
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf20.hostedemail.com (Postfix) with ESMTP id 630C91C0003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 08:04:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="mEi/rTAG";
	spf=pass (imf20.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789805091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=M+BRVhkKKFrAm9F4me8SFnldKmWn3El7IJQUQ2no8Zc=;
	b=QXGkammEvtZZZC5lALUpwpRbKFnWpNbrlN3MwPW0ALlb408tyASFW/6DVr0OAvboL5Hrws
	PMPTURKp/h3PnkyeabfsKR45fQ9MnxOKN/xNSRBtBEV40txeVv1bjegxZSzCWGzun0AphU
	RkDSr4jrglxDfhU07ZiTRJbpAe2F0V8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="mEi/rTAG";
	spf=pass (imf20.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789805091;
	b=K+mpeY7fgeqy4zl77FRukyAeag8XzpLkhc33WpN7bFpsi5bxwN0IA06ycVhvjHPGI6VO5L
	6H/xVScg6cR8umlysz6wRRceXB7fpEPsDloADFnubMFjIAxaEGj34DZHqA1/1D10zuliNO
	88NDTYvuLn958DbvKdRWRqXRBL3mzD4=
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469d249c6so1351899b3a.1
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789805090; x=1790409890; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=M+BRVhkKKFrAm9F4me8SFnldKmWn3El7IJQUQ2no8Zc=;
        b=mEi/rTAG6NEoGfWlbx3/Pcnbbdw+bGztg8Qa6aS7GBt6O9PgoixJ7meV41Fct38P2E
         JXsXAVqvGbL8c8q5n8Z9ToStYT10CL+8dBFdZCWxWn5U1UW4V4cmaT8xg6YMuyD3bPya
         MbNH2lOJa4KEiVNCqVWaYvcmSsN2YIglDjSYXzlAeLaN/4uwml1dWgOpsCK2ajUUny5f
         YDg4m21Ubj3OqInLK39X9Rar0tVTz34vSzr+jZqyHCoiBADoglnGBMUIuTY4BQp9xdM5
         n2eGHfHTRjKSEJqQvWzlbJKc5c0b6vParLhYQ4fxmCxomt5cOoQDmMaLEU6hXPwFNiE2
         ztDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789805090; x=1790409890;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M+BRVhkKKFrAm9F4me8SFnldKmWn3El7IJQUQ2no8Zc=;
        b=QTO/pJXh8k70TwzK0np3CTsJh0xNtlkrKLrBh6amuXZmlXvT6g3gl7WWcJQf4NsyeQ
         vn1GPX9YpGthnCXMtNzW7oomIR3YwsBgEFu1Y9KpTgNw8Iihj8FbS+0us5uWivxgEo49
         3akJr3z/LuqzcyFSuaUJEQw50dtgstcYeL7fnJRZWe87atsyUQlRLSsbbCFxfbD7T6b0
         orH3RLizz6/MkOmc1kz6RFex9/LrM8G84chuhjQdvO+j9dsqVaX/GoO8vWANFZldUiOK
         6c+JFTN2KeQEm+XBwh0L2bsqtgU0P9gdzELeKJML8CJ+q8RUxTLvWknj8Aqa4nF/BaDO
         DG4g==
X-Forwarded-Encrypted: i=1; AKwUvBzUB4N+PowasydOruKHmAS3cc0QD5ZVJALwZk0TSd+vd2z75s3c+bi3XUQg3Qi8g6vmQLHQ/f6Yyg==@kvack.org
X-Gm-Message-State: AFuF++mWYi5KjU/gSUe8fZoZukxZeeXxCtWkzKC6HfbJWKiBBkYCjtPZ
	0oj5siCHD7jn+b1sORfczLZIOmfTDHgmVVvNRGPq8LuzmHBU+jbBovhJ
X-Gm-Gg: AYBFou3JS7o59LcorX2xef2LQW/LiZYvaCBnBPbTxftPBZahYZc/qCcYp33lOXE6vb7
	0Au867FX/t+by3GwuFTOXjxNiUlv3AiIY6wDwjPMTF22Rh5gi9dgRIjNyIHynLBgPrh92MC0EuI
	PGvOoTzWj/JaLtvSxYYO/+YgfWo542PD5vg9FmYu+G4iBHxo6KC2+afPT/XAB0k+ZdrpweGucUZ
	Wch9Ua1pY7zQ5nL/zEglvmp2gBFFV2Ga4Izi3uuLcuuJgVs/R0LAJQaOt8FmKTKLKq+SQBZ2JCj
	BFh+Kstmz1jeS29+hD/8zgXPxT/ZAZk2s9bDFFNYTYKrKftrUFc1ZZPtz7HCOrRb57ULi5j+hKA
	b1DkCAjcMLxJYUTo1d6ye6Flo31z/5Ez1F8GStjRmVuybIV8OkZFbrTTM1PytWLrpFTHGTRHizq
	CeFRgSKfFJoVd9ZmuZ8bvs53y40ZKul5mJkRbHPuGWwEMKt8/CbH2+tTPMbxH8fYD5s0Kf679c2
	BBMlTjT8x0V
X-Received: by 2002:a05:6a00:4655:b0:852:38ff:b4b6 with SMTP id d2e1a72fcca58-874dd6ff304mr8942695b3a.17.1789805090087;
        Sat, 19 Sep 2026 01:04:50 -0700 (PDT)
Received: from celestia ([2402:1980:c3f:8e4f:9945:ef6a:453a:80bc])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-877aa11153dsm782402b3a.51.2026.09.19.01.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 01:04:49 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] mm/damon/tests/core-kunit: add test for unconditionally skipping the last region
Date: Sat, 19 Sep 2026 16:01:58 +0800
Message-ID: <20260919080453.628679-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 630C91C0003
X-Stat-Signature: amgui3gwwf67bs5qptni7rcp3zq34m1w
X-Rspam-User: 
X-HE-Tag: 1789805091-249876
X-HE-Meta: U2FsdGVkX1/gUEFYP7Wxlpkx5z3pqNIVr4rlNoQqHe/BubP+CfZWmoqQVE5dL0ajdtz89rXwrxS9yYA/5HSkbUzcnhh9dicIlqjgDIjdsSmwK2BfUFpmEOnQuHak+m4iNJWhoGvzDWX6jvf9HmJoKqSjca9qXB8W8fZ72d54DyfGbOWzXFq7iD3bi7a5yiPmMbyu5PcMGPTVHARYhZ1Wboyq/H54ZJKfpV2mqkyXQ0u38fS7Elm4tIfx0PgBzFbLxeBongZbT/gnqVm/Fo0b32asxTug+pOH8PGUJMfKz8H0GspapBfp8Gq9m78G+MhcALLOe4DroDLSVgZdFliVKhPPihw8HCkkyfDxDyi5B1QMlMP0pEOjg1hjDVeL8xP8u46KbUuOEujreuhTTGFtrFGapAFsbsN5hScpsWqVUUzCS/+0CwrmPbL2wHXitK/bVAkbWoNot0NnEkRgM4V5HwjJGVP7WAAyIqERtFxc2QRVXpKdGSp1elAyp7ldSfu6Fyb0a/IV91mCe5d0GyLWMJQ2TuGNdbVW4UdkTQN1MXOlA6pIlW1dN3nwdXe2KXICh0JgZ1s4mS5kg1EWDW2lERd56IVQDiOiMFWNLvjeIFcl7LbJZN4w67EP0VyX9oPOOtjfSU91kWOQRsHoLFhtWL3LOKrDZCaaZ6IOtxJ6VRlfwN7D/tJ1bH13Xz+yegFYPKr9PLJkmu/w0csGEgDY7aI+zahQaiOKhwEuqM0BqaYx5fRiAdbUlggK0Pu0gm6ym/9pHoGR6jgO+Qxl3wq64WeYPUShOalfclXFl6fd1kx6qNVSS/DB0WdnbrJkCx2b9vZO9vO4Y5OsURqP/38aeOkCDPc9/t9Ure/Z/IKBgnOnGr5W2KijeJ3KxPzFTfJmpaEj0taKibnxaU+u06TPbqr6UjrFZBlQzS7qWVSfyCtxNfCajm+9zL025vzn2rFzUPFbXymOuUVcRKiUebk
 tVv+xDIC
 dkq+ppZhIk6FixM0F0n+llVH1aEmf98HUNpWZ6mZGIH8KP1Uot+Ko4AMPOo7ZHO2G7MHzDnX+jYHKmEow2TyFzrvvtCo2QkJ70fH9/B0MElIDNHI1i7xEfW+ENUJ3RuABSkVeB3dWAFFsH4wECpRxGXd14VQLwb3QFU3DlbU7cIipuuhGjYUGPt/VUFUFJdAoaZpZ5zpYxPPUdolo6kQQkhlasvVvI4OxVwcHZO0JD9ptAAQQtb3+mm+RQ81eYHDhgI3hUu9QsYpj+1oqD/rSQlDYtvSpw8j13qmbnaisXYzb1laRqXlkyADUzWExLxYRPLzJRhqgmSYs8ueACyRrls8ir5Tpcs1sAz4jTNMJZnFCNcJCKgWgjWzfc/XMoLzvME/DGRdkEgFIaNLF1yhIKPV/ijBpQ2Xv4AdfAvKF0OOIqPjzi9hVzKBuwllqvKi+4n7g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 50585192bc2e ("mm/damon/schemes: skip already charged targets and
regions") introduced a minor issue that causes the last region to be
skipped before it is processed.

Example:

    1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
    2. Quota is configured to process only 100 bytes per window.
    3. Window 1: Processes R1 (0-100).  Quota is full.  charge_{target,
       addr}_from is saved at (Target, 100).
    4. Window 2: The loop reaches R2.  Because R2 is
       damon_last_region(t), the old code unconditionally returns true,
       skipping R2 entirely and resetting the charge_{target,addr}_from.

    Result: R2 is permanently skipped even though it has never been
    processed.

Add a test to prevent this regression in the future.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---

Changes from v1:
- v1: https://lore.kernel.org/damon/20260831113735.3349-1-aethernet65535@gmail.com
- Resend since the dependent patch is merged into mm-new, that would
  help us getting AI review help.

---
 mm/damon/tests/core-kunit.h | 43 +++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 4a536d41cdb2..90b0fda34fba 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1632,6 +1632,48 @@ static void damon_test_rand(struct kunit *test)
 	}
 }
 
+static void damon_test_last_region_quota_reset(struct kunit *test)
+{
+	struct damos s = {0};
+	struct damon_target *t;
+	struct damon_region *r1, *r2;
+	unsigned long min_region_sz = 10;
+	bool skipped;
+
+	t = damon_new_target();
+	if (!t) {
+		kunit_skip(test, "target alloc fail");
+	}
+
+	r1 = damon_new_region(0, 100);
+	if (!r1) {
+		damon_free_target(t);
+		kunit_skip(test, "region 1 alloc fail");
+	}
+	damon_add_region(r1, t);
+
+	r2 = damon_new_region(100, 200);
+	if (!r2) {
+		damon_free_target(t);
+		kunit_skip(test, "region 2 alloc fail");
+	}
+	damon_add_region(r2, t);
+
+	s.quota.charge_target_from = t;
+	s.quota.charge_addr_from = r1->ar.end;
+
+	skipped = damos_skip_charged_region(t, r2, &s, min_region_sz);
+
+	/* 'r2' is not processed, it should not skip */
+	KUNIT_EXPECT_EQ(test, skipped, false);
+
+	/* 'r2' is last region, it should reset charge_{target,addr}_from */
+	KUNIT_EXPECT_PTR_EQ(test, s.quota.charge_target_from, NULL);
+	KUNIT_EXPECT_EQ(test, s.quota.charge_addr_from, 0);
+
+	damon_free_target(t);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1664,6 +1706,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_is_last_region),
 	KUNIT_CASE(damon_test_walk_control_obsolete),
 	KUNIT_CASE(damon_test_rand),
+	KUNIT_CASE(damon_test_last_region_quota_reset),
 	{},
 };
 
-- 
2.55.0


