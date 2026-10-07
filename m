Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17011CA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 15:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1023B6B008C; Wed,  7 Oct 2026 11:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA816B0092; Wed,  7 Oct 2026 11:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4D16B0093; Wed,  7 Oct 2026 11:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC3D06B008C
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:49:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 170E61A02C4
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 15:49:32 +0000 (UTC)
X-FDA: 85296264984.21.28EEA3F
Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	by imf26.hostedemail.com (Postfix) with ESMTP id E70BA140007
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 15:49:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b="J pmXNUy";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=OYuZ+sQs;
	spf=pass (imf26.hostedemail.com: domain of suhaas@s-joshi.in designates 103.168.172.139 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791388170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMzj+0i9NThcJ6q8TSEFs4eoC4MBdtZJg2mYQDdAvN4=;
	b=46a2exbm8WjhgDdBtuK81UsTOsdouJug2im6THBH7J55igRWNuyVxr+xNTRe37dbP21Xxp
	fJto6Q4b9LH3Rfi1f5u3eGwURB4hs4wEzgiVNWEwZle0IeluCA0fGyYqjqERQR/dCQw6qA
	IGnJH15vfdtr3bjeivwcGSUTaY+7FnA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791388170;
	b=uWMFNE8km8S/oG90gRIHXihLI800X6n+GFkL2TCuwdrpFqcyhgalwqVEcvusohJcvezT/F
	CQDZSzhMPDTNAKYtzIVGUNNPLaTxCeu+NRod1ji6fFTv9IViGOFSgj2zzdoBNMMDgg22q4
	KSN7G6w8wWYe71CIsdKGxw+XRA54FQE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b="J pmXNUy";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=OYuZ+sQs;
	spf=pass (imf26.hostedemail.com: domain of suhaas@s-joshi.in designates 103.168.172.139 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id 8253D13801DE
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:49:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 07 Oct 2026 11:49:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s-joshi.in; h=cc
	:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1791388169; x=
	1791391769; bh=NMzj+0i9NThcJ6q8TSEFs4eoC4MBdtZJg2mYQDdAvN4=; b=J
	pmXNUyDSsiJ7zfYJSF18AGNLAXDcZGSTWvdFh4QCGsJqlEhBgQzq96UhPWD0e7TY
	oXCnD4EFGVS+SKN0DInYQytBIS91/AyWWJIWZsmOeIrofGs1tEq2aTCXasvqFEFx
	ACRzIU11zHOHb+Q/7J5TbBSBvdCGH3uP5EAWcxTM0154zgGOF8B5sInp84kYFXTj
	evNPfZQ+CQWXjVTXzNEIETppTNRxav+NhWn3Dqxv2K2+X1LhSLEeuTiiqKjgql6s
	qaZjIwaG/+fPgm2UPqtq+jCOttheQJSFrTpkEwrE3MHvbOhUbNsj/rwyjdvONNjO
	zgbeDTkI3o+kSKsx/wKvw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1791388169; x=1791391769; bh=N
	Mzj+0i9NThcJ6q8TSEFs4eoC4MBdtZJg2mYQDdAvN4=; b=OYuZ+sQsFEMkdvZLP
	HixoehhJYyLOlut2GRlKP5wQof4f7mC4KjRJr/JE+sSWuBu2uNOgZMBsJHmaHdKw
	0WGb0+cZIc03pSuxbioU7HlBa5uQAaOyWjFdgiU0lCzB9OipFUOzbzngdczfK2Sn
	3Saixd5HOptRMKvPnjE9ylL8CZHMRCc8AvwwFFegF2XZgGtenueOu4iZ/gvPCZAv
	0CTE5IauN3U8Y5Kgk3hmBFd7Pgprj4TbZlOmzaaxGtjbkQGQmCUc/W8LAG4+enhm
	4TQB28jTq4Zhw40K7ubOdpSmdHMLRE7fdEQjEjAgKf5kx/Od5CJJa/qsB8I/UYHT
	/JByQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=s-joshi.in a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791388169; d=s-joshi.in;
	mf=PHN1aGFhc0BzLWpvc2hpLmluPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:xt/dOxM00M5SseM9hu/ayNhERmfDBFgJNx6XnaopLd/RKf2
	8lM3XUDh1rw2JIgeAfFgx3W1X4xQ9wXReXJaENriPetzVPxXX/1RU6O02T773tO+
	qHSK3sx7ZFgwrAB5Fm8ChC0m8eHKwNgUYVII9t8nGzY8nNy9XsCgS++RiG85Ggdu
	xlI0kWDI8vVgcq7I7tP7zLgxhieFqzA4/sKvjbo9pb/05vSSJn9AgOBcTyeRXusP
	6nMyvPdtzWszblPPMJY4/sXi9d4wyUeIZty0Sphcbhw3F+Jkimbo+sIRHS/fkxOb
	RQX6kp2x9qtgcIlPzOFatVDwKBVBxsuMb1fqm9w==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:7AQ9A5q7IWuAEQ0ViyW9S4JAu6xYUCd/GdG3tTeUDtg=:SJ85HzI3nnTUKBjbG9eDMxU8wMh9OyTklgMqk6xA5BU=;
X-ME-Sender: <xms:CWrGav5_hxK97RNu0wEmCXqVNZvadydOOrr1T__GXlP8vsp0_KOVug>
    <xme:CWrGauMixcZRSaCM7J3v1uCgPLsuf9AZlNscO2kUZ1X5yCjonvEYWzD79K9dz1b0B
    Dile7UdaF6af3evaJ7FbYbWFm2OgAVOzyiI8B7rxbdCRX81IlcvzOIZ>
X-ME-Received: <xmr:CWrGatubASkOwrKCV7Xfjp9fuvO4-JoWMZ3lw-R9cTR2otCjCD4Emk8GXA>
X-ME-Proxy-Cause: dmFkZTEBaUDDO6ngTf2qaoSnvem6liDvuhKl/9yQVpKqZxwy4l1eqKxf+EyLhO58G5o0Gk
    FCVZ5dgt+2a+9WSMNk6P1NC/alZr9x3nei1HF3ulSpjUgDRWm3MOfiENnwy+bbJnNFqBv6
    01JjNYluYE02hPPSGuQvtWjRl4n20jQ98HoA3X45Z/VIWCArdnL60YadLRBc+c9Y0G+ABZ
    CKUZ3Lv3++BdVjZn1l3etwpTvSpv9G6XBVnQOcuLLi0b/OpnpZAFrIIuZDZQXHaaNKuDUo
    8HvPsQHd4nffXMvs7XIOg/J6/2EI+tKqpbMZB4s1+BkZ0nB6uTNWeGWijEEeSu74c8NTQJ
    vsEkXXlJdTlvMzVDgeOAXKkuNn2KNTLOMcqRe9Th1pl5qe5XU5fYkcJ3CBo/NqO8s66dB4
    bVOPVqPEin8sahcf4meKLM+ECBsqHvfnA05IgMmeo58ltlR4+DWifCAMjHhK77ViOYHn+z
    S8gVZJoQRlgeDs5O2tG6U4AQHWyZSpE/qBxnYBuU4m625TkjN56HZBHzevAClgn35/35Xd
    RSmsEvhk+iytFzrUn5DUUUnujyUL3mhzdinr8JjnJiikdQ/uRIkMXNs9GuIKVFQly1UAKU
    0icnpZPp1t7l55kZltznc2HKVlsTVVWZigF0pt2ZU4a4Dark6bNdAJvI57LA
X-ME-Proxy: <xmx:CWrGahY9yg7hO9h_-IYyWsQm3PlRaPLDlWdWw8KXY-x6gqv5J868mg>
    <xmx:CWrGavw8TnGNSi0HUwsm3kjUEVoNZ7Hc5m29K77FT5i2RhEil9z2jg>
    <xmx:CWrGaphjOEgaDI8Sd3Zo5GX2VRCKJYCWTMhXAXvqI72gGQ_JCpLp0A>
    <xmx:CWrGarnT4PTJWRQpHbR65c6S2Q-NhnEGGvbhIO5F2O7ypGcpckA24w>
    <xmx:CWrGahKiom2Ru4Yd_ao7GxHuBKaCW5pz-J_Q0qH3ZX_uGxXXr45J39Nw>
Feedback-ID: ia9504abf:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Oct 2026 11:49:28 -0400 (EDT)
From: Suhaas Joshi <suhaas@s-joshi.in>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	suhaas@s-joshi.in
Subject: [PATCH 2/2] mm/damon/core: Copy only installed probe in damon_split_region_at()
Date: Wed,  7 Oct 2026 21:18:46 +0530
Message-ID: <20261007154851.45368-3-suhaas@s-joshi.in>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261007154851.45368-1-suhaas@s-joshi.in>
References: <20261007154851.45368-1-suhaas@s-joshi.in>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E70BA140007
X-Stat-Signature: 7zofpfr8tck18eyyfzm8phxyuhh91bj9
X-HE-Tag: 1791388169-529793
X-HE-Meta: U2FsdGVkX1/GzToUebnDQ4zWsSf7B/3EdJK/cA523riDw13TgKmc2hDfMFwSeGRwnkmg1QEUug3qC+EqxQSQht4zuny2VGBO+5jQ+NIt0RCH3ggJ6jEU3M49pznH0kOfJPKUH488KULTKi/qryVhAFcgh7Ykw4lM5e5Bne5/5czZxyaWREvNdTSNCl32KAorKQMfeU4yWFz2RfTSO4cq8gRGnRv1SryYm0gXZtrlsQFIWBq1FWbgolV0fsN46KWwj8Fz5uGPvX3j+8ct13jupKkYqFifxZ/KVlirNSKAMgw6UEccFLnUZeftIPIoY2P22mfkQkRdKF0TXJpcrQ0Ey+t7QxITNRhQHL2Sz3lVnWccN1xTAfTpMKNUShnx0EgrGn3UzUpElD+X5d7Mi6PFNHzG1Qzd+IGybTW3PzT2WrvT7N4uYNTwDiTYBEiE6l95rKeAMgs6cYb2NvWcG80biofji5hUAMpD+32oswvMVkpToFqigXwuQpWY1xlAEeC5lfYuxDCjc7cFsBEJ+nDx2Ye8qH/6+CP9XFYZsI65AjOYFbtlVxo1MYpn0bFW4TUI5EgddkrY9o23eMRFnS5iTuwAdvaz6WnnHmzVPqnZ4WlnfN9TagTb5/omcq1cpi1m2hd210qq4JvonXqo4N6e+pA+wtLloleOJpbb02t70n01I9dXlSzh4lmXK8mA5GZGTanF9leEcRLRWe5rfKjxmZmy7ixLmxhXUFnvrg2zS1/NWDbk7XPnKw/4HsYEqpS8AnSE2QvNaDBfSbxO1oFyhBKBFM8P/jj6rb0Hmb+hWB06MGBDN3ZFy9MlX07boFpFpbdX7tbDCh6Z3Qu3QGzvUIQaztsksb1VlZM/8mdCeKAUUXufQ2CXS7LzYFX0cloHQc3AfbolVYUGEN6ZjMSCxyckZtORSdwjvyJIuO2kVzluPudnc7yi+Eoc69WdBUhV59FYdji6LkDthQXkHQE
 YEP2BqiK
 gdCJpgjlh0Qum2upvYTypWxs9l6uXMeFtvx62wzWf925WgI26cGR4xCjoF11uq7wNQ9YOdXuDVCIqFjfzTyAeUYU0qMQVDzHUQYupiBCPNNvynfTPwN0S45bneI4R6lrqrGGly59Y9bAC987FPBVlF2TeG1UgslLpXsDjvMtBbw4F33ER/soWVtiDlSLXLp2HI65eE22snjoehBZhQwZxaA8jF9eZ7DIFzxd7hD3lWeqqIb7wlJJSN0hx8182Y6FBEwIqoq+hkn8PypWveodzUk8JXNKDBWG24gitKzm7gOlH+fqatM37knculD7MgZzBpblsbafXtK82OiLlfrZVVbgewiQ1yreUx9a4svJq85GItLdQEfO2wmxw+6Wj/IGq/gQWOS3BqDcCNUPOjAFofuVzgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In damon_split_region_at(), we copy the entire probe_hits[] and
last_probe_hits[] arrays of DAMON_MAX_PROBES size. However it is possible
that the number of probes installed is less than DAMON_MAX_PROBES, in which
case one or more iterations is/are redundant. To remedy this, iterate over
only as many times as the number of installed probes. To do so, accept a
struct damon_ctx pointer in damon_split_region_at(), and update all
invocations of the function to pass the new argument.

Also update damon_test_split_at() and damos_test_filter_out() in
core-kunit.h to supply a context to function paths that call
damon_split_region_at().

Signed-off-by: Suhaas Joshi <suhaas@s-joshi.in>
---
 mm/damon/core.c             | 42 +++++++++++++++++---------------
 mm/damon/tests/core-kunit.h | 48 ++++++++++++++++++++++++++++++-------
 2 files changed, 63 insertions(+), 27 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index a3af5ee685e1..025df4d19e20 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2049,8 +2049,8 @@ static unsigned long damon_region_sz_limit(struct damon_ctx *ctx)
 	return sz;
 }
 
-static int damon_split_region_at(struct damon_target *t,
-				  struct damon_region *r, unsigned long sz_r);
+static int damon_split_region_at(struct damon_ctx *ctx, struct damon_target *t,
+				 struct damon_region *r, unsigned long sz_r);
 
 /*
  * damon_apply_min_nr_regions() - Make effect of min_nr_regions parameter.
@@ -2075,7 +2075,7 @@ static unsigned long damon_apply_min_nr_regions(struct damon_ctx *ctx)
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region_safe(r, next, t) {
 			while (damon_sz_region(r) > max_region_sz) {
-				if (damon_split_region_at(t, r, max_region_sz))
+				if (damon_split_region_at(ctx, t, r, max_region_sz))
 					goto out;
 				r = damon_next_region(r);
 			}
@@ -2494,9 +2494,9 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
  *
  * Return: true if the region should be skipped, false otherwise.
  */
-static bool damos_skip_charged_region(struct damon_target *t,
-		struct damon_region *r, struct damos *s,
-		unsigned long min_region_sz)
+static bool damos_skip_charged_region(struct damon_ctx *ctx, struct damon_target *t,
+				      struct damon_region *r, struct damos *s,
+				      unsigned long min_region_sz)
 {
 	struct damos_quota *quota = &s->quota;
 	unsigned long sz_to_skip;
@@ -2523,7 +2523,7 @@ static bool damos_skip_charged_region(struct damon_target *t,
 				}
 				sz_to_skip = min_region_sz;
 			}
-			damon_split_region_at(t, r, sz_to_skip);
+			damon_split_region_at(ctx, t, r, sz_to_skip);
 			skip = true;
 		}
 	}
