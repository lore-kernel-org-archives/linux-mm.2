Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BACC4CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 07:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24A816B008C; Thu, 14 May 2026 03:49:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FAC16B0092; Thu, 14 May 2026 03:49:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1119E6B0093; Thu, 14 May 2026 03:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F38EE6B008C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 03:49:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C66BB1A0548
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:49:34 +0000 (UTC)
X-FDA: 84765250668.10.E8697E9
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9E3601C0007
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:49:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ghy2H9bV;
	spf=pass (imf18.hostedemail.com: domain of niecheng1@uniontech.com designates 18.194.254.142 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778744972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pKTqojM/V0cbc3/HlhyNeRdXjdESyH/Mqh9A6SdRWzA=;
	b=BFt7DhY7uhI0tvCyQOKX2WciGxEOG3+TsmlnL2jgvBOJUgzKbD41Y/11px3C1eqg+K3+R9
	1Xi0c9yJ7ELO6gFbzwfPDwshsGjB54bEW5pXVeVsYNRGFa7HzjKcZxTFqWCe5lli6+kvdn
	l/QmogPV80kUCe6zYI1/TnSJf/nySAE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ghy2H9bV;
	spf=pass (imf18.hostedemail.com: domain of niecheng1@uniontech.com designates 18.194.254.142 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778744972; a=rsa-sha256;
	cv=none;
	b=yafICSd3RDzw6M30VhMZMuZIwSIIP7d8QFP8mpWq9GbTEyYX0Xz/hMk70o65149mppfKmT
	hp7zYe2+1L9M0ASQQn5LAuapQfHCHO31MLxoEskoWba96q1xPqAczBkw3UxIRVRfFX1O45
	SvWyHsX5RnUVfPeLzCfw+IbJWLrNJ/U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1778744950;
	bh=pKTqojM/V0cbc3/HlhyNeRdXjdESyH/Mqh9A6SdRWzA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=ghy2H9bViOMcVFvaZKc9SDkDZJg2JlNNpMTOR26JDsvXw5sR4QsVv6MAZksxrTWq6
	 m8bq5HyEDevVvKVPH1YL40lavNIhomiyLDVqq+c27Nj2XCe9EtBOHHEffgM4xfhgsI
	 4EIkFN949P+FJxbhKb/aFi8oxe9TIn95C9+04VCQ=
X-QQ-mid: esmtpsz20t1778744937t882aa529
X-QQ-Originating-IP: t4JR6FDlpu7PnX2nSsNg47MmTk9Aj1uuNgDI/hu0pGA=
Received: from PEN1097 ( [61.183.83.60])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 14 May 2026 15:48:49 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 10419003516767972258
EX-QQ-RecipientCnt: 7
From: niecheng <niecheng1@uniontech.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel@uniontech.com,
	niecheng <niecheng1@uniontech.com>
Subject: [PATCH] mm/damon/core: recalculate intervals tuning deadline on attrs update
Date: Thu, 14 May 2026 15:48:46 +0800
Message-ID: <7946CE4E0773AEF7+20260514074846.3258908-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: N76rkG23tQ5KrkmKH08ZmRRLUXZwvZbJ9KW2lohhC9Kcjnyc+p3IwnI7
	AY1of18aTLESjkHQtZfSJ2xloiTAtQ6NW/FJquxJAKky2tM/mwxKtIsFjqLVue+0w5QWvsV
	VffYrNet0Z8i4EWVIpBBuMnrk3iJQx3yGEArHJpp68+wfHb3CWk9QZqyJU82jWRCDtD5Q97
	WkVG/CItbj/yLi7MIkWSDAWjPmOCF8L1EoYyVOhkqw5bGJ1XeB5YUPnmZg47hKECfrH/nk+
	KS+YnMnvbi/uAXpVwMGj00cZF+upD7mCDD28TKsVZRQkBqELAGxoG31NMybR00W0kFrz9vM
	nxoejCsps1/SnhPN9qoSMI2k7fyvidilc1R7wh2TIpAnn5nwvovDgLaYmzUGfgTWc+qKgab
	qh+oKJbPgtZ158SZlzbf5Et7VirM0ibTMnD+SkAu+BmycKCPdHmsU2agY0Bp7VSGt3GsPlg
	UdmSyBEDrbRRU0oqitxM+eVg1lIZSrgIN3Kz59Lnblw99u/cf854pgf5mqdoCJu+1o3nB2z
	CKPIsKb8taCe33O3dHJmSR5z1IBAo/J6i5fnhcWoCmSB57Ia215zkvSr0qeI2qBeyUbbQiX
	opOpEKsHFExaVQmU6bK1qTlbnfZsnmu2JzB9F8XlAk7g3+QDYdzYzPzwa/t+WpDNtxCN3UG
	6jsQCyZnPc0L4g0pezq5YpUX9pKOmH0AEIq8P4tYSGKpqqoZ3ADOzTH5ch0aiRaIGk1QVTv
	a84Vo2OTIxdgGZpcQ4bcfn3lZ35nBLiZS9O3CoNwksM7gBInIzkH2Z1VI63d3BeZBi6nNpp
	/7UQTLU8iTJsNB0cjLbgqNizVxdIfIZ/k8iD4AKH2rd1htqtc7ZwHrQsfaDgWuktaMtljg6
	uNWnYUKxEPo8p5M8+mIqkSgsZUGwENr0IhECf230Rne2VrVuXjZaICKPvQTxswN81Z0Vi5O
	nbWoGu0UWR90ofhe3Dwae2okMIGFZaexypePizZjatJuhnvo1j6bEWMaI9CuIzDWtkyjrl0
	cUdjJeJKQLZmE+BAKEaTuUX9+AeJ3CYl0dTZKz/vWMANBGsTqK4oMAhTt0yE1FOQa6SVim9
	DTLUnfzJVrLMbERMl7Nhf0VgB54giKSi0XRkB4D3RnV
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E3601C0007
X-Rspamd-Server: rspam06
X-Stat-Signature: ycz37xxzud9ngfprbdam874upamz9f86
X-HE-Tag: 1778744971-379537
X-HE-Meta: U2FsdGVkX19IzCvkYlNaiQZ6cezJ1PHAXsYzNnYq1DanmHn4RTFkPpYyZoXzjMrRKj7UQa9EqXlqH5ymXwKphj6GdHg5IVI0KARhADKyTIOSORkV2Ad7B479Hu17PIXe3vcaKQgQvRjOpascFez31Xj0uNkM8iaWmTzQQQEQepQTOzyJ2lMq9oIEFDNpMeK4O3nEBHDX790zDAxWtvZr79b20HP+5D4s1hOCukpEqroebkXMMy40J1LsxCFuDteinI6/OykvKXu92FOg+UO/gXO+urE92DgNbpVfurYgPxCN2WqURA1L/JetOwEV9HCVdJ68REWSXpoFuhvfsUMrBldHr+EUWZn8l0HX2sLSQaP7qExpb3e2Uy05zT3SaNgQSmBp8rJoOn8jl4OOuEl6s8Fo1iZj9n9ecuBOvQb7YhD+dlQDdaCsheG4KenMM7nT9r6hHJtZ5P9JWhrrrQD/kNg79Djn3YN5T+hM9kgFAUgt6Rlq9dyCCLuaj1bpdx5wmdMladdPLDxM8liVxZbPPBnfoC1/lPF82tcStxOOqLtCXPtAKTSSoys8w0M4ChA2BvLoUzU07hi0tdD5pFxGMnTqqakSJKsr9x02O3LwA0gdfjMoGYfy3k0THVsmZzMtg1dhzLJBe9Ia5KeY+G/mYlV2NPDKW855NPZwK2CX+4L1uF3QctCWV/d51T1EJ0ppgU2tJBB324xxk3UDKEl4fl6uFv5wGGSSSk71FUIGuMhku28LBVqcFQAem3WzyCA4QpCHp4ZMkh+cSxdHhKoMHXqGXDdwzywLxMXwLbsTeUUKvKp/VDGMTahV9PiA6XGaCnMiw4pIwuAk690/0u4F2qTAiw3TBHKoBfstuTY17z67mxDyDvN1hg2ITqEphqNf1uSjX4N5PWmurjLeksrOEiVA3xu9jhyAo19/4OtZhanu7Sa5gQxqfPGZ3XrBSYqcZ9AksHugm6glOtn68dB
 nQz67OMH
 rdYVeC8e7B0Q3NGVUDNmxRZ6JQTNNAqjDXRfHVJtc0kq+Hx2UNiVig+0oZik1XDIW3aLxEVlph5bfFGUdqXZ0sQu0iX72Hf/cPSKiA3E/PjUYKiZNLyQlSsSpN1f5HXaR3CQx2RBh8yz2SgWlT4JmcGcKq3Z8EgOYf0lzCxDMm6+mTvcKwLiYqaWbZdUgWG/j9PsTjPn84YrZZ8WytEpcc2evlgfsS2/Nf19y3vg4BfgI/ZK0uGZ6Umh4FWPpjMOTcqDwe+1UWVuX2oA1TgkM7teLycAR6HmzzgNOOYMKv9Oimszh8/F1EmrwLM3oufmjoQyzEfw+o/fOvD3CxBd/f3CQ8TGSVTiHJDUk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_attrs() refreshes next_aggregation_sis and
next_ops_update_sis for online monitoring attribute updates, but it
does not refresh next_intervals_tune_sis.

Because of that, enabling intervals auto-tuning via an online attrs
commit can leave next_intervals_tune_sis stale.  If a context starts
with intervals_goal.aggrs == 0 and later updates attrs online to set it
non-zero, kdamond_fn() can treat the tuning deadline as already expired
and tune the intervals earlier than intended.

This has been possible since the intervals auto-tuning feature was
introduced, because that commit initialized the deadline at kdamond
start but did not refresh it on later attrs updates.

Fix it by recalculating next_intervals_tune_sis in damon_set_attrs(),
using the same passed_sample_intervals-based schedule as the other
runtime deadlines.

Fixes: f04b0fedbe71 ("mm/damon/core: implement intervals auto-tuning")
Signed-off-by: niecheng <niecheng1@uniontech.com>
---
 mm/damon/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3dbbbfdeff71..501694d4a590 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -797,6 +797,8 @@ int damon_set_attrs(struct damon_ctx *ctx, struct damon_attrs *attrs)
 		attrs->aggr_interval / sample_interval;
 	ctx->next_ops_update_sis = ctx->passed_sample_intervals +
 		attrs->ops_update_interval / sample_interval;
+	ctx->next_intervals_tune_sis = ctx->passed_sample_intervals +
+		attrs->aggr_samples * attrs->intervals_goal.aggrs;
 
 	damon_update_monitoring_results(ctx, attrs, aggregating);
 	ctx->attrs = *attrs;
-- 
2.51.0


