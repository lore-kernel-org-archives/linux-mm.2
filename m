Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C84BCA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 15:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27F8A6B008C; Thu,  8 Oct 2026 11:20:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 230476B0092; Thu,  8 Oct 2026 11:20:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0D46B0093; Thu,  8 Oct 2026 11:20:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBA706B008C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:20:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C0D41A02C6
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:20:25 +0000 (UTC)
X-FDA: 85299820410.27.601F5B9
Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0129240007
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:20:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b="x lvcfMK";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="kGQc/1bM";
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of suhaas@s-joshi.in designates 103.168.172.143 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791472823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6rh0PqVWjs0+3QPQMIsutYwuCznqT4PXGPb0xZDsJpE=;
	b=mFBFoeeuH+5RouckRRQDXwPZP9XKSIrw6LKWCUYYrNNZYhueP7bB53TXq9o2OCXo+uElTy
	2YNyWiHSjwE+6a9wR/wjOG7sUKkfRreNCHhps98KmUNWdBA37H0L+u8tI+LDACAL1Rofc7
	wxUnVDyBALdECgsXdmNfcKMLrsN2nDY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b="x lvcfMK";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="kGQc/1bM";
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of suhaas@s-joshi.in designates 103.168.172.143 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791472823;
	b=NhyC6C9vLC6dPlisTN4GFYHKNna3KOB61gedEWCu48ZFrFC9yeOD/bDC0LWpBoIoB/Gz0q
	YLgesAyrJqpvnW0T85xlGO7ynqD2ezQ+mxL7cgMivc9woP1ypi07OrbuGGse2EVhs4I2ne
	dk6At5HsnkLVUy/CYRBhJoO5wUKm3K4=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id 914BA13804BB
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:20:22 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 08 Oct 2026 11:20:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s-joshi.in; h=cc
	:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1791472822; x=
	1791476422; bh=6rh0PqVWjs0+3QPQMIsutYwuCznqT4PXGPb0xZDsJpE=; b=x
	lvcfMKitJZHnPNpiQfvIyP24F5yexE7hMZap5xmiKvjGQhtdGfJRQBoa/+uERG4I
	dc1Q17C4BL60a+Hn1TR9Xug+efDTRYDvZut4mfKFqGEPVbRro8rIJJSJ7A774fgL
	ytzLdUS6ocTJePMgNejrJ4+DuxHUNkGQOKAB2xyzwdG7M33r9QllSFAMbXAw9mj+
	e82Uj7EVllIVd0mHVTUACNQ2MRaffvzoLEshDUXVEmlUWwo/YbMAqMtoW2LgQO4N
	Pfwgu/MvviG4Tyh1N+/wGfJUovg41NnSAjmptrH258xXYtKT2mnFL3re0/PIAFNz
	YYMbFrSfrandYa6TawbLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1791472822; x=1791476422; bh=6
	rh0PqVWjs0+3QPQMIsutYwuCznqT4PXGPb0xZDsJpE=; b=kGQc/1bMCbpo70ZQZ
	fA2+tqcYoscREmF8gPvEj9CN8ArdMrHWUrhm/aybZSjmRNfbPuI6vJqw6PZtergZ
	7rOrorrIbswLcc3NoZe7VhEg1q14VqVlzn6KPhPHRL/PXu3LuMjpeJYqZAovG+KI
	94H7jrsU1z6y6OBsvxncvnjDplf+Ijj6/ElA1xyRsxatlgdwq3DU/uR+Y0oH68iH
	zjt2Wzb/z4700fxpd/48TTMNoZtPN92QJmRdrsY5gNKLOr11pv3QvwZLVZWCtV3R
	gMW8pfHAunXOpVE08zSMvrfguMJtDsMmYgZcJ8/zC9ONE0zeuBYNuRO0iggCglMO
	RSX8Q==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=s-joshi.in a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791472822; d=s-joshi.in;
	mf=PHN1aGFhc0BzLWpvc2hpLmluPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:G9GBZHGljBRaUm299/vJPP6bnhSwkbVy0wVGQE9xKOLwLOT
	2+xFgXIBrF40sRTKO3AXJ4SbXqeJPgxCOOLWx7C5SqXDceC6NdaCjXDIEKHBCUe6
	fU0VYzDvURh1hxQx1pbKz0aJ8XWgeikZ+86Bk/JCTFeGR6ggvVK5rnGhEmoROgVa
	fx+NqCZuwctLhNxfy7vlmVauG8hr66k98Oc/n/LCf90bcjv/wfpyBEwaGEp67rEn
	XSbIy2OgikhmijH8VwmG45InoKz4E3+1Kngf8OwLoatXI8nc9m0Yap8a2sIWcGIJ
	o9mfamvz8QucIhyl77g461P5uDBkutuYek92lZQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:JeRmy8VpZusi9wmRgncbH9C467D+OtBW9yCkQ9h/Fns=:IoXp3bc9DZ6vOZyETGFaTgR+fn73FxzVEKJ3+lh6sYo=;