@@ -2581,12 +2581,12 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		}
 		/* start before the range and overlap */
 		if (r->ar.start < start) {
-			damon_split_region_at(t, r, start - r->ar.start);
+			damon_split_region_at(ctx, t, r, start - r->ar.start);
 			matched = false;
 			break;
 		}
 		/* start inside the range */
-		damon_split_region_at(t, r, end - r->ar.start);
+		damon_split_region_at(ctx, t, r, end - r->ar.start);
 		matched = true;
 		break;
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
@@ -2779,7 +2779,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 					c->min_region_sz);
 			if (!sz)
 				goto update_stat;
-			if (damon_split_region_at(t, r, sz))
+			if (damon_split_region_at(c, t, r, sz))
 				goto update_stat;
 		}
 		if (damos_core_filter_out(c, t, r, s))
@@ -2826,7 +2826,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (damos_quota_is_full(quota, c->min_region_sz))
 			continue;
 
-		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
+		if (damos_skip_charged_region(c, t, r, s, c->min_region_sz))
 			continue;
 
 		if (s->max_nr_snapshots &&
@@ -3643,10 +3643,12 @@ static void damon_verify_split_region_at(struct damon_region *r,
  *
  * Return: 0 on success, negative error code otherwise.
  */
-static int damon_split_region_at(struct damon_target *t,
-				  struct damon_region *r, unsigned long sz_r)
+static int damon_split_region_at(struct damon_ctx *ctx, struct damon_target *t,
+				 struct damon_region *r, unsigned long sz_r)
 {
 	struct damon_region *new;
+	struct damon_probe *p;
+	int i;
 
 	damon_verify_split_region_at(r, sz_r);
 	new = damon_new_region(r->ar.start + sz_r, r->ar.end);
@@ -3658,11 +3660,13 @@ static int damon_split_region_at(struct damon_target *t,
 	new->age = r->age;
 	new->last_nr_accesses = r->last_nr_accesses;
 	new->nr_accesses = r->nr_accesses;
-	/* todo: do this for only installed probes */
-	memcpy(new->probe_hits, r->probe_hits, sizeof(r->probe_hits));
-	memcpy(new->last_probe_hits, r->last_probe_hits,
-			sizeof(r->last_probe_hits));
 
+	i = 0;
+	damon_for_each_probe(p, ctx) {
+		new->probe_hits[i] = r->probe_hits[i];
+		new->last_probe_hits[i] = r->last_probe_hits[i];
+		++i;
+	}
 	damon_insert_region(new, r, damon_next_region(r), t);
 	return 0;
 }
@@ -3691,7 +3695,7 @@ static void damon_split_regions_of(struct damon_ctx *ctx,
 			if (sz_sub == 0 || sz_sub >= sz_region)
 				continue;
 
-			damon_split_region_at(t, r, sz_sub);
+			damon_split_region_at(ctx, t, r, sz_sub);
 			sz_region = sz_sub;
 		}
 	}
@@ -3723,7 +3727,7 @@ static void damon_split_some_regions(struct damon_ctx *ctx,
 			if (sz_sub == 0 || sz_sub >= sz_region)
 				continue;
 
-			damon_split_region_at(t, r, sz_sub);
+			damon_split_region_at(ctx, t, r, sz_sub);
 		}
 	}
 }
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 5ad89c1d9fc2..e02604c7e0bc 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -141,12 +141,26 @@ static void damon_test_split_at(struct kunit *test)
 {
 	struct damon_target *t;
 	struct damon_region *r, *r_new;
+	struct damon_ctx *ctx;
+	struct damon_probe *p;
 
+	p = damon_new_probe();
+	if (!p)
+		kunit_skip(test, "probe alloc fail");
+	ctx = damon_new_ctx();
+	if (!ctx) {
+		damon_destroy_probe(p);
+		kunit_skip(test, "context alloc fail");
+	}
+	damon_add_probe(ctx, p);
 	t = damon_new_target();
-	if (!t)
+	if (!t) {
+		damon_destroy_ctx(ctx);
 		kunit_skip(test, "target alloc fail");
+	}
 	r = damon_new_region(0, 100);
 	if (!r) {
+		damon_destroy_ctx(ctx);
 		damon_free_target(t);
 		kunit_skip(test, "region alloc fail");
 	}
@@ -156,7 +170,7 @@ static void damon_test_split_at(struct kunit *test)
 	r->last_probe_hits[0] = 3;
 	r->age = 10;
 	damon_add_region(r, t);
-	damon_split_region_at(t, r, 25);
+	damon_split_region_at(ctx, t, r, 25);
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
 	if (damon_nr_regions(t) != 2)
 		goto out;
@@ -176,6 +190,7 @@ static void damon_test_split_at(struct kunit *test)
 
 out:
 	damon_free_target(t);
+	damon_destroy_ctx(ctx);
 }
 
 static void damon_test_merge_two(struct kunit *test)
