Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27390C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20FD36B009E; Fri, 10 Jul 2026 09:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7966B00A0; Fri, 10 Jul 2026 09:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FE2C6B00A1; Fri, 10 Jul 2026 09:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA03E6B009E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6603FC1C27
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:06 +0000 (UTC)
X-FDA: 84972993252.20.9FB2856
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id DCD474000B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZAb63wrG;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gcmh3CO5nLFI9rnEGlo1ly2IEXcDgUHS1nJW1mHJiU8=;
	b=7RKepJG/4KlZxrKTOTFVpzCObty34bX3wOBlgULe6WCObMKkWFigpAXCdhdvkgFNJPwBfb
	Mo3Yz+dj3bIYbCdxZfD9Am35VWrdmxvqOclSiagzsQsJOajOYrhKfbcrXKvzUkQyXGr6tf
	coJXVdBSPG+0JRx+4UpUx5TcvtqxkZ4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZAb63wrG;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691224;
	b=LE68F2Mzc7zpJrPDt+M9zdgCMH+wAXHlfsp/QvY6TY6AwvJY049zsiF/Eb4+kO2pT6wtvw
	3X04M/dpFTzFOBLKLjTLEz5sfCXDHO6WHqbw0dgDDboMMPdzthccutZBE5+qobj6yTSWyz
	edlNCNWB/zuemG5hSt2qH6/D6g6DPk4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 88E0C6136C;
	Fri, 10 Jul 2026 13:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE6C1F00AC4;
	Fri, 10 Jul 2026 13:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691224;
	bh=gcmh3CO5nLFI9rnEGlo1ly2IEXcDgUHS1nJW1mHJiU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZAb63wrGcdyPVzWcGEsZr/VhfWy51Kg4BNHyrUHPNheYf7pyRR6LjnpEy5NHwy0eP
	 meFzkD0wazEIBoI6hu7jaI/OPmZrpR0/Q7EElkGDDgiPGFa1GQPPD44Q3zk+irK6gM
	 FoIYFEz/pZ6OHtUXJEE1SeWh1eIs4zE7ZijlP1MzCiA8TbDl8ZEpQmoaH9DJbBCrsE
	 24eQJuikFqxA24dw5aIH+eMlWsXah5JNAxiIf1nnc1v0SgUE3EpTVtobgZfI5oHW4j
	 pjzt2/xnqCBJ3GDNpq1smbfDeLtAhAKruZTR7/RFmDBQFPgBrt7JJe1+Zn7mmXDOKf
	 ElYnn2cQKNdeA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 12/19] mm/damon/core: set samples in apply_probes() if probe weights are set
Date: Fri, 10 Jul 2026 06:46:41 -0700
Message-ID: <20260710134651.18084-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DCD474000B
X-Stat-Signature: coszba5aj3q3qd48745szur3jpj15urs
X-HE-Tag: 1783691224-888131
X-HE-Meta: U2FsdGVkX19ri9MS43r+U4PJJIicRbYSdX8UFBD8U6W9aRGmHOnoLYcY8FTC4J8LFrApA5x47puGIFFmkWaLs0d6bpPg10GOo/RgqB2g/s1Kv4PNHtVH+JnRSs1xyeXMLmKqsIF+zKuL9c0GnRbUwxG6PIy88CGGEhC/6o6FF9nshykvb3QcODLUeZg3W9B2jOXWT5grmuYWOFRjHR1shQ/YOtjUSee/052ewHsVlSk/pXT5jy9Ggekpsp9Gp0w6u85b1iBuxaexe9PlG3sLoV5Be761gsanAN/2ripLtcF4xOVHtVmuWpIqSywpRPapMwX90NL/CAoqTeI21l0/DjEJu7H/3Wq+GtIobLzt5M59kWu0hd/yWj4DWCWu70LYK2MVnFPsLJw2WgKWVpyfzCqB3rEio4flmo5Abo2mauxunKZg3dyVu1xI1g+d1jkO9VTaCJDk1DS27ThSs3gXlbK69DDe6Ll4BPCYVPEHsXjuVEHfsX+lW7toJufJHwWVTGkxBULVlfyxC6DkV1sP9PEMCrJHYcMBUCeSas0vv+Td2X0MHPmPJWdoT9ANlQyWe6iACi26oxJE6Qgpxo98iNhSy7eCAKDSshPi0TZ2vlgvz5PEQH2l7+OXh4aF+6lAempcDKN9Iip8pqChN4QDnqYGrtVL6j7ew5chNsz7krn/utbVAwedkG8wzwpbynDkICaQKo6bG5vFpw3bxwBiRAAKxg0DcKY0V6/CB8JESbHuqvKsz1AIMTdRRFqZcDqvFTw4wmPWTB4fzT0F0OMwrBSU2wnJczTQoUM9YN3fNCnHj6hQBckNdEQ2Ln6T9Zo4ytwT6rVnQOdKoz/F+rYi29YBcCqb9Q7GaY0JBvGc1/kzmOe0+mz9pWOW5Bq6K1AWMI9zXhB8eJfjo/BTVzYmLAuU+7OFF9EYXRD0bWg2J7qfBCXjaDEWMTeUcde5zdMglxAZlVXx4JFk/P/7Y8X
 hg/Pmn46
 8qVVesutnZtgO5r7VK/wWcoCjyXDLm8s+K/Es2pTKWOitECxi3RoUPTFEDgCo694wiDu9Jr71hM2D4RebKLsxrSaBttWaNhvNbNh1JPGBk3mWK+SwEFeQbZLHDWMCSaG+lKW2S6ZOy75fca7ouJ8rx49vu4DMaI51fvrpPsaZLaMmP8It3uecZtJ9VcB5LkpeI7xWLXuov4L+3BRteIaPeF1IGZCjHoMhzvtaSYfbbMo94cWhWQtaR14Aj9f75vpjWQM6lscVjV/zln3c1qCJcOUDyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When probe weights are set, the prepare_access_checks() ops callback is
not invoked, so sampling addresses of regions are unset.  Ask
apply_probes() to set those together in the case.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 65f91e3b58d2e..dd0612e1a408b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3777,7 +3777,8 @@ static int kdamond_fn(void *data)
 		if (!access_check_disabled && ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
-			ctx->ops.apply_probes(ctx, false, false);
+			ctx->ops.apply_probes(ctx, access_check_disabled,
+					false);
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
-- 
2.47.3

