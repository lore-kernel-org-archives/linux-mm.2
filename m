Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80E3AC624CF
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 10:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F6B46B008C; Tue,  1 Sep 2026 06:59:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A7BB6B00B8; Tue,  1 Sep 2026 06:59:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 596CD6B00BA; Tue,  1 Sep 2026 06:59:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FF856B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:59:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5EEC160329
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:59:46 +0000 (UTC)
X-FDA: 85164897972.03.6A25386
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0484B180002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:59:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="iK3pD/73";
	spf=pass (imf16.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788260385;
	b=SmHMVPXIzQLx74Obp35Mp2JxvTPxEN0w6iprbUnf1x3/vEXL1J8TBQzq/9incydw5xXV2J
	6q2QfM59ngWpRrmQdYOnXz2m3ySC+kITWfjZp0TQOdpXqBoRTs8iy/T3mWk3fYgldDmbgU
	ayRl9cyF5sRpAt3H3TNd4lZ/J+Cn+2I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="iK3pD/73";
	spf=pass (imf16.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788260385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5kRAIEtptDuoDIWPjplgkKnNy7su8uVe41K8WELHNS0=;
	b=jAsOmcNGggRRRguVEnQmaWBxPdt56fmbB4h3SzCdJflCEQf82IZa64QYjyPped1Me8yPJY
	U77Mq2XoaMkrUF5QerMlBWI1yRKCbATEc9Cb+YgH2bYKRwyj93oL0coSf2/STEyGcME3g8
	cGHEZfq98C3BgdezAsVy50vanXfrVEs=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-395cf2535acso1035444a91.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 03:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788260384; x=1788865184; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5kRAIEtptDuoDIWPjplgkKnNy7su8uVe41K8WELHNS0=;
        b=iK3pD/73OUy9j6cUCOFSuVSN0SrgAV/2EWjwsp4vNfweicmuOVAGYPTySyv8ad3143
         Bnfg9d41BI9qVOohDHaxc2QTfD9j5K3ADtKJSlyvdsEZF9e/QSQm8cRcNLpq8MJRL0cq
         4EU1NFV7f91Qe5/KZxSEKDjUhPRiSBaLavKqzd+NIstz00hLkjQLxnXFi9FCZPkJIj9Y
         y7h3phjhsHYHzK1DNGTqcI4H/jba0rFRndZCNkXHERcW9IkDI03yXBAg/3SvyQ/W4pjQ
         7z83/tiBgqrtgMJSP8SOQ5I3JyQc+P0lk/Jt2lANWuQ/Vj464X0H+pjZwl1xmARuJvCH
         AHMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788260384; x=1788865184;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5kRAIEtptDuoDIWPjplgkKnNy7su8uVe41K8WELHNS0=;
        b=dvub7CJooPygvhssJszxjTQEr4FhKz1WxW7e7FmC/N5pHmemXNT8Nmfknro5v8Pbl1
         x/twNJJ1kyvyyR/IqxT1x8GKKw3n1CJYhIn6y+xD1VOYSVYtWcZUm4n6zoLMYoEolRdE
         W07b0ovUXB7jWgIttCPcSWd8TIkvrwGZRGeaFnnc8fxOpkr4SS6V0XkSUHgOf2Z7vr+v
         Bqtp7LYdwQCQzfKH3887iWurUFEtGFh1r64AMTY88ezEpiN/G15dyJL0NNYeOS6HJdMR
         jzTtu6GjWtPXW+ivO2MoHzlmFAkxdxN9RsZi6XEza6lcjVZ6x1aNFnKhi/Kle63wdhQe
         Mxvw==
X-Forwarded-Encrypted: i=1; AKwUvByySJbrJVxnqfF2Cbzj5hz5gOwhwIIykpbz2srTxxYYF5EPX2WNcwVJMglXB0cE8ztoQZzwyfcIRw==@kvack.org
X-Gm-Message-State: AFuF++m201bpmxOZIfiRYGMaKxaceplYN0fnbutAUd77lQER4hG/Kg5q
	FvW+tuV/EN1h00eFSDz6QORbgMW3urvutPC4qr0JoyICVgNa9brpaYnhLNs/4g==
X-Gm-Gg: AYBFou1UTmmXK7SziP05x/19Zy27hHbAdL49CZTNnGBf8+XSgUnmVV7E5lrxMkHqUfo
	CWizlKEr2K8mU1RQaD99PmW4GM3jwGQypQ6dftTbp08HwSsbBVWQ2cpjnAygxDSwW1SJdWhO9IZ
	kKcax1OlYF6osn27Oivd+mJl58X0s1CxmZKMYbAZfUcRwFA77D0OAz7wgGK+usP4wjtrrG6YIjm
	wLrkZshDO76KNPUASXxgid3EIY/N61i5THnlaM7HA+VwRM+dlSGK9ps++zDRWaE7aYG+IPenop2
	7RDImp0CTZzJUtJnduljXYxPo8pIm4DJXhCuFaeC2TpWDDHj4JFbJNKhrjKH7VOnFyYZ428RQHE
	ebcgaon78i7FCTdkhHF/JOQeqMl6YycX2Se+PPoWMFE684XEq0ThfbOfohVm3hloafEUut+DCZP
	/oR/NcvRhuAeEAyJvt38FqAIlhudT25LGpyfECv1afiHEfeWZ3JgbTwU2eAn0Vy9ei
X-Received: by 2002:a17:90b:4a01:b0:398:c6e8:3fc2 with SMTP id 98e67ed59e1d1-3990f772f5emr3422761a91.4.1788260383779;
        Tue, 01 Sep 2026 03:59:43 -0700 (PDT)
Received: from celestia ([2402:1980:9c5:2de5:8b4e:3f3c:b637:4ca5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990d499811sm6303184a91.10.2026.09.01.03.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 03:59:43 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/damon/core: fix quota could not be set to zero
Date: Tue,  1 Sep 2026 18:59:51 +0800
Message-ID: <20260901105951.106246-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0484B180002
X-Stat-Signature: ohqfg49g6556gtfny8yxirg435gc3n4r
X-HE-Tag: 1788260384-991678
X-HE-Meta: U2FsdGVkX1+1Ezh0O+QYefiEzw0Nr/oEuPZcm2/LNTThDrVX8qLsIAEMLfHptdG0iWGOK5ScnrEX8D2Qll9+xce7nS8ogIejpEyLxTosraF1bfW61ihmXDMxb6/thfVnFqP3yMfYXzK/nbj7A16zEcyOuB2d/LNykCU5LXdd8AiLCzrBdaywgFR2TivXwNstg0HgQei8bBSitbJ+EkrKH72+TPveOiSoJa08CmLRx0SVn7Drw2N+8JvgFr97XLgNrr5QTCGNMyLjQIQauCFaB8tVSf8UyKJcMOnzy51jF/EtjTtkS3/E400wM+WKhYBWcHWNmpPl2ISbEFBZ2ZAx0WWVt5fTpFWyv1LBlPEuckmvvrMue1LHhQOFKJzpGcBEXwLTIhNBZMjJbDTjxA+/d759tz2O1bSh9FPBX1zOPnGg4xmcsheNOTtodIPUfrxwU7LV93fIldwpIVslxgWVHYRVVZFXxJ1taFFUew8bIy9sgNdy/YrZ1RW2nEvCo8LKyejSuRlDPWeqyYUr9Qzwk61DguVHlEOdfp+6hNlyBlUngAVj6gzAvNKa+/NtvnPErG23sZJGoPn0oOON2QItc/9fbQBjKdi5nUuNErxcWF1U+koo8B++ClGQz27apmijY51BjYwYDtzHOBPkQh+f2pYPJu0vTVQZSMcpSH6RIl2QZ8ApyXTwDk3mevzlCVUsD547IWQOX7UJ7yPY2ju+gcy/JQcfmCW96candEHMNNZ9nVvrGfW0Lc707MgYbyqvEKufMWsJZA1xKC1Eida8pYPKYOkk09LAjcWLWZpU8/8iNb5OpJ3YnFgNbfxe7SNbdkvtgS9lPkDtrYw9FYSgbuN94mHNYIHGvNx/2y5SRXqWBrjCvYwmLii21k2THjmumJ3IvWOF9z6gwe8s3Dxq0e++s3BYUvanE4SvCf2TUNph1yti6jF1+cyXINemNx5TofqOgDL8n9LzK/zXONF
 6fCZfgu+
 3hONgxN71OcPKt0rF/Q8ppTIi4Qcffg05GyWnIRrNDCYfl/fRsCK/cqPZjk5axescvAQTDsRiiYRX+p5DOpy2BI1G9LvVlqEWIP7v43vRFo/2dB2VS4NSgkyqxLf1AI4MpPbkjvXLf7vXkSbl/bDlkSxGnLYhPcrqOvrPwgizMswbMyaOleSzcCKhZ4Q4sWI7CW8EasXLf/tcEhP55XJz+oIV70Dsbxr1bS/0auyL+imsMabtYIiIXKaIeLkLi++XCtJDOPd6sUgRDkhfqIxLxwMojsT+OZ+lScXaZNv3T0v4b/bAkLw48sfsFUrLSi/uKGLsffxu2H1w/MUR39To3YCpAyZvmuy6xmubZFrrA2GmhwxnppU8cuBv+OOZTHek+AYiCTPkTgQMX15wnK9c6dJasVFm+OKZTqOKc/ILXF8JHmlpdhhCAQdknOZuIT1t2O5v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the temporal quota goal tuner determines that the goal has been
achieved (score >= 10000), it sets esz_bp to zero so that the effective
quota becomes error.  However, damos_set_effective_quota()
unconditionally clamps the quota to min_region_sz, preventing the quota
from ever reaching zero.

Fix this by skip the min_region_sz clamping when esz is already zero so
that the temporal tuner's intent is respected.

Fixes: 8bbde987c2b8 ("mm/damon/core: disallow time-quota setting zero esz")
Cc: <stable@vger.kernel.org> # v7.1.x
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 mm/damon/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 53cf32f1d515..0258769b8727 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3114,7 +3114,8 @@ static void damos_set_effective_quota(struct damon_ctx *ctx, struct damos *s)
 		else
 			throughput = PAGE_SIZE * 1024;
 		esz = min(throughput * quota->ms, esz);
-		esz = max(ctx->min_region_sz, esz);
+		if (esz)
+			esz = max(ctx->min_region_sz, esz);
 	}
 
 	if (quota->sz && quota->sz < esz)
-- 
2.55.0


