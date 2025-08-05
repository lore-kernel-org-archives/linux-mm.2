Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C99AC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 16:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6DB18E0009; Tue,  5 Aug 2025 12:21:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F6AC8E0001; Tue,  5 Aug 2025 12:21:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5BE8E0009; Tue,  5 Aug 2025 12:21:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7BE4F8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:21:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 076AAB54B6
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:21:03 +0000 (UTC)
X-FDA: 83743218006.16.03BDA14
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1676580009
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:21:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DmVIw1op;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of bijan311@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=bijan311@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754410861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTHZI7K9+4GxRlV7Vt7J0J39jlZPj/iqR6Wo5lhHevk=;
	b=xIgE4rfF7Zdxgp3B07pegYpgciHEVDwwpSFKroz4utw6uvMECxjH7cr4qVxGicgll/sTPY
	NDXEjm8Yo3nBLcfYJqSd3BX6uLx9deU8m+bwKaGLsKXSnJdWP5tP743Dmi1bLxkth2uUhP
	IT55xU4zHLqkNv8+HbZSbTPYrbuopBQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754410861; a=rsa-sha256;
	cv=none;
	b=u/zLdztXgh0cIiK8xMxEXhGD8KX88ugjdiPqFRx2d7HJuiHui1jepy2FY1bRkKfeWIKYaG
	NnfNSs1tjlqA5a4ubQomckFDig1KN0XqAMzzGGPlzvfIl2Pm/TV2J+BsrHhd0qtEr7Il1G
	R9d4kUpYaEGZhq8E8HOtK+24WEeoLks=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DmVIw1op;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of bijan311@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=bijan311@gmail.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-718409593b9so57959677b3.3
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 09:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754410860; x=1755015660; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FTHZI7K9+4GxRlV7Vt7J0J39jlZPj/iqR6Wo5lhHevk=;
        b=DmVIw1opES1fhxnSOKYaaJOkyW3eI91+5yMOVDUY6hj77xr5L67t1Sy569wjC6ZdX3
         17WP2CJAvxlRlCu1UwR4ymZaI/MSnfH6cptXkQQPPiPlUHxafaorWotcl45gBvLKB76T
         8uDpFM6R6eMZPhF8KUXGA7W7zNmQKdiDtroPbz0kHR+Yk522mxR+CXU3mVJ8ItnprzZi
         +M97JF9FwX7ilfnPyZ8QDmF01umG9e7vV1JvOIB4+2vfZYHnVLlK/48wAcHdDrKo7uNT
         jdNJy2fCZcT4KWgkx9QLx0hAHZViFY509/zopJeVvdmsM7tHJIcnWckA2cRtI4JYGMmN
         mUzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754410860; x=1755015660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FTHZI7K9+4GxRlV7Vt7J0J39jlZPj/iqR6Wo5lhHevk=;
        b=EkGlxPTbjpYXJ7ep71lu9lsY1gfPtIpul2aUZKQbgCkvw8cOEhmHQJxYT9O/2BDoSq
         InEJ9G8BWz30TlXqDuGupBDTPnsDUPhm4Gx4ErSwOsDT2geuXB6bv82P1lCyyVprzSUa
         MpfV+vRBDj+zkGl5keh0oe6MZTuVKJmMrY6mrsfiQe9z0MCHJYkYW+D1VRWd+l9Q+1uN
         oa5WZH6sARpCZwvOhiE8Jy61TYv6sQ3zcDdZpIcnwa4dkeXzxXU5T0RCQkZmAcsprfbI
         TTdcst6Hma0rcHqRNgjDNcyRsTspm3jEJVKMNV+rJWZ+5WAD/18px5XfG7r+tYUHxszF
         edaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKz83rjpEjfy0bAEdsx1X9+wNoCGRbHey72B6PifVl2gZDV8IOkDMsG3BYiUN/BUQMKqmpU1WWNA==@kvack.org
X-Gm-Message-State: AOJu0Ywl7sUyFpJ675bpzx+VmmOpCmJ7m9UfAqXUgRP7H1L/nrw/5vnG
	OXLRLjbV0hqZ8UZ58f3shjOaBgOjAMYq/9DJRS6CPcGO55zVS82gwV1A
