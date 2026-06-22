Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E50ACCD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6606B00AC; Mon, 22 Jun 2026 10:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876E06B00B1; Mon, 22 Jun 2026 10:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B4266B00B4; Mon, 22 Jun 2026 10:22:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 234D56B00AC
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:22:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49EB8140192
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:00 +0000 (UTC)
X-FDA: 84907762800.06.F7B51BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id BDF6540011
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HFlGElAz;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BGWzxU5bZaNSYgN3wX42/Kk6A34qbqSNs910LdacOd4=;
	b=FjUxUj08T0/6vs9Go6QjrMUgJyQx3TrrT4/vj3WU1wwTBELB5a3P8bEzYKYWcSMfAWCwoP
	cj05bcmYTeGFMsKhTt95GTpM6AKDeH/vE5DZh+SiuYPzhwwd8V7DxGTeJBe+ef2N1ICI1z
	iznuPDCGnT5ZxU4OQEDVzTsXrHYBxLo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138118;
	b=qA/rEAwtXMr7Q68gy4QR2DXlvZQW6Bmzu16+wOW8kYJwMRN8WGYsNttOm90d7bU+eF9wmP
	7X3KIR7Z93n8PWSXitxKCndPAwyF8OA9ldO+MaC17gA4TtTO5fd4x6W82MNJZludWvmCQK
	YCe8DtM7oQpAbJB3Nm4GV+J38sfPeAM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HFlGElAz;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 63D0A601F8;
	Mon, 22 Jun 2026 14:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB881F00A3D;
	Mon, 22 Jun 2026 14:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138118;
	bh=BGWzxU5bZaNSYgN3wX42/Kk6A34qbqSNs910LdacOd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFlGElAzlA6mNvqYV655G9zaorPSKChkQSdKwYtV2iEoiTmMsfOiVYtCp5xFSKN8F
	 8DjxI2xcLN1XjlPd1b3f/kQ915FH1ouf0Em7Q5hQZLHIha5kI8tYat+2QfWAZsxlPh
	 qXqpS/kT8aHbuM9GSJ1unAz+6viJbb8gAnk0ZvVkr8OvZAewFttEHxQ9pxuPX4gEP+
	 9OW/8WOLOS2CBsfDg1Jx2TC1ZAFLWWuqulnqffVhc+moYNTrAxdiQAcxaWA4MiH7RO
	 d/2rfmC0x/2ofleTEGKroVAor5fgJNutpJ2srL4lMYn0Cd+jETVh6xlLDIXOTyI6Zd
	 29PmXLhBAGTQw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 09/18] mm/damon/core: remove damon_verify_reset_aggregated()
Date: Mon, 22 Jun 2026 07:21:29 -0700
Message-ID: <20260622142139.30269-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622142139.30269-1-sj@kernel.org>
References: <20260622142139.30269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1zxa7ooju8q5xystx9jbwyhzacjk8o8b
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BDF6540011
X-HE-Tag: 1782138118-606983
X-HE-Meta: U2FsdGVkX19lwl5H9XlqeSzYAtfd5gU1p/HyOEmcm8sowhYRrCsHZQ291K5tVl12Nv8/xKVEMt7453iwG78eMgifgKoYgT4lyuPcu6DqkFoQcpD7D9h0giYcKOAPT1SLWcygYzD4Iu/nLHus6jdIJRagvKMRx+EDltlWO+AQW2SGJYe1ULKZfEEXT+tEj4iR2dOdk9XB8kLbOD7Vt+8DWCf/ZEUyP8RLyBYThDwUZdyJaEMrskj/dbCSjEPMMGIzP2tiQiR5s/FghXGq5T9qrCH146k53TFbo/kcmjHatXIRp4VgFOiKJzs6o0H5MawBQ3q3xw8iFMBS4EpFEnmwJ3wwK38Ey7sG9g9fvCfd1d6/3NMyBZlsqiHnjKWqM6WlfxDZHl1j3oioXfm4cS+Kd/8RgJ8eHsur8vQUt02XgkoiAu4uz8lnmxHLVQB2ofqfd1pF3zJ/s65FjrCxm92oPTAEPQa71oa9XRJ0Krjf+R/W5CHx3Y0ne6M91h/HRUSHnDZrm9qnl4ePCwY9iaaBuwZcJIXUFXNbVtLQocNdSIUU79dVnfdEffNQQiJBy0soV75BbRy7B7ZQnkF2B1xPgpIjyK+T3vDNwyp+wEejhm3r0KmaBp9SSljqu5BYLcqgcSjX7Y1my/IaIcz7FxlZ88rqCRSTbtQpXDXiJM/YHyRnP/i2mXvRmfuiF2STFgfmnmCFGnWktVjOCYeppsMWTsnSjIyFbO9dtWTikaE2bKnE0FanvFnRIRWQGISoGneh/mb1zDwGXJ3mEQmp9pUMHjLuHhKSH+V53CRxCabNg2UYmUKgDu+ja2ILlUHI6rXMuqxAij+St8E0CMr9DAEo52+oumNem6HtoUyv9VsHUyPkAeEkgNu5P4JoyacND804odVTozMtSnPSMZdIBvqz0rBuRyQvsg2e886HdiN3skQXsgVWQxxeM4MBFqZyUTjfm4vfZgubMz+Sz0PTfCz
 IVcB2H9r
 H9PS93nqFdz7Ik4orMMZLqJIseU174j6Rdp/B67PViMbf5XwkN63Q0rSSLhRdHkvpRt5H4f2mKXrtlCiYRPatvWkdhuUCIsrTtFfoVEEYGI1iUGGoZyZLlS/+tOqWi2AdvtSM5txm0/An8bHivlGuCncq7eOwVf7zsoBy+n0oichvaq0D5gQxyIEStYNjVtwO9kJJjzXIpwJarqaRIlJXjZIZoHcr94E1A4B28hCar4Hl+o73bX/fIEZFewHAUmskXnEv/bIUUIPTilo50Ai2aukA7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nr_accesses_bp is no longer being used in real use cases.  Remove its
validation function.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 89ac5552085a8..84052fa009158 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2002,23 +2002,6 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
 	return 0;
 }
 
-#ifdef CONFIG_DAMON_DEBUG_SANITY
-static void damon_verify_reset_aggregated(struct damon_region *r,
-		struct damon_ctx *c)
-{
-	WARN_ONCE(r->nr_accesses_bp != r->last_nr_accesses * 10000,
-			"nr_accesses_bp %u last_nr_accesses %u sis %lu %lu\n",
-			r->nr_accesses_bp, r->last_nr_accesses,
-			c->passed_sample_intervals, c->next_aggregation_sis);
-}
-#else
-static void damon_verify_reset_aggregated(struct damon_region *r,
-		struct damon_ctx *c)
-{
-}
-#endif
-
-
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
@@ -2047,7 +2030,6 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			r->nr_accesses = 0;
 			for (i = 0; i < DAMON_MAX_PROBES; i++)
 				r->probe_hits[i] = 0;
-			damon_verify_reset_aggregated(r, c);
 		}
 		ti++;
 	}
-- 
2.47.3

