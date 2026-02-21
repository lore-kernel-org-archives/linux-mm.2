Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D58AC61DFF
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 19:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C9636B008C; Sat, 21 Feb 2026 14:36:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 234F66B0093; Sat, 21 Feb 2026 14:36:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95BD6B0098; Sat, 21 Feb 2026 14:36:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C50E16B008C
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 14:36:38 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 849ED1A0537
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:38 +0000 (UTC)
X-FDA: 84469470876.01.423787C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id E1FB8180007
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:36:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bnBaaJmV;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771702597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wauAKw3s8UcCHsp18DWi2N549iBHDTZBiX6uLZiuHk4=;
	b=Ffg/eIFDSrlGXyg0kRm1GmVLNsN/vdE9BPHvI4JL8eIQl0RtIqc/pyll6JIhU/ZUFlcoCO
	Ybqf0NwFuaF/0U+iLX5QJ/MS+W2aIbyYtEeVpLGeqRs/HcOnvMjyy56XS4RcPTiMA7xic7
	leuqt4qeud2n4tu7wlYm39s4dVk8v40=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bnBaaJmV;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771702597; a=rsa-sha256;
	cv=none;
	b=RBMRK93+eUUsJdhcTdAsxlOFCz6ecgOtYnsjNjuse16kBdwQo3XUH6tu89dh+Dy+YxyFeQ
	VrSv6ReCgpGFSaNPPy7pnCoyNNLZNOgjwcza0zp53jwyIqbXJxtAKHAVlBOZmaWBLnGNQx
	oaMmxcIlink1J+40YDtdXdD1LJDiSY0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F8FB444A3;
	Sat, 21 Feb 2026 19:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86355C2BC86;
	Sat, 21 Feb 2026 19:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771702596;
	bh=hTJuo1zGiIhoE2C8xzUpqoPqVjI2PLBsSgMe7nKwEuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnBaaJmVPhcila4+rCDK54NN7dsnfuRDST8prP+m03KVFBp2tqmhkWLcRTInnG0LS
	 nAKLYddEBKRvToqQjwJ6/bZSSXCM2Uz8QW/JTmnOgWpNE5vjd2/JUsgpFshffTMY6w
	 vcgt5sVYNCtrnFkNqea18bzVmnOM3xZHZpErdI98da9aKquFUKWTsbdOzyzxCPCxYa
	 sOOtvRHA2SVlJc+NBbAFx9GAgm+y8JASF7N6oy3wisqS1v4n1XpNxlKT8349mTSKJp
	 vNqrNvFXGQGO4IQdSpqMtoQGdDJPqPkQZwsLOWOyJXu8WPapqPmfnQGGyAo4x+JW/Q
	 T2ffAmM8tnhdQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 04/10] mm/damon/core: add damon_nr_regions() debug_sanity check
Date: Sat, 21 Feb 2026 11:36:21 -0800
Message-ID: <20260221193629.19332-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260221193629.19332-1-sj@kernel.org>
References: <20260221193629.19332-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 15t6ihtxrp1pshsafuu1czah96866m9d
X-Rspam-User: 
X-Rspamd-Queue-Id: E1FB8180007
X-Rspamd-Server: rspam01
X-HE-Tag: 1771702596-493446
X-HE-Meta: U2FsdGVkX1+H9mX2FHg8VXp4+PSjYQ9ChpSF3Jt82cYguRWiHymqN+SSOd0G0LlqLrm1frL851TtwMNdlGj3HP9mzX3YfEwZrfWfwxAVSXXp3tBlC6HaC4C6y9N4Z0UlFab0I9eYYV1nPZ0QS1B1cL2ORVS+FsvSOKBB5pOXG+tTjToDkxDc/QAvsObMpRiepAcoWD7L9h00gnwmhNb7XJAOeko6X2IytrDP9vBOClrCILIbvEklxc1OUFg+AqfVFpTFSb5qGSUKsiWV4RNIDdLsgABhxXE6gaWtN9eNlF2co5Ktr4Lv5vp+YSwjLHB0MnqAfwxfLbwGG9EQDmwMAnwnA1eNGfkOqaTGoij9zFQL+5e2NTSoChCKZ7zQtV9OqYfetfM88FxbS6OrTaJNWn7bJKOmcta0BpmfHgUHI1EIcCnW9OSwHOcI2DS1Bahrh23Oh2ocf5nCOztMLTB1UEg+LQIJWx0wcuEcvum8V5uNAGhrjk4vz+c4Q0f4T1CifeECOvz7mJllv22Y89YUpY849LQA+niZDE1KhqpFLaU2C0WSG2pdjVttvpdBiR9l3QMqwvO6eZuE8tS0KoeDHwusBIoaNNh+skLEdX+Fc2Lc2PN4r6vAfVyNU+sQd0H6Ah90aGcmh+XRwIdo7S85u/28hwiGk+AYAEHUNSbvMfe4waICW33ssgA2QJmHSQp9AF3u/MIEdftT2y8BX+8v70H3NTH+XZBKNtHSxy87QSCYJMrBoNhLppZnVC4N4UNaQRwyEmhkLR4YxEF8Ti5u6oASMT4CX0n5G+0xEF3nUTqkTjTIAanT5ISXMdQhdLkgSir38iN9CsaQB7jtaG8hzcCdGkRaujIZux28nlE8kJ2sPZYpIjsHeDe2q3i+XgnEbL4ScHMsMJLPPF9EpPNrdlXpR6xtBlG9ahowvKd9YaoZCICC+syl2EDyACXDVd13+b212UW7C118/euoiDb
 ybUClxCN
 unKRK6NiyCcEB/W9XjJXV1UU8LI85TCTDgcavyflnV2JLe7gnbANnBNZdxkkzZDBWvE33W3PReroXBfgfKx2bmA8BjaK74TlOH9sKD6ut23yLJHIrGUp5K9EqTnO2tVv9ew49FvctQqRtbq8yM/v4fI/g8iwCy6HS/imovAE+e+AUPd5brJL6Mu2xTFG4cV8YLqhMl8n5mZLy59gmoxPIJf2bJKkW0PPoJJ4BeaLGD6xv+2/6/21kIUWqrRxU6vWD70V4lpsVXFBZ+m6xITIRTKyEbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_target->nr_regions is introduced to get the number quickly without
having to iterate regions always.  Add a sanity check for that under
CONFIG_DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7e03c3af03694..ede76e0789be3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -556,8 +556,30 @@ void damon_destroy_target(struct damon_target *t, struct damon_ctx *ctx)
 	damon_free_target(t);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_nr_regions(struct damon_target *t)
+{
+	struct damon_region *r;
+	unsigned int count = 0;
+
+	damon_for_each_region(r, t)
+		count++;
+	if (count == t->nr_regions)
+		return;
+	pr_err("damon_nr_regions(): t->nr_regions (%u) != real number (%u)\n",
+			t->nr_regions, count);
+	WARN_ONCE();
+}
+#else
+static void damon_verify_nr_regions(struct damon_target *t)
+{
+}
+#endif
+
 unsigned int damon_nr_regions(struct damon_target *t)
 {
+	damon_verify_nr_regions(t);
+
 	return t->nr_regions;
 }
 
-- 
2.47.3

