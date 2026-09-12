Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B0D6C79FB6
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 12:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AFE36B008C; Sat, 12 Sep 2026 08:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13AA66B0092; Sat, 12 Sep 2026 08:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002C96B0093; Sat, 12 Sep 2026 08:44:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE26E6B008C
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 08:44:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6254A0175
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 12:44:06 +0000 (UTC)
X-FDA: 85205077692.07.ADE0E5A
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf15.hostedemail.com (Postfix) with ESMTP id E6A5BA0003
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 12:44:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l8tUV1i3;
	spf=pass (imf15.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789217044;
	b=0yHxc3QdMJqRaBCEf7hQffY9Dt++NfdMTyURaJ3qEdpcl2KlWTV7LtL2tMfliD7PQTYy3m
	5NH2LVFIAzPozWiN8aFLjSsDaWg6EZNJh1gCbX7kQkjpy6scQN0thJIVL0ALjVjyXscd2x
	dmd0trFiuDs9UHMe26QiksPre1SOyCs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l8tUV1i3;
	spf=pass (imf15.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789217044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fd0BG/EWunOB+q7PV/ZVh026vIj4CU3m1NzQ65Z0ygg=;
	b=t9R7FV5FdtiF3DRE6/Gti8oKflwV+SrxN4XrBcD/Wg5tNLw2ocqUDbU+JmkEVc41mhb8d/
	kbAj6/BGcwSVYXB/6N/sE4/5ZGRH+YnhMGfJOsIPBTK0S3EQkpdMUufwGcK62IYe9Cqhi0
	hYhISEvdN69gNPAlVVvS5oS7efkazbU=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccd66bb4so408677a91.1
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 05:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789217044; x=1789821844; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fd0BG/EWunOB+q7PV/ZVh026vIj4CU3m1NzQ65Z0ygg=;
        b=l8tUV1i3X26+zixJhE8sKyIpHkPzA4DFV/ovO29tt/4wlFYBDA8HT5UoOAFN3kjOST
         eFkURmKOzyOaGO0OHlgSkXcxv054MeeloT7hSziXgPhNIkSlbvRTpLNqBMS7YyiAZPbH
         q9pHlAWnQVB1SSfuzNIACF7cg52kTODRt2WAFKkYm1HnyHGPcFOxvlokAlpMF9ft+0MX
         VA2K4zcuWuP2bOSb6V9aiVN/O7rJ/lGELjjiwjkxmen0wWWyDAAlNKOSAm48v1Bhs6LH
         5aIhBhUFbR7MslDAPDHGrIvu3swUeayLB0P+hBhP4Jb4Wdn8ibiEbP5cLHBcqSnLlhbK
         Wotw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789217044; x=1789821844;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fd0BG/EWunOB+q7PV/ZVh026vIj4CU3m1NzQ65Z0ygg=;
        b=SxaeyXURxhDlUAtStC5YFQzncIJtLqBsoVIe/fIOxM+teQntPfmvGdcdDElOJmw+8n
         zNKuUVNx2wqVMZ6gqVD5wizUbZzJ6j/ffomxNf/2yGdFB2XuiXEFwFyfvnAz3DF/vQvP
         KU4yHykB89K6PlYlJ32mHTBYBjMEoqwCFjw6X1u1sS+sGLV9gQXksfCOVI+kiZSp49R5
         XUe9pJN4aZ/9piL52xr/z0xQUt6uBEN0WNH8x4q+u5hyVgxB/4DPMpdZeWvC/pOJFrG4
         0P4KFep2iyZIhHX93vZgm9z8xC/ERonN9jv6Akb8jRWXh0lRm0NblqipSJZwFTfBzaPl
         M2mw==
X-Forwarded-Encrypted: i=1; AKwUvBw709+x629tvUoa0WuI8B0ZqWnAoV4w4voocSYl/c86ZIKiwgscc97mM/Q2kob+d6xlVq7kEjRS2w==@kvack.org
X-Gm-Message-State: AFuF++n9QFMLWKFhaqNgltPynI/LI0vZAWRYL8CKB8f56tY0OeKVl5ac
	Umd39kbK4Ay550mgjJwTxa+lhmI04usKIkpSsA4f7ns26nJnmYVXaXV7zQorKVXq79E=
X-Gm-Gg: AYBFou1f0Y8xHwqjXvR8e+PXZhKRnoRGLTtUumYSOmufY7YgaM95Wjd+arnZLYzcog0
	UnHJi30qUBR7StpqGwCjzBDX9QODs/SZgRYcXt9DTV3FsSjM5rxgPYU2XlXEUagyrLHF/puK7LE
	yb1BdamksauFszZ84XaNm6DzPnd/1rD8ijbEwbFrK+AywYNCeHd4vjtcAX6BWvpQBOh0YRs7apX
	AKCi+JLdEq1GfgBlefEabFRI56liOjtfNeSp4cYzfAsqUXeWkEDPe34xtWj3oUFiSLPQtjlvZO0
	B3JERVR4RXhLdxpyrgJfoRycZfCVRqFEmrKSGiUsrP0H3VImTsHlN4xpat3BAk4XOnTzPPWADg3
	U83uZOHQvLN+7SZ338zgX1ZfZ2ofay4anE/n6kxU8uZxl9BW9l7YvUmXPeFAwYUHul1pqhdBfRP
	Vo+Ka4swjIDYW/NACx8j03DecxPvJAJUVU9h8dVoMCpYwRodzsSCp4VyDB4QGeldiBcMm74pgdK
	0Uj
X-Received: by 2002:a17:90b:57c6:b0:381:a766:efc9 with SMTP id 98e67ed59e1d1-39dbbeb57a5mr5027381a91.7.1789217043584;
        Sat, 12 Sep 2026 05:44:03 -0700 (PDT)
Received: from celestia ([2402:1980:8858:8cc0:7bda:d54a:257:22ec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d95713602sm10294840a91.11.2026.09.12.05.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 05:44:03 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: 
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] mm/damon/core: add short circuit for temporal-goal schemes in damos_adjust_quota()
Date: Sat, 12 Sep 2026 20:43:12 +0800
Message-ID: <20260912124406.96535-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E6A5BA0003
X-Stat-Signature: mfkb8kau79d6tiruiiy8ro13866679mi
X-Rspam-User: 
X-HE-Tag: 1789217044-210668
X-HE-Meta: U2FsdGVkX199kCvbs9Ek6apq8nhPGlIbImzK/QWeEgOo99MPVRLIOnIRiAT/AOlozzLk2zzGgsnQtgQTNA61s8ApCqcnlatlwcTvlJ6A0Ov246B5n5PKSMbls6R1Ye+SLOd8RC3iab8nVhruZAfMfw8h3GBkyua4qx3TJZRdsuAlM20OjJkhNQYUullZCbMKkM+l11COLg+jDoxvDo2SK3HjdszunTMrJYP1JQ21Jzdif00QqlJHmhc3mMEzAbuSik43zhLLJ/AipweaYUfzCMPdTkpmWnyhVJ/ycNx5wSRzH4BlPr60yHqjdDun6gyNiNIf71DH2iG7I/QVp6Y7zXwj8pJgDbn8QOjoGxdNEVrCEqSoztE7YCKJYYCFndXvX0/w7IAZauLanFfyK1AKo1tO7AP/cK0G2rXeh3gZwLFer5NBj9QYmr2HB6hSxRB6hekpIuH8lagj3CGmLGPBJsqmEPA8te0idn2CxuKPp33M/Sz83jTkTjJr3J0+u2yvJDUWwMuuGsvk4xgFo3Tz+t9D1pkrhKQsZ4ixrUxgSZrt0JM+p59lrXthXSu79y0K48bPERwfNbi9dUejxZ/0GReTv3HfTpePLADGa2Db9i5XCFR9ZgKQeiRCcDtek2q7FIUFqMrBXN87kGl7+z6eX+1H3rrQx9DVyo9qL69S/fCuWKmo5I3gwZluerYU+8hvvQ3/ckaga57CAAbOLE/hp42vHmoFbD+AyMurqJD3u+a6S6wREJkwFhTQBM5k4PsYakin0xoTP2oVJpxbqseX606Av/swJx9BZBlw/38fWG4/Ck6KwvOhvC7BwiKRt7aizfWcGjt6XfKMG+Ri9HBNn+WFU5e/QqEYAMeEiRuSnPMA7mqiWnpOva4t+XjI/SUKyID6D8nZMqiLMMvU2/7WD9gjzbDT0lvd/G5pyW6k5u/akBdgmyB1nQU5+f0I91Dc7onn0MJmj8lKfr36jAV
 eSRm27Cc
 dXIMqpca3sTLkZHOlZt/EWSfcjsVw/RyJDJcJwB2HgTYhPttVWDQmewB1/25miZXI0MUso/9tTXGW/AL5zJMGuaumCnFNUU2289TxE+EjqHyXnbYZOHFQGc8Zajr2NSW5TY60S2fqX2Ic4jH+gM66dKiNxEUxoLRhwC0RQY9I4qUIGbACrms91+IgZREpUNtBN+pRi14aPnzZf6t7CfzBBSKNiSrRym1ibeu7x7KLWSv1ZQJ0DqHZhlbfZZMeBgYYwys19p+oP1iPnwDKWXIUdXkHzfVbVIOO+kI5o/3M+B/wDyvQej2Y/b4ZeobtK6vFyNC5T5OpwXVlLwjEwMX7pLdC0lNa1Q+6iG5kjhNDpRCipe5Zef15Epoi3w/7xqlt24mKM7G/MGMd7yBMgo5quFHPy7ylaPT9Z1+iOT6ejWUGqN0e6uwlOpiOKaTE/K+WhXEQhQC521Agkh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When using the temporal auto-tuning algorithm, the effective size quota
becomes zero once the goal is [over-]achieved.

In this situation, damos_adjust_quota() still calculates
quota->min_score for it.  However, this min_score will not be used in
this window, because in damon_do_apply_schemes(), damos_quota_is_full()
will always returns true, preventing the scheme from being applied to
any region.

Therefore, add a short circuit for temporal-goal algorithm schemes to
early return from damos_adjust_quota() before calculating min_score.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---

I tested with virtme-ng + perf on a Proactive Memory Reclaim workload;
within measurement noise (~3%), no measurable difference was observed.

The purpose of this patch is to reduce unnecessary operations
(calculating min_score).  But, I'd like to know if this patch needs to
demonstrate that it provides better performance before it's merged.

---
 mm/damon/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ce8c6f99106e..fdcea989f0e0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3320,6 +3320,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 
 	if (!c->ops.get_scheme_score)
 		return;
+	if (quota->esz == 0)
+		return;
 
 	/* Fill up the score histogram */
 	memset(c->regions_score_histogram, 0,
-- 
2.55.0


