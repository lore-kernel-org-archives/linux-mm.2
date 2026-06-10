Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24130CD98C6
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 13:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3FAB6B0096; Wed, 10 Jun 2026 09:56:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92C566B0098; Wed, 10 Jun 2026 09:56:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869B56B0099; Wed, 10 Jun 2026 09:56:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 701346B0096
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:56:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F169A00F9
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:56:01 +0000 (UTC)
X-FDA: 84864151722.09.7DED255
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6420020004
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:55:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EIh1pLpT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781099759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=np27EpbpG+TlvGmhDpEg+i4zWgXnS+HKHhJxhydFuds=;
	b=AZQzWzwKNl2zorZmV83CmkkneHd+Au3v44MbMjgmMUCAei7ceRP4ZTFBvtScWfmrT1kN7n
	1+turp7bM1Q2niNPpDN/J1Ifr7HjWKMzSicYFmuQJWAYlelIHWMqp25CcYpHZ17sqeM10f
	xyRDzuNqVfGrPwFQYnk+wNOSG3zn/1Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EIh1pLpT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781099759;
	b=CbWhG04wfqO8QKYuSzslaAJkTXuvlItzSm+wv/m4ujkcuorVH1QVuMaCyw6RZBULMvsjyh
	pjat46gk1Cwqyf1PI1O01bMesfQ7k1xNbX69kYEkjUH05qkLcZ0/k155oTnypfsO3xukbu
	IBzETitrE1WxBfXNIILmUZBCSY/oeio=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A3C204463E;
	Wed, 10 Jun 2026 13:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9F71F00899;
	Wed, 10 Jun 2026 13:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781099758;
	bh=np27EpbpG+TlvGmhDpEg+i4zWgXnS+HKHhJxhydFuds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EIh1pLpT2Kntma9pyfpR4fjjgcl52ZD0EWa3Cz25JtupEDkZxy8Aja17UnCvyT+Pz
	 ny3Cri1QeNZb6hlymfZYRIqiZIJdBVDzg/HvDq8PDNAt2+sgTI74s+1QP/ceDS3JA1
	 ALdMpay/0c9/+Xkxxz0HygOZmYjmqJ9I27MNUCoS8SvF9eEl0u9b7p8bbZAun8IRp4
	 Q1U2bU+dXx8XyTvhbMckUINDlXcw9y50gaypzzgUS5UYxUVuIYYH3GczZRs/znh1g2
	 o7b/0dEs7SQWm6bcGkFIpmiWX3cAktuRBSuH5JDtDIAcanQxoIDIR4kwXaLKQVZrJo
	 Vr1fnszUF1n/A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 5/6] samples/damon/wsse: stop and free damon ctx when damon_call() fails
