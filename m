Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4BEBFEEF4E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 14:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5966B0088; Tue,  7 Apr 2026 10:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CDA46B0089; Tue,  7 Apr 2026 10:14:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E3266B008A; Tue,  7 Apr 2026 10:14:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1F1BE6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:14:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A6327160830
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:14:19 +0000 (UTC)
X-FDA: 84631954638.27.ABFA4D7
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id DAF1740010
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:14:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IVRmehxg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775571257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1V2lh/GaZrBlJfRbo6ax10GEA/6JMxVWK7CRPQq0TpQ=;
	b=j5Ax7abcvy0A+VImvwfvcVpK5t9jQbesXMmZbGTx1MSiG49EtjCAweQCVHIVNYZPAPqH0e
	+33PcxMtWrUZN7c17pIbGKX9fXcuFbPnkn+6tq7tTFRG0hGAMwh+01/GZ9P+AddHyD2DGA
	tZ467+9aGLxR5TEIvYi7ttfW9Q+ZAoM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775571257; a=rsa-sha256;
	cv=none;
	b=0BcUvJ6Rg4HXwjWg9r6Bzs2o9yiW3YvfDCd9I6aRNcVvt/ib1K5AAc2AqYPscHzZ82xUKh
	M24RJP+A+MKMnmCkH4okGJcerbAzp7p/qkl8GUxEYH+VUDwU70XRsd4R5fMETWV2QW5Soz
	hyYAc655J+ChYfCjJXYA9r36Mj47/DE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IVRmehxg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7dbcb467f2bso3347321a34.3
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 07:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775571257; x=1776176057; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1V2lh/GaZrBlJfRbo6ax10GEA/6JMxVWK7CRPQq0TpQ=;
        b=IVRmehxgZB0Uv4tsQEy3NdgS//kYxa2/5EASiWL7Uku7EW+LPG/vuO8K71GvDxXzHG
         hPeTsoWlaNUH95abGB/fHwDBoJv8XIhJbmf+8YlnC5DdVZIQMt4YAE86oud49PzMbx4K
         Ey/ve5Rh4dKCvZWZhpAm/55XsqRyxJM8QazMWy+UQGELp+GARWje2E1DrawHX5Jg/4Gk
         iRipPff2cx33jHM5VtrC+cew3N1i/LLb0FvRcalJomp2cw5qr03uXQ+F+tv+hGPVS4bj
         +ZGG5fMY4SErAZNKeSbBOto+H4Uo8Tu6BTb1eYg7/kZgZogBtJJPhmPNuC8dfrpVaON7
         s7cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775571257; x=1776176057;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1V2lh/GaZrBlJfRbo6ax10GEA/6JMxVWK7CRPQq0TpQ=;
        b=hDrUPsjaV/6mKskmzJCqbQAB3xAzLUBixv9aVXN5OTtI1gPX5xmvtgJbBObco2T0XS
         NiCcfDMFjg9hxPEG82bh02SqE2l5KCSLNccOoxH+dG45ZMbEuR85lDJnkKMzZk5/l+Vg
         OBU1vEbvzMW3fg6/Izba+rgfQ3IebQWH+2OGVgS5rkNMAEW3PXv3JtdgxuJHN6gQBWMs
         oo4UD8DqFMRMb+MZXs1gz3C3TptUnr9WWEqndYZa97rhhHMo97H0HRnBOUxQR/gBVqzM
         zaIxXhA+UhDG5ZcpC4A8PEQy2dYXOazVW4yLwOytFtgKADym4nE4B27byVUI7XMfz+uq
         No+A==
X-Forwarded-Encrypted: i=1; AJvYcCX960DXF2/X1EiAKK3IpoIrWc6EqSw55Qv7OmEO9JfOQBDxTCfOQNj2yjlgU0ZZie76DRZ5KPIWnQ==@kvack.org
X-Gm-Message-State: AOJu0YzuJo+So/eGfbCI+GgoKb9SkjqL5cFB61KYm3bnoVtTSbzTH2IE
	PCXikn+Q7TUKbFOsCkvq3hf4sLHAfEqdegMGhIzPBvftT6mwgAMfdMe7
X-Gm-Gg: AeBDieu18WyyS2aReah3Shl9w1cihoEt9Ts0WIGsJXH5h7i9wCflhaBQ2ZurJi++qM/
	d5P0Uk9l2qRSSmP3xtpHO7YN4lU5vIvUwEAKTvRtDRzqsDDRrp/nopPG3JsiuIB/XKd15q0hwLD
	RwSkxtmuvH2nKYA1cxSgiOvo1mPSpWLSHvr/XE+T0pG4l4pXAzUB1Kt3Ssd51Pwe8XdeKAyziFq
	tEU5DctIMc8hhK2BvHSSi6KBMz2bwrP7MDt+ecjW2cu0bvqKz8smuwIs9QvpbkBe1EKrKo/wlDs
	4YTCnTjlPHghtCRP6mCOOj1v2+iMmYjRMnU44SdotfRZfpPDx1kcSEcQPfb+PozQsVlSjiuzVtb
	58K/xw6Czh2zGJXBOrjbU+kawu8qUZz7JFsz4cXDEAXSGtN4hHxxoazUzjUfLZSDXQGUwLBUHAU
	zblMMAekm4dhbhlKf/PDNUGw==
X-Received: by 2002:a05:6820:2219:b0:684:92a9:a2e2 with SMTP id 006d021491bc7-68492a9b397mr6359128eaf.39.1775571256590;
        Tue, 07 Apr 2026 07:14:16 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:49::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-422eaf2c7c3sm13702797fac.5.2026.04.07.07.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 07:14:15 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jackie Liu <liu.yun@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] mm/mempolicy: Fix weighted interleave auto sysfs name