X-Gm-Gg: ASbGncta26CSX76AOS4pvPbgzOzNdFFn0sFRYO8US0ybKFB+t4JDvob3mb/kh0Vmn8W
	m6bbx1Xd92BSuV4mh2rc0NZqNYVhrriSzTucWIGjLESmk6KHWkczl1A1XTZC7Dh4T81HU2lyABf
	DCtbSDFWkENouC/radnEiEyhYNVbk3V8rTFbLswD/M+3nmsoQ97CxHVcrt2FwfnAXFjvO3qsjwZ
	mz9SnT9vK77NtIO5SG0SBkjH+TweGs0s333OE69SPzccsSULaYQPjoU069OqhVXuxauPH9qvkvq
	0DB9WWd78dVpFzcGKKkPhwUjFBYkr3dW9z+CLMCofUC1OoDQLYOQWRjoftlSK8Pr4iHZ+MC3IW8
	X4nyzKnYq4acpFwlMc58qznGx+isBajAWofKn6jsAAnQ=
X-Google-Smtp-Source: AGHT+IEvW39T/sWp90HWrVkoCtc3N9MROV6TVWwJCqhkh0uDVhaEZjbOJNyDmjL1eVTf6OAsvjkH2A==
X-Received: by 2002:a05:690c:6085:b0:712:d54e:2209 with SMTP id 00721157ae682-71b7f5f743fmr175406147b3.14.1754410859891;
        Tue, 05 Aug 2025 09:20:59 -0700 (PDT)
Received: from bijan-laptop.attlocal.net ([2600:1700:680e:c000:2c65:e45a:e7d5:5f0e])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a5cdfc5sm33098757b3.77.2025.08.05.09.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 09:20:59 -0700 (PDT)
From: Bijan Tabatabai <bijan311@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: sj@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	corbet@lwn.net,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: [PATCH 3/5] mm/damon/sysfs: Implement a command to wait until schemes are applied
Date: Tue,  5 Aug 2025 11:20:20 -0500
Message-ID: <20250805162022.4920-4-bijan311@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250805162022.4920-1-bijan311@gmail.com>
References: <20250805162022.4920-1-bijan311@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1676580009
X-Stat-Signature: xwufgxihu984bp7krhze6n6n418rrmdh
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754410860-879866
X-HE-Meta: U2FsdGVkX1+wWisqqe21EiWcu1f5dfjBOz6X9df5kAj1ir2Wk1rFEow00Lndr2S3949m4XURzhCkCwrDyfluZiWQxiTfAZQpDcjknOuygLiimHoaHzJyVk5+IuyQgOmyuSzBplmJJSlLYiaDfpTW+XSPnTp9mZG0KGI14QG5DNe96/MqF05Tv4keQ5rnIcSVkpjGL1VYL6vIKhLzV4E36xHtBHA6RGr2W44Hh07SIbic8OtXYO4jDXRtizLg380OnArcMUXIEOBz/ekuo6rWvEVeX4MxllBfJ36Ox6tewjf7xfKtDeZwctw9QArfPwioUbetR16d9PGWG2iUHL9VDiAH8WSQygVrpsJn8I0FrEOuQ18npuxD9hc56m5th0CXAVvvx9t2J19DIJrRbv4+R0fblMKhw6SNV1aQsqexw3db7Nzgu9CmHh69u4kFb8YKeYMRwaxoj6ExqCIA2lJuCgi+Ec73VYP3iom6q1DVoHwVZVDPuUe+r8nc+7sq43ddCVy7ZX2YAx7W3eVLKhpM/CefLQtSttFW6szPerx1E9+FReLaAhZCEa7vSeNLbgLdz/rMO3KFbZeZ+ECGBin9vYU2a/YVnQan3Xpjcwrkv3CdWzb4j8jKwUbtgYI7sHom2D0wTD1BdYa0xI9xvBu0QbHBW13U3qrVjofJBs0bH0HDqRmUjJIOzLI/cBNHp1UMpn2b8eAfjKTCrS90cO+1OlmCjWuHIdpoiiDnCKcaHuTUVNWXkF+7qWeTALFadlll/DTwOj4h5JwoqEsaJuopM7YcJ1G+qFTBZVcuSTC8l2Bf7MlLyxfw/vKc4uU2vz6NAOBOvVrYMoZcvRvmeM7k0z8oQ+hKOzTGZiHOCpvOIPFBCNkDrpS5O+PB/R02MNI9qRG3I86Zde9wgKCwYFTG/0f6LSNyiBF4zqrOnS4CflmsOlSCBKfo7CnQHtQgk+Snpl0txjhb5PRByVFkLu4
 67moxHcD
 K5MfPkPGoR38Om0lgPR7BhqzxB3K06JP1arcciME4g1nvPxZyAMxVDsO2mw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bijan Tabatabai <bijantabatab@micron.com>

