Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1526D10AB834
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 00:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5830C6B00A8; Thu, 26 Mar 2026 20:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 534126B00A9; Thu, 26 Mar 2026 20:32:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449F86B00AA; Thu, 26 Mar 2026 20:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 376886B00A8
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:32:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D1036140FA5
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:32:29 +0000 (UTC)
X-FDA: 84589966818.25.2F71509
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3A4492000D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:32:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VNRNrlnn;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774571548; a=rsa-sha256;
	cv=none;
	b=yOmm8hsYdZ7EcUgGuVjnp3x+jCsrrfVjhTk9lzu3QPANY92OkTQs/dOB4QpxWdkZ/o0ugL
	cZngse9XtJ4aIHmDu/80Je+oAZafECZ9X/VWQ2Y08YDRFsU57SwRoqGl9c+ydJses3Fluy
	4a+pbn1sZ3pJiTAh3DD/LFq3d/QWDfE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774571548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=n+oOQwivQ17Bg3lYMCVhGVPIEaLQ62gTjxWiJ0Mbask=;
	b=5PEawVK1lhPanxtV/mwpjQ7P8C8PwEBOjNUs4YNbfSgWPrTSe76SNQosCP+EqEaU97VRs2
	Q5jvFMLygYR7SlhNBq1VSv7HamwTv3Wfr7cXvZeV4fyKk7m1oihyqfMcAGNnb3Sn1w/02w
	8Ab5rHbxyTFy1RAxvu2c1Hh1DNRGHyw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VNRNrlnn;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0088E42E2F;
	Fri, 27 Mar 2026 00:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BA6C116C6;
	Fri, 27 Mar 2026 00:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774571546;
	bh=477C8/cGg78aynYBDYa7PrZfozFomytf/sPOXH4AIRQ=;
	h=From:To:Cc:Subject:Date:From;
	b=VNRNrlnndzxNHwOR3H1P0LyEaSzC3fKlp9bvoAeQkgrbwDSrawZ4MQkHylGTEEu2U
	 QBbB2PNMZdbpNGVoFrbc/3d2L/K+IKXmRc91AtWvqFsSlvqSLdQejHRLE+RFXQ9F0t
	 U61RAX23zAH4AbAk00tdOUv5kSLg0y7SLSd/VUjRukFBarHMbw5Tal48SSE/eGqqI7
	 Latq5hJEOWLZOAbOd/djTMFhKn83suMfR0eoAqbDBLLMWuLErFja/Luhf7fL7bfsIz
	 vQIiJplsCZfeCPdcakTUF/u6BMrTigjSs2yd4/ogxT01t6dERfBDfOn5s8W46HJ3ff
	 GsVDiATzoWyBA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/sysfs: dealloc repeat_call_control if damon_call() fails
Date: Thu, 26 Mar 2026 17:32:22 -0700
Message-ID: <20260327003224.55752-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3A4492000D
X-Stat-Signature: zteer3bw4accp4a44tu77qeeu51f4fom
X-HE-Tag: 1774571547-595242
X-HE-Meta: U2FsdGVkX196JhSVCIPibuLVXqrL29TsAtJca+mFS9hPjm/F0KZRngJpr+uNFSuTrfS4KMbpZ8jub0bCyRAxxKJ0PBQXekISw7Oz2xRuPk9D0ESOTLAYw23R6UVcD1NiiqsCMf66dFehRzuxweblE0dApWODhARGvIvN9IgL9dhlcjWC9D758jUGISvgrtuSaNoouqlasJbORaoV7I/aB0bKzQcPMESK4Nuw8v8O6/9L6lLS90GnQnkh089N5Can+FATiNLl39htFmMxJpTqr81PbqA6lRlNYP4k10x8rSYDe/01FPVg3f5uhP8gEe65M97IXsSXffnWrK1YAXB9G8MpF/x8IaUCFWK7ZLlJAJcw1MmmUn0en++nL5LsUKBUmoCDnj+CbHwqJ3f2MFZTFPfLibaYYAdWp1Uq3UMHZWjydzkDuuUFvG3Y0OEtmq8eDlRNzqkTTC+qmzKs/a0WQd6b/vvaOiZtOC+Xl1ICrKuPGSP6nIWMLDGZgXp8NE9cHGsgariFqsnNWKUf0xee70O53V9U5My/PjA85/LadUuhJcvSg/xQUyYhcUuGZ5oHGhkkBx8AIC/ZrCDMmzSMuTmebp1Pgka7psoes1m0kSzgqY844cTAfKI597Sx3oE+0YpPH7brhEQaRTDnbTKGa44+Fxs+d6zwL8sFhGk4QnfQtzp8RVXqJNpBuanB/jT4BLubMthecfyY+Vty+dCOY/p4Od5+lDyJWLqPF2i++uQ6wJ4gy0wsSAelPWPo9DjAMkeuUh4s7yy+mPP+eKRi79bMj85Kw/MzTUKnteSOJYFs3H2auwpBAWPCwIrXPjDAVSqZ06iN2yTXSiDjrVLnuy8wWgAmQfODkycEPI9UryD64yX0WymR1fzBW2RaVQr3QLkg0BMFYcpAOjTHFynrlNDLqcm656LwzIbp/s8eImt0TUA1Qrw7X8SVzJOdl48XgLyRyHAREUm2RH/ufeZ
 H9ILXtwz
 h47R04BF5zghE+ZUfBTq4OaILIHwL4wlniPMz/ECooXRfAHFon7wOzNws9aNcvIS06trJhzQn0PhV+pZ2FrSIU0Jdrkku6XaMxQQRk0dyL6oX1Y5TR2Y9QECSCUieysfDHLrI4naMPGiLkOh/6YpKim/SVpl8iV6vUsvdYk10Up+XogzMHvaU96eWrHdLNlwaPsE2HbU92sE1uqH2ygjBwb+g+i2lvlNg5RPkRBa9i6zI2MX/Ds8gGqiYMYKsF4KArC/j10eJsZ3yGsN7ONVXSFfDfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_call() for repeat_call_control of DAMON_SYSFS could fail if
somehow the kdamond is stopped before the damon_call().  It could
happen, for example, when te damon context was made for monitroing of a
virtual address processes, and the process is terminated immediately,
before the damon_call() invocation.  In the case, the dyanmically
allocated repeat_call_control is not deallocated and leaked.

Fix the leak by deallocating the repeat_call_control under the
damon_call() failure.

This issue is discovered by sashiko [1].

[1] https://lore.kernel.org/20260320020630.962-1-sj@kernel.org

Fixes: 04a06b139ec0 ("mm/damon/sysfs: use dynamically allocated repeat mode damon_call_control")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from RFC
(https://lore.kernel.org/20260326062347.88569-2-sj@kernel.org)
- Split out from the series.
- Drop RFC tag.
- Add Fixes: and Cc: stable.

 mm/damon/sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6a44a2f3d8fc..eefa959aa30a 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1670,7 +1670,8 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 	repeat_call_control->data = kdamond;
 	repeat_call_control->repeat = true;
 	repeat_call_control->dealloc_on_cancel = true;
-	damon_call(ctx, repeat_call_control);
+	if (damon_call(ctx, repeat_call_control))
+		kfree(repeat_call_control);
 	return err;
 }
 

base-commit: dd478b2be41492a9f7be5abbdbd4dceddc46818f
-- 
2.47.3