Date: Wed, 10 Jun 2026 06:55:43 -0700
Message-ID: <20260610135546.64943-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610135546.64943-1-sj@kernel.org>
References: <20260610135546.64943-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6420020004
X-Stat-Signature: xxayh3i58h9xrpckm4ez5zac6d15a76z
X-Rspam-User: 
X-HE-Tag: 1781099759-171030
X-HE-Meta: U2FsdGVkX18vGux4g6zrP0RzZSes19bLZhR03MoGMWiVflk75aosXsS4SLPBqgocAWN3qjm4pwYKy4D5TsisAN7PPLsjtk5MEu49e+czFcuUAbc8xfOGIUJMFFq+k8L6+3pMnJ4vdezkUR1k4tuTTXfzlyeMb+g0DgOCAFR7DkiYxV4oE3XlHmPM6NgzH+D1JU9tG3MAvZbSpdUokrEHteIO8CujfMBzCpSOx3LKGm/r0fVvW5oDSJae4R6ggUq7VTssaD8dntBOtl92BHGcrvk2wJeAG0xW37dxsd4oC1646aP0CDeZm4qgjgO09aAA5f2iDMESX/gKXkrNA+ijz7PzC99Jr0llwxzUoF07WK2QfKRvVsghZpIQKPQuKNyfVdPplxR/NdmVMPHeqi+tAhxtYxUQBjIGnVAAAUTM3UK6Wy73sahijJoEUKSur+1Pr4kKVkwmhLrU/ofEmvX2ttGL++mGIfuUcVjO5ABTaBMeUGc5+aVMeVerFaY+pt7QJyDzyM8cGzUwNsjzRlyGafzOVBsnHH2REcAefZnSm5c71CpD33lV4ng/5FWTEULZeRnXvM86YPiknZBYcPpnSlC/HyNlT0l7xH3IG8ckmP6UEBP6CzX/mS1m2eXATf+ueL+YgXDb6qxrY9rTPW81rpOGcLBV7GrC/zNy49wqLw1/xBvkqMJnT5pX8Jtw6psmvaKVP6o5/EWTOuM8cZ3kXddWlLErQa3IEAFYIzapIcDUmiqLKFP7BhdX3E00jeMZRqUh3mHtLkBl13dq1pjtxPIfTPa+8Oq1kvsMiEoc5EDQgQQQzv/ALowhpQkaX0Wk2hbspo855KKFQ7XrVmXXGH3ydA1OjK4cDlaLtSv3A1bewKCnZM5SqrmJN0suWEKDwu4fPgjnVhJ2Z1YjcEACl8H5+ux6aNENLU0RL8BZDi6KQXLwV9jc15C/odWbpGCP28XXO1vkPCSEF6qhHqT
 PMmns/pT
 cIyLlgnjtr95IINZlkOIAKmgwB1cwVOevtvbi3ndsG46xI+RkK/3KmMcGhACcQT1E6IHG8u+QbPjyqqpGH9QEv1hiWRtAVeBPrvD+4oiubiHFVjFstVGZt51uy+WctsrWswvMSVHjK4XdGG6NKs7ihxSRNmN501UDcM7KriVp5dn9hMVFma2V7XpbU/Q2nYcACGbGEQUeHearYk0pOTUsJqoF9C8LvhYsccHn+Fiq4SEaxaR0GxOPc8G3C5CQ8lh3x8fgO7bhyxV5ErPfWEal5y27OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_wsse_start() calls damon_call() right after damon_start()
is succeeded.  The kdamond that has started by the damon_start() could
be terminated by itself before or in the middle of the damon_call()
execution. There could be multiple reasons for such a stop including
monitoring target process termination and kdamond_fn() internal memory
allocation failures.  In the case, damon_call() will fail and return an
error without cleaning up the DAMON context object.  The
damon_sample_wsse_start() caller assumes it would clean up the object,
though.  When the user requests to start DAMON again,
damon_sample_wsse_start() is called again, allocates a new DAMON context
object and overwrites the pointer for the previous object.  As a result,
the previous context object is leaked.

Safely stop the kdamond and deallocate the context object when the
failure is returned.  Note that the kdamond should be stopped first,
because damon_call() failure means not complete termination of the
kdamond but only the fact that the termination process has started.

The user impact shouldn't be that significant because the race is not
easy to happen, and only up to one DAMON context object can be leaked
per race.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260610034828.4632-1-sj@kernel.org

Fixes: cc9c1b8c205b ("samples/damon/wsse: use damon_call() repeat mode instead of damon_callback")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/wsse.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/samples/damon/wsse.c b/samples/damon/wsse.c
index bbd9392ab5b36..ff5e8a890f448 100644
--- a/samples/damon/wsse.c
+++ b/samples/damon/wsse.c
@@ -92,7 +92,12 @@ static int damon_sample_wsse_start(void)
 		return err;
 	}
 	repeat_call_control.data = ctx;
-	return damon_call(ctx, &repeat_call_control);
+	err = damon_call(ctx, &repeat_call_control);
+	if (err) {
+		damon_stop(&ctx, 1);
+		damon_destroy_ctx(ctx);
+	}
+	return err;
 }
 
 static void damon_sample_wsse_stop(void)
-- 
2.47.3

