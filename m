Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F5B1606BABF
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 15:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=g-ucla-edu.20260707.gappssmtp.com header.i=@g-ucla-edu.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=CZU0m891
Received: by kanga.kvack.org (Postfix)
	id DAFDE6B05B3; Fri, 13 Nov 2026 10:59:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D320D6B05B4; Fri, 13 Nov 2026 10:59:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAC186B05B5; Fri, 13 Nov 2026 10:59:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 889E16B05B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:59:22 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F11F58014E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:59:21 +0000 (UTC)
X-FDA: 85430555322.05.60068F4
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 14B64A000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:59:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20260707.gappssmtp.com header.s=20260707 header.b=CZU0m891;
	spf=pass (imf25.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 74.125.82.42 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu;
	dmarc=pass (policy=none) header.from=ucla.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794585560;
	b=osK9ADbij1hl4hf9y3w8vH+KuzZGnIt7dJ2zzYN8rSR44WmSwHFnsooO5hmgpLmXF4t5xD
	oy0MaBYdf9DRR/mTZjFWCNBmI2NwSLiPe3jHUjaQwmh+tIyt+/cjmgoDYTTu3o8XLnBQwl
	dy/AzSjKV4J93srJh1ER9yxhvzm5N38=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20260707.gappssmtp.com header.s=20260707 header.b=CZU0m891;
	spf=pass (imf25.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 74.125.82.42 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu;
	dmarc=pass (policy=none) header.from=ucla.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794585560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQfzRALCDpL4DLVl9bz2Iqb7R2/WHPaCJ3qKGqNNiOc=;
	b=kbPEyViH/iHd8vn80KnUoqTX6wvdZ8CqbegTqwShF+rMDR53UjW0CMPbaSt4V0XJwAOqSM
	BReiKcoWkU/0WTjEAt5mlY3FjJwaQCeQNfYyaI5SLUUhkF7/VN1aLO8YH2XpKe6Qh0SVeX
	7Sxs26D9u3G3MmEZP4LHt2za8y0eAek=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-14394530ec6so1366811c88.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=g-ucla-edu.20260707.gappssmtp.com; s=20260707; t=1794585559; x=1795190359; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CQfzRALCDpL4DLVl9bz2Iqb7R2/WHPaCJ3qKGqNNiOc=;
        b=CZU0m891krWWSrNjgZ07R2eejUUn0iZt/9bkJ4PUBHoDmzCK8bDmyGvlgxd4zVUpBZ
         z0ezIwQ3iDkL2lDMfvg85WKkLv+kNaKHa7yIpdGlH5IHdbIcvZEj0u2j8RcdmlBcBbY3
         bdQoYgZlk278LUjNmpFuPvH9D5q0/dXMimNyCKasha4SYphS5QQh0lAqe4H3kRixOHVc
         NDJdvQuo6X4OLUl5QTy7Lc47f3EwTlg390J1ENvmGWRyqUH7yDvFK5jJ7xzmynlMuZ0r
         z9BWYt7+gLgBMXA7WStmq7yqw2oxkQOkCzeGDkGX+tQDJi0M9HeMQkVFbMxQaCkKfwoC
         YYKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794585559; x=1795190359;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CQfzRALCDpL4DLVl9bz2Iqb7R2/WHPaCJ3qKGqNNiOc=;
        b=0z+GFhjBGLcX/5LAPKRrIuaiaq2G/WIRLawHooKFl090rfZFGVssDEPPAEJ7RVz2qf
         v9c5aHmgiQnJMhC9PBlFpMbqS6fEgxR2hBPlrGSRTAXw2qU0skUdrQCCFB81eSYTq926
         mjmUlR5jY05za7C24FgYI2ca9XFK87Y0DNsq7y9f7dtVt9yaacu2YORCgFMEmqPJEd6Z
         0x2xf0L+ulP6KTo7jIFR1tHfWh1aa8/xvzebnUdlulB49/yGQ0wlkOa3RF/lkLk1tCjp
         ivmiZx7YbESCO1zT0ynDl0Jndc5F6FLDfAISLSJCfYcErtDc/9uV7ozMHdiDj2vyyhDP
         Cr1Q==
X-Forwarded-Encrypted: i=1; AL+hErEFo4mYu7SRLSyevIuWfK9bA7ePphiI30HoHekc/JE6ZZjRM9e6/XGAP4bhS2RQkx5YWN5roHfGRw==@kvack.org
X-Gm-Message-State: APuU4Z/Nd78cf8UEHSzXGUQuM/+h8W1ndOoOjzq2qd+GOa8Nqfpgbu+O
	D+kNGXkTvHgHkVXipwcp2qyCHtyeoD2nvOAp92AnbnHuXNS57oyE/icuiE+Bu22f3nY=
X-Gm-Gg: AYBFou26D397qGzWLjKvWGZ033LHxtOQG2jh2UowK+SeZB4ofZsHsCq7hLj6i1AiY6r
	gFJlJlIlBldW2oAx2R1+ZT8PjcD+NXmIgRUjUzFdW4Ps/4qgQXUbQ4p8oWG+LOMNQPmQ0ysczdy
	eHtsD8T/qPQ5D5ENR1gUnCMNw//JXU8xyB1GIBYDDJ0RbgSlphRPQtgPtXvFXdGE1+k2D9Yk5QQ
	2roi+cUMBkptWTxLfX7N6v6V9pPd/kULzBipiXsCbzSRQZUxAalvHAjQVca16WKzPiULs9fBcKJ
	YPzzLqlG5u0oQzZgL5zI6yr+1vUr6zXlFv1GwORkyOwlzDLMlkQlLp8fTn4Ju4CyIvHSyjCEp4S
	BzPJLa29ZIgGaI8bptdllJZNRwsoEBk8k8/tgjpghvVJRbUMhqnlQrHjwFmtFj1A2Q1mOXQl71K
	RqR0QdNQF5eMRZz+fc87Abx+Jhx0/6QRtBBNDYsiBGdCLHRTfCHa1zMSvJOPPy+hpF00Wbv3Ioa
	LZBDcwC8fBnU/fLRur5E+vuOHFlPolrItKDx9rh4zCVneA/I3VAkmyIbpn852zpcZHvEIMpE9wY
	HplgRghJC6YN8pIbnsYIQYDuuU5UCQ==
X-Received: by 2002:a05:7022:f109:b0:1ad:4ef5:ffed with SMTP id a92af1059eb24-1b50313d936mr2385378c88.38.1794585558544;
        Fri, 13 Nov 2026 07:59:18 -0800 (PST)
Received: from [127.0.1.1] ([131.179.95.34])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031bc518sm7868383c88.15.2026.11.13.07.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 07:59:16 -0800 (PST)
From: Jason Angelov <jasonangelov@ucla.edu>
Date: Fri, 13 Nov 2026 07:58:56 -0800
Subject: [PATCH 2/3] mm/damon/tests/core-kunit: test
 DAMOS_FILTER_TYPE_AGE_MS in damos_filter_for_ops()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-test-age-ms-filter-v1-2-b99eab2f71bb@ucla.edu>
References: <20261113-test-age-ms-filter-v1-0-b99eab2f71bb@ucla.edu>
In-Reply-To: <20261113-test-age-ms-filter-v1-0-b99eab2f71bb@ucla.edu>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Jason Angelov <jasonangelov@ucla.edu>
X-Mailer: b4 0.14.3
X-Stat-Signature: 7nxenow8chxtgt9rge6446jzbd5csdg5
X-Rspamd-Queue-Id: 14B64A000A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794585559-247530
X-HE-Meta: U2FsdGVkX19x5IBAri0+qlgqyBwP2vlRiDeyLxTsDZuRtdqTino2/2QbmVTFUQ4CBq8ySNJVlvPElvp09eMZz0DKw99WZ/Q/+m+Mra5HXT5GpyDlAzxYCKfDbx6HWQP5yY/JMySI8G5gInj3CgdeWLMbV5jtltRClH4mFZz16fSu3N/tAVUjTWOcz2lbwJnnYmAo2/cCnL0eY5Oo5dHGQHZ6SpGViAEXpNaMPN23Jj00JbQb6mem2CiKY5Byz9fLQF1n1Lt084WTGfdMwmZVPHxGn1fpacaj+kiZphYNWCylMQ+4sV9A0r0xymwE1FDvUJVJjxqhBbZwR3XW62pI0H7ZTUFBm9Uew65iWBV/1fFRb0G2o+cU5IBt5nMLPHOddZrA4c/EelVMeNd+FHNIJ7WVxVIwsMnRKVlo0a74KFoybgoBK2CnHVbvjONbVfTRB4Ghy3veWvIc7xcmw0erpwvbxTIEEzNiasLE5ALXdwczhlpzOMEBPTBuV7syZWncAKIU6iRvJc3WzD3n5JriD4sJQd+bPKTS7P2Bhqucx60YwDYs4DUxFVyqsdSjEWVAkBj2WTwZhXuok+4hjtcxYXILqkqR05LpNhJQg7pQsHJVfwBUrg5D9vAKvqQaCZwcyXDGAyfD4M8pdxmrChOpfsOENhlZhSGFLQKJiEzmw7V5M/EA45JCZbiCUk2a3U6oi3eCOR4L45E7qvIZtMduRV7cJ5xUzXhGFfb38+zWxrfnCyFOul6dOWAFEDytNwr1J8ih0c4/6Wbv3zv3jSnoBhb3aLoRXrH22ouBKMgoFPMPlG6YKshVabmyGrXYvi9jRySgSgagpGWiP0nDyNR4r5cnyxT6+AUh7nh5gg6hWC/gS2OZ+2blalEBmJT9aiX87aBW7lKHJGMg3Oj9eIHM1gEcWgH2pAsNvGfMFIxHfGA8P58RTapwAXfbGi/qMhxARLub00gR53hdkCQIWsB
 hGifqNf0
 9tWM2H4JIdRIcp4ificjiGxQtqKTjJ9eTF4ZJGdaHOk8EP1N+/e49qTFsIJtR+ouWn52Q7PRdywzOYL6HXpqO99ERUXKnRAUvuuucQ+AWjwtHQ8a5JgLhBkHXoqlYmR+gVEIKKzQSiXydTJJzPqqxij6M3MbbrxzI5K+yDQbuyQbbiFKZx8Wet9XHWnqkIQno5Z3bH2fRtD2dFYmOExa5MtzFyJR5ah4YB4Za54Yh7RJH6m22eRnWRq/mmvlT9Kr3d9csSBncwNNVlDnBLy2KmFA78um5y0/ewB+Mok2NkzXP2i73wH7jq7cQgmeKXstmHhzdKdtKv2MigY6LQSFVKoLHQOE+g/0ZhK+T+dkb4CAKjvJC9469li5CSPu/QqyjrQlyj+mVuruH9iEdHhhmywUy9Qly0QzvMhML3m8dpcklnnFCLY0wSWCwBaoiiRh0uGJa0oykS4/Mlikodc3ssmf7IEUN1kEVytirDaUypcM+l6l768HCxM2WzU9e6ADg0dUN4kXV47pMhmrLYHvBh5m1CO0KR2I162ksTW9sw4HjiYtQpxeHFriGDKNvPEs1CvhXMgPP1VQL9QnTaZ9kWqGPWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMOS_FILTER_TYPE_AGE_MS is core filter, not ops filter.
add kunit test covering this rejection.

Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
---
 mm/damon/tests/core-kunit.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0eb5dcdba0ae..fb84d30a712d 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1832,6 +1832,11 @@ static void damon_test_valid_probe_params(struct kunit *test)
 	damon_destroy_ctx(ctx);
 }
 
+static void damos_test_age_ms_filter_is_core(struct kunit *test)
+{
+	KUNIT_EXPECT_FALSE(test, damos_filter_for_ops(DAMOS_FILTER_TYPE_AGE_MS));
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -2593,6 +2598,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_commit_ctx),
 	KUNIT_CASE(damon_test_commit_ctx_keeps_quota),
 	KUNIT_CASE(damon_test_valid_probe_params),
+	KUNIT_CASE(damos_test_age_ms_filter_is_core),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damos_test_apply_scheme_filtered_sz),
 	KUNIT_CASE(damos_test_apply_scheme_filter_sz_unchanged),

-- 
2.53.0


