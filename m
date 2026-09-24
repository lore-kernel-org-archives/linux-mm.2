Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E3ECC9831F
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 20:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 448506B0095; Thu, 24 Sep 2026 16:16:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D1D76B0096; Thu, 24 Sep 2026 16:16:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0C46B0098; Thu, 24 Sep 2026 16:16:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 050B16B0095
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:16:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04530A6129
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:16:36 +0000 (UTC)
X-FDA: 85249763634.25.8CE625A
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf24.hostedemail.com (Postfix) with ESMTP id 37B66180004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:16:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="hGqvi/kH";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790280995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNbMPD2l6k45HjCSlVyW5ug/N5eQ+jTGtlCh88p1xFw=;
	b=ZoTanM5llV06QhS5uWj5tQ+MVybfIxow4PSBGWbssXd4Hi6RcnVguXg44zLdlcRIDJfxip
	9YmL9sZp5XTlqoFqkW/I4VmfCuJpZI0ipN+xlQIJI6gJ03RBATDytZXyjSLdyITlT985jl
	+wQJqUW3j3/Yhu/AoMSIyhyxpTnAr38=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="hGqvi/kH";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790280995;
	b=VBiVSJ+CV+sTUTAT3+OtW/yO/ukpG7tcjQMGRmX1seHAVCXTIzQhV0SB0jvzm5DAlgLKiR
	19Hzdwu4LbjrNQKlRf22S92o4gpxTs3MSMvsZlcOY44M0k7b2V8h8OJWbm96jHmdSBbe08
	BHtjQud+LJ9rMJK8rGm+3lpbZ27g/HY=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd38e0e5dso2777415e9.2
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790280994; x=1790885794; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wNbMPD2l6k45HjCSlVyW5ug/N5eQ+jTGtlCh88p1xFw=;
        b=hGqvi/kHusl8HGhoPKdWlRCCVLLI9zVB3Rl8n/Gr+jV+t1rcDzwfn/MYYVQr+lEvQ5
         O6FGe6ni8F0YfMmRTHO+xY4X9ngpHrnhkcv4Bl7dL+pbu4Et0UWD9UEz5T99rIriOjF3
         TTaDIzLFr5yFCtpT1NfGHjd33OThxFi00KScF9xoRDriJUiWrMyCorg2QVmKfadamCs0
         KatZU9WfsFKUUk6Z2uNjWFXAVuibuF4yNdSo15kZ1riH3cR46U7EUdwtiGA7+b8qiNTo
         CcDmZICN+uwKmiivObx3l88YCSnKUoHFgDI1k+mzvc96VBl3YPqlabj63mvc7S9baPXq
         jS6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790280994; x=1790885794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wNbMPD2l6k45HjCSlVyW5ug/N5eQ+jTGtlCh88p1xFw=;
        b=q4ogcwFrAn9dvMDz+pD3bQzk+wG0LS5Rmme7+DB1KnDUGXcB95gK+A4IwlqbnSamVV
         xM/SobHn6DQ6+vvvO6xKnNlOtTqJQFNXMKi21jpKx7pyU+MQT8jyHP0ighhotEkPBBCE
         6YH6Tja8B07t7BPmIJQJyEYA1hGdSjLQuN2kMrMGKxb1ZO44k3MNwEJihV7APAOjLNYf
         Ja+Zx/HIlgUWZQcWOsFz93bjdLTZHW9Xpb1H+VKPaJvw5Q7LS7xIxpDHOsbCn6Pq9vGj
         Z+CioPxlV0Qv0BqlUtBIdytQkvNKZ2g4bB7a3QQaSbI2mY/EWFcv0Fp2cb6YD/PZG4GZ
         hrXA==
X-Forwarded-Encrypted: i=1; AKwUvBzWyLHpPGtLCiBK7oUasEdSen+6RTfVj8crd8AsYIO3kiUkkFKnXkWUUr0auD+CYLaISF3M0dO1GQ==@kvack.org
X-Gm-Message-State: AFuF++n9EMYnst9UJpxrRkqImDb/3du0RV158PptbLjLapHJ4JAUI/78
	VybRFuZ93wTV7BCls+3vdSZnLx6dUkuPv67wLftbc1TsgModht6Wu+PB
