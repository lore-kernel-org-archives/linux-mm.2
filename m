Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97688C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 08:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 840AB6B00B8; Wed,  2 Sep 2026 04:20:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CAD86B00BA; Wed,  2 Sep 2026 04:20:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692046B00BB; Wed,  2 Sep 2026 04:20:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E88D6B00B8
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:20:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5B328010C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:20:44 +0000 (UTC)
X-FDA: 85168126008.15.639B966
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0CA5A140003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:20:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f3u0ogdK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788337243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=C6stb0h/TUGkigOyr7jwbkqUiojuR7BYoo9mkXkmykw=;
	b=xN/pjCgDLILyRUasB2NZ+b53PVOwNVLEyUyJi62zSM6cu8nyjp3WXohgWYnwBm7tWKZaD2
	wt2NeaTFWcExYEU5+fnXUf1lczblwlTsKEByIRG3/njbUvz+S+QeQGt72t3EyQdov2YolS
	3soiWwDHmxeY4tSY89LAguUmLBiszvA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788337243;
	b=AmoGIbGJKeq6ggouVU4mOxrbdvx3eDAHmoWQRs/bzeOm1UmwvERCVUTaTrQU1jV2mjHD4G
	2vebPcsqemgTSRAEhoSclb4HsxtIyJ97rOWoPUHe8PnpOzHQeZ1a6jt81GGpSZqsdQFlk3
	3iij2PA2l9jYzHjYKPmfKjhvFnA3C1A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f3u0ogdK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cc1cc97b84bso678399a12.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 01:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788337242; x=1788942042; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=C6stb0h/TUGkigOyr7jwbkqUiojuR7BYoo9mkXkmykw=;
        b=f3u0ogdKh3c8JooUp8v4Iu67QsjKd7/QJQDt/k1LQ2t/DzMjWxeQSOt8hNwuzpytc/
         3/PyEfl4zBwawZz6f+3Z9QaCwn7TqhKjxnQ2woiEYXDNu3CoPSX1fpBguwpuRmro3hTi
         BqQIchKX7PYRnQRCLu7nx2qB3xqYukZKq2M+a5tIRAtTcDuehfjvaw0d+fYg/3dfeHM1
         HUWD0qGWn0zkMC2GipzB0AJx8OF+OQ6FN4k+fDxIPlbe83Ph+/l0aGp9XUH9JagcQhk4
         2Q2YNpdHzTuuH6dzGnR9rxkrVagsd76oiuZ0vq58nJiaHCivOcwXdQ6HXvlylnClrFA9
         W/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788337242; x=1788942042;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C6stb0h/TUGkigOyr7jwbkqUiojuR7BYoo9mkXkmykw=;
        b=GrHXzgbS1TCqe8OLMzMzxEpolvHAWTIsxv9425Wk8nJYuKAUd/ZPi0hx2l+dXo/Y+Q
         DwcY4JpezD7N+mzjgfnKw1IArMWKMbmsMnDLdgTWlehH0oRIKtiQs3VkXAY5LSeyJEZT
         Ibn8Ll5HjvKh3LE/kgteZXtNXtH6lp+/9Fj2xiQ6KnInf7M4zfXIGAg/sKEqDpRm8pvU
         kM45fnPrExXi6GsJdabpqPFW9pAv0NYpDyuHwvnp0/gmFqhltZ2SQUadS0Xf6miEOY+g
         5D6UOPEDAelWCmBZqWBCXr+2eBILQc591Rls6TmBz8um3lV1cklqNCJmd2/3ut6ZIwc8
         FtBQ==
X-Forwarded-Encrypted: i=1; AKwUvBxwK8CQ0UCd8x4zAeNPbO7KgHy0iqRzRjXgB5ekFqzZK6IjmXIlyvEcBJzl8csT77qO8/LkKYdn7w==@kvack.org
X-Gm-Message-State: AFuF++kWO+Clcq+13/AN0wA4L4KLAohbWiYf00fslAiZzoBlCeg5pqYg
	Bo+GYIV1BHumHajzK5DosDOlMKEhEFEhWI1zZu1kNBtcsefjRsJNPXi4
X-Gm-Gg: AYBFou00wENtw/J3uNIjhkG48tphbVi5bUUI4JQWQuUHPUIGsqgqSkLELelABBGi9DF
	I6JNcCMj/nKJCCTKbCKXtg9fiY8tBd93BMlUdQCAO7hRxVzBjolk97cOsbtV7k2fOyqRc5PMVlu
	l4LZ2YDmky85OGly4keqRXx2fZdZ8qZjQaNWfdNjr3jynw77xtRC52H4tE1TyFsdu+R/4Fj4Rwp
	jmtEtr87ORxNowjO0/9oBGoFvOkTfPpSNAnjk1mX0InTah0/awAWFkPcGZ7Ub4qwOxJkytBB9yg
	S6QYsboDGpzS85IAtXUU/+HPYvCdkJoN2Iqfd1qUMwrA2xVZehTiQJ0FZgcP97DsJyZgPjdrv84
	Cmo/0Gr8zCcynxt6oBt3C4zIaRGEnXvlGHl5FJGouWfSJGTP5oJbGtiqmUyugxinee6/fxQSzZu
	QuiAJYstPofmHoFZ5FV0XxXOOKFgLOV/aoEs4ksGPZlCYZXwP/h8lEpnFw/A0Dq4FvuNHtDixOi
	2T+kZfXI5bf8I7dJ0+xdxPUiiFh
