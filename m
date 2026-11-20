Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DFE1606A51F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 06:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DrP6t8wt
Received: by kanga.kvack.org (Postfix)
	id 3DB5B6B05B4; Fri, 20 Nov 2026 01:07:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38BF26B05B6; Fri, 20 Nov 2026 01:07:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A1DD6B05B8; Fri, 20 Nov 2026 01:07:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E6FE76B05B4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:52 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 637FB1A0D64
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:07:52 +0000 (UTC)
X-FDA: 85454466384.18.D32C05A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D227240007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:07:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DrP6t8wt;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795154870;
	b=4JsXkz989SmkrWd0Der1ifRYb4nMTiACvyne2EKrKJ0HMyUoLXxz5atM4ZfgeHWNfY6223
	bFlGNjQq8dDya0y6Qre+2ACJd5UlfT9pYkVSMqW4qFrXNonFZZzs+Gt25cI/Q5AEFmnAHz
	vZDqn92hZUc4wlhd8YO1iUZC/fpfWUk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795154870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qskq9szjVa9XlNedP+qAv1YRg+a7vizmTmlvGZkJCUU=;
	b=c9ZKAgriUfvEH9g4B8i1RmdUaVe40E6Ok4qL34XkCB7mmeakRqOp+MLbnPwIJwp9vpPq79
	tVSReVmlZFyzO1adK0TFwxz3J/BpuB0puPbnRaJCo8LjJ2e8/tHXwDy6wTiA/ps2IvUwpj
	ZICqCbAKcb7ZxbfQWceI/L0pqskYCF4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DrP6t8wt;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 68DA3601C5;
	Fri, 20 Nov 2026 06:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036BF1F000C4;
	Fri, 20 Nov 2026 06:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795154870;
	bh=Qskq9szjVa9XlNedP+qAv1YRg+a7vizmTmlvGZkJCUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrP6t8wtbBsl0csg8WTSkxMKknFEl+bdBnYt6LASgO2kYYCF527kkkM2Eu3MC/km8
	 FMB253p7WriLRmuvYNZ6ybWaZEcyOqMzhLj6/rtuEWspqkMhp3QdVEBs93qDF0fp/o
	 E187u/U+5rlV8I3O6ssoHw1wrwXmVkBjKsbn9aQedjNzbjmiD6ETSOD8OtGlADy7QR
	 9i+RDc0cGS/TOWSPzMRUHoFZRgTYnN7PIUobjGaP7HIbW//dtEkH0j3soMSAf3jXLf
	 4khFiCDsliS7FrvLeepg9+2u7ndxZmdjJ0noW5Ssxfix2X7WP6ij5jLk2wlUDX30LO
	 mW8v6cOddc6uA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/4] mm/damon/reclaim: disable watermarks by default