X-Gm-Gg: AYBFou2KGoZC/BGY7QfVomaigZi2iSL1A6DgeqGw3/7CLvAG7lZNOgsJ/orNXmjsRb0
	uol3mMc0NXFh7pLkJIx/fKTklWzDp7b4r26LrtAsaO6ZM2FJDwJ8qNdIzbui1aXRsXUEJEEOuiH
	8AgIrqiUaGYQ9BuYDxFxeHtPObOr2i0Ejjp2q1QZtuGIZBb+YHMEd5pMDHmaDb0Sh3Jb00INg37
	7P0COiQFG9Uj26lUbPEfn29dSpQR9s6wKeXevTyO1Ih9lXZZkTvMV8//mSLPFz6Lc1EMwgMChWo
	7zofT8abxCj3czm+A0/dAoo9JyWQ3fE4IdeQi+C+6zlwfpHOI2RvPKGtS+fls0rEWs8mWeu3CcI
	X9JShpym081hS0ywXWCsbyLHgcAMpauYjGo9cvQRNOo6qOC2LlUyEU8zhDk8Db/9UfihzxAkLRm
	7wx3xmzuL+qcyJ2NqpUga4/eiEmvz+sl9xDamLRPY7RxgeoyUwyhzeTw6RHxPCD+cPcPz5bC2te
	Qk/q+QrSln8q35+pGNEJyEdfVwz1qhiNXzlqtcD4RBX6nOL7/iHvZqxuX19dTupidC2fK3xNehE
	pykh4vjPNykgPVMSFtAPbH5OeB3w54NMh5+xYf9E4jbF6zvNzUAomewqM2zAwVV6c1kD4w7xq8i
	99Po6Qrl5NT4puAsLsMpTdyg=
X-Received: by 2002:a05:600c:3e07:b0:49f:d6f0:6f24 with SMTP id 5b1f17b1804b1-49fe66cab70mr70945335e9.2.1790280993575;
        Thu, 24 Sep 2026 13:16:33 -0700 (PDT)
Received: from MBP-von-Karl.localdomain (dynamic-2a02-3100-adbf-6901-3138-76b5-e9f7-b9cf.310.pool.telefonica.de. [2a02:3100:adbf:6901:3138:76b5:e9f7:b9cf])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe5dfa6a7sm144818795e9.12.2026.09.24.13.16.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 24 Sep 2026 13:16:33 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mm/damon/core: preserve the quota passed to damon_new_scheme()
Date: Thu, 24 Sep 2026 22:16:13 +0200
Message-Id: <20260924201615.4478-2-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260924201615.4478-1-kmehltretter@gmail.com>
References: <20260924201615.4478-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 37B66180004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: a5iw3kk9ack16t6esob76zmg8dn3jjm8
X-HE-Tag: 1790280995-996191
X-HE-Meta: U2FsdGVkX18EZ/Yc+yruGmxXvycHf1Bs9V1F6Wa/IthRVUNtC/p3/9RYQxr7LR1O46mQAaSXztRoWSoRQIuUHuBGM5YvO/m4Uifi6MOzcHXiL0dh8MQ1rtAhTRpfDB2lW9g+bFEwWGZn5e2NH1U3TTaDX0v+gUy8wFOlR/fwkdlBQfhvu1tNEY+6GZV0AW12QeMpirsyVlevhBCNB+FXq3AwKRaWtjMk/4/CIfEiQ1wLWTVWx/1hF54NuDA7dZQTUf2bIWOlMGyxWiiHLxFFA0i6DfTiv6X2oHakxsk5yCcshaV1nSW3jhPrDEjVTtsW8h35uxSODPErnM/yzVDoBkZBkXY972qZTpl0r1Qd8Mhxb3L6WSRSiT4YHhuW+9RUn+CStB3jkqR8BdYQ6IgwQrwAYEJCDsJ8nfn9pcG1zNvl6Y/7kWsKjTdvCbyIPVtsOTO6YnAL7RjO4aUXkI9GKeuI22Svzmwk868HVnHMTB8KYvIdqkTxQnd5RkE+2tYyCgOWWLvaDKXrIhl/6WXYB3jXhtLCrVEoDRWse9rtN00JWhjx13QNQOOWrhewZNyxRq+foQ/Lf6VNoo5kS2UJJh3vf+DVXA7S+Ck/DMcTfihMm8cfFdo1b5rfqhdgQM/OZ2Yp5QCDO7n3zkpVLnCMzWFF2chwqk8kJDL/bExU/xNg5R/f7YZFDOfafAv0fJKFKHWD5B2ucr5PpfA6zba0kUaiAtNeAmV+6e3WKFDnLziuLIDhLyMW8E5jsMBl/q9prz904DGFV4TbXHkcouQ1gKhUPH83YSwPaJSm5SyDyDuQhOOdAjwkYSrdF2NlVJeNtayFm6zk7UgMeLjl6hcvdUMv57PRyl4O33jJw7bd8kVI4NPAnsfWUoMQSkDHjyzReZDFTtRyejIcwo0BHF6UWZJnjnQ6Ja+VSHeXCKu2b44KTp+sVacmHndSXCZ7/OSo/9w2IQ7Vse7/mGCFiLL
 PXWBq/oq
 9qC4mG1Ku80XE4blFc+VhpBEgAy2ED1xE5Px+18SielBZqoAeBLUvDlYr2MmpN55CMmh6LREI8ScAffAdvjVoOqDUad6HyIrcddAWmB+F7vab5xwMqID8OOx00rfVFHzMcqtC3Tyhdw2H/VAEXqHgHUaXH4FScjCfVACDLk1oNywZl/lQW5E2IO7tBAVmBgfuqiBwYJAG95tbp9GEakcA2R4JT1fWrjnyI3Ip3jcmtXk2LhNj+HLKzNq+UfCFRFB+44YwzVm4UimvzYYr637F8Yu/kdE+OS/mVH4jSdBLkuhJNCgx62PRQDtxbCVHeq3CUYeqKtI37hJach8+CDosBhBnmFgQxGbak31b5VjsRt7as8Ro3au81lm2rlvyTfgHpt8q9Bh7GTdqlLxkVtaQh/RTGQnDoYBb24lU8OxuEauIrp4frxIFffQOajjMnPu78t5IhlRQk3YpgFrcKJYTJR4yzBMqUktd/opeUpuP5CJKg/Xyj0Sl14Pzu85xEjwlOJXU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_commit_ctx() first commits the running context's parameters to a
