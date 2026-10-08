Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3902FCA600C
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 16:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D6046B0092; Thu,  8 Oct 2026 12:24:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05F0D6B0093; Thu,  8 Oct 2026 12:24:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E902F6B0095; Thu,  8 Oct 2026 12:24:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6AD86B0092
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 12:24:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 446651C332F
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 16:24:20 +0000 (UTC)
X-FDA: 85299981480.06.E87B3F9
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf24.hostedemail.com (Postfix) with ESMTP id 722C5180006
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 16:24:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=kIEh5TwK;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf24.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.152 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791476658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5bPypBCTKYm/iwPwiaKupGULbBRaR6fxPaTi88ylUjY=;
	b=7+WsTN1qAYhkyRh7MopTDVrz96t4TrDoROgwgDyb2xYC/sWVolmVb/dR+yrnBq1ABS33Bd
	wjHLjbIRZIHG9iUxIYkpK1F9t8K7wCRb/yDZPVGayJ3jrBZO42WgroOhHSgmiTkJ9yHr0f
	rKbcvOxa0TOzOeBHI95S8Ron31YE480=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=kIEh5TwK;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf24.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.152 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791476658;
	b=X4RsUvM0nqknj7BqnWkknNbxbozY5U6HJ4011TTENtD1clpTznqNzIgquwXXHj+jH06aHN
	0VPxLZp2UnnQBNSha4q2sUzBF9GmSIAHp8aSorA37jU+TFubO9sVqffcSNYmqZStj0lDaN
	5+wwUSz9kXVsDFikJElgWeNRj2UqyyQ=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4j0wL72g10zKp3n;
	Thu, 08 Oct 2026 18:24:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1791476655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5bPypBCTKYm/iwPwiaKupGULbBRaR6fxPaTi88ylUjY=;
	b=kIEh5TwK6pPwT3BN773nkeSGSir40AOfj1vsSzuZYu7Q4Zw8KiBPvjAW/mDTs7TtZiurNW
	lczOG0VKMvB3oP7y36vnoW4XFxS2oRMKJbks0TIeTGfRjfWRyFubFn5xAmSw5DcdjmXB1p
	sBvVVgG99XMOgLgOO7ItpVCp1Bfe8bbcFfvvASJ56xH0tu1Er4mHR7dg2a1/ABLUyWst7e
	DTpbcyku/IzuyHq2N1zDxw43gP48UkTvckpbEf2mPEg5Pq0dnOhzmwcJiGVXdgFN7/RXmn
	6Zczo5kc79mrMmcLVNFhdvFrdoiUJD20HwNJkjbUxJxXMo86hrd+UeelIdxzUw==
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>,
	"Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/damon: fix typo and grammar
