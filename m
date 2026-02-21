Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB253C61DEB
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 19:36:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518166B008A; Sat, 21 Feb 2026 14:36:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CBA06B0092; Sat, 21 Feb 2026 14:36:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EC4A6B008A; Sat, 21 Feb 2026 14:36:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 053FB6B008C
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 14:36:38 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3E19160567
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:37 +0000 (UTC)
X-FDA: 84469470834.24.08CE88C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0BB40160004
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="k+72ZuX/";
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771702596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oSSE+dkCyqJdTCeX6IMZuI0BpxiwOOj08VohuPphVY8=;
	b=ArrrpQWHCFAn2UZ0iJURkfk6rFaR66juyVsXS/ZZmcsnp60YriwMgS8hYsAuFFSmYj0h/1
	la+PHZB5ypzZgKatB8e5QAFPyC9ss1GPoQddksTVUxAk4DmuZK2NxKHwA2ol2rLAkRf+aU
	Zv1X2ZYp32YgIeKV/KTE67VzwQ55c7A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="k+72ZuX/";
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771702596; a=rsa-sha256;
	cv=none;
	b=Pu3v3um8m0Iy+FgenlHlPxmd/T6JL21vSdRH4y6hKImLP8VpXMoH6Z6GRhK0g9F/bZJVep
	GmCevZbX8Dkx3dHdk4WRj62znn9mQutqzS5ocMHrg/K+gbvH40NFvJax3BSDWO8pA42r3a
	sn9l2nZvx+glPzrW4tnPI3UALnh/Yuo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 86B7D600C4;
	Sat, 21 Feb 2026 19:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AF2C2BC9E;
	Sat, 21 Feb 2026 19:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771702595;
	bh=I8vgGzFmn9eOAxp25MVWasYsGVVIm8Br+R7YY0e17Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+72ZuX/URzHsMuAN+fknl+2ID4qfoFDQn3AZe8rUqgJu5ygA/+FDLFEpgXnoBds+
	 J2Uf9ypx2huS+b6oURZLEquamH70DT70inxL8Wszswem0BkIrwPjbwVXhFnnP8h2NJ
	 uqTI/kCmCFOd0xwr5CF4JbHUUCJX1z5YI9cSAE39G9RgDnPWhbBqQRTE60DrGcyC6j
	 bIdQxBe+P09rlDSLGaprGs6UmENL/MhYNxVsl2+VG0StOzDK0nZO9CHruaz/Ybi09b
	 EOLzZignmqx3ExNAaewSGm/3kx4guwjE/qZBdFU6Qvws+hwOcbrQ2D+rII4qq8Y1E2
	 eDtlfGIfpHYkg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 03/10] mm/damon/core: add damon_del_region() debug_sanity check
Date: Sat, 21 Feb 2026 11:36:20 -0800
Message-ID: <20260221193629.19332-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260221193629.19332-1-sj@kernel.org>
References: <20260221193629.19332-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BB40160004
X-Stat-Signature: ct6cm5jmanktrpopmngh5puurr34s37h
X-HE-Tag: 1771702595-469786
X-HE-Meta: U2FsdGVkX1+kYFCgNmqK79nABZ8ztYD1j/ARG8KROIS5wrk7EfmFHTWcZC7o3YErWBT/wboyRB+gzSujwqQjKuMd50Ms6SAoPVOH84BDnRcMbBSIICaQNNiVam5T1O9b8k6yZO61dq2Xlrp5cS93cYUf6we4Pgb5RXuypeSRNZwqUctHzaEzBpwg4XS0bhJuP0Bq1Yo+Q0ZIuwfGkBuTnb7jPDa2cs+xcR9WUxfBaKm6xnF/xIa7L3Q8tDlozS9XB+zHUkHQRQNpK/XGbUs55BrQBrMpx7dyetbOk/wdr5seIEW141nGAmhpHqdzM/IM5V2id0c2TEhGf1CeWCS9yafzONIoQ5hah9dbClz0XkEAGefWhpjP1FXbOJ0+PqjbvNaigLKfc1UmJVMNWsYlFkpMSkQEGGiDD/F8SuZzb77PrgX9V9xhAZz8s2QbXcOZZghJ8ruJH6Q2XQAB3S57EwcIPG9V+s3ZG3lhjjLsVluwMQc/CGo0N64d6na5fmdO+nt8mmNS3UP7FbMmnegrZvx+MSBE7/ZbFk/PpIbkpUvY4MF/YSI1Gq442iXSfKu2i+WaErX8HM4N3eZds8R4L9uE8erQVOmZorrSj9ZRELaYN0nRzSjqddE0Bw/q8K9Fi2sffqPOalxGvdctYyzDxEQSsBSNvd1kWhFnAYoM6JlRQ3cvRw7CgEFOf+cmVjBpHFvcBzD475fjBVYnXD9HUBckiUfqlf7M1j04NJC4p/ttcT7HFxyjopMH9QhL24cAJaXpXakpLKTZt6uktRhbOMIFBpLoZDmt+T355TJXq08o8Qdf5U/uMugQmKl3zpVbAwDjmSkVXHkH8l3N/X9pTXFytGqt6cpmyhVOY5/RnPSJlKlaOC80LM/fwlHX8cVnb52yP1bF0c24IK4bfv56apX1hbojr4+Il2zJwNb5x7tG+rzeU3AuUgn/1TKoHr+Ws7lYuCm08feSHrLipVk
 5rwUT/ZO
 dRb0NAJ3+d5NoH/t3aZF+tkL1pAQsQ5AoIMVW0zYPJt9U/iLw6KYUi7vocMoK2rKhkWoKfP1cmu6zdZMBHgy44WziJkCAfmHW1ALRQDEa/EC168PeQniYfvWdmK9+FfBRF1JT/jYMgc0jHy67SvmBy54skPYwQNGT81QAIwaz0dQ38rZzps1a5q4wF5dRrjqhIuznuMwR36hdN+HXjnXYrva5MvgBlVryOpAgxKusqFGQx/sJXcCLoMcungBcL3/lUqqy1RP73u8j5QB05N4mrCfxww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_del_region() should be called for targets that have one or more
regions.  Add a sanity check for that under CONFIG_DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index a7f5748c1fe17..7e03c3af03694 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -158,8 +158,25 @@ void damon_add_region(struct damon_region *r, struct damon_target *t)
 	t->nr_regions++;
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_del_region(struct damon_target *t)
+{
+	if (t->nr_regions > 0)
+		return;
+	pr_err("damon_del_region() called while t->nr_regions <= 0 (%u)\n",
+			t->nr_regions);
+	WARN_ONCE();
+}
+#else
+static void damon_verify_del_region(struct damon_target *t)
+{
+}
+#endif
+
 static void damon_del_region(struct damon_region *r, struct damon_target *t)
 {
+	damon_verify_del_region(t);
+
 	list_del(&r->list);
 	t->nr_regions--;
 }
-- 
2.47.3