Date: Tue,  7 Apr 2026 07:14:14 -0700
Message-ID: <20260407141415.3080960-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DAF1740010
X-Stat-Signature: 6a1pzdy1hj4x1z6rjpsjg7nzrgkjdu3o
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775571257-166087
X-HE-Meta: U2FsdGVkX18SgAHiJ1xNAnqG70SYET9DZteX/OAKQU99DZ8INWwjfOD8mDc6QRT+8J+TWnI4JUL1MR5hCCaurx3bOff4W4VSF0vsgqhWJnJKQcmmW9uKDhBT/sodtbATd1YINe4vf7dl1Y8BqdtxSJXup7eiyWb9zAQV3ksaX+FdVQOJVT7K/yhYmdbZn5uqjvJlcIT3/gGP5lhJ6R2GUT3oTGxyFyA+gU9pONIy8Jw2rpxKl7/wABre6OijHCiWhR36QYRi/0oN5f5Rl2Lv3AsUYc+uionx31s++pLaKu+0KzM5xvVvpoAIo9j7RWoXGLFcXBGjoCpxA7826jmm1W1GEmlKTi2eOX0pYO3fqVbWFgYvLd9N+qFBXM9NxqzvbkNsnxkh9PC5QpfDfsKvs0abiDoA49KwrhKVWjSKceNe/GYPttn4+bXGFy+1YxzaTYuwzXWLjgoyfiVlq0Hp44bFeCLCIIqhgVouBKIb54G2yZRhcd5iXY6zAJUsIh45EBl/RNhAPucYNK2Dm9OFAsBUChp2Qp6B5CUS8QZjLa+dMNnUXs2+ueUBnsflBYR+gv2JxIlVjqEdDduq7PlNxm92szVUxlv4ZQKl9RufY9AsR3KRXiSXWVL1H3CjoozQaVBfxIgG+8RWhrCEUTPggc147mff8rhrautPXqARMreUeit9bIFZEff3I6HT54su68ZiGexttyJE4Xux+plvDWjXC0po0yHn3aZeBWeGdE3okYTKC6MN0eoH4OvoYGrf8jtqJAx4uS/2w4HqC+FOGoKnT1TYOjiXx26kHCQb8K9TfMai4AnIGj7K18pJM9LlqxVuFIRiVUi3kBMLfkJUMRbbgfwlaPYa9ckQwV2CX/AqQbSVfbbXtRyND30tWv6n8Zqi6bnVZ8U/HLrfQp0mHpHlRibP2IUurlU94bVUcqErggC0l/yOEC93FebIZnKZANR2ZokM/kO8eLAJGkE
 MIZeNVgC
 XdonS8PeAkVhXbSCCZkSeu5Ft/6UAsrzGYM1u5xFaMqPlw/2uMx+IlXWI1wSw9jo7ROT0q49BWEKoDANiQn/6giazGzAM2pBs8gTi4SCzNaHeM4maOyhrfgbPGKB46tNT/xdks8bawecaIGQjlsgKaxgO3XNWmKArQj7E5FzvS1uK/3pkCLgS+iD0e5py+L2nnwvVZUsOUyMRb2QkJ8S/ZJz4+VOuynwDvOCGhS0J3yqSTCTxA4rZ6eM6kYdz/SXp+EPOPO89mvLKNQuXAyxPEqww4yHjjfoRT8nyqWwDqw/bWMfH6VXDQcIzTB2X2QOZrWHcZ2ToIeCCd8wM8T3XFXGuJ/lw+RIf+GT1Ow5GCyxbBpvA06PdApBk2vDoUWW7gDGV8JvK1jzBubeUkvOe4FcKKI+dDv9bboYCyGbr1URzWeDN4hbP1egNYiZ8703GbU0L0BJCiURZ2VQ4x07SxV2yHRZak8AjEzk7vK/5WEiIIFR5+0H95f0zjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The __ATTR macro is a utility that makes defining kobj_attributes easier
by stringfying the name, verifying the mode, and setting the show/store
fields in a single initializer. It takes a raw token as the first value,
rather than a string, so that __ATTR family macros like __ATTR_RW can
token-paste it for inferring the _show / _store function names.

Commit e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
used the __ATTR macro to define the "auto" sysfs for weighted
interleave. A few months later, commit 2fb6915fa22d ("compiler_types.h:
add "auto" as a macro for "__auto_type"") introduced a #define macro
which expanded auto into __auto_type.

This led to the "auto" token passed into __ATTR to be expanded out into
__auto_type, and the sysfs entry to be displayed as __auto_type as well.

Expand out the __ATTR macro and directly pass a string "auto" instead of
the raw token 'auto' to prevent it from being expanded out. Also bypass
the VERIFY_OCTAL_PERMISSIONS check by triple checking that 0664 is
indeed the intended permissions for this sysfs file.

Before:
$ ls /sys/kernel/mm/mempolicy/weighted_interleave
__auto_type  node0

After:
$ ls /sys/kernel/mm/mempolicy/weighted_interleave/
auto  node0

Based on latest mm-new: 96881c429af1

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/mempolicy.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 62108a5b74c4e..845458a3c18f4 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -3782,9 +3782,11 @@ static void wi_state_free(void)
 	}
 }
 
-static struct kobj_attribute wi_auto_attr =
-	__ATTR(auto, 0664, weighted_interleave_auto_show,
-			   weighted_interleave_auto_store);
+static struct kobj_attribute wi_auto_attr = {
+	.attr = { .name = "auto", .mode = 0664 },
+	.show = weighted_interleave_auto_show,
+	.store = weighted_interleave_auto_store,
+};
 
 static void wi_cleanup(void) {
 	sysfs_remove_file(&wi_group->wi_kobj, &wi_auto_attr.attr);
-- 
2.52.0


