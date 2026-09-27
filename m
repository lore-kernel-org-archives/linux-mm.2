Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B253C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 17:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E40F6B008C; Sun, 27 Sep 2026 13:51:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 194C86B0092; Sun, 27 Sep 2026 13:51:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 087C76B0093; Sun, 27 Sep 2026 13:51:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D88846B008C
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 13:51:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A9361C3A61
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 17:51:58 +0000 (UTC)
X-FDA: 85260285516.14.9AEF266
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf23.hostedemail.com (Postfix) with ESMTP id B26EE140006
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 17:51:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ctaeZ2V0;
	spf=pass (imf23.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790531516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kwmzHbcrjIY/XcCe6sCdMKV/UzCFAPbJtQGnBjUsEZY=;
	b=i0Ph0aJFky28SZzUZXydGv2FM89gglebYTrkZcbMnVVXljmzhSKTkJwgfha2IAwZQoh98q
	5bxSl3LMiEewJtfg09otXBjetYGikMAItCAKVewxQ2ASxhYCpJJvSU4wrYz+7EOl1E5dio
	e2iuqFKWU28WlQ1BArhsQMz3PICuh3Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790531516;
	b=ZD39vxP8RMuVDMGsMnKpa0MA9+23HHG6gEQhkHPgzEkCeeKcrxqL+5LgZj/KWx6q7gzlfU
	GxoBpYliD+W6RCjRaPKtRV+qiFemrjBAqloPNy/r2PE7AgSwhUEUafWNTH/hJ1NwjwOHpp
	kiXtvfFidz3Q7an20v1vOShaqRdUfNc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ctaeZ2V0;
	spf=pass (imf23.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccb652d7so1493254a91.0
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 10:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790531515; x=1791136315; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kwmzHbcrjIY/XcCe6sCdMKV/UzCFAPbJtQGnBjUsEZY=;
        b=ctaeZ2V00gGYgiL9czfH5mE+fRcEPEqus4n3EF1cIczxu5E9ictuJ435ua5KyeIZVF
         P5p6YESf6deH0JuDfz1ik+YQgbISYn0guZUnheRZJtWxZuA698f27kWwrfgZl0G2x8tY
         KwJmgt5QatNFkSnn0Bojwxx32h2NsXEFaLfduD0+A8n6ASwJoTUcIjknlj3oU0ZGBrib
         9K1diL9pAE2baZmb2hqotfhC8/xA+2F+h9EE1u6F3OUdswW74uOPRzb26ociZ0kOSTY7
         uaPKFU1Ag435JYxUr4NU8gRIsa/e7DsdDXhncAIe4oqFhRMDJfKcKI/iaP4X+fLaccLk
         FlPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790531515; x=1791136315;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kwmzHbcrjIY/XcCe6sCdMKV/UzCFAPbJtQGnBjUsEZY=;
        b=v/wpriSQAg9ND5kT7sRxF9/MljLxbBYfpdt4BXLFBl6ob7Lzcbey8Rb8cGC7ZFLbwl
         tsfVau0IHoiUq4f4peCZxwe4aF5TWQP/MiAdFGqiXWvmz3VXl07mmZvCOi/RIOk/PFt9
         jYatLEYkgZMJUeBQ2wVswBbbyxavly4r2riCc1QVmClSO6o1u6mg4zzYVifzQLgdByEz
         ThaDkhHaSpiFZne+3V9XD2qIZ/mXvC6Xo8mUtx42cgWszpKZROR998FLcUumiMX6xFFf
         wVXHDieFKQx9NCf513y8+aIhsRb2zgXzDHYxqDJNYknHkr3qTVwpy/05Gz2w47dUi2C4
         Jz3w==
X-Forwarded-Encrypted: i=1; AKwUvBwtpzBdRuc53D6t7VkaORPgTvw5CPNOubGjoTtxc86uIbiAlG3OJta2KIU3kav4hoDS1S/3fm8+6g==@kvack.org
X-Gm-Message-State: AFq9FYKOMMmombSkN3maIif8iTRdB4NigjcBO4yYfxs8Zoz2FaWxeM0R
	HqbE0zxdXNyPwA7jGqFFriEmQjnRTESXhCDJrjAcUhVtTcecmxJiZeHjx8vs3g==
X-Gm-Gg: AYBFou1i3ChwZX9rnmCEy2YZENok5zSJFNxcAtaPnR9cvpQWqqtQHYupBpZZGpdf2J/
	VOxkGeGOcRIePrwC6YjbSbZwUldtosDJijK/F535D9uya+xO0FsIHJXBOfgDg5dAVqEWDCs1BNv
	NtH5yHt2tZAoJ3AlLgdLzT4vmEYZLJYSJuaTHdkNESBrqtP23zw+S8m/OTBN3iPRZ6kopdEgHBQ
	6Y3orzoLWur4+T9qjGI3bSQajL31WeN0KsIIcZJs48Qn4LVEqp+tkTO5IjI+q9W7XAxic/n2hwB
	2iNdG1lU/BISNizRdIN9hpWuEg6k1JwTVGWMznPbQaKbepWod71pi6jVwMLoY7ZI6EfsoIVtmvw
	7E3cxTxebVZsZQhZXUBo2C12BEtYSgiy4AuY7Tf2/5ERmFnLaLEpUolvLxF3FOHGwYCyL4v5sbv
	WfQemhbi3Rk9Ze3++AqsCk1SFVle34McrcTzw7yHwoQHVK06yW1ksVUxTUU6N2vLcIG2p0Pf5xz
	AnAJ8oek5c=
X-Received: by 2002:a17:90b:440c:b0:3a0:c8e6:ab30 with SMTP id 98e67ed59e1d1-3a0c8e6b9b6mr5659510a91.59.1790531515391;
        Sun, 27 Sep 2026 10:51:55 -0700 (PDT)
Received: from celestia ([2402:1980:867:387a:70b:38f1:a1dd:9303])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b9355e54sm15597784a91.5.2026.09.27.10.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 10:51:54 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm/damon/tests/core-kunit: add test for unconditionally skipping the last region
Date: Mon, 28 Sep 2026 01:51:43 +0800
Message-ID: <20260927175159.60703-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B26EE140006
X-Stat-Signature: ja5c6nnbftptph8br6skhzey6f1c38b3
X-Rspam-User: 
X-HE-Tag: 1790531516-960824
X-HE-Meta: U2FsdGVkX1/dbsZBOumByqOuu7YK+MCn4pog+0mZ2TEYlyc8rvB7vRmdoKUKjSv4AfzxW7oKStKw7bVKpiQI+6JP6QoYHQqKwcXSBfI6q4zydBb7cO+flnDwi7s+Um93442imqY2hWijPbhQN8e59ItaCcACwhafSXrz/fvJ+eCFjTWFdqx+QlsfQZ4gXMyMWm8XCt1B9oxc5akhPs5o2S74Y+R+WtdQhlD+Dqj5WPoy6xKDsqx1cJC/EW5hxcd1Bq9LbppesLNZ2u4m9ghydvSKSacBpV++OsKYDbJfSMIDWR6je36h2ImFqabWamSqPM7VprrxatslPbwUAAU14Dmaxw33lK3i0YVg6zBflveBwn9mqduUZzogtGY6jeN/q/IIe++rT+K+ALK37xZ666pz2g8G/FJKNh6INCG88TvxHKmd83CoFE2gJRtVhA+hmRi+LsS4nK/ebCf5qwwomhVMQ0ouekmt4Dt5cvmUwktAfWM+ehHJcHioTytwnVQuvKtYEBzHeSwGBYnGzN+qPn0qcKId4j0ugY4AkLKYniCAXY/W/RpHCmVo4RekFP0lN0J9Jnc+DolRTh3qNOhW6C0hbrtp1KgC/7CqPN2ipEjB7sJYv4xL+36l2d5gg4paw8L2MYjnf66zMp7SIs0zwQpS1HZDtI8xWXKVxe6/21VSxd1xtv3pZ138HPv3oBpqFVlKX443RJEHra1LsG6dEuFgiJ6nT3USiz6gB4efR59ITHfpjpfZfoEiGanDb8zngQHv9oYjsjbryZQ+U+Rc1v74wbLnaKrOMpkRpwSu91MP9ZYL6KM5G7si4d63EKlt6Cbbd8KQisBG04zg+edQVbDDT1c40W3eoyTRFKSsi75yFnwVlYvTq0Q9QnZFXqAljViEkEuyDmMFbAQpexmVlKOJMbGOmghbx6xL2RxWuzrAMlCUko5JBNTjiNv+VunMY38rWXRjDwQVc5f3w/A
 Ly/hlaB0
 GkvP4dDrBGFk6dglEBoFwFRFtDEyy+7xsNIfbr4BSnW/w11eAFL7bAOd8HRGuvY1N6tViindYnrGQbMepXJgROLeVj6oVGnE6fY2FZ/M8cynMaWo6l4F028h8aatZunmG15M3WEr5lhFZAsDpS1NXoKvdb0pRPqA13/8+tqNRPLW/vIb5W9DofZ7ZK3lYdumj6Tk0CFdszPeDaneuiLj+Q+kgDkaVEHP8jKVbaske8RJ8QaKfRWsc/n34qmtOHZ3+gWAfOjTTKdtaegZWtL9QWa2RXaEoOt1oDNPf+jdyXNpy07nlMUkU30QpJIdeGS8DnaJLbnTpeF7oLQW/2TlTyhZFQT8UbIIpRfOqFAJ3ysVR7GjGTYm8VPUej8N1mclMmYbpH0GdyLvfUWrXsJFl47lGxwnG1Yv/wSYdkxk6SuoA2q6+Xxabeq9lhksgljjml9wqksxWYc4HtarA/YFYBZ1jyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit b3723b596b54 ("mm/damon/core: fix unconditionally skip last
region") fixed a minor bug.

Add a KUnit test case to cover this behavior and prevent regressions in
the future.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---

Changes from v2:
- v2: https://lore.kernel.org/damon/20260925045350.66595-1-aethernet65535@gmail.com
- Change the commit message, mention the fix rather than the original
  bug.

Changes from v1 RESEND:
- v1 RESEND: https://lore.kernel.org/damon/20260919080453.628679-1-aethernet65535@gmail.com
- Drop braces for single line, as suggested [1] in coding-style.
- Set min_region_sz initial value to power-of-2 value, '1'.
- [1] https://docs.kernel.org/process/coding-style.html#placing-braces-and-spaces

Changes from v1:
- v1: https://lore.kernel.org/damon/20260831113735.3349-1-aethernet65535@gmail.com
- Resend since the dependent patch is merged into mm-new, that would
  help us getting AI review help.

---
 mm/damon/tests/core-kunit.h | 42 +++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 4a536d41cdb2..f4237436e1b4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1632,6 +1632,47 @@ static void damon_test_rand(struct kunit *test)
 	}
 }
 
+static void damon_test_last_region_quota_reset(struct kunit *test)
+{
+	struct damos s = {0};
+	struct damon_target *t;
+	struct damon_region *r1, *r2;
+	unsigned long min_region_sz = 1;
+	bool skipped;
+
+	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "target alloc fail");
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
@@ -1664,6 +1705,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_is_last_region),
 	KUNIT_CASE(damon_test_walk_control_obsolete),
 	KUNIT_CASE(damon_test_rand),
+	KUNIT_CASE(damon_test_last_region_quota_reset),
 	{},
 };
 
-- 
2.55.0