X-ME-Sender: <xms:trTHahFjuyM4Qn5VjolxHqmCC5DxVLLS5PCpKMuVQt9rDLXEkP1tYA>
    <xme:trTHanDiJTKbkN144286Wm3_4h1xHtBiuZdWnb7I5-18espCOx2T6oi1vap9jbvK5
    5PUcjS4oIhrDlspJLgf1Wt0k2_GFW8sh1pXXPXMc_ArrHd01Jf-leY>
X-ME-Received: <xmr:trTHahXehooAFvBTLy5WRNxzxI0ypAzAX6BZ_YzSDw2YwUqvTr-IMOV_KA>
X-ME-Proxy-Cause: dmFkZTGw4cW8duv08kIWxjs2BGgtMj2MekkbWQhuS1Zs18hlYVZkN74okfKvstA3KgUHWH
    4N26/mEHeyoAFvLEGksFN2P/9LzpeSKDBoZl32N4i98jXFmW5ClE1C54fQE/JsBcktI5jL
    OTo65tOem1jMStbTw36olCRqaGUqenGAppO4hwb4Cj4cPy2vvoWsZVRqFvwYRlrTMaA5Rk
    7froXThWs/CyGiAM791wkT/UbCRUphTzxOeeWTdkBLopMeqg9QAbh/GnQrl4LqCr502gDG
    gdWiqBrjcjXtMGan0VmqcqXBEmKdXofYhI/JY96TmrSraTYOyAeVBUNJqCVgc7btTYnJZJ
    KPKiggFQ32R462zmuTG8HqmkKjVhxQ12CBkyFkZku+iVo80nuX6UjsB5DfoxpUKETLUz5B
    0YHtpw1aDUD01QThzd1RojLvZWll6Wb2UC6jD1hY7+T2cAebrSdjhpmDPX1Rxxu0daieTy
    hkI0jpO7MlS3dQPgVx3I7RRSLFRtBuCDXZgc26Y+iBHy0iO9Iib179sEDCDqzX5MHsi0XZ
    B6BiaIdTg4kVWVqlZr+mN+xQ5QLKOJZoaRc5YJ69lVM7UGrbD4sZ0/W7PuwIJ6H1NJsP+f
    oOhnqg5cj4Cd4Hphl+UyE0LhallTsvtoekyauWfLadK3bMcMJEBacNQvj2cg
X-ME-Proxy: <xmx:trTHarrMnGpz4I5x20aWdysTOylVk0ZCQeHuEpvd6Okt7l-xQ32_iQ>
    <xmx:trTHatSiBMC0ZQpHLc5sB_C_w5sMiG1N0AOjwlZ9pRUzWu5ToaCNFQ>
    <xmx:trTHal3HHG4F9iSfYehXqmsS2dE6RnelT_qV9cNv4lmL-ZMdks0XlA>
    <xmx:trTHapAup8BgtogEVUfb9WWhg0PiHnJU3nScYe77mJAv-cnwyUEfrw>
    <xmx:trTHajZWRyywf0dSHyOQ5tEs10FybVE0W6Jd8RA4abideOK7MqI53vKp>
Feedback-ID: ia9504abf:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Oct 2026 11:20:21 -0400 (EDT)
From: Suhaas Joshi <suhaas@s-joshi.in>
To: sj@kernel.org,
	akpm@linux-foundation.org,
	aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] mm/damon/core: Copy only installed probe in damon_split_region_at()
