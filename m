Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47D9F1112246
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 01:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D9D6B0088; Wed,  1 Apr 2026 21:05:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A72C6B0089; Wed,  1 Apr 2026 21:05:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695766B008A; Wed,  1 Apr 2026 21:05:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54DBC6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:05:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D0CE81A0338
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:05:02 +0000 (UTC)
X-FDA: 84611821644.10.1F7FEFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2C52E180010
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:05:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uav8uHAU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775091901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=23SMw0BWNBMbaRBBTGOFpZr31Cs4EyCeDVghqwQB3O8=;
	b=2llfmJBGLdBL0RdMg+WONVksXEgcgxfcg6VP+9EsKgMFo9fY2ZWDr8vMzeYO0U2SOfqrLO
	YNgu2NVmWDEoh8CLsd6O+XnlYrkZCvNdAyOGFETa5roMYwXmsCY0cUFlva5MfwWQD4G5q9
	6+0rT2+z7ytQSN3U7Qo/QVoiBfZubnw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775091901; a=rsa-sha256;
	cv=none;
	b=aMpksRg7SdFNhOe/upE0tKFewiqtjFErpZLkoIQsEq4Q+xpXWFx39U6223/Smr10VBX4dv
	dTJGKjKODapft3OzhgjRYrgvy96vizPdu6tlOOwI4wRqzApwHD0/24JpfpQji1oXSUqsSD
	z/yldwIOdaeaEkLVv+6LclHxK27V9Po=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uav8uHAU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DE2324419B;
	Thu,  2 Apr 2026 01:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EF6C4CEF7;
	Thu,  2 Apr 2026 01:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775091899;
	bh=e4BniEALtKj2WeE8HlkohnCEv/JIv0ZTg/5k1eKeGFs=;
	h=From:To:Cc:Subject:Date:From;
	b=Uav8uHAUSjEDjDVXMUiKwNs31B5OATnzuQSyA8oEcn0aYqDpqHpbyOLbjZkaVJp7W
	 4ipgcuJVp7JB3X+PJBEN+wvCl8XlHt2ZBEF27SqPKTgCoYtJ9p1d60pzyckz1OLvlO
	 riitWL8qytEMQXMS++cW1eLJ0l0C02N7xNNll80GrCKpASu4Kw3uw01qrTmwT0xyrl
	 M7YnVBqK6K7i28hyqR2LQ545bhXWDE26MJhpfMReBLH5z8NSmeRVbxHxeSI23jn/zF
	 VhxfI44jdVyJThMxQMvgUzG/JEGiFVwIvMImTwdBK/M/zwElBlqx8Jj0lzL/40PKNJ
	 DhrKx26vIuIlQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
Date: Wed,  1 Apr 2026 18:04:55 -0700
Message-ID: <20260402010457.66860-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2C52E180010
X-Stat-Signature: f1y897kxprpai85ug79wtrxz9qqbjuxc
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775091900-240112
X-HE-Meta: U2FsdGVkX18nDpotqs8mONtJy/owkBJx7aXsSFAfTxotqX+hM2VfK6tLesDorkpFN6xEAKWu7dPwzghV809gQFAB9CchPcBm5GB3zyaBD3kXxXr4DlmLSYu6rI08XcCKZO7wHmppTbgVLlmqlCfMbckTpw3yP2oWDYkvCAQha3yfISB7LXTIRvenVd0h9e8xXzpnTv7F7mKewryIVJQgCUxe1dkV/PgXruhpFazcHXwHuNuUjpBJwfRk8La/QHFR/bs+UDrRcDGQ//lKYGJ38iIOD1NLTdHWcQ+2rW4YvJ0x3X3o6EztCNXW/6fIxcPFnQIItayEpB41t/95K9IU07fmNgTYObnUZl8Wfgt2alfcMqfkqCzUNvS8ZvqNZVI/InyLaS31q8jgOXPU2i7uE0oYZKHhapCPFQnBxH6wLA8SNrTT7zYADW5JI1PVHzffv95+U9+jPcG05aa4lml8YooZSS2GKo92UZD/EnzK+yNCOfNbLZwbYQRXPUj97CuX40zToGgpYJxfJLDJY97r5yKKjmwZid215GRsBrOeOOa0ogbxagq2nR0gDD4vMjDtcOw3anu08UtzhH/8lmomVLA2YmqZnwjeIYzcmNdXetzC0J32oQhzPmH81GyqT1dQl4/APPnIOXM+VMN/liiqyiYjuwOpYzLzsizbogAGqa0z6UnajDfLTEucIB5zaiIzPxzDKDfx1Vgs5tj3+TsYgwVAgGSz+rVD7bHUHiwcjc6wRoyKM10keHWptDbBqHuSU42OIMYT+75GB4nNLcyCkeEM2cWwKL9EJrYfquUTPd+e1ckb2uvwdBIwXyfZgiPLj4N8jaqsXru1iOYjdn9l5uT0gXvpAklYFST3nWMcqvtc6j2qEBVdttgDxoM5K6wOLuYP73ZdrHblt0nYMjSByBJg0DbCbHIKHnjNm/1IwsZuY2seKC7u37w13oMq1IuBGKkykvCOb/1DRaXJkhI
 kKr+z2/m
 DvBxtbht4TlIGnpCoQQ2nDgvai+yZPkoF40tnPKTogOx7GTKu8XLQ6N5g2ozHnuyk8nFRwJvGToWXhGBm1CkKYL4GEB3971Ondjbn8pHazHFqXP93XGHjXCE7dOCyYG1sPHuKpfLelsmnKBHJtLjyQ/oJmByJm8HKhUhFbO939chcUa6KaBfITArVG22bontViV06hmcfRWoP3lxlQCK21WAeuFjJSAQ710mB3h1We1Qz5lFb0kcl+vwLejXrIWpgYilOE7vOVYQc4apsQhEbjwwp5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_STAT does not deallocate its dynamically allocated damon_ctx
object when damon_call() is failed.  As a result, the memory is leaked.
Check the failure and deallocate the damon_ctx object.

The issue was discovered [1] by sashiko.

[1] https://lore.kernel.org/20260401012428.86694-1-sj@kernel.org

Fixes: 405f61996d9d ("mm/damon/stat: use damon_call() repeat mode instead of damon_callback")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/stat.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 5a742fc157e4..30aeb2c207ec 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -257,7 +257,12 @@ static int damon_stat_start(void)
 
 	damon_stat_last_refresh_jiffies = jiffies;
 	call_control.data = damon_stat_context;
-	return damon_call(damon_stat_context, &call_control);
+	err = damon_call(damon_stat_context, &call_control);
+	if (err) {
+		damon_destroy_ctx(damon_stat_context);
+		damon_stat_context = NULL;
+	}
+	return err;
 }
 
 static void damon_stat_stop(void)

base-commit: 4fd04f750d79667937931314ed64c9d79b0d82ef
-- 
2.47.3