Date: Thu, 19 Nov 2026 22:07:37 -0800
Message-ID: <20261120060741.92121-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120060741.92121-1-sj@kernel.org>
References: <20261120060741.92121-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D227240007
X-Rspam-User:
X-Stat-Signature: bh46ai4bcsydnj61uc9fibhzbkauhqoq
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795154870-382170
X-HE-Meta: U2FsdGVkX1+gQF1WkboiELz5ZSscDCmyT5oz1k6WANn0Uiq9QGlHjX1A6KvSt//QtQxtOA5wgSGpRUKIG/AhSvbmio1TEqzTSSfSaTMcAm2xGcHY/JWB0golAilGsAwzU8uf0JMXq/gX2FiSgFVYAbDhXvPcUApuRulFHJh671OFHhsrKu5/HajF3DiJu7FfnAJpAzDjTQhxMrYfbdxqlbxvbODLrnDbM1x28lZ06rI8Xc6cLnsQfdCORZZ6h8+ti+YvyxicKXF/h7IQ/k/tv5ngYoKuGa8GAbQ85uWt1LcavuIpJkluCou/ULB6u3yft256Nbovy4HYjkO82r/Ocs0b1EX6IuJts3e+TLVKRAOSyfqkD9kiGvYI6EpRHH6pHgG/jFAuKBpRH26XyQggAcVlYC3iVmXJJAJCiwoxiB/vQarHVFdIEMNADOvzif1iY2lvtjWgIIC+xbwL4rYubkQX6Q81UfQLsCIHBMH/HzVMDipPDQRe7f/w6cyIFn5hIpHLT6mQDXmFR/ECEkDSc2S3B1mMK4v4rHgDhPPSpOmyp+nYJXJJzAb1LOxzwWRZaF/whPcJ2QLAzi7XrtooJBF9V543tRpUZx1bZ587JzB6HB0xTndQcgUt6Hzapk5OfqsZtAdSWQrePTmbWMvklvrOqY841RbyBlGTKTPQibMMthdFjXTZ5r/dXpmZEXFKpKdMChuBwEzTFrxZxdjwxKkAHYcFo0fhx+umdYs9xHt7X/bOoGkmQanRCRlkcvuZYUCpvFbg8lX4VqyBc2snbJ3uNzw92wNNoZLX7SFZA8GckYBsHRaYEd13XNP2bDSrkCAEFCSPBdBGItdAPfd6wcYiqpyvnQk0zzEYbZdDtHxnS0keVZXFlEAlhzrVgXEfEZAfnWR/HDR+3eGqHrk0tHpecaaMNcOk6zIcEDSEEXMWeUCUI2FAwBartlDy25gRWGCEaKSCevoxSguxkqV
 lhh6o4/u
 obCsjZdvIOqpgbk6r45yYJFbcmj7F7uA6feIdcKld62LI1nrY6HxJnMdc2nsbGZCpXqhnWBQ6Tu2ZAqNQB9f60rkfReUmHzi6cywOKF117t9JNSPBkBrFqqUH++tPykXoz1cApbrWnHorb8fhPXTHKLRRX6PulRz5IKl0he7SiL1c2toIxMgsP8UddupAIONiMIY9N2EUHqH4FxVc+Ew8WEdsrb0PLKQ+qksk7sl7GUFvEHYO1IJLTDWeUg0ZKjr3AZVLr1GfE8mEMS9we+NDdaUZ4EgQr6/+ajeFVd3UsgsIykK/yuuJ6jBMaPzGAKX8nxLI0UA+d4GqyVrTKrWOi0csowMFCijL+xcB7yAQaZvSxCRW8+O2tRoTk3BKd5LGTRUfIM7L0UXNrJKCLCqGXTXkSXAWLZLoo3NmdKg9StNK8XelEOs3156oDi8ZzmtqvDjFSnc5Fm5Q5zE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON_RECLAIM's free memory based watermarks features were introduced as
a safe guard for wrongly-tuned coldness threshold (min_age).  The
default watermark values were chosen to let users easily understand how
those can be set and tuned.  The default values are never meant to be
used as are.  DAMON_RECLAIM is later updated to enable PSI-driven
coldness threshold auto-tuning by default.  When the auto-tuning is
enabled, having the watermarks with the default values makes no sense.
Disable the watermarks by default.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index d297b1596704b..a8b18f51e99d5 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -103,12 +103,13 @@ module_param(quota_autotune_feedback, ulong, 0600);
 static bool autotune_monitoring_intervals __read_mostly = true;
 module_param(autotune_monitoring_intervals, bool, 0600);
 
+/* Watermarks are effectively disabled by default. */
 static struct damos_watermarks damon_reclaim_wmarks = {
 	.metric = DAMOS_WMARK_FREE_MEM_RATE,
 	.interval = 5000000,	/* 5 seconds */
-	.high = 500,		/* 50 percent */
-	.mid = 400,		/* 40 percent */
-	.low = 200,		/* 20 percent */
+	.high = 1000,		/* 100 percent */
+	.mid = 1000,		/* 100 percent */
+	.low = 0,		/* 0 percent */
 };
 DEFINE_DAMON_MODULES_WMARKS_PARAMS(damon_reclaim_wmarks);
 
-- 
2.47.3

