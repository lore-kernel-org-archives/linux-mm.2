Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEAB5C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 421776B00B3; Tue,  7 Jul 2026 09:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A87C6B00B0; Tue,  7 Jul 2026 09:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C076B00B0; Tue,  7 Jul 2026 09:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE0E26B00B1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:50:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48E4D1C2DEC
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:50:54 +0000 (UTC)
X-FDA: 84962116428.19.AF1C498
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id BB33820007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:50:52 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WqgM6oHl;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y2nS4ty/xjd06Q+OF1q+BaFHGwsWJWpLHsAguRnNOTk=;
	b=E2A0WCKaQcI0um92snX3Im7zCPuCrJ0HGvfzsrVlk99omjSpXQ1uMGYjAIzMRPPXdsTI83
	YNLVtQXWssk85UQbkLnVDQ/aJN7pPbOp6BkWilPH1Nsr59gH5QfMor80IBGOhDSf76Wr7A
	/h65EzGzpB5/wTC0faAtz2aMsou6Jz8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WqgM6oHl;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432252;
	b=gxGQ+XUtulGTdsi0pdTvsWPfAhpeZtwtcbcv+gjna9TKfWMtquk0B53hEL4GO9ylJMXK7K
	qgmG1S7ygDhi/h9kvGahhjyWgl1PcHWYXVkJRpBW4XJSVT4SGTcOdhyUWZGPwIY4xgpajS
	myGUTAw6nD1f+qTQhswd81HQ2BuAOgk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5601560018;
	Tue,  7 Jul 2026 13:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8581F00AC4;
	Tue,  7 Jul 2026 13:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783432252;
	bh=y2nS4ty/xjd06Q+OF1q+BaFHGwsWJWpLHsAguRnNOTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WqgM6oHl9dZNqM6aypSOWyCxzCWUqOWcz0OmsFZqyPoPxU6pSNT5yuSjrs2W+iXbe
	 nMZgVHymJxKVkcy9yVLlGNCANbP3UHXunTAXb/EfQqS7OVbQDrVn5yaL5Mdgg0K111
	 wFMgsUCfiGCQeTzk6IGTgHj0GcXZd31SrxojgyswLf1DEjdgFTcRd50WEcCDECZ6ZH
	 ygiQX8rkMDixhgJQ01cPl+kL/kDExO1lEi1SEQG3Tho65XbZ0pJK9WTDZbXfqAviLz
	 Vo0JxbPU7a/n2QB0R3Lsw7hXcH7iCPx9Wy2z3r07ajEHUzU6dgiiAobTMWM4fmdbR7
	 +ZsZMlRb+xdqA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 5/7] mm/damon/core: s/nr_accesses_for_new_attrs/nr_samples_for_new_attrs/
Date: Tue,  7 Jul 2026 06:50:34 -0700
Message-ID: <20260707135038.90068-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260707135038.90068-1-sj@kernel.org>
References: <20260707135038.90068-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB33820007
X-Stat-Signature: jyrbkjwqqidj5ifeuhqn5h9xwpb3xxkw
X-HE-Tag: 1783432252-954532
X-HE-Meta: U2FsdGVkX19fWi9qlyglIfZT0drZI8f3XoWmxqlV75ds4S0U4M1f2fs/EJfkY/CoXPd503LptPLHvbKlqXQZTiAOrUC0i1TCimw8JTJ6v4Ofx3c8DXMBlexoL50DWNzgi07gru+6k3K4pvIFMVFy4/wJdrivT6HX3DTwkFlWTXGIwCdCfa6up3LNr76QnSDBMQkRHG88Ilib1Zw3u7U4mxs+jBRLDbufb7FXP11XbMK1d7sM5vzELS/KKSQ5Pki55NrbmFdkKZKCSFPfiiBQYhywrB3fIL5dkWDxolmehjaw5sRUL7KkFfw/7NBpX1twuP7CqlUD12qQ9rkEWIW+CvCFUHerFFxgOVEmRmojEPvvrZYaX28TbKZsiB9fVpR41Ke2rFn0KfNvN3TPmo++7U6VT0hWTqeZ8k3e23+jgPdm25savM9aaTC0C0DhmnMVS59nTAV6KGDZcRSn7WOqYzhkGgd8fNvuUZvPdnVrkwkHGBJ9DwSfml03nUWDFGYGOWPcXTtUDvviu3//LEFKlq1Gx/8cV74Vza9NR0r4j4/4gTqW+n3HChd9x4Ibg+W31crziF5nBCmX8sgQLUu3+2zfy0RWM4/1MriR4vUXa23PtNo/6LJpntF631AbAemtrOfHhNzbv94qnPL1kpKm777IQSH72ZIKiHzcrTzR8YMeBV0RBzNrs71dL35jHwGre0aqswCzjN2k/GzQ1FzuATIfZyHlI2cgcaKgdLwVnSRu0gqZUovp/a4wkJ/TSuZXCE17hbe08egfou8ZnVKzQ+oHXbgqSylKozjXS5N1XidewfH5lmz3yrv4oaw0s/XKKWZoYvgsuWibML9KplHsH0wc60nL+uRBIzKPCwGqn47o6176Wz6/vodXAWDFKDrVL1+9xx036yPPABVknUZhFhmBhpx1MxnS9LYsFz2HxIg19DNHXMZO07BdCnYcxMJJh5EmNX5FdZjfJxuHEeg
 KLpVV96G
 +M4z4Nkq7G2m80geUsWSVFNS7IrjS7JSh9u0XnThGieEzhlNgi8OW4qWOUA2f8VrkpoYrTjfbs3HmfS40VcjxIslWymCbmbrJhrpivLrK1anA+C/Pn/8ITwxeSmnYP/BIUZjTuZuHLaahtO12vP7jng0f/Q1/WXM/Wb62ShcTyNL4OqqnaUtB4eDf1I12v8o2T6qFQUf/Tr/2XolfjXwlUglU+czDSoNYHPHm31ZClGJa1Ay6yyj1yMpFfvPJwfpC6SJmFJQ9zrODT+1F7Y3fkozqBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_for_new_attrs() can be used for not only nr_accesses
but also any positive sample count, like probe_hits.  Rename to be able
to be used for such general uses without confusion.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 718268df27fa7..cda318806b65b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -890,7 +890,7 @@ static unsigned int damon_sample_count_to_bp(
 	return mult_frac(count, 10000, damon_nr_samples_per_aggr(attrs));
 }
 
-static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
+static unsigned int damon_nr_samples_for_new_attrs(unsigned int nr_accesses,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
 	return damon_sample_bp_to_count(
@@ -902,10 +902,10 @@ static void damon_update_monitoring_result(struct damon_region *r,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs,
 		bool aggregating)
 {
-	r->last_nr_accesses = damon_nr_accesses_for_new_attrs(
+	r->last_nr_accesses = damon_nr_samples_for_new_attrs(
 			r->last_nr_accesses, old_attrs, new_attrs);
 	if (!aggregating)
-		r->nr_accesses = damon_nr_accesses_for_new_attrs(
+		r->nr_accesses = damon_nr_samples_for_new_attrs(
 				r->nr_accesses, old_attrs, new_attrs);
 	else
 		/*
-- 
2.47.3