Any DAMON command that uses damos_walk() internally, such as
update_schemes_tried_bytes and update_schemes_tried_regions, waits until
each scheme in the DAMON context have finished. This can be useful, for
example, if a user wants to know when new scheme parameters they've
committed have been applied. Another use case could be if a user wants
to record the system state every time a scheme is applied for debug
purposes.

This patch adds a new command, wait_for_schemes_apply, which calls
damos_walk() without a walk function so that all it does is wait until
all schemes have been applied. The same functionality can be achieved
by using update_schemes_tried_bytes, for example, but having a separate
command for this avoid unnecessary work. It also makes user intent
clearer when used in scripts.

Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
---
 mm/damon/core.c  |  3 ++-
 mm/damon/sysfs.c | 27 +++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 07b4fc5a9790..56a13d16e4d1 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1731,7 +1731,8 @@ static void damos_walk_call_walk(struct damon_ctx *ctx, struct damon_target *t,
 	if (!control)
 		return;
 
-	control->walk_fn(control->data, ctx, t, r, s, sz_filter_passed);
+	if (control->walk_fn)
+		control->walk_fn(control->data, ctx, t, r, s, sz_filter_passed);
 }
 
 /*
diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index c2b036abb25b..ded3f60e4e22 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1223,6 +1223,11 @@ enum damon_sysfs_cmd {
 	 * intevals.
 	 */
 	DAMON_SYSFS_CMD_UPDATE_TUNED_INTERVALS,
+	/*
+	 * @DAMON_SYSFS_CMD_WAIT_FOR_SCHEMES_APPLY: Wait for all schemes to be
+	 * applied.
+	 */
+	DAMON_SYSFS_CMD_WAIT_FOR_SCHEMES_APPLY,
 	/*
 	 * @NR_DAMON_SYSFS_CMDS: Total number of DAMON sysfs commands.
 	 */
@@ -1242,6 +1247,7 @@ static const char * const damon_sysfs_cmd_strs[] = {
 	"clear_schemes_tried_regions",
 	"update_schemes_effective_quotas",
 	"update_tuned_intervals",
+	"wait_for_schemes_apply",
 };
 
 static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
@@ -1643,6 +1649,25 @@ static int damon_sysfs_update_schemes_tried_regions(
 	return damos_walk(ctx, &control);
 }
 
+static int damon_sysfs_wait_for_schemes_apply(
+		struct damon_sysfs_kdamond *sysfs_kdamond)
+{
+	/*
+	 * damos_walk returns after the next time all of the schemes have been
+	 * applied. We don't need to do any actual work, so walk_fn is NULL.
+	 */
+	struct damos_walk_control control = {
+		.walk_fn = NULL,
+		.data = NULL,
+	};
+	struct damon_ctx *ctx = sysfs_kdamond->damon_ctx;
+
+	if (!ctx)
+		return -EINVAL;
+
+	return damos_walk(ctx, &control);
+}
+
 /*
  * damon_sysfs_handle_cmd() - Handle a command for a specific kdamond.
  * @cmd:	The command to handle.
@@ -1688,6 +1713,8 @@ static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
 	case DAMON_SYSFS_CMD_UPDATE_TUNED_INTERVALS:
 		return damon_sysfs_damon_call(
 				damon_sysfs_upd_tuned_intervals, kdamond);
+	case DAMON_SYSFS_CMD_WAIT_FOR_SCHEMES_APPLY:
+		return damon_sysfs_wait_for_schemes_apply(kdamond);
 	default:
 		return -EINVAL;
 	}
-- 
2.43.5