Date: Thu,  8 Oct 2026 18:20:10 +0200
Message-ID: <20261008162010.4010682-2-manuelebnerli@mailbox.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: 146527ebf00b3996ac3
X-MBO-RS-META: j3ekztrcsey7e6x4x3jgeyzcex9sg55o
X-Stat-Signature: fp8rxyexm9bdz9iw3wem6pnk44xkjrap
X-Rspam-User: 
X-Rspamd-Queue-Id: 722C5180006
X-Rspamd-Server: rspam08
X-HE-Tag: 1791476658-708223
X-HE-Meta: U2FsdGVkX1/vEY9KC1ByK3LfnCH4RGszjOzYjHowjMlngpsQ98oKv+cjYkLbrCm0DeU0MPx4l9RJJ19J/VqbiLoN3XWxSl2xNIcfaVMNNwsilKaLiISxloEYPhfKZGLAdAMoVfEoHn+d6E8vet0yUcLUtGQSwMk3IPGUQBUv7UxsxXdV3e6qKSFf2kCGNfnHlgQWvoTmUxIVfOQTFm5BC5WkpLZbQLnfqHb1OoUmUvHIKPpzybhHeFMo3GDYyaabslhBgNunz0Dg8PFh3fmsTE+sxAOqI6A5iQ05a05c97/n42WljzOE3et1xG+13T/f8vtMMueSPc5mL4/NdzOmVQNt0CTmC25OxeQqFMKFXtLKcdoTKf46hsu2HTa6Eh8ZxnRu+DuvgzyJHwQaBfwgL3V+JuTk0jVGztS5Ei1JZfSfNlTcl7r06lBIXcAJ4S+PbU6efbI1MB4O3yOmLw/NDuZO9f+oi1cg9m5DY8vvtJkqoKcqgc662x8CJfTxQy3CThwYaU8Rp77/VzZsetNhEGhsFY252G3fJi7LxkuH9VLoN7Ido6k+OKWbdvXCIntoHJIm3sGKj75su7DuH070+XJjtLev7rFPtzebrHxZT7r5Iyhk4flOJ3K2EHi1PJRTwkRqOOroXg01v2OLP5dcfjog2LaaAwpl9VTT4xvL6feu2TG/YN6VP6eRnT+3RJGSAygVmBD97dKqwNszQ4drAx3B5yTNfUwNlWUTk+DskpZyF3P2oeMYzT7nwHRk3rHAELV1VVj7wgfwdW1wZ9z0Cy4WV1R6/l+ENXRFdxjKKJ267+Idbq0S3s5QJkDNuzriOjxreOJV07yn1N2rjoRrkS559qiE9hC/zqydix6pKhdsWIlu+cHrEnat5mRQ2Dmb+XGeHCsWoaSfm/nhnunvS10nCSJuyaDIzVpZ1REmg0ilrW9Dsoiu9gsA54qr1kbPRv/3AlRxPr4yB56jtWx
 v6fWm4iV
 BLQj2xeI03tNwVaZklSbcVzr3/JkPc/Z4ndbdIQD3ejOpj7Svwur0Q3E5aqXzI/4eHkcF7RaFZ6q8MIC/CqsDePyXZxJ4HJOYSOZS/G9j7b66+c0lUepqLQ97nlCLdD3qEja6ZcSeno4Lp+ZykjncUQyIf1QoeL9pLRPkuNZL1VdSM//kRVxOXFthYlyEitVcqqB0ggWIkDDrV2q4LMJdbdqDAWYa8aQMOqEtG5eQUIHQ7OpsSzLccmtbQe1+NS0XJxFdR6IqNz7MZimt2lnb/j0t/ojecMuDR2y7yUfMWYK4sByps2UFbW5XOCEHpuPRQfkpQ8zfwAbIJAFRtC6fpKiIJT3rEV7Blnls
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RCLAIM -> DAMON_RECLAIM
set as -> set to

Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
CC: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
---
I hope I got the right git-tree. somehow there's 'damon/next'
and 'damon/next/damon/next'
The other patches will take a couple more days.

 mm/damon/reclaim.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 014b0779ea..a84cea070e 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -19,8 +19,8 @@
 /*
  * Enable or disable DAMON_RECLAIM.
  *
- * You can enable DAMON_RCLAIM by setting the value of this parameter as ``Y``.
- * Setting it as ``N`` disables DAMON_RECLAIM.  Note that DAMON_RECLAIM could
+ * You can enable DAMON_RECLAIM by setting the value of this parameter to ``Y``.
+ * Setting it to ``N`` disables DAMON_RECLAIM.  Note that DAMON_RECLAIM could
  * do no real monitoring and reclamation due to the watermarks-based activation
  * condition.  Refer to below descriptions for the watermarks parameter for
  * this.
@@ -31,9 +31,9 @@ static bool enabled __read_mostly;
  * Make DAMON_RECLAIM reads the input parameters again, except ``enabled``.
  *
  * Input parameters that updated while DAMON_RECLAIM is running are not applied
- * by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
+ * by default.  Once this parameter is set to ``Y``, DAMON_RECLAIM reads values
  * of parameters except ``enabled`` again.  Once the re-reading is done, this
- * parameter is set as ``N``.  If invalid parameters are found while the
+ * parameter is set to ``N``.  If invalid parameters are found while the
  * re-reading, DAMON_RECLAIM will be disabled.
  */
 static bool commit_inputs __read_mostly;
@@ -92,11 +92,11 @@ module_param(quota_autotune_feedback, ulong, 0600);
 /*
  * Auto-tune monitoring intervals.
  *
- * If this parameter is set as ``Y``, DAMON_RECLAIM automatically tunes DAMON's
+ * If this parameter is set to ``Y``, DAMON_RECLAIM automatically tunes DAMON's
  * sampling and aggregation intervals.  The auto-tuning aims to capture
  * meaningful amount of access events in each DAMON-snapshot, while keeping the
  * sampling intervals 5 milliseconds in minimum, and 10 seconds in maximum.
- * Setting this as ``N`` disables the auto-tuning.
+ * Setting this to ``N`` disables the auto-tuning.
  *
  * Disabled by default.
  */
@@ -151,7 +151,7 @@ static unsigned long addr_unit __read_mostly = 1;
 /*
  * Skip anonymous pages reclamation.
  *
- * If this parameter is set as ``Y``, DAMON_RECLAIM does not reclaim anonymous
+ * If this parameter is set to ``Y``, DAMON_RECLAIM does not reclaim anonymous
  * pages.  By default, ``N``.
  */
 static bool skip_anon __read_mostly;
-- 
2.55.0