Date: Thu,  8 Oct 2026 20:49:26 +0530
Message-ID: <20261008151944.113714-3-suhaas@s-joshi.in>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261008151944.113714-1-suhaas@s-joshi.in>
References: <20261008151944.113714-1-suhaas@s-joshi.in>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yxuzq8uxiw8ccy7a3tdg5ikud3j1qk49
X-Rspam-User: 
X-Rspamd-Queue-Id: 0129240007
X-Rspamd-Server: rspam08
X-HE-Tag: 1791472822-135605
X-HE-Meta: U2FsdGVkX1/4hhScpPQ3mmp43VPluMUYgct0zzdNW9XhZ6b0lNhF/c2gxnR7q0REOPybniskrJjZtt3uC6UszqwABTGJPhP9vpcMDLUmOvqQ7j0WncXnFCWh3MsdMIP76b2Stbc08wldgjFFnD7zbcNBZ+p0KN6mPeXB0jGUip4gokN1gpYUYAn+xfNjwKQ2BGiEQMXx3gdsO3nztBZTUG32qie/wkQANYx3OO7wUvDJY9zIma2PrQsRhSqN2TcZvAJ1/rhgMEm/6rZfTg0MczvTQcJ/CNtKU9HRDlTYzMSUU1tI7l5WatSFXWEVeHWHBSjAmDnm0CIBOsUCPIZbI4TIcEjOQXsfW9wk5pt5bJtwSn+BhU45QmXZr+l5d3TRo655f9sekPqX3RWf7330rIEnX2cYOlVzrzYsYkEX0iujyc2vUSv3c4KtcfXQtsP0FFhilsn4j3siWyO+PEaB4AkYHL51SzmbfshREpgIHrCPQgARUnC2rfcZ87bqAwL5WXm4a/FiJMmKTaJ0OrYSDwTjO5zHfiLws+CCoUy1lzNoIijdhoIJlMIMtzqKik3InmmpTT1RTSvPEXWwoSToPn7qXhPyPv2gc/TiCR9grpn04TmAkc/O6HT3aUIjqJN+kmEhleuFw+LX/yIT3DE/s3qjIaOCjZt1O94mbFHzOFgqfgPQz1rPXXJ1F7MeABDlEv0yRX8Gvh0VZM4IGzGmIwVLuhffAhlbPgMOV00p41DISi0Q2YxmcoiDMsPw6wPRurZ68hyYHRLM4rd4FKxP463sYgtK3nmTvcoCRg1vsCGHfpcCR6VX6EpBBjtg2a9g1ALWqKQv98xeuw0NkoIvtpxFtLmWVHKVylSVh0TjvivTGEZpgIC0wV5QUiiGRFdQXWsFkj6pKWyAIRRI0znyAIJXCKeBhkvXUmjJN/3Qxdksz7uetoSPEjqDnKP04VAs+UnBHdzfxCpQEZbX4MO
 OKaWfskS
 6xpCgwHVyNkIU0lHURLkn000b/+EPYN6vYCtvD8jgisybXF/A2VlXmVeL2fSD1liRtJu07n1X4YVsz0HrR5G4ADB+/EjqsjNcFBilkzV5supwoGdc4HigQ9l9HsGz56HLHmIvzng+r6mboyP7Wi9j5LO3zbNsV3EBUfPbdVd3HxKU/D5tGWuNfKN74ZYhMR1uDsriG87E5WKk85LD4eBL0yyZnmDMeaYj0u2awkvgXPX3JY2s0FHB6ftzlg+C17nAD5kP3dwBtCDXTwPn0b4zmV6zhJBkLtyNNouc3HeWPEKnPYUkEyslM2Bb97UQx2kuGJlG6CuPn79P1ZM1VEyZpLhicjB+qa17HzrFXshEZ77kAeYr0LlE6AJthaTJiJccMisq0d14HiAMxi2xOlieTjMbIg==
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
 mm/damon/core.c             | 45 +++++++++++++++++++---------------
 mm/damon/tests/core-kunit.h | 48 ++++++++++++++++++++++++++++++-------
 2 files changed, 66 insertions(+), 27 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index fc202f90991b..9e5a19c2a19d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2051,8 +2051,8 @@ static unsigned long damon_region_sz_limit(struct damon_ctx *ctx)
 	return sz;
 }
 