temporary context for validating proposed updates. When
damon_commit_schemes() creates the temporary schemes, it passes the
running scheme's quota as the quota parameter of damon_new_scheme().

damon_new_scheme() calls damos_quota_init() on that quota before copying
it to the new scheme. This clears the running scheme's effective quota,
feedback input and charging state. Even an update rejected with -EINVAL
loses the running quota state.

For a size quota, this discards the bytes already charged and allows the
scheme to use a fresh quota before the reset interval has elapsed. For a
goal-driven quota, the consist tuner loses its accumulated input and
restarts from its minimum input. A time quota loses its throughput
estimate and falls back to the initial estimate.

Commit 60bd24f272d0 ("mm/damon/sysfs: test commit input against realistic
destination") introduced this problem in v6.19 when sysfs validation
began committing the running context's parameters to a temporary context.
Commit b90408ef1163 ("mm/damon/core: safely validate src on
damon_commit_ctx()") later moved that validation into the core API,
exposing other callers including DAMON_RECLAIM and DAMON_LRU_SORT.

Sashiko reported the same side effect [1] on the RFC of the core API
change.

Copy the quota to the new scheme first, then initialize that copy. Make
damos_quota_init() return void, since its return value is no longer needed.

Fixes: 60bd24f272d0 ("mm/damon/sysfs: test commit input against realistic destination")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20260702212143.0CB6D1F00A3D@smtp.kernel.org/ [1]
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Changes in v2:
 - Explain the running-context validation before the constructor side effect.
 - Clarify the quota parameter and use "commit" for the context operation.
 - Point Fixes to commit 60bd24f272d0 ("mm/damon/sysfs: test commit input
   against realistic destination") and drop the stable version comment.
 - Rebase onto mm-new. No changes to the fix logic.

 mm/damon/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4687b909d42c9..f76333f26de22 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -734,7 +734,7 @@ static bool damos_quota_goals_empty(struct damos_quota *q)
 }
 
 /* initialize fields of @quota that normally API users wouldn't set */
-static struct damos_quota *damos_quota_init(struct damos_quota *quota)
+static void damos_quota_init(struct damos_quota *quota)
 {
 	quota->esz = 0;
 	quota->total_charged_sz = 0;
@@ -744,7 +744,6 @@ static struct damos_quota *damos_quota_init(struct damos_quota *quota)
 	quota->charge_target_from = NULL;
 	quota->charge_addr_from = 0;
 	quota->esz_bp = 0;
-	return quota;
 }
 
 struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
@@ -776,7 +775,8 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 	scheme->last_applied = NULL;
 	INIT_LIST_HEAD(&scheme->list);
 
-	scheme->quota = *(damos_quota_init(quota));
+	scheme->quota = *quota;
+	damos_quota_init(&scheme->quota);
 	/* quota.goals should be separately set by caller */
 	INIT_LIST_HEAD(&scheme->quota.goals);
 
-- 
2.53.0