X-Received: by 2002:a17:90b:3c89:b0:38f:aab1:5148 with SMTP id 98e67ed59e1d1-39aee066dd0mr5075947a91.13.1788337241788;
        Wed, 02 Sep 2026 01:20:41 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:9c5:2de5:8b4e:3f3c:b637:4ca5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae3c72584sm4119404a91.17.2026.09.02.01.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 01:20:41 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/damon/core: allow esz to be set to zero
Date: Wed,  2 Sep 2026 16:20:50 +0800
Message-ID: <20260902082050.19566-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0CA5A140003
X-Stat-Signature: 8ti89urzggo8wpe53t4wtg5qhuiepuci
X-Rspam-User: 
X-HE-Tag: 1788337242-227404
X-HE-Meta: U2FsdGVkX18rUOGDZSc5y+s6VsRK7ccrz9RsySKEsRhHuUtAgpvsUoYDnxLcT4eg71yjzDjbUeqJt+Gl86+TJ8IsDiaTFq3DWcOoXGWowN1UOoCc3RodeyBzJk8xdbGu8wd1r+lLoezpTzAJ5G3Z9vqDaRKGzlFAXipGG3Yyf75ABmL/bWoNmkSjInii++d3bMpubzWWo80wHF/zcU5KJv9qpmLPK2dt+Eey+XtT4xHZM/7Ud+C6mxbdbyoDd7JgagfmQTRd1XAaLCAXntkQJHjdP6reXHupv/GrfHFJYX6sNl4WEgLt3Yj5NDOOAYiJ7GslYaljT5+z13aISLPnaBnlRa5UAUNvs41W3dZG+yISpAiMliyKX5FxMi4igVlwiyIy8wU+Ep1VKbhJ68NmTKpIiNtvZ/QHqOQivfx/hVkNcMaBoevjKRxVskMCqNmoJEh5AW0GDhO80JqHGt91LvOyOdtdoAvpXqAS+4DlD4i07kkPO5ne4nMZlfQTHE38dtNYMlf/P+78FwLQRpuueWffuYhQLGwaWfpiY0khLyOw5b7zK1efXoLrN6ETDvgmG01gxkXAQ/Wr1DXuIuEJrPCkxsXTMe0WYXYBbgShc2rndbM0ot4zJcOmYyuMEnfzF3mKgXToyrU6Fc4DJbztyVhGHwztDPXWqfY5xs9lxC1vHehh8ECMfretNCaN5jGnSVWv0Unu8BnNg8HfC/Ux2RJu5yZqJM9SD34TpEw/Zyb0oOC8lM+DLL5wcirRF9LH016Z9SXZWyBBWGTOuD0u8WWdKlG42mWhkDeO/lCWY/DG+2G8luKpvbVxpzgNyGFc+owg952zt4akZWMbAqru7EmK+gGZajR9Z6Q8oIhMzCyRoqxd4PhDwc/QCnIGJ/hwJZb/AKjbfVOskfu80Ytkn9WM+7mT787FBUWd/LhcgEPg9TZgkBO2TQCHx91XRbMlpBhewNqa7EHqYDTvyh1
 1m12eaVT
 F8X7SDRmQiEBFyQdEuNBSn/79gvWIq0e1VeXNHbLvzULjo5ZQJKWKwhsrMj6/cqcRFgvHcBQONsWDbym0FKOt+XMcf6B412zJNxe6y4R6cnroh2QHZunoKlCev7HOrcsCfmoSPYnIRz4RBTUV9F8G1ghoelCYPA4Iy8ZjJpyWzQlH9enEebfvZfsRApJ3T2DOEdxkSYTIRKXMb2SydfzlJRuJQmlyIJPdvoXYiAvOZV883AYgOrsqxwUKUTPYy2smEJdWIvRPXamvuY/nWDwh7mc8eV5xYI4bihsE/HDzAtuJaDVCCMHTl9OKikqOUW8Puhi8XIykR378i3CWLtr9+lolpZXFFaqjHq21i5oHKycwgramx7/zdTJYEaTcOYcEtqWp79eKnbkWJWEjR5Wb7lr9RMWVNfQCkRU9mMn+NsYRIuBzxlREFa2y0GOrtz09BojN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the temporal quota goal tuner determines that the goal has been
achieved (score >= 10000), it sets esz_bp to zero so that the effective
quota (esz) becomes zero.  However, damos_set_effective_quota() clamps
the quota to min_region_sz, preventing the quota from ever reaching
zero.

Fix this by adding a check for zero esz_bp.

Fixes: 8bbde987c2b8 ("mm/damon/core: disallow time-quota setting zero esz")
Cc: <stable@vger.kernel.org> # v7.1.x
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---

Changes from v1:
- v1: https://lore.kernel.org/damon/20260901105951.106246-1-aethernet65535@gmail.com
- Changed implementation.  The initial solution skipped the
  min_region_sz clamping when esz was already zero.  However, this would
  revert the fix from commit 8bbde987c2b8 and cause a regression.  This
  revision fixes the issue by adding a specific check for a zero esz_bp.
- Changed patch title, original title: fix quota could not be set to
  zero

---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e13a154aa4b9..8e3ded1a2cf6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3133,6 +3133,9 @@ static void damos_set_effective_quota(struct damon_ctx *ctx, struct damos *s)
 	if (quota->sz && quota->sz < esz)
 		esz = quota->sz;
 
+	if (!quota->esz_bp)
+		esz = 0;
+
 	quota->esz = esz;
 }
 
-- 
2.55.0