@@ -1648,19 +1663,35 @@ static void damos_test_filter_out(struct kunit *test)
 	struct damon_target *t;
 	struct damon_region *r, *r2;
 	struct damos_filter *f;
+	struct damon_ctx *ctx;
+	struct damon_probe *p;
+
+	p = damon_new_probe();
+	if (!p)
+		kunit_skip(test, "probe alloc fail");
+	ctx = damon_new_ctx();
+	if (!ctx) {
+		damon_destroy_probe(p);
+		kunit_skip(test, "context alloc fail");
+	}
+	damon_add_probe(ctx, p);
 
 	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
-	if (!f)
+	if (!f) {
+		damon_destroy_ctx(ctx);
 		kunit_skip(test, "filter alloc fail");
+	}
 	f->addr_range = (struct damon_addr_range){.start = 2, .end = 6};
 
 	t = damon_new_target();
 	if (!t) {
+		damon_destroy_ctx(ctx);
 		damos_destroy_filter(f);
 		kunit_skip(test, "target alloc fail");
 	}
 	r = damon_new_region(3, 5);
 	if (!r) {
+		damon_destroy_ctx(ctx);
 		damos_destroy_filter(f);
 		damon_free_target(t);
 		kunit_skip(test, "region alloc fail");
@@ -1668,27 +1699,27 @@ static void damos_test_filter_out(struct kunit *test)
 	damon_add_region(r, t);
 
 	/* region in the range */
-	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f, 1));
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, f, 1));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region before the range */
 	r->ar.start = 1;
 	r->ar.end = 2;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, 1));
+			damos_filter_match(ctx, t, r, f, 1));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region after the range */
 	r->ar.start = 6;
 	r->ar.end = 8;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, 1));
+			damos_filter_match(ctx, t, r, f, 1));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region started before the range */
 	r->ar.start = 1;
 	r->ar.end = 4;
-	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f, 1));
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(ctx, t, r, f, 1));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, 1);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 2);
@@ -1704,7 +1735,7 @@ static void damos_test_filter_out(struct kunit *test)
 	r->ar.start = 2;
 	r->ar.end = 8;
 	KUNIT_EXPECT_TRUE(test,
-			damos_filter_match(NULL, t, r, f, 1));
+			damos_filter_match(ctx, t, r, f, 1));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, 2);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 6);
@@ -1717,6 +1748,7 @@ static void damos_test_filter_out(struct kunit *test)
 	damon_destroy_region(r2, t);
 
 out:
+	damon_destroy_ctx(ctx);
 	damon_free_target(t);
 	damos_free_filter(f);
 }
-- 
2.55.0


