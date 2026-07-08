Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B642C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 706D96B0098; Wed,  8 Jul 2026 09:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DE966B0099; Wed,  8 Jul 2026 09:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6016B009D; Wed,  8 Jul 2026 09:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 336C96B0099
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:54:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE591167485
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:54:09 +0000 (UTC)
X-FDA: 84965753418.30.C61D1BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 216C914000E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:54:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S/nLD9o/";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783518848;
	b=OnHf7D2MnFIADtEqlQvnTeEHaWb4BRmP1Cp9XtXgJtcaRsvwuXvCf3gAFqMwHRth9OVcgd
	iL2sSNfP0fkzJgixUBTD+MFvyZ1CYMAR4WmOJwIDqZX3ItMJcdQ7KOCufFBoSNEnaoMtIV
	nJrwO7/Ld5UtswtV6dsJec6FmX0f+6g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S/nLD9o/";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783518848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FjsCU14SCNwzNXGXZ9ta5DksRZeNC0xj5z1tjd9bQ8A=;
	b=um/PGeHM2RbMTkUHac2dM8e2SB9g/Xj9R1SVCPsD8f/0zwd8oZg1znC0O+h3r63H2WFPac
	cuQmdrNj2Aq7oLDtk58zkdA2MuGQ5TqqdhzFm0WmAOxXxQqeeCV5LAF2d0nrH8CeaD1+O6
	99hGkM0l03IA4BoPNlXzNwrkN1misNs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7753141E91;
	Wed,  8 Jul 2026 13:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDD91F00ADB;
	Wed,  8 Jul 2026 13:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783518847;
	bh=FjsCU14SCNwzNXGXZ9ta5DksRZeNC0xj5z1tjd9bQ8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/nLD9o/Qjh5tLPHZqt1VNLZ0pYci7WKgWei0fOiiIL7v1uDHsi+1JOGmXBNrP8yb
	 Qor5+oDR4q2k7eAAeiKqlYmxFX/4KaYFrj3khAxKzgyMXpGgjxZ4oXkYd9xJ11f7NU
	 pbON4T27mUBQPijrP08XfiB3jzxwCUOejAyzlTgeOB2Avlq7BAyjHDOpmXETx1reCb
	 Ihj58yCh7axxdgD/EsifvO694uENNrVq4k4zNTLOFgJyKDiHKFmMQE8duZNSHk3B8K
	 gcD5fkpWvgwD/64QMNhyE6rp90INaypFchsMXJlWgP1omWbfeWjhXZ1hYUK5FHx3Jr
	 V2k1nP6Z0/W6Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/7] mm/damon/core: handle unreset probe_hits in probe_hits_mvsum()
Date: Wed,  8 Jul 2026 06:53:57 -0700
Message-ID: <20260708135359.122587-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708135359.122587-1-sj@kernel.org>
References: <20260708135359.122587-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 216C914000E
X-Stat-Signature: jbnaj95pr8ncx8rjunu89ssu3dhyezcr
X-HE-Tag: 1783518848-415625
X-HE-Meta: U2FsdGVkX18xZVB2FNiAMpDmTosgLoo9eNA1Zc+k+eNGBi4w5WIyHZw39Itolsq8EzYFra2K8086KwsEjEX6NQ0O7tDRtAKo+Y3baDPEQuj/fMSENONOkNvqOk+goBWg8nWiaHkOoI4F12YougRyKC7OVJOFsvS5w0I9os+StbElKwdjKkoJQgYddYac4Ircr5Sy7hdRDch+RMS+Exl+r1scaN5GKMIkB+CfOMkIDBRX/wlFlfHX7koNCFORyK6fx0e4T6suNjlsU3IGO7xyDICPemCgL++OC7OQbofOd6kPqQQz8TadnK0xOR4l34eNQIdNDx+xGxKrFwTaNwkYAcRTQAFAw2MhzS2KoagBr0NM7GhRgaZ4zBu27v19oc8C9HFo2s5ZDWmy3QkvMbNse0PlJ5FaTfx/Wi+7T9FYq4ToDQhNOS568jEavpbMsnr9rLMaz6Vn+psS2imneuyNinjVRExQPWTC3RXYexhcEMddC84IcRxRpF5Gte12GwEUBY2CR+64jNp+LRMHCWHo5ckQli9RKeLNa+ZJumH80FuL7OKg25cQWNVfLsu9F1gw118i5Lpx7b7ux/5bq22H8LGZWDtBl0QMxhr7/C47LO9FVOHvnu+2oQQs4pLdO21yGxCXipDEKmARKGaVARZ7dJAbzPtGUL/wi5PfJ/5hMYTssMPR61nYTwfIkXbYiSQTdbbqmS2l7aY5Al10wOxs0a90kWaqsl0LJIf0rtDfuIFZvHWMoDdgoFyjdVqKiPbGNuFgAmJYdedq3nW6TUKNsMVDnqqs5RkIDmBpM2d6izR2pmgrQ8s8YsXUaamzXKIZyzbZCP5AkpJQb7wQoALMnjB4/4olbi/n0kdAS9w4TqV/6p2MDEVzOMdXBLv753cJBLJiTDiRxNZIsxhKU5MfpSnmzO2KjHesdnyZzoFUOklSNcoJVZcfxFC3an13Yw9uGXMiyq3M2e0ok+zoU3+
 nQXcplqO
 peSuc1PLMqVfjd7VC3OdrCrldDzh3at3k53SPprvUnZ0j+waMR9QYLB7CUrHQ0He0Ylzg68j8eZkFxUZLIyhijT7iFb3gMfG6oFCEeOB9XRW2EZeNyvpGKGBwtkC2gYU/z9L24bNFisv0VhEXdVvEFryTV2yuV8XewaYM1b4HqdYFFsmP64kVlYkdSFzjx0ltYoWDI1yOWIyTAqtVCQFb2BhtK5jRDE/zlSQMeEywwo9jTq5xjtCCGNi/k+2yzTHDUlyZeekON02TNsb7h75kz2fX0ZwSEKd1Cu5Xfz1AfhhigruJutRZy2sU8hv89fBW5tzgyhYHLx8n7UHnPgGfGSCKBVy3nih8vf/ahjiF4YCM2HlMrWP1r8b+Nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If damon_update_monitoring_result() is called at the end of the
aggregation interval, probe_hits is not reset.  That's because the value
will be exposed to the user via damon_region_aggregated trace event.

Meanwhile, damon_probe_hits_mvsum() can be called in this state.  Due to
its logic, it will return a value that is incorrectly high.  This could
happen  if the user requested DAMOS schemes applied regions sysfs files
update exactly in the time sequence.

The impact is minor, but better to avoid.  Check the timing and simply
return the fully aggregated last_probe_hits, like
damon_nr_accesses_mvsum() also does.  It is not 100% accurate since it
is the last interval's aggregation.  But better than the value that is
completely reset.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 15d31285515d6..11473aa1f70f4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -290,6 +290,9 @@ unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 			ctx->passed_sample_intervals;
 	left_window_bp = mult_frac(left_window, 10000, window_len);
 
+	if (left_window_bp == 10000)
+		return r->last_probe_hits[probe_idx];
+
 	return damon_mvsum(r->probe_hits[probe_idx],
 			r->last_probe_hits[probe_idx], left_window_bp);
 }
-- 
2.47.3