-static int damon_split_region_at(struct damon_target *t,
-				  struct damon_region *r, unsigned long sz_r);
+static int damon_split_region_at(struct damon_ctx *ctx, struct damon_target *t,
+				 struct damon_region *r, unsigned long sz_r);
 
 /*
  * damon_apply_min_nr_regions() - Make effect of min_nr_regions parameter.
@@ -2077,7 +2077,7 @@ static unsigned long damon_apply_min_nr_regions(struct damon_ctx *ctx)
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region_safe(r, next, t) {
 			while (damon_sz_region(r) > max_region_sz) {
-				if (damon_split_region_at(t, r, max_region_sz))
+				if (damon_split_region_at(ctx, t, r, max_region_sz))
 					goto out;
 				r = damon_next_region(r);
 			}
@@ -2474,6 +2474,7 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
 /*
  * damos_skip_charged_region() - Check if the given region or starting part of
  * it is already charged for the DAMOS quota.
+ * @ctx: The pointer to the context.
  * @t:	The target of the region.
  * @rp:	The pointer to the region.
  * @s:	The scheme to be applied.
@@ -2496,9 +2497,10 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
  *
  * Return: true if the region should be skipped, false otherwise.
  */
-static bool damos_skip_charged_region(struct damon_target *t,
-		struct damon_region *r, struct damos *s,
-		unsigned long min_region_sz)
+static bool damos_skip_charged_region(struct damon_ctx *ctx,
+				      struct damon_target *t,
+				      struct damon_region *r, struct damos *s,
+				      unsigned long min_region_sz)
 {
 	struct damos_quota *quota = &s->quota;
 	unsigned long sz_to_skip;
@@ -2525,7 +2527,7 @@ static bool damos_skip_charged_region(struct damon_target *t,
 				}
 				sz_to_skip = min_region_sz;
 			}
-			damon_split_region_at(t, r, sz_to_skip);
+			damon_split_region_at(ctx, t, r, sz_to_skip);
 			skip = true;
 		}
 	}
@@ -2583,12 +2585,12 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
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
@@ -2781,7 +2783,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 					c->min_region_sz);
 			if (!sz)
 				goto update_stat;
-			if (damon_split_region_at(t, r, sz))
+			if (damon_split_region_at(c, t, r, sz))
 				goto update_stat;
 		}
 		if (damos_core_filter_out(c, t, r, s))
@@ -2828,7 +2830,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (damos_quota_is_full(quota, c->min_region_sz))
 			continue;
 
-		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
+		if (damos_skip_charged_region(c, t, r, s, c->min_region_sz))
 			continue;
 
 		if (s->max_nr_snapshots &&
@@ -3666,15 +3668,18 @@ static void damon_verify_split_region_at(struct damon_region *r,
 /*
  * Split a region in two
  *
+ * ctx		pointer to the region's context
  * r		the region to be split
  * sz_r		size of the first sub-region that will be made
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
@@ -3686,11 +3691,13 @@ static int damon_split_region_at(struct damon_target *t,
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
@@ -3719,7 +3726,7 @@ static void damon_split_regions_of(struct damon_ctx *ctx,
 			if (sz_sub == 0 || sz_sub >= sz_region)
 				continue;
 
-			damon_split_region_at(t, r, sz_sub);
+			damon_split_region_at(ctx, t, r, sz_sub);
 			sz_region = sz_sub;
 		}
 	}
@@ -3751,7 +3758,7 @@ static void damon_split_some_regions(struct damon_ctx *ctx,
 			if (sz_sub == 0 || sz_sub >= sz_region)
 				continue;
 
-			damon_split_region_at(t, r, sz_sub);
+			damon_split_region_at(ctx, t, r, sz_sub);
 		}
 	}
 }
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 4e380c6c5eb2..b942598e8dc2 100644
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
@@ -1799,19 +1814,35 @@ static void damos_test_filter_out(struct kunit *test)
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
@@ -1819,27 +1850,27 @@ static void damos_test_filter_out(struct kunit *test)
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
@@ -1855,7 +1886,7 @@ static void damos_test_filter_out(struct kunit *test)
 	r->ar.start = 2;
 	r->ar.end = 8;
 	KUNIT_EXPECT_TRUE(test,
-			damos_filter_match(NULL, t, r, f, 1));
+			damos_filter_match(ctx, t, r, f, 1));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, 2);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 6);
@@ -1868,6 +1899,7 @@ static void damos_test_filter_out(struct kunit *test)
 	damon_destroy_region(r2, t);
 
 out:
+	damon_destroy_ctx(ctx);
 	damon_free_target(t);
 	damos_free_filter(f);
 }
-- 
2.55.0


