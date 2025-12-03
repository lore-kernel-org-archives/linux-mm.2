Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7860D1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 08:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 079966B0027; Wed,  3 Dec 2025 03:05:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0035A6B0028; Wed,  3 Dec 2025 03:05:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34E96B0029; Wed,  3 Dec 2025 03:05:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF4D66B0027
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:05:06 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8246E132B34
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:05:04 +0000 (UTC)
X-FDA: 84177424128.23.AE74BF5
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id B240FC0004
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:05:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LdLhqZCe;
	spf=pass (imf22.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764749102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=R9a/AxV+wC8jwsiLQBhrbX+GTyTSM7uRmBDhsxzqnBc=;
	b=0h41rQ71MvqgWPQpatPjHTIJsm+HY1y30VkGmbtwOLtfX1k3rCK+AkFU+o08nu+7sSXx0O
	ofu0a2OpXlMhR8BBBntl8gR9Na/54SmFhcdUmA+k80LbSqpyeMi5i8u4pUCOrJ823uh9Su
	Aajlk1pwHKZsM062w6V4xOMU46YP7RE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764749102; a=rsa-sha256;
	cv=none;
	b=MpWDN6TMgs2jqc6tt4Gk10nGH8PpcC/19iS8VEsHfm/DI7IzV9nnTteS3wSZqdbF+mp8cW
	Nj7jf3HgkxXMSSEgjFsLAP6xC+oWp863pkNHi1UOk9FXHA6ChAfPX2EUL68lo3j92N8iGO
	zb3xLXWAXzki7obG+vgWxNmR4ACy/Lw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LdLhqZCe;
	spf=pass (imf22.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7b8eff36e3bso10398823b3a.2
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 00:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764749101; x=1765353901; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R9a/AxV+wC8jwsiLQBhrbX+GTyTSM7uRmBDhsxzqnBc=;
        b=LdLhqZCesXOFrFmSHJdnpWG6MdTbKTWwlY84TI482Zyh8zDKQsIX92s/nr1xJeib3N
         csSsEE7saW3iKiPr62+LxMTvhLv7VAJ5epGnFlES1FfaAxJZKzQQudkW9uUAiIjcJK4T
         u5Pg7uoeWU6iPl7cgrPt27lKRMpb2q4o0UhukrVRwrz/RT9z2y1gC7wb80/rV2JAFj6m
         zy2MiMylKLV2/PYfJ5cjeTyLBsbDuU2BhcZlgJURE2eUBMW+sHRfJ6+6wBnUknb5Xy1M
         nk8oten0HLpCoMW0e/5ehByzjUrfTLxd+vrk5da5gubYVCz2k1ZOzPU8Ek/0F3M8kWFP
         t5RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764749101; x=1765353901;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R9a/AxV+wC8jwsiLQBhrbX+GTyTSM7uRmBDhsxzqnBc=;
        b=WVlik7Og04Sed1CgPP1DZuYOr/FoB7993sDoIiBSgdfgxaGzxH8zN83Mh2Rgex9+9/
         dDIAr3NTzj/cX7/ZzIijP4wZugKLgYZWLvOEEudwFdvj8h/GXAiQb+i/hT7RmGl5qmmI
         N+G3hCbgncHl+twDvRrYfpqKP4mDI0fCWTZykXKA3+Kox9OoMMfj9P43fj9Z4KSo4rXw
         UXs0LrwLwwqnU++Wbp0G+hieftYS5A96sfbjFVR0YO7rvEs42NaRHhjVsWVxruBAeVR/
         k2HJ7v/bBapmbiV2UwwlPpXufkHrvOq3WFGldOSRl44fm8h5LWLorYVXi31d+rjLEsnU
         VspA==
X-Forwarded-Encrypted: i=1; AJvYcCXVKaPQtwY93U2XWgwTok7Uxq6e+GeJSz5XQR+W98YZtmHmYRE7BfK79XUbRdJtqeNhJR3AGXAo6w==@kvack.org
X-Gm-Message-State: AOJu0YzXnif9U5GKYi2Yw5PoKqtFKUtQz6GJazRVaUPjzrgFqIgLxrs+
	XXgsfd56hKU5yB9Z6/3YNGKUU4GSm35S1tSJ6DGZGatlJjrBaB/XOsc6
X-Gm-Gg: ASbGnct72MC/fuoH6xtoNyknoXPEfh7DoigkOEoW+S2S69REvXL+Zsvjs6OrILr1jLt
	MHnuXZGKt46fZNFA9XZWCgRxvYPVIVttI2Mg/5xAx6NBKSf7D29xeafDD9STx7kNKLasshAgQGX
	NBNDxki1snouo4Ust26bL0iZjmI4buI+vSDQRkIhxo/IbGciAjjOC+OfrgxjexDJ1aRfS4uXdj4
	Fjigo6OWD8owjlViVT4sdTN454J1DIq/8pmHTuL+lPPqwE9DqnSAM77y5y1n2OqBtThdUIu3Yxm
	6MWCXqlKW5Y8kA1JuL8X1EZd9xCpah5hfe36svPaDCWg986J62eNCYf74lg9hDqPg3Fm2O5/Rnh
	I0LooHZWWEIsfKTpMRDr4HFetRi8ga1YyfSq18/HdVfNeQz0xxf/YFNEgkw+OJx0gqsR5Fa/aP9
	9H7b5H9IIU+kEU
X-Google-Smtp-Source: AGHT+IEKnfRdlKVBSs8FMLtPg066nv9w/0bsZDbFhrjOTm0rk01/YNwhJ9ucFUGfG3SebblIOnE7gg==
X-Received: by 2002:a05:6a00:2d04:b0:7b8:bab9:5794 with SMTP id d2e1a72fcca58-7e00e3b938bmr1721264b3a.26.1764749101329;
        Wed, 03 Dec 2025 00:05:01 -0800 (PST)
Received: from HP-Note-Host.. ([222.234.91.137])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7d15f9260a4sm19331963b3a.58.2025.12.03.00.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 00:05:00 -0800 (PST)
From: Jung-JaeJoon <rgbi3307@gmail.com>
To: sj@kernel.org
Cc: Jung-JaeJoon <rgbi3307@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	rgbi3307@naver.com
Subject: [PATCH v2] mm/damon/stat: deduplicate intervals_goal setup in damon_stat_build_ctx()
Date: Wed,  3 Dec 2025 17:04:33 +0900
Message-ID: <20251203080440.16096-1-rgbi3307@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B240FC0004
X-Stat-Signature: zzum4ygahtdezoaejmxph4phgcofyac6
X-HE-Tag: 1764749102-76920
X-HE-Meta: U2FsdGVkX1+CA1VGGAcflEDyblUwGpmCaweFmUGNkZkn/lEiYInzNVk5AwEcukFUJnP63m2QG8h2dbyuiTsBZjDH9Xgi/+8a6NM8TpSlSp6VRZ3igrRz7zO3W79qrE+XaLXV4VHpAoVWLv4j6FGdIZaCCX5fumHflhek1Y6xcAjE4n+5ruI8WzT5HRjagBzVSg6L5WpCPSvEWf7xSekYRGxWyPR8vBOg/czC06tu8lUzfXezKylivFjJKjhDZEZNCAFWhmst7Ht/rba/AJc5C9XcZJ39cwTd+vxFtWd8q3XiTzCQMRcqsEmp69D94ygFfk0H7HQH8dENiB1pF+fo1G4ZB8h0gy0NdE262iWFoAi76sn6aQLrvjMRuX8MF+SWfYjIGPD4SY258y6pjjWv/YQt6u3lJajhxuqxeLhpefugZLtVD8YK6O5InJ7O120amBI+6VdQxucbzs/gI7dZBAv48bMKO1B9GsrOuou2gbWN8H6iqn3X07NRBRgCNBxjMD2eAl3kYgDkcAmrCmSIDtWFXuPk7VojLDIO7dnBl7hhlTOX+vMVZIi/FnC3yTMW7CUDmUKEoUkcHcGjgOuxs6EQhs0PRro20uo6MJgEva2CGgMEIuHn6Gy4UoY6hjxdmHbC3os2vkVV3OEuGLt0L1Is64j5fvPd5Qrrf6ScN/OxqM3e0lR7GWRMVkdUyN/D+bu1k9YA42IOhC3SS6+BPK/hyx5SEoc8KLaGpFWXonBaPqdut0NuhASQijP6SYsvzuwCUrd2I01cSL4Mo7gA1j5PjcuNDKymAzBtaduInxjruh9qEBfsrKzCI7SWAtrEQ4msXl+AT0tVtOMK1VdNxvorCGncuocoo4Wz6nWQLZfuRBCSbcJDiPjJMds8lIYiwessMTNiiUBhelg7vhdcmR6TP1huM9Ywof9wlogM65cfQMUrqd5Hn/KjGNA5OczoeGtSL/JWd0ZZwCKb6NR
 ctc1b/tT
 GEmrxHencwYSEnuQHU43VCc+0JkY/44NqdxkGe1YpZgBOX0T+IQd3UGxs17k4IWAL6ey81LytoUblbYmXc7UPrHerbOAHdol5//b8z9UxOmoDQ1RDADeziRsnQj/XpKZsSwLC+J2eHW2z6JR4HPQNS1gSYv5gv5j/rcZH9+lOWhd6X04iiCrM64gq1dhyBIsEKFnY3ghkaNEaCK8MD5S2Yp6bzM8V82LJj83LwSxN6J9dVBOZJwdhFP3BNvQuPV6zcRDz5IeXgWe2NI0GZLHeCWsJ3VY0iPLaBR51UuwwXnGws5B6lNZHoBRMh7dFinjsate3lUVz9J+mhJue2Ab0wRIERurWMG4uN0xKiRjy1f3wc3ARzn3jdgV3gaqeJpg33NkLtRd0Njs3tC1lWMGmEn9L0V2NEvURQcTBVteZq2/xJe9/RxYZHQBf7zMfp9yIE7qXqCmN510Uqm1gnn0CGEX6C4+3X8D48Mz9Ky0hMFu6x/dtXdw2ioAB//340zgJyEt/3mxb3WLmAOaoQ4i0EnLnZL8/S3l2tVahLyqjkjnHbJXymZGV1RXUOEs1Aw3pOU6bDnaUeqVawgDrmGr1/RbXYJioar4BLkDV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The damon_stat_build_ctx() function sets the values
of attrs.intervals_goal structure members.
These values are applied to damon_ctx in damon_set_attrs().
However, It is resetting the values that were already applied previously
to the same values.
I suggest removing this code as it constitutes duplicate execution.

Signed-off-by: Jung-JaeJoon <rgbi3307@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/stat.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index bf8626859902..51dd29685915 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -173,14 +173,6 @@ static struct damon_ctx *damon_stat_build_ctx(void)
 	if (damon_set_attrs(ctx, &attrs))
 		goto free_out;
 
-	/*
-	 * auto-tune sampling and aggregation interval aiming 4% DAMON-observed
-	 * accesses ratio, keeping sampling interval in [5ms, 10s] range.
-	 */
-	ctx->attrs.intervals_goal = (struct damon_intervals_goal) {
-		.access_bp = 400, .aggrs = 3,
-		.min_sample_us = 5000, .max_sample_us = 10000000,
-	};
 	if (damon_select_ops(ctx, DAMON_OPS_PADDR))
 		goto free_out;
 
-- 
2.43.0


